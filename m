Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB96188A0E;
	Tue,  3 Dec 2024 21:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733261851; cv=fail; b=DBahuZUznFGJtEy8EvT/RARdYVbgSOkPpVhEA4CT2pquTLnH8fL6Xc6xlQqSap1JXkHRVNTYEcPoLynkDhcNTWRnzkYQn2iaH4FGr9xDSx/s1RK044+wevYstR/kbqe6mcDmNxzhV4MOT5QkwHtxauW41eGxhnxKH4Ta184+Pjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733261851; c=relaxed/simple;
	bh=5ID/wf7HePKp2bWYMtzVdTi63HHYf4Oiazgi9H1Kwl0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ouPhi12FwAPJvORLXv9ewjHSSy8ovp7SOS6qjBtROiQOeJbU4LUdfinT9lpIWGqG76/uhdw0qvfqFQJoJRFCXv8MCsrV7sW/EZjDTovEGVdNgT7HhOYR7slflQt4gZFyRQEIvJJhljBCNCQ9eRsXkuUXKLTdNa3oVbmy+HM7RZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CCEuefTe; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CCEuefTe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733261850; x=1764797850;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5ID/wf7HePKp2bWYMtzVdTi63HHYf4Oiazgi9H1Kwl0=;
  b=CCEuefTeOhUBg+RIKeE5/AvXdlJ8WLTovOt540L6CC9zMWYQ9vXyqd2A
   mVxWYiVtNxMg/m/BTgW3Ren+UuXYewtFcIkUN5cakbdlnLaVfxdtb09i8
   WRRPNu8PHoaPYbhZqh7AVcFNqgfA0P0PbuIbZun2aEcc6//ZnhNyGBmH1
   3FI/dvtUx9s6CZj1sBnl9C+m95SCfLmz8shErxSLwNdmM0l+lLiyLeJ8d
   L+MatTybKqcZZyzgL2bvtBkE7oQi9qHUyKuyMz0QnsAHRM6+QEtYZQ+LX
   cJ45/t7blGdUYT0K+VViO4D9DXy29RDlBEap9fYcF15FmHPYwu8Au2gAC
   Q==;
X-CSE-ConnectionGUID: oVRKAJRiQwa0/CMux5VwSw==
X-CSE-MsgGUID: 3qQa0lWzTBGxfu2lgBPUNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="44115347"
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="44115347"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 13:37:29 -0800
X-CSE-ConnectionGUID: Hs09YkgOTte6iejRszbNvQ==
X-CSE-MsgGUID: r0c06tgpS2KTKO5X5QSh3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="131017230"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Dec 2024 13:37:29 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Dec 2024 13:37:28 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Dec 2024 13:37:28 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Dec 2024 13:37:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ix39J4m/0SHshEpp5fQQfL3w9p+9cHUXSUoolYZ6OSUuz13GzVjBkmIBTg6N0IvCWRtpvP2XQSzI8OCQxR4jyyxkOneFnQskfUbGLzlR0qD3dvJGdFWg5x1GWwMW2hpvsjSx+sYKHTkhHL075B/Bu9sPCdRaqw1jTqIhSwiE9LDMN2wkvk3TVO2ZhSm9wUAooe6IT3KMA0U2YIRpHG9ton6B5BYtyFCc9WO21owaCZzi7Y90befNIfuc3RNUeA5R4Ce+G31yRAOOcNdBluDxbNOaOGkcJs37AcLcOkP4bjAlxRSOaGfNdk0fS0CbJHHBhaKgX6jYp1IGSAq9mGPYHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CgoeKt/hArCOmmwNOV0/XoruRggFJfvvQxEjdPdIt38=;
 b=NUtSoyP9F7XcWSJpksiKBEszScycb+n2KcJ+Uh09y5X9sKA+QCxK7M+hovYa5eW4kzXDJ1kLfS1Tefh58sZVMFshxeqUmcEOvdL2SAj8S+MiDrt4WyPvhQP0XOJBnuttAor1OlbUyBuNvt0HA+nq9N1/1Q+AsfRbMC28iDR2Q7onFVcaYQftMM8EbwMejiBOi6vd/UIOR2Nn0nvxtWBYLYRL2FHgR+2hd9zYVCMBn37g2/EjTTy23Xj6dsSv2PNANr6Hh8dJruSpZ5bNlNFkmUOoBuP8G4XGwifnuoVv1mdkm/CTwGbLXtCP00v3kioKa3Dmr4MDDpoEUcukKnm23Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by DS0PR11MB8762.namprd11.prod.outlook.com (2603:10b6:8:1a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 21:37:24 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 21:37:24 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Nhat Pham <nphamcs@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosryahmed@google.com"
	<yosryahmed@google.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"ying.huang@intel.com" <ying.huang@intel.com>, "21cnbao@gmail.com"
	<21cnbao@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
Thread-Topic: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
Thread-Index: AQHbPXWU4Gc6KD17CkKDJ7pv5ZtEYLLTYjKAgABKBaCAAIvAgIAA4a2Q
Date: Tue, 3 Dec 2024 21:37:24 +0000
Message-ID: <SJ0PR11MB5678AAEF4F62773847E6307FC9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-10-kanchana.p.sridhar@intel.com>
 <CAKEwX=PmKWH4Z4Py9Jti9fcD6qCYJBBRrDF48qdmo8-i+LzzfA@mail.gmail.com>
 <SJ0PR11MB56783454B5985ACD48744772C9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <Z066p53LoISwqkmX@gondor.apana.org.au>
In-Reply-To: <Z066p53LoISwqkmX@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|DS0PR11MB8762:EE_
x-ms-office365-filtering-correlation-id: b1666f04-3945-4f10-4085-08dd13e2ad5e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?o0E6l064dIJ/lDG1qy6wDDc/RwPLbtp1kHiu+UW53CREZ5Vdt0mmluV7Kp+Q?=
 =?us-ascii?Q?O4xya3ayqQi+ZEPLduWhlu0VTwtmiii1aM4AlqsjFxt2Lf4iGpkpbDMmkQZB?=
 =?us-ascii?Q?lRND4SfofgTiiNutwR6KPNGNmk67f3n88btAQtHF87HnAou70ftHjZ65ObQI?=
 =?us-ascii?Q?aPq8tkuWmnqGpUs2lpt3xgqy2DT/DWngPo3GDZ1l1TVcO0ZKHc4U28cnd9z+?=
 =?us-ascii?Q?NE8eSjqm1uuQRd6AgYzE2r+PppLwtE9gf8ivVRauBHr4+temGT+yHQm8Qikx?=
 =?us-ascii?Q?wvCVO1OQfcqaBP3KZzwbwgPAGgjFySsUwhg5hq1VTiWMsus3VtqDcFo1yaw5?=
 =?us-ascii?Q?y9GvhXE+iPNQAyc76A6NL2XMMaqEetvlHgf7vE5WA5YbFZO8chK2XPoEofG3?=
 =?us-ascii?Q?hT0nyO4T1zhnb13atF1JFG8ODRuPuwzjfP1PRd7Jzr8WQWYilx1OgE21OUYD?=
 =?us-ascii?Q?o2Vq9RYnN1QKsKdbLNqMGQhbyUWLoypWH7eCfOFXn0PuZHk1f6+elDyXITte?=
 =?us-ascii?Q?vI8l+yx/qc+aOnuk//qbVDknqdfQisOOD7O/YstjPYhCXsbkuB1qRkDKgk8J?=
 =?us-ascii?Q?FROFpGKg+dQxEp88FU7HBYpm/KA69mOI+VyQSfvkfRtAvOeA002Oto2DIEj2?=
 =?us-ascii?Q?AqQaayNjOHCkguLDdIhQIQMWHtcQUndUyrAy/fI5oL9rN7KYTmR3Ikkom6ub?=
 =?us-ascii?Q?LjI/+gwuDx9DFue5c46fdTdaJHAe7TcQGqylvgrQUZyVI4frtKVpcpFTZPFI?=
 =?us-ascii?Q?iKsnjZ3UXv6TuFlFTgKjWb6tPa/fs1Xysg9GOEsrzJcb2mgwn7NFsIufpKea?=
 =?us-ascii?Q?bC4ajDY5DtAI/zNJs38X3Wt87/mKSSJwXpgtFYOIpkBXIvn+DbmM59n0o9Xx?=
 =?us-ascii?Q?C/R+GwD2cK4RFND/6H2KSpkm7jxt5g84jmIsSg9TME2v3omvHb3AxLAOwopR?=
 =?us-ascii?Q?aVGRv/KIkRxP1vJSlbTUJKexGtJnouwAcZcUfWCpdlnmWvyrVNXW0IV/e8g5?=
 =?us-ascii?Q?VysD5CgJ53j8AiPJ3dT5cELzVwq68GgdqJluJoONvSwX8LqliSccWKdJBpG6?=
 =?us-ascii?Q?jxrjS6NpJCLJqVOF5nKo7PFdS/zzIT/ih9yKNaYvWLgB4sJSDVtRw8e82d6W?=
 =?us-ascii?Q?iSs98MNV9MwiJ0j6meup15IwAMpHZ1/gP/srOjZUZtmHred9U9dwlP9tC3bB?=
 =?us-ascii?Q?tBmql0rCL1uGUVpRqtgpUpsYW1dZvSCdUs0ydxyCfUTYn/VPNrMxHZ1YVk7/?=
 =?us-ascii?Q?twF3cJvrhgAqAec2c7tqulI7TdiB/YcBSLOU36O1ioJBdqiaNFXzEbEW77Lb?=
 =?us-ascii?Q?Yg8/7SQeZ6GPCFkRxhH0HtTPU+E7aDe0VhEQ62CrdV/wqU0FxfgRvzSrO3+j?=
 =?us-ascii?Q?3F+N3YY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Me4/cywG3ifAbfW4S6noyVvyMyPvdVJ7iPlC30RPUENzo9MbzD5agC1wgVHM?=
 =?us-ascii?Q?25tqc37wCIre3e3Iqvk3xovftAAtSuYcyEh2Ug1w95d5Cft6yO3GK2LtIe+V?=
 =?us-ascii?Q?ccFRbAhfzjAmnV/goDLtAlDIfqz3GoY0ElJ83o7u4z+Qd9REJViy3+z5ZBUF?=
 =?us-ascii?Q?bXP3zUo5Kpm2XZTwSJXEpymaKjUl5sOkQk3NKcUADOr8RoRf7n7B8QdbrQff?=
 =?us-ascii?Q?4dluluTc1LIdsiUAK34DJE5EKY6zuWvdeT7P9Dsdi2VxQgFoDW+3cqvq9MOT?=
 =?us-ascii?Q?EevScmNPnzo+LajStd+ldKa2D6pnntTOZilIsf791IAVR7ly5sW0Pkn23Rhi?=
 =?us-ascii?Q?PIYiV28SF4zUKSAeFadDcXtra/iHGk9fNZFfGVp7snrqJDLBMNg9P0jD6uVS?=
 =?us-ascii?Q?1RgClUm63eDBsOUwJlml3ufi1Ta16aVMCp486bT3IsNby34VXGElj05qeI1a?=
 =?us-ascii?Q?4fFfr33DynfRWJeyJjr6iEAbIxZxwHfoGk6NqUv7dbFfl4UB8+K9nDZnQisw?=
 =?us-ascii?Q?NcY+Yd+wArR7Ec4H4u+KE6sJKWSAAfmAwENRY1NynUlQhryJbMJ5eVQIo5GZ?=
 =?us-ascii?Q?WcONH78vEWn3zcGSG7UOKDGEuwXskC4EVQnd40ZAPC/EFqRKxxRiFzSHPywJ?=
 =?us-ascii?Q?bcZwmQWwZpM/UqWcTey1DcL+SuoJn4NsJDUAKlVbbEMpWcU3w70OC64oYGfc?=
 =?us-ascii?Q?3tweHf8XVJ+rJeSf20Cy0Q0Pep/8jrZ3XSK28dgwlLso/ML8TX4g0a7GSQHV?=
 =?us-ascii?Q?c7Falmsf6KH0tcozNn3naIj6kH7WGt+VPUdDcl+jDEPmc6jRDVo99pzzCRAV?=
 =?us-ascii?Q?gArIJKYtsiTm0rfI0293/7PS+RAqQPp5UmzlYv1mkKtyx75uVNQPILr6RlXr?=
 =?us-ascii?Q?3UYhYAV2+Ly2cfdRG7okK//eAMsoNm4t6lGm83CXO/DIK0teqNvrBoxxO2/w?=
 =?us-ascii?Q?6NuAqbJump3JUPJ/ShPDiZyWu0i1biQk1Homp35dGsIZMmgTMIZ+KFOFl3uJ?=
 =?us-ascii?Q?Xq5K4WnxVBkkT2i0eJdw8glYHRXr3dJAvi5vIP0Y7Po5RfvspigfBdgI1yVf?=
 =?us-ascii?Q?0Yzgmd2x0JUbfbHApT3jro6cnxFktkjrXrs5HkW88kffOx0Z+o9ej4oevneH?=
 =?us-ascii?Q?LPXgghAatGVXok8GQUH5zmMdzxmZnjqLB3yMaMWBxhbwl2DZLHtOO2It3EMB?=
 =?us-ascii?Q?iazR3Zh+V+OkxlyMCXBH8OYaSZ6aHfcx9ndRqfie/kFace91WBrPIXJP4K5Y?=
 =?us-ascii?Q?3mmU48ELsIgq+dfF5lkuKxonRjqpmaDshmubOehvWHr9BFUE347IM7NaiUs2?=
 =?us-ascii?Q?JJmDAYqB9dgfgi9OC372U3Xi5DZYTzV+8Vib1IGbEM8HoU/EBqwN98LAeBVJ?=
 =?us-ascii?Q?7opRuBYH0X5N8lhN6u1Jsg07O1hvFs1nn8cDjJckjLPeHzWfW9gc1oX4sFvS?=
 =?us-ascii?Q?0W7nsX24+V27mjszvuNO44JYHaOl1w+CHpCKElN+11IMDdpgF4iQ3dKZAJqT?=
 =?us-ascii?Q?Uc0UsdVa7C/6JYZcLyeowJAs1AC7DLHAVZreOGO8WbJ5nQMY/yQ5PA9GEhc3?=
 =?us-ascii?Q?DeeVtj/F6gF25ukhJPfbucr1jyuCi59NqYK2M17mNDaEOGm1nVO5W2uE64hu?=
 =?us-ascii?Q?A9lmAJgY+MVe70fLooD3NFlSc33WeAOChrt6058rwgjtdABF1uxr2juHVFsj?=
 =?us-ascii?Q?QHoG+w=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b1666f04-3945-4f10-4085-08dd13e2ad5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2024 21:37:24.8131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C2JHK8ywfySrbtSOfHldzzieddkl1f7mQuU5SxOxwqof/lR6Ekyr7m3vY/ma5U2DP01nc5GDjz8BymVMo2IpC/lQig7Jp+cjySi0YWO1c9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8762
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Tuesday, December 3, 2024 12:01 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: Nhat Pham <nphamcs@gmail.com>; linux-kernel@vger.kernel.org; linux-
> mm@kvack.org; hannes@cmpxchg.org; yosryahmed@google.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; ying.huang@intel.com; 21cnbao@gmail.com;
> akpm@linux-foundation.org; linux-crypto@vger.kernel.org;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.co=
m>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources=
 if
> the crypto_alg supports batching.
>=20
> On Tue, Dec 03, 2024 at 12:30:30AM +0000, Sridhar, Kanchana P wrote:
> >
> > > Why do we need this "can_batch" field? IIUC, this can be determined
> > > from the compressor internal fields itself, no?
> > >
> > > acomp_has_async_batching(acomp);
> > >
> > > Is this just for convenience, or is this actually an expensive thing =
to
> compute?
> >
> > Thanks for your comments. This is a good question. I tried not to imply=
 that
> > batching resources have been allocated for the cpu based only on what
> > acomp_has_async_batching() returns. It is possible that the cpu onlinin=
g
> > code ran into an -ENOMEM error on any particular cpu. In this case, I s=
et
> > the pool->can_batch to "false", mainly for convenience, so that zswap
> > can be somewhat insulated from migration. I agree that this may not be
> > the best solution; and whether or not batching is enabled can be direct=
ly
> > determined just before the call to crypto_acomp_batch_compress()
> > based on:
> >
> > acomp_ctx->nr_reqs =3D=3D SWAP_CRYPTO_BATCH_SIZE;
>=20
> With ahash request chaining, the idea is to accumulate as much
> data as you can before you provide it to the Crypto API.  The
> API is responsible for dividing it up if the underlying driver
> is only able to handle one request at a time.
>=20
> So that would be the ideal model to use for compression as well.
> Provide as much data as you can and let the API handle the case
> where the data needs to be divided up.

Thanks for this suggestion! This sounds like a clean way to handle the
batching/sequential compress/decompress within the crypto API as long
as it can be contained in the crypto acompress layer.=20
If the zswap maintainers don't have any objections, I can look into the
feasibility of doing this.

Thanks,
Kanchana

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
