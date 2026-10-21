Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792594972;
	b=pvDT2ozmRiCJPs555ND8FGFXS0S+Y2XhQWV6rekPu+1TKPYChIBK/9pbw5K0qOgqwCKA
	 /UidG3v9cJ6872fQ7v4Z3PmNehMarGx23MRZ7RRJIWWpYS7eRV0PzFB6wcIKX7K8dFWyZ
	 wilyaGShL+I3PD35Yc+WAbFTt4ZbKMsAGEkNHRP/9/TKhtOo2ZaHzLG9tXiYOLIQi4qJ9
	 VLa/eV8bC7ck95lrFMdtxKRxG0bla8w5ghueWi+FvCg1ZlmTRrXQ17UJ4Za5qOs590dNz
	 Di6mtWGOJourohtq6S2UeOavV9Q3LmNWXEBnUXysIuzEKrPONpXAJRl6GXMlyx33NMQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792594972;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Message-ID:Date:User-Agent:Subject:To:CC:
	 References:From:Content-Language:In-Reply-To:Content-Type:
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
	bh=W+kUAd/cDX6gYPBYVQLxlpxP2NVXHVQMpql/6HKRGCI=;
	b=CtVemFh8IwF1RdGh6c8rwtjNJu6el0Cs3Ptlq7QUh5KezSj1aO18ryeURAlYYz0ca4eT
	 rYYujNn/l191rQhl6h9MukYvVx8i/2G/glTgfU2ukSmKSHcqKeqH3QkSGOYKs3dJJ/k5X
	 iE/VfyG5Coat6BD9TsSutPEyI/LVC0rXxmj9W5IbxHDBnzhBkcgpH3WQ2g0yF5Bd9kpUt
	 A4S6bxXPtK3Lby7EG0wlSWW1fOXV8ts5HP5/8bRh39NhnVcvLd1/adXhBitScgENgtpnT
	 VUasVzeRPRH8Gle7xyDaSDMFxwa9B349qbP0jQ2FEe4tjF5Iorq5OxIEH4c0AA7MRIA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ct3iT0Uh;
	arc=fail smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CD1606A323;
	Wed, 21 Oct 2026 15:02:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8CD1606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ct3iT0Uh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792594972; x=1824130972;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W+kUAd/cDX6gYPBYVQLxlpxP2NVXHVQMpql/6HKRGCI=;
  b=ct3iT0Uhw3MwLb8BpUIOgZuUOVPgUL00ei84OHUaKghLf217Xaw1s9U2
   y9qCv1mWdJzEnRcwoU6YT/eHGnn6wTJlt4mYp/JQKBeqniAiDXNYcaGwM
   hwsR2iw60hbkJsPZKztuXmf6TmBzoCCyzQjNUwIBprJnZntrUxe6Fuy4q
   f9j4CpithjYuNXWSKMT5Oconj61pGTSDLDzH7quQd5/oyHjiN8O34Y762
   p6QHHM2QlqXYOIX+kkBHtAUZpc0WC+XuakyiZ58A2e62lBIpOcQ679xF3
   IOmrOMnnERGvugW7AcVJpLrTgiIFymFhNPVzppLxZLW1jCQ6n0ycwyfm2
   A==;
X-CSE-ConnectionGUID: 1iD8ba1HQ/e3T+A8TdW+/g==
X-CSE-MsgGUID: E28NBL9VRROlWZshL2PDzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="1198372"
X-IronPort-AV: E=Sophos;i="6.27,170,1787036400"; 
   d="scan'208";a="1198372"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 08:02:45 -0700
X-CSE-ConnectionGUID: ZVA7AVTmS+2NtRMTgXbKNQ==
X-CSE-MsgGUID: +Y/5XkbSRQ6kjKVAS+RAXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,170,1787036400"; 
   d="scan'208";a="3170074"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 08:02:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 08:02:41 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 21 Oct 2026 08:02:41 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.48) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 08:02:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xWNDiu6yD2m5js4fOCNAg9Wx+3eBrDuCROAvufYkSTLhXdVJXGPjp/OcXW5fgMcCv8fJnJ+c8ib8xJigyyFgMh6UdpPKn/z1J0MQjNcsjdNWR1DXqnXVB/DpZ8cpN5Jt86O5jDTjz/UInIsSFiEXnrRTohlK/X0DMASgA5DLoe5d5Ec7m1mMJot/OePETkrhCD+9n42SYNMklHBhIrfq85h1vMJ69x2PvZB6Bv0/wcyDULicLDWJmbXMAFA/3AkpA7u7IqK9lkusJEqP4sntMiAFUN45l+C4CMLi8/3ihcsNj1ymp1ckXZl2myRwnqCn98x9bGsRHHPs6JtRgcTmcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W+kUAd/cDX6gYPBYVQLxlpxP2NVXHVQMpql/6HKRGCI=;
 b=IJR3mzAEJoR21RF47nohBsshHNcHXhyVAQ0HfuLPGCSlixX4HzXp5KSZMdPQ6dj/v5zPyK/EHv8/Y8GUx9Tj7dn25Rg69CaO6RTjDnsIEeewD442xWOphtbxG1fkLJ336y0R0QsB3XhKd2eCE8HTE8X9HG8l5Ul/K7a5eBizh2BJor8J3AD0ZzBOOcU9X3hIc+xDEYLLjk+sM+2kpV4ZAUEovjajgh8GnekY/cuVtw61dJAtnvd46MIDinbvUrzGfktavjXU/GlBQQ7zoP5UEwzg2OXPr7whKTdXwcoo3dqJdoYlWYmged07aDfQr9H7zMpCeOWraUrplZ74aavq9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8718.namprd11.prod.outlook.com (2603:10b6:8:1b9::20)
 by CH3PR11MB395573.namprd11.prod.outlook.com (2603:10b6:610:362::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.14; Wed, 21 Oct
 2026 15:02:39 +0000
Received: from DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::6aa:411d:4bfa:619c]) by DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::6aa:411d:4bfa:619c%4]) with mapi id 15.21.0496.021; Wed, 21 Oct 2026
 15:02:39 +0000
Message-ID: <0a38e0b0-2508-41c1-bd99-d15c27579307@intel.com>
Date: Wed, 21 Oct 2026 17:02:30 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] unroll: Make unrolled, unrolled_full and unrolled_none
 function-like
To: Tzu-Ching Yang <shingekinocore@gmail.com>, Eric Biggers
	<ebiggers@kernel.org>
CC: "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
	"Jose E. Marchesi" <jose.marchesi@oracle.com>, Jakub Kicinski
	<kuba@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Simon Horman
	<horms@kernel.org>, Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20261016025613.2690485-1-shingekinocore@gmail.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
Content-Language: en-US
In-Reply-To: <20261016025613.2690485-1-shingekinocore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0012.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::16) To DS0PR11MB8718.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS0PR11MB8718:EE_|CH3PR11MB395573:EE_
X-MS-Office365-Filtering-Correlation-Id: fa1d45ed-bc8f-4f89-9d74-08df2f845971
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|56012099006|11063799006|18002099003|10067099003|22082099003;
X-Microsoft-Antispam-Message-Info: kwA/FNMmyAHbG4dbcMH0Iuphl6uonNIuSfzrL/AsTN0RR+ye+OX5HdPpruaMwzZ/5sjsvjlyvW3NN/FvXg5jyP0h8FAdNtuH1/0biXiFKwLRkqjYnZP+Akrzzc8b2rIBEpqKgopM2J8uRFycEcZd5OB/JxLzqXy/HzRbjSK4sDaV/47pZI36d+gef5m2NZ6phA/Dwg1ohhzu/KoNbTIQ97/YqtdDApsMC2wMt3K+8eHLHfVnVManaCzwAFRbaB+06b08sbhP3WCPyMGkJQ0/wsWPDteqJ06jfYWdfor//gHYraU+AxiVMmKZSXbNb54fWmGEKiLUJkV4AklMzpGIKmxXyJ1w5g8dkeB4nzBMk+RZ6SDVLzzquMJdPlo73W9rEX8VA91IdIjforPo7X7uONYicpimfwOfpQncdx4AgqYW4lqvk2nC7+PyjC6pKWk6nfv4kd5qpGRD3lp3d3QkHN2u8+QYl7jUMSWcluqR/rTAtCD4ahm+5DoUTF4v28q16kX/fn0ZLyO7CxW+dTTx9myvBn0ZK94XegUY/768B5mzr9172XjlcO7rGvJPyhgATf9QKIU5o9l9xAkkUpeCbzF6Z6DaLR1xVWOB1EWMMgiWORCvWI9kcdhBvY13HjkBfj4fG+kJGyjYnyfEMufXme9QQZL5/SJHiS7SRxnIeDg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(56012099006)(11063799006)(18002099003)(10067099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1p0bHdxRGpDOEtlakpFdlJUNENCeG5uRm5aYmZ6ZVpHQ05OY1VCcmFHWlE4?=
 =?utf-8?B?STcrVEk2NWYyc3dWNzRjcEozSCt3N1dTcThFZzdWTFhJbDE3WUpkdDBNSGp3?=
 =?utf-8?B?TjZ4a2NRRjBOVkFmSEZlOXFCRDdHZDh6YXZvQnRlRko3b05BL1B6cGIwenZs?=
 =?utf-8?B?cnJZNlhNcVlUcC9SQjBMTlg0YXFqdG9GdUdiWHZJd1ROSXhtRkZzZUxDN1Vu?=
 =?utf-8?B?aStpbXlLblZ2dXZ6ZVNaeUtzV3JFK1FGbzRYN01NRkE5UWNSVWJtZTRCY3FY?=
 =?utf-8?B?TDRSUHBXU2FaOCt3U2w0ZzZEV2Ftd0lYK2liNTNXVWVONDVpelR6NUVDUG1W?=
 =?utf-8?B?RVl1V2ZFdlhuZWluTDZkSkxaQ2hJMmFjOFQ4TU45cHpXMmxIUW5iSkFYOUVP?=
 =?utf-8?B?Y21NZkR4Qi9OaG5BYVNBNHhmY21SemU0RS8yZDhWYW1adWpRTkJ3dGluU3B0?=
 =?utf-8?B?Qk5xbjJSVGM0N001YXh0UUpPYmt1MGt5Y25RaUtYRXJzY1JwaDdqME5kUWkz?=
 =?utf-8?B?NDE5YzJLSTVXWmdDZWt0TEFjYTRtaGJBa3ZxcHFaWG5YSkxkOEtLZVFOUjZH?=
 =?utf-8?B?N2hybjEzdkUvb3ZlVHV1RUVvUktkbFBDMWpZK3dVZkRwOXFHcnpLQWp6aGQ3?=
 =?utf-8?B?UTRDT0xYWWtlQ2NSN2xubDQ4YUtFQjhaV2plT1JET1RUNWpQQVdKcHc0cW9F?=
 =?utf-8?B?RHcvR2lURmZUU0dkODFGUEVUTzh3ekNkK09ENk53T01FQXhQNE83VU43V1pG?=
 =?utf-8?B?MXNNUk9rY2hwaXR4ZGdwR2ZsTG03YmhJRWJBTUo1NDhxSG9ZNDR4cEJUZ0k0?=
 =?utf-8?B?Q3NSS2piUWlTRzFQcFN5WENqZFdYc3RuTTJBdHFxQ01LVXNLenR3bThmdlQ4?=
 =?utf-8?B?dC9uR0tpTllRZlJmcnk2ZW1SL0E0QXdKM1ZIWnFydVo4U1lRa2dWTkUvNmhn?=
 =?utf-8?B?MWVPUkVuN0lYenF3akVaU043WXJMUVZDVTNsZTl1dGloeTlETzdjTXBwdzdR?=
 =?utf-8?B?Nm1lZXF6ZFlvOVJleE44OEZYZFoxT3B5bmxDWWd3cnpoNmgrcUJwTzIxRjFx?=
 =?utf-8?B?TW85cjMxclNYY1grZXpEWUdEUmNielFaYWttNXJ6NW1tdll2aHh0WWRyV3Vp?=
 =?utf-8?B?OFR6Y0lRYzRGc0FlK0NmYXI0RTY5MWJjK2twNTBRZ3puSU1LUndBVzVHQ21K?=
 =?utf-8?B?Rm5nVTE4QWxvZFlwWDlIWmY3WnBhS0U3a1AwVUFBcVVDc25ocWsvRVFva2JU?=
 =?utf-8?B?bTZkUVNMMHlFYldHc0cxcVd4UGNYd1B1dmtrbUhuL1hZT01ickhtdEN1WGNI?=
 =?utf-8?B?d01ZL1N4dGJEb0pTQ3pHNW5ZUjMrdGp3VmIyYm5Tbm5GWTR6a1FOZ3dKOWFw?=
 =?utf-8?B?bm1RZkREek9FeXdiSEpMN2FOUFZjN3NjZ0ZZTlBTZDBPRmJTTTEzaDduVERr?=
 =?utf-8?B?Zit6WjNtcGtPYzEyNFdQQVVvVWpsTkd1M2hRdjBwWDBKazhiUWlIWDdFRGRx?=
 =?utf-8?B?Ukt5RnFQMGF0U2dpWXh2dDNMYW1yNm1qWWVQaGNGNzY4aXFXT2xMWGV1RlJh?=
 =?utf-8?B?ZnpLKy9xTUVWV0V5VkRYbi83eFVaWDNkZ2F1YWttSjRJZ282aGcyOFhjSjhu?=
 =?utf-8?B?c2NQUmV0UEJnRFZrZHB5UjR0RU9wMG9CdTR2V1E0cktFQkhHU0Z5Q0VLbG9u?=
 =?utf-8?B?OU9kNFlSSmlwOVcrcHFBYlJ3Ymc5V1hIMGdRM25wZTBheStESTJid29MeUFJ?=
 =?utf-8?B?aTRNRTZOS0JJditOZzZnZmdER245Ym13QTd3OVVocmo0N3VOcDVnbTMydWx4?=
 =?utf-8?B?Y3BuTkFBWktEK2RBQ0E0Q1R4aHRxQ3ZZOEIzRVdvYVpHSmZRMkFqaXBSZXB6?=
 =?utf-8?B?REU1ZmQ3VE44ZFB6azlmVnZycVdYQmFobGdkZGlZOEhOUERQNERLOEt1eENw?=
 =?utf-8?B?a2JheTBtMlpRVlJwUnR1RkFBRW90ckNPTXB1NlZRbTZUbDVsQjNTT0lHUDc2?=
 =?utf-8?B?VUNaRVd1bzczREt3YVE2TGNSZHVtazNodHlvMEtzNUNjSXd1ZkRXL0owdE53?=
 =?utf-8?B?Q3F1N1JQcDVwSjczaHV6bDJTdmpiMUhYeHRJZFJMdkphay9CT0JGdGFBbGor?=
 =?utf-8?B?dlZ6UVI0S3MxQnIrT2t0Y3llbFN4TzRBSnRqVFljYnFicGJ4bUR3S3M4MGdB?=
 =?utf-8?B?ckhDSy9xb3ZaMGU5WFBUcXlzVmFwaFI5cHgvbVFyOThLd3cvRjNZaFNGamZr?=
 =?utf-8?B?WG43SjJnUThYM1NLY0QwZXg1RlJyNURBVy9ueHMzdy82SVVFM1MwZU93V3dT?=
 =?utf-8?B?MUd1d0MrWnI3eE1NZlNESXQwQjVkdnA2ekw5QTFrdmk0WWFoMEg5V3EzaG1B?=
 =?utf-8?Q?u/KD6OPluXElCl/A=3D?=
X-Exchange-RoutingPolicyChecked: fv2AAOl9pF27GeZUVz/XRTCv07kPpU1n8m1yH3ceZX/+8pizCknNZTgkuX+c+zsgqsCVtu2pHLca8Vpv2VYTI9ZCVVAlLSLqR/Iq3SWGtWDTMrC3R5bEmsykwomtTUIISMZeR8uef0bJ2XOC+6MA+iXGKD9Khw8BKDcxnjkN4XwExYeKXwWpQFw9z6TjDxvWfH/Fq/jNXoDPgLU5xwJIUjXf6l7b44HAZIqARFrSgNcGkx0LOtfsoKRaxxT405MXGvxSPeT6S3iZxT56HUk9cPxdQBxt9uyS2VpUZH5AsMbMR0cTEOyRJe0rq8aUvOzlgSfxe4eNjYJeXIr44Ugp9Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: fa1d45ed-bc8f-4f89-9d74-08df2f845971
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 15:02:39.5492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HmZUX7Gq/6gYfc5bx6xDlx6CxirhEUd/rvPEW0KEMnOAndOgx3Ia/NIoeUhDdYffdTAwkRCq9NaYl8qq2jGH+ZqblYIIQ57r8RRJ0mFoZd4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB395573
X-OriginatorOrg: intel.com

From: Tzu-Ching Yang <shingekinocore@gmail.com>
Date: Fri, 16 Oct 2026 10:56:13 +0800

> unrolled, unrolled_full and unrolled_none are object-like macros with

Because those are attributes. With function-like names such patterns:

unrolled()
for (int i = 0; i < n; i++)

are counter-intuitive and confusing.

We have either plain-named attributes like `notrace` (BTW what if you
name your variable as `notrace`?) or underscored like `__always_inline`.
If you really need to name your variables `unrolled`, then I'd expect
changing these macros to `__unrolled` etc, not to `unrolled()`.
Although I'm not sure we really need it, there's tons of such macros in
the kernel -- try naming your variable `current`.

> lower-case names, so in a file that includes <linux/unroll.h> every
> later identifier with one of these names is replaced with a _Pragma()
> operator. A local variable or struct member with one of these names
Thanks,
Olek
