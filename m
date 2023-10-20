Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E0CDCDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 13:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377395AbjJTNu1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 09:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377304AbjJTNu0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 09:50:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222BF19E
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 06:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697809824; x=1729345824;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=/QLsk07hupOFnt2EU0uu5DpSjIzm9FJOJmBO6Agsh1Q=;
  b=irfiiOiHFbsat7b0NFlBD/g0M4wKpVDDUhhecmQ3s2BYJ7JDllcSpkou
   HdHA/qjwNaZnQdM14KpCPjFBNKI2a+iIHLwUzjrTrpNlDLk7XxzMz5St/
   OS8e2DvAGM1AgmM2zF0Lc4+cZA8huNWpZlmWd6nhP+GzWiuVjKPk9BBce
   8FEUpBpW7ealcANe5COf2hyCRP1hHo5BmaP6OasmXz7cllnPONqRkSnB6
   1a2mqLdKi+aHl/pcd4mpx2bXykCSDS/X3ffDuwfUHKUGPiQ7xaaBTnU4o
   2khs9/gDV6utg1Kb9XIrEYvsPIqlUX/6m1MGMA5IG8V6e/59z80+fTILv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="450725539"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="450725539"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 06:50:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="761058801"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="761058801"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 06:50:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:22 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 06:50:22 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCHWYSwo5Cy2ZVwVVTF4XaCJsB+NBUdbMdSFjAg+J3FxPWLMSpo9XZ0rjfQ+NXBcKxZosr6jokssdVDx7/zFIkhm+PhE55OeWBwjjL2VxhNqI04fCDSIejvtFmfw6OKnr2UjWGi/NsEO/7Eg53eag5f6VwUNUcsiG/5j8enFrZjubHcSYCmHOotaq8tqle25SFiP1jb6V07JAPoEXUyQCo0kxw/lN1fsl9hjIZi45qs9oLMflrlyqWYvcU5jo0StiUEDWhAjbrzoeiJZ6lEv59joxuzy5BJZCJemiu0YuXuoZu4X+nYkda7qjJRWn3haqpWJ5O5eNmXOT80re8MU2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z6OMrKxBj6rwQmRmOUukfQqPSfIrYOWlsw63n9F9ABI=;
 b=GsSALBUoz6aDptfOrNA4/6WI/2x7/vnzd6cOG2Jj9oHdgoo3JM5Bw7mYvcW7bBTkaRHHRoinqIKbT+tEq3+mD/bot1WADMSqQuZ+24Guw56JFUHEXaTLR/PsbbMj5BWgtG0frssB7IJ5wPQsQwrEVFkqxQAWta/oVE0buiiJCt2+6hBYRuk1wv+YFxNe5dOGk9wMb7qIHGBjTdMT1QB5OnfS1pdNd3QtynprPuUrMkv3LETJHmtD/Gsq12vC/ywgwTN9RdednvZ+z8MqSapujVZlOU5tqy3FvHpuoAXYx0KaV3Iz50JCy217/z/Zyz9ABWltOnDvDEVHzNs0LvFyQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by BL3PR11MB6363.namprd11.prod.outlook.com (2603:10b6:208:3b6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Fri, 20 Oct
 2023 13:50:19 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9%4]) with mapi id 15.20.6863.032; Fri, 20 Oct 2023
 13:50:19 +0000
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>,
        Tero Kristo <tero.kristo@linux.intel.com>
Subject: [PATCH v2 04/11] crypto: qat - move admin api
Date:   Fri, 20 Oct 2023 15:49:24 +0200
Message-ID: <20231020134931.7530-5-damian.muszynski@intel.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2f662c58-a8ff-4d27-73ae-08dbd1737f79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R/mqfEPKIWFRVkiDtu668u/oI4rPkA5YYXsEVecc9R2llo+ZXkobr1KF5MeB/Jf82X3QJs/BosmbRsXTjy6vAodBVaBbiKmN3yS/un8BPckjgNvocPqW1oisSYNQ9hx8Nr3sM78sVg9abzAVHWs/smUK1Aqnu0384VFBGZbAGqFvUwgyRZre9ZGgpaAKAncieqA95cTORUD/9XHc/nHX5Bpe2WgIGIN3a5VO/ShfTbIC53JMZd7ohLf9RDzLt9Rwu77+XITjIxxkekH+vN+3w6rWjmi7EEGhS4tYrdVRTAKL5lwtXT1j+bGHkk8YwoEpRCiEmu0Kozy5H4/2F2rvtTtoTTkR8JLrDyTn5GNvIYbgaCXfnyInNDz/HAdA7kQoh1TRInbmxwQaohoWYx7BJQFv6aAFjieVJ6sjaO8MQjFsT83Bb6LkgUe1rSxi4KqbansTsTxgpeUDqZN/Ks8jw843A80lsVcfG3aP8hYLfJw0dDuUmuUTdyCK8eu9BzczWj6Y7W9YcGmQHO8L1CGetJEKBkcaGzt7g2iAEgUZmRdYOmh9zJYfJDWzGq90I6r3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(39860400002)(346002)(396003)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(66556008)(6666004)(54906003)(66476007)(478600001)(6916009)(83380400001)(6486002)(66946007)(6512007)(38100700002)(1076003)(41300700001)(26005)(36916002)(316002)(2616005)(6506007)(82960400001)(30864003)(36756003)(86362001)(8676002)(8936002)(44832011)(2906002)(5660300002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SuhfdH7jbJPajAkaxBKCsiTIyGQPIkqK2Gax5P4zrhRrvFXAAKScW8FcXjuL?=
 =?us-ascii?Q?wtjbhquM7nOuW0r5R895d7/+IhZ9z7oyZ+KxzQ6NgoV2mMXGdMo2UK/yVWcj?=
 =?us-ascii?Q?LHS3YkqyFw+WMlQZuszGizQUf50qq8snGA7UaWnIeV9kocB0utm5W4T65vGB?=
 =?us-ascii?Q?93Y6iGE7KUmP9JJgvMnKaG5mYzVgxuh9qJZ3IeGajL+kc1EJOx6Fy2ombtRs?=
 =?us-ascii?Q?2XK2SQlweU36POdlndVLIfmIq4SnCrpkIrkBnZab99u719kaMsFxhqxVWJW2?=
 =?us-ascii?Q?N6mhBPzse9vCCT5TBmmnTL6T1k/yUc6B0TzPwHaOixkJ7PBzlc8EvLdyM/yp?=
 =?us-ascii?Q?1F5byIU5HQwA/3/5atJsL/R6TlT0gS3bBV2PdEgSXFoqFjBzZCgsm9YBKB4v?=
 =?us-ascii?Q?xAwWCYpnw8RP9fTvJ4xP1yr4djFkiMz8/t/UbeqhGswYE/5rheEg05V32/UC?=
 =?us-ascii?Q?AFUlj/fzTUP5xrmuktrnFEcCPnXrcCC6law7YhNxaCXlJ45Mq0/sWAdJrTzw?=
 =?us-ascii?Q?xq5cyONaQ4Am+HALo7z9nhGWnyO2QTiv99ctIBrxYcP5MJzEgXzPt2TKU3Ol?=
 =?us-ascii?Q?n8ejuV0qQKWBl+Qr4qkiBX1hnWNvxi/Z82HbTex0a+kvCtHnSsC4DeATe8Ow?=
 =?us-ascii?Q?RgsslUZ39mLJUGPp69S8535/R6N3OUjo4d/rHBNE3uSX3r4hVDZwQxtuaHty?=
 =?us-ascii?Q?Au89tADEkr94DHf/IDZDExurotZYMMzVTWn9h7EMrVYXx/BD82gqeuJMGAi/?=
 =?us-ascii?Q?pLpVcwi9IfHdFirlC83cl3h+xk3wGESjEXHDAhz1CLmhuzsiuYPmq73XHG/8?=
 =?us-ascii?Q?XYooWewbrNvOlKnR4c6s0J+LjPVVXxNIyt6VMEnOJphMrF9/+MC9G468Ixi8?=
 =?us-ascii?Q?JE7C9S4xb7Wmu8zICTjkG9icXtvzaT817Pjp1o6mqRbZa5KllQYPkqQnvzIS?=
 =?us-ascii?Q?kJb1+zAr4ndxOUB8EYlhCWhCkkxKHjto7h47OvudtjRaREF5WLOYxzNWtlLr?=
 =?us-ascii?Q?tjL0ZmMQ7y9ip3QwAM2R8UPIpnm3D8Is/K+yzUpQoJDZ9X11AMypWTo205d6?=
 =?us-ascii?Q?+BinEdiZk/lWtibD0k1HJWilGzfhgMbjxFw5XGgNsc1MBaz1cmozSq0lwmiH?=
 =?us-ascii?Q?9D+9bLS2UdYLw/DNaI8Ewi3lynU03ayLIZ5StBPxZmzTm8GSC/o8Vqj1L49p?=
 =?us-ascii?Q?xB9lZFHyHZa1XKCkJodGfQ5VNzsowuu9AFqwm1Y3djUhI1d6VY7R/c1jA5aJ?=
 =?us-ascii?Q?Z7YmQDYjC6Rfgdlov7LWlw0aWfEcTCXkN0MSUhqKzyLXzdXNSHdp0yu2sLs/?=
 =?us-ascii?Q?xB3KAsltIZOVnd2zJUcBhMtxOHq+UeIxJqkoGYAuHmeldMrE4BDGfbLEfKsn?=
 =?us-ascii?Q?fKWU9C2JpAFpopctp56XydXuCVbjshs4x1d8RlGD+H/wHvcP3OveqenesE9v?=
 =?us-ascii?Q?vcLspkoepdJvmCdeIucXtvqH4QzxNTj3LdIiCMFlx8E7PVhDbDT1U2yhP6Hf?=
 =?us-ascii?Q?25DJjbYZObWJ8M3A0+Z5IOqnFNmWngDx+R/hQp34WvnNN9RabvRS5ol3LDyX?=
 =?us-ascii?Q?RWoR++n7naUiNGMn6/9NTBPt+jqp2IVPHl/jQkpoeuNZmA23mX7CZDafzVbI?=
 =?us-ascii?Q?Tw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f662c58-a8ff-4d27-73ae-08dbd1737f79
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 13:50:19.4718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f4gAMzpJ0wG0bH11XufSN/cywj7lgRZTCgR6bOfn8B3TBvZSePkeLN4fnQrqqq8cmaSHceZGDCCP38BOOUzgygvDgqb3pnemJXMFe408NcE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6363
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

The admin API is growing and deserves its own include.
Move it from adf_common_drv.h to adf_admin.h.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  1 +
 .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |  1 +
 .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |  1 +
 .../crypto/intel/qat/qat_common/adf_admin.c   |  1 +
 .../crypto/intel/qat/qat_common/adf_admin.h   | 19 +++++++++++++++++++
 .../crypto/intel/qat/qat_common/adf_clock.c   |  1 +
 .../intel/qat/qat_common/adf_cnv_dbgfs.c      |  1 +
 .../intel/qat/qat_common/adf_common_drv.h     | 10 ----------
 .../intel/qat/qat_common/adf_fw_counters.c    |  1 +
 .../crypto/intel/qat/qat_common/adf_gen4_pm.c |  1 +
 .../qat/qat_common/adf_gen4_pm_debugfs.c      |  1 +
 .../intel/qat/qat_common/adf_gen4_timer.c     |  1 +
 .../intel/qat/qat_common/adf_heartbeat.c      |  1 +
 .../qat/qat_common/adf_heartbeat_dbgfs.c      |  1 +
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |  1 +
 15 files changed, 32 insertions(+), 10 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_admin.h

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 37bb2b3618cd..ea47a05e12ed 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2020 - 2021 Intel Corporation */
 #include <linux/iopoll.h>
 #include <adf_accel_devices.h>
+#include <adf_admin.h>
 #include <adf_cfg.h>
 #include <adf_clock.h>
 #include <adf_common_drv.h>
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 9c00c441b602..a882e0ea2279 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2014 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
+#include <adf_admin.h>
 #include <adf_clock.h>
 #include <adf_common_drv.h>
 #include <adf_gen2_config.h>
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
index 355a781693eb..48cf3eb7c734 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2014 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
+#include <adf_admin.h>
 #include <adf_clock.h>
 #include <adf_common_drv.h>
 #include <adf_gen2_config.h>
diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.c b/drivers/crypto/intel/qat/qat_common/adf_admin.c
index 3a04e743497f..15ffda582334 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.c
@@ -7,6 +7,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include "adf_accel_devices.h"
+#include "adf_admin.h"
 #include "adf_common_drv.h"
 #include "adf_cfg.h"
 #include "adf_heartbeat.h"
diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.h b/drivers/crypto/intel/qat/qat_common/adf_admin.h
new file mode 100644
index 000000000000..03507ec3a51d
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Intel Corporation */
+#ifndef ADF_ADMIN
+#define ADF_ADMIN
+
+struct adf_accel_dev;
+
+int adf_init_admin_comms(struct adf_accel_dev *accel_dev);
+void adf_exit_admin_comms(struct adf_accel_dev *accel_dev);
+int adf_send_admin_init(struct adf_accel_dev *accel_dev);
+int adf_get_ae_fw_counters(struct adf_accel_dev *accel_dev, u16 ae, u64 *reqs, u64 *resps);
+int adf_init_admin_pm(struct adf_accel_dev *accel_dev, u32 idle_delay);
+int adf_send_admin_tim_sync(struct adf_accel_dev *accel_dev, u32 cnt);
+int adf_send_admin_hb_timer(struct adf_accel_dev *accel_dev, uint32_t ticks);
+int adf_get_fw_timestamp(struct adf_accel_dev *accel_dev, u64 *timestamp);
+int adf_get_pm_info(struct adf_accel_dev *accel_dev, dma_addr_t p_state_addr, size_t buff_size);
+int adf_get_cnv_stats(struct adf_accel_dev *accel_dev, u16 ae, u16 *err_cnt, u16 *latest_err);
+
+#endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_clock.c b/drivers/crypto/intel/qat/qat_common/adf_clock.c
index dc0778691eb0..01e0a389e462 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_clock.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_clock.c
@@ -10,6 +10,7 @@
 #include <linux/types.h>
 #include <linux/units.h>
 #include <asm/errno.h>
+#include "adf_admin.h"
 #include "adf_accel_devices.h"
 #include "adf_clock.h"
 #include "adf_common_drv.h"
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c b/drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c
index aa5b6ff1dfb4..07119c487da0 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c
@@ -6,6 +6,7 @@
 #include <linux/kernel.h>
 
 #include "adf_accel_devices.h"
+#include "adf_admin.h"
 #include "adf_common_drv.h"
 #include "adf_cnv_dbgfs.h"
 #include "qat_compression.h"
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index d9342634f9c1..f06188033a93 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -87,16 +87,6 @@ void adf_reset_flr(struct adf_accel_dev *accel_dev);
 void adf_dev_restore(struct adf_accel_dev *accel_dev);
 int adf_init_aer(void);
 void adf_exit_aer(void);
-int adf_init_admin_comms(struct adf_accel_dev *accel_dev);
-void adf_exit_admin_comms(struct adf_accel_dev *accel_dev);
-int adf_send_admin_init(struct adf_accel_dev *accel_dev);
-int adf_get_ae_fw_counters(struct adf_accel_dev *accel_dev, u16 ae, u64 *reqs, u64 *resps);
-int adf_init_admin_pm(struct adf_accel_dev *accel_dev, u32 idle_delay);
-int adf_send_admin_tim_sync(struct adf_accel_dev *accel_dev, u32 cnt);
-int adf_send_admin_hb_timer(struct adf_accel_dev *accel_dev, uint32_t ticks);
-int adf_get_fw_timestamp(struct adf_accel_dev *accel_dev, u64 *timestamp);
-int adf_get_pm_info(struct adf_accel_dev *accel_dev, dma_addr_t p_state_addr, size_t buff_size);
-int adf_get_cnv_stats(struct adf_accel_dev *accel_dev, u16 ae, u16 *err_cnt, u16 *latest_err);
 int adf_init_arb(struct adf_accel_dev *accel_dev);
 void adf_exit_arb(struct adf_accel_dev *accel_dev);
 void adf_update_ring_arb(struct adf_etr_ring_data *ring);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_fw_counters.c b/drivers/crypto/intel/qat/qat_common/adf_fw_counters.c
index 6abe4736eab8..98fb7ccfed9f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_fw_counters.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_fw_counters.c
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 
 #include "adf_accel_devices.h"
+#include "adf_admin.h"
 #include "adf_common_drv.h"
 #include "adf_fw_counters.h"
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
index c663d3a20c5b..5dafd9a270db 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
@@ -5,6 +5,7 @@
 #include <linux/kernel.h>
 
 #include "adf_accel_devices.h"
+#include "adf_admin.h"
 #include "adf_common_drv.h"
 #include "adf_gen4_pm.h"
 #include "adf_cfg_strings.h"
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
index 5114759287c6..ee0b5079de3e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
@@ -6,6 +6,7 @@
 #include <linux/stringify.h>
 
 #include "adf_accel_devices.h"
+#include "adf_admin.h"
 #include "adf_common_drv.h"
 #include "adf_gen4_pm.h"
 #include "icp_qat_fw_init_admin.h"
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c
index 646c57922fcd..35ccb91d6ec1 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
+#include "adf_admin.h"
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_gen4_timer.h"
diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
index beef9a5f6c75..13f48d2f6da8 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <asm/errno.h>
 #include "adf_accel_devices.h"
+#include "adf_admin.h"
 #include "adf_cfg.h"
 #include "adf_cfg_strings.h"
 #include "adf_clock.h"
diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c b/drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c
index 803cbfd838f0..2661af6a2ef6 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/kstrtox.h>
 #include <linux/types.h>
+#include "adf_admin.h"
 #include "adf_cfg.h"
 #include "adf_common_drv.h"
 #include "adf_heartbeat.h"
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 09551f949126..af14090cc4be 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2014 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
+#include <adf_admin.h>
 #include <adf_common_drv.h>
 #include <adf_gen2_config.h>
 #include <adf_gen2_dc.h>
-- 
2.34.1

