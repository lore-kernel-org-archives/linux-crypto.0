Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794440265;
	b=2/akOt21qGKlaFwDfZqznXFM/LtIqq1tBMKxmwGeoePUYZHpAhfhvQJmSitsEPSCsPK0
	 KIc0gxFM1GCzTR2fu+Q0LqAmLlyGr5ks97udhgJUwbzra73vTpx7L2bbzW5gdHTXDQqqh
	 RQtiUfvs1/HMgCd5dsoepRv4DlCvT256OmmVTxDKA13sg9QQyBlIB0ceQxp49dyyJze4r
	 mJrmMRwafgnZ3G2fQxK5FfjlNDRjKjaiz+DaOEB0SD9HYQ9yAUfwYecLzUlRbXiGbO/zg
	 UC4qNE4yl7F4ocNpcuIFGGFYNXMUs7QkKFzEmYniLAxAe+OoLPmmTrOlnugO3+NjzEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794440265;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=lJdT0fOI9E139SqFIzvgiNh3N78RYBsKwVaI7zZt/yg=;
	b=rIN8qYktL8ol6y+HCC0XfQoD9IlglIa7n6/sHALpzAU6kRNoBL0L0OFIyE8jNEP+jujZ
	 Ab3eTfcIoIl4sgqXpqejd3s9TFDaf+QHdo7AScc7KZ+JcSIkOy57MSDLQi9IK4+TfUF2h
	 7ctZiVflEbw7+RDQ9j6Dzs8sRN3dP68h+6MEVpyNs5mUwcpEMq2TuX2+bZ1PfxTr4NTNf
	 9iiBa7Kxuie4W05QTaVbhiey79XL3Mz7W7JX60kTH/UkN29cqZ6N1R4KYnxkBaH95AZxW
	 KOMRQ+rQqUrnDqM7WWLnHZsX/oyhkhL/+NIV05lZ9u4YikcPocNvHrydwWZNlk57NFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=VOohpbsf;
	arc=none smtp.remote-ip=195.10.208.55
Received: from mout-b-110.mailbox.org (mout-b-110.mailbox.org [195.10.208.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045ED606A31C
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 23:37:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 045ED606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=VOohpbsf
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-110.mailbox.org (Postfix) with ESMTPS id 4jQ0LQ2tlDzNlpY;
	Thu, 12 Nov 2026 00:37:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1794440254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lJdT0fOI9E139SqFIzvgiNh3N78RYBsKwVaI7zZt/yg=;
	b=VOohpbsfTdgqN6PnDzPciMaVo8lLkiFGu/uKkSosFwet3Ebw7MUxmtaq2iiu1Kbcx3/fHq
	Fe1o4z7noU5ST0TlBauwGnCJv0FOAuJCI5YQ6lD/FjfOtwOh1AvOJjC43NzfDCY4xOnbq6
	XCuHXgc5kg2ni81lnVnczhL1qK0WFCIOCaShytEwDRe2v9u0UMLKBAfHArzQCBgG6aHfUe
	WoGl2hmZ91nN0ZxSN5dU69Z8+JHXNZA7OFl0MK09ufA3YR2tPutnkrlrhVCNwEkK3ofzct
	GAuN1ORxUdpGOihjhGiE2EflCzPSPljg0W3VoTtfWrmQ0qTI0qqp53+4b7fO3A==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::202 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <bb57a569-66ce-4126-a1e1-40af464a8334@mandelbit.com>
Date: Thu, 12 Nov 2026 00:37:33 +0100
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
Subject: Re: [PATCH] lib/crypto: x86/chacha: Drop redundant moves from AVX2
 code
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld"
 <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Martin Willi <martin@strongswan.org>
References: <20261111223455.89467-1-ebiggers@kernel.org>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261111223455.89467-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jQ0LQ2tlDzNlpY

Hi,

On 11/11/2026 23:34, Eric Biggers wrote:
> The AVX2 optimized ChaCha code has many instances of moving one register
> to another, then left-shifting the destination register with 'vpslld'.
> This pattern likely was copied from the SSSE3 code, which uses 'pslld'.
> However, like all the other AVX instructions, 'vpslld' has separate
> source and destination registers.  Just utilize that instead.

Tested on a Ryzen 9 9950X in a KVM guest with AVX-512 hidden, so that
the AVX2 code is used: the ChaCha and ChaCha20-Poly1305 KUnit tests
pass.
The ChaCha benchmark shows no difference beyond noise (+/-0.6% at every
length, 3 runs each).

Reviewed-by: Antonio Quartulli <antonio@mandelbit.com>
Tested-by: Antonio Quartulli <antonio@mandelbit.com>

-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

