Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793527112;
	b=ZinQPhK9LsWYNuDpwYQgJ5Zu2jruoZoH5Pxb6vBajauZgRwNoCNV2sTcJcVgthqYE/5/
	 Ffr7b4FLDjrkiHLrSe22tf9NxqLiYbhf4CVoF1LnUXHd7Be2tVMMGOK1FS2iROK4abWFB
	 ZgMHnz5HE9AR1tdjXZpOnKh08DrI8lP6xNZxSRtkAN4qkvilMf2VsnCzvIsfxiVstKNA3
	 3trkFbHl8pWduAtTD+ZEQKhVTV789KPjNuVD9HvCdu6zJZmKdxP7wxygrZDT+tYk5AxLH
	 cUHM8X+PcwVXYfDixJ+R6My8JSVeASqSUKk1vqLb5ZFtw3NOWpw2XUklBMxM2s36Ofw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793527112;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Message-Id:In-Reply-To:References:Subject:
	 Content-Type:Content-Transfer-Encoding;
	bh=xAgWg0tDwrr/lzE52vVCd0BTqxlgoKI/tPtnPR81L6g=;
	b=vbD6T7iISz/YjR6YjoWvJM5XQuLlwPqEPJ0Xn+veGQIHuRjhWqskqoRbNh81xodPShyY
	 TqGNbkOA1DvGT8j+66oUtWWW8arG0rzBfebY8RvWjA7R3QZUib4sNdCAQbBB/e532h2A+
	 9jXXTGfSep5t+3uHAKHwto9LFi1bd7/tBn+59G0Ah9L3Pme3zpoxi2Lm6roo9tV/OkJDH
	 UBWiq1VCLoTU4DXw1lfyunNumpQT5afGalY70KdA/9egIdLqMckqy5woXe3etFrR+XJPD
	 F95PjCR1/kGF5X0HMae1C+lt1EHE6XPLFixMgTN4L7aTdJ0jnbkjxpOLwE2cV+5MIEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fUPMe4Xq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B880606A324
	for <linux-crypto@vger.kernel.org>; Sun,  1 Nov 2026 09:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fUPMe4Xq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BE41F00919
	for <linux-crypto@vger.kernel.org>; Sun,  1 Nov 2026 09:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793527111;
	bh=xAgWg0tDwrr/lzE52vVCd0BTqxlgoKI/tPtnPR81L6g=;
	h=Date:From:To:In-Reply-To:References:Subject;
	b=fUPMe4Xq6xtlqc++CB+Kx1lTuBP7W00M2lCI3tmEW0vgfhNJbOqsP7NNC3wsJAKRH
	 5/5y86l72QsI5Lw3JMICG77AsCTlrE9Pu1JZt+cjST7LMchShqn8oPfZGfi2rivzit
	 QEJyYuxepZuVPs9gHRln/T8GbCgOKyGBK2tbSqh3egolfYpVh7Tb5yAp3FAWduibv3
	 aXuQ6Vm9FiapZMjhEj9CmbIgGIAbaKDl08xwHb6lL2jhCAo8eEb88PRwD8zxjn6OmM
	 rTXxoMXJ8ay25AbJ3G6dcjx/gAMjaRDMJaJHv+Za4qliLUrC+28PdqPKuLrwDYQref
	 APlNguEFZRlZQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id AE992198003A;
	Sun,  1 Nov 2026 04:58:29 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Sun, 01 Nov 2026 04:58:29 -0500
X-ME-Sender: <xms:RA3nanaLntdvk4mFFBm4UV7ucf8XpQ2TP5Zz7OGvdYmBo4f_D6O1fA>
    <xme:RA3nahM5JACieHjymwEv6QRYydcE12aMUq73d0WMJYCwzemgxiAL-F6SVYOddzITF
    Lh9e95dX9GUZAmq7utdfvUAZ8itP-E5oBZS6RdRCXFIa4an4BJdaCm4>
X-ME-Proxy-Cause: dmFkZTF6BNGr5DxEnSUFknMn4VvU/DlDpbUsvJHwagO0vZMctU/P/EwGEJBEm8j2lC10Fj
    hjIqMul3vevZipRYdZ8BhXxs5+kFNhz25UDb/GTa62Z+ii0tFEGu4DipjDAlwI6m+DbUtO
    sz8dgSTf54CxpU2Cvhkww3i7WJKBNxLoNj/DqldGDn+hZs43QYdKtrsWsAiIDeFFm44M4T
    80gkbig+61b4V4l0xQkM6ifRZZAb5EhkrX/8uO699zeDbr7zbLrYnD1LxgoLeWlsuxuXv5
    Zh2BqmapToc7+u0MZza+tB5ILWVRUlS87BLDB5MGHQmZCMhK6VrANnXclVGx7GVV8vPqpc
    3PpmClLfOZlyeWPb/YMKUF3QXnDf9VqAv7jsoGT9RcgI+Y9Q2+xUd3c6u1jx5t9weZO2Z6
    Ignajt1EY2Zom0/OUA1aZzYtlTP3g45j0zC8Mabd9o1qpdxXLefDUSw01WHUtpZ/aYLbNK
    ZxOzePK2Vvw5PS+R5+5gUCAl+vm7oHBjLNrCClt4CkIViM6NGx9tDDqMHTM0vSZXutZQ0e
    Rx6pK1jQHQiEtiofEsHfmoRw/3h+SfcIhG/NdofT12JEGEHew2egYwW7s8gNyVtr0rgq0F
    zg2FY9Blr8AEgtLabcYNyfSkkbl7IaYfDQqUJlWUgew6uu9Xp/oeU5AqA1DQ
X-ME-Proxy: <xmx:RQ3nap9rmSpBeBSS_TnXLDqq7Vzpyv5HHteFteEDkUPiAQ1Nk6zKdg>
    <xmx:RQ3nakttxnUDKSOVfSyEy7UiMuS2Xi3mfMqP1JUtY-_8xw-Jj6Z4Ig>
    <xmx:RQ3nasD4u6RoqyHWakoV9kmKsX9RGNZ5rfqbxuZviipkvZxQiAvH8g>
    <xmx:RQ3nasV3pa8j5hPvuY37V3_8pADtDiRePcI6_VYvmQ9-UdZ3T95FoQ>
    <xmx:RQ3naqAy7F9lbMLbHZVPcOsCefrCT6_CAN44pUgogypVYmjcFDc2ixjG>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 3DF80F8008E; Sun,  1 Nov 2026 04:58:28 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Sun, 01 Nov 2026 10:58:07 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <7884dbb2-1585-46fb-a6eb-fe4df9a7e679@app.fastmail.com>
In-Reply-To: <20261031211535.8793-1-ebiggers@kernel.org>
References: <20261031211535.8793-1-ebiggers@kernel.org>
Subject: Re: [PATCH] crypto: arc4 - Remove obsolete crypto API support for ARC4
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 31 Oct 2026, at 22:15, Eric Biggers wrote:
> All in-kernel users of ARC4 use the ARC4 library (lib/crypto/arc4.c)
> directly, not the crypto API wrapper (crypto/arc4.c).
>
> Removal of the crypto API wrapper was attempted in 2020
> (https://lore.kernel.org/linux-crypto/20200702101947.682-5-ardb@kernel.org/)
> but was delayed due to its use by iwd via AF_ALG.  This was, however,
> soon afterwards resolved by making iwd simply use userspace ARC4 code
> (https://git.kernel.org/pub/scm/network/wireless/iwd.git/commit/?id=1db8a85a60c645232eb5bba1ec0cd0a2927ccd16),
> which was released in iwd 1.9 in September 2020.
>
> Also at the time, CONFIG_CRYPTO_ARC4 was placed under
> CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE, and the kernel started printing
> a warning whenever "ecb(arc4)" is used.  See commit 9ace67718310
> ("crypto: arc4 - mark ecb(arc4) skcipher as obsolete").  So, any other
> hypothetical user would have had 6 years of deprecation warnings, even
> if somehow they were overlooking that ARC4 is insecure.
>
> Finally, "ecb(arc4)" isn't on the skcipher_allowlist introduced in v7.3,
> so it's no longer available in AF_ALG by default even if
> CONFIG_CRYPTO_ARC4 is enabled.
>
> Given all this, it's clear that the crypto_skcipher / crypto_lskcipher
> API support for ARC4 is no longer used or needed.  Remove it.
>
> The ARC4 library remains in place, as it's still used in the kernel to
> support certain legacy protocols.  (Note: since this removes the only
> ARC4 test, I'll also add a KUnit test to replace it in a later commit.)
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  arch/arm/configs/am200epdkit_defconfig     |  1 -
>  arch/arm/configs/spitz_defconfig           |  1 -
>  arch/m68k/configs/amiga_defconfig          |  1 -
>  arch/m68k/configs/apollo_defconfig         |  1 -
>  arch/m68k/configs/atari_defconfig          |  1 -
>  arch/m68k/configs/bvme6000_defconfig       |  1 -
>  arch/m68k/configs/hp300_defconfig          |  1 -
>  arch/m68k/configs/mac_defconfig            |  1 -
>  arch/m68k/configs/multi_defconfig          |  1 -
>  arch/m68k/configs/mvme147_defconfig        |  1 -
>  arch/m68k/configs/mvme16x_defconfig        |  1 -
>  arch/m68k/configs/q40_defconfig            |  1 -
>  arch/m68k/configs/sun3_defconfig           |  1 -
>  arch/m68k/configs/sun3x_defconfig          |  1 -
>  arch/mips/configs/decstation_defconfig     |  1 -
>  arch/mips/configs/decstation_r4k_defconfig |  1 -
>  arch/mips/configs/ip32_defconfig           |  1 -
>  arch/mips/configs/rt305x_defconfig         |  1 -
>  arch/mips/configs/xway_defconfig           |  1 -
>  arch/powerpc/configs/44x/eiger_defconfig   |  1 -
>  arch/powerpc/configs/44x/redwood_defconfig |  1 -
>  arch/s390/configs/debug_defconfig          |  1 -
>  arch/s390/configs/defconfig                |  1 -
>  arch/sh/configs/sh2007_defconfig           |  1 -
>  arch/sh/configs/titan_defconfig            |  1 -
>  arch/sparc/configs/sparc32_defconfig       |  1 -
>  crypto/Kconfig                             | 13 ----
>  crypto/Makefile                            |  1 -
>  crypto/arc4.c                              | 82 ----------------------
>  crypto/tcrypt.c                            | 19 -----
>  crypto/testmgr.c                           |  7 --
>  crypto/testmgr.h                           | 62 ----------------
>  include/crypto/arc4.h                      |  3 +-
>  33 files changed, 1 insertion(+), 212 deletions(-)
>  delete mode 100644 crypto/arc4.c
>

Good riddance.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/arch/arm/configs/am200epdkit_defconfig 
> b/arch/arm/configs/am200epdkit_defconfig
> index 61beac88e863..444091e601f2 100644
> --- a/arch/arm/configs/am200epdkit_defconfig
> +++ b/arch/arm/configs/am200epdkit_defconfig
> @@ -85,7 +85,6 @@ CONFIG_DEBUG_KERNEL=y
>  CONFIG_CRYPTO=y
>  CONFIG_CRYPTO_CBC=m
>  CONFIG_CRYPTO_ECB=m
> -CONFIG_CRYPTO_ARC4=m
>  # CONFIG_DEBUG_BUGVERBOSE is not set
>  # CONFIG_DEBUG_PREEMPT is not set
>  CONFIG_DEBUG_USER=y
> diff --git a/arch/arm/configs/spitz_defconfig 
> b/arch/arm/configs/spitz_defconfig
> index c7cf089001bf..6b988283bc7d 100644
> --- a/arch/arm/configs/spitz_defconfig
> +++ b/arch/arm/configs/spitz_defconfig
> @@ -217,7 +217,6 @@ CONFIG_CRYPTO_ECB=m
>  CONFIG_CRYPTO_SHA256=m
>  CONFIG_CRYPTO_AES=m
>  CONFIG_CRYPTO_ANUBIS=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_BLOWFISH=m
>  CONFIG_CRYPTO_CAST5=m
>  CONFIG_CRYPTO_CAST6=m
> diff --git a/arch/m68k/configs/amiga_defconfig 
> b/arch/m68k/configs/amiga_defconfig
> index e2d474e8cb8f..7a72436f7031 100644
> --- a/arch/m68k/configs/amiga_defconfig
> +++ b/arch/m68k/configs/amiga_defconfig
> @@ -527,7 +527,6 @@ CONFIG_CRYPTO_SM4_GENERIC=m
>  CONFIG_CRYPTO_TEA=m
>  CONFIG_CRYPTO_TWOFISH=m
>  CONFIG_CRYPTO_ADIANTUM=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_HCTR2=m
>  CONFIG_CRYPTO_LRW=m
>  CONFIG_CRYPTO_XTS=m
> diff --git a/arch/m68k/configs/apollo_defconfig 
> b/arch/m68k/configs/apollo_defconfig
> index 77669e31bb5a..5e5a8b9a0019 100644
> --- a/arch/m68k/configs/apollo_defconfig
> +++ b/arch/m68k/configs/apollo_defconfig
> @@ -481,7 +481,6 @@ CONFIG_CRYPTO_SM4_GENERIC=m
>  CONFIG_CRYPTO_TEA=m
>  CONFIG_CRYPTO_TWOFISH=m
>  CONFIG_CRYPTO_ADIANTUM=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_HCTR2=m
>  CONFIG_CRYPTO_LRW=m
>  CONFIG_CRYPTO_XTS=m
> diff --git a/arch/m68k/configs/atari_defconfig 
> b/arch/m68k/configs/atari_defconfig
> index 43ed1e317ae2..08cbb7e16847 100644
> --- a/arch/m68k/configs/atari_defconfig
> +++ b/arch/m68k/configs/atari_defconfig
> @@ -506,7 +506,6 @@ CONFIG_CRYPTO_SM4_GENERIC=m
>  CONFIG_CRYPTO_TEA=m
>  CONFIG_CRYPTO_TWOFISH=m
>  CONFIG_CRYPTO_ADIANTUM=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_HCTR2=m
>  CONFIG_CRYPTO_LRW=m
>  CONFIG_CRYPTO_XTS=m
> diff --git a/arch/m68k/configs/bvme6000_defconfig 
> b/arch/m68k/configs/bvme6000_defconfig
> index 44c1a2228d5f..794973be69bf 100644
> --- a/arch/m68k/configs/bvme6000_defconfig
> +++ b/arch/m68k/configs/bvme6000_defconfig
> @@ -473,7 +473,6 @@ CONFIG_CRYPTO_SM4_GENERIC=m
>  CONFIG_CRYPTO_TEA=m
>  CONFIG_CRYPTO_TWOFISH=m
>  CONFIG_CRYPTO_ADIANTUM=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_HCTR2=m
>  CONFIG_CRYPTO_LRW=m
>  CONFIG_CRYPTO_XTS=m
> diff --git a/arch/m68k/configs/hp300_defconfig 
> b/arch/m68k/configs/hp300_defconfig
> index 7ab25377bfe8..f79c221a6117 100644
> --- a/arch/m68k/configs/hp300_defconfig
> +++ b/arch/m68k/configs/hp300_defconfig
> @@ -483,7 +483,6 @@ CONFIG_CRYPTO_SM4_GENERIC=m
>  CONFIG_CRYPTO_TEA=m
>  CONFIG_CRYPTO_TWOFISH=m
>  CONFIG_CRYPTO_ADIANTUM=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_HCTR2=m
>  CONFIG_CRYPTO_LRW=m
>  CONFIG_CRYPTO_XTS=m
> diff --git a/arch/m68k/configs/mac_defconfig 
> b/arch/m68k/configs/mac_defconfig
> index 13f642884a94..e08032056392 100644
> --- a/arch/m68k/configs/mac_defconfig
> +++ b/arch/m68k/configs/mac_defconfig
> @@ -502,7 +502,6 @@ CONFIG_CRYPTO_SM4_GENERIC=m
>  CONFIG_CRYPTO_TEA=m
>  CONFIG_CRYPTO_TWOFISH=m
>  CONFIG_CRYPTO_ADIANTUM=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_HCTR2=m
>  CONFIG_CRYPTO_LRW=m
>  CONFIG_CRYPTO_XTS=m
> diff --git a/arch/m68k/configs/multi_defconfig 
> b/arch/m68k/configs/multi_defconfig
> index 1bbd2aa653c0..6aae07476a3f 100644
> --- a/arch/m68k/configs/multi_defconfig
> +++ b/arch/m68k/configs/multi_defconfig
> @@ -592,7 +592,6 @@ CONFIG_CRYPTO_SM4_GENERIC=m
>  CONFIG_CRYPTO_TEA=m
>  CONFIG_CRYPTO_TWOFISH=m
>  CONFIG_CRYPTO_ADIANTUM=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_HCTR2=m
>  CONFIG_CRYPTO_LRW=m
>  CONFIG_CRYPTO_XTS=m
> diff --git a/arch/m68k/configs/mvme147_defconfig 
> b/arch/m68k/configs/mvme147_defconfig
> index 3bfc36faf8d5..ce0210ed83d8 100644
> --- a/arch/m68k/configs/mvme147_defconfig
> +++ b/arch/m68k/configs/mvme147_defconfig
> @@ -473,7 +473,6 @@ CONFIG_CRYPTO_SM4_GENERIC=m
>  CONFIG_CRYPTO_TEA=m
>  CONFIG_CRYPTO_TWOFISH=m
>  CONFIG_CRYPTO_ADIANTUM=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_HCTR2=m
>  CONFIG_CRYPTO_LRW=m
>  CONFIG_CRYPTO_XTS=m
> diff --git a/arch/m68k/configs/mvme16x_defconfig 
> b/arch/m68k/configs/mvme16x_defconfig
> index 41ceed87c78a..2de3a5e2c95b 100644
> --- a/arch/m68k/configs/mvme16x_defconfig
> +++ b/arch/m68k/configs/mvme16x_defconfig
> @@ -474,7 +474,6 @@ CONFIG_CRYPTO_SM4_GENERIC=m
>  CONFIG_CRYPTO_TEA=m
>  CONFIG_CRYPTO_TWOFISH=m
>  CONFIG_CRYPTO_ADIANTUM=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_HCTR2=m
>  CONFIG_CRYPTO_LRW=m
>  CONFIG_CRYPTO_XTS=m
> diff --git a/arch/m68k/configs/q40_defconfig 
> b/arch/m68k/configs/q40_defconfig
> index af4b5c6e4655..8c8ba10f183f 100644
> --- a/arch/m68k/configs/q40_defconfig
> +++ b/arch/m68k/configs/q40_defconfig
> @@ -492,7 +492,6 @@ CONFIG_CRYPTO_SM4_GENERIC=m
>  CONFIG_CRYPTO_TEA=m
>  CONFIG_CRYPTO_TWOFISH=m
>  CONFIG_CRYPTO_ADIANTUM=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_HCTR2=m
>  CONFIG_CRYPTO_LRW=m
>  CONFIG_CRYPTO_XTS=m
> diff --git a/arch/m68k/configs/sun3_defconfig 
> b/arch/m68k/configs/sun3_defconfig
> index 1140951fefe7..e637063fec95 100644
> --- a/arch/m68k/configs/sun3_defconfig
> +++ b/arch/m68k/configs/sun3_defconfig
> @@ -471,7 +471,6 @@ CONFIG_CRYPTO_SM4_GENERIC=m
>  CONFIG_CRYPTO_TEA=m
>  CONFIG_CRYPTO_TWOFISH=m
>  CONFIG_CRYPTO_ADIANTUM=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_HCTR2=m
>  CONFIG_CRYPTO_LRW=m
>  CONFIG_CRYPTO_XTS=m
> diff --git a/arch/m68k/configs/sun3x_defconfig 
> b/arch/m68k/configs/sun3x_defconfig
> index bc9358e71ee0..ddc1bd7d0ac4 100644
> --- a/arch/m68k/configs/sun3x_defconfig
> +++ b/arch/m68k/configs/sun3x_defconfig
> @@ -471,7 +471,6 @@ CONFIG_CRYPTO_SM4_GENERIC=m
>  CONFIG_CRYPTO_TEA=m
>  CONFIG_CRYPTO_TWOFISH=m
>  CONFIG_CRYPTO_ADIANTUM=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_HCTR2=m
>  CONFIG_CRYPTO_LRW=m
>  CONFIG_CRYPTO_XTS=m
> diff --git a/arch/mips/configs/decstation_defconfig 
> b/arch/mips/configs/decstation_defconfig
> index 29915a002db1..e23784ae9636 100644
> --- a/arch/mips/configs/decstation_defconfig
> +++ b/arch/mips/configs/decstation_defconfig
> @@ -178,7 +178,6 @@ CONFIG_CRYPTO_RMD160=m
>  CONFIG_CRYPTO_SHA512=m
>  CONFIG_CRYPTO_WP512=m
>  CONFIG_CRYPTO_ANUBIS=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_BLOWFISH=m
>  CONFIG_CRYPTO_CAMELLIA=m
>  CONFIG_CRYPTO_CAST5=m
> diff --git a/arch/mips/configs/decstation_r4k_defconfig 
> b/arch/mips/configs/decstation_r4k_defconfig
> index 7eef7a1bdc30..0a81d57ca9c1 100644
> --- a/arch/mips/configs/decstation_r4k_defconfig
> +++ b/arch/mips/configs/decstation_r4k_defconfig
> @@ -178,7 +178,6 @@ CONFIG_CRYPTO_RMD160=m
>  CONFIG_CRYPTO_SHA512=m
>  CONFIG_CRYPTO_WP512=m
>  CONFIG_CRYPTO_ANUBIS=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_BLOWFISH=m
>  CONFIG_CRYPTO_CAMELLIA=m
>  CONFIG_CRYPTO_CAST5=m
> diff --git a/arch/mips/configs/ip32_defconfig 
> b/arch/mips/configs/ip32_defconfig
> index 5ddbaa0aafaf..0c3bae4a7bac 100644
> --- a/arch/mips/configs/ip32_defconfig
> +++ b/arch/mips/configs/ip32_defconfig
> @@ -162,7 +162,6 @@ CONFIG_CRYPTO_SHA256=y
>  CONFIG_CRYPTO_SHA512=y
>  CONFIG_CRYPTO_WP512=y
>  CONFIG_CRYPTO_ANUBIS=y
> -CONFIG_CRYPTO_ARC4=y
>  CONFIG_CRYPTO_BLOWFISH=y
>  CONFIG_CRYPTO_CAMELLIA=y
>  CONFIG_CRYPTO_CAST5=y
> diff --git a/arch/mips/configs/rt305x_defconfig 
> b/arch/mips/configs/rt305x_defconfig
> index c920976bedd0..86327df02681 100644
> --- a/arch/mips/configs/rt305x_defconfig
> +++ b/arch/mips/configs/rt305x_defconfig
> @@ -126,7 +126,6 @@ CONFIG_JFFS2_COMPRESSION_OPTIONS=y
>  CONFIG_SQUASHFS=y
>  # CONFIG_SQUASHFS_ZLIB is not set
>  CONFIG_SQUASHFS_XZ=y
> -CONFIG_CRYPTO_ARC4=m
>  # CONFIG_XZ_DEC_X86 is not set
>  # CONFIG_XZ_DEC_POWERPC is not set
>  # CONFIG_XZ_DEC_IA64 is not set
> diff --git a/arch/mips/configs/xway_defconfig 
> b/arch/mips/configs/xway_defconfig
> index f1c53bbb72e9..74cc4c5cce4c 100644
> --- a/arch/mips/configs/xway_defconfig
> +++ b/arch/mips/configs/xway_defconfig
> @@ -138,7 +138,6 @@ CONFIG_JFFS2_COMPRESSION_OPTIONS=y
>  CONFIG_SQUASHFS=y
>  # CONFIG_SQUASHFS_ZLIB is not set
>  CONFIG_SQUASHFS_XZ=y
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_PRINTK_TIME=y
>  CONFIG_STRIP_ASM_SYMS=y
>  CONFIG_DEBUG_FS=y
> diff --git a/arch/powerpc/configs/44x/eiger_defconfig 
> b/arch/powerpc/configs/44x/eiger_defconfig
> index 48ab405ab80b..240f3f453b5c 100644
> --- a/arch/powerpc/configs/44x/eiger_defconfig
> +++ b/arch/powerpc/configs/44x/eiger_defconfig
> @@ -85,6 +85,5 @@ CONFIG_CRYPTO_MD4=y
>  CONFIG_CRYPTO_MD5=y
>  CONFIG_CRYPTO_SHA1=y
>  CONFIG_CRYPTO_SHA512=y
> -CONFIG_CRYPTO_ARC4=y
>  CONFIG_CRYPTO_BLOWFISH=y
>  CONFIG_CRYPTO_DES=y
> diff --git a/arch/powerpc/configs/44x/redwood_defconfig 
> b/arch/powerpc/configs/44x/redwood_defconfig
> index 1e883938ca11..a8b93d7a592d 100644
> --- a/arch/powerpc/configs/44x/redwood_defconfig
> +++ b/arch/powerpc/configs/44x/redwood_defconfig
> @@ -84,6 +84,5 @@ CONFIG_CRYPTO_MD4=y
>  CONFIG_CRYPTO_MD5=y
>  CONFIG_CRYPTO_SHA1=y
>  CONFIG_CRYPTO_SHA512=y
> -CONFIG_CRYPTO_ARC4=y
>  CONFIG_CRYPTO_BLOWFISH=y
>  CONFIG_CRYPTO_DES=y
> diff --git a/arch/s390/configs/debug_defconfig 
> b/arch/s390/configs/debug_defconfig
> index d44674b63715..e457b13057d2 100644
> --- a/arch/s390/configs/debug_defconfig
> +++ b/arch/s390/configs/debug_defconfig
> @@ -802,7 +802,6 @@ CONFIG_CRYPTO_SM4_GENERIC=m
>  CONFIG_CRYPTO_TEA=m
>  CONFIG_CRYPTO_TWOFISH=m
>  CONFIG_CRYPTO_ADIANTUM=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_HCTR2=m
>  CONFIG_CRYPTO_LRW=m
>  CONFIG_CRYPTO_AEGIS128=m
> diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
> index e00e252d4694..9e10ac7b1c85 100644
> --- a/arch/s390/configs/defconfig
> +++ b/arch/s390/configs/defconfig
> @@ -786,7 +786,6 @@ CONFIG_CRYPTO_SM4_GENERIC=m
>  CONFIG_CRYPTO_TEA=m
>  CONFIG_CRYPTO_TWOFISH=m
>  CONFIG_CRYPTO_ADIANTUM=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_HCTR2=m
>  CONFIG_CRYPTO_LRW=m
>  CONFIG_CRYPTO_AEGIS128=m
> diff --git a/arch/sh/configs/sh2007_defconfig 
> b/arch/sh/configs/sh2007_defconfig
> index 3060bcd9cc5f..ce641ed3a147 100644
> --- a/arch/sh/configs/sh2007_defconfig
> +++ b/arch/sh/configs/sh2007_defconfig
> @@ -176,7 +176,6 @@ CONFIG_CRYPTO_TGR192=y
>  CONFIG_CRYPTO_WP512=y
>  CONFIG_CRYPTO_AES=y
>  CONFIG_CRYPTO_ANUBIS=y
> -CONFIG_CRYPTO_ARC4=y
>  CONFIG_CRYPTO_BLOWFISH=y
>  CONFIG_CRYPTO_CAMELLIA=y
>  CONFIG_CRYPTO_CAST5=y
> diff --git a/arch/sh/configs/titan_defconfig 
> b/arch/sh/configs/titan_defconfig
> index 00863ecb228e..6f690a0a26d7 100644
> --- a/arch/sh/configs/titan_defconfig
> +++ b/arch/sh/configs/titan_defconfig
> @@ -252,7 +252,6 @@ CONFIG_CRYPTO_TGR192=m
>  CONFIG_CRYPTO_WP512=m
>  CONFIG_CRYPTO_AES=y
>  CONFIG_CRYPTO_ANUBIS=m
> -CONFIG_CRYPTO_ARC4=y
>  CONFIG_CRYPTO_BLOWFISH=m
>  CONFIG_CRYPTO_CAST5=m
>  CONFIG_CRYPTO_CAST6=m
> diff --git a/arch/sparc/configs/sparc32_defconfig 
> b/arch/sparc/configs/sparc32_defconfig
> index d5579217fb4c..2f688b83e21b 100644
> --- a/arch/sparc/configs/sparc32_defconfig
> +++ b/arch/sparc/configs/sparc32_defconfig
> @@ -84,7 +84,6 @@ CONFIG_CRYPTO_MD4=y
>  CONFIG_CRYPTO_SHA256=m
>  CONFIG_CRYPTO_SHA512=m
>  CONFIG_CRYPTO_AES=m
> -CONFIG_CRYPTO_ARC4=m
>  CONFIG_CRYPTO_BLOWFISH=m
>  CONFIG_CRYPTO_CAST5=m
>  CONFIG_CRYPTO_CAST6=m
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 981d5dc422d4..2d727f708d9a 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -613,19 +613,6 @@ config CRYPTO_ADIANTUM
> 
>  	  If unsure, say N.
> 
> -config CRYPTO_ARC4
> -	tristate "ARC4 (Alleged Rivest Cipher 4)"
> -	depends on CRYPTO_USER_API_ENABLE_OBSOLETE
> -	select CRYPTO_SKCIPHER
> -	select CRYPTO_LIB_ARC4
> -	help
> -	  ARC4 cipher algorithm
> -
> -	  ARC4 is a stream cipher using keys ranging from 8 bits to 2048
> -	  bits in length.  This algorithm is required for driver-based
> -	  WEP, but it should not be for other purposes because of the
> -	  weakness of the algorithm.
> -
>  config CRYPTO_CHACHA20
>  	tristate "ChaCha"
>  	select CRYPTO_LIB_CHACHA
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 33bb5ad595e8..768a09b7162a 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -133,7 +133,6 @@ obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia_generic.o
>  obj-$(CONFIG_CRYPTO_CAST_COMMON) += cast_common.o
>  obj-$(CONFIG_CRYPTO_CAST5) += cast5_generic.o
>  obj-$(CONFIG_CRYPTO_CAST6) += cast6_generic.o
> -obj-$(CONFIG_CRYPTO_ARC4) += arc4.o
>  obj-$(CONFIG_CRYPTO_TEA) += tea.o
>  obj-$(CONFIG_CRYPTO_KHAZAD) += khazad.o
>  obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
> diff --git a/crypto/arc4.c b/crypto/arc4.c
> deleted file mode 100644
> index 1608018111d0..000000000000
> --- a/crypto/arc4.c
> +++ /dev/null
> @@ -1,82 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0-or-later
> -/*
> - * Cryptographic API
> - *
> - * ARC4 Cipher Algorithm
> - *
> - * Jon Oberheide <jon@oberheide.org>
> - */
> -
> -#include <crypto/arc4.h>
> -#include <crypto/internal/skcipher.h>
> -#include <linux/init.h>
> -#include <linux/kernel.h>
> -#include <linux/module.h>
> -#include <linux/sched.h>
> -
> -#define ARC4_ALIGN __alignof__(struct arc4_ctx)
> -
> -static int crypto_arc4_setkey(struct crypto_lskcipher *tfm, const u8 
> *in_key,
> -			      unsigned int key_len)
> -{
> -	struct arc4_ctx *ctx = crypto_lskcipher_ctx(tfm);
> -
> -	return arc4_setkey(ctx, in_key, key_len);
> -}
> -
> -static int crypto_arc4_crypt(struct crypto_lskcipher *tfm, const u8 
> *src,
> -			     u8 *dst, unsigned nbytes, u8 *siv, u32 flags)
> -{
> -	struct arc4_ctx *ctx = crypto_lskcipher_ctx(tfm);
> -
> -	if (!(flags & CRYPTO_LSKCIPHER_FLAG_CONT))
> -		memcpy(siv, ctx, sizeof(*ctx));
> -
> -	ctx = (struct arc4_ctx *)siv;
> -
> -	arc4_crypt(ctx, dst, src, nbytes);
> -	return 0;
> -}
> -
> -static int crypto_arc4_init(struct crypto_lskcipher *tfm)
> -{
> -	pr_warn_ratelimited("\"%s\" (%ld) uses obsolete ecb(arc4) skcipher\n",
> -			    current->comm, (unsigned long)current->pid);
> -
> -	return 0;
> -}
> -
> -static struct lskcipher_alg arc4_alg = {
> -	.co.base.cra_name		=	"arc4",
> -	.co.base.cra_driver_name	=	"arc4-generic",
> -	.co.base.cra_priority		=	100,
> -	.co.base.cra_blocksize		=	ARC4_BLOCK_SIZE,
> -	.co.base.cra_ctxsize		=	sizeof(struct arc4_ctx),
> -	.co.base.cra_alignmask		=	ARC4_ALIGN - 1,
> -	.co.base.cra_module		=	THIS_MODULE,
> -	.co.min_keysize			=	ARC4_MIN_KEY_SIZE,
> -	.co.max_keysize			=	ARC4_MAX_KEY_SIZE,
> -	.co.statesize			=	sizeof(struct arc4_ctx),
> -	.setkey				=	crypto_arc4_setkey,
> -	.encrypt			=	crypto_arc4_crypt,
> -	.decrypt			=	crypto_arc4_crypt,
> -	.init				=	crypto_arc4_init,
> -};
> -
> -static int __init arc4_init(void)
> -{
> -	return crypto_register_lskcipher(&arc4_alg);
> -}
> -
> -static void __exit arc4_exit(void)
> -{
> -	crypto_unregister_lskcipher(&arc4_alg);
> -}
> -
> -module_init(arc4_init);
> -module_exit(arc4_exit);
> -
> -MODULE_LICENSE("GPL");
> -MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
> -MODULE_AUTHOR("Jon Oberheide <jon@oberheide.org>");
> -MODULE_ALIAS_CRYPTO("ecb(arc4)");
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index e6834bdde9b9..579a05d39856 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -1579,10 +1579,6 @@ static int do_test(const char *alg, u32 type, 
> u32 mask, int m, u32 num_mb)
>  		ret = min(ret, tcrypt_test("xts(cast6)"));
>  		break;
> 
> -	case 16:
> -		ret = min(ret, tcrypt_test("ecb(arc4)"));
> -		break;
> -
>  	case 18:
>  		ret = min(ret, tcrypt_test("crc32c"));
>  		break;
> @@ -1995,11 +1991,6 @@ static int do_test(const char *alg, u32 type, 
> u32 mask, int m, u32 num_mb)
>  				  speed_template_32_64);
>  		break;
> 
> -	case 208:
> -		test_cipher_speed("ecb(arc4)", ENCRYPT, sec, NULL, 0,
> -				  speed_template_8);
> -		break;
> -
>  	case 209:
>  		test_cipher_speed("ecb(cast5)", ENCRYPT, sec, NULL, 0,
>  				  speed_template_8_16);
> @@ -2486,11 +2477,6 @@ static int do_test(const char *alg, u32 type, 
> u32 mask, int m, u32 num_mb)
>  				   speed_template_32_48_64);
>  		break;
> 
> -	case 505:
> -		test_acipher_speed("ecb(arc4)", ENCRYPT, sec, NULL, 0,
> -				   speed_template_8);
> -		break;
> -
>  	case 506:
>  		test_acipher_speed("ecb(cast5)", ENCRYPT, sec, NULL, 0,
>  				   speed_template_8_16);
> @@ -2709,11 +2695,6 @@ static int do_test(const char *alg, u32 type, 
> u32 mask, int m, u32 num_mb)
>  				       speed_template_32_48_64, num_mb);
>  		break;
> 
> -	case 605:
> -		test_mb_skcipher_speed("ecb(arc4)", ENCRYPT, sec, NULL, 0,
> -				       speed_template_8, num_mb);
> -		break;
> -
>  	case 606:
>  		test_mb_skcipher_speed("ecb(cast5)", ENCRYPT, sec, NULL, 0,
>  				       speed_template_8_16, num_mb);
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 9419d61d0602..094f8e0853f0 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -4665,13 +4665,6 @@ static const struct alg_test_desc 
> alg_test_descs[] = {
>  		.suite = {
>  			.cipher = __VECS(anubis_tv_template)
>  		}
> -	}, {
> -		.alg = "ecb(arc4)",
> -		.generic_driver = "arc4-generic",
> -		.test = alg_test_skcipher,
> -		.suite = {
> -			.cipher = __VECS(arc4_tv_template)
> -		}
>  	}, {
>  		.alg = "ecb(aria)",
>  		.test = alg_test_skcipher,
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index 0ee15a8fae27..a7f096b0830e 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -24388,68 +24388,6 @@ static const struct cipher_testvec 
> cast5_ctr_tv_template[] = {
>  	},
>  };
> 
> -/*
> - * ARC4 test vectors from OpenSSL
> - */
> -static const struct cipher_testvec arc4_tv_template[] = {
> -	{
> -		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
> -		.klen	= 8,
> -		.ptext	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
> -		.ctext	= "\x75\xb7\x87\x80\x99\xe0\xc5\x96",
> -		.len	= 8,
> -	}, {
> -		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
> -		.klen	= 8,
> -		.ptext	= "\x00\x00\x00\x00\x00\x00\x00\x00",
> -		.ctext	= "\x74\x94\xc2\xe7\x10\x4b\x08\x79",
> -		.len	= 8,
> -	}, {
> -		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00",
> -		.klen	= 8,
> -		.ptext	= "\x00\x00\x00\x00\x00\x00\x00\x00",
> -		.ctext	= "\xde\x18\x89\x41\xa3\x37\x5d\x3a",
> -		.len	= 8,
> -	}, {
> -		.key	= "\xef\x01\x23\x45",
> -		.klen	= 4,
> -		.ptext	= "\x00\x00\x00\x00\x00\x00\x00\x00"
> -			  "\x00\x00\x00\x00\x00\x00\x00\x00"
> -			  "\x00\x00\x00\x00",
> -		.ctext	= "\xd6\xa1\x41\xa7\xec\x3c\x38\xdf"
> -			  "\xbd\x61\x5a\x11\x62\xe1\xc7\xba"
> -			  "\x36\xb6\x78\x58",
> -		.len	= 20,
> -	}, {
> -		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
> -		.klen	= 8,
> -		.ptext	= "\x12\x34\x56\x78\x9A\xBC\xDE\xF0"
> -			  "\x12\x34\x56\x78\x9A\xBC\xDE\xF0"
> -			  "\x12\x34\x56\x78\x9A\xBC\xDE\xF0"
> -			  "\x12\x34\x56\x78",
> -		.ctext	= "\x66\xa0\x94\x9f\x8a\xf7\xd6\x89"
> -			  "\x1f\x7f\x83\x2b\xa8\x33\xc0\x0c"
> -			  "\x89\x2e\xbe\x30\x14\x3c\xe2\x87"
> -			  "\x40\x01\x1e\xcf",
> -		.len	= 28,
> -	}, {
> -		.key	= "\xef\x01\x23\x45",
> -		.klen	= 4,
> -		.ptext	= "\x00\x00\x00\x00\x00\x00\x00\x00"
> -			  "\x00\x00",
> -		.ctext	= "\xd6\xa1\x41\xa7\xec\x3c\x38\xdf"
> -			  "\xbd\x61",
> -		.len	= 10,
> -	}, {
> -		.key	= "\x01\x23\x45\x67\x89\xAB\xCD\xEF"
> -			"\x00\x00\x00\x00\x00\x00\x00\x00",
> -		.klen	= 16,
> -		.ptext	= "\x01\x23\x45\x67\x89\xAB\xCD\xEF",
> -		.ctext	= "\x69\x72\x36\x59\x1B\x52\x42\xB1",
> -		.len	= 8,
> -	},
> -};
> -
>  /*
>   * TEA test vectors
>   */
> diff --git a/include/crypto/arc4.h b/include/crypto/arc4.h
> index f3c22fe01704..f88a5fb85c9a 100644
> --- a/include/crypto/arc4.h
> +++ b/include/crypto/arc4.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0+ */
>  /*
> - * Common values for ARC4 Cipher Algorithm
> + * ARC4 Cipher Algorithm
>   */
> 
>  #ifndef _CRYPTO_ARC4_H
> @@ -10,7 +10,6 @@
> 
>  #define ARC4_MIN_KEY_SIZE	1
>  #define ARC4_MAX_KEY_SIZE	256
> -#define ARC4_BLOCK_SIZE		1
> 
>  struct arc4_ctx {
>  	u32 S[256];
>
> base-commit: e9954f3fbddd25e1a01b7e5a0b72fb8b564204e0
> -- 
> 2.56.0
