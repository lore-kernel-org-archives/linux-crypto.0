From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 2/2] crytpo: rsa - use mpi slg helpers to import and export
 data
Date: Wed, 23 Sep 2015 15:49:03 -0700
Message-ID: <20150923224903.23780.96938.stgit@tstruk-mobl1>
References: <20150923224853.23780.95440.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16945 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634AbbIWWu7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Sep 2015 18:50:59 -0400
In-Reply-To: <20150923224853.23780.95440.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use the new mpi_write_to_sgl and mpi_read_raw_from_sgl helpers
to import and export data.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/rsa.c |  127 +++++-----------------------------------------------------
 1 file changed, 12 insertions(+), 115 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index df81bbf..ce293d3 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -13,7 +13,6 @@
 #include <crypto/internal/rsa.h>
 #include <crypto/internal/akcipher.h>
 #include <crypto/akcipher.h>
-#include <crypto/scatterwalk.h>
 
 /*
  * RSAEP function [RFC3447 sec 5.1.1]
@@ -100,18 +99,7 @@ static int rsa_enc(struct akcipher_request *req)
 	}
 
 	ret = -ENOMEM;
-	if (sg_is_last(req->src)) {
-		m = mpi_read_raw_data(sg_virt(req->src), src_len);
-	} else {
-		void *ptr = kmalloc(src_len, GFP_KERNEL);
-
-		if (!ptr)
-			goto err_free_c;
-
-		scatterwalk_map_and_copy(ptr, req->src, 0, src_len, 0);
-		m = mpi_read_raw_data(ptr, src_len);
-		kfree(ptr);
-	}
+	m = mpi_read_raw_from_sgl(req->src);
 	if (!m)
 		goto err_free_c;
 
@@ -119,26 +107,12 @@ static int rsa_enc(struct akcipher_request *req)
 	if (ret)
 		goto err_free_m;
 
-	if (sg_is_last(req->dst)) {
-		ret = mpi_read_buffer(c, sg_virt(req->dst), dst_len,
-				      &req->out_len, &sign);
-	} else {
-		void *ptr = kmalloc(dst_len, GFP_KERNEL);
-
-		if (!ptr)
-			goto err_free_m;
-
-		ret = mpi_read_buffer(c, ptr, dst_len, &req->out_len, &sign);
-		scatterwalk_map_and_copy(ptr, req->dst, 0, dst_len, 1);
-		kfree(ptr);
-	}
+	ret = mpi_write_to_sgl(c, req->dst, &req->out_len, &sign);
 	if (ret)
 		goto err_free_m;
 
-	if (sign < 0) {
+	if (sign < 0)
 		ret = -EBADMSG;
-		goto err_free_m;
-	}
 
 err_free_m:
 	mpi_free(m);
@@ -171,18 +145,7 @@ static int rsa_dec(struct akcipher_request *req)
 	}
 
 	ret = -ENOMEM;
-	if (sg_is_last(req->src)) {
-		c = mpi_read_raw_data(sg_virt(req->src), src_len);
-	} else {
-		void *ptr = kmalloc(src_len, GFP_KERNEL);
-
-		if (!ptr)
-			goto err_free_m;
-
-		scatterwalk_map_and_copy(ptr, req->src, 0, src_len, 0);
-		c = mpi_read_raw_data(ptr, src_len);
-		kfree(ptr);
-	}
+	c = mpi_read_raw_from_sgl(req->src);
 	if (!c)
 		goto err_free_m;
 
@@ -190,27 +153,12 @@ static int rsa_dec(struct akcipher_request *req)
 	if (ret)
 		goto err_free_c;
 
-	if (sg_is_last(req->dst)) {
-		ret = mpi_read_buffer(m, sg_virt(req->dst), dst_len,
-				      &req->out_len, &sign);
-	} else {
-		void *ptr = kmalloc(dst_len, GFP_KERNEL);
-
-		if (!ptr)
-			goto err_free_c;
-
-		ret = mpi_read_buffer(m, ptr, dst_len, &req->out_len, &sign);
-		scatterwalk_map_and_copy(ptr, req->dst, 0, dst_len, 1);
-		kfree(ptr);
-	}
+	ret = mpi_write_to_sgl(m, req->dst, &req->out_len, &sign);
 	if (ret)
 		goto err_free_c;
 
-	if (sign < 0) {
+	if (sign < 0)
 		ret = -EBADMSG;
-		goto err_free_c;
-	}
-
 err_free_c:
 	mpi_free(c);
 err_free_m:
@@ -242,19 +190,7 @@ static int rsa_sign(struct akcipher_request *req)
 	}
 
 	ret = -ENOMEM;
-	if (sg_is_last(req->src)) {
-		m = mpi_read_raw_data(sg_virt(req->src), src_len);
-	} else {
-		void *ptr = kmalloc(src_len, GFP_KERNEL);
-
-		if (!ptr)
-			goto err_free_s;
-
-		scatterwalk_map_and_copy(ptr, req->src, 0, src_len, 0);
-		m = mpi_read_raw_data(ptr, src_len);
-		kfree(ptr);
-
-	}
+	m = mpi_read_raw_from_sgl(req->src);
 	if (!m)
 		goto err_free_s;
 
@@ -262,26 +198,12 @@ static int rsa_sign(struct akcipher_request *req)
 	if (ret)
 		goto err_free_m;
 
-	if (sg_is_last(req->dst)) {
-		ret = mpi_read_buffer(s, sg_virt(req->dst), dst_len,
-				      &req->out_len, &sign);
-	} else {
-		void *ptr = kmalloc(dst_len, GFP_KERNEL);
-
-		if (!ptr)
-			goto err_free_m;
-
-		ret = mpi_read_buffer(s, ptr, dst_len, &req->out_len, &sign);
-		scatterwalk_map_and_copy(ptr, req->dst, 0, dst_len, 1);
-		kfree(ptr);
-	}
+	ret = mpi_write_to_sgl(s, req->dst, &req->out_len, &sign);
 	if (ret)
 		goto err_free_m;
 
-	if (sign < 0) {
+	if (sign < 0)
 		ret = -EBADMSG;
-		goto err_free_m;
-	}
 
 err_free_m:
 	mpi_free(m);
@@ -314,18 +236,7 @@ static int rsa_verify(struct akcipher_request *req)
 	}
 
 	ret = -ENOMEM;
-	if (sg_is_last(req->src)) {
-		s = mpi_read_raw_data(sg_virt(req->src), src_len);
-	} else {
-		void *ptr = kmalloc(src_len, GFP_KERNEL);
-
-		if (!ptr)
-			goto err_free_m;
-
-		scatterwalk_map_and_copy(ptr, req->src, 0, src_len, 0);
-		s = mpi_read_raw_data(ptr, src_len);
-		kfree(ptr);
-	}
+	s = mpi_read_raw_from_sgl(req->src);
 	if (!s) {
 		ret = -ENOMEM;
 		goto err_free_m;
@@ -335,26 +246,12 @@ static int rsa_verify(struct akcipher_request *req)
 	if (ret)
 		goto err_free_s;
 
-	if (sg_is_last(req->dst)) {
-		ret = mpi_read_buffer(m, sg_virt(req->dst), dst_len,
-				      &req->out_len, &sign);
-	} else {
-		void *ptr = kmalloc(dst_len, GFP_KERNEL);
-
-		if (!ptr)
-			goto err_free_s;
-
-		ret = mpi_read_buffer(m, ptr, dst_len, &req->out_len, &sign);
-		scatterwalk_map_and_copy(ptr, req->dst, 0, dst_len, 1);
-		kfree(ptr);
-	}
+	ret = mpi_write_to_sgl(m, req->dst, &req->out_len, &sign);
 	if (ret)
 		goto err_free_s;
 
-	if (sign < 0) {
+	if (sign < 0)
 		ret = -EBADMSG;
-		goto err_free_s;
-	}
 
 err_free_s:
 	mpi_free(s);
