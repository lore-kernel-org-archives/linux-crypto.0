Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11020078.outbound.protection.outlook.com [52.101.69.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448E138BF60;
	Tue, 24 Feb 2026 16:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771949402; cv=fail; b=vBR6yvJshBhGZO3bAjO8/8oE/enyqjAFBd6o9baoYuIyOYNS5GPojeTvHKxYkAxk90uo4jmybGYNt5Io4mv3QuKp8oewsJ9PwCaLxaq967TZnUOmlUAANKSC+CBjvb4SOhdE5utU8831+PiQRBoyRKvsWSzrKsFoapfLxZpGcGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771949402; c=relaxed/simple;
	bh=d53bM4bp5fECmZQR5D+MLhc4IE6aeald0ehFKYnv+Wc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qk+lTKnQcMjqTIEBB9qVTsyRz+lWsC8oCx0wf10fQoC1n1NOco/G51z1ZIsc4Mn1Fw/jU60mD5piMMI2x6yEswozm8gKdr6zpSogOTyjFM9Rm57bKlzoI7ZAsoSmnP3FdNgTQabxaabo7AIepzQVK3+freNf/RFFg5zzf10RAlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com; spf=pass smtp.mailfrom=ginzinger.com; dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b=PQeXUL5i; arc=fail smtp.client-ip=52.101.69.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ginzinger.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ginzinger.com header.i=@ginzinger.com header.b="PQeXUL5i"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OMSLWH2gnkp/3EmvScA/0yY+kEZsXtGKRv7Df7fdDQTYUMvfH1UFCOvOp0P/Be7A1N5KRqZQ9j0XlMuvNgMi/0u8/IVSsvIBfbgry8DcSrsULRPRXPIREXKOZe7SoJ/39Jrpb3e3V0M+LA6grQbBS/lmpXFijc2eHyztxQ84i9ct46a+Lu8CZOGvkhEalnELWxYpFlDBLqO54ZNTOanrSBgL7yg3Vpkh2apbQVKyMhICYdhrelMUS5x5ypAvuH+3kn3Rrtj6veI8jlxUTwY9EFpiqPTScL8DcfVe3Dmy043XGIRbn9/t/PnmbkvAtajCvmjvuNvJFiIGtQptL/O/Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d53bM4bp5fECmZQR5D+MLhc4IE6aeald0ehFKYnv+Wc=;
 b=kE4XYayUc5O4ghu0vytbtBeSz4IusPy7l1pcFzprcRbPKYEVuLjNuJ5ow3bZAqhBkP5PIqzlXArGReUYl75Jv4/6U3/lGCqJtdp13te9XD0YgVil2Og9WJ7GX9Pmr28ve+QsVgznScys8hDrvdJfRN+DWlgEmRfQswC35dWuv1mFYe26ocF/BTQNbYKI82dSdQDm836d9f/mVsIWSDM/yKZqidw0aldcPumhx5MDVVlJIrfqWOkm8Ny1Q+57+6AiVPbJ7j1OVdkv6UqRQZhw0DFITbbblUxzT8CmzfYxlvb6tDqJEQWWyDVGTFUIEtVWEnp2H1PvZwUxKxpxw4G8Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 20.93.157.195) smtp.rcpttodomain=wunner.de smtp.mailfrom=ginzinger.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=ginzinger.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ginzinger.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d53bM4bp5fECmZQR5D+MLhc4IE6aeald0ehFKYnv+Wc=;
 b=PQeXUL5iPGa4G4K4/H6GY9ce5OQB9ZygUWrPAPmKvL697TVPqSKH13MofboHzVD77wVV16p4ypv347k0j56ejet83KTxc/UeBro9gu2uIOYgNRkF/VNWYdCHIKRID2d1sW/xe6xlxpp7lhdaKiB6vXK1BP6/x2V3QCKqnxxSNhP+FItJSKduH0VKZecIutFWxvlKHJO6/zMNHAiK1VGjau3A++zykNh4PTNO19iFAJkXumjdOk3DN/PrPhpxMa3Ycz9ys94LuJCDfQ1l806DJu8guSLyWGPoVlql7axHx7ZMmMdK/ag/jIh718Igywfvaj7mZXI1iJQrZOfREiKESQ==
Received: from DB9PR06CA0005.eurprd06.prod.outlook.com (2603:10a6:10:1db::10)
 by AMBPR06MB10743.eurprd06.prod.outlook.com (2603:10a6:20b:72c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 16:09:57 +0000
Received: from DU6PEPF00009523.eurprd02.prod.outlook.com
 (2603:10a6:10:1db:cafe::9b) by DB9PR06CA0005.outlook.office365.com
 (2603:10a6:10:1db::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Tue,
 24 Feb 2026 16:09:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.93.157.195)
 smtp.mailfrom=ginzinger.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ginzinger.com;
Received-SPF: Pass (protection.outlook.com: domain of ginzinger.com designates
 20.93.157.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.93.157.195; helo=westeu11-emailsignatures-cloud.codetwo.com;
 pr=C
Received: from westeu11-emailsignatures-cloud.codetwo.com (20.93.157.195) by
 DU6PEPF00009523.mail.protection.outlook.com (10.167.8.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 24 Feb 2026 16:09:56 +0000
Received: from DUZPR08CU001.outbound.protection.outlook.com (40.93.64.67) by westeu11-emailsignatures-cloud.codetwo.com with CodeTwo SMTP Server (TLS12) via SMTP; Tue, 24 Feb 2026 16:09:55 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com (2603:10a6:803:d6::26)
 by DB9PR06MB7642.eurprd06.prod.outlook.com (2603:10a6:10:256::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 16:09:53 +0000
Received: from VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25]) by VI1PR06MB5549.eurprd06.prod.outlook.com
 ([fe80::2c95:365d:522:dd25%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 16:09:51 +0000
From: Kepplinger-Novakovic Martin <Martin.Kepplinger-Novakovic@ginzinger.com>
To: Lukas Wunner <lukas@wunner.de>
CC: "horia.geanta@nxp.com" <horia.geanta@nxp.com>, "pankaj.gupta@nxp.com"
	<pankaj.gupta@nxp.com>, "gaurav.jain@nxp.com" <gaurav.jain@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "ignat@cloudflare.com"
	<ignat@cloudflare.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [BUG] crypto: caam - RSA encrypt doesn't always complete new
 data in out_buf
Thread-Index: AQHcpZhLhQf6tsYBZky80qwgD1KH9rWR8nmAgAASVwA=
Date: Tue, 24 Feb 2026 16:09:51 +0000
Message-ID: <e1d7ad1106dbb259f7c61bdd1910ac9f08012725.camel@ginzinger.com>
References: <6029acc0f0ddfe25e2537c2866d54fd7f54bc182.camel@ginzinger.com>
	 <aZ296wd7fLE6X3-U@wunner.de>
In-Reply-To: <aZ296wd7fLE6X3-U@wunner.de>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ginzinger.com;
x-ms-traffictypediagnostic:
	VI1PR06MB5549:EE_|DB9PR06MB7642:EE_|DU6PEPF00009523:EE_|AMBPR06MB10743:EE_
X-MS-Office365-Filtering-Correlation-Id: 88e7b8fc-e459-41e5-78ef-08de73bf274a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?RFd3Umt5Y3FiZVdrV1pOZW94UkN2bWxNMTBWWlV0dXlpZE5rWHdWWFhQSWJG?=
 =?utf-8?B?VjNzTmRkdjNqTi8wdUpsMnUvYzIxenI0d1J3STJlZ3d3TS8rQ25rQm1zWU94?=
 =?utf-8?B?Y1JTbGlGVnZ1MktmUHh5aVZFbmRQTHlEWTFUZEE0YktCYVYzeDRFZ2tyUUM2?=
 =?utf-8?B?U3MrZWd6VEIxYzUxbTNMcHNLYVloUEVUVUo1dVBzb2hFN1k4eWdDMkZKK1hs?=
 =?utf-8?B?WUdheVV2Y3U0dE5iVUxVRDU1UTBwQmkzaGZNTXEvMU1LcGZPeVRKT2NuNDJv?=
 =?utf-8?B?SWJQSFhSMFozU1k3Wlg0V25jUnJLb1kwTm1CRkMzbEhuQUNzSm5ndG9NNzJy?=
 =?utf-8?B?VHAySU9OajRLeTFhck9ESHU1VHpTNmJKT0ZEdXNZQ3h5eVN6eDJwSWlmZ2Vw?=
 =?utf-8?B?VVM5RFk3VWNsSnRyVHI0Vi9IaVBRVU1XODV5OXZVU1FTbHZ1REpmaFVxSjhV?=
 =?utf-8?B?b2hJTysySzdTRWtxNVA2MVlYN2RnRWNLQVE3KzVQb2QwVmpzcFdLMWFpQ0VV?=
 =?utf-8?B?Z1BVR0QxY3FzSVhrc2dFTDZxejI1QUg3OVdORHNzL1BnbFJvU3IxOGZqTHdR?=
 =?utf-8?B?ZGllMlZ5WGk4TTA5TTg3RUl6ak04QmZDeGMxN3FuMFhUWGNMOW1DTm9Zck9B?=
 =?utf-8?B?LzEvQUpRR3FnaStSTm1aOTRvQjZ3a09LakVMMmVxWW1VM3RiVU14TURtekxF?=
 =?utf-8?B?bTk2RUVRc0tCNnlBN2wvYUNMcHY2WU9lMGNKbzhYZzdCdjFUS3M1ZzZXa0Ev?=
 =?utf-8?B?OUFFano3VnpYZXN6dFJIb3g0bUk5NTNRemZPZHRFTmtkRjdsS0FGZHozNUo2?=
 =?utf-8?B?NUtnejhrek5hdFR5YTFZRW1zdXR1Z1VtaEtqbjhST3ZlMUIrb1kzTFVqU01J?=
 =?utf-8?B?eWNheEdJcjN5NThvVEZCSk01eDJjV2tBR2kycGRENEcrN3Zzb2p1NmljRkJq?=
 =?utf-8?B?cmxTUXpuTFQvazFCbWZZSjgyOC85WTBRWlQwL1ZhaW5OdzF1aG0xWWFaUjNP?=
 =?utf-8?B?MDd2L2JGeG14eDUvd2dPVmhMVHJoSmdqV3JtLzZ6RDlUSFRkRUZZZmRkZUY1?=
 =?utf-8?B?YmRJRFpkYkNkQnpqelVNOHh6OGNCUzN3QnllTkEwQmFNcnpzMGZvRnJVTXJB?=
 =?utf-8?B?QU53V1hLcGF1WEMrL25nTHFmUGF6TmtwWkdWa01qd1kvMmNmU3ZURFU0VHZG?=
 =?utf-8?B?bFhqMDQ5SG5LZUZUKzA5YjRJNzNrclJENjNwSGJmKzRyRllnSG9iOHlPSEFU?=
 =?utf-8?B?V1p5QnYyK3ZuQUkvZUZyd1RaYkI2TUJIMUJoVkRwNmcvQ2RXRGpoZ2gwdm9u?=
 =?utf-8?B?Sm9Td3Roa2NQWWtjZ0VsWVBsRzdBYlBWMU56T2ZDS0pobThGbkI0d3dvUmZJ?=
 =?utf-8?B?YnlLbytrVGxCYlRWejk0Z05kc0dheGl6TTdlTVFNL1hsTldHTjhpSnhKZWJs?=
 =?utf-8?B?bzlQalZxcUgzWVRxUjg1UjdUdC9zT2Fsa0JjSVdIZm1ldVlHajhEcnMreE1P?=
 =?utf-8?B?cEJVZ2RtcEc4a1BEOHZFbis2ZWJNbzlZRTBhWWNDU2cvZlBWenpmdmU3Zldh?=
 =?utf-8?B?RDZlODBKcktrVDNJVDY4UGpDd21rcHJjVFlYb3lXb0padU1mRVltL1FKSnZI?=
 =?utf-8?B?dGM4eXBRMWx5VHFhS08zMmZ4WWRUcVVjaWJwRWE1aGNBYm5BRlhjNVpMMHpo?=
 =?utf-8?B?UTF2L0wvdkFFcnY0dTBvRytuNXlFeEIxRCtaVDk4c0hyZ3BSR0twc0ZzQ0k1?=
 =?utf-8?B?OGx4RmlqRDVhTjlSallFQjJtNzJoZXNqYjdvN1BGa0g3a1RSTmVUQmxiZWU5?=
 =?utf-8?B?cDgvQk11enVwcmRzaTNkK09XanlJN25wTWlENTRLWEZnTGo3Q0VmNlVkOW5F?=
 =?utf-8?B?L1gzeDlkMWpDUURta0NvRG00RTRJZitLTm44RU5hcTRnZ3dzRnRQS3M5Vzdh?=
 =?utf-8?B?SjYyUitPTVdSYWpCUHpVd0l0bzdNYWNPdTZlL3hsV00wamc0SFJ6UkdnNW9i?=
 =?utf-8?B?WHZCaCtiVHFINWd2cVhoeWhhM2d6VXBXOUZaTis3OXNKTzFPY2RtaTg0V1NV?=
 =?utf-8?B?L1BSaFFMNnNDL2xxdG9RTXRQQ0NPMzd2NHhCUFhhNWEwV3dYWDA5SDZRREpX?=
 =?utf-8?Q?il8Bp38yLRvuH2zZoy66esgy9?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB5549.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="utf-8"
Content-ID: <3ED637EC8A225044B0FBCDCB81459803@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR06MB7642
X-CodeTwo-MessageID: e6c4de76-4b5f-4602-91cf-7c9f4d69c65c.20260224160955@westeu11-emailsignatures-cloud.codetwo.com
X-CodeTwoProcessed: true
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	579f4069-a8ca-4298-9e61-08de73bf2436
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|14060799003|36860700013|1800799024|35042699022|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Tlp4RFN0b1BHV3lMdUFkOWFMVU15TC9ra2FXUksySmtYOGV6YWlSUHdsNkFG?=
 =?utf-8?B?MnFJU2tUR25JTTR3L3lGbU1lQytJVjVhZFBRdm5ESVIxem9SNFVKZ0J0SExO?=
 =?utf-8?B?V0hQYW9QZUs5STAxTS9hRVhLck5pVnI3eDcrbUNLUWM2OHh5RElJUmZlM3FY?=
 =?utf-8?B?VnYxMXhtblRNRkJkdzJXRGhaVmtJaTU4R1hlbGhXNGlITllVNzBsblVURXln?=
 =?utf-8?B?dTBPYUptN3NyOEJUYll6RVVrR1NSMEZ6amViUjZ2UUlSVHk0a2NTaUo5ZVRT?=
 =?utf-8?B?ZERpeTF5Y0ovQlQ2d3RSdHkzZFFkVyttbTN6cmdkQ0FjSlBxa3FTKzNVbm9J?=
 =?utf-8?B?ZUZNWVc4b0l2bExmeGhjakZGVGUyeGt6RGpBdE5FTGViZVFONlhOcWZLdVEv?=
 =?utf-8?B?QU5vSzRUaEZrVHZLcTRXMnh4RTFITG53K0lZYjRZUlV0V3ZWMHFhRi9vQnNH?=
 =?utf-8?B?VDAxQUU3dnpMTVZaa0N4b2RBRmFpQ0ZuSUFieFA0bVJtazVYcU9KdFlCOCt0?=
 =?utf-8?B?WkFwU0t1UUt0VmdESWcySzVsZUJrK24xUFFScmprSllWWFNKR2xkcFFCcHE1?=
 =?utf-8?B?QTAwdmxyeDJzMVROQitlNEczeURheHFxYkkxSnVOUEpNWmw1TnlELzYxWUpN?=
 =?utf-8?B?U3ZNUXVpRFRqdHZJNzlSWjAxYnhOd3VuYVdXRG94bTZpQjgzU2dOSHEvdHVi?=
 =?utf-8?B?MDE0a1grMmhHK0YyaCtuUFhYUUc2V3lrZjQ3YjF6NmZDMjhUSDk2Vnd2VDc4?=
 =?utf-8?B?Vmpyak1EQW05N3UvaURQajV4R0pKU2pIMGZTTU14NWQxTWRZZ3NJRFpXZW0z?=
 =?utf-8?B?eXc3MDVHSHBLVjljZUlBWXNaQUFSNmpQSC9GK2FyejVCamppMGNqZHFRcHVz?=
 =?utf-8?B?L2gvbGcrTEU5V3BuVS9YMlBlQ0J6ZmxuWDZDUTlaUXNtK0FoWXo0cjZZd1hw?=
 =?utf-8?B?ZWF1R1RXMVMwRmhQYXQ0S2RVTHNvcndUSU1HTERyN1B0Q0VsaERWU25sYk1I?=
 =?utf-8?B?NFFUMGQ3SjE1ak4vNFp2ejdXTHNhL204QnhaR0tEbEw1UENTTy9DQUZnM0tn?=
 =?utf-8?B?ODhNMENJVDR1ZnhNZy9LMVVROTlzdE03TGhGcllIaEh0aVh5OXFoMmd5YnM0?=
 =?utf-8?B?S3Vtb2dsdEJOYURiSXhxUTRnVjE0WmtCZ2JOOGVPcDZwS21tSy9lRDVCMjNE?=
 =?utf-8?B?MmovMWVnM3I2MUViT2lJK2Z4aWNmcExzc1BFRUI0M0MrZVVWaHpLZFhqVnpQ?=
 =?utf-8?B?d2tCWm9jMHdqR25NTy91TkhtQnZONVBUUFlUdnhScDdSK2xYdU0xdVVGemY0?=
 =?utf-8?B?ZXBzQUZCZUwyMTc0bXliUjczdm9odWpPR1pUT0dFS2h1aW92MXVMd0Q3K092?=
 =?utf-8?B?V0k0blFEOXFZK1lWa2xkblhOb0J2a01JUTVKYll2bTA5and4U1drcklFY1ow?=
 =?utf-8?B?TVc0R1hDWER4eGJnVzdGVDNkaDk0blBNOEdBOVN2N1JFY004M0JaclhoWFJa?=
 =?utf-8?B?dGNsU0RUMjhQUW5UYTliMDZicnM5UHBWcDdoRzNxY29wTkxhZkEzYWN4VEM4?=
 =?utf-8?B?RTdGOUFDUzJoYXJrRDJLa016cTFsV1JUZ29DYURqRU1TdHRIbTc3V29ubEVU?=
 =?utf-8?B?VVlUdXdoQ0ZsaUtKb2c5eU1EVFhFU0MwYTI2ZTdzRW5ka0hwdThISS9yOEhs?=
 =?utf-8?B?aG43ekIwRDlidlo5ajhuSlZ3aVh5eG9IaldOVjRtcUlSbThsZnVMSkJkaEFN?=
 =?utf-8?B?SWYySTl0RVpaNHRkSnhNR2RoMHRid1o3bzZVU3hhTkZOeHlnME53S0l4RGl6?=
 =?utf-8?B?dTY2aFJjN2prdHlLZ2ZxZ0Z4MGdBR3BGVk4xMjc0MUtpenA0V2lxODdZc1d5?=
 =?utf-8?B?dnp1NGpEUzlOUTcyTGkxZWNWQk90UzRXY0Nab25YSU13MUhyWTdEVWwzRVE5?=
 =?utf-8?B?Z1gwbTQ1MXdQZ2tKT1dURk1oVThrRDJ5OGw4SGltYU5tUmN3YlVBVHFpam5t?=
 =?utf-8?B?d243R2ZJVVQyaVNzN0xNTGF4THRtQm9aRVljOVJUZ1NSYzhUNjlSMk11VEwy?=
 =?utf-8?B?TVV1R3BlWDA0NXRQWmhsdkhabDhaSVZ1TkMvSUZkUDVYWUMxRkk0SDJUazNG?=
 =?utf-8?B?M0RDWGZRWlk0aG9kZWdoaWJzN0h5WkswS1JWMDNwSzhIT0NtRXc0ZWpDaWdt?=
 =?utf-8?B?Mnc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:20.93.157.195;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:westeu11-emailsignatures-cloud.codetwo.com;PTR:westeu11-emailsignatures-cloud.codetwo.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(14060799003)(36860700013)(1800799024)(35042699022)(13003099007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hr4yYlyVarpbs0crEhabxd1fpoKu+mCNyBHlUZ4HSbXIQPAUb3NCRgzC2EYfXLrSOGDVOiT8+l8AWMefP1Pl8hYMUUPu/vwZffqh2EkGGqyAjQ1ajZk1pPadGiVDG0RfGXIw+BIW4r+bqdB5wltncaL8lgZ7eMPN2IXxOdD241JfuKe3ItJis8o6o+PCB705I5gkwH54/kJGRwr6SUkI33IktwcOT7+MtnFeP2T04uijC3p5LkmwR/BLG38lo36DvpLiLTb9likFQ8FsebYtZE0G5zFKXrrpqH649vW3sH6FA1xkbZsc6tXV360P7cxRUIhXm+U+RlyDg8de51zSFCID33Fw9RiojXLdLWOKIiuoHyK3ovyr5l+HFGe8uoYwlXfXFLrTFtgiQYdqe+GlRD4PGvS4pRTs9GMjb8fEVHpulJSBiEYB+d55HBBd57nd
X-OriginatorOrg: ginzinger.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 16:09:56.6487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88e7b8fc-e459-41e5-78ef-08de73bf274a
X-MS-Exchange-CrossTenant-Id: 198354b3-f56d-4ad5-b1e4-7eb8b115ed44
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=198354b3-f56d-4ad5-b1e4-7eb8b115ed44;Ip=[20.93.157.195];Helo=[westeu11-emailsignatures-cloud.codetwo.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR06MB10743

QW0gRGllbnN0YWcsIGRlbSAyNC4wMi4yMDI2IHVtIDE2OjA0ICswMTAwIHNjaHJpZWIgTHVrYXMg
V3VubmVyOgo+IE9uIFR1ZSwgRmViIDI0LCAyMDI2IGF0IDAyOjE3OjIyUE0gKzAwMDAsIEtlcHBs
aW5nZXItTm92YWtvdmljIE1hcnRpbiB3cm90ZToKPiA+IEkgcnVuIGlteDZ1bCB3aXRoIEZTTF9D
QUFNKiBlbmFibGVkIGFuZCBzaW1wbHkgYWRkIGNhLnBlbSAKPiA+ICggb3BlbnNzbCByZXEgLXg1
MDkgLW5ld2tleSByc2E6NDA5NiAta2V5b3V0IGNhX2tleS5wZW0gLW91dCBjYS5wZW0gXAo+ID4g
LW5vZGVzIC1kYXlzIDM2NSAtc2V0X3NlcmlhbCAwMSAtc3ViaiAvQ049Z2luemluZ2VyLmNvbSAp
Cj4gPiB0byBDT05GSUdfU1lTVEVNX1RSVVNURURfS0VZUyBpbiBvcmRlciB0byB1c2UgaXQgdG8g
dmVyaWZ5IGEgc3F1YXNoZnMKPiA+IHJvb3RmcyB2aWEgZG0tdmVyaXR5IChidXQgZm9yZ2V0IHRo
YXQgZm9yIGEgbW9tZW50LCB0aGUgZmFpbHVyZSBpcyBlYXJseQo+ID4gZHVyaW5nIGJvb3QsIHJz
YSB2ZXJpZnkoKSkuCj4gCj4gVGhlIGlzc3VlIG1pZ2h0IGJlIGVhc2llciB0byBkZWJ1ZyBpZiB5
b3UgY291bGQgY29tZSB1cCB3aXRoIGEKPiBzaW1wbGVyIHJlcHJvZHVjZXIuwqAgRS5nLiB5b3Ug
Y291bGQgdXNlIGtleWN0bCgxKSB0byBhZGQgYSBrZXkgdG8KPiBhIGtleXJpbmcgaW4gdGhlIGtl
cm5lbCBhbmQgc3Vic2VxdWVudGx5IGhhdmUgdGhlIGtlcm5lbCB2ZXJpZnkKPiBhIHNpZ25hdHVy
ZSB3aXRoIGl0LgoKSSBjYW4gdHJ5IHRoYXQsIGJ1dCBJIHRoaW5rIENPTkZJR19DRkc4MDIxMV9S
RVFVSVJFX1NJR05FRF9SRUdEQiBzaG91bGQgYmUgZW5vdWdoCnRvIHRyaWdnZXIgdGhpcyBhZnRl
ciByZWJvb3RpbmcuCgo+IAo+ID4gVGhpcyB3b3JrcyB1bnRpbCB2Ni42IGFuZCBmYWlscyBhZnRl
ciAoImNyeXB0bzogYWhhc2ggLSBvcHRpbWl6ZQo+ID4gcGVyZm9ybWFuY2Ugd2hlbiB3cmFwcGlu
ZyBzaGFzaCIpCj4gPiBidXQgdG9vIG11Y2ggaGFzIGhhcHBlbmVkIHRoYXQgSSBjb3VsZCByZXZl
cnQgb25lIGFuZCBJIG1pZ2h0IGJlIHdyb25nCj4gPiB3aXRoIHRoYXQgY29tbWl0IGV2ZW4uCj4g
Cj4gSXQgd291bGQgYmUgZ29vZCBpZiB5b3UgY291bGQgYmlzZWN0IHRvIGV4YWN0bHkgcGlucG9p
bnQgdGhlIG9mZmVuZGluZwo+IGNvbW1pdC4KCkkga25vdyB2Ni42IHdvcmtlZC4gdjYuNyBzaG93
ZWQKWyAgICAyLjk3ODcyMl0gY2FhbV9qciAyMTQyMDAwLmpyOiA0MDAwMDAxMzogREVDTzogZGVz
YyBpZHggMDogSGVhZGVyIEVycm9yLiBJbnZhbGlkIGxlbmd0aCBvciBwYXJpdHksIG9yIGNlcnRh
aW4gb3RoZXIgcHJvYmxlbXMuCmFuZCBJIG5ldmVyIGZvdW5kIG9uZSBjb21taXQgSSBjb3VsZCBz
ZW1hbnRpY2FsbHkgcmV2ZXJ0IGFzIGEgZml4LgpJIGNhbiB0cnkgdG8gbmFycm93IHRoaXMgZG93
biBhIGJpdCBsYXRlci4KCj4gCj4gPiBJIHJ1biB2Ni4xOCBub3cgd2hlcmUgdGhpcyB3b3JrcyB3
aGVuIEkgKmRpc2FibGUqIEZTTF9DQUFNKiBjb21wbGV0ZWx5Cj4gPiBhbmQgdXNlIHRoZSByc2Et
Z2VuZXJpYyBjb2RlLgo+ID4gQWxzbyBpdCB3b3Jrcywgd2hlbiBJIGdlbmVyYXRlIGZyb20gZWxs
aXB0aWMgY3VydmUga2V5Lgo+ID4gCj4gPiBPbmx5IHRoZSBDQUFNK1JTQSBjYXNlIGlzIGZhaWxp
bmcgaW4gYSB3ZWlyZCB3YXk6Cj4gWy4uLl0KPiA+IGJ1dCB3aHk/IEJlY2F1c2UgYWZ0ZXIgdGhl
IENBQU0gY29tcGxldGlvbiBjYWxsYmFjayByZXR1cm5pbmcgdG8gdGhlCj4gPiBjYWxsZXIsIG91
dF9idWYgKHRoYXQgd2FzIHNldCB0byB0aGUga2V5LXBhcnQgaW5zaWRlIG9mIHRoZSByZXF1ZXN0
Cj4gPiBlYXJsaWVyKSBzdGlsbCBob2xkcyAqb2xkKiBkYXRhLAo+ID4gYW5kIE5PVCB0aGUgImVu
Y3lwdGlvbiBibG9jayIgd2l0aCAwMCAwMSBmZiBmZi4uLi4gCj4gPiAKPiA+IG91dF9idWYxIGlz
IChJIGFzc3VtZSB2YWxpZCBiZWNhdXNlIG5ldmVyIGNoYW5naW5nKSBpbnB1dCBkYXRhICJvdXRf
YnVmIgo+ID4gaW5zaWRlIG9mICJjaGlsZF9yZXEiLgo+IAo+ICJnaXQgZ3JlcCBvdXRfYnVmMSIg
ZmluZHMgbm90aGluZyBpbiBhIHY2LjE5IHNvdXJjZSB0cmVlLCBzbyBJJ20gbm90IHN1cmUKPiB3
aGF0IHlvdSdyZSByZWZlcnJpbmcgdG8/Cgpzb3JyeTsgb3V0X2J1ZiBoZXJlIGh0dHBzOi8vZWxp
eGlyLmJvb3RsaW4uY29tL2xpbnV4L3Y2LjE5LjMvc291cmNlL2NyeXB0by9yc2Fzc2EtcGtjczEu
YyNMMjQ2CmlzIHdoYXQgSSBjYWxsZWQgb3V0X2J1ZjEgYW5kIH4yMCBsaW5lcyBiZWxvdyBJIGNh
bGxlZCBpdCBvdXRfYnVmMiBpbiBteSBsb3N0LgoKPiAKPiA+IERpcmVjdGx5IHdoZW4gY2FhbSBq
ciBkZXF1ZXVlKCkgcmV0dXJucyB3aXRoIHRoZSB1c2VyLWNhbGxiYWNrLCBJIHNlZSA2NCBieXRl
cyAoYWxsPykKPiA+IG9sZCBkYXRhLiBTT01FSE9XIHRoZSBjcnl0by13YWl0IG5lZWRzIDEwMG1z
IG9yIGxvbmdlciAobm8gaWRlYSB3aHkpIGFuZCBhZnRlciBUSEFULAo+ID4gb3V0X2J1ZiBoYXMg
b25seSB0aGUgZmlyc3QgMTYgYnl0ZXMgb2xkIGRhdGEgKG91dF9idWYyIGluIHRoZSBsb2dzKToK
PiAKPiBJIGFzc3VtZSB0aGUgY2FhbSBkZXZpY2Ugd3JpdGVzIHRvIG1lbW9yeSB2aWEgRE1BLsKg
IFBlcmhhcHMgdGhlIENQVSBpc24ndAo+IGF3YXJlIHRoYXQgdGhlIG1lbW9yeSBoYXMgYmVlbiBj
aGFuZ2VkIGFuZCBpcyB1c2luZyBkYXRhIGluIGl0cyBjYWNoZT8KPiBUaGF0IGNvdWxkIGJlIGNh
dXNlZCBieSBhbiBpbmNvcnJlY3QgZG1hX21hcF8qKCkgY2FsbCBpbiBjYWFtcGtjLmMuCj4gCj4g
PiBUaGVyZSBoYXMgYmVlbiBxdWl0ZSBzb21lIGNoYW5nZXMsIG1vc3Qgbm90YWJseSAoImNyeXB0
bzogYWhhc2ggLSBvcHRpbWl6ZQo+ID4gcGVyZm9ybWFuY2Ugd2hlbiB3cmFwcGluZyBzaGFzaCIp
Cj4gPiBvciAoImNyeXB0bzogcnNhc3NhLXBrY3MxIC0gTWlncmF0ZSB0byBzaWdfYWxnIGJhY2tl
bmQiKSB3aGljaCBzcXVhc2hlcwo+ID4gZGlmZmVybnQgY2hhbmdlcyBpbnRvIG9uZSBjb21taXQu
Li4KPiAKPiBCZWluZyB0aGUgYXV0aG9yIG9mIHRoZSBsYXR0ZXIsIHlvdXIgaW5pdGlhbCByZXBv
cnQgc2NhcmVkIG1lIHRoYXQKPiBJIG1pZ2h0IGhhdmUgYnJva2VuIHNvbWV0aGluZy7CoCBIb3dl
dmVyIEkgbG9va2VkIHRocm91Z2ggdGhlIGNvZGUKPiBhbmQgbm90aGluZyBzdHVjayBvdXQuCj4g
Cj4gVGhhbmtzLAo+IAo+IEx1a2FzCg==
