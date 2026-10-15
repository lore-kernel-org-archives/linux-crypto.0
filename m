Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013067.outbound.protection.outlook.com [52.101.83.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4FE4D0A0B;
	Thu, 15 Oct 2026 19:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792092178; cv=fail; b=CkudS+FZI2K9sFyFBM6vzao9YPaD7kcvVsKvrFahcqPU8IWzLaYFcnGBN+nTZklShHEAWRTUDlzYN9g6+cROe4Gq/0wCfv6EXoJrrM9lAI1n/bf30NKTSTnEPFMW8p2hJxg+cPeQBjn5FrGyZWPxBwbss0A5u6ARpvlqFU3Qo0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792092178; c=relaxed/simple;
	bh=504gSiKbgzIirt4PzRbrfHg8TzZ6PtC1YpvT1StGdt4=;
	h=From:Subject:Date:Message-Id:Content-Type:To:Cc:MIME-Version; b=pSxgGr/opzrObVhqUz9WRHVFX6S4Ql9MSVd/eTL4RDDYhFLl0ywNqpFJHjcK/lwcFskz8LP4mTmRMpT8G790Z9JPq6vAoJeP6CSS35GzXIB526SztRwHPVyVo8JqjVo3VkLHu9Aa1z6qgg5+SXiuXrV3y5R2NXEBHsGhQYDwUcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=FNbm9hp+; arc=fail smtp.client-ip=52.101.83.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="FNbm9hp+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HjVXfggUCBD0V6iQZMiHxNw0Jg9IFzwahpdmPZ59CKtQ6wpxHk03t/bnfFA6ZQ4fLfjJJTszigTjwxcli/dA4S5DPlIi8Rnd1COiAIOVWltMNsyG8/sZICEoylfWVsag2NfE98yehdIKJFDNHUSx/QfLtlr3q9J7YBBOdQdEaBv/V5DEPgTToklpBC5lU8Yfte1f2Wa6y0/AP0Ov5Otsxip09C/+EOh/oOsyzLrdfvz/Zq82XzQWC7p/4sqF3LtZOg+yym3H/w1MNeogMrFSZ7DpY5zjmQd+ey3TKZGk5Il+Rwv4bw6sNQZonBWJAroFay9SRacfYaY+xkO+nKyorg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mb6Ykn3FCLqwUzITwfOKv7cpTHwi55sPkdzttBwbOHg=;
 b=YtYReVGDi9KOpgWZTAD7KDMRJbC7O5YsEURSQ7BbARLbtuC8eDfpz8rboYp5MJvd05ZxvsH+SrhAuV2AdAegWuvqx4YGwDSn7rd6MYlcqXMJgNTncl73kHGNQoOZGzUKFVgEfxqgIWDTtTJit/3iOXrkJ6V9YcemAqKzgI33i7y1+Ww4+yb39N5coidOrJMHcLf5E9f7bi09dRikqBHasahWBXJ9tRwSi2mws73RSTK4HKBWvIahHIpPSW8zGwAdQwMI2rCCHyB9VoAXsurbwcaINfa6/VndBqYYPVQrHgUa6EeaRwPTCkSBLEANa5+NjfqUcB5Y+segliYT7KCsqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mb6Ykn3FCLqwUzITwfOKv7cpTHwi55sPkdzttBwbOHg=;
 b=FNbm9hp+qgcwifqM8sRueRTXjI+9zgyNrxsKha+m5y9S5Yn3z/16ykLLLSJUpNMNT3/k/69rK0Y8E0Rq0Z9bKXAWq97vAjewS9dZpOUaL2bkQMz1KFludcsG20HBdxY7/5zummYxcM56FeZd1vTRaPCf4fKfDM2oJDOWCuXKuiRAkEhebQfW2W6IbY3FoGnzOACCV+yO4Pjswyty7yf6pPAyoCGJnPlyb5QiaQhC7sK/2vHnAHEVekRNrvY32fKj1a1/7xg1g4+UblRQ3MScgF2Gt3iEMseu5aXSs+ezz9qTiAGpHr+DcqV4XDn9w0MbR4gSwy3rXbvrZ64b5oV8rQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by MIWPR04MB358405.eurprd04.prod.outlook.com (2603:10a6:290:ab::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 19:22:52 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.012; Thu, 15 Oct 2026
 19:22:52 +0000
From: Frank.Li@oss.nxp.com
Subject: [PATCH RFC 0/4] async_tx/md: Remove async_tx framework
Date: Thu, 15 Oct 2026 15:22:24 -0400
Message-Id: <20261015-asycn_tx_remove-v1-0-056a7085e0a1@nxp.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPAn0WoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDA0NT3cTiyuS8+JKK+KLU3PyyVF1jC8PkFAMD4xTLNHMloK6CotS0zAq
 widFKQW7OSrEQweLSpKzU5BKQWUq1tQAepbCGeAAAAA==
X-Change-ID: 20261015-asycn_tx_remove-381cd003d9f7
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fygo.io>, Li Nan <magiclinan@didiglobal.com>, 
 Xiao Ni <xiao@kernel.org>, Dan Williams <djbw@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-doc@vger.kernel.org, Anatolij Gustschin <agust@denx.de>, 
 Saeed Bishara <saeed@marvell.com>, Rameshwar Prasad Sahu <rsahu@apm.com>, 
 Thomas Petazzoni <thomas.petazzoni@free-electrons.com>, 
 Anup Patel <anup.patel@broadcom.com>, Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792092167; l=4698;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=504gSiKbgzIirt4PzRbrfHg8TzZ6PtC1YpvT1StGdt4=;
 b=2ooMhwISN5LNUNkLAL+zJtJStvfuvlYn7wrY9vrZ3etIyBvO1i8HwzrTiwQRqSOY+bE282hx9
 eDQoNorGMMkCCaDTap1qRVAcEQ8ejb0UnhXvtSxU44SUgxn6na0IUw+
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH7P220CA0123.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:327::26) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|MIWPR04MB358405:EE_
X-MS-Office365-Filtering-Correlation-Id: 791e49ec-636c-465b-2e53-08df2af1b515
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|19092799006|1800799024|23010399003|366016|18002099003|10067099003|921020|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	QwBP6n13Ba+oyStc2BY1Zekko/hH4geZgoHbq7J3LTK7TqTidcpEVuL5aBEdqGtJSfnhRSsl7KDpBUoCFR1NoPjlLeucTewDwlaUVG7E1IPNW8xYOfhlIinD8h41+enajmu/SiXYB8Pen+Le3JF+7JDmhhJFd0yRo4LdlbM2jIFwiInAywQB61Mw2uCSf8+J1vVqWfGt50EBtXOT2p7oNtp7fEMX/9SfGzDRvo3gAMjnTTsMAO2PtVVP9zDvjfDkl106e2v2VNkhx9NDiwPVKSXfjt2nlRqiHJO5GYA6cdYRRLHwGMDrku7+YHqBFZUCW8PMJV0j22UlDZfXyqD6oYD0z0Y5IAXAFYuxHBajAO9s/HabtIBr9oDnx1puPFwTi2rV9DFtCM4ZoCZkDz3xJweOlrphZ+kq3ogOqHWKMxIvk5lloe2WAtAUuVsEIFfSVmkLpXj8kll3C09zQQWGkl2R2W7foDKTaJTDhT9Szs6iihtmZgJoFpYf8LEmg9W2giUSsJpvWAOMaP6qaCOkLddwwpJjb6LsK4n21kqoHvgVsnvC93gxYDQ0DLH+N3AgsI31UOBqsqNZ0GXsAYLIccLuniwAwwMKeDpNlWFBjChbJ2ozfEP4piNeWTREjiEnGE7rlHCOjj6F10bub5bNH1DfZkPc487Rc0EvTKDTO4bFXtbLVhyjw4cdnc/lrMuwYj/KBaxz+A3yLSieIuFwmQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(19092799006)(1800799024)(23010399003)(366016)(18002099003)(10067099003)(921020)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VzVwYndadHVRM1BBY3VaZFpxZHVGbGtuMWpTSjhBVFBiclRYdklMUWVudGpL?=
 =?utf-8?B?dlI2K3FxZzROa3ZxNnF0bmVuT05qdERhd3JtcmFOdFo1ejFST2ZMK21vdkp2?=
 =?utf-8?B?dXd0d3hBNldnaHdvb1hpa25Gc290U3VuYjJVZ3ZYV2YrdVduY1MzdkJOOFlv?=
 =?utf-8?B?OEhhT2hqK1Q0eG83QWg0bkttSTdJS0p2NkZsV1JFbEtySDV4aE9rSUJmRTZT?=
 =?utf-8?B?MXJXMno4WjRlK1JHSHJRVmxWUWlkQS9vREtDWE5PYXpsc0Qyem81aG8wUlBO?=
 =?utf-8?B?K0xFbHY5Ujg0c2NRSWxKZDFpYjhuNmpkbHlzNHJZb0Z3UjQ1R2MxZDQycGhy?=
 =?utf-8?B?THliV29RckJiNU5SSHk3WlBydWt3NjFiYWFCMkJsTFlkdUlwaldPYy8vcWxn?=
 =?utf-8?B?OXdqdnQxTmZ3NkNsR2FiMXo3VVFHK3U1L3ZVZWhkNDZucWM2NVBJRGlyL1pj?=
 =?utf-8?B?VUFYZlJVbEpIMUZSYmVMc2NYMGxDY1ZacDJVRVpDRGNBbWRJYXhwYStMS2ZR?=
 =?utf-8?B?ZWQwajk4akpyVlNzTkpwTFM3cUR2aXZlT0I1YmpSUkxSUWNnMTVyMG5HbVpZ?=
 =?utf-8?B?REh0eHYwR3JsRWtiZ2NJZDdHOVVaVm8rNStKU1M0QktyNlpwN0t5VEVGbENM?=
 =?utf-8?B?K2VmdHNzWWl0Mktqd1BscGNIWjdYdU5WYnRQS1JqcitiaDg5SFFtWGp5WDVL?=
 =?utf-8?B?SHpFcFRvb09CbmFhSmZzT0VyZzJLNUVzWm9uektGdnVrY3A1VWpkQzdwQytW?=
 =?utf-8?B?OWtJcVFLVGhFQVZxbHEyRFRLcU00V2I4M0RNVk1aWEQyL0JrYnBDSHJPNitp?=
 =?utf-8?B?MHYwTnpMZHNCNEFreFlRaTQyNHVscWtFVmJYbXNBeGhaK0c2Q0VkZm5kZlZT?=
 =?utf-8?B?LzArblU4MU0zTVNOZGEyc3RTQjRlajhaKzlCUnV3K1lWcjg5cUx1YmdyRWFG?=
 =?utf-8?B?QzljZHU4V2pYSkJndC9nSW53RC9zbWlGcWhzUHI3RlAvNEg4WlNFWDlmeTk3?=
 =?utf-8?B?bitPMG91S1NCT2xUTFh0N3JVc0xWa1k4SDNzRCtNbXpUL290aHpwUlMxQzZC?=
 =?utf-8?B?Q2dYbVl5YzEwMXJ5STk2dHYxd2NYNVVYQWlJZlJUSldGdW9IZzgxc3h3RUlh?=
 =?utf-8?B?cVBTN0F1NnRqVFZSY1dMS0VFbThSN3FCQ3EyUjFkc0prMFBycW1kcFBTdFZy?=
 =?utf-8?B?ODhBMmJDS3hWV3E2blpnOHgyS0ZCWjlKenAxU1grY0VORnpYYXc2bllJWkNX?=
 =?utf-8?B?R3FmZEIyQ2Npckh2Ti9WUlRKYmVuUkxXTHB6ZDc3dUxaS2JnakY0YXA3Y2xj?=
 =?utf-8?B?UG1oU3MwSitjVm16TWNmZVZJMXFhcjNFT1N2NE9mYm81MHd5YXhQUnRjc2M2?=
 =?utf-8?B?SG4rN1hwSk85a25zTUIxM3pzcE9WdWdBTEFEMEhZWnYxKzM0N2xDeExhZGJI?=
 =?utf-8?B?RU1MWjBQK1VTV2JVdjB6Y0xFWU1xOEp3T0RMcUJ0N3N2MW9SVFBjSjdGUWQ3?=
 =?utf-8?B?TlJPWWFNSW5Zei8zWGJjV25HdENjQnZBMzM2ZTQ1cVdVNXkvb1p3ZDNCQVI5?=
 =?utf-8?B?Qnlhc29zNElWR1hsOUhhdjJwUjFmNm9Oc0NNckE3bmp6MjB2UHp4QW10UWp2?=
 =?utf-8?B?cGd5WE4zeU9sdXJPR0daZlpkYklUb2ZYbUk1RjBzQW9aUGV4NENFMnF0K2Ix?=
 =?utf-8?B?ZkUwMVBrcWxCTkFFWmpOMkx4UWhlWGllS2w2aEJwVXNrS05DVEdZakpQc2Y2?=
 =?utf-8?B?bmZpRExtdkJrOTV5NFpXTmkzNHNWMC8yNkp2bTltZWVRd2NJTC9jUkxudmha?=
 =?utf-8?B?K1F3aC90cGVicmNMeWhhM2swVFFkZlhOalBseXM1VnZqTGZMVmN2SDJWRnNi?=
 =?utf-8?B?bWlRUjdFLzE0SmNuMzgxdE5SZUl5NzV5QThhRUo3WHAya3M2M2dwMGJuUFJw?=
 =?utf-8?B?ZURTWnlqY0ZxS3BqUTg3bUsvbEJ4dEVEZ3IvTGRLUXVnd29QVW0zbjRGN0tM?=
 =?utf-8?B?SVdNSWFQaHBRWHBjbFluNDh4QWh3bDQyTjlBcXdmQi9xQ2xmempVdGI3OVM0?=
 =?utf-8?B?RWRzdkVmTGNmQ0JzbnIwWWwzaUxZa0FHQUwvc3BudVBIKzdjTWhCNVhPdzVN?=
 =?utf-8?B?Z1lqRXI4RUdkSVNHOG9maHZLTUp2L1NXWGs5RnhkaUJidG85eWEzMkF2aFI0?=
 =?utf-8?B?T2dua1N3S0pOOU94MDVQdStMMUx4YnNwZ1NkTkppT282cjJ1MzlndDZjTkFu?=
 =?utf-8?B?Y21wYVRZOUFUTGxYcUFDbHl5MVp5K2NacW1LMFN6aUUwUUlYS1dydkdBV3lo?=
 =?utf-8?B?bTh4NUFKdWJ3TlpVY1F0ZzJKZWtHUDNjZVhwek9Hc2ZXSURtVHEzajZ4aFh0?=
 =?utf-8?Q?jSVru/n93vJ4QDeN21JAFtcuV+8jziBjaz4nq?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 791e49ec-636c-465b-2e53-08df2af1b515
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 19:22:52.5372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sg1Fwgtaho4+Rbh1DS/ziOs1/py3pSAR1RIniy3fLLpdFmr6D2yzrhw/thyDOC+0ZSZdlaLvbNHv0TLqCr7rBIk1jCcPUkI0zDiHCzZzIYzLBDfG8h41YzkdDSYL00L0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MIWPR04MB358405

This RFC is collecting more feedbacks to device when is good time to remove
whole async_tx framework and how to remove it safely. And is overall
direction correction.

Little to no real hardware acceleration usage:
  Most systems run RAID5/6 parity calculations on the CPU using optimized
  XOR/PQ implementations, while DMAEngine-backed async_tx acceleration is
  rarely present or exercised.

Added abstraction and maintenance cost:
  async_tx introduces an extra layer between MD RAID and parity operations,
  making the code harder to understand, debug, and maintain.

Modern CPUs outperform DMA offload:
  SIMD implementations (SSE/AVX/NEON and architecture-specific RAID
  routines) often provide better performance than DMA descriptor setup and
  completion handling overhead.

Obsolete hardware dependencies:
  Many async_tx acceleration backends were designed for older DMA/XOR
  engines that are no longer common in contemporary systems.

Complex asynchronous execution model:
  Dependency chains, callback handling, and DMA transaction management
  increase code complexity without corresponding performance benefits on
  typical deployments.Simplifies RAID code paths: Removing async_tx allows
  direct use of synchronous XOR/PQ helpers, reducing indirection in raid5.c
  source code [linux/drivers/md/raid5.c].

Reduces testing burden:
  Eliminates rarely used code paths that are difficult to validate and more
  likely to accumulate latent bugs.

Aligns implementation with actual usage:
  The vast majority of MD RAID deployments already rely on software parity
  generation rather than DMA offload.

Current dmaengine support xor is

Driver File		Driver Name			First Added Date
==========================================================================
mv_xor.c		Marvell XOR Engine (mv_xor)	2008-07-08
ppc4xx/adma.c		ppc440spe ADMA (PPC4xx)		2009-12-11
fsl_raid.c		Freescale RAID Engine (fsl_re)	2015-03-03
xgene-dma.c		APM X-Gene DMA			2015-03-18
ioat/init.c		Intel IOAT DMA (ioatdma)	2015-08-11
mv_xor_v2.c		Marvell XOR Engine v2		2016-06-16
bcm-sba-raid.c		BCM SBA RAID (Broadcom)		2017-05-15

fsl_raid is for power pc SoC, which already EOF.

Patches is build test only now.

To: Alasdair Kergon <agk@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
To: Song Liu <song@kernel.org>
To: Yu Kuai <yukuai@fygo.io>
To: Li Nan <magiclinan@didiglobal.com>
To: Xiao Ni <xiao@kernel.org>
To: Dan Williams <djbw@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>
To: Jonathan Corbet <corbet@lwn.net>
To: Shuah Khan <skhan@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>
Cc: Saeed Bishara <saeed@marvell.com>
Cc: Rameshwar Prasad Sahu <rsahu@apm.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Anup Patel <anup.patel@broadcom.com>

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
Frank Li (4):
      md/dm-integrity: replace async_tx with synchronous xor for journal
      md/raid5-ppl: replace async_tx with synchronous xor
      md/raid5: replace async_tx with synchronous xor/pq operations
      crypto: remove async_tx framework

 Documentation/crypto/async-tx-api.rst | 270 ---------------
 Documentation/crypto/index.rst        |   1 -
 crypto/Kconfig                        |   5 -
 crypto/Makefile                       |   4 -
 crypto/async_tx/Kconfig               |  28 --
 crypto/async_tx/Makefile              |   7 -
 crypto/async_tx/async_memcpy.c        |  97 ------
 crypto/async_tx/async_pq.c            | 464 --------------------------
 crypto/async_tx/async_raid6_recov.c   | 595 ----------------------------------
 crypto/async_tx/async_tx.c            | 299 -----------------
 crypto/async_tx/async_xor.c           | 380 ----------------------
 crypto/async_tx/raid6test.c           | 250 --------------
 drivers/md/dm-integrity.c             |  26 +-
 drivers/md/raid5-log.h                |   4 +-
 drivers/md/raid5-ppl.c                |  40 +--
 drivers/md/raid5.c                    | 467 +++++++++++++-------------
 include/linux/async_tx.h              | 187 -----------
 17 files changed, 281 insertions(+), 2843 deletions(-)
---
base-commit: 98a4f6276df67a1bb37b1be56a3ab4285155e3df
change-id: 20261015-asycn_tx_remove-381cd003d9f7

Best regards,
--  
Frank Li <Frank.Li@nxp.com>

