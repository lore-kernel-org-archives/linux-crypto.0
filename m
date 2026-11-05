Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793871851;
	b=QnLyFj3Wmr1W8+w+y7PpkmwC4TZBvLSMSna7gUPihtKLK0O8MLVeiDuVazNOFrOW6ehz
	 zBxgrfnqf3MckOg6afGY/jz5BJs0dUMvRfcoYSi6/0Qr5YkbBj7wnUmb5EwYwAX+fNc/E
	 7mPbDIBb9vauxtQTiVYv2JqH/H31UXiG/dwD3Qy1G13c2sT0PyhrSCt2xBYryxBBXJWYj
	 1zdyM5IqhVhY0PjjXwQcFV6gWq354ofkwlJAG0TShhTOj2r/9mtzUcV5Z9RD2CMaaUvZ/
	 +ExsVuPCJTvVOGQyoxb0EemNUvgbC8URH5gvuWj31UcX3iAVdeaFzzdzhDVhkXdmMqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793871851;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=pGy1Kh+GkweoDW55tkkLScaIrLrXynqE2s5jUf609Pk=;
	b=Ow67x51klalYwp501I+9Llk43wpHcoLtzBKdlR5ccJykbG7XCWLD0gdQRIg226iu8eiL
	 J59B9jmU+8WfDE6f01hpqE5osEIZFRmHL/EbtxZXmNWtGZfPMwlZI0Y1zxCN28QJHj444
	 FzoytNT7kh2c8BOgIsNRb93EqNNfWipKZ/meOVu5D983y+ZUNGrdlhT1bpw4uVcO9Pofk
	 tbccVrUnbaRq0Au70LXavJOXnJ136sLzyc41qAZz1RXof9SrQ5PV78GiN+GRnpGWBaMGm
	 TQR61R+hRff2rauXXJI5h4MNFMWSWDNBGIDmNmuf8nDzfmIp3k17shVpaxu4qP9T83Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=MWSnoExm;
	arc=none smtp.remote-ip=195.10.208.42
Received: from mout-b-112.mailbox.org (mout-b-112.mailbox.org [195.10.208.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E65606A336
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 09:44:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76E65606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=MWSnoExm
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-112.mailbox.org (Postfix) with ESMTPS id 4jKy7V3Hdrz5wpH;
	Thu, 05 Nov 2026 10:44:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1793871846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pGy1Kh+GkweoDW55tkkLScaIrLrXynqE2s5jUf609Pk=;
	b=MWSnoExmCwmc4FKPbOlBqx5mq0hsvXr72bQDWl5kxpS9BMPLqjw1ucRWShAoikwQiHYekf
	A1cdCyjwyqnBPhcThBSCVG3YGUQ7iHKpeWiPraOg9U9xwliDVEqwJMbFBkMgOyeqGi1KMv
	3NaN2E36a8vERFJCYFbQ/f5pe0uzwFuYDPPlsTN8isirqbRo5XRpmVh5QwFWa0JTJepI2c
	tydNBohBEuwWg6awqAi2rmG8xN5cEaTtLUj1xL+6AdOJndoUsLeVZQIjksgnkcgXsfFq5n
	tlMI5PcMnuN9YLOAuI69amgiUtUdGW5iYlgW7fRCfOXPDEy4yw7JGA8GNHc4qw==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <46792443-8de7-4b4b-a5d1-015516eb1c5e@mandelbit.com>
Date: Thu, 5 Nov 2026 10:44:05 +0100
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
Subject: Re: [PATCH] lib/crypto: x86/chacha: Avoid overly-narrow keystream
 XORs
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld"
 <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Martin Willi <martin@strongswan.org>
References: <20261104065703.247316-1-ebiggers@kernel.org>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261104065703.247316-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jKy7V3Hdrz5wpH

Tested on Zen 5 (Ryzen 9 9950X) in a KVM guest, on top of the bzhi,
vzeroupper and interleaving patches. KUnit chacha suite + benchmark
(64..16384 B, 3 runs each), compared with the tree without this patch:

   path                 CPU setup              KUnit  perf
   -------------------  ---------------------  -----  ------------
   AVX-512, zmm         native                 pass   -1.8..+2.8%
   AVX-512VL, ymm only  spoofed SKX (6/0x55)   pass   -0.2..+1.1%
   AVX2                 clearcpuid=avx512f     pass   -1.2..+0.6%

Small but consistent gains at 192..1420 B on the AVX-512 paths;
AVX2 is neutral.

Tested-by: Antonio Quartulli <antonio@mandelbit.com>


-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

