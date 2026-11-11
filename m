Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794421903;
	b=ix5mOG51VPmR7LNRxiAXVLO9VYvvS7O6u6h+R0ZGtbKzsDnPOn7J2PPiFSDocznoYN4i
	 fKOMcEkcUNgSgC5pLC+ljstehnmN1qH6+G04eQahjsIm+PO0gM/nEN1FHb08Fbey1Dm3j
	 XNol+6lqAQDkyhzNskuPb2G5P/VVj08xShNc18NSp+xqGp/jq7cqbMkRvDTvf5T0aChDN
	 qUtPolbjtOuh29lDR32x02RGFRUWTVE1uv+hdT4EXGHB8/BH/3bydhlTaE6GOxqznJGis
	 Vl+km4PPjdXmAofjZRJ0GtdChGHi/8p+R0GtaG8t+8S8lVHEKhrSiBjqbiW1/T/2zdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794421903;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4AU6yrqWvCc/nyHqN3PU3r1GIThqckGTo09wAzMWOLA=;
	b=ectqffGPtraMpgYBuznK48VKXES0GAqbNmTdbVVdti+y7cKlxQAUYXNVwS8wm/SqY4ts
	 R1MKZxZfJX1DN5HIY8QDL2723kTPJ9ZPu11zU5KgQinY/3ZaJAy8G6QZP9hUIiT/fD6a6
	 5tKzPIRe9+sQG3XRz11eSxsRo2smHzQ3O7MEqoCEkE8hoEVBakMq0BqPh2JAFKJm7/uMy
	 DgVoi0g0WK0fdv0c0Mp020tgKcweSKqyARAuSclT7FLeTST2bAwbpQNNTq7QRIZEMgFLS
	 ppxwM1lK8gBcENiGQn7SgxVHDCeiPipNc5nmJVvZBdyHJW4FtlCQuVrNHxT7MDMLTsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=hAQTx9YA;
	arc=none smtp.remote-ip=185.125.188.122
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F68B606A31C
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 18:31:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F68B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=hAQTx9YA
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com [74.125.224.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id EA4863F288
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 18:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1794421893;
	bh=4AU6yrqWvCc/nyHqN3PU3r1GIThqckGTo09wAzMWOLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=hAQTx9YAaCki+ZEz3l+BuQFoV4KaH7ZYP8A8aNJNibzZXl8br1TloPw2oTzR85jCT
	 U0PZjcp4a6x2b34V57O8NYevQTiMDkBE3nb7mh5nZzQsX0q8IRu/ZZd4n/ft1TJ3/v
	 pzX6letQgq0Nw+P+mH7Zf8RWh2dv8i8GVbAtJcgZNCzWsq9TttK9RqTV539JspSacB
	 rnfD0U8YkIlepxcw5z1YSZ7Y8Nhf6Y7JmvPC8Bw53GjjOYH+FR/R66uKUYTL8H3Wdf
	 CQD7HrbHEEaHhhhTia4zxi9z61Ea6OLyi4GPwTIA1K61SdrJUSkC0xlOrDk6tBrJjj
	 0lWOcWQX4FzDvmjbCmPPS7NtZ5AD5NBKXySxGzElKA/teoMKsoJtpHP2jLyZxqEdx5
	 sgcXDI4tfwOkxauz6YlsxAlFaVNqYUzq3/S4FrQjO4smYvD+X/9r0XDClqvMQDqlI4
	 ZqtSZQjBDy16pOXvtfVhpRmqiZ8bIibKW4ZH92ppMubFt6XrMKuTWoVuyMBLqUrEtg
	 GtIQ82bDc5e+UECHOYQ02+zQg2+JW/NYUIj/vnn/bGpM+pflT+dzkPKvB5tqMKtAGr
	 Q6VwUTe0v5KwzMWA8tKRvGoNBYHPaoI5HZYN5siGrJNn2iGd/susLS089o8KASaMXG
	 EMYGU2/DkayH3STLYLiRJWfg=
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-67a6eb09b1eso4639353d50.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 10:31:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794421893; x=1795026693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4AU6yrqWvCc/nyHqN3PU3r1GIThqckGTo09wAzMWOLA=;
        b=rYgEhsfR5O3rZb4LY0fmvr+3hY5gnkAqwVtA7sedC6mAjyEPsbF9XpagzZWh0RqSZr
         G9bJmoF8qcRPtJfJ2SN3htjoV4lHTv02/o43daFCQWAwAK174TcWODcje82GzXA0Ed8K
         2Qyum+hXyduDj13vGMB3mIYRgUofy3LO72DKhUNyLgRWKEZypQGfg0wOdHW+DAYaySfO
         9MF917hO7vCA0/VuRa1FWx7nKHg6N8dYMuq880B1EdLwJMbo7Y0Af605OFo9IyCRTPCS
         NmPD+ch0ZJMp+WOI43I3ZYBtLpEcvxJAG50UmDbzCqIun8Aji+73VLVWfdWNxe8hVAJZ
         FVdQ==
X-Forwarded-Encrypted: i=1; AL+hErEOuGHN5NsZtIKIaBijadM3iF3UtL5it7bc+48ojl8dcrFLo3Ztmyrn26wYzNrlQEOM9duHw6AL+237R1Q=@vger.kernel.org
X-Gm-Message-State: APuU4Z/Ru6GZBKbkv813cUeJhl3l6L+trxGlrEN88MnGioj/63C0Uofb
	2VeL9FVKMNt84AY/KWvopqtqPfQmhVquoQydURMWcgZX+TaYguZYAhQzpdhAtm5AI7RA62AfVfZ
	YO948BezH5VFOwdMPxrf0HK0CQJwde3v186EdfiaQA8KgZNncFdLGcTGkTYWjTS/6RuLb8RscWR
	PS0RrIUg==
X-Gm-Gg: AYBFou26B8plB1Fo6gzxE2U4uz5CM+5w/FjMTImLJMr/3FhvI6mqhefL0UQcvU5+Ira
	f+6RHwJ+7E5WKc39PVOs6+ulYbHMfpQDzxs1SzjMy8yobTe2q8RyHBDMx2ND9ZQwenwVx32kOe4
	jFLEFtc/7tGOEFVVCNVFTuo5Op1+Lzhp+h2C+YPmja9d6ThijI0JS6b+ghc7hI73rMkURSh10aU
	JGwxEoqMG5LBEwCWAQ/TlFMDqkqrr44+15afTM7WVmykV4v+1vfz3vu8URg2Fv4Pl/8r0sK9URX
	XeKZp67gNqDJAKZck6NKdxbgC9UCqIck4Lji2/79ZGKchTE62l/zhGtjGkApQHqyuw5coMeh5DT
	FNzNuqWLYE6nnwdqh8zndClw95sPxjXMcpQUTEe6G3LE50n1uptfVEgyqBSE=
X-Received: by 2002:a17:903:f83:b0:2cc:6018:f030 with SMTP id d9443c01a7336-2edd76d1b91mr27420575ad.14.1794400871218;
        Wed, 11 Nov 2026 04:41:11 -0800 (PST)
X-Received: by 2002:a17:903:f83:b0:2cc:6018:f030 with SMTP id d9443c01a7336-2edd76d1b91mr27420345ad.14.1794400870858;
        Wed, 11 Nov 2026 04:41:10 -0800 (PST)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d4d79bsm20660295ad.16.2026.11.11.04.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 04:41:09 -0800 (PST)
From: Changwei Zou <changwei.zou@canonical.com>
To: herbert@gondor.apana.org.au
Cc: changwei.zou@canonical.com,
	davem@davemloft.net,
	gaurav.jain@nxp.com,
	horia.geanta@nxp.com,
	iuliana.prodan@nxp.com,
	jeffbarnes@linux.microsoft.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	martin.kepplinger-novakovic@ginzinger.com,
	pankaj.gupta@nxp.com,
	sahil.malhotra@nxp.com,
	sahil.malhotra@oss.nxp.com,
	stephane.debusne@cynove.com
Subject: Re: [PATCH v3 2/2] crypto: caam - Use bounce buffer for unaligned RSA destination buffers
Date: Wed, 11 Nov 2026 23:40:59 +1100
Message-ID: <20261111124059.789629-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <avRIYjWB6AUbeLUS@gondor.apana.org.au>
References: <avRIYjWB6AUbeLUS@gondor.apana.org.au>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Herbert,

Thanks a lot.
This is a valid finding, I'll fix it in v4.

> rsa_edesc_alloc() allocates req_ctx->bounce_buf with size
> ALIGN(req->dst_len, dma_get_cache_alignment()), but initializes the
> bounce scatterlist entry via sg_init_one(&req_ctx->dst,
> req_ctx->bounce_buf, req->dst_len) with the unaligned req->dst_len.

Correct. The bounce buffer is allocated with the aligned size, but the SG
is described with the possibly-unaligned req->dst_len.

So the fix is to describe the SG with the aligned allocation size:

	unsigned int bounce_len =
		ALIGN(req->dst_len, dma_get_cache_alignment());

	req_ctx->bounce_buf = kzalloc(bounce_len, flags);
	if (!req_ctx->bounce_buf)
		return ERR_PTR(-ENOMEM);
	sg_init_one(&req_ctx->dst, req_ctx->bounce_buf, bounce_len);

My own test case (loading signed kernel modules) used req->dst_len = 512
bytes, which is already cacheline-aligned, so this unaligned-length path
was not exercised and the issue was missed.

Kind regards,
Changwei
