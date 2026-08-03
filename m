Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568B730E85D
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 22:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785796833; cv=none; b=hicVgIEnyJ3KOPr/264n2YDxvLatbHFZxbbnf6X5bwhpb0fh3MhBhjAWhmrNcnbmC4IBsAGdKWIELLSY3g6dkfJ97FLYt6lKL+DzIN5DjuAycLaZHPETN1iLdyZ+ofgkqvXi4vusOVU3ta97LPavbulrFE6rnE5S5XTXho0bESA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785796833; c=relaxed/simple;
	bh=VBin3fKUCRlsDlkXw8qTaQ4uOqAhatoApOdan+EvJeo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WJM49JKufK6RywIA56J86cWcePO2NPJc/OFqNnp9GDOujZAJ3mjUM/focq2pkFaBj4+BXLyRVOcxZN46G2gDQKwjuuz7XFJ5toTjEGb/V7Wv4MFZtlLxP3n32+TwYp75X8z9ZxjQWAh89FLYvK+ySxDtQSfuA7gl/I+W+RsqGgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XVPUrb3L; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XVPUrb3L"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cbe6295f05bso310476a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 03 Aug 2026 15:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785796832; x=1786401632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/b25x1MMUKD6WDX1Tuev6CJ34C4sSksygwaie5KO8Mk=;
        b=XVPUrb3LixSw+ucseyFrSK4uw0+++NQo3hn3uOEn4o/1d6IFlPYiDqvG7N0icZSIst
         YbG2C+H/DXvXmerNKawCcBc8yo/jLgox9WAbfenbk96qPk4+Hly7IbN4A78H5/7T0GDI
         1DQbbOWtoJ5C5gE2gkI6Ik9eia7fXUMyKxnFDiRkx5/jeoXn6KpY9/yk+pQ9X3UhIN65
         ZID39Ry8rQSUFLpKMgoOvCRpKTQeqWXPtqdQkINF8xf3Dq5NO3EH6DlSq3Ou+bgeSpac
         0rHmiIxDGJ+5LMxCeHgcI8UJK6EiEHRT9sy8HUqnDrVD0m/y6TEoBVIfeXPsyiZLUvk5
         HATw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785796832; x=1786401632;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/b25x1MMUKD6WDX1Tuev6CJ34C4sSksygwaie5KO8Mk=;
        b=K6XZnSTi94XI8I6TsxN8pzIGYaxjODv/mxB1ZBkLuHS2RQduVTsEQ38gBGy2YZBK5S
         w9lMYnXUyhzL8ceVaq0mhCkHEPgFSckO3v9dsyAjkOzd8T8MyaFheG16G8/qO5nUDNKv
         XvIHutZ0bqmg8n6uwPIUtGVYrSV/KNf+VCtcHbxGVJpe2T8KCTbf9mZQZyRdxBTKx0Pu
         lFeR3dfJTqCYwjZLFlnlHAv1n6ikN7XRxCtNRykjPq7tdWf4jcmW8oN20gNYKE7zActv
         Mr3J+6LqNJrup/V3pcJDm9aSqRWaQgeUOv78bZQ7JRv8XiLn/i3PNGIT2o2WiL7oIBNJ
         PAlA==
X-Gm-Message-State: AOJu0YxDNPWlLilxEmT54K48lMkyLXQwBTYyhTJIgXhjutc7mqgxp5j9
	K7kxa1eKmh5DnQ0sEwCqjrGCjfwku8IqAnZnNVHVj2SKxKMrd0r9+ot1JseVZw==
X-Gm-Gg: AR+sD13NZgKlNUdVvVGMLvkwAbHjWBUVoHV4PiNxWfRE7TH1nWgPk8fjGkdJ+94NGg/
	qAyedXJXtYkUES06YnQgQpv2piw2mGmRkHeYuOT7+OrDgfTw//KMpa+RW+tEyOlKovJg3wqVJtG
	PViEJoPbrTGYY/9AqpS95olZm1bTDeILXcc6yHr97QOsHNS0v64C3X6RtHSIjlfnIMBNEVHlNSn
	oqsMk1iFc7TpXL1inLC16BksSNAhwGGqqRVfgza0PKzCj7pko5j+mY/fnonM6mP/JXnaroJVxXp
	/97eolqEBkh2/bpXvubKMZ2U6JTGXhnXbnnBTbPObg5lf4ygiDayMEJdpxpZ+QddUc3q6PAP+lx
	3Hw5AH8FVX/7MBiYhNAx9F1yY1FWOFs/PdbfWoWqT8yXB9zuAS3mPq9IFaSG/sbcWrxA0lZbklx
	lVvTai85ea71NvUdXQGM2jtekYBIMAV0781xUbE06kOVDhnis08JRIPF0H3xgmFYnwJ2W+RNrFe
	+647wVrEQ91Hddcl1ORgsuggwnY9XnSZBKlOaQwKqY1RAbe9Bzd+J8Z4UXv3zpmadyRTFINtEuL
	ncbQvECtqN63CL4YwqbO8+seqjrHyak5MKd30Q==
X-Received: by 2002:a05:6a21:1405:b0:3c6:3c5b:f7a7 with SMTP id adf61e73a8af0-3cb6c9d468amr1106262637.38.1785796831573;
        Mon, 03 Aug 2026 15:40:31 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe3963e2aasm4144468a12.2.2026.08.03.15.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 15:40:29 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: eip93 - use struct_size() and flexible array for ring allocation
Date: Mon,  3 Aug 2026 15:40:28 -0700
Message-ID: <20260803224028.87631-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Embed the single ring as a flexible array member in eip93_device
instead of allocating it separately. This simplifies the probe path
and uses struct_size() for a single allocation.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 .../crypto/inside-secure/eip93/eip93-main.c   |  6 +----
 .../crypto/inside-secure/eip93/eip93-main.h   | 22 +++++++++----------
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index 1a8dabc4ada4..e62785952b0d 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -415,7 +415,7 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 	u32 ver, algo_flags;
 	int ret;
 
-	eip93 = devm_kzalloc(dev, sizeof(*eip93), GFP_KERNEL);
+	eip93 = devm_kzalloc(dev, struct_size(eip93, ring, 1), GFP_KERNEL);
 	if (!eip93)
 		return -ENOMEM;
 
@@ -436,10 +436,6 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	eip93->ring = devm_kcalloc(eip93->dev, 1, sizeof(*eip93->ring), GFP_KERNEL);
-	if (!eip93->ring)
-		return -ENOMEM;
-
 	ret = eip93_desc_init(eip93);
 	if (ret)
 		return ret;
diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.h b/drivers/crypto/inside-secure/eip93/eip93-main.h
index 990c2401b7ce..5f0f51081743 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.h
@@ -92,17 +92,6 @@
 						    EIP93_HASH_SHA224 | \
 						    EIP93_HASH_SHA256))
 
-/**
- * struct eip93_device - crypto engine device structure
- */
-struct eip93_device {
-	void __iomem		*base;
-	struct device		*dev;
-	struct clk		*clk;
-	int			irq;
-	struct eip93_ring		*ring;
-};
-
 struct eip93_desc_ring {
 	void			*base;
 	void			*base_end;
@@ -131,6 +120,17 @@ struct eip93_ring {
 	struct idr			crypto_async_idr;
 };
 
+/**
+ * struct eip93_device - crypto engine device structure
+ */
+struct eip93_device {
+	void __iomem		*base;
+	struct device		*dev;
+	struct clk		*clk;
+	int			irq;
+	struct eip93_ring	ring[];
+};
+
 enum eip93_alg_type {
 	EIP93_ALG_TYPE_AEAD,
 	EIP93_ALG_TYPE_SKCIPHER,
-- 
2.55.0

