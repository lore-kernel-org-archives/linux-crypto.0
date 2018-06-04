From: Oliver <oohall@gmail.com>
Subject: Re: [PATCH] crypto/nx: Initialize 842 high and normal RxFIFO control
 registers
Date: Mon, 4 Jun 2018 14:59:23 +1000
Message-ID: <CAOSf1CGKhEuk8Pa2=9sdbr+iq3QV+w3qXoRyjogKvNTghTayWw@mail.gmail.com>
References: <1527789287.5945.23.camel@hbabu-laptop>
 <87h8mn2bta.fsf@linux.vnet.ibm.com>
 <5B117946.8010100@linux.vnet.ibm.com> <87bmcr2xj4.fsf@linux.vnet.ibm.com>
 <5B14A797.2050306@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, herbert@gondor.apana.org.au,
 Stewart Smith <stewart@linux.ibm.com>, linux-crypto@vger.kernel.org
To: Haren Myneni <haren@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <5B14A797.2050306@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 4, 2018 at 12:44 PM, Haren Myneni <haren@linux.vnet.ibm.com> wr=
ote:
> On 06/03/2018 05:41 PM, Stewart Smith wrote:
>> Haren Myneni <haren@linux.vnet.ibm.com> writes:
>>> On 06/01/2018 12:41 AM, Stewart Smith wrote:
>>>> Haren Myneni <haren@linux.vnet.ibm.com> writes:
>>>>> NX increments readOffset by FIFO size in receive FIFO control registe=
r
>>>>> when CRB is read. But the index in RxFIFO has to match with the
>>>>> corresponding entry in FIFO maintained by VAS in kernel. Otherwise NX
>>>>> may be processing incorrect CRBs and can cause CRB timeout.
>>>>>
>>>>> VAS FIFO offset is 0 when the receive window is opened during
>>>>> initialization. When the module is reloaded or in kexec boot, readOff=
set
>>>>> in FIFO control register may not match with VAS entry. This patch add=
s
>>>>> nx_coproc_init OPAL call to reset readOffset and queued entries in FI=
FO
>>>>> control register for both high and normal FIFOs.
>>>>>
>>>>> Signed-off-by: Haren Myneni <haren@us.ibm.com>
>>>>>
>>>>> diff --git a/arch/powerpc/include/asm/opal-api.h b/arch/powerpc/inclu=
de/asm/opal-api.h
>>>>> index d886a5b..ff61e4b 100644
>>>>> --- a/arch/powerpc/include/asm/opal-api.h
>>>>> +++ b/arch/powerpc/include/asm/opal-api.h
>>>>> @@ -206,7 +206,8 @@
>>>>>  #define OPAL_NPU_TL_SET                           161
>>>>>  #define OPAL_PCI_GET_PBCQ_TUNNEL_BAR              164
>>>>>  #define OPAL_PCI_SET_PBCQ_TUNNEL_BAR              165
>>>>> -#define OPAL_LAST                         165
>>>>> +#define   OPAL_NX_COPROC_INIT                     167
>>>>> +#define OPAL_LAST                         167
>>>>>
>>>>>  /* Device tree flags */
>>>>>
>>>>> diff --git a/arch/powerpc/include/asm/opal.h b/arch/powerpc/include/a=
sm/opal.h
>>>>> index 7159e1a..d79eb82 100644
>>>>> --- a/arch/powerpc/include/asm/opal.h
>>>>> +++ b/arch/powerpc/include/asm/opal.h
>>>>> @@ -288,6 +288,7 @@ int64_t opal_imc_counters_init(uint32_t type, uin=
t64_t address,
>>>>>  int opal_get_power_shift_ratio(u32 handle, int token, u32 *psr);
>>>>>  int opal_set_power_shift_ratio(u32 handle, int token, u32 psr);
>>>>>  int opal_sensor_group_clear(u32 group_hndl, int token);
>>>>> +int opal_nx_coproc_init(uint32_t chip_id, uint32_t ct);
>>>>>
>>>>>  s64 opal_signal_system_reset(s32 cpu);
>>>>>
>>>>> diff --git a/arch/powerpc/platforms/powernv/opal-wrappers.S b/arch/po=
werpc/platforms/powernv/opal-wrappers.S
>>>>> index 3da30c2..c7541a9 100644
>>>>> --- a/arch/powerpc/platforms/powernv/opal-wrappers.S
>>>>> +++ b/arch/powerpc/platforms/powernv/opal-wrappers.S
>>>>> @@ -325,3 +325,4 @@ OPAL_CALL(opal_npu_spa_clear_cache,            OP=
AL_NPU_SPA_CLEAR_CACHE);
>>>>>  OPAL_CALL(opal_npu_tl_set,                        OPAL_NPU_TL_SET);
>>>>>  OPAL_CALL(opal_pci_get_pbcq_tunnel_bar,           OPAL_PCI_GET_PBCQ_=
TUNNEL_BAR);
>>>>>  OPAL_CALL(opal_pci_set_pbcq_tunnel_bar,           OPAL_PCI_SET_PBCQ_=
TUNNEL_BAR);
>>>>> +OPAL_CALL(opal_nx_coproc_init,                    OPAL_NX_COPROC_INI=
T);
>>>>> diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/pla=
tforms/powernv/opal.c
>>>>> index 48fbb41..5e13908 100644
>>>>> --- a/arch/powerpc/platforms/powernv/opal.c
>>>>> +++ b/arch/powerpc/platforms/powernv/opal.c
>>>>> @@ -1035,3 +1035,5 @@ void powernv_set_nmmu_ptcr(unsigned long ptcr)
>>>>>  EXPORT_SYMBOL_GPL(opal_int_set_mfrr);
>>>>>  EXPORT_SYMBOL_GPL(opal_int_eoi);
>>>>>  EXPORT_SYMBOL_GPL(opal_error_code);
>>>>> +/* Export the below symbol for NX compression */
>>>>> +EXPORT_SYMBOL(opal_nx_coproc_init);
>>>>> diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/n=
x-842-powernv.c
>>>>> index 1e87637..6c4784d 100644
>>>>> --- a/drivers/crypto/nx/nx-842-powernv.c
>>>>> +++ b/drivers/crypto/nx/nx-842-powernv.c
>>>>> @@ -24,6 +24,8 @@
>>>>>  #include <asm/icswx.h>
>>>>>  #include <asm/vas.h>
>>>>>  #include <asm/reg.h>
>>>>> +#include <asm/opal-api.h>
>>>>> +#include <asm/opal.h>
>>>>>
>>>>>  MODULE_LICENSE("GPL");
>>>>>  MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
>>>>> @@ -803,9 +805,26 @@ static int __init vas_cfg_coproc_info(struct dev=
ice_node *dn, int chip_id,
>>>>>    if (!coproc)
>>>>>            return -ENOMEM;
>>>>>
>>>>> -  if (!strcmp(priority, "High"))
>>>>> +  if (!strcmp(priority, "High")) {
>>>>> +          /*
>>>>> +           * (lpid, pid, tid) combination has to be unique for each
>>>>> +           * coprocessor instance in the system. So to make it
>>>>> +           * unique, skiboot uses coprocessor type such as 842 or
>>>>> +           * GZIP for pid and provides this value to kernel in pid
>>>>> +           * device-tree property.
>>>>> +           *
>>>>> +           * Initialize each NX instance for both high and normal
>>>>> +           * priority FIFOs.
>>>>> +           */
>>>>> +          ret =3D opal_nx_coproc_init(chip_id, pid);
>>>>> +          if (ret) {
>>>>> +                  pr_err("Failed to initialize NX coproc: %d\n", ret=
);
>>>>> +                  ret =3D opal_error_code(ret);
>>>>> +                  goto err_out;
>>>>> +          }
>>>>> +
>>>>>            coproc->ct =3D VAS_COP_TYPE_842_HIPRI;
>>>>
>>>> I think this should be called for all priority queues as it would be a=
t
>>>> least theoretically possible to only have Normal priority queues, in
>>>> which case this patch wouldn't fix the problem.
>>>
>>> device tree exports separate nodes for high and normal priority FIFOs
>>> per each NX instance. But NX init OPAL function is called once per
>>> each NX instance when high-FIFO device node is parsed to reset high
>>> and normal FIFO control registers. As you see in skiboot patch, resets
>>> both priority registers. Thought we should minimize the number of OPAL
>>> calla execution and also should have generic NX init OPAL call. We can
>>> extend this call to reset default values for any other registers if
>>> needed.
>>
>> This code does'nt do that though, it calls it for "high" priority, so if
>> for whatever reason there was a DT without a "High" priority node there,
>> it'd not call it.
>
> Skiboot exports high and normal FIFO nodes for each coprocessor type per =
NX instance. We will never see only normal FIFO node without high FIFO node=
. As we see in skiboot code, configure high FIFO and export this node first=
, and then normal FIFO. In case if xscom read/ write for high FIFO failed, =
we do not proceed for normal FIFO.
>
> Also, we use only high priority FIFOs in kernel (nx-842). Normal FIFOs ar=
e reserved only for user space use (NX GZIP in future).
>
> So we will not get in to the case that you described. Normal FIFO DT node=
 will be available only with high FIFO node per each NX instance.

This is infuriating to read.

OPAL is an API that Skiboot happens to implement. It's like that so
that we can change the behaviour of skiboot (to work around bugs,
implement new features, or whatever)  without breaking the existing
kernels that use that API. Trying to argue that this is OK because it
works with the *current* behaviour of skiboot misses the point
entirely.

>>> If you prefer calling separately based on priority, we can have
>>> opal_nx_coproc_FIFO_init(chip_id, pid, priority). Please let me know.
>>
>> I think the call is okay, it's just that if it needs to be called once
>> per accellerator, then we should ensure it does that.
>>
>
