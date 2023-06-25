Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3803EB64DA
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Jun 2023 01:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjFYBvA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Jun 2023 21:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjFYBu7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Jun 2023 21:50:59 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E15C10C9
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 18:50:55 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QpYlc4SWfztQYf;
        Sun, 25 Jun 2023 09:48:12 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Sun, 25 Jun
 2023 09:50:53 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH RFC v3 2/3] crypto: Introduce SM9 key exchange algorithm library
Date:   Sun, 25 Jun 2023 09:49:57 +0800
Message-ID: <20230625014958.32631-3-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230625014958.32631-1-guozihua@huawei.com>
References: <20230625014958.32631-1-guozihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This commit introduces library for SM9 (ShangMi9) key exchange crypto
algorithm.

SM9 is an ID-based crypto algorithm providing asymmetric encryption,
signature and key exchange capability. Within which, the key exchange
algorithm has been accepted in ISO/IEC 11770-3:2021 international
standard.

sm9_lib.c contains mathematical algorithms used by SM9 key exchange
algorithm.

References:
http://c.gb688.cn/bzgk/gb/showGb?type=online&hcno=B7A0D7DFF411CD0AAE76135ADE91886A
http://c.gb688.cn/bzgk/gb/showGb?type=online&hcno=02A8E87248BD500747D2CD484C034EB0
https://github.com/guanzhi/GmSSL

Co-developed-by: LI Shiya <lishiya1@huawei.com>
Signed-off-by: GUO Zihua <guozihua@huawei.com>
---
 crypto/sm9_lib.c | 1585 ++++++++++++++++++++++++++++++++++++++++++++++
 crypto/sm9_lib.h |   92 +++
 2 files changed, 1677 insertions(+)
 create mode 100644 crypto/sm9_lib.c
 create mode 100644 crypto/sm9_lib.h

diff --git a/crypto/sm9_lib.c b/crypto/sm9_lib.c
new file mode 100644
index 000000000000..5cd43bd853d4
--- /dev/null
+++ b/crypto/sm9_lib.c
@@ -0,0 +1,1585 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Libraries for SM9 key exchange algorithm
+ *
+ * Copyright (c) 2023, Huawei Technology Co., Ltd.
+ * Authors: GUO Zihua <guozihua@huawei.com>
+ */
+
+#include <linux/module.h>
+#include <linux/mpi.h>
+#include <linux/string.h>
+#include <crypto/sm9.h>
+
+#include "sm9_lib.h"
+
+unsigned int mpi_dump_to_buf(MPI a, u8 *buf, unsigned int expected_size)
+{
+	unsigned int written_size;
+	u8 *mpi_buf;
+
+	if (expected_size < mpi_get_size(a))
+		return 0;
+
+	mpi_buf = mpi_get_buffer(a, &written_size, NULL);
+	if (!mpi_buf)
+		return 0;
+	memcpy(buf + (expected_size - written_size), mpi_buf, expected_size);
+	kfree(mpi_buf);
+	return expected_size;
+}
+
+int mpi_point_jacobian_to_affine(MPI_POINT out, MPI_POINT p, MPI q)
+{
+	MPI z, _q;
+	int rc = -ENOMEM;
+
+	if (!out)
+		return -EINVAL;
+
+	z = mpi_new(0);
+	_q = mpi_new(0);
+	if (!z || !_q)
+		goto out_free;
+
+	mpi_sub_ui(_q, q, 3);
+	mpi_powm(z, p->z, _q, q);
+	mpi_mulm(out->x, p->x, z, q);
+
+	mpi_sub_ui(_q, q, 4);
+	mpi_powm(z, p->z, _q, q);
+	mpi_mulm(out->y, p->y, z, q);
+
+	mpi_set_ui(out->z, 1);
+	rc = 0;
+
+out_free:
+	mpi_free(z);
+	mpi_free(_q);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(mpi_point_jacobian_to_affine);
+
+int mpi_point_export(MPI_POINT P, u8 *buf, size_t size)
+{
+	unsigned int nbytes, x_size;
+	int rc;
+
+	if (size < max(mpi_get_size(P->x), mpi_get_size(P->y)) * 2)
+		return -EINVAL;
+
+	x_size = size / 2;
+	rc = mpi_read_buffer(P->x, buf, x_size, &nbytes, NULL);
+	if (rc)
+		return nbytes;
+
+	rc = mpi_read_buffer(P->y, buf + x_size, x_size, &nbytes, NULL);
+	if (rc)
+		return nbytes;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpi_point_export);
+
+int mpi_point_from_buf(MPI_POINT P, const u8 *buf, size_t size)
+{
+	size_t x_size;
+	MPI x, y;
+
+	if (size % 2)
+		return -EINVAL;
+
+	x_size = size / 2;
+	x = mpi_read_raw_data(buf, x_size);
+	y = mpi_read_raw_data(buf + x_size, x_size);
+	if (!x || !y) {
+		mpi_free(x);
+		mpi_free(y);
+		return -ENOMEM;
+	}
+
+	mpi_set(P->x, x);
+	mpi_set(P->y, y);
+	mpi_set_ui(P->z, 1);
+
+	mpi_free(x);
+	mpi_free(y);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpi_point_from_buf);
+
+static void mpi_div2m(MPI out, MPI a, MPI q)
+{
+	mpi_set(out, a);
+
+	if (mpi_test_bit(a, 0))
+		mpi_add(out, out, q);
+	mpi_rshift(out, out, 1);
+	mpi_mod(out, out, q);
+}
+
+static bool sm9_dim_eq(SM9_DIM_FQ2 a, SM9_DIM_FQ2 b)
+{
+	return !(mpi_cmp(a[0], b[0]) && mpi_cmp(a[1], b[1]));
+}
+
+int sm9_dim_init(SM9_DIM_FQ2 dim, unsigned int nbits)
+{
+	if (!dim)
+		return -EINVAL;
+
+	dim[0] = mpi_new(nbits);
+	dim[1] = mpi_new(nbits);
+	if (!dim[0] || !dim[1])
+		return -ENOMEM;
+	return 0;
+}
+
+static int sm9_dim_init_from_buf(SM9_DIM_FQ2 dim, const u8 *buf, size_t size)
+{
+	size_t d_size;
+
+	if (size % 2)
+		return -EINVAL;
+
+	d_size = size / 2;
+	dim[1] = mpi_read_raw_data(buf, d_size);
+	dim[0] = mpi_read_raw_data(buf + d_size, d_size);
+	return 0;
+}
+
+void sm9_dim_deinit(SM9_DIM_FQ2 dim)
+{
+	mpi_free(dim[0]);
+	mpi_free(dim[1]);
+}
+
+void sm9_dim_free(SM9_DIM_FQ2 *dim)
+{
+	if (!dim)
+		return;
+
+	sm9_dim_deinit(*dim);
+	kfree(dim);
+}
+
+SM9_DIM_FQ2 *sm9_dim_alloc(unsigned int nbits)
+{
+	SM9_DIM_FQ2 *res;
+
+	res = kzalloc(sizeof(SM9_DIM_FQ2), GFP_KERNEL);
+	if (!res)
+		return NULL;
+
+	if (sm9_dim_init(*res, nbits)) {
+		kfree(res);
+		res = NULL;
+	}
+	return res;
+}
+
+int sm9_dim_set(SM9_DIM_FQ2 a, SM9_DIM_FQ2 b)
+{
+	mpi_set(a[0], b[0]);
+	mpi_set(a[1], b[1]);
+	return 0;
+}
+
+int sm9_dim_clear(SM9_DIM_FQ2 a)
+{
+	memzero_explicit(a[0]->d, a[0]->alloced * BYTES_PER_MPI_LIMB);
+	mpi_clear(a[0]);
+	memzero_explicit(a[1]->d, a[1]->alloced * BYTES_PER_MPI_LIMB);
+	mpi_clear(a[1]);
+	return 0;
+}
+
+static int sm9_dim_mulm(SM9_DIM_FQ2 out, SM9_DIM_FQ2 _a, SM9_DIM_FQ2 _b, MPI q)
+{
+	MPI tmp;
+	SM9_DIM_FQ2 a, b;
+	int rc;
+
+	if (!out)
+		return -EINVAL;
+
+	tmp = mpi_new(0);
+	if (!tmp)
+		return -ENOMEM;
+
+	rc = sm9_dim_init(a, 0);
+	rc |= sm9_dim_init(b, 0);
+	if (rc)
+		goto out_free;
+	sm9_dim_set(a, _a);
+	sm9_dim_set(b, _b);
+
+	mpi_mulm(out[0], a[0], b[0], q);
+	mpi_mulm(tmp, a[1], b[1], q);
+	mpi_addm(tmp, tmp, tmp, q);
+	mpi_subm(out[0], out[0], tmp, q);
+
+	mpi_mulm(out[1], a[0], b[1], q);
+	mpi_mulm(tmp, a[1], b[0], q);
+	mpi_addm(out[1], out[1], tmp, q);
+
+out_free:
+	sm9_dim_deinit(a);
+	sm9_dim_deinit(b);
+	mpi_free(tmp);
+	return rc;
+}
+
+static int sm9_dim_mulm_u(SM9_DIM_FQ2 out, SM9_DIM_FQ2 _a, SM9_DIM_FQ2 _b,
+			  MPI q)
+{
+	MPI tmp;
+	SM9_DIM_FQ2 a, b;
+	int rc;
+
+	if (!out)
+		return -EINVAL;
+
+	tmp = mpi_new(0);
+	if (!tmp)
+		return -ENOMEM;
+
+	rc = sm9_dim_init(a, 0);
+	rc |= sm9_dim_init(b, 0);
+	if (rc)
+		goto out_free;
+	sm9_dim_set(a, _a);
+	sm9_dim_set(b, _b);
+
+	mpi_mulm(out[0], a[0], b[1], q);
+	mpi_mulm(tmp, a[1], b[0], q);
+	mpi_addm(out[0], out[0], tmp, q);
+	mpi_addm(out[0], out[0], out[0], q);
+	mpi_subm(out[0], q, out[0], q);
+
+	mpi_mulm(out[1], a[0], b[0], q);
+	mpi_mulm(tmp, a[1], b[1], q);
+	mpi_addm(tmp, tmp, tmp, q);
+	mpi_subm(out[1], out[1], tmp, q);
+
+out_free:
+	sm9_dim_deinit(a);
+	sm9_dim_deinit(b);
+	mpi_free(tmp);
+	return 0;
+}
+
+static int sm9_dim_mulm_mpi(SM9_DIM_FQ2 out, SM9_DIM_FQ2 P, MPI a, MPI q)
+{
+	mpi_mulm(out[0], P[0], a, q);
+	mpi_mulm(out[1], P[1], a, q);
+	return 0;
+}
+
+static int sm9_dim_mulm_ui(SM9_DIM_FQ2 out, SM9_DIM_FQ2 P, unsigned int a,
+			   MPI q)
+{
+	int rc;
+	MPI p = mpi_new(0);
+
+	if (!p)
+		return -ENOMEM;
+
+	mpi_set_ui(p, a);
+	rc = sm9_dim_mulm_mpi(out, P, p, q);
+	mpi_free(p);
+	return rc;
+}
+
+static int sm9_dim_subm(SM9_DIM_FQ2 out, SM9_DIM_FQ2 a, SM9_DIM_FQ2 b, MPI q)
+{
+	if (!out)
+		return -EINVAL;
+
+	mpi_subm(out[0], a[0], b[0], q);
+	mpi_subm(out[1], a[1], b[1], q);
+	return 0;
+}
+
+static int sm9_dim_addm(SM9_DIM_FQ2 out, SM9_DIM_FQ2 a, SM9_DIM_FQ2 b, MPI q)
+{
+	if (!out)
+		return -EINVAL;
+
+	mpi_addm(out[0], a[0], b[0], q);
+	mpi_addm(out[1], a[1], b[1], q);
+	return 0;
+}
+
+static int sm9_dim_negm(SM9_DIM_FQ2 out, SM9_DIM_FQ2 a, MPI q)
+{
+	if (!out)
+		return -EINVAL;
+
+	mpi_subm(out[0], q, a[0], q);
+	mpi_subm(out[1], q, a[1], q);
+	return 0;
+}
+
+static int sm9_dim_div2m(SM9_DIM_FQ2 out, SM9_DIM_FQ2 a, MPI q)
+{
+	if (!out)
+		return -EINVAL;
+
+	mpi_div2m(out[0], a[0], q);
+	mpi_div2m(out[1], a[1], q);
+	return 0;
+}
+
+static int sm9_dim_conjugate(SM9_DIM_FQ2 out, SM9_DIM_FQ2 a, MPI q)
+{
+	if (!out)
+		return -EINVAL;
+
+	mpi_set(out[0], a[0]);
+	mpi_subm(out[1], q, a[1], q);
+	return 0;
+}
+
+static int sm9_dim_copy(SM9_DIM_FQ2 out, SM9_DIM_FQ2 a)
+{
+	if (!out)
+		return -EINVAL;
+
+	mpi_set(out[0], a[0]);
+	mpi_set(out[1], a[1]);
+	return 0;
+}
+
+static int sm9_dim_is_zero(SM9_DIM_FQ2 a)
+{
+	return !(mpi_cmp_ui(a[0], 0) || mpi_cmp_ui(a[1], 0));
+}
+
+static int sm9_dim_invm(SM9_DIM_FQ2 out, SM9_DIM_FQ2 a, MPI q, MPI q_minus_2)
+{
+	MPI t0, t1;
+
+	if (!out)
+		return -EINVAL;
+
+	if (!mpi_cmp_ui(a[0], 0)) {
+		mpi_clear(out[0]);
+		mpi_addm(out[1], a[1], a[1], q);
+		mpi_powm(out[1], out[1], q_minus_2, q);
+		mpi_subm(out[1], q, out[1], q);
+	} else if (!mpi_cmp_ui(a[1], 0)) {
+		mpi_clear(out[1]);
+		mpi_powm(out[0], q_minus_2, a[0], q);
+	} else {
+		t0 = mpi_new(0);
+		t1 = mpi_new(0);
+		if (!t0 || !t1) {
+			mpi_free(t0);
+			mpi_free(t1);
+			return -ENOMEM;
+		}
+
+		mpi_mulm(t0, a[0], a[0], q);
+		mpi_mulm(t1, a[1], a[1], q);
+		mpi_addm(t1, t1, t1, q);
+		mpi_addm(t0, t0, t1, q);
+		mpi_powm(t0, t0, q_minus_2, q);
+
+		mpi_mulm(out[0], a[0], t0, q);
+		mpi_mulm(out[1], a[1], t0, q);
+		mpi_subm(out[1], q, out[1], q);
+
+		mpi_free(t0);
+		mpi_free(t1);
+	}
+	return 0;
+}
+
+static size_t sm9_dim_get_size(SM9_DIM_FQ2 a)
+{
+	size_t size;
+
+	size = mpi_get_size(a[0]);
+	size += mpi_get_size(a[1]);
+	return size;
+}
+
+static ssize_t sm9_dim_to_buf_rev(SM9_DIM_FQ2 a, char *buf, size_t size)
+{
+	unsigned int d_size = size / 2, written_size;
+
+	written_size = mpi_dump_to_buf(a[1], buf, d_size);
+	if (written_size != d_size)
+		return -ENOMEM;
+
+	written_size = mpi_dump_to_buf(a[0], buf + d_size, d_size);
+	if (written_size != d_size)
+		return -ENOMEM;
+	return size;
+}
+
+static int sm9_point_copy(SM9_POINT out, SM9_POINT p)
+{
+	if (!out)
+		return -EINVAL;
+
+	if (out == p)
+		return 0;
+
+	mpi_set(out->xd1, p->xd1);
+	mpi_set(out->xd2, p->xd2);
+	mpi_set(out->yd1, p->yd1);
+	mpi_set(out->yd2, p->yd2);
+	mpi_set(out->zd1, p->zd1);
+	mpi_set(out->zd2, p->zd2);
+	return 0;
+}
+
+void sm9_point_release(SM9_POINT P)
+{
+	if (!P)
+		return;
+
+	sm9_dim_deinit(P->x_fq2);
+	sm9_dim_deinit(P->y_fq2);
+	sm9_dim_deinit(P->z_fq2);
+	kfree(P);
+}
+
+SM9_POINT sm9_point_new(unsigned int nbits)
+{
+	SM9_POINT res;
+
+	res = kzalloc(sizeof(struct sm9_point_fq2), GFP_KERNEL);
+	if (!res)
+		return NULL;
+
+	if (sm9_dim_init(res->x_fq2, nbits) ||
+	    sm9_dim_init(res->y_fq2, nbits) ||
+	    sm9_dim_init(res->z_fq2, nbits)) {
+		sm9_point_release(res);
+		return NULL;
+	}
+	return res;
+}
+
+SM9_POINT sm9_point_from_buf(const u8 *buf, size_t size)
+{
+	SM9_POINT res;
+	size_t x_size;
+	int rc;
+
+	res = kzalloc(sizeof(struct sm9_point_fq2), GFP_KERNEL);
+	if (!res)
+		return NULL;
+
+	x_size = size / 2;
+	rc = sm9_dim_init_from_buf(res->x_fq2, buf, x_size);
+	if (rc) {
+		kfree(res);
+		return NULL;
+	}
+
+	rc = sm9_dim_init_from_buf(res->y_fq2, buf + x_size, x_size);
+	if (rc) {
+		sm9_dim_deinit(res->x_fq2);
+		kfree(res);
+		return NULL;
+	}
+
+	rc = sm9_dim_init(res->z_fq2, 0);
+	if (rc) {
+		sm9_dim_deinit(res->x_fq2);
+		sm9_dim_deinit(res->y_fq2);
+		kfree(res);
+		return NULL;
+	}
+	mpi_set_ui(res->zd1, 1);
+	return res;
+}
+EXPORT_SYMBOL_GPL(sm9_point_from_buf);
+
+static bool sm9_point_is_infinity(SM9_POINT p)
+{
+	return !(mpi_cmp_ui(p->zd1, 0) && mpi_cmp_ui(p->zd2, 0));
+}
+
+bool sm9_point_valid(SM9_POINT P, struct sm9_ctx *ctx)
+{
+	SM9_DIM_FQ2 x, y;
+	SM9_POINT Q;
+	MPI q = ctx->sys_cfg->q;
+	bool rc;
+
+	if (sm9_dim_init(x, 0) || sm9_dim_init(y, 0)) {
+		sm9_dim_deinit(x);
+		sm9_dim_deinit(y);
+		return false;
+	}
+
+	sm9_dim_mulm(x, P->x_fq2, P->x_fq2, q);
+	sm9_dim_mulm(x, x, P->x_fq2, q);
+	mpi_addm(x[0], x[0], ctx->sys_cfg->b, q);
+
+	sm9_dim_mulm(y, P->y_fq2, P->y_fq2, q);
+	if (!sm9_dim_eq(x, y)) {
+		sm9_dim_deinit(x);
+		sm9_dim_deinit(y);
+		return false;
+	}
+
+	Q = sm9_point_new(0);
+	if (!Q) {
+		sm9_dim_deinit(x);
+		sm9_dim_deinit(y);
+		return false;
+	}
+	sm9_point_mpi_mulm(Q, P, ctx->sys_cfg->q, ctx);
+	rc = sm9_point_is_infinity(Q);
+
+	sm9_dim_deinit(x);
+	sm9_dim_deinit(y);
+	sm9_point_release(Q);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(sm9_point_valid);
+
+static int sm9_point_addm_same(SM9_POINT out, SM9_POINT _P, struct sm9_ctx *ctx)
+{
+	SM9_DIM_FQ2 x2, x4, y2, y4, tmp;
+	SM9_POINT P;
+	MPI q = ctx->sys_cfg->q;
+	int rc;
+
+	rc = sm9_dim_init(x2, 0);
+	rc |= sm9_dim_init(x4, 0);
+	rc |= sm9_dim_init(y2, 0);
+	rc |= sm9_dim_init(y4, 0);
+	rc |= sm9_dim_init(tmp, 0);
+	if (rc)
+		goto out_free;
+
+	P = sm9_point_new(0);
+	if (!P)
+		goto out_free;
+	sm9_point_copy(P, _P);
+
+	sm9_dim_mulm(x2, P->x_fq2, P->x_fq2, q);
+	sm9_dim_mulm(x4, x2, x2, q);
+	sm9_dim_mulm(y2, P->y_fq2, P->y_fq2, q);
+	sm9_dim_mulm(y4, y2, y2, q);
+
+	/* x3 = 9 * x1^4 - 8 * x1 * y1^2 */
+	sm9_dim_mulm_ui(out->x_fq2, x4, 9, q);
+	sm9_dim_mulm(tmp, P->x_fq2, y2, q);
+	sm9_dim_mulm_ui(tmp, tmp, 8, q);
+	sm9_dim_subm(out->x_fq2, out->x_fq2, tmp, q);
+
+	/* y3 = 3 * x1^2 * (4 * x1 * y1^2 - x3) - 8 * y1^4 */
+	sm9_dim_mulm(out->y_fq2, P->x_fq2, y2, q);
+	sm9_dim_mulm_ui(out->y_fq2, out->y_fq2, 4, q);
+	sm9_dim_subm(out->y_fq2, out->y_fq2, out->x_fq2, q);
+	sm9_dim_mulm(out->y_fq2, out->y_fq2, x2, q);
+	sm9_dim_mulm_ui(out->y_fq2, out->y_fq2, 3, q);
+	sm9_dim_mulm_ui(tmp, y4, 8, q);
+	sm9_dim_subm(out->y_fq2, out->y_fq2, tmp, q);
+
+	/* z3 = 2 * y1 * z1 */
+	sm9_dim_mulm(out->z_fq2, P->y_fq2, P->z_fq2, q);
+	sm9_dim_mulm_ui(out->z_fq2, out->z_fq2, 2, q);
+
+	rc = 0;
+out_free:
+	sm9_dim_deinit(x2);
+	sm9_dim_deinit(x4);
+	sm9_dim_deinit(y2);
+	sm9_dim_deinit(y4);
+	sm9_dim_deinit(tmp);
+	sm9_point_release(P);
+	return rc;
+}
+
+static int sm9_point_addm_diff(SM9_POINT out, SM9_POINT _P, SM9_POINT _Q,
+			       struct sm9_ctx *ctx)
+{
+	SM9_DIM_FQ2 u1, u2, s1, s2, h, h2, h3, r, tmp;
+	SM9_POINT P, Q;
+	MPI q = ctx->sys_cfg->q;
+	int rc;
+
+	rc = sm9_dim_init(u1, 0);
+	rc |= sm9_dim_init(u2, 0);
+	rc |= sm9_dim_init(s1, 0);
+	rc |= sm9_dim_init(s2, 0);
+	rc |= sm9_dim_init(h, 0);
+	rc |= sm9_dim_init(h2, 0);
+	rc |= sm9_dim_init(h3, 0);
+	rc |= sm9_dim_init(r, 0);
+	rc |= sm9_dim_init(tmp, 0);
+	if (rc)
+		goto out_free;
+
+	P = sm9_point_new(0);
+	Q = sm9_point_new(0);
+	if (!Q || !P)
+		goto out_free_point;
+	sm9_point_copy(P, _P);
+	sm9_point_copy(Q, _Q);
+
+	/* u1 = x1 * z2^2 */
+	sm9_dim_mulm(u1, Q->z_fq2, Q->z_fq2, q);
+	sm9_dim_mulm(u1, P->x_fq2, u1, q);
+	/* u2 = x2 * z1^2 */
+	sm9_dim_mulm(u2, P->z_fq2, P->z_fq2, q);
+	sm9_dim_mulm(u2, Q->x_fq2, u2, q);
+	/* s1 = y1 * z2^3 */
+	sm9_dim_mulm(s1, Q->z_fq2, Q->z_fq2, q);
+	sm9_dim_mulm(s1, s1, Q->z_fq2, q);
+	sm9_dim_mulm(s1, P->y_fq2, s1, q);
+	/* s2 = y2 * z1^3 */
+	sm9_dim_mulm(s2, P->z_fq2, P->z_fq2, q);
+	sm9_dim_mulm(s2, s2, P->z_fq2, q);
+	sm9_dim_mulm(s2, Q->y_fq2, s2, q);
+	/* h = u2 - u1 */
+	sm9_dim_subm(h, u2, u1, q);
+	/* r = s2 - s1 */
+	sm9_dim_subm(r, s2, s1, q);
+
+	/* x3 = r^2 - h^3 - 2 * u1 * h^2 */
+	sm9_dim_mulm(out->x_fq2, r, r, q);
+	sm9_dim_mulm(out->x_fq2, r, r, q);
+	sm9_dim_mulm(h2, h, h, q);
+	sm9_dim_mulm(h3, h2, h, q);
+	sm9_dim_subm(out->x_fq2, out->x_fq2, h3, q);
+	sm9_dim_mulm(tmp, u1, h2, q);
+	sm9_dim_mulm_ui(tmp, tmp, 2, q);
+	sm9_dim_subm(out->x_fq2, out->x_fq2, tmp, q);
+
+	/* y3 = r * (u1 * h^2 - x3) - s1 * h^3 */
+	sm9_dim_mulm(out->y_fq2, u1, h2, q);
+	sm9_dim_subm(out->y_fq2, out->y_fq2, out->x_fq2, q);
+	sm9_dim_mulm(out->y_fq2, r, out->y_fq2, q);
+	sm9_dim_mulm(tmp, s1, h3, q);
+	sm9_dim_subm(out->y_fq2, out->y_fq2, tmp, q);
+
+	/* z3 = z1 * z2 * h */
+	sm9_dim_mulm(out->z_fq2, P->z_fq2, Q->z_fq2, q);
+	sm9_dim_mulm(out->z_fq2, out->z_fq2, h, q);
+
+	rc = 0;
+out_free_point:
+	sm9_point_release(P);
+	sm9_point_release(Q);
+out_free:
+	sm9_dim_deinit(u1);
+	sm9_dim_deinit(u2);
+	sm9_dim_deinit(s1);
+	sm9_dim_deinit(s2);
+	sm9_dim_deinit(h);
+	sm9_dim_deinit(h2);
+	sm9_dim_deinit(h3);
+	sm9_dim_deinit(r);
+	sm9_dim_deinit(tmp);
+	return rc;
+}
+
+static int sm9_point_same(SM9_POINT a, SM9_POINT b)
+{
+	if (a == b)
+		return 1;
+
+	if (!mpi_cmp(a->xd1, b->xd1) && !mpi_cmp(a->xd2, b->xd2) &&
+	    !mpi_cmp(a->yd1, b->yd1) && !mpi_cmp(a->yd2, b->yd2) &&
+	    !mpi_cmp(a->zd1, b->zd1) && !mpi_cmp(a->zd2, b->zd2))
+		return 1;
+	return 0;
+}
+
+int sm9_point_addm(SM9_POINT out, SM9_POINT P, SM9_POINT Q, struct sm9_ctx *ctx)
+{
+	if (!out)
+		return -EINVAL;
+
+	if (sm9_dim_is_zero(P->z_fq2)) {
+		sm9_point_copy(out, Q);
+		return 0;
+	} else if (sm9_dim_is_zero(Q->z_fq2)) {
+		sm9_point_copy(out, P);
+		return 0;
+	}
+
+	if (sm9_point_same(P, Q))
+		return sm9_point_addm_same(out, P, ctx);
+	return sm9_point_addm_diff(out, P, Q, ctx);
+}
+EXPORT_SYMBOL_GPL(sm9_point_addm);
+
+int sm9_point_mpi_mulm(SM9_POINT out, SM9_POINT _P, MPI a, struct sm9_ctx *ctx)
+{
+	SM9_POINT P;
+	int i;
+
+	if (!out)
+		return -EINVAL;
+
+	P = sm9_point_new(0);
+	if (!P)
+		return -ENOMEM;
+	mpi_set_ui(P->xd1, 1);
+	mpi_set_ui(P->yd1, 1);
+	mpi_set_ui(P->zd1, 0);
+
+	for (i = mpi_get_nbits(a) - 1; i >= 0; i--) {
+		sm9_point_addm(P, P, P, ctx);
+		if (mpi_test_bit(a, i))
+			sm9_point_addm(P, P, _P, ctx);
+	}
+	sm9_point_copy(out, P);
+	sm9_point_release(P);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sm9_point_mpi_mulm);
+
+int sm9_point_mpi_addm(SM9_POINT out, SM9_POINT P, MPI a, MPI q)
+{
+	if (!out)
+		return -EINVAL;
+
+	mpi_addm(out->xd1, P->xd1, a, q);
+	mpi_addm(out->yd1, P->yd1, a, q);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sm9_point_mpi_addm);
+
+void sm9_point_clear(SM9_POINT p)
+{
+	sm9_dim_clear(p->x_fq2);
+	sm9_dim_clear(p->y_fq2);
+	sm9_dim_clear(p->z_fq2);
+}
+EXPORT_SYMBOL_GPL(sm9_point_clear);
+
+int sm9_dim_fq4_set(SM9_DIM_FQ4 a, SM9_DIM_FQ4 b)
+{
+	sm9_dim_set(a[0], b[0]);
+	sm9_dim_set(a[1], b[1]);
+	return 0;
+}
+
+void sm9_dim_fq4_deinit(SM9_DIM_FQ4 p)
+{
+	sm9_dim_deinit(p[0]);
+	sm9_dim_deinit(p[1]);
+}
+
+int sm9_dim_fq4_init(SM9_DIM_FQ4 p, unsigned int nbits)
+{
+	int i, rc;
+
+	if (!p)
+		return -EINVAL;
+
+	for (i = 0; i < 2; i++) {
+		rc = sm9_dim_init(p[i], 0);
+		if (rc) {
+			sm9_dim_fq4_deinit(p);
+			return rc;
+		}
+	}
+	return 0;
+}
+
+int sm9_dim_fq4_clear(SM9_DIM_FQ4 p)
+{
+	sm9_dim_clear(p[0]);
+	sm9_dim_clear(p[1]);
+	return 0;
+}
+
+static int sm9_dim_fq4_mulm(SM9_DIM_FQ4 out, SM9_DIM_FQ4 _a, SM9_DIM_FQ4 _b,
+			    struct sm9_ctx *ctx)
+{
+	SM9_DIM_FQ2 tmp;
+	SM9_DIM_FQ4 a, b;
+	MPI q = ctx->sys_cfg->q;
+	int rc;
+
+	rc = sm9_dim_init(tmp, 0);
+	rc |= sm9_dim_fq4_init(a, 0);
+	rc |= sm9_dim_fq4_init(b, 0);
+	if (rc)
+		goto out_free;
+	sm9_dim_fq4_set(a, _a);
+	sm9_dim_fq4_set(b, _b);
+
+	sm9_dim_mulm(out[0], a[0], b[0], q);
+	sm9_dim_mulm_u(tmp, a[1], b[1], q);
+	sm9_dim_addm(out[0], out[0], tmp, q);
+
+	sm9_dim_mulm(out[1], a[0], b[1], q);
+	sm9_dim_mulm(tmp, a[1], b[0], q);
+	sm9_dim_addm(out[1], out[1], tmp, q);
+
+out_free:
+	sm9_dim_fq4_deinit(a);
+	sm9_dim_fq4_deinit(b);
+	sm9_dim_deinit(tmp);
+	return rc;
+}
+
+static int sm9_dim_fq4_mulm_mpi(SM9_DIM_FQ4 out, SM9_DIM_FQ4 a, MPI b,
+				struct sm9_ctx *ctx)
+{
+	sm9_dim_mulm_mpi(out[0], a[0], b, ctx->sys_cfg->q);
+	sm9_dim_mulm_mpi(out[1], a[1], b, ctx->sys_cfg->q);
+	return 0;
+}
+
+static int sm9_dim_fq4_mulm_v(SM9_DIM_FQ4 out, SM9_DIM_FQ4 _a, SM9_DIM_FQ4 _b,
+			      struct sm9_ctx *ctx)
+{
+	SM9_DIM_FQ2 tmp;
+	SM9_DIM_FQ4 a, b;
+	MPI q = ctx->sys_cfg->q;
+	int rc;
+
+	rc = sm9_dim_init(tmp, 0);
+	rc |= sm9_dim_fq4_init(a, 0);
+	rc |= sm9_dim_fq4_init(b, 0);
+	if (rc)
+		goto out_free;
+	sm9_dim_fq4_set(a, _a);
+	sm9_dim_fq4_set(b, _b);
+
+	sm9_dim_mulm_u(out[0], a[1], b[0], q);
+	sm9_dim_mulm_u(tmp, a[0], b[1], q);
+	sm9_dim_addm(out[0], out[0], tmp, q);
+
+	sm9_dim_mulm(out[1], a[0], b[0], q);
+	sm9_dim_mulm_u(tmp, a[1], b[1], q);
+	sm9_dim_addm(out[1], out[1], tmp, q);
+
+out_free:
+	sm9_dim_fq4_deinit(a);
+	sm9_dim_fq4_deinit(b);
+	sm9_dim_deinit(tmp);
+	return 0;
+}
+
+static int sm9_dim_fq4_addm(SM9_DIM_FQ4 out, SM9_DIM_FQ4 a, SM9_DIM_FQ4 b,
+			    struct sm9_ctx *ctx)
+{
+	MPI q = ctx->sys_cfg->q;
+
+	sm9_dim_addm(out[0], a[0], b[0], q);
+	sm9_dim_addm(out[1], a[1], b[1], q);
+
+	return 0;
+}
+
+static int sm9_dim_fq4_subm(SM9_DIM_FQ4 out, SM9_DIM_FQ4 a, SM9_DIM_FQ4 b,
+			    struct sm9_ctx *ctx)
+{
+	sm9_dim_subm(out[0], a[0], b[0], ctx->sys_cfg->q);
+	sm9_dim_subm(out[1], a[1], b[1], ctx->sys_cfg->q);
+	return 0;
+}
+
+static int sm9_dim_fq4_invm(SM9_DIM_FQ4 out, SM9_DIM_FQ4 a, struct sm9_ctx *ctx)
+{
+	SM9_DIM_FQ2 t0, t1, t2;
+	MPI q = ctx->sys_cfg->q;
+
+	if (sm9_dim_init(t0, 0) || sm9_dim_init(t1, 0) || sm9_dim_init(t2, 0)) {
+		sm9_dim_deinit(t0);
+		sm9_dim_deinit(t1);
+		sm9_dim_deinit(t2);
+		return -ENOMEM;
+	}
+
+	sm9_dim_mulm_u(t2, a[1], a[1], q);
+	sm9_dim_mulm(t0, a[0], a[0], q);
+	sm9_dim_subm(t2, t2, t0, q);
+	sm9_dim_invm(t2, t2, q, ctx->sys_cfg->q_minus_2);
+
+	sm9_dim_mulm(t0, a[0], t2, q);
+	sm9_dim_negm(out[0], t0, q);
+
+	sm9_dim_mulm(out[1], a[1], t2, q);
+
+	sm9_dim_deinit(t0);
+	sm9_dim_deinit(t1);
+	sm9_dim_deinit(t2);
+	return 0;
+}
+
+static int sm9_dim_fq4_is_zero(SM9_DIM_FQ4 a)
+{
+	return sm9_dim_is_zero(a[0]) && sm9_dim_is_zero(a[1]);
+}
+
+static int sm9_dim_fq4_negm(SM9_DIM_FQ4 out, SM9_DIM_FQ4 a, struct sm9_ctx *ctx)
+{
+	sm9_dim_negm(out[0], a[0], ctx->sys_cfg->q);
+	sm9_dim_negm(out[1], a[1], ctx->sys_cfg->q);
+	return 0;
+}
+
+static int sm9_dim_fq4_conjugate(SM9_DIM_FQ4 out, SM9_DIM_FQ4 a,
+				 struct sm9_ctx *ctx)
+{
+	sm9_dim_set(out[0], a[0]);
+	sm9_dim_negm(out[1], a[1], ctx->sys_cfg->q);
+	return 0;
+}
+
+static size_t sm9_dim_fq4_get_size(SM9_DIM_FQ4 a)
+{
+	size_t size;
+
+	size = sm9_dim_get_size(a[0]);
+	size += sm9_dim_get_size(a[1]);
+	return size;
+}
+
+static ssize_t sm9_dim_fq4_to_buf_rev(SM9_DIM_FQ4 a, char *buf, size_t size)
+{
+	ssize_t d_size = size / 2, written_size;
+
+	written_size = sm9_dim_to_buf_rev(a[1], buf, d_size);
+	if (written_size < 0)
+		return written_size;
+
+	written_size = sm9_dim_to_buf_rev(a[0], buf + d_size, d_size);
+	if (written_size < 0)
+		return written_size;
+	return size;
+}
+
+int sm9_dim_fq12_set(SM9_DIM_FQ12 a, SM9_DIM_FQ12 b)
+{
+	sm9_dim_fq4_set(a[0], b[0]);
+	sm9_dim_fq4_set(a[1], b[1]);
+	sm9_dim_fq4_set(a[2], b[2]);
+	return 0;
+}
+
+void sm9_dim_fq12_deinit(SM9_DIM_FQ12 d)
+{
+	sm9_dim_fq4_deinit(d[0]);
+	sm9_dim_fq4_deinit(d[1]);
+	sm9_dim_fq4_deinit(d[2]);
+}
+
+int sm9_dim_fq12_init(SM9_DIM_FQ12 d, unsigned int nbits)
+{
+	int i, j;
+
+	for (i = 0; i < 3; i++) {
+		for (j = 0; j < 2; j++)
+			sm9_dim_init(d[i][j], nbits);
+	}
+	return 0;
+}
+
+int sm9_dim_fq12_clear(SM9_DIM_FQ12 d)
+{
+	int i, j;
+
+	for (i = 0; i < 3; i++) {
+		for (j = 0; j < 2; j++)
+			sm9_dim_clear(d[i][j]);
+	}
+	return 0;
+}
+
+static int sm9_dim_fq12_mulm(SM9_DIM_FQ12 out, SM9_DIM_FQ12 _a, SM9_DIM_FQ12 _b,
+			     struct sm9_ctx *ctx)
+{
+	SM9_DIM_FQ4 tmp;
+	SM9_DIM_FQ12 a, b;
+	int rc;
+
+	rc = sm9_dim_fq4_init(tmp, 0);
+	rc |= sm9_dim_fq12_init(a, 0);
+	rc |= sm9_dim_fq12_init(b, 0);
+	if (rc)
+		goto out_free;
+	sm9_dim_fq12_set(a, _a);
+	sm9_dim_fq12_set(b, _b);
+
+	sm9_dim_fq4_mulm(out[0], a[0], b[0], ctx);
+	sm9_dim_fq4_mulm_v(tmp, a[1], b[2], ctx);
+	sm9_dim_fq4_addm(out[0], out[0], tmp, ctx);
+	sm9_dim_fq4_mulm_v(tmp, a[2], b[1], ctx);
+	sm9_dim_fq4_addm(out[0], out[0], tmp, ctx);
+
+	sm9_dim_fq4_mulm(out[1], a[0], b[1], ctx);
+	sm9_dim_fq4_mulm(tmp, a[1], b[0], ctx);
+	sm9_dim_fq4_addm(out[1], out[1], tmp, ctx);
+	sm9_dim_fq4_mulm_v(tmp, a[2], b[2], ctx);
+	sm9_dim_fq4_addm(out[1], out[1], tmp, ctx);
+
+	sm9_dim_fq4_mulm(out[2], a[0], b[2], ctx);
+	sm9_dim_fq4_mulm(tmp, a[1], b[1], ctx);
+	sm9_dim_fq4_addm(out[2], out[2], tmp, ctx);
+	sm9_dim_fq4_mulm(tmp, a[2], b[0], ctx);
+	sm9_dim_fq4_addm(out[2], out[2], tmp, ctx);
+
+out_free:
+	sm9_dim_fq12_deinit(a);
+	sm9_dim_fq12_deinit(b);
+	sm9_dim_fq4_deinit(tmp);
+	return rc;
+}
+
+int sm9_dim_fq12_powm(SM9_DIM_FQ12 out, SM9_DIM_FQ12 a, MPI b,
+		      struct sm9_ctx *ctx)
+{
+	int i;
+	SM9_DIM_FQ12 tmp;
+	int rc = -EINVAL;
+
+	rc = sm9_dim_fq12_init(tmp, 0);
+	if (rc)
+		return -ENOMEM;
+	mpi_set_ui(tmp[0][0][0], 1);
+
+	for (i = mpi_get_nbits(b); i >= 0; i--) {
+		sm9_dim_fq12_mulm(tmp, tmp, tmp, ctx);
+		if (mpi_test_bit(b, i))
+			sm9_dim_fq12_mulm(tmp, a, tmp, ctx);
+	}
+	sm9_dim_fq12_set(out, tmp);
+
+	sm9_dim_fq12_deinit(tmp);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(sm9_dim_fq12_powm);
+
+static int sm9_dim_fq12_powm_ui(SM9_DIM_FQ12 out, SM9_DIM_FQ12 a,
+				unsigned int b, struct sm9_ctx *ctx)
+{
+	MPI i = NULL;
+	int rc;
+
+	i = mpi_new(0);
+	if (!i)
+		return -ENOMEM;
+
+	mpi_set_ui(i, b);
+	rc = sm9_dim_fq12_powm(out, a, i, ctx);
+	mpi_free(i);
+	return rc;
+}
+
+static int sm9_dim_fq12_invm(SM9_DIM_FQ12 out, SM9_DIM_FQ12 _a,
+			     struct sm9_ctx *ctx)
+{
+	SM9_DIM_FQ4 t0, t1, t2, t3;
+	SM9_DIM_FQ12 a;
+	int rc;
+
+	rc = sm9_dim_fq4_init(t0, 0);
+	rc |= sm9_dim_fq4_init(t1, 0);
+	rc |= sm9_dim_fq4_init(t2, 0);
+	rc |= sm9_dim_fq4_init(t3, 0);
+	rc |= sm9_dim_fq12_init(a, 0);
+	if (rc)
+		goto out_free;
+	sm9_dim_fq12_set(a, _a);
+
+	if (sm9_dim_fq4_is_zero(a[2])) {
+		sm9_dim_fq4_mulm(t0, a[0], a[0], ctx);
+		sm9_dim_fq4_mulm(t0, t0, a[0], ctx);
+		sm9_dim_fq4_mulm_v(t1, a[1], a[1], ctx);
+		sm9_dim_fq4_mulm(t1, t1, a[1], ctx);
+		sm9_dim_fq4_addm(t0, t0, t1, ctx);
+		sm9_dim_fq4_invm(t0, t0, ctx);
+
+		sm9_dim_fq4_mulm(out[2], a[1], a[1], ctx);
+		sm9_dim_fq4_mulm(out[2], out[2], t0, ctx);
+
+		sm9_dim_fq4_mulm(out[1], a[0], a[1], ctx);
+		sm9_dim_fq4_mulm(out[1], out[1], t0, ctx);
+		sm9_dim_fq4_negm(out[1], out[1], ctx);
+
+		sm9_dim_fq4_mulm(out[0], a[0], a[0], ctx);
+		sm9_dim_fq4_mulm(out[0], out[0], t0, ctx);
+		rc = 0;
+		goto out_free;
+	}
+
+	sm9_dim_fq4_mulm(t0, a[1], a[1], ctx);
+	sm9_dim_fq4_mulm(t1, a[0], a[2], ctx);
+	sm9_dim_fq4_subm(t0, t0, t1, ctx);
+
+	sm9_dim_fq4_mulm(t1, a[0], a[1], ctx);
+	sm9_dim_fq4_mulm_v(t2, a[2], a[2], ctx);
+	sm9_dim_fq4_subm(t1, t1, t2, ctx);
+
+	sm9_dim_fq4_mulm(t2, a[0], a[0], ctx);
+	sm9_dim_fq4_mulm_v(t3, a[1], a[2], ctx);
+	sm9_dim_fq4_subm(t2, t2, t3, ctx);
+
+	sm9_dim_fq4_mulm(t3, t1, t1, ctx);
+	sm9_dim_fq4_mulm(out[0], t0, t2, ctx);
+	sm9_dim_fq4_subm(t3, t3, out[0], ctx);
+	sm9_dim_fq4_invm(t3, t3, ctx);
+	sm9_dim_fq4_mulm(t3, a[2], t3, ctx);
+
+	sm9_dim_fq4_mulm(out[0], t2, t3, ctx);
+	sm9_dim_fq4_mulm(out[1], t1, t3, ctx);
+	sm9_dim_fq4_negm(out[1], out[1], ctx);
+	sm9_dim_fq4_mulm(out[2], t0, t3, ctx);
+
+	rc = 0;
+out_free:
+	sm9_dim_fq12_deinit(a);
+	sm9_dim_fq4_deinit(t0);
+	sm9_dim_fq4_deinit(t1);
+	sm9_dim_fq4_deinit(t2);
+	sm9_dim_fq4_deinit(t3);
+	return rc;
+}
+
+size_t sm9_dim_fq12_get_size(SM9_DIM_FQ12 a)
+{
+	size_t size;
+
+	size = sm9_dim_fq4_get_size(a[0]);
+	size += sm9_dim_fq4_get_size(a[1]);
+	size += sm9_dim_fq4_get_size(a[2]);
+	return size;
+}
+EXPORT_SYMBOL_GPL(sm9_dim_fq12_get_size);
+
+ssize_t sm9_dim_fq12_to_buf_rev(SM9_DIM_FQ12 a, char *buf, size_t size)
+{
+	ssize_t d_size = size / 3, written_size;
+
+	if (size % 3)
+		return -EINVAL;
+
+	written_size = sm9_dim_fq4_to_buf_rev(a[2], buf, d_size);
+	if (written_size < 0)
+		return written_size;
+
+	written_size = sm9_dim_fq4_to_buf_rev(a[1], buf + d_size, d_size);
+	if (written_size < 0)
+		return written_size;
+
+	written_size = sm9_dim_fq4_to_buf_rev(a[0], buf + 2 * d_size, d_size);
+	if (written_size < 0)
+		return written_size;
+	return size;
+}
+EXPORT_SYMBOL_GPL(sm9_dim_fq12_to_buf_rev);
+
+static int sm9_dim_fq12_frobenius_6(SM9_DIM_FQ12 out, SM9_DIM_FQ12 a,
+				    struct sm9_ctx *ctx)
+{
+	sm9_dim_fq4_conjugate(out[0], a[0], ctx);
+	sm9_dim_fq4_conjugate(out[1], a[1], ctx);
+	sm9_dim_fq4_negm(out[1], out[1], ctx);
+	sm9_dim_fq4_conjugate(out[2], a[2], ctx);
+	return 0;
+}
+
+static int sm9_dim_fq12_frobenius_3(SM9_DIM_FQ12 out, SM9_DIM_FQ12 a,
+				    struct sm9_ctx *ctx)
+{
+	MPI q = ctx->sys_cfg->q;
+	SM9_DIM_FQ2 beta;
+
+	if (sm9_dim_init(beta, 0))
+		return -ENOMEM;
+
+	mpi_set(beta[0], ctx->sys_cfg->beta);
+
+	sm9_dim_conjugate(out[0][0], a[0][0], q);
+	sm9_dim_conjugate(out[0][1], a[0][1], q);
+	sm9_dim_mulm(out[0][1], out[0][1], beta, q);
+	sm9_dim_negm(out[0][1], out[0][1], q);
+
+	sm9_dim_conjugate(out[1][0], a[1][0], q);
+	sm9_dim_mulm(out[1][0], out[1][0], beta, q);
+	sm9_dim_conjugate(out[1][1], a[1][1], q);
+
+	sm9_dim_conjugate(out[2][0], a[2][0], q);
+	sm9_dim_negm(out[2][0], out[2][0], q);
+	sm9_dim_conjugate(out[2][1], a[2][1], q);
+	sm9_dim_mulm(out[2][1], out[2][1], beta, q);
+
+	sm9_dim_deinit(beta);
+	return 0;
+}
+
+static int sm9_dim_fq12_frobenius_2(SM9_DIM_FQ12 out, SM9_DIM_FQ12 a,
+				    struct sm9_ctx *ctx)
+{
+	sm9_dim_fq4_conjugate(out[0], a[0], ctx);
+	sm9_dim_fq4_conjugate(out[1], a[1], ctx);
+	sm9_dim_fq4_mulm_mpi(out[1], out[1], ctx->sys_cfg->alpha2, ctx);
+	sm9_dim_fq4_conjugate(out[2], a[2], ctx);
+	sm9_dim_fq4_mulm_mpi(out[2], out[2], ctx->sys_cfg->alpha4, ctx);
+	return 0;
+}
+
+static int sm9_dim_fq12_frobenius(SM9_DIM_FQ12 out, SM9_DIM_FQ12 a,
+				  struct sm9_ctx *ctx)
+{
+	MPI q = ctx->sys_cfg->q;
+
+	sm9_dim_conjugate(out[0][0], a[0][0], q);
+	sm9_dim_conjugate(out[0][1], a[0][1], q);
+	sm9_dim_mulm_mpi(out[0][1], out[0][1], ctx->sys_cfg->alpha3, q);
+
+	sm9_dim_conjugate(out[1][0], a[1][0], q);
+	sm9_dim_mulm_mpi(out[1][0], out[1][0], ctx->sys_cfg->alpha1, q);
+	sm9_dim_conjugate(out[1][1], a[1][1], q);
+	sm9_dim_mulm_mpi(out[1][1], out[1][1], ctx->sys_cfg->alpha4, q);
+
+	sm9_dim_conjugate(out[2][0], a[2][0], q);
+	sm9_dim_mulm_mpi(out[2][0], out[2][0], ctx->sys_cfg->alpha2, q);
+	sm9_dim_conjugate(out[2][1], a[2][1], q);
+	sm9_dim_mulm_mpi(out[2][1], out[2][1], ctx->sys_cfg->alpha5, q);
+	return 0;
+}
+
+static int g_V_V_Q(SM9_DIM_FQ12 num, SM9_DIM_FQ12 den, SM9_POINT V, MPI_POINT Q,
+		   struct sm9_ctx *ctx)
+{
+	SM9_DIM_FQ2 t0, t1, t2;
+	MPI q = ctx->sys_cfg->q;
+	int rc = -ENOMEM;
+
+	if (sm9_dim_init(t0, 0) || sm9_dim_init(t1, 0) || sm9_dim_init(t2, 0))
+		goto out_free;
+
+	sm9_dim_fq12_clear(num);
+	sm9_dim_fq12_clear(den);
+
+	sm9_dim_mulm(t0, V->z_fq2, V->z_fq2, q);
+	sm9_dim_mulm(t1, t0, V->z_fq2, q);
+	sm9_dim_mulm(den[0][1], t1, V->y_fq2, q);
+
+	sm9_dim_mulm_mpi(t2, den[0][1], Q->y, q);
+	sm9_dim_negm(num[0][1], t2, q);
+
+	sm9_dim_mulm(t1, V->x_fq2, V->x_fq2, q);
+	sm9_dim_mulm(t0, t0, t1, q);
+	sm9_dim_mulm_mpi(t0, t0, Q->x, q);
+	sm9_dim_mulm_ui(t0, t0, 3, q);
+	sm9_dim_div2m(num[2][0], t0, q);
+
+	sm9_dim_mulm(t1, t1, V->x_fq2, q);
+	sm9_dim_mulm_ui(t1, t1, 3, q);
+	sm9_dim_div2m(t1, t1, q);
+	sm9_dim_mulm(t0, V->y_fq2, V->y_fq2, q);
+	sm9_dim_subm(num[0][0], t0, t1, q);
+
+	rc = 0;
+
+out_free:
+	sm9_dim_deinit(t0);
+	sm9_dim_deinit(t1);
+	sm9_dim_deinit(t2);
+	return rc;
+}
+
+static int g_U_V_Q(SM9_DIM_FQ12 num, SM9_DIM_FQ12 den, SM9_POINT U, SM9_POINT V,
+		   MPI_POINT Q, struct sm9_ctx *ctx)
+{
+	SM9_DIM_FQ2 t0, t1, t2, t3, t4;
+	MPI q = ctx->sys_cfg->q;
+	int rc = -ENOMEM;
+
+	if (sm9_dim_init(t0, 0) || sm9_dim_init(t1, 0) || sm9_dim_init(t2, 0) ||
+	    sm9_dim_init(t3, 0) || sm9_dim_init(t4, 0))
+		goto out_free;
+
+	sm9_dim_fq12_clear(num);
+	sm9_dim_fq12_clear(den);
+
+	sm9_dim_mulm(t0, V->z_fq2, V->z_fq2, q);
+	sm9_dim_mulm(t1, t0, U->x_fq2, q);
+	sm9_dim_mulm(t0, t0, V->z_fq2, q);
+	sm9_dim_mulm(t2, U->z_fq2, U->z_fq2, q);
+	sm9_dim_mulm(t3, t2, V->x_fq2, q);
+	sm9_dim_mulm(t2, t2, U->z_fq2, q);
+	sm9_dim_mulm(t2, t2, V->y_fq2, q);
+	sm9_dim_subm(t1, t1, t3, q);
+	sm9_dim_mulm(t1, t1, U->z_fq2, q);
+	sm9_dim_mulm(t1, t1, V->z_fq2, q);
+	sm9_dim_mulm(den[0][1], t1, t0, q);
+	sm9_dim_mulm(t1, t1, V->y_fq2, q);
+	sm9_dim_mulm(t3, t0, U->y_fq2, q);
+	sm9_dim_subm(t3, t3, t2, q);
+	sm9_dim_mulm(t0, t0, t3, q);
+	sm9_dim_mulm_mpi(num[2][0], t0, Q->x, q);
+	sm9_dim_mulm(t3, t3, V->x_fq2, q);
+	sm9_dim_mulm(t3, t3, V->z_fq2, q);
+	sm9_dim_subm(num[0][0], t1, t3, q);
+	sm9_dim_mulm_mpi(t2, den[0][1], Q->y, q);
+	sm9_dim_negm(num[0][1], t2, q);
+
+	rc = 0;
+out_free:
+	sm9_dim_deinit(t0);
+	sm9_dim_deinit(t1);
+	sm9_dim_deinit(t2);
+	sm9_dim_deinit(t3);
+	sm9_dim_deinit(t4);
+
+	return rc;
+}
+
+static int sm9_point_pi_q(SM9_POINT out, SM9_POINT p, struct sm9_ctx *ctx)
+{
+	MPI q = ctx->sys_cfg->q;
+
+	if (!out)
+		return -EINVAL;
+
+	sm9_dim_conjugate(out->x_fq2, p->x_fq2, q);
+	sm9_dim_conjugate(out->y_fq2, p->y_fq2, q);
+	sm9_dim_conjugate(out->z_fq2, p->z_fq2, q);
+	sm9_dim_mulm_mpi(out->z_fq2, out->z_fq2, ctx->sys_cfg->pi_q_c, q);
+	return 0;
+}
+
+static int sm9_point_neg_pi_q2(SM9_POINT out, SM9_POINT p, struct sm9_ctx *ctx)
+{
+	if (!out)
+		return -EINVAL;
+
+	sm9_dim_copy(out->x_fq2, p->x_fq2);
+	sm9_dim_negm(out->y_fq2, p->y_fq2, ctx->sys_cfg->q);
+	sm9_dim_mulm_mpi(out->z_fq2, p->z_fq2, ctx->sys_cfg->pi_q2_c,
+			 ctx->sys_cfg->q);
+	return 0;
+}
+
+static int sm9_final_exponent(SM9_DIM_FQ12 out, SM9_DIM_FQ12 F,
+			      struct sm9_ctx *ctx)
+{
+	const char *a2_c = "0xd8000000019062ed0000b98b0cb27659";
+	const char *a3_c = "0x2400000000215d941";
+	SM9_DIM_FQ12 t0, t1, t2, t3, t4, t5;
+	MPI a2 = NULL, a3 = NULL;
+	int rc = -ENOMEM;
+
+	a2 = mpi_scanval(a2_c);
+	a3 = mpi_scanval(a3_c);
+	if (!a2 || !a3)
+		goto out_free_mpi;
+
+	rc = sm9_dim_fq12_init(t0, 0);
+	rc |= sm9_dim_fq12_init(t1, 0);
+	rc |= sm9_dim_fq12_init(t2, 0);
+	rc |= sm9_dim_fq12_init(t3, 0);
+	rc |= sm9_dim_fq12_init(t4, 0);
+	rc |= sm9_dim_fq12_init(t5, 0);
+	if (rc)
+		goto out_free;
+
+	sm9_dim_fq12_frobenius_6(t0, F, ctx);
+	sm9_dim_fq12_invm(t1, F, ctx);
+	sm9_dim_fq12_mulm(t0, t0, t1, ctx);
+	sm9_dim_fq12_frobenius_2(t1, t0, ctx);
+	sm9_dim_fq12_mulm(t0, t0, t1, ctx);
+
+	sm9_dim_fq12_powm(t2, t0, a3, ctx);
+	sm9_dim_fq12_invm(t2, t2, ctx);
+	sm9_dim_fq12_frobenius(t3, t2, ctx);
+	sm9_dim_fq12_mulm(t3, t2, t3, ctx);
+
+	sm9_dim_fq12_mulm(t2, t2, t3, ctx);
+	sm9_dim_fq12_frobenius(t4, t0, ctx);
+	sm9_dim_fq12_mulm(t5, t4, t0, ctx);
+	sm9_dim_fq12_powm_ui(t5, t5, 9, ctx);
+
+	sm9_dim_fq12_mulm(t2, t2, t5, ctx);
+	sm9_dim_fq12_mulm(t5, t0, t0, ctx);
+	sm9_dim_fq12_mulm(t5, t5, t5, ctx);
+	sm9_dim_fq12_mulm(t2, t2, t5, ctx);
+	sm9_dim_fq12_mulm(t4, t4, t4, ctx);
+	sm9_dim_fq12_mulm(t4, t4, t3, ctx);
+	sm9_dim_fq12_frobenius_2(t3, t0, ctx);
+	sm9_dim_fq12_mulm(t3, t3, t4, ctx);
+
+	sm9_dim_fq12_powm(t4, t3, a2, ctx);
+	sm9_dim_fq12_mulm(t2, t4, t2, ctx);
+	sm9_dim_fq12_frobenius_3(t3, t0, ctx);
+	sm9_dim_fq12_mulm(out, t3, t2, ctx);
+
+	rc = 0;
+
+out_free:
+	sm9_dim_fq12_deinit(t0);
+	sm9_dim_fq12_deinit(t1);
+	sm9_dim_fq12_deinit(t2);
+	sm9_dim_fq12_deinit(t3);
+	sm9_dim_fq12_deinit(t4);
+	sm9_dim_fq12_deinit(t5);
+
+out_free_mpi:
+	mpi_free(a2);
+	mpi_free(a3);
+	return rc;
+}
+
+int Rate_pairing(SM9_DIM_FQ12 out, SM9_POINT Q, MPI_POINT P, MPI a,
+		 struct sm9_ctx *ctx)
+{
+	SM9_POINT T = NULL;
+	SM9_POINT Q1 = NULL, Q2 = NULL;
+	SM9_DIM_FQ12 f_num, f_den, g_num, g_den;
+	int i;
+	int rc = -ENOMEM;
+
+	Q1 = sm9_point_new(0);
+	Q2 = sm9_point_new(0);
+	T = sm9_point_new(0);
+	if (!Q1 || !Q2 || !T || !P)
+		goto out_free;
+
+	if (sm9_dim_fq12_init(f_num, 0) || sm9_dim_fq12_init(f_den, 0) ||
+	    sm9_dim_fq12_init(g_num, 0) || sm9_dim_fq12_init(g_den, 0))
+		goto out_free;
+
+	/* f = 1 */
+	mpi_set_ui(f_num[0][0][0], 1);
+	mpi_set_ui(f_den[0][0][0], 1);
+
+	sm9_point_copy(T, Q);
+
+	for (i = mpi_get_nbits(a) - 2; i >= 0; i--) {
+		sm9_dim_fq12_mulm(f_num, f_num, f_num, ctx);
+		sm9_dim_fq12_mulm(f_den, f_den, f_den, ctx);
+		g_V_V_Q(g_num, g_den, T, P, ctx);
+		sm9_dim_fq12_mulm(f_num, f_num, g_num, ctx);
+		sm9_dim_fq12_mulm(f_den, f_den, g_den, ctx);
+
+		sm9_point_addm(T, T, T, ctx);
+
+		if (mpi_test_bit(a, i)) {
+			g_U_V_Q(g_num, g_den, T, Q, P, ctx);
+			sm9_dim_fq12_mulm(f_num, f_num, g_num, ctx);
+			sm9_dim_fq12_mulm(f_den, f_den, g_den, ctx);
+			sm9_point_addm(T, T, Q, ctx);
+		}
+	}
+
+	sm9_point_pi_q(Q1, Q, ctx);
+	sm9_point_neg_pi_q2(Q2, Q, ctx);
+
+	g_U_V_Q(g_num, g_den, T, Q1, P, ctx);
+	sm9_dim_fq12_mulm(f_num, f_num, g_num, ctx);
+	sm9_dim_fq12_mulm(f_den, f_den, g_den, ctx);
+	sm9_point_addm(T, T, Q1, ctx);
+
+	g_U_V_Q(g_num, g_den, T, Q2, P, ctx);
+	sm9_dim_fq12_mulm(f_num, f_num, g_num, ctx);
+	sm9_dim_fq12_mulm(f_den, f_den, g_den, ctx);
+	sm9_point_addm(T, T, Q2, ctx);
+
+	sm9_dim_fq12_invm(f_den, f_den, ctx);
+	sm9_dim_fq12_mulm(out, f_num, f_den, ctx);
+
+	sm9_final_exponent(out, out, ctx);
+
+	rc = 0;
+out_free:
+	sm9_dim_fq12_deinit(f_num);
+	sm9_dim_fq12_deinit(f_den);
+	sm9_dim_fq12_deinit(g_num);
+	sm9_dim_fq12_deinit(g_den);
+	sm9_point_release(T);
+	sm9_point_release(Q1);
+	sm9_point_release(Q2);
+	return rc;
+}
+
+MPI_POINT bytes_to_point(u8 *src, size_t size)
+{
+	MPI_POINT res;
+	MPI tmp;
+	size_t l = size / 2;
+
+	if (size % 2)
+		return NULL;
+
+	res = mpi_point_new(0);
+	if (!res)
+		return NULL;
+	mpi_set_ui(res->z, 1);
+
+	tmp = mpi_read_raw_data(src, l);
+	if (!tmp) {
+		mpi_point_release(res);
+		return NULL;
+	}
+	mpi_set(res->x, tmp);
+	mpi_free(tmp);
+
+	tmp = mpi_read_raw_data(src + l, l);
+	if (!tmp) {
+		mpi_point_release(res);
+		return NULL;
+	}
+	mpi_set(res->y, tmp);
+	mpi_free(tmp);
+	return res;
+}
+
+int point_to_bytes(MPI_POINT P, u8 **out, size_t *out_size)
+{
+	size_t size;
+	unsigned int write_size;
+
+	if (!P)
+		return -EINVAL;
+
+	size = mpi_get_size(P->x);
+	*out = kzalloc(size * 2, GFP_KERNEL);
+	if (!*out)
+		return -ENOMEM;
+
+	mpi_read_buffer(P->x, *out, size, &write_size, NULL);
+	if (write_size != size) {
+		kfree(*out);
+		*out = NULL;
+		return -EINVAL;
+	}
+
+	mpi_read_buffer(P->y, *out + size, size, &write_size, NULL);
+	if (write_size != size) {
+		kfree(*out);
+		*out = NULL;
+		return -EINVAL;
+	}
+
+	*out_size = size * 2;
+	return 0;
+}
+
+int mpi_point_to_sm9_point(SM9_POINT out, MPI_POINT p)
+{
+	if (!out)
+		return -EINVAL;
+
+	mpi_set(out->xd1, p->x);
+	mpi_set_ui(out->xd2, 0);
+	mpi_set(out->yd1, p->y);
+	mpi_set_ui(out->yd2, 0);
+	mpi_set(out->zd1, p->z);
+	mpi_set_ui(out->zd2, 0);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpi_point_to_sm9_point);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("GUO Zihua <guozihua@huawei.com>");
+MODULE_DESCRIPTION("SM9 generic algorithm library");
diff --git a/crypto/sm9_lib.h b/crypto/sm9_lib.h
new file mode 100644
index 000000000000..27c741ca11cd
--- /dev/null
+++ b/crypto/sm9_lib.h
@@ -0,0 +1,92 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * Header of libraries for SM9 key exchange algorithm
+ *
+ * Copyright (c) 2023, Huawei Technology Co., Ltd.
+ * Authors: GUO Zihua <guozihua@huawei.com>
+ */
+
+#include <linux/mpi.h>
+#include <crypto/sm9.h>
+
+#ifndef _LOCAL_SM9_LIB_H
+#define _LOCAL_SM9_LIB_H
+
+struct sm9_point_fq2 {
+	union {
+		SM9_DIM_FQ2 x_fq2;
+		struct {
+			MPI xd1;
+			MPI xd2;
+		};
+	};
+	union {
+		SM9_DIM_FQ2 y_fq2;
+		struct {
+			MPI yd1;
+			MPI yd2;
+		};
+	};
+	union {
+		SM9_DIM_FQ2 z_fq2;
+		struct {
+			MPI zd1;
+			MPI zd2;
+		};
+	};
+};
+
+struct sm9_sys_cfg {
+	u8 cid;
+	MPI q;
+	MPI q_minus_2;
+	MPI q2;
+	MPI q2_minus_2;
+	MPI a, b;
+	MPI N;
+	MPI N_minus_1;
+	unsigned int N_log_2_times_5_roundup;
+	size_t N_size;
+	unsigned int cf;
+	unsigned int k;
+	MPI_POINT P1;
+	SM9_POINT P2;
+	u8 hid;
+	MPI t;
+	MPI tr;
+	MPI pairing_a;
+	MPI pi_q_c;
+	MPI pi_q2_c;
+	MPI beta;
+	MPI alpha1;
+	MPI alpha2;
+	MPI alpha3;
+	MPI alpha4;
+	MPI alpha5;
+
+	struct mpi_ec_ctx *G1;
+};
+
+struct sm9_ctx {
+	struct sm9_sys_cfg *sys_cfg;
+	MPI_POINT R;
+	MPI_POINT Ppub_s;
+	MPI r;
+	SM9_POINT de;
+	unsigned int hid;
+	char *id;
+	size_t id_size;
+	bool initiator;
+};
+
+int Rate_pairing(SM9_DIM_FQ12 out, SM9_POINT Q, MPI_POINT P, MPI t,
+		 struct sm9_ctx *ctx);
+MPI_POINT bytes_to_point(u8 *src, size_t size);
+int point_to_bytes(MPI_POINT P, u8 **out, size_t *out_size);
+
+int sm9_point_mpi_addm(SM9_POINT out, SM9_POINT P, MPI a, MPI q);
+int sm9_point_mpi_mulm(SM9_POINT out, SM9_POINT P, MPI a, struct sm9_ctx *ctx);
+int sm9_point_addm(SM9_POINT out, SM9_POINT P, SM9_POINT Q,
+		   struct sm9_ctx *ctx);
+int mpi_point_to_sm9_point(SM9_POINT out, MPI_POINT p);
+#endif
-- 
2.17.1

