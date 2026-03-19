Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95FF35AC35;
	Thu, 19 Mar 2026 22:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773960239; cv=fail; b=BSQ/SbrX0QEBuV/W0Wn9sbcteL2hZsK1dIJkot8MCu2cAvC4R0/feFT15cqpnGG40wzsusdPR/xpEeH88Nr6kt8MBet9+ZZPNqNR6mzX5xoIRt1Lfie2mBwqnIanRnnFBQvIp7VMCOPcxUihXcfkO/PtaOtQ63eSFswI+Ryd86g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773960239; c=relaxed/simple;
	bh=0r2+/XxZ8S3fvFdHJeNisoZFYJMMAq7VkoMLFb4ZTM0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dGmA2S9tuf74Xqp5ks4FMA/gv6a58cDraWGcAaL58doq4h1yPk9r2T/IqDNwmiPjpiMz19brzzOUJeQ//GfNziaCgyKLCWJPPtjoHGsHGLAx8Ahvr2SiqRO64UtIEPhS0QXcddzedWn0kgF1XyaVbILhXYc0lP2G5XmazXNRaPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UYKK9Jql; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UYKK9Jql"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773960237; x=1805496237;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0r2+/XxZ8S3fvFdHJeNisoZFYJMMAq7VkoMLFb4ZTM0=;
  b=UYKK9JqlX6fTK6tRho2bS6x5I/GasWK6pucYsdrtxCZsH71PNMXeL6d7
   TLI3x505LfchUCiZC96bMTZSWUxrgXvsSGeKgX417uLzZhzzqdFVi+tCl
   vJX8fLK51DNHygR/b49bE9a/csPeTZYA0/5Svb8B2qwJNncPoPHosvsb4
   RZ7oqvyXMOTAqXISJpdEjIYRBEtabmagLZvCoTYTd5Ribfs5KQeI3xzBB
   dgBn/nRgyb9ynRJqrRxzQV7bNppImawGWLhTcC7DCfP4JQfpnZJSUGFan
   3yz5ZtZq7n2VM+ZYfzR2oMWJDP+nEmrKJ+TeRixWTbJXJak6ibB6gpjgt
   g==;
X-CSE-ConnectionGUID: jXSQYt01Ta2/NRoiN8lJlw==
X-CSE-MsgGUID: abHvIM+iSqeYUg1x+IWRJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11734"; a="74932339"
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="74932339"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 15:43:57 -0700
X-CSE-ConnectionGUID: 9smSN6sXRYKRvMZ667I4Tw==
X-CSE-MsgGUID: zIejGQWrSiud2xWukFYr2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="220049689"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 15:43:57 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 19 Mar 2026 15:43:56 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 19 Mar 2026 15:43:56 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.28) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 19 Mar 2026 15:43:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NIdTW2FNcQ2Lw2pgzMUiJhiRAugmG/kgcT+ufxzfjh1joNu8pNX+Apubp9F+6uMLJzRfvdHz8a7u650Sduok/nzq5/PgQyZuE/ugLtRIO2y6RyBDe0WXwiaG7MOmhMEv+lAkP5AkQAdrEWll/Sp0AbvzxbaFeNvbQKbzklKsSKA+79ACRmhjiqg2Q9M1A+3CcVZkuWLg+ph1u7E7O67nocoJfNnffrVJIQUCBRWsqTUMkC3B2lkNBL1NhXaZczkVLbaMbM0B93Vpcbp1PoopPcbd2SUdf2L9zQV4wt/K9G6QQBbi6vQ96EV8MOQ6HfnVnNY0B0Cg2SXFnmXYx57dgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8aPngyKMpLoEsW0HnlIgavW2E6IyenaECABkdZfjs0=;
 b=hH2vpLgO8HmDciT3+9KRaLbZK1vM/S3gxLyS8LA8lZl2Dwmf6+BcGJ8KVgo2TJFvMx6xOvx7YrAA81djVqHnxwz3vMa13oo94P/B9AX3VIbHr+7FQIoNnHH39YmugmSpEU12y2v6sju9VpqtZwoAoeyd0aWt5un8SmSEjtm4JFD9Zq3b+36F2OYI2D3spG0TS3bYAhvqBgxBy23/w5mdkEUwcLwIGlQoEOboO9bKDv79bLNtpzXJRoXti7PeMpjv+dbgyflCRVRRzl3UlbE+C4Bgq2zhNdJrGh9AnPkcq6FIfddzejiUvo+/+Qz5UZQtIp71xWDwYU9rtrVUbPvgCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6407.namprd11.prod.outlook.com (2603:10b6:8:b4::11) by
 SA3PR11MB7655.namprd11.prod.outlook.com (2603:10b6:806:307::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.9; Thu, 19 Mar 2026 22:43:52 +0000
Received: from DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4]) by DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4%6]) with mapi id 15.20.9745.007; Thu, 19 Mar 2026
 22:43:52 +0000
Date: Thu, 19 Mar 2026 22:43:44 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Wesley Atwell <atwellwea@gmail.com>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <terrelln@fb.com>,
	<dsterba@suse.com>, <suman.kumar.chakraborty@intel.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: zstd - fix segmented acomp streaming paths
Message-ID: <abx7522F7DLyBauU@gcabiddu-mobl.ger.corp.intel.com>
References: <20260309082051.2087363-1-atwellwea@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260309082051.2087363-1-atwellwea@gmail.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2PR04CA0188.eurprd04.prod.outlook.com
 (2603:10a6:10:28d::13) To DM4PR11MB6407.namprd11.prod.outlook.com
 (2603:10b6:8:b4::11)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6407:EE_|SA3PR11MB7655:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d718b10-e223-4422-a32e-08de8608fe9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|22082099003|56012099003|7053199007;
X-Microsoft-Antispam-Message-Info: Q2UPtb9PE8HfZnC7ZXF5zPhmJWZcgxLW61tH8jotO2zo927QDFz9P9IkdoKtEVphGmiKtYZJN6uDckiDNSAQjxR0LyjvX6qJ2T2jsL/EjKSbGFcuht9efV6dN6Kwc5SZonE4/NpnRoZ9eOxMC1xSJOLYIKM6ewsygfLkHPbdgv4jkyzNpBMVzmi9YyniD99UvLtnN1Fk/LZZAcaX4fQMBcurcSAiR8ojvAuMzyu//aYIMJqizrx5Ejjo9yelgr/7FM9503XKnj8X+stAhn6VuX+UeBvBib9Ky3kj1rmAAWQ8Lt8nNXSAgmh7kiLWZIoNKwxC19Qh63UZv9wnqmPd6Xt1g/22E6U5ogPLmY301oQ098ntiaNlVfc4hsxlQo37V5gcQgz/EjZLCVoO55uIRRJ9w3dJLemzRbVwdW+SUauln+zd/mOC9Jhhe9gZWuEgHC3YyQfw+NjT0U79DhOPsFZejkyf6Faug4HvuOWZYXyYtt9h2bcclJ+SisNV1Yuz7cRH3/zA0nEVIzzk5CbXAqUafiuxpHop020n1QZ1ge3IDFzMLEELKBzIsrGB09CGC3yZChmwAbhsBeOlX8S64WnzCSidaUIGxI9tZ8Ny2JljzMZlfZ1qcc6phGYDBLPITEpv6W21C3XOJMWc5I4Mhiz2SG7ts4RLG6Dte0ceJiiLIqnv+okluaEahsJz9B9WeUwLhLWw9fhtbn7oKwUsrQSubyxrMouRCJ7CQS6t3OI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6407.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pAttFtQDSVmb4qmcZGxZ5UI4eAipk5IHbUbbxyeogHQ2gmuW8cF2LpTKQm0+?=
 =?us-ascii?Q?Zzt0FswyPp9rShGAC7vGtkF4PaR4HgXC5q4FeJZYeDTiSzrKejRnYcB1cZql?=
 =?us-ascii?Q?3oXkfGXQwTNe1+xBsfgBXcDx+WoXPiGzdSeVLwcuxj6xmSaDVud6Yt5Mq1gE?=
 =?us-ascii?Q?7KK8AtH1vTPRxPBKH64Xti6NIafDFtYtyeGGUh4gcXq+4UU9Fa23w6UtNTmU?=
 =?us-ascii?Q?rhr+brIBRJe27/C232EXTWsXeSzCoChSc8k882yvDpIzW219cpB64xhAKzkR?=
 =?us-ascii?Q?DFZWGHpY6ETJJP2GARxHNTifVZmzN6yOcYjF71AfASVomiFZUj7g9l8cehus?=
 =?us-ascii?Q?GFEaC4OULuw6bIYJIWrl8aT6hyO9d8TYNXgAXM5BOnd6PkHR2AGQwKusRRA9?=
 =?us-ascii?Q?cX71H6lkmGsqI9QcVD896ivV8z1HK5ueHvquV+MrDyH+KVm7Vw2P6RTn4iJZ?=
 =?us-ascii?Q?wqXTPfC6ei7hU6v4/friaAzD+dxjgDLCGAgRgtm7bzVQShvy35Lk8iEFiWe4?=
 =?us-ascii?Q?uTvc0cGtjGhDw59RgR98rKmOYYKLxznt3Rbm7Fqy9tfrPB5Vjk8Qaf2eXxhJ?=
 =?us-ascii?Q?rWDZkzBEz0I19tmZwbBNU7DO7YZ0qaEuPDasQGcJfrwMj3a2OVdrAbj7FqVM?=
 =?us-ascii?Q?wuHo3aotaP27O/FUap1SDrxuTofhQgiFibYVQ+WFWPFR+cyTXhqW2i7Wr5xq?=
 =?us-ascii?Q?ybjBY8gwUTJKQ+ByXvFAshdu0N+mNHJtKkuZc99zLv6u1L6q+Iqkh8dhzqrv?=
 =?us-ascii?Q?STV4QgwY3hMBL17SM252uJ+p+k5t1ZnYd446Ww7pLNnrSDfcFuSMckkfk7ju?=
 =?us-ascii?Q?swkCTdE2yHjVOHlikGjH5PDcafL2oQ/l09mGhxgQ/GT9Yq+RgGTo9YOvGUgv?=
 =?us-ascii?Q?2ZdDpPpCy2BODi3e0z7SxDPlvpSTyyweRJpnk0wYGdmR1Rcm4G772ooJxg6D?=
 =?us-ascii?Q?rIBwm6zWKuLqoXlHmkPP1i8WU85PUaS/ElD29pId5T/L8kBgwSl1+E1bHuWr?=
 =?us-ascii?Q?qAiE7fPZ/xmzXaXAEMrfZyBNDFDpZI5YPyd2Kq3vqA2GmoRE0YtXkyahHRjN?=
 =?us-ascii?Q?j+83RSiPQ05wDH0Zr6NAZyE9bdKQiYwbyArttRh/Osr8lO9OD8ooSSVA4Ta/?=
 =?us-ascii?Q?/A8u4+LKZqqr5+qyWyq1J/Hx3x+xwQR9ELFzQacSwSBTEQeyFGCwcJkxruHz?=
 =?us-ascii?Q?BRvoS3H7OdbKu5IlkTll6DT/Xz3szHjk24+thOKfEOA9q2XvO3kcMgp6IvRz?=
 =?us-ascii?Q?Kyf3GNytbERvHdQLZDifAILBb6VCcyZumhBfVXoSRJJvOJQgU2zMANK29VR7?=
 =?us-ascii?Q?shi8CU73OG3TzxefQjVW67jywfe1GI1rzTnCZBuk93/M6I4mk2yfwIxsNmy7?=
 =?us-ascii?Q?8SLCrqFX5CSdOAGmdk8Fn2k2HFtgwg5CAXVNLVc1dsns9kzAE/U8akctgKTC?=
 =?us-ascii?Q?tli0vlV8MN+a3TZXYL/q9q2hyVFHrEt1J1pipcfpgT7eqUHARR9Yj+dJGZJq?=
 =?us-ascii?Q?rkobTQdUaj7FrtJby8yJrjTdDs14gusoya0X9zsp2CbMwKJoqiud8txU29XB?=
 =?us-ascii?Q?qn0Ui33TXLQkz4fL1Yieh7SvE1yJcG5XHem7/AgeTJmIPL+Ym4TiH30i8LJJ?=
 =?us-ascii?Q?Ey6kPxqv41dQcNhYDKl76nn+W2KrRsZXk94edjD9GL+qgvUilb8CNH19gHh/?=
 =?us-ascii?Q?1tsyY4f1/g0E348O+utFMXHpqAEDMpBtR2o82M6HddRkSAs/gShIBPYnZ/hC?=
 =?us-ascii?Q?7IQcVA3zilmNDr/y2/wThYlC1G3m5H0=3D?=
X-Exchange-RoutingPolicyChecked: FBMddUqRiYzTwRCEaAka2pBqsoWDNC3jm1d5SSYVZKlDaplR9SuvUJWRK69nDKcIFQ7WiPcYifMpvmGbK7ByyXofenO2PuhKVoU5/K7tjAfBDhRfTzcBYYVOrZqLmuvhbG3NQBn8dA9FfEzrWXTJnmevB7PvYWH8eUkU4rJFQNRZtunU6L+52qL7SPXbYBiDYOhqgu5tF1p9Wvu2UwN+mY3nkWagjW8sRG3fN8Xgh4zlHz2VRsPpFlX9/pl2DGlzTdt4lnibNaESfV1TLCLRqSJ82Mqxth+sAPjtV/QMj379pz0/MskrfgDpmk/FuvR9x6HOlRaKHF8akbG8YTIuMQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d718b10-e223-4422-a32e-08de8608fe9c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6407.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 22:43:52.3879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tLKVpJWS0UDtydDxxJ9mmeIo518qGKIM90iH236CQeOavbfJ1BaDLY9lkony8OVJMqt7j+zQvNS86XSDrJGMZuGBhWxpMCWLnsrQbnXhw3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7655
X-OriginatorOrg: intel.com

On Mon, Mar 09, 2026 at 02:20:51AM -0600, Wesley Atwell wrote:
> The zstd acomp implementation does not correctly handle segmented
> source and destination walks.
> 
> The compression path advances the destination walk by the full
> segment length rather than the bytes actually produced, and it only
> calls zstd_end_stream() once even though the streaming API requires it
> to be called until it returns 0.  With segmented destinations this can
> leave buffered output behind and misaccount the walk progress.
> 
> The decompression path has the same destination accounting issue, and
> it stops when the source walk is exhausted even if
> zstd_decompress_stream() has not yet reported that the frame is fully
> decoded and flushed.  That can report success too early for segmented
> requests and incomplete frames.
> 
> Fix both streaming paths by advancing destination segments by actual
> output bytes, refilling destination segments as needed, draining
> zstd_end_stream() until completion, and continuing to flush buffered
> decompression output after the source walk is exhausted.  Return
> -EINVAL if decompression cannot finish once the input has been fully
> consumed.
> 
> Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
> Assisted-by: Codex:GPT-5
> Signed-off-by: Wesley Atwell <atwellwea@gmail.com>
> ---
> Local validation:
> - built bzImage with CONFIG_CRYPTO_SELFTESTS=y and CONFIG_CRYPTO_SELFTESTS_FULL=y
> - exercised segmented zstd acomp requests using temporary local testmgr scaffolding
> - booted under virtme and verified zstd-generic selftest passed in /proc/crypto
> 
>  crypto/zstd.c | 228 ++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 156 insertions(+), 72 deletions(-)
> 
> diff --git a/crypto/zstd.c b/crypto/zstd.c
> index 556f5d2bdd5f..3e19da1fed22 100644
> --- a/crypto/zstd.c
> +++ b/crypto/zstd.c
> @@ -94,18 +94,30 @@ static int zstd_compress_one(struct acomp_req *req, struct zstd_ctx *ctx,
>  	return 0;
>  }
>  
> +static int zstd_acomp_next_dst(struct acomp_walk *walk, zstd_out_buffer *outbuf)
> +{
> +	unsigned int dcur = acomp_walk_next_dst(walk);
> +
> +	if (!dcur)
> +		return -ENOSPC;
> +
> +	outbuf->pos = 0;
> +	outbuf->dst = walk->dst.virt.addr;
> +	outbuf->size = dcur;
> +
> +	return 0;
> +}
> +
>  static int zstd_compress(struct acomp_req *req)
>  {
>  	struct crypto_acomp_stream *s;
> -	unsigned int pos, scur, dcur;
> +	unsigned int scur;
>  	unsigned int total_out = 0;
> -	bool data_available = true;
>  	zstd_out_buffer outbuf;
>  	struct acomp_walk walk;
>  	zstd_in_buffer inbuf;
>  	struct zstd_ctx *ctx;
> -	size_t pending_bytes;
> -	size_t num_bytes;
> +	size_t remaining;
>  	int ret;
>  
>  	s = crypto_acomp_lock_stream_bh(&zstd_streams);
> @@ -115,66 +127,87 @@ static int zstd_compress(struct acomp_req *req)
>  	if (ret)
>  		goto out;
>  
> +	ret = zstd_acomp_next_dst(&walk, &outbuf);
> +	if (ret)
> +		goto out;
> +
>  	ctx->cctx = zstd_init_cstream(&ctx->params, 0, ctx->wksp, ctx->wksp_size);
>  	if (!ctx->cctx) {
>  		ret = -EINVAL;
>  		goto out;
>  	}
>  
> -	do {
> -		dcur = acomp_walk_next_dst(&walk);
> -		if (!dcur) {
> -			ret = -ENOSPC;
> +	for (;;) {
> +		scur = acomp_walk_next_src(&walk);
> +		if (outbuf.size == req->dlen && scur == req->slen) {
> +			ret = zstd_compress_one(req, ctx, walk.src.virt.addr,
> +						walk.dst.virt.addr, &total_out);
> +			if (!ret) {
> +				acomp_walk_done_src(&walk, scur);
> +				acomp_walk_done_dst(&walk, total_out);
These two functions should be called regardless of the return code of
zstd_compress_one() as they are unmapping the buffers.

...

> @@ -209,12 +242,12 @@ static int zstd_decompress(struct acomp_req *req)
>  {
>  	struct crypto_acomp_stream *s;
>  	unsigned int total_out = 0;
> -	unsigned int scur, dcur;
> +	unsigned int scur;
>  	zstd_out_buffer outbuf;
>  	struct acomp_walk walk;
>  	zstd_in_buffer inbuf;
>  	struct zstd_ctx *ctx;
> -	size_t pending_bytes;
> +	size_t remaining = 1;
>  	int ret;
>  
>  	s = crypto_acomp_lock_stream_bh(&zstd_streams);
> @@ -224,54 +257,105 @@ static int zstd_decompress(struct acomp_req *req)
>  	if (ret)
>  		goto out;
>  
> +	ret = zstd_acomp_next_dst(&walk, &outbuf);
> +	if (ret)
> +		goto out;
> +
>  	ctx->dctx = zstd_init_dstream(ZSTD_MAX_SIZE, ctx->wksp, ctx->wksp_size);
>  	if (!ctx->dctx) {
>  		ret = -EINVAL;
>  		goto out;
>  	}
>  
> -	do {
> +	for (;;) {
>  		scur = acomp_walk_next_src(&walk);
> -		if (scur) {
> -			inbuf.pos = 0;
> -			inbuf.size = scur;
> -			inbuf.src = walk.src.virt.addr;
> -		} else {
> -			break;
> +		if (outbuf.size == req->dlen && scur == req->slen) {
> +			ret = zstd_decompress_one(req, ctx, walk.src.virt.addr,
> +						  walk.dst.virt.addr, &total_out);
> +			if (!ret) {
> +				acomp_walk_done_src(&walk, scur);
> +				acomp_walk_done_dst(&walk, total_out);
> +			}
Same here.

Regards,

-- 
Giovanni
