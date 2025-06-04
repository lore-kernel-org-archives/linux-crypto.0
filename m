Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C199182864
	for <linux-crypto@vger.kernel.org>; Wed,  4 Jun 2025 09:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749029835; cv=fail; b=OerIdnNsqPW4WMLiNweTrmHFT3j/4qbF8QxVYbeg9lnxc9ZrQ8RGRqdSBxObdcUIXKfPhXT0UNdQPZIR2kNX2Z3mVAwDVj0kyqQqalX57+SHRb3Rtmu/+SLV4vXTRxtAXwIk2pxb9dwPxz1bywA7BZVtaD5wenPk+9woANkiGmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749029835; c=relaxed/simple;
	bh=TKrBfYxRdLWyNJmqKSvRGUCUdpRCI4n9JzET7a4zSoY=;
	h=Content-Type:Date:Message-ID:CC:Subject:From:To:References:
	 In-Reply-To:MIME-Version; b=Ozms7oV4W4b4OVJDPwonHYCV7tEUqYA/NtWZE6AfntIN3TcrRBL/wwcZqr+EFnpZfKpQo8VhiFX3ivTFrAwRrNjV3kLB5xJuMu7AdCFhN4ebaycggPjGqY062+EEsNCfFmJ3LtDCfWouw67vRljTrkhTdma8/DJTO+wy0At6UHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tfnwt5j5; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tfnwt5j5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749029833; x=1780565833;
  h=content-transfer-encoding:date:message-id:cc:subject:
   from:to:references:in-reply-to:mime-version;
  bh=TKrBfYxRdLWyNJmqKSvRGUCUdpRCI4n9JzET7a4zSoY=;
  b=Tfnwt5j50Y8APFNwQFPPFlzfpc3ofTibjb5tsWCaCm1bz3wLD23ivEY0
   QOhQcj5aNQG/siyEmKwVbG0AKw14bh7sPwUvvkDtrTCWQOLHlMuzRpof0
   fYB9EeBkJU+JwMOrbuAbC9av2QbXPIBNS9bV9BZxiPw7KxLiki7Q4uVTs
   Lq2yTDftr8u6vf3zbqQOCwyqHWio59ZbHaDUEeSuHF8yefyViW63vIhPb
   VY/4BLj86bG9Anh8cnTfdM2WZqMAECk3qlGEGpYTv15fMQM5/AWr1TaBQ
   2ql+7NmDVIInTyCq+mQZ1DXEcfylA7f+vWO54iYaBWRl5+bf/A5LRrLrt
   A==;
X-CSE-ConnectionGUID: rJvI7bgpS3O7I/iEY+RcWA==
X-CSE-MsgGUID: WEiQPr/JQYiP1dh2fFS2xw==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="76487737"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="76487737"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 02:37:13 -0700
X-CSE-ConnectionGUID: UG6DCwUjRa6emKiKSD0LcQ==
X-CSE-MsgGUID: mzcjvjpfQ4egajVXSD5Tdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="149922403"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 02:37:13 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 02:37:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 4 Jun 2025 02:37:11 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.55) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 02:37:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E7OdAuBXXoe+u+5J2TQ5rdxQMq27xU+9pMu4xHlWnHHcNLT0FdZ7WpUiok1H6SmW6Kt/98xyQGkhBFMF4dWoLucqNA/Gw1HmAsmYVsQJb4A7pFtM7pz755Qmtiq2oc8aaUydWZYx37fTs5Pkh5yu0koFjTFPOyF0insrQY5sqYJrU89EUMwCtTRoyIxOXxf2Xqfpeqf7MJkUiCoAMQ46rrrP+0JNR/Ox4C7NauoQyRBOft5dt8t0DfM7+sxM/dFN0DNBo/n/GvRiiULPkmfQFtDooxwcZHNbPZ3CrA3FcRRObfyCT1fYDKlSdcg4YvR/nOH7jkguID3tsUbVslW/bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TKrBfYxRdLWyNJmqKSvRGUCUdpRCI4n9JzET7a4zSoY=;
 b=JnXaGP1xMCAGX/331rjdQU3CmmvxPrI/UbZYsTNzX/BTVVyBfTd3OqAIDN0oyAjojrwyJjeZA2c+N0X3n3xpz+wcvYf/PcYFp0wSyX0qRxdMv0BxbCd0Qu1xulAfrQtMhzbNL6PnEA/uEqjk/uJo14A5z6xDyita0dBUE9PndRgEnkGa6YkeiLrbKlvJVyt6ADPyB37oeVTguO6hFK5TDECImrv0zHZylznx66HLDKtVgyVOHFTdoVy38Lk/iFiU9RugD5tCsnFzAEDq+xLxvX8OoYoNoTYHZc3eegXJoRwWC/D901N6cxIULZoB5j/QYWBKq4upjbvSDlCIxvhzxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA3PR11MB9254.namprd11.prod.outlook.com (2603:10b6:208:573::10)
 by SJ2PR11MB8470.namprd11.prod.outlook.com (2603:10b6:a03:56f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 09:36:56 +0000
Received: from IA3PR11MB9254.namprd11.prod.outlook.com
 ([fe80::8547:f00:c13c:8fc7]) by IA3PR11MB9254.namprd11.prod.outlook.com
 ([fe80::8547:f00:c13c:8fc7%4]) with mapi id 15.20.8769.033; Wed, 4 Jun 2025
 09:36:56 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 4 Jun 2025 11:35:58 +0200
Message-ID: <DADNAYLX03BS.182ZYK5TYJ0UE@intel.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, qat-linux
	<qat-linux@intel.com>, "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - allow enabling VFs in the absence of
 IOMMU
From: Michal Witwicki <michal.witwicki@intel.com>
To: "Atta, Ahsan" <ahsan.atta@intel.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>
X-Mailer: aerc 0.18.2
References: <00e74d37ff4d47bda7f425134b737a27@MW3PR11MB4569.namprd11.prod.outlook.com>
In-Reply-To: <00e74d37ff4d47bda7f425134b737a27@MW3PR11MB4569.namprd11.prod.outlook.com>
X-ClientProxiedBy: VI1PR0102CA0100.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::41) To IA3PR11MB9254.namprd11.prod.outlook.com
 (2603:10b6:208:573::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA3PR11MB9254:EE_|SJ2PR11MB8470:EE_
X-MS-Office365-Filtering-Correlation-Id: ca551684-8d7b-42b9-0ed2-08dda34b5882
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eDVHUTQ5cjA4TnZ4Qy9CK3Z3ZUZ4N05RcG16ZzlVdUFZcmN4aVlIbnBnY3Ri?=
 =?utf-8?B?aWhLWFBSSEZQZkt4L2tuS2RXUHFtOUZQV0tjLzlRN3dHK0ZvczdtajVQa0dD?=
 =?utf-8?B?eS9tVzlTdUNNSGFhbVBENWVMQU1aelBybmRzRzViaDNwdnUvYW1ONERLRERW?=
 =?utf-8?B?RUlSQWJSZjNuUDdadmFJMDdGdTdGSzRMTW1RQzViYnJLc0JMbWJMamlpRmNM?=
 =?utf-8?B?MzJVeEtPcUcyZkFmcWxzWTRUakdyR24xY3RoSEd6NmtZbHR3SzJSMklmSzl2?=
 =?utf-8?B?MVBXY01qQWlzUDJOa3dhMUhSZ2dQMUJFU29ya1dTS0dXakFmQWdRSjRiVEhj?=
 =?utf-8?B?SGJiYk1DUUN0Z3F0aDF2RUV0TmNDK0RTME1FZkQxMlduWnJrVDcrMERWT2c4?=
 =?utf-8?B?aW5QWHd5S1J3Yi9xZG8vMlVhRzZmQzZFcm1YSlJKQjJCQTV3Ly9pM2hiVUcr?=
 =?utf-8?B?THZIbmp2Q0xhbjQ2azNXOHN4UE81eG1uWjV5RWhpQml4c2ZFcnk4MTRpdVhk?=
 =?utf-8?B?di85aUdNTjc4MHc4U2R3VkMrOTFLRVdLZXdubHJoV2o5YU04ZldQZ3MyZ0xr?=
 =?utf-8?B?ZGN2R2taZzNzQndJRzlZaTZKUWw1SnJGZTlZQmE0NHQxUFlIcjd5RFZBajhF?=
 =?utf-8?B?V2FWYVNmNWpueFE1eHpBTVBtQndHTFdzQ0UrODQzMlFMNlUyWDU5TGpCNVJt?=
 =?utf-8?B?c2hnUjk1QUt0eEdtUmhLNGdYOXNvSGRMeVBpZkNpc3hRQ0NxajU4bWVmV0o1?=
 =?utf-8?B?aWZCTjEvQzBHaG5FZm1CM2dSZTVFS2UrdkhqK3VWTjFiUDNjdUMyOXpNQzhZ?=
 =?utf-8?B?bVhpTWtpWmZhSG5HSXVRQ1d2cGZxVWVudVJiSmR0MUk3L0k3WG9aS2o0a3Z6?=
 =?utf-8?B?cjZJbnc1STBBbUQxZ3lqZnVHN0hFYS9SQ3BqZHgrb3ZiU2xKL0RYZ2p1QUts?=
 =?utf-8?B?cnFOaWZwMHVab3Btb0dXM0s5dVRYVTlCYjNqSm8zeXlkbmVobllEa0xZZG5M?=
 =?utf-8?B?bXpsUWtZU0Jtczl2ellNb2FwYW9yNnd2K25jWXA5RWoybzAwcVUyUG9uazVQ?=
 =?utf-8?B?QjNQNFUwQjI2SjFuZXFTRm5mcXJzNnVMQ2JuMmMxTUo2N0lKb0RJTHhwVGtJ?=
 =?utf-8?B?M2lEMW42UnVtSXNZc2Z3NThLcS9XcndIWkI4WDVESTNUNjE3OFo5QzBjdjA1?=
 =?utf-8?B?aU14akxka011cGM4RjMyMkR0RUFjRG9uZEtXeFRkVFQ0UHVDR0YvWlo5T3JP?=
 =?utf-8?B?OU53UEZDNzBBVllTQW5QdWtURzc5RWZmSnBIZFJzRHY3TldwaEFNbXA1SzBp?=
 =?utf-8?B?dkxBcFJROWFSQWRkbVhzT0g1RExaTTdPR2FUcU5pK0N0Vm4vL24vZlRZbUMz?=
 =?utf-8?B?OFVDbDR6NlZnZTBOYSt4a3lWaUZ0MWtMUWRHcFNDb1FkYlR0ZjZlMC9mY1Z2?=
 =?utf-8?B?VkorcklkOVNPSGNYMlpvcWFodmEyWm5vM3dCcU50Qlo5enFZVlpLbzExV1RC?=
 =?utf-8?B?SkNuNCsyMUN4SFdWUjVDTk9ZNm9kV1IrTDE2RG92cGl6dFkxZ0phUEFESHRP?=
 =?utf-8?B?QWpWUG1IT0hPcWxUZFN0M3p2VGo2bFVVaTBkU0dJS0NqNUlmMW1udk9GaGxo?=
 =?utf-8?B?L0pkeDU4ZjQxV1BrNUlZUVFBNUIxYkNtNkpSdFR5eGIzdEo3NUNTeW56OEVM?=
 =?utf-8?B?aTUrbVNGdE4ybDQwbmdyL3k2OWlrL0hLS1NTUGlpQVJaNjluc2F1bC93VVl3?=
 =?utf-8?B?U2VSRGt0dTY3WDc2U2I4VlBua1hTUEh1QWZEL0tQdkYrMXRpeG1JS1BCeE9u?=
 =?utf-8?B?bllpaVFBWEd0aDk0bW9XRWFxbzlvTXptcFN5cWdZUUJwZy91T1cwakkxWmNJ?=
 =?utf-8?B?RkFXS1FUYit6TzNXVWc2MWVnVjdlMXdQMGNMZVVLOEw0Wk9vd05ZZU9Hazk0?=
 =?utf-8?Q?sz790+wWktk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB9254.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHN5UkgzUkpOWWdhNUJyc2l3Rm5uek5TUnNpMWhpVTRVaU56SEprY3JrQ0RI?=
 =?utf-8?B?OFR3QnNaZEIzMk1UNWk2TFp4UUp6NUdVMzNROU5jc004NGwwRlNPZjVock14?=
 =?utf-8?B?bVZmcDAvYkY4aVBxcDhVUjNTclZmT3FmUXViRFZnckdWVmpiWXNnaEx0QzNo?=
 =?utf-8?B?Q1BNWERGa3JtSXMyVXczYkR2TmhHNFNsTXRaSnZSOGNKUENiT0FUNDVBWUd6?=
 =?utf-8?B?cWkyTUNjZXhsQUpuWDR6aHRLM0g5c2dDRklqb3JDT1YrekpxUnNPYjZmU3Vv?=
 =?utf-8?B?YlMxUmwzUGlvQ2pKZVM5dXZZejlqS29iOGIwVWRrUDZRR092ZmlGK3Yvd1l0?=
 =?utf-8?B?Mm94M1crakhjVmJCU0ZrbjVncFJnd0pnZGNFNzMwOHRTT3RHTkpacEliYXBn?=
 =?utf-8?B?SnhEZmd2YmhpM3hHUUNLOUdHVFpkc3E3UGxiOWI0blVHWUdva2V1UVNncC90?=
 =?utf-8?B?MVBwTTNSQ2ZoekFlUkxtdm84eExST3pnTG5ldjlVV3VwK2hUMjFyVXlKTlVo?=
 =?utf-8?B?ZkJhMlEvZWV4aTdrdUczVk54U1dwcEtpVTJ6Z2llTFRnemptbVhqbnZlM05y?=
 =?utf-8?B?YXo2YkRlVGx2cU96T3czV0ttNzFXOGVPM0psQ0Vnb3J1TStCZTVRQk9zRFRk?=
 =?utf-8?B?TE9yOXZkUDVGK1ZpSFplQVkvYWFKWFI3REoySGtTbGg2ZUZ1c1ZnVzFaMXdG?=
 =?utf-8?B?L2xCalhkZUtOTVVYa01nSDRnTTYxME5oMG0yYTl4Y0xFREVRU2NWM2JSRkk4?=
 =?utf-8?B?K01GN09acFhHZDJVcE9Od3pTQXB4YjBMbUIrZi9jNUFEaStpMUl1RDVJWFNW?=
 =?utf-8?B?cU1CWmFsQjRpNFFxWE5yT29TUjRvZkdmdVZQcGwvNWlRbTdXNWdVUFJOQUk1?=
 =?utf-8?B?L1ZFdFhhWUhCMlVSYktoUjhWL0w2ZHl2TVdNNEN2R0lNUE55aVNTMFpsdjVx?=
 =?utf-8?B?ejcyZSt0YXpwVzBmb1kwejM3M3hCZnM0cVhuZWx2MjV4bm8xYmIwYy9GWG9Q?=
 =?utf-8?B?SGZvN203RWN2ZFE3OEFUTGwwWVoyY0QyQTJ0UjAwVUl3UWhDQXZnRk41MDNk?=
 =?utf-8?B?cDhUdkRkMzEwVEZMZW1RQ3NBd29GOWdDTC9lM2xOcTVPZFY0SHNXWndzVlhr?=
 =?utf-8?B?U1lVTkVhZFhIT1dFeW1wdG85dGRyY0xTbjlZam9aWURWd09tZmRnbjRzQm9v?=
 =?utf-8?B?TXZiMFdXQi9GSlR1Ym5LRmgyR3lhZUk0Mk1NS2pOOWFINjY1b0NlNWZpMzZN?=
 =?utf-8?B?dzQzKzVqUUM0YXVpT1Jnbk80L1BnVmE2UjBTanBuTDlHRVJ6RlRhZ1hvQVM0?=
 =?utf-8?B?VUFXSWZ3NEVma3lEUER2enIwNnlFRE1EYThSY2R5T1lDd0RrT2ZBWjIrOEZp?=
 =?utf-8?B?SkRUN002SldKY0NnOVhyRDMxRkUwalpnR1dwYjltY3gyL2p6TlZ0Q2Fmc1FG?=
 =?utf-8?B?OXlrQXZwTU1YY2dBUm04ZzB1YlRmNnZTVTc1c1pEUDMwSTd2KzRneEtvV0NN?=
 =?utf-8?B?bCtqam5sdnBNY3F3QjI2NnMxS3RGa1FSTWVDS2RQSGY1MHRBak1EZzg5V3Fr?=
 =?utf-8?B?eC9nakR4RjZRVWlTQ0N1Z0lZVC9WZDZrcGJobVNIbGZaM0RoclNQWi9LcFFJ?=
 =?utf-8?B?elduN3RmN2lvNklncWMyZ0hRMW1VMGpQNTBoK0Y1ekhpVmdQUTVYRUlIYjlD?=
 =?utf-8?B?QjFhc1o1c2NxdWtESWdMRlhFZytRTzNiT3pia3RNRzVhdXVIUGE5dUJJZnUw?=
 =?utf-8?B?dnRMMG1nUDE0ZGpJeHZLQ0d3L2lxWHFZTi9aYmo5aVBlMitpQnlyTTNsQUZM?=
 =?utf-8?B?aFAvVExrS05SYWZXZk1zVGFmbVRyWVlWUVpSTXZ3VXF3ZjEvV2xzMmlIMitG?=
 =?utf-8?B?MkM2cUNzZGxxaEpPb0dvOURtL3JqRnNGWHUzY2RwOU1LbHRvOVZuMjZReE81?=
 =?utf-8?B?eUhmbEtsY3l0WEEwM3lwekp3SWxHa2tSUnlkNHR0all4ZXFza3U5TjNXT0tk?=
 =?utf-8?B?TlprakZ6T3FGYVFydHlHZ3lNd2F3bnBIZWJKcElOeGVxWEdpWE42YktIMDZR?=
 =?utf-8?B?Y1lLdWg4dC84KzFxVmRqNXdrY3dhbXFEMGl2dkwrKzc3bHNuSmd5VWVORTBJ?=
 =?utf-8?B?ZGlMdDZyTHM3c2M2UDlJdkVIZmEzY2xOMVJrbzRxK2J6aDdIKzhISkdXTEgv?=
 =?utf-8?B?dFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca551684-8d7b-42b9-0ed2-08dda34b5882
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB9254.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 09:36:56.0556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ITuscLnAZhV2imaRltAKOvHrZiZX6Tv11ZIkKYoYXHNx9CwYs91MFgZwLW8eXoC4UYbRL96dtycKvWruuzgQmqPT7dmFnZcqcpug6nihu0M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8470
X-OriginatorOrg: intel.com

On Wed Jun 4, 2025 at 10:23 AM CEST, Ahsan Atta wrote:
> The commit ca88a2bdd4dd ("crypto: qat - allow disabling SR-IOV VFs")
> introduced an unnecessary change that prevented enabling SR-IOV when
> IOMMU is disabled. In certain scenarios, it is desirable to enable
> SR-IOV even in the absence of IOMMU. Thus, restoring the previous
> functionality to allow VFs to be enumerated in the absence of IOMMU.
>
> Fixes: ca88a2bdd4dd ("crypto: qat - allow disabling SR-IOV VFs")
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Michal Witwicki <michal.witwicki@intel.com>
