From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 5/8] crypto: DH - allow params and key to be set independently
Date: Wed, 19 Apr 2017 01:06:23 +0200
Message-ID: <2575387.ZKC7OI4y0P@positron.chronox.de>
References: <2715753.J0rCo2lbig@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: keyrings@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58998 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758187AbdDRXKJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 19:10:09 -0400
In-Reply-To: <2715753.J0rCo2lbig@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Parameters are handled independently from the secret key. Therefore,
this patch allows setting of the parameter independently from the secret
key. Before invoking the actual crypto operation, the code must now
check that the secret key and the parameters are all present.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/dh.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index 87e3542..f7be48e 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -60,6 +60,10 @@ static int dh_check_params_length(unsigned int p_len)
 
 static int dh_set_params(struct dh_ctx *ctx, struct dh *params)
 {
+	/* If DH parameters are not given, do not check them. */
+	if (!params->p_size && !params->g_size)
+		return 0;
+
 	if (unlikely(!params->p || !params->g))
 		return -EINVAL;
 
@@ -111,7 +115,7 @@ static int dh_compute_value(struct kpp_request *req)
 	if (!val)
 		return -ENOMEM;
 
-	if (unlikely(!ctx->xa)) {
+	if (unlikely(!ctx->xa || !ctx->p || !ctx->g)) {
 		ret = -EINVAL;
 		goto err_free_val;
 	}
-- 
2.9.3
