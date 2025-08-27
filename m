Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCB01DB12E;
	Wed, 27 Aug 2025 13:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756302016; cv=fail; b=qCY4oNfpUoVNx82PdvWsVLi6mV+vHXBe5xeGkXMt88RR9Wgi0mvBptVIlkb0e2nkWNXeGub7HFaofwfAOZzMGYW/qVB8pr4Fj+lsN5161W1KUskjeMQ3Qbpk0hToh0fhgqZZuSUEiy4+1mIpxNQisanGSP+zJ3NpXbKOGqQAsJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756302016; c=relaxed/simple;
	bh=tiGLInEquz0CvCFAOqCe/xVoBdNtOr+KiHK8uxpx/1o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pfliGO3+YSWKfz+kQYQcy++giEByGua/893PYlw4nkpBRS5Me+Ey8eEP3der7LGGkQsP9Oqm7AmJYGnnMN0QdKzNh7BU7qdJGBD/pxOPUuRgGO+JVwSraaFjIPNMQbwqfZRkTbAAx3cE1LJCrx4nfqR3EoN9VWebUQdATOXuFQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CfEKRWJQ; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CfEKRWJQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756302012; x=1787838012;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tiGLInEquz0CvCFAOqCe/xVoBdNtOr+KiHK8uxpx/1o=;
  b=CfEKRWJQkIz5jwpRLsdHdZnYjrXCxtj30SQN1Aglx1jrVHIakl7R42kv
   tSOHf4bU5aH/DnxwX8sZxjPDZk+G6jMPvAH3lZYzkafYxZICd1Vp1Mnha
   lhmW5HaC8/KZNKHszkJzV7NcaX5mJKeVhf0qrmb+Bkj//eIWXdwZXk9FM
   QSNxjPvfGeoejgUmkBghUZoHR9mK/cORfKxUkJ8NI6c5gdsZowTfk+vEy
   rAcZEcSOg7zFk+m4qH+Z9DYT0VSarP8uAhXAADueLaY3Tt7/9nVRRcqln
   SA6MgxvOfihvvKf8/g2RWY4MrPNFxgzd1MAbj2rBJFcyB8JyaKi9O3qI/
   w==;
X-CSE-ConnectionGUID: qsHJSHP9SviI6hQRZpVFJg==
X-CSE-MsgGUID: bz1DKpTHTJ2MQjK2K1KqJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="58614707"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="58614707"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 06:40:11 -0700
X-CSE-ConnectionGUID: LMwn3dLoTAqc9uBxyYQ8TQ==
X-CSE-MsgGUID: AFr6odMyQmOChbZHgGjsVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="174008030"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 06:40:12 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 06:40:10 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 06:40:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.58)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 06:40:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bnlaPcDrUApfeY95nDP0xxDBKtj2JmiiSkf21h2moYvKuwMcANkIHOhp+NDZGu84VHAwSr+YFgb2H2DSsKcALg7/U/iaqfG/bTFo+g+uZX2zhW1nCmD08fvp3qREUjO4C5V0pup4+ZH+Ojjtorih8pbxNVDyztSdsjJAwmw39us+drgeJbLwcDhqiqYaXhZWbUOVKB67XfOkUEXsqwoZ0MY2lA36hTiUPEch433BwjkvWJQaBNpXamki8AsjAJexCn4M3mNvRk7mLvu10n0GU7G1puyZL5qLTd6SY2wXgrZfVLIuar3V3ofI/pym4vow4LlZrqTI3U8M1oDSj6iJtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60FUDmj2nUSm9KWGnTV03rf1VJl8dwW3K6sZuRcsvKY=;
 b=fDwdiF9CaEhJrN/xCgVJpY3IMh5zlccdyeCmyOYVD1ZXXXCLZVJUl2+QlWIWLtD1LIj/IATnOK4M3leKmlFmFEDR7BI1Wyfp5FJKuohreBPXSkSRNrzvCBoK4KihYG9trsmxlocAgsSTZfa3PPhKQyCgUsOgkkOjXj1HzC3tywr9BJcfnuavUVrJE4xjGxnHXYnlDywpWQUHsz8Cd9FHYeTBQX3UrtH1QpFf2qcVn4lpMs5jW0X06hMbxGRuhz7gsigUti8rdd3U55DQ6sn5tAKvOu92tpYo/dBKUF0I+h57YmE4XVHQOr8eoFizU+aP7tYqDmVM3Trr9ZcqLKXnKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by PH7PR11MB5819.namprd11.prod.outlook.com (2603:10b6:510:13b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Wed, 27 Aug
 2025 13:40:08 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 13:40:08 +0000
Date: Wed, 27 Aug 2025 14:40:00 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Qianfeng Rong <rongqianfeng@vivo.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jack Xu <jack.xu@intel.com>, Suman Kumar Chakraborty
	<suman.kumar.chakraborty@intel.com>, Colin Ian King <colin.i.king@gmail.com>,
	<qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] crypto: qat - use kcalloc() in
 qat_uclo_map_objs_from_mof()
Message-ID: <aK8KsPlsSyB3lXqV@gcabiddu-mobl.ger.corp.intel.com>
References: <20250821142028.33256-1-rongqianfeng@vivo.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250821142028.33256-1-rongqianfeng@vivo.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB7PR05CA0025.eurprd05.prod.outlook.com
 (2603:10a6:10:36::38) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|PH7PR11MB5819:EE_
X-MS-Office365-Filtering-Correlation-Id: 300ae72a-5564-46ea-c800-08dde56f3cd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/2jKtyQ1pGmZdG7xsga8Ih8+5WZ3Bf35VifhV+qsYfHLp7BGTPbOl1+abN/J?=
 =?us-ascii?Q?qpI2Oz2rnSgxPbZTcr/NftTMXK1wzGsZxI8JIQWuFGDV+s3C9DOQKS+XJgj7?=
 =?us-ascii?Q?GZ1RJPzqTe2gXihVNB5jk4KyB2axa4UNkUHKMcE1vxBEa4nwwxseV4TT1gpF?=
 =?us-ascii?Q?vzZ/CMNvALUa6YOFPeATQXKs2+/c3iuBbz0dOMbd8RcEwZQEHpeiHNPNy42f?=
 =?us-ascii?Q?AynJ1YjHtnPvgJ91X+o/l23gTJ7Oetp4In73YlP5xRsEsdEnVLV5njERjEKR?=
 =?us-ascii?Q?0GMpFH+UXBq7irpqfixqFFc1IXlRYHf9OI3eePAGd1WZEwYWY426bZpILt9U?=
 =?us-ascii?Q?dUi/hGopBikQlS5I+KIbc1UTiuKweBjZwm+/L+4PnsONC2c+HO2eWo66fkBZ?=
 =?us-ascii?Q?vma9cBDW4KIKbqfvm8p0OEHp69/Ji+34LpefiAgOpEf0lXEo9iWuVUPKQISu?=
 =?us-ascii?Q?Y2QvP8RlVBL+cfwO/o78Lwz8zXrF9Vhmge4na+PlzPJ2fi11q2+3M9dklmzM?=
 =?us-ascii?Q?MgiIHP7ciJLRFT8iLGPRy56Wj5unoBx9KcyEfcEQ04nO4QJOXqTDOqnGoIxJ?=
 =?us-ascii?Q?YymGKbyhZJ/7Xz8fxDWtFJrf6Kk8rNfXF0REGc9uIvpS5MClI81Q6vdhs2Hd?=
 =?us-ascii?Q?k6RrxOYt4B6bq27r+ocv3hMrnJV8CJXZTCgJjFB0q8tXQuTSb8YRT34r77Yc?=
 =?us-ascii?Q?lXUgvEwp+IaQ9zpcaDAPqX4IPl4SnGDJOAdm+4BxboyG9afSMUQajwtkimzt?=
 =?us-ascii?Q?l2aYBEVcP5fQfdLtYJiVqlvZ74GYZmZjHTUwVpyUyxTdsyJwSlO5cuz5V0gf?=
 =?us-ascii?Q?BlsAoddCXKabFx5C1uQ9SnUlQBbKjwSIlvVv5i8kMnDFnIxUpxAgZUJK7i1m?=
 =?us-ascii?Q?QeLQpItDCd7Wqy0U6yRExF28a0ayQqUb6q55067bA32s/svkIxHfpc/WaO0b?=
 =?us-ascii?Q?FxP3CbJENB1bkzpQhg2GZRvhazjp0TtJVVODT5aD385xpLSJKH1qNpK3FqKH?=
 =?us-ascii?Q?b5Ued2417wRy6UM4azRfmYguJa/mD3dPeJ7krWU+3a5eoyO6nfbFr52AwKrk?=
 =?us-ascii?Q?12HTblQrQgQltJNUqXatcwAUxF698QaoJlth6qDtM97z5AJKRv8onuvDEoXR?=
 =?us-ascii?Q?ey2LjL2oI02SiyxDy2YZ1U1Jq8nIS+TLWP6l0vrHkW3/aSv7XEjlyZGfWPln?=
 =?us-ascii?Q?DyzY+VKApGztMoKN+vom0u9K05blI3KsiZzw93ehtr7ltBGYwsDLRdm9yaJC?=
 =?us-ascii?Q?yvJ+FsTjOQ2wOpBm4f20iOZk22yKii/tUPqPxemPwCb6VyFdoGn9k4mBHysV?=
 =?us-ascii?Q?/XFlfX2L2XbZjKfCmLYcX1krFi4THjl5V9dbtES0rgnL2iiGzyoeayZ1IYC0?=
 =?us-ascii?Q?PbZAy7/GTllF7IvWHISsIyTExLsskG4qHgWGiZGebxH7aJ7eByFQxp8Sustw?=
 =?us-ascii?Q?yMe0aBkP7KM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tr1bJNErGLYFgTLQT1gllFUiSDsBjv4AqlB9KmSbbAl8NCoF0JRjH7gCflp7?=
 =?us-ascii?Q?rLRpPWspadP5V9cmTjCFyslP6YnJTqDeg+o2Lch07nBnGR+PVbcObSzn7SBt?=
 =?us-ascii?Q?rJqaKxgUMqulc809zxQZd4OtHlb8BRpGXG7pAi5SU/70QqJNXVuPnFChNw4l?=
 =?us-ascii?Q?c2CoZOxHOQYj8C2gKoQ7u1S1xRBqbm/9aMMGWH1nGSIhhWAnpFl2MgmKKk9c?=
 =?us-ascii?Q?jVq7fKGmOMh0FAX6nLJEc3qJRkzPzPXIhDhXd9D0r4uF370j8jYFctlVjwAu?=
 =?us-ascii?Q?vtx7hDo/Vd1zo2dtOl8fsKkq3FiNqzkhrF4to1kf0uWONIDppIlP6S19iREv?=
 =?us-ascii?Q?mFjHYL22tN9n6m2LeJFeL0N0aUJGvTaO/PaqHvEBNYJI/nrGSp4Nw9y4sZoP?=
 =?us-ascii?Q?chL1YXe/x17oBODRE5ZhaFHJVkmZJHpwI1Aza6HXggOvonU7TLFap213IhoC?=
 =?us-ascii?Q?4cEr4F9HQOndodYF+53aDLACCInuLKKkLYwYD+yBSzJrvB/h2jpT6OOBybsS?=
 =?us-ascii?Q?gEqT2s8hcDb1aPwoQ8+3TmvyNIscOFLaAoiCev3tm+bnQLQ9UWvQA7QM20ia?=
 =?us-ascii?Q?BxIA8NpbKykzXzC4/7w2zqKIc5KsWPBCukB7RZc/v7isOhCexkFNC0n3SGB1?=
 =?us-ascii?Q?KCk7cdm38o7mzL9Dsp77cgSJ+WaM71h2yNhoOKDPEZjuS7l5TC81lBqnfp+F?=
 =?us-ascii?Q?LNwqmO1TLBICn45XAfqWkHGuAI9P5O3/K/Ho2hv2FcC658jI6fNn1HCHZazC?=
 =?us-ascii?Q?d+xbpe8s+vvrrcZDCNu+U6qdVGsrjEPZKQcGeLZE58w58KAkK98EqDA8aTws?=
 =?us-ascii?Q?PzHS5/gd8zq5JF+1BN/pf+e7LFz9+FQsTgjkWQPorWNEZXzRJqXEsSNa1yl4?=
 =?us-ascii?Q?R0x7zVqwB+zfCLyOmasqSanIxUgMSHlAepAyBbqncH6PJkj/4nDI4J5lD7VW?=
 =?us-ascii?Q?42xJqjcN3ch3C5oH0otbwSCmZcQD6+8jhgX+elM93v/sz8vn/OAe/mzClBrP?=
 =?us-ascii?Q?Ex/xg3GnFcG79YjyNcC6cS/tXdLQMHBxdsjD62wZG3TX4oWGwUnF8WXDW0Z2?=
 =?us-ascii?Q?hFeUYyX3cQE4zty+BX95xV9351dOwBm8FmqUDqy/4GfY8mrbDnTAWYti5JWX?=
 =?us-ascii?Q?PnImlWEae4vERjO3Y6IVqir0p1crsxKSjHN8KRf5EcGp4ofi1L8y0bxIsDEO?=
 =?us-ascii?Q?BPHmB6eGlC2trJo02BAM2ugUMQFs/HprCSGyI4TMOpT/Puu0hvPOn2CtU1Q9?=
 =?us-ascii?Q?lsiQN6WkwGFH4gQME+4t4fr8NQbow1vcojmmfk5lckCIWOulOhtrUBF7rL9F?=
 =?us-ascii?Q?CKqLgSzYE2KO+UaZG5Zzyx9jvUpkCZEEjheCh9rJY8O7nlCdcznSTEl+CZ84?=
 =?us-ascii?Q?J+//+8a9x8+PcSjfpKeYDTf7+TrI7tcsVtHcWqebUrvdKEk6O1WXqUBPD+Y+?=
 =?us-ascii?Q?gKw4uILTRpsEHPevoUoMGIj9VDj6kRkgY8bKw1b4E9DlQr4SuNaBFRsA5Q2O?=
 =?us-ascii?Q?/MMuySCoG/VQn9MLDN4ynNDBvol/D9RtJqwTzeeUH88cu40xU0vCZejG7oMj?=
 =?us-ascii?Q?+Hp3iLg5FRSO11eUtQsYfovWgCvSOc+Wiji1jKxCyLJStZgAUNduH6o13IRl?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 300ae72a-5564-46ea-c800-08dde56f3cd1
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 13:40:08.3056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zWXzzTpQftLpLwvavS+X/iP3eq/UdiZTLCCSrk3iN50z9meSFG4iUNt/RBIBxGclLEuqr6w3sqji5q7ri9R+dcHmuEFbiGr6kqPWd8F25lw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5819
X-OriginatorOrg: intel.com

On Thu, Aug 21, 2025 at 10:20:26PM +0800, Qianfeng Rong wrote:
> As noted in the kernel documentation [1], open-coded multiplication in
> allocator arguments is discouraged because it can lead to integer overflow.
> 
> Use kcalloc() to gain built-in overflow protection, making memory
> allocation safer when calculating allocation size compared to explicit
> multiplication.  Similarly, use size_add() instead of explicit addition
> for 'uobj_chunk_num + sobj_chunk_num'.
> 
> Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments #1
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Regards,

-- 
Giovanni
