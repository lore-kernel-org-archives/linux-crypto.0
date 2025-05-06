Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F1927CB30
	for <linux-crypto@vger.kernel.org>; Tue,  6 May 2025 11:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746531019; cv=fail; b=lvXbRzaid4cShIVfOOh/tUxWbRU4y5PfZL+21IjN+AmZZaW6T8HloeBySZaHw1nxhGlH0urRGJqqYllYchh2/4ErfPrk8q1y4GGE37i9Sw66MBY20b6aQUmfmeLtPWh/VA249zgSOPr8KcaBrlVC6GqspFsBtnCGnbDd+3yAFEU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746531019; c=relaxed/simple;
	bh=Q8ntdzhw9c84MgDsbr/cuV0ffaj7zpVYfrmRmV2XlJ4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jIwqM7+4ONb97WSNNuwkZl/DaXaaz7I77wf15zZYC1zvSCuRorwFA2G4tRpBpYWf868JQGpABIa2eeb/hDYXXEU+fc3HUkM1S8ueZ+7iY20EYmD9toyg/hk4rPOEhQS9Nn/X6QIk9PFqMi/H4HBV6AENfI7W4y8ZC4XRyAXCAOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YTtPqkzx; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YTtPqkzx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746531017; x=1778067017;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Q8ntdzhw9c84MgDsbr/cuV0ffaj7zpVYfrmRmV2XlJ4=;
  b=YTtPqkzxnIo7lpP4ypiqx0c4QfA4Gpm3Ffi56FO08MXpDdffwjBxhpkG
   k3YWWsKcOI4SKSwWZMz3urzZt1H0s4VXsc2h5APb0PI7ulLwC3PnWJsWP
   M9o4Z9hQdqYKH0kXa5PWxvPnh1P3P0YoT6IBxdXkiwH1dvaULDdaQQApR
   IxpZTaOXCDJMQPqysee0Wzsn0zCdK5bozH5ufag1NRPWK5HmOULdkdrud
   OMSgIuTqOKCmo6jCZcmda/bDxB+jZkRLFZ+Z/JhOu3acesuKCaNrYeJ7w
   9kUfjNBHir/oHTCh0vYQjRe2qPqovcG2UB4G4L1y3FDoTg7g2xfiUx0Jy
   w==;
X-CSE-ConnectionGUID: ryDsbfaVSqygYMkAGNB0sQ==
X-CSE-MsgGUID: eX2NlzgZRZC1Nij43hR1Pw==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="48328387"
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="48328387"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 04:30:16 -0700
X-CSE-ConnectionGUID: c0jB1yI7QC6whOUEQCNawA==
X-CSE-MsgGUID: qLE3yTrzTNmY/IRW5CZKlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="140709802"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 04:30:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 6 May 2025 04:30:15 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 6 May 2025 04:30:15 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 6 May 2025 04:30:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kc/wWVHKBjvZiUqjq04h3LI1bPvo1av7bBL2bSTrFVGPXQKd9sfMvVUju25HEEWwgIDNAeAAN1n3xtdr8WsAToIXHh77lWPyG2FiiaoKsKFDZTgcaGskiWMIZ5YExOhcW2rm99RSqMkwMiuJmngYfQdEJU4QPQv8Jt0b1dbzWGaeaDmk5+vy6QUZsAhGkaxu9+p6ZXxtaIZEiEKPt3uxTGDxKPjmyy0crSHkFMdxqqXjV96vO7sFxm3+1Bxu1UFenFFVwIFHzie8BfZs8pbPQJ6J8/nh6ntjhhAZyfOQNfFALwtPjSKAgvgn06hT9jxAAN06KrKTOkjUmgeOh1PnXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BaMpgNAgsz+n5jCUBU5bKwvX6KCKKO1axyod4Tf/HyM=;
 b=TaXqcYT0gydQTGIrheggSNz5YyhoaEK5tFitBqtt4bQMv5wojelaGjyLpwcu+FczBirVDI7ySZ1GqP3uOJanN7NrPbZtwH3jVkdmTibKmL1T9q2gujdsK2wq7zjWlPDM3CRLQOlVHIoiN0usaQBlXQ57jI/xjRENBXG/1o778OKjK3OuyTMZobAmuR0rc+OCZWoK4sgcXTj1KlJJ1qkW+Tfm7D6f0dZW2NWikS0GOPttuqDjBk9dHbmmYge0+wU1V9UuHnoRIaIQSaitDrOd09VyveG6FDPiodQ35QvoUDSUt67O9ZlL0o8/uHis9Ih12s4KbJWMbR09gQpD89kj9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DS0PR11MB8667.namprd11.prod.outlook.com (2603:10b6:8:1b3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Tue, 6 May
 2025 11:30:12 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8678.028; Tue, 6 May 2025
 11:30:11 +0000
Date: Tue, 6 May 2025 12:30:08 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH] crypto: lib/poly1305 - Build main library on
 LIB_POLY1305 and split generic code out
Message-ID: <aBnywNFIL4s8sBI7@gcabiddu-mobl.ger.corp.intel.com>
References: <cover.1745815528.git.herbert@gondor.apana.org.au>
 <0babdb56d14256b44249dc2bf3190ec200d9d738.1745815528.git.herbert@gondor.apana.org.au>
 <aBjAFG4+PXbPgqFw@gcabiddu-mobl.ger.corp.intel.com>
 <aBluBfXCtOoGrPKW@gondor.apana.org.au>
 <aBluVB9Xg2hbNlKX@gondor.apana.org.au>
 <aBnqw2PCznYO6lPB@gcabiddu-mobl.ger.corp.intel.com>
 <aBntFsNuZ3m-gR7p@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aBntFsNuZ3m-gR7p@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0126.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::20) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DS0PR11MB8667:EE_
X-MS-Office365-Filtering-Correlation-Id: 244e8757-87dd-43ca-83cd-08dd8c915ce7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Fs1YHqvnAn/oIqvMEglmvGjCxhoeZ5dXLulUJDl/0U0IZlzbOSvnFTfOcBcZ?=
 =?us-ascii?Q?Ts7qWzWB7P377Rn0l83e6ZhfriPtnxQnQFJhpsvVNjMUP5b+NUjYFGzsUhYJ?=
 =?us-ascii?Q?4CApOKB+yCxxGnW4KnNb+XBzAnowonZ1ebj6noFxKv7S+iRIH7ApK1ns6clS?=
 =?us-ascii?Q?omOIvFGRDlEHSob1gVJfcNj1y9H6HxyFKsOI2v0V/hgCx4dSj91xNQ3rr9LW?=
 =?us-ascii?Q?W/AdaNeEbB7Oji8wM3BFeOiOdlbWBRP/0uDziqhRSDpAic9k4R5YDwaJblPk?=
 =?us-ascii?Q?4XZQr1imXBhAUA2YnlAyYiawAVIl14YPq37oZQm7NRz25Ytgh+DGzyk8M5j8?=
 =?us-ascii?Q?YT9Y3lVKZ/iZPqm9qdeg7+E4ZQBfETrgrpgoKkry2kKjH86Y6uKooFyt1cPB?=
 =?us-ascii?Q?D+lfrGIrHA8cUr3tMO1TUHDUXBpxLWTBNNORymCJSwTGGV9lXlu+bGDZVrzn?=
 =?us-ascii?Q?obm5gnM8i/bLJDN1mcJOEKYhKi++g/xuR0Iczeo+juqN3rvddg0uO4Pb/xg2?=
 =?us-ascii?Q?l7yBSV4F7Xw69TrE0Ka7H1Nr8uyZ8JaL+r5+KebGjc9gxplYVLZp4AnfEZY/?=
 =?us-ascii?Q?wcCuLIFPWV6tjNxnOjRBZ7P7NDgu4jFNMr7lyfle+Hx5Box0pFSdpu3ttfLt?=
 =?us-ascii?Q?uNqB3Rmvh9oHlx7YVKN7dPr5QfGEfg6mh5pUow2iJgiGWZwxhEAgoymWpwKW?=
 =?us-ascii?Q?9Aw3rAsQbMqzNftjAnqzv5LqXjseGG2u/rVStB3HKq7Vw1tyRBhzHK2rk3gV?=
 =?us-ascii?Q?XLq0KAuqRhvh7jbxO9VRJ1uADQbNGPPQEvKSoCceZJ6LYgAY5l+gMyLwom1+?=
 =?us-ascii?Q?C8UwPzS3JMKwAIL42+BOyjD47/Oiy0rqjnCvbg5qO0Dj1sgCGsjb4mphfjDV?=
 =?us-ascii?Q?uYzsRko2JAGlUCcrnEdM40fRlIWmAJCZziBw/4piW96oRGu7kw108vYApJW6?=
 =?us-ascii?Q?UM8k8Ks6fVxtL4el9wsZs9u7P7A5mlW1gYaPmJmbOj2wvxYx1NZMojxc0XMT?=
 =?us-ascii?Q?okRMgLgjxg45HSOoiy3O0F5hmKvkThbGwnDFG2kSnYdal6pq3ghx8hvJMZ0U?=
 =?us-ascii?Q?maEloXt6AxTa7JYbvpzfny7b88/uV+NA7TKi5b6mTdE9D1R6ppkSZ8jZ2y0t?=
 =?us-ascii?Q?XR+01Xx0if+4z/1B704tQpQawvi6OPcxSM9+5wREoZhSXSdAGIknQbxIfzNp?=
 =?us-ascii?Q?7/tTTlCnlwR64qkpFMboUJ9nKmvt8PMwDs9rjId4saQNVF5CP9usy0N2PT+V?=
 =?us-ascii?Q?r+Jl7lbffV0s9un4TqXD3OLt0l+oT6kQL5S6zTk8UBpHYNQyDecL3tvL0Q/o?=
 =?us-ascii?Q?xO9oiSBytnRvZUx8GHonK38E9PFzwPrwZMIhmAj2YUZqreddXM+WD7dI+5bG?=
 =?us-ascii?Q?+Ijifhs/Uug7mEGmzWbXSFBRAkGNYJFLtWRul9heYRelx2pY/OjJKIoqGyR7?=
 =?us-ascii?Q?B+LthiGk53A=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5W2XZsPJFjmkttrwZL1TwtO3I2wSqRxigE8qW0vLWI8odNHYPpxtSVeBtyPB?=
 =?us-ascii?Q?MCg9aBZU+Sajw8wDERAriIftvxBxOF/evLtJdEG/+kW7DnjG5cWjgYqL5uxb?=
 =?us-ascii?Q?prlbrpPum64TSmtDaNIoj6Evp8i/QWjknVuR1hFAok7G3HdmbIALLzXuXYaA?=
 =?us-ascii?Q?zBr2lLpvHUTSzPJLq5PvP9o3lmzmEcGUnSuscfi67Hbhlx7BamLCyMM4LzWs?=
 =?us-ascii?Q?jICkm3AKxzDx1U7DLJscP1l/Tm2S0vWTOB2aPtUrLovW36K3MpvlXdzxcEDd?=
 =?us-ascii?Q?kJnq3psiTuKhPKDGe20s7sQcc+57/JeeuKT368Gj0UXYHDFl3aqQwvVUM7Ci?=
 =?us-ascii?Q?oayJxLMwNbaSe2fH9vD7eQX0seIkldR2XD9YpkGpAyyE/6a8/leNYEuRm202?=
 =?us-ascii?Q?byKjjjDxC256Bx3SqpAT/SQDF3EeSG/lJ2cLGnZi7KeofPLdD/MI3uwntf6K?=
 =?us-ascii?Q?49AIGZweqAUlO4VHAvfZjf/5JywtK5S7Iz78rRPvixSOsNxGPz9MmOFP4pX1?=
 =?us-ascii?Q?KP4kBeOLXUutCFpdMzMLmXLSxzi56jRvHiaYxYHpDKXDehEQAD9/4Vy6onTM?=
 =?us-ascii?Q?Pe8R7hpCcuNFg+h06JEAVSjR7gxEUMRdPk/pau8N7teQ2AzR/tH21aNJFZDt?=
 =?us-ascii?Q?eAI5OU9bOX9vRM1ySImI5AR/NobbjHMR+7dnT4W3wIXEwt+eSz3k2oAzmn/E?=
 =?us-ascii?Q?ITXY3yoX8iTTuaV/fYM6Y4B4yyH7l+k9sGw7DdJvG2sVuMfca7AOo4NVKOrj?=
 =?us-ascii?Q?QXpQ8vIEG8DElrKxGxyiAxJI/v9O98RqSPz01gH35IwXXFvGA/0O+hU8cX6A?=
 =?us-ascii?Q?BLmTDIRqUPQTH72NIMceAuTdMuzzr8upD6ay6OyvhYzPGbWrVHVCqx9LMmB5?=
 =?us-ascii?Q?aMOU12/EnQgNJN538j+4M/tokcmxNwDa6UGgSf+ZKLTfEVwBTqF2jcpP6khc?=
 =?us-ascii?Q?xsBud/pFHyU7xeWytMW6hUtJZP3eiJ7KTmmIvUIdINbcHSv2tzm+NffPtbMN?=
 =?us-ascii?Q?FuG9eaFoXFkmbTqb8qHqrZh+AaZxrRBocPB0UCrMxFgaa9zvizxg09mjSIPE?=
 =?us-ascii?Q?6BuYfPOfzgiY9dL0WFarm/WVGdJeCExrlMpNxy6CdqqqgjliXhfsOYLgiq30?=
 =?us-ascii?Q?MI0BCacTYpB+MT+bN9gTIvFyZbvqSQqZ714mU5WHNrYAFSI6fo0OoG3FiTOU?=
 =?us-ascii?Q?KhdnitV0TeX7mkvokNWljVLsZTEXtQZcdncZHU/qaRp4ksM5FA8fl632D+mJ?=
 =?us-ascii?Q?esuJqMX1u4WItOJnA4r1/TwcyBrmUsw1Fqyy3TwoGsj5BU+KEEX5/G2t/xeC?=
 =?us-ascii?Q?xPIZ8rVZNr+KNF8ZiHWODq8u2FzO34BfUGU7sU8uul5EZgnlNi3wWSAwhit0?=
 =?us-ascii?Q?HfY86xa9ePQbC6Cs3C7p03x+MQpdUX28/zxSJ0CCa4TS6SCoeyrXztRuPkHD?=
 =?us-ascii?Q?Xz/HR6bPZ6YyX7Se5Y7WmzYbMXe7YNnshCwvAKswfSc2AsK5K+B5EHpTtwIV?=
 =?us-ascii?Q?qh9cAKslEyUE0IuQHDzVb3FIZivd0J08MStlZ+EQvpAVqAxwpvffZmoPy03q?=
 =?us-ascii?Q?39EtPjKi9EC9iqxWevDxzQzXCt8oyKCeH8wgcVM9rhO2ZQxw10RfNVj1MJxe?=
 =?us-ascii?Q?jQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 244e8757-87dd-43ca-83cd-08dd8c915ce7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 11:30:11.4541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kcnRM7jhH49riraIBxNU6qEAFgZWsolSm9vDEchEpdCi174nOeU8BHIMoVXrzpf8dS3HCXlgg1/6zEqVEyCv0X/i7z4TqBjykSgLoMT25M4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8667
X-OriginatorOrg: intel.com

On Tue, May 06, 2025 at 07:05:58PM +0800, Herbert Xu wrote:
> On Tue, May 06, 2025 at 11:56:03AM +0100, Cabiddu, Giovanni wrote:
> >
> > With this patch the build fails reporting a missing MODULE_LICENSE() and
> > MODULE_DESCRIPTION():
> 
> Oops, I messed up the Makefile:
> 
> ---8<---
> Split the lib poly1305 code just as was done with sha256.  Make
> the main library code conditional on LIB_POLY1305 instead of
> LIB_POLY1305_GENERIC.
> 
> Reported-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Fixes: 10a6d72ea355 ("crypto: lib/poly1305 - Use block-only interface")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
Thanks Herbert. This fixes the build.

Regards,

-- 
Giovanni
