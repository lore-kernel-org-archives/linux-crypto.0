Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794580906;
	b=inckUMvb64pZGsDDiole5ZG+0qX3PPF1EtW1ZMVgJVGcR4YdEvWBSwInOwK/HgvdzBR8
	 Bvo/5RiGB/Ab4ehYRzsxSbH7X/afkSBgmYOe7n/Iim2mAJ/kz6d/+HlbqaDeMhmo/CiHF
	 C8Gi62HJ7m46hF2y++0CocFYYA45Zjyo/MwDy1HoK3/5OaZ9C/yfN7ZYnTkfPedTxeav0
	 qZwyLFP/bJzSjOVU+LjxPEmOTlij1mFFMo7ATNF+kKpoS20nJYrCqc9iMJ9lLm43BzZRR
	 kzvRv69VgYQIRudUYOHNmCRz5u3/xEd1Q1HCCPneKejA2tUtTCUsp6JrYMJtQsXhHDQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794580906;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:CC:Subject:
	 Message-ID:References:Content-Type:Content-Disposition:In-Reply-To:
	 Organization:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=3D36xf/nlWECnnxXReIxZRY8MaIO/UjnYI7D9CTjPeQ=;
	b=2vZtT6V4ukmLRNT6eRj0GYYwEm7lSdJwpKcCgxNxkETXjrIR8BP9a52aU6+8dHK8J7Dq
	 3N6lphAZpYPBkxxXjKdN0gHrgKPCfT7WePBqG9b3xjM1+Wzxa6Gvs50CQBciCRKZnYB4/
	 KEMqaC1LVtZW8rPBpdj5ZHzf4ihv3rtfbOm4fRMvpNb+xRoJvb9JFuM/1PJfrFgE9vDky
	 Wv9LaaYiy3x+rAvN6EfzhmyiE/M8kU5CHRIrQpsvEoq3m3gMBMESE5UfJdE0ZBevxA156
	 80ddWegWgWEcIY+rBQEEQijrsINA3wOtiDDfhxZre6cKsS7lrtrSIlcqPWIJ4LmoYag==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=d8LVT7IJ;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=ELj2iwj1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4029E606A887
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 14:41:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4029E606A887
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=d8LVT7IJ;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=ELj2iwj1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794580907; x=1826116907;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zz4uyzGM5UO0QYSqj9OUNMsHNXaW9ZyC99LBeecFO80=;
  b=d8LVT7IJoFFhl9TKHAopNTo11N8WqA5euc5urbC+wGJ5PRDRtWYLvb80
   cLuwA2a1BTmYU2QpVFoj9iLBZ5ueF+OJ/4Ont5qDBdYVuTa2n7OOF1aRm
   leaw6vH7vM67TNSZD8BgvMBVs4y2rxGTCwB5pVwkZeeOxYLgp3LP7h64W
   q6l+20Tn2PZmJso5OVgYPKZzPhDcT7ZeS4Jz0tXccQkUVUI1z81XSVwF4
   wCJMA2t+BO7GcX6nLnTedQLko1wQocSEhVghL1sJGrrLdRfYgVwQE+/SG
   oQ/BG590bobsmlBLiL05V3G0Ua2JUhWHCgDaMFGdzxjwSksN/lTtOvvlf
   g==;
X-CSE-ConnectionGUID: qjrQwspZSf2DX2bxKpIaSQ==
X-CSE-MsgGUID: h1/ZJAPMS6ucEJXRJitktw==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3416142"
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="3416142"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 06:41:45 -0800
X-CSE-ConnectionGUID: T4/m3326S4CaRB8TM2G/rw==
X-CSE-MsgGUID: QtrOi2xuRTa/k/msbA83Zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="9024484"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 06:41:45 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 13 Nov 2026 06:41:44 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Fri, 13 Nov 2026 06:41:44 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.35) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 13 Nov 2026 06:41:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WBuxMRkVAgT6lUb0NeQSlYomK/M2+r6wxixGI8JLVtUQprdeCfmCJsInzwciDq1krtm40xfsn9nLkJJwJed4OePAl8uIP7BYDNtOgUue3H2sXSsgaURJK/FIH+cjHNsOKxvUVWXreEjzCxT39dwaNG+wqRi/yZViUJDCKK81VpJi5yrn8lzrHNjdxSkHsyhqA0IYE7Q0mwEGmUhjL6dYYW6a8WhYoGiDtzPKY8AsPytqrbrGSFS4A6v1nbIPoGlMK3r+8Oa1dAu+w195OqweeiCjMHthKVXe/fv1P+Z/1IkXUDK2ApQunTQhGwbWSNiChJYkGdfBzDXLOxIoh76uNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3D36xf/nlWECnnxXReIxZRY8MaIO/UjnYI7D9CTjPeQ=;
 b=u00qBrz1XE+lQTSim/CdMKZbn4yWCwtdWUw+11lE5fM9AGvsdxI72Rn30GpOy+ggpIlbaCKYvpXtkTgxgS+5oe59u3C8NHyituJK/e0uihbJNCXKywdGJPON2ANti7rOGXsO1La1QBtoWuod1RIlMniJKeDKTuM2/Cw3g2zgbRJxR2th11YXkyZ4DDk+1/9Sh41jHzv8CvYhdID/cAvgKkUdXnRKolXIDJwihuxvz13T+YHtoYY3BDd99Ua8Uc9X7ZkGMKDSSTvBCZRrXRTdl1w5u3V4uRp632OuQ0VKT79u/YvPnS+SbYiMlfjrR7LCn62hr9vuRTQNLvszUbIIEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3D36xf/nlWECnnxXReIxZRY8MaIO/UjnYI7D9CTjPeQ=;
 b=ELj2iwj1GdbjIaiDCOjJu7K9pEsDzf01JJcHwuNb4VAMN4Y5hRoKgztv0yQY/miKvapsXjlM+s/RnC446fBPz7drZ7V0Mp8nUoO5Bh2GXeFm6fiU3mfIRfgb6EmuxRel/BiHs6UplwwM+wbzlIXT8Ba0EG+gdw6JWOYG4FwlVlQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6253.namprd11.prod.outlook.com (2603:10b6:208:3c6::18)
 by PH7PR11MB6793.namprd11.prod.outlook.com (2603:10b6:510:1b7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Fri, 13 Nov
 2026 14:41:36 +0000
Received: from MN0PR11MB6253.namprd11.prod.outlook.com
 ([fe80::2d7e:97a6:b6cb:acdf]) by MN0PR11MB6253.namprd11.prod.outlook.com
 ([fe80::2d7e:97a6:b6cb:acdf%4]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 14:41:36 +0000
Date: Fri, 13 Nov 2026 14:41:33 +0000
From: Ahsan Atta <ahsan.atta@intel.com>
To: Thomas Huth <thuth@redhat.com>
CC: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<qat-linux@intel.com>, Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - clear fw_loader pointer on adf_ae_init()
 failure
Message-ID: <avchnYuwouXKyRgS@soc-PF5467PW.clients.intel.com>
References: <20261103100126.534424-1-ahsan.atta@intel.com>
 <545910af-9ff4-4fcc-92bb-43a56f88753e@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545910af-9ff4-4fcc-92bb-43a56f88753e@redhat.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2P251CA0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:10:230::12) To MN0PR11MB6253.namprd11.prod.outlook.com
 (2603:10b6:208:3c6::18)
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
X-MS-TrafficTypeDiagnostic: MN0PR11MB6253:EE_|PH7PR11MB6793:EE_
X-MS-Office365-Filtering-Correlation-Id: a62cf635-0f37-4847-bd9e-08df41943858
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|10070799003|376014|4143699003|11063799006|56012099006|22082099003|18002099003|6133799003|261102123227099003|261022105027099003|10067099003|261028144727099003|261026140227099003|261022075727099003|261021121427099003;
X-Microsoft-Antispam-Message-Info: MuIKLJ0x+PJX6adlbOe+LqbolykhdFWuLXqxOAgBrxpwGMyVnqbLQ8GnJQysRb67lSujLhbmcqyJ/W5Aoty8rzhYZ/xvdbxg379YS6MXaaFbXTdsp6UjwqmET54Y4g0rN2oC6+CCIMNxGAZwXHyPtt7y2HB/JySGkTe3xbB4U1o5rhDYkTY5bCKjaMRPhfulQgM6VMgjNL6QIAYPNHRZZEYWlZqAdJTr+5imqAYK5D8sO4wLp1m6L4AkcsodByA2kLhCS69lxDSoz9JcthCcRnGiYc3AICexXY3BEyyJo8QHQOmh7V3CpAtDb5LjUhuSEqeirRqsosCdTWrUSzptyHkWzZaMsZaWRfAuedGumRf6VhXbuaWh/+df74+ig9c7lX7U5pGJB/XDjLpSOo18tqzj0W7kPXCx+Qu/odY1eL63NEb+k52LL746jYL56rJnOOqwDQhvORgwmhG60G7C03QIGy76KrrGDnbTd+C9TussyQGv9ktW+b7s/hvfFwDI6XQ/A9OxODby8u+ejzLAYgpuRJcJ87jFe0+bXJwvt6kEP/e1qiTQXYarFB2oKuxEQVFDZCy2TuhkkK6+t/+HpC8+rcGsd4cI67i2oOAtYmsfpE/x8cnGpm+4rAMXUlbv9X7pk3oZ1WbSbdiaUbhQeFnXloqexEFy8SwPxJ+iS4M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6253.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(10070799003)(376014)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003)(6133799003)(261102123227099003)(261022105027099003)(10067099003)(261028144727099003)(261026140227099003)(261022075727099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hZDZrQ7E/hxaxCh0YIf2Xxxv8ExDE6dpbH6ZKk2j3iZ8vYu1Uqh/bXOWQ34Y?=
 =?us-ascii?Q?/VUAE+LaGWtmqoJ94ZvSAuIArIlNGcMh5uK5HlxTEXuC9c2VmI2COkVgT2IG?=
 =?us-ascii?Q?/YdJnSxxezUC5BhleEnzOOOlUmnVfT05OpkCb+hskezEaHz8UQHtaxRnzRmC?=
 =?us-ascii?Q?PrUHDPwMRk9nOA56PYZdmLuweaAlUXaPweGQJUFmkojR4N8HY/LM1yhzCpOh?=
 =?us-ascii?Q?v/3Y7PPAJ0pLJTyEJSw4XYa8+uxOufTkovNldzafsTk8L+8gNmgx2asR7tT/?=
 =?us-ascii?Q?BCnTTVzjYmz+DxRCwWrtuU0+MFqgzAdFUXRZ9WCwvt1VK1U8QLcJq9uhNZki?=
 =?us-ascii?Q?lLwmRQMoTQ0mo3UfmkBlhKB+70SSq2jtWJb4bI3OCVL0wmBRrX+uvpGcOLk9?=
 =?us-ascii?Q?y5UFpZCmfSICf+i5dODjYF8hV54uzYb3S3kQMhEtNNlp4uN/LfEiqAnm8nAh?=
 =?us-ascii?Q?glR47VGfU/9OiGWERp3yO2xVsGQxC1opbvu54G8lQco9WdSE7mECxgzteOG7?=
 =?us-ascii?Q?fXqfeGlorLWWZanQP9KuLWhNSa+w5V8c/438ds63bjvRgS70PS3KDUQMsESp?=
 =?us-ascii?Q?lvB0oItAkSiJMrR/4XVDWJuP/QXG2+ibuMg0120Ju44RK2fXTwTswsOsrE4i?=
 =?us-ascii?Q?TyWdewRPRII4BetNwf4mN2lh52dq5uDlS4hV3HjQbFzknwA5noi03i2rDBoj?=
 =?us-ascii?Q?hvPpqukuC4uwNVg9bs0QEFq5+iAFBFpKs68tBmOQkg2hk4S5fGNV/r9ap4K6?=
 =?us-ascii?Q?PvCwDmJqTiStjaBNKvRyd1ZsjJlVh01vh4u47UhWZIZJmCkGIE/ElkvLBp8y?=
 =?us-ascii?Q?UP2VbRblOirC5qN91XkC7BmHmmXBJAQUYCBUlFS8V2uUDpl0osOV29Pjnubn?=
 =?us-ascii?Q?0OdcoVq1MzwEy8HMlKey2hVZ16osKHf/oARMYOGGdnX2h1xZCFuw4O/47Sjd?=
 =?us-ascii?Q?T8hGFiqexPbxghTzW7ISjFxGjDuvHuRGi/P0ToBJruxpCBuHPYI0bRayQWJC?=
 =?us-ascii?Q?zFcfamlvd9sGuix6oFFhqfTTUXgg5Fo+TQUgeo/Ldou8+bz1MuQVf5gVW5hG?=
 =?us-ascii?Q?a8dd0897mP3Bnl1GVtTn21RGSUEhVBDqYwr/Yr8wohGf9+M7BO8VHBBEoSCK?=
 =?us-ascii?Q?VbWWov87GpM/RGyByQ4EnFgzlOPxvbixw5+rEI7Od8TJAvKvI/QTU7FueXKy?=
 =?us-ascii?Q?wy3x9PsI2sK78VYycd6iAQnE9jNwaKud5m6yqpVyhhQTDdhdnbVhmHusrFbq?=
 =?us-ascii?Q?1wS7a5UAVkSc0f2vwFLFf3EcSRPqFefV8gzBVLfo843kFlaY9X21/KXQ4vCo?=
 =?us-ascii?Q?MrM8/piPZoLCGjr9PUlUUqXk3poDTbgfd2HiXABLttS9eWjQ0Ou7Ek1nZ4h9?=
 =?us-ascii?Q?53Qn6Bf4VvtgWThdOqi+G/wPywO1gshQNR4t1KLorjhbk0ZWN4UMTowmQM15?=
 =?us-ascii?Q?vzMImYflljB1gj03q3YQefOHeoTidGUFZCCj6QY6K9UOO925zBfI/ul5TDMe?=
 =?us-ascii?Q?dxqSZs+njQl8ig8avvAQHERb5CuOvnrm3v1qvRc5fHTbTW+Tyhta7hp+AeSt?=
 =?us-ascii?Q?TMqOX5qHdkzP02tGmAPIrj4ubmZSqzvE+0l5zixvix2ifmS05kOWspO1KIwo?=
 =?us-ascii?Q?QtHsMEAfN7rvLH/YAHnsCdZFWMgJjnPz5m+yBDyaPqTL2G0VyxttTmrTXy7p?=
 =?us-ascii?Q?nL//xKlAIKAyqgdGkXsU2Ip3nrGoQz7dUKPAGsgxsndzuZBC5OueaALNQFvd?=
 =?us-ascii?Q?Hsf4WJWXzQc0XmfKa39uOkIMZcBWxIcuG9r9ogsfCtwFOTInSWRNI5kcaI62?=
X-MS-Exchange-AntiSpam-MessageData-1: fM5912W7MUbPSQ==
X-Exchange-RoutingPolicyChecked: 2RGcvTai6awYgJ8TO81oKMp1nen6A56vsrUxrgY94tqXRjthajqfzwS3FzmH39MxNX30B0nqs4ftTW5DOlVVgRJZ7+mGFxFruA9URRjAiG15prcP3N5dyHh+gw/m752JkQU1rZzTTQMeIkcno3Osepwky9fuYmUXR0ZQ3TN8Yay9bFoRcamxy1UO8CAGIBXUZdPOfyw1v9crPlrsmNNZp4wo7dut5HPDDeYBwfAOounc7Za39ALkT5qUyLNlCJJMsZCHUk7h68nDQ5dAxcZosl+86qZoS2oKooUlf/08zUyCKv9ps3FCz4HwWCnHC1/tT+N5EtXZHsEtib5lHxJgnQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: a62cf635-0f37-4847-bd9e-08df41943858
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6253.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 14:41:36.8175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rz4EK9EVUurH8PwUiwDFGwZx9+MErX18Z11zKoYt2DRdz+/b/hfuIsHTt9c5yLO2N6pye6cl/1Ig7pl/5one9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6793
X-OriginatorOrg: intel.com

On Fri, Nov 13, 2026 at 12:20:47PM +0100, Thomas Huth wrote:
> Am 03.11.26 um 11:01 schrieb Ahsan Atta:
> > adf_ae_init() stores the newly allocated loader data in
> > accel_dev->fw_loader before calling qat_hal_init(), as the latter
> > publishes the HAL handle through that pointer. If either
> > qat_hal_init() or adf_ae_reset() fails, the error paths free the
> > allocation but leave accel_dev->fw_loader pointing at freed memory,
> > so the device is left holding a dangling pointer.
> > 
> > No code path dereferences that stale pointer today. This is therefore
> > a robustness improvement with no observable failure behind it, hence
> > no Fixes tag.
> > 
> > Clear accel_dev->fw_loader when the allocation is released, and fold
> > the duplicated error handling into a cascading goto chain. Report the
> > error returned by the callee rather than a generic -EFAULT;
> > adf_dev_init() still maps any failure to -EFAULT, so this is a
> > readability improvement and not a functional change.
> 
> The -EFAULT in adf_dev_init() should likely also go away: EFAULT means "Bad
> address", i.e. a page could not be accessed. Thus it's likely the wrong
> error code for most cases there.>

Hi Thomas,
With this patch adf_dev_init() would still return -EFAULT when
adf_ae_init() fails.

        if (adf_ae_init(accel_dev)) {
                dev_err(&GET_DEV(accel_dev),
                        "Failed to initialise Acceleration Engine\n");
                return -EFAULT;
        }
Let me know if you would like me to add your reviewed by tag.

Thanks,
Ahsan Atta
