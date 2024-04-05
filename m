Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A7428E11
	for <linux-crypto@vger.kernel.org>; Fri,  5 Apr 2024 07:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712300924; cv=none; b=daYOshg9vLhKzF1L/f4JqV3qHJiidnxofZfUc5bSO+u+tgr8bE6+ZUB30k2eiP5GBYz6LkrVz3laFlEAkqiRRnv9wYHYuGo1w85xsRYwvl6ifP5Nyp5UHb9V5/bexP5cvuzjFMIZ5rniLFQbH/4pG143XONTPAsCgW4st72X7wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712300924; c=relaxed/simple;
	bh=U1mc75I4sm7V2Bh1tHMJIxztG8sheBdbDYkJzw+oBc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o6xxmf3o03sHXf/Sa8hs3vr47mH0z2czS/SRuIKwZyUYTedM9tNuQ2gRePSMKSDx9NWWqjWx6MdZb01S5fCYZF/GUR77A83uk8eD5YgiG+0kQXXYtc6HcT1dqtc3Tus+1ZiuWzqEs0nM087czewfTuex1SbCg/46ju7aHeAYfDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rsdgj-00FT7v-Oe; Fri, 05 Apr 2024 15:08:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 05 Apr 2024 15:08:54 +0800
Date: Fri, 5 Apr 2024 15:08:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v1 0/4] Add spacc crypto driver support
Message-ID: <Zg+jhukIGEyFdjae@gondor.apana.org.au>
References: <20240328182652.3587727-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328182652.3587727-1-pavitrakumarm@vayavyalabs.com>

On Thu, Mar 28, 2024 at 11:56:48PM +0530, Pavitrakumar M wrote:
> Add the driver for SPAcc(Security Protocol Accelerator), which is a
> crypto acceleration IP from Synopsys. The SPAcc supports many cipher,
> hash, aead algorithms and various modes.The driver currently supports
> below,
> 
> aead:
> - ccm(sm4)
> - ccm(aes)
> - gcm(sm4)
> - gcm(aes)
> - rfc8998(gcm(sm4))
> - rfc7539(chacha20,poly1305)
> 
> cipher:
> - cbc(sm4)
> - ecb(sm4)
> - ofb(sm4)
> - cfb(sm4)
> - ctr(sm4)
> - cbc(aes)
> - ecb(aes)
> - ctr(aes)
> - xts(aes)
> - cts(cbc(aes))
> - cbc(des)
> - ecb(des)
> - cbc(des3_ede)
> - ecb(des3_ede)
> - chacha20
> - xts(sm4)
> - cts(cbc(sm4))
> - ecb(kasumi)
> - f8(kasumi)
> - snow3g_uea2
> - cs1(cbc(aes))
> - cs2(cbc(aes))
> - cs1(cbc(sm4))
> - cs2(cbc(sm4))
> - f8(sm4)
> 
> hash:
> - michael_mic
> - sm3
> - hmac(sm3)
> - sha3-512
> - sha3-384
> - sha3-256
> - sha3-224
> - hmac(sha512)
> - hmac(sha384)
> - hmac(sha256)
> - hmac(sha224)
> - sha512
> - sha384
> - sha256
> - sha224
> - sha1
> - hmac(sha1)
> - md5
> - hmac(md5)
> - cmac(sm4)
> - xcbc(aes)
> - cmac(aes)
> - xcbc(sm4) 
> - sha512-224
> - hmac(sha512-224)
> - sha512-256
> - hmac(sha512-256)
> - mac(kasumi_f9)
> - mac(snow3g)
> - mac(zuc)
> - sslmac(sha1)
> - shake128
> - shake256
> - cshake128
> - cshake256
> - kcmac128
> - kcmac256
> - kcmacxof128
> - kcmacxof256
> - sslmac(md5)

We don't add hardware implementations without software counterparts.
So please prune your list of algorithms according to this rule.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
