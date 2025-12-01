Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36389337BB3;
	Mon,  1 Dec 2025 17:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764610120; cv=fail; b=T27q2jP95pMj6t4YuQwOxTno1srZDYUeCIqYF2AVs8gCyniplP4nEQj6JfLsbYg5Zo71ZRKDLF9YEXydVq7t/mnklAle70dDOZ+KhCcZfsCjWidDjbPGRlu2IQOtRombm9mAECgw0Rmq+7yMYFFox6/kIvRMYSHhJ/ILom0YKBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764610120; c=relaxed/simple;
	bh=x8C1xptlxKbWHQ3xSAJeUIxXqMIbQ1wspfezefjdgAc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=izO9ZLO1ADBr9AbD2s/Rb+HwFsD9DZDSlQNpSGU5fuHDPhFNF5M9D9mSdC4Lg6RLOOjeCH//+xzFjPQA/5Jw7NBfbn9OSH1e028FBT+hNFUnMhPOi6NvJmC8/0zmvAZdGmBiNhLakyrBW9zeR5UDEP6w1aX/WcKVUkTMOaljbFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MRIwtvdP; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MRIwtvdP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764610118; x=1796146118;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x8C1xptlxKbWHQ3xSAJeUIxXqMIbQ1wspfezefjdgAc=;
  b=MRIwtvdPGuvqCRzoY51kjXD6uy8CMSkW4O8GYf75yYESxQB1hVOH8lGc
   UypIPuwgdQMf1Tyef6xi6w/YrjKDmDcOLkCGAosge9ArPLDkZe4bh2+JC
   kamU49jeIuqZGJVKvPVeakajRbG4++XTiGtr/UsxQSdRM9hXzMrwIVUoF
   EyrXFXPOkBhSMToTGi0Y66nyvxPfqbewU81qUAbvTYtEubhz+86ocLGLU
   tX5W45aZq0OPafeC9B8s53usc7iWJ7RIbZL2KgUNeddRzqu2pzPfdkh8f
   hqcylwmCNFUKwRFLZnDDQ/ZTIYXTz5XP5rZapX9NJPUEGqVlQPSTZuJT3
   Q==;
X-CSE-ConnectionGUID: ZfmcbSxdQXCsKUX5O3z81A==
X-CSE-MsgGUID: QX6LcydUR/qzd+kdCqzv6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66451579"
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="66451579"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 09:28:37 -0800
X-CSE-ConnectionGUID: FV++I5g5Q3CFJDld3iCoxA==
X-CSE-MsgGUID: rLe0rZ5BRquPCW2ZD1KoxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="231440578"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 09:28:37 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 09:28:36 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 1 Dec 2025 09:28:36 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.66) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 09:28:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gxDZRo8k1O6Y129FSfazW2+1QV4dvRcYrRqLI+ymWs+IU8wJsBNJTu+MIQxpJl6OQE7RNsxWBL/JUCABCNaoJ8SKFwZ9F4CXNZTEOos6Hq/yuGH6l/mWx8JSXhI+6DBzokD1AmUUI/1CLX2eHCcsE8O0RS0kSrbe3itHzDGznQwrOCXCgMcCM09YLq4jFc+C72WaPtikc9TZBkk6XX9R2yPahywu/3WbpoA+ZH+Igkucfhmb08nlmF+r6cb9I9gvpP3NaDIfrzC+CdWUHZaBdNIWXQZYvvgn12LlsDcyYVWtqTbCfJy++psf1S6F3+O0MiKlSFXAWbeo6GYR426xNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hwz//UMKcmLZx2joXsPd+8emCbjx2Qc48n+MCtgrllI=;
 b=NXHeLGttfw+J4ZOlmWAFOzLaRBamoEqdpHusUl8+0nWkW2JDU1jfTceLi4/Ih6ciiA5tmbqs4/uRh53JdcMbD76xHsy22o4uwidXlOxcjYaI83Ad0KP/GU2S9awZ+KphyeJr5L02WAR8fmNn+uYO+fRloOfpAsxpn+ocH7ko+Y2HUK0C1v1R1AunOubWLcJGmxveGlTyB2EhyY0q+WzWUnpdEngWYNyxhvp1vDKRDKU4NZoiFU9XcuKm362CoYfNaAs1UFQnMw27pfhoGqfgpZtFB3Y1y1kosNMtW7yAtqS6WSu+uCL7x6sLJYGNOiH/hBp28a4uOLc240C58y6lJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by SJ2PR11MB7620.namprd11.prod.outlook.com (2603:10b6:a03:4d1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 17:28:34 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 17:28:34 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Tom Zanussi <tom.zanussi@linux.intel.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Sridhar,
 Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH] crypto: iaa - Fix out-of-bounds index in
 find_empty_iaa_compression_mode
Thread-Topic: [PATCH] crypto: iaa - Fix out-of-bounds index in
 find_empty_iaa_compression_mode
Thread-Index: AQHcX6aBg8akqeBrFku/pgsyswWMSrUND88w
Date: Mon, 1 Dec 2025 17:28:33 +0000
Message-ID: <SJ2PR11MB8472AE5C88DC7F651DAF944CC9DBA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251127140158.173840-1-thorsten.blum@linux.dev>
In-Reply-To: <20251127140158.173840-1-thorsten.blum@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|SJ2PR11MB7620:EE_
x-ms-office365-filtering-correlation-id: 9ec0d78d-e91a-44ab-0c48-08de30ff0dd3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?UBHlYcHYKJRSgCQzEwdzzN4ukGfr9USdZRtIC8nY9TUODjxxZ7F7/NEb9A0N?=
 =?us-ascii?Q?D6waokhvf4r7lJmhUlE37OiFkhI7qvVylbP6+FQ+IiYI7ivkU9GILf/o/wsQ?=
 =?us-ascii?Q?tJoUa+/Mojbr/hC/NS2ALhRlWpHdsv83M9LFcbkcG9IycSTuJKJQEMn2It7H?=
 =?us-ascii?Q?jdQFnv6DEmLveAJZiyrihKGirKdaVztoL47yGByvWCpxcFAgPK0mag5F88TW?=
 =?us-ascii?Q?Ldo+Cf2WmnE18VJVOkyyG70HmL6xCyX6ndFgwGJLmeIwVVbdXHYPsLec4e9o?=
 =?us-ascii?Q?o62L8iDwDVeZYWZ7eZ10X5LvsU8FH2O//kmSJWT/u0OLQSN6btKLNr0DVe0C?=
 =?us-ascii?Q?0ve6HZ0Jne7UKKdNypzWcGdD8MsqEGAGwTSEDk1qQAH1eigDjDvVenIzTvfQ?=
 =?us-ascii?Q?5e4MbYe2uyFoGBhzAiEXea7YwwG5AkLmZOZxUzRoaCpl8ki/Bsngri+FORJd?=
 =?us-ascii?Q?nn5z2sfRa6waQ5pD/xuhDcAewoZ9qi9+ccNLD2G+TXv3Pw6ErPK+k6VhtHOT?=
 =?us-ascii?Q?WPdWdAa00jxe7YBnVnfov9qLZ38cOQ2B3u0h4XkvNwwBGpQjm0eGXGE+989j?=
 =?us-ascii?Q?NyHlJiTyUV1FY2UFhjmChnhwCjwQB+7KiskoqKEvSkgQMGx/MWXKymvGM24y?=
 =?us-ascii?Q?gDQf3u9vsLV1w3dXjjUo1Hzwu+eblr7eqYxQQj+yHxXpZadVlF5h6Ya6tPDu?=
 =?us-ascii?Q?C52TJAptL+oqJizQKphlu6Zqmk4+gqKet+1JtrZsxX4tKJwuOeNalPdrBgOP?=
 =?us-ascii?Q?wtjc0FY3Un8z2vRaT29r2E/zNKQ+QTdOILPODC9nas+CQZQ/K7+mDhGGRxJ+?=
 =?us-ascii?Q?NfAMj7kyjKzOKeCs7V2wbUDjXxY1jBOP/P/x7/0bC+x3KSgj8u3yjzSn/66c?=
 =?us-ascii?Q?g5IpqIxeMenXHfJsfF6rZb0nJZCIes5fnE71FlnZYw2dq+tmDpzGzOzu7bg0?=
 =?us-ascii?Q?zkPJw/8/sD5tdlgVo/sEwE4xjd5EEF5zDioxqay/JjIY5qe3zt9DockViA10?=
 =?us-ascii?Q?MTRn5iWV0IK+h0LBh3sUrwlstFjawWTg5EJSpqBgFl/2j3cj+4iykNpHQQ8C?=
 =?us-ascii?Q?MuMuDQ5l03CymN8S1ck1AZkrNim0XSeHjlX/gOXXBjBMmjL44fJwubOEJebB?=
 =?us-ascii?Q?WmGuuAT22QCVdOPmUBBN50xDgAfPVO/kASVhLZA2UmydZLhyWhkE1eHPPRoL?=
 =?us-ascii?Q?nVba3q6gvajIOnGyyWsvQlYepJTLagRCrx2iMEqwUSQSTOvsY1WR+iEhX5+D?=
 =?us-ascii?Q?bv21yYc3vDb134+/UydghS2fguqMz74IHKit4gt0D1PZmne9hyFFzQTuJ1PR?=
 =?us-ascii?Q?MKqGYm28MdcppG2ReeraRzTV7PANksY3e3MEdHzmdkEIMWjmnmJe3YR0vphv?=
 =?us-ascii?Q?I1Hc76gxwU0xYlSV09dIOLI02BdYnNqGn85L9tHkUBmOgaLHkDLG498tYEq5?=
 =?us-ascii?Q?Gm3Disq12ufwwUmBpF581vJd9A/OGPlv7DhMb9lhZ2XAXAl6AdKQ40mtdw7P?=
 =?us-ascii?Q?du/UG2RBkhJQGOAgILYJWcAJOtu85WwhYmsn?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dEnapwW/csPADypY2Ez5FuyY1k2u97NCz2SFuf8LcOjprSq/lqwsci+CLuLA?=
 =?us-ascii?Q?lwHtrhv/X5DornpGTb75GmhXK2V/+FpH4y9IiuCK4n3bokzp/gDPuvpppmsp?=
 =?us-ascii?Q?YHZFi7gkBBr/bZzCcaAptEFoRwh1BjVWkyEB0lH5iQATszUnq1nVoopgw6uZ?=
 =?us-ascii?Q?CqGx+0RODmFEgWBL0fM7uSjeaIjNrTpRzebvJaSRyf1UuCN7na+rEsyfbyLh?=
 =?us-ascii?Q?jLAIrTDHeqOsqG99FN/Ot4Mnv3VJcECGz/F5Ls8SHwSkVr1mlY8qir8Ully9?=
 =?us-ascii?Q?skGT7U0HDcUYYb3wtoS93LFQL+7Z33VGwc9Wo0q9BBqPKwQ90i9xKpoMDQKe?=
 =?us-ascii?Q?tUexT/tDKcK+D0ir3Tl0WYyEil1Qy7drLMFi//WgjBCUF0i8QVwQzaOA2noF?=
 =?us-ascii?Q?/u2NjgJDLfj+CIpRa1aamHAbNrvV1vSBe4caHcN4XnhSEO7+vyEFp3BzSv68?=
 =?us-ascii?Q?1d5W0CEdlycYEl8v+BTLZ8Gmu0LfcirDcpGQ2ILPAuxYKKdZEj5h+qN2E7ao?=
 =?us-ascii?Q?55L8lgGHXOTe7cG/QckiXfE68Y8YppQxkHO4gpUPetmSDVkq8EHYO0nU66kS?=
 =?us-ascii?Q?w0D1WLNhiP9miyhtvfTk01ppoAKkANEmxA3vVhgc6Q3igsCgUOG9tvXBRg7F?=
 =?us-ascii?Q?A8f9A0yVoW2KrCDLapK1vH7WUKcdeFttAc5TY/kzWENGvuHJluy4iknBvZYr?=
 =?us-ascii?Q?mvMflNGNV8cWNf01A45sjQwIZ05BkRL3es5pINqj3lsMiboxKc0ZCCXu7G7/?=
 =?us-ascii?Q?Jx5SkS/PlZmdxLRyg2cMwvyERawOkzBcUX4uC2cz3jTNj1WMBAWaq/w0SsXB?=
 =?us-ascii?Q?Kzap8/V4mVlS2/ctG5D5mDuUqTibmOOZfMCis5SKFSyBSKZlhWzHm2zcx01a?=
 =?us-ascii?Q?5E21d/OEcpKCf8CM53+D+FcrnsaVOPtFBwDVKXwSBDRdh14qEjFRvuhNGxVX?=
 =?us-ascii?Q?hvh3etsopwka3MH9kcwrIy8GgWnl5xuGcGL+5Y23BFPjt/7m4sYFDdSu4lga?=
 =?us-ascii?Q?6HG9mRXNoNkAc59vgER/0bhjTqTCE+if2gTzqnajQd8Pw2EHkXcaJYU9I/vl?=
 =?us-ascii?Q?FARGIZRoGhjq03EIIVXjSctp0iQkzuwqDEVk7u9NUoTTD+JjDt88zKnS3mcF?=
 =?us-ascii?Q?5OwqY3p/ytkldTsRHdc0N+ZsJaaIkNCwCOVyNKWU66Ycr2+76O95AOSzG+GM?=
 =?us-ascii?Q?DzVfCeQArsF/Xbxj+bQbJ/ab8r3s7qweeclB/5MMhcFXBtu0HVZNY2Bj89+O?=
 =?us-ascii?Q?TBEXbN+NV/5FuL5oGynJbO0P+z9nO+O1maJ2izoHuY6xGHuMgyqaNVAikG0h?=
 =?us-ascii?Q?rqGg9qMJDsmOs7Eyrr+lp/OEJDwD4HUSsLZ1fM0U/jZXBYvhmQ7XWM+HEJ9d?=
 =?us-ascii?Q?zDb9Ai1YCrUYLRc21wx7DK+mZV10j9OAb/vNlFY7g8oRe8LiksvV+d6ghAQ7?=
 =?us-ascii?Q?6TZrkzV4rrDWQvNQQ3NcUKTP0Gy9u6imBl6GkDZN4cOCqyrCnzW5kzN9lD+F?=
 =?us-ascii?Q?5P4rv39GZ0EjE/HzHsT1shwqFuto6ChCw2Pb7gn/Z1TwvfFEmEx0Ppd6kh3Y?=
 =?us-ascii?Q?/Ke737o89HVUnVa+io/Ssrmt8wkw8d8oPjuFRfdO7RBU6F99I2bqgo6CfB6Y?=
 =?us-ascii?Q?wg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec0d78d-e91a-44ab-0c48-08de30ff0dd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2025 17:28:33.9811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m8pYUG/RZXVHlqugKh3ki24uM0PjC4XvoppYZbrvxef5X1CBH+FBTJOcmiq4DQeS0AjezLIyt+ab3IggaUotT3V5fubTfo9CgE9GkWA7VSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7620
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Thorsten Blum <thorsten.blum@linux.dev>
> Sent: Thursday, November 27, 2025 6:02 AM
> To: Accardi, Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Sridhar, Kanchana P
> <kanchana.p.sridhar@intel.com>; Herbert Xu
> <herbert@gondor.apana.org.au>; David S. Miller <davem@davemloft.net>;
> Tom Zanussi <tom.zanussi@linux.intel.com>
> Cc: Thorsten Blum <thorsten.blum@linux.dev>; stable@vger.kernel.org;
> linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] crypto: iaa - Fix out-of-bounds index in
> find_empty_iaa_compression_mode
>=20
> The local variable 'i' is initialized with -EINVAL, but the for loop
> immediately overwrites it and -EINVAL is never returned.
>=20
> If no empty compression mode can be found, the function would return the
> out-of-bounds index IAA_COMP_MODES_MAX, which would cause an invalid
> array access in add_iaa_compression_mode().
>=20
> Fix both issues by returning either a valid index or -EINVAL.
>=20
> Cc: stable@vger.kernel.org
> Fixes: b190447e0fa3 ("crypto: iaa - Add compression mode management
> along with fixed mode")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Acked-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>


> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c
> b/drivers/crypto/intel/iaa/iaa_crypto_main.c
> index 23f585219fb4..8ee2a55ec449 100644
> --- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
> +++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
> @@ -221,15 +221,13 @@ static struct iaa_compression_mode
> *iaa_compression_modes[IAA_COMP_MODES_MAX];
>=20
>  static int find_empty_iaa_compression_mode(void)
>  {
> -	int i =3D -EINVAL;
> +	int i;
>=20
> -	for (i =3D 0; i < IAA_COMP_MODES_MAX; i++) {
> -		if (iaa_compression_modes[i])
> -			continue;
> -		break;
> -	}
> +	for (i =3D 0; i < IAA_COMP_MODES_MAX; i++)
> +		if (!iaa_compression_modes[i])
> +			return i;
>=20
> -	return i;
> +	return -EINVAL;
>  }
>=20
>  static struct iaa_compression_mode *find_iaa_compression_mode(const
> char *name, int *idx)
> --
> Thorsten Blum <thorsten.blum@linux.dev>
> GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

