Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F1027BF93
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 22:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741125606; cv=fail; b=Mu5aAZ8rulUAafjepbQNw6ETbtax1oNKKhidYK8xU+zn4YSmjQfXP57DF14ZBnOjpJFt9ry0IHVwDmvt9dRiZX0Ix0c0uiM8waBIWsdw6bQ8CtL8n4t/eUFw+E2Md4+pUQWvYoYkxVOBIsUzogK/EcQjufmTprHfvVxSvNKF7YU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741125606; c=relaxed/simple;
	bh=JmuYUmiaBmNzI2rP3xvn3VHrC5gQhJ4m892VkGhZFg4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EsoCvhgVLQYShfnIkCeHDsbpyxO3+lr2oFDQmvBidnDvUMc4YSpKIz03Fi9WnNG4soIkKKHUsYdvpCT1lD7CNMDPthwIbskGfXK1kRFandTsaJ4S7U/h54YqpGUNLtdBR+C05FWilbSpN2O4ho7uM6T6G7OAcoLYLxyvGDqi9zE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XpUODIFF; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XpUODIFF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741125603; x=1772661603;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JmuYUmiaBmNzI2rP3xvn3VHrC5gQhJ4m892VkGhZFg4=;
  b=XpUODIFFTESOEPywF1oIVAIINDXBPRX9dgjLHviOaZb1RXB8bOzmpXx5
   MjbQK/AFZyiRLGVKQjKFfcRjrAnR9nW/DCRhCqvzZ7Ll8o5kSO+fyy1cD
   oWkx7tcXRfAbp3iNuDFT1zJpKXyCUHfDj8mp3nv7dx170NqmpJXfWQG2G
   1JxVEij7sr5tILGGEdxgPdMWjV+oylc1hHcc3QAfCT/X+EHQ3x5DtyXsX
   tSCgCka75/LnQQEVepMOqmmSGB/5ON/O8iHqWx8R58VWpgUqjYHM5UXa8
   U02AFqKWGBLjBZ+PxXkemLopZojSl2gau2gTO7HL/X/M3lDm2ZashWpcv
   g==;
X-CSE-ConnectionGUID: fwFELam3QVGwZnUx2bGfRw==
X-CSE-MsgGUID: dUx+SLQ6R6O/XP2zpmbgQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="53465155"
X-IronPort-AV: E=Sophos;i="6.14,221,1736841600"; 
   d="scan'208";a="53465155"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 14:00:02 -0800
X-CSE-ConnectionGUID: Kmr8ZKA7Sg2uC1PisZVHfw==
X-CSE-MsgGUID: mZP3LkMtQyq9/JzEeRxXiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="119003081"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Mar 2025 14:00:03 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 4 Mar 2025 14:00:02 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 4 Mar 2025 14:00:02 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 4 Mar 2025 14:00:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ER2Xpa05p/HisjtP5/bdTqC/tCQZNyFo3ZjkhODOxx5idWDRC6jhOqXhiPZwnCv1kTlyIc3SH2iAC7hsqU3YQs7kbxw0R7Nr3cnbur9gawlRht4e2Yc+2Tx/I50ktGzLeUUZwjUmjIWrbhSjNnvd0as1GaOSWivYN4aRNjgv5Cqjp7eqTKu3fvD73qAxWgOJKgcSiTcWAvS1yH+te3MexIafU5wCPORTwxoXGN7OjyFrH08I6kepjV5NznWbQf3Nf/oBv3yHynkVSwwN3i/ZLGjhkV58Bw+JWbO99p4RRNiTYsjaBUZbOH0EsyBUNr6mCSoOt/lGhSAIunrAC78+pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOulJnG8YKTxDv2CQ6neeOJM7doNB422yHAeFTmN77s=;
 b=HVzhz2IJOhRaJTpUip+xl8c+kd6eYERvP+x1xh3uwfcYRZcNNDuOHJO3iICT+2LW35c4CkROYt103+kTOltuiGQh/YzqGR0pAfGcEnCnikExkPOlXU5UIXCU3PXMLoOgJ+0GG5rq+ofPlT9pME9upYps39M6sBqhzJ+HoR8nhZt9kObYi4E+FWj3eCq/FQhUwTKy0dlLF7J59D0Z//k5Qnu20NjrNEQE6/1T2v73xWXySYQSnE1D1x9wDH98Nf6WmDAa+jaKNK6tyCuIDGAb5VIGDg6qpmNR7LyscTYl8B8kWM1mkonFafcOe7jRQDVC7rSWjFIHOZMClKiGszPWOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by PH7PR11MB6748.namprd11.prod.outlook.com (2603:10b6:510:1b6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.26; Tue, 4 Mar
 2025 21:59:59 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%5]) with mapi id 15.20.8489.025; Tue, 4 Mar 2025
 21:59:59 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Linux Crypto Mailing List
	<linux-crypto@vger.kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, Yosry Ahmed
	<yosry.ahmed@linux.dev>, "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [v2 PATCH 3/7] crypto: acomp - Add request chaining and virtual
 addresses
Thread-Topic: [v2 PATCH 3/7] crypto: acomp - Add request chaining and virtual
 addresses
Thread-Index: AQHbjOdg2QrOh3WnyEqhsJpXglwgBbNje+sg
Date: Tue, 4 Mar 2025 21:59:59 +0000
Message-ID: <SA3PR11MB81203FD3D6638C0E1259E5DAC9C82@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <cover.1741080140.git.herbert@gondor.apana.org.au>
 <a11883ded326c4f4f80dcf0307ad05fd8e31abc7.1741080140.git.herbert@gondor.apana.org.au>
In-Reply-To: <a11883ded326c4f4f80dcf0307ad05fd8e31abc7.1741080140.git.herbert@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|PH7PR11MB6748:EE_
x-ms-office365-filtering-correlation-id: 80f7baf0-b69b-4139-f073-08dd5b67e839
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?3j7oVHdIi4JH9iZ+rdigXfgeIk1TsPPmLC90+B1c3UAar5gmGxD9jaUG74su?=
 =?us-ascii?Q?QGUxbv9NL5XAQH0FqSxWhgpMu0t4nFFTZV04dlq3SzdzaUrauh5981n/p82j?=
 =?us-ascii?Q?2oIwXnJvScsB3L8a+1gqD+mtQydmpJ3faYTCzcF1e2K+6eSAElnIgbJVt0px?=
 =?us-ascii?Q?BRRGBskO1Mm8FfjnqB52xVCzvgiRdtRBg44UqxYdTwjT8VJEQsH+/xK5EevP?=
 =?us-ascii?Q?TvVo4KlJvDmYWJs5SxlMS1o8dz10pTSesBOko+vYEXyZ4xl1Wz2wFe8LICQ2?=
 =?us-ascii?Q?0iGyqIRxsEsxKtau/kp2l+6erirEXNxnmbYh2Dq/2ToFJ0ROqpNrbG9eej6S?=
 =?us-ascii?Q?sAxrG+u90WTiLlWl4uXZI1IqH4yCDJb1kJ8Fw1Jymc6AjOhj09+R8xdJOgCi?=
 =?us-ascii?Q?TJOy37ZdNyBdVVLoOj77GN0fMfoc3M5mbWVBNp9acMaykD5816GhjBtdSTgB?=
 =?us-ascii?Q?nDtD1aLH7TLAk00xdadycFvloqyt+/HVclNCn/g3jtJPs07dNovn1YBa+R+L?=
 =?us-ascii?Q?YLgd28ACGJNm+zEtUwWcMHu+jL4ZCWYrozdcC5q7D0oBQKPPRzZqrckyTzcd?=
 =?us-ascii?Q?oKGpd2uFb1B+Stw4t3kpakdR698C9lB5J0LhvPlLvP41AJxW6cPcuPEA1knT?=
 =?us-ascii?Q?aA6nzKTw6na0mfC52sk+lLcALkShuk6g/meIXm2KkwSSTwVYHmJT08xXDQ3Z?=
 =?us-ascii?Q?/zmoRS8AoQidIkqjXwXH1t19vfHwtRyUgTulvA/+V3GHLOOQign78j5biNec?=
 =?us-ascii?Q?HFRTIL/XKof3R1L7JnF+RED8c0tHI9bEug5MVxOgyTul4L1twcChlHUmm+/i?=
 =?us-ascii?Q?cphVO/lHMhlDB3+B/ED7HEGBsk4jKhOtqRNvPeBpkFskM2KZfYWWodMm0UMB?=
 =?us-ascii?Q?hT3Qi/w480/EpDeWgKNiBPyEd3AbTrZoF1Yewfg2nETV2BwjqbpUMK79EuuH?=
 =?us-ascii?Q?9yB8v8jWcERRIopPHguX5jHGH82br7UA/VmGbmwxMZRy22cEN80SDm2dPzRc?=
 =?us-ascii?Q?Y2BMKBg9FasPvrxhyiwwJiQqk82QG77oKu4bus5wTryA0aDzpYUITR5+LzWj?=
 =?us-ascii?Q?vnXXYLaYIprq3s0z69VkTpy+YehYzQhx6fRnA9NwJtGdmiV2De5oVcFVMqrt?=
 =?us-ascii?Q?bseoPnEVy44nvRQaHW1rNzNDWNcvQ1DU0ZTp3uy3Jmp+nlYAPLovuxkOu8BQ?=
 =?us-ascii?Q?NY4OLzgLiM/s9e4TbyGZG3CmZTiHADVqUmbLqQhC8lW94DzyLoE+2upVEYT7?=
 =?us-ascii?Q?lnequ/RMRrpK0LLGburdRjN4Szc8cv6K4RP1IDWTGmWXlaB7E+tqoRbV2344?=
 =?us-ascii?Q?F9CJOeSC4eZRFVt4BbS3umGO0PYy55gz3NKij9RJB9QWTAVSmheT4wKZGw6J?=
 =?us-ascii?Q?KA9tMQYNoqkr+0G602nqJoze9CeKp+gh+0/aeJoMv1CJ+1INNlrww73k8/jb?=
 =?us-ascii?Q?8Wa8/syjtNV529A0N30IVjNcoAJ5FiK9?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4kU94w3y7qr20dhNt83gmMfux/JnXWYZCMqkoxGL10GmyimYX0W072j+D1yL?=
 =?us-ascii?Q?rM+WKjmHuuZMZTi8heOA0iRWd8wsGBQZ1VFehT+byhAgU+OIOGoSjdCezU4n?=
 =?us-ascii?Q?BctW3nNRsvlJb73E3PGof1JH8DPjbmDOIRHbC9QG89qf4vyo4O5Mk07ZwWzk?=
 =?us-ascii?Q?3/RYujMOrkfPr59StNONAIXkU/YjIOnCkUtQQU41a5/lYffaWCKfBCniNYjl?=
 =?us-ascii?Q?vAlHjn198phOaCBLjOEpSRhK1NsWuOczChSqnFCn9xTsFxxkIrhfaJiXAxki?=
 =?us-ascii?Q?Hdz4pIZLO6pxJ20rCGLKkrmuRVNmAjcK3VR7SQOHMkZyjtDBPA90G3GBmZhz?=
 =?us-ascii?Q?qHXCHpTXLSAY/mZhy2LmMCoHky4QPi2Veaa+T4JS8qx1Cz5e1lcTm2s/51qi?=
 =?us-ascii?Q?eknE4ELPrTi/gA2LxrUIlM9rkM2MjKsgyBevJq9jyV/g4Gnhz5SWO6wr7AkB?=
 =?us-ascii?Q?jCvdinglLKeyvB9he7nI0o2cUD3bW6hsaczWb1wwuUVUu3RM11n7yii1msSg?=
 =?us-ascii?Q?RCI98F/jooWNgmGTsTxqpqjO6CMonZr46h8+Q00VIIeIGlTNzl0p2ZzBJP6x?=
 =?us-ascii?Q?N4k4YsUWLUxtuRMRKaxS4KEyJY/wsvOklpxgyFrkObLM04SbUxVWwgnKW66b?=
 =?us-ascii?Q?mWTyHF4zZCpT4f+KA7kk8kDaVCQg0GHhJ+JvRnxQGDAxafvsJY9CqfIgI9II?=
 =?us-ascii?Q?ogKW24EaJcGbE/eIUJSaozBaGDZ/8cLSoyVvVQofYG87VYX0YvPeZM5UBwcj?=
 =?us-ascii?Q?wVV1835Thx12RLkM7Eb+ShT8XhZ0AT5p3Q3QA22r3zhGWJmI+ZKnY7/SnL/Q?=
 =?us-ascii?Q?PW7PByIrO/PCR5+J+kNbAEGTHg5dPVzVyTgfUbj1O0iWskvUnXMJfWiEJOmc?=
 =?us-ascii?Q?ENTRf8I0zhHKmdMpGPYxDXrybpd32aQnuhCeujaut+DF47AfL4KWwVO7j15r?=
 =?us-ascii?Q?DfXC6GRVE37xsGpnAUh4aqyOwDVKiJ7c5RycOp7zDze4Y1G5Dkvu8gdwtUpS?=
 =?us-ascii?Q?WnMK364gZ6SRX8P/RHqgpqtBAFr92qn75tqAJTQuYBzL6GvaUqrNVMf/uKuv?=
 =?us-ascii?Q?UBENLS3xMl2IF4B3tU3Asn6WtY3Vb6fsuFsneAcGXeAlL/XA9/fx39/+YFYc?=
 =?us-ascii?Q?ah68O63r1dHCuu36ezXl7mamarPlJuyPIIJe7Cb/ycK44/3eA9acxkdzJSuw?=
 =?us-ascii?Q?Axv2j9eL5zN3RkO1/kg8dr0U7mmtbnOHnTAfuPyRVPEVNGyYFojb5Pu84+1b?=
 =?us-ascii?Q?VFDoXapo3ofhOuMQ1eHJmNQmzngrUEkoavecedc8U747stImw+v98iRn+7O1?=
 =?us-ascii?Q?2IyIiCNu6dRHwqN1lPaB7KM387MXYTVBYQYamkBqKX7Or9LYwl5qv50yfRXs?=
 =?us-ascii?Q?eGa/GirgqtCSVsu0Ps5h1aycjw1cDGBaEdP7Pbt+xa/Ve6iZK7Hr+MZKmCyt?=
 =?us-ascii?Q?AnkS1qVDvDrhiR5uvciNDQo4BWJdUUJHF8frHaePsJW60/UqvPxqpa8dGocY?=
 =?us-ascii?Q?91xca133UX4Uy5dxNhZl8Mv1xd2LXl7u6B4U3xd/l1A8wW+UB2pfSzIoRY/F?=
 =?us-ascii?Q?x9f0jK/G4yaiE7KBseqvFqhVSCRUzSnaJ4R20VIe8kH7jTovWnJ8E0AhRQJB?=
 =?us-ascii?Q?4g=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f7baf0-b69b-4139-f073-08dd5b67e839
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2025 21:59:59.2317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ieXppVwuO/c2NIiYmaYV9cXTYUkobc5WLywTDS5CjjOVmWqdEpHnhmrIQlPXQuldiUS3W7x78iW29sompL2mPLYzy3y0VDPHG2CP4E1qruw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6748
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Tuesday, March 4, 2025 1:25 AM
> To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
> Cc: linux-mm@kvack.org; Yosry Ahmed <yosry.ahmed@linux.dev>; Sridhar,
> Kanchana P <kanchana.p.sridhar@intel.com>
> Subject: [v2 PATCH 3/7] crypto: acomp - Add request chaining and virtual
> addresses
>=20
> This adds request chaining and virtual address support to the
> acomp interface.
>=20
> It is identical to the ahash interface, except that a new flag
> CRYPTO_ACOMP_REQ_NONDMA has been added to indicate that the
> virtual addresses are not suitable for DMA.  This is because
> all existing and potential acomp users can provide memory that
> is suitable for DMA so there is no need for a fall-back copy
> path.
>=20
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  crypto/acompress.c                  | 201 ++++++++++++++++++++++++++++
>  include/crypto/acompress.h          |  89 ++++++++++--
>  include/crypto/internal/acompress.h |  22 +++
>  3 files changed, 299 insertions(+), 13 deletions(-)
>=20
> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index 30176316140a..d2103d4e42cc 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -23,6 +23,8 @@ struct crypto_scomp;
>=20
>  static const struct crypto_type crypto_acomp_type;
>=20
> +static void acomp_reqchain_done(void *data, int err);
> +
>  static inline struct acomp_alg *__crypto_acomp_alg(struct crypto_alg *al=
g)
>  {
>  	return container_of(alg, struct acomp_alg, calg.base);
> @@ -153,6 +155,205 @@ void acomp_request_free(struct acomp_req *req)
>  }
>  EXPORT_SYMBOL_GPL(acomp_request_free);
>=20
> +static bool acomp_request_has_nondma(struct acomp_req *req)
> +{
> +	struct acomp_req *r2;
> +
> +	if (acomp_request_isnondma(req))
> +		return true;
> +
> +	list_for_each_entry(r2, &req->base.list, base.list)
> +		if (acomp_request_isnondma(r2))
> +			return true;
> +
> +	return false;
> +}
> +
> +static void acomp_save_req(struct acomp_req *req, crypto_completion_t
> cplt)
> +{
> +	struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);
> +	struct acomp_req_chain *state =3D &req->chain;
> +
> +	if (!acomp_is_async(tfm))
> +		return;
> +
> +	state->compl =3D req->base.complete;
> +	state->data =3D req->base.data;
> +	req->base.complete =3D cplt;
> +	req->base.data =3D state;
> +	state->req0 =3D req;
> +}
> +
> +static void acomp_restore_req(struct acomp_req_chain *state)
> +{
> +	struct acomp_req *req =3D state->req0;
> +	struct crypto_acomp *tfm;
> +
> +	tfm =3D crypto_acomp_reqtfm(req);
> +	if (!acomp_is_async(tfm))
> +		return;
> +
> +	req->base.complete =3D state->compl;
> +	req->base.data =3D state->data;
> +}
> +
> +static void acomp_reqchain_virt(struct acomp_req_chain *state, int err)
> +{
> +	struct acomp_req *req =3D state->cur;
> +	unsigned int slen =3D req->slen;
> +	unsigned int dlen =3D req->dlen;
> +
> +	req->base.err =3D err;
> +	if (!state->src)
> +		return;
> +
> +	acomp_request_set_virt(req, state->src, state->dst, slen, dlen);
> +	state->src =3D NULL;
> +}
> +
> +static int acomp_reqchain_finish(struct acomp_req_chain *state,
> +				 int err, u32 mask)
> +{
> +	struct acomp_req *req0 =3D state->req0;
> +	struct acomp_req *req =3D state->cur;
> +	struct acomp_req *n;
> +
> +	acomp_reqchain_virt(state, err);

Unless I am missing something, this seems to be future-proofing, based
on the initial checks you've implemented in acomp_do_req_chain().

> +
> +	if (req !=3D req0)
> +		list_add_tail(&req->base.list, &req0->base.list);
> +
> +	list_for_each_entry_safe(req, n, &state->head, base.list) {
> +		list_del_init(&req->base.list);
> +
> +		req->base.flags &=3D mask;
> +		req->base.complete =3D acomp_reqchain_done;
> +		req->base.data =3D state;
> +		state->cur =3D req;
> +
> +		if (acomp_request_isvirt(req)) {
> +			unsigned int slen =3D req->slen;
> +			unsigned int dlen =3D req->dlen;
> +			const u8 *svirt =3D req->svirt;
> +			u8 *dvirt =3D req->dvirt;
> +
> +			state->src =3D svirt;
> +			state->dst =3D dvirt;
> +
> +			sg_init_one(&state->ssg, svirt, slen);
> +			sg_init_one(&state->dsg, dvirt, dlen);
> +
> +			acomp_request_set_params(req, &state->ssg,
> &state->dsg,
> +						 slen, dlen);
> +		}
> +
> +		err =3D state->op(req);
> +
> +		if (err =3D=3D -EINPROGRESS) {
> +			if (!list_empty(&state->head))
> +				err =3D -EBUSY;
> +			goto out;
> +		}
> +
> +		if (err =3D=3D -EBUSY)
> +			goto out;

This is a fully synchronous way of processing the request chain, and
will not work for iaa_crypto's submit-then-poll-for-completions paradigm,
essential for us to process the compressions in parallel in hardware.
Without parallelism, we will not derive the full benefits of IAA.

Would you be willing to incorporate the acomp_do_async_req_chain()
that I have implemented in v8 of my patch-series [1], to enable the iaa_cry=
pto
driver's async way of processing the request chain to get the parallelism,
and/or adapt your implementation to enable this?

Better still, if you agree that the virtual address support is entirely fut=
ure-proofing,
I would like to request you to consider reviewing and improving my well-val=
idated
implementation of request chaining in [1], with the goal of merging it in w=
ith
parallel/series support for the reqchain, and introduce virtual address sup=
port
at a later time.=20

[1] https://patchwork.kernel.org/project/linux-mm/patch/20250303084724.6490=
-2-kanchana.p.sridhar@intel.com/


> +
> +		acomp_reqchain_virt(state, err);

Is this really needed? From what I can understand, the important thing this
call does for the implementation, is to set the req->base.err. It seems lik=
e
compute overhead (which matters for kernel users like zswap) for setting
the request's error status.

In general, the calls to virtual address support are a bit confusing, since=
 you
check right upfront in acomp_do_req_chain()
"if (acomp_request_has_nondma(req)) return -EINVAL".

Imo, it appears that this is all we need until there are in kernel users th=
at
require the virtual address future-proofing. Please correct me if I am miss=
ing
something significant.

Also, is my understanding correct that zswap code that sets up the SG lists
for compress/decompress are not impacted by this?


> +		list_add_tail(&req->base.list, &req0->base.list);
> +	}
> +
> +	acomp_restore_req(state);
> +
> +out:
> +	return err;
> +}
> +
> +static void acomp_reqchain_done(void *data, int err)
> +{
> +	struct acomp_req_chain *state =3D data;
> +	crypto_completion_t compl =3D state->compl;
> +
> +	data =3D state->data;
> +
> +	if (err =3D=3D -EINPROGRESS) {
> +		if (!list_empty(&state->head))
> +			return;
> +		goto notify;
> +	}
> +
> +	err =3D acomp_reqchain_finish(state, err,
> CRYPTO_TFM_REQ_MAY_BACKLOG);
> +	if (err =3D=3D -EBUSY)
> +		return;
> +
> +notify:
> +	compl(data, err);
> +}
> +
> +static int acomp_do_req_chain(struct acomp_req *req,
> +			      int (*op)(struct acomp_req *req))
> +{
> +	struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);
> +	struct acomp_req_chain *state =3D &req->chain;
> +	int err;
> +
> +	if (crypto_acomp_req_chain(tfm) ||
> +	    (!acomp_request_chained(req) && !acomp_request_isvirt(req)))
> +		return op(req);

Isn't this a bug? If an algorithm opts-in and sets CRYPTO_ALG_REQ_CHAIN
in its cra_flags, the above statement will always be true, the "op" will be
called on the first request, and this will return. Am I missing something?

> +
> +	/*
> +	 * There are no in-kernel users that do this.  If and ever
> +	 * such users come into being then we could add a fall-back
> +	 * path.
> +	 */
> +	if (acomp_request_has_nondma(req))
> +		return -EINVAL;

As mentioned earlier, is this sufficient for now, and is the virtual addres=
s
support really future-proofing?

> +
> +	if (acomp_is_async(tfm)) {
> +		acomp_save_req(req, acomp_reqchain_done);
> +		state =3D req->base.data;
> +	}
> +
> +	state->op =3D op;
> +	state->cur =3D req;
> +	state->src =3D NULL;
> +	INIT_LIST_HEAD(&state->head);
> +	list_splice_init(&req->base.list, &state->head);
> +
> +	if (acomp_request_isvirt(req)) {

Based on the above check for acomp_request_has_nondma(), it should never
get here, IIUC?

In general, can you shed some light on how you envision zswap code to
change based on this patchset?

Thanks,
Kanchana

> +		unsigned int slen =3D req->slen;
> +		unsigned int dlen =3D req->dlen;
> +		const u8 *svirt =3D req->svirt;
> +		u8 *dvirt =3D req->dvirt;
> +
> +		state->src =3D svirt;
> +		state->dst =3D dvirt;
> +
> +		sg_init_one(&state->ssg, svirt, slen);
> +		sg_init_one(&state->dsg, dvirt, dlen);
> +
> +		acomp_request_set_params(req, &state->ssg, &state->dsg,
> +					 slen, dlen);
> +	}
> +
> +	err =3D op(req);
> +	if (err =3D=3D -EBUSY || err =3D=3D -EINPROGRESS)
> +		return -EBUSY;
> +
> +	return acomp_reqchain_finish(state, err, ~0);
> +}
> +
> +int crypto_acomp_compress(struct acomp_req *req)
> +{
> +	return acomp_do_req_chain(req, crypto_acomp_reqtfm(req)-
> >compress);
> +}
> +EXPORT_SYMBOL_GPL(crypto_acomp_compress);
> +
> +int crypto_acomp_decompress(struct acomp_req *req)
> +{
> +	return acomp_do_req_chain(req, crypto_acomp_reqtfm(req)-
> >decompress);
> +}
> +EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
> +
>  void comp_prepare_alg(struct comp_alg_common *alg)
>  {
>  	struct crypto_alg *base =3D &alg->base;
> diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
> index b6d5136e689d..15bb13e47f8b 100644
> --- a/include/crypto/acompress.h
> +++ b/include/crypto/acompress.h
> @@ -12,10 +12,34 @@
>  #include <linux/atomic.h>
>  #include <linux/container_of.h>
>  #include <linux/crypto.h>
> +#include <linux/scatterlist.h>
> +#include <linux/types.h>
>=20
>  #define CRYPTO_ACOMP_ALLOC_OUTPUT	0x00000001
> +
> +/* Set this bit for virtual address instead of SG list. */
> +#define CRYPTO_ACOMP_REQ_VIRT		0x00000002
> +
> +/* Set this bit for if virtual address buffer cannot be used for DMA. */
> +#define CRYPTO_ACOMP_REQ_NONDMA		0x00000004
> +
>  #define CRYPTO_ACOMP_DST_MAX		131072
>=20
> +struct acomp_req;
> +
> +struct acomp_req_chain {
> +	struct list_head head;
> +	struct acomp_req *req0;
> +	struct acomp_req *cur;
> +	int (*op)(struct acomp_req *req);
> +	crypto_completion_t compl;
> +	void *data;
> +	struct scatterlist ssg;
> +	struct scatterlist dsg;
> +	const u8 *src;
> +	u8 *dst;
> +};
> +
>  /**
>   * struct acomp_req - asynchronous (de)compression request
>   *
> @@ -24,14 +48,24 @@
>   * @dst:	Destination data
>   * @slen:	Size of the input buffer
>   * @dlen:	Size of the output buffer and number of bytes produced
> + * @chain:	Private API code data, do not use
>   * @__ctx:	Start of private context data
>   */
>  struct acomp_req {
>  	struct crypto_async_request base;
> -	struct scatterlist *src;
> -	struct scatterlist *dst;
> +	union {
> +		struct scatterlist *src;
> +		const u8 *svirt;
> +	};
> +	union {
> +		struct scatterlist *dst;
> +		u8 *dvirt;
> +	};
>  	unsigned int slen;
>  	unsigned int dlen;
> +
> +	struct acomp_req_chain chain;
> +
>  	void *__ctx[] CRYPTO_MINALIGN_ATTR;
>  };
>=20
> @@ -200,10 +234,14 @@ static inline void
> acomp_request_set_callback(struct acomp_req *req,
>  					      crypto_completion_t cmpl,
>  					      void *data)
>  {
> +	u32 keep =3D CRYPTO_ACOMP_ALLOC_OUTPUT |
> CRYPTO_ACOMP_REQ_VIRT;
> +
>  	req->base.complete =3D cmpl;
>  	req->base.data =3D data;
> -	req->base.flags &=3D CRYPTO_ACOMP_ALLOC_OUTPUT;
> -	req->base.flags |=3D flgs & ~CRYPTO_ACOMP_ALLOC_OUTPUT;
> +	req->base.flags &=3D keep;
> +	req->base.flags |=3D flgs & ~keep;
> +
> +	crypto_reqchain_init(&req->base);
>  }
>=20
>  /**
> @@ -230,11 +268,42 @@ static inline void
> acomp_request_set_params(struct acomp_req *req,
>  	req->slen =3D slen;
>  	req->dlen =3D dlen;
>=20
> -	req->base.flags &=3D ~CRYPTO_ACOMP_ALLOC_OUTPUT;
> +	req->base.flags &=3D ~(CRYPTO_ACOMP_ALLOC_OUTPUT |
> CRYPTO_ACOMP_REQ_VIRT);
>  	if (!req->dst)
>  		req->base.flags |=3D CRYPTO_ACOMP_ALLOC_OUTPUT;
>  }
>=20
> +/**
> + * acomp_request_set_virt() -- Sets virtual address request parameters
> + *
> + * Sets virtual address parameters required by an acomp operation
> + *
> + * @req:	asynchronous compress request
> + * @src:	virtual address pointer to input buffer
> + * @dst:	virtual address pointer to output buffer.
> + * @slen:	size of the input buffer
> + * @dlen:	size of the output buffer.
> + */
> +static inline void acomp_request_set_virt(struct acomp_req *req,
> +					  const u8 *src, u8 *dst,
> +					  unsigned int slen,
> +					  unsigned int dlen)
> +{
> +	req->svirt =3D src;
> +	req->dvirt =3D dst;
> +	req->slen =3D slen;
> +	req->dlen =3D dlen;
> +
> +	req->base.flags &=3D ~CRYPTO_ACOMP_ALLOC_OUTPUT;
> +	req->base.flags |=3D CRYPTO_ACOMP_REQ_VIRT;
> +}
> +
> +static inline void acomp_request_chain(struct acomp_req *req,
> +				       struct acomp_req *head)
> +{
> +	crypto_request_chain(&req->base, &head->base);
> +}
> +
>  /**
>   * crypto_acomp_compress() -- Invoke asynchronous compress operation
>   *
> @@ -244,10 +313,7 @@ static inline void acomp_request_set_params(struct
> acomp_req *req,
>   *
>   * Return:	zero on success; error code in case of error
>   */
> -static inline int crypto_acomp_compress(struct acomp_req *req)
> -{
> -	return crypto_acomp_reqtfm(req)->compress(req);
> -}
> +int crypto_acomp_compress(struct acomp_req *req);
>=20
>  /**
>   * crypto_acomp_decompress() -- Invoke asynchronous decompress
> operation
> @@ -258,9 +324,6 @@ static inline int crypto_acomp_compress(struct
> acomp_req *req)
>   *
>   * Return:	zero on success; error code in case of error
>   */
> -static inline int crypto_acomp_decompress(struct acomp_req *req)
> -{
> -	return crypto_acomp_reqtfm(req)->decompress(req);
> -}
> +int crypto_acomp_decompress(struct acomp_req *req);
>=20
>  #endif
> diff --git a/include/crypto/internal/acompress.h
> b/include/crypto/internal/acompress.h
> index 8831edaafc05..b3b48dea7f2f 100644
> --- a/include/crypto/internal/acompress.h
> +++ b/include/crypto/internal/acompress.h
> @@ -109,4 +109,26 @@ void crypto_unregister_acomp(struct acomp_alg
> *alg);
>  int crypto_register_acomps(struct acomp_alg *algs, int count);
>  void crypto_unregister_acomps(struct acomp_alg *algs, int count);
>=20
> +static inline bool acomp_request_chained(struct acomp_req *req)
> +{
> +	return crypto_request_chained(&req->base);
> +}
> +
> +static inline bool acomp_request_isvirt(struct acomp_req *req)
> +{
> +	return req->base.flags & CRYPTO_ACOMP_REQ_VIRT;
> +}
> +
> +static inline bool acomp_request_isnondma(struct acomp_req *req)
> +{
> +	return (req->base.flags &
> +		(CRYPTO_ACOMP_REQ_NONDMA |
> CRYPTO_ACOMP_REQ_VIRT)) =3D=3D
> +	       (CRYPTO_ACOMP_REQ_NONDMA |
> CRYPTO_ACOMP_REQ_VIRT);
> +}
> +
> +static inline bool crypto_acomp_req_chain(struct crypto_acomp *tfm)
> +{
> +	return crypto_tfm_req_chain(&tfm->base);
> +}
> +
>  #endif
> --
> 2.39.5

