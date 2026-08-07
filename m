Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CEA42902A
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 15:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117463; cv=none; b=CqbtqaEbKSAkW8O33/7IVGAuDTN8rz3UO4dIiW38IZA95OAyBpKn85HiG3T8yQxwDt4P752jenI17b4NigqOxml61HOdfHlwT9ZfxexD+QobF/6a7KcwLB6ZiZVblOuXXZaXVXqKN3ZtgAXjuy9X6gkllz0Am9XddBXYBn4m6RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117463; c=relaxed/simple;
	bh=eHBUeNYAmYQqgSbomhjGrUI+jo6b4xG9p+7Unl8lsOU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lzwKornONsrT1RWDZeMy6/+YQ02h5ClL7MAf06Yzx+qanAMR3TQVxtPkPwtgK1NyPRfdjpJglqkPH7Tqkc/2DhA3uCEhWDJd2qWvm9YM5hwZRBPK+3yp1kkB0mf4YpQySBXQB0qVYijLRQk2L8qmlm8kg19nbgy+xQftM5epxJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=fIKm/Pfx; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="fIKm/Pfx"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c169ae1cb26so400444466b.1
        for <linux-crypto@vger.kernel.org>; Fri, 07 Aug 2026 08:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1786117460; x=1786722260; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jex9FjJ6TrVlpD/29LwZtxw48/lgu4Xc7Jori9zIbiQ=;
        b=fIKm/PfxZRrzTkazf6B7BKdp/Jj0u14wrKBvA9/mZMS6Di2Ia15ntVo+xZPzT7Yr3y
         CuYluY1QcVkq22B7gK8lXSfT2+6Vr8E7rd/nRlnH7/BmwbGb7GlY/hKFrhTL6vDZTv1V
         rIMLtVrQ+7UfWvX18Jjit8OqvN9nXX0lzV5wiuEcRA/q/gdW60EHmvjcUqv8j5qaeaIR
         SXanCqIqE2T17OCTq0S6T/X6f2kBiEr97/6bIGk5/j7O+f5+dc62pDZhDco3NWILlmF+
         8Z9oobdxgIyPCun7ARl0EVwlgyeE/E/zGnHDIwcqewSF1baZ7zxXusunmhI9t3PJCsaz
         YgCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786117460; x=1786722260;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jex9FjJ6TrVlpD/29LwZtxw48/lgu4Xc7Jori9zIbiQ=;
        b=ZNteSAb4B3EIjalLvaLKixQNMIsGDB5FlVdQsxTaydfjMHQi9znRmZGF6YeC/H4Et4
         EOaj9EqBJSLKhmKfmCriqzPK6KOFYk2qRyz4ML//EvyCmTajsclN+zn+amOijYvUH+kX
         Yp0IdIqUAH5q0V/r4j0lJzhaOKnzNkGG67y/nBz5sTWZjgZaR/Ufh5RZL6IIkONYf+ud
         M+d5x6Pf5BkFzXtjpZY4Lk7Od64d5OTfp5eCZGkiMV+c123HxSj/0ITLHrc0aTJa9ome
         ZQuKgFSk5qB6aewX2BQnsvCWU2ZYn5qTPUVzAjVfxPBxLkvMXwX9v9s1atvM97VyD+Ow
         ZCbA==
X-Forwarded-Encrypted: i=1; AHgh+RqTNn3l50q9fe4h9C8+d7ZhXE24St6cuAL8yMtueHH4yT095ZhTff0eYiynNfa31G6XnHeRV/hny06Coto=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuCu/OA/wT7KTb41ZsnCJQlhzJhd9Zz0jCM5k/FKYc5UrncbkS
	EsTqgt9Kpk+mX4NPJNqGjDPst2DqV7+4CceeNnfSVD5h5shZiBCFmEjp
X-Gm-Gg: AR+sD10hzugyG2EnGvoGigaeg9LWwqN0EJbYTqcPutxBSs/pLYG13n8RI4JLskiAk26
	O1W0mPNgthNjNHoXWZTp2KMW17hmmsoj+XN10ZdM1jN5dJruinOfz1GliyVxcq1OtivNiIVrkBi
	HjDFvUyCrMnAShUjb2ZgU6AyqGcjuaCqavQkN+hyNE7sOXWvgesq5CoCmxcy/we0HmhLx1yG40+
	gRup36sDkuqfCEjXPoRyGf9EO69EViNOrnD+XHEcHAVa+THhOdVdVq5WNS//vL8ImbiwX95/BuZ
	TDIh08tegMjY4KrbwDvEFg2lNYIrsTwlT6fpmIWn2j+EH3ycU8VaNiCRAIrf4EKe1PrQ5s8rHB4
	PwqvjAhutpKk1TBLiqDEDuQ1HUt/nc3xXBQUFYLkqTp6dIbHZTLLiIeG44Q8SorU94kqR834Bej
	7LDwAuDebj7uYgu9EVa5YFS6aUvHVkJhTnR1GTyLMaGXuFGpJh+abyjsi1SrshB5Ev2ZEvs3fu3
	k7LX358e5ymW2YmUVJQVMS/0mvC
X-Received: by 2002:a17:906:99d4:b0:c12:49d6:3c5b with SMTP id a640c23a62f3a-c2057fc248fmr744744966b.8.1786117459248;
        Fri, 07 Aug 2026 08:44:19 -0700 (PDT)
Received: from fudgebox (k10193.upc-k.chello.nl. [62.108.10.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2080cc3c80sm67378766b.47.2026.08.07.08.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 08:44:18 -0700 (PDT)
Date: Fri, 7 Aug 2026 17:44:16 +0200
From: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH] crypto: sa2ul - use crypto_memneq() to compare AEAD tag
Message-ID: <anX9UKJ66Aak4ICV@fudgebox>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Use crypto_memneq() for a constant-time comparison.

sa_aead_dma_in_callback() compares the computed authentication tag
against the received tag with memcmp(), which short-circuits on the
first differing byte. An attacker who can submit decrypt requests and
observe completion latency could recover the expected tag byte by byte.

Valid tag forgery for AEAD breaks the INT-CTXT guarantee.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
---
 drivers/crypto/sa2ul.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 965a03d5b27a..7cdfc91670f7 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -22,6 +22,7 @@
 
 #include <crypto/aes.h>
 #include <crypto/authenc.h>
+#include <crypto/utils.h>
 #include <crypto/des.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
@@ -1688,7 +1689,7 @@ static void sa_aead_dma_in_callback(void *data)
 		scatterwalk_map_and_copy(auth_tag, req->src, start, authsize,
 					 0);
 
-		err = memcmp(&mdptr[4], auth_tag, authsize) ? -EBADMSG : 0;
+		err = crypto_memneq(&mdptr[4], auth_tag, authsize) ? -EBADMSG : 0;
 	}
 
 	sa_free_sa_rx_data(rxd);
-- 
2.43.0

