Return-Path: <SRS0=7Iqi=AE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24566C433E3
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 04:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A86D2065D
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 04:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgFWESQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jun 2020 00:18:16 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6384 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgFWESO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jun 2020 00:18:14 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 27210302518C2C7DB378;
        Tue, 23 Jun 2020 12:18:12 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.200.72) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Tue, 23 Jun 2020 12:18:02 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <wangzhou1@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <akpm@linux-foundation.org>, <linux-crypto@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Barry Song <song.bao.hua@hisilicon.com>,
        Seth Jennings <sjenning@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Vitaly Wool <vitaly.wool@konsulko.com>
Subject: [PATCH v2 3/3] mm/zswap: allocate acomp on the numa node committing acomp_req
Date:   Tue, 23 Jun 2020 16:16:10 +1200
Message-ID: <20200623041610.7620-4-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20200623041610.7620-1-song.bao.hua@hisilicon.com>
References: <20200623041610.7620-1-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.200.72]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

zswap is allocating acomp on one different cpu with those cpus which will
eventually committing acomp_req. this patch specifies the numa node to
help compression/decompression done by local (de)compressors hardware.

Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller" <davem@davemloft.net>
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 -v2: patch is rebased againest "[PATCH] mm/zswap: careful error path
 implementation in comp_prepare" [1]
 [1] https://lkml.org/lkml/2020/6/22/347

 mm/zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index c0a85ef46610..98db09524af6 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -438,7 +438,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		pr_err("Could not allocate acomp_ctx\n");
 		return -ENOMEM;
 	}
-	acomp = crypto_alloc_acomp(pool->tfm_name, 0, 0);
+	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp));
-- 
2.27.0


