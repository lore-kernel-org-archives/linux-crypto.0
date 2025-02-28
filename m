Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A87425DAE8
	for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 12:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740744711; cv=none; b=Oj8ZkXGQ4eCRVaF2U8ha+4qciP5kCotOJwNWl4CEnz5QxAP33qgeT/AxJfJeKkVhe7kaoiliLGgxmc3WQSQLQ7HkW53PpF3yRIl1BWshOUgAooQ9R2TUjKOETidfev5aqN3ZTMSyF1tL8gL2Ihs3eChfLLuHStby44eW5qaiGMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740744711; c=relaxed/simple;
	bh=B5I575Vc1ATQO2Jz0oPzcz0NKdEn/Dgu9+qvru1Xxi4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=We0KgQVtfFWWJ6BPJQMMNeJKUNBciijikx814w6t4oOMaA+dgVINGsB/dd1IVOQf+MwBLtAiklOQsf5ytm2XvksjeGiHm17jXddiSksqLgitkUpimftbhOYBnZaJ+mvoyJ/59ycCN8x5pygBfXI2EGudN4z2a3BVZsCS5yIX0pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qkzwqVam; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qkzwqVam"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-438e4e9a53fso13162825e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 04:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740744708; x=1741349508; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iBVP6QnHpqsjT767GF3tcrtREbTQ/KQgzFjFPBBWg+c=;
        b=qkzwqVamZnoQ5dfJOVZ6r3Jb9jhV3qCq+Go3Q0wnsLfP4FcFwrDmZt95Pw+9wkASla
         xBD+ufJM+FP2RfKrcJ8ZaH1+YKoh2C60cS2JZIm4edTqgUzrAMJmSmZqV/373UleiRnq
         fgmZNr93CZ1sMFbzfyNphq7VZq8UhSwXkJZoTgygY5pOksU8RX0HQn2XQFiKvJH5aHA7
         /HC5GWwtuIUDE777wUHNebfOYPNppQFMAj6HAhf59HLYzOiOqdGgmuxBHknGyFCMo42U
         hDp4fXfRU2Wn0pVw3FvnEoooNGR3nftmYYcfbbDmuzO1tcHD0099lPV6u6ygf14Hsyrx
         fDHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740744708; x=1741349508;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iBVP6QnHpqsjT767GF3tcrtREbTQ/KQgzFjFPBBWg+c=;
        b=dPprOLTm3d9V0hMwkrz4jkh5gvzBuvaNWjixp22KF1o0GjUcmgd1GUxjUhoc7Xb/eS
         b6C/rmqtU6XSBcmW8wg/fYEgFOwsDF+4p0fW/KOIU3B7Jaqdpj2PWXVqKU4u/pp6MWqi
         cIfKkNuiB7LD8IONcu5qsU1XYgWv1frSUHI/tC7GTUQVl5/872XCAH9X+6waiKqJHaFZ
         iQmJCWdtYtUM2QGnfHG2Dks0ujO4KXPyA12hdwdbyeXS4FIBeGpCQVYfABvrumFRAGa3
         suwWFMZUdzVMCjlTjmZKjim8NOMZ9t0IV54yZ+Q8YhFMmAv+zYW8bVHV3uS3+thNYHTQ
         eE1Q==
X-Gm-Message-State: AOJu0Yz5tSi0+hmCEf8fCFHGY6LP6qr0w9gfAMDUvrOtPH6nPjXSLEaX
	AUT1O2h8q2AgmmWgyxg7Idf6CK+vDePDRV0Mcz/ZUB/8i+UM1rMDAAconzfqaYvI87n1BJGm22w
	0PqoosQLAc4vycMpnCKtC94Orml2EwzozBsKQHHjrY9++bfJaOpXnVdM0+ENpglRs1DdXe1LiYo
	UjlZ5Z0F701fnMJ4zxAzyvIXClvNQIFQ==
X-Google-Smtp-Source: AGHT+IH5ksx6P9s5tCTO/Ze6G7x7UgZ5LoGCbfPmceDbi278RWaaX4A5DUNOkVr8oWcP34ruqynlicTg
X-Received: from wmgg5.prod.google.com ([2002:a05:600d:5:b0:439:7db5:29bb])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3ba5:b0:439:9361:13d3
 with SMTP id 5b1f17b1804b1-43ba670b6ebmr26717665e9.18.1740744708036; Fri, 28
 Feb 2025 04:11:48 -0800 (PST)
Date: Fri, 28 Feb 2025 13:11:38 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2531; i=ardb@kernel.org;
 h=from:subject; bh=VHYF4u9LG0X82kJsM0ALRJErMXeMCLbRoWWbvWPKiSw=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIf3g8l+xzPHmXQvD/1qfmuqswciosfTPGs9XB4O+/1OT+
 +5Qv5e/o5SFQYyDQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzk1A5GhunzLyp9uJuVOtc+
 8NtKvU+pjzeIvze89PTbyanPSj8WZOkx/A/8eby32rNpu1VY8KfmxVEf/Q9cDKq0Nnf7IfP0M/f UMywA
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250228121137.3534964-2-ardb+git@google.com>
Subject: [PATCH v2] crypto: lib/chachapoly - Drop dependency on CRYPTO_ALGAPI
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
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
instead, and drop the dependencies on CONFIG_CRYPTO_ALGAPI and
CONFIG_CRYPTO.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
v2: - replace include of crypto/algapi.h with crypto/utils.h
    - drop dependency on CONFIG_CRYPTO

 lib/crypto/Kconfig            | 2 --
 lib/crypto/chacha20poly1305.c | 7 +++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index c542ef1d64d0..562906be4f93 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -142,10 +142,8 @@ config CRYPTO_LIB_POLY1305
 
 config CRYPTO_LIB_CHACHA20POLY1305
 	tristate "ChaCha20-Poly1305 AEAD support (8-byte nonce library version)"
-	depends on CRYPTO
 	select CRYPTO_LIB_CHACHA
 	select CRYPTO_LIB_POLY1305
-	select CRYPTO_ALGAPI
 
 config CRYPTO_LIB_SHA1
 	tristate
diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
index a839c0ac60b2..9cfa886f1f89 100644
--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -7,11 +7,10 @@
  * Information: https://tools.ietf.org/html/rfc8439
  */
 
-#include <crypto/algapi.h>
 #include <crypto/chacha20poly1305.h>
 #include <crypto/chacha.h>
 #include <crypto/poly1305.h>
-#include <crypto/scatterwalk.h>
+#include <crypto/utils.h>
 
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

