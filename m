Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF47415ECEF
	for <linux-crypto@vger.kernel.org>; Mon,  5 Aug 2024 17:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722880393; cv=none; b=bw9S14SxrjpIB75ZMc9qZizTKWxfx2/iGtrSmsAOdDejnjVWxV0IIIz4pIr1R7QwyBVPC4l60Fs4oRiehZ5kTBnZu79gCBbP8AHBl0wTD7a/9CfcIO2T5exz9neFyWdtmvc7PkFTlyEt7GUGr+sfBxHhFqmjpkIam0z1GWixdZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722880393; c=relaxed/simple;
	bh=37JxbYtgj0UGmkJjr7UoHvqcTRSFFhKr2Vl6ibBWKk4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mxAx/xk+LALr0zmTzqS/dToPJ1BJ3qHiaJLpzY/7GpMVa+j9pJ3GJ1ZIc+xDKKnZhyi8JulkpWbsBwTNO78Wocwl2s/ovbbhMumMf54pjaWpEFwpV5sMNQFNJt8Mi4Io0ZGAH74UjP5XWc8Gr3bXqkoQD1y+PxxiwD6Hgkh0zHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=f8pKmzbN; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="f8pKmzbN"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3683329f787so6102156f8f.1
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2024 10:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1722880389; x=1723485189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+vqwe0/CvqutnT3l9d7/bTn3dqeHNjAfCcV9ZLukVbM=;
        b=f8pKmzbN0/ZM/QxuwCBdH+N06OQKotZqtz8yH41AO62ttbRG371WCfw8SQPPlOPT3q
         USIyL6ZRuPWeO4y4T3RBB8nu/6fcWTJTNK4xlUa4wRCFyIHj/NmXScXQ1QGQuGX3O++x
         zgIazL2/Ej4+AO1p3QVNXVcLKhpAqaSF9ojHA5Q/Gnh5XCARExOS989fbpe85Z4HMyzX
         OO913yMCiRfBcOG/+S6Q5lfgmyBt1D0yDfabqPoM7wkE18C/d65G0p116I1aj9DMK4St
         cRswLk4C5hmawy6SIjNGWqbrde8Ex03wWJqr8mTrcBGlLJFyp7MawCnmtEgehtEgvj7m
         phjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722880389; x=1723485189;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+vqwe0/CvqutnT3l9d7/bTn3dqeHNjAfCcV9ZLukVbM=;
        b=B8ys6QnhOZBWHY5J6ditXjcNmoZElH+UO2VdckUmRO6avy0CrqXf2e+yaNMXse/XvM
         4hx3LvMHL2oktFYdUtIy5hAUEEArx8iXBtRGEC3MeVOi25S2S0AuRKvpjoB4xmXPUgig
         P/+Ivy4m1eCqpp419hf25JKkXilG/ANvhP2ro3iZ/INcoSJFHvOfWMGXY/QzIZ7vKgW0
         FLBSCDSr/DeGTx67qknGM0KpdLlNfKChe/o8hqu1KQEURLj+zcZ6Zxc+1DwBhHEXCdEw
         tiA7PMKp8+/aOtageGbu6yJP2Wa/sdiMJ1jpyJWb7vMUHzZjvBgpoFGmRPbwEjypij6z
         PnKA==
X-Gm-Message-State: AOJu0YwXAysYeH/saQ94n/Y3pV3IVW8HzD4CjDkLTFmh0jl6/pmPte0e
	LnUiZkforM5mi38Oiw7dSWNoX2Pnt5F0xSwhiSYzbzGqlr4zIMyNbqpGG7RT8x0/fkefZ5M9dpP
	j
X-Google-Smtp-Source: AGHT+IFsapBhb8f6mICFhltKqRUHmpBomLHqM0Xug77XUaSdZlzbbtSgJltdKCGcKWuJfAdIFBDA9g==
X-Received: by 2002:a5d:6083:0:b0:367:340e:d6e6 with SMTP id ffacd0b85a97d-36bbc1bcadfmr7746862f8f.41.1722880388924;
        Mon, 05 Aug 2024 10:53:08 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-26.dynamic.mnet-online.de. [82.135.80.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36bbd06dfbfsm10593716f8f.99.2024.08.05.10.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Aug 2024 10:53:08 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	kees@kernel.org,
	gustavoars@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] crypto: chacha20poly1305 - Annotate struct chachapoly_ctx with __counted_by()
Date: Mon,  5 Aug 2024 19:52:38 +0200
Message-ID: <20240805175237.63098-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the __counted_by compiler attribute to the flexible array member
salt to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
CONFIG_FORTIFY_SOURCE.

Use struct_size_t() instead of manually calculating the struct's size.

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 crypto/chacha20poly1305.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 9e4651330852..b37f59a8280a 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -27,7 +27,7 @@ struct chachapoly_ctx {
 	struct crypto_ahash *poly;
 	/* key bytes we use for the ChaCha20 IV */
 	unsigned int saltlen;
-	u8 salt[];
+	u8 salt[] __counted_by(saltlen);
 };
 
 struct poly_req {
@@ -611,8 +611,8 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 				       poly->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = chacha->base.cra_alignmask;
-	inst->alg.base.cra_ctxsize = sizeof(struct chachapoly_ctx) +
-				     ctx->saltlen;
+	inst->alg.base.cra_ctxsize = struct_size_t(struct chachapoly_ctx, salt,
+						   ctx->saltlen);
 	inst->alg.ivsize = ivsize;
 	inst->alg.chunksize = chacha->chunksize;
 	inst->alg.maxauthsize = POLY1305_DIGEST_SIZE;
-- 
2.45.2

