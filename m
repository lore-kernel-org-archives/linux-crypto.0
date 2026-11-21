Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795256309;
	b=eIg5dYrgQ5OMPh7ZqfIkUwO9iKS0FIhOmg3nVdtL+yZ9dpQdAs7kYskIOmJ1BmQhVnTu
	 EuGffMqS5ya930oiJAtcaoD9UpRTsn8Pn3r6X5LxQX7lyG9WhHkc/vXo7jqNiJU/BVgEi
	 OYs5huBKsmPVk7GRXt5PoZiQt/rEPhTYT0B4K1GG+lR6aY/qoMD23QquoXVoKktgpERIc
	 Scke7u42Zf4FPACxKrRemIVvNoNOvp0uavuhVK+xbSI6cww7qLm5z757LNXO6+FJG41D5
	 f2s88lxH/MdyefOUgzaFNBtlaix3pn067lIdgY0LLJru93K5F9UB6tQjB6lkD14rtew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795256309;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=ybCiBiLC+wMkxHxvSe2Dz7VO4d0TKq7kRkdKiMWCjnc=;
	b=hXWv6k9m4GgvsnPXXh146irZbhIOHrdC29hrIJCpwtQ0Zhr4+N/JafvTVdxsJ+8LYYSp
	 ULSzKoig9TCBaf7Z6I+2CcDGjKAMAn2kQDjy9IYqvYzsOSHYm3A9d4HTCIFedoPCZnVBX
	 fWLmxljD2CtUCmxN7gsfimSiAB02+fyh/4zRG3LPalWjlvx68f2MXfyO8LJLndjzlpqs3
	 UCDZOUq9xeOM/xjdF56eaF+MR2ey/TKZAgDxqRzjHp9+9vh2y1cDoDPledo6WaIoaMuOo
	 CGhLREXHPb9FbaNLkFjfa/0KP7jy7rMzyIh1kWCt2xMshjUZOoym0sxCZLyxfu5XV2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0CR70O6z;
	arc=none smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74CA606A32A
	for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 10:18:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D74CA606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0CR70O6z
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e9ae391a05so11629145ad.1
        for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 02:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795256308; x=1795861108; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ybCiBiLC+wMkxHxvSe2Dz7VO4d0TKq7kRkdKiMWCjnc=;
        b=0CR70O6zM57iqUKWetRzT5oUBSl2GhokaGg/cpikzwOYvOOqilYqTDL+Y9GagQrMkp
         Nh8KfKaOqOTCVY/1NGh3tJNyA7Ja5KcdTT9BUXtnhPUA3eVZJW5GmngU7I3CZBngAqAu
         EqkD2jTb//499zm/oua+Mh4bxNDRqSS5W/dTasJ01XbWyEylNzMeKHRGpZZsG2XapDuk
         0u9uV7FtpXkXpb1dN3wGqYQDtCCsUrnuTsCGcSKRWSbebDqk7AbelvQ/3lmHUjZmE7x4
         dKupWOxjwdnawW6im8C/yy7DjB6rscufQMn+y1eYtq9DM0mMznsoVopI1qURUl3TKSpU
         w9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795256308; x=1795861108;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ybCiBiLC+wMkxHxvSe2Dz7VO4d0TKq7kRkdKiMWCjnc=;
        b=XwLcJ5OWn7DgnrYOWpSMuApPr0Z6r2v5sCqZCy6K2AfeLSlLwX7EEBrC3FCEsPUMPJ
         amFC5NUSLoYOy0H9VNCbvRosdm7gyuE/CMnz6lFBxO1Bb6yMQ39CesYDNu3USc9EJBBp
         75oHRlp2VuAtYH+F1BfWx0BBjiiLRC/w7j0LwH0VsBOjBQi8U702gebbCKbLQdxis4E9
         UkOVhLmwY/t6OXwM7eTkxPyBZw0KTGBBC1wGyOYUWGhwn8OauC3PvxzqKTrAGBy/dg+Y
         39ynSuFUPwj0O6VNbpbCEUCvY2xjYTJe9xRInLUNet2YFTxqIoAkVtBKT+OqtXo9mZJo
         iPLw==
X-Gm-Message-State: APuU4Z/+fLfEpudELfwHDha8mFnhYNYHe10jyzTXGnz4MoAvQoinrX+m
	cOKQGKrC7xQJKTt/C0vqc6BGcrarfnc+vbk9xONS1PrROTo86+DsEt4wteex0SyC
X-Gm-Gg: AZFdTZf6eBxsMaR6uni5MpSLMvFiJDzwEFJm8hWanfv7g0SyOxMnrS8N7VV61aXCnMC
	KnDWIvG+BMW2RmLyOP8YNGuYhHilwTTieuZxHEoEZAo7ZBy9YVfiSl0xCw7QrIeI+iZ4NTyVrdg
	OojcIXCSl4n5ji4Oag2PcStyy9ILGmDbEVSYO+Z7zOx3XM2oC4Ll31KOXNbdCLZv8MLfVS/tJOs
	0MQQrQixdappLnX/n1rZwQCEex3iVc+lOURaupSmNJ4Ik9/5Xb6Y+V/q2GqIHddvpNTBBf8CMeQ
	pJ9VzkHjbnqWMaBXt8j+9wPtdfwQSMWSusGsXoDUicGBim1eZMPySKsSdOUlAVKKxR+XgdtKzqt
	Jh3pMik75+GkNHGO8b2ANcqU4fv/jemeY8IqYo/rmaKsbHXLUpkWAnDCbiClcSbNFEs6Qw42fxu
	P86skEmIqED9eNZcTBjJpwbt22cj16yiLDJ9x4YjlevqXxnogZFuO7qPn05b5ieOWOZvi5KUTPz
	g0JH5815Zx6zV92Ejx950fCrC20PwnJaeII3nyWFRKrLKXeZ9pCsCbJBCeVYl+cQWHzwK16ewAH
	GioBkMT1kKoNXJ7eVuiVuLsTmWKGxqrQ/qolV7FoemKwq9N83ZEJXofaZHrXxwM2k6oA4K+Ac7q
	o4g7ZeKfBmSVlHgDQh4NQvoqpjDIc
X-Received: by 2002:a17:903:1545:b0:2e9:5598:d182 with SMTP id d9443c01a7336-2f031eab286mr53575105ad.15.1795256307921;
        Sat, 21 Nov 2026 02:18:27 -0800 (PST)
Received: from patch.eml (awork078078.netvigator.com. [203.198.250.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0dc0f8sm24859755ad.27.2026.11.21.02.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 02:18:27 -0800 (PST)
From: Yuqi Xu <xuyuqiabc@gmail.com>
To: linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
 Ignat Korchagin <ignat@linux.win>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Rusty Russell <rusty@rustcorp.com.au>, stable@vger.kernel.org,
 Vega <vega@nebusec.ai>, Ren Wei <weir@nebusec.ai>, xuyq21@lenovo.com
Subject: [PATCH v5] KEYS: Account for asymmetric key payload data in the quota
Date: Sat, 21 Nov 2026 18:18:05 +0800
Message-ID: <20261121181805.58538-1-xuyuqiabc@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

add_key("asymmetric", ...) preparses the supplied blob and then
instantiates the key with generic_key_instantiate(), which charges
prep->quotalen to the owning user's key quota through
key_payload_reserve().

pkcs8_parse() duplicates the attacker-controlled PrivateKey OCTET
STRING with kmemdup() into pub->key. pkcs8_key_preparse() stores that
object in the asymmetric-key payload but hard-codes prep->quotalen to
100, so the quota records 100 bytes regardless of the retained private
key size. The ASN.1 decoder accepts blobs up to 65535 bytes, so one
key can pin about 64 KiB while consuming 100 quota bytes. With the
default non-root limits (200 keys / 20000 bytes) a user can retain
roughly 12 MiB instead of the 20 KiB the limit is meant to allow.

x509_key_preparse() keeps the parsed public key, its parameters, the
signature and the authority key IDs, but also charges a fixed 100
bytes. PKCS#8 later repeated the same fixed-100 accounting. The same
add_key() call reaches the X.509 parser, so fixing only PKCS#8 would
leave the bypass reachable.

Charge the size of the retained payload instead. An oversized PKCS#8
key now fails with -EDQUOT instead of being accepted for 100 bytes,
and the same applies to an X.509 certificate that retains an oversized
public key or set of authority key IDs.

A charge which does not fit in unsigned short is rejected, because
key_payload_reserve() keeps the full delta in the user counter and
refunds only the truncated key->quotalen. The asymmetric parsers reject
such a charge before installing the payload; put the same guard in
key_payload_reserve() so every key type is covered, not only the
asymmetric parsers. The guard also applies to other key types that use
the same field, including big_key updates and keyring link accounting:
a charge that would exceed USHRT_MAX bytes now fails instead of
wrapping the counter. key_alloc() also charges the key description to
the same field, so the effective description length is part of the
check.

Measured on v7.3-rc1 (10396a2d6d41), 2 vCPU / 2 GiB QEMU guest, as uid
1000, adding PKCS#8 keys with a 65000-byte PrivateKey field. Before
the patch, 176 keys were retained (about 11.4 MiB) while
/proc/key-users charged only 19712 bytes. After the patch the
oversized key is rejected immediately, and a 200-byte PrivateKey still
loads and is charged 264 bytes. A small X.509 certificate whose only
large object is a 26000-byte authorityKeyIdentifier is likewise
rejected, while the unpatched kernel accepted it and charged 109
bytes.

Fixes: c26fd69fa009 ("X.509: Add a crypto key parser for binary (DER) X.509 c=
ertificates")
Fixes: 3c58b2362ba8 ("KEYS: Implement PKCS#8 RSA Private Key parser [ver #2]")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Reviewed-by: Ren Wei <weir@nebusec.ai>
---
Changes in v5:
 - Ignat Korchagin: add the missing PKCS#8 Fixes tag.
 - Ignat Korchagin: add the USHRT_MAX guard to key_payload_reserve()
   so every key type is covered, not only the asymmetric parsers.
 - v4 Link: https://lore.kernel.org/all/20261026024840.23482-1-xuyuqiabc@gmai=
l.com/

Changes in v4:
 - Sashiko (High): "keys: integer truncation of key->quotalen causes
   permanent quota leak" on key_alloc() and key_payload_reserve().
   Include the effective key description length in the USHRT_MAX
   limit. key_alloc() and key_payload_reserve() add the description
   and the payload to the same unsigned short field, so checking the
   payload alone was not enough.
 - v3 Link: https://lore.kernel.org/all/20261019041314.48569-1-xuyuqiabc@gmai=
l.com/

Changes in v3:
 - Sashiko (High): "keys: integer truncation of key->quotalen causes
   permanent quota leak" on pkcs8_key_preparse() and
   x509_key_preparse(). A payload charge above USHRT_MAX is rejected
   with -EINVAL before the payload is installed. key_payload_reserve()
   keeps the full delta in the user quota and refunds only the
   truncated key->quotalen, so that charge would leak quota.
 - Reposted so Sashiko records a review against this Message-ID, as
   requested by Herbert Xu. v2 was posted and Ignat Korchagin replied.
 - v2 Link: https://lore.kernel.org/all/4a0b2e00f5cc62c173a01fec2f56eab1b04d7=
0bb.1790568982.git.xuyuqiabc@gmail.com/

Changes in v2:
 - Move the bug details and the measured quota numbers into this
   commit message, as requested by Ignat Korchagin.
 - Sashiko (High): "keys: integer truncation in key->quotalen causes
   permanent quota leak" on pkcs8_key_preparse() and
   x509_key_preparse(). Not changed in v2. The same finding is
   addressed in v3 and v4.
 - v1 Link: https://lore.kernel.org/all/cover.1789801335.git.xuyuqiabc@gmail.=
com/

 crypto/asymmetric_keys/pkcs8_parser.c    | 18 ++++++++++-
 crypto/asymmetric_keys/x509_public_key.c | 38 ++++++++++++++++++++++--
 security/keys/key.c                      | 16 ++++++++--
 3 files changed, 66 insertions(+), 6 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs8_parser.c b/crypto/asymmetric_keys/p=
kcs8_parser.c
index 9dd1c181789a..db2d57489d96 100644
--- a/crypto/asymmetric_keys/pkcs8_parser.c
+++ b/crypto/asymmetric_keys/pkcs8_parser.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/err.h>
 #include <linux/oid_registry.h>
 #include <keys/asymmetric-subtype.h>
@@ -136,6 +137,8 @@ static struct public_key *pkcs8_parse(const void *data, s=
ize_t datalen)
 static int pkcs8_key_preparse(struct key_preparsed_payload *prep)
 {
 	struct public_key *pub;
+	const char *description;
+	size_t desclen, quotalen;
=20
 	pub =3D pkcs8_parse(prep->data, prep->datalen);
 	if (IS_ERR(pub))
@@ -144,13 +147,26 @@ static int pkcs8_key_preparse(struct key_preparsed_payl=
oad *prep)
 	pr_devel("Cert Key Algo: %s\n", pub->pkey_algo);
 	pub->id_type =3D "PKCS8";
=20
+	/*
+	 * key_alloc() charges the description to the same unsigned short
+	 * field that key_payload_reserve() later adds the payload to.
+	 */
+	description =3D prep->orig_description ?: prep->description;
+	desclen =3D description ? strlen(description) + 1 : 0;
+
+	quotalen =3D sizeof(*pub) + pub->keylen;
+	if (desclen > USHRT_MAX || quotalen > USHRT_MAX - desclen) {
+		public_key_free(pub);
+		return -EINVAL;
+	}
+
 	/* We're pinning the module by being linked against it */
 	__module_get(public_key_subtype.owner);
 	prep->payload.data[asym_subtype] =3D &public_key_subtype;
 	prep->payload.data[asym_key_ids] =3D NULL;
 	prep->payload.data[asym_crypto] =3D pub;
 	prep->payload.data[asym_auth] =3D NULL;
-	prep->quotalen =3D 100;
+	prep->quotalen =3D quotalen;
 	return 0;
 }
=20
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_key=
s/x509_public_key.c
index 25cf8ac7f257..4a9c85277ce0 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -163,9 +163,11 @@ static int x509_key_preparse(struct key_preparsed_payloa=
d *prep)
 {
 	struct x509_certificate *cert __free(x509_free_certificate) =3D NULL;
 	struct asymmetric_key_ids *kids __free(kfree) =3D NULL;
+	struct asymmetric_key_id *id;
 	char *p, *desc __free(kfree) =3D NULL;
-	const char *q;
-	size_t srlen, sulen;
+	const char *description, *q;
+	size_t desclen, srlen, sulen, quotalen;
+	int i;
=20
 	cert =3D x509_cert_parse(prep->data, prep->datalen);
 	if (IS_ERR(cert))
@@ -221,6 +223,36 @@ static int x509_key_preparse(struct key_preparsed_payloa=
d *prep)
 	if (IS_ERR(kids->id[2]))
 		return PTR_ERR(kids->id[2]);
=20
+	/* Charge the memory retained in the payload, not a fixed estimate */
+	quotalen =3D sizeof(*cert->pub) + cert->pub->keylen +
+		   cert->pub->paramlen;
+	if (cert->sig) {
+		quotalen +=3D sizeof(*cert->sig) + cert->sig->s_size;
+		if (cert->sig->m_free)
+			quotalen +=3D cert->sig->m_size;
+		for (i =3D 0; i < ARRAY_SIZE(cert->sig->auth_ids); i++) {
+			id =3D cert->sig->auth_ids[i];
+			if (id)
+				quotalen +=3D sizeof(*id) + id->len;
+		}
+	}
+	quotalen +=3D sizeof(*kids);
+	for (i =3D 0; i < ARRAY_SIZE(kids->id); i++) {
+		id =3D kids->id[i];
+		if (id)
+			quotalen +=3D sizeof(*id) + id->len;
+	}
+	/*
+	 * key_alloc() charges the description to the same unsigned short
+	 * field that key_payload_reserve() later adds the payload to.
+	 */
+	description =3D prep->orig_description ?: desc;
+	desclen =3D strlen(description) + 1;
+	if (desclen > USHRT_MAX || quotalen > USHRT_MAX - desclen) {
+		kfree(kids->id[2]);
+		return -EINVAL;
+	}
+
 	/* We're pinning the module by being linked against it */
 	__module_get(public_key_subtype.owner);
 	prep->payload.data[asym_subtype] =3D &public_key_subtype;
@@ -228,7 +260,7 @@ static int x509_key_preparse(struct key_preparsed_payload=
 *prep)
 	prep->payload.data[asym_crypto] =3D cert->pub;
 	prep->payload.data[asym_auth] =3D cert->sig;
 	prep->description =3D desc;
-	prep->quotalen =3D 100;
+	prep->quotalen =3D quotalen;
=20
 	/* We've finished with the certificate */
 	cert->pub =3D NULL;
diff --git a/security/keys/key.c b/security/keys/key.c
index b34a64d81d47..3f6886844089 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -373,11 +373,17 @@ EXPORT_SYMBOL(key_alloc);
  */
 int key_payload_reserve(struct key *key, size_t datalen)
 {
-	int delta =3D (int)datalen - key->datalen;
+	int delta;
 	int ret =3D 0;
=20
 	key_check(key);
=20
+	/* key->quotalen is an unsigned short and cannot represent this. */
+	if (test_bit(KEY_FLAG_IN_QUOTA, &key->flags) && datalen > USHRT_MAX)
+		return -EDQUOT;
+
+	delta =3D (int)datalen - key->datalen;
+
 	/* contemplate the quota adjustment */
 	if (delta !=3D 0 && test_bit(KEY_FLAG_IN_QUOTA, &key->flags)) {
 		unsigned maxbytes =3D uid_eq(key->user->uid, GLOBAL_ROOT_UID) ?
@@ -386,9 +392,15 @@ int key_payload_reserve(struct key *key, size_t datalen)
=20
 		spin_lock_irqsave(&key->user->lock, flags);
=20
+		/*
+		 * key->quotalen is an unsigned short.  Reject a charge that
+		 * would wrap it; key_put() refunds only the stored value, so
+		 * a wrap would leak quota.
+		 */
 		if (delta > 0 &&
 		    (key->user->qnbytes + delta > maxbytes ||
-		     key->user->qnbytes + delta < key->user->qnbytes)) {
+		     key->user->qnbytes + delta < key->user->qnbytes ||
+		     (size_t)key->quotalen + delta > USHRT_MAX)) {
 			ret =3D -EDQUOT;
 		}
 		else {
--=20
2.56.1


