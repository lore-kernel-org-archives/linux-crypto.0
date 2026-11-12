Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794478486;
	b=mS/4pD1zSlDdX9a4OHcQblyd2bHQ0PBhJM0JE2qKzjG3V5N3A1o99fvpuS0Jy2Xpghy6
	 t/V3E5OnCNU0o2PmBwNSJorY802OjGrYSfK934lDdSFK+R6SejOpT6PI+U3M1eu0QgQsF
	 ctCSVRNPLLV5s+mm2l0U/SwFXP7V90Le3qGEIMHKixJTNLMdHcJRvr9Ejzyu6aE/CSM5R
	 DQ2kfAe5vvwBJrUiPVesOMdXq3XvWlVlZEOahMAK9x1KJnGScZhBSjZjAncpx0GKRQUeN
	 R3nbhzRKYZeCmsnPEe1XriFUFbz/k3/pPndT0f5rToCxxlxsUj640kdS7LV2Zuo8jTw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794478486;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=g79KqDdRogso1j1ny8bA85B1JP/9iGVBYuZ/5cbwqvI=;
	b=GZCRytxbFuQ6z8uMZRv9QW3lpI9pFVY6tSq72kxxzhXAdPK/eRl3M0i6biGB7cQNSmrL
	 IuyRZ2u/+NFfHCtBGMU4SAWxS4K3gA++bRK6Lz2/LVjKLr/fMfX0jPrE70vsW1APkBP+R
	 YSkTzfODVRjGSL/rFhY9DrGjVF1KXXt+ohvZzAkqm2Xl/9xtQJJDkAeHp/OKeav2zaoAP
	 D53UKWM6dqyN/NyU5/tkToxKkNTMp4zAfvbPPlOTClIxiby2sExrhI/sYK6e4fjJSnl7h
	 ahBOODqobRXS0+5HSquphpPPfmDV0mM/uzj/xUHWOJq5tbDAKqv29X7CJxGmhV4DrZQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=YKrzue2M;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.28
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013028.outbound.protection.outlook.com [40.107.159.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB14606A321;
	Thu, 12 Nov 2026 10:14:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABB14606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=YKrzue2M
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SAtb/j8Um/Nq6lGXK9l9Qgv37E/W3aGVPTxd25WKIyvQS7wvq5t33d3ZRBVoDz0ZzJRn4XHpDhv03wd0hz3uichT9QIDKeqR19Pc1qD+ZJfAGSMD1NAdLrgEVdXZ8Fb3vZ0BH8NFsbZafOIp7dNhJgMN7QQFtxIopBd3yzP+sCJSLTcFHa5s+8qY6FZvFSlp/2YJfcxQ11gnbMgU0C5PqwsBib3yGyl/ZfxBgndyUV5J7D47H0Mn8oaLKyjJKhpXkVkmPiSqZLsszbe3Em1mxBN3/rckQLzAv2b2BW+s/JWZnUDD38dUuZZeK1cfAH5lklGryM43ZGiEoGPukQzUyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g79KqDdRogso1j1ny8bA85B1JP/9iGVBYuZ/5cbwqvI=;
 b=SGoUAgl8w294AUtjRLGaNNKPD14GmRMmHUVFPiq7ESnfvZiXrhuHCRXCOp3d3bbmfqucUFn7OG6SlGnpQavnZGvNvYOTdbbAZSGgvTLmjf8czA/MhkoZNi7u8dfgNxVTu5E970q5BAW7BaOTULlDCYf78yNL8RoqdxJ2xLsnK1Eu/cFEcwEe3/kjLg3w/AjD4F7ZxRYyOq4F/FGy8Fev/4GWfM/4N8LdQMSvA41TJ89EJhjuFlras4zegEpASjAFX/akgx07w/wNSx6hz1gUZUtrjWWNes4ZgL+jzU9A0O7PB5ef6o0xgpLUSHKt1Kiksbg/9+gr2HS08yjduKGNeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g79KqDdRogso1j1ny8bA85B1JP/9iGVBYuZ/5cbwqvI=;
 b=YKrzue2MpKFV3n01XSAXLWwxoJ5gShv122cdAHcw8tC8UTh8DfoZCAwsL23/Qup8wlY43Q/pvDlycbSusYVrxlU6/+vpYc2AsWpKDOvZI7F6DePkhNXZA2GvN7SQ2cT/eRQnIaA3/6lK40H77kw280mwUCXhIKnDncQwet+VvKKkSytO76aoho/WBaS/tBfJE6AmYiKYWlZGMGCfJt6w9ZCzhsQxZ968AuwTdn0N5GFA7TxRgAgku/tXlU6IznFTgNd/ti+93uyT77j2+0mNnHKLlTkzjVr+vLXM1SyQvxuRTs+NH8ApttqHqxzHGVBp94QBTnQwB9Zdtnh5FW7YHQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com (2603:10a6:20b:4dc::19)
 by MMZPR04MB387749.eurprd04.prod.outlook.com (2603:10a6:190:4f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 10:14:42 +0000
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4]) by AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4%5]) with mapi id 15.21.0615.009; Thu, 12 Nov 2026
 10:14:42 +0000
From: Sahil Malhotra <sahil.malhotra@oss.nxp.com>
To: Vincent Jardin <vjardin@free.fr>
Cc: horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] crypto: caam - never share the gcm and skcipher descriptors serially
Date: Thu, 12 Nov 2026 11:14:40 +0100
Message-ID: <20261112101440.673231-1-sahil.malhotra@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109-for-upstream-caam-shdsc-share-never-v1-v1-1-65a1dd146db2@free.fr>
References: <20261109-for-upstream-caam-shdsc-share-never-v1-v1-1-65a1dd146db2@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR0301CA0059.eurprd03.prod.outlook.com
 (2603:10a6:20b:469::21) To AS1PR04MB9358.eurprd04.prod.outlook.com
 (2603:10a6:20b:4dc::19)
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
X-MS-TrafficTypeDiagnostic: AS1PR04MB9358:EE_|MMZPR04MB387749:EE_
X-MS-Office365-Filtering-Correlation-Id: 09843eb6-b45f-4435-02ca-08df40a5c49f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|19092799006|23010399003|10067099003|11063799006|56012099006|261028144727099003|261022105027099003|261026140227099003|261026121527099003|261021123027099003|261021121427099003|261102123227099003|18002099003|22082099003|41080700001;
X-Microsoft-Antispam-Message-Info:
	5AG2pSSmZs06iMEKCzftB0N2Ux3TpgZZFK8SLidfaUBOXKpziz7E/Z8GHGc4akM8vitPgDRh0OlpoubW20qtbCztDT8dwEHGOfpUzrwOdhdViAq6rZsqzcdx71SxHgSiOgv6imFg4pvtVD2Ko5xvXjrGNBgO8uFqf4Hf2DcZwfnmnM8KV3jMfSK1jmuRuYNIOyhXffVuoZC0NYilscjeFOnYyF9XCu8bs0ohmsrelTLc2e5uH0zG/yBkN0XxizgJp2u/zjdrSD6z1+Uu4ToJ/Hi4wPtUmVt5Vrr1K+LjC1IuhmQq11eX5sM56cFocJH9GOiqePq1EViAK413PB94fjAB5J1qxtxDV6MlYSzFXjTLQsPSGxccptZrhLK3Xy43ct4eCs4XmQhMKlRL7u2fVLF5UwZ2WLNBx8ctDMcgBabZ7mRBPsIhHdYz6TYhqI8yCY0uIuq2QchZQrbKS4BSVMqE+kBPNa9EJuY2RJJzbtTRfwMg6fduUt6w7rSbQCCVWiyj5h39yis8V3YjMA9o9H/Sev0mzFL/QdNaMNEL/4vhK2VuZ62yruqdue5bfzHsVBadbYUDgUsGqyhjkZpjTs+AQ+6HVjMlHnVzABF0KwPMxFPePZoWba5Ub2IdVOKPAlcPqkEvgL8nMqHNxojgC0A0R9JCZwM0L2hiEQrGFhxrWfrMThPOnalNJ/Q0xTbf1kMeVMR0IhDdrhTPCX9EmcbRlaN83gttQN7WXri5ZNg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS1PR04MB9358.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(19092799006)(23010399003)(10067099003)(11063799006)(56012099006)(261028144727099003)(261022105027099003)(261026140227099003)(261026121527099003)(261021123027099003)(261021121427099003)(261102123227099003)(18002099003)(22082099003)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VTJQUVcvd29RbGswSUs5OE5lcFhobWUrajlaLzU1VFFTWGtzRGprczEwWm9z?=
 =?utf-8?B?eVNueXRxVGpWdXVLVjBhWE1TRFJYb0JaTzVCSEV4UFZrM1FRRHpTZllHSXA2?=
 =?utf-8?B?SGhDMytERDlUSFp3bkpxWkRXcFQ4THdwRGtYbFVIRWR4Z1JhWkh5ajU4ZTdL?=
 =?utf-8?B?SHc2ZldPUnJaaHpJTU5VSWpGcmpJS1pmRWw0VXE1VFVhbFA0b1AwdkJzbEUz?=
 =?utf-8?B?b2FaTGxuL1MrOHpXcHd2bldnV1lUNXRHT2tZNEx6Y2tjV1pUT0FQZFhDRmJM?=
 =?utf-8?B?VTJLM2J3Um5PUHk4MVVLQytESmZSZ3BhWTMwaXU1MTdSUkhqT3RRYWJETnlQ?=
 =?utf-8?B?bmJyT2ZlckhZYm82OXVETHRNMlI3WElOcXl6R0VJcDloNW1nQ29rY0EyV0ZS?=
 =?utf-8?B?OThzOWN1T0Q4TXVIZzlHS2tiMGtuOVlxNTBjNWo3MFhVWGh1cFZlQ1BkaHZK?=
 =?utf-8?B?ZG84K1JCU3ZuLzluRlovUC94NjJVaGEzZUZUbldxVlBIZFhTeVdoWXhNUUp2?=
 =?utf-8?B?dEpzMzJoUmlJSGZOZkVmNkdWd3FXS3VQamVJRlpwL0V6Y0VMS0lodFMzenBr?=
 =?utf-8?B?WkVMcHdqNTJ2QWxNMytOTTlqMzRqS2MwUmNib1AvRm9JK29rWGp1MkRnck94?=
 =?utf-8?B?QWZrZlNVek9aeDY5am14S2U5VXRRM0Npb29NNTRwVW1vS01BWTNjVXJIazdm?=
 =?utf-8?B?TU8zTXp2T3lPQytuK29waG42am5NNldveEpUcjUxak5XYVAza1FNdDdycDRv?=
 =?utf-8?B?bXdUSmZnbDNtNm9waWI2THQyeTJrTldVMUcvbXRtRmwwMmsrQk5tNkw4d09U?=
 =?utf-8?B?RVRPVmlTZUp4Umtvd3hwZzZXS2VHSlc3KzI1TFBvcGt5SUJmTkJFOGRycnlv?=
 =?utf-8?B?K08xSUxtTWVHckhJdVVzV1BqUW02cnc5QmF5ZzdGV2tLVk9zQ21HYXJXanhz?=
 =?utf-8?B?VUljdmFqdWE1K0F4blhUK1c5Sm95RjBpNDVnVE5ISmcvZDZQWVpwRE1jeHZj?=
 =?utf-8?B?T1BCbU9HYnlnV1JDQ3FtY0IzdHRtL2R0MVhzS1JJbmltb2l1ZmlRMTZOUTVD?=
 =?utf-8?B?MDhaVTkxUktvUnltK0tRZTdTQmlNbjZKMEttTTlFT0s4QXJ3ZnFlRFh3VXVn?=
 =?utf-8?B?aVpWQVpXQmJkSndrUFJRUXh1cmx3dTl0dTBZRXcyWmVwWVljVDFRaFViU3NS?=
 =?utf-8?B?bGF4K2RkQzEyWXREYTVoNXNHM3lUT3libkRWaTVZZCtJdDh5VG9uL29JakVi?=
 =?utf-8?B?T2lwOTF5M2tSaGhhSzZmNzJ0RGwrajRlaFc5aVQrVStON21EeFNkLzQ3ZmFs?=
 =?utf-8?B?K1ZmQ0p5dnhqNFNQVlJNM2JXYUhaTFFFUlgwdHNOYkhxZmdsOHMremcrckZK?=
 =?utf-8?B?a2pYYU4zREs1aHk1Z0NxWGVpK3QweVMrakw4V04zbWNHRVIvUVlTN3l0Ty9M?=
 =?utf-8?B?N0FYcXp1Nm1KZ2ZxY2xhTXE2anV5TzNhZzYyZk9KWjhxZzN3RDNlVXE0MjF2?=
 =?utf-8?B?WThBZzlKVlpyV2s0dU5VekpjZFFleDl1TmlIc0tDa28wREF4WU50N2k1TVFU?=
 =?utf-8?B?aHVuUlpPZENDZUZ3MTMyUEhwSk0rR05BbXZMUGJLMlR2TzZ1NkxCaFJrQzVZ?=
 =?utf-8?B?RmtwWHVVRkJSd0ZBaUtWSkNlZmVDZERKKzFoT29iQjFDTCtRMDZ1ZHFYaS8r?=
 =?utf-8?B?dXVWTmhMWGg4dWg1WjNhNnhZRjFCTmFlL2tDZmt0QldzU0ptRXovdC85aXcv?=
 =?utf-8?B?QnFvaWRweVNMWmErOE0yOWI5T1R5MTlQRlVFbzJqYWFBbGluTTUrZlExRHl6?=
 =?utf-8?B?U3JZeFJoS0xONlpicXhqL1ByRW1jbUNxOEZtcm1jbVNWWWEydS8rZUVaZmUv?=
 =?utf-8?B?dy9iYTRmeEtnZC9HaHBEdmlhVjRoZVoxMjFrVkVqYVQ0RVd0SUVpem9KS1RZ?=
 =?utf-8?B?eElyS0dzbTNKZFFxNE9OK1RQb1dhMmlzYzJHQUJ5cW05QVYvbUxPZmRzK1Az?=
 =?utf-8?B?eVA0R25oUEgrT1U2dHRVZXlWUHZLSXRSbnNLbW8zK3hrTmMrUTRFeFF4TUJL?=
 =?utf-8?B?QnNKMHFmTWUrRXpkRUtyRW0vR1FteEE4UWNhcG9tQThnRHMrQ0hhUE5pWFF4?=
 =?utf-8?B?T285aHNBMDV4NE5maTFiTmdsdUxzMzZuZ2RXZlNmTkE4ajJJNVVqenowS2Yx?=
 =?utf-8?B?T3VXbEFxVEdOMHNhU04vaGdaaENaSllIeFYvekN5NGFiRmFDUUlhU0Y2eUpR?=
 =?utf-8?B?amJFMUc1bFhWRUtLay8yOVovRmFiOXFVL2EyQnVQR1R3THVYcHJPV1ZiZ3N5?=
 =?utf-8?B?bVFRZnpucTFxT0pRVHFBRVdHZVk2emtRcGdBZVBOcVpCUUUrVEpiUTdKM0c5?=
 =?utf-8?Q?mxKKZ4FFQ4nkTESEdXZXZpkCQOgdrDYHE+cFEOfr50qGW?=
X-MS-Exchange-AntiSpam-MessageData-1: rYBHaAoUYsaulw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09843eb6-b45f-4435-02ca-08df40a5c49f
X-MS-Exchange-CrossTenant-AuthSource: AS1PR04MB9358.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 10:14:42.8249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2s0Zm7DaCVr220cRqhMtkcjcl8oljZHxP3HOgzdGnBZhRDujS6juQb2O1RfWv88YWmRMVu35Vxl+N5hYXXVW7TYs6cSsX9aWInJFoJJ7gxx84RjqlUFtx7C/X9IuzUZz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MMZPR04MB387749

On Mon, Nov 09, 2026 at 12:42:54AM +0100, Vincent Jardin wrote:
> The gcm and skcipher shared descriptors were built with HDR_SHARE_SERIAL,
> so the SEC runs the jobs of one key one after the other:
> it leads to about 4 Gbps per key on LX2160A, whatever the number of
> CPUs or queues. No hardware reason for this code has been found.
>
> From benchmarks, when built with HDR_SHARE_NEVER, the performance
> is much better and scales: for instance with one CPU, AES-128-GCM,
> the gains are:
>   - 325 -> 592 MB/s at 1420 B
>   - 498 -> 6283 MB/s at 16 KiB

Hi Vincent,

Thanks for the patch and the numbers. They are LX2160A only, but this
change affects every CAAM user, and most CAAM instances look very
different from LX2160A.

Some CAAM-based SoCs have a single DECO, and others only 2-3.
On a single-DECO CAAM, SERIAL sharing is the best case: consecutive
same-key jobs self-share in the one DECO and keep the class 1/2 keys
(and context, with SC). NEVER cannot add any parallelism
there. It only adds a shared descriptor refetch, a key reload, and the
AES decrypt-key derivation again. So I would expect a small regression on
those parts, worst for small packets.

So this needs to be tested on other platforms before it can go in.
If you have numbers on other SoCs with fewer DECOs, that would be
helpful. We can also run it on i.MX boards on our side, if you don't
have access to other boards.

If the regression shows up, one option is to pick the share mode at
probe time from CHA_NUM_MS[DECO_NUM]: NEVER only when there is more than
one DECO, SERIAL otherwise.

On the commit message: "No hardware reason for this code has been
found" is not quite right. SERIAL is a deliberate key-reuse trade-off
that suits few-DECO parts. Please reword the log so it describes a
trade-off.

> -	init_sh_desc(desc, HDR_SHARE_SERIAL);
> +	init_sh_desc(desc, HDR_SHARE_NEVER);

Do you have similar numbers for authenc and xts, since they use the
same kind of descriptors?

> -	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
> +	init_sh_desc(desc, HDR_SHARE_NEVER | HDR_SAVECTX);
>  	/* Skip if already shared */
>  	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
>  				   JUMP_COND_SHRD);

With NEVER, the JUMP_COND_SHRD key-skip and HDR_SAVECTX become dead
code (as the bot noted).

Thanks,
Sahil
