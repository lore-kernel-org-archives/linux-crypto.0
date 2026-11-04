Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793792483;
	b=zo0Ytcqi7T0e9Nu5HxQfv07to7gZjlS09w6nE08vRoKrmaUx3PN9HGn1pefYPbzYrG+w
	 f4cI/laNZIgjgspOFe7h1UprrmyvHDp3P2IYq+CjfE9ZayfUeU7WAEK64qqlucFk3wvAE
	 f9Q4oLcRNnqEZvB67bVliL0a7J491Ig0nBlqAPRI1s6uNxbvoO2BR/2xAE1lKXlP4/lxd
	 mlUSNhOQqovrA7ZorMyPH2Q0uryfMZxHKtC+OAseTV48p+KVuOOzDYX/GJuqmd/sN8w/o
	 x0XKuq0TJyBVMNQLfgiDemRHeFMVA3B4tKLudiZp0GYR9pfWSI20aagyQRsVGG3QgXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793792483;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=izYKdqoeoSdawHeFj/YzAtZebFxT9JtTIALU4NjHjR4=;
	b=CB2eOjQiM/bRzY01N0mntCQO5NfobK3f/dZcdlmpAgP3dFVpKZwOMlYai+GVd8lgRIRo
	 EFxlU44umZmKQ2O5EJcF6Dz4d8tvePgh4xUJhlrhXsltW5Y6SQ3dI7rkBHEzr5d51lEek
	 sHcRSj6yZjxixSZ+a7l08X5xFjWOiSyJFtFt7qy5LlBv8t21sKhs7bSnyhDUfNjq14dXD
	 W2pC29+4vMjslEnO/jQ6OSA97cuOObr5K42cJ03Npniyizo4loenB/1G/9DSPT0TyuWoE
	 iFibai1t/Pw3O89UV6qvIN/k0O5fjSwkmVtY9Kqd29ebJcfftCqN2qWY6DrXtOykIBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FUpSFZ91;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54878606A330
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 11:41:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54878606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FUpSFZ91
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ac6794fe45so501305a91.0
        for <linux-crypto@vger.kernel.org>; Wed, 04 Nov 2026 03:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793792483; x=1794397283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=izYKdqoeoSdawHeFj/YzAtZebFxT9JtTIALU4NjHjR4=;
        b=FUpSFZ91rkWfLqLAFhZVbsjzNMSUObbfpIwwxnxRFhycxnlfSNv3QRqzXs3Yw2Ub4D
         pF7Bm+EEkpxWFMage9B1J9QUdD7J0QxtSh2kBak7AmuqagHq4TRhsJwnQ8vKE1kc+kEY
         h/sTj/mggLP2S4OUpe+q3uNGrr5LlDagL1oqE38xM0aLfiJDEMk93Y3A8vp/fHkyLnp0
         ZydBne6Wo3QNWm7mfjIDvM0a/FdhsVHdvUSKprpW2qeHUvkAQS4aOTZtzf6AHk3zo8Uw
         EpZk3FZHUKWp/osTNB/h1NFIlgv3nYg0NMKTItEHkYsOS/+DH1YxtVOWCsJtgi+uY02Q
         5vEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793792483; x=1794397283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=izYKdqoeoSdawHeFj/YzAtZebFxT9JtTIALU4NjHjR4=;
        b=0YattmW1NnyjzAfqvYELvsWauiX931gwbdpjaIgDq2ByXQjhQDUZJu3Qtl/4sTVSU3
         b0ifMI+zFHYj4WMtZE+ST/QLgw1aYfklqZ0dsl9vuVM7suQf5yaQC39bkuKOyec6DeMO
         WNoQzP1ekwoNwqsKPjeVYaOgwr9Wh916GB80kca8EMZ18JSXOVPYHCH9nem3guQg5lwT
         iXIWlxuyhruUkihuYoQGH/PwKVtyWagvfDdAcascW2JSBKC/OL+eObTPGMuwrLqIj+0v
         UHKtxjngCyzDWjBC/2I5CGuo4FlVXikpABo0f6coDqLReqEhdkF6B9lkEuL288T9Wcc2
         vj3Q==
X-Gm-Message-State: APuU4Z9i+fX8S6wA44pCwR/TkC/I3WSK+bcMyQq/ysgpTgzeWIhYWT++
	FiF1xGG0Dd9GmJS7+ZVlEei3EguCzcLamidgMKcsdbCtWEyg0UnLTPVxAApoWw==
X-Gm-Gg: AYBFou2tHTJI9LzjO403PS+7wrPFDW3fffDcBDWfLZ9O0bjWg5rhrqTXMLorBVhmA8M
	G68J2+iAI62u2st4njak36GVL7b08wTP3sRSe3DrvIckroSl0YvL0RxXAHtGDitu/W9tRU9e1Gv
	T/BWJXGguDDZClVuyvUwX5QpOWnGDVODNtNwH095tATDEu+bFM9hTQsWOSo4zAeFx9Grr1nILND
	4s/ao+Ffc5luBvtAOlR4i4mE8lG/MZWJ3k4bq6ttGkOU0AIzgAaWDK3Q8WhAYh6z9VBRvAHkTKS
	uuLeB+pLI+mUMkNMpxsuXZBqLFuvOG+XlGfRzLWKQ+kqsYegs68ukz46htXmP9xBH0gHb0cstci
	iGI+74H/ht38kjJCFcXM4OAvtvDZ8O5ru6HHbOVz0/Q5cM3WEBGmaizFzLnHZjbBfCOpidPsmgD
	ANewoqVI6uSfQTSn1EHYOHPubxfaKYbULtDbHfDwUgtlk6Nk2drJUL1NPvCxS39NWvwabDJmjR/
	PTfBhDxjkJ/6yMXi4zDby/COGkKrhY0oOnYJijmoJLx1fwZRrDjXfc/hyedg+ZkYcB3T4QYX78+
	wngAVVGBPF9lqVDDG9ui7ICC9hOLYMnHZU9UjJXsHu2fpRnsOa0O
X-Received: by 2002:a17:90b:562d:b0:3ad:a462:f07f with SMTP id 98e67ed59e1d1-3ae8982c1ffmr14269962a91.45.1793792482472;
        Wed, 04 Nov 2026 03:41:22 -0800 (PST)
Received: from d.home.yangfl.dn42 ([2a09:bac1:7680:28::4:396])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b093d481a3sm3770036a91.1.2026.11.04.03.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 03:41:22 -0800 (PST)
From: David Yang <mmyangfl@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: David Yang <mmyangfl@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] hwrng: histb - fix read timeout
Date: Wed,  4 Nov 2026 19:41:04 +0800
Message-ID: <20261104114108.2378751-2-mmyangfl@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104114108.2378751-1-mmyangfl@gmail.com>
References: <20261104114108.2378751-1-mmyangfl@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The old figures were per-word averages, but the device produces 4
words in one go, with each unit of post-process depth taking ~200us.

The old 30ms timeout was chosen on that per-word basis. At a depth
of 144, a 4-word batch may take as long as ~30ms, causing random
read timeouts.

Also, a restart after rewriting the control word may take ~300ms, so
use a 500ms timeout instead to cover all of the above.

Fixes: a2216e187471 ("crypto: hisilicon/trng - add support for HiSTB TRNG")
Signed-off-by: David Yang <mmyangfl@gmail.com>
---
 drivers/char/hw_random/histb-rng.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/histb-rng.c b/drivers/char/hw_random/histb-rng.c
index 445b80beed62..d435d4ab9aa7 100644
--- a/drivers/char/hw_random/histb-rng.c
+++ b/drivers/char/hw_random/histb-rng.c
@@ -26,16 +26,21 @@ struct histb_rng_priv {
 };
 
 /*
- * Observed:
- * depth = 1 -> ~1ms
- * depth = 255 -> ~16ms
+ * Observed: the FIFO fills with 4 words at a time, roughly every 200us per
+ * unit of post-process depth, i.e. one batch per:
+ * depth = 144 -> ~30ms
+ * depth = 255 -> ~52ms
+ * Rewriting the control word delays the first batch by up to 300ms.
  */
+#define BATCH_TIMEOUT_US	(500 * USEC_PER_MSEC)
+
 static int histb_rng_wait(void __iomem *base)
 {
 	u32 val;
 
 	return readl_relaxed_poll_timeout(base + RNG_STAT, val,
-					  val & DATA_COUNT, 1000, 30 * 1000);
+					  val & DATA_COUNT, 1000,
+					  BATCH_TIMEOUT_US);
 }
 
 static void histb_rng_init(void __iomem *base, unsigned int depth)
-- 
2.53.0

