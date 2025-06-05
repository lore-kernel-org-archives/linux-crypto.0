Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA88D28E3F
	for <linux-crypto@vger.kernel.org>; Thu,  5 Jun 2025 08:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749111184; cv=fail; b=aphPQccaDbrwkBxf9izSkVOuw28mXUE/pHVrEwib87AYo60QbxqTtfoA+OoT1reHqXNS0FnpcQMrrAlECnrV2pThjbQndk8hAQ3wb4MwKy1/B0Kluh8BR7zko/Wr76g03mUXqFvOQC1n64DhcSuyOGHP8dW+ZWw9yjz5deXuEF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749111184; c=relaxed/simple;
	bh=eE9z24P/pzTR0Edr5v+yvIfUyrsvbU886XbPWSsDDbM=;
	h=Content-Type:Date:Message-ID:CC:Subject:From:To:References:
	 In-Reply-To:MIME-Version; b=lwvtDzTD7L9g/s7ypUeloiNbfAsTzhO03HSWYq3E0ZwvKlr2iyl1O/YoaNZRKUOhY27yIj+6wjJrxj1roE5cmEUMJVJmAKJmQJ8axn3Z3Nfk52VUpREWrKBFJQoq2p/CuSZuUkNsDlJjQJEIKXAcukcQxuCcj99JS53eOS7xksw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GdA4gvHa; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GdA4gvHa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749111183; x=1780647183;
  h=content-transfer-encoding:date:message-id:cc:subject:
   from:to:references:in-reply-to:mime-version;
  bh=eE9z24P/pzTR0Edr5v+yvIfUyrsvbU886XbPWSsDDbM=;
  b=GdA4gvHa/EtPn0EAhOcKRevfNTsczJ08XDdMGjaCbq6x5JioJUCOxYnN
   9RZOy0fSpDb4Ze9RpeuougO1DexqDA6ZdEQsIhFKpew58njNolieTWK70
   jTcY3e9NcRHndAQsJnS41GIGUHeUfiV7Rs5UtPmyjVUp5pPuNFThvJhUe
   P/TSVL4FpyADl88Vo4Wx1T3524tW2RJTY9ocaajpf74AtaxpTeRj09oY3
   84rHhvosHYnEO0eYmadPXGjPVUXQRcQfUFysN8zFyH0+vSNhfhvgTtkW4
   dX5avDix/U/Y9mOCPlN3Ns5Usv+BUQJit/m2X6yziIaJqu8+8ehXzrO5T
   g==;
X-CSE-ConnectionGUID: sbsGVcAeQXCFsNlMVuMRyw==
X-CSE-MsgGUID: nwIxyhz4Sp+0RDaw4mbEiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="61838971"
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="61838971"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 01:13:02 -0700
X-CSE-ConnectionGUID: l6OcK30CSwmXle22gAJJZA==
X-CSE-MsgGUID: K7kmtx8mQiSJh52b35JwYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="145328434"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 01:13:01 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 5 Jun 2025 01:13:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 5 Jun 2025 01:13:01 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.68) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 5 Jun 2025 01:13:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aYge1Y9aP6nq09gIMdmBhA9GrILusFwHc2GjTrrKFRHKKJ8RRH2zIEO2U0Y40OSfB8PADJfVSjg/pmJGTVU18GFiNJPhOK3otBkgy7E9Fp0JW5GNw/n7C9z0H3vG8xRkPJDF9bsYjA2zHsAxhwK4bI9P1n1pWNPyxQZB7Zd+NRsWYXoGISB/onnb6UNWeprHSu+zp1HuzPqRR22lIsOMxbq5XA9xQKt0MYY05+9Z0mSbq8bjrUU3+FyMeWyDtSFMxwyznH3V03Cyre70hhQBkYZOtmr+89IY9KYhrl7DqOYkNLbmVfsWq89vW8HVCjJNKaKsM7/3IF8FdTYeORs7BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eE9z24P/pzTR0Edr5v+yvIfUyrsvbU886XbPWSsDDbM=;
 b=BWJ/u9hHW8BSPYyvlSz8sdWsfozHgmuV9Dm/OMxDxDa0HFcFRAJdptV5YtPb52kuWWvNyftjb33CMC1R4hHYn+j4m+Zcw7fSWgB+4lMyRte0vPaQmt79d5HtQNl1egEvjAEoj5Frro8H5GbaSNgssgcvJiBAVbA03/fuSk4q1Jiece9ian4WDGH5Gse6l0BjuIpW5K9uuRJTCOwtiSTulTpSn2oiSHrIW8LaMDb5FiS9U62MyY3OwR9+C+iJlEc3y5v0wAm3xDAK/euFvdZHZGgjGmsPZ6iMuzGyzAWGoXig+pSd4vwCasKHfhB845520KWQ9VKZAgy3lQDR+1uq2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA3PR11MB9254.namprd11.prod.outlook.com (2603:10b6:208:573::10)
 by IA3PR11MB9226.namprd11.prod.outlook.com (2603:10b6:208:574::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Thu, 5 Jun
 2025 08:12:46 +0000
Received: from IA3PR11MB9254.namprd11.prod.outlook.com
 ([fe80::8547:f00:c13c:8fc7]) by IA3PR11MB9254.namprd11.prod.outlook.com
 ([fe80::8547:f00:c13c:8fc7%4]) with mapi id 15.20.8769.033; Thu, 5 Jun 2025
 08:12:46 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 5 Jun 2025 10:11:48 +0200
Message-ID: <DAEG5280ECE3.2Q4NTA329MYZ3@intel.com>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, Giovanni Cabiddu
	<giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - allow enabling VFs in the absence of
 IOMMU
From: Michal Witwicki <michal.witwicki@intel.com>
To: Ahsan Atta <ahsan.atta@intel.com>, <herbert@gondor.apana.org.au>
X-Mailer: aerc 0.18.2
References: <20250604082343.26819-1-ahsan.atta@intel.com>
In-Reply-To: <20250604082343.26819-1-ahsan.atta@intel.com>
X-ClientProxiedBy: DB7PR02CA0012.eurprd02.prod.outlook.com
 (2603:10a6:10:52::25) To IA3PR11MB9254.namprd11.prod.outlook.com
 (2603:10b6:208:573::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA3PR11MB9254:EE_|IA3PR11MB9226:EE_
X-MS-Office365-Filtering-Correlation-Id: 57e2fe2e-7443-4ba7-2e1b-08dda408c0c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MEFXS0lCME02aG8wZjlyNDFNNHRheThteHN5MHlNUUNZaWtObmFEQlJ4VER0?=
 =?utf-8?B?SkFPa1lCODNnSGRoVnNWSndQY1BUR0lWTXhKd0VCMERCMldtUGZsWUlESzZy?=
 =?utf-8?B?Q3l5Z1F3bEJEcHJGYkpyeGpLYVhrN3VhSXlvYUdxZkNHaUlua2pqZXR5eFFN?=
 =?utf-8?B?NHcwbmNUZlpzUnIwVzl0U05BeGR4enYrQTlyUzdVdlg5M24wWVE5REFkcGJE?=
 =?utf-8?B?dzJBNmkrc3c1SWc1N0FmMGdLVTZ0RDBVUVhSbjRiY2xSUS9xNmIrZ0Z0VnVD?=
 =?utf-8?B?VG9DMUxUNVdpRVFidFNsZmd2ZWJSZ081MVR5TUpzWjd4dmovOEd3ZDBEdzZT?=
 =?utf-8?B?MEdoZlYzRGxITUkwZGZYaG1mYzJVZmxDZWN1elBDcjlnSVpSVWdtNE1XOVdT?=
 =?utf-8?B?YytrMjB1Z3BwNXEwS3lSeThwek95QTA4NjhhVXVsdlVDSzU0cksyc3pCb3lB?=
 =?utf-8?B?a1p2TmxkL1JxeTBSaUg3ejlPZ2ZrVnpHS0hBNkF6cEVzb2dhTUtCRFFCNE1i?=
 =?utf-8?B?eHlXdmJEWlcxVEpPSFBOeEtmakMvTDM2aTVjRjNxeG9aNkRuRW5GaldGdWlD?=
 =?utf-8?B?djFCZENWWURjZ1E1Mk1kSXdQZVVlUU9Nc1VUUmVHbUw3UW5ESUVrSmJMUUht?=
 =?utf-8?B?dUlrdysrU01YV0xrelVRUURSY0RBZjkxVmdXU3FOMmxMNkI4TGtJZWl2UWtu?=
 =?utf-8?B?UEpNZFdtaWVLUGN0OXhGc0N6cXZrakw0Mm05YXArZGMrZHdBU0hzUjFQa3Zj?=
 =?utf-8?B?V0dUNk9ORXBDYm5aUEdmeWZxUFdWS0w2T3dZTktsMTIyMTlERml6NkRRdjlN?=
 =?utf-8?B?YjQzRjFMNEI1Y3NsakRKbWYzbkk2bjNURmxaV24wNXB3cWNCUS9Lc3c1cUlH?=
 =?utf-8?B?VGdUWkp4Q2RGTDFUS3R5dWFXdWpOY3ArRDZZbTBFR0xPNllraHFnVzRIT1V1?=
 =?utf-8?B?Zi9TNkp4UUZNWkx2aHBVdlZQOXdubC94MXpjTmdQOWMzNnhRajVnME1yNUJn?=
 =?utf-8?B?Um5jY3dYSDhuMFlSVjJrdkhEb2hoMGZDWGJRdnBDVEpwamxPQ1R2SGRFYkpu?=
 =?utf-8?B?QU9QSjJQM1hYb2Y5d05HWjBzUGMyNVp4UFY1eGF1bVBvVHh6R09Xd3pDdEd2?=
 =?utf-8?B?ZDJDK2w3WXQ4SmlpM1FhblhTUGFHd0FMT2ZnRVM3RU9lSCthU1RlZWtoTC85?=
 =?utf-8?B?Q2hNNDYwM05GbzVCczE3RnI0ejZFQ3o2YjQyNjRBaittUnZ5ZTlzZ0hnZDdJ?=
 =?utf-8?B?Ritad1QvNHhsMGwzWDJhK3N4bjlYZVZGSmtLbUh5RS9uaDVIcHBpNmdLU1hs?=
 =?utf-8?B?Mmp3RDBJM1BGSWVZNVBEV0NFcmJOdGhKS2dXelhFUFc1eTlMRnIvSE40ek8y?=
 =?utf-8?B?Q3puY0IvWHh4Z0hMNDZSbm5TeWJjbUlwNE41MFFBTjlKblFmQlFFcFNpdmJ5?=
 =?utf-8?B?UVR0a2NtODljSXFJQmJ3YjNNekpvYXllVUE4L09vOGY1M01HSnNYTy9ERm9O?=
 =?utf-8?B?WHJIQnMwbXpwdjVWWHUwb1V1U01GcnpQaUlwRk1XcUdhNjVSY1JZT3pXVnpk?=
 =?utf-8?B?dERmaHhJSlZva1djcWpNRWVpVUZpZlVteG1BSnhISEQ3dFJPUkU2Q0ZSZlBD?=
 =?utf-8?B?aU5waU5RN3F4L1FxRFk1WmlnSWFiaHJWbCtCWk1ieFJYTDNYYzlGY3ZiQXhW?=
 =?utf-8?B?Y29QZDRMWm45aTRSUFhta1BoV3VSWnBtVFhXTU9FWVlPVXh4VTMvRWxzVlRY?=
 =?utf-8?B?T2d2Z1ZoVm0rQnFERVVwZFpHeHJWaHhFR1BwbVJyNldxRW9FRnplYnE0YUhK?=
 =?utf-8?B?aisycit6MXFiajFpT0VROGg1U2pVY0pLWnNFSXd3ckhNc3RnRHlZeUhBTDV4?=
 =?utf-8?B?aDA2bUlvd3R3RHdvRmk3Zm5lNzVpc29mWjNXS1d2dTlrSHNScklkMWw5Z3No?=
 =?utf-8?Q?SRGkjtLS66w=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB9254.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3dURUFJa0dUMHFIYXFiR0JOMjcvUEVqYnBLWkZTQXZTNllKL1c0RjJoa1Zl?=
 =?utf-8?B?a2cvY2pHYzF4bWw0T3poWWVaL3E2amFreDEzMC9FbWU5U1JjRHp4dG5zaEt1?=
 =?utf-8?B?Y0ZoamhTUHBkaTZSblVYM1d1cUZSRXFMaStjZlZSTW5CZWxvMGMzd1BaZ2s4?=
 =?utf-8?B?MDVqWGEvVVFZRzlrZ25nSUNaVVFQUTY1QmN4eUYwQlZFUURqaTBYdXUxbUhm?=
 =?utf-8?B?OVNEeThlazVWeHlGMTBLeVBVTjZoT3JZTTlJNmtTcVNJU0hvaE5nMW5Lc1kv?=
 =?utf-8?B?dlJhZGIyMEczTEVub0lRRzZIc29ZTTZMTURGZmpOZXg3cDdRVzF3WWc3UkN0?=
 =?utf-8?B?WkROVEJucmhwVjFZaVJML3huMGt0bmM4SkZRZzQvUUVNUldSTXhIYzMwS1NX?=
 =?utf-8?B?ZkM0Z3BNUVI2VGNObHBTZzIxVWF0UGdFUjNLRng5dG9NanJyTjRJTjRzVVF2?=
 =?utf-8?B?bTI2UldVQnBVZmdvRXNZOWRjbjFpNjF5OWk5QzZqdVpPQUZmeE5qQWpXSGg5?=
 =?utf-8?B?djVLa1RtazFTeUE4TXh2eHc5OXNrWTVJZGtUOTh2UGovR3M4eGhEb1ZyejFC?=
 =?utf-8?B?VmRhSjB3SkhYdS9RL2xITEFCUVRlcU9QZTlBNHk4ZHRrZ0tJZkFMbVRsODlC?=
 =?utf-8?B?VkRjYVhDdG1LQWhxTXQ0em0zRmFmcG1tTTVobTJYbjloMGl5N1BZUmlKSTJS?=
 =?utf-8?B?Qm1zZGRQN0JxWGd4TEZQWTFzN0s3V0owczl3cXV3bjNybEF3TlVzbUp6NlZO?=
 =?utf-8?B?RE5OMXhqdFA5YmZPcDY2eG12ZGVnSXM1QVV3ZjZKVEdnR3dVTXV3TXdCU2xD?=
 =?utf-8?B?VGVJNytVNWR6UzFjN0M0SGFRZzBna3BYbmU5VjBUN2krTHBHR05kTEdoZHY4?=
 =?utf-8?B?dGxVNWdLQ1E2M0RMZXIrbVQzMlZTcEsyY3pvTUFtTndCMmRGd0V0SlNicDVC?=
 =?utf-8?B?RmpUOStwNGlFWWFrVXU5NDVzMURCYWxUajZLdDhqZ2hBNC9BMkxpQVRmbWxt?=
 =?utf-8?B?WHhIV0hMbHVoZWFDcnFiekFKWkVrb1dzN0NiMFJ0T2dFamNaUERGb3MrRXhB?=
 =?utf-8?B?WEZoK21CYmF0aGxlcWdXL1VzOEIzTFF3aGtGUHNCOWszSU9JYWVUS0VPLytq?=
 =?utf-8?B?UjE1M2RGZm5ndmZyRVVwUXlvZU13VEdpOUVobE1oOWx0MDdtVTdKZncyNm1r?=
 =?utf-8?B?N1lNU3hqeDJCRjZDRktiWTU5L09WMk5NWHgvMk9CUURQRzR1RjhCSFhmWSs4?=
 =?utf-8?B?dTQ0Z3pGWGFKVGpnU0ZUYXMyZWU2NmYvSTNrWnhreG10N1Rkd0RQcUVwRmhp?=
 =?utf-8?B?ZTdBZldVLzBmUmJKYVJ0cTNFOVRjUWorNmJNQWlscTdWV2dlVENHczQvWFI0?=
 =?utf-8?B?ZFlSc3kwQnlhcnc4M2xuV0FPYXUxZ1BjWHBtWTFiNjlCYWVmU0N4eXlBZWs4?=
 =?utf-8?B?cTRZTlhCb1FXWm0zeEc1d3ZYaHhqMDQ1SUh5Vm9uVnVLMW40WnJMT0oxZGZw?=
 =?utf-8?B?UjZ4T0tXQTQzV3hidkRwNU9makhDdERPMHNEazJDcS9GM2pPQlNzMkpmdHFO?=
 =?utf-8?B?UnNscVI3V1ZlOFFlVjh3L2xadHYrbzFwNzFKaUhVWko0Zi9LVWQ5TlBRcGlL?=
 =?utf-8?B?S0NmNFV6VFZTMzMwMmVSNGNrOEp1U2xMY3lSYW92MnErM20vcHRjSFQ2TCtx?=
 =?utf-8?B?RUpjUURoYWdDSk1vdHZMMTdZRDVudE1vZGpYOUNPMVVHOFB0VURlV3hoNU16?=
 =?utf-8?B?UGFKQWxIbERURHkxNUN3cnY1eE45UktEczNENzhlRnkySENJeEh2MVlJSGF4?=
 =?utf-8?B?aXo0aUYvVjg4c1hlRlVBeG9JcEpXam5EOStnYTlUNmhMcmMwdHhXVEI0bWJ0?=
 =?utf-8?B?UnBzdkVVckVNbThDbytqTVAyeEQrd21rUDRZK09ETmRtMEdSTDc1MG1LdGgx?=
 =?utf-8?B?VmhSbXBJa0lzTmdTeHNwWnozRGhWQjdSNHB1am4zalVPa3N0OGx2S01Nd0dG?=
 =?utf-8?B?V3Y3Y2xPV0hwM3l5U1UvdlhpbmhiWU1GdjhpRTJRNkQxWFdyV21pYytnOGJJ?=
 =?utf-8?B?Y2MwbzlITllIRWJra1RSQVNOdDZzMkNNUm5NbWpkcUp4MVV1M3NheUh0SmEx?=
 =?utf-8?B?VUU4K0hsSm9Dd2k4SUZLN2M1cjdQa1FXb3U2bUlGTS9Db2VZVCtqbmx1dDVi?=
 =?utf-8?B?SUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 57e2fe2e-7443-4ba7-2e1b-08dda408c0c1
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB9254.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 08:12:45.9072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IievVNXbQVvDZ6ii5xzTMw0JIHr2Cccw+XeH2YoFBc6g54PTsa/XgMFcZ0/19H7WJ7FhFkOK9REPOnKTXyrtznSt+NT8W5pOupJfhGSmSjg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9226
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

Sorry for resending, previous email was replying to the wrong thread.
