Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2137463A9;
	Sat,  1 Mar 2025 01:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740791882; cv=fail; b=djkyXajjfwxUPoLBy671wt1SaX9XTIAZrs25izaUpoTs45CPsYVbsjKUkS5/t/w0pkJpb8friOT6zzC5dM8VQJLcIHo0gaQJKwp/AAGhiO8x+HnZAYIwF4S/dB8BxAgIkCKyU9MBbd3okSG6Xw03JrMfo+7IzCPam+9sj6wZ6UE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740791882; c=relaxed/simple;
	bh=DzW3BLlt4MiuyKWSTuTm0pGpO6yuXPZq0+6uhhao+YM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZNjlReHbAxmt4s7Yd/KThjGhLTImCp2VHWiyEUqIm4hu7Q9pT8U8/5ouf4+iBRowSWx70OlODeyXwIhuTZ2dlwzjlGIsRsKdwZkhPFu6PcphdVtI2Cgn8W/XIyY3eEz/WpXglyB83k4MP2tmi+315HL4hu9L6Gb481doWvpqeB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cFDOBIOr; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cFDOBIOr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740791881; x=1772327881;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DzW3BLlt4MiuyKWSTuTm0pGpO6yuXPZq0+6uhhao+YM=;
  b=cFDOBIOrcKu65RG2LXe05f+IrHsFZmoIti/8LDjzn4w6EonoOGRlF9y8
   Py1xgGMRIBvPbckoLCuY5mAr4M4Is+TMlHM4WcLCbVZoW9OdoJkhewX79
   t081T4qEhO1wKU6W7DtqR2tTFNTLGKdhkDSibKlzCdBBjaCKnF8Dd9Iny
   DmPMaU9HZ2m0Ympc5JGmbD8uNbvUc1i8n7E0Xz2UL7d7IOxzQNmuKwu/4
   rXOqLA+9N6PJ4ok9HtoLcPjg4fGHZCpaog/SaE2gTSb+pNuG6rjR7jZ+d
   xqpbtkRKZu1vX2hDnVqu9N7t/a+8E0X1/rVw7G2Q6JW+nVSE3adQfrnQP
   Q==;
X-CSE-ConnectionGUID: WLPgmCCDQgqs51EknXPi4g==
X-CSE-MsgGUID: MDFeJBA1TOyTRBoqYJmZnQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11359"; a="41860231"
X-IronPort-AV: E=Sophos;i="6.13,323,1732608000"; 
   d="scan'208";a="41860231"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 17:17:59 -0800
X-CSE-ConnectionGUID: fwpG5yIoRxCztuwhR1xkiQ==
X-CSE-MsgGUID: KdDH+dyqS32LghwWbg8utw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="154662480"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Feb 2025 17:17:59 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 28 Feb 2025 17:17:58 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 28 Feb 2025 17:17:58 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 28 Feb 2025 17:17:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WlDsm6brTf+NZd8EGMBNyPPBYBR7bXHjzoU74V+UQfcgskGhB1AWcRceMowsx4YMfnfXtgqiqvWPlWRuFhq3alPHl8sOW+KuzwTORmniSbvzDis6yncoNWK+jNkA/Jo9yosZaByxUFQ5brWxes39s7eCRI0LEBZEls99zFmEd10qHoxtldZu3GYSZeuzVCgqSJSoGYOrCWwbFWqZ/Oi/BA9+EQBR5BhCbnOnvj8zunXaaXvKx4ovg7cEqPbepE1Sw2eIg8XTmFyumQSymvPisKPz/Q0qcrZylV/i+3TFQGohkroa1ZfUl6gy90HuBjxtq6p3PjXo/EflRRMvoiEKhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRP6Emh6R9OuedHcTXkyB6jKDeG6mZrJEP6s/3b0d8w=;
 b=Rb4y0vz0HmfIYWABeRclnLUKw6LaJQYXNSsq/mwhY7iH0HvqGWrIE4KL+BarXNcWrRnKvN5H1fcaPGhUhi1WrIfIQNAyw7aRBpMkjUpTwwGKt3cBKiJ8lLvI41CZqNzjohUbPX7P6ttZwwfWjt3P6JGGPF7z9V0hqc5abD1bIu+CZzmE3/PzHs9IfIXAFFqLHmpgIlRz51vizq5jAtMkbeXq7FNQZxp46ULE8a6eQs/7dxYLjzsnkibWFZhbwXJ85ZbfbbC84nikUWvIM0beLY1clZrKP1UHoHld8oYrtJGgJWpLAGkU3v18DHIQmIc2aEpgZhrK2p40tSXGGcP+FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by PH7PR11MB6548.namprd11.prod.outlook.com (2603:10b6:510:210::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.19; Sat, 1 Mar
 2025 01:17:42 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%5]) with mapi id 15.20.8489.021; Sat, 1 Mar 2025
 01:17:42 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v7 00/15] zswap IAA compress batching
Thread-Topic: [PATCH v7 00/15] zswap IAA compress batching
Thread-Index: AQHbiceg39kI/20AU0W9GEohTPKAv7Ndd0cQgAADMYCAAAEzoA==
Date: Sat, 1 Mar 2025 01:17:42 +0000
Message-ID: <SA3PR11MB81204DB5927750D24860FAEEC9CF2@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
 <SA3PR11MB8120AD2AD0A9208BDA861580C9CF2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z8JfA5eJa-HUbYO3@google.com>
In-Reply-To: <Z8JfA5eJa-HUbYO3@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|PH7PR11MB6548:EE_
x-ms-office365-filtering-correlation-id: e3e8da0e-4965-491a-35b4-08dd585eddad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?qINNafL1AYlhopR6GJ6iizZoQfnxQLw9cwld/0Y29fUB1h9hfu7mp9pUhUrl?=
 =?us-ascii?Q?bJc6rjiHFZaZ+OWOjf015bKj4OoBUwJJvbwY0VvjzYeHb98VEXz3B9kc/xAn?=
 =?us-ascii?Q?vblEjkyCiPUUz29kLgK2yxBh8zOx3uO8ssBPplkJz4ZhQ5j2JCL+FaylQNxD?=
 =?us-ascii?Q?Srr28BOmjpDRXg6+SNXI3zu6NP+CDz+rPk7A0UqSkIzXpH+u6Y1XmI1ZSx9f?=
 =?us-ascii?Q?6DAJ5xZRJVABlZ0k7Vc3WXVWvi9y4xTPWkQSy6tTQxTMKXGQt4O6DR/pXoir?=
 =?us-ascii?Q?IEbke9BHbJ0RBaxBzCNVEEuot8gpUKiUCFm740LFVtWJogxtExGGV9FDMiZO?=
 =?us-ascii?Q?e4ITBDyDpKKMG6VTyuPj5VkPolKarge9W8QLlPRC+sqYmyuRneYEnaE6ojGd?=
 =?us-ascii?Q?N3L4mTrI/mHWZlfx9fKcD51ka+GDIQ+3xj2K+qHJfkP1LKeYjoAtC1UhrnZ1?=
 =?us-ascii?Q?0P+LqfOOBllcmE4718Ga7GwCvQXcrAY8Od8IG9bpva1qMZplVrdnO/NtC+hq?=
 =?us-ascii?Q?C5Q+8VuciroLRb0/Uiw1UTkw6kZ8mIypIwtsimrAkM2/1feyrmpx6Pr0Vomp?=
 =?us-ascii?Q?vLy4mRNgJddvnutrSYWjI/wky68M/0UaypNrr/frIHU9W+KteJvcl3RdsX51?=
 =?us-ascii?Q?lZndHxo2i8pTzWTukklRk7o8VASahGFqiWe0Y16nnFa3JcHrLEKfoYbne2bv?=
 =?us-ascii?Q?cidrVxr91rEsE0wfUmeWb38F8jAN3UeGUx+P0O1QJeoIuy99uVzAZtr5TEgD?=
 =?us-ascii?Q?xJmInvrDu+V8FCCMjYe9B7ge5RbKUT+gaAC/yLzViPgICV9qOH9+XSRPlSzv?=
 =?us-ascii?Q?PGJnCaxBQmj+n8osVAwRwSSZIowIRE2I0z04V6pk0Nqr69RnaSbVWOii3s5X?=
 =?us-ascii?Q?KRgEUQQuhXzkMv/6JAPAybnbnlZx71KaRpHcHUfbc42+aWgWtZnsN3sRwgYQ?=
 =?us-ascii?Q?x21+G22duB4YJgTNrIVPF5muaIy1f6yJbEM6PxFIEuqSIfxRjFq5N9nm7tct?=
 =?us-ascii?Q?7kJb5W6SAt3sm1V2ivFoX2wX2FAg7wkp9Ih2io4A1sN/E+8vqQR3QCRtymAn?=
 =?us-ascii?Q?7mcg8ibn9j96dDGm9O+fZXrHfoeBWOHTQDZc3/CJDzscmO9fUgOmN8qaHlHl?=
 =?us-ascii?Q?IKDMpO+w1Gb5CT0MYi+SAwKnX+DNkpSJIETpamqCHS8L/04cGnoqx7YtN2y7?=
 =?us-ascii?Q?QbkR0mPip1Z9XP150KxpMKadbH2/PhqBQi2f/1ZQPZ0JFMQbCLDJH/E1bkUx?=
 =?us-ascii?Q?Xv63jraI4ySsJYv0RTaKKOw+MqJswNk8tPgCY51CYpdlLzoObw3H84zFrnIw?=
 =?us-ascii?Q?dVSQwZTZ6SBikZ2ESjrvwJkE3DQ+4sh7v4RqyMlzr3xios5U8UyOeCrrTBD3?=
 =?us-ascii?Q?Qg4JqkPG/UL9cRqNNSfpYEBLjjP8onMkuAtErd4vya2BuVvn6jkRZhYgMryK?=
 =?us-ascii?Q?of41kXlarRdEbgbEkCtdWhce1lboIVrU?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6pH/Rl00xlvpYFOHaDfcAVz0SYdhMtxa07OdjN27tlUVqWw5g640PZ1UtCGF?=
 =?us-ascii?Q?yDvgjVcr3401NrIz8qoyVzy2cQgFZTHL7Y16l7sS152X3AfV/+5Y3XzrHChp?=
 =?us-ascii?Q?434MbxepGtITGAhJ8EygSya1mYPDqiWwQhS2yTGgr9ygsbL9dtUEDoTwS6eR?=
 =?us-ascii?Q?U46/wOwLeBuXR5qyx1Y29joP1ztPND+a3RuTbCdeIRPKr5V7DGm5HEs9kfNe?=
 =?us-ascii?Q?bnFFx2fHObNX+JQbZZL/L014mf6Ee+UugdRL4p0r+eVHc67qhBaFkSimVJ5/?=
 =?us-ascii?Q?POCmlNf2a20gy1wcjoDYeRvynWFuwPP3re+YJ5ts3+fkoM66ATo3OX5W2Wh1?=
 =?us-ascii?Q?avE6RP3zzTZG7AP+0ykRDmnRFi5vkqhLAO18xOA0zdOq68vdmAV+4GIaDrgY?=
 =?us-ascii?Q?zbbFV6D6leryEM0opQIPfa9FFQN2GDZG6M1J2mtIP+d3Gpx9BvX8d/wJdYAt?=
 =?us-ascii?Q?ZIRjDYCxOXDZu6TmvfA9hF74goc00EXbKCSHUaXmayG1X2ADe4HI40I9hvtR?=
 =?us-ascii?Q?nSdHF821hd1uDg6kIh2XCHwJqoq93g6ItHAaldJx5eED8MgW2VPpor34ulXk?=
 =?us-ascii?Q?mW3pwyqEjqIPoMD+XQ+DgEG9lBOmVN/hW1J9uLScFhWibOw7cxqOzBr4/GvD?=
 =?us-ascii?Q?4Deuz5UIH0mXzyFzVJxPvXWTfc3EXNUGrfupmqwJ0F9wC2RsOOY0IETB7LlG?=
 =?us-ascii?Q?7yjQ/Avrzz5mZfQgpkKN9C6XUvlnzBgKMf8ZgIXUF16jstqP0sMR4yY4tdNA?=
 =?us-ascii?Q?DISmaF5Gz1j17oj/Dx3/nNUc5AsMZtflGBtAWJJ9MKxt2NsC9yTJDgmXkrq5?=
 =?us-ascii?Q?SgwRsk7M6ofmSWlxRjmYMDuJq18LCJHd2J/y0YWHdl6nIwimoqFYLmcWf3Pp?=
 =?us-ascii?Q?ExCU72VFIfw64NO3i9vshu6csLG+l0SF2t76cUfZE8fKVwv5G7SE7CJDHGgg?=
 =?us-ascii?Q?47AlpG9YixN4JTqqEtmtwXNYWp65qBu0goGjOvpXF5n9Rw4lmCvb3nCRx/bJ?=
 =?us-ascii?Q?1sGHUUywPI/E0+8lPXRLDo8jA4X+q9nPnSi1ngi1Dos2oGDfbtOqAatIMj4B?=
 =?us-ascii?Q?y4CklYrKeOpkIzmgVqnah3A4PLT6YfDSYHptTS0LUIH+yg7VdO6eXmrQJ25g?=
 =?us-ascii?Q?yx/swsNCS4ba2IvIvnmNpbLI9XeHIv3oRvDFLVpLijLMwVTCxzWWN/FvRVmx?=
 =?us-ascii?Q?r5MbwBYWcDlmJnE7hmwvwd8tCVLukoIkw6ZdhrMmvef8nh8rvX8bVRfIczP6?=
 =?us-ascii?Q?5Yb3MvdtIDu2YXhUKReBJsPFwDu5tLDbbd2kW/9p6QPk6gySJqxFVGzApHCY?=
 =?us-ascii?Q?53nLOWC9NdF4K5wihcVMYgCOd0pIWvd9Nx3yCSANhqkZ3zhGWWWP5FpCovLC?=
 =?us-ascii?Q?nxlJ+KvkwSTQGXnH0WSEr2ouH5eunDUuhYDNuDKnp94iDVQpLTFt5M12pORw?=
 =?us-ascii?Q?J/krvYw/3VMtHJLRK4DB9fOKUZXZRqL2o6HRJmydEruBD5ijSD29X0atH2pu?=
 =?us-ascii?Q?9H88P5x2NIMIwC8wQqPZZTpEBrJcziQHvjZsdvs0HUKHixWfFliz78j7Vg33?=
 =?us-ascii?Q?vzq1V9J0KZTagM2sq34dpFr3RWjp5NP+hRzVIY5YBi1NIhke4FkOc3Rl2n/K?=
 =?us-ascii?Q?zA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8120.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3e8da0e-4965-491a-35b4-08dd585eddad
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2025 01:17:42.5515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IyumFC+28BgYuzB0d3S79CwAYNsYNpitt0rUgaqMSZjQGsVSHVQ/UOx2wqQ67hMmdNEdbePoFfCkalcDskrlLCMJ0mQ38hUl5Ht8iC1wWmg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6548
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Friday, February 28, 2025 5:13 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.co=
m>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v7 00/15] zswap IAA compress batching
>=20
> On Sat, Mar 01, 2025 at 01:09:22AM +0000, Sridhar, Kanchana P wrote:
> > Hi All,
> >
> > > Performance testing (Kernel compilation, allmodconfig):
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> > >
> > > The experiments with kernel compilation test, 32 threads, in tmpfs us=
e the
> > > "allmodconfig" that takes ~12 minutes, and has considerable
> swapout/swapin
> > > activity. The cgroup's memory.max is set to 2G.
> > >
> > >
> > >  64K folios: Kernel compilation/allmodconfig:
> > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > >  --------------------------------------------------------------------=
-----------
> > >                      mm-unstable               v7   mm-unstable      =
      v7
> > >  --------------------------------------------------------------------=
-----------
> > >  zswap compressor    deflate-iaa      deflate-iaa          zstd      =
    zstd
> > >  --------------------------------------------------------------------=
-----------
> > >  real_sec                 775.83           765.90        769.39      =
  772.63
> > >  user_sec              15,659.10        15,659.14     15,666.28     1=
5,665.98
> > >  sys_sec                4,209.69         4,040.44      5,277.86      =
5,358.61
> > >  --------------------------------------------------------------------=
-----------
> > >  Max_Res_Set_Size_KB   1,871,116        1,874,128     1,873,200     1=
,873,488
> > >  --------------------------------------------------------------------=
-----------
> > >  memcg_high                    0                0             0      =
       0
> > >  memcg_swap_fail               0                0             0      =
       0
> > >  zswpout             107,305,181      106,985,511    86,621,912    89=
,355,274
> > >  zswpin               32,418,991       32,184,517    25,337,514    26=
,522,042
> > >  pswpout                     272               80            94      =
      16
> > >  pswpin                      274               69            54      =
      16
> > >  thp_swpout                    0                0             0      =
       0
> > >  thp_swpout_fallback           0                0             0      =
       0
> > >  64kB_swpout_fallback        494                0             0      =
       0
> > >  pgmajfault           34,577,545       34,333,290    26,892,991    28=
,132,682
> > >  ZSWPOUT-64kB          3,498,796        3,460,751     2,737,544     2=
,823,211
> > >  SWPOUT-64kB                  17                4             4      =
       1
> > >  --------------------------------------------------------------------=
-----------
> > >
> > > [...]
> > >
> > > Summary:
> > > =3D=3D=3D=3D=3D=3D=3D=3D
> > > The performance testing data with usemem 30 processes and kernel
> > > compilation test show 61%-73% throughput gains and 27%-37% sys time
> > > reduction (usemem30) and 4% sys time reduction (kernel compilation)
> with
> > > zswap_store() large folios using IAA compress batching as compared to
> > > IAA sequential. There is no performance regression for zstd/usemem30
> and a
> > > slight 1.5% sys time zstd regression with kernel compilation allmod
> > > config.
> >
> > I think I know why kernel_compilation with zstd shows a regression wher=
eas
> > usemem30 does not. It is because I lock/unlock the acomp_ctx mutex once
> > per folio. This can cause decomp jobs to wait for the mutex, which can =
cause
> > more compressions, and this repeats. kernel_compilation has 25M+
> decomps
> > with zstd, whereas usemem30 has practically no decomps, but is
> > compression-intensive, because of which it benefits the once-per-folio =
lock
> > acquire/release.
> >
> > I am testing a fix where I return zswap_compress() to do the mutex
> lock/unlock,
> > and expect to post v8 by end of the day. I would appreciate it if you c=
an hold
> off
> > on reviewing only the zswap patches [14, 15] in my v7 and instead revie=
w
> the v8
> > versions of these two patches.
>=20
> I was planning to take a look at v7 next week, so take your time, no
> rush to post it on a Friday afternoon.
>=20
> Anyway, thanks for the heads up, I appreciate you trying to save
> everyone's time.

Thanks Yosry!

