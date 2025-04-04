Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4401AD41F
	for <linux-crypto@vger.kernel.org>; Fri,  4 Apr 2025 12:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743768747; cv=fail; b=NAvMjZ+nGp4NjaZCzpePk3Eo6fY8s5RZ0iRuRULLbmR/Rp1o3kgigH9YAiNP9RrZ5kjdCiIoYp6qR3hT+mfhVXdoUInU3kgRyEZ+doq7LMPwCyoX3Dg2qSAyP9raRpu/+DZ0ynpEutavQ6pmBjytQIi1DuHOYWXWtX86VUZ986E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743768747; c=relaxed/simple;
	bh=nkp1woqXRLQ+aNwl8UER29N4bdzMzWEz5SIVA2P7TPU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZhdtrvIavZFuNnEwT3Ga+6Q+kpjPyLaFBOZJ9nxfSpZVDkjNQCVGuR2BLyN1fsu/vgXPFHxlhgimyCJYejhktLl8zpEYnmiZmrHrVgG9OohsL5HX9tkenDpIJLzsfETVIpTuvCaoBDC2+ciC/otrTbG130z2jHL2NM0YZ6z0mS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i7tvdXq0; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i7tvdXq0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743768746; x=1775304746;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nkp1woqXRLQ+aNwl8UER29N4bdzMzWEz5SIVA2P7TPU=;
  b=i7tvdXq0BiNCxCdftB3xk0an1M8hhXUFjOpDgyyhJ0f8CZntX35SpGqh
   x17AOcRIipv+gyWoCkvUJZhOBrNknFAxIr3GJ+9h6RplaaYP/axtJx2nS
   L3u/qgbhV0NU53D/lG5vveVQy6O3ZJC7eZgLb2fCAYF3iMsGcT/DjGSQ+
   bH8zMN58ZXve4RNKREmfOr3HXp6LdpGIEvif2cN3ITelWLYpg2nk0jQWL
   udrdZNL2G0VpwhGCq3EeG/ndiVdGuvVZ4o0zbj3y0T7Aybnn0FGXkS7CD
   RnE/r2peX/lwro/qMRueqfutN9yiSAjKgBGCZ9Flv4+uafh5yu5mHoE4F
   Q==;
X-CSE-ConnectionGUID: Qi7vyUl6R4SYakv+3gJEjA==
X-CSE-MsgGUID: 2CSk8esrT0us3rSoLCgvwA==
X-IronPort-AV: E=McAfee;i="6700,10204,11393"; a="49066538"
X-IronPort-AV: E=Sophos;i="6.15,188,1739865600"; 
   d="scan'208";a="49066538"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2025 05:12:25 -0700
X-CSE-ConnectionGUID: chAiV5cIR6K+yvCK9Ypy+g==
X-CSE-MsgGUID: jcDJTQWMQkKFUVd/dhpcTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,188,1739865600"; 
   d="scan'208";a="127191921"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2025 05:12:25 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 4 Apr 2025 05:12:24 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 4 Apr 2025 05:12:24 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 4 Apr 2025 05:12:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Spk+m2PCVJcnXR0LD3SyIWWCeqTznNOOH7G8nleHuT+tFKK+lgDJgaVgilcT63SHLkH/QDfg91Lb7zpAxtQgoyD+NH0sbMHGg0OvCdgKnFrO9sAFmVZVnMzbRQz5eYzhuD4SSA7iihzH2JeRnHfTa2jrl0qGuvmgnAXisswVqDXEWg+D0ETR5xLj0uOHKZ8hWWETh+bo471fUBI2DKIS5GPzsgZ+ny9aQyTu75hYGdlqCoZQLDpfKXDDcfbjDlNpn6/ajKHk4vk51aAEWJv4ctqnRkUQrnHH2/9BUzS6ZhWKQxZafw6XPxYwiae8Xu+CPLmD1fQkqOGrM6o+/wBEIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UgLCtCIJx8q97BTGFb/wWeCekdZmhPBASxaxe6svTIk=;
 b=TPcKylozLSHlihsHvEJDSM+9hAJ+VnIC/YjRlM273GkimEMAfgC3iKyUCvDHtCNJ9v6/CcK50FzBAyjkmPJz+zi8wMfztsAqoryGtQf2bBZn9OiBMCOui4SVHLFXWl90qXPQiZk5AaSON57S++3SS8qxLCJldV739BSohcsBpnAzYwjK3+INzEC4kw4Y5egv437DSL378TviLubgbB/WFAbjKqTK7/dcYyH1D0KLRXmZAzlk6qZbQVPFFyTOrL0du1Z0wKGRn+Da02YUHwTdIzxv1uJs4rO5aeBZAzrSa3N0iAuv/Yr41puyxppwJHBTtzjWdhRxj/GTfOihGJyMGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by IA4PR11MB9081.namprd11.prod.outlook.com (2603:10b6:208:56e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.43; Fri, 4 Apr
 2025 12:12:22 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8534.043; Fri, 4 Apr 2025
 12:12:22 +0000
Date: Fri, 4 Apr 2025 13:12:18 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <andriy.shevchenko@intel.com>,
	<qat-linux@intel.com>
Subject: Re: [PATCH 0/8] crypto: qat - fix warm reboot
Message-ID: <Z+/MomEpHXH4ZJHH@gcabiddu-mobl.ger.corp.intel.com>
References: <20250326160116.102699-2-giovanni.cabiddu@intel.com>
 <Z-ynxYw7OYHjfSaF@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z-ynxYw7OYHjfSaF@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0278.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b9::23) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|IA4PR11MB9081:EE_
X-MS-Office365-Filtering-Correlation-Id: aa05c9c8-a236-4fec-fa86-08dd7371f44d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?acXPJK1bw+shv0G33TLcp1ngzzvnob4n8/7r5GSLrmJBr8SOH1P2P8efhly/?=
 =?us-ascii?Q?7PZ4AHGBMW4PZy+oSEvvcjJBttAh8uwXWCW4TlloJbA9otNjDce9gcLsbKHd?=
 =?us-ascii?Q?qS+zD8PgxXZv4Q+PnGXASNyQbTBbSk4WoQmbPPoLW5y+DZiLnc/ffPY6lbwf?=
 =?us-ascii?Q?bQeU+vweuiS23Jf883wdTIsAmdLgRuTRVX31QT4WG+nTXxzb8oCXhah6c/MK?=
 =?us-ascii?Q?KutdFajHtdtFdgjAqNOct7+c7HtU6eMkqa2V86YnG/+i8yQIronlXprBiHIZ?=
 =?us-ascii?Q?PYp+ikxMAm44/8/TauOZL+azY6/b12wtQNVyDZy+fd2T9bwjCaufPoHN6ON4?=
 =?us-ascii?Q?AVMYdmxiXqykv5AY7VxQYpjv32NC5sgDgmZ8/t3tUwwagnJ7YXFJk20w+xqy?=
 =?us-ascii?Q?rIEA6wGM9aVJP3BycRRG2LQvu0LS/aaMl5lih8dG2/JKft3SeTUgRkCZz+Sp?=
 =?us-ascii?Q?kDxB+sBs25zFk81ctEdgUVJZCZXAgyUGOsfIT8wx1y+tQ/T8MJUcETF/uDaW?=
 =?us-ascii?Q?VANjn1Nl/RCa+CnxatNGRfwi0hTx5pF4DIN0EYNuTjzh8aXFHxzOyzf40srF?=
 =?us-ascii?Q?Xfn3D63m1OLjeoxboOoCc3iyvWB2entYiYd6SzbjeYgjOwyehrnwdanVw3Bg?=
 =?us-ascii?Q?EJEUliLYsaO2mE2ZPzVETL5LSfQQ3ATR+mZXjdxmf4ZgCuxDOXh3euuhX+Mn?=
 =?us-ascii?Q?NEwzZYtt38BogXTEwemwNsMkCQYTotuw+whvMhMlsC5iwuZ1yd8tDlM/ou39?=
 =?us-ascii?Q?3LahFq0F+vzDRctreGosgJb4k1gntdDWexYPKpnUH+U/VWsVJIwsHW3kX4rh?=
 =?us-ascii?Q?t4fCW6Q8v/cq5Nwr8IkRjS+e37J3pjP2iS9Y8HrjVoMWrVWnjveNARO5iKwo?=
 =?us-ascii?Q?joIcDm7aVtNoIrVQ7SkoaL/fCikOGJCHBDLtZsO0eaZvT2JCIZ29015a1MA0?=
 =?us-ascii?Q?tgyrMUcXgYAQ7Vq5SiXcCzsDPqZvhu0uh975ZyNMyrOHnbviiz/Jk7AB89gY?=
 =?us-ascii?Q?Wl21WvDcxnTT4KoVl3q89xlJWgRodjNycZpOA5OEFVC64IM0s9R5q0BmXXhw?=
 =?us-ascii?Q?ZVZQEYUo1Okwm+iZ57yvIy1MoHJy2J4meILx86vQq1XZPUJgHy4ysprh2YHF?=
 =?us-ascii?Q?soo3rS3kFrkp5Z1LrhQtZ4CUK/83Pc5LGdhAay7kDVWZyjhj3k276P5/EYw6?=
 =?us-ascii?Q?vOSuzWlHVSmpR1+VfHOSj4yBPMrjVB0cvqDh1+KoZ8wuAAUsBCCplS1d1DvX?=
 =?us-ascii?Q?viO5aDQpOpRkL5NvHrVro0TOxXJnz1Dj7indJCisoVjU4dUEc5z7sO2ayVqQ?=
 =?us-ascii?Q?GiCqCXh2+WeXrgQSWbniFCBqmNSMPrxlQl49IlMmnqPRWAxXqFAazmc705cv?=
 =?us-ascii?Q?rC2QuCCSJkH0546LuBlCQKEq9i8Z?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KtqRpw9k25ltjOx+y194V32IOci+7YMw7Z5WHcfdmkDAk2MJFvoD7Gvyduqc?=
 =?us-ascii?Q?w+g7gMPWpbv3Dof0khwNt4ZcoLIUoIFiDjzBbHxXwcChNJsRrop7xHxgXL1N?=
 =?us-ascii?Q?2QPv2nug030R2AalUXlZVzQqMaw9+nqVGLiK5aRHienQibmQpUWiZ+LnPRmq?=
 =?us-ascii?Q?y7CI3xfKuVWLd86NjAV/2zRoNwwsbPbb5Bysy5AzRlK+gx0BknJ4iZkGtWuB?=
 =?us-ascii?Q?q1OLjMgbbVaa9oqiIhTuyHiEgwvXXYIE/2tqulpZQynVKc6hLmSejZVtcgpW?=
 =?us-ascii?Q?yjNDFoBj++xgmS3J9HgdLY1AWK2bVTlqKCHOimF0EPZHAeOyHqFVRs5kAT1J?=
 =?us-ascii?Q?3BQfYlGYoBqcWV0lBpsY24wAOMp+Xgg8OlqLM9jHylMyCmQHo3pP9MXIGkcI?=
 =?us-ascii?Q?g+pnIH6OeJLDrhzu2p+/MhWwXI865CXb7S07abSfrN1oDbbZCZStksDiu1jp?=
 =?us-ascii?Q?m6C5K1BW4XHY7y8IN8A0kZClV0AdB+ibnqwEOgd9mvqTFcY4nVbS7gXCuwI3?=
 =?us-ascii?Q?7P0voMKXODC23Kqv5uniBSLlAdBeLDpjicGJJR/arVBJDiqcsYGkvq9gyFVI?=
 =?us-ascii?Q?9+zCQUy9XxefJZW50SDoMbmj+ZVOnj/zaDpHnesSa9CPk/1UJqxOk8AaOmKj?=
 =?us-ascii?Q?3vXNcWBYR0RlZhs2Eqmr48BxVlvcURUGQyhDINNRKtwQwG9fkCfwdNSqC+kp?=
 =?us-ascii?Q?DsTMo92J9+H6PX8XRbVBz9YgMPF2niZaPfGPQO9nJv8sPOuoQtIrM+CpPswT?=
 =?us-ascii?Q?dKLoRqDP2MNk3g8FXYpJI3cIr8eokdIJS5SfI7K7AdqciodWb6CZxj36BxDL?=
 =?us-ascii?Q?3scXRVWS7HZU4TlZ4r7vFIjfhwM6Y9oLHBr3EP3ZEjbGjY5AVzJismYYj5Se?=
 =?us-ascii?Q?9Nf4zG1QJTOWOSAFmXmgKccDHrBxV7woq3/VScQ2yaZO++4drnpOx+jDY/Ew?=
 =?us-ascii?Q?aQYvRYtrrvPDsXnMrGHEg3ZaSbGwPtEyc/851OhHqalJQgZ2vG5C6PKz1s1+?=
 =?us-ascii?Q?su8HzkQZbT5N0+zX7HKU+SqYb579U+sNCAYLtA64Mzk1xSFCMVLSEcf+oOMc?=
 =?us-ascii?Q?3Bc5fyMzi8ykWZ1kcM0rXvbMFFKSkJnxAAL+VhgANdMpntdT2JYDFK5vbu9R?=
 =?us-ascii?Q?Y++h6RfLOHci2Y8jna+is4rbl/UlaKM+6omZQI8olcaNwzbt6JXucdwuf74u?=
 =?us-ascii?Q?g9T9YjIa5l1fUNJyq+0yTu1JYY1LmRWxwW4az83WYB5UxJARlEOXe64voFtj?=
 =?us-ascii?Q?PIdGgkw8Um//ad3w+d9BzCOSmTA6RY5zAH8GqdvmLUXQA/mzAnZxHOqYeb4z?=
 =?us-ascii?Q?2OExWsjtTBhMBNYM2lBitKJv3uOxMuTk6+SBI5+JoKkUTFwZW60DQclJYN0o?=
 =?us-ascii?Q?idX1wpQ47Y6cGmo2KQ5ldnToIOGvsVbq2Fn0tAI51ebz8yKp4AfTAJjcbdO6?=
 =?us-ascii?Q?8HVI8DH6yUCCkr2S5SoR3vABEOhxDjCRpxAsA4zp/HAAr4UvbCbOVRtGWkQc?=
 =?us-ascii?Q?D1ytw1RXXz/8SHug4svxWWuXUmP/nQ/lylR2FAF6xfylN1MSWucBvVUxSkRG?=
 =?us-ascii?Q?zcXeuGwSLFl5pEvW6FZY6/NeKDj2kwzC9ROrIiiMLo39+k3Ogrvl2Lldxa81?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa05c9c8-a236-4fec-fa86-08dd7371f44d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2025 12:12:22.5620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4HOGKkRgq1HLGjMbFtRtv31+td2+Aq16d7T5i9rPQwDYqUpUVtOGw20EL4YCuBTNuBEocI9gT2DeVE0p4coXp1HCRiBac9L/pJV/kA13Ts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9081
X-OriginatorOrg: intel.com

Hi Herbert,

On Wed, Apr 02, 2025 at 10:58:13AM +0800, Herbert Xu wrote:
> On Wed, Mar 26, 2025 at 03:59:45PM +0000, Giovanni Cabiddu wrote:
> > This series of patches addresses the warm reboot problem that affects
> > all QAT devices. When a reset is performed using kexec, QAT devices
> > fail to recover due to improper shutdown.
> 
> Thanks for the quick fixes Giovanni!
> 
> As this is not a new regression, I think they should go through
> the usual release cycle.

Sure, that's fine.

> Just one comment on a possible improvement though, while it's good
> to shut down the device properly, the initialisation side should
> also do as much as is possible to reset a device that is in an
> unknown state.

> 
> This is because the previous kernel might have had a hard crash,
> in which case there is no chance for the correct shutdown sequence
> to be carried out.
> 
> Of course it's not always physically possible to reset something
> that is in an unknown state, but we should design the driver to be
> as resilient as possible.

Thanks for the feedback.

I considered adding a reset in the probe, but it would slow down the
load time for each user.

One option might be to attempt to bring up the device, and if that fails,
reset the device and retry the startup process.
We can look into that.

Regards,

-- 
Giovanni
