Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795648737;
	b=dBx4mzAGWt0OigMP6WDF8UiIhK7wFUpo44d17SzfxzGPLwPpEVHh2cbrh2KTpKt2hm3x
	 0adaeSbrQkz47Mm3DFJ1DJ2R4bQZBcdXmJ2mR/kbiP9ebA8MNKbLHhb9gZq7fG+umh37m
	 yykdnMNQ7Xde4k9StcT+BtOMezdCGQcCB21m6ROB9G4qybX1+b+hosiYjXKzjeDDUEIdm
	 AYWZgTs52B8cxCFWoSOBamaRg187Xnp4fLPOE++Of7r6AW/bbEDOnp+k4Pdb205LC+2Q9
	 UvaAoxNh21bx/5ULNf7+efNBJOC0iv8F2co0EUCv+Tbl4z2gz2pfHWDpgY/VwlPe6Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795648737;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=YWWKvDKRDn1hHUowo2at1VmbK3immV9LxoHiyGmdb+c=;
	b=BYmgXjEwQQGYolBl3pu3sqw8Pr/8R34zLVI+GBySN84F8tAha04M1bzhlODQljc9wCyQ
	 msLgKNVdlB8cXPWHaOKGwy2TVUbO/ZLPnT2vJe9oeBGRXl7VuCBEzY3b0USkSVTdch0xZ
	 QxdSwHfWehlmPGyBRqYEMAxpedOwL5FGCNpeXotGpUtpiLCuNgZuIpWD0rWPt3Pv3DL4n
	 cUBrT4Td8EeI3JCtRy7K0fImJ3HXDzbGAbVv29FF9abZltFKI7BpsJw69dFDA6B/3EpR9
	 naJeXLN8XaMoUe4NBAmWizUcIrK3amVdmnYXN2B1l5Y4l+wN6vdrVFDViSQrzC3LGUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=DVqfc+LJ;
	arc=none smtp.remote-ip=109.224.244.17
Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123DD606A321
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 23:18:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 123DD606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=DVqfc+LJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1795648729; x=1795907929;
	bh=YWWKvDKRDn1hHUowo2at1VmbK3immV9LxoHiyGmdb+c=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=DVqfc+LJQLHNj73WRDjy5ay/WFUh79BHwYwf0R/xgKBloYMTRLHhAGCCnCMR4QDJX
	 RPnpKlAshqyzyw3zj/dM3TW8yC8JfbR4wDNm8RQOaEyuzKjFP7yEsa0jfwEK9RzVgy
	 KuGTLk6fqCobmKfiR2fbupApcasZqVpOJRcpaN55bu/bpSvhRbL+31hrQ31VjotbBh
	 myLOwvb1qIbD13T/2/CQOqNdkQfnmDHblxQUk1AmzulOJ8BbhqPxjvYDF1Kyg7rSdU
	 MUJ59E7i3LyskV4CCLHlPgp33vktzvXwKyfqAbK/Dk/+2DcsNQlxL81BE4Wkv3zM+J
	 cx5tD3muPLmUw==
Date: Wed, 25 Nov 2026 23:18:43 +0000
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
From: Ryan Prinz <rc4d5a@protonmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Zhiqi Song <songzhiqi1@huawei.com>, Longfang Liu <liulongfang@huawei.com>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ryan Prinz <rc4d5a@protonmail.com>
Subject: [PATCH] crypto: dh - add shared DH public key range check
Message-ID: <20261125231825.1857253-1-rc4d5a@protonmail.com>
Feedback-ID: 190731814:user:proton
X-Pm-Message-ID: fa848d53e2077f708d61559a1ec3e8e5ae28a36d
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

Add a shared helper for the DH public key range check from SP800-56A
rev3 5.6.2.3.2 (2 <=3D y <=3D p - 2), operating on raw big-endian buffers.
Any "dh" backend can call this instead of carrying its own copy.

Zero-padding the peer's value and computing p - 1 stay the caller's
job, since that depends on how each backend already has the data;
only the comparison itself lives here.

Signed-off-by: Ryan Prinz <rc4d5a@protonmail.com>
---
Verified by building crypto/dh_helper.o directly, confirming it
compiles cleanly with no new warnings or errors. Also verified with a
standalone build of the function under AddressSanitizer/UBSan,
exercising y =3D 0, 1, 2, p-2, p-1, p, a value larger than p, and an
ordinary interior value, each at both a multi-byte and a single-byte
p_size, plus p_size =3D 0 itself. All cases produced the expected
accept/reject result with no sanitizer reports.

AI Disclosure: An AI assistant was used to assist with the
analysis and testing. I have verified the fix and the test results
myself and take responsibility for this contribution, per
Documentation/process/coding-assistants.rst.

 crypto/dh_helper.c     | 32 ++++++++++++++++++++++++++++++++
 include/crypto/dh.h    | 22 ++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/crypto/dh_helper.c b/crypto/dh_helper.c
--- a/crypto/dh_helper.c
+++ b/crypto/dh_helper.c
@@ -91,6 +91,38 @@ int crypto_dh_encode_key(char *buf, unsigned int len, co=
nst struct dh *params)
 =09return 0;
 }

+/*
+ * Partial public key validation check from SP800-56A rev3 section
+ * 5.6.2.3.2: a DH public value is invalid unless 2 <=3D y <=3D p - 2.
+ * Does not depend on FIPS mode.
+ *
+ * @y and @p_minus_1 must both already be exactly @p_size bytes,
+ * big-endian; callers are responsible for zero-extending a shorter
+ * public value before calling this function.
+ */
+bool crypto_dh_pubkey_in_range(const u8 *y, const u8 *p_minus_1,
+=09=09=09       unsigned int p_size)
+{
+=09bool is_zero_or_one =3D true;
+=09unsigned int i;
+
+=09if (!p_size)
+=09=09return false;
+
+=09for (i =3D 0; i < p_size - 1; i++) {
+=09=09if (y[i]) {
+=09=09=09is_zero_or_one =3D false;
+=09=09=09break;
+=09=09}
+=09}
+
+=09if (is_zero_or_one && y[p_size - 1] <=3D 1)
+=09=09return false;
+
+=09return memcmp(y, p_minus_1, p_size) < 0;
+}
+EXPORT_SYMBOL_GPL(crypto_dh_pubkey_in_range);
+
 int crypto_dh_decode_key(const char *buf, unsigned int len, struct dh *par=
ams)
 {
 =09int err;
diff --git a/include/crypto/dh.h b/include/crypto/dh.h
--- a/include/crypto/dh.h
+++ b/include/crypto/dh.h
@@ -95,4 +95,26 @@ int crypto_dh_decode_key(const char *buf, unsigned int l=
en, struct dh *params)
 int __crypto_dh_decode_key(const char *buf, unsigned int len,
 =09=09=09   struct dh *params);

+/**
+ * crypto_dh_pubkey_in_range() - range-check a DH public value
+ * @y:=09=09Big-endian public value to check, zero-padded to @p_size
+ *=09=09bytes by the caller
+ * @p_minus_1:=09Big-endian (p - 1) for the same group as @y, @p_size byte=
s
+ * @p_size:=09Size of both @y and @p_minus_1 in bytes
+ *
+ * This is the partial public key validation check from SP800-56A rev3
+ * section 5.6.2.3.2: a DH public value is invalid unless 2 <=3D y <=3D p =
- 2.
+ * It does not depend on FIPS mode and is meant to be used by any backend
+ * that implements the "dh" kpp algorithm, hardware or software, so the
+ * check does not have to be reimplemented per backend.
+ *
+ * Both buffers must already be exactly @p_size bytes; callers are
+ * responsible for zero-extending a shorter public value before calling
+ * this function.
+ *
+ * Return: true if 2 <=3D y <=3D p - 2, false otherwise.
+ */
+bool crypto_dh_pubkey_in_range(const u8 *y, const u8 *p_minus_1,
+=09=09=09       unsigned int p_size);
+
 #endif
--=20
2.51.2

