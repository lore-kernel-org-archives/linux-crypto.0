Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3767EC32751
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 13:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DC4A208C3
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 13:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388125AbfGaNIZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 09:08:25 -0400
Received: from inva021.nxp.com ([92.121.34.21]:42766 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729233AbfGaNIZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 09:08:25 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id DA6FC200A25;
        Wed, 31 Jul 2019 15:08:22 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CDE78200A23;
        Wed, 31 Jul 2019 15:08:22 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 7A4EA205F3;
        Wed, 31 Jul 2019 15:08:22 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH v5 05/14] crypto: caam - check authsize
Date:   Wed, 31 Jul 2019 16:08:06 +0300
Message-Id: <1564578495-9883-6-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1564578495-9883-1-git-send-email-iuliana.prodan@nxp.com>
References: <1564578495-9883-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Check authsize to solve the extra tests that expect -EINVAL to be
returned when the authentication tag size is not valid.

Validated authsize for GCM, RFC4106 and RFC4543.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Horia Geanta <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c     | 13 +++++++++++++
 drivers/crypto/caam/caamalg_qi.c  | 13 +++++++++++++
 drivers/crypto/caam/caamalg_qi2.c | 13 +++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index ce50ae1..5919069 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -376,6 +376,11 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 static int gcm_setauthsize(struct crypto_aead *authenc, unsigned int authsize)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
+	int err;
+
+	err = crypto_gcm_check_authsize(authsize);
+	if (err)
+		return err;
 
 	ctx->authsize = authsize;
 	gcm_set_sh_desc(authenc);
@@ -439,6 +444,11 @@ static int rfc4106_setauthsize(struct crypto_aead *authenc,
 			       unsigned int authsize)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
+	int err;
+
+	err = crypto_rfc4106_check_authsize(authsize);
+	if (err)
+		return err;
 
 	ctx->authsize = authsize;
 	rfc4106_set_sh_desc(authenc);
@@ -503,6 +513,9 @@ static int rfc4543_setauthsize(struct crypto_aead *authenc,
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
 
+	if (authsize != 16)
+		return -EINVAL;
+
 	ctx->authsize = authsize;
 	rfc4543_set_sh_desc(authenc);
 
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index b8854f2..6c69f54 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -371,6 +371,11 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 static int gcm_setauthsize(struct crypto_aead *authenc, unsigned int authsize)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
+	int err;
+
+	err = crypto_gcm_check_authsize(authsize);
+	if (err)
+		return err;
 
 	ctx->authsize = authsize;
 	gcm_set_sh_desc(authenc);
@@ -472,6 +477,11 @@ static int rfc4106_setauthsize(struct crypto_aead *authenc,
 			       unsigned int authsize)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
+	int err;
+
+	err = crypto_rfc4106_check_authsize(authsize);
+	if (err)
+		return err;
 
 	ctx->authsize = authsize;
 	rfc4106_set_sh_desc(authenc);
@@ -578,6 +588,9 @@ static int rfc4543_setauthsize(struct crypto_aead *authenc,
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
 
+	if (authsize != 16)
+		return -EINVAL;
+
 	ctx->authsize = authsize;
 	rfc4543_set_sh_desc(authenc);
 
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index fd38639..b5baa17 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -719,6 +719,11 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 static int gcm_setauthsize(struct crypto_aead *authenc, unsigned int authsize)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
+	int err;
+
+	err = crypto_gcm_check_authsize(authsize);
+	if (err)
+		return err;
 
 	ctx->authsize = authsize;
 	gcm_set_sh_desc(authenc);
@@ -811,6 +816,11 @@ static int rfc4106_setauthsize(struct crypto_aead *authenc,
 			       unsigned int authsize)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
+	int err;
+
+	err = crypto_rfc4106_check_authsize(authsize);
+	if (err)
+		return err;
 
 	ctx->authsize = authsize;
 	rfc4106_set_sh_desc(authenc);
@@ -910,6 +920,9 @@ static int rfc4543_setauthsize(struct crypto_aead *authenc,
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
 
+	if (authsize != 16)
+		return -EINVAL;
+
 	ctx->authsize = authsize;
 	rfc4543_set_sh_desc(authenc);
 
-- 
2.1.0

