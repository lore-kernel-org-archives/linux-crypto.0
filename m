Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013003.outbound.protection.outlook.com [52.101.83.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F1429ACF0;
	Tue, 14 Oct 2025 08:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760432201; cv=fail; b=Ev+fP1G2SYF0u0sxB5M7DE91tcbUhinP22q5s1y/X7u4UcW5LmsWxoV7Zd4uo1SelQ3XrNF/GNKj6lRuFzgLy8yMdpoij043r60embjrtCiXbJk22Nngwy983n0iKDRS+6suIlspTXp22j7WtGEsGhpUnPWMYyBBme5c/CDg1Pc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760432201; c=relaxed/simple;
	bh=ZpKU+LsuXxpQtqo7bkSbsYrrpnEgJ7Pk1HKl7b6odA4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n4kn32NIho7AY2zNy2HbpGQpVE96enluKYmm4Z8XuKk7qYartBLQfy7ugXeIKjRDYSwHsiQOzAKg8YXl1nxjrMar0HuEE8xY874IjG1XWkHsj4Cy7XCul6/aHtDWHN1RQKSg/hyOzrLDqk8oQFxO7nULBeJRpZKJLtzVLLdh9T4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=BisvZgD9; arc=fail smtp.client-ip=52.101.83.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="BisvZgD9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BROKBWyQAcIIPDktau/0AfbPxvPzNH0SUqFh86TcSMmZyLmJqYF9Rcj0Voc/4bK1+NiLVpNtUMv4m89k3fpmW5vKj67qT7FBEcwKiemJpNE+X935S/AjLKMR8iILw3OhylLxIUBYj3qVq0V+zKdnDskyQgP3sGUHNX/ziSJVTiz9xnKui4t+EMfGvGyx+JiVRkse5+aW7EO4i/p3z+7lWaRA1N6xf96SkkVaNKTXtL8cWgs6F8c/i7xK946I92hJPzSvUJKxp0lYV53WIxtE4e0cGY0s6ZId5ZGezwLuJCqA6+o6NbVz4cdyomC9Gz6FineWAutrIyYX3otSqdfmnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZpKU+LsuXxpQtqo7bkSbsYrrpnEgJ7Pk1HKl7b6odA4=;
 b=xZXWTR5gC7ayNhUFe3JgYy/tcxKXKbkwuymlmGcWCqnuWDP4ziWyYqeENBTP6+MAkQeL4Y9n80viWjukQiPvFdqd5yM+6mFBnW3toMS3ZtS6ZafPJxz1LzsZSycbxE+pSwE6rZWsCmrTpElnWB8oSP5j9VHbMXFxd082SmSKgTNStAgEL04Bb/pkpfIeK7RXXqd5vTwynGbpRNj9QKKAPd5W9BUOOkmY5z/ZIJzkjVVdQJXYT2ik/eKkR59nugEkDRWuNx//SJlSDHRhD4pGquAv4aNUOMGT5VTNa+B7DoEEcdrgFrPs9B6Lvfrxwo1uB+IlR9KFYzagLiqjWGV0Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpKU+LsuXxpQtqo7bkSbsYrrpnEgJ7Pk1HKl7b6odA4=;
 b=BisvZgD90pVlsOVp2oC+XwcEWmMPF6mw0q38Yg7TnueL245tjWpH4rJNbF4K55HTZP6AVp2iPy+P4b5bTaAQhskbPA/oZ+hmBxsYN8ZrIGikCCyFQRoW5xVj42YrgmkifRvfs1U8ORtCliw77j2NDTenTbkJvoDwP1MGJdr5Dd+rY/MabHGgs7yvXKQ2yQ5Il3hw7dnNPgupPX3P+p6wM76gD/Cuu8vxnZ9JbquZf406CHlVUWSSjV+eh0CmWtbTp1dvbiCpRD8K8N4aAIWFn/PzduNTN2c5VPwFeobi7d52gDcBKGrph/NL1dU7681oXULKHYsyaELXbGj0uuhDew==
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com (2603:10a6:102:26b::10)
 by PAXPR04MB8942.eurprd04.prod.outlook.com (2603:10a6:102:20d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 08:56:35 +0000
Received: from PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628]) by PA4PR04MB9709.eurprd04.prod.outlook.com
 ([fe80::1009:ebb:d7ae:4628%3]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 08:56:35 +0000
From: Horia Geanta <horia.geanta@nxp.com>
To: Gaurav Jain <gaurav.jain@nxp.com>, Meenakshi Aggarwal
	<meenakshi.aggarwal@nxp.com>, Varun Sethi <V.Sethi@nxp.com>, Pankaj Gupta
	<pankaj.gupta@nxp.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] trusted-keys: Add support for protected keys using
 CAAM
Thread-Topic: [PATCH 0/3] trusted-keys: Add support for protected keys using
 CAAM
Thread-Index: AQHcNpFjDm8xrvtjBU6l3YfxHj7INbTBY7wA
Date: Tue, 14 Oct 2025 08:56:35 +0000
Message-ID: <5fa818597020992de54f7911533fcabfc4844629.camel@nxp.com>
References: <20251006071753.3073538-1-meenakshi.aggarwal@nxp.com>
In-Reply-To: <20251006071753.3073538-1-meenakshi.aggarwal@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9709:EE_|PAXPR04MB8942:EE_
x-ms-office365-filtering-correlation-id: a57768f9-ba09-4569-53d0-08de0aff9458
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|19092799006|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?L0UzSm5RTmpCdmlJNmJ6eG1iaW53S0crQUtVYVFDUkpsNmsxVThLZmZEMCtH?=
 =?utf-8?B?U1VYZmpIVWhiNjI0bGMyMStXZlVSQ0oza0hWT0F0cThWTTFCSjl4enVOWG5U?=
 =?utf-8?B?NHo0K2VtalpRSXRDVlVDdm03VlJFUkMvNDZPd1pzSTcxdTVVZXdoWWpQUTdv?=
 =?utf-8?B?cXFSZHBTMHBJMmQrcnZzdGwyOXc3dWJyeHFEYmhJQmFYNDhkaDhrWXppR0lF?=
 =?utf-8?B?TEFRZEhvNCtWM0ZZYXl6bkJ3VTlUUjZGcldUbjN0V0k3N2pHeGlJTmlyQmFi?=
 =?utf-8?B?NnNDaVo4ZFBpN20vVnU1RG9ySEtxZFJFeWJjNE9BSkpSMWtOajVmM29xdmVS?=
 =?utf-8?B?TWR5VkhmQzVySVlhNllLUG5mOE01L0FvZGFwM09mbzkrTU1ndzNVay9wLzY2?=
 =?utf-8?B?VjhYTTZPQ0lRVkZzZW9MT2haVk5wTVRXcVUwaWRwY0dDdTNDRHhKTGYrR1hx?=
 =?utf-8?B?ZU1UenlwaUJKWFhCNSsyMlBCNENuQlZ3c2Z2QWttY2UvV1MyeW5lMFE2Z21q?=
 =?utf-8?B?eFVjUEJFQktTZldnMktKbFpXWHJYVnBjaStwR2JmQzVlM1VuZG14K2pBQ2FE?=
 =?utf-8?B?OHRueEw5L2swOUpITkwxRWx6b2VieDNZdWRHOGF6R0w5OUV2NWQ4VFZ0K0Vk?=
 =?utf-8?B?STQ0TE1JKzZUbmFDOFRxSDIvNWJ5djdvaTZIaGg2WWdyMCs3djQ4dDFVUlFz?=
 =?utf-8?B?WlhHN3dlWm5XblN4bU55elpPUlJ6UEh4Zmw1YWFXLy9oR3M5bWJIaWx1d1lk?=
 =?utf-8?B?WjJzU29VU3hIUldEYlNtYW9hNFQzdjZOZm9sOVFPUEVXbEs5UUNYNmgvM29x?=
 =?utf-8?B?c055MkNEd0xHKzB2MTFGVFowTW53VkszNlZmQklqQnZnNVQwYjJrZ1A0Szcx?=
 =?utf-8?B?dW9HdUxZcW1hWUUxa3g4NHJZSjlrR2lhRVV2Q2p4ZEp3bnViRVFWWjBCdnBC?=
 =?utf-8?B?TXFUNmZhWXYzYVYvNzB4djhpcDJ3b01RVkUvNHl0R0FLNlZjTlh5V2tCMTFO?=
 =?utf-8?B?bEpUK3Zzb3JWODJvQVpRSENUR1U2aHVZcFlaS0dsNmFCemcwc0pWRDlpTkM1?=
 =?utf-8?B?ZFRoS3NtTkhITEdSTS82czIySXJGelliSEd2TWpDZGd2ZzJCRURoWURDQTd1?=
 =?utf-8?B?b2VScFVGdmVTVnFGRjJodnRoMHNQd1I4L0JXajVUN3FkNkZIYlU2OVhiTkhY?=
 =?utf-8?B?cDg3OEhDeGhGWWZNdnNBdnVJaFVBQzIrMkdMVms2cWdvdklMaXpiQjVoZlFy?=
 =?utf-8?B?M2wxcVFpRStJREFmanBsTFVNSjNvMk8vUjdIdmJZSGhnQkdZSW1xNnRrcEln?=
 =?utf-8?B?MFpaZ09xcnZ6NVBsckY4ekk4ZENCbEFXS045ZmV2UTk1Z090cFdaclNVVlA1?=
 =?utf-8?B?bnZiOFZVOWhQS1M5T1RRRkpHL2Y3STMxY09EQWRmejJuUkZWN0g1VjNDRy82?=
 =?utf-8?B?WmdkZFBNZkw2NGMvM3JwV3N4c1V3Ukljc3ZBMTgyNDV5NGdqcjZsaThJczNl?=
 =?utf-8?B?ZVFFUGlwZ0pIc2xBYzBJL25BWktyKzJmbjZyUHVlejdJT0tyZjE1THRxRk1R?=
 =?utf-8?B?blF5UTA2bWJTd1h2OUtsaHI0SHFsenNLNlpGK0FqS3hPTURsUkJJNnRPVDJh?=
 =?utf-8?B?bTBZeXd4eXBINEVjbEg5Y0h0SHM2SENVNGxyRWkwMXVjUkdPT3JyZ0o2T0Ru?=
 =?utf-8?B?MU5sZ2UrbDZ0cWJZeHp4Tng3OE96TnNyS3JoVUhiZElXZVdLTFVpV2FSVXRK?=
 =?utf-8?B?V21MSWRXUXRoTWI5c0JBbHAyQkFTSEFTNkJ1Ym9YQW11YkRidmF2Qy9UN2VU?=
 =?utf-8?B?Y2hhRHlhcjVFOE5OT2ZRVzFJa2VqR0w4MkkwWTliOHFZVTl3ZHFyZTh4a0cw?=
 =?utf-8?B?YUhMdkNCaUtjdGwyeU9pbDg0QzJUZzkwb2l4M2E4c3ovNm4xanRxSklUdXU5?=
 =?utf-8?B?QkdZRDlqNXJSdnc0Nmk2bThRNFVZWWxyUmdiMXFOaVVNOGRPdVNuV2FSQkpv?=
 =?utf-8?B?THhZZjV0aTVsbFpQbWJGMHNRZVBWc1BiZmN1OHNMeUFuQ21JSE8xck9NZWZw?=
 =?utf-8?Q?2eCJ/g?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9709.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(19092799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YXZIUk1OOU53d1hzbzYyVHV0b0ZQWHE0OTZqdmpxMStwQUxSWk52V3pReGlx?=
 =?utf-8?B?NVgrK3lIZSttVUJnVU9kMEV5aVUybVRVRC9RbEFJU1hpSmVRZnJ4eTZWOXRL?=
 =?utf-8?B?bEhzZDJYWHhvWHBpeFMwZ0tGS3d5VU5qR0V1RTlsQnJCSkI2akd5ZVdTcG1B?=
 =?utf-8?B?MWRaYTEvanhiS0RBSUVUOXBxbTkrRHRwSGkwaWxwQmVYTEJZazRtTkV3cGtl?=
 =?utf-8?B?NGFVUVdRZlUvODZVYkg5cm1senVZQ1U3SDNPMzd2N3dEZjE5eDFWRFQzUHA2?=
 =?utf-8?B?aStBUkIybHAvVDdPTVE3S3VxcWtVNFFvZDBIbGRaSDFRWEEzTXNlZWh5KzEz?=
 =?utf-8?B?eUk0SkNSWnpoNGtzeDU2dkZVVGJYZnpxMWMwUmNBQ1JWQXp4SHlUalU4cDdi?=
 =?utf-8?B?WmlLZ1dRdXlTT3NjSnhDWTBLNGZsbXlRbG5aeFpLNXZwMFgrL1MxNEhNNEY3?=
 =?utf-8?B?eEtsN29KTXVlSURiZWtMTGNuZ1k0YlNWTWVtQ3BMaWptT05lcXBoeWtEZzBr?=
 =?utf-8?B?ZmFmMkt1Q0pTQWF3cXA3L2piREI4U0swWmd1Uk9GVWVHY2l3YlFySGZwZEpm?=
 =?utf-8?B?VnRDL3dDVW9KVEdRWGxKaCtGc202S3ZxZEVLdnZLZlVxbzh4WGFPQnRUQTRS?=
 =?utf-8?B?YWh3S3A4bk1MMEZXMzk0VEEzL2txZExpb2F5YSs5Z1J4WW5tOTYzZE1OTDFO?=
 =?utf-8?B?T2h2YzZ1UXlBWnVMVE9kRzNXSWRiVnBURDFSY3htL24ya3QvaExKZWgwV1Nl?=
 =?utf-8?B?bDVtS2REVlE5dHVQT3lNRDIwQzlGbUJua1dReFkrMit4YnZ4NnNNRlR0UGRl?=
 =?utf-8?B?S3F0YkE4ZGhEcm0vRnNsL0s3RXhOZ3kxbGR6UmtNSm11NWJKRXZSUnNFcmVz?=
 =?utf-8?B?ekUyRDZhUDh2YnZoZ1VUTCttMDE2dWhNdlZMZklTSWo5WnhUakxxcG9VZFVI?=
 =?utf-8?B?YjVWVkJzak00QS9LWFNVRkJTcGRxV2tKczVxZzJnQ1VMM0pmRERoaFd4SFF1?=
 =?utf-8?B?STU5YVVMZjhYVmRjRVp1d0FnMFI3cGttUjJac2lXOTVJSjZBcmZMU2dyVjVK?=
 =?utf-8?B?WXRaMUREZTdjUDhWT2ZmVmVnNWp0VURJcGJaMnNXQzJHalBKdzJnV2xpT1lJ?=
 =?utf-8?B?Q0RXbUQ5OFVIRXlGaG1pZkRRSEFlQ1BBVUN1RTR4NmRCTXQrcVBybXJBVXVI?=
 =?utf-8?B?YkxHVUo2Q0lJaWQ4QzlEV1hhd2hOZ0RwZTE4d0EwR3RqcnlLMWoxRk5mVEZJ?=
 =?utf-8?B?SldBVkZPbEdjZEU5N0RsTXp2dHNSR1UvMUpNd0hlUFI0NWl5ZVg5cTR4dXRC?=
 =?utf-8?B?ZWdzN1d2REVKYjZST1V5Q25ITGRMaW80ek1wMmRSNE9GWUlpK1orNHBPUEdx?=
 =?utf-8?B?TUNoMnZBaENDek9UeFBZN29jQ2N1Umw0M0tBZEJSMWFRSmZQbWFzNjN3RWpw?=
 =?utf-8?B?bFZjWXBBS0E5bUV1TEF1d0V5c0wrNnZueUJaSVhlWmdlcW5pWENjN0Z6M1Bu?=
 =?utf-8?B?K2tXYUJVdlVneWpvZVdibm5TTWhpaTFyVFVLWStXUUhjNGF5Tk54cnJWWjZh?=
 =?utf-8?B?N2wvaGMrdlZEbis2NjNSQUZxQXZJUk9Ed0lQbE8vVUFZVEFMVSs5MVdLSS9o?=
 =?utf-8?B?dU9YdXVTLy8wUzFyVHZOMmVFRlVCMm9XdXBpbTI3RnVZaEdJS2E5MHhnalVr?=
 =?utf-8?B?NlFVU1R6MkZweTNYOHVvbkFlWTBiQmhoL1Fzd3F0UGJaTXlCQWZoOTNKS2lZ?=
 =?utf-8?B?ZnNWUnkxT3BJT25UTE55QXYyYUliNk1wY1lEMDVqeEZ2NkJJOHhzSVBOb3dV?=
 =?utf-8?B?S0p2UXBuL25iaXpVZklKS2J3YzVsL1pNU1pZQldQdy9sV0IzVEpwdEtVMGkw?=
 =?utf-8?B?eGlmZWxsTXEra1FaL3hWaW5KMGRwZzZVN0cxcE8xVUUyQVVtcnhJUHp6TG5n?=
 =?utf-8?B?TlVKcGNQRGpnWXFKdmN6ZEZHL1E3eE5CNVBkQTA2YWZKWDBBZzhXZlZoM1VS?=
 =?utf-8?B?b1NoSU1RRnMyOVZNaExRTFVVclVEaXgzaGozVkFIRzRPT2l6MmZibUlxcERT?=
 =?utf-8?B?NHUyQSsvOE9iS0czMlVhMHdEVkZ6TW9zOGhtVXRQMWVlT1dCWjQzUWtxdlRp?=
 =?utf-8?Q?msg6FLOxJRl+LASIKUbCkhWmt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F0C060A2034F1448AC88D7884145AD8@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a57768f9-ba09-4569-53d0-08de0aff9458
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 08:56:35.4919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mSrhkI5gk9Z5Q51rpo5zapZ6YSzB56C8E77exZx5B9Sc7ZOh1QgQAQo2J7RsEuWWDct47lBAQviCVWWlC1WsOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8942

T24gTW9uLCAyMDI1LTEwLTA2IGF0IDA5OjE3ICswMjAwLCBtZWVuYWtzaGkuYWdnYXJ3YWxAbnhw
LmNvbSB3cm90ZToNCj4gRnJvbTogTWVlbmFrc2hpIEFnZ2Fyd2FsIDxtZWVuYWtzaGkuYWdnYXJ3
YWxAbnhwLmNvbT4NCj4gDQo+IE92ZXJ2aWV3Og0KPiBUaGlzIHBhdGNoIHNldCBhZGRzOg0KPiAt
IFN1cHBvcnQgZm9yIGNyZWF0aW5nIGFuZCBsb2FkaW5nIHByb3RlY3RlZCBrZXlzIHZpYSBga2V5
Y3RsYA0KPiBpbnRlcmZhY2UuDQo+IC0gRG9jdW1lbnRhdGlvbiB1cGRhdGVzIHRvIGRlc2NyaWJl
IHByb3RlY3RlZCBrZXkgdXNhZ2UgYW5kIG9wdGlvbnMuDQo+IC0gQ0FBTS1zcGVjaWZpYyBpbXBs
ZW1lbnRhdGlvbiBmb3IgcHJvdGVjdGVkIGtleSBlbmNyeXB0aW9uDQo+IGFsZ29yaXRobXMuDQo+
IA0KPiBVc2VyIGNhbiBjcmVhdGUgcHJvdGVjdGVkL2VuY3J5cHRlZCBrZXkgdXNpbmcga2V5Y3Rs
IGludGVyZmFjZToNCj4gDQo+IEtFWU5BTUU9ZG1fdHJ1c3Rfa2V5X2h3DQo+IEtFWT0iJChrZXlj
dGwgYWRkIHRydXN0ZWQgJEtFWU5BTUUgJ25ldyAzMiBwayBrZXlfZW5jX2FsZ289MScgQHMpIg0K
PiBrZXljdGwgcGlwZSAkS0VZID5+LyRLRVlOQU1FLmJsb2INCj4ga2V5Y3RsIGxpc3QgQHMNCj4g
DQo+IGRtLWNyeXB0IGNhbiBsb2FkIHRoZSBwcm90ZWN0ZWQga2V5IGJ1ZmZlciBmcm9tIHRoZSBr
ZXlyaW5nIGFuZCB1c2UNCj4gaXQgdG8NCj4gaW5pdGlhbGl6ZSBlbmNyeXB0ZWQgdm9sdW1lcywg
ZW5zdXJpbmcgdGhhdCBrZXkgbWF0ZXJpYWwgaXMgbmV2ZXINCj4gZXhwb3NlZCBpbiBwbGFpbnRl
eHQuDQo+IA0KPiBUaGUgUHJvdGVjdGVkIGtleSBidWZmZXIgaXMgcGFzc2VkIHRvIHRoZSBDQUFN
IGRyaXZlciB2aWEgdGhlIGtlcm5lbA0KPiBjcnlwdG8gQVBJLg0KPiBDQUFNIGRyaXZlciB3aWxs
IGRlY2Fwc3VsYXRlIHRoZSBwcm90ZWN0ZWQga2V5IGJ1ZmZlciBhbmQgcGVyZm9ybQ0KPiBjaXBo
ZXIgb3BlcmF0aW9uLg0KPiANCkFGQUlDUywgdGhlIGFsZ29yaXRobXMgaW1wbGVtZW50ZWQgaW4g
Y2FhbSBkcml2ZXIgYXJlIHN0aWxsIG1hcmtlZCB3aXRoDQpDUllQVE9fQUxHX0FMTE9DQVRFU19N
RU1PUlkuDQoNClRodXMsIEkgYW0gd29uZGVyaW5nIGlmIGN1cnJlbnRseSBkbS1jcnlwdCBpcyBy
ZWFsbHkgYSB1c2UgY2FzZSBmb3INCiJwcm90ZWN0ZWQga2V5cyIgaGF2aW5nIENBQU0gYXMgYmFj
a2VuZC4NCg0KVGhhbmtzLA0KSG9yaWENCg0K
