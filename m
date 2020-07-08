Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B521C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 15:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F17D3207C4
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 15:06:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="TDRFStjt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgGHPGL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 11:06:11 -0400
Received: from mail-eopbgr70093.outbound.protection.outlook.com ([40.107.7.93]:32003
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729022AbgGHPGL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 11:06:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MCZ65RENXmGG4K/9IOaUkZPaSa5vcxij0Te49Q8EdSS04zjN4x+0Zv9SI4BOiHrXoTK+0QCrWKL8X0JdRwxfVcZI2aftHk8Rv2pfmiq8CgHjSNSovUsUz2Z43XbYgvaigxqJNfU4mP9A8ZKgdQhjey+i3MNb0BjDULvpgexqhORl0/Tewp2iCFPMP9iUayUnNpuaKY4mkEoHEaowgDZ6rH4sEfcCqesp2e9afxVbY2UPvsCQq4b5v3B7a65Vdt0iMafwqsVgoTO4waraLjBOsWOzYUM0EqHzvwFN3VULNV88r+aA1lks8Xc4AOBlP7b5v7QMBKrl7mwUw9bYQ/fzdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bbh7sdC8gbuCXdM0oP3TS3t+Qvwo46zHyqpjfNeomh8=;
 b=CnM3InFXZPsHwNTiTSOc9qLUS/VuFAlkyl8JzsGW5wOvuZxv0qfKPgN+o7Q+CiVufH+yh22vVpLYTQ+nxwJZAkXj9jkaX2riz5dj6UQz48ygd4yaqDkMDf/W4CUT9xh3rKOm6puxRa+dsnNoOR4dSMWJVcK4YeB1QPt8fP9lfiJ6PfOhiloak1WGy/DI+xhLhb3dsd2ejLEZK70+/q84eiZhxa4ZQqcubmA1DOj9Bau52G6GIJzfMYA6saCLq1sCKcNMxHImcoAorRGbIgDO60ej5sLmU+7RV41f/olI4XLe3ThM82rxIlVSQ8sl11zc+ANL83CpQVvfIiTS9RweOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bbh7sdC8gbuCXdM0oP3TS3t+Qvwo46zHyqpjfNeomh8=;
 b=TDRFStjtJe4YXsTaeJbeIb08Hj+N1tLJjTiOMhuylSV1xhlHVGKxLXYXMhuXBWbL/OUKLJgosbtymPhMoIaxN748z26Udf0sZnNwYbLXsz8h6byqmFukf+fLuBG+H6hGQBsmNQxZ2rhOv4SdmQwY1ggZJqVn8Fa83b3fj9seId0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM0PR05MB6788.eurprd05.prod.outlook.com
 (2603:10a6:20b:152::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Wed, 8 Jul
 2020 15:06:07 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3153.030; Wed, 8 Jul 2020
 15:06:06 +0000
From:   sven.auhagen@voleatech.de
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v1] fixes
Date:   Wed,  8 Jul 2020 17:06:05 +0200
Message-Id: <20200708150605.60657-1-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0027.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::37) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (109.193.235.168) by AM0P190CA0027.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Wed, 8 Jul 2020 15:06:06 +0000
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
X-Originating-IP: [109.193.235.168]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5c55a41-f558-4772-32d7-08d823507098
X-MS-TrafficTypeDiagnostic: AM0PR05MB6788:
X-Microsoft-Antispam-PRVS: <AM0PR05MB67883AE3595E8817F23D7DBEEF670@AM0PR05MB6788.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4u/mG6mHKZb8hvIii9UYxQyxxfCY+u9KFGpRDGE+0bSADuYC92DyqS1RdK2wS8ABSqJf/cDHoTVgGlDwGzumZKOmeDf4xPA1lKWVSKygRU2KOAZhZSXtRzZNKOMvmItUlrlpIRoGHRymT3FKJRHwHyE1aX7ns4Nbm4bVN/UjxUywXUIiPKs3/DP4mIws3f6QAGm1zRWbcr4IG0hwVh+cQSzPufFNKrRKV9f0qHtur7d1EXoUbgsKuUM8uYUar4c/fop79XGvYo+AE8kO7HRzzDu+7K7lapchNz5simMkYQ+2e8Kja0dgeNYb3D9e244e1ellPiyEIQ9R5gHqI3R8Uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(346002)(39830400003)(376002)(6512007)(2616005)(9686003)(66556008)(66476007)(1076003)(36756003)(6486002)(86362001)(66946007)(16526019)(508600001)(186003)(956004)(26005)(2906002)(52116002)(5660300002)(83380400001)(6506007)(316002)(6916009)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: X2NpNk26TU4gAvyVpMI21EwR9c9yt+5O1WE8gK5E2d4GwZScXMP8v4WdhnKyhdzIlRJQS4wzpZuqz+r1FtrgCRnbZLO8jHhRHCCjnRxZrlavoa4yiatZwLZL/mvewAJlEd+XcQ1nMf44MIdGoi8ZVOJx4L6uvSUYP6iNweJdolVO+egjQhzTS+cqySjbNkPbYKS4X5jqdNl53oo4DkgYeL7h7k5MO2YaeMoPpd36Cj/ZOoDwiN62AKrUkLV0EOU2A1jQRAvZtHDfdq7K6cvdP4r9OHcl+ahOxg27MOdnep5T09f2WaLjYjC8XXXLKCwf3HuF1kZEz/QWEu8RB+MAe9rxRGwp/mv+codwb+mWeso5Y+VOOQTH9bGpG2o2Ho1n6OH5M0uevMfuFjkWyWDPqUR7fAk3SkLDJ0Iq8OfX1LXOcddQmUWzWjd40NkblzzWBtdb69BaDrZXDGaspbzreMT00J91tJ28/w1+FKcxxdK5YlVOLesAmU7dlFHYS8XZ
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: b5c55a41-f558-4772-32d7-08d823507098
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 15:06:06.8442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CdbOs6//FcQWp65GZcu9GHjlFVuqoodS2e1JlfbYf/ykx1CWMfAwYd21VgBUMZN7eQMv26bHh/dN/5cXtcypCBk6C+FkCNTwJyJjf2Az79o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6788
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Sven Auhagen <Sven.Auhagen@voleatech.de>

---
 drivers/crypto/inside-secure/safexcel.h        | 1 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 6 +++++-
 drivers/crypto/inside-secure/safexcel_hash.c   | 6 ++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index a7ab1183a723..7341f047cb2f 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -40,6 +40,7 @@
 
 /* Static configuration */
 #define EIP197_DEFAULT_RING_SIZE		400
+#define EIP197_DEFAULT_RING_ROTATE		50
 #define EIP197_EMB_TOKENS			4 /* Pad CD to 16 dwords */
 #define EIP197_MAX_TOKENS			16
 #define EIP197_MAX_RINGS			4
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 2018b7f3942d..2c4bda960ee6 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1218,7 +1218,11 @@ static int safexcel_queue_req(struct crypto_async_request *base,
 
 	ring = ctx->base.ring;
 
-	printk("Ring %d queue length %d\n", ring, priv->ring[ring].queue->qlen);
+	// Rotate ring if full
+	if (priv->ring[ring].queue.qlen > EIP197_DEFAULT_RING_ROTATE) {
+		ctx->base.ring = safexcel_select_ring(priv);
+		ring = ctx->base.ring;
+	}
 
 	spin_lock_bh(&priv->ring[ring].queue_lock);
 	ret = crypto_enqueue_request(&priv->ring[ring].queue, base);
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index e1d65788bf41..55a573bbb3ae 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -744,6 +744,12 @@ static int safexcel_ahash_enqueue(struct ahash_request *areq)
 
 	ring = ctx->base.ring;
 
+	// Rotate ring if full
+	if (priv->ring[ring].queue.qlen > EIP197_DEFAULT_RING_ROTATE) {
+		ctx->base.ring = safexcel_select_ring(priv);
+		ring = ctx->base.ring;
+	}
+
 	spin_lock_bh(&priv->ring[ring].queue_lock);
 	ret = crypto_enqueue_request(&priv->ring[ring].queue, &areq->base);
 	spin_unlock_bh(&priv->ring[ring].queue_lock);
-- 
2.24.3 (Apple Git-128)

