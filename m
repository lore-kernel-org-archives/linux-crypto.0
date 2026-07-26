Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2305377AA7;
	Sun, 26 Jul 2026 23:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785107334; cv=none; b=MliCpw4UfgBg6K8dut9Pip58C0GUXuPqwsOuAjwDlm3s+gUCR42L6uFo/n4n6v0+0op31lhStwBhrIfMm9zpl7T3A1ZDPJNteiucvITZW7IxTBRl4Id6e0WN1KJqrCblHl+WgnIvaQY5Mv7Mx6tVaKF/hYfgAZJ0t6VH1jwulY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785107334; c=relaxed/simple;
	bh=3GWNfXacbQZO8307BKt6gnR+ILNsEEGScLxgY9C+4DM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tAYKBMK8X5/+D6wBQ2KHWLj7UER/CHPU2u2mlO58xa9zQ2VQiUaQqs6xZGQJQ3GX+VEWDP0NZnWpAdZaS+iAPG8JrNnzsp8zkSblZmRaLtKlJulvrN77b9pGrNuytjuXn7/LBtyEGwkDYubppGpDtxggTYAaaWHJuxFiZoX77Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=E+99C4MX; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="E+99C4MX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=LrKa0V1KCyVFsZR6LpR0YGYIwHlwSXfdbJn1zOquLNA=; 
	b=E+99C4MX7MubS8V+iYWrQOYFnisJAAzjzOmlSJRzIAuMXpMd+14SE8uZFhfSqfaHid1aR+LsmLk
	wsfIkiE6r1OmDIiYwUrpUFjYOm/i0biISAeH84WYYlXt3V1oO+hRWnF8mvplMdP6FgICLQzNSef1A
	xkHFqW+bpAl/ZhC9yEZWDxyXaNGvPjXMqoPzE5kLN54Ycy8vi8/Rs2rdsm831VhwA0Kjo/RcWSe4n
	vP4GDooqmBqXFLmQr/h7FDDhSdOfjNkTBkfi2a0j+tXO/wX1QwwtHF2j+Ka+3j6hyHrOYevpg7qCG
	tQxZiiCq2s50uOzKbM6+CdfPRFf7Znmgfk9A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wo7xP-0000000GyML-3zSb;
	Mon, 27 Jul 2026 07:08:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Jul 2026 09:08:31 +1000
Date: Mon, 27 Jul 2026 09:08:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Eneas U de Queiroz <cotequeiroz@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, brgl@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v6 1/8] crypto: qce - Fix HMAC self-test failures for
 empty messages
Message-ID: <amaTb58-PcC1ePoY@gondor.apana.org.au>
References: <20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com>
 <20260717-qce-fix-self-tests-v6-1-455775fe5f6c@oss.qualcomm.com>
 <20260723192514.GA110634@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723192514.GA110634@quark>

On Thu, Jul 23, 2026 at 12:25:14PM -0700, Eric Biggers wrote:
>
> I'm trying to understand how this is intended to work.  This uses
> crypto_tfm::fb.  But this driver doesn't set CRYPTO_ALG_NEED_FALLBACK,
> so crypto_tfm::fb is actually just a pointer to the same crypto_tfm.
> (See crypto_create_tfm_node() and crypto_ahash_init_tfm().)  Doesn't
> this just result in an infinite recursive loop and a crash?

Every async driver gets a fallback by default, unless you set
the bit CRYPTO_ALG_NO_FALLBACK or you declare that you support
CRYPTO_ALG_REQ_VIRT (which no driver does).

Cheers,
--
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
