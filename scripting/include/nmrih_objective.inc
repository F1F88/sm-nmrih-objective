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
 * Inspired by: https://github.com/dysphie/nmo-guard
 */

/**
 * CNMRiH_Objective
 * A map objective, used in conjunction with CObjectiveManager
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

    public native void GetName(char[] buffer, int maxlen);

    public native void GetDescription(char[] buffer, int maxlen);

    public native int GetEntity(int index);

    public native int GetEntityCount();

    public native int GetLink(int index);

    public native int GetLinkCount();

    public native bool IsEndObjective();

    public native bool IsAntiObjective();

    /**
     * Returns name of the current objective boundary.
     */
    public native void GetObjectiveBoundaryName(char[] buffer, int maxlen);

    /**
     * Returns entity handle to current objective boundary.
     */
    public native ObjectiveBoundary GetObjectiveBoundary();
}


/**
 * CNMRiH_ObjectiveBoundary
 */
methodmap ObjectiveBoundary < AddressBase
{
    public ObjectiveBoundary(Address addr)
    {
        return view_as<ObjectiveBoundary>(addr);
    }

    // TODO windows sig
	// public native void Start();

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
     */
    public native void CompleteCurrentObjective(const char[] targetname);

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
     */
    public native Objective GetObjectiveById(int id);

    /**
     * Returns objective instance by index.
     *
     * @error       Invalid index.
     */
    public native Objective GetObjectiveByIndex(int index);

    /**
     * Returns objective instance by name.
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
     */
    public native bool IsCompleted();

    /**
     * Returns true if objectives failed.
     */
    public native bool IsFailed();

    /**
     * Starts next objective on the chain.
     */
	public native void StartNextObjective();
}
