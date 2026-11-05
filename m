Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793871801;
	b=n84v1hI8mxxhLJGW7LtpeoC2/LzR6JZy+Fb5sYfciwNzf1g4Mdhx4uhsNi1jtXTFH5mf
	 YduWkUbYnMv2EFx7UP5pehp8hs6c9sV7BGLVAP832tAM2Eyt29/SXJOWxWxs3eyRLOVa9
	 4gCYIZteJqSxWfQSS4iBkL4eVSz9Zcvzr9iDCH1OUIWqyewL+ZIJz/BiRl7GSpTxx29N/
	 L98AvN3M6EDmIVxGpiqRCg5snZAU8a4SUmZiJOQJWihYMXusUhiO3/5gu5+qfba49002o
	 PLOFAnGifyPdTtg8DogEmYhA4zDTctVBC1xDGlndkAnLr/rTgA4ArFSKowNqGUZ+SDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793871801;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=2HDIIMx9SJ8j2pZYWA5q8DBTAabyvw87RL2lFe+WM2M=;
	b=VxJH9NDh0qBcuFX89P5AY4vRtYfeMnoQOwDB3C8nXxQWLcJcSFpHBGu3P4t8PSwzC8wi
	 UCvrO4AxN9pMWaj3QZwA0aeFewhG9CTs8IdkuoJlcrKy2nsDoyVsQhCKZV9fgTzIJicA/
	 r0bAJ8RWVzQ9kdjeT/RGkkTgTPC3BEBqCH2rdqPfiSppT4t/XTt6UkaqbIS6BpPN1TyX+
	 GXsu9aq/NUiI5wSneFAyqed/w1pklb9m9sBcpHff/NXS4KtdPCOP1qndpMORTSX6CfK/8
	 fNfxHsrQmu/ZbvlxAL3ldWG54ZXT38psDxYV2qF5Xccj79XEP0x8AfZtAfMSN9ImAfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=RppS6KWA;
	arc=none smtp.remote-ip=195.10.208.42
Received: from mout-b-112.mailbox.org (mout-b-112.mailbox.org [195.10.208.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41280606A326
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 09:43:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41280606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=RppS6KWA
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-112.mailbox.org (Postfix) with ESMTPS id 4jKy6S4qCmz5wpH;
	Thu, 05 Nov 2026 10:43:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1793871792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2HDIIMx9SJ8j2pZYWA5q8DBTAabyvw87RL2lFe+WM2M=;
	b=RppS6KWAllBXna4+0A4RXtnpcTAna0VJFanOalyxKEhpRkEZ1+I3rh4olcxD12SifRhlL5
	CrcpE2Mof0izwmD1aF44jBNzrj/ZCdLvSBWO/DkCe0Vj42Xbg6BWPuvWkReQBi5yAXYeQv
	g+hkgoGatz4GkwMuHrFEHnKJq7HzViCpdkBMI0jTr/taDo1gnWkI2ogGKowL5ZXKs7oD/1
	A+ppLomfo70rMckLh8Mp34cKFDPdJsCOsyqmeKWBzzem5XzdJZVOlm/LPTZa8KY1vX76wJ
	CGwl+aQFPchYqNlpiDaigJZ7gb8suxnEmdD+ovWgW8N2QbLDlhusrw7vTtdwvg==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <1cdcef2d-8c21-4a45-9eda-3daa4c493066@mandelbit.com>
Date: Thu, 5 Nov 2026 10:43:10 +0100
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
Subject: Re: [PATCH] lib/crypto: x86/chacha: Remove vzeroupper at beginning of
 functions
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld"
 <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Martin Willi <martin@strongswan.org>
References: <20261104053830.82604-1-ebiggers@kernel.org>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261104053830.82604-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jKy6S4qCmz5wpH

Tested on Zen 5 (Ryzen 9 9950X) in a KVM guest, on top of the bzhi
patch. KUnit chacha suite + benchmark (64..16384 B, 3 runs each),
compared with the tree without this patch:

   path                 CPU setup              KUnit  perf
   -------------------  ---------------------  -----  ------------
   AVX-512, zmm         native                 pass   -0.5..+0.5%
   AVX-512VL, ymm only  spoofed SKX (6/0x55)   pass   -0.8..+0.1%
   AVX2                 clearcpuid=avx512f     pass   +0.1..+1.9%

Tested-by: Antonio Quartulli <antonio@mandelbit.com>

-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

