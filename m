From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [7/7] crypto: caam/qi - add ablkcipher and authenc algorithms
Date: Tue, 04 Apr 2017 15:03:23 +1000
Message-ID: <87vaqkvk6c.fsf@concordia.ellerman.id.au>
References: <20170317100602.2837-8-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Claudiu Manoil <claudiu.manoil@nxp.com>,
 Cristian Stoica <cristian.stoica@nxp.com>, Dan Douglass <dan.douglass@nxp.com>,
 linux-arm-kernel@lists.infradead.org, Vakul Garg <vakul.garg@nxp.com>,
 linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>,
 Alexandru Porosanu <alexandru.porosanu@nxp.com>, linux-crypto@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Scott Wood <oss@buserror.net>, Roy Pledge
 <roy.pledge@nxp.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20170317100602.2837-8-horia.geanta@nxp.com>
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

Horia Geant=C4=83 <horia.geanta@nxp.com> writes:

> Add support to submit ablkcipher and authenc algorithms
> via the QI backend:
> -ablkcipher:
> cbc({aes,des,des3_ede})
> ctr(aes), rfc3686(ctr(aes))
> xts(aes)
> -authenc:
> authenc(hmac(md5),cbc({aes,des,des3_ede}))
> authenc(hmac(sha*),cbc({aes,des,des3_ede}))
>
> caam/qi being a new driver, let's wait some time to settle down without
> interfering with existing caam/jr driver.
> Accordingly, for now all caam/qi algorithms (caamalg_qi module) are
> marked to be of lower priority than caam/jr ones (caamalg module).
>
> Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
> Signed-off-by: Alex Porosanu <alexandru.porosanu@nxp.com>
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
> ---
>  drivers/crypto/caam/Kconfig        |   20 +-
>  drivers/crypto/caam/Makefile       |    1 +
>  drivers/crypto/caam/caamalg.c      |    9 +-
>  drivers/crypto/caam/caamalg_desc.c |   77 +-
>  drivers/crypto/caam/caamalg_desc.h |   15 +-
>  drivers/crypto/caam/caamalg_qi.c   | 2387 ++++++++++++++++++++++++++++++=
++++++
>  drivers/crypto/caam/sg_sw_qm.h     |  108 ++
>  7 files changed, 2601 insertions(+), 16 deletions(-)
>  create mode 100644 drivers/crypto/caam/caamalg_qi.c
>  create mode 100644 drivers/crypto/caam/sg_sw_qm.h


This appears to be blowing up my Freescale (NXP) P5020DS board:

  Unable to handle kernel paging request for data at address 0x00000020
  Faulting instruction address: 0xc0000000004393e4
  Oops: Kernel access of bad area, sig: 11 [#1]
  SMP NR_CPUS=3D24=20
  CoreNet Generic
  Modules linked in:
  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.11.0-rc3-compiler_gcc-4.6.3-0=
0046-gb189817cf789 #5
  task: c0000000f70c0000 task.stack: c0000000f70c8000
  NIP: c0000000004393e4 LR: c0000000004aeba0 CTR: c0000000004fa7d8
  REGS: c0000000f70cb160 TRAP: 0300   Not tainted  (4.11.0-rc3-compiler_gcc=
-4.6.3-00046-gb189817cf789)
  MSR: 0000000080029000 <CE,EE,ME>
    CR: 24adbe48  XER: 20000000
  DEAR: 0000000000000020 ESR: 0000000000000000 SOFTE: 1=20
  GPR00: c0000000006feba0 c0000000f70cb3e0 c000000000e60000 000000000000000=
0=20
  GPR04: 0000000000000001 0000000000000000 c000000000e0b290 000000000000000=
3=20
  GPR08: 0000000000000004 c000000000ea5280 0000000000000004 000000000000000=
4=20
  GPR12: 0000000088adbe22 c00000003fff5000 c000000000ba3518 8000080088090fa=
8=20
  GPR16: 0000000000001000 c000000000ba3500 c0000000f72c68d8 000000000000000=
4=20
  GPR20: c000000000ea5280 c000000000ba34e8 0000000000000020 000000000000000=
4=20
  GPR24: c000000000eab7c0 0000000000000000 c0000000f7fc8818 c000000000eb000=
0=20
  GPR28: c0000000f786cc00 c000000000eab780 fffffffff786cc00 c000000000eab7c=
0=20
  NIP [c0000000004393e4] .gen_pool_alloc+0x0/0xc
  LR [c0000000004aeba0] .qman_alloc_cgrid_range+0x24/0x54
  Call Trace:
  [c0000000f70cb3e0] [c000000000504054] .platform_device_register_full+0x12=
c/0x150 (unreliable)
  [c0000000f70cb460] [c0000000006feba0] .caam_qi_init+0x158/0x63c
  [c0000000f70cb5f0] [c0000000006fc64c] .caam_probe+0x8b8/0x1830
  [c0000000f70cb740] [c000000000503288] .platform_drv_probe+0x60/0xac
  [c0000000f70cb7c0] [c000000000501194] .driver_probe_device+0x248/0x344
  [c0000000f70cb870] [c0000000005013b4] .__driver_attach+0x124/0x128
  [c0000000f70cb900] [c0000000004fed90] .bus_for_each_dev+0x80/0xcc
  [c0000000f70cb9a0] [c000000000500858] .driver_attach+0x24/0x38
  [c0000000f70cba10] [c00000000050043c] .bus_add_driver+0x14c/0x29c
  [c0000000f70cbab0] [c000000000501d64] .driver_register+0x8c/0x154
  [c0000000f70cbb30] [c000000000503000] .__platform_driver_register+0x48/0x=
5c
  [c0000000f70cbba0] [c000000000c7f798] .caam_driver_init+0x1c/0x30
  [c0000000f70cbc10] [c000000000001904] .do_one_initcall+0x60/0x1a8
  [c0000000f70cbcf0] [c000000000c35f30] .kernel_init_freeable+0x248/0x334
  [c0000000f70cbdb0] [c0000000000020fc] .kernel_init+0x1c/0xf20
  [c0000000f70cbe30] [c0000000000009bc] .ret_from_kernel_thread+0x58/0x9c
  Instruction dump:
  eb61ffd8 eb81ffe0 eba1ffe8 ebc1fff0 ebe1fff8 4e800020 38600000 4bffffb0=20
  7ce53b78 4bffff0c 7f67db78 4bffff24 <e8a30020> e8c30028 4bfffd30 fbe1fff8=
=20
  ---[ end trace 9f61087068991b02 ]---


home:linux-next(4)(I)> git bisect log
...
git bisect bad b189817cf7894e03fd3700acd923221d3007259e
# first bad commit: [b189817cf7894e03fd3700acd923221d3007259e] crypto: caam=
/qi - add ablkcipher and authenc algorithms


The oops is saying gen_pool_alloc() was called with a NULL pointer, so
it seems qm_cgralloc is NULL:

static int qman_alloc_range(struct gen_pool *p, u32 *result, u32 cnt)
{
	unsigned long addr;

	addr =3D gen_pool_alloc(p, cnt);
	...

int qman_alloc_cgrid_range(u32 *result, u32 count)
{
	return qman_alloc_range(qm_cgralloc, result, count);
}


I didn't pull the thread any further than that.

cheers
