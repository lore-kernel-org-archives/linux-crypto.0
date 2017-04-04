From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [7/7] crypto: caam/qi - add ablkcipher and authenc algorithms
Date: Tue, 4 Apr 2017 12:42:37 +0000
Message-ID: <VI1PR0401MB2591B66506D78DF5AFCC8FA4980B0@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170317100602.2837-8-horia.geanta@nxp.com>
 <87vaqkvk6c.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Cristian Stoica <cristian.stoica@nxp.com>,
        "Claudiu Manoil" <claudiu.manoil@nxp.com>,
        "linuxppc-dev@" <"lists.ozlabs.org linuxppc-dev"@lists.ozlabs.org>
To: Michael Ellerman <mpe@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Wood <oss@buserror.net>, Roy Pledge <roy.pledge@nxp.com>,
        Madalin-Cristian Bucur <madalin.bucur@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr50071.outbound.protection.outlook.com ([40.107.5.71]:64956
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752165AbdDDMmn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Apr 2017 08:42:43 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4/4/2017 8:03 AM, Michael Ellerman wrote:=0A=
> Horia Geant=E3 <horia.geanta@nxp.com> writes:=0A=
> =0A=
>> Add support to submit ablkcipher and authenc algorithms=0A=
>> via the QI backend:=0A=
>> -ablkcipher:=0A=
>> cbc({aes,des,des3_ede})=0A=
>> ctr(aes), rfc3686(ctr(aes))=0A=
>> xts(aes)=0A=
>> -authenc:=0A=
>> authenc(hmac(md5),cbc({aes,des,des3_ede}))=0A=
>> authenc(hmac(sha*),cbc({aes,des,des3_ede}))=0A=
>>=0A=
>> caam/qi being a new driver, let's wait some time to settle down without=
=0A=
>> interfering with existing caam/jr driver.=0A=
>> Accordingly, for now all caam/qi algorithms (caamalg_qi module) are=0A=
>> marked to be of lower priority than caam/jr ones (caamalg module).=0A=
>>=0A=
>> Signed-off-by: Vakul Garg <vakul.garg@nxp.com>=0A=
>> Signed-off-by: Alex Porosanu <alexandru.porosanu@nxp.com>=0A=
>> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>> ---=0A=
>>  drivers/crypto/caam/Kconfig        |   20 +-=0A=
>>  drivers/crypto/caam/Makefile       |    1 +=0A=
>>  drivers/crypto/caam/caamalg.c      |    9 +-=0A=
>>  drivers/crypto/caam/caamalg_desc.c |   77 +-=0A=
>>  drivers/crypto/caam/caamalg_desc.h |   15 +-=0A=
>>  drivers/crypto/caam/caamalg_qi.c   | 2387 +++++++++++++++++++++++++++++=
+++++++=0A=
>>  drivers/crypto/caam/sg_sw_qm.h     |  108 ++=0A=
>>  7 files changed, 2601 insertions(+), 16 deletions(-)=0A=
>>  create mode 100644 drivers/crypto/caam/caamalg_qi.c=0A=
>>  create mode 100644 drivers/crypto/caam/sg_sw_qm.h=0A=
> =0A=
> =0A=
> This appears to be blowing up my Freescale (NXP) P5020DS board:=0A=
> =0A=
=0A=
Michael,=0A=
=0A=
Unfortunately I was not able to reproduce the issue on my P5020DS using=0A=
the same SHA1 (b189817cf789). Assuming you've used=0A=
corenet64_smp_defconfig and the p5020ds dts file in this tree.=0A=
=0A=
Roy, Madalin,=0A=
=0A=
This might be a probing order issue b/w CAAM/QI and QMan=0A=
(drivers/soc/fsl/qbman/qman_ccsr.c) platform drivers.=0A=
AFAICT the same dependency exists b/w QMan and DPAA Ethernet, thus is=0A=
should be fixed there too.=0A=
=0A=
CAAM and QMan are sibling devices, having "soc" DT node as parent.=0A=
Should device link mechanism (Documentation/driver-api/device_link.rst)=0A=
be used to register the dependency b/w QMan driver (supplier) and=0A=
CAAM/QI driver (consumer)?=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
>   Unable to handle kernel paging request for data at address 0x00000020=
=0A=
>   Faulting instruction address: 0xc0000000004393e4=0A=
>   Oops: Kernel access of bad area, sig: 11 [#1]=0A=
>   SMP NR_CPUS=3D24 =0A=
>   CoreNet Generic=0A=
>   Modules linked in:=0A=
>   CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.11.0-rc3-compiler_gcc-4.6.3=
-00046-gb189817cf789 #5=0A=
>   task: c0000000f70c0000 task.stack: c0000000f70c8000=0A=
>   NIP: c0000000004393e4 LR: c0000000004aeba0 CTR: c0000000004fa7d8=0A=
>   REGS: c0000000f70cb160 TRAP: 0300   Not tainted  (4.11.0-rc3-compiler_g=
cc-4.6.3-00046-gb189817cf789)=0A=
>   MSR: 0000000080029000 <CE,EE,ME>=0A=
>     CR: 24adbe48  XER: 20000000=0A=
>   DEAR: 0000000000000020 ESR: 0000000000000000 SOFTE: 1 =0A=
>   GPR00: c0000000006feba0 c0000000f70cb3e0 c000000000e60000 0000000000000=
000 =0A=
>   GPR04: 0000000000000001 0000000000000000 c000000000e0b290 0000000000000=
003 =0A=
>   GPR08: 0000000000000004 c000000000ea5280 0000000000000004 0000000000000=
004 =0A=
>   GPR12: 0000000088adbe22 c00000003fff5000 c000000000ba3518 8000080088090=
fa8 =0A=
>   GPR16: 0000000000001000 c000000000ba3500 c0000000f72c68d8 0000000000000=
004 =0A=
>   GPR20: c000000000ea5280 c000000000ba34e8 0000000000000020 0000000000000=
004 =0A=
>   GPR24: c000000000eab7c0 0000000000000000 c0000000f7fc8818 c000000000eb0=
000 =0A=
>   GPR28: c0000000f786cc00 c000000000eab780 fffffffff786cc00 c000000000eab=
7c0 =0A=
>   NIP [c0000000004393e4] .gen_pool_alloc+0x0/0xc=0A=
>   LR [c0000000004aeba0] .qman_alloc_cgrid_range+0x24/0x54=0A=
>   Call Trace:=0A=
>   [c0000000f70cb3e0] [c000000000504054] .platform_device_register_full+0x=
12c/0x150 (unreliable)=0A=
>   [c0000000f70cb460] [c0000000006feba0] .caam_qi_init+0x158/0x63c=0A=
>   [c0000000f70cb5f0] [c0000000006fc64c] .caam_probe+0x8b8/0x1830=0A=
>   [c0000000f70cb740] [c000000000503288] .platform_drv_probe+0x60/0xac=0A=
>   [c0000000f70cb7c0] [c000000000501194] .driver_probe_device+0x248/0x344=
=0A=
>   [c0000000f70cb870] [c0000000005013b4] .__driver_attach+0x124/0x128=0A=
>   [c0000000f70cb900] [c0000000004fed90] .bus_for_each_dev+0x80/0xcc=0A=
>   [c0000000f70cb9a0] [c000000000500858] .driver_attach+0x24/0x38=0A=
>   [c0000000f70cba10] [c00000000050043c] .bus_add_driver+0x14c/0x29c=0A=
>   [c0000000f70cbab0] [c000000000501d64] .driver_register+0x8c/0x154=0A=
>   [c0000000f70cbb30] [c000000000503000] .__platform_driver_register+0x48/=
0x5c=0A=
>   [c0000000f70cbba0] [c000000000c7f798] .caam_driver_init+0x1c/0x30=0A=
>   [c0000000f70cbc10] [c000000000001904] .do_one_initcall+0x60/0x1a8=0A=
>   [c0000000f70cbcf0] [c000000000c35f30] .kernel_init_freeable+0x248/0x334=
=0A=
>   [c0000000f70cbdb0] [c0000000000020fc] .kernel_init+0x1c/0xf20=0A=
>   [c0000000f70cbe30] [c0000000000009bc] .ret_from_kernel_thread+0x58/0x9c=
=0A=
>   Instruction dump:=0A=
>   eb61ffd8 eb81ffe0 eba1ffe8 ebc1fff0 ebe1fff8 4e800020 38600000 4bffffb0=
 =0A=
>   7ce53b78 4bffff0c 7f67db78 4bffff24 <e8a30020> e8c30028 4bfffd30 fbe1ff=
f8 =0A=
>   ---[ end trace 9f61087068991b02 ]---=0A=
> =0A=
> =0A=
> home:linux-next(4)(I)> git bisect log=0A=
> ...=0A=
> git bisect bad b189817cf7894e03fd3700acd923221d3007259e=0A=
> # first bad commit: [b189817cf7894e03fd3700acd923221d3007259e] crypto: ca=
am/qi - add ablkcipher and authenc algorithms=0A=
> =0A=
> =0A=
> The oops is saying gen_pool_alloc() was called with a NULL pointer, so=0A=
> it seems qm_cgralloc is NULL:=0A=
> =0A=
> static int qman_alloc_range(struct gen_pool *p, u32 *result, u32 cnt)=0A=
> {=0A=
> 	unsigned long addr;=0A=
> =0A=
> 	addr =3D gen_pool_alloc(p, cnt);=0A=
> 	...=0A=
> =0A=
> int qman_alloc_cgrid_range(u32 *result, u32 count)=0A=
> {=0A=
> 	return qman_alloc_range(qm_cgralloc, result, count);=0A=
> }=0A=
> =0A=
> =0A=
> I didn't pull the thread any further than that.=0A=
> =0A=
> cheers=0A=
> =0A=
=0A=
