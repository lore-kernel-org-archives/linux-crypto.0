Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2B01F4617;
	Sun,  3 Aug 2025 19:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754248268; cv=none; b=Pw8JxCO/75wLY5KgV3PH5E4TD83ZaxQgpClejbHGe9Rd19I66eRlBBanCYsMJlgNrwIrRA+weIkRWoCCnbd1I6vS5hWz81K6UhukMxYbOlSuXlg2TqWZBvP7lL5bsh5CE4lbtJf+xvQExpOnIiOX9Imj3MYOxAYqVwYZy1S2/mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754248268; c=relaxed/simple;
	bh=bsrtN/UNG9iIkOTFtbf/aBs98lsRgQ3mXT6PfL4G5aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBEZXQKFv8HNv/KsMwJULwW9tYyoE77ErpkUow/0SIhR5Cv7iTZK9QCKGlj7IBUKcRaNB7Gm5wn0U/ptb31p+MFSkzUpSlqZMYOJGNUq1F3yKVPjo1ogNNPtBs66HHIkYbmN1FkdPzDzOGLY1MCKVJDXrsuGhMdsGBcTjpWlALY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N5hJJtBO; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N5hJJtBO"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3b8d0f1fb49so1751205f8f.2;
        Sun, 03 Aug 2025 12:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754248266; x=1754853066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9SQo1VWDa8L0gOXuwTFV8cUa7G4/T2C+1QUOVeEgYOo=;
        b=N5hJJtBOxSPXciwE78Cav4PEeI8lySy5i909p5TfFeTOTpiAzcJTQ45lcyBXvFMlX0
         931y1+pcUpLZd0naK3zl+XMf5y4Ueor+9w0el8k9Np9cPLQ/a9IKrQSaRfRVrBJ7r1f1
         ckQ6OgDrGtbuH5BiuSfLTPQXwDqMqMHjFFMg5wgcIcFXf85kRIa+udeflFigs2TihOoK
         SAcLKEjHbV7Cr9vkveWD1Zz1sOQw2D2Gm1as6w8biT6PJH/OIkEhqJ9pvTxmjdHtOfYf
         JPcq8cPrX+H8VE5CdTtgfJUfMWFkfff48nSw00il5izr4MIIjgo5HX7+5S1JjiHHBo5l
         smSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754248266; x=1754853066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9SQo1VWDa8L0gOXuwTFV8cUa7G4/T2C+1QUOVeEgYOo=;
        b=RG6KH11pPtLqthqsvIXQy/q2vt9AF1Quo+7R5i7uJymNbs6JBbt3S45rDfs9gA+IqU
         0AYUvBD8iAgWudheDTRYfpvWPYiwLUAI9sC5gEDs/s7eOiXV9N0++iMPxkr//bNp79ld
         AuZ8483bAVgNXiC1g4hGzH/C3Rk8cu3GG+66WfTnixIxg0ye/gOPHaAXPOyhxUrIb/VT
         6jTUUSWxXQ1CJPAJuVJkdy+EaEC94RsZZ92HziThecM1rLabMuaXHA/Q7+7Ui92dGWdr
         x6jdMNToi7KxXODb4ycHkhJ/t9sx8YiCm0SbfiF+yLvaRbQD4tMq+eisv/WOTudGjT24
         1d0w==
X-Forwarded-Encrypted: i=1; AJvYcCVuFHGf6SFXCyBJElznuZLNe4RbXQhHEYEirlXFMCfuxGggo0KVdbrZp61xuozZQHWl1Lvua7mtAGriM7c=@vger.kernel.org, AJvYcCXHBNKNN7BuJ/i2iCrDB4D63xs8a/VFeBBzJnzcwAqzJZ0TcSKKvtSbAyzQwzPAuIRO6NRIRg+YZyF82hBn@vger.kernel.org
X-Gm-Message-State: AOJu0YwgO9yAeuH8/aWzhJRy1p9s/TURmWirCDbA0WpnGadYGmknxs6l
	V29gALiykSiAxtP91D0Opt8sS7iBXxu27oAApxZgzo7480nH0gjMGWz1
X-Gm-Gg: ASbGncsBpph7IJOFLVMmFCkiUUvu8oMhzW/heBptM+6KrSnNotEpOzUbO7qzwi2Eqz3
	YzOMF9mzKZT6s35zM9xpGyO/MVb5KeOAAp0S2eZYstPBJdl+rs0cFothKduPLOm6SWv80yw/ZA4
	KYBajgqsOCxUEnn6Nn7RTV3Wv0NvIjT0fDrBtSqqvrJ+4YG7k2Whvw+nIRyTfKXUiKofGDaLaYB
	SxlooCCeQrg56u07/sswx3o7qz1mL/4DtBvEuc7v83crGgZuyLTbqZcAP+KaoLof/NAEiVTvVKy
	Z/798GBoacj6PADY49s4aWOav6GbPRMrviuAr+43vTa6x49JL8YX6EihGF+ux0ByPMb7/b9alHZ
	U6akzu8EdLKhdGs9b3ae25h3LVnkuuWc6Rg==
X-Google-Smtp-Source: AGHT+IGAkLXj89d8+BSh3EqnA4GVIsKBPznnVnW8s4SI6ImldpUHqZ4tb20/Ec2WyIE1Q5fljBDFvA==
X-Received: by 2002:a5d:584e:0:b0:3a4:dfc2:bb60 with SMTP id ffacd0b85a97d-3b8d9481972mr4970990f8f.26.1754248265452;
        Sun, 03 Aug 2025 12:11:05 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:ca0d:f700:1210:b727:adc8:716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c45346asm13099210f8f.39.2025.08.03.12.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Aug 2025 12:11:05 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: clabbe.montjoie@gmail.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Cc: wens@csie.org,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH v2 3/9] crypto: sun8i-ce - remove unnecessary __maybe_unused annotations
Date: Sun,  3 Aug 2025 22:10:23 +0300
Message-ID: <20250803191029.3592987-4-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250803191029.3592987-1-ovidiu.panait.oss@gmail.com>
References: <20250803191029.3592987-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are 3 instances of '__maybe_unused' annotations that are not needed,
as the variables are always used, so remove them.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c   | 2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 113a1100f2ae..c57c64a1a388 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -111,7 +111,7 @@ static int sun8i_ce_cipher_fallback(struct skcipher_request *areq)
 
 	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)) {
 		struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
-		struct sun8i_ce_alg_template *algt __maybe_unused;
+		struct sun8i_ce_alg_template *algt;
 
 		algt = container_of(alg, struct sun8i_ce_alg_template,
 				    alg.skcipher.base);
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 79ec172e5c99..ba30859e749c 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -1062,7 +1062,7 @@ static int sun8i_ce_probe(struct platform_device *pdev)
 	pm_runtime_put_sync(ce->dev);
 
 	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)) {
-		struct dentry *dbgfs_dir __maybe_unused;
+		struct dentry *dbgfs_dir;
 		struct dentry *dbgfs_stats __maybe_unused;
 
 		/* Ignore error of debugfs */
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 61e8d968fdcc..df2acef9c679 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -26,7 +26,7 @@
 static void sun8i_ce_hash_stat_fb_inc(struct crypto_ahash *tfm)
 {
 	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)) {
-		struct sun8i_ce_alg_template *algt __maybe_unused;
+		struct sun8i_ce_alg_template *algt;
 		struct ahash_alg *alg = crypto_ahash_alg(tfm);
 
 		algt = container_of(alg, struct sun8i_ce_alg_template,
-- 
2.50.0

