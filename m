Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B1AC001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 13:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377372AbjJTNuI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 09:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377424AbjJTNuH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 09:50:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448BF19E
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 06:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697809804; x=1729345804;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=3qBvjcr/fVtuW6GCpBiFYcBCRq8Q7OXGV3ds5zW0JOU=;
  b=BNu7Aqp4+wZ6OCVCsSIfUgk6n4wkYgP3WzSJupKDLYvvYgwhcA8moIgh
   45HN34pFt8Dh+fQ7lHUKZHazWrMKxD8ooMz1MwK8nwV6lKnii/6ggaN1y
   9mhR4LKepPR/8nkrIGMnet14aQW09Pn4t7r5T9GzbmssxhJH/aSwhtX0Z
   ssp/2O5W924m57USeXPoDjLJ25qPc7OkqKEut6Am+6LODcSZHdjM70HHz
   fSgMklnmVwiOJDiGXWHFrAiSMt6fUeJE7QPhO2uPDdL3kFixp9Gfio2vs
   Z6vC2NSnuZ9YXl3IkWtLhOMSMbI/pMwCwlcVA2skoKGLCUVu/TvfbwU7U
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="365835973"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="365835973"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 06:50:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="1088748304"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="1088748304"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 06:49:59 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 06:49:58 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 06:49:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 06:49:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVQs8SuTKy6+bFZ9sJ9Jgv7a9AVF96RPqtNpdTEN+IARTidqmp39+cDWaViSFmCmZYreSvZVvyfP4a8YuwjQCQWgHNyahPFNfU05w4wlUnTl0mdcAwWCcUxZaP1YET5vBVlH1Oki27djzCPE1iUI4lo7bOscPnIs9OgEVqkZ7Uhxb7rVuEC4rRkAYKROyJphuODd1pxsTlzJoZ8V0ycX/fi4yLgdSNgdG+QjPVx5c5ZA5lo4OxiXNVKJBOh+iYupsel107D/75Fb2G4sUnyZEMJjx3luzJlsMGKutbmNz9N2bjQckXMQ/D9DpZje8CY+dJU4Pq0J5smJKmpUDKmZjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFw0NR+aZDlmYLGuKk0W18dadz/ygUxp/of/bpsGbz0=;
 b=AsJSMQqpz+xs31Yq906VmktC16eUrHtj944fTOb6XM26obavT0cSsjdGe21AG4trwu3baIJCiH/8hrj/tilERZKmv56EZHdfB1fPqST30x4/MXcJX+XzvIM8NrgGn8TDyh6cVJICnDOVIDq+AEgJb4Cl0QASe6CFGrdNEUx1gqVyrwD3outxVHqwZCI59aa5deDuOYixICgII4SOL3hSLLP93vt0cjCIcfsuGY1YKo8ScUr+PsR+kj3QikDCifs5D/MS4fWwkWjfMyPVBz3q4wjzd5y4J1vZD0UbRECYW2jxFJDSfitp0s2lnIuInnmhI2iVF9kjRWw/dkdFnm8Mgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by PH8PR11MB6830.namprd11.prod.outlook.com (2603:10b6:510:22e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Fri, 20 Oct
 2023 13:49:55 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9%4]) with mapi id 15.20.6863.032; Fri, 20 Oct 2023
 13:49:55 +0000
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH v2 00/11] crypto: qat - add rate limiting feature to qat_4xxx
Date:   Fri, 20 Oct 2023 15:49:20 +0200
Message-ID: <20231020134931.7530-1-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.34.1
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR5P281CA0027.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::7) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3734:EE_|PH8PR11MB6830:EE_
X-MS-Office365-Filtering-Correlation-Id: c50da031-51ed-415d-a2b0-08dbd173713e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5wgJkejzm+NkS23QWZy3ezmvRJUwStBSWD5J5zDZ0ARTpWNS73lYzBEw5Y2txqegJSNyDh177S2srjBtxtsZM+MwifDP8EcgujPVr3Vj6mhKrBqpDV/ukUcN6+d0/w+K7iqQ7qrnJg6gSJPD9so8sA2CFDZyD8HD4usO6KXnSC9yIMuCxy4kSlhtfctZz7AwgSeFXr8eNA9JUH/6e+2T2od8kuOzYfRDERGp/QlD1IzePvvIEjTsZ6PvF6td2SPn5mZPBMGUf8/MW2fqhpnoG9krVzYfcIWUG/eU8WpSht6dGyYc3+cHCdnpSbzJLA5IoBwgsyWpA30+Ea3Ky1UHxnwFu9eExKASOvH954TrqepnpGVedCn6x42NvFMuxooU/SLQrJxhJEYw26FrNVVFIkkxUDRj8LsClHyHxKFkXb42qgBA/VELBpmy/EDi5EkPVs2c/tpvlLG2jcRUOlGHdvznSm3FYn2RifA/CItgj3aT1CQUUZrUTJucMYejV9mQxT7ofgkBXmZZKLZIn+zI52lbrIftNENnk43ahKHQ3GBX6nwk7x0Tk+4u65HKhsiD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(376002)(136003)(39860400002)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(5660300002)(66556008)(66946007)(6916009)(316002)(66476007)(8936002)(478600001)(8676002)(6486002)(4326008)(38100700002)(83380400001)(82960400001)(6512007)(107886003)(2616005)(86362001)(41300700001)(1076003)(26005)(6506007)(6666004)(36916002)(2906002)(44832011)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AvL2lQ075mkPjvxd/NPhaX6sO1G3AiNLW436pkJBNFy84z8CP5SQzpnAQYFB?=
 =?us-ascii?Q?TbGNn3+5Iri7nhMoutuP4fGERj2+XLZSpVbsiJDtKSsibMNznBJzT4Qyvj75?=
 =?us-ascii?Q?UL6+FENAVIUAGcoca4Eiv1xMDFPoErnmfBRz/tIKZsSpsstDIlORFnohwmsi?=
 =?us-ascii?Q?Ie1K0yde97CPhVef0LVX5RVQsnlm+Xh3z8GgXoCYevWUyv6QvmUhv3eyw70+?=
 =?us-ascii?Q?zKSI0E5pRO47FgJGWpgyYQIM0e2VfuUDLyP7wOjjwVYaz7ffEzqQoGQ0Iv54?=
 =?us-ascii?Q?Rdx0XWytqVXr/43RwFhmjCOJkE2KVg/wborwyE+w8PJogU/sZClW2k0EQJbO?=
 =?us-ascii?Q?Ex7jCarmQowvm3EiaDVTLG13SpwgQ+/N6giU/3IWS31dLGJyGRRwZmqtmJNz?=
 =?us-ascii?Q?10/C3U8offrhWXC4tve7p2YtFAP0NnqIkAMfoHwKf7uEpfWM5b+YcAKxLJaf?=
 =?us-ascii?Q?pd6TAJBZJTjhymLKKLQpvNGsISscyA4spHsfQoG60Fxk5KMtAbReFOjaaaBF?=
 =?us-ascii?Q?7Yj3lKbuImUvmU9RQXiM3G9SXrtzEA0+aQ5VIrNwssWH3jbsDKJRYv5Ynrw3?=
 =?us-ascii?Q?4NXCaJc8aNKDTJOgAbVKseDFdNUXc+vQBJ62rJEJD6E6HJSYZTlhgtcflDHu?=
 =?us-ascii?Q?c6R+diBbsyqaslUocqC5RPTFRiOWPmZM4bFmRkUTcumOxYlH1OZP6IwXrgVS?=
 =?us-ascii?Q?nwlEpkFCLU8ovCHcVUc4fH2Njifn0y50wCF3oSdg/NYONV4jAfBa21IGPALu?=
 =?us-ascii?Q?qmw+8mR0vEXHSehP4V0f+QxbkPR5AOZib98VepiPKllzRb6mjo4qBEDXE+hT?=
 =?us-ascii?Q?KIBCqkvicROJRkNMyPD+kMktcrtZYqIFjvPeFbbDzWggQKBDkYALPra4wNHh?=
 =?us-ascii?Q?b7790xbgR2le56XfAeejsuXbcFlMOp081AubHk6BcSXVYP1PhgrMPf4TpQaT?=
 =?us-ascii?Q?16T7NkYA/TjH8QHpDbVY9X1atrl1sTgyiAVr17oExlVC7V/zjnBbLOOdjVvB?=
 =?us-ascii?Q?q4SudtsjHODsX9GcnjJnlxs02AcjsovrXzPKlqo/2pCqvOO8fE4tQ1Nzga0y?=
 =?us-ascii?Q?2a0Fu9IIsjtm2qtQDvKSr2VoL542rEsoTAe7JpavWU3wh0Gh3sCLXEA15D+7?=
 =?us-ascii?Q?sWwxDkT2W858wyVtqCyDofJOh0/mLmMZIxY/jKlpEsIjoDfU1K+q+seKvBY2?=
 =?us-ascii?Q?mL67cvbzVqDdKPfNxnB+gBki7r6sY2w0PfCgOOEXdMqn6LX1tpvV6ar/qkpu?=
 =?us-ascii?Q?drwLrL0E9KDa8ZODH9VVaaL6O5fJMXS/dNzlsqeZHurfnltY94fxVaxGV+so?=
 =?us-ascii?Q?2CEO/iHRk5CNSw3KHQipWYjYAQaBPuBNMtLCdepgp4vsyEj3MA4un992mW1s?=
 =?us-ascii?Q?MC30uBXzQP8IlndBsircKP7Osdvz1sgkM2hOZ3spPof1Fj2cx00zU3Wl/akq?=
 =?us-ascii?Q?Ogdk6KP+xu0Pg1PXQlVhHzdtls19YB0oMVBugsMDJwOZDdcUBoPV6km1TgRT?=
 =?us-ascii?Q?XSzElNwIIjQPIH1BLLd6pWFoFXRepaW6QJz6lrWRRXINsAMssGq0VsEFGbxN?=
 =?us-ascii?Q?D/h/DEQ/OKvsKP3Emd4GDRA2jUdA7jmzGZjNHG9o1zA5ngXKeaocCfIh1q6I?=
 =?us-ascii?Q?JQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c50da031-51ed-415d-a2b0-08dbd173713e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 13:49:55.6151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kH7nhUr7hM1Evy/gcMgmmS7brZXf2C15fc8udvXLG10g0pRHeCIoBL99nhU2QF+1OkCJXQfGzphd3YZg2Bk2eIaZuH/abFg/yc6Ny/nRKuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6830
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set enables hardware rate limiting capabilities on QAT 4xxx
accelerators. Rate Limiting allows to control the rate of the requests
that can be submitted to a ring pair (RP). This allows sharing
a QAT device among multiple users while ensuring guaranteed throughput.

The driver provides a mechanism that allows users to set policies, through
a sysfs interface, that are then programmed to the device. The device is
then enforcing the policies.

The first six commits are refactoring and additions in preparation for
  the feature.
Patch #6 introduces a mechanism for retrieving firmware feature
  capabilities.
Patch #8 implements the core of the rate limiting feature by providing
  mechanisms to set rate limiting policies (aka SLAs).
The final three commits add the required sysfs interface that allow
  users to configure SLAs.

Changes since v1:
- Removed unnecessary check
- Simplified a few error paths
- Reduced a few local variables
- Fixed repeated error message
- Moved mutex lock above sla_id existence check.
- Added Reviewed-by tag from Tero Kristo received from an internal review
  of the set.

Ciunas Bennett (3):
  crypto: qat - add rate limiting sysfs interface
  crypto: qat - add rp2svc sysfs attribute
  crypto: qat - add num_rps sysfs attribute

Damian Muszynski (4):
  units: Add BYTES_PER_*BIT
  crypto: qat - add bits.h to icp_qat_hw.h
  crypto: qat - add retrieval of fw capabilities
  crypto: qat - add rate limiting feature to qat_4xxx

Giovanni Cabiddu (4):
  crypto: qat - refactor fw config related functions
  crypto: qat - use masks for AE groups
  crypto: qat - fix ring to service map for QAT GEN4
  crypto: qat - move admin api

 Documentation/ABI/testing/sysfs-driver-qat    |   46 +
 Documentation/ABI/testing/sysfs-driver-qat_rl |  227 ++++
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  190 ++-
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.h     |   13 +-
 .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |    1 +
 .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |    1 +
 drivers/crypto/intel/qat/qat_common/Makefile  |    3 +
 .../intel/qat/qat_common/adf_accel_devices.h  |   11 +
 .../crypto/intel/qat/qat_common/adf_admin.c   |   71 +
 .../crypto/intel/qat/qat_common/adf_admin.h   |   27 +
 .../crypto/intel/qat/qat_common/adf_clock.c   |    1 +
 .../intel/qat/qat_common/adf_cnv_dbgfs.c      |    1 +
 .../intel/qat/qat_common/adf_common_drv.h     |   10 -
 .../intel/qat/qat_common/adf_fw_counters.c    |    1 +
 .../intel/qat/qat_common/adf_gen4_hw_data.h   |    7 +
 .../crypto/intel/qat/qat_common/adf_gen4_pm.c |    1 +
 .../qat/qat_common/adf_gen4_pm_debugfs.c      |    1 +
 .../intel/qat/qat_common/adf_gen4_timer.c     |    1 +
 .../intel/qat/qat_common/adf_heartbeat.c      |    1 +
 .../qat/qat_common/adf_heartbeat_dbgfs.c      |    1 +
 .../crypto/intel/qat/qat_common/adf_init.c    |   13 +
 drivers/crypto/intel/qat/qat_common/adf_rl.c  | 1169 +++++++++++++++++
 drivers/crypto/intel/qat/qat_common/adf_rl.h  |  176 +++
 .../intel/qat/qat_common/adf_rl_admin.c       |   97 ++
 .../intel/qat/qat_common/adf_rl_admin.h       |   18 +
 .../crypto/intel/qat/qat_common/adf_sysfs.c   |   80 ++
 .../intel/qat/qat_common/adf_sysfs_rl.c       |  451 +++++++
 .../intel/qat/qat_common/adf_sysfs_rl.h       |   11 +
 .../qat/qat_common/icp_qat_fw_init_admin.h    |   41 +
 .../crypto/intel/qat/qat_common/icp_qat_hw.h  |    2 +
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |    1 +
 include/linux/units.h                         |    4 +
 32 files changed, 2605 insertions(+), 73 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-qat_rl
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_admin.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_rl.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_rl.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_rl_admin.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_rl_admin.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.h


base-commit: 1bb03421eab67940b6509fe0869ff43df5fbe3e6
-- 
2.34.1

