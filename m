Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793634791;
	b=HlYCC2+tryPS/8K13IwGtdIticmRUOkHrEtgRGaQQdEajM/PJNnhbl1j3ypKAxa0s46Q
	 0YZSMj1/uTI2UFOrpxieLpVVSLnnoxkXYGmG/CLF6h6pIYJ2EPj2rl445fGRcJdoe14G/
	 3iwn2HuZgUy/+tbt1KTnbm9+s2KsbcpB1B7+4HC2N9pJ06Zs7ZhIzvu+veg5KM1V5Ww/h
	 584e4Ny7fAqiXAvhkK59fcI77T9HKdvhv/TlkO02PGTmuEnOYFGWqkaTNh7EffGRjR024
	 lIe1e4iUyf/LXpySc3wBOW4xX+/xpQF4OMdhvqMz8Wb+Fu/QVT+lc72UTj/4O1ItpHA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793634791;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:Organization:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=+cJFIVHbGZBBUPocZ24vxbcova4v0fH8BBfgynGkCz0=;
	b=nthGXM5WMhPeDcGrc1/klXIa7wN1yrd5+mifVYvViEu9+zpmQWoSgIgZKAhkITvphb6u
	 pk1BArSraotEKhDrRo0Va/kVOBsFKYSixO2mUEr6dy8ynKa2silKp7SSU4kwjRqramnng
	 t+MEApo03Xz3OZNA8HhXaN43AkSpkZZ51MeeGtD238M2WDF5AiEzxKORHwaRQy/J3pcJh
	 Q5NAk9/YHPyqA+G7Q18QuZDn8tPVCTBa3GhSZMT2J4xFGxZ1XPPS1kagfAckqE4+O1UeK
	 7ZoZkAyN9793zh1EWQmURSUgH/xZBk1FHXKmru+qItcbyrBBE2YdhuUh+fmQAVweydg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hKvXEuwc;
	arc=fail smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00599607A891;
	Mon,  2 Nov 2026 15:53:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00599607A891
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hKvXEuwc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793634789; x=1825170789;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9MAW17Gqrw2y8909G4BkpQ+L5A7brW3bslSYSX8Uy8o=;
  b=hKvXEuwce0X7lJDWvDMAKUCgQ0smptrE510SGgd95gntaphWr9LlPnYs
   bni/ynV2lozM/QWbID/mJaX73lGDPl69Q28KMdhEUgDVCvnaMkgSXAvrX
   0of0SA2QcINQ6w/QoLxhMOPM+HXFWskMRuNFMXYEBmDKFXPJO9jTON79K
   2dQz86NF+JK8fED8MOWJkwvAy6gzl8yBB1z3zAzukvNlTvDQ9EIMo5oSA
   crSXlo/nHBpZbb9Rjupi8DHVjEs70xNCCKIdx7wfYxS7nu4y4sfuZ1NxK
   ghjYrHOHdl13GEuigRhGgEMfOCljoOMLw3WMiVQMYdniO32n+i+7ijlLj
   w==;
X-CSE-ConnectionGUID: Jm7ER638QW6oyYMPnNUtZA==
X-CSE-MsgGUID: nV1qalsETkeKREd4tlpuuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11954"; a="2362885"
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="2362885"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 07:52:22 -0800
X-CSE-ConnectionGUID: jLGyBK9QTIaKnGcVa1N0Sg==
X-CSE-MsgGUID: 4bobHHcIRYqmtE0LtEm2jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="7924052"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa012.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 07:52:22 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 07:52:21 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Mon, 2 Nov 2026 07:52:21 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.27) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 07:52:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xi4T2j0rC6eR0WmuONqpLfeWNs7znnYVwRDFvSakNgF1WsVnQA2TrSzpJAstXrBFGsBPu7zbLaMJgJ4qBTtcoUKPv+2hIDh05ZF/ClQpFHUkmD1DIPy9AXt4BxiwVjg/yVz4Bug4DIVy3JO5o7YHr2YrUe0NfRc9saZs/uktXZBywdRBx99HuJR64hHMUzPnYb6T8y874+rtMbMIK0QAiWwZa2ZwNf0dBlIyCFOSLNb3cY/5c45NqOC4E6uMRYm7ioZ0EZpoIV4B8PbNdt+7gZLxDzusrSch2Yp0YG1A65YWpvZyu3bKXt8uW7ZlyEkIeXV0G+0zGKYCy16piR9M1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+cJFIVHbGZBBUPocZ24vxbcova4v0fH8BBfgynGkCz0=;
 b=FDMsUu/D0r50hdDos9v/69JcMs1iqj9MBhewgXM/9BPODZxd4sY8V1OWIxsp+MVTzsjGT3IZFeloD3j0fum58cIwLdMoIsWJ7PribmK+JJmlcAzwNQZOfr61L5nbvt0mZ03IEc6Bh3tGdue23SPi6xlMphu5pV+et9D2TW+onNAw8l2tyHRqin1xnvEyK7KD2zLQdRiJPluEG+3yHUC0yWht1mPUJ6jfe1XHfArR2jvBIX5j6ZZ1PsWvVlNnncoipi0mldpDFZz9C0Qv/+k573q8PUd2qVGkj05eF7V1famBaOBoDWe7FVzkwqZLm43p7Glr9dsLdB0RVe/+PmhKDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH4PR11MB742795.namprd11.prod.outlook.com
 (2603:10b6:610:517::15) by SJ0PR11MB5120.namprd11.prod.outlook.com
 (2603:10b6:a03:2d1::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 15:52:19 +0000
Received: from CH4PR11MB742795.namprd11.prod.outlook.com
 ([fe80::4bf1:7579:c9da:77d5]) by CH4PR11MB742795.namprd11.prod.outlook.com
 ([fe80::4bf1:7579:c9da:77d5%5]) with mapi id 15.21.0569.008; Mon, 2 Nov 2026
 15:52:19 +0000
Date: Mon, 2 Nov 2026 15:52:07 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: ZhaoJinming <zhaojinming@uniontech.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<qat-linux@intel.com>, <linux-kernel@vger.kernel.org>, "David S. Miller"
	<davem@davemloft.net>, Suman Kumar Chakraborty
	<suman.kumar.chakraborty@intel.com>, Laurent M Coquerel
	<laurent.m.coquerel@intel.com>, Thorsten Blum <blum@kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - free dc_data with kfree() in the error path
Message-ID: <auixpy8UTqZ5zKNe@gcabiddu-mobl.ger.corp.intel.com>
References: <20261019-qat-dc-data-kfree-v1-1-b294cb951a77@uniontech.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261019-qat-dc-data-kfree-v1-1-b294cb951a77@uniontech.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0121.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::11) To CH4PR11MB742795.namprd11.prod.outlook.com
 (2603:10b6:610:517::15)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH4PR11MB742795:EE_|SJ0PR11MB5120:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d153adb-81f1-4d42-1b9c-08df38f94652
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|10067099003|56012099006|261102123227099003|18002099003|261009223027099003|261022105027099003|261021121427099003|261022075727099003|11063799006|261028144727099003|261026121527099003|261026140227099003;
X-Microsoft-Antispam-Message-Info: EszfxSJy+E4+Dttnr4CKLf+dm6qfJATw+5UMOVsqjCW03rOIBSQi2ywrEIVKL7IsHF0yC6JkWAnsOhykCJ2vHFxiuXqXP6qMuBjWqerpILQOoFAVP4t4a8uArgJKpdaqImlN+IPZSECKtVzXAsam8xXwhB1t46WWn9DMD5Q65mLAhy1OuZOHb9pNWIAsI9LC+patlMEf3kd0xihwwPxiiUTkmm6Ej92iREHC6wP2Gr84jAIObRwRFlsWW/6RHQA553pe77aEKG5FWQQzQGJ/Wfg1ex510BWdSO3+NKHElMPxJ1HoAK8zbPBoL+Xp9kiSHCfDP8HMcn3dOAqAeUskTyyj3rOi7CX1ue2ZVsF0eRBWEgG/GW+9DQkqaVjGr7K6MP+LZcGdt0TukuyYkkBqHgzPznMLC1tCfIu4PCjY3P095GWy+bFMK2esD7dAiq1sHRl1EnUD56Yh7JbK6Jj5hJj/S89OOBtVQvIExj0c9lqG6BsUZ9TwfdfU5q3EXEWJIEO7T8Tq/gbuAZo5hYvTm5iZ6hQgIwpDy5MihFaiq5iermUoa+JpvD0fk6CS7ZBhRgahpXfEporLUIMSL/f1AkMKPB7d2Evi1P7/4xhoojsO85XSSVapkXNT0bikYJ+Dw4ffAbg9Mqz7R8ORG4HFeU96ePajztev3eJBJRB6dzU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH4PR11MB742795.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(10067099003)(56012099006)(261102123227099003)(18002099003)(261009223027099003)(261022105027099003)(261021121427099003)(261022075727099003)(11063799006)(261028144727099003)(261026121527099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZbOobzH+6JbGrV2fsNbtGoDLHiODk+RkWAGKcREQ3kSiJi+7B16d8zvOX6R2?=
 =?us-ascii?Q?uMeQQ+JmeFlUURI5zCHDG/BRHsPt1ZNInZtz49MUPosfUT4VOBxiwYN1v+e1?=
 =?us-ascii?Q?TCnZ4ZqK3BfEm7z0rkqhPXwenCjFBmEq/n1Yl7Qo5w6h3UlpmEjiwb2VILP8?=
 =?us-ascii?Q?4OZQIQSfkPY8UzBoztJmkE3wm+pPX8xe3fj8yxdtkDQgFskq0EFq7D9de2xJ?=
 =?us-ascii?Q?bpiKaWCIE6kfZ3gneHfT5nM3JNk89R9uCBkFq8kiUtmWsyqw54jBd/ANc2PL?=
 =?us-ascii?Q?bSEYqdnLmETSSdNXtCsdPWpF/+S8X1nLXucRnVQatwQJm9Y0haDQF7+6Qork?=
 =?us-ascii?Q?N55LM8rzI3jA2WCECeeIpwnDAlcheWmTys6c9n/CoRqlgLTDOfVW0tpAW6eG?=
 =?us-ascii?Q?iLls6jGUXD/aXL/jHywi3ug5Q9pL6sK+PL5s5IL98rywv9oDJF1GKRpwenby?=
 =?us-ascii?Q?pEegp+3fMQv6OMk1LvWuDINl9N1SufKtgTSmjWaTZxETYmITt9xS8xConGDm?=
 =?us-ascii?Q?zCGRcAzvlZffiHKPHobGHJGfSwC+dg3RiBSAR2L/KRzQQOpyBejfUnNG7mVw?=
 =?us-ascii?Q?7gQf3UYUarw0yK1v4OJH8mb7SxIWTZFB2PohEukKymPANYXLWpuPQ1ClWAwy?=
 =?us-ascii?Q?Tc5BiH/+15zNJ/mDoNNkRX2clhnlvmZvsLDwBL26fE81XHtg0qeqnM7Tidju?=
 =?us-ascii?Q?djXmC9bE4w4ToO2SRWDoR5Xi2EQwZZeQhmAry3eHE0SliJx9uzqDzUQxuCdf?=
 =?us-ascii?Q?wfbyXhysgiIu/CG8ZQMKLcyCNQvKsH0EDS0M3P4bSI93ZWJGFkTBs5bFrN1k?=
 =?us-ascii?Q?qrGt+jedGUgEAY8oyEwN1HlNMaV3aom3WW1eozWTrCpL8zai7hK+5mXPLyLR?=
 =?us-ascii?Q?bFeFUYDPKBQqkXhxV3+nEVnq7Yo5PBCua0+xy5E/08Ax7VSGE3dC8KZgsMQH?=
 =?us-ascii?Q?NUMdUQXY6L9rhC6WKoOBu0BRCY5Hio7JvrFkPqwT4iM3ck923hsC7mCXJsk9?=
 =?us-ascii?Q?XurPCxXUUBrmptg5z61nghwHooZZjLjx/yKieINK1XFpaBnEVYfRVWweAiVe?=
 =?us-ascii?Q?L9A6xKWZJKqzunp9HoaK6+ClwMLQ9QEsv+wmJMMG3t1qegZXLBSmqfDWKeqR?=
 =?us-ascii?Q?C0kwGyOynh+kC7k2k4SmZSTJPMTU0KwRUKP5FpYr1MgiYNvswEb+BfFcOZ5C?=
 =?us-ascii?Q?gcBezokKTKtnf8ZpBrtXRMzPz8hohRrrIGJbRlIqkQqLPk/IHJbAcFll0GKS?=
 =?us-ascii?Q?UNnQ4FZC7i4NewBfcmD/jh2UptF5SKpkR9Lv9GVui6j4cmrQWk6t5Hn/J0n+?=
 =?us-ascii?Q?xwsEZzuDHcAxTsKK1YFAHtzM76f4v79MB3a5TuVhopGbg45vMH+sIV89ACdW?=
 =?us-ascii?Q?md/GrLLu5hyuQCdTrUBY/y2ZeuFEJ+p1agYq8W+2HjWdz0SeoUWWwMYtmku1?=
 =?us-ascii?Q?KIyUe1I8q6e5s6I3sBvfTETCtKWUhHGYygeviyBgXo7isXiz+FxEL+LZEflA?=
 =?us-ascii?Q?d0RKq3IbqtofWtJIqWWsmaxiDHkriaGyyLnRf95KzaV+z9kOFmvdYsZOdDTt?=
 =?us-ascii?Q?F6gqEQ3r7KPkLeCc5qJ39HRZbd59/HBmQ7bDNWYgx6+ZJ0Iyla0D2EjbPYUF?=
 =?us-ascii?Q?MhjLw08ZxswJnO9uQjHdAzNT0OmESKtDwBLcRQj4+ylKv1utZZjSDgxzYlKq?=
 =?us-ascii?Q?JlDGQzHZn7fNfDAvgpUzKVxxdanpEuAXM7RPhVVjOnUdyIQTyE0WYEAq0nE2?=
 =?us-ascii?Q?Q80qu+998V53izOZ7QE2Xg26KpWausk=3D?=
X-Exchange-RoutingPolicyChecked: yHffk6qdU01qGLOnwlKUFTNje8Ux52oicTGxRn8GVdLT5DlH9CI1UN1KzGnWKFWM73PwHxz8XJ0px1XNx1j9Q5XAMe+CBFhchAQmOq52UhXniL8ONqlg24g7xhK5DH7p+UloyP4Gf5eL7E4YowJ+w6KMpMo8nFXQONb6mkYO1GS/gWT2OGIscYdGJS3/HG0bxgwN4QiIAezPnEPUPMhuCmR9hN5xz2OYkyYYngagXgEqnA1cWiaPInu8kPJ+UdvRtyVeSD/yPRM8h5VAcRL1ygBV+sKuiSWtfJSMpI/qAhb4JClXVnvvva3IBH7f9CkBySVODqNsyrLxl5LdQuzTHQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d153adb-81f1-4d42-1b9c-08df38f94652
X-MS-Exchange-CrossTenant-AuthSource: CH4PR11MB742795.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 15:52:18.9031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: enbicJXeA4z4U9S7LFv2lHjLs9jmKCRVPHZFgjRhOQibB8R+QhUjzvIShYif4z7BDDG3vIVxsS8Lciy1MGhp/TRT13AXcr0P9vO/JLK/UnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5120
X-OriginatorOrg: intel.com

On Mon, Oct 19, 2026 at 01:51:32PM +0800, ZhaoJinming wrote:
> qat_compression_alloc_dc_data() allocates dc_data with kzalloc_node(), but
> its error path releases it with devm_kfree():
> 
> 	dc_data = kzalloc_node(sizeof(*dc_data), GFP_KERNEL,
> 			       dev_to_node(dev));
> 	...
> err:
> 	accel_dev->dc_data = NULL;
> 	kfree(obuff);
> 	devm_kfree(dev, dc_data);
> 
> devm_kfree() only frees memory that was allocated with devm_kmalloc() and
> registered with the device resource manager.  dc_data is a plain kmalloc
> allocation that was never registered, so devres_destroy() does not find it,
> returns -ENOENT and devm_kfree() ends up in WARN_ON() without freeing
> anything.  The dc_data structure is leaked.
> 
> Commit 4cc871ad0173 ("crypto: qat - use unmanaged allocation for dc_data")
> switched dc_data to unmanaged allocation and replaced the devm_kfree() in
> qat_free_dc_data(), but missed the identical call in the error path of
> qat_compression_alloc_dc_data().  That path is taken when the overflow
> buffer allocation or its DMA mapping fails.
> 
> Free dc_data with kfree() here as well, matching the allocation and the
> other release path.
> 
> Fixes: 4cc871ad0173 ("crypto: qat - use unmanaged allocation for dc_data")
> Cc: stable@vger.kernel.org
> Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Regards,

-- 
Giovanni
