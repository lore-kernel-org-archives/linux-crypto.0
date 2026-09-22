Received: from mail-pj2-f18.google.com (mail-pj2-f18.google.com [74.125.227.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B813B840F
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 03:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790047253; cv=none; b=JnDOU0uAQpL1oZ8SjJ+kCWvIr2atNzGGdDOVpvQq7rgKn6S63L0ZpR4zLkMj3C/Rga6mWLBIJ2gtvD/a9wjX4H91673uTaQRo1whmZ5WgfwtMTvCi/cG4J7h9vqI1MvN5JU24Vqqf6sCp6n0FP77ov63Xd7mFFgteICreZ9K4O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790047253; c=relaxed/simple;
	bh=8A5lbFX7jPgNjHXFUP9sZMZQ7/uPse/Wza7yZTZRNrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPJH3+I9K5raVTFgdsKm8CAcqxuZAq6BAj2SbxmLWyOjMjIl0E7ZKOKsKfLo3wEMStFBdesG3BflDBAWbONEon9feWe++oIJniFpZXIXPV4Ac8KEJy3JBa0HpqzOjWaghYCQbMeRpK56m5FyVg1pe+tBdPmASG00tebbf72NLb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=saR23UYN; arc=none smtp.client-ip=74.125.227.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="saR23UYN"
Received: by mail-pj2-f18.google.com with SMTP id d9443c01a7336-2db22383fe8so23782555ad.2
        for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 20:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790047251; x=1790652051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z7TxIVacK4CiPP85Zm/zWINHMIm3Lw/0BaBVswTN6EM=;
        b=saR23UYN3c0RdK3S66u8CN3exUVRu1tP7W2bqD8sH//ynzAe/N33XR0vvct88asD6d
         Rg27ndt4TrgdKIi3nZzQRuxXosiKyrgugbHtXzPPfyPp1llMHFhUBnRwAf0Jrio8kFf9
         IVz5UL2i/Xlxqw2PAoPyNZ7jtJGxt88R13Sy7pljP8G8a3Iq2cGj0PBnt8ro4Ih6Ik2w
         XHXg8VbqZIxQBtzdMOIbpWFPgWSCAghE0uGXeRwr6fdI6d1Cm+OtmKGUfpvrP7hIMKvp
         xREJL60U5hqPLo5uKt1SfqZE35Iv4lOw+UD3W6r8/uMlWjkoiXz2xhHp+cdTQeZhMqKE
         G0qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790047251; x=1790652051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z7TxIVacK4CiPP85Zm/zWINHMIm3Lw/0BaBVswTN6EM=;
        b=j0yl/2SPgW+Z89iJmfKgivJ5Yxm02Bks/faQ7XpV028JZTA3sdm2M1eyWDKMlQ2R6y
         FsIHC0fojJPSxkiJRLP8VlE0zKOTZ1AlLKp6u4N3GAbX2vKm+6xs3e/EJUl0jsWS53l4
         iPQogoOdPLh6GYdyyySL5Cx4MryEV+Qvn/KqE01Fx7M3qkLQOq2qFHzbRVygKJ3UIXw7
         nmfM1ThVdDqG3tddoB5gdAB9yIIvKGTgInmcATPQ0taos5v8NWALRgB+UZLuJva+PgfW
         HvHuqPPrBDPXGh6STAKksYHBYfFgyGLF7AVsLrc5ZZ9aw9YNulBKcNAKajCguSUEhaPX
         SS6Q==
X-Forwarded-Encrypted: i=1; AKwUvBw6a81ELtskFpraPPVjig04PGl455dBCX5e7ihiweBk+0u+RrIu5L83j5zWNHksSruiuHcyLp3Ue+wWhEA=@vger.kernel.org
X-Gm-Message-State: AFuF++nKapr3PC9mbPnyeRzkQj8OyzBmulwlZMCXDd4hQYo/wwgmjntx
	Mzkm/SFwPs/jSSo5lkwvoCX84XSqwDNK45IF4PqrUkjxUnQg68ZGlnkH
X-Gm-Gg: AYBFou0YKpknbSLFtyP2PWGFAyBIfwzk8/3eC+wPB+dWFADERoo7DZLTF3RKzyokwPs
	5ZLrOg/Xx1+yc//CPexF/u1h30z6JAajeWGQ515xbFp2mQeJA+ksXjaUWAlypNk+cwsm1akA7my
	hERfDMZF0UYujOdicyt4IhzwsRICLMwHHx8izIg+dj7+c1VjU5d+5rW5cpn5ycXSZqE5wahgMnZ
	HVsa8VKPD8r0U9AZhbQTUiD2+aqm5IFszWMKYun3k6mYAYWuSgLpG0Hj5I/ojDAmDnTh44X8GMz
	fcE97gyIuCBDj79NjfsZLJgJIsysQOBR0F4aDXxvuZulhQQUBENvQ7zuXLCzDYQyZTGXcxJnfn2
	FUlyYrqHtHBbgqUOANzXsTli8NAQLakkfO7KJzniOcbtVmRWODAS9JxYGVc1zmP4Er+Wq5cRH+Q
	ygdxknRTkF17or2r+JtmIypzi4NetwPYw2u1BVT6He/jox1pV9o2J3sgtnZEBlRSR+P/jvgMHa6
	vWCccN1jypF2TlAL8O29oUQWndv97puPwDk+KcKIHTsL9MH9Ql6Ya6ca/xO8pcD7q2cDZtVyd4i
	4gx5KNWEGpmjZJmGQZA6BJTh
X-Received: by 2002:a17:903:b84:b0:2dd:c053:82fa with SMTP id d9443c01a7336-2ddc053843cmr122847195ad.49.1790047250783;
        Mon, 21 Sep 2026 20:20:50 -0700 (PDT)
Received: from phuc-desktop.. ([183.91.15.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df5cf83512sm1940355ad.5.2026.09.21.20.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 20:20:50 -0700 (PDT)
From: phucduc.bui@gmail.com
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Gilad Ben-Yossef <gilad@benyossef.com>,
	Hans Ulli Kroll <ulli.kroll@googlemail.com>,
	Linus Walleij <linusw@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	bui duc phuc <phucduc.bui@gmail.com>
Subject: [PATCH 3/3] crypto: sl3516 - Use pm_runtime_resume_and_get()
Date: Tue, 22 Sep 2026 10:19:54 +0700
Message-ID: <20260922031954.320895-4-phucduc.bui@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922031954.320895-1-phucduc.bui@gmail.com>
References: <20260922031954.320895-1-phucduc.bui@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: bui duc phuc <phucduc.bui@gmail.com>

Replace the open-coded pm_runtime_get_sync() + pm_runtime_put_noidle()
error handling pattern with pm_runtime_resume_and_get(), which already
does this internally.

No functional change.

Found by manual code inspection.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
---
 drivers/crypto/gemini/sl3516-ce-cipher.c | 3 +--
 drivers/crypto/gemini/sl3516-ce-rng.c    | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/gemini/sl3516-ce-cipher.c b/drivers/crypto/gemini/sl3516-ce-cipher.c
index 02ec4282333b..eba46aebf176 100644
--- a/drivers/crypto/gemini/sl3516-ce-cipher.c
+++ b/drivers/crypto/gemini/sl3516-ce-cipher.c
@@ -331,13 +331,12 @@ int sl3516_ce_cipher_init(struct crypto_tfm *tfm)
 		 crypto_tfm_alg_driver_name(&sktfm->base),
 		 crypto_tfm_alg_driver_name(crypto_skcipher_tfm(op->fallback_tfm)));
 
-	err = pm_runtime_get_sync(op->ce->dev);
+	err = pm_runtime_resume_and_get(op->ce->dev);
 	if (err < 0)
 		goto error_pm;
 
 	return 0;
 error_pm:
-	pm_runtime_put_noidle(op->ce->dev);
 	crypto_free_skcipher(op->fallback_tfm);
 	return err;
 }
diff --git a/drivers/crypto/gemini/sl3516-ce-rng.c b/drivers/crypto/gemini/sl3516-ce-rng.c
index 76931ec1cec5..19af03b03e42 100644
--- a/drivers/crypto/gemini/sl3516-ce-rng.c
+++ b/drivers/crypto/gemini/sl3516-ce-rng.c
@@ -24,11 +24,9 @@ static int sl3516_ce_rng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 	ce->hwrng_stat_bytes += max;
 #endif
 
-	err = pm_runtime_get_sync(ce->dev);
-	if (err < 0) {
-		pm_runtime_put_noidle(ce->dev);
+	err = pm_runtime_resume_and_get(ce->dev);
+	if (err < 0)
 		return err;
-	}
 
 	while (read < max) {
 		*data = readl(ce->base + IPSEC_RAND_NUM_REG);
-- 
2.43.0

