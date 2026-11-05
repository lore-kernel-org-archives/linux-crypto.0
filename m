Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.40
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793871884;
	b=wtMA9QwT6OiZQ5tNPmltiDdcNRqa3licZtHbVHJkVVR52FmRVcd6Z7s8NR2a/JoqUF1z
	 XJpx3ApoLiu/ge8FxY3N3NgA5kdveiWmnDHfO9jSMDRzQqgoLWsqy1NJU1BtTyM1UmCOQ
	 dAyPsz2OIl33Pyp0gSuIq50wLy2OPDuN/qhiMQTu/GBRWB9lHwZefC+zq88fxVuMMP8Vi
	 APbLyuw3KxlWhnlw/6L4s9MLHVMboHRo/Ra738jqNx80aUN3rFP8hKFqLxFC4ohI1g7L3
	 4H+UP/9abJO6zxStgWocSqP92/EeaXuyP0QnvYgD8x/omf/q8z9i9sFj+BmhXtWrv2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793871884;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=N07bmy/zU3QtUfoZUJHS4AxyCcrWPsy8FNdquqzxLsY=;
	b=iIYV2Mu2cqp904hPVJ9s/i9afpe7NIVLWfi8U2X75N7/8QgIii3s9oaLWP/L1J/y+pEf
	 XWowTQGB2OdYdpeY5qMoGeiZNbv9ASIDo0FFQYaO8T2wstJWE/ZUsm1aLR7TCg12t3Sa1
	 xI3sHCjT+Lxdu0T7Bb9jL39sz8ToCZhbcKnHkzWSw04YwCyt7A65Af050TcoJwC1bz4P7
	 8f6CeqybdYkoAd2ANGgCne1tSlQE/LCHkhXzPnIuJsP9Kc48T3bukQ2kjRp917i/7xehk
	 EZ9uAgdp4dZIGWcxy4zpUmUbzYKceMCRbf2KyZlI4JwL+WAwmhorm7VdbJCmEctcrww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=rNnCcAPQ;
	arc=none smtp.remote-ip=195.10.208.40
Received: from mout-b-210.mailbox.org (mout-b-210.mailbox.org [195.10.208.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8BC606A31B
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 09:44:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB8BC606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=rNnCcAPQ
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-210.mailbox.org (Postfix) with ESMTPS id 4jKy816LP5zFqvs;
	Thu, 05 Nov 2026 10:44:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1793871873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N07bmy/zU3QtUfoZUJHS4AxyCcrWPsy8FNdquqzxLsY=;
	b=rNnCcAPQHNO3rKjJuo10pZml6/P91b0JLgZOm86eW99BTsMuic2BIbaXk3KEDdyPbjWKiw
	J+F5AWNHbZlJO2a0fBnEPRG6g2I1kOf/dNhqbdm/NyXQeMRbnsEWPejkAK4LmC4MtUJZ6g
	Zb5yoLXzIAOqFsPl/NYFdBfGLUHKM6f1/0mxNCyqTD0nGVM39DsanLXKlglola7B1qWkps
	3mKtRHwcU/GZ7mWPm9BDRvCvKvoIdoYYwDzWuSJFgGCel+qHbjCGM6Rz64Zvt4W/7KbMd+
	sjGocco9fYfoUfgPRi3tzpwBlNVrEEIBq/KGYbu1+iD4v64QJ206474VX+6QXw==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <ac222990-fe07-497a-aae9-5a0758c3625c@mandelbit.com>
Date: Thu, 5 Nov 2026 10:44:33 +0100
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
Subject: Re: [PATCH] lib/crypto: x86/chacha: Simplify chacha_dosimd()
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld"
 <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Martin Willi <martin@strongswan.org>
References: <20261104081604.302414-1-ebiggers@kernel.org>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261104081604.302414-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jKy816LP5zFqvs

Tested on Zen 5 (Ryzen 9 9950X) in a KVM guest, on top of the bzhi,
vzeroupper, interleaving and keystream-XOR patches. KUnit chacha
suite + benchmark (64..16384 B, 3 runs each), compared with the tree
without this patch:

   path                 CPU setup              KUnit  perf
   -------------------  ---------------------  -----  ------------
   AVX-512, zmm         native                 pass   -0.4..+0.6%
   AVX-512VL, ymm only  spoofed SKX (6/0x55)   pass   -0.3..+0.1%
   AVX2                 clearcpuid=avx512f     pass   -0.9..+1.3%
   SSSE3                clearcpuid=avx2        pass   -0.7..+0.3%

Generated assembly is unchanged.

Tested-by: Antonio Quartulli <antonio@mandelbit.com>


-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

