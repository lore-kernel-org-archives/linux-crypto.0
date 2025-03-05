Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B5D19D06A
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 20:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741205364; cv=fail; b=lsNEaYnuWPO1Ac9YDsKtbxub5aMfVXAcgzqfc1PnI90JnRsdU10O+ovj3y7pbe/QMz9KOT8HjOkAxH8IfmQASu6EPG4WmABgxPTpVUE0FUZI1zi3lCfuFGEkzRTGC75KTp1nHJguydIvaLe7KZJ3s7hbFgNylmdtZSV3R9Ty7GE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741205364; c=relaxed/simple;
	bh=2IY7izdIpbvxPgKjofVIxvYsIEfnSMDgEeS41U4skS8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oFF9rY+7TEPU8KJ4mmaaMkxQAF1T4IKOTpBhq8ec4qI9k+xxkF17xKWNgVbeVkkJkeU4dObBF7VgR5LPxRGCBqUaqGHmKkKpHtifre7JE/mn05vSYhzvnY+woIbLrMkUOnT5fVvzakNllztDPImfwTLZtpwVV6WGhjMkgtmYjFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nMAyzmFa; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nMAyzmFa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741205362; x=1772741362;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2IY7izdIpbvxPgKjofVIxvYsIEfnSMDgEeS41U4skS8=;
  b=nMAyzmFa87xzOj4mm0soND+bw4DCoL0zdJGg9h9RVQI671qTd4hDSx6/
   yoq7SR9yZfH8ppZmYSlMdg1r/ADihzztg8/vWjqR7nNM8Ptcf4ilvCYAq
   L6H0VVDodBZR1dC4NHHSe7Hk5ozRCCTMTaggOmk4ZZDjvb011nILFW5UY
   tOhaFbitlaOIRB9kX+TdN/oY1e5+n7efxGaKljTBH+dGxkZcvcwtTYzHF
   0Qff6TWjDhzCim3D3I0GkBGLAWzmvu+vWAUW3RM63VzWFbMTqeYp1Ly/E
   MCFv62q1ixoFGGad87AGOxsBOGFGJnAzTQh4K0V+piGvWgf8zig9NCymw
   Q==;
X-CSE-ConnectionGUID: HGehFnm2TsmJZ6rpGmW3SQ==
X-CSE-MsgGUID: 028UaHvFTpC+kqNBU/31vQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="53177582"
X-IronPort-AV: E=Sophos;i="6.14,224,1736841600"; 
   d="scan'208";a="53177582"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 12:09:21 -0800
X-CSE-ConnectionGUID: IFTLJTjhQhKGGSivJj2Dzg==
X-CSE-MsgGUID: tuGlgU9ET8K5waAwiuP6pQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,224,1736841600"; 
   d="scan'208";a="123898632"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Mar 2025 12:09:21 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 5 Mar 2025 12:09:20 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 5 Mar 2025 12:09:20 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 5 Mar 2025 12:09:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FYw+gGZBWDBuzUA5vU4egvCp1uUHOTVomcIGMKNuMdPnARdUchD+PA9X28spwVE+udH7dga3ILpfRE5c/MJ/jt8JbN/H06z7aIZohrqMlg4ysdYGKEWH7DjDhIZSkGAI3Pd872ckrM0UQq3qqpnnY0B9bGk+eyQhIBJHZNsqElKwb579VccHqXd+H9PzGGmAUdxoCEOLUNpQi99oTmFl7IJtdWP9PLnqyQ/1vsrolYRDM03x7N3C9LKPCQNaL1fZsgj5k1/oB5icwECMPPgHqOD5EosloHHsiIzJSFrnNrlNlsZXeqmjRc32PnKgTJZjmI6UiX2JmtMfk5w/oAU0Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fdMvw8q7eEDb1tPSW/Db9ou5KzrEDwG3/5/g2kGz3wI=;
 b=X6FLIbnPnHb+r0DMO5cQeVj1QDlR13KZLDokqebZfcBXdUz+/s1/Wwf+Pw41C/6o6GaP5y3IAkxdaApMANTxR4Wn4uu9UPHBPwgFzWRmmsBsquMBYhUu8oORVOVDd8nyj9UMLE0GliPLb4jBfyiKnn05Ngb+K1skEnfEjOpWII0cx2JvIgORDpiyp6GGhSvPvrYNTDRpuOQAHM3fYBRrczzhSzD91ZM52nrGl+cwWCRtjoktVZEgcmUbrxagiasuxpyJStbrLpbeZ3OLJWLa1GYK3zqhL48uHjwzC56whMe9/hZo2HS8c2MBtwYol+dElcyc1CmkZ05OMAuI13IFBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BY1PR11MB8127.namprd11.prod.outlook.com (2603:10b6:a03:531::20)
 by SJ1PR11MB6177.namprd11.prod.outlook.com (2603:10b6:a03:45c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Wed, 5 Mar
 2025 20:09:16 +0000
Received: from BY1PR11MB8127.namprd11.prod.outlook.com
 ([fe80::6f9b:50de:e910:9aaa]) by BY1PR11MB8127.namprd11.prod.outlook.com
 ([fe80::6f9b:50de:e910:9aaa%4]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 20:09:16 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Yosry Ahmed
	<yosry.ahmed@linux.dev>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: RE: [v2 PATCH 3/7] crypto: acomp - Add request chaining and virtual
 addresses
Thread-Topic: [v2 PATCH 3/7] crypto: acomp - Add request chaining and virtual
 addresses
Thread-Index: AQHbjOdg2QrOh3WnyEqhsJpXglwgBbNje+sggABMeQCAATArkA==
Date: Wed, 5 Mar 2025 20:09:16 +0000
Message-ID: <BY1PR11MB812704BB7CE4C9C859B702E0C9CB2@BY1PR11MB8127.namprd11.prod.outlook.com>
References: <cover.1741080140.git.herbert@gondor.apana.org.au>
 <a11883ded326c4f4f80dcf0307ad05fd8e31abc7.1741080140.git.herbert@gondor.apana.org.au>
 <SA3PR11MB81203FD3D6638C0E1259E5DAC9C82@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z8euHNedFIBkVZmL@gondor.apana.org.au>
In-Reply-To: <Z8euHNedFIBkVZmL@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR11MB8127:EE_|SJ1PR11MB6177:EE_
x-ms-office365-filtering-correlation-id: 9f746f31-214d-49e1-654f-08dd5c219b37
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?dRic81UqwZ81FO6PsX88brupS830xFKmnA2F9zW6YYtYIITuQPw4IG4St/BH?=
 =?us-ascii?Q?AS17iKw7hls3CaRajDhXa1MPgVx6ez4pw6Vht25eGdyY4qZugs2FchduaU5v?=
 =?us-ascii?Q?RPnWDxnlnBHjww1cyGPd9Yl2skNMajLqegcRhx5Qy4xvLof1xDiRA05vHdMb?=
 =?us-ascii?Q?Q31pncK8FG+JX3Zi8B5nQ9E2L5tqGQjgGgaDN0i3qNhzdOCeIRZLrIPjN5de?=
 =?us-ascii?Q?AuHyAuS57Gv0u+n6IvikTQTZwXF+HyyIu6JDpUNrcsg7+a3wpJIdTiTvoxiJ?=
 =?us-ascii?Q?bdg7AMQYqFIRgvWb05PJK6hY1potHgCRwFiFWmPRsnTXGCA2WK1zbppMXDeD?=
 =?us-ascii?Q?1PG36iXgMGdSF28n1na61xtA7XxGMG5/kZUXBkjH0LMul0zo+tAb8VnW7JRL?=
 =?us-ascii?Q?9xKEKUID2R5rTDbfQfIHy4HWCBVYPIcesXYCRwK1U2sBxxg1XCpWqh95Qqef?=
 =?us-ascii?Q?krf3hkPIBgzPWXke9rRwiY6mB2CLVuSuvWn0z5kzq9a6SCGLUdOXWLXy7TEj?=
 =?us-ascii?Q?Lf/hx8j07MDsq4adxLe0GP2vdixEooZ0nh/UpDkZmX1StF17Df/ZcRWzwaOY?=
 =?us-ascii?Q?6orJ2JT39QJzQJTknoGZ8lRb9h/WZR22PPzbMGQw2sYB/istcEESt3Kfy3qQ?=
 =?us-ascii?Q?2+GMMLp8xizncf+sxPxfj+Npmqv2tDZc7hVvR48KUq0VKnIudgxaGMdi08H+?=
 =?us-ascii?Q?QrtbykwzUGXMUOmYGAiQdQNbiQw5H3hOR5ha64/vcdpU9nG6laCwYBNiovH8?=
 =?us-ascii?Q?aurTSMyNsi4Alg/VW400KOEMsaiLaw3lYBksGdmwwGplJ8G9MoaZUFS6bNpd?=
 =?us-ascii?Q?osv6EWCgpJwjPxhLl26NQ17TELZxvIph0dGTU7DN7GSTnkj7Exd1eLpkU4MN?=
 =?us-ascii?Q?VZipJWwOaIRKbLL2dTeBlSqKS9rC+eaUO7B67uMDymbmdWeANMmWE4YW/DIy?=
 =?us-ascii?Q?D5wCmrs1cDh1nKeZXkSzDupIfPhK2RgmCEEkK1VxKv9JEB3GrgMK4MDonm+s?=
 =?us-ascii?Q?07Lz1nOLfEVRCdcx33sYPhcBft6k5LS+lAH5gsozl2NgawMUrKn0zlnhxJ74?=
 =?us-ascii?Q?qV97e3juUMUNVh8lYE0wCaugyX9eNpzBGmn5GflbBuJmOhSCI5CGew+tyE38?=
 =?us-ascii?Q?1tty3GIJSD6R/7QQ5/gtDBuu/naKnPtXtZ+NXza1Kk1fw1ZOLkexeyvWCehH?=
 =?us-ascii?Q?TfVhxKesHUDsirqHNZ1c1EM5xhRpimkBYNhpnVWAlVwb41NoEPAQmH6gckqn?=
 =?us-ascii?Q?/TEO6vAhdwe7eMvmUYYR3o5jHa7iE/BuQgE5YKbYKpqUzCXW7xkshKN62GvB?=
 =?us-ascii?Q?6Re4ImNewlbyYx3Dt6wc6y6T4j13+m7AVV9FCV5xUn0Ue0WW6OCGQC+bKL2A?=
 =?us-ascii?Q?kiijQPc9d/Rzo10MaHVrXyxRhO+8Sksu5Cf7z5gKbpgznE45CA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR11MB8127.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NqSsz05nmoWOkGRLUjyi2YHHCE7DPy1Oxmv6jmMWO1A9khCw1OKI4EY1wxP1?=
 =?us-ascii?Q?D2kkhn+IARcSslI5G6dLUVP+MgOHSB85XYbnLaciYN+wVimVzF5oEStILF/B?=
 =?us-ascii?Q?PaYhhOJuV58U7TUaYcRTkKj2F60gMIwXBZextuVjzr/d2ddrROrXzjqaE5Dj?=
 =?us-ascii?Q?Au68GU1vUQbR0YTD+0wE563jlyYNrxDyQBelofFmNJ+ITGHqfppKDVeLnqKa?=
 =?us-ascii?Q?nlC+2q25NjdgBN1qW0GgHKaDZ5jT0HnRb2VoEFPj9RuTaCp8ajEaRjmXHaTZ?=
 =?us-ascii?Q?P0UfxeFRRS1MF8NJ7AvYOpc8zLX4XrX0hWskHiNkmhmYPGGzaoACTbqNvsjt?=
 =?us-ascii?Q?lxzUKEnhk30pcTSsnudUPr7hohKUfCKieYVE9Qv0/dAuZvq4A/J4HUSEgcPh?=
 =?us-ascii?Q?pjTN6VG5L7PBqtKGNd8r5IzRaQxV1/Z/+/4QDg7yGcduxDTbFfXiSN/B/m6A?=
 =?us-ascii?Q?I3niBh+xhkvWb9Jx3/OE6/bxaoXotH+JHQA7NM0gsmTD0NyMXaHoXd296eFJ?=
 =?us-ascii?Q?wku+bVJY/DEQBJDjX+z2N1LNkdXZL1yfGn49RLGphlu8EdmePByi8hR5v2Hr?=
 =?us-ascii?Q?73DHLB/Ul2eXVH/I50SLfRqrWepFU3WF4HTBbRP0Q8u/97378V1MJcKrr0SC?=
 =?us-ascii?Q?7zUUTYL5pPSeOGhBRgD1dcgOtsjaVCHCnzhzSXqupKMGEa4yv6ftoEhozOeY?=
 =?us-ascii?Q?BPV9xDshS1m0SpBT7ZAneNL6vg6I3J9e2ExqaLUpR1xTfOyDhK0m5/eIPxE3?=
 =?us-ascii?Q?hwpdxkQUaXf6RKwMbh4uN2J6nDEbXniLmdSHsgHO6aPZJHcWI4GlFBxdYzv8?=
 =?us-ascii?Q?59yyw3kIoync2RqDvE5dD89GVsfNnXP8owt+iObBUg3O3DVIM+7X6BRwqDOF?=
 =?us-ascii?Q?aKbgJ0Z4SLpjGjHm3O/Rh/Mmv0SbuoJ0xUP39fzt6gUT2iwfcjY5CuWhEKKT?=
 =?us-ascii?Q?a82HL18xq+pmKC5E9rrgxsOvXgohvNJLB2FkPhXZj5CSoDPKnF/yekGIE5yh?=
 =?us-ascii?Q?kd6RQcfnpVD+cJe3rafG/5u2qMKakEuVFqbshXXIAmrAW7Nd+5L/mdS1XOVQ?=
 =?us-ascii?Q?YW6zP0yGqfGcXBi040ln4wRcn0+1jiI8pSjNv5b1OKHBCM+FMiCECUAuz5qQ?=
 =?us-ascii?Q?XBAuqafwzo4/w5Vg81sKFV9lq0drxBuLb5Q6Qpvrx1QBRn9S18hw0iqlguqY?=
 =?us-ascii?Q?bWElge7epW9eRGuVxf+hh0h7Tzv2BT34uvSPGL0Mlcf15btPUIggQrF7oiu7?=
 =?us-ascii?Q?y6ztunpNjVlUPqSPNg9Q9/R8WEC0AnKqWlVN+B8CoyBXBYsDtv0a72XbFRA7?=
 =?us-ascii?Q?pUW/Y1XEXX1B6stS3cC4NVfw+R8BdGWySja5LEfRunjdpf0NEsbX8eOaeKKy?=
 =?us-ascii?Q?BcQPcuaCLlWwkh0kjSLr5xzzCQf+TxFU+cYVHifQ5mdPAZrNItWmdYnYW+G+?=
 =?us-ascii?Q?JzBeBDFfvJDVcWmxEIjs49a886RV49UHROaA0eaBuQlK9RwNMVZcdZ51NJ+F?=
 =?us-ascii?Q?pBpgZSJi0l6WfQ1BR8MbTd69NTy6KoDKxdsOPxiuW1hXJEiIVZKnhGME03Ef?=
 =?us-ascii?Q?plpg5SJkN4oBRSQhLoUHGSCbwfX+Pd9zMM9n23P4bwwceNX6a5BWm+RGCgtw?=
 =?us-ascii?Q?9w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR11MB8127.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f746f31-214d-49e1-654f-08dd5c219b37
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2025 20:09:16.3698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kURSOaRWQs7icF7oE+arHVt+Zr2qqxweJKYI3LccpK2pFj6X3ADY5/kU2xwOLWQrpHcF2j+o1BtwcqBCTbWnj/66zrMUOAWKs/ezDUfdYSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6177
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Tuesday, March 4, 2025 5:51 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>; linux-
> mm@kvack.org; Yosry Ahmed <yosry.ahmed@linux.dev>
> Subject: Re: [v2 PATCH 3/7] crypto: acomp - Add request chaining and virt=
ual
> addresses
>=20
> On Tue, Mar 04, 2025 at 09:59:59PM +0000, Sridhar, Kanchana P wrote:
> >
> > > +static int acomp_reqchain_finish(struct acomp_req_chain *state,
> > > +				 int err, u32 mask)
> > > +{
> > > +	struct acomp_req *req0 =3D state->req0;
> > > +	struct acomp_req *req =3D state->cur;
> > > +	struct acomp_req *n;
> > > +
> > > +	acomp_reqchain_virt(state, err);
> >
> > Unless I am missing something, this seems to be future-proofing, based
> > on the initial checks you've implemented in acomp_do_req_chain().
> >
> > > +
> > > +	if (req !=3D req0)
> > > +		list_add_tail(&req->base.list, &req0->base.list);
> > > +
> > > +	list_for_each_entry_safe(req, n, &state->head, base.list) {
> > > +		list_del_init(&req->base.list);
> > > +
> > > +		req->base.flags &=3D mask;
> > > +		req->base.complete =3D acomp_reqchain_done;
> > > +		req->base.data =3D state;
> > > +		state->cur =3D req;
> > > +
> > > +		if (acomp_request_isvirt(req)) {
> > > +			unsigned int slen =3D req->slen;
> > > +			unsigned int dlen =3D req->dlen;
> > > +			const u8 *svirt =3D req->svirt;
> > > +			u8 *dvirt =3D req->dvirt;
> > > +
> > > +			state->src =3D svirt;
> > > +			state->dst =3D dvirt;
> > > +
> > > +			sg_init_one(&state->ssg, svirt, slen);
> > > +			sg_init_one(&state->dsg, dvirt, dlen);
> > > +
> > > +			acomp_request_set_params(req, &state->ssg,
> > > &state->dsg,
> > > +						 slen, dlen);
> > > +		}
> > > +
> > > +		err =3D state->op(req);
> > > +
> > > +		if (err =3D=3D -EINPROGRESS) {
> > > +			if (!list_empty(&state->head))
> > > +				err =3D -EBUSY;
> > > +			goto out;
> > > +		}
> > > +
> > > +		if (err =3D=3D -EBUSY)
> > > +			goto out;
> >
> > This is a fully synchronous way of processing the request chain, and
> > will not work for iaa_crypto's submit-then-poll-for-completions paradig=
m,
> > essential for us to process the compressions in parallel in hardware.
> > Without parallelism, we will not derive the full benefits of IAA.
>=20
> This function is not for chaining drivers at all.  It's for existing
> drivers that do *not* support chaining.
>=20
> If your driver supports chaining, then it should not come through
> acomp_reqchain_finish in the first place.  The acomp_reqchain code
> translates chained requests to simple unchained ones for the
> existing drivers.  If the driver supports chaining natively, then
> it will bypass all this go straight to the driver, where you can do
> whatever you want with the chained request.

Hi Herbert,

Can you please take a look at patches 1 (only the acomp_do_async_req_chain(=
) interface),
2 and 4 in my latest v8 "zswap IAA compress batching" series [2], wherein I=
 have tried to
address your comments [1] given in v6, and let me know if this implements
batching with request chaining as you envision?

[1] https://patchwork.kernel.org/comment/26246560/
[2] https://patchwork.kernel.org/project/linux-mm/list/?series=3D939487

If this architecture looks Ok from your perspective, then can you please
let me know if "acomp_do_async_req_chain()" would be helpful in general,
outside of the iaa_crypto driver, or would your recommendation be for
this to be specific to iaa_crypto?

Thanks,
Kanchana

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
