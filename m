From: Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH 4/5] tsc: wire up entropy generation function
Date: Mon, 13 Jun 2011 15:27:26 -0700
Message-ID: <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>
	<1308002818-27802-5-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:47539 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab1FMW1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2011 18:27:30 -0400
Received: from hpaq11.eem.corp.google.com (hpaq11.eem.corp.google.com [172.25.149.11])
	by smtp-out.google.com with ESMTP id p5DMRTjj026356
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jun 2011 15:27:29 -0700
Received: from ywp31 (ywp31.prod.google.com [10.192.16.31])
	by hpaq11.eem.corp.google.com with ESMTP id p5DMRQjM022376
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jun 2011 15:27:27 -0700
Received: by ywp31 with SMTP id 31so3524161ywp.17
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jun 2011 15:27:26 -0700 (PDT)
In-Reply-To: <1308002818-27802-5-git-send-email-jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 13, 2011 at 3:06 PM, Jarod Wilson <jarod@redhat.com> wrote:
> TSC is high enough resolution that we can use its low-order byte to
> stir new data into the random number generator entropy pool.

=46rom what I vaguely remember from years past, rdtsc, especially last
few bits of it are not very good as random number source. As they are
based on lower bus frequency and a multiplier. May be things have
changed these days. Adding Peter and Suresh for comments.

Thanks,
Venki

>
> CC: Matt Mackall <mpm@selenic.com>
> CC: "Venkatesh Pallipadi (Venki)" <venki@google.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: John Stultz <johnstul@us.ibm.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
> =A0arch/x86/kernel/tsc.c | =A0 18 ++++++++++++++++++
> =A01 files changed, 18 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 6cc6922..d206ec3 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -10,6 +10,7 @@
> =A0#include <linux/clocksource.h>
> =A0#include <linux/percpu.h>
> =A0#include <linux/timex.h>
> +#include <linux/random.h>
>
> =A0#include <asm/hpet.h>
> =A0#include <asm/timer.h>
> @@ -768,11 +769,28 @@ static void resume_tsc(struct clocksource *cs)
> =A0 =A0 =A0 =A0clocksource_tsc.cycle_last =3D 0;
> =A0}
>
> +static void tsc_add_entropy(void)
> +{
> + =A0 =A0 =A0 static u64 last;
> + =A0 =A0 =A0 u64 counter;
> + =A0 =A0 =A0 int delta;
> +
> + =A0 =A0 =A0 rdtscll(counter);
> + =A0 =A0 =A0 delta =3D (int)(counter - last);
> + =A0 =A0 =A0 last =3D counter;
> +
> + =A0 =A0 =A0 if (delta =3D=3D counter)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 add_clocksource_randomness(delta);
> +}
> +
> =A0static struct clocksource clocksource_tsc =3D {
> =A0 =A0 =A0 =A0.name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D "tsc",
> =A0 =A0 =A0 =A0.rating =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 300,
> =A0 =A0 =A0 =A0.read =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D read_tsc=
,
> =A0 =A0 =A0 =A0.resume =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D resume_tsc=
,
> + =A0 =A0 =A0 .entropy =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D tsc_add_ent=
ropy,
> =A0 =A0 =A0 =A0.mask =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D CLOCKSOU=
RCE_MASK(64),
> =A0 =A0 =A0 =A0.flags =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D CLOCK_SO=
URCE_IS_CONTINUOUS |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CL=
OCK_SOURCE_MUST_VERIFY,
> --
> 1.7.1
>
>
