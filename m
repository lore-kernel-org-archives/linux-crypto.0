Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FB01C6F70;
	Mon,  4 Nov 2024 18:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730744954; cv=fail; b=RGUJCZqEoK/SnIvoqxjg1R3aoBdkJcHMFEs/C9bD989v8q7wu/AXqOwP41pRcplmmkgiXpHSlfacNJZ4OlEoZILyow0dNOMyu0XIxVwcw1Go+MWj4Feh3BYxcEReM20ubsib1sxfD4faNiLEtSOyuLIFdkQSZ0O9q/vNGIr0b+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730744954; c=relaxed/simple;
	bh=bk/a2M+YyTVGLklyPs0AkStQSEU3KsfdBmB1fp9rNHo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cF+gK83F9HiMKW9KiKD1le3MhRwX5Lam88hcSCssS8Sqa1sSPeZjPZB1dPVBej7206aNjoUePpUhk3hKxJKCEiQLcG2wvf2HaBPLYby54w/ZADoDZklkvMYiirwNiU2HFAxXc7TF8w3ckWPJ/lfcrbojVGAV5NuAeuOQ0s89j5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XkKx3Jw7; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XkKx3Jw7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730744951; x=1762280951;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bk/a2M+YyTVGLklyPs0AkStQSEU3KsfdBmB1fp9rNHo=;
  b=XkKx3Jw7LfYuAKb1gfnU1L2rBQhEUyVN4UivFvR+2DzIrOArZuw3uAVd
   2u1q1YUon6nuUPLGWOAsvDUKATvcN0lGAE9oMlXLovmQ9fNa3yKTcvZP3
   dpPchClQYRdlRkc/OqcJsxN25nalKWyd2zzDj08n/PIeF8ZGAFweIDUaT
   KrhhwpquCqHzbdy7gqzWELb20j/1oElAp7hbadhBgcTKA0b25cz4Fxjyw
   LH5R62RtRZkoiN9WPggTHFmLxW3NGSPFfkUJJJfYq7lO2+4gL8KlilfHu
   dTExNQ+4bjXcEVYsOH+PnODV7gkyB+OojQakw1Y90hWpSt32HagaoEVFm
   Q==;
X-CSE-ConnectionGUID: Qhj9v+08Q02V9Vl6POAZsw==
X-CSE-MsgGUID: nMbeTSPBQ66ts50nqpzGig==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30622422"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30622422"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 10:29:10 -0800
X-CSE-ConnectionGUID: gPJ/bsspTP2axq3TF3xgsQ==
X-CSE-MsgGUID: NrtKsBOlQj+Aa6iB0AE48Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="88882953"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 10:29:10 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 10:29:09 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 10:29:09 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 10:29:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lyaaV+ExDBCaR6xzcY9ZCsOFVEDgPAvIspT/YQBy5Y4srgsnKqvWo+FCoC/OLw4wP8LqZB2O74xV0ckurUf2i15y3doll+Dg4jkrh7udEkQ9+mirXFMMEbmBgsA4LuSPc4QKvujwrJvScHbzQgfdRjvUtyUM8zCOWZsxhn2QtPkizesgbmk1CLCkUgq1tCrlMOdUr8L1ih4OaUzWIiW5N5QQXRY5hIoZ0seBvq/Xr2qtUIFER+pz+fyzDikM3HkEHH4ufgTsl6z9gjv5ja3Hm4MGPcTnfHiTmDH47Fu//nZhP3tXy89gvq+ybHUZ61ePEv9fBsCwlTYJHLH9q6i7Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HyAqXXirxrEnL201+WXSWiFZ2subZ7fZux25g2ejZTE=;
 b=wx7MOPXI8iGrVYA2xRHSZZ3TovOMcaTHMVVlBln+jXex+QJUeZA1QrayJ3tEm02p87xs+1wxUikuPWqUre6Vvv5MqjdeFJgsjeEsWtzCTUBbeWpQOJk1dOn6jQEQoM8TBcmHUcw+AUxV8o8yO8CN3FgyCu9djFH1keiptB2FRINJ14F6DKIyBwBAOyVOAAVF1u5p0dMVpD+7kb+4+rJkriqV0f0v/sXLh5zZ+v32wLDpHAOiEKn2/EkLPlX0KEEB2SAy6rEOGVxPkNQouG8QbQjsQmurB6/PZzwkezXY0bYawdgeo8frC4R/iTRzSG6VGzz8xmbb3wKmZn/to00jfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by BN9PR11MB5260.namprd11.prod.outlook.com (2603:10b6:408:135::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Mon, 4 Nov
 2024 18:29:06 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8114.028; Mon, 4 Nov 2024
 18:29:06 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Dan Carpenter <dan.carpenter@linaro.org>, "oe-kbuild@lists.linux.dev"
	<oe-kbuild@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosryahmed@google.com"
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
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
CC: lkp <lkp@intel.com>, "oe-kbuild-all@lists.linux.dev"
	<oe-kbuild-all@lists.linux.dev>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: RE: [PATCH v2 13/13] mm: zswap: Compress batching with Intel IAA in
 zswap_store() of large folios.
Thread-Topic: [PATCH v2 13/13] mm: zswap: Compress batching with Intel IAA in
 zswap_store() of large folios.
Thread-Index: AQHbLZ9+ci0x3FTQ5E26KU1IJnhgwrKmzJGAgACll0A=
Date: Mon, 4 Nov 2024 18:29:06 +0000
Message-ID: <SJ0PR11MB5678990C825FE48D67D9B0C4C9512@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241103032111.333282-14-kanchana.p.sridhar@intel.com>
 <89728727-0fd2-4539-bc89-17a699d7179a@stanley.mountain>
In-Reply-To: <89728727-0fd2-4539-bc89-17a699d7179a@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|BN9PR11MB5260:EE_
x-ms-office365-filtering-correlation-id: 1f70954d-0230-44d3-0028-08dcfcfe911c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018|921020;
x-microsoft-antispam-message-info: =?us-ascii?Q?X3vSudW2vi7GTqyKHmY88R2/hwhupbF56paVEEDqo7dPeePNoX59Lr1C9TOM?=
 =?us-ascii?Q?1G65hkhDSSrQJGXTmEr388iC3OrFM5E2cuqg3gqy/fklWe23EcgWzmu25mVs?=
 =?us-ascii?Q?klNtNHGiKOKEPBuK65yLcBIPFWyDeRQETnZrOOZngZddP76d2Ls5tKkuy/DV?=
 =?us-ascii?Q?c7g8fEImCbbCQ3NzoZB4W5q6jbLg3sl8Jrg86W4eD+MKA0yL4tETgv5W/9qO?=
 =?us-ascii?Q?HJGhhMLB+uXsb0zfPSkI4xph23QuV50No5PvpcF//bNOPCm8RvqJ0M/pd2s5?=
 =?us-ascii?Q?V0gBhT/6OWijNwTfERF8UfRQxalJVnlDNNCI38qT0zOPlyxHQqkmyf6xP+8y?=
 =?us-ascii?Q?ZVhix4RrXdF5BFA5poGqpAdsLNA0RgCqNwroiHK479wGhG6lO3IF/4vPQrEw?=
 =?us-ascii?Q?UaiJXMNB04uT/YlSs624MPGbCuX2VQMRFs9F6U+JyUuVcMfUxKrVeWexgcBT?=
 =?us-ascii?Q?Duu09aT7MGxPSegbs1YG9C+1p6zoc/j0AUIw7dpWoBbtwM1TGCzwCKbjXZhH?=
 =?us-ascii?Q?1QzUzU6cQVHzrhJnYxrQiFj31DlUV84rQdmja1nhrjMm1HYpTas4lv3OpidJ?=
 =?us-ascii?Q?vXGa3c6nS8Ow1ukkvy37k+x2DSjye6fPDcA9I3ziUg2HYb1SWmlR7Jiv2iXo?=
 =?us-ascii?Q?u8NzH8JGCRm8s7VaSukIoS7cTh0oo8Gstp98d8RwpWz8IMlcWRWsWcJ5c+As?=
 =?us-ascii?Q?N2LWWtkhPs1jyeAoHYxQKRGp6O5sNUa4OTbcuzK9Mk5NpFj2gqIzT8HgUpS6?=
 =?us-ascii?Q?NuTKYG7HtUlzcAOyQPUgPDiNKMPDp7vW7T0FTyf82eh5iOyhTdeQ0a3uqWY4?=
 =?us-ascii?Q?6pfYv68HhE0PaVqnXe4klWkkftprdDg+lu1p6xee/Y0xphn15B32zFNoWsiI?=
 =?us-ascii?Q?XjNcVENYaC142tFHfr4csPPy4VJPF99ndDckTWuq7zwEjcve01ztxVhACU8k?=
 =?us-ascii?Q?T/4xHnOfY/YtTofPRYA0APeIaFv9qO/ZUUsc9yhjacSmhHb2RQxNMCvtiq/A?=
 =?us-ascii?Q?/M3p4BFg6rDs0VDmN1PvY/KyjYv7Pucjym/pPLuKvk+UDR3f0CakK4RsITqv?=
 =?us-ascii?Q?XoFUsSkHl7fcBiXnQNQoRWgGp60zXMfjkzEaTocevg50H0c2flC9ayhVp7zg?=
 =?us-ascii?Q?Eng3RLl4g9NJ45UE2/BK68TAn32ddCsB9ZCXeAQJLml6eh+by0173G8YDh0Z?=
 =?us-ascii?Q?w4dI8xY82zh2d1yRhVyHpUoY+B2Kr01VCYkF8IoMxuPHJPT/1zzxXzVEDxj3?=
 =?us-ascii?Q?2FJuZm6lXYsm/PpjLhE8r2G7gbhTaaDvUUJd845oMIKifOTuD8oUFSFlSE3e?=
 =?us-ascii?Q?e8hP2EWi2D5ZqMKTkszzaLzUem1Rv1JF4xVS4xyUgmeRpw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Uvhyo8Z8IINT4iJ2O9hlXyhq7RxRgyiXF9l6ug/gfwbAq5brjrN37i6YqEpj?=
 =?us-ascii?Q?aEC0clSYXozUH36FB4FtbAVgWIN8v7cGHQMIU54Sm7+pYbYkyKRgtcbRPOnR?=
 =?us-ascii?Q?yy5+xiQgA4DiPe4AErTnBjcEGtKqDmXuAXi2ZdSvsMfQh7z/JQFQksNvZTnp?=
 =?us-ascii?Q?qfw57OqjN4f9r/O415rWNZuLe0IDVZf9AU0hEsndgOOSkDuVsXX4tw76TIy8?=
 =?us-ascii?Q?Sb2jJP9ysvUrXDZBspNb3urovoiqMMxneWpDzyJ3+GnZlsiGpnxswlpjYMGC?=
 =?us-ascii?Q?zpt4W0dZfPv28laNbCJTyW2cWaxoOBgSRdkR+/O50Ozgxy+fUBy3sH36ID+Y?=
 =?us-ascii?Q?1upmZo3QxMcjby75jhpe/kPL3ERYgqhKWxQa9U+EnHChYuS8ePB2W+lXGRz2?=
 =?us-ascii?Q?l+4+FjQcIdGodyy9HJpqM8icPbmOFggCkmgCaS7CjL5Bbb2hkStD/Rs2nfT3?=
 =?us-ascii?Q?si0EgeEnxmnsIcZyx7ZH/oNDq0xEXZH7X+9TnAm6Js4vk1c5gpvV47evC5eW?=
 =?us-ascii?Q?XuhmaVkEb3gaD/IBwWUl2jXjweBpTtDFRbqTrdLbqwZYCprff0ygikOX1W1C?=
 =?us-ascii?Q?ivagRqB6zFerunZT9EJjyzRIq80QKhusFMzqGSfceuNUwSUHw8lBoZE6IsB6?=
 =?us-ascii?Q?2Xcc105Oz5BgxvDuGmhzrs9qxCkvgOSkW/YoGTgOJtZJ3peKL6St5RX1C3Av?=
 =?us-ascii?Q?MA06tfjTQKITXxfT3iDoNzDIDNOuDKSY4HOGU0Rz09K88lfXr9ko+Maf9y7f?=
 =?us-ascii?Q?RyuvMmdhE0qgHG04ID2dJeBxKMuWuzrZUFJpJntX7zAFikzbHCAlyf42usoe?=
 =?us-ascii?Q?h2FFTe5Xdh5pWvggDxsGnyQX9XeIOvMNVe+XsIuw39MLA8fNwwTR78dYbT3k?=
 =?us-ascii?Q?yb7jsCE8a0epD1foT6jVgFRj+6aIxv34RLuUa88Sjwl/af588liEfQrso1gb?=
 =?us-ascii?Q?esXJ2sb/nRXUyUskKdjbIdg4ECFsZUepLKHWR4/ezEkVTh5j3QHmlBYMJ9Br?=
 =?us-ascii?Q?vLEIcLHb16VzBiSNSv8xUs585ekTkM8FohTwKPnk4jnChPsbyJJr9Ee0NvCX?=
 =?us-ascii?Q?F/FZnNYq6Sne9PQx5O8EokzIWI2hRRV5cbca5KsFUskY+Nwun/q7sar5FHt7?=
 =?us-ascii?Q?MKXhewSw/xtj1mL+jsnlnYLuobpB8jqWlYPOV1CJTKKj3D60bdqSh3f9l5pb?=
 =?us-ascii?Q?vMjvvA1OQGW1spynQAahbwDTfva319CBeUoH+qHH/iu7c9/i+pMZbmAGfy5l?=
 =?us-ascii?Q?+bpclDvLPhG7vGyZS2jWKSoHh4aomDpSZyQboU1qf/LgS44zUQxugan7jguH?=
 =?us-ascii?Q?j11yPlMufE7aJisYYDveKCy/AIYfGO8XmMFCS7iqzg1Kv9vJDRc0fsDD7zGS?=
 =?us-ascii?Q?TDUFeAqCq8Hl4huVnFxH8JRF3dkkbfD4u79VVtwZk5sug+ECITAcNhM/sCHZ?=
 =?us-ascii?Q?jO5+WfP6ncts8mquWZMirBOjjUzfhW0/YxZEO91aqMl+b+UAMrQtap/ZI+kj?=
 =?us-ascii?Q?KgMAAwBmHrkYqhH8a8RJo9dr/ULTEZfZ3BujfayTgMDLNjZhXTGs60UE87iy?=
 =?us-ascii?Q?gE3EAz5lPvy3VcpjYIGyrjCYSwLCKOpZlGPQg8P4RzHL0yJskOHHncOqMKUQ?=
 =?us-ascii?Q?MA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f70954d-0230-44d3-0028-08dcfcfe911c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2024 18:29:06.5742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zqxgW0jzjLP20mMrTiSVVOVOMeG39L/cafnuCNBtzCNRpL0yEzuUm60/EYXaDfZZBOFfApw0cX9ndeqe/og1lRYVklR+8Uwv8derMfge9SE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5260
X-OriginatorOrg: intel.com

Hi Dan,

> -----Original Message-----
> From: Dan Carpenter <dan.carpenter@linaro.org>
> Sent: Monday, November 4, 2024 12:31 AM
> To: oe-kbuild@lists.linux.dev; Sridhar, Kanchana P
> <kanchana.p.sridhar@intel.com>; linux-kernel@vger.kernel.org; linux-
> mm@kvack.org; hannes@cmpxchg.org; yosryahmed@google.com;
> nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; Huang, Ying
> <ying.huang@intel.com>; 21cnbao@gmail.com; akpm@linux-foundation.org;
> linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; zanussi@kernel.org
> Cc: lkp <lkp@intel.com>; oe-kbuild-all@lists.linux.dev; Feghali, Wajdi K
> <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>;
> Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Subject: Re: [PATCH v2 13/13] mm: zswap: Compress batching with Intel IAA
> in zswap_store() of large folios.
>=20
> Hi Kanchana,
>=20
> kernel test robot noticed the following build warnings:
>=20
> url:    https://github.com/intel-lab-lkp/linux/commits/Kanchana-P-
> Sridhar/crypto-acomp-Define-two-new-interfaces-for-compress-decompress-
> batching/20241103-112337
> base:   5c4cf96cd70230100b5d396d45a5c9a332539d19
> patch link:    https://lore.kernel.org/r/20241103032111.333282-14-
> kanchana.p.sridhar%40intel.com
> patch subject: [PATCH v2 13/13] mm: zswap: Compress batching with Intel
> IAA in zswap_store() of large folios.
> config: x86_64-randconfig-161-20241104 (https://download.01.org/0day-
> ci/archive/20241104/202411040859.2z0MfFkR-lkp@intel.com/config)
> compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202411040859.2z0MfFkR-lkp@intel.com/
>=20
> smatch warnings:
> mm/zswap.c:1788 zswap_store_propagate_errors() warn: variable
> dereferenced before check 'sbp->entry' (see line 1785)
>=20
> vim +1788 mm/zswap.c
>=20
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1771  static
> __always_inline void zswap_store_propagate_errors(
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1772  	struct
> zswap_store_pipeline_state *zst,
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1773  	u8
> error_batch_idx)
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1774  {
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1775  	u8 i;
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1776
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1777  	if (zst-
> >errors[error_batch_idx])
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1778
> 	return;
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1779
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1780  	for (i =3D 0; i <
> zst->nr_comp_pages; ++i) {
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1781
> 	struct zswap_store_sub_batch_page *sbp =3D &zst->sub_batch[i];
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1782
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1783  		if
> (sbp->batch_idx =3D=3D error_batch_idx) {
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1784
> 	if (!sbp->error) {
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02 @1785
> 		if (!IS_ERR_VALUE(sbp->entry->handle))
>                                                                          =
                         ^^^^^^^^^^^^^^^^^^
> Dereferenced
>=20
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1786
> 			zpool_free(zst->pool->zpool, sbp->entry->handle);
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1787
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02 @1788
> 		if (sbp->entry) {
>                                                                          =
           ^^^^^^^^^^
> Checked too late

Thanks for pointing this out.  The implementation makes sure that all
sbp->entry values are valid before it gets to zswap_store_propagate_errors(=
).
That said, I agree, the sbp->entry check can be done earlier to make the
code more correct/readable. I will fix this in v3.

Thanks,
Kanchana

>=20
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1789
> 			zswap_entry_cache_free(sbp->entry);
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1790
> 			sbp->entry =3D NULL;
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1791
> 		}
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1792
> 		sbp->error =3D -EINVAL;
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1793
> 	}
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1794  		}
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1795  	}
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1796
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1797  	/*
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1798  	 * Set zswap
> status for the folio to "error"
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1799  	 * for use in
> swap_writepage.
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1800  	 */
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1801  	zst-
> >errors[error_batch_idx] =3D -EINVAL;
> c1252ac91d6a6a Kanchana P Sridhar 2024-11-02  1802  }
>=20
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

