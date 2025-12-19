Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E32A2D948A;
	Fri, 19 Dec 2025 19:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766170862; cv=fail; b=QonVOKWwSV7ZxctAYEtvHlh78Q6RW8v3zRQWIFgYVCO9HcuuMAlyYSB3nsYmarvMdg0BLsXiIiHCtHK4O8ij0BsQSBEcMMib/6JA1QzLFW5+oked2zeRhAkO02fE9xfL2Hl2qPszTBxXo86O1laUabRMKZwzlowD1HsGX4wD+fc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766170862; c=relaxed/simple;
	bh=z0g+2UyS4kMVDCdgbnoDnPhrO/yURY4l3WpJtcx+s0k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ljZc4k81I5ERm1oAdQn0+9cG6mtq7CP91cn2Of6xCoh3qL8EPl0+4Hrs+h8nxEvUUNOLXzLi6NGmbe4ITD+rls+9R3DtjGLXwFwjOPow/a7xKs5Cw+JQ62lcXrnFXkM74M6WnRGZzf4AyLUt2yBINy92Bqcrimj2ZpHfQW8v6L0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZddBdsk7; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZddBdsk7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766170860; x=1797706860;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z0g+2UyS4kMVDCdgbnoDnPhrO/yURY4l3WpJtcx+s0k=;
  b=ZddBdsk7bG9bYWsUEdNAALVI237ZxIOrCSc6j79yuvztBNTfnqPFExVK
   bQLvR8d1/Cu7H91tixYCuAP1loNTkOi01bkjKJAcmkzRD2tFi0mrhjx4v
   eBX+O7nyBuQPBC6AQEB4l2GX/1OF/iwR+G3UqsggeNt3xqCTWtwUT2FPa
   iLf0gh+VUrfLHfuOX/ptbfiLjLZsDAJfPdxc5e4y8NzmSacrjGFEIG6pl
   aeoog6QW1tybG3Nk6DNuVGXSesR0OR1yPRzGUyLkdzjQhIP0PJSIPRJoP
   PKq3jEC0Tf/3bmzSqpvPbGEf7Z/RNv48OKQn2z61sFYMuBcCLQhqEm9sM
   A==;
X-CSE-ConnectionGUID: 9E4UnVmsTXW68qsm1NW+BQ==
X-CSE-MsgGUID: gloXluUVQfazXb6ZyttILw==
X-IronPort-AV: E=McAfee;i="6800,10657,11647"; a="93607685"
X-IronPort-AV: E=Sophos;i="6.21,162,1763452800"; 
   d="scan'208";a="93607685"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 11:00:56 -0800
X-CSE-ConnectionGUID: BUJgqos8RrS0u3w/Kv18nw==
X-CSE-MsgGUID: bpCAevtwRJC+BpmDI9b26g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,162,1763452800"; 
   d="scan'208";a="198088298"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 11:00:54 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 19 Dec 2025 11:00:52 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 19 Dec 2025 11:00:52 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.27) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 19 Dec 2025 11:00:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O6uA7e3R7UNrdgw0Mxe/Zk7IiQm7WaLG3HdoivEWlCFv774hpD5oWyPGKjV3inWjWxisJfS9sjjgnAOCSrEJ4r+RcENIX89ZON66tQ04ize/hCYFpNSc5h1IIRamUEYDVI38UpdgbTEI7zlcNKVWqPP+xS+1odb/kRv1NlrO3i/RYj6LdRAc2Z/3+FtgjqrFM5jFBfriT+zBeGxtsuuFDAzbyTqa/XfdD5kfKa9fJJxUfofREpPirvIhldzzHtwnuHKbfuq3DAUkvgqAtHnT8SiUW9ut9cfG6d1WrVAGw7sIZsSwqCVLLl5EElvjxnQnV8wfzh8xa6Wxh2nXoumNLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/v7kBfojtfDuGTc/kHP587jscN1uMGq0b0n68JQK4co=;
 b=xZ9gOdBecaU+0cKRSODGaJQ+2bvWhMTe7If4+lAriPXcfddNLU/I+SU9MGGDyLZhVxv7PFfWoZM6SPfe/UYAHEbzfOexraV8FjNHgZLe9xqmBT0THeLm7LcF9BEIiGVn+1OI1lzXLSU12Byc+dznUuWkPeH10DfA841Tl7upVdwqHMPuKDLJ44LxKdlMt9/ErLOaDQdVd4tkqEHGd8IQs2mS5zub2KOU+7c0ZLlvzO8aRh9+ATiMn/hZLFbiunJcYtOCF6LNg+C0UWHxzE0JiZsw1rcF7NRsyzS6Q+5VnsSVUywn91NsW8mggrGREP12zJn+btRPgkQjfIxquJHUoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by IA3PR11MB9038.namprd11.prod.outlook.com (2603:10b6:208:57a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 19:00:42 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 19:00:42 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Sridhar,
 Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH] crypto: iaa - Replace sprintf with sysfs_emit in sysfs
 show functions
Thread-Topic: [PATCH] crypto: iaa - Replace sprintf with sysfs_emit in sysfs
 show functions
Thread-Index: AQHcbZP4BPg9WydYiEyxorrgPrrByLUpWAiw
Date: Fri, 19 Dec 2025 19:00:42 +0000
Message-ID: <SJ2PR11MB8472C7611888CAB6F21C8CE1C9A9A@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251215072351.279432-2-thorsten.blum@linux.dev>
In-Reply-To: <20251215072351.279432-2-thorsten.blum@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|IA3PR11MB9038:EE_
x-ms-office365-filtering-correlation-id: c7094c80-dec0-4acf-2693-08de3f30e8ae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?4skrxwQ9ws5nje9VlqaPsR4iB4RPFOVH1tqVj0RTLd73LufxVI6m9UW3Ug29?=
 =?us-ascii?Q?X2B/TWWdV5Nqzu5TGidBA0qTwRGfHEfMJEYN0FFbef06rWiWquoGvv7pozEE?=
 =?us-ascii?Q?A01CupvDeSUa3hldd8kqGino4strO4ZtjYWThTRZoQqIzg6r1hS8ycKzEB3A?=
 =?us-ascii?Q?+PBQa+Czh43PGBXHp9BiDmpo40zk0iY6hGWXrzq1m6PMu2koLirlmb4wxnHP?=
 =?us-ascii?Q?iV70br4bFPrC++W7MKWFqGWXsa8XPKIpY5AeapAp+QouE16gMThjQhu6zx45?=
 =?us-ascii?Q?ZX+l1dLDec1fL43IjY/mjscqTdXVnJGHAdlJMXdpojAKd86v5fFIWxBvNDkX?=
 =?us-ascii?Q?cUEcUHZvmyLq3r8oJk9dAzLlzPNH4PxZzg8fziT030Oo/M+k5DxWE5LR3hv3?=
 =?us-ascii?Q?UTf17Y8wnoL2UN4X8AEjIBX9RQ8rsOwY3tm+NmcB/8WHnquYjXfsBmMTViYm?=
 =?us-ascii?Q?uwQcnZlGIqpS7oGeH61Nub+Uy7l17TNDxtSns+NZ9WmDQQESc/ivgS01unxC?=
 =?us-ascii?Q?r4+DdXXEiVnFTWq0m9qrmyqXQHPBdI90qfRKMl+uJWCgVHwP3ekSijZ4ACf/?=
 =?us-ascii?Q?zSHSW6X8nkziIdovRMEr3XycFifjP5ylqHmFjabz86KvxSptIjciEMbWjWeP?=
 =?us-ascii?Q?yUN08vVRztNmIY1kclWc6ewhDF4EohYso9ADlsisXXRTcxmULjO6e+DQO40i?=
 =?us-ascii?Q?IDcv5szA12SDg+dLyk2wLBtLg+xysyVhD+Mv9Rm79O5UCMNLS1TAjtqhWKEc?=
 =?us-ascii?Q?ms2OL+T0MMmiejQb1MnrPn/nS34XOiVpScSiI5IshDMvhEA0TKivXAVNLaZ9?=
 =?us-ascii?Q?x3ziW4ScWm0esFMd1N+DV8Hv9Z7wpZd056ngomTJdhrZYE+wPLq+HyJbr1m2?=
 =?us-ascii?Q?FGPRF/grdk6jFoRnnZQNYAh60/7fp1fFyxNhKmY2nBozAi2YdJNZBjezdrNF?=
 =?us-ascii?Q?5txMWI6EpTZUAHlMUJV7gTHPAgYzxaNqg33YWayHMvKM8jYt/a1U5tumx/xy?=
 =?us-ascii?Q?WnDvtOm3e0uyvrcYUHcsNDvVrhHo0QR5bYJsbMtVvfVNVMwTUDwr/98MKP6S?=
 =?us-ascii?Q?5k0tQg7dolCEcgeDrc709IVlSF4x8TmiGEEAH8/xcr84HnS9j8EB2+RDLKae?=
 =?us-ascii?Q?IT4wXOesUAC6VO4q7ccUFJ095RpQRvfMT130/lZu6lmowC4Tj2owhfYImIrk?=
 =?us-ascii?Q?qOFFlC8sncrEhEZ1EHQb29Y52weYIZI4cFwSleF9JaoK0UxvgBVGwYJzZCkn?=
 =?us-ascii?Q?EccrVqOss+bbMw5CEMYEQRtHFg2/AZvKj5/YMBWnWrC8uwLSCgiqqyg/0ysT?=
 =?us-ascii?Q?isd1NjP84q7FP1SabT7fPKCFhZH/O6/07nngPyHaayZS85Bi8mPnbVcDxpLf?=
 =?us-ascii?Q?oZWAzPDbyMC4CKEPf+Sms0qMv/Gy3Z9fg44qL2vglQMT5Fe8/zCEQD0WDc82?=
 =?us-ascii?Q?+JELwPYDS9NN0MxKea2KS9dcr7VYbXZ6SUNgIBM7obYkmfc0xYkfgA7RIOyx?=
 =?us-ascii?Q?2VFF7Wf4opDLGHfzrEcAvy/uDKSk+hZC+0a5?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1udvvKAWtbq0Ik0a/iB4v1rJvqs6acQcQwZ5Fe5WoadJzRQcBPHiDgAAEFlG?=
 =?us-ascii?Q?d2TGqai9+faSvw5PmdgsxPeN8wJJ4tlM9XO2d39rbe41dp+9E9d/u6A6VCE7?=
 =?us-ascii?Q?GYcduy2jqxys/gGEvVIVpDUEDaQzEWHdco1DrJLvAe3Lg17UMtdPTORlfXX5?=
 =?us-ascii?Q?ZU8YEUQreFcYpZkD4xyrNcyL8E6UOwdKIUauil52fOTx3R4n+kDNXxzMVl+G?=
 =?us-ascii?Q?oD8LezlQiy88Kje2zIMEMa8FjuPviq5qD43k/UPtoe2GdRZDk9gKAwoIqL2w?=
 =?us-ascii?Q?A1yBL0QXelREsbNkbEMVYs0nDmzaOq1OkcWWGdGc/wlJNxNELTgoQ4G59l75?=
 =?us-ascii?Q?Jj2jGQV0lK8a0G4P4mLAyu/U8nTSTdpYi27C4NZl8KMPupKY8/24vtQ7G9W1?=
 =?us-ascii?Q?mPYjS8BvaACdHcDhQD4D82DhL0zwgjSiAAEt42vjxt0QIHsSrA2Tpwj3w7qV?=
 =?us-ascii?Q?zdV+xxImmBIkEAIwVsJIPu+s34gw8PKBI7E2CbC5H2+bMaW3Scq/evfqZpx2?=
 =?us-ascii?Q?zmSnf2VT0wKTmPuS/9rlghq08RjfDbMfDTWXiMnjznToKVeqZODNdrKqGk1R?=
 =?us-ascii?Q?fL89yjOixHrl1DGKm9ej61dHmsNU4x/KPmEtXQKoxxADE2UxqVCWdQtyWx21?=
 =?us-ascii?Q?07tXzgBp28y3wTIINoPJ4BhDOUbftSCv9meU1NGqcU0mIq1FaJsx/VmCEOGr?=
 =?us-ascii?Q?+9qZQAla1E3gf+DccQBmwSnHxPEpsyMFNqzrRCze4AEHw1tING9R2jUc4vJE?=
 =?us-ascii?Q?CXQtlmeIJSAXFX90n3bNp3nlunszgoSGBTLFivNb8HXEaCvkCOSWFt7MoQ++?=
 =?us-ascii?Q?pCZ0JawZiDVqUSyuOB7Dlmq4v45fSb/PSoQTQkY+QBjPS/N3uFBmbfxf0nPs?=
 =?us-ascii?Q?43mDtHuH0x0MY1yDJJOMmWDjPO1pJ93L0iRa9wir2LhetKNyeheePA6RrNh7?=
 =?us-ascii?Q?EdPeQhPEysuXeP33UGgStVsS80DlFSpn/5gO+g61eNc95If3x6Hj49e6lCDg?=
 =?us-ascii?Q?2wBhteP2Hhf9SwNmgYDd5KROj6nE4ZaA7d/Nz5mS+WKFcP7KccE1a5xKIQY6?=
 =?us-ascii?Q?FzYTizqoCg+fMwG8BMg7t7oYCqvPMepRkmYUSrt3e9ky/LWm+X98X0fcInpE?=
 =?us-ascii?Q?fH3xLRMONauEWf0lfYlwlu9Z/TTTwEwjetcSNeTKfn8P3OSUXycHNmeXWj1q?=
 =?us-ascii?Q?9kzqBdZRtI4PG7ccfGpCi97x1pQQr9Zl7tvEXWz3v/2TtQ6PzPD9BYny3AdS?=
 =?us-ascii?Q?AdosIqV3UfIuDqsMmvyr9/vR//FHrn6JDwBjcsO2S1trD9syPnu2tes+jXg9?=
 =?us-ascii?Q?NNcX0Phi6H+hTKFJU0LaoMnHguZzNCmuURIElZV6kmWDpR+J15Lyp/qERHtR?=
 =?us-ascii?Q?W63uLGRxibivPdi1dtfOWIhaElAZAy05RoRAfVVJaHjOTjAmya2xdPpwqGFq?=
 =?us-ascii?Q?DJU3Y104UUvbI5QVRfX0N5kiRpCm2wCRlIoVhwngm80keiA3qYJFEaJKFX++?=
 =?us-ascii?Q?ZwXRazW3eg0xKyCuoufMe5AdqGc6CzVcqttFIFo8ZMmbDRSJl3FdRMPE7F3Y?=
 =?us-ascii?Q?n26nBWYNsrciYF++3dl4SeOlq8FTCEloNpiNJ6W7MiBAT0XdZ2g3uSzlCuo9?=
 =?us-ascii?Q?6jWW5nCA7oe4wN29dE8dkXAUrdXA5ks8seaH3Uh1Xil3/1bNoLpQ4zgWY51Y?=
 =?us-ascii?Q?CuyDuvy18TBQgefWFNZkPjokbwGvj5kKWR5tq3JyPXGMOZDkAI/3Za5EX1l/?=
 =?us-ascii?Q?d6nRb5CD88Wc1dpm4Z67cJtToN7ayU5nUp9VA26m0pz3VN59YIv/rQ7igm9W?=
x-ms-exchange-antispam-messagedata-1: pNpCrDWMKDC8yw==
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c7094c80-dec0-4acf-2693-08de3f30e8ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2025 19:00:42.6917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 55olOWG/dajCw+Ojco/qYwqlOTIwZOTSTPndxPK8dXhuqW9nFj69pQNEQfMbVEk4h3iGO61tpX2+42WN78jbmKheoVNWrOMfCycKn3tIwv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9038
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Thorsten Blum <thorsten.blum@linux.dev>
> Sent: Sunday, December 14, 2025 11:24 PM
> To: Accardi, Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Sridhar, Kanchana P
> <kanchana.p.sridhar@intel.com>; Herbert Xu
> <herbert@gondor.apana.org.au>; David S. Miller <davem@davemloft.net>
> Cc: Thorsten Blum <thorsten.blum@linux.dev>; linux-crypto@vger.kernel.org=
;
> linux-kernel@vger.kernel.org
> Subject: [PATCH] crypto: iaa - Replace sprintf with sysfs_emit in sysfs s=
how
> functions
>=20
> Replace sprintf() with sysfs_emit() in verify_compress_show() and
> sync_mode_show(). sysfs_emit() is preferred to format sysfs output as it
> provides better bounds checking.  No functional changes.
>=20
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Acked-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>

> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c
> b/drivers/crypto/intel/iaa/iaa_crypto_main.c
> index d0058757b000..9e2a17c473ef 100644
> --- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
> +++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
> @@ -5,6 +5,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/pci.h>
> +#include <linux/sysfs.h>
>  #include <linux/device.h>
>  #include <linux/iommu.h>
>  #include <uapi/linux/idxd.h>
> @@ -96,7 +97,7 @@ static bool iaa_verify_compress =3D true;
>=20
>  static ssize_t verify_compress_show(struct device_driver *driver, char *=
buf)
>  {
> -	return sprintf(buf, "%d\n", iaa_verify_compress);
> +	return sysfs_emit(buf, "%d\n", iaa_verify_compress);
>  }
>=20
>  static ssize_t verify_compress_store(struct device_driver *driver,
> @@ -188,11 +189,11 @@ static ssize_t sync_mode_show(struct
> device_driver *driver, char *buf)
>  	int ret =3D 0;
>=20
>  	if (!async_mode && !use_irq)
> -		ret =3D sprintf(buf, "%s\n", "sync");
> +		ret =3D sysfs_emit(buf, "%s\n", "sync");
>  	else if (async_mode && !use_irq)
> -		ret =3D sprintf(buf, "%s\n", "async");
> +		ret =3D sysfs_emit(buf, "%s\n", "async");
>  	else if (async_mode && use_irq)
> -		ret =3D sprintf(buf, "%s\n", "async_irq");
> +		ret =3D sysfs_emit(buf, "%s\n", "async_irq");
>=20
>  	return ret;
>  }
> --
> Thorsten Blum <thorsten.blum@linux.dev>
> GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

