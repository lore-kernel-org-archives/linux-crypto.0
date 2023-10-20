Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC756C001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 13:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377481AbjJTNuT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 09:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377304AbjJTNuS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 09:50:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32721D4C
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 06:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697809816; x=1729345816;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=xfWZrcLhOyBWr6bw+0L6MFZ1c4l2R/4V4LyEPE9NcZ0=;
  b=RJa5nu9gh4BAxQYRG8jXm9Gj5ZBx3RL7c3c0YXvfZx0xi5OvEYbZ7Str
   ZfP/6MOHROsjNWCMvvkBa4GJ2hRATUL/23P9umaxxRyoN4PapIfHaBvL5
   +bCDgbgIwpAA12nWf4QC2eJnVYdSa/Q3Sy9+lcQne2evGjXhB1Oid6KmW
   3hRo7FRWmQ1aaXTJQTKPfoImwxwyF74kBo4eVWzibQfpjYJyalgcoqRBy
   7aGiyv4oPWqHmsRA0+Gabd+AEQHefZOExGEPIRqKj8nA88vzUi6pfyqQS
   RjtVw9p4GifelsrYYR8qXKfKPMUPwAay5m/nqu+odt4n+aA5gc1F+seG7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="452976858"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="452976858"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 06:50:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="733967936"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="733967936"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 06:50:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 06:50:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WhWkygUsro0li/eKA2G3rRzioOUvw1jk9lsDigsi5K0MP16Xuf70b6rfuGgMaEvwG+eWEaRkK9nZJVBIrb2q8Y3AmKYh+/sFQXzKb2kVywxnGLZ0xEyoBldu29TG5RDkQ/R8vqTnINXCLHhUGWRnDqGy72YW2KrzMacQYyVV5nWa/AjeQyhtDuKsO4kVH/7B8W4rSjtk9AhwNQVy54QvAD4IP7P1eP5aQGLwythVXpZCE1A0W5crDboIFPn04u/365lBUK+/IoQ+cCBbiyPUMkPsisNwyIoFVuzbg5mzwSdabF9Wb998/6+TlKf1Ilq9DzyIZriLmBchZAn+7yu5DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mHVbZKL7CMxwWhzI1BI44BBWb2hNxp7szSiDofCTjdY=;
 b=FlpApG9euULHoccnDNJ9LPbv5rljJaqkbr3KmEbIEboL3/dc8ZBkDNLIstlnHZQw6VNfyXLktEikL3NGntYc6JLq0T7hkpfgCQqOYdej14F7sJZYi8vdBDlUE2cZZYQCFP/DDjZP7VYQkWlTrmOwk04KSzjj/XvFVyVbjXEitEOFKYSCNDJ1SoazyH2mTVBq8OYu+EMJcGJjBWQfO7DBQE9EgLPc0EvnOVprbxeGE0qUO+/kpQEQIqB8QY7e7MI5jjYV3kwuPeMdlZaT7wzFdhWCE3bshqz6X2eYFGQfI8qF5lJc4hklzSyC9VCAtAXXgh5pIhqMh7Kbdbh+IAZ+gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by PH7PR11MB8035.namprd11.prod.outlook.com (2603:10b6:510:245::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.24; Fri, 20 Oct
 2023 13:50:10 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9%4]) with mapi id 15.20.6863.032; Fri, 20 Oct 2023
 13:50:10 +0000
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>,
        Tero Kristo <tero.kristo@linux.intel.com>
Subject: [PATCH v2 01/11] crypto: qat - refactor fw config related functions
Date:   Fri, 20 Oct 2023 15:49:21 +0200
Message-ID: <20231020134931.7530-2-damian.muszynski@intel.com>
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
X-MS-Office365-Filtering-Correlation-Id: 97717cff-49e7-416d-3e51-08dbd1737a1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6kKCe6qU5LdGK1oAuKwfgNwup5HW9U/Yo2AfusnfL59wgp7+tgz60yJqBNEDNa1bUCLtHEzwQ1XgFbfDuFujvD0mC5DkbnIIEG6JBeNEjwRFrMxzfRdfEG85rw9dhzByUYYJgyiT3vIUMyV2++9Uj0xD3xSzdvTbCMAcUfqktLrNK127qd/HT+Luk+D9swTD+BuQ9k5Rao4Nn7bykqETsRHH5XD5CCJk+urvzYR+PoOYMATeL46pt0450BRaQg11YJ+8d/5sN093PhUMqjTLIpkdaoRRCvZTyOf97SQEYBp2bnp42DJ1YxrG8j+J9Kd4uqKNSvr1lZpor4PCLaP5GGs/3etJ0yAxtoG9vPtTYkoLLW9sB5MuRXbdnsvCYr40W06oMUy82yUyIRNds7mifbk1allVgN66AHRheSHxbHlcvxLPWwE7xC16zS1NtK9PaVbuY2ZBwS8DeUL01qyqcVNss/irI3ybZmjfloGXGocmarodPbPeBTUW+B25n2VlzJzyVY+sRaXY9B0ZZPnOTADrwd+qWVpFyql4RM+QjCeDIxG5JH0kGDfWv28cek8k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(366004)(376002)(136003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(83380400001)(54906003)(38100700002)(6916009)(66476007)(41300700001)(6512007)(36756003)(2616005)(1076003)(86362001)(44832011)(2906002)(4326008)(66946007)(5660300002)(8676002)(8936002)(6666004)(36916002)(316002)(66556008)(6506007)(6486002)(478600001)(26005)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K1xib+SBKTvM7hE2goBAIrmIk4FIicU2+e0FnVgHKJ5fQ6r/ue1dFOS8ZgFn?=
 =?us-ascii?Q?aJOfUuEDgCSOC3urwbsGk8gz3PbpRjhbhrkoDHUlpSMBd42TVVp35N5gt3X6?=
 =?us-ascii?Q?1Fh/11nXOQCr6doYgxoaRsabci2kXGrswU4ugRl3KFIAzNLdFn1h7cFuRKoj?=
 =?us-ascii?Q?aJJquy80mza6hAAAhy4JYNhuddtdfStX+daObUIGiAvG+lgsTOpPuFxvOC4T?=
 =?us-ascii?Q?qOhmnVKfan3Yaaz0mJxXPsGNdLkFUwf5KD6IglSLnPFrWbeTy2BzJ0X2iVOk?=
 =?us-ascii?Q?F3ysbyZtrYHJmWKLS+WE3Caf1K48gx9zYPRTyy3gRv6NBYn5yWkL+1+KJNJw?=
 =?us-ascii?Q?ILohs5InJ+8XwoU1hvK80i5b7DwBJYa1//nCHP/9i1tBPirRhsRT7DKOBe6w?=
 =?us-ascii?Q?A60Cezrtx2qIWNivG0RAf1TpUOyXAUuRNWExMLdDXE2sDvfE6VF5gROvPz+E?=
 =?us-ascii?Q?EuRthJI7gHwT+UymUZvo0TJWLOytQDbanQz/FYdkMcT4Ig1acogFTi1cdvqj?=
 =?us-ascii?Q?wmHTneG7Pl6zMyqPr1InGL6axU8VXpH0oAMnthOKXSw9lHFt7AtccI/GI/DW?=
 =?us-ascii?Q?uljkhn51SYBJk8oDwrJf4DY9qNqNCywCQQ69SZgDl2+01t408m18vF5SnOFR?=
 =?us-ascii?Q?RylbZZXwQMD9Xw560m/Pg3pPyezIq2vFzTkf6B/XUmolL5tMNrMcaag2ZNFL?=
 =?us-ascii?Q?OfYteOwM6UZCVuqu0RJa0XFzuU5Jes4Riomt7KyFPmnpKoGWMgxfa5tuYwXN?=
 =?us-ascii?Q?MiVMDM+8G7vyDquVZy0gObLrr6ibBLKyJ9PhUxvPLCtcBPaOa2HPXUm37Ez3?=
 =?us-ascii?Q?BTdnmzCRokgOMEe1w52oDjvCCwmdUqb/cBVzWpdgRvdNPSlWKQa+SYKNdqvf?=
 =?us-ascii?Q?ZzG5kQgALdXxe18oRhVRjFu+kI5ft02f9KhvTYk8kymlQxg+k2c5vT2/17F+?=
 =?us-ascii?Q?9EiCKTG+SfvyBzRGyHowFPQ5+zQ1hxzELRs2j75iOPdrDAqGGP1EjG/SsRLV?=
 =?us-ascii?Q?Whz5oIeU4Vtw43CFUnv3v9H9+QSFmEKrnmPsD2lHMYxbWTIILlR4sNxThtv6?=
 =?us-ascii?Q?ZvRP17OFNvoEQ8qa/rdjUJ8fpO/KzPH13VA01Yk5zmvGSatpcZRQIIWauEVw?=
 =?us-ascii?Q?SdhbTWpEsSlN9kf19rVGejZ2WPSDrW6iD4reeWvZB9Oee/uVDbAecoaBVQ7c?=
 =?us-ascii?Q?d/JMGeXqdZ3ub4anHrK/cbN7jzvI2jAtWfmGpD6d7gYagCD9Xlz1TG5o5vIZ?=
 =?us-ascii?Q?ogo8pMA62IANt6GbJ6MWAtIGTB0+ogzpZ5eeGqVdJLLM3map1m6E2d3bDCt7?=
 =?us-ascii?Q?joqXAsjT/C4o1EmBn9fbfoyQfn1jpWyGKnj0/jOdPk7czzolDpsOEMukZnEF?=
 =?us-ascii?Q?N/yDUr0t5Dfu2MmowEZFSmVHhw/X4iv/UHMgebxX1IV31y1Zp8iiaTMIf0/z?=
 =?us-ascii?Q?Ci+kAYgpO0/55H0WRvFyUK55aqe1PO1cOvfp4HphJ44mMbrO5Wz+83whmB+Z?=
 =?us-ascii?Q?/FKJcD1nVnbj4ZCYBls7fzbn1gkarUHYvwzTAvYXfvd0eT0GTdgapTxp9QT6?=
 =?us-ascii?Q?wPM1Q4+R8QEI4x2Rvx38br7I1YjPHVCPDIoI6/TwB1YdWJD8toeDk1lnhXr2?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97717cff-49e7-416d-3e51-08dbd1737a1c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 13:50:10.5162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xPLUwkPMDatqzptu/Q2ey4ci2U3CROS8pXT7cMFU9zVOaTWuAc7Btlwid+01pbycIMq8MpKDIXPEFBI3iCGDJTQzvQMG2DpV3wnYe4OpWUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8035
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

The logic that selects the correct adf_fw_config structure based on the
configured service is replicated twice in the uof_get_name() and
uof_get_ae_mask() functions. Refactor the code so that there is no
replication.

This does not introduce any functional change.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 69 ++++++++-----------
 1 file changed, 28 insertions(+), 41 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 51db004641bf..3ea4bfc91bfe 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -395,40 +395,42 @@ static u32 uof_get_num_objs(void)
 	return ARRAY_SIZE(adf_fw_cy_config);
 }
 
-static const char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num,
-				const char * const fw_objs[], int num_objs)
+static const struct adf_fw_config *get_fw_config(struct adf_accel_dev *accel_dev)
 {
-	int id;
-
 	switch (get_service_enabled(accel_dev)) {
 	case SVC_CY:
 	case SVC_CY2:
-		id = adf_fw_cy_config[obj_num].obj;
-		break;
+		return adf_fw_cy_config;
 	case SVC_DC:
-		id = adf_fw_dc_config[obj_num].obj;
-		break;
+		return adf_fw_dc_config;
 	case SVC_DCC:
-		id = adf_fw_dcc_config[obj_num].obj;
-		break;
+		return adf_fw_dcc_config;
 	case SVC_SYM:
-		id = adf_fw_sym_config[obj_num].obj;
-		break;
+		return adf_fw_sym_config;
 	case SVC_ASYM:
-		id =  adf_fw_asym_config[obj_num].obj;
-		break;
+		return adf_fw_asym_config;
 	case SVC_ASYM_DC:
 	case SVC_DC_ASYM:
-		id = adf_fw_asym_dc_config[obj_num].obj;
-		break;
+		return adf_fw_asym_dc_config;
 	case SVC_SYM_DC:
 	case SVC_DC_SYM:
-		id = adf_fw_sym_dc_config[obj_num].obj;
-		break;
+		return adf_fw_sym_dc_config;
 	default:
-		id = -EINVAL;
-		break;
+		return NULL;
 	}
+}
+
+static const char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num,
+				const char * const fw_objs[], int num_objs)
+{
+	const struct adf_fw_config *fw_config;
+	int id;
+
+	fw_config = get_fw_config(accel_dev);
+	if (fw_config)
+		id = fw_config[obj_num].obj;
+	else
+		id = -EINVAL;
 
 	if (id < 0 || id > num_objs)
 		return NULL;
@@ -452,28 +454,13 @@ static const char *uof_get_name_402xx(struct adf_accel_dev *accel_dev, u32 obj_n
 
 static u32 uof_get_ae_mask(struct adf_accel_dev *accel_dev, u32 obj_num)
 {
-	switch (get_service_enabled(accel_dev)) {
-	case SVC_CY:
-		return adf_fw_cy_config[obj_num].ae_mask;
-	case SVC_DC:
-		return adf_fw_dc_config[obj_num].ae_mask;
-	case SVC_DCC:
-		return adf_fw_dcc_config[obj_num].ae_mask;
-	case SVC_CY2:
-		return adf_fw_cy_config[obj_num].ae_mask;
-	case SVC_SYM:
-		return adf_fw_sym_config[obj_num].ae_mask;
-	case SVC_ASYM:
-		return adf_fw_asym_config[obj_num].ae_mask;
-	case SVC_ASYM_DC:
-	case SVC_DC_ASYM:
-		return adf_fw_asym_dc_config[obj_num].ae_mask;
-	case SVC_SYM_DC:
-	case SVC_DC_SYM:
-		return adf_fw_sym_dc_config[obj_num].ae_mask;
-	default:
+	const struct adf_fw_config *fw_config;
+
+	fw_config = get_fw_config(accel_dev);
+	if (!fw_config)
 		return 0;
-	}
+
+	return fw_config[obj_num].ae_mask;
 }
 
 static void adf_gen4_set_err_mask(struct adf_dev_err_mask *dev_err_mask)
-- 
2.34.1

