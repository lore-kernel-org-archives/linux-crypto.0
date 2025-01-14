Received: from zxbjcas.zhaoxin.com (zxbjcas.zhaoxin.com [124.127.214.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6590615250F;
	Wed, 15 Jan 2025 03:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.127.214.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736913493; cv=none; b=d8r2POGg+0ijCe/U7cVW17xu87Vi11TLHqAzvYjuIwKgrV6ESlTqpFd2qLBmWUVNyD64/QOa0ONZ2FdBKz7JgmaDzGhp3wSmklNdmNB9RGjB7a4znw1w1Ruyho6CVNO7IWyNT0COxW8YLHLJFeGWkF4BYAoxamIAoJMqdVJYK9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736913493; c=relaxed/simple;
	bh=9b7a5MPW0z/mHGgFceEoXxq/NAGGXc48TTYGBS/Iw3k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kmz+Asqs5CZ43TFYjhk+wYpsSkgvkZpeIE7eaZ7dZWZWK8HWGSMJlyxR1BHnbhhikWecEtak+s35seM2qwna2iM+7OUtdO86Q9u/eIigXAVEeFmoI0k76P2F1m6874X23UMKn0vEpXs1UXoLQZ8hHn5sHFLFZKmB1RaCx7PC8XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=124.127.214.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
Received: from zxbjcas.zhaoxin.com (localhost [127.0.0.2] (may be forged))
	by zxbjcas.zhaoxin.com with ESMTP id 50F3VwVK014563;
	Wed, 15 Jan 2025 11:31:58 +0800 (GMT-8)
	(envelope-from TonyWWang-oc@zhaoxin.com)
Received: from ZXBJMBX03.zhaoxin.com (ZXBJMBX03.zhaoxin.com [10.29.252.7])
	by zxbjcas.zhaoxin.com with ESMTP id 50F3TCW8013884;
	Wed, 15 Jan 2025 11:29:12 +0800 (GMT-8)
	(envelope-from TonyWWang-oc@zhaoxin.com)
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXBJMBX03.zhaoxin.com
 (10.29.252.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 15 Jan
 2025 11:29:11 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::1f6:1739:ec6a:3d64]) by
 ZXSHMBX1.zhaoxin.com ([fe80::1f6:1739:ec6a:3d64%7]) with mapi id
 15.01.2507.039; Wed, 15 Jan 2025 11:29:11 +0800
Received: from tony.zhaoxin.com (10.32.65.152) by ZXBJMBX03.zhaoxin.com
 (10.29.252.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 14 Jan
 2025 20:12:55 +0800
From: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
        <pawan.kumar.gupta@linux.intel.com>, <jpoimboe@kernel.org>,
        <daniel.sneddon@linux.intel.com>, <perry.yuan@amd.com>,
        <thomas.lendacky@amd.com>, <sandipan.das@amd.com>,
        <namhyung@kernel.org>, <acme@redhat.com>, <xin3.li@intel.com>,
        <brijesh.singh@amd.com>, <TonyWWang-oc@zhaoxin.com>,
        <linux-kernel@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
CC: <CobeChen@zhaoxin.com>, <TimGuo@zhaoxin.com>, <LeoLiu-oc@zhaoxin.com>,
        <GeorgeXue@zhaoxin.com>
Subject: [PATCH v3 2/2] crypto: Add Zhaoxin PadLock Hash Engine support for SHA384/SHA512
Date: Tue, 14 Jan 2025 20:13:01 +0800
Message-ID: <20250114121301.156359-3-TonyWWang-oc@zhaoxin.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250114121301.156359-1-TonyWWang-oc@zhaoxin.com>
References: <20250114121301.156359-1-TonyWWang-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX03.zhaoxin.com (10.29.252.7)
X-Moderation-Data: 1/15/2025 11:29:10 AM
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:zxbjcas.zhaoxin.com 50F3VwVK014563

Zhaoxin CPUs have implemented the SHA(Secure Hash Algorithm) as its CPU
instructions, including SHA1, SHA256, SHA384 and SHA512, which conform
to the Secure Hash Algorithms specified by FIPS 180-3.

Zhaoxin CPU's SHA1/SHA256 implementation is compatible with VIA's
SHA1/SHA256, so add Zhaoxin CPU's SHA384/SHA512 support in padlock-sha.c.

With the help of implementation of SHA in hardware instead of software,
can develop applications with higher performance, more security and more
flexibility.

Below table gives a summary of test using the driver tcrypt with different
crypt algorithm drivers on Zhaoxin KH-40000 platform:
---------------------------------------------------------------------------
tcrypt     driver   16*    64      256     1024    2048    4096    8192
---------------------------------------------------------------------------
           PadLock** 442.80 1309.21 3257.53 5221.56 5813.45 6136.39 6264.50=
***
403:SHA1   generic** 341.44 813.27  1458.98 1818.03 1896.60 1940.71 1939.06
           ratio    1.30   1.61    2.23    2.87    3.07    3.16    3.23
---------------------------------------------------------------------------
           Padlock  451.70 1313.65 2958.71 4658.55 5109.16 5359.08 5459.13
404:SHA256 generic  202.62 463.55  845.01  1070.50 1117.51 1144.79 1155.68
           ratio    2.23   2.83    3.50    4.35    4.57    4.68    4.72
---------------------------------------------------------------------------
           Padlock  350.90 1406.42 3166.16 5736.39 6627.77 7182.01 7429.18
405:SHA384 generic  161.76 654.88  979.06  1350.56 1423.08 1496.57 1513.12
           ratio    2.17   2.15    3.23    4.25    4.66    4.80    4.91
---------------------------------------------------------------------------
           Padlock  334.49 1394.71 3159.93 5728.86 6625.33 7169.23 7407.80
406:SHA512 generic  161.80 653.84  979.42  1351.41 1444.14 1495.35 1518.43
           ratio    2.07   2.13    3.23    4.24    4.59    4.79    4.88
---------------------------------------------------------------------------
*: The length of each data block to be processed by one complete SHA
   sequence, namely one INIT, multi UPDATEs and one FINAL.
**: Crypt algorithm driver used by tcrypt, "PadLock" represents padlock-sha
   while "generic" represents the generic software SHA driver.
***: The speed of each crypt algorithm driver processing different length
   of data blocks, unit is Mb/s.

The ratio in the table implies the performance of SHA implemented by
padlock-sha driver is much higher than the ones implemented by the generic
software driver of sha1/sha256/sha384/sha512.

Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
---
 drivers/crypto/Kconfig       |  10 +-
 drivers/crypto/padlock-sha.c | 200 ++++++++++++++++++++++++++++++++++-
 2 files changed, 202 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 19ab145f912e..0e97be36e037 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -39,15 +39,19 @@ config CRYPTO_DEV_PADLOCK_AES
 	  called padlock-aes.
=20
 config CRYPTO_DEV_PADLOCK_SHA
-	tristate "PadLock driver for SHA1 and SHA256 algorithms"
+	tristate "PadLock driver for SHA1/SHA256/SHA384/SHA512 algorithms"
+	depends on X86 && !UML
 	depends on CRYPTO_DEV_PADLOCK
 	select CRYPTO_HASH
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
+	select CRYPTO_SHA512
 	help
-	  Use VIA PadLock for SHA1/SHA256 algorithms.
+	  Use PadLock for SHA1/SHA256 algorithms.
+	  Available in VIA C7 and newer processors, available in Zhaoxin processo=
rs.
=20
-	  Available in VIA C7 and newer processors.
+	  Use PadLock for SHA384/SHA512 algorithms.
+	  Available in Zhaoxin processors.
=20
 	  If unsure say M. The compiled module will be
 	  called padlock-sha.
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index 6865c7f1fc1a..80af906184e2 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -5,6 +5,10 @@
  * Support for VIA PadLock hardware crypto engine.
  *
  * Copyright (c) 2006  Michal Ludvig <michal@logix.cz>
+ *
+ * Add SHA384/SHA512 support for Zhaoxin processors.
+ *
+ * Copyright (c) 2025  George Xue <georgexue@zhaoxin.com>
  */
=20
 #include <crypto/internal/hash.h>
@@ -434,6 +438,123 @@ static int padlock_sha256_final_nano(struct shash_des=
c *desc, u8 *out)
 	return 0;
 }
=20
+static inline void padlock_output_block_512(uint64_t *src, uint64_t *dst, =
size_t count)
+{
+	while (count--)
+		*dst++ =3D swab64(*src++);
+}
+
+static int padlock_sha384_init(struct shash_desc *desc)
+{
+	struct sha512_state *sctx =3D shash_desc_ctx(desc);
+
+	*sctx =3D (struct sha512_state){
+		.state =3D { SHA384_H0, SHA384_H1, SHA384_H2, SHA384_H3, SHA384_H4, SHA3=
84_H5,
+			   SHA384_H6, SHA384_H7 },
+		.count =3D { 0, 0 },
+	};
+
+	return 0;
+}
+
+static int padlock_sha512_init(struct shash_desc *desc)
+{
+	struct sha512_state *sctx =3D shash_desc_ctx(desc);
+
+	*sctx =3D (struct sha512_state){
+		.state =3D { SHA512_H0, SHA512_H1, SHA512_H2, SHA512_H3, SHA512_H4, SHA5=
12_H5,
+			   SHA512_H6, SHA512_H7 },
+		.count =3D { 0, 0 },
+	};
+
+	return 0;
+}
+
+static int padlock_sha512_update(struct shash_desc *desc, const u8 *data, =
unsigned int len)
+{
+	struct sha512_state *sctx =3D shash_desc_ctx(desc);
+	unsigned int partial, done;
+	const u8 *src;
+	u8 buf[SHA512_BLOCK_SIZE];
+	u8 *dst =3D &buf[0];
+
+	partial =3D sctx->count[0] % SHA512_BLOCK_SIZE;
+
+	sctx->count[0] +=3D len;
+	if (sctx->count[0] < len)
+		sctx->count[1]++;
+
+	done =3D 0;
+	src =3D data;
+	memcpy(dst, sctx->state, SHA512_DIGEST_SIZE);
+
+	if ((partial + len) >=3D SHA512_BLOCK_SIZE) {
+		/* Append the bytes in state's buffer to a block to handle */
+		if (partial) {
+			done =3D -partial;
+			memcpy(sctx->buf + partial, data, done + SHA512_BLOCK_SIZE);
+
+			src =3D sctx->buf;
+
+			asm volatile(".byte 0xf3, 0x0f, 0xa6, 0xe0"
+				     : "+S"(src), "+D"(dst)
+				     : "c"(1UL));
+
+			done +=3D SHA512_BLOCK_SIZE;
+			src =3D data + done;
+		}
+
+		/* Process the left bytes from input data */
+		if (len - done >=3D SHA512_BLOCK_SIZE) {
+			asm volatile(".byte 0xf3, 0x0f, 0xa6, 0xe0"
+				     : "+S"(src), "+D"(dst)
+				     : "c"((unsigned long)((len - done) / SHA512_BLOCK_SIZE)));
+
+			done +=3D ((len - done) - (len - done) % SHA512_BLOCK_SIZE);
+			src =3D data + done;
+		}
+		partial =3D 0;
+	}
+
+	memcpy(sctx->state, dst, SHA512_DIGEST_SIZE);
+	memcpy(sctx->buf + partial, src, len - done);
+
+	return 0;
+}
+
+static int padlock_sha512_final(struct shash_desc *desc, u8 *out)
+{
+	const int bit_offset =3D SHA512_BLOCK_SIZE - sizeof(__be64[2]);
+	struct sha512_state *state =3D shash_desc_ctx(desc);
+	unsigned int partial =3D state->count[0] % SHA512_BLOCK_SIZE, padlen;
+	__be64 bits[2];
+
+	/* Both SHA384 and SHA512 may be supported. */
+	int dgst_size =3D crypto_shash_digestsize(desc->tfm);
+
+	static u8 padding[SHA512_BLOCK_SIZE];
+
+	memset(padding, 0, SHA512_BLOCK_SIZE);
+	padding[0] =3D 0x80;
+
+	/* Convert byte count in little endian to bit count in big endian. */
+	bits[0] =3D cpu_to_be64(state->count[1] << 3 | state->count[0] >> 61);
+	bits[1] =3D cpu_to_be64(state->count[0] << 3);
+
+	padlen =3D (partial < bit_offset) ? (bit_offset - partial) :
+					  ((SHA512_BLOCK_SIZE + bit_offset) - partial);
+
+	padlock_sha512_update(desc, padding, padlen);
+
+	/* Append length field bytes */
+	padlock_sha512_update(desc, (const u8 *)bits, sizeof(__be64[2]));
+
+	/* Swap to output */
+	padlock_output_block_512(state->state, (uint64_t *)out, dgst_size / sizeo=
f(uint64_t));
+
+	return 0;
+}
+
 static int padlock_sha_export_nano(struct shash_desc *desc,
 				void *out)
 {
@@ -490,6 +611,42 @@ static struct shash_alg sha256_alg_nano =3D {
 	}
 };
=20
+static struct shash_alg sha384_alg =3D {
+	.digestsize =3D SHA384_DIGEST_SIZE,
+	.init       =3D padlock_sha384_init,
+	.update     =3D padlock_sha512_update,
+	.final      =3D padlock_sha512_final,
+	.export     =3D padlock_sha_export_nano,
+	.import     =3D padlock_sha_import_nano,
+	.descsize   =3D sizeof(struct sha512_state),
+	.statesize  =3D sizeof(struct sha512_state),
+	.base       =3D {
+		.cra_name        =3D "sha384",
+		.cra_driver_name =3D "sha384-padlock-zhaoxin",
+		.cra_priority    =3D PADLOCK_CRA_PRIORITY,
+		.cra_blocksize   =3D SHA384_BLOCK_SIZE,
+		.cra_module      =3D THIS_MODULE,
+	}
+};
+
+static struct shash_alg sha512_alg =3D {
+	.digestsize =3D SHA512_DIGEST_SIZE,
+	.init       =3D padlock_sha512_init,
+	.update     =3D padlock_sha512_update,
+	.final      =3D padlock_sha512_final,
+	.export     =3D padlock_sha_export_nano,
+	.import     =3D padlock_sha_import_nano,
+	.descsize   =3D sizeof(struct sha512_state),
+	.statesize  =3D sizeof(struct sha512_state),
+	.base       =3D {
+		.cra_name        =3D "sha512",
+		.cra_driver_name =3D "sha512-padlock-zhaoxin",
+		.cra_priority    =3D PADLOCK_CRA_PRIORITY,
+		.cra_blocksize   =3D SHA512_BLOCK_SIZE,
+		.cra_module      =3D THIS_MODULE,
+	}
+};
+
 static const struct x86_cpu_id padlock_sha_ids[] =3D {
 	X86_MATCH_FEATURE(X86_FEATURE_PHE, NULL),
 	{}
@@ -502,12 +659,16 @@ static int __init padlock_init(void)
 	struct cpuinfo_x86 *c =3D &cpu_data(0);
 	struct shash_alg *sha1;
 	struct shash_alg *sha256;
+	struct shash_alg *sha384;
+	struct shash_alg *sha512;
=20
 	if (!x86_match_cpu(padlock_sha_ids) || !boot_cpu_has(X86_FEATURE_PHE_EN))
 		return -ENODEV;
=20
-	/* Register the newly added algorithm module if on *
-	* VIA Nano processor, or else just do as before */
+	/*
+	 * Register the newly added algorithm module if on
+	 * Zhaoxin/VIA Nano processor, or else just do as before
+	 */
 	if (c->x86_model < 0x0f) {
 		sha1 =3D &sha1_alg;
 		sha256 =3D &sha256_alg;
@@ -524,15 +685,34 @@ static int __init padlock_init(void)
 	if (rc)
 		goto out_unreg1;
=20
-	printk(KERN_NOTICE PFX "Using VIA PadLock ACE for SHA1/SHA256 algorithms.=
\n");
+	printk(KERN_NOTICE PFX "Using PadLock ACE for SHA1/SHA256 algorithms.\n")=
;
+
+	if (boot_cpu_has(X86_FEATURE_PHE2_EN)) {
+		sha384 =3D &sha384_alg;
+		sha512 =3D &sha512_alg;
+
+		rc =3D crypto_register_shash(sha384);
+		if (rc)
+			goto out_unreg2;
+
+		rc =3D crypto_register_shash(sha512);
+		if (rc)
+			goto out_unreg3;
+
+		printk(KERN_NOTICE PFX "Using PadLock ACE for SHA384/SHA512 algorithms.\=
n");
+	}
=20
 	return 0;
=20
+out_unreg3:
+	crypto_unregister_shash(sha384);
+out_unreg2:
+	crypto_unregister_shash(sha256);
 out_unreg1:
 	crypto_unregister_shash(sha1);
=20
 out:
-	printk(KERN_ERR PFX "VIA PadLock SHA1/SHA256 initialization failed.\n");
+	printk(KERN_ERR PFX "PadLock SHA1/SHA256/SHA384/SHA5112 initialization fa=
iled.\n");
 	return rc;
 }
=20
@@ -543,6 +723,11 @@ static void __exit padlock_fini(void)
 	if (c->x86_model >=3D 0x0f) {
 		crypto_unregister_shash(&sha1_alg_nano);
 		crypto_unregister_shash(&sha256_alg_nano);
+
+		if (boot_cpu_has(X86_FEATURE_PHE2_EN)) {
+			crypto_unregister_shash(&sha384_alg);
+			crypto_unregister_shash(&sha512_alg);
+		}
 	} else {
 		crypto_unregister_shash(&sha1_alg);
 		crypto_unregister_shash(&sha256_alg);
@@ -552,11 +737,16 @@ static void __exit padlock_fini(void)
 module_init(padlock_init);
 module_exit(padlock_fini);
=20
-MODULE_DESCRIPTION("VIA PadLock SHA1/SHA256 algorithms support.");
+MODULE_DESCRIPTION("PadLock SHA1/SHA256/SHA384/SHA512 algorithms support."=
);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michal Ludvig");
+MODULE_AUTHOR("George Xue <georgexue@zhaoxin.com>");
=20
 MODULE_ALIAS_CRYPTO("sha1-all");
 MODULE_ALIAS_CRYPTO("sha256-all");
+MODULE_ALIAS_CRYPTO("sha384-all");
+MODULE_ALIAS_CRYPTO("sha512-all");
 MODULE_ALIAS_CRYPTO("sha1-padlock");
 MODULE_ALIAS_CRYPTO("sha256-padlock");
+MODULE_ALIAS_CRYPTO("sha384-padlock");
+MODULE_ALIAS_CRYPTO("sha512-padlock");
--=20
2.25.1

