Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E113346FA6
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 08:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778834306; cv=none; b=jCz2AMes/aKIB0hQCp0gx6CxoAjOX/Zk3VqY3wG955tYcLqojSpAOUMy/W8texIsDg24X9izrp0/seFKocYcjekIR3sVstCt3Cqt1XrDyfa6x5IyXoeavXZr4aJVd/HKUibq+Pdurusv2aaxv5sQ1Xq/4buL50/VwaSOeSTkli0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778834306; c=relaxed/simple;
	bh=0IzjRu/LmNvFxlp574pApVZLtPdMRu9i+gW+erW1E7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNPHrcu0EYeq+LxDqeUV5px9A1fxFZMqWb59phZlDpNOsn9X+SVtPb9btheH0aWpH76j/VXv2YCNM05qucUy/CVJenZugSVou8tIzaeic3nCdXmp8qCWF1l+dnN8cVb+fIMzipxtGkxhugo2k4zbGC6FRZ+fy5UDuQoaj+sm2Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=eRL/ehQw; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="eRL/ehQw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Nf
	QIIhKGaOlwLugaIMJR6stpyhjVmgbTs+xUzMcggWk=; b=eRL/ehQwlTyJyhIP4q
	0JFJYbrVFRxoVQvgmvimqrkUqirPsyzrGIn2lAfhNJGlE68U6UfGz723dsSZ9Zb3
	HeVu1UPELSUgAeiXuSxP1flAyuX2IMlxqM6XkxTJpZWZi0S7FcGCZmQOQH3CLFnf
	IPsgdetWWf7kaqHwE26cbWv/0=
Received: from localhost.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDHlOFC2wZq4mXLDg--.24792S4;
	Fri, 15 May 2026 16:37:24 +0800 (CST)
From: scott_gzh@163.com
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	Scott GUO <scottzhguo@tencent.com>
Subject: [PATCH 2/2] authencesn: Refactor inplace-decryption with sglist shift helper
Date: Fri, 15 May 2026 16:36:45 +0800
Message-ID: <20260515083645.4024574-3-scott_gzh@163.com>
X-Mailer: git-send-email 2.41.3
In-Reply-To: <20260515083645.4024574-1-scott_gzh@163.com>
References: <20260515083645.4024574-1-scott_gzh@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgDHlOFC2wZq4mXLDg--.24792S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF45XF4fGryfGw4Utr45GFg_yoW5Cr17pr
	sxKFWagw4UJF4jgrs3Xw1rG39xGr40ya4fWF45CrWF9ryaqw1rtry2yr10qry5ZFWxCrsr
	tFs7Was8Ar43JFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jIksDUUUUU=
X-CM-SenderInfo: hvfr33hbj2xqqrwthudrp/xtbC7AUkwWoG20VBZgAA3Z

From: Scott GUO <scottzhguo@tencent.com>

By using shift helpers, we shift assoc data and crypt data in-place
, avoid writing the ICV tag part during decryption.

This patch also merge the code for in-place and non-in-place
decryption together once again.

Fixes: e02494114ebf ("crypto: authencesn - Do not place hiseq at end of dst for out-of-place decryption")
Signed-off-by: GUO Zihua <scottzhguo@tencent.com>
---
 crypto/authencesn.c | 38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 522df41365d8..a81003a69a18 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -210,18 +210,14 @@ static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
 	u8 *ihash = ohash + crypto_ahash_digestsize(auth);
-	u32 tmp[2];
+	u32 tmp;
 
 	if (!authsize)
 		goto decrypt;
 
-	if (src == dst) {
-		/* Move high-order bits of sequence number back. */
-		scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
-		scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
-		scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
-	} else
-		memcpy_sglist(dst, src, assoclen);
+	memcpy_from_sglist(&tmp, dst, assoclen + cryptlen - 4, 4);
+	sglist_shift_right(dst, 8, 4, assoclen + cryptlen - 8);
+	memcpy_to_sglist(dst, 4, &tmp, 4);
 
 	if (crypto_memneq(ihash, ohash, authsize))
 		return -EBADMSG;
@@ -264,7 +260,7 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 	u8 *ihash = ohash + crypto_ahash_digestsize(auth);
 	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
-	u32 tmp[2];
+	u32 tmp;
 	int err;
 
 	if (assoclen < 8)
@@ -274,24 +270,14 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 		goto tail;
 
 	cryptlen -= authsize;
-	scatterwalk_map_and_copy(ihash, req->src, assoclen + cryptlen,
-				 authsize, 0);
+	memcpy_from_sglist(ihash, req->src, assoclen + cryptlen, authsize);
 
-	/* Move high-order bits of sequence number to the end. */
-	scatterwalk_map_and_copy(tmp, src, 0, 8, 0);
-	if (src == dst) {
-		scatterwalk_map_and_copy(tmp, dst, 4, 4, 1);
-		scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 1);
-		dst = scatterwalk_ffwd(areq_ctx->dst, dst, 4);
-	} else {
-		scatterwalk_map_and_copy(tmp, dst, 0, 4, 1);
-		scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen - 4, 4, 1);
-
-		src = scatterwalk_ffwd(areq_ctx->src, src, 8);
-		dst = scatterwalk_ffwd(areq_ctx->dst, dst, 4);
-		memcpy_sglist(dst, src, assoclen + cryptlen - 8);
-		dst = req->dst;
-	}
+	memcpy_from_sglist(&tmp, src, 4, 4);
+	if (src != dst)
+		memcpy_sglist(dst, src, assoclen + cryptlen);
+
+	sglist_shift_left(dst, 4, 8, assoclen + cryptlen - 8);
+	memcpy_to_sglist(dst, assoclen + cryptlen - 4, &tmp, 4);
 
 	ahash_request_set_tfm(ahreq, auth);
 	ahash_request_set_crypt(ahreq, dst, ohash, assoclen + cryptlen);
-- 
2.41.3

