Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BC71D5CE3
	for <linux-crypto@vger.kernel.org>; Sat,  4 Jan 2025 20:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736024114; cv=none; b=CD5uEx9+vpwdVtGT8Trki4BvGo6S9qOviekjtznMEpghzsZnUNmCjPwqqzlVqBflAhQ7FaC6xFzDztKEBaPiC6Nm3zKBigG7jEhPAsLfjVT/u7Vcrh+GrgUqt6XuYDlYYBiukuQU3nDpxgbvjzBM4HvxNS73W9bt4gHBeCgRotY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736024114; c=relaxed/simple;
	bh=Xn/kRMOeY30BbZdhigNGOrSGfeTCnFdlp6m/DcAWf0s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s34TxnQh5fuAp4G4fHpFEStWqp7dHujNzxBS2SHIz0t9HEHOY3x1PluEnSg5dM/YTrUwQNi/Cus0I3YJ9cp0y+o6mVEuwxi+Li/ahErgycjn2myjDYxHweiIAFO3eguePntb7qr+KXJTkmJw98rvhTIHGlLDdoLwlDLK5YZCKIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mc/65IQt; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mc/65IQt"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d3c0bd1cc4so2500912a12.0
        for <linux-crypto@vger.kernel.org>; Sat, 04 Jan 2025 12:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736024111; x=1736628911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WDsJNqlpSJNNawMf3Py4v8MhzkVez917T1reSgeDSXg=;
        b=mc/65IQt+2MM5+Npo75wBtMSx6g+8NOZFzOlD+Dw7oTdp0pA7GpEGSXm2g4NkLTknf
         F+PtkoINvl3oa1jPYy+Ukdso7u5+Xk9iurumY3BsUOlMxifPaBeJf9VGRtgMhW6PQbis
         axV0Lf/OWMZQ4gIBpFfiKoZWevTaDUuihI2sh6fvgxqQjykh8ikUOu6vrbxKsz2ZkTnc
         UYsPh9aaVUlpLF8uzky8frWKcmZNNj47DvcMYHmQlz/3i3usl+MinEfRZE0vD4UBMU7h
         GccCKA0sCMna8eZ62S4Vb29y/cf1Bwo6/1re6nZ0OZLkn0eTaUUTtLVhJLpgCiFyIdab
         LCDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736024111; x=1736628911;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WDsJNqlpSJNNawMf3Py4v8MhzkVez917T1reSgeDSXg=;
        b=eO2hsFd06oHTMwXYn6HEWAJbQvfb2EiByIclG5pvoDo+w5mBkcf9o6wDpPunLgMf1q
         alXAHx7hVN+hoOrfkBATuOjiFAucmzxxrY5IMk1nfSD0q+cRIYVYjT8gUt+UowCWxfR9
         8vb3bLckDaKDRotPLlbUo1vQDa3XoloFo1bYalfBeBa5ohiK8AtEfwXUjt1XOesZzJ3Y
         VSyZMX4/xHDWAUH6Y4dOAsTTwVJ8rds5S0JTvNY1EuS5dvdGK6oWYYWe2XLIxnJ9F9l4
         8IocnTBuSKMP0abHKFFL7pcWZoCa9h9h/VnaIIdySx9qJQnEEyZkCGuGQMP96taos1Fm
         CDow==
X-Forwarded-Encrypted: i=1; AJvYcCUVFbbrLjWNR/0nSxXrRm1yaoSmynJj0aV/5Hz5nRpNwc9JX0yOd2p1hIfl9P3soCau7hnDHSHxmm5WyYo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYc0n59WZu+5efrUrRLj+KlS5tnBKWpnWU39X5aeEyQ4UwOsMu
	OPsQu2B+Qbl/Fpc1zBJ2eFB9HkocVFCfamfyuSgiiLugEYXKWVJt5wPE6d1EOjw=
X-Gm-Gg: ASbGnctGUagL7nY7yzXczAV8nycroErxVOyKqo/MBVJcGZcz8DXIyZhV/JfCMeWg8g1
	brhf2yDBbzIsQl15fVcrWG8flnq1pB3DkaP51SAhwyN0e4UYK38awVFBPMkXvxQSIe/41cTkrsj
	z0DfzH88f48n37tRxk8PUD5T8hjU0Texh51mNetbJMwgs9q0dC7lSp+ETjRcAiUMfMGrsR7Vmex
	6h7i5izlHYFmqvzGRAl/olHyuNTrDGRPN1APzl5RsksXUKTVbTBx+DY10F4TXuBXQCcrSw=
X-Google-Smtp-Source: AGHT+IHWTvEbFyBXzG9e8FsP0ij+GiuUSqKpGVu0O1LuszPhiJHSeY0kaqUmQ0J/IbFid0QVoi6aLA==
X-Received: by 2002:a17:906:7951:b0:aa5:a36c:88f0 with SMTP id a640c23a62f3a-aac3378e312mr1546765566b.12.1736024109719;
        Sat, 04 Jan 2025 12:55:09 -0800 (PST)
Received: from krzk-bin.. ([178.197.223.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0eae3a7bsm2050315466b.83.2025.01.04.12.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2025 12:55:08 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH] crypto: bcm - Drop unused setting of local 'ptr' variable
Date: Sat,  4 Jan 2025 21:55:02 +0100
Message-ID: <20250104205502.184869-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

spum_cipher_req_init() assigns 'spu_hdr' to local 'ptr' variable and
later increments 'ptr' over specific fields like it was meant to point
to pieces of message for some purpose.  However the code does not read
'ptr' at all thus this entire iteration over 'spu_hdr' seams pointless.

Reported by clang W=1 build:

  drivers/crypto/bcm/spu.c:839:6: error: variable 'ptr' set but not used [-Werror,-Wunused-but-set-variable]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/crypto/bcm/spu.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/crypto/bcm/spu.c b/drivers/crypto/bcm/spu.c
index 6283e8c6d51d..86c227caa722 100644
--- a/drivers/crypto/bcm/spu.c
+++ b/drivers/crypto/bcm/spu.c
@@ -836,7 +836,6 @@ u16 spum_cipher_req_init(u8 *spu_hdr, struct spu_cipher_parms *cipher_parms)
 	u32 cipher_bits = 0;
 	u32 ecf_bits = 0;
 	u8 sctx_words = 0;
-	u8 *ptr = spu_hdr;
 
 	flow_log("%s()\n", __func__);
 	flow_log("  cipher alg:%u mode:%u type %u\n", cipher_parms->alg,
@@ -847,7 +846,6 @@ u16 spum_cipher_req_init(u8 *spu_hdr, struct spu_cipher_parms *cipher_parms)
 
 	/* starting out: zero the header (plus some) */
 	memset(spu_hdr, 0, sizeof(struct SPUHEADER));
-	ptr += sizeof(struct SPUHEADER);
 
 	/* format master header word */
 	/* Do not set the next bit even though the datasheet says to */
@@ -861,10 +859,8 @@ u16 spum_cipher_req_init(u8 *spu_hdr, struct spu_cipher_parms *cipher_parms)
 
 	/* copy the encryption keys in the SAD entry */
 	if (cipher_parms->alg) {
-		if (cipher_parms->key_len) {
-			ptr += cipher_parms->key_len;
+		if (cipher_parms->key_len)
 			sctx_words += cipher_parms->key_len / 4;
-		}
 
 		/*
 		 * if encrypting then set IV size, use SCTX IV unless no IV
@@ -873,7 +869,6 @@ u16 spum_cipher_req_init(u8 *spu_hdr, struct spu_cipher_parms *cipher_parms)
 		if (cipher_parms->iv_len) {
 			/* Use SCTX IV */
 			ecf_bits |= SCTX_IV;
-			ptr += cipher_parms->iv_len;
 			sctx_words += cipher_parms->iv_len / 4;
 		}
 	}
-- 
2.43.0

