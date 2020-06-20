Return-Path: <SRS0=xOPh=AB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0FFC433DF
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Jun 2020 23:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EAC12474A
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Jun 2020 23:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgFTXJl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Jun 2020 19:09:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:36666 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728969AbgFTXJl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Jun 2020 19:09:41 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C7A1244EF19071396E52;
        Sun, 21 Jun 2020 07:09:38 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.202.231) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sun, 21 Jun 2020 07:09:28 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Barry Song <song.bao.hua@hisilicon.com>
Subject: [PATCH] crypto: scompress - call the completion callback for the completed acomp_req
Date:   Sun, 21 Jun 2020 11:07:56 +1200
Message-ID: <20200620230756.6592-1-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.202.231]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

While using acomp_req, users may customize a completion callback, if the
backend of acomp is actually scomp, this callback will never be called.
This looks a bit messy to users. For one user, all scomp details should
be hidden by acomp APIs.

But it won't cause any real problem if users simply use crypto_req_done()
as the callback, and further use crypto_wait_req() to wait for request to
be done since crypto_wait_req() depends on the callback only if queuing
acomp_req returns -EINPROGRESS or -EBUSY.

This patch will make sure the customized completion callback is called
for the first case. And it won't break the second case in which users
use the common crypto_req_done() and crypto_wait_req() only.

Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 crypto/scompress.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 738f4f8f0f41..634b7ced9348 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -158,6 +158,10 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	}
 out:
 	spin_unlock(&scratch->lock);
+
+	if (req->base.complete)
+		acomp_request_complete(req, ret);
+
 	return ret;
 }
 
-- 
2.27.0


