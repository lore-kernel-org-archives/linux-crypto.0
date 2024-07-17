Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888B913CFBC
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jul 2024 11:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721216819; cv=fail; b=GayLbdbn/ysiXG3LzQNdeCOnv77dYXOlSnDc0JkNTvXBGonvQPp7cnB38a0GdxO3lY+SWYjK59hLj1mq01Biqo4uXPFXShu57v5Sz1s2twK7/87dnKSW/8XmDGM41fXP7tr0Xq+C2GXJ7Qcvq0fAmihpEr9gTDSxtdtFpU7UpBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721216819; c=relaxed/simple;
	bh=1jqSK8/+2JIBb2/ir8Kc9ZeOEzChsqjrYVaYJDHj3GA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b/ijZgmPSVih89YRDMrassfJ19fWaoXiLxC2hXRAW81ucvE4JoS3+BYyq6u8PYgmTfbcfRl/PKQZ7wHa/OOraIyLK004xehS4p/gbEMIe82lI+nsiF5VjxN5/h37iK5NdfBHyaZ5zJ2xxe1lJ8pR31+HPAx0Yxfh6Z+WfPf+L0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FYcfvl1P; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FYcfvl1P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721216818; x=1752752818;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=1jqSK8/+2JIBb2/ir8Kc9ZeOEzChsqjrYVaYJDHj3GA=;
  b=FYcfvl1Ps62Ut0ADtktdHkikzt6ZQ9VWsJzKWzlXWBWALN1of5A4blTO
   JToIRkrHkrOJWirm1IIYanhtcdpZQoon/qWiM1PFy03EE6NbMpjpPRCHA
   IaywoRtjag3nYLLzPF9daIoXXs1CWUQT92gpIJfXnSEYcsXo2ArG+mC9f
   XLSZSS05fdwexS05oQIJtIjL3GRQYJMdyEQp6/zQGDCCWxbulKrOaYojT
   3Dl3Z6gyzH8UnyWxLyGGnNTFoqIb5q9ctWlfjbdlANv4LMwnur4LDJJsj
   zfxw7YZ1DkE7dRY2DsePtNCTCWMFNcoYlhdcUkEwRFsCmHNTbWsp2ulBE
   w==;
X-CSE-ConnectionGUID: IS4edo8NSMeJbGgSzFdRBg==
X-CSE-MsgGUID: DqdV58K/TfGfCHUhB7qzyQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="22572919"
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="22572919"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 04:46:58 -0700
X-CSE-ConnectionGUID: KA95izjvQ8a3I0c+p5TuxA==
X-CSE-MsgGUID: 4Hc05/hJSgqbrUgk++IzZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="55207404"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jul 2024 04:46:58 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 17 Jul 2024 04:46:56 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 17 Jul 2024 04:46:56 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 17 Jul 2024 04:46:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ujoltb28h5jBNdKQWe9bC2lul+JqXSkLCcZey0o5ofLG8mFHt07K3nQC+Z8jQrNg8kaVeOSm6E5fsT/0CmP7a6vXGGhxzMhZozNxm7p98m1J5ikN8YBioU49G5fmnuACx6JQ9eAjAc4jPqCITvmXCL47F7zSB5arMPJu9piZAh8qo+GVL3yQ8bxVBjTRouTEGfQ3dcQdLN/TQ9kfTp+AyM+k+mLLvK0UNcn/icri10Jv8RQe3VxwKKX3JFEM7qcWNAEU/WWh4t3iuk1dslMJMziH4DhAQEr+O6rpr/e3nKfJ4xSCN9PsRtNacqcW+aQbaZPEa5L1NNLwzuT9bbYhhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m2lw8x1P01pWKmRbH4dFHiCEwzy1fXOVtXWADSmHNho=;
 b=V0qiIwlerwwbU812q7ZhA2Kz5K9EgBt0ObMvH2DRPeo9U4nslPt6Wv/0WnLpOLlNDi0n76FJ36qfka0NNOH4mjn3tfVQWqZs/FXbgJS4Tqcv9/ExTT3o5NKnNXCnnvGohGG3it/DGkmow8hzgE667WLxioJdNDFUnaFhGbiMY6Zp1Zj+irlr7nCQeJv65jZ7FAR636PxsCMC2r7HR4l/jJpU9hrRt5AVqdV4Vx4zetrKERUoYv2Vxi8J7zUa278x+jm9A6bfnW0vVdku79zr/+NcJSW0HDdNLTOHeD5/IGOEHh0eVFYn6EutGD3lcQrSH3gQfbUaqupESAxZis2ZwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by CH3PR11MB7794.namprd11.prod.outlook.com (2603:10b6:610:125::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Wed, 17 Jul
 2024 11:46:53 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::c80d:3b17:3f40:10d6]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::c80d:3b17:3f40:10d6%3]) with mapi id 15.20.7762.027; Wed, 17 Jul 2024
 11:46:53 +0000
From: Michal Witwicki <michal.witwicki@intel.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, Michal Witwicki
	<michal.witwicki@intel.com>, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>
Subject: [PATCH 3/5] crypto: qat - fix recovery flow for VFs
Date: Wed, 17 Jul 2024 07:44:58 -0400
Message-ID: <20240717114544.364892-4-michal.witwicki@intel.com>
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
X-MS-TrafficTypeDiagnostic: PH0PR11MB5830:EE_|CH3PR11MB7794:EE_
X-MS-Office365-Filtering-Correlation-Id: a83cd593-9482-4bef-4f71-08dca6562742
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?cmtcOw4xa9cCFSxaDGAKmuwTqEaN9KeLerkYJ41CTxJvj/cubaUsIoSIDizj?=
 =?us-ascii?Q?HGI+T4d2I3sICLxByccU2dBv5XiXijuvY3yrVIbm0iooVUxS6N9Ymkz4qTa0?=
 =?us-ascii?Q?V3oRRzZzG8VvlZj5woLoWfnX80vZy2mtkF+p5qx/1sE5xMCiO3CgRQGxC7gd?=
 =?us-ascii?Q?3DbjdKKgFW5Tmd6E5IRwYtdl/Any/cIIPGTL8pjMoTriXyK7Dz7+I2Ot0mW9?=
 =?us-ascii?Q?x4fIvBd/hypH4j4qOjeuMCcp0twXBCzdrFZK/Bkk9Vqm3mDmn2/y0WlK1SkB?=
 =?us-ascii?Q?ZvB9xJZ/fSq5bNfU2Babh3b7VWIibqy47eK3JtNWchOgIsINn1/4H6OALk/w?=
 =?us-ascii?Q?GJAuSXT9Ty444jsDVrSogcFi0PlqohB+1EfBYqG/Nt9Ry9WfQOcaBZ20clLs?=
 =?us-ascii?Q?kklqPp29ipZQR32tudGAIKQ5P4Q25YmuiGMBhDxjJaDnrjzXQCXEWQiaSc/r?=
 =?us-ascii?Q?kquoCN7JNRfFDiZdEwB3DO7Vw7AvoeuEWyfzfyZHJ9pbuvrKwo1JS0T9TjBN?=
 =?us-ascii?Q?bV0dcnBn5adx5+i+J3CJ4EhWkrFJi2QDfGAXYcNIUxDmcJ5wUfTVY8RFemCQ?=
 =?us-ascii?Q?8uzX6UcQalLvtAxiMSgu4eLNs5vfoaV9v/8cleAKtj2fbJkiBEtBpbU2Q6Gp?=
 =?us-ascii?Q?LpQq9zdgHUt8YMq5C60W0vQq13IE3fQqSTQvFz2/sD04tVTE8p9dbsPOIX15?=
 =?us-ascii?Q?LDygUHpAJD9i92zTb8Ru2Bv3HqIXpgoH30I/LnT/ifluw0Sz2uKyIqz1wV5j?=
 =?us-ascii?Q?tcqABsAu/5WLTlBGY1TrMRbUDYEwmF+sxIjoZRF5pEcIV+u9wd0hFg3+9SSc?=
 =?us-ascii?Q?E7nR7Cn+AotxykMAUNJf/PWuJhDm62gkEJbfiBB0RTX9MpwVyZ3EnxYq/5hX?=
 =?us-ascii?Q?lAudpOwroi+zrmHuE7WMpAKhghv6LMmvO12Om+Fnl3nz1TLWbC1u7vYQvpS2?=
 =?us-ascii?Q?Trg3PmPMnfibDmDe8QiKk7MWvwIFwbYNUetoNsW9mh2O9oJ5uE7CXXWBEIwh?=
 =?us-ascii?Q?hrlbOFq7kYnDXK2T5AAaqeBhvJ7kxjlWJHbFPwEVP6kOneWGeihyB7enjZ84?=
 =?us-ascii?Q?nqPwW8uM+77k8siZKwYQ2Jdo7JvIywyzGU44Kp7kit1uA109Q7s4vlh7dA71?=
 =?us-ascii?Q?8L+f1xbcxmcVhw9STv+zvzf3tWM4XOY1YkAwfUX6fRzDUb2JsYBV3RFPnVMp?=
 =?us-ascii?Q?6HD864nNjzdbfYaEQgsB/+zBevLRAFSMH62WXpr3cOJyMuYQgsp5lWaZrxJn?=
 =?us-ascii?Q?CwDuIJBbTSpEoBgXpviHF4fpHErVUJpo5RyBRTBBJLllcA79Z8pEdAILx2zF?=
 =?us-ascii?Q?y9ogE4t7TXbh3jzZMdk3PdXllaO42ymJtLMWqNlSoZWmnQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+c/H0xMGjZ2XVXHuxWDn4X1r0hApUwPkawNAqVX4BnWA7AhZsL5/RSVXzunx?=
 =?us-ascii?Q?lHALt21IWw86QnUcVbEjHuTqRQE1ynkCziYPM/91qPWYlAEyIBABl9JrZbfD?=
 =?us-ascii?Q?YGIcRkMRRc8ZQSCrpeDgGsSQqIB6m4VsTTIXUXqLmjpHtojNxhT9hNUy+BGO?=
 =?us-ascii?Q?twiDW3pTV4Np3ddFczsqg5C9i+1j4kD0MOGe2NKwR4DKjzxCGU29Y339pCoW?=
 =?us-ascii?Q?T2OqKn00pu6vGNtfu5xXMbLtWgAB3Q1s9zbf/ImMlgNM90GARVfRynbTGfgw?=
 =?us-ascii?Q?a/LixdC6ZuGc/fOilmKfj+LE450ZwzvzhxRzjj1cBOOnv7U4N+U7NehTmh1v?=
 =?us-ascii?Q?ot3uvSxXoR72E1L9bD6Gq/O/vhUAbIJXKkVTaBG6fMiX28Gt8AtQ8Ztk8nUI?=
 =?us-ascii?Q?w8LxG/202+Ze8c9pKhurpcFpEkezUj7Z5YIW2MVKYvqeNLZZJr3vzOTru/vT?=
 =?us-ascii?Q?lnZSueN7Jnus0rTFF53N6ODUYZa/RF9TkT+wQ0chT7ZpdAVAV5Nx63apXZJg?=
 =?us-ascii?Q?wutQCqdGbmHmiLAZKnnra4VIIuF4gYkF1h9lk+S/qHbDEZwzWwWXfbRp4YZZ?=
 =?us-ascii?Q?bHdvzWxhcoXvtl4YZVN85mNbcRk0kcvvF9EE5+hnNmP+c6u5TrqepTfnqwVc?=
 =?us-ascii?Q?tcw1v048Yi5RDoAJ8xse5A6s0e/BdWkoPPB7HCJ88H+uE+XrhrhSvMaNhXGS?=
 =?us-ascii?Q?kd3OpOn15Ej4KzLcXy9nvkCyHIk6GlG49Wlu4GgGCIQI8xRa/04xku3zmXvs?=
 =?us-ascii?Q?vtJKC4RDmRlK/mg7hkOtAtZgtPND1V739R/BL0CYr47Jf1YDAhtor/ZIQkrh?=
 =?us-ascii?Q?i+VF5ec3Qvabr+nd9LV1Dl7V7/WV5MPjebwU8p5px3BrZuP+O65YHHEOucYg?=
 =?us-ascii?Q?Tjm8aAiprgmL6ZRGkR6DsZYZG61u/pSzQAWqKRnRVpZaW1NlJlrEW65Xwid6?=
 =?us-ascii?Q?GncJII2NHHHAIJUAkuhBzTFIQncNfh4YCSJa9INUzsTzxxWjB2gCsmbEvOpF?=
 =?us-ascii?Q?BMkTv6aaod4RML+2fq+MW3/MgmS7k74o01gyCmpf6Xig31mSiuRvECqgP4ze?=
 =?us-ascii?Q?aoqozPDvI5AGxkn1vIJJE2kq+9W9j/jgio7sYpa6kht5BLtaljyroVzz+6mT?=
 =?us-ascii?Q?R3lwJaeWLqZtN0nMCux8TwuurxTPjKnSBwLO3S/OegGQbd3ftgvPzCGx3vnn?=
 =?us-ascii?Q?fkKVbanaB8nIeEHzjVoW0bOovXRLDdPIkuv4WaUKJRByU63GM8tr6UKUNUaf?=
 =?us-ascii?Q?FGwmWFH2PTwKtEe3lkziQTI23G6Dqr7Oys4ot+aHrNNp4cbJ76aykg0jM5Xi?=
 =?us-ascii?Q?l4y7D/pUIo3T4aRamnnfDsbFkVoEAaepqG8wB0LHm28bNYpFBA2zusQdgD4y?=
 =?us-ascii?Q?s4Ap0ter+0EHM1l4ulxL7qYh2i+yxl4TGshGxR1Pq+cvN0Z4Fnyt7eCkaNev?=
 =?us-ascii?Q?AKrhGwQipWjAyzrKqAJ73yMezx8liId9ykepAiTk/VBMMarnXY206Rbkp3na?=
 =?us-ascii?Q?Zy9gUF0TyW2pEVHFAmmmWvCrpwD+ivFw1+nKXJnKmZSOaLWfsBCDuAA/dEbK?=
 =?us-ascii?Q?srCATNacGI2oTdxClimQRgW5rWvyV2Feb4RlAZ703F0jkWuoIBPG5FyJgUv/?=
 =?us-ascii?Q?8g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a83cd593-9482-4bef-4f71-08dca6562742
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 11:46:53.7181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7lm/xwBA5B9n51cNHf4haZeJHv1cKoiBWpLEGgFnquTcbVkSWChhGeL9s80g1jr7p8OO0Hect9gguJV2T0wGULNDo58FhAB4fTl6nuUcw84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7794
X-OriginatorOrg: intel.com

When the PFVF protocol was updated to support version 5, i.e.
ADF_PFVF_COMPAT_FALLBACK, the compatibility version for the VF was
updated without supporting the message RESTARTING_COMPLETE required for
such version.

Add support for the ADF_VF2PF_MSGTYPE_RESTARTING_COMPLETE message in the
VF drivers. This message is sent by the VF driver to the PF to notify
the completion of the shutdown flow.

Fixes: ec26f8e6c784 ("crypto: qat - update PFVF protocol for recovery")
Signed-off-by: Michal Witwicki <michal.witwicki@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
---
 .../crypto/intel/qat/qat_common/adf_pfvf_vf_msg.c  | 14 ++++++++++++++
 .../crypto/intel/qat/qat_common/adf_pfvf_vf_msg.h  |  1 +
 drivers/crypto/intel/qat/qat_common/adf_vf_isr.c   |  2 ++
 3 files changed, 17 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_msg.c b/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_msg.c
index 1141258db4b6..10c91e56d6be 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_msg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_msg.c
@@ -48,6 +48,20 @@ void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
 }
 EXPORT_SYMBOL_GPL(adf_vf2pf_notify_shutdown);
 
+void adf_vf2pf_notify_restart_complete(struct adf_accel_dev *accel_dev)
+{
+	struct pfvf_message msg = { .type = ADF_VF2PF_MSGTYPE_RESTARTING_COMPLETE };
+
+	/* Check compatibility version */
+	if (accel_dev->vf.pf_compat_ver < ADF_PFVF_COMPAT_FALLBACK)
+		return;
+
+	if (adf_send_vf2pf_msg(accel_dev, msg))
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to send Restarting complete event to PF\n");
+}
+EXPORT_SYMBOL_GPL(adf_vf2pf_notify_restart_complete);
+
 int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 {
 	u8 pf_version;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_msg.h b/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_msg.h
index 71bc0e3f1d93..d79340ab3134 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_msg.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_pfvf_vf_msg.h
@@ -6,6 +6,7 @@
 #if defined(CONFIG_PCI_IOV)
 int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev);
 void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev);
+void adf_vf2pf_notify_restart_complete(struct adf_accel_dev *accel_dev);
 int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev);
 int adf_vf2pf_get_capabilities(struct adf_accel_dev *accel_dev);
 int adf_vf2pf_get_ring_to_svc(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
index 783ee8c0fc14..a4636ec9f9ca 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
@@ -13,6 +13,7 @@
 #include "adf_cfg.h"
 #include "adf_cfg_strings.h"
 #include "adf_cfg_common.h"
+#include "adf_pfvf_vf_msg.h"
 #include "adf_transport_access_macros.h"
 #include "adf_transport_internal.h"
 
@@ -75,6 +76,7 @@ static void adf_dev_stop_async(struct work_struct *work)
 
 	/* Re-enable PF2VF interrupts */
 	adf_enable_pf2vf_interrupts(accel_dev);
+	adf_vf2pf_notify_restart_complete(accel_dev);
 	kfree(stop_data);
 }
 
-- 
2.44.0

