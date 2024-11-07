Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2630F218930;
	Thu,  7 Nov 2024 22:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731018312; cv=fail; b=d4M1YOPMzPo+yNmlGAsl47N6VY6SvUQaKiKAGAEhUh7h7qoKD0HomAaGgYqw5WCKJfKKZNjwNoDnl/tmUI3Zl/MkZdA5sdkGzA6K+/zviQzpsqPO43++LcRMya83+QEhkcMAHrJLpaMNBstPhKpaP8F28b26KIPeycogIkNV9nI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731018312; c=relaxed/simple;
	bh=9OPd2uc4/9gNgtJUXKMKkG0qf1HPoI4Nuq5w4ZSmM5w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jWB547+cvEAjabMUB1FIF+p//f+klA5YEuCCsMHDHNFcMLHM0mHXw0XC/KfQwh4KdFPwmA/ZX2sHO8syrlGL8OwsLhYX6i4WunGMMGErxM7XJmydFJJrqIxIZ5LcsGpgn1P8BbHiKSv9ZVj9W5HA3ap/zyzA05QCuwpGMXO5h3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jXpdQEtb; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jXpdQEtb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731018311; x=1762554311;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9OPd2uc4/9gNgtJUXKMKkG0qf1HPoI4Nuq5w4ZSmM5w=;
  b=jXpdQEtbn7TNF1DPWkFfOOHdDPEjiBmtbjb+1KHBc2BCLn8QHtmW7WYt
   6DSppCk3em0PYO+Zll4VEXuFH7G4a5zMTXdguDitLQohIVRxULSdXCR7u
   Ko55PjCphqNshG15LAnXlItbLweRYtMg3icfEhqN2FNhpaboU2VOiJA8z
   lRUUwAXhZT8JIVD2hk91fKQcMhzLROSRjehCKOzY49OkRFsSaMurfiTLH
   0ZcOEFwr2NH4OTJEJJTs70KBV3ejxB1ivmikptRFdR2+UbMX7MCuiRuGO
   W/1Q7K8cL6AsKHV+1ywv4WcqfOWjCAwvzkEog39QIDxR02Rha6qs1fvsa
   w==;
X-CSE-ConnectionGUID: AkRHeZhAQKa6t071kTv1qA==
X-CSE-MsgGUID: xLgg/5oCRy6PcHdt0uCWMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="48400857"
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="48400857"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 14:25:07 -0800
X-CSE-ConnectionGUID: 93TE9mwJQJGY7gsOUvuYlQ==
X-CSE-MsgGUID: HL/itPDDS5CSXMsjumZmAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="90121946"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2024 14:25:04 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 7 Nov 2024 14:25:00 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 7 Nov 2024 14:25:00 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 14:25:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rK7apo8HKeM7HyTmTB0ddBdi9VAwFQoMRAAglcBFDtQUd2mOCiQ5TGDhqekU39duPgXnl2Q/QaXhs3r0eljXNHqKOMmgYg+aks5DoZuXYcU5EMF59FNIq7CvU8A3KaxPG62Rruk5oOiPuUV9U4tQPGBlGkZADi9OJLCxfGvy5RphTZcgl6PIDJRkn8QzNnN/ZzUZc8MShZpOrhGGQMvbuTUXBvGNq87mtgwCd3FgIyCCPYx/6E36yFaBc7nJbxOPhaJxENyCr5OG0SuU4M8oe9qPFM/zsLH6AJLkpjpjF1wMY33SZmCP8hQCjEncE7UlB7w5DPHyuynNknxslpqUGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9OPd2uc4/9gNgtJUXKMKkG0qf1HPoI4Nuq5w4ZSmM5w=;
 b=VT7lU/GqcJcPISJTnQg/vidZST6DJ00debkB0sF90hXT2ziM3n/PUGw4tEQ6IjFA3JYlfABAyiWGacgea3jQ4Pt0hB0ENS+5Pe16GGXrl4uBgPmx0Q5LJYHg/rrn1JNz7F0kRTpn6Mo9LQjrp82uEkgcAOQou3DqsR+0YTR4K0Bewexg6qUH9MfxmMy1/DWVPGA002RiUvD9+cNt4Wqb6FrFkSyJRNV4byHElxNGP0FZ2CySr487WYsQfVekFlQtYCzuYKgJcl7GW+CUUYpwLlpVD0Umv818r2Ee09AgarxGVkmBekHOGeSes34sWAkqzQ3qkblgSuD2H5YkKjr5kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by MW4PR11MB7080.namprd11.prod.outlook.com (2603:10b6:303:21a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Thu, 7 Nov
 2024 22:24:57 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8114.028; Thu, 7 Nov 2024
 22:24:57 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "yosryahmed@google.com"
	<yosryahmed@google.com>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "Huang, Ying" <ying.huang@intel.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "zanussi@kernel.org" <zanussi@kernel.org>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v3 12/13] mm: Add sysctl vm.compress-batching switch for
 compress batching during swapout.
Thread-Topic: [PATCH v3 12/13] mm: Add sysctl vm.compress-batching switch for
 compress batching during swapout.
Thread-Index: AQHbMIESISE0FUMsYkiPsANVvfbhO7KsFYIAgABQmRA=
Date: Thu, 7 Nov 2024 22:24:57 +0000
Message-ID: <SJ0PR11MB56785626DD03165F04F995A9C95C2@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
 <20241106192105.6731-13-kanchana.p.sridhar@intel.com>
 <20241107173412.GE1172372@cmpxchg.org>
In-Reply-To: <20241107173412.GE1172372@cmpxchg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|MW4PR11MB7080:EE_
x-ms-office365-filtering-correlation-id: 8fe213fd-c5fd-497f-f29e-08dcff7b02df
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?X2zTkUWVwQRCXOGE6f0rwmmkgeyHimwND8sHTV9ZZGDPF/bTbWctPSeNjNkL?=
 =?us-ascii?Q?BBar3CY4n8cFGUvzoAestxs8rrpGs35aOZ0moT9RUXZGOs1M/Kks48lgmhpp?=
 =?us-ascii?Q?bb5jwoXaJTqpmXcs8HMazZDBH1MjJmfFxSP5Tc8FsuzzD2e4pU/qvZiAnI5Y?=
 =?us-ascii?Q?z2uBsIblgx/L97HaOnsjh//44tvuYuG4DFmR85BM/EfqGjjOuW9s/FMhcPAN?=
 =?us-ascii?Q?sLX0Y6ZjrsFS2bCLToW5cv3WvNnqX1VaaXGvrGSOFiX3yUlM8rlUpPLejNNF?=
 =?us-ascii?Q?4A1Caw2jwQWqGpYXDqwLWP7CL4GNHnKZ4ImDPTyiovONzsMpciqP6uPnTvtm?=
 =?us-ascii?Q?3qyMgjj2kpSkXk8AhR4AaFAc/6WQQommYpesjd2C+Ku5xo38N1dzV7Wfhtrj?=
 =?us-ascii?Q?hsUNBIZ6dHPhnH5iCXW3iOC3iABNY8evMTDUt+v7t/fa3aH5Uyg9A5Evus1N?=
 =?us-ascii?Q?M13QBtcP2GWn+mcEqW1nYYJzthA3Tn8TN1kQRihT7b3eESN2C2vz7EYwh3TA?=
 =?us-ascii?Q?ucy+Lvt5bULQDmJSvqNGhC8C7+KhhHPfBp5bF3VgE/W8pGZyug97jJhrqt+V?=
 =?us-ascii?Q?dzCoGCbceGT7IZeW4K4D0a8jY2w4zFdC0s7Vs4ekHtpWvdeuACo4LsqT+acl?=
 =?us-ascii?Q?A4KWtLdRl4S3eebNEPCMqoMbOKYzce7MKNASQwYpsBpHBH/zMHYB+SYxJEDJ?=
 =?us-ascii?Q?vJb3PQPATmfcNbWsoqFzURVkYhzmEdRRvVdb2rg/odrh/7mLqvfrfx/CZkAf?=
 =?us-ascii?Q?RnIp58yjff7IdvyPZ3L6l/Euci6FBRW7gydGCsMGgxBGCGkpjW2c85ShQoSf?=
 =?us-ascii?Q?L/sI+6A8TB1B5PNPJa/c0XDOcF/DOjRxl+ZjeQu5BBFjDEAOmUqfpsBUTDMF?=
 =?us-ascii?Q?RM2sHekDQAgJycjq4D1rCIpsCbl6BDHIEGzuYLR94LPy+03eQUpFgec/MTH9?=
 =?us-ascii?Q?pF970I0dukkTM5QRL6JnlHjM5e/1i1uv2AetQnnN2Dvi5HN6BIpVhvjJbXze?=
 =?us-ascii?Q?sZwIsdkms43IgRb/BTuzM1uXYkNAIRKyaFaHZegIEaidHEA2y0ZAgtOrVXZK?=
 =?us-ascii?Q?LkIxAgeJbO9Bg+L+Zn4/S96ebPXn+/uYJ/jK7C9W2c5YP3Gje7hkNm4fLRhs?=
 =?us-ascii?Q?2fRr1KtbgFHULWgEqfUM3ZQrFnFLJjDGwg1ltgpKiI5CzJ2Zcklz8hOGMRij?=
 =?us-ascii?Q?Rqu7XxDiXBOsymB9Uvcl/xJRXc/1wFoCpF4DDQIEiFEd5GWpvg4UcdZR7DLM?=
 =?us-ascii?Q?XCa2t0LWuv55XrK+mzGr83kYZifWfV3Rvye6nBRRdF00W9mCqOuTQL0wKHE/?=
 =?us-ascii?Q?o7YHFHh/B0OCRZPQqaVnnXyDMjFkvPEgZAU86chj4NQhSeFYgfmqXgSLxkgC?=
 =?us-ascii?Q?0mZFP5g=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7zBYqsCTZabCMj1knzR9/suOn6yH9YaRTluzJl0+bSRkAOh/FvkubN2gSdlg?=
 =?us-ascii?Q?J2D+kXhwxgKt3YZyjaHEKBL8KKWcYQs0M7Tjw9tLmZqfHEoNubz2nsjUWkhE?=
 =?us-ascii?Q?varZ+or2lYgDOTbcgDW31FnYg1QnWhMDx5Nx0f5fHWBvz7u1ASZ837u04IyX?=
 =?us-ascii?Q?mgx8fyJZRIpyJVTV8Bj+qbxFyyY1PoxC9rqCHIgo0EXXz2ed9S80rMI2PVzf?=
 =?us-ascii?Q?O/nR+qXzR2iK43aEOuZofZlP/R+rnJ7LdWSv3OMpEtAIYEf36cTAHsfdnGZA?=
 =?us-ascii?Q?u7LwHHWh/Xwu7AyVYh2bUNNtpDeot0rUOi15KZxluVQFra6zoCHZi7rfy23k?=
 =?us-ascii?Q?RpVvxW7xlRcCiNsuKhOy3Nt085ovECDMVNtfRYDhwS6xS4n8kDOmuH6YesCb?=
 =?us-ascii?Q?9Wmry+kJdrCtzB28P/v+UDV+F9z4nl453S3r5nhu/4X1HE2ieeL6jvDO395V?=
 =?us-ascii?Q?fuc1lSBWvW24iPGgxF9hV29FZju16Z6WeMUGljXA8zqExA5ML4Eg8ASAKbwr?=
 =?us-ascii?Q?CRhE06KRD71kfLVNO6JT1txP7bD3q+D9g1p/FEqaDqdjtdd/ACKQ6aLOStYE?=
 =?us-ascii?Q?5HfkYmEm4WMdSxTUIilvW/Xt/Hn7gmzrPKbWJr57o5dWWokc+oV3oo4PVoi0?=
 =?us-ascii?Q?OvbDnr26eRlew0+cgGx3Gb4Qa+s6ddruhxiR3Hokj6GYlvl45O8nP17CXB8j?=
 =?us-ascii?Q?/glS6nPyTAHtmWMT96kroJgwj2knMGdBrUMhS2+tU2retgEnVX+pdMVlhK4W?=
 =?us-ascii?Q?nE2zkZt2FkggxZ9XWcnkoaHcXxKBwDsIlLdXgE70KprHwDxgTc1uGBbPJlrG?=
 =?us-ascii?Q?ldOPi2OPk4urdrIFmTlpF/TZ28HDMLJRf8/Ed6u8XLR7Y9bNzWqm3mA9Uqrt?=
 =?us-ascii?Q?7Jv2nqbGdRts8k+vBre7EA3xaQdYY/pjC3rwXPkP7OsSXfsRngH/p5w9uMo3?=
 =?us-ascii?Q?Yl2Tv0F3vY5OJpuFDm5xI27/OJbxi0IMo0/tc2OBDnPhBnH3UUwoAErATz1u?=
 =?us-ascii?Q?bburmlr7bMnf5mV62cNsVSoitzn8htYt7wFqBIIfKz2CO1u9S4weUpvjlKze?=
 =?us-ascii?Q?9u/VZ/5FpF0wHncYFULTDv885bmnKc2CodbvBbnODlpwDCOsZzMARnO3tPlS?=
 =?us-ascii?Q?xxC1UY9+bwo04ihq7O/eV7ORkGGkLFLc31M4rcPF8K3SaG2toQCIjX83tM4s?=
 =?us-ascii?Q?NkhQLUZd+p44MoujVkJ2XXe3gVCV7a5aWzGuTGmlxcEY/vdDbx+jq+790VLj?=
 =?us-ascii?Q?B40GJOtW2FGI0yguXga9F4bijhtSyxEO+0GuiNr+bAS7W07RlG0qa4XVTqxR?=
 =?us-ascii?Q?120bY9uvoGHjGPngYgvUId71tyM+/xmTR/jwaEw1sN4wRQK2L7C7qmXgmRCW?=
 =?us-ascii?Q?qGE5jbG6g69x3UtjneeuKHTmQWrd2zEcAlkMlwktB/hMekU+fkiD/QR3mI7x?=
 =?us-ascii?Q?UCD04raatDIN1DIGz5cKbhdT+gqa3rq8j+lbN/EfOXTECZhYDBG7JfE4isvx?=
 =?us-ascii?Q?av6OqsIAbg3nhpNTo9f+G5cgTnoG5Mezs10ma/MyfIDj0z5RDxPxuUzqlUxP?=
 =?us-ascii?Q?0UtGPNRc3EWqpvSiNSfIN2sSqFp4qv/injHWChw/4OnkqsAiu9HiRRNAKJOG?=
 =?us-ascii?Q?dw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5678.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fe213fd-c5fd-497f-f29e-08dcff7b02df
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2024 22:24:57.4009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rk47GdrOySwmp+wXzSgTQQFDwiDaY9RH2fJlg5Ae761VlqJ8HQHLQH60sz+HzNDX7KO+3vWqhdF/YyVma0Y5GgpyqWUhvi7VisojB6Rer48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7080
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Johannes Weiner <hannes@cmpxchg.org>
> Sent: Thursday, November 7, 2024 9:34 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> yosryahmed@google.com; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; Huang, Ying <ying.huang@intel.com>;
> 21cnbao@gmail.com; akpm@linux-foundation.org; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; zanussi@kernel.org; Feghali, Wajdi K
> <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v3 12/13] mm: Add sysctl vm.compress-batching switch
> for compress batching during swapout.
>=20
> On Wed, Nov 06, 2024 at 11:21:04AM -0800, Kanchana P Sridhar wrote:
> > The sysctl vm.compress-batching parameter is 0 by default. If the platf=
orm
> > has Intel IAA, the user can run experiments with IAA compress batching =
of
> > large folios in zswap_store() as follows:
> >
> > sysctl vm.compress-batching=3D1
> > echo deflate-iaa > /sys/module/zswap/parameters/compressor
>=20
> A sysctl seems uncalled for. Can't the batching code be gated on
> deflate-iaa being the compressor? It can still be generalized later if
> another compressor is shown to benefit from batching.

That's a very valid point. I will gate the batching code based on the
availability of the crypto batch_compress() and batch_decompress()
interfaces in the compressor. I agree, this can still be generalized later =
to
other compressors, potentially via these same batching API.

Thanks,
Kanchana
