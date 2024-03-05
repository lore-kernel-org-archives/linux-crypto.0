Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648D614288
	for <linux-crypto@vger.kernel.org>; Tue,  5 Mar 2024 21:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709673200; cv=none; b=ac3bCppbbjn5yskWeGXOdYPvbWE7bejZ+CK3vjUtpeM+D1JzyLeUyMfJn+BkSW7HkHPyn5gbHv0Ma7B3hYpWalCbH7CPQ1eip7VJTYopL590s2+6H0WgN+OiBnpvR83fFAUtGThVEbHL7c3RXFhRwhgYES6oL6S11qqoEnUdEjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709673200; c=relaxed/simple;
	bh=gvftx1Uiw+HEqhLhJNylAuj/DkVc0aFLAzSYPQPCXbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=do5Xs57me+6DDzcF1ly6KWojmQkvKMCk81BRZPE3LasiZdGBDqCjWZdobJ9meJ+45AVj1fWP5qzVx8J951q1FPjjCy2xVYoCEGU0FxG0x7s6NNqRre+gZA/yEAKgk7R5Q0rw1O8oxUOQZY12HI+KxTjK0qFxkIpPNtq0EnEkVAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nbX/OJS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nbX/OJS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF967C433F1;
	Tue,  5 Mar 2024 21:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709673200;
	bh=gvftx1Uiw+HEqhLhJNylAuj/DkVc0aFLAzSYPQPCXbU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nbX/OJS7ic3OaUQ7dx0iKc7b5NUFwKA7AMWiYLwz9rgF21ih7+wlcDIQ2lUvorgQI
	 C/Q7HS78QIR68zdJIhvY8CxqL2i7vp0/OOI/SYwM6fyS5CId5mJAZuBqnUoxTnYZJo
	 KtQLpo4aVyfGx4ZozDeO+b4sn2OENsRbz6BCI+BB9Z1ixnMz1jzZ7piz1juUztLa3i
	 0odVKMPUVdxlK0KeHdLd/OlpNqsGUTRR/vHlpP54qRgwqWmiNi2udTm0GGq1xzWuit
	 hkXer+oOZRJb4MqOFmUoGO7PpBGQYPgPAs6uLIUON/L11Y9IFeGM3eat0aF8o3CmgA
	 oElvQdhdtcK/w==
Date: Tue, 5 Mar 2024 13:13:18 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com
Subject: Re: [PATCH 0/4] Add spacc crypto driver support
Message-ID: <20240305211318.GA1202@sol.localdomain>
References: <20240305112831.3380896-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240305112831.3380896-1-pavitrakumarm@vayavyalabs.com>

On Tue, Mar 05, 2024 at 04:58:27PM +0530, Pavitrakumar M wrote:
> Add the driver for SPAcc(Security Protocol Accelerator), which is a
> crypto acceleration IP from Synopsys. The SPAcc supports many cipher,
> hash, aead algorithms and various modes.The driver currently supports
> below,

Has this been tested with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?

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

Algorithms that don't have a generic implementation shouldn't be included.

- Eric
