Return-Path: <SRS0=BxOx=6V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75ADC38A2A
	for <linux-crypto@archiver.kernel.org>; Thu,  7 May 2020 18:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9BEE21BE5
	for <linux-crypto@archiver.kernel.org>; Thu,  7 May 2020 18:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588877241;
	bh=kmGDD3oC3EB4KQRIO7ZBSOzgTGdqiOKS8/Gs5OxyZzQ=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=mlZ0Lx4qLyQTvKZdsW8+ZI31OPVH6zOwOsysffAwrKtk8NNPFNoYNHHa9159qFuHr
	 2FeXyMNoKBj99wy3uW5LC/n17DDVBs3dFIdLAKzZLPHWs/R0O5DSGDdOu3dSBasFZr
	 lBLONOknTx2Abkm3Z5PzezXGRIr0tsSCTHuYBr+0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgEGSrU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 May 2020 14:47:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbgEGSrT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 May 2020 14:47:19 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8A782184D;
        Thu,  7 May 2020 18:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588877239;
        bh=kmGDD3oC3EB4KQRIO7ZBSOzgTGdqiOKS8/Gs5OxyZzQ=;
        h=Date:From:To:Cc:Subject:From;
        b=aQxNvVL4LnuUDIlx7X8iJ3ft1lNV6QVFUbl5bZMcJufApldo3SFTFMFJplJfTqMaa
         aQhG09ZmEJVF2CZLRxbvL8/rWJJi394/CcJOQZaO4qhDgaUmkMlfQd5uFA1pti9SQX
         jSuf6bWpyzrCCe3uuZ9amCXb2unSpP7HAZCZO5xo=
Date:   Thu, 7 May 2020 13:51:45 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: Replace zero-length array with flexible-array
Message-ID: <20200507185145.GA14096@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

sizeof(flexible-array-member) triggers a warning because flexible array
members have incomplete type[1]. There are some instances of code in
which the sizeof operator is being incorrectly/erroneously applied to
zero-length arrays and the result is zero. Such instances may be hiding
some bugs. So, this work (flexible-array member conversions) will also
help to get completely rid of those sorts of issues.

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/crypto/chelsio/chcr_crypto.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
index 542bebae001f..1cc522a07aac 100644
--- a/drivers/crypto/chelsio/chcr_crypto.h
+++ b/drivers/crypto/chelsio/chcr_crypto.h
@@ -223,7 +223,7 @@ struct chcr_authenc_ctx {
 
 struct __aead_ctx {
 	struct chcr_gcm_ctx gcm[0];
-	struct chcr_authenc_ctx authenc[0];
+	struct chcr_authenc_ctx authenc[];
 };
 
 struct chcr_aead_ctx {
@@ -235,7 +235,7 @@ struct chcr_aead_ctx {
 	u8 nonce[4];
 	u16 hmac_ctrl;
 	u16 mayverify;
-	struct	__aead_ctx ctx[0];
+	struct	__aead_ctx ctx[];
 };
 
 struct hmac_ctx {
@@ -247,7 +247,7 @@ struct hmac_ctx {
 struct __crypto_ctx {
 	struct hmac_ctx hmacctx[0];
 	struct ablk_ctx ablkctx[0];
-	struct chcr_aead_ctx aeadctx[0];
+	struct chcr_aead_ctx aeadctx[];
 };
 
 struct chcr_context {
@@ -257,7 +257,7 @@ struct chcr_context {
 	unsigned int  ntxq;
 	unsigned int  nrxq;
 	struct completion cbc_aes_aio_done;
-	struct __crypto_ctx crypto_ctx[0];
+	struct __crypto_ctx crypto_ctx[];
 };
 
 struct chcr_hctx_per_wr {

