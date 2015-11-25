From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Subject: [PATCH v4 2/4] crypto: rsa: only require output buffers as big as needed.
Date: Wed, 25 Nov 2015 11:12:15 +0100
Message-ID: <1448446337-17176-2-git-send-email-andrew.zaborowski@intel.com>
References: <1448446337-17176-1-git-send-email-andrew.zaborowski@intel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38568 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbbKYKMb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Nov 2015 05:12:31 -0500
Received: by wmec201 with SMTP id c201so63146685wme.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2015 02:12:30 -0800 (PST)
Received: from localhost.localdomain (9.Red-2-136-109.dynamicIP.rima-tde.net. [2.136.109.9])
        by smtp.gmail.com with ESMTPSA id z13sm22062283wjr.47.2015.11.25.02.12.29
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 25 Nov 2015 02:12:29 -0800 (PST)
In-Reply-To: <1448446337-17176-1-git-send-email-andrew.zaborowski@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

rhe RSA operations explicitly left-align the integers being written
skipping any leading zero bytes, but still require the output buffers to
include just enough space for the integer + the leading zero bytes.
Since the size of integer + the leading zero bytes (i.e. the key modulus
size) can now be obtained more easily through crypto_akcipher_maxsize
change the operations to only require as big a buffer as actually needed
if the caller has that information.  The semantics for request->dst_len
don't change.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
No changes since v1
---
 crypto/rsa.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 1093e04..58aad69 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -91,12 +91,6 @@ static int rsa_enc(struct akcipher_request *req)
 		goto err_free_c;
 	}
 
-	if (req->dst_len < mpi_get_size(pkey->n)) {
-		req->dst_len = mpi_get_size(pkey->n);
-		ret = -EOVERFLOW;
-		goto err_free_c;
-	}
-
 	ret = -ENOMEM;
 	m = mpi_read_raw_from_sgl(req->src, req->src_len);
 	if (!m)
@@ -136,12 +130,6 @@ static int rsa_dec(struct akcipher_request *req)
 		goto err_free_m;
 	}
 
-	if (req->dst_len < mpi_get_size(pkey->n)) {
-		req->dst_len = mpi_get_size(pkey->n);
-		ret = -EOVERFLOW;
-		goto err_free_m;
-	}
-
 	ret = -ENOMEM;
 	c = mpi_read_raw_from_sgl(req->src, req->src_len);
 	if (!c)
@@ -180,12 +168,6 @@ static int rsa_sign(struct akcipher_request *req)
 		goto err_free_s;
 	}
 
-	if (req->dst_len < mpi_get_size(pkey->n)) {
-		req->dst_len = mpi_get_size(pkey->n);
-		ret = -EOVERFLOW;
-		goto err_free_s;
-	}
-
 	ret = -ENOMEM;
 	m = mpi_read_raw_from_sgl(req->src, req->src_len);
 	if (!m)
@@ -225,12 +207,6 @@ static int rsa_verify(struct akcipher_request *req)
 		goto err_free_m;
 	}
 
-	if (req->dst_len < mpi_get_size(pkey->n)) {
-		req->dst_len = mpi_get_size(pkey->n);
-		ret = -EOVERFLOW;
-		goto err_free_m;
-	}
-
 	ret = -ENOMEM;
 	s = mpi_read_raw_from_sgl(req->src, req->src_len);
 	if (!s) {
-- 
2.1.4
