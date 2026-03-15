Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA5435F610
	for <linux-crypto@vger.kernel.org>; Sun, 15 Mar 2026 14:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773586656; cv=none; b=tK9ZBAB8E7t87gMkTVAiQIQVhbAzKGOuPT0LLZDracseGxZbm80YZPjRBLmLmCwdGEnnqQuJr1f3uXVwOoVwBTFdYkfTta3TUuHYbQa5HOjoRzxqeQtwNoM0T3lpj/kqx8AfENwxCtd7EUVU5PLpqwESC+GAau1U9aFsLci4UPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773586656; c=relaxed/simple;
	bh=bdzgUYp9Hfk5Jhb55dw+Ajj+qPfsDMuNmgtx+Zl5MR8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UEQ3x5booMOxk8JG6VqAD6kr5nPeuARmU3Pn1ngAQWOz/I5OF+842YvaoMdfIZ7/zycxxlNIll6Lg/Jy678dUHNnJIL6eLpaY1dFC47oF+PVOszEd/+caChpFoifwoDJhTLFVUYjoxseG3BOfVtGkowFbmJKvtsHL+cFU9mehmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z0CbEB5e; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z0CbEB5e"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43a03cb1df9so3643654f8f.1
        for <linux-crypto@vger.kernel.org>; Sun, 15 Mar 2026 07:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773586653; x=1774191453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ctMsamV79lnDxH1eZ0yPc5TbWrVVMUxp8VuhiBWLzMA=;
        b=Z0CbEB5eIytM5T8sRDOHZzuRT9JztpbGP4iRh4HICIRnUNYOeiAxjjf8PFd2VCIG+W
         tv3mOX6gD37vpC/V0i5ftpETZIbmwfp6EYN4W0d0Vda+RmVIq2Eawe1MzPOiWm2LP+l5
         tIk2fUGWWtf6jk/dWLO4ONItdg4o65g5FDZpNFoQ7eVnvKppf8NK4now4fYISiVate0h
         WlBXw6PSEL0qL4Wvm6e1MBCh6eGHV5jmIV0g+Hf77Q4OJkcBtYOob9gF1a9soLjuOuOv
         xLHZzT1ACM/LgpeFUYI8JZDvZtOyWEzRtSLfSrtQoFFJ33evEuI//LketYATncSGL5Z1
         Q9Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773586653; x=1774191453;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ctMsamV79lnDxH1eZ0yPc5TbWrVVMUxp8VuhiBWLzMA=;
        b=ZOFnnSq/vjFTitRCb76f62UI2o7OgO9yLiN8HYglIIWbxhI8R5OZMtenKOZTjf8r4p
         dzku6s8ESps1WAYoEsA1LBxJY6QutiY3nxshvEs+CPF6AvZXc14Ll9YWa0K7N4H7vgQv
         nr/JEQFaKygU77gKZStStncQCYq5Ap36sLGpZ6Mt23GY33BpA12G4mCZq0a3PeXqrSP0
         s5vDC1rMtMJpOeSAxgJVhKaL81iCwcgIL7dRFf7yuPhT8HCWYvbiL6LB+52+TsfzCaEf
         umMKI8axtaN0GDWQSYbdaLTttm+I6z02dco5WLVRJDyo6IQWjrthw2UmbleamMldkOY6
         ddkQ==
X-Gm-Message-State: AOJu0Yycd2rgXTEVLAok37Wn6a/mpkuvZG0qIBDmS3mdAnpOJjtNAzO7
	oBVayfxE/vuYArasM6bVS8RfGUi7SGYrftDe9VR5UD3mQozxkgJ8pvqO
X-Gm-Gg: ATEYQzwzZ2zuUWUeuwPxUqyAjfAqhxeRdle59BjymovyarhM0MD/JD9d50LqIkWx7NF
	npNp2p/Vv4ygMG3WyfPJFhDf0iKlMzC91RhQNPzbPh9nXIA4OCIGBsr6WbJDczvyEZ12mmTpL1E
	5LB2A+mRZCD6DD6vF/+GpIlOtPq8a4395iUjcdJHAr/J0zTI780BFOcVQXPDuz1xz4lDQj/vuvD
	yPLJVnAd6G9WqzrRvvL+i6Vx4ioVWQrK75HKHAu1NcmGZCojPksc5zgNCvAqb4tPtLjOcve8GZE
	zcw/+Cjs26xX9VYzWodfyRXH1C9S6CS229bOJi6tumD1US/VZl9h7VhkZlxKjiwOqC5VUcyYj+Z
	Um/V/FTZTD2VLd8YESodfpMDNGX307vBhafpA/LYgof19ly+8nbgoFOISdRYzhbSc346N3wqVD3
	bPoEXxnNw1X9jpy+xgBu2S7Dtiu8lOPKqa0+z48IRdnozyHVpFulbji96XzEuvLLkLPYonaWQ41
	RBWs6HIbHDbfRfXWiFlVeK3WzfZ4A==
X-Received: by 2002:a5d:5e01:0:b0:439:befa:91cb with SMTP id ffacd0b85a97d-43a04dc0958mr17059954f8f.45.1773586653358;
        Sun, 15 Mar 2026 07:57:33 -0700 (PDT)
Received: from DESKTOP-TILNSD1.localdomain ([139.47.104.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe1a72cdsm36221172f8f.9.2026.03.15.07.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 07:57:32 -0700 (PDT)
From: Kit Dallege <xaum.io@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kit Dallege <xaum.io@gmail.com>
Subject: [PATCH 1/5] crypto: add missing kernel-doc for anonymous union members
Date: Sun, 15 Mar 2026 15:57:22 +0100
Message-ID: <20260315145722.24081-1-xaum.io@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document the anonymous SKCIPHER_ALG_COMMON and COMP_ALG_COMMON struct
members in skcipher_alg, scomp_alg, and acomp_alg, following the
existing pattern used by HASH_ALG_COMMON in shash_alg.

This fixes the following kernel-doc warnings:

  include/crypto/skcipher.h:166: struct member 'SKCIPHER_ALG_COMMON' not described in 'skcipher_alg'
  include/crypto/internal/scompress.h:39: struct member 'COMP_ALG_COMMON' not described in 'scomp_alg'
  include/crypto/internal/acompress.h:55: struct member 'COMP_ALG_COMMON' not described in 'acomp_alg'

Signed-off-by: Kit Dallege <xaum.io@gmail.com>
---
 include/crypto/internal/acompress.h | 1 +
 include/crypto/internal/scompress.h | 1 +
 include/crypto/skcipher.h           | 1 +
 3 files changed, 3 insertions(+)

diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 9a3f28baa804..9cd37df32dc4 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -42,6 +42,7 @@
  *
  * @base:	Common crypto API algorithm data structure
  * @calg:	Cmonn algorithm data structure shared with scomp
+ * @COMP_ALG_COMMON: see struct comp_alg_common
  */
 struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 6a2c5f2e90f9..13a0851a995b 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -22,6 +22,7 @@ struct crypto_scomp {
  * @decompress:	Function performs a de-compress operation
  * @streams:	Per-cpu memory for algorithm
  * @calg:	Cmonn algorithm data structure shared with acomp
+ * @COMP_ALG_COMMON: see struct comp_alg_common
  */
 struct scomp_alg {
 	int (*compress)(struct crypto_scomp *tfm, const u8 *src,
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 9e5853464345..4efe2ca8c4d1 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -145,6 +145,7 @@ struct skcipher_alg_common SKCIPHER_ALG_COMMON;
  * 	      considerably more efficient if it can operate on multiple chunks
  * 	      in parallel. Should be a multiple of chunksize.
  * @co: see struct skcipher_alg_common
+ * @SKCIPHER_ALG_COMMON: see struct skcipher_alg_common
  *
  * All fields except @ivsize are mandatory and must be filled.
  */
-- 
2.53.0

