Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792762962;
	b=QEIznw/3vSJ5ikLp4Do0Vic5kQ9J/z07irJvMquXPqLbhTKyW9/lEYJGwp2izHtNwxw6
	 1h6iT5a0/QIPZ4bYLuHd8i1zOU7dOldCpVEkP8Z6GgSx7TuLM/lg49g4GxoYrrRxUWIH9
	 9pGBiazG9tWbAIfVBoUguYojVygLjcAnL03TQ+M9s2yAjBxlP3ADxL5Dg2E7G/ucKNqw4
	 9GEdv72i21EedMepIlEbtmwh3qxbRD2baQfOLtH6zLmJyOXK9j8lY8Bvpkprm0B5wzdFy
	 9cWu53LtkG0MMvMN4adHX5uqE9G+OqqDrNlqZiX2q1sZKG85IqdPai6wQw3owV2VBOA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792762962;
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
	bh=C5DDVEmyKrAYkkXxMgA+xZDuu82mvi1itaMcPdYMRsk=;
	b=fKqsajU8QOX+K4oqpehN4L/OPv4zX9KwQa+vvARMV4rjfELZniqtuk9jB650ghR730p/
	 8I6FijPCv5C2NB57qMjIzR7kM7mxVlSHQwCcx92KI2wS323aT/q3o2ZrvDfgOuI+gBO0O
	 rx3C+XeEDP6jQCgSdBNT5PG2Vjcquny83uJzdtkNlCQiN+P+geCulnQhwox67Oq/0mEOZ
	 +2DyhmXyIFa6m/WJXxwmCIkJUDubl51cReZ1c2XS+ZRK8oiS0+k3JdEd/xxfKph6LrJzP
	 NvxFKSawbUB3ya6RWw+Afu9WNtwq84juWLi2o5Rfp2416Qcr60fsRfF6yMHtjqiFoug==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="k1oqal3/";
	arc=fail smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5480606A31A;
	Fri, 23 Oct 2026 13:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5480606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=k1oqal3/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792762962; x=1824298962;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gpQFmda+1bhwfPpLhxa4rrzQ2w0mAXbckVV9BZ2saZQ=;
  b=k1oqal3/1CNJOEg2lC2uPD2mtl3ZcjDEoKy/M93ZO8wCxa+8te8nPMHz
   TMwoOdtpu1vrC0/JSDwsouHK0Lktv1Kserv+vOanRrFOhHZvicKu7zJm2
   WZwlkEOlSMMZV13MANICGvwXJRbTPTqlpsGd2bqTbdp0MsvpJ3iDODgNs
   uag0bX5h2Ku9QZ+NW9Cw4n2tJ279vlcFgjV1MCQ1FgjRhsVvU+NeA7ujV
   W64D6fK7TgZCvXLyTqV/VvGV6RcCs5m0epnPHU/yLZMuF+yWOJFU0bUPh
   Jm/pb/9rNIF6MdbMhYUp0HGaoH9CTSmddRKGhKBGesoS4YRYr47xGjdU7
   Q==;
X-CSE-ConnectionGUID: lQpdEM49TWaSkywMH2IIiQ==
X-CSE-MsgGUID: OcDCg1l+Tm6vvdHBwf1Fdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11943"; a="1559139"
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="1559139"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 06:42:41 -0700
X-CSE-ConnectionGUID: fC1FYxDaRQ+nbzbKkbY6bQ==
X-CSE-MsgGUID: AG7qLgS/SvqqHtfUhl24nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="4011117"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 06:42:42 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 06:42:40 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 23 Oct 2026 06:42:40 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.50) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 06:42:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QGaqZlAPiKnZ544GEXnz/Z2zLxaumPViXaXDt8CyZ2Kfn+xk7axb2r/yhJ8ZEvBn8t9FE0A/9vrLhKHeIrSkelk9C7HKLb/X/xfLqyxdYBzlD4khEguncW7gUEIzDZkapePsJws25fQOfgjx4H8m6K7gx9BNwDL8qo3zyr46nhF1qBODFZhhmuuw8zHoR1foogXMeVfYZaWoJwYDfJ5HODeNE1KhcVs81D6I0de9lWqdGv03qT+dFct+MAfaulAT4j7lDezO/JTjqEKGSDV60bKJkjHkjrX0kWfXq0T7/27i4qyl4TfKOxgPIO+DACQey/a9yScQk16dwnAglxofOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C5DDVEmyKrAYkkXxMgA+xZDuu82mvi1itaMcPdYMRsk=;
 b=FbMI+Y0Qiv2WrHfDe9wGm5aA6iCW6kNgybf+ZpRyHMqFDJksmUhO+NfO/AQGTb/wE1guf3CNKmjXzemJa9WUFg+skiwJxIHrNU00B1irViGnLEd1WqhasUQj5mu3Sy73ejP1S3YPbuE8xIQVoD4+Nt/zI+P1Nsu7PZLOwwH0BUNMGoJpCZs1fdRPTJ00TXyIdMMEv5itc6eL0JXQVd5WSWS27ZlXraOMmZepX7s7oH8aIlt/tNjTLpGFpvQOPMqchhv0rgw3NP/k9/INlCt/8F2SF+zq1iVH7bB0W+w704NRN9sNIKotvFOskAneKZuozvlQRSpgbetQ9/5vCrLNdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8718.namprd11.prod.outlook.com (2603:10b6:8:1b9::20)
 by MN6PR11MB8102.namprd11.prod.outlook.com (2603:10b6:208:46d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Fri, 23 Oct
 2026 13:42:34 +0000
Received: from DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::6aa:411d:4bfa:619c]) by DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::6aa:411d:4bfa:619c%4]) with mapi id 15.21.0496.021; Fri, 23 Oct 2026
 13:42:34 +0000
Message-ID: <3c25921c-7bdf-4edd-ba06-838dd1765db6@intel.com>
Date: Fri, 23 Oct 2026 15:42:28 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] unroll: Make unrolled, unrolled_full and unrolled_none
 function-like
To: Tzu-Ching Yang <shingekinocore@gmail.com>
CC: David Laight <david.laight.linux@gmail.com>, Eric Biggers
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
Content-Language: en-US
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20261022110959.1173447-1-shingekinocore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU7P250CA0012.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:10:54f::25) To DS0PR11MB8718.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS0PR11MB8718:EE_|MN6PR11MB8102:EE_
X-MS-Office365-Filtering-Correlation-Id: d2c06563-0a9a-4604-0292-08df310b7e1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|261021121427099003|10067099003|56012099006|18002099003|22082099003|4143699003|11063799006|261022105027099003;
X-Microsoft-Antispam-Message-Info: /uxzmPViLFMSJD86W2H0JMPMH5CqyJTPOHnrs+SlwBZIj1zlfnm5MLYF7JoaCrJNKsB3sMBlkzezPUZ0vlg9cpRx9pVAQ7SPwCKGd04gZBkrvbBH/ykkdAn1QoxnkzomsehsaoUhyPdKiVeQcPqgermUwzCatkKHb59UCTl5IqnE3+PaJkdTMERWRt0JyHMuHOD++LvFR3KenknekpQ4ob8f8D5/hzKoLKW/8Cye38HuqLpwjvZpaG7RRHjiPmtWXib/IhNdriQJXR9REbe5WF195pWyg8fZ4YUra9LV+kOSV9jno2yDJGb4KO3mNmogc0Q566eX6LSOagTGXE0hZI5S9vLRV8kKm76FZWrqrX+JyxOR5d10HH6sbTQ5vxwUWOq+YMGMdbkDH9iFErppql4nK5cBvnRI2sKlSQl8iCthAqm6kWoxPFD4d6Ed8APmUgDWUP2U0DwFvYcgdsdSgMN5AoMlLevy/BsedVrnH7Xn14GjO1bXiyKmsFTsCm5DKoWJTXP+nfMg/XrNiJvJq8dHrkkWEElFwa9aXe+bvWgEIkoh6cFr2h/l7JAJieROGvjCqunDs1t26pATo9SVRsZaU+FCC91aQqoUAV9eJo2RapjzlEMO4VuHIE+7hVwQcfg1kpPf5+/j7qNZ0uVNeAFe3QYICvZdHPhYQxFwLD0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(261021121427099003)(10067099003)(56012099006)(18002099003)(22082099003)(4143699003)(11063799006)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wi84aXBxOVRSTmlLSHRVYXRHZnBtTWczcFhiNFdwSVNUU0hnTjdZSFo1RTNt?=
 =?utf-8?B?RHlSNktGNmJFZEJuaUVFSnc0blpxdDBSSlpjUUQ5VHVKYkdLd1MwNlR4d2ZW?=
 =?utf-8?B?N0MzNkF3RzUzWmRvZUFwWWNPSWNMS2Q0eGdGWm5OSTA0ZXlmLy95Y2d3YU5C?=
 =?utf-8?B?Sm1ldlNIWkdTSzNrajlqUVRxUDhUZjZCOUFISWdac21FZHl1YVdmV0hJT3R1?=
 =?utf-8?B?ejRqUXE0djI2TVlkUTZZNFpZTkswZkdhemZCbDE4ekxTUnhkMlpyNFdmSTJF?=
 =?utf-8?B?VjhHczN0NGw4bEg2ekE2RGJxQ2cveUtUbUpwVGRtbEJtUDBhRnVsOU5wK3VN?=
 =?utf-8?B?SkVzRGtVY0JMZ3NpR0xvSjFRcGpYR0YrdmNSYkVhVktPNGFJb0tsT09xMzRH?=
 =?utf-8?B?ems4U3hyalhxS0htQ1pDVGRVc2tpL3BRV0Nwb2o2d1ljZmhrRTV3VHJWcm9N?=
 =?utf-8?B?SXM1a3NibmRMT0FXVHNjMzJPdENaaitTd09PaFBFRU92Wm1nQ2JTZzUraUpW?=
 =?utf-8?B?U3FIaTlOZHAvOFlhNDh5bnl5cGJoR1ByY0QrZ2o2TFY3RkpULzNLYnNxaGF1?=
 =?utf-8?B?SUdSUWxPN1ZqVnBhN1ZVb2pKTWswa0VuRW51Si9QWW5CdlZXNGVYVUlrYXpl?=
 =?utf-8?B?dFVMNXZyQnlKSjcvN1dsVGltRUdrdnZGTHF3WnRDSmNQOWxCcUFVWFJsR21r?=
 =?utf-8?B?MC9mK1FMQmpMVUd2ekJZQVgzcWhkcm01ck03M2NneVBUK3lYaHNidE1pR0ky?=
 =?utf-8?B?eTRRSVJEa3YxWXlkeEVZbEtWSnlzOGhEaERsSGNXc05GVmlCM0F1U1JsaUYy?=
 =?utf-8?B?WDNKYW5ta0dYMFRvb1l5SXRoR1RYaVEyWjR6M0Z6dDBlNzBHUmRUR0x2SGg0?=
 =?utf-8?B?QkRLenI3a0NCbElPMjVreW1NMkZDOTZ6enliUXVEZkhGV1N4SnR2T294Vkxq?=
 =?utf-8?B?R2lDQmdHN3ZtR3NkYld6UmVvOWFHejNlWWVVSWVtSmNuMEZSb2pSc2Y1c29J?=
 =?utf-8?B?b2N1WkRvTlg1UWpoZnliSDAvNTA4TUUxMXVjcktwUkRCT2VzVmN3YTdzOG5i?=
 =?utf-8?B?N1NmbVBJR1o1cEMwOUliNWtUckNqd1R5TDRaRHpDM25lVWxydUxJMzRLcHRN?=
 =?utf-8?B?OE9qWWh6c2tjeWQ5dmh5MHZpKzEyNnloak9kd1lTUVdmUjRrNWZ1aTRLbUdt?=
 =?utf-8?B?YjZPKzBqSEptYWNROFV1OGpJTXRleGhpSHFXMXZXUWFEQ1hQMm9FK3d4cTFp?=
 =?utf-8?B?ZHFXYmtaVkVkMEx1aWlkdWRrcTZiRXA4aU5RaHhydVl6dkM4K1ZoVGMvVjhy?=
 =?utf-8?B?aEFEV2hNS3grMEtrcWZ0NU05OHBhdVpMNzVmMXlyZHlpanowTjlTQ2preDJt?=
 =?utf-8?B?dHRvVWZTdDNjWTU3eEVPVlpyelZRR0NCenFhR0JkcXhtYjdKcVRqdFBwR0V4?=
 =?utf-8?B?dU4yVUlXdFFDMTlYcUdXdmw0YS9EOGdZUjRveHJMMzdoMWs2QU8ySUpManRj?=
 =?utf-8?B?WjZMNktiT2hKT1VtQmVGUFdwS0lWTHhlQVlZTFNwTmZKMkFMM3NGTGhZWXQv?=
 =?utf-8?B?RXU3dzFaUjhoQ1FTakRzZlRZTmUvYXZadXlQUDRrMm84eTZGYzRiclQ3dG5S?=
 =?utf-8?B?ZVVTT3R3dEc4cGZUblFvR3dxcW00Z0c5VjRMMGZkWXZkVisxUXhnT2JCR2xG?=
 =?utf-8?B?RnFlWUZXajVPNjROZ2pxTmR0d2Y2RUhReldVY2dEcWx2OVA5Z05iTTVEK2wx?=
 =?utf-8?B?T3huSTE2Y2ZmdVRDSlVPek45anpRVVYvRUh5a3poZGRjbkVtWmRuL0JCSW9a?=
 =?utf-8?B?SXFWMkZKcHJmdktUOERBQTV3dGtsRTRqZjRuZElEMmJ3eXRWM1BjRWwremVj?=
 =?utf-8?B?Yk90eTBWaGF0d2c2dHZjamZvUFBVL2pqV3AzRXB4TmZOTEJSNVNzRFEra0dK?=
 =?utf-8?B?bmoxSXRtQ3FJSjhTOTlDaGhKWmQrRmN6c1l5QVJaV1ZiNi9YaC9NaGFra2lt?=
 =?utf-8?B?K1RhRWI1ZVA0TUFCWjM5RzFIbE84Q2RmQTYwbWQ4S1pvRm51UW12NU1TdVNM?=
 =?utf-8?B?bGtTMkFPdVdnNDNQNVQ5cGRSR0p1bitOVTJ5WDBmLytNMHBXU0w4SXpQVkRY?=
 =?utf-8?B?ZTN5Y1c4VVNuc3MvamZ2N0J6ZzVvdWYzcTdlTEZRK0YzNWVRZUZVbDZzZnM5?=
 =?utf-8?B?c0xubFhxZlBzVUY0QVAyQVZJMGNOMjJQcW1RcW5XRytaME9uQnhFOTZaM2xr?=
 =?utf-8?B?ZlZhMEJydy9FMjNDa013QU0rMWx4NVJrRnZnSGhiMzE4Q0pLUVozTUd4aDA0?=
 =?utf-8?B?TUlMU2pzVklUQzdUNkJNTXdNdkpsKzVTSnArZHpRQjdqTzBIVlFoVWc1eDFN?=
 =?utf-8?Q?6ggW6JMgXQO5Bh+A=3D?=
X-Exchange-RoutingPolicyChecked: DzUwpZlyoolsPrwGaYoGyhvhv62MQh/u3riSm+o6iBf3D7ClEJXgw6SjNcR1QbRoQwUcOmO63gWKOKziwsouZoFfOQ5yYYU1fwWl83ICAJuFIqWN7zm9VRkSeNbmxLfgGwdWYP4E/aJvpcR/8U1QDgcD1hayfNOgF4skbyXWitRFjbSrbnC4SyoBzTQ7hDecZH5SI5MS5i/fOaNfmX3EJBgJ+xvLAUAE222E6gHiBIfFMppnJJteSXLCDNd2kfu6gMgBk+vTkmnsrTpw+47afHeldH3z+rePkXJSP5I0ktl2AVsrBTOEHXWepQlB7BWVw0Jj0iDVu6YkOWDbfsDHcQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c06563-0a9a-4604-0292-08df310b7e1e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 13:42:34.2539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p5McxHk3y1o9ZU3CvlAK5/kwTx4tk46um5YhutlBmrVSlsDQ63lcG4787EwUIdW6AYk5usHc/BG/NxL6LaOUZWn2WaV1RWzXIPD+Y+0Eiuo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8102
X-OriginatorOrg: intel.com

From: Tzu-Ching Yang <shingekinocore@gmail.com>
Date: Thu, 22 Oct 2026 19:09:59 +0800

> On Thu, Oct 22, 2026 at 10:01:40AM +0100, David Laight wrote:
>> Is it possible to make the syntax:
>> 	unrolled_for(....)
>>
>> Or is that made 'all hard and difficult' because he setting is sticky?
> 
> The pragma binds only to the loop that follows it, so it can go inside
> the macro:
> 
> #define unrolled_full_for(...) \
> 	__pick_unrolled(clang loop unroll(full), GCC unroll 65534) \
> 	for (__VA_ARGS__)
> 
> 	unrolled_full_for (int i = 0, j = 7; i < 8; i++, j--)
> 		s += a[i] * b[j];
> 
> GCC 8 to 16 and Clang 17 to 23 unroll this fully, and the same works
> with break and continue in the body, nested loops and a loop inside
> another macro. The count form has the same shape:
> 
> 	unrolled_count_for (4, int i = 0; i < n; i++)
> 		s += a[i];
> 
> As a fourth option, the _for forms would replace the four unrolled*
> macros: no clash with identifiers, and the loop reads like
> for_each_*(); the cost is a new loop spelling at every user. Olek,
> Eric, would you prefer this over options 1 to 3 from my earlier reply?

I had considered this option in the past, but IIRC the unrolled
attribute can also apply to `while` etc, this would limit it to
`for` only.

Honestly I think I'd just drop the unused versions (`unrolled` and
`unrolled_none`) since they've gained no users for their entire lifetime
(sorta understandable since the former relies too much on the compiler
and the latter makes sense only in some very constrained environments
where usually, the related compiler flags are used globally instead).

> 
> Thanks,
> Tzu-Ching

Thanks,
Olek
