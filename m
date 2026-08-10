Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139D23A453B;
	Mon, 10 Aug 2026 08:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350470; cv=none; b=YiWzPdiwcAJKsi4R6nr2GtXSaf8m8qyLGOum7CH+MwDneCvNiLLa+vN3eyEPY/eTyMAGOG58DtwG59Q4wwXbnabEkgzXr0L2t2kGOOfJjpBhGJLVLO7BWQX9efWkHJRmpMqG/HR0d2A6I8Ny03OGRMBsJFaWCO7HK89Q3lQoASA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350470; c=relaxed/simple;
	bh=XVEE4UnD5PYrIi5jo5o6ydv1EK0xOjDreKgjlkoSnQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lwFz37znc1ocG9qsf4WVHeId7X7kMgkB3joIJt1z26cIMzAeIKXOPSnERr85gJcf90w59Q3AceisANbPhlk4gLuM6kWNrg+AYkp3OHb/S1hRhXam9tBAUtEmMhcadT9XHVid9USLvxMOltw0ZA6dU7sROl3ofe17cX+38vV2j0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=m6qZUXhH; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="m6qZUXhH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/F1e77TPvuR0TBYrkl3P9k0NERk+KajiE/8B/DaE2mI=; 
	b=m6qZUXhHVWb0yi2ag6E8GngJhCUEWnkWDU4sl/t1mUGgsvzzVWCvu5EmjJ9M8tq7dnvZwkmamX5
	pGSTdSHgQtGk5a6japtvaiuGg4u/NQUDgx9Gohyt7PMAKoaVo6u1WKFWkLpJVi9QZQoTseBX02iPp
	X5pMqHMQIghNjD4dl0CzIO43rmTurvM4IMwQko9PFxnKqzMPghBD+bH6S8NbPtOZ+BKdHDYB7gLLr
	1Dlwc4NYU+BouFrPFhiYZnWp2FO/hojW3tcov6ULpCt02RQ+zqfdT40w9CKFzRJIuRVRKo/x/LMv6
	ZdkkNZeEg0YTd3cPC9ilYDpHGlts4Lxlp0tA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtLMF-00000003Wex-22Tn;
	Mon, 10 Aug 2026 16:27:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:27:43 +1000
Date: Mon, 10 Aug 2026 18:27:43 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Bartosz Golaszewski <brgl@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Udit Tiwari <udit.tiwari@oss.qualcomm.com>,
	Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Subject: Re: [Patch v9] crypto: qce - Add runtime PM and interconnect
 bandwidth scaling support
Message-ID: <anmLfyaF1vUNDqNe@gondor.apana.org.au>
References: <20260729110455.641256-1-kuldeep.singh@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729110455.641256-1-kuldeep.singh@oss.qualcomm.com>

On Wed, Jul 29, 2026 at 04:34:55PM +0530, Kuldeep Singh wrote:
> From: Udit Tiwari <udit.tiwari@oss.qualcomm.com>
> 
> The Qualcomm Crypto Engine (QCE) driver currently lacks support for
> runtime power management (PM) and interconnect bandwidth control.
> As a result, the hardware remains fully powered and clocks stay
> enabled even when the device is idle. Additionally, static
> interconnect bandwidth votes are held indefinitely, preventing the
> system from reclaiming unused bandwidth.
> 
> Address this by enabling runtime PM and dynamic interconnect
> bandwidth scaling to allow the system to suspend the device when idle
> and scale interconnect usage based on actual demand. Improve overall
> system efficiency by reducing power usage and optimizing interconnect
> resource allocation.
> 
> Signed-off-by: Udit Tiwari <udit.tiwari@oss.qualcomm.com>
> Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---
> I am taking care of follow-up of this patch from the original author,
> with their consent, while preserving the original authorship.
> 
> Changes in v9:
> - Rebase to latest linux-next/master(tag: next-20260728).
> - Link to v8:
>   https://lore.kernel.org/linux-arm-msm/20260517105233.807935-1-udit.tiwari@oss.qualcomm.com/
> 
> Changes in v8:
> - Drop pm_clk framework (devm_pm_clk_create/pm_clk_add/pm_clk_suspend/
>   pm_clk_resume); use devm_clk_get_optional() and direct
>   clk_prepare_enable()/clk_disable_unprepare() in runtime PM callbacks.
>   This removes the CONFIG_PM_CLK dependency and the build error reported
>   by the kernel test robot.
> - Replace icc_disable() with icc_set_bw(path, 0, 0) in runtime suspend
>   to avoid corrupting the internal 'enabled' flag, which would cause
>   subsequent icc_set_bw() calls in resume to be silently skipped during
>   aggregation.
> - Fix ICC vote ordering: cast bandwidth vote before enabling clocks in
>   resume; disable clocks before dropping ICC vote in suspend.
> - Use PM_RUNTIME_ACQUIRE_AUTOSUSPEND()/PM_RUNTIME_ACQUIRE_ERR() wrapper
>   macros instead of raw ACQUIRE() in both qce_handle_queue() and probe.
> - Drop __maybe_unused from runtime PM callbacks; use RUNTIME_PM_OPS /
>   SYSTEM_SLEEP_PM_OPS (non-SET_ prefix) and pm_ptr(&qce_crypto_pm_ops).
> - Drop unnecessary ret = 0 initializations in qce_handle_queue() and
>   qce_runtime_resume().
> - Extend probe comment to explain ICC + clock ordering rationale.
> - Link to v7:
>   https://lore.kernel.org/lkml/20260220072818.2921517-1-quic_utiwari@quicinc.com/
> 
> Changes in v7:
> - Use ACQUIRE guard in probe to simplify runtime PM management and error
>   paths.
> - Drop redundant icc_enable() call in runtime resume path.
> - Explicitly call pm_clk_suspend(dev) and pm_clk_resume(dev) within the
>   custom runtime PM callbacks. Since custom callbacks are provided to
>   handle interconnect scaling, the standard PM clock helpers must be
>   invoked manually to ensure clocks are gated/ungated.
> - Link to v6:
>  https://lore.kernel.org/lkml/20260210061437.2293654-1-quic_utiwari@quicinc.com/
> 
> Changes in v6:
> - Adopt ACQUIRE(pm_runtime_active_try, ...) for scoped runtime PM
>   management in qce_handle_queue(). This removes the need for manual
>   put calls and goto labels in the error paths, as suggested by Konrad.
> - Link to v5:
>   https://lore.kernel.org/lkml/20251120062443.2016084-1-quic_utiwari@quicinc.com/
> 
> Changes in v5:
> - Drop Reported-by and Closes tags for kernel test robot W=1 warnings,
>   as the issue was fixed within the same patch series.
> - Fix a minor comment indentation/style issue.
> - Link to v4:
>   https://lore.kernel.org/lkml/20251117062737.3946074-1-quic_utiwari@quicinc.com/
> 
> Changes in v4:
> - Annotate runtime PM callbacks with __maybe_unused to silence W=1
>   warnings.
> - Add Reported-by and Closes tags for kernel test robot warning.
> - Link to v3:
>   https://lore.kernel.org/lkml/20251115084851.2750446-1-quic_utiwari@quicinc.com/
> 
> Changes in v3:
> - Switch from manual clock management to PM clock helpers
>   (devm_pm_clk_create() + pm_clk_add()); no direct clk_* enable/disable
>   in runtime callbacks.
> - Replace pm_runtime_get_sync() with pm_runtime_resume_and_get(); remove
>   pm_runtime_put_noidle() on error.
> - Define PM ops using helper macros and reuse runtime callbacks for
>   system sleep via pm_runtime_force_suspend()/pm_runtime_force_resume().
> - Link to v2:
>   https://lore.kernel.org/lkml/20250826110917.3383061-1-quic_utiwari@quicinc.com/
> 
> Changes in v2:
> - Extend suspend/resume support to include runtime PM and ICC scaling.
> - Register dev_pm_ops and implement runtime_suspend/resume callbacks.
> - Link to v1:
>   https://lore.kernel.org/lkml/20250606105808.2119280-1-quic_utiwari@quicinc.com/
> ---
>  drivers/crypto/qce/core.c | 99 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 92 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
