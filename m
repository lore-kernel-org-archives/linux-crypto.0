Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9B1CDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 13:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377482AbjJTNul (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 09:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377423AbjJTNuh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 09:50:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364CFCA
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 06:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697809835; x=1729345835;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=qu1nOuYeuKn+4XVQacCqHy9yrfjMsytpjUlu4U+wmlI=;
  b=OKvSPcuWTQnnRoT4sUTNxHNEIU+aZooByq8IbsVLzPSPtQKnvJuxcYNV
   V3TsLYIr4YkYjG7tua0RQcte0ixfTXIQ896ZyC0/Pj9sM5T84vcE8Bs3F
   f9d+6HWX4ykPoHy6sNrwhyYb7Q9Ue83GIYtAkChVGsPmhiir+qF9oqQ9D
   k7eT1R6zJA10WH1t/ATTNsM6QnXg8jGyMpq8IriQcL/MKLHQYywbLaGF/
   jQhtuZVYVReRe9ex9JS14TE5DDpRiebrEpWrNBdVXViX2+a7hzJRk7lVD
   rZtAriu+YJ2XQdxOSR+LHYjpfg3Z3xruKWXf8gmitHg5dD2ldeKp7v9Qz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="365836088"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="365836088"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 06:50:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="1088748579"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="1088748579"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 06:50:34 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:33 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 06:50:33 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oexSWSGSdyV6wVKNxZl0d7gmMLtsNHu5nRuyDY28kpa1RSPKbGrsUiDcNdLuK8wYaF8wqW+Ff6sFfxT0gRW24ci/HwxszJKDwrjQAUo3nfOcusOItm3KWQs6igwkRt3gwrHoQ32y8erdVqPrKZDhPpJZJq1q4r/DWAWGxc0R3qvHpFWKQYXv5VQIOXZiRkaCr9y3Tu+aE497HTOZikkbwGEL1vND3VoOhb9cC49vG/R52uis4fkX/TUDWzMwgYaZWOO4EMkjLs4NrwZxGb2b+Z6jQDKP4iyb5JSR4rZGaPrOJUF8Wu0xL6wAvedgCdTri66V30Hx+Ls2piDMDBvrlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CfYcXvh7mRZL3MQDv53VOIJ/d5Hv1tN4NH+hHr9YeJM=;
 b=bo2bqyswXK/pQs1GAcrOv7hXWhq/ZQB3D06eVt9Jd8GbpW05qGE2E0Mlgb9LVt67f+af0LeAiW0zQiuGg+Cyhc/26oRFgXJQGTKv84utUbNDsDRFhjSPjxH7xSQW9g8WdhIA5/A0a3DfjfPzRCVUZYC6IZD4ORQxyYPwDRLm7sn3VzbtVivFti02iB0UhO/SnmosmQKHjXG/3Ff9lK13hy3r2YrCwEb6N9NREElwqRUK3kbt/SkQzTAqhu35YlggxldOk36Lx3QQyDkVP3dmw8aaM2z53AX5l6CO1ZB2KMBn0m7WWM2ntbatbqvrlae6oh3sYkHwkvHB2ze3t1JY1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by BL3PR11MB6363.namprd11.prod.outlook.com (2603:10b6:208:3b6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Fri, 20 Oct
 2023 13:50:27 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9%4]) with mapi id 15.20.6863.032; Fri, 20 Oct 2023
 13:50:27 +0000
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Tero Kristo <tero.kristo@linux.intel.com>
Subject: [PATCH v2 07/11] crypto: qat - add retrieval of fw capabilities
Date:   Fri, 20 Oct 2023 15:49:27 +0200
Message-ID: <20231020134931.7530-8-damian.muszynski@intel.com>
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
X-MS-Office365-Filtering-Correlation-Id: d4905fe0-11c0-46c7-2b0d-08dbd1738413
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sw28Z60fP55yLcZma99Ymptd1gqvcwN9Fb6oU00Gq9PHU2tsZxX2o4JnQWJ86rQTwV6CnTuJTFDHQJPasFiCxUK2lFdFP3kAenDlwSZZgQtjRl9ly2c927D+K41B+QNjN8duggO33epgpP2weJRCiZO/KtQeVd/QOyZuJRp5uVwTCv0wMJWFcmnGgMSGfIRMvM17SoN3jgs4+X6OqvPeV/oiYxtoY8yMzg3c3K1fBS2YLQxZTPtcrqNyOI3DvIbxMky8dTmjPz6wphfa4PUBtvPb1DrkA9n/kw/t1KIGuGlg2WIu08B5EQmnBZDBxc8LTA83TX/z2U+AKm+RfIORNWnEHrkIjR2zildT0jGhxDpJbIc4Ejw5zNzUG/RYWCCxCZVplrex8ntHqz2uI3GBWLWqdnUoeTI05/U+LTsDsWeKvqa+O2YC28T0g2dUticso4okOumpRz997ZZWG1T3TEpX0ocL2IO5gKMABcxJ0Ri3mGolzodZis8WxdxwOoWinQTwlnwjfA2V4lD3jc9zvHOiT3CMFarPhZcsaa/Wz6A/eyF5Jjmz8wLazkCQnY3R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(39860400002)(346002)(396003)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(66556008)(54906003)(66476007)(478600001)(6916009)(83380400001)(6486002)(66946007)(6512007)(38100700002)(1076003)(41300700001)(26005)(36916002)(316002)(2616005)(6506007)(82960400001)(36756003)(86362001)(8676002)(8936002)(44832011)(2906002)(5660300002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hr1kHL1aqHdRiFqmcbH8gZZBmT6/xrfJ+areQxkqL+TjbE/15SBJs/64znmY?=
 =?us-ascii?Q?53mSavGfTo5XmRXslWGKrazMe8hsWwBb4h6oL5+0KjSxvn36XGaw+8IoTpy4?=
 =?us-ascii?Q?VDtYoYDuSoCy+uGSlLII8n7a9NlAaEfSk2DNWa09jnPZTehMBcBzznGwmtJr?=
 =?us-ascii?Q?PAyxCMGkjTrHm1nU1zuBuHDGjNnlnLblYEs4MW9SVQTsg2GT67kp6nkFzpX0?=
 =?us-ascii?Q?BW+uM10qTSRY7dRB1gFrQ31xnkyhVAZQjKVvjMUTMRKdJovisjae3UVO7kVi?=
 =?us-ascii?Q?NNChxMgSkmKBO054RF4bX32Wtji6KNWFFSKNlRaKT+tATLYhwBcr0RkRrK5d?=
 =?us-ascii?Q?vhgOa+qfqZAfrEDsLNOW7VBpbdHRfE86Qj70ZLS1aYgaTnRnJACA831h5/RW?=
 =?us-ascii?Q?NKDogiNZvpJiKfHsXn124lpgLbUV7GyqmOLZNd3W/T/1E+5wMHnrZH+vlRJ+?=
 =?us-ascii?Q?9l/IngMMqfwUsmKyjrF45oZD0Dv5UeUox86hajsfPfup66PG2zW1d2gkOGr9?=
 =?us-ascii?Q?XiixS6UWHDa4pz3hmk0jK5MIkjFN5EYvDogMWFMyRmYUpCjMRZzEHv2amO4T?=
 =?us-ascii?Q?pFhf90pSesMmAJ9CWbO+S4emSQjCY+aEFo+RZr7qft6YDVvRdRDkBsgFcZbC?=
 =?us-ascii?Q?7612hXzN+sN1kFG5zRrEdf4hJoeVs8av51DWH/z467o1jE+uVGj7genxHTij?=
 =?us-ascii?Q?A0BoeryzWIhtPDdV15tYWwWUtzv7C5y0KhE4+Cq2ecgsZ41lURLQoOIXsI5b?=
 =?us-ascii?Q?pMbcCbsYous4pLdl0qidHOtUIPpLU0s41Tv65/XZM/ugbXh6V2Rya9Toq0uv?=
 =?us-ascii?Q?od8/s7E4MlANBPx+ohd5xIijPBfaIgXRpErIFwpWaAAA1AScBSaCZhtE2j2l?=
 =?us-ascii?Q?NzNeH4DM+1zjuhiBZDW2v+A2Q+TfZtMfck5C+S5uocRH+y99qvtdwwmywDVn?=
 =?us-ascii?Q?t/Q6YNLC6R/jFUzbLbZFKWVfMc/OSNDUAdwBigF+Yrf6UTdEB/igVfMT00sz?=
 =?us-ascii?Q?Gp+z6zsO9NFm08IhNZpBaKNAcu51zwwXtCC2222OOCXs+Tdsp/JkytEZrCPI?=
 =?us-ascii?Q?ahgzcY/K4sVwp3VWoO6TTi2MdN/1MOQI1XAMyXLbDF/XWHNXrmBw5bQvqKFg?=
 =?us-ascii?Q?9aQXOzIzJI41tNF5sVrDs1z24VbeDqb3MM4nbe5mpS+eoSp6JAwbJkUungb2?=
 =?us-ascii?Q?dQXPw/nrvNRiN8dsv38QYEMRUFnjQRP833VcNBAPHfCHAOUmzJzLQ/JCqCVp?=
 =?us-ascii?Q?55NDpEDkE4aciwmlMAvtd1ImIKCzun/zCFzXlxa7kSdoTZuU2PwZ8zDlPjjd?=
 =?us-ascii?Q?VeApgPDS8DC3ji1/VB2celscULSgnuMVFKtsuAbzMqYcB3MwNBkdR6QIhQRU?=
 =?us-ascii?Q?8r0C4Xk/qsFcwof7XbMAck8+4B/3hNBSsWgvjBt9d2oSpDrxRhgOamlnJPmN?=
 =?us-ascii?Q?wTIUQFrWZaLHSJzpyt8aC436KGTpy/5Zq3lN01kevZ+/Rl1DrMZeXy3VA87a?=
 =?us-ascii?Q?gu/2N9H7VSRq8HayaidvsDJPKIOjdHsfSUBcly6XV/2VPcyQcinvIHsGUZdp?=
 =?us-ascii?Q?xyXSN25ABZ34sDjSjJ54VW1YP7xsyvkP3skHLDImSBQFU20T3B2TLdM8oGI6?=
 =?us-ascii?Q?LA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d4905fe0-11c0-46c7-2b0d-08dbd1738413
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 13:50:27.1546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXdsXibqiS/3mxM/VID9Zxn8dtdPgzH/T3zeK8UakmTHz+ZxIDsZWbP+rgxSTX5uEfmbiSR6CiCcimaw+cZg2jG6VIvdq6yGNB8vaEjvZp8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6363
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The QAT firmware provides a mechanism to retrieve its capabilities
through the init admin interface.

Add logic to retrieve the firmware capability mask from the firmware
through the init/admin channel. This mask reports if the
power management, telemetry and rate limiting features are supported.

The fw capabilities are stored in the accel_dev structure and are used
to detect if a certain feature is supported by the firmware loaded
in the device.

This is supported only by devices which have an admin AE.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
---
 .../intel/qat/qat_common/adf_accel_devices.h  |  1 +
 .../crypto/intel/qat/qat_common/adf_admin.c   | 23 +++++++++++++++++++
 .../qat/qat_common/icp_qat_fw_init_admin.h    |  3 +++
 3 files changed, 27 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 1c11d90bd9f3..908959288ce5 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -253,6 +253,7 @@ struct adf_hw_device_data {
 	u32 straps;
 	u32 accel_capabilities_mask;
 	u32 extended_dc_capabilities;
+	u16 fw_capabilities;
 	u32 clock_frequency;
 	u32 instance_id;
 	u16 accel_mask;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.c b/drivers/crypto/intel/qat/qat_common/adf_admin.c
index 15ffda582334..50e054ba2c33 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.c
@@ -310,6 +310,26 @@ static bool is_dcc_enabled(struct adf_accel_dev *accel_dev)
 	return !strcmp(services, "dcc");
 }
 
+static int adf_get_fw_capabilities(struct adf_accel_dev *accel_dev, u16 *caps)
+{
+	u32 ae_mask = accel_dev->hw_device->admin_ae_mask;
+	struct icp_qat_fw_init_admin_resp resp = { };
+	struct icp_qat_fw_init_admin_req req = { };
+	int ret;
+
+	if (!ae_mask)
+		return 0;
+
+	req.cmd_id = ICP_QAT_FW_CAPABILITIES_GET;
+	ret = adf_send_admin(accel_dev, &req, &resp, ae_mask);
+	if (ret)
+		return ret;
+
+	*caps = resp.fw_capabilities;
+
+	return 0;
+}
+
 /**
  * adf_send_admin_init() - Function sends init message to FW
  * @accel_dev: Pointer to acceleration device.
@@ -320,6 +340,7 @@ static bool is_dcc_enabled(struct adf_accel_dev *accel_dev)
  */
 int adf_send_admin_init(struct adf_accel_dev *accel_dev)
 {
+	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
 	u32 dc_capabilities = 0;
 	int ret;
 
@@ -340,6 +361,8 @@ int adf_send_admin_init(struct adf_accel_dev *accel_dev)
 	}
 	accel_dev->hw_device->extended_dc_capabilities = dc_capabilities;
 
+	adf_get_fw_capabilities(accel_dev, &hw_data->fw_capabilities);
+
 	return adf_init_ae(accel_dev);
 }
 EXPORT_SYMBOL_GPL(adf_send_admin_init);
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
index 9e5ce419d875..e4de9a30e0bd 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
@@ -16,6 +16,7 @@ enum icp_qat_fw_init_admin_cmd_id {
 	ICP_QAT_FW_HEARTBEAT_SYNC = 7,
 	ICP_QAT_FW_HEARTBEAT_GET = 8,
 	ICP_QAT_FW_COMP_CAPABILITY_GET = 9,
+	ICP_QAT_FW_CRYPTO_CAPABILITY_GET = 10,
 	ICP_QAT_FW_DC_CHAIN_INIT = 11,
 	ICP_QAT_FW_HEARTBEAT_TIMER_SET = 13,
 	ICP_QAT_FW_TIMER_GET = 19,
@@ -109,10 +110,12 @@ struct icp_qat_fw_init_admin_resp {
 			__u32 unsuccessful_count;
 			__u64 resrvd8;
 		};
+		__u16 fw_capabilities;
 	};
 } __packed;
 
 #define ICP_QAT_FW_SYNC ICP_QAT_FW_HEARTBEAT_SYNC
+#define ICP_QAT_FW_CAPABILITIES_GET ICP_QAT_FW_CRYPTO_CAPABILITY_GET
 
 #define ICP_QAT_NUMBER_OF_PM_EVENTS 8
 
-- 
2.34.1

