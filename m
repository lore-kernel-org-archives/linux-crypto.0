Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E83C1B87CA;
	Mon, 25 Nov 2024 20:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732564993; cv=fail; b=dG3CeG4SigNkyFhEfYRJEnnEjFR09RA31uf8kGquToTjNeS53kf6dLD1CRLsbpagVpFOsO88nMiRNf8or2o7W+nLQD5pf56Ea3kZQeAXRGsZoJ+cm7XmW7/ZQqADAbh89hh4gXsFNa69t1uG57b7u69WtG9bdN+xMTIE5NX7BJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732564993; c=relaxed/simple;
	bh=qsYPtsadr/fkzwt+fwdv9JblOIZdjD2KDigBtVzmrvI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gwjwbiWXqi0reYvprluA2Mn9CXkm0c+y4ghVbjvl6oIIHFzRYcYFU7N3uorV/yCoR4UrpZloVqhTpbvZDKfUzpFp7GieqGm9RYxUfR4tCl8oL3+A2q5dROBJuKVwBRG+fY1mRNxOe2TnQTGkPgRfkuyxBvIEPzP/EJsaa6UoXLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fcnAu8+B; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fcnAu8+B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732564991; x=1764100991;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qsYPtsadr/fkzwt+fwdv9JblOIZdjD2KDigBtVzmrvI=;
  b=fcnAu8+B8Yp1ODdgtaz2Xf9kGYiCU0QPeuF8zx+ra0EUs0GA/2ifohi/
   7q5x3MpQkM26UdO8xjirP469ldJMkr30foal+tp8wDWRxI0bIRkqE+6BM
   +FWoOBvzeXzsfklFmH2kuh8Ht5RuAy1fmxG2CNRMy6JplWRVLVG2Dclc7
   /HytipqU3vfHDy2qYjSk9VnGonAB8XvqbhEpyvvSGwOESG3pcm/gd86zL
   fVMRI04EmzlUElAhFjtzhL2U3hbt3zf75zPbUi/miaeKdA9Ejf7o4ok9G
   nj/DB5mOJ96ahgonyGOeaiuFsV/y6bMPQSFShEwgTRVK/fKDh1cwAzTrW
   g==;
X-CSE-ConnectionGUID: ZIW6+PgYTiWdTOKEABlT6A==
X-CSE-MsgGUID: WzF3cEXHTAuKkufbgaaqOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="32950655"
X-IronPort-AV: E=Sophos;i="6.12,183,1728975600"; 
   d="scan'208";a="32950655"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 12:03:11 -0800
X-CSE-ConnectionGUID: 2b3AGnQKQvik3ztR8Mhxwg==
X-CSE-MsgGUID: DAM336INS5yYOSt0GifE3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,183,1728975600"; 
   d="scan'208";a="114636190"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Nov 2024 12:03:10 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 25 Nov 2024 12:03:09 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 25 Nov 2024 12:03:09 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 25 Nov 2024 12:03:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JHUbH50VrKAXHHtxszHFILmmZW7mKHpU91NoqCLsTJlD43lncWYbKK5s4UCDtfolJY46g5hhlZwVQlQr0qCBqQcKIBkBgACaOvu8RtARPDFkoahGa96c0zYXGa9EVzMyq4ajLWfhjKCIAJDYZEnQ6hemUty1W21GuqI9W08P/ZzFKTXmSSDc9wlpfQNI1kj7RLW9yXIK7TUEwvwSeCZIYQioynqCG2pgueLFSBN6jOhwcyPo56wIRS9DzQvKA1Qf2Ltg0+VaacukHLopB0HvrlqbkPtVj0jaDHDbjvpRoazTXRZnLXyIkHuA7q77rbJcHT9ADYhBcbaLjOAjTmQRjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qzd7gTmTfJOLekfMSDP0hFWKQGByWar1MSFT/i8nSgY=;
 b=ktM/G2SKwchgkBa3STzzO04/Qj7mxrRaw40xQ/7+2hUPIuV8TLq6k19OgRl0oPVI1kk0yaoQTtPRNR4/QqQzA9U8F0C9mYPIZfT1bctEeF+SgxzJCwN0+1xC0J10TIb6leV1iSmOG5P0cVnrU2x0V+oQdNVYF+aLol3EOsH8aGe6sUs1vdmP/MYNKhKwrvLksse8XKVm8B0ls9wEeSoRENDd1/MdYLiqk28xrVUaEre8xJrReYkzyOgMoIOSikzRH94/GA0EIJGXTTUz64xLlZj/W/yYKXnZ0pOWxjiQw3EFgbB2T9NK5xqsgSxWLbRSgAoihoK03xQCFF0WHXBVwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22)
 by IA1PR11MB6147.namprd11.prod.outlook.com (2603:10b6:208:3ed::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.19; Mon, 25 Nov
 2024 20:03:03 +0000
Received: from SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c]) by SJ0PR11MB5678.namprd11.prod.outlook.com
 ([fe80::812:6f53:13d:609c%4]) with mapi id 15.20.8182.019; Mon, 25 Nov 2024
 20:03:02 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosryahmed@google.com" <yosryahmed@google.com>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"ying.huang@intel.com" <ying.huang@intel.com>, "21cnbao@gmail.com"
	<21cnbao@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v4 01/10] crypto: acomp - Define two new interfaces for
 compress/decompress batching.
Thread-Topic: [PATCH v4 01/10] crypto: acomp - Define two new interfaces for
 compress/decompress batching.
Thread-Index: AQHbPXWM22jcCkeyAE6LgM2tVAM8N7LHv8kAgACul1A=
Date: Mon, 25 Nov 2024 20:03:02 +0000
Message-ID: <SJ0PR11MB5678CAD2BB752D97C770031EC92E2@SJ0PR11MB5678.namprd11.prod.outlook.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-2-kanchana.p.sridhar@intel.com>
 <Z0RE3Bn1WWANGsvK@gondor.apana.org.au>
In-Reply-To: <Z0RE3Bn1WWANGsvK@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5678:EE_|IA1PR11MB6147:EE_
x-ms-office365-filtering-correlation-id: 65a340df-a8ab-40ea-8eb1-08dd0d8c2b45
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|10070799003|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?NJ/vck5yLRkYtuwCoYhllxdxkiI5f9YiW/AvImsdluEcw2JizUpEzT8UvO+W?=
 =?us-ascii?Q?PG00gqNefaxnQfoYLGW9TE7MlDQLZRa3PrpnPgeBJvKtfqKNP1NPQKZCd4Oi?=
 =?us-ascii?Q?oKbEvxHysHL4qptwBL8v9s2pyL/9JErVHhzlEyv/9n519KbkmdwSNFn6la5G?=
 =?us-ascii?Q?/4hpSsf8s4L4DTsmnHgL0IgrAz9//cdDezl8EfjFEZu5SrV7DqO/nxxamGwM?=
 =?us-ascii?Q?A6NnZc0ptUaREPitRUYfZacolyKmNkPV61DZuOWYbjWLBfd+Nxn6V/YCf6g+?=
 =?us-ascii?Q?CUcIEuXrTEMh8lk8nEcjND4tk1E+T+I6B33fl2q+Vkgi1WOQyoJFcoKZ8yN/?=
 =?us-ascii?Q?W737C5s2Wz1jLKr9I812VIKirdKtqhqmnE6MJ/F1Cajyzuu8m2Wu5rJ19R0I?=
 =?us-ascii?Q?YXrUg/3bFbrdVaH+tYb24Z/PiJg48i5mIqcTAi7vi3YRNJBiWCgSi287NrD/?=
 =?us-ascii?Q?og7g5+WqAnNkWelif66NtricKUnDEcChMFwUDpY5O9DeYVVAeYpwVu1wTxL/?=
 =?us-ascii?Q?m4XIkjQbxKBD1ft7nVSZ9kKG6YOvNuSxu86bXCvRClLNoIjAZABSlQSrE4lK?=
 =?us-ascii?Q?DQS+huNdPMHfQVMyqNyu7gkoTNuPh7dRxz34W8VKzytxeHlJbxQ/t20VJkgA?=
 =?us-ascii?Q?spMHTl1/6zULsPs1QM36OUQzIeQyOiAZ/S1Fy3xeAPDMVeTJrE7FQsqo44El?=
 =?us-ascii?Q?ZTSVDvOGxTRG2zn8ruxVV0IGRTJIP4C5VOrozDC2vA9NXdaPErC1mcdcRbnz?=
 =?us-ascii?Q?nVpiGnJrsmMRRhurB3pWwTs91h033hLotHBSrBIuuIFBCHpkXVE/mnY4Of7U?=
 =?us-ascii?Q?pUWaDNfwhGYHyvM4s5OLG9AzWBKOVN1m77+O3vYgjUxUNEdb9ADfkHS5lZEa?=
 =?us-ascii?Q?NmAjG2oUQpQzkI+6PgcsOJzB2TLJhnQw1oWfCjWb0PBXK9/A9QzIKVicjtY6?=
 =?us-ascii?Q?KjstV8lq4nuwplFYeuTTAqoMFz/xdRmmZ8HkYGoI55KGuwvJ6JcDNVrAqs59?=
 =?us-ascii?Q?0qUvWIBLKybtpj5XjMVXXLHJShAWR+NGTyyeccxE77slF8zNRdICMy49SIbe?=
 =?us-ascii?Q?BQFotp6bPSd7LMrt8vGkLbL6UJhvXIt7Pj7ZmjJRsA1eNdRPjXrAxQVjHYCW?=
 =?us-ascii?Q?xvy+hWSaX9ASdIc80vTr0vIeaPSuJXIS1r5BtXP/bbFRo42hlrqZcE6gaFsy?=
 =?us-ascii?Q?IZFq9Km45IB0bcoUh1n7m9GeBDgKmkjTY95W7uWISZMJPWM1GlDgudOqP+nu?=
 =?us-ascii?Q?hhzKwSMsExM+ejticH/LWiuI4K0WnZQP5dy88vI/TMwMGNQRCtIRKcloiXrx?=
 =?us-ascii?Q?IbNZjzTArmXshNPqaY3oNk1bhxXc6USe+tQh3C0QUvrMnpjzohW7Nl2a+glk?=
 =?us-ascii?Q?08bQKZA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5678.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(10070799003)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w32YoqVGpoHFxdhk8i5i+2Uumad9kAmjWaQtYuKvWKhMWWJsowPkdsKxXNXh?=
 =?us-ascii?Q?9oJng+PoHtykyzwlCZqG3K9Wd4UwNYik/7jA4P90+UXVT54HsDdtmFdt0pSC?=
 =?us-ascii?Q?/qk66LzHRRS+EzkkFHRzia1LM+WnT/MBMCtZZVD50Em9NYXGDnoWi80jOITi?=
 =?us-ascii?Q?MnFFwAUxZVwJ3bs6dsnz2UvcWpKApDWH7cf1ZB+qXb+nVVFp4X9imuEB/SQr?=
 =?us-ascii?Q?D/keP3bpmkcnyO8R+MDlUqqNmAPnnDwA+AurksTGTSVFhT/T+op4tlqtWFMk?=
 =?us-ascii?Q?gKoOrcFg+G3c4qnzYsODr06jwR31TohhNzaELq9jdVT74w8gBnPTRnZ/rurC?=
 =?us-ascii?Q?B0p8M8uoZnUR6NvBhv2zaB5DyRI3IQcvTPJD0Fdca5p6QOyN9nSrj+pQNZgE?=
 =?us-ascii?Q?Sp/W/+BJncKp2DKTFQdbHjXTOfX39Btbxi7dKe4NVARnmlxjwpZ665DPARoS?=
 =?us-ascii?Q?3m0j45thK41NnnrU7SNKkNLqFQW2iRLAtP95F3z9r4vLu3DrUdBEhleXRvhY?=
 =?us-ascii?Q?d+8pLY9r1punXJJQzYGh8KC/y25zNyl2H1rb0vm7ajKPii25wLrJDVimHOXl?=
 =?us-ascii?Q?Rt0bMQa4UX+1WPSfQptL4pY7KKo4TQEdRhQ6UYA5Zm9oqNG4ubpTIFT0uLRy?=
 =?us-ascii?Q?NBkoRCKc+vEXqlSvZwc4+f6aAPqzdUE4X8daBgYZjnXhq/XzSOdQhEQQf5Jc?=
 =?us-ascii?Q?g0yW6aCQES/CQR6UrSoXz91BubuO/BtJj12zfPovT+LGLli2AEFaGKIjrmBW?=
 =?us-ascii?Q?m4BOY120AJRE297JHkZFzuzuzjKh5ttVqEYNLzplqBpK88XAUgCOQY4yqlj0?=
 =?us-ascii?Q?Gnn0sHu27gRjfcyYp2QJ/BxiwBg3DOwFvVPd6IiDDQJs5T01XEgbqqmbb2Kh?=
 =?us-ascii?Q?WxejLJzwYExKAiHyjPTse06aepJFa/xsxLzEcUm8owVS7ZI+ei+og4nQHUb1?=
 =?us-ascii?Q?zGSbMyN2rl9wM2VmMbZhzZSjMzxzIeYXj1tesKgL3dkoDzbi8YhB/9T6YMHM?=
 =?us-ascii?Q?HNCiC2jfMyV4XpjVKbNpQP/7jfksMGmZvg8xwOOHheWu68vB2cNQxs1ZdEgE?=
 =?us-ascii?Q?RZxu3co4MNBV1n+CCQNJjPeYBMofT+9QvVMBAADX1hQfd/ThEsMw/uHfvEJn?=
 =?us-ascii?Q?2FG5D7Dl9Wg1uML43hKJVI5orDS/cBT9leqnxjLQcn4ppy4cLosHeumbaAVV?=
 =?us-ascii?Q?Jf3Oo9Aukwf3rAIm2o+AF8GnMd3TOFxPbxzcrU1j+CnVTLjZxFnq7aU1f17i?=
 =?us-ascii?Q?k97o42rnqHx4c7mp6Ft7xpeIejgKMpOSd92cj9AnGdnQysU5blRxJPNAvpeA?=
 =?us-ascii?Q?6bfbcqeknmzBdg3F6Zr8vpFd6ekyQW/MgaEfOEUnZvRJqfR5Cvkk93a8UCcO?=
 =?us-ascii?Q?ByypweWAzDstNF3YTWwnJaaum3JnO+NRsmdoRGiYyFKZhVJH8ggK26WT8bkW?=
 =?us-ascii?Q?NZA/6Og9sjhWS2mWcNWXFBqqVCg27S2Yv+7U6eNB2m/GCN9i6QFA777v/Ihr?=
 =?us-ascii?Q?+LJnga4QuZx8AXPzlQHdZENJd+O70KCFD3rbp72d5RmWQ3jXfsyBdEKs5nSd?=
 =?us-ascii?Q?8JAmq6ckOes9E3o8yZsCPdpGz+Rp4PcP4zAk9pJrl4u3l3RMQ59jMNbCxI9D?=
 =?us-ascii?Q?sy0G6PEF5dzrUdz1ifhqMZlotidcZH5g7iq9edC1wqiyV0L9xIhH31BSkW4G?=
 =?us-ascii?Q?Hl9Kzg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 65a340df-a8ab-40ea-8eb1-08dd0d8c2b45
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2024 20:03:02.8686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i6sk+yz3tjlmJiy5yfHUlesIjMfjI0PJv8rbzu784yyWtKgyThyGKf3WwR11ST31EGwC+TaDP6LxDLtaS5tLQm0W1t9NcMUlhYoZpuLZ3+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6147
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Monday, November 25, 2024 1:35 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosryahmed@google.com; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; ying.huang@intel.com; 21cnbao@gmail.com;
> akpm@linux-foundation.org; linux-crypto@vger.kernel.org;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.co=
m>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v4 01/10] crypto: acomp - Define two new interfaces f=
or
> compress/decompress batching.
>=20
> On Fri, Nov 22, 2024 at 11:01:18PM -0800, Kanchana P Sridhar wrote:
> > This commit adds batch_compress() and batch_decompress() interfaces to:
> >
> >   struct acomp_alg
> >   struct crypto_acomp
> >
> > This allows the iaa_crypto Intel IAA driver to register implementations=
 for
> > the batch_compress() and batch_decompress() API, that can subsequently
> be
> > invoked from the kernel zswap/zram swap modules to
> compress/decompress
> > up to CRYPTO_BATCH_SIZE (i.e. 8) pages in parallel in the IAA hardware
> > accelerator to improve swapout/swapin performance.
> >
> > A new helper function acomp_has_async_batching() can be invoked to
> query
> > if a crypto_acomp has registered these batch_compress and
> batch_decompress
> > interfaces.
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > ---
> >  crypto/acompress.c                  |  2 +
> >  include/crypto/acompress.h          | 91 +++++++++++++++++++++++++++++
> >  include/crypto/internal/acompress.h | 16 +++++
> >  3 files changed, 109 insertions(+)
>=20
> This should be rebased on top of my request chaining patch:
>=20
> https://lore.kernel.org/linux-
> crypto/677614fbdc70b31df2e26483c8d2cd1510c8af91.1730021644.git.herb
> ert@gondor.apana.org.au/
>=20
> Request chaining provides a perfect fit for batching.

Thanks Herbert. I am working on integrating the request chaining with
the iaa_crypto driver, expecting to have this ready for v5.

Thanks,
Kanchana

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
