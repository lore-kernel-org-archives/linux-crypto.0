Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012020.outbound.protection.outlook.com [52.101.66.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64711DC9B8;
	Tue, 15 Jul 2025 21:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752615517; cv=fail; b=VY3LImH6yN6+N8TOVCngTpfB/H6RznldGnki2oj4s6U1lsXtmfsIeaA3zpEq3QAk6ZvHLuNVI0x7HxOANsASJw4TtYn3HOzFFmE0VaGTA9IsNtku6w540G3I86REANMEakoVUDob8eM8VyIj0NjHDQJMrwef74dKCv9Ko8bNa9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752615517; c=relaxed/simple;
	bh=RzjqEzqI+6LfnRKtbw0uULkudijPZHc/v04iL5PSgm4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pfnze1QPTvPv6bpr7Bbei5uw9tr7ocIACQ+BXw0oRoYUlhYanjaLOl78uYndBBWgsxhC4NUqlAxmiBr3iFzTOAx00ukKNFzU1idwBEnyTLHsgpmZ/wX0IN0pXJ0ICCmyp/2JcsfCC38W/5NKiBJWVK5ZOShu2hnfzCD0+/WJEbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=CN2aYayt; arc=fail smtp.client-ip=52.101.66.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="CN2aYayt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=REb/YzWTZRV1/DlunVCVZqTYEpwLSsBsmjY246GeidmDLirtLGazWnMAYKwI7kIB5RmKCdMOg61GRaTOS/MdN/7WhwPTDo1fMH01kk5uc64fd2y16GrfVkdc5fmhTPPziuhrweypzSJiTw+7J+guSXxq4n03nkemV9sZqLXNNUGrT20BlnYRHPSz+DPo67BdIO4hRSOREmgeNzwWV77Y1WGz/O5UFEZecyBFNdaouhV1BWBumt41OioOBslVbRzIw0X4Sot96b6lLafuS3QlquMPmn2DnvfESDuoYmr9v7OZTv4Z+nBabj3xslrTL33CFOdU/GTMTeK0cDUFAzHX8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RzjqEzqI+6LfnRKtbw0uULkudijPZHc/v04iL5PSgm4=;
 b=CtQHpvGznnBkBqSNYuwLaHe+vQNGKdSuA2nU/tn11rf+qDAyX+ywVLsAtq+LgGJNr5I6cEpVnIlOXwLFWKzZ2BQN5Jm9QT+JmntfF9fDi1hJ7tQpmIWAeGrdioe09vlFdn0clCkgv0mvkCoOoZCBXMw7+9zsOL0xTiNI2kT4LTLEaBfPQAkUIj9b1touNGIsRJ0Up5rsH55p6UocQPy4m2/MD9T6K2oCblbxmDWvMFxfImZEALZJGH8ENh9+wUtQB5JdDa8KvzCslrpbSroJnQxn7LGQCUOSVEQzQFgSzGLSQgAlsYAjMlDpUgPg8bz2C/57hvnH8t2zpsijDBeqZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RzjqEzqI+6LfnRKtbw0uULkudijPZHc/v04iL5PSgm4=;
 b=CN2aYaytgrjXIy0si4ym+benMzQJ9zLnTZY+vSx/fHqD+ONGtB98U07w8yYFy9dl7sxxM7fBVkNmbViQYjfGSHzN44cRPhmdAGQwl26OB830/y0X36suSBLsNqL06ueDZ7zOO38YV7lLxdSzmZlaVkQ8J0Tkn2EKsdNBBVkCTzlww2tDTwUDSl/7/Pf/joJBRNM1W8yMrDh+EKQiu/UTi4S+wEpnzn25lVgM5XH7WvDbWY9dyxLzyGq5zss01LktGZtT5FPK8VO+XzR73aVzeJzk9oaHbH5p8sly5QfPfDWnSG+eMD0ZOSQZQFWC32BKee7D8/RVZcCZti0+0pWCOQ==
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com (2603:10a6:102:26b::10)
 by PA4PR04MB8045.eurprd04.prod.outlook.com (2603:10a6:102:bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Tue, 15 Jul
 2025 21:38:32 +0000
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628]) by PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628%4]) with mapi id 15.20.8901.024; Tue, 15 Jul 2025
 21:38:32 +0000
From: Horia Geanta <horia.geanta@nxp.com>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "freude@linux.ibm.com" <freude@linux.ibm.com>, "dengler@linux.ibm.com"
	<dengler@linux.ibm.com>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav
 Jain <gaurav.jain@nxp.com>, "arei.gonglei@huawei.com"
	<arei.gonglei@huawei.com>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>
Subject: Re: [PATCH 1/2] crypto: engine: remove request batching support
Thread-Topic: [PATCH 1/2] crypto: engine: remove request batching support
Thread-Index: AQHb8pHk28FvqdYACEW6OmhtYn5K/rQzvHmA
Date: Tue, 15 Jul 2025 21:38:32 +0000
Message-ID: <701ab192-9c96-43b8-805e-a8e9953f7abc@nxp.com>
References: <20250711182932.918257-1-ovidiu.panait.oss@gmail.com>
In-Reply-To: <20250711182932.918257-1-ovidiu.panait.oss@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9709:EE_|PA4PR04MB8045:EE_
x-ms-office365-filtering-correlation-id: 28b29cff-4116-473e-f070-08ddc3e7f209
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|19092799006|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NDJZMjkzWlF3WHdqOUVIQ3piTDk4MklBMkRRU3hKU3R1UFpnekNBSExkclNY?=
 =?utf-8?B?U0N5SEllZVhEQXArZlN0aVVLQzhDLzlqdGRheUoyQjlGZ2YxQ1k3QmlFeUtL?=
 =?utf-8?B?eWkrdVExb3hjNDRkazVYZTE4aDNOVmpWNTAyVE9PdkRzR1E2K2VrZDZhNzlP?=
 =?utf-8?B?Ulo5cElFYWdmVkhjRXdYWjdqMmRHb2hiUmhJMGpabTZmcXdPMVdNWkR1dmtr?=
 =?utf-8?B?cno4cGU3ek5QemdLNFdhWFRDOFU4cHNVMHZ1UVc3dUJQNXFvb0QwbzJWL2dw?=
 =?utf-8?B?R253bUlXVDNqalB1YnF5THlDWXNEUThtKzBTWDFTVy9jSDhpalhONkZGS3V5?=
 =?utf-8?B?cDJGbnNLSVZpeE1TRCtYSDZNYy9Obmp2Q3pxalB3L0llL01laHF2czlLR2lW?=
 =?utf-8?B?MEVjQXBWSk9oS0tyZ0pYbW4wTnVqRVZINWgzNDhxL2lCQ203QklIQXVrSXFp?=
 =?utf-8?B?MzZnZmR2V1FWbXovVzBCdDZ2OXpFc0RrTFVQRG5US0NnNm51UE1PbnZYaVhx?=
 =?utf-8?B?dS9Ncnl2L1ZOTDc1a2xCNjhPZTFFOWU1MGJISTZmakpQak5OL0hRMW9YZzJh?=
 =?utf-8?B?M3BkQW5QRUFCaGM2SGhBZVZQWFlVMzlKdFUrUUNiVFFqZGc4R09ZYmt0Y2Ro?=
 =?utf-8?B?aEhIajRMelNMVEFmc3pKWXYxVHRpS3BaekZwWmFFWkhrQy9iazRlMjZxNUpq?=
 =?utf-8?B?VmE4enFxMWx6OWdDdlVaUlVQTTd2eHVUN29VcTJEdU91ZVdFeG1VanJYaEJY?=
 =?utf-8?B?SHdwSTBwdC96anZLb05FdG9MZ1NLanI0M2puYU1CTXpScGJhMiswYTd4Wkcr?=
 =?utf-8?B?ZzVta0EzRVBQL2RsY040TGpvdVdwMTRjcnBlRDNoZ3hPdE1MWGZJVVlVTE85?=
 =?utf-8?B?UzlUc1lPYU93WUc5UTNCT2JFL2ZpUiszOG9XU2RQRUtpWkkwWWNvbVZVdEFo?=
 =?utf-8?B?MWFWRVkzTTY3ckVLRFJNUSs0N0ZNRkozSW5kcy82WmFQUFBKVDVNU1M3MEtr?=
 =?utf-8?B?aFRGNkh5NlBqSDJPVEJJcE9PNE1HeUFGMVB0RTVGVTNma0laeGRyeEZzemJV?=
 =?utf-8?B?dFNmR1V5d2EvR1hkRUdLRjB3Rk0vR1NUYjlIR2JOeFM3cjdqalpkbXppWmlE?=
 =?utf-8?B?Nm8zYW1KQ2lkSnVFOTBmV1VJM0tqRWpBTjNiOEVxRDFGWWh3emJMQW55VTE2?=
 =?utf-8?B?a25wVDZXQ1FoR0dGaXQ5VldlSUFyUjJEQ2tRYUgyZW5Fa1ozQytsaklDdE9R?=
 =?utf-8?B?REw3NDlGTzNOSlNjOFQ4WlF2Yk8yMS9QZW9HQkFobnIrVTFlUVF5ZGtGVXJq?=
 =?utf-8?B?OEFOSHpOMEdCOGlpQzNSdnJBMHdCampRdFU2WENZeXVBRkxPWk81bVBSdXFj?=
 =?utf-8?B?dTJOM0pxandzaWk3c0JQbk9oc3BDU1VEQndQV2piRVlvSW1EYVhBNmpKMk1u?=
 =?utf-8?B?MTRWTGxOb2ZrK3lWaWhSRVdIdHQ0WFFUbUhJMlJJU3BWY0FLL0NpYWg5T3g3?=
 =?utf-8?B?L2trajI4MTdKNHJZaUNjdUgvSzdDb05HSFlJamFDRzBETk9GSk5mekRscWxJ?=
 =?utf-8?B?bUZPQXJUblZOOGpTVHd6VVlVeTJ6TFVjSGd2dVhUaXh0TU54eTBsYys4Zitj?=
 =?utf-8?B?aGZmNmRDMitXdE5oVThKVllwMzVna3BST0x0WDJHdmw1VmpVa01jVmhzTXRE?=
 =?utf-8?B?c3FTQUQ3dzJrNHhJdVMrL256aXZiYVllL0dDVTVTeFBQeng5anUydUIrSTBk?=
 =?utf-8?B?akEwYTJybXB0REJWbWNWYkVYY0hnY3ZCejl4WlFsUXFJZjBlSEpmZWNudDNp?=
 =?utf-8?B?djljWWgyRFVXL2dQOEN6NUNWZjFxcktuWTRQZnRzVTduOXVaQXVaZGcxV1Zu?=
 =?utf-8?B?eUs0a21DV1RaL1NMTm4yeFplaVJTc25neU03TUVLUFJBNDNnVWZBeXNVZGw1?=
 =?utf-8?B?Y1NFQXRYN1JKeWRsb0tBVlJ6ekVTZ1FZbGkxYUU5Rk9LQnp6MHhaUENDRTFY?=
 =?utf-8?B?UndieGZrS0VBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9709.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(19092799006)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MEMxd2JEOEpnbXBpcjBxdDI0NGNKL2hucGFqQ0Y5Ti9rdzR1emJRcnREazZW?=
 =?utf-8?B?dXNxaFBJcmlINmlKbVlUQWpVN0hSWWR4Zzc3N1VRM0kyS3I3NU81L1RIZFM1?=
 =?utf-8?B?MGZNY1AyaDR3bGZja1I5MHZKRHZxKzhnaXdSZFZ6eWE4U0pXcEFnMFdIV2Jm?=
 =?utf-8?B?Q0VmQy9NNXU0alQ5c01TKzZMZVJ2dHJIbnlQUnNSRkZUclhqR1lhbUtDM3B0?=
 =?utf-8?B?eWFKcVUwaWVjSllBaTN1K1FNTUcyR0g0N0FOdEVLYjBLYVhsMmliU2xQMmdL?=
 =?utf-8?B?LzUxcGU2YWlNOWtKZy9rUzl3b0ZoZktnOTVwT3dMSFdZR2hJQlg0aWorLytS?=
 =?utf-8?B?MzFpZnJZWUpHYzZVNGYzS3QzRFlsOGozTlRjTFNtU01iTUU0c0lzTitGS1li?=
 =?utf-8?B?MGVlcXhBT2RVeFg1MEVKRlFtMTRoOEludUQrWUkvcUtQdmw3cVNqVnh5R0px?=
 =?utf-8?B?eElFa2VYSE53U2czQmxFVlJQVzhDVk5COHlVQmlmNFBLU0tXK3Y4U2ZZN2VT?=
 =?utf-8?B?dXNWQ0dzVzVXQW5MQjFxczZncU1IelZhcEZMeThlRVBXY3N3b2NpRTRVZnlV?=
 =?utf-8?B?S1VReEZvV1B2NkJDdUl0OWdnQ2VDMVg2cmJNUDFKbVRsZEFSUmR1emNWQmNw?=
 =?utf-8?B?cG50SG1FcDZib0o1NEVRM3hQUmFYeHc5VnduK1hSMkpzcTVYbEdSeGNKcmF4?=
 =?utf-8?B?K0JMWk91NHZDa202L3JWMUphelYyWkFHZmlwT3JvRSswNHgwbEpONzhKdUVW?=
 =?utf-8?B?N0dNeFFFaFNLRU5QaHlTMzBScjBjYkVHWVhzZ0JqdFdRVHdTeGNFOU9TcXlx?=
 =?utf-8?B?SFdnSjFsaWlGVHo4MjRBaVlmSG5kVElBTVVEVzV4azJxeWJOUXlSaE4wU0hN?=
 =?utf-8?B?NVhxQjhkYTE5LytCRTNkaklNcXRxY2sxTWh0LzFzWWF6aytQVDRnaUI5NDNB?=
 =?utf-8?B?UTdncnd2dGNkc1JhNE5lWEpJbWU0NDd4bEo1Qjl2UXRWcnZ0RDZ2ajdKZEVn?=
 =?utf-8?B?Zi80UTd4WmF3Ti8wN3oyYVQxMWFKcXRXc3g4eExUeHZxY0hXMjBZbExqN09C?=
 =?utf-8?B?ODc5a2dEMDJpL1RGbUNabEorTHkraXgyQjVnanRCOEdlYzZObG5FN2ZBSFJR?=
 =?utf-8?B?QWIwQ0hjbTVtbUtmUXJodFFMRzlRQ1NpU3dXRGoyWXg1aXFuczRHSzhqcUh2?=
 =?utf-8?B?dzdiZ2tiT3llMUp1RjNLZ1dZMkJUeFlIZTQxTGhOVitGd0ZJLzltNCt0SFV5?=
 =?utf-8?B?TUdjZ0gvT2w4NFk4RERBd0d1OEM0L0RoL2JYekZUK01uSjJYcHNJMVhJNzlu?=
 =?utf-8?B?T010Zk9pL251ODhhSXM4V0xWWnZPUDRDZVZuVThBc2twZmF1eU9mdEpqdzM3?=
 =?utf-8?B?U0Y3Wjg0c25PZW51Unl2aTFmT0tiSzYzMU9PWDdEVVVoV0tDT3h5TXRHUUND?=
 =?utf-8?B?aG9aT3JWVEo0bGxyM2QvT25nam53MkEvSGpoSjZKYjBVY09vN2J4UWlJd0hq?=
 =?utf-8?B?ZmxLUkdBTWxwUnBtN0p3aFdaSXp3aStJdGE2WWIzcVFZekFyZ1dySTBLZEY2?=
 =?utf-8?B?SEUzYlkyWFIxUmNyYzlzR2JmYU9obXBiT05Zam5JUzJVTjh1Y295NC92Y3py?=
 =?utf-8?B?L3BHUkpsSXNQWXlRVGtsZ0p2Wjc4WGZRaVB6VjVRZHEyd205UjNXOHNKbXZi?=
 =?utf-8?B?RmN1N0owZjlmZGtIVm9CbExvOFYyZVgxZUN5d0lXdWVzay9MU1c3THVKOC9t?=
 =?utf-8?B?bmdvQlR4dWZJd2VxQ0JZeFU0emo4RUV6anJlK0pHNGFXZFF3WEdQZDY1eWF1?=
 =?utf-8?B?NWRTT3ZQbzdmdGRTOVJheFBkWGhoOHJrTDZpK3QvM1JrTnBTWGh4SkJ0VUx0?=
 =?utf-8?B?Y1ZZWkpaanA5akh5c01IQXQzekdpQUU1c0NXbzY2UHNDSWpmZmZCVzVrSk13?=
 =?utf-8?B?RmZJS0VTekF6dk5YSzNweklYMFVKNmY0cXdXaXNwbW0rWENXKytxSkFUUzdK?=
 =?utf-8?B?SUVyVWlFY1hRZnZEQUEzNDVHWTZJdVZXLy9hakNsUkJpU0NZVlVoazZnQVRt?=
 =?utf-8?B?eHhUbHNHVS9aV1dVUTlrbWc4SlIzRlIzcE9IZjYxWWt0ZU5yQXFqM3dLS2E0?=
 =?utf-8?B?cWh6UnI4RlhkOEFZN0ZabXMxQ3lWTGVwYkVIV3hFRU5qSjdhWFhDYUhQWU9L?=
 =?utf-8?B?N1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B504BF55640AA9438316B59BEDE1C8DC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB9709.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28b29cff-4116-473e-f070-08ddc3e7f209
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2025 21:38:32.1932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VUa6jAbyTeob01chLdd/IJ12og+Kh/DC8rsopaIAZO6Bmq/aczhXEQWwIWIks9/oqwvSPKLBXbfQ+SIzzl7QgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB8045

T24gNy8xMS8yMDI1IDk6MzAgUE0sIE92aWRpdSBQYW5haXQgd3JvdGU6DQo+IFJlbW92ZSByZXF1
ZXN0IGJhdGNoaW5nIHN1cHBvcnQgZnJvbSBjcnlwdG9fZW5naW5lLCBhcyB0aGVyZSBhcmUgbm8N
Cj4gZHJpdmVycyB1c2luZyB0aGlzIGZlYXR1cmUgYW5kIGl0IGRvZXNuJ3QgcmVhbGx5IHdvcmsg
dGhhdCB3ZWxsLg0KPiANCj4gSW5zdGVhZCBvZiBkb2luZyBiYXRjaGluZyBiYXNlZCBvbiBiYWNr
bG9nLCBhIG1vcmUgb3B0aW1hbCBhcHByb2FjaA0KPiB3b3VsZCBiZSBmb3IgdGhlIHVzZXIgdG8g
aGFuZGxlIHRoZSBiYXRjaGluZyAoc2ltaWxhciB0byBob3cgSVBzZWMNCj4gY2FuIGhvb2sgaW50
byBHU08gdG8gZ2V0IDY0SyBvZiBkYXRhIGVhY2ggdGltZSBvciBob3cgYmxvY2sgZW5jcnlwdGlv
bg0KPiBjYW4gdXNlIHVuaXQgc2l6ZXMgbXVjaCBncmVhdGVyIHRoYW4gNEspLg0KPiANCj4gU3Vn
Z2VzdGVkLWJ5OiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+DQo+IFNp
Z25lZC1vZmYtYnk6IE92aWRpdSBQYW5haXQgPG92aWRpdS5wYW5haXQub3NzQGdtYWlsLmNvbT4N
ClJldmlld2VkLWJ5OiBIb3JpYSBHZWFudMSDIDxob3JpYS5nZWFudGFAbnhwLmNvbT4NCg0KVGhh
bmtzLA0KSG9yaWENCg0K
