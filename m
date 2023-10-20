Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C5E2C001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 13:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377419AbjJTNuh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 09:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377424AbjJTNuf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 09:50:35 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4BC93
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 06:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697809833; x=1729345833;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=yQGB3xXizo3RDe5guSPSRF78I5xvLp75E32p5aPc5so=;
  b=LA9mg6V1YAeNzMXW4FrAwXlTk5wNNzllAfNPaOplwEPypR9PW3TlluFa
   udkJ6vSPsBXEpUuHg5bvhgZuNd9QXj33eCgi9AH+xtCeIDzkHBeDNrufK
   wwkkZw8YV/0OnJgSfiEBFJobXPBWkjsZrJ8kkQ/kHzSSzWBv8X0VqheY2
   WlOIaMJVEZfyqCK0Y+pa836MdQocLUzLVsIuWnGNuz20JNgcQq47KWM9z
   7Y85OkyHRJ/0qEtdOBetSmQKsVSstVHJkGQrzY6Fyfjl/VjmvSsSRvoYT
   G/lup/Rum73ud55crVtqNeBIhK8BRRSxYo9xVkBABmDpqYblfRnnZGgQ6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="365836083"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="365836083"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 06:50:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="1088748566"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="1088748566"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 06:50:32 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:32 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 06:50:32 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SK3uFWLPJGooCCgYJm8ktoW2tcT4+yegr6mYPz3UmgYnkJj2MeeM1pjbVCbaGMm9yzjdLs2EeOvGtf2Y95jD+JQ2CvdZuUHnAv4zdIZV6ZRqJFsch3xhl8Xd/UjKXmyvXXtJWRbPhwgocoeYGcvbxyJli+5AY8bvJtz+u0zT56ok4xRrUv4M4iwUhunCcCE5rypVMSfklrcvdQwgeT2hhqsIpCnI3ov6mmv8Sj7k1cpugp/HhXHrQ90F/V8bs40pmFhW4tI1El7dQiEbTypW4jIJS0kHrGcDDD8STo0ceyooP3b/wswS/U11J2fhiZ0pY1LdtPVcg4V2fu/l/BRW/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vkEzy/W5Y+OGdt3wgK5v7awsR+Y96F8IR0BiVrOxRSs=;
 b=JXL2GlQpLBoQ6Ln73xLV8dUz2sRQqbhHs3oEZd69IL99g7pwDGZP5MipJ+ePRMnrYUPWc9BnrqjG0SHVxaoGkKSDxmZCTaS308wHK3qNVHdsiei61DPTni1U6MlANuE8Xen9GoIuky9q+jjxxopdmk9ee701TzIO2mmr7O3eMuCWJTmx7tEAZIR5oDfT1Lx5CpebHO7ntwkenmqcEwF/76bzy9GcbKeJ5vlUjhnKemOlFFaW96uLz3yJZbynpGLQ3tpG7Gd57f+5QPmy92BV4reU6rvEW4K3v52x+KzvXPBz6Kur+W335CYkXR9vuT746GNOrRpr9+ohwgwmkSQnOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by BL3PR11MB6363.namprd11.prod.outlook.com (2603:10b6:208:3b6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Fri, 20 Oct
 2023 13:50:25 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9%4]) with mapi id 15.20.6863.032; Fri, 20 Oct 2023
 13:50:24 +0000
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Tero Kristo <tero.kristo@linux.intel.com>
Subject: [PATCH v2 06/11] crypto: qat - add bits.h to icp_qat_hw.h
Date:   Fri, 20 Oct 2023 15:49:26 +0200
Message-ID: <20231020134931.7530-7-damian.muszynski@intel.com>
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
X-MS-TrafficTypeDiagnostic: BYAPR11MB3734:EE_|BL3PR11MB6363:EE_
X-MS-Office365-Filtering-Correlation-Id: 18622f72-e15a-4d69-cd20-08dbd1738289
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FPbXtm1o53myRsItlfM51OC0YUWUU1s5OU1mnxYYA9csdA27ZezIUE9LOXn3R1izoPFpGOdcTfSDTU7ShcnJ+TVlH5naeI3f6CA/Gz5epE/JDOcOPKyeXoAq7taurceXKR+zFamIh8kr0vXe2ONrcOvbw3EYd6JS+JoyMlDsyBPhQakaslkcXkNBtowFEJhpFeEZCZfMobddTx0lx585mtUAumdktMu0mVpgaFJLkBy8d98n07JTmozEbDnX9XFTj9BWp72zWBJpg4AyJx64jsnZi9CkRVq9n5fWOGDrXJC2itihZjHRVgZaz4cXZXGvSH152Me4Q+tm88c1a6D3+ugWWprW5JM5+Qpjq2qGCAcaZvyG+hdpNINuPNYZwtiN+NN9JYd1JOn4pOfCO0MZ8DMoY1ljzY7NXPwRZ5DVS7jMhmb6AypAJdlZ1DEXwKc0WvRZpQCMYOLePl2aWBmaQVZxYdhnOGT0RCYx0Ma1kcxsP/SBz1MfV0ftZputH1yMXU/dp+gfddey58wudor4PWyejt8JtS7MEquy3ap0sWzE0vc11XIjIwy+L72Tv3gI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(39860400002)(346002)(396003)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(66556008)(54906003)(66476007)(478600001)(6916009)(6486002)(66946007)(6512007)(38100700002)(1076003)(41300700001)(26005)(36916002)(316002)(2616005)(4744005)(6506007)(82960400001)(36756003)(86362001)(8676002)(8936002)(44832011)(2906002)(5660300002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T32WYv4zzPYhFCu+TrpxVVmsh3v+zZjiJ+J6epK0azBglyRTP5zi418G1VPT?=
 =?us-ascii?Q?2MRu5le2vFu/20OWRF2E2XhQ25xSzmw6E6YhnVveUdf7n2uD5NjRJN8NaY6z?=
 =?us-ascii?Q?b1cH6/YE6+SLHSe9531a1dG9YslqltPoEUgPT975BRRb5Z6u/ZWZpVHBm4g2?=
 =?us-ascii?Q?F0U5aqOtG8HtfiawZmZJSF4auFjCugP+aVYCArMIb0e0Oo84KKf9MZOYIVRh?=
 =?us-ascii?Q?Q40QVEEbObTU833Xuz0EB1iSHuowRkY3g3f+jW2WFSEeFX5351tZ6KHPa0NA?=
 =?us-ascii?Q?APpJLNlxp0oW2/swq8dpFMkdTXGws+hLZfSI0SDYNaF8NE2kQVKIimkH1NAy?=
 =?us-ascii?Q?BhO6sPTmQsNYI7ykdOgvXWQ1kwHAl8NjbQVpFhDt1LvrzKIkc0kBqbQstXeI?=
 =?us-ascii?Q?Cz3+bE7PU+V6aMNkkB/hXmXKCOx+89WycLkuUPkW97BoOOcVjhXqvUeOJRIa?=
 =?us-ascii?Q?FZvizTiSdH6/qeusGcMBlhkU+1tvRBehteSdgr5N62h7l6Bu16CIW2s15ah6?=
 =?us-ascii?Q?Xzb/vxHnESABIkUuU7yXXLBImXZI0FBilEePERxNmiHIHCMlLa4G9ZfhN6Er?=
 =?us-ascii?Q?0qqZ9TX+CAOK2LE5Zf7YBuAQQ/nPhHCjA/6kOQcMtqB8G2o0AFxsTHGY5XO0?=
 =?us-ascii?Q?6tsjGHDoYk7TwoJZHQod/E2KNdF1iv/3SZnjX3nS6z8jyBwtNEVVd1FSvm5m?=
 =?us-ascii?Q?W+oXHkhk/K06d0WFQGKEwtHifEshJL/h15Lo9OBwcHz0oZQ0Mksoa4ORYwZ8?=
 =?us-ascii?Q?5kw3GpMiY6i5DWxGl3GEJKhEvm+PPoXkKGP7AWAkgorMMQkNTkPzlvyr5hqd?=
 =?us-ascii?Q?9lg8T8JPl46b3IckI53L1rlxhn7JUX3ITU9ewOD7LZP+jXGYAamvsvo7o73q?=
 =?us-ascii?Q?zdYIpCAAlKF3NVJDGKmXla9ECxDuO8EI8YG5VHgDSWOVMYVEJ6U4YrcNYKjj?=
 =?us-ascii?Q?unpummxgm7BOrXR2IztxUbD2ecBRD2otkBzf9sXmtNip2b+4nZpi5Q4geOJl?=
 =?us-ascii?Q?RZwnhoP/uHn+S3kyVZj0U7IXDz4lhZ7QuPwdvRQ9lMa5UIlS2NVJsIXum5Im?=
 =?us-ascii?Q?2YuxkdnFaFegwXBQOA0CY4w8uhEi8HZ4oyVxoxuY8Wu9aUVtHI9sr0oP2RNk?=
 =?us-ascii?Q?72xr/Ry5FZVFhsrl6MEyjkGEpG4+pUwpYi76FYYKEXlJHmez6lF5epzfhrs+?=
 =?us-ascii?Q?+/1CyjYHZlWL+xiYS3djov5TkdqbToJL1ATq4aos6eph/U+jTYtvFlAxY4Pi?=
 =?us-ascii?Q?cNqBf1b12VR1De1fSGukHni6nt7B7737LFMuUHvU5ZhcEOy4joZWve3WCkfX?=
 =?us-ascii?Q?S2zn6JPGiJg9sm1OnEdWR5hqazPQEQofVuFuaxTjbiNAYUp+uW3KXlqA9X/x?=
 =?us-ascii?Q?B3ng8VSrVZqyQUB1EWDouIR1i6zXyb6HhD/39hjnHx5cyzhj8H797I6ciK+3?=
 =?us-ascii?Q?EV/IqhMMNbkGT3EzWKR+hR+pEtHZNx87+pAAZ7ErflA4us6SgO4TqUEVNyT6?=
 =?us-ascii?Q?RPQKrBzQI7EnvHNm5nZD7E1kIvwZEpo9kC6ccNt/leUwZ5NNXoO2GWvsT25T?=
 =?us-ascii?Q?M+PvL3u1j4/+4xqDAS70BCCaOv1bsVqol3x1BeXU23GA+Qxf1jlmLlcCs8Eo?=
 =?us-ascii?Q?2Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 18622f72-e15a-4d69-cd20-08dbd1738289
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 13:50:24.7568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tsIisgAZ8X8RSG/sQub31U7vWo/rY1xTsYFReGjj07mcsAlrUSIfTsN3Poy2opTgYmhCOKKxHDDi67ejvEF6LVe9MZArLLfGlOLi6DpE7BU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6363
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some enums use the macro BIT. Include bits.h as it is missing.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_common/icp_qat_hw.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h b/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
index 0c8883e2ccc6..eb2ef225bcee 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
@@ -3,6 +3,8 @@
 #ifndef _ICP_QAT_HW_H_
 #define _ICP_QAT_HW_H_
 
+#include <linux/bits.h>
+
 enum icp_qat_hw_ae_id {
 	ICP_QAT_HW_AE_0 = 0,
 	ICP_QAT_HW_AE_1 = 1,
-- 
2.34.1

