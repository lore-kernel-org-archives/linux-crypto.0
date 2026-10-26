Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793030040;
	b=nJWR+PPwuQMXYQ6Hncj46Mn8CDKsbyfC8rYBTr9A+SMUdsHi83q3g7VaqKU0F9ToUArw
	 GoWxfb1aLkwZ7N5wOgHAVKy/JQfbA9VWCRR/U7F0Uhw12XeB2feQBXK+Pu+U9BWUmzbdK
	 uKJVdjRXoUwC7wCqZBR/3bnvNd/O/ijqlIL0r1Hcyz21kbfwb9ZHZmORykOb4/Dgpd7Qe
	 x+A8D8agMRZ81S2Cwf8FkAh7aauq3OlJMCvblP+q/9WTGoV7ykaliPdtTltsIbsZf8FVI
	 3s0tVNzVqnTq2a5H/qTANRizdrPiv82mQjr1pZiEhYqhgNlbAAqapxlXSIudRYz9d3A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793030040;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Message-ID:Date:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=BTiC7HSUnHp6tLz7RNvfWGt/dm881MdleDlChMj7oWI=;
	b=VEpw+AQ52Ha9q57rZVZa7kzah9a3vurCR2IUKTNs3tGeXsOgAW8MeUv8PjMN7swmWJnO
	 Hx0SJFeEBscB0d9BPZYNOV1mOFBwZNuspO5AMZqCLeatZ7sr/PbIK21zOffT0FCFF618p
	 glZ0/uxtZJvSbnnKfwtCzJX2E3lwhvtPjqlTiD/ZH+yWCTP6hhhZbtFofhqkdowW4gPG9
	 wPIXiZsUVCcYYXUq9+hZ1zSahor3pQZqr0stGDiXYKrlRJAzN2IvHv3GXN1+fWU9XMnrX
	 QmTVa4xa+/PQUJYCIjdpSQYnqwVHD5mADePj+B8vhALoaxfG127SBM6zyHYxmgho3yQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jYHiTdXD;
	arc=fail smtp.remote-ip=198.175.65.18
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704B1606A31A;
	Mon, 26 Oct 2026 15:53:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 704B1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jYHiTdXD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793030038; x=1824566038;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KzAI2o5uAF1xOAFLOx0re6wCajOfsR/gYaTcNj2300A=;
  b=jYHiTdXDzUMiMyJ+CDP8eIt2CjGg1x/iCG+eksT3YnzrL1yGeJf1Oa0h
   95++N/BD7alckREwcudHL1TDRSziJosiRyBfRwhi8xshwxaR5vW9j9N5G
   gLDnCxLdP65Ht28FLue5J9kUsQmNuh1n/kI1g/XkmNyizuHuEDX03se/N
   SNR0dd9lboOXLPQ1XnpZX6vaM2dd/ePf5ZEWM3g+W9GlcptfHMTrlrOye
   BG+Vy1UVhYEpFncu3+oYJI6L5/uqclkZW9dJBlhD3SFQTNS36N5zUciRw
   I/uppxBumf+uA0xNVhwucnT3xTQPpCg6mLL+MP3whXnNjvG/VM4kgv9X7
   w==;
X-CSE-ConnectionGUID: u3rf4Zj/QLylV9ifN4kNIw==
X-CSE-MsgGUID: o0aI4fwiSLqzSAGmt1wRPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1709782"
X-IronPort-AV: E=Sophos;i="6.27,179,1787036400"; 
   d="scan'208";a="1709782"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 08:53:58 -0700
X-CSE-ConnectionGUID: Qw1NlK3TTG6W/X3N8FMQOw==
X-CSE-MsgGUID: YG1994RkQ8CmSi0FoHlkCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,179,1787036400"; 
   d="scan'208";a="4308189"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 08:53:57 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 26 Oct 2026 08:53:57 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 26 Oct 2026 08:53:57 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.51) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 26 Oct 2026 08:53:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pf5JKKtDSC5ZYoZ+iVLsYEhNgh09fLD/051NqeIDirZYT9HC9+fe4pbNiHT1w/6+dHWFTswI1GOkuGkZ92anlAo1TKlmD3JWhUYEo2fjndcK3XNouMwhgqFAlFCXVwdzkNYKmyDBkvjaaw56/EIC/jt8N5jhzuJiY1Mo3e0V8piimGCGgiaer2+snFPxw1IXxBCO4EdrcSy7T5yIdFACEWGp8MektIfY+Pv177k9ov8fm8VNBCZv6u2jYiat9DgcntHdjzYFiyL/NFDHyujriLvcKNZ6bj96s8Rc+b9cOkWBP9NNimLqXF2LzWkktbVHOJd8T6XvbX6CmQT2U0Yy+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BTiC7HSUnHp6tLz7RNvfWGt/dm881MdleDlChMj7oWI=;
 b=Aywyg9h2lTb1PeGXVMqIBZCDTWWfVOBPsY6xGeWqNyZCdkRxtFcy70/fwx2plAGVVNA4DK5F/PLiO1tm9rYpoONlh0uDHnHEb84U8YVACbOGbOrj7HabiGwu2gBGZkzBLqXsN/e755WAfSqcL+TE4q/AJ6zBTkzDW+LkfbzsrSRS7suqVAvstBYW7uKc+T0Pz7ocibvt1DsX+ag6/a/4SunvW57UgE74mo/vdamXrAP9cspSpyHhMJeBFZRWIKsZFvXKuNFrfGKIw4dAsxlvLPghdcM3+vi3cSMp3vweIa5xBI/JdU7A2swnonQx7CJYWLNoptzerHth+AGH9TGC4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8718.namprd11.prod.outlook.com (2603:10b6:8:1b9::20)
 by BN9PR11MB5244.namprd11.prod.outlook.com (2603:10b6:408:135::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 15:53:55 +0000
Received: from DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::6aa:411d:4bfa:619c]) by DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::6aa:411d:4bfa:619c%4]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 15:53:54 +0000
Message-ID: <ec1c6f33-ce75-41d7-a7b1-3f9a56c74d4e@intel.com>
Date: Mon, 26 Oct 2026 16:53:48 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] unroll: Make unrolled, unrolled_full and unrolled_none
 function-like
To: David Laight <david.laight.linux@gmail.com>
CC: Tzu-Ching Yang <shingekinocore@gmail.com>, Eric Biggers
	<ebiggers@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel
	<ardb@kernel.org>, "Jose E. Marchesi" <jose.marchesi@oracle.com>, "Jakub
 Kicinski" <kuba@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	"Simon Horman" <horms@kernel.org>, Maciej Fijalkowski
	<maciej.fijalkowski@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20261016025613.2690485-1-shingekinocore@gmail.com>
 <0a38e0b0-2508-41c1-bd99-d15c27579307@intel.com>
 <20261022100140.101ddf52@pumpkin>
 <20261022110959.1173447-1-shingekinocore@gmail.com>
 <3c25921c-7bdf-4edd-ba06-838dd1765db6@intel.com>
 <20261023173845.2ca86a63@pumpkin>
Content-Language: en-US
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20261023173845.2ca86a63@pumpkin>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB8P191CA0019.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:130::29) To DS0PR11MB8718.namprd11.prod.outlook.com
 (2603:10b6:8:1b9::20)
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
X-MS-TrafficTypeDiagnostic: DS0PR11MB8718:EE_|BN9PR11MB5244:EE_
X-MS-Office365-Filtering-Correlation-Id: 17565507-70ef-41a9-7778-08df337955fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|3023799007|261026140227099003|4143699003|11063799006|56012099006|5023799004|261022075727099003|261022105027099003|261021121427099003|10067099003|261026121527099003|18002099003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info: gyiQ5Ga9kUwO9xGHSGfap8iEeAl1DYHFdHVWKFeP4uTALYSy2QCkQ4fpQIasftLA766E8loAP0o9OjvqWdAS7VxrzmsB7lgavCDZnhSmMfjz3VZ7zhdf8KBQZV6NeegBynYz+jFBpTqbWzWrNqYj4sNkxt4Avxy3nblAUI03u4x954Ptj5VvD63TtHDXdArKrD+s8MZXirGEWsC+Srwj8kCdS2r5hCYwSx27ZeOuzsdbIqrKWnr8D6YK4Yp7LXueHCXdajcNJQM75MWSVT+hxs/6DRZYLzeXX8CaSz/Ab2YXA8TZu6LJUgNDmDSl3nAMumT1hRuuwqAhYq7VeK9W/GLVhU/DzmB8or1e0fpsKFqjn1DEw3x1WpGxcQG909Gx1LHBGkQOxeUlQavakD9GPszSLciOPFmoE3PG8vjJXeuzroqEU0LzM30iF/o8ckNLRDDJ3EFypYsY6nHq2AQkpht9qAI+vdUDBCHzCOp6izcthFbUBGcKTEZYcttjgAVMmLFrIb/GSrP/+N7RC3EaktYyGaOeEgNI1KWWovVF57s6/H6UGbDAjjvs3x3dqfRBFr+Ap3IOE68krFNW09NhpTCeR4U88PiP8SQjjSzlYXAMTx9ok8CGw22s4eq4x8xHld9ciPqKt+SqWi9TGQhBkNV14uOzi8+4aeDvyBL+DiE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(3023799007)(261026140227099003)(4143699003)(11063799006)(56012099006)(5023799004)(261022075727099003)(261022105027099003)(261021121427099003)(10067099003)(261026121527099003)(18002099003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFNQRmd2ZTBtSFZ5dHR6VmtFaU1EVTU3dTNJVG1Na1p5aUFDcHpyREhWdXdG?=
 =?utf-8?B?UEVLZHBoZHBlTlBhLytRbkZVYzVqSWJpOG05bFp6U081ZEpYcWpJT08zWURi?=
 =?utf-8?B?QkxPKzhxUGl0TmU5MUJ4clVoNmZYNmorSTBWbkdlRklGVGxTNnRZcVJpMytF?=
 =?utf-8?B?YnZaZHRHakxoZjI0UllBZ1VkWFdzbFRUNSsxbUR6K2tXcUZoNDVIYXFGOTI4?=
 =?utf-8?B?aXF4aXpRUFVKQVV3OHJUVUw4bUlKcmdtdmtBVzJHQVRobjhFNFk5b3pwTGZ6?=
 =?utf-8?B?clJXTDBVdjFNOEVuODVLYWF6R2FPUGg3Y0NkeSs3VmVDbWxmSDlzTHFQeHZk?=
 =?utf-8?B?c01iL0c1RUpUdjQ1UHcxNzBQR2ZrclFkR0taNng4T1JRY2QwRlU0MzlnbzN6?=
 =?utf-8?B?UVhFMXJPdFF5ODJuZDc3UEVpSm1QcDFad2V2SzlhekpmMnBFc2JBbWVsUmZa?=
 =?utf-8?B?QXE1U1pTemhZSUJHTmRLNlI2T1FUcy9pOTF4YmRZRy9PU09QcSs0WmhMNzBO?=
 =?utf-8?B?Mm1sVjhRYlhidjFNeCtMZ0ZIcVR2QUEyZE0ydDI3SDVaZHlBK2diNDlwajhL?=
 =?utf-8?B?QlFiOG5sdDdtQituTjVYN2xCZGgwMUltdnAvMEl6TW5RdEJONDR0cEV6b05I?=
 =?utf-8?B?cTRlcmxWSzNieTQyRVRYc05xUkdlY1BqZEZFNlFWQnVkZUVkZzE4dGEwY0Zo?=
 =?utf-8?B?TWozQUNEQURGdW1nOE5GaFdRTkxiVEUvTlduc2Z6WVB2NEh5c2NYekNyM3ND?=
 =?utf-8?B?TWV6c1NxWG9ZV1o3Uzk2bnZ3WEV1MjlWY3Y5bWt0L0twd0cvTnE2RUNCdEd4?=
 =?utf-8?B?S0lvTWJzMUh0b05MQ0JML1doWlFvNjRLdkVKYlJVVk8zUzVZSWtLdVNkYVZU?=
 =?utf-8?B?ajJZNmYyakoyTDVTcTR4NzYrb3ZtQ3pFU1NvT0JwZGlXNGhrUGpKbUc1cGo3?=
 =?utf-8?B?VzZyeVFnczhYOEFxUlltOUhING5yM3RiZnFTUk8zMUxUenVtZ2NnUkcrTk9F?=
 =?utf-8?B?ekptYW9CdUtCTnVoSkZ1MlFBSlphdkRZSXdPZ2IyeS9KRUZGUXNOc0VNU29B?=
 =?utf-8?B?M21KenRqZTJVZHJJZGhqY0ZzKzYwN3QwNWVxYXJCOUphT1lFeHpUa1dwOVNs?=
 =?utf-8?B?RzBXcDY3aEFrRHp0Y0dGamJsMDNwTXpXWlpYMCtHVXZ4a3lxdndxRDhab2M1?=
 =?utf-8?B?ZTdrUzZDbnNaUTJDWTdSb0poOXRrc2FtYnk3Q1AveFcyL3piNkFMZFptVXJI?=
 =?utf-8?B?VVlqVjhDQi8yRCt5Z20venhDTVhkdjFqSlZPMzdLNGdndy9yUUxidHJ2bnlk?=
 =?utf-8?B?bC9HOUIyY0tuRmlnQ3dKdnkrWC9zUXBEZVgwaktuclVjQ3VuQnVHQ2tBbVh6?=
 =?utf-8?B?SnRIN2xqYnpMSlhRRC8rWVpydXFGOG1sYlRwbVBsM2hyWDRlMFBWcjZYQS9Z?=
 =?utf-8?B?eWRxTHBMcTFTdDVCekJZY1FqMzhOMmRlSFZVWWN0cG51b0ZqVHZ2TU56bU5J?=
 =?utf-8?B?QTRsRnc0K0RBaHoyTHA2akNOTWpKdUo4cEhaYndaejlCT3hZLy9Ob29JMTM3?=
 =?utf-8?B?SjVoVVZJZEhWajN4S2xrcTRYcllGTzVsOWZqREp5VXRmYkx5blREd2tjR05x?=
 =?utf-8?B?bXN0M2p6ZGZacitDbmdWTU9hWUZWZVZrU0o0elFkeUFXTTJZUW9GYWpnWVRq?=
 =?utf-8?B?QnFKRXhQL21PdVlSUlc4ZXZnQlRzU1QxazVHRXhndWtpMVJWTVFGWDZxTTgx?=
 =?utf-8?B?QWZXdXIvT0cvTHhmTTdMclhmcFFUamJiTG5wRFEwR1JoKytzV3RpdlExN3ZL?=
 =?utf-8?B?cmVJQUV2QVVrTHR1UFBzU1NoaUVmRyt2bGFJWHg2N2IxUXFhNC90NzJXUysw?=
 =?utf-8?B?NlR5Mk1VWHVjeDdQWUIxQ203Z1oydDRmamtCcDZzSHdIRGY1THhjR1pyNU1H?=
 =?utf-8?B?MUpIMFVDNERrK3o5R3h0RWJCRjFaRlcxZ3NlU2JHTFF5T3dpQWhsQ0Y1dklY?=
 =?utf-8?B?Vy9paU9JWjBtODJMNVpRMGlzcmtJZDRzdThGTVFUaU1QTmpoN3ZpUi81bmJD?=
 =?utf-8?B?bXZLd0xRSUFzYlR4c1BQR1J0d0NpRkQ3czdoczVyWlYvRllZelB3Tll4ZXJs?=
 =?utf-8?B?MXNZZFdZTUJrcVlPaUpUR2MzdHdRekpyZ3N4dHF4OE9TQXVkTG1DVURWdDNH?=
 =?utf-8?B?Vk84b013aWpLT2M1NVE2K1Z5WmJrb21ZalYzWDVNbmZSWk94MkxCV1V0UW5Y?=
 =?utf-8?B?VVJLbjIwTG02OHI0a0VhemttUnlla0d6RDVEOVowRXJUZWlDblBVZ0VuRzdC?=
 =?utf-8?B?NHVwWEJiNkdWZ1loM2FqNk4vMXlHL2NjdWp1azNqZnk3K1dYSWJXZ0VFbVZF?=
 =?utf-8?Q?MLSsWtIdez3O2DZs=3D?=
X-Exchange-RoutingPolicyChecked: tfo9a12uZOUmtyf2QiFh/r8mrqCTn3HvRZX1Z4f/uEagupvXpah6vYIEb3nBkkJuIP5AwrAln2Ujg86SHvvvTFkOIsRizkb5LDKSA15sY7lJxKc3V3iPDhQY3DTHRTUlpGnAEQtpSBnSxuVbhHyGA3wOjYcGmH4hpoUZiQUb0MLWVHZTDp43KF+7P5K3Z0q+CDrhZ1lHx/VSuKyv/3lm3an+knAaPiNq72UZZusAVrhhpoeKJ65psV0kfMcrvQoqfN26ehE8II7PuJX9JdqyCRJRUju0ABTbh+uskR8AfXbsglGZFG8tEZaVKwwg3dN4LhzBN7VT7ZyADC5wzn0OLw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 17565507-70ef-41a9-7778-08df337955fe
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 15:53:54.0742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rS2jINwOhk+18U1PJTF+fRQ+LMqMxP76BOo1wsq0G+7lEKQ0GHY+WPNG9cAvRMc41uUJ0swjo7yxTx2pvbq2RvoDhqBlpk5j6MvWoB08NZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5244
X-OriginatorOrg: intel.com

From: David Laight <david.laight.linux@gmail.com>
Date: Fri, 23 Oct 2026 17:38:45 +0100

> On Fri, 23 Oct 2026 15:42:28 +0200
> Alexander Lobakin <aleksander.lobakin@intel.com> wrote:
> 
>> From: Tzu-Ching Yang <shingekinocore@gmail.com>
>> Date: Thu, 22 Oct 2026 19:09:59 +0800
>>
>>> On Thu, Oct 22, 2026 at 10:01:40AM +0100, David Laight wrote:  
>>>> Is it possible to make the syntax:
>>>> 	unrolled_for(....)
>>>>
>>>> Or is that made 'all hard and difficult' because he setting is sticky?  
>>>
>>> The pragma binds only to the loop that follows it, so it can go inside
>>> the macro:
>>>
>>> #define unrolled_full_for(...) \
>>> 	__pick_unrolled(clang loop unroll(full), GCC unroll 65534) \
>>> 	for (__VA_ARGS__)
>>>
>>> 	unrolled_full_for (int i = 0, j = 7; i < 8; i++, j--)
>>> 		s += a[i] * b[j];
>>>
>>> GCC 8 to 16 and Clang 17 to 23 unroll this fully, and the same works
>>> with break and continue in the body, nested loops and a loop inside
>>> another macro. The count form has the same shape:
>>>
>>> 	unrolled_count_for (4, int i = 0; i < n; i++)
>>> 		s += a[i];
>>>
>>> As a fourth option, the _for forms would replace the four unrolled*
>>> macros: no clash with identifiers, and the loop reads like
>>> for_each_*(); the cost is a new loop spelling at every user. Olek,
>>> Eric, would you prefer this over options 1 to 3 from my earlier reply?  
>>
>> I had considered this option in the past, but IIRC the unrolled
>> attribute can also apply to `while` etc, this would limit it to
>> `for` only.
> 
> Is that really useful?
> Partially unrolling a variable iteration count loop most likely just
> trashes the I-cache.
> (The unroll can't use simd instructions because they aren't normally
> available in kernel - ok, some cpu have a 'load pair'.)

In XSk xmit code, we have loops with the number of iterations being a
variable (number of packets queued by the userspace program), but using
unrolling by 8 packets helps there a lot if iterations are really
independent from each other (except the counter itself).
Pick a lower or bigger value and the performance (which can sometimes
reach 90 Mpps if everything is optimized to the top) will drop,
`unrolled_full` is not an option (not a compile-time constant), leave it
without any manual unrolling and the compiler won't do anything ('cause
not a compile-time constant).

> The only exception is very short loops where unrolling once can help
> because the cpu cant execute a single clock loop.
> The compiler is likely to make a pigs breakfast of those loops
> so they end up in asm anyway - look at the xor parity code.
Thanks,
Olek
