Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5A8DC001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 13:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377274AbjJTNu0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 09:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377304AbjJTNuV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 09:50:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8D593
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 06:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697809820; x=1729345820;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=aSiqd+TCmSSnpiwKxnBHjE3UQOrnnu4zIT8HmNI9e24=;
  b=U5LQYMVjfuboY9R2XW1iGWlExtgj53CxM+vOCcMYZZxo6kGm0Qt/WhMx
   ZxyT+CMTozilpPHs8/PUHiUpzoYeHMdY0KLiEZac1Y63m4Va1mcA0q1o0
   m/bWc94HK57qQyWTGpDG/CoidIQC1dA5ZBPDoeXNMeM3cfPCy+mXzWdn2
   Kwy7lR/vMCyS4RE8LsGmOwfaLSzmEfVDy5Mt42bfGuW2pd9nnEKherHrZ
   3vDhSBSVMbVgBSFMLWww/pNBEx4LsATGCbVdBAPuRS7+RGO+xll73vA8F
   cpS9IdmZWtUDz9r9kVTt46yCffwFLtil3ll0EQT4xjfWrCCwTJxhM9Z3n
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="385376734"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="385376734"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 06:50:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="931012664"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="931012664"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 06:50:19 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:19 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 06:50:19 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ajo9Q7KFxRXzVKs63cjZ8kOh4Nh3HwJzx4yvv8dTszQh9MzKO6iSR0aOzz/VSQ2e227zR9Kf9Sn0ULAVmaT1W40n7ZjmUtMseTo6dbfx1N7Rvs2efzr76sq9hZZmE3R1Fu+hFGIuKWPuu2+upX0Y2cFGaNQRVeYui7BVB6oWWtwJ0V0pF/SPY0LuvGzvb8/zbNOgq9qet1T5vWTimPShOLNqamXrRyoBYivKqY5++EgiweAyryfXsFOlgbLENxNf3WeUROacW+Z1RLaKlsao8IRnVFZI20T70QzwW4jsmyDT40RnZ7h8AMMoaytLse8/JUUOSrMTSWDcqCeJlzHxpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PcVaaLCrUauKSHt/K12clGOZkcYE4/fCVRqTRSTbuRk=;
 b=R4/dVYGmRWe45gT5wYMyCqiCvX9oUT/NHy1uEic0xPjYr4ySMjfsYaxj+tavcRzTCyC2FgwrJ0KWlJzlBZ5/sv3lfMlY04ugOf9kZ3dHVEoUB4N6euCDFwrwLIdy6s718LFk11W9/CXXprqQQNVUKIIN3rZHDWy64JL1Ru47ncIrFkh2Wy9J55G17AQVLIX8HzKeapCzBYOBXVLfBxSNhDM3uPSoVgV3OLttW3DX4XNzbx6E+GfWeASS++OnsuC7+OqcFAw72BI2p8Q7WKiyN3XDP8Z6qEay3l47aPuep4fehIZcYSRkf/g540v1HICQxwTEtk4vFlEDCYFZxggfAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by BL3PR11MB6363.namprd11.prod.outlook.com (2603:10b6:208:3b6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Fri, 20 Oct
 2023 13:50:17 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9%4]) with mapi id 15.20.6863.032; Fri, 20 Oct 2023
 13:50:16 +0000
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>,
        Tero Kristo <tero.kristo@linux.intel.com>
Subject: [PATCH v2 03/11] crypto: qat - fix ring to service map for QAT GEN4
Date:   Fri, 20 Oct 2023 15:49:23 +0200
Message-ID: <20231020134931.7530-4-damian.muszynski@intel.com>
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
X-MS-Office365-Filtering-Correlation-Id: 21bb3ad1-4348-4356-da66-08dbd1737df4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q7ynVN26ZnwHJlaVnARzCy4bxl81H5l8xoFx7N8zyiNH1cf/3tTvkq+rg/PDtk1cPJjGLru4lbPPnWTMEsixfhiwdibzW3M5rTg7AI9dla6j0LOJcJBio2MXapXXQM9/LSaQD9IUd4F5uoCMTQbFTDNIHRuTSTuFUfh5nA2sG7EYxFnSgg7ZOnvirYEa2hbSdMsyt6CF0WEEn4i3Zz6dqG3RXp+E24/xS/My5HckIKYnq+U+0eRq6NCgtu8P/6hPv7wsa6X0M7szqx+8ZiwMPwhUNUBU4ZPGe5ftfLX4Ma10CVOul0K0XizgU+Rs5wX60d4R/29Uhj33XanVoEHUmggnj8/75VLZ7wzo3IrwyzXgIthDXsHuue48uYTzC2L4HCDsbhFgaSyd8Rr8XJ01OBoome3Ld+4ZD/YASqqn95hRhOVYmcfefMlVNPcLvL4XZImgfhvA4mev1fspFcDgo18slWlVCKZDBBjeEcPrnWEjqwaSwnN3R4k2qyvZVclgqzUlBmLh2AzwtttcrT+2WkgCtFBlyYPAulF78hynKok=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(39860400002)(346002)(396003)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(66556008)(6666004)(54906003)(66476007)(478600001)(6916009)(83380400001)(6486002)(66946007)(6512007)(38100700002)(1076003)(41300700001)(26005)(36916002)(316002)(2616005)(6506007)(82960400001)(36756003)(86362001)(8676002)(8936002)(44832011)(2906002)(5660300002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MmJvO6IMrx6iknyXKfAmN7ZV3+9h4lPeybPYMdEaw50dN7b30dOv9qo1ZSN8?=
 =?us-ascii?Q?zKeNGRYaaIzerhq7SYOY4HV9dQWL+3352zUqd7wTMP7Ykn2V0I+Wu/O5VHIr?=
 =?us-ascii?Q?XjuuRXN2a+eToDxHmaNkb2bHRNrFycosGI7io4xt+RyeyyGqf2bBiwkA4dCx?=
 =?us-ascii?Q?AjPJ8Odow23YrNZGHrQ7qT8LtYWLx+CJ6epJMycSHkgyf5JnQsH74lrmzK/g?=
 =?us-ascii?Q?d7jIINjYZYJqPJ1ElmVRIsD+madhxqx/Q66y7nZhBH8BmZ/dKQVdOHUfMQV4?=
 =?us-ascii?Q?W93j4BlgiWWoPy1bMbNm5vZuZhQ0k6Ld07vusGypPg3bZqOydlyafWwfgCSr?=
 =?us-ascii?Q?YmAdV4vdgwualgpWVp9oW+3NkhWu2jEZK+ecZjtKQ2cga6ylQ0pTmY6E3CdO?=
 =?us-ascii?Q?9FSKi6GfHHSlACFAMn9shPE2wrehWspvaaWaH68FeMz7JJtzFgHQbKGELNU6?=
 =?us-ascii?Q?XZs10xeQm1bIhQte1Oi3cbjgxmsc/5c9DHOxphcy+d9T2JggQyGVzox874Mf?=
 =?us-ascii?Q?fyjDb4rr0JHhIX3cTMNPEwDkS41lfuf51DiqS1guxVoY00KUoaH2QCqeqzG8?=
 =?us-ascii?Q?xpspbMuCyeiI712bgH0l2GnP7J+t/FHrjZBfmH2g90Iwmo+SUb9SHFbNnw0/?=
 =?us-ascii?Q?aQ4HaswUfO/nhGJ7Wc29hYRQ54Oy08IDqg23oJecOLEn3XFMYTltEWmWGIqF?=
 =?us-ascii?Q?RIRze/JKXAlSEEBhXAtmDVLSTm3VXHhxwSlJxKMjWMOtrZGjwxm9rr8cqg1s?=
 =?us-ascii?Q?Wr7mzKFTjFVoEPbBtSgwPQhPszU/bWvNcSPCaoRTIIC6WonAHb0EJbtCRXs7?=
 =?us-ascii?Q?6vVXuEVj2Z2lDO9ii/qtwQlOdDnHW9DbjwLxtMJV03BXFJbrZ7U8OFQ3NzJ6?=
 =?us-ascii?Q?82cvZ4Ooxgm6B6SQxfhRT1X1Uu5YAUCpZyMsBzVtsjleFBPmDvFPK/VAgrrE?=
 =?us-ascii?Q?d8OX44hiWbS3jvPA6cZ2IZk5MXmxYIBfNl6yY6bAVU7bKmac6OHjr3nTZ81g?=
 =?us-ascii?Q?xiLRUkRKYe4kJ2LRRVUTCtCpwsjOX+pGEor5SeSTMXk4pZiWH12dL7UkttL+?=
 =?us-ascii?Q?0Nbx+TfSO7bL5u72M8p9edtm3HEXUfCDO+W+7r8k2tl/TTjyk93/14RKiY2I?=
 =?us-ascii?Q?q3XnRap9pdjH35oEjLFPNEOmhoi82/oSSFD/IKOAxqJ25UMdHI+Fes/QyKJM?=
 =?us-ascii?Q?NJ3i6gQQZQ2ocBT01+1UE5wcCy9GOgcdryS6NAJbP+wHmA+urpvoBc2OS8VP?=
 =?us-ascii?Q?nqk7QFw13KQ04tOOck0zwk6PY6fN/FRvqQe7ZCcFxTfJJWEPOvM5tB47IZXL?=
 =?us-ascii?Q?9n1wPXehNO23dHNHL8GyGIJ0KRU1qjKqaaZgVWY19VkGu8xSPiuR5s5NwYyo?=
 =?us-ascii?Q?XGtY14qVgN1voNtJ61Ah++wKtqYqueT+bm7EJO3o+z+ue2k4p3FXwBWkFkw7?=
 =?us-ascii?Q?QEjZJwBbGM5LaR5cVhnxcNJD2drL+3aPZ0wUEtag+AvtT8fVfjb98SQZ/Yh/?=
 =?us-ascii?Q?onStkuL+DIyrRp/VxFHUrWleHFLvXZ6MNNLNPvqKj9zjzGd+Dz2eKDkv7lx8?=
 =?us-ascii?Q?MHJ+TCKoc3o2ShgAXPI+vCq4FXB7DuTCkoB6QINKeslgbp9gnGwqz6G85fYS?=
 =?us-ascii?Q?2w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21bb3ad1-4348-4356-da66-08dbd1737df4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 13:50:16.8860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /tHydgnq6bApau+j/DMtG6JeqVfLP2nCboo3DiaLsDdzbtDhz0dX30Kg5TGjGK2jfWE5UokINrgACrPFuLyL13Ko43/+tYd03byjitw4uq0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6363
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

The 4xxx drivers hardcode the ring to service mapping. However, when
additional configurations where added to the driver, the mappings were
not updated. This implies that an incorrect mapping might be reported
through pfvf for certain configurations.

Add an algorithm that computes the correct ring to service mapping based
on the firmware loaded on the device.

Fixes: 0cec19c761e5 ("crypto: qat - add support for compression for 4xxx")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 54 +++++++++++++++++++
 .../intel/qat/qat_common/adf_accel_devices.h  |  1 +
 .../crypto/intel/qat/qat_common/adf_init.c    |  3 ++
 3 files changed, 58 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 1f1e318eeabe..37bb2b3618cd 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -424,6 +424,59 @@ static const struct adf_fw_config *get_fw_config(struct adf_accel_dev *accel_dev
 	}
 }
 
+enum adf_rp_groups {
+	RP_GROUP_0 = 0,
+	RP_GROUP_1,
+	RP_GROUP_COUNT
+};
+
+static u16 get_ring_to_svc_map(struct adf_accel_dev *accel_dev)
+{
+	enum adf_cfg_service_type rps[RP_GROUP_COUNT];
+	const struct adf_fw_config *fw_config;
+	u16 ring_to_svc_map;
+	int i, j;
+
+	fw_config = get_fw_config(accel_dev);
+	if (!fw_config)
+		return 0;
+
+	for (i = 0; i < RP_GROUP_COUNT; i++) {
+		switch (fw_config[i].ae_mask) {
+		case ADF_AE_GROUP_0:
+			j = RP_GROUP_0;
+			break;
+		case ADF_AE_GROUP_1:
+			j = RP_GROUP_1;
+			break;
+		default:
+			return 0;
+		}
+
+		switch (fw_config[i].obj) {
+		case ADF_FW_SYM_OBJ:
+			rps[j] = SYM;
+			break;
+		case ADF_FW_ASYM_OBJ:
+			rps[j] = ASYM;
+			break;
+		case ADF_FW_DC_OBJ:
+			rps[j] = COMP;
+			break;
+		default:
+			rps[j] = 0;
+			break;
+		}
+	}
+
+	ring_to_svc_map = rps[RP_GROUP_0] << ADF_CFG_SERV_RING_PAIR_0_SHIFT |
+			  rps[RP_GROUP_1] << ADF_CFG_SERV_RING_PAIR_1_SHIFT |
+			  rps[RP_GROUP_0] << ADF_CFG_SERV_RING_PAIR_2_SHIFT |
+			  rps[RP_GROUP_1] << ADF_CFG_SERV_RING_PAIR_3_SHIFT;
+
+	return ring_to_svc_map;
+}
+
 static const char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num,
 				const char * const fw_objs[], int num_objs)
 {
@@ -530,6 +583,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->uof_get_ae_mask = uof_get_ae_mask;
 	hw_data->set_msix_rttable = set_msix_default_rttable;
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
+	hw_data->get_ring_to_svc_map = get_ring_to_svc_map;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->ring_pair_reset = adf_gen4_ring_pair_reset;
 	hw_data->enable_pm = adf_gen4_enable_pm;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 197e10eb5534..1c11d90bd9f3 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -212,6 +212,7 @@ struct adf_hw_device_data {
 	void (*get_arb_info)(struct arb_info *arb_csrs_info);
 	void (*get_admin_info)(struct admin_info *admin_csrs_info);
 	enum dev_sku_info (*get_sku)(struct adf_hw_device_data *self);
+	u16 (*get_ring_to_svc_map)(struct adf_accel_dev *accel_dev);
 	int (*alloc_irq)(struct adf_accel_dev *accel_dev);
 	void (*free_irq)(struct adf_accel_dev *accel_dev);
 	void (*enable_error_correction)(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 00a32efdfc59..ef51c4d028d2 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -97,6 +97,9 @@ static int adf_dev_init(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 	}
 
+	if (hw_data->get_ring_to_svc_map)
+		hw_data->ring_to_svc_map = hw_data->get_ring_to_svc_map(accel_dev);
+
 	if (adf_ae_init(accel_dev)) {
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to initialise Acceleration Engine\n");
-- 
2.34.1

