Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051681DB55E;
	Fri, 13 Sep 2024 13:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726235762; cv=none; b=WZI1yMPkC0+rQukcM/hUv0GummvHYYvS7toLW6Kc3gmfBD8olyrfwiv7/WEsTTRRfvo9keSiqsf7Z7gL9t6JjCbqLpUM1aV3zBGRP5sdX7ST5xtSbuXoz1Aj0+mSQ6IgF5cXaVLKZ5I59TiJSWKSfIdpNphC2ewViC+g8ymbdGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726235762; c=relaxed/simple;
	bh=Aaxomep/WHOUGpm7S7gaJ/QXCPerPw8W3t7xe21LvnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DpNvP2kojtLL5L9Fbxs+5w5XJNjiMTj2p9P6lLKMVe+dTQ1zi0HpIpcoqja17frEMGGqxVybmmQUAm/hzEMz/AZWFjSNxidpnqSuvxE3LInXlFPr4Ce8W1blJDbPMhKFg0gfn6QAgSmZGc+2vbFqlhBf/6fJyZQBjv5SW7djlLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4X4wnT638kz9sfV;
	Fri, 13 Sep 2024 15:55:57 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NdghGpa9uVpK; Fri, 13 Sep 2024 15:55:57 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4X4wnT56q9z9sVl;
	Fri, 13 Sep 2024 15:55:57 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 8B0F68B77C;
	Fri, 13 Sep 2024 15:55:57 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id 00vgt6UPj302; Fri, 13 Sep 2024 15:55:57 +0200 (CEST)
Received: from [192.168.233.70] (unknown [192.168.233.70])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 0FB758B766;
	Fri, 13 Sep 2024 15:55:57 +0200 (CEST)
Message-ID: <4742a397-eb68-4a79-a2fa-fc45a81e7c2b@csgroup.eu>
Date: Fri, 13 Sep 2024 15:55:56 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: Removing CRYPTO_AES_GCM_P10.
To: Danny Tsen <dtsen@linux.ibm.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
 appro@cryptogams.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
 ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
References: <20240913123043.1636183-1-dtsen@linux.ibm.com>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20240913123043.1636183-1-dtsen@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 13/09/2024 à 14:30, Danny Tsen a écrit :
> [Vous ne recevez pas souvent de courriers de dtsen@linux.ibm.com. Découvrez pourquoi ceci est important à https://aka.ms/LearnAboutSenderIdentification ]
> 
> Removing CRYPTO_AES_GCM_P10 in Kconfig first so that we can apply the
> subsequent patches to fix data mismatch over ipsec tunnel.

To deactivate a driver, all you have to do is to add:

	depends on BROKEN

Christophe


> 
> Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
> ---
>   arch/powerpc/crypto/Kconfig | 32 ++++++++++++++++----------------
>   1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
> index 09ebcbdfb34f..96ca2c4c8827 100644
> --- a/arch/powerpc/crypto/Kconfig
> +++ b/arch/powerpc/crypto/Kconfig
> @@ -105,22 +105,22 @@ config CRYPTO_AES_PPC_SPE
>            architecture specific assembler implementations that work on 1KB
>            tables or 256 bytes S-boxes.
> 
> -config CRYPTO_AES_GCM_P10
> -       tristate "Stitched AES/GCM acceleration support on P10 or later CPU (PPC)"
> -       depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
> -       select CRYPTO_LIB_AES
> -       select CRYPTO_ALGAPI
> -       select CRYPTO_AEAD
> -       select CRYPTO_SKCIPHER
> -       help
> -         AEAD cipher: AES cipher algorithms (FIPS-197)
> -         GCM (Galois/Counter Mode) authenticated encryption mode (NIST SP800-38D)
> -         Architecture: powerpc64 using:
> -           - little-endian
> -           - Power10 or later features
> -
> -         Support for cryptographic acceleration instructions on Power10 or
> -         later CPU. This module supports stitched acceleration for AES/GCM.
> +#config CRYPTO_AES_GCM_P10
> +#      tristate "Stitched AES/GCM acceleration support on P10 or later CPU (PPC)"
> +#      depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
> +#      select CRYPTO_LIB_AES
> +#      select CRYPTO_ALGAPI
> +#      select CRYPTO_AEAD
> +#      select CRYPTO_SKCIPHER
> +#      help
> +#        AEAD cipher: AES cipher algorithms (FIPS-197)
> +#        GCM (Galois/Counter Mode) authenticated encryption mode (NIST SP800-38D)
> +#        Architecture: powerpc64 using:
> +#          - little-endian
> +#          - Power10 or later features
> +#
> +#        Support for cryptographic acceleration instructions on Power10 or
> +#        later CPU. This module supports stitched acceleration for AES/GCM.
> 
>   config CRYPTO_CHACHA20_P10
>          tristate "Ciphers: ChaCha20, XChacha20, XChacha12 (P10 or later)"
> --
> 2.43.0
> 
> 
