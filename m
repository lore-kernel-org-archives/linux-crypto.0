Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011060.outbound.protection.outlook.com [52.101.65.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F857552954;
	Wed, 23 Sep 2026 16:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180448; cv=fail; b=U3sJdtLRe+YRwkIx1bbvt22K82HBOkxx/HmNoR0gunv+9HK5/Sd/PUzaI503WAK3JfiYSTGGqMRIDmvJa9sUMWTcvhVy/RYygQ5N9DKHDHr546KUi28/9pDT7OvT5bQ5V7LcT6gx2PNC8NNxGdh82jblSOF0vlNR27dMOcMaQMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180448; c=relaxed/simple;
	bh=mIMtRZc/aP3dP+jhwzAxQ/FHZxXC9C/bUsZjVktjMeI=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=UBklVazSVZcgjY054Ebkd8BK1t4UeSr1bG6Ib4zMuJjinah6jQw7jF2Ti43vq0QCG1fS8UrNG+qGhQxAqwKaGprWIfO4o2eaK4I358U5uq7pxZa4AzAlHIBbtOh9cP29vusANBlUSNZ+v9h0epQyOE37c2B/o0MJPP/DONhYdlE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=rjxFChzW; arc=fail smtp.client-ip=52.101.65.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="rjxFChzW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yaKjgmatJz/TrJusMj4uBParxzx78wvJC1xgL3e1qeVDvnySOY5jgI/eKA5cGtlQuyzRH1NIUHMX6yUHA/U+d4OlUi/m1MeY1iKQUgFF2mHC5NQ4xB8SPa8D5B6Kl2RV1BW/qkKwsqOhW/qHcP6bDTw+GE6SoxMDuc1MjqUOVO3N9xWrXxPsaWmCBPt32tKLwzUAVKZ4mGqJ32UYR7dBRpIf3qlqp3npIYEqH7C8N6FV2TH/gRPdorNS7YnxkQTNtcXo2L8wVh+jK/GjSSi9NSXHAwuMpZzWftGrW4DBVpJeUuN3pX/rVYeXxhXGBK5wrXf7X/8ygQcdfubfP8hNag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5w/lPJrmc3m5j9IWNs0d7LIt4GcVNfKkkmTHK7HL1xQ=;
 b=iygF1rWW6Pr01GTi4bgxdZ7+qlud+sora313TELqS51UHsolenguK4Qsvh3qae+Zl10arOleMrssHaTLkYB232sxySi47Mwl2Rlbm6zyO85nMFRWhTOcY4s5dFgb44ABIzJsEItFxcH2h+PjlmLl4kYPEpT4tWgWRqct8LoIjgX60adpv5qmjfSyFRuxPqIwLkF9tuCld5fwWFlCeos4tjRK44BuGGmyyUursE1/beET+WC4pF+AZbmKyfuDLJBKA/FaKGkdIiamRiciGxgsYSHkVuWJb1AXMi9rO5xTTwRDk4S69wZCoHjC8i7bUlZbbCek0DlEDoYpD2fFL91Lvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5w/lPJrmc3m5j9IWNs0d7LIt4GcVNfKkkmTHK7HL1xQ=;
 b=rjxFChzWfYaz1KfQnpMkEltmrpGo7HUDOF2IDCMRC/wsJegm5cfBEQg89ulzoXWzlVsyz+Y+nh9H+QdIlK8dqP/5pw724L73xLV0bo7xrHZ+z2/9k6KG4Tzqu5FCr8ZRPDXAaV2v3t+hLgngtEj0ZdS+xEEMG/wV6Pq1uXZ0TvLV57QlbYbkhfXusvnz0Gk3HRnsUIg9aJzlAeUFCQvpxqeRuh4HPOy58E/euo4fwgVaGyFW1i9SDt2HNevR0RC9qUZi9HLJZ0bPd19LiRSFoccGrdrw7V/ZCf4GC3tv1zB8kuptcSDjxOQmYpBos98fPQlZ/HiPljZHxdMM4y2Rkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DU4PR04MB10433.eurprd04.prod.outlook.com (2603:10a6:10:55f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.17; Wed, 23 Sep
 2026 16:20:43 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Wed, 23 Sep 2026
 16:20:43 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 23 Sep 2026 12:19:41 -0400
Subject: [PATCH v2 12/12] async_tx: replace open-coded cap_mask accesses
 with dmaengine_has_cap()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-dmaengine_prep_dma_pq-v2-12-32ed65b8a9b4@nxp.com>
References: <20260923-dmaengine_prep_dma_pq-v2-0-32ed65b8a9b4@nxp.com>
In-Reply-To: <20260923-dmaengine_prep_dma_pq-v2-0-32ed65b8a9b4@nxp.com>
To: Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Dan Williams <djbw@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Jon Mason <jdmason@kudzu.us>, 
 Dave Jiang <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>, ntb@lists.linux.dev
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790180376; l=811;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=+z4r5MWtbaMh7Do/UsFrhQ12/nuY+GHP7Q0JHyFXttc=;
 b=PFL/30TfrECeDqWKuUVv6bTG8peu9n+fHCDvJ7fKvDOzeKxT9EsgBjXDl/qcJw08HcVYWy9Q+
 S43fEkb4tIFACd3wuOoyHTZKbTCYKKFcb3Je2u10JJDBRcFTNzXHUGS
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: SJ0PR13CA0219.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::14) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DU4PR04MB10433:EE_
X-MS-Office365-Filtering-Correlation-Id: c2070377-2676-4be6-d68c-08df198e9dbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|19092799006|23010399003|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	wQ8OYhglvfxUKubG7LqWbpoJKe6icNrv91e+Xj6agguK3tlWtTe3zkUWyKDWpVlwUDxJhEeUQdsWP+gT+UnI/Yk5+z+Po40PaqUI7Z2YTa1sSmX0KzuRIxiYVwIJ3NKQD4w72I2NlAfwcscRDPHtet1IkMbXeKJQq0UojgtE+aJQq9lx/ZVjf9BZVXJxBe2AupMrAC9SLf25BQCfeVbCixCAkOAfq51sBiE5Dp/3m+0Ca4Q/lE0gvzUouif3zimQmpQVoes0f9E67ddHVX2AYqm6Ox29kf8oW2eVRyeWeya7/lts+ZQYjcXJYPnP83oh+2psofiOgZekeuHyzTIw9LrVqYB9mG67ceSujhNuXym9CDejlb4PBCsLYL/IpBPhK+YXggf+dSbnRsugxaV0qE/5OpcTGu+jLERXKbILlDhRfiyfRWPfMOXSJAGoj84AgXZ4pIxCX85dndsuSJJxaI52RIExsvUHUyhk9NWSpvfBeyyaYTDDkY5V47ziUt4iHFn0JHtEc3Gy5wKgNNMXpTU9HonioFA4batHJqaZ5GIdkMPPlwAa+ZK92bqbVCq/UNNJjDvBfaSgkaSVyK7NwzO6QZce0Ep/+yPIZmy4/3swO1EK1tRCEU2fQEz7chYolhPpevr+6paDSgA47yXdfQ5gw1RKkRVtnYGFDB+eAuk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(19092799006)(23010399003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWZIeWpoNEZSOFh4YVA4aWtFRWxJK1pUajdCZmNnendXM1F2ZHBVQnNVa2hZ?=
 =?utf-8?B?U3FDRG1WUUlIVUQxZEtnam91dEJkT3prRUZnWWtkbmNKTWVNQWxhOXp3Tmwr?=
 =?utf-8?B?aVg0cWVaR24vK0kwZkY0V2QzS2hkUnZITUlvYU5TY2w2VVpmVjFEV3VNK1du?=
 =?utf-8?B?NEpxdmM2TWVZQkpmblM3bE84MzRFRTFVQWczVG5GYmgzWFEyM1poU0NMMUdu?=
 =?utf-8?B?UlJqU0RCb1NWVkY5Uk1ZZ3FNVWk5eUpHdytnbmtQMkEvLy9hV0loMXNLdFpZ?=
 =?utf-8?B?WjhoeFJmZk1rWVAxZ2wwRDc2SXpPQkZlVlZZcC9EU2k3VG8rWEhrbjRhcGE1?=
 =?utf-8?B?ZU9yZ3J5Nlk3NFl4YUFMWlhwOWRNOXVDQmhxL203MTBqRkFnZFhYSXRSUUcy?=
 =?utf-8?B?QW41SjhXVm15NG1jY0NZcXBleXU1Q09FUEZUM2FZalh2UU5OcTdPYzlJaWZ0?=
 =?utf-8?B?TjNFRDVYUVV3dGl1NTBJZXdjZFRCN0FlWGNLN1FCMk5BbHQ5OU5Nc2Z0L2Ir?=
 =?utf-8?B?YWlJcFpWbVc2ZGNTdWg5S3BjL3Y2c3FWWWx5bXR3K2VEQ09WcGVtK1dTajBo?=
 =?utf-8?B?azVLdUxaQkVQQmtyMlRVTDk0c3R3V3FwYmlZa3R5WEc2bWE1Tjc2UEJVRWhS?=
 =?utf-8?B?ZVhBNDQ0ZHowNDVSTTZsenYvbGhEVW12ZUNReTVxcjBkUUEybkNFbkR6U09Q?=
 =?utf-8?B?dnREOFFEWStyZTZpTFhpbzV5THVkdjZUU0k3L3pUK0wwYkxiQTh5VlpUWS9R?=
 =?utf-8?B?RVBrekRGOUpMQ3VCdlA4NWJOZnBHNGd4cE5CR3Z4S1ZockE2WHpXd0dKZ0pH?=
 =?utf-8?B?bHp5NUZHOUY5RFlHLzI3QWczZytjb0M3cHQrdUI2TUMzbWZpYk1YN1ozUHVS?=
 =?utf-8?B?a0Y0aWtoSng5OCtrUXdsNkVkVWRwSW5UVys2NXIvWGRZSEZzaXUvcnJXRmF2?=
 =?utf-8?B?WVordUF0UjQya2JiK0wycks0L1hSMndLV21DTUtRazFncGxxOGdwRm5lWlRk?=
 =?utf-8?B?MEpka1U5SHFacHRSUEhYaWhhVGViczdmS1lLZFl4WFpnQnp6RFptOWtYOEdP?=
 =?utf-8?B?aytndGpTNGRFS2F6T1dPN0lwMzRRdEd2Vk1aMlFnRFFLM2pVUkF4bzlWcWVs?=
 =?utf-8?B?L3ExTW9WYkVaT3VjaTNjeERxblFKTERFSlpDTVdSU3JBZ3IvcXFSSUpCd2Iz?=
 =?utf-8?B?ckszaHpwbGJZSU10eE5IZ3hsZWRNVkJCdG1VdVVtdmhkcVgzaUl2Z3ludUpr?=
 =?utf-8?B?dkRNeGExSmd1aStva1U4a1RvQWFzQlhBVm8xb2VvMU9sQk5CSUJxOXVyeXl2?=
 =?utf-8?B?REdVUVpWOWprV2JINDQwVVNncWpON3ZlU0hTUnplTW4yckFGREpOc3htWTR1?=
 =?utf-8?B?ZEdnQndjWS81YmU0V2RHNEFlMTJWM3Fid2JqK25vdit1WlRBOHh6VEg1eVR4?=
 =?utf-8?B?UFdLVnhWV2swVk02bVVwUzdaWTd6eWZCU2NWMENqNDM4eWhha3JPOWFNUTcx?=
 =?utf-8?B?NUt2RGJvUEc1YVkrZDNQUFRheFJsOWdpWnBGM3d1aGZNVDJta3drYXpISHJH?=
 =?utf-8?B?WjdFRFhMSW1pRGZZMVNYL2NUN1A5bDU1MzJJbTFrOGVvNCtrblg2bkJYaXZi?=
 =?utf-8?B?c3V3cExFbmZBTm54anNNenJ5TlB5QlNvUnVHWEZBMFFScHlvK3FTQUs1SWth?=
 =?utf-8?B?Ri9sbW9saVNZWFNSWndkK0tPVStqS3Z5eXQxVENmUmFRTDkzV1V4c01MVXp1?=
 =?utf-8?B?OUZlYXdMZjlrSldNQnYyQlMzRC8yZyt3eFBiaEFxeWppYnF5M3RrelBLaWJ2?=
 =?utf-8?B?SENrWisxYTc3NFVUM0llSGRvczBtODJWeHMxeFpiUTFic3VpRDFQdFk2REht?=
 =?utf-8?B?TURIN1pwaXU2VzRFK2dqeUZSbDN4MGRvVHl5SUMyVTdUclMxMmN3c25YRkg1?=
 =?utf-8?B?OE03UDd1Q2dreC9Hdm9PNFVJNlYyUU9NOURvaWVINU9sTmtDUDBxZ1V2N013?=
 =?utf-8?B?b2JRc1pqdnhjdDJ6MWg1SEcwUXpSZ1lSV3RSUHpyYkRJVkY2Vld3S2FjdkN6?=
 =?utf-8?B?Sk5aQ0xJQWpTc0pRbFByRkVHejFyTVhpTEJSUWI0Nkc5aTI4djJ0U21FczVj?=
 =?utf-8?B?N1Y5S0dNeTNpTERFL1JJMDBlR3lZRXA5NXlhVmdrVXpUZFhMVnNLOS9IbFdX?=
 =?utf-8?B?UGhUaUowS01HVWJjdGM1blV3bUd3ZGU5WEtGUDhCQzAyRnlXQmI5UWlNUTJz?=
 =?utf-8?B?cE5XSDN5RmJOaWd0R2ZIRFZSQkwvdWxPTmxqM2hTUGd1c1ZrVXdldFpoODFF?=
 =?utf-8?B?MkxoTWZtUGlYUVRiVkYxVnh0aTk3bG1OWG9WTGVJUnNxd2lFWThtaTg1ejZY?=
 =?utf-8?Q?7la6UTuHzEHYAPBugFMAuY8qrzuqCfganxILD?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2070377-2676-4be6-d68c-08df198e9dbb
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 16:20:43.6355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wlLy7kFeOmKIWzN+PGBVSyV8tQv0uUi96ARmtgnRrjcEV1iFoYS3WMLFWKozVJ+9O69q9TYZdMN0hOpeZCtiu6+ovpWcm/e/wcDgfgu35ka+KRumgspoUMkaybcp+YyZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10433

From: Frank Li <Frank.Li@nxp.com>

Replace remaining direct accesses to chan->device->cap_mask with the
dmaengine_has_cap() helper which already exists in dmaengine.h.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 7eba152ecb97b..5637c95be6b3b 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -47,7 +47,7 @@ __async_tx_find_channel(struct async_submit_ctl *submit,
 
 	/* see if we can keep the chain on one channel */
 	if (depend_tx &&
-	    dma_has_cap(tx_type, depend_tx->chan->device->cap_mask))
+	    dmaengine_has_cap(depend_tx->chan, tx_type))
 		return depend_tx->chan;
 	return async_dma_find_channel(tx_type);
 }

-- 
2.43.0

