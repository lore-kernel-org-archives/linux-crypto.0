Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963523;
	b=zGk/YTvfFejnfpi+GCkfPT/iZItfunZE4RY9wEdnRjNhJp50UPJBptkMFEc23Ys/Z/jx
	 6CtTgbPvIhxXCRnhm+CiDgguccdMpBYcy2u5Prz5GQqflMkEVSKKsoIefr3KwLzkGnHQr
	 2o1XilRqUQiEA5KzsT7GIFDKuUK21MUjcq5YCDChBlVLX6+kMfi8TNS2A5biwZD/sEL5Q
	 TvWTr31Nfyb09EDmyeW4w9STlfK/uea9FEuSVdl3NmlthJRNgQhgI4bMWCMSvh8ohqoQw
	 W9qatBKJzGVn1ErMR7TObR64uMsVZytRGnf7A9npayQZFLL8DeSGPzfPpASYUx4chEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963523;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=qHsvtGSzruDpufmVgGB18b19oNg1SUnZv08yqQlPOS8=;
	b=lA4y26b3iPNmnfOJy6ms+b5DHXJGloNboK73D8shevoAQjlx6sT7y+hBCnYPH+LEoAXz
	 icdSIn0rwvU7V+KD4EVxNq3Sto3GL3g05192ppdQkTivwfXBEhR90G49vLW6U0EOsKpOM
	 t3J35RkQJYEn7zQIfNEQxqRH6ZWYSFtoq+T/8Ex39qZYeiIfnDMbuc6aww3kBiOIdxhoj
	 uPi4OWsjqRtg5v5Xt3cqpxGdUy50/5JenwgkwEvUJ5f27zYkVgEPNw/G03ybT3cDP9Mti
	 tOLvomd6aIoEHVhF5WoE4tjWMKkY6jHhkjGodwjgbMsWCDTVfDIO7BKE7tU5GfPFLJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=R2A6eVjD;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C32A606A329;
	Fri,  6 Nov 2026 11:12:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C32A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=R2A6eVjD
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=qHsvtGSzruDpufmVgGB18b19oNg1SUnZv08yqQlPOS8=; 
	b=R2A6eVjDt8hq/OYN4TBmIILWlMHMTJo5MVY5Af74wlJUlr4KwgQrtfkZRHBz6Sa5DvxBzGnY4PW
	tOtng6AJvil7nbCyKO+6Mz733dDQsi2yNoAohwBaP7NJ8ztTLn93pAm74bk04bVw/nZeWu9Qa3Uro
	a75O7PA2nBVA5k1DMauM/PEALG4pX6Cc2ITI4ALulT1A4Oj5+RGxmr36h0NmMy4ST7wVyRIgLLzV7
	lO92i6R8thvqehYIhD88SQu6SGxAU/fTBzTbFVjeGn6WQH9k1RuU0fmG9+tkg6/L7GjpngIvI8hcl
	FroikT7/6Y0Ot8SQOoCTz4frO9TUjJmqp6FQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xPHrK-0000000BqVB-39Dr;
	Fri, 06 Nov 2026 19:11:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2026 19:11:50 +0800
Date: Fri, 6 Nov 2026 19:11:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Laurent Vivier <lvivier@redhat.com>,
	Olivia Mackall <olivia@selenic.com>,
	Rusty Russell <rusty@rustcorp.com.au>, Amos Kong <akong@redhat.com>,
	virtualization@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: virtio - prevent use-after-free after a failed
 restore
Message-ID: <au219vQfcYE0maYw@gondor.apana.org.au>
References: <20261016103640.4989-2-blum@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016103640.4989-2-blum@kernel.org>

On Fri, Oct 16, 2026 at 12:36:40PM +0200, Thorsten Blum wrote:
> remove_common() frees the driver data during freeze, but does not clear
> vdev->priv, which points to freed memory. If probe_common() then fails
> during restore, a later remove or freeze can dereference the dangling
> pointer.
> 
> Clear vdev->priv on the probe_common() error cleanup path and before
> freeing the driver data in remove_common(). Also reset the device and
> return early from remove_common() if vdev->priv is already NULL for a
> safe teardown after a failed restore.
> 
> Fixes: 08e53fbdb85c ("virtio-rng: support multiple virtio-rng devices")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/virtio-rng.c | 7 +++++++
>  1 file changed, 7 insertions(+)

Please respond to this comment:

https://sashiko.dev/#/patchset/20261016103640.4989-2-blum%40kernel.org

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
