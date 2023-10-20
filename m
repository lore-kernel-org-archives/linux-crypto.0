Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50DCAC00A98
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 13:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377429AbjJTNuv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 09:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377424AbjJTNut (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 09:50:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D25D66
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 06:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697809847; x=1729345847;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=eBs6t0dguCb3C4PI+AeeUvJFCzk1/Vywh9P9+qZWMjM=;
  b=FSXHUXx0eFjx8zzJWyii4x00UcNO0eFskYCOJC95J778QVgVH6SwffEX
   hlK/AVBe70QVgzHT3YKaHTv8+MF44ph15s2LHoGz0As7IfPYh3Kx1CZRR
   hChYkpAXEKea1Epf/QtXHROqmh0nsyQCACkW01/sRBF3ouEhDlRFvEBWq
   JSfXtk+01n0rCP9MPM/pwMPZd7yisKhSHuFU3DmWaE8kw+wRLEquYdm/s
   /P6QTW00vhlg8tmTvKJcJtF8CENaQkhcHqtlcS12t68OKfXWQesbBpthf
   ybH11GIQ9bCSvH1JBIEYO1ksHh5U80gEdUhWrg1oJSIQZf2CdxjujV9NX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="450725619"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="450725619"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 06:50:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="848086668"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="848086668"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 06:50:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:46 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 06:50:46 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 06:50:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+mTzNRyIXPQOkPvC5UJOyGi89yVvBmuhSENRtysOaWYyIrJXB3NVh9eib5lHp2g41Q3XDGEL52pBEEauUiAFQJ/hdytpV4bKLb9FdqupUfdNloSVO+fHW8h0tPdv8x/7GZCu81ydhjBBmUrzz/hDcCF8dqjqJ7B4s24iQ8PKRVj3SsOL4fTit9n3UhMv5iseCsaQTCfzIM0kbCJotpY9Mv9BXVzWpbnAi8I3m1AWW64DpfUeiA7BzUKPlFMA58SGFatmZ9CS1buN+REylKeecHdeXvz1VJ5f8GVEmwDLCP4V2R7bPgodR+mJ0HkwI5zPS5PzOMzeG5xmsadkrHQmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=njoOqE0ISWBXWaXpNoC3/dSCdsD/aEO0tvRct5aM4p8=;
 b=oeeFlSPKhjsW2Y34gI5wzhLWdF9p79CHq6Azgq6dlbwfOgZtb3Ajcjo1eA5/y7ml8G0nK+ZjFT8NwmLIfYgSznCx146IMs91y8fNlbcIDB2ybKZLbyilAVf70Pi8UHRnNnjzD2oIPxFck0B3KWdlS0qiP/EyDGkYz4yVzVFcFZR5ndbc7duXe0Z1KyPVgKBxUr2JM7VzSvCd+RG12s8vWmQB3e8csKiOtkgQvyvXqiLoWuAXOm0GvaQ1tWzSUm4aQStT0R3lOJdNouQxfAbXhGJ5YZv7GwnvWYpYwHPBuakQmqwFj6JgryOvF2Zb8K1+xsunF0QII2g+U8ArNxh9VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by BL3PR11MB6363.namprd11.prod.outlook.com (2603:10b6:208:3b6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Fri, 20 Oct
 2023 13:50:40 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9%4]) with mapi id 15.20.6863.032; Fri, 20 Oct 2023
 13:50:40 +0000
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Ciunas Bennett <ciunas.bennett@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>,
        Tero Kristo <tero.kristo@linux.intel.com>
Subject: [PATCH v2 11/11] crypto: qat - add num_rps sysfs attribute
Date:   Fri, 20 Oct 2023 15:49:31 +0200
Message-ID: <20231020134931.7530-12-damian.muszynski@intel.com>
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
X-MS-Office365-Filtering-Correlation-Id: c760715e-bf2a-493f-27b1-08dbd1738bc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kG6fHr0Loc+MU5QpYwsYh/7Or0MT1bDYHRm+epPKZC+WSBgfxARsGcI4pHkvbytDcNpzX8gyFXNTiS7ZiPJ84Uw/paX+2Okn2FfRNuub/pURKWdNXmKJl5UQQ7nnfNTx2CIZIl3UrGVCNeu/8DDllzqFqPCgEW6Og2zrZ0ATjQEVVAiAOmO03Yvjsu3dm76ARD5TfHBH9iUVFTEKjed64uarXVBdyuRKDEbosVbLzvqlIsGf3JfgQLXARzWjQe8SB2Am/HPu3G0ykWDT32ZAV2UY0PYbCv9owZdChjdqTM9/0Q4zWrPHNqCkVeKItJIC8fDlXUN7D05vnDuslI7RteXHVnRvoUs9qB4NHaAbH2DcSBVL0OnHbWzRPMVVRnsKJzpOnit7P61vjmR4+iTbNwgaf5blGTlZFikahcSjUit/XColwzB/SM9GvugxPp1KjPfdyhchGBHn0zXL8kqzMQIDI3UNJgBNCcnkD9yl093M8waWTot1DaAK2FGPwLWotTJ6Dy4SVw9IjNjWeJFAM502jMzBmg3/BDlpW9S3dP+R23uxs+2UeIKiC1cvpYts
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(39860400002)(346002)(396003)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(66556008)(6666004)(54906003)(66476007)(478600001)(6916009)(83380400001)(6486002)(66946007)(6512007)(38100700002)(1076003)(41300700001)(26005)(36916002)(316002)(2616005)(6506007)(82960400001)(36756003)(86362001)(8676002)(8936002)(44832011)(2906002)(5660300002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SgI3PZyEbNs7KOF0atvjG7sPN9rBuCh/YFY5WTJgnLfBmnCKVd+Xw34hLls8?=
 =?us-ascii?Q?Kiyv3d/DlQCSyxhSUmWjl2M5Bi7GlcA06ICHW9q6Sz2k46742bC9AQP9W+Ns?=
 =?us-ascii?Q?MlIMl68BOwJNAqX7cORHxwHzfdgsWK/5ATbGmmFpPE68E0EGLLgYp8L8Iyy/?=
 =?us-ascii?Q?llm6A2v+GDwoumuhk9jEkaSWTgBMja6GzYyUXfFY3wrs0gKXhPMi4lEC1g9p?=
 =?us-ascii?Q?dUSSajoOjmX9TkIfWZeEyCFP9igU9QzIH5WvbF0rjjlX4Pgm7QaLfYNK8hjq?=
 =?us-ascii?Q?QQuXieCoYlaLmXc44PAA3aXUKqCM5PuAIidN5Hfmcrc3AUhchwbPramyACtu?=
 =?us-ascii?Q?ldfoEsIPIzeWijQVUS0GifmJpgz+xSwpgpScqMiTkmToJZqyLKgOxTKi2gf4?=
 =?us-ascii?Q?eW8LCGHW5rNStGue2hCKWup4311sXMIF5UmPqUwc6vCWvcsI71677KQSeca4?=
 =?us-ascii?Q?QXwLuKeuiQWDtXbHUB0PP7CR3eCLY2OEoRTMXdPIizh7Kq5b7OBcTnxTvPeM?=
 =?us-ascii?Q?lrepT/OSC7Q+/qOvvmGEjTIB9nieFjukgcOtPFPqobPSgkRN/1SN7OKASDhN?=
 =?us-ascii?Q?/R8PY2Jh/3UdmPKmgF4aP9zH5iK+xfGn+XmmtEddWUsmjpougY2lImYkzjy2?=
 =?us-ascii?Q?pd56VIPuTyJvVoWonzeTYju04jzo1Xk4qoKTO19+5PFd4mndqpvLQ9ZkFXt0?=
 =?us-ascii?Q?W/A2thvAnxaH/m5mbbAbzqtCYAlrWriM1jhT6beZk8+ojA9mqDD6eYabWO4m?=
 =?us-ascii?Q?OkQOJnMFeGeuS1+yq0JK+07mbkDEmiIZ457aJctXl2M7VNdulZk167gonGY+?=
 =?us-ascii?Q?chxd7gYNzpflvkQUU/IadyWf8Ur8blNmUor/9LA/YuxcfiB6FxFobeVVclcu?=
 =?us-ascii?Q?PY7tm4h5IAwGLoZGoqooYwRZ6v9Oju3ORviseKy0cGdj2f+OTGuCm+Sc+aFT?=
 =?us-ascii?Q?NRdhm7szvW3Tyi8Pzr+uJJTfmrex0tVle5QhLJIF/YcxPYPzIZncLSkibUu8?=
 =?us-ascii?Q?fMScZxenN9Xt3PV6X95QCaK2p5kg+tcK9senvPS24VJuU6tqw0oUVQl+z4GE?=
 =?us-ascii?Q?YsxVKOmZY/wQmQqW+w3fL7aot3Q2LRn2uoAt+SEHKe12RdVmNrNcTYA/xL8j?=
 =?us-ascii?Q?eNt1k0CZWe2YDfA47I46xG+wgWWPKu+uv2fy/8XCfu1gaAgYfzjI83/yRa/Q?=
 =?us-ascii?Q?OEsG+7s2qGbli4OiH0KELpyR5qi+69yxSgM069+7VRKC0kzTlpyTdV+hfcHk?=
 =?us-ascii?Q?qTW9indUFijPDaJkaPqWLH+TgfuuhEHdBawodj+qahOyMHvD1aAopwDcIuhc?=
 =?us-ascii?Q?cu0BjAlhOpawYWour2oUYGLlyWWB5LpIebvlSJ9dnMSMEOYQ+zeq9lT8cBDT?=
 =?us-ascii?Q?34G/BnnY9oVJWrSnnxyAGpsMdgMe0/lbHTv9tH4p24o+V4lmiqzZceBs480b?=
 =?us-ascii?Q?7AhKSGyofoAfb5guYvxd/chYV7lpU1MfHm4C+YseTq9vHmLxT/VzupRoMINY?=
 =?us-ascii?Q?udNkeA6P/T+dKRtGo74XZWNc/ddoetNnobKjrZUumZa4L9vEvXT3h+VUd1da?=
 =?us-ascii?Q?try1hE9Sh0OUtiyNnRY3hmRSfdFFsejWrCg6nIIjuFx5V+tKdSl4Ruqd7uBR?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c760715e-bf2a-493f-27b1-08dbd1738bc9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 13:50:40.1007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GHmXqkK8Q93k4uPon7uzyIy/w/rEMkqxl0E1DpppguVQNN3QVrQ5zAmjy+c9CpdXCTdEbPc884Mh7UTyLqs/BeN6RrhorfZDHdmc7OQlJYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6363
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ciunas Bennett <ciunas.bennett@intel.com>

Add the attribute `num_rps` to the `qat` attribute group. This returns
the number of ring pairs that a single device has. This allows to know
the maximum value that can be set to the attribute `rp2svc`.

Signed-off-by: Ciunas Bennett <ciunas.bennett@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
---
 Documentation/ABI/testing/sysfs-driver-qat      | 14 ++++++++++++++
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c | 14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-qat b/Documentation/ABI/testing/sysfs-driver-qat
index f24a5ddca94b..bbf329cf0d67 100644
--- a/Documentation/ABI/testing/sysfs-driver-qat
+++ b/Documentation/ABI/testing/sysfs-driver-qat
@@ -127,3 +127,17 @@ Description:
 			sym
 
 		This attribute is only available for qat_4xxx devices.
+
+What:		/sys/bus/pci/devices/<BDF>/qat/num_rps
+Date:		January 2024
+KernelVersion:	6.7
+Contact:	qat-linux@intel.com
+Description:
+		(RO) Returns the number of ring pairs that a single device has.
+
+		Example usage::
+
+			# cat /sys/bus/pci/devices/<BDF>/qat/num_rps
+			64
+
+		This attribute is only available for qat_4xxx devices.
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index 9317127128a9..ddffc98119c6 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -268,11 +268,25 @@ static ssize_t rp2srv_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(rp2srv);
 
+static ssize_t num_rps_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct adf_accel_dev *accel_dev;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	return sysfs_emit(buf, "%u\n", GET_MAX_BANKS(accel_dev));
+}
+static DEVICE_ATTR_RO(num_rps);
+
 static struct attribute *qat_attrs[] = {
 	&dev_attr_state.attr,
 	&dev_attr_cfg_services.attr,
 	&dev_attr_pm_idle_enabled.attr,
 	&dev_attr_rp2srv.attr,
+	&dev_attr_num_rps.attr,
 	NULL,
 };
 
-- 
2.34.1

