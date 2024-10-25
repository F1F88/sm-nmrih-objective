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

    property UtlVector _pEntitysVector
    {
        public native get();
    }

    property int _iEntitysCount
    {
        public native get();
    }

    property UtlVector _pLinksVector
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
     * GetName returns the name of this objective, or "" if there is none.
     *
     * @param buffer    The buffer to store the name in.
     * @param maxlen    The maximum length of the buffer.
     * @return          The number of bytes written to the buffer, or 0 if there is no name.
     * @error           Invalid Objective addr.
     */
    public native int GetName(char[] buffer, int maxlen);

    /**
     * GetDescription returns the description of this objective, or "" if there is none.
     *
     * @param buffer    The buffer to store the description in.
     * @param maxlen    The maximum length of the buffer.
     * @return          The number of bytes written to the buffer, or 0 if there is no description.
     * @error           Invalid Objective addr.
     */
    public native int GetDescription(char[] buffer, int maxlen);

    /**
     * GetEntity returns the index of an entity in this objective's list by its index in the list, or -1 if there is none.
     *
     * @param index     The index of the entity in the list, starting from 0.
     * @return          The index of the entity in the game world, or -1 if there is no such entity.
     */
    public native int GetEntity(int index);

    public native int GetEntityCount();

    // TODO
    // public native ArrayList GetEntityList();

    // TODO
    /**
     * HasLink returns true if this objective has a link with the given id, false otherwise.
     * @param linkId    The id of the link to check for.
     * @return          A bool value indicating if this objective has the link.
     */
    // public native bool HasLink(int linkId);

    /**
     * GetLink returns the id of a link in this objective's list by its index in the list, or -1 if there is none.
     * A link is an id that connects two objectives together and defines how they are related.
     * For example, a link can indicate that an objective must be completed before another one can start, or that an objective is optional, etc.
     *
     * @param index     The index of the link in the list, starting from 0.
     * @return          The id of the link, or -1 if there is no such link.
     * @error           Invalid Objective addr or index out of bounds.
     */
    public native int GetLink(int index);

    public native int GetLinkCount();

    /**
     * IsEndObjective returns true if this objective is the last one in the mission, false otherwise.
     *
     * @return          A bool value indicating if this objective is the end objective.
     * @error           Invalid Objective addr.
     */
    public native bool IsEndObjective();

    public native bool IsAntiObjective();

    /**
     * Returns name of the current objective boundary, or "" if there is none.
     *
     * @param buffer    The buffer to store the name in.
     * @param maxlen    The maximum length of the buffer.
     * @return          The number of bytes written to the buffer, or 0 if there is no name.
     * @error           Invalid Objective addr.
     */
    public native int GetObjectiveBoundaryName(char[] buffer, int maxlen);

    /**
     * GetObjectiveBoundary returns the ObjectiveBoundary object of this objective, or null if there is none.
     *
     * @return          An ObjectiveBoundary object or null.
     * @error           Invalid Objective addr.
     */
    public native ObjectiveBoundary GetObjectiveBoundary();

    // TODO
    /**
     * UpdateBoundary updates the boundary of this objective based on its entities and links.
     */
    // public native void UpdateBoundary();
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

    // TODO windows sig
    /**
     * Finish finishes the boundary and removes any effects or markers associated with it.
     */
	// public native void Start();

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

    /**
     * @note element type is Objective object address.
     */
    property UtlVector _pObjectivesVector
    {
        public native get();
    }

    property int _iObjectivesCount
    {
        public native get();
    }

    /**
     * @note element type is objective id.
     */
    property UtlVector _pObjectiveChainVector
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
     * CompleteCurrentObjective completes the current objective and optionally sets a forced extraction zone (forcedExtractZone).
     *
     * @param targetname    The name of the extraction zone to use, or "" for none.
     */
    public static native void CompleteCurrentObjective(const char[] targetname = NULL_STRING);

    /**
     * Returns the ObjectiveBoundary object of the current objective, or null if there is none.
     *
     * @note                由于官方移除了这个接口，不保证未来游戏更新后这个 native 仍正常工作
     *
     * @return              An ObjectiveBoundary object or null.
     */
    #pragma deprecated See: https:\/\/github.com/nmrih/source-game/issues/1495
    public static native ObjectiveBoundary GetCurrentObjectiveBoundary();

    // TODO
    /**
     * Clear clears all the objectives and resets the ObjectiveManager state.
     */
    // public static native void Clear();

    // TODO
    /**
     * Finish finishes the mission and shows the end screen.
     */
    // public static native void Finish();


    /**
     * Returns current objective instance.
     */
    public static native Objective GetCurrentObjective();

    /**
     * Returns current objective index.
     */
    public static native int GetCurrentObjectiveIndex();

    /**
     * GetObjectiveById returns the Objective object with the given id, or null if there is none.
     *
     * @param id        The id of the objective to get.
     * @return          An Objective object or null.
     */
    public static native Objective GetObjectiveById(int id);

    /**
     * GetObjectiveByIndex returns the Objective object at the given index in the objective list, or null if there is none.
     *
     * @param index     The index of the objective to get, starting from 0.
     * @return          An Objective object or null.
     * @error           Invalid index.
     */
    public static native Objective GetObjectiveByIndex(int index);

    /**
     * GetObjectiveByName returns the Objective object with the given name, or null if there is none.
     *
     * @param name      The name of the objective to get.
     * @return          An Objective object or null.
     */
    public static native Objective GetObjectiveByName(const char[] name);

    /**
     * Fills array with current objective chain.
     *
     * @note            The ArrayList element type is Objective.
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
     * IsCompleted returns true if all the objectives are completed, false otherwise.
     *
     * @return          A bool value indicating if all the objectives are completed.
     */
    public static native bool IsCompleted();

    /**
     * IsFailed returns true if any of the objectives are failed, false otherwise.
     *
     * @return          A bool value indicating if any of the objectives are failed.
     */
    public static native bool IsFailed();

    /**
     * StartNextObjective starts the next objective in the list, if there is any.
     */
	public static native void StartNextObjective();

    // TODO
    /**
     * UpdateObjectiveBoundaries updates the boundaries of all the objectives based on their entities and links.
     */
    // public static native void UpdateObjectiveBoundaries();
}
