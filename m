Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9802EA493;
	Wed,  1 Oct 2025 21:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759353657; cv=fail; b=kqG3QBc9Y7rys70QopS7AHQ6YJ8QzOHY8+X3dFRBu/NO3nya5r0efuRY8o9I7x/WopQ4otI0oiMSDudyw7ynrIAY1+a5gdumAom0aBNOqdIY7Up6dZTnQ7DGSv0r/6HSL6SE/4AbGLf4nIvbSm/HGHFrnKVal0i3dX2PiOT2b3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759353657; c=relaxed/simple;
	bh=Aj97A2rp+YMO+sHjHdWPmKzAEOtjm6mJ7kIKbVf14DU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lU5ubLJL8HHzntBUj6YLMTqXoy0R3yTpLxlv3pC+/Av2elvAiSLEPQTolqq3cqd2ldbB4qh7Ob6pvhzZGqRvs2N53R4XF7z530+/aJEqrxnVhGcVHnEuPUzjOaLVS7ahdIf/7fV36ylt2LlOLeaP3SkRPAiqKIQgK4WMNdCx8Og=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e/cZl7O+; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e/cZl7O+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759353654; x=1790889654;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Aj97A2rp+YMO+sHjHdWPmKzAEOtjm6mJ7kIKbVf14DU=;
  b=e/cZl7O+2QmqvzMJXdaHUfg78hj/l92M/daPWL2atpAlOLCli7T6mqR1
   TwtPjAr+yWLiMrOs91WUtLsWATegXS4NAB0GZ7P6R71TzzwscPgYRkxlZ
   jo0NIo+2Ef0Nn3N1YneMOpgxtjvlXHNDxtKDEwYkW+zcz/Vn0gAW+eYeM
   7HVYeskFC/auQaXK06Sn9HHXSIJN6+sFu+zksLJo221tP2viNTkT2KcYa
   Y3Zf0acGW8tkT6gm1cWPw6p/OqO3R+EtaJPGfYAqlgTkZw7jBNCCPnPyL
   AG8ShCMGt9Dc7zFZWVFz0uHUrpAfoAYGHs3t6sDIRrPqYOvHLJO1iyuUS
   A==;
X-CSE-ConnectionGUID: nQCxkHKiSLCX8QOQUb1TkA==
X-CSE-MsgGUID: CMB8Qe0kTdu555Q0skAlRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="60854693"
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="60854693"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 14:20:53 -0700
X-CSE-ConnectionGUID: NTLMQbYWRiy4S7ln77MAtQ==
X-CSE-MsgGUID: X1Jcngd7QtaqC5bJFLhzVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="183285812"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 14:20:53 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 14:20:52 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 1 Oct 2025 14:20:52 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.38) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 14:20:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WDFrwR4MsJ56YN4JMA2yJBjOHhw2Rr+9pZDEcrmPireamafRy2q8CX2gSAX6Rvx+foVq6NKDHQeIjzR9BlQV8SB8R950t8395BNCUk4Uo0wppgOcs5wxN9LtY02tPE39Jy4dTaP5hT9QD5v+Jgwd96XR8V+i2jLImqZvba6oqE58fcvWvQhH6AyKPJRZ6nAsUt19xIvMOAeAoDpeaKnD7ARnSkiI26CspM8WnLyxlRmpnjuhkNwXwIGlHRDT1CavpA8fIP6fayJfpW4DGzFn34cOYjkg8PWL/eq/csvnEn7x1wshOZvw1lF1NqXuhjj3xr8cn/AcX6oJWgeYpL5iog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R39DCPB26BdquE/lY0ljMp4r+gdpnuXfjpVOzjhvaQ4=;
 b=PJGaHX3cvXZnmeAbR30uvyrDc9tbx5wKR4B/+AWJN5okOCpjxiV4yf7laEG91adZq9l5Zdp42h+/J5YlvY+nBxrqiIeGjHYCW3ydEDZ+h024XLB0LDjP7yXUOwdPhLDEEv3d3n9xrUX6Eitdd/AY4lQ+klBMvVsRTLwSaa3gNB6b+0gjgqJMnQk2tetN3kNXY65+Oj5dLe+EYJhQGomZO3mhemfdTm8t6AaZMb2iVO8Xk0tZDezkof+9rbSACc3NcmUq3wF+GLzmkcl+fTk191CM+uEqJwW89Yxm09SiOQKvW37H3HFt5P4Q0VW2hBd+5w2n9BftjtvSsl/2C6qkaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by SA1PR11MB6918.namprd11.prod.outlook.com (2603:10b6:806:2bf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 21:20:49 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9160.017; Wed, 1 Oct 2025
 21:20:49 +0000
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
Subject: RE: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Topic: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Index: AQHcLpaY70ekQ7dio0CIg97nnm1fBLStgQgAgAAW5fA=
Date: Wed, 1 Oct 2025 21:20:49 +0000
Message-ID: <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-23-kanchana.p.sridhar@intel.com>
 <2qvfjavbepw3sq2pvvcez6jsc3bxkxej27674l4ztfdza7jqaq@xi6qndkj5xhh>
In-Reply-To: <2qvfjavbepw3sq2pvvcez6jsc3bxkxej27674l4ztfdza7jqaq@xi6qndkj5xhh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|SA1PR11MB6918:EE_
x-ms-office365-filtering-correlation-id: 106b05ff-18e0-4be7-66f3-08de013064d9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?eMBfVe0ZZAhP/oNN69KMLZgu4HvPE8x/BJpjJdz2oDYDBYKymQcKS9ubTQ9W?=
 =?us-ascii?Q?WDv7uyP8nWDuLoxg72IvZEFdOd3+gzH7m0yzRiIRVQU33IOhUmfXRe3d416U?=
 =?us-ascii?Q?L1rwxcjKl8gT4ndd3HxHO+bNOkMXk2z3yzUCdohYEJmF6GB74CvBI5Uwa8NW?=
 =?us-ascii?Q?ZFDOZ3QmYUB5eBFM4DnAC95Mxow/c7Jtpqkue/rTpo0X6JKZJWjtsuhDIh5+?=
 =?us-ascii?Q?efbYMGiG4xKIp/Z5SF5LgOZsBPphjKs9q7nKanFggpu8sO4osNqpZBAYugJf?=
 =?us-ascii?Q?agqY/4DzlX57qG4b+4yoq49jsKhpuyaWEr2M5msT/oeXTO6QBfpQv1PJBeXk?=
 =?us-ascii?Q?8HBcV5q6wdueuIIXLOn3M/35SgypXE8DmEHZtNEGxiroZT/A1trIWWenyamp?=
 =?us-ascii?Q?sZad7gCG/HOzkODKLBaG9N6LdSHx3fLBkeseeqITkwCc+jjzItJy+K80t2Gx?=
 =?us-ascii?Q?3HErOA6Ulrdr8wFUAG4EZV2rsuagGWLeBUfbctLIl7qO7aO2Zys6fvMHHtWX?=
 =?us-ascii?Q?zUg+T8Qv+Pu/tJLjg1auVLgkAwQunvR5sokgjZuL/QOYxlJCRZz+UJiX9edv?=
 =?us-ascii?Q?oUE/yka+FFRygX2NsqBhTUU1O9lp3iGYTrekXoDFiCIVJD6ifR4hobedIxyw?=
 =?us-ascii?Q?cDdCEoQNJeVF6Ldb0EdsZ3LPzLQ+v2GvbAcx4S2KjBuBRxVW01fYJeeXHAvY?=
 =?us-ascii?Q?WYgte/pabXw4ymJ4DIFmPX57xlM1+5jL7kuXjiOvMWWwgDPyMQk0PtRWl76n?=
 =?us-ascii?Q?pLH7EcfOzQw2WOOSuh82esrr1W3pwvQVK4DZv+Lm0aeajHAWp+YAJ6KjGzFJ?=
 =?us-ascii?Q?zIsihlxq/0A5gWsRV+a11LYa4bO1MDPHxLxzv6eC5/gDrmTVzuoI30oV3Jys?=
 =?us-ascii?Q?R8CLgx+fRJ9Lp2/1pMCmwxBREXMpMJzbFh4roIPsoIrGQjhl0pyG0Cw8QnT4?=
 =?us-ascii?Q?RFNWJGXpSLvTtL/BWQD5wb4SENE2yQI1Gy+M9Elt5hvTApgiDS2v8J6gcN6k?=
 =?us-ascii?Q?07Itzjhqe+BQ4rgs541mFWfW7yXJ4PZ7DjZ9oyDsYGD5OaAIsaGf2hFCDEYt?=
 =?us-ascii?Q?KhnlPNhWdrrmBi8lYX1uYozFx+ZAH0SwA5A9qkE8f41m31oY/ANKE1RkwG0B?=
 =?us-ascii?Q?caGTzAZfGICFmAxUlRl2En7+UkxVZo4djHXWTSNNt4yszTHhx5P9BKT6BPx1?=
 =?us-ascii?Q?8Dde+IXNp/0pCgZix3cYOUDYkgHZt72h4TQ+tMUm7dNCc6pDnZSv34SaYMiD?=
 =?us-ascii?Q?34MJzVBMuprbJ0pt1DR/rs+x/nzIuX7WM4nb6uDOJHPJgaSWAIPvjYLpi70J?=
 =?us-ascii?Q?bgon3WRMNBUx64Uxm0YKO8/xs5BYRyTF7CSVAsNcl5zplqEa2M5CBSpcHMiF?=
 =?us-ascii?Q?VflsgMN44OaQOsNkT8HRJJS9dfIUugm2pkSIGr47RFu9z8+lWGKUTGFvOxSy?=
 =?us-ascii?Q?qjavRCwE+QMn/uw8PKATxQfZK/Gc+B8op0VkrRIzv81n1igxudubow=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lvfFnZ2Kt+p7P4gCU0l/1VosWU21q1IIiNhYOPb1AXjdxtvSH4NNC+tJXAqd?=
 =?us-ascii?Q?dMhd7JiQ9rHh+wJusFamsmGbJzUnrs+RXxA+88nueEqnMOBDKTAzFnLEriY8?=
 =?us-ascii?Q?OsDWiIeJOskrxtncBKqCushPadC6nzHh0belBaHtAIK2WzznzeKE+gFR/9QP?=
 =?us-ascii?Q?MWJZdytAO2sWgzgtduxrXafwhBTxF7RSD6slBCS7U3WOAAO4a1jNdLMfHOqw?=
 =?us-ascii?Q?j6JrYHCDbgv9T/d02lf++EWtSPXc5EvaI3LHFvxCKMCf7KS9p7VgnamSBTk3?=
 =?us-ascii?Q?zYEQzdl3924bykowb812lAitYRQPmlhzkpDz1RaRhQXU6PgZPm0Tnkpc/0Rp?=
 =?us-ascii?Q?aYh7d05cEo0hOeqfQEo3dDEgWXvQJdyjYTsJsn/ZQvOfrQM3x2s4zD3b2suI?=
 =?us-ascii?Q?VC7nSZnyqE/obl0LX8WGDqR5PbUNk19mS+GQbZe5ecJbi9pkeHqlNQjoueVl?=
 =?us-ascii?Q?y/QXk24zcSKHhy93JXNc6as7Me/n1Cb6LRIfWtNycwRfpvJgjqjoLqxZZXpp?=
 =?us-ascii?Q?cUQuybt4N1WnwfOZ0fYpSk0YbjNZ2PmvMv/V/1HZ82aRt6TOC/Ib8strwgSQ?=
 =?us-ascii?Q?ReMQMNY1lQK+AnzlUcjPrhn2EkRiVG8E/JYS1KtL5b/QWWK/a4/3KT7vqFa1?=
 =?us-ascii?Q?lWb5HwLptJXY6Xt1w2USjL9HgquODchc015lCRJP+VAq1NhdYQuQvBF2b3NS?=
 =?us-ascii?Q?8b8J7fE5vXI749RhneteKWNDtDO7Q97nvog2LzbQlgDExtfPATr08ZnbOIDT?=
 =?us-ascii?Q?KCwTl8d56j8q/QqhJ1xVlZWgKBcgqgQZ1S5SbjfG92ZWBsNb39FvA8pdrGji?=
 =?us-ascii?Q?YAYRwAvW5/tvjhUPvlUBJvU5PenC7slOss5/n5REM2yToiJUvqxLzF2ZnuHd?=
 =?us-ascii?Q?9NWOuyGI99t8E/K7Ll9NTvObjIlU4RbZMVK1oEkBqjgmFTg7pm7pHpm8Zq97?=
 =?us-ascii?Q?mgHj5h9tHThMgIv75BYUPMPWsa9v4HFk/mXNMjAPnRz+7Pt8e5eL9/zK0oZ+?=
 =?us-ascii?Q?XbKRtOrOv9k9b18NvaynsUluk1BATS1KQIzpZjBbHccKHSNJTxNaI3mYEQTw?=
 =?us-ascii?Q?0329KgPD81D4Peba+LDb0lnjReCV/306tNA03zuAcev8b5Fzrgb1qst+rfUb?=
 =?us-ascii?Q?5Fe3UeHlce5DLIHHYjlKkAdY7NRbMF0iSrfnSLzXFqNiZ+d6Hkre5XQtFrTh?=
 =?us-ascii?Q?vETz8Vgs2bO2qYNEhBt3h+bC+tBTXwoxKojpoNXZaJr3QEC9+wIAmTG0V9pz?=
 =?us-ascii?Q?5nmcT7m0x/Jbp6LgB4x6eLaJ2AXvjgR5lQK0NXuKg9PGVWhA7jR+5twqC1yz?=
 =?us-ascii?Q?jkkOle8Q5CmtPHkdKAbmPmgXBxpEsL9VXO0KH5fNE3ECfmFTv2nqyuGn7Bib?=
 =?us-ascii?Q?cGqcuKr9tmhMpFGzxgmM41Lt4My81ny3keMvWPOOJC58iqXFa2u35FAKE8Qb?=
 =?us-ascii?Q?Q5Xh4LMaSITZEnWPeqKa9Pd/E344sgdbaah/jQb8ODXebDBVrj/HAS5xH/dR?=
 =?us-ascii?Q?i+vjTxsPEyJnLaMCvbW1lQJwlkLnCdqAG+xJ5jYoyI00qLou9lPAH0QUs6j/?=
 =?us-ascii?Q?YQqD5JCVWn3+9Fqila86vtyTMqftZrovvljLlWfDViyLv5H40XyYDHWtt2sW?=
 =?us-ascii?Q?2Q=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 106b05ff-18e0-4be7-66f3-08de013064d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2025 21:20:49.4816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Wx1r2vODj9QPZrEx2HWt3meCqgcolinuo5lA8mLxQfol4cCEU+5n0jMUxJSo5PnWE+GshcW/aZFKYMDlRLsShX3POHvuvOPlA1mReUcZio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6918
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Wednesday, October 1, 2025 9:19 AM
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
> Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process a
> large folio in batches.
>=20
> On Thu, Sep 25, 2025 at 08:35:01PM -0700, Kanchana P Sridhar wrote:
> > This patch makes two major changes:
> >
> > First, we allocate pool batching resources if the compressor supports
> > batching:
> >
> >   This patch sets up zswap for allocating per-CPU resources optimally
> >   for non-batching and batching compressors.
> >
> >   A new ZSWAP_MAX_BATCH_SIZE constant is defined as 8U, to set an upper
> >   limit on the number of pages in large folios that will be batch
> >   compressed.
> >
> >   It is up to the compressor to manage multiple requests, as needed, to
> >   accomplish batch parallelism. zswap only needs to allocate the per-CP=
U
> >   dst buffers according to the batch size supported by the compressor.
> >
> >   A "u8 compr_batch_size" member is added to "struct zswap_pool", as pe=
r
> >   Yosry's suggestion. pool->compr_batch_size is set as the minimum of
> >   the compressor's max batch-size and ZSWAP_MAX_BATCH_SIZE.
> Accordingly,
> >   it proceeds to allocate the necessary compression dst buffers in the
> >   per-CPU acomp_ctx.
> >
> >   Another "u8 store_batch_size" member is added to "struct zswap_pool"
> >   to store the unit for batching large folio stores: for batching
> >   compressors, this is the pool->compr_batch_size. For non-batching
> >   compressors, this is ZSWAP_MAX_BATCH_SIZE.
> >
> >   zswap does not use more than one dst buffer yet. Follow-up patches
> >   will actually utilize the multiple acomp_ctx buffers for batch
> >   compression/decompression of multiple pages.
> >
> >   Thus, ZSWAP_MAX_BATCH_SIZE limits the amount of extra memory used
> for
> >   batching. There is a small extra memory overhead of allocating
> >   the acomp_ctx->buffers array for compressors that do not support
> >   batching: On x86_64, the overhead is 1 pointer per-CPU (i.e. 8 bytes)=
.
> >
> > Next, we store the folio in batches:
> >
> >   This patch modifies zswap_store() to store a batch of pages in large
> >   folios at a time, instead of storing one page at a time. It does this=
 by
> >   calling a new procedure zswap_store_pages() with a range of
> >   "pool->store_batch_size" indices in the folio.
> >
> >   zswap_store_pages() implements all the computes done earlier in
> >   zswap_store_page() for a single-page, for multiple pages in a folio,
> >   namely the "batch":
> >
> >   1) It starts by allocating all zswap entries required to store the
> >      batch. New procedures, zswap_entries_cache_alloc_batch() and
> >      zswap_entries_cache_free_batch() call kmem_cache_[free]alloc_bulk(=
)
> >      to optimize the performance of this step.
> >
> >   2) Next, the entries fields are written, computes that need to be hap=
pen
> >      anyway, without modifying the zswap xarray/LRU publishing order. T=
his
> >      improves latency by avoiding having to bring the entries into the
> >      cache for writing in different code blocks within this procedure.
> >
> >   3) Next, it calls zswap_compress() to sequentially compress each page=
 in
> >      the batch.
> >
> >   4) Finally, it adds the batch's zswap entries to the xarray and LRU,
> >      charges zswap memory and increments zswap stats.
> >
> >   5) The error handling and cleanup required for all failure scenarios
> >      that can occur while storing a batch in zswap are consolidated to =
a
> >      single "store_pages_failed" label in zswap_store_pages(). Here aga=
in,
> >      we optimize performance by calling kmem_cache_free_bulk().
> >
> > This commit also makes a minor optimization in zswap_compress(), for th=
e
> > info on whether or not the page's folio has memcg writeback enabled to
> > be passed in via a "bool folio_wb" flag from zswap_store(). The intent
> > is to not re-compute this for every page in a folio. Since
> > zswap_compress() is a static function, I figured this should be safe.
> > A repetition of "dlen =3D PAGE_SIZE" is deleted.
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > ---
> >  mm/zswap.c | 319 +++++++++++++++++++++++++++++++++++++-----------
> -----
> >  1 file changed, 224 insertions(+), 95 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 3b3716808d7d..9e0e7887de33 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -82,6 +82,9 @@ static bool zswap_pool_reached_full;
> >
> >  #define ZSWAP_PARAM_UNSET ""
> >
> > +/* Limit the batch size to limit per-CPU memory usage for dst buffers.=
 */
> > +#define ZSWAP_MAX_BATCH_SIZE 8U
> > +
> >  static int zswap_setup(void);
> >
> >  /* Enable/disable zswap */
> > @@ -139,7 +142,7 @@ struct crypto_acomp_ctx {
> >  	struct crypto_acomp *acomp;
> >  	struct acomp_req *req;
> >  	struct crypto_wait wait;
> > -	u8 *buffer;
> > +	u8 **buffers;
> >  	struct mutex mutex;
> >  	bool is_sleepable;
> >  };
> > @@ -158,6 +161,8 @@ struct zswap_pool {
> >  	struct work_struct release_work;
> >  	struct hlist_node node;
> >  	char tfm_name[CRYPTO_MAX_ALG_NAME];
> > +	u8 compr_batch_size;
> > +	u8 store_batch_size;
>=20
> I don't think we need to store store_batch_size, seems trivial to
> calculate at store time (perhaps in a helper).
>=20
> Taking a step back, is there any benefit to limiting store_batch_size to
> compr_batch_size? Is there a disadvantage to using
> ZSWAP_MAX_BATCH_SIZE
> even if it's higher than the HW compression batch size?

Thanks Yosry, for the code review comments. I had a discussion with
Barry earlier on these very same topics as follow up to his review comments
for v11, starting with [1]. Can you please go through the rationale for
these design choices, and let me know if you have any questions:

[1]: https://patchwork.kernel.org/comment/26530319/

>=20
> >  };
> >
> >  /* Global LRU lists shared by all zswap pools. */
> > @@ -252,8 +257,10 @@ static void __zswap_pool_empty(struct
> percpu_ref *ref);
> >   *   zswap_cpu_comp_prepare(), not others.
> >   * - Cleanup acomp_ctx resources on all cores in zswap_pool_destroy().
> >   */
> > -static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
> > +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx, u8
> nr_buffers)
> >  {
> > +	u8 i;
> > +
> >  	if (IS_ERR_OR_NULL(acomp_ctx))
> >  		return;
> >
> > @@ -263,7 +270,11 @@ static void acomp_ctx_dealloc(struct
> crypto_acomp_ctx *acomp_ctx)
> >  	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> >  		crypto_free_acomp(acomp_ctx->acomp);
> >
> > -	kfree(acomp_ctx->buffer);
> > +	if (acomp_ctx->buffers) {
> > +		for (i =3D 0; i < nr_buffers; ++i)
> > +			kfree(acomp_ctx->buffers[i]);
> > +		kfree(acomp_ctx->buffers);
> > +	}
> >  }
> >
> >  static struct zswap_pool *zswap_pool_create(char *compressor)
> > @@ -275,6 +286,7 @@ static struct zswap_pool *zswap_pool_create(char
> *compressor)
> >  	if (!zswap_has_pool && !strcmp(compressor,
> ZSWAP_PARAM_UNSET))
> >  		return NULL;
> >
> > +	/* Many things rely on the zero-initialization. */
> >  	pool =3D kzalloc(sizeof(*pool), GFP_KERNEL);
> >  	if (!pool)
> >  		return NULL;
> > @@ -334,13 +346,28 @@ static struct zswap_pool
> *zswap_pool_create(char *compressor)
> >  		goto ref_fail;
> >  	INIT_LIST_HEAD(&pool->list);
> >
> > +	/*
> > +	 * Set the unit of compress batching for large folios, for quick
> > +	 * retrieval in the zswap_compress() fast path:
> > +	 * If the compressor is sequential (@pool->compr_batch_size is 1),
> > +	 * large folios will be compressed in batches of
> ZSWAP_MAX_BATCH_SIZE
> > +	 * pages, where each page in the batch is compressed sequentially.
> > +	 * We see better performance by processing the folio in batches of
> > +	 * ZSWAP_MAX_BATCH_SIZE, due to cache locality of working set
> > +	 * structures.
> > +	 */
> > +	pool->store_batch_size =3D (pool->compr_batch_size > 1) ?
> > +				  pool->compr_batch_size :
> ZSWAP_MAX_BATCH_SIZE;
> > +
> >  	zswap_pool_debug("created", pool);
> >
> >  	return pool;
> >
> >  ref_fail:
> >  	for_each_possible_cpu(cpu)
> > -		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
> > +				  pool->compr_batch_size);
> > +
> >  error:
> >  	if (pool->acomp_ctx)
> >  		free_percpu(pool->acomp_ctx);
> > @@ -376,7 +403,8 @@ static void zswap_pool_destroy(struct zswap_pool
> *pool)
> >  	zswap_pool_debug("destroying", pool);
> >
> >  	for_each_possible_cpu(cpu)
> > -		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> > +		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
> > +				  pool->compr_batch_size);
> >
> >  	free_percpu(pool->acomp_ctx);
> >
> > @@ -763,6 +791,24 @@ static void zswap_entry_cache_free(struct
> zswap_entry *entry)
> >  	kmem_cache_free(zswap_entry_cache, entry);
> >  }
> >
> > +/*
> > + * Returns 0 if kmem_cache_alloc_bulk() failed and a positive number
> otherwise.
> > + * The code for __kmem_cache_alloc_bulk() indicates that this positive
> number
> > + * will be the @size requested, i.e., @nr_entries.
>=20
> The behavior is not documented tho, and other users seem like they don't
> all assume the return has to be 0 or nr_entries. Maybe we should add a
> WARN if the returned size is not nr_entries or 0?

Sure, I will do so.

>=20
> > + */
> > +static __always_inline int zswap_entries_cache_alloc_batch(void
> **entries,
> > +							   unsigned int
> nr_entries,
> > +							   gfp_t gfp)
> > +{
> > +	return kmem_cache_alloc_bulk(zswap_entry_cache, gfp, nr_entries,
> entries);
>=20
> We currently use kmem_cache_alloc_node() in zswap_entry_cache_alloc() to
> allocate the entry on the same node as the compressed page. We use
> entry_to_nid() to get the node for LRU operations.
>=20
> This breaks that assumption.

You bring up a good point. I was looking at the code in slub.c and my
understanding thus far is that both, bulk allocations and kmem_cache_alloc_=
node()
allocations are made from a per-CPU "cpu_slab" that is allocated by SLUB.

IIUC, the concern you are raising is in the mainline, the entry is allocate=
d on
the same node as the compressed page, and gets added to the LRU list of tha=
t
node. IOW, the node to which the compressed page belongs is the one to whos=
e
LRU the entry will be added.

With this patch, with kmem_cache_alloc_bulk(), the entry will be created on
the per-CPU slab of the CPU on which zswap_store() is called and will be
added to the LRU of that per-CPU slab's NUMA node. Hence, the end result
could potentially be that the zswap_entry for a page could potentially be
on a different NUMA node/memcg than the page's NUMA node.

This is my thinking as to how this will impact the zswap shrinker:

1) memcg shrinker: if the memcg the entry ends up in is on the zswap_list_l=
ru,
    the entry will be written back.
2) Global shrinker: will cycle through all memcg's that have pages in the
    zswap_list_lru, and the entry will be written back.

Based on this, it is not clear to me if there is a problem, and would like =
to
request you, Nhat and others to provide insights as well.

Interestingly, most of the code in slub.c has unlikely(!node_match(slab, no=
de)).
Does this imply some higher level mm slab allocation requirements?

I am Ok with just calling zswap_entry_cache_alloc() for "nr_pages" if we
think this would be more correct.

>=20
> > +}
> > +
> > +static __always_inline void zswap_entries_cache_free_batch(void
> **entries,
> > +							   unsigned int
> nr_entries)
> > +{
> > +	kmem_cache_free_bulk(zswap_entry_cache, nr_entries, entries);
> > +}
> > +
> >  /*
> >   * Carries out the common pattern of freeing an entry's zsmalloc alloc=
ation,
> >   * freeing the entry itself, and decrementing the number of stored pag=
es.
> > @@ -789,7 +835,9 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  {
> >  	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> node);
> >  	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> >acomp_ctx, cpu);
> > +	int cpu_node =3D cpu_to_node(cpu);
>=20
> "nid" is a more common name.

Sure, I can change this.

>=20
> >  	int ret =3D -ENOMEM;
> > +	u8 i;
> >
> >  	/*
> >  	 * The per-CPU pool->acomp_ctx is zero-initialized on allocation.
> > @@ -802,11 +850,7 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> >  		return 0;
> >
> > -	acomp_ctx->buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL,
> cpu_to_node(cpu));
> > -	if (!acomp_ctx->buffer)
> > -		return ret;
> > -
> > -	acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0,
> 0, cpu_to_node(cpu));
> > +	acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0,
> 0, cpu_node);
> >  	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
> >  		pr_err("could not alloc crypto acomp %s : %ld\n",
> >  				pool->tfm_name, PTR_ERR(acomp_ctx-
> >acomp));
> > @@ -815,20 +859,40 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  	}
> >  	acomp_ctx->is_sleepable =3D acomp_is_async(acomp_ctx->acomp);
> >
> > +	/*
> > +	 * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
> > +	 * compressor supports batching.
> > +	 */
> > +	pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
> > +				     crypto_acomp_batch_size(acomp_ctx-
> >acomp));
> > +
> >  	acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> > +
> >  	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
> >  		pr_err("could not alloc crypto acomp_request %s\n",
> > -		       pool->tfm_name);
> > +			pool->tfm_name);
>=20
> Unrelated change.

Ok, will submit this separately.

>=20
> >  		goto fail;
> >  	}
> >
> > -	crypto_init_wait(&acomp_ctx->wait);
> > +	acomp_ctx->buffers =3D kcalloc_node(pool->compr_batch_size,
> sizeof(u8 *),
> > +					  GFP_KERNEL, cpu_node);
> > +	if (!acomp_ctx->buffers)
> > +		goto fail;
> > +
> > +	for (i =3D 0; i < pool->compr_batch_size; ++i) {
> > +		acomp_ctx->buffers[i] =3D kmalloc_node(PAGE_SIZE,
> GFP_KERNEL,
> > +						     cpu_node);
> > +		if (!acomp_ctx->buffers[i])
> > +			goto fail;
> > +	}
> >
> >  	/*
> >  	 * if the backend of acomp is async zip, crypto_req_done() will
> wakeup
> >  	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
> >  	 * won't be called, crypto_wait_req() will return without blocking.
> >  	 */
> > +	crypto_init_wait(&acomp_ctx->wait);
> > +
> >  	acomp_request_set_callback(acomp_ctx->req,
> CRYPTO_TFM_REQ_MAY_BACKLOG,
> >  				   crypto_req_done, &acomp_ctx->wait);
> >
> > @@ -836,12 +900,12 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  	return 0;
> >
> >  fail:
> > -	acomp_ctx_dealloc(acomp_ctx);
> > +	acomp_ctx_dealloc(acomp_ctx, pool->compr_batch_size);
> >  	return ret;
> >  }
> >
> >  static bool zswap_compress(struct page *page, struct zswap_entry *entr=
y,
> > -			   struct zswap_pool *pool)
> > +			   struct zswap_pool *pool, bool folio_wb)
>=20
> Maybe "wb_enabled" instead of folio_wb?

Ok.

>=20
> >  {
> >  	struct crypto_acomp_ctx *acomp_ctx;
> >  	struct scatterlist input, output;
> > @@ -855,7 +919,7 @@ static bool zswap_compress(struct page *page,
> struct zswap_entry *entry,
> >  	acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
> >  	mutex_lock(&acomp_ctx->mutex);
> >
> > -	dst =3D acomp_ctx->buffer;
> > +	dst =3D acomp_ctx->buffers[0];
> >  	sg_init_table(&input, 1);
> >  	sg_set_page(&input, page, PAGE_SIZE, 0);
> >
> > @@ -886,13 +950,11 @@ static bool zswap_compress(struct page *page,
> struct zswap_entry *entry,
> >  	 */
> >  	if (comp_ret || !dlen || dlen >=3D PAGE_SIZE) {
> >  		dlen =3D PAGE_SIZE;
> > -		if (!mem_cgroup_zswap_writeback_enabled(
> > -					folio_memcg(page_folio(page)))) {
> > +		if (!folio_wb) {
> >  			comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> >  			goto unlock;
> >  		}
> >  		comp_ret =3D 0;
> > -		dlen =3D PAGE_SIZE;
>=20
> Unrelated change.

Will submit a separate patch.

>=20
> >  		dst =3D kmap_local_page(page);
> >  		mapped =3D true;
> >  	}
> > @@ -932,7 +994,7 @@ static bool zswap_decompress(struct zswap_entry
> *entry, struct folio *folio)
> >
> >  	acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
> >  	mutex_lock(&acomp_ctx->mutex);
> > -	obj =3D zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx-
> >buffer);
> > +	obj =3D zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx-
> >buffers[0]);
> >
> >  	/* zswap entries of length PAGE_SIZE are not compressed. */
> >  	if (entry->length =3D=3D PAGE_SIZE) {
> > @@ -942,15 +1004,15 @@ static bool zswap_decompress(struct
> zswap_entry *entry, struct folio *folio)
> >
> >  	/*
> >  	 * zs_obj_read_begin() might return a kmap address of highmem
> when
> > -	 * acomp_ctx->buffer is not used.  However, sg_init_one() does not
> > -	 * handle highmem addresses, so copy the object to acomp_ctx-
> >buffer.
> > +	 * acomp_ctx->buffers[0] is not used.  However, sg_init_one() does
> not
> > +	 * handle highmem addresses, so copy the object to acomp_ctx-
> >buffers[0].
> >  	 */
> >  	if (virt_addr_valid(obj)) {
> >  		src =3D obj;
> >  	} else {
> > -		WARN_ON_ONCE(obj =3D=3D acomp_ctx->buffer);
> > -		memcpy(acomp_ctx->buffer, obj, entry->length);
> > -		src =3D acomp_ctx->buffer;
> > +		WARN_ON_ONCE(obj =3D=3D acomp_ctx->buffers[0]);
> > +		memcpy(acomp_ctx->buffers[0], obj, entry->length);
> > +		src =3D acomp_ctx->buffers[0];
> >  	}
> >
> >  	sg_init_one(&input, src, entry->length);
> > @@ -1404,95 +1466,160 @@ static void shrink_worker(struct work_struct
> *w)
> >  * main API
> >  **********************************/
> >
> > -static bool zswap_store_page(struct page *page,
> > -			     struct obj_cgroup *objcg,
> > -			     struct zswap_pool *pool)
> > +/*
> > + * Store multiple pages in @folio, starting from the page at index @st=
art up
> to
> > + * the page at index @end-1.
> > + */
> > +static bool zswap_store_pages(struct folio *folio,
> > +			      long start,
> > +			      long end,
> > +			      struct obj_cgroup *objcg,
> > +			      struct zswap_pool *pool,
> > +			      int node_id,
> > +			      bool folio_wb)
> >  {
> > -	swp_entry_t page_swpentry =3D page_swap_entry(page);
> > -	struct zswap_entry *entry, *old;
> > -
> > -	/* allocate entry */
> > -	entry =3D zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
> > -	if (!entry) {
> > -		zswap_reject_kmemcache_fail++;
> > -		return false;
> > +	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
> > +	u8 i, store_fail_idx =3D 0, nr_pages =3D end - start;
> > +
> > +	VM_WARN_ON_ONCE(nr_pages > ZSWAP_MAX_BATCH_SIZE);
> > +
> > +	if (unlikely(!zswap_entries_cache_alloc_batch((void **)&entries[0],
> > +						      nr_pages, GFP_KERNEL)))
> {
> > +		for (i =3D 0; i < nr_pages; ++i) {
> > +			entries[i] =3D zswap_entry_cache_alloc(GFP_KERNEL,
> node_id);
> > +
> > +			if (unlikely(!entries[i])) {
> > +				zswap_reject_kmemcache_fail++;
> > +				/*
> > +				 * While handling this error, we only need to
> > +				 * call zswap_entries_cache_free_batch() for
> > +				 * entries[0 .. i-1].
> > +				 */
> > +				nr_pages =3D i;
> > +				goto store_pages_failed;
> > +			}
>=20
> Is it okay to use kmem_cache_free_bulk() to free slab objects that were
> not allocated with kmem_cache_alloc_bulk()?

I recall verifying that it should be Ok, but can check again.

>=20
> > +		}
> >  	}
> >
> > -	if (!zswap_compress(page, entry, pool))
> > -		goto compress_failed;
> > +	/*
> > +	 * Three sets of initializations are done to minimize bringing
> > +	 * @entries into the cache for writing at different parts of this
> > +	 * procedure, since doing so regresses performance:
> > +	 *
> > +	 * 1) Do all the writes to each entry in one code block. These
> > +	 *    writes need to be done anyway upon success which is more likely
> > +	 *    than not.
> > +	 *
> > +	 * 2) Initialize the handle to an error value. This facilitates
> > +	 *    having a consolidated failure handling
> > +	 *    'goto store_pages_failed' that can inspect the value of the
> > +	 *    handle to determine whether zsmalloc memory needs to be
> > +	 *    de-allocated.
> > +	 *
> > +	 * 3) The page_swap_entry() is obtained once and stored in the entry.
> > +	 *    Subsequent store in xarray gets the entry->swpentry instead of
> > +	 *    calling page_swap_entry(), minimizing computes.
> > +	 */
>=20
> Very long comment, and I am not sure what it is trying to say. We don't
> need to describe what the code is doing like that.
>=20
> The only thing that may be worth pointing out is that we are colocating
> initialization as much as possible here to minimize potential cache
> misses.

Sounds good.
=20
>=20
> Does it actually matter if we do the initializations here vs. right
> before inserting to the LRU (current behavior)?

Yes, it impacts batching performance with software quite a bit.

>=20
> > +	for (i =3D 0; i < nr_pages; ++i) {
> > +		entries[i]->handle =3D (unsigned long)ERR_PTR(-EINVAL);
> > +		entries[i]->pool =3D pool;
> > +		entries[i]->swpentry =3D page_swap_entry(folio_page(folio,
> start + i));
> > +		entries[i]->objcg =3D objcg;
> > +		entries[i]->referenced =3D true;
> > +		INIT_LIST_HEAD(&entries[i]->lru);
> > +	}
> >
> > -	old =3D xa_store(swap_zswap_tree(page_swpentry),
> > -		       swp_offset(page_swpentry),
> > -		       entry, GFP_KERNEL);
> > -	if (xa_is_err(old)) {
> > -		int err =3D xa_err(old);
> > +	for (i =3D 0; i < nr_pages; ++i) {
> > +		struct page *page =3D folio_page(folio, start + i);
> >
> > -		WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray error:
> %d\n", err);
> > -		zswap_reject_alloc_fail++;
> > -		goto store_failed;
> > +		if (!zswap_compress(page, entries[i], pool, folio_wb))
> > +			goto store_pages_failed;
> >  	}
> >
> > -	/*
> > -	 * We may have had an existing entry that became stale when
> > -	 * the folio was redirtied and now the new version is being
> > -	 * swapped out. Get rid of the old.
> > -	 */
> > -	if (old)
> > -		zswap_entry_free(old);
> > +	for (i =3D 0; i < nr_pages; ++i) {
> > +		struct zswap_entry *old, *entry =3D entries[i];
> >
> > -	/*
> > -	 * The entry is successfully compressed and stored in the tree, there=
 is
> > -	 * no further possibility of failure. Grab refs to the pool and objcg=
,
> > -	 * charge zswap memory, and increment zswap_stored_pages.
> > -	 * The opposite actions will be performed by zswap_entry_free()
> > -	 * when the entry is removed from the tree.
> > -	 */
> > -	zswap_pool_get(pool);
> > -	if (objcg) {
> > -		obj_cgroup_get(objcg);
> > -		obj_cgroup_charge_zswap(objcg, entry->length);
> > -	}
> > -	atomic_long_inc(&zswap_stored_pages);
> > -	if (entry->length =3D=3D PAGE_SIZE)
> > -		atomic_long_inc(&zswap_stored_incompressible_pages);
> > +		old =3D xa_store(swap_zswap_tree(entry->swpentry),
> > +			       swp_offset(entry->swpentry),
> > +			       entry, GFP_KERNEL);
> > +		if (unlikely(xa_is_err(old))) {
> > +			int err =3D xa_err(old);
> >
> > -	/*
> > -	 * We finish initializing the entry while it's already in xarray.
> > -	 * This is safe because:
> > -	 *
> > -	 * 1. Concurrent stores and invalidations are excluded by folio lock.
> > -	 *
> > -	 * 2. Writeback is excluded by the entry not being on the LRU yet.
> > -	 *    The publishing order matters to prevent writeback from seeing
> > -	 *    an incoherent entry.
> > -	 */
> > -	entry->pool =3D pool;
> > -	entry->swpentry =3D page_swpentry;
> > -	entry->objcg =3D objcg;
> > -	entry->referenced =3D true;
> > -	if (entry->length) {
> > -		INIT_LIST_HEAD(&entry->lru);
> > -		zswap_lru_add(&zswap_list_lru, entry);
> > +			WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray
> error: %d\n", err);
> > +			zswap_reject_alloc_fail++;
> > +			/*
> > +			 * Entries up to this point have been stored in the
> > +			 * xarray. zswap_store() will erase them from the
> xarray
> > +			 * and call zswap_entry_free(). Local cleanup in
> > +			 * 'store_pages_failed' only needs to happen for
> > +			 * entries from [@i to @nr_pages).
> > +			 */
> > +			store_fail_idx =3D i;
> > +			goto store_pages_failed;
> > +		}
> > +
> > +		/*
> > +		 * We may have had an existing entry that became stale when
> > +		 * the folio was redirtied and now the new version is being
> > +		 * swapped out. Get rid of the old.
> > +		 */
> > +		if (unlikely(old))
> > +			zswap_entry_free(old);
> > +
> > +		/*
> > +		 * The entry is successfully compressed and stored in the tree,
> there is
> > +		 * no further possibility of failure. Grab refs to the pool and
> objcg,
> > +		 * charge zswap memory, and increment
> zswap_stored_pages.
> > +		 * The opposite actions will be performed by
> zswap_entry_free()
> > +		 * when the entry is removed from the tree.
> > +		 */
>=20
> But there *is* further possibility of failure if a subsequent entry
> xa_store() fails, right?

This comment is referring to this specific entry.

>=20
> Seems like if xa_store() fails we do not cleanup previously charged
> objects, pool references, zswap_stored_pages, etc. Instead of rolling
> all this back on failure, can we do all the xarray stores first and only
> do the rest when we're at a point where no failure can happen? Would
> that cause a performance regression?

It would make the code more complicated and thus cause a performance
regression. I have tried to balance code simplicity (which impacts performa=
nce)
with correctness here. The "store_failed_idx" ensures that all partial work=
 done
in zswap_store_pages() for this batch, is cleaned up.

The rest is handled in zswap_store() when it sees an error returned by
zswap_store_pages().

>=20
> > +		zswap_pool_get(pool);
> > +		if (objcg) {
> > +			obj_cgroup_get(objcg);
> > +			obj_cgroup_charge_zswap(objcg, entry->length);
> > +		}
> > +		atomic_long_inc(&zswap_stored_pages);
> > +		if (entry->length =3D=3D PAGE_SIZE)
> > +
> 	atomic_long_inc(&zswap_stored_incompressible_pages);
> > +
> > +		/*
> > +		 * We finish by adding the entry to the LRU while it's already
> > +		 * in xarray. This is safe because:
> > +		 *
> > +		 * 1. Concurrent stores and invalidations are excluded by folio
> lock.
> > +		 *
> > +		 * 2. Writeback is excluded by the entry not being on the LRU
> yet.
> > +		 *    The publishing order matters to prevent writeback from
> seeing
> > +		 *    an incoherent entry.
> > +		 */
> > +		if (likely(entry->length))
> > +			zswap_lru_add(&zswap_list_lru, entry);
> >  	}
> >
> >  	return true;
> >
> > -store_failed:
> > -	zs_free(pool->zs_pool, entry->handle);
> > -compress_failed:
> > -	zswap_entry_cache_free(entry);
> > +store_pages_failed:
> > +	for (i =3D store_fail_idx; i < nr_pages; ++i) {
> > +		if (!IS_ERR_VALUE(entries[i]->handle))
> > +			zs_free(pool->zs_pool, entries[i]->handle);
> > +	}
> > +	zswap_entries_cache_free_batch((void **)&entries[store_fail_idx],
> > +				       nr_pages - store_fail_idx);
> > +
> >  	return false;
> >  }
> >
> >  bool zswap_store(struct folio *folio)
> >  {
> > +	bool folio_wb =3D
> mem_cgroup_zswap_writeback_enabled(folio_memcg(folio));
>=20
> Ditto renaming folio_wb.

Yes.

>=20
> >  	long nr_pages =3D folio_nr_pages(folio);
> > +	int node_id =3D folio_nid(folio);
>=20
> Ditto nid.

Ok.

>=20
> >  	swp_entry_t swp =3D folio->swap;
> >  	struct obj_cgroup *objcg =3D NULL;
> >  	struct mem_cgroup *memcg =3D NULL;
> >  	struct zswap_pool *pool;
> >  	bool ret =3D false;
> > -	long index;
> > +	long start, end;
> >
> >  	VM_WARN_ON_ONCE(!folio_test_locked(folio));
> >  	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
> > @@ -1526,10 +1653,12 @@ bool zswap_store(struct folio *folio)
> >  		mem_cgroup_put(memcg);
> >  	}
> >
> > -	for (index =3D 0; index < nr_pages; ++index) {
> > -		struct page *page =3D folio_page(folio, index);
> > +	/* Store the folio in batches of @pool->store_batch_size pages. */
> > +	for (start =3D 0; start < nr_pages; start +=3D pool->store_batch_size=
) {
> > +		end =3D min(start + pool->store_batch_size, nr_pages);
> >
> > -		if (!zswap_store_page(page, objcg, pool))
> > +		if (!zswap_store_pages(folio, start, end, objcg, pool,
> > +				       node_id, folio_wb))
> >  			goto put_pool;
> >  	}
> >
> > @@ -1559,9 +1688,9 @@ bool zswap_store(struct folio *folio)
> >  		struct zswap_entry *entry;
> >  		struct xarray *tree;
> >
> > -		for (index =3D 0; index < nr_pages; ++index) {
> > -			tree =3D swap_zswap_tree(swp_entry(type, offset +
> index));
> > -			entry =3D xa_erase(tree, offset + index);
> > +		for (start =3D 0; start < nr_pages; ++start) {
> > +			tree =3D swap_zswap_tree(swp_entry(type, offset +
> start));
> > +			entry =3D xa_erase(tree, offset + start);
> >  			if (entry)
> >  				zswap_entry_free(entry);
> >  		}
> > --
> > 2.27.0
> >
