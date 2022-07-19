Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3841C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Jul 2022 07:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbiGSHyh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Jul 2022 03:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbiGSHyg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Jul 2022 03:54:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAF227B1D;
        Tue, 19 Jul 2022 00:54:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D6AC61709;
        Tue, 19 Jul 2022 07:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7467AC341C6;
        Tue, 19 Jul 2022 07:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658217274;
        bh=R+wXBIQRVLh28YERmpCcfYhCxcU9Hecpmr9sKbwPJKk=;
        h=From:To:Cc:Subject:Date:From;
        b=C9T23g7EQtTKTNxKNwJIZYmL78BWvTAMeXeuJtymIM4xXn1xWIDbiaKRrFPYtT/lL
         r6yz6PBrlqiy8SfEW0jam111KimxiNbUkCjSWC8LN7fnnU+X/zpry8tHvf0KjELdPE
         Toag0RCG++L3FNnSOp2y4+7bpn/ExdQjoyoiTalHZOZzkZoOAl6ifbycjkpZRMkC5R
         5I8Y/D/rj3+JPePNYPQiy3UcS43egufeQZ5igAwAi7eoaD7RCEk0WCfeMsrCHulUOm
         4mL2eMoNaX7+oJuDrzqraLqsOMVXAWxFiek4O7zdaL1c6eXOlKjvTqotOAfWCRVRJ3
         9JTsp2AjdQNDw==
Received: by pali.im (Postfix)
        id 949FFF3C; Tue, 19 Jul 2022 09:54:31 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: inside-secure: Add missing MODULE_DEVICE_TABLE for of
Date:   Tue, 19 Jul 2022 09:54:03 +0200
Message-Id: <20220719075403.15379-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Without MODULE_DEVICE_TABLE, crypto_safexcel.ko module is not automatically
loaded on platforms where inside-secure crypto HW is specified in device
tree (e.g. Armada 3720). So add missing MODULE_DEVICE_TABLE for of.

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 drivers/crypto/inside-secure/safexcel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 9b1a158aec29..ad0d8c4a71ac 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1831,6 +1831,8 @@ static const struct of_device_id safexcel_of_match_table[] = {
 	{},
 };
 
+MODULE_DEVICE_TABLE(of, safexcel_of_match_table);
+
 static struct platform_driver  crypto_safexcel = {
 	.probe		= safexcel_probe,
 	.remove		= safexcel_remove,
-- 
2.20.1

