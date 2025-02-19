Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2B421B1B5;
	Wed, 19 Feb 2025 18:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989471; cv=none; b=U25LTH5DjJnbGI2GJ9KR4NpJTbGg2UpYjnheSSKM5inriUHM46Hgqp8hVuOEuQzllhyBALTZlwS01PdQdcqdeRl0d2DbXNoixiB5WaSuWeFjzopIL1uQ0z5ALEzr8abrtVStPlUyyJX3zOtpp24A8ErhEAKQLhpvxR/lPwRI4BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989471; c=relaxed/simple;
	bh=cXUqK6gzrQ6Jb8f2XQHgstHPltOXwTTStbk2H1bPmow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xygc26FoTw8ZRlkCkKjGWW2cyu/KGdZtMqufiblvilP58y+068vsKhcOrXCf+arC5xDYgcipidgJjgwHMXDuGrcTx0t/75ZDGA0/79YYrF0ZBiDSKx4fu51whM4+EHmXuGzp+3pliIbOcwALEAMHCiDWkb/dFLIOzwjZ8N0NC1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kBs4SFo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBs4SFo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8FDC4CEE9;
	Wed, 19 Feb 2025 18:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989471;
	bh=cXUqK6gzrQ6Jb8f2XQHgstHPltOXwTTStbk2H1bPmow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBs4SFo1yJD+EOXqO74HzIV7aOWP8Zs4387sigrp++bBLIaVkEQxhnBDdW+6dEGh1
	 AlrcIasD9/EKoOd+GGwmKXWPq1yFkUkv/4/LjCpv8sGPBZSQ9BdBVncrONvEKO7Y4p
	 sga/5WKolx5qUc5EJUO/wYsK3nRygi4L9W8NPfUoIeQx/ryqCHRBMCgJGxBaQkv0MC
	 Umj1Q5PtHGD8INYDOVPMA6BZBzRFqSxy1abrg9k7WsPvv2uXqlr7YHRxWyeI4xByh4
	 7RfW1OxrI3s8FVHx48kjN+dnVt4kYd67egfiD2N0USjGVVYV5e/qe9zL+ahymajH0t
	 BYu9hHiyjDqWw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Boris Pismenny <borisp@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH v3 16/19] net/tls: use the new scatterwalk functions
Date: Wed, 19 Feb 2025 10:23:38 -0800
Message-ID: <20250219182341.43961-17-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219182341.43961-1-ebiggers@kernel.org>
References: <20250219182341.43961-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Replace calls to the deprecated function scatterwalk_copychunks() with
memcpy_from_scatterwalk(), memcpy_to_scatterwalk(), or
scatterwalk_skip() as appropriate.  The new functions generally behave
more as expected and eliminate the need to call scatterwalk_done() or
scatterwalk_pagedone().

However, the new functions intentionally do not advance to the next sg
entry right away, which would have broken chain_to_walk() which is
accessing the fields of struct scatter_walk directly.  To avoid this,
replace chain_to_walk() with scatterwalk_get_sglist() which supports the
needed functionality.

Cc: Boris Pismenny <borisp@nvidia.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 net/tls/tls_device_fallback.c | 31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index f9e3d3d90dcf5..03d508a45aaee 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -35,21 +35,10 @@
 #include <net/ip6_checksum.h>
 #include <linux/skbuff_ref.h>
 
 #include "tls.h"
 
-static void chain_to_walk(struct scatterlist *sg, struct scatter_walk *walk)
-{
-	struct scatterlist *src = walk->sg;
-	int diff = walk->offset - src->offset;
-
-	sg_set_page(sg, sg_page(src),
-		    src->length - diff, walk->offset);
-
-	scatterwalk_crypto_chain(sg, sg_next(src), 2);
-}
-
 static int tls_enc_record(struct aead_request *aead_req,
 			  struct crypto_aead *aead, char *aad,
 			  char *iv, __be64 rcd_sn,
 			  struct scatter_walk *in,
 			  struct scatter_walk *out, int *in_len,
@@ -67,20 +56,17 @@ static int tls_enc_record(struct aead_request *aead_req,
 	DEBUG_NET_WARN_ON_ONCE(!cipher_desc || !cipher_desc->offloadable);
 
 	buf_size = TLS_HEADER_SIZE + cipher_desc->iv;
 	len = min_t(int, *in_len, buf_size);
 
-	scatterwalk_copychunks(buf, in, len, 0);
-	scatterwalk_copychunks(buf, out, len, 1);
+	memcpy_from_scatterwalk(buf, in, len);
+	memcpy_to_scatterwalk(out, buf, len);
 
 	*in_len -= len;
 	if (!*in_len)
 		return 0;
 
-	scatterwalk_pagedone(in, 0, 1);
-	scatterwalk_pagedone(out, 1, 1);
-
 	len = buf[4] | (buf[3] << 8);
 	len -= cipher_desc->iv;
 
 	tls_make_aad(aad, len - cipher_desc->tag, (char *)&rcd_sn, buf[0], prot);
 
@@ -88,12 +74,12 @@ static int tls_enc_record(struct aead_request *aead_req,
 
 	sg_init_table(sg_in, ARRAY_SIZE(sg_in));
 	sg_init_table(sg_out, ARRAY_SIZE(sg_out));
 	sg_set_buf(sg_in, aad, TLS_AAD_SPACE_SIZE);
 	sg_set_buf(sg_out, aad, TLS_AAD_SPACE_SIZE);
-	chain_to_walk(sg_in + 1, in);
-	chain_to_walk(sg_out + 1, out);
+	scatterwalk_get_sglist(in, sg_in + 1);
+	scatterwalk_get_sglist(out, sg_out + 1);
 
 	*in_len -= len;
 	if (*in_len < 0) {
 		*in_len += cipher_desc->tag;
 		/* the input buffer doesn't contain the entire record.
@@ -108,14 +94,12 @@ static int tls_enc_record(struct aead_request *aead_req,
 
 		*in_len = 0;
 	}
 
 	if (*in_len) {
-		scatterwalk_copychunks(NULL, in, len, 2);
-		scatterwalk_pagedone(in, 0, 1);
-		scatterwalk_copychunks(NULL, out, len, 2);
-		scatterwalk_pagedone(out, 1, 1);
+		scatterwalk_skip(in, len);
+		scatterwalk_skip(out, len);
 	}
 
 	len -= cipher_desc->tag;
 	aead_request_set_crypt(aead_req, sg_in, sg_out, len, iv);
 
@@ -160,13 +144,10 @@ static int tls_enc_records(struct aead_request *aead_req,
 				    cpu_to_be64(rcd_sn), &in, &out, &len, prot);
 		rcd_sn++;
 
 	} while (rc == 0 && len);
 
-	scatterwalk_done(&in, 0, 0);
-	scatterwalk_done(&out, 1, 0);
-
 	return rc;
 }
 
 /* Can't use icsk->icsk_af_ops->send_check here because the ip addresses
  * might have been changed by NAT.
-- 
2.48.1

