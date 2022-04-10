Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969BCC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 14:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344642AbiDROp4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 10:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344875AbiDROpl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 10:45:41 -0400
Received: from m12-14.163.com (m12-14.163.com [220.181.12.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1FBDE5BD0B
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 06:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=tAYD7
        +MmKQcCEfy0fxTo+ymoJOEsbkaCZ7xgIHOqeC4=; b=cinKJgsR5KCIzmKuhNH8E
        u5ez06KPs+XAyhFTYqEvXJBRASfv7CvA+gAfcDe9bkSmtIadSqAGK5LEMEi+9IMc
        MPEeX65bqXassuQ5BPaWQ/6PLtDxssVVU4aPncIC/PBNDlx9w8Wzaekq49EypjG+
        pwo1gHiVMenMd9I9iflpVQ=
Received: from localhost.localdomain.localdomain (unknown [115.197.34.188])
        by smtp10 (Coremail) with SMTP id DsCowABnAl+2Z11iuC5kBw--.27054S2;
        Mon, 18 Apr 2022 21:29:27 +0800 (CST)
From:   chinayanlei2002@163.com
To:     herbert@gondor.apana.org.au, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
Cc:     linux-crypto@vger.kernel.org, Yan Lei <yan_lei@dahuatech.com>
Subject: [PATCH] x86: crypto: fix Using uninitialized value walk.flags
Date:   Sun, 10 Apr 2022 14:07:57 +0800
Message-Id: <20220410060757.4009-1-chinayanlei2002@163.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowABnAl+2Z11iuC5kBw--.27054S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cr48tr1DKw1fGw17ZFWxtFb_yoW8KrWUpF
        1ak397tw48JwnF9348JFZ5Xr93tF45Za1Ikw48Jw1xGr1S9FW8GrsrAw18ZrW5AFW5WFyU
        GrWv9w18Ww1kGaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UCNtsUUUUU=
X-Originating-IP: [115.197.34.188]
X-CM-SenderInfo: xfkl0tx1dqzvblsqiji6rwjhhfrp/1tbiOxfmLGC5i5p2TwAAsX
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Yan Lei <yan_lei@dahuatech.com>

----------------------------------------------------------
Using uninitialized value "walk.flags" when calling "skcipher_walk_virt".

Signed-off-by: Yan Lei <yan_lei@dahuatech.com>
---
 arch/x86/crypto/sm4_aesni_avx_glue.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/sm4_aesni_avx_glue.c b/arch/x86/crypto/sm4_aesni_avx_glue.c
index 7800f77d6..417e3bbfe 100644
--- a/arch/x86/crypto/sm4_aesni_avx_glue.c
+++ b/arch/x86/crypto/sm4_aesni_avx_glue.c
@@ -40,7 +40,7 @@ static int sm4_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 
 static int ecb_do_crypt(struct skcipher_request *req, const u32 *rkey)
 {
-	struct skcipher_walk walk;
+	struct skcipher_walk walk = { 0 };
 	unsigned int nbytes;
 	int err;
 
@@ -94,7 +94,7 @@ int sm4_cbc_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct sm4_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
+	struct skcipher_walk walk = { 0 };
 	unsigned int nbytes;
 	int err;
 
@@ -128,7 +128,7 @@ int sm4_avx_cbc_decrypt(struct skcipher_request *req,
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct sm4_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
+	struct skcipher_walk walk = { 0 };
 	unsigned int nbytes;
 	int err;
 
@@ -192,7 +192,7 @@ int sm4_cfb_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct sm4_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
+	struct skcipher_walk walk = { 0 };
 	unsigned int nbytes;
 	int err;
 
@@ -234,7 +234,7 @@ int sm4_avx_cfb_decrypt(struct skcipher_request *req,
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct sm4_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
+	struct skcipher_walk walk = { 0 };
 	unsigned int nbytes;
 	int err;
 
@@ -303,7 +303,7 @@ int sm4_avx_ctr_crypt(struct skcipher_request *req,
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct sm4_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
+	struct skcipher_walk walk = { 0 };
 	unsigned int nbytes;
 	int err;
 
-- 
2.30.0

