Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792616240;
	b=djFYSAuLgDiiTeiq/KkFEArBnAU7l4VB8oKyXNEWh9vgWMHMlHA98oa3KHbEX5MltYAg
	 g1G9XD8USziBUbsXvFch/ZvIpMNMxcpoLMZNcw0h2NrZAVZ2w7cVMkYpfLjJAsBsDpKLt
	 CKjdZdoBlwsgIAcMbg71FGqbu64zP8OmJOH4g7xnEpZK+Hap0/S7iYUPedGcXy1jEAEt0
	 dTvLqarbxbrCILwYjYNt+e7QSyUy6XxRPndMgxwhI2bSmnoqz29M7oSKq1L2O2dvLEHIt
	 meIJFHNvpNhWPZOzrZd2/KFctJAiHjxFEMaGQzzBAcom06VuCzWemXYzh3FbdbFGWMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792616240;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=svpaPlWQ3kiRUSxvrVjWiPIzFOlTHujdEaUrpizU6Tg=;
	b=e8Q22+KZKOvzwGmv8bQNaLzhH7NH/umIQNVbfmHnKpV9wZYl1ZWt57Q8uPN7BNl4s9jb
	 X61NpDcKzxLC+Z2JLeAWivpwk4PXd7vAGsYuYnT1i5BNku/gIIauu/ZqS7VCStdK4QUlX
	 wL2tAe08yIS4x3bHfJXAfUbfOESy9FmO6OZnQN6Tkna5YxxIgqhKFeLVOe4fdEpYexKLD
	 TGh+6Iu+3tzARKuCTh9X2Q1RN1/m9fXicGLGr4bggZfPtZQqgYTSdhBc9tcjJfKTdg5NT
	 JYCTt4D2u494GOQx+VfPX7llQS9kYdT+gQEfgae/D7UBEeZ+VodJvcozWP6i4Pif62w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--suseendranb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=oupeLWxK;
	arc=none smtp.remote-ip=209.85.210.198
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539B9606A319
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 20:57:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 539B9606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suseendranb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=oupeLWxK
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8a06750c74fso868578b3a.0
        for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 13:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792616240; x=1793221040; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=svpaPlWQ3kiRUSxvrVjWiPIzFOlTHujdEaUrpizU6Tg=;
        b=oupeLWxKbfd9DGxg5flKRdQ7c/+SDwRnTopgoQXLxB2Y6lZn+PrtYw/u4zlpDzHzM3
         K2IZIwu7K6Tjnz9FwwL5tVbMLBRfngIMBSyaZfAe5iEVMuYU4BvGPJ5TNTVcStQyWYWx
         NdW0Qa0WKti+R84vvVZycganZ8RP58B95uwtYL8o0T2oA1PWQ6fXW0BsiPXcTNhMidYj
         GTqI1/VDSew2ErnAj/JxW1ARZ6xTSqJoC9C3zZyiDhbBGTflbj+LEW7R1SIFnzAVxHgK
         FdrYeMxziZCnxLwdynkXrc5qZrMULXNHbOO4Lxbt7rSHWmkyykcRN1W1Jo3wXQFACQKD
         mftg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792616240; x=1793221040;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=svpaPlWQ3kiRUSxvrVjWiPIzFOlTHujdEaUrpizU6Tg=;
        b=Gig7BZ+KqLjvRE7IOOpnfp+z6oN53C3eCqJAwAPS+BCyRNiZxZt8ca/HT8Qm0E9Nei
         dC+m5jjLNch1WNXEJ3v3bI86LoMfbRKwnF0jHwfoFzI5SDybFszI9kS+2mB9gYcF6JNt
         jKNUY7EFFH0fesvJAezLRlH7F6o2WP8v90G7+myYPf4tcqe2DhS5HMkLfy5yFsorgO1k
         MChEg4snJVPl2FlR776Vp7h9UgKBoGL3kZDYSPMApM1boYbwHw4CuFz+HDMEkMfJOSFL
         Rm871bOvk29cT1n59jAl+1TYwo9yB2JZJ6Vprgw0jkmFCsLJowjUCdm52kQhdQOr1qqX
         AQkg==
X-Forwarded-Encrypted: i=1; AKwUvBwo5LgKIBbr2TmId0Fg4OhTr1Ocd3V99z3rOY8ewCeovREUmN4iyxSRhthI9nuusZq+gNzkf0zfSkdrwbY=@vger.kernel.org
X-Gm-Message-State: AFq9FYILPps/bmtTNDiDMufVb6NwO6fnZJ7qv5FnTgKqitlCIRatSiUD
	ypQ9mWaGBNfBhQoL/oS0xC33qsaFg7DR6FJqgVdRT6t+UL2gOiJRRfIeZEVYgN1l9AOOBTkghNo
	GQXg6xATziMc/SYQ/w9eD2hw/fw==
X-Received: from pffl12-n2.prod.google.com ([2002:a05:6a00:c34c:20b0:8a0:9000:c7a4])
 (user=suseendranb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2e93:b0:8a0:3ed7:93a2 with SMTP id d2e1a72fcca58-8a089f8b366mr2376676b3a.52.1792616239453;
 Wed, 21 Oct 2026 13:57:19 -0700 (PDT)
Date: Wed, 21 Oct 2026 20:56:25 +0000
In-Reply-To: <20261021205626.3286270-1-suseendranb@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261021205626.3286270-2-suseendranb@google.com>
Subject: [PATCH 1/2] crypto: return -ENOSPC on compression destination overflow
From: Suseendran Bhaskaran <suseendranb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Suseendran Bhaskaran <suseendranb@google.com>
Content-Type: text/plain; charset="UTF-8"

In the acomp/scomp compression interface, callers pass a bounded
destination buffer and rely on the return code to distinguish a
destination buffer overflow (incompressible input) from genuine
compressor failures (such as invalid parameters, uninitialized state, or
hardware errors).

While the multi-segment streaming path in zstd_compress(),
crypto/deflate.c, and lib/842/842_compress.c returns -ENOSPC when the
destination buffer runs out of space, the single-buffer path
zstd_compress_one() (taken when input and output are contiguous single
pages, such as in zswap) as well as lz4, lz4hc, lzo, and lzo-rle return
-EINVAL instead of -ENOSPC on destination buffer overflow.

For users such as zswap, which reduced its per-CPU compression buffer to
a single page in commit 0b1bf60c324a ("mm/zswap: reduce the size of the
compression buffer to a single page"), incompressible pages typically
overflow the PAGE_SIZE destination buffer due to compressor header/token
overhead. Because these compressors return -EINVAL rather than -ENOSPC,
zswap cannot distinguish a destination buffer overflow from a compressor
failure, causing broken debugfs error accounting (reject_compress_fail
vs. reject_compress_poor) or masking real compressor errors.

Update zstd_compress_one(), lz4, lz4hc, lzo, and lzo-rle to return
-ENOSPC when the compressed output overflows the destination buffer,
matching the streaming path in zstd_compress(), deflate, and 842.

Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
Signed-off-by: Suseendran Bhaskaran <suseendranb@google.com>
---
 crypto/lz4.c     | 2 +-
 crypto/lz4hc.c   | 2 +-
 crypto/lzo-rle.c | 2 +-
 crypto/lzo.c     | 2 +-
 crypto/zstd.c    | 5 ++++-
 5 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/crypto/lz4.c b/crypto/lz4.c
index 57b713516aef..c37e29afc831 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -35,7 +35,7 @@ static int __lz4_compress_crypto(const u8 *src, unsigned int slen,
 		slen, *dlen, ctx);
 
 	if (!out_len)
-		return -EINVAL;
+		return -ENOSPC;
 
 	*dlen = out_len;
 	return 0;
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index bb84f8a68cb5..3098466eb72a 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -33,7 +33,7 @@ static int __lz4hc_compress_crypto(const u8 *src, unsigned int slen,
 		*dlen, LZ4HC_DEFAULT_CLEVEL, ctx);
 
 	if (!out_len)
-		return -EINVAL;
+		return -ENOSPC;
 
 	*dlen = out_len;
 	return 0;
diff --git a/crypto/lzo-rle.c b/crypto/lzo-rle.c
index 794e7ec49536..483327873efd 100644
--- a/crypto/lzo-rle.c
+++ b/crypto/lzo-rle.c
@@ -34,7 +34,7 @@ static int __lzorle_compress(const u8 *src, unsigned int slen,
 	err = lzorle1x_1_compress_safe(src, slen, dst, &tmp_len, ctx);
 
 	if (err != LZO_E_OK)
-		return -EINVAL;
+		return err == LZO_E_OUTPUT_OVERRUN ? -ENOSPC : -EINVAL;
 
 	*dlen = tmp_len;
 	return 0;
diff --git a/crypto/lzo.c b/crypto/lzo.c
index d43242b24b4e..378b491b0cbd 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -34,7 +34,7 @@ static int __lzo_compress(const u8 *src, unsigned int slen,
 	err = lzo1x_1_compress_safe(src, slen, dst, &tmp_len, ctx);
 
 	if (err != LZO_E_OK)
-		return -EINVAL;
+		return err == LZO_E_OUTPUT_OVERRUN ? -ENOSPC : -EINVAL;
 
 	*dlen = tmp_len;
 	return 0;
diff --git a/crypto/zstd.c b/crypto/zstd.c
index 556f5d2bdd5f..7fafbdc19fd9 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -86,8 +86,11 @@ static int zstd_compress_one(struct acomp_req *req, struct zstd_ctx *ctx,
 
 	out_len = zstd_compress_cctx(ctx->cctx, dst, req->dlen, src, req->slen,
 				     &ctx->params);
-	if (zstd_is_error(out_len))
+	if (zstd_is_error(out_len)) {
+		if (zstd_get_error_code(out_len) == ZSTD_error_dstSize_tooSmall)
+			return -ENOSPC;
 		return -EINVAL;
+	}
 
 	*dlen = out_len;
 
-- 
2.56.0.218.g1ec904b173-goog

