Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793892709;
	b=VJiUOOoWf/bfij/s3uAmlUE/muocuZelNnpSxlR+sOwB6+1oCpBXu/ONKheRf2Mblekx
	 Ffgmsy9lSCW9igwCW8LubX7GOMrH3PIFQDBqNSVuKkQu9GmFocctpgznmujkj7nCjn14Q
	 +ibHawGbf1GLgARDZ2UE45wnjbOG6g7SagaY3CZqXaI3nx/K1eOgj/SPf4WkQGgd5t2vD
	 OsldGA7O4gquQlnr2hEoI1WGoYwiFBlxSqoiNZ29zGEXTgD9lVe4Kb2bWWchWZudan8ep
	 L5kq9slWBXoMnWVcAcQxN7o7dfzVPBaBXpN1190JLoqbBBGIWhIKX+Q6juwhnUjp6fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793892709;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=uV8u02Hsl+xRcTQ/feJ6iS8G6Os+Ncu80bsmmWWEnaA=;
	b=HI8kJK6PjJ6lKEKQCN7fC9YuNxkXjmOgwPuB+2RjQpxfXRxUEWkL5H0we4M7ehVISMJH
	 NrK81/cb22f3JTxAQ8drQdw8261pePxvBb6qnBjP8hyIx+ctl9svCRozPc59ZkzJ8ZViq
	 JwtW8m2kD/UgkfbxcieFkbhSxF0V34FoGkjAt2N7uZVByEFsz5u2jAfjktUFhf8Hfryq+
	 VQLygLUkwOU2uRE0XoFEjwBzVvotOxMm+shtrB0TjPN4tuQ4JylMwB60Ng/ecbKbIbFyo
	 DhFDt5lpvzUWgvPqw+xl2q/3yrh9mQij6o1UieDvD9ccl8UBAaY0rkMjcwWJSfuIdqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=0dIL1p6e;
	arc=none smtp.remote-ip=195.10.208.42
Received: from mout-b-112.mailbox.org (mout-b-112.mailbox.org [195.10.208.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F39606A31B
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 15:31:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39F39606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=0dIL1p6e
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-112.mailbox.org (Postfix) with ESMTPS id 4jL5rb0GCMz5vvQ;
	Thu, 05 Nov 2026 16:31:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1793892703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uV8u02Hsl+xRcTQ/feJ6iS8G6Os+Ncu80bsmmWWEnaA=;
	b=0dIL1p6ejLd4pq0bqrGol7140WxAVSQJMvSKK2JekjpXQQ1sFudTHYxiRJlCu+NA3db+Li
	+yZGEseLDhOngowawLhwI8QE228czYPAdOaeYj+WrHkLAKEGZaeF0oIndaHGBRpyDHccDO
	wuaNLaOnktDSHEPRNPP7t1wKX2j0woDHjYOlSrjNvqVShXpUoddAqI0Y8mZu6J2WiIJ75a
	+4oK53of7mwLzrzRCfyVzKYDxwKpAK89/mNvU8jam+xxThCo/gVEwTUIWoYJfJYij604OK
	+6/ywo0ZGGdGXfmwCFpFTmx3VGkxUw9bZEKNW08afqe0I1L5liZDlFpLuRfuLQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <3349b575-5f1d-4b81-be15-5f92565904e7@mandelbit.com>
Date: Thu, 5 Nov 2026 16:31:41 +0100
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
Subject: Re: [PATCH] lib/crypto: x86/chacha: Eliminate more never-taken
 branches
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld"
 <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Martin Willi <martin@strongswan.org>
References: <20261104225526.68557-1-ebiggers@kernel.org>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261104225526.68557-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jL5rb0GCMz5vvQ

Tested on Zen 5 (Ryzen 9 9950X) in a KVM guest, on top of base
9fbbbaefd5f9 + the 5 prerequisite patches. KUnit chacha suite +
benchmark (64..16384 B incl. 200/511/513, 3 runs each), compared
with the tree without this patch:

   path                 CPU setup              KUnit  perf
   -------------------  ---------------------  -----  ------------
   AVX-512, zmm         native                 pass   -1.0..-0.1%
   AVX-512VL, ymm only  spoofed SKX (6/0x55)   pass   -0.3..+1.1%
   AVX2                 clearcpuid=avx512f     pass   -0.6..+1.0%
   SSSE3                clearcpuid=avx2        pass   -0.4..+0.0%

There is a little loss in the zmm case. I presume we can live with that, 
but was worth mentioning.

Tested-by: Antonio Quartulli <antonio@mandelbit.com>

-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

