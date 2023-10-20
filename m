Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88481CDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 13:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377304AbjJTNuf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 09:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377424AbjJTNuc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 09:50:32 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A997FA3
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 06:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697809830; x=1729345830;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ny+J88a9fUWxk02zbew/tNCGAtRBiuUXV4EPwl4yxYM=;
  b=iPg+8dvEuAAQu1Fd84Wu6sYDVXiYXdX/wdqvbLT43z93fE6AEAWqS/uV
   ecvJMIT5wN1qmm9f9untCxbKbbgpPmxCkgjdtJkzxus3s9GE2eoZymMoB
   2A0Q3KCBc3q4S5VHhbOKq+GaWB/GvdhkiRy4xncbH+3IjlE3Tqc88f4/c
   n8NhrUmfcSudkov2CVSE6rHvzlkDW+5brMMZdzJdEtRdnIgd2B42cghf1
   eGru0oLMO+pk/nj+05rA0ENu24kAn7penfrY4H3g6KirrsK/UCnxfydJ2
   nViDO+au9jv5JI7qgqkOnHQRrO8Sqj9rp/VscJEhzku35ugib2yNWFCV/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="450725565"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="450725565"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 06:50:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="848086559"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="848086559"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 06:50:30 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 06:50:29 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4PdANTSR9LDbYIuedrOaKf4IVBuvRNVfkIB+oXN96VMnIe5p8sPfv50kL3dAG6VAWIQMOZLEfuhbeCfg2DSMhb9ShVm00A43BY9/WM0jyWwpU7b1jQpApd+TqIlUbYOsVUNipzxaK+jjVtWESaXHCZsbSZQwyG+kT0SKmm9e91Z2FsRqty8gm70sqvJFPzMaIoFajUWtQq8ICrlfxQkcf4YUDNOUPb8q1mxZUBY74tIuWDc0wT2vnaKpen+6FOJVLfJqyjZqKp+Eegxd8QStLxiHTH21+d/7onqB+0mv59hCXLjDtPpyyZ/Pzh/1Ij48B7HMY2Nq7Muol1xUmjRRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0xf/lALibDNelJevs5VpWI9lc8jYgawj4q/yrrI2Ww=;
 b=FMHQbev6HKJUm6MnlhIGaiXut7M0GO9pZhTvBRWd66wZlOC760YjcE2mQuqjj9Az8Q7oHTHWte0MbgWe9gy9YDz42VcTU6KB/qXXGB8SRj8C2c0vSAObFN/IRhILAxRWeEEwSTGzLqmdI2Q9GF/Nu+ipjWJrKssKMEjj2rll4uDGByS0Eg4G7AozCW9ICX463shjLuKCvRej2sNbjw1PQWC46BU2MyxhA7y7JqbnUcCU+P2lzGNvPwpfmsRtKazcNnRGQLUH2B/VrlJyS4ORfPQRKj7D8lOg4rA5wmj7nxPVHeItK7vHEL4XI2YiyH61cH/e/ostVqVUlRAVLEcQuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by BL3PR11MB6363.namprd11.prod.outlook.com (2603:10b6:208:3b6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Fri, 20 Oct
 2023 13:50:22 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9%4]) with mapi id 15.20.6863.032; Fri, 20 Oct 2023
 13:50:22 +0000
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Tero Kristo <tero.kristo@linux.intel.com>
Subject: [PATCH v2 05/11] units: Add BYTES_PER_*BIT
Date:   Fri, 20 Oct 2023 15:49:25 +0200
Message-ID: <20231020134931.7530-6-damian.muszynski@intel.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0f79931b-c98c-4065-6f49-08dbd1738100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kLL2Pz1OxcLjXxC2R3FSLuHLhSVxWHz4jgKAi7BreaHcMN4d1fxY7NF3mNI2+qMwBD1DvbdzqEDwzfI6IHI8Z9FLe+vAju+8OBEtpMO4a4qeMO6WHVpLUsqxfm58K18Fqvada/9Fn8kFxW3Xn54U6PFKZ1tmjHULnY8eAo5UTPhe2WlvENLJsV7vKvSu1D8sXLk353jPtH8BDgyrhoM7Jy1usR8oNKUfrFcDkzrXuCxFAASk5YARC0TZPph75N4cmqRi/wia2CRzZN5pcMghGnY1iDK0rK5swHdRx/Lr+YHHZPsSebn9D7o2/Z9CNfZB2J6EjyJo+/+hjh3nOifwTJvSyntOKiYbeyoJpzaoevMyYZ4bCvm04YAyDGs//vtZ13EeNbeCt2RLTfeYCHRk1QA7rz9qAnlbeQHgE6Z05nSKeypOSJqtCabbK61ObicBfUf10EKaYFYo1aueKcmpJStAKSsvUY+gE1rehjxN8KmYmH+AiUswyRmOIM9zCOGCkQBrK7uRhWIf1P5+qoX7+2xiELAOven7UP0dUieTxy2r3LaBZn+rIrBygcqo6jyI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(39860400002)(346002)(396003)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(66556008)(54906003)(66476007)(478600001)(6916009)(83380400001)(6486002)(66946007)(6512007)(38100700002)(1076003)(41300700001)(26005)(36916002)(316002)(2616005)(4744005)(6506007)(82960400001)(36756003)(86362001)(8676002)(8936002)(44832011)(2906002)(5660300002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fbremNSQUpqT/BQFQCa+2/ls7qcl04ENAk2Mr4eyafEv/b1IkrnJdE9d7uyQ?=
 =?us-ascii?Q?B+gXymtYfJVoLLJJ/ooY7VxWDlj4fyD5KmlWTWRlov9hMa7eK5/DQq4vaA6A?=
 =?us-ascii?Q?GebtMuGa/9icajjoX9q5ZXZzHejaixJih68znChxBPMjIfGpIle/nUMYFfoG?=
 =?us-ascii?Q?WZuQj+Pyb8/SMBhoY7T3kie9KpAldUNCvJIruc8QoPTaeuBHk6za3klKhM+D?=
 =?us-ascii?Q?/2vscIl/kNdQ/Rqblqx/WHzLKioyeCquf8TOIniJP+5vtt9rzA9LFRsmeha4?=
 =?us-ascii?Q?JFQHbRw2uPPmVbclf1lXHsqougvrMSWC+Xq0c4GsJZOHqoNUcA8L7sN5KX7Y?=
 =?us-ascii?Q?zgtRwmK7nAIK6vkCjsHiTK5GviUePSY2cprh73Yw4cRYohNrEHAugyZLybad?=
 =?us-ascii?Q?yi/wsLSsneatGA2DTCHtgaaBfQ9K1qXB5WzUxhPmB7JSAPCp7IwosSdaAUyD?=
 =?us-ascii?Q?UbNz4yf1v8GoMj7fiZEnZzOHnmyTsMPM82NEloUbNC6XejwI/Z+RJHJ+XUjj?=
 =?us-ascii?Q?fQWmRmAEXJ1LAAycqJDiZPhRY+u/IQHCwbptvJH7Q6vjCKs5EP8zcqaBbwpr?=
 =?us-ascii?Q?QZptt3QsjRaS4ywDoxG+d/zOl5WS5h9dt12rkZjT727uh3kKeIRIL3jmFIaq?=
 =?us-ascii?Q?6LoKwIxi9y2Fccy/wkkD+Gn98eaaQTiM8RMtRCwnhOo3h018hYylfq6HuofG?=
 =?us-ascii?Q?MrvyxcHAiDxuRi4tAx+xCmIxGo5WYlmZpnJe3XDQu0DiIfXfnbYp51F7QyL/?=
 =?us-ascii?Q?lJSx9SzyQx6ItRLo1Bmo65R9U+oX/To+IJBW8ZJJPcnccFX9Qig9neX3DHul?=
 =?us-ascii?Q?1SMPx5cXiYucSjONEyviQ8IpG54Ny5UlZoenXhBzoequq7EVqLadYVH1e2+Q?=
 =?us-ascii?Q?g4Th1ks9zLy6LHYYeVh2V/1BGPa4VghwCh2d0cDbwMyvbtMm+J6/eGC4wokM?=
 =?us-ascii?Q?8rzytIOKesvnSuDqTJyskCR0SmfzXlXfin1VptVScCCribU1DVRhpYaKrvwH?=
 =?us-ascii?Q?DRVuSow20z+kpQBKNylVo9Av4mhOtBj6hIhoXugTqeXtAiQmmXS+WcgHvVm4?=
 =?us-ascii?Q?GlmhOGZWR8e+B+Il08xs/LMWmIzlZUlnBzhZ1vwoTQMYZgrd9wmFLMscGKh4?=
 =?us-ascii?Q?a1bowrKnN03ty2vsqaGn8V8XoK8fTiDY1su2zjnONKSPXEHicKyV+bgmzB8X?=
 =?us-ascii?Q?kieX2HG9Uj1zTvW5h995fZx8HdMwMeSWI9UveRgRM0ZVYER1EIJeZt0W7w6Z?=
 =?us-ascii?Q?ESZi9RvFjtGk2XXpBSByxXWxXWsgmdc9kaehReemPPgqUIgOziQkN5o0bp3M?=
 =?us-ascii?Q?BfRkKhadMDtnzQiSerp5IR+Q9jr8YGN2L6xOXp/rRcHNr5wAz9SMunfJN3Sc?=
 =?us-ascii?Q?ceY94ce9K6KQWk82xPO+5yUvqi55/FzpCnjNsKXdWeF5F8r7c44UL7/NGg79?=
 =?us-ascii?Q?cyw+rUYPsn+3WuqbrmjJhCWYJwetu8pxgGntDJpa4yyp3RkaO+vezkksuPh2?=
 =?us-ascii?Q?CzWBJFkjh+hu8jsgjQBY+0fb09QKFObFsV0AeX0Yap17hS8Xldlc7e6pRxkM?=
 =?us-ascii?Q?OCsk0EY7I/EMFNluvMGCoGbgxg01U8I92wsqqVtCEtgdVb1jiPbcTrTAvpur?=
 =?us-ascii?Q?Og=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f79931b-c98c-4065-6f49-08dbd1738100
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 13:50:22.1579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qotizgfSI8gEGBhCyP5zgrDRRUkHJtGcvHsWuxWuEn9jJALTTA0agHJho5xOjPdkx6P9w5f1E8n/DOm1qkJhIs/96+g5vWORB39jzCB3bsk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6363
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is going to be a new user of the BYTES_PER_[K/M/G]BIT definition
besides possibly existing ones. Add them to the header.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
---
 include/linux/units.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/units.h b/include/linux/units.h
index 2793a41e73a2..ff1bd6b5f5b3 100644
--- a/include/linux/units.h
+++ b/include/linux/units.h
@@ -31,6 +31,10 @@
 #define MICROWATT_PER_MILLIWATT	1000UL
 #define MICROWATT_PER_WATT	1000000UL
 
+#define BYTES_PER_KBIT		(KILO / BITS_PER_BYTE)
+#define BYTES_PER_MBIT		(MEGA / BITS_PER_BYTE)
+#define BYTES_PER_GBIT		(GIGA / BITS_PER_BYTE)
+
 #define ABSOLUTE_ZERO_MILLICELSIUS -273150
 
 static inline long milli_kelvin_to_millicelsius(long t)
-- 
2.34.1

