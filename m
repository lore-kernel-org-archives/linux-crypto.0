Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794488080;
	b=K87PKMrNkgi1GP4gn16rrumVg/2x4wxP6YZmIYEtImnFyCcSw5dQtc4lOmnkyMkksg+a
	 v24G27aTPUGBTfAvD9+4g/Euz+G+AauZxxxbul2a/yHRJNHeba8K1klDmVNc9SUR8oPV1
	 rZazfTvnF31Hb9OV2IWlQO2EVlxhMMznTmnK0sPnjHS5Bj1/3gIiFoawtk34hNpzVTop2
	 FxTwvDqtzP3nWHfT7jsu/wwghx0xRqsekQwDrWagCWbDhYYCkCOjCXCKLJGEKR6ufNDld
	 rj22fJlQ7y15sBUzR4keK7Ug5GroXCGfBqVEgaJ+A6uGuiuxaQ/sBwgdb5ZpmbFx6IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794488080;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eW3nNpyH1jyxKHaKw6h/4dF8TToSbxOcVkVsaWeaXt8=;
	b=GZhHdXNuJWVHeSmXmrYZ4O2fvm/4Dos3VP7sydHMJBSCSAXXs2W7kzRkDhh/vQzV/jwv
	 b7i8bOlRwnsGckInjPMaiYt1z0/Zl62KDctpGYms/eu12HN4x8PzdA/Wr+/vuWJiUMcwJ
	 RDF7fgW8Hs6GkeLtnrzxryp6gew2RhdGaPfwwyRQoYTN6dz6m8HM7rQq4Qzaa2ZNBW5JA
	 JP0Yw5ssrYN/NlqJ/M2NlathLuO83AKXX+BCQ6Jzmgdkzp6awbH5cMjkPFpmVKjTPy/kf
	 rvVGKa7rqMlsp8K6yoAWgr2Zy8ffz/ipMNgbsEs7YtzZ8p4kF1d8FKSKe2yYiRAqE5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openvpn.net;
	spf=pass smtp.mailfrom=openvpn.com;
	dkim=pass header.d=openvpn.net header.i=@openvpn.net header.a=rsa-sha256 header.s=google header.b=Ij8Nqle4;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239F0606A321
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 12:54:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 239F0606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvpn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvpn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openvpn.net header.i=@openvpn.net header.a=rsa-sha256 header.s=google header.b=Ij8Nqle4
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so29547035e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 04:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvpn.net; s=google; t=1794488079; x=1795092879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eW3nNpyH1jyxKHaKw6h/4dF8TToSbxOcVkVsaWeaXt8=;
        b=Ij8Nqle47CyemC9MrBMVA0rwpny4uIJ2g4zFjA7QGlxZ0apwGFzWE27Z8gZd9qBTCa
         aLt7K9jr5zj345CeWYq9XeH9hQFqsiOLAL+H+NJufmHEj+MslE4eS8jNuQus9ILcT4pQ
         dZNeEwk3rTLjRaTr9GU24G8pSdZhItSoKXk2UP03wBU+CFNmzPzph3UbSl+/37Gn607I
         9lqH79SlUvMotibZnntX4UoZDjKzMdHEhuJwlcotMn0hix04O1pj0jsGu/QquFKoZVi1
         9TbNZmfKkd6cFWAgWdVCDOOSV638g0ykOU7I/ytySpZz8CPTTenGCMwE4w5rEuoa72qe
         HRSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794488079; x=1795092879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eW3nNpyH1jyxKHaKw6h/4dF8TToSbxOcVkVsaWeaXt8=;
        b=iW8hnrvBTJPLlzj8YILJq0J7eQ68b830eJKW3lDhqnEZdPJERMTiuLGLZawthtxP74
         5CpQoBqwBGXmQGjrJ8vRYkAdVZH9FlE1vdimDOsCTzLrNtTH6soOSMMRxCghEYhCdVYb
         zbAMSyaErExegQAPA0jippKEpnGcli91mF5M8iHOqqbCGExYaBk+o+Ij/tJafp33gjxl
         7bc9tUduT/ljG+v6p1MSl3GKdegqfqdB0Ost0SQt37ucKuuCz0zZWHZzFecIXM5y9CWH
         CoXU3VLgSa2EsCewbPBS7ocTXwiPaG80vuZ8MP8xfMOGSgz8zkEsZklrDv/eIbg9eCWf
         vptQ==
X-Gm-Message-State: APuU4Z9Etvjj+z3Tnb9rALUv3tepjhIQTGQn00jIBZNlzv0SH0YOD3Cd
	MhW4gqZuL7Bha53NOJW6q9ys5xalTiHe5EUd1arHAZz3yJhP7IH0hV99rGqTM+JKL9weo+n8u71
	hY/mBHtIMdkHrRurjcswq2MQ8V5mnmbU9PSextmj7W1A9K7PCczDH9uZ9aMtZDxgsOe9f9rkw
X-Gm-Gg: AYBFou2ADSJZO6jSyN8NS2kRtSvy0jHR2lHzItbATQ1/lOI1X14W7O7zhWCYivbQvkF
	7HsBxettAwAq2iuqS13Rz5JpFKS8rd8kIttIqHtQR0Nm84zReaE0ZaYom3m87z7WQ/mZW7Ouwbe
	22Dtl9dl8P42sWgwM/1OCAYGlKYMUJ2frn+9+Nuy+7tYZHO+NKBNSA+PAnUdc0p1UMORH6iMv9D
	U692tsNjBCzYUJrSw2x81fj+EEBAwkyLCxSSgsKwuPKeQlB04lD+odmcGyw+H0MLIpn0Jb2uCdk
	Vy2GAabVYFmPw4DgH5zEpYR5VSO933Uv+b1qKYdGpH9O41E/KNpqkeMMDIvhv7Gwg8Cm1FaLe3z
	0RGqiiNw57mUDKJSec4wAfxk9hdeTvNmecyOGBb4ET5UwxAFSujd1Ksvay0RJkEDz2Rj3ieRfxJ
	rUfleNTh+dB2Ynz2ZTszs4ZeOWz5gNIQIy8Id6OFyH9pdcBKNO4l+YOa7zeQFg3H6fNjckUzLs+
	VYaw/MI2Km9KsTpRsLfkJmW3ySEsY2/lwDgCWHsIxuvolb6DuTTLzXz4H997BcyEpxmFqYxu9mn
	K/a7jzrdb7F+hnjUxJZHvUCdsXX9sDXvhr0x9EOFNNB0D3cJk0gb//M/uTeiZsQyTynmUyyEQg=
	=
X-Received: by 2002:a05:600c:19d0:b0:4a3:7344:13b5 with SMTP id 5b1f17b1804b1-4ba093ab25dmr98030675e9.16.1794488078354;
        Thu, 12 Nov 2026 04:54:38 -0800 (PST)
Received: from inifinity.homelan.mandelbit.com ([2001:67c:2fbc:1:56b9:769a:f836:6390])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49835858f26sm17202726f8f.18.2026.11.12.04.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:54:37 -0800 (PST)
From: Antonio Quartulli <antonio@openvpn.net>
To: linux-crypto@vger.kernel.org
Cc: Antonio Quartulli <antonio@mandelbit.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [RFC PATCH 3/5] lib/crypto: tests: Add KUnit test suite for AEGIS-128X4
Date: Thu, 12 Nov 2026 13:54:28 +0100
Message-ID: <20261112125432.3064939-4-antonio@openvpn.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112125432.3064939-1-antonio@openvpn.net>
References: <20261112125432.3064939-1-antonio@openvpn.net>
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

From: Antonio Quartulli <antonio@mandelbit.com>

Add a KUnit test suite for the AEGIS-128X4 library, using the AEAD test
template and the AEGIS-128X4 test vectors from RFC 10032.

python-cryptography doesn't support AEGIS, so add an implementation of
AEGIS-128X written from the RFC to gen-aead-testvecs.py, to generate the
Monte Carlo checksum.

Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
---
 lib/crypto/.kunitconfig             |   1 +
 lib/crypto/tests/Kconfig            |  10 +
 lib/crypto/tests/Makefile           |   1 +
 lib/crypto/tests/aegis128x4_kunit.c | 352 ++++++++++++++++++++++++++++
 scripts/crypto/gen-aead-testvecs.py | 166 ++++++++++++-
 5 files changed, 524 insertions(+), 6 deletions(-)
 create mode 100644 lib/crypto/tests/aegis128x4_kunit.c

diff --git a/lib/crypto/.kunitconfig b/lib/crypto/.kunitconfig
index 6d83badf4292..61a28c1554cb 100644
--- a/lib/crypto/.kunitconfig
+++ b/lib/crypto/.kunitconfig
@@ -2,6 +2,7 @@ CONFIG_KUNIT=y
 
 CONFIG_CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT=y
 
+CONFIG_CRYPTO_LIB_AEGIS128X4_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_AES_CCM_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_AES_GCM_KUNIT_TEST=y
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 5a86a02d25b7..2584aa74c450 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -1,5 +1,14 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
+config CRYPTO_LIB_AEGIS128X4_KUNIT_TEST
+	tristate "KUnit tests for AEGIS-128X4" if !KUNIT_ALL_TESTS
+	depends on KUNIT && CRYPTO_LIB_AEGIS128X4
+	default KUNIT_ALL_TESTS
+	select CRYPTO_LIB_BENCHMARK_VISIBLE
+	# This test uses BLAKE2s, but that's always built-in.
+	help
+	  KUnit tests for the AEGIS-128X4 authenticated encryption algorithm.
+
 config CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST
 	tristate "KUnit tests for AES-CMAC, AES-XCBC-MAC, and AES-CBC-MAC" if !KUNIT_ALL_TESTS
 	depends on KUNIT && CRYPTO_LIB_AES_CBC_MACS
@@ -179,6 +188,7 @@ config CRYPTO_LIB_SM3_KUNIT_TEST
 config CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
 	tristate "Enable all crypto library code for KUnit tests"
 	depends on KUNIT
+	select CRYPTO_LIB_AEGIS128X4
 	select CRYPTO_LIB_AES_CBC
 	select CRYPTO_LIB_AES_CBC_MACS
 	select CRYPTO_LIB_AES_CCM
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index 40c9624eaaa8..73e9851dbb14 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
+obj-$(CONFIG_CRYPTO_LIB_AEGIS128X4_KUNIT_TEST) += aegis128x4_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST) += aes_cbc_macs_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_CCM_KUNIT_TEST) += aes_ccm_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_AES_GCM_KUNIT_TEST) += aes_gcm_kunit.o
diff --git a/lib/crypto/tests/aegis128x4_kunit.c b/lib/crypto/tests/aegis128x4_kunit.c
new file mode 100644
index 000000000000..1e271e4a1756
--- /dev/null
+++ b/lib/crypto/tests/aegis128x4_kunit.c
@@ -0,0 +1,352 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KUnit test suite for AEGIS-128X4
+ *
+ * Copyright 2026 Antonio Quartulli <antonio@mandelbit.com>
+ */
+#include <crypto/aegis128x4.h>
+#include <crypto/blake2s.h>
+#include "test-utils.h"
+
+/* AEGIS-128X4 test vectors from RFC 10032, Appendix A.5 */
+static const struct aegis128x4_testvec {
+	const char *name;
+	const char *key;
+	const char *nonce;
+	const char *ad;
+	size_t ad_len;
+	const char *ptext;
+	const char *ctext;
+	size_t data_len;
+	const char *tag;
+	size_t tag_len;
+} aegis128x4_testvecs[] = {
+	{
+		.name = "RFC 10032 A.5.2 (128-bit tag)",
+		.key = "\x00\x01\x02\x03\x04\x05\x06\x07"
+		       "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.nonce = "\x10\x11\x12\x13\x14\x15\x16\x17"
+			 "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.ad = "",
+		.ad_len = 0,
+		.ptext = "",
+		.ctext = "",
+		.data_len = 0,
+		.tag = "\x5b\xef\x76\x2d\x09\x47\xc0\x04"
+		       "\x55\xb9\x7b\xb3\xaf\x30\xdf\xa3",
+		.tag_len = 16,
+	},
+	{
+		.name = "RFC 10032 A.5.2 (256-bit tag)",
+		.key = "\x00\x01\x02\x03\x04\x05\x06\x07"
+		       "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.nonce = "\x10\x11\x12\x13\x14\x15\x16\x17"
+			 "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.ad = "",
+		.ad_len = 0,
+		.ptext = "",
+		.ctext = "",
+		.data_len = 0,
+		.tag = "\xa4\xb2\x54\x37\xf4\xbe\x93\xcf"
+		       "\xa8\x56\xa2\xf2\x7e\x44\x16\xb4"
+		       "\x2c\xac\x79\xfd\x46\x98\xf2\xcd"
+		       "\xbe\x6a\xf2\x56\x73\xe1\x0a\x68",
+		.tag_len = 32,
+	},
+	{
+		.name = "RFC 10032 A.5.3 (128-bit tag)",
+		.key = "\x00\x01\x02\x03\x04\x05\x06\x07"
+		       "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.nonce = "\x10\x11\x12\x13\x14\x15\x16\x17"
+			 "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.ad = "\x01\x02\x03\x04\x01\x02\x03\x04",
+		.ad_len = 8,
+		.ptext = "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07",
+		.ctext = "\xe8\x36\x11\x85\x62\xf4\x47\x9c"
+			 "\x9d\x35\xc1\x73\x56\xa8\x33\x11"
+			 "\x4c\x21\xf9\xaa\x39\xe4\xdd\xa5"
+			 "\xe5\xc8\x7f\x41\x52\xa0\x0f\xce"
+			 "\x9a\x7c\x38\xf8\x32\xea\xfe\x8b"
+			 "\x1c\x12\xf8\xa7\xcf\x12\xa8\x1a"
+			 "\x1a\xd8\xa9\xc2\x4b\xa9\xde\xdf"
+			 "\xbd\xaa\x58\x6f\xfe\xa6\x7d\xdc"
+			 "\x80\x1e\xa9\x7d\x9a\xb4\xa8\x72"
+			 "\xf4\x2d\x0e\x35\x2e\x27\x13\xda"
+			 "\xcd\x60\x9f\x94\x42\xc1\x75\x17"
+			 "\xc5\xa2\x9d\xaf\x3e\x2a\x3f\xac"
+			 "\x4f\xf6\xb1\x38\x0c\x4e\x46\xdf"
+			 "\x7b\x08\x6a\xf6\xce\x6b\xc1\xed"
+			 "\x59\x4b\x8d\xd6\x4a\xed\x2a\x7e",
+		.data_len = 120,
+		.tag = "\x0e\x56\xab\x94\xe2\xe8\x5d\xb8"
+		       "\x0f\x9d\x54\x01\x0c\xaa\xbf\xb4",
+		.tag_len = 16,
+	},
+	{
+		.name = "RFC 10032 A.5.3 (256-bit tag)",
+		.key = "\x00\x01\x02\x03\x04\x05\x06\x07"
+		       "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.nonce = "\x10\x11\x12\x13\x14\x15\x16\x17"
+			 "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.ad = "\x01\x02\x03\x04\x01\x02\x03\x04",
+		.ad_len = 8,
+		.ptext = "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07"
+			 "\x04\x05\x06\x07\x04\x05\x06\x07",
+		.ctext = "\xe8\x36\x11\x85\x62\xf4\x47\x9c"
+			 "\x9d\x35\xc1\x73\x56\xa8\x33\x11"
+			 "\x4c\x21\xf9\xaa\x39\xe4\xdd\xa5"
+			 "\xe5\xc8\x7f\x41\x52\xa0\x0f\xce"
+			 "\x9a\x7c\x38\xf8\x32\xea\xfe\x8b"
+			 "\x1c\x12\xf8\xa7\xcf\x12\xa8\x1a"
+			 "\x1a\xd8\xa9\xc2\x4b\xa9\xde\xdf"
+			 "\xbd\xaa\x58\x6f\xfe\xa6\x7d\xdc"
+			 "\x80\x1e\xa9\x7d\x9a\xb4\xa8\x72"
+			 "\xf4\x2d\x0e\x35\x2e\x27\x13\xda"
+			 "\xcd\x60\x9f\x94\x42\xc1\x75\x17"
+			 "\xc5\xa2\x9d\xaf\x3e\x2a\x3f\xac"
+			 "\x4f\xf6\xb1\x38\x0c\x4e\x46\xdf"
+			 "\x7b\x08\x6a\xf6\xce\x6b\xc1\xed"
+			 "\x59\x4b\x8d\xd6\x4a\xed\x2a\x7e",
+		.data_len = 120,
+		.tag = "\x69\xab\xf0\xf6\x4a\x13\x7d\xd6"
+		       "\xe1\x22\x47\x8d\x77\x7e\x98\xbc"
+		       "\x42\x28\x23\x00\x6c\xf5\x7f\x5e"
+		       "\xe8\x22\xdd\x78\x39\x72\x30\xb2",
+		.tag_len = 32,
+	},
+};
+
+static void test_aegis128x4_one_test_vector(struct kunit *test,
+					    const struct aegis128x4_testvec *tv)
+{
+	u8 *ctext = alloc_buf(test, tv->data_len);
+	u8 *decrypted = alloc_buf(test, tv->data_len);
+	u8 *tag = alloc_buf(test, tv->tag_len);
+	struct aegis128x4_key key;
+	int err;
+
+	err = aegis128x4_preparekey(&key, tv->key, AEGIS128X4_KEY_SIZE,
+				    tv->tag_len);
+	KUNIT_ASSERT_EQ_MSG(test, 0, err, "Failed to prepare key for %s",
+			    tv->name);
+
+	aegis128x4_encrypt(ctext, tv->ptext, tv->data_len, tag, tv->ad,
+			   tv->ad_len, tv->nonce, &key);
+	KUNIT_ASSERT_MEMEQ_MSG(test, tv->ctext, ctext, tv->data_len,
+			       "Wrong ciphertext for %s", tv->name);
+	KUNIT_ASSERT_MEMEQ_MSG(test, tag, tv->tag, tv->tag_len,
+			       "Wrong tag for %s", tv->name);
+
+	err = aegis128x4_decrypt(decrypted, ctext, tv->data_len, tag, tv->ad,
+				 tv->ad_len, tv->nonce, &key);
+	KUNIT_ASSERT_EQ_MSG(test, 0, err, "Decryption failed for %s", tv->name);
+	KUNIT_ASSERT_MEMEQ_MSG(test, tv->ptext, decrypted, tv->data_len,
+			       "Wrong plaintext for %s", tv->name);
+}
+
+static void test_aegis128x4_test_vectors(struct kunit *test)
+{
+	for (size_t i = 0; i < ARRAY_SIZE(aegis128x4_testvecs); i++)
+		test_aegis128x4_one_test_vector(test, &aegis128x4_testvecs[i]);
+}
+
+/* The (data, associated data) lengths of AEGIS128X4_LONG_LENS in the script */
+static const struct {
+	size_t data_len;
+	size_t ad_len;
+} aegis128x4_long_lens[] = {
+	{ 4097, 0 },
+	{ 8320, 4100 },
+	{ 12345, 129 },
+};
+
+/* This value was generated by gen-aead-testvecs.py. */
+static const u8 aegis128x4_long_checksum[BLAKE2S_HASH_SIZE] = {
+	0x0a, 0x18, 0x21, 0x25, 0x48, 0xe7, 0x99, 0x53, 0x09, 0x00, 0x0d,
+	0xf5, 0x61, 0x1b, 0xa4, 0x11, 0xe1, 0x91, 0xef, 0xf5, 0x60, 0x84,
+	0x79, 0x26, 0x4c, 0x20, 0xb2, 0x0d, 0x22, 0x70, 0x10, 0xfb,
+};
+
+/*
+ * Test messages longer than the 4 KiB that the x86 code processes at a time,
+ * out-of-place, in-place and incrementally in pieces of random length.
+ */
+static void test_aegis128x4_long(struct kunit *test)
+{
+	const size_t max_len = 12345;
+	u8 *pt = alloc_buf(test, max_len);
+	u8 *ad = alloc_buf(test, max_len);
+	u8 *ct = alloc_buf(test, max_len);
+	u8 *buf = alloc_buf(test, max_len);
+	u8 tag[AEGIS128X4_MAX_AUTHTAG_SIZE], tag2[AEGIS128X4_MAX_AUTHTAG_SIZE];
+	u8 raw_key[AEGIS128X4_KEY_SIZE], nonce[AEGIS128X4_NONCE_SIZE];
+	u8 checksum[BLAKE2S_HASH_SIZE];
+	struct blake2s_ctx checksum_ctx;
+	struct aegis128x4_key key;
+	struct aegis128x4_ctx ctx;
+	size_t pos, n;
+	int err;
+
+	blake2s_init(&checksum_ctx, BLAKE2S_HASH_SIZE);
+	for (size_t i = 0; i < ARRAY_SIZE(aegis128x4_long_lens); i++) {
+		size_t data_len = aegis128x4_long_lens[i].data_len;
+		size_t ad_len = aegis128x4_long_lens[i].ad_len;
+
+		rand_bytes_seeded_from_len(pt, data_len);
+		rand_bytes_seeded_from_len(ad, ad_len);
+		rand_bytes_seeded_from_len(raw_key, sizeof(raw_key));
+		rand_bytes_seeded_from_len(nonce, sizeof(nonce));
+		err = aegis128x4_preparekey(&key, raw_key, sizeof(raw_key),
+					    sizeof(tag));
+		KUNIT_ASSERT_EQ(test, 0, err);
+
+		aegis128x4_encrypt(ct, pt, data_len, tag, ad, ad_len, nonce,
+				   &key);
+		blake2s_update(&checksum_ctx, ct, data_len);
+		blake2s_update(&checksum_ctx, tag, sizeof(tag));
+
+		memcpy(buf, pt, data_len);
+		aegis128x4_encrypt(buf, buf, data_len, tag2, ad, ad_len, nonce,
+				   &key);
+		KUNIT_ASSERT_MEMEQ(test, ct, buf, data_len);
+		KUNIT_ASSERT_MEMEQ(test, tag, tag2, sizeof(tag));
+
+		aegis128x4_init(&ctx, nonce, &key);
+		for (pos = 0; pos < ad_len; pos += n) {
+			n = min(ad_len - pos, 1 + rand_length(1000));
+			aegis128x4_auth_update(&ctx, &ad[pos], n);
+		}
+		for (pos = 0; pos < data_len; pos += n) {
+			n = min(data_len - pos, 1 + rand_length(5000));
+			aegis128x4_encrypt_update(&ctx, &buf[pos], &pt[pos], n);
+		}
+		aegis128x4_encrypt_final(&ctx, tag2);
+		KUNIT_ASSERT_MEMEQ(test, ct, buf, data_len);
+		KUNIT_ASSERT_MEMEQ(test, tag, tag2, sizeof(tag));
+
+		memcpy(buf, ct, data_len);
+		err = aegis128x4_decrypt(buf, buf, data_len, tag, ad, ad_len,
+					 nonce, &key);
+		KUNIT_ASSERT_EQ(test, 0, err);
+		KUNIT_ASSERT_MEMEQ(test, pt, buf, data_len);
+	}
+	blake2s_final(&checksum_ctx, checksum);
+	KUNIT_EXPECT_MEMEQ(test, checksum, aegis128x4_long_checksum,
+			   BLAKE2S_HASH_SIZE);
+}
+
+static int aegis128x4_init_test(struct aegis128x4_ctx *ctx, u64 data_len,
+				u64 ad_len, const u8 *nonce, size_t nonce_len,
+				const struct aegis128x4_key *key)
+{
+	if (nonce_len != AEGIS128X4_NONCE_SIZE)
+		return -EINVAL;
+	/*
+	 * Ignore data_len and ad_len.  Incremental AEGIS-128X4 doesn't need
+	 * them at initialization time.
+	 */
+	aegis128x4_init(ctx, nonce, key);
+	return 0;
+}
+
+static int aegis128x4_encrypt_test(u8 *dst, const u8 *src, size_t data_len,
+				   u8 *authtag, const u8 *ad, size_t ad_len,
+				   const u8 *nonce, size_t nonce_len,
+				   const struct aegis128x4_key *key)
+{
+	if (nonce_len != AEGIS128X4_NONCE_SIZE)
+		return -EINVAL;
+	/* aegis128x4_encrypt() returns void. */
+	aegis128x4_encrypt(dst, src, data_len, authtag, ad, ad_len, nonce, key);
+	return 0;
+}
+
+static int aegis128x4_decrypt_test(u8 *dst, const u8 *src, size_t data_len,
+				   const u8 *authtag, const u8 *ad,
+				   size_t ad_len, const u8 *nonce,
+				   size_t nonce_len,
+				   const struct aegis128x4_key *key)
+{
+	if (nonce_len != AEGIS128X4_NONCE_SIZE)
+		return -EINVAL;
+	return aegis128x4_decrypt(dst, src, data_len, authtag, ad, ad_len,
+				  nonce, key);
+}
+
+static const size_t aegis128x4_valid_key_lens[] = { AEGIS128X4_KEY_SIZE };
+#define AEAD_MAX_KEY_LEN AEGIS128X4_KEY_SIZE
+#define AEAD_VALID_KEY_LENS aegis128x4_valid_key_lens
+
+static const size_t aegis128x4_valid_nonce_lens[] = { AEGIS128X4_NONCE_SIZE };
+#define AEAD_MAX_NONCE_LEN AEGIS128X4_NONCE_SIZE
+#define AEAD_VALID_NONCE_LENS aegis128x4_valid_nonce_lens
+
+static const size_t aegis128x4_valid_tag_lens[] = { 16, 32 };
+#define AEAD_MAX_TAG_LEN AEGIS128X4_MAX_AUTHTAG_SIZE
+#define AEAD_VALID_TAG_LENS aegis128x4_valid_tag_lens
+
+#define AEAD_KEY aegis128x4_key
+#define AEAD_CTX aegis128x4_ctx
+#define AEAD_PREPAREKEY aegis128x4_preparekey
+#define AEAD_ENCRYPT aegis128x4_encrypt_test
+#define AEAD_DECRYPT aegis128x4_decrypt_test
+
+#define AEAD_INIT aegis128x4_init_test
+#define AEAD_AUTH_UPDATE aegis128x4_auth_update
+#define AEAD_ENCRYPT_UPDATE aegis128x4_encrypt_update
+#define AEAD_DECRYPT_UPDATE aegis128x4_decrypt_update
+#define AEAD_ENCRYPT_FINAL aegis128x4_encrypt_final
+#define AEAD_DECRYPT_FINAL aegis128x4_decrypt_final
+
+/* This value was generated by gen-aead-testvecs.py. */
+static const u8 aegis128x4_monte_carlo_checksum[BLAKE2S_HASH_SIZE] = {
+	0x57, 0xf2, 0x44, 0xb4, 0x43, 0x71, 0x7c, 0x34, 0x94, 0x93, 0x22,
+	0xaa, 0xaf, 0x75, 0x5b, 0xa9, 0x5c, 0x23, 0x26, 0xbb, 0x4f, 0xf2,
+	0x61, 0x43, 0xa6, 0x92, 0xc7, 0x46, 0x3a, 0x17, 0x58, 0x67,
+};
+#define AEAD_MONTE_CARLO_CHECKSUM aegis128x4_monte_carlo_checksum
+
+#include "aead-test-template.h"
+
+static struct kunit_case aegis128x4_test_cases[] = {
+	KUNIT_CASE(test_aegis128x4_test_vectors),
+	KUNIT_CASE(test_aegis128x4_long),
+	AEAD_KUNIT_CASES,
+	{},
+};
+
+static struct kunit_suite aegis128x4_test_suite = {
+	.name = "aegis128x4",
+	.test_cases = aegis128x4_test_cases,
+};
+kunit_test_suite(aegis128x4_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests and benchmark for AEGIS-128X4");
+MODULE_LICENSE("GPL");
diff --git a/scripts/crypto/gen-aead-testvecs.py b/scripts/crypto/gen-aead-testvecs.py
index d77d646f75b5..6917be65f5ab 100755
--- a/scripts/crypto/gen-aead-testvecs.py
+++ b/scripts/crypto/gen-aead-testvecs.py
@@ -3,13 +3,12 @@
 #
 # Script that generates known-good data used in the AEAD tests.
 #
-# Requires that python-cryptography be installed.
+# Requires that python-cryptography be installed, except for AEGIS-128X4.
 #
 # Copyright 2026 Google LLC
 
 import hashlib
 import sys
-import cryptography.hazmat.primitives.ciphers.aead
 
 
 # Deterministically generate 'length' random bytes.
@@ -22,6 +21,129 @@ def rand_bytes(length):
     return bytes(out)
 
 
+# Multiply two elements of GF(2^8), using the AES polynomial.
+def gf256_mul(a, b):
+    product = 0
+    for _ in range(8):
+        if b & 1:
+            product ^= a
+        a = (a << 1) ^ (0x11B if a & 0x80 else 0)
+        b >>= 1
+    return product
+
+
+# The AES S-box: the multiplicative inverse in GF(2^8), then the affine map.
+def gen_aes_sbox():
+    sbox = []
+    for x in range(256):
+        inv = next((y for y in range(256) if gf256_mul(x, y) == 1), 0)
+        s = inv
+        for i in range(1, 5):
+            s ^= ((inv << i) | (inv >> (8 - i))) & 0xFF
+        sbox.append(s ^ 0x63)
+    return sbox
+
+
+AES_SBOX = gen_aes_sbox()
+
+
+def xor_bytes(a, b):
+    return bytes(x ^ y for x, y in zip(a, b))
+
+
+def and_bytes(a, b):
+    return bytes(x & y for x, y in zip(a, b))
+
+
+# The AES round function: SubBytes, ShiftRows, MixColumns and AddRoundKey.
+def aes_round(block, round_key):
+    s = [AES_SBOX[block[(i + 4 * (i % 4)) % 16]] for i in range(16)]
+    out = []
+    for c in range(4):
+        col = s[4 * c : 4 * c + 4]
+        for r in range(4):
+            out.append(
+                gf256_mul(col[r], 2)
+                ^ gf256_mul(col[(r + 1) % 4], 3)
+                ^ col[(r + 2) % 4]
+                ^ col[(r + 3) % 4]
+            )
+    return xor_bytes(out, round_key)
+
+
+# AEGIS-128X encryption with parallelism degree 'd', as specified in RFC 10032
+# section 5.4, since python-cryptography doesn't support AEGIS.
+def aegis128x_encrypt(d, key, nonce, ad, pt, tag_len):
+    c0 = bytes.fromhex("000101020305080d1522375990e97962")
+    c1 = bytes.fromhex("db3d18556dc22ff12011314273b528dd")
+    rate = 32 * d
+    half = rate // 2
+
+    def update(v, m0, m1):
+        for i, s in enumerate(v):
+            v[i] = [
+                aes_round(s[7], xor_bytes(s[0], m0[16 * i : 16 * i + 16])),
+                aes_round(s[0], s[1]),
+                aes_round(s[1], s[2]),
+                aes_round(s[2], s[3]),
+                aes_round(s[3], xor_bytes(s[4], m1[16 * i : 16 * i + 16])),
+                aes_round(s[4], s[5]),
+                aes_round(s[5], s[6]),
+                aes_round(s[6], s[7]),
+            ]
+
+    # Init
+    kn = xor_bytes(key, nonce)
+    kc0 = xor_bytes(key, c0)
+    kc1 = xor_bytes(key, c1)
+    v = [[kn, c1, c0, c1, kn, kc0, kc1, kc0] for _ in range(d)]
+    for _ in range(10):
+        for i in range(d):
+            ctx = bytes([i, d - 1]) + bytes(14)
+            v[i][3] = xor_bytes(v[i][3], ctx)
+            v[i][7] = xor_bytes(v[i][7], ctx)
+        update(v, nonce * d, key * d)
+
+    # Absorb
+    padded = ad + bytes(-len(ad) % rate)
+    for i in range(0, len(padded), rate):
+        update(v, padded[i : i + half], padded[i + half : i + rate])
+
+    # Enc
+    ct = b""
+    padded = pt + bytes(-len(pt) % rate)
+    for i in range(0, len(padded), rate):
+        z0 = b"".join(
+            xor_bytes(xor_bytes(s[1], s[6]), and_bytes(s[2], s[3])) for s in v
+        )
+        z1 = b"".join(
+            xor_bytes(xor_bytes(s[2], s[5]), and_bytes(s[6], s[7])) for s in v
+        )
+        block = padded[i : i + rate]
+        ct += xor_bytes(block, z0 + z1)
+        update(v, block[:half], block[half:])
+
+    # Finalize
+    u = (len(ad) * 8).to_bytes(8, "little")
+    u += (len(pt) * 8).to_bytes(8, "little")
+    t = b"".join(xor_bytes(s[2], u) for s in v)
+    for _ in range(7):
+        update(v, t, t)
+    if tag_len == 16:
+        tag = bytes(16)
+        for s in v:
+            for j in range(7):
+                tag = xor_bytes(tag, s[j])
+    else:
+        tag0 = tag1 = bytes(16)
+        for s in v:
+            for j in range(4):
+                tag0 = xor_bytes(tag0, s[j])
+                tag1 = xor_bytes(tag1, s[j + 4])
+        tag = tag0 + tag1
+    return ct[: len(pt)] + tag
+
+
 # Deterministically generate many different AEAD inputs using exactly the same
 # method that the test uses; encrypt them using an independent implementation of
 # the algorithm; compute the checksum of all the resulting (ciphertext, authtag)
@@ -32,7 +154,14 @@ def gen_monte_carlo_checksum(alg):
         ad_len = data_len % 293
         pt = rand_bytes(data_len)
         ad = rand_bytes(ad_len)
-        if alg == "aes-ccm":
+        if alg == "aegis128x4":
+            key = rand_bytes(16)
+            nonce = rand_bytes(16)
+            tag_len = [16, 32][data_len % 2]
+            ct_and_tag = aegis128x_encrypt(4, key, nonce, ad, pt, tag_len)
+        elif alg == "aes-ccm":
+            import cryptography.hazmat.primitives.ciphers.aead
+
             key_len = [16, 24, 32][data_len % 3]
             key = rand_bytes(key_len)
             nonce = rand_bytes([7, 8, 9, 10, 11, 12, 13][data_len % 7])
@@ -42,6 +171,8 @@ def gen_monte_carlo_checksum(alg):
             )
             ct_and_tag = ccm.encrypt(nonce, pt, ad)
         elif alg == "aes-gcm":
+            import cryptography.hazmat.primitives.ciphers.aead
+
             key_len = [16, 24, 32][data_len % 3]
             key = rand_bytes(key_len)
             nonce = rand_bytes(12)
@@ -53,7 +184,27 @@ def gen_monte_carlo_checksum(alg):
 
         blake2s.update(ct_and_tag)
 
-    name = f"{alg.replace('-', '_')}_monte_carlo_checksum"
+    print_checksum(f"{alg.replace('-', '_')}_monte_carlo_checksum", blake2s)
+
+
+# Lengths of the (data, associated data) pairs in test_aegis128x4_long(), which
+# cross the 4 KiB units that the x86 code splits its work into.
+AEGIS128X4_LONG_LENS = ((4097, 0), (8320, 4100), (12345, 129))
+
+
+# Checksum of the (ciphertext, authtag) pairs of test_aegis128x4_long().
+def gen_aegis128x4_long_checksum():
+    blake2s = hashlib.blake2s()
+    for data_len, ad_len in AEGIS128X4_LONG_LENS:
+        pt = rand_bytes(data_len)
+        ad = rand_bytes(ad_len)
+        key = rand_bytes(16)
+        nonce = rand_bytes(16)
+        blake2s.update(aegis128x_encrypt(4, key, nonce, ad, pt, 32))
+    print_checksum("aegis128x4_long_checksum", blake2s)
+
+
+def print_checksum(name, blake2s):
     value = blake2s.digest()
     print(f"static const u8 {name}[BLAKE2S_HASH_SIZE] = {{")
     for i in range(0, len(value), 11):
@@ -62,8 +213,11 @@ def gen_monte_carlo_checksum(alg):
     print("};")
 
 
-if len(sys.argv) != 2 or sys.argv[1] not in ("aes-ccm", "aes-gcm"):
-    sys.stderr.write("Usage: gen-aead-testvecs.py [aes-ccm|aes-gcm]\n")
+ALGS = ("aegis128x4", "aes-ccm", "aes-gcm")
+if len(sys.argv) != 2 or sys.argv[1] not in ALGS:
+    sys.stderr.write(f"Usage: gen-aead-testvecs.py [{'|'.join(ALGS)}]\n")
     sys.exit(1)
 
 gen_monte_carlo_checksum(sys.argv[1])
+if sys.argv[1] == "aegis128x4":
+    gen_aegis128x4_long_checksum()
-- 
2.56.0

