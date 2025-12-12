Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0732FCBEF;
	Fri, 12 Dec 2025 18:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765563434; cv=fail; b=b85cI6q5XGSFVE+R+Hi5BJr+pR0q2yR6EUR1C7JV6qSnFvMXsKPZZYjNftQXOoWf0XkX4Xjg3zrrtGqHmxfTDW2wRD3XITW0BYy9gfYjJY0jfouhMTU2rPZyQUFnuhJoQBhS2v5Ttk07TWWrc+g8Rk4nbTjYgE5R8DFj1bTtc6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765563434; c=relaxed/simple;
	bh=N0RZZEulvTnZdK6j2x2l7u/aCIcORp170GpWJlMnCSY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qKU1837OI3lrMKA5W5agoCFVYR+w7jFAnP2KJR/lLloeE/g/JS5l8qC/HybaX9/3hcZX1Q3hH5aWr7QKi/lEbWWgwYIpZut0itRLiERMqxZbeYezC7jKJHiLkEdWnDJgwFzi1XJ/QeUQYaTr+TuxsNayBeXNNl7wNBy8DEcXTUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DUELJg+x; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DUELJg+x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765563432; x=1797099432;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N0RZZEulvTnZdK6j2x2l7u/aCIcORp170GpWJlMnCSY=;
  b=DUELJg+xxCVFxvm/65c5JnRWlLKlYOrq0JjMKgfFmGZnyNaLGIbrhDtj
   tAXm2lXHTUr8LCOLmWv7ASiE85Md1ePZoyoGRDbTW/PRHkRjPhCnq+ucw
   wxfpyuq/mqXcI+0elkGRHT8EeIK/WervfCv/yhYPY9Ei5kwaip7dJ23Zz
   Ryf7i5niCVEHNt0k0IlZFdurTy3eHTwmvlizEZUZvNOl8sW95ytsVzsl1
   2BIh+QN8cSidZjhSferiOLIjj2gjwi3Ny4uAoZGSRGp+vRa5qphC3U2NR
   m7P1AQ+2Aefin7aeGwgmrCfX0U3GTMCL1w4jr1PMlGDXDsXiOh6exe0SA
   w==;
X-CSE-ConnectionGUID: BiBkeIvcQZKOUPou2SHaZw==
X-CSE-MsgGUID: TD5nys1hQcuXXnRI22pJdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11640"; a="67728752"
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="67728752"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 10:17:11 -0800
X-CSE-ConnectionGUID: ToIlNsKXQf2fA9EHqqKtyQ==
X-CSE-MsgGUID: xEZ+MZ9iSt+XrBODY+Qy5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="197973362"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 10:17:10 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Dec 2025 10:17:10 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 12 Dec 2025 10:17:10 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.41)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Dec 2025 10:17:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OpeUkYy2XzmJlK2nMInWkbrtvs/kR8FZ0jQY7Xe3fW5JlYAoXIAPhykIXN59C+WdNQNEIKAJPyYLh9zfdpghx2Rn7WfVcCwOgUwQoJqRRWJgmbELPywkMUknbYPGzJlv5ztxrUA5qai49r1QfBOU1LHlf68wtHMX9tdgaN6Az8+t8HJsZH+XqzCgu/Qscfs+YNiMa7Z1opgASAYpO1PyYt1yYDNBWDaDU+Ui3SAWRYq+XzYRshPCcpssLdGFlNVXPf15vVM7WSYuOneYzKTSZS7U6uvmK9etiu1rLE373ue1uCIVpWGsSIfzMPFMBqWOv+ZOFSqH2HIgfAo0pxO8BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lGMGaHBsaSHxN9gsS6hktJYFrW4acaosIpGCeEyANhU=;
 b=Fiue6QJE4wfRGA37xNan7uq5zWvdWMSg9H0GQ82T7ZdBYrp0/w41WscBelNH/Cp4w09Y6NlLAs/OXnv1yYi6m/2S6FSeY7EhMXXq1W2noeWP64EJtGUgz5ggZqHbLsbcQt7FfKN1D630cZRiPSRXGoLIXHYQbT9LIulzPpdIX3mgXKmBbV3KHVnI04Fxv9F9wMwuFRmg0YsCmtFQK2EceVerZDuXKZG15rX3R/K1F/5WlLuZCLdAdCN5eOwYwOSiMfKbq306UCyCuNG85KPlMM3KED5IMCx13TmsyhowXjiY5nmXPGHbaFJiDjHjA50Ycy61S5+WSbJyJsojhKMruQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by PH8PR11MB7024.namprd11.prod.outlook.com (2603:10b6:510:220::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Fri, 12 Dec
 2025 18:17:07 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 18:17:07 +0000
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
Subject: RE: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Topic: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Index: AQHcTWsygycgPn5uUUWANDAP/laxYLTxHCiAgC1uKYA=
Date: Fri, 12 Dec 2025 18:17:07 +0000
Message-ID: <SJ2PR11MB84729A04737171FCF31DB9FDC9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
 <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
In-Reply-To: <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|PH8PR11MB7024:EE_
x-ms-office365-filtering-correlation-id: e124bfd0-72e1-4c29-df95-08de39aaa90b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|10070799003|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?aOK3Fz79lOR1EwDHFY6zJD7lBI0zQom/sPIadzPv0vRHrp319g1Es2a40ZnN?=
 =?us-ascii?Q?IslrrLfqTgb4ON7QxsJltfTNAKnQRtVFu6e4fwvu/edr3KI/3xc30aP3TE05?=
 =?us-ascii?Q?79VbMAY7pBu8ehvJ6qFY7oWnDn8glepy6OISBXhE8HNuigBtrnMGToJ5+H7F?=
 =?us-ascii?Q?eMK4TVfjK65Yn04zHhU63oUkz1IHU1VDNSKRiA10xZRG/cqn5DV/GnxBF/AV?=
 =?us-ascii?Q?k1vw05RVlrbVeVNw0+osCjY94fhChUbr4O9svF0Q9jUnuZHrmlicvFH9+KYZ?=
 =?us-ascii?Q?AvUW7bdwhv0UYVwL5jJrqz4eawNFirYuyNb3hCh0bBQYWqJsTZCWsjt5+Tvu?=
 =?us-ascii?Q?z51+NWIzrg6WGj7cFWXgGl9adP2OiPw/T5ewWuCoMA0l8jh29izzq/pCffaq?=
 =?us-ascii?Q?3M5v8Wkqwtswe/3vKWUQd+qoBgAKQSCo2ArD1LOqryycMyIvLLJorKlGdhG4?=
 =?us-ascii?Q?E7LtBTVYCs07Jc/J46sUy+LO0QzOu5DRwpklRmaInclL6RRnTjS6jeD9V0Mq?=
 =?us-ascii?Q?30v1ughwFSF7Pb7rSWxT+z8XIOasU1DkdNUGlWMSt/5ka+fs/c2XWDjKqY2w?=
 =?us-ascii?Q?OTU7DSlEZTYhMco1A+jDldnD+m9kSLA5/GrgOFfkAWHKFgzcLSJnXcLHmRmA?=
 =?us-ascii?Q?2OQUYeLXhHLNvMYWgucbLkfJLxZgRcJ/4zAU8sBMs6JhQxgmQ8NerOrAivdP?=
 =?us-ascii?Q?G0THj6y9+KJdq0/DUm9SSkImc/TGulA8BhGUaXuCfRSyVsSOZJHsVE8VE7Wj?=
 =?us-ascii?Q?quJDuqZQqILZHoajEVSziaWhENY8+Tpba4D4kFMoTc6QJOIz3GabK7O584JT?=
 =?us-ascii?Q?CaH/fXNFrBmMWVrr0tvPskU+yyjstTxzaCGfZ03phYCETHFB3pJTPWCWSEs9?=
 =?us-ascii?Q?zFXAX0O/EUpWKMN30oRaEveicN8nkAtN69p0ujzh1YkQcQQ78ASfzyDdWHrl?=
 =?us-ascii?Q?D7MpRpYzNvFgVt8blb2e4G96tjD5renvbvm+KCtkig2PPRf/N9oadtiWy8lp?=
 =?us-ascii?Q?RC6jRk7/OtVFmUhRq9GhHJdoO2IXoIPxvKZnYsounVxyUKDlME7RHJCKs1uJ?=
 =?us-ascii?Q?UM8fNDiEPf4iSbCsymrPVjOP6lUz6QYw2cwVEkxnBQAWS2UyrW0hqZa07TfY?=
 =?us-ascii?Q?EPBGQ/SEgkvJsXLRpkvVaetd93uHkfTcnlqg4gu1yMaCtSsYi6CwQ2/VG1Ik?=
 =?us-ascii?Q?MFm7SKuDE+oKmE19tddmw+KnfeFFtNCmRpzBvYmOn34E9MX9Zzim39PffVxb?=
 =?us-ascii?Q?mWZF56FSZ2+VhQWGsgCSrakx64AQn5zMRlFYqGq2vuEVJDuKkCT2DTSbTqgH?=
 =?us-ascii?Q?nCBsWerHYVIGYlLU5JqptriHwe5ikXdFbX0+bqx3VmxRcT+InXOa31XVtHzP?=
 =?us-ascii?Q?OaduaXpGuT5YQMBmUBm19NaXxlwPrB8hPrWmKiuLe+3RiYE/liqFbGYmnnPA?=
 =?us-ascii?Q?l2JXdCjZBlWvbf+Ikw5mF1PCzsfe/SCJ52uEfADeZbPoIWqAasasP+6hH+sd?=
 =?us-ascii?Q?iRJazJFZuPbSqAv8MNaa09CeaW7T7ROn2ttv?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gwDL0Xy3jnxMJEm/y2z9pugD4ac+JQFGCgzlgM36rAhLaQRMyzNdIH6y9iN/?=
 =?us-ascii?Q?rXxkgWnrlrmAqiM5prCG0BsYfOLAml8C2B7Zlhv9Us6HDWkZZ0NzMiaaaw9I?=
 =?us-ascii?Q?iU/56QF4Q3l/+JmXLbNeh1pwwU58p/R4tpBycBEAal7o7YbpAv7IX7WlJw2L?=
 =?us-ascii?Q?pajQiiBSZly5U1Jqds9VPKCsBew4a8mhwyLtYyyS9rEgWWfpMozYo+567kqo?=
 =?us-ascii?Q?km5u/Gc8/gZiO7oEWwAjvv9nEKRHh6WXk87rZxhKcHT8DN4Dnm5pTc7wtATD?=
 =?us-ascii?Q?ObqcU7vhagleANza2HTvYOpcz1dsskn9pTKYGgFwbXoe4FzaKzTnD2oATRQr?=
 =?us-ascii?Q?+Ih3qzanlWrynsIr7QKNTY2CQx8LngbXKTfzDwh45zOXoqjhcrPHEE11QUaU?=
 =?us-ascii?Q?vJ7J49oS9D+hq3bmT5YJHBICQQJ7/4/6hyzjJ+uWNrHaP5tjQKsREFS6yPAk?=
 =?us-ascii?Q?CCKUMWFAURKr5BH012TBsjlC3vFVRDnxSeSVE0UywaccAtUcST8+1w5OOt5f?=
 =?us-ascii?Q?8OHTr1lgc152JEFXZ/Z230q65t0hCF/35JABJ7688plRdlZ757eVgqIhROuk?=
 =?us-ascii?Q?SPUOqG93noJc9FofyyT5lmDuFLO9bMmeE+y3to10LN2nD5tV1SIdPKrSjfu5?=
 =?us-ascii?Q?5+R9fDAAjMyQlRFjmGMW3B409c//cdd/Ej+e/oY+rT6wLg7ks5BZTFyFeV1k?=
 =?us-ascii?Q?TT1dJX6fQu+WJI5V76wucf9xZlvZHDvCBRkCJz/5OSVb6UiSkgpZzYE+YLhO?=
 =?us-ascii?Q?LX9TUe/+67HlJ/E9NikYvzxYp1RxhdZYoyWrM61VzmSIEZd9d62R5oeH079W?=
 =?us-ascii?Q?gkCHZtvxVTdC69w1TswqzX+WZ9oNXzkwH8Mz5Jyh+IgDIB+E39M6IJDP1Ctz?=
 =?us-ascii?Q?BkfbfFHRP1GIQwWIFxqF6VYgSsN2VH6qmawjzbiBVEaWD4HggCEX/f+/DNcm?=
 =?us-ascii?Q?JCkkTh1t4ryWoR2kATzCVgAYI14l0UyR8+1UR4AVcChp6M8rIjusCpt7qSb1?=
 =?us-ascii?Q?tRaQXSXarCSyRYb7ZERd3QJThqHLiPxJujP3Ds6vNDDNgWlyUngJV374bRir?=
 =?us-ascii?Q?6jWJvl+M5hOcMnixGjDZ0ji1omqvDBGIEsm8DqqkVIe4cu0duZ1NoF7GWJdz?=
 =?us-ascii?Q?tY1ve8zeaFnX0122FldWo7PhOF1an6bRS9I8/M4krsEw3UXYt/ysiB07evyQ?=
 =?us-ascii?Q?DKdNnE/eLV7xW0pvVNnESIud96bEk4F32gvFKLp4WRje9sL5aVsepfniAiIn?=
 =?us-ascii?Q?8iOpFMzirGWinEHSOwaFcIpvNpxMv6nejOAs0fND/1zFgBTcY+hDpAPiXulQ?=
 =?us-ascii?Q?dKWqb9rZWPSOQP6eQWjsFUjd150qGs9/THtonOPNMc7j/VIqleswTioO1/pl?=
 =?us-ascii?Q?RA0sd+LFX0Llfpxw8hMRcMw+QiMb6W8fFUW7fR8ACoJ+GVaQIpycUtEP0w+W?=
 =?us-ascii?Q?yLZT7DW/IpLPogLeHvHn2wRp43JJX8X7VV3HsbiMfPQvgg/fsQ7lcc4hPN2k?=
 =?us-ascii?Q?nl0dNWtxC5m8lRD5LSOYvOR6Uxcyix7KjwpdfoLBPsJjV+Sh3fw5NzaeMJ2o?=
 =?us-ascii?Q?TqLtCX9qf2dO7SGStYDMngu9dpZmXcBCNP9D7zw88PZ1MhimEo3yPG9YK3c5?=
 =?us-ascii?Q?Q1SAc4uGCN1NcyOIfau3F+GBmVELk2+BWZ42xb509iOzT41Ef+GVK/IsTM9Y?=
 =?us-ascii?Q?Mk2rQw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e124bfd0-72e1-4c29-df95-08de39aaa90b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 18:17:07.6024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3+hdvpIsStp/UJV6FSwOsMiZWyK5HzrCPPIcgYZnscBlBUgDkyjC02uXTAAK6trsMqfjsrU1O/HwbCrAnAvT0DGOptI1pOXg9tUkap0tWcY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7024
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, November 13, 2025 12:24 PM
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
> Subject: Re: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources
> exist from pool creation to deletion.
>=20
> On Tue, Nov 04, 2025 at 01:12:32AM -0800, Kanchana P Sridhar wrote:
>
[...]
> >  mm/zswap.c | 164 +++++++++++++++++++++--------------------------------
> >  1 file changed, 64 insertions(+), 100 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 4897ed689b9f..87d50786f61f 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -242,6 +242,20 @@ static inline struct xarray
> *swap_zswap_tree(swp_entry_t swp)
> >  **********************************/
> >  static void __zswap_pool_empty(struct percpu_ref *ref);
> >
> > +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
> > +{
> > +	if (IS_ERR_OR_NULL(acomp_ctx))
> > +		return;
> > +
> > +	if (!IS_ERR_OR_NULL(acomp_ctx->req))
> > +		acomp_request_free(acomp_ctx->req);
> > +
> > +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> > +		crypto_free_acomp(acomp_ctx->acomp);
> > +
> > +	kfree(acomp_ctx->buffer);
> > +}
> > +
> >  static struct zswap_pool *zswap_pool_create(char *compressor)
> >  {
> >  	struct zswap_pool *pool;
> > @@ -263,19 +277,26 @@ static struct zswap_pool
> *zswap_pool_create(char *compressor)
> >
> >  	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
> >
> > -	pool->acomp_ctx =3D alloc_percpu(*pool->acomp_ctx);
> > +	/* Many things rely on the zero-initialization. */
> > +	pool->acomp_ctx =3D alloc_percpu_gfp(*pool->acomp_ctx,
> > +					   GFP_KERNEL | __GFP_ZERO);
> >  	if (!pool->acomp_ctx) {
> >  		pr_err("percpu alloc failed\n");
> >  		goto error;
> >  	}
> >
> > -	for_each_possible_cpu(cpu)
> > -		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
> > -
> > +	/*
> > +	 * This is serialized against CPU hotplug operations. Hence, cores
> > +	 * cannot be offlined until this finishes.
> > +	 * In case of errors, we need to goto "ref_fail" instead of "error"
> > +	 * because there is no teardown callback registered anymore, for
> > +	 * cpuhp_state_add_instance() to de-allocate resources as it rolls
> back
> > +	 * state on cores before the CPU on which error was encountered.
> > +	 */
>=20
> Do we need to manually call acomp_ctx_dealloc() on each CPU on failure
> because cpuhp_state_add_instance() relies on the hotunplug callback for
> cleanup, and we don't have any?

That's correct.

>=20
> If that's the case:
>=20
> 	/*
> 	 * cpuhp_state_add_instance() will not cleanup on failure since
> 	 * we don't register a hotunplug callback.
> 	 */
>=20
> Describing what the code does is not helpful, and things like "anymore"
> do not make sense once the code is merged.

Ok.

>=20
> >  	ret =3D
> cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> >  				       &pool->node);
> >  	if (ret)
> > -		goto error;
> > +		goto ref_fail;
>=20
> IIUC we shouldn't call cpuhp_state_remove_instance() on failure, we
> probably should add a new label.

In this case we should because it is part of the pool creation failure
handling flow, at the end of which, the pool will be deleted.

>=20
> >
> >  	/* being the current pool takes 1 ref; this func expects the
> >  	 * caller to always add the new pool as the current pool
> > @@ -292,6 +313,9 @@ static struct zswap_pool *zswap_pool_create(char
> *compressor)
> >
> >  ref_fail:
> >  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> &pool->node);
> > +
> > +	for_each_possible_cpu(cpu)
> > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> >  error:
> >  	if (pool->acomp_ctx)
> >  		free_percpu(pool->acomp_ctx);
> > @@ -322,9 +346,15 @@ static struct zswap_pool
> *__zswap_pool_create_fallback(void)
> >
> >  static void zswap_pool_destroy(struct zswap_pool *pool)
> >  {
> > +	int cpu;
> > +
> >  	zswap_pool_debug("destroying", pool);
> >
> >  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> &pool->node);
> > +
> > +	for_each_possible_cpu(cpu)
> > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> > +
> >  	free_percpu(pool->acomp_ctx);
> >
> >  	zs_destroy_pool(pool->zs_pool);
> > @@ -736,39 +766,35 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  {
> >  	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> node);
> >  	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> >acomp_ctx, cpu);
> > -	struct crypto_acomp *acomp =3D NULL;
> > -	struct acomp_req *req =3D NULL;
> > -	u8 *buffer =3D NULL;
> > -	int ret;
> > +	int ret =3D -ENOMEM;
> >
> > -	buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
> > -	if (!buffer) {
> > -		ret =3D -ENOMEM;
> > -		goto fail;
> > -	}
> > +	/*
> > +	 * To handle cases where the CPU goes through online-offline-online
> > +	 * transitions, we return if the acomp_ctx has already been initializ=
ed.
> > +	 */
> > +	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> > +		return 0;
>=20
> Is it possible for acomp_ctx->acomp to be an ERR value here? If it is,
> then zswap initialization should have failed. Maybe WARN_ON_ONCE() for
> that case?

This is checking for a valid acomp_ctx->acomp using the same criteria
being uniformly used in acomp_ctx_dealloc(). This check is necessary to
handle the case where the CPU goes through online-offline-online state
transitions.

Thanks,
Kanchana

>=20
> >
> > -	acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0,
> cpu_to_node(cpu));
> > -	if (IS_ERR(acomp)) {
> > +	acomp_ctx->buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL,
> cpu_to_node(cpu));
> > +	if (!acomp_ctx->buffer)
> > +		return ret;
> > +
> > +	acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0,
> 0, cpu_to_node(cpu));
> > +	if (IS_ERR(acomp_ctx->acomp)) {
> >  		pr_err("could not alloc crypto acomp %s : %ld\n",
> > -				pool->tfm_name, PTR_ERR(acomp));
> > -		ret =3D PTR_ERR(acomp);
> > +				pool->tfm_name, PTR_ERR(acomp_ctx-
> >acomp));
> > +		ret =3D PTR_ERR(acomp_ctx->acomp);
> >  		goto fail;
> >  	}
> > +	acomp_ctx->is_sleepable =3D acomp_is_async(acomp_ctx->acomp);
> >
> > -	req =3D acomp_request_alloc(acomp);
> > -	if (!req) {
> > +	acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> > +	if (!acomp_ctx->req) {
> >  		pr_err("could not alloc crypto acomp_request %s\n",
> >  		       pool->tfm_name);
> > -		ret =3D -ENOMEM;
> >  		goto fail;
> >  	}
> >
> > -	/*
> > -	 * Only hold the mutex after completing allocations, otherwise we
> may
> > -	 * recurse into zswap through reclaim and attempt to hold the mutex
> > -	 * again resulting in a deadlock.
> > -	 */
> > -	mutex_lock(&acomp_ctx->mutex);
> >  	crypto_init_wait(&acomp_ctx->wait);
> >
> >  	/*
> [..]
