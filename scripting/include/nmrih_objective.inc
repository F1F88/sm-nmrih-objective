/** Double-include prevention */
#if defined _nmrih_objective_included_
  #endinput
#endif
#define _nmrih_objective_included_

#pragma newdecls required
#pragma semicolon 1

#include <address_base>
#include <stringt>
#include <utl_vector>

/**
 * Objective is a class that represents an objective of a mission.
 * It can have a name, a description, a list of entities and links, and a boundary.
 */
methodmap Objective < AddressBase
{
    public Objective(Address addr)
    {
        return view_as<Objective>(addr);
    }

    property int m_iId
    {
        public native get();
        public native set(int value);
    }

    property Stringt _sName
    {
        public native get();
    }

    property Stringt _sDescription
    {
        public native get();
    }

    property UtlVector /* <Stringt> */ _pEntitysVector
    {
        public native get();
    }

    property int _iEntitysCount
    {
        public native get();
    }

    property UtlVector /* <int> */ _pLinksVector
    {
        public native get();
    }

    property int _iLinksCount
    {
        public native get();
    }

    property bool _bIsAntiObjective
    {
        public native get();
        public native set(bool value);
    }

    property Stringt _sObjectiveBoundaryName
    {
        public native get();
    }

    public native int GetId();

    /**
     * Gets the objective name.
     *
     * @param buffer    Buffer to store name.
     * @param maxlen    Maximum length of the buffer.
     * @return          Number of bytes written.
     */
    public native int GetName(char[] buffer, int maxlen);

    /**
     * Gets the objective description.
     *
     * @param buffer    Buffer to store description.
     * @param maxlen    Maximum length of the buffer.
     * @return          Number of bytes written.
     */
    public native int GetDescription(char[] buffer, int maxlen);

    public native bool ContainsEntity(int entity);

    /**
     * GetEntity returns the index of an entity in this objective's list by its index in the list, or -1 if there is none.
     *
     * @param index     The index of the entity in the list, starting from 0.
     * @return          The index of the entity in the game world, or -1 if there is no such entity.
     */
    public native int GetEntity(int index);

    public native int GetEntityCount();

    /**
     * Returns an ArrayList filled with `Stringt` instances of the entities' targetname.
     *
     * @note            The array handle must be freed manually.
    */
    public native ArrayList GetEntityList();

    /**
     * Gets whether this objective has a link with the given id.
     *
     * @param linkId    The id of the link to check for.
     * @return          True if this objective has the link, false otherwise.
     */
    public native bool HasLink(int linkId);

    /**
     * Gets the link id by its index.
     *
     * A link is an id that connects two objectives together and defines how they are related.
     * For example, a link can indicate that an objective must be completed before another one can start, or that an objective is optional, etc.
     *
     * @param index     Index in the link ids (starting from 0).
     * @return          The id of the link.
     * @error           Invalid index.
     */
    public native int GetLink(int index);

    public native int GetLinkCount();

    /**
     * Gets whether this objective is the last one in the mission.
     *
     * @return          True if this objective is the end objective, false otherwise.
     */
    public native bool IsEndObjective();

    public native bool IsAntiObjective();

    /**
     * Gets the objective boundary name.
     *
     * @param buffer    Buffer to store objective boundary name.
     * @param maxlen    Maximum length of the buffer.
     * @return          Number of bytes written.
     */
    public native int GetObjectiveBoundaryName(char[] buffer, int maxlen);

    /**
     * Gets the objective boundary.
     *
     * @return          An ObjectiveBoundary object or Address_Null.
     */
    public native ObjectiveBoundary GetObjectiveBoundary();

    /**
     * UpdateBoundary updates the boundary of this objective based on its entities and links.
     */
    public native void UpdateBoundary();
}


/**
 * ObjectiveBoundary is a class that represents a boundary for an objective.
 * It can be a trigger, a marker, a zone or any other entity that defines where an objective takes place.
 */
methodmap ObjectiveBoundary < AddressBase
{
    public ObjectiveBoundary(Address addr)
    {
        return view_as<ObjectiveBoundary>(addr);
    }

    // TODO: add windows signature
    /**
     * Finish finishes the boundary and removes any effects or markers associated with it.
     *
     * @note        Linux only.
     */
	public native void Start();

    /**
     * Start starts the boundary and adds any effects or markers associated with it.
     */
	public native void Finish();
}


/**
 * CNMRiH_ObjectiveManager
 * Interface for objective manager.
 */
methodmap ObjectiveManager < AddressBase
{
    /**
     * return the global singleton ObjectiveManager object.
     *
     * @error       The internal ObjectiveManager address is null.
     */
    public static native ObjectiveManager Instance();

    property UtlVector /* <Objective> */ _pObjectivesVector
    {
        public native get();
    }

    property int _iObjectivesCount
    {
        public native get();
    }

    property UtlVector /* <Objective> */ _pAntiObjectivesVector
    {
        public native get();
    }

    property int _iAntiObjectivesCount
    {
        public native get();
    }

    /**
     * @note element type is objective id.
     */
    property UtlVector /* <int> */ _pObjectiveChainVector
    {
        public native get();
    }

    property int _iObjectiveChainCount
    {
        public native get();
    }

    property bool _bIsCompleted
    {
        public native get();
        public native set(bool value);
    }

    property bool _bIsFailed
    {
        public native get();
        public native set(bool value);
    }

    property int _iCurrentObjectiveIndex
    {
        public native get();
        public native set(int value);
    }

    property Objective _pCurrentObjective
    {
        public native get();
        public native set(Objective value);
    }

    /**
     * Completes the current objective and optionally sets a forced extraction zone (forcedExtractZone).
     *
     * @param targetname    The name of the extraction zone to use, or "" for none.
     */
    public static native void CompleteCurrentObjective(const char[] targetname = NULL_STRING);

    /**
     * Returns the ObjectiveBoundary object of the current objective, or null if there is none.
     *
     * @note                由于官方移除了这个接口，不保证未来游戏更新后这个 native 仍正常工作
     *
     * @return              An ObjectiveBoundary object or Address_Null.
     */
    #pragma deprecated See: https:\/\/github.com/nmrih/source-game/issues/1495
    public static native ObjectiveBoundary GetCurrentObjectiveBoundary();

    /**
     * Clears all the objectives and resets the ObjectiveManager state.
     */
    public static native void Clear();

    // TODO: add windows signature
    /**
     * Finishes the mission and shows the end screen.
     *
     * @note        Linux only.
     */
    public static native void Finish();

    /**
     * Returns current objective instance.
     */
    public static native Objective GetCurrentObjective();

    /**
     * Returns current objective index.
     */
    public static native int GetCurrentObjectiveIndex();

    /**
     * Returns the Objective object with the given id, or null if there is none.
     *
     * @param id        The id of the objective to get.
     * @return          An Objective object or null.
     */
    public static native Objective GetObjectiveById(int id);

    /**
     * Returns the Objective object at the given index in the objective list, or null if there is none.
     *
     * @param index     The index of the objective to get, starting from 0.
     * @return          An Objective object or null.
     * @error           Invalid index.
     */
    public static native Objective GetObjectiveByIndex(int index);

    /**
     * Returns the Objective object with the given name, or null if there is none.
     *
     * @param name      The name of the objective to get.
     * @return          An Objective object or null.
     */
    public static native Objective GetObjectiveByName(const char[] name);

    /**
     * Fills array with current objective chain.
     *
     * @note            The ArrayList element type is Objective.
     * @note            The ArrayList handle must be freed manually.
     * @note            实际返回的 ArrayList 元素个数可能是 GetObjectiveChainCount - 1
     */
    public static native ArrayList GetObjectiveChain();

    /**
     * Returns current objective chain element count.
     *
     * @note            可能还包含一个撤离任务, 总之无法将最后一个 id 转换成对应的 objective,
     *                  所以 chain ArrayList 中的元素会缺少这一个.
     */
    public static native int GetObjectiveChainCount();

    /**
     * Returns total objective count.
     */
    public static native int GetObjectiveCount();

    /**
     * Returns true if all the objectives are completed, false otherwise.
     *
     * @return          A bool value indicating if all the objectives are completed.
     */
    public static native bool IsCompleted();

    /**
     * Returns true if any of the objectives are failed, false otherwise.
     *
     * @return          A bool value indicating if any of the objectives are failed.
     */
    public static native bool IsFailed();

    /**
     * Starts the next objective in the list, if there is any.
     */
	public static native void StartNextObjective();

    /**
     * Updates the boundaries of all the objectives based on their entities and links.
     */
    public static native void UpdateObjectiveBoundaries();

    public static native void FailCurrentObjective();
}
