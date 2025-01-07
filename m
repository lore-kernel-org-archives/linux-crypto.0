Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBF786333;
	Tue,  7 Jan 2025 06:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736231780; cv=fail; b=tSLoD+baqslG1l/O9u1UjEMfU4wX5YCsBB/FeDvomSZxcx0iJpqDv2KQv9n0AgWGrPxY9breMvOixg70nnyDZciR/4+mb+OUXUGOJUfRST1WuxPPPZQQtcaCSk1jdKl2K6iOwVpZk0pz8VCQDUzQt03iZrLwuzI+U87Nf4nR57M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736231780; c=relaxed/simple;
	bh=m/2ID1Y8PB30skCBC6S+pTopZxkuEdiWfzG9I3ZvBH0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EHXaxaetAuB1I7Whbj+447cHWz6ZtSUIwzgFBpLA6iiZF+QrGMlFAGL7+EjDMaL5IKOfAsQvPUyIvXhjL+jeB7o9cItdy1O0nysjQOZ7ya47jzfaLdrRSHopiBuUM3oYDAA14lGRJTYcAtkSwe4EPNgmORqzKa8uybZxeAXHpdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TOQ3SlkO; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TOQ3SlkO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736231777; x=1767767777;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=m/2ID1Y8PB30skCBC6S+pTopZxkuEdiWfzG9I3ZvBH0=;
  b=TOQ3SlkOaFnek9XMcp1SS8sM8lb/zjdVKK26Dfyb7729cGJRgKilsSZw
   TNvvbG/LEipAv/xiihvyxhX2Qf5WUz5MA8uy5u7Ld+S+D7mNM4G9ru/cz
   WfQxPUywHoc1mb/Cm7ItQ5Jjcvca6qUy0G6teSl5l6BRGraT56WVi6mP2
   FBUnP3scxuG47UcoEpRVVtbN/HCX5XJjrow+L1Y6xKMZMVc5JG9bVB7xT
   sYTc83RbV4XAXKQ6iXfUamh5Cv8JSIHM3QMnRVjaFxUNW23fD3G60mnhI
   mugPJ6TquH0cUKvLDPCwy/bnErMsGxZtSLMv6YUlZXyHyhsGwz6E5aCIM
   w==;
X-CSE-ConnectionGUID: UeIRbcO+R0mo+PI1kMyghQ==
X-CSE-MsgGUID: a6xPPJZQSwCYXCPvofVhrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="36094355"
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="36094355"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 22:36:16 -0800
X-CSE-ConnectionGUID: HsZ/O/xdTOOaexfVPRr3Ug==
X-CSE-MsgGUID: xv7DwqbfTXuaxQ6UMS8czQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="102742904"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jan 2025 22:36:16 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 6 Jan 2025 22:36:16 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 6 Jan 2025 22:36:16 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 6 Jan 2025 22:36:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ykzY+Uy2BYxS5Q3x08ncyX+OQpJ5rDovwMe6WdiQizI9p2xQgkhhLJ4BACjyBB6cc5aqmKgnVb0g6zYE50idxlOiyg/E/9pMTxxwCETv591dewGc5tJoW1g5ltNvbpbHbLWse46AKWFwG9hAK2RTqijxuAbtEe3xNfHzyC5RYJ2Oq2lPCN3heQGH1mdc+0cPtSFXFGOMrlzE8zHBtJrze058wbZf7ftdBAwlE5IY478nnXgA5rXMipWn3rAPehmyUJ/O1XWa/qmAoIqMcUDZ70+LfU3vDButPzaZkTnhfH9S2kn/FoQShrldSmSjNY0IAQAXoyyPoWAMKHuqz7bn0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VA+nisWCZXUAbP+4DSbmcY1+eCaYdfc92AmA3IPHngY=;
 b=zIljxOBM9xXtPta/9bIZvsZk6aTETVATjUcjok6uzRbXCTJGLES4vsFqVMYTKGhI3zs7Ih8LAKY4xbzqT8mU74k4srOVdOorXirXk0GIqrEYikDfYmJ/H7oH5VxryXKOnsz/0hNwov9XKv9z8plvm2mXwxDmePIwO4TYwIqOu7OTnYwq5AnUnSQaT/labAgh2DG09G5oGouwuGByChHCUEsb1XdNexBd/CDPh3YAD5w+H/SxGGVsSk5KD0ZnhDGNKnvu78LZPCMO5cjfNet5xLjdblEsRpdBU7jqzWHYghRZ05FD87T0fkmDdFnzPle/UALUtiwhF6l+iTcVH8WIkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DS0PR11MB6421.namprd11.prod.outlook.com (2603:10b6:8:c7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 06:35:53 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8335.010; Tue, 7 Jan 2025
 06:35:53 +0000
Date: Tue, 7 Jan 2025 14:35:44 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Breno Leitao <leitao@debian.org>
CC: <lkp@intel.com>, <oe-lkp@lists.linux.dev>, <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>, Tejun Heo <tj@kernel.org>,
	<netdev@vger.kernel.org>, <oliver.sang@intel.com>
Subject: Re: [herbert-cryptodev-2.6:master] [rhashtable]  e1d3422c95:
 stress-ng.syscall.ops_per_sec 98.9% regression
Message-ID: <Z3zLQObsD42R6Nwz@xsang-OptiPlex-9020>
References: <202412271017.cad7675-lkp@intel.com>
 <20250103-singing-crow-of-fantasy-fd061f@leitao>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250103-singing-crow-of-fantasy-fd061f@leitao>
X-ClientProxiedBy: SG2PR01CA0173.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::29) To SJ2PR11MB8587.namprd11.prod.outlook.com
 (2603:10b6:a03:568::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DS0PR11MB6421:EE_
X-MS-Office365-Filtering-Correlation-Id: bc0974c2-97d6-40eb-e17a-08dd2ee587cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?trBUAkTDDTUwNcEvJ/OlwoFV71/5rs1ohm08Gn0jtzBeeXjY393qCVTK2E?=
 =?iso-8859-1?Q?bUZPAQpqT/SPM92YnekPrf/BaMSAFW0N5LzWXijbTmNaICrFeh43M3R60i?=
 =?iso-8859-1?Q?p5w4CO9m1TLrK/Fa/oN6v5iYAXMBNYUdEnzjDTX/L8ienoU8gp/Uub9F2t?=
 =?iso-8859-1?Q?UB7qI2Gs95Q571BAayoUlLv078rtggOY+MrL4XICxEkobSqoA1giBK8Vh0?=
 =?iso-8859-1?Q?aMKCl9wIYsWjsCdVZnPeZpvbka1iT428y3x6qAMGDY9O7ccm2yE3fc7Ozv?=
 =?iso-8859-1?Q?1Msl+H2qeN6qJtFEHqm9+UkEptOOt46bgZECN7U9hcVlrzEYh4dwwyxqJf?=
 =?iso-8859-1?Q?OohJ8sUr8A0YrD8fvw/APqlgvMvpkSY3oWcnZ6tulhyDrixBswQmfLbS36?=
 =?iso-8859-1?Q?bCoivvrIJj9nVhYSn8Rb7M7QMe7moOqjUhA0HIYR0R8su37ANhnbJE7uMK?=
 =?iso-8859-1?Q?QPoS6qfhfSOMYaD7iszXjvmrwjWE6ZKHVhKJwsIN6sRGNXwtMDjNWwybP2?=
 =?iso-8859-1?Q?zh4JGzw2Dkj4GIGaTRCJRvWdhpHlu1kw0eoYfNTUjdqnIVhwL7XLI8zAoi?=
 =?iso-8859-1?Q?Ucdx2w3cuR9on+jx2x2c6SVWNsvw9/VIkM1raXiR7X6eVgse3kh7wMGXgJ?=
 =?iso-8859-1?Q?qXzBqGM+cs4TvKm3LvZn627mHhVAuazruOV+zvYzz6qhpL1c6Q99gqkbTU?=
 =?iso-8859-1?Q?QA77LXt2lLNqNtAkxsIPvepwFESmOI62GzLZnmKSu82FQ92YoeiQzs9Oai?=
 =?iso-8859-1?Q?V0PMdf2xSPi36TtvRq6du1JLDXtjFmR5LAYc4Dqx8R2XFSPdASPOorfkYn?=
 =?iso-8859-1?Q?zamUL034N14JkTjD5mf5NGh3RSdXyhwIz4W1JTJo6Eg86rdFV0v0iU2/QI?=
 =?iso-8859-1?Q?mMORYJCqPU1lXo4MEunTsfc6UOFkiaqjNqXbZakZSxQnuc6pYFqhQ0NrRQ?=
 =?iso-8859-1?Q?oSiLa+CoRPYJE+S99uMC7s76ZRflQZS2HcWEGS+pSChcbNCV6mm1IcoRA8?=
 =?iso-8859-1?Q?q53kbJ+s+cTpVsHhJUi60/rDI4SvpgKpK8dmlWSzipw8o7pxrzpbaFe/HL?=
 =?iso-8859-1?Q?u6ncv7XLoAPpqtC8tVyCEBlv9aiNQ7c86YfDDNuP/s7ShodqH06lw/vS9f?=
 =?iso-8859-1?Q?kXQtadrcE+LqnsRzamdNhLZ1Z9p3fA3Dq7z1D0CHIJ7ODAPNeAJRHfWB0O?=
 =?iso-8859-1?Q?aID+Trzl+jGD0ZbFsTzW0RfMRmnsXHg+Fdy0pBsDsdJl7t0aJ6TEEpgNnN?=
 =?iso-8859-1?Q?kXFRAe5kLttDhzwt9UG4kCdCVgyMOBcGt/CKGEJOmuj7pb/McOso/rFRLy?=
 =?iso-8859-1?Q?FXh1eZKQgrDGYheTaxmc9YqGG1LJ4t5UmMIff+2ljnRw080OLpP8FgBr73?=
 =?iso-8859-1?Q?B3LiXYw50G6Oza4Z6QJ/HhXFRABeN75IAT+LX2jPz4wAQdFeEvHCBdVl5B?=
 =?iso-8859-1?Q?cFgy8hS+k4jitYU71YMtskRCSyo0mysTlXZ6jg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?E5G4+DEL7t2IUH9gTqUpn2VwA5qPNqKYFOZTNtKdhr1bLMlSRQxLmZXuFh?=
 =?iso-8859-1?Q?yFGq+ybbmUOozo+UCv808RNZYt+DhmKhxLKeWJc0mTWAav7kJi5DuhlJc5?=
 =?iso-8859-1?Q?K0HjpIASS1onlwLe9cqY6qq7HO9hLxaU2OBfSwbs8b9Dwvv3KMgQuc883Z?=
 =?iso-8859-1?Q?84gd/NrKVLCOOPFdH/xlXf8lvQCAPOrnjRCs+7TeE5j1xqfhueYXyQwKf6?=
 =?iso-8859-1?Q?gcpBN5i9m/9S0SWYilg5XSClcVpSONyxLrkzE8zzpZHlUEBc07yQ58eqnX?=
 =?iso-8859-1?Q?RRvoODqMT+0F9QFN8+xgX7EQbcpyHRBbp1q2nY7P51p/KahrE7RRhZKAdv?=
 =?iso-8859-1?Q?0Z3oN3D10jc3jlQ2cpWjHIcTntTUQq5qdrBJ6szZy3LGUiWJtPMuA9ir92?=
 =?iso-8859-1?Q?ez13Jc7mPq4f9lJHzTpJ8e6RttTpqrt8ZZxq2H6X7cbTBW70a1i4JLgaga?=
 =?iso-8859-1?Q?KTmMClPQWZOyWIVrELn7InpwABoDnADae1DotCfwhlLDiQ1UhVN1yNpgLm?=
 =?iso-8859-1?Q?n9sIEBZcqnU5M0L3/qLeiId4upqk5jIOQ7biQYqygG8MOQVD87AfO8+Eum?=
 =?iso-8859-1?Q?A5jY7bL8nQhKBDzsS9qOuWG30DsKWjioBBxcetb2r7Be3YN/4FIDmLRywX?=
 =?iso-8859-1?Q?W8IAlvqq3zGtYXiG5khG1/3R5w7ZfJC/VFDaM2SIomh2/jvEsz8ucvOgEG?=
 =?iso-8859-1?Q?pQTAfxn/puZ+EZTwbIR9e47Z+0eaLvhTBYZHl/GUEJ7eDIraQcRfhZth4z?=
 =?iso-8859-1?Q?4jIifMNFeOlyFhptS5DKpniCcGO3Jc9g5jXPLgP7gfsvX8lNYoZKXIX9lv?=
 =?iso-8859-1?Q?rqzMDrGJqqK2AllxoDajqknYFyeQ0BJ3w2H2Au0QtuGt0R+Ro67OJEE/Ti?=
 =?iso-8859-1?Q?1KiBair22kDkR/DJRFKPnCmpQtwax/dYION2jpamfEQkrlaLFTZ0bPAiX/?=
 =?iso-8859-1?Q?Vul7URuzKshir59MuTrs23SynfsrxH/4dEVWeTXlN2wrQFSYAzvdEnaL7u?=
 =?iso-8859-1?Q?hrEN8Fub2VaLhdW+L/k0QhJtBtp7SUB8O40UiUJ3qc0RPA9rOTq9oGizM+?=
 =?iso-8859-1?Q?v1ntdlJAS4RyXLMc6YEelnGeTLAXTlzwCxaM46JHSpqSWMjV50wXiywvjN?=
 =?iso-8859-1?Q?c66tYlKUCk728Xfa+ZgDMoyn640MVCj+cFZ2qRgcs0g9/IfBo8QnO7cGXv?=
 =?iso-8859-1?Q?978Lqjlej9pkm2DXqHQt3lddXI5xnMAOQFbgx7C71t+NVhEkMuxd5+X2Mm?=
 =?iso-8859-1?Q?1otCCCvIzeR4COJ3xXQqD+Q3R4HavgVvf3cPEkohZCjQoaiIFyYY4yUTse?=
 =?iso-8859-1?Q?Hh0cTNmjgJYN3OI4qXA21FhhiyMaRzF1oNdV0YEQAtzrj89FTfgczHYwPE?=
 =?iso-8859-1?Q?UVfiznXDNXW9e5r8Vjb/+PII2hGZWUu/JbRrGzYqcT1sXcSONH2uunk1o5?=
 =?iso-8859-1?Q?FNotEt3azACn5DFWKz/6laIBN4odeRybj86f1s3TRENyUo/6JS5qmGn1WW?=
 =?iso-8859-1?Q?e4quHP2MpCKvr8T/w7xRVdYD1O9cZx9VTPzOEorAbCgBCW62iT/m19NPQV?=
 =?iso-8859-1?Q?nACiXiu2IuQ9zfjO6/roD5y30Fs9e3ySS1G8AR+3wOsVZq42QPQ5qYubWX?=
 =?iso-8859-1?Q?lpoKhPmlwUriercMBDeqoqvtoWetV/b9RM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0974c2-97d6-40eb-e17a-08dd2ee587cd
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 06:35:53.1110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WbpSWLMYX0qBbSHTKwP+i6Jc6XFU/E8rnOUAebKgZm98Za6LEYDqVldFLEBD2dItNmZQH34tbO7bmpHqbeeruQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6421
X-OriginatorOrg: intel.com

hi, Breno Leitao,

On Fri, Jan 03, 2025 at 05:41:56AM -0800, Breno Leitao wrote:
> Hello "kernel robot" team,
> 
> First of all, thank you very much for running these tests against the
> linux kernel.

you are welcome!

> 
> I am trying to reproduce this report, and I would appreciate some help
> to understand what is being measured, and try to reproduce the reported
> problem.
> 
> On Fri, Dec 27, 2024 at 11:10:11AM +0800, kernel test robot wrote:
> > kernel test robot noticed a 98.9% regression of stress-ng.syscall.ops_per_sec on:
> 
> Is this metric coming from `bogo ops/s` from stress-ng?

yes, it's from bogo ops/s (real time).

one thing we want to mention is the test runs unstably upon e1d3422c95.
as below, %stddev for it reaches 67%.
not very stable for parent, either, but 7% is much better.

f916e44487f56df4 e1d3422c95f003eba241c176adf 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   4115705 ±  7%     -98.9%      45562 ± 67%  stress-ng.syscall.ops_per_sec

below is the raw data of 6 runs for e1d3422c95 in our tests.
  "stress-ng.syscall.ops_per_sec": [
    12892.83,
    98074.65,
    65206.14,
    11507.57,
    55012.11,
    30684.44
  ],

take that 55012.11 as example, (part of) the stress-ng output is:
stress-ng: metrc: [6604] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max
stress-ng: metrc: [6604]                           (secs)    (secs)    (secs)   (real time) (usr+sys time) instance (%)          (KB)
stress-ng: metrc: [6604] syscall         8878630    161.39      9.86  31058.22     55012.11         285.78        85.94         10512


another thing we want to mention is we also notice a WARNING for this commit in
another test, so we reported
"[herbert-cryptodev-2.6:master] [rhashtable] e1d3422c95: WARNING:at_mm/util.c:#__kvmalloc_node_noprof"
in
https://lore.kernel.org/all/202412311213.4e69877e-lkp@intel.com/

not sure if it's related or could supply any hint?

> 
> I am trying to reproduce this problem, running the following script:
> https://download.01.org/0day-ci/archive/20241227/202412271017.cad7675-lkp@intel.com/repro-script
> 
> And I see the output like the one below, but, it is unclear to me what
> metric regressed stress-ng.syscall.ops_per_sec means exactly.  Would you
> mind helping me to understand what is stress-ng.syscall.ops_per_sec and
> how it maps to stress-ng metrics?
> 
> Output of `stress-ng --timeout 60 --times --verify --metrics --no-rand-seed --syscall 224`:
> 
> 	stress-ng: info:  [59621] setting to a 1 min, 0 secs run per stressor
> 	stress-ng: info:  [59621] dispatching hogs: 224 syscall
> 	stress-ng: info:  [59647] syscall: using method 'fast75'
> 	stress-ng: info:  [59647] syscall: 292 system call tests, 219 (75.0%) fastest non-failing tests fully exercised
> 	stress-ng: info:  [59647] syscall: Top 10 fastest system calls (timings in nanosecs):
> 	stress-ng: info:  [59647] syscall:               System Call   Avg (ns)   Min (ns)   Max (ns)
> 	stress-ng: info:  [59647] syscall:                  pkey_get      156.0        127        185
> 	stress-ng: info:  [59647] syscall:                      time      212.5        195        230
> 	stress-ng: info:  [59647] syscall:                  pkey_set      235.5        193        278
> 	stress-ng: info:  [59647] syscall:              gettimeofday      282.5        255        310
> 	stress-ng: info:  [59647] syscall:                    getcpu      457.0        388        526
> 	stress-ng: info:  [59647] syscall:           set_robust_list      791.5        745        838
> 	stress-ng: info:  [59647] syscall:                    getgid     1137.0        974       1300
> 	stress-ng: info:  [59647] syscall:                 setresuid     1146.0       1070       1222
> 	stress-ng: info:  [59647] syscall:                    getuid     1162.5        902       1423
> 	stress-ng: info:  [59647] syscall:                 setresgid     1211.5       1159       1264
> 	stress-ng: metrc: [59621] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max
> 	stress-ng: metrc: [59621]                           (secs)    (secs)    (secs)   (real time) (usr+sys time) instance (%)          (KB)
> 	stress-ng: metrc: [59621] syscall          114464     86.78      1.27    364.05      1318.95         313.33         1.88          4500
> 	stress-ng: info:  [59621] for a 98.30s run time:
> 	stress-ng: info:  [59621]    3538.93s available CPU time
> 	stress-ng: info:  [59621]       1.26s user time   (  0.04%)
> 	stress-ng: info:  [59621]     366.66s system time ( 10.36%)
> 	stress-ng: info:  [59621]     367.92s total time  ( 10.40%)
> 	stress-ng: info:  [59621] load average: 80.45 43.94 20.82
> 	stress-ng: info:  [59621] skipped: 0
> 	stress-ng: info:  [59621] passed: 224: syscall (224)
> 	stress-ng: info:  [59621] failed: 0
> 	stress-ng: info:  [59621] metrics untrustworthy: 0
> 	stress-ng: info:  [59621] successful run completed in 1 min, 38.30 secs
> 
> Thank you!
> --breno
> 
