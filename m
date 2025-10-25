Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B753064A1;
	Sat, 25 Oct 2025 16:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408931; cv=none; b=Oae4czvG3N6GwZqFC4FzPSCDhEKRBVADY1WC3pzymcGCjhk/6rOWlskR90ufwaIEOzo4RFXi0D9cR+AZqneezWx0Wb7RkF3hPqQdaIMZtlvrD+fuQ35Ii5m0NBpAE0o5SPPAGcvUGM/ugSxr9pC8nlS5EXt9WLRjWPESUWhV6OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408931; c=relaxed/simple;
	bh=9MZF9AswfuKOW+F/Bi84Zd75DMjYPY7l6W4DWEBpRJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W6jTgCVAyiCdrdDCrZWfudGUf6ZLnX//yoWibMI47ozf5zd/4WjF1GPhu97Zh8GogGMqmSKsbmj9Kq9NbdVo0skL+3hEdbsytSyGOTD+bV8kKAJg7YxbF25jcbvoKIV2tke51fSUgi8/kag8hKMVyl2Qoa9oNWFtcDCQSuw8ENM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uTHgfCVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uTHgfCVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197CAC4CEFB;
	Sat, 25 Oct 2025 16:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408931;
	bh=9MZF9AswfuKOW+F/Bi84Zd75DMjYPY7l6W4DWEBpRJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTHgfCVXwnfYJPXmyAZxDc4kZhiQr1g/+mDjoiXENRfcHJwn1vjNrQqXFhx41hZo1
	 vBTE2YZd2gau4F9ubWBSl0kQiir3dt7PIIoFIjMmqwK65Yk419iQF6yakosPbdpllJ
	 yB7P+4pqsz9m0ndg0OD9kt9Lv3OHW2ovnUjM6+rzWAnyWdtmoTKP01h5I7oOdwU07/
	 B/R0hzhr+CLGYx5BEPm6iDl+WmUg3ZWfMgqfZTzpblERgvN8BeyymhgmkAnkZaCwFZ
	 bmro5VkUrCHMUqNG+2LWL5OuYz/hh7/C8J5Ta2vWxzBGQftH8OQawr25HzGnCjr+09
	 svuywP+FyoePQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xichao Zhao <zhao.xichao@vivo.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	olivia@selenic.com,
	tglx@linutronix.de,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	namcao@linutronix.de,
	u.kleine-koenig@baylibre.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] hwrng: timeriomem - Use us_to_ktime() where appropriate
Date: Sat, 25 Oct 2025 11:56:08 -0400
Message-ID: <20251025160905.3857885-137-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xichao Zhao <zhao.xichao@vivo.com>

[ Upstream commit 817fcdbd4ca29834014a5dadbe8e11efeb12800c ]

It is better to replace ns_to_ktime() with us_to_ktime(),
which can make the code clearer.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: The probe assigns `priv->period` using
  `us_to_ktime(period)` instead of `ns_to_ktime(period *
  NSEC_PER_USEC)`, i.e. a unit conversion moved inside a dedicated
  helper. See `drivers/char/hw_random/timeriomem-rng.c:155` (old code
  shown) and the diff replacing it with `us_to_ktime(period)`.
- Code context shows `period` is specified in microseconds:
  - Read from DT as a 32-bit value “period” and stored into local `int
    period` (microseconds): `drivers/char/hw_random/timeriomem-
    rng.c:137`.
  - Printed as microseconds: `drivers/char/hw_random/timeriomem-
    rng.c:178` (“@ %dus”).
  - The driver later converts `priv->period` back to microseconds to
    sleep between reads: `drivers/char/hw_random/timeriomem-rng.c:50`.
- Why this matters: The old expression performs the multiplication in C
  before passing to `ns_to_ktime`. On 32-bit architectures,
  `NSEC_PER_USEC` is `1000L` (32-bit long), so `period * NSEC_PER_USEC`
  is computed in 32-bit and can overflow when `period > LONG_MAX/1000 ≈
  2,147,483us (~2.147s)`. See `include/vdso/time64.h:8`. That overflow
  would yield an incorrect `priv->period`, which then:
  - Produces a wrong `period_us = ktime_to_us(priv->period)` used in
    `usleep_range()` (timing skew): `drivers/char/hw_random/timeriomem-
    rng.c:50` and `drivers/char/hw_random/timeriomem-rng.c:70-72`.
  - Forwards the hrtimer by a wrong amount via
    `hrtimer_forward_now(&priv->timer, priv->period)`:
    `drivers/char/hw_random/timeriomem-rng.c:86`.
- Why the new helper is safer: `us_to_ktime(u64 us)` multiplies in
  64-bit, avoiding the 32-bit intermediate overflow (see
  `include/linux/ktime.h:225`). Passing the `int period` argument
  promotes it to `u64` before multiplication, making this robust on
  32-bit systems as well.
- Scope and risk:
  - Single-line change in a contained driver
    (`drivers/char/hw_random/timeriomem-rng.c`), no interface/ABI
    changes, no architectural churn.
  - Behavior is unchanged for typical periods (1us–1s), but correctness
    improves for larger microsecond values by eliminating potential
    overflow on 32-bit.
  - No dependency on newer APIs; `us_to_ktime()` exists alongside
    `ns_to_ktime()` in stable trees (`include/linux/ktime.h:225`).
- History/context sanity check: The driver explicitly handles a wide
  range of periods and uses that period both to schedule an hrtimer and
  to compute sleeps, so a wrong `ktime_t` directly affects observable
  timing. Prior fixes to this driver have targeted timing behavior
  (e.g., cooldown tolerance), underscoring that timing correctness
  matters here.

Given the minimal, self-contained nature of the change, its alignment
with existing helper usage elsewhere in the kernel, and its elimination
of a plausible 32-bit overflow hazard, this is a low-risk improvement
with tangible correctness benefits. It is suitable for stable
backporting.

 drivers/char/hw_random/timeriomem-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index b95f6d0f17ede..e61f063932090 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -150,7 +150,7 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 		priv->rng_ops.quality = pdata->quality;
 	}
 
-	priv->period = ns_to_ktime(period * NSEC_PER_USEC);
+	priv->period = us_to_ktime(period);
 	init_completion(&priv->completion);
 	hrtimer_setup(&priv->timer, timeriomem_rng_trigger, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 
-- 
2.51.0

