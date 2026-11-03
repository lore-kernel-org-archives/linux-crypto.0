Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793735596;
	b=ilLsd1nNDMLQihXQyluoFAP+pFY3HYDGcDJH4rAbKAPKW+df6dxzJB6FwgyzbXq/33vU
	 KCn7K6G0ehdacuM7+mw4Gn1e6pC0bt4YfRaIqLo39HU95zNMPzIegE7oNyubh21e/iKLQ
	 90SdUbct68OJLNAzsAqegJ/1CaYg3YPv7JEDEydr5KsuP0W+y2yhGfoJAxhsPMURJSaxH
	 5K9cqHbXhY+6xE3KY8ekDQlCBcy0PrJb/gXJCN2IOEG01X36OglwjtMqkR1zkDw2I6XfA
	 sSA/O+fD2FPIR0gIs3cEx1917KHLSb3wzKwra59n0UnaUPTvxKoRhlcTH7rval4tpMw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735596;
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
	bh=Fo2StrG289/WfQzHKauRX0nrs787lDF/VzOBM/lfH6w=;
	b=V8uFYqtvFV9FW+0d4n1iBUF055cRF7+QiQxCYR3K26z0x+FgHhYEQHJ5CYhXrNuUVAh/
	 Uj46anQSxlARYKRBozmMVKi3H8GoURUVOv0yRYkQoH82RQP6nv0UfzsmJw0hDW1pKPg4h
	 xpwtTZKPfO47ZdZjIX1nsXOzMrwR1CNiPDYWZ8FjIEbAZm1l+Y9h0R0E/9yaVfoXPpCAW
	 4MB3eEF+TabQe7Eh40aav8v+r5Bwiy74wMPTgX8SZgUOnEfZlJ+K2GdEEUGXY2sDek99e
	 Mv1jH1ntQK7tNJgP7CsyfFG7+cyOXiSYZ3PxQItRKoE4/CYxV58eibSqBeO0MJwC0rQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=OlDRswap;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.64
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013064.outbound.protection.outlook.com [40.107.159.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2A9606A324;
	Tue,  3 Nov 2026 19:53:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B2A9606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=OlDRswap
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XJluf64+HFoX6gUvVF2ULLxfO/PS+r8RBT7HDC7n0vhJ0/WgZDATyjHOJKkVcFPQEtboqdrFs4QNod8eOGpxsu5CLhysisWk7QrYmF1EDzR1L2whs3a2T0gZR6jABItQ/VV0V23ilkcurZEt24ftsV0q0PK5HFCWPoSatnDIF6ow4CipLQi7Vd2E3cxlodgYCtC92IltvOyxRJEVSuKl2zAFKO8Rl302pLU1AQgmVtmzenMGutFQeZVf5XWgauzawG+9t0LiBihM5XcCgQB4ehj+2fhyrQneWH5v81BG2LMQXXInXJtXhKfjBJAhkktwz7+CPGcvYG1eHGj2+P73sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fo2StrG289/WfQzHKauRX0nrs787lDF/VzOBM/lfH6w=;
 b=SVIbqT/jjkhpfmZmgyiyrDdqEuPN4zbTMMBcoMWVIKIlssxNSvPBnGgYz+ToLyMVgsgaLHGamCqru34qbHPj4HP9SNy9HtOSTw/dknjNzKSTgV6YVWBvVD+5iQN4tvxb/uV0YU5RIH3CxanCD+clKhwhJG8nqTpeNVljVkbj6/xKNMVt8iubz1YAAbfCcBE2ZEf3mTRktLhN7c2FegBxe1hZpYhGd/7DovpePa4DDoLW5IQUuBKsB+p/v0+buOcc0OeO+d88xvfVfGSWPQ+Ee5j2N9a4zG26e6rSLct3hIcQQfcHWeT2UV/ay0TJ62pSZZbp9DTfjGUWTNnAf85XNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fo2StrG289/WfQzHKauRX0nrs787lDF/VzOBM/lfH6w=;
 b=OlDRswapjpBaS/zWBqDWtAfVbhywLwZs4/92+fTNQFf0+97KC4YFs3n3/lXd9/InEzpYOstryvifiWCDU8KiMlp01W0FYs4pJiCz23OnMvp7LVxXKTJqs6FD6oYqZzaJbrgXJSO6LkQvp2tIn5gTsMGheZdeI3FBeOUYUfeEJZXEUT/2/S/TuYCYJM1iMJ9s7pf8cwiunpEYpt75OEnVQINmKvVsmRzDJKFA6SzNsYI8De6rGiG57W1GxwhGO5kdniYmSvQqtK5N1MDD75VsLX44DJoWlSYeQAF3wwgnZIGVAMYTK50lTOBGDIrLQtGCl4qvuCESPAIsVrfTJZcMJA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com (2603:10a6:290:76::14)
 by OSKPR04MB11366.eurprd04.prod.outlook.com (2603:10a6:e10:96::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Tue, 3 Nov 2026
 19:53:11 +0000
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b]) by MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 19:53:09 +0000
From: Frank.Li@oss.nxp.com
Date: Tue, 03 Nov 2026 14:52:36 -0500
Subject: [PATCH v2 5/7] async_tx: convert to dmaengine_is_*_aligned()
 helpers
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-async_tx_dma-v2-5-3afc7c59362c@nxp.com>
References: <20261103-async_tx_dma-v2-0-3afc7c59362c@nxp.com>
In-Reply-To: <20261103-async_tx_dma-v2-0-3afc7c59362c@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org, 
 Frank Li <Frank.Li@nxp.com>, Peng Fan <peng.fan@nxp.com>, 
 Dave Jiang <dave.jiang@intel.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793735557; l=7867;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=2MRIB1Q+/jmi5SOtqVilDPSRqCbCGdirOiptANZf4cs=;
 b=cHFTUJa/Ca9UzRIrYVhb1RXvD63bgJa8uznn4v3ypdUrtLxdLrqbzJ+pK0twM+HpGNEcRke0h
 hSM1KSdlTcVDJB+RVp32MngZTFa7bKjxluahJ5C7MxUlp2mQ2AidCrW
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH8PR02CA0006.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::23) To MI3PR04MB12438.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: MI3PR04MB12438:EE_|OSKPR04MB11366:EE_
X-MS-Office365-Filtering-Correlation-Id: 19e81ce7-dd96-4cbe-cd37-08df39e415bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|19092799006|11063799006|56012099006|261021121427099003|261021123027099003|261009223027099003|261021135927099003|261021130227099003|261022115727099003|261021133027099003|261102123227099003|261022075727099003|261022105027099003|261022113327099003|261028144727099003|261026121527099003|261026140227099003|261026130827099003|261026135527099003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	BFBpkxj9ik4piRDr4Da8UQhsPHDU/k2L6FE+GdlQF86/Xy0+KgTQElpVmaKujwbZ5EvSUeImFJn3jRx+Hl45RjBxEDLK++d323AS89OGZBtCyPxGnVQQ2C8dgWzkduxbTH9sjus1Rbp0nbwAbrOS4LZijSv68nahSc7fJqaPEH82Kvcq3Zb1HGozTIKBa+7nM2p/GW4fxWsMLXI/Cl0bOPTFJ1ac5NG4+8taeAaDvdWIU5RkvgFf1fNA8VvkgyUr9dQnxCoP1wt/Ydc40PVS23RZ2/kq76aaGMIBH2T/q3iFMxzICMhIm7ttFK8tCE05dJTNdHPLg4/UgsCykBnWUqEkm+8vcEXE6BkIVj4R+AOwzmoAxlaKaLChKujLECsSVzDKu51BRiP3CdNPdeOCnwDVe8rzFzKkEy/O2enLycKdCEuSXf/NTmHozXCPxBQF5bToQ5HOo+sCKzWg5Qt/aDgek2WnQ4BvDTBmt3T9FSgxl1uYbyp3a4GubWN3BhmdSS8y3BZt2ChvUGhiPawrfXoJD1mHTBZA7V+pzpNtO5JjY+VQXyFD2HbaaH8skvJB5kIaP1hN4nYi7RB0pyxSImPdSEBTHuWwfH+nIBp2XykhI0+8TCplKCTyGiRFi1ieKK2EIDbJE8xpD+4l2XANm7egN2OEZhDHAu5iz1SaiQo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MI3PR04MB12438.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(19092799006)(11063799006)(56012099006)(261021121427099003)(261021123027099003)(261009223027099003)(261021135927099003)(261021130227099003)(261022115727099003)(261021133027099003)(261102123227099003)(261022075727099003)(261022105027099003)(261022113327099003)(261028144727099003)(261026121527099003)(261026140227099003)(261026130827099003)(261026135527099003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzVTR1BXVlNWdVd4UnhzQU9UWW1hVnBMMjBqWmZucjdtNGFKTlVJSzk1S25j?=
 =?utf-8?B?SXJySjhMclczM3dvUXZzM2lqNmxJNmRTQWlGQmtWUEtBNnZIMmU5Nlh2RkxM?=
 =?utf-8?B?RHltTklGc00xbDl4OG1pTk4zZEUyZkhwT0JFd2J4cGdlam5sL3B5eWdZaklI?=
 =?utf-8?B?SDFMbEdDaUJORUxuTGhLb21tS1Z1QjloTkJ1TEw4ZEpONGJiNzd4QVJydkcw?=
 =?utf-8?B?ZW1XZmk3VGNKUEpNaXVrOEd6NG5LcVYwWkVveGlaMkJkZFpJeWUxdWJtUXZN?=
 =?utf-8?B?bVRIWUVSVTlxUnBUcG9IZzdxYU5UZm51ME1OZGhGdzNOckxNNS9XRHNZT2E4?=
 =?utf-8?B?K2VaSHpwSE9aTEpnMndiYi9va282UEw2cFU3Y0srSlR5b25LcnkzelNUd0N0?=
 =?utf-8?B?Mkt4M2YvVEV3czY3WGpicEdpYm11bmJmVXFDY2YxaXlaKytOcmYvVGpnTzdr?=
 =?utf-8?B?YUhsMS9TcUwvd3NSZ01CcDdkTWhjeTF2RkdBQnoybnRNYlhoYzJYZ2x0dVZj?=
 =?utf-8?B?M2dpVzMrVUc3ZEVNSmM0UDF0NUxYS1l6elByeFMyVW9jWTM1a2d5UzlOeFNm?=
 =?utf-8?B?NSthYys1cGVGeUNLUURiM2FmMXJSOUVNeUg2cmkzMElJdWdrbWdaMWFYdmdr?=
 =?utf-8?B?ZTNwckRkdzRLd0FoV080NGxTdmhBTGREOE9HREJEUEZNdVhrMnJIWENudWxJ?=
 =?utf-8?B?WCs2KzFmSUo2ZW44Y01KUUJpdzcvQmo5Y2J2Q0FnVW84UXplVFE5Q0xPUHJP?=
 =?utf-8?B?U1NFdnBUREwwWHQvQU5pYTNGa2laV01jSk5FNkFiVEVFbDN2M2MwNHlWMG9K?=
 =?utf-8?B?TGZuY0hUbWRUcGIzeHBtdjBBbUxlOW5CRGJlRUZpdjYyUVBXZWFHZVRtU3dw?=
 =?utf-8?B?VU9hbXhBRlJEUC9PSnNGYzMyOEx2VDJkR2hqQU15VjBhL3IvUDlmZkNIN0dr?=
 =?utf-8?B?M1lOK1ZwRk1TVkl1bTNkSXRRTCtVcithTXR5dGlKcjhJQ0hXZ0hJaFlpTzRY?=
 =?utf-8?B?aXV3NE43emtZTE1jbXRRSG96THZMbXBXWURycW9lL0J0YkV1eFdYUnhJcFln?=
 =?utf-8?B?SGhUVW1wQVNEUy9SaVZlNWxZQnhSN1hSVzFDYURrd2xkQkg3WlczSFFFSE9C?=
 =?utf-8?B?SFNEMnZLUVdpek5uc05aMFFiSkNhWnhPYVljaFpEa3V6OUZYV3BxZUcrMi9M?=
 =?utf-8?B?R20zMGRDbUpKaHIvSGxCTmtHMkZScDMzMUh6RkpQaGo1UDAzekFwcDV5b1d3?=
 =?utf-8?B?SXdjT0ROdmdkdDJQTmw1ZkFIYjUxTTY2QU8zRVlrNC9jdENabzdNc3NSZml1?=
 =?utf-8?B?OEpBcEZPZ2ticnY1QlVhVUdlclQrS25GYitVZDJWMmtNZnh3c1ZJZmFCNmd0?=
 =?utf-8?B?NC8rTDl3UFl4Ti9FMkU5ME8vbmRkcW5zOTdQOS9QRFVnK0JEK3c1UlJuMzI0?=
 =?utf-8?B?R1hXbnY2RDdVY252NVhNcE9Jd09udGJUZkVLcUExdS9uZ01ONDVlNmtuUzdW?=
 =?utf-8?B?aTVMM3pucWRCTm5iQnZqRDdGSmIxc1oyLzlSazBpUEF0QlFGWXVCcFdCSGJk?=
 =?utf-8?B?aWI0Y3dsNDAxMFFYSEQ3TmVLaVVsWVA1eGpiaUVWVHJOcHlaOUoyYWI4dDlm?=
 =?utf-8?B?blhjNlp3elBDTHFZbzNiYnlaSnFhRGdIWWQwcjlPYkhWN1BocHRSSkgybDI1?=
 =?utf-8?B?enU5alNvQWttZ0R4Y0NBdDdPVHlMVHhYbXRLNnBiNnBiR0FlMTRMTlZWTTVk?=
 =?utf-8?B?YjI0RUFjaEt4OEx2MjVuMGlLWEhZaUFqcExZR1c3WkFGRytrY0QxYW13enJK?=
 =?utf-8?B?S3p1MnFWNUx0RDZsbGJiazFOek1ndkFKRDBNSUFSU1RkZ0NBRHBIeUpIbHJY?=
 =?utf-8?B?OEFsRlRabnN1Q2dPSmxwb1QxeGZrZWg0SjhyUVRwd3IxaWtDUW1HYzAvYjQw?=
 =?utf-8?B?enlkaGZ3NFJmTk9xRGVTcVVaMEZyLzdxbnB3YVIrZ0ZqeWdlMElLSlVJdGkz?=
 =?utf-8?B?VjVUMGM1c1kzRmN4azlnS0RqSUEyZ01kYjcvV1NpN01PL2VWQjNBY3JjMVRI?=
 =?utf-8?B?STYySTR6VXBDbjRucVpkTUtXbXhKaUFHZnJPTVZEMTlPQmNKOVErOWxYUm8z?=
 =?utf-8?B?dWdTSzF5THdLYlU0RmhmNkVmd1VMZHNxMW45TTk2T0xQSzM1RE91d3BRNmMx?=
 =?utf-8?B?Q3VMM21ON2JrT3pobC9oSFdwOW8zMTZQUkZyZGZYT1NEOFdwdWdJd3RmY29X?=
 =?utf-8?B?SmxzTkw5K3BUNDdmcWJua3Y0L1RJVy9UemI4OW5lZE9EL2tUdnoyT0o5YnZG?=
 =?utf-8?B?QzZmU0pudjNMTlFqSGxyQ203WUpTMEhxT3c2Rzk4bGwzTDBUUEhGNVZkc0J4?=
 =?utf-8?Q?9v/bt7oNcM/JlQM0LMuhTRYoNdEdzCDjDMKj1?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19e81ce7-dd96-4cbe-cd37-08df39e415bf
X-MS-Exchange-CrossTenant-AuthSource: MI3PR04MB12438.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 19:53:09.0741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nXJlMqZxZnbX9PphJqS9ZPTPLbcPenmGiJWy8KBZhCRsoQVfDh6DAj5RhjU5+CT9WZfCVeGEY60M3c73HctBzxH6bbtIBibSULfTURAQQssLtsmXJPQvaRRw1oEr06FJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSKPR04MB11366

From: Frank Li <Frank.Li@nxp.com>

Replace is_dma_{copy,xor,pq}_aligned() calls with the new
dmaengine_is_{copy,xor,pq}_aligned() helpers that take a struct
dma_chan * instead of struct dma_device *. Also update the internal
helpers dma_xor_aligned_offsets() and is_dma_pq_aligned_offs() to
take struct dma_chan * accordingly.

Also use dmaengine_get_max_xor() to get max_xor.

Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_memcpy.c |  3 +--
 crypto/async_tx/async_pq.c     | 12 +++++-------
 crypto/async_tx/async_xor.c    | 23 ++++++++++-------------
 3 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 49ee66759c7e9..972670094be0a 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -35,14 +35,13 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 {
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_MEMCPY,
 						      &dest, 1, &src, 1, len);
-	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 
 	if (chan)
 		unmap = dmaengine_get_unmap_data(chan, 2, GFP_NOWAIT);
 
-	if (unmap && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
+	if (unmap && dmaengine_is_copy_aligned(chan, src_offset, dest_offset, len)) {
 		unsigned long dma_prep_flags = 0;
 		struct device *dma_dev =  dmaengine_get_dma_device(chan);
 
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 6ccc1073c5ace..30d6ee676dd44 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -140,13 +140,13 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 }
 
 static inline bool
-is_dma_pq_aligned_offs(struct dma_device *dev, unsigned int *offs,
-				     int src_cnt, size_t len)
+is_dma_pq_aligned_offs(struct dma_chan *chan, unsigned int *offs,
+		       int src_cnt, size_t len)
 {
 	int i;
 
 	for (i = 0; i < src_cnt; i++) {
-		if (!is_dma_pq_aligned(dev, offs[i], 0, len))
+		if (!dmaengine_is_pq_aligned(chan, offs[i], 0, len))
 			return false;
 	}
 	return true;
@@ -181,7 +181,6 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
 						      &P(blocks, disks), 2,
 						      blocks, src_cnt, len);
-	struct dma_device *device = chan ? chan->device : NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 
 	BUG_ON(disks > MAX_DISKS || !(P(blocks, disks) || Q(blocks, disks)));
@@ -193,7 +192,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 	if (unmap && !(submit->flags & ASYNC_TX_PQ_XOR_DST) &&
 	    (src_cnt <= dmaengine_maxpq(chan, 0) ||
 	     dmaengine_maxpq(chan, DMA_PREP_CONTINUE) > 0) &&
-	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
+	    is_dma_pq_aligned_offs(chan, offsets, disks, len)) {
 		struct dma_async_tx_descriptor *tx;
 		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		enum dma_ctrl_flags dma_flags = 0;
@@ -301,7 +300,6 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 		   unsigned int s_off, struct async_submit_ctl *submit)
 {
 	struct dma_chan *chan = pq_val_chan(submit, blocks, disks, len);
-	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx;
 	unsigned char coefs[MAX_DISKS];
 	enum dma_ctrl_flags dma_flags = submit->cb_fn ? DMA_PREP_INTERRUPT : 0;
@@ -313,7 +311,7 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 		unmap = dmaengine_get_unmap_data(chan, disks, GFP_NOWAIT);
 
 	if (unmap && disks <= dmaengine_maxpq(chan, 0) &&
-	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
+	    is_dma_pq_aligned_offs(chan, offsets, disks, len)) {
 		struct device *dev = dmaengine_get_dma_device(chan);
 		dma_addr_t pq[2];
 		int i, j = 0, src_cnt = 0;
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 3cbe08883085b..cf3eedaf2a75b 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -23,7 +23,6 @@ static __async_inline struct dma_async_tx_descriptor *
 do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 	     struct async_submit_ctl *submit)
 {
-	struct dma_device *dma = chan->device;
 	struct dma_async_tx_descriptor *tx = NULL;
 	dma_async_tx_callback cb_fn_orig = submit->cb_fn;
 	void *cb_param_orig = submit->cb_param;
@@ -38,7 +37,7 @@ do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 		dma_addr_t tmp;
 
 		submit->flags = flags_orig;
-		xor_src_cnt = min(src_cnt, (int)dma->max_xor);
+		xor_src_cnt = min_t(int, src_cnt, dmaengine_get_max_xor(chan));
 		/* if we are submitting additional xors, leave the chain open
 		 * and clear the callback parameters
 		 */
@@ -124,19 +123,19 @@ do_sync_xor_offs(struct page *dest, unsigned int offset,
 }
 
 static inline bool
-dma_xor_aligned_offsets(struct dma_device *device, unsigned int offset,
-		unsigned int *src_offs, int src_cnt, int len)
+dma_xor_aligned_offsets(struct dma_chan *chan, unsigned int offset,
+			unsigned int *src_offs, int src_cnt, int len)
 {
 	int i;
 
-	if (!is_dma_xor_aligned(device, offset, 0, len))
+	if (!dmaengine_is_xor_aligned(chan, offset, 0, len))
 		return false;
 
 	if (!src_offs)
 		return true;
 
 	for (i = 0; i < src_cnt; i++) {
-		if (!is_dma_xor_aligned(device, src_offs[i], 0, len))
+		if (!dmaengine_is_xor_aligned(chan, src_offs[i], 0, len))
 			return false;
 	}
 	return true;
@@ -171,7 +170,6 @@ async_xor_offs(struct page *dest, unsigned int offset,
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_XOR,
 						      &dest, 1, src_list,
 						      src_cnt, len);
-	struct dma_device *device = chan ? chan->device : NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 
 	BUG_ON(src_cnt <= 1);
@@ -179,8 +177,8 @@ async_xor_offs(struct page *dest, unsigned int offset,
 	if (chan)
 		unmap = dmaengine_get_unmap_data(chan, src_cnt + 1, GFP_NOWAIT);
 
-	if (unmap && dma_xor_aligned_offsets(device, offset,
-				src_offs, src_cnt, len)) {
+	if (unmap && dma_xor_aligned_offsets(chan, offset, src_offs,
+					     src_cnt, len)) {
 		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		struct dma_async_tx_descriptor *tx;
 		int i, j;
@@ -303,7 +301,6 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 		struct async_submit_ctl *submit)
 {
 	struct dma_chan *chan = xor_val_chan(submit, dest, src_list, src_cnt, len);
-	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 
@@ -312,8 +309,8 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 	if (chan)
 		unmap = dmaengine_get_unmap_data(chan, src_cnt, GFP_NOWAIT);
 
-	if (unmap && src_cnt <= device->max_xor &&
-	    dma_xor_aligned_offsets(device, offset, src_offs, src_cnt, len)) {
+	if (unmap && src_cnt <= dmaengine_get_max_xor(chan) &&
+	    dma_xor_aligned_offsets(chan, offset, src_offs, src_cnt, len)) {
 		unsigned long dma_prep_flags = 0;
 		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		int i;
@@ -351,7 +348,7 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 		enum async_tx_flags flags_orig = submit->flags;
 
 		pr_debug("%s: (sync) len: %zu\n", __func__, len);
-		WARN_ONCE(device && src_cnt <= device->max_xor,
+		WARN_ONCE(chan && src_cnt <= dmaengine_get_max_xor(chan),
 			  "%s: no space for dma address conversion\n",
 			  __func__);
 

-- 
2.43.0

