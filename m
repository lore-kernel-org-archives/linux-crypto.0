Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780901;
	b=A5YaSMMuVzlZjTryxUzesUbxKYeHmLTyxvA0L61bOnXBfu36grFN/R6rLs6JQhyfJhKu
	 +1RdkCxnDUZg2JZkLfv9NM5ngxKKXWV3b3nFFn+BaOH0P3aZi01QK14z6NECzj6rBc9E2
	 ZWz4gkFGpRblqWgD6Yw91OB5IHIpa2UMhx0vsSruPcgkl9W5is4SkDJpApFA4qis98FbU
	 cT8v1FZxVkM8eawNKwhMR6UU9cA6le+PRNYoJL24nyjQa6EZbKRK/TfNOoHkfxeuqk46M
	 UnLHTUrmY2v1dJWDUHte1Y0NBjBcEybErqKGmhid7EVG6ZKPTCWtUvzS863NaeyfxGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780901;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vH8KVarvy9c5js2zbRlKpUiINo+DHyvtWOK36pzfGps=;
	b=3f/GMTk1KK3pN7oLmF2TfQtOwnhFqNI4nnhU/jl8RJ2wrMJOEcuq/mHNrqZaYvxzjEPb
	 PA4mdWWmik+OkGXsd9R3xMEqyi2fEs6Cc+ndWXrwk2YYPQssQmBkpqNdRcOlBOl6mXos4
	 +jwiYvOTO/PL/R0sjNzUb+aFaS0U5dlsUmajVQo5PtZQQLvm6oJ8Xl4XLVwTmJcwhjchw
	 5NwlY0R7ib+xaiW4sJibBzi5hs2piSHea8sWw4IHO3OTz0xPehmJD8k6wFROTNXnmYHIg
	 0YWvmkMfvUyOIrLnbFzhzCHnmm9RDzawCITvLOK4VETC40qCR/IdLPqM13aK4BDa8rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nD4If6ps;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164A4606A329
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 164A4606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nD4If6ps
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so77223705e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780899; x=1796385699; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vH8KVarvy9c5js2zbRlKpUiINo+DHyvtWOK36pzfGps=;
        b=nD4If6psQxV1qUCVu1yaAPXdMFYyfcB+jxkQIXhUTX0RZufzFDsERTTYT6X4fgyEhC
         J8udY4byKXW6bp9LpSuIhGBsOki/o44/7Shr4BZFyoB9xH5ojHdzLi1BK5BTJgCWtBfd
         KcBuf6P02UqGV30wAQBgzzNiMKyPkIM6o52OSS+uQ3qCzALm7xgclTstxElzbj83hjFY
         WLFqMS9Q0NPlsAi3TTwmQ90LDKX2n2tCG713OCtazIqkpLpYOU0ivg3kuqmnkDRRbjcx
         o+OL3r2YRMD028rrsEjfo5Uqq5XoI++V49KulJjv89+Ug/dIwQhrqkoKdZp48iqgrVia
         hx9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780899; x=1796385699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vH8KVarvy9c5js2zbRlKpUiINo+DHyvtWOK36pzfGps=;
        b=p1sqTsBuaZScLS6nNMrUx1hwqd26AQ9XuCqtkMJwsr/nBC1EbcNHXJRb9p3fnBNAlM
         04KV8lBtp5Ic8S3NfgLRC+601kQM/LzEZwetJu2mzUXqSNScQHt6WJQkRMN6DX+2vXdQ
         QUshKd7preGyQ6HrArSIk9o3dAUBXX8AAH2u62HwmF5VTQRXA4yEzYDPtaySGoGMMTFP
         SwSW+r2gJLj/J/bzbx5kCECZyHcVsRN0ZMbGqGEb6dx4xMnPbp9wipniHZwS0hAKAAHA
         tqHwHoKdH4fQ5BIsvWR0/du8irsi6/vWkiE3wYA/oVx4lcxY6DBx24pjcnXkR4gFgt/N
         C2kQ==
X-Gm-Message-State: APuU4Z9JclIDSaEkNBRyjxdvBneU7/iN1VKwaJLAzpm/SCCN6YvLs/fx
	iDzrUYDyI7ACQngaElB66V2kG+BXtjBUr/amNWid/cqPS4TLNPtqbRvEYA2+sDDG6c8=
X-Gm-Gg: AZFdTZeAtZSbzEKQDMB1MkNDKv8jbVlPOeeo9TJTOWZkqiJJhjdIl0IpmOd+JO9TjYi
	977vJTP4Y+q5giHDht/iGrihKKexA5Z5ouGhZ0pUIxyGR1KD0U1Gcmpm1SVwjWSBNFiNVkrnNx7
	WmdSO2/RsGw0hEUeSbwxTIBEuGmp0C4hX0mTIKrwsnAKerHrfH8jv/Cywo/HJwZ8x6l3doRxXiX
	361BHj8ptWzAGfX3g0uLBoyuKLMXNFXW2FK0v6tfyHlYj5CEuK4zpEDcWWe5rd0nt+Q7tAzRJ/T
	uKZIhFlK4hfGAd1o3RUHul4EgXpuT+1MeWmuK+ZifaO9ZQjnlsUU2O8pMY8G31z9BiT5yWUtW8B
	CvY5TwSU3Z23jB6AsSo5M3dVzv+aQCU7Zjl2ypWEtyaLy0dRkyAC/NeRywxm5QKTGDjihh0HlIL
	4QZQ6+r1hmThYtrvoVURSMKpx1Q/2+XdRxwedmdyQ6LHF8eo513DWDCcv6qkpYclU20WWI38E1h
	tsrgomcLt+RoCnwb5AkpR0zDtWKKg4w5zluyY7LM5ckFKSsIDCpKqp9ik/K/aHBaQzN3aBMBovT
	1BbrdujQ47Tb2eBcyEp9n34iU9I3U+CgBujJv32ywlJvyaU=
X-Received: by 2002:a05:600c:c168:b0:4bb:81b2:c801 with SMTP id 5b1f17b1804b1-4bb889238f1mr480667555e9.20.1795780899271;
        Fri, 27 Nov 2026 04:01:39 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:38 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v14 14/30] crypto: amlogic - Use fallback for 192-bit keys
Date: Fri, 27 Nov 2026 13:00:47 +0100
Message-ID: <20261127120103.1532882-15-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127120103.1532882-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
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

From: Alexey Romanov <romanov.alexey2000@gmail.com>

Unforunately, not all Amlogic SoC's have a 192-bit key
support for AES algo. In this case, use fallback.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 7 +++++++
 drivers/crypto/amlogic/amlogic-gxl-core.c   | 1 +
 drivers/crypto/amlogic/amlogic-gxl.h        | 2 ++
 3 files changed, 10 insertions(+)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index df42940f1112..6070ee6b488e 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -41,6 +41,13 @@ static bool meson_cipher_need_fallback_sg(struct skcipher_request *areq,
 
 static bool meson_cipher_need_fallback(struct skcipher_request *areq)
 {
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx_dma(tfm);
+	struct meson_dev *mc = op->mc;
+
+	if (op->keymode == DESC_MODE_AES_192 && !mc->pdata->support_192bit_key)
+		return true;
+
 	if (areq->cryptlen == 0)
 		return true;
 
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 9676b86a5089..f530e238812e 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -279,6 +279,7 @@ static const struct meson_pdata meson_gxl_pdata = {
 	.status_reg = 0x4,
 	.setup_desc_cnt = 3,
 	.hasher_supported = false,
+	.support_192bit_key = true,
 };
 
 static const struct of_device_id meson_crypto_of_match_table[] = {
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index b092d0c89cd8..a44290fcf3a0 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -94,12 +94,14 @@ struct meson_flow {
  * @reg_status:	offset to status register
  * @setup_desc_cnt:	number of setup descriptor to configure.
  * @hasher_supported:	indecates whether hasher is supported.
+ * @support_192bit_key:	indicates whether platform support AES 192-bit key
  */
 struct meson_pdata {
 	u32 descs_reg;
 	u32 status_reg;
 	u32 setup_desc_cnt;
 	bool hasher_supported;
+	bool support_192bit_key;
 };
 
 /*
-- 
2.47.3

