Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242713;
	b=Z0DgkvPpz+71K9vX+oBBlfEYvdrFvPfvcMq3YKwPD6/RkqEZ4NitL5dCbwdyPSiU8nBG
	 CDezoGf6j5b556mWq+guTh2obhK2bMBqWmnHSXQ1XGmLHJYs6dx+D81rOwVsCq53jUC39
	 pAV4/fHZw2z4PYlbYDolC1Tq+G8Ce8NUAhUXrqCUwlLrvWUPN025crGKTZ3Wy/zIAfEaM
	 O1B7q6M4MiS/WhDSti8kZApycUFW8WLt9G3A9k+JfMmUF+/fMXnXeiwnreQeigQuspVnk
	 EdDP2u2S4KDoXNsD7xNHJ+/XqZFd0SOdQCEBWAFawY6PR95alsvHoZ0IYhaFy1g6o0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242713;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding;
	bh=FpiqRag+t5NMeuB2lpRlUMa7TgFo9C0tjAPeji60Tuw=;
	b=3p3AJTk3XvKW/+9EzOfvOcNPbl63oJm264j/tbtur5goEHk9l45FYYaSgl6BucKDgZW+
	 SMb2E9jfS8gTRbk5Qz+nUBjGvP65WPzD9/oxx69LWN9AAMezaoiehRT5dAitP2+Ho9/+f
	 qltN2vNUEuXBcQPzARZUoghuLaT3ZTWVVOxRaSxASjOW5qkNUNXZIV3hrL+I2hiYTWwHq
	 wIAqXTWVLBASfwjkz1O2Rp+AV9qZ1ZlJ3TiE9b824lUaXRrsq46xtC91ylONvl5sQx8oP
	 wFpi97mODjYe8EnY3JxcSFbN8JJCTouvLSXBKM9/ZmzWgbA9QOsqacF/6ZbcyjTE6jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=baylibre.com;
	spf=pass smtp.mailfrom=baylibre.com;
	dkim=pass header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=VXFKdTKz;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1942606EEBB
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 16:45:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1942606EEBB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=VXFKdTKz
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a35db1f202so8846565e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 09 Nov 2026 08:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1794242710; x=1794847510; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FpiqRag+t5NMeuB2lpRlUMa7TgFo9C0tjAPeji60Tuw=;
        b=VXFKdTKzLxsYhDA5qSpvAW+aSF7XTfB5oaoxy/4AIoO/UuHMCYEnagcVKNgxFLofs9
         cYyOIpNObI9HlAPGHkG7U8tFkFTd5uoEaI88h84+vq6OaCx/yrXGM156bEbm3L/hKSNp
         4LnNXjZ5smFgmflZkLwQ8orIQADyyr56pXKBQTAid4qnfrlo6mE8ExaCMiizG8I+9Iuj
         M4JpQyiU24Oen0O6GQ80Refeh0QrUjS3bQ0hfioLoZL8+VUtCa5SizFiHd2RaHrgsMQQ
         42ozsFQM5BaYjXEn1VBcuSj6lCYDZJH3X2XrzbkA/x8y5qgXNf0D9GT0o1YvGELWYaIw
         wz2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242710; x=1794847510;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FpiqRag+t5NMeuB2lpRlUMa7TgFo9C0tjAPeji60Tuw=;
        b=xOrqHZmeb5yyKKkd0tjdQag7fG4WZ24YLzFqia++6RL/8peYsiv2vxqtRNy2Ky6i0Z
         LeqI0zXxiHvuvivocXXc9yf6KsnD7wEVZu27u5J7vH2hvgAD7YLleDJ1jKo+WZzn19gg
         goPH20uDOvS4b/FVe1X/cJ91WZJpsgIwmN2fbnOZZfCev8XbjmbmaPj1B4r5cg0gKo/u
         xkFc8OSpU0ZDKk1CsPmPplfzpq6WsM19E8VO7kSHNKH8VzVzXVZaZmCqP5TkIcjwHexo
         iDOpO5R4efYbqAnrRQMhLoVk6SiFFcAuWMC3IDNZB41qoVYdLGDQGSM/iMiv8dgzFY7d
         esPQ==
X-Forwarded-Encrypted: i=1; AL+hErFc7l5U4y0PTiGlrOlMGUaVDR2GJumr4KW1Sy3cufBp7U4WX+nKbiH6xwhH2wQXRGV86Lkgs5odrLKwQjk=@vger.kernel.org
X-Gm-Message-State: APuU4Z+Ewui8GbThvkqpxmK5a9krrNrTQRJO2UKBQ2QKmmHcK8soF1A4
	QcGYKDXaIv/rUc1V/ssqFMBOo+fcMctFktzEHcC96AOYCvO5y5iQRTqZlpaRxWhzAtg=
X-Gm-Gg: AYBFou2DeL16N5DYKUzO3QfqqLv1+W8I2JE0VCGfdOjgTOaabij6tGyoISJ1nXzoIHY
	y8op5AbcK0HG/y0EiOsq2cFAAl8pUoQuPoWM8RSn3BRvjH7qscI5EDasg1PlpKF1wvtFxCC0gsY
	yWZqVPec5VxLqVry9OZC/AlaP2twPJMGd8HGLznS8k4sAxTBLcV66vZaZrhTQIbNqXNOMoyfI4J
	N7lz7Nzalhr1758pGCoSSQ6WYcaiEjbLCiRWNO6ZnbnkbYKw9EQUh9cBq3gXsx5/YJ1vhoFFfiH
	eJsqCILVdAxxiefAhNCZtka0qChkgqDzW5zyYG1gOzAyHheJcwCgvQ6J3issHwje1YgEJEH8tTi
	ZVJLpliP+FlyZqjiszeFCkTAO2ZdO4zZ8EaFmjeWTiryj4+vBvr07XOYCMskrG6XFpBCYwRLp7H
	0GS+YunK3MLnX2NBYQ+zwScjGEpDxt191sMPgoKDLUFZ26Ird9jSYMX3gnGQIkAMhITQ5sJoBhk
	IwWyQvmgs8/2i2cR+eTVOYp1tbvKmDKeaQeY9CPc7T4yRrRNCb0O+SWuZ2NkTiqr747h/CVE7mo
	fCql6Pj6UZ9f9OGbqDEr2smjpQoEKJctD2G05cEpmrOZMZ9XPuGm0q5aBhDd92iLBFBZ1nDE89S
	Yg+wwYVhTHsRH0E4=
X-Received: by 2002:a05:600c:524e:b0:4a2:a9:ed5a with SMTP id 5b1f17b1804b1-4b960d9bb10mr93175615e9.8.1794242710297;
        Mon, 09 Nov 2026 08:45:10 -0800 (PST)
Received: from localhost (p200300f65f19a90407b2ef73b14b6bb2.dip0.t-ipconnect.de. [2003:f6:5f19:a904:7b2:ef73:b14b:6bb2])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4ba01fd4754sm31615e9.14.2026.11.09.08.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:45:09 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH] crypto: arm64/ghash - Reduce boilerplate
Date: Mon,  9 Nov 2026 17:45:02 +0100
Message-ID: <20261109164502.905237-2-u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1360; i=u.kleine-koenig@baylibre.com; h=from:subject; bh=lwNvkM6qvpzuHSc2uxsQlZKF+Oa7f9Zznr3rNlsBfkw=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBq8fiOhLsVtaX8XKYIBfS3FUGU/riART+vS/RBv A9nIr0wO2KJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCavH4jgAKCRCPgPtYfRL+ TpTOB/4iYigJ1++vAX+4XjRUWiW7t8/QF1Sf4+OyChwtX9F3aj6GbFEfjaKvJm38H6aHRz2Aa7N Y6ZW6pauYylv9qcXXfvok/8pgyVl+xFLtFO/zTHoWX/YvVJY9/ZsTM5zlY/mMWEXN2+BAG77IW+ LKE6AiHwW7xzZptaXmmoMuXIXiNva/rA3DrBY2Dfg2qWz8ZRqZ/JtfvGsTtOLiMjivFNE2PjvZ8 mAUqistuSWJ8FGFy/G5fXhNbBJVHn75a5KxTwduap49quV9prrXGmfGeJ2dyqB6khpQXynj+vPD KTnm/FZqcM1j5iSX9zvSyyUc20Y+2SU9FFBmoWU4oa2y+Has
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

Make use of module_cpu_feature_match() which expands to nearly the code
that is typed out.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 arch/arm64/crypto/ghash-ce-glue.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index eaf2932ceaf5..0884f812a315 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -384,7 +384,8 @@ static struct aead_alg gcm_aes_algs[] = {{
 
 static int __init ghash_ce_mod_init(void)
 {
-	if (!cpu_have_named_feature(ASIMD) || !cpu_have_named_feature(PMULL))
+	/* ASIMD is implied by PMULL, but better be safe than sorry */
+	if (!cpu_have_named_feature(ASIMD))
 		return -ENODEV;
 
 	return crypto_register_aeads(gcm_aes_algs, ARRAY_SIZE(gcm_aes_algs));
@@ -395,10 +396,5 @@ static void __exit ghash_ce_mod_exit(void)
 	crypto_unregister_aeads(gcm_aes_algs, ARRAY_SIZE(gcm_aes_algs));
 }
 
-static const struct cpu_feature __maybe_unused ghash_cpu_feature[] = {
-	{ cpu_feature(PMULL) }, { }
-};
-MODULE_DEVICE_TABLE(cpu, ghash_cpu_feature);
-
-module_init(ghash_ce_mod_init);
+module_cpu_feature_match(PMULL, ghash_ce_mod_init);
 module_exit(ghash_ce_mod_exit);

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0.rc1

