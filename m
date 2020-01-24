Return-Path: <SRS0=mAFZ=3O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03734C2D0CE
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Jan 2020 03:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6ACA2073B
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Jan 2020 03:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387699AbgAYDIk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jan 2020 22:08:40 -0500
Received: from 19.mo1.mail-out.ovh.net ([178.32.97.206]:47566 "EHLO
        19.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387675AbgAYDIj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jan 2020 22:08:39 -0500
X-Greylist: delayed 17251 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jan 2020 22:08:38 EST
Received: from player778.ha.ovh.net (unknown [10.108.42.170])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id 9302D1AB774
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jan 2020 23:21:05 +0100 (CET)
Received: from sk2.org (unknown [77.240.182.90])
        (Authenticated sender: steve@sk2.org)
        by player778.ha.ovh.net (Postfix) with ESMTPSA id E8C14EA12AF8;
        Fri, 24 Jan 2020 22:20:58 +0000 (UTC)
From:   Stephen Kitt <steve@sk2.org>
To:     Atul Gupta <atul.gupta@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Kitt <steve@sk2.org>
Subject: [PATCH] crypto: chelsio - remove extra allocation for chtls_dev
Date:   Fri, 24 Jan 2020 23:20:51 +0100
Message-Id: <20200124222051.1925415-1-steve@sk2.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 7913106020267085241
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedrvdehgddviecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecukfhppedtrddtrddtrddtpdejjedrvdegtddrudekvddrledtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeejkedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehsthgvvhgvsehskhdvrdhorhhgpdhrtghpthhtoheplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

chtls_uld_add allocates room for info->nports net_device structs
following the chtls_dev struct, presumably because it was originally
intended that the ports array would be stored there. This is suggested
by the assignment which was present in initial versions and removed by
c4e848586cf1 ("crypto: chelsio - remove redundant assignment to
cdev->ports"):

	cdev->ports = (struct net_device **)(cdev + 1);

This assignment was never used, being overwritten by lldi->ports
immediately afterwards, and I couldn't find any uses of the memory
allocated past the end of the struct.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 drivers/crypto/chelsio/chtls/chtls_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index 18996935d8ba..1311488be37d 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -230,8 +230,7 @@ static void *chtls_uld_add(const struct cxgb4_lld_info *info)
 	struct chtls_dev *cdev;
 	int i, j;
 
-	cdev = kzalloc(sizeof(*cdev) + info->nports *
-		      (sizeof(struct net_device *)), GFP_KERNEL);
+	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
 	if (!cdev)
 		goto out;
 
-- 
2.24.1

