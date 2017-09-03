From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH V3 6/6] crypto/nx: Add P9 NX support for 842 compression engine
Date: Sun, 3 Sep 2017 10:12:24 -0400
Message-ID: <CALZtONCA20nRcWVO8Hc+sGyV0Vw-j6Rjgn6D9yfuZfgAKggxjg@mail.gmail.com>
References: <1500699702.23205.8.camel@hbabu-laptop> <CALZtONBGVQy2iwkb8WpVd-_QG7bLFTvUbnuub6CCXP55YpQiSQ@mail.gmail.com>
 <59AA6E71.8070704@linux.vnet.ibm.com> <CALZtONB3sUTtxOeQqRpSqHs2yGP-uOusBNM5y2LT3wzCNOp+2A@mail.gmail.com>
 <59ABBE0B.8020301@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Michael Neuling <mikey@neuling.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ram Pai <linuxram@us.ibm.com>, npiggin@gmail.com,
        suka@us.ibm.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: Haren Myneni <haren@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33589 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752913AbdICONG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Sep 2017 10:13:06 -0400
Received: by mail-it0-f67.google.com with SMTP id 77so1961253itj.0
        for <linux-crypto@vger.kernel.org>; Sun, 03 Sep 2017 07:13:06 -0700 (PDT)
In-Reply-To: <59ABBE0B.8020301@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Sep 3, 2017 at 4:32 AM, Haren Myneni <haren@linux.vnet.ibm.com> wro=
te:
> On 09/02/2017 09:17 AM, Dan Streetman wrote:
>> On Sat, Sep 2, 2017 at 4:40 AM, Haren Myneni <haren@linux.vnet.ibm.com> =
wrote:
>>> On 08/29/2017 06:58 AM, Dan Streetman wrote:
>>>> On Sat, Jul 22, 2017 at 1:01 AM, Haren Myneni <haren@linux.vnet.ibm.co=
m> wrote:
>>>>>
>>>>> This patch adds P9 NX support for 842 compression engine. Virtual
>>>>> Accelerator Switchboard (VAS) is used to access 842 engine on P9.
>>>>>
>>>>> For each NX engine per chip, setup receive window using
>>>>> vas_rx_win_open() which configures RxFIFo with FIFO address, lpid,
>>>>> pid and tid values. This unique (lpid, pid, tid) combination will
>>>>> be used to identify the target engine.
>>>>>
>>>>> For crypto open request, open send window on the NX engine for
>>>>> the corresponding chip / cpu where the open request is executed.
>>>>> This send window will be closed upon crypto close request.
>>>>>
>>>>> NX provides high and normal priority FIFOs. For compression /
>>>>> decompression requests, we use only hight priority FIFOs in kernel.
>>>>>
>>>>> Each NX request will be communicated to VAS using copy/paste
>>>>> instructions with vas_copy_crb() / vas_paste_crb() functions.
>>>>>
>>>>> Signed-off-by: Haren Myneni <haren@us.ibm.com>
>>>>> ---
>>>>>  drivers/crypto/nx/Kconfig          |   1 +
>>>>>  drivers/crypto/nx/nx-842-powernv.c | 375 +++++++++++++++++++++++++++=
+++++++++-
>>>>>  drivers/crypto/nx/nx-842.c         |   2 +-
>>>>>  3 files changed, 371 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/drivers/crypto/nx/Kconfig b/drivers/crypto/nx/Kconfig
>>>>> index ad7552a6998c..cd5dda9c48f4 100644
>>>>> --- a/drivers/crypto/nx/Kconfig
>>>>> +++ b/drivers/crypto/nx/Kconfig
>>>>> @@ -38,6 +38,7 @@ config CRYPTO_DEV_NX_COMPRESS_PSERIES
>>>>>  config CRYPTO_DEV_NX_COMPRESS_POWERNV
>>>>>         tristate "Compression acceleration support on PowerNV platfor=
m"
>>>>>         depends on PPC_POWERNV
>>>>> +       depends on PPC_VAS
>>>>>         default y
>>>>>         help
>>>>>           Support for PowerPC Nest (NX) compression acceleration. Thi=
s
>>>>> diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/n=
x-842-powernv.c
>>>>> index c0dd4c7e17d3..13089a0b9dfa 100644
>>>>> --- a/drivers/crypto/nx/nx-842-powernv.c
>>>>> +++ b/drivers/crypto/nx/nx-842-powernv.c
>>>>> @@ -23,6 +23,7 @@
>>>>>  #include <asm/prom.h>
>>>>>  #include <asm/icswx.h>
>>>>>  #include <asm/vas.h>
>>>>> +#include <asm/reg.h>
>>>>>
>>>>>  MODULE_LICENSE("GPL");
>>>>>  MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
>>>>> @@ -32,6 +33,9 @@ MODULE_ALIAS_CRYPTO("842-nx");
>>>>>
>>>>>  #define WORKMEM_ALIGN  (CRB_ALIGN)
>>>>>  #define CSB_WAIT_MAX   (5000) /* ms */
>>>>> +#define VAS_RETRIES    (10)
>>>>> +/* # of requests allowed per RxFIFO at a time. 0 for unlimited */
>>>>> +#define MAX_CREDITS_PER_RXFIFO (1024)
>>>>>
>>>>>  struct nx842_workmem {
>>>>>         /* Below fields must be properly aligned */
>>>>> @@ -42,16 +46,27 @@ struct nx842_workmem {
>>>>>
>>>>>         ktime_t start;
>>>>>
>>>>> +       struct vas_window *txwin;       /* Used with VAS function */
>>>>>         char padding[WORKMEM_ALIGN]; /* unused, to allow alignment */
>>>>>  } __packed __aligned(WORKMEM_ALIGN);
>>>>>
>>>>>  struct nx842_coproc {
>>>>>         unsigned int chip_id;
>>>>>         unsigned int ct;
>>>>> -       unsigned int ci;
>>>>> +       unsigned int ci;        /* Coprocessor instance, used with ic=
swx */
>>>>> +       struct {
>>>>> +               struct vas_window *rxwin;
>>>>> +               int id;
>>>>> +       } vas;
>>>>>         struct list_head list;
>>>>>  };
>>>>>
>>>>> +/*
>>>>> + * Send the request to NX engine on the chip for the corresponding C=
PU
>>>>> + * where the process is executing. Use with VAS function.
>>>>> + */
>>>>> +static DEFINE_PER_CPU(struct nx842_coproc *, coproc_inst);
>>>>> +
>>>>>  /* no cpu hotplug on powernv, so this list never changes after init =
*/
>>>>>  static LIST_HEAD(nx842_coprocs);
>>>>>  static unsigned int nx842_ct;  /* used in icswx function */
>>>>> @@ -513,6 +528,105 @@ static int nx842_exec_icswx(const unsigned char=
 *in, unsigned int inlen,
>>>>>  }
>>>>>
>>>>>  /**
>>>>> + * nx842_exec_vas - compress/decompress data using the 842 algorithm
>>>>> + *
>>>>> + * (De)compression provided by the NX842 coprocessor on IBM PowerNV =
systems.
>>>>> + * This compresses or decompresses the provided input buffer into th=
e provided
>>>>> + * output buffer.
>>>>> + *
>>>>> + * Upon return from this function @outlen contains the length of the
>>>>> + * output data.  If there is an error then @outlen will be 0 and an
>>>>> + * error will be specified by the return code from this function.
>>>>> + *
>>>>> + * The @workmem buffer should only be used by one function call at a=
 time.
>>>>> + *
>>>>> + * @in: input buffer pointer
>>>>> + * @inlen: input buffer size
>>>>> + * @out: output buffer pointer
>>>>> + * @outlenp: output buffer size pointer
>>>>> + * @workmem: working memory buffer pointer, size determined by
>>>>> + *           nx842_powernv_driver.workmem_size
>>>>> + * @fc: function code, see CCW Function Codes in nx-842.h
>>>>> + *
>>>>> + * Returns:
>>>>> + *   0         Success, output of length @outlenp stored in the buff=
er
>>>>> + *             at @out
>>>>> + *   -ENODEV   Hardware unavailable
>>>>> + *   -ENOSPC   Output buffer is to small
>>>>> + *   -EMSGSIZE Input buffer too large
>>>>> + *   -EINVAL   buffer constraints do not fix nx842_constraints
>>>>> + *   -EPROTO   hardware error during operation
>>>>> + *   -ETIMEDOUT        hardware did not complete operation in reason=
able time
>>>>> + *   -EINTR    operation was aborted
>>>>> + */
>>>>> +static int nx842_exec_vas(const unsigned char *in, unsigned int inle=
n,
>>>>> +                                 unsigned char *out, unsigned int *o=
utlenp,
>>>>> +                                 void *workmem, int fc)
>>>>> +{
>>>>> +       struct coprocessor_request_block *crb;
>>>>> +       struct coprocessor_status_block *csb;
>>>>> +       struct nx842_workmem *wmem;
>>>>> +       struct vas_window *txwin;
>>>>> +       int ret, i =3D 0;
>>>>> +       u32 ccw;
>>>>> +       unsigned int outlen =3D *outlenp;
>>>>> +
>>>>> +       wmem =3D PTR_ALIGN(workmem, WORKMEM_ALIGN);
>>>>> +
>>>>> +       *outlenp =3D 0;
>>>>> +
>>>>> +       crb =3D &wmem->crb;
>>>>> +       csb =3D &crb->csb;
>>>>> +
>>>>> +       ret =3D nx842_config_crb(in, inlen, out, outlen, wmem);
>>>>> +       if (ret)
>>>>> +               return ret;
>>>>> +
>>>>> +       ccw =3D 0;
>>>>> +       ccw =3D SET_FIELD(CCW_FC_842, ccw, fc);
>>>>> +       crb->ccw =3D cpu_to_be32(ccw);
>>>>> +
>>>>> +       txwin =3D wmem->txwin;
>>>>> +       /* shoudn't happen, we don't load without a coproc */
>>>>> +       if (!txwin) {
>>>>> +               pr_err_ratelimited("NX-842 coprocessor is not availab=
le");
>>>>> +               return -ENODEV;
>>>>> +       }
>>>>> +
>>>>> +       do {
>>>>> +               wmem->start =3D ktime_get();
>>>>> +               preempt_disable();
>>>>> +               /*
>>>>> +                * VAS copy CRB into L2 cache. Refer <asm/vas.h>.
>>>>> +                * @crb, @offset and @first (must be true)
>>>>> +                */
>>>>> +               vas_copy_crb(crb, 0, 1);
>>>>> +
>>>>> +               /*
>>>>> +                * VAS paste previously copied CRB to NX.
>>>>> +                * @txwin, @offset, @last (must be true) and @re is
>>>>> +                * expected/assumed to be true for NX windows.
>>>>> +                */
>>>>> +               ret =3D vas_paste_crb(txwin, 0, 1, 1);
>>>>> +               preempt_enable();
>>>>> +               /*
>>>>> +                * Retry copy/paste function for VAS failures.
>>>>> +                */
>>>>> +       } while (ret && (i++ < VAS_RETRIES));
>>>>> +
>>>>> +       if (ret) {
>>>>> +               pr_err_ratelimited("VAS copy/paste failed\n");
>>>>> +               return ret;
>>>>> +       }
>>>>> +
>>>>> +       ret =3D wait_for_csb(wmem, csb);
>>>>> +       if (!ret)
>>>>> +               *outlenp =3D be32_to_cpu(csb->count);
>>>>> +
>>>>> +       return ret;
>>>>> +}
>>>>> +
>>>>> +/**
>>>>>   * nx842_powernv_compress - Compress data using the 842 algorithm
>>>>>   *
>>>>>   * Compression provided by the NX842 coprocessor on IBM PowerNV syst=
ems.
>>>>> @@ -576,6 +690,198 @@ static inline void nx842_add_coprocs_list(struc=
t nx842_coproc *coproc,
>>>>>         list_add(&coproc->list, &nx842_coprocs);
>>>>>  }
>>>>>
>>>>> +/*
>>>>> + * Identify chip ID for each CPU and save coprocesor adddress for th=
e
>>>>> + * corresponding NX engine in percpu coproc_inst.
>>>>> + * coproc_inst is used in crypto_init to open send window on the NX =
instance
>>>>> + * for the corresponding CPU / chip where the open request is execut=
ed.
>>>>> + */
>>>>> +static void nx842_set_per_cpu_coproc(struct nx842_coproc *coproc)
>>>>> +{
>>>>> +       unsigned int i, chip_id;
>>>>> +
>>>>> +       for_each_possible_cpu(i) {
>>>>> +               chip_id =3D cpu_to_chip_id(i);
>>>>> +
>>>>> +               if (coproc->chip_id =3D=3D chip_id)
>>>>> +                       per_cpu(coproc_inst, i) =3D coproc;
>>>>> +       }
>>>>> +}
>>>>> +
>>>>> +
>>>>> +static struct vas_window *nx842_alloc_txwin(struct nx842_coproc *cop=
roc)
>>>>> +{
>>>>> +       struct vas_window *txwin =3D NULL;
>>>>> +       struct vas_tx_win_attr txattr;
>>>>> +
>>>>> +       /*
>>>>> +        * Kernel requests will be high priority. So open send
>>>>> +        * windows only for high priority RxFIFO entries.
>>>>> +        */
>>>>> +       vas_init_tx_win_attr(&txattr, coproc->ct);
>>>>> +       txattr.lpid =3D 0;        /* lpid is 0 for kernel requests */
>>>>> +       txattr.pid =3D mfspr(SPRN_PID);
>>>>> +
>>>>> +       /*
>>>>> +        * Open a VAS send window which is used to send request to NX=
.
>>>>> +        */
>>>>> +       txwin =3D vas_tx_win_open(coproc->vas.id, coproc->ct, &txattr=
);
>>>>> +       if (IS_ERR(txwin)) {
>>>>> +               pr_err("ibm,nx-842: Can not open TX window: %ld\n",
>>>>> +                               PTR_ERR(txwin));
>>>>> +               return NULL;
>>>>> +       }
>>>>> +
>>>>> +       return txwin;
>>>>> +}
>>>>> +
>>>>> +static int __init vas_cfg_coproc_info(struct device_node *dn, int ch=
ip_id,
>>>>> +                                       int vasid)
>>>>> +{
>>>>> +       struct vas_window *rxwin =3D NULL;
>>>>> +       struct vas_rx_win_attr rxattr;
>>>>> +       struct nx842_coproc *coproc;
>>>>> +       u32 lpid, pid, tid, fifo_size;
>>>>> +       u64 rx_fifo;
>>>>> +       const char *priority;
>>>>> +       int ret;
>>>>> +
>>>>> +       ret =3D of_property_read_u64(dn, "rx-fifo-address", (void *)&=
rx_fifo);
>>>>> +       if (ret) {
>>>>> +               pr_err("Missing rx-fifo-address property\n");
>>>>> +               return ret;
>>>>> +       }
>>>>> +
>>>>> +       ret =3D of_property_read_u32(dn, "rx-fifo-size", &fifo_size);
>>>>> +       if (ret) {
>>>>> +               pr_err("Missing rx-fifo-size property\n");
>>>>> +               return ret;
>>>>> +       }
>>>>> +
>>>>> +       ret =3D of_property_read_u32(dn, "lpid", &lpid);
>>>>> +       if (ret) {
>>>>> +               pr_err("Missing lpid property\n");
>>>>> +               return ret;
>>>>> +       }
>>>>> +
>>>>> +       ret =3D of_property_read_u32(dn, "pid", &pid);
>>>>> +       if (ret) {
>>>>> +               pr_err("Missing pid property\n");
>>>>> +               return ret;
>>>>> +       }
>>>>> +
>>>>> +       ret =3D of_property_read_u32(dn, "tid", &tid);
>>>>> +       if (ret) {
>>>>> +               pr_err("Missing tid property\n");
>>>>> +               return ret;
>>>>> +       }
>>>>> +
>>>>> +       ret =3D of_property_read_string(dn, "priority", &priority);
>>>>> +       if (ret) {
>>>>> +               pr_err("Missing priority property\n");
>>>>> +               return ret;
>>>>> +       }
>>>>> +
>>>>> +       coproc =3D kzalloc(sizeof(*coproc), GFP_KERNEL);
>>>>> +       if (!coproc)
>>>>> +               return -ENOMEM;
>>>>> +
>>>>> +       if (!strcmp(priority, "High"))
>>>>> +               coproc->ct =3D VAS_COP_TYPE_842_HIPRI;
>>>>> +       else if (!strcmp(priority, "Normal"))
>>>>> +               coproc->ct =3D VAS_COP_TYPE_842;
>>>>> +       else {
>>>>> +               pr_err("Invalid RxFIFO priority value\n");
>>>>> +               ret =3D  -EINVAL;
>>>>> +               goto err_out;
>>>>> +       }
>>>>> +
>>>>> +       vas_init_rx_win_attr(&rxattr, coproc->ct);
>>>>> +       rxattr.rx_fifo =3D (void *)rx_fifo;
>>>>> +       rxattr.rx_fifo_size =3D fifo_size;
>>>>> +       rxattr.lnotify_lpid =3D lpid;
>>>>> +       rxattr.lnotify_pid =3D pid;
>>>>> +       rxattr.lnotify_tid =3D tid;
>>>>> +       rxattr.wcreds_max =3D MAX_CREDITS_PER_RXFIFO;
>>>>> +
>>>>> +       /*
>>>>> +        * Open a VAS receice window which is used to configure RxFIF=
O
>>>>> +        * for NX.
>>>>> +        */
>>>>> +       rxwin =3D vas_rx_win_open(vasid, coproc->ct, &rxattr);
>>>>> +       if (IS_ERR(rxwin)) {
>>>>> +               ret =3D PTR_ERR(rxwin);
>>>>> +               pr_err("setting RxFIFO with VAS failed: %d\n",
>>>>> +                       ret);
>>>>> +               goto err_out;
>>>>> +       }
>>>>> +
>>>>> +       coproc->vas.rxwin =3D rxwin;
>>>>> +       coproc->vas.id =3D vasid;
>>>>> +       nx842_add_coprocs_list(coproc, chip_id);
>>>>> +
>>>>> +       /*
>>>>> +        * Kernel requests use only high priority FIFOs. So save copr=
oc
>>>>> +        * info in percpu coproc_inst which will be used to open send
>>>>> +        * windows for crypto open requests later.
>>>>> +        */
>>>>> +       if (coproc->ct =3D=3D VAS_COP_TYPE_842_HIPRI)
>>>>> +               nx842_set_per_cpu_coproc(coproc);
>>>>> +
>>>>> +       return 0;
>>>>> +
>>>>> +err_out:
>>>>> +       kfree(coproc);
>>>>> +       return ret;
>>>>> +}
>>>>> +
>>>>> +
>>>>> +static int __init nx842_powernv_probe_vas(struct device_node *pn)
>>>>> +{
>>>>> +       struct device_node *dn;
>>>>> +       int chip_id, vasid, ret =3D 0;
>>>>> +       int nx_fifo_found =3D 0;
>>>>> +
>>>>> +       chip_id =3D of_get_ibm_chip_id(pn);
>>>>> +       if (chip_id < 0) {
>>>>> +               pr_err("ibm,chip-id missing\n");
>>>>> +               return -EINVAL;
>>>>> +       }
>>>>> +
>>>>> +       dn =3D of_find_compatible_node(pn, NULL, "ibm,power9-vas-x");
>>>>> +
>>>>> +       if (!dn) {
>>>>> +               pr_err("Missing VAS device node\n");
>>>>> +               return -EINVAL;
>>>>> +       }
>>>>> +
>>>>> +       if (of_property_read_u32(dn, "ibm,vas-id", &vasid)) {
>>>>> +               pr_err("Missing ibm,vas-id device property\n");
>>>>> +               of_node_put(dn);
>>>>> +               return -EINVAL;
>>>>> +       }
>>>>> +
>>>>> +       of_node_put(dn);
>>>>> +
>>>>> +       for_each_child_of_node(pn, dn) {
>>>>> +               if (of_device_is_compatible(dn, "ibm,p9-nx-842")) {
>>>>> +                       ret =3D vas_cfg_coproc_info(dn, chip_id, vasi=
d);
>>>>> +                       if (ret) {
>>>>> +                               of_node_put(dn);
>>>>> +                               return ret;
>>>>> +                       }
>>>>> +                       nx_fifo_found++;
>>>>> +               }
>>>>> +       }
>>>>> +
>>>>> +       if (!nx_fifo_found) {
>>>>> +               pr_err("NX842 FIFO nodes are missing\n");
>>>>> +               ret =3D -EINVAL;
>>>>> +       }
>>>>> +
>>>>> +       return ret;
>>>>> +}
>>>>> +
>>>>>  static int __init nx842_powernv_probe(struct device_node *dn)
>>>>>  {
>>>>>         struct nx842_coproc *coproc;
>>>>> @@ -622,6 +928,9 @@ static void nx842_delete_coprocs(void)
>>>>>         struct nx842_coproc *coproc, *n;
>>>>>
>>>>>         list_for_each_entry_safe(coproc, n, &nx842_coprocs, list) {
>>>>> +               if (coproc->vas.rxwin)
>>>>> +                       vas_win_close(coproc->vas.rxwin);
>>>>> +
>>>>>                 list_del(&coproc->list);
>>>>>                 kfree(coproc);
>>>>>         }
>>>>> @@ -643,6 +952,46 @@ static struct nx842_driver nx842_powernv_driver =
=3D {
>>>>>         .decompress =3D   nx842_powernv_decompress,
>>>>>  };
>>>>>
>>>>> +static int nx842_powernv_crypto_init_vas(struct crypto_tfm *tfm)
>>>>> +{
>>>>> +       struct nx842_crypto_ctx *ctx =3D crypto_tfm_ctx(tfm);
>>>>> +       struct nx842_workmem *wmem;
>>>>> +       struct nx842_coproc *coproc;
>>>>> +       int ret;
>>>>> +
>>>>> +       ret =3D nx842_crypto_init(tfm, &nx842_powernv_driver);
>>>>> +
>>>>> +       if (ret)
>>>>> +               return ret;
>>>>> +
>>>>> +       wmem =3D PTR_ALIGN((struct nx842_workmem *)ctx->wmem, WORKMEM=
_ALIGN);
>>>>> +       coproc =3D per_cpu(coproc_inst, smp_processor_id());
>>>>
>>>> this is wrong.  the crypto transform init function is not guaranteed
>>>> to be called by the same processor that later uses it.  Just because
>>>> that happens to be how zswap operates doesn't guarantee other crypto
>>>> users will do the same.
>>>
>>> Dan, Sorry missed this comment.
>>>
>>> Right, The actual crypto request can be executed on other processor tha=
n the CPU when the init is executed. The main goal is open send window on t=
he NX engine which is on the same chip for the corresponding CPU. So we are=
 OK if the request is scheduled on other CPU as long as it belongs to same =
chip. Otherwise in the worst case we will end up using remote NX.
>>
>> ok, but there's no guarantee of future crypto calls being on the same
>> chip either, so i still don't understand why you're doing this.  if
>> you want each crypto comp/decomp call to be cpu-local or node-local,
>> then choose which corpco/txwin to use at comp/decomp time, not
>> transform init time.
>
> On P8, requests are always send to same NX engine (nx842_ct) even though =
if the system has multiple NX coprocessors.

Um, no - read RFC02167 icswx spec again.  CT is the coprocessor
*type*, and is the same value for all 842 coprocessor engines in the
system.  It's the CI which is the coprocessor *instance*, which is
different for each coprocessor instance (of the same type) in the
system.  When setting up the icswx call, using the CT must be the type
assigned to 842 coprocessors, and the CI can correspond to any
specific coprocessor instance, or it can be the reserved value 0 to
indicate the system should choose the "best" coprocessor to use.
That's what the driver does, lets the system choose the "best" 842
engine instance to use:

        ccw =3D SET_FIELD(ccw, CCW_CI_842, 0); /* use 0 for hw
auto-selection */

Whether or not the underlying P8 firmware actually does pick the
"best" instance, or even load balances the engines at all, I don't
know.  The nx842 driver certainly could be updated to try to choose
the "best" coproc engine to use itself, if the coproc firmware isn't
doing it.  From the last version of the spec that I have, however, it
sounds like it should be working:

"8.3.2 CI Default Selection

When a CI of zero is specified, implementation-depen-
dent default selection of a targeted coprocessor is per-
formed. The default selection is made in one of the
following ways:

 The default CI is determined in the processor dur-
ing execution of icswx. The applicable nonzero CI
is substituted for the originally-specified zero CI in
order to designate the default coprocessor.

The zero CI is observed which causes the default
coprocessor to identify the issuer by implementa-
tion-dependent means and accept the request.

The use of the default CI reduces pressure on the
CI space. Any coprocessor type that does not
require predictable selection can use default CI
selection. Implementation-dependent configuration
controls can be used to balance and rebalance
coprocessor availability for the set of logical parti-
tions."


> Whereas on P9, requests will be forwarded to different NX engines, prefer=
able to the local NX for the corresponding chip.
>
> One way is open 1 send window for each NX during device probe and use the=
 corresponding window for each request. But in this case we might have over=
head with parallel requests (ex: 1024).
>
> We can open limited number of send windows on each NX (including for 842,=
 gzip - kernel and user space requests). So we can not keep send windows op=
en forever. The current code is opening TX window for each crypto session d=
uring crpto alloc and closing it during crypto free. We do not want window =
open / close for each request (copy/paste). With this approach, the compres=
sion/decompression request can be scheduled on different chip than the one =
used during window open. So in the worst case, requests will be processed o=
n the remote NX engine.
>
> One other way is reserve few windows (say 100) for each engine type and u=
se them - open 100 windows during probe and manage these windows for differ=
ent requests depends on the cpu / chip where these requests are executed. O=
ur next plan is look at performance analysis as part of VAS/NX optimization=
 once NX gzip support is added and make necessary changes.

I'm not sure if you are using 'engine type' when you mean 'engine
instance', but yes i would think it makes much more sense to open N
txwins per engine instance and keep them in a queue/list, then for
each comp/decomp operation choose the 'best' (considering cpu-local
and coproc available txwin queue len) coproc to use and take the top
txwin from that coproc's queue.

But again, since the P9 spec isn't public and the last I saw was a P8
spec over 2 years ago, I probably don't need to comment on this much
more ;-)

>
>
>>
>>
>>>
>>> Thanks
>>> Haren
>>>
>>>
>>>
>>>
>>
>
