Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9176328C2A4;
	Thu,  8 May 2025 19:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746734067; cv=fail; b=M6cemyOH3cqkQUM92wg/Fh88GXhbtTtnQxX27LIDd5iuHRyhJNfncUrXLWnNsihp4BshbcwoLC/gVFItPbWGYV7L7HdMLg2pSZhTN6GB01aa44L2xQ+DBJkGai4I4gEpT0f1vgVJNAISKwhzTh0DnXIjnkFVfqvlF3vOVMGyyIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746734067; c=relaxed/simple;
	bh=QbSo6e0tn7YHoQiYpcK2uaj3eo2meMv7yV3Y0I43heM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j70WLKRq9MBPW9BMlN+MpkYAevvgaUhs23vS1duO1bL8uKF8LmyehKLpTFNUc/iDdrWzIvGd7lQhXZJNsEOPQxm6sPSv6Uk73YlRVzhLwlQwh9inIfyTFC0SwSvf6hpbpTeVs720tIp3rbsg3aB1vCs5Y0KTgJXEFYZwEU1Rz0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cYx6PbMb; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cYx6PbMb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746734063; x=1778270063;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QbSo6e0tn7YHoQiYpcK2uaj3eo2meMv7yV3Y0I43heM=;
  b=cYx6PbMbkAFoSsUceLluVvqs2N+vXIxLO/oQd/R3JhOU9wsq0XVwWLis
   yDNUThC5dI5rmuYFb3Hndbq3t71jircJAYoIFgtjq1AaoQTAPLQCUqzQ2
   vy646f0JAxvNeYY49Xqggm6W+V4eW1lJOZJdqwANP1uVqCBqQ6z3uRKr3
   Zd7QbY82KJ93PNNiJpJBUXFb2rAtCiuC6Z98JdP0I1eXJqSLmDV5bK9+B
   rAtfQULtzDD3/JDVcjXGESIW+D474WI8XeZ6yaDeeXDPMZqQCB2UV5Gb5
   X0mubzY32Piq4Jse9WvLbp+C7XOTLfsTiHYNTzyZ7SCujVawnjVb+Qw7n
   A==;
X-CSE-ConnectionGUID: bhluRZOJQ5uLYznpFdSlyA==
X-CSE-MsgGUID: vz8vUXTBTRWPUfdjZ+qj/g==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73920048"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="73920048"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:54:22 -0700
X-CSE-ConnectionGUID: BHUD/9OlSPCNKqQQAv0Duw==
X-CSE-MsgGUID: XNV/Q8DkTnCgXQWxtGoDZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="137391415"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:54:22 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 12:54:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 12:54:21 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 12:54:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O1atHMlPsRuEFxSPUuVOFmLkaanZ7hXFUihezkymaYZHZRNAQ4Ts7EF1EpKwB8OEi3ycqDv6KZzbd673JdNjMEfpYTe9+VgBnqKBi8xomcyYUOtNK5QD36rI+Zx+KRnc9lesteqIh+P87a3mbWKjhQ2cVXBtyxkZh9YnGHYYmDFFoSakAjVrYQKlN9Mbk00qUTqzGF6pwWFtgvwVaKdQTCbzbNZ9xoURF2KdBGXsr6Z7llotA5ISQzYcIU460f+XKD0QiZX0ns2Pp6GGA/0yQ/Pmxzvool5GP7om0sckh6Gx1Wzjh6a7/oOYxvEvMZZ3AR30AMm7DzDWx0MZwgMUhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9WXLNqQjnDefIlTLEfdiHZFEh6eOhwbSDbh1pV2eI0=;
 b=YxeyOQKy5ZIgqV/X+xTenpZGuSXT+8rx8FV4DuY8qr73UiLJBkMFL1IyMge4+E9HhsQX6jdfKSNFTmBrTuMtxk1yrlqtpE5fyirEAtOQQ4gfopMByNsoc+VYWHKMC/fARu4RP1fLxqPM7uv+Is0hnLbDiTS7vbgmkuJH0SFaiWfOizWLgAwq4tSAagMp+ZO7C6LG13+//aj5nxXfPtDO7iHmLxXCM3475CaI4C01NklGdsbsNlXyMWTRELdIiq66m9RqNDXkOcdy4GPp1GKik7ZqtgnAfoHBEuyk7NhcO+nrRVi1cBFFyfM1gOKSa2qR49wcf3GE50c9BxyDJ+UGLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by SA2PR11MB5195.namprd11.prod.outlook.com (2603:10b6:806:11a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Thu, 8 May
 2025 19:54:13 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%6]) with mapi id 15.20.8722.020; Thu, 8 May 2025
 19:54:13 +0000
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
	<senozhatsky@chromium.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>
CC: "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [RESEND PATCH v9 00/19] zswap compression batching
Thread-Topic: [RESEND PATCH v9 00/19] zswap compression batching
Thread-Index: AQHbwFFAVvH/XaQ67k+2PUM4dnM9ErPJIwbA
Date: Thu, 8 May 2025 19:54:13 +0000
Message-ID: <PH7PR11MB8121D67B0BFE87CD0F24CFD4C98BA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|SA2PR11MB5195:EE_
x-ms-office365-filtering-correlation-id: b9b20645-abe1-48ce-f035-08dd8e6a1b5a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007|38070700018|921020;
x-microsoft-antispam-message-info: =?us-ascii?Q?k5ZwbxO5+CFlOBs2p/NkWGDOrug4th/7ysC1G/O2979wwsOjK7EqiBIS6F4S?=
 =?us-ascii?Q?yfx+AW9OK2Zs5I3nKXUqcrOc1Tk95fUTBa3bL1W4UOh4jIpjrg3rJHM0X7nR?=
 =?us-ascii?Q?PO5pcr780A9JOpTGA11USTR1MguTMxKJ6wpYQWya1qp2FN3zHH50ErShz6L2?=
 =?us-ascii?Q?cwgDJuhlzqh7hP+2X8vkEB1yjDByI8HRGq7jGHFdzAn5Pp6OqEovdxjcOLiD?=
 =?us-ascii?Q?Vtkf5/k/5WHJ6G+yyqSu+oCATOTBnDy9wpVHpJXan4nRaVDVLvcUxkY8q3gu?=
 =?us-ascii?Q?BfWEXWuxV3IugIgGwPJ5SHW8CXj5J94fApmd2TNmXoOjPfyLPkw89Z4G892s?=
 =?us-ascii?Q?fw4H4z70QITdQ6bKBVOXjM0g/tISSjRaCvtanSUvhDmFIFx9rdkSI2K2Kd51?=
 =?us-ascii?Q?jBdfkGofs/I6MqV8sQL4W79pxETpuRsSrqbpiC/dkJhSehhZUr2WhzOomR5/?=
 =?us-ascii?Q?u4EGHt1pIE7B1+I/FbCznxdw9uZdPoWn15xHr90PDGi2Cy5PtuwIGhsFRObh?=
 =?us-ascii?Q?0T6vxuuPludtbD6kKPFDNupe/ykdzlCkVWo8OPyJUQMKEZLdX2hfgLp6mVb8?=
 =?us-ascii?Q?ALMMWlgpaKAhaO8SMYfKrNYAX+J+l4PI2uKM31GWx+qhVAfW7M7KEn9R2tXX?=
 =?us-ascii?Q?rSoJZ2G7QO7a9oRw5Q0taK8JdOGb+duc9mAyEOKEECkn3+LZaBYd2JQ12ioc?=
 =?us-ascii?Q?S6FeH4MGlMsfhmMsoHLykOTtH9lRI+Ew7OZdshu/ONrqMewuPzQ038HTO1nv?=
 =?us-ascii?Q?aSZzj/KK1gduz2WvXSzIoxSfLZSXzv6aCDtPVFt69CVQEOkMgMtyZ1M3ZCvO?=
 =?us-ascii?Q?kjFNzuTrTGU4/1nOA8ddLydiwmwQyauFMuf+aDUyIJwWc5UX8XecwoggS1AF?=
 =?us-ascii?Q?H0RFbdPEiDGBUtDdodgh/oODxJkWYP5/JTV0X3fxmmOtdlQIynvVn27rYbVm?=
 =?us-ascii?Q?N2UVugtMcLdFWHdOut19pjxN+DnAXkfcqVMvEBwWth6H784OlClVUgbhJ59l?=
 =?us-ascii?Q?dnyrDs309mb7kM9kaT7/0w042dt1ipK/8VKVxtI+2xxQLFExIXg02N/7m/xO?=
 =?us-ascii?Q?wQPx+M/GJx+ELXCJmxp4dPds5iTILM7fn/7su3cnWr+P9Yqnbloa6qEa3xrA?=
 =?us-ascii?Q?Hx23ZzXXTwmtuOL8d18iSgMcRVNObu5Ou2aw3AJ3KnDQ/cH555C5EFeHsm6V?=
 =?us-ascii?Q?jk4nvjg9A/5TWa5COEXcqIouaONzd2yhZGrSAFAx6uXIqJZz5k+IbKMVQz94?=
 =?us-ascii?Q?5l/FVQ9lKcCauOV3dNCIGBXOxxFF5nChTyGJP9Od+kn4lVEqiyyIcNs2oqBO?=
 =?us-ascii?Q?+cIDNa6/+jYbFq5eNhOmuELFa9pz+h4zdDEZ5/ujW6AXK0Ce2BeUDOvPsrUO?=
 =?us-ascii?Q?C0+3sxXw1Q0mSUhbg+we+YJrU1nIiZYoN3va1NVnvQqZxoIkJY/QTMvB3ahJ?=
 =?us-ascii?Q?A+SAehvqrQZhxnwj+nbaROyrv63TxBcWBqLAWXPu6GZTYcU2ngq0w1T+DQEL?=
 =?us-ascii?Q?yPd8rc3rSF7A8nl/MzetvWfhAotuBTKYYZxX?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tBABA6GphgWJJJZ5RgRl9/kIyHjMq3q3Iv3dPKiVOK2zJy2EHzm6ZDT7vt/b?=
 =?us-ascii?Q?RICzNwnBUEZyp3Kn3ZuaNhq9D7cmA20xCJ25ZKNrsy52ZQ5AdGLf5g4k0zlb?=
 =?us-ascii?Q?dfT7+AbebuaQY9UwN1YkuN5HPNoLGZg+g5/QGM3Gn5YRxumjw4+SWAppYjB+?=
 =?us-ascii?Q?ehzos0jKDFrqQvZEAFSkosllM/Xi3Gw9NTZdmVGhxR9XCO8T/tuRKrx7qJT3?=
 =?us-ascii?Q?DY7Tw1pfDRYrlI9SU46CMzUYwxPagg7zJtGiCycUa83MBXluXyRl0T/xGTas?=
 =?us-ascii?Q?rpyX+I6jcXtvzM6lNFf9ZLOA/8XukaRy8XhreFS8tk+h5du5unzsmW4IbSVJ?=
 =?us-ascii?Q?WoXPeRMynllspG3eBAxlD8tUmEJupBHHD9+HYFIJEvGm1ehpcY5y5n2swqxA?=
 =?us-ascii?Q?59yCipwF33NIEMUjcS3V8laMUMM5cTgNUC5HQSZhKTDK22MYhIRh0T43f1PI?=
 =?us-ascii?Q?XoFeHhnmX8GmABtT2bsMq1pfq8MZOMW2HlCja6Cr2L69gJvlwME/3QHda4jQ?=
 =?us-ascii?Q?0BC2Y3QuMKl3hHKjCNeKZ+OkzpHlEdCX0zTI6EcrJCQxbpRQeJeWCfHTEru4?=
 =?us-ascii?Q?HcVRe0ImR1y8PwUy9gMIZq1t0MJqsD0YcyhGzNuHCnY1u4jrcPCJ2kE+DqGd?=
 =?us-ascii?Q?CY87W5p1WsQjqOx0p1kQdK2IJ/OxA+IAF5unPSggoanyah15zGN9pXp/jLkj?=
 =?us-ascii?Q?nFmbCD6Uhl+t+fv97KxsCD7ToBa6yl6VuWnPQFQDl/W6TpEYE4Uw4imfrocg?=
 =?us-ascii?Q?baX+ZCIdGMyMxAuZlG1Hu8qh57toReGRInlsR+pzSA8yelu/RBivJDjpJmxo?=
 =?us-ascii?Q?dKSqQ9qRYXMcT6SRMG4m5UBWxJsu2QeXY0bDN5HEmGQzyG0bBio8V7ri9wQx?=
 =?us-ascii?Q?y6Se7AaincBspipsht6/cMdieCtQblglZ4jgCdR85C81eAHtd5h7QiJmldwm?=
 =?us-ascii?Q?3kmAtUAPkhY+OrzpHzc/tEAExaVFCow3+PgsvlnJkfELWjm1ESj3BySaHDze?=
 =?us-ascii?Q?gZsilqJ0Tp27pEdcaSHjUeg558K+yggkGvwLS66v9vYGndDm2QbdSraf0wKF?=
 =?us-ascii?Q?CopaVbg9sbaqAu3vVKr6uj2igNvgXfsUFQ3pvBR1IAawstE/rSk91ijrsPKD?=
 =?us-ascii?Q?U7c7TjbSt74yVfMf4Nrfti+iZGptqcdwfbd+UMypIF2woFT4qQzQ/uxKk1rj?=
 =?us-ascii?Q?ADDN09fQOZZvBLmUePUfq+46oWJjMpGI1E4CpBQbRt2lXpiahFIgvw6f4jfM?=
 =?us-ascii?Q?r1jrSvZBB75xQAwzIb4hWl61nx5wiCY+WW+iQRcXjvcaeiQBubL8QwkqBVCX?=
 =?us-ascii?Q?63TVHWihbwmMiFGyv71kvsqL7yIPqDaPwqRQEtKqhQb6AGHKfvDJKbvxta02?=
 =?us-ascii?Q?4lC8+9TX/hxhcm4ximF4PsVyJLRuYcQXv7CgcBlzfMMOHLN8tkChH9Zs52w5?=
 =?us-ascii?Q?pMDx63SI4ZzyS40j6ippOWsXOH/CVXgVon4aIaNujDTugWQgJn/JuCYOxi9Q?=
 =?us-ascii?Q?v+kmV9NslSdmhC3DYISnf8/OJwW32Yz4wX/yGhygzPMruDz67ZOJWzhGilPS?=
 =?us-ascii?Q?mWp9Jg8sx24Ai2jDO6TGT7eS22+9SpAZlsUVOjRz7mcK97sS4pd4X/LcM6tj?=
 =?us-ascii?Q?Ug=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b9b20645-abe1-48ce-f035-08dd8e6a1b5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2025 19:54:13.2795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7uN5gRguXTf9bekZPX2PCBbPJJ55UDfFr32haZgRC+bJX9vJKrKeiKJ7XwMe0iSDKhG70Y7jY7akxQclZbrnkQpJy7qTPLoVV2AUC7GuZw4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5195
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Sent: Thursday, May 8, 2025 12:41 PM
> To: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; linux-crypto@vger.kernel.org;
> herbert@gondor.apana.org.au; davem@davemloft.net;
> clabbe@baylibre.com; ardb@kernel.org; ebiggers@google.com;
> surenb@google.com; Accardi, Kristen C <kristen.c.accardi@intel.com>;
> Gomes, Vinicius <vinicius.gomes@intel.com>
> Cc: Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>; Sridhar, Kanchana P
> <kanchana.p.sridhar@intel.com>
> Subject: [RESEND PATCH v9 00/19] zswap compression batching
>=20
>=20
> Compression Batching:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> This patch-series introduces batch compression of pages in large folios t=
o
> improve zswap swapout latency. It preserves the existing zswap protocols
> for non-batching software compressors by calling crypto_acomp sequentiall=
y
> per page in the batch. Additionally, in support of hardware accelerators
> that can process a batch as an integral unit, the patch-series creates
> generic batching interfaces in crypto_acomp, and calls the
> crypto_acomp_batch_compress() interface in zswap_compress() for
> compressors
> that intrinsically support batching.
>=20
> The patch series provides a proof point by using the Intel Analytics
> Accelerator (IAA) for implementing the compress/decompress batching API
> using hardware parallelism in the iaa_crypto driver and another proof poi=
nt
> with a sequential software compressor, zstd.
>=20
> SUMMARY:
> =3D=3D=3D=3D=3D=3D=3D=3D
>=20
>   The first proof point is to test with IAA using a sequential call (full=
y
>   synchronous, compress one page at a time) vs. a batching call (fully
>   asynchronous, submit a batch to IAA for parallel compression, then poll=
 for
>   completion statuses).
>=20
>     The performance testing data with usemem 30 processes and kernel
>     compilation test using 32 threads, show 67%-77% throughput gains and
>     28%-32% sys time reduction (usemem30) and 2-3% sys time reduction
>     (kernel compilation) with zswap_store() large folios using IAA compre=
ss
>     batching as compared to IAA sequential.
>=20
>   The second proof point is to make sure that software algorithms such as
>   zstd do not regress. The data indicates that for sequential software
>   algorithms a performance gain is achieved.
>=20
>     With the performance optimizations implemented in patches 18 and 19 o=
f
>     v9, zstd usemem30 throughput increases by 1%, along with a 6%-8% sys
> time
>     reduction. With kernel compilation using zstd, we get a 0.4%-3.2%
>     reduction in sys time. These optimizations pertain to common code
>     paths, removing redundant branches/computes, using prefetchw() of the
>     zswap entry before it is written, and selectively annotating branches
>     with likely()/unlikely() compiler directives to minimize branch
>     mis-prediction penalty. Additionally, using the batching code for
>     non-batching compressors to sequentially compress/store batches of up
>     to ZSWAP_MAX_BATCH_SIZE (8) pages seems to help, most likely due to
>     cache locality of working set structures such as the array of
>     zswap_entry-s for the batch.
>=20
>     Our internal validation of zstd with the batching interface vs. IAA w=
ith
>     the batching interface on Emerald Rapids has shown that IAA
>     compress/decompress batching gives 21.3% more memory savings as
> compared
>     to zstd, for 5% performance loss as compared to the baseline without =
any
>     memory pressure. IAA batching demonstrates more than 2X the memory
>     savings obtained by zstd at this 95% performance KPI.
>     The compression ratio with IAA is 2.23, and with zstd 2.96. Even with
>     this compression ratio deficit for IAA, batching is extremely
>     beneficial. As we improve the compression ratio of the IAA accelerato=
r,
>     we expect to see even better memory savings with IAA as compared to
>     software compressors.
>=20
>=20
>   Batching Roadmap:
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>   1) Compression batching within large folios (this series).
>=20
>   2) Reclaim batching of hybrid folios:
>=20
>      We can expect to see even more significant performance and throughpu=
t
>      improvements if we use the parallelism offered by IAA to do reclaim
>      batching of 4K/large folios (really any-order folios), and using the
>      zswap_store() high throughput compression pipeline to batch-compress
>      pages comprising these folios, not just batching within large
>      folios. This is the reclaim batching patch 13 in v1, which we expect
>      to submit in a separate patch-series.
>=20
>   3) Decompression batching:
>=20
>      We have developed a zswap load batching interface for IAA to be used
>      for parallel decompression batching, using swapin_readahead().
>=20
>   These capabilities are architected so as to be useful to zswap and
>   zram. We are actively working on integrating these components with zram=
.
>=20
>   v9 Performance Summary:
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>   This is a performance testing summary of results with usemem30
>   (30 usemem processes running in a cgroup limited at 150G, each trying t=
o
>   allocate 10G).
>=20
>   usemem30 with 64K folios:
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>=20
>      --------------------------------------------------------------------=
---
>                     mm-unstable-4-21-2025              v9
>      --------------------------------------------------------------------=
---
>      zswap compressor         deflate-iaa     deflate-iaa    IAA Batching
>                                                                  vs.
>                                                              IAA Sequenti=
al
>      --------------------------------------------------------------------=
---
>      Total throughput (KB/s)    6,091,607      10,174,344         67%
>      Avg throughput (KB/s)        203,053         339,144
>      elapsed time (sec)            100.46           69.70        -31%
>      sys time (sec)              2,416.97        1,648.37        -32%
>      --------------------------------------------------------------------=
---
>=20
>      --------------------------------------------------------------------=
---
>                     mm-unstable-4-21-2025              v9
>      --------------------------------------------------------------------=
---
>      zswap compressor                zstd            zstd    v9 zstd
>                                                              improvement
>      --------------------------------------------------------------------=
---
>      Total throughput (KB/s)    6,574,380       6,632,230          1%
>      Avg throughput (KB/s)        219,146         221,074
>      elapsed time (sec)             96.58           90.60         -6%
>      sys time (sec)              2,416.52        2,224.78         -8%
>      --------------------------------------------------------------------=
---
>=20
>   usemem30 with 2M folios:
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>=20
>      --------------------------------------------------------------------=
--
>                      mm-unstable-4-21-2025             v9
>      --------------------------------------------------------------------=
--
>      zswap compressor          deflate-iaa    deflate-iaa    IAA Batching
>                                                                  vs.
>                                                              IAA Sequenti=
al
>      --------------------------------------------------------------------=
--
>      Total throughput (KB/s)     6,371,048     11,282,935         77%
>      Avg throughput (KB/s)         212,368        376,097
>      elapsed time (sec)              87.15          63.04        -28%
>      sys time (sec)               2,011.56       1,450.45        -28%
>      --------------------------------------------------------------------=
--
>=20
>      --------------------------------------------------------------------=
--
>                      mm-unstable-4-21-2025             v9
>      --------------------------------------------------------------------=
--
>      zswap compressor                 zstd           zstd    v9 zstd
>                                                              improvement
>      --------------------------------------------------------------------=
--
>      Total throughput (KB/s)     7,320,278      7,428,055          1%
>      Avg throughput (KB/s)         244,009        247,601
>      elapsed time (sec)              83.30          81.60         -2%
>      sys time (sec)               1,970.89       1,857.70         -6%
>      --------------------------------------------------------------------=
--
>=20
>=20
>=20
> DETAILS:
> =3D=3D=3D=3D=3D=3D=3D=3D
>=20
> (A) From zswap's perspective, the most significant changes are:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> 1) A unified zswap_compress() API is added to compress multiple
>    pages:
>=20
>    - If the compressor has multiple acomp requests, i.e., internally
>      supports batching, crypto_acomp_batch_compress() is called. If all
>      pages are successfully compressed, the batch is stored in zpool.
>=20
>    - If the compressor can only compress one page at a time, each page
>      is compressed and stored sequentially.
>=20
>    Many thanks to Yosry for this suggestion, because it is an essential
>    component of unifying common code paths between sequential/batching
>    compressions.
>=20
>    prefetchw() is used in zswap_compress() to minimize cache-miss
>    latency by moving the zswap entry to the cache before it is written
>    to; reducing sys time by ~1.5% for zstd (non-batching software
>    compression). In other words, this optimization helps both batching an=
d
>    software compressors.
>=20
>    Overall, the prefetchw() and likely()/unlikely() annotations prevent
>    regressions with software compressors like zstd, and generally improve
>    non-batching compressors' performance with the batching code by ~8%.
>=20
> 2) A new zswap_store_pages() is added, that stores multiple pages in a
>    folio in a range of indices. This is an extension of the earlier
>    zswap_store_page(), except it operates on a batch of pages.
>=20
> 3) zswap_store() is modified to store the folio's pages in batches
>    by calling zswap_store_pages(). If the compressor supports batching,
>    i.e., has multiple acomp requests, the folio will be compressed in
>    batches of "pool->nr_reqs". If the compressor has only one acomp
>    request, the folio will be compressed in batches of
>    ZSWAP_MAX_BATCH_SIZE pages, where each page in the batch is
>    compressed sequentially. We see better performance by processing
>    the folio in batches of ZSWAP_MAX_BATCH_SIZE, due to cache locality
>    of working set structures such as the array of zswap_entry-s for the
>    batch.
>=20
>    Many thanks to Yosry and Johannes for steering towards a common
>    design and code paths for sequential and batched compressions (i.e.,
>    for software compressors and hardware accelerators such as IAA). As pe=
r
>    Yosry's suggestion in v8, the nr_reqs is an attribute of the
>    compressor/pool, and hence is stored in struct zswap_pool instead of i=
n
>    struct crypto_acomp_ctx.
>=20
> 4) Simplifications to the acomp_ctx resources allocation/deletion
>    vis-a-vis CPU hot[un]plug. This further improves upon v8 of this
>    patch-series based on the discussion with Yosry, and formalizes the
>    lifetime of these resources from pool creation to pool
>    deletion. zswap does not register a CPU hotplug teardown
>    callback. The acomp_ctx resources will persist through CPU
>    online/offline transitions. The main changes made to avoid UAF/race
>    conditions, and correctly handle process migration, are:
>=20
>    a) No acomp_ctx mutex locking in zswap_cpu_comp_prepare().
>    b) No CPU hotplug teardown callback, no acomp_ctx resources deleted.
>    c) New acomp_ctx_dealloc() procedure that cleans up the acomp_ctx
>       resources, and is shared by zswap_cpu_comp_prepare() error
>       handling and zswap_pool_destroy().
>    d) The zswap_pool node list instance is removed right after the node
>       list add function in zswap_pool_create().
>    e) We directly call mutex_[un]lock(&acomp_ctx->mutex) in
>       zswap_[de]compress().
> acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock()
>       are deleted.
>=20
>    The commit log of patch 0015 has a more detailed analysis.
>=20
>=20
> (B) Main changes in crypto_acomp and iaa_crypto:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 1) A new architecture is introduced for IAA device WQs' usage as:
>    - compress only
>    - decompress only
>    - generic, i.e., both compress/decompress.
>=20
>    Further, IAA devices/wqs are assigned to cores based on packages
>    instead of NUMA nodes.
>=20
>    The WQ rebalancing algorithm that is invoked as WQs are
>    discovered/deleted has been made very general and flexible so that
>    the user can control exactly how IAA WQs are used. In addition to the
>    user being able to specify a WQ type as comp/decomp/generic, the user
>    can also configure if WQs need to be shared among all same-package
>    cores, or, whether the cores should be divided up amongst the
>    available IAA devices.
>=20
>    If distribute_[de]comps is enabled, from a given core's perspective,
>    the iaa_crypto driver will distribute comp/decomp jobs among all
>    devices' WQs in round-robin manner. This improves batching latency
>    and can improve compression/decompression throughput for workloads
>    that see a lot of swap activity.
>=20
>    The commit log of patch 0006 provides more details on new iaa_crypto
>    driver parameters added, along with recommended settings.
>=20
> 2) Compress/decompress batching are implemented using
>    crypto_acomp_batch_[de]compress(), along the lines of v6 since
>    request chaining is no longer the recommended approach.
>=20
>=20
> (C) The patch-series is organized as follows:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>  1) crypto acomp & iaa_crypto driver enablers for batching: Relevant
>     patches are tagged with "crypto:" in the subject:
>=20
>     Patches 1-4) Backport some of the crypto patches that revert request
>                  chaining that are in the cryptodev-2.6 git tree and are
>                  yet to be included in mm-unstable. I have also
>                  backported the fix to the scomp off-by-one bug. Further,=
 the
>                  non-request-chaining implementations of
>                  crypto_acomp_[de]compress() are reinstated. Without
>                  patches 1/2/3, the crypto/testmgr issues errors that
>                  prevent deflate-iaa from being used as zswap's
>                  compressor. Once mm-unstable is updated with the
>                  request chaining reverts, patches 1/3/4 can be deleted
>                  from this patch-series.
>=20
>     Patch 5) Reorganizes the iaa_crypto driver code into logically relate=
d
>              sections and avoids forward declarations, in order to facili=
tate
>              subsequent iaa_crypto patches. This patch makes no
>              functional changes.
>=20
>     Patch 6) Makes an infrastructure change in the iaa_crypto driver
>              to map IAA devices/work-queues to cores based on packages
>              instead of NUMA nodes. This doesn't impact performance on
>              the Sapphire Rapids system used for performance
>              testing. However, this change fixes functional problems we
>              found on Granite Rapids during internal validation, where th=
e
>              number of NUMA nodes is greater than the number of packages,
>              which was resulting in over-utilization of some IAA devices
>              and non-usage of other IAA devices as per the current NUMA
>              based mapping infrastructure.
>=20
>              This patch also develops a new architecture that
>              generalizes how IAA device WQs are used. It enables
>              designating IAA device WQs as either compress-only or
>              decompress-only or generic. Once IAA device WQ types are
>              thus defined, it also allows the configuration of whether
>              device WQs will be shared by all cores on the package, or
>              used only by "mapped cores" obtained by a simple allocation
>              of available IAAs to cores on the package.
>=20
>              As a result of the overhaul of wq_table definition,
>              allocation and rebalancing, this patch eliminates
>              duplication of device WQs in per-cpu wq_tables, thereby
>              saving 140MiB on a 384 cores dual socket Granite Rapids serv=
er
>              with 8 IAAs.
>=20
>              Regardless of how the user has configured the WQs' usage,
>              the next WQ to use is obtained through a direct look-up in
>              per-cpu "cpu_comp_wqs" and "cpu_decomp_wqs" structures so
>              as to minimize latency in the critical path driver compress
>              and decompress routines.
>=20
>     Patch 7) Defines a "void *data" in struct acomp_req, in response to
>              Herbert's comments in v8 about avoiding use of
>              req->base.data. iaa_crypto requires the req->data to
>              store the idxd_desc allocated in the core
>              iaa_[de]compress() functions, for later retreival in the
>              iaa_comp_poll() function to check for the descriptor's
>              completion status. This async submit-poll is essential for
>              batching.
>=20
>     Patch 8) Makes a change to iaa_crypto driver's descriptor allocation,
>              from blocking to non-blocking with retries/timeouts and
>              mitigations in case of timeouts during compress/decompress
>              ops. This prevents tasks getting blocked indefinitely, which
>              was observed when testing 30 cores running workloads, with
>              only 1 IAA enabled on Sapphire Rapids (out of 4). These
>              timeouts are typically only encountered, and associated
>              mitigations exercised, only in configurations with 1 IAA
>              device shared by 30+ cores.
>=20
>     Patch 9) New CRYPTO_ACOMP_REQ_POLL acomp_req flag to act as a gate
> for
>              async poll mode in iaa_crypto.
>=20
>    Patch 10) Adds acomp_alg/crypto_acomp interfaces for get_batch_size(),
>              batch_compress() and batch_decompress() along with the
>              corresponding crypto_acomp_batch_size(),
>              crypto_acomp_batch_compress() and
>              crypto_acomp_batch_decompress() API for use in zswap.
>=20
>    Patch 11) iaa-crypto driver implementations for the newly added batchi=
ng
>              interfaces. iaa_crypto implements the crypto_acomp
>              get_batch_size() interface that returns an iaa_driver specif=
ic
>              constant, IAA_CRYPTO_MAX_BATCH_SIZE (set to 8U currently).
>=20
>              This patch also provides the iaa_crypto driver implementatio=
ns
>              for the batch_compress() and batch_decompress() crypto_acomp
>              interfaces.
>=20
>    Patch 12) Modifies the default iaa_crypto driver mode to async, now th=
at
>              iaa_crypto provides a truly async mode that gives
>              significantly better latency than sync mode for the batching
>              use case.
>=20
>    Patch 13) Disables verify_compress by default, to facilitate users to
>              run IAA easily for comparison with software compressors.
>=20
>=20
>  2) zswap modifications to enable compress batching in zswap_store()
>     of large folios (including pmd-mappable folios):
>=20
>    Patch 14) Moves the zswap CPU hotplug procedures under "pool functions=
",
>              because they are invoked upon pool creation/deletion.
>=20
>    Patch 15) Simplifies the zswap_pool's per-CPU acomp_ctx resource
>              management and lifetime to be from pool creation to pool
>              deletion.
>=20
>    Patch 16) Uses IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check
> for
>              valid acomp/req, thereby making it consistent with the resou=
rce
>              de-allocation code.
>=20
>    Patch 17) Defines a zswap-specific ZSWAP_MAX_BATCH_SIZE (currently set
>              as 8U) to denote the maximum number of acomp_ctx batching
>              resources to allocate, thus limiting the amount of extra
>              memory used for batching. Further, the "struct
>              crypto_acomp_ctx" is modified to contain multiple acomp_reqs
>              and buffers. A new "u8 nr_reqs" member is added to "struct
>              zswap_pool" to track the number of requests/buffers associat=
ed
>              with the compressor.
>=20
>    Patch 18) Modifies zswap_store() to store the folio in batches of
>              pool->nr_reqs by calling a new zswap_store_pages() that take=
s
>              a range of indices in the folio to be stored.
>              zswap_store_pages() pre-allocates zswap entries for the batc=
h,
>              calls zswap_compress() for each page in this range, and stor=
es
>              the entries in xarray/LRU.
>=20
>    Patch 19) Introduces a new unified implementation of zswap_compress()
>              for compressors that do and do not support batching. This
>              eliminates code duplication and facilitates maintainability =
of
>              the code with the introduction of compress batching. Further=
,
>              there are many optimizations to this common code that result
>              in workload throughput and performance improvements with
>              software compressors and hardware accelerators such as IAA.
>=20
>              zstd performance is better or on par with mm-unstable. We
>              see impressive throughput/performance improvements with IAA
>              batching vs. no-batching.
>=20
>=20
> With v9 of this patch series, the IAA compress batching feature will be
> enabled seamlessly on Intel platforms that have IAA by selecting
> 'deflate-iaa' as the zswap compressor, and using the iaa_crypto 'async'
> sync_mode driver attribute (the default).
>=20
>=20
> System setup for testing:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> Testing of this patch-series was done with mm-unstable as of 4-21-2025,
> commit 2c01d9f3c611, without and with this patch-series. Data was
> gathered on an Intel Sapphire Rapids (SPR) server, dual-socket 56 cores
> per socket, 4 IAA devices per socket, 503 GiB RAM and 525G SSD disk
> partition swap. Core frequency was fixed at 2500MHz.
>=20
> Other kernel configuration parameters:
>=20
>     zswap compressor  : zstd, deflate-iaa
>     zswap allocator   : zsmalloc
>     vm.page-cluster   : 0
>=20
> IAA "compression verification" is disabled and IAA is run in the async
> mode (the defaults with this series).
>=20
> I ran experiments with these workloads:
>=20
> 1) usemem 30 processes with these large folios enabled to "always":
>    - 64k
>    - 2048k
>=20
>    IAA WQ Configuration:
>=20
>    Since usemem sees practically no swapin activity, we set up 1 WQ per
>    IAA device, so that all 128 entries are available for compress
>    jobs. All IAA's WQs are available to all package cores to send
>    compress/decompress jobs in a round-robin manner.
>=20
>      4 IAA devices
>      1 WQ per device
>      echo 0 > /sys/bus/dsa/drivers/crypto/g_comp_wqs_per_iaa
>      echo 1 > /sys/bus/dsa/drivers/crypto/distribute_comps
>      echo 1 > /sys/bus/dsa/drivers/crypto/distribute_decomps
>=20
> 2) Kernel compilation allmodconfig with 2G max memory, 32 threads, with
>    these large folios enabled to "always":
>    - 64k
>=20
>    IAA WQ Configuration:
>=20
>    Since kernel compilation sees considerable swapin activity, we set up
>    2 WQs per IAA device, each containing 64 entries. The driver sends
>    decompresses to wqX.0 and compresses to wqX.1. All IAAs' wqX.0 are
>    available to all package cores to send decompress jobs in a
>    round-robin manner. Likewise, all IAAs' wqX.1 are available to all
>    package cores to send decompress jobs in a round-robin manner.
>=20
>      4 IAA devices
>      2 WQs per device
>      echo 1 > /sys/bus/dsa/drivers/crypto/g_comp_wqs_per_iaa
>      echo 1 > /sys/bus/dsa/drivers/crypto/distribute_comps
>      echo 1 > /sys/bus/dsa/drivers/crypto/distribute_decomps
>=20
>=20
> Performance testing (usemem30):
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> The vm-scalability "usemem" test was run in a cgroup whose memory.high
> was fixed at 150G. The is no swap limit set for the cgroup. 30 usemem
> processes were run, each allocating and writing 10G of memory, and sleepi=
ng
> for 10 sec before exiting:
>=20
> usemem --init-time -w -O -b 1 -s 10 -n 30 10g
>=20
>=20
>  64K folios: usemem30: deflate-iaa:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>  ------------------------------------------------------------------------=
-------
>                  mm-unstable-4-21-2025             v9
>  ------------------------------------------------------------------------=
-------
>  zswap compressor         deflate-iaa     deflate-iaa    IAA Batching
>                                                              vs.
>                                                          IAA Sequential
>  ------------------------------------------------------------------------=
-------
>  Total throughput (KB/s)    6,091,607      10,174,344         67%
>  Avg throughput (KB/s)        203,053         339,144
>  elapsed time (sec)            100.46           69.70        -31%
>  sys time (sec)              2,416.97        1,648.37        -32%
>=20
>  ------------------------------------------------------------------------=
-------
>  memcg_high                 1,262,996       1,403,680
>  memcg_swap_fail                2,712           2,105
>  zswpout                   58,146,954      64,508,450
>  zswpin                            91             256
>  pswpout                            0               0
>  pswpin                             0               0
>  thp_swpout                         0               0
>  thp_swpout_fallback                0               0
>  64kB_swpout_fallback           2,712           2,105
>  pgmajfault                     2,858           3,032
>  ZSWPOUT-64kB               3,631,559       4,029,802
>  SWPOUT-64kB                        0               0
>  ------------------------------------------------------------------------=
-------
>=20
>=20
>  2M folios: usemem30: deflate-iaa:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>  ------------------------------------------------------------------------=
-------
>                  mm-unstable-4-21-2025              v9
>  ------------------------------------------------------------------------=
-------
>  zswap compressor          deflate-iaa     deflate-iaa     IAA Batching
>                                                                vs.
>                                                            IAA Sequential
>  ------------------------------------------------------------------------=
-------
>  Total throughput (KB/s)     6,371,048      11,282,935       77%
>  Avg throughput (KB/s)         212,368         376,097
>  elapsed time (sec)              87.15           63.04      -28%
>  sys time (sec)               2,011.56        1,450.45      -28%
>=20
>  ------------------------------------------------------------------------=
-------
>  memcg_high                    116,156         125,138
>  memcg_swap_fail                   348             248
>  zswpout                    59,815,486      64,509,928
>  zswpin                            442             422
>  pswpout                             0               0
>  pswpin                              0               0
>  thp_swpout                          0               0
>  thp_swpout_fallback               348             248
>  pgmajfault                      3,575           3,272
>  ZSWPOUT-2048kB                116,480         125,759
>  SWPOUT-2048kB                       0               0
>  ------------------------------------------------------------------------=
-------
>=20
>=20
>  64K folios: usemem30: zstd:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>=20
>  ------------------------------------------------------------------------=
-------
>                mm-unstable-4-21-2025            v9
>  ------------------------------------------------------------------------=
-------
>  zswap compressor               zstd          zstd       v9 zstd
>                                                          improvement
>  ------------------------------------------------------------------------=
-------
>  Total throughput (KB/s)   6,574,380     6,632,230        1%
>  Avg throughput (KB/s)       219,146       221,074
>  elapsed time (sec)            96.58         90.60       -6%
>  sys time (sec)             2,416.52      2,224.78       -8%
>=20
>  ------------------------------------------------------------------------=
-------
>  memcg_high                1,117,577     1,110,504
>  memcg_swap_fail                  65         2,217
>  zswpout                  48,771,672    48,806,988
>  zswpin                          137           429
>  pswpout                           0             0
>  pswpin                            0             0
>  thp_swpout                        0             0
>  thp_swpout_fallback               0             0
>  64kB_swpout_fallback             65         2,217
>  pgmajfault                    3,286         3,224
>  ZSWPOUT-64kB              3,048,122     3,048,198
>  SWPOUT-64kB                       0             0
>  ------------------------------------------------------------------------=
-------
>=20
>=20
>  2M folios: usemem30: zstd:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>=20
>  ------------------------------------------------------------------------=
-------
>                mm-unstable-4-21-2025            v9
>  ------------------------------------------------------------------------=
-------
>  zswap compressor               zstd          zstd      v9 zstd
>                                                         improvement
>  ------------------------------------------------------------------------=
-------
>  Total throughput (KB/s)   7,320,278     7,428,055       1%
>  Avg throughput (KB/s)       244,009       247,601
>  elapsed time (sec)            83.30         81.60      -2%
>  sys time (sec)             1,970.89      1,857.70      -6%
>=20
>  ------------------------------------------------------------------------=
-------
>  memcg_high                   92,970        92,708
>  memcg_swap_fail                  59           172
>  zswpout                  48,043,615    47,896,223
>  zswpin                           77           416
>  pswpout                           0             0
>  pswpin                            0             0
>  thp_swpout                        0             0
>  thp_swpout_fallback              59           172
>  pgmajfault                    2,815         3,170
>  ZSWPOUT-2048kB               93,776        93,381
>  SWPOUT-2048kB                     0             0
>  ------------------------------------------------------------------------=
-------
>=20
>=20
>=20
> Performance testing (Kernel compilation, allmodconfig):
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>=20
> The experiments with kernel compilation test use 32 threads and build
> the "allmodconfig" that takes ~14 minutes, and has considerable
> swapout/swapin activity. The cgroup's memory.max is set to 2G.
>=20
>=20
>  64K folios: Kernel compilation/allmodconfig:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>  ------------------------------------------------------------------------=
-------
>                        mm-unstable               v9    mm-unstable       =
     v9
>  ------------------------------------------------------------------------=
-------
>  zswap compressor      deflate-iaa      deflate-iaa           zstd       =
   zstd
>  ------------------------------------------------------------------------=
-------
>  real_sec                   835.31           837.75         858.73       =
 852.22
>  user_sec                15,649.58        15,660.48      15,682.66     15=
,649.91
>  sys_sec                  3,705.03         3,642.59       4,858.46      4=
,703.58
>  ------------------------------------------------------------------------=
-------
>  Max_Res_Set_Size_KB     1,874,524        1,872,200      1,871,248     1,=
870,972
>  ------------------------------------------------------------------------=
-------
>  memcg_high                      0                0              0       =
      0
>  memcg_swap_fail                 0                0              0       =
      0
>  zswpout                89,767,776       91,376,740     76,444,847    73,=
771,346
>  zswpin                 26,362,204       27,700,717     22,138,662    21,=
287,433
>  pswpout                       360              574             52       =
    154
>  pswpin                        275              551             19       =
     63
>  thp_swpout                      0                0              0       =
      0
>  thp_swpout_fallback             0                0              0       =
      0
>  64kB_swpout_fallback            0            1,523              0       =
      0
>  pgmajfault             27,938,009       29,559,339     23,339,818    22,=
458,108
>  ZSWPOUT-64kB            2,958,806        2,992,126      2,444,259     2,=
382,986
>  SWPOUT-64kB                    21               30              3       =
      8
>  ------------------------------------------------------------------------=
-------
>=20
>=20
>  2M folios: Kernel compilation/allmodconfig:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>  ------------------------------------------------------------------------=
-------
>                        mm-unstable               v9    mm-unstable       =
     v9
>  ------------------------------------------------------------------------=
-------
>  zswap compressor      deflate-iaa      deflate-iaa           zstd       =
   zstd
>  ------------------------------------------------------------------------=
-------
>  real_sec                   790.66           789.01         818.46       =
 819.08
>  user_sec                15,757.60        15,759.57      15,785.34     15=
,777.70
>  sys_sec                  4,307.92         4,184.09       5,602.95      5=
,582.45
>  ------------------------------------------------------------------------=
-------
>  Max_Res_Set_Size_KB     1,871,100        1,872,892      1,872,892     1,=
872,888
>  ------------------------------------------------------------------------=
-------
>  memcg_high                      0                0              0       =
      0
>  memcg_swap_fail                 0                0              0       =
      0
>  zswpout               107,349,845      101,481,140     90,083,661    90,=
818,923
>  zswpin                 37,486,883       35,081,184     29,823,462    29,=
597,292
>  pswpout                     3,664            1,191          1,066       =
  1,617
>  pswpin                      1,594              138             37       =
  1,594
>  thp_swpout                      7                2              2       =
      3
>  thp_swpout_fallback         9,434            8,100          6,354       =
  5,809
>  pgmajfault             38,781,821       36,235,171     30,677,937    30,=
442,685
>  ZSWPOUT-2048kB              8,810            7,772          7,857       =
  8,515
>  ------------------------------------------------------------------------=
-------
>=20
>=20
> With the iaa_crypto driver changes for non-blocking descriptor allocation=
s,
> no timeouts-with-mitigations were seen in compress/decompress jobs, for a=
ll
> of the above experiments.
>=20
>=20
>=20
> Changes since v8:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 4-21-2025, commit 2c01d9f3c611.
> 2) Backported commits for reverting request chaining, since these are
>    in cryptodev-2.6 but not yet in mm-unstable: without these backports,
>    deflate-iaa is non-functional in mm-unstable:
>    commit 64929fe8c0a4 ("crypto: acomp - Remove request chaining")
>    commit 5976fe19e240 ("Revert "crypto: testmgr - Add multibuffer acomp
>                          testing"")
>    Backported this hotfix as well:
>    commit 002ba346e3d7 ("crypto: scomp - Fix off-by-one bug when
>    calculating last page").
> 3) crypto_acomp_[de]compress() restored to non-request chained
>    implementations since request chaining has been removed from acomp in
>    commit 64929fe8c0a4 ("crypto: acomp - Remove request chaining").
> 4) New IAA WQ architecture to denote WQ type and whether or not a WQ
>    should be shared among all package cores, or only to the "mapped"
>    ones from an even cores-to-IAA distribution scheme.
> 5) Compress/decompress batching are implemented in iaa_crypto using new
>    crypto_acomp_batch_compress()/crypto_acomp_batch_decompress() API.
> 6) Defines a "void *data" in struct acomp_req, based on Herbert advising
>    against using req->base.data in the driver. This is needed for async
>    submit-poll to work.
> 7) In zswap.c, moved the CPU hotplug callbacks to reside in "pool
>    functions", per Yosry's suggestion to move procedures in a distinct
>    patch before refactoring patches.
> 8) A new "u8 nr_reqs" member is added to "struct zswap_pool" to track
>    the number of requests/buffers associated with the per-cpu acomp_ctx,
>    as per Yosry's suggestion.
> 9) Simplifications to the acomp_ctx resources allocation, deletion,
>    locking, and for these to exist from pool creation to pool deletion,
>    based on v8 code review discussions with Yosry.
> 10) Use IS_ERR_OR_NULL() consistently in zswap_cpu_comp_prepare() and
>     acomp_ctx_dealloc(), as per Yosry's v8 comment.
> 11) zswap_store_folio() is deleted, and instead, the loop over
>     zswap_store_pages() is moved inline in zswap_store(), per Yosry's
>     suggestion.
> 12) Better structure in zswap_compress(), unified procedure that
>     compresses/stores a batch of pages for both, non-batching and
>     batching compressors. Renamed from zswap_batch_compress() to
>     zswap_compress(): Thanks Yosry for these suggestions.
>=20
>=20
> Changes since v7:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 3-3-2025, commit 5f089a9aa987.
> 2) Changed the acomp_ctx->nr_reqs to be u8 since ZSWAP_MAX_BATCH_SIZE
> is
>    defined as 8U, for saving memory in this per-cpu structure.
> 3) Fixed a typo in code comments in acomp_ctx_get_cpu_lock():
>    acomp_ctx->initialized to acomp_ctx->__online.
> 4) Incorporated suggestions from Yosry, Chengming, Nhat and Johannes,
>    thanks to all!
>    a) zswap_batch_compress() replaces zswap_compress(). Thanks Yosry
>       for this suggestion!
>    b) Process the folio in sub-batches of ZSWAP_MAX_BATCH_SIZE, regardles=
s
>       of whether or not the compressor supports batching. This gets rid o=
f
>       the kmalloc(entries), and allows us to allocate an array of
>       ZSWAP_MAX_BATCH_SIZE entries on the stack. This is implemented in
>       zswap_store_pages().
>    c) Use of a common structure and code paths for compressing a folio in
>       batches, either as a request chain (in parallel in IAA hardware) or
>       sequentially. No code duplication since zswap_compress() has been
>       replaced with zswap_batch_compress(), simplifying maintainability.
> 5) A key difference between compressors that support batching and
>    those that do not, is that for the latter, the acomp_ctx mutex is
>    locked/unlocked per ZSWAP_MAX_BATCH_SIZE batch, so that
> decompressions
>    to handle page-faults can make progress. This fixes the zstd kernel
>    compilation regression seen in v7. For compressors that support
>    batching, for e.g. IAA, the mutex is locked/released once for storing
>    the folio.
> 6) Used likely/unlikely compiler directives and prefetchw to restore
>    performance with the common code paths.
>=20
> Changes since v6:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 2-27-2025, commit d58172d128ac.
>=20
> 2) Deleted crypto_acomp_batch_compress() and
>    crypto_acomp_batch_decompress() interfaces, as per Herbert's
>    suggestion. Batching is instead enabled by chaining the requests. For
>    non-batching compressors, there is no request chaining involved. Both,
>    batching and non-batching compressions are accomplished by zswap by
>    calling:
>=20
>    crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]),
> &acomp_ctx->wait);
>=20
> 3) iaa_crypto implementation of batch compressions/decompressions using
>    request chaining, as per Herbert's suggestions.
> 4) Simplification of the acomp_ctx resource allocation/deletion with
>    respect to CPU hot[un]plug, to address Yosry's suggestions to explore =
the
>    mutex options in zswap_cpu_comp_prepare(). Yosry, please let me know i=
f
>    the per-cpu memory cost of this proposed change is acceptable (IAA:
>    64.8KB, Software compressors: 8.2KB). On the positive side, I believe
>    restarting reclaim on a CPU after it has been through an offline-onlin=
e
>    transition, will be much faster by not deleting the acomp_ctx resource=
s
>    when the CPU gets offlined.
> 5) Use of lockdep assertions rather than comments for internal locking
>    rules, as per Yosry's suggestion.
> 6) No specific references to IAA in zswap.c, as suggested by Yosry.
> 7) Explored various solutions other than the v6 zswap_store_folio()
>    implementation, to fix the zstd regression seen in v5, to attempt to
>    unify common code paths, and to allocate smaller arrays for the zswap
>    entries on the stack. All these options were found to cause usemem30
>    latency regression with zstd. The v6 version of zswap_store_folio() is
>    the only implementation that does not cause zstd regression, confirmed
>    by 10 consecutive runs, each giving quite consistent latency
>    numbers. Hence, the v6 implementation is carried forward to v7, with
>    changes for branching for batching vs. sequential compression API
>    calls.
>=20
>=20
> Changes since v5:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 2-1-2025, commit 7de6fd8ab650.
>=20
> Several improvements, regression fixes and bug fixes, based on Yosry's
> v5 comments (Thanks Yosry!):
>=20
> 2) Fix for zstd performance regression in v5.
> 3) Performance debug and fix for marginal improvements with IAA batching
>    vs. sequential.
> 4) Performance testing data compares IAA with and without batching, inste=
ad
>    of IAA batching against zstd.
> 5) Commit logs/zswap comments not mentioning crypto_acomp
> implementation
>    details.
> 6) Delete the pr_info_once() when batching resources are allocated in
>    zswap_cpu_comp_prepare().
> 7) Use kcalloc_node() for the multiple acomp_ctx buffers/reqs in
>    zswap_cpu_comp_prepare().
> 8) Simplify and consolidate error handling cleanup code in
>    zswap_cpu_comp_prepare().
> 9) Introduce zswap_compress_folio() in a separate patch.
> 10) Bug fix in zswap_store_folio() when xa_store() failure can cause all
>     compressed objects and entries to be freed, and UAF when zswap_store(=
)
>     tries to free the entries that were already added to the xarray prior
>     to the failure.
> 11) Deleting compressed_bytes/bytes. zswap_store_folio() also comprehends
>     the recent fixes in commit bf5eaaaf7941 ("mm/zswap: fix inconsistency
>     when zswap_store_page() fails") by Hyeonggon Yoo.
>=20
> iaa_crypto improvements/fixes/changes:
>=20
> 12) Enables asynchronous mode and makes it the default. With commit
>     4ebd9a5ca478 ("crypto: iaa - Fix IAA disabling that occurs when
>     sync_mode is set to 'async'"), async mode was previously just sync. W=
e
>     now have true async support.
> 13) Change idxd descriptor allocations from blocking to non-blocking with
>     timeouts, and mitigations for compress/decompress ops that fail to
>     obtain a descriptor. This is a fix for tasks blocked errors seen in
>     configurations where 30+ cores are running workloads under high memor=
y
>     pressure, and sending comps/decomps to 1 IAA device.
> 14) Fixes a bug with unprotected access of "deflate_generic_tfm" in
>     deflate_generic_decompress(), which can cause data corruption and
>     zswap_decompress() kernel crash.
> 15) zswap uses crypto_acomp_batch_compress() with async polling instead o=
f
>     request chaining for slightly better latency. However, the request
>     chaining framework itself is unchanged, preserved from v5.
>=20
>=20
> Changes since v4:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 12-20-2024, commit 5555a83c82d6.
> 2) Added acomp request chaining, as suggested by Herbert. Thanks Herbert!
> 3) Implemented IAA compress batching using request chaining.
> 4) zswap_store() batching simplifications suggested by Chengming, Yosry a=
nd
>    Nhat, thanks to all!
>    - New zswap_compress_folio() that is called by zswap_store().
>    - Move the loop over folio's pages out of zswap_store() and into a
>      zswap_store_folio() that stores all pages.
>    - Allocate all zswap entries for the folio upfront.
>    - Added zswap_batch_compress().
>    - Branch to call zswap_compress() or zswap_batch_compress() inside
>      zswap_compress_folio().
>    - All iterations over pages kept in same function level.
>    - No helpers other than the newly added zswap_store_folio() and
>      zswap_compress_folio().
>=20
>=20
> Changes since v3:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 11-18-2024, commit 5a7056135bb6.
> 2) Major re-write of iaa_crypto driver's mapping of IAA devices to cores,
>    based on packages instead of NUMA nodes.
> 3) Added acomp_has_async_batching() API to crypto acomp, that allows
>    zswap/zram to query if a crypto_acomp has registered batch_compress an=
d
>    batch_decompress interfaces.
> 4) Clear the poll bits on the acomp_reqs passed to
>    iaa_comp_a[de]compress_batch() so that a module like zswap can be
>    confident about the acomp_reqs[0] not having the poll bit set before
>    calling the fully synchronous API crypto_acomp_[de]compress().
>    Herbert, I would appreciate it if you can review changes 2-4; in patch=
es
>    1-8 in v4. I did not want to introduce too many iaa_crypto changes in
>    v4, given that patch 7 is already making a major change. I plan to wor=
k
>    on incorporating the request chaining using the ahash interface in v5
>    (I need to understand the basic crypto ahash better). Thanks Herbert!
> 5) Incorporated Johannes' suggestion to not have a sysctl to enable
>    compress batching.
> 6) Incorporated Yosry's suggestion to allocate batching resources in the
>    cpu hotplug onlining code, since there is no longer a sysctl to contro=
l
>    batching. Thanks Yosry!
> 7) Incorporated Johannes' suggestions related to making the overall
>    sequence of events between zswap_store() and zswap_batch_store()
> similar
>    as much as possible for readability and control flow, better naming of
>    procedures, avoiding forward declarations, not inlining error path
>    procedures, deleting zswap internal details from zswap.h, etc. Thanks
>    Johannes, really appreciate the direction!
>    I have tried to explain the minimal future-proofing in terms of the
>    zswap_batch_store() signature and the definition of "struct
>    zswap_batch_store_sub_batch" in the comments for this struct. I hope t=
he
>    new code explains the control flow a bit better.
>=20
>=20
> Changes since v2:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 11-5-2024, commit 7994b7ea6ac8.
> 2) Fixed an issue in zswap_create_acomp_ctx() with checking for NULL
>    returned by kmalloc_node() for acomp_ctx->buffers and for
>    acomp_ctx->reqs.
> 3) Fixed a bug in zswap_pool_can_batch() for returning true if
>    pool->can_batch_comp is found to be equal to BATCH_COMP_ENABLED,
> and if
>    the per-cpu acomp_batch_ctx tests true for batching resources having
>    been allocated on this cpu. Also, changed from per_cpu_ptr() to
>    raw_cpu_ptr().
> 4) Incorporated the zswap_store_propagate_errors() compilation warning fi=
x
>    suggested by Dan Carpenter. Thanks Dan!
> 5) Replaced the references to SWAP_CRYPTO_SUB_BATCH_SIZE in comments
> in
>    zswap.h, with SWAP_CRYPTO_BATCH_SIZE.
>=20
> Changes since v1:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 11-1-2024, commit 5c4cf96cd702.
> 2) Incorporated Herbert's suggestions to use an acomp_req flag to indicat=
e
>    async/poll mode, and to encapsulate the polling functionality in the
>    iaa_crypto driver. Thanks Herbert!
> 3) Incorporated Herbert's and Yosry's suggestions to implement the batchi=
ng
>    API in iaa_crypto and to make its use seamless from zswap's
>    perspective. Thanks Herbert and Yosry!
> 4) Incorporated Yosry's suggestion to make it more convenient for the use=
r
>    to enable compress batching, while minimizing the memory footprint
>    cost. Thanks Yosry!
> 5) Incorporated Yosry's suggestion to de-couple the shrink_folio_list()
>    reclaim batching patch from this series, since it requires a broader
>    discussion.
>=20
>=20
> I would greatly appreciate code review comments for the iaa_crypto driver
> and mm patches included in this series!
>=20
> Thanks,
> Kanchana
>=20
>=20
>=20
> Kanchana P Sridhar (19):
>   crypto: acomp - Remove request chaining
>   crypto: acomp - Reinstate non-chained crypto_acomp_[de]compress().
>   Revert "crypto: testmgr - Add multibuffer acomp testing"
>   crypto: scomp - Fix off-by-one bug when calculating last page
>   crypto: iaa - Re-organize the iaa_crypto driver code.
>   crypto: iaa - New architecture for IAA device WQ comp/decomp usage &
>     core mapping.
>   crypto: iaa - Define and use req->data instead of req->base.data.
>   crypto: iaa - Descriptor allocation timeouts with mitigations in
>     iaa_crypto.
>   crypto: iaa - CRYPTO_ACOMP_REQ_POLL acomp_req flag for sequential vs.
>     parallel.
>   crypto: acomp - New interfaces to facilitate batching support in acomp
>     & drivers.
>   crypto: iaa - Implement crypto_acomp batching interfaces for Intel
>     IAA.
>   crypto: iaa - Enable async mode and make it the default.
>   crypto: iaa - Disable iaa_verify_compress by default.
>   mm: zswap: Move the CPU hotplug procedures under "pool functions".
>   mm: zswap: Per-CPU acomp_ctx resources exist from pool creation to
>     deletion.
>   mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
>     resources.
>   mm: zswap: Allocate pool batching resources if the compressor supports
>     batching.
>   mm: zswap: zswap_store() will process a folio in batches.
>   mm: zswap: Batched zswap_compress() with compress batching of large
>     folios.
>=20
>  .../driver-api/crypto/iaa/iaa-crypto.rst      |  145 +-
>  crypto/acompress.c                            |  112 +-
>  crypto/scompress.c                            |   28 +-
>  crypto/testmgr.c                              |  147 +-
>  drivers/crypto/intel/iaa/iaa_crypto.h         |   30 +-
>  drivers/crypto/intel/iaa/iaa_crypto_main.c    | 1934 ++++++++++++-----
>  include/crypto/acompress.h                    |  129 +-
>  include/crypto/internal/acompress.h           |   25 +-
>  mm/zswap.c                                    |  684 +++---
>  9 files changed, 2199 insertions(+), 1035 deletions(-)
>=20
>=20
> base-commit: 2c01d9f3c61101355afde90dc5c0b39d9a772ef3
> --
> 2.27.0

Hi all,

Please disregard the earlier v9 series sent on 4/30/2025. Today's resend of=
 v9
is the same code posted earlier,  just added Sergey and Vinicius to the rec=
ipients.

The only patch from the 4/30 series that had comments from Herbert and=20
follow-up data that I shared is [1], for reference. I would appreciate feed=
back
on next steps from the zswap maintainers as requested in [1].

[1] https://patchwork.kernel.org/project/linux-mm/patch/20250430205305.2284=
4-11-kanchana.p.sridhar@intel.com/

Thanks,
Kanchana
