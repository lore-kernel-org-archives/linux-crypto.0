Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011060.outbound.protection.outlook.com [52.101.70.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57F94570C5;
	Mon,  5 Oct 2026 09:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193077; cv=fail; b=cZ9VUOeUfObxOv7YcW5zkxzyAWMVNMDmQalhAghN+fbYveIV7oyvalTJ0OEGQijtt+QHnGcK568ARrtIydjCo76uTOWi1agFohcc3dWCbbnySmbUwOMPZ4QMZgzbWEW3m2uUarWIsxWU+ugZHfjsFXR2bdGbcul62U/HnURFH1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193077; c=relaxed/simple;
	bh=XXDZa0fldTMEp8iAUiTVQReaO9dGN2dBP5eLRD3rdTY=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=Y+7enA9Lt+pKtdvDD1mzrf69FKkcQ6TIIcB4s2iyEjQkdXagroT08nRp/iyZE3iCygIZAFnClQlNunLaAYcLqb4+36jAyzgPN/AxLk2ZBo9rcDDtMfzTe65E/mn6kDQXU19z050+TnpSWuGvDcmIl39ipySW3h4BGF90jBeK4hk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=A/vtsIyp; arc=fail smtp.client-ip=52.101.70.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="A/vtsIyp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kHxqIDdmiK1BEskyOOKyri6VKpkTGQ6uuw75awr2cSKm60a7ebGHDab72+ULMtfBbI9/a8K1ecSU6eoJOq+zlCBdbdn4EpzGXu2bZbX42ThxdQw/s2CczgTA/XV5RT7IXijgyTqGG0YAGiiLOmGziGkM8KXr5ri+RaGhRh+xOg/FeBAUZ9Fr/gcl/+EW/KOBhvDrJh6h+xFuC6jF3h0DdPMq6nkWbrypLjtgZdaVkBqmWqYOMceYJkZNfIszhC+4HcekpU8Mpk3NCii4iJi51+gK2V4MwyCq+nD30o6XG9/zMz/HUgOEjgqBdaQnfM+Txt9rsDWPyVjyv40YTlcklw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BR469c5W90ajpdexETWSfN2htmkBoa6khGx4l5kN+D8=;
 b=s6wwpUrGmJrtC0CHsfC2faN2OPBuoD+eToPRdo/HFzB5j2zy3m9oE/pUUdB4QjT8hJ7KfkDV1ORGRCe0X+qToqyTn1F6K2CtzzwdV6M746XqDBMhXF6l/rsuaUUX9QUQ1+8lTTkB1FjMc5jZ4SuvobEpv7gSJ/iDoAOBqQ4MFmrglJN2OiuWKtaX99XRUhz9u3zkXGc+89+VTNLAIpqFC1RWwqZslBuQA4lv5cSAekLviproRi4ECXk3G2aAuL6vzXoBVqciDQjvJApgRIOXGC/PHvJk/7hhPwXwy8ds/a4b4mfpdGKm9OYk3JHlfqTepuf6BfpSuu0Y44S88Mcjeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BR469c5W90ajpdexETWSfN2htmkBoa6khGx4l5kN+D8=;
 b=A/vtsIypmi83vj+0eCA7pEpKj8WRA7wolpGKNsJVdwoezcV+4VUhqOtGLWgJhWr/AqiLbPJOy1VKl7HBQgmB0NpSGbbP2MRtQmOe1+x0BIah87QrK0fHTTY4gSR4szdKrGSe6pCdDEJ7PEIGHq8IDOdEbPhOdsvoorHqWC9mxFGYhKXKEK51IXAba94Mm0Rt3q2qtrdELSssdoL81lH/2WTufzOcu7L/xZgI0w3bHR7eFgH5fAcoRLsLYCoXNhHg3VqEHuIklhuNn3moPq53M9JmNKqkK3P7Nfcf3aSU4SJ363O8l+eb2fByH3zdEdlwHZh5gYKRU3Xe5g4ABYihGQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DB9PR04MB9913.eurprd04.prod.outlook.com (2603:10a6:10:4c4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Mon, 5 Oct
 2026 09:37:37 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 09:37:37 +0000
From: Frank.Li@oss.nxp.com
Date: Mon, 05 Oct 2026 05:37:14 -0400
Subject: [PATCH v3 1/5] dmaengine: add
 dmaengine_prep_dma_(pq|pq_val|interrupt|xor)() API
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-dmaengine_prep_dma_pq-v3-1-a4a241f26fa7@nxp.com>
References: <20261005-dmaengine_prep_dma_pq-v3-0-a4a241f26fa7@nxp.com>
In-Reply-To: <20261005-dmaengine_prep_dma_pq-v3-0-a4a241f26fa7@nxp.com>
To: Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791193046; l=6855;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=prNdM7OARrJ6YMH29f3XHgl7NJH+49TuwBrbB5M3cLs=;
 b=8dliin7ccZ+N4bjy3ZBEMKO30tOc8/IUJ+lS6dUsVpmZtQuttDPJPd3WrqHJRyZg6Yq7uJcVw
 hQwghSkReqgBltfP1jhKUOTfKkt1nbR1BawWx6HThmm2GErwVDRivxc
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH8PR02CA0031.namprd02.prod.outlook.com
 (2603:10b6:510:2da::7) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DB9PR04MB9913:EE_
X-MS-Office365-Filtering-Correlation-Id: 35472179-d92b-4cee-d7fc-08df22c44ab2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|23010399003|11063799006|56012099006|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	9AHoNguuivY2cAu7D6obMeBU/2+Ep9Vo2EYkP7hLhXo433441zr2vZ4kzvDRwafTEOyrBPOBM1X1HbW1uKqCWxCAk8fWEjPiGamgsJdVOudlQeB6b5F+YkWlQzJKFnujJ1jXhDyeB7mqhXaBQwS7vqbx2Vc/U+4xeKlQhocpMh4BNSHy2jfowpuaUpjDOOCfitQvDW/+Ebny3QUEZKtjQnkdZqRg+NNeiLlxWmctqEXWj+euOt7Z0plvMZxobKw3vQc+BbbGIPdscW3X8cl+h7tNbraMFMRfpKnT7tcMchK5UBn5mJz1UUhsjn8R9uZYH9Xck6wshZBRxEPi3+xb+f+P2N6c58oPZQ8UioBVPnE0AgehKWMuYxE4LOCUwnvVoF8Rl6eFL/2Lvlw7XiXqMoNneXdhxlWULq/SxugAbMoLAnnBs6I0EtzP2Y6lz+ZeCVRPVUDHcTcluBZgpJkrdmnoL5mmRbaIDpFAKmDvenmQjP34dIPnsMKXUpL4QSlP9ElPyJvh2XXd9bBlGI25oCJj+VFWahAwHKqfMUC0IheUxCvmZtD/zqdKb/0RO717W9dfQtPpffiVcOdfVh5KK97iTWte6F7JU4W0vef7r1TLDapzz2us9fsNmdMjceXZvSbSlYufSfTf7RQmqPpzoXvhjepR3Nz43/qbHfOhQq0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(23010399003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?czcveHpXVmJzQ1EzRk9jUEFxV0k2NldDQ2UvaFV2RGtvODRMdlZFdm9WbXkx?=
 =?utf-8?B?SE1JaU5UZ3B5TFBqbEdRZmRGN1Q2ZDQ2cHBXNzhHcnUrWnMwUlFnbWpFaWpn?=
 =?utf-8?B?RGtaRGFoNWM3OUtDQ1pRUTh6RHYzaXF5NlZkOFdwZk92aUxmNmw5dlFlclFv?=
 =?utf-8?B?ZFBSOXNGTHlmRmR3RUFnMDkyMFFUWkh0RlBFQzBzUkVEcFIrWUxWVVpOZmtl?=
 =?utf-8?B?SlRoSHBiTjI2UTdsaGVTdlA0QTkvVXBQY0tPeGJmdFprc1VLcENDU2R3MUkx?=
 =?utf-8?B?a3lKSHRMZTVlL2crTG9nQkFvSURDMnd6TTFmN21iSllRNXBBTTV0OFpOc1ZI?=
 =?utf-8?B?RzR0dTFCczJKTk42ZTgyL1RiRWliQlhuc2RldDZlOFpVRVJZbTZJdlhtdFh5?=
 =?utf-8?B?Z29oUTgwNlBRcTduekpXMDRFeGNkTDhVM1orbk1GSnY2bjBQZ0hxZlc1V01w?=
 =?utf-8?B?MjhHVklMK2VMN0RpRFQrbmgzZ3MzcHN6MWd0QmdnbExGYXZPeWZNWmlQTzlS?=
 =?utf-8?B?Q0JpakNkcGptQXZkTTRXcjFSbHpJUktlQVFnVjh6TnlVbDhZS2dTMDBpV21M?=
 =?utf-8?B?YXluUGR1c045cC9SQm94NFQyblNRa1NrNElWMWRzZGRFVkppTlhKNTFPK1l6?=
 =?utf-8?B?R091VUN5OWhTVVppSHlzSXhVNWpVUWpQQXBuT09EeTZTRkJ0TGRtdDNDaU9P?=
 =?utf-8?B?Sys2ZVFTamxBckp0NElWb3YxQmRFbldOTExZMlRKOGR1S3NFWHdwT3JhWEU4?=
 =?utf-8?B?TU8yNTZwZGRpTDBDYXQ2SHgxa3Q4aGRlYTBwa2FLczYyVkFmQ2hWZnc5cEV1?=
 =?utf-8?B?bkdMdXEzTlBsV0hmU1k4bmkrZ3ZoUHY0QnM4VzNad3ZPK2JPMElDZ3RSbVBB?=
 =?utf-8?B?bDJKTVBwSHhwUmlDQ05ZNW00YWhxYjVtci9VSnJWWDYxb3dPelUyNDJublcv?=
 =?utf-8?B?UHI3TjRDRGFUaHJlZC9jM0JWRCt6TitTSW5QejduOVlkYWl2LzBxc0lkWk9n?=
 =?utf-8?B?RTVDeDg5R0M4N2h1RW9XSmxZV0VUMXM3akNUc04xalY1ZzZsZm9yL2NJeDlP?=
 =?utf-8?B?V3FYV3JPWFhTVkJJTmpjZVNySUg3WmZvNjVqdUViaWd0ODh6c3RyYVNQNWZM?=
 =?utf-8?B?c2N2NmJSbFdmUE8wV0NhSGhRayswQkZiRFNacXEzZEVJUTJ2T2xjT255dEg0?=
 =?utf-8?B?cTU4Qng2ektXMEhsMVFLVEhyeVFDK29DcE5SMFlOZ0UrSmhtcW12bDdsK2lp?=
 =?utf-8?B?MkliRDRhdUhZOElpMk05dWVQd1d2amJuREtSZnJnN0s2aTNPVGxaSzdWMnVB?=
 =?utf-8?B?TVZ3UjBFTWt0RStYRk0zL1dQNmViVVQ2anJ0VGJzQ1dBN0hIS2JIUVJiNVZE?=
 =?utf-8?B?TE94c1hpbkY5eEo3elBSWkRIYTV6eHgyRU5reGp6MGRkWEp1WlZDZ3pwWDc5?=
 =?utf-8?B?QTg5RWtsL3lNM2JNczlnWjVhdWJ0aEl0dE04cm9sZ0hSMlVzV3haMXljY3N1?=
 =?utf-8?B?b0Z0NE04RW1PVWVmWWYxWHQzdUh6MXFuanJ5b3hKb1BUMVhiL2h4UENEaE5l?=
 =?utf-8?B?OTl4akhCQy9lMW01WlFmREJsNkNUc0ZSdkJjR0s0ZitNSjgzR3JmWWNUT29h?=
 =?utf-8?B?c09KcU14ZjV3ekVYZjZFNHlVcmNLRkFJNk5xdDNhZEd2elRSZ1RNZVlHTVI3?=
 =?utf-8?B?YUJhS2Vlam9rcW5RVmVkY2ljU2QvQVdNSTUzUUJpU0R6MlZLK1FHalFYV09p?=
 =?utf-8?B?czFtdlBrMGpPL1FPbmdMYmo0WnpjTUZvRms3WjhrT0UxTGdydTN4TlVXTFM2?=
 =?utf-8?B?K3RuZ0xkUlE5TzU2K3VLUksvY3I0V3lMUHd6dTdaVlRla0dlRXdoSExDZHhQ?=
 =?utf-8?B?U3RlZXp0bjFFUzE0dy9kOG4xRS85OTdjMVQ0WXNuTFg1OTBjbFBSVVU1NlI5?=
 =?utf-8?B?QTJNY0JPWjhTVjBYU2JvNitMUmNlYWg4em4zb1N2QlNHT2VNa3B3Mnd5d3BT?=
 =?utf-8?B?K1RMaGhzSzFNZk5ielZUL2VrSStmazE4TDY0V2xLTHc3R0F0RXVJT0lOVjg3?=
 =?utf-8?B?TDhuOHBHTi9ZWFN4N2JpaWJDS2xJZG5BY2VZU3ZZaVJiTjZxS1ZxaWxxT2U4?=
 =?utf-8?B?SUlOM043ckpmejJWd1UrVTM2WTNrcStzYWgvTFJOTVNRbXEreEU2ZitKYmtn?=
 =?utf-8?B?N3RqNWNLMTZhWTI3TUYvZjRZRHNyT2VXMlVzckxoaG5LaC9OZ0tPNXVGMDVx?=
 =?utf-8?B?cDlUeXdEVW1seCtwYlR3bDVxclJEQjBXZ3Nmc20zK0Fyc3FQZ04xaWM4UjJ1?=
 =?utf-8?B?cS9lRlIvVzhORU1CTkUxQk9WZXNrZXl2MFJOd1RWRmFFWlhJN0w4NXVOZnNj?=
 =?utf-8?Q?QycwQr3vY5Ubw6ZM=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35472179-d92b-4cee-d7fc-08df22c44ab2
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 09:37:37.3570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DwEkH248cpsaysTXYzER8tdMVXPDf4ck2qsuTxbRgUEQNiK3O6uwrQemqivZ7fIQI/r+6DGvP4wVFTjGY63TAPar7SI+OrRw4HbCtK+Yeo4K7a382gVznozTr7tzEDAL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9913

From: Frank Li <Frank.Li@nxp.com>

Add dmaengine_prep_dma_(pq|pq_val|interrupt|xor)() as an inline
wrapper around the device_prep_dma_(pq|pq_val|interrupt|xor)() callback,
consistent with how other dmaengine prep helpers like
dmaengine_prep_dma_memcpy() are structured.

Provide a clean public API that hides the direct callback access and add
proper NULL-checks on chan, chan->device, and the callback pointer.

Assisted-by: LLM
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 include/linux/dmaengine.h | 134 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 134 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index c3a49a33307c6..6a187136f9493 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1232,6 +1232,122 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_memcpy(
 						    len, flags);
 }
 
+/**
+ * dmaengine_prep_dma_xor - prepare a DMA XOR operation
+ * @chan: the channel to use for this operation
+ * @dst: destination buffer address
+ * @src: array of source buffer addresses
+ * @src_cnt: number of source buffers
+ * @len: length in bytes of each source and destination buffer
+ * @flags: DMA engine flags (e.g. DMA_PREP_INTERRUPT)
+ *
+ * Prepare an XOR parity generation transaction.  The engine computes:
+ *   dst = src[0] XOR src[1] XOR ... XOR src[src_cnt - 1]
+ *
+ * Returns a descriptor on success, or NULL if the channel does not support
+ * this operation or the request could not be queued.
+ */
+static inline struct dma_async_tx_descriptor *
+dmaengine_prep_dma_xor(struct dma_chan *chan, dma_addr_t dst, dma_addr_t *src,
+		       unsigned int src_cnt, size_t len, unsigned long flags)
+{
+	if (!chan || !chan->device || !chan->device->device_prep_dma_xor)
+		return NULL;
+
+	return chan->device->device_prep_dma_xor(chan, dst, src,
+						 src_cnt, len, flags);
+}
+
+/**
+ * dmaengine_prep_dma_xor_val - prepare a DMA XOR zero-sum validation operation
+ * @chan: the channel to use for this operation
+ * @src: array of source buffer addresses
+ * @src_cnt: number of source buffers
+ * @len: length in bytes of each source buffer
+ * @result: output flag set to SUM_CHECK_P_RESULT if the XOR of all sources
+ *          is non-zero (i.e. parity error), cleared otherwise
+ * @flags: DMA engine flags (e.g. DMA_PREP_INTERRUPT)
+ *
+ * Prepare an XOR zero-sum validation transaction.  The engine XORs all
+ * source buffers and checks whether the result is zero.  The outcome is
+ * written to @result on completion.
+ *
+ * Returns a descriptor on success, or NULL if the channel does not support
+ * this operation or the request could not be queued.
+ */
+static inline struct dma_async_tx_descriptor *
+dmaengine_prep_dma_xor_val(struct dma_chan *chan, dma_addr_t *src,
+			   unsigned int src_cnt, size_t len,
+			   enum sum_check_flags *result, unsigned long flags)
+{
+	if (!chan || !chan->device || !chan->device->device_prep_dma_xor_val)
+		return NULL;
+
+	return chan->device->device_prep_dma_xor_val(chan, src, src_cnt,
+						     len, result, flags);
+}
+
+/**
+ * dmaengine_prep_dma_pq - prepare a DMA PQ (RAID-6 P+Q) operation
+ * @chan: the channel to use for this operation
+ * @dst: array of two destination addresses: dst[0] for P, dst[1] for Q
+ * @src: array of source buffer addresses
+ * @src_cnt: number of source buffers
+ * @scf: array of scaling coefficients, one per source buffer
+ * @len: length in bytes of each source and destination buffer
+ * @flags: DMA engine flags (e.g. DMA_PREP_INTERRUPT)
+ *
+ * Prepare a P+Q parity generation transaction.  The engine computes:
+ *   P = XOR of all source buffers
+ *   Q = Galois field sum of (scf[i] * src[i]) over all sources
+ *
+ * Returns a descriptor on success, or NULL if the channel does not support
+ * this operation or the request could not be queued.
+ */
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
+/**
+ * dmaengine_prep_dma_pq_val - prepare a DMA PQ validation operation
+ * @chan: the channel to use for this operation
+ * @pq: array of two addresses holding existing P and Q parity buffers
+ * @src: array of source buffer addresses
+ * @src_cnt: number of source buffers
+ * @scf: array of scaling coefficients, one per source buffer
+ * @len: length in bytes of each buffer
+ * @pqres: output flags indicating P and/or Q check results (SUM_CHECK_P_VALID,
+ *         SUM_CHECK_Q_VALID)
+ * @flags: DMA engine flags (e.g. DMA_PREP_INTERRUPT)
+ *
+ * Prepare a PQ validation transaction.  The engine recomputes P and Q from the
+ * source buffers and compares them against the existing parity stored at @pq.
+ * The result of each comparison is reported through @pqres.
+ *
+ * Returns a descriptor on success, or NULL if the channel does not support
+ * this operation or the request could not be queued.
+ */
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
@@ -1585,6 +1701,24 @@ __dma_has_cap(enum dma_transaction_type tx_type, dma_cap_mask_t *srcp)
 #define for_each_dma_cap_mask(cap, mask) \
 	for_each_set_bit(cap, mask.bits, DMA_TX_TYPE_END)
 
+/**
+ * dmaengine_prep_dma_interrupt() - Prepare a DMA interrupt descriptor.
+ * @chan: The channel to be used for this descriptor
+ * @flags: DMA engine flags
+ *
+ * Returns a descriptor for an interrupt transaction, or NULL if the
+ * channel does not support DMA_INTERRUPT.
+ */
+static inline struct dma_async_tx_descriptor *
+dmaengine_prep_dma_interrupt(struct dma_chan *chan, unsigned long flags)
+{
+	if (!chan || !chan->device || !chan->device->device_prep_dma_interrupt ||
+	    !dma_has_cap(DMA_INTERRUPT, chan->device->cap_mask))
+		return NULL;
+
+	return chan->device->device_prep_dma_interrupt(chan, flags);
+}
+
 /**
  * dma_async_issue_pending - flush pending transactions to HW
  * @chan: target DMA channel

-- 
2.43.0

