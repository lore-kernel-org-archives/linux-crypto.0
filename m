Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010066.outbound.protection.outlook.com [52.101.69.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030564F4739;
	Wed, 14 Oct 2026 19:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792007065; cv=fail; b=QokJ0Hqwza6WFzYVimWYI6GWM8sepIxY6wpbpT1z/yEH6K2a4y3N/VmqIhPifWYC/nK6RXg/uiAWAv6Db4urkb8mQGhAHKq2ofY+lX6lprZmvrusrM4g1OwjWLM1JI7jAsRZ37l2ViLZ+63zTMPosl/MGnCe5YnvJJ63VD2tTBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792007065; c=relaxed/simple;
	bh=zOIb8BHkONWGwWwC4aGSk7IdY/jgKjD9GG8v6PPQqYU=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=in7Rn90Ho162zwilwKw4yWeG700+2/k5y/fRf1+bRhhuk7GZeV0ojJgYr6xBUNroINqR3qgDVYHwJcNknqFhFdK3SLDnMkrcmX+TcTV5hZagRK6Go8aePfeHqAcLXDVpjIjsfb9iFbKCOTGSz3IakN9gxN25t9v9H2UAIhs7CaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=sIGHXoEt; arc=fail smtp.client-ip=52.101.69.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="sIGHXoEt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C3MwI2fuyv6yWpNY1u5Yi5OdHBGUXk8nHCj2mwh5CW4yCrt+x66o1Y99c7lB016Qfgbi20AN6DJejGprYmt0QuDDyLyeTy/y74o4gOfdZb/1v0ePwXmRhqnXRoeouJrS1iaDU9vwkF5KNGaEOLyS5d4ngfQO6zodRWZ644X1m7AakZQNXFA78Zr4tli5vh7+uPveCuVpnJk1L5xLDhAmmLuaEzXNDAmEGR6d/ro0xz0drsi9ZKN/p3Nc7oLDllWNQgCu49nRi7wJO4nhEFDVdW2HWtnkOeWwb8lp7DW5b1ZhIqGuWVhK565EC6fBCwydUAqZJyN4avjOGzmc4lLp4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hpcZvQ+JgKZgxrQd9r1XdRhxKWPG015w59O7RJ/3LiA=;
 b=j86YCq7Ru1LukwTy6WWE18nWjiCSHsD7Eqy2ZyzLZ9mF8PsjwDEXifcYIL6sFqik3eyWG43jOq1uSZ9UNeHmyWWS/BCjbQrewo+wMz9G+YURyoLsz2PmR9MiTHdDr2c/4rxchtPaXLRkTqzaxKjqqRI5Qru3d23hFxV7Y3tPvH6vpXoab0R194X6nj/wHYfRVA0lZUYbFB8mCTO07Qpimej4o/F6bzbD8moUUXVPg+1Jlmzpla7/o7SAPw2Bu1NuAlNIA4q3rv+F/BJ1+jJRsHd+iDJa0YGSpLDLaOF887M/v+ZBbDv12efxhqf/20nk3312O2s1jX+XOXB9HOEOcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hpcZvQ+JgKZgxrQd9r1XdRhxKWPG015w59O7RJ/3LiA=;
 b=sIGHXoEtFw4zAtWvqwGaOSMm9xqlkHmxX5oelsiPErCXXuLEBU2OEcMHlU0Ym053vifgEZzS22Yhod1dY6Dago3scWD5TPbWHdWiRIi2oo4psoPgtZKVQr/+ffB66e9oFcsWk1Iey3aESL8/uPHwK6qMKlwsC6XBfCsKBcvCaZ09DDoOnGga0chkwpsrHhkUNdwQiJq7AVHTGkRvVDUreQOeKMUB/ThYn9w99n7BVBOwN86en/vXTP8RJuEqTLTx73iU7x1WazzzgMP6Rm0dfoLeZCtAtErARThefITC2DkE07DW9ZhUxh2Z7wp5AEo2x1QMzezMoM9QGzTNQxAUzA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DB9PR04MB8361.eurprd04.prod.outlook.com (2603:10a6:10:24d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Wed, 14 Oct
 2026 19:44:21 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 19:44:21 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 14 Oct 2026 15:43:48 -0400
Subject: [PATCH 4/6] async_tx: convert to dmaengine_is_*_aligned() helpers
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-async_tx_dma-v1-4-35790d01e190@nxp.com>
References: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
In-Reply-To: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792007035; l=7777;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=MXXspFpNMQHnCFDkxgXQK55LyGvBoycOAUNpk+mGK+w=;
 b=RU37vu7AqKgeuMnsZTt+x7roHZx+ODL03tfxCPazMFigr3EZG+SeKvh2BblroxmJ0Cb4Hv8i4
 pZG2WyOy4cKAI8gmAWMjaJTTPNC8pNSQLeF1eRVSkws+PN340XtiKuz
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH8PR15CA0024.namprd15.prod.outlook.com
 (2603:10b6:510:2d2::9) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DB9PR04MB8361:EE_
X-MS-Office365-Filtering-Correlation-Id: 87acee73-2599-47d0-860d-08df2a2b8af7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|19092799006|56012099006|10067099003|3023799007|11063799006|22082099003|18002099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	9g78Yf033bnomvjzsTxuta0QdaJ1aTzCOxzaPGZqnpllEQxqBHKvMjlU53m95kZDXSJm2XqciUiVJLWW4Gz7XnK2y1lm9+X4tgvirEx3i1WE13xeJHzXOcerTSJEQcJGz0huvotntThyoojzY5Rw6CQZi1PSbwmh9zmxtKWXHxPBNbxs4EkDQMCi2R5+5KI3XTmYoEm6mK05hO5YvWTpy1SE3eEIB4KMGWT+oVBEhPaCoPDNK3xU2RJQ2Q8EigJPvCB3PKOtwg+waJBN0qjXJJ76rJpHlNVugwcczHikWEx1RylN+uITTvcKpvVHXiGJN/QP+5a5xj7q+nKcPJfxVUkE2s7Qhg092wfFL953hIGxVrbXViOCxGktFQAk+mNDd/RclEfjcVQ3stRpJgAmHPWskMiLT/y5FRzd6X8+FrjZMjdcyY6ljs9aE28kbJnx4psA1T3+zdXE7F9LoOCx8y13jmw0SkbD/oVBD11QvIvQQ/Ob7CjAUrIl3ojG9AiSX8X8/qi/kiqixNQgSXB6sBAxB/gt1xt5ZHlAYN1OMGFlL9VG3u7Tnlp0mEnBn2U+FQWzRjlZeqMzaLn3zV3ci4MikXQri5SetPDDUwGR106Tpc7/ECYiera23VwACqYTy8UdDGFFnHR6yTSYPJWYcvJjT5bLRkC3RfWhiOjQcng=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(19092799006)(56012099006)(10067099003)(3023799007)(11063799006)(22082099003)(18002099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFpRZ0lDSWxrRmRUOW80RytVWUtLTXVvbGNMRkNUWlJaSHBKTEpRcGdrRHgr?=
 =?utf-8?B?M1NMN2x3eVhmRkdwblFDQnRaU0lMMXBNWktVOEpOcG9raHo4SVFFRzRyVEFz?=
 =?utf-8?B?K1U1UTRpZzlHTlBadlgzd09QMXJmek1kc1ljYzFTOUJYc052UlVvOTZjS2hm?=
 =?utf-8?B?cWF3Q211aHR0ZVJncTNORzRiczQ4MzBhZU1haEVtcEZCRTBVR2hKdGtFd25n?=
 =?utf-8?B?SDBYK0M3NjlnWXFxRHhhaWFmeUZuUDl2WjZaMktkK0lUMHRqS2loc1FlZ1Qz?=
 =?utf-8?B?UDRZU1hNU2NubndEN1cxdjlqa1pSbXVpN3FoRDdkTVdmRnQ3WEs2YVlMdFNh?=
 =?utf-8?B?Y0p1UzV5Z0IwdG1mY0lhREVrTTJPWEdMUFFYbXdjVHNML1VEQXBrSXMvVUIv?=
 =?utf-8?B?eU9zeHZHVEtBSzF2NkY3L3p3eWM2eGM2dm5YNFY2SXdobVdRdlBaQzc1SlpK?=
 =?utf-8?B?UkZKRlJmUG1sVEZwS0c5aVVFWVF1SGZDMWx0R09ZeG03QXZJWUZFM0Y5WG9q?=
 =?utf-8?B?cnZ3ZE16VkR1djJKc3hKRWhnTXVIUEI5bjQ5Q1RDdjcxMTFKdFdWNlltb1JZ?=
 =?utf-8?B?cmRyTXB1SFZOZTNVNE5KRVJoTUhYbWIwUnpWb25xaWs0RFRYUEFBRmliYW81?=
 =?utf-8?B?eHlvSlh6R0RjTTVDRWJpUitQS0tUZ2N6NWNNODRDRFloYVAvTzlrem5QZzVo?=
 =?utf-8?B?UldTTGk3Q1VmRlFDRExBRUdVVkNBQW9nNnNMT2ZNOWJNQmgvNTVxcncwejBB?=
 =?utf-8?B?STJvWXpjS2gvWGZScXk2M08xMytGUjIzRDBpM2RHdU5Gb1NrMkE2ZjFZM2Jj?=
 =?utf-8?B?WjZuM1RBSGxsWUZVeGlSWHZYK0E3bXJFQXhPMUdOY3NYMVlQZm5uSldqVlJh?=
 =?utf-8?B?V3o1WFVJRGpBSjYrZnRSOVdoTFhBZHBrV3JQSWIrSkRPbDBLMFVXWDd5QSt4?=
 =?utf-8?B?TFk1WUNpMjY2RUVqRUVMR3JKUDhxbzJpbmc0QjJRQkJPanV1UGNZV04wU1B1?=
 =?utf-8?B?V1JsZnNkWm0wVXJ2b3VEM09NUUNKT0VvL1N3M1RpVzc2UEx0MzVEYVd5RzNu?=
 =?utf-8?B?QkVSYTI3SVl2REtqeEgxYllVanpxWlV0SnBHcVVNMmNRb2JJK0s1NGFpM3N3?=
 =?utf-8?B?WFNNVVJhc3N0Qmh3VGZkVFNsQW8yOXhKdlNTc3g4SG9RdC9FQ3NjOGsxaWNa?=
 =?utf-8?B?NjNQSzJFRHNydGlYdlpGZGljZmlwZ0tFTzY0K2owa2ZyQnpGejBVdkJUOE9T?=
 =?utf-8?B?M1NNQmNJMkFMUVlUS2lacGN4V3ZCQ1p5OXVUdG1yTUtxY051SjdnNzJPM0cv?=
 =?utf-8?B?QUNiNk5jQVowZjF3OWxSayt0NHByVmZ3cGVqd29KV3hHNS9MOEhudmh1S0dV?=
 =?utf-8?B?Nk40czVsNXRTRXB2Q0NJOEZ1dko0ajJ0Z2FZeXB2SnhFdTNBNnJ0bGVHMzRm?=
 =?utf-8?B?cndZNGw5MFVBOGloMWRONEhrODVBaGNuMHlnS2hqWUNYVVpmTXlEZDd5RnZN?=
 =?utf-8?B?WElEaTIwSXJmREJPK2tQNGt0Q1dDV3VQZmd0TUZUM09NZ1lGNXV3TVZpWWJa?=
 =?utf-8?B?cEFEZ2JMTUFpcm9EeXQzLy9LdC9lZU56UmFyRk9QRU9ycWV3N0JVa0RuT3gx?=
 =?utf-8?B?VmhwV1VabWlsYldqVlAzMENFc3VBcEJYWHBaNnFpWThrVXFUUUZnNGx2SDhQ?=
 =?utf-8?B?cjN3WXZVREEzdGtQbnU5U3R4ajFxc0VHUm4vby9UUy9oR2dFWXJMTUZ6bi9l?=
 =?utf-8?B?NmRoUnlOblBjbkpjb0YyVWRKZUdveUM4TjlZaXFqUUJCOFpwWmUwWnpCL0lr?=
 =?utf-8?B?N1dIdW9kSk1tRGxFeS9LeVJoR0gwTDFVeDJ1QXgwampVcVpNRWhJdThvYWRv?=
 =?utf-8?B?YTJ3NEczSGZzZjNQVytROVBtZ1lMRWk2elpzZHR4OC96aVdDVUhOTTVyTmJz?=
 =?utf-8?B?RmNIRFdKamhjOWFxMVJ5SkNpSGFxdnRTSFNCL3EzeThpemIvQnUrV2NYd2Ev?=
 =?utf-8?B?VFArbUN1Nk5ORWpoc2xEYWRSSzdFL2hkd1BQSVIzNkoxdlEvaHRGQkMzWFJV?=
 =?utf-8?B?ZGdLbm5ocFdWU1BSOFlmcWtBUE1VazZsaTNLK1JUb0xTaDE1M0twK2l1MGRz?=
 =?utf-8?B?ZTlTNVBxVitKTDd2S1FMckgxY0NVa0Z2VE96b0c2c0hzcVhYcEZqK01rRFFQ?=
 =?utf-8?B?U1FSVHZyWnBRT0g3Ky9ZaHlhVnR3eWY4QnlXdmN1aUFrdFk3enJ4MmVjOXhW?=
 =?utf-8?B?SWtKM1c0SC91TUo4T3B4TE9kU1lxd2psUjRvcjlBK1JIWlhxSCtKeUUvMzZs?=
 =?utf-8?B?UmJhUFRma2JYTFFiSHpwS0Z1VncvZ1o3eno1UE52c3J0MC85OWdtU09zSVFU?=
 =?utf-8?Q?IKCQo6mVaif6DpQ/b0hO02JrkIHpaW/w5MXLd?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87acee73-2599-47d0-860d-08df2a2b8af7
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 19:44:21.4560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +mHfehARlWFFKfknFfAPTi3SbdGpNIYsnvS1FJeYqa7P6Y3pMVpvO1qSkrSrsVP7jPzff3o7lbaeGJM5q3XDLUhqyulCALUxjYVrFtIpEwC0H0VdRj654L5q36cUlKrQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8361

From: Frank Li <Frank.Li@nxp.com>

Replace is_dma_{copy,xor,pq}_aligned() calls with the new
dmaengine_is_{copy,xor,pq}_aligned() helpers that take a struct
dma_chan * instead of struct dma_device *. Also update the internal
helpers dma_xor_aligned_offsets() and is_dma_pq_aligned_offs() to
take struct dma_chan * accordingly.

Also use dmaengine_get_max_xor() to get max_xor.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_memcpy.c |  3 +--
 crypto/async_tx/async_pq.c     | 12 +++++-------
 crypto/async_tx/async_xor.c    | 23 ++++++++++-------------
 3 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 49ee66759c7e9..972670094be0a 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -35,14 +35,13 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 {
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_MEMCPY,
 						      &dest, 1, &src, 1, len);
-	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 
 	if (chan)
 		unmap = dmaengine_get_unmap_data(chan, 2, GFP_NOWAIT);
 
-	if (unmap && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
+	if (unmap && dmaengine_is_copy_aligned(chan, src_offset, dest_offset, len)) {
 		unsigned long dma_prep_flags = 0;
 		struct device *dma_dev =  dmaengine_get_dma_device(chan);
 
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 6ccc1073c5ace..30d6ee676dd44 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -140,13 +140,13 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 }
 
 static inline bool
-is_dma_pq_aligned_offs(struct dma_device *dev, unsigned int *offs,
-				     int src_cnt, size_t len)
+is_dma_pq_aligned_offs(struct dma_chan *chan, unsigned int *offs,
+		       int src_cnt, size_t len)
 {
 	int i;
 
 	for (i = 0; i < src_cnt; i++) {
-		if (!is_dma_pq_aligned(dev, offs[i], 0, len))
+		if (!dmaengine_is_pq_aligned(chan, offs[i], 0, len))
 			return false;
 	}
 	return true;
@@ -181,7 +181,6 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
 						      &P(blocks, disks), 2,
 						      blocks, src_cnt, len);
-	struct dma_device *device = chan ? chan->device : NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 
 	BUG_ON(disks > MAX_DISKS || !(P(blocks, disks) || Q(blocks, disks)));
@@ -193,7 +192,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 	if (unmap && !(submit->flags & ASYNC_TX_PQ_XOR_DST) &&
 	    (src_cnt <= dmaengine_maxpq(chan, 0) ||
 	     dmaengine_maxpq(chan, DMA_PREP_CONTINUE) > 0) &&
-	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
+	    is_dma_pq_aligned_offs(chan, offsets, disks, len)) {
 		struct dma_async_tx_descriptor *tx;
 		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		enum dma_ctrl_flags dma_flags = 0;
@@ -301,7 +300,6 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 		   unsigned int s_off, struct async_submit_ctl *submit)
 {
 	struct dma_chan *chan = pq_val_chan(submit, blocks, disks, len);
-	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx;
 	unsigned char coefs[MAX_DISKS];
 	enum dma_ctrl_flags dma_flags = submit->cb_fn ? DMA_PREP_INTERRUPT : 0;
@@ -313,7 +311,7 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 		unmap = dmaengine_get_unmap_data(chan, disks, GFP_NOWAIT);
 
 	if (unmap && disks <= dmaengine_maxpq(chan, 0) &&
-	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
+	    is_dma_pq_aligned_offs(chan, offsets, disks, len)) {
 		struct device *dev = dmaengine_get_dma_device(chan);
 		dma_addr_t pq[2];
 		int i, j = 0, src_cnt = 0;
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 3cbe08883085b..cf3eedaf2a75b 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -23,7 +23,6 @@ static __async_inline struct dma_async_tx_descriptor *
 do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 	     struct async_submit_ctl *submit)
 {
-	struct dma_device *dma = chan->device;
 	struct dma_async_tx_descriptor *tx = NULL;
 	dma_async_tx_callback cb_fn_orig = submit->cb_fn;
 	void *cb_param_orig = submit->cb_param;
@@ -38,7 +37,7 @@ do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 		dma_addr_t tmp;
 
 		submit->flags = flags_orig;
-		xor_src_cnt = min(src_cnt, (int)dma->max_xor);
+		xor_src_cnt = min_t(int, src_cnt, dmaengine_get_max_xor(chan));
 		/* if we are submitting additional xors, leave the chain open
 		 * and clear the callback parameters
 		 */
@@ -124,19 +123,19 @@ do_sync_xor_offs(struct page *dest, unsigned int offset,
 }
 
 static inline bool
-dma_xor_aligned_offsets(struct dma_device *device, unsigned int offset,
-		unsigned int *src_offs, int src_cnt, int len)
+dma_xor_aligned_offsets(struct dma_chan *chan, unsigned int offset,
+			unsigned int *src_offs, int src_cnt, int len)
 {
 	int i;
 
-	if (!is_dma_xor_aligned(device, offset, 0, len))
+	if (!dmaengine_is_xor_aligned(chan, offset, 0, len))
 		return false;
 
 	if (!src_offs)
 		return true;
 
 	for (i = 0; i < src_cnt; i++) {
-		if (!is_dma_xor_aligned(device, src_offs[i], 0, len))
+		if (!dmaengine_is_xor_aligned(chan, src_offs[i], 0, len))
 			return false;
 	}
 	return true;
@@ -171,7 +170,6 @@ async_xor_offs(struct page *dest, unsigned int offset,
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_XOR,
 						      &dest, 1, src_list,
 						      src_cnt, len);
-	struct dma_device *device = chan ? chan->device : NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 
 	BUG_ON(src_cnt <= 1);
@@ -179,8 +177,8 @@ async_xor_offs(struct page *dest, unsigned int offset,
 	if (chan)
 		unmap = dmaengine_get_unmap_data(chan, src_cnt + 1, GFP_NOWAIT);
 
-	if (unmap && dma_xor_aligned_offsets(device, offset,
-				src_offs, src_cnt, len)) {
+	if (unmap && dma_xor_aligned_offsets(chan, offset, src_offs,
+					     src_cnt, len)) {
 		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		struct dma_async_tx_descriptor *tx;
 		int i, j;
@@ -303,7 +301,6 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 		struct async_submit_ctl *submit)
 {
 	struct dma_chan *chan = xor_val_chan(submit, dest, src_list, src_cnt, len);
-	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 
@@ -312,8 +309,8 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 	if (chan)
 		unmap = dmaengine_get_unmap_data(chan, src_cnt, GFP_NOWAIT);
 
-	if (unmap && src_cnt <= device->max_xor &&
-	    dma_xor_aligned_offsets(device, offset, src_offs, src_cnt, len)) {
+	if (unmap && src_cnt <= dmaengine_get_max_xor(chan) &&
+	    dma_xor_aligned_offsets(chan, offset, src_offs, src_cnt, len)) {
 		unsigned long dma_prep_flags = 0;
 		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		int i;
@@ -351,7 +348,7 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 		enum async_tx_flags flags_orig = submit->flags;
 
 		pr_debug("%s: (sync) len: %zu\n", __func__, len);
-		WARN_ONCE(device && src_cnt <= device->max_xor,
+		WARN_ONCE(chan && src_cnt <= dmaengine_get_max_xor(chan),
 			  "%s: no space for dma address conversion\n",
 			  __func__);
 

-- 
2.43.0

