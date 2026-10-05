Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011043.outbound.protection.outlook.com [52.101.65.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3E3445AD1;
	Mon,  5 Oct 2026 09:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193075; cv=fail; b=rA0z6V2a3HHOLtVJbGERTi0CTa59hjwv1esw59OjplXvBvYrUm112cughFlXVvLrm5agupUUl68GOS7qaSoOcbKmBdgp1i1csl2qErJnTj1bpdlawafnr3HNEFszx71xjE5IYzB2Gop2ejY8tAJi4zz0zXDE4v4h18yryRSgr4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193075; c=relaxed/simple;
	bh=yPjcKmIAfAQsHIpprPTVTIFweOIkApZP0n/mTuTRRj4=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=qv1Cx4GoNey6VWARvPSa6Mmd3pMK9kOtxFMEoWEyU0/cR3F9u1bj6YuU2i4nDOBmwsGuA5gzEHeZh3bAzyXeKEhprC4nvP3wiBeH/t8ZLStNucPj1kvHNrfZBbqRGMdfgZs15dras053ZmoU6tl9EgyeCARXKWWbhxQJi2JQzxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=C4U8R7sY; arc=fail smtp.client-ip=52.101.65.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="C4U8R7sY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jg+Ow8x8pZX1iDCjv2pSTQ/96jBq1FK1Rn3bydoUZGkBShg/Z9j4MHIfMX1xLeGWpfUoTIfyHBgr+KJ03zc3A3ulJYRxbOsyoYq2rQeV/4l1/dAeKwzbiKbmX+4/Q7mTVyZbMkmpuqmbeF0furS8Fouryne2Ccq+RFM47PwMVSi26Yqy4t+4aQ8mCyEmffiIhh2wpCDreT/UQrTo/HS9sBKH1sgFf8nSsC3eLJ7JlBG7j+nCDwZk+puCJlhbckx3C4TOM8vgtBF4mGdDaUodxeNhLhRIKVEOGxNj4YuyrF6kaQdR8qSfKFJYr6/Ra3OE+27rh9zCueUP6krW/u+38A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qFcdyzJnZBjBVqjPmcCSwYmPD9G8DqgVLR/EWom7g8o=;
 b=J4FzvyF4q1vYOitse2NQyoM9xc8oFKTAwb36IS6slzWF+Gg2tv3sfpbKcLxrbnh8bp8F3ytR7z5VTmNw7dkyfv4uS3US7ZrHHKw6vJMsq00XlOf0A+OufmKUNQVUEcbvNQupBeI8YcnBu8rs5iKwR1f9Ne7eC55Y21TD1nU9E3GloATGsevxCB9t5UK11NjFpButRsH83HVo5VuMgQhTu/FRHbHC+pPm6yA0qzwgMpZ/ZRGY9ERvLWusW3Zgkns6BtmE+B4qrO+GhnPOCmwozz0oVgIG41vftTK2DV57DrULy6zgSRVQxpCcXbc4SEaeY6q97WMy27l3t2F777RCWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qFcdyzJnZBjBVqjPmcCSwYmPD9G8DqgVLR/EWom7g8o=;
 b=C4U8R7sYF/B0LtkP1bDPuaUmdB9keITdtW14tZRGQk/3SOSwhTauffJCJ9TkYxS54W4ZWArGAnfgRrkTLzrLm01xc8Ch7m2MMg08R8S9hk3ukETRelA3dED5s4WtjeQwcYDdLIRl4t5N2j83HiZe3lflDSBsNpKt0UAdxTMq+vT7jp502awalbtxmdsUcNGx2O6A5fnPX6HuPgu03Nv1O6ZdvY5aqWHwFmDWfWT9QgGdJ0OygMxMKCCPLUgxMrd1ZLJ5CxrkPsZ/EyAy7CGH4cuvZ4zAUR8NTnfVuvKNxOKwxKbyJORXoGhEBKqlgeIn9k0FuOB1Y/ayJR40+Kw5fw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DB8PR04MB6956.eurprd04.prod.outlook.com (2603:10a6:10:11b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 09:37:42 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 09:37:42 +0000
From: Frank.Li@oss.nxp.com
Date: Mon, 05 Oct 2026 05:37:15 -0400
Subject: [PATCH v3 2/5] dmaengine: add dmaengine_is_*_aligned() helpers for
 DMA consumers
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-dmaengine_prep_dma_pq-v3-2-a4a241f26fa7@nxp.com>
References: <20261005-dmaengine_prep_dma_pq-v3-0-a4a241f26fa7@nxp.com>
In-Reply-To: <20261005-dmaengine_prep_dma_pq-v3-0-a4a241f26fa7@nxp.com>
To: Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791193046; l=3167;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=KCTGjzRUC82WfCM01zzXaIcdRgIJEvbFP+94q9Ozdvk=;
 b=1Am+v6fIJLXoFlWHlGloKtAZsXf39KbJfRJyygcGilVo87u0AyIqY8Hi19BpH1M6rJeKkAWbb
 x6lV2w2uaRnCXoiyNeoOuYkW4M1Y1VnFHrTzKl7NOMJZBC2MZBn9CkC
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH7P220CA0106.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32d::7) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DB8PR04MB6956:EE_
X-MS-Office365-Filtering-Correlation-Id: afd186eb-4e37-46ab-2c82-08df22c44dc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|19092799006|1800799024|376014|22082099003|18002099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	HZVQfOelHq8NQUrklIF3A9Ze/BkJ2tDDwDyE+v5m9Tg6qpxED72bJBAd01IumV5eeUPuUKneK8JfFKz0uUasqSH/1EQHapF4sAwHBQmysxdIYjD5SdLcWOprsvDnUKMQ8cB/xnINcUp0vOCUlcKG9O8tQ/HLjO8mz2dnSpvlA0vbqwNbwvD4L+EMB+Oi3KlYSYin87Sa+lz74QIJcrElQOjZ+AQJkVgwYHxRjLblRRLTJH6d/hDUVOwllX2JL8QR5M+V5wNvol0EvR9rsyKSwvO6XRqGpwOGQKb/Jqw+DIUpCisFmohNA961nc1ka9m/Ai/FuPGfZY1a6z/iTnTCiHX+7CEUH64qiQ1ezAsUxi22tw4pPqQPQl7BgBZ3Yk2n+RC2gKvO3/nbAn85FTgS3I2FW4RzeUK6sQ3G8xXT41hh3YCFdpFhQkw4D6K3bdRjCnmc8cQjIHEUPM093xV5g/zKZYy9VqJiOWyeCTR8qzX66PHaXU99/LFwCU7aKlCcMLPDPBVMbceVY/DVCNX4KPpENRHvHL/Ea4IkWFO90qqcbXe/FghRpia64CJVAULsLXvto2W3WjY3ctm+YQsoZ/oM/WkX1/cBLzppI4GuraBRYrFufxXm8PGWxncSQizDpB31brDdjrcQbZuiQqyyK41xCQRJ68r0wnaatpWh12U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(19092799006)(1800799024)(376014)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aU1VLzVtQWY2V0tpTi9IVHhiVUlCbDZ2OUh1UHQ4Q2xvL0h4Q0RNMUxsalZn?=
 =?utf-8?B?V3VZRWdpMnFEWUZuVmlaeDk1OTJoSHIrYWZJZCtEWms4aVhCYmRJUDY2RlJQ?=
 =?utf-8?B?eUhFV2lhK2ltQTRQQzlHenZYQ09GbEVZM2NiRXo2U3czbWcwRFdyRHVCWld3?=
 =?utf-8?B?Ni9EaGNkYWthbU9lc2FJaFB5Sml5UHV3ZzNGT1R0Q3ptenVEeWhtMjQvSzBn?=
 =?utf-8?B?bHkvTmlCQXNSY2Z3bExST0dhLzFqdlNQUE9RVGc0eG5zNENCQ0duRmJFYWtX?=
 =?utf-8?B?aFBxbmxYRmpxQXExNEVmQkhSSTF6SEliK2ZDNGFsZWl2d2tGVUVzZjB5Qm82?=
 =?utf-8?B?bkJENmljbTM4cjlBczNXUnJVdWl3Z3pSMlJoaFpqZmRRRk9IeDhxVXFNMitB?=
 =?utf-8?B?aXljS2JodzQxWEZITjdHa3N2T0duVzFWY09YRjBWZ1hJSzNTd2FPclltUm91?=
 =?utf-8?B?SzQ0M2dCa0V3ajdoZzk2T0NlaEk3bjRTZXRsSjdEUHVBdFdVWndJeVJyZlRr?=
 =?utf-8?B?YnhOVThha3h4VldlTFMvbEEvK1RLdDBTblhwRnFacVlnR3FYUXo5eWZDbFkw?=
 =?utf-8?B?Tk9ESzVkS0RMcVZjSytaTzdtZGlxSEtwdkVJMWhLeGw4Mm1hNlB0MzVjL3lL?=
 =?utf-8?B?bitZNC9wZmtEMXNhYit5NmNGLzhBR3VyQXJnR0lLVFZCN05FVzlYbUI1em82?=
 =?utf-8?B?KzBUallsaUwyL0RnYzVKckdlQWlmWEJRbUg5SmpUTHMxNU5heTFCU0puOHFz?=
 =?utf-8?B?T04xb1FjMVl4WEl5WjZmZ0s4TzJLOTBSWGEzNVcwV3BMS0JDamthQUxUQmNT?=
 =?utf-8?B?RjRKbGN2K2tJa3NVREN2dXBNWWRhaUdWclJzcHlLUG80RGpLblBxMDJDSURx?=
 =?utf-8?B?YWYzYlBRSzZ6THBObWhRK0UxajVUMWFmVm9Hd053bnFVdUJBcHVDVEc2Snln?=
 =?utf-8?B?K3gzM2ZzM00zQnhaQy93aDF3RlZXN0xkUjAxRmQzaExLQ0wxYXQzci9lY0pm?=
 =?utf-8?B?dmtGNnNuM000MnJxbTF4aDd2dS9PZ3FrYVVWUU4wNllucEF5N3hybXd5V1N4?=
 =?utf-8?B?UXBKNWpPVE84WitKWjV5czZyYWZrTis3Vml4OGgyeHI0VFdZNk92bzcwMVFk?=
 =?utf-8?B?U2JHTVFKazZ6cjBJa1Z4R053U2wxMEs3SDFBbU5KWEMzUWhGbkdoZU1Pd2FE?=
 =?utf-8?B?dE5IeVVwYTRMZzg1OTRpdWo3U0syZlgvOFJSY04yZHlxNVNHSU1CTC9DYU5y?=
 =?utf-8?B?ZHdWRDl4K29iOUdzU2UyRnVIRnN6MGlNU3ZucWtGWGpNVUcyZDBad3ZVUk1j?=
 =?utf-8?B?cDFtWWZUN2VLeXJXRlZFcENFWWpDRnA5Tzk1Y1g1WVlVTXVJTmNXQWFqa295?=
 =?utf-8?B?b2JPRHg2K016cmVNZmpHdmhYT0M1SHBLNHJoc2NRc1ZIWXRSMitDSEpZL1BE?=
 =?utf-8?B?Mi9adVk4c1ZobVkxMHM4b216TEdVTmgyUjErRlB5aXJ0VjluZTFJQ3dIVTc0?=
 =?utf-8?B?Q1JRQjQzRVd6WUZHV2YxQ1JuOUxNa05PaVJTNklVc1grZjF6aG1UQmxCZjUv?=
 =?utf-8?B?L1ZWVDRwNGJjR3IxTmJUcW1EdE0rYnFIM1pvQWRkMnBaRDhESzh0QkpLWXcz?=
 =?utf-8?B?RlF1V0tNRjAxT0wvb2dsVU4vNjRUdzU4cExpK25BNVVCNWhYbTVDNXprYjBv?=
 =?utf-8?B?WGdoNWNOS3cwajEvOFduSHM5NzRBKzUzb1RxYlc3RHUvU0lWMjJLbXl2SGRp?=
 =?utf-8?B?S3lsc0lNbndVRmk1ZlRJamZLNjE3TmVzSHN1bTZHUlprVlFQMGhYUkY2dklF?=
 =?utf-8?B?TFVIZG1Zb3BXQlJiank4aWh2TDFrOUFpNEVwWndFbUo2UlBqMStZWGJkT2FZ?=
 =?utf-8?B?OUEwTU12TWxMYWRMaUdjcEdYTlIvTmNCc2VMem54SVFOSHBXeGZYNnIvczZD?=
 =?utf-8?B?T3Q1SmdOVjgrVTZNUUZrRGJjaTk5MC9nL09GWFo4L2xSQnk5bnErRWdkRVJN?=
 =?utf-8?B?VnFkWTZlZmxPYStTZi8rSHgyNlUxWkt3K2dBN2xtd0NzS056ZDBUKzhFTEp3?=
 =?utf-8?B?R2J0OFBMeGlhZko4Y0tlMEFGYUNkL0dURHhvUFIrVndwUWYxeTlQenhhcjhQ?=
 =?utf-8?B?a09DSExVeTl1MzdSa3FZZjJLVVVhVHJ0QWZUSnJJYk1RN1N0MEI5SFFibWl0?=
 =?utf-8?B?NjBDb1FhbHJ0RTZ3NzJHNGVubmxqS0Q2UmphSTEzeERIRmRaVzN0dGpCbFhD?=
 =?utf-8?B?bURaalhLL3dkTjM4MEsyZ1c2T0RRdTdGblVqNzRDdEI3U0FiUDl6U1JURHdN?=
 =?utf-8?B?dzNwZ1NPdTkyNW80b1NzWFQ2YitkQTgyZER3c2lWMUxyZFNOcTBSUTY1Q1N4?=
 =?utf-8?Q?tohoYonPUSQ4pGOA=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afd186eb-4e37-46ab-2c82-08df22c44dc6
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 09:37:42.5302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJEDDL+cwpclPppsYqUb6oNOfEUzxcz/2KpFhCd9j3eApOzjs8fW0u7ylDB4Cdi1T128OTlx6Zf27CwbhFWruSO0wekngUI/EKb2nYmYAkOfGnNO+JuCwIU24QA3/zLa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6956

From: Frank Li <Frank.Li@nxp.com>

DMA engine consumers typically hold a struct dma_chan pointer and should
not need to reach into struct dma_device directly to check alignment
requirements.  Add dmaengine_is_copy_aligned(), dmaengine_is_xor_aligned(),
dmaengine_is_pq_aligned() and dmaengine_is_fill_aligned() as channel-based
counterparts to the existing is_dma_*_aligned() family.

Each wrapper calls dmaengine_check_align() directly with the alignment
value from chan->device, keeping struct dma_device opaque to consumers.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 include/linux/dmaengine.h | 64 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 6a187136f9493..1efb04e137673 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1537,6 +1537,70 @@ static inline bool is_dma_fill_aligned(struct dma_device *dev, size_t off1,
 	return dmaengine_check_align(dev->fill_align, off1, off2, len);
 }
 
+/**
+ * dmaengine_is_copy_aligned - test copy alignment
+ * @chan: DMA channel
+ * @off1: first buffer offset
+ * @off2: second buffer offset
+ * @len: transfer length
+ *
+ * Return true if off1, off2 and len satisfy the copy alignment requirement of
+ * the DMA channel, false otherwise.
+ */
+static inline bool dmaengine_is_copy_aligned(struct dma_chan *chan, size_t off1,
+					     size_t off2, size_t len)
+{
+	return dmaengine_check_align(chan->device->copy_align, off1, off2, len);
+}
+
+/**
+ * dmaengine_is_xor_aligned - test xor alignment
+ * @chan: DMA channel
+ * @off1: first buffer offset
+ * @off2: second buffer offset
+ * @len: transfer length
+ *
+ * Return true if off1, off2 and len satisfy the xor alignment requirement of
+ * the DMA channel, false otherwise.
+ */
+static inline bool dmaengine_is_xor_aligned(struct dma_chan *chan, size_t off1,
+					    size_t off2, size_t len)
+{
+	return dmaengine_check_align(chan->device->xor_align, off1, off2, len);
+}
+
+/**
+ * dmaengine_is_pq_aligned - test pq alignment
+ * @chan: DMA channel
+ * @off1: first buffer offset
+ * @off2: second buffer offset
+ * @len: transfer length
+ *
+ * Return true if off1, off2 and len satisfy the pq alignment requirement of
+ * the DMA channel, false otherwise.
+ */
+static inline bool dmaengine_is_pq_aligned(struct dma_chan *chan, size_t off1,
+					   size_t off2, size_t len)
+{
+	return dmaengine_check_align(chan->device->pq_align, off1, off2, len);
+}
+
+/**
+ * dmaengine_is_fill_aligned - test fill alignment
+ * @chan: DMA channel
+ * @off1: first buffer offset
+ * @off2: second buffer offset
+ * @len: transfer length
+ *
+ * Return true if off1, off2 and len satisfy the fill alignment requirement of
+ * the DMA channel, false otherwise.
+ */
+static inline bool dmaengine_is_fill_aligned(struct dma_chan *chan, size_t off1,
+					     size_t off2, size_t len)
+{
+	return dmaengine_check_align(chan->device->fill_align, off1, off2, len);
+}
+
 static inline void
 dma_set_maxpq(struct dma_device *dma, int maxpq, int has_pq_continue)
 {

-- 
2.43.0

