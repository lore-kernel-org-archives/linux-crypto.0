Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC022C15A3;
	Tue,  2 Sep 2025 13:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819378; cv=none; b=V8sdMzAEjyCmJpJJz0hjt/37QafSxPIJf9fPSZoKUdYdzXUnvb2Dp4Rst34Cow7RaJ2t57p4D1sFIA1sg1lkCV7iQw2G3kF/tO7/Xz1J1ZMRMqXzOkldJYgMdLX9LbC533jm6qZK+wCqLDjxlCylytTicsplOZKeFPKWtzmGsNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819378; c=relaxed/simple;
	bh=l898iI1BQTDI8cMdaHUOF7Zr2+U+5iB/kVmacVwl2cs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gvWrHl6dU53+F/8fqnIdULYLs8GDmns0uKwaxQxFnz9UR3H0w7PBEHZ/xksv3zgvQQUn4VJeESpD8sBWqaCp0ZQe2Ez4NgpfxmSJf5a8DPeZBUp/Tj6Ye93V1sLH3Heb5YgWKrdT66RSsKamlYVCAZoRyKhfMkL6loSHFuTjJ5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R+kD0QLE; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R+kD0QLE"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45b8b25296fso16216965e9.2;
        Tue, 02 Sep 2025 06:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756819375; x=1757424175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=edZLfiZt8B4p4uO3hUsASn2XOCnLkF3RAYMn9M9Bwpk=;
        b=R+kD0QLEoyU1r6H2K2rqlQbAQ6RuDvkUbK2AV6DadOQ336hrwyJttfxuF6psbAXyQY
         udAKjGY2UhC18nj9DNsJJafmQSfr/YbHT/kljiLXpZ+F7Qa73pQpOlxx80wzILzMTXcU
         vbzJUoB7QLsivnBpDdxmH48UPCtAWfyAtg6y5G6rHiPHj/efOUOhwIGnzEEDssZiiOvK
         aQpYxUeqwCi2McCQqvi4rVE+HP3RYUNTVLjltHUay60c/lUKKB/Ue7+Ds68KmEuKJgbN
         cMmS+dklImLvCRLaEebpfybzvBFuddTSmBSL1luKiiu4RPUqXSWVjq9GmZ18uO6u6Zjq
         /sWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756819375; x=1757424175;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=edZLfiZt8B4p4uO3hUsASn2XOCnLkF3RAYMn9M9Bwpk=;
        b=aMSphE0X027p85VRWAuCC/4XMzqjSYNlPGK3CaoKvjGW3EDrxWKFqQ0fHp1MahBcqN
         HSADNPA70g3I62xJSBkZMq9dIHzo3VDgVbW81ZcU0DDnc2z99wrmu/sMQ673klgukHq6
         UsPhNEAD35cB5GGEqW+QkY7IjglgctYdisu3+qHFkBrVmL4goLK4lhaGixtDQjPkn7Rq
         BOU/6QKtLtqCgUbwjAQGQUXB1OGLuG9skhZxiCo9ca/WycVDUmZW8D7w4SL9JdF8TIJt
         X8Db1NLmUtFPin7gA7pWKtbRNzvaP5DhEiqs2vRVZRX2FsX2ExnLQvuNa/Wr1W/48Lk1
         Z9kQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiCnEevoK27XSUVieAJbUBuNWV1yszbEpcup7PtRt9ZqnluZ6+VSszFMrNZpdiXC8lNOJqYLWsRW1crfc=@vger.kernel.org, AJvYcCXR3q/NX0hhTfthnmG7F3/z00e4jYqoPIyRNDQX03zRMbMleqUy3HB3vdd5lkOib23hjuScRGubmiAiG8bs@vger.kernel.org
X-Gm-Message-State: AOJu0YxGCkIcftU8qde0J5sIfNcOguJPmwKEN/t/vxlOEAZzhDzWzv7z
	0HtWK8MKC7rWgMhDr7HDbzeiHJoGvTaAHXC/6JZCRikXCAMEBIfnpedJ
X-Gm-Gg: ASbGnctkeI7e2NS6fopNsJBUHYi9J7jv0XawpwSLr4GVU0I51NXtHIZjbJ5lK5dsSCU
	HhIw+mJcqUky+TvfxWrEfSX3qihZUrIhFcmKpahL42F7tSFgiPciuR3eTGclwE4LhqKLBZuQGMn
	5Ryx7Mu5G037l0Yh7WhOJXr2P6eDEkHvvCDEcA31qx8pMikI97DS079mCrMF5JCSa1BpvjwsFL/
	TNR8kL90W1NIThJLWrzr5xZ8ozzKm2nnBjxpRgYK7NWaQN5s+h3YG8+Twoh4kMZZYFIwGY9paHG
	eWueo6V1YnhwQLBMCkrVhnwGnHnhh9iRDH9GxS4KG0Q7xB6N7rOD/l30fvct1/2PSE+ibYohXab
	QlxBaSWhifdEcgWboT54J0myAIXwGxrOQupfdqYfBxvbU
X-Google-Smtp-Source: AGHT+IH7LkldeuIVl0roiAT8alXAPPPGwsjQFZhyThmF6wIdY2fazyGKGh4QM5al/Tpt7/lQ+R0tnw==
X-Received: by 2002:a05:600c:4ecd:b0:45b:876b:bccd with SMTP id 5b1f17b1804b1-45b876bc00dmr86469705e9.6.1756819375070;
        Tue, 02 Sep 2025 06:22:55 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:c207:b600:978:f6fa:583e:b091])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b945332adsm44452155e9.4.2025.09.02.06.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 06:22:54 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: clabbe.montjoie@gmail.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Cc: wens@csie.org,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH v3 0/9] sun8i-ce: small cleanups/refactoring
Date: Tue,  2 Sep 2025 16:21:25 +0300
Message-ID: <20250902132134.3287515-1-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series includes only the refactoring commits from [1]. The batching
related changes were dropped since they are no longer relevant (batching
support in crypto_engine was retired in [2]).

This series includes various small cleanups and refactoring:
- move request-specific skcipher and hash data to request context,
  eliminating the need to allocate extra memory in the digest path
- make the hashing code more clear and modular
- reduce a bit of boilerplate/duplicated code

Changes in v3:
   - dropped ____cacheline_aligned attributes from buffers used for
     to-device DMA only
   - set up proper alignment for ahash reqctx, in order to allow from-device DMA
     into reqctx buffer:
      * increased ahash reqsize by CRYPTO_DMA_PADDING
      * added __aligned(CRYPTO_DMA_ALIGN) attribute for the 'result' buffer
      * converted all ahash_request_ctx_dma() calls to ahash_request_ctx_dma()

Changes in v2:
   - fixed [-Wunused-but-set-variable] warning reported by kernel test robot

[1] https://lore.kernel.org/linux-crypto/20250626095813.83963-1-ovidiu.panait.oss@gmail.com/
[2] c470ffa6f486 ("crypto: engine - remove request batching support")

Ovidiu Panait (9):
  crypto: sun8i-ce - remove channel timeout field
  crypto: sun8i-ce - remove boilerplate in sun8i_ce_hash_digest()
  crypto: sun8i-ce - remove unnecessary __maybe_unused annotations
  crypto: sun8i-ce - add a new function for dumping task descriptors
  crypto: sun8i-ce - move bounce_iv and backup_iv to request context
  crypto: sun8i-ce - fold sun8i_ce_cipher_run() into
    sun8i_ce_cipher_do_one()
  crypto: sun8i-ce - pass task descriptor to cipher prepare/unprepare
  crypto: sun8i-ce - save hash buffers and dma info to request context
  crytpo: sun8i-ce - factor out prepare/unprepare from
    sun8i_ce_hash_run()

 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      |  85 +++++-----
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  35 ++---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 145 ++++++++++--------
 .../crypto/allwinner/sun8i-ce/sun8i-ce-prng.c |   1 -
 .../crypto/allwinner/sun8i-ce/sun8i-ce-trng.c |   1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  27 +++-
 6 files changed, 147 insertions(+), 147 deletions(-)

-- 
2.50.0

