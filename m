Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A77248879;
	Mon,  7 Apr 2025 12:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744029441; cv=none; b=S2NrzNKUPZyqEJ0Ej/3MgtOU5Q5ZACw8drKneIs3Yhlavf+1Zgg3kqTROB3AChXsBvccN0Ix6FKWAVSgxMoudExaVi+EVeDS7wk5PBX101qvdajcpYRqpxX/OpOuQ9fRMBY2xgjLR8gGxHBl/65mF1ujhmHeqsStpeAk1WBERf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744029441; c=relaxed/simple;
	bh=HOibTiVBe6urW/I8l/bkB3d+bGhjt3ehDkrMVTY5jTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GrK7URVDHUWI5e2Te5IQhT7N5Iu4vX+H5/z6zQ10RVmkOS4KPfvTx19CHedWnepnn5bKX2XPHl5FN74ZOBK4JMQSZe7KLug6VcsFz2gnVgUvhc9cRm/oI3rS1pZd/ZqKGFa1HD7+9grXwE+PmMKPyb7JJdjrg9YyaII7pOAxXtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bFbE6NgE; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bFbE6NgE"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-39ac8e7688aso3202037f8f.2;
        Mon, 07 Apr 2025 05:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744029437; x=1744634237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lh/I3yXpOsBj/QaJBup8gnrC62Y5DCOS4SYvr7caIAA=;
        b=bFbE6NgEjJ29ZUze30WNurTKDjAwAAhPunxQGlgRXVzefqVJ5Rh126Kyl9zCsF8pJr
         udbkcJz3HauzvyRv4RSGxueEN+eAzYKj2XDioD/E2EyCI4cyJKINiLeMc4PNf7LfRZSX
         /iV6oH7qFzK7NAAtJVE/NEoMxrdwTlQLh/b6+Z6CHYuSYjKcOp71pmPXyCOJxDYNblb4
         mHbYGd8wjGr3o9DIpjPlsUijqL9zNsk6uaGCLOb+eGeHrSMl0pYxYYRzIT3IwFQa8F24
         F0zVxYd5U6WmEdJlrTn3ziaMZUOEXm5IxJUsmVW4h41Sub4OpqBcZY8Y888e08MsTmQP
         EmFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744029437; x=1744634237;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lh/I3yXpOsBj/QaJBup8gnrC62Y5DCOS4SYvr7caIAA=;
        b=rpblIYqCZOBOj0WPV6OPF3Xc9cYjWHwfqMR5LOQ6pj1jYTsKpl0dO8sTO2v7sglGZv
         TlOdBqqd4Bi4xvUxHZ1QgLw3djWAfTyNMCh4LWdZSxgGto6QOItWsby8UGpOPM60qq+7
         KpmjU7n4cu4Kq/KfxHd0QU76wcksZ0jFwXauOw8sPhi8lldCI2UAjzL1/43rkhvVs87a
         ixS/SO1F32sKMALYWM9lr5b/9SOG3H6gf7w6xg7MrUteaPg9Cw2BWfX9wvJSimbHtPrj
         BrekyZ69y4vPfDpPkMrpluMPmHRMdqmOcL4dt4fwmbv/qjftf4+1JHe6wudnNJ8pZnSR
         04UQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaTz+iYjasCC7MPUTmPMMKW/mFTgobh1nQIplUoAfba3phGULVowFX2Jx8Y2V11OE1o3pJvdsQrFtV+ao=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7o41NqeZUPHVz0pWygh6jtr5PqdaYCmKO7xkxS4UUWMXrfo5H
	NWOTZftSBBxR2/4x0eTdVEHXUsucuTiViwIaRqrew/C3MpZS0DgG6wQ7QQ==
X-Gm-Gg: ASbGncvEp/kyUOJ5i3qpuP8fzGhwPZhyvwVxHgKHcivJrvC8mh5CATitaefTEwuDbQn
	dmJW+opExsu9/9tYoCc/xk3+bIsiuAWwL0VhOXaguF68MurUei9IwfzoO3qTRoX+aDlfZ8Bc7db
	Q8aLV72xo1MGzbmW8wzr0YHZvo/a5fofOpL6VcNqybYJxZiPKESeB0xTpjFtYaMB308mhJ9OqVY
	ANIVM4eaMvQfeX6I1jcopmEP5xxG7DH6Lm18DKrmYEfH3xOY7muLfCRZQyXIxMxLeFGIlZL836h
	qS5hMAmBRfJK9xKlKSJ049gsf+y+b+O/DtoZI5IvucZ6tf5DIiTVbb3FLSE0OrMfet1YqXi4
X-Google-Smtp-Source: AGHT+IGHpxPIDtpchXInrsm1R02zHSRqOeOW0Uyj1nK5Y5FXV8oqwFqAV3X3meNPTj66oB5UmyG3Hg==
X-Received: by 2002:a05:6000:4212:b0:39c:1efb:ec8e with SMTP id ffacd0b85a97d-39d6fc00a75mr6536810f8f.6.1744029436707;
        Mon, 07 Apr 2025 05:37:16 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301b76f2sm12065198f8f.53.2025.04.07.05.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 05:37:16 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 1/4] crypto: img-hash - use API helpers to setup fallback request
Date: Mon,  7 Apr 2025 15:36:01 +0300
Message-ID: <20250407123604.2109561-1-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than setting up the fallback request by hand, use
ahash_request_set_callback() and ahash_request_set_crypt() API helpers
to properly setup the new request.

This also ensures that the completion callback is properly passed down
to the fallback algorithm, which avoids a crash with async fallbacks.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 drivers/crypto/img-hash.c | 41 ++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 1dc2378aa88b..e050f5ff5efb 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -491,8 +491,9 @@ static int img_hash_init(struct ahash_request *req)
 	struct img_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-	rctx->fallback_req.base.flags =	req->base.flags
-		& CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   req->base.complete, req->base.data);
 
 	return crypto_ahash_init(&rctx->fallback_req);
 }
@@ -555,10 +556,10 @@ static int img_hash_update(struct ahash_request *req)
 	struct img_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-	rctx->fallback_req.base.flags = req->base.flags
-		& CRYPTO_TFM_REQ_MAY_SLEEP;
-	rctx->fallback_req.nbytes = req->nbytes;
-	rctx->fallback_req.src = req->src;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   req->base.complete, req->base.data);
+	ahash_request_set_crypt(&rctx->fallback_req, req->src, NULL, req->nbytes);
 
 	return crypto_ahash_update(&rctx->fallback_req);
 }
@@ -570,9 +571,10 @@ static int img_hash_final(struct ahash_request *req)
 	struct img_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-	rctx->fallback_req.base.flags = req->base.flags
-		& CRYPTO_TFM_REQ_MAY_SLEEP;
-	rctx->fallback_req.result = req->result;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   req->base.complete, req->base.data);
+	ahash_request_set_crypt(&rctx->fallback_req, NULL, req->result, 0);
 
 	return crypto_ahash_final(&rctx->fallback_req);
 }
@@ -584,11 +586,12 @@ static int img_hash_finup(struct ahash_request *req)
 	struct img_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-	rctx->fallback_req.base.flags = req->base.flags
-		& CRYPTO_TFM_REQ_MAY_SLEEP;
-	rctx->fallback_req.nbytes = req->nbytes;
-	rctx->fallback_req.src = req->src;
-	rctx->fallback_req.result = req->result;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   req->base.complete, req->base.data);
+	ahash_request_set_crypt(&rctx->fallback_req, req->src, req->result,
+				req->nbytes);
+
 
 	return crypto_ahash_finup(&rctx->fallback_req);
 }
@@ -600,8 +603,9 @@ static int img_hash_import(struct ahash_request *req, const void *in)
 	struct img_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-	rctx->fallback_req.base.flags = req->base.flags
-		& CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   req->base.complete, req->base.data);
 
 	return crypto_ahash_import(&rctx->fallback_req, in);
 }
@@ -613,8 +617,9 @@ static int img_hash_export(struct ahash_request *req, void *out)
 	struct img_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-	rctx->fallback_req.base.flags = req->base.flags
-		& CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   req->base.complete, req->base.data);
 
 	return crypto_ahash_export(&rctx->fallback_req, out);
 }
-- 
2.48.1

