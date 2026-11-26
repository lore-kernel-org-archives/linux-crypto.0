Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721603;
	b=jomOhT5EHk5PKQrnW5KP4hKhQgd0gR2g3Kr+nyajhHlJaaCi1GzfkcYPuBTlxt+siMyG
	 yc4+1TySW/m1H4OvZBliDReKDZ7i1Y/c72EkOl/1iILOKDup6DWwo0i6XjYQ1GhCwrUOp
	 oPjfNfvoBSHP2sV+s5/2xcjJUFPNtZIxRvLkKwz++cs5wxpCyxZac9zytkGv+YagAZVWE
	 cq4hkrd1oLk7RqhV28eTfhUUdzOZLjFUj5d/aCdOE3bZZ25DFXMS+N5rGKFwZidw3HPiS
	 IuNUxmM8K9p5bNHIK0G0ghivSfLma3cjHuMXm3Ct3vTl4sZbToX4BWif21m+4gaZtGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721603;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vH8KVarvy9c5js2zbRlKpUiINo+DHyvtWOK36pzfGps=;
	b=bfOeNyrNiw/zAtBdlBa1pSjcBM88OF7wODW/z3ifmYpFMgTfgIA9U3w1qheGN7ThLYeA
	 l78ZyWe5fHMw+cctputgZLgVgC2oNHhQSUyt3NTJfYVv6F7OG7nKuzcoX799Vy/24nm2o
	 RAY4XM0E+R2rtPWrpbTJcjwbkMOmjAjCdCxQQfZFNYgfL3EDSYDLLcb6z14SkmuShXewm
	 lJhqGikbRtiPPldUKWkPPOlfKj2vD1NB5SrkAL5maPf13WSiaUd5E+HxnLhQ8Vl5q++75
	 NZmGIupRr3OwNEdORUVLZd2bWjlz/CCA9HGxHVl0LbWuMNv8IB3yyFQjBRPo8ECjKaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="ov/E8NgN";
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1259606A329
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1259606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ov/E8NgN
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb55cda775so46071405e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721601; x=1796326401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vH8KVarvy9c5js2zbRlKpUiINo+DHyvtWOK36pzfGps=;
        b=ov/E8NgN9ZtH+l2fCS4g2mhbQFxx1LmWUJCXP9cKkd6JPbERTFuwSEsBPOYcgbFZfA
         k6pW+MIBFBtskU3FfX/n/uTBCj/rPU5LZCcD3pTrPri7VXZH8Snwos0Tr/Crr9gYCZND
         0WyghQg6wC9nyCgOaL9cFkRmS5hpDW1VfFuSYX0qxTKjhmajhWFHQ2p7IzcPDK6cQ4xQ
         W/OaZ3uTR+42vSOg7jxrtiNgkDXEpcdc5E9gJgUs/ZeYA84TsI80jEECbLSmMy6sOQLF
         22leg26udNn3u6sF5qGK7YHvmh+/iTjmBejnPgJU61VbDkkXxhD15iJtbs3Q2+C+ZXDn
         ZJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721601; x=1796326401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vH8KVarvy9c5js2zbRlKpUiINo+DHyvtWOK36pzfGps=;
        b=ScaYMxHym/uprmpmyqQKZWFgb/JdynandBrBb82mFfNGQ3yRS2XAwYvVo5h9iEL3yg
         xnqyFMnuYVtY/WtFC4e0qxf8nVjqOV4w8PRQ3Pvqx4RvEI6oFP4lqjhGzUPjJ2Lh8kY1
         +uyj40IpRdMM+VzjdGMoyi+QK2+eM+/vSFYadvdhsSB0jCYedDGH1gdH05sXFIjHX5iy
         gpvUL18qpm3PJSx2kitUp97alKaw3OwGIHFXxt0BYvfSlu4lIRWUmikb6qAGfJdmKcmX
         TcMZmB9iOvh/IyGUQCSSUyg0lP6YN9I4Zgre+PG5rRvXBDaataNpAZGfRjd91wkg39QB
         /X7w==
X-Gm-Message-State: APuU4Z9dd6vTvOkAOw8SxCTI5mevM37eiXEioFwU2Ts4aywlrBZiIsFo
	iGWufFOGh5e+IBQRwcTJ1h3hNIg/dFyuGXDJNwbtFbx9cxmB/aQynTJ5
X-Gm-Gg: AZFdTZeiarcPtBc5iuTMAzSyQD7CwKLGeIPpQU7JTTfM5UHubChcRE2g8ZgbqPlTSbK
	7ZqCW3szrf34ksBr5GwTTvEWCZ7GBWKCdUHjJoPquNWTp44QaWCtVvY6jrJImqxjE8QSq4IPVh4
	8loiPyZvKBkOU5ojXd2NLixZCkRom1psEJjw4hgWjB6ibip+9M1xf3BrMjuYm0d7xR9a22Nznj9
	LleONj3+Qy9tZ66L/zPz8+yad/qWMVGsICbh3Z+dROaHcNa4GHE29oSUG1Zu0eAo11ZFgB/wlDQ
	/k5NirrxCU1d+B68TGc8rEkEOyNC47MFgsJb6TecV3GEPqXraXtCCZbkxwQUZ07NfoD8qfcVN22
	H8Y3M7psHQYIiq6YZ1MaGTOzmNdEcM3i57KjGnsSGuFF94I0+DLt/ioCTQ2zCqg0AMtthNZTzJ6
	7uCWIz3obaCP7V1cH7pFWcwS59ULUAeQL93Yktd3fIQi+mGqlj0AIIlzYICgnf93aR9JFYDhMCT
	GhRY5rBnw1B8uUiXXBCs6qFm81AEdLKSoW6YoCLVvHHhzUGWNL07/9OJThKMVZ+NHUSrSfuCgAf
	EDw/LNd2NChlKQgNoLJOwm2hK2TimJBhC0vtFpmbZT4uMlb6AmaIC/7d1L9jJOgrml4=
X-Received: by 2002:a05:600c:1d09:b0:4bb:66fd:ad68 with SMTP id 5b1f17b1804b1-4bb888160cdmr471718395e9.14.1795721601329;
        Thu, 26 Nov 2026 11:33:21 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:20 -0800 (PST)
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
Subject: [PATCH v13 14/25] crypto: amlogic - Use fallback for 192-bit keys
Date: Thu, 26 Nov 2026 20:32:30 +0100
Message-ID: <20261126193241.1471372-15-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
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

