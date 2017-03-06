From: James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH v3] MIPS: Fix build breakage caused by header file changes
Date: Mon, 6 Mar 2017 23:20:20 +0000
Message-ID: <20170306232019.GG2878@jhogan-linux.le.imgtec.org>
References: <1488827635-7708-1-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yZnyZsPjQYjG7xG7"
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <1488827635-7708-1-git-send-email-linux@roeck-us.net>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
List-Id: linux-crypto.vger.kernel.org

--yZnyZsPjQYjG7xG7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Mon, Mar 06, 2017 at 11:13:55AM -0800, Guenter Roeck wrote:
> Since commit f3ac60671954 ("sched/headers: Move task-stack related
> APIs from <linux/sched.h> to <linux/sched/task_stack.h>") and commit
> f780d89a0e82 ("sched/headers: Remove <asm/ptrace.h> from
> <linux/sched.h>"), various mips builds fail as follows.
>=20
> arch/mips/kernel/smp-mt.c: In function =E2=80=98vsmp_boot_secondary=E2=80=
=99:
> arch/mips/include/asm/processor.h:384:41: error:
> 	implicit declaration of function =E2=80=98task_stack_page=E2=80=99
>=20
> In file included from
> 	/opt/buildbot/slave/hwmon-testing/build/arch/mips/kernel/pm.c:
> arch/mips/include/asm/fpu.h: In function '__own_fpu':
> arch/mips/include/asm/processor.h:385:31: error:
> 	invalid application of 'sizeof' to incomplete type 'struct pt_regs'

This one is in an inline function, so I think it'd affect multiple
includes of <asm/fpu.h> even if __own_fpu isn't used, so I think the
following patch which adds the include ptrace.h in fpu.h is more robust
than adding to the individual c files affected:
https://patchwork.linux-mips.org/patch/15386/

Admitedly it could probably have a more specific subject line since
there are more similar errors.

Cheers
James

>=20
> arch/mips/netlogic/common/smp.c: In function 'nlm_boot_secondary':
> arch/mips/netlogic/common/smp.c:157:2: error:
> 	implicit declaration of function 'task_stack_page'
>=20
> and more similar errors.
>=20
> Fixes: f3ac60671954 ("sched/headers: Move task-stack related APIs ...")
> Fixes: f780d89a0e82 ("sched/headers: Remove <asm/ptrace.h> from ...")
> Cc: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v3: Catch more build errors
>=20
>  arch/mips/cavium-octeon/cpu.c                  | 3 ++-
>  arch/mips/cavium-octeon/crypto/octeon-crypto.c | 1 +
>  arch/mips/cavium-octeon/smp.c                  | 2 +-
>  arch/mips/kernel/pm.c                          | 1 +
>  arch/mips/kernel/smp-mt.c                      | 2 +-
>  arch/mips/netlogic/common/smp.c                | 1 +
>  arch/mips/netlogic/xlp/cop2-ex.c               | 3 ++-
>  arch/mips/power/cpu.c                          | 1 +
>  8 files changed, 10 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/mips/cavium-octeon/cpu.c b/arch/mips/cavium-octeon/cpu.c
> index a5b427909b5c..b826b7a87c57 100644
> --- a/arch/mips/cavium-octeon/cpu.c
> +++ b/arch/mips/cavium-octeon/cpu.c
> @@ -10,7 +10,8 @@
>  #include <linux/irqflags.h>
>  #include <linux/notifier.h>
>  #include <linux/prefetch.h>
> -#include <linux/sched.h>
> +#include <linux/ptrace.h>
> +#include <linux/sched/task_stack.h>
> =20
>  #include <asm/cop2.h>
>  #include <asm/current.h>
> diff --git a/arch/mips/cavium-octeon/crypto/octeon-crypto.c b/arch/mips/c=
avium-octeon/crypto/octeon-crypto.c
> index 4d22365844af..cfb4a146cf17 100644
> --- a/arch/mips/cavium-octeon/crypto/octeon-crypto.c
> +++ b/arch/mips/cavium-octeon/crypto/octeon-crypto.c
> @@ -9,6 +9,7 @@
>  #include <asm/cop2.h>
>  #include <linux/export.h>
>  #include <linux/interrupt.h>
> +#include <linux/sched/task_stack.h>
> =20
>  #include "octeon-crypto.h"
> =20
> diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
> index 4b94b7fbafa3..d475c0146347 100644
> --- a/arch/mips/cavium-octeon/smp.c
> +++ b/arch/mips/cavium-octeon/smp.c
> @@ -10,8 +10,8 @@
>  #include <linux/smp.h>
>  #include <linux/interrupt.h>
>  #include <linux/kernel_stat.h>
> -#include <linux/sched.h>
>  #include <linux/sched/hotplug.h>
> +#include <linux/sched/task_stack.h>
>  #include <linux/init.h>
>  #include <linux/export.h>
> =20
> diff --git a/arch/mips/kernel/pm.c b/arch/mips/kernel/pm.c
> index dc814892133c..fab05022ab39 100644
> --- a/arch/mips/kernel/pm.c
> +++ b/arch/mips/kernel/pm.c
> @@ -11,6 +11,7 @@
> =20
>  #include <linux/cpu_pm.h>
>  #include <linux/init.h>
> +#include <linux/ptrace.h>
> =20
>  #include <asm/dsp.h>
>  #include <asm/fpu.h>
> diff --git a/arch/mips/kernel/smp-mt.c b/arch/mips/kernel/smp-mt.c
> index e077ea3e11fb..effc1ed18954 100644
> --- a/arch/mips/kernel/smp-mt.c
> +++ b/arch/mips/kernel/smp-mt.c
> @@ -18,7 +18,7 @@
>   * Copyright (C) 2006 Ralf Baechle (ralf@linux-mips.org)
>   */
>  #include <linux/kernel.h>
> -#include <linux/sched.h>
> +#include <linux/sched/task_stack.h>
>  #include <linux/cpumask.h>
>  #include <linux/interrupt.h>
>  #include <linux/irqchip/mips-gic.h>
> diff --git a/arch/mips/netlogic/common/smp.c b/arch/mips/netlogic/common/=
smp.c
> index 10d86d54880a..9035558920c1 100644
> --- a/arch/mips/netlogic/common/smp.c
> +++ b/arch/mips/netlogic/common/smp.c
> @@ -37,6 +37,7 @@
>  #include <linux/init.h>
>  #include <linux/smp.h>
>  #include <linux/irq.h>
> +#include <linux/sched/task_stack.h>
> =20
>  #include <asm/mmu_context.h>
> =20
> diff --git a/arch/mips/netlogic/xlp/cop2-ex.c b/arch/mips/netlogic/xlp/co=
p2-ex.c
> index 52bc5de42005..d990b7fc84aa 100644
> --- a/arch/mips/netlogic/xlp/cop2-ex.c
> +++ b/arch/mips/netlogic/xlp/cop2-ex.c
> @@ -13,7 +13,8 @@
>  #include <linux/irqflags.h>
>  #include <linux/notifier.h>
>  #include <linux/prefetch.h>
> -#include <linux/sched.h>
> +#include <linux/ptrace.h>
> +#include <linux/sched/task_stack.h>
> =20
>  #include <asm/cop2.h>
>  #include <asm/current.h>
> diff --git a/arch/mips/power/cpu.c b/arch/mips/power/cpu.c
> index 2129e67723ff..6ecccc26bf7f 100644
> --- a/arch/mips/power/cpu.c
> +++ b/arch/mips/power/cpu.c
> @@ -7,6 +7,7 @@
>   * Author: Hu Hongbing <huhb@lemote.com>
>   *	   Wu Zhangjin <wuzhangjin@gmail.com>
>   */
> +#include <linux/ptrace.h>
>  #include <asm/sections.h>
>  #include <asm/fpu.h>
>  #include <asm/dsp.h>
> --=20
> 2.7.4
>=20
>=20

--yZnyZsPjQYjG7xG7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYve6zAAoJEGwLaZPeOHZ6oNwQALQSrLL6zvv8KKSmyGrPAwmj
/saYz2fpM85GmGQILkTUM3aAs9NSEXHhImk0584nwWHw8INnckNvEqEqdRqDuRcT
PAZQGdCrvXh5rL65LPWpU66G+c/ZxWJNGfJl7yPFpNJOhe8IY5Vpsp+VvOXg1uGY
awu2ufZkQ3nZ/0pOd+/IwE8s+oji7U/d91aBnKsiRhbuL/CZtk9RhTzjyII31DjM
meEt478vn7GkEgDweQlKy4UiHaE6Odm+ag1q2UWBORMHpHF6lI+9krTv7it5D98V
fQljMD6cXmfl8ERMaTbnpgme0HIXX4jRayoZJXUKtmNz0Jub5WPfO0qL4+KRoUYN
HG/Ca9v7UYvFXV9CkfDAl6cxYM5+RNWljblD7Q1/cmPiGpfQl+0IOKjHznWYQ5vB
rNTsgULIyfoIi6KfI7TrU5opLqGznBTf4pki07JQM0lhKLd0hkVLLnNIL+DSumZM
xBu3C4omo6E0rP8AzdPPysW7BX0+8cxv/0DYW9Y2ziueDsCzFL/L3pImG0hb+Y+0
9Gu3UPC+EYxzMBV8/dCaIHUx9FjC6bMObtoJpRfhdHcP5PhZs11N8GffEFSxfojW
HOSH/zZMWfDc2r5TYjjEtszpEDLnPUzAV6XR+snbQvkUkfE1llm+rY6d3xTjVNHw
41e9XEeVI0EG4LT2kCse
=tVu/
-----END PGP SIGNATURE-----

--yZnyZsPjQYjG7xG7--
