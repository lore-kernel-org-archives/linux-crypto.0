Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88181C4BA0B
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 591E224656
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 05:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582693261;
	bh=+Sp7ZvDmeV/GPvCqwJ66Fb86M6xqAEOefxwFSCjV/S8=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vMBOACODZrh/Ih45ZirErPLnzaRfFNnYAMvGGEAg6puHnyUd/KMUrGoaW9Xav0ka0
	 mZ30z5vawMww8iSvDeQQgdtoDNeyz6RxjTB60V7Wk1xZRGbSOFwkZn4+1MTUb1Oy2N
	 7nWDfMI1of+7ZtKT5u/AQ5Y3zLs/ppVmfeX4oEyk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgBZFBA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Feb 2020 00:01:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgBZFBA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Feb 2020 00:01:00 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E39F72067C
        for <linux-crypto@vger.kernel.org>; Wed, 26 Feb 2020 05:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582693260;
        bh=+Sp7ZvDmeV/GPvCqwJ66Fb86M6xqAEOefxwFSCjV/S8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=0vqecRmHpZtPomgN3POK9y5Tw9OtdLLCHCjeF9PnrLHJMeN0SZATmKiPkQwEd+z22
         3A2qY/f/OL5pzv733Hli7hBuH28n+XX5anP7t2xETYh7rtqMJiIBt/Ik9EsPcH7EFe
         TGVhrqnzMmCW7npOR3KqCm8EgikYmA9b3Wb0tYzk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 01/12] crypto: authencesn - fix weird comma-terminated line
Date:   Tue, 25 Feb 2020 20:59:13 -0800
Message-Id: <20200226045924.97053-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226045924.97053-1-ebiggers@kernel.org>
References: <20200226045924.97053-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Fix a weird case where a line was terminated by a comma rather than a
semicolon, causing the statement to be continued on the next line.
Fortunately the code still behaved as intended, though.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/authencesn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 589008146fce7..149b70df2a917 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -458,7 +458,7 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 	inst->alg.encrypt = crypto_authenc_esn_encrypt;
 	inst->alg.decrypt = crypto_authenc_esn_decrypt;
 
-	inst->free = crypto_authenc_esn_free,
+	inst->free = crypto_authenc_esn_free;
 
 	err = aead_register_instance(tmpl, inst);
 	if (err) {

base-commit: ff462ddfd95b915345c3c7c037c3bfafdc58bae7
-- 
2.25.1

