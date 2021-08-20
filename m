Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2005BC4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Aug 2021 14:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB05A61057
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Aug 2021 14:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238576AbhHTO5a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Aug 2021 10:57:30 -0400
Received: from mail-bn8nam12on2073.outbound.protection.outlook.com ([40.107.237.73]:44228
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238522AbhHTO53 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Aug 2021 10:57:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ko9KBrX/7mnaWDZ/KcIHFfXvd3MZBa3FnlMj8OafjmOH7OnOxZCV7wIaIh5vRYvtni/lY03u+JE+Jcnqje4Be6mcvypUhMKU8fNJ5D1lQejyN7Jlwl4INTbCYPt2XUBN6wUs7VU5iM02xj8XNZOxnWMFSJigkMuv6aG0oog1kH5CV0YE4l9AUK1e4J/Fxlg7Lsl0KPv/Z57QhD+XjCkDflFRq+oeLJOlXga8L82mvJFeBy8k83Y3qmx/LT+4njLRipdW3+W3XdXm6VYqEfZeiFVnKQsl0oCEZNTmCSmkPzG1LSbv26hNvzCNLgRa2Pc8h0FMGT5jJzoth/2s9LvavA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VKaylNVflQLsSyiJnh24WDssGf8l+cjeWuuawpCG6c=;
 b=UtsN30xnENR69MD4ubHTJslS1g/FBx/LVZWLZ/bymAg3Jkh9UBNU9kkCnDNjByw84LzRrkOoela/ufUm1VWIFCXWLBium65mOEPtCsV5VGLABxQnFnd7jrCAo7i05uex28fYs6GR/x5qSrOeWQi/VqbWhaXFUF3jJFhjfRKl+UgiLDUZrFeJ0YSw2NZj2h7nj+F+VisoiXcl/cywOjnOMQAQQcEXhFxdqiPlBQtTu9GeS9NXe9XLZMk+BExjQlZkumO/l+cIoyP77gaZLB56ZqdCAI9HNLZ+kbBuQ9/nBDMHs6/0aBXXW/v4CL0vGeVz5/9Pmzq+iC27swgipekCwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VKaylNVflQLsSyiJnh24WDssGf8l+cjeWuuawpCG6c=;
 b=xx9d/Z64/3pLpZ81g2j58yoVlyEQLUISbKO9p4m1YG1dzEsl7zX6TNCVzSlxdA+FwWZ1FAPdaHweblSf/eCtMyYIR3KTPx6t4TeuHdfMPcPTU9zVZhxrefv9QKHsrapx2qVtOQcOa05Jhd5O5XM0sbI8LYH3847As0bfxz1YKR4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB5549.namprd12.prod.outlook.com (2603:10b6:5:209::13)
 by DM4PR12MB5134.namprd12.prod.outlook.com (2603:10b6:5:391::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 14:56:50 +0000
Received: from DM6PR12MB5549.namprd12.prod.outlook.com
 ([fe80::4092:5d49:d028:e0df]) by DM6PR12MB5549.namprd12.prod.outlook.com
 ([fe80::4092:5d49:d028:e0df%8]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 14:56:50 +0000
From:   John Allen <john.allen@amd.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au
Cc:     thomas.lendacky@amd.com, davem@davemloft.net, john.allen@amd.com
Subject: [PATCH] crypto: ccp - Add support for new CCP/PSP device ID
Date:   Fri, 20 Aug 2021 14:56:21 +0000
Message-Id: <20210820145621.185866-1-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN6PR2001CA0008.namprd20.prod.outlook.com
 (2603:10b6:404:b4::18) To DM6PR12MB5549.namprd12.prod.outlook.com
 (2603:10b6:5:209::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jallen-jump-host.amd.com (165.204.184.1) by BN6PR2001CA0008.namprd20.prod.outlook.com (2603:10b6:404:b4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 14:56:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adcede1e-f6a3-4ba0-6b61-08d963eabd61
X-MS-TrafficTypeDiagnostic: DM4PR12MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB51345FAA60CDA6C294949EC09AC19@DM4PR12MB5134.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 56MvmpjvawLgsNacEnV1VHTDycM2RFjGpoazgBozLM8OgAhvtesnIGj0ZLMOJIF0aBc1FIcnd39/tGgAYh8+keAv3JHsq3AyvVAGWkwpEfS0qUoFIXbgSzeeVlAn/I9bTO6nnLRhUy8AYcvyusQhY5MPHanSVOO8Yc40X/7y0pG2k3frwHNVvlBnudJLBCzuAkhlRJ5TpHs07as/+qCN05AlQyBcyrQeJx5Rj3wXVwXzDhpT6lpAr5wkAg7uKEKapNqft1M2MywCy3GXTOyz3fzHn6/FxsQoGZoxntO6IZyIQDwqXmJe9nc6acMD0hY32MY0tBKP0YLzi066zuLjIiZ//0ywbFtto0+RtfXNC/vpqrExa6sCvGkkMZGwzpTQ/ZlA7EZD2/xxK2gOmXq+ripMcy9Nf/b8DzqBUR1FprlPfOhaOdThvWk/nQhyCKjeA44F0Fo7Qt5qJSorgU5PZlLpFh6J7w6mRYA5WepCYkmt1QIVdchtdX7Vy+ZmAMpWjoYty/7k+6PghSBHPCqngBzTi/cllECqNkj0rrGlzkqYqSBz/hDRZete55+iNGTKwcYYq/TcSrDzBy4rS2YGxeO0CA0ByQY7dqK5On4hdpAd0kqfYIOKtse01JcF5gC7JYas3ZJbNw83uCT1qya+q3AtjyH4zgNphuaXdMdS1l1zF6bfd24c3hIfG+ly+f9AwHi/SkzMS6HPTmmlaRNw2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5549.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(508600001)(4744005)(6486002)(1076003)(2616005)(956004)(38350700002)(26005)(6666004)(38100700002)(66946007)(186003)(66556008)(66476007)(8936002)(86362001)(8676002)(5660300002)(52116002)(36756003)(7696005)(44832011)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tNBN3oKj62M2M8AgAAdO7wy6CXQssgryz5turLJgZRmDlecQOM7//33OVX9Y?=
 =?us-ascii?Q?UtxSXOwH+0An4OoCr81xhOZJ8MHVBYBOfd26DsSUwLB3TFk8jcq/flhS5e7d?=
 =?us-ascii?Q?iN6exd3bS3RSfPT9HJOdIPmCRN9iS0QUkTPUgHHTHQwLJWbNplIaQ5bSfRed?=
 =?us-ascii?Q?WfZeSaDQe0QwqP+xf0DxAkGaZcM9FNl2OHpZACzup8IAoQnZjYVmPz9a/tmS?=
 =?us-ascii?Q?by89EDFgQ1lcUDshmdhdc6xbnKVabIUKGbwcVjd+k8kf0Y6yq2kNJnKIJEt4?=
 =?us-ascii?Q?C+TvNXStuHJJDYx869MVf1FD2n/xmG1VVRVHll3623xKpEyqxzNrhRxlzTp9?=
 =?us-ascii?Q?LMRocun8iwElGUQ+dYH63NjY2Iccw33cBVlSt9HRQa5SwGaUbiL4PxOjDtg0?=
 =?us-ascii?Q?uXqnhwAHGL7dx2tnNdx6GGbA+J9TRcZQDsky18upsnmu1a6yyPaaACHEw2BT?=
 =?us-ascii?Q?qfbki3bkQHAeJ/xJLh7jCNUn8YgcMDCUkLICeyabuVvXFOzSguc47uAxKZvJ?=
 =?us-ascii?Q?nKOJ8mdKBq5R8Qe79Nq85oJe9yyoOOjG9RfsIjdiWE0UiEiQAYFi+6vaz63c?=
 =?us-ascii?Q?OvoGTlVA3UJyVhlieRsjDr/OgDPiBCIHY88FMM+Pob8mKnvUOuOt5ipG/MQ1?=
 =?us-ascii?Q?ZZ1DvRS0RSENyB/SPVjLGGHgsjpdpS8y0XFbKTDAUZP3utn7ao7Q5uZsJYiq?=
 =?us-ascii?Q?3i/hBFKu08XFvJlt5Ceu/Pgr8KvLTZDsYwdpZ9Kvmma3Lu2zvUjDy3yFm0Ir?=
 =?us-ascii?Q?JEGYFvcEF5GevLOgegNyJj2ORtA4DtXlJZCR9jvbVFxxcz1JJUYnu1SMN5yi?=
 =?us-ascii?Q?XrEaULlOU+fgejmgeuJ8aWE+ct1f0v16WHW6S3P3QHYJv1N+O4e4LJe49GTx?=
 =?us-ascii?Q?QqW2ujhwn7q7rBWLXkFKbGJ5CIpnc5PnyanRe+ogMgxk8/ZsoPvCWEui6Gqd?=
 =?us-ascii?Q?pxChW6bq+dDKkXyc0/MZmGXj/W0EAH5pej7fZibaERHM4k89v7+2iGAGKRUO?=
 =?us-ascii?Q?wPeKbmGQAs/xO2LaJyPq6s2LipOZq2c8HJQlvS+3WpTsDaIUYBhvMil3Vtcf?=
 =?us-ascii?Q?AqBJu/I63qXLOf7VWSyHP8Dy7gKCJDg7jxB5diOs8TmhQf+8RLGGMwGKavaJ?=
 =?us-ascii?Q?fksNUhGNuStZGaFJi9HRm7w/4UNxUyOhb+oFCgTrqwF/sPi8ps54EKGfYAUN?=
 =?us-ascii?Q?gI225Ez4ZZA2iGJ7yZfJz5VjhxXApP6SDNBDfO24Q9CBucepj0W2fazKhGdx?=
 =?us-ascii?Q?uVM/5JckwT+nfSsKyPbnKyOY+wY+0jEDZ+2Q6vT2sn7xTbFZnKlbV1yKQ02+?=
 =?us-ascii?Q?K7m9mX9uKIslDqgtLlyMjHDe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adcede1e-f6a3-4ba0-6b61-08d963eabd61
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5549.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 14:56:50.2138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iQB10iAuzY1KnuXzxEloA0eQfXB7Q5KMm7kNFbRz941W3iYovMA3rKKi49B2P+gqk2YjlFDbTKzUhLVn7s2/Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5134
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a new CCP/PSP PCI device ID and corresponding entry in the dev_vdata
struct.

Signed-off-by: John Allen <john.allen@amd.com>
---
 drivers/crypto/ccp/sp-pci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 6fb6ba35f89d..280161292d13 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -349,6 +349,12 @@ static const struct sp_dev_vdata dev_vdata[] = {
 #endif
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 		.psp_vdata = &pspv3,
+#endif
+	},
+	{	/* 5 */
+		.bar = 2,
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
+		.psp_vdata = &pspv2,
 #endif
 	},
 };
@@ -359,6 +365,7 @@ static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x1486), (kernel_ulong_t)&dev_vdata[3] },
 	{ PCI_VDEVICE(AMD, 0x15DF), (kernel_ulong_t)&dev_vdata[4] },
 	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[4] },
+	{ PCI_VDEVICE(AMD, 0x14CA), (kernel_ulong_t)&dev_vdata[5] },
 	/* Last entry must be zero */
 	{ 0, }
 };
-- 
2.25.1

