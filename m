Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9AE1422AB;
	Mon, 17 Mar 2025 21:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742246145; cv=fail; b=sKQvwE6+iOB+yEMtva8/prJn7aG1V8yO7iyMR81/n5NdzQoD2NWrPflZeEAw2JQrkJwNIgik2SFpStTIFiL8B+YgytZLzTVATiMVKn0aZPwtzlZTO5/m3LgWdEYNUnKsT6Ocdj503t2rok40/0scEIpsqudmf85+xNFgAcvl/IY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742246145; c=relaxed/simple;
	bh=Z8qsylAESvfVmaeKVrzM++D9qwJQtiXItba7tJePVk8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SePHDkrmEeVX0SLNJPN5HdbjNpDaq0K8HMHUqzSWJUN1ZCk7eBy8OsGuQ5qQJ7RXb6/hkZ4KR1W9I6p3DAZENVPYRpxDIxHbx4r6/yTYDC9DA++es+Bs9R5rGGxV4utVtRe7gVEckweFSnD60274rD6AsbqF/lcNm7JtW7BTE/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jx1r10A5; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jx1r10A5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742246143; x=1773782143;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z8qsylAESvfVmaeKVrzM++D9qwJQtiXItba7tJePVk8=;
  b=jx1r10A5WLmTwAQaE/AX/lGh5lI/e64ceNXo7H1Drt2+XhwxTo4Yw2jJ
   eh2OWKcDik3cxUypSBoQlO3tNXdK5fhemE2CRVA8Y2La/QKggDlmSlMEK
   w5UFECruHQMqhTz3f7QBRDpQoLMA4lBNrawOnzLIiS6K5xUHsPc5pHsLI
   nJBsSXx1YjVzMFudBA8rQe1CW4oPKHQ2QCnBSrA2qYA+OL/w+pumDf1l/
   i4k5hoxG6ngx5+3Q+jeL6d+tA/0jDUpNP0SEe0gNSIFYu6Rv5+FaUDPho
   syc78aZ/mW8NBguVAjhNGfKTwFksAn/QEfepfrdIDUJo9Id3YYK7t0Xqk
   A==;
X-CSE-ConnectionGUID: pJgW5QnURhW+xK2IyXk5IQ==
X-CSE-MsgGUID: 183bsqdzRW6wS3d81E9wxQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="46129928"
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="46129928"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 14:15:41 -0700
X-CSE-ConnectionGUID: O+kg0QkuRkqe78mqYGB0Aw==
X-CSE-MsgGUID: Z87XljihQIiNp87rRXKGLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="122004883"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 14:15:42 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 17 Mar 2025 14:15:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 17 Mar 2025 14:15:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 17 Mar 2025 14:15:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xnONq7lbd6Y6PUw1nfy7HX/mCXD82ebAATsVuFmN9lm6zDsgWWclTK349FIdWmsoZPYmgJ3iZr5/R6EXLdAKTtFcoHoP3wQlh+uAbwtKZAeNncjaiCNfA5oStwdgGOe0M7mLUdSVnXG8i7AnreE4A8c8XXKlXvo3z8GXdsSMv2DMzQdAFEA4C5+EriJ0ej+XEyO0JIg0lLI8D/M+MaTrZrmL3RYblLyu9/TKMGVyCT7QTSHApHmU47Sg7/6LTEssB1/vg77b02ojMXfQQceJ4QjPkAk6VjtNUYrfkUNiDXgMdveeIyci2jpEhIu1j+i2DGf9yQz2VDejWQPP+QL8xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BaT2REtR2k3OhH1GLMSsKKe7C2QAIUaZz2sk1ZN1CXk=;
 b=nDKhf2mgvj69A9ZaUke+0MVWlLwzD2wBh9fLnr456rgfaK6ypGE9262abkfQgFwhRjaE2/HPdZcdKZbwmilaAeHNTyrBNMjKB6CPs0CBg/a89yS/DZUVTsr3yYDWnBlprfCecSRGpT6GFFgERXXSutu5c4aUkzBJWeUvc9vTc+LuOZksjciSU1cPkF0ZCVlgyfUVbxwlYFTSsEHMdv5NyQ4vXW4aOS250uiGwlXAGt6GXXysoRbR5lnBBa3luEk+XsGZOOq8vHmi8odmPIz55UyOvYlRtsfy2GQrS1pjenwYFpd15QeuENAil/39WCzN1pbkyDQAzbYyyPwa1u8qlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by BL1PR11MB5253.namprd11.prod.outlook.com (2603:10b6:208:310::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 21:15:10 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%5]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 21:15:09 +0000
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
Subject: RE: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
 allocation/deletion and mutex lock usage.
Thread-Topic: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
 allocation/deletion and mutex lock usage.
Thread-Index: AQHbjBjx1q5dleb6eEq5EZF781nDprNmhasAgAA86hCAAVPdAIAAYjdggAQziACACyMtkA==
Date: Mon, 17 Mar 2025 21:15:09 +0000
Message-ID: <SA3PR11MB812082535F1E6D63BC0F1412C9DF2@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
 <20250303084724.6490-13-kanchana.p.sridhar@intel.com>
 <Z8n5CCmELvpUwi3B@google.com>
 <PH8SPRMB004414B5E1E0765C18F9A89DC9D52@PH8SPRMB0044.namprd11.prod.outlook.com>
 <Z8tJOi5G_3dpK31v@google.com>
 <PH8SPRMB00447B066A769C76F57F8800C9D42@PH8SPRMB0044.namprd11.prod.outlook.com>
 <Z88h1mPkYNM6yOGE@google.com>
In-Reply-To: <Z88h1mPkYNM6yOGE@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|BL1PR11MB5253:EE_
x-ms-office365-filtering-correlation-id: a50e2b53-1642-4262-bb9c-08dd6598cca0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?0yV1ntYHpHYmE9jQFbd5RSBMI3jbMdQbCEyfirSBUxAQM7eSoXwyGY7proBe?=
 =?us-ascii?Q?8wsIwU2gaS/WSqPbN3Z8RdIjGNQNaQ3t+EP4ScQB8agG9Pl5T0aswwL5b6Da?=
 =?us-ascii?Q?RYKdUEZ9EoUw3UL7pyUDdXPU+HVMKfvGviHYwA+iiV29m2ldSH3xolBpjRvV?=
 =?us-ascii?Q?R7LqHsOoi7WhC5n37rLng7QtngiAh20POsJVjYBWFY7x2UetyoxaocUxjxJU?=
 =?us-ascii?Q?rVfmzrHKpdSobemuSAu+JjrZwsybVsy+MRZNV7qm4Cn7rjD1AAxIvZZgHH5O?=
 =?us-ascii?Q?C9zDYNl/ApdxgPq8JBwCL8JFDj3nrQ1x17iuns0EJcl4COUTVW3M4b8J5cFz?=
 =?us-ascii?Q?lR++WWvevRf9AZoRva4AvMXblCH48O8LjpNMm75znx7H24TglVlJLLoH18ZS?=
 =?us-ascii?Q?WGT5HrtIWD/EyLqB/JSV0Z3BtoSYyH8O7O/ilA1XUNqgHLlbPRwXry/LjSMt?=
 =?us-ascii?Q?BT2hXkvo1wXkZnbkBbpRC3DvVDC0pwC5G4eD5Sw+dLE3ZaWxufeyf42Q0d0R?=
 =?us-ascii?Q?hLhvLm76Dk/sg9tF9DxXlODcNhS6G9R99Y4Oi7a4neIFbJNrZsHqTFG3mO2Q?=
 =?us-ascii?Q?z5v4wMs6vhXpSiRwH3J2idlZuKN/Knvkb1WGaN1xmyZSrnGYhyqNMNT3gf45?=
 =?us-ascii?Q?RUD5ekiEKMhRomhVOZR1dIr2q4NRD3LGvV0C+Tm5FMrUYRi9be1iWEZZSUyV?=
 =?us-ascii?Q?834GWmbmX4oCdg2JFr2zptCifBhT1j7BlPGb0KQ1oq84pLDdsJ10fwzTOsK5?=
 =?us-ascii?Q?SrXdoC3aZgc/Y+JXVo/IHk/Fj8yRC5DDWH9t4cwS4cAZms7cpVO60m8vwvji?=
 =?us-ascii?Q?kW92CaVLk8EfJ7akP+jptoWq8/mD3jkl3L5V/oO1WBoiPUzw/xq8s4d+L3mJ?=
 =?us-ascii?Q?ZYySHcYDr7piwcBI7rN7poJ4RAi41RrU1f6qdlpJbFDqFhvrbH6jFIM5jj5y?=
 =?us-ascii?Q?6pfdHYOjNhE0Iu1jd+poW/6hEOUp9oE+eLNzCVEnvEXQSL491r8hEpc4mLj7?=
 =?us-ascii?Q?uHkuetPBpdww0UJThXB0A0HpjXA7nNqXP0F1UQkip7qtXUOd1TS5hn0GgPcN?=
 =?us-ascii?Q?pYbINBpt0G91ws3Mv1zE5XE/pcCSIWEM18Vxd1MRjQgHexxpWWAbTwoxQywn?=
 =?us-ascii?Q?mxS/wCzRmuZH7pLY3jaBGKRjfLKrBm61WHxVRDFP0/td6so3ephzQCSlsR/Q?=
 =?us-ascii?Q?3cDyJd4wpt9FTzgWVaY7VIm+7Jkabr2eaeEvmiaFgkecApdNwCAxUnz33apu?=
 =?us-ascii?Q?l9e0Z04GmoR8aPZIFHAklsvkfO9b1ROJTVLuE3nlqyeEusoksMfD8GD1o1ZK?=
 =?us-ascii?Q?emiRG3zBkUnJ/NhpvJkHA5xWTRsE7EEfS8ejwGW47GcCAg2U8n1m+FTR17R7?=
 =?us-ascii?Q?46u5o0MhILM9ba0knZ5XP2h1D71MH4uTuCPZ0FB4Zi4zrhH+10+J53bRaDOA?=
 =?us-ascii?Q?qXuLEF1mGtLpZSRU40gKGT+tLfkrGGzm?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CJJG9DN1m5KqUZ0o2nrlubdQp3pG3kZAr2Wh5XXxNd5hWRV0Ju8BZSWINij4?=
 =?us-ascii?Q?qgSDk5f1JDfSN0lH6IH4ej2OxMX8WmSBiCT7j1DMt/sZ09BiTX2V21PaKhon?=
 =?us-ascii?Q?rhoOzJhlKNvkk3EsEfpylwhYI6jK9ZyEX8iCquqa4ogR+6XKATs7yuTANb7E?=
 =?us-ascii?Q?6dQDYZM1I3UosxnBLyL31Voxg6h5j5VsDpwy1D2aQgDzvXHGpfAb8xjHTnrB?=
 =?us-ascii?Q?PcU9+rZeeZ3OUHNN8ABiFq8p0lHzasKPptEKEQUtSJEgZl6BNZuWAA6abSPn?=
 =?us-ascii?Q?E9eyxoZJkk4BBfAgTUY4+TncKmJyyhE+H+9MgT6YTWyVJ5Xyo5h2mRSap0jU?=
 =?us-ascii?Q?sEZXuLiBOlYog2c1HU0056WrU5n9ztEETbuwSN8zy6B47s+8VJfLYOpxTH0b?=
 =?us-ascii?Q?ngT7i70HsCYOum04J1PmEO2bQ9fYwCpNJG7vLjptUl5Fh8ueZSAKgo1BzeYS?=
 =?us-ascii?Q?u1VXvfv7dNOn4s7cH9mifxamD431YAyr8S/WUjLkqoyyq6Gsr9NBzFjhuliM?=
 =?us-ascii?Q?oMslYVN1XV091ubmMfCKtjbQHcIcJRtyG5OhSxlfVnsxnq96wB31n+DD9whx?=
 =?us-ascii?Q?oRLegh/LGasDzBIGQT8RZ9v/Z7OnvIlUUn05a9bj6ubWMDthSRLI4FU/Z/nd?=
 =?us-ascii?Q?fcVmjy2M+6lQFHbu9Gl/hzKgSifyyYnuciJSckIAFCDCPh34xB5WVRaCZPBr?=
 =?us-ascii?Q?oY9Xqje0OZ7U4imNlquZuFrqHkvw+OsoAdunf+VJ4gU+K4iYiK0NOn9vR+q7?=
 =?us-ascii?Q?mWkM0e69NWhigfL5OSSQ3DzXuaqvtCVtmGkNsC9suASxN92oST853h7s6ndA?=
 =?us-ascii?Q?6rWTc20w7cfj8pfN9ZzSGpk+PQdICwiEAnJzS5rWs2DDIW8Awz5BL/HSSi4s?=
 =?us-ascii?Q?EOXU95DpM122swSvjcU/u4AHRlbw2b56xccpy88eSLGdpHDwWn3+TdjeU/T/?=
 =?us-ascii?Q?0EFKXmvQCTlm5aBNprA3yba9NP2AjNlwh1lR1oPUyNMFToAqpsXjbpBhveWb?=
 =?us-ascii?Q?VcuiRvls5bot7I+QYQWFnKRA2DZET/J4TY0lfNMQDUDOD16f07BHFcjI3nA9?=
 =?us-ascii?Q?3XoODl8DlD9aVn4tSbgpjkVql8KI6NqrbL1zgcSb3PKoLaeWmwzLTy6qUq0A?=
 =?us-ascii?Q?ErL26VdsTA+0ziZiF4ZVxBZP9Vr0e2CXtHc6/ksv2Hrht0HZxkew1+5c98kE?=
 =?us-ascii?Q?PuJbjH2Dwtv6k0doEze4fDDixxvJdhajVfcuwwCVCjw9uzmD3F4kFkwAZ9xF?=
 =?us-ascii?Q?Knax0psv2jKA+4jJDC9mOOAjRYY5Hl7GKVwv4MXIbi5n9PNtzt/Wk3L5p3k3?=
 =?us-ascii?Q?x1VER76qIBthIjaEXEAHZEp0or/e1n2gbeUL8865HgCAc2ypxtt7orxrEMKv?=
 =?us-ascii?Q?2p7X3rTzFKr91EI0FH6ywNjMgpjGfjjncL1it22J0/1Tt7Nfvr+0MxQJy1Hd?=
 =?us-ascii?Q?47sY6vz5b7mEHJ2xmhWgXHsuT2Bo6Se9P9rinBX6BoQCvkGCX6KBuOgVDdwC?=
 =?us-ascii?Q?UExB8g/+WaiwcvlX5MWWzfZgLe3TGKwam1Ih6zOTou08PkuBN2joZxovN28E?=
 =?us-ascii?Q?yzc8/e+uwoFy2Nm0BsrP10v4XO20amc/SWUWijsf+6wa0KpIH9ueuSjW9akC?=
 =?us-ascii?Q?vQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a50e2b53-1642-4262-bb9c-08dd6598cca0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2025 21:15:09.8766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yjnh+I7wPLMSJSdTZLc5CSgNY81Mq59RMyl4xsCTqnaYzGLlFd5XGO8g1G9RURHvx70dP/QHTEGdB9yzlKmRdjDBNuL5346bpqGKrY8kmHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5253
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Monday, March 10, 2025 10:31 AM
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
> Subject: Re: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
> allocation/deletion and mutex lock usage.
>=20
> On Sat, Mar 08, 2025 at 02:47:15AM +0000, Sridhar, Kanchana P wrote:
> >
> [..]
> > > > > >  	u8 *buffer;
> > > > > > +	u8 nr_reqs;
> > > > > > +	struct crypto_wait wait;
> > > > > >  	struct mutex mutex;
> > > > > >  	bool is_sleepable;
> > > > > > +	bool __online;
> > > > >
> > > > > I don't believe we need this.
> > > > >
> > > > > If we are not freeing resources during CPU offlining, then we do =
not
> > > > > need a CPU offline callback and acomp_ctx->__online serves no
> purpose.
> > > > >
> > > > > The whole point of synchronizing between offlining and
> > > > > compress/decompress operations is to avoid UAF. If offlining does=
 not
> > > > > free resources, then we can hold the mutex directly in the
> > > > > compress/decompress path and drop the hotunplug callback
> completely.
> > > > >
> > > > > I also believe nr_reqs can be dropped from this patch, as it seem=
s like
> > > > > it's only used know when to set __online.
> > > >
> > > > All great points! In fact, that was the original solution I had imp=
lemented
> > > > (not having an offline callback). But then, I spent some time
> understanding
> > > > the v6.13 hotfix for synchronizing freeing of resources, and this c=
omment
> > > > in zswap_cpu_comp_prepare():
> > > >
> > > > 	/*
> > > > 	 * Only hold the mutex after completing allocations, otherwise we
> > > may
> > > > 	 * recurse into zswap through reclaim and attempt to hold the mute=
x
> > > > 	 * again resulting in a deadlock.
> > > > 	 */
> > > >
> > > > Hence, I figured the constraint of "recurse into zswap through recl=
aim"
> was
> > > > something to comprehend in the simplification (even though I had a
> tough
> > > > time imagining how this could happen).
> > >
> > > The constraint here is about zswap_cpu_comp_prepare() holding the
> mutex,
> > > making an allocation which internally triggers reclaim, then recursin=
g
> > > into zswap and trying to hold the same mutex again causing a deadlock=
.
> > >
> > > If zswap_cpu_comp_prepare() does not need to hold the mutex to begin
> > > with, the constraint naturally goes away.
> >
> > Actually, if it is possible for the allocations in zswap_cpu_comp_prepa=
re()
> > to trigger reclaim, then I believe we need some way for reclaim to know=
 if
> > the acomp_ctx resources are available. Hence, this seems like a potenti=
al
> > for deadlock regardless of the mutex.
>=20
> I took a closer look and I believe my hotfix was actually unnecessary. I
> sent it out in response to a syzbot report, but upon closer look it
> seems like it was not an actual problem. Sorry if my patch confused you.
>=20
> Looking at enum cpuhp_state in include/linux/cpuhotplug.h, it seems like
> CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section. The comment
> above
> says:
>=20
>  * PREPARE: The callbacks are invoked on a control CPU before the
>  * hotplugged CPU is started up or after the hotplugged CPU has died.
>=20
> So even if we go into reclaim during zswap_cpu_comp_prepare(), it will
> never be on the CPU that we are allocating resources for.
>=20
> The other case where zswap_cpu_comp_prepare() could race with
> compression/decompression is when a pool is being created. In this case,
> reclaim from zswap_cpu_comp_prepare() can recurse into zswap on the
> same
> CPU AFAICT. However, because the pool is still under creation, it will
> not be used (i.e. zswap_pool_current_get() won't find it).
>=20
> So I think we don't need to worry about zswap_cpu_comp_prepare() racing
> with compression or decompression for the same pool and CPU.

Thanks Yosry, for this observation! You are right, when considered purely
from a CPU hotplug perspective, zswap_cpu_comp_prepare() and
zswap_cpu_comp_dead() in fact run on a control CPU, because the state is
registered in the PREPARE section of "enum cpuhp_state" in cpuhotplug.h.

The problem however is that, in the current architecture, CPU onlining/=20
zswap_pool creation, and CPU offlining/zswap_pool deletion have the
same semantics as far as these resources are concerned. Hence, although
zswap_cpu_comp_prepare() is run on a control CPU, the CPU for which
the "hotplug" code is called is in fact online. It is possible for the memo=
ry
allocation calls in zswap_cpu_comp_prepare() to recurse into
zswap_compress(), which now needs to be handled by the current pool,
since the new pool has not yet been added to the zswap_pools, as you
pointed out.

The ref on the current pool has not yet been dropped. Could there be
a potential for a deadlock at pool transition time: the new pool is blocked
from allocating acomp_ctx resources, triggering reclaim, which the old
pool needs to handle?

I see other places in the kernel that use CPU hotplug for resource allocati=
on,
outside of the context of CPU onlining. IIUC, it is difficult to guarantee =
that
the startup/teardown callbacks are modifying acomp_ctx resources for a
dysfunctional CPU.

Now that I think about it, the only real constraint is that the acomp_ctx
resources are guaranteed to exist for a functional CPU which can run zswap
compress/decompress.

I think we can simplify this as follows, and would welcome suggestions
to improve the proposed solution:

1) We dis-associate the acomp_ctx from the pool, and instead, have this
    be a global percpu zswap resource that gets allocated once in zswap_set=
up(),
    just like the zswap_entry_cache.
2) The acomp_ctx resources will get allocated during zswap_setup(), using
    the cpuhp_setup_state_multi callback() in zswap_setup(), that registers
    zswap_cpu_comp_prepare(), but no teardown callback.
3) We call cpuhp_state_add_instance() for_each_possible_cpu(cpu) in
     zswap_setup().=20
4) The acomp_ctx resources persist through subsequent "real CPU offline/onl=
ine
     state transitions".
5) zswap_[de]compress() can go ahead and lock the mutex, and use the
    reqs/buffers without worrying about whether these resources are
    initialized or still exist/are being deleted.
6) "struct zswap_pool" is now de-coupled from this global percpu zswap
    acomp_ctx.
7) To address the issue of how many reqs/buffers to allocate, there could
     potentially be a memory cost for non-batching compressors, if we want
     to always allocate ZSWAP_MAX_BATCH_SIZE acomp_reqs and buffers.
     This would allow the acomp_ctx to seamlessly handle batching
     compressors, non-batching compressors, and transitions among the
     two compressor types in a pretty general manner, that relies only on
     the ZSWAP_MAX_BATCH_SIZE, which we define anyway.

     I believe we can maximize the chances of success for the allocation of
     the acomp_ctx resources if this is done in zswap_setup(), but please
     correct me if I am wrong.

     The added memory cost for platforms without IAA would be
     ~57 KB per cpu, on x86. Would this be acceptable?
     If not, I don't believe this simplification would be worth it, because
     allocating for one req/buffer, then dynamically adding more resources
     if a newly selected compressor requires more resources, would run
     into the same race conditions and added checks as in
     acomp_ctx_get_cpu_lock(), which I believe, seem to be necessary becaus=
e
     CPU onlining/zswap_pool creation and CPU offlining/zswap_pool
     deletion have the same semantics for these resources.

    The only other fallback solution in lieu of the proposed simplification=
 that
    I can think of is to keep the lifespan of these resources from pool cre=
ation
    to deletion, using the CPU hotplug code. Although, it is not totally cl=
ear
    to me if there is potential for deadlock during pool transitions, as no=
ted above.

Please do let me know your suggestions on how to proceed. If the
simplification and added memory cost are acceptable, I can implement this a=
s
part of my v9 changes.

>=20
> >
> > I verified that all the zswap_cpu_comp_prepare() allocations are done w=
ith
> > GFP_KERNEL, which implicitly allows direct reclaim. So this appears to =
be a
> > risk for deadlock between zswap_compress() and
> zswap_cpu_comp_prepare()
> > in general, i.e., aside from this patchset.
> >
> > I can think of the following options to resolve this, and would welcome
> > other suggestions:
> >
> > 1) Less intrusive: acomp_ctx_get_cpu_lock() should get the mutex, check
> >     if acomp_ctx->__online is true, and if so, return the mutex. If
> >     acomp_ctx->__online is false, then it returns NULL. In other words,=
 we
> >     don't have the for loop.
> >     - This will cause recursions into direct reclaim from
> zswap_cpu_comp_prepare()
> >        to fail, cpuhotplug to fail. However, there is no deadlock.
> >         - zswap_compress() will need to detect NULL returned by
> >           acomp_ctx_get_cpu_lock(), and return an error.
> >         - zswap_decompress() will need a BUG_ON(!acomp_ctx) after calli=
ng
> >           acomp_ctx_get_cpu_lock().
> >     - We won't be migrated to a different CPU because we hold the mutex=
,
> hence
> >       zswap_cpu_comp_dead() will wait on the mutex.
> >
> > 2) More intrusive: We would need to use a gfp_t that prevents direct
> reclaim
> >     and kswapd, i.e., something similar to GFP_TRANSHUGE_LIGHT in
> gfp_types.h,
> >     but for non-THP allocations. If we decide to adopt this approach, w=
e
> would
> >     need changes in include/crypto/acompress.h, crypto/api.c, and
> crypto/acompress.c
> >     to allow crypto_create_tfm_node() to call crypto_alloc_tfmmem() wit=
h
> this
> >     new gfp_t, in lieu of GFP_KERNEL.
> >
> > >
> > > >
> > > > Hence, I added the "bool __online" because
> zswap_cpu_comp_prepare()
> > > > does not acquire the mutex lock while allocating resources. We have
> > > already
> > > > initialized the mutex, so in theory, it is possible for
> compress/decompress
> > > > to acquire the mutex lock. The __online acts as a way to indicate
> whether
> > > > compress/decompress can proceed reliably to use the resources.
> > >
> > > For compress/decompress to acquire the mutex they need to run on that
> > > CPU, and I don't think that's possible before onlining completes, so
> > > zswap_cpu_comp_prepare() must have already completed before
> > > compress/decompress can use that CPU IIUC.
> >
> > If we can make this assumption, that would be great! However, I am not
> > totally sure because of the GFP_KERNEL allocations in
> > zswap_cpu_comp_prepare().
>=20
> As I mentioned above, when zswap_cpu_comp_prepare() is run we are in one
> of two situations:
> - The pool is under creation, so we cannot race with stores/loads from
>   that same pool.
> - The CPU is being onlined, in which case zswap_cpu_comp_prepare() is
>   called from a control CPU before tasks start running on the CPU being
>   onlined.
>=20
> Please correct me if I am wrong.

I agree and think we can simplify this even further.

>=20
> [..]
> > > > > > @@ -285,13 +403,21 @@ static struct zswap_pool
> > > > > *zswap_pool_create(char *type, char *compressor)
> > > > > >  		goto error;
> > > > > >  	}
> > > > > >
> > > > > > -	for_each_possible_cpu(cpu)
> > > > > > -		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)-
> >mutex);
> > > > > > +	for_each_possible_cpu(cpu) {
> > > > > > +		struct crypto_acomp_ctx *acomp_ctx =3D
> per_cpu_ptr(pool-
> > > > > >acomp_ctx, cpu);
> > > > > > +
> > > > > > +		acomp_ctx->acomp =3D NULL;
> > > > > > +		acomp_ctx->req =3D NULL;
> > > > > > +		acomp_ctx->buffer =3D NULL;
> > > > > > +		acomp_ctx->__online =3D false;
> > > > > > +		acomp_ctx->nr_reqs =3D 0;
> > > > >
> > > > > Why is this needed? Wouldn't zswap_cpu_comp_prepare() initialize
> them
> > > > > right away?
> > > >
> > > > Yes, I figured this is needed for two reasons:
> > > >
> > > > 1) For the error handling in zswap_cpu_comp_prepare() and calls int=
o
> > > >     zswap_cpu_comp_dealloc() to be handled by the common procedure
> > > >     "acomp_ctx_dealloc()" unambiguously.
> > >
> > > This makes sense. When you move the refactoring to create
> > > acomp_ctx_dealloc() to a separate patch, please include this change i=
n
> > > it and call it out explicitly in the commit message.
> >
> > Sure.
> >
> > >
> > > > 2) The second scenario I thought of that would need this, is let's =
say
> > > >      the zswap compressor is switched immediately after setting the
> > > >      compressor. Some cores have executed the onlining code and
> > > >      some haven't. Because there are no pool refs held,
> > > >      zswap_cpu_comp_dealloc() would be called per-CPU. Hence, I
> figured
> > > >      it would help to initialize these acomp_ctx members before the
> > > >      hand-off to "cpuhp_state_add_instance()" in zswap_pool_create(=
).
> > >
> > > I believe cpuhp_state_add_instance() calls the onlining function
> > > synchronously on all present CPUs, so I don't think it's possible to =
end
> > > up in a state where the pool is being destroyed and some CPU executed
> > > zswap_cpu_comp_prepare() while others haven't.
> >
> > I looked at the cpuhotplug code some more. The startup callback is
> > invoked sequentially for_each_present_cpu(). If an error occurs for any
> > one of them, it calls the teardown callback only on the earlier cores t=
hat
> > have already finished running the startup callback. However,
> > zswap_cpu_comp_dealloc() will be called for all cores, even the ones
> > for which the startup callback was not run. Hence, I believe the
> > zero initialization is useful, albeit using alloc_percpu_gfp(__GFP_ZERO=
)
> > to allocate the acomp_ctx.
>=20
> Yeah this is point (1) above IIUC, and I agree about zero initialization
> for that.

Thanks. I will re-examine if zero initialization is required as part of the
simplification, if we think the latter makes sense.

>=20
> >
> > >
> > > That being said, this made me think of a different problem. If pool
> > > destruction races with CPU onlining, there could be a race between
> > > zswap_cpu_comp_prepare() allocating resources and
> > > zswap_cpu_comp_dealloc() (or acomp_ctx_dealloc()) freeing them.
> > >
> > > I believe we must always call cpuhp_state_remove_instance() *before*
> > > freeing the resources to prevent this race from happening. This needs=
 to
> > > be documented with a comment.
> >
> > Yes, this race condition is possible, thanks for catching this! The pro=
blem
> with
> > calling cpuhp_state_remove_instance() before freeing the resources is t=
hat
> > cpuhp_state_add_instance() and cpuhp_state_remove_instance() both
> > acquire a "mutex_lock(&cpuhp_state_mutex);" at the beginning; and hence
> > are serialized.
> >
> > For the reasons motivating why acomp_ctx->__online is set to false in
> > zswap_cpu_comp_dead(), I cannot call cpuhp_state_remove_instance()
> > before calling acomp_ctx_dealloc() because the latter could wait until
> > acomp_ctx->__online to be true before deleting the resources. I will
> > think about this some more.
>=20
> I believe this problem goes away with acomp_ctx->__online going away,
> right?

Yes, I don't think we need acomp_ctx->__online.

>=20
> >
> > Another possibility is to not rely on cpuhotplug in zswap, and instead
> > manage the per-cpu acomp_ctx resource allocation entirely in
> > zswap_pool_create(), and deletion entirely in zswap_pool_destroy(),
> > along with the necessary error handling. Let me think about this some
> > more as well.
> >
> > >
> > > Let me know if I missed something.
> > >
> > > >
> > > > Please let me know if these are valid considerations.
> > > >
> > > > >
> > > > > If it is in fact needed we should probably just use __GFP_ZERO.
> > > >
> > > > Sure. Are you suggesting I use "alloc_percpu_gfp()" instead of
> > > "alloc_percpu()"
> > > > for the acomp_ctx?
> > >
> > > Yeah if we need to initialize all/most fields to 0 let's use
> > > alloc_percpu_gfp() and pass GFP_KERNEL | __GFP_ZERO.
> >
> > Sounds good.
> >
> > >
> > > [..]
> > > > > > @@ -902,16 +957,52 @@ static struct crypto_acomp_ctx
> > > > > *acomp_ctx_get_cpu_lock(struct zswap_pool *pool)
> > > > > >
> > > > > >  	for (;;) {
> > > > > >  		acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
> > > > > > -		mutex_lock(&acomp_ctx->mutex);
> > > > > > -		if (likely(acomp_ctx->req))
> > > > > > -			return acomp_ctx;
> > > > > >  		/*
> > > > > > -		 * It is possible that we were migrated to a different
> CPU
> > > > > after
> > > > > > -		 * getting the per-CPU ctx but before the mutex was
> > > > > acquired. If
> > > > > > -		 * the old CPU got offlined, zswap_cpu_comp_dead()
> could
> > > > > have
> > > > > > -		 * already freed ctx->req (among other things) and
> set it to
> > > > > > -		 * NULL. Just try again on the new CPU that we
> ended up on.
> > > > > > +		 * If the CPU onlining code successfully allocates
> acomp_ctx
> > > > > resources,
> > > > > > +		 * it sets acomp_ctx->__online to true. Until this
> happens, we
> > > > > have
> > > > > > +		 * two options:
> > > > > > +		 *
> > > > > > +		 * 1. Return NULL and fail all stores on this CPU.
> > > > > > +		 * 2. Retry, until onlining has finished allocating
> resources.
> > > > > > +		 *
> > > > > > +		 * In theory, option 1 could be more appropriate,
> because it
> > > > > > +		 * allows the calling procedure to decide how it wants
> to
> > > > > handle
> > > > > > +		 * reclaim racing with CPU hotplug. For instance, it
> might be
> > > > > Ok
> > > > > > +		 * for compress to return an error for the backing
> swap device
> > > > > > +		 * to store the folio. Decompress could wait until we
> get a
> > > > > > +		 * valid and locked mutex after onlining has
> completed. For
> > > > > now,
> > > > > > +		 * we go with option 2 because adding a do-while in
> > > > > > +		 * zswap_decompress() adds latency for software
> > > > > compressors.
> > > > > > +		 *
> > > > > > +		 * Once initialized, the resources will be de-allocated
> only
> > > > > > +		 * when the pool is destroyed. The acomp_ctx will
> hold on to
> > > > > the
> > > > > > +		 * resources through CPU offlining/onlining at any
> time until
> > > > > > +		 * the pool is destroyed.
> > > > > > +		 *
> > > > > > +		 * This prevents races/deadlocks between reclaim
> and CPU
> > > > > acomp_ctx
> > > > > > +		 * resource allocation that are a dependency for
> reclaim.
> > > > > > +		 * It further simplifies the interaction with CPU
> onlining and
> > > > > > +		 * offlining:
> > > > > > +		 *
> > > > > > +		 * - CPU onlining does not take the mutex. It only
> allocates
> > > > > > +		 *   resources and sets __online to true.
> > > > > > +		 * - CPU offlining acquires the mutex before setting
> > > > > > +		 *   __online to false. If reclaim has acquired the
> mutex,
> > > > > > +		 *   offlining will have to wait for reclaim to complete
> before
> > > > > > +		 *   hotunplug can proceed. Further, hotplug merely
> sets
> > > > > > +		 *   __online to false. It does not delete the
> acomp_ctx
> > > > > > +		 *   resources.
> > > > > > +		 *
> > > > > > +		 * Option 1 is better than potentially not exiting the
> earlier
> > > > > > +		 * for (;;) loop because the system is running low on
> memory
> > > > > > +		 * and/or CPUs are getting offlined for whatever
> reason. At
> > > > > > +		 * least failing this store will prevent data loss by
> failing
> > > > > > +		 * zswap_store(), and saving the data in the backing
> swap
> > > > > device.
> > > > > >  		 */
> > > > >
> > > > > I believe we can dropped. I don't think we can have any store/loa=
d
> > > > > operations on a CPU before it's fully onlined, and we should alwa=
ys
> have
> > > > > a reference on the pool here, so the resources cannot go away.
> > > > >
> > > > > So unless I missed something we can drop this completely now and
> just
> > > > > hold the mutex directly in the load/store paths.
> > > >
> > > > Based on the above explanations, please let me know if it is a good=
 idea
> > > > to keep the __online, or if you think further simplification is pos=
sible.
> > >
> > > I still think it's not needed. Let me know if I missed anything.
> >
> > Let me think some more about whether it is feasible to not have cpuhotp=
lug
> > manage the acomp_ctx resource allocation, and instead have this be done
> > through the pool creation/deletion routines.
>=20
> I don't think this is necessary, see my comments above.

If the highlighted memory cost for non-batching compressors is acceptable,
I believe we can aim for a simplification.

Thanks,
Kanchana
