Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D0722A4CC;
	Sun, 16 Nov 2025 18:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763319194; cv=fail; b=H6CX0SILueA+1CwRsaXSv++vY9fvDkzZQ4ryhcQB7YhJfi1psDL33cfB2ssfpXvE2HAkwBV8eSQfDyWNLkIvQvD24WKFReVQLBS7tlLLC/1YhUnL5sx4iyaJLgCnKcwCNlZ6mY3Qt0YOFOCwAfV6nwcwffxspWcLtax8d7IWa/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763319194; c=relaxed/simple;
	bh=Lij+fS6QG1dpmPRly6h+PWgnoC3C0zWFFobSC9UWDRQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JJ3WI9HCP48elu/9SzueXKcp7aHJYI7HsR7SmI0q/FoQe2WHKHPSVeDurwGhqcNaHKHnARwnpx2lUV8c2InBqy/hlJDjrm6dTZvU1qM32aQLdUfOIr190YXKONuTqZqZeCk9KYP8BhHvo0X4wtaONzZEgPA2Y7IJvU5Em2pElJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gZDDT2M/; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gZDDT2M/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763319192; x=1794855192;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lij+fS6QG1dpmPRly6h+PWgnoC3C0zWFFobSC9UWDRQ=;
  b=gZDDT2M/SN0sDEAp+xFUSqP2kgRRe5qOJwVTji811vS9OO0VDwdNdcMy
   pAZ3kNX5uuuoU5EPUzvGxH+9hfTeiQEkBUtlLQXkkwrOlLu78h8HWsl5N
   k2b9PHj31Q5cyfvUo4C/0PzTK6tbpgv/mMXi5Sak9CqLMEHncyr3SrjIi
   STXFZ3nF+hRhu/fT9hi7kZsaBeRxQ50KhjItpoR3AQmbJU+DvZGz3bHhf
   mJhLq8lh6jGmzzEHsOdRBU3/iQN+FTH9OVbdOW450j4Z4JwW5JKUdBAcn
   QPOFugKpxZLTpESqS1ouEHGaRjfFIGFSq2GA8mFNUHEb/++HiTLsWAWvO
   w==;
X-CSE-ConnectionGUID: H1iCcjCjQ9yW/SftxaiOuA==
X-CSE-MsgGUID: vdq2yC+VQFiMuFVFfEZnHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="67935392"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="67935392"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 10:53:11 -0800
X-CSE-ConnectionGUID: cqWf2M0LTIGrsiyb8firdw==
X-CSE-MsgGUID: uksuy7tcTQeXvvr/SnYeuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="190289418"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 10:53:11 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 16 Nov 2025 10:53:10 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 16 Nov 2025 10:53:10 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.49) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 16 Nov 2025 10:53:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eCIFdV4IOj3D8ARzXXw7nG12fpadu0ioy/rIdsH+c5AoUAc3/ljGeS29eQU5ABqE5pNbbFtyWfUZWlgrCMfGphoqxHmNHxj6bLX0F3oZl8EZUiWi9vomogx3I/GAW1tPJ/kVJbXJ53PQSkz6/obbYXaSTAfhI868DSjrBRI4NwET36kjDFVX16NEPf3oCMH19RcF5UpoOj6LKOwOKQxfZxZJYAbgmBE5FMq7p01EH7Zqyuk5/BhPuv9gOhoUrQ9Ao7n3DzWGGshgXbq1IP9d54FNNc6prAq18KXs/5Yu60jURWJwVOWx+s+fNn3RN6oFbJY6+shod3aIX2HL3o5VUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N+MdNH40p1ALfdg2EkIi541KuoZStZz5ynisxqDGTtQ=;
 b=wiKipSfrM+X94mqgBVa+pJh8buBJ+q+NM9hJouw6wlyy0eQFbK9ztAq/5TGY/BijtF6BphqSNX4p9U6bctYj5lbqCmg7UztKMUhvlAKySBK5WRVl3wOsD/uKAQI2sSJnOvshsaQTROOcmTnSHRo5J/ztzPgDS7OQ/wnQyk0gNaHZH73PzHSw/Y0J9Im8jlcbusdDgNdwbEy8Dr0+54hVXNhKa5S2rl0ZKmpwUEdHEKt5lWrqj0aCHcpSkknkpgbAZx2rNdOmWNUq/gJUNhxIG8ZMv3yWS2Fq7C2WYW+1aMVDnAmIrt5VUdCUouwbft881NVPVN5gjS79jqkkx/Bp/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by PH7PR11MB6978.namprd11.prod.outlook.com (2603:10b6:510:206::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Sun, 16 Nov
 2025 18:53:08 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::1871:ff24:a49e:2bbb]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::1871:ff24:a49e:2bbb%4]) with mapi id 15.20.9320.018; Sun, 16 Nov 2025
 18:53:08 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "senozhatsky@chromium.org"
	<senozhatsky@chromium.org>, "sj@kernel.org" <sj@kernel.org>,
	"kasong@tencent.com" <kasong@tencent.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v13 13/22] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Thread-Topic: [PATCH v13 13/22] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Thread-Index: AQHcTWszo/WY4LO3fkO1jxkjgF2nErTx/98AgAO1Y2A=
Date: Sun, 16 Nov 2025 18:53:08 +0000
Message-ID: <SJ2PR11MB8472EB3D482C1455BD5A8EFFC9C8A@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-14-kanchana.p.sridhar@intel.com>
 <aRb9fGDUhgRASTmM@gondor.apana.org.au>
In-Reply-To: <aRb9fGDUhgRASTmM@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|PH7PR11MB6978:EE_
x-ms-office365-filtering-correlation-id: 399f3948-63a4-49e1-7744-08de25416233
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?ZoXwEFEGs3c5rbrX89P1/H0afTkLMHbs5VI8W5d3QcCMIzPXwzmKnpUK2H?=
 =?iso-8859-1?Q?6RJqwG9rPiFAZzqA2DTrZKodehgaeaWSTp71KWC+8fBwRUKmzn+9OlQx2v?=
 =?iso-8859-1?Q?KsE4W5m5kh2ATFTjNJesDK+dqNw/bCYQDsiRzFen7x7WMaL+8SAHcB4OzG?=
 =?iso-8859-1?Q?O7pi3gPfSp4uTGzDiTlO71oBZjOgoGOayWm/yj52cZJks/c85pztf+27Eu?=
 =?iso-8859-1?Q?xtvnNJgyHhMBKqEOpXqiI8FupqY3+PuUeprlGsdsW6Xksilwp6WtUwI/N5?=
 =?iso-8859-1?Q?+qKqJ9sP6rHF84apTG18NXVteHaig86zCoyg5y9AShiouHZatwg09Gb0V7?=
 =?iso-8859-1?Q?f0FtMNgY7csDaqZiot+MhaOLvjQnaTcSWxtmQKLA9ri0MbEEr6VuGw8jhk?=
 =?iso-8859-1?Q?/CtK/Qqgu4UdXaQoGAFuqTyS4jiG+TF+rqntJgdO1C8W0gGgZF8pVv4nBE?=
 =?iso-8859-1?Q?dBfUmsujCEILiXzas0u2QhejrMwGq2K2yMVTktos4Y6HVlgz0n/vRDd36R?=
 =?iso-8859-1?Q?/GW6b/Tv34hCMWOCdaiDbrcxev6dYJl42y2S3zh/YrlhFd0ypkEybIkcTX?=
 =?iso-8859-1?Q?2qmSzF/4zgg2gus8gQlZ1UIjPE97DkXytd9xI1i85Ey4FlS4IxLLK2mK06?=
 =?iso-8859-1?Q?n/VcDSj5D3twNK5mvI7P6fZ4Q7U3z/mnxubx7GRlQUF7J+ou3IEHYL3wGA?=
 =?iso-8859-1?Q?NmQnbpWiErpmeDoVUGJv93BA1KU6MvGBgGZQdKQKy/zqDk7pqUBRVtwBHL?=
 =?iso-8859-1?Q?/mUNfgWPDRgl/XI46AP5XLtuYyz6y084ojBhYTiTr9TlwKaGaLQXrnskqK?=
 =?iso-8859-1?Q?ors1/ma5WEAAstZKJjuEpmqYJguSwzUoRWEibbQ1nQjJL0IIvrgCRzpmSc?=
 =?iso-8859-1?Q?Cg9PQTBDAzRsW2Sd+LLIhwlDdAXgbL8IbnG4/WnBy4pwejvwkUkqutBEGX?=
 =?iso-8859-1?Q?WbCnpNE5ZvKdAfFdiKZkuN7LCP1BHGKmxURJ4mdzL1myPiIPyBQMxv3nek?=
 =?iso-8859-1?Q?Ie/NjRNIi6gxL04xhNaBA0IYYB6DD3AmLk7cmL7gUbjLLSoP25pP7PhJA8?=
 =?iso-8859-1?Q?oKG9ayJmktcaahEf6z1U0F3ItvjXeiBqc5/kdN2gItL0jIA/FDcRHCT99v?=
 =?iso-8859-1?Q?LKh+Wj2rWG2OkBu1kwPDrosV38vy44I/sGe9z8MtVBx6n9jzTCjxNFzSAn?=
 =?iso-8859-1?Q?JXmpUW6Zj/r43bboXAw2Yh23KmZmemYpCbpqhZLJ2zJCZIX4avAQqjZR32?=
 =?iso-8859-1?Q?d3lhTpRP9QoxX17NTlw/juAOS4TXN55UyfD4Ebdur52r/mPT9ezwHyp92T?=
 =?iso-8859-1?Q?sIq/3LzBEa94XSHruThswMYWFzMSNLtKOt/FoAhntfL9DpWYTiEq3u5cW2?=
 =?iso-8859-1?Q?NFNEueKYsokxtB0ZrndfiYkfK2HBFP+6ZS8O+mFK/MGeZRD8sffqMUh4Ux?=
 =?iso-8859-1?Q?Oqi5bm6wKR0ms+2fp41ZrBUNDPcIQTbvr8yI9dTtaI+9V2yB91xX/RgRkE?=
 =?iso-8859-1?Q?qtj8982Hs8OCDI8SmAxltDJ766ao5UJaeSPcLww7jFEw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?LAnI5r2sli8cgWaPLKgvcHg2TIC/lB2HPvSOEo94HIsx7nLTc3h6XLRxOy?=
 =?iso-8859-1?Q?D+3W6Zb0TGGpuUwiOmOQiJqubeYQnuZuxQmWh5+mareY642RtlH1v0mDjs?=
 =?iso-8859-1?Q?/lklAwalaSpvmXmrVrNFnKF+og8qjQItK9Pj1BLx4vWAEPCTuI6WPg/p0W?=
 =?iso-8859-1?Q?h5+s5V6OCrynJ0SRKfXI3FDcYKFkxsu6I3+BWytl5PXNEtSOZjJMtcvE5s?=
 =?iso-8859-1?Q?PyysYK4GfPvIfouaSwPVIbVQPMSHEDuNpvCDcnp5FYzleN4+bEmjDpdodI?=
 =?iso-8859-1?Q?kmQGm9IW00LGbeX0tt2A3bbwG0/spJ/C31ShEGZH978CxbylAQg4HxawvN?=
 =?iso-8859-1?Q?610cZALbltChYBYfnPRZxRGfNAyGxGjwCg0zywT1C4VcwuVmFyY++xrAGa?=
 =?iso-8859-1?Q?RyhJ81POuvVSZbkt1/9/4USddrowMD1G3vVV/Pj1TOhk1+Hei9nh8k87sp?=
 =?iso-8859-1?Q?V+mlDGaCe/g273ztyuXauamtETyBxkTdzg1bW+3zNskxxCbGYdBkdYKrHP?=
 =?iso-8859-1?Q?4QB785UwztivURqhmuiWRPeNPW74rASfVfP22VRtkNmDSLauxbcvgYdEK7?=
 =?iso-8859-1?Q?4WOLKgBMaBL9jS3C5Br/XtuAUL8UDtOKs1bH6ZfvPIj2RqtmS3q1s35ON2?=
 =?iso-8859-1?Q?+psiZ7iLvODjpRjEqwLMo1J4akucQhkimDrxkNsztW1gJLqhAbwbQZTMU6?=
 =?iso-8859-1?Q?qbNkUwIJkzaYS8lgmC1qRBO/R83vruUqtKBXy2nEgqZjkyoBxXyA+6QCuH?=
 =?iso-8859-1?Q?ew3pBzJTP+gO2vof7d4V8LK/BsY9SiNj14/oVHUMQsyFk23wWv/q4/RlPp?=
 =?iso-8859-1?Q?EsY+0FUf5v4vy+VhQb13TpYFZ9sHqDHyJLxVy8mrzy72Fzygs6oNbixJTt?=
 =?iso-8859-1?Q?L+XBZu50D8ZzoGhpOOIfX20BxJo+Huw2m3OQ22caQLQuYoRIYJMaL+kTdA?=
 =?iso-8859-1?Q?W6SG1u6rCn2XHBg7zk63TVTLdzEySNMTuCApkLHlcZ4VDiU+lVNZiikRnw?=
 =?iso-8859-1?Q?R+KAA2FuxeThNvYEd26eriZNPe6+i22E1Aqc0PNssO77sJljG4MseZmTCx?=
 =?iso-8859-1?Q?lLAWqyBcD5U0t8NWS1cqnmTAjyc0wGFFRTN0JiMygVoJMLppXJ5eWsjGGL?=
 =?iso-8859-1?Q?KeVsZsiX+r+VCNsslaexvUvuaDNrXWW8exuG/mGjm3BTRol8vWl/ziNpqm?=
 =?iso-8859-1?Q?jmLcsGb6h9Lz9r3Y8lmvI94VYJ8veQ94nK7Mkykc5XSVx5dK5DaHgq78YO?=
 =?iso-8859-1?Q?HataUvzEgvXJ67tTcOU6qDbePUYRwyv6x/BOqdcD80svEcksA2F+5BI6bU?=
 =?iso-8859-1?Q?MTzQnZ446bWIilbDUEcjMH/TMNjYMxEV+6mzHA1UXKZRF7zVAiE9fEqfKT?=
 =?iso-8859-1?Q?jOu00L/7TyArpcIaXPjpiLz0mgt9iif23gYFgd9uHXCeoktJXHmSBo5xY5?=
 =?iso-8859-1?Q?8QL2oITbPh1FeGeDCh6B+dYOVuG7LkKr9namytFC8/EyxYNL1ArBuvn1rm?=
 =?iso-8859-1?Q?dWv7avlRR+ioOnN/smBff/vNSt0xYRDAJ0bRUEK6lUF/pMdh8wiCClwAim?=
 =?iso-8859-1?Q?KsSpNDoWFWMyq5AGHqDKns5iJH35GEbF/+koixgmKsTsfcgtaQWp/zN4Dk?=
 =?iso-8859-1?Q?PoF4uqH190QdJdy/UGR0hJKpOBpWP1c4rs+7l1zKpFv4DZJZmcwuJ2uA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 399f3948-63a4-49e1-7744-08de25416233
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2025 18:53:08.3657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j7ZgJFvWKyu6JnKD3Sd3ksqJF3JFS2Dimp/x6XuZHfXATSi+vxTu+F9oXabtZSLE0lYrHSSnyWw9Lqpqt9kWAzOhFb8yN2uNbvaBknSE3l0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6978
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Friday, November 14, 2025 1:59 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.com>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v13 13/22] crypto: iaa - IAA Batching for parallel
> compressions/decompressions.
>=20
> On Tue, Nov 04, 2025 at 01:12:26AM -0800, Kanchana P Sridhar wrote:
> >
> > +/**
> > + * This API provides IAA compress batching functionality for use by sw=
ap
> > + * modules.
> > + *
> > + * @ctx:  compression ctx for the requested IAA mode (fixed/dynamic).
> > + * @parent_req: The "parent" iaa_req that contains SG lists for the ba=
tch's
> > + *              inputs and outputs.
> > + * @unit_size: The unit size to apply to @parent_req->slen to get the
> number of
> > + *             scatterlists it contains.
> > + *
> > + * The caller should check the individual sg->lengths in the @parent_r=
eq
> for
> > + * errors, including incompressible page errors.
> > + *
> > + * Returns 0 if all compress requests in the batch complete successful=
ly,
> > + * -EINVAL otherwise.
> > + */
> > +static int iaa_comp_acompress_batch(
> > +	struct iaa_compression_ctx *ctx,
> > +	struct iaa_req *parent_req,
> > +	unsigned int unit_size)
> > +{
> > +	struct iaa_batch_ctx *cpu_ctx =3D raw_cpu_ptr(iaa_batch_ctx);
> > +	int nr_reqs =3D parent_req->slen / unit_size;
> > +	int errors[IAA_CRYPTO_MAX_BATCH_SIZE];
> > +	int *dlens[IAA_CRYPTO_MAX_BATCH_SIZE];
> > +	bool compressions_done =3D false;
> > +	struct sg_page_iter sgiter;
> > +	struct scatterlist *sg;
> > +	struct iaa_req **reqs;
> > +	int i, err =3D 0;
> > +
> > +	mutex_lock(&cpu_ctx->mutex);
> > +
> > +	reqs =3D cpu_ctx->reqs;
> > +
> > +	__sg_page_iter_start(&sgiter, parent_req->src, nr_reqs,
> > +			     parent_req->src->offset/unit_size);
> > +
> > +	for (i =3D 0; i < nr_reqs; ++i, ++sgiter.sg_pgoffset) {
> > +		sg_set_page(reqs[i]->src, sg_page_iter_page(&sgiter),
> PAGE_SIZE, 0);
> > +		reqs[i]->slen =3D PAGE_SIZE;
> > +	}
> > +
> > +	for_each_sg(parent_req->dst, sg, nr_reqs, i) {
> > +		sg->length =3D PAGE_SIZE;
> > +		dlens[i] =3D &sg->length;
> > +		reqs[i]->dst =3D sg;
> > +		reqs[i]->dlen =3D PAGE_SIZE;
> > +	}
> > +
> > +	iaa_set_req_poll(reqs, nr_reqs, true);
> > +
> > +	/*
> > +	 * Prepare and submit the batch of iaa_reqs to IAA. IAA will process
> > +	 * these compress jobs in parallel.
> > +	 */
> > +	for (i =3D 0; i < nr_reqs; ++i) {
> > +		errors[i] =3D iaa_comp_acompress(ctx, reqs[i]);
> > +
> > +		if (likely(errors[i] =3D=3D -EINPROGRESS)) {
> > +			errors[i] =3D -EAGAIN;
> > +		} else if (unlikely(errors[i])) {
> > +			*dlens[i] =3D errors[i];
> > +			err =3D -EINVAL;
> > +		} else {
> > +			*dlens[i] =3D reqs[i]->dlen;
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * Asynchronously poll for and process IAA compress job completions.
> > +	 */
> > +	while (!compressions_done) {
> > +		compressions_done =3D true;
> > +
> > +		for (i =3D 0; i < nr_reqs; ++i) {
> > +			/*
> > +			 * Skip, if the compression has already completed
> > +			 * successfully or with an error.
> > +			 */
> > +			if (errors[i] !=3D -EAGAIN)
> > +				continue;
> > +
> > +			errors[i] =3D iaa_comp_poll(ctx, reqs[i]);
> > +
> > +			if (errors[i]) {
> > +				if (likely(errors[i] =3D=3D -EAGAIN)) {
> > +					compressions_done =3D false;
> > +				} else {
> > +					*dlens[i] =3D errors[i];
> > +					err =3D -EINVAL;
> > +				}
> > +			} else {
> > +				*dlens[i] =3D reqs[i]->dlen;
> > +			}
> > +		}
> > +	}
>=20
> Why is this polling necessary?
>=20
> The crypto_acomp interface is async, even if the only user that
> you're proposing is synchronous.
>=20
> IOW the driver shouldn't care about synchronous polling at all.
> Just invoke the callback once all the sub-requests are complete
> and the wait call in zswap will take care of the rest.

Hi Herbert,

This is a simple/low-overhead implementation that tries to avail of
hardware parallelism by launching multiple compress/decompress jobs
to the accelerator. Each job runs independently of the other from a
driver perspective. For e.g., no assumptions are made in the driver
about submission order vis-=E0-vis completion order. Completions can
occur asynchronously.

The polling is intended for exactly the purpose you mention, namely,
to know when all the sub-requests are complete and to set the sg->length
as each sub-request completes. Please let me know if I understood your
question correctly.

Thanks,
Kanchana

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
