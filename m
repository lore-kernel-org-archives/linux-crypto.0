Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B275CDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 13:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377405AbjJTNuU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 09:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377395AbjJTNuS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 09:50:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B912ACA
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 06:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697809816; x=1729345816;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=jq4nS4tvy3im0kjDjxUZ+Nvi845EiJC6fWoucNyDfSs=;
  b=XeZCuUNRpmQCXqMPINtRw/6118UfXBTi7auFZTZm1AYhhunua55UL5VQ
   dMv53ZoGGJvDnpv1wNTR5pDtgBKgvVkvQ6vqKAQSZ7+RANreE8ZB5azdu
   s+NqoprB4FrKRdH1jryiItIQP7uhOJtFTWboBe28BgFSGuxmBIBBuBoQS
   lHgCLdwwVdpEMue5OjcRa4H712GUX+zdYEiS3BK9OhfhkXHnebTljkk8b
   1ij9D/A5DKqzdIIrOs2451AJgtgqM7B5VQWf0sVm2DRFUIHWzu8PtTCJq
   bD+XLMNBFxm/s8Xtfkjt5Z+N4Xr8NTBdSERFCEWgit7mBmslitdu9/1Sv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="385376709"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="385376709"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 06:50:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="931012623"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="931012623"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 06:50:16 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 06:50:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLrShgs4JL5+tfih6JIKnuGkhNrkEFA0Cf7cnFOkwTZM17tquAh8gqsC92Zd5ot4r+R3n1U3MsuKcI27Y5b47oTuHK1Q/0r1rj8bDw5y/qn7pNAHkiOsQdwyD6/DDzog9gKLy/7ZHuNswOfgROO33+2Mwq5rVrtrDK8UjUubjisDdpoHXR+BJtClaKW0tbHY4VduD+5X42vpjAGlGAfnfBPStb/d1EOwocTimQFdUWcGcwVOzxNmCABZZnl19QhtVAo2LChuaAqgctZQSxdhCVIDM8yQFoohvLXCeEqpq1rKzz+kQZrGkj4TCZ46TX+5+0R1eXSgnPEANiPtrlgSqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gRvYgiPo5YIxcu+t5W6Dwor0XqqnLr1KYcv0QplImhg=;
 b=dYlvgE2SK7Ilm2IqFZrmtfVHEX6KUCuZdBr3DY38CJkk003hFFB9J5TOGAT66wQP4tEcTP1tFWRzyNbtPt5VZ6oYV/iWDdidAwTK9unqDpH1L0/xw31HEDv1B33b0xr3BzudfR8P9sW9BFXiUEaYwBVKOjDCdCRVFyde1PDbVYKSTETPlyjkvUfUH/0mEX3+k7dF1pC6IvAIAos2+AMSfQLIPIr3HvIrMaTdxAqFgpn5TyoRuTkG9rJIPD4tqO/qzFJHg0KuEusRc40IEDdCGiGK7Thw14yad/0SulJdyS1upGwhCnwN4O0S/A8jqqhwwQhBGD+j/skVLM0uHpeNTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by PH7PR11MB8035.namprd11.prod.outlook.com (2603:10b6:510:245::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.24; Fri, 20 Oct
 2023 13:50:14 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9%4]) with mapi id 15.20.6863.032; Fri, 20 Oct 2023
 13:50:14 +0000
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>,
        Tero Kristo <tero.kristo@linux.intel.com>
Subject: [PATCH v2 02/11] crypto: qat - use masks for AE groups
Date:   Fri, 20 Oct 2023 15:49:22 +0200
Message-ID: <20231020134931.7530-3-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231020134931.7530-1-damian.muszynski@intel.com>
References: <20231020134931.7530-1-damian.muszynski@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR5P281CA0027.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::7) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3734:EE_|PH7PR11MB8035:EE_
X-MS-Office365-Filtering-Correlation-Id: 98375f33-ef05-4839-576b-08dbd1737c45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V8MmUmDpx+lm6fmw9+XvJ8J/+yr63c3RGYjLYqVE5sD2gokB+gakbpEByXRJyLzyVPkBwqN6brOIn17EzKWgUxDNepm+jBBblkb9vq/vZO3mFmKTt41zcDbeNnCOfU4qNJ9wa1se6K0T260cNMH+Q11fKmtF0gq8qnVU6k/CoZrtdVYvhbtxBhh+DF/Cb7CfIskq8o//tPcPP9kKhfDzlibDffgAiYuuIP7hBt8ka9nLho25Y7OnjpqoJ/lGHsHoVX0NXHKpselMo1Kmz43QuPx+I7B8c4fOglzgIhQ6s5mRfP4NPfXWLhhr26MYzUc700mi9paJHvWf1fEoKhWYPQcfYWxCjRkXxK+hrAVvLPvOTZusF/GzXFl29W9V8nEaTd2/IRe2w7GRokKPmGk/s3eVcv9s0CoRFJZV9chyhL7qp3WOwVMK14553IsC8AACsgLuQTxQ1YvmdvfTPVdM65vFP89Ovaxm12u2QZipIryNjWmmOw4Cj4O27LZxvF4freda8+8/3ykddTH7cWfvyyz3pGVdArwH5951n+iEdn0VaGz9GCCz1AHK4MqQO+uV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(366004)(376002)(136003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(83380400001)(54906003)(38100700002)(6916009)(66476007)(41300700001)(6512007)(36756003)(2616005)(1076003)(86362001)(44832011)(2906002)(4326008)(66946007)(5660300002)(8676002)(8936002)(6666004)(36916002)(316002)(66556008)(6506007)(6486002)(478600001)(26005)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ppe91UXvyTGyeD3EFSfPIgb8H5mX1Xl/+35e2HkijbRP9ZBtZXcxWU8hzYOs?=
 =?us-ascii?Q?kHwskFfjNlCUkzyUbWagiLPpkxHidhf2DaEeAOyyMdkG0btT+bEPy677Lw/k?=
 =?us-ascii?Q?bhhD2mmX/jnYBwyDFpdatn8N8exXALZr6NepFtjppg3AWGVFW0+BcxbrXdzQ?=
 =?us-ascii?Q?sobrMZA3OeDaHXOnz/QfpayU874vhZedekrzFc5/jGhfJZELY3PBx3X7twe1?=
 =?us-ascii?Q?at4jxdx+1qSf1pghTgwaTFbxFXiJQAZE/vREpWst2CpMOW6mW/KXgV1bktSg?=
 =?us-ascii?Q?QS6cd3H7f261Utik7dEnAlvquS9U/mWu6Ht8q9excZM35cyOVVsIsAJM1+k3?=
 =?us-ascii?Q?zREyXBvT3pbKeXTFX/sgHc9vYwO8WR5L8Pl74Do+OdYkQwf9H+YRW4zhBTUn?=
 =?us-ascii?Q?zwVKktWTg5MV+DTbTbMAWzM5+rX/xO+KwAA2vr2UJlWLJPf+xPNA8d3vMkxB?=
 =?us-ascii?Q?PzIVohr4ISd/CFImMiQOZstacB1zykdicNSJ+xiTGm8Y1Ugq9fONwDq6GvFW?=
 =?us-ascii?Q?y3bWd9ublXCOw23jqT3GXLrbmM98L5QjkNy6oLSCGlmy0W6ybgve+1eKEbwk?=
 =?us-ascii?Q?x/aS11PvxmXJ5yMD1RHJVp+Ep8fBi1mgJcSsdTpApmTrcHoU/Rwf7sG13cII?=
 =?us-ascii?Q?pdQSK7t1fP8Gcxzi0UfS1UnF6ML/7UqMX254jQBxt8Jik37+VywNcVEf9rcd?=
 =?us-ascii?Q?aa5fyNlajtr8op70s1IQz/5n5PVpS6BaNg8BqMY9ge1q3W+CXN9unA2NqRiE?=
 =?us-ascii?Q?Gq6kYZ1OVjmF/e4dXw2gDQped0kLsoQtvVqjv7lbO/D3ktsLMncZ28VdJwZT?=
 =?us-ascii?Q?VZoJGLWEx5bVJlVwV/SOK93ylVa+cNVWxtEb7p4cg/UBU45x+TON5B5F7bg8?=
 =?us-ascii?Q?BY1rIM7nRmWed3mJo2SVCfjdrWrqe/gZ/DVUsYbjGyJiI1awtB7ULRQbN3fL?=
 =?us-ascii?Q?jR7b/ECtbFMCRoZANT8+sEbhvHseNtI+Dx4JT/4OjRT3m3jdUZX8G6rBQV6J?=
 =?us-ascii?Q?ypkwp4Y7mqGdQG3fKYoLFxCVspiiC3v4Zcehux7/LDQUHD17M8BT+/V+fhJD?=
 =?us-ascii?Q?1bWDydhVWVwijbkFq+HowR+sYlwBnqhYt2chZ/ueQb/CnmSbU6+gdj5lX331?=
 =?us-ascii?Q?chbXRELHiIEfrM1g0zOXiK9rwnkncbqrToauMCPKnZ1yQE0mYnamaeAaXyAO?=
 =?us-ascii?Q?aVrsyMzPOvtW8oZIkK5dZaYx20gQtxG5cD74A4KAbgJxhr4gsRfXTKIatZs2?=
 =?us-ascii?Q?rpYBdcWJJCqmmgKQ959pwM8apkXqRScsQm00mYT3Y4cfysmViXpL9Ftsoa6n?=
 =?us-ascii?Q?EgiuTa0gEyXee2IpFWI8uordgjplszmKSKD0LPCqjH09AyYbG+QElZoAbs6e?=
 =?us-ascii?Q?ozDWlZNQi+HKdRj+iHJg29ihLBeRRZKN9uyWa1MTCLPkcmqXilxo7lg1Mqul?=
 =?us-ascii?Q?a6soXGCoAo/MRt4S3lHePnJYK7JObKptyMkRIxuvOJVg26IeZexN3bshoJca?=
 =?us-ascii?Q?2Oii3sPLzEPoOmG4idb+bflGfhG+a8sYd5WVUoITBx3N2Hh+IdaWrDAzf0m9?=
 =?us-ascii?Q?wIo1bNHtomdCBs4NS6yE61uNxChHS+hBqocr2TSpP/qMCQchFNG2sbWrHLmE?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98375f33-ef05-4839-576b-08dbd1737c45
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 13:50:14.1831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NJeKZ82DBbIK+AjIiI70wKx/0ZmCMzwP9ivfClZQV4AF3zV7em6NAnZa2L05l36X+DJ6AVMt15lQk9rLEp/UlZ9tA9nE+gTFC3lSYj3Hykg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8035
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

The adf_fw_config structures hardcode a bit mask that represents the
acceleration engines (AEs) where a certain firmware image will have to
be loaded to. Remove the hardcoded masks and replace them with defines.

This does not introduce any functional change.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 46 ++++++++++---------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 3ea4bfc91bfe..1f1e318eeabe 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -15,6 +15,10 @@
 #include "adf_cfg_services.h"
 #include "icp_qat_hw.h"
 
+#define ADF_AE_GROUP_0		GENMASK(3, 0)
+#define ADF_AE_GROUP_1		GENMASK(7, 4)
+#define ADF_AE_GROUP_2		BIT(8)
+
 enum adf_fw_objs {
 	ADF_FW_SYM_OBJ,
 	ADF_FW_ASYM_OBJ,
@@ -42,45 +46,45 @@ struct adf_fw_config {
 };
 
 static const struct adf_fw_config adf_fw_cy_config[] = {
-	{0xF0, ADF_FW_SYM_OBJ},
-	{0xF, ADF_FW_ASYM_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_SYM_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_ASYM_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_dc_config[] = {
-	{0xF0, ADF_FW_DC_OBJ},
-	{0xF, ADF_FW_DC_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_sym_config[] = {
-	{0xF0, ADF_FW_SYM_OBJ},
-	{0xF, ADF_FW_SYM_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_SYM_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_SYM_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_asym_config[] = {
-	{0xF0, ADF_FW_ASYM_OBJ},
-	{0xF, ADF_FW_ASYM_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_ASYM_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_ASYM_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_asym_dc_config[] = {
-	{0xF0, ADF_FW_ASYM_OBJ},
-	{0xF, ADF_FW_DC_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_ASYM_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_sym_dc_config[] = {
-	{0xF0, ADF_FW_SYM_OBJ},
-	{0xF, ADF_FW_DC_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_SYM_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_dcc_config[] = {
-	{0xF0, ADF_FW_DC_OBJ},
-	{0xF, ADF_FW_SYM_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_SYM_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static_assert(ARRAY_SIZE(adf_fw_cy_config) == ARRAY_SIZE(adf_fw_dc_config));
-- 
2.34.1

