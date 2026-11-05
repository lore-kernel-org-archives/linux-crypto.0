Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793871834;
	b=BYFVA0/dsrhX8rW84FPbvVLBQ5HzjRoKCm4rCGdRO2CcjsOsa4y+z7XeS/29FwNLfNC+
	 XbY6fMHOWCfclphPjAHwiEYSlPzUqlqBUgFDUK5UZxhudJ4akr3Hts3Eh/TgyPXZcCKdn
	 dAZmUxoCawMhrwC+H3ClgQYRlMdl1uqs7+5xEN/1Qe8jyUD57uddOmD60Alj6szoLiH1m
	 SyocZiitL3klN6vEpTckK0KIv9+BvqNlydXL53wuNvnzWvkM5u2qjcEr2AdtSGBbJuCWu
	 LhdwipmrbGCsfsgNBwQMSzVEgfDXx2zgr7LUT/mOwmrkZKUPapvejslNAN899nDhv6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793871834;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=c41V7BByAOkpHrvRkTypMFKlqtDX9QfhZJ/wih1geKI=;
	b=mrTew+CymQcc/wDVmjgUgyAvXVxylGXlhTXm+RtWK+3ON7s44UGn+y8Y+AI8EPPJ6j2k
	 kov7lKDwHxaN+I578VY0f9UsUBEQwv5G727kuqCFPr13Qm1FHKaFwK9r1KL8R0MmDTa0c
	 Gh0e/Z1T2BucPDEkyPiZvuxD9pQBVvd4i5n+Na1KSafWIc7D4tRTT5w2h13NgxzIxBzKa
	 Nk8PvWF2cmsoC2toBo0XGcODoSoCcNWfZsty3iHsBxLKSwOw1Nt87aNuJpCSbOezeVxxd
	 K91v3pV2G+Olc6P6oUtUlCAN9s2rN/YIvB4LhQg6BU2RI/kUCHHCfh4uiHPuW3TyOKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=1tJRdVRh;
	arc=none smtp.remote-ip=195.10.208.46
Received: from mout-b-106.mailbox.org (mout-b-106.mailbox.org [195.10.208.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBE4606A328
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 09:43:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FBE4606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=1tJRdVRh
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-106.mailbox.org (Postfix) with ESMTPS id 4jKy7614n9zNlKG;
	Thu, 05 Nov 2026 10:43:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1793871826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c41V7BByAOkpHrvRkTypMFKlqtDX9QfhZJ/wih1geKI=;
	b=1tJRdVRhqLACT4ME94tH+8uxBYDSVqArgT91hqTAXrkyEb0/YIwwftIqIFy0yrCJy7MaxE
	EiPXjsROoEZZnQd2HHJWU7WD01XmxuJfhowGvtQi/NCKHpdQyFBpKYluK/yg2jCEdTGpS6
	c51kP9D0ounYWN9KRTHlE1eZVzSdJM10rJuPgjE7XHRkIINXbW0Gvr2oRQ0jY82mANv7RR
	vy8rIvxCoVEiiTo+gALpCTkAsp9Ib1XOQbhZ4Lq32dQtOdqqfgx/qm66FDxMvPtbfV+Fi0
	E7oUOc5z4Iu2SWsD95F+N/BLiYPM6iRO6JUYX4nYf9ii+wwWP12WQgpUMsRAcw==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <2437dd15-0ba9-4b2d-8c15-81fedaf677b8@mandelbit.com>
Date: Thu, 5 Nov 2026 10:43:44 +0100
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
Subject: Re: [PATCH] lib/crypto: x86/chacha: Improve interleaving in
 chacha_8block_xor_avx512vl()
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld"
 <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Martin Willi <martin@strongswan.org>
References: <20261104061209.143901-1-ebiggers@kernel.org>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261104061209.143901-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jKy7614n9zNlKG

Tested on Zen 5 (Ryzen 9 9950X) in a KVM guest, on top of the bzhi
and vzeroupper patches. KUnit chacha suite + benchmark (64..16384 B,
3 runs each), compared with the tree without this patch:

   path                 CPU setup              KUnit  perf
   -------------------  ---------------------  -----  ------------
   AVX-512, zmm         native                 pass   -1.6..+0.5%
   AVX-512VL, ymm only  spoofed SKX (6/0x55)   pass   -0.4..+1.2%

16-block code unchanged (identical disassembly).

Tested-by: Antonio Quartulli <antonio@mandelbit.com>


-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

