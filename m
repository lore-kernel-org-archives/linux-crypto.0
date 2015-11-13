From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Subject: [PATCH 2/4] crypto: rsa: only require output buffers as big as needed.
Date: Fri, 13 Nov 2015 12:01:33 +0100
Message-ID: <1447412495-4370-2-git-send-email-andrew.zaborowski@intel.com>
References: <1447412495-4370-1-git-send-email-andrew.zaborowski@intel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36255 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbbKMLBw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Nov 2015 06:01:52 -0500
Received: by wmww144 with SMTP id w144so23801915wmw.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2015 03:01:51 -0800 (PST)
Received: from localhost.localdomain (9.Red-2-136-109.dynamicIP.rima-tde.net. [2.136.109.9])
        by smtp.gmail.com with ESMTPSA id w73sm3401681wme.12.2015.11.13.03.01.50
        for <linux-crypto@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 13 Nov 2015 03:01:51 -0800 (PST)
In-Reply-To: <1447412495-4370-1-git-send-email-andrew.zaborowski@intel.com>
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
