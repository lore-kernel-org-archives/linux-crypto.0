Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793735587;
	b=SqnCw2fGpk0ZDYJZoRXKBCWuTUd7ILpk8qX8LwPa2COF2JT8Si1uNxtDe38sYgRyD9Wl
	 4paPIdqRBiUlLLDrcvu7VlobOv5C7DoHlNy1zxylARKCMMzB6rD/nnyI0J6McmZIPCNCf
	 r3Qr6PtE/Mh1aRoLNbystTUMOj8Dq7hYmTZBGBjZrbC7eZgtqE7vSW6tYYakgTGYS+8eF
	 f3aUFvenQXSLflspaHWT/jTaGUN3lAn8hVrI/SgCVd7dvpTgcOs/MDs3EnVA6TXCXeNeL
	 /+uKanC7mtaxp/xAelCkg9anIPooVlDeru+WMO18KnN90jDH04+/E8jLms7AZmTYLqQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735587;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:Date:Subject:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=bq8MD6s28DUbvSmDyTwhYprCCjqIMz+4PP4q9KCj/T0=;
	b=q4rr4q4Pl27076s9Tzgo1RSIQY7as549+1+gCRv0k+hWWDuamrx015q6mBxMgrrTl1OW
	 DN2gmoiuV8Fd07VSe0g3WQzFtEkzlUWxLd/4NnYBQ+wPqys2ZV008czZatgmMmuj4/OVn
	 +TTB6ikmZlY0eD60XKj/m1M197V9/kuowpzZbB9G/UIT1HqFKMA+DcgGMtWFd9cLyWlRA
	 qttF8K0rxmuGtEf1U2AzT6bB1IWvxD9lepg9h6ZSmeVbK1lN0w5AxZJzi0vVu23m1rhF+
	 tKQ8YnoKDE9FHy6hmJmg5Du384i7hhXjdgH76vC4vpeGcmAgmcWYqBMAx4m/l4PTpqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=hMgoTt8Z;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.34
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010034.outbound.protection.outlook.com [52.101.69.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ED7606A329;
	Tue,  3 Nov 2026 19:53:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4ED7606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=hMgoTt8Z
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IvJUOtUb34Owkdnl1C2DKWGMWJqqp80/4QV1dQhqaDPkyvFRfhEVva0fg02WfJ85zN8/lpyZeabBxqBINZUf7+R6uvq7zDlvq4wTSTizaAvN+40eJr7kDe6SaaGPJW6gfpWAqfi1nxYQVJSDjDks0P0O5Mg4eXLk4yZv6ZBBcoMm7WkaNQOzY/LDMgnI48igPjRtkjLnS4jbnMV2pHAtLKkcpSeTaSdE6qOlxowqltAwwI09S5OCBQ8B5mNfj+C35eVHae1d9cb9eg0/WBjQZm1PlDm3MvCvWcMQNX41Rm5noPogLJCgWDzWumSYvEQMIckpAYcenVFyxH0huzc5Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bq8MD6s28DUbvSmDyTwhYprCCjqIMz+4PP4q9KCj/T0=;
 b=yARQXS1jT9oZ4oTo1IBiO6tj0wAOafwd1uqJ+7h21FFcUUoidalR2VEd5tKSaP7NAZWL2tI/yFxTcD6DayUCCDB0JtHhsvZDPF1FInIADq54UvhGkuf+/O8E8pTVX1h6h5Kv4uygXsx/UKeYWFvQvQR97IXmXRWGBS+sY+LHlsyNyrFOz56LGqi9xh7xL3FRW+TmqkVgPtO5i5KaOLpdz4PM9gIjV5UhZTd2jIRhoR5NyXsv4zFbtEanPuq+wfntH1Gz/lKUdUvVhl0bjxkQdCwb031x6+kmFFmXpLNL6/XhhBI2fzSb1HrHRAX5lAp9/zzWLt1YtK/EDCiZd9DuUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bq8MD6s28DUbvSmDyTwhYprCCjqIMz+4PP4q9KCj/T0=;
 b=hMgoTt8ZXFYWgGkVz/qoGZH6h4GqtdP3k2jjNLirflrhhPQ12bFD7MrLHZllvM04AAKD+2B7oSTMUZ4EGjzn3O+gNvK9hHJtyVv6qORM/bJrvY49qNKZrjDMIVVT8A1u//aH6eCZqBWN6Z3L942Trdt0JsqPyaq907AvxrI0awKAt5UG7IrKeTMMRS/CFNQYn2ok/SXb/ZbSHmWp25N5t61SJmf0JqNcFeXfMHzQVTc6d9Q3Tyb8C3JXydjDoZVyu1gYcsSoxvOtq/F5FPLAKWHE3+ZmomGlBeAyOEyej0VdvsJNCog4WcUVt/NhgQKc92MWRxtIRr6Nb+u007lFEg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com (2603:10a6:290:76::14)
 by AMBPR04MB299223.eurprd04.prod.outlook.com (2603:10a6:20b:7d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 19:53:03 +0000
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b]) by MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 19:53:03 +0000
From: Frank.Li@oss.nxp.com
Date: Tue, 03 Nov 2026 14:52:35 -0500
Subject: [PATCH v2 4/7] async_tx: use
 dmaengine_prep_dma_(pq|pq_val|interrupt|xor) instead of direct callback
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-async_tx_dma-v2-4-3afc7c59362c@nxp.com>
References: <20261103-async_tx_dma-v2-0-3afc7c59362c@nxp.com>
In-Reply-To: <20261103-async_tx_dma-v2-0-3afc7c59362c@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org, 
 Frank Li <Frank.Li@nxp.com>, Peng Fan <peng.fan@nxp.com>, 
 Dave Jiang <dave.jiang@intel.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793735557; l=7587;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=CmVa3oKrcSnPNppHdo5trI0VsDTLQFTblrIir2g1OoE=;
 b=m6TH5YyCYXgcye1muzeJWrwsRwg2H0RjTiEQIrZ1P6naZ2y1UFS2I1Mpb8C2zfo2jch+Q8CWg
 oSvgoDYOGxxDIEuD86jRY30scWQma4cx4McYTd6RmAVHwJiGxDkBiyF
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH0PR07CA0007.namprd07.prod.outlook.com
 (2603:10b6:510:5::12) To MI3PR04MB12438.eurprd04.prod.outlook.com
 (2603:10a6:290:76::14)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MI3PR04MB12438:EE_|AMBPR04MB299223:EE_
X-MS-Office365-Filtering-Correlation-Id: b60dbfd2-19ee-4f77-2601-08df39e4126d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|19092799006|11063799006|261022075727099003|261021121427099003|56012099006|261021123027099003|261022105027099003|261009223027099003|261102123227099003|261026140227099003|261026121527099003|261028144727099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	eavj0Sy6NtIJYXVLEGJo5SCjLyOwMpEsWQCQBkYWKks6c+x9E5cmxrhr6Pysy7McZFdOlStek0Ojtd5bZEd9jnPiCo3LvEDuQc7hzIBhOkbnTCUqD4DA5N02EVqyxuBu+jpU2wJOycIDWtIk0k3mcrykrbQy5l5UDbxrRBFH3qvC5a3khCSdtpETKae9pmv7ZJOHjRB0qj0UBpbXdM52b2wPzrE3FhehA53f2o7TLJyQJRSUi79zKIO+MjK90O3POQQrsvHzUqWzjzUfOfzY4WyG3+KKOepPq3e1rmSWQjiQ+v38tgi2YYuxyOBUPBBeWCwfGT2M2M0leJ1Am47rWr+/Pw6QO1c9PvtZV06J/1SSGyEBxsh9OFkcyhROHSDAVGj/rGdk0BKJOsyS1+MzyGWkotBLv05IG+wYE9BUg/iDO7ZfU4FU/zRQNHvinzPG9POXV2C0a4/olC75IacgE37ZD/W8osc8MTavlCJGllQuvUnzcOy/uS8a06NFNdmA05wQ47cPHGL3PCN0A27DYoQigzUVl3Zu8jZVtK7aVe7LSSsBgYioQPSXoPFjzGMPTbF4xORGtsoCwXcTDHjac1LblZkFIFdjKl52oucJQao2z9mGVRH/oWIlQpvGVpDAAU2b9wu8AZyohxA8aiEscwZ7rbaGe+uM2QtNS0hmdKI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MI3PR04MB12438.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(19092799006)(11063799006)(261022075727099003)(261021121427099003)(56012099006)(261021123027099003)(261022105027099003)(261009223027099003)(261102123227099003)(261026140227099003)(261026121527099003)(261028144727099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWwwRmNoSHZjYXdYcjRwZWtHS0MvdHBidER4b0RaL0t0NlpjUm85Qm9GbUlU?=
 =?utf-8?B?MHhrVzlFTVZPSkp4WVFxS0Z6UjdZUGwzczMwdWFYSlNScDl0cnNMbG80d2Zt?=
 =?utf-8?B?Z2VlNUxsRUxrQ0NwbW1wN3cwQkY4MEdSakZIU0dTWXJQc1BFVDg3UlBKVXdz?=
 =?utf-8?B?b09yRzhGQzNHTVZVSzZOUk9MYU5EWVdnclFVTDV1dTdhQkdwc3Q5ZGNBclJB?=
 =?utf-8?B?MTcySkhER1JQbjA3NkdlbXNVODVwRnpXTVdSdXBJbkFSOWRXVkFSZWpidldm?=
 =?utf-8?B?Y0Y5MDNqTDlMMUE0Z0FiSHpqdGNKdFhwN3cxODljTGh3SXZKc1ZHNmlEeXBV?=
 =?utf-8?B?Mm1NcG5ZbndjSHV3VHZZcnhWUlVNMTlhWXAvbUtaeTBxZlNxNTdDMWJFVDNV?=
 =?utf-8?B?RVhMV0VvL1l4NUp5cEJ3eDJMcmhNbno4SnBSWTRJVzQ0a1R5VS8yRVMxa2xh?=
 =?utf-8?B?L0Ftd2EzWUFHNEUzVXd2ZEdoZkVMbENheCswQ0krdDlqWlNjdk5qbXIzTmo4?=
 =?utf-8?B?NW82SjFMNW1VdmVOV21DWmViMWZLVUlQUmh2VW5mVWQ4VmZqekJndHcvcjVP?=
 =?utf-8?B?R0hQKysrcVY4aDNzMmJtNVpFaHVuU1R0TU13WHYwQmVyOVl4UjJ4TEFNYTVH?=
 =?utf-8?B?bkZrMmlMTXpiTm1OaSs1SjljUm9UcDNlSmtXRXhNUFJNSjhqVHJsQUU3OXZE?=
 =?utf-8?B?Vkl3RVdGZTUwT2FqWHQ3S1NjOFpYUGRHV0RGYWhjb1VJMTNsUG45UU5ldmJ0?=
 =?utf-8?B?akozM21XbFRZUUoxczBCQ3I2Zjd4TEpORGUwWXBVVG1UVEZ2bHNDeFQreE1X?=
 =?utf-8?B?aUJESGM1NW9lcXFwbXd2K080QTcyQnJlQ3prYzZPZHQ3S3lWSXVFa0N1bENU?=
 =?utf-8?B?akNmdTZOSkkyT1JyTnhBVXJYK0RsY1pnekx3Q0luZ2tGc0wxU3pwZDN5U3h6?=
 =?utf-8?B?Wm92dFJuZmwyaXZKamRQRG1Va01hTkxFUjdHZWJxdVNaMzk4VUZuVU5LbFpB?=
 =?utf-8?B?L0ZKWjQvUkxsYmFBc0E0Tk1vR1RPdncwVlFMLzgvWG1NeTU0cFF5MEl2YnZx?=
 =?utf-8?B?UEVmcVJDVVhuYU5kTE1WQmliYXZuZGpqTnAvVWdSdEcwQldoTnNDVmNYVGJI?=
 =?utf-8?B?VVVRSjNuNGRya1B2U3pXRTNuM3puZkZGZzdzQVhhMUVjMXpXUUhkYUVMZnNq?=
 =?utf-8?B?UGxhMk5OeGR6Wi93blc3RUlkNWRPcnRvUmlhUi9RT0JtMVY3NmhsMHRheW9R?=
 =?utf-8?B?KzM2STZmcEY5bUpFdDB6QkxSY3FTS1FuY2Qya2grS282ZTBFVFd1OUZrVlB5?=
 =?utf-8?B?cGpyOTNCMzNyVVFxMTl2UTdxbVFWaDRZQkVXVU12bTNIU0FqRmcyOEc0Qlpk?=
 =?utf-8?B?dmJXUy83NEtYQmxHWFZ6aEV4LzEyTVdXQkt5Z1hqNnhpRGpETXBkRnZoeGY5?=
 =?utf-8?B?eFZXQ1ZmQjY4TEUzSTcwK3pqMDdFTldhR0lHcHV5VWs5Z0xCdURlZXRiNXpD?=
 =?utf-8?B?SDVmYXlnZnhFMndQeHo1TG9HYzFrVTFPVFZFRm1hWDdwME5nUWY1eklvZWly?=
 =?utf-8?B?bThzRklGZGU1NVErYUlpcWdMV1FQL0prRStrQitBYlQvRjREcXAzNlhadVhm?=
 =?utf-8?B?Vm5HRE80VG1pUUhEaTFtRTFvaWtqRndTelBmOVZBSndaSllUcGNSZytUNTNO?=
 =?utf-8?B?YlkrTnRDaFlQeEV1bXloT0x5M2hUb3MyMm8xSmVZRVRjRGgzZHJsaWZjRnFC?=
 =?utf-8?B?NytHNm0rQndWcG1yVklLMnFpdExoRm0raFFRS3BjMXhaMlJReDFyVnFjb0Fa?=
 =?utf-8?B?OHUvQnBJOGtLZ2ErSThHQlVkTXlOTHo3NU5MNmk4OUhGUEpTamJvWWwvdlRP?=
 =?utf-8?B?KzBBclVIYnU5YnBJalhZTlA4MWptc0kvNmV5eWdseTlxMDRNUXFLRE1WVGNW?=
 =?utf-8?B?VkI3VnNTVG9zUy8vc3pneGlCTVNXMXdlU2dxcGFiKy85Z0VMT0ppWjJEa3pF?=
 =?utf-8?B?cmNwMy9xbW9ycUE3WG1DekZONGRHTVBIb2hCY1R0UDRON3BDQXpmWGdCeXVT?=
 =?utf-8?B?Vmx6UjZDRDhTN3lSQ2lXb3hKcklmcVhRamczQkJvRVkwUnQ4L3hZdFpPOTdt?=
 =?utf-8?B?WFVBeURLM2VydWFHa2dBZWZIczZnb0xYcktnOCs1MXRIUWxjRzJSRDlWZ1dH?=
 =?utf-8?B?amtTYUpQNkJOS0xYOHZVaDVvZUEvbzhQU0tLSjl2emVlemNjWkQ0Z0pMVWxY?=
 =?utf-8?B?U1BoV1M5TDVKOVlDU08vV1c0RzNINi82UlB4c3NkY1pjeGNhMmxBS3JPSFMv?=
 =?utf-8?B?dzkrVk1pUGN2eVRGM2twMGhFNGtMbUEzVFFWSFRnZzg3SmkxejU3dWp4ekxN?=
 =?utf-8?Q?bK1E7z/HVbriXuLircXypG325aFy4G/4WZTgn?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b60dbfd2-19ee-4f77-2601-08df39e4126d
X-MS-Exchange-CrossTenant-AuthSource: MI3PR04MB12438.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 19:53:03.4943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wxadLIFdYKfI/SgxyhN61iKPFkp6/GW2A/TyWjDFtygEU5yFxXU6CH+wv6jZECn+YIBKxhd1fk04VoVp+cJ+NCsaPhZOI4PR2K4JrMQasXmS90v9+iShMdjKDaLYec2V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR04MB299223

From: Frank Li <Frank.Li@nxp.com>

Replace direct device_prep_dma_(pq|pq_val|interrupt|xor) callback
invocations with dmaengine_prep_dma_(pq|pq_val|interrupt|xor) API,
consistent with how other dmaengine operations use their API.

Assisted-by: LLM
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_pq.c          | 23 +++++++++++------------
 crypto/async_tx/async_raid6_recov.c | 10 ++++------
 crypto/async_tx/async_tx.c          | 13 ++-----------
 crypto/async_tx/async_xor.c         | 19 ++++++++-----------
 4 files changed, 25 insertions(+), 40 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 5f62f2edefe58..6ccc1073c5ace 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -40,7 +40,6 @@ do_async_gen_syndrome(struct dma_chan *chan,
 		      struct async_submit_ctl *submit)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
-	struct dma_device *dma = chan->device;
 	enum async_tx_flags flags_orig = submit->flags;
 	dma_async_tx_callback cb_fn_orig = submit->cb_fn;
 	dma_async_tx_callback cb_param_orig = submit->cb_param;
@@ -76,11 +75,11 @@ do_async_gen_syndrome(struct dma_chan *chan,
 		for (;;) {
 			dma_dest[0] = unmap->addr[disks - 2];
 			dma_dest[1] = unmap->addr[disks - 1];
-			tx = dma->device_prep_dma_pq(chan, dma_dest,
-						     &unmap->addr[src_off],
-						     pq_src_cnt,
-						     &scfs[src_off], unmap->len,
-						     dma_flags);
+			tx = dmaengine_prep_dma_pq(chan, dma_dest,
+						   &unmap->addr[src_off],
+						   pq_src_cnt,
+						   &scfs[src_off], unmap->len,
+						   dma_flags);
 			if (likely(tx))
 				break;
 			async_tx_quiesce(&submit->depend_tx);
@@ -358,12 +357,12 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
 		for (;;) {
-			tx = device->device_prep_dma_pq_val(chan, pq,
-							    unmap->addr,
-							    src_cnt,
-							    coefs,
-							    len, pqres,
-							    dma_flags);
+			tx = dmaengine_prep_dma_pq_val(chan, pq,
+						       unmap->addr,
+						       src_cnt,
+						       coefs,
+						       len, pqres,
+						       dma_flags);
 			if (likely(tx))
 				break;
 			async_tx_quiesce(&submit->depend_tx);
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index 4f223fa36c706..0e3ae945154fc 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -22,7 +22,6 @@ async_sum_product(struct page *dest, unsigned int d_off,
 {
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
 						      &dest, 1, srcs, 2, len);
-	struct dma_device *dma = chan ? chan->device : NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 	const u8 *amul, *bmul;
 	u8 ax, bx;
@@ -52,8 +51,8 @@ async_sum_product(struct page *dest, unsigned int d_off,
 		pq[1] = unmap->addr[2];
 
 		unmap->len = len;
-		tx = dma->device_prep_dma_pq(chan, pq, unmap->addr, 2, coef,
-					     len, dma_flags);
+		tx = dmaengine_prep_dma_pq(chan, pq, unmap->addr, 2, coef,
+					   len, dma_flags);
 		if (tx) {
 			dma_set_unmap(tx, unmap);
 			async_tx_submit(chan, tx, submit);
@@ -91,7 +90,6 @@ async_mult(struct page *dest, unsigned int d_off, struct page *src,
 {
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
 						      &dest, 1, &src, 1, len);
-	struct dma_device *dma = chan ? chan->device : NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 	const u8 *qmul; /* Q multiplier table */
 	u8 *d, *s;
@@ -120,8 +118,8 @@ async_mult(struct page *dest, unsigned int d_off, struct page *src,
 		 * dma_dest[1] and ignores dma_dest[0] as a dest
 		 * due to DMA_PREP_PQ_DISABLE_P
 		 */
-		tx = dma->device_prep_dma_pq(chan, dma_dest, unmap->addr,
-					     1, &coef, len, dma_flags);
+		tx = dmaengine_prep_dma_pq(chan, dma_dest, unmap->addr,
+					   1, &coef, len, dma_flags);
 
 		if (tx) {
 			dma_set_unmap(tx, unmap);
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index f6e8f68f00972..90d6df9f872cc 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -66,7 +66,6 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 			struct dma_async_tx_descriptor *tx)
 {
 	struct dma_chan *chan = depend_tx->chan;
-	struct dma_device *device = chan->device;
 	struct dma_async_tx_descriptor *intr_tx = (void *) ~0;
 
 	/* first check to see if we can still append to depend_tx */
@@ -86,10 +85,7 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 	/* see if we can schedule an interrupt
 	 * otherwise poll for completion
 	 */
-	if (dma_has_cap(DMA_INTERRUPT, device->cap_mask))
-		intr_tx = device->device_prep_dma_interrupt(chan, 0);
-	else
-		intr_tx = NULL;
+	intr_tx = dmaengine_prep_dma_interrupt(chan, 0);
 
 	if (intr_tx) {
 		dmaengine_desc_set_callback(intr_tx, NULL, NULL, NULL);
@@ -219,21 +215,16 @@ struct dma_async_tx_descriptor *
 async_trigger_callback(struct async_submit_ctl *submit)
 {
 	struct dma_chan *chan;
-	struct dma_device *device;
 	struct dma_async_tx_descriptor *tx;
 	struct dma_async_tx_descriptor *depend_tx = submit->depend_tx;
 
 	if (depend_tx) {
 		chan = depend_tx->chan;
-		device = chan->device;
 
 		/* see if we can schedule an interrupt
 		 * otherwise poll for completion
 		 */
-		if (device && !dma_has_cap(DMA_INTERRUPT, device->cap_mask))
-			device = NULL;
-
-		tx = device ? device->device_prep_dma_interrupt(chan, 0) : NULL;
+		tx = dmaengine_prep_dma_interrupt(chan, 0);
 	} else
 		tx = NULL;
 
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 0fb29da2235cd..3cbe08883085b 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -62,9 +62,8 @@ do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 		tmp = src_list[0];
 		if (src_list > unmap->addr)
 			src_list[0] = dma_dest;
-		tx = dma->device_prep_dma_xor(chan, dma_dest, src_list,
-					      xor_src_cnt, unmap->len,
-					      dma_flags);
+		tx = dmaengine_prep_dma_xor(chan, dma_dest, src_list,
+					    xor_src_cnt, unmap->len, dma_flags);
 
 		if (unlikely(!tx))
 			async_tx_quiesce(&submit->depend_tx);
@@ -72,10 +71,9 @@ do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 		/* spin wait for the preceding transactions to complete */
 		while (unlikely(!tx)) {
 			dma_async_issue_pending(chan);
-			tx = dma->device_prep_dma_xor(chan, dma_dest,
-						      src_list,
-						      xor_src_cnt, unmap->len,
-						      dma_flags);
+			tx = dmaengine_prep_dma_xor(chan, dma_dest, src_list,
+						    xor_src_cnt, unmap->len,
+						    dma_flags);
 		}
 		src_list[0] = tmp;
 
@@ -335,15 +333,14 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 		}
 		unmap->len = len;
 
-		tx = device->device_prep_dma_xor_val(chan, unmap->addr, src_cnt,
-						     len, result,
-						     dma_prep_flags);
+		tx = dmaengine_prep_dma_xor_val(chan, unmap->addr, src_cnt,
+						len, result, dma_prep_flags);
 		if (unlikely(!tx)) {
 			async_tx_quiesce(&submit->depend_tx);
 
 			while (!tx) {
 				dma_async_issue_pending(chan);
-				tx = device->device_prep_dma_xor_val(chan,
+				tx = dmaengine_prep_dma_xor_val(chan,
 					unmap->addr, src_cnt, len, result,
 					dma_prep_flags);
 			}

-- 
2.43.0

