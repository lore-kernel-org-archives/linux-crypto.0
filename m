Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C12CC07480
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 13:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377490AbjJTNux (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 09:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377487AbjJTNuv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 09:50:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD695A3
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 06:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697809849; x=1729345849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=NMdAFjwGq7BahmMNPGjxfdxGjcK2OLK8M84GpARINFI=;
  b=jAGqoGuElpBaldRFI2ZNwV1F/SBg+pfVrSHwPYxLrnHPsFQisvFJ99+r
   Eht2M9mpCX/kmln0QuccWepao6mTP2RgF49nyL6CuBVCmNVy4h/RLoTzl
   Ck/MrnnNuVrv6bIVWyXySA8ThgccWjriDRw5az0S7SygRCweKzQTZDb8r
   35Mer4k/BbyO2zD5hEDdKRAAEy6yRK+QY0xxZfksfHJNev7qhoLF/3gX8
   t0RRLytsRcSyieXzV5/afHlcs/AxtFr8YJErBMbpPCmHc2w9zQkjKwGaR
   3rfJxRIoeO0YfLpzk0wHKURq0DEH84Ns3iKCuVgV0spQNI4ccxf37xV4J
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="472721235"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="472721235"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 06:50:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="707231443"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="707231443"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 06:50:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:45 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 06:50:45 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdBOyghyKIn1VtTaxH89t/tQ9Ftk103jzg01W/zWfyHz3dDWFh7XvISiXEizdVSNwM6Kd1YhAd3cDmj9WpoctMmXo1QF/erABLbdBOrm9oco8+lOG0Fnya1umM3K7TMwM0FqpLFmpAAtfBm/H7UNxeljH5XV3pUsKnrlpwAcS9plABE5wayNBVHfSh5r+DqPBdXszILmUuYmCR/lzjppu7a3cQe4SJjAJO8L3KfURD+I0NaqA9IEJHuonFz2roStFBLSTjkh2oDvfzzXDILpjbWTslA5VnUMzzds/qasOKo9EL4X6NiXf0lTRLEQ+LQJhxJtm3yfJAmWFf9NnieyXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BhtlNptHFv5SGQ14qDb0koVi9AJMgGI9+xcODbiwjV0=;
 b=jx9znnWVCnn9uRfZZxm6AdZilBGLEZriL+kztkm0EIvIO5UF85dZx9rtu78RshGbAwVlq1AZe7q9Jgrj+0CsozEz7t5TJpfhyy97ULat8O25HZT8R8oAuVjGfpAClkw/6mxj1C2XGHk3voyKb+Avu/fbSDq6kJQYFwv+BzjF4MczKwDN3TuS9NkTpgtSrDArVAVqDP1kCPxtf0Y3M9vkifaxgANQTFjE1cIBVba2rw8D5zxr0O2AyBEXWOMe3FQSkdxq++7tdxU6/t8cYVaBjhdWL5AsdsjnHDOY7/klBTZ9eeB05ASy9bTs2B1z4v+hXp67OWAYHBHHMxuPSrI4nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by BL3PR11MB6363.namprd11.prod.outlook.com (2603:10b6:208:3b6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Fri, 20 Oct
 2023 13:50:37 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9%4]) with mapi id 15.20.6863.032; Fri, 20 Oct 2023
 13:50:37 +0000
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Ciunas Bennett <ciunas.bennett@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>,
        Tero Kristo <tero.kristo@linux.intel.com>
Subject: [PATCH v2 10/11] crypto: qat - add rp2svc sysfs attribute
Date:   Fri, 20 Oct 2023 15:49:30 +0200
Message-ID: <20231020134931.7530-11-damian.muszynski@intel.com>
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
X-MS-Office365-Filtering-Correlation-Id: 37ed858a-d8a7-4728-6951-08dbd1738a1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NvI+ebVCgavyN30jcWFkai3LPmO3LzpdsZK82pwCM8v64dK+CJ2/wdhmQ5QpQt4//0PSg6wUFxj5u5WvjLEm6Cjz/S+OnJURKStXkboks7PijtojtmS+DYB3Dkry+qsJJfi/S5vuSIrEz7aAhlbHXpSh2Fku3d8YWVfBz7ClciJHQsXItCloJ1/Qx/jGtmZ5AoQiyh8gg2LDRL/mQtYXnNMC/B0fv+3G223yDUJb81Lai+slwL+42XYCpKuQ1oAuzWDrNIffcQtrFkXq/ORHFAgibtUagt5C3ntTRF3fyrof1zQYDuBQtUhrdK/a8ReHsUB26skfqj1aLUdyjj9h+G24qkeFhEFYhrdQr5lNCY1O7DGLXwrviFRbpTKnU0MvD4czp0pG+Mziv5171zovlK7R3duCeX65apMH61eIaAIAClAm+82DyZyet+SqkIWiP4JQaA/Grkmk5GvoOyZht4eppbUwBe/ubQ6LCLal4eAAowS4bwYqyQ8XmJCKEtbg84HAVGw7FAJzcF/iFeGc4HA1exuXxgM5zTv0LKPCd5Mi9bl9u+3nB421C4clj825
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(39860400002)(346002)(396003)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(66556008)(6666004)(54906003)(66476007)(478600001)(6916009)(83380400001)(6486002)(66946007)(6512007)(38100700002)(1076003)(41300700001)(26005)(36916002)(316002)(2616005)(6506007)(82960400001)(36756003)(86362001)(8676002)(8936002)(44832011)(2906002)(5660300002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gaC8f+D2WTrrXpeC+5w9I92VQnx7ugf0qQCWLyhurWXFyd2X3H0RZKnu9DVW?=
 =?us-ascii?Q?dqAQhxOq+K4FLF5Zj+olUGpIP+9nsSqeHJWjzaPqKu5ndyYp5/hw69LnELlC?=
 =?us-ascii?Q?006pbICub2T1euiODVrMcmZTlBQ6FmqUuCzDJ9C9Vvf8OqgkGeqScvRz9ihx?=
 =?us-ascii?Q?BziCexTpjh5fMnq/7AiKH3dAck9E5SncX60bOa9rJOzvn7qbXfFxljbaz3Nz?=
 =?us-ascii?Q?Vcxz3L1fZoExNum1a7/wkq/OmCdqp+yqH+PiMmR3xKAuwaZ+3PoFEsmGUWPi?=
 =?us-ascii?Q?CHqlZgO8St/CNVO6Z1yVY//+2Q9pG4Do1slnzTM/I41afkneV00nw9CwmrLr?=
 =?us-ascii?Q?BluuDcN8ziKf0pr2zPdCBg++N5ZcqplyN/8VBmk6QgXF2uMsdJ6iO3+E1j+6?=
 =?us-ascii?Q?2NLkuno/TmGAZk0tDzyvXi1Og8GdXwpsHl+eE56vRe+JmXkTkc/WyErmZ8fe?=
 =?us-ascii?Q?2GU6IcvmmgBTt5HyC209vwIQtA5cuot4yiuWwBN3G7J4iyZsobcmiPDpUjYb?=
 =?us-ascii?Q?fEP+irBZyHYp7wP7hldSCnT4nRka8RXf+/YzL8kvB0LptyQdkEfSOQ5zz13x?=
 =?us-ascii?Q?OBMJOriLbTxd0L5mlOV0YjcJHFs3WpfYr7kCpqx5+v3nhITCGtqA6Ydg5GTh?=
 =?us-ascii?Q?d5hz+6D5M/w65ZFQUWGJ5tsJZlOmtsD+ObEHjEwMekr8GDL5UfbKoR3qGZSf?=
 =?us-ascii?Q?c4jiBF1aVvOhomYjSYl52gks9lHPZmKdblKq8u5r9J35qGbGTZuH17nepEBM?=
 =?us-ascii?Q?sJDSMuf4hZX7t3AkC6OgwLttms5qAAcQ69QR0gw6REmQv4BeWcpQ+QX2dhgC?=
 =?us-ascii?Q?AiysDKR8xYRS6gW1TfHvg7tYmHHC72llse3i+c3yRY2js4P1FMHp+Ez6n33S?=
 =?us-ascii?Q?iqAtvLqUI9HpIUAesk8rJ8GxsEMwDynTPkpYHACFyfDOzG35CRpmoCRn+blO?=
 =?us-ascii?Q?1h21k9bB12tLAWl+teCq653hO2tfBEUjaZVKkZt7+Gy3mEv5XeiTV8AXrLHU?=
 =?us-ascii?Q?+hxi2d6PDPTwqquf3BehonGu3CoWaG/NZcH/W2P8UoBLKD0vdX6VQqjyO1fk?=
 =?us-ascii?Q?Wu+Nh/fERkimKbSKUF0ufBSqhEGvvMUuSn+P6ZU9ZgLnoCHN3vNBV2ecX2H8?=
 =?us-ascii?Q?x88ZNtXG6Rr/Qze6X7cqClQjdFj9GENw9zGMhJ3A34qgmdf4vw6F6ln8QAWO?=
 =?us-ascii?Q?fBMA+aVxQu6k+7pngwWM+4f4lIvPgsWGxVW966X9BLYcSMCDHrRNeyM1FcWo?=
 =?us-ascii?Q?f5n2/G6o4Y5ChwNKi59AfG+L8VUAnFlbgM5wkTUl80F0Q1XauW8zgd03WcQ7?=
 =?us-ascii?Q?uAqEWKl+oe1EB5Z+8fWSW0ZPYKII0T1JaK94Vg02k+rVSEMY7QGTgnCvciFh?=
 =?us-ascii?Q?G+WjkZsNgZJuOJQ9BlScwRWSQXU3GiwKWZz7JY74/Jh010qtSsd19BprjinU?=
 =?us-ascii?Q?aOricO/yGtQ1ZnWbSYpPZ4vx21yrEXvkaVR/zTp6aWRzm2buiKezxyPJjBH0?=
 =?us-ascii?Q?POOoqhI9klWTPwF8cUt4UHA/+CwKtaGg7vK9SB1w5JraKJRmtUw5Cc+tZnGL?=
 =?us-ascii?Q?P2vnllMnq5M+GPi+sih/yaYNaQB6L9qtOR81Ail44yEhk3pEmKMDzOs7sZII?=
 =?us-ascii?Q?Iw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 37ed858a-d8a7-4728-6951-08dbd1738a1e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 13:50:37.4114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v04xJWYVMJJ1jn6TPeJgt8ELCAXKBWWjEQM0yfJIyHabr/nqnCQO5UX36aTU+XR57gEXZXhX7hy5CgVutNGJS5nbQSo5rhav0HhTbd9o/oM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6363
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ciunas Bennett <ciunas.bennett@intel.com>

Add the attribute `rp2svc` to the `qat` attribute group. This provides a
way for a user to query a specific ring pair for the type of service
that is currently configured for.

When read, the service will be returned for the defined ring pair.
When written to this value will be stored as the ring pair to return
the service of.

Signed-off-by: Ciunas Bennett <ciunas.bennett@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
---
 Documentation/ABI/testing/sysfs-driver-qat    | 32 +++++++++
 .../intel/qat/qat_common/adf_accel_devices.h  |  6 ++
 .../crypto/intel/qat/qat_common/adf_sysfs.c   | 66 +++++++++++++++++++
 3 files changed, 104 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-qat b/Documentation/ABI/testing/sysfs-driver-qat
index 96834d103a09..f24a5ddca94b 100644
--- a/Documentation/ABI/testing/sysfs-driver-qat
+++ b/Documentation/ABI/testing/sysfs-driver-qat
@@ -95,3 +95,35 @@ Description:	(RW) This configuration option provides a way to force the device i
 			0
 
 		This attribute is only available for qat_4xxx devices.
+
+What:		/sys/bus/pci/devices/<BDF>/qat/rp2srv
+Date:		January 2024
+KernelVersion:	6.7
+Contact:	qat-linux@intel.com
+Description:
+		(RW) This attribute provides a way for a user to query a
+		specific ring pair for the type of service that it is currently
+		configured for.
+
+		When written to, the value is cached and used to perform the
+		read operation. Allowed values are in the range 0 to N-1, where
+		N is the max number of ring pairs supported by a device. This
+		can be queried using the attribute qat/num_rps.
+
+		A read returns the service associated to the ring pair queried.
+
+		The values are:
+
+		* dc: the ring pair is configured for running compression services
+		* sym: the ring pair is configured for running symmetric crypto
+		  services
+		* asym: the ring pair is configured for running asymmetric crypto
+		  services
+
+		Example usage::
+
+			# echo 1 > /sys/bus/pci/devices/<BDF>/qat/rp2srv
+			# cat /sys/bus/pci/devices/<BDF>/qat/rp2srv
+			sym
+
+		This attribute is only available for qat_4xxx devices.
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 30c2b15ff801..4ff5729a3496 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -340,6 +340,11 @@ struct adf_pm {
 				   char __user *buf, size_t count, loff_t *pos);
 };
 
+struct adf_sysfs {
+	int ring_num;
+	struct rw_semaphore lock; /* protects access to the fields in this struct */
+};
+
 struct adf_accel_dev {
 	struct adf_etr_data *transport;
 	struct adf_hw_device_data *hw_device;
@@ -361,6 +366,7 @@ struct adf_accel_dev {
 	struct adf_timer *timer;
 	struct adf_heartbeat *heartbeat;
 	struct adf_rl *rate_limiting;
+	struct adf_sysfs sysfs;
 	union {
 		struct {
 			/* protects VF2PF interrupts access */
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index f4a89f7ed4e9..9317127128a9 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -8,6 +8,8 @@
 #include "adf_cfg_services.h"
 #include "adf_common_drv.h"
 
+#define UNSET_RING_NUM -1
+
 static const char * const state_operations[] = {
 	[DEV_DOWN] = "down",
 	[DEV_UP] = "up",
@@ -205,10 +207,72 @@ static DEVICE_ATTR_RW(pm_idle_enabled);
 static DEVICE_ATTR_RW(state);
 static DEVICE_ATTR_RW(cfg_services);
 
+static ssize_t rp2srv_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct adf_hw_device_data *hw_data;
+	struct adf_accel_dev *accel_dev;
+	enum adf_cfg_service_type svc;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	hw_data = GET_HW_DATA(accel_dev);
+
+	if (accel_dev->sysfs.ring_num == UNSET_RING_NUM)
+		return -EINVAL;
+
+	down_read(&accel_dev->sysfs.lock);
+	svc = GET_SRV_TYPE(accel_dev, accel_dev->sysfs.ring_num %
+					      hw_data->num_banks_per_vf);
+	up_read(&accel_dev->sysfs.lock);
+
+	switch (svc) {
+	case COMP:
+		return sysfs_emit(buf, "%s\n", ADF_CFG_DC);
+	case SYM:
+		return sysfs_emit(buf, "%s\n", ADF_CFG_SYM);
+	case ASYM:
+		return sysfs_emit(buf, "%s\n", ADF_CFG_ASYM);
+	default:
+		break;
+	}
+	return -EINVAL;
+}
+
+static ssize_t rp2srv_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct adf_accel_dev *accel_dev;
+	int ring, num_rings, ret;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	ret = kstrtouint(buf, 10, &ring);
+	if (ret)
+		return ret;
+
+	num_rings = GET_MAX_BANKS(accel_dev);
+	if (ring >= num_rings) {
+		dev_err(&GET_DEV(accel_dev),
+			"Device does not support more than %u ring pairs\n",
+			num_rings);
+		return -EINVAL;
+	}
+
+	down_write(&accel_dev->sysfs.lock);
+	accel_dev->sysfs.ring_num = ring;
+	up_write(&accel_dev->sysfs.lock);
+
+	return count;
+}
+static DEVICE_ATTR_RW(rp2srv);
+
 static struct attribute *qat_attrs[] = {
 	&dev_attr_state.attr,
 	&dev_attr_cfg_services.attr,
 	&dev_attr_pm_idle_enabled.attr,
+	&dev_attr_rp2srv.attr,
 	NULL,
 };
 
@@ -227,6 +291,8 @@ int adf_sysfs_init(struct adf_accel_dev *accel_dev)
 			"Failed to create qat attribute group: %d\n", ret);
 	}
 
+	accel_dev->sysfs.ring_num = UNSET_RING_NUM;
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(adf_sysfs_init);
-- 
2.34.1

