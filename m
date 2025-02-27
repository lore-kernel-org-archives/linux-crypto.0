Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554A627003F
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 12:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740659625; cv=none; b=ZO3HLrOJgSLlWPD2NtJgfLtPNFhbiJe4+ViuufvH86btsi4av9sYhYz4QkhzWZlqwsnK1JHCTk5fF/JA74X23PQbe5BENXa3ixtUmLVvtryDT/mW0CBon5KWY2ocba1/PFhGB+MuUepO4VY/orAHPomt0fYOLdZUIn4T8Eq1bvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740659625; c=relaxed/simple;
	bh=EdLDjkeSr54IWa5pKDb8TuhcBJrbeBl8E6TTNThf/QE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=KJ0t4m0SuAG4CNbVVkV6l37jViRcz4QFr5O0rXuTfqeLN2AIQu9pq8w1rx7izZvYZStNvpPVJmy3SyJ2cOYYOdLMsFXGsYnfYnUPM2iHlaLwwSyhDrhUeS+LUYekMqWTh0fgDJkx+m1zOMJkCmV7yWDx8qRRjCCspEQLb1SqiEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DC+DrI4j; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DC+DrI4j"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-38f4e47d0b2so366182f8f.2
        for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 04:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740659621; x=1741264421; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1YZ7z55/PPSZi/CSu9v5KnREgk6+KNnZT6kxrAUgPpQ=;
        b=DC+DrI4jqFc/AzryCWDAsu52QHstQQxrccRY7GkgolRWH8O4Rb/UD9huIKjFle2KC3
         A22mJSpHDlggYdfFDvZ0Fnzww9ShAP6c5TuAcwOVG61/NXtp45UwYX5rZasHk3V6kvVO
         x5TV5DEXNmvealk8OsRn31Dw+QmYw3vnNRY3byv4OqQbHGMA/3knhCalqsYVUsb/HteM
         IeLjuLES4uNwPXppmrlZ45qAwE9SU0fMBxgyyeD5D55zJPXtG/3i0jpMAqpfqLI7z8mp
         Rr5foMlhXgf0arARW7BL3lciKbqls4/qHDfEbQaoM/4xF4vaMVIm9D5giaTFI3/awskx
         MW1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740659621; x=1741264421;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1YZ7z55/PPSZi/CSu9v5KnREgk6+KNnZT6kxrAUgPpQ=;
        b=w9Kg/MPHkLupJtKhz+iAoBDp5YKEVMY71h5mWG4gKHsw9rs6qNeL2x6fZe8/Z3BEzp
         L5NEFT8e1fKiHe0WpAddOkVxLW3lar9nLz2Wd7KT3IIlxaIAgdgGajdFCEhLwjwuAxML
         9bw2FBkP94Da4+84KKIFfSNraJa1P8HUY9ysjzEgISJXgB3HFWzb9hAujUSbeX84Zv8q
         lyPHH7TXHrD463WsIsSMBZ7A01BLwmqH+3UaZOBdZ+4XLQLofQ+X2NNZsN5L6fhws70j
         LeAnT7+XmpBm3ve8BjcBMFU2rR5jWfWnV14w13Bm1Uh5l5syZ9Gue8UITmCQVzLIkgEQ
         +n4A==
X-Gm-Message-State: AOJu0YwcVVJARnNEnrL64di1a3EYWiiWd2piDfM25szeTY0xdrm+xDXr
	6TiQ9fA9ko7M47Rx1gOVSpGLilAnAWjMX+/qcsbURp4TZTexO2WxPJ3Qdef/lDmCBY7/phY5tg5
	og6BMT3AUN+feq4tpoJjq28u493O6ZyGd4PlbgYby1s30BJeBLs9n4HsW19UjxI1Otb++wvN97D
	lloif8jhE+yyNZkv1Yov/TA1X6ASb1Gw==
X-Google-Smtp-Source: AGHT+IHupwJTmB9Ch9XG+DJU0fl1g/wMPBjVQf4rJuby5bJtQM/3o3mPObYTMbKCQZNK+4FWtf1IV560
X-Received: from wmbbh16.prod.google.com ([2002:a05:600c:3d10:b0:439:80fc:8bce])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1843:b0:38d:e078:43a0
 with SMTP id ffacd0b85a97d-390d4f84922mr7850556f8f.38.1740659621742; Thu, 27
 Feb 2025 04:33:41 -0800 (PST)
Date: Thu, 27 Feb 2025 13:33:38 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250227123338.3033402-1-ardb+git@google.com>
Subject: [PATCH] crypto: lib/chachapoly - Drop dependency on CRYPTO_ALGAPI
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The ChaCha20-Poly1305 library code uses the sg_miter API to process
input presented via scatterlists, except for the special case where the
digest buffer is not covered entirely by the same scatterlist entry as
the last byte of input. In that case, it uses scatterwalk_map_and_copy()
to access the memory in the input scatterlist where the digest is stored.

This results in a dependency on crypto/scatterwalk.c and therefore on
CONFIG_CRYPTO_ALGAPI, which is unnecessary, as the sg_miter API already
provides this functionality via sg_copy_to_buffer(). So use that
instead, and drop the CRYPTO_ALGAPI dependency.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/crypto/Kconfig            | 1 -
 lib/crypto/chacha20poly1305.c | 5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index b01253cac70a..a759e6f6a939 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -135,7 +135,6 @@ config CRYPTO_LIB_CHACHA20POLY1305
 	depends on CRYPTO
 	select CRYPTO_LIB_CHACHA
 	select CRYPTO_LIB_POLY1305
-	select CRYPTO_ALGAPI
 
 config CRYPTO_LIB_SHA1
 	tristate
diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
index a839c0ac60b2..280a4925dd17 100644
--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -11,7 +11,6 @@
 #include <crypto/chacha20poly1305.h>
 #include <crypto/chacha.h>
 #include <crypto/poly1305.h>
-#include <crypto/scatterwalk.h>
 
 #include <linux/unaligned.h>
 #include <linux/kernel.h>
@@ -318,8 +317,8 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
 
 	if (unlikely(sl > -POLY1305_DIGEST_SIZE)) {
 		poly1305_final(&poly1305_state, b.mac[1]);
-		scatterwalk_map_and_copy(b.mac[encrypt], src, src_len,
-					 sizeof(b.mac[1]), encrypt);
+		sg_copy_buffer(src, sg_nents(src), b.mac[encrypt],
+			       sizeof(b.mac[1]), src_len, !encrypt);
 		ret = encrypt ||
 		      !crypto_memneq(b.mac[0], b.mac[1], POLY1305_DIGEST_SIZE);
 	}
-- 
2.48.1.711.g2feabab25a-goog

