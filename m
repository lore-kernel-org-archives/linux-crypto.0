Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728F8C54EE9
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Sep 2022 06:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiISGno (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Sep 2022 02:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiISGnn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Sep 2022 02:43:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7861C92A;
        Sun, 18 Sep 2022 23:43:42 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28J0xBLG006387;
        Mon, 19 Sep 2022 06:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=AXRuPKEwU9auHSfC3dl2d8026EoCS1+saM9XrRsKz5U=;
 b=PezT7JILTyBCW1m6nZlOqzQx5TSmepO82locvNaSqDrYeMS6G23JMoUJK3etB4z3YP2F
 AUEfVCgw4QI37x4V/9tZskkohQxK8o5EiBJntiGZ95NF+nN+QHVwkxzyEsVD7uYt9bpz
 8qPLPhu7HC7QgqtChjv/+6Ji5kHWwWj9VHIE9eL50q8UOd1PJE6qi030mpJWrP8TmmBw
 xffI8Vdt6f5D/mLevNM3kK0s5+pPRBmUHLBhv95+w2Ng/5fqtm0LnFzsFuA8gWEfmlPh
 zpCLCnTpOU3MhPsOg01jrICQvuKMsiCLD0qkXIUk8YKWUKR+BVhAT+kFQN2PzBj8qiLo 1g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68m2tv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Sep 2022 06:43:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28J4h14I035847;
        Mon, 19 Sep 2022 06:43:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39hfe8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Sep 2022 06:43:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRxpnag6Cg5MELycJgPs0weEN3wQi5BNbyOmWOJnCdxobNUyW4rZcWtq/04WEBoI5U/TuHZFz3Nea9Sp0OdbkBziN17p2eOeEShAorzgrsw7Wnv4x0hTPS9B0LfsBSw6hgpmOfWdX1jHlQl6NJE/dK0N6f/cvzZtYR0GOb+W0rg5Bx0LCZ+Ie3uCNSY4IAg1tDpG6D/yURHamaClPxg1X7khnYNvAbUwIGFbjynyGYlDpvDDWGE3FA4zjvw3opNUUWrSAD58MA7jOFQAGgPyCzldspW7vHEebnqxOnOg5YPslAaOL61b3AZ5cBHYOXJuQRKsEDLMAph6s1JUZz2OPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AXRuPKEwU9auHSfC3dl2d8026EoCS1+saM9XrRsKz5U=;
 b=kpaZGxtzGHwGu7ap9oF4Eqs61YVtTOOAriik2auwKa1BZhJmSQK7ZUwa9ZGvHYGg1pqmTCkc8nh5dS/ZVjxCmOOln2vLPjQTTi/jfoKCUJZxoLEg7ZMhK6dCxxUW5iRb0t177aJOWLxtRKr+4erzXowMl2Di6EzBBpJRotf8rJh+GgRsajIs0eukexUJ09VtWPoKqsisDnDKD1rwe6oXhH30wD1ZOoLy0cLfElCKbpqjuqYNdxq6lknQBPTiGI8QPMrrDRSb9hpsxbRtmPflIByyzFIOv1Qsm+aVvI7ggFIj0rsYpEyfslUepdraxXbRDq1A4CqkQqeR/E0NQWdYXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXRuPKEwU9auHSfC3dl2d8026EoCS1+saM9XrRsKz5U=;
 b=WSBGPj9rI82tRiSpulU10D5pGm3kgH//FivoAQpBBeSSu1V9Md3B/xha1gG6Bo8k/TByj622NG7VSmuLDEVm/4GfczAYYrCEBtVApITJAVbWzeu6APgHeF44aacOQnb7n1s0vku6E7t2b9p0blucUTtW4XYK6Oo2pkcO5Z2a9kk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH0PR10MB5244.namprd10.prod.outlook.com
 (2603:10b6:610:d9::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Mon, 19 Sep
 2022 06:43:35 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6%6]) with mapi id 15.20.5632.016; Mon, 19 Sep 2022
 06:43:35 +0000
Date:   Mon, 19 Sep 2022 09:43:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     George Cherian <gcherian@marvell.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v2] crypto: cavium - prevent integer overflow loading firmware
Message-ID: <YygPj8aYTvApOQFB@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZRAP278CA0012.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|CH0PR10MB5244:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d0016a6-5243-46e9-ad04-08da9a0a46dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nS2yHRP81f3PK+++8wwhs1IPA/HBcwJH9R+yusUhK69v+ZRc7otDk985fA7zugypr19JuR8osxsCfwZGbTUK1uBXaTh4fliCdp5hkTGjaRNuAWNPIUiHvFrqnLuWqQtWoNpR0JLjv1dT3RUB7gMt14EHFwBy9AKj3SSA77F+/yJK3DynaBAqC0dhorxmsdOfhVDLXoqcmeWtHLWrJXiBH+CsowU6nJAjTte/IgrdN9gXLL0O/4PrD44fwNYns7e+bVYSUkUBBszOqdUPU8t2L9Lq8MerFSlSrN7G2AaEIXt8U/m8PLlv2SgGX1Y7eZR1H+it8CEGZdMmne6GwacNHzGAnSnfpPC/0NS4dQvjoAE1rDGJvLYczvC1mV7jW0r4HFMLb59AWeB5gQR90kT0LtSZkUmeo3xHpViHzvHSeoO+J4/gNhkXgB+ibh256IzTWMKDw4gE48wHfAooAdiJHfIpN4JSsElaR+ssARhyJga1GrC0CIXGVKp1RE1x2QzvfuPBfV2wppsHzVeGP8X4YwRXU4mZrQJ1uIuTp5vYN+MXDeid91lPAy1oODRdTw3T1tJtuAsu6m7AoBIM0ElXGlxfA4SfyuU3C9NhYPOUjg/ccIc4JJQzKHtc/WDN+L/K1DJTy58f/Kc1pkBLyH81D1FUO+bI3hWem9VPs3OgVQ/RG+ZFMTl81KNkXbaGdfQsrpCOkKIDBaDMcojD/PxnoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199015)(66946007)(66556008)(8676002)(4326008)(66476007)(5660300002)(8936002)(54906003)(6916009)(86362001)(316002)(38100700002)(83380400001)(6666004)(6486002)(6506007)(41300700001)(478600001)(186003)(9686003)(6512007)(26005)(33716001)(2906002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y6sV/2BBCu8vxXXqoJVCAAvlgNX53YY0MEyLqZL4b0P20UalK59pH8ExKvCH?=
 =?us-ascii?Q?7oTiEC4pm5qrqCP0aCsO1N03slH3gPU7Y0jLno7f0hxPBoUYrgmefZKIz/xr?=
 =?us-ascii?Q?H5h3bxevdK5TZCqTq7Fn8EbqvRH+wHZyJKPxhblloz1f+itWKS1rwaD3/sfM?=
 =?us-ascii?Q?uocNkY41nzFgFlzwIrhQaaGk5vBuobECrkMm3+q/i0kBT9szjv6Z19flBuFH?=
 =?us-ascii?Q?UkJzaPxLiwJjN4j/AQ5ilLkl52HF9ZYu6CsXkhMUUef8gPjPZXktjhjlA/a9?=
 =?us-ascii?Q?RV+QS1f6erOtU3cKgp5F3W44lnFoGAAPQ4t6VSgV8oiiewHjlBAEU8sXDe37?=
 =?us-ascii?Q?Lpmeep7KHXEG4CuN3g/I8H3qe3J+fd9SOuv8aKxUWcFJlUjqnXm4vDZMPHGR?=
 =?us-ascii?Q?6Bq9nxjGo0j4qqVt6+kFLQ+D1soGNDwIojMnV6kAq4gSRwPfTSzRp0958qua?=
 =?us-ascii?Q?Hu663+DVzCUPlL759O4p/GueWnGrSPJDh2OBqxMQEvXy5z008Bgvtbd3dEaC?=
 =?us-ascii?Q?jv8WseRgR+DWR80oO9RgkuFxvDsU36TKnP7hdQhTSQvjR9QQGX76Lx19c9iG?=
 =?us-ascii?Q?D+Crq0cnVCzCPapYmWy9Mym0kRKBLBy2ouZunMv5cLoln/Xzvc/573a3swio?=
 =?us-ascii?Q?wQ7O4YlsluebCUUv55O0SEjYO+ACkF4hie/q+PzyRRlVXBRC3dVuLYWAlm7E?=
 =?us-ascii?Q?sAGyQEIWNB7uhlgLEd0sqqCHUpKqxB/qwwor9nXLhrR9WSeRHHzfIlSZbRjj?=
 =?us-ascii?Q?QTQi1oxgGGh/7jkthjijqkZBLTxJU/lfTlaSosvWnOqttu8kRHVEIgWtXOt8?=
 =?us-ascii?Q?x8ZIZufxz9east5EzjohPA21UWvr5XgwN8wlG1iRkDchqw97akwhz9necx9y?=
 =?us-ascii?Q?uU0QZgNXZRRvjcfxHrOMjDr6A4BC/i7U0TLZpUSf1A04Sfgq/DRZyg1POmnK?=
 =?us-ascii?Q?rDUBCu3MlsVBkV8DK8a0mRsHoteE3r2Z5Mj5DfqbppgShdMN21KXjssDAQ15?=
 =?us-ascii?Q?NXMSEUYcCX7MV8ODsX0zweXOimWGJroCKxNrGC9z17K5jcc3Se2/lb/rD7mW?=
 =?us-ascii?Q?hnX/d15d06rd8JnWGhNLBTonuQKl/ms+Ygr7bJvB0smW+GkxICSu7+ScNdj9?=
 =?us-ascii?Q?0Y4KrCe2A+nLCd3QL1LB2MNeLhQVyYjYTK2dsVgOrthz4epm/NaQznbQrX58?=
 =?us-ascii?Q?vQXhSsEJzoBvrc1M55uXHw9dQaX70FuQ3/ZpvG9ms8ypr66FTBNg3QaVMTm7?=
 =?us-ascii?Q?DD9L/T0kOnY1O+drGITt+wFC8ia2eFrlM3CjcN1/SUQmJu1Au7JTzdli/npN?=
 =?us-ascii?Q?CZLZt7Lh5wb4r7yUrFCj0npITs1l5J/2vHNss8RwLD/CFbsVYy0yO7wzWu+b?=
 =?us-ascii?Q?tE7nMzIz3v/B+DGIEMBh2XYoieNREp3uCSs/IKH+TBrFdz+fWyFGi5+rJeD7?=
 =?us-ascii?Q?mgKTJRy/9x32eHszFvAEiAZkElgLF8+nBMrK4eM3BlCEYJQZVsOSYVJKqCoj?=
 =?us-ascii?Q?+VpbMD3ZpTs8TQQ0dPaLTrcMD90Q5YonZKEp3gaVYhWd0YHQEMEyJA5XUN/+?=
 =?us-ascii?Q?bmz/1nfD/nkyfpNGIsx5PYSOzQZDzJ9F9YiDJ8R3BFS5sUF1npWDR2Or9lcq?=
 =?us-ascii?Q?Dg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d0016a6-5243-46e9-ad04-08da9a0a46dd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 06:43:35.6567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: imTJe+OzK7U4VWaxBz8hHw+zsTI14C4jIgiWPkz8owKAq/nUG4R52E4kJP0INw/4xaT6zJaLv26PgPCvm6wkqxJU4i0i9OcaTUsaFnGVFkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5244
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-19_03,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209190044
X-Proofpoint-ORIG-GUID: ln3GwqAGMBMp8g84e-Zel6PV7ma397JS
X-Proofpoint-GUID: ln3GwqAGMBMp8g84e-Zel6PV7ma397JS
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The "code_length" value comes from the firmware file.  If your firmware
is untrusted realistically there is probably very little you can do to
protect yourself.  Still we try to limit the damage as much as possible.
Also Smatch marks any data read from the filesystem as untrusted and
prints warnings if it not capped correctly.

The "ntohl(ucode->code_length) * 2" multiplication can have an
integer overflow.

Fixes: 9e2c7d99941d ("crypto: cavium - Add Support for Octeon-tx CPT Engine")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: The first code removed the " * 2" so it would have caused immediate
    memory corruption and crashes.

    Also in version 2 I combine the "if (!mcode->code_size) {" check
    with the overflow check for better readability.

 drivers/crypto/cavium/cpt/cptpf_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index 8c32d0eb8fcf..6872ac344001 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -253,6 +253,7 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 	const struct firmware *fw_entry;
 	struct device *dev = &cpt->pdev->dev;
 	struct ucode_header *ucode;
+	unsigned int code_length;
 	struct microcode *mcode;
 	int j, ret = 0;
 
@@ -263,11 +264,12 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 	ucode = (struct ucode_header *)fw_entry->data;
 	mcode = &cpt->mcode[cpt->next_mc_idx];
 	memcpy(mcode->version, (u8 *)fw_entry->data, CPT_UCODE_VERSION_SZ);
-	mcode->code_size = ntohl(ucode->code_length) * 2;
-	if (!mcode->code_size) {
+	code_length = ntohl(ucode->code_length);
+	if (code_length == 0 || code_length >= INT_MAX / 2) {
 		ret = -EINVAL;
 		goto fw_release;
 	}
+	mcode->code_size = code_length * 2;
 
 	mcode->is_ae = is_ae;
 	mcode->core_mask = 0ULL;
-- 
2.35.1

