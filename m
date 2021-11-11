Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE052C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Nov 2021 16:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C53861002
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Nov 2021 16:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhKKQtR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Nov 2021 11:49:17 -0500
Received: from mail-am6eur05on2099.outbound.protection.outlook.com ([40.107.22.99]:38144
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233966AbhKKQtR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Nov 2021 11:49:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1Ke1HDB2sWPzucO0krFQRvCAE5UJF7xoJztpLjw4VABn8MK4S8qs9aCvGbVnxsmYZ0OMdgBehSyEtlYmRF1AWVcrFJ1dPkmBuWTE9SfDf8tm3QU6RVeo3t1u+6+gwml3C0AkObhzO0+spD0rNeTsQEUs+VuGBOb4oq/7T6JiM3+s6tP6yfaLz3dL/XXy98rkeP8rpFjRgl9uanNdGKytnJhxl+zJVMZKFbtYW48P9q36/7zlam01N/srRiVEkWiMVq4ILWafVnP3Z4GJHRNsq30mTfYDdRj9bY7xKVzpz1sm+aKfmEMLQ191Mr/cCggHY2uSkSKKSZEy0lK0FRiRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zerkbcep/Q5PY9vBjI53Yl6Sqd93m76agKMYCiUSVbw=;
 b=GSfce+k/bVCC/Tnm3EDmeMdmqOmuEsbB9JvxOI6NYIszw/u8NKYQoTtnIIVVgTsNh27QPpPPqBqs8g7C/xqvR4+S/KgajhjVVjQGNctUcZ8Zs1TTiGUDzrZ5BmYUfLCTLjp/rdiKCmZcb502r68Ifst2iE7hGYIFlypWfMTXqEIjC+OvJyq6gJXjfUL5lLkBfM1dxfTbBc51v/qJvmB7vtmh9HXBzwj045jyc2HcWImiDumXMCk9whMGTbbwUlUN8ItxgTjHSzsDSymwOPwGl/Iy790ujZS52Z16wIM+6LdlWpl/q+dryzjrz2jfMldG9QHwzQJW0NRxxSjh7wk3KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=leica-geosystems.com; dmarc=pass action=none
 header.from=leica-geosystems.com; dkim=pass header.d=leica-geosystems.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=leica-geosystems.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zerkbcep/Q5PY9vBjI53Yl6Sqd93m76agKMYCiUSVbw=;
 b=SgoiH0yiVS2sEoJW3xHGBGTubPQiMyv3e11YmdIQgaekGMCgJJjmssHwiRbXujjKQ1Tsiqj9oMGGb5AuanL8/jQVxsIuV75Pjuhbk80f4hLuEoiE6ich1FV6pQT3oGRP8f8xiHzIDT9JPH3FOwEi6u7DV1V2FPjCQ+LnjFvvw5w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=leica-geosystems.com;
Received: from VI1PR06MB3102.eurprd06.prod.outlook.com (2603:10a6:802:c::17)
 by VI1PR0601MB2430.eurprd06.prod.outlook.com (2603:10a6:801:7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Thu, 11 Nov
 2021 16:46:25 +0000
Received: from VI1PR06MB3102.eurprd06.prod.outlook.com
 ([fe80::5420:b387:e6b8:9e22]) by VI1PR06MB3102.eurprd06.prod.outlook.com
 ([fe80::5420:b387:e6b8:9e22%4]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 16:46:24 +0000
From:   Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
To:     horia.geanta@nxp.com, pankaj.gupta@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        iuliana.prodan@nxp.com, michael@walle.cc,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
Subject: [PATCH v2 0/2] CAAM Driver: re-factor and dynamic JR availability check
Date:   Thu, 11 Nov 2021 17:45:59 +0100
Message-Id: <20211111164601.13135-1-andrey.zhizhikin@leica-geosystems.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com>
References: <20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0166.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::13) To VI1PR06MB3102.eurprd06.prod.outlook.com
 (2603:10a6:802:c::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GEO-HfyyrYQLnZo.lgs-net.com (193.8.40.112) by ZR0P278CA0166.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:45::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16 via Frontend Transport; Thu, 11 Nov 2021 16:46:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff1e7688-ffc4-4a38-2355-08d9a532cc6a
X-MS-TrafficTypeDiagnostic: VI1PR0601MB2430:
X-Microsoft-Antispam-PRVS: <VI1PR0601MB24304EEF00F121275BEF374BA6949@VI1PR0601MB2430.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pgbBsJNd2tjv1TwbAelJ0Ge1XQTiryOGcR5fv0GCh04L3P3exxjM9FbxU0VdtlmH7n1YsyBuWUy0IgcF90xRGB5fVxWP+2tGy/5QylAv7xS5PyO3RiT2MSQ5yWyHFanh0E2jEX6CQYW66ln/THwONAeQDlwkggvvNh3/bi0eB8FWcVAO2JE+1h7UqJzAyo/ObC4Y55lqhajdWvyPVFFCOtyGyYbf9APk7cAcFvyUpCoGkV15/YhiuPj14rqA9/XOpALrUuYlxiVJygJWLGlMFNGVPLZ9xvnQ1tpLmwKSv7AY8PQLDy3I416T/fC6N8vEW5PcgaXh6HAVn+mq6HF1ZeeG1hd4WahHUt5fIsaiF31hsbxYfExh21GO+AF89kgMXTiKPa+d3yjwIrdPVYhTl4XNJOR3wMXoYZsJdHi9ynPBgsmdZYdw9EfXZFqajd628vUgLC/jGPxXImipQdnsQ0h++X/JqceGjA1oeyr+oOAocd+v6k1jCSk7MyhwsdX/I7067at9UxVsnnKBc64dbeBNiWxb0izZnTlF7bs/IscVK6Qh7Mm3yFEjTfha9gR37I+wUTZHE4nra9p4ZA2KqqXiHkTJUJse+5C9TX2SkEHghZ4Z9nn9b6xX7//PXafyZ09eGanimWGOjlo8to6oNF6bUIA5MW4t8bXtIqqoYkDvM0auh+CWG3xQWFB2DFhmYLr5yH3KdJp9ZfTIfnae1pt45wXOX/h4i6bnLMvJR4z6DqIPgJKb+N4BmZwAsMCsw6bPn4HpJf/ws7H/ut94kSKd+svdwTWUqRCxFjoIZoY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB3102.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(2906002)(8676002)(66556008)(66476007)(6486002)(508600001)(966005)(44832011)(6666004)(2616005)(956004)(8936002)(4326008)(6512007)(52116002)(83380400001)(316002)(6506007)(5660300002)(26005)(86362001)(36756003)(38100700002)(38350700002)(107886003)(186003)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o2VeYqRszAJMY/F3UmYWzXm3sjFMAYFvTe1Fkko+oNwc03wjeg1JU+D9qvLS?=
 =?us-ascii?Q?PTZpAaZ2vjPaX5P+WoCFAZaTHx4MCLvpwImUkURO0V29bPyjK7czgI1nJBy2?=
 =?us-ascii?Q?+vb2UKKXb7ZuheWQ0E5QGsd6Ec3ZTlFLE++Ltd0z3Llz+xnKSiEhqVM2zpP0?=
 =?us-ascii?Q?6TeelOJ9390nXGAjFme+Y6YyxhxBVVVwKTS0YRt5o5M4xuoQ0T5LHvoMk8Dj?=
 =?us-ascii?Q?UA/NSLJC6NA9lyBwPvtZd0Wf82eYhMCV681uWRTZvpOzHcaXJ0N7TWtdMJFk?=
 =?us-ascii?Q?GaBrzvtobAbs5IrjRlsU3CJX8ZBLUmc8ovScyAVCrJOaM1jTG/8ZhCUWVjdM?=
 =?us-ascii?Q?2YGAy30b7edKSY7Ga8JUYUffqBF1I2Iu+OXLVq2YE8arGSghtTpo9LnqnTbh?=
 =?us-ascii?Q?RZNv90L5gJH37d+go/Jx5mAhhXkCzskwj5IYWvW9voow2rSMwS+mSlaL4Nea?=
 =?us-ascii?Q?FHXljQOqu+CVvJqOusQpYnYx+t6rMlJKs8cys+NkD7sqq4R4HWnw4xtI/lMa?=
 =?us-ascii?Q?udfHlqHMZMGRjZyhUX/F/BoDfFq0IwzdAMaBv5aMU6HY+pqHA42EyV5CWvlb?=
 =?us-ascii?Q?6q1sK0Q9ArdeELSAH1D2rViSPBKd+yJbgDSt09w6ZuoAVRuw6zUDb6rRHFlq?=
 =?us-ascii?Q?KS6U9X9CxQi2ggr8FmLzGV7f6S/glIrOpoUm56PwFsHqatnf+EOP2geoxqE2?=
 =?us-ascii?Q?a9Oeyjrafx9dzorq96HkTnCCEhuVC1shlifhVjRARUmJio4jbXvV2ZF0NlZs?=
 =?us-ascii?Q?Qv/8DFI/bEzj/3XXfd69OJF+BAP0m4+a4qfY1+/5UjnEpWZp56ct+Pv8tu/u?=
 =?us-ascii?Q?9pB7ecjuvDL6MVmY7vM/tW/K6gjWnvQJVeAohCj+wOVyRhNxwhN/hNaOPlV6?=
 =?us-ascii?Q?nk89sHY2oQ+sMWwHCYPtG3bBLT61SfnkO69eyP4+OGqeddcQdeeeHJO8488O?=
 =?us-ascii?Q?45NyMHhKHpRSpbzFbL1WPROI5z6YLTXiybHSv3BLcKOCFkGLxtXkPnDUN6cS?=
 =?us-ascii?Q?XWIEMiCE86qfKGuUzgXhYnnnJWY1n0ymFVpgul0DzteyzIi9yH0hbuZm7K8+?=
 =?us-ascii?Q?KG2sPfLM9RseuwkFG0AXxdnzUWMkCWSq0Z9KLWrmrjbGfy2blQ1ojpDGjx4f?=
 =?us-ascii?Q?RnTX/qmEaNMnRIfH18MdUf3T3lcGSKs4xVlpFyiMKG8RlldioUuLYuz/c3kL?=
 =?us-ascii?Q?EpeGhEH1ihoLy0DfmGxLh0oPOrd5mp4wA389YjhUfI8QxfF5AjxIaGe/u9+B?=
 =?us-ascii?Q?PEwkqaxIG91bLdbfER2eP/NNeBSaHyQhH+TZo9sXVWAko10abj0x87nmYLUV?=
 =?us-ascii?Q?lZPu4I+RFCA27ryeNIqIKw5J7Bl+9MeTFXBBcQUA3rf9lOaA9Vyvv60kEOGW?=
 =?us-ascii?Q?6q6AMU62tzzhF1JHyN5l6BtJlp+vUeS+Xq4/G0Kku+zaK0pfdQkqGy3vt/zb?=
 =?us-ascii?Q?jpksxfj/aS2gW5Dtw9z3jKGDl6yEuLEIUM0Mo+brDLXlwZT6K66n5llQOGTY?=
 =?us-ascii?Q?ULuuL7h2N9tDQCnCFBFbYSpCkSIMyn5NXA18VqwCOpJo8rSf/8Gp6YSg3CD7?=
 =?us-ascii?Q?2nvhh5YXYZ87DwW337wG0MeAKam/4Rih8+/SF+gHziwfJWfbVTQDcTSmSeCc?=
 =?us-ascii?Q?mu6zuUQEW7TwcFHEkFA7bgXcw/TE3tlG+29bX2Bfm9eyJaWN80VAJCvnSJG8?=
 =?us-ascii?Q?ZPQT5jVsUuCth/FrEzwb7Mb5jF8=3D?=
X-OriginatorOrg: leica-geosystems.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff1e7688-ffc4-4a38-2355-08d9a532cc6a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR06MB3102.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 16:46:24.8390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1b16ab3e-b8f6-4fe3-9f3e-2db7fe549f6a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LqcWn84z+23e5RhLBGGwOYMtzzQx0dqGFgt/9E8EMj7qDVxpc0LNUuEOpKG7YQi0be+Z53C2/t7jor17iYg7OaFfMVNthihKbrIqcjaxpVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0601MB2430
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset is a follow-up work, which was originated with patch [1].

During the review of originally proposed solution, it has been
discovered that a certain level of clean-up and re-factoring would be
needed for CAAM Driver to remove static variables in JR probing
functions, and some bits of CAAM driver code that is used for debug
output purposes only.

New solution is proposed in this series, and provides following
enhancements to the CAAM Driver infrastructure:
- CAAM Driver uses new bitmap to indicate capabilities, which has been
  previously accomplished by various assorted variables in
  caam_ctrl_priv structure
- JR node parsing is made independent from the order of appearance in
  the DTB, indexing is now based on the address provided by the "reg"
  property
- CAAM Driver checks the presence on JR nodes in DTB, and matches the
  access to JR HW units in its internal registers. If the JR HW unit is
  marked to be used by TrustZone - it would be marked appropriate and
  further probing of JR device would be stopped at the very early stage.

Changelog with respect to original patch [1] is recorded in the updated
version of the patch, which is included in this series.

Link: [1]: https://lore.kernel.org/lkml/20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com/

Andrey Zhizhikin (2):
  crypto: caam - convert to use capabilities
  crypto: caam - check jr permissions before probing

 drivers/crypto/caam/caamalg_qi.c |   2 +-
 drivers/crypto/caam/ctrl.c       | 110 ++++++++++++++++++++++---------
 drivers/crypto/caam/intern.h     |  18 ++---
 drivers/crypto/caam/jr.c         |  33 ++++++++--
 drivers/crypto/caam/regs.h       |   9 ++-
 5 files changed, 122 insertions(+), 50 deletions(-)


base-commit: ad8be4fa6e8149ba6ea21fdf0089e8254437b3c8
-- 
2.25.1

