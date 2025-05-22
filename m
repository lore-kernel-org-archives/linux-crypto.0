Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E931288CBE;
	Thu, 22 May 2025 10:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747909331; cv=fail; b=lwRpaHp215tK3OVToYpETl3UqYghZCGLeRyCMf4yZWVFAgmfShkML397s91L9uabQdxk6CsM0Ok7Ntpnyy2smqzRJJvjBGax8TI1gwlRJrvZUNHLz9Y6FVGIQP/QzzwNowZCY+nVjrUt8JS6FrDEqeR+V0URA9D34ZK89Z8T35I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747909331; c=relaxed/simple;
	bh=W6afXmBQJBmhfYX7RHd3wWv8daDaD3Ogm+TwHpUnYxM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Q4I5qvqxPg/WUdMFHCH+B+NmR1o3uMKgeShUqh/fZqSnC4O25p0agurnSdoTb4l1zmXBMdD4gYoFGMpyt+eGjOZcgMkgkw6I0vD6D1Ld+09ldjH2LhTQZPXIKAj0e4FhLEwaGiwc37TJxnA3zlbOhzKD6tQTVi9Z8KggK93phb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YQMsQCAz; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YQMsQCAz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747909329; x=1779445329;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=W6afXmBQJBmhfYX7RHd3wWv8daDaD3Ogm+TwHpUnYxM=;
  b=YQMsQCAzEARkKDi7FV9FBPOTn7S7Dn1uwiebWzEvQcqn4OGVXZ7e/Gib
   hzJ85rhwzG65TQCKtpFATJXnXjxGQQs5IZ1gKhmgzEgeINfpwtk0E5y4f
   8pRGf3jDrQR05ta0QWfHzAqtgINsSMeGZqk45LYUBnUnbByGjMW1OyESS
   +EqgobZM0BHeGHdsZuFVw3ngtdWYDrv01m3DIJO/dbNR7dwly0Hs0GOeB
   /P4+jhffz7n/MYOOqRDeon8WURr21koYsWNFuN92XftLbYycFr+SJj7c7
   jxR9w6dzS1SyXM5T/f0HxuQSgZNcM9pUbBH9Jcp2WnOawnWEgS909LXBJ
   Q==;
X-CSE-ConnectionGUID: 7JYuhaqETwe6uqDOkF51DA==
X-CSE-MsgGUID: xKQnGkwGSkeBSuQFF9m/Ow==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="49175553"
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="49175553"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 03:22:09 -0700
X-CSE-ConnectionGUID: lwaXZADqSXaGMFVC/59k+A==
X-CSE-MsgGUID: b5ZRecbQTqWGkxoCf7J3Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="171525864"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 03:22:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 22 May 2025 03:22:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 22 May 2025 03:22:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 22 May 2025 03:22:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N12FUcs71tLobhbSy732EFa0QUk704Vpe1tcnJXq92Ri6X5+ecK4/vBxEuNAjpWyNnw81+Am0nl89YjEL45j43nq+BY1tiT5afnKMaSJjsaujXXQrdEP+5ije6Obqd/GJWZUC50oGSmzW2CsMUjVr7LM1OKy7qPCDD1IYq+CMmUnYO1KHA56thLxKhuMFxuTRvgNDACvpZ6w/9hhv0TH2053+J9OKqxAXYKXWozp4qXbvdfEBspvtrO+0S8aw6e8UUpoVMKCBfTzQ88jmjWixvxiRLZAuA2peAa4jLoQkRyuxQfHERprXhU14UYnzyK+/VUcgwP99QIp+WofB7jqog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bs74xKf3KW6+Y0rRJQO/izGu7tMAalmHex+7SrvHK9U=;
 b=cDlOpawpPxxmnm/dGN3y4Fc6iJEblD6WxEXm/MPuqEjF2cvehnj6T8IkpKwbHATISPV7zFcRoD216uwjQ9I9rIygjMZMpsXM97FalZFqToeYp2En2TKaJf+Sobz/2PJDRT1Sg1F4cpU64p9+QDfL0q5C1VvETMGOE54m25Jj5+jSHd0NPPewFT614W4hJRM27yqOtHslXgxMlT/xyqlzl5Y5Z7bBYdTvf7Uq7vsgJ6jzoDi1ZH7jGcRe5gNvuR8GcC4wj0HeybTaSTwvLBfJgdAE0rdWJO9qyC1odqZAOkzrnEz5+I4a9aYhM/w1nBaHVL4nvLD1BTFoSujR/RMxSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CY8PR11MB7845.namprd11.prod.outlook.com (2603:10b6:930:72::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.20; Thu, 22 May
 2025 10:21:52 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%3]) with mapi id 15.20.8746.030; Thu, 22 May 2025
 10:21:52 +0000
Date: Thu, 22 May 2025 11:21:41 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Arnd Bergmann <arnd@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, Karthikeyan Gopal
	<karthikeyan.gopal@intel.com>, Laurent M Coquerel
	<laurent.m.coquerel@intel.com>, Suman Kumar Chakraborty
	<suman.kumar.chakraborty@intel.com>, Arnd Bergmann <arnd@arndb.de>, "George
 Abraham P" <george.abraham.p@intel.com>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] crypto: qat - add missing header inclusion
Message-ID: <aC76tZFMTee1hHI3@gcabiddu-mobl.ger.corp.intel.com>
References: <20250520161148.3562622-1-arnd@kernel.org>
 <aC1c7+PQZN++5mgf@gcabiddu-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aC1c7+PQZN++5mgf@gcabiddu-mobl.ger.corp.intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2PR04CA0049.eurprd04.prod.outlook.com
 (2603:10a6:10:234::24) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CY8PR11MB7845:EE_
X-MS-Office365-Filtering-Correlation-Id: b0890660-50b4-452f-a760-08dd991a7859
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7XyiwaYPYcs18m2sxl6ch5cOJFzK2S0ilkI9GSKr2mX80upwtvRu8oe9cWgh?=
 =?us-ascii?Q?QCgFYJlDMTOU8VMktj03mg7gElFtP/XaaUORxRkPeLE1uJky3W656ixsFQRu?=
 =?us-ascii?Q?0OkVDysigRcOnx8jhjBzeo9V6d/5eL2mcbOE6XgpamjULKOVJtQ96075etNf?=
 =?us-ascii?Q?EGWX4rK77JBW7rgpFcJWhoGit4xwz1b/RJyolOYpvW1B51y7FOkkb9fr09wX?=
 =?us-ascii?Q?0v1loiC1ilMMnaBoUThtaVUadhl9VW4GqCWYk3Y+EfwkzharzH341N4xUx2E?=
 =?us-ascii?Q?sxWW8X3GQTA2yX6se0ZgMq6CYNJRBmq4MBl1Wuu7vl9JaV89u5FnhLLw4Rec?=
 =?us-ascii?Q?Mo9lZ/t1fkClmGKYiCPaqUYsRekkj1nmTHhq+1q9/LymvmkvRG7Af6dWx5QE?=
 =?us-ascii?Q?x4dI9dJFYpNbY28VP73iWBqs+KQoYZ3tZmS0y/kVxo0hglj8a2SiMbyTqGil?=
 =?us-ascii?Q?/HI2lRBtV+jGEEh3Cyg9CZnNrkP2hyHJ6ts4O2TofCHJqedPbZl8Vb5fGCHX?=
 =?us-ascii?Q?dd1xeVGMkKKnHO2R6vOhBSPZdgIE87YH4bTBRh39qjWbTgGbg9ggrtHvRyAn?=
 =?us-ascii?Q?ShuPshgjEXxYJOU9Jp9794P8fqBwYJQWyCdc9MtGefaWH7gg37tGSGYy2rn0?=
 =?us-ascii?Q?h7HLLi9vqCL4voStsqmn8lBdBxs1NNSeE4R2qEbr9YTKG4KqB9/HEvBg+v9j?=
 =?us-ascii?Q?IqOPYzt71eFGTvTSFZ3RbNpIS3A+iJ3whxgFd2NL9eTKOTMSwwZHVVNwNgC4?=
 =?us-ascii?Q?MfrIp4XDKQgmfPqAZNhAdB5XsJ7Ujx5qnSrA9IBsFjDDnGS4BOZY8q7G9bOS?=
 =?us-ascii?Q?rQt0jgnYXYcbhBOBHDO4xJhvxJy9hKXWBcXVbhSwPSR7/x12svouxpC/xmwL?=
 =?us-ascii?Q?BSPok3a3lPIiq/RukW8rhpruZ8aK3NR5rS6CyazVzYuIwtXsOa0y//Zui78q?=
 =?us-ascii?Q?Y0/EWQyUn3EZdcH9hunkrvNd/PEWbBZCitY+YIxGqINqF1cSJbas+58b1Eeh?=
 =?us-ascii?Q?h1tfw2ZEVG0deeYM4VitMZ5fuuB0ee6dVWB8uEeenkpA7PY7UfU2OCaViknc?=
 =?us-ascii?Q?RgdWCIVckTN7psqW1AQhH9bI0Lv8nUpB/Nzbm3FlG4rx+M+vQqbccrY+Zuw7?=
 =?us-ascii?Q?PdEgvFE5gPUUPXKMHkVD3IFlOVGdkoWWA9g/FZRJutKbidU1tPZWXvW1hMyu?=
 =?us-ascii?Q?vfNjj6gTt9OnlB499yyC+aEjH8sC2cbSdTn4sxQ4LNoOlC8IRWs2OOgzWLtW?=
 =?us-ascii?Q?mYOO/qbQu/RfLn15Vlj0h9VOPBy/BRdscWB6IYrgY7d3mVAgi8vuP4FEmUfU?=
 =?us-ascii?Q?68CS5K94w38rZgMpTltIFjHldnvf086PtyT5b8ydUA0NKTfqY3RrxPfvAfy+?=
 =?us-ascii?Q?FFIz/M+K7DU1iY0Ql3Y37vnKh+x3bnWc6USKaIg3yj/MDUZdTPxu5wCyic0I?=
 =?us-ascii?Q?5XOkcjgidF8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iQR4HEWFMtksMUcP28/8yqn/UWzADfrp9SNDt7LaGRWJ395mg+T44stMhVup?=
 =?us-ascii?Q?zYDF/Hho2J9RgM+ifNxK9DASEL70LlpAw6X8UnaUft7Rqm3rsiCUkeuCKaBI?=
 =?us-ascii?Q?zr7Ize2dAE+d2ACWv/hzTRA1KlMkMroH7dE1cEbuiZsf1NlikxY5Tta55mH4?=
 =?us-ascii?Q?h+UIK2qjGsUOhcYb6prjww4FTbcYk3LefMkYL6MBHotnn2qORz23LzDnlFKz?=
 =?us-ascii?Q?/pRRWcx9IBZvRLPeC6+lnwF5gYet6veJJDJD5Tt9Dr1g7UKVMFKO8I6oNx+S?=
 =?us-ascii?Q?T+EK8nJVM4W3ms2LsUjajVQCyedC0GO8DXoRX7mSX31Fiw28BDvnCXxrXQwq?=
 =?us-ascii?Q?YOFKUVbraPu6ZeD3oPJH6Lx763mc/wWO4GBPNT2KdiOIBOiof5xKDjnpTD1R?=
 =?us-ascii?Q?/ChkzDkD8FlTFxj06jBDCppzEghLA0rNAoylQkRjxxwzoCx4D7INRPEGJ9BZ?=
 =?us-ascii?Q?wrhhQCDyozRS9OtA4MBLRvl4y1mFKR2HHiSDI8bOemaUd7e6wlYrhy98zdR7?=
 =?us-ascii?Q?PT3fewBQtKhjMVJAk1Q/0fsYMYh8l+oCVtlPaeyXiaAKIGdHckX0UWeiLIaS?=
 =?us-ascii?Q?YXzAdIOYzT12eJ1d518B/BTYHhf3W5pftE6p29+cT+eQtzmggTJ+c1hGOO+r?=
 =?us-ascii?Q?6YOCONsT7Pfgl3ZPzxXiqmLhuuX2ir8mwqIBp2o+3hDv2m1C+JNZM399DYlw?=
 =?us-ascii?Q?jb8SlAVfa5F/yNqENe22rnCW3JIk+OumFnxXbGtbEMSIoYa0ZhudKo0+i58i?=
 =?us-ascii?Q?/3ty07n6Tu/Af0MFzwoA7GBQEM/i19eWrdX2ZN7xnB4sfn6Hz3R4pI+vFxqG?=
 =?us-ascii?Q?SSw7DG2ncmpDV+PQYWx2aLDloSjobmGPMJ0L38EU0PICPp1oakfGjbrfcdLZ?=
 =?us-ascii?Q?1f1eHJ2rX0jKr3yZo9MmIZ4QGDKZabQkXnZJrUf9/VHARBcjtiRFS15MUWxz?=
 =?us-ascii?Q?r6JZAdkkr1ubq6DdP5LCQeF0SD/jOM9fCU+jXkqjIquRdn9Q6sLDOyAHMjKP?=
 =?us-ascii?Q?/SO8kmdKAOoJS7FomKhtb6UgsatN8ruGcznuooDjAyNqPt5qH8sHYJ2+MgKT?=
 =?us-ascii?Q?N9bKqCq/wC5qcyotWyy7yq+X0XuJogAX7zTM7T/qIN2Z9pgpLvBwtL/DPauy?=
 =?us-ascii?Q?YgC6UaaZL2BSNx3MxgPCAtgodIzeDEVSxe51685a8iSJ2SeDTMshIlEFjhFS?=
 =?us-ascii?Q?mM78GTRS05IYgZVnByUmQNlq2vpnNXCHOHTONS+zIFu7GzM/csrll4b8fw4W?=
 =?us-ascii?Q?LYnVX3PPW41CwNyI28cIkCmPVLgyyxdQBp54xAGrzdQNw9iz9y11OQhaCSpv?=
 =?us-ascii?Q?UwMIbpIF9ZJp9WfR4XoZqdxT2XSKArks/QMkHBrLOhyg3otwBVlcy0uBdNKI?=
 =?us-ascii?Q?p6K3Pv/hCxiKLQLIPA6NuUbkogQOx7LD3z/8u/Esh/oBnLaEstPYgLcE0uBV?=
 =?us-ascii?Q?gqeKCCJq6eMjOL3aO8keKfslKAlEoKGA992NP0dGzqdR6PgIZ1fFrVlWJq3R?=
 =?us-ascii?Q?cb3m9+djirkxJGmIn9j/edrNkOa7FHkFE4MZObPftQQ4a3aq3eURbhpJYDoe?=
 =?us-ascii?Q?Q9bOjkR8mHb2FDJqIN9jYgWIdTNvxRRrbBvb33VSaWwtFG4H2gL4qQV9++D3?=
 =?us-ascii?Q?YQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0890660-50b4-452f-a760-08dd991a7859
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 10:21:52.5106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6JGPq0sPyMagEfTD6YmhOdhec/hZXimVsVihlfCHjXsGgecyX3Pakqp6R+kB9+fm4kK2L7w4IWKD0DNCnATzylSWl7MMp/Qm2ewgF4WDd4k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7845
X-OriginatorOrg: intel.com

On Wed, May 21, 2025 at 05:56:15AM +0100, Cabiddu, Giovanni wrote:
> On Tue, May 20, 2025 at 06:11:36PM +0200, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > Without this header, building the new driver fails with:
> > 
> > In file included from drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c:7:
> > drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h: In function 'adf_gen4_init_pf_pfvf_ops':
> > drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h:13:34: error: 'adf_pfvf_comms_disabled' undeclared (first use in this function)
> >    13 |         pfvf_ops->enable_comms = adf_pfvf_comms_disabled;
> >       |                                  ^~~~~~~~~~~~~~~~~~~~~~~
> > 
> > Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Thanks Arnd. This occurs with CONFIG_PCI_IOV not set. Can this be added
> to the commit message?
> 
> > ---
> >  drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h | 1 +
> >  drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h | 1 +
> >  2 files changed, 2 insertions(+)
> > 
> > diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h b/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h
> > index a716545a764c..9efee0053f3a 100644
> > --- a/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h
> > +++ b/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h
> > @@ -4,6 +4,7 @@
> >  #define ADF_GEN2_PFVF_H
> >  
> >  #include <linux/types.h>
> > +#include "adf_common_drv.h"
> >  #include "adf_accel_devices.h"
> NIT. Can this be in alphabetical order?

---8<---

From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: qat - add missing header inclusion

Without this header, the build of the new qat_6xxx driver fails when
CONFIG_PCI_IOV is not set:

    In file included from drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c:7:
    drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h: In function 'adf_gen4_init_pf_pfvf_ops':
    drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h:13:34: error: 'adf_pfvf_comms_disabled' undeclared (first use in this function)
       13 |         pfvf_ops->enable_comms = adf_pfvf_comms_disabled;
          |                                  ^~~~~~~~~~~~~~~~~~~~~~~

Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h | 1 +
 drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h b/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h
index a716545a764c..34a63cf40db2 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.h
@@ -5,6 +5,7 @@
 
 #include <linux/types.h>
 #include "adf_accel_devices.h"
+#include "adf_common_drv.h"
 
 #define ADF_GEN2_ERRSOU3 (0x3A000 + 0x0C)
 #define ADF_GEN2_ERRSOU5 (0x3A000 + 0xD8)
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h
index 17d1b774d4a8..2c8708117f70 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h
@@ -4,6 +4,7 @@
 #define ADF_GEN4_PFVF_H
 
 #include "adf_accel_devices.h"
+#include "adf_common_drv.h"
 
 #ifdef CONFIG_PCI_IOV
 void adf_gen4_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops);
-- 
2.49.0
