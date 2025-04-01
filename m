Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066381F03D6;
	Tue,  1 Apr 2025 12:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743509812; cv=none; b=HubU5O/3COhnjpcWQXYFr1Q84pAOvOnRILaRsBMIph8hFI2Lkq03a+RfaxxsRY1qJn0DARwLNR9B8fRdiVHgZwbcXze3om3fFradaURjYgI7xG7un626+djVyVdGaFswzN65+cBRGSGRWjf8Y008GhBvI2m3MOFuotzKIbmAaMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743509812; c=relaxed/simple;
	bh=JHwVvB464WiIDJiE7SbFKoQIQXrQ7qwM/kXeKgp2Qks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fYKpxMHzsZkeltL6hHcRmIdRjlIx8rkJXhtwy7DoyJIkeJBAIB+stSKgahfiM9joFz0EAphlp/ub8sDTJ33PeQVH2uhF+4RARMXfkdkINCLAvX+HxFnDd+dgUMbUEpK/tHpCw4JVZ5aqZhMXtNPHTSMPM2GjLu7LehhI53CsFYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=M/33HPa8; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="M/33HPa8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Pfcv/mgCibSZQSp0GWRTI6tc4QttBvlotb2/ILE9954=; b=M/33HPa8Gz3NBBZ9hpZbIic9ge
	MFJb7n67WuVDUalS8V/sO/K8V2m62ZwOEsreXyY51OJtIikm6yHR9TFnFX54uMcOVoKn1mblHGySA
	fAUAijH6h1E+J2nVbeooQ+/LPPg29mLftvf1PQDqjaPXZtxbn6vWh3g4lz9yGHCbTrBw1XIHHx4YX
	siQnirbfMt5/XNlcUcnwXfBqD0BqaGbMM8P3s07/nPZSdH+9V4y0iu36sN7GKHP/WbvdWcwpqXdrZ
	QJY9xph+5CxQ3Vb2w5QhH3S4Zv3UsAQA2d73R46ix+nCvL4oMwVzYQ+Rm51xgnuG+U862IuztVpGg
	MlhqZGxA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzaXq-00Bpck-1v;
	Tue, 01 Apr 2025 20:16:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 01 Apr 2025 20:16:42 +0800
Date: Tue, 1 Apr 2025 20:16:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Bulwahn <lbulwahn@redhat.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Hannes Reinecke <hare@kernel.org>, Keith Busch <kbusch@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: Re: [PATCH] crypto: Kconfig - correct references in config
 CRYPTO_HKDF
Message-ID: <Z-vZKlqdAtvyeUjj@gondor.apana.org.au>
References: <20250401121354.20897-1-lukas.bulwahn@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250401121354.20897-1-lukas.bulwahn@redhat.com>

On Tue, Apr 01, 2025 at 02:13:54PM +0200, Lukas Bulwahn wrote:
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index dbf97c4e7c59..f601a4ec6d1a 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -143,8 +143,8 @@ config CRYPTO_ACOMP
>  
>  config CRYPTO_HKDF
>  	tristate
> -	select CRYPTO_SHA256 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
> -	select CRYPTO_SHA512 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
> +	select CRYPTO_SHA256 if !CRYPTO_MANAGER_DISABLE_TESTS
> +	select CRYPTO_SHA512 if !CRYPTO_MANAGER_DISABLE_TESTS

Why not just drop CRYPTO_MANAGER_DISABLE_TESTS and select the
SHA algorithms unconditionally?

>  	select CRYPTO_HASH2

Nobody should select HASH2.  Just drop it since it's implied
by SHA256/SHA512.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
