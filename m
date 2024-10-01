Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6679819D88A;
	Tue,  1 Oct 2024 11:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727780795; cv=fail; b=bl+fbF3sMTry8Ku38cfqT7vRsrsujCSLWjLuVcVD1Wgh3NDVC7C44OxRpa0i4LyjzcIvl0AA9M2aEuQEMI4rKnUI384c+zpLZO3cdRUInP1zKKpH17QwDHXEJNEBU+V8XtcKJEIrVKSlFRDca68GjRLR2taW8ZwFjoUBnvoTxqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727780795; c=relaxed/simple;
	bh=v4HCuxvZ80bf5qYewmOv4d1w5qWNHRobemBpojsLG6Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BRcNSkyZ5fpfWSvRFC9//ZANKQNk3PhbqewdO5EWQBrehAiTa6f6tbCv5uDudO1wZnbhgVUCoFthBfjKRZZAm+0uLGcCXOgeaNmq3EfWNdN2m6sYXXXkHCgqi3ZdOl14y6qIczwx6RRYNu3LXYELbjeH6caAVJm1VBB2iNMn3CI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hjecZTCV; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hjecZTCV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727780793; x=1759316793;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=v4HCuxvZ80bf5qYewmOv4d1w5qWNHRobemBpojsLG6Y=;
  b=hjecZTCVKEY1jZpg47vjC8ISEGjhpoqLBuWVaS02Tb8Tu54odpWxPTHT
   korxEe0epzezQfBEStYpQJoJ5HjVunAfTB2tquOb5h7+LcaGf4nMbqIoe
   +ZM3tLD5p+kEHzeLZhzgWQhqAmu2bi9JAjrGamn9Vvgbvqout9avtELUf
   RO7YxAyhj54mdc+qRU2ujGNb5mAChtBWjH0P0bC8BYRCNyoUPYnWk8Lmy
   LLsOwmAsGBfY2tYongtpSRTahyDaRfziJzbYDokzSWn++RVQpiL60iO3z
   xxNsOc1rGOlrSl92uS1QR/BDiVnmK6XV5eKQfvve8c0oNWYS+28Wg45c5
   Q==;
X-CSE-ConnectionGUID: IaOFJ+gtTd2Nis5Gc/TmJQ==
X-CSE-MsgGUID: 686hMyGORzCAVmt21H10OA==
X-IronPort-AV: E=McAfee;i="6700,10204,11211"; a="37501434"
X-IronPort-AV: E=Sophos;i="6.11,167,1725346800"; 
   d="scan'208";a="37501434"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2024 04:06:32 -0700
X-CSE-ConnectionGUID: pSL6E5CMQxmFC5w2N/Zr1w==
X-CSE-MsgGUID: LDleP9CTSfGRydZMGNRCDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,167,1725346800"; 
   d="scan'208";a="73607493"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Oct 2024 04:06:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 1 Oct 2024 04:06:31 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 1 Oct 2024 04:06:31 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 1 Oct 2024 04:06:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gZ4iPPiLGpYpqeUEVhho9tlpwxVP6s5uMq7j2GZ8NFIMx/ScnJig7GogXMx/BzsF8YtHv2RI9jI78+iIB7gB0PfXyLl34ymbQCZEzN2ovGBHcmXc9IrrEnIbojxqeeYv7/+NnKi2JUZ9qgiO1WNSberYeHXvB6k9VikTEGE+dlEsB8Z7zPBrENZukuz15pgW0BhRXL2nC2pIH1h6OAsbN3/bcLqUBkscZccWvaAvUC5rCgpMycg5DLsNx+qJU40VIWH8kr9IKDXnn3DeRGsjdxzXGGDrawi+qftKA72i/Wb0N2pO2F5enbBSL5OgV7EM559oUY88ryMPJ6khisI3UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xAJgk160QXZJo0L2hOY1B/Id1L/rcaX9Zru5tnQQ2Rs=;
 b=S1e4HxPy+AbG3VGDpdMxAIF536hwKhr0THoCAfUnVngiA9u4DR0dNdt5APGzaDRP8XeoYbc1aFdv0aInqaI8WzMwnJPtslmtZY/iykL2Mhompdcy1yMIXEck5lDbMCZS/zhVYztutiESp29bgRziEVi0CL9c5sO0y3ttmPNr765o4FtDxY/5PmujG9T6JaX2TbaRQxO+eF3koi6QlXljIN0AZjM9fPmxnV15ipXhxmVZ3AH6fAY6FTCNwjwhR/eDoNQlZ2JxofgsEesAqT0LnJRmO0cfRXVuGrOr2hzXdqRFkLrwbwT9Karz7Wq5dDxM6XhjDAdFZRrUZJYQdxakkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by BY1PR11MB8078.namprd11.prod.outlook.com (2603:10b6:a03:52a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27; Tue, 1 Oct
 2024 11:06:24 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8005.026; Tue, 1 Oct 2024
 11:06:24 +0000
Date: Tue, 1 Oct 2024 12:06:17 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Damian Muszynski <damian.muszynski@intel.com>, "Tero
 Kristo" <tero.kristo@linux.intel.com>, Jie Wang <jie.wang@intel.com>,
	"Shashank Gupta" <shashank.gupta@intel.com>, Lucas Segarra Fernandez
	<lucas.segarra.fernandez@intel.com>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Adam Guerin <adam.guerin@intel.com>,
	<qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - (qat_4xxx) fix off by one in uof_get_name()
Message-ID: <ZvvXqT6TRM5uSzVR@gcabiddu-mobl.ger.corp.intel.com>
References: <cca43549-7715-44ba-a1c0-61dd027ed3b5@stanley.mountain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cca43549-7715-44ba-a1c0-61dd027ed3b5@stanley.mountain>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: WA2P291CA0023.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1e::19) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|BY1PR11MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: b9d502c0-49fa-4ec9-e1ab-08dce2091699
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?apjiUFOA9IKWdvx1dnWlHVsOv5edUCxdWhIpfcVurWz9JLsrv8RFmeHKCHcz?=
 =?us-ascii?Q?4Slk1qMVvRnPbP9T9sBmGp2CVdeITUSD3clmkZcd4LEy+aSo9QhEQGeW+zIr?=
 =?us-ascii?Q?I0wYsPkBXk4ctoCkprrj9wcZ14h9msj8R1Onut7zqxksTmQecK/3WKf+A/pz?=
 =?us-ascii?Q?6cIZcZhkWjwymRY3mc8dz6vSlMuJUOTYnY+1vKF4YNpN8NGiSpHQ8VQj8N+g?=
 =?us-ascii?Q?THKbfB+gWyEZ6FevGpOMwVcR3mh15Vh7i24bOY3GN0ACQ7RzJwtMYvgTSn5R?=
 =?us-ascii?Q?RSFu7HhoonbZIZSnuYHj7QMQQa4H/r35fJu2SmRtcwNCq+JB80LTIvVtmAOs?=
 =?us-ascii?Q?mI80o6J+suKxk7mGY6dSIccPwoJMwr6ykWfnAmMfHuxILlYfWGyBWA71nQrs?=
 =?us-ascii?Q?7hI4WbIQE0cQiknDr7YBW3jB0S9TIxt3Ea+T/tbsbdMC6Rfl1WZpUk8YjsU0?=
 =?us-ascii?Q?lnCXviXPrOO2JeTJxqi+Wi8ipp/Ugudp0ZPSNODaskCBGyuJ7v2g/R9l49cv?=
 =?us-ascii?Q?+AMGJmFoC+VsUJiVhRhC9DAyRxHe+hnrwJhA545agfb03QDfoTTzFCtm18cY?=
 =?us-ascii?Q?JL/j8Ih0HIxtBzdd/JzLXx4G6Wd+i7yPwSrbtQFz4jhnwgO9Ax4TjvVdoECY?=
 =?us-ascii?Q?zUaLENpJFN3MNc6t4Gz+3fZ/Zo1jaE3mlsZ86xXB0CrjG0sdJ3X12NQxKx2z?=
 =?us-ascii?Q?zNMluEc0GpoMZTUcZWBP6ikEYBwl8BURKM2ZNHdv0Y7t1sodJOxbqALoOdKQ?=
 =?us-ascii?Q?9FGxih0yP4v1NGwa4PP0my7/FAVjlQwMr2o061I5AdJKH9gSNXo8qtIvygF0?=
 =?us-ascii?Q?yutp3k8Mdktlaa26GkDNizSBaz9V0uu5gEtqof99fGRUdmxy7tIZ+xQ4b/lh?=
 =?us-ascii?Q?LHbWZYHhUqaUqY71nagWPwPXmVtNsuxaVYyVm7UtZzzwbFO6AxGCGT7E5CeM?=
 =?us-ascii?Q?PtFsXldUWYRcU6BJTo7dMWQgTm/nqbwObv55Ho4ZuvB3aMdgAjV0bMMu6IJh?=
 =?us-ascii?Q?CGKP8nleIi/0TWMhZicTJCx5qSG1C9BmqSvX+88+H24Hnd3g6h1aRhhQgR8W?=
 =?us-ascii?Q?7OeBI4jCWFLGue/QpOsOd7zFFCYTo352oYHzyN3adLOGLocCjItc95eNi/Y8?=
 =?us-ascii?Q?hB13r41552l5l9/vJFaNB8TZ/dz8ME+8OZy3efwxNde4QoLiXoBGT7/pFxz+?=
 =?us-ascii?Q?ysHCRTmx8kQz5Rip0UHQmZ6NGsCJF19fliABLnNoIGVo6IxIg+1vSIM1Gqlf?=
 =?us-ascii?Q?EZ7yVVxPHWFtoyOsM3ahxo3LzOyMz3wLfelxofLLPXWY8fRVXCUpBM+6ezY4?=
 =?us-ascii?Q?eztKU1wAlNqIR5SMM2ubjme64nBpcd3qrGSjKrgkLT/WGQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OKpUXMp5Kfg25xGPE+fu8up7E6h3Af1DYA+1MHPZbdUDAEaK1BaJXil2Ad1Z?=
 =?us-ascii?Q?AMzlvWyuXnYhkubXsByEQxSpKn+/vmpFUeduFloHmXX0pbBZFQKGOE143PD8?=
 =?us-ascii?Q?7ghvBuugGhr9WlVV4FQavZfCAEBsBR0wJlidlHcQ8KUC1OUFfonv/3ysTbij?=
 =?us-ascii?Q?6zgyI5ZuO75qLQJ1NKo6vmCjKBWUXChUuxkMlzMoeFvageGYWdl1DP5j5h2G?=
 =?us-ascii?Q?Bvpge9raBp26A60I3grUmh1HDvuhnQSvZGqVpq/fKY7smRyQR2ps9fYDXoFE?=
 =?us-ascii?Q?Nd9RN76MvBp8fFrU8bE//nrRk7VN+0G1DmcyNw/Uj86dmliXiswYaeag6qSp?=
 =?us-ascii?Q?8pgMaYAkRonLvaKfb5wXAfSEeYdtwfJIeYHejS7pdJwNFHL48sWAz0Yr62qq?=
 =?us-ascii?Q?ZdaH3oZQYKIDnv/1u3V9i94sPvKqPNjShz0SvVm6/n172s1IjrfXPDMlJx8t?=
 =?us-ascii?Q?ij/XWch93ihzZAXkqDGZpx4tQMw7Sq+uY2lThNQyR1K9LEZGz15WbUyp2jx5?=
 =?us-ascii?Q?SDzknLaBRKuz8od+bfKBeYALxJJ0cDjzwmXYrnw3OyTjElC+mgEWTXDhU+jp?=
 =?us-ascii?Q?uZM7sXo94VY8H1GMZSJAuOk8jnvj9mTlVDy1YpaqDJNEu7Ewq/4Zg3mph1zo?=
 =?us-ascii?Q?WKvzKzlfwybSXDdH64plRtMK4nUFp8NIvTyWazs0qGD9ZLv0wkXWtjsAsTZA?=
 =?us-ascii?Q?ORMi0/oRDolrulrJAN4xkcYHOWQ2VJIEGzLDJvmzl9ki9/NV0OniJFsW9jEH?=
 =?us-ascii?Q?pxm29mZt2REseaqj1bBo2151LU+Uz1Nlxt3lGczKc+kCwj/NKFUngz8RSND4?=
 =?us-ascii?Q?BDBW6grbjv0BE6RVKrC3Z60W6zWVwbIr53EJnYiSvrFeGCwliGSBH4E3zOlR?=
 =?us-ascii?Q?FTGO5NHRwR8tcxaoF2gpgpQ3IXJ62wvhoj2QGkzDq/9hnMMv+nQ8fVGu1sgi?=
 =?us-ascii?Q?IvJkD6JEukeT2TEr0x5y2tEcrTgqYdaNRQsCJKaSMwNjM6gTPdhTmACLvaDp?=
 =?us-ascii?Q?KUkhZ6H4H3nWXa+LJjB3rc1l02sTqJreFtGoZLD36G1wNs/AwN0JIVx8dFl+?=
 =?us-ascii?Q?8SiUNb0n3y0qmWErcWmJDW0EpNv227PD1zqfVLanyymm0mKfpRVPYeYvzS8U?=
 =?us-ascii?Q?vXbsCcucM7Qo1afug4TsKAXqUlKJ3PuvoZMYkrIzfM44GpslAzSU7oSC9wbw?=
 =?us-ascii?Q?4X8tIQgOVJvppDYnjhS8oO+ACsfaNR3z2bmziiSUxmF6ZV0gv2upeEFX32xD?=
 =?us-ascii?Q?u8OO/B9SnVHUhdAY2S+7tDi7E18wbs7+wSDuY8WnV75o1RqSrd0PV/AVc9gK?=
 =?us-ascii?Q?3nGPSMCkdbUF05TA17p1nIBwRCeIWyE+Ga02URRBGMPNEYqAoC5pkFg7qn4s?=
 =?us-ascii?Q?AqCTrxoGGHCcaqKYUXBgvh2vqFl4oTfoS6GxTsZm8zBVeBggYo13Stex7b5P?=
 =?us-ascii?Q?hMrRwlAHIWCdmbGat0l7H8T3sR8n8gcsLTyFw2vD+RKIsENICoZgI/jnZWnA?=
 =?us-ascii?Q?As8PVJvMK+7Iysl/k9zbHkfZ5rLFcHho1dRL8a1HtIwWuJln/blFhn8O84V5?=
 =?us-ascii?Q?IbrKULfRFjeLazk3/fNAQfYK2kGZq8Azg/L1soOzd+E20oT2gZfangPVlHSy?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9d502c0-49fa-4ec9-e1ab-08dce2091699
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2024 11:06:24.2475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t5eIi7Ejsvhry4AOAbhOtm9PFBv+ngX6lh7BWTR01MSjaGTDU9WUcLzVCL1PN5tV6uubpyN5FxReVtriEwPJBpPC/d86Vtx+q+GtU1ycJi8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8078
X-OriginatorOrg: intel.com

On Sat, Sep 28, 2024 at 01:05:08PM +0300, Dan Carpenter wrote:
> The fw_objs[] array has "num_objs" elements so the > needs to be >= to
> prevent an out of bounds read.
> 
> Fixes: 10484c647af6 ("crypto: qat - refactor fw config logic for 4xxx")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
