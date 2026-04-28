Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99E2224AF9
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 01:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777339491; cv=none; b=JLB1t0gJraQw4CzgUINU3NtcBraaoeeTOTrr6LPxD3DEAJd0UOXeiaAHx3URr9AQOUT6NTabD4AxEjXpSbiLd6vPNtAfXUISJtQHouQ00uuC+Huq4787GY6FZjBlJ0aIajT6frHREJj3tkBTxBhCqTxnBiKesAUqflHHyKtRauk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777339491; c=relaxed/simple;
	bh=Jrr5vozgfTInFQ8tY3V01o9YID5j5pE0ZSEW05djYFA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oHugmXfJORn79Xkn42wBrxJQGmr9rxF55vYNNrhe/VKP1TtZXdaASaHY9d2RHxL1+E7W5s357bnDC2qZRRs1zOVQOJp+cJ0QuNIYKM5viF1G57pm/TTRTajuYldOhCcpsU21zrftjqKzYTtEPs3yhqhPrynPaA/tBsWJAVsfsck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KUntDx0L; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KUntDx0L"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so133717425e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 18:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777339487; x=1777944287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=weDQ2uowpmJWEW0ohZ4PRY9xm0tEvW01Qf+utiRvTWI=;
        b=KUntDx0LWOSjDrwiK7AOLoztTzKWOKD6r1TTSiesmdBvp1V/UPWE5sKSLvZSZIhtXm
         APXyUwGshnbQWVyfoXn4EJrvvJqLsX8pVIkylkM6tUN0eh/NjR7RQNog9p47pHw8WCb8
         jkoD+L6CNzvXgMvSwSyHaF0hXlUWkgKRQMXea5oJDxYm6sSzw/ihV5nx97vIJ+HYrteR
         4GTcsfKC4LHHQRQpLxzU5avx5er+Wf/aL6GOvW1PJOECO6n5UDunQCx05KAmCAEjTmqf
         sV0CvhFuMYulueCgkPf2Kn8mEJzIlsEczbz2wXvAcNfv/TTQGuh1z+3E5oBr/n9so6Pa
         CM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777339487; x=1777944287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=weDQ2uowpmJWEW0ohZ4PRY9xm0tEvW01Qf+utiRvTWI=;
        b=aYXam92v1V9Okgw5CQQ/ml7ItejIJJGyvyTdsfyvkMh3F0hmL/rrz3KDM0bJB0DdR8
         XFRbZFDW9Y/Q2ZQk3wRkktH+JzAMki6O+p6e6fxR6fGkvqoiYMhfOb8s5zQBk7WBHmN/
         nyVI5Q2rSn9jc9ON1JUX/MlA6Bvavzh++9168LXWYGmNG20uQsEWxtifhToo5yXfW8DN
         Mcy2JNqjazMP/LhaXxJY95HntRkmSWThQaU9kyJGC2PSpQK4LHsrOSvKRyFTFoUnCO9B
         SlMcDuLHEcUPz1zIf2cCUHgN3vJGaXDk/yrJxAf+ntxIToEJumuxlqN/P3r/YElKSE7y
         1c/Q==
X-Forwarded-Encrypted: i=1; AFNElJ9trHocgjWMtTQjFtKw8lfLMIaKIy/pQA+4gBy6ddITLyk52EdT4TTGwNq5ohPIKyeT/6dBldUKWkmtLAc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtIDQ0dRpoUKQk04eLf12B/QE097s5w6ATNqPWndag58Q1ELLo
	6kl9hQ3s1fIYsHY2kmFWXjQKFKLHUu2pO9/rX6prhdpF6bGVgr3hJr9Y
X-Gm-Gg: AeBDiesI4AFytIfu8hIo8UzLpAKDM07LkHBNUXIP7bunYr1lb0xUYRlHJoKxuscepi0
	8iR8tGqLuxsHyAP/pGQIaRu/28NgIC+G8IO+wa0y2Ra1GOSVliuEA4R5BCimU9R2h0wnmsF2EdJ
	BA1TpfoeoIFYcLB6ZTHKcSMthGS++qtHEJdrBfQXrVPBwadalT+2P1AP6uYZ456bWMsMaU/OYry
	70esk3GaN9wnp36g8DDfMvIaNk3d6PCfDR/FmEyinmZtoS/ScL26shHIPCxib31KH44KH+Xkqty
	QlGAqw2GrSci+JLCINitlsopxY8qeeG8PODNijiLqbLDgXIWAm/uW4Bg8KBE3TQ7i/FsdNiCmYr
	eAI37Y9d8lqr2KptwLP6051/U4/+tiA238l+J+9oHpjAXBFB1TyCzHUT1UZ3ilysYPMbBRtZgAs
	sV/pnKeTLuXy1SZUaEe4xB4/2cWNNASGRMPJgOdu6IkcjuhhjB6C/46NXU8sub1K9w8Ly5i2eIn
	JlmHp5GQ0ZmUA==
X-Received: by 2002:a05:600c:5251:b0:488:81b1:ae36 with SMTP id 5b1f17b1804b1-48a77b19cf8mr13046995e9.23.1777339487108;
        Mon, 27 Apr 2026 18:24:47 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a774d9bd1sm10577525e9.3.2026.04.27.18.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 18:24:46 -0700 (PDT)
Date: Tue, 28 Apr 2026 02:24:45 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Neal
 Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 "David S . Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, "Jason A .
 Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [PATCH net-next v2 2/5] net/tcp-ao: Use crypto library API
 instead of crypto_ahash
Message-ID: <20260428022445.65e14a27@pumpkin>
In-Reply-To: <20260427172727.9310-3-ebiggers@kernel.org>
References: <20260427172727.9310-1-ebiggers@kernel.org>
	<20260427172727.9310-3-ebiggers@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 27 Apr 2026 10:27:24 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> Currently the kernel's TCP-AO implementation does the MAC and KDF
> computations using the crypto_ahash API.  This API is inefficient and
> difficult to use, and it has required extensive workarounds in the form
> of per-CPU preallocated objects (tcp_sigpool) to work at all.
> 
> Let's use lib/crypto/ instead.  This means switching to straightforward
> stack-allocated structures, virtually addressed buffers, and direct
> function calls.  It also means removing quite a bit of error handling.
> This makes TCP-AO quite a bit faster.
> 
> This also enables many additional cleanups, which later commits will
> handle: removing tcp-sigpool, removing support for crypto_tfm cloning,
> removing more error handling, and replacing more dynamically-allocated
> buffers with stack buffers based on the now-statically-known limits.
> 
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
...
> @@ -344,33 +444,26 @@ static int tcp_v4_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
>  	struct kdf_input_block {
>  		u8                      counter;
>  		u8                      label[6];
>  		struct tcp4_ao_context	ctx;
>  		__be16                  outlen;
> -	} __packed * tmp;

That looks a bit horrid.
I also had a feeling that the compiler sometimes rejects non-packed structures
inside packed ones.
Perhaps nest the whole thing inside another structure that has an initial
u8 pad and is marked __packed __aligned(4).
Then the assignments to the fields of 'ctx' will be known to be aligned
even when tcp4_ao_context is also __packed.

	David

> -	struct tcp_sigpool hp;
> -	int err;
> -
> -	err = tcp_sigpool_start(mkt->tcp_sigpool_id, &hp);
> -	if (err)
> -		return err;
> -
> -	tmp = hp.scratch;
> -	tmp->counter	= 1;
> -	memcpy(tmp->label, "TCP-AO", 6);
> -	tmp->ctx.saddr	= saddr;
> -	tmp->ctx.daddr	= daddr;
> -	tmp->ctx.sport	= sport;
> -	tmp->ctx.dport	= dport;
> -	tmp->ctx.sisn	= sisn;
> -	tmp->ctx.disn	= disn;
> -	tmp->outlen	= htons(tcp_ao_digest_size(mkt) * 8); /* in bits */
> -
> -	err = tcp_ao_calc_traffic_key(mkt, key, tmp, sizeof(*tmp), &hp);
> -	tcp_sigpool_end(&hp);
> -
> -	return err;
> +	} __packed input = {
> +		.counter = 1,
> +		.label = "TCP-AO",
> +		.ctx = {
> +			.saddr = saddr,
> +			.daddr = daddr,
> +			.sport = sport,
> +			.dport = dport,
> +			.sisn = sisn,
> +			.disn = disn,
> +		},
> +		.outlen = htons(tcp_ao_digest_size(mkt) * 8), /* in bits */
> +	};
> +
> +	tcp_ao_calc_traffic_key(mkt, key, &input, sizeof(input));
> +	return 0;
>  }
