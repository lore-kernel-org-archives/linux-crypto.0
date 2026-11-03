Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.3
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793735566;
	b=dbzXAquEp/E4RoTGC7gmx6zb4uo3liGvKbRnCpiPM/Z/wPX5eLWAKTr+vyGqHXd5LMgJ
	 5N6sI4cTC0x0Ze77AMyNGdxb8FoXdRf9o6kxg9x+FWkxU75wkuNsPSNWUdKB5XzfYXPoA
	 TqEaxMjq6UE1hiAI59fG5Mb3QrA8QWnOfDYWARJpX465b1c5hIKOQgxCnQtpWLE0ccORt
	 LmKU9ZKXFICi9dJVSlaTUs7ZlnHnV7bIgFPo15RaI6T0xrRNwUqEpipqrDK7/rewDI7EZ
	 uyDjH7Gxd0+vC2wgb58quZccbIwczpxdrQEZl/jQ696foEkOYVcAclI+aNYz97j/Uiw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735566;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:Subject:Date:
	 Message-Id:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
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
	bh=s6k1vbUHwOh2rlcqgTHQppfaCBfvavH0tfMZPy2A+nc=;
	b=2SOft23kp7ajjfqO7ixe1hbDpHYBJzSZ/T2Kz8TY9fCuXMY3LDgY7NVABGDVG3B/R3ci
	 f0648Y52DURWwqhAXGykXXonsA4CfWBaUpy1Z9ITr1blTXZUDkNrGICA9CuMKbIIAOVjs
	 5hVf38S/XCWH+G7L8smO2MfJi/oqromkLVE9W2d85KK1fr7JOh4YJfP6wTcOG28iprVZ1
	 JKIkpoKNSI0P5LmYbw8dv4gxRqR0hmMNIkHqrCnXLOm7D6YQVjn8atDcfZkw1/owU7sAE
	 jFFW8m1tTIuBK2yaQXipkpxAI4QifGx2Md5E+RwPfo6GGN2ODgips+DHCRkTx1dTyRg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=LMxLkK9F;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.3
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010003.outbound.protection.outlook.com [52.101.69.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D427606A326;
	Tue,  3 Nov 2026 19:52:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D427606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=LMxLkK9F
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vPLU5IzQGhMBtpPQ0rj3ex9l7GBIlPLvv+GvA0fVTrW4u41reAFKHBS+YtBkewYgdyQ3UlFf3pbJG49lj6O7FtNDMZAlgcFCm71tvTHES6IfW4eI7oepERKExn5+8ke9MdajYGJMU3oMjK8pS6AX8hnh6TRMKadw4/IL3JfPdOOwFhzl9KLQQHTxW3PUhyIBVfWfnoIQIM+ja6SkCZ/b5yYgKvXZaGb0Wj35FfFyTsq4OjPSLA2pqHn+M4yGMrTP/vC6MRYS0AdxCno6m2LcHAHbpsiwqzy3mLJ7H4We/dCeZyyM8USQle20XnxUcGlWQGaya+8TvwDp77M8SOcvIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s6k1vbUHwOh2rlcqgTHQppfaCBfvavH0tfMZPy2A+nc=;
 b=IeEZTn3MBIAHfq4so9XJ9lqfK66pX0qtpAtMowxAyvr8I645IuHi4Q3K8AKv3aWS+yFWA8ul7thSWT71rTNAMkNDwwRcSnhXjTMTWVYQxDDGSZ2cNIxzBuudWnbwvCir+nWrlWCFoL0+hoFDP8oiaz/qO9hPSU97ExI7QdVbeR8MiFqq3Pl22nJzTmgVs+z8qORppE8rwSOFvJxn+IZG1Odc6XIxrearMJgy+h4JLeBaFMC3n/pKwOoNGqeGZUKMYL72fWvPbJi3Rau6QAcVHzIBEDdWoLv4435wNKWy+9YeH5E26vQ0f49ImmHnPoJNX3XAVEXIn3qR4j+0wCCwOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6k1vbUHwOh2rlcqgTHQppfaCBfvavH0tfMZPy2A+nc=;
 b=LMxLkK9FLjPx8fP6/cTZRmHRSZRdoAxOWvOAGeBBWARzIWiDr5IA/0SR1YAClnYaqOB9hVN5Bzw1Gjba63vkhdn9ND5ZQ+xU8BwH/4XAqrovXHjbgpwFvX4iJKNhDdQVDMix7LANS/zCPAXMS3iyvvUeH4knB6VK0wXPtHH7D1Ajp/yrlBqO/xU8ZDR8lF8XJ2PKyQJ+cBEkMhIWSnNCukg+9id8/oqdob9vahh4BMqGEx0uttcg6SQbkIrpR+kaQcxOUCkyEtVlFSNxi7qJXSvyYR/eJ1I5jJobfZT47vypKQObCYvdivRStuujNL3MHjm78JjxnQQGoxmWTXa2Yg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com (2603:10a6:290:76::14)
 by AMBPR04MB299223.eurprd04.prod.outlook.com (2603:10a6:20b:7d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 19:52:42 +0000
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b]) by MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 19:52:42 +0000
From: Frank.Li@oss.nxp.com
Subject: [PATCH v2 0/7] async_tx: use DMA Engine APIs
Date: Tue, 03 Nov 2026 14:52:31 -0500
Message-Id: <20261103-async_tx_dma-v2-0-3afc7c59362c@nxp.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAH876moC/3WNQQ6CMBBFr0Jmbc1MRRBX3sMQAmUqNaElbSUQw
 t0FXLt8yfvvLxDYGw5wTxbwPJpgnN1AnhJQXW1fLEy7MUiUGSGlog6zVVWcqravRaqzotE3pDz
 TsE0Gz9pMR+5Z/jh8mjeruDd2ozMhOj8ffyPt3p/0SALF5ZoX2CIxFfiw03BWrodyXdcvSRxbI
 rgAAAA=
X-Change-ID: 20261014-async_tx_dma-4f69bf80176f
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org, 
 Frank Li <Frank.Li@nxp.com>, Peng Fan <peng.fan@nxp.com>, 
 Dave Jiang <dave.jiang@intel.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793735557; l=1835;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=0JKMw4qa8j5hgx61tqv2BFjNLNvrf1Q7eP4ttYZEM0U=;
 b=zmYqj/jWdDiDvgxwtMfahaL47TNQnTYkeFr2hgttr1FOV8QPeHiEMIO/1SEMmhdPvHPX0hv26
 2UB5MJZYS48DPRn/PiGRw5HxaV68a8QbWYU1n90eFzWILwDCoqZYmGc
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH7PR17CA0008.namprd17.prod.outlook.com
 (2603:10b6:510:324::8) To MI3PR04MB12438.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 0befb746-6006-407a-ac22-08df39e40604
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|19092799006|260925022911599003|261021133027099003|260925021311599003|260925021911599003|11063799006|261022075727099003|261021121427099003|56012099006|261021123027099003|261022105027099003|261009223027099003|261021135927099003|261102123227099003|261022115727099003|261021130227099003|261022113327099003|261026140227099003|261026130827099003|261026121527099003|261028144727099003|261026135527099003|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	RKRVLGz59qhUpsk6FcRNijgf0U4uE3cKezZmlB6dyQXxvbyhHHxanDGOHxmTqZtRSmIZibyqeQ0c0MU3pxnSAyKo7ZDtgoTvRZxJG3gQHpP1KkjlpPxn56mp7TuhIAWOp5FpM4yI07eFIpC1nlK8zhf+RWaW+iQ5YaZorVSvcTJWnbNZ+hNlhhJuYcuYFeYYyy1cs53FleKZ1hF6uIxLKAyu7BaeLgndTG5TE/R2rXjrJNgbiwsv8jwx8crOVM4utSCd7l4pp9+ujZJuPm5me6OneFmESrsXPk+s0IVO/TqMwYiembgtvhUYAgTDNkJuT+PycRANv6mjTBXaIQw/3FcQ5+PmM+3ZWLZzTWkG//AcfcbSSaAhG3R1+ZNUFe+YGYXuIKVi8XxilYCmq4CrZIl3W/e0h1gY23c4J9CpsMZplc764R/DPK2SKuU3bbtsGCLkaSY/1Hg1t/w6c7SbU8QktJVCHCcp87sqRovD5OzPm+bRE0LewIe6JXsFTsRUF79lS+brQWCkbheFo0Orrgd3yqLKsVBr9HbnBGsHOEGdrUqix3dLXkjKHg3ASkSVZxOz6xbARcBJ7++C7DDar5w6UoXiGiN6HcFWBQqwkpcVcPHVarNed78f4ZIjrniY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MI3PR04MB12438.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(19092799006)(260925022911599003)(261021133027099003)(260925021311599003)(260925021911599003)(11063799006)(261022075727099003)(261021121427099003)(56012099006)(261021123027099003)(261022105027099003)(261009223027099003)(261021135927099003)(261102123227099003)(261022115727099003)(261021130227099003)(261022113327099003)(261026140227099003)(261026130827099003)(261026121527099003)(261028144727099003)(261026135527099003)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzdTSDlGUEpzc2tPZmkrck5qRmVsenhSZStsUlp3ZVR0TEFuZU80TlZDRzIz?=
 =?utf-8?B?b0toV0F2U2RSaitXMk9mekV3cXBkN3Qyc1M0aUZNRm1JZFMrSHRHOC9IWVl2?=
 =?utf-8?B?Z2k0Kyt4a3doTTI1b1N1OUdLNGN1NXEwc25JbTdsR25CKzhNNlczZFlPQ1VU?=
 =?utf-8?B?ZmdNSXcvNEJncko0ZWtGcVZOMHQzME9Hd2pXVGpCNmEvMUJlUTlhQ1NjOVJI?=
 =?utf-8?B?TDFqZ3VsaUd3Zk5tOElIeW5ueGczazlnTy91NnpMUW1tUHR3bG9KREJpZVRq?=
 =?utf-8?B?NERpV2ZFVkt2TUJqcnArM1NQTkpGZ2ZmN21RWEM2RHZyaXlvQVJXUi9uOGxk?=
 =?utf-8?B?cC95TGFxMzl4MzBHWnpaZ3c5OXRnYk1JTmxuN0lMbndwTlk0S1FMZFVtb1NG?=
 =?utf-8?B?eWVqL09MNzRyb2p5Q3ZnMkNVT3hqT1E5SWc3L2hOREZlZW14YjN3VjBRZkRh?=
 =?utf-8?B?ZEpGWEYyS24xK25CRlRIRlRmWmorR3haUDVVL214S2Vpems3VkVFZ1BZUXU5?=
 =?utf-8?B?VHEwUEpYa25JaGZWbzhyMFg3N05ra09FZElGbE8rWXQrZUMxMnRvOGRjUlpR?=
 =?utf-8?B?QjIraVQrbjB1bTlBcnN2a0FNa1VUM293STRuRXZHbTN2NW5LVUwvOGlVVUtz?=
 =?utf-8?B?QTZ2S0hLSEV6UlB2bVMwTEh3dk1Xc3QwNUdsU3FBdU5JYURuK2syVytnMnlz?=
 =?utf-8?B?K3kxaHphMm1ISkkwRkRPb0NnTklUSlRMMkNhLzhIZ2wvUzBIVTUyVFhaNC9p?=
 =?utf-8?B?VlBoMlJNUldwZHFtUDVsd1NMSHpZd2toRkVnN2hBUUJPQWEwSVFSSHl6Y24v?=
 =?utf-8?B?dU9yc3lEVGRBM0V1L0R2Q1VtT2NtMlYxeVhvSmRzeGxFTmRXbU1BM2lPN3Zj?=
 =?utf-8?B?MzhNdTZ6eG1SMVRYWk16TDJBY2VXVktXa2swb0J3bHZ6TjhBRHJGUm5tejNr?=
 =?utf-8?B?aHNTenBsYVRxSDV4S3hVM0MxTUNraUxnV3N0MndXS0czL2xpayt3TVI1QUo1?=
 =?utf-8?B?MldrNXZXNWpibFJsWHoyM25DK2tadFpqU0p3SmNFbjc1Q3F5M0srSXFxVVY0?=
 =?utf-8?B?OVM0dlJIbGhTOEFWZXFFUkJlZDRDUE1iams1L2dhbElBY09PQnhZcUtDbXlq?=
 =?utf-8?B?aDFXYlpRSUVQNzkwY3diZDR5QW5VNCszZmlQYXZRS3ptaUNsMmNDOFpTTmVP?=
 =?utf-8?B?UVJZcytHSURtdlBNT2xLNWJKL1F5SDZXRHdBREpLRUNHamY2UEkxZ3hKeDFs?=
 =?utf-8?B?TTBldXlKM3Z2QUpsaUFNK3k5SHUzQnBRQnpVZjR4SitFVDlud1ZNL0I2bVAw?=
 =?utf-8?B?cmFTRVo3UUoxZGVGVXZqOUdzTlRlUVdBRERHWGZLNHFmYWhqeXU0em5wb0Rj?=
 =?utf-8?B?WWZOa3NHNStJTmpRcGIxc0tpNklWSHc0TTVBQXpBemxGejhNYkwrRnlxYnpn?=
 =?utf-8?B?TEJabk5OMkI0c0JWa04vN2pFaFIxeGJRbkwzS1gzQ0FDdXlqNTJlRDRQbW1V?=
 =?utf-8?B?R3FnVUJyN0Fuakc3YmhzMlV2cVljNDhRVE03N0Jod0Z3ZER4TFNSOUhvQlVB?=
 =?utf-8?B?emViQ1NaK0U5WHF6ZEpxeWQyRFoxRzBsZDUzbUE5SGhrMUQyMUJHWitDVFhj?=
 =?utf-8?B?WG1uT0lEWmh4Q2lVV0QxeXh4V2FsOEVnczZNdmZUWXJDZ3p5bWNOSit2TjdU?=
 =?utf-8?B?eTFOcGxvWmJQTytReGRVRkh6UEU4QnVYR24vbk84b3k5eUd1ZkdwWTgybXJy?=
 =?utf-8?B?dTdpcjYvUTY2THpCWVFURmpkRkVtYk8rSmcyZ0dycm9OZGtEQlN4UFZsdkFX?=
 =?utf-8?B?RHpnQlVoc2pXQ0x0UVoxek53TnVXMThtenA0MDVxT1I2eEtlTE1rbEU5cGpO?=
 =?utf-8?B?ZlJ1NU1XOWRGcGFuckxZNFFLWFZ6QTZpVEZ0akxOa0djcW1mTmgvMTl2MDl5?=
 =?utf-8?B?Vi9lYVRwblpRV2VMWTVhdmZWeUdZcHBXZnBMTmhpTWcvRDN6bHBnSE84SERh?=
 =?utf-8?B?RlZKTDZjNmlGSFNHQUNLSHRHTVNNZ2MyODlWN2h0VzlaUVdGMFp5dE9MOXJK?=
 =?utf-8?B?Zk1TZm1TVGVpeEFLdVFUS3Y5b3YwdWdwYlFzWlJ6VERVeUxiakVqV3RSamVv?=
 =?utf-8?B?Z2V5YUlKWTlUN0x3NHRoL28xcUg1a29FamdnclJrOCtLVllKZHFEWDBXU29p?=
 =?utf-8?B?aWgzQ2loTjBXZXhWdVRrSEVlR25CcUtRaUM2bzBYVUVNMlhGOExWQW5tWERo?=
 =?utf-8?B?cE9tSTlyQXd5WU15eUtRWDNzYjNWWG1sbXVRd0taM2hNV2tPWXRkaHREV1l5?=
 =?utf-8?B?ZmVleDVaMFNzR0IzczJ5STlJR29OQzVMVEI3REFMVFVVYWZQdk5QSWNjWnd4?=
 =?utf-8?Q?KNI15CpetjNNdloRoFPZOp46yZ6M7bb8CB1rV?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0befb746-6006-407a-ac22-08df39e40604
X-MS-Exchange-CrossTenant-AuthSource: MI3PR04MB12438.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 19:52:42.7297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0+qJLkkfGGwzdhBFv52OueKmDnrD6Y4RoF6ItTgZITMi+9K+wzwLsyGS1oB6PYiMIXheKWRcYJeelorUNfj+3GzL2sg1mb8H5YVUcnLGscdaiKTzUBZRuGoTM9VI69o1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR04MB299223

Use DMA Engine APIs to prepare make dma_device private.
Last patch mark async_tx as deprecated.

Depend on below two patches
https://lore.kernel.org/imx/20261014190337.1718622-1-Frank.Li@oss.nxp.com/T/#u

base on https://git.kernel.org/pub/scm/linux/kernel/git/vkoul/dmaengine.git/
branch: next

Remove whole async_tx RFC patch at
  https://lore.kernel.org/linux-crypto/20261015-asycn_tx_remove-v1-0-056a7085e0a1@nxp.com/

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
Changes in v2:
- Add patch to call dmaengine_set_callback()
- collect david and peng fan's review by tags
- Link to v1: https://patch.msgid.link/20261014-async_tx_dma-v1-0-35790d01e190@nxp.com

---
Frank Li (7):
      async_tx: use dmaengine_desc_set_callback()
      async_tx: replace direct ->device_prep*() calls with standard DMA engine API
      async_tx: use dmaengine_get_dma_device() instead of chan->device->dev
      async_tx: use dmaengine_prep_dma_(pq|pq_val|interrupt|xor) instead of direct callback
      async_tx: convert to dmaengine_is_*_aligned() helpers
      async_tx: replace open-coded cap_mask accesses with dmaengine_has_cap()
      async_tx: Mark as Deprecated in Kconfig

 crypto/async_tx/Kconfig             |  2 +-
 crypto/async_tx/async_memcpy.c      | 14 +++++------
 crypto/async_tx/async_pq.c          | 44 ++++++++++++++++----------------
 crypto/async_tx/async_raid6_recov.c | 14 +++++------
 crypto/async_tx/async_tx.c          | 25 ++++++-------------
 crypto/async_tx/async_xor.c         | 50 +++++++++++++++++--------------------
 include/linux/async_tx.h            |  8 ++----
 7 files changed, 67 insertions(+), 90 deletions(-)
---
base-commit: a2313814224c3944419186b273c8a29e7c8c37db
change-id: 20261014-async_tx_dma-4f69bf80176f

Best regards,
--  
Frank Li <Frank.Li@nxp.com>

