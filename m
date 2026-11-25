Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795629877;
	b=uwhk7z0+YbvWeKUPms+Egs/zLcSDxWl1u2XlD69Z5IXorEfM7tqMdwwBikPYaP9ZmdtY
	 oNv6inYIWbGH84ajIT7BLkl/38L5Nu6NH9GWmURPwbUYgso9Pm1iKhBt78LV8v0oBXhv8
	 l4N+1BoZkraD7qU+4SyqohiqWtmvG2EaVVWIoOUfYcFVSn2sdk1MLa1qh05jmQToUydpr
	 E0gOeC+aJitHQmrSgJ5tuuB6z9bRzn2e9m7xwZJvxrQ0XLlKvKoBcdL9fAWZGHq4bJcEC
	 v08zuqwiCWGBmJGw4mqJct3KhsJGtRnXSpu7Vo+Bi3SNnOlB9hB42z8OxfcWVx4d2/w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795629877;
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
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=r3hr56IexS1zJmyvSXMyvQX2Cfopu0kAlK1GpejC6jk=;
	b=3CbXXwdouNmtpYEtIjyQkBb6wnV6S6hJIjdqABhYpKJ6U5wXSxYIKK0g1PIv2psPTev0
	 0njP6ENj25K6lo8tDvtnZP27MzpRtYtpBeoCcg7pfbi1GM3wIANOGu33unmlvJ2WC2Vvr
	 G7ZmapTL/u4Lkn8yDFqfksyL8j9h56rn9QcV7yDF16M/S6qyTnP4hmpMAftt1HgSPi7iS
	 q9NlSqpF0CkoM+v5OsAHtige1xtbkEZpVolVmm5IbVumPY72U2FsMELVZ3mfdhI+r/wCe
	 Es7crzw7tiscHqv+mphviuO+PgaSecOd761QMYyGO0h19E7y/Sq01BpmXH9WPsHdWDg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jS4oaAy8;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=d44ofl8+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.12
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13531606A323;
	Wed, 25 Nov 2026 18:04:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13531606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jS4oaAy8;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=d44ofl8+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795629877; x=1827165877;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+hOvjffpQO4WrTGGCaxTkLpK/crteDlokC2Zj2D89CE=;
  b=jS4oaAy81+w6fNxOVDAdB1jc7oVi4tC/0qhA5yhcSkNZs+ldriUgvlJV
   kUxTbFkD5j8KqBXSXI8x+YBfb60/CDfRaNblylL2hjvqwoMJJAxRu5tQg
   mfWntD7zFt2dYjnbaO4+oU/Ynq+k9z1BV0Mq8F082l/xGXQAK46PzR6cE
   x036Kmh1OfroC3H4/HHoc95imciAHgFh5v2aBPm6wWk+zirkB4N+Z4sca
   U+jZ2uO6NyZTReMBbNHUIr8LOnO5s21w5z5z3nEEN9a+LLkQK6P+aH+W8
   Uqaanlg8U9X/BUUWXUrnu8POEgxFJDBQ8wEVonFJ9NJnWzqIf41jQtOd7
   w==;
X-CSE-ConnectionGUID: QzgSzJVXRNy8jZ/84hlThg==
X-CSE-MsgGUID: RIvCSvmNRWezUdT4KpV08w==
X-IronPort-AV: E=McAfee;i="6800,10657,11977"; a="4412320"
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="4412320"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 10:04:37 -0800
X-CSE-ConnectionGUID: Eg6jvPHjSCKFE4TITRDb5A==
X-CSE-MsgGUID: tGYfyU+/Q2m+Z8f0nRCy+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="11937127"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 10:04:37 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Wed, 25 Nov 2026 10:04:35 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57 via Frontend Transport; Wed, 25 Nov 2026 10:04:35 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.35) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Wed, 25 Nov 2026 10:04:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MrqvedbrKkUNqp3BZ9hR82PmByf+wMNtWKCghRIV4OOtDu0RHDimhOEDIRXzAiL9kDkDVwYjdeRJAyrDITfleCYRKlaIkDvViZMHMGmILdtaytV0pa3s/49M7WKXPhjLvnqDUJTtoWmfMn1C9GfLFMFK834mQiqbbGyECvy/t+ZIxx1ckusNz/Ot5TK4XYMR3/s5LtDglfcnZB0TiGaqlR+gioBmP4lNxl7IBI9uwOsQrsqSfC17wLW+47XdcH2B2HBiHrt4jeHFFscEhemHrBaXyxnIAD19fiFy4x8o1tQDglPJUGA0Lm2WRqnxiAsBng7YCOhiGYG1EBHOiFdPZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r3hr56IexS1zJmyvSXMyvQX2Cfopu0kAlK1GpejC6jk=;
 b=h8KadwgqMlS60Dvsf0+lDBE6i1bqxdLgp65HlxO7sPx/pj9PUf8A6ekmQ/FJH6Y4eGTdLWBqD+2r/G5JtyCX4ru8LGTQTJ0LzHqIlG0bV4w1COULWwZ45UjdB8wGrJmjQuANl4my8Bf4wM+XAdVSzN4xrkBc3F5yzwQ6uaJFmCj/JjYoGyPkaNgTlx7PAm2izOhln2IbdP/ozt3dw+Hf4hwYgWQhl6Cf5oVzoMzPYlSzs3EZ3xEx2HYR8Qr7MB8g8Hnpxu87pnA3kHpK4CATASKRGaEOI1/10fM61CnbZPMVNy7S94Qgvhcq18UkjCwPERVQzkVEv7nPOUScXSjJRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3hr56IexS1zJmyvSXMyvQX2Cfopu0kAlK1GpejC6jk=;
 b=d44ofl8+93GcvudCbP+bCA7mq0e9scPuxHPH+uroeUjQ5XDv4c/VRWswELeWqrDNf3M4pClcrllgz/DRInXoGSZMQxn1eqQqlYoqbRerPEN0lr+PM0JImmq5cCfvL8v2izwHrNc67GmgtAWVOCW85hFa2O7h562zAtTVcX4rP58=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH4PR11MB742795.namprd11.prod.outlook.com
 (2603:10b6:610:517::15) by IA1PR11MB7388.namprd11.prod.outlook.com
 (2603:10b6:208:420::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.5; Wed, 25 Nov
 2026 18:04:30 +0000
Received: from CH4PR11MB742795.namprd11.prod.outlook.com
 ([fe80::4bf1:7579:c9da:77d5]) by CH4PR11MB742795.namprd11.prod.outlook.com
 ([fe80::4bf1:7579:c9da:77d5%5]) with mapi id 15.21.0662.001; Wed, 25 Nov 2026
 18:04:30 +0000
Date: Wed, 25 Nov 2026 18:04:23 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Ryan Prinz <rc4d5a@protonmail.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>, <qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: qat - fix missing DH public key validation
Message-ID: <awcjJ8/jvscOuCLl@gcabiddu-mobl.ger.corp.intel.com>
References: <20261124141238.1743680-1-rc4d5a@protonmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124141238.1743680-1-rc4d5a@protonmail.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0137.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::10) To CH4PR11MB742795.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CH4PR11MB742795:EE_|IA1PR11MB7388:EE_
X-MS-Office365-Filtering-Correlation-Id: f47cdf2a-ced1-4779-c1cf-08df4b1e8d54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|10067099003|261022075727099003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: Ea8HGfwsHEW8iVajhhvOt0Wvri71gh+K7Nl1v+aulLaZiwyH4fNjlrKIwkI6hem8MAw6PLmJYuGcHOcl4H1cEr7mRkagv4YjsmV6v64rskAAQNIu8EOnnW/MPFEcWZTqhDEVF7Zj/RKvvu0x1rojAd+fVShviPZY07LXgoa+GDH4y9YZnqAZ23CwrMtFW9OpRFoATM6KNqbuNZjvg/l4/M+UAjYWtwY0WW5oBZTrFojuwr/qV6q5K3OyHWCohblHNt9aFR+FACaaHdTttxP1XEWSa/0EBt+/jskBeYtVfhGprRUprXlGl5lytPOuCXEVWT0Y1Z5yes+7RFe1W5SoVZ1IvAztQ99yDuktLGYgpAqjNkP+kpzTGA8/KfnpKVgFcNY4XCEIp5l09qA9QmuHroptJQnvrUjOrywOXfDdBsn4FL+bDXlXesHbXAb3DloQeHLe3irI4fVM60g3rKDbgJjSdkcVy7dSuBzIoVPH7t/hOPb8sNp7zb7cC/JDYMf0z6RAUIrlCF2G1oifvuxfmtwitbUcCakC8JPZLiAZMjfXNPiAQwOVeP9RCHab1vLRUThjMQO+o66+VjzJQvoaagwBcYLryfeDrzGxbieKZ9YOwL/kgDvfzhxX4324yqoRJLHidvrFVqY4iyxAB7AtOY2+aPzU79xApEczFmK9Wk0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH4PR11MB742795.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(10067099003)(261022075727099003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tJPvkeG8n8HqGQDCu2aNwVIy+PhTH1IHUKnFTkY6rIxmORSC3dGh8AFrGl9V?=
 =?us-ascii?Q?T77Pa/+frl8Jypz3f3EzVXLPmt3Y9MWMdTUsC1s+FdGpCqq+sAGfzRl4EXRa?=
 =?us-ascii?Q?/Npl0hR9P0KafJVOWMmiMe8Nkni8XmbAseLBU3mkr+6bFqav548/A5hIMMFp?=
 =?us-ascii?Q?JOzZRW9h557g+pKZAzWNmrp+lKpLSgOhgja1WkRVkAiFoZqyYEDX8S7SJatj?=
 =?us-ascii?Q?DvKWhYEt6Y46Q+EImAW4/fNEUspM8++O5kfex8rd0Jr7Gy7mkS+FTw0arGLL?=
 =?us-ascii?Q?4tEJWXRNGXByqThx1D2ckIZXDEgIJMh7wDUfR350FljVLUWhfiyBCK7l+SPl?=
 =?us-ascii?Q?/xN2Kk6DkAVFTibad5R07EU4z8LIhEF5RXNUJZLPyaiF0kcFCwyTcyi1xePW?=
 =?us-ascii?Q?zuzYv2TzoJAjFRkgiqNqduf2b4W2OQQFaFkp7rtx4kWNpXLa9PSJoP1RkrL6?=
 =?us-ascii?Q?Ik5SnNTnHp/wG3el6rj37M6JF+ha1LgWWtZRq4e8tZL6Z0eSFgVfTkkBQfwt?=
 =?us-ascii?Q?b60Ta304nKB/BGVnGfB7KqSMJICepikcsL+A1fzT9SqSR7pfimg/kP+XGcfS?=
 =?us-ascii?Q?MgaRSN35o7hlupZaJRcLf6PuKlkmazj8MIOp4/SIPQMaxcR8wGjZ7DgVSGb9?=
 =?us-ascii?Q?hjZhpsLQZLhosK5v9rWdwlGLcPmKZxI1nTCPg7ML+XC+PaA3gq/cPUhDSrd/?=
 =?us-ascii?Q?CwQgT2soM6JkUH0Iq4A0SRIkTyWl23APyihKMInBElgFR+XAtlS1NYWtBmDT?=
 =?us-ascii?Q?xZBDDgo20mVR0a/ElpLahIdV0/mEZDBcFVyzH+0WtmJRsmvc0vFfjZ9/u9EO?=
 =?us-ascii?Q?q72vkSsfNLboqfXy8z6X4oLcyBI1q3In5UziaplT4Yc0iYZVSHfZ+T+OBDF5?=
 =?us-ascii?Q?VVS/nZLE1CjRuEPsOsPEYw0hShEaPWa+NGYYqm102BIq5+MtJl7RFAGeUxb7?=
 =?us-ascii?Q?4CBuusKEkMRQKlIntL4WuEJn3YNKm+Ro+Sd4Eua5rWhSbBfwSbozAvFQMJYS?=
 =?us-ascii?Q?TJoyKFa6ouVNrUCKhxNp9dkRs1BJQohWoOPX3xQYI6BxFmddncnABSV8X7gE?=
 =?us-ascii?Q?88CRm78tKy+OvvC7t+uuzS1N3/chmc/x20L9nTzHWkvdRP9rX5NmXLWYf8l4?=
 =?us-ascii?Q?vqdIuuzST/GEEUCMLua9yU6KPZO4w0aK3W3hKIIxz/Ldfe52U/frsrZUY9+T?=
 =?us-ascii?Q?ecVk9jYvOb8Kxjqwi2+ZNuLaZSobYiIiCZI3Z0ELoE4IId+m5gAGf1DxqD9d?=
 =?us-ascii?Q?N2GGrI4DR0o9K/OhgTrjc7Fli0nEGqwkPB0ciOpdRO+xOYuUqtDISxCpTp29?=
 =?us-ascii?Q?U9Zr2ivQ8yD8rfqA0P6Y24/SZ3/o9/Y4l5BFReHjxcpvPY3SeqL2WNKyGAXH?=
 =?us-ascii?Q?AIdh/VqSB0WESOCpdkdAfuMG8R9rtC4eVeTuyVVjUrlGaJjDxeNX93Nf9n3n?=
 =?us-ascii?Q?GbaPzUotzv94yA6DsCAy+Cg9AxIZN9sorCVJejgP4ensiqFk+BJDx9PQobvo?=
 =?us-ascii?Q?co3rEmraWGtLVOxEGCl4rcVGvbms6KDZHbNlEnb3IEZCAUL4jqbc1NpLHPg/?=
 =?us-ascii?Q?zhQCFtJmd19MfeZEKkp1QicgMvo0j+MojdQPKchR6xrXAb6YK/z9pj6pnvw0?=
 =?us-ascii?Q?ocOmFPQLZmu9VLOAQLLiYwjWBPwTZkGIXyb5PIavsP46SchG3yjFamfprTeP?=
 =?us-ascii?Q?Uzg/tQVNQCqXCslgMhllJel1IDafaC+zc3619kauMlGynMt05VwiAHrY/zuM?=
 =?us-ascii?Q?e5woXPa8jg9bWLLuYF8In8c8/5AI9Ww=3D?=
X-Exchange-RoutingPolicyChecked: OPrcZVsN29GR6s3JiKJhmfhvMpOlG9sPN2TUmk+m55ZWl/wKzphnuNF/rh9f1LJlZC7wDrrJHmj1F5uRaZj8SKSPOJDqS0RMpNi9lsDb/WCTkkDWfPnqw4aFNdruXj+31ZkO05GGltZfwpeTQI8s49Gxz3JNgd59PukbTNnODl0+mHvqPgbOksjXF1AVxfzrg/8cgylB+K8mIIDr6aYrHLbbm5SYCUJJ5gxNoZa+OhxfCxPUcRfNLrsWxtRBxrKodNoanK/V2W4xWTXiXN6IwteaiHp9NT5hBWhDYrAnihBsleZVSo6Cx15XeiRPO1De0gmfZGtiBxrAMJBZ3GW7TA==
X-MS-Exchange-CrossTenant-Network-Message-Id: f47cdf2a-ced1-4779-c1cf-08df4b1e8d54
X-MS-Exchange-CrossTenant-AuthSource: CH4PR11MB742795.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 18:04:30.3258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Msw3F/QsKj9OpWydgHQS6HYlg2xWk3RkI+KhTuSU+wIFUxJtUMaXq0vblrw2BaeN/Yo7cJcNLclVEUKsbE94xze1+xLlJjPELCGLzJFwss0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7388
X-OriginatorOrg: intel.com

On Tue, Nov 24, 2026 at 02:12:54PM +0000, Ryan Prinz wrote:
> qat_dh_compute_value() passes the peer's DH public value into the
> hardware queue without checking it. The only checks on req->src are
> on length (req->src_len > ctx->p_size); never on the value itself.
> 
> crypto/dh.c's dh_is_pubkey_valid() is the generic software check for
> this: it rejects a value outside [2, p-2], but only when FIPS mode
> is enabled, and only for callers using the software implementation.
> QAT's hardware path has no equivalent check in either mode.
> 
> QAT registers "dh" at cra_priority 1000, versus the generic software
> implementation's 100, so any caller requesting "dh" gets this
> unvalidated path whenever a QAT device is present and the requested
> modulus size (1536/2048/3072/4096 bits) is one QAT supports;
> qat_dh_set_secret() only falls back to software for sizes outside
> that set.
Would it make sense to have a provider-independent check for the public
key in crypto/dh_helper.c instead?

This way, software DH, QAT and HiSilicon HPRE, which all register "dh",
could use the same check (regardless of FIPS mode).

Thanks,

-- 
Giovanni
