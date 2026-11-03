Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793735604;
	b=k6I7qgpABOzt5veZMveA/X/FmRsPLjteF5fYvBUJzqAWmOH2VdTw8NNQetXl58Pn6hVw
	 L3lq5KlXg7TqNWpTKEpOMQxARZw2V6mXapWAVLfr+wCdMW7WkBXnkylaLt0zdYL2o0bPZ
	 iPptkFtiy/Y+nH7kapOn5brXtLDeuOjWVPvD0g8ts8CbYm+lU1ZJPC3bLi4P9Q7N388LE
	 SpvYCJdM2VWyKmym1q8GcbKXKL8DRNis2B+jJ2CTNVBCRwViLGCrsOOH0Kn9irCpt9cMn
	 cqUJsfl+9Y2xiZ9fuY/v0AHdyMZ9bA8otqsFaXHgwOUoWa95Uh1nWDPox5bironOgtA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735604;
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
	bh=A3B22sRhyL2+zKkGVXLkpIkJ0GEjiJA1mfOLni8lhZw=;
	b=z6k4YsL/lPKEuPq614ZXekju+SModcBYWoEeazLk103Gsl2UW+VdbvQMh1oYxkt1G2Us
	 gMffVPVnu7iApXN+BkfjqcfC9yD6HMsQwZo7oFVMT0T9HCD2kjA4QzptRa+BnWz1c9xGO
	 Z94+Ca5LPP/O42oQu1w+gVS/unhHn0kP6s7pQhxrT+qKaseiLPrngvgRuWQWNuFOv+nRz
	 ybenCagFpFyS/IEcJ0kSytuUz1Ho8oxs4S/5TW793V+4rwAZ+gyJKeYSDaX1rXBjTZEoW
	 mJsuEfUwCF0gb3k7W3j44vxZgnWD9UNyZ0UIbblQ4TyGdETsqbqCQGRMdKkSJLNJXyw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=fuoa8K9T;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.43
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012043.outbound.protection.outlook.com [52.101.66.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD72606A33D;
	Tue,  3 Nov 2026 19:53:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FD72606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=fuoa8K9T
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f96yhZRu6Mw24Q+Sqs9TGGOMjBtqu3AaSWmkNSauuaTh0c9A45IL9Di0LPLI8WX87tqZDIvnt9olPhV4AF/tNgwio2bjvqJ68B6HKuVnViegMcJgvdqhFVBvRp9SMgBGkDfWHjnQPpfpxnnnoYRx2bQUj37x0GEV4EebtVXiNFTnRFFfq56j8FZl+8iev/18RdZ9bikgRYo07+npBIF7Vhr545hzKMMq+23/lQGOLcHx/1pTdeT50tqtv2nHSKJaCQmhANIXOpUnrP6oPREAb2VSMt/BxU8YqpyrdQPUwbmOhmg5Zx0Ay0MpvpIliU5mRXYecPXDlVBawmZLrsG0qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A3B22sRhyL2+zKkGVXLkpIkJ0GEjiJA1mfOLni8lhZw=;
 b=gL2hiYP5NtpOz/7GvZcAsEAzXkLS7sELf2K1EaygXsM5odntsgihvuHNuXZW6eyo/lze1RMoYKOEEpf0b82Sh6pT+yGwtuwVdz7qCuCrnWJXYxgkb6Ui/3JAcqMTJ1q/NC7vOk9RLohzKdYgfgAVOgoSA516NxVGQI2cdznMHG46RoZQ6a+gnpPwQtBVfBLLis/9AAPNy+/9bTeW18tzktqgI0onSb4PeClptyxDJ4Rz5Hr+0i3XB0nCrzMBzEy0EtTp7AQB4IUc/n+FnkuZqHSeMWBLwCxy7hC2J/A5NZYst+XBa6/Td5EvSu/20SPnkFVzHTCOLJzauHdASJrTzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3B22sRhyL2+zKkGVXLkpIkJ0GEjiJA1mfOLni8lhZw=;
 b=fuoa8K9TSK59KSkmsPCKjPe1BYaDa05Avwso+4WkbjZ16DwA3MJp3wfdE1AqfNTsl2LnxIX7/8akAUV079jJZ/+9Wt5JEDniiqTFpWtaNGjtEjiCi/VrLn44uj0eEhkmubl3ej9YfDIo3b3uroRuyycV3LSee3g/zJPuCV5CuQWWhGmnloBRjXele3BVAMoMidrpobYyIL0IxGaX7RFuMR+/f0EtfcJAc8vSSQfTPO8ulzQzRQEmFeTQPC9CN5ogGxWzF9g+am1j0tP10CvID2Yrf7XL2BebI1F3qs3mI6IkcibpKjd3i0V+OItdN7dCdaLwumPhkAHN49ThzyZOXw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com (2603:10a6:290:76::14)
 by PAXPR04MB8829.eurprd04.prod.outlook.com (2603:10a6:102:20c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Tue, 3 Nov 2026
 19:53:20 +0000
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b]) by MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 19:53:19 +0000
From: Frank.Li@oss.nxp.com
Date: Tue, 03 Nov 2026 14:52:38 -0500
Subject: [PATCH v2 7/7] async_tx: Mark as Deprecated in Kconfig
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-async_tx_dma-v2-7-3afc7c59362c@nxp.com>
References: <20261103-async_tx_dma-v2-0-3afc7c59362c@nxp.com>
In-Reply-To: <20261103-async_tx_dma-v2-0-3afc7c59362c@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org, 
 Frank Li <Frank.Li@nxp.com>, Dave Jiang <dave.jiang@intel.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793735557; l=1070;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=IUrm6onBSpLn4DYXFPdGFi4Cs7ojbtdwb/nFk5FkkyA=;
 b=TlPX4sWw0THxOOVLolsFy16nRwOPA5P2rnrKiTZnwuRtpw6Vpn7m1t38GTWy94s187Ix5TYt0
 n4WheRROMs9AXjDOW+Sgjt+a9VcLamjTc8R7w0+e27JwIVJRb2Tfsgn
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH5P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:34a::9) To MI3PR04MB12438.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: MI3PR04MB12438:EE_|PAXPR04MB8829:EE_
X-MS-Office365-Filtering-Correlation-Id: 47eadebc-c3bb-4fa5-060d-08df39e41c07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|366016|23010399003|1800799024|6133799003|10067099003|22082099003|18002099003|11063799006|261021135927099003|261102123227099003|261022115727099003|261028144727099003|261022113327099003|261022105027099003|261022075727099003|261026135527099003|261026121527099003|261026140227099003|261026130827099003|261021123027099003|261021121427099003|56012099006|261021133027099003|261009223027099003|261021130227099003;
X-Microsoft-Antispam-Message-Info:
	Ba67OcwjOJ2uLrNDzBO/Z3ZMVfwdXzC0jqIPQpAZp3HIOFYnvBLEV+zrme5dTwDsYfzJ+YMzavNU9uJUHP68s/Ho6hEscoiySNoxhTfm4bxZl0PPl8nxG9FdmPnDIs4N2hEMBeyCE7F4o8tj4LROIwV1howWbEtY6CQn29Up7PVWBqBwFy4t4nk6PbhdXkVtjQE1kyJ6oESrfD+wD3fbfPuxbwHhWcIZaTK2RCnSTCSHcJNilWPCBntKkNOCKH1OG/DQ5iXi7sH3/nXYbHtnDRPdJM1XcOnbqeB74CZe9HCFMU7Erh3ogiRTCj19Rp5joUjmrYkNYQCa9Q96O4iaD7s/2B71UeHBE/ozoWWb1Ggr+m7uiWFWZwWyTxGEjY15b6nvBL4a3Ne5jHNduQfbRL+Kr4BuYe0lFw8trg7uaiLKCFrpR2lXmW0udr3lfQfU0PhDobRqlthjibYKH0ghkGy3H0SYvAsuAa18LTl3Dr8uF7RJuM0wt3xewkt79GSYLS+gTu5S9EksKvhgUEDlMwUcntxYp6RxIDcm5pmp6TMgdyRSaA4nleoK/UYNz9LNf/tIZoPqW0aphUJxE3F35r5G3V4ksUz05jyUYoBiPCuay4iHcOfQM7KOzQvlepfKQEg0yxvgo1C8G1MPkbpN2y2NOiNSHgADTGDAkJcXoEM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MI3PR04MB12438.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(366016)(23010399003)(1800799024)(6133799003)(10067099003)(22082099003)(18002099003)(11063799006)(261021135927099003)(261102123227099003)(261022115727099003)(261028144727099003)(261022113327099003)(261022105027099003)(261022075727099003)(261026135527099003)(261026121527099003)(261026140227099003)(261026130827099003)(261021123027099003)(261021121427099003)(56012099006)(261021133027099003)(261009223027099003)(261021130227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bGlVWW5ETVF5cXhLekMyRkZlUTcxMlJpSjVTUStRQXZ5UG9raHlEQ0d3QzNt?=
 =?utf-8?B?c2Q5UWxFQ1JxTVpQN1htdlI0ZHk0UVdabkhDUmtkVWwybG45ajIxYlJOUlRQ?=
 =?utf-8?B?SDBCTk1QL1I4RkpjVmpmSXlPOHZoMHhYdkZSMzdvdStaTzQyaWV1dzdTRjhM?=
 =?utf-8?B?bS92bEFGWHJjZVo2L1Y1MWFnWDdOdTIyRCtWb2JmRTkycHVrekdtVHpSR2hZ?=
 =?utf-8?B?VlVQaVMwbnQwYm5DK2l3bDhKSGl4SGFldmo4YjNaY0ZtR082U0YrV1R4OUZL?=
 =?utf-8?B?Rk10bFdRSDVibTdGa3ZieWxIeWNFSU1hY3REVDQ2N2FIM3pnZFN1dE16UkRa?=
 =?utf-8?B?RUZMUnNZUnZlMlpkQlM2MnBXaGh3LzREdkhmeE5JN2p0a1dPU3lZVVIzaGgy?=
 =?utf-8?B?MkZZYWJKcnMrWUI4b1ptM3ZlY0FNWUhZMjVEcnVUcTdYd1Z4Z3M2L0kwc3RE?=
 =?utf-8?B?SGluL3ZjM0tKcnZTSnBYWUlxSUhwZDhucTVmcDlSSWo5Vkk3ek1RY01uVWp4?=
 =?utf-8?B?bk5sWDV4b3lSb3p6blpKR09iNmFPbXNYWGFsdDBKRTdxQVBLeE5xOEh5VnRj?=
 =?utf-8?B?S1BzSFNKOUZqM09zdGJpSGtXcGVVSWhBcXMzMXpHVGV3THhXRWc0UVlBMklJ?=
 =?utf-8?B?Z3RvNTRoeFdqcG0rWVRLK0Q2WHYyK2JaaFVFTmE0ZDBibEI5QUFURHA2Nm1L?=
 =?utf-8?B?U25sTllnQ3RaMXhIMm8wcE5aWElJUm5FVnhSUzk2ZjhKc1MwWlBVdU5GRWcr?=
 =?utf-8?B?UFd0c2dhRm1lQlRhWFVqeDBKa21KY1dLc0FGMEVPNlhiZ3k0ODhRUXpvbzZK?=
 =?utf-8?B?MkJzLzc1ZkJ0WnBjcjJvZnhab05jYmoxMDVOYzljeXlkUXcrZVowVDkyTzZv?=
 =?utf-8?B?U2JSbVQ4bWQwMitLdFY5WjNiTis2ZEoyTjRVMWM2UUdLRHc4a2xoeE9vdHJn?=
 =?utf-8?B?WEk5TVNWL0FjTk5reThKUjZobTYwMno0NTFZN0dsbUd5VlBuR1l1bEhXWkxj?=
 =?utf-8?B?MEJZcmk0dFZsUTkyOUZVQ0FuOW51UGJhazZZNm55NDlqYlJ4dFduV0ptQTRw?=
 =?utf-8?B?M3dIN0IrWnFsaVFUa1BBTVhoSUFoNWw5VDZGNkw1ampnZDZ3R2p3Q3lmRis4?=
 =?utf-8?B?dFBpUnNTdGtNbnl3S3hWVFRkRTZMTFNqbFJGYWRhSm9keHZ3eE45YnBLVHN4?=
 =?utf-8?B?RVpYVTBTOSsxWHU5WTExdkhjTlZoYmMxUldKT1hoTDhNY1B4aTlIMnh0UWZ3?=
 =?utf-8?B?eExFVE9EODZieHdVRXZ3dGdsTVB2QXc5K2VMR0xTUWdJZHJPR1dxUFdnSlE5?=
 =?utf-8?B?OCtvNDdualNQUFgyOTBkanFySVlhMVRCNHoyK1R1RzEzMXBialNXR0R4VCtS?=
 =?utf-8?B?K2gwWXh2eTNaKy9kRHRVdFU0M3hldUF5SVlHcitud3EvdDJaRkM1eWxCN3R3?=
 =?utf-8?B?czVKK2MvSkV0SStQalV3d2JaN1QvNHU3SmxTYWJOLy91dkl5bXVyeDNHd1pE?=
 =?utf-8?B?RVBnNHgxd0cwSTJ4UkdvQW1kY0JDeW5Kb0gzVnZXV3ZYYjBaSEtKVC9CNitP?=
 =?utf-8?B?eHBRaytoQVhGU0tWb1FhWnVsalAvZUxKYytBN3J3UzV5aElsdGttbUhFZGhG?=
 =?utf-8?B?bXg5QWZSWXE2YW5tVTlrQjVPNk1mUHVlUGNidWE0NkpKRkROMTdKTDBrNVV6?=
 =?utf-8?B?V1poL2NOSFo4TXNVNWcwSG5qd1BBSEV1SjF2aUF4OE5jQW5UZ1UyUlV6cmJu?=
 =?utf-8?B?b2x3MThrSzRRWE9wSGZWL0JhNUJNQk11ZHVjdFVTTTdjUnVOUDN5Z21PTFZs?=
 =?utf-8?B?Slg5UU9WOEoweGo2SUh4Z0tZR0pWOHFjenZLZEFaWmJvOTRMWC96VTQ0c3B0?=
 =?utf-8?B?TE5BZkZEeTNiTlVvMmR5T1RpbkZSTWJJbnZ3dGZpSGczTERzajBjbFN5MXg5?=
 =?utf-8?B?cnRlcXFsODlPWHFLR095dEtoM3I2TVFkVUJxNmFBRWwveXhTMklCVU1aRUJQ?=
 =?utf-8?B?aDZwUGJlMzd1VytEMTVZcW5lWWFQWUhxM1A2ZGxQczRENElhdlBRYzRCREhZ?=
 =?utf-8?B?YVlNeEFMeVVpTXFjTVB5aTBpTmdLYXk4bGZJNFYrdG1WZG8zV21lSUVSbmN2?=
 =?utf-8?B?bW5CenB4aWNBOUZmV09DOHFOeXJaZUJUbUtnNnhUMTFGWjkyekZhK1FmbWlz?=
 =?utf-8?B?SWhlYnNzMWxZWGR6ODNyZGxvdElOdE5JcVgxVEZqRFVhd3hFd1dRdDRiOWR4?=
 =?utf-8?B?VkZGRGRzQ1BDZkJVNjhyaS9rRGdXdDFtS1B1QVdhOEVsNzdzeUtlU3lUaEZ5?=
 =?utf-8?B?OGtHRnVpTmQ4QjZsZ1diUnk5c2RhVlQvQVUvM0l6RTBLdlIvWWhBL216OVN4?=
 =?utf-8?Q?xprPYBbmJF66m2SIUMpZw+8qc0zs7UCIFAfjm?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47eadebc-c3bb-4fa5-060d-08df39e41c07
X-MS-Exchange-CrossTenant-AuthSource: MI3PR04MB12438.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 19:53:19.6115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1+R286kdSpY7Nupg7zJMuKB0JswmdsOs+uB0gt5SvP9//+l1gQaQGbVsdy//SCFc8qa/WhNGCR8uVdhTHRnWQoFbN3ExPOU0RS6tYQJzVDVGzgbWfD+GDEWSzAOT7hir
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8829

From: Frank Li <Frank.Li@nxp.com>

The async_tx framework was introduced to support asynchronous RAID
memory operations and DMA offload engines that were common at the time.
Today, adoption is limited, most clients use DMAEngine interfaces
directly, and the framework's dependency-chaining and software fallback
features provide little value for new users.

Maintaining async_tx adds an extra abstraction layer and ongoing
maintenance burden while serving a shrinking set of users. Deprecate the
framework and discourage new users in favor of direct DMAEngine APIs.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/async_tx/Kconfig b/crypto/async_tx/Kconfig
index 89bafa2efc300..02d472fc7a476 100644
--- a/crypto/async_tx/Kconfig
+++ b/crypto/async_tx/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 config ASYNC_CORE
-	tristate
+	tristate "Async tx core (DEPRECATED)"
 
 config ASYNC_MEMCPY
 	tristate

-- 
2.43.0

