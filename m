Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A36229994B;
	Fri, 22 Aug 2025 19:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755890802; cv=fail; b=bbkOqMBTzuWz17F98bPwONApvdjpXpKg0llSKk1AKiWp4NDgM5QvJcbWYgbOoZ47AwnIyZuIqaVFnL9gHqxHrEFmWeoW4P/i4k0VEs2hCcJQ2L39etvYt4+9Vbvgn+ivmeSfog/EI715NnIDIRnOl+uWaQ3pc8Dl7+xZ/JYjcZo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755890802; c=relaxed/simple;
	bh=AhVzoTAwG8CKBFdMHiSLuC8DhKWpi3gomlxqHJbe40U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YEkfT0s+HP8mwPEHZ5y46wF7tqtgScdBBkC560rdG8ZeyrJS7E0bvhH8tl3KuBpPdQVHYtESuhnSlUslagScNPRxOxj8MvRkFRQtIr0Jgq4frtBLFDEj7fH04C5Li2hOLzOpw5K6oI7yMSu+npUSHMZVt2GhIElZWqjcbkOvhw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hkJXaYR1; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hkJXaYR1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755890800; x=1787426800;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AhVzoTAwG8CKBFdMHiSLuC8DhKWpi3gomlxqHJbe40U=;
  b=hkJXaYR1hvKI+jTEg5rydbdfx4jcwOzki4za1gZfKo3byANyzROU2gYt
   E77DatMG3i1xs+zP4LRY+3iznYQj7KEI5Bde6NTPrgdARIwP94q5SG/sA
   pM2FAe3Gnpu5IXjCdYnovAW5p19qdyI21/Irh+Y5Pl6q1yFoBXMnuqhPe
   QZ59XRaJ4BV4Nj1udJpUqUQ04Lcs7UsoRe61ylS6xKz9VWlvjUzU7lbMR
   RtNmNFL0phlRMAJeNauYQT8eZHqKjcppAH0+FXM+SmZ+y280nEBhBfoHM
   avRcPSGRWQJkCHMQ8/gfCOXDoQWpH7feD8U3y/OE9+LPtKXMd1QKwOZ8f
   A==;
X-CSE-ConnectionGUID: rQQxlsVNRuKbt2yPwfmhtg==
X-CSE-MsgGUID: d+5s7M56RgGytAmpqZ8qxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="75660557"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="75660557"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 12:26:39 -0700
X-CSE-ConnectionGUID: ik4VxBO/RS+PBnGU7EE96A==
X-CSE-MsgGUID: IU6MNBgdSTuu/ypMjO374Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="168680797"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 12:26:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 12:26:38 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 22 Aug 2025 12:26:38 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.55)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 12:26:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BL0ZCQapiDgHLlXHpPb0KaRZ3zS2hZy1WfnX2VhBkCxL5iixCnyIw9KTM2bXkGdcRUlYhvIu9ieyW3RvD5/jCiq7gEo4cUpZT6bOj/KWImyiTDZOUrAJ5yWtnup1guAbs+M/rE2rlZiBMIaCwmoZvIs9RHQKIShIGynx+v0nSrqeaeqYUIuJqCjhrQORLLeDnud2mxzdz5hzhKJ4ML2bltPnLWfOQrWW5BW6p6IuCRIBG1wd0GxYo77tWle7nQUAJfUDmRxaa1lzpxrwwLiQy68f6rcIJ2SccAlEiuA/3U8+tCutVKrN5YqFF4blRy78AfwmvMQeNae3NDkxIZYy7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KbauquOY7+bDeJpebSqkeXRr3jqtfS6+L/kPg5qstfw=;
 b=yldw7xpTmifGpzNF98L4PNJxkcI0JIWLJQYbgjmyDfvVncxUKdvWNcsbwGAmZp7qj2plbistV5suDcGS1dXW9zCwC6SUCO+nHf2aiI9u+mSvk0wJbDkkoGWPFePFGJggiUFQCUFNIBfjGePMf9kRfoWlxuju/AOidHkE4GKyWHh/R1pYUpemGPFp7HGMWsrqNuT0Tko7McnMUeNsY/0OdIYAhyGAikgDLGW43dS5S268lUqoBIvKUqtBYwdObQa06wkZn3cbL0BLTHav+S81lIO933UNRMJWLvdfv5zboF+ysNDIZW9k+tGjPUGmW92cvvmCOkXceqw2Su7WGTWpyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by DM6PR11MB4563.namprd11.prod.outlook.com (2603:10b6:5:28e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Fri, 22 Aug
 2025 19:26:34 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9052.017; Fri, 22 Aug 2025
 19:26:34 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Nhat Pham <nphamcs@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Thread-Topic: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Thread-Index: AQHcAp3n35LtSdVMgUSnKQGImY3Y0LRZeWoAgAnL+YCAC+jI8A==
Date: Fri, 22 Aug 2025 19:26:34 +0000
Message-ID: <PH7PR11MB812143269E98B00ED4E5BE4DC93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
 <aJ7FSUdvxtZyiHBq@gondor.apana.org.au>
In-Reply-To: <aJ7FSUdvxtZyiHBq@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|DM6PR11MB4563:EE_
x-ms-office365-filtering-correlation-id: c6bc808f-4514-489e-171b-08dde1b1ce95
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?TXI5qcusSEePO0TpRUfg9uc/jlEBjWNDo1jY0x4W3nZMIaWawKRrmk5RLwGf?=
 =?us-ascii?Q?yWYl4h+rhBARoHbmncb2K0VBYQBmeArv8T1GwheFQxMGFDk0hMnRtIm4yUfk?=
 =?us-ascii?Q?6axomghHzgLe20gJ7Mf5WIdLDukq0GPnn6D9g2nDSLt/eKneyZsvC7kHIdc2?=
 =?us-ascii?Q?Ehu7BJ1Mz91yqcV5cU1RNfqVHIiGs5ZJJCy2uf+v1QgDw9NqPuKvJDBNVQ23?=
 =?us-ascii?Q?0RnQ8kiY6wyUfTlSAnAN6N0znZlup4ZCtB2f4njQGgR7745JYPjYE8UzwuWr?=
 =?us-ascii?Q?wc61OYr0LAR28gCfo5XuXT2kiYXnLSrLHp6ziJprXFBo4ir2NEuwy6WeGD3M?=
 =?us-ascii?Q?QqT+2GvcrnULT808xc9xogETdBDRkxOABg24JE2jx+Vl4zJGewfJ8vAqK0pQ?=
 =?us-ascii?Q?uEdmUiTsb6LBGj3cO+oBqcSq6eUAxNkMy5Q6uxyvY3tmSfKIWlPMvMSCMwxA?=
 =?us-ascii?Q?PhzQsTONm8wp9S6tRMoec7SQAYofCF3zZGP9uGAmPb64FeM4YaMIN5pfQv4m?=
 =?us-ascii?Q?+kWZLR4cBT2J42KLn+g76ZLaL6xzE6eqU4nzHyA0k27zecNr0BOGs6NcRAtI?=
 =?us-ascii?Q?9ygmi9brHG3xtT+uuSVmp32KbhU+rppwHHDE5XzaU0dh9TK1ZaT6Pp4wClAU?=
 =?us-ascii?Q?WI7m95DWLyDbDcbfa3SABlSYsOIhvlxR0kI0eRUPdLr7SqV3grmNMakRTsQv?=
 =?us-ascii?Q?QgaFNxfqby/NRpRX3EczrTMTrlIL6FhjRlPm10GUFkmatcthAcqVwUxFaX8N?=
 =?us-ascii?Q?nXxxO8XfB2Q+F9P1CFyemjiMhYSqrRoe3rP0I9rKCRt6SVh7XRfjNK1yxWjW?=
 =?us-ascii?Q?Cv1s/f9SXG3xd5SMAjEE1xIn7EO4D/9cdlkbfelOB9D8sDeefKQakXC01Hd3?=
 =?us-ascii?Q?CLS+WxJk5XTMMirsvmQS9uXvqJjuGlETDR1nZ5RMVnVAQxN8pHF0qYy9gvcB?=
 =?us-ascii?Q?ANlkA9CSoZq68Ny9yYC+o3+T6gI1AdpKOYx0GT/evEp0aMsvBCg0DKqnlhxN?=
 =?us-ascii?Q?OHT+k0f59wm9H8pnsWPB4phn/EwTXd7Rdawz+6eT5NkAE4swyC8BdNcqMbZr?=
 =?us-ascii?Q?SP2P5u2jO8LeACzcKTvApDcDoTvbXy5W/V4giGFJDmeqDg6ODJazb4YB0gVy?=
 =?us-ascii?Q?iJfZQa7qqqEgrtFHUuPWrnqBAA34Ov1BPhXM+CkWea1dF+NvTnbLBl8a/5mi?=
 =?us-ascii?Q?AbxkAND0z9JIjYwVVUqZMrnhYg8Q5NG4GBrHKfmyvVdu85+HeHheHkQrniuq?=
 =?us-ascii?Q?k8Wj1n+/WKJzj1YpHJEQnTmPKegQxfWBU7aj9TQ48UQblJGaa21pw7JRhYqg?=
 =?us-ascii?Q?XQE+o4lC6pBOixk9i2bNCThWPebwFn1dmGRcja4xeJ1JucNVmwy60hF6kGcb?=
 =?us-ascii?Q?FwtJO3HLe4mvd/2IFlXvqQ/HeClz9WcwdZKfIQj/foNfMtaE6JeSPPFwbvrN?=
 =?us-ascii?Q?hiJADw7XLs0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BAnd9meIPyeFBhipy8ipJIxYJrpqIPARSsTvSP5tOFOTC5GpUf+KfD3y2k2h?=
 =?us-ascii?Q?gcZqe4m0cUdFhtxHwDYccO7HFMidtv3kDuHdKVA3XmSrUAYAdEMg2VbEorRf?=
 =?us-ascii?Q?N0Vlp0dMgna1fjLdXVYXn2OMUjr5ZZvhgAo0adu9+HkXSE/4IM6Wc+6Cc/2S?=
 =?us-ascii?Q?5MZ1fp8i1Zsy04mJhS2EI1cDMXlJ4Lvb/81oX1oO6DtoVQpoQkb5jP7A3Nn9?=
 =?us-ascii?Q?11E4XEV6J49jmxkIJJmugaoFNRGpwYzrdl9spGxCL1Fa4Zk4ayJBbiMD53jg?=
 =?us-ascii?Q?0x4AmZnSf5e4Sn+pT++QOjEK2BT4bde+1ho7hcKlnHKRFlTaD2A/wDc6wDCs?=
 =?us-ascii?Q?IE3NSixED6sK1PJTSczEdQOB7Ix6xPB3XClRoP8SYBt56xzSL9K5W3yBt9w5?=
 =?us-ascii?Q?7YSJ+lIL5OxKzMS+4+M1i5ZnnF67mTH8gUeKZR0TiOvlYKW6vYyVFCB9t5CO?=
 =?us-ascii?Q?BhvWfLoFSM7NX5v/im8QPZZ3e9XSZLykpWar4VD8ZVThH5t8yCz7LrHyEzC/?=
 =?us-ascii?Q?YFL6DyAgF/sLRyz6LnV1HwzZ2JMxbC2fbVYUrJVWCSsOeYayYG2o2aJSebqt?=
 =?us-ascii?Q?P6D45ny6TOoetAikU4AoTvMiOxLtU1nteESmJcTbQdZCa4uhcC1t9HCbqwtZ?=
 =?us-ascii?Q?YAKO5kX+vlD1zz1ub67MWoeeOyr3Q4YBYQxHaYBZXJgonmxF/1vdP2DAywrV?=
 =?us-ascii?Q?naSQ0qx87ixx5r/L4vMjGY0WPVtNhPEFNMeXhqMUdqJCE7p9WzvUe2aCg4Ug?=
 =?us-ascii?Q?iuGW8u13BGsPobQh+7uc2es/o0Z2MLh9ukqc2xpRY51U11m5wCIOaX/zFran?=
 =?us-ascii?Q?xLfkmBDq1/2oR0eDsrk27rCPmnXECfE9pHiWGQLF9xYqnyiHvFiz7bQFLON2?=
 =?us-ascii?Q?+SFRMd6C9Et91bYZADE8seNeJAuuiFlgU3KTiIDbMvTe0V6dsH81L2Kbj3/h?=
 =?us-ascii?Q?jZzDUQlm4UDd9OYkFSHla1xZjjF9mTotiq9qpQarJo0HCC3PRvYPKQr/XjVb?=
 =?us-ascii?Q?HLqpxSBVIh2FktxeCm7ygX603KaoDY/Ewse+RRxMUIsjKCVbR0qJK9PjC6tj?=
 =?us-ascii?Q?R9z99TNYiJT3fHRsm59pN9uzJGiDcJXtMaNzsCANFlKLlTGIhEwJ4OWQgvm1?=
 =?us-ascii?Q?nREhJiiUDfc9obXYrfkx76/ixSx0o0j1+soSpP/EVTNBj+OUTomTihggw03k?=
 =?us-ascii?Q?oOaFEYnj/8gQPcWPA0yW3XbkE/uwVG+A26xTrbjI2MrYkTKzdvTAUScKNk13?=
 =?us-ascii?Q?++bEbTyYNbzi9QAsmFQvEKt35A3g9Li9r+c0SpW7w5h3t53zgnQR3a7NaPk7?=
 =?us-ascii?Q?QAgMpfYdCLKrisqYnyGMAqsnRQxOabgj/8QTO0Y1R1kxztSAka4Yu+A58Rmz?=
 =?us-ascii?Q?zZZEqov7uaIWBzJ7duP+tND3YFJE2xDRXHD42U34BhDh+TbbRdoVp8ZwH2vM?=
 =?us-ascii?Q?ZWtXYMblnoyI+5ofG3LOHJp355KkzPycHhYb2qmtM674oLGrq15onliKS3vd?=
 =?us-ascii?Q?bgbt7VL15fyK631FIp3raLG9A26Uso7ovE3URPBt/oqiVZKHmvd/eYpQgDps?=
 =?us-ascii?Q?CRomKp2udNEzGNr2ryNNlURJLg+ngSZ842VZTqQ7VTEvmovpNzUJ1vt7bNQA?=
 =?us-ascii?Q?vw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c6bc808f-4514-489e-171b-08dde1b1ce95
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2025 19:26:34.7781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9a7U4Hv3l7ggu08/EiZMmfAEpSV/VvBin62TXRvJ6VscQvAZanGPzwYoc1RSj/tUdV5lmnC5SFWxOWw2Ly6+HvKVuHVIAy3MJZQg51PKpxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4563
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Thursday, August 14, 2025 10:28 PM
> To: Nhat Pham <nphamcs@gmail.com>
> Cc: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; linux-
> kernel@vger.kernel.org; linux-mm@kvack.org; hannes@cmpxchg.org;
> yosry.ahmed@linux.dev; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; linux-crypto@vger.kernel.org;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>=
;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v11 00/24] zswap compression batching with optimized
> iaa_crypto driver
>=20
> On Fri, Aug 08, 2025 at 04:51:14PM -0700, Nhat Pham wrote:
> >
> > Can we get some comments from crypto tree maintainers as well? I feel
> > like this patch series is more crypto patch than zswap patch, at this
> > point.
> >
> > Can we land any zswap parts without the crypto API change? Grasping at
> > straws here, in case we can parallelize the reviewing and merging
> > process.
>=20
> My preference is for a unified interface that caters to both
> software compression as well as parallel hardware compression.
>=20
> The reason is that there is clear advantage in passing a large
> batch of pages to the Crypto API even for software compression,
> the least we could do is to pack the compressed result together
> and avoid the unnecessary copying of the compressed output that
> is currently done in zswap.
>=20
> However, since you guys are both happy with this patch-set,
> I'm not going stand in the way.
>=20
> But I do want some changes made to the proposed Crypto API interface
> so that it can be reused for IPComp.
>=20
> In particular, instead of passing an opaque pointer (kernel_data)
> to magically turn on batching, please add a new helper that enables
> batching.
>=20
> I don't think we need any extra fields in struct acomp_req apart
> from a new field called unit_size.  This would be 4096 for zswap,
> it could be the MTU for IPsec.
>=20
> So add something like this and document that it must be called
> after acmop_request_set_callback (which should set unit_size to 0):
>=20
> static inline void acomp_request_set_unit_size(struct acomp_req *req,
> 					       unsigned int du)
> {
> 	req->unit =3D du;
> }
>=20
> static inline void acomp_request_set_callback(struct acomp_req *req, ...)
> {
> 	...
> +	req->unit =3D 0;
> }
>=20
> For the source, nothing needs to be done because the folio could
> be passed in as is.
>=20
> For the destination, construct an SG list for them and pass that in.
> The rule should be that the SG list must contain a sufficient number
> of pages for the compression output based on the given unit size.
>=20
> For the output lengths, just set the lengths in the destination
> SG list after compression.  If a page is incompressible (including
> an error), just set the length to a negative value (-ENOSPC could
> be used for incompressible input, as we already do).  Even though
> struct scatterlist->length is unsigned, there should be no issue
> with storing a negative value there.

Hi Herbert, Nhat,

Thanks Herbert for these suggestions! I have implemented the new crypto API
and the SG list suggestion. While doing so, I was also able to consolidate =
the
new scatterlist based zswap_compress() implementation for software and hard=
ware
(i.e. batching) compressors, within the constraints of not changing anythin=
g
below the crypto layer for software compressors.

I wanted to provide some additional details so that you can review the over=
all
approach and let me know if things look Ok. I will rebase the code to the l=
atest
mm-unstable and start working on v12 in the meantime.

1) The zswap per-CPU acomp_ctx has two sg_tables added, one each for
   inputs/outputs, with nents set to the pool->compr_batch_size (1 for soft=
ware
   compressors). This per-CPU data incurs additional memory overhead per-CP=
U,
   however this is memory that will anyway be allocated on the stack in
   zswap_compress(); and less memory overhead than the latter because we kn=
ow
   exactly how many sg_table scatterlists to allocate for the given pool
   (assuming we don't kmalloc in zswap_compress()). I will make sure to qua=
ntify
   the overhead in v12's commit logs.

2) I added new sg_alloc_table_node() and sg_kmalloc_node() to facilitate th=
is.

3) I added the acomp_request_set_unit_size() helper for
   batching; initialized the unit_size to 0 in
   acomp_request_set_callback(). zswap_cpu_comp_prepare() will set the unit=
_size
   to PAGE_SIZE after the call to acomp_request_set_callback().

4) Unified code in zswap_compress() for software and hardware compressors t=
o use
   the per-CPU SG lists. Some unavoidable changes for software path to use =
the
   acomp_req->dlen instead of the SG list output length.

5) A trade-off I had to make in the iaa_crypto driver to adhere to the new =
SG
   list based batching architecture:

   Currently, all calls to dma_map_sg() in iaa_crypto_main.c use
   sg_nents(req->src[dst]). This requires the sg_init_marker() is set corre=
ctly
   based on the number of pages in the batch. This in turn requires
   sg_unmark_end() to be called to clear the termination marker before
   returning. All this adds latency to zswap_compress() (i.e. per batch com=
press
   call) with the new approach and causes regression wrt v11.

   To make the new approach functional and performant, I have changed all
   the calls to dma_map_sg() to use nents of 1. This should not be a concer=
n,
   since it eliminates redundant computes to scan an SG list with only one
   scatterlist for existing kernel users, i.e. zswap with the zswap_compres=
s()
   modifications described in (4). This will continue to hold true with the=
 zram
   IAA batching support I am developing. There are no kernel use cases for =
the
   iaa_crypto driver that will break this assumption.

6) "For the source, nothing needs to be done because the folio could be pas=
sed
   in as is.". As far as I know, this cannot be accomplished without
   modifications to the crypto API for software compressors, because compre=
ssed
   buffers need to be stored in the zswap/zram zs_pools at PAGE_SIZE
   granularity.
  =20
I have validated the above v12 changes applied over the v11 patch-series,
on Sapphire Rapids:

  1) usemem30: Both zstd and deflate-iaa have comparable performance to v11=
.

  2) kernel_compilation test: Mostly better performance than baseline, but =
worse
     than v11. Slightly worse sys time than baseline for zstd/PMD.


  usemem30 with 64K folios:
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
 =20
     zswap shrinker_enabled =3D N.
 =20
     ----------------------------------------------------------------------=
-
                     mm-unstable-7-30-2025             v11             v12
     ----------------------------------------------------------------------=
-
     zswap compressor          deflate-iaa     deflate-iaa     deflate-iaa
     ----------------------------------------------------------------------=
-
     Total throughput (KB/s)     7,153,359      10,856,388      10,714,236
     Avg throughput (KB/s)         238,445         361,879         357,141 =
        =20
     elapsed time (sec)              92.61           70.50           68.87
     sys time (sec)               2,193.59        1,675.32        1,613.11
     ----------------------------------------------------------------------=
-
   =20
     ----------------------------------------------------------------------=
-
                     mm-unstable-7-30-2025             v11             v12
     ----------------------------------------------------------------------=
-
     zswap compressor                 zstd            zstd            zstd
     ----------------------------------------------------------------------=
-
     Total throughput (KB/s)     6,866,411       6,874,244       6,922,818
     Avg throughput (KB/s)         228,880         229,141         230,760
     elapsed time (sec)              96.45           89.05           87.75
     sys time (sec)               2,410.72        2,150.63        2,090.86 =
   =20
     ----------------------------------------------------------------------=
-


  usemem30 with 2M folios:
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 =20
     zswap shrinker_enabled =3D N.
   =20
     ----------------------------------------------------------------------=
-
                     mm-unstable-7-30-2025             v11             v12
     ----------------------------------------------------------------------=
-
     zswap compressor          deflate-iaa     deflate-iaa     deflate-iaa
     ----------------------------------------------------------------------=
-
     Total throughput (KB/s)     7,268,929      11,312,195      10,943,491
     Avg throughput (KB/s)         242,297         377,073         364,783
     elapsed time (sec)              80.40           68.73           69.19
     sys time (sec)               1,856.54        1,599.25        1,618.08
     ----------------------------------------------------------------------=
-
 =20
     ----------------------------------------------------------------------=
-
                     mm-unstable-7-30-2025             v11             v12
     ----------------------------------------------------------------------=
-
     zswap compressor                 zstd            zstd            zstd =
         =20
     ----------------------------------------------------------------------=
-
     Total throughput (KB/s)     7,560,441       7,627,155       7,600,588
     Avg throughput (KB/s)         252,014         254,238         253,352
     elapsed time (sec)              88.89           83.22           87.55
     sys time (sec)               2,132.05        1,952.98        2,079.26
     ----------------------------------------------------------------------=
-


  kernel_compilation with 64K folios:
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

     zswap shrinker_enabled =3D Y.
 =20
     ----------------------------------------------------------------------=
----
                        mm-unstable-7-30-2025             v11             v=
12
     ----------------------------------------------------------------------=
----
     zswap compressor             deflate-iaa     deflate-iaa     deflate-i=
aa
     ----------------------------------------------------------------------=
----
     real_sec                          901.81          840.60          895.=
94
     sys_sec                         2,672.93        2,171.17        2,584.=
04
     zswpout                       34,700,692      24,076,095      37,725,6=
71
     zswap_written_back_pages       2,612,474       1,451,961       3,050,5=
57
     ----------------------------------------------------------------------=
----

     ----------------------------------------------------------------------=
----
                        mm-unstable-7-30-2025             v11             v=
12
     ----------------------------------------------------------------------=
----
     zswap compressor                    zstd            zstd            zs=
td
     ----------------------------------------------------------------------=
----
     real_sec                          882.67          837.21          872.=
98 =20
     sys_sec                         3,573.31        2,593.94        3,301.=
67
     zswpout                       42,768,967      22,660,215      36,810,3=
96
     zswap_written_back_pages       2,109,739         727,919       1,475,4=
80
     ----------------------------------------------------------------------=
----


  kernel_compilation with PMD folios:
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

     zswap shrinker_enabled =3D Y.

     ----------------------------------------------------------------------=
----
                        mm-unstable-7-30-2025             v11             v=
12
     ----------------------------------------------------------------------=
----
     zswap compressor             deflate-iaa     deflate-iaa     deflate-i=
aa
     ----------------------------------------------------------------------=
----
     real_sec                          838.76          804.83          826.=
05
     sys_sec                         3,173.57        2,422.63        3,128.=
11
     zswpout                       59,544,198      38,093,995      60,072,1=
19
     zswap_written_back_pages       2,726,367         929,614       2,324,7=
07
     ----------------------------------------------------------------------=
----
=20
=20
     ----------------------------------------------------------------------=
----
                        mm-unstable-7-30-2025             v11             v=
12
     ----------------------------------------------------------------------=
----
     zswap compressor                    zstd            zstd            zs=
td=20
     ----------------------------------------------------------------------=
----
     real_sec                          831.09          813.40          827.=
84
     sys_sec                         4,251.11        3,053.95        4,406.=
65
     zswpout                       59,452,638      35,832,407      63,459,4=
71
     zswap_written_back_pages       1,041,721         423,334       1,162,9=
13
     ----------------------------------------------------------------------=
----


I am still in the process of verifying if modifying zswap_decompress() to u=
se
the per-CPU SG lists improves kernel_compilation, but thought this would be=
 a
good sync point to get your thoughts.

I would greatly appreciate your comments on the approach and trade-offs, an=
d
guidance on how to proceed.


"v12" zswap.c diff wrt v11:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D

diff --git a/mm/zswap.c b/mm/zswap.c
index c30c1f325f57..58ad257e87e8 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -152,6 +152,8 @@ struct crypto_acomp_ctx {
 	struct acomp_req *req;
 	struct crypto_wait wait;
 	u8 **buffers;
+	struct sg_table *sg_inputs;
+	struct sg_table *sg_outputs;
 	struct mutex mutex;
 	bool is_sleepable;
 };
@@ -282,6 +284,16 @@ static void acomp_ctx_dealloc(struct crypto_acomp_ctx =
*acomp_ctx, u8 nr_buffers)
 			kfree(acomp_ctx->buffers[i]);
 		kfree(acomp_ctx->buffers);
 	}
+
+	if (acomp_ctx->sg_inputs) {
+		sg_free_table(acomp_ctx->sg_inputs);
+		acomp_ctx->sg_inputs =3D NULL;
+	}
+
+	if (acomp_ctx->sg_outputs) {
+		sg_free_table(acomp_ctx->sg_outputs);
+		acomp_ctx->sg_outputs =3D NULL;
+	}
 }
=20
 static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
@@ -922,6 +934,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, str=
uct hlist_node *node)
 {
 	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool->acomp_ctx, cpu);
+	int cpu_node =3D cpu_to_node(cpu);
 	int ret =3D -ENOMEM;
 	u8 i;
=20
@@ -936,7 +949,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, str=
uct hlist_node *node)
 	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
 		return 0;
=20
-	acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to=
_node(cpu));
+	acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_no=
de);
 	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
@@ -960,13 +973,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, s=
truct hlist_node *node)
 				     crypto_acomp_batch_size(acomp_ctx->acomp));
=20
 	acomp_ctx->buffers =3D kcalloc_node(pool->compr_batch_size, sizeof(u8 *),
-					  GFP_KERNEL, cpu_to_node(cpu));
+					  GFP_KERNEL, cpu_node);
 	if (!acomp_ctx->buffers)
 		goto fail;
=20
 	for (i =3D 0; i < pool->compr_batch_size; ++i) {
 		acomp_ctx->buffers[i] =3D kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL,
-						     cpu_to_node(cpu));
+						     cpu_node);
 		if (!acomp_ctx->buffers[i])
 			goto fail;
 	}
@@ -981,6 +994,26 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, st=
ruct hlist_node *node)
 	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   crypto_req_done, &acomp_ctx->wait);
=20
+	acomp_request_set_unit_size(acomp_ctx->req, PAGE_SIZE);
+
+	acomp_ctx->sg_inputs =3D kmalloc_node(sizeof(*acomp_ctx->sg_inputs),
+					    GFP_KERNEL, cpu_node);
+	if (!acomp_ctx->sg_inputs)
+		goto fail;
+
+	if (sg_alloc_table_node(&acomp_ctx->sg_inputs, pool->compr_batch_size,
+				GFP_KERNEL, cpu_node))
+		goto fail;
+
+	acomp_ctx->sg_outputs =3D kmalloc_node(sizeof(*acomp_ctx->sg_outputs),
+					     GFP_KERNEL, cpu_node);
+	if (!acomp_ctx->sg_outputs)
+		goto fail;
+
+	if (sg_alloc_table_node(&acomp_ctx->sg_outputs, pool->compr_batch_size,
+				GFP_KERNEL, cpu_node))
+		goto fail;
+
 	mutex_init(&acomp_ctx->mutex);
 	return 0;
=20
@@ -1027,17 +1060,14 @@ static bool zswap_compress(struct folio *folio, lon=
g start, unsigned int nr_page
 			   struct zswap_entry *entries[], struct zswap_pool *pool,
 			   int node_id)
 {
+	unsigned int nr_comps =3D min(nr_pages, pool->compr_batch_size);
+	unsigned int dlens[ZSWAP_MAX_BATCH_SIZE];
 	struct crypto_acomp_ctx *acomp_ctx;
-	struct scatterlist input, output;
 	struct zpool *zpool =3D pool->zpool;
-
-	unsigned int dlens[ZSWAP_MAX_BATCH_SIZE];
-	int errors[ZSWAP_MAX_BATCH_SIZE];
-
-	unsigned int nr_comps =3D min(nr_pages, pool->compr_batch_size);
-	unsigned int i, j;
-	int err;
+	struct scatterlist *sg;
+	unsigned int i, j, k;
 	gfp_t gfp;
+	int err;
=20
 	gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
=20
@@ -1045,59 +1075,58 @@ static bool zswap_compress(struct folio *folio, lon=
g start, unsigned int nr_page
=20
 	mutex_lock(&acomp_ctx->mutex);
=20
+	prefetchw(acomp_ctx->sg_inputs->sgl);
+	prefetchw(acomp_ctx->sg_outputs->sgl);
+
 	/*
 	 * Note:
 	 * [i] refers to the incoming batch space and is used to
-	 *     index into the folio pages, @entries and @errors.
+	 *     index into the folio pages and @entries.
+	 *
+	 * [k] refers to the @acomp_ctx space, as determined by
+	 *     @pool->compr_batch_size, and is used to index into
+	 *     @acomp_ctx->buffers and @dlens.
 	 */
 	for (i =3D 0; i < nr_pages; i +=3D nr_comps) {
-		if (nr_comps =3D=3D 1) {
-			sg_init_table(&input, 1);
-			sg_set_page(&input, folio_page(folio, start + i), PAGE_SIZE, 0);
+		for_each_sg(acomp_ctx->sg_inputs->sgl, sg, nr_comps, k)
+			sg_set_page(sg, folio_page(folio, start + k + i), PAGE_SIZE, 0);
=20
-			/*
-			 * We need PAGE_SIZE * 2 here since there maybe over-compression case,
-			 * and hardware-accelerators may won't check the dst buffer size, so
-			 * giving the dst buffer with enough length to avoid buffer overflow.
-			 */
-			sg_init_one(&output, acomp_ctx->buffers[0], PAGE_SIZE * 2);
-			acomp_request_set_params(acomp_ctx->req, &input,
-						 &output, PAGE_SIZE, PAGE_SIZE);
-
-			errors[i] =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req),
-						    &acomp_ctx->wait);
-			if (unlikely(errors[i]))
-				goto compress_error;
-
-			dlens[i] =3D acomp_ctx->req->dlen;
-		} else {
-			struct page *pages[ZSWAP_MAX_BATCH_SIZE];
-			unsigned int k;
-
-			for (k =3D 0; k < nr_pages; ++k)
-				pages[k] =3D folio_page(folio, start + k);
-
-			struct swap_batch_comp_data batch_comp_data =3D {
-				.pages =3D pages,
-				.dsts =3D acomp_ctx->buffers,
-				.dlens =3D dlens,
-				.errors =3D errors,
-				.nr_comps =3D nr_pages,
-			};
-
-			acomp_ctx->req->kernel_data =3D &batch_comp_data;
-
-			if (unlikely(crypto_acomp_compress(acomp_ctx->req)))
-				goto compress_error;
+		/*
+		 * We need PAGE_SIZE * 2 here since there maybe over-compression case,
+		 * and hardware-accelerators may won't check the dst buffer size, so
+		 * giving the dst buffer with enough length to avoid buffer overflow.
+		 */
+		for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k)
+			sg_set_buf(sg, acomp_ctx->buffers[k], PAGE_SIZE * 2);
+
+		acomp_request_set_params(acomp_ctx->req,
+					 acomp_ctx->sg_inputs->sgl,
+					 acomp_ctx->sg_outputs->sgl,
+					 nr_comps * PAGE_SIZE,
+					 nr_comps * PAGE_SIZE);
+
+		err =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req),
+				      &acomp_ctx->wait);
+
+		if (unlikely(err)) {
+			if (nr_comps =3D=3D 1)
+				dlens[0] =3D err;
+			goto compress_error;
 		}
=20
+		if (nr_comps =3D=3D 1)
+			dlens[0] =3D acomp_ctx->req->dlen;
+		else
+			for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k)
+				dlens[k] =3D sg->length;
+
 		/*
 		 * All @nr_comps pages were successfully compressed.
 		 * Store the pages in zpool.
 		 *
 		 * Note:
 		 * [j] refers to the incoming batch space and is used to
-		 *     index into the folio pages, @entries, @dlens and @errors.
+		 *     index into the folio pages and @entries.
 		 * [k] refers to the @acomp_ctx space, as determined by
 		 *     @pool->compr_batch_size, and is used to index into
 		 *     @acomp_ctx->buffers.
@@ -1113,7 +1142,7 @@ static bool zswap_compress(struct folio *folio, long =
start, unsigned int nr_page
 			 * non-batching software compressors.
 			 */
 			prefetchw(entries[j]);
-			err =3D zpool_malloc(zpool, dlens[j], gfp, &handle, node_id);
+			err =3D zpool_malloc(zpool, dlens[k], gfp, &handle, node_id);
=20
 			if (unlikely(err)) {
 				if (err =3D=3D -ENOSPC)
@@ -1124,9 +1153,9 @@ static bool zswap_compress(struct folio *folio, long =
start, unsigned int nr_page
 				goto err_unlock;
 			}
=20
-			zpool_obj_write(zpool, handle, acomp_ctx->buffers[k], dlens[j]);
+			zpool_obj_write(zpool, handle, acomp_ctx->buffers[k], dlens[k]);
 			entries[j]->handle =3D handle;
-			entries[j]->length =3D dlens[j];
+			entries[j]->length =3D dlens[k];
 		}
 	} /* finished compress and store nr_pages. */
=20
@@ -1134,9 +1163,9 @@ static bool zswap_compress(struct folio *folio, long =
start, unsigned int nr_page
 	return true;
=20
 compress_error:
-	for (j =3D i; j < i + nr_comps; ++j) {
-		if (errors[j]) {
-			if (errors[j] =3D=3D -ENOSPC)
+	for (k =3D 0; k < nr_comps; ++k) {
+		if (dlens[k] < 0) {
+			if (dlens[k] =3D=3D -ENOSPC)
 				zswap_reject_compress_poor++;
 			else
 				zswap_reject_compress_fail++;



Thanks,
Kanchana

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
