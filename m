Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9967158545;
	Thu, 13 Nov 2025 23:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763078119; cv=fail; b=NIkTkXpB+TD80XML1oWPxtI4bc5U+U6ITj/Q54IhWXOngNsZtksZ/up0/BBVCqfio/vLrPV1gPmsdYrM7s1fa0uo1/YVk22y7wVYZzvXADdw5Jv3MHFqn1nGss/GVJX3V7FZSYU0g29rBt29bMFKVDNaWhS2ILCxuxNiVsScv5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763078119; c=relaxed/simple;
	bh=heJb7VRipS5HpseOdpijwnIpuC1EEwpEjtOZoEOiaNY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OlwW3EASozMMM2+ugwe74kLbZja5HxV3ys/qa+kphLC5fLZWi5Vqi1mqYiA9/uCzr1FlJQZyAJIsOFYnbLtjLumuAzN+btjQtZtgCkOmFch1eCdmXgk0/FndOC9y50lq0SPyqO4y3uDeH/QyofGgujpyIxfg1zOi427YOVN5v1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W7yq1zql; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W7yq1zql"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763078117; x=1794614117;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=heJb7VRipS5HpseOdpijwnIpuC1EEwpEjtOZoEOiaNY=;
  b=W7yq1zql7KQYuMH+HUrBN+OHdqpcPvB2uYSL+brfbB4cBGYs/pU+wlHL
   doWJgOp9nUGoWQNJxjLFTB9bF1OAOomJzzwn5dSsvD2gZHmZn19uSixir
   4MAJJS0A/kyPlPT8XszJqI1mpw1WE+kZReox1O1HcR6AV5ad3KNq+sJoe
   nyd7IPRGMZgsfRrcFqkRmPvRtxaGtz6Wl00SbGpSBySvVVsUEvMW7YrHC
   /9m5taUO2pZZDeBR0NgpuygJrA1OizNLaP1CGmLtYpr6ETvuGFb/z2Spf
   HFyQobnjan2lLV1FsPJ5anHX9ia09/HKlRMA6Dgfdr0neCPzy/j/jW9i+
   w==;
X-CSE-ConnectionGUID: BRJktQA/SpiKw1fD/9Ls0Q==
X-CSE-MsgGUID: Hbc2V5kQTUelNkH8N5x6qw==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="87816843"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="87816843"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:55:14 -0800
X-CSE-ConnectionGUID: DcbM+8L1R5C9KyWYsttycw==
X-CSE-MsgGUID: v7W3OG7UT/Ond6p7gP9iJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="189883441"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:55:14 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:55:13 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 15:55:13 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.35) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:55:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k1SlpP7EGkfZyMh5/mY8t0xKUcYzhDd+rdePSlgqXDMS4g3BWvJvrXsIQ4wDDshcF+z1IwmJM/EIWImgUEuV6S+ioJUD+z9EC/MdYqFemtGz2wXqzDABHJxYfkHIRqVvdAzeuoKkEG1tQZyg4Di/BUPELroq1saJ0FpbGHdONl+Jdcj4RHZpobfesFzF8LBWjiQ57iMlJxDmM1GQ2ABYaFnNn+kEAgPU/X15eu4C5qGyytLsdpIt+LZF8U0oggdfMPnTSl+0HAweJyRKu8YFR6DBjLLFcDMVnlLUqavsaPcWxPm38mtZWeoXZ39PylBT8orIZtQjMR+2X6v1q3BoRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DYoqR0TdGSVG7bOTdbnyhhETO2mxS+IEXorH9dr56+U=;
 b=ihkYZW/AG/FfLdkZQO0ZSMZieRkBSwAKxcK0yXhvvWsWDVgbpNW6LQeAZPd3Aa0A19xqPh4ZesFlDeBlHcw0kAHNbaDl5VlxQTdmSgNYvseqqYvn9TsF/231/tvEalcUkEGTrn8G1StEuN/UWj+t6BtR9DU726OdNv/Gikkb66en1Dkby7y/h8XfWIQum5MCdhDYb4VTytAsJA37waQY+1dsH5U/i4Cl2sPuF4Q404ZTa2mw/majkmOac+M8D/BnicqxNiN7fpmwbdxjkV1W7YBs3bzuwSTF7jIhksW+b7+p9vaFi7AWC6wS0omICS/NRyvbPpMDwlG26NoYPixn7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by IA4PR11MB9369.namprd11.prod.outlook.com (2603:10b6:208:565::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 23:55:10 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::1871:ff24:a49e:2bbb]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::1871:ff24:a49e:2bbb%4]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 23:55:10 +0000
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
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "sj@kernel.org"
	<sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Topic: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Index: AQHcTWs0Qo3eNl0w/UamTXF2PMbCz7TxL9wAgAAcuzA=
Date: Thu, 13 Nov 2025 23:55:10 +0000
Message-ID: <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
In-Reply-To: <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|IA4PR11MB9369:EE_
x-ms-office365-filtering-correlation-id: 6b85215b-adc3-4fbc-a598-08de23101459
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?t6r9hvw8zk/H7iSRRsJ5S1QZ7efvyjrkpYO8Ev9U0v/HsF1m61mBR620x4hr?=
 =?us-ascii?Q?L9ZfQ8Gi3XKUaOJ2OYyPkT3GV5vhKCshKaOcsFYVtsRHvz1ZTUbBGUEGlqiL?=
 =?us-ascii?Q?i5T0cD+Q2bjKtBi4vaFVzc9wSoZtsyTnXagjX5COidlUFLtXgUVezHUbZgIL?=
 =?us-ascii?Q?4i4Z1yrXxDyR9UYNIbnuqHN9D4u+OPVjeGCy6MCKIznzPMf8RJD0v5pm80+f?=
 =?us-ascii?Q?dbHAD4gfPeSvS6IQKYDqreKWj/E2pZwG14gmETcSfsRzeIZ9oIUmmYxQRE9k?=
 =?us-ascii?Q?/dL2i6IZNljXjTzx3L6YxpzGCIOjya26s33u5efu/WTgDWMCUwbBcEN4Stf8?=
 =?us-ascii?Q?+IkO+Iyk51ZMQr3rdkODR0uuHEtoVXUEXA0Sq7MbwvxznLgUerQcFyOaQH67?=
 =?us-ascii?Q?y/b6Mol0W2g4l9wlAcFZBMS4wdduJpcmBNBouX1lLqxXK6mzZX6crhMT3oIJ?=
 =?us-ascii?Q?hZdzgvIS6dd5PGdQ847c6cQp/IjFhFDDT4410JTDu25UPg1co8i/kG1jCEc6?=
 =?us-ascii?Q?WtY5aM+Ar99V4JhNMnQb0MLAXuJNK4rAqJJ6XPcXQzuKtlH0+dt0T/vCUbGC?=
 =?us-ascii?Q?Hvmj4Mdv2zV0L9YyrLbMkxbEVbNnBbXfV/wI6fzTBgg8BQrJdQUdiyHW2dA9?=
 =?us-ascii?Q?m2/X4+//7meYj66J0snDffUZnPcj6vNjnUmUipqhsAYvoC3oh6wTLqivmSY0?=
 =?us-ascii?Q?vwe2mQHRbBkORyADb138NsZl1oICrpkyQFVRdjFArv5HZb2Ey6tc0Lf2ujLp?=
 =?us-ascii?Q?sCl+TnKaUrbK0r5+fib8jd+mpeH65RjqNeemIjMGaFZ3CdxlBvQKTm6Irhdi?=
 =?us-ascii?Q?tq+qRkhCwCvbCRUHKVt+ETZKDpXY0PfUFrJpzJ2YAzF0RvDKL5CDXvis7iue?=
 =?us-ascii?Q?zn5ikuSBpELQaBFCSAF5FFu3/1sNQcDL6c3w780Fs4gn/b8Mng15Hauyb9sA?=
 =?us-ascii?Q?VVSBnwlsgqUqRSf5IsTwEmraC6TVKCVarLFbqDnemhNUtxltEALzTD2MFzDd?=
 =?us-ascii?Q?yP6iYneqGTwnb84S/GbYhzi+wmUvdFIkoLfXepglxnBLWEqkpUyJAKtKBpTk?=
 =?us-ascii?Q?sCbJNBZggMi5e5uU468OX4RV4LMOabY/KMLk44nLvVM6kR/XQAMK+foAiejg?=
 =?us-ascii?Q?Bnk4glDoAkoSjgcCX7mMyewNr/lvj/0+tdvWwqArAZAFnYdb3BZ1qzJk73Uy?=
 =?us-ascii?Q?Zzhacu6pPwDR3ic4U7/8XwBAKywyoBYr6uxEX5nhVjZjdDSiFIWZ5F9TXXzU?=
 =?us-ascii?Q?OWQfHMVsJEXyX+QHXUlRVAdRbOm/E7O+1uHMFDlM2xqYb8R02uQLFpyZjY54?=
 =?us-ascii?Q?leUFbimJaSp87zdqmpbIFYeSCIoRuPmQ5j2xq5qFlOGZnTaIotwrU6QRI0l6?=
 =?us-ascii?Q?MzzLtRheboCv1c4oh61U7pf8rtzc9quvh2Hy2jCqo67GrzzWAht4OMKQLeIh?=
 =?us-ascii?Q?fFTXRRXhl639DuDHKUaXVHli23e7wzg8+GMWO0T4xYZWht17lfUxBw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mBfr9r9GdSHGg6Pb5RDSZiwg75BMT/Vxdifz0n1DccCZQOYk7zp1s0xjl6l8?=
 =?us-ascii?Q?G7+4DgVoHR/K2Xxz5c2somLM0xuI80fgcBdKsJ/Cv3kLcUqVBWJQGJ2mG5mU?=
 =?us-ascii?Q?ccZ7//mQJHV6+fsW6hWVyOv/WhX7yP0kjIyYVtRWlvJL2+7BIY5sUpniWAX/?=
 =?us-ascii?Q?/8yW0f66ZdAHhFga0WTexUwk0GssIfsb5Cy6LM1OGKaA4ub6dNT3Qw6NqzTq?=
 =?us-ascii?Q?JSYscaD+o3s7rapWNnnZsbAfabt7CxHHIWswuNqAWH2Lq0gITS1NapJZb+Rw?=
 =?us-ascii?Q?aLT7nlRqkL57+gWOnw2yK9A/9tADXGdGY2CePC6ua/4TnmeQISUSaoaKOVLh?=
 =?us-ascii?Q?lbOdczEaF92nxLZMzOB0IBRB3WT3eya/qsT9SZMFpgapwOXkD0FXKRdTS3cK?=
 =?us-ascii?Q?PYaxVdMzOf1bSJYtcaGm9mXDDOSQ57po8lEaezAsO8Nk8dZaY2vsGK1LXZLs?=
 =?us-ascii?Q?CZ2q/tGgIRzqu8DwsozwxePcKv8pfdVgfV/D1q8oga9SUPlD1gT2BPlfBKW6?=
 =?us-ascii?Q?dc0tjHxDNiErRHQhQ1wHLvMUImBJSdeAGXM/miEup7KnCy+VcAdbe0rYznvC?=
 =?us-ascii?Q?YvmE4bgaqK0voEmEOYjUwxm/cbYRg+5OnXKmkFaCkKe59K/1vUjvWtzWQmd/?=
 =?us-ascii?Q?hsDwfSf7nVweBPDP4nn41KbAsXFZORUgkhOP37kBG0hFOSTxoIP8Sr7mCsEQ?=
 =?us-ascii?Q?/Bnqopq8HSHP70EOTvpV1jAkHTPVzPQOxGZZUnoyK/KZSlG+0mmleNPOFhgO?=
 =?us-ascii?Q?qkR9atARJHlMGsDVrNBaCUKUjh1HuhT6aDS6yldKLypcjeYIK0ZhPZzMTxeQ?=
 =?us-ascii?Q?OBA7e2KrQ/wcRHL7SDNWHz0Mjhhtyi7WoDJ48nBLIRVtyaw2aOGydDkyb1TL?=
 =?us-ascii?Q?5T/CdGLmUPVOsAZjVwfPQJDu9ZJ7xcGeBJGkrXP+tx5pbvyOhBNsQJ+rjPid?=
 =?us-ascii?Q?KHLsUndqF60xb4/asQm5Hf8xVVTljcYqz2mXsUlonTAlo+vqcY4yYk8Be/Qt?=
 =?us-ascii?Q?9OFJ7q1CvXAzVi6w5F6h49axfroJmOITStk6jUCN4Nl95renHlX8nB+6AcBx?=
 =?us-ascii?Q?k3DghfomXBH+V4+ohKahZFf1D5WBmyeoDmG9JbUhoIHydQsKpBJjFk++ku5e?=
 =?us-ascii?Q?EL2UuzLqa+veqtUFTSkzOmiKZP4a+co48QYZMjNJUeVfBymW6EgfqMqpweuK?=
 =?us-ascii?Q?wXig/4c7zJuMohEhBQzzAXyZd2VUbR/0kHIjCohbezM5J7DybmCdZoroqzlC?=
 =?us-ascii?Q?UZO3GjmwfrTZNzdXuc0DVHSRfqcfMl3p2maS3yzfgGnes7TYD3wfYG+Nv9kZ?=
 =?us-ascii?Q?FLXLpAD9K/3fDtKiMe+1RmYfvWUg+r67RqmAwbqt32J8wKi0qW+A20xAEN3J?=
 =?us-ascii?Q?DV+POVk1Xvcg7XO+7ZHADDAfo3PD4x5VPokK6K4zjbPSKfMPbiCtY8rRbhVg?=
 =?us-ascii?Q?I4X/FQgrbJfkvZ9OqF6pK/MklRiGMz0MFWLe/Lo/DvJN0GpuqW2V7XeimStx?=
 =?us-ascii?Q?BIolVvmqvUGagG+AT0e/B+edIK7ACmeKN9ZDEfaKGYdhFkq09VmF5SNI3jV0?=
 =?us-ascii?Q?S5c051Yr5k66+XyJ+fFuIZplRWt3/HeKXkWcryqnH1bx77KYXiUIsB3go3IO?=
 =?us-ascii?Q?Cw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b85215b-adc3-4fbc-a598-08de23101459
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 23:55:10.0875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3y7TgrtOnmun984zX0KCdwVbeC1SICdBS1JYLVPJdFxwnkUYkLDvDw49DxMWE5OpIp1oT+HMipwWPAxaYQDIOdeKPpmkVhLW8uY+l7PFYXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9369
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, November 13, 2025 1:35 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>=
;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> compress batching of large folios.
>=20
> On Tue, Nov 04, 2025 at 01:12:35AM -0800, Kanchana P Sridhar wrote:
> > This patch introduces a new unified implementation of zswap_compress()
> > for compressors that do and do not support batching. This eliminates
> > code duplication and facilitates code maintainability with the
> > introduction of compress batching.
> >
> > The vectorized implementation of calling the earlier zswap_compress()
> > sequentially, one page at a time in zswap_store_pages(), is replaced
> > with this new version of zswap_compress() that accepts multiple pages t=
o
> > compress as a batch.
> >
> > If the compressor does not support batching, each page in the batch is
> > compressed and stored sequentially. If the compressor supports batching=
,
> > for e.g., 'deflate-iaa', the Intel IAA hardware accelerator, the batch
> > is compressed in parallel in hardware. If the batch is compressed
> > without errors, the compressed buffers are then stored in zsmalloc. In
> > case of compression errors, the current behavior is preserved for the
> > batching zswap_compress(): if the folio's memcg is writeback enabled,
> > pages with compression errors are store uncompressed in zsmalloc; if
> > not, we return an error for the folio in zswap_store().
> >
> > As per Herbert's suggestion in [1] for batching to be based on SG lists
> > to interface with the crypto API, a "struct sg_table *sg_outputs" is
> > added to the per-CPU acomp_ctx. In zswap_cpu_comp_prepare(), memory
> is
> > allocated for @pool->compr_batch_size scatterlists in
> > @acomp_ctx->sg_outputs. The per-CPU @acomp_ctx->buffers' addresses
> are
> > statically mapped to the respective SG lists. The existing non-NUMA
> > sg_alloc_table() was found to give better performance than a NUMA-aware
> > allocation function, hence is used in this patch.
> >
> > Batching compressors should initialize the output SG lengths to
> > PAGE_SIZE as part of the internal compress batching setup, to avoid
> > having to do multiple traversals over the @acomp_ctx->sg_outputs->sgl.
> > This is exactly how batching is implemented in the iaa_crypto driver's
> > compress batching procedure, iaa_comp_acompress_batch().
> >
> > The batched zswap_compress() implementation is generalized as much as
> > possible for non-batching and batching compressors, so that the
> > subsequent incompressible page handling, zs_pool writes, and error
> > handling code is seamless for both, without the use of conditionals to
> > switch to specialized code for either.
> >
> > The new batching implementation of zswap_compress() is called with a
> > batch of @nr_pages sent from zswap_store() to zswap_store_pages().
> > zswap_compress() steps through the batch in increments of the
> > compressor's batch-size, sets up the acomp_ctx->req's src/dst SG lists
> > to contain the folio pages and output buffers, before calling
> > crypto_acomp_compress().
> >
> > Some important requirements of this batching architecture for batching
> > compressors:
> >
> >   1) The output SG lengths for each sg in the acomp_req->dst should be
> >      intialized to PAGE_SIZE as part of other batch setup in the batch
> >      compression function. zswap will not take care of this in the
> >      interest of avoiding repetitive traversals of the
> >      @acomp_ctx->sg_outputs->sgl so as to not lose the benefits of
> >      batching.
> >
> >   2) In case of a compression error for any page in the batch, the
> >      batching compressor should set the corresponding @sg->length to a
> >      negative error number, as suggested by Herbert. Otherwise, the
> >      @sg->length will contain the compressed output length.
> >
> >   3) Batching compressors should set acomp_req->dlen to
> >      acomp_req->dst->length, i.e., the sg->length of the first SG in
> >      acomp_req->dst.
> >
> > Another important change this patch makes is with the acomp_ctx mutex
> > locking in zswap_compress(). Earlier, the mutex was held per page's
> > compression. With the new code, [un]locking the mutex per page caused
> > regressions for software compressors when testing with 30 usemem
> > processes, and also kernel compilation with 'allmod' config. The
> > regressions were more eggregious when PMD folios were stored. The
> > implementation in this commit locks/unlocks the mutex once per batch,
> > that resolves the regression.
> >
> > Architectural considerations for the zswap batching framework:
> >
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > We have designed the zswap batching framework to be
> > hardware-agnostic. It has no dependencies on Intel-specific features an=
d
> > can be leveraged by any hardware accelerator or software-based
> > compressor. In other words, the framework is open and inclusive by
> > design.
> >
> > Other ongoing work that can use batching:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > This patch-series demonstrates the performance benefits of compress
> > batching when used in zswap_store() of large folios. shrink_folio_list(=
)
> > "reclaim batching" of any-order folios is the major next work that uses
> > the zswap compress batching framework: our testing of kernel_compilatio=
n
> > with writeback and the zswap shrinker indicates 10X fewer pages get
> > written back when we reclaim 32 folios as a batch, as compared to one
> > folio at a time: this is with deflate-iaa and with zstd. We expect to
> > submit a patch-series with this data and the resulting performance
> > improvements shortly. Reclaim batching relieves memory pressure faster
> > than reclaiming one folio at a time, hence alleviates the need to scan
> > slab memory for writeback.
> >
> > Nhat has given ideas on using batching with the ongoing kcompressd work=
,
> > as well as beneficially using decompression batching & block IO batchin=
g
> > to improve zswap writeback efficiency.
> >
> > Experiments that combine zswap compress batching, reclaim batching,
> > swapin_readahead() decompression batching of prefetched pages, and
> > writeback batching show that 0 pages are written back with deflate-iaa
> > and zstd. For comparison, the baselines for these compressors see
> > 200K-800K pages written to disk (kernel compilation 'allmod' config).
> >
> > To summarize, these are future clients of the batching framework:
> >
> >    - shrink_folio_list() reclaim batching of multiple folios:
> >        Implemented, will submit patch-series.
> >    - zswap writeback with decompress batching:
> >        Implemented, will submit patch-series.
> >    - zram:
> >        Implemented, will submit patch-series.
> >    - kcompressd:
> >        Not yet implemented.
> >    - file systems:
> >        Not yet implemented.
> >    - swapin_readahead() decompression batching of prefetched pages:
> >        Implemented, will submit patch-series.
> >
> > Additionally, any place we have folios that need to be compressed, can
> > potentially be parallelized.
> >
> > Performance data:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > As suggested by Barry, this is the performance data gathered on Intel
> > Sapphire Rapids with usemem 30 processes running at 50% memory
> pressure
> > and kernel_compilation/allmod config run with 2G limit using 32
> > threads. To keep comparisons simple, all testing was done without the
> > zswap shrinker.
> >
> >   usemem30 with 64K folios:
> >   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >
> >      zswap shrinker_enabled =3D N.
> >
> >      ------------------------------------------------------------------=
-----
> >                      mm-unstable-10-24-2025             v13
> >      ------------------------------------------------------------------=
-----
> >      zswap compressor          deflate-iaa     deflate-iaa   IAA Batchi=
ng
> >                                                                  vs.
> >                                                              IAA Sequen=
tial
> >      ------------------------------------------------------------------=
-----
> >      Total throughput (KB/s)     6,118,675       9,901,216       62%
> >      Average throughput (KB/s)     203,955         330,040       62%
> >      elapsed time (sec)              98.94           70.90      -28%
> >      sys time (sec)               2,379.29        1,686.18      -29%
> >      ------------------------------------------------------------------=
-----
> >
> >      ------------------------------------------------------------------=
-----
> >                      mm-unstable-10-24-2025             v13
> >      ------------------------------------------------------------------=
-----
> >      zswap compressor                 zstd            zstd   v13 zstd
> >                                                              improvemen=
t
> >      ------------------------------------------------------------------=
-----
> >      Total throughput (KB/s)     5,983,561       6,003,851      0.3%
> >      Average throughput (KB/s)     199,452         200,128      0.3%
> >      elapsed time (sec)             100.93           96.62     -4.3%
> >      sys time (sec)               2,532.49        2,395.83       -5%
> >      ------------------------------------------------------------------=
-----
> >
> >   usemem30 with 2M folios:
> >   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> >
> >      ------------------------------------------------------------------=
-----
> >                      mm-unstable-10-24-2025             v13
> >      ------------------------------------------------------------------=
-----
> >      zswap compressor          deflate-iaa     deflate-iaa   IAA Batchi=
ng
> >                                                                  vs.
> >                                                              IAA Sequen=
tial
> >      ------------------------------------------------------------------=
-----
> >      Total throughput (KB/s)     6,309,635      10,558,225       67%
> >      Average throughput (KB/s)     210,321         351,940       67%
> >      elapsed time (sec)              88.70           67.84      -24%
> >      sys time (sec)               2,059.83        1,581.07      -23%
> >      ------------------------------------------------------------------=
-----
> >
> >      ------------------------------------------------------------------=
-----
> >                      mm-unstable-10-24-2025             v13
> >      ------------------------------------------------------------------=
-----
> >      zswap compressor                 zstd            zstd   v13 zstd
> >                                                              improvemen=
t
> >      ------------------------------------------------------------------=
-----
> >      Total throughput (KB/s)     6,562,687       6,567,946      0.1%
> >      Average throughput (KB/s)     218,756         218,931      0.1%
> >      elapsed time (sec)              94.69           88.79       -6%
> >      sys time (sec)               2,253.97        2,083.43       -8%
> >      ------------------------------------------------------------------=
-----
> >
> >     The main takeaway from usemem, a workload that is mostly compressio=
n
> >     dominated (very few swapins) is that the higher the number of batch=
es,
> >     such as with larger folios, the more the benefit of batching cost
> >     amortization, as shown by the PMD usemem data. This aligns well
> >     with the future direction for batching.
> >
> > kernel_compilation/allmodconfig, 64K folios:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >      ------------------------------------------------------------------=
--------
> >                mm-unstable-10-24-2025             v13
> >      ------------------------------------------------------------------=
--------
> >      zswap compressor    deflate-iaa     deflate-iaa    IAA Batching
> >                                                              vs.
> >                                                         IAA Sequential
> >      ------------------------------------------------------------------=
--------
> >      real_sec                 836.64          806.94      -3.5%
> >      sys_sec                3,897.57        3,661.83        -6%
> >      ------------------------------------------------------------------=
--------
> >
> >      ------------------------------------------------------------------=
--------
> >                mm-unstable-10-24-2025             v13
> >      ------------------------------------------------------------------=
--------
> >      zswap compressor           zstd            zstd    Improvement
> >      ------------------------------------------------------------------=
--------
> >      real_sec                 880.62          850.41      -3.4%
> >      sys_sec                5,171.90        5,076.51      -1.8%
> >      ------------------------------------------------------------------=
--------
> >
> > kernel_compilation/allmodconfig, PMD folios:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >      ------------------------------------------------------------------=
--------
> >                mm-unstable-10-24-2025             v13
> >      ------------------------------------------------------------------=
--------
> >      zswap compressor    deflate-iaa     deflate-iaa    IAA Batching
> >                                                              vs.
> >                                                         IAA Sequential
> >      ------------------------------------------------------------------=
--------
> >      real_sec                 818.48          779.67      -4.7%
> >      sys_sec                4,226.52        4,245.18       0.4%
> >      ------------------------------------------------------------------=
--------
> >
> >      ------------------------------------------------------------------=
--------
> >               mm-unstable-10-24-2025             v13
> >      ------------------------------------------------------------------=
--------
> >      zswap compressor          zstd             zstd    Improvement
> >      ------------------------------------------------------------------=
--------
> >      real_sec                888.45           849.54      -4.4%
> >      sys_sec               5,866.72         5,847.17      -0.3%
> >      ------------------------------------------------------------------=
--------
> >
> > [1]:
> https://lore.kernel.org/all/aJ7Fk6RpNc815Ivd@gondor.apana.org.au/T/#m99
> aea2ce3d284e6c5a3253061d97b08c4752a798
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
>=20
> I won't go through the commit log and rewrite for this one too, but
> please do so similar to how I did for the previous patches. Do not
> describe the code, give a high-level overview of what is happening and
> why it's happeneing, as well as very concise performance results.

With all due respect, I am not describing the code. zswap compress batching
is a major architectural change and I am documenting the changes from the
status quo, for other zswap developers. Yes, some of this might involve
weaving in repetition of current behavior, again to stress the backward
compatibility of main concepts.

I believe there is not one redundant datapoint when it comes to performance
metrics in this summary - please elaborate. Thanks.

>=20
> Do not include things that only make sense in the context of a patch and
> won't make sense as part of git histroy.

This makes sense, duly noted and will be addressed.

>=20
> That being said, I'd like Herbert to review this patch and make sure the
> scatterlist and crypto APIs are being used correctly as he advised
> earlier. I do have some comments on the zswap side though.
>=20
> > ---
> >  mm/zswap.c | 249 ++++++++++++++++++++++++++++++++++++++----------
> -----
> >  1 file changed, 181 insertions(+), 68 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 257567edc587..c5487dd69ec6 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -143,6 +143,7 @@ struct crypto_acomp_ctx {
> >  	struct acomp_req *req;
> >  	struct crypto_wait wait;
> >  	u8 **buffers;
> > +	struct sg_table *sg_outputs;
> >  	struct mutex mutex;
> >  	bool is_sleepable;
> >  };
> > @@ -271,6 +272,11 @@ static void acomp_ctx_dealloc(struct
> crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
> >  			kfree(acomp_ctx->buffers[i]);
> >  		kfree(acomp_ctx->buffers);
> >  	}
> > +
> > +	if (acomp_ctx->sg_outputs) {
> > +		sg_free_table(acomp_ctx->sg_outputs);
> > +		kfree(acomp_ctx->sg_outputs);
> > +	}
> >  }
> >
> >  static struct zswap_pool *zswap_pool_create(char *compressor)
> > @@ -804,6 +810,7 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> node);
> >  	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> >acomp_ctx, cpu);
> >  	int nid =3D cpu_to_node(cpu);
> > +	struct scatterlist *sg;
> >  	int ret =3D -ENOMEM;
> >  	u8 i;
> >
> > @@ -849,6 +856,22 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  			goto fail;
> >  	}
> >
> > +	acomp_ctx->sg_outputs =3D kmalloc(sizeof(*acomp_ctx->sg_outputs),
> > +					GFP_KERNEL);
> > +	if (!acomp_ctx->sg_outputs)
> > +		goto fail;
> > +
> > +	if (sg_alloc_table(acomp_ctx->sg_outputs, pool->compr_batch_size,
> > +			   GFP_KERNEL))
> > +		goto fail;
> > +
> > +	/*
> > +	 * Statically map the per-CPU destination buffers to the per-CPU
> > +	 * SG lists.
> > +	 */
> > +	for_each_sg(acomp_ctx->sg_outputs->sgl, sg, pool-
> >compr_batch_size, i)
> > +		sg_set_buf(sg, acomp_ctx->buffers[i], PAGE_SIZE);
> > +
> >  	/*
> >  	 * if the backend of acomp is async zip, crypto_req_done() will
> wakeup
> >  	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
> > @@ -869,84 +892,177 @@ static int zswap_cpu_comp_prepare(unsigned
> int cpu, struct hlist_node *node)
> >  	return ret;
> >  }
> >
> > -static bool zswap_compress(struct page *page, struct zswap_entry *entr=
y,
> > -			   struct zswap_pool *pool, bool wb_enabled)
> > +/*
> > + * Unified code path for compressors that do and do not support batchi=
ng.
> This
> > + * procedure will compress multiple @nr_pages in @folio starting from =
the
> > + * @start index.
> > + *
> > + * It is assumed that @nr_pages <=3D ZSWAP_MAX_BATCH_SIZE.
> zswap_store() makes
> > + * sure of this by design and zswap_store_pages() warns if this is not
> > + * true.
> > + *
> > + * @nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the
> compressor does not
> > + * support batching.
> > + *
> > + * If @pool->compr_batch_size is 1, each page is processed sequentiall=
y.
> > + *
> > + * If @pool->compr_batch_size is > 1, compression batching is invoked
> within
> > + * the algorithm's driver, except if @nr_pages is 1: if so, the driver=
 can
> > + * choose to call the sequential/non-batching compress API.
> > + *
> > + * In both cases, if all compressions are successful, the compressed b=
uffers
> > + * are stored in zsmalloc.
> > + *
> > + * Traversing multiple SG lists when @nr_comps is > 1 is expensive, an=
d
> impacts
> > + * batching performance if we were to repeat this operation multiple
> times,
> > + * such as:
> > + *   - to map destination buffers to each SG list in the @acomp_ctx-
> >sg_outputs
> > + *     sg_table.
> > + *   - to initialize each output SG list's @sg->length to PAGE_SIZE.
> > + *   - to get the compressed output length in each @sg->length.
> > + *
> > + * These are some design choices made to optimize batching with SG lis=
ts:
> > + *
> > + * 1) The source folio pages in the batch are directly submitted to
> > + *    crypto_acomp via acomp_request_set_src_folio().
> > + *
> > + * 2) The per-CPU @acomp_ctx->sg_outputs scatterlists are used to set =
up
> > + *    destination buffers for interfacing with crypto_acomp.
> > + *
> > + * 3) To optimize performance, we map the per-CPU @acomp_ctx->buffers
> to the
> > + *    @acomp_ctx->sg_outputs->sgl SG lists at pool creation time. The =
only
> task
> > + *    remaining to be done for the output SG lists in zswap_compress()=
 is to
> > + *    set each @sg->length to PAGE_SIZE. This is done in zswap_compres=
s()
> > + *    for non-batching compressors. This needs to be done within the
> compress
> > + *    batching driver procedure as part of iterating through the SG li=
sts for
> > + *    batch setup, so as to minimize expensive traversals through the =
SG
> lists.
> > + *
> > + * 4) Important requirements for batching compressors:
> > + *    - Each @sg->length in @acomp_ctx->req->sg_outputs->sgl should
> reflect the
> > + *      compression outcome for that specific page, and be set to:
> > + *      - the page's compressed length, or
> > + *      - the compression error value for that page.
> > + *    - The @acomp_ctx->req->dlen should be set to the first page's
> > + *      @sg->length. This enables code generalization in zswap_compres=
s()
> > + *      for non-batching and batching compressors.
> > + *
> > + * acomp_ctx mutex locking:
> > + *    Earlier, the mutex was held per page compression. With the new c=
ode,
> > + *    [un]locking the mutex per page caused regressions for software
> > + *    compressors. We now lock the mutex once per batch, which resolve=
s
> the
> > + *    regression.
> > + */
>=20
> Please, no huge comments describing what the code is doing. If there's
> anything that is not clear from reading the code or needs to be
> explained or documented, please do so **concisely** in the relevant part
> of the function.

Again, these are important requirements related to the major change, i.e.,
batching, wrt why/how. I think it is important to note considerations for t=
he
next batching algorithm, just like I have done within the IAA driver. To be=
 very
clear, I am not describing code.

If questions arise as to why the mutex is being locked per batch as against
per page, I think the comment above is helpful and saves time for folks to
understand the "why".

>=20
> > +static bool zswap_compress(struct folio *folio, long start, unsigned i=
nt
> nr_pages,
> > +			   struct zswap_entry *entries[], struct zswap_pool
> *pool,
> > +			   int nid, bool wb_enabled)
> >  {
> > +	gfp_t gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM |
> __GFP_MOVABLE;
> > +	unsigned int nr_comps =3D min(nr_pages, pool->compr_batch_size);
> > +	unsigned int slen =3D nr_comps * PAGE_SIZE;
> >  	struct crypto_acomp_ctx *acomp_ctx;
> > -	struct scatterlist input, output;
> > -	int comp_ret =3D 0, alloc_ret =3D 0;
> > -	unsigned int dlen =3D PAGE_SIZE;
> > +	int err =3D 0, err_sg =3D 0;
> > +	struct scatterlist *sg;
> > +	unsigned int i, j, k;
> >  	unsigned long handle;
> > -	gfp_t gfp;
> > -	u8 *dst;
> > -	bool mapped =3D false;
> > +	int *errp, dlen;
> > +	void *dst;
> >
> >  	acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
> >  	mutex_lock(&acomp_ctx->mutex);
> >
> > -	dst =3D acomp_ctx->buffers[0];
> > -	sg_init_table(&input, 1);
> > -	sg_set_page(&input, page, PAGE_SIZE, 0);
> > -
> > -	sg_init_one(&output, dst, PAGE_SIZE);
> > -	acomp_request_set_params(acomp_ctx->req, &input, &output,
> PAGE_SIZE, dlen);
> > +	errp =3D (pool->compr_batch_size =3D=3D 1) ? &err : &err_sg;
>=20
> err_sg is not used anywhere, so *errp could end up being garbage. Why do
> we need this?

err_sg is initialized to 0 and never changes. It can never be garbage.
We need this because of the current dichotomy between software compressors
and IAA in the sg->length based error handling per Herbert's suggestions,
included in the huge function comment block. It is needed to avoid branches
and have the zswap_compress() code look seamless for all compressors.

>=20
> >
> >  	/*
> > -	 * it maybe looks a little bit silly that we send an asynchronous
> request,
> > -	 * then wait for its completion synchronously. This makes the process
> look
> > -	 * synchronous in fact.
> > -	 * Theoretically, acomp supports users send multiple acomp requests
> in one
> > -	 * acomp instance, then get those requests done simultaneously. but
> in this
> > -	 * case, zswap actually does store and load page by page, there is no
> > -	 * existing method to send the second page before the first page is
> done
> > -	 * in one thread doing zswap.
> > -	 * but in different threads running on different cpu, we have differe=
nt
> > -	 * acomp instance, so multiple threads can do (de)compression in
> parallel.
> > +	 * [i] refers to the incoming batch space and is used to
> > +	 *     index into the folio pages.
> > +	 *
> > +	 * [j] refers to the incoming batch space and is used to
> > +	 *     index into the @entries for the folio's pages in this
> > +	 *     batch, per compress call while iterating over the output SG
> > +	 *     lists. Also used to index into the folio's pages from @start,
> > +	 *     in case of compress errors.
> > +	 *
> > +	 * [k] refers to the @acomp_ctx space, as determined by
> > +	 *     @pool->compr_batch_size, and is used to index into
> > +	 *     @acomp_ctx->sg_outputs->sgl and @acomp_ctx->buffers.
> >  	 */
> > -	comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx-
> >req), &acomp_ctx->wait);
> > -	dlen =3D acomp_ctx->req->dlen;
> > +	for (i =3D 0; i < nr_pages; i +=3D nr_comps) {
>=20
> What are looping over here? I thought zswap_compress() takes in exactly
> one batch.

We are iterating once over one batch for batching compressors, and one
page at a time for software.

>=20
> > +		acomp_request_set_src_folio(acomp_ctx->req, folio,
> > +					    (start + i) * PAGE_SIZE,
> > +					    slen);
> >
> > -	/*
> > -	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
> > -	 * save the content as is without a compression, to keep the LRU
> order
> > -	 * of writebacks.  If writeback is disabled, reject the page since it
> > -	 * only adds metadata overhead.  swap_writeout() will put the page
> back
> > -	 * to the active LRU list in the case.
> > -	 */
> > -	if (comp_ret || !dlen || dlen >=3D PAGE_SIZE) {
> > -		if (!wb_enabled) {
> > -			comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> > -			goto unlock;
> > -		}
> > -		comp_ret =3D 0;
> > -		dlen =3D PAGE_SIZE;
> > -		dst =3D kmap_local_page(page);
> > -		mapped =3D true;
> > -	}
> > +		acomp_ctx->sg_outputs->sgl->length =3D slen;
> >
> > -	gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM |
> __GFP_MOVABLE;
> > -	handle =3D zs_malloc(pool->zs_pool, dlen, gfp, page_to_nid(page));
> > -	if (IS_ERR_VALUE(handle)) {
> > -		alloc_ret =3D PTR_ERR((void *)handle);
> > -		goto unlock;
> > -	}
> > +		acomp_request_set_dst_sg(acomp_ctx->req,
> > +					 acomp_ctx->sg_outputs->sgl,
> > +					 slen);
> > +
> > +		err =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx-
> >req),
> > +				      &acomp_ctx->wait);
> > +
> > +		acomp_ctx->sg_outputs->sgl->length =3D acomp_ctx->req-
> >dlen;
> > +
> > +		/*
> > +		 * If a page cannot be compressed into a size smaller than
> > +		 * PAGE_SIZE, save the content as is without a compression,
> to
> > +		 * keep the LRU order of writebacks.  If writeback is disabled,
> > +		 * reject the page since it only adds metadata overhead.
> > +		 * swap_writeout() will put the page back to the active LRU
> list
> > +		 * in the case.
> > +		 *
> > +		 * It is assumed that any compressor that sets the output
> length
> > +		 * to 0 or a value >=3D PAGE_SIZE will also return a negative
> > +		 * error status in @err; i.e, will not return a successful
> > +		 * compression status in @err in this case.
> > +		 */
>=20
> Ugh, checking the compression error and checking the compression length
> are now in separate places so we need to check if writeback is disabled
> in separate places and store the page as-is. It's ugly, and I think the
> current code is not correct.

The code is 100% correct. You need to spend more time understanding
the code. I have stated my assumption above in the comments to
help in understanding the "why".

From a maintainer, I would expect more responsible statements than
this. A flippant remark made without understanding the code (and,
disparaging the comments intended to help you do this), can impact
someone's career. I am held accountable in my job based on your
comments.

That said, I have worked tirelessly and innovated to make the code
compliant with Herbert's suggestions (which btw have enabled an
elegant batching implementation and code commonality for IAA and
software compressors), validated it thoroughly for IAA and ZSTD to
ensure that both demonstrate performance improvements, which
are crucial for memory savings. I am proud of this work.


>=20
> > +		if (err && !wb_enabled)
> > +			goto compress_error;
> > +
> > +		for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
> > +			j =3D k + i;
>=20
> Please use meaningful iterator names rather than i, j, and k and the huge
> comment explaining what they are.

I happen to have a different view: having longer iterator names firstly mak=
es
code seem "verbose" and detracts from readability, not to mention exceeding=
 the
80-character line limit. The comments are essential for code maintainabilit=
y
and avoid out-of-bounds errors when the next zswap developer wants to
optimize the code.

One drawback of i/j/k iterators is mis-typing errors which cannot be caught
at compile time. Let me think some more about how to strike a good balance.

>=20
> > +			dst =3D acomp_ctx->buffers[k];
> > +			dlen =3D sg->length | *errp;
>=20
> Why are we doing this?
>=20
> > +
> > +			if (dlen < 0) {
>=20
> We should do the incompressible page handling also if dlen is PAGE_SIZE,
> or if the compression failed (I guess that's the intention of bit OR'ing
> with *errp?)

Yes, indeed: that's the intention of bit OR'ing with *errp.

>=20
> > +				dlen =3D PAGE_SIZE;
> > +				dst =3D kmap_local_page(folio_page(folio, start
> + j));
> > +			}
> > +
> > +			handle =3D zs_malloc(pool->zs_pool, dlen, gfp, nid);
> >
> > -	zs_obj_write(pool->zs_pool, handle, dst, dlen);
> > -	entry->handle =3D handle;
> > -	entry->length =3D dlen;
> > +			if (IS_ERR_VALUE(handle)) {
> > +				if (PTR_ERR((void *)handle) =3D=3D -ENOSPC)
> > +					zswap_reject_compress_poor++;
> > +				else
> > +					zswap_reject_alloc_fail++;
> >
> > -unlock:
> > -	if (mapped)
> > -		kunmap_local(dst);
> > -	if (comp_ret =3D=3D -ENOSPC || alloc_ret =3D=3D -ENOSPC)
> > -		zswap_reject_compress_poor++;
> > -	else if (comp_ret)
> > -		zswap_reject_compress_fail++;
> > -	else if (alloc_ret)
> > -		zswap_reject_alloc_fail++;
> > +				goto err_unlock;
> > +			}
> > +
> > +			zs_obj_write(pool->zs_pool, handle, dst, dlen);
> > +			entries[j]->handle =3D handle;
> > +			entries[j]->length =3D dlen;
> > +			if (dst !=3D acomp_ctx->buffers[k])
> > +				kunmap_local(dst);
> > +		}
> > +	} /* finished compress and store nr_pages. */
> > +
> > +	mutex_unlock(&acomp_ctx->mutex);
> > +	return true;
> > +
> > +compress_error:
> > +	for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
> > +		if ((int)sg->length < 0) {
> > +			if ((int)sg->length =3D=3D -ENOSPC)
> > +				zswap_reject_compress_poor++;
> > +			else
> > +				zswap_reject_compress_fail++;
> > +		}
> > +	}
> >
> > +err_unlock:
> >  	mutex_unlock(&acomp_ctx->mutex);
> > -	return comp_ret =3D=3D 0 && alloc_ret =3D=3D 0;
> > +	return false;
> >  }
> >
> >  static bool zswap_decompress(struct zswap_entry *entry, struct folio
> *folio)
> > @@ -1488,12 +1604,9 @@ static bool zswap_store_pages(struct folio
> *folio,
> >  		INIT_LIST_HEAD(&entries[i]->lru);
> >  	}
> >
> > -	for (i =3D 0; i < nr_pages; ++i) {
> > -		struct page *page =3D folio_page(folio, start + i);
> > -
> > -		if (!zswap_compress(page, entries[i], pool, wb_enabled))
> > -			goto store_pages_failed;
> > -	}
> > +	if (unlikely(!zswap_compress(folio, start, nr_pages, entries, pool,
> > +				     nid, wb_enabled)))
> > +		goto store_pages_failed;
> >
> >  	for (i =3D 0; i < nr_pages; ++i) {
> >  		struct zswap_entry *old, *entry =3D entries[i];
> > --
> > 2.27.0
> >
