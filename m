Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7652A3093C6
	for <linux-crypto@vger.kernel.org>; Thu, 26 Mar 2026 09:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774517798; cv=fail; b=N3T8rBNn9O2Ga1CT4tlvAIYd0ECZQsV3F2XMq6NiQdZmot2AV2mbxMjCtCkeeYDKStdosgyfTDGqoG1HOQGarwztPkeCbaPmMltZ2r5LiasA/ZcGzhgEIdQh6Xw563XjHUmLwWpVkEGgKUPWbTmP6CDYa5kGZW5Wvuwf8SjLrsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774517798; c=relaxed/simple;
	bh=VfMvl5PWQLvaGup+fH6p9ij7OjevxOKZLy5DIbMONIU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WLH1bdSYjAZC32rXSv5nlrN++QDOdB8O5d+UqEIKbhmatW0PptPKBsp7DmlOwPrVbM0MH8QtINLkzmx5HRbiSaU6oTvo6sgecsU9ICwXDn9uiQFOhgMaBQz7XWmAfYWQfX0j8wyHoya6W/T19mUuNhIdfwOIYSsb1LYnM5kHWaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ma4CFOLz; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ma4CFOLz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774517796; x=1806053796;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=VfMvl5PWQLvaGup+fH6p9ij7OjevxOKZLy5DIbMONIU=;
  b=ma4CFOLz+SVIdqogtEqCOZCU7UTjdnlzsjzp9ZieyeFzJ+FbyWaAemh+
   59KIpuTDszpCAurVAnA/0jA8lnovoWYQIZ6dut+emtTBYFljYrfhOwcMp
   m46lln/TT1iR16NRGf3tDQzTxv1is7irbMP5al1qYnBQq/80W1jGwDVdq
   5yniJ3LGHnKxmiIop2/v2KV0QH6BFa2y7pRd3FQJMoi6Z1pH4lIA4tcBz
   FaVI3d8R+AvmGDLHAB59p00Vud6CM58wUT7aRBKdbUucrowJtG+1a9S3W
   zXZMas0iUAU4+KjnS6xgBSa9msTKZ3RtoygOrcsTs9fSUsUZlax0DQvhw
   A==;
X-CSE-ConnectionGUID: Rfs+5U3tTtGTZh4PSVGp9w==
X-CSE-MsgGUID: iRLHEpIVS1mOjQ9uaq6pKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="78166147"
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="78166147"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 02:36:36 -0700
X-CSE-ConnectionGUID: 949EkGI6T2+z7eFoQmZ1cQ==
X-CSE-MsgGUID: Ygy4TDKjSiaVFV2mLBxRtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="229721483"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 02:36:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Mar 2026 02:36:35 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 26 Mar 2026 02:36:35 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.53) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Mar 2026 02:36:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ft42rqPU7+i8We0P53DxFQu0xAhNQUMcxHObbLe/p5CvuKjsgHrDeYu1IhLV50/UsZelKzNJMtQGL8Y1PNrFZr0/6ERQv1WyeiR7jjRBH30Hn583Iwap/NRZWZO2jc9Ys+6nAl+JQNhJG1TItSX586SLAesyLjEp31yWA3TtNixD0xkIrfGGJmJoSAOwp3Zh27gOsCNmOLS+hWH4XS1x1bU1xH260ufVbKUkTPLUxirCepYDeGV2K2DWWiVB8CNod6cxmj/GStWnBUb7POmjxpA3r8GtGFeRYA+3L9+sFpYS0Ngw1oRUjQM1kiCBpnKUWTcCYJmm2yLvYJ8RjwpxMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tFMxNizTgRTHt52ba+lq/+EpyckcvZErlSg2hFNr22c=;
 b=fLnxIhRloZw4vBndhlAvrTnfeIhVfOdmFvEIawmwlQYR3zBr4CZOIxGa4a6fVhuC/v5tVXPXu6F361xvh6pNxHFCz2yvqwkWYkF/seoFYwu9xNTX89pQsSt/1UoQN4CRJxcXsFJl4LaN2mvxapKjU3STGdFbcP4X/ocB1FFTv+Lc/JYZKHLMfCW0UwdN7+8udrMxfoqWAGsJUIJ+2c7yAxNxOd9t2vcbvvht1U+g8OFA8FN8BgqhyrpkXb4IRu3ge4Ezw7ee0LLQ7vBVVO2AWW4hT7T+BP7dLsudHZ607tHcVQ4io2feijgZO3FT9X9IGSq+bwxJqulueUGhTufNfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6407.namprd11.prod.outlook.com (2603:10b6:8:b4::11) by
 LV3PR11MB8674.namprd11.prod.outlook.com (2603:10b6:408:217::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Thu, 26 Mar
 2026 09:36:32 +0000
Received: from DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4]) by DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4%6]) with mapi id 15.20.9769.006; Thu, 26 Mar 2026
 09:36:31 +0000
Date: Thu, 26 Mar 2026 09:36:25 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, Laurent M Coquerel
	<laurent.m.coquerel@intel.com>
Subject: Re: [PATCH] crypto: deflate - fix decompression window size
Message-ID: <acT+Gc/xKHa0EsDc@gcabiddu-mobl.ger.corp.intel.com>
References: <20260324180905.120703-1-giovanni.cabiddu@intel.com>
 <acTx0-uYRgjaTLU9@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <acTx0-uYRgjaTLU9@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU7P190CA0003.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:10:550::16) To DM4PR11MB6407.namprd11.prod.outlook.com
 (2603:10b6:8:b4::11)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6407:EE_|LV3PR11MB8674:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f701a1e-f2ce-41b4-7cf3-08de8b1b29dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: eMCpPC8GiFbWwysZmUfs/RuXbbtJwh+RuvEjnHY6/cK0cZVWbeHIC8qcKGmoevn/TZB6EqA5DUC/jwcXtZvj4G4o6GfwEF5Cv4ZaWl1jua2yID1qT9/Weam0N92UIdfA9h5rkpy8KZ+wrXHGHhtRdL1Zu7c3x4BrKh336hBBpBElHBvF6Ob2N5hMUb7dOyCAbqiauMv3B8OBTpxcFSt5YDlInkHgfqSqsL9+2Z1moDRbsIicmIAvi3F1CIlSLeyYnDKNAibHSfPYaReOWqnpemriaPkji6cGyYbmFrOA+8TQug3h12tpll1rIJ9beEsH5hDXNfi64Y6Y/NVEAYUQqaGomVi5Z/7L7UbmqJMHtcmso25HYRGhjioRF3vIl0Owa4r63RtXDj78R+MDukABZRnnHIvI6cHWRcs/KwzZb4kWPA+9tgpsw4tB6e9Uu6virHY4gyqJiIbV2rJNmq7MGCijKHSImhEGN3O9Spp6+tpFjejo+teDdH8LjhIfnfyfCgVxER8c3bXD3F+ojRTn7Ce+Ast0KzDftKR3VmOKdoT3AkHHi86xI2tB/vD+CYXCYD4G3JLJH03XqCRRb20qMB0WNU5uw5gGgrAcFfI36M4VG6Gm/Or4+KyoaTgCcPIXjRT8dMpS+JydsYlZmAULiFD57kkZPvcCfUwSC1Bp0AU27+bJI0lz/XpF1njfaEzTnYNSw0hNf/bAmPNjBQSp7ocFCWQXgbBgdsOcc3CLyns=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6407.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alBEYmw3bDQ5YXY4V2lmS2YrYTZzZ3FrZnUzd1F4Q1psdEkvMFVzMGo3a2RO?=
 =?utf-8?B?WUhPM256Uk9ka2R5VU8xQ3FIRCt4N3Z3WFd2Yy90MTFEMUxVdHlUVlRXcWht?=
 =?utf-8?B?R0xLaUNvT1VrQk9kazVDMkNvdmxOd2o4SHJ0K0w3L0VTaTRDZlN2L3lHVjZF?=
 =?utf-8?B?ckZoSHJJZnBHUGpMbEw0NDdUTGxuYyt5NDJJcGJNc3RKMHVrZzg1ZnordGFo?=
 =?utf-8?B?QkJqd3JOOFdEWFBWZjFiWUFEU2FrSHBWcjZFSFFTaFR6c3ZLTklUUnVtUFVy?=
 =?utf-8?B?Zy9saEtJRGhMbW5LSFV0THAyVVJhSklCQloyU3cxZ0FLY2VCQ1craEdqNmdx?=
 =?utf-8?B?amQxcDJpOEhtRGpwZlF0eGFWUE03RXdZcmJTK2w0TUJlOEFhY3dIcGRvb2Nr?=
 =?utf-8?B?QTMzNnNmeEhMcUttUW9aZ2Nib0Y3b2I2ZThjMVp2MU50ZUtJUEVrUTFsV2Nu?=
 =?utf-8?B?eEZTa09vOFp4MENYbDJVcndSaURESEJXOVpjZEdqUGQzRWo1UDZtbFQ4ZnpD?=
 =?utf-8?B?VnNEcVU4L2ZYNWcvUUptMVpGa0RCTmZaUmhXMUpqd284SlU3Y0ZnYm5vNDVL?=
 =?utf-8?B?S1M0RnFNcGp1Q2tCVG1tN0QrZGZBLzVQUG1YUkd3c2F3d0dFTW1kcWVpTVhO?=
 =?utf-8?B?K3Q5dkZ0ZzZCekxlUlZsQ3RnenpaaHZMdGRyNVBmNGdQS01UL2UvV2t5bEZL?=
 =?utf-8?B?TjUyNWpiR0hseEFBd21HeEZSQVRJNkY2RjRvMHA5SzJXcEtSaVUwS3hkRFg3?=
 =?utf-8?B?ZVU0eE5nanlBd0k1NUZVWmFjZnJGV2NnTFNPZC9JWU5YZFo2c0g0S2g3SDVH?=
 =?utf-8?B?UEFkUk1SNk9abDdIQkZBbkQ4UW0zZTgySHAxamJZTVhENzhxeElUTU9sOEx3?=
 =?utf-8?B?dnRjRnlyZC94YjhmeDQ0NUJyNC8yazFUMnQ4ZWpFUmdncGRkMi9EVUpqaDBm?=
 =?utf-8?B?MXVYbXRPQWY4RTVRbVNvZ2dmMldDY1cwUE1GS04vNEZuOE9rRlAwZ2hMUmgv?=
 =?utf-8?B?ZW5ENXk3SmZZcW5BQzNBb1BQZmlZRDFoblkxWXQ4WDJZR1ZoUUF0YXhNK3gy?=
 =?utf-8?B?YUNxSTcyOUhHUkZSSlFrcFM3ejIyK3o2RVI0Y1U4dHVrS2NpMUlMUElHcHZE?=
 =?utf-8?B?NUVKZkhlMGxSRVBqQm90VlRMRi9xNTNTakt4U1ZxQlRhV1J5WWluWi9GOEJr?=
 =?utf-8?B?Q3RNaVR0anAzQlRHSzFkY3RhbXJVUzZhL08zSzhKdEhGQldSU0ZZQzAzUk04?=
 =?utf-8?B?dXRka0g4QTlUeTNTdFJEblNhTGJPUkhIZE5SQUttUmg3dnVlcHovZG9rUEpq?=
 =?utf-8?B?VUJmVmhiMy93K08rRXdoeGhlTnRxZFZleXJhWVNRekwzYVJBWmovTE55OWlr?=
 =?utf-8?B?NTNYMXFqNTdnMWcxdnNVYlA2TWRvNWQxeFJwZmQxeHUvSmhMWDdCcnJ1NnVL?=
 =?utf-8?B?bisvRzJpTG5SeW9SeXFzTExkb3MyQ1JjY1h3c0hYV1Buc0NjTHZPMHdXSXJC?=
 =?utf-8?B?blJkQ2tEMmhkYUw1SDVDWCsvQlNockJZYUMyNnlzNFhQeWlGT3pKRFJSdXFm?=
 =?utf-8?B?aUIwMGo3WGhkTVU0OTJVaGRHR1BGenYvTDJVVGRkNU1BdmVKN2REMlNuL3lW?=
 =?utf-8?B?TTl2SjI3eWE3R3U1VzZwWG1KQURtcU1yMkkyU1YzK1Jvb2RpREFFOVBSNk5y?=
 =?utf-8?B?d1FIRUxlQk8xbFdEM3czS1k2Q2IvN0R3ZDVadll3R0ZvNHd0OXRBTWJlMDBw?=
 =?utf-8?B?aXBLZTFTcUxCZ2h2c3hyNCtDWnJxTytUT1J3UXNNVm1RWHVFMTdUNGMxYXp0?=
 =?utf-8?B?N1BEdDNBSlFPWlpvcU4vS1p2aHlNSDM4N3MyTnFwMFczYlJOcURHTXFqOUZk?=
 =?utf-8?B?d3FobFJIQVZneEF3ZGhTbG1zOWpWc0NWSEFRUkJjRXI2UTl3c0pNdXZVTmlU?=
 =?utf-8?B?V3F0NThVQkV4aU9TMVV1NEJLbmp4OXdMZGx4QkJwY0d4U01vclNHK1h3RWgx?=
 =?utf-8?B?aXZuTWNmcUZxa09BeHZPVDl2UEs1U3NLTlN2UnRPWDhRNkwxSHVYYVYrWTQr?=
 =?utf-8?B?QmxvbEI0UHp4d3pkU2tKYUlyMHdJUngwakpMeUlpajV6ZDVzWUlWRS9tZ2JK?=
 =?utf-8?B?bkxiSTB5RThtZkNQUUVKbWt3MG9memNaQmw1ZzR5dko0cVgyMldRdjdVZWJv?=
 =?utf-8?B?cGNTaHUxRXhkN2xRNnFhM3ZLR0JJSFFacnJFL01udWtOdTU2OTM0eVljOVVa?=
 =?utf-8?B?NXpaRGFKUE9GajUwZGUyZm82ZGVTZW5RZE1wTnYrVHlKaFd0K01JNGV4QWQ2?=
 =?utf-8?B?RzJCZ1gxZFhFWDhBeUJVUjI4c3FpdHJPN3BuWklDa3QwVlBGQUlRcm5ERGZ6?=
 =?utf-8?Q?+3BMSghVOIQIdhfQ=3D?=
X-Exchange-RoutingPolicyChecked: pcAH2VV6R6PGryZWgTLJay6nABYfmia2Ii/FEa9cj1Lt/e5/j7HwSIY5K78Y584B4LNfUpoBbzXkunP1NlXynURvYK2TvnQoBALL22Adttq/7yj1BmoozwEIEBtba/tkDAuU8Q/p44E85jMkajIiN+bcRX8bPU3FuUAT7G9cZpFd8sArxtY84545CsQ7EjtYpiWhuqQ9/V/HB4lvzFWyuhvHFC+iS3l9Zl7yuRTMeNbiZSyHjAkPxsPSTjnz6zir91zIn1Wr001aIB5IaOWZhm0skM5nbk3T1pEyHLwQ2tVGDsL+Yn9P5Q1dMTGDBIELFxC9+i8z5RaLoKVz3n15Jw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f701a1e-f2ce-41b4-7cf3-08de8b1b29dc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6407.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 09:36:31.7079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oh2RAtL5SNarfxrtl5aBv3wFhg7dl/h1elzC9jGeHFrPJGCi4U8vFN39Z8Gju5mwZtNQVE6F1rEn3EGXGdsRQerJpGyIubeTBTkYAKMM3wo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8674
X-OriginatorOrg: intel.com

On Thu, Mar 26, 2026 at 05:44:03PM +0900, Herbert Xu wrote:
> On Tue, Mar 24, 2026 at 06:08:58PM +0000, Giovanni Cabiddu wrote:
> > deflate_decompress() initializes the inflate stream with windowBits set
> > to -DEFLATE_DEF_WINBITS (11 bits, 2KB window). Valid raw DEFLATE streams
> > allow window sizes up to MAX_WBITS (15 bits, 32KB).  Using a smaller
> > window than the one used during compression causes decompression to fail
> > for externally generated data. This might occur if data is compressed
> > with a compressor that is not deflate-generic (i.e. this
> > implementation).
> > 
> > Use -MAX_WBITS when calling zlib_inflateInit2() to accept all valid raw
> > DEFLATE streams. The inflate workspace allocated in deflate_alloc_stream()
> > is already sized using zlib_inflate_workspacesize(), which accounts for
> > the maximum window size, so no allocation change is needed.
> > 
> > Fixes: 08cabc7d3c86 ("crypto: deflate - Convert to acomp")
> 
> That commit doesn't touch this at all.  I think you meant
> 
> commit 62a465c25e99b9a98259a6b7f5bb759f5296d501
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Wed Aug 30 17:56:25 2023 +0800
> 
>     crypto: deflate - Remove zlib-deflate
> 
> But this simply restored the status quo prior to
> 
> commit a368f43d6e3a001e684e9191a27df384fbff12f5
> Author: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Date:   Fri Apr 21 21:54:30 2017 +0100
> 
>     crypto: scomp - add support for deflate rfc1950 (zlib)
> 
> So the commit message needs to be rewritten to clearly state
> why this is needed for the "deflate" algorithm.
My bad. Sorry about that.

I think the Fixes tag should report either the commit that introduced
deflate-scomp

    commit f6ded09de8bdaa405ab90b1b6c4166e69a23664d
    Author: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    Date:   Fri Oct 21 13:19:53 2016 +0100

        crypto: acomp - add support for deflate via scomp

OR the one that introduced deflate...

    commit 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 (tag: v2.6.12-rc2)
    Author: Linus Torvalds <torvalds@ppc970.osdl.org>
    Date:   Sat Apr 16 15:20:36 2005 -0700

        Linux-2.6.12-rc2

What do you think?

The motivation for this change is that data compressed with a history
window larger than 2 KB (for example, by QAT or IAA) might not be
decompressed by deflate-generic, which currently initializes the inflate
stream with a 2 KB window.

I'll rework the commit message to make this explicit and resubmit.

Regards,

-- 
Giovanni
