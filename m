Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE0823A8
	for <linux-crypto@vger.kernel.org>; Fri, 29 Mar 2024 15:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711727360; cv=none; b=cfVYV5spEV4EAGSDS6vbeq/IDMGksNp+UMCc2rE/2Qdo8kcnDuQUEoP+SyQXdyXHTfOHQ1KvZp7nvjq+Vjkr17mrl5ODzupehk3496l0kaoRcMRGuWSYZByBJK5p8OpGiDTY4isKk4E3Y3uMwrNMhN6FbUMLM2OzGFT+hWbEEj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711727360; c=relaxed/simple;
	bh=lnooIcnRm+Tj9mcyOfrRGjNu8vfwrgz8A/shrwBRbbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=udxSUQwhVEUjUzuEHMQqJ0hg3FfnAF1uNNOoLvC/Y3KonSZCL/QoIH59/X/uqsdWyebrCO/2/pCR7lmjdMa0ClwQNroqxBxXk6OLr9XyqWEEk80tZfsoR9FsgOs6FsqwjYUQA6hplbxa1uUR1Y2lQWr9R64v2zk6vP2V7rUh9B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=fMQo+Z7A; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="fMQo+Z7A"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a4751063318so266718966b.0
        for <linux-crypto@vger.kernel.org>; Fri, 29 Mar 2024 08:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1711727356; x=1712332156; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xl4g7kNwbZSWPZHN5jBx2cvEXqgu3O7G1Se4DzXl3uE=;
        b=fMQo+Z7AL8tM9cuYXErnx7hO9gy514ZVipjF13lMr+GvGtE4v+lrJWKI3X8uT+rbZs
         QpbytKBsloff8/EsV8zd/13KYoU1rthfRTg67nKHk3GKCbHaj6AW4pqtca4LEnmQxPtY
         dSwL3Pjt9SAJ91SoLqZYzc69eVKEhbqyefHBEIA7tc0UgCp/ZHZhCURlRS/Ml0LXxq9t
         YCu1EN/W/B2hByHflGuC/QXpGGSWWf7mqwuVwDC6swbMlxbLwe6489v2c7oUKdWSLr9S
         fvyn0JSPkkcWAQxg6oST42poH/n802O4xS2kptY+5UmZ2Y0tWM5tBjcEA+dzdq3q4Lo5
         tOkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711727356; x=1712332156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xl4g7kNwbZSWPZHN5jBx2cvEXqgu3O7G1Se4DzXl3uE=;
        b=hmkEvs5TtkAfO/ciqbqz39Kau7WYrZE73tf30EBaf+N1CjaZXNx/LtnnQxlGS0lya8
         rAq2vhzhzFNH6SoVZ1XkFLQ27xB0JwPKpuXenJHgIusDhSRm+/hZk6k99zBCIrNUJA6c
         2c2/FONhRRiHw4iJU7ahz2THGEHjc6z3zGfP0PnWbrgitCdAPL0AlOb2diYXNmoI8yGl
         V+GCfjmS5/IkCgX3QiB+TleSz9BA1ddZMqQ/ts5ZRRHc6Xsbs0rCSsXmwwnlaOHZWmL9
         Z0TLJZGrLBT74Wtfvfkvh4mOH+g8BdKF0JrSYfzcIBWm3/dcEeJ1gTZY3Ab6CDllLREC
         /oZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVprBGcoaYc3TaeNzMpU276bTuVobpUCEHYITsxNZS2ODuImFZsO37OebIPf7KSZilOszWmsTX8AvWnsKsiwsUvi7ZicPaHJ6Kpqe5a
X-Gm-Message-State: AOJu0YyRlAgvqHEAiGHNwd5W9yUjTBStf4i5MbUvlZ2SeM89rmKcY3ci
	nTABm3OimQe9Ig9QU046h5Ax9c9g/o1rPfsG1K9WxGNjfLosMG1aUYqawfSmvgs=
X-Google-Smtp-Source: AGHT+IEoTDNuKniQKyvP1LcAKCmnmgTPpoKnq+nHfUNUTmyJXKTX+6p6o2lqqh+la6T6vBc+BWJu3g==
X-Received: by 2002:a17:907:7e9c:b0:a46:ec44:477c with SMTP id qb28-20020a1709077e9c00b00a46ec44477cmr2119729ejc.41.1711727356324;
        Fri, 29 Mar 2024 08:49:16 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-212.dynamic.mnet-online.de. [82.135.80.212])
        by smtp.gmail.com with ESMTPSA id bw17-20020a170906c1d100b00a46b4544da2sm2038962ejb.125.2024.03.29.08.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 08:49:15 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: thorsten.blum@toblux.com
Cc: davem@davemloft.net,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: jitter - Remove duplicate word in comment
Date: Fri, 29 Mar 2024 16:44:54 +0100
Message-ID: <20240329154455.1733-3-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328160401.445647-2-thorsten.blum@toblux.com>
References: <20240328160401.445647-2-thorsten.blum@toblux.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

s/in//

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
Changes in v2:
- Fix the commit diff because I made a mistake when breaking up changes
  into individual patches
---
 crypto/jitterentropy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 26a9048bc893..ee2aa0b7aa9e 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -158,7 +158,7 @@ struct rand_data {
  * See the SP 800-90B comment #10b for the corrected cutoff for the SP 800-90B
  * APT.
  * http://www.untruth.org/~josh/sp80090b/UL%20SP800-90B-final%20comments%20v1.9%2020191212.pdf
- * In in the syntax of R, this is C = 2 + qbinom(1 − 2^(−30), 511, 2^(-1/osr)).
+ * In the syntax of R, this is C = 2 + qbinom(1 − 2^(−30), 511, 2^(-1/osr)).
  * (The original formula wasn't correct because the first symbol must
  * necessarily have been observed, so there is no chance of observing 0 of these
  * symbols.)
-- 
2.44.0

