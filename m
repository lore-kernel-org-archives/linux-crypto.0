Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79BDDC2BA83
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 17:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51E0B206ED
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 17:43:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="MugzU50q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgBMRnh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 12:43:37 -0500
Received: from gateway22.websitewelcome.com ([192.185.47.65]:19190 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726282AbgBMRnh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 12:43:37 -0500
X-Greylist: delayed 1477 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Feb 2020 12:43:36 EST
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 1DA175C4F
        for <linux-crypto@vger.kernel.org>; Thu, 13 Feb 2020 11:18:59 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 2I8gjOGg2vBMd2I8gjMkTU; Thu, 13 Feb 2020 11:18:59 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=a+bd2IXpJ5Ra94RkqkEqLoja0urUQM03kkJdxZlm35M=; b=MugzU50q1YrajeIJNwpHGNKkNO
        norc0Oeuoia4hBploFYnqjCnLgx0uOKvOo8YvLYjdqp/kOyJb5R+YV9FbfraK1d4s71qa35EuXCd8
        3PInB3TByUO0ZDMGmP7NTChWl9II38WVPXuo6tqDEOyxG/j9XDvwbGM2T62ZI7iMlkVc380qH3NAH
        4k/6IPouF7FHf7R7yGgeGCDH0SU83VhglBPCLr7ViiCxT/2mkMfse6GaCBWEy2ocWeo2bBhKcXBEc
        JEXzx9jCh3SAOLHCjyHcJ2xQHX+A3zSvrSV/DYaAFdxR6meAETmZKQ22dEIOdjxJp6V2BtO85seCd
        nZQfuv7w==;
Received: from [200.68.140.15] (port=11781 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j2I8d-004GVi-MW; Thu, 13 Feb 2020 11:18:57 -0600
Date:   Thu, 13 Feb 2020 11:21:30 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] crypto: s5p-sss - Replace zero-length array with
 flexible-array member
Message-ID: <20200213172130.GA13395@embeddedor>
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
X-Exim-ID: 1j2I8d-004GVi-MW
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.15]:11781
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
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
 drivers/crypto/s5p-sss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index d66e20a2f54c..2a16800d2579 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -369,7 +369,7 @@ struct s5p_hash_reqctx {
 	bool			error;
 
 	u32			bufcnt;
-	u8			buffer[0];
+	u8			buffer[];
 };
 
 /**
-- 
2.25.0

