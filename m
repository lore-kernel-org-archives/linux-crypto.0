Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C9EC2BA83
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 17:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C88B8206DB
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 17:08:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="TGWs1xno"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgBMRIf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 12:08:35 -0500
Received: from gateway24.websitewelcome.com ([192.185.51.202]:45316 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727690AbgBMRIf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 12:08:35 -0500
X-Greylist: delayed 1214 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Feb 2020 12:08:33 EST
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 1265281298
        for <linux-crypto@vger.kernel.org>; Thu, 13 Feb 2020 10:48:19 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 2Hf0jSYrxAGTX2Hf1jeZWZ; Thu, 13 Feb 2020 10:48:19 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Bs8CD4elab7gEoHuomTzKuiJhB+d5B0XV8i9tY3kOnI=; b=TGWs1xnovy+EkuZTu7TgLh61rH
        3X0KXbhMSv2Skcn4fGWRroyZvNy8nKiC7KMz3XSPHAu01+Y4eLgqam6R13VoLe3Ik9LcI6MOHVzWi
        /vDInhraxjL9DNLBIjgX74wV3X+tqzhJ3qCmjlCUgtcnU/9ui85zsdCF8yk4bonvNBwXZGfvdruc/
        b/FWTw+d31qoOCrYQkwMkxCGXJk+ZaFgUrbPfuo1DFd16I0lNhzeSMVjvJTnJDoT0r/6xpvI0yIEd
        yntLgDn0C420260oVgPob7V03H2AktZl4yTkA2Ctmze9huxGZiwuT4A3pHT5fJllAHFdtumnS5h1O
        kzHwt+eQ==;
Received: from [200.68.140.15] (port=22021 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j2Hez-003zOt-J2; Thu, 13 Feb 2020 10:48:17 -0600
Date:   Thu, 13 Feb 2020 10:50:54 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] crypto: img-hash - Replace zero-length array with
 flexible-array member
Message-ID: <20200213165054.GA11109@embeddedor>
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
X-Source-IP: 200.68.140.15
X-Source-L: No
X-Exim-ID: 1j2Hez-003zOt-J2
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.15]:22021
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 15
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
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

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/crypto/img-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 25d5227f74a1..0e25fc3087f3 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -103,7 +103,7 @@ struct img_hash_request_ctx {
 	struct ahash_request	fallback_req;
 
 	/* Zero length buffer must remain last member of struct */
-	u8 buffer[0] __aligned(sizeof(u32));
+	u8 buffer[] __aligned(sizeof(u32));
 };
 
 struct img_hash_ctx {
-- 
2.25.0

