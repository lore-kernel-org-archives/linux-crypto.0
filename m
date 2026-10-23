Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792722673;
	b=h/ZhabmcfPCVMa0t1MsHC9vLtjpVv4bDlAXU3jgUcyxf26Fi1NZVnef5G7uyFs5lkQS+
	 qZuzRht262TfKyDh6NHlLlV426kG6njf1q654gda8X02kEkC+5aZBVHaahlR78EQjLYb9
	 AkN4HmABiYc13R7rWWtTsSgtwPQIZkE0QriZOQAGAQCx7YiXJbV54lLSSVthHta3GEZV+
	 E+6Ve4NW2ot0rZ7C6i4Vu2eSIQdbZkNLO4JttaWTdfQ4vHyogqhM40OSxH3UH4Ij1cUcF
	 zGHENNiA8N++KZEIf/9nkLaDKpCFxVjjum75ydvNArdf9dkdbnzMHnNUFJSxO556lPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792722673;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LaWfGEg3F0yGus45XEi1G/VZakxdpTsIbwri8yzeDMA=;
	b=ceBZDSTuA/Nmud26NzSopwrP5MCTFyF96ZH8zHZrkBYpKZsXVpFcXehZ+IRQQIjkTQg5
	 Cl4QzNM2oRfRpK2xW+yk+FXAl8o5AUfRgnMoBgMhmrfqJyiuqVpD8LXr+ivTUDCSyTX2X
	 u8oPoe+U2dJnjhnYyLBUsvifKD8Q1Nka0iF5hbPEIZiumj24JCnJSd8aKHlAD0B5pCxOU
	 ur6x6gnkfC6IOyl7ZhtWsqp4Or53Y1qSJcPJYww6dHICqNF06Ic54+aayp1HRGzoiIWmN
	 Sy1vfXyB+MqX8y6+qAxezlkFxaDdAtY2kip8aSVxTXJrWQTT2c9Mxcqp2Z6ipp+6rcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EUEi1Ywk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F7F606A31A;
	Fri, 23 Oct 2026 02:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EUEi1Ywk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28171F01825;
	Fri, 23 Oct 2026 02:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792722673;
	bh=LaWfGEg3F0yGus45XEi1G/VZakxdpTsIbwri8yzeDMA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EUEi1YwkPRMnXdlba5EQpsxgK0PPQrCMIeEL0MDvwKr5HK/yqqQAeiFYO6sxbGnNe
	 Xabtm4FE2AySQNZcDGrYhG2AUTZBKwMUrKlYR7YiMvL96fPeXQIObxeOqLEUAVEQtH
	 GT4FoNz9117WWLBjMbn+zzSA9JZYmukuKVca3lFlMIO1t7buLF8NYvNknznXiksyL+
	 3boomsZO4Xyj3dyy/UKBhCuWAWK0b8t1TTuBfvlzeu0OP4tm2wUuZ7aWohfGYY2qHc
	 beTB08D3+NvL254recGe+EuOAmpZfWM45BtlM/AFhU4UTxeptsyN3ogndI9f76LlQl
	 Lecds9cC5V0Lg==
Message-ID: <sashiko-outbox-182235@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 3/6] hwrng: starfive - move the SEU reseed out of
 the interrupt handler
Reply-To: sashiko-reviews@lists.linux.dev
To: lianfeng.ouyang <lianfeng.ouyang@starfivetech.com>, "Olivia Mackall" <olivia@selenic.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Philipp
 Zabel" <p.zabel@pengutronix.de>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20261023021248.3763-4-lianfeng.ouyang@starfivetech.com>
References: <20261023021248.3763-1-lianfeng.ouyang@starfivetech.com>
 <20261023021248.3763-4-lianfeng.ouyang@starfivetech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 02:31:12 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] hwrng: starfive - premature completion race in starfive_trng_cmd()
- [High] hwrng: starfive - uncancelled reseed work in starfive_trng_irq_cle=
ar()
--

commit 23b2ffaa5e6bbeefc785bc18a08d6497566a4c9b
Author: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

hwrng: starfive - move the SEU reseed out of the interrupt handler

This commit reworks command handling in the StarFive TRNG driver around a
mutex that serialises command sequences and moves LFSR lockup reseeding
from the interrupt handler to a work item and the read path. It also manages
the interrupt lifecycle across init, cleanup, and runtime suspend/resume.

> diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_rando=
m/jh7110-trng.c
> index 17932cc6d7aa4..8e0e7865453b0 100644
> --- a/drivers/char/hw_random/jh7110-trng.c
> +++ b/drivers/char/hw_random/jh7110-trng.c
[ ... ]
> @@ -122,22 +141,38 @@ MODULE_PARM_DESC(autoage, "Auto-reseeding after spe=
cified timer countdowns to 0:
>  				" 0 - disable timer\n"
>  				" other - reload value for internal timer");
> =20
> -static inline int starfive_trng_wait_idle(struct starfive_trng *trng)
> +static bool starfive_trng_idle(struct starfive_trng *trng, bool wait)
>  {
> -	u32 stat;
> +	u32 stat, busy =3D STARFIVE_STAT_RAND_GENERATING | STARFIVE_STAT_RAND_S=
EEDING;
> =20
> -	return readl_relaxed_poll_timeout(trng->base + STARFIVE_STAT, stat,
> -					  !(stat & (STARFIVE_STAT_RAND_GENERATING |
> -						    STARFIVE_STAT_RAND_SEEDING)),
> -					  10, 100000);
> +	if (!wait)
> +		return !(readl_relaxed(trng->base + STARFIVE_STAT) & busy);
> +
> +	return !readl_relaxed_poll_timeout(trng->base + STARFIVE_STAT, stat,
> +					   !(stat & busy),
> +					   10, 100000);
>  }
> =20
> -static inline void starfive_trng_irq_mask_clear(struct starfive_trng *tr=
ng)
> +/*
> + * Record a pending LFSR lockup and make sure it gets serviced. queue_wo=
rk()
> + * is a no-op while the work is already pending, so this is safe to call
> + * from any context that notices the lockup.
> + */
> +static void starfive_trng_request_reseed(struct starfive_trng *trng)
>  {
> -	/* clear register: ISTAT */
> -	u32 data =3D readl(trng->base + STARFIVE_ISTAT);
> +	WRITE_ONCE(trng->need_reseed, true);
> +	queue_work(system_freezable_wq, &trng->work);
> +}
> +
> +static void starfive_trng_irq_clear(struct starfive_trng *trng)
> +{
> +	u32 istat =3D readl(trng->base + STARFIVE_ISTAT);
> +
> +	/* Do not lose an LFSR lockup that has not been serviced yet. */
> +	if (istat & STARFIVE_ISTAT_LFSR_LOCKUP)
> +		starfive_trng_request_reseed(trng);
> =20
> -	writel(data, trng->base + STARFIVE_ISTAT);
> +	writel(istat, trng->base + STARFIVE_ISTAT);
>  }
[ ... ]
> @@ -194,42 +229,71 @@ static void starfive_trng_power_off_action(void *da=
ta)
>  	starfive_trng_power_off(data, true);
>  }
> =20
> -static int starfive_trng_cmd(struct starfive_trng *trng, u32 cmd, bool w=
ait)
> +static int starfive_trng_cmd(struct starfive_trng *trng, u32 cmd, unsign=
ed long timeout, bool wait)
>  {
> -	int wait_time =3D 1000;
> +	struct completion *done;
> =20
> -	/* allow up to 40 us for wait =3D=3D 0 */
> -	if (!wait)
> -		wait_time =3D 40;
> +	lockdep_assert_held(&trng->lock);
> +
> +	if (!starfive_trng_idle(trng, wait))
> +		return wait ? -ETIMEDOUT : -EBUSY;
> =20
>  	switch (cmd) {
>  	case STARFIVE_CTRL_GENE_RANDNUM:
> -		reinit_completion(&trng->random_done);
> -		spin_lock_irq(&trng->write_lock);
> -		writel(cmd, trng->base + STARFIVE_CTRL);
> -		spin_unlock_irq(&trng->write_lock);
> -		if (!wait_for_completion_timeout(&trng->random_done, usecs_to_jiffies(=
wait_time)))
> -			return -ETIMEDOUT;
> +		done =3D &trng->random_done;
>  		break;
>  	case STARFIVE_CTRL_EXEC_RANDRESEED:
> -		reinit_completion(&trng->reseed_done);
> -		spin_lock_irq(&trng->write_lock);
> -		writel(cmd, trng->base + STARFIVE_CTRL);
> -		spin_unlock_irq(&trng->write_lock);
> -		if (!wait_for_completion_timeout(&trng->reseed_done, usecs_to_jiffies(=
wait_time)))
> -			return -ETIMEDOUT;
> +		done =3D &trng->reseed_done;
>  		break;
>  	default:
>  		return -EINVAL;
>  	}
> =20
> +	reinit_completion(done);
> +	writel(cmd, trng->base + STARFIVE_CTRL);
> +	if (!wait_for_completion_timeout(done, timeout)) {
> +		synchronize_irq(trng->irq);
> +		if (!try_wait_for_completion(done))
> +			return -ETIMEDOUT;
> +	}
> =20
>  	return 0;
>  }

[Severity: High]
Can a command that times out while the hardware is still busy leave a late
completion for the next command in starfive_trng_cmd()?

In starfive_trng_read(), non-blocking reads (wait =3D=3D false) pass
timeout =3D STARFIVE_RANDGEN_NOWAIT_TIMEOUT (1 jiffy) to starfive_trng_cmd(=
).
Because wait_for_completion_timeout(done, 1) expires on the very next timer
tick, a call issued right before a tick can time out in microseconds while
the hardware is still executing STARFIVE_CTRL_GENE_RANDNUM
(STARFIVE_STAT_RAND_GENERATING is still set and STARFIVE_ISTAT_RAND_RDY has
not been asserted yet).

When wait_for_completion_timeout() returns 0 while the hardware command is
still in flight, synchronize_irq(trng->irq) returns immediately because the
IRQ line has not been asserted yet, try_wait_for_completion(done) returns
false, and starfive_trng_cmd() returns -ETIMEDOUT and drops trng->lock while
the hardware continues running.

When the next caller enters starfive_trng_cmd(), starfive_trng_idle() only
polls STARFIVE_STAT until STARFIVE_STAT_RAND_GENERATING and
STARFIVE_STAT_RAND_SEEDING clear:

  starfive_trng_cmd()
    starfive_trng_idle() -> returns true once previous command finishes
    reinit_completion(done)
    writel(cmd, trng->base + STARFIVE_CTRL)

If starfive_trng_irq() services the first command's STARFIVE_ISTAT_RAND_RDY
interrupt after reinit_completion(done), it completes trng->random_done for
the second command before the new generation finishes, causing
starfive_trng_read() to copy stale or in-progress data from STARFIVE_RAND0.

A similar race can also affect trng->reseed_done when autoreq or autoage is
configured: an automatic hardware reseed sets STARFIVE_ISTAT_SEED_DONE when
STARFIVE_STAT_RAND_SEEDING clears, which can fire after
starfive_trng_idle() and race with reinit_completion(&trng->reseed_done).

> @@ -238,37 +302,62 @@ static int starfive_trng_init(struct hwrng *rng)
>  		return ret;
>  	}
> =20
> -	/* setup Auto Request/Age register */
> -	writel(autoage, trng->base + STARFIVE_AUTO_AGE);
> -	writel(autoreq, trng->base + STARFIVE_AUTO_RQSTS);
> +	mutex_lock(&trng->lock);
> +
> +	/*
> +	 * The hwrng core can call init again without an intervening
> +	 * cleanup: deselecting and quickly reselecting the device makes
> +	 * cleanup_rng_work() skip ->cleanup() once the refcount is back up.
> +	 * Only bring up the interrupt line once in that case.
> +	 */
> +	if (!trng->initialized) {
> +		starfive_trng_irq_clear(trng);
> +		starfive_trng_hw_setup(trng);
> +
> +		enable_irq(trng->irq);
> +		writel(STARFIVE_IE_ALL, trng->base + STARFIVE_IE);
> +		trng->initialized =3D true;
> +	}
> +
> +	ret =3D starfive_trng_reseed(trng);
> +	if (ret) {
> +		trng->initialized =3D false;
> +		writel(0, trng->base + STARFIVE_IE);
> +		starfive_trng_irq_clear(trng);
> +		disable_irq(trng->irq);
> +	}
[ ... ]
> @@ -301,15 +387,36 @@ static irqreturn_t starfive_trng_irq(int irq, void =
*priv)
>  static void starfive_trng_cleanup(struct hwrng *rng)
>  {
>  	struct starfive_trng *trng =3D to_trng(rng);
> +	bool initialized;
>  	int ret;
> =20
>  	ret =3D pm_runtime_resume_and_get(trng->dev);
> -	if (ret < 0) {
> +	if (ret < 0)
>  		dev_err(trng->dev, "Failed to wake device for cleanup: %d\n", ret);
> -		return;
> +
> +	mutex_lock(&trng->lock);
> +	initialized =3D trng->initialized;
> +	trng->initialized =3D false;
> +	if (ret >=3D 0 && initialized) {
> +		writel(0, trng->base + STARFIVE_IE);
> +		starfive_trng_irq_clear(trng);
>  	}
> +	mutex_unlock(&trng->lock);
> +
> +	/*
> +	 * cleanup also runs after a failed init, which has already undone
> +	 * its enable_irq(). Only disable the line if init left it enabled.
> +	 */
> +	if (initialized)
> +		disable_irq(trng->irq);
> +	cancel_work_sync(&trng->work);
> =20
> +	if (ret < 0)
> +		return;
> +
> +	mutex_lock(&trng->lock);
>  	writel(STARFIVE_CTRL_EXEC_NOP, trng->base + STARFIVE_CTRL);
> +	mutex_unlock(&trng->lock);
> =20
>  	pm_runtime_put_sync_suspend(trng->dev);
>  }
[ ... ]
> @@ -420,6 +566,15 @@ static int starfive_trng_probe(struct platform_devic=
e *pdev)
>  	if (ret)
>  		return dev_err_probe(&pdev->dev, ret, "Failed to enable runtime PM\n");
> =20
> +	ret =3D devm_work_autocancel(&pdev->dev, &trng->work, starfive_trng_res=
eed_work);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D devm_request_irq(&pdev->dev, trng->irq, starfive_trng_irq, IRQF=
_NO_AUTOEN,
> +			       pdev->name, (void *)trng);
> +	if (ret)
> +		return ret;
> +
>  	ret =3D devm_hwrng_register(&pdev->dev, &trng->rng);
>  	if (ret)
>  		return dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
> @@ -432,8 +587,16 @@ static int starfive_trng_probe(struct platform_devic=
e *pdev)
>  static int starfive_trng_suspend(struct device *dev)
>  {
>  	struct starfive_trng *trng =3D dev_get_drvdata(dev);
> +	bool assert_rst;
> +
> +	mutex_lock(&trng->lock);
> +	assert_rst =3D !trng->initialized;
> +	writel(0, trng->base + STARFIVE_IE);
> +	starfive_trng_irq_clear(trng);
> +	mutex_unlock(&trng->lock);
> =20
> -	starfive_trng_power_off(trng, false);
> +	synchronize_irq(trng->irq);
> +	starfive_trng_power_off(trng, assert_rst);
> =20
>  	return 0;
>  }

[Severity: High]
Does calling starfive_trng_irq_clear() when trng->initialized is false allow
trng->work to be queued after it has already been cancelled, leading to a
use-after-free of struct starfive_trng during teardown?

In starfive_trng_irq_clear(), if STARFIVE_ISTAT_LFSR_LOCKUP is set in
STARFIVE_ISTAT, starfive_trng_request_reseed() unconditionally queues
trng->work on system_freezable_wq even when trng->initialized is false.

In starfive_trng_probe(), devm_pm_runtime_set_active_enabled() is registered
before devm_work_autocancel() and devm_request_irq(). During devres teardown
(for example, if devm_hwrng_register() fails after starfive_trng_init()
leaves the device RPM_ACTIVE via pm_runtime_put_autosuspend(), or on driver
unbind after __device_release_driver() resumes the device), devres actions
run in reverse order:

  devm_irq_release() -> frees trng->irq
  devm_work_drop() -> cancel_work_sync(&trng->work)
  pm_runtime_disable_action()
    pm_runtime_dont_use_autosuspend()
      rpm_idle() -> rpm_suspend()
        starfive_trng_suspend()
          starfive_trng_irq_clear() -> queues trng->work
          synchronize_irq(trng->irq)

Because starfive_trng_suspend() runs after devm_irq_release() and
devm_work_drop(), it calls synchronize_irq() on an already-freed IRQ and can
re-queue trng->work right before devres frees struct starfive_trng, causing
starfive_trng_reseed_work() to access freed memory.

Similarly, in starfive_trng_cleanup(), cancel_work_sync(&trng->work) runs
before pm_runtime_put_sync_suspend(trng->dev), which synchronously invokes
starfive_trng_suspend() -> starfive_trng_irq_clear() and can re-queue
trng->work after cleanup cancelled it. And if starfive_trng_reseed() fails
in starfive_trng_init(), the error path calls starfive_trng_irq_clear()
without cancelling trng->work (while hwrng_init() in
drivers/char/hw_random/core.c does not call ->cleanup() on normal ->init()
failure), allowing starfive_trng_reseed_work() to run while
!trng->initialized and call pm_runtime_resume_and_get() ->
starfive_trng_resume() -> starfive_trng_power_on(), deasserting the hardware
reset on an uninitialized device.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023021248.3763=
-1-lianfeng.ouyang@starfivetech.com?part=3D3
