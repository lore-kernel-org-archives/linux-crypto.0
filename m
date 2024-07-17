Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8777413CFBC
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jul 2024 11:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721216823; cv=fail; b=S4r8hNPzOmY06fCo8ffCOLTJdP//WMaeorEiCtKXiED2aBr6//kg8HT8x7fKanodZALzs6l2FYVMaRMNomLVOr7wGNZA2AGXWGEUG9ie5Z2SThsBC6RjWamTCWkPOGMed4bf11NkZrZbWjsDk/w5FTCqVSF63byQGYoahVTvd0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721216823; c=relaxed/simple;
	bh=6sh2uEiv7Hd6FuF8MPeayrblto0+bZRTK4f3dIwrkhI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Vzwsl5vUCaXaraqfz6elFe3zQ+pg2vUKISVBJusmc1ufsfO9RzCvWVP8iPZMRm3zQ1NcF/FOmiysz0hudUcXkDPsObypg+DUAFGb/jGNg6pj+fXPnQzGegMsInRD2KiwbkvwI7rLHupamHc+dg6wKfF5exYQZhMaLX0JYA43j7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ly0uLilZ; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ly0uLilZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721216822; x=1752752822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=6sh2uEiv7Hd6FuF8MPeayrblto0+bZRTK4f3dIwrkhI=;
  b=ly0uLilZF/q18A3Hxz8jSLyrQUWzBbPebb1QqSaWqG5yaHZMpMVet4j8
   kHNFvZRD62/e+97AT/in6564SWHTwcL45gqwhJ7BnlQXnborBDFvChWZN
   GiftCr4FbCg3qglFW8o6uR3hK/7p5ddk/GWizeE+7oI2dJaanp3AJ+g4s
   nijEe5OWbWxFGdq1xa8ANEUxnMa/TF9xBmlDT5sGJ++hh/41kCmc92ud+
   kS7kaPbucdOG9kxMYevvZaIIl6LACUhozgT36kLLIQmxhmE5uocnVWcI/
   fn0dF124Ge+LisVyr8VjXCBMJPfIbNtuIln72efw7EbRFQP6G2IBUZC0V
   g==;
X-CSE-ConnectionGUID: 85MhiPETTtOwxxrB0vUQ9g==
X-CSE-MsgGUID: QvGhR5F3T5Ow2sCPGwFY+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="21617739"
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="21617739"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 04:47:01 -0700
X-CSE-ConnectionGUID: QpYATMZQRBKUXUwdeTZqmA==
X-CSE-MsgGUID: 3RfE1XgTTmW+O5TOr/DKMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="81406958"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jul 2024 04:47:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 17 Jul 2024 04:47:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 17 Jul 2024 04:47:00 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 17 Jul 2024 04:47:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m4AmYqUZHNCwLSl4SlOZkCsq+up7NXG8WbIt1Q6+tB58xROjC8cbtmusuQx0OxsiUAzby6+nfLCRafJ5EhqP3X4OpeH0TWAL35OTkeH3ce/AsvFd2wmbwwnzHiXafumkvaPLpkGrQtmPpjkSwey7rx38GiZ6K2fROQUGajAgKyEbAgWGxB3hJ+B9DhonRsmiRsRXl1v31QhvY1GifX2sEurWAanVQqIhGzWCPVkYPXPcxwJlMEt1REFKv0vra/Dy0fQIjHw6b62CVexdKmDJrlaOjn+uLt0eB6tDjXu7xKPOFs7Hjhu/UeqghyN+gxO3hN7lWTOBJGWp0Gu54CGLIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lHOGUz8HY2zAgr7fONQ5Re3zDb4pevl9lZJCtvdEH0c=;
 b=Y9HvAON3y7JXPstHt6dhKZ+yZnUlWfUQ618CBV4gil4QnE70WYJUQi+gf6k867peoDGe49gYVebmKBJMUnDlbrN4FFb2vC1j4hAgM9LTtJqMpycrjgGykNhkrki80/62AMXbn8N9HngqpdHHV4nN1Q2VhWnjkxZ8KJft+74g0ePqTOIrrV8QmIPKYXpxnaHFb3XNVl8NE55caDJQtmrn0DE4Pwxwej9xawUM6uk+zoke1ZVlnFTRIxhYRIvoV0oVuHXqfZYpI2c+DA6vFMFc/gDbVCqQrMCgCRQMaWWO1sIWpnoWYgamT0ODB1AbEJOA3SZ3hISC/BLVnx1pdM0A7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by CH3PR11MB7794.namprd11.prod.outlook.com (2603:10b6:610:125::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Wed, 17 Jul
 2024 11:46:58 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::c80d:3b17:3f40:10d6]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::c80d:3b17:3f40:10d6%3]) with mapi id 15.20.7762.027; Wed, 17 Jul 2024
 11:46:58 +0000
From: Michal Witwicki <michal.witwicki@intel.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, Michal Witwicki
	<michal.witwicki@intel.com>, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>
Subject: [PATCH 4/5] crypto: qat - ensure correct order in VF restarting handler
Date: Wed, 17 Jul 2024 07:44:59 -0400
Message-ID: <20240717114544.364892-5-michal.witwicki@intel.com>
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
X-MS-Office365-Filtering-Correlation-Id: 50013319-7c2b-4e7a-33d6-08dca65629d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wHE0CrDWI5t2tYPUoL+bQ4mYi9g6w4Km64KBJifmfK+sKzRkApgmJiFxgJ3q?=
 =?us-ascii?Q?OrTMlY9tKnwgQMedipV6ZJE1CNVMzTwAuNyMVxc1HRQ1zd/L0vSCnImgEUeM?=
 =?us-ascii?Q?ZlfPK/p7BH7VTZSwK7mVL/vmNqnyAVXt0L8AF0QGq0D80uwJ3XWtDL8ML4h3?=
 =?us-ascii?Q?nRK8BNMAz8Og0b++WUfwZXXSDjaNLI0pvByo5w7uRbpC2607Oh0PtMjfxqlt?=
 =?us-ascii?Q?sK7KmbdBD58B5wfJwk3xok9E4iY73hMfzPb1N8fclqzufxH3M/uItCFvDJw6?=
 =?us-ascii?Q?VOzDuaTs/McKFF7yhDDZF4ra6zlWBPVHNbNgpKfOaZOg7yMRGi0mn7DybsQ9?=
 =?us-ascii?Q?JFyMXf+Xv50BAn5gPkoiAv23vUCTeMZ4Hp7V7VjfSnxGun6OQP/zP572Alal?=
 =?us-ascii?Q?VT1ZxTvDD99ILVhgzrTgL/pLwFLWiONhfyBY9FIqp9BOmM6QakzPaqyPA0Zj?=
 =?us-ascii?Q?85HgSzzKYwT+MWg2szahHvFh2dZX7BcqR2csCqje1O5PmHv0RqixOQL+b/zz?=
 =?us-ascii?Q?jj1W2RprQa1bYcxiMdK/X4bsPiw66fO7QFqDDtFTKHZPWMcLzs732qNpimpD?=
 =?us-ascii?Q?KlktyuSsiZP3Xq5WamXxKycB7oEvI/ZnlANfSUT+o5zhVnIvzBRJTaonm3qL?=
 =?us-ascii?Q?2l/QXjkvP2HCoh/8mszsuslT6MIPHXLLA87L2DNThgXI/SfSju7UgGW79Si2?=
 =?us-ascii?Q?M4MZwpSLQzU5JMDV+gJe1vXN3VMsGTBNblIJlpRLNJdL85et2511dNQUEJxS?=
 =?us-ascii?Q?SUe4AC4UW26b1nFuPSFYTWt8k+2nyJiISEWpoqRPxAWxYxdHDDpS6Vzf9G9Y?=
 =?us-ascii?Q?Wgr5V3leTbWERG1dSwPS0P2Xpjjh+Jol7pQMcgmxePcNn/KgwLR639bf241o?=
 =?us-ascii?Q?kJ5c2nCv8wtALVWKQkPIyipIMPcpaY4dKaGQxA+gWHTYcXijOae+1EaJ0zG5?=
 =?us-ascii?Q?rMrPH/2RjUlrqOtI9Am7uCQRs+w4pohha5aMl8gTe8+ahnQg20XlSpe68C4K?=
 =?us-ascii?Q?WO+OVXPHpZxukk5ynaBrjxm3vNKu+iLgumICKRVyIYvaqGCAcij9oXUotYZR?=
 =?us-ascii?Q?1rOgzembbpF1Dttfzo0+zmfjVGl/QvqLfr6QFc0VuRvR/mjtJFbX8HTYp1Tq?=
 =?us-ascii?Q?t+Uvv/wJfSPjYLreG+IvYjGepK/SnPHZvtPKjYD/41AlvemJJomiczqKzWEr?=
 =?us-ascii?Q?542NpJMf4d/4hItQoS9YrUYu0I2WSoEtguNVB1fjpBC933W7SLv5XGz0L5mQ?=
 =?us-ascii?Q?Siq8rM88LT2kONxD6MvNlJFAL7Z+ORd8LNpvMghr/WbFiZ04KiwX8Wav/cmp?=
 =?us-ascii?Q?ku4K+kFUYmt52SRv6sWo8YOZgFqCaAfbFvPvRx5+VxnpJg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RrJJgoJ/yNnPkZBPx2BxIM3I2Hoq5JwTvpL/o2TXhFNCmcBgYp2DdlCM/vfx?=
 =?us-ascii?Q?EcOscPGJ7BDppBENrcLh9ZZm1CycNIy18GpMbOt2+FQ7XkBKD3ArWiDDOpvt?=
 =?us-ascii?Q?xU0/e0zTwrThAWH9IxmeEAn5dH3FiBNl+I1KVEDINOSh0+6Q3VWKCozHRav8?=
 =?us-ascii?Q?Jw25EA1oqcLEK45l4B3pguF2clGkosgvJgHQHJbqLRO/5+eepyckcag5puan?=
 =?us-ascii?Q?VVX3xikLhGt6Wqyl1ClknhCGTZkjoESBai6PWm8ZAuoAF/ASULCryZdLCWe3?=
 =?us-ascii?Q?HkkrzamWJHN+PeOZymij+V1qSH4oGwXe8wZ1E29htHsK5oKDuPKbuPCk6DZe?=
 =?us-ascii?Q?qRkvSQdnBksKDAxBtoB5hKJt2eQbee0pyAILd5neD1jgx4Nm3dkPOrB1ujfZ?=
 =?us-ascii?Q?Fe2i1zVYNavupDYeVCFCNUH34uOYFhDu8svRhUAyF+ghCtv7TV6XKe/kaRPG?=
 =?us-ascii?Q?Z4rj3BB6ZeFiZTHYvERdUaEpbFwdRI5zT4yU0AnupYsPX7h9xLCunOqYlqfa?=
 =?us-ascii?Q?zNosG9YTpgqep/crYgWB0hkK4bDx3qqu6GqG06vhNSozfzIQcgaJZv1ok1OX?=
 =?us-ascii?Q?PhtU2Mp3f5/v6muI53RgsW8mnIZf1p0PeFuoyTQ1ymUx28mNuna645axfcqe?=
 =?us-ascii?Q?KPD6i2fcq9aMSnjUObDTUFI66zmVCcT1R2qYMSD5nGLM9rJVzCq7teY3ggX1?=
 =?us-ascii?Q?enubSNbIPlERDMOw9+RlnstvO5JblUo7HH6Dm1RN7yvBq1zFhzMyVwJOdHSC?=
 =?us-ascii?Q?nEZk+dILv5cszN0DUs9xA89CW8S9quY99Xex55qQ9QsYI30G98s7FrUy1fVP?=
 =?us-ascii?Q?6X9aF42TfV2wsecZKAp3OTB9QM5A05wzj5Y5VNDqk0eaqhtuVhLHICvlls0X?=
 =?us-ascii?Q?nWZAWtmOLE3+bB5KpLmfX5lhTYG4LbwV0cL4nXo13SANiSyMBEKlc0Dx+B8l?=
 =?us-ascii?Q?Qhm4iIuuGAmcPQdbzA1aJaPqcLmaJGvY7ytEp8FEXPj/SXAuwQvRu17ND6aa?=
 =?us-ascii?Q?tpVtNpEiVbjfxJo0O2Ya+/YsJe7N4xrCYKJtmq06iziCEIboMFj3+ZKjnEGn?=
 =?us-ascii?Q?KhlvjV0jgdlSSffKutEmtPBAR7llPJIUedS2JKDeopWsvMPoPI9tOSrw/fQ/?=
 =?us-ascii?Q?U+/5nLEm2/x4nhwXp+mkOw7uLHwvxiOVqbRye0AmrcIxi5PelT/mXaHv9pJ7?=
 =?us-ascii?Q?VaMfqUKQsz+kzYB87KVVE9BhFqGo6MHMyjGAp9rUI6U6dXvmdUV6EeW1EN9x?=
 =?us-ascii?Q?KY9/zXwO2BJPdiKK/fJ4r5ZMAspYh7W6Zuk2CNv12rPYMvr4TP76liO9/o3e?=
 =?us-ascii?Q?WWFMTN3XeKHt00etyH6f/XpnT0E6k9wwfP1BuH7Zc3PBJj+cxJ1EgQ/iKZ5K?=
 =?us-ascii?Q?2XYEX/FZ5mu89ppocAX4TQHfmFGR8UTaH9WUB9wu5iuJwVb+8sM+LCJ4y4ml?=
 =?us-ascii?Q?M0oDBzYh/zimc8YJedgmiaBvOy9je2scM4tT4mKugsVYNJ2m+8K+JqUnOPlZ?=
 =?us-ascii?Q?qZMySbr8C/NJjRDTvf65N6N/lAujepHOxRcEjoCrvVl8UvojGG9zzkLHhQ+k?=
 =?us-ascii?Q?PpoM+zFi69RUbI8XQ3HxuRMlUNCO1DOucDfq0EgIidotycj6psw6SkpjDaA4?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50013319-7c2b-4e7a-33d6-08dca65629d7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 11:46:58.0303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /3K8JieZmM4eEjbO/MU+3ldlSw7060M3p3xKNHRpPddDYMhLedT/5p3Q2vwdVni32OXtjeuliWdBMcEjpOOrD3zo/waQvvs26M0G2MKuqG4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7794
X-OriginatorOrg: intel.com

In the process of sending the ADF_PF2VF_MSGTYPE_RESTARTING message to
Virtual Functions (VFs), the Physical Function (PF) should set the
`vf->restarting` flag to true before dispatching the message.
This change is necessary to prevent a race condition where the handling
of the ADF_VF2PF_MSGTYPE_RESTARTING_COMPLETE message (which sets the
`vf->restarting` flag to false) runs immediately after the message is sent,
but before the flag is set to true.

Set the `vf->restarting` to true before sending the message
ADF_PF2VF_MSGTYPE_RESTARTING, if supported by the version of the
protocol and if the VF is started.

Fixes: ec26f8e6c784 ("crypto: qat - update PFVF protocol for recovery")
Signed-off-by: Michal Witwicki <michal.witwicki@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c
index 0e31f4b41844..0cee3b23dee9 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c
@@ -18,14 +18,17 @@ void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev)
 
 	dev_dbg(&GET_DEV(accel_dev), "pf2vf notify restarting\n");
 	for (i = 0, vf = accel_dev->pf.vf_info; i < num_vfs; i++, vf++) {
-		vf->restarting = false;
+		if (vf->init && vf->vf_compat_ver >= ADF_PFVF_COMPAT_FALLBACK)
+			vf->restarting = true;
+		else
+			vf->restarting = false;
+
 		if (!vf->init)
 			continue;
+
 		if (adf_send_pf2vf_msg(accel_dev, i, msg))
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to send restarting msg to VF%d\n", i);
-		else if (vf->vf_compat_ver >= ADF_PFVF_COMPAT_FALLBACK)
-			vf->restarting = true;
 	}
 }
 
-- 
2.44.0

