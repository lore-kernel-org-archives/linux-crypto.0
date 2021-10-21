Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBFF0C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Oct 2021 18:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6D6360F22
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Oct 2021 18:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhJUSdM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Oct 2021 14:33:12 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23820 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230020AbhJUSdM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Oct 2021 14:33:12 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LI7HDX028125;
        Thu, 21 Oct 2021 18:30:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ny9F1hAd28fzQddGXh7mwgLZlybOZHKkpc7sm1jNd6s=;
 b=mnWwr9lq7Y6H/W3wSvmniO0lUl9+iO8VTXgarVwK9uKruTfPGlcBfhjWA9kMxUe2+gPr
 cK2S811KRcjttVxU58epkjUsIK4njvnFn7oC4GezEy/bgfNeU1P96M1mpdJOGxuSzHc/
 eRviE5bGv27YReWbBFcEXNcVz+RYCPrj5SiQbx4/ynQgD+p+HKIzYWWCCi/7AKqcHsox
 3XSbWqsieFBfOJ96iGmp2ex71BMb5MO0M/acf8mKdcXTWBpXMpAn5p9pz8qWWhRaoVp6
 oZdufvQoPBZ7GIyUK8D0r1cEU16Kq6OyTUKQdAv9L5e0b6euKMkq+iH85/dfdRC2DwHO Cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkwj7wy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 18:30:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LIGuIm132901;
        Thu, 21 Oct 2021 18:30:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by aserp3030.oracle.com with ESMTP id 3bqmsjmsgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 18:30:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OR91TQBxtD9mWk8P+60SUujUmB1cKvMMyrPucK96QpcYSKjVcY1Dy4Nps2DTHYRhbW+SsLH24QJnVuXiXe8+78bzNkOQ3/aaOr3o8aIC5Awj7D6/Ql2KysBXOw6oG/iQOO9SVIoI4AcCo2P3V2MjfitUsZWTMfNXLOm8oQk9fgEdffb/J+OVD6aTd0EJ3IadCLujq0c2+cmDcmAM8lWfa2KAd+w+yT43cR8SuhuYK34i7m91rGowiqUuKuf6cZFHtO4iKBENNV0xiV0IkhbZa1MWtg4ukoinJxkZ5JomNknvAMfjjOOb5AVUbgUcvtIMy61iJGrADGbG0uGOKKD4Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ny9F1hAd28fzQddGXh7mwgLZlybOZHKkpc7sm1jNd6s=;
 b=LnSMhBi1ThpSs8N38t2R6RJh96G0HNx1eR9xf8FabXXFLj+TzBKjQMRbxx6vrI34JArvB5vfMcewdPrWVQNgyz81HZm2nK1SEQKPMaDkgYOaGhL5Qgt3WP4Ee8Zc3EI1TXnOdqhLlSR6os963TgTgR6wOukrQB2Dxm6A3DtGqgAKJUpb1faH8ESYWZ9S9OCeGEC9ldZNitSBl+tU3Sr6pU/ufkQPxYo0x8h9OLdVlGsuqKLVYwvBxyDqDPJs3YKL9q1DkwgkfG5WqxvvovIMSg6wNse+93x+V1N17LA+G/ILDHZ9aBUaxJCp+NJRK8pM4WPhOwbcDLrQGCpW/JuNsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ny9F1hAd28fzQddGXh7mwgLZlybOZHKkpc7sm1jNd6s=;
 b=fpcH4Y+k1oAwPs5cxzkEs4IfbpeiEzlCr4AbZa98BSz/+zWM5kkTu2W6Y6zDObsBCCVESp3eYYK08UVd5DE9OjZ9092YmQ2/wROfl2FNxV1XGW0RrdvgwbebXecRqpKHjw+qVWqouA5WE+X/1x60KW1irTfg58W3qjz+DZ5E6LA=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27)
 by SJ0PR10MB4447.namprd10.prod.outlook.com (2603:10b6:a03:2dc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Thu, 21 Oct
 2021 18:30:43 +0000
Received: from BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::938:e546:a29a:7f03]) by BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::938:e546:a29a:7f03%6]) with mapi id 15.20.4628.018; Thu, 21 Oct 2021
 18:30:43 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: pcrypt - Delay write to padata->info
Date:   Thu, 21 Oct 2021 14:30:28 -0400
Message-Id: <20211021183028.837112-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.33.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0188.namprd13.prod.outlook.com
 (2603:10b6:208:2be::13) To BYAPR10MB2966.namprd10.prod.outlook.com
 (2603:10b6:a03:8c::27)
MIME-Version: 1.0
Received: from localhost.localdomain (98.229.125.203) by BL1PR13CA0188.namprd13.prod.outlook.com (2603:10b6:208:2be::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.10 via Frontend Transport; Thu, 21 Oct 2021 18:30:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f8ad336-50fb-4912-4b76-08d994c0e417
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4447:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44477BA23E541EBC8F90B65DD9BF9@SJ0PR10MB4447.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yA3pXKdH+bOxtjY9a0JniKI1O6LG5KF7kVSljMg9qjAUzGE9wwLHvLOdYg5NrHGzn83HlgmHrIz0W886GCLaUbN2VPdR9dTf0bbtmB63SIDgOwkA+ff0sF7oU48PITtYyf4QpLxJUCKNW48AzmIw9s9A9/9hKLDDt3t/VQngP179Evzgv9PpCCLBd949wLfcwyThBoesiuNv3qhmcgg+aGoVkbKvfULn1raKa8Ny0ArdxqeszCCIFB3nZL+5uwSUPrqrLZEeQt73H47kxn70kbdsuvoxlhSGiinPx+prO1HUpotngfU+WzrsnwWxClvU/0ZX88HIYXk5Q9KwMrJ4rRuDBA3hi7zYGNBrAnVn550ZU/EnrHnmM478ewzTUidH2Px8xvwAGSl7zkKjKKbuuBfwIngdNDTScgC8lP46zPCVKlmdyHgr9okNLbuGJmhRQnlDoIoCkWnfrSpbKHJAqJee3RBIrL8AlI5jDBM8aCjpCw5W49XMr0490NRBqvwMtk75Kdh0pgPsc9a1RytikGB9CSb+v61WuVdz1nPW84D3GJZkAAUMC5L7+BTVXYcCS8oWC1qaITmISHrXMIZr9Np64YVAcg+81UV6pbRzy90+0UWQ087MQaT5nnVHP2hqTiY3cQB4S4AWJOrXzmYpN9f+Gsun6lSRM3nt+vP21STtJOOrm+wqYFbpt7EslIjpbYRP6CGvNtBpP0lAqUXhAZK4qiQ9+RQM04Dmd6qTVC6JuPMopDBp5vIkSjApwee7N895ISZIqMc2YHox65N8kBDvPTsA6Fsl3ByOAWUNdeE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2966.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(508600001)(4326008)(5660300002)(6506007)(38350700002)(186003)(8936002)(6486002)(2906002)(66476007)(66946007)(38100700002)(83380400001)(66556008)(103116003)(6666004)(966005)(1076003)(86362001)(26005)(6512007)(2616005)(52116002)(956004)(36756003)(8676002)(316002)(7049001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MglBUNCe/lVT5FoWhIHk7Gyzri6iaK5u3fOnxUw9TeP7wGtgVHlBRdnF1Vd0?=
 =?us-ascii?Q?NQiuU8LQmiFdRpX8mbZ6myYxCQ+Zdfeg4OjQMZ+J7mHm9Vk7rpOQW8B5GaVE?=
 =?us-ascii?Q?ZIABUr4Ea1v+qAFiotwS7Fi6JGmRI0s3Uo0k4/TvJdWsGwCptn7y6upfr4pk?=
 =?us-ascii?Q?ijrm5ZeCtXYX33cPUY+dH676RI8iRCY3K19ak7IeIJA0rubJBm/iQslis92b?=
 =?us-ascii?Q?USDVFwELdu5heqwUz4U9V3yISQuqn5zS/fMsMwkNTPj/oB8EppRCggrJhaUq?=
 =?us-ascii?Q?0mist/ni9pNBvG6E6zHRI4WWBvurq5AAO6ZdGW0hGo+8KyKNWi0ZMIrZGHGi?=
 =?us-ascii?Q?GK2cLTr2+F9FCcWTBmQGdgeBct+fYqMwjyfwRX7tuFT35QTbuBVGM0NRvsUs?=
 =?us-ascii?Q?Ps85vZU5EFvveVgiV+lAcaHtIZPNF9CnOZkisEpgB1Qo6uarPPtM+Wce0e6U?=
 =?us-ascii?Q?veYkTqG4jcNnV2YvzC+7fdIQ2hzYyjpMp0qDyNu1EN/fNS0UPvCyQUwt1vMu?=
 =?us-ascii?Q?4T3uEnjfR96IXiLKDM9RigZmQQkb1n93uXnGS8uCq2a0lFIy9cX5sg4tn+ky?=
 =?us-ascii?Q?eLX2zhlN5KzhshAeqQySaOv8u7i+RJ91CNWlJR/FMsDIzjEYwVLWcOpJmofN?=
 =?us-ascii?Q?RKkCtefwTQFLzl3TY90LJ8LvHLLqoVGXWzVj643iIMmgAPvRi3ufyC86z3At?=
 =?us-ascii?Q?RdsOqRQYW026IOUM5vAmwcN8yeLOWmNNg7fgrQlgskayR+HbJIkemADhrNpn?=
 =?us-ascii?Q?VSp/9U7cWe4/NtBYhsXd83TAe/dS/6djHDJLVxyYH3dWTJcPdTz99a31HbRw?=
 =?us-ascii?Q?EPhg1RQ6oFB+tKQUysaMwpZQ8p5TQYa3glPYF09VoBP06WDe2WmBuX5+lBAk?=
 =?us-ascii?Q?SX6FtuqxVpL/d9pkv8jJ/L9ARA5TpWI9cTrPKdmLbbrf2NwvreRTslCjBIDa?=
 =?us-ascii?Q?J4aaUm7lN0TqUSblNghmpIGc2IFvdM0morccgWwyOK5Kkga30I2tAsyknhZe?=
 =?us-ascii?Q?i/a2MfQOR1CLhbra9VTSLiYBf0bBbDXGqTm4kGQ/WHu+DM3ivKs4YLBNur8B?=
 =?us-ascii?Q?RuDReDlfso6+Ig9HXRiCJIwLeFhBILomymkC2JGfWC+myJ4604iNMXf3w1Sp?=
 =?us-ascii?Q?dvocRE2LJIdC/bb1KMdfXZrZ0pXWc33oxDz4WdkRDr0mY5PXwYVugImcBImI?=
 =?us-ascii?Q?dAdmf4eU4DSl8qXW3ZMck+Q6alguSSjKKTWX+wCFEV7cYTFY/D65G3HrRfa2?=
 =?us-ascii?Q?81P+myGokueOs0GYMADkwoSXo5N9c1WwDABcTKfxvq7Bn4n+j5uLnv6/prO9?=
 =?us-ascii?Q?Wdrcd/gLAEr4C3z7GbmXlhc0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f8ad336-50fb-4912-4b76-08d994c0e417
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2966.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 18:30:43.2758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: daniel.m.jordan@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4447
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210092
X-Proofpoint-ORIG-GUID: EozwhAlUV72BTAb1EBmUspb1nU1oE4F_
X-Proofpoint-GUID: EozwhAlUV72BTAb1EBmUspb1nU1oE4F_
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These three events can race when pcrypt is used multiple times in a
template ("pcrypt(pcrypt(...))"):

  1.  [taskA] The caller makes the crypto request via crypto_aead_encrypt()
  2.  [kworkerB] padata serializes the inner pcrypt request
  3.  [kworkerC] padata serializes the outer pcrypt request

3 might finish before the call to crypto_aead_encrypt() returns in 1,
resulting in two possible issues.

First, a use-after-free of the crypto request's memory when, for
example, taskA writes to the outer pcrypt request's padata->info in
pcrypt_aead_enc() after kworkerC completes the request.

Second, the outer pcrypt request overwrites the inner pcrypt request's
return code with -EINPROGRESS, making a successful request appear to
fail.  For instance, kworkerB writes the outer pcrypt request's
padata->info in pcrypt_aead_done() and then taskA overwrites it
in pcrypt_aead_enc().

Avoid both situations by delaying the write of padata->info until after
the inner crypto request's return code is checked.  This prevents the
use-after-free by not touching the crypto request's memory after the
next-inner crypto request is made, and stops padata->info from being
overwritten.

Fixes: 5068c7a883d16 ("crypto: pcrypt - Add pcrypt crypto parallelization wrapper")
Reported-by: syzbot+b187b77c8474f9648fae@syzkaller.appspotmail.com
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---

So, pcrypt(pcrypt(...)) doesn't make all that much sense, but apparently
there's not an easy way to prevent it [1], so I'm going with the minimal
fix.

[1] https://lkml.kernel.org/20171230083744.vuclnbs677tj7pi2@gauss3.secunet.de/

 crypto/pcrypt.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index d569c7ed6c80..9d10b846ccf7 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -78,12 +78,14 @@ static void pcrypt_aead_enc(struct padata_priv *padata)
 {
 	struct pcrypt_request *preq = pcrypt_padata_request(padata);
 	struct aead_request *req = pcrypt_request_ctx(preq);
+	int ret;
 
-	padata->info = crypto_aead_encrypt(req);
+	ret = crypto_aead_encrypt(req);
 
-	if (padata->info == -EINPROGRESS)
+	if (ret == -EINPROGRESS)
 		return;
 
+	padata->info = ret;
 	padata_do_serial(padata);
 }
 
@@ -123,12 +125,14 @@ static void pcrypt_aead_dec(struct padata_priv *padata)
 {
 	struct pcrypt_request *preq = pcrypt_padata_request(padata);
 	struct aead_request *req = pcrypt_request_ctx(preq);
+	int ret;
 
-	padata->info = crypto_aead_decrypt(req);
+	ret = crypto_aead_decrypt(req);
 
-	if (padata->info == -EINPROGRESS)
+	if (ret == -EINPROGRESS)
 		return;
 
+	padata->info = ret;
 	padata_do_serial(padata);
 }
 
-- 
2.27.0

