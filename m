Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFE6155C96;
	Mon,  6 Jan 2025 17:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736185038; cv=fail; b=N7ZDCbPjZf7MpmF+3YuZ5qGZWDZ+QJ+58gx55N35T2e+uVvVQkkjb9imsTPfrD6FlBZIKhpztCxgl+S/POdaKY2VCUMT4YW87QfF16yPVyCvbvKkPX+c4BaaBOT0V5IP4L2nFRNoSHN9FszFGW9WUVm7AS+bnh6WFSHvhAFqhvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736185038; c=relaxed/simple;
	bh=0fEMsEvzO2+7YboTTJ11lC5sdOyW8HDSSjcQZuUkUrA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FY+xfGmAgCWJXNY7yyqXbUv+yyu3c/XvHVRcaKLtmK1icysNTp7+L5JjGx7TBAyflGGi2HDmSw2pR34TysN8X2/D05C42PqyrqxDQ20CD8yQauzwa84rQVDuIFxC01XQ6TpXD7bqb3XkXN3vI/DGTpA1VX700qAmPxyGNo3PJTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O9S7qr0S; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O9S7qr0S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736185036; x=1767721036;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0fEMsEvzO2+7YboTTJ11lC5sdOyW8HDSSjcQZuUkUrA=;
  b=O9S7qr0SNY7m2tuWSOZDS6woXVBnpLLUWwUqqiAG9NVeL1dd0teW8tOM
   GC5aSNvQ7Hk2QNmcItKjng+pB1ytL2V1wRp6AuHG2sxQ4QDxfbfwXA7pw
   Pa1jQUqB4xN+PWJEOXvkg+OJSu+/svNc1teq8yxLSrYApNhsitoIg5Bs4
   S1IgRPuOHxBn8+P+70Ojei9P3wG4yCDNoDjsdJbqLubjGTmSmGDccO6M+
   wVq7HMdfe/RQM27BYoD2vA2yQ2AZX4t6Vki4PA2fvsys3wI5uQuQ/d7xD
   QQrzbRzUjwp6UhzpcwkVSMz6PaQ3axdSHJ7QLSxH4zSMG8fGe8VCEFTp7
   Q==;
X-CSE-ConnectionGUID: w/jKGllPS2mYzby/2oW1qg==
X-CSE-MsgGUID: Kza4FdWXSy6g5hHIZxXQlw==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="36037955"
X-IronPort-AV: E=Sophos;i="6.12,293,1728975600"; 
   d="scan'208";a="36037955"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 09:37:16 -0800
X-CSE-ConnectionGUID: nw4viPx1Su2wZXy4oNRiIQ==
X-CSE-MsgGUID: ldBjP2jTQ42My23yhPlZhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,293,1728975600"; 
   d="scan'208";a="102588550"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jan 2025 09:37:15 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 6 Jan 2025 09:37:14 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 6 Jan 2025 09:37:14 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 6 Jan 2025 09:37:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oyIDejIE+VQ7GRTDFgag0jUDAjON6AnRp37RsZVKlBwZRs8rX0oGMhd9OP3U6WcLOsTn5ve68P7lyD9fzLMD10DafWQ9Nbd3x8cIXrVKlqNzJoGdk+BwWjKfI4VRUZVf73fts/J2Ppz30AjVs6IInJvLTPSvdK+PmfgAyQvWNAyAC6RWCEbRBucVe6tFEMmCjIQbBv5X3XzZPLGwIWuuNYrPSFzaqKD3Bs/MKoUfPexf9/zE9RlF3/khjRmXHxo8u9OwtAuTcxYyBnKsgpQMiOCf5ZL1sKIKylM0dbMS3RCOOMI7MLtsG2mapJEhbafcsw4Yr/JMrkzlvey4xJWdYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fi/mDxbXRFcfdcHv4TNi0pIJ7ffqmI386E/UQFHqRpY=;
 b=hRq2+Y7DQ3xB5gqulfVpn/orUIXWNRtuW+kJlWZ3vWEPgFBMLJio511SyMVzEiE+66Y/E4V4CWDhwpKDK/iIHKP9jQbT/mu0sKa8PlCK850e6CgcpHxe35B/GhS/Tr9RdjrM93dsD8whKtPMDJQ6e/WBnHA1mJt6Li4G5hlpfqpAhZSPNYwReAAkYmyUMS7GPxUqLEsVCbQOwtL7LhyZZyVZtRLp8JSPmRTNluUQZhsUM29+j6PtojkimJNfy5WA/O1W3ehAY1xbj7RYCqIkEMDrbnDeYh/PeQduQ268u0lvVZhsu02cwmduGrqYa0TJLUvR1PwPEbkH1irTTKDJ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by IA1PR11MB8150.namprd11.prod.outlook.com (2603:10b6:208:44c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 17:37:07 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%6]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 17:37:07 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosryahmed@google.com" <yosryahmed@google.com>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Thread-Topic: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Thread-Index: AQHbU3H2SqTrZiGQHkmN4NbyUE5ZLrL7lUYAgA58frA=
Date: Mon, 6 Jan 2025 17:37:07 +0000
Message-ID: <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
 <20241221063119.29140-3-kanchana.p.sridhar@intel.com>
 <Z2_lAGctG0DDSCIH@gondor.apana.org.au>
In-Reply-To: <Z2_lAGctG0DDSCIH@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|IA1PR11MB8150:EE_
x-ms-office365-filtering-correlation-id: 4e626e5f-44da-412c-b88f-08dd2e78bdd8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?gxB/Ct60WYDhikAkUNN9uA6BmOw3llJAcFdu9JTuP5/TnhZfpc4DC79FJXQW?=
 =?us-ascii?Q?0/P+d6gGwQU3KOS8sHjTJ++SdT3fP699AjrQqhibiykaIl7xxOdnSrWH6Vpz?=
 =?us-ascii?Q?0J2ZatzW1lGLWRqYBjCND/TdOAldVlOJAXhCou77WeS9OeL6i7/Bp96a+Mbi?=
 =?us-ascii?Q?GoxgzawxseczUj6rGZ6QC29qlU4MB2u427Ga5aN4TNcVGNTUqa9cKMhlkMih?=
 =?us-ascii?Q?maoexUtgTcVdYIpiF11XHIYNTVWeCpIjgsS2V8a+ob07eD79xx6hv+D+ZqIM?=
 =?us-ascii?Q?u5VzkLqC6XqLD20qcuW7/wAo5BIAdjuvN6XqbAobiMuoJDr6NsknF9/tWaqJ?=
 =?us-ascii?Q?PUsXdZ3G6I681s80nPQhkt+34UEjFFihfMSAy74RscQTc6LDhAfHB2vbTsgx?=
 =?us-ascii?Q?6nXWZH4Hy/qDXeUnc67a7RoHLhuY5c1eaqMvS/dMfaqALFwpNB85Y0WL1gWc?=
 =?us-ascii?Q?KW4RBPvqB6x7b3ckBKGWVBzUMYkL3vb+3mZampVyF7/l3hzUbeS1w920v9Rk?=
 =?us-ascii?Q?NBvG7WwNt5Vdq/yH5yEpFaIUHOSvRISBEpUzM3t6SauuoKMLG3rZ888Vr7Ws?=
 =?us-ascii?Q?J5ZszIwDFLyNPZ9C1PRDHIVTLihOSDOOAJjWObqs6I12FbSXkYpvJFp3764a?=
 =?us-ascii?Q?FBCCibtimICS/GIUDmTdyN+3ENGxy6Y/fMIsJGr4QIAHY2mEDOPN22WGXVim?=
 =?us-ascii?Q?uxQHibq2wL+OM/pQEnPCceHhxzq9vPBTFWPtXgiBpXZCB04Kh5fMYJKFOFK0?=
 =?us-ascii?Q?12yQlR3poHXFAAYmRDdvsQZjMYZa/pydtzugr6+KNIZuaykyW24xEs+xPI8O?=
 =?us-ascii?Q?dJW+UOGPP4MhNEit3bD0Tllk91XpdlH7FzJtiguL+gMwx6lNnYDb/382SJdA?=
 =?us-ascii?Q?9ulRhoWob9bup4P419qM9FARFiwgMPK3GAV7YCGhnUqWr9GsH3+JlC1kCg7r?=
 =?us-ascii?Q?LJZN6RYdEu+bI5Zas28Roni8ycSil2I8r0ev+kd/wjCncFBExJwzgYwqc/G8?=
 =?us-ascii?Q?NH8tY2Q0bD7GO8GLu3Vbo0dtqDx0TQw1XF11C+Hb74TasVH7JZWeWlTro0md?=
 =?us-ascii?Q?3nv+ZnohLxcwSbP8d1K/Z3Zt4zsHrO+GpEqQotZm0EASJdkY3+Cgplp1yc6G?=
 =?us-ascii?Q?KMYy3ShKpr1EPzAQE7wAPzW3F7QXGU4Jza9+XpSA9gWBqJCX+qLaAEABR9l2?=
 =?us-ascii?Q?spNSX1v31zOcnGnTm6goPRFyEOkNp2D/CrbWCBWJl/SZcr89E8a35mesq5Vc?=
 =?us-ascii?Q?Tum12IOdiuBn2y8AP3gFlwpLbnKMwHJW2DKzWKmTLBu4NnOsVuh653f2JuDT?=
 =?us-ascii?Q?v421XbMtLQsVuxfHADUUKjthB6Q9zd6CqnQIKyDQACOwrXBTWw8AZ90worNJ?=
 =?us-ascii?Q?G4pwryLCDxZS2w8h2TEu3QZO9+zjLV3u98wHMwzNmlnLr06GXw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jaAD8/kt4yqfvK+dvv0WzQ10mfkiTan45vJlkfaTrMNQDrlGBhGB37wXe4Yn?=
 =?us-ascii?Q?7zrepsVVCoYmnYuTJL2sZGT4x7ea9+HU12bZBcjPCuUk6QmGofyen3pUhvI0?=
 =?us-ascii?Q?wJRw5LCHHggGhfRWxa6VPTQv7o/P0DsTQ48dzvIasCblhbvx8q1N29bvqmvR?=
 =?us-ascii?Q?rQ0vXnywowFOQBde72Xje9GsRRSWpNkyJYhs20mCEIZxDWZjWHCR79gXJaUF?=
 =?us-ascii?Q?+O35bInie8Z1hEZuRIGmLJfOxenS6cX5SQ2jxUx9WapX6qGK5t5P8Kqr46cQ?=
 =?us-ascii?Q?apMv3qAQlsSJqYEeOWY//I0pMi/ZuceTcmOyi4LpHljaWFEP+RpEYtzHOR6L?=
 =?us-ascii?Q?JmViGZWuZxC5A/ABD3ZM2wV1sXRY+7glQ/04hxooLjhNmlVfM1oU/TJ6CWhs?=
 =?us-ascii?Q?WO+TQ9mv8vTz7qrUfYRXwSG2nLrfxXS9jBVMD1gl3zmghO1KKZNYkg84by7R?=
 =?us-ascii?Q?riMlBajdzidyFXr8snLoOyfbCmcs2/6dVNDZF+NUCVeKO8eF4G7NqtWZfHA+?=
 =?us-ascii?Q?vLUp/+mzE8U6QGkNLPCjoDgwGXo1JjWkOF48THpFVCBDj/beJL0bWoq/ifWa?=
 =?us-ascii?Q?PklIvEn5wijY7YQjWTnpXHK38OtAauPvivrcMkVtwIDMLldfmSGPw0MBVyTi?=
 =?us-ascii?Q?KNFzW/ifrHFQF/bE/V6Y7srvCx6EX76lZvEOOmKL4nvJG6D2DquUhuCziEOI?=
 =?us-ascii?Q?h32GHaAYS2RNqSpQI58XtdX74g3KVfiO0U7+roPMawTsSlLmtMDvJ5/C/xiT?=
 =?us-ascii?Q?5NJ3UnmLCuO9MbxTs2yp3cVmH1WiMKs3+RZ40TXY2Dsqjf2Oi9w45Vifli9M?=
 =?us-ascii?Q?44wIzlPvWx9PkRi7YzIiW1WmfMihLBnhYtKFNr59Pkn3bLcY+21a7UDm+4ld?=
 =?us-ascii?Q?pHBNIDIzLst/k06gvOFmsBFV1Kafwt9vtBsPY9aSfiCI7I+x+7sk3iir5AZT?=
 =?us-ascii?Q?A3lgkcE0sjjkKg1neSMTxHTKSPpsl3almHRY2ab7RiiSU/9saghHChlzJVX5?=
 =?us-ascii?Q?mUNKacvQ7Zr/I+eRdeibNTl+yBXcU7uWt4dw3lJy55Ttn91Se71V0aKVKG18?=
 =?us-ascii?Q?wt4eVQfqD11pC/u4B/d1e+VoLGkFEWEa/gj3KuRGgkn23ntiR74ABp6N3lEz?=
 =?us-ascii?Q?ue03n2twpurW6UZxyiXAf7vLbJMwqKn2hYInTTCYrTpeTLz0L4GlH+nUvi8d?=
 =?us-ascii?Q?HvuAkiabPMJuZ1xTw3bdWeKOpPA3L6YMtp0YMABPgS8cMNzcllkwHTrzKsoW?=
 =?us-ascii?Q?8iVPLClrADt7Wu2AAaW3W+iekYHMzy/nLTstdX3JLxh7LhR1SxJ1wfz3W3Gm?=
 =?us-ascii?Q?kMLBLIkOLIbukqnZHuEu3Qbo09p9fcNSkCb/R8oS6rMowO/ojYNR50aRWk03?=
 =?us-ascii?Q?V2zCqI6xE1imIRrHjvoON3EA9kCORTPldNpMY/INJVeU9tGqbihNOpoRcsXX?=
 =?us-ascii?Q?Nu0i5TIoz1ve/sQo2jvFU0jXhno8+QP3+9KyhejK2vdLFEfmD0Qzy47PYVu1?=
 =?us-ascii?Q?qRqXbFWmNDhMHeGpTN9erTsQp3M3ByqffL0SFqHrynvDVgPZg2Ewtd3VWlcb?=
 =?us-ascii?Q?JxQ96omX4QT7pikJVyhyVF5Qf3cOkSFn+EOx6DasiBW+58qPk0EHYiQLIlGF?=
 =?us-ascii?Q?CA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e626e5f-44da-412c-b88f-08dd2e78bdd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2025 17:37:07.2158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rS/x6pQuV6lATMqy4xBAx7J2nZN/DKgw+eO02Uh3ykQyczaa9hADaqbcvC+FQeGdmo2vZyPQZUDnWEqg6+r3sG6l91eXF2i0MyL9cDiUZEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8150
X-OriginatorOrg: intel.com

Hi Herbert,

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Saturday, December 28, 2024 3:46 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosryahmed@google.com; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com; akpm@linux-foundation.org;
> linux-crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Feghali, Wajdi K
> <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
> compress/decompress batching.
>=20
> On Fri, Dec 20, 2024 at 10:31:09PM -0800, Kanchana P Sridhar wrote:
> > This commit adds get_batch_size(), batch_compress() and
> batch_decompress()
> > interfaces to:
>=20
> First of all we don't need a batch compress/decompress interface
> because the whole point of request chaining is to supply the data
> in batches.
>=20
> I'm also against having a get_batch_size because the user should
> be supplying as much data as they're comfortable with.  In other
> words if the user is happy to give us 8 requests for iaa then it
> should be happy to give us 8 requests for every implementation.
>=20
> The request chaining interface should be such that processing
> 8 requests is always better than doing 1 request at a time as
> the cost is amortised.

Thanks for your comments. Can you please elaborate on how
request chaining would enable cost amortization for software
compressors? With the current implementation, a module like
zswap would need to do the following to invoke request chaining
for software compressors (in addition to pushing the chaining
to the user layer for IAA, as per your suggestion on not needing a
batch compress/decompress interface):

zswap_batch_compress():
   for (i =3D 0; i < nr_pages_in_batch; ++i) {
      /* set up the acomp_req "reqs[i]". */
      [ ... ]
      if (i)
	acomp_request_chain(reqs[i], reqs[0]);
      else
	acomp_reqchain_init(reqs[0], 0, crypto_req_done, crypto_wait);
   }

   /* Process the request chain in series. */
   err =3D crypto_wait_req(acomp_do_req_chain(reqs[0], crypto_acomp_compres=
s), crypto_wait);

Internally, acomp_do_req_chain() would sequentially process the
request chain by:
1) adding all requests to a list "state"
2) call "crypto_acomp_compress()" for the next list element
3) when this request completes, dequeue it from the list "state"
4) repeat for all requests in "state"
5) When the last request in "state" completes, call "reqs[0]->base.complete=
()",
    which notifies crypto_wait.

From what I can understand, the latency cost should be the same for
processing a request chain in series vs. processing each request as it is
done today in zswap, by calling:

  comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &=
acomp_ctx->wait);

It is not clear to me if there is a cost amortization benefit for software
compressors. One of the requirements from Yosry was that there should
be no change for the software compressors, which is what I have
attempted to do in v5.

Can you please help us understand if there is a room for optimizing
the implementation of the synchronous "acomp_do_req_chain()" API?
I would also like to get inputs from the zswap maintainers on using
request chaining for a batching implementation for software compressors.

Thanks,
Kanchana

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
