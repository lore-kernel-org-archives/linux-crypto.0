Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D35C9C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Oct 2021 06:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B599160FF2
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Oct 2021 06:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhJSGod (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Oct 2021 02:44:33 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:54434 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229649AbhJSGoc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Oct 2021 02:44:32 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19J6OrGh010925;
        Tue, 19 Oct 2021 06:37:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=9qg/UxtggRC1cQ7lDXcS4/jtj4I7Ur68O4cBUnN+Ltk=;
 b=kur89UVVgKGAMThJGS4wJs5rLdMi0WzBUb0mISFtxVdK2ZMtVYYn3opl/5/8c4QAnj0Y
 kboKSyME8vJtMw+6tG9luaIDLVSpXKksMmFmfFqXLI6wP4cP0HYqImb6XtuXCwGffX1t
 7nuSGjlHrh/eJcTN5Ln+9vFU6iUbuLNRhM6djOtzqTwyeAysTREkPIRxjiBe5Qw7bdJr
 2lEXv6L0UV0nh9u91MBhkvvUFgO0j1L3ID+F17YtT65Hb2FUlmjGIm3vlpgrg2zWnD0l
 BR987nrCxP7WxSnUMbNEHtO6NEqQhTJv+y6VtpcQlsZns2wTleKhFOOuzKdMAbOkDzp6 Ag== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bs9apgpuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 06:37:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OEdpr7FQtjshOU/kGFmuiZqLEmVi6DkyNWwhav+cqTL1YbGNPAXo7A8o7+bDd6DQmP80DaTc7UH64Xx+h8UwY9K8km1xhBwJr3CPPknMdOBU25XjxgRiB8LP/OpoZX7MjaDWCuhdJPqSH4Yr1PuJI+rU/ESyoU47d9YxCQ4wk4gEB5uitJJinihHuER2YBMJUymwfIUt8FlQrUiAg20/Zg2S9E+dXFEHBoNtxloX9gnWKrrXRU+nVM3nXTTyl6qXoUFFJMtrAio7AY9FHUkM62+LrpD8fxuswVv0IRvpToh3X5GzF7VYxIbbHvij/+p0uCwo9OeNAhYVRTmmMbaRwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qg/UxtggRC1cQ7lDXcS4/jtj4I7Ur68O4cBUnN+Ltk=;
 b=RWLEmBEJWH/4VPRJEJ2dREFcClgeat0bwZD4hrDi972TMkaLm5YWq7i4hUiZIj5uLM/zqiY3YTf5jJL42DDpfcQCaOK+lsTJ0gav4i8sKE3iHUKx5f7zhtf+1Lyx9YZp7UOipwvmbsgUNAvs5R1QxK+H2w7B5JG52PYDt+PKfjxF5Q8GX5a0Wp0GLRrNVUcsyEIUdzBhKwwI+/Vq0G0qtfzGZ0sh+0cEk2JnI2OT2MhLq8k5W0aOrcSO6lNLxOJYR6KLr1f+bR8R1jVDMOjN8SW72q6ZfyBpCj0zBurDncNs/qY7Mn8mBEUEqS8FaPx9LeXzXnk1xGPRO39C72vHOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=windriver.com;
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH0PR11MB4806.namprd11.prod.outlook.com (2603:10b6:510:31::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Tue, 19 Oct
 2021 06:37:36 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::c11a:b99e:67ce:4a14]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::c11a:b99e:67ce:4a14%8]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 06:37:36 +0000
From:   Meng Li <Meng.Li@windriver.com>
To:     horia.geanta@nxp.com, pankaj.gupta@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        meng.li@windriver.com
Subject: [PATCH] driver: crypto: caam: instead this_cpu_ptr with raw_cpu_ptr
Date:   Tue, 19 Oct 2021 14:37:19 +0800
Message-Id: <20211019063719.18251-1-Meng.Li@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR06CA0024.apcprd06.prod.outlook.com
 (2603:1096:202:2e::36) To PH0PR11MB5191.namprd11.prod.outlook.com
 (2603:10b6:510:3e::24)
MIME-Version: 1.0
Received: from pek-mli1-d2.wrs.com (60.247.85.82) by HK2PR06CA0024.apcprd06.prod.outlook.com (2603:1096:202:2e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17 via Frontend Transport; Tue, 19 Oct 2021 06:37:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eaa3969b-2e9c-4180-b29b-08d992caf069
X-MS-TrafficTypeDiagnostic: PH0PR11MB4806:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR11MB48064239A6A40BBD4880CE69F1BD9@PH0PR11MB4806.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:569;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S3kK1jEqouETOSaybP47KYv1Ve8Y/D/QR7cvX1OvF+SJGYsL2xf8hfQIq47c1Ul1tGvwFFJ7e4KO2k7mW1t2CdDnKqRRnhOwf1LxbDhBPAcCc784EAGTqLPYaJ6WtMt/ZptmzmaFI1iWcaY/BIrNLvKNiz85ZooZ77q7AiqEbewTTMsX536A2yvsFgj0TIviUs6WtjbKeQmuIg6hGqKr7QJH31PnkMhJze+ZjAxVtq+wni4I3rR1RL75NNr06MNs/D5UIWfIZI2pPtNpqxM+O3WTgO4+pRopcK1aqGMUzL1TDp9VHPmU5G60QeBBym2SQsuTkk5w1W95wz53qYa6VbGqqTaNwAdazNdHBPTXs6c8oO6Mjd5gpB/Apvqy66mN6FlD+mVgQh8dbx5jfDiCfWVgaqDBmQLavkQjrlolgyK+qpAzjXIRIaXLekYxfNo66AqWbsCvk9FziwvF4H0IMc369t74ri3aUI9KxdhcpUbO1SF3NaBKsI/W+Q1hzgO/Mb18Z32A5d8VuKZDKAEQ8zRJecEO+T/U6zMWBKtJmkUJgbjyvDBP9A4DjTK2hEfklgIyUJbsd0Rz/IC6abXF3uHHFG6g3mYuQgh8H0rTRowFk37SckD0SjGX3nW0T437ITayS100SKbaFafqOI59qHDe0fbhJZtwMYifB0ANiIleSqjVB9Naf3Mx03L5Vm6QGkHk19RvBnztRACHFNxiTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(186003)(36756003)(66946007)(6666004)(8676002)(66476007)(107886003)(956004)(83380400001)(38350700002)(38100700002)(508600001)(6486002)(66556008)(2616005)(4326008)(1076003)(5660300002)(316002)(86362001)(2906002)(8936002)(52116002)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oqG+BaL0vM3OqyU3Am3B12ey33tSXQCKjs/vhw/tCDIXyRVAfFO70ZmWXVi0?=
 =?us-ascii?Q?N1IWf8SlfudVwok6l39OqLG5AsZKqxWneEgZ4UN/Q4FNOWL8laRr7/WGTbbn?=
 =?us-ascii?Q?2mPy3qnYd2AZo1+hZLbYTnG5Xe8pT3F3Z9rYQaAH/exIjxAnVq1HPMk9nr6H?=
 =?us-ascii?Q?QsX0L3xOqbuy7ZtKQMTDOomd1E3eTR+Op9R7/Ox915seqhKUk+mLeH9sFm9Q?=
 =?us-ascii?Q?8CCZYpAULLGlLqutpwaoC8jlfJ7ImLHPjjRLfs4ip1cnRr8cDsJvLZb5PO4Y?=
 =?us-ascii?Q?rKxDXHadL11ivbdN1nPNA9hDUkb+mpvN0HbwvjweAEIovoSlC+sgggAMF6VI?=
 =?us-ascii?Q?teCUL/gUVpU/ed4pW2GLtoC0bYzvQwrv0mnFINgZ2DzsbmHRanwoVyRHfqQG?=
 =?us-ascii?Q?cT78Cq8zTfBFR2Dl1TMo/rd+BR+mqyIDdwZUUbXHK7GqGB9ZoYnnPj01vKC5?=
 =?us-ascii?Q?m6VvCbT4HJS7qCcoJQc1ukKZgEtv/G7yUSPvMdg9jNS5bte7FSofY3ntMV6N?=
 =?us-ascii?Q?7B2PEfztFn+xWQQ2P5gmg1D9u6wjjnKF87TVWK/wYmcSb95I4jiTmFIjnvm5?=
 =?us-ascii?Q?z60nwjcX5JDJCptdJeIaFSf2roMoJ4hTZmcXmnJUdyIJQjyCsrvumclfqh6m?=
 =?us-ascii?Q?12ZvJkWNERDsds7V9tiLAp9eVdt06G6r1Zf5ufih3/3K/uJVt1mlm5EKpwvT?=
 =?us-ascii?Q?+w/hR8IScgs9vac3Yvd8xOTGVVR6+gyZJvAW7m9L3+fcK3+ng2pafvPJCjzS?=
 =?us-ascii?Q?gxyYJwFHtN4D+EdA3ejbNUFWrS6TMLr4awfoyrqOW5bdqCVDMGDsJYQm4wsz?=
 =?us-ascii?Q?RNYBfTbxGutVeSVDv5m+j1JW7Fh4gF4kCyM/xwuYea5Y66ZVVmRoj5ejvdQi?=
 =?us-ascii?Q?a4py7npCuNKuplkFW2Rlt6w2Ufpxt+HtK3cpcHDrE6QzLcBCwaZIXFMrI5zi?=
 =?us-ascii?Q?+ZeVR6x9Cnv801VOf+7c2w8yP77VaxzereyMPVAJ/vXLg7do6CHtwU75mUm3?=
 =?us-ascii?Q?tMzG+U3OzwOkZ89dBUSGTQWCIcxg8cvLL3Sbkg6xtGDs2Sskk747OLlg6fZN?=
 =?us-ascii?Q?JmrsPO1Tr8NY46g6ymwVl5HVmQEP5r5smibe80KNhkP3nIVvFOaPlT7iKOay?=
 =?us-ascii?Q?7aqtyQl8Do+gXizrA5X0PebXjWXl13Rz8rAIg61wPhkoiBlxa14e4Qep2koJ?=
 =?us-ascii?Q?cd9GhJKJQQVN+YBr6TQwvrpjvhYbeVlkYWMp33M8zbwDLCVmvtnCUQYvmbK7?=
 =?us-ascii?Q?5xHBjajuervM13ZNyVFTv+TKpyUYyXuHzF3/gEpraT+xZrJZ1+o/J9FnlMyC?=
 =?us-ascii?Q?ijngTcEUt9+kA4Ry2goX26gw?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaa3969b-2e9c-4180-b29b-08d992caf069
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 06:37:36.6563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1TMFmwPvpdjg+r6fJEVY117VpB7cZC/LeFMTSTMmiSWEOyhJM4pX5GVYdnucjis/5bmwYYPgovCLfKCbbGzzEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4806
X-Proofpoint-GUID: lgCR1bBHLDLEe1R_ijJNc6IBFJ5emIoD
X-Proofpoint-ORIG-GUID: lgCR1bBHLDLEe1R_ijJNc6IBFJ5emIoD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_07,2021-10-18_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 priorityscore=1501 clxscore=1011
 impostorscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190039
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When enable the kernel debug config, there is below calltrace detected:
BUG: using smp_processor_id() in preemptible [00000000] code: cryptomgr_test/339
caller is debug_smp_processor_id+0x20/0x30
CPU: 9 PID: 339 Comm: cryptomgr_test Not tainted 5.10.63-yocto-standard #1
Hardware name: NXP Layerscape LX2160ARDB (DT)
Call trace:
 dump_backtrace+0x0/0x1a0
 show_stack+0x24/0x30
 dump_stack+0xf0/0x13c
 check_preemption_disabled+0x100/0x110
 debug_smp_processor_id+0x20/0x30
 dpaa2_caam_enqueue+0x10c/0x25c
 ......
 cryptomgr_test+0x38/0x60
 kthread+0x158/0x164
 ret_from_fork+0x10/0x38
According to the comment in commit ac5d15b4519f("crypto: caam/qi2
 - use affine DPIOs "), it doesn't matter whether preemption is
disable or not. So, only instead this_cpu_ptr with raw_cpu_ptr to
avoid above call trace.

Fixes: ac5d15b4519f ("crypto: caam/qi2 - use affine DPIOs")
Cc: stable@vger.kernel.org
Signed-off-by: Meng Li <Meng.Li@windriver.com>
---
 drivers/crypto/caam/caamalg_qi2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 86fc349abc59..39db403ba8b4 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -5766,7 +5766,7 @@ int dpaa2_caam_enqueue(struct device *dev, struct caam_request *req)
 	dpaa2_fd_set_len(&fd, dpaa2_fl_get_len(&req->fd_flt[1]));
 	dpaa2_fd_set_flc(&fd, req->flc_dma);
 
-	ppriv = this_cpu_ptr(priv->ppriv);
+	ppriv = raw_cpu_ptr(priv->ppriv);
 	for (i = 0; i < (priv->dpseci_attr.num_tx_queues << 1); i++) {
 		err = dpaa2_io_service_enqueue_fq(ppriv->dpio, ppriv->req_fqid,
 						  &fd);
-- 
2.17.1

