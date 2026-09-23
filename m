Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010034.outbound.protection.outlook.com [52.101.84.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510084EDCCF;
	Wed, 23 Sep 2026 16:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180387; cv=fail; b=TW5ReHZWzbZsovQolsziih7mMQbeUlmul2300UaQnOCZ/dXmSf2hlEZpUEA8FWgpyqcAjXU1lJ6yVDumoZM7+VROg2v9lXreIeZycu9SQF/0HvfNy7rKOvkxM0J4AGyEYQQUBA3pJcmQlLU8yu+juYEO+17Ff1dmlJhatpD/h+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180387; c=relaxed/simple;
	bh=9e2UdO9YDMZNtydoI6l60HjblnIpj0ruLZz//kgWc8g=;
	h=From:Subject:Date:Message-Id:Content-Type:To:Cc:MIME-Version; b=ZfDbWscPVAl3feXU6chsAwl8E9bKEgyyXtO0aIEie/iYbq86T5Mkwirmu3qOyy/iThM5eMqti/CaWTKtb2h4kMXDKkiALmdoymsREHQq4UUxSP1hMciw4ZLNdm8JGYBqftPWQNxke7htkqylClvt4WEXQlYgazZAnHjZ5BnBkWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=bAoqsG0G; arc=fail smtp.client-ip=52.101.84.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="bAoqsG0G"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mtx8+x/mdBZ0dXXEqxPqilMckhSSJowxVDlGcyjvPxR8x+LIxr3uxddt243q44LTOv1RtEYRAZZhUgnVWNOl3Kcezj+KwsyDdeIHch7CdyFTSJ6Q6ctilCjERefoeZdkvFuPdKWGmh/jA6qsxC9fU/5FrLUmYEBA0twPvKYJ0V/yQtA2jt2H0/3VwrmmnofC4K9E/4zx4e6gDQPBsGykncvb45i0kyfi10DSqT2CPQDmpX5iM7M+s3x85SG5Rgij/rkep6nobdC+ondI7MarRwqWtzSmavLLlcThp6uKeOHQbexK622YfLGxkDivLQ8TYn3JudZz5QwdHGDeVnMqqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXwuZ97zZiDsb4tSWoUmX0C3BVZjOt5BTF2ic4tw2RI=;
 b=jfOQjX0dr/6zEAGXAq+CgwwGpnXs2q9NUoAmiigHXYb8ZaDtH05SddMxvy9zQBUNYomN8aA9wOBBSLStY6hAC6rl3Oz8OM/deovLMeUHYzT6AmcbzmnqSOYygATfmxO3f1oNsji57+pRMxzprqeGBHqcXFAPUVEbsM9aNf9yRMcnDQ5xqkp8T7esaP154A0oXmSNck6/jtBJsfYIQq91dh37smLh3jEio+i/9c/Iebfg+g38ogo0svm+qWPdPRATby/1IIQmCcuqP7iPN1iv6YW/KYCfGTMyV4U9GZdy77RFfXB5ILeKWZeuOtixKiTV8gwbD55LSx6YbzTwt07HwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXwuZ97zZiDsb4tSWoUmX0C3BVZjOt5BTF2ic4tw2RI=;
 b=bAoqsG0GE+c5TuQ49WedpNofNlb/lehacnCvlJgz6uzKW0RXhvjGDQ9v0I59riK/Gzw2Swub4pAE6YbGZnvKhHpbNQ6FxyQPUPzn8ryAxlnER4edEBBvJL4EyDUu0pQ4kb5YBgMBfTEBW4so/BjlSiMtvCI6KIqubPiIMJRQg+WsS5HfyLdru/SZtkEbphd2ahS4vmOJLE/WCuVX24aSW7JaA/saMtVonOLHHqRCgLDj3s+VSY9wYt+2DKjTFswyDGDha7yuEkmqIeSXRhAKWsGaGA3gDJ6+gcovWbxzFQ8NqHG+AxsfgsskqFgMgRKKmedbLaB+LKvuXu7qk3Nl4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by MIWPR04MB961718.eurprd04.prod.outlook.com (2603:10a6:290:e4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Wed, 23 Sep
 2026 16:19:41 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Wed, 23 Sep 2026
 16:19:41 +0000
From: Frank.Li@oss.nxp.com
Subject: [PATCH v2 00/12] dmaengine: Add dmaengine API to avoid call DMA
 Engine callback directly
Date: Wed, 23 Sep 2026 12:19:29 -0400
Message-Id: <20260923-dmaengine_prep_dma_pq-v2-0-32ed65b8a9b4@nxp.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABH8s2oC/4WNUQ6CMBBEr0L22xpaEYUv72EIKXSFNaGtLRIM4
 e4ueAA/X+bNzAIRA2GEMlkg4ESRnGVQhwTaXtsOBRlmUKnK00JJYQaNtiOLtQ/oa8bav8QFG11
 IzQoa4C5nD5r33Xv14/huntiO29hm9BRHFz778SQ379/HJEUqinN+QpNlV1ZvdvbH1g1Qrev6B
 RweFQzKAAAA
X-Change-ID: 20260921-dmaengine_prep_dma_pq-7eba91a609ed
To: Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Dan Williams <djbw@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Jon Mason <jdmason@kudzu.us>, 
 Dave Jiang <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>, ntb@lists.linux.dev
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790180375; l=2951;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=9e2UdO9YDMZNtydoI6l60HjblnIpj0ruLZz//kgWc8g=;
 b=/qlpmkDShDvpXNRrdtePQ86nHLdinyBM1m5ychgXn7ubDkUwZgjp9LiVKpolLiFHsFq6w7vDc
 uobCjwA0TZuCLAqGTavNpMu0STuiqZmUfgfHGFuP4CzaECXAb7LVIq6
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: CY5PR17CA0053.namprd17.prod.outlook.com
 (2603:10b6:930:12::24) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|MIWPR04MB961718:EE_
X-MS-Office365-Filtering-Correlation-Id: e90dc688-2e48-45fa-f31c-08df198e7891
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|19092799006|1800799024|6133799003|11063799006|10067099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	NdURnUzUwtCxgFdpxetAdarj0z4m6mQo9LxSgE0v7NatEc+VwkUADvgnyti4kxYSkI9x4MpVmcxrIJxz1HbWEfhe05ojPhwip80mOj/5T/daOcMNSogpXJpL5fdn2/B8mircVV4Xt+xsWtt1FYDHkZdNWucj8ZLGL8ZcKl6OYdrpWi65adc6uvyJjOd1GBb/DdnIn07XF5V3Ei+FIBL/5SxuQYmDc6JZHdv4ObnoKBzk1MKAR05EJROHFvfc8IuaI72bXqYvwtH9/K/Ap77sQszynIHQEDXuvaGjmr/kkafMfm7YO/zk295yMN1dxZR4rVB5508ZShFahDX/TrPoiJLmZOKHtjxDOIbUhlqNqFVUN8xz2XaUnAUaFjY5WvgGuJhdNJLJh3n3Zx/E9eYvYiUde9Z6y/J7OmdMpgtWmQ1lWfSjov368Vv4oE3fopY4zf2IzlbncMERBT3mUbNE/w/SRWpjl2ApMSKtN5QnR/jiSiTrLosQV/G75J8HJvEvRLU0of//u1C6j+5lp/77UTUt0nCMcYqfE+VOYSnDEVAZ8MGwLD03kqfS1CzBoyd2qX2HCQHsvt0/Df/joBmZr4/WSBDiJDBuSfmSfXpbdFk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(19092799006)(1800799024)(6133799003)(11063799006)(10067099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHRpSGJINHpWMmVoakpPY25YU1lpU0NGb0ptNXo0ZWU0YUVPTEFJTCtGaEFu?=
 =?utf-8?B?RFYrV0dWNitlNTNReWdmNlI5T0l4bjQxSnNiWmxHak5KRE43L25wWFV5blJ3?=
 =?utf-8?B?QnZmenRpQmlOSWNJRTJKTXlDMVNEQmlhdVZnbWg5M3RMQ3psd2dqQ0ZWNkND?=
 =?utf-8?B?L0dpSU5mSmFPVnpFOWxybmRwbHpoejdRMXlTMVp2aU4yNE5oaGZ5UmprbndX?=
 =?utf-8?B?em9QZmtzd1lsZ2xUb1VXSUhFbzlIMWlxbkVXT1djQXM2Q0d2cTRqb0piRTVq?=
 =?utf-8?B?dm1hWDZ0djZselhSVEVqNkNwRFI2cG5HNTJndHEyMnpoNS9BQmR4bnNkenFX?=
 =?utf-8?B?dDhwRlZrdXFnYjFkS0pvRm94TWJDeE5KOXQwYzJDeGtBbktjaFFnZ2JEZkhk?=
 =?utf-8?B?UWwzcWtNK29Rb09EdXdxemttVHY3VDlUcEVlL21jclVRV2o3bkxLTVpyTVlj?=
 =?utf-8?B?MnMwbHF3a2FLU2JKdm1FcXhWMW5BQTMwbFRGM0wrMmRZYTcxR2M2TFdEYjU1?=
 =?utf-8?B?NVVaL2FGejUzUExpekU4Snk5MUQ1YzV1MTNaRFFIYmRKVmxDUlBwQ0l0aHNK?=
 =?utf-8?B?UU12NWhMNUdJUWNBZW5VS0dHRkdlWHBYRFBySE4zakZMb0hnbUJMV0tJVEJR?=
 =?utf-8?B?N0dHbElONUF2a2JsUlpyT2trM1ZpdU8xS2VFM1NGbWxEVmN3aGJpRVJ6NmEw?=
 =?utf-8?B?SEJiQmNYSFRJMGxsTUlIS3BhUzBXSUhpTW9mQjFhQ2F1Ty9hV2dBaDZ2eHEx?=
 =?utf-8?B?Tkk2cGhXQ1RmalZxVE4vY0pzbVFncEljaXhlWHBQdWFCRlk0dGU2QmpURldV?=
 =?utf-8?B?TElQU29QNCtHdnJlZzhvK3VTRHk4ekJlZTNWSTNOT0xNY1NtTVlVNlpxakpS?=
 =?utf-8?B?eUM4ei9VK2lSZC9SQUozMktFY3I4VHdkZnhIRUlnMFlTWjNXMXlZYmVHdGxj?=
 =?utf-8?B?MG05MlBEdkpZSm56OEFrNDVLRk9NODIzRzFrNm5jQk8yU3g1TGhCT2VST0ty?=
 =?utf-8?B?YkhJL2trZEl2RlQzVjFTZUVSaVNHYjZubHRNaGZsbXlsUUZwd0FKb3d1OVZ5?=
 =?utf-8?B?ajNuZnp6eStLOEorVWtCcEloL1gxdTV1c3ZMNXpueERMNFFQdUlZc0JvMVMx?=
 =?utf-8?B?dWJETFNVdTFmZ0xkSE9VcWVRc1lIaHZlT0tPQk9mSExrOHlxYlRoZ05GVnhN?=
 =?utf-8?B?anltcmhiV1dQSFdsUFhhakxEVXZzTDhEYk5CUVVtSkovSnRjUkxUcjAwOUFp?=
 =?utf-8?B?TFFST3lNVFRPb1h0RWJ1M1lHOUhtS3BUQ3J1OFgwNHJZbDlYSHdPZFpsQm5F?=
 =?utf-8?B?eEFMc3d1TmI1Q2c1VytLV1dXTjZweEI5WmJidzJtZW85S1pCSElBZXUxc3Qw?=
 =?utf-8?B?OGFodmF1MU45U25PV21HUytkRE5Ta1A2NG1HMlBIcUt5TUxQWW0rNUdyQ05H?=
 =?utf-8?B?RzNVZUxEd1hmbjFCaEIyVTJ3azlQVTltbGE0ZGtDbE5TVEE0cWx6SEsvUkpT?=
 =?utf-8?B?SjZuWDVEdy9SSTVkWjhRTngvTVhQelQ1RW1NS2JKTGF5cDl4bE1BN2VyUDNw?=
 =?utf-8?B?L2p0OG9aeXo5a0VCVmhLeVNhMi9RSC9WSlowanZIVlN3L3pMVWFrbHB4dHdv?=
 =?utf-8?B?cTJCNnhhSEw2UzhKcWVmeWN3dTFhV1VDOWhzMG1DZHRtSUFTenN5MWg3Tm1o?=
 =?utf-8?B?R3FhWWU2L3ZoZFN5bXlJVHZiR2xFMHgxMWdpM0thWW1tZUNsQlJBN2hDZHhz?=
 =?utf-8?B?bUpaTlliRTQxN1JZcTZwdDUybHVueGFHOEgrVEx2NnluSExITVpFMlZXUEhq?=
 =?utf-8?B?dXI2UW5PeS9EcUg5aTZITjJxZVVxZHNsRm5RN3NtZTNaWXFXa3J2L3hXODNn?=
 =?utf-8?B?VFdaV3U0cWV5aFU3bnh4SWhlZ09yTi9ST3JhMUJjZE5xbndNaHEyblpQUDBh?=
 =?utf-8?B?WXViSE9qRDBrZjZlcXl2OXhpK0RNL1F2VkFvdHU3bHlvZDI5NXNoQmZsTHM5?=
 =?utf-8?B?blh6TmhJaUZvYzQ5WnVmajFlZXB1MFlyeWlIbXpYWEJpOHFmS2Y1cFJmU2Fs?=
 =?utf-8?B?ejBCb0hpMEhEK0hNdStncWxJWUlVaXNjRm51QUR5MytaV0ZQVkozdGZhTGx0?=
 =?utf-8?B?TmZ3OWdHT0R1L094Tlh2UWRqclRVRERVRWJ3S2dicUk5OXVxcnlyQ2lVZllp?=
 =?utf-8?B?OXkrWXhIMlNzMHo3Zkd1UHFuVFhXS2RWSHg5V0drQTRPNEllS0NxTkZGSFpS?=
 =?utf-8?B?QXYrcUNuUTE2UzZKbVU4TERpTjZNQXMxUDRHaEZMQUE2Ny9pU21rekdLZ3Aw?=
 =?utf-8?B?ZHVFOXU2RWl1cGhTYXc1QUJKN1hiSGxMQmJidmpRUFd2R1A2VnBZTkFzVFg4?=
 =?utf-8?Q?y1MPyGzouuTCXitnZE4eqXALr6CddZ5dpsTbI?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e90dc688-2e48-45fa-f31c-08df198e7891
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 16:19:41.1677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0iLxK4joRckSRQIUexh/riISX/CZWaV7Xz9hcVLkgkYBAzTnlcpX0nZVeJ9OMztJ/+Q2vb/UJKS4VXhJj9rVZ5PBLIUpZtaeENrDcPHB1nodErfDfvUdxsqNfO+x5RTD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MIWPR04MB961718

Add dmaengine APIs to avoid call DMA Engine callback directly. Prepare to
make dmaengine provider private.

Fix all under crypto/async_tx

Build pass under crypto/async_tx after change dma_device *device to _device.
to make sure all code use dmaengine APIs.

Assisted-by: LLM
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
Changes in v2:
- Add more patch to cleanup crypto/async_tx
- collect https://lore.kernel.org/imx/b40fa0d7-fbd0-4ee8-b99c-781d08c18838@intel.com/T/#t
- first two patches can be applied without added new dmaengine apis.
- Link to v1: https://patch.msgid.link/20260921-dmaengine_prep_dma_pq-v1-0-9563ed448260@nxp.com

To: Dan Williams <djbw@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>
To: Vinod Koul <vkoul@kernel.org>
To: Frank Li <Frank.Li@kernel.org>
To: Jon Mason <jdmason@kudzu.us>
To: Dave Jiang <dave.jiang@intel.com>
To: Allen Hubbe <allenbh@gmail.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: dmaengine@vger.kernel.org
Cc: ntb@lists.linux.dev
dmaengine: change dmaengine_get_unmap_data() first arg to dma_chan into this series

---
Frank Li (12):
      async_tx: replace direct ->device_prep*() calls with standard DMA engine API
      async_tx: use dmaengine_get_dma_device() instead of chan->device->dev
      dmaengine: add dmaengine_prep_dma_(pq|pq_val|interrupt|xor)() API
      dmaengine: add dmaengine_is_*_aligned() helpers for DMA consumers
      dmaengine: add dmaengine_get_copy_align() and related alignment getter helpers
      dmaengine: add dmaengine_get_cap_mask() and dmaengine_has_cap() helpers
      dmaengine: add dmaengine_get_max_xor() helper
      dmaengine: change dmaengine_get_unmap_data() first arg to dma_chan
      dmaengine: replace dma_maxqp() with dmaengine_maxpq() taking struct dma_chan *
      async_tx: use dmaengine_prep_dma_(pq|pq_val|interrupt|xor) instead of direct callback
      async_tx: convert to dmaengine_is_*_aligned() helpers
      async_tx: replace open-coded cap_mask accesses with dmaengine_has_cap()

 crypto/async_tx/async_memcpy.c      |  18 +--
 crypto/async_tx/async_pq.c          |  60 ++++----
 crypto/async_tx/async_raid6_recov.c |  22 ++-
 crypto/async_tx/async_tx.c          |  19 +--
 crypto/async_tx/async_xor.c         |  58 ++++---
 drivers/dma/dmaengine.c             |   4 +-
 drivers/dma/dmatest.c               |   4 +-
 drivers/dma/mv_xor.c                |   4 +-
 drivers/ntb/ntb_transport.c         |   4 +-
 drivers/ntb/test/ntb_perf.c         |   2 +-
 include/linux/async_tx.h            |   8 +-
 include/linux/dmaengine.h           | 296 +++++++++++++++++++++++++++++++++++-
 12 files changed, 383 insertions(+), 116 deletions(-)
---
base-commit: 5c4d4169604b335c38bbc79bc1fc03042981fc6f
change-id: 20260921-dmaengine_prep_dma_pq-7eba91a609ed

Best regards,
--  
Frank Li <Frank.Li@nxp.com>

