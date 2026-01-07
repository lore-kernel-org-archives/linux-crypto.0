Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA8213A244
	for <linux-crypto@vger.kernel.org>; Wed,  7 Jan 2026 04:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767760001; cv=fail; b=KsyAJFFODx4BUTG1m16a2eW9181Fmphw//b8+eSTuuOMUqbWzUR7m+YLPqfwh26ep+3wL0r0VXwqrKQfFlNlIApjJeq6pPIpsOsgkbvFjvx2VvrxLTnW9gBF66lzKLyMFPjR55T96Op7kSI92W7AhVCRvUXELTqA7JwKXo5de8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767760001; c=relaxed/simple;
	bh=YG+Cn4w/vnh8bd4gPop4rz6Y0UUSngMqbVq8jtY2SDw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d5wtbAHFrOVmORcb3kKIly6+Eeq2U0JmZRXxSzwAPLmeewVFwLkS6okWejm4AuRc7tE+AEcS3b0vongO9cqgGpPljUKKYbjikyNzqHguPTVGIeYiUBQTdAoiWGXCgZZFjCmD2svZ6yF0ddeusIq9O7bWAA//KAGO8UzTZRn0JWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DDmGPwZr; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DDmGPwZr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767759999; x=1799295999;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YG+Cn4w/vnh8bd4gPop4rz6Y0UUSngMqbVq8jtY2SDw=;
  b=DDmGPwZrL0aPIc4Sb4c9AR1d1yoJspnipcwJOYhY1BSdy8y5KBLPEkbl
   /RJ1t9B9p+KWCu4fBTUCZeYivJCzxRqjnDY3n7wGf1Bm3FW3Lrse01zVj
   nNb/18u7dgRtGaavmIJt6WUxoG7oLnrSnnI/EywY3eAAQtldefZOd5xbG
   OLl+BAA52qhCoqEUlxDEPW/lR/yu/bsOpZ0nj1o6Pq2gUYVH8DSzk/8vM
   wg8cOEowZfvkRVisOB+L4ZQZnpC4RTSRBxEJbEvrkHxD5u10fjfmehxso
   Woe40EqGyRtFCWT2MnR+6RbpENd/BT+FHHOhD5JPp0TAxnME9B214XEHX
   w==;
X-CSE-ConnectionGUID: 5Q8dONEuT3yfcB1GcYGBIg==
X-CSE-MsgGUID: sBpEANrsTH2iAKdgxBgbUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="80241453"
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="80241453"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 20:26:38 -0800
X-CSE-ConnectionGUID: 8xQmSiBcTT2WJT4Lc1q56A==
X-CSE-MsgGUID: 1ORtETiMSCu5u2fn59pVew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="233527729"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 20:26:39 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 20:26:37 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 6 Jan 2026 20:26:37 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.56) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 20:26:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EZ1HWXN6oE7n9hEDG5pB7IfyFZukxtmE+xHyr/KjjD0/AYKa0GW5mScBhDBZurQmgglHPFzyZAiz5ELcdj6fHoUuLgac79HSqaYicYznRKr6V6fW4JwJRyZlMCad1lJWQZ6bdgcMq4oyh1HQ3VydnLcBiaVPBk8FYeQTdUr+dldEJC9VTbzAxj2AMFn0LG2rkLHn4GYhb1zj000lFJzaGUq4ACXC5GnvAhFHjjHHpLX5f7/L95Vy6JQpROm/Klul45tZ1NX4mPSKfS1omMfi3W5MxVEg6Sam8d/sBFdiuGjxQK04M81EKNduw3cvrbZn4KAXHHGk+X1VsfRZmIiyeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8onm5LQvVXIB4Kh/w6hWUuOUVbYngenWog06WLrxbh0=;
 b=qeHoD3N6VSxWHHvQqWSCZIakyc1X3i8UeaQOOKbw3dlCGic69ZYjB1nr5dA/ySmJc/tgm3Ge/N7v/jsj8brvFvQfgKXZ0Msz0Hs2QMloYiBq8CPwWOf65OBt3vFV9Uxm9LFbFB8xyeVrNp9xHvfF/4pM0+HMfX7P5mNug9ibkvJLLzBRh2xUU5odmr1eoqByH9Bx7V5mdxt5dx+CYTToKoLN8RpOBw/6BfcyHkjWJqFh1SfZxElDmNJak5er9M0jRYmttZ9Mj2S1V+e/13iFJNQZFCAiQHxuQ551iJZMbKXPX9XTST6BOhX/hXVebCJPWfBzA5GW9VO09gEwGCyQgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB8476.namprd11.prod.outlook.com (2603:10b6:806:3af::20)
 by SN7PR11MB6752.namprd11.prod.outlook.com (2603:10b6:806:264::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 7 Jan
 2026 04:26:31 +0000
Received: from SA1PR11MB8476.namprd11.prod.outlook.com
 ([fe80::25cd:f498:d9e6:939]) by SA1PR11MB8476.namprd11.prod.outlook.com
 ([fe80::25cd:f498:d9e6:939%6]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 04:26:31 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Linux Crypto Mailing List
	<linux-crypto@vger.kernel.org>
CC: "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>, "nphamcs@gmail.com"
	<nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH 3/3] crypto: acomp - Add trivial segmentation wrapper
Thread-Topic: [PATCH 3/3] crypto: acomp - Add trivial segmentation wrapper
Thread-Index: AQHcdgAD4xdTWMSnLUSEH7bPw2ktk7VGKlmw
Date: Wed, 7 Jan 2026 04:26:31 +0000
Message-ID: <SA1PR11MB8476DC4555BAABB5734BE314C984A@SA1PR11MB8476.namprd11.prod.outlook.com>
References: <cover.1766709379.git.herbert@gondor.apana.org.au>
 <9aab007e003c291a549a0b1794854d5d83f9da27.1766709379.git.herbert@gondor.apana.org.au>
In-Reply-To: <9aab007e003c291a549a0b1794854d5d83f9da27.1766709379.git.herbert@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB8476:EE_|SN7PR11MB6752:EE_
x-ms-office365-filtering-correlation-id: 5bc01a40-0d39-4b04-1c96-08de4da4ef0c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?8Qawkr2y5iRRzFjSAQUjtCePAvSmICItGKeZf32OthUBjHSe1bbf7R94PjRb?=
 =?us-ascii?Q?Eg0FfeX9odH7pW7T1dGkaoE9wRKg5DQnMjANVqXtAVA4UOMHkjZk6hRsL6F6?=
 =?us-ascii?Q?uuegS/Cn5VdVbBfBGhqdw5mDIFYY+vkO+GSG6xD8B4bhxgVJ4dFfX5i2zids?=
 =?us-ascii?Q?cKU5GzTQ2+dWPmF55S0BNMP+AczWX85IdoBosBDgo5ED9YOpdGAdMooLQc6u?=
 =?us-ascii?Q?SQOV4DB/Ui8hY8ZErCdDafwfw6vGqa6nESQI1PWAHUsVG5U6RJnkU81wFWB0?=
 =?us-ascii?Q?YeJ82uPfSgovFeFBREgU1h9n4mh70318+tN5N701D+UYYwCha0VcBe1/mPVf?=
 =?us-ascii?Q?zoD4PssHMDatCnuMuSRzAdzlQOUSi9kR5oe7iYtcVeDWFZATv8VOeuAMIR4D?=
 =?us-ascii?Q?5Mxl3tw2yPsKhYHEOVetxsSMuhIlFZcc2Y/IBhORhGBb9EAC98xTQaBHrKfQ?=
 =?us-ascii?Q?TDx5pjdM0syjwi6qIiGLoD+Jzm5CZ7roLHYqfJI8FD/m55bARWpwDDd6UYaK?=
 =?us-ascii?Q?wFW5+bLj04IwTfkfyd/sWdHhilfMw8bTNvxSgGjbIJVWAL4vVhmajiShuuFj?=
 =?us-ascii?Q?UVnDy5QbF5Eg08SDF0zEIE5dud9Nj+sVhW2P77EvU3GOJKYb1/HrpvDWBxD3?=
 =?us-ascii?Q?KNZFPNrofDqZat5fAezZUdI8hg32F3Ih+R1SijyuKyRStIfEswVEpcL+lnYm?=
 =?us-ascii?Q?a9stkq4XWwEfkvHqObIwB1i6wkDeBSms4ylUFPoHMF3w8raQOP1JZkZjncYE?=
 =?us-ascii?Q?DT6Mb/sVOPMOzMy1prsszdhn0YdGrVTReSt/TuSHFp2slBmZx+kO7OcIA5IX?=
 =?us-ascii?Q?4qXU89lGvOrRjOqcGpaLzubdvaaqB5TzzpqQT1GsBwqHFdYI/DmcCY6Pv0yw?=
 =?us-ascii?Q?x7vyECoOHDLq/+/bio6fyi/4SU/d5jMWrEyeIYm5q/rMWAg2lD7UeRCGhjJR?=
 =?us-ascii?Q?lPaloUc848x/MfPoe5Lg9h9KGzBPspADcFbO/zIweNrRz3P0FnjYEoen5vNv?=
 =?us-ascii?Q?jsAsU8+0CKFp0G/zQN+VuXGGp8uc2za3ytEitinaCsAetiQlpsY/ztHNPQjf?=
 =?us-ascii?Q?jjpI56t/YOSpR+/1Wz328vuljYj3HnkvlxifC7tIMmwhLSkJzPAKWUCngx1P?=
 =?us-ascii?Q?KxYpphMxpywoJkvWLQ6cYFw5aeTOMPQPAew5PXuwhim9RgvAp1frokqCek36?=
 =?us-ascii?Q?7RQ6Iws/iNFmZfNFP7EHZUHFAaOOqCz5ERBlfKGvv7e1NKuUr5I2jswUWCLU?=
 =?us-ascii?Q?rYu3HIBCwDzK692Rs/vDs9NabRqRPnDqLgWK5/NtdHSpgUjxX4MMTMsBrthk?=
 =?us-ascii?Q?r39ysfj+oNleDUa37T7SFeoe4cmbKe2r906vaCTlZgzN5PexpHlLQL4FMSx3?=
 =?us-ascii?Q?cveWKkvjZqjh7lTFKDw0akwNPCSIXZwTGgNjOr4eP82PMo38cniB1EBFaEQX?=
 =?us-ascii?Q?1k3DeXwO/kEpGjFGkFFP0XV/4LCt6okbPt/iCfhp29CGDDjGN26pilIY2mFi?=
 =?us-ascii?Q?1lhuJLA1+1zieta0BDS3Fmvswrb7M7PfLngv?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8476.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w+0uVHvqzJ6a8RnGUCFPlXTueGiB7w3BNv9aupsRxJWr1fvwqaGtPlcRFXxC?=
 =?us-ascii?Q?T+4mrhmF2dNDmk+QPCLqZ4ZOPTBV65WVLGqWsu2zFJKx24FJ940Tb9e41HKM?=
 =?us-ascii?Q?4udRI0bQW3pF2amH9BK8/9ex/tDmEss8m8KWeybu2NCGBPzv9O+8HS65kKfD?=
 =?us-ascii?Q?Cr5ZCCr8umrgDKQCiZDjyjG+uu9JiGNX+L+7d2Q1Er4UFEYmvIlDd1eOvpSE?=
 =?us-ascii?Q?QyKSbSlgn6+/HEfamUCCe0YIkvWQnXwSow47nrtTS/BatUiEEkeROHRwFGYP?=
 =?us-ascii?Q?6V6bILduTv2TIHP7uJ1g8Mb72x41nT6f2jlLIyAubRwFRIMUoIkhKdYJLoNt?=
 =?us-ascii?Q?zvfr5JTKAgroKAogwxqLCh3xAQC4DPe1m/ZtDd3Okyl7fTF1TSrz/QG4U6bE?=
 =?us-ascii?Q?PLhCoBi+J0ZYR1JXxt7Pg2HBvdcy4FdydpsWfBeFcWFt2UedP3dk6jgqJgck?=
 =?us-ascii?Q?Xr4h1dd9AnIStmQt2qtkSbdIsPQ7Ygs10cLuBGsOj+VnwLc2KPeX7fWm/+y4?=
 =?us-ascii?Q?cJAVQy+VoNU61nN280FGyaFhxPZItKUBUdQGrv6CuuuHfpjpDew04bCjlCIa?=
 =?us-ascii?Q?8H6g4h2TZyoRcDmC0ZKsCkjFow8exkXVlTKYCXVktYIqHvDlHkJEwMWfGJR0?=
 =?us-ascii?Q?JYLL8utAyHaFUKzEab+sRQgow4vr/xfBfSPR1oEZI909LGZyfkYkWbtF74sy?=
 =?us-ascii?Q?OkY9EywoxD2zNOJXOrtoFEcs8tw0sIWjG24BYpVPVbb38P0SdCP2LB06YX84?=
 =?us-ascii?Q?dWEMBA8tzP5POJdAWlx6oOK0Ls5scBOgw5A77GGa9YA589sAQ+HSww6br87B?=
 =?us-ascii?Q?YZoe3U6ya+jwP70Pu6aspRMdKA8TT/yq5d6SIqsFJAVo5wWhI7LCgpgWSjTL?=
 =?us-ascii?Q?/fLFXwM/cbPd6gYRrh5lkIKG6wKghakQGj5hnQDbUAiZToSB3BLVDgmI2FY6?=
 =?us-ascii?Q?/p7ogrzrabToVIdvDF6DOEVIN3xNukHuBw9rg2/BqTw1qybf7UZLtuHinWFu?=
 =?us-ascii?Q?KzYKWps3b5NG1yl+QStJTtk8j89baJC0ahxfPh5EUVmQouFzNJ0tqtgln8af?=
 =?us-ascii?Q?IO7WliPsENWavNz5Rvd9lmZI7Yeo04DkoXPFBcJ42rtVyrY1rfvpD4ixx+k4?=
 =?us-ascii?Q?vQuHP1WBvBpHl3iuMzhi1iDFwzzqvg11syhsGvnwnSy61a1ajFpjKP1RQTpV?=
 =?us-ascii?Q?u0FJM/Bm1cMx6mCUVh3TSTz+BmCMeMm8TdiUPGtUTUQKEqOu8M2ogKcQvNFF?=
 =?us-ascii?Q?9yxHkfSaydsWx7guroBvgWvdU0iDUiteOSn1fbsHGa2JDjTm9QNwbgdfKBQ2?=
 =?us-ascii?Q?rSIG4LjZS36hA8tTEU7RAAIQkblY1dtjPRHPTnmO6vFCA0KJb6Fp+r1FemhV?=
 =?us-ascii?Q?4zHb5bINYENeSaDktA7Uu5UuLGGxYM2sYgrGJb7VwhjxhozXSTzuMng6fDw+?=
 =?us-ascii?Q?dpZcJbKrw6I7yWWKZRLnlLnJI/6qvk4Q8hhCnTqxsbC+RLkgt8xyS9hUTk/k?=
 =?us-ascii?Q?uQgf18doO8zcugTaO823H7yzGVL8h4/QDPJ/PIdvU5PNcyDjkFofr4kLsrwd?=
 =?us-ascii?Q?p+BuHu1dFd57ZCprYQwUdtw66Y8KeFrpO9uBLrZa74jJuLvAL064B3ibEDeB?=
 =?us-ascii?Q?pLOruTClE0mkqJXB/ZAedyPXfruUOFrhlypxoAd3ekJ6uv5nkouUhtZt79a9?=
 =?us-ascii?Q?57iFSvOcG/lKtLLIdV2JG2gBzQASdXjxK+yYi3o8hFL7D1c8d3FQbiWb3XZw?=
 =?us-ascii?Q?8eelEnLbbA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8476.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bc01a40-0d39-4b04-1c96-08de4da4ef0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2026 04:26:31.3040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PCMahhm9GnuAMVh1+ByQQEsADO7Xl6os0oHF/GBC+QPmHB6gCuhBLCcSQUei1wdolRCTddVNwv+A1JpFH6mRdPQ1uGHryRE6z2EU2MTMs/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6752
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Thursday, December 25, 2025 4:38 PM
> To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
> Cc: yosry.ahmed@linux.dev; nphamcs@gmail.com;
> chengming.zhou@linux.dev; Sridhar, Kanchana P
> <kanchana.p.sridhar@intel.com>
> Subject: [PATCH 3/3] crypto: acomp - Add trivial segmentation wrapper
>=20
> Add a trivial segmentation wrapper that only supports compression
> with a segment count of exactly one.
>=20
> The reason is that the first user zswap will only allocate the
> extra memory if the underlying algorithm supports segmentation,
> and otherwise only one segment will be given at a time.
>=20
> Having this wrapper means that the same calling convention can
> be used for all algorithms, regardless of segmentation support.
>=20
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  crypto/acompress.c         | 25 ++++++++++++++++++++++---
>  include/crypto/acompress.h |  1 +
>  2 files changed, 23 insertions(+), 3 deletions(-)
>=20
> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index be28cbfd22e3..d97a90a5ee46 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -170,8 +170,13 @@ static void acomp_save_req(struct acomp_req *req,
> crypto_completion_t cplt)
>=20
>  	state->compl =3D req->base.complete;
>  	state->data =3D req->base.data;
> +	state->unit_size =3D req->unit_size;
> +	state->flags =3D req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
> +					  CRYPTO_ACOMP_REQ_DST_VIRT);
> +
>  	req->base.complete =3D cplt;
>  	req->base.data =3D state;
> +	req->unit_size =3D 0;
>  }
>=20
>  static void acomp_restore_req(struct acomp_req *req)
> @@ -180,6 +185,7 @@ static void acomp_restore_req(struct acomp_req
> *req)
>=20
>  	req->base.complete =3D state->compl;
>  	req->base.data =3D state->data;
> +	req->unit_size =3D state->unit_size;
>  }
>=20
>  static void acomp_reqchain_virt(struct acomp_req *req)
> @@ -198,9 +204,6 @@ static void acomp_virt_to_sg(struct acomp_req *req)
>  {
>  	struct acomp_req_chain *state =3D &req->chain;
>=20
> -	state->flags =3D req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
> -					  CRYPTO_ACOMP_REQ_DST_VIRT);
> -
>  	if (acomp_request_src_isvirt(req)) {
>  		unsigned int slen =3D req->slen;
>  		const u8 *svirt =3D req->svirt;
> @@ -248,6 +251,10 @@ static int acomp_reqchain_finish(struct acomp_req
> *req, int err)
>  {
>  	acomp_reqchain_virt(req);
>  	acomp_restore_req(req);
> +
> +	if (req->unit_size)
> +		req->dst->length =3D err ?: req->dlen;
> +
>  	return err;
>  }
>=20
> @@ -272,6 +279,9 @@ static int acomp_do_req_chain(struct acomp_req
> *req, bool comp)
>  {
>  	int err;
>=20
> +	if (req->unit_size && req->slen > req->unit_size)
> +		return -ENOSYS;
> +
>  	acomp_save_req(req, acomp_reqchain_done);
>=20
>  	err =3D acomp_do_one_req(req, comp);
> @@ -287,6 +297,13 @@ int crypto_acomp_compress(struct acomp_req
> *req)
>=20
>  	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
>  		return -EAGAIN;
> +	if (req->unit_size) {
> +		if (!acomp_request_issg(req))
> +			return -EINVAL;
> +		if (crypto_acomp_req_seg(tfm))
> +			return crypto_acomp_reqtfm(req)->compress(req);
> +		return acomp_do_req_chain(req, true);
> +	}

Happy New Year to everyone!

Hi Herbert,

Thanks for the segmentation patches. I have integrated the changes with
my latest v14 patch-set I have been working on that incorporates the
rest of the comments. I had to re-organize the structure of
crypto_acomp_compress() to make sure that performance does not
regress as a result of the 3 additional conditionals introduced. I also had
to inline acomp_do_req_chain() to not regress usemem/zstd performance
with PMD folios due to the added computes.

>  	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
>  		return crypto_acomp_reqtfm(req)->compress(req);
>  	return acomp_do_req_chain(req, true);
> @@ -299,6 +316,8 @@ int crypto_acomp_decompress(struct acomp_req
> *req)
>=20
>  	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
>  		return -EAGAIN;
> +	if (req->unit_size)
> +		return -ENOSYS;

In order to be able to use the same zswap per-CPU acomp_req for compression=
s
and decompressions, I kept crypto_acomp_decompress() unchanged and to
not flag an error "if (req->unit_size)" for now. Besides, the added conditi=
onal
impacts performance for the workloads that I have been using (usemem,
kernel_compilation)

I wanted to share these updates and get your thoughts. If the above propose=
d
changes from my integration sound Ok, can you please let me know if I can
include your patches in v14, or if you would prefer the segmentation patch-=
set
is accepted that I can then rebase to?

Thanks,
Kanchana

>  	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
>  		return crypto_acomp_reqtfm(req)->decompress(req);
>  	return acomp_do_req_chain(req, false);
> diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
> index 0f1334168f1b..965eab7738ba 100644
> --- a/include/crypto/acompress.h
> +++ b/include/crypto/acompress.h
> @@ -67,6 +67,7 @@ struct acomp_req_chain {
>  		struct folio *dfolio;
>  	};
>  	u32 flags;
> +	u32 unit_size;
>  };
>=20
>  /**
> --
> 2.47.3

