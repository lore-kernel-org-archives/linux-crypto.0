Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0D13368AE
	for <linux-crypto@vger.kernel.org>; Fri, 31 Jul 2026 02:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465901; cv=none; b=BwYUbBL07oZguPDjWZuutsfdKl2BfY7yfg7X0VjMPU8GuY263FBec/+9CC3MehYSDcGXdGXP1jSUL6qq3v13bYk6aAoddbs7xb4xmyJBZNf+lGk+nAv8F7xslPBx5qm4N9ctuct4G46vNQN6IT0vZciBFCxiKTVtoTQtATKcQpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465901; c=relaxed/simple;
	bh=dZmsQ2jTqPiVr2JY2/gGuNbP07OGrR4qzw1nbZi22hI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KVcB4rgP6OTHZXPYYnAdYsTGpCrs481Sq8oTi2YkOdkVkFN5KE3ff4h8/NKb2ta8qAfV0lnxBVvw5akWU6ZlGDRMd37AmlJZKCTI5cwm11L3nPdFk5KrI7zJu1GXz5Vp4x2V7nGqh7uTACGcVh2iFlcLanWx9IpGTuU9L2C/VgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=MF8+fkGS; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="MF8+fkGS"
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 725543FBF4
	for <linux-crypto@vger.kernel.org>; Fri, 31 Jul 2026 02:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1785465896;
	bh=xR8Vjy4QAmUUp9y/woUbqCLhCK65cSgpGrMe3tuno94=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=MF8+fkGSQP/zgtCqTlEDX2PR1tn/O9P7YDK6f4A1h/m9nSDvIYE9oqdDJFXHyXrfU
	 d+C9/rCwHCBH/sW0yL6fOFMnXKQj77Wi1Po9z6XBuSUqow3QzQKnfHGXRS4QuDNUMa
	 u1qF0vazhyim171Q5qeQboUVH16E9NDBLLiH+2qgyS5Uiv32HuRjRUs9kofQ0rHXEx
	 EcY7dh+2Dy5shj5EnQqaFmFGdyxUvGrSXtSvkyArMgS20K8PIB4geHFe/iXZqEbccF
	 qoufygVr7KuEwwGapqvL1qe/pP7a1EprlFEJR4NjF1AYbyodR995tGlk4FNI3OskPF
	 K3tGnvRuSJNlrJyfSy2BrrFo570d2TZw0UqvBk6MVoQwH9bI0L6AgkELII7pNutQSs
	 jIY4/H/yaV2oREuzDgvjty/xt1ZMp9On2EBT1tGyLERRh0kRU015OSgymFHEjnFuwn
	 ge5EBneXkg4maK6m5aJVSKeay8/R6LjczYLOqZrhhX4HceupdOqml+9xseey2pkM2q
	 CTMvYZsSB0lv4w+Xon7UDyo2YoUXiOV55tsR2/PF0GB7TtxOe0bPIC3jtwzJcQ9MNl
	 eT93L3K9EKM2X+BkTFCiuMI6URD98301UyRVpJVc5p+xYnViLlTCcfAANiv2CMUk/p
	 abMlDwDTns4L0HnGwNr9DRTU=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-385d2703b64so1330421a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 19:44:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785465895; x=1786070695;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xR8Vjy4QAmUUp9y/woUbqCLhCK65cSgpGrMe3tuno94=;
        b=A/+BPGGA6JGRwLwrNRrM4rwet4RxRKRkzlPTdbZCy0wtzFF5r8PWLXnIwC1BOy8obA
         gm2BDGnAKcShXcS1EOcLM536eRgcwaUbuhh8RbSF4qSPhxgTbj0CLagxcwS9l01gBonj
         27oSI+9PDDbzhWMymsKEexjUBH8MeY7ZiUJApO1yM4Yl+W2AvOE/lQCOw0XDSP/AyPuK
         9bqykCVVYFGQMXNCD5W6Q/c3nXro5GrecMo0JFWENRMYUOjMU7vTbxxd+x1xkOTiLZL6
         xo/UMAbPNE6CVOP6iA8PhIWhl82sb0LQruJrosOMTmaShbdHgyx92h0ijxPW7KMvgUol
         7BcQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro0ovqCDNSAtywuxL4/uiyD9AJKHhj3njFIbp9jgkj+5c147apxwGUPX1SWCTQm6NpcmgvPm7/I1twVpYw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzR+ySiVote0I6qKrMLJZCrXSNqRox8vni6HmbneyGGt6m2qx55
	zkkQkGB2+kfBBvu9qfSIvkDnrfblfeqCjnzY61nOKkQZN7nXx+W4HZKH5WR4owHRbprLILM0wH4
	puyBUncCl9oKhPPLrK6QTaKSLfUiBt56TRANfBUa3CT2OOTex8uni0qHTtrlMtKxlkWOeCl1SD5
	db2RFSHA==
X-Gm-Gg: AR+sD12ePhCr1bUiy0Mmh+TxDB1cgHLpTiCsTh6APS7AszDyvZlKjUjFK7X7+GZlFGW
	5P9Qx3tYk+YKuLAhcPQ6pj1DjfU5EtbVCFlCXuh2kjX0sXVoCkbXy/sO7x1ae7Zmnar0XJwck9B
	2F4hr5muApNDTLb0KPuPIhGbAH7io8BA8iuch+G2/UmgAvQ58wSnJIJFrxVcaJaGYbApxiTRPcJ
	CVcGKDMV3FV4rKv5a1FjiWkMaSEY7azHnrwfBlzV3hAdodGo7kN7j+P5e3nTei86AHRUp+OpLCR
	1hUgWqzAjwUu5Jd7WPX+ya0wA1AaMPdEX7IR0cQXQ23m/5hjRZRvsECOsw3OadNPTU4jGee9NGk
	ILXM4yTlZPG8=
X-Received: by 2002:a17:90b:38c8:b0:38e:7e9b:5fbc with SMTP id 98e67ed59e1d1-38fb244e2bamr200338a91.7.1785465894637;
        Thu, 30 Jul 2026 19:44:54 -0700 (PDT)
X-Received: by 2002:a17:90b:38c8:b0:38e:7e9b:5fbc with SMTP id 98e67ed59e1d1-38fb244e2bamr200306a91.7.1785465894242;
        Thu, 30 Jul 2026 19:44:54 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153aedee81sm769560eec.26.2026.07.30.19.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 19:44:53 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: lukas@wunner.de
Cc: Martin.Kepplinger-Novakovic@ginzinger.com,
	changwei.zou@canonical.com,
	davem@davemloft.net,
	herbert@gondor.apana.org.au,
	ignat@linux.win,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	martink@posteo.de
Subject: [PATCH v5] crypto: rsassa-pkcs1 - Avoid cacheline sharing with underlying driver
Date: Fri, 31 Jul 2026 12:44:46 +1000
Message-ID: <20260731024446.786329-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

out_buf is used as a DMA buffer for the RSA verification operation.
If it is not aligned to CRYPTO_DMA_ALIGN, cacheline sharing
problems (data corruption) would occur on CPUs with DMA-incoherent caches,
leading to -EKEYREJECTED.

Rename out_buf to buf, as it serves as both the input and output buffer.
Add a buf_ptr pointer to track its position.

Allocate the buffer separately via kmalloc(), which guarantees cacheline
alignment on architectures without fully coherent DMA.
This acts as a defensive measure, and avoids the need for an extra copy
in the underlying driver, which should check alignment before supplying
buffers to the hardware.

The intermittent error 'Key was rejected by service' on i.MX8 with CAAM
can be triggered when loading signed kernel modules.

    for i in $(seq 1 100); do
        sudo modprobe xfs 2>&1 && echo "SUCCESS on attempt $i" \
        && sudo rmmod xfs || echo "FAILED on attempt $i"
    done

Signed-off-by: Changwei Zou <changwei.zou@canonical.com>
---
 crypto/rsassa-pkcs1.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
index 94fa5e9600e7..b1fb5111b6af 100644
--- a/crypto/rsassa-pkcs1.c
+++ b/crypto/rsassa-pkcs1.c
@@ -223,11 +223,12 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 	struct rsassa_pkcs1_ctx *ctx = crypto_sig_ctx(tfm);
 	unsigned int child_reqsize = crypto_akcipher_reqsize(ctx->child);
 	struct akcipher_request *child_req __free(kfree_sensitive) = NULL;
+	u8 *buf __free(kfree_sensitive) = NULL;
 	struct crypto_wait cwait;
 	struct scatterlist sg;
 	unsigned int dst_len;
 	unsigned int pos;
-	u8 *out_buf;
+	u8 *buf_ptr;
 	int err;
 
 	/* RFC 8017 sec 8.2.2 step 1 - length checking */
@@ -237,16 +238,16 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 		return -EINVAL;
 
 	/* RFC 8017 sec 8.2.2 step 2 - RSA verification */
-	child_req = kmalloc(sizeof(*child_req) + child_reqsize + ctx->key_size,
-			    GFP_KERNEL);
-	if (!child_req)
+	child_req = kmalloc(sizeof(*child_req) + child_reqsize, GFP_KERNEL);
+	buf = kmalloc(ctx->key_size, GFP_KERNEL);
+	if (!child_req || !buf)
 		return -ENOMEM;
 
-	out_buf = (u8 *)(child_req + 1) + child_reqsize;
-	memcpy(out_buf, src, slen);
+	buf_ptr = buf;
+	memcpy(buf_ptr, src, slen);
 
 	crypto_init_wait(&cwait);
-	sg_init_one(&sg, out_buf, slen);
+	sg_init_one(&sg, buf_ptr, slen);
 	akcipher_request_set_tfm(child_req, ctx->child);
 	akcipher_request_set_crypt(child_req, &sg, &sg, slen, slen);
 	akcipher_request_set_callback(child_req, CRYPTO_TFM_REQ_MAY_SLEEP,
@@ -263,35 +264,35 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 		return -EINVAL;
 
 	if (dst_len == ctx->key_size) {
-		if (out_buf[0] != 0x00)
+		if (buf_ptr[0] != 0x00)
 			/* Encrypted value had no leading 0 byte */
 			return -EINVAL;
 
 		dst_len--;
-		out_buf++;
+		buf_ptr++;
 	}
 
-	if (out_buf[0] != 0x01)
+	if (buf_ptr[0] != 0x01)
 		return -EBADMSG;
 
 	for (pos = 1; pos < dst_len; pos++)
-		if (out_buf[pos] != 0xff)
+		if (buf_ptr[pos] != 0xff)
 			break;
 
-	if (pos < 9 || pos == dst_len || out_buf[pos] != 0x00)
+	if (pos < 9 || pos == dst_len || buf_ptr[pos] != 0x00)
 		return -EBADMSG;
 	pos++;
 
 	if (hash_prefix->size > dst_len - pos)
 		return -EBADMSG;
-	if (crypto_memneq(out_buf + pos, hash_prefix->data, hash_prefix->size))
+	if (crypto_memneq(buf_ptr + pos, hash_prefix->data, hash_prefix->size))
 		return -EBADMSG;
 	pos += hash_prefix->size;
 
-	/* RFC 8017 sec 8.2.2 step 4 - comparison of digest with out_buf */
+	/* RFC 8017 sec 8.2.2 step 4 - comparison of digest with buf */
 	if (dlen != dst_len - pos)
 		return -EKEYREJECTED;
-	if (memcmp(digest, out_buf + pos, dlen) != 0)
+	if (memcmp(digest, buf_ptr + pos, dlen) != 0)
 		return -EKEYREJECTED;
 
 	return 0;
-- 
2.43.0

