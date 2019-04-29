Return-Path: <SRS0=wtno=S7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65C5C43219
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Apr 2019 15:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A802820675
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Apr 2019 15:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfD2Po3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Apr 2019 11:44:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:4157 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728438AbfD2Po3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Apr 2019 11:44:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 08:44:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,410,1549958400"; 
   d="scan'208";a="319990389"
Received: from silvixa00391824.ir.intel.com (HELO silvixa00391824.ger.corp.intel.com) ([10.237.222.24])
  by orsmga005.jf.intel.com with ESMTP; 29 Apr 2019 08:44:27 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Conor Mcloughlin <conor.mcloughlin@intel.com>,
        Sergey Portnoy <sergey.portnoy@intel.com>
Subject: [PATCH 6/7] crypto: qat - return error for block ciphers for invalid requests
Date:   Mon, 29 Apr 2019 16:43:20 +0100
Message-Id: <20190429154321.21098-6-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190429154321.21098-1-giovanni.cabiddu@intel.com>
References: <20190429154321.21098-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Return -EINVAL if a request for a block cipher is not multiple of the
size of the block.

This problem was found with by the new extra run-time crypto self test.

Reviewed-by: Conor Mcloughlin <conor.mcloughlin@intel.com>
Tested-by: Sergey Portnoy <sergey.portnoy@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index f9a46918c9d1..868fefa9bb65 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -1096,6 +1096,14 @@ static int qat_alg_ablkcipher_encrypt(struct ablkcipher_request *req)
 	return -EINPROGRESS;
 }
 
+static int qat_alg_ablkcipher_blk_encrypt(struct ablkcipher_request *req)
+{
+	if (req->nbytes % AES_BLOCK_SIZE != 0)
+		return -EINVAL;
+
+	return qat_alg_ablkcipher_encrypt(req);
+}
+
 static int qat_alg_ablkcipher_decrypt(struct ablkcipher_request *req)
 {
 	struct crypto_ablkcipher *atfm = crypto_ablkcipher_reqtfm(req);
@@ -1145,6 +1153,13 @@ static int qat_alg_ablkcipher_decrypt(struct ablkcipher_request *req)
 	return -EINPROGRESS;
 }
 
+static int qat_alg_ablkcipher_blk_decrypt(struct ablkcipher_request *req)
+{
+	if (req->nbytes % AES_BLOCK_SIZE != 0)
+		return -EINVAL;
+
+	return qat_alg_ablkcipher_decrypt(req);
+}
 static int qat_alg_aead_init(struct crypto_aead *tfm,
 			     enum icp_qat_hw_auth_algo hash,
 			     const char *hash_name)
@@ -1304,8 +1319,8 @@ static struct crypto_alg qat_algs[] = { {
 	.cra_u = {
 		.ablkcipher = {
 			.setkey = qat_alg_ablkcipher_cbc_setkey,
-			.decrypt = qat_alg_ablkcipher_decrypt,
-			.encrypt = qat_alg_ablkcipher_encrypt,
+			.decrypt = qat_alg_ablkcipher_blk_decrypt,
+			.encrypt = qat_alg_ablkcipher_blk_encrypt,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
@@ -1348,8 +1363,8 @@ static struct crypto_alg qat_algs[] = { {
 	.cra_u = {
 		.ablkcipher = {
 			.setkey = qat_alg_ablkcipher_xts_setkey,
-			.decrypt = qat_alg_ablkcipher_decrypt,
-			.encrypt = qat_alg_ablkcipher_encrypt,
+			.decrypt = qat_alg_ablkcipher_blk_decrypt,
+			.encrypt = qat_alg_ablkcipher_blk_encrypt,
 			.min_keysize = 2 * AES_MIN_KEY_SIZE,
 			.max_keysize = 2 * AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
-- 
2.20.1

