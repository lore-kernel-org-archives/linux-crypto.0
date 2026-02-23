Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B61D221FB1
	for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 13:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771854849; cv=none; b=ntnIY2PrdhIMZqAn/j5OyqZbc1X7Ju1R9ArZO81hnQAmPvRMkYHxrJTHx32a2tKoTLJrIS8+LGxZmcoSY8ySJpF6AjvCJX6g8QSSUbwAkMyU9CUjO1z7I7t/Pqhl5jVs/NdDpOsT0GJuRLOy2BEOO1YAiseLWHJ072idAQqXSG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771854849; c=relaxed/simple;
	bh=nMNKM2hbPd4zqSQopRJMeuwy8HqeQaJMUGkJjXpyxJc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O4usPTKsgK9gBMeW64uBNUHOKK9rpKATvhQX1VidiHUvnW9SSGAXOLxGIg3qzkctRiJ1sLbMTz8pE3pKMPKTmzvy/gBVpSuv22dfkFZeLK4UNCSJ6q36/RGlh9g1eZ5WbYhDSBd4HeFwu3Bc0v8knw4+3UccIMc2v9CeMCOpWF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G7RouRdH; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G7RouRdH"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-824af5e5c81so4117291b3a.0
        for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 05:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771854848; x=1772459648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EOtit9nPhhTYStdVZEsCqrHrK6HVIjzNEiHiK3t7y2U=;
        b=G7RouRdH7jSejRv0rHGdO6Hz8PZAOjPebZ3kUJWmQRDpQ5YjJJTVTPf0N9fuQx1pmi
         S7YfR86bd2bILvxFRD/YJESlqZZ3ujkCra/lCQkCZWw+X9bTQJVEXYo0s9EpPe8IgP4y
         +q0GSzgqsoJLLPuLGJF8qsNQyRUWeCLMsn1Z7oLIuKmjw8482teOeui2zr8CL7464+uL
         ApfDu779ZPPIEt4qFdDyzfEb42Wwo2ooL9iZ/j4bwk8WAkkzw7YoctO82G8DFDd0CCkM
         BbzI722n7ATeM5wFOJny9A0uNPmR9SVaDGhziswdCRpB85BfSWb2a5Vmg1ardgP5+tdj
         qjdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771854848; x=1772459648;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EOtit9nPhhTYStdVZEsCqrHrK6HVIjzNEiHiK3t7y2U=;
        b=J3Ryi+wAe/gAM/sVUkQajlQTsMEWqEzkYiU5pf9ahF0wgCnxtPyR1IjaEZtA3kg763
         ZXzKUPOdDYfq5ykbEv/6hBqWh2g+17Y771BrQbR+9ozwOP1Uu73zEXBI3Y9tOp0GYC3a
         YiS4TgS43eqcVwcSG3erWie/XVNWjvyxrmViuQksBr9VJHQemzz2MgOl3RggJ/1UVsIs
         XhU4byINmqRJz/8KijmnjrZGjSomKO2bu77SveI94m/XdVOfIwRieqAzOwJ3UOV7XMNg
         Xo01Txu3alMjFWUOP44JIiV8td7g/ajHY5uyb9EaqW5mR/jDzpmmbq1gNK/v3ehyBz3+
         ngcA==
X-Gm-Message-State: AOJu0YyZXuSSIO6gH8H2119PteuIkRiMd4I+22gWqYcDjl3Z1cdJYIAW
	OZV8ZpZjKxF5ZKPNt4taQHN7+aQ7Wd1FERYhkpt6CAF12T4UF2vMliPbUzTzQ+pw89bmdQ==
X-Gm-Gg: AZuq6aInXMJSm4JSfI4k8GU+CTOwJ+bmricKHOPCOyidfhtODaRaW2zPiPWAoFd8cqj
	VRHLr5Ngo+pEwbq7RH/wttV0FJ051YRJ9+KPQPOYDHqqeszbD+arVhCeYE2i4xTwpfc02IWbsfJ
	NL6KQgnkdFyV0HMyn8eQ4Vjofttbqzl9C030FjNGpq+z57Eh1Y8mZ9P6XtjD+pHwrT4P7qrZ5Bq
	IpEm+bsWOKiavUWPdXNiBMPIHcjwpvh1X3QwfEuDlpSUrPp+PO4Dk8cIL1vlLxsNGHyCESdCwIo
	bvx3c/MoNYG9dGjoUiv2EVt07tSlM5RYG5W2PMTg0a+zIB2GQy7+74VjwKNeNFE3UPNpSzqNH1q
	tE19z+Z1QW7OFIGxOwGxjoaH/QyVr5hDfPXNl/gExxjCXphcQWJMrAvtdrCm2U+UDBF+iLcN3w1
	fXrrzi4aFfeNltr5FR7HW4r8HiYoI=
X-Received: by 2002:a05:6a00:3407:b0:823:998:95b0 with SMTP id d2e1a72fcca58-826da9ee868mr8366804b3a.35.1771854847801;
        Mon, 23 Feb 2026 05:54:07 -0800 (PST)
Received: from archlinux ([2408:8340:a622:6ad0:e841:fcfd:4323:9565])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd8bf9besm9470190b3a.55.2026.02.23.05.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 05:54:07 -0800 (PST)
From: Sun Chaobo <suncoding913@gmail.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	Sun Chaobo <suncoding913@gmail.com>
Subject: [PATCH v2] crypto: fix spelling errors in comments
Date: Mon, 23 Feb 2026 21:53:39 +0800
Message-ID: <20260223135339.38631-1-suncoding913@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix several spelling mistakes in comments across the following files:

- crypto/tea.c: Correct "alogrithms" to "algorithms"
- crypto/lrw.c: Correct "mutliple" to "multiple"
- crypto/drbg.c: Correct "additonal" to "additional"

No functional change.

Signed-off-by: Sun Chaobo <suncoding913@gmail.com>
---
 crypto/drbg.c | 2 +-
 crypto/lrw.c  | 2 +-
 crypto/tea.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 1ed209e5d..9204e6edb 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1780,7 +1780,7 @@ static inline int __init drbg_healthcheck_sanity(void)
 	max_addtllen = drbg_max_addtl(drbg);
 	max_request_bytes = drbg_max_request_bytes(drbg);
 	drbg_string_fill(&addtl, buf, max_addtllen + 1);
-	/* overflow addtllen with additonal info string */
+	/* overflow addtllen with additional info string */
 	len = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
 	BUG_ON(0 < len);
 	/* overflow max_bits */
diff --git a/crypto/lrw.c b/crypto/lrw.c
index dd403b800..aa31ab03a 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -134,7 +134,7 @@ static int lrw_next_index(u32 *counter)
 /*
  * We compute the tweak masks twice (both before and after the ECB encryption or
  * decryption) to avoid having to allocate a temporary buffer and/or make
- * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
+ * multiple calls to the 'ecb(..)' instance, which usually would be slower than
  * just doing the lrw_next_index() calls again.
  */
 static int lrw_xor_tweak(struct skcipher_request *req, bool second_pass)
diff --git a/crypto/tea.c b/crypto/tea.c
index cb05140e3..7c66efcb5 100644
--- a/crypto/tea.c
+++ b/crypto/tea.c
@@ -2,7 +2,7 @@
 /* 
  * Cryptographic API.
  *
- * TEA, XTEA, and XETA crypto alogrithms
+ * TEA, XTEA, and XETA crypto algorithms
  *
  * The TEA and Xtended TEA algorithms were developed by David Wheeler 
  * and Roger Needham at the Computer Laboratory of Cambridge University.
-- 
2.53.0

Changes since v1:
- Fixed multiple typos in the commit message description.
  1. Corrected the spelling of the target word "algorithms" (added missing 's').
  2. Fixed a typo in the quoted original error string (the original code had 
     "alogrithms", but I accidentally mistyped it again in the v1 log).
  Both are now accurately represented.
- The actual code diff remains unchanged from v1; the source code fixes 
  were already correct in v1.
- No functional changes.
