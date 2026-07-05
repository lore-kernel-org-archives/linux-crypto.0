Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C7336CE06;
	Sun,  5 Jul 2026 08:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240713; cv=none; b=SzAADQ01tplhS7s40U5x7eFWHCJv0N63O2MZ97/PKKb49gwGorwxe/nKEXNUYlsdBQqDZM3BAHA9CvUigdHmNQYFAi1mZ4vokIALmqemuVapmSBzteujUKohlIcXMnmg1EAO6wQ76OL7fqx+STwkbjEQB72KB7bS9LXy0/0d2tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240713; c=relaxed/simple;
	bh=7s0KonSwT+ADSLZHft7mPJ/7WejFR1vU9didABypiUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g27aaluTvujDIcdx7H8E40pmt9D46QY09Jme9668dCQI372nZUHybccL6+9GTPPAMmDBhoNh9NKMHUU63YnKoQ1sAdLl7o3J4eJvHPe3LRwuJfceSdjgl6pYQ620ARDbHnMHfCCK1klI8xqJGq8yhSuDMFgFnpDfYBeNJveiSqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=arscSYLH; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="arscSYLH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=6PIbcn5LuVyrvGq13RKK5l9fGE1EpF75wfm5PwmwfFg=; 
	b=arscSYLHogbrDIvkjwyWp89EmL6Z2+WHVwTkyFDHrmuGlnCjzzMrhD9sdewuX9kpZYzqT5Nog+T
	OYwTafRE1IiDumvGEYvsw8I2JOb159xKDI7+5irRIL2/5+KbuHWpGCy4I/pHYg4Xc/c1JKWBJmbyM
	B1cetEJESZ27/nJ2nQu2w8zfNUnx3t9/UIEA9SH081HiAIl6skLZvJKjHrHZiKxsqBvyWYtwmFZmA
	z+e7ctDr2/Uz2NPnWP0Pic0YWtgJs5MLo650/OGmoQlxdY6ABCP96zuKtx+cL3UZqsAP7f6YGvTCX
	2u63p8GYzorI2PhiwO/JjtMMLyvfzCac16qw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgIMo-0000000Al5S-3jCu;
	Sun, 05 Jul 2026 16:38:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 16:38:22 +0800
Date: Sun, 5 Jul 2026 16:38:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Eneas U de Queiroz <cotequeiroz@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	brgl@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 1/8] crypto: qce - Remove unsafe/deprecated algorithms
Message-ID: <akoX_suAitZhXWTu@gondor.apana.org.au>
References: <20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com>
 <20260622-qce-fix-self-tests-v4-1-4f82ffa716c6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622-qce-fix-self-tests-v4-1-4f82ffa716c6@oss.qualcomm.com>

On Mon, Jun 22, 2026 at 03:18:09PM +0200, Bartosz Golaszewski wrote:
> Remove algorithms that are either unsafe or deprecated and have no
> in-kernel users that cannot be served by the ARM CE implementations.
> 
> AES-ECB reveals plaintext patterns (identical plaintext blocks produce
> identical ciphertext blocks) and should not be exposed as a hardware-
> accelerated primitive. DES, Triple DES and HMAC-SHA1 have been
> deprecated for years.
> 
> Remove sha1, ecb(aes), ecb(des), cbc(des), ecb(des3_ede), cbc(des3_ede),
> hmac(sha1) and all AEAD variants built on these primitives as well as
> authenc(hmac(sha256),cbc(des)). Also clean up the - now dead - code,
> flags and constants.
> 
> Cc: stable@vger.kernel.org
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---
>  drivers/crypto/qce/aead.c     | 56 +------------------------
>  drivers/crypto/qce/common.c   | 55 ++++++------------------
>  drivers/crypto/qce/common.h   | 16 ++-----
>  drivers/crypto/qce/regs-v5.h  |  4 --
>  drivers/crypto/qce/sha.c      | 30 +------------
>  drivers/crypto/qce/sha.h      |  1 -
>  drivers/crypto/qce/skcipher.c | 97 +------------------------------------------
>  7 files changed, 20 insertions(+), 239 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
