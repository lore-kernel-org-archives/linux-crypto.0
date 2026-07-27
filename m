Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E51378F2F;
	Mon, 27 Jul 2026 00:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785112571; cv=none; b=Jhb+6KBDoOaMWEIOGNfusRkAgGt6BmnNKipfdURa4AQZVcos15j7d4201xJMGZeOBFOF2T/1BjtV3mmAOgIbaPAh0ZLgZssLssr47rFkELa/Pbcne6Ud4PMsNM8h46IjtcWA3q31DqR94O3PLZBCycAEt/OAmIlDlppOsPeecy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785112571; c=relaxed/simple;
	bh=VAD8aaJveeNCSkN4qPAWhHREBVRZAo1Twf+uPB3EIK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jt/MlukkBmyhh1Bk4Bt4ZSzKn5jWpr2Zt7b/nufhNbS9KNCnIEQIUQjnBzpZGqSjrey0iikso5dwqo+KZpzfnlvk/iDp9tps5Ades3kHrp4i8YQnUUvtPKku2WN6ahPQMroQYbluIvgOvgAcCm4ECrzHZlMxY3fMlFIbI4MoLRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=M3sJhciD; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="M3sJhciD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=cePsuwFbqleCO0lprDfloU/DeGUmtkvcYNUIMucMeWg=; 
	b=M3sJhciDYj+wPs6LfKGT/qM9VynYmUYn/zWlVcCxF+HHeDkGuyNPkfcusRx7lZOf8QTI/fnvnN9
	4pFvE670qS4cQsIC9g7WOWCBuRGQDHS1LyM4YYr0hdJ+qt9mHt9VM+1tT7h/bTxg3uzt57OucXAzb
	1qBIs1V3+k0VpkOvuAy2BxslF/jyYxckOEDqkcZHKyUwFIIEdae8sUZV2NPROESy4Z4Co+V8gMam9
	CtyCgJJKIGpslss5NraFX7fGgm5k7/vmQCjI+cDlF3nEs0VlbXVM71SBRzI287dKUPeU6Y+EwMzfv
	GoD50ZrURqRJZ00jpa6ucoVu3RtJSzVVJBgw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wo9K2-0000000Gz3v-0xch;
	Mon, 27 Jul 2026 08:35:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Jul 2026 10:35:58 +1000
Date: Mon, 27 Jul 2026 10:35:58 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Can Peng <pengcan@kylinos.cn>
Cc: olivia@selenic.com, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, danielt@kernel.org, linusw@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] hwrng: stm32 - Fix runtime PM cleanup on registration
 failure
Message-ID: <aman7sL1uDcwcQ4i@gondor.apana.org.au>
References: <20260718032937.420561-1-pengcan@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260718032937.420561-1-pengcan@kylinos.cn>

On Sat, Jul 18, 2026 at 11:29:37AM +0800, Can Peng wrote:
> stm32_rng_probe() enables autosuspend and runtime PM before registering the
> hwrng. If devm_hwrng_register() fails, probe returns with runtime PM left
> enabled and autosuspend still selected.
> 
> The remove callback also only disables runtime PM and does not undo
> pm_runtime_use_autosuspend().
> 
> Use devm_pm_runtime_enable() so runtime PM is unwound automatically on
> probe failure and driver detach. Since the managed cleanup also disables
> runtime PM,drop the remove callback.
> 
> Fixes: c6a97c42e399 ("hwrng: stm32 - add support for STM32 HW RNG")
> Cc: stable@vger.kernel.org
> Signed-off-by: Can Peng <pengcan@kylinos.cn>
> ---
>  drivers/char/hw_random/stm32-rng.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
