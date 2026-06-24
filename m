Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB0039C632
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jun 2026 07:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782285761; cv=none; b=Gc2eprKM6AyKhcP/KXMJngUCaBOjhiLgVrRKWcF63C4QYVNrWO+Ln+xeQv2rc2Ahnow/rNGkxVRxBjrYcKC4xX3l+iiSWfNjpDA3PvYir0mILBXNLfKwUue4jZ3DmaR0V3SylwQ1ISqAdhjIybPAV4/gJpv6zzssEpsxvYYGbsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782285761; c=relaxed/simple;
	bh=nwChGcCuC+vu8JXPjj6FLvyF7C+SFBi04eIJ2mILbPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pagHfsqQ1iVGCBywe77DwY0eek0urlcjc+IMH1TckbAZjmHvyGrASygqLC8KUjA6r+dV+sSdInFuxbKZIdGnJcpgOI5alOvWqbWqa9n1fY9qCadpCKwxQaE8t4IwEdn74193lJulGw1LCtaOccBxTeLXi171b+ZR9NCMMiVF62g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mx08zGk9; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mx08zGk9"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-36b9d265355so428166a91.2
        for <linux-crypto@vger.kernel.org>; Wed, 24 Jun 2026 00:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782285758; x=1782890558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZV8Zh7yj1iuS4i7Rrs7iwcE2rMMQ2V1yWPR7/wiPumM=;
        b=mx08zGk9DnbWxP57HbX5Ac2dluH3E0+/d/rNnq/j74nmdf5OlPCWxu5Gro1zWCGOsS
         n9wN6kIZBP3Wi/FwDJbA+Zy32qSgr3RpxBwP8Wvfn4XaiZ2g2GeAeguFGc5XU4J40rAl
         N5bFkG924c6OB0HJmDgnTbWmZ+P0+3IJHTFxY/IvIlYOCfjt7apUmKMkHM1QdDDdrfZK
         08sF3gLMKNwZbtyLtYajlgMj8MEriqG80XYIwkqaVKne4pJa3n++83qPeER0711Uk+wi
         IdEGWvrT8h5s7Uf9t9dxb/TPMm+2WH7mzXoPM+JvMrxGvqQOibkaexggXogWO2EyoZS+
         RXnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782285758; x=1782890558;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZV8Zh7yj1iuS4i7Rrs7iwcE2rMMQ2V1yWPR7/wiPumM=;
        b=IPvpIVELObq6kkm9b1M8l9As8a62byXvPMHCwOj/opUXdiHZ9kNp87MxSdVGzDX2sJ
         anUU6DBhSgCX+0m8AFkN7Mc9kq0s6gkNxccJb+i/MtxbqXkplSlXlWulmwNDkuGzzXHY
         t1OO5yWMczTutiu6aPP4PPF8bG9nas2IF6PgECTgAHXMcaYy2HF6aC20i0ifkVDGmGfn
         gF76w9cXvvCmem81q0cpJO2EFRbCnxC3SWEoC/1ugAPl+w1dt1PSyv8Nk8KeNBZ7fCeJ
         cF280uzD5sP/KrP5/BFzIrIEk176CsFmFb6ZRYPy8jbg6XppsijYp73LB9gi8ZyfuKYZ
         RLhA==
X-Gm-Message-State: AOJu0YwcFPdm15Lv3FjxxeglnzdILThqxfO3N+3ro4WVziP9kZ/R255a
	cRF75VjpF9F98znR/HEw4bps90uUJcJZWaMG0agBsBX2EMo7kdt/hzQ=
X-Gm-Gg: AfdE7cl7FXiSW0xPt984DIqEcIkYKFtEAqtHaaTw0tS4NaYueXj0Z7uXeD2agz2HDcb
	RubB024vhED/nUo0cMqqNoGj9dJm9MB7HwoVodqU4ycTWW47OfOIv6fW2GfsPf+6jhvSPGNjEWm
	YOrwS+h+7jWLCXfINSoQtsfuAPeBU0bLqCLdxgbJVLIi+ruXUcAo+fT+SN1NUees8JXbpNpvm/g
	opseaNXP3mNRDFj/uflB7Fj74nVB1cCjnhwomNLgjXG8LmJkKfJHUDom8HZjbaBTwMdG3wf0h9C
	s+YOawhwGE8A42GXM/5MWN/0e7/YilFbQuZnDIobtY3EVgTCZxbHKAMT2wZsK460WwTrSAjhZnU
	23NlKrU765MGLqFbXWWFB5mebU68A/UNTDdynpARM9sXn1J8OZsmkfk1wb2rXgP5zLfQtTsGEM1
	5z4+QtWELtOs2N6aEDyCjd+k6hZnlz7WbcTFT7jukwPlLhNEWsGDAgF7wCrnzsu8A3
X-Received: by 2002:a17:90b:586c:b0:368:6998:b49d with SMTP id 98e67ed59e1d1-37de4219724mr2189115a91.10.1782285757623;
        Wed, 24 Jun 2026 00:22:37 -0700 (PDT)
Received: from localhost.localdomain ([14.5.152.27])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37de3bbc38asm1477842a91.0.2026.06.24.00.22.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 24 Jun 2026 00:22:36 -0700 (PDT)
From: Myeonghun Pak <mhun512@gmail.com>
To: Daniele Alessandrelli <daniele.alessandrelli@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Myeonghun Pak <mhun512@gmail.com>,
	Ijae Kim <ae878000@gmail.com>
Subject: [PATCH] crypto: keembay: Fix AEAD unregister count in error path
Date: Wed, 24 Jun 2026 16:15:49 +0900
Message-ID: <20260624072230.26742-1-mhun512@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

register_aes_algs() registers the AEAD algorithms before registering the
skcipher algorithms.  If skcipher registration fails, the function unwinds
the earlier AEAD registration with crypto_engine_unregister_aeads(), but it
passes ARRAY_SIZE(algs), which is the skcipher table size.

Use ARRAY_SIZE(algs_aead) for the AEAD unwind path so the unregister helper
iterates over the same table that was registered.  Also clarify the nearby
comment: the crypto registration helpers clean up algorithms registered
within the same call, while this function must still unwind earlier
successful registration steps.

Fixes: 885743324513 ("crypto: keembay - Add support for Keem Bay OCS AES/SM4")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>

---
 drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
index 8a8f6c81e0..0e42402422 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -1541,7 +1541,7 @@ static int register_aes_algs(struct ocs_aes_dev *aes_dev)
 
 	/*
 	 * If any algorithm fails to register, all preceding algorithms that
-	 * were successfully registered will be automatically unregistered.
+	 * were registered in the same call are automatically unregistered.
 	 */
 	ret = crypto_engine_register_aeads(algs_aead, ARRAY_SIZE(algs_aead));
 	if (ret)
@@ -1549,7 +1549,7 @@ static int register_aes_algs(struct ocs_aes_dev *aes_dev)
 
 	ret = crypto_engine_register_skciphers(algs, ARRAY_SIZE(algs));
 	if (ret)
-		crypto_engine_unregister_aeads(algs_aead, ARRAY_SIZE(algs));
+		crypto_engine_unregister_aeads(algs_aead, ARRAY_SIZE(algs_aead));
 
 	return ret;
 }
-- 
2.47.1
