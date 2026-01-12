Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6196D358D00;
	Mon, 12 Jan 2026 13:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768223646; cv=fail; b=DGLCxLo67xJGc01BWqdaWCVpHe8/uuTQc45ISTSmuWI1zSbUJhB5XfhC20lAbvH4dgh3mMIHGQovE467jrX2+QqydEzo5luy2ATLp9QQoZaTBksmPIic2+ddt63PtEpCqhFT54MMfDqdULRyTbnndOr0jd+XySejh7mG0gnrg20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768223646; c=relaxed/simple;
	bh=hJeUeqoPzcBfGZ1NraVfzaybXNuJp6YPxPCtQvSUvjo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pAkhFoWht4lJROP1of8hsc8VB3YwAgg0JVCTDygAxqY6GE5mviGzu9911V+CH6M/9VS5y+gCcN1beVsGcQMYlFUCWD3AfmKN3jaHQzdZZvvvBGz+7qMgYPRBJiaI8GmeBGkLbUJA6yKlASGdi4eZAq0VdO86N56+w96IaRVTBZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AAzp165F; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AAzp165F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768223644; x=1799759644;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hJeUeqoPzcBfGZ1NraVfzaybXNuJp6YPxPCtQvSUvjo=;
  b=AAzp165FqteoIS9Js4B+NneM7sme6jJZKy94TWdUmUpqVwNsw+uOqHRW
   1hZnJKPeJeywhkXJoMbO0KhTgsNlEBx4AXqsJVa7XQw1ckQtYp+AQTDSG
   +0bjRwfc5QA9EqLE+MVyDRRZklNuECxDTUA2u9JWNuiAIEK9ChGKYGMlS
   Dcnycb3+aUL8QGoHp/ErfhlOxK1R4XBpU8nOyBq8ZLMxCRj80P5B8jfuE
   8Xx6kwq1kYft5oUsCAsjjGr2S1tI0+Kq3oExLqi4vFWmclYOQs3iNUbcX
   wQP/OlLbSNslVIcBQDM8E2TReMi3+z3nhzMEwbhBpr303f+zeexoJKxji
   Q==;
X-CSE-ConnectionGUID: h6yYjIEpS3i/P/4eB5gDVQ==
X-CSE-MsgGUID: vxzGxm0eTjO+H6gIdz3Nmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="69422589"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="69422589"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 05:14:03 -0800
X-CSE-ConnectionGUID: YWJnccWjRAeNc2vKCv5O0g==
X-CSE-MsgGUID: /rkuEopeQDaiQFXff4nzTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,221,1763452800"; 
   d="scan'208";a="203893198"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 05:14:04 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 05:14:03 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 05:14:03 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.7) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 05:14:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EuzFoOpSWCBJic0PepavpY2lKry90UP8qcFIBfcH9rmjgYwRHDo42tXgx0uTZU4CCbdU5XmbdawaZagGSPVcrovimOItoRUqq9FEjDAYSOxgD9bBSgkub+LtEYmBMrVQIN+3EXZCLowKN/58Kmrb+p7gZBYJTKRlvkjQfMth4KsrkyUKYUNfeuqm24Yqqg9PLNdWmA1cmt95VxAMM7ea9LS2Q/6hzt20NZGjTxlxQtHgzvNmI8NYjjQfkqoUXV4/tRVnkbXaEgIj15o2o7khslVlRtiXV7lTyAJBVz8LNsuM+K2q/RgzrOtyV+LyN+tdyq7c+xh4mGDLYfcMYjWyAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJeUeqoPzcBfGZ1NraVfzaybXNuJp6YPxPCtQvSUvjo=;
 b=KQRCwCZBde0ygwD7daUnPZCNKXfIn0rjnkjHYDP90/5FKNH5Ux3VoElMO2fJWzeJkGqcNsHrxdmMAnjWQEIHyN3SUtcZn9mTEOepK29VHb59D3w3WJcEXueqnr/qsOMkdKoHLyRGPUJMEHjrp053G8VQRhYZV0W9CiKo/wbvCbB+qP8z7K8olYKQvDApcjLkE6hE9qzk3F7Dq8lU0QVGLVldMzyBzR0sxRHRHWjyMOofsVS3kwAmKGuDKvMaGIFKoXy4vdwoCsEQD+V8sGkPHb488tE1d47aJvSgj9NIYSX0CyhpkTc3g9KMVE0+HQeZxVkJfORAImjgDpfT7/jYmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CY8PR11MB7825.namprd11.prod.outlook.com (2603:10b6:930:71::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 13:14:00 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::22af:c9c9:3681:5201]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::22af:c9c9:3681:5201%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 13:14:00 +0000
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: "wangzhi_xd@stu.xidian.edu.cn" <wangzhi_xd@stu.xidian.edu.cn>, Herbert Xu
	<herbert@gondor.apana.org.au>
CC: qat-linux <qat-linux@intel.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Cabiddu, Giovanni"
	<giovanni.cabiddu@intel.com>
Subject: RE: [BUG] KASAN: slab-use-after-free Read in adf_dev_up
Thread-Topic: [BUG] KASAN: slab-use-after-free Read in adf_dev_up
Thread-Index: AQHcg8TyTF4a3412UE+wpcOfMoPrwbVOguiw
Date: Mon, 12 Jan 2026 13:14:00 +0000
Message-ID: <CY5PR11MB6366E30B590833A634B453018281A@CY5PR11MB6366.namprd11.prod.outlook.com>
References: <782a4d0e.c456.19bb25459b4.Coremail.wangzhi_xd@stu.xidian.edu.cn>
In-Reply-To: <782a4d0e.c456.19bb25459b4.Coremail.wangzhi_xd@stu.xidian.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY5PR11MB6366:EE_|CY8PR11MB7825:EE_
x-ms-office365-filtering-correlation-id: 37fed55b-fe50-4cc9-fa3e-08de51dc7350
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?WlBmckt4QWVpWGhhUWNwZE5LQmoyQmlaNm9YVmpsbEwrMXQ4RU9vSnlkWS9Z?=
 =?utf-8?B?N0cvckQ1c3FFc0xjcFNwem5vRVF4dUIwQ0lnejMvbjJjdjVOaGN4d2ltZjFQ?=
 =?utf-8?B?Q3pXZEhZZWFlaGJwRVgraWlJVHp5VnNUYW1RbjVFcXBHUlZUUysrZUVIRXNP?=
 =?utf-8?B?cmdITHU2REVETFZISENqektKMVdPVExoTHV2SzA3ZkEvWVN4dHFlZktWZGxD?=
 =?utf-8?B?cDdWNkRsNUZrSVM4ejJFK0lNSE12MWxZQnVUOFhBZXViMGd2Z0pwek8zMm5r?=
 =?utf-8?B?U0lWKzZJQmhBTEthVzF2cGljc3ZVL2VwVkJ1RzNzOUc4eHpEQTJtNUxERHNW?=
 =?utf-8?B?T3ZxcHNWRjVJbFh1cndiNDhJd01lWVZDSW9HWjNBYUdNYk9ERlVjVWJGSk8x?=
 =?utf-8?B?US96dVZ2OS84dG9uQW1aSzlNNXVmT0YxNkVtbVBQMStIMzRBZ2RnMHo5R3Q4?=
 =?utf-8?B?R3lTckdpWlg5bU8yQW5YTm9VK1lWbVZNSWtGSGR0b2tmS3VXeHJ5VlhLSDVV?=
 =?utf-8?B?dGYvYkdxVmZ4dVRLNEQ0TGNzR0FwRVkydDJuMndBUlZDTlN2YkNuenZUNEIw?=
 =?utf-8?B?S1hGeGNwdEZsemFqdVVLcGc2RWNheTY3QUFLMmpPQVpDWEg2WGpqNXczanoy?=
 =?utf-8?B?SlNvcUVtTFk4a2VvRFpndjZ5dE1XdURvVDQ3V1dmVjVsbjVZbEVwbm8zelBn?=
 =?utf-8?B?WXhWRFBsOGt5ZVE4M0hkWmZhNk1WZUJKaW96MXhzR2d3SEloMVQ3TjBKb2tX?=
 =?utf-8?B?elIrSkt4TTJ1UnhtVTRGZXV2cm0vOEZIWnlwbWJKcFU5UG9OUVFUQ29kTXJS?=
 =?utf-8?B?djYwK2RRdHZidksyUHJDTXp2N29nV0RyOXZoKyt2NE0zZDArZGIwT0ZQcm16?=
 =?utf-8?B?aXR1djRVMEErRS9VY2lwVVgrRWJ2Nnh3bWFRaEErdENYZWVLZEhlNThiM2NY?=
 =?utf-8?B?SGg0cVVUOElMMnN2LzlxQmVpcmliLzlEWmh5cnBmWjh1OFR5ajZydllxYkw2?=
 =?utf-8?B?bVJqVFZwR0FiU1FxWTlONGdwT1JPd2c3OFlZT2ZzSzd5UlhIMFJCaEpScjZM?=
 =?utf-8?B?ZUVublMxbk1PeEM0QWJiSm9OQW1iWkJFb1BKTGhLVGwyQm11dGJ5QjdKeWk2?=
 =?utf-8?B?YjZrTFVpb085VzVaWWgvU3RHTnYzRzlMWjQ2Z3FVQ1VMN293dnVLdXBIOUVU?=
 =?utf-8?B?ZkR1QU1aM3Avd2tGZnFINjc3Qlh1cEhDNE56a0d2RThteGZNNW11U0VoTnJp?=
 =?utf-8?B?VmdvNEdkTCt2MDVRNHVwNHFGUlp5a1l2T2dEVjZ4OU44SHZwWFJCa0IwYlVN?=
 =?utf-8?B?OWR0eUE5MUtNVzdXN1lPcTNkY0ViU2xHZ1hvMnVvbXY0L1Yyd1BKeFlIT1hs?=
 =?utf-8?B?d0VPT0hnV0lMUjU1UytQUklHU0pwN2I0MVY1ZEtPdUZGSkxMZGJVYlBTbmxy?=
 =?utf-8?B?TWpCRUtzdFRCbXdzemV5SnMrY0pLUEpZdjFWWDJzYmcvM2RPcXRKRkNhMkRh?=
 =?utf-8?B?VTBmYkJJK25vTG1mU2ZqQzhBRnpIcm0wNmhpL2E0U0tUY2FVam9DODdxNTFh?=
 =?utf-8?B?MW12ckxxOTBXb29XVnFPWTFmNEpDVTBVblNZM01jL01RZjZGTjZEVFhTL09s?=
 =?utf-8?B?Z1BXT0FIb3I3WHFYQktHQzJCTUdpRUt3SURaQmhVTStDQitVMDdydUJFNytF?=
 =?utf-8?B?K3J0QzhHb01XaGdLTS85a0lWYUJ0UmhhYkVxZkhUOWRGblJnalBGUGxQaEQw?=
 =?utf-8?B?eTRiVzhPcmczRVZGYlJ1dUNHcnFXYWl2V0hXTWkvUktmaFloMk82V2IxcGhy?=
 =?utf-8?B?SW5RMDljbis3WUoyMVN6Ty80ZEt2ek1VVkJGZ3MvMnVZd1o2MjdVYjZYSGVD?=
 =?utf-8?B?Z3RUQXdRd1VzKzNIYkdXb0xRc25SaWZqbGF3SEwwRkt2NkFSUXQyWWVMSzRJ?=
 =?utf-8?B?L3U1ZUE5WlNuWXRUR2wwTE16ZXVmeDNObDczdmhuWUxKbC9lNDh4U0FLYko5?=
 =?utf-8?B?dUdZRGhhai9RZ2IzT3VBc3V2d0UxTWVkRnUzTFY5di94NE5LQTg2VTJjalVT?=
 =?utf-8?B?dFJTOHNhbWl2N01nU3czTUhSK1ViWTNtTjlFUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bytBcnRWajRTQ3RsWDh4OHpXaWFMZCt1VlF3Qm5aQTYwQ1QrMmN5QjJIM0Z1?=
 =?utf-8?B?b1N4ZHFNWStBbzVmVENFT1JaSzFzOEs5ZHJjMWZsNGp1VDZLVGZqd3BRZWZO?=
 =?utf-8?B?TFd1M0JnVHo3cGpOa0RTR3FRY2dxcGJRZzcwM1BMbzY1eGJhaXdoV1M5Nmdm?=
 =?utf-8?B?RG4zVGxwcE16blE3TUdIaXEyZWhSMHhxUE9mbGx3akFGemRXYVZZdi9NK09U?=
 =?utf-8?B?M2NGaWJ5NTFWb3lRamoyV3ErblJXOWhueTZtU21aYit5WnRPNkIxRWhpQ2pv?=
 =?utf-8?B?S2RPVXI0VnRsTFFzWjJWTFRxeGVrRWJmRjRZNVMrRmkrZDdOcDZ5a3RYQ3FW?=
 =?utf-8?B?SlFPQXd5ck0xQVVVaC9BS0J0eVNkVFpLZ2g5UXZtV0JhWlR3dHplTkRWRmJC?=
 =?utf-8?B?ZmZVakxUU2hMeTh1Nml5OFNwaktvNUl3eGJoaUxUUlF2YjFaU0JKYU42L29D?=
 =?utf-8?B?MmgrZmV2cEx2ODU2VnAxMlNEeVdYd3U2cXJUek5kMFRsQzdCS2tLekZ0MjZn?=
 =?utf-8?B?cHFaTmVCTHFiRzd3UVZVeWY0YTdremhlRHVQZFNtYXFEU29VWi9ZcmRxQ1Mx?=
 =?utf-8?B?RVhsaUVkWC9FK00wNkpwNlJTUG9YVFk1ckR6ZG5lNDAxZTkxa1pDcHVRSkY3?=
 =?utf-8?B?QTNoUldLZVkzQUFhZFlxZEJkQTdGM2ZSS1FIRXd5UXh6ZVNTT2FtRndqbUlm?=
 =?utf-8?B?RlpxcTY3Sk9OeFlPWDF1eU5jMHVZWXovZ2hNRDc4UHRsTGxieWwvdVlEZjFM?=
 =?utf-8?B?QksyWnFmOElHcmlLZkFaaFFZaURVaXNJZnpFbUZlankvbUxCR05WYTBrNkFC?=
 =?utf-8?B?eERybEpucU43dGNMeGhsWDB6TFhuejhPZGYwLy9Fdy8yYzNsRTVjZXAvOE1G?=
 =?utf-8?B?TitNVFErcWRwWm52QjVlVFk3ZnpIVHhVSkplQ0pPZ2VzTHZIL0cxeXM3WUNi?=
 =?utf-8?B?OVVBYmZDR0huVlo5ZUdpQjRhQzFEM2E2MXlmRWdDOHlKZTRMS1ZjWGdGVG1N?=
 =?utf-8?B?Y2xFalBlQXoxU21XUWU2eWpWU3YyS053QWNsM0hKdVNDTEZiS0RNN3YxekN3?=
 =?utf-8?B?WTFCUXJsQ0lhN0g3TUdNRWMvMTVmSW5NRzk4dHN4c3hEY2l0NDdLMHYyQlNR?=
 =?utf-8?B?c2djNmhVZnREZGl1T21CZkNmTEluSXpKcHIyLzNjaFF2dFJJOFYvWkE4OUtH?=
 =?utf-8?B?TVVmaFJ6SCs3WThjditlZ0hrMEJsSUdIM0VRYjFQZFFDZkh4L2F0YnkySUdm?=
 =?utf-8?B?NHZUZEhwMjd5QjJZVmVOL2xkWVFUK2NtSHNnRlc2dVU5blVKRzFsUDk5dTY3?=
 =?utf-8?B?bmRnanJtU1ZkbXU0L3c4cFBkUTU3UUNKbWV5allRL2U0Z0svejBOZjR5RGZN?=
 =?utf-8?B?R1hSRTdXWnlpR1YrdWJxbTFkYzFNc2VpQnZML1dxRVlZbjJabENiNGNFenZU?=
 =?utf-8?B?N2puK3BBY08zeTJNeENMQTlHRHJSYWdCR2NSZ3YrSEVkV1FkYWptR3VPYVRQ?=
 =?utf-8?B?SnVNYWtDcWJWR3NHNHk3RTMxb3JaR0tXbUFIYk4rK2xLbVdxYnIyUEtQSUdq?=
 =?utf-8?B?R1A4QjN1TDhBWU5yK2U4RUhpKzNQaktyOXhlbXdQeVBJZVl5dThjeHlJN0s5?=
 =?utf-8?B?RXNPSmk4dEVUVlFMc3A0YlREb3dXb0tKNUlyem9lK2lBUUJpKzZGZXJPTDlt?=
 =?utf-8?B?QnlBcFZ5TFN3Uk84RzI2Mi82aVM5bTh6Tm10SnI2NlZ5RmM4ODVURFVSNkZR?=
 =?utf-8?B?djE0RkF2M2FJOWVFc2FXY3FjOWZZZE1hWDVHOGV0Y0pGaUZWMUdkKyttZDNY?=
 =?utf-8?B?NXNkNnlFWGlmRU16cm1nSGlWcmJtYXhjbW5PRS9uQU0reS9ZejBRb0pSZFpJ?=
 =?utf-8?B?bUxUT0dERjdpQ3pYNERpWWJZTDRWMWxHWDkyZHJTSC9jMzJsV2hHNXVSQWl0?=
 =?utf-8?B?QkthS3hYUEpEQVNQRjRYUC9pOWM2SVFrMWZIUEpDV0oxL28vWEtiK25BQ3pt?=
 =?utf-8?B?NFc0MVM0Zk1UdkM3V1I4MndadTlzRnl3R0phMXhRNlBCVEFNSGhBMVkrY1Mx?=
 =?utf-8?B?dlF1YWZMTXRkWVFkdzlQakxkL0E5NXFJd2haWS9vZXhPbTVkMjAwaFhPY1pY?=
 =?utf-8?B?WjlYT29jTWFrZmE3QnhMNnNSdkdqZE5qdGRwZTZnNUlTM0pieXIrRTV2QzA5?=
 =?utf-8?B?ekNUWUNFa3o3UGY4MHBmcWZNTGVHdDNYc2wrM3FTcUIwQzFHVjhGdlAyYml3?=
 =?utf-8?B?a0Y1a0J0dEEwekswRStWdnFXQTNhZU9sZUZDZ3VTUXNRcjFVYlMvUHNCdzBQ?=
 =?utf-8?B?c2VPOUlvRnNMeUFWQUpnRTM0UGd3TlZoR1dhUk5EUlRPREZSMUNMdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37fed55b-fe50-4cc9-fa3e-08de51dc7350
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2026 13:14:00.1651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FA955mHBVa3QDM5MazLWZq9AJ8nolJO5c98d03vVR0fxIQ9UBgGMV52Rp21CS2wjkCAU6d1Ncp8Oq5QKJRq7Lg2RrfA9DDprpRGWycjwAjg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7825
X-OriginatorOrg: intel.com

VGhhbmtzIGZvciB0aGUgcmVwb3J0LiBJJ20gbG9va2luZyBhdCBpdC4NCg0KUmVnYXJkcywNCg0K
LS0gDQpHaW92YW5uaQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTog546L5b+X
IDx3YW5nemhpX3hkQHN0dS54aWRpYW4uZWR1LmNuPiANClNlbnQ6IE1vbmRheSwgSmFudWFyeSAx
MiwgMjAyNiAxOjExIFBNDQpUbzogQ2FiaWRkdSwgR2lvdmFubmkgPGdpb3Zhbm5pLmNhYmlkZHVA
aW50ZWwuY29tPjsgSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Pg0KQ2M6
IHFhdC1saW51eCA8cWF0LWxpbnV4QGludGVsLmNvbT47IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5l
bC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFtCVUddIEtBU0FO
OiBzbGFiLXVzZS1hZnRlci1mcmVlIFJlYWQgaW4gYWRmX2Rldl91cA0KDQpEZWFyIE1haW50YWlu
ZXJzLA0KDQpXaGVuIHVzaW5nIG91ciBjdXN0b21pemVkIFN5emthbGxlciB0byBmdXp6IHRoZSBs
YXRlc3QgTGludXgga2VybmVsLCB0aGUgZm9sbG93aW5nIGNyYXNoIHdhcyB0cmlnZ2VyZWQuDQpI
RUFEIGNvbW1pdDo3ZDBhNjZlNGJiOTA4MWQ3NWM4MmVjNDk1N2M1MDAzNGNiMGVhNDQ5DQpnaXQg
dHJlZTogdXBzdHJlYW0NCk91dHB1dDpodHRwczovL2dpdGh1Yi5jb20vbWFudWFsMC9jcmFzaC9i
bG9iL21haW4vcmVwb3J0X2M2eHh2Zi50eHQNCktlcm5lbCBjb25maWc6IGh0dHBzOi8vZ2l0aHVi
LmNvbS9tYW51YWwwL2NyYXNoL2Jsb2IvbWFpbi9jb25maWcudHh0DQpDIHJlcHJvZHVjZXI6IGh0
dHBzOi8vZ2l0aHViLmNvbS9tYW51YWwwL2NyYXNoL2Jsb2IvbWFpbi9yZXByb19jNnh4dmYuYw0K
U3l6IHJlcHJvZHVjZXI6IGh0dHBzOi8vZ2l0aHViLmNvbS9tYW51YWwwL2NyYXNoL2Jsb2IvbWFp
bi9yZXByb19jNnh4dmYuc3l6DQoNCktBU0FOIHJlcG9ydHMgYSBzbGFiIHVzZS1hZnRlci1mcmVl
IGluIHRoZSBJbnRlbCBRQVQgZHJpdmVyIGR1cmluZyBhZGZfZGV2X3VwKCkuIFRoZSBkcml2ZXIg
YWNjZXNzZXMgYSBuYW1lc19jYWNoZSBvYmplY3QgdGhhdCBoYXMgYWxyZWFkeSBiZWVuIGZyZWVk
IHdoaWxlIHBlcmZvcm1pbmcgbXV0ZXggb3BlcmF0aW9ucyAoX19tdXRleF9sb2NrX2NvbW1vbiDi
hpIgbXV0ZXhfb3B0aW1pc3RpY19zcGluKS4gVGhlIGlzc3VlIGlzIHRyaWdnZXJlZCB3aGVuIG9w
ZW5pbmcgL2Rldi9xYXRfYWRmX2N0bCBhbmQgcGVyZm9ybWluZyBhbiBpb2N0bCB0byBzdGFydCB0
aGUgYWNjZWxlcmF0b3IgZGV2aWNlIHdpdGggbWluaW1hbCBjb25maWd1cmF0aW9uLiBJbiBzaG9y
dCwgdGhlIFFBVCBkcml2ZXIgcmVhZHMgZnJlZWQgbWVtb3J5IGR1cmluZyBkZXZpY2UgaW5pdGlh
bGl6YXRpb24sIGxlYWRpbmcgdG8gdXNlLWFmdGVyLWZyZWUuIA0KDQpJZiB5b3UgZml4IHRoaXMg
aXNzdWUsIHBsZWFzZSBhZGQgdGhlIGZvbGxvd2luZyB0YWcgdG8gdGhlIGNvbW1pdDoNClJlcG9y
dGVkLWJ5OiBaaGkgV2FuZyA8d2FuZ3poaUBzdHUueGlkaWFuLmVkdS5jbj4sIEJpbiBZdTxieXVA
eGlkaWFuLmVkdS5jbj4sIE1pbmdZdSBXYW5nPHcxNTMwMzc0NjA2MkAxNjMuY29tPg0KDQpRQVQ6
IGZhaWxlZCB0byBjb3B5IGZyb20gdXNlciBjZmdfZGF0YS4NCmM2eHh2ZiAwMDAwOjAwOjA1LjA6
IFN0YXJ0aW5nIGFjY2VsZXJhdGlvbiBkZXZpY2UgcWF0X2RldjAuDQo9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCkJVRzog
S0FTQU46IHNsYWItdXNlLWFmdGVyLWZyZWUgaW4gb3duZXJfb25fY3B1IGhvbWUvd215L0Z1enpl
ci90aGlyZF90b29sL2xpbnV4LTYuMTgvaW5jbHVkZS9saW51eC9zY2hlZC5oOjIyODIgW2lubGlu
ZV0NCkJVRzogS0FTQU46IHNsYWItdXNlLWFmdGVyLWZyZWUgaW4gbXV0ZXhfY2FuX3NwaW5fb25f
b3duZXIgaG9tZS93bXkvRnV6emVyL3RoaXJkX3Rvb2wvbGludXgtNi4xOC9rZXJuZWwvbG9ja2lu
Zy9tdXRleC5jOjM5NyBbaW5saW5lXQ0KQlVHOiBLQVNBTjogc2xhYi11c2UtYWZ0ZXItZnJlZSBp
biBtdXRleF9vcHRpbWlzdGljX3NwaW4gaG9tZS93bXkvRnV6emVyL3RoaXJkX3Rvb2wvbGludXgt
Ni4xOC9rZXJuZWwvbG9ja2luZy9tdXRleC5jOjQ0MCBbaW5saW5lXQ0KQlVHOiBLQVNBTjogc2xh
Yi11c2UtYWZ0ZXItZnJlZSBpbiBfX211dGV4X2xvY2tfY29tbW9uIGhvbWUvd215L0Z1enplci90
aGlyZF90b29sL2xpbnV4LTYuMTgva2VybmVsL2xvY2tpbmcvbXV0ZXguYzo2MDIgW2lubGluZV0N
CkJVRzogS0FTQU46IHNsYWItdXNlLWFmdGVyLWZyZWUgaW4gX19tdXRleF9sb2NrKzB4ZDBhLzB4
MTE2MCBob21lL3dteS9GdXp6ZXIvdGhpcmRfdG9vbC9saW51eC02LjE4L2tlcm5lbC9sb2NraW5n
L211dGV4LmM6NzYwDQpSZWFkIG9mIHNpemUgNCBhdCBhZGRyIGZmZmY4ODgxMTI1YzlhYjQgYnkg
dGFzayBzeXouMi42MDY3LzE3MzYyDQoNCkNQVTogMSBVSUQ6IDAgUElEOiAxNzM2MiBDb21tOiBz
eXouMi42MDY3IFRhaW50ZWQ6IEcgICAgICBEICAgICAgICAgICAgIDYuMTguMCAjMyBQUkVFTVBU
KHZvbHVudGFyeSkgDQpUYWludGVkOiBbRF09RElFDQpIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5k
YXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyByZWwtMS4xNi4zLTAtZ2E2ZWQ2Yjcw
MWYwYS1wcmVidWlsdC5xZW11Lm9yZyAwNC8wMS8yMDE0IENhbGwgVHJhY2U6DQogPFRBU0s+DQog
X19kdW1wX3N0YWNrIGhvbWUvd215L0Z1enplci90aGlyZF90b29sL2xpbnV4LTYuMTgvbGliL2R1
bXBfc3RhY2suYzo5NCBbaW5saW5lXQ0KIGR1bXBfc3RhY2tfbHZsKzB4ZGIvMHgxNDAgaG9tZS93
bXkvRnV6emVyL3RoaXJkX3Rvb2wvbGludXgtNi4xOC9saWIvZHVtcF9zdGFjay5jOjEyMA0KIHBy
aW50X2FkZHJlc3NfZGVzY3JpcHRpb24gaG9tZS93bXkvRnV6emVyL3RoaXJkX3Rvb2wvbGludXgt
Ni4xOC9tbS9rYXNhbi9yZXBvcnQuYzozNzggW2lubGluZV0NCiBwcmludF9yZXBvcnQrMHhjYi8w
eDYxMCBob21lL3dteS9GdXp6ZXIvdGhpcmRfdG9vbC9saW51eC02LjE4L21tL2thc2FuL3JlcG9y
dC5jOjQ4Mg0KIGthc2FuX3JlcG9ydCsweGNhLzB4MTAwIGhvbWUvd215L0Z1enplci90aGlyZF90
b29sL2xpbnV4LTYuMTgvbW0va2FzYW4vcmVwb3J0LmM6NTk1DQogb3duZXJfb25fY3B1IGhvbWUv
d215L0Z1enplci90aGlyZF90b29sL2xpbnV4LTYuMTgvaW5jbHVkZS9saW51eC9zY2hlZC5oOjIy
ODIgW2lubGluZV0gIG11dGV4X2Nhbl9zcGluX29uX293bmVyIGhvbWUvd215L0Z1enplci90aGly
ZF90b29sL2xpbnV4LTYuMTgva2VybmVsL2xvY2tpbmcvbXV0ZXguYzozOTcgW2lubGluZV0gIG11
dGV4X29wdGltaXN0aWNfc3BpbiBob21lL3dteS9GdXp6ZXIvdGhpcmRfdG9vbC9saW51eC02LjE4
L2tlcm5lbC9sb2NraW5nL211dGV4LmM6NDQwIFtpbmxpbmVdICBfX211dGV4X2xvY2tfY29tbW9u
IGhvbWUvd215L0Z1enplci90aGlyZF90b29sL2xpbnV4LTYuMTgva2VybmVsL2xvY2tpbmcvbXV0
ZXguYzo2MDIgW2lubGluZV0NCiBfX211dGV4X2xvY2srMHhkMGEvMHgxMTYwIGhvbWUvd215L0Z1
enplci90aGlyZF90b29sL2xpbnV4LTYuMTgva2VybmVsL2xvY2tpbmcvbXV0ZXguYzo3NjANCiBh
ZGZfZGV2X3VwKzB4NDQvMHgxNGMwIGhvbWUvd215L0Z1enplci90aGlyZF90b29sL2xpbnV4LTYu
MTgvZHJpdmVycy9jcnlwdG8vaW50ZWwvcWF0L3FhdF9jb21tb24vYWRmX2luaXQuYzo0NzMgW2lu
dGVsX3FhdF0NCiBhZGZfY3RsX2lvY3RsKzB4MWQ2LzB4MTA4MCBbaW50ZWxfcWF0XQ0KIHZmc19p
b2N0bCBob21lL3dteS9GdXp6ZXIvdGhpcmRfdG9vbC9saW51eC02LjE4L2ZzL2lvY3RsLmM6NTEg
W2lubGluZV0gIF9fZG9fc3lzX2lvY3RsIGhvbWUvd215L0Z1enplci90aGlyZF90b29sL2xpbnV4
LTYuMTgvZnMvaW9jdGwuYzo1OTcgW2lubGluZV0gIF9fc2Vfc3lzX2lvY3RsIGhvbWUvd215L0Z1
enplci90aGlyZF90b29sL2xpbnV4LTYuMTgvZnMvaW9jdGwuYzo1ODMgW2lubGluZV0NCiBfX3g2
NF9zeXNfaW9jdGwrMHgxOTQvMHgyMTAgaG9tZS93bXkvRnV6emVyL3RoaXJkX3Rvb2wvbGludXgt
Ni4xOC9mcy9pb2N0bC5jOjU4Mw0KIGRvX3N5c2NhbGxfeDY0IGhvbWUvd215L0Z1enplci90aGly
ZF90b29sL2xpbnV4LTYuMTgvYXJjaC94ODYvZW50cnkvc3lzY2FsbF82NC5jOjYzIFtpbmxpbmVd
DQogZG9fc3lzY2FsbF82NCsweGM2LzB4MzkwIGhvbWUvd215L0Z1enplci90aGlyZF90b29sL2xp
bnV4LTYuMTgvYXJjaC94ODYvZW50cnkvc3lzY2FsbF82NC5jOjk0DQogZW50cnlfU1lTQ0FMTF82
NF9hZnRlcl9od2ZyYW1lKzB4NzcvMHg3Zg0KUklQOiAwMDMzOjB4N2ZhZTg3YzQwNTlkDQpDb2Rl
OiAwMiBiOCBmZiBmZiBmZiBmZiBjMyA2NiAwZiAxZiA0NCAwMCAwMCBmMyAwZiAxZSBmYSA0OCA4
OSBmOCA0OCA4OSBmNyA0OCA4OSBkNiA0OCA4OSBjYSA0ZCA4OSBjMiA0ZCA4OSBjOCA0YyA4YiA0
YyAyNCAwOCAwZiAwNSA8NDg+IDNkIDAxIGYwIGZmIGZmIDczIDAxIGMzIDQ4IGM3IGMxIGE4IGZm
IGZmIGZmIGY3IGQ4IDY0IDg5IDAxIDQ4DQpSU1A6IDAwMmI6MDAwMDdmYWU4NjY4NmY5OCBFRkxB
R1M6IDAwMDAwMjQ2IE9SSUdfUkFYOiAwMDAwMDAwMDAwMDAwMDEwDQpSQVg6IGZmZmZmZmZmZmZm
ZmZmZGEgUkJYOiAwMDAwN2ZhZTg3ZWI1ZmEwIFJDWDogMDAwMDdmYWU4N2M0MDU5ZA0KUkRYOiAw
MDAwMjAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDA0MDA5NjEwMiBSREk6IDAwMDAwMDAwMDAwMDAw
MDMNClJCUDogMDAwMDdmYWU4N2NkZTA3OCBSMDg6IDAwMDAwMDAwMDAwMDAwMDAgUjA5OiAwMDAw
MDAwMDAwMDAwMDAwDQpSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAwMDAwMDAwMDAwMjQ2
IFIxMjogMDAwMDAwMDAwMDAwMDAwMA0KUjEzOiAwMDAwN2ZhZTg3ZWI2MDM4IFIxNDogMDAwMDdm
YWU4N2ViNWZhMCBSMTU6IDAwMDA3ZmFlODY2NjcwMDAgIDwvVEFTSz4NCg0KVGhhbmtzLA0KWmhp
IFdhbmcNCg==
