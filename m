Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34653CC9F3
	for <linux-crypto@vger.kernel.org>; Tue,  5 May 2026 07:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777966646; cv=none; b=UnxQo/2moPHg+Q0/Z2PDwaHu0W1JjIv6XzXOar8iB8UDDUwckIKyz6WxlWr9l9EA+KoCupyuT7OeXnrQBYuomi53r5h9aoLfeaggaXfqXpGUfeFUWhT6PLmlfAROrr7L1u3Jg4N/CB+6FH6nI0JpZbnt8zqudHx5vmNOSC8YA8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777966646; c=relaxed/simple;
	bh=IJ8fOwbxwCTp9Ks6bWz1Vj41x0dRZq0kJUqRAWzOlM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EIadUbyB8teUifcPE0xI834DNZTWss40XbCXPHV4GNbnJ6tAMmJAgD6yRUAI5q2ypCbLQSGyFNPweHPLbIpFg102zZT+kQGqaNjRQtkZZ14Yz1H8eeEB4M4DEZA5pRX0eO8kenbSpekaN9ZVbC60N7MLgSzDc+Y8inClshpokEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e12KG5Hm; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e12KG5Hm"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-838d0b7c950so644875b3a.3
        for <linux-crypto@vger.kernel.org>; Tue, 05 May 2026 00:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777966643; x=1778571443; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i0DH8W9/s3GguFFjUkHHe27A9U//szz9TZ2MkEXFYvI=;
        b=e12KG5HmHD49c+V7L77KGUjuPCrGUR+KXMfMNtxeIOe0iqPeTvTuhUhincGVWJVSRp
         WlsA8UScVaKEb8o7sdYqYDpfIqG6ePKVnMiwyqD9Ir5EvGvcDP3G/CgbVC77QPfkh7k1
         +OITiP2V9Vq+hcuhyT8+eMSE5P7bh8a6dO5a6508nOuIuNI9BzUbXAxeCTh0BfCGJxVY
         y5HsT+9YzdSZR4ERnFjS80KXZ+DX+RJO1+EZTBm6CEzvi3LQgiQY2xyyaRDn4wLZgzjP
         fi3tFGP8p3xkNLqqBsM4ONc8YT2H/m7qSNZseSDGqriEln9VL6t2sQDO7OaCJA9S67A4
         Wk8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777966643; x=1778571443;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i0DH8W9/s3GguFFjUkHHe27A9U//szz9TZ2MkEXFYvI=;
        b=pMOTDOjozIOsR+Yh5LNS1BQz4yQMjtqAPMop6PUa+nkt/EQVsNDZQQ9tE79ph2ql4B
         aPr2Mm9aXBFnY6FthF550OxVtvJn1DUe3ScoyFrZMrJ5YGFgEfLyPJTWcCFh49hVbuUi
         22HjguqhfUrlEucnEbYlIQpKqtCBPm5T7DpdrXBXhcl4hKhfzDJ4E86pFijwrI2YUBJk
         lmO9xr0vWRn+hnHig4zSNmb0sSph7Efc1csb2YHAnGEYPdRj6q/73f0XE0tDAPSKmq2N
         DfSgW8CQzY/vVaC+T6OtH+i18p7aq8pinXYuf2gIhpr4bIiJIMhwfbexqb5MewKwzGgB
         7hPQ==
X-Gm-Message-State: AOJu0YxQM9aFSNqU6Eo7ERiAlkvLIMFgS1PfED5wEvtMRb16Ij1GBLDf
	BW1Yi//h9OI3ghBEqJxXwvpD/Nhl79lXgk7jcnrB3bKxmHwGvaY8zOXNfAmAQE/k
X-Gm-Gg: AeBDietX+MNd2+OEpMl+RtWW0z5d4iu5DiUteCFv0+543cO+vkS9WxDmwP8i7gJ7tQf
	xwS3Z2vVSlVGT7ZPyc9s64QuGmp91G9vvkuO4i2urXz7JyCss9udlqfQf+h82PcclkqkBprou95
	/luuXVT9c3YTurX4ARf9EnT6ObDvsRmKPp4MYabCeym+rTbgK0VJGc5mZvB8CKnuJUZMQ7b/3n6
	NmCsCmc+CXJ7A2Ahah6uWXxCnNg7RweahVwiAWB3vWydGhD9+vIaT6gAc7PLK2fm1GRZRQvCjHM
	UdpRWA/kvDGY8DlsOaK53bzQ32+iXnRPtoCXr2XYwOf79imlJeLLINMAp1bECm6fa7o8Ke1LjI8
	gRT39uiCci2MMrNbN5IRdxcqbxtdrDVOpKetQBK9+AaB5qAuUMJuPR+BN4xBvtEly3DdyD1Rb8q
	uLP1qLo4x98g4F7Ov2Cb1jl0VeVrcD7RBUo4WohsXDTZCbJVeQ55jmPzToqYCX6uuQ+zCQkaGjW
	KOidViPgpxZWpIP1YRyVvDUSfsJMaGFCsZYTJgpB4oQNA==
X-Received: by 2002:a05:6a00:92a8:b0:835:6d99:3f94 with SMTP id d2e1a72fcca58-8356d9949f6mr9288842b3a.25.1777966643412;
        Tue, 05 May 2026 00:37:23 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965c30ddasm1492602b3a.21.2026.05.05.00.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 00:37:22 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org (open list),
	linux-hardening@vger.kernel.org (open list:KERNEL HARDENING (not covered by other areas):Keyword:\b__counted_by(_le|_be)?\b)
Subject: [PATCHv2] talitos: allocate channels with main struct
Date: Tue,  5 May 2026 00:37:05 -0700
Message-ID: <20260505073705.8810-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use a flexible array member to combine allocations.

Add __counted_by for extra runtime analysis.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: add check for of_property_read_u32
 drivers/crypto/talitos.c | 19 +++++++------------
 drivers/crypto/talitos.h |  5 +++--
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index bc61d0fe3514..e1f009684216 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3409,14 +3409,20 @@ static int talitos_probe(struct platform_device *ofdev)
 	struct device *dev = &ofdev->dev;
 	struct device_node *np = ofdev->dev.of_node;
 	struct talitos_private *priv;
+	unsigned int num_channels;
 	int i, err;
 	int stride;
 	struct resource *res;
 
-	priv = devm_kzalloc(dev, sizeof(struct talitos_private), GFP_KERNEL);
+	if (of_property_read_u32(np, "fsl,num-channels", &num_channels))
+		num_channels = 0;
+
+	priv = devm_kzalloc(dev, struct_size(priv, chan, num_channels), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
+	priv->num_channels = num_channels;
+
 	INIT_LIST_HEAD(&priv->alg_list);
 
 	dev_set_drvdata(dev, priv);
@@ -3436,7 +3442,6 @@ static int talitos_probe(struct platform_device *ofdev)
 	}
 
 	/* get SEC version capabilities from device tree */
-	of_property_read_u32(np, "fsl,num-channels", &priv->num_channels);
 	of_property_read_u32(np, "fsl,channel-fifo-len", &priv->chfifo_len);
 	of_property_read_u32(np, "fsl,exec-units-mask", &priv->exec_units);
 	of_property_read_u32(np, "fsl,descriptor-types-mask",
@@ -3511,16 +3516,6 @@ static int talitos_probe(struct platform_device *ofdev)
 		}
 	}
 
-	priv->chan = devm_kcalloc(dev,
-				  priv->num_channels,
-				  sizeof(struct talitos_channel),
-				  GFP_KERNEL);
-	if (!priv->chan) {
-		dev_err(dev, "failed to allocate channel management space\n");
-		err = -ENOMEM;
-		goto err_out;
-	}
-
 	priv->fifo_len = roundup_pow_of_two(priv->chfifo_len);
 
 	for (i = 0; i < priv->num_channels; i++) {
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 1a93ee355929..34b0b5fab7e7 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -139,8 +139,6 @@ struct talitos_private {
 	 */
 	unsigned int fifo_len;
 
-	struct talitos_channel *chan;
-
 	/* next channel to be assigned next incoming descriptor */
 	atomic_t last_chan ____cacheline_aligned;
 
@@ -153,6 +151,9 @@ struct talitos_private {
 	/* hwrng device */
 	struct hwrng rng;
 	bool rng_registered;
+
+	struct talitos_channel chan[] __counted_by(num_channels);
+
 };
 
 /* .features flag */
-- 
2.54.0

