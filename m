Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1614382377;
	Mon, 20 Apr 2026 06:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667020; cv=none; b=gDfKEy7nkD6Gi50RS9plTFC3BElFlfSwEHZGmFlmSRBBJL05euf4jZ8C1anV96DOleV/tCR5K9ntoLWu4itE++YFTkbEKkifVM7U1JL+77ERG05y143lm3V9v0M4PaqlRxSXDJKsJS5n98j7h/PefgZlWGPsbR4K6Tj276bzKys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667020; c=relaxed/simple;
	bh=DgjRJy3WrFHnXHJomMIkJwOT7NG0TlWT6zE8xZlCamw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zt3Eujla6TixHf5LbHxCeA1/kuYfoskzQ3KU6tAqBgIA+/PG3ooTuZfcDklCmc+uW7ga5yuZ7n90GaKP9/ytCi3UvVHZxS3hKLZCDbfqlV0THj2Yf3GCvZkzZul2s+tJqxZ5NG9abn4CvcmX+1PGTtzDSYyMEw+1151iui6ZySI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JNR/fOq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JNR/fOq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914C7C2BCB8;
	Mon, 20 Apr 2026 06:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667019;
	bh=DgjRJy3WrFHnXHJomMIkJwOT7NG0TlWT6zE8xZlCamw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNR/fOq10jCgAWiwjnPCIiL8+zaHscoC9UruJzuOnE7jHOTeLVgnDIquzPOidrhz2
	 abd/qxiPsu/67ZlBpbdaVlp8aVwt5otpzrIfZYSFuAjz70qg7HKlVYgpamx5CxjkvT
	 okT/SpHApwXXt/0cAfgOCYLkcwCmWk3lYvvm3DIHqAPN9sULbzgMfO0wjnRuBFucQd
	 G98rzc3Sy4E2Jg2xIirmlfqE0XPkVoP3oqGYEsA5bjw2/nHP6VLusjdp85OXf0k96b
	 qbrngpbAGXEUJaRBsD3LKWgWFk4szVYwpKOZTAnCwqLMfRMyEaxivz3SkRKDKi0Okn
	 kYgXFrM0FIMAQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 02/38] crypto: drbg - Fix misaligned writes in CTR_DRBG and HASH_DRBG
Date: Sun, 19 Apr 2026 23:33:46 -0700
Message-ID: <20260420063422.324906-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420063422.324906-1-ebiggers@kernel.org>
References: <20260420063422.324906-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

drbg_cpu_to_be32() is being used to do a plain write to a byte array,
which doesn't have any alignment guarantee.  This can cause a misaligned
write.  Replace it with the correct function, put_unaligned_be32().

Fixes: 72f3e00dd67e ("crypto: drbg - replace int2byte with cpu_to_be")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/df_sp80090a.c           |  7 ++++---
 crypto/drbg.c                  |  3 ++-
 include/crypto/internal/drbg.h | 18 ------------------
 3 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/crypto/df_sp80090a.c b/crypto/df_sp80090a.c
index b8134be6f7ad..f4bb7be016e8 100644
--- a/crypto/df_sp80090a.c
+++ b/crypto/df_sp80090a.c
@@ -8,10 +8,11 @@
 
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/unaligned.h>
 #include <crypto/aes.h>
 #include <crypto/df_sp80090a.h>
 #include <crypto/internal/drbg.h>
 
 static void drbg_kcapi_sym(struct aes_enckey *aeskey, unsigned char *outval,
@@ -139,14 +140,14 @@ int crypto_drbg_ctr_df(struct aes_enckey *aeskey,
 		return -EINVAL;
 
 	/* 10.4.2 step 2 -- calculate the entire length of all input data */
 	list_for_each_entry(seed, seedlist, list)
 		inputlen += seed->len;
-	drbg_cpu_to_be32(inputlen, &L_N[0]);
+	put_unaligned_be32(inputlen, &L_N[0]);
 
 	/* 10.4.2 step 3 */
-	drbg_cpu_to_be32(bytes_to_return, &L_N[4]);
+	put_unaligned_be32(bytes_to_return, &L_N[4]);
 
 	/* 10.4.2 step 5: length is L_N, input_string, one byte, padding */
 	padlen = (inputlen + sizeof(L_N) + 1) % (blocklen_bytes);
 	/* wrap the padlen appropriately */
 	if (padlen)
@@ -173,11 +174,11 @@ int crypto_drbg_ctr_df(struct aes_enckey *aeskey,
 		/*
 		 * 10.4.2 step 9.1 - the padding is implicit as the buffer
 		 * holds zeros after allocation -- even the increment of i
 		 * is irrelevant as the increment remains within length of i
 		 */
-		drbg_cpu_to_be32(i, iv);
+		put_unaligned_be32(i, iv);
 		/* 10.4.2 step 9.2 -- BCC and concatenation with temp */
 		drbg_ctr_bcc(aeskey, temp + templen, K, &bcc_list,
 			     blocklen_bytes, keylen);
 		/* 10.4.2 step 9.3 */
 		i++;
diff --git a/crypto/drbg.c b/crypto/drbg.c
index e4eb78ed222b..de4c69032155 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -101,10 +101,11 @@
 #include <crypto/df_sp80090a.h>
 #include <crypto/internal/cipher.h>
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
 #include <linux/string_choices.h>
+#include <linux/unaligned.h>
 
 /***************************************************************
  * Backend cipher definitions available to DRBG
  ***************************************************************/
 
@@ -599,11 +600,11 @@ static int drbg_hash_df(struct drbg_state *drbg,
 	unsigned char *tmp = drbg->scratchpad + drbg_statelen(drbg);
 	struct drbg_string data;
 
 	/* 10.4.1 step 3 */
 	input[0] = 1;
-	drbg_cpu_to_be32((outlen * 8), &input[1]);
+	put_unaligned_be32(outlen * 8, &input[1]);
 
 	/* 10.4.1 step 4.1 -- concatenation of data for input into hash */
 	drbg_string_fill(&data, input, 5);
 	list_add(&data.list, entropylist);
 
diff --git a/include/crypto/internal/drbg.h b/include/crypto/internal/drbg.h
index 371e52dcee6c..b4e5ef0be602 100644
--- a/include/crypto/internal/drbg.h
+++ b/include/crypto/internal/drbg.h
@@ -7,28 +7,10 @@
  */
 
 #ifndef _INTERNAL_DRBG_H
 #define _INTERNAL_DRBG_H
 
-/*
- * Convert an integer into a byte representation of this integer.
- * The byte representation is big-endian
- *
- * @val value to be converted
- * @buf buffer holding the converted integer -- caller must ensure that
- *      buffer size is at least 32 bit
- */
-static inline void drbg_cpu_to_be32(__u32 val, unsigned char *buf)
-{
-	struct s {
-		__be32 conv;
-	};
-	struct s *conversion = (struct s *)buf;
-
-	conversion->conv = cpu_to_be32(val);
-}
-
 /*
  * Concatenation Helper and string operation helper
  *
  * SP800-90A requires the concatenation of different data. To avoid copying
  * buffers around or allocate additional memory, the following data structure
-- 
2.53.0

