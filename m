Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66031223301
	for <linux-crypto@vger.kernel.org>; Thu, 20 Mar 2025 17:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742491508; cv=fail; b=ParxAGe7uTGL+qrcxSpiR4Ke9xS1ufpUAyPZ7H7THKezm+5tdReZAZMsCM9h9nZO7zhifSHYd/4ezhyNQWTAGDyghKxnCkG1lMzeAIK4pi+GcWAYDhLnvi10YyfkiKVbZGZLjCuk7rr6+ltCiHGp0/kZvfF3iBeZm2zIQhSKAWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742491508; c=relaxed/simple;
	bh=v4G9gGMzQ+hpsb6dK4J26lmTKevK9OYrMds67mHTErI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DbchRM+JqTdcfpCQnbxYvAGSN69kRawehFVUZQlKwdDH9Gj7lGTFrBlmAmGRzQZfBFwnnytt5fkXwdncg583acq6dZgp0Q3YKau1ei+raccqZxHWezM+gZs2Sa9oLCgN2kHVsi9wAPLK4FtVoSDgclTNCKJ/gfnX6UfOfls7S3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RDkqvbsp; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RDkqvbsp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742491507; x=1774027507;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=v4G9gGMzQ+hpsb6dK4J26lmTKevK9OYrMds67mHTErI=;
  b=RDkqvbspwEs2HWFJufDMP2MYMoEywpAVlJsCoA7J6cvYZjcTLic+yeBw
   E94rPhgulVVswZ5kd+8/m9evLSdKR/8scbYbIVvvKOzOjKHjSDUKNgHyG
   1gj/Gp4QFy0yu+ar561RipNBQdJNUDV+gMx3UVDmJ0M9DgvyWSpnvmRd5
   TVbmjOWR4O1yZWKLuh685jL0dvE6zXI9x7F4Ta/pK9Qx3yv1FR/enPhNQ
   WanuOvFWj2sfS1JmFi6V9eCwD/BrGg2jpJTr8JS9/Qcbt/67VuQvCTLk1
   EknJa3+bD5A9C6U2aVSZuOweT4+szo7lWNKl+esfTxIK+FGPA5+8n/a2m
   A==;
X-CSE-ConnectionGUID: 47wlg+bDSgaL/Eprb+LQSw==
X-CSE-MsgGUID: eepSI4z/Rpe0K0QMi/Cp/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11379"; a="53958776"
X-IronPort-AV: E=Sophos;i="6.14,262,1736841600"; 
   d="scan'208";a="53958776"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2025 10:25:06 -0700
X-CSE-ConnectionGUID: vViNai5CTmGV/bp9uNQEgQ==
X-CSE-MsgGUID: nneb2XoMQ7aidsDiCBBdGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,262,1736841600"; 
   d="scan'208";a="123181167"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Mar 2025 10:25:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 20 Mar 2025 10:25:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 20 Mar 2025 10:25:05 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 20 Mar 2025 10:25:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cIua4G84AX9H7QS8C8C0whd+dlFDK1vipygPM4SE78xzpQLHv/btHlZ8bCU1ulFPFvdhFZsv6/uYLlFLezOXEUWy3gZxfaoPjIQIMsT50C5MGF3bW06bVHp2vbd/d9jLcLNAdjzGZevKA5w1oYlrBOW4Z5ZXjBUvrjcrYdZqKnIFKU1+Hm3Xpx7O6Yh3HHzio4uDFr0Bm572/ZGbCC0kgAtPetwJo48OEIqPDFMMc6S9YEfTS5SJu1T/WENquQwlAGZNmzvBBcTFcDSWHJhe5ZmGw5D8Dswk1iiyY3+Nvksxfv1weLUhsjxguUe9bq+v6WxdKz27w2bh2mmk1Z3YxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/KNoR8BCnOc8kR8VsgWdvyUMfGDqaUp41EyeqBwDFtM=;
 b=UmcdBgYvC8htAjkyN+RPG9sTdYLOWxwja5hkEyo3cBLDNpXprpLqMlZtwXmPwsqsN3sFYwxRHKiuzlW3HkPSt1fo8oINE7v/N7CZ1T/ikqFpJT1kWY7bmKAg/Q8pBHXEmc/Onwz7mDpcO3xMD9dUUmW1u4Ap+U9X4nC1xOLXjLOf0P9g2Uxow2fW9sNoZjoSL5fgsReeSY+3TriBwavKThErahnYk1qqIVSMoFQJ1qkTBM7epeLAs/tJcB/NbcCvVFK7P5BrGfpsK3fO9AEERZD5JQxsY7DkxAvxHeIKg0cmclH6BJZKv3eK+9Bp/TS+J0F+Z8UOIcntLFpJrsuRGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by MN0PR11MB5962.namprd11.prod.outlook.com (2603:10b6:208:371::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.36; Thu, 20 Mar
 2025 17:25:03 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8534.034; Thu, 20 Mar 2025
 17:25:03 +0000
Date: Thu, 20 Mar 2025 17:24:57 +0000
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Yosry Ahmed
	<yosry.ahmed@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [v3 PATCH 5/8] crypto: acomp - Add request chaining and virtual
 addresses
Message-ID: <Z9xPaQNIyFi9fiYe@gcabiddu-mobl.ger.corp.intel.com>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
 <e9da3237a4b9ca0a9c8aad8f182997ad14320b5a.1741488107.git.herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e9da3237a4b9ca0a9c8aad8f182997ad14320b5a.1741488107.git.herbert@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0134.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::9) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|MN0PR11MB5962:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d62513f-7ec5-4fd1-6b90-08dd67d42660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?qqoe17ilLJpcoJ/v8jvCrLIm71Heu4UlyY0wbjYGjAaUUTV2vZEYEKQU4+AM?=
 =?us-ascii?Q?8UVNNPXN8iN3+WwY5cdlHQKZ0DhCg9gAj1bstVT+6ovrDBtTFB+fCU5CoQJ4?=
 =?us-ascii?Q?jv7tu5Y8rK3pTqzGH5Nuy0OmjUzeKjRhOJO97AxDFgZWIoCfsh4khQiiuq/n?=
 =?us-ascii?Q?jlhyfzlIdUqdiFrEF6YagHh8Rc1VqoiWrU5ttzwE8r30Qm0xnO163dgG/FY9?=
 =?us-ascii?Q?snVmhtlM6D3Ns6MmYzsQzidPBMFwg/W4/C9jXAwQbQOiX6jrzfcg2ePiDqbs?=
 =?us-ascii?Q?tBmGhGBPv5VPtYyQ6UK+/O9DbJoboDGsZlr3H6xgkAMt2WvSIGxOopb5loZm?=
 =?us-ascii?Q?I/64uAPxNhbqdrAkgnigUua1bZyvKkaG5/2cDMNsBjvHfUQRWcl/fZHRbnt4?=
 =?us-ascii?Q?jPsY1n7UO/k5b8zRwsC7ZqHJFyyemqVIdgLrztl2KTGXYBXNJmpLo4WfeuR3?=
 =?us-ascii?Q?1yWqCf17vgJXEzWQEo6+73jQOwLF/+DTckI4p4ZlM2kTf/pXGVuWG61+S3ig?=
 =?us-ascii?Q?EZYFf5BkNh+pcfgHX6Hjji7n/WT+DrVVUjFoM49xshKIT7DFllQt4cOmXHKu?=
 =?us-ascii?Q?f9907dnCeRPqZDMKOOJJrhRTovhZqT0zeDx2MBNZ6teyHP2m6v4BoZdigcnt?=
 =?us-ascii?Q?cNPKidXydxrxNSumjZquKXCTktPHCq2PIRI7LwIzVp7YG6YiuG4W+uCUCfyX?=
 =?us-ascii?Q?t4QDXcXGqEUyNTDMweMX8kEMDzX/cle/4lkFwBIrQUH28nAFtmSekeHOm1pT?=
 =?us-ascii?Q?JhjpBhsYkUy91JTPdPBFvuMRkpfk6kCEWQPKnrLXaDArOIA5wsDRVb0COn7O?=
 =?us-ascii?Q?EitpQfJftU2RR/rhQCPvV1/mcUQysxDmDZzeerfqirF7+Qx/pGNmr3gCOO+Y?=
 =?us-ascii?Q?NTYCi364VtUWkbk7cDNlST3ijPMlcucg43fzwXQAXFj//o1+FLKTIeBmckns?=
 =?us-ascii?Q?W2C8sJS6qZrYIgx4uXvyzlPomcFFoQOfdlAjWOvNj4ZNDfIEXgQWYiqQPAaQ?=
 =?us-ascii?Q?Oc7ADOlpnWhIqzLyqOOGSjcj3vIGkA5UQdSIDZMXISEqXtPrS+6mknbuu43R?=
 =?us-ascii?Q?yPK6/J0slUurZZyZHm6IqYogVou2q/zbbUykQ6oo4/vWvmy3ueIVvcEG2RoQ?=
 =?us-ascii?Q?QXJ9e+S8EM1JAP14X8l+JBz53WeBAAE0To5EGvekPYWwAF2jeGjxGobu3t9b?=
 =?us-ascii?Q?YEyjF5W2ayTjQp4IvwtdI5gVMjebfy6LtGjiFfx9J5beQIunOKu/McSouOQX?=
 =?us-ascii?Q?IbnY8hbeh77wOpgA5So7A/hlLSpAwQJJOYrpK1MgHKnX9XGDZCMMuudtHdiA?=
 =?us-ascii?Q?E3so2b9J6uhXBG684Heg01zSV185Ou9SgYGXfXh2niVm3p5+6weGSWAd6cYL?=
 =?us-ascii?Q?xz15Al5ImgxQHjyQKIiY40EZddDE?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rTU/eotKAoh/kMP09Zk//lNwdMWQ/YmdBVT6+18OKuLVIuEY0zP4L8kMqC8C?=
 =?us-ascii?Q?vKew+wWLsWH2Ysr2g/W1MDvFzCgZaFhHbGQmq/DkYH3YOTTVQ6UvObZC0zbH?=
 =?us-ascii?Q?HtNjw3U2kXaEGB8EnQjpTrz8DPnq2TB1tW8neMgd5uv5E+nVnjhmZ2/gLaDC?=
 =?us-ascii?Q?UTvxEs/Kxfy6/5D0TFjhyXe0UmxqfB3WVTyUchXF1rrzV/wZT726O6m+u5nu?=
 =?us-ascii?Q?+t1dnpX1N7o5mdp1+o0Up7fGUQmpVGMpySr45UDo5uY87BNkFRVT7M3Z5I6e?=
 =?us-ascii?Q?+Lq8UTtuKQpDMLD94kyKKr4Upo3lrOmHVk9PFGWbkF1NoY+M7VbpE0RhX9Zl?=
 =?us-ascii?Q?76vn+LAxoFIZSDTdysmNGSgG8pfSTLePvXbcOowL5roJgf3j/EJyyhgw+ckP?=
 =?us-ascii?Q?ZURspuipd5GiPM3BGyhpiTf5VkfilEK/fYFt1rh0LPtFgVRRfGKWd+WHmFM3?=
 =?us-ascii?Q?GMvWLNeI+J6dPKFYhomg5IEuj0PW5IftTuO/NhhZTTaobkmaU8cugj3FWrxj?=
 =?us-ascii?Q?eICyVBwxs4jSCQa15Hu/faXeCBqD3aEjKJpWk24OeJgBgPXa8HRXN0YCHUkz?=
 =?us-ascii?Q?0m2EDuvmSKab3sPGYmOjNHgIAE8PW8VWmGT144czUSx+d9l94VLb8bWP2VPG?=
 =?us-ascii?Q?u13rfHW2GJypqYPoVYojvJxc+tddcQInKCoMopZF6JcdmZM3nETIuy+KtEtw?=
 =?us-ascii?Q?Y8SulDU6NZRFQurZjHyU7liaEPpfV/dZaSY3momM8VSebdeC54Eyf8F+EVoC?=
 =?us-ascii?Q?aQq4iPB3WxAcP/J9zzzm5XFH04xeqmNjs/FHDX5MJBYGVrOZnqNTe0reAiUO?=
 =?us-ascii?Q?GugfhBuZPT9ovGnnFp2bupUTkksdImaVmdPnzBC9zZxwkcgNwNbdYS0Nkpd4?=
 =?us-ascii?Q?uEWAdjaPRSfIuocISbKy4DT5ylPyBtlD+2DO8RuGEMCoT6JPpmvRJPVETBbS?=
 =?us-ascii?Q?zAcO82gGrggj1mtFWs5s6S9qGtccUyGQnAs82p5D/MAECiFpxjrCOz9lMJCl?=
 =?us-ascii?Q?HycZUuElzaW2LzrJs/l98pgl9D1pLyE0rv3l2HKTg1wScX+8zc2v/RjIjc6z?=
 =?us-ascii?Q?VSpsvoMCZ5SMxBwb+q8pmM8j5ZKmP3X4UONEIf+HH2pRBDipfn+B6ZJ5vPpN?=
 =?us-ascii?Q?MhTkaDklLMWqs551cYpNA6QJ0iTCiKUbuUe0Cgf1yw0E9/J6rppFbPNwbB8W?=
 =?us-ascii?Q?m8f2isBYkGoleDBycOQWe4HbL864RyQibiZqlMwSi9JEu2l1z3NlpJUVgt6O?=
 =?us-ascii?Q?g2w7+aWyqyQ/gpp48Sir3xxE1RyWOY772nNWyBDeOlAv4WJOv27zqvwX2Y+r?=
 =?us-ascii?Q?kDycl6THK0b0DJbqtQIDEjssAXuZwEh+8FWuCuHZKTjShFxKY7mSGnBAjpcV?=
 =?us-ascii?Q?d84ExEQI8uLn+LVACulFHCuTbrB0eZiX3OBjme89qiDmKtMcYxTOglwLM9xm?=
 =?us-ascii?Q?fl2xRloxAeVBXx3k4oxStnTgJpoQdrROgpT5nN1x2FFqnXnypXjpdFpR+PEJ?=
 =?us-ascii?Q?kfV++9K1or3q9S6udl4MDGdderzCUSzt0c8UzzWrZuXWia2jsJZoQq/4suXE?=
 =?us-ascii?Q?LICwpXClVfDgFnBJJ+DcsQACpjLHTB/0cURX1lSPiawtHeeboIOAujJA4sN/?=
 =?us-ascii?Q?bA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d62513f-7ec5-4fd1-6b90-08dd67d42660
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 17:25:03.2136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BlYBkBCEmJESu1r6P1Uq63t0/JOlV1nYRsqux59DpqnKh7Uy0pi0B6UciR/oQZIgT3R8yWbhlL36qtYd5KybwVs83lO0p1DqVW35SZk4v/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5962
X-OriginatorOrg: intel.com

On Sun, Mar 09, 2025 at 10:43:21AM +0800, Herbert Xu wrote:
> This adds request chaining and virtual address support to the
> acomp interface.
> 
> It is identical to the ahash interface, except that a new flag
> CRYPTO_ACOMP_REQ_NONDMA has been added to indicate that the
> virtual addresses are not suitable for DMA.  This is because
> all existing and potential acomp users can provide memory that
> is suitable for DMA so there is no need for a fall-back copy
> path.

...

> +static int acomp_reqchain_finish(struct acomp_req_chain *state,
> +				 int err, u32 mask)
> +{
> +	struct acomp_req *req0 = state->req0;
> +	struct acomp_req *req = state->cur;
> +	struct acomp_req *n;
> +
> +	acomp_reqchain_virt(state, err);
> +
> +	if (req != req0)
I'm hitting a NULL pointer dereference at this point as req0 is NULL.

I'm using b67a02600372 ("crypto: acomp - Add request chaining and
virtual addresses") from your tree.
I wrote a simple test that chains a bunch of requests following the same
pattern in tcrypt for ahash.

Here is how I'm using the API high level. For now, I'm using the software
implementation of deflate (deflate-scomp):

    tfm = crypto_alloc_acomp("deflate", 0, 0);

    req0 = acomp_request_alloc(tfm);
    req1 = acomp_request_alloc(tfm);
    req2 = acomp_request_alloc(tfm);

    acomp_request_set_params(req0, ...);
    acomp_request_set_params(req1, ...);
    acomp_request_set_params(req2, ...);

    acomp_request_set_callback(req0, 0, crypto_req_done, &wait);
    acomp_request_set_callback(req1, 0, NULL, NULL);
    acomp_request_set_callback(req2, 0, NULL, NULL);

    head = req0;
    acomp_request_chain(req1, head);
    acomp_request_chain(req2, head);

    ret = crypto_acomp_compress(req0);$
    ...

Do you see anything wrong?
Do you have any documentation or a sample showing how to use these APIs?

Thanks,

-- 
Giovanni
