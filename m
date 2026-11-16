Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794847420;
	b=lIeKwbCQ1COqrGQRYu/EIc0q+uRlCLrtvoeopK6md3vfQ1YyeFTkOMTVhqX1Fep2cbv8
	 usJfLBRguRhi1UEJ0FK8/cn4+svcvX8DCT7U5U2fz93g1v3yIZ9BeCcx6WsDDg1HBMbaB
	 axHrHuqxXdWxCmIP5HDJbsXTB2Qctx3hmzMOxupa/rNxz7hrwB3GGyPprJQsYVtEjRcGI
	 d9onAkWjeN+JDzZIdEHycZWXo47X40xGMOXmvYQyEDAhXRr9WKeMNm7kFZZo3WkG700Zz
	 BrrrFgWamsaP0LDJaesKp2B4Xtqh1Sn2EXfZmh78XrLq7lU2QVvFLz1n/8NEhB0Hd1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794847420;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=qaPKPUdGH924jHLGVu1MUDf3AduWT9UCCqZDZcF7y5E=;
	b=hiYMaeLpIpurnoaOCyhX3r6kl5KEnVrYYwSfmoqpWwqFhnoPhMS0wMISdD+CAvsarhol
	 ruIxRGQotROHYn9i4PXzJEUG9wyeAJ0oNza+JMNmkgPt3o6cC1f9uaX0Ar2hTYEk97eVD
	 MXUAhN2NcRQPmwIF4/Lb4XTf/YYnSGow+T5GZK9I6PZ7H/7aRrNwFd7mgSzBS7CJHPJj6
	 Wp8epDrUK6aGOOt3veLNkvr11ATFjzP8mMjXEm5IRbDH8I6CxSB1M206RcbkAbADeVlGB
	 qIT0gPJi+vP1gVO56qsdhbkbC6WJ9q5vfJ7kEvT5Q45dlYnLbXpheXniCdNrBM0RdXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZKsXDk52;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D919E606A32A;
	Mon, 16 Nov 2026 16:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZKsXDk52
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61931F000C4;
	Mon, 16 Nov 2026 16:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794847420;
	bh=qaPKPUdGH924jHLGVu1MUDf3AduWT9UCCqZDZcF7y5E=;
	h=Date:From:To:Cc:Subject;
	b=ZKsXDk52Gr5sfYnrtJfUMVbuA5zOpi9/bgl94v1M0ywtPY7Sbm/g2IPKmenpnJAzj
	 DQCvQfaCMwx0qnrY5RaExGhb9LWnCcjTewSfbpHcUTbwf9EXjVR//qeiff8dnA7CPi
	 69yJ5LO/Ut0E9Da2DAYRV05wrBUKsKbid4NUEqQPoBP2BYUR4aK+ry+sxtpGz4RRwk
	 yc6g4DQv7LgWfnsh0iZrPPVRJxftDU2J8sMFGSXtub1ECJK4uONonSGuIBN52wt9gV
	 X9QgMlc9fbrQbVWnOR7732k9muH/SXhCunjsIDJQf/LFGKtufpmHt30ON8OlHPjIo9
	 Xxj1k+2zzudAw==
Date: Mon, 16 Nov 2026 16:43:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto List <linux-crypto@vger.kernel.org>
Cc: Kees Cook <kees@kernel.org>, Kees Cook <kees+treewide@kernel.org>,
	Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the crypto tree with the origin tree
Message-ID: <avsytz1IzLXflvSo@sirena.org.uk>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tsgXF2Ef5B65i5il"
Content-Disposition: inline


--tsgXF2Ef5B65i5il
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the crypto tree got a conflict in:

  drivers/char/hw_random/jh7110-trng.c

between commit:

  4dd10fbbeb9c3 ("treewide: Convert devm_kmalloc() family to the devm_kmall=
oc_obj() family")

=66rom the origin tree and commit:

  de5aafa40f37f ("hwrng: starfive - tidy up includes and drop unused code")

=66rom the crypto tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --combined drivers/char/hw_random/jh7110-trng.c
index bc5328566659d,763aacf7dfac6..0000000000000
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@@ -1,25 -1,33 +1,33 @@@
  // SPDX-License-Identifier: GPL-2.0
  /*
-  * TRNG driver for the StarFive JH7110 SoC
+  * TRNG driver for the StarFive JH7110/JHB100 SoCs
   *
   * Copyright (C) 2022 StarFive Technology Co.
   */
 =20
+ #include <linux/bits.h>
  #include <linux/clk.h>
  #include <linux/completion.h>
- #include <linux/delay.h>
+ #include <linux/container_of.h>
+ #include <linux/device.h>
+ #include <linux/devm-helpers.h>
  #include <linux/err.h>
+ #include <linux/errno.h>
  #include <linux/hw_random.h>
  #include <linux/interrupt.h>
  #include <linux/io.h>
  #include <linux/iopoll.h>
- #include <linux/kernel.h>
+ #include <linux/jiffies.h>
+ #include <linux/lockdep.h>
+ #include <linux/minmax.h>
  #include <linux/module.h>
- #include <linux/of.h>
+ #include <linux/mutex.h>
  #include <linux/platform_device.h>
  #include <linux/pm_runtime.h>
- #include <linux/random.h>
+ #include <linux/property.h>
  #include <linux/reset.h>
+ #include <linux/types.h>
+ #include <linux/workqueue.h>
 =20
  /* trng register offset */
  #define STARFIVE_CTRL			0x00
@@@ -78,36 -86,64 +86,64 @@@
  #define STARFIVE_ISTAT_SEED_DONE	BIT(1)
  #define STARFIVE_ISTAT_LFSR_LOCKUP	BIT(4)
 =20
+ #define STARFIVE_ISTAT_ALL		(STARFIVE_ISTAT_RAND_RDY | \
+ 					 STARFIVE_ISTAT_SEED_DONE | \
+ 					 STARFIVE_ISTAT_LFSR_LOCKUP)
+=20
  #define STARFIVE_RAND_LEN		sizeof(u32)
+ #define STARFIVE_RANDRESEED_TIMEOUT_MS	50
+ #define STARFIVE_RANDGEN_TIMEOUT_MS	20
+ #define STARFIVE_RANDGEN_NOWAIT_TIMEOUT	1
 =20
  #define to_trng(p)			container_of(p, struct starfive_trng, rng)
 =20
- enum reseed {
- 	RANDOM_RESEED,
- 	NONCE_RESEED,
- };
-=20
- enum mode {
+ enum starfive_trng_mode {
  	PRNG_128BIT,
  	PRNG_256BIT,
  };
 =20
+ /*
+  * Power-down ordering of reset assertion vs. clock gating:
+  * SEQ_RST_FIRST - assert reset, then gate the clocks (JH7110).
+  * SEQ_CLK_FIRST - gate the clocks, then assert reset (JHB100). Asserting
+  *                 reset with the clocks running causes reset-domain-cros=
sing
+  *                 glitches that can affect downstream IPs.
+  */
+ enum seq_rst_clk {
+ 	SEQ_RST_FIRST,
+ 	SEQ_CLK_FIRST,
+ };
+=20
+ struct starfive_trng_data {
+ 	enum seq_rst_clk	seq_rst_clk;
+ };
+=20
  struct starfive_trng {
  	struct device		*dev;
  	void __iomem		*base;
+ 	int			irq;
  	struct clk		*hclk;
  	struct clk		*ahb;
  	struct reset_control	*rst;
  	struct hwrng		rng;
  	struct completion	random_done;
  	struct completion	reseed_done;
+ 	struct work_struct	work;
+ 	const struct starfive_trng_data *data;
  	u32			mode;
  	u32			mission;
- 	u32			reseed;
- 	/* protects against concurrent write to ctrl register */
- 	spinlock_t		write_lock;
+ 	bool			need_reseed;
+ 	bool			initialized;
+ 	bool			clk_on;
+ 	bool			rst_deassert;
+ 	struct mutex		lock; /* protect trng cmd seq */
  };
 =20
+ static inline struct starfive_trng *work_to_trng(struct work_struct *work)
+ {
+ 	return container_of(work, struct starfive_trng, work);
+ }
+=20
  static u16 autoreq;
  module_param(autoreq, ushort, 0);
  MODULE_PARM_DESC(autoreq, "Auto-reseeding after random number requests by=
 host reaches specified counter:\n"
@@@ -120,113 -156,262 +156,262 @@@ MODULE_PARM_DESC(autoage, "Auto-reseedi
  				" 0 - disable timer\n"
  				" other - reload value for internal timer");
 =20
- static inline int starfive_trng_wait_idle(struct starfive_trng *trng)
+ static bool starfive_trng_idle(struct starfive_trng *trng, bool wait)
  {
- 	u32 stat;
+ 	u32 stat, busy =3D STARFIVE_STAT_RAND_GENERATING | STARFIVE_STAT_RAND_SE=
EDING;
 =20
- 	return readl_relaxed_poll_timeout(trng->base + STARFIVE_STAT, stat,
- 					  !(stat & (STARFIVE_STAT_RAND_GENERATING |
- 						    STARFIVE_STAT_RAND_SEEDING)),
- 					  10, 100000);
- }
-=20
- static inline void starfive_trng_irq_mask_clear(struct starfive_trng *trn=
g)
- {
- 	/* clear register: ISTAT */
- 	u32 data =3D readl(trng->base + STARFIVE_ISTAT);
-=20
- 	writel(data, trng->base + STARFIVE_ISTAT);
- }
-=20
- static int starfive_trng_cmd(struct starfive_trng *trng, u32 cmd, bool wa=
it)
- {
- 	int wait_time =3D 1000;
-=20
- 	/* allow up to 40 us for wait =3D=3D 0 */
  	if (!wait)
- 		wait_time =3D 40;
+ 		return !(readl_relaxed(trng->base + STARFIVE_STAT) & busy);
+=20
+ 	return !readl_relaxed_poll_timeout(trng->base + STARFIVE_STAT, stat,
+ 					   !(stat & busy),
+ 					   10, 100000);
+ }
+=20
+ /*
+  * Record a pending LFSR lockup and make sure it gets serviced. queue_wor=
k()
+  * is a no-op while the work is already pending, so this is safe to call
+  * from any context that notices the lockup.
+  */
+ static void starfive_trng_request_reseed(struct starfive_trng *trng)
+ {
+ 	WRITE_ONCE(trng->need_reseed, true);
+ 	queue_work(system_freezable_wq, &trng->work);
+ }
+=20
+ static void starfive_trng_irq_clear(struct starfive_trng *trng)
+ {
+ 	u32 istat =3D readl(trng->base + STARFIVE_ISTAT);
+=20
+ 	/* Do not lose an LFSR lockup that has not been serviced yet. */
+ 	if ((istat & STARFIVE_ISTAT_LFSR_LOCKUP) && trng->initialized)
+ 		starfive_trng_request_reseed(trng);
+=20
+ 	writel(istat, trng->base + STARFIVE_ISTAT);
+ }
+=20
+ static int starfive_trng_power_on(struct starfive_trng *trng)
+ {
+ 	int ret;
+=20
+ 	if (!trng->clk_on) {
+ 		ret =3D clk_prepare_enable(trng->hclk);
+ 		if (ret)
+ 			goto err_hclk;
+=20
+ 		ret =3D clk_prepare_enable(trng->ahb);
+ 		if (ret)
+ 			goto err_ahb;
+=20
+ 		trng->clk_on =3D true;
+ 	}
+=20
+ 	if (!trng->rst_deassert) {
+ 		ret =3D reset_control_deassert(trng->rst);
+ 		if (ret)
+ 			goto err_rst;
+=20
+ 		trng->rst_deassert =3D true;
+ 	}
+=20
+ 	return 0;
+=20
+ err_rst:
+ 	clk_disable_unprepare(trng->ahb);
+ err_ahb:
+ 	clk_disable_unprepare(trng->hclk);
+ 	trng->clk_on =3D false;
+ err_hclk:
+ 	return ret;
+ }
+=20
+ static void starfive_trng_power_off(struct starfive_trng *trng, bool asse=
rt_rst)
+ {
+ 	bool clk_first =3D trng->data->seq_rst_clk =3D=3D SEQ_CLK_FIRST;
+ 	bool do_rst =3D assert_rst && trng->rst_deassert;
+=20
+ 	if (do_rst && !clk_first) {
+ 		reset_control_assert(trng->rst);
+ 		trng->rst_deassert =3D false;
+ 	}
+=20
+ 	if (trng->clk_on) {
+ 		clk_disable_unprepare(trng->ahb);
+ 		clk_disable_unprepare(trng->hclk);
+ 		trng->clk_on =3D false;
+ 	}
+=20
+ 	if (do_rst && clk_first) {
+ 		reset_control_assert(trng->rst);
+ 		trng->rst_deassert =3D false;
+ 	}
+ }
+=20
+ static void starfive_trng_power_off_action(void *data)
+ {
+ 	starfive_trng_power_off(data, true);
+ }
+=20
+ static int starfive_trng_cmd(struct starfive_trng *trng, u32 cmd, unsigne=
d long timeout, bool wait)
+ {
+ 	struct completion *done;
+=20
+ 	lockdep_assert_held(&trng->lock);
+=20
+ 	if (!starfive_trng_idle(trng, wait))
+ 		return wait ? -ETIMEDOUT : -EBUSY;
 =20
  	switch (cmd) {
  	case STARFIVE_CTRL_GENE_RANDNUM:
- 		reinit_completion(&trng->random_done);
- 		spin_lock_irq(&trng->write_lock);
- 		writel(cmd, trng->base + STARFIVE_CTRL);
- 		spin_unlock_irq(&trng->write_lock);
- 		if (!wait_for_completion_timeout(&trng->random_done, usecs_to_jiffies(w=
ait_time)))
- 			return -ETIMEDOUT;
+ 		done =3D &trng->random_done;
  		break;
  	case STARFIVE_CTRL_EXEC_RANDRESEED:
- 		reinit_completion(&trng->reseed_done);
- 		spin_lock_irq(&trng->write_lock);
- 		writel(cmd, trng->base + STARFIVE_CTRL);
- 		spin_unlock_irq(&trng->write_lock);
- 		if (!wait_for_completion_timeout(&trng->reseed_done, usecs_to_jiffies(w=
ait_time)))
- 			return -ETIMEDOUT;
+ 		done =3D &trng->reseed_done;
  		break;
  	default:
  		return -EINVAL;
  	}
 =20
+ 	/*
+ 	 * A command that timed out earlier may still have its completion
+ 	 * interrupt in flight. Ack the status bits and flush the handler so
+ 	 * a late RAND_RDY/SEED_DONE cannot complete this command.
+ 	 */
+ 	writel(STARFIVE_ISTAT_RAND_RDY | STARFIVE_ISTAT_SEED_DONE,
+ 	       trng->base + STARFIVE_ISTAT);
+ 	synchronize_irq(trng->irq);
+=20
+ 	reinit_completion(done);
+ 	writel(cmd, trng->base + STARFIVE_CTRL);
+ 	if (!wait_for_completion_timeout(done, timeout)) {
+ 		synchronize_irq(trng->irq);
+ 		if (!try_wait_for_completion(done))
+ 			return -ETIMEDOUT;
+ 	}
+=20
  	return 0;
  }
 =20
- static int starfive_trng_init(struct hwrng *rng)
+ static int starfive_trng_reseed(struct starfive_trng *trng)
  {
- 	struct starfive_trng *trng =3D to_trng(rng);
- 	u32 mode, intr =3D 0;
+ 	int ret;
+=20
+ 	lockdep_assert_held(&trng->lock);
+=20
+ 	WRITE_ONCE(trng->need_reseed, false);
+ 	ret =3D starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED,
+ 				msecs_to_jiffies(STARFIVE_RANDRESEED_TIMEOUT_MS), true);
+ 	if (ret)
+ 		WRITE_ONCE(trng->need_reseed, true);
+=20
+ 	return ret;
+ }
+=20
+ static void starfive_trng_hw_setup(struct starfive_trng *trng)
+ {
+ 	u32 mode;
 =20
  	/* setup Auto Request/Age register */
  	writel(autoage, trng->base + STARFIVE_AUTO_AGE);
  	writel(autoreq, trng->base + STARFIVE_AUTO_RQSTS);
 =20
- 	/* clear register: ISTAT */
- 	starfive_trng_irq_mask_clear(trng);
-=20
- 	intr |=3D STARFIVE_IE_ALL;
- 	writel(intr, trng->base + STARFIVE_IE);
-=20
- 	mode  =3D readl(trng->base + STARFIVE_MODE);
-=20
- 	switch (trng->mode) {
- 	case PRNG_128BIT:
+ 	mode =3D readl(trng->base + STARFIVE_MODE);
+ 	if (trng->mode =3D=3D PRNG_128BIT)
  		mode &=3D ~STARFIVE_MODE_R256;
- 		break;
- 	case PRNG_256BIT:
+ 	else
  		mode |=3D STARFIVE_MODE_R256;
- 		break;
- 	default:
- 		mode |=3D STARFIVE_MODE_R256;
- 		break;
+ 	writel(mode, trng->base + STARFIVE_MODE);
+ }
+=20
+ static int starfive_trng_init(struct hwrng *rng)
+ {
+ 	struct starfive_trng *trng =3D to_trng(rng);
+ 	int ret;
+=20
+ 	ret =3D pm_runtime_resume_and_get(trng->dev);
+ 	if (ret < 0) {
+ 		dev_err(trng->dev, "Failed to wake device for init: %d\n", ret);
+ 		return ret;
  	}
 =20
- 	writel(mode, trng->base + STARFIVE_MODE);
+ 	mutex_lock(&trng->lock);
 =20
- 	return starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED, 1);
+ 	/*
+ 	 * The hwrng core can call init again without an intervening
+ 	 * cleanup: deselecting and quickly reselecting the device makes
+ 	 * cleanup_rng_work() skip ->cleanup() once the refcount is back up.
+ 	 * Only bring up the interrupt line once in that case.
+ 	 */
+ 	if (!trng->initialized) {
+ 		starfive_trng_irq_clear(trng);
+ 		starfive_trng_hw_setup(trng);
+=20
+ 		enable_irq(trng->irq);
+ 		writel(STARFIVE_IE_ALL, trng->base + STARFIVE_IE);
+ 		trng->initialized =3D true;
+ 	}
+=20
+ 	ret =3D starfive_trng_reseed(trng);
+ 	if (ret) {
+ 		trng->initialized =3D false;
+ 		writel(0, trng->base + STARFIVE_IE);
+ 		starfive_trng_irq_clear(trng);
+ 		disable_irq(trng->irq);
+ 	}
+=20
+ 	mutex_unlock(&trng->lock);
+=20
+ 	pm_runtime_put_autosuspend(trng->dev);
+=20
+ 	return ret;
+ }
+=20
+ static void starfive_trng_reseed_work(struct work_struct *work)
+ {
+ 	struct starfive_trng *trng =3D work_to_trng(work);
+ 	int ret;
+=20
+ 	ret =3D pm_runtime_resume_and_get(trng->dev);
+ 	if (ret < 0) {
+ 		dev_err(trng->dev, "Failed to wake device for reseed: %d\n", ret);
+ 		return;
+ 	}
+=20
+ 	mutex_lock(&trng->lock);
+=20
+ 	if (!READ_ONCE(trng->need_reseed) || !trng->initialized)
+ 		goto unlock;
+=20
+ 	ret =3D starfive_trng_reseed(trng);
+ 	if (ret)
+ 		dev_err(trng->dev, "Reseed after LFSR lockup failed: %d\n", ret);
+=20
+ unlock:
+ 	mutex_unlock(&trng->lock);
+=20
+ 	pm_runtime_put_autosuspend(trng->dev);
  }
 =20
  static irqreturn_t starfive_trng_irq(int irq, void *priv)
  {
  	u32 status;
- 	struct starfive_trng *trng =3D (struct starfive_trng *)priv;
+ 	struct starfive_trng *trng =3D priv;
 =20
- 	status =3D readl(trng->base + STARFIVE_ISTAT);
- 	if (status & STARFIVE_ISTAT_RAND_RDY) {
- 		writel(STARFIVE_ISTAT_RAND_RDY, trng->base + STARFIVE_ISTAT);
+ 	status =3D readl(trng->base + STARFIVE_ISTAT) & STARFIVE_ISTAT_ALL;
+ 	if (!status)
+ 		return IRQ_NONE;
+=20
+ 	writel(status, trng->base + STARFIVE_ISTAT);
+=20
+ 	/* SEU occurred, reseeding required */
+ 	if (status & STARFIVE_ISTAT_LFSR_LOCKUP)
+ 		starfive_trng_request_reseed(trng);
+=20
+ 	if (status & STARFIVE_ISTAT_RAND_RDY)
  		complete(&trng->random_done);
- 	}
 =20
- 	if (status & STARFIVE_ISTAT_SEED_DONE) {
- 		writel(STARFIVE_ISTAT_SEED_DONE, trng->base + STARFIVE_ISTAT);
+ 	if (status & STARFIVE_ISTAT_SEED_DONE)
  		complete(&trng->reseed_done);
- 	}
-=20
- 	if (status & STARFIVE_ISTAT_LFSR_LOCKUP) {
- 		writel(STARFIVE_ISTAT_LFSR_LOCKUP, trng->base + STARFIVE_ISTAT);
- 		/* SEU occurred, reseeding required*/
- 		spin_lock(&trng->write_lock);
- 		writel(STARFIVE_CTRL_EXEC_RANDRESEED, trng->base + STARFIVE_CTRL);
- 		spin_unlock(&trng->write_lock);
- 	}
 =20
  	return IRQ_HANDLED;
  }
@@@ -234,181 -419,267 +419,267 @@@
  static void starfive_trng_cleanup(struct hwrng *rng)
  {
  	struct starfive_trng *trng =3D to_trng(rng);
+ 	bool initialized;
+ 	int ret;
 =20
- 	writel(0, trng->base + STARFIVE_CTRL);
+ 	ret =3D pm_runtime_resume_and_get(trng->dev);
+ 	if (ret < 0)
+ 		dev_err(trng->dev, "Failed to wake device for cleanup: %d\n", ret);
 =20
- 	reset_control_assert(trng->rst);
- 	clk_disable_unprepare(trng->hclk);
- 	clk_disable_unprepare(trng->ahb);
+ 	mutex_lock(&trng->lock);
+ 	initialized =3D trng->initialized;
+ 	trng->initialized =3D false;
+ 	if (ret >=3D 0 && initialized) {
+ 		writel(0, trng->base + STARFIVE_IE);
+ 		starfive_trng_irq_clear(trng);
+ 	}
+ 	mutex_unlock(&trng->lock);
+=20
+ 	/*
+ 	 * cleanup also runs after a failed init, which has already undone
+ 	 * its enable_irq(). Only disable the line if init left it enabled.
+ 	 */
+ 	if (initialized)
+ 		disable_irq(trng->irq);
+ 	cancel_work_sync(&trng->work);
+=20
+ 	if (ret < 0)
+ 		return;
+=20
+ 	mutex_lock(&trng->lock);
+ 	writel(STARFIVE_CTRL_EXEC_NOP, trng->base + STARFIVE_CTRL);
+ 	mutex_unlock(&trng->lock);
+=20
+ 	pm_runtime_put_sync_suspend(trng->dev);
  }
 =20
  static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, b=
ool wait)
  {
  	struct starfive_trng *trng =3D to_trng(rng);
- 	int ret;
+ 	unsigned long timeout;
+ 	int ret, retry =3D 1;
 =20
- 	pm_runtime_get_sync(trng->dev);
-=20
- 	if (trng->mode =3D=3D PRNG_256BIT)
- 		max =3D min_t(size_t, max, (STARFIVE_RAND_LEN * 8));
- 	else
- 		max =3D min_t(size_t, max, (STARFIVE_RAND_LEN * 4));
+ 	ret =3D pm_runtime_resume_and_get(trng->dev);
+ 	if (ret < 0) {
+ 		dev_warn_ratelimited(trng->dev, "Failed to wake device for read: %d\n",=
 ret);
+ 		return ret;
+ 	}
 =20
  	if (wait) {
- 		ret =3D starfive_trng_wait_idle(trng);
- 		if (ret) {
- 			ret =3D -ETIMEDOUT;
+ 		mutex_lock(&trng->lock);
+ 		timeout =3D msecs_to_jiffies(STARFIVE_RANDGEN_TIMEOUT_MS);
+ 	} else {
+ 		/* allow up to 1 jiffy for wait =3D=3D 0 */
+ 		if (!mutex_trylock(&trng->lock)) {
+ 			ret =3D 0;
  			goto out_put;
  		}
+ 		timeout =3D STARFIVE_RANDGEN_NOWAIT_TIMEOUT;
+ 	}
+=20
+ 	for (;;) {
+ 		/*
+ 		 * A pending LFSR lockup taints the next sample. Blocking
+ 		 * callers reseed here; non-blocking callers return no data
+ 		 * and leave it to the reseed work. Re-queue it explicitly:
+ 		 * the lockup may have been seen by starfive_trng_irq_clear()
+ 		 * or a previous reseed attempt may have failed.
+ 		 */
+ 		if (READ_ONCE(trng->need_reseed)) {
+ 			if (!wait) {
+ 				starfive_trng_request_reseed(trng);
+ 				ret =3D 0;
+ 				goto out_unlock;
+ 			}
+ 			ret =3D starfive_trng_reseed(trng);
+ 			if (ret)
+ 				goto out_unlock;
+ 		}
+=20
+ 		ret =3D starfive_trng_cmd(trng, STARFIVE_CTRL_GENE_RANDNUM, timeout, wa=
it);
+ 		if (ret) {
+ 			if (!wait && (ret =3D=3D -EBUSY || ret =3D=3D -ETIMEDOUT))
+ 				ret =3D 0;
+ 			goto out_unlock;
+ 		}
+=20
+ 		/* Lockup reported together with RAND_RDY: reseed and retry once */
+ 		if (!READ_ONCE(trng->need_reseed))
+ 			break;
+=20
+ 		if (!wait || !retry--) {
+ 			ret =3D 0;
+ 			goto out_unlock;
+ 		}
  	}
 =20
- 	ret =3D starfive_trng_cmd(trng, STARFIVE_CTRL_GENE_RANDNUM, wait);
- 	if (ret)
- 		goto out_put;
+ 	if (trng->mode =3D=3D PRNG_256BIT)
+ 		max =3D min(max, STARFIVE_RAND_LEN * 8);
+ 	else
+ 		max =3D min(max, STARFIVE_RAND_LEN * 4);
 =20
  	memcpy_fromio(buf, trng->base + STARFIVE_RAND0, max);
+=20
  	ret =3D max;
 =20
+ out_unlock:
+ 	mutex_unlock(&trng->lock);
+=20
  out_put:
- 	pm_runtime_put_sync_autosuspend(trng->dev);
+ 	pm_runtime_put_autosuspend(trng->dev);
+=20
  	return ret;
  }
 =20
  static int starfive_trng_probe(struct platform_device *pdev)
  {
- 	int ret;
- 	int irq;
+ 	struct device *dev =3D &pdev->dev;
  	struct starfive_trng *trng;
+ 	int ret;
 =20
- 	trng =3D devm_kzalloc_obj(&pdev->dev, *trng);
 -	trng =3D devm_kzalloc(dev, sizeof(*trng), GFP_KERNEL);
++	trng =3D devm_kzalloc_obj(dev, *trng);
  	if (!trng)
  		return -ENOMEM;
 =20
  	platform_set_drvdata(pdev, trng);
- 	trng->dev =3D &pdev->dev;
+=20
+ 	trng->dev =3D dev;
+ 	trng->data =3D device_get_match_data(dev);
+ 	if (!trng->data)
+ 		return dev_err_probe(dev, -ENODEV, "No match data\n");
 =20
  	trng->base =3D devm_platform_ioremap_resource(pdev, 0);
  	if (IS_ERR(trng->base))
- 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->base),
- 				     "Error remapping memory for platform device.\n");
+ 		return dev_err_probe(dev, PTR_ERR(trng->base),
+ 				     "Error remapping memory for platform device\n");
 =20
- 	irq =3D platform_get_irq(pdev, 0);
- 	if (irq < 0)
- 		return irq;
+ 	trng->irq =3D platform_get_irq(pdev, 0);
+ 	if (trng->irq < 0)
+ 		return trng->irq;
 =20
  	init_completion(&trng->random_done);
  	init_completion(&trng->reseed_done);
- 	spin_lock_init(&trng->write_lock);
 =20
- 	ret =3D devm_request_irq(&pdev->dev, irq, starfive_trng_irq, 0, pdev->na=
me,
- 			       (void *)trng);
+ 	ret =3D devm_mutex_init(dev, &trng->lock);
  	if (ret)
  		return ret;
 =20
- 	trng->hclk =3D devm_clk_get(&pdev->dev, "hclk");
+ 	trng->hclk =3D devm_clk_get(dev, "hclk");
  	if (IS_ERR(trng->hclk))
- 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->hclk),
+ 		return dev_err_probe(dev, PTR_ERR(trng->hclk),
  				     "Error getting hardware reference clock\n");
 =20
- 	trng->ahb =3D devm_clk_get(&pdev->dev, "ahb");
+ 	trng->ahb =3D devm_clk_get(dev, "ahb");
  	if (IS_ERR(trng->ahb))
- 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->ahb),
+ 		return dev_err_probe(dev, PTR_ERR(trng->ahb),
  				     "Error getting ahb reference clock\n");
 =20
- 	trng->rst =3D devm_reset_control_get_shared(&pdev->dev, NULL);
+ 	trng->rst =3D devm_reset_control_get_shared(dev, NULL);
  	if (IS_ERR(trng->rst))
- 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->rst),
+ 		return dev_err_probe(dev, PTR_ERR(trng->rst),
  				     "Error getting hardware reset line\n");
 =20
- 	ret =3D clk_prepare_enable(trng->hclk);
+ 	ret =3D starfive_trng_power_on(trng);
+ 	if (ret)
+ 		return dev_err_probe(dev, ret, "Failed to power on\n");
+=20
+ 	ret =3D devm_add_action_or_reset(dev, starfive_trng_power_off_action, tr=
ng);
  	if (ret)
  		return ret;
 =20
- 	ret =3D clk_prepare_enable(trng->ahb);
- 	if (ret)
- 		goto disable_hclk;
-=20
- 	ret =3D reset_control_deassert(trng->rst);
- 	if (ret)
- 		goto disable_ahb;
-=20
- 	trng->rng.name =3D dev_driver_string(&pdev->dev);
+ 	trng->rng.name =3D dev_driver_string(dev);
  	trng->rng.init =3D starfive_trng_init;
  	trng->rng.cleanup =3D starfive_trng_cleanup;
  	trng->rng.read =3D starfive_trng_read;
 =20
  	trng->mode =3D PRNG_256BIT;
  	trng->mission =3D 1;
- 	trng->reseed =3D RANDOM_RESEED;
 =20
- 	pm_runtime_use_autosuspend(&pdev->dev);
- 	pm_runtime_set_autosuspend_delay(&pdev->dev, 100);
- 	pm_runtime_enable(&pdev->dev);
+ 	pm_runtime_use_autosuspend(dev);
+ 	pm_runtime_set_autosuspend_delay(dev, 100);
 =20
- 	ret =3D devm_hwrng_register(&pdev->dev, &trng->rng);
- 	if (ret) {
- 		pm_runtime_disable(&pdev->dev);
+ 	ret =3D devm_pm_runtime_set_active_enabled(dev);
+ 	if (ret)
+ 		return dev_err_probe(dev, ret, "Failed to enable runtime PM\n");
 =20
- 		reset_control_assert(trng->rst);
- 		ret =3D dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
- 		goto disable_ahb;
- 	}
+ 	ret =3D devm_work_autocancel(dev, &trng->work, starfive_trng_reseed_work=
);
+ 	if (ret)
+ 		return ret;
+=20
+ 	ret =3D devm_request_irq(dev, trng->irq, starfive_trng_irq, IRQF_NO_AUTO=
EN,
+ 			       dev_name(dev), trng);
+ 	if (ret)
+ 		return ret;
+=20
+ 	ret =3D devm_hwrng_register(dev, &trng->rng);
+ 	if (ret)
+ 		return dev_err_probe(dev, ret, "Failed to register hwrng\n");
+=20
+ 	pm_runtime_idle(dev);
 =20
  	return 0;
-=20
- disable_ahb:
- 	clk_disable_unprepare(trng->ahb);
- disable_hclk:
- 	clk_disable_unprepare(trng->hclk);
-=20
- 	return ret;
  }
 =20
- static int __maybe_unused starfive_trng_suspend(struct device *dev)
+ static int starfive_trng_suspend(struct device *dev)
  {
  	struct starfive_trng *trng =3D dev_get_drvdata(dev);
+ 	bool assert_rst;
 =20
- 	clk_disable_unprepare(trng->hclk);
- 	clk_disable_unprepare(trng->ahb);
+ 	mutex_lock(&trng->lock);
+ 	assert_rst =3D !trng->initialized;
+ 	writel(0, trng->base + STARFIVE_IE);
+ 	starfive_trng_irq_clear(trng);
+ 	mutex_unlock(&trng->lock);
+=20
+ 	synchronize_irq(trng->irq);
+ 	starfive_trng_power_off(trng, assert_rst);
 =20
  	return 0;
  }
 =20
- static int __maybe_unused starfive_trng_resume(struct device *dev)
+ static int starfive_trng_resume(struct device *dev)
  {
  	struct starfive_trng *trng =3D dev_get_drvdata(dev);
  	int ret;
 =20
- 	ret =3D clk_prepare_enable(trng->hclk);
- 	if (ret)
+ 	ret =3D starfive_trng_power_on(trng);
+ 	if (ret) {
+ 		dev_err(dev, "Failed to power on: %d\n", ret);
  		return ret;
+ 	}
 =20
- 	ret =3D clk_prepare_enable(trng->ahb);
- 	if (ret)
- 		clk_disable_unprepare(trng->hclk);
+ 	if (trng->initialized) {
+ 		starfive_trng_irq_clear(trng);
+ 		writel(STARFIVE_IE_ALL, trng->base + STARFIVE_IE);
+ 	}
 =20
- 	return ret;
+ 	return 0;
  }
 =20
- static const struct dev_pm_ops starfive_trng_pm_ops =3D {
- 	SET_SYSTEM_SLEEP_PM_OPS(starfive_trng_suspend,
- 				starfive_trng_resume)
- 	SET_RUNTIME_PM_OPS(starfive_trng_suspend,
- 			   starfive_trng_resume, NULL)
+ static const struct starfive_trng_data jh7110_data =3D {
+ 	.seq_rst_clk =3D SEQ_RST_FIRST,
  };
 =20
- static const struct of_device_id trng_dt_ids[] __maybe_unused =3D {
- 	{ .compatible =3D "starfive,jh7110-trng" },
+ static const struct starfive_trng_data jhb100_data =3D {
+ 	.seq_rst_clk =3D SEQ_CLK_FIRST,
+ };
+=20
+ static const struct of_device_id trng_dt_ids[] =3D {
+ 	{ .compatible =3D "starfive,jh7110-trng", .data =3D &jh7110_data },
+ 	{ .compatible =3D "starfive,jhb100-trng", .data =3D &jhb100_data },
  	{ }
  };
  MODULE_DEVICE_TABLE(of, trng_dt_ids);
 =20
+ static DEFINE_RUNTIME_DEV_PM_OPS(starfive_trng_pm_ops,
+ 				 starfive_trng_suspend, starfive_trng_resume, NULL);
+=20
  static struct platform_driver starfive_trng_driver =3D {
  	.probe	=3D starfive_trng_probe,
  	.driver	=3D {
  		.name		=3D "jh7110-trng",
- 		.pm		=3D &starfive_trng_pm_ops,
- 		.of_match_table	=3D of_match_ptr(trng_dt_ids),
+ 		.pm		=3D pm_ptr(&starfive_trng_pm_ops),
+ 		.of_match_table	=3D trng_dt_ids,
  	},
  };
 =20

--tsgXF2Ef5B65i5il
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmr7MrcACgkQJNaLcl1U
h9CWXgf9Gukity4U1K165ClrlMtDL1zrrKIrIRVWQBBSrjGwNb0Toho70a4Gyp5W
KXRrAEb7NSYs9ldxwXXn7MYtqVmMS7/ILTjQ92mXnzdMYuwYMfVpbY8CRTq4/Gyj
SnvuPxTxbpagVi1eXlPZt9bLjQZplSQEfxLf/oBarYytTtd8ltDRAFJX38o+E54E
RA7fYaWAmzI1gI3cqcpbYBaECL9wqIdq/ydqZ2tpjn+TJm85IuuKRS0YUeIMqkjN
X79XF95aGDfliCpRA7ufB1s5ZM1y2lRUJauSsD6cIwGgrsEHu2ED3FlCiZzQYe5M
ENTg7myqGY7YmjraiVr/PdzbZPmSiw==
=x3dq
-----END PGP SIGNATURE-----

--tsgXF2Ef5B65i5il--
