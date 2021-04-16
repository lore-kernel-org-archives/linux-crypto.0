Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D910DC433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0009610FC
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241722AbhDPJWE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:22:04 -0400
Received: from mail-mw2nam10on2068.outbound.protection.outlook.com ([40.107.94.68]:6177
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241701AbhDPJWC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Apr 2021 05:22:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOdklHWiSYrjhC66IgMWWCmNCA9gUwDBwrq0eAc5NkCXdrLsPDFouib7LEJcvlUvjEWJCEQfsGxshRCFcUlEbek7Z96xbMy/FiDyopjUoR1eOingQDDmrQjA1PuNW5jpfBPiEHU/Xf8/ZdgGNzbOx9e5IFbqcLOw1XMVywM9utqdqIcokelWwEVqH9eg7xSXNEF+CXX84hD6IQOg2Ime7TZM2t62/SA2lhTACWczzkj1UgGFdxiv8YLusIcdWkWbO/TXoCzx+xu1dd7HptVRe+0zVp3ef4zMwNf42khi/PS6B75Abw/XbIWAk7q7AalayO05E27yySgEu/fUMNlOMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Thndhyrkk+7/2pnTlz6g+/XmazKOBtIk4RHNHjcV8vU=;
 b=JGjkMLpeSFbSvViH2Y/NZ9G2i4YPQkw5d0iOThl9BtXB1x9NwoJ3zPJhMqOsSou7bN2itdOoXCB0/TUk8IrXoUtFnwOiq6iV6aDYhmz6abcpBjeHvEFsNRxp3IoEmIG4q2Gn5qyGRWuWBh0DKUgx9EWSGb+cwDg3EoONiDhZ5kAth88O12xR9NugZiBvOFi6r5uPlV+ArkCQaNoRy1rLD656/cgYlhGBx7jBzuJXz7SiA139jvFo2vNX8iBE0T8R1AgnRox2dvKTZSC6bicqPPkKs+WtaVzfXD7IGULcaplbHpwU7sGGe+BoGCaEaqtfgx/hx/fmJYTvMSlM0BKhWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Thndhyrkk+7/2pnTlz6g+/XmazKOBtIk4RHNHjcV8vU=;
 b=gFG4MVRDJLlZoHF2rU0aukuFlOPiAziU1CK4qpWbrFHfQJP6ixMfapB+M03qZkvb3KyMaFyLoi2w2XSzklUDMGVps2Uoe5EhkSjMT0+bZKAkik+3Pxknjz54zm1fgbgIYDNJGAxnVWhfi5gnIR3qE5d9K1WBrqg6PEdH5pdXA+s=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB4719.namprd12.prod.outlook.com (2603:10b6:805:e9::25)
 by SN6PR12MB4765.namprd12.prod.outlook.com (2603:10b6:805:e4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 09:21:34 +0000
Received: from SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::6999:4ad6:8648:9c8b]) by SN6PR12MB4719.namprd12.prod.outlook.com
 ([fe80::6999:4ad6:8648:9c8b%4]) with mapi id 15.20.4020.025; Fri, 16 Apr 2021
 09:21:34 +0000
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Babulu Ellune <Babulu.Ellune@amd.com>,
        Mythri Pandeshwara krishna <mythri.pandeshwarakrishna@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rijo Thomas <Rijo-john.Thomas@amd.com>
Subject: [PATCH] ccp: ccp - add support for Green Sardine
Date:   Fri, 16 Apr 2021 14:50:56 +0530
Message-Id: <c10ef44c4f0a36e9748703600c31a2570e4d691b.1618564722.git.Rijo-john.Thomas@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MA1PR01CA0134.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::28) To SN6PR12MB4719.namprd12.prod.outlook.com
 (2603:10b6:805:e9::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from andbang6.amd.com (165.204.156.251) by MA1PR01CA0134.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:35::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:21:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 279eb9e2-9393-4dbc-a00e-08d900b9076e
X-MS-TrafficTypeDiagnostic: SN6PR12MB4765:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB47657334042AECBE47933A7ECF4C9@SN6PR12MB4765.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xjy6KkfDDD9SD+bbaDPzVFxb+ToLGM0kPS28znUwWzN+Levenydne6WCZsvxJxrrrPJlj4Xyyo1308GWAMUsgWiNdHB8tvF3SwvK//8FGm+jsACj8akSWMfdcgwZduTAdZJpihRDB+s/Ca4WaYbmo0359oCxmqxAQ7fb5zzMCYswhRvW+mRGILZ9VdvpANObx8uH4zdVc9XADjbutrHIAFfBoqIFmcUFCqc8KUcs2Ek9KbvwRF9bNUrzFkqo8h9sX96hEkYAPEVRLR+ardVsrjBgkFqlZkrXOr2PyiE4PHQyTbNtvngwP0V5K5j8jz5IuaSQSwo6uk7NBj+8qFi8intWCp2znMoLVjNTsM9q/C0BE16Ak6PvMs3L5oDmwg8u/CgcF1+LWVNQKTbPPb3J8i92DRSOIcs2KjM5en04HOqbxkCMOQwkJauIPkOo+Lh9bOVnBcSrC5yeoBhbXTYoOZaoeNIbx2ET1Ul7EhKZDHA6Pi4zbw4y6L8Q8zvp9npkKc11Qi/bdhawPX/MVKsiIeZiPgZ4ARyLhy72Ytw1AdtH1nubJPestuc9CJdrDFIFAhXpGKBtCkVOcSesXzZiQN6GF7MEZVpdpekIlV+bdNqyXpcP3UjhR5q7k1ca3n1NIyaLqOY9nl/81fO7vj65RntF4smw7SkkKp/z3np/QWk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB4719.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(16526019)(5660300002)(2906002)(38350700002)(26005)(8936002)(4326008)(38100700002)(186003)(4744005)(36756003)(52116002)(7696005)(478600001)(6486002)(66556008)(110136005)(956004)(8676002)(2616005)(6666004)(316002)(54906003)(86362001)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Vpp0EhWXZAzm3j+HUORbfp8IGdPi+ikhaeszF1BmwaMDdLRjGIUnXLmCGzJM?=
 =?us-ascii?Q?pt0o/OavAAcxk8tzVUv1ZzjSB+Kz2OMnekfQABuhh6p+Z+KnulerfkVndABY?=
 =?us-ascii?Q?xcrDJQVk2+/iVkDkhABMY+Ew557kNvHAN3EqJR9PCYDpRI0dkONLlF9Yit2X?=
 =?us-ascii?Q?PP6f/Bs78g+6Uu708jpjDXhp/SNxoshOomv0tHSui371UqoSekNUWS1L+IiO?=
 =?us-ascii?Q?x7W8h/ujSHKBIZnxpGLXIvNFvz/7USW8oTXzKWx1Yp2JVcu76Fsw/6BTl7vB?=
 =?us-ascii?Q?9fW43RgJZJhFAPHm8zo9IUS1EWo0O+WJCabxKbNWKiyef48Teh/vbYbKAWH+?=
 =?us-ascii?Q?ig6EiHI65n023rwuqmq9DqkGDKSpbuOabFfz7Ooh6M+fz3DCuRM+DIj3ugiR?=
 =?us-ascii?Q?cxqd5Zs4YQDxzFJmxuE+7UC5w/b8H3PSN7Xm03QKssEkf5XTCIkx+Ol8JGxA?=
 =?us-ascii?Q?kCDxMfEgBSCZarhla1nNSi3W8y2Or7OHCS1yAQli+PEILSEtXDQl5SnGcSc3?=
 =?us-ascii?Q?5Ejfy0UBhF6KFdtLTyMgGcC6hFAM+rVNmCad/u8Sol70fSGjxL7FporoziUu?=
 =?us-ascii?Q?A7/6fH4aN49Cd6zAahs3mjW7kf8P/nE4pEXec1vFrmri93My9p/ginnJZ0tl?=
 =?us-ascii?Q?B2+l/ldNE4p+hcfAmx5GADCLh/565A5D7UQRhb3YLO72OATltcM4EakTH4Hy?=
 =?us-ascii?Q?U7RskgM+EMzL2zNUOLQpSEtyDlgFLaUuFQKm5sj1k1kP2cgsUQm7bOzRqAj4?=
 =?us-ascii?Q?CBLXUk0JH5jd7eEUKnySrRB0LRErueUGFoV+4BQfsgRjh3Oun1SMReYxkDXs?=
 =?us-ascii?Q?bEP9Kn20ah5nq6t/ahM8adAruz77Nzd0z31WWONLX5lUN5WGt59yQl9+M0Uj?=
 =?us-ascii?Q?gYHMTQnHSd000pcVVWvV0o8R9dpu5qPZsAFOmvNTxQUzyR2DERvvW6i1T85V?=
 =?us-ascii?Q?hSO+8AmbPlMop//R9CTBhehFfwTas3CsC1yjhDIQjvWJJv2YAcygYKcZr+C4?=
 =?us-ascii?Q?KUEvUOQ+ZMvQrYKG0jrrF7iSQCVs6znnA8COc8v9ht4aKpxKj9xFgk+nnAOy?=
 =?us-ascii?Q?U/Ndyf/7i1BU5ri4X1LpJRcc8Ex7iTxJMx8OyqTqFgKrPtSiyvCZ+dNZXhGV?=
 =?us-ascii?Q?u+NB8cCH17oP0lx92qYH98f+yQhuduHjocbR7KnIfu7nkflIbqwI2M3PPmH2?=
 =?us-ascii?Q?yGYOj8YhfceBIhi4MONF0mkHFf30xP5yYbvnZ35nJE3205hEPOcLwOqtjQJC?=
 =?us-ascii?Q?COqMyIWEWTD3FHw0ZgESb18JHCjgxfrdaJ5kmww6jm1XlxRETL1+/BXh1FhM?=
 =?us-ascii?Q?p+YG1s0ZnDbFdzAlnYB8NeDh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 279eb9e2-9393-4dbc-a00e-08d900b9076e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB4719.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:21:34.6873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B5gYIeN26+akhpPcPHFwVs1JJqhUo6f3ffcELIPYAoa+Tn4CBMRHalH4YskN386J0lCAkom/7az8wvit/+r1Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4765
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>

Add a new PCI device entry for Green Sardine APU.

Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Tested-by: Babulu Ellune <Babulu.Ellune@amd.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
---
 drivers/crypto/ccp/sp-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index f471dbaef1fb..f468594ef8af 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -356,6 +356,7 @@ static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x1468), (kernel_ulong_t)&dev_vdata[2] },
 	{ PCI_VDEVICE(AMD, 0x1486), (kernel_ulong_t)&dev_vdata[3] },
 	{ PCI_VDEVICE(AMD, 0x15DF), (kernel_ulong_t)&dev_vdata[4] },
+	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[4] },
 	/* Last entry must be zero */
 	{ 0, }
 };
-- 
2.17.1

