Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B24ECAA25
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Aug 2022 16:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242413AbiHYQJ3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Aug 2022 12:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242600AbiHYQJV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2022 12:09:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134A0B5A41
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 09:09:20 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PG49vk003441;
        Thu, 25 Aug 2022 16:09:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=qEdZSa1CIXS3i8JP2KmL9uSLRgybPoVA3dZPWzgtEUE=;
 b=gYliDAnDc0B4DaL4PdjUKgMEnSQajawfnSE+6SbZ0KvfkZr8ADcRXxr5g7qpkPZG6dyd
 5K/LE9KIcZM2ukt9t//fiacrONg7T1a/nAfP3POSK2G/z/TIfl1dauz67XNGDW9hgI9s
 pIRtnInTxudHXzkJf/5llGksGIrYVe2FhFl9OmnZ1xG+n08Mjam7m6stytZ3ZKPJoZAO
 a5G2XYgK6tCV8nmSCYekMoa+AElo+nQU4oXO+7oeHoIEtloboACxjaGhAIkvfPTQCkj6
 UJx6P8HeiSQbyiC2zQEnUK7079sQWwIKc+FPMf2DQ9bgGIjG8jPwyyR6xnYhsgCXgdwb Mg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j5aww4js4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 16:09:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27PFJH5q016667;
        Thu, 25 Aug 2022 16:09:09 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j5n57sfbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 16:09:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDbeqRagaVQRi/B5JdF12SuFF9piqGWMZ/v5cHp8MX2wsmQQB9GjvDlwET7VVQd/9moH25yRDkhPi0woan08DA9Y0+693qYEyFcV5BZhK+HQKOhhx+bd3A9AE15PG+LUpQOMSWjZnKETEmo4Xi98jNkiYfa0HjefnQCNxa8TkJeiQEtbQQFNWHq6PfmCGhpDmh7MHYILu4US1polmb2D2EkCNbBSv3QsQqG4Jn6qMEJbLOMkmkYr5zLhZaAo/06Q5pzXoMZXX3Lq7IowAJy8vrcs1ktkeW050+3NP7swaKm5Ri4ucQqaTtw159D/oEBBR5+Tum1y0pXrCMftg4QhKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qEdZSa1CIXS3i8JP2KmL9uSLRgybPoVA3dZPWzgtEUE=;
 b=BHJWH6o5ilzacZFggTqbZjlcsH6CNiE/Ah0PoA8CCjD/3ELULYy5fb75p6MrGbHoDp2XODtl98nM7fxCGZUFPL9lFPIgOHOIKtugp49k5NdwhJq8J5whqt2X5Vd+Qd/Js75Fm5xJRF8+MC1gCk0pUfaVkPNfLmRozV6rG+qV+LWbFNOaIwW68IBPwOOV3wBra7MoBgW974zxHXkHTkFxMZxaE8G/2SvwEyPevKtQlK/Wjb244EsA9meOmcROQqNSLypt7Q/wVN7OOHi8ILFXBPdD7eaVKNIyoRHngHAvUMaXi2OHL5XPODgYmw52Z4EOAHA95xdIq901c9qEVnMsRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qEdZSa1CIXS3i8JP2KmL9uSLRgybPoVA3dZPWzgtEUE=;
 b=EIvnjTZxtJftk7DP2K8PtnHTQcsTPx+G+eVVK+7i3e92XMGWRH4G2AnZAGaR+83ZtkIfX+6M7CjkLbPVuqFY4OLBeuNr08iT+SNUWFdsoj3RZ5G7eUwYMdGKnUdINvKgeK5tbuvTjUZWtsn3kMQJ/UbeO9uBOXustmI2pqOn2JI=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH0PR10MB5450.namprd10.prod.outlook.com
 (2603:10b6:510:ee::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Thu, 25 Aug
 2022 16:09:06 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5546.024; Thu, 25 Aug 2022
 16:09:06 +0000
Date:   Thu, 25 Aug 2022 19:08:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     clabbe@baylibre.com
Cc:     linux-crypto@vger.kernel.org, linux-sunxi@lists.linux.dev
Subject: [bug report] crypto: sun8i-ss - rework handling of IV
Message-ID: <YweemJw2a5OSWx1h@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0088.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::21) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e4ea2d5-d766-4c14-cc65-08da86b422c3
X-MS-TrafficTypeDiagnostic: PH0PR10MB5450:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: axaloQGWkUCfW+by6EfwzL5MQo2/8dxho+nVXp03tTW6xKHcdoOKXj5YZ7rexHuMF66Jhwcq5Jg4xr5YSlaDPetPyLRfqgWraf3+rVUqyPNtrPa7h+1tiKbLgyc/A6qTO5OxBuaX7zL524IdEqfAUiuBmTDADd/s1K3NLmNO13y5yfZWE2n6Du0+bRfzGCSKOHaD7458Smo5/iqhcIRNHz5tWj0hrp1ZripJS8PEdRSF6JPVjip8IBeytg2ZartXXSCjYEUBIFgZKkPwHsM5mrSP7AHLGdVtPc0xjOJ9OnbbO1cg79aYPXZvkInFTqdmbYmPA4pMrmRJlDxJBdQMW2U2ysQTm9czEnOJcfUwhmXREKHoPlnbArmXgsavI9H/li2WUeGrG0AF0+Ib2iSRs3H93b1TLyia4aHufo75vF3+iTZP7/Dwit4KsJvaR5Qc1Ipx4j6HIyCji6+MVY+agIk9MtvSz3F8jXNhWNem0dqpHV3hnVPDn3JcR5JzlOs6PjhIGViri28aJI2L5X2XpOJVQMTTfbF15PINbskiRLNoCbpjUQiETNgLurPlHiZ0KiEM9QF4afqxoFimMjXxaBUiol2WmPKpXxLIu1VxNKhfMXhZiIdugsj8bsB3Y5H4SF/n6CQzPSBQKrSWsF8rc4XzdQQgxfefIdX1+eGpyUbolNdos2v2TOF8/IkqpuYIr+yW7eywuUHynxPy5VuPlGj/OY5k2DAWiPuM3LDhem+xZuV/KroV+zSv1Gje3MJa2eOuZj+XTmwJblUtwv9LY5WC3gqqTENETZzNbAOTP50=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(366004)(39860400002)(346002)(136003)(376002)(44832011)(6666004)(41300700001)(6506007)(478600001)(186003)(26005)(83380400001)(52116002)(6486002)(9686003)(6512007)(2906002)(5660300002)(33716001)(316002)(66556008)(66476007)(66946007)(6916009)(8676002)(4326008)(38100700002)(38350700002)(86362001)(8936002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WI5Cnm4isiTB6atheLnhDMNuqaKB6Hj8/y//ib4qCwotZWvy6Mu95KBCbF9J?=
 =?us-ascii?Q?G7Pgk4G9sY/cJ6jlbri2lyA/MLgi42lIKr2l0NSVMNy1P9Aq0MM3Ertk9AOk?=
 =?us-ascii?Q?gPiGQ2XiFfMPXE29aCoVQ3z5BUtLFJb0pmv5Ryz5L/efOMO9NDIpMnIMm9vc?=
 =?us-ascii?Q?Ifs4NeZEtDeYNqGRj2ibMSvKnNLIBwZnl2CGlcp6X1FnUiyeIqBQjEAcuwat?=
 =?us-ascii?Q?syRwFxoqlgj3PQFvg40wqC2yxfsoBpyCo2mly9vXKGOO6kV1bsWLtnUW+a00?=
 =?us-ascii?Q?e9StK6NMjlonDOAFz9mi17ZBqFIgJ9+A9In3rIPAaOzP1kjpk+oOpUZdw+Rz?=
 =?us-ascii?Q?fMIR6xZDMqrzkVzYne+pxNISh7qXMGcECK2r+nUZ8Va0LGkCGEFaoYFuaXOP?=
 =?us-ascii?Q?J7XcW+t5+w44O+u45Zbia8UwNXaKuuchFkSgdeL+uleisITqDEX88JUbvPCN?=
 =?us-ascii?Q?9tYzZXLhHDmYb7pwyzD+sNr7hUPdPjn77RBkyc1Jkj5enjBRvNYTi2HSIbS5?=
 =?us-ascii?Q?zvmi+3VyjameFyz7yuUWCPo2/Kb5eXm49itKW7+QXtXvTZRopKTsfkmyhcri?=
 =?us-ascii?Q?EuzMXzGXQ3WoEBaDb7SBLQyB/MOi0xeGrVKMW5cxtkTxeqENmBAcC7DL7LRJ?=
 =?us-ascii?Q?m2dOdr5MiuDr/3pp3FNohghhkwCgRjeQP4dpY/cxstIYZ0Pyz4FVxfDGBmxG?=
 =?us-ascii?Q?PtUs+zSbdeFgKDeH8zS9FAtKUFaM/rnjcny6KhS8AhmIuHCjwpN2XVPTvkdl?=
 =?us-ascii?Q?HobSthBpq8p3ly4uurQw4EpXBeWRKO11Ek25OqPuAZ7hVuPtlx1qovoMJbfw?=
 =?us-ascii?Q?1uP3YuuzZ4xkYV0H5D2ykCVMrMmvjDFjm0OKxHW3xQcbPImXi+bl1MiFoRiW?=
 =?us-ascii?Q?uszwQeErQZbHEIehAnrqS238hDgRnhw0aBtesgXlxICkJMhZO3+L7jzEZIfi?=
 =?us-ascii?Q?/t/3UcsrJjejSlzshZu0QTroAuXwugnO/BG2YrOenkoXy/xd+4pcqBH9iOqU?=
 =?us-ascii?Q?5CnpgvIew/vx7N7UxwjineZK4E0skmNNc3O1rgK4rnc4SPPU3DAehiqcvrF9?=
 =?us-ascii?Q?dW/qenomPPcwjFShlEdTXd3qV9VHyoVfrzeOvCOmBCWefeGxf4WNVSJO587t?=
 =?us-ascii?Q?pt1Dcsye3BpTzT4kK4nJdqiu6gA0goZ4vg03CsHWnYchamfEai2G/QGn3+Rp?=
 =?us-ascii?Q?B9D+zfIX6+hSoEO6VIZ89npCX6UrV9w91Lj8jPEy3SHwhLSZaw7rtDfui4ga?=
 =?us-ascii?Q?vUtt+V98/+WWS2K1iZsbU0QlPvefryEdoGxMGwSjaOCoiHFSSgaB/YgOCc/R?=
 =?us-ascii?Q?VmAa3mrSiR75d23m69DlTsZTwlOUS+Vjq7uMEcCj5rvkch4+Ylw6AAnlkulJ?=
 =?us-ascii?Q?EFMBYCRFW7Oily5s37lEvVPTdSLbdqbY8d0RY8k7i+NOT1lTdROj2thKVrZp?=
 =?us-ascii?Q?JgWhrV5EquJ+P02F0he5GPLNS3E2H3Z+Y6exS4cvwgGg8OrbvV5sFzruWBHo?=
 =?us-ascii?Q?4TSLbhT95vwyvTtuPHJjf53532+rFOYk6kinI++jl9/Hr6MF9wkeDfZu5kkL?=
 =?us-ascii?Q?PelaTEst8sNC8Wpz28kcBpw8g+CfWGGbtySTzLiQopPpFP9FW36PVtWh9eHd?=
 =?us-ascii?Q?xw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4ea2d5-d766-4c14-cc65-08da86b422c3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 16:09:06.3713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3WPyXQint0wtvPlT8KqSTj0VtY5faIhPe0V1Z03wimv+rNB0ZB+TnZqyAWP6f7uWtN32yJ9zEsdc/dDeCf9sIiECvQXbU9ukqL1W4jlQnfM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_08,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=924 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208250061
X-Proofpoint-GUID: JFnWR-63XR1UA__hhCMNy5ALdOdc_okK
X-Proofpoint-ORIG-GUID: JFnWR-63XR1UA__hhCMNy5ALdOdc_okK
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Corentin Labbe,

The patch 359e893e8af4: "crypto: sun8i-ss - rework handling of IV"
from May 2, 2022, leads to the following Smatch static checker
warning:

    drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c:146 sun8i_ss_setup_ivs()
    warn: 'a' is not a DMA mapping error

    drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c:213 sun8i_ss_cipher()
    warn: 'rctx->p_key' is not a DMA mapping error

drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
    115 static int sun8i_ss_setup_ivs(struct skcipher_request *areq)
    116 {
    117         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
    118         struct sun8i_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
    119         struct sun8i_ss_dev *ss = op->ss;
    120         struct sun8i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
    121         struct scatterlist *sg = areq->src;
    122         unsigned int todo, offset;
    123         unsigned int len = areq->cryptlen;
    124         unsigned int ivsize = crypto_skcipher_ivsize(tfm);
    125         struct sun8i_ss_flow *sf = &ss->flows[rctx->flow];
    126         int i = 0;
    127         u32 a;

This needs to be a dma_addr_t a;

    128         int err;
    129 
    130         rctx->ivlen = ivsize;
    131         if (rctx->op_dir & SS_DECRYPTION) {
    132                 offset = areq->cryptlen - ivsize;
    133                 scatterwalk_map_and_copy(sf->biv, areq->src, offset,
    134                                          ivsize, 0);
    135         }
    136 
    137         /* we need to copy all IVs from source in case DMA is bi-directionnal */
    138         while (sg && len) {
    139                 if (sg_dma_len(sg) == 0) {
    140                         sg = sg_next(sg);
    141                         continue;
    142                 }
    143                 if (i == 0)
    144                         memcpy(sf->iv[0], areq->iv, ivsize);
    145                 a = dma_map_single(ss->dev, sf->iv[i], ivsize, DMA_TO_DEVICE);
--> 146                 if (dma_mapping_error(ss->dev, a)) {

This can't be true because of the 32/63 bit bug.

    147                         memzero_explicit(sf->iv[i], ivsize);
    148                         dev_err(ss->dev, "Cannot DMA MAP IV\n");
    149                         err = -EFAULT;
    150                         goto dma_iv_error;
    151                 }
    152                 rctx->p_iv[i] = a;

But then only 32 bits are used later in the driver in ->p_iv[].  So it's
more complicated than I thought.

    153                 /* we need to setup all others IVs only in the decrypt way */
    154                 if (rctx->op_dir & SS_ENCRYPTION)
    155                         return 0;
    156                 todo = min(len, sg_dma_len(sg));
    157                 len -= todo;
    158                 i++;
    159                 if (i < MAX_SG) {
    160                         offset = sg->length - ivsize;
    161                         scatterwalk_map_and_copy(sf->iv[i], sg, offset, ivsize, 0);
    162                 }
    163                 rctx->niv = i;
    164                 sg = sg_next(sg);
    165         }
    166 
    167         return 0;
    168 dma_iv_error:
    169         i--;
    170         while (i >= 0) {
    171                 dma_unmap_single(ss->dev, rctx->p_iv[i], ivsize, DMA_TO_DEVICE);
    172                 memzero_explicit(sf->iv[i], ivsize);
    173                 i--;
    174         }
    175         return err;
    176 }

regards,
dan carpenter
