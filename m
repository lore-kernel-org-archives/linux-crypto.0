Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C51CC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 03:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4409A603E8
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 03:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhJMD2M (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Oct 2021 23:28:12 -0400
Received: from mail-eopbgr1320124.outbound.protection.outlook.com ([40.107.132.124]:12464
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237237AbhJMD2M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Oct 2021 23:28:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCTRKGYCQuSqGI1Rpzh649lwsp2QXry6Ss5FhByZsx8Ae2MHQ9h5O4HFjsptppa0uPm6mAMSXn/vgdAkN0Ol1w24jarx1+T7k+4GdHQ89uRRDBkGCHja35CcuVlZKiwZDeyPPdvPg/S+a4L1SvoAzxlictx4D7WTbr+eEzkmzH+E65g3Wb6nDSwdkTxsSkCLz68TIYTEPuSIVl5oekznQ7/scZIt75lbjRsBKhp9PVe2jKvTv0cNUrJgMOnL61eFE1zuu4maYJNaFHpVCkc1tdZ/xzlmGTXz8qtSVt6f/e/OzBXAgoE9www1jl/6tUBWn+0aa5Pskh2UeFJ5jqs3cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpPnj7WYnnHp38LIZB/JABHaSILI/GDQE0fC/te+acg=;
 b=nM1FXBivPxz0Py8qfyIGyR4WfmtwK+fh5seESksb9UuByOEuWeMBlkCyir0wGvYp+4R+ENVU5Vfrls6ZS7Ix16qf1ZcTrvjLyJNXub0NnS1TszZVZMJ4pwA3BTj3B8SAjGB9HIU49bHxEXnn4oZ8+iPMOONQbIPkQFs6LtgQgtfLVhOr5emKrLzX1kY/4Xs0tpgx3LtLOswYZ6GmbZ8OQY8zCTqb91QhmCq0MOTygp0Z7jeOfRubuorPC9BWVVPihs5Syvv4fzVLo+JuXe0u4DbHb1mpLO4Ew6FDpt3fOHB6mtjCK6RXOrWn2DJhzI/c1WGyvWvqffpk8tUFL8E5yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CpPnj7WYnnHp38LIZB/JABHaSILI/GDQE0fC/te+acg=;
 b=O4FurDwGOKilIwjE+jnoS1BHUmipOhH3NUBQ0l0V0dIgaGCIEOLwFv3o/nP/2k9zy6HEFtOVVA3p/fSMV084O/Q27PNCM7qT5pg5CL8MmjOJ0DWJF0D4/oCm4GIMz75pjaJ0/S5vY4L1FHy1qwXtf1PsKVpOkbr9MMB/Z0d/HFs=
Authentication-Results: selenic.com; dkim=none (message not signed)
 header.d=none;selenic.com; dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB3243.apcprd06.prod.outlook.com (2603:1096:100:35::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 13 Oct
 2021 03:26:07 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414%6]) with mapi id 15.20.4587.024; Wed, 13 Oct 2021
 03:26:07 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Qing Wang <wangqing@vivo.com>
Subject: [PATCH] hw_random: replace snprintf in show functions with sysfs_emit
Date:   Tue, 12 Oct 2021 20:26:01 -0700
Message-Id: <1634095561-4030-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HKAPR03CA0019.apcprd03.prod.outlook.com
 (2603:1096:203:c9::6) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
Received: from ubuntu.localdomain (103.220.76.181) by HKAPR03CA0019.apcprd03.prod.outlook.com (2603:1096:203:c9::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4608.4 via Frontend Transport; Wed, 13 Oct 2021 03:26:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43113e44-b58a-422c-a027-08d98df93202
X-MS-TrafficTypeDiagnostic: SL2PR06MB3243:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SL2PR06MB3243924AA7774BB60C565C80BDB79@SL2PR06MB3243.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LkG5OxryUO4V1SggFJXKQACsP4eWdU7idqOvpJ+QiUOE8+ouUE9RcQazD7BOFud/Mknd/lbgQmO8Lp7W3PqFTcpd83QBy6R3bQt+dzOqeVEr8dJzdk8Xo/nFvwjnlJN5p9H1BTYO5+e9BYIo6WTJTGY/skha9lFJQWJMyUdl4+bfGA573u4TqcbJ1JI1v8XlejgW4LSXe9jdGWzduVK3W+y7JEQi5Pk8KJeVfvE/vceFa+QAp5VemeVm+CbUKKAVuUR97RQJ6l8j3UdGXG1sBwBCYOt4qaAX0xdw//0AkyY/ZYFJE/zrwOTZ5l+7ICNiL+g3HKybX+E30AXPcE3uJiDHZ1UyzIDpnLAHK5RZtBc2HctucGchfRPSIlmwULRw03gKVDh++QMxn4Jeox06hto2EkvfWOSD5O6tFzbBs+siYfIs0rhLTzIuZaWIOBBIKbwAFkw1tzJSnWGOODnv1MVeOMoZgwOksbmQnrcNeaOnpBBLSLDHNL5LzA0lrA2WtIluM65c3P4uXWxU+K5T5h4mq2ROrsukxKWmecg5TaCrzPYnaoLrjC6y5/iW9BVBDojHJQW9hjafRvCvMpBgl45puR2+reynPYBBD0iqpTN+f5bG3rSG+XzNi+Ab+9yHz7C3JW+M4nQwyEkEodAH7dpUkbdZOCXys6IuSAycxmErS6B6/XbXf2Xmb9DJwF3RWphHwpOKyyQ0NR6i/gorQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(2906002)(26005)(6512007)(4326008)(66946007)(8676002)(36756003)(66476007)(83380400001)(38100700002)(6666004)(66556008)(38350700002)(107886003)(316002)(52116002)(186003)(8936002)(6486002)(5660300002)(6506007)(110136005)(956004)(2616005)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i1cQSPxO38ruCrohtevYQG6TS8ZQdbGet1R3skugTgBoREQniRGkK0dP9ljY?=
 =?us-ascii?Q?GPHT/osaLm7qnrshEASe+hzv0JBRhrDt2DHGK4esZlXgPAMkmzsqU1RAc/VU?=
 =?us-ascii?Q?QaJDXyiucn+E+HAd73bY4lFSmK753mSh+gal/O5B50uL/ddNA5gqUoJVLulG?=
 =?us-ascii?Q?30IwNUqDykZ3NaCqTtTba5UAcqHblz6DOnIlLilJtN8oXqURh8hyl2SLujpP?=
 =?us-ascii?Q?DDARrONo0dhkHbbriP7ScSvjC92akRE5zi5vu9tq71OrR7RsXYwVIygPEhq1?=
 =?us-ascii?Q?W52jKGmv/jh5hA8vpURP1whUERW1RzXsLGe3MqnQBui2zvPXQJBEpgrsGyPn?=
 =?us-ascii?Q?nPtUiiJekStuHW7FkuVqILlBQ2hUwreglfkPQPuSYtVbNKU8fOmRlJLDkwNs?=
 =?us-ascii?Q?9EsD+dWCXHcHE2xCl/1ADAl97//7iTvyQYNcpg6BUjw2BlFa9NeuENigK7pX?=
 =?us-ascii?Q?eYjInVhILjc7aPqPjLChKi3foJPf2Rdnka/Cm2REsy1bs0Iy0EZBPRklBHec?=
 =?us-ascii?Q?YlgBJutSJw7u82k4VlmMiAollb+WnTEkG9faTRrxgXP+JzqfQDVHbLP4Vpcu?=
 =?us-ascii?Q?r74NnTy0b1NaMsbnGXszyZYFh28niadAneFbL+D8qeKoWxdOJiVWHln8XNhk?=
 =?us-ascii?Q?osKK80B9iM6kfypQ5+P3wx+wvbFrtZmcMDtU2kfDPnhsB5RDvV4chEKdfTpJ?=
 =?us-ascii?Q?7DdJ9ZfkCIr3eAqQeBya/D4z6JI1zrcIIsbUVLG3IUSNc2wd40JVJec+7NpZ?=
 =?us-ascii?Q?lOarPTtN6DlAZiEQPwCC1vdJDZIGXncbOma/aI6ejC/1yrUXlJzwqRG2pBpk?=
 =?us-ascii?Q?aYxMu2F0x0zAESjty6VUYG0HhZhzTsKQNiG5onBOeaVLPY7eqwgFu9su9ky/?=
 =?us-ascii?Q?/V8RxmWOkFRjepIQ8JM94SX+g4+tWqmiNZqOzEJAejuzk55Pzc+lDxeK+LC6?=
 =?us-ascii?Q?wI4mD+psn9h7/Pywzmx/N+iMerZVvlcDnOwg+xKtjZugqM6hV+FAenxVdLfn?=
 =?us-ascii?Q?0zFKglgIuOE51KNH/NM2Qzr1qRm9SptIx+Ml2xmZNtqVlx9WPbSc6vMfawbe?=
 =?us-ascii?Q?p5WIlRwZWPCAs7JugmqvStGae279K9H5dpN/A/wWXe+aRoTJfIE+8WsaMWZo?=
 =?us-ascii?Q?4twp0W/ZuRKT4p+uKfdIvpFAYZyboCMu7MNqVeVteBIMycPaAZljqvUeXKD1?=
 =?us-ascii?Q?IDTtRuVh/K8u9pkWhTvRMw3XMICtY7LbZrYlVlGIwU46gOuZa+tkwRkwf8eC?=
 =?us-ascii?Q?JVT0Ecy29zF1TRLnk+hAMCclMKXe0ow71ezfuf0TWre0GDJul/DA5aer8n5T?=
 =?us-ascii?Q?ROESXrmPWllb+wHRd4y/l0Gx?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43113e44-b58a-422c-a027-08d98df93202
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 03:26:07.6690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wR3vRZ9oo6SdGV9xdthopQlxl5h3FUUZBemfsSVNsVw+KwuXKQDYjyIBSSMAAp4xAvr2cFFXXpD9X9OkrHJ4bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB3243
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

coccicheck complains about the use of snprintf() in sysfs show functions.

Fix the following coccicheck warning:
drivers/char/hw_random/s390-trng.c:114:8-16: WARNING: use scnprintf or sprintf.
drivers/char/hw_random/s390-trng.c:122:8-16: WARNING: use scnprintf or sprintf.

Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Signed-off-by: Qing Wang <wangqing@vivo.com>
---
 drivers/char/hw_random/s390-trng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/s390-trng.c b/drivers/char/hw_random/s390-trng.c
index 7c673af..2beaa35 100644
--- a/drivers/char/hw_random/s390-trng.c
+++ b/drivers/char/hw_random/s390-trng.c
@@ -111,7 +111,7 @@ static ssize_t trng_counter_show(struct device *dev,
 #if IS_ENABLED(CONFIG_ARCH_RANDOM)
 	u64 arch_counter = atomic64_read(&s390_arch_random_counter);
 
-	return snprintf(buf, PAGE_SIZE,
+	return sysfs_emit(buf,
 			"trng:  %llu\n"
 			"hwrng: %llu\n"
 			"arch:  %llu\n"
@@ -119,7 +119,7 @@ static ssize_t trng_counter_show(struct device *dev,
 			dev_counter, hwrng_counter, arch_counter,
 			dev_counter + hwrng_counter + arch_counter);
 #else
-	return snprintf(buf, PAGE_SIZE,
+	return sysfs_emit(buf,
 			"trng:  %llu\n"
 			"hwrng: %llu\n"
 			"total: %llu\n",
-- 
2.7.4

