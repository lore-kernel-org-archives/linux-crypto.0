Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793735582;
	b=PvS5sa2u4kiHu6wROn/2P1VExrpbqHIACfTjlHyZ5H5QWCOMvdJcnMPbS2obneflplel
	 NxTw9rkIECsyQ6sOAiQQmMlQchGcRKWi+FfD1H2vXhqs+Xk8At8axUfYFzhfy0sAJiNhy
	 DYdl2cce3MDmgKb7jBgXIfdGWhrXcMAilF67DIhPjPqY+dMDHHCfzBrlTdNK9SVbClEad
	 f+jpP74IQRUKGs9vDzagqWxcg0hKhGYkjMbF8UDVnPlKa2PMVs2N94urc/gzKLstsSUlE
	 OkDWSg2z9vz8KQxt7qXN9h3TbPPYx1RYf2JaWxN4Sxa2FXkbtV4Bd3cA4FkZqYmY0zA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735582;
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
	bh=k+Ry+OAnxM03S3waQ0Rq7HQ1J3a+30PE5x1B5ttkunI=;
	b=mSjaa7LfhvQDX4ZLXoK3dCXDEJlPHnAufUdkdcYYhRC3kMtnS57smfQwoVAC5HzaLasR
	 n1jL/DmRI1qYRyoo+NAJoPCnZv7CCXCHAq3f4Y6KjOZxjh4GXPs1XEedl0vaR86bHVVjr
	 hvSn6yRWeX7kwzyS6cBnqDMMFodV2mOwAqdh+J8FN0a4O2jrGBrsTd2me8kfKOC28qMf6
	 foIUgIVYD8KleujUW7VkmFbU2tJQdFqsAJwAL5tmSx3I4ztGUAfJigjRNfHrSW5pu7XYd
	 nWH7bgM/l8he9QK4JJlVTp5ynVIErNahlTRQ3z4OBGsKerWq1qSxaanPyjmkldxqYRg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=YYTYQXFb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.35
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013035.outbound.protection.outlook.com [40.107.159.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D62606D808;
	Tue,  3 Nov 2026 19:53:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76D62606D808
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=YYTYQXFb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bpdj6PujBEF4wZGKiv2TaSbnxs1IGZf4f8Myx+JjrsLG+lkRcYGiWacinLlDC4E06CBjPBdSvgRWJ53Nb5zeVMj7iDrB/q2UWFa37fgYMoaCNglhTRU3Lc8pIflRsKoOlYvirB7QC/M7lTJ2AV0unRYuXnI/AArUrDyjdLqVb6vOUGtnEgBDUoDFgjzLWeKJteqwS2Y+dPtOuA2Uf3rOmPUC+x7vSaLQBdnyvbqVK2dl33URw3oZJLpUSt+p3rrPhJGo6L9FkPje5zsZzGn2BdNXXYZnGp1nqIlFiiKmOPYWsCM0SL5kEnNFSbLiYPOzSAPYMsTyV5rOBqfXffDIkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+Ry+OAnxM03S3waQ0Rq7HQ1J3a+30PE5x1B5ttkunI=;
 b=r8NnxOas+/iFf11uJU4AA7hHqvM35Y1XF0J8IsZCxKQI43HcQXxA44ilO+IbAXRoDJvbNQo/uLgsE/4qKwV7AgmYyidckDxwWG0UlLlzo6yav+KPf+G+NW1H4UTi35Jug7PPpkdt3a96LGW3ScmEc3vAhf4b47Vmms8RNILadLosxBPOQvj+DL9TYaxu08UPDM7IOQnHyeP0oNOAq6MXEuG+Pv/ZJ4PlzHOvqc7LaE2F6v6iCCY4lNbT6MWEXivWQ1a37U5GSDjUlABtEollMcKKNiKv3p4hEl3AgkxaSCmvkM3x/10/v/dcfiNPqxOv6WlLwfy9JThb8ixzGS8xpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+Ry+OAnxM03S3waQ0Rq7HQ1J3a+30PE5x1B5ttkunI=;
 b=YYTYQXFbj84QCIGtR59702WlCqNqN7dr2Ap2+fxjhJRvYReZ8FaTeZtoRqaluggBLQcybACPl8p2zRhaTs59nt3tcWDqz0pIYozn1gcKqloyxDpyxeRLTqXlhB8wbwtkvnaHssAK+KR/TSpwYppw+pZPaV6bY9p2r43M6UBBXgtoUXJXr0jACc0YI1Sp/kH4ya2v85/ooxRRj2cyCGGDcxhnNX33ah7bU6q535dOxlQRHPMLDd6Fv5laLr+CYSuGPQbjZsJmQkVQ7HBFYW6U5NX6TwxnAYKLdOd+yINF8iUQkjzEnhfCDnAFT7t1vYyF9rGm1XRMxqPGheWfu8TPVw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com (2603:10a6:290:76::14)
 by AMBPR04MB299223.eurprd04.prod.outlook.com (2603:10a6:20b:7d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 19:52:59 +0000
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b]) by MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 19:52:59 +0000
From: Frank.Li@oss.nxp.com
Date: Tue, 03 Nov 2026 14:52:34 -0500
Subject: [PATCH v2 3/7] async_tx: use dmaengine_get_dma_device() instead of
 chan->device->dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-async_tx_dma-v2-3-3afc7c59362c@nxp.com>
References: <20261103-async_tx_dma-v2-0-3afc7c59362c@nxp.com>
In-Reply-To: <20261103-async_tx_dma-v2-0-3afc7c59362c@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org, 
 Frank Li <Frank.Li@nxp.com>, Peng Fan <peng.fan@nxp.com>, 
 Dave Jiang <dave.jiang@intel.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793735557; l=6750;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=LxTl+PSsW4e8ho8Fhyfo83cVu3HXo2Uwd+v9C5aeP9I=;
 b=t6PQMEjRJNMv3ioVjs7Zd5A+Qurxfv5ygK4FKztk+1tBc2YUqLMUCD0eExqlM2LFXMwdnVwYV
 mfZPUYjSlDjA1tBu40PwvNfMq+vXCzsVa2R7HhUd9HW7tnMxm0Ixqwn
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
X-MS-Office365-Filtering-Correlation-Id: 9cd99ea1-7b17-4233-2312-08df39e40fe4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|19092799006|261021133027099003|11063799006|261022075727099003|261021121427099003|56012099006|261021123027099003|261022105027099003|261009223027099003|261021135927099003|261102123227099003|261022115727099003|261021130227099003|261022113327099003|261026140227099003|261026130827099003|261026121527099003|261028144727099003|261026135527099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	K9UY37atLWxzijm8MPN8vLOw1SqXUSwW0MrvRdxMvqgYnbwndkFbU17eT1uy1ujSwi9cOY1+wCiqh2EXg1F+jpd+05Gbkj27sa7Vvfcyzs2btaiqHuAjjYVcqQewAK9HPk13vuUgbbQWgaQJP1Er1monbWoXQgPGCFvpEgcpdBw+2k+QKJ4VOTL+xquGRY5lDvoZDN+AccEqxkQK44fQHQIAX/dq9XCRM2ARyNmbzaV9DeHbqyR4ivLgy8rzYxELwnsQgMeV8ZccaMwclft7SWv2LnoG86nvaywx99+G9jTN4z83fbOfwScJtqrphNC/BXd5swHkizRdbBVyFVOmUXfQObaexWBlGpCCBeTSY/wxQHxrxemlJ4XOQ+H3Lhbs/ZXpuWUGtxJH5v3ShTrS1WVCY9gwLa87Gk9XpLLDxTO98LJr3LAqDe3H0Rlaa68+4s+vvZO/2LJwZVFTHAAGzu0EuqcxIin+GOGcwctPZU901jC8vj3lIyodObmeJ3+t/ho0FMHVDMQfl/00rAn5HLalrY1jRsH+Vv2ykVDoZEge7C0x0/+LW1d82A+pWSlCRwKLtg8bBbAa2MQnOk68ys2071Sq9+uiQ/BCoSdJQvG94wuhmOLXk3BKX3SEJurO7HzUedNGghdtxU/yRZgH+yF0Wn/wEGy1FOrcAomNFSk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MI3PR04MB12438.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(19092799006)(261021133027099003)(11063799006)(261022075727099003)(261021121427099003)(56012099006)(261021123027099003)(261022105027099003)(261009223027099003)(261021135927099003)(261102123227099003)(261022115727099003)(261021130227099003)(261022113327099003)(261026140227099003)(261026130827099003)(261026121527099003)(261028144727099003)(261026135527099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVFLOWJkQXdOY0NvN2NDYnp0N2V4R0x0MzI4NGYxMXF4MXpmMjRNam1iaXJE?=
 =?utf-8?B?QnNjcDBveXduV3JqUEZUM0tVYTNwRlEyTCs2aERmVWhkbjJpYllvalpzUUZ3?=
 =?utf-8?B?NHdBVW1xRytJNGdVeVZTb0lHNmVSZ3djOTFNMnF6TGpGNlgyYVg3aVNyK2Fz?=
 =?utf-8?B?NzY0TVM2d2piN3ZLZDZyS3ExOU1YQXQ2SkNlYk1pT2l4Rk9OU0NsRlk3cUM0?=
 =?utf-8?B?VUo0d0NONUx4QXZKeGQ2aUxjbnp2NEo0Nk1UK1ZVcDlMdW1kaytVV1JsazhS?=
 =?utf-8?B?eEF3dGthMHBUd3RyVTBKK2xiOFV1MUtZMjlUZkVaSThPTGNjcVp6RVI1dzVX?=
 =?utf-8?B?RWY2QTcyYkxEeFRjSzZDeGVtNXZCenJLYnVIS1lBRjc5ZmJERDNoUUFoaC9N?=
 =?utf-8?B?ZjJhcEJabWZweFUrQVpoSGpHL0FRbGtaNytHZ1dlbUUzeGpGTXZRTEw1aXVy?=
 =?utf-8?B?Ny9KZ1MrSDNpY0ZBZVRvVDEzWHpWSzdrY0I2UmFnR1o5a0M1eURYNGN2dC8y?=
 =?utf-8?B?SldnUVRtMGFMS3BjOTdkSHhDNml0eE1rRDl6SGxnQXdwTkZvN3E4ejFrcDA3?=
 =?utf-8?B?OUZML0htcUY5bzFlWkIyTGpXMTc1MzUrUzIwQWdpdHJocVNzbXRYZUN5Qkxs?=
 =?utf-8?B?RFFyendoelJoOC9nU0p0RzM3SnBQbm5uMlBRall6bzVUaGxNUVVnRVlpa3Fn?=
 =?utf-8?B?dlI2TUM3OEh3OWdpY081d2ZudS9yeFpWNVI0ejRMZVlCSVdUNlF0dXJsR0s4?=
 =?utf-8?B?SEdoSU5iL1RFam1qeEkya0k3aFRuaklEVGFlOHgrbVFYOVZ2b1pDUTJ3dEl6?=
 =?utf-8?B?MER4aVZJTFhGcmQ4REY1ZFUxakkwUTNRSlNZY2xvYTU5eHc2WmpjQ2lNYzJx?=
 =?utf-8?B?Z2xxWDVyaFZES3RPby82N0FieUc1VjNPZ2xRVC91U2hCOWtia0QvYWt1Ni9L?=
 =?utf-8?B?N0Q4eUlFK2swYmtmc3V3NDk1RW9wNkQ1NGJuM2dCOE0zTTdQOEg3YUJRT2xi?=
 =?utf-8?B?YmhWMU9rVlV3azh5OXFBaUtOTmp1YUJUYVpPTkUvUGdOVVg1L3ZHNTVpbTla?=
 =?utf-8?B?MzFGbThxL2xPTVg5Z0h3dVVQbEQrdDBSLzc1ZFlCZGVydDRZdG05ajBRaWZM?=
 =?utf-8?B?cnFnM0czb0NUa1NJQU94Q2Fiejk4QUtrekdvVFp3eFpMdVdWbTVsOEs5ZG1D?=
 =?utf-8?B?eW04cVc4K0NmVHB5TjYrR0ZNSm45Uy9rTjl2NC9GdG1YLzFQSUwxNnYreHZw?=
 =?utf-8?B?NklYR2N1TjJ1Qk45M2NJek94R2UxQ1FsanB1SHF0REwrc0JuQ2Rtdkp5b0dj?=
 =?utf-8?B?VStJNVFHVFpPNmRLWlBqNHBaUHhpb0k3a09uRXZwbnFnMkNkOGtlN085MVBF?=
 =?utf-8?B?NUhWL0RYL3Bpa2xXQkVHOTRTRVhoeTBiZmpRRzVpOEhkbzJNZTN3NmRaL3I1?=
 =?utf-8?B?dEFiM0JpaXQ1Q2ppcE1YS2NSYW9FSmRHZ2xlT1B2RUkwWTBteWtqSmk0TGJG?=
 =?utf-8?B?WUozNkgyMXZIZzg3dGVSUDA3dXloT2xyU0I3UEhQcU9EdTZ3TFhGc1dIa3BW?=
 =?utf-8?B?cWovMjhTNHJHUUJYV1IyK3I2ODkrZ0hZUkFLQjk0Y1dPa0JHWi9PYm92Sko1?=
 =?utf-8?B?amwvbWhrcTYxUkMxdFdIZHZZZm54b2hFdlB3ZGlkdTVXRGxpN01INzg0a2Qz?=
 =?utf-8?B?MVRlYUxVMWlXMUJEZTJ6bFBncUJqT3ZsSWV1djZFdzU5b1BLaERGZU1qcXRN?=
 =?utf-8?B?cVhxS2tGRDg2a2dFZzRYeFVMYnJ6NU11V3N3OHVsUlgwRml4dldCKzJTS0hw?=
 =?utf-8?B?OGFLS0wwSmlteE9hYnpMdStCWGJtWWcxR3VkWURUSHZWVEtkN0VnSEFwaWcw?=
 =?utf-8?B?ck1UZ0w2OWFXSVA1cnNzVm5YbTlyaUZESDEwKytjM21tT3ZjQzdOLzVhT1Ey?=
 =?utf-8?B?bjZuU1VVMkRQSHRMb0tOU05RemhReFRVNnVnSG0vZFF1cW42SVZqbW9udXN1?=
 =?utf-8?B?R3ovNDhZV1NwdTVjQmpaRU1UK2p1QUZHWFRiMjhkanNHOXFOMnlsVUgzTEti?=
 =?utf-8?B?Z1Jra2lPRFlRc2djUlZtKzduU3hMWEFtbEdtUTFERzQ1eUxFTVhoektSZEFL?=
 =?utf-8?B?TjBLUGFWaE1zRC92NTE4Tng0N29nblVuREw1VEFzVGxTNVZDUy9RMjRQcVVq?=
 =?utf-8?B?UGpGRnRoYTZLMU54MTZmVjdFMVF2bmdCMmdUNlhNNWhVN04rVk4vK0xXdkdq?=
 =?utf-8?B?WG5XdDhlTTlXcDEwaVA5YlhzYTQ4SkxuU05FY3dmNmFZaGxTTUJkT3NGMmdZ?=
 =?utf-8?B?VXIyY09NY2F3NlJiUzhEdmxVeTBLSmdud0dsWWthaitjRy9vWFZBUzV0SVZh?=
 =?utf-8?Q?scn0GAidu93LfaIWPXy4OHZ8pNyxGcpq/CG+1?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cd99ea1-7b17-4233-2312-08df39e40fe4
X-MS-Exchange-CrossTenant-AuthSource: MI3PR04MB12438.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 19:52:59.2410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ib9Iy+74ljK+hBBaQQKBJ0wRawZEbpR6bv5g3xCEaCOqpP5mUn/lfGS8g0n8XNZyZBfCUzggYo3LdDbWOn/l7ljaQ17qhp3i04m3auo/MfhoQSwFghJwwlWHESfEbK18
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR04MB299223

From: Frank Li <Frank.Li@nxp.com>

Replace direct dma_chan::device::dev access with the proper
dmaengine_get_dma_device() for consumer API.

chan->device->dev is not always the device used for DMA mapping. Some DMA
engines support per-channel IOMMU mappings, so different channels may use
different DMA devices.  dmaengine_get_dma_device() returns the correct
device for each channel.

Prepare for making the DMA engine provider data structures private. DMA
consumers should not access DMA engine internals directly.

Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_memcpy.c      | 5 +++--
 crypto/async_tx/async_pq.c          | 9 +++++----
 crypto/async_tx/async_raid6_recov.c | 4 ++--
 crypto/async_tx/async_xor.c         | 8 +++++---
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 538bb83df841c..49ee66759c7e9 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -44,6 +44,7 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 
 	if (unmap && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
 		unsigned long dma_prep_flags = 0;
+		struct device *dma_dev =  dmaengine_get_dma_device(chan);
 
 		if (submit->cb_fn)
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
@@ -51,10 +52,10 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 			dma_prep_flags |= DMA_PREP_FENCE;
 
 		unmap->to_cnt = 1;
-		unmap->addr[0] = dma_map_page(device->dev, src, src_offset, len,
+		unmap->addr[0] = dma_map_page(dma_dev, src, src_offset, len,
 					      DMA_TO_DEVICE);
 		unmap->from_cnt = 1;
-		unmap->addr[1] = dma_map_page(device->dev, dest, dest_offset, len,
+		unmap->addr[1] = dma_map_page(dma_dev, dest, dest_offset, len,
 					      DMA_FROM_DEVICE);
 		unmap->len = len;
 
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 37bc48bbda821..5f62f2edefe58 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -196,6 +196,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 	     dmaengine_maxpq(chan, DMA_PREP_CONTINUE) > 0) &&
 	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
 		struct dma_async_tx_descriptor *tx;
+		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		enum dma_ctrl_flags dma_flags = 0;
 		unsigned char coefs[MAX_DISKS];
 		int i, j;
@@ -211,7 +212,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 		for (i = 0, j = 0; i < src_cnt; i++) {
 			if (blocks[i] == NULL)
 				continue;
-			unmap->addr[j] = dma_map_page(device->dev, blocks[i],
+			unmap->addr[j] = dma_map_page(dma_dev, blocks[i],
 						offsets[i], len, DMA_TO_DEVICE);
 			coefs[j] = raid6_gfexp[i];
 			unmap->to_cnt++;
@@ -224,7 +225,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 		 */
 		unmap->bidi_cnt++;
 		if (P(blocks, disks))
-			unmap->addr[j++] = dma_map_page(device->dev, P(blocks, disks),
+			unmap->addr[j++] = dma_map_page(dma_dev, P(blocks, disks),
 							P(offsets, disks),
 							len, DMA_BIDIRECTIONAL);
 		else {
@@ -234,7 +235,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 
 		unmap->bidi_cnt++;
 		if (Q(blocks, disks))
-			unmap->addr[j++] = dma_map_page(device->dev, Q(blocks, disks),
+			unmap->addr[j++] = dma_map_page(dma_dev, Q(blocks, disks),
 							Q(offsets, disks),
 							len, DMA_BIDIRECTIONAL);
 		else {
@@ -314,7 +315,7 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 
 	if (unmap && disks <= dmaengine_maxpq(chan, 0) &&
 	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
-		struct device *dev = device->dev;
+		struct device *dev = dmaengine_get_dma_device(chan);
 		dma_addr_t pq[2];
 		int i, j = 0, src_cnt = 0;
 
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index 306448c47aa00..4f223fa36c706 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -32,7 +32,7 @@ async_sum_product(struct page *dest, unsigned int d_off,
 		unmap = dmaengine_get_unmap_data(chan, 3, GFP_NOWAIT);
 
 	if (unmap) {
-		struct device *dev = dma->dev;
+		struct device *dev = dmaengine_get_dma_device(chan);
 		dma_addr_t pq[2];
 		struct dma_async_tx_descriptor *tx;
 		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
@@ -101,7 +101,7 @@ async_mult(struct page *dest, unsigned int d_off, struct page *src,
 
 	if (unmap) {
 		dma_addr_t dma_dest[2];
-		struct device *dev = dma->dev;
+		struct device *dev = dmaengine_get_dma_device(chan);
 		struct dma_async_tx_descriptor *tx;
 		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
 
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 40caee262a4ab..0fb29da2235cd 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -183,6 +183,7 @@ async_xor_offs(struct page *dest, unsigned int offset,
 
 	if (unmap && dma_xor_aligned_offsets(device, offset,
 				src_offs, src_cnt, len)) {
+		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		struct dma_async_tx_descriptor *tx;
 		int i, j;
 
@@ -194,13 +195,13 @@ async_xor_offs(struct page *dest, unsigned int offset,
 			if (!src_list[i])
 				continue;
 			unmap->to_cnt++;
-			unmap->addr[j++] = dma_map_page(device->dev, src_list[i],
+			unmap->addr[j++] = dma_map_page(dma_dev, src_list[i],
 					src_offs ? src_offs[i] : offset,
 					len, DMA_TO_DEVICE);
 		}
 
 		/* map it bidirectional as it may be re-used as a source */
-		unmap->addr[j] = dma_map_page(device->dev, dest, offset, len,
+		unmap->addr[j] = dma_map_page(dma_dev, dest, offset, len,
 					      DMA_BIDIRECTIONAL);
 		unmap->bidi_cnt = 1;
 
@@ -316,6 +317,7 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 	if (unmap && src_cnt <= device->max_xor &&
 	    dma_xor_aligned_offsets(device, offset, src_offs, src_cnt, len)) {
 		unsigned long dma_prep_flags = 0;
+		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		int i;
 
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
@@ -326,7 +328,7 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 			dma_prep_flags |= DMA_PREP_FENCE;
 
 		for (i = 0; i < src_cnt; i++) {
-			unmap->addr[i] = dma_map_page(device->dev, src_list[i],
+			unmap->addr[i] = dma_map_page(dma_dev, src_list[i],
 					src_offs ? src_offs[i] : offset,
 					len, DMA_TO_DEVICE);
 			unmap->to_cnt++;

-- 
2.43.0

