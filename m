Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795430440;
	b=LwmMaAt/xIyaLyQU+o85ueoTQyKWy91p5PMvD7zkIE/y49llXFFTYOSho7Y6HxD329NZ
	 br7XkVDbernbNYmu6lCz71hiO4Hj6FUCaAhGi3/2Rnb8P/uOlWtuNbNlmpMiVBqKd2ZVT
	 +N6OfLWEq0tgIioEEiJutXZgnlOTvOr0X9uLcWz8HxSJaLfJJv+ejbe3VrlHKzDPjvOl3
	 rVr5VSEbrz+JQwziGf1XIkyyk3C+u2TApRBBt4piMpDvkqA/QL1BLhIK6UJkmAI/eBJ5u
	 AO2qVV6zf3mmkNUuq8Q6zzbQRjNUvBgmPuocLhr3ef/+49q//pVf2C040DMTzFWDxGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795430440;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=AoHPrlw7cHKhLG/2C7Mmh2Ph3LLuU0qyTHH6DFLMjMo=;
	b=2yMlUAFuQgCiR6pgNqIfd6iSM8O9mxmsnTwisWTcmnCig6IpwoZaqxEwFCiyfCPH1R0q
	 NZOBoNOFt/qnSmpPmWn2ilTWOkkDuJGoURH0e6PJxZIym+M+zYNgSy8H41UoCbuqV5R+I
	 qaK14p133xNkRfQzlm6FWsdmNAHm1EUE+K3eOLZlsiggTKYS+Ii6q0Qyl33FFy9ECko2s
	 K4XqVVbH+l9lRydXyNkcHfcWIigeyqgKbXKq+qkIvbHdzFWMGp/ZaiAC7vfNmLtRMHgSf
	 jufSKJ9HR7t/RHAd2/+GyAFn5IWIYmjQwXKWvnHjoc2hG5nYSJsA5lE+iYJCWdeFGaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NU2bShVh;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70890606A31E
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 10:40:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70890606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NU2bShVh
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-3863db981d4so4131179eec.0
        for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 02:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795430438; x=1796035238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AoHPrlw7cHKhLG/2C7Mmh2Ph3LLuU0qyTHH6DFLMjMo=;
        b=NU2bShVh8f3IRVK7GpGP4qsoxe22YPQwXZ+v4H0IRPaSgkaZOgGQJUXyJHLqCZ35G4
         l+IqmDevDc5dPwt8wNEi42LmqwP0qHx4lI35uza0O82UgzpHYF7cBMIT5r27eaU9LaHE
         2OtU332J8V5USXOsLDK0qBJnY8ey6XonX4tf2QwSlGw4o2gKZaXojrUXGnlbaa+IOrS/
         ea+OqRDFX94Zb+nVXysPRSKS9rUXY6euIlQTyzhDSy2c1wJtec6k5ZRiG8t21qJZjKFQ
         FY3uCxmi80rw6H26Jib2w3LHA6R3OYW8OPoH4ZW3iHJNMlYpajb08PyFpXk7+49tXb6u
         wyZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795430438; x=1796035238;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AoHPrlw7cHKhLG/2C7Mmh2Ph3LLuU0qyTHH6DFLMjMo=;
        b=Naj0KHI6qvRIxgAg1rgyL8E6Ff2/OofZqmhqBjFc6tUJ2ryRX7Vn+3NGUs36WXueIH
         jMldAxSUNtqwBCEHn4CuUNFUcfA0YrgZ8b10iE6NsvpDLQr0p+jBWeEFCr3D7k2EQzGz
         VWkT91HSEJlvEAgQIYMVpQu9WX+aP7MQzeF5uRpNyqWatOgJDcA2DNgUFlU0Sv0un7/l
         i6paSkng42VOdn2doOxZmt5uUa6NZ24AMyOOaBbRUT2hGzBxQN1vWLOydvoymFdXyXV4
         t7uEc4a4TXPvNbzhQz7M8K5gE6aiQTetHWuJBGHzJIoHYAYAqCAhncKPIFaVrj/RIxn0
         +EAA==
X-Gm-Message-State: APuU4Z9zGWCajF661s5YsEKnLfVo5HJ8ukmrSsq/H32nj/01O+5E01if
	1ExlSh7JJjOMIdfZxPhoNmPeHtwnouyUc/LJfjVJSNZNI15q3iBfXn2n
X-Gm-Gg: AZFdTZeCmFC+DveH4xEwzOoUSHJYDFI8hwoIo/+tuYl4ROMriDnExYAJZuoWrtykEAP
	VoaTVQNBW2Gs6+SdxFDN1HAWATYTHlhEp8zqd3jVpQd3O62ZVmnvJgZqkZWueZ8J/LooWoMTopl
	yrbmaKfB4uOh5XwfK1jVahy61pKBnIWkH7UT3ewifWBXvT6XKjL+Mtr5yj/Qdz6OOh1Djk1cysp
	CCTFLTfmd3ZOOt74SVeqki/H0FdJkJ/yDIUJZrFG9v1kom1llufUoTlTd8YM2ZOcQ5YfMTIfm8J
	cVeuTkUN9SHWAkAJ8Auag8i4YztypgyJoARSC3TmiAMU38230JkQefA18xFwAniMkYwKiL9TPDv
	gGmYg4k2/dfUq4Fi6eThYB/xchaocUCnNB04NX0yXuzFm+p6FKjYqcldmw9TuM9HFaJOu5AGHZp
	KMiN0nQwcoYZ+snROirOYCgxeRDNml0FX37wSiz5zyoPsOikAlyiSjl3/M4Ou9z8a49W0gX6fcm
	Bc3HM4OzTJhM4k68RnBUb6LLD2Kv/Xj/wgv+f0RxQFg3zVz6KHFoEqbIOOY5YeiISa/cWJrp4am
	PCnjuQI4/jPbFB/zZBimJPmINIUWOEzbjImlV7T7hA0jrQ==
X-Received: by 2002:a05:7300:ff49:b0:36e:b05e:9a74 with SMTP id 5a478bee46e88-38570c30013mr9891055eec.30.1795430438356;
        Mon, 23 Nov 2026 02:40:38 -0800 (PST)
Received: from kernel ([45.251.35.85])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385665f21aesm43882172eec.4.2026.11.23.02.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 02:40:37 -0800 (PST)
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Subject: [PATCH] crypto: xcbc - use init_tfm & exit_tfm instead of cra_int & cra_exit
Date: Mon, 23 Nov 2026 16:10:30 +0530
Message-ID: <20261123104030.5378-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
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

The cra_init and cra_exit fields of struct crypto_alg are deprecated.
Switch to the shash-speicific init_tfm & exit_tfm callbacks, which take
a struct crypto_shash directly.

This also removes (void *) cast of tfm->__crt_alg and the manual
crypto_instance_ctx() conversion and drops a stray semicolon after
xcbc_init_tfm().

No functional change.

Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
 crypto/xcbc.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 6c5f6766fdd6..6bb3cddb391b 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -102,13 +102,14 @@ static int crypto_xcbc_digest_finup(struct shash_desc *pdesc, const u8 *src,
 	return 0;
 }
 
-static int xcbc_init_tfm(struct crypto_tfm *tfm)
+static int xcbc_init_tfm(struct crypto_shash *tfm)
 {
+	struct shash_instance *inst = shash_alg_instance(tfm);
+	struct xcbc_tfm_ctx *ctx = crypto_shash_ctx(tfm);
+	struct crypto_cipher_spawn *spawn;
 	struct crypto_cipher *cipher;
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_cipher_spawn *spawn = crypto_instance_ctx(inst);
-	struct xcbc_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
 
+	spawn = shash_instance_ctx(inst);
 	cipher = crypto_spawn_cipher(spawn);
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
@@ -116,11 +117,11 @@ static int xcbc_init_tfm(struct crypto_tfm *tfm)
 	ctx->child = cipher;
 
 	return 0;
-};
+}
 
-static void xcbc_exit_tfm(struct crypto_tfm *tfm)
+static void xcbc_exit_tfm(struct crypto_shash *tfm)
 {
-	struct xcbc_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct xcbc_tfm_ctx *ctx = crypto_shash_ctx(tfm);
 	crypto_free_cipher(ctx->child);
 }
 
@@ -165,8 +166,8 @@ static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.digestsize = alg->cra_blocksize;
 	inst->alg.descsize = alg->cra_blocksize;
 
-	inst->alg.base.cra_init = xcbc_init_tfm;
-	inst->alg.base.cra_exit = xcbc_exit_tfm;
+	inst->alg.init_tfm = xcbc_init_tfm;
+	inst->alg.exit_tfm = xcbc_exit_tfm;
 
 	inst->alg.init = crypto_xcbc_digest_init;
 	inst->alg.update = crypto_xcbc_digest_update;
-- 
2.53.0

