Return-Path: <SRS0=/YgZ=AD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE395C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 02:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 979FA22210
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 02:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731082AbgFVCvC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 22:51:02 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55942 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726699AbgFVCvC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 22:51:02 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 50DD9814332985B8E437;
        Mon, 22 Jun 2020 10:51:00 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.201.106) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Mon, 22 Jun 2020 10:50:50 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <wangzhou1@hisilicon.com>, <akpm@linux-foundation.org>,
        <linux-crypto@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Seth Jennings <sjenning@redhat.com>,
        "Dan Streetman" <ddstreet@ieee.org>,
        Vitaly Wool <vitaly.wool@konsulko.com>
Subject: [PATCH 3/3] mm/zswap: specify the NUMA node of acomp to use local compressors
Date:   Mon, 22 Jun 2020 14:49:01 +1200
Message-ID: <20200622024901.12632-4-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20200622024901.12632-1-song.bao.hua@hisilicon.com>
References: <20200622024901.12632-1-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.201.106]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

zswap_cpu_comp_prepare() is called on a different CPU with the CPU which
will really send acomp_req. In order to use the right local compressors,
this patch specifies the NUMA node to which the CPU sending acomp_req
belongs.

Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller" <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 mm/zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 0d914ba6b4a0..9b1aa477022e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -437,7 +437,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		pr_err("Could not initialize acomp_ctx\n");
 		return -ENOMEM;
 	}
-	acomp = crypto_alloc_acomp(pool->tfm_name, 0, 0);
+	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR_OR_NULL(acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp));
-- 
2.27.0


