Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BADCC433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jan 2021 20:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB15C23A9C
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jan 2021 20:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbhAOUss (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jan 2021 15:48:48 -0500
Received: from mail-dm6nam10on2089.outbound.protection.outlook.com ([40.107.93.89]:7104
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727808AbhAOUsq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jan 2021 15:48:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQajGoHLWp5fJe3M0p4Sv1ZZgho9hVQf5DAzKZwtY3NvBa2kRNBcH+Q/dRWfM8eGzuQVhJn/j47ThZETTYdW53yt3sD25mLme0LjyD0BfTwyZfUuNBL1WoaZklzwMsaC7d5LS0t5JrimVAqZ7da6W+yBsgI2N4evH5brnhyCatHawudmpIdEF8KL1ZwF3QglVTOe/Tmok3NP967jM3CTYOTLA7bu3gJGEEKANYlu9JmGNK5Xw/VXpkB/zDBivcxAIMQ+qLd4qM7mPLOIKBPLH5t3Ni00LAwUh7zCEcRyLAdbuBrK2o0cus86s04TRz6oah/NOIV2IljXbgCckYmMAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SbkiGnPmpKiPQOYh4cyaZY7heRNVywwoSXsIBqoKnJQ=;
 b=cZAZ1IFzpofOebKH7gdKfME5h+WH2XHdXYJorUv44Icj6L5Ty0eap7s1iLQzceC/zgqq31J/NLG18+f5lrR4qx9m5/BANDFT1VNOI12iS2d+7wexg1RyuIqvYcAFb0kxj8Rlo15vSb99WDWjHOxOzyax+Angl4qh5+W2I9WBWNz1rwvNvQEQfeMnntr/k5/GiP5C1WuUa/U5Nl4lLgjlvwkTQREZP+JQeaMQCoB11xHSCwJk8kLq+FCCIhCo63PMv6SUbsJEnZH7MUVbHhcvq7Cg2LK2KyCvK4+zrJgdf+k/f3h4gJDE2RbljASjjJhuQCwuG0Ic012T++jHTI2q/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SbkiGnPmpKiPQOYh4cyaZY7heRNVywwoSXsIBqoKnJQ=;
 b=U7mPIpGHZZZuK/dc9aO38WbCKewAPXRTYfQ4K0Av9b9XGiEEfTe7PbB7QfXyXP1d3Xs0f2+tiDs7gyOWgz+nf7Yzi/n/trwtjtwRltInJm0r4JAKNeTtbYJY2Vj9zXqbVTYircYFRjkn0WQqmMLwqUiOF26DGm+YytsxlpyCdhg=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=windriver.com;
Received: from BL0PR11MB3201.namprd11.prod.outlook.com (2603:10b6:208:6b::21)
 by BL0PR11MB3138.namprd11.prod.outlook.com (2603:10b6:208:7b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Fri, 15 Jan
 2021 20:47:55 +0000
Received: from BL0PR11MB3201.namprd11.prod.outlook.com
 ([fe80::85d9:7219:6427:fb43]) by BL0PR11MB3201.namprd11.prod.outlook.com
 ([fe80::85d9:7219:6427:fb43%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 20:47:55 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     daniele.alessandrelli@intel.com, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net
Subject: [PATCH] crypto: keembay: ocs-aes: use 64-bit arithmetic for computing bit_len
Date:   Fri, 15 Jan 2021 22:46:05 +0200
Message-Id: <20210115204605.36834-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [46.97.150.20]
X-ClientProxiedBy: VI1PR0102CA0092.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::33) To BL0PR11MB3201.namprd11.prod.outlook.com
 (2603:10b6:208:6b::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0092.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 20:47:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8165cbe5-d64c-42bc-621e-08d8b996d4d2
X-MS-TrafficTypeDiagnostic: BL0PR11MB3138:
X-Microsoft-Antispam-PRVS: <BL0PR11MB3138EB0754614590966E73A9FEA70@BL0PR11MB3138.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tS5jQ3rYvQEq4nKtkJklbeCC5GASX6I3ZBUCUqb7p2ZRlafPShx/D3qkptYhZcn4RERUCeiIJ4wOpUAIP3yOirD3Uf/DaYXzhhfZ3IarXtWLIdcrOfzYV89ZThje5lZiCBXp3ZteMiA9L38nURrSkkpHdJbD0EPFx9g5lbLLuojMGUdEP+saDt5Bti1VWsiz0erT9Kup0TLlLq6BkNz1Syj7yrYrE6eydU78FIooYf0gDylLm65UOAPxLDO8BGKMKTcv8e0cIeqGrl/0nyy9XN18SNjpN+Jj8C2ZomAOSES/JPKrLsZOtNKifJN9HkRZ5MhbjW0SLtDzMIvVTtNje7KysdsY8ph/GJCM+oxRPbOTwIOYuwc2weL/C613kM7C0yvpfgE5hLuQaOQdj+RmZyu5mYAJdijEFOBmeH46amJthBQzwORtGs4JCUO0DaCF6I+9rvVbD311iKr1WVK4fcclLwQ6KGzvKmDtlmOvsYBE0Z5PCCHH6MXy+iIKAZVLMQ5CqNapibAH5sfbeQW5rA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3201.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39850400004)(83380400001)(6506007)(26005)(36756003)(6486002)(86362001)(186003)(6512007)(16526019)(52116002)(478600001)(44832011)(6666004)(66946007)(2616005)(956004)(2906002)(1076003)(66476007)(66556008)(8936002)(316002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gRWh1SSoou4heUX7WjG7JRPAFClAZzpmCruvcWZD7fsy5+nteHPN2zoXxSuH?=
 =?us-ascii?Q?ZRCeWouMxtfOmTQVHjoQHII/bVzVe26RS7SzuKeVfrXSSItlotXpg2Slv2H8?=
 =?us-ascii?Q?1pIAPfAmMoLaO3MStHOjXq6woTa2x5/SprVxdDmsJn4QpMwE0Ct8X1QGVMn1?=
 =?us-ascii?Q?yzmLB17reE2/RPL2yYXrmWkSSfagPMC/y52UsjRoD5j8TxfAdwqvg9YX5vNx?=
 =?us-ascii?Q?HJeB98LrfUiuURtE3ilnZWo1fhLXKR1Age7MObTy9qqV7bYrMws4AXUz3TJq?=
 =?us-ascii?Q?TZ2YiTYKwEl3bkfCrZ6vfWYYR+EXOunEQG0hLVwMmRTpRF+Mo0zlXRpZp+oO?=
 =?us-ascii?Q?OQ0C532ByTjoMns2rzpk302jZfrelBYR9JE/0yozdXyTtvYSmMIzgoGejvQn?=
 =?us-ascii?Q?v9/GR0+okE4SlfRn9zEKzin34sCgUgH2kKplzsvNKaBF800WPIDh6S90O66Z?=
 =?us-ascii?Q?VbGjuqlg4iD2ZmBQJg8YZZff04WSmDMpvTcjrZ3DMlt3PIRDA8B9UqM0rr3e?=
 =?us-ascii?Q?ytk1Sxi5y0Pii951VYitj8HSIn+TndulLJJS1iYYT0H9EUp7uP7bmb5t2BjJ?=
 =?us-ascii?Q?t1YAJ8f5K64KikSOTObiPeOtuwgmzD5qcLDSaHpPZvW3rVS4Ua46i4Vus6eM?=
 =?us-ascii?Q?QZrvIP11IA0mMPh4VI9bK4uK7FcicRISIPlsnh8hs1ExpLg4vYdh9qyIjvm6?=
 =?us-ascii?Q?jzA9UPxDSwCCMKmmocICMiDt9a2Yr9IkA6QE9iuME2m5/rS44Msp67Kkpkbx?=
 =?us-ascii?Q?SA8Fzejn1XUvbC8vk6Nrb2UZudluKwRmGGrZ8dbsqcdb1Xp0DKhCu1PrF4fq?=
 =?us-ascii?Q?bf8ke4q3OZsGliy4T90+RoWt5CMug434snjpNy4HLbZIf9juSAbb2Z1V2VY/?=
 =?us-ascii?Q?fqzThWlWo+j+k2Eu+EkKWxBaElrQH9Lt+rIxrmIPP/fXSxPUFhCOd7IQSzOp?=
 =?us-ascii?Q?0qJUO1NbAHGrMaUtG8nydY1jAwqsyDVjBNm0m3wepfxSo7BG0Si/QE6JPoK+?=
 =?us-ascii?Q?I7XH?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8165cbe5-d64c-42bc-621e-08d8b996d4d2
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3201.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 20:47:55.1668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oPZhAtAu1XVu25/IRL+rjJLg+r2cx/VsciCVghITwh1CtJrzA04N6sSbZP7vfNoedAI9b6Qht+FJSO1beOIm+sTWqFR2sQM8TDrix0dvZGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3138
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

src_size and aad_size are defined as u32, so the following expressions are
currently being evaluated using 32-bit arithmetic:

bit_len = src_size * 8;
...
bit_len = aad_size * 8;

However, bit_len is used afterwards in a context that expects a valid
64-bit value (the lower and upper 32-bit words of bit_len are extracted
and written to hw).

In order to make sure the correct bit length is generated and the 32-bit
multiplication does not wrap around, cast src_size and aad_size to u64.

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/keembay/ocs-aes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/keembay/ocs-aes.c b/drivers/crypto/keembay/ocs-aes.c
index cc286adb1c4a..b85c89477afa 100644
--- a/drivers/crypto/keembay/ocs-aes.c
+++ b/drivers/crypto/keembay/ocs-aes.c
@@ -958,14 +958,14 @@ int ocs_aes_gcm_op(struct ocs_aes_dev *aes_dev,
 	ocs_aes_write_last_data_blk_len(aes_dev, src_size);
 
 	/* Write ciphertext bit length */
-	bit_len = src_size * 8;
+	bit_len = (u64)src_size * 8;
 	val = bit_len & 0xFFFFFFFF;
 	iowrite32(val, aes_dev->base_reg + AES_MULTIPURPOSE2_0_OFFSET);
 	val = bit_len >> 32;
 	iowrite32(val, aes_dev->base_reg + AES_MULTIPURPOSE2_1_OFFSET);
 
 	/* Write aad bit length */
-	bit_len = aad_size * 8;
+	bit_len = (u64)aad_size * 8;
 	val = bit_len & 0xFFFFFFFF;
 	iowrite32(val, aes_dev->base_reg + AES_MULTIPURPOSE2_2_OFFSET);
 	val = bit_len >> 32;
-- 
2.17.1

