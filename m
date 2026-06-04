Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2433FA5D2;
	Thu,  4 Jun 2026 21:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780607736; cv=fail; b=HZJOcCW9osY8790mPBFdEzpqri89jb9Gj/yflFV16jFYrpV13oH+RDfo6sddYxOXaIwQD2DYbuG3PhDRAjP+++PGqqDHP826eCPYbiVEvf6zi6LqlSZ1dDEPNjAsyOvMUCbNeSCXbx0yGP6mZNiGCo6WPXjZSdLuRZit2knNrfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780607736; c=relaxed/simple;
	bh=U3k8pR05R7xDIXdbeTDUE0iVTtBdWeehNOSu28a0Kb0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aHCR3T1AiPf69qyfZFmMtyrIVwINXl6/w8V15Sq8895j8Ss1J6GNSZI+4tHBXjXlJXW1WVkpVjkf+76Cy8UUAGW9/QkHS4r+kr5R/tGD3ngRUfStSZfuoyr1Io7jlZeqsZ1zs6+tniSXViOL9yqBhmdg9dut/lkHG3IHFZDECCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DAKOlnc0; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DAKOlnc0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780607735; x=1812143735;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=U3k8pR05R7xDIXdbeTDUE0iVTtBdWeehNOSu28a0Kb0=;
  b=DAKOlnc0eXXIbwQeFbCKF3M40bzrYFu+ticiiR+WjJ7cUg50ktOpoxe4
   KigUnA53USKLPa9rwub6Tt3vDUs7oNzgKMdN7J6iSlofW9QZ8YFoCg+7S
   1jPnLcRP2TvfSt9uL3+abmhrKgNddhXzGfjlcTSFxhQXzusHutnkWlL+d
   Fwwotb2Xm6aWeB76XXPtsT4T8PnoYZ9bBIeotjxc3gUXFyFEgwgiAdqrw
   fmO5YK1sJdk9Bbi8N9V06KmkkVAVv6sjkQL/xI5WNO9nOjymuCfhq5kWS
   cA2CqYfxCPpo7zut2EXCu9pm3MIGLhHTIJVG5K8DTsbTgznMbnyAUAkvA
   g==;
X-CSE-ConnectionGUID: erTGQcYrQ4m31LZI9wEaLQ==
X-CSE-MsgGUID: F8Zy72MdQbyZmhVpp+hhMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11807"; a="98863064"
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="98863064"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 14:15:34 -0700
X-CSE-ConnectionGUID: PSrwsqjAQfyEthgQJjM5Pw==
X-CSE-MsgGUID: 2sctxfCbQP2DY87xWcjKAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="243816738"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 14:15:35 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 14:15:34 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 4 Jun 2026 14:15:34 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.5) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 14:15:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fqHVQOOHAEO3VOZO1+v+usixqjzVdoW+OfdfOStpHisODv7c5Y7dOvHcA+bjFhI6SX2U1rqC3yjjjSc75dACDgHLDFJ/HCjJJwfjI3S+B9i24ZyLl4QqwMX15ZT/vMJdyjblCMp0dOuwIB/PvJPIGora/X0xXM6eeJHMpbMPLeO3rfNFDzm2IQ2ZiEjQjVxRm8CLGAtSlv+4k4ZC4KFpGj5UkeOfVDpQYruh0opPqnJyVM5BJcIDXQu+3TzgiJZNsJ4v+WRs3LvnNxnwAksCEs+gqc2buwllXN4qEGTHcn/MevhEymnrhBKlGuUvdWtIqfRcmTK2RAHVH5tQnw9Tbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JuwRLSb3M6VXqdkJn07oyklN9Bzv4OIxz6YCs8z/8c=;
 b=CK0yTGHjmFCL9QC8WqBbvxbX3Sx+W4GBqutTceeiojx6qvVQ5s9tFd78EqYF7HrckFY2HnkI1vrR8sLLvIkjlsJPBpHR52G2qMkLPbMXGowDXhXA0Od0posAuKdFNp9eJha15UVFjjCJ+H7T+WfaqGtDq/JSELycagUNDskVXjBnfn+Cf24hqE3goWm86wKyRRflFG8ri3XcZwo99Nr8u1KManXpl7neVKRbcvo4oGMHsSzsqbYyrXhonmoppoOzCCjKIcX+paCuxTd5wk61rLJmY52vZsDpXEpksAmJzk8L69sy4WCdgAPS1/q6Cp2bNlsNeauNs41js5skkngeQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6407.namprd11.prod.outlook.com (2603:10b6:8:b4::11) by
 IA1PR11MB8247.namprd11.prod.outlook.com (2603:10b6:208:449::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Thu, 4 Jun 2026
 21:15:27 +0000
Received: from DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4]) by DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4%5]) with mapi id 15.21.0092.006; Thu, 4 Jun 2026
 21:15:26 +0000
Date: Thu, 4 Jun 2026 22:15:21 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Suman Kumar Chakraborty
	<suman.kumar.chakraborty@intel.com>, Karthikeyan Gopal
	<karthikeyan.gopal@intel.com>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - simplify adf_service_mask_to_string helper
Message-ID: <aiHq6ZMkZbH3ehQ+@gcabiddu-mobl.ger.corp.intel.com>
References: <20260527174655.1390543-3-thorsten.blum@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260527174655.1390543-3-thorsten.blum@linux.dev>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZP191CA0035.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:4f8::27) To DM4PR11MB6407.namprd11.prod.outlook.com
 (2603:10b6:8:b4::11)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6407:EE_|IA1PR11MB8247:EE_
X-MS-Office365-Filtering-Correlation-Id: 77170a98-ef2c-42ac-9ef3-08dec27e65ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: DfkgWPnaRnLAwH8z45N51+3m3vf8Neh1FArBaqsoeSNtp1jT/e6WPXBaDc/P73nG/gAsl7fxerOhqffD0zgOuW58SA1qVedz5zT4HsvkmopZ8FR2pyN6V3fZHNxY4V9/ebnvxzpZ7kDoNFx+4Ugxpp5bV+WkV6Yb5kC9tZarICD2D5EkUEJgwXeNBynzzft9tWvFLRvwolyJVZHSnFSI7FPAkh4sJEAXHWrpTYw34kNwAer3dICyiHn1oifO0wAJduCXOsWPJMBqcJKSTxweyJh0ltCwnqMoi/nGQx+wJcYFXWoTNv9CsR/GKpGOiFv5U7/b4MOApuVqxTcuRjcEKP9W+kyds2VIhLW/vQCv0A2YxaDi19+NL3srmi64jsxW2bHrqKZKoDcREDiIj7ZtHC3BDzMikndys3PlF17WLH7cRDD4WwDNW+4Rltsq4GP/VWTFIJHzG/VeC2L710qm8wcST/MmwZZy93nrtv7AyD3UK4glWx8pvRfsH9Ll0enyjNVpDG2YfGWIowPKa8VoKFeru70HEnSYvJKKp3YwlwPfqUWTRWO2kWKaInR3DI9V+Wc39aqcDWHN4w9A3iYMMVmtE9sX+4AKyW+IyEwPdPKoHocie4souF7iGtzmKw1Kih1TjM+a4vdyOoKacxUKdiy8ljnV0sGOQLoKRUTlw4PmIen31g0BUTe6zwO5auqj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6407.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dQPn6Y//eYfl20VKnasOk0mRIs6ktADXH5A3XKmDCjiFXNAFiuJ1bUQwzODS?=
 =?us-ascii?Q?BRYA9g+Wpxcg/1OUp+YCXNnKuEYcNELIwn8n4bbS7yfg7Usq+aBLsZCx4NuN?=
 =?us-ascii?Q?+M2aifWjuvIs5OXUrb3aLquRmRdysJ95liCS2E+mFrwwAWekXls/hNmSONQ8?=
 =?us-ascii?Q?tBBvAyMrVGuo1dzthT1tegxMnC/TN5z3NvnQnEsZ5IjkcamWX6TKHfHF9Zpy?=
 =?us-ascii?Q?DP84bk8GlyUt+z083IGj3QGA2dp9U/nWODlnqk/Zs/D/A4Mjns39dvkBR/7o?=
 =?us-ascii?Q?YpTJmh5cqcVqdxs7ptQUW71JVTnkbvFl2VR2jlVf7+d/BhIMDUvi6E88X7IL?=
 =?us-ascii?Q?+x6bg2mUWp5oRF1s6atABpFmBJHmhbGmW/ejOmS2bnEDzV7b7AZSadN5FOCG?=
 =?us-ascii?Q?teZqTrnucobjMiJhaaaQS9Bgki8NO6fOZcAjt+qGDJvAcz4jwVU2xAgRPfzv?=
 =?us-ascii?Q?pMvOSKZIv4JTQmrw/yd9MKiWxNw9cpoC8g05CEHZanTZ1W0OzaT6niG96D0t?=
 =?us-ascii?Q?J6IMYqU1M5MOUMGR57XYw8anXYi2LUGvzKLiUQyh4JHxoOPEUSEVyAu8HBKG?=
 =?us-ascii?Q?qFLA8gjVeaMmrT+kUV5mG9Hj6slhXTVWin73qmulqAHrBH8WRJW5tEY4eG4J?=
 =?us-ascii?Q?fsSpDkLMN084JiiYtzApkeDkXjy6CKAQoXaErM2cM8y75rX28X3817xStU2L?=
 =?us-ascii?Q?oT1o9sa/95YIvLZlXb3ZhO1du3YbbD4rWRl5jYrFGVff1ny3fNtDD+ftv/lD?=
 =?us-ascii?Q?S3+WUs0shsAwCcnUnmUZD4bl6UMAAhfO1eqC+m/FoseE7lS4OIyHyCGBn/21?=
 =?us-ascii?Q?W8Q6IzkWUw6Xf0GznuzH4w+/82hyJncVMFkm1/k8tyl4zbbaX6bQ0DUYAxjO?=
 =?us-ascii?Q?OitQIgtnamNbcU/EyHsU9tyhviHDiZQsp+kEifuIRMsKLlqi7WNi2YoyXHh5?=
 =?us-ascii?Q?yHHZDzNN/NgDjiNJvHm/2fCxdLOHzUN+biURVPN14szBwRqbokYSarl3Tkpp?=
 =?us-ascii?Q?tmNJPUKxomE38nNVq96toA7e2YszL5NF58bAmC1GBqUw41MLP9xn+jpTUyyk?=
 =?us-ascii?Q?QT48I1xaep+2wT87jLUV/aRPmqrhf1na80b1r1q1hEk1kepADrQwzPFBfiAh?=
 =?us-ascii?Q?4NH50FuScJ1B5q3seNcti/gLkGe0aS6FbolUErT2X1ZYd7riAgZO9E5zNuWW?=
 =?us-ascii?Q?oIf/cGO0liR6BiXOXxZ68GQpyVyzZ5EmR+LVEc6zn5m26xkdNugPYb7ez1se?=
 =?us-ascii?Q?16CnQKHVZ4c4Pr761EorobbMBw8tn35XZS0cS/QudmR7EIpTw2VBp1zXkZs5?=
 =?us-ascii?Q?nxuo+YQ+CEelIk9tvnDQYW/M1ks5mv2wc4kfXij5R3IiRd+kqRnW6tUGSzf6?=
 =?us-ascii?Q?yYoILHV5lLy5bu0qgmHbh3I9dOh0Pj6mJSh2hS8zAVguWOvFfQ6bjB3wZQFc?=
 =?us-ascii?Q?8FR8n3+8mRZUvjzPJW56t1ZPi7Dp0sDdVDm+vLuXvwtbtbDbI4fktBWwRJtV?=
 =?us-ascii?Q?B+j7Kj8ZOp1lSBlBwvqS1met+3R0RFHZdEF8P2wFBcKLywl0khx0jINtvWRN?=
 =?us-ascii?Q?pD3H/JVvtYQnXJ7KAhgwD+sO3J7mExQ0+gGqmUuiOXmkzXE9BGMUfrEc4Lxt?=
 =?us-ascii?Q?iYc2+wA4AQO4Ke1YyZrAJ41f/i9Chlg6zqg+ztPTcUQeiDKAIIZAOrQ4fmVB?=
 =?us-ascii?Q?seul1q2ckYs6J8rkM86mA3jD0ZYdZJ4Sl743g21GuiiUAmvj5gV6nznjrkA+?=
 =?us-ascii?Q?Y7T0GsBl7PhrehcsdWSlYbaGXTbGehE=3D?=
X-Exchange-RoutingPolicyChecked: WwMMsOJZX3IWhyjkeN6FYyjl5OnsZGT88W9Crdn8nzLOJGQNGmLhSg5ac5Y/Q4A1Yt0jTCSZaVW+FJwOF68KDXdERPVuIrlH9syOVL5oEufKxc9BlDweMv7FTRs2SA33tt8j5Nfmu3jVAYiTjsX9LbbS1kRff0Y0B2m96M/UuZQ1DiJSwfU9VCEv0AEQBviCEA1Ekv6Z7VqiJzG0NFoI5R8XcjyAQfWVwoydYCPjh/szFnFIr0UeJ40e4r8bRKeqe+0W/o8HC8J7Fx7QFkiJvFN788vQl1WFYG7+0GRyJq5oPItMST1iP1nlOI9r0ECgFypVOleFFTALWNItk8kUlg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 77170a98-ef2c-42ac-9ef3-08dec27e65ca
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6407.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2026 21:15:26.6787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e0bdiXhSAJdqr2creiTbLHmR8DC65uAm8GVJye3DfAfrA8xnFQImhGSuSYKtsqSsPvaMXZheYno4vosLjwbPpEF0ufDkySA7dTq2Ybvtn5g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8247
X-OriginatorOrg: intel.com

On Wed, May 27, 2026 at 07:46:55PM +0200, Thorsten Blum wrote:
> Use a single scnprintf() for each set bit and drop the offset in the
> else branch to simplify adf_service_mask_to_string().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

> ---
>  drivers/crypto/intel/qat/qat_common/adf_cfg_services.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
> index 21b21ac78e53..baf563c6f9b7 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
> @@ -93,10 +93,9 @@ static int adf_service_mask_to_string(unsigned long mask, char *buf, size_t len)
>  	for_each_set_bit(bit, &mask, SVC_COUNT) {
>  		if (offset)
>  			offset += scnprintf(buf + offset, len - offset,
> -					    ADF_SERVICES_DELIMITER);
> -
> -		offset += scnprintf(buf + offset, len - offset, "%s",
> -				    adf_cfg_services[bit]);
> +				ADF_SERVICES_DELIMITER "%s", adf_cfg_services[bit]);
> +		else
> +			offset += scnprintf(buf, len, "%s", adf_cfg_services[bit]);
>  	}
>  
>  	return 0;
