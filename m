Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8428815AC5
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 12:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YerqpYop"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-33768a5f55cso3117734f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 04:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704976408; x=1705581208; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TzgsTumrVcxIBPU7QnQ9Rqml590Mt0QTqnlJ397suzE=;
        b=YerqpYopwKGskaN0YwyuMmX0E7zcwonlpb+Pdtsk+1I6cPq1y7Z+wbXXLefvl7v0aK
         V6yp/WuZuxpIt+uh1YqOgX6Ood0fqGurab/253IrSFEm7joesBTP3OYQdyHy8GRL6rrD
         WkfgR/f06r0HZIy20DjKWa8QrbUUvjpn2Dgq+gBZxjWMRdMupEWXJKmJT55qKd2mZ5Ss
         p92RLd5q10qywP1wyyigC4a18EZ02OiKvWmuqpnQsqqX9aWQ3Mvd1WDCJ0FPSDS5jN9p
         oNFH8h+Nr7slwq23Elp3Syl9Osp4KQGMVPUwuxf6y1SZJN2WjR+jZucDnoyQH/Uwchle
         hREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704976408; x=1705581208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TzgsTumrVcxIBPU7QnQ9Rqml590Mt0QTqnlJ397suzE=;
        b=GKB1UlIgAU7ms2JYKAo3Z3rqZNpogTj9aDUy46spHAXM1oMYV2KpVvOxKgxlqVUNBy
         DvJdb+i9UgZIZLcZsvgOYcdJp/sqwc3/7xQSVu/I/DN5dzQVxJQHXiJV9h3pmPl4IRQa
         QmSUffaRX7H5bg29GbVgXQUIGZqIaczCrREit8BhB4j3p5K9X2Uh9oYxshK6eWDJ6p7N
         MVbVAADsO1mKPUOzd6HZOa2k/2QD4JoOsLSy9AEKS2LeBXlytkRpzdvLrf9n6AzmGHcf
         FjvtSoeBG/s7ga0w004RR46nIIP8gOUUl1scm0bl9WjCdkRuDfNo8/pd1n0zlLaMDfKP
         mdtg==
X-Gm-Message-State: AOJu0Yx8Q72WF25hkygxvWdlZKrKbPnyLsgWP8FNZ+vwHdcNlbUbWtLH
	DQUO33zEgG6E5gUTeGl3LeCqUVp/feH20ip8iIqCO/f6LWpszJkY5HXERikZMwudbomntjDBsje
	nCAlKvp1xeOd0IiBZ5h8S6Ng0t+kEMxM241DNJfPXx4dadqQVjR56weijsLjQQJviHFd9CXk=
X-Google-Smtp-Source: AGHT+IFVtIwgAB8S5lsgRb9QdquxXYtzMM+/kerKZ5QqW8PLlk2JjmKbZgY27RaJgJsSvnIYCkuy+8L9
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:600c:3581:b0:40e:46bc:f757 with SMTP id
 p1-20020a05600c358100b0040e46bcf757mr9227wmq.3.1704976407436; Thu, 11 Jan
 2024 04:33:27 -0800 (PST)
Date: Thu, 11 Jan 2024 13:33:05 +0100
In-Reply-To: <20240111123302.589910-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111123302.589910-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1868; i=ardb@kernel.org;
 h=from:subject; bh=cy89LZAGVQoSF1sLZhWsnNc4qSFNESYSS670zbbSREU=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXX+AwYHxgnO/6omWK6ddmCu7NUbiw/cLJ6qt0FWedpcj
 eY0h7hbHaUsDGIcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAiM48zMjQ/mqte9YWDIeRt
 9H6t43/+LmWI+zMxLvSWYmo0r+psBVuGv5I5E87ruzTJ/PL3SA38b8u1ttw+uPi0IU/+a9UsydX JzAA=
X-Mailer: git-send-email 2.43.0.275.g3460e3d667-goog
Message-ID: <20240111123302.589910-12-ardb+git@google.com>
Subject: [PATCH 2/8] crypto: arm64/aes-ccm - Keep NEON enabled during skcipher walk
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Now that kernel mode NEON no longer disables preemption, we no longer
have to take care to disable and re-enable use of the NEON when calling
into the skcipher walk API. So just keep it enabled until done.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 22 +++++++++-----------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index c4f14415f5f0..b177ebea7d09 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -182,17 +182,16 @@ static int ccm_encrypt(struct aead_request *req)
 		if (walk.nbytes == walk.total)
 			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
 
-		kernel_neon_end();
-
 		if (walk.nbytes) {
 			err = skcipher_walk_done(&walk, tail);
-			if (unlikely(err))
-				return err;
-			if (unlikely(walk.nbytes))
-				kernel_neon_begin();
 		}
 	} while (walk.nbytes);
 
+	kernel_neon_end();
+
+	if (unlikely(err))
+		return err;
+
 	/* copy authtag to end of dst */
 	scatterwalk_map_and_copy(mac, req->dst, req->assoclen + req->cryptlen,
 				 crypto_aead_authsize(aead), 1);
@@ -240,17 +239,16 @@ static int ccm_decrypt(struct aead_request *req)
 		if (walk.nbytes == walk.total)
 			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
 
-		kernel_neon_end();
-
 		if (walk.nbytes) {
 			err = skcipher_walk_done(&walk, tail);
-			if (unlikely(err))
-				return err;
-			if (unlikely(walk.nbytes))
-				kernel_neon_begin();
 		}
 	} while (walk.nbytes);
 
+	kernel_neon_end();
+
+	if (unlikely(err))
+		return err;
+
 	/* compare calculated auth tag with the stored one */
 	scatterwalk_map_and_copy(buf, req->src,
 				 req->assoclen + req->cryptlen - authsize,
-- 
2.43.0.275.g3460e3d667-goog

