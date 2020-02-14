Return-Path: <SRS0=Wzqe=4C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D9BC2BA83
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Feb 2020 16:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 575262168B
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Feb 2020 16:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581696130;
	bh=Wf6+5th2F9srA5n2O4rn5EYSr5Vxtth49+lAj9Yemro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=BdWSdV16sZPPH9XfObvWZQHxvcO94GOth7Ov9Hhht6/PZwV10iu/fi0ZuvBHteIEf
	 /E1S3bgh6veEnCMyxDWnLdirevFUGlWrT84EbSwGdk5IAzV3tm/Dn3dAaN2xQFl/bw
	 Wz9yfyOw/v/sopX7O0YS65FP/l2ymCG6XWfzWDdo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389259AbgBNQCJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:02:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389208AbgBNQCI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Feb 2020 11:02:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A10A5206CC;
        Fri, 14 Feb 2020 16:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696127;
        bh=Wf6+5th2F9srA5n2O4rn5EYSr5Vxtth49+lAj9Yemro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpapbOD4/DWCTIUmGh9LLD2pM5PAPRFmTMsx8P818NSH7nTwM2sIes9rZJTsrFdLl
         zegoXHiHgaNlV6IXy7/9rNCJN7gSrqBt3hLMMJNUQnBlXV9RReOHjQFXNS4g/Qx5Eo
         IpgSrL8+zLGwoI3SCw8HDXoTi3juyDnhEqu1Y2BE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 013/459] crypto: testmgr - don't try to decrypt uninitialized buffers
Date:   Fri, 14 Feb 2020 10:54:23 -0500
Message-Id: <20200214160149.11681-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit eb455dbd02cb1074b37872ffca30a81cb2a18eaa ]

Currently if the comparison fuzz tests encounter an encryption error
when generating an skcipher or AEAD test vector, they will still test
the decryption side (passing it the uninitialized ciphertext buffer)
and expect it to fail with the same error.

This is sort of broken because it's not well-defined usage of the API to
pass an uninitialized buffer, and furthermore in the AEAD case it's
acceptable for the decryption error to be EBADMSG (meaning "inauthentic
input") even if the encryption error was something else like EINVAL.

Fix this for skcipher by explicitly initializing the ciphertext buffer
on error, and for AEAD by skipping the decryption test on error.

Reported-by: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Fixes: d435e10e67be ("crypto: testmgr - fuzz skciphers against their generic implementation")
Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against their generic implementation")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/testmgr.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index c39e39e55dc20..7473c5bc06b1a 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2102,6 +2102,7 @@ static void generate_random_aead_testvec(struct aead_request *req,
 	 * If the key or authentication tag size couldn't be set, no need to
 	 * continue to encrypt.
 	 */
+	vec->crypt_error = 0;
 	if (vec->setkey_error || vec->setauthsize_error)
 		goto done;
 
@@ -2245,10 +2246,12 @@ static int test_aead_vs_generic_impl(const char *driver,
 					req, tsgls);
 		if (err)
 			goto out;
-		err = test_aead_vec_cfg(driver, DECRYPT, &vec, vec_name, cfg,
-					req, tsgls);
-		if (err)
-			goto out;
+		if (vec.crypt_error == 0) {
+			err = test_aead_vec_cfg(driver, DECRYPT, &vec, vec_name,
+						cfg, req, tsgls);
+			if (err)
+				goto out;
+		}
 		cond_resched();
 	}
 	err = 0;
@@ -2678,6 +2681,15 @@ static void generate_random_cipher_testvec(struct skcipher_request *req,
 	skcipher_request_set_callback(req, 0, crypto_req_done, &wait);
 	skcipher_request_set_crypt(req, &src, &dst, vec->len, iv);
 	vec->crypt_error = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+	if (vec->crypt_error != 0) {
+		/*
+		 * The only acceptable error here is for an invalid length, so
+		 * skcipher decryption should fail with the same error too.
+		 * We'll test for this.  But to keep the API usage well-defined,
+		 * explicitly initialize the ciphertext buffer too.
+		 */
+		memset((u8 *)vec->ctext, 0, vec->len);
+	}
 done:
 	snprintf(name, max_namelen, "\"random: len=%u klen=%u\"",
 		 vec->len, vec->klen);
-- 
2.20.1

