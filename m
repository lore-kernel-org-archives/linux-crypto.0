Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6B110957
	for <linux-crypto@vger.kernel.org>; Thu, 12 Jun 2025 03:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749698209; cv=none; b=eq14bqV4hxoeAXvN9+vm1y8AbPuGDjNqjHUEMOgmgcjT/UwnIrs7Ba3j3h00T09MS6V8RUDkncLG7aBIh1kvinidskJ/qEVuEcm7AjqYrijqswWqT84DL5WwvqT3lvrsqVn6QjO0QBYSu9b0PkwT93vYT6/TzDMHYqh80u+ipZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749698209; c=relaxed/simple;
	bh=sWoFWozHKTaF0WU46uVJnEcDppru2KkQ7fyi0DQiIsw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IphV5rlms6y7ooCpoklT1lr7SRPKHMU5BTZXl9K21SImB/O7PRq/A8QdknnOZs5Zr1ANClE+TSBdXr0qXnTQIzL9/JwEgfK9Bd4TlWaODMcOFJWtEImB2zd+0Iygyc/yggGKU6iutVGXZEb2elA8p/DLLx6Eo4vHaaN3lugUqCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1749697461-1eb14e386e395790001-Xm9f1P
Received: from ZXSHMBX2.zhaoxin.com (ZXSHMBX2.zhaoxin.com [10.28.252.164]) by mx2.zhaoxin.com with ESMTP id yY0hS9Df4QX84M3m (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Thu, 12 Jun 2025 11:04:21 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX2.zhaoxin.com
 (10.28.252.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Thu, 12 Jun
 2025 11:04:21 +0800
Received: from ZXSHMBX1.zhaoxin.com ([::1]) by ZXSHMBX1.zhaoxin.com
 ([fe80::2c07:394e:4919:4dc1%7]) with mapi id 15.01.2507.044; Thu, 12 Jun 2025
 11:04:21 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from DESKTOP-A4I8D8T.zhaoxin.com (10.32.65.156) by
 ZXBJMBX02.zhaoxin.com (10.29.252.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 12 Jun 2025 10:57:55 +0800
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <CobeChen@zhaoxin.com>, <TonyWWang-oc@zhaoxin.com>, <YunShen@zhaoxin.com>,
	<GeorgeXue@zhaoxin.com>, <LeoLiu-oc@zhaoxin.com>, <HansHu@zhaoxin.com>,
	AlanSong-oc <AlanSong-oc@zhaoxin.com>
Subject: [PATCH RESEND] crypto: padlock-sha - Add support for Zhaoxin processor
Date: Thu, 12 Jun 2025 10:55:18 +0800
X-ASG-Orig-Subj: [PATCH RESEND] crypto: padlock-sha - Add support for Zhaoxin processor
Message-ID: <20250612025516.368-1-AlanSong-oc@zhaoxin.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 6/12/2025 11:04:20 AM
X-Barracuda-Connect: ZXSHMBX2.zhaoxin.com[10.28.252.164]
X-Barracuda-Start-Time: 1749697461
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 8768
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.142737
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

For Zhaoxin processors, the XSHA1 instruction requires the total memory
allocated at %rdi register must be 32 bytes, while the XSHA1 and
XSHA256 instruction doesn't perform any operation when %ecx is zero.

Due to these requirements, the current padlock-sha driver does not work
correctly with Zhaoxin processors. It cannot pass the self-tests and
therefore does not activate the driver on Zhaoxin processors. This issue
has been reported in Debian [1]. The self-tests fail with the
following messages [2]:

alg: shash: sha1-padlock-nano test failed (wrong result) on test vector 0, =
cfg=3D"init+update+final aligned buffer"
alg: self-tests for sha1 using sha1-padlock-nano failed (rc=3D-22)
------------[ cut here ]------------

alg: shash: sha256-padlock-nano test failed (wrong result) on test vector 0=
, cfg=3D"init+update+final aligned buffer"
alg: self-tests for sha256 using sha256-padlock-nano failed (rc=3D-22)
------------[ cut here ]------------

This patch introduces new functions and data structures to properly meet
the requirements of XSHA1 and XSHA256 instruction on Zhaoxin processors.

[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1103397
[2] https://linux-hardware.org/?probe=3D271fabb7a4&log=3Ddmesg

Signed-off-by: AlanSong-oc <AlanSong-oc@zhaoxin.com>
---
 drivers/crypto/padlock-sha.c | 169 ++++++++++++++++++++++++++++++++---
 1 file changed, 157 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index 329f60ad4..f980e08f6 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -99,6 +99,14 @@ static inline void padlock_output_block(uint32_t *src,
 		*dst++ =3D swab32(*src++);
 }
=20
+static inline void padlock_pad_block_zhaoxin(u8 *padded_data, size_t block=
_size, u64 bit_len)
+{
+	memset(padded_data, 0, block_size);
+	padded_data[0] =3D 0x80;
+	for (int i =3D 0; i < 8 && bit_len; i++)
+		padded_data[block_size - 1 - i] =3D (bit_len >> (i * 8)) & 0xFF;
+}
+
 static int padlock_sha_finup(struct shash_desc *desc, const u8 *in,
 			     unsigned int count, u8 *out)
 {
@@ -133,6 +141,37 @@ static int padlock_sha1_finup(struct shash_desc *desc,=
 const u8 *in,
 	return 0;
 }
=20
+static int padlock_sha1_finup_zhaoxin(struct shash_desc *desc, const u8 *i=
n,
+			      unsigned int count, u8 *out)
+{
+	struct sha1_state *state =3D padlock_shash_desc_ctx(desc);
+	u64 start =3D state->count;
+
+	if (start + count > ULONG_MAX)
+		return padlock_sha_finup(desc, in, count, out);
+
+	if (count =3D=3D 0) {
+		u8 buf[SHA1_BLOCK_SIZE + PADLOCK_ALIGNMENT - 1];
+		u8 *padded_data =3D PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
+		u64 bit_len =3D (start + count) * 8;
+
+		padlock_pad_block_zhaoxin(padded_data, SHA1_BLOCK_SIZE, bit_len);
+
+		asm volatile(".byte 0xf3,0x0f,0xa6,0xc8"
+			: "+S"(padded_data), "+D"(state)
+			: "a"((long)-1), "c"(1UL));
+	} else {
+		/* Process the input data in bytes, applying necessary padding */
+		asm volatile(".byte 0xf3,0x0f,0xa6,0xc8"
+			     :
+			     : "c"((unsigned long)start + count), "a"((unsigned long)start),
+			       "S"(in), "D"(state));
+	}
+
+	padlock_output_block(state->state, (uint32_t *)out, 5);
+	return 0;
+}
+
 static int padlock_sha256_finup(struct shash_desc *desc, const u8 *in,
 				unsigned int count, u8 *out)
 {
@@ -155,6 +194,37 @@ static int padlock_sha256_finup(struct shash_desc *des=
c, const u8 *in,
 	return 0;
 }
=20
+static int padlock_sha256_finup_zhaoxin(struct shash_desc *desc, const u8 =
*in,
+				unsigned int count, u8 *out)
+{
+	struct sha256_state *state =3D padlock_shash_desc_ctx(desc);
+	u64 start =3D state->count;
+
+	if (start + count > ULONG_MAX)
+		return padlock_sha_finup(desc, in, count, out);
+
+	if (count =3D=3D 0) {
+		u8 buf[SHA256_BLOCK_SIZE + PADLOCK_ALIGNMENT - 1];
+		u8 *padded_data =3D PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
+		u64 bit_len =3D (start + count) * 8;
+
+		padlock_pad_block_zhaoxin(padded_data, SHA256_BLOCK_SIZE, bit_len);
+
+		asm volatile(".byte 0xf3,0x0f,0xa6,0xd0"
+			: "+S"(padded_data), "+D"(state)
+			: "a"((long)-1), "c"(1UL));
+	} else {
+		/* Process the input data in bytes, applying necessary padding */
+		asm volatile(".byte 0xf3,0x0f,0xa6,0xd0"
+			:
+			: "c"((unsigned long)start + count), "a"((unsigned long)start),
+			"S"(in), "D"(state));
+	}
+
+	padlock_output_block(state->state, (uint32_t *)out, 8);
+	return 0;
+}
+
 static int padlock_init_tfm(struct crypto_shash *hash)
 {
 	const char *fallback_driver_name =3D crypto_shash_alg_name(hash);
@@ -258,6 +328,31 @@ static int padlock_sha1_update_nano(struct shash_desc =
*desc,
 	return len;
 }
=20
+static int padlock_sha1_update_zhaoxin(struct shash_desc *desc,
+				    const u8 *src, unsigned int len)
+{
+	struct sha1_state *state =3D padlock_shash_desc_ctx(desc);
+	int blocks =3D len / SHA1_BLOCK_SIZE;
+
+	/* The xsha1 instruction requires a 32-byte buffer for execution for Zhao=
xin processors */
+	u8 buf[32 + PADLOCK_ALIGNMENT - 1];
+	u8 *dst =3D PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
+
+	memcpy(dst, (u8 *)(state->state), SHA1_DIGEST_SIZE);
+
+	len -=3D blocks * SHA1_BLOCK_SIZE;
+	state->count +=3D blocks * SHA1_BLOCK_SIZE;
+
+	/* Process the input data in blocks, without applying padding */
+	asm volatile(".byte 0xf3,0x0f,0xa6,0xc8"
+			: "+S"(src), "+D"(dst)
+			: "a"((long)-1), "c"((unsigned long)blocks));
+
+	memcpy((u8 *)(state->state), dst, SHA1_DIGEST_SIZE);
+
+	return len;
+}
+
 static int padlock_sha256_update_nano(struct shash_desc *desc, const u8 *s=
rc,
 			  unsigned int len)
 {
@@ -316,6 +411,44 @@ static struct shash_alg sha256_alg_nano =3D {
 	}
 };
=20
+static struct shash_alg sha1_alg_zhaoxin =3D {
+	.digestsize =3D SHA1_DIGEST_SIZE,
+	.init       =3D padlock_sha1_init,
+	.update     =3D padlock_sha1_update_zhaoxin,
+	.finup      =3D padlock_sha1_finup_zhaoxin,
+	.export     =3D padlock_sha_export,
+	.import     =3D padlock_sha_import,
+	.descsize   =3D PADLOCK_SHA_DESCSIZE,
+	.statesize  =3D SHA1_STATE_SIZE,
+	.base       =3D {
+		.cra_name        =3D "sha1",
+		.cra_driver_name =3D "sha1-padlock-zhaoxin",
+		.cra_priority    =3D PADLOCK_CRA_PRIORITY,
+		.cra_flags       =3D CRYPTO_AHASH_ALG_BLOCK_ONLY | CRYPTO_AHASH_ALG_FINU=
P_MAX,
+		.cra_blocksize   =3D SHA1_BLOCK_SIZE,
+		.cra_module      =3D THIS_MODULE,
+	}
+};
+
+static struct shash_alg sha256_alg_zhaoxin =3D {
+	.digestsize =3D SHA256_DIGEST_SIZE,
+	.init       =3D padlock_sha256_init,
+	.update     =3D padlock_sha256_update_nano,
+	.finup      =3D padlock_sha256_finup_zhaoxin,
+	.export     =3D padlock_sha_export,
+	.import     =3D padlock_sha_import,
+	.descsize   =3D PADLOCK_SHA_DESCSIZE,
+	.statesize  =3D sizeof(struct crypto_sha256_state),
+	.base       =3D {
+		.cra_name        =3D "sha256",
+		.cra_driver_name =3D "sha256-padlock-zhaoxin",
+		.cra_priority    =3D PADLOCK_CRA_PRIORITY,
+		.cra_flags       =3D CRYPTO_AHASH_ALG_BLOCK_ONLY | CRYPTO_AHASH_ALG_FINU=
P_MAX,
+		.cra_blocksize   =3D SHA256_BLOCK_SIZE,
+		.cra_module      =3D THIS_MODULE,
+	}
+};
+
 static const struct x86_cpu_id padlock_sha_ids[] =3D {
 	X86_MATCH_FEATURE(X86_FEATURE_PHE, NULL),
 	{}
@@ -332,14 +465,21 @@ static int __init padlock_init(void)
 	if (!x86_match_cpu(padlock_sha_ids) || !boot_cpu_has(X86_FEATURE_PHE_EN))
 		return -ENODEV;
=20
-	/* Register the newly added algorithm module if on *
-	* VIA Nano processor, or else just do as before */
-	if (c->x86_model < 0x0f) {
-		sha1 =3D &sha1_alg;
-		sha256 =3D &sha256_alg;
+	if (c->x86 >=3D 0x07) {
+		/* Register the newly added algorithm module for Zhaoxin processors */
+		sha1 =3D &sha1_alg_zhaoxin;
+		sha256 =3D &sha256_alg_zhaoxin;
 	} else {
-		sha1 =3D &sha1_alg_nano;
-		sha256 =3D &sha256_alg_nano;
+		/* Register the newly added algorithm module if on
+		 * VIA Nano processor, or else just do as before
+		 */
+		if (c->x86_model < 0x0f) {
+			sha1 =3D &sha1_alg;
+			sha256 =3D &sha256_alg;
+		} else {
+			sha1 =3D &sha1_alg_nano;
+			sha256 =3D &sha256_alg_nano;
+		}
 	}
=20
 	rc =3D crypto_register_shash(sha1);
@@ -366,12 +506,17 @@ static void __exit padlock_fini(void)
 {
 	struct cpuinfo_x86 *c =3D &cpu_data(0);
=20
-	if (c->x86_model >=3D 0x0f) {
-		crypto_unregister_shash(&sha1_alg_nano);
-		crypto_unregister_shash(&sha256_alg_nano);
+	if (c->x86 >=3D 0x07) {
+		crypto_unregister_shash(&sha1_alg_zhaoxin);
+		crypto_unregister_shash(&sha256_alg_zhaoxin);
 	} else {
-		crypto_unregister_shash(&sha1_alg);
-		crypto_unregister_shash(&sha256_alg);
+		if (c->x86_model >=3D 0x0f) {
+			crypto_unregister_shash(&sha1_alg_nano);
+			crypto_unregister_shash(&sha256_alg_nano);
+		} else {
+			crypto_unregister_shash(&sha1_alg);
+			crypto_unregister_shash(&sha256_alg);
+		}
 	}
 }
=20
--=20
2.34.1

