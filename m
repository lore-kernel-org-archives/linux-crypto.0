Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33D51A83F8;
	Mon, 30 Dec 2024 00:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517768; cv=none; b=cY/xMXDTlnVJU2AGpcd+awAhp/rcgDFtm+6e7VWUPmIL1gaC/flj9W01RmQOVRLbsduj7YdG2puN6mQOn8syhGim6nx1gemKOIb8z/KPi6ZLWDjqVHDafJyIG7pGxVdUfw+bd/X463jqP0xNqzRovJuKw2xjjEXbtXhHDGRdOSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517768; c=relaxed/simple;
	bh=5aJ14qFdsp3EjNcjdgSBEGYXvCZe209dFMhq2DFCmN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtFo1lBM/sHfXfmsc9Gv+ZC1vSlhs22ZtFpDFwWHix41A49jjzMu13M413FVVbowxTe9oUZ30nOJ166QprapPN3syM72jLn2ezKeTeCxgTdMIOs1at+z9qp0wO00EtHEMQTiOiWYUyQnd94qhGbkF9UmLhI+DEJqMZSjCcHiBbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zrt3lNbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zrt3lNbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E78AC4CEE0;
	Mon, 30 Dec 2024 00:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517768;
	bh=5aJ14qFdsp3EjNcjdgSBEGYXvCZe209dFMhq2DFCmN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zrt3lNbnAS43581HvbVTvyRO4az38cnZlbFuRpBQrSK3GsYN4oF3p3E0VWeTa3Duo
	 Ll9IO0k0TUUpHi4tdE7bWdKGOZPBXxgiJ8snA8VnFtmbzWB46jZ1RGojGVpW4srM7W
	 LTdaS88R/xy77WlL7Gl9N+6jW3o3cx5xnDvm5bCV5GC3QgkRfO3qtk9hAOKgKuN/U9
	 eUKxW+W/ZLpFHtTlLCxNXTo1ZyPvuZD1WPM/rj5qiyDWX4GO7W07zTOYmitk5T6wDI
	 okvbOlw6X4VLjdj69i6K5OyVowqZb8R1gQFPxwUfDI+0eFCMux+vZLXw5k04KSYWiB
	 Yx5ecKor+UVnw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Boris Pismenny <borisp@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH v2 26/29] net/tls: use the new scatterwalk functions
Date: Sun, 29 Dec 2024 16:14:15 -0800
Message-ID: <20241230001418.74739-27-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230001418.74739-1-ebiggers@kernel.org>
References: <20241230001418.74739-1-ebiggers@kernel.org>
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

This patch is part of a long series touching many files, so I have
limited the Cc list on the full series.  If you want the full series and
did not receive it, please retrieve it from lore.kernel.org.

 net/tls/tls_device_fallback.c | 31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index f9e3d3d90dcf..03d508a45aae 100644
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
2.47.1

