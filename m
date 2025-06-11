Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5E128750C
	for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 10:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749639334; cv=none; b=mMQw2yheCDpJ8FpdVrI2xiHlMre/3IxEBNcDZYGOh6FKaToM0cotQESxdxRzrui5vTjW98wAqHoc/N4ZGKHwGDN2KZXgbJljPJWKdP3b7tnYqsrVbi8kmVaB+uFLC8b5flla7DkD3iQ0FIujt1ZUFD31OefbMZNQy6JRzTz4IAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749639334; c=relaxed/simple;
	bh=//dx93M1aeY8vooLgxtPMHyHBVzuRNjPDDoqEIYxszA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IZ88p45uBC5zhDCvG2BW0IWB0bHgNmIDC3saFzjRUrwG6fpgKI6qGlTatt2IfaB1S5Huhey4IaslOsth2ZZt7QUwNROOOf7Hh6MiXn+wMEMDYFnCN24zBYl9ZqhuN3EVg6wkdgCnwMILbKgR7Bb+gZZrEyw7IQ3XRh/HRQU4d/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1749639318-086e23269850650001-Xm9f1P
Received: from ZXSHMBX2.zhaoxin.com (ZXSHMBX2.zhaoxin.com [10.28.252.164]) by mx1.zhaoxin.com with ESMTP id FSNqAaMdAo6Gno33 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Wed, 11 Jun 2025 18:55:18 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX2.zhaoxin.com
 (10.28.252.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Wed, 11 Jun
 2025 18:55:17 +0800
Received: from ZXSHMBX1.zhaoxin.com ([::1]) by ZXSHMBX1.zhaoxin.com
 ([fe80::2c07:394e:4919:4dc1%7]) with mapi id 15.01.2507.044; Wed, 11 Jun 2025
 18:55:17 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from DESKTOP-A4I8D8T.zhaoxin.com (10.32.65.156) by
 ZXBJMBX02.zhaoxin.com (10.29.252.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 11 Jun 2025 18:17:51 +0800
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <CobeChen@zhaoxin.com>, <TonyWWang-oc@zhaoxin.com>, <YunShen@zhaoxin.com>,
	<GeorgeXue@zhaoxin.com>, <LeoLiu-oc@zhaoxin.com>, <HansHu@zhaoxin.com>,
	AlanSong <AlanSong-oc@zhaoxin.com>
Subject: [PATCH] crypto: padlock-sha - Add support for Zhaoxin processor
Date: Wed, 11 Jun 2025 18:17:50 +0800
X-ASG-Orig-Subj: [PATCH] crypto: padlock-sha - Add support for Zhaoxin processor
Message-ID: <20250611101750.6839-1-AlanSong-oc@zhaoxin.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 6/11/2025 6:55:16 PM
X-Barracuda-Connect: ZXSHMBX2.zhaoxin.com[10.28.252.164]
X-Barracuda-Start-Time: 1749639318
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 10898
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.142705
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

From: AlanSong <AlanSong-oc@zhaoxin.com>

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

+static inline void padlock_pad_block_zhaoxin(u8 *padded_data, size_t block=
_size, u64 bit_len)
+{
+       memset(padded_data, 0, block_size);
+       padded_data[0] =3D 0x80;
+       for (int i =3D 0; i < 8 && bit_len; i++)
+               padded_data[block_size - 1 - i] =3D (bit_len >> (i * 8)) & =
0xFF;
+}
+
 static int padlock_sha_finup(struct shash_desc *desc, const u8 *in,
                             unsigned int count, u8 *out)
 {
@@ -133,6 +141,37 @@ static int padlock_sha1_finup(struct shash_desc *desc,=
 const u8 *in,
        return 0;
 }

+static int padlock_sha1_finup_zhaoxin(struct shash_desc *desc, const u8 *i=
n,
+                             unsigned int count, u8 *out)
+{
+       struct sha1_state *state =3D padlock_shash_desc_ctx(desc);
+       u64 start =3D state->count;
+
+       if (start + count > ULONG_MAX)
+               return padlock_sha_finup(desc, in, count, out);
+
+       if (count =3D=3D 0) {
+               u8 buf[SHA1_BLOCK_SIZE + PADLOCK_ALIGNMENT - 1];
+               u8 *padded_data =3D PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
+               u64 bit_len =3D (start + count) * 8;
+
+               padlock_pad_block_zhaoxin(padded_data, SHA1_BLOCK_SIZE, bit=
_len);
+
+               asm volatile(".byte 0xf3,0x0f,0xa6,0xc8"
+                       : "+S"(padded_data), "+D"(state)
+                       : "a"((long)-1), "c"(1UL));
+       } else {
+               /* Process the input data in bytes, applying necessary padd=
ing */
+               asm volatile(".byte 0xf3,0x0f,0xa6,0xc8"
+                            :
+                            : "c"((unsigned long)start + count), "a"((unsi=
gned long)start),
+                              "S"(in), "D"(state));
+       }
+
+       padlock_output_block(state->state, (uint32_t *)out, 5);
+       return 0;
+}
+
 static int padlock_sha256_finup(struct shash_desc *desc, const u8 *in,
                                unsigned int count, u8 *out)
 {
@@ -155,6 +194,37 @@ static int padlock_sha256_finup(struct shash_desc *des=
c, const u8 *in,
        return 0;
 }

+static int padlock_sha256_finup_zhaoxin(struct shash_desc *desc, const u8 =
*in,
+                               unsigned int count, u8 *out)
+{
+       struct sha256_state *state =3D padlock_shash_desc_ctx(desc);
+       u64 start =3D state->count;
+
+       if (start + count > ULONG_MAX)
+               return padlock_sha_finup(desc, in, count, out);
+
+       if (count =3D=3D 0) {
+               u8 buf[SHA256_BLOCK_SIZE + PADLOCK_ALIGNMENT - 1];
+               u8 *padded_data =3D PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
+               u64 bit_len =3D (start + count) * 8;
+
+               padlock_pad_block_zhaoxin(padded_data, SHA256_BLOCK_SIZE, b=
it_len);
+
+               asm volatile(".byte 0xf3,0x0f,0xa6,0xd0"
+                       : "+S"(padded_data), "+D"(state)
+                       : "a"((long)-1), "c"(1UL));
+       } else {
+               /* Process the input data in bytes, applying necessary padd=
ing */
+               asm volatile(".byte 0xf3,0x0f,0xa6,0xd0"
+                       :
+                       : "c"((unsigned long)start + count), "a"((unsigned =
long)start),
+                       "S"(in), "D"(state));
+       }
+
+       padlock_output_block(state->state, (uint32_t *)out, 8);
+       return 0;
+}
+
 static int padlock_init_tfm(struct crypto_shash *hash)
 {
        const char *fallback_driver_name =3D crypto_shash_alg_name(hash);
@@ -258,6 +328,31 @@ static int padlock_sha1_update_nano(struct shash_desc =
*desc,
        return len;
 }

+static int padlock_sha1_update_zhaoxin(struct shash_desc *desc,
+                                   const u8 *src, unsigned int len)
+{
+       struct sha1_state *state =3D padlock_shash_desc_ctx(desc);
+       int blocks =3D len / SHA1_BLOCK_SIZE;
+
+       /* The xsha1 instruction requires a 32-byte buffer for execution fo=
r Zhaoxin processors */
+       u8 buf[32 + PADLOCK_ALIGNMENT - 1];
+       u8 *dst =3D PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
+
+       memcpy(dst, (u8 *)(state->state), SHA1_DIGEST_SIZE);
+
+       len -=3D blocks * SHA1_BLOCK_SIZE;
+       state->count +=3D blocks * SHA1_BLOCK_SIZE;
+
+       /* Process the input data in blocks, without applying padding */
+       asm volatile(".byte 0xf3,0x0f,0xa6,0xc8"
+                       : "+S"(src), "+D"(dst)
+                       : "a"((long)-1), "c"((unsigned long)blocks));
+
+       memcpy((u8 *)(state->state), dst, SHA1_DIGEST_SIZE);
+
+       return len;
+}
+
 static int padlock_sha256_update_nano(struct shash_desc *desc, const u8 *s=
rc,
                          unsigned int len)
 {
@@ -316,6 +411,44 @@ static struct shash_alg sha256_alg_nano =3D {
        }
 };

+static struct shash_alg sha1_alg_zhaoxin =3D {
+       .digestsize =3D SHA1_DIGEST_SIZE,
+       .init       =3D padlock_sha1_init,
+       .update     =3D padlock_sha1_update_zhaoxin,
+       .finup      =3D padlock_sha1_finup_zhaoxin,
+       .export     =3D padlock_sha_export,
+       .import     =3D padlock_sha_import,
+       .descsize   =3D PADLOCK_SHA_DESCSIZE,
+       .statesize  =3D SHA1_STATE_SIZE,
+       .base       =3D {
+               .cra_name        =3D "sha1",
+               .cra_driver_name =3D "sha1-padlock-zhaoxin",
+               .cra_priority    =3D PADLOCK_CRA_PRIORITY,
+               .cra_flags       =3D CRYPTO_AHASH_ALG_BLOCK_ONLY | CRYPTO_A=
HASH_ALG_FINUP_MAX,
+               .cra_blocksize   =3D SHA1_BLOCK_SIZE,
+               .cra_module      =3D THIS_MODULE,
+       }
+};
+
+static struct shash_alg sha256_alg_zhaoxin =3D {
+       .digestsize =3D SHA256_DIGEST_SIZE,
+       .init       =3D padlock_sha256_init,
+       .update     =3D padlock_sha256_update_nano,
+       .finup      =3D padlock_sha256_finup_zhaoxin,
+       .export     =3D padlock_sha_export,
+       .import     =3D padlock_sha_import,
+       .descsize   =3D PADLOCK_SHA_DESCSIZE,
+       .statesize  =3D sizeof(struct crypto_sha256_state),
+       .base       =3D {
+               .cra_name        =3D "sha256",
+               .cra_driver_name =3D "sha256-padlock-zhaoxin",
+               .cra_priority    =3D PADLOCK_CRA_PRIORITY,
+               .cra_flags       =3D CRYPTO_AHASH_ALG_BLOCK_ONLY | CRYPTO_A=
HASH_ALG_FINUP_MAX,
+               .cra_blocksize   =3D SHA256_BLOCK_SIZE,
+               .cra_module      =3D THIS_MODULE,
+       }
+};
+
 static const struct x86_cpu_id padlock_sha_ids[] =3D {
        X86_MATCH_FEATURE(X86_FEATURE_PHE, NULL),
        {}
@@ -332,14 +465,21 @@ static int __init padlock_init(void)
        if (!x86_match_cpu(padlock_sha_ids) || !boot_cpu_has(X86_FEATURE_PH=
E_EN))
                return -ENODEV;

-       /* Register the newly added algorithm module if on *
-       * VIA Nano processor, or else just do as before */
-       if (c->x86_model < 0x0f) {
-               sha1 =3D &sha1_alg;
-               sha256 =3D &sha256_alg;
+       if (c->x86 >=3D 0x07) {
+               /* Register the newly added algorithm module for Zhaoxin pr=
ocessors */
+               sha1 =3D &sha1_alg_zhaoxin;
+               sha256 =3D &sha256_alg_zhaoxin;
        } else {
-               sha1 =3D &sha1_alg_nano;
-               sha256 =3D &sha256_alg_nano;
+               /* Register the newly added algorithm module if on
+                * VIA Nano processor, or else just do as before
+                */
+               if (c->x86_model < 0x0f) {
+                       sha1 =3D &sha1_alg;
+                       sha256 =3D &sha256_alg;
+               } else {
+                       sha1 =3D &sha1_alg_nano;
+                       sha256 =3D &sha256_alg_nano;
+               }
        }

        rc =3D crypto_register_shash(sha1);
@@ -366,12 +506,17 @@ static void __exit padlock_fini(void)
 {
        struct cpuinfo_x86 *c =3D &cpu_data(0);

-       if (c->x86_model >=3D 0x0f) {
-               crypto_unregister_shash(&sha1_alg_nano);
-               crypto_unregister_shash(&sha256_alg_nano);
+       if (c->x86 >=3D 0x07) {
+               crypto_unregister_shash(&sha1_alg_zhaoxin);
+               crypto_unregister_shash(&sha256_alg_zhaoxin);
        } else {
-               crypto_unregister_shash(&sha1_alg);
-               crypto_unregister_shash(&sha256_alg);
+               if (c->x86_model >=3D 0x0f) {
+                       crypto_unregister_shash(&sha1_alg_nano);
+                       crypto_unregister_shash(&sha256_alg_nano);
+               } else {
+                       crypto_unregister_shash(&sha1_alg);
+                       crypto_unregister_shash(&sha256_alg);
+               }
        }
 }

--
2.34.1



=E4=BF=9D=E5=AF=86=E5=A3=B0=E6=98=8E=EF=BC=9A
=E6=9C=AC=E9=82=AE=E4=BB=B6=E5=90=AB=E6=9C=89=E4=BF=9D=E5=AF=86=E6=88=96=E4=
=B8=93=E6=9C=89=E4=BF=A1=E6=81=AF=EF=BC=8C=E4=BB=85=E4=BE=9B=E6=8C=87=E5=AE=
=9A=E6=94=B6=E4=BB=B6=E4=BA=BA=E4=BD=BF=E7=94=A8=E3=80=82=E4=B8=A5=E7=A6=81=
=E5=AF=B9=E6=9C=AC=E9=82=AE=E4=BB=B6=E6=88=96=E5=85=B6=E5=86=85=E5=AE=B9=E5=
=81=9A=E4=BB=BB=E4=BD=95=E6=9C=AA=E7=BB=8F=E6=8E=88=E6=9D=83=E7=9A=84=E6=9F=
=A5=E9=98=85=E3=80=81=E4=BD=BF=E7=94=A8=E3=80=81=E5=A4=8D=E5=88=B6=E6=88=96=
=E8=BD=AC=E5=8F=91=E3=80=82
CONFIDENTIAL NOTE:
This email contains confidential or legally privileged information and is f=
or the sole use of its intended recipient. Any unauthorized review, use, co=
pying or forwarding of this email or the content of this email is strictly =
prohibited.
