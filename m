Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406D4EB64D8
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jun 2023 02:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjFSCQW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Jun 2023 22:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjFSCQV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Jun 2023 22:16:21 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FEAE5D
        for <linux-crypto@vger.kernel.org>; Sun, 18 Jun 2023 19:16:05 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QktfS25jgz1FDZm;
        Mon, 19 Jun 2023 10:16:00 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 19 Jun
 2023 10:16:04 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH RFC v2 3/3] crypto: Introduce SM9 key exchange algorithm
Date:   Mon, 19 Jun 2023 10:15:03 +0800
Message-ID: <20230619021503.29814-4-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230619021503.29814-1-guozihua@huawei.com>
References: <20230619021503.29814-1-guozihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch introduces a generic implementation of SM9 (ShangMi 9) key
exchange algorithm.

SM9 is an ID-based cryptography algorithm within the ShangMi family whose
key exchange algorithm was accepted in ISO/IEC 11770-3 as an
international standard.

Being an ID-based crypto algorithm, each user would propose a
human-readable ID. The ID is then send to KGC (Key Generation Center),
who would generate private keys for the user.

The operation of SM9 key exchange is quite like that of DH or ECDH,
except with SM9, the caller and callee would be exchanging IDs
beforehand. Public keys are generated based on the id of the opponent,
as well as the private key of the user. Besides, unlike DH and ECDH,
caller and callee would be processing data slightly differently, which
could be noticed within the code.

Due to the difference mentioned above, SM9 does not quite fit into the
current self-test framework, thus self-tests for SM9 is not included yet.

Moreover, due to the fact that the data structure for passing data
around users is not defined by the standard, it is implemented in a
simple length then data style.

References:
http://c.gb688.cn/bzgk/gb/showGb?type=online&hcno=B7A0D7DFF411CD0AAE76135ADE91886A
http://c.gb688.cn/bzgk/gb/showGb?type=online&hcno=02A8E87248BD500747D2CD484C034EB0
https://github.com/guanzhi/GmSSL

Co-developed-by: LI Shiya <lishiya1@huawei.com>
Signed-off-by: GUO Zihua <guozihua@huawei.com>
---
 crypto/Kconfig       |  15 +
 crypto/Makefile      |   4 +
 crypto/sm9.c         | 916 +++++++++++++++++++++++++++++++++++++++++++
 include/crypto/sm9.h |  84 ++++
 4 files changed, 1019 insertions(+)
 create mode 100644 crypto/sm9.c
 create mode 100644 include/crypto/sm9.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a0e080d5f6ae..fe0d0c886e95 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -304,6 +304,21 @@ config CRYPTO_ECRDSA
 	  One of the Russian cryptographic standard algorithms (called GOST
 	  algorithms). Only signature verification is implemented.
 
+config CRYPTO_SM9
+	tristate "SM9 (ShangMi 9 Key Exchange)"
+	select CRYPTO_SM3
+	select CRYPTO_AKCIPHER
+	select CRYPTO_MANAGER
+	select MPILIB
+	help
+	  SM9 (ShangMi 9) key exchange algorithm.
+
+	  As specified by GB/T 38635.1-2020 and GB/T 38635.2-2020.
+
+	  References:
+	  http://c.gb688.cn/bzgk/gb/showGb?type=online&hcno=B7A0D7DFF411CD0AAE76135ADE91886A
+	  http://c.gb688.cn/bzgk/gb/showGb?type=online&hcno=02A8E87248BD500747D2CD484C034EB0
+
 config CRYPTO_SM2
 	tristate "SM2 (ShangMi 2)"
 	select CRYPTO_SM3
diff --git a/crypto/Makefile b/crypto/Makefile
index d0126c915834..a4acad6b02f2 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -189,6 +189,10 @@ ecdh_generic-y += ecdh.o
 ecdh_generic-y += ecdh_helper.o
 obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o
 
+sm9_generic-y += sm9_lib.o
+sm9_generic-y += sm9.o
+obj-$(CONFIG_CRYPTO_SM9) += sm9_generic.o
+
 $(obj)/ecrdsa_params.asn1.o: $(obj)/ecrdsa_params.asn1.c $(obj)/ecrdsa_params.asn1.h
 $(obj)/ecrdsa_pub_key.asn1.o: $(obj)/ecrdsa_pub_key.asn1.c $(obj)/ecrdsa_pub_key.asn1.h
 $(obj)/ecrdsa.o: $(obj)/ecrdsa_params.asn1.h $(obj)/ecrdsa_pub_key.asn1.h
diff --git a/crypto/sm9.c b/crypto/sm9.c
new file mode 100644
index 000000000000..48c96e9e473c
--- /dev/null
+++ b/crypto/sm9.c
@@ -0,0 +1,916 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * SM9 key exchange algorithm, as specified in
+ * GB/T 38635.1-2020 and GB/T 38635.2-2020
+ *
+ * Copyright (c) 2023, Huawei Technology Co., Ltd.
+ * Authors: GUO Zihua <guozihua@huawei.com>
+ */
+
+#include <linux/math.h>
+#include <linux/mpi.h>
+#include <linux/bits.h>
+#include <linux/random.h>
+#include <linux/crypto.h>
+#include <crypto/hash.h>
+#include <crypto/kpp.h>
+#include <crypto/sm3.h>
+#include <crypto/sm3_base.h>
+#include <crypto/internal/kpp.h>
+#include <crypto/sm9.h>
+
+#include "sm9_lib.h"
+
+static struct sm9_sys_cfg sys_cfg;
+
+struct sm9_raw_cfg {
+	const char *desc;
+	unsigned int nbits;
+
+	enum gcry_mpi_ec_models model;
+
+	enum ecc_dialects dialect;
+
+	u8 cid;
+	u8 eid;
+	u8 hid;
+
+	const char *q;
+	const char *a, *b;
+	const char *N;
+	unsigned int N_log_2_times_5_roundup;
+	unsigned int cf;
+	unsigned int k;
+	const char *p1_x, *p1_y;
+	const char *p2_xd1, *p2_xd2, *p2_yd1, *p2_yd2;
+	const char *n; /* The order of the base point.  */
+	const char *g_x, *g_y; /* Base point.  */
+	const char *t;
+	const char *tr;
+	const char *pairing_a;
+	const char *pi_q_c;
+	const char *pi_q2_c;
+	const char *beta;
+	const char *alpha1;
+	const char *alpha2;
+	const char *alpha3;
+	const char *alpha4;
+	const char *alpha5;
+};
+
+static const struct sm9_raw_cfg sm9_default_cfg = {
+	.desc = "sm9Rate",
+	.model = MPI_EC_WEIERSTRASS,
+	.dialect = ECC_DIALECT_STANDARD,
+	.cid = 0x12,
+	.eid = 0x04,
+	.hid = 0x02,
+	.q = "0xB640000002A3A6F1D603AB4FF58EC74521F2934B1A7AEEDBE56F9B27E351457D",
+	.N = "0xB640000002A3A6F1D603AB4FF58EC74449F2934B18EA8BEEE56EE19CD69ECF25",
+	.N_log_2_times_5_roundup = 1278,
+	.a = "0x0",
+	.b = "0x5",
+	.k = 12,
+	.cf = 1,
+
+	.p1_x = "0x93DE051D62BF718FF5ED0704487D01D6E1E4086909DC3280E8C4E4817C66DDDD",
+	.p1_y = "0x21FE8DDA4F21E607631065125C395BBC1C1C00CBFA6024350C464CD70A3EA616",
+	.p2_xd2 =
+		"0x85AEF3D078640C98597B6027B441A01FF1DD2C190F5E93C454806C11D8806141",
+	.p2_xd1 =
+		"0x3722755292130B08D2AAB97FD34EC120EE265948D19C17ABF9B7213BAF82D65B",
+	.p2_yd2 =
+		"0x17509B092E845C1266BA0D262CBEE6ED0736A96FA347C8BD856DC76B84EBEB96",
+	.p2_yd1 =
+		"0xA7CF28D519BE3DA65F3170153D278FF247EFBA98A71A08116215BBA5C999A7C7",
+	.t = "0x600000000058F98A",
+	.tr = "0xD8000000019062ED0000B98B0CB27659",
+	.pairing_a = "0x2400000000215d93e",
+	.pi_q_c =
+		"0x3f23ea58e5720bdb843c6cfa9c08674947c5c86e0ddd04eda91d8354377b698b",
+	.pi_q2_c = "0xf300000002a3a6f2780272354f8b78f4d5fc11967be65334",
+	.beta = "0x6c648de5dc0a3f2cf55acc93ee0baf159f9d411806dc5177f5b21fd3da24d011",
+	.alpha1 =
+		"0x3f23ea58e5720bdb843c6cfa9c08674947c5c86e0ddd04eda91d8354377b698b",
+	.alpha2 = "0xf300000002a3a6f2780272354f8b78f4d5fc11967be65334",
+	.alpha3 =
+		"0x6c648de5dc0a3f2cf55acc93ee0baf159f9d411806dc5177f5b21fd3da24d011",
+	.alpha4 = "0xf300000002a3a6f2780272354f8b78f4d5fc11967be65333",
+	.alpha5 =
+		"0x2d40a38cf6983351711e5f99520347cc57d778a9f8ff4c8a4c949c7fa2a96686"
+};
+
+static struct crypto_shash *hash_tfm;
+
+static int sm9_h(MPI out, u8 *Z, size_t z_size, MPI n, u8 prepend,
+		 struct sm9_ctx *ctx)
+{
+	SHASH_DESC_ON_STACK(shash, hash_tfm);
+	u8 *data, *tmp, *tmp_p;
+	u8 hash_result[SM3_DIGEST_SIZE];
+	u32 counter = 1;
+	size_t hlen, tmp_len, hash_digest_size = SM3_DIGEST_SIZE;
+	size_t data_size = z_size + sizeof(counter) + 1;
+	int i, hash_count;
+	int rc = -ENOMEM;
+	MPI mpi_tmp = NULL;
+
+	if (!out)
+		return -EINVAL;
+
+	data = kmalloc(data_size, GFP_KERNEL);
+	if (!data)
+		return rc;
+	memset(data, 0x0, data_size);
+
+	hlen = (roundup(ctx->sys_cfg->N_log_2_times_5_roundup, 32)) / 32;
+	hash_count = roundup(hlen, hash_digest_size) / hash_digest_size;
+
+	tmp = kmalloc(hlen, GFP_KERNEL);
+	if (!tmp)
+		goto out_free;
+
+	shash->tfm = hash_tfm;
+
+	tmp_len = hlen;
+	/* only the counter changes during the loop */
+	data[0] = prepend;
+	memcpy(&data[1], Z, z_size);
+	tmp_p = tmp;
+	for (i = 0; i < hash_count; i++) {
+		cpu_to_be32_array((__be32 *)&data[z_size + 1], &counter,
+				  sizeof(counter));
+		crypto_shash_digest(shash, data, data_size, hash_result);
+		memcpy(tmp_p, &hash_result, min(tmp_len, hash_digest_size));
+		counter++;
+		tmp_len -= hash_digest_size;
+		tmp_p += hash_digest_size;
+	}
+
+	mpi_tmp = mpi_read_raw_data(tmp, hlen);
+	if (!mpi_tmp)
+		goto out_free;
+	mpi_set(out, mpi_tmp);
+
+	mpi_sub_ui(mpi_tmp, n, 1);
+	mpi_mod(out, out, mpi_tmp);
+	mpi_add_ui(out, out, 1);
+	rc = 0;
+
+out_free:
+	mpi_free(mpi_tmp);
+	kfree(tmp);
+	kfree(data);
+	return rc;
+}
+
+static int sm9_h1(MPI out, u8 *Z, size_t z_size, MPI n, struct sm9_ctx *ctx)
+{
+	return sm9_h(out, Z, z_size, n, 0x01, ctx);
+}
+
+static int sm9_get_R(MPI_POINT R, MPI ra, const u8 *id, size_t id_size,
+		     struct sm9_ctx *ctx)
+{
+	MPI_POINT Q = NULL;
+	MPI tmp = NULL, r = NULL;
+	u8 *buf = NULL, *ra_buf = NULL;
+	int rc = -ENOMEM;
+
+	buf = kmalloc(id_size + sizeof(ctx->sys_cfg->hid), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	memcpy(buf, id, id_size);
+	memcpy(buf + id_size, &ctx->sys_cfg->hid, sizeof(ctx->sys_cfg->hid));
+
+	tmp = mpi_new(0);
+	if (!tmp)
+		goto out_err;
+	sm9_h1(tmp, buf, id_size + sizeof(ctx->sys_cfg->hid), ctx->sys_cfg->N,
+	       ctx);
+
+	Q = mpi_point_new(0);
+	if (!Q)
+		goto out_err;
+	/* 1: Q = [H1(ID || hid, N)]P1 + Ppub-e */
+	mpi_ec_mul_point(Q, tmp, ctx->sys_cfg->G1->G, ctx->sys_cfg->G1);
+	mpi_ec_add_points(Q, Q, ctx->Ppub_s, ctx->sys_cfg->G1);
+
+	ra_buf = kzalloc(mpi_get_size(ctx->sys_cfg->N), GFP_KERNEL);
+	if (!ra_buf)
+		goto out_err;
+	r = mpi_new(0);
+	do {
+		get_random_bytes_wait(ra_buf, mpi_get_size(ctx->sys_cfg->N));
+		r = mpi_read_raw_data(ra_buf, mpi_get_size(ctx->sys_cfg->N));
+		if (!r)
+			goto out_err;
+	} while (mpi_cmp(r, ctx->sys_cfg->N_minus_1) > 0 ||
+		 mpi_cmp_ui(r, 1) < 0);
+	memzero_explicit(ra_buf, mpi_get_size(ctx->sys_cfg->N));
+
+	mpi_ec_mul_point(R, r, Q, ctx->sys_cfg->G1);
+	mpi_point_jacobian_to_affine(R, R, ctx->sys_cfg->q);
+
+	memzero_explicit(ra->d, mpi_get_size(ra));
+	mpi_set(ra, r);
+	rc = 0;
+
+out_err:
+	mpi_point_release(Q);
+	mpi_free(tmp);
+	mpi_free(r);
+	kfree(buf);
+	kfree(ra_buf);
+	return rc;
+}
+
+static int _sm9_kdf(u8 *k, size_t klen, u8 *Z, size_t Z_size)
+{
+	SHASH_DESC_ON_STACK(shash, hash_tfm);
+	__be32 counter = 1;
+	u8 *buf = NULL, hash_out[SM3_DIGEST_SIZE];
+	size_t buf_size = Z_size + sizeof(counter), kp = 0, cpy_size;
+	int i, hash_times = roundup(klen, SM3_DIGEST_SIZE) / SM3_DIGEST_SIZE;
+
+	if (!Z || !Z_size || !k || !klen)
+		return -EINVAL;
+
+	buf = kmalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	shash->tfm = hash_tfm;
+
+	memcpy(buf, Z, Z_size);
+	for (i = 0; i < hash_times; i++) {
+		cpu_to_be32_array((__be32 *)&buf[Z_size], &counter,
+				  sizeof(counter));
+		counter++;
+		crypto_shash_digest(shash, buf, buf_size, hash_out);
+		cpy_size = min(klen - kp, (size_t)SM3_DIGEST_SIZE);
+		memcpy(k + kp, hash_out, cpy_size);
+		kp += cpy_size;
+	}
+
+	memzero_explicit(buf, buf_size);
+	kfree(buf);
+	memzero_explicit(hash_out, SM3_DIGEST_SIZE);
+	return 0;
+}
+
+static int sm9_kdf(u8 *SK, size_t klen, const u8 *ida, size_t ida_size,
+		   const u8 *idb, size_t idb_size, MPI_POINT Ra, MPI_POINT Rb,
+		   SM9_DIM_FQ12 g1, SM9_DIM_FQ12 g2, SM9_DIM_FQ12 g3)
+{
+	u8 *buf = NULL, *buf_tmp, *Ra_buf = NULL, *Rb_buf = NULL;
+	size_t buf_size, buf_size_tmp, Ra_buf_size, Rb_buf_size, g_size;
+	int rc = -ENOMEM;
+
+	point_to_bytes(Ra, &Ra_buf, &Ra_buf_size);
+	point_to_bytes(Rb, &Rb_buf, &Rb_buf_size);
+	if (!Ra_buf || !Rb_buf)
+		goto out_free;
+
+	buf_size = ida_size + idb_size;
+	buf_size += Ra_buf_size;
+	buf_size += Rb_buf_size;
+	g_size = sm9_dim_fq12_get_size(g1);
+	buf_size += 3 * g_size;
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		goto out_free;
+
+	buf_tmp = buf;
+	buf_size_tmp = buf_size;
+	memcpy(buf_tmp, ida, ida_size);
+	buf_tmp += ida_size;
+	buf_size_tmp -= ida_size;
+
+	memcpy(buf_tmp, idb, idb_size);
+	buf_tmp += idb_size;
+	buf_size_tmp -= idb_size;
+
+	memcpy(buf_tmp, Ra_buf, Ra_buf_size);
+	buf_tmp += Ra_buf_size;
+	buf_size_tmp -= Ra_buf_size;
+
+	memcpy(buf_tmp, Rb_buf, Rb_buf_size);
+	buf_tmp += Rb_buf_size;
+	buf_size_tmp -= Ra_buf_size;
+
+	sm9_dim_fq12_to_buf_rev(g1, buf_tmp, g_size);
+	buf_tmp += g_size;
+	buf_size_tmp -= g_size;
+
+	sm9_dim_fq12_to_buf_rev(g2, buf_tmp, g_size);
+	buf_tmp += g_size;
+	buf_size_tmp -= g_size;
+
+	sm9_dim_fq12_to_buf_rev(g3, buf_tmp, g_size);
+	buf_tmp += g_size;
+	buf_size_tmp -= g_size;
+
+	rc = _sm9_kdf(SK, klen, buf, buf_size);
+
+out_free:
+	kfree(buf);
+	kfree(Ra_buf);
+	kfree(Rb_buf);
+	return rc;
+}
+
+static int _sm9_get_SK_responder(u8 *SK, size_t klen, MPI_POINT R,
+				 const char *id, const size_t id_size,
+				 struct sm9_ctx *ctx)
+{
+	SM9_DIM_FQ12 g1, g2, g3;
+	int rc;
+
+	rc = sm9_dim_fq12_init(g1, 0);
+	rc |= sm9_dim_fq12_init(g2, 0);
+	rc |= sm9_dim_fq12_init(g3, 0);
+	if (rc)
+		goto out_free;
+	Rate_pairing(g1, ctx->de, R, ctx->sys_cfg->pairing_a, ctx);
+	Rate_pairing(g2, ctx->sys_cfg->P2, ctx->Ppub_s, ctx->sys_cfg->pairing_a,
+		     ctx);
+	sm9_dim_fq12_powm(g2, g2, ctx->r, ctx);
+	sm9_dim_fq12_powm(g3, g1, ctx->r, ctx);
+
+	rc = sm9_kdf(SK, klen, id, id_size, ctx->id, ctx->id_size, R, ctx->R,
+		     g1, g2, g3);
+
+out_free:
+	sm9_dim_fq12_deinit(g1);
+	sm9_dim_fq12_deinit(g2);
+	sm9_dim_fq12_deinit(g3);
+	return rc;
+}
+
+static int _sm9_get_SK_initiator(u8 *SK, size_t klen, MPI_POINT R,
+				 const char *id, const size_t id_size,
+				 struct sm9_ctx *ctx)
+{
+	SM9_DIM_FQ12 g1, g2, g3;
+	int rc;
+
+	rc = sm9_dim_fq12_init(g1, 0);
+	rc |= sm9_dim_fq12_init(g2, 0);
+	rc |= sm9_dim_fq12_init(g3, 0);
+	if (rc)
+		goto out_free;
+	Rate_pairing(g1, ctx->sys_cfg->P2, ctx->Ppub_s, ctx->sys_cfg->pairing_a,
+		     ctx);
+	sm9_dim_fq12_powm(g1, g1, ctx->r, ctx);
+	Rate_pairing(g2, ctx->de, R, ctx->sys_cfg->pairing_a, ctx);
+	sm9_dim_fq12_powm(g3, g2, ctx->r, ctx);
+
+	rc = sm9_kdf(SK, klen, ctx->id, ctx->id_size, id, id_size, ctx->R, R,
+		     g1, g2, g3);
+
+out_free:
+	sm9_dim_fq12_deinit(g1);
+	sm9_dim_fq12_deinit(g2);
+	sm9_dim_fq12_deinit(g3);
+	return rc;
+}
+
+static int sm9_get_SK(u8 *SK, size_t klen, MPI_POINT R, const char *id,
+	       const size_t id_size, struct sm9_ctx *ctx, bool initiator)
+{
+	if (initiator)
+		return _sm9_get_SK_initiator(SK, klen, R, id, id_size, ctx);
+
+	return _sm9_get_SK_responder(SK, klen, R, id, id_size, ctx);
+}
+
+static void sm9_ctx_deinit(struct sm9_ctx *ctx)
+{
+	ctx->sys_cfg = NULL;
+	if (ctx->Ppub_s)
+		mpi_point_release(ctx->Ppub_s);
+	ctx->Ppub_s = NULL;
+
+	if (ctx->R)
+		mpi_point_release(ctx->R);
+	ctx->R = NULL;
+
+	if (ctx->de)
+		sm9_point_release(ctx->de);
+	ctx->de = NULL;
+
+	kfree(ctx->id);
+	ctx->id = NULL;
+
+	if (ctx->r)
+		mpi_free(ctx->r);
+	ctx->r = NULL;
+}
+
+static int sm9_init_tfm(struct crypto_kpp *tfm)
+{
+	struct sm9_ctx *ctx = (struct sm9_ctx *)kpp_tfm_ctx(tfm);
+
+	ctx->sys_cfg = &sys_cfg;
+	return 0;
+}
+
+static void sm9_exit_tfm(struct crypto_kpp *tfm)
+{
+	struct sm9_ctx *ctx = (struct sm9_ctx *)kpp_tfm_ctx(tfm);
+
+	sm9_ctx_deinit(ctx);
+}
+
+static unsigned int sm9_max_size(struct crypto_kpp *tfm)
+{
+	/* Unlimited max size */
+	return PAGE_SIZE;
+}
+
+static int sm9_set_secret(struct crypto_kpp *tfm, const void *buf,
+			  unsigned int len)
+{
+	struct sm9_ctx *ctx = (struct sm9_ctx *)kpp_tfm_ctx(tfm);
+	struct sm9_set_secret_data *data;
+	u8 *data_p;
+
+	data = kmemdup(buf, len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->id_size = be32_to_cpu(data->id_size);
+	data->secret_size = be32_to_cpu(data->secret_size);
+	data->pub_size = be32_to_cpu(data->pub_size);
+
+	if (!data->id_size || !data->secret_size || !data->pub_size ||
+	    data->secret_size % 2) {
+		kfree_sensitive(data);
+		return -EINVAL;
+	}
+	data_p = data->data;
+
+	ctx->id = kzalloc(data->id_size, GFP_KERNEL);
+	if (!ctx->id) {
+		kfree_sensitive(data);
+		return -ENOMEM;
+	}
+	memcpy(ctx->id, data_p, data->id_size);
+	ctx->id_size = data->id_size;
+	data_p += data->id_size;
+
+	ctx->de = sm9_point_from_buf(data_p, data->secret_size);
+	if (!ctx->de) {
+		kfree_sensitive(data);
+		kfree(ctx->id);
+		ctx->id = NULL;
+		return -ENOMEM;
+	}
+	data_p += data->secret_size;
+
+	if (sm9_point_valid(ctx->de, ctx)) {
+		kfree_sensitive(data);
+		kfree(ctx->id);
+		ctx->id = NULL;
+		sm9_point_release(ctx->de);
+		ctx->de = NULL;
+		return -EINVAL;
+	}
+
+	ctx->Ppub_s = mpi_point_new(0);
+	if (!ctx->Ppub_s) {
+		kfree_sensitive(data);
+		kfree(ctx->id);
+		ctx->id = NULL;
+		sm9_point_release(ctx->de);
+		ctx->de = NULL;
+		return -ENOMEM;
+	}
+	mpi_point_from_buf(ctx->Ppub_s, data_p, data->pub_size);
+	if (!mpi_ec_curve_point(ctx->Ppub_s, ctx->sys_cfg->G1)) {
+		kfree_sensitive(data);
+		kfree(ctx->id);
+		ctx->id = NULL;
+		sm9_point_release(ctx->de);
+		ctx->de = NULL;
+		mpi_point_release(ctx->Ppub_s);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct sm9_compute_data *retrive_oppo_data(struct kpp_request *req)
+{
+	struct sm9_compute_data *oppo_data;
+	u8 *input_buf = NULL;
+	size_t copied;
+
+	input_buf = kzalloc(req->src_len, GFP_KERNEL);
+	if (!input_buf)
+		return NULL;
+
+	copied = sg_copy_to_buffer(req->src,
+				   sg_nents_for_len(req->src, req->src_len),
+				   input_buf, req->src_len);
+	if (copied != req->src_len) {
+		kfree(input_buf);
+		return NULL;
+	}
+
+	oppo_data = (struct sm9_compute_data *)input_buf;
+	oppo_data->id_size = be32_to_cpu(oppo_data->id_size);
+	oppo_data->R_size = be32_to_cpu(oppo_data->R_size);
+
+	if (oppo_data->R_size + oppo_data->id_size !=
+	    req->src_len - sizeof(oppo_data->R_size) -
+		    sizeof(oppo_data->id_size)) {
+		kfree(input_buf);
+		return NULL;
+	}
+	return oppo_data;
+}
+
+static int sm9_generate_public_key(struct kpp_request *req)
+{
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct sm9_ctx *ctx = kpp_tfm_ctx(tfm);
+	struct sm9_compute_data *oppo_data = NULL;
+	struct sm9_compute_data *data = NULL;
+	MPI_POINT P = NULL;
+	u8 *key = NULL, *id_buf = NULL;
+	size_t key_size, data_size, copied;
+	int rc = -ENOMEM;
+
+	if (!ctx->id) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (!req->src || !req->src_len)
+		return -EINVAL;
+
+	oppo_data = retrive_oppo_data(req);
+	if (!oppo_data)
+		return -ENOMEM;
+
+	id_buf = kmemdup(oppo_data->data, oppo_data->id_size, GFP_KERNEL);
+	if (!id_buf) {
+		kfree(oppo_data);
+		return -ENOMEM;
+	}
+
+	if (ctx->R)
+		mpi_point_release(ctx->R);
+	ctx->R = mpi_point_new(0);
+	if (!ctx->R)
+		goto out_err;
+
+	if (ctx->r)
+		mpi_free(ctx->r);
+	ctx->r = mpi_new(0);
+	if (!ctx->r)
+		goto out_err;
+
+	rc = sm9_get_R(ctx->R, ctx->r, id_buf, oppo_data->id_size, ctx);
+	if (rc)
+		goto out_err;
+
+	P = mpi_point_new(0);
+	if (!P)
+		goto out_err;
+
+	rc = mpi_point_jacobian_to_affine(P, ctx->R, ctx->sys_cfg->q);
+	if (rc)
+		goto out_err;
+
+	key_size = max(mpi_get_size(P->x), mpi_get_size(P->y)) * 2;
+	data_size = sizeof(struct sm9_compute_data) + ctx->id_size + key_size;
+	if (req->dst_len < data_size) {
+		req->dst_len = data_size;
+		rc = -EINVAL;
+		goto out_err;
+	}
+
+	data = kzalloc(data_size, GFP_KERNEL);
+	if (!data)
+		goto out_err;
+	data->id_size = cpu_to_be32(ctx->id_size);
+	data->R_size = cpu_to_be32(key_size);
+	memcpy(data->data, ctx->id, ctx->id_size);
+
+	rc = mpi_point_export(P, data->data + ctx->id_size, key_size);
+	if (rc)
+		goto out_err;
+
+	copied = sg_copy_from_buffer(req->dst,
+				     sg_nents_for_len(req->dst, data_size),
+				     data, data_size);
+	if (copied != data_size)
+		rc = -EINVAL;
+
+	if (!oppo_data->R_size)
+		ctx->initiator = true;
+	rc = 0;
+	goto out;
+out_err:
+	if (ctx->R)
+		mpi_point_release(ctx->R);
+	ctx->R = NULL;
+	if (ctx->r)
+		mpi_free(ctx->r);
+	ctx->r = NULL;
+out:
+	kfree_sensitive(data);
+	mpi_point_release(P);
+	kfree(key);
+	kfree(oppo_data);
+	kfree(id_buf);
+	return rc;
+}
+
+static int sm9_compute_shared_secret(struct kpp_request *req, const u8 *oppo_id,
+				     struct sm9_compute_data *oppo_data,
+				     bool initiator)
+{
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct sm9_ctx *ctx = kpp_tfm_ctx(tfm);
+	MPI_POINT R = NULL;
+	u8 *k_buf = NULL;
+	size_t klen = req->dst_len, copied;
+	int rc = -ENOMEM;
+
+	if (!req->src || !req->src_len)
+		return -EINVAL;
+
+	if (!oppo_data->R_size)
+		return -EINVAL;
+
+	R = mpi_point_new(0);
+	if (!R)
+		goto out_free;
+
+	rc = mpi_point_from_buf(R, oppo_data->data + oppo_data->id_size,
+				oppo_data->R_size);
+	if (rc)
+		goto out_free;
+
+	k_buf = kzalloc(klen, GFP_KERNEL);
+	if (!k_buf)
+		goto out_free;
+
+	rc = sm9_get_SK(k_buf, klen, R, oppo_id, oppo_data->id_size, ctx,
+			initiator);
+	if (rc)
+		goto out_free;
+
+	copied = sg_copy_from_buffer(req->dst, sg_nents_for_len(req->dst, klen),
+				     k_buf, klen);
+	if (copied != klen)
+		rc = -ENOMEM;
+
+out_free:
+	kfree_sensitive(k_buf);
+	mpi_point_release(R);
+	return rc;
+}
+
+static int sm9_compute(struct kpp_request *req)
+{
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct sm9_ctx *ctx = kpp_tfm_ctx(tfm);
+	struct sm9_compute_data *oppo_data;
+	u8 *id_buf = NULL;
+	int rc;
+
+	if (!req->src || !req->src_len)
+		return -EINVAL;
+
+	if (!ctx->R)
+		return -EINVAL;
+
+	oppo_data = retrive_oppo_data(req);
+	if (!oppo_data)
+		return -ENOMEM;
+
+	id_buf = kmemdup(oppo_data->data, oppo_data->id_size, GFP_KERNEL);
+	if (!id_buf) {
+		kfree(oppo_data);
+		return -ENOMEM;
+	}
+
+	rc = sm9_compute_shared_secret(req, id_buf, oppo_data, ctx->initiator);
+
+	ctx->initiator = false;
+	kfree(id_buf);
+	kfree(oppo_data);
+	return rc;
+}
+
+static struct kpp_alg sm9_generic = {
+	.set_secret = sm9_set_secret,
+	.generate_public_key = sm9_generate_public_key,
+	.compute_shared_secret = sm9_compute,
+	.max_size = sm9_max_size,
+	.init = sm9_init_tfm,
+	.exit = sm9_exit_tfm,
+	.base = { .cra_name = "sm9_kpp",
+		  .cra_driver_name = "sm9_kpp_generic",
+		  .cra_priority = 100,
+		  .cra_module = THIS_MODULE,
+		  .cra_ctxsize = sizeof(struct sm9_ctx) }
+};
+
+static void sm9_sys_cfg_deinit(void)
+{
+	struct sm9_sys_cfg *cfg = &sys_cfg;
+
+	mpi_free(cfg->q);
+	cfg->q = NULL;
+	mpi_free(cfg->q_minus_2);
+	cfg->q_minus_2 = NULL;
+	mpi_free(cfg->q2);
+	cfg->q2 = NULL;
+	mpi_free(cfg->q2_minus_2);
+	cfg->q2_minus_2 = NULL;
+	mpi_free(cfg->a);
+	cfg->a = NULL;
+	mpi_free(cfg->b);
+	cfg->b = NULL;
+	mpi_free(cfg->t);
+	cfg->t = NULL;
+	mpi_free(cfg->tr);
+	cfg->tr = NULL;
+	mpi_free(cfg->pairing_a);
+	cfg->pairing_a = NULL;
+	mpi_free(cfg->N);
+	cfg->N = NULL;
+	cfg->G1->n = NULL;
+	mpi_free(cfg->N_minus_1);
+	cfg->N_minus_1 = NULL;
+	mpi_free(cfg->pi_q_c);
+	cfg->pi_q_c = NULL;
+	mpi_free(cfg->pi_q2_c);
+	cfg->pi_q2_c = NULL;
+	mpi_free(cfg->beta);
+	cfg->beta = NULL;
+	mpi_free(cfg->alpha1);
+	cfg->alpha1 = NULL;
+	mpi_free(cfg->alpha2);
+	cfg->alpha2 = NULL;
+	mpi_free(cfg->alpha3);
+	cfg->alpha3 = NULL;
+	mpi_free(cfg->alpha4);
+	cfg->alpha4 = NULL;
+	mpi_free(cfg->alpha5);
+	cfg->alpha5 = NULL;
+	mpi_point_release(cfg->P1);
+	cfg->P1 = NULL;
+	sm9_point_release(cfg->P2);
+	cfg->P2 = NULL;
+
+	if (cfg->G1)
+		mpi_ec_deinit(cfg->G1);
+	cfg->G1 = NULL;
+}
+
+static int sm9_ec_ctx_init(void)
+{
+	const struct sm9_raw_cfg *default_cfg = &sm9_default_cfg;
+	struct sm9_sys_cfg *cfg = &sys_cfg;
+	MPI mpi0 = NULL;
+
+	cfg->G1 = kzalloc(sizeof(struct mpi_ec_ctx), GFP_KERNEL);
+	if (!cfg->G1)
+		return -ENOMEM;
+
+	mpi0 = mpi_new(0);
+	if (!mpi0) {
+		kfree(cfg->G1);
+		return -ENOMEM;
+	}
+	mpi_set_ui(mpi0, 0);
+	cfg->G1->G = mpi_point_new(0);
+	if (!cfg->G1->G) {
+		mpi_free(mpi0);
+		kfree(cfg->G1);
+		return -ENOMEM;
+	}
+	cfg->G1->n = cfg->N;
+	cfg->G1->h = cfg->cf;
+	cfg->G1->name = default_cfg->desc;
+	mpi_set(cfg->G1->G->x, cfg->P1->x);
+	mpi_set(cfg->G1->G->y, cfg->P1->y);
+	mpi_set_ui(cfg->G1->G->z, 1);
+	mpi_ec_init(cfg->G1, sm9_default_cfg.model, sm9_default_cfg.dialect, 0,
+		    cfg->q, mpi0, cfg->b);
+	mpi_free(mpi0);
+	return 0;
+}
+
+static int sm9_sys_cfg_init(void)
+{
+	const struct sm9_raw_cfg *default_cfg = &sm9_default_cfg;
+	struct sm9_sys_cfg *cfg = &sys_cfg;
+
+	cfg->P1 = mpi_point_new(0);
+	cfg->P2 = sm9_point_new(0);
+	if (!cfg->P1 || !cfg->P2)
+		goto out_err;
+
+	mpi_fromstr(cfg->P1->x, default_cfg->p1_x);
+	mpi_fromstr(cfg->P1->y, default_cfg->p1_y);
+
+	mpi_fromstr(cfg->P2->xd1, default_cfg->p2_xd1);
+	mpi_fromstr(cfg->P2->xd2, default_cfg->p2_xd2);
+	mpi_fromstr(cfg->P2->yd1, default_cfg->p2_yd1);
+	mpi_fromstr(cfg->P2->yd2, default_cfg->p2_yd2);
+	mpi_set_ui(cfg->P2->zd1, 1);
+	mpi_set_ui(cfg->P2->zd2, 0);
+
+	cfg->N = mpi_scanval(default_cfg->N);
+	cfg->N_minus_1 = mpi_new(0);
+	if (!cfg->N || !cfg->N_minus_1)
+		goto out_err;
+	mpi_sub_ui(cfg->N_minus_1, cfg->N, 1);
+
+	cfg->q = mpi_scanval(default_cfg->q);
+	cfg->q_minus_2 = mpi_new(0);
+	cfg->q2 = mpi_new(0);
+	cfg->q2_minus_2 = mpi_new(0);
+	cfg->a = mpi_scanval(default_cfg->a);
+	cfg->b = mpi_scanval(default_cfg->b);
+	cfg->t = mpi_scanval(default_cfg->t);
+	cfg->tr = mpi_scanval(default_cfg->tr);
+	cfg->pairing_a = mpi_scanval(default_cfg->pairing_a);
+	cfg->pi_q_c = mpi_scanval(default_cfg->pi_q_c);
+	cfg->pi_q2_c = mpi_scanval(default_cfg->pi_q2_c);
+	cfg->beta = mpi_scanval(default_cfg->beta);
+	cfg->alpha1 = mpi_scanval(default_cfg->alpha1);
+	cfg->alpha2 = mpi_scanval(default_cfg->alpha2);
+	cfg->alpha3 = mpi_scanval(default_cfg->alpha3);
+	cfg->alpha4 = mpi_scanval(default_cfg->alpha4);
+	cfg->alpha5 = mpi_scanval(default_cfg->alpha5);
+	if (!cfg->q || !cfg->q_minus_2 || !cfg->q2 || !cfg->q2_minus_2 ||
+	    !cfg->a || !cfg->b || !cfg->t || !cfg->tr || !cfg->pairing_a ||
+	    !cfg->pi_q_c || !cfg->pi_q2_c || !cfg->beta || !cfg->alpha1 ||
+	    !cfg->alpha2 || !cfg->alpha3 || !cfg->alpha4 || !cfg->alpha5)
+		goto out_err;
+	mpi_sub_ui(cfg->q_minus_2, cfg->q, 2);
+	mpi_mulm(cfg->q2, cfg->q, cfg->q, cfg->q);
+	mpi_sub_ui(cfg->q2_minus_2, cfg->q2, 2);
+
+	cfg->cid = default_cfg->cid;
+	cfg->k = default_cfg->k;
+	cfg->cf = default_cfg->cf;
+	cfg->N_log_2_times_5_roundup = default_cfg->N_log_2_times_5_roundup;
+	cfg->hid = default_cfg->hid;
+
+	if (sm9_ec_ctx_init())
+		goto out_err;
+
+	return 0;
+out_err:
+	sm9_sys_cfg_deinit();
+	return -ENOMEM;
+}
+
+static int sm9_init(void)
+{
+	int rc;
+
+	hash_tfm = crypto_alloc_shash("sm3", 0, 0);
+	if (IS_ERR(hash_tfm)) {
+		pr_err("Failed to allocate SM3 hash algorithm\n");
+		return PTR_ERR(hash_tfm);
+	}
+
+	rc = sm9_sys_cfg_init();
+	if (rc) {
+		crypto_free_shash(hash_tfm);
+		return rc;
+	}
+
+	rc = crypto_register_kpp(&sm9_generic);
+	if (rc) {
+		crypto_free_shash(hash_tfm);
+		sm9_sys_cfg_deinit();
+	}
+
+	return rc;
+}
+
+static void sm9_exit(void)
+{
+	if (hash_tfm)
+		crypto_free_shash(hash_tfm);
+	sm9_sys_cfg_deinit();
+}
+
+subsys_initcall(sm9_init);
+module_exit(sm9_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("GUO Zihua <guozihua@huawei.com>");
+MODULE_DESCRIPTION("SM9 generic algorithm");
+MODULE_ALIAS_CRYPTO("sm9-generic");
diff --git a/include/crypto/sm9.h b/include/crypto/sm9.h
new file mode 100644
index 000000000000..05161b8e8c8d
--- /dev/null
+++ b/include/crypto/sm9.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * Header file for SM9 key exchange algorithm
+ *
+ * Copyright (c) 2023, Huawei Technology Co., Ltd.
+ * Authors: GUO Zihua <guozihua@huawei.com>
+ */
+
+#include <linux/types.h>
+#include <linux/mpi.h>
+
+#ifndef SM9_H
+#define SM9_H
+
+typedef MPI SM9_DIM_FQ2[2];
+
+typedef SM9_DIM_FQ2 SM9_DIM_FQ4[2];
+typedef SM9_DIM_FQ4 SM9_DIM_FQ12[3];
+
+struct sm9_point_fq12 {
+	union {
+		SM9_DIM_FQ12 x_fq12;
+		MPI x[12];
+	};
+	union {
+		SM9_DIM_FQ12 y_fq12;
+		MPI y[12];
+	};
+	union {
+		SM9_DIM_FQ12 z_fq12;
+		MPI z[12];
+	};
+};
+
+typedef struct sm9_point_fq12 *SM9_POINT_FQ12;
+typedef struct sm9_point_fq2 *SM9_POINT;
+
+struct sm9_sys_cfg;
+
+struct sm9_ctx;
+
+struct sm9_set_secret_data {
+	u32 id_size;
+	u32 secret_size;
+	u32 pub_size;
+	u8 data[];
+};
+
+struct sm9_compute_data {
+	u32 id_size;
+	u32 R_size;
+	u8 data[];
+};
+
+int sm9_dim_init(SM9_DIM_FQ2 dim, unsigned int nbits);
+void sm9_dim_deinit(SM9_DIM_FQ2 dim);
+void sm9_dim_free(SM9_DIM_FQ2 *dim);
+SM9_DIM_FQ2 *sm9_dim_alloc(unsigned int nbits);
+int sm9_dim_set(SM9_DIM_FQ2 a, SM9_DIM_FQ2 b);
+int sm9_dim_clear(SM9_DIM_FQ2 a);
+
+void sm9_point_release(SM9_POINT P);
+SM9_POINT sm9_point_new(unsigned int nbits);
+SM9_POINT sm9_point_from_buf(const u8 *buf, size_t size);
+bool sm9_point_valid(SM9_POINT P, struct sm9_ctx *ctx);
+
+int sm9_dim_fq4_set(SM9_DIM_FQ4 a, SM9_DIM_FQ4 b);
+void sm9_dim_fq4_deinit(SM9_DIM_FQ4 p);
+int sm9_dim_fq4_init(SM9_DIM_FQ4 p, unsigned int nbits);
+int sm9_dim_fq4_clear(SM9_DIM_FQ4 p);
+
+int sm9_dim_fq12_set(SM9_DIM_FQ12 a, SM9_DIM_FQ12 b);
+void sm9_dim_fq12_deinit(SM9_DIM_FQ12 d);
+int sm9_dim_fq12_init(SM9_DIM_FQ12 d, unsigned int nbits);
+int sm9_dim_fq12_clear(SM9_DIM_FQ12 d);
+int sm9_dim_fq12_powm(SM9_DIM_FQ12 out, SM9_DIM_FQ12 a, MPI b,
+		      struct sm9_ctx *ctx);
+size_t sm9_dim_fq12_get_size(SM9_DIM_FQ12 a);
+ssize_t sm9_dim_fq12_to_buf_rev(SM9_DIM_FQ12 a, char *buf, size_t size);
+
+int mpi_point_jacobian_to_affine(MPI_POINT out, MPI_POINT p, MPI q);
+int mpi_point_export(MPI_POINT P, u8 *buf, size_t size);
+int mpi_point_from_buf(MPI_POINT P, const u8 *buf, size_t size);
+#endif
-- 
2.17.1

