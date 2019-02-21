Return-Path: <SRS0=2gc/=Q4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE8FDC43381
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 18:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C84702083B
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 18:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfBUSY4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Feb 2019 13:24:56 -0500
Received: from gateway34.websitewelcome.com ([192.185.150.114]:21002 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbfBUSYz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Feb 2019 13:24:55 -0500
X-Greylist: delayed 1230 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2019 13:24:55 EST
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 91BD3B46A3
        for <linux-crypto@vger.kernel.org>; Thu, 21 Feb 2019 12:04:24 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id wshsgIGbriQerwshsgVxub; Thu, 21 Feb 2019 12:04:24 -0600
X-Authority-Reason: nr=8
Received: from [189.250.119.20] (port=39454 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gwshr-001xnC-K4; Thu, 21 Feb 2019 12:04:23 -0600
Date:   Thu, 21 Feb 2019 12:04:23 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] crypto: af_alg - use struct_size() in sock_kfree_s()
Message-ID: <20190221180423.GA5689@embeddedor>
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
X-Source-IP: 189.250.119.20
X-Source-L: No
X-Exim-ID: 1gwshr-001xnC-K4
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.119.20]:39454
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes, in particular in the
context in which this code is being used.

So, change the following form:

sizeof(*sgl) + sizeof(sgl->sg[0]) * (MAX_SGL_ENTS + 1)

to :

struct_size(sgl, sg, MAX_SGL_ENTS + 1)

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 crypto/af_alg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 65f4326d08f0..edca0998b2a4 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -637,8 +637,7 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 		}
 
 		list_del(&sgl->list);
-		sock_kfree_s(sk, sgl, sizeof(*sgl) + sizeof(sgl->sg[0]) *
-						     (MAX_SGL_ENTS + 1));
+		sock_kfree_s(sk, sgl, struct_size(sgl, sg, MAX_SGL_ENTS + 1));
 	}
 
 	if (!ctx->used)
-- 
2.20.1

