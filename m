Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4731C25BAC4;
	Fri, 28 Feb 2025 10:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736831; cv=fail; b=c+VfnGD0l93qTzcUcpeKyKxD91Po6J9ibf51hn472wU3nlkow1OtRg+U+3TvTqGwz7DYi94rqZXpAQQnqB8IYO8wQwVsDaI92J+IxtNBQKPmGttCJpSKnjfKEI5y06qAwQ4KGF+6N590C8jeMyPhOKZJcYM9J+eC4JE1jg+G/sg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736831; c=relaxed/simple;
	bh=bLx7Mxm3nKUXjssqHql8otq5YktL151u5l60cBZOrkY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=klYdaad4yI+3E+sPtCovoN/hhvaUq50rR+rIg3BHXI5ParjPuq1WJbI2CarAcvN8prk4sXjUfczPoHjOuGrKgGxyYfhGUVteq9CcwxEGxA97veVmhvb0qfCaf0yOgumUnhPOfSyB/dRig5LBNfNJy5FBUfJifPEMvgyRvCiDHhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MCBqOCHZ; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MCBqOCHZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740736829; x=1772272829;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bLx7Mxm3nKUXjssqHql8otq5YktL151u5l60cBZOrkY=;
  b=MCBqOCHZl6XPg6tV8ZDeZyE8CgoO1OKma76LUr9YAkIg5qboIZm9J3c2
   4mjbJVBWQHfXUglQHf7xG6ROYAaOXaDCk6tpzMMRjIxZVCEoA7YjjjE9b
   J/CNIn7WoHiSwvHVblB22bHcrllO3W8TymhGr9SXfGVs+AbTTX7P5IEl1
   uqj44tYsXEnBoGvHNoRO9LgZNc7kUKhXCt2uWwvp5SIjCiMKt6gGxkP1D
   uAsYoBu+5My7E06HeagocDPrr7ynmHKbYg8mYqL3MrlPBfgy3bLQoIL/n
   sOYlL8ckyPJS+SfYv7akw8nfVI9M8e/S8T1/YmaZFlyFYXHsmsQBIW+J9
   Q==;
X-CSE-ConnectionGUID: JNHUO2jGSie3lTm+pwJ9Bg==
X-CSE-MsgGUID: uRAQp7Z/SR+G4OcZ13olCA==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="41783667"
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="41783667"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:00:29 -0800
X-CSE-ConnectionGUID: mckXF2ajSDOksG1oy5T8DQ==
X-CSE-MsgGUID: 2PafbR0yQtGIoiky/V4O4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="117962439"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:00:28 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 28 Feb 2025 02:00:27 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 28 Feb 2025 02:00:27 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 28 Feb 2025 02:00:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LpwG3ECjg4Y28NG/I5IRYifqXxt4y4iQoB5S4MhCqtNmdM7NaovJ/UT4wYht6r6oIaoXYSbC/v7vkeIEFru4fQ38495HJg/b2tiKWaLi27IKue3+zqBvmkRMSX+mTT+m5gjJ3p40YkDRDRH+f3Sbq18q4pEflxyLtOQtuVUZza1qBZyiloZKfHhd1rQPEhPnWxEWjd++1ZL825ChfxwgQ6tIzmoDnNO6RTzFJJUEcX6O4JwwNtCw5l/+0tuLwqYUjNiA8gCMhEKxiR6DkGzRz/vZitC0Jzi4ljpEpeVUjTQ77XD78wcLpqrPT3HCWb9eoZprqB7EWaUIz/cIUFqBzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZPs92JKKgDjn8OUxVwwG95uNqELgAH6JaojZGhR8Qs=;
 b=V9EMKqxDteljiwxSxMkusikF2UTta3iOwT5pXMIqCetQafCEyriYmeRdASNZZdBTNOpIqwoYPK/nd5ZU8Xj71o8PXrP76xmreFKClgyONPnZQlDQsQ3BzBaJeaIA7B0QGerAQqfd573N/+bMfScFGCTyPbQe1rMv2WHwY2dl+Bd5y6sPCVgHLGKKD6BdCZ4FwXafV3FBJ2Fe00xm+esb34/es8A3/XlzH8/Tnk+KUmAWotLVV0j8xhyjn1l6fsZfSbVGa/aovwvu7glQnmmN+gr8idu2bzQLlo96VS4jemRuXB/perng2k8CZMyMTkPrtqaj+Nkd5KKGeywz4k9CYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8120.namprd11.prod.outlook.com (2603:10b6:806:2f3::7)
 by PH8PR11MB8287.namprd11.prod.outlook.com (2603:10b6:510:1c7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.23; Fri, 28 Feb
 2025 10:00:18 +0000
Received: from SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c]) by SA3PR11MB8120.namprd11.prod.outlook.com
 ([fe80::3597:77d7:f969:142c%5]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 10:00:18 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
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
Subject: RE: [PATCH v6 02/16] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Thread-Topic: [PATCH v6 02/16] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Thread-Index: AQHbeGe+zOuYvdosaUCOhMN63I5I/bNJcWkAgBLs3YA=
Date: Fri, 28 Feb 2025 10:00:17 +0000
Message-ID: <SA3PR11MB8120161A21D2DA07F23B9392C9CC2@SA3PR11MB8120.namprd11.prod.outlook.com>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
 <20250206072102.29045-3-kanchana.p.sridhar@intel.com>
 <Z7FzTLPSrnixkvGQ@gondor.apana.org.au>
In-Reply-To: <Z7FzTLPSrnixkvGQ@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR11MB8120:EE_|PH8PR11MB8287:EE_
x-ms-office365-filtering-correlation-id: 9ca5934e-5795-4272-04d8-08dd57deb48c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?r3xzWsAADCSKpdZCc9b1+sRmHVgg/stI5JoWureWfHBiRJ8cM0JHChvUIuAz?=
 =?us-ascii?Q?L10zYSzGAkGCvxaO6OC/CsXamXDivdKTPbNk0/h1r1J8JLT2QlbsciiA0q9l?=
 =?us-ascii?Q?n5njyOip36PAec/+pEZogiRxaaGXVFHZdoDQhTWw7zfjGfnc2zW+NQ/kAMV4?=
 =?us-ascii?Q?WNVuQnbe+ASStWMkYeE8uYmftDhC1hojbltB3GJp65oEQlw7+7JumTWCpQl2?=
 =?us-ascii?Q?ImK3kNo/gxrKgBNTxCijXGpOXeZwavXLzHqdErxgYNFWYUmmZ1tGjQTsrTEZ?=
 =?us-ascii?Q?/Fa2M+KVR+iwL52mFZiro3lVf6MBIZMlPMDQq13/4nwSm6qL9KeUkqzGRoYM?=
 =?us-ascii?Q?aYCd9e+7z0KpfVwbCHm2nslHfj0K7NxpZ20WK86Cz07KTDKMwnHHvQCjNGNn?=
 =?us-ascii?Q?xAiJomCjiexUKRU7OOC4uk+BgWgljv+KVjlg1ggQfcyBBo67tQDVBJJSTWYE?=
 =?us-ascii?Q?br60EP66+prL3LIsMXRNpTsBCU7GEIYxXhhsmPhNdV2VZ13sX74hKuf5+tHL?=
 =?us-ascii?Q?FUA+VBVk32D92QmAf9E1woJyfbqF/zwHexunTlFhrpVwh8PU1pTw5VBY1xOQ?=
 =?us-ascii?Q?zR06TKh7Fl4PJWmteE14E5kWo+V1OYQfRtGnVl5EpdhhSbAAgB9ah7ISAP0e?=
 =?us-ascii?Q?eX6y9cfJhm+TagAKjJl02umb2YZkGmHGRq73tGStPPjy12pLxIq9HJZDU0oM?=
 =?us-ascii?Q?IkWTeT+YenfC/tWCumAZVkcpY7oCXqmuAfE+elpmSYeRbvM07T7gsy2y0JSh?=
 =?us-ascii?Q?+PO4+1MHoqyItzSXZiQqlSnTIWh6QS8eVCZrjxDzutzGJM7tI0mQAlS9M2xj?=
 =?us-ascii?Q?7tzQsLGxkpLMLq7eHUz0IhRkpf2qcbPn+eS89QrqyeAnad5puoMNa18cpEZX?=
 =?us-ascii?Q?Zyx8qzgpim1tmHWUlT6/j7MGJm4XWKSkDIvnn1Dky0elDUGNN805mqn2+Lsu?=
 =?us-ascii?Q?uhR6E59deyTNS4Gm5K86nKkO16/89J2BHMuzJcuC/R7WhR2LUb9xRFBDuZ2j?=
 =?us-ascii?Q?MWLoNdun2qJj0/ZJbIUt3KzVbZdqw3HDq1PrCFn1l2ohDIXnPWlXVqA5LrQI?=
 =?us-ascii?Q?bDed8ePUE0BrdW1jCY3VTt2IHF5QWodi8QtrnPBtGJTU6AG7wpYsH12cYYf9?=
 =?us-ascii?Q?cyI+nt2Wc44Jxremwg+vi7WL6gzwgsy8Yo+bANMqZhjHKlnabI9zAFVwJ31j?=
 =?us-ascii?Q?2XHyDfSy1rqN0aVU1/tjhLdFc8MJlwxIMdd4EBsf2psBG/pbQti0A0zfdGeg?=
 =?us-ascii?Q?3Ne8XTgD8neou4YyHy3J3MvyT8GX1/YdzBlyhvoL9JvedvGmulX5Dp5tORFh?=
 =?us-ascii?Q?n+q5IQ0Kb3KjuiDFLXq/RVJtXtYQ0WoQZ5KYcX1lhzQewzksSWk4btFMPTR3?=
 =?us-ascii?Q?nXqzWijPG7VQfr41QdkmY4Hlc/sB?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8120.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xqg5rzkRN564WIfee9VJ77/bh8xvIyrwIdYNdLDJmFlNI90csfAu70tZcs64?=
 =?us-ascii?Q?IJyqC1Xj9rcLHL0mjXddNloZQtA0RriFmQ0SdGqLoSMuLWIAXFRkaDQ0kus/?=
 =?us-ascii?Q?Qme2Ma5P8xXyQdu0r1aKQ/d6awEDVLmeaSYYDGSTVYxiWrehzFXrqC0Cq5yw?=
 =?us-ascii?Q?hnOoiq/JhuyL+Qfumk27sIY6AGWRL/HWCQ7g2DCUaJd4DC5bSBKq0bXcu1s8?=
 =?us-ascii?Q?z87qMFBCoHZC9LTFkp9wehhodWFFPxZS15ZW4iAr8kiJNmEcdgDI5a6p4snU?=
 =?us-ascii?Q?LK1px/kAxUD8fATWtiQKwXkEgrUI+PJ7sZZEVCw7Fco5eUUaRDwvZTZfnapE?=
 =?us-ascii?Q?9hNAQvVeFtDDdo1bszkMd/+jLCNgQycR7fCEBjsHm7ClAY9XbQlIpyz9fNfG?=
 =?us-ascii?Q?RtWWKI+H2MrkVdqt+U/duFdLW5NnAAj4aEFXYi7MKeRk7XDx/OsEa7xLpDCt?=
 =?us-ascii?Q?UACvJYqNUVECsg44JBS74lZMZD5DX4sHLY+gneEl6LpEuF2EU7uW856hVInX?=
 =?us-ascii?Q?ZfYig5Kz5/QcZE+D4ZP8vCLugjblDGEu4rqCpku+tQmnUBEVC5yuTr2GcAGO?=
 =?us-ascii?Q?+eUtOMo+qbAgnmn+1xjeFHELCS1IIUSol+ltksUMR/rkFPKVb1WCRXfl5z25?=
 =?us-ascii?Q?5YOtbPG5Bl4uQHcOeuebarBMYYCVUHg/cA/RkgPBJO8TIwhyC9QSesWeb0/R?=
 =?us-ascii?Q?3B4i2oy6bupOlX8B3yaW04UdfOa0lSNR1H7PZvz7Igw4re+wtabNW6qXpfvW?=
 =?us-ascii?Q?0MqC0c9emGOxNKYNRFGHpZ4QugmNxsM0n6mvVkGPnrGafbo3acccNfWiq6JZ?=
 =?us-ascii?Q?9mgjSv+mOgNn4KWZQ8ZAzJWq3TT1lYvu2rmo4OWer7epacz/D0SV9sI6BeXA?=
 =?us-ascii?Q?C9HDnoKwM6AhtuLD9QL8Kr5S0BUS+C3npcHN3LaB4tpcUDA7T1c4RbzreZ2G?=
 =?us-ascii?Q?suBcZlENjVlF69GG1J2ulnuNRFYEnHpRL4nUB4Vq/Vo65gVG4z3HRfJ/mUF3?=
 =?us-ascii?Q?xd1KdfjmI4815cZrNBlZgFHw6zqbew2uQtU2e8z+M7JUjX+rE/6qD5c4IjPh?=
 =?us-ascii?Q?wS3o1i8XA+lMPoEZeUgClpTtyBrpZ2QyJAEaCjzBEnVUukEIIyk7DaY0rXR2?=
 =?us-ascii?Q?wlBuBlfrOHxk6lghvcUYqd313zFxp2t4mRWMLJl7CeIUIK/xJBFVjX8+J9RT?=
 =?us-ascii?Q?sZ/SkCE1/LFVufGo5qtRMkazLGJAuZ4V+c+dQtAdtqmOqAFUPy765A8OJmep?=
 =?us-ascii?Q?YaiLJ3YUqEqu7bM+cxp5Td6aIeIOUcRuS99pRiVjZThp6bDX0cWDbcNZmjnS?=
 =?us-ascii?Q?ZBRs0QIUPI22uij+nNUwMQLY6oqf4NEfTMRwJPTd9CmKpJg7tPgRJvuGJKWr?=
 =?us-ascii?Q?kwW+KreqBCfY2pEXGQ9WaZkIC2j7dsshJtCBYEVX5XEKHbAzDZmetd6vhPy1?=
 =?us-ascii?Q?JsZoAXPvM0RBGwe5zFe5/c38CgJde29xsQnpVMXO+6MTjnQt2LME0A3NSdvK?=
 =?us-ascii?Q?52VG4V8dlQ3mNzJBpVYj49A0KyfhExGvrkzGeHHRgGpTe+hWjORGQe5GGaua?=
 =?us-ascii?Q?iviLJFU4ofyUdV7hbj9Sl9FlqE4Vs2CTD5mvU/QspzbRThXlKfzrLwDRlraK?=
 =?us-ascii?Q?eA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ca5934e-5795-4272-04d8-08dd57deb48c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2025 10:00:17.9615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CbKUersUa4hNuzmy7Tep/VOd6Gss/0b8jH0jpp4+Y/K83XWBsZUDYP0MB8NwJdtsAvq+UOlYAIQ/1n/nulxA7aceThv8gU6rNuX2ao9QHbo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8287
X-OriginatorOrg: intel.com

Hi Herbert,

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Saturday, February 15, 2025 9:11 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com; akpm@linux-foundation.org;
> linux-crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Feghali, Wajdi K
> <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v6 02/16] crypto: acomp - Define new interfaces for
> compress/decompress batching.
>=20
> On Wed, Feb 05, 2025 at 11:20:48PM -0800, Kanchana P Sridhar wrote:
> > This commit adds get_batch_size(), batch_compress() and
> batch_decompress()
> > interfaces to:
> >
> >   struct acomp_alg
> >   struct crypto_acomp
> >
> > A crypto_acomp compression algorithm that supports batching of
> compressions
> > and decompressions must provide implementations for these API.
> >
> > A new helper function acomp_has_async_batching() can be invoked to
> query if
> > a crypto_acomp has registered these batching interfaces.
> >
> > A higher level module like zswap can call acomp_has_async_batching() to
> > detect if the compressor supports batching, and if so, it can call
> > the new crypto_acomp_batch_size() to detect the maximum batch-size
> > supported by the compressor. Based on this, zswap can use the minimum o=
f
> > any zswap-specific upper limits for batch-size and the compressor's max
> > batch-size, to allocate batching resources.
> >
> > This allows the iaa_crypto Intel IAA driver to register implementations=
 for
> > the get_batch_size(), batch_compress() and batch_decompress() acomp_alg
> > interfaces, that can subsequently be invoked from the kernel zswap/zram
> > modules to compress/decompress pages in parallel in the IAA hardware
> > accelerator to improve swapout/swapin performance through these newly
> added
> > corresponding crypto_acomp API:
> >
> >   crypto_acomp_batch_size()
> >   crypto_acomp_batch_compress()
> >   crypto_acomp_batch_decompress()
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > ---
> >  crypto/acompress.c                  |   3 +
> >  include/crypto/acompress.h          | 111 ++++++++++++++++++++++++++++
> >  include/crypto/internal/acompress.h |  19 +++++
> >  3 files changed, 133 insertions(+)
>=20
> Please get rid of these batch interfaces.  The whole point of
> request chaining is to remove the distinction between batching
> and normal requests.  IOW, if a request is chained then it is
> automatically processed as a batch.  If it's a singleton then
> normal processing will occur.

Thanks. I have incorporated this suggestion in v7. I would appreciate
it if you can review patch 1 in the v7 that I will be submitting shortly.

Thanks,
Kanchana

>=20
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
