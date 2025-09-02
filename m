Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90A2307AD9;
	Tue,  2 Sep 2025 13:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819382; cv=none; b=fbakiIRQfSTb6Qs2kps0NJIfxrYeyFByx7yq8qesydsOXE+oQN+q4hBvVuLeWRChtcU6DQhKL6qDudy7Y6X4ksVIXahWDLioQLAkkdgR69FHMdQZbwTIVvMSTVZdHf1C44loroRYvxgB+87ePd9A4tV3j7/TSHQcYW2bz34jkhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819382; c=relaxed/simple;
	bh=bsrtN/UNG9iIkOTFtbf/aBs98lsRgQ3mXT6PfL4G5aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOvW11vfMprElTNdPf7g0/pH1RzXm4NfZAga3s/juyVToghn3mqOfbTQ5R68A0h0JugbLnjbYgQMRT92DmZ8XNts+aIcPhEe27jE2kGqEUlUINkeKZ9NCou36PosLD2sit7u8SoDplsqy5fVCmecAXgf21A0CR+uspL9wdoSZ2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iyc8CGur; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iyc8CGur"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45b9853e630so6923235e9.0;
        Tue, 02 Sep 2025 06:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756819379; x=1757424179; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9SQo1VWDa8L0gOXuwTFV8cUa7G4/T2C+1QUOVeEgYOo=;
        b=Iyc8CGuroWsrMSaMLQhZ5TaIC7kdOWeM1BzXtA0KMuXkgWknQuUMJ3Ot9tFnMEbhje
         ifDT5yh2jcC/rhboUSdZDKkFocyEtH5/P6Ra0Ok2xiZAR1lnadPdnlg6YaXD1V6eQiXE
         hFpNxYf5Lf64cvDKwKXKOzLDPu0K5jPSOlaX3XrQfwGPr4yduORaHGGlzmhXx2e285ip
         Rle9bfiM/lKHNpoBOr0ljNsV0AlMinUCVvJYGCwZC+/9ZC3UJV23Avhapt+wkNkjqXCH
         Cu1JGd3NUtMFz6V01PvZuhGGeBVsox5LO4Tc+wlR6Zv7A+18HyaZkgwtcF87sXf6fx4/
         4jLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756819379; x=1757424179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9SQo1VWDa8L0gOXuwTFV8cUa7G4/T2C+1QUOVeEgYOo=;
        b=tkeEcwPBtlV0y9PzEIk5lgZi51D+zqisBxgA938ZCvb4NazzLY2nC30TG/K8/687Iq
         cK7byAdJzLeqkFRVMBfHckGuonhsChvcIKYWpJoylauyFjrvGxwQfBsnJE1qOpXChG7+
         fAhU3q2f1PNK7+hzUkiKtN49JMeOOiiw+ScPoakNqY2WY7aVgx5GsTgldLathFVCPqN0
         9+/iAXMTxnxKG99wLA7Uw7MGERw1NoVGxAYXLUx9ukXIJuxQuu+Qz2lJvr0GWlt9idlP
         IyZHk5K/B356bd2w6wTBszdl4aUisQj9ghqoeJrfDwHaUCLKKkX10JnidqUHeD8QAiJk
         zLnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmZgYFqXVNYFdtgyzm7iTQHU60f3XecY5qG1cgP0U2wFIOqkXdi94n7rjc+pH7TZPdiQ9Jy6+BvHkVOM8=@vger.kernel.org, AJvYcCXcnMTlBgkhnelRJeQP6JE/v3DXcOkFNPmbs9t82rXcUmaDhk88fIcxxa92Y1SHuKQsxEkrA4ZAbrn8QCqd@vger.kernel.org
X-Gm-Message-State: AOJu0YxB/dB+mhjFLKhr9CKjK+LvQHYWk+nbiosPlc/WvO3plxRsCpow
	ZyzsH+PrjFQKDemr7710aCWRa/++ClXrXXm53y3h+WEDSivQaGxRQRGM
X-Gm-Gg: ASbGncuw6FXx9Dl8N+DnFE6KnevBl8lRhe0ufyLlNJD+17V1n8ValND2b2Dm2KhBOy2
	f8scMfI3BKNBUjDzzd5377jzVTZgL3ryRONMnf9cJzp43hfpncp8KMCGN3sXO9GF3ZzZvUHDEno
	kBgPgDuiGWH/qTV893NLQqTPL9mp535UP8ePmXmxd+BArLKPg9TLWSy8aKqcbU/g/JpOLRppDX5
	iAEWmRsHdLzwNA3S0q0RxE/A5owUhVu1jL10XUhy+fHwhZ6b4MkquWW/8ADXIvpqb/o15BDj6CG
	dy9DZsld9UsCbUdugVhCHnyGlnCnRI801/9lEKy2AJnQt7bCMGqKBW4hFgP4l9KCp9RgrTt7ls8
	5sp0BUyLJ2e3OCwSqM7hoO8zLvDOQzRCBUw==
X-Google-Smtp-Source: AGHT+IFCIE32gRqXCK2cxP5jJ0umVullIbqtBAeMOiAN/1dBA/vOuBTNpHuGFamrKvDjEfmo1r30gg==
X-Received: by 2002:a05:600c:1e87:b0:45b:47e1:f5fe with SMTP id 5b1f17b1804b1-45b855c0d3dmr80790615e9.34.1756819378791;
        Tue, 02 Sep 2025 06:22:58 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:c207:b600:978:f6fa:583e:b091])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b945332adsm44452155e9.4.2025.09.02.06.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 06:22:58 -0700 (PDT)
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
Subject: [PATCH v3 3/9] crypto: sun8i-ce - remove unnecessary __maybe_unused annotations
Date: Tue,  2 Sep 2025 16:21:28 +0300
Message-ID: <20250902132134.3287515-4-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250902132134.3287515-1-ovidiu.panait.oss@gmail.com>
References: <20250902132134.3287515-1-ovidiu.panait.oss@gmail.com>
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

