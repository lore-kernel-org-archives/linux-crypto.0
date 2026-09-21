Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011021.outbound.protection.outlook.com [52.101.70.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38503F39D1;
	Mon, 21 Sep 2026 23:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790032162; cv=fail; b=aOyR+gSKZuzirvbZsT5RisNIbQFC0Xzwg2QxLUl/t3uIw8ZbgTjAJOu+H9T15Zv3h6USSvT3RHP97yiQKbUzVr74eX2IKp2/rM3B2s0QRS4hwOo1BnIkaAsnDho0BLlhOf0+XwTi/a/U3A9h+65G+zdfsLl1w3AKmljjjqyG+Gg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790032162; c=relaxed/simple;
	bh=ucoSkZguwXHGfuw7fJUR0KRmu3Ep5Ve+lN2KgHoF1+Q=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=JvEgDB4uBVYOfyADbYev/33ZKeOGorwGf4Zj+GJydSdL8UiqeZdHHMoFyGImglNkwuQp+EpfrcVSDMdK3CvZObnzX4THvedFQJdTc2/A3P3wamRbKAcVshO7s3tif34NkZ8ensFyOroSohawe15tf49fZGI5l8v7GCXf+1ZkRj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=xkqI0Cp/; arc=fail smtp.client-ip=52.101.70.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="xkqI0Cp/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j5mGJT3ArbtugVtHecBgiu0+LMm55li/tkXkAp1vJ3NxCAoXM2dtwBvQAzMJKQFXYryFU6+h1fzF3p4+0Q32HVYVV8UcW8FxovRqmWXP8a87UzQgRv3osRvWRdqLecJyX0lteC0M1U2FdM7j2hp+lXOcF662rqXs6ed5fiR3Eu60rP86DN4Qu/w/xT62PewmXM0yL/Rx/k6znjii7Dfmz36FPucRSfFGCluoXZuDn9w3RWAS57POYjCeVRWk0Vzf5PZwkR6q0XafofHWHd//74ErhWE3sFu8FNvhiz/zE8AKVU1NFG3LPsoEKBGQNJ3p2AI1gD9K9D2VYlBVn8/+Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YiTnVLWtdMgphFfBE6xtUmgRrUzcZc/zArVeaTb5CX8=;
 b=AAxD5lWi3Hvfca5lJgZGASAmO4SbryMR4O+pwco67ze9cCFdj+5yHlXDBudQNJLvO5xY6yEUVatwegUkHcVNqVL/gYhXrDNJJlrZpLWRdBDCk9Ha+JED+Hid3bBi48yh7OT1xi1wUmYYlSsvuT4816QddazUUTvylu36eB3jzqOjMtXg4RfZkys24xHysJMCySuTDmZijRY/j+Z0hCtlDsregV4xr2CwYq6l8XOngIidnbn9/C+GktRfyryDK5V3ssJByDAjyNhf+iGrY07oSu1AC6UBKnmWZlbLtX7sCN+PAn0vfjzLJgLUZCdrHciI04v2BGecDn4Css22pIIjvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YiTnVLWtdMgphFfBE6xtUmgRrUzcZc/zArVeaTb5CX8=;
 b=xkqI0Cp/xAsCHT6JtsN1mXL2UZvGaQv1oPjkELZsuyD99gnjSR4I0xZ40Abxm2SAFpOs3N7BWv6iXxTE407QALV0YTyzSPZ5PHUBATM98crlg6bHnV+WioqRWHP69fh0Zv67UVb4CX92WCXKeGayR1YlyGE9uOBHKA4rc+5ah4mY6BYH03QGTletogFVbogD5JEGTUFRRipUKQVAkNgofjwOENRaakg40BGUBI3XnR/U3ILedt0+Rqy0tcXTMPZwEwN6Y+5uZmcrkcGSt4hXI3uJhNR7dT7pjgJGLUx0bZ/Kvh6R4LOwSl3GUwMPnX5ERGBXWjC2g4arX2CueVMDwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DBAPR04MB7352.eurprd04.prod.outlook.com (2603:10a6:10:1a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 23:09:18 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 23:09:18 +0000
From: Frank.Li@oss.nxp.com
Date: Mon, 21 Sep 2026 19:09:03 -0400
Subject: [PATCH 1/3] dmaengine: add dmaengine_prep_dma_pq(_val)() API
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dmaengine_prep_dma_pq-v1-1-9563ed448260@nxp.com>
References: <20260921-dmaengine_prep_dma_pq-v1-0-9563ed448260@nxp.com>
In-Reply-To: <20260921-dmaengine_prep_dma_pq-v1-0-9563ed448260@nxp.com>
To: Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Dan Williams <djbw@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790032148; l=1910;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=Ci0MYII5+LQU3gHwG1PPZkl/l5bN5Jf0GdmgWRglIps=;
 b=0HT5p9Prq03CRLR4UDYfEnQQ+IsTSC2xCLQXQBHXffptvbR9NKxXbKGPH6gVkLohfhEMc5Ml7
 hMxXn1/BxHSDR9mpBV794xnZBaRsvWkvG/yPXo4KAAC+He/r2CivVQD
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: CY5PR14CA0015.namprd14.prod.outlook.com
 (2603:10b6:930:2::21) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DBAPR04MB7352:EE_
X-MS-Office365-Filtering-Correlation-Id: c6fcd57f-bd73-4399-572e-08df18355cd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|19092799006|23010399003|376014|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	mSE7wh4alhQj7VHJbxVJMuBQ+psm6TzFmU00PsavcVWmt4plsnB46B5OC3SV5DsBXatRoCUw1A/j2UROXXPqC20BskucUUa+U/psKsuhhGAp+4BKDZJnSWtbd7hfhhTpi5Ckw8OMhi2jvGYORAXO3qWUDy4kF2wGwpZdjeZbXeZIAWncGwo9Wgljfr34fdlxpJMh3V+yBqYg0wzc0XTHDEd/2PKnIR+LIlTuXdg1XgFy8izCKuFYSJEVZoIioMUzqxk+vf6/jjo8IFek5itx1mJki9s3P0yKcrmWG6F+TOyjR9MvveAA/vs5W0WpwcoZH0dAu8n5CsymX6P8oGgCMXhioIGRz9aUNXr5YEReyDsF6nRnfWfVmaWNMlKEIMwWmhYgSGO9cZj6FGQaWptH2D4uq0bKA9WQ6ubpFc9CYpjx5yo6Y8gmG6UTi781gENK+w8D9pEyF1WKTvkzJ0tykz6VVNEscy0B/o7dcdQaoG6M/omhGFlHfsc65t8D4oisuzwFRaFE6ikGb6u+BeSvGXCAx6vfWcb9dMJAIZ9DlkekH5byQt54L1hi5VrFv1z2IbFpUWb6Sh20LRIe6FigQC2XNEnOzfOtWxLfMAsCW9zqdlGD6f/R0iLfpsP56eD8M9fSIqCDu37F1Dx31AiyJAOtO5kM0Qd9ak6ysoRcyPw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(23010399003)(376014)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WGhqc1FUY2ZFajYrUTI4R2tVY1BnTWFKcUdvQnJRS05mRjhNbFU4R2Q1TGQ1?=
 =?utf-8?B?YkRWd2o0dStENEpGQ1dnQ2F3K1hsYVhraEJpaWVTQldzc3hlSzNPL3EzSkg0?=
 =?utf-8?B?eTFDMlNZdXdmdzdoRnQzSjV2UHlhazRUK3lkZWswK0N6VW5IMm5TRUJjVUV3?=
 =?utf-8?B?RU5yeUwweEtHOTVwWW9ZNndVQVZGZ0I0elB3VXZWOEcxejJBbWRFdnpYcnJ3?=
 =?utf-8?B?ZWtCdStCNVh5N2lKaXpieHhQcEtMQkQzOGs5eFFEcVlQY2ZOTGNYUXg4VXcx?=
 =?utf-8?B?Q2IwV0dGS2hBM3A1YXJnSnVZQThvRG9yWGtKcWxzOWFmMW1xRjBSM1VwSld1?=
 =?utf-8?B?a3RmMkNBZWVCRWxSeENKVlhCR3Eyd2ova3ZaVmtrbGE5cmw4cWVhQ1J0ZHVP?=
 =?utf-8?B?WCsyZTZYUGg2OGlYU0Ywcm12ZlBGdEpnTC83anU4RjFmQzhzVkRlWVczc2tT?=
 =?utf-8?B?L0dxME9VckJyelJGL041T2k2dklPUmgzQU5vcG52T2FYWm9KOE1yS2VwWFVt?=
 =?utf-8?B?c3BLQWwyRTI4ck1JaTRUeE5wSXZvSUxYYU5VOXdVMGMrcXFXTDZUUzhMNmI5?=
 =?utf-8?B?VUtnMWpYV3RKd0pGZ3FpZy9icWszL3hhOFo4T1BPSU1ZRjZPVi9vUkxSUTJG?=
 =?utf-8?B?UFVodS9GaDRmcjNvNjk3c0kyaUpteFpHOGtMbUxUOCtRVzQ5NGFFdDBpWE5l?=
 =?utf-8?B?amhsT2dYT3MxTmM0b3lKU2hhM1Zmb1hJOVdmcDNiUXR1N3dEZkxzSEJ1bHYz?=
 =?utf-8?B?ZE03ZlFDTERZR3hoTlFLM0l2WnRIcThOM0JMUTl0K2hvNVJZVGhvRUpIUFlX?=
 =?utf-8?B?cXNhQ0hwNmVNTEFTUElzWjltemYrQjVlelV2M2N5OXZtQVZVNmp0cnFsQngw?=
 =?utf-8?B?blF6UUV0dDI3L3FXdnFqSk1VWDVMdzFwZUpnQmgyUzRYR3g5Q2Fhb00rWjVv?=
 =?utf-8?B?cy9RWlNXK0hEMkkzT090RkVBM29aQjY0dUJpUnhvVVk0NHJ1T3puNzE4UXBq?=
 =?utf-8?B?dmFCd2Z4U0NjZ2lXWElFSVpIMmZHajVZekxLWnRrUnpVdU4vNHdZN3hSeWFy?=
 =?utf-8?B?U1J3ZnBVUzNseTVqYi9UMm02YXpTeW5RS09mYTc5cGFnM1o2REdpdisxNXg2?=
 =?utf-8?B?UFpFbXB3UHZTamRkSXZRUkNycjI5TVpUVXNXWG9NSTZxcDZEWXU4Y0YxV0NY?=
 =?utf-8?B?OWdtRlozcHRRczViL1grWTRVWXBmQXl3djI2T2wxcGpQa1JTOWwzSFI1ZEI4?=
 =?utf-8?B?d1B6a1kyTEc4TUlicVdrYzhRVzVDMUF1b3gvYTBFdmNuOU14YWd4R3FodEtP?=
 =?utf-8?B?bms0S2NrT2RCRVZldS94NnRyMzZvSjRwUWZDU1ZwTDBndGZpOG00S29WeGlG?=
 =?utf-8?B?WVY3UW1zZ1pwT1MrTndtbnFzZkJiUS9WVnIwMlZ1ZHNoRjl5TGFWQyt4NkQy?=
 =?utf-8?B?YWxVNDJFZ2tRM1pMRElyNysxVStQS2ZWZHlEVDc5cVZOSTZCdmFudFhEbEZH?=
 =?utf-8?B?eUExNVFwMG9SSHdyQTlhZWxBZ3FaZ1hCVjRkQ0lTRWtiSDF4azZhaU4vK29E?=
 =?utf-8?B?S0dqTlFUQ1BEVFVLSFNhOUJWS1VwSW5XeHkrQlUzQ3BKOWxaMHA0cGRhNE5J?=
 =?utf-8?B?S28xSWdjVG5UREdBQ3R3dS9sWmJoSFJDN2tJbC9VMktqYkl6eTB0SE1JSFhy?=
 =?utf-8?B?czRmaTlWbU91MU5wQXRQQ000YTVFVGU3bTFEa1lpcUkxdUplUmdwNWFrVlpB?=
 =?utf-8?B?NG5JTjZqUGx3ang0dUFFMnBmVThtWEQzMTNxNTlTZ2N4MkdBNmxBT3RwdWxH?=
 =?utf-8?B?RGdSLzlvVW9jS2N0c2tWcWlVTi9lWWNzMWZLR1M5bURmMytPbFNDUVE0K3BR?=
 =?utf-8?B?M3R1bXZHSnhua3RDWTlsdUQvWjFCU0dEUWc5dFMzWDdjNWFhSXJaMnNqb3h5?=
 =?utf-8?B?bGZzT1RlcnhKbEdXNEhnMklEZWJQQk9Nc2hndEhLOHBUTnIyL1FxYzQ4Wmlz?=
 =?utf-8?B?VUVTR2hSN1RicWwxczlNcVA1bkhjRlM4aDZySVMrWG5OSUFoMmgwWStpeW1W?=
 =?utf-8?B?K1RyOG1WWjB1QmE5dThpWGRJTXNnVWkxTGFpOVRjQnNOQlBEcnRMblloSXpj?=
 =?utf-8?B?QXljVVg3VndEMGZjUSt4ZjNySlNqdFc0dDVKUWJOMk5Bbk1BaWwva0o2aTdt?=
 =?utf-8?B?WDRPMWVEUXNUMWFDaXZTekpXTUtGdnZENjBYVVYyc2phaDJtU0t0U2lUQkxW?=
 =?utf-8?B?OTJjUkdMamlMS01aeEtET2ZTVG5BeHREWFAzU2hmMWxnUitWWHlLdUtXYlMv?=
 =?utf-8?B?ZEFUNU5XVUtuZGdadVJuWFFwU0pQeG5zaVBFZDhmMXZ5M1dHOGtHSTNEWXla?=
 =?utf-8?Q?gdvfOodtYhpreAhbgbWKd7RaKsgTVR8qRiDYC?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6fcd57f-bd73-4399-572e-08df18355cd1
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 23:09:18.1022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xE8LNVEAGNy4azkIba0n4G/sfmPt0NRsG4f3LqMSE8fA1lj8JAQCPToZ8fXc6yBHhvKxuyw4Gmv7/tLGihrEDZSui7/uatyfmjZqcOMo6KC1gMoEZn9Vt/ygp9PYdNDp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7352

From: Frank Li <Frank.Li@nxp.com>

Add dmaengine_prep_dma_pq() and dmaengine_prep_dma_pq_val as an inline
wrapper around the device_prep_dma_pq() and device_prep_dma_pq_val()
callback, consistent with how other dmaengine prep helpers like
dmaengine_prep_dma_memcpy() are structured.

Provide a clean public API that hides the direct callback access and add
proper NULL-checks on chan, chan->device, and the callback pointer.

Assisted-by: LLM
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 include/linux/dmaengine.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index c3a49a33307c6..e3b5c23d7cb0d 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1232,6 +1232,31 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_memcpy(
 						    len, flags);
 }
 
+static inline struct dma_async_tx_descriptor *
+dmaengine_prep_dma_pq(struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
+		      unsigned int src_cnt, const unsigned char *scf,
+		      size_t len, unsigned long flags)
+{
+	if (!chan || !chan->device || !chan->device->device_prep_dma_pq)
+		return NULL;
+
+	return chan->device->device_prep_dma_pq(chan, dst, src,
+						src_cnt, scf, len, flags);
+}
+
+static inline struct dma_async_tx_descriptor *
+dmaengine_prep_dma_pq_val(struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
+			  unsigned int src_cnt, const unsigned char *scf,
+			  size_t len, enum sum_check_flags *pqres, unsigned long flags)
+{
+	if (!chan || !chan->device || !chan->device->device_prep_dma_pq_val)
+		return NULL;
+
+	return chan->device->device_prep_dma_pq_val(chan, pq, src,
+						    src_cnt, scf, len,
+						    pqres, flags);
+}
+
 static inline bool dmaengine_is_metadata_mode_supported(struct dma_chan *chan,
 		enum dma_desc_metadata_mode mode)
 {

-- 
2.43.0

