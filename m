Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF452264C9;
	Fri, 19 Dec 2025 19:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766171001; cv=fail; b=D/kG2wIEnPQOaGrKdrah8NxxnvRJTD8XLZKgsZS0TgNKJ8Df6BzHEwSgXeRKt8w0amLJ9OmN1GXxlAvRerI3o0kJxwWjoCPuthUt4Qyax4aDTwzPYLYh7lArkpNBxSJi915CDRUXoWgKNQsgW9lG2zJYMR92kyY2n1qJtsnONps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766171001; c=relaxed/simple;
	bh=cdNEGPAbPEBS0lISCPcPg+Wj2309c3z0vsoE1pAlwW0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gxivA6Dmzc6nxb2z84ksej6OOQbstdN5wipZFzL9pkk83qRxM6K5ssbyFZvbC7/MbBrFSeTtviuYC2IGbwm3oyHtMQBGm69bRCGZdWBkvXCgb6cJWiYVhmTGjjbUPTby4X80iUqjgNV40k1Vw63nRhA1VVWcbZzXn/g0PGsdMbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AdWEH1ee; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AdWEH1ee"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766171000; x=1797707000;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cdNEGPAbPEBS0lISCPcPg+Wj2309c3z0vsoE1pAlwW0=;
  b=AdWEH1eeWvlNAl6UJi+V8v0qKctKoLi37bVhM45ZhJRMl6WZGQFP/KNd
   0ybOIdVTiPD2IpcxZ9qwu/xutxl7IDT3rWXNwm9WktICql+DW0J3zikHl
   7N/0+hGLaGK/1fhNf+/pMkoxc+5IlSq2I1/iis+ucBuBnwx1o7IJnFnQg
   JA9Tndvpd7zf+Taacrhstjxcw8nqB2JgblqvKmnSwhvE/6jse1DzM0syS
   jXm2/d10Deh0yFStkyBn9Npma+BMs3TNrr0rZTC97/LlpoK8Jw5Aa7Px9
   k7lzzqLbyEge3w406/JWTSFAA9pZ0LmIsbqvwBPbbfuAJEjw6rffKY7a1
   g==;
X-CSE-ConnectionGUID: Jmqx4trKRRuULLMYPAIPKg==
X-CSE-MsgGUID: ZK1xltj9QreIPDXj++Q3wA==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68069261"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68069261"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 11:03:19 -0800
X-CSE-ConnectionGUID: G4T3PKzAST2QAQ0ImhujRQ==
X-CSE-MsgGUID: cI8hV3miQZO9PZF/dEuk6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,162,1763452800"; 
   d="scan'208";a="198516273"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 11:03:18 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 19 Dec 2025 11:03:17 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 19 Dec 2025 11:03:17 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.6) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 19 Dec 2025 11:03:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZH/S4x+qZqxxzdc8OFUi+8Qno5J9CEWp6Z2+bKwWoBHw5pGnxIQNB+r/zBU/cRh8NEYptrNtYICEW39jSmA6mQ2aR6eITKCZeirH/DVcQdgjq3EtwL6nLrK+HkqXD7VTxjaJRrpkKU8W3Ijd/OAyw1+WnVbRZTYQ3JkPcmfEjLNHHnuOH29W2IWL9ETVptvL4emv0FJB/jV+O0I4LWrK3VW01+3IHvlkH+axgtUio2WHFR3vRoXtwWauYvKP5bGodWwSZ+Qpoo2Jwd5k3u/bYXH3ns7Wo/aTZDxczLGnlUNe2piXWDYXa7kPj0gLNQLW7fZ7dR8xe6slMP7fYf3Cww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=28CKRFdTwCS0tzXGdv3IYsWP+3FdoG/Asurd+mwIkiU=;
 b=AvcSAvQ9JJ2U9Rtb8iCg7Il67NS44d4Kf/J1qVjjVG6nPcfhIKZzg4AMwu+x4WzdL1X92Pbq1LSCtxSWMwAUk5wxCSXvJrIcqD0+iotD3Ayj21we1UMh+GyQLXfM6y/lPEiNt+SAsG/94OqDV9N0EpGsAkEWxW0FkCE+0wQUa7STo+GTobyQ9dpXeLSPr8L+y9gLtK6XPmXmwgEGajaL+uvVu+8P9ft2aurvrLC8miO+uIU4jEUY/Hf12F5/IzGXU64fVEfqIKJvNAFOYdUyZmToCBUi+h3AlJuCZBwFQ19vojASWxqqX4BLc+MJsiXXcKl0qG6/Un5z4axSUgGFpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by DM3PPF5AD378C3B.namprd11.prod.outlook.com (2603:10b6:f:fc00::f24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 19:03:14 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 19:03:14 +0000
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
Subject: RE: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Topic: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Index: AQHcTWs0Qo3eNl0w/UamTXF2PMbCz7TxL9wAgAAcuzCAABirgIA3HHXQgADbBgCAADxHYA==
Date: Fri, 19 Dec 2025 19:03:13 +0000
Message-ID: <SJ2PR11MB8472581BC9FAAC1048C6D8F7C9A9A@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <vc65dxjoledwtojbcdgyxh2xt3hhlqrzgxcnbgufji7sgnhkus@fqkcflhwbags>
 <SJ2PR11MB847267511A5B6CF9EBFA1A0DC9A9A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <uqznqihjuyfk3ifyxsjwp6x7nvk2vloinody6fomfuqepfu64n@25yboetztah3>
In-Reply-To: <uqznqihjuyfk3ifyxsjwp6x7nvk2vloinody6fomfuqepfu64n@25yboetztah3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|DM3PPF5AD378C3B:EE_
x-ms-office365-filtering-correlation-id: cd473467-38f6-4f3a-a36a-08de3f3142be
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|10070799003|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?WMVE/FnxR8gcWbLhruv84L4U7Sdv9G4EvMSziwEtYnMd92iZML+ZQ1FuJybe?=
 =?us-ascii?Q?9y5tnXQyiJz2vwDcIL2siWdEVuICQPUDUdL+j5cIrjUMSTDRgr2vU1Easu2+?=
 =?us-ascii?Q?tFRrv626orvIeH5ZR8RonlvBEE9SQ7H6vTReaGtLkpEU/8weCO3UhgFBH3iz?=
 =?us-ascii?Q?2kZ07tIQxrcPgktaqmXGjU6/C27ql/glDcVtSX7ojVA0OviwsYMUomwxyGsg?=
 =?us-ascii?Q?G5WOgegKwWyjMX8yqLwiCeFpQaWsE8fKxicvDtvHoao7gxX5f+hAHQoKXdSb?=
 =?us-ascii?Q?PwA5yVTXsEUYTIH4u7Azmq/cMt1FCqAal2SRQMdIZ9IUrb7GNq0gTOiKQkFi?=
 =?us-ascii?Q?2Bkk7KFbN9ADeDKq0PBMRdw9GjtWZ6vSg/NDfcUjNvjj5atPoahDf1ciLWdP?=
 =?us-ascii?Q?IkZjUVIoWWXIEYhQzyoorErCWlG6kUC7PXj94aqMkqnRoLnLM803BM/KVeUs?=
 =?us-ascii?Q?j8wCfJiIqldeMwwYNtnqwSTDilY7YSTZcpzWmDzUr9LQW8C1eX+W3EaQK4gE?=
 =?us-ascii?Q?jG5jUFAWRKShIwiq+uX98o6/0oYAqBBhkeYdQ5tZn4bQOAsPnUosSCYyYINq?=
 =?us-ascii?Q?MXv2TusY0GXc5e+VR2tXll0v8SN8x+2b7xsakwikuLA7Bnqi2N4CsO0lO+nm?=
 =?us-ascii?Q?kmFeLAvM/v/6AbxCQBWdPFSxu6gJ+GXpiaw0Mnqq2sWYNV4Id4WIppcqgdVi?=
 =?us-ascii?Q?NmJ5Z1ffKb/rkSLzh8TkRoWQRc6nRySjJlAzAvNyXWCxSTr076BPRj7Z/nRf?=
 =?us-ascii?Q?nWxV84mIhYmZqaKsmBbRa9+PKqUIey+3sqNMK3vUXU92otxsinBcXhI/1OwJ?=
 =?us-ascii?Q?ol4EezdT23FWhtaVyTaU+RtD7RmYUzUqRQinZDJvjecPsiaG9KI23l2I5y9r?=
 =?us-ascii?Q?6/snHg8tmAluVRhHdGWp3+jT0Zhrb2k53T+i85zELF76hqUJiEHlcdyk3gdF?=
 =?us-ascii?Q?NYlCpLeRsqe5/SL8+mykQ4d4vMXV6ORmFVyuKpIJW0qindf6quULAosOANAV?=
 =?us-ascii?Q?kQSp+hERGZB9miPGXilXrDCc1LzDciIId1ZujaNWuFA9lNeEm1h1bpgt8T4B?=
 =?us-ascii?Q?O9aeEUX+m9t1HC54Q4MtGaP+xSc8JLljaL4kmTk0Z/4loJMMLFTAVPeWaL8T?=
 =?us-ascii?Q?L2uiMVNzb/pkdCKnRjI1emKiuQQQJ3UYtIAb/LloMOXcXj1qr3GPkp47pMEm?=
 =?us-ascii?Q?mHL7dSHm8nwjRyAcU33Y/ZRdx0e8GWZhduagyociXSHIL9PfsDU89dWmxa/3?=
 =?us-ascii?Q?j9/4dPahVJEtlPOkWHuL6vSWyd53NUX0+ohdzpuERy43I5ocpfehBgv8zTbG?=
 =?us-ascii?Q?GntU1an9R0o1Hd+d3wrJme3TfAFcrwPnLntPJDjO7JZkm6KD6lFwiDCbrWPk?=
 =?us-ascii?Q?rROk4Quy/Nzda9OyVWUnoB8RtyWWJ/MJckvMcUF0rQgdpuwV9KEcCRsWNACk?=
 =?us-ascii?Q?ce9feUQDzXtTIqpX5ceqS2TaSFuKDgfeKA5KbKycYUbSb7sniWYaEtHi3QvA?=
 =?us-ascii?Q?7gLjw24wrZDxC2Z8LbOllrk2dDpZOCdGzk6C?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AU7qsjZLihN8mhLmuD4GwSnZK5rLGzhmtUt8nPL/+2FcyhBYpEJFP2n57X1y?=
 =?us-ascii?Q?oKOmFHF7H1ifMGv4y3DtFr2j36YOauPzW7eOwjRMmOOOxev4qNTEShk+HYGJ?=
 =?us-ascii?Q?SiEfAlCp3qG3rE3zjp/lpXGx/RXHSD+kkUAAOCPqmQ+trlqN49ynX6RnCH2G?=
 =?us-ascii?Q?KPQ8kcZHSnahvN0AcBJ8M8N/NOTZSqavmoG6g2muRpi8xDbQmQUoJKfLYSei?=
 =?us-ascii?Q?iHenmmKn/+1JWWC6bmuljk2CvIdJiEGC4NeLNFE1h57qdXu1PICPJzCPyuJD?=
 =?us-ascii?Q?9G2v5HhtPVttsneCBzJ6VhQKlSlnJeatTnj+bSRF/8+Gjs06c3DSw7B+Qo0V?=
 =?us-ascii?Q?88IBXkZSz7QLR9rJH74VDb1Q1IxJIJ01b3W6iFa++8QQkU12NwqvrKTWHeRH?=
 =?us-ascii?Q?a9kwy/2MnV77LWPYmURm8MWUm3c/PtS3PZOXBe205jnJeidrCwNPLh0xjO5y?=
 =?us-ascii?Q?5cuGOhVqlAgBckSm5FRKXAwyAc1mCY5E6dtQ2y85dOwymoZMLyRETZLJv3TE?=
 =?us-ascii?Q?OXQ4WNP09yN4cHC7zwyWsv8h2Io/JPW7aeDDiqhkXipdzzFcQWEdrUxfTfZb?=
 =?us-ascii?Q?5pNqM6n1TR8YNQ3SknPuew5GiXNytoy8HHfPtxC9j+7Z4MtqZbmT0PKXGDEL?=
 =?us-ascii?Q?8g0iyofH7LZ7I7RThS1bf1pC6m6MvPh6hQXnYaMg0sI+48PaMbWndo8C6voM?=
 =?us-ascii?Q?pmeKkgpRZTQcPIx84gHlShs5/AenrztVkezUcFglZ2sRlPzfvPY6zuoDCxPP?=
 =?us-ascii?Q?ghg1AH0ir31/iS7ZBXqw3IKkDjgdx6NvjmPG92bqVm1slI5CFmKfA/6i4Uat?=
 =?us-ascii?Q?fmZ8R9GOw6Ha6Kx0jugYVVAZR/CNC8nCdOWvUj53GVuqWenoZRG4PhiAELQ1?=
 =?us-ascii?Q?mcskcWsBBI0QYSbl3kyWTlqmVqvTpxNhjI4qLcNOfxXSG10DM7rWS+S8uNxW?=
 =?us-ascii?Q?Xkvt9bVg11aN4ZdpoVnmifHwMXtRUO2g/h1QtGjOjOKQ2/DtJTra/GhBC7co?=
 =?us-ascii?Q?UajrCsTJ+dxH52V8VW1reTdeRumzfvd5SYngt33giFkkieYLfeuwSyFVmeNb?=
 =?us-ascii?Q?2yjBli0C3UiyIZlA/KgXJNqh7n5yWkeqm/9gICx3Dm68fWwcrLX2piGwVIz3?=
 =?us-ascii?Q?Ys5L3jkXhy2CTSdyqSh+f7ZViY3CnWNoBZFFJlkIYt50qVUMhYiPV4l+OBdJ?=
 =?us-ascii?Q?qWort4c3Eo34KA9aRXwRqeYbG/rKurdjlMPY/kHMMaw45zEwoOfH5ST8+D6F?=
 =?us-ascii?Q?nAvjBzbrPs2QaE9KaB7tBBVuEvIhSQHqepGZ5hc46spJur9O9P5T4s+r0KvZ?=
 =?us-ascii?Q?CMCVyb7JuHD5j0pYuQ/dS0GANA9Pk3R/GcNGXtwfSfv4g7r6m4RU/TAVFU6a?=
 =?us-ascii?Q?JUujtnUbZb4CL7I/aK7Fn3FPnW1IM42U+7UZxinaILXDwKeAX2GtNWl+jd+u?=
 =?us-ascii?Q?FQOA2lbCOiqdTNcTkYhf7jWvqKeU/IYCYDntNWI7sP1fg0ehtst8Eb1jqOSW?=
 =?us-ascii?Q?vI7+dRFWzHQOg1+qT6DlZ1vxOYrYdA3XRYS4Ec/RRdXlH3IKI1dPyDKXRxme?=
 =?us-ascii?Q?ToySxka433pConDPBuk0r+9YWvHSPd0nFcIku5uiUxSoRw5NHw6BMXpPF6dx?=
 =?us-ascii?Q?oQHytqcXe8Ck0AL625nR0qan2MMifYH7WTytZkuIFWJ2CmHw1dbwitChNfoO?=
 =?us-ascii?Q?lewlaDjEnel4t6ewheQ6WUP797no2WQfR+uiYnOx1mJVbuquiFIBn1C321/U?=
 =?us-ascii?Q?3farXturLedA7I4156t67Q1MsSRIa62uR2yZsuvF8ntJ38hJxzOF6bEdQW9n?=
x-ms-exchange-antispam-messagedata-1: TSeLPg+7QKmzHw==
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
X-MS-Exchange-CrossTenant-Network-Message-Id: cd473467-38f6-4f3a-a36a-08de3f3142be
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2025 19:03:13.8902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CAk9f3WGIltThFT1DWhNcwTvlPOU8BJVGqT/AAwpyLjjJPIxPYH3sKKsEb79wKOQ00zJolktCo/wANxrMW3JfsU/7/SuBCqWs/ZvfgZALPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF5AD378C3B
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Friday, December 19, 2025 7:26 AM
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
> Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> compress batching of large folios.
>=20
> On Fri, Dec 19, 2025 at 02:29:15AM +0000, Sridhar, Kanchana P wrote:
> >
> > > -----Original Message-----
> > > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > Sent: Thursday, November 13, 2025 4:46 PM
> > > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > > hannes@cmpxchg.org; nphamcs@gmail.com;
> chengming.zhou@linux.dev;
> > > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > > <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>;
> > > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > > <vinodh.gopal@intel.com>
> > > Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress()
> with
> > > compress batching of large folios.
> > [...]
> > > > > > Architectural considerations for the zswap batching framework:
> > > > > >
> > > > >
> > >
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > We have designed the zswap batching framework to be
> > > > > > hardware-agnostic. It has no dependencies on Intel-specific fea=
tures
> > > and
> > > > > > can be leveraged by any hardware accelerator or software-based
> > > > > > compressor. In other words, the framework is open and inclusive=
 by
> > > > > > design.
> > > > > >
> > > > > > Other ongoing work that can use batching:
> > > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > This patch-series demonstrates the performance benefits of
> compress
> > > > > > batching when used in zswap_store() of large folios.
> shrink_folio_list()
> > > > > > "reclaim batching" of any-order folios is the major next work t=
hat
> uses
> > > > > > the zswap compress batching framework: our testing of
> > > kernel_compilation
> > > > > > with writeback and the zswap shrinker indicates 10X fewer pages=
 get
> > > > > > written back when we reclaim 32 folios as a batch, as compared =
to
> one
> > > > > > folio at a time: this is with deflate-iaa and with zstd. We exp=
ect to
> > > > > > submit a patch-series with this data and the resulting performa=
nce
> > > > > > improvements shortly. Reclaim batching relieves memory pressure
> > > faster
> > > > > > than reclaiming one folio at a time, hence alleviates the need =
to scan
> > > > > > slab memory for writeback.
> > > > > >
> > > > > > Nhat has given ideas on using batching with the ongoing kcompre=
ssd
> > > work,
> > > > > > as well as beneficially using decompression batching & block IO
> batching
> > > > > > to improve zswap writeback efficiency.
> > > > > >
> > > > > > Experiments that combine zswap compress batching, reclaim
> batching,
> > > > > > swapin_readahead() decompression batching of prefetched pages,
> and
> > > > > > writeback batching show that 0 pages are written back with defl=
ate-
> iaa
> > > > > > and zstd. For comparison, the baselines for these compressors s=
ee
> > > > > > 200K-800K pages written to disk (kernel compilation 'allmod' co=
nfig).
> > > > > >
> > > > > > To summarize, these are future clients of the batching framewor=
k:
> > > > > >
> > > > > >    - shrink_folio_list() reclaim batching of multiple folios:
> > > > > >        Implemented, will submit patch-series.
> > > > > >    - zswap writeback with decompress batching:
> > > > > >        Implemented, will submit patch-series.
> > > > > >    - zram:
> > > > > >        Implemented, will submit patch-series.
> > > > > >    - kcompressd:
> > > > > >        Not yet implemented.
> > > > > >    - file systems:
> > > > > >        Not yet implemented.
> > > > > >    - swapin_readahead() decompression batching of prefetched
> pages:
> > > > > >        Implemented, will submit patch-series.
> > > > > >
> > > > > > Additionally, any place we have folios that need to be compress=
ed,
> can
> > > > > > potentially be parallelized.
> >
> > [...]
> >
> > > For example, you should remove mentions of ongoing work and future
> work,
> > > simply because things change and they may not land. Just briefly
> > > mentioning that there are future use cases (with maybe an example) is
> > > sufficient.
> >
> > Hi Yosry,
> >
> > The mentions of ongoing/future work were included as per Andrew's
> suggestion.
> > Hence, I would like to keep these in the commit log. Hope this is Ok wi=
th
> you?
>=20
> We can keep them, but not in the detail they are currently in, and
> avoiding mentioning what is implemented or not implemented yet because
> it's not very relevant to the patch imo.
>=20
> So maybe focus on the fact that the compression batching can be used for
> other use cases like batching decompression in zswap writeback, batching
> compression in zram, batch compression of different folios during
> reclaim, etc -- without going too much into detail because these details
> will probably change when these extensions are proposed.

Sure, this sounds good, thanks!

>=20
>=20
> >
> > Thanks,
> > Kanchana
> >
