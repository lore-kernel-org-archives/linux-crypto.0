Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD94626CB
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jul 2024 11:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721216815; cv=fail; b=cdhrprYrK/nIC7uOz0inbajmAAyfEG3t987g+oKGcLooZl+WWHKNH2OFia2HvMTxW2vHVG6J6aV2bMao4avrw6hoegtrZ9rLi+cdySEQLr+Z0Zvk1wHBhCEacye9qqouJXZMjXOYH9kkZAPtcsS2u9cgXz7INbWQL34FbLA4gFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721216815; c=relaxed/simple;
	bh=+QLy4NYwZWpFId2JW+oQfngL3ZKynlpR3lTLxStoLME=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=REX6Ngp+3ZuOMMR5EE5LEV3IiSVFzzRVX0zTq9RiWYraVAI0kWaXuDr5wbS0r/3mNqRe77RGGrfSP2ZxQ6dwiXTgH+/LJeIfU8yowHtiuW2TpQbwFhKey8JzueUqtv09Cuzl3x+VHMrbL5OvMrMRYgw8upc54radyMraSfMnduQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=We/UUc/U; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="We/UUc/U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721216814; x=1752752814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=+QLy4NYwZWpFId2JW+oQfngL3ZKynlpR3lTLxStoLME=;
  b=We/UUc/UdXeCXF419cgiGgxhXwPcOdhM5V2QNtQoJ1dF6aKX3KlGXHUY
   fGtrUUtpWs+1HCgaG3WSA4LlvHr4u8h8TtCRKW3OlBxFzhrFlij8vRhpe
   XVp1aiKOKH0kTBakzylMTb819ogTsZr8RAB0cPzwxOoDzx/LYg0zGxMrl
   UM4un7DKYtf9TX3ryxI+Y/fWXEvw+EKTW0B4Uk5lJ4imlO4meVKhSwWQt
   g+OSSDFJsOCVl9JvEXr14GwTjJej7wo8onODGiSr07hzwnUe6LTQhfJgY
   tcrIORmX9YDgwbuxW8QWLXYjreIQHZRGqNYp7dSZcQr4LyR+0z9/Hgqz4
   w==;
X-CSE-ConnectionGUID: JEW5QBCwQTagD1eF8+RJTg==
X-CSE-MsgGUID: Op275RAuRFSEDWmQ4S00dg==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="22572908"
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="22572908"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 04:46:54 -0700
X-CSE-ConnectionGUID: BTBbciZ4TqKR/YTHHSRu5Q==
X-CSE-MsgGUID: GjH+xJy2S/WKaOn83eOf1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="55207386"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jul 2024 04:46:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 17 Jul 2024 04:46:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 17 Jul 2024 04:46:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 17 Jul 2024 04:46:52 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 17 Jul 2024 04:46:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PTpDzdLjFtxuGv2adf2A/QPGBKyXrP8yrBL4ZEkleS/eAnhpNP7pZpalcyY76ADpaHQR1S9QVzz1vGh6b/JTNriNOUwwHz1Ig36tU52PpzVD4c3hIMsrhasLn8HMJvc8/lrUiC+dMEwHPmN6cry0Cc9gpjrqTXbfF8xJCuXMKKnHeJ85gm9tQFtjJz/oyS0p46Abx6W8tib+Qz9GvhpYwr6cIolR2jDPysR4HTFeSkImaEuQW0IafsRx1xY04CkrvqLB7pmwn+xIAILAxzw8y2TZP39UzG0TFHko9fZyFNUxmEDphf9HCQ1IaNvNvMPMqKoSXint8N3qWU7WBr1YuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MwWr7Bn2vGfUDRuoKvUvC3AmRdfUX3PTzSK/KA5e6cU=;
 b=TmEIyp7PfYCKDR4NFBTlirPg9YELm02MGe/sWeKBTwgW2TWPeak8UEtQfR618iqK07CM/BZYA3QKCxKHwKYZ+8t7khMWXzkmc3RUbBtXt7OWZ4kk2ztnnyDYARICvP+cYoS3eNfGN0ic+eQaxBmWRInXhiN2BqK8TMq3Zl8Op1q7nSKo8As23R0ZFNplKtUaD1S0mbo6AsEb+JYrCzTPPUrGLvlhvhFW7cmd/yfI+ohi1KthonYPovEnykAij38+IKLpPh1FMKMthS1AbkS5fj9oH7evaa6BZJIfWYpuFANq9DQAymMT5iWM0fpSNQq7JwOMoA6juSGiaRbNb+7Okw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by PH0PR11MB7710.namprd11.prod.outlook.com (2603:10b6:510:298::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Wed, 17 Jul
 2024 11:46:50 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::c80d:3b17:3f40:10d6]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::c80d:3b17:3f40:10d6%3]) with mapi id 15.20.7762.027; Wed, 17 Jul 2024
 11:46:50 +0000
From: Michal Witwicki <michal.witwicki@intel.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, Michal Witwicki
	<michal.witwicki@intel.com>, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>
Subject: [PATCH 2/5] crypto: qat - disable IOV in adf_dev_stop()
Date: Wed, 17 Jul 2024 07:44:57 -0400
Message-ID: <20240717114544.364892-3-michal.witwicki@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240717114544.364892-1-michal.witwicki@intel.com>
References: <20240717114544.364892-1-michal.witwicki@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DBBPR09CA0046.eurprd09.prod.outlook.com
 (2603:10a6:10:d4::34) To PH0PR11MB5830.namprd11.prod.outlook.com
 (2603:10b6:510:129::20)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5830:EE_|PH0PR11MB7710:EE_
X-MS-Office365-Filtering-Correlation-Id: 610f8998-3e25-4dc5-196c-08dca656256c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+yyCGDC1bQBdPsRDXw4FpNxNLXBJh7DrADqiDAU9Z4rI1XoPbjaQP7k8DYaC?=
 =?us-ascii?Q?17+cwoB1JGh3d6jCFz1JL+1SO65G/Yk+5d2f8NUI4agoCO40RK83cVf91V5c?=
 =?us-ascii?Q?dWNCKdyZEuIcq4a2DvT1JykbERu+PZRMJ2lQlKqpfmMnZRr4freEUqy0J6Kv?=
 =?us-ascii?Q?EbgGuvCEFjGHEhyU0BaUzT1GQqXPlhMz40jae2aPxvj741UutiPd94T4JLAV?=
 =?us-ascii?Q?f8y3cWx//cGPk90QCK3csYMtMY72OgefQEmGxgxjmy275FU15WJz+xx05nhv?=
 =?us-ascii?Q?woaHUZDbevdqXzHTij8g2LXt/HMEp1ie1CC/xIiTRcPgc3E7+KZIDJSJHTQK?=
 =?us-ascii?Q?FxmAa1esQsjdhfXOzEGrJimbSs0DeDIgdWaa9i+FDVCmN9rEad44NoRMEwn6?=
 =?us-ascii?Q?EaRv0UVbMMS4x2SSetJq9Xes9Nalv8dSqXgfxmq+jQ6MefGjFvtLoYuixarW?=
 =?us-ascii?Q?4aEy7ijnevzemDBywc0ky3MlLQ+vlPjnX28Y9eAqtbTcaLTWqef+SgQQ2SzB?=
 =?us-ascii?Q?1UOrFRkE8FeZ+qMkl9D1dHGPreCGzp4xRl8WZqt4a7IewcLs3OC5HAvHlArx?=
 =?us-ascii?Q?p/EeWbJdDAHxsN2BdoIuNRSJU2OUFP6A7iILdfJQ5P8p+7C4fl6im31dQnNU?=
 =?us-ascii?Q?Ob67hNDuTq9hRiKpMVmJuPstMVt9m97bub5NGgg/2U8awPG8LY5hlX0kQrUw?=
 =?us-ascii?Q?lQlh1I/I/cbcPBuT/ljoQb8zHSZD3mD38QCm7fSYAtL9j80XYplVx98ZBBhQ?=
 =?us-ascii?Q?gVC0LKsGHOs9LZBMYd10NZyO95koZ/oOx6TN6IJyJTsXUFKoYFqoT64zDSAM?=
 =?us-ascii?Q?7PDHBs3lz1geSIMWsH13r7OrK9NA+MMM+DMop/LSbUeOKUYWEHsNvXcCTVpt?=
 =?us-ascii?Q?IqBLjj7ELF3sQDhbksaSyaKz/WWSR9eI3G4W6YCl6fn1n2TxvpVTS8SbXbk7?=
 =?us-ascii?Q?YQ4bo5SJ0px4NkFKcpNZ/p2qQceWE8ybVCFuBIjrdJSK/pukDHqsLCzLhaI1?=
 =?us-ascii?Q?5rWy2PTgJw7n0JonBRUoIBXjYaAfgNtNwYslmkWrUtxGHU5D9yAXit0qKdJ3?=
 =?us-ascii?Q?rxnLvM/NaGPKQWUg2Uun6vtD+EJaAqb4W8wAHxTuGERTeCE5DXqYWECg232H?=
 =?us-ascii?Q?XiAvxEsUyZquNu8tZe5pKL3fw6eG+jqRxGdPoWjno3BEW+TLwpsdSzaZACdc?=
 =?us-ascii?Q?R6Yun56RrOGXVufRuVxw83N4wlC1/oQkDlgZdEsJTv2lk1MkTt2dzh2/3CEX?=
 =?us-ascii?Q?N0pMRVBw3ZH3TlPPz56nkMUd95YfN+9ZBsHpS7jb1iqyjh8vfvJUigp9TU3/?=
 =?us-ascii?Q?+btL3ciHjORRnR4dbVPkrN7hD7QXT2qYJj8T/9RnenXycA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R3vFgsrHUCaP8vFdkuHJ8oMzRsUDQsc1tNt0UmiChWFzgpGFZpRtEq/dG+WW?=
 =?us-ascii?Q?NhyB8+wpU9z0nVgRpAOCn0UC3zyR3Iu/VpBGLaSSYd97p4+wYsa8FkJLDLV2?=
 =?us-ascii?Q?+ym71jgnA+/wU0zUgw+jpek4nrusEydWpyIQtK9dysDNCkPoWfGNEEyOf3rE?=
 =?us-ascii?Q?IShGVDUkC/WgbdKaBuBgAxflsvGWaQcUhH66WxwrtkfG3BuFV0SmZvznTHxu?=
 =?us-ascii?Q?wZgUgWtfgop624PrlYJEMmpcoMI0A00Zo2R6Tc+WZ5pmG2kzQWgcUOaYQe5/?=
 =?us-ascii?Q?Hi1/PXK3ZIUTaXpIphN6VB3kSGPO12pl7hBC/dlDL3cMjsvMnFeiMoU2shwF?=
 =?us-ascii?Q?9WBKnaW09trSeLZ+kQD56G8rPdAmoYfTA/SWyAO/FxSzPdbnGrwSrj5JHpoU?=
 =?us-ascii?Q?ozUnOH1xYmhVUlxh9Eh0XpwHWSeLYChuwPs4vRseUFlWQ7G4brx1axeHwl19?=
 =?us-ascii?Q?WLwHWNqGI8IllE7uD9AOAVhMWJV1OCSZ6EIUXHljytTAtdEfZs0eWNMSuZgP?=
 =?us-ascii?Q?AZbcwB1NgI8LJJoJJ4N79NwlNrB6VX1Sx3TUoBKTnxaxoEnMlTXu1uMzCMVU?=
 =?us-ascii?Q?L4EycBGe6IttdWTB7DpXgkgzAADgv9JumCDw0lIlltQ5ORlprlUmi4V1gV/b?=
 =?us-ascii?Q?OQcVVHzLJfhqVIkMyTF+RWcSnyu9M+M7QWn73pphtRpKQjBgkD2NGRAMYjlJ?=
 =?us-ascii?Q?vsrB8f8iq0eFCTkCBqJ+dmBoVw5IISN/3brM556aXw3G+uZ9I+N2/JdnWZpD?=
 =?us-ascii?Q?KrLC1M+f6xQdjIQ+36K5oPg5fmJm+zdRoFii17RGJYYNSuziPEC9cmnW3qEO?=
 =?us-ascii?Q?futu0gMKmIIwpr0vZg+o0OT5/QCOZm2kTOT9RaDuzuk6iXL7NG0Ugk2RlLWC?=
 =?us-ascii?Q?3SsyPq+yrhbNELiJAafDjHD7oZFWcE/1HmG5kQdBvl8sLZmfdwDVzKNpJAmZ?=
 =?us-ascii?Q?qT4eWdQSPqlY9JEicoOnqcsbwPaMaQ3cr8Wvvk/4lMusuaqmxCSQaWx0vgNN?=
 =?us-ascii?Q?x/aAYWUHrY4aa6Z6tR9gvEXHVqPHnKaV4YsKxxJfYHTYKyybkHnMqE9h6qjU?=
 =?us-ascii?Q?Hcp2XLR1+PnCYk7EVk7JpJ13xIKEbCvxe4gRybJi9uB1lfDk4ZSM2n+3yEIS?=
 =?us-ascii?Q?xGzBhg8SJro6nvcBWcjj6x4i4YAxJNkGdpDcQZooxBqpZMMETaQ+SXplgULZ?=
 =?us-ascii?Q?8j3ME53CCzihLhQWjBEWxhPkGSygeXTxj7s7YnsswvJGmRTH5vixzcFPDa9l?=
 =?us-ascii?Q?3KOQyJV8/7O32jpPkPr7nguck3I4xSXIyiHLMaDuQnHiYH/Ai7E6h8RhfIKy?=
 =?us-ascii?Q?r3ghBnNhLMgVF/t/gvfEapI761MYFOW3atVgafh/CkNxUxD2+MnYD/N2sNUk?=
 =?us-ascii?Q?sNRXhQUk1jE2q0I7sV1w0JKWnig/cvsOHBhpF3nawGYnjewpvaj5owIJP4g0?=
 =?us-ascii?Q?g5Entd9m/rltt/X7lbYutuJJVTYeD75n/I1IHZG56h/7yVxYMpnaZmeozSN/?=
 =?us-ascii?Q?1QmpiKonxpX4iX0P8T68Wf+1olnWaOZMWlngJEGDqTqRZ+K21Mp6iq6J4btA?=
 =?us-ascii?Q?KqT9Yd5PZyFoJa3GeRCZT2tntSLzO4q5gLVAVqXYey2JQN1Bcfxz11sg9C0U?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 610f8998-3e25-4dc5-196c-08dca656256c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 11:46:50.7745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f6msHUZReHw9LfKqnoSFe6NhnK8Wr60G3hud1byFieK1rwqne+YTpBePkTKSs5KWlSLO0l/MX0+JIcHNWGlDFYs97FKtja5WgtZvnI2uC10=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7710
X-OriginatorOrg: intel.com

Disabling IOV has the side effect of re-enabling the AEs that might
attempt to do DMAs into the heartbeat buffers.
Move the disable_iov() function in adf_dev_stop() before the AEs are
stopped.

Fixes: ed8ccaef52fa ("crypto: qat - Add support for SRIOV")
Signed-off-by: Michal Witwicki <michal.witwicki@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 593fe9abe88c..f189cce7d153 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -323,6 +323,8 @@ static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 	if (hw_data->stop_timer)
 		hw_data->stop_timer(accel_dev);
 
+	hw_data->disable_iov(accel_dev);
+
 	if (wait)
 		msleep(100);
 
@@ -386,8 +388,6 @@ static void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 
 	adf_tl_shutdown(accel_dev);
 
-	hw_data->disable_iov(accel_dev);
-
 	if (test_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status)) {
 		hw_data->free_irq(accel_dev);
 		clear_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status);
-- 
2.44.0

