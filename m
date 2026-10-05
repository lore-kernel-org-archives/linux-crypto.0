Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013054.outbound.protection.outlook.com [40.107.159.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC084570E2;
	Mon,  5 Oct 2026 09:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193095; cv=fail; b=N1r9UhM8eJD6uLkI5PbptG00YpgWxNBf80nPsrHf/X6MPKwGmR+5RTWeql4Y+quljqVdh6YDEM+TtU+72bEaqc/w/oLxRqa/2uLW+52WZRVRbV1+wCFT4tRra/JSHqY4qjFPOtTEgrTpR/wCDS10koCWJS47m7HW0g9TPxMA2Zw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193095; c=relaxed/simple;
	bh=ZS5U/4k6NodneT+wW5hlcRXa7c+RqecOtxGstNYglJE=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=k+YjNrJOL9gP+TYKdVPsArU7hzskPYPimwKj6X9wrBDP8XRPMAItha14y2vev7/AwQUkAORXtV/NNs8M0Nj+e2SrtnjmouCuNMXUprCVufoJcaAuv9q22cmrN22whoi+PBX+DTlGn7VJ41e7tf8/Ppg+BLykGeQquUefsxLBWD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=unhAbd6w; arc=fail smtp.client-ip=40.107.159.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="unhAbd6w"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ODFVH5pXjcVdtz9nph0Ewo57VnoWr9k3ANfNpl6n23BogLrgAUxc0yUdIP/Y134PbII5XixbhcqJEksmqfdK5C3pWO4bpG3lbjb7w4meV0F0zAlMI6pIm4fvngda2pyNVeUSxjH08+QVLOjh1YPItM+rRxNu9TXS03zulE6Zk/X5RaF5XZPi3EJLH0L6TJAc1AispHiXjCAtn8cylYShofPbmEQSxHKahnhCKsDgRkHfMLtGP9+J7FG0xMWMb+DTy374zyej291/K66hHBQre5zJ/ewAQGVCvzcQtnOAfT/tH+L8OJqqSDRAwKzZwY9S75NGOy4KP9dXkWDZ5oRaQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+9xfVgONIsZjfEJTqGA2HL3WCL+KQlLCpYmqvNdR3s=;
 b=QOsu4OeQEh5vtlXQKYwkmM/BqEiWljU+f7RJkf05e16WdQR3hOoC8+ZFFliLucz/ZTz1l6DXXlTvDVfYgY4a96k5n+Iva+/VWNJsEY3qYVB1Mew6OOrpe1S1o3uDGmzTbbt2B4zyWWJBJa7w3FyuRxw1vdqZIgAy7VAPb0St+AEJQ8u1co1/yR1xCCLbx8jTCt8yywyIlYE5hRfkrzoABQr3VfxMlufKqoRUlLn4p0oBJV+n6CEwr2xc0VOHE0xBOt8Ito8RUwA4cLgqy1BzSk8yV6VjWFUH+I6iOFvZXzwiw5pMQ4KKpfsuEHPDmu6l6JCqSvShm7yhg0OfJnN48g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+9xfVgONIsZjfEJTqGA2HL3WCL+KQlLCpYmqvNdR3s=;
 b=unhAbd6wb9V1MYRcU3EXoDTyy32cWhOqKItREh1eYFJRz+PwLYR9k3zYqtesul5DRJp7PGZIrNwPJtlN9sFjLRHTiPU+yWd6tNDTyvrcd9uQeou2H3/BF949xJsZUSIhSCa7lbxi7UsFvmXp64eny/t8XT6SLj39HLGWC7gBU8AlytgkF2/ZS66c9mohcC0JPDdPqnh+0aiGH7+AwY3yrRhHFC7gFoIgNXAJwQ18LcR8UrfcZJZFiS3mYJmaW8TYYHP6MqZtAX+ecvorPRaDjDUPWpI2lAuulQtoWmayFP8tAJLDPlPbece9TG5a0/6pTKUXQ0YMESCbu3CbNvAzsA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DUZPR04MB9947.eurprd04.prod.outlook.com (2603:10a6:10:4d9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Mon, 5 Oct
 2026 09:38:05 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 09:38:05 +0000
From: Frank.Li@oss.nxp.com
Date: Mon, 05 Oct 2026 05:37:18 -0400
Subject: [PATCH v3 5/5] dmaengine: add dmaengine_get_max_xor() helper
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-dmaengine_prep_dma_pq-v3-5-a4a241f26fa7@nxp.com>
References: <20261005-dmaengine_prep_dma_pq-v3-0-a4a241f26fa7@nxp.com>
In-Reply-To: <20261005-dmaengine_prep_dma_pq-v3-0-a4a241f26fa7@nxp.com>
To: Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791193046; l=1223;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=LNNV7Bgrn+0vp2g6IdYTuXEoC8S9OlxLNLCMVkkCNmI=;
 b=7YhMTppkKAtE3b2H8HnjlvV7JdaXWPCd7cYtIEniX6zFGDo5wR9HvoBzFn2+c2PS4TN2RbTeE
 nmMzukiayynBfjzL0eeAPueeRrg09OMEQJr+stHgGct3k+QcRQBq305
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH0PR07CA0006.namprd07.prod.outlook.com
 (2603:10b6:510:5::11) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DUZPR04MB9947:EE_
X-MS-Office365-Filtering-Correlation-Id: b587a399-2c4f-4585-72a2-08df22c45b5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|19092799006|1800799024|376014|22082099003|18002099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	GvkcM4vfIeojwS7+hLpyPXlVac82pHF23kS7ccUhhV3DePigMRgC97H+ML6ch6FzHEIeNzovfSwFi+m2cFGFacnrfgxOxY+9evHqnS2ri67pcNjCz9qwXCg9hgAtlbZVvSGxJxaeZx0PdFu84WwotgSXKtxuT2UdpKps/p+pDWGUDYlVv9QIohyQayA95DNMgc0DDHX7jbbICN0eoXjjvU6m3hP1RdutO2FJBnnZOvW+ECfK7vfZF4cHik8wzDuVum3mbb/yV5fx3+wzV6TlJfBoA/rEhe2ESfXut3jEr5Jh/geeXrUNlSGrapM1yF+SfVAkgkCsbw6nZ/cpZhSKYaawQ2WfVGGg8U421XPhq9F6cB6iHXOK+7PAxyC+xPZE9a+d8hP7IxrtjFjWAb3pkp8ol0VUcQXkoC7KbmvyUCNjX0LxdjYoD0qM1x7TGM/ULQCvaGBb7yJ5nd0A3w3GiTkvQXf2V0e0WsgW1rp4iNPNB3YT0TP8aGJtAg1suyFJPnmTrzC9PsnfmjIterU6G6HgF4RkfYH+EUzLTSPeRfE0/rmPVrUADhDXKAfp9iv+KU/BHIdXwcCXeH2anEjxzpYBJbSWBrkZN3IwQRwi8FQqLVkJzlH1z33j7Y8r/hmVRkWsejt0N6EWBIHF8VZikD3wKMu0adxjdM4csyg4ojk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(19092799006)(1800799024)(376014)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U3R4eXdNQ0VRL1RWd09Oc1QwOFk0QzNCbXJTa21nQVFzamRwcEs4QTI4YURl?=
 =?utf-8?B?RHBRQndjU3MzZktNbEdoN0tpQjJySlkwRXU0N0k1ai9ieHRVYUwxQ2c5TDQy?=
 =?utf-8?B?QzdSZGtOSjNYTHhhZzV5bWtBQm8yaXNZK2JXUGIxcFVkVm1DalZTSVVOVDc1?=
 =?utf-8?B?ZVYyYWh6YWVOU0NsNUtxNlVGWTFWbGtXd2hUK3VTWTN4dmdvMzNuWlZENlN6?=
 =?utf-8?B?U0NRZGVWcyswQWlBREFQQlVwRHBURytMRGxsQUlTTmRUS2VnblR3dlJlcHVq?=
 =?utf-8?B?K2RQaVEybzRsOXdUNUhJVVNlR3lWa1loZXYxeXhHT0hQZDVHeDl4MFU5MGs4?=
 =?utf-8?B?dkVUMmwwR2dPYWJ1ZStVUWNOZGZUWDdnODdNbndFT3hjdi9qc0pSUmhRV1h4?=
 =?utf-8?B?TDJNWmVJK2VqTCt5TnpBRC9ENnREZm0vQ0twenJ2UDYvZFYxV0xiZExtZ3JX?=
 =?utf-8?B?dk9uZEJWVm5UQVp2L1dPZG0wVHNPSk5XdmNXNFhKU043SFlhanE2clJEcnF1?=
 =?utf-8?B?eDdGRzJEM285bkpxVzI2QUtENk9rN3VFTlZIdHNvYW0yWUNSK21ydDJaSjRH?=
 =?utf-8?B?Zk5pdnBxNEVLaERaM1R1ZW5sd1RDNlh4M0FaK2tXODVEZnhYNmkxMFlCeFBw?=
 =?utf-8?B?RnpRVk0vQmIrZjFUTkFDOHo5UnpBVnVuaGswUVZzTmoxNk9FUEIzejhZamtJ?=
 =?utf-8?B?WXJSdzk3KzlkdFVwS0xTUjBvRDVpekNqT2lpeGJIQVFjUkJ4c1dSQXpmcmtn?=
 =?utf-8?B?R0ZpNWpvKy9VMVJLZS9NMEo1MS9GajU3amlRL05mbitGZzBNV3FVd0NsREVY?=
 =?utf-8?B?UWhneFBzUGhpazVPVFJWMEFza3J2WVZiZ01EVThXMHVocCtkOVFpVXMvNkNW?=
 =?utf-8?B?TjVyRzNzY2tVMVY0bUxIQ2hDbnVKNm9IaHBrT0gzMXZCSXo0NXdPby8vNHdI?=
 =?utf-8?B?SWsxTmZVWlNaTGRuOUxpSVpRbXk3RlVTZlNFV1ZXdXBtbHk0WDFwM2hVazdB?=
 =?utf-8?B?UXQycUd1SkkrMFZ6YlhCejIwNFUwenNaNXNjaU1Qd3RZdjY4N2YzQ1RNZXZx?=
 =?utf-8?B?N1pCUlBaUTN3dlN5WWlic0plRUJ5aUVqNHJZNU9mc3AycnhIQlU5VXllTFpl?=
 =?utf-8?B?dFlsOVM2Mlk3dmIxM1JpaUZEVUxPWWJiZFZFQU1rczNWb0sydlFPOHF0ZTNM?=
 =?utf-8?B?MXRiMm02ZmJnOCtUNDAzSFdNMm5BWWxZVURXb2t1dm5iMHNEYUJ3ZVU5cCs5?=
 =?utf-8?B?RVBWYWlPRURma2xIdFNrdEdKd3dJUk4yR3IwMEdkbFc2UG51NE0zdDAzcmxH?=
 =?utf-8?B?WmQ2SW85MVZRQWs0SWJja1hFR1pqYWdSTk5GVkdwNStRaW1MS0gwUEEwcnlZ?=
 =?utf-8?B?UERTcE9oTkdlQTRXQTRvZjA4UkxqdWN1c1pCczA2TURibmNSdTlCZjhEdEJU?=
 =?utf-8?B?YjQwZzlOc0tEejV2Tkc4WHBTY3JSZE5ycjVvZzUwRkJEVVRuTjk5akhCMFUv?=
 =?utf-8?B?Lzdjd3JTQjlBN0UwOEFodDFRQkVxaDE1V0xmclByeGdBUUgwSUE1S0RyU1ls?=
 =?utf-8?B?aWhZRXdSeHcvNE1PVTBPdVZXd2VZWHRlbXdQbTFDcGtsMERYWlhqaTRyWEU2?=
 =?utf-8?B?WUdyV0hNcFc5YTd2OTkyWlQ5dFp3WENoOXRsNFFVUDFVeTBsSit4M1JrMm44?=
 =?utf-8?B?V2YvNmVMNVp6Sk1CRXFSNlNHS1FNZmlwcHpzSFJJRFBXOTArc3VmcDcySG5w?=
 =?utf-8?B?VkJCbjVaalJ0TDcybC9uZE01N0ZTdGhhWnBFd252bHlzUG56cm1KZnJwaFBX?=
 =?utf-8?B?VG9mMmVIaktrSVhmc1o3N2UyYTRISHVwM2JMNklOcVhpaWRjYlBrVm1yN0RI?=
 =?utf-8?B?ZSt0b0pOVTJYbWQ5VkpNdU14TFdpTlorcDVrKzZrVWp0QUc3MkJvZW56Q091?=
 =?utf-8?B?MUtiY1BpYzNjRVBoNm1xV2o5WlNIb0ZZUXl4WVFzUyt4d0x3R2ozSWtFQlVB?=
 =?utf-8?B?cXQ3WVIzV0gvMW43MWpKMmNUU1VGaStLamxYSUFyd2NNK0FSWkVXZ1hUdFVx?=
 =?utf-8?B?ai9CcmhRSGx5ejhZWjl2WG5GS3ZtbDBQbWw5eW9Jak8zMTdteGJSMFBGcU5N?=
 =?utf-8?B?dldWYTRRYnVOL2pmQXhieEt2bmhqVkQ0RWh5K1hwVzc0V1JydmpyTGF1cWRP?=
 =?utf-8?B?V1lOUkx5Q2JhQ2JzeWZNRDdydGMweXd3emZrREhlSlAvaXlPdW5udXdWWkxU?=
 =?utf-8?B?ZVppdElnWHN2RDhScjMxZ3MvM09xWWN2dFdzTmdnUFBsaEIzRkxwVjh5V0F0?=
 =?utf-8?B?QmFxSUlVTG1EbkltUGU4RHF2eTVLdW5NOGZmajQ3QlRlTU41d0NCMHpUNXFR?=
 =?utf-8?Q?1SI6tIifWuhzgkXA=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b587a399-2c4f-4585-72a2-08df22c45b5f
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 09:38:05.3613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FnBrm+GSgsLZiJu115lKOMxI6BOCa94KIa1ig+e5WL6w++xmrUGeSjljEOBs7caRkPh3kzJsNDRClkjrlFlbbEaMTF5yqXLi/CqcSMvWxLtwlNOCUAAWhqmuf8TK4sMF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9947

From: Frank Li <Frank.Li@nxp.com>

Add a new inline helper dmaengine_get_max_xor() that returns the maximum
number of XOR source buffers supported by the DMA channel's device.
Returns 0 if the channel is NULL or does not support XOR operations.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 include/linux/dmaengine.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 7fce44bd7c049..a4c9eef369cb4 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1232,6 +1232,21 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_memcpy(
 						    len, flags);
 }
 
+/**
+ * dmaengine_get_max_xor - get the maximum number of XOR sources for a channel
+ * @chan: DMA channel
+ *
+ * Returns the maximum number of source buffers supported by the XOR engine
+ * behind @chan, or 0 if the channel does not support XOR operations.
+ */
+static inline unsigned int dmaengine_get_max_xor(struct dma_chan *chan)
+{
+	if (!chan || !chan->device)
+		return 0;
+
+	return chan->device->max_xor;
+}
+
 /**
  * dmaengine_prep_dma_xor - prepare a DMA XOR operation
  * @chan: the channel to use for this operation

-- 
2.43.0

