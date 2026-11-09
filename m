Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794239238;
	b=17qwzRLqTv3571xgodECh0m6PuWMjn7yJshwc6D737B+RCHiM4cKOK+prEWFE0kVDx/M
	 l8eo9Q7rcef3WXcmTOMp1YsnSkx8N31e6yJ0Xqhs6GeYU8NL8mL549qsgz0uYvQmJu0Wm
	 jZtovQnqRvud+INKTdTONKdoXEcnfvi5mHac56QyoqZszCZxkUIZjw+btQV+kizj9F89D
	 PDcDCyg79aq04i4/lyrDkVk4/o4hsbeF2iShFZFee/Ft4NBYsiaRjIBEL5p6mJHu3cbz4
	 cvDrNVjMrIRiUzWjVtx1DZDi8ymctZ6dwuvyOzOa2KI9lp/VyoX+zlyrooj0Ynr/8Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794239238;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Content-Language:To:Cc:From:Subject:Organization:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id;
	bh=DZrPf1hpZbcC8nVxJuT5T9+Mzzh/Kjk+l9tgfjPY/54=;
	b=rm2qbl8SDmb4jJWfYoi0B7yh3RokuwzEuEgveT1hOFMnfAGhdfgCvVfzpEFdeqVHQCz+
	 9B/yK+ukuRq0f6eLJfIeeyW3KCCVkoTgHoV2UYE4K8OCVS/9Oh4+zkg3ftM4yZyKttpuD
	 9fvKbVxsdTPqOnv2herV1ymWBsNaUztumMG4gsAw04vfCVY5mcei0I+vkrh34qFGAxdvT
	 +0108Y0b/BGcDpVsxnyP2TudGujQR4jxU3n1NSAnQ6h+iNMdwM3M/0PbeBJsqJ+d4WUwA
	 rbmnenuAzFbOCaTZ9VoRQG9Es231k2WstgrRrRStEgquqDTlkqQqanEbIYosu4YGU/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=fFtzFWRj;
	arc=none smtp.remote-ip=195.10.208.51
Received: from mout-b-206.mailbox.org (mout-b-206.mailbox.org [195.10.208.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735B8606A31C
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 15:47:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 735B8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=fFtzFWRj
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-206.mailbox.org (Postfix) with ESMTPS id 4jNZ0T6SkDz1H;
	Mon, 09 Nov 2026 16:47:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1794239225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DZrPf1hpZbcC8nVxJuT5T9+Mzzh/Kjk+l9tgfjPY/54=;
	b=fFtzFWRjVa4irhVeeI80K6o31DaF1fvDwxls+IGONE3OLhr/bC1DEn9EH2Wl/SXsKu84EC
	oESILVehizq2yXxxeJoF9DhF74aNH6uTysQt/f/Tn0p+WIW6HgMXdLcktoII7FcNhmF94U
	OpeHFOs8Wnau73idPxj9SIV3b36uVxVkEvkvv6fbvASzfuwFRXXjD3YfABa3RWwxQNew41
	qYOJuFPG5zoYR49xDJea0VfbYVwk1kE6S3IahDh1WDUb/zKZRl9KQTmK/REP2yUJMrlLVE
	O0stXm/5QPJ8wzAOkqdbMSfzUSkmdHZcdgZ2LYTE8pQONTFQpP7+LADZ0Q6K0A==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <6ce2344c-f6b5-4051-87b0-88a1c258a6d3@mandelbit.com>
Date: Mon, 9 Nov 2026 16:47:05 +0100
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
Content-Language: en-US
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
From: Antonio Quartulli <antonio@mandelbit.com>
Subject: lib/crypto: AES-GCM x86 arch hooks: any plan?
Organization: Mandelbit SRL
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jNZ0T6SkDz1H

Hi Eric,

while working on optimising ovpn (OpenVPN data channel offload) we
prototyped what an x86 implementation of 
aes_gcm_{en,de}crypt_update_arch() would give us: ovpn calls the 
existing VAES-AVX512
GCM code directly on
linear records (AAD update, en/decrypt update and final in one FPU
section), instead of going through the crypto_aead API.

On a Ryzen 9 9950X (Zen 5), ovpn over 100G, MTU 1500, the receiver (the
bottleneck) saves ~120-127 cycles per record at every record size, i.e. the
request/scatterlist/skcipher_walk overhead:

                      Gbit/s, AES-GCM
                      crypto_aead   direct
   1 stream, 1000 B      21.34      22.86   +7.1%
   1 stream, 1500 B      29.73      31.67   +6.5%
   1 stream, 2500 B      40.78      43.13   +5.8%
   4 streams, 1500 B     28.79      30.48   +5.9%

With RX prefetching in
the NIC driver the receiver gets cheaper and the gain grows to +10.8%
(41.23 -> 45.70 Gbit/s, 1 stream). On the sending side (single packets
and UDP GSO segments) the direct path saves ~40-100 cycles per packet;
throughput there is set by the receiver.

Since the commit adding GCM to the library says the arch-optimized code
will be migrated into it, do you already have work in progress for x86?

If not, we'd be happy to help there, or to test yours on Zen 5 with ovpn
as a user.

One design question I have though: the VAES code needs the hash key
powers H^16..H^1 (and H^8..H^1 for VAES-AVX2 / AES-NI), while the x86
ghash_key only holds the PCLMUL state.

Would you rather extend struct ghash_key on x86, or have an
arch-specific part in struct aes_gcm_key that aes_gcm_preparekey()
fills when the arch code is usable?

Thanks a lot!

-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

