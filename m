Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794479754;
	b=henTMzOOPhQam4owVHUC1NRd6VNnFl4xlD7R2B0zgoowvTFKzaB8GwyGhtJvSeloIahM
	 Z4u4bB3Hs/0RD3hm+1Oo1c5LN9vjkafXwfpvpRDkRd7vEKm2nADeQtPTEQY9krli6YzY5
	 SXxncCP2VQwQUHqZ0TqCKZLNS6jIhSKP7jSzp+rzcMnRAnfEMPWr+a1AYCRI5AoGP9wL0
	 ofkMvJyd1AoJkUHTHMmsI+38HvVJJwVkGLMcmL+0GkOCfcufveHV5Ld9+Q8dfIIt5+v29
	 cxMUa/acSUWr+NxUICO0htAImuwWmJ8JGtYOYR6KqXlCIiWBm5u5jvyiq7q4Ii6/GVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794479754;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=K81mWYhMFrWqy7LbBT24c0bfAlTliufbMupmkf2zFog=;
	b=JaWYh9Pw9TTt8BEpsmHCt6F+2y5ZVqh7Mv8i1IIljjN2/n6lzFD5FBcPohrHPXkHayPf
	 AonJrHVPluq7ECSkT+aaoK0zDJ18IB7v0LVOrZZEEvFYXjqwes1dHRP0nniBoXQeSQNF5
	 ersYlpcyia0+kPjv2VTkSLBQlyCkpI0JgbLPi/7CSEaT82n/P5RSBtta3k5yKhO8/PtTm
	 bUn1NRuESQZQ9mmUnwb3cdavP+trjaIOADaYQgsIghIVnAfiw+Yb3RCc6DgtooTDpoPuZ
	 yzMQbeUEq5zRQvC6rb1G1dh3G4VNP0l1RdoRX8dCvQz5vIZlls11/0K+M6Al/tSrpIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=SveVj1jA;
	arc=none smtp.remote-ip=195.10.208.55
Received: from mout-b-110.mailbox.org (mout-b-110.mailbox.org [195.10.208.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F7C606A32A
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 10:35:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92F7C606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=SveVj1jA
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-110.mailbox.org (Postfix) with ESMTPS id 4jQGxw2Gm6zNknJ;
	Thu, 12 Nov 2026 11:35:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1794479748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K81mWYhMFrWqy7LbBT24c0bfAlTliufbMupmkf2zFog=;
	b=SveVj1jAjhYLADs6RyhfZy4JnV4S30zV3e1iCbPdm2ypl+im5SHols7fYzKG4J3k9Zxz+0
	TD6SKcICZ049qK0yjdOvB89eFYjX1yREP7hwV+Pig6ZMdfnHADKqnMGR4iX+pZgLPq0jo6
	fR+2QtVWtq+VXnq9sfE2jezGyoOST3xpeZbrvYzZnMV0OVFJ2DOzOUouLQBGfyrvn/lbk7
	qeNMCQfpJdaNNg43WBgGlhwhANOBeV2JQIo9FiKSVNLwKxTHtvOnEcH683fQtT6TgmYCtI
	6Trw0V06gzJm1PR/lfAnjtn6T06dDvSdjLVSJO8UIiZ6c2mkwc2QEJc2h5FaHg==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <0280ecc9-fcc1-48e5-b248-4641c30e5cb5@mandelbit.com>
Date: Thu, 12 Nov 2026 11:35:45 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/crypto: x86/chacha: Fix mistakes and inconsistencies
 in comments
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld"
 <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Martin Willi <martin@strongswan.org>
References: <20261112034453.12795-1-ebiggers@kernel.org>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261112034453.12795-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jQGxw2Gm6zNknJ

Hi Eric,

On 12/11/2026 04:44, Eric Biggers wrote:
> diff --git a/lib/crypto/x86/chacha-avx512-x86_64.S b/lib/crypto/x86/chacha-avx512-x86_64.S
> index 127a94f1843bb..3a70608d4a7d2 100644
> --- a/lib/crypto/x86/chacha-avx512-x86_64.S
> +++ b/lib/crypto/x86/chacha-avx512-x86_64.S
> @@ -55,7 +55,7 @@ SYM_FUNC_START(chacha_0to2blocks_avx512vl)
>   	# on four words in each matrix in parallel, but requires shuffling to
>   	# rearrange the words after each round.
>   
> -	# x0..3[0-2] = s0..3
> +	# x0..3[0-1] = s0..3
>   	vbroadcasti128	0x00(%rdi),%ymm0
>   	vbroadcasti128	0x10(%rdi),%ymm1
>   	vbroadcasti128	0x20(%rdi),%ymm2
> @@ -195,7 +195,7 @@ SYM_FUNC_START(chacha_2to4blocks_avx512vl)
>   	# required word shuffling has a rather high latency, we can do the
>   	# arithmetic on two matrix-pairs without much slowdown.
>   
> -	# x0..3[0-4] = s0..3
> +	# x0..3[0-3] = s0..3
>   	vbroadcasti128	0x00(%rdi),%ymm0
>   	vbroadcasti128	0x10(%rdi),%ymm1
>   	vbroadcasti128	0x20(%rdi),%ymm2
> @@ -400,14 +400,14 @@ SYM_FUNC_END(chacha_2to4blocks_avx512vl)
>   	# %r8d: nrounds
>   
>   	# This encrypts VL/4 consecutive ChaCha blocks by loading the state
> -	# matrix in as many vector registers. Compared to AVX2, this mostly
> +	# matrix in vector registers VL/4 times. Compared to AVX2, this mostly
>   	# benefits from the new rotate instructions and the additional
>   	# registers.
>   	#
>   	# VL=32 encrypts eight blocks in 256-bit ymm registers.
>   	# VL=64 encrypts sixteen blocks in 512-bit zmm registers.
>   
> -	# x0..15[0-VL/4] = s[0..15]
> +	# x0..15[0-(VL/4 - 1)] = s[0..15]
>   	vpbroadcastd	0x00(%rdi),V0
>   	vpbroadcastd	0x04(%rdi),V1
>   	vpbroadcastd	0x08(%rdi),V2

Maybe you want to also fix chacha-avx512-x86_64.S:588?

         # x0..15 += s[0..15]
         vpaddd          V16,V0,V0

If I am not wrong, it'd be the only lacking the lane range now.

Regards,


-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

