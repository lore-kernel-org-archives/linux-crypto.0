Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BA56A031
	for <linux-crypto@vger.kernel.org>; Fri, 29 Mar 2024 15:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711727658; cv=none; b=hVlkzv18DurFE9FGCuO4pHxhFu43ldjsBqfiPJHUDGo8vb6D60dZShR/cAdmn/qBqmdIrMzCjn6RzsKWayo2DIiF04eeMODi7URAsbIVTYUp6rem04fz27u/QUeJH49QmFpWECs17muNnu9zV5qiSz74QF7S1AuFkg60njQDFw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711727658; c=relaxed/simple;
	bh=vtTblsRc+wVqJ6tKn5gTXVgrZJN5e4s6L8dhh2uEnLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L7jhla2/Ui/4LKJp20cw9lLxIDDOQ75VZbLNZhgNXlChxvDk2I/NMnRPDr1m3Sb8vfEopAQqZnSKaoxDz/IZ8ytBYVi/oe47ajijfyjAitTJKIFfE2LuFn2GKkhlW+BrdtnRuiiU+RER+pe03TLSvzclWdj9wu0R0ER4g4LV/tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=tBg5NsLI; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="tBg5NsLI"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a2f22bfb4e6so287003366b.0
        for <linux-crypto@vger.kernel.org>; Fri, 29 Mar 2024 08:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1711727655; x=1712332455; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ydk4tnBWDP6DoMkMXrIOPwG9i0lGGhIvBed6DXOHPjw=;
        b=tBg5NsLI3XDF/eQ0hhlvMMdc++tdmrZ4g8G1l2S4yFRfKO4S4RKCvtZFB7D6j15g+/
         KXcGtGHCmGOsfqRphxWOXsx9pL4IEwLKh1ld5nmk2Hibon9LIH/4kFVfmBI7je3++pdR
         kjIK9R4gOwxolixptQZgtbT8AlG0eTodFpYlFl771mCYOtbpzRkEPurD26G9HsQr4Cvq
         SnpoVCN4kaYi1356p45H7HVdRVM22lBiPVqvwR9c00GIwzI0r6qlXPCsC8fsMtfCFthZ
         DLpRjE7oFOpCcZ4NKaeqA934iu4fnIRuIOu10jXmm0qu0lmCwccD5kDMs19Re0D8zqaE
         g8Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711727655; x=1712332455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ydk4tnBWDP6DoMkMXrIOPwG9i0lGGhIvBed6DXOHPjw=;
        b=LNgeQNGqP/WKwt21+4tgTdUs+bJdScUzvUZDmn09p1aacteiZBA5jE1/P0ohlpZpLv
         20qkxUb9YdiiFbEtC+G+JmSYDIftaVN6q0RQsLX7hbU/iPvEduRjcM6b3RBLz716fzAB
         TcSbt4nKhSnvc/r0GWJ4YjkZB3ZubCehQVwAXCUqgBTp+GeNiqQHB8CV/J81l39if0Gv
         RxyGJTROulzXh+/t9Luynr+F75vUfNWq8VHm6iuUfd6WBbolb1w0dvLC9ofAYt6Arj5t
         jYu1LUzv2rnYeUZD0fIC9UjXHJID6SHP7YT2rsuCH/Lji0nibg3ocIbNeIulYT319CsT
         8kTw==
X-Forwarded-Encrypted: i=1; AJvYcCW67biUHYKEBKj3DaRlrGoKKbiSpvzVaAuqrwZVljUO4FQyxjpkhzLdOIoyR05xEVS93T2/lkQ4AYmsds774h7vnYLXBElw+4BjkyD8
X-Gm-Message-State: AOJu0YxanK7Kfv7YbmdhnBn0zwGEiu1eupfxQMH/r2brOoRxOLEmeppe
	czZ2TyYlJ332sxCh8xSoEfabY93x3tNqvV/jp44UgAe5MXwsS3ghxpRvpK0v14o=
X-Google-Smtp-Source: AGHT+IHq+DMnS1H+BOBJytzr6EPT7vrwrca2u3kAsQ7K8DmMFFjbSyT3iO+fnMlYGEz682MaGnGRMA==
X-Received: by 2002:a17:906:c0cb:b0:a46:b1b3:aba0 with SMTP id bn11-20020a170906c0cb00b00a46b1b3aba0mr1799114ejb.17.1711727655311;
        Fri, 29 Mar 2024 08:54:15 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-212.dynamic.mnet-online.de. [82.135.80.212])
        by smtp.gmail.com with ESMTPSA id s25-20020a170906bc5900b00a45200fe2b5sm2058379ejv.224.2024.03.29.08.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 08:54:15 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: thorsten.blum@toblux.com
Cc: davem@davemloft.net,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: jitter - Replace http with https
Date: Fri, 29 Mar 2024 16:53:45 +0100
Message-ID: <20240329155345.2015-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328190511.473822-3-thorsten.blum@toblux.com>
References: <20240328190511.473822-3-thorsten.blum@toblux.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The PDF is also available via https.

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
Changes in v2:
- Fix the commit diff because I made a mistake when breaking up changes
  into individual patches
---
 crypto/jitterentropy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index ee2aa0b7aa9e..d7056de8c0d7 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -157,7 +157,7 @@ struct rand_data {
 /*
  * See the SP 800-90B comment #10b for the corrected cutoff for the SP 800-90B
  * APT.
- * http://www.untruth.org/~josh/sp80090b/UL%20SP800-90B-final%20comments%20v1.9%2020191212.pdf
+ * https://www.untruth.org/~josh/sp80090b/UL%20SP800-90B-final%20comments%20v1.9%2020191212.pdf
  * In the syntax of R, this is C = 2 + qbinom(1 − 2^(−30), 511, 2^(-1/osr)).
  * (The original formula wasn't correct because the first symbol must
  * necessarily have been observed, so there is no chance of observing 0 of these
-- 
2.44.0

