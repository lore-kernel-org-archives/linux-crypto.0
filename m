Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.103
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795855574;
	b=xw8Tdj9hUGI3W2B6K72e/unpJqVOwIUs3O6vDtzzAeesjf6HlKY/2airYVYOQRw+4Y1Y
	 Z9wVM316QTQmKw6W8oqTwbnxeKFoLht+DSO8l93lC6EuBNtRM3inhrVmQ4OaY+8xywhGm
	 Ozi1h54O3d7mTTTYVyaMf+4265aQ7+WTLyf2QuP1426KyFtqHw4dbLPArvUPlGjGG0M+V
	 q/at1QJVtq1IZEDWJENJvdjKeJybL6azPUmFCeoj6TXwO3UYp8LhBTXbTN04wc8nhVclu
	 t+scHWt8MWuhLHQ5PwhfVwX2UYgN50HLlbJlrv6EZVYiOtRrKbPuSMxsHJ24No4UnPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795855574;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=dlTQWiAn3YLfcAJNd1Ndj/7+XyLCIy6l+m0g7G+VOgc=;
	b=gRONjGtsco7NgKqVPWtjwdV+hFracyZyYeqysIZSUlCgFXQ9KbwYhLXIoBV638Ov/t9b
	 gt148neIVgKHIqxeCgOYXYY3TaI0v8JRzPdYPNjqHrtLcEIgny8wgIc9bJZ5rpMQKD7bV
	 2+cIHoJUbHNsCs3aQG0rmq1TuGMoV6eLKK1MXS7qpog83Y2OA45AICQ+2/qFkukQBk/sv
	 j6PoUuQ78qlaU3guvz3kJeAiLfaloUdKMQCmtPoL6yiUxibgKKeAekFXbjRdAOWMkZJvN
	 s+jLP6XaGr5mUpxidVuydhyLg8DslAuEVJopH1KfhA61xoYfnfZIBXqSvFk6FSR2wMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=JBWha1op;
	arc=none smtp.remote-ip=185.70.43.103
Received: from mail-43103.protonmail.ch (mail-43103.protonmail.ch [185.70.43.103])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE297606A31C
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 08:46:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE297606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=JBWha1op
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1795855571; x=1796114771;
	bh=dlTQWiAn3YLfcAJNd1Ndj/7+XyLCIy6l+m0g7G+VOgc=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=JBWha1opf0l/UMQtG05kd5+uLBl7i8XYbDPD2Xk5frakEhZFu89uOyb9/4iYBoerV
	 78wDGEFdBt5dg2Pf4NRZTUDJQuCP/u4IU3J69BMcy69Y6LIU/nNUiC5eRQ0ZM0iupN
	 Y0QaCD0J63BalJac82DlcaE6p9RAF0047c7v8LK8QatYm6bVisHSTbivCQbkJS62f+
	 wJF2Zf92y8o7HH0WwtUMISYvKgWiamd+AVx5mYlnF1bnWKs/94hSjEl78Zln1vHjY/
	 04cKShjD04J0ziV/omBDy8Rv44TCmrHGCzfXv8hqzkPdENvJ90u7OG14rplAAzWGkq
	 KUe5Rq4TkiN4g==
Date: Sat, 28 Nov 2026 08:46:06 +0000
To: Thorsten Blum <blum@kernel.org>
From: Ryan Prinz <rc4d5a@protonmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ryan Prinz <rc4d5a@protonmail.com>
Subject: [PATCH v3] crypto: atmel-ecc - fix missing ECDH public key validation
Message-ID: <20261128084418.2057984-1-rc4d5a@protonmail.com>
In-Reply-To: <awouRON5Mgq6pbhf@kernel.org>
References: <20261125231745.1857056-1-rc4d5a@protonmail.com> <awouRON5Mgq6pbhf@kernel.org>
Feedback-ID: 190731814:user:proton
X-Pm-Message-ID: 2e8a5ce05cd395c37284349127493ff8609cd3fa
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

atmel_ecdh_compute_shared_secret() passes the peer's ECDH public point
to the ATECC508A/608A/608B secure element without validating it; only
req->src_len is checked.

Add the same check to this driver's path, before the point reaches the
I2C command, reusing ecc_is_pubkey_valid_partial().

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC d=
river")
Signed-off-by: Ryan Prinz <rc4d5a@protonmail.com>
---
v3: Shortened the commit message, moving supporting detail below
this line. No functional change.

Both implementations register as crypto_kpp "ecdh-nist-p256"; this
driver's higher cra_priority (300 vs. the generic implementation's
100) is why it's selected instead whenever an Atmel/Microchip ECC
device is bound, so the generic validation never runs for this
driver.

v2: Fixed the crypto/ecdh.c function names (ecdh_compute_value() is
the registered callback; validation happens in
crypto_ecdh_shared_secret()) and dropped the unsupported Bluetooth
SMP reachability claim. (Thorsten Blum)

This has not been tested on hardware. The ATECC608A-TFLXTLS datasheet
(Microchip DS40002138A) describes the ECDH command (opcode 0x43)
combining the stored private key with the input coordinates directly,
with no on-curve or range check documented. Its "Public Key
Validation Support" feature is the Verify command's
Validate/ValidateExternal modes (AN8932), which validate a
persistently stored key against a certificate chain at provisioning
time, which is a different operation from validating the ephemeral
peer public key given as live input here.

Verified by applying this patch to an unmodified kernel tree and
building drivers/crypto/atmel-ecc.o directly (make drivers/crypto/
atmel-ecc.o), confirming it compiles cleanly with no new warnings or
errors. The point validation reuses ecc_is_pubkey_valid_partial()
unmodified. I traced net/bluetooth/ecdh_helper.c's
compute_ecdh_secret() to confirm the src buffer it submits is
big-endian X (32 bytes) || big-endian Y (32 bytes), the same layout
ecdh_compute_value() expects and atmel_i2c_init_ecdh_cmd() already
consumes directly.

AI Disclosure: An AI assistant was used to assist with the
analysis and testing. I have verified the vulnerability, the fix, and
the test results myself and take responsibility for this contribution,
per Documentation/process/coding-assistants.rst.

 drivers/crypto/atmel-ecc.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -19,7 +19,9 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <crypto/internal/kpp.h>
+#include <crypto/ecc_curve.h>
 #include <crypto/ecdh.h>
+#include <crypto/internal/ecc.h>
 #include <crypto/kpp.h>
 #include "atmel-i2c.h"

@@ -146,6 +148,34 @@ static int atmel_ecdh_generate_public_key(struct kpp_r=
equest *req)
 =09return 0;
 }

+static int atmel_ecdh_peer_pubkey_valid(struct scatterlist *src,
+=09=09=09=09=09unsigned int src_len)
+{
+=09const struct ecc_curve *curve =3D ecc_get_curve(ECC_CURVE_NIST_P256);
+=09u8 pubkey_buf[ATMEL_ECC_PUBKEY_SIZE];
+=09u64 x[ECC_CURVE_NIST_P256_DIGITS], y[ECC_CURVE_NIST_P256_DIGITS];
+=09struct ecc_point pk;
+=09size_t copied;
+
+=09if (!curve)
+=09=09return -EINVAL;
+
+=09if (src_len !=3D ATMEL_ECC_PUBKEY_SIZE)
+=09=09return -EINVAL;
+
+=09copied =3D sg_copy_to_buffer(src, sg_nents_for_len(src, src_len),
+=09=09=09=09   pubkey_buf, src_len);
+=09if (copied !=3D src_len)
+=09=09return -EINVAL;
+
+=09ecc_swap_digits(pubkey_buf, x, ECC_CURVE_NIST_P256_DIGITS);
+=09ecc_swap_digits(pubkey_buf + ATMEL_ECC_NIST_P256_N_SIZE, y,
+=09=09=09ECC_CURVE_NIST_P256_DIGITS);
+=09pk =3D ECC_POINT_INIT(x, y, ECC_CURVE_NIST_P256_DIGITS);
+
+=09return ecc_is_pubkey_valid_partial(curve, &pk);
+}
+
 static int atmel_ecdh_compute_shared_secret(struct kpp_request *req)
 {
 =09struct crypto_kpp *tfm =3D crypto_kpp_reqtfm(req);
@@ -166,6 +196,10 @@ static int atmel_ecdh_compute_shared_secret(struct kpp=
_request *req)
 =09if (req->src_len !=3D ATMEL_ECC_PUBKEY_SIZE)
 =09=09return -EINVAL;

+=09ret =3D atmel_ecdh_peer_pubkey_valid(req->src, req->src_len);
+=09if (ret)
+=09=09return ret;
+
 =09gfp =3D (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ? GFP_KERNEL :
 =09=09=09=09=09=09=09     GFP_ATOMIC;

--
2.51.2

