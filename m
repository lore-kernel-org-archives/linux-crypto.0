Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6923B059F
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 15:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785340288; cv=none; b=W25gXGYEgYnouubiEVsfh/fmH1NAdCYAlnrJiUm2OEbzy/TG0m9zR5DdDNFjgSwwy/qhlnytVHSlurtvqjXqVvDxvY3C0m7Jm958XsLU2cgzQ9jfGbbij4HyVQDHcx/Y4p8ZKefw4I8dUrkU+t/tN6cK99puoGTYOxkiq2DpgvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785340288; c=relaxed/simple;
	bh=fUukMHp5tStisc4UzhTeF1WYXczt5exOKWZEDDItiFk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=J02gGPe2la56hmh+3NMMNjAIT7d5RJvGq/9OxfVdCapbMWFeo2bV6NLbkt3BTGpU7mTS/NhWFnlaS+Cd9oV0Bl8Hm4IgZ4rY2zxA4DoDEB8L1oLTph7VfTeeQtn+hfqpaR+WXr0BnXOaNKgukNFeLJV70kCD7LPR2vrdee6gzAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=P3bWZxQ3; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="P3bWZxQ3"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 07BDD4E40FB5;
	Wed, 29 Jul 2026 15:51:25 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id BDDB96039A;
	Wed, 29 Jul 2026 15:51:24 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6D9AB11C15059;
	Wed, 29 Jul 2026 17:51:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1785340280; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=ZPXTabHkhz0UXMndbv8m7Il/GNF0gmMhCwSWDgdzz7E=;
	b=P3bWZxQ3YyzihwRlTfGTySMwo3a8JGF4af8Z3YrVNJz50Hb28C21mCfGJDIMlR55cZFDIY
	ZT+naoSeuM3stya1pUR1gmQbSVLDuMCNiRkyMre0Vhmuokm1hxexOlLHoJILPFCK5UT4nb
	uzkl0MFIpu2+bnXkHBaTVzo6xELeqF3Nc+lgNF/3MKiKH8AJZxnjEMDN0GwjtLcYKlOK2z
	pEiwlOyCNaqzEWMNFe8ISXTbCWD4w/+v0JXhO31Eryctjj0HuAZBGTvBUmLjf6bXTa9HdR
	+uqEkCay79N27ZDgoIVM9wuJ/39btV/LsnJwed12arZ6HhsaiZgQVYAlo+zLgQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Wed, 29 Jul 2026 17:51:04 +0200
Subject: [PATCH] crypto: ecc - Add NIST P224 curve parameters
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-add-nist-p224-curve-v1-1-334dfbe16683@bootlin.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMPQ6DMAxA4asgz7UEFgqlV0Ed8mPAHVIUQ4SEu
 DspHb/hvQOUk7DCqzogcRaVbyxoHhX42caJUUIxUE2m7qhHGwJG0RUXohb9ljLj0zTk2j4YZwl
 KuSQeZb+vw/tv3dyH/fpbwXlerL+0sncAAAA=
X-Change-ID: 20260729-add-nist-p224-curve-8612b49d6ba2
To: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>, 
 Stefan Berger <stefanb@linux.ibm.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785340275; l=3072;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=fUukMHp5tStisc4UzhTeF1WYXczt5exOKWZEDDItiFk=;
 b=vQSm2ByYkYK9hjOqevmnFMAr08mT+o6BGNJGSt+QHkuN7Ywf3RZVc7paEGBdyEhAdUu5uA05O
 asUSmhQZZWvASuJHA3GXW5e91B1pR/rjOQBmiZRivmUJM66D33vuD0n
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Add the parameters for the NIST P224 curve and define a new curve ID for
it. Make the curve available in ecc_get_curve().

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 crypto/ecc.c            |  2 ++
 crypto/ecc_curve_defs.h | 27 +++++++++++++++++++++++++++
 include/crypto/ecdh.h   |  7 ++++---
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 6eb4d97a5f0d..6aa007420ab4 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -56,6 +56,8 @@ const struct ecc_curve *ecc_get_curve(unsigned int curve_id)
 	/* In FIPS mode only allow P256 and higher */
 	case ECC_CURVE_NIST_P192:
 		return fips_enabled ? NULL : &nist_p192;
+	case ECC_CURVE_NIST_P224:
+		return &nist_p224;
 	case ECC_CURVE_NIST_P256:
 		return &nist_p256;
 	case ECC_CURVE_NIST_P384:
diff --git a/crypto/ecc_curve_defs.h b/crypto/ecc_curve_defs.h
index 0ecade7d02f5..c67b73f2cd5a 100644
--- a/crypto/ecc_curve_defs.h
+++ b/crypto/ecc_curve_defs.h
@@ -29,6 +29,33 @@ static struct ecc_curve nist_p192 = {
 	.b = nist_p192_b
 };
 
+/* NIST P-224: a = p - 3 */
+static u64 nist_p224_g_x[] = { 0x115c1d21ull, 0x56c21122343280d6ull,
+			       0x321390b94a03c1d3ull, 0xb70e0cbd6bb4bf7full };
+static u64 nist_p224_g_y[] = { 0x85007e34ull, 0x5a07476444d58199ull,
+			       0x4c22dfe6cd4375a0ull, 0xbd376388b5f723fbull };
+static u64 nist_p224_p[] = { 0x00000001ull, 0x0000000000000000ull,
+			     0xffffffffffffffffull, 0xffffffffffffffffull };
+static u64 nist_p224_n[] = { 0x5c5c2a3dull, 0xe0b8f03e13dd2945ull,
+			     0xffffffffffff16a2ull, 0xffffffffffffffffull };
+static u64 nist_p224_a[] = { 0xfffffffeull, 0xffffffffffffffffull,
+			     0xfffffffffffffffeull, 0xffffffffffffffffull };
+static u64 nist_p224_b[] = { 0x2355ffb4ull, 0xd7bfd8ba270b3943ull,
+			     0xf54132565044b0b7ull, 0xb4050a850c04b3abull };
+static struct ecc_curve nist_p224 = {
+	.name = "nist_224",
+	.nbits = 224,
+	.g = {
+		.x = nist_p224_g_x,
+		.y = nist_p224_g_y,
+		.ndigits = 4,
+	},
+	.p = nist_p224_p,
+	.n = nist_p224_n,
+	.a = nist_p224_a,
+	.b = nist_p224_b
+};
+
 /* NIST P-256: a = p - 3 */
 static u64 nist_p256_g_x[] = { 0xF4A13945D898C296ull, 0x77037D812DEB33A0ull,
 				0xF8BCE6E563A440F2ull, 0x6B17D1F2E12C4247ull };
diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
index 9784ecdd2fb4..07e0d3058f5f 100644
--- a/include/crypto/ecdh.h
+++ b/include/crypto/ecdh.h
@@ -24,9 +24,10 @@
 
 /* Curves IDs */
 #define ECC_CURVE_NIST_P192	0x0001
-#define ECC_CURVE_NIST_P256	0x0002
-#define ECC_CURVE_NIST_P384	0x0003
-#define ECC_CURVE_NIST_P521	0x0004
+#define ECC_CURVE_NIST_P224	0x0002
+#define ECC_CURVE_NIST_P256	0x0003
+#define ECC_CURVE_NIST_P384	0x0004
+#define ECC_CURVE_NIST_P521	0x0005
 
 /**
  * struct ecdh - define an ECDH private key

---
base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
change-id: 20260729-add-nist-p224-curve-8612b49d6ba2

Best regards,
--  
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

