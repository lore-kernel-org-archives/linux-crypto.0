Return-Path: <SRS0=2CiZ=QS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CEB6C169C4
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 18:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33EBF21B69
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 18:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbfBKSzd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Feb 2019 13:55:33 -0500
Received: from gateway24.websitewelcome.com ([192.185.50.252]:49165 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726228AbfBKSzd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Feb 2019 13:55:33 -0500
X-Greylist: delayed 1437 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2019 13:55:32 EST
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 7B31E3AA409
        for <linux-crypto@vger.kernel.org>; Mon, 11 Feb 2019 12:31:34 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id tGMggeVS94FKptGMggzPez; Mon, 11 Feb 2019 12:31:34 -0600
X-Authority-Reason: nr=8
Received: from [189.250.49.191] (port=42244 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gtGMf-0027zH-MN; Mon, 11 Feb 2019 12:31:33 -0600
Date:   Mon, 11 Feb 2019 12:31:31 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] crypto: ccree - fix missing break in switch statement
Message-ID: <20190211183131.GA19193@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.49.191
X-Source-L: No
X-Exim-ID: 1gtGMf-0027zH-MN
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.49.191]:42244
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 27
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add missing break statement in order to prevent the code from falling
through to case S_DIN_to_DES.

This bug was found thanks to the ongoing efforts to enable
-Wimplicit-fallthrough.

Fixes: 63ee04c8b491 ("crypto: ccree - add skcipher support")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/crypto/ccree/cc_cipher.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 5e3361a363b5..d9c17078517b 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -80,6 +80,7 @@ static int validate_keys_sizes(struct cc_cipher_ctx *ctx_p, u32 size)
 		default:
 			break;
 		}
+		break;
 	case S_DIN_to_DES:
 		if (size == DES3_EDE_KEY_SIZE || size == DES_KEY_SIZE)
 			return 0;
-- 
2.20.1

