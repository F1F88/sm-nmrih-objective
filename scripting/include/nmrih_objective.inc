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
     * @param buffer The buffer to store the name in.
     * @param maxlen The maximum length of the buffer.
     * @return The number of bytes written to the buffer, or 0 if there is no name.
     */
    public native void GetName(char[] buffer, int maxlen);

    /**
     * GetDescription returns the description of this objective, or "" if there is none.
     *
     * @param buffer The buffer to store the description in.
     * @param maxlen The maximum length of the buffer.
     * @return The number of bytes written to the buffer, or 0 if there is no description.
     */
    public native void GetDescription(char[] buffer, int maxlen);

    public native int GetEntity(int index);

    public native int GetEntityCount();

    // TODO
    /**
     * GetEntity returns the name and index of an entity in this objective's list by its index in the list, or "" and -1 if there is none.
     * @param index The index of the entity in the list, starting from 0.
     * @param buffer The buffer to store the name of the entity in.
     * @param maxlen The maximum length of the buffer.
     * @return The index of the entity in the game world, or -1 if there is no such entity.
     */
    // public native ArrayList GetEntityList();

    // TODO
    /**
     * HasLink returns true if this objective has a link with the given id, false otherwise.
     * @param linkId The id of the link to check for.
     * @return A bool value indicating if this objective has the link.
     */
    // public native bool HasLink(int linkId);

    /**
     * GetLink returns the id of a link in this objective's list by its index in the list, or -1 if there is none.
     * A link is an id that connects two objectives together and defines how they are related.
     * For example, a link can indicate that an objective must be completed before another one can start, or that an objective is optional, etc.
     *
     * @param index The index of the link in the list, starting from 0.
     * @return The id of the link, or -1 if there is no such link.
     */
    public native int GetLink(int index);

    public native int GetLinkCount();

    /**
     * IsEndObjective returns true if this objective is the last one in the mission, false otherwise.
     * @return A bool value indicating if this objective is the end objective.
     */
    public native bool IsEndObjective();

    public native bool IsAntiObjective();

    /**
     * Returns name of the current objective boundary.
     */
    public native void GetObjectiveBoundaryName(char[] buffer, int maxlen);

    /**
     * Returns entity handle to current objective boundary.
     *
     * GetObjectiveBoundary returns the ObjectiveBoundary object of this objective, or null if there is none.
     * @return An ObjectiveBoundary object or null.
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
     * Completes current objective, with targetname parameter of forced extraction zone.
     *
     * CompleteCurrentObjective completes the current objective and optionally sets a forced extraction zone.
     * @param targetname    (forcedExtractZone) The name of the extraction zone to use, or "" for none.
     */
    public native void CompleteCurrentObjective(const char[] targetname = NULL_STRING);

    /**
     * Returns the ObjectiveBoundary object of the current objective, or null if there is none.
     * @return An ObjectiveBoundary object or null.
     */
    // #pragma deprecated See: https:\/\/github.com/nmrih/source-game/issues/1495
    // public ObjectiveBoundary GetCurrentObjectiveBoundary()
    // {
    //     Objective currentObjective = this.GetCurrentObjective();
    //     return currentObjective.GetObjectiveBoundary();
    // }

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
    public Objective GetCurrentObjective()
    {
        // 参考自 CNMRiH_ObjectiveManager::ScriptGetObjectiveByIndex 的逆向
        int index = this._iCurrentObjectiveIndex;
        int len = this._iObjectivesCount;
        if (index < 0 || index >= len)
        {
            ThrowError("Invalid objective index (%d) [0-%d].", index, len);
        }

        UtlVector chain = this._pObjectiveChainVector;
        if (chain.addr == Address_Null)
        {
            ThrowError("Invalid objective chain instance.");
        }

        Objective result = chain.Get(index);
        if (result.addr == Address_Null)
        {
            ThrowError("Invalid objective instance.");
        }
        return result;
    }

    /**
     * Returns current objective index.
     */
    public native int GetCurrentObjectiveIndex();

    /**
     * Returns objective instance by ID.
     *
     * GetObjectiveById returns the Objective object with the given id, or null if there is none.
     * @return An Objective object or null.
     * @param id The id of the objective to get.
     */
    public native Objective GetObjectiveById(int id);

    /**
     * Returns objective instance by index.
     *
     * GetObjectiveByIndex returns the Objective object at the given index in the objective list, or null if there is none.
     * @param index The index of the objective to get, starting from 0.
     * @return An Objective object or null.
     * @error       Invalid index.
     */
    public native Objective GetObjectiveByIndex(int index);

    /**
     * Returns objective instance by name.
     *
     * GetObjectiveByName returns the Objective object with the given name, or null if there is none.
     * @param name The name of the objective to get.
     * @return An Objective object or null.
     */
    public native Objective GetObjectiveByName(const char[] name);

    /**
     * Fills array with current objective chain.
     *
     * @note The ArrayList element type is Objective.
     * @note 实际返回的 ArrayList 元素个数可能是 GetObjectiveChainCount - 1
     */
    public native ArrayList GetObjectiveChain();

    /**
     * Returns current objective chain element count.
     *
     * @note 可能还包含一个撤离任务, 总之无法将最后一个 id 转换成对应的 objective,
     *       所以 chain ArrayList 中的元素会缺少这一个.
     */
    public native int GetObjectiveChainCount();

    /**
     * Returns total objective count.
     */
    public native int GetObjectiveCount();

    /**
     * Returns true if objectives are complete.
     *
     * IsCompleted returns true if all the objectives are completed, false otherwise.
     * @return A bool value indicating if all the objectives are completed.
     */
    public native bool IsCompleted();

    /**
     * Returns true if objectives failed.
     *
     * IsFailed returns true if any of the objectives are failed, false otherwise.
     * @return A bool value indicating if any of the objectives are failed.
     */
    public native bool IsFailed();

    /**
     * Starts next objective on the chain.
     *
     * StartNextObjective starts the next objective in the list, if there is any.
     */
	public native void StartNextObjective();

    // TODO
    /**
     * UpdateObjectiveBoundaries updates the boundaries of all the objectives based on their entities and links.
     */
    // public static native void UpdateObjectiveBoundaries();
}
