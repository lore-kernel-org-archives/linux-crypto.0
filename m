Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4532C15A2;
	Mon, 13 Oct 2025 18:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760378605; cv=fail; b=gJfjqyKYdLF7himbO3bKaLcHVBVkHr9a+JxN/E4TjQsPHDjskJ0EhvGTEPAH/q1+t4yhmkYjTyYUcnyDvAXD0lcGrxi6DKjMh7IMOVP5zF9PZwceapr03D6m15psnNMlUcfzjsRu2+/6GSWfBqeYvWn8zOYGw2OptyxcgG3ExXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760378605; c=relaxed/simple;
	bh=3jcBK1H5xeBs8x+3STckRuRYKjwgmAWjtib0ueuyEKE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Rg92VejTT8JpX0eI/asj6GUI6nnpNtTwzAgTSWTZFVyRvHXhZM84nrT1b00bxGctGhr9RA4BdS185KIVr35g3qSAvacjGx+meavPtwqhooNaIFoznRyQl4FVfhxgEuDneQdveJmm5dmQJ01BcECNVJJ9JC0PjwuxKQ4zjGTM+70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hKmh9ucM; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hKmh9ucM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760378604; x=1791914604;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3jcBK1H5xeBs8x+3STckRuRYKjwgmAWjtib0ueuyEKE=;
  b=hKmh9ucMfIQAellDfEqizR9G316ik9dTgzJP++LURnzfTQr2FqRnS1IQ
   7VXF5p5FGKMi+6JX82EWtbfAjQMB5hZdT5UtgtQaak+zk71GZ8O0jYsIR
   vdGRuKUJjCfl1Rsu5q3/jONUR1vuQsBs/mb6zuGmV757rQqR8v6mv/X6l
   Gr5tUqBFXUPvzs7kPSgQgK5Q1u7p7km5qpt04ADEJkbOPl57lVJlGkfU+
   hbpXy5lrZhV0bXEsDuwyJr+A0dzWZYc+wukRWHNpx41WwsDJYq1Nbh0XB
   HiG2q//9vSZk/ataXkxtOlPeHVRIwIf6+oViGxC46Z87dRUn8R9Vqkr3E
   w==;
X-CSE-ConnectionGUID: K5e6UeKJRx6KEK5VisSQJA==
X-CSE-MsgGUID: JUKAtfp+S+GSMY74D6Zt0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="73129642"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="73129642"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 11:03:24 -0700
X-CSE-ConnectionGUID: CMsCbyQ+TRSksTo4O9P9UA==
X-CSE-MsgGUID: wWcRfQVMQkqJ1aBgYRaDeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="212284584"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 11:03:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 11:03:22 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 13 Oct 2025 11:03:22 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.30) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 11:03:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t85SErlTAybJjIKkrMiCVx7ZS7UOKxOZjxjT2icHlFx5s/H4UcfnbeEjEqcubVaTf3Jf7L2FML8RVxDIH7gr3p99vB/u3My51cGHIN7wpERJAYEroTpC18HFC34YJJpoHwCLQS5La3iGdkykOqB5tuCHt7qvFB+5UIgEvazwPe5QC0pjoGtw5QndARMS3IKrXyIGQpawbhGSeq6nXzp0tky87X9aXbZywyTZD5s33RuTSCkwDpQY9scjvDWR5fAjzrQca9lsNkbomg8SXEvj2f5h0btaYOwBnkAPPFr/Ps3pUqu985Mvf8DkpzuW1Lmh0e60eqMT8YvPnUr9B9U63g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3n7JfVOE1pg0+LqqS32AHJBbgwh1cPvrMUEF31Q26s0=;
 b=sghxbrJ6Pmu8YxJ3tWspmZavgtdcgEKgp3XoXnrFaRJOy9eq/nScDPYhGph5VL5D0z/ye6IGEo1ixVkYKW5cozOGywajkyLOMzN5Ph50+sBTBxmrncZ2ge9VQsUOH+Jl/lKN5AQWMo3Z1pupP3HuYPKcuwqnUjcehjIQMj69OUYFh4df3kxlKmZW3e/SUydpumjCX7uix3KcIm9LsPLYmEpE4TSVR4qGDNCGTRdHo3ryaVXhZfTpN7BCwREBbrKjU74nCTHkaEHgylMl0Tcs2/YJwHXiFDyaFxv85SV9CRegquTavRx5tjRZoMwgx2116+xO5FPOD/9pFA1HvWv7gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by CH3PR11MB7297.namprd11.prod.outlook.com (2603:10b6:610:140::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Mon, 13 Oct
 2025 18:03:19 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 18:03:19 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
	<linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>
CC: "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v12 00/23] zswap compression batching with optimized
 iaa_crypto driver
Thread-Topic: [PATCH v12 00/23] zswap compression batching with optimized
 iaa_crypto driver
Thread-Index: AQHcLpaWQvzV6tNz6UyN3AQCyKtPdrTAeOTA
Date: Mon, 13 Oct 2025 18:03:19 +0000
Message-ID: <PH7PR11MB8121082DCE1A974F7FAE02F5C9EAA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|CH3PR11MB7297:EE_
x-ms-office365-filtering-correlation-id: 49beacb7-1a4b-4226-6ab0-08de0a82ca97
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|10070799003|921020|7053199007|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?xW1j5caTKxkgM3GUeTSvaFS1znYPZNTEir2wMPK43W/N1DHndxoWTaVk8DIJ?=
 =?us-ascii?Q?Wrtc1WfGu4Pg/UKUmyEteQYvgTk5Zmorfbp+OzbSLOWKwWXljV+xJFy5uz3o?=
 =?us-ascii?Q?UqDOoRkDG3znYPARfK2AviQ7P7qG1iZNuCAYlcSkPRxpwV4z+EuPTBZzyogf?=
 =?us-ascii?Q?A4JLvvx6UVU3PMid4bxasljh66nR0R7vZwnNPafGKTpyu9InyQ44pYTrFgea?=
 =?us-ascii?Q?Zxf4J/JOB3UOTvxG3RkQyaqJHCj0FThjxKvE7PC3bQDWVDB7Io7POMn4B3Xd?=
 =?us-ascii?Q?faWJ6uQ4hlyP1GiEW/dtCEz4XgUyJo2NvBxg/Tt0OaO/52CGW8KBp4wR1GBM?=
 =?us-ascii?Q?uB3ccMTrv5gr5rIe/5YiaMPOrLv2v4DuFf62lwzQz81dR8EkgYAg834ClsCa?=
 =?us-ascii?Q?uIjRCujoj8zGGbTt/vH4aunuSAoRAd7pNxCaGrRDZZKEs1MXcnXuISttc6O9?=
 =?us-ascii?Q?GBpCKsuTk6ADIhVimGglv6bHsrC1acgkpwtQ2aiavX5db3vYzXVH1xpT1COg?=
 =?us-ascii?Q?qLiSBB+N2KoTnJ2k10PosrnZ8lEJ00j9o9BNORicK3OFyrl2ZSKrpJjBB6fz?=
 =?us-ascii?Q?8KGcYZGN1mwXKuDPz/HB9SbZliUF4+NzilLcCSOjk/RzhvS6i5C2jDfZBJTW?=
 =?us-ascii?Q?ap1YCxPdWXjkR/kPkoXSPFTEcTjtysNUFU6CCGUz97fL2ufXALYNiS5EXUpG?=
 =?us-ascii?Q?89GYCw+5BTQYLML8ENo5a428OcAs3VhcY+UivXyhK4pYZb+e+VYq1kZ3u60e?=
 =?us-ascii?Q?Z9oO+cwOdKev1D6a9a5h/F34vaqv9OGqOfmlTA4C/5f4tcwWqqy73GXBVXAN?=
 =?us-ascii?Q?dOBpPt1iTSGIDOrjREVpxNGdZIdOWh55ezWYuu+w1vVs4LPcBhBCJZT/ychs?=
 =?us-ascii?Q?REQiQP2jsRyYgU+alcj0Sq5kpp81Rz3yxmPKGmmLu/nEJosCdPYwgme/LGOR?=
 =?us-ascii?Q?RL0AYli4Zyr75gWBSmP3XxDElVJEeRksxN3TNjEjJVN0zeA1BOiajWH57FvU?=
 =?us-ascii?Q?qKMBRH7R33KBbVCZF9pBWyHqD4rejXyIp9K9M6hgV3+P0IvEHUk6A4TpV2ix?=
 =?us-ascii?Q?XKqXYkrfmz3Loq6POEpHIRBG37Ucl3RMFm/S8QtGck/n1OY0zlLKOp/pX4Yy?=
 =?us-ascii?Q?mBcJmLtymb0Y/pjzcftg7wFjl7eY9wg4yfS9x5Ti8ps5sW7C1aVeq3sSBUV0?=
 =?us-ascii?Q?GffypqE7ZhWiP3oF2olsllRYSsVtMynjktRuz8OBrTQgAlvs4AftOYIIt7iy?=
 =?us-ascii?Q?acl92VqAJcgJGEDLI02bkkkKwOMKghMH0BuJFFa3onzUKG/b30KwyEfbjzE4?=
 =?us-ascii?Q?OxNO+vZOR767XvQ4iqRV5rIQ0SuxwwJoEVWyv1V6JmhFpDMLKwWCWZR7MeVb?=
 =?us-ascii?Q?7c5qq3sK/Y3l5LrNbQObj7TF8uyiK3bv+vzAt+k55JpVIwmd/6E4u/4jstfy?=
 =?us-ascii?Q?AE0A4tsBL3VXFYf4mV//G6p6h5s7DWMk5bzpAnGZNOJd3aM+6rgQ8Yvfqa9t?=
 =?us-ascii?Q?brQTV0CkH3kQYeSQkQcK+1whXMa08lFdQyl0V5RyuSBjWfMFY+SLQ7C7vw?=
 =?us-ascii?Q?=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(10070799003)(921020)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yPVwolWG/PCYoNDP/DiS0i+Vbef/A1rTkn84hz+DLpwGPU26g6jFAUVp5xmg?=
 =?us-ascii?Q?iISNZXByacMNxJ8IA+k/V9RbhpYj9M1VRoVL8e9ZXDW5zH2Y4wARk/2w2srx?=
 =?us-ascii?Q?LwxNlgpcfRBTmil+A91JkVxrjTcR67Y/ri2wRcNbIja5/jTQCu57T2bnzMhz?=
 =?us-ascii?Q?M878ua+MoVENVkaT0St0cbDrhw5gV/jZeKMSKvxlclBAAYkNp8SqE8jSfl2q?=
 =?us-ascii?Q?/k0eTGg9K+fQ4Ei4aqgJSlQZmAvMHGQ2qUvHS9YB+k+ZjfKYvNKasCdt6JgG?=
 =?us-ascii?Q?R20AzBT9JyWSdvHSZnI9sUA3uyjLQ41bYOmhKlvqMP3tSYooYq9n52ok1j1o?=
 =?us-ascii?Q?B/z3TrarkZ9RiBylHH+phGbDoBSn1GlvNiZm2Gm1fQkF5XaHsixUMVF0aDgW?=
 =?us-ascii?Q?Vw6S0hCg5lyU/8M4FoOgikM+8I5tK7Ejzc4cbtV3WI8rAlOMEvuFp8J0yMbh?=
 =?us-ascii?Q?u4jFLY01hukY2faLUzOO0Hpr/XM7PYXTJjd3Q+P9Mo88KV5HTsbclixXfTmc?=
 =?us-ascii?Q?3w0zpGAl6ot+a+BRCX+/GkzJ+GD3sz50SAOU3l9/iaootEpMOsBbugsCVaP/?=
 =?us-ascii?Q?GiRolwIErTuzTfanvieFMZpmFCUxAsNz0s7ra+9dyO5p7BKhWFb9eV557Wvt?=
 =?us-ascii?Q?sykopNQiHaUJs1oHXFGHA+z9T5YNwwgXNyKP7mT7L1wX6494mFK3eRSAxp7h?=
 =?us-ascii?Q?kaz1A5PKKsg4h/Xpk0fhnDRu23VuSSGop3mMDf3UVRzcI4z6t6RM4X7DfQ0f?=
 =?us-ascii?Q?/NCTk/nCaqFWtFM3F+nnjWJczIs+vWTzyiqyU0/aHmIujNVlY471DWB6FcA+?=
 =?us-ascii?Q?kXJap4bfsSy6eTds95CfBgdT0zlauBN3h3IRQw0Q+MPbrhxNmMWs14IiaYhD?=
 =?us-ascii?Q?WN3z3SWxZcY6feOpCXhehWDmL+Pr3dC47PSnu/PtUa2mQFDxfrYgnJAVbVDQ?=
 =?us-ascii?Q?tg08XtWVC8GiAA5A3rUDCh5etbRSSjZPIgYaFUZ9Us/n2C9huJO8wkO60Jyh?=
 =?us-ascii?Q?R+36XdumSj4cRaEx2Zqc8mgFwU0Wbp+oXaQnLyER7iaSv1n+Lin/Lp3Sz5f6?=
 =?us-ascii?Q?FJLGjYi1yUfwmvibW1Kv9nLpBIRBxUzaKgJcIZ596YklNt2ccgWTzfHivvNo?=
 =?us-ascii?Q?lgDxXD8ECUi7E4K4CmDwdpyRdqYpZqYdwqqdPMBtCLWovoYkk5U6jhrsc1DO?=
 =?us-ascii?Q?e47D89K3QG5yQh4kRUjE2yRtYNhUh/kG0tk/0eSuY5qm5RHCcx2DMLWqbDzA?=
 =?us-ascii?Q?DoMVSr5WuzeDxyghPDOeHc3bSJDWciVr+tNgYNUCr2pDC4Wu0kVcJbApzNue?=
 =?us-ascii?Q?SGYBgUtXbxT9QcP6tH8+NoZ5HTT++NTQm2Sdd7oJBdMnqr1LJgcnU6S1t6gB?=
 =?us-ascii?Q?wRI6NFL0BY8RISSuiGCw2zqcmvQ9cEG4F/UiOe3TUKqrtfP+pW1YcVU+qy9X?=
 =?us-ascii?Q?2ZmSG2JfAByJyn9vw1P6wr1VXTxzV+JjyMhl6FKPaU1G/kvzz3y14EAkosAa?=
 =?us-ascii?Q?0Qp8oeZn//R3AUSLndPX9n2Bm6w0f6zb8zNg8yIU62hWRhjcgKDJsODr2S1J?=
 =?us-ascii?Q?DtxgGjwJAsVVpgCxL0bklNu5chkTb5tqAaZ3lAwFeFOKX4hPp3E2jXePr9L0?=
 =?us-ascii?Q?TmdezPNPiNOPo5a+x297VbzgooBblj8YHTHDfxgPRzg2DCRJF/XPHZQOJzid?=
 =?us-ascii?Q?hLzKwg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49beacb7-1a4b-4226-6ab0-08de0a82ca97
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2025 18:03:19.4080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 40Xh8jqqgJ3L4xdikwhv+HIl6qIuw4EQo/WKsWRspVrdRyFmZDhv5PUga+CWOT8E5LaxE2gVkhq3DcQB+VI5EPqrK/3PfJKCFZCE41nVNak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7297
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Sent: Thursday, September 25, 2025 8:35 PM
> To: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>
> Cc: Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>; Sridhar, Kanchana P
> <kanchana.p.sridhar@intel.com>
> Subject: [PATCH v12 00/23] zswap compression batching with optimized
> iaa_crypto driver
>=20
>=20
> v12: zswap compression batching with optimized iaa_crypto driver
>=20
> Based on Herbert's suggestions, the most significant change in v12 is, th=
e
> batching interfaces from zswap to crypto, from crypto to iaa_crypto, and
> the batching implementation within iaa_crypto now use the folio directly =
as
> the
> source (sg_page_iter for retrieving pages) and destination SG lists. A un=
it_size
> has been added to struct acomp_req, with kernel users such as zswap using
> the
> new acomp_request_set_unit_size() API to set the unit size to use while
> breaking
> down the request's src/dst scatterlists. zswap sets the unit-size to PAGE=
_SIZE.
>=20

Hi Herbert,

Just wanted to follow up to see if you have any code review comments on
the v12 changes made to the batching interfaces as per your suggestions?

Please let me know, I would appreciate it.

Thanks,
Kanchana

>=20
> Changes since v11:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 9-18-2025, commit 1f98191f08b4.
> 2) Incorporated Herbert's suggestions on submitting the folio as the sour=
ce
> and
>    SG lists for the destination to create the compress batching interface=
 from
>    zswap to crypto.
> 3) As per Herbert's suggestion, added a new unit_size member to struct
>    acomp_req, along with a acomp_request_set_unit_size() API for kernel
> modules
>    to set the unit size to use while breaking down the request's src/dst
>    scatterlists.
> 4) Implemented iaa_crypto batching using the new SG lists based architect=
ure
> and
>    crypto interfaces.
> 5) To make the SG lists based approach functional and performant for IAA,=
 I
> have
>    changed all the calls to dma_map_sg() to use nents of 1. This should n=
ot be
> a
>    concern, since it eliminates redundant computes to scan an SG list wit=
h only
>    one scatterlist for existing kernel users, i.e. zswap with the
>    zswap_compress() modifications in this series. This will continue to h=
old
>    true with the zram IAA batching support I am developing. There are no
> kernel
>    use cases for the iaa_crypto driver that will break this assumption.
> 6) Addressed Herbert's comment about batch_size being a statically define=
d
> data
>    member in struct acomp_alg and struct crypto_acomp.
> 7) Addressed Nhat's comment about VM_WARN_ON_ONCE(nr_pages >
>    ZSWAP_MAX_BATCH_SIZE) in zswap_store_pages().
> 8) Nhat's comment about deleting struct swap_batch_decomp_data is
> automatically
>    addressed by the SG lists based rewrite of the crypto batching interfa=
ce.
> 9) Addressed Barry's comment about renaming pool->batch_size to
>    pool->store_batch_size.
> 10) Incorporated Barry's suggestion to merge patches that introduce data
> members
>     to structures and/or API and their usage.
> 11) Added performance data to patch 0023's commit log, as suggested by
> Barry.
>=20

