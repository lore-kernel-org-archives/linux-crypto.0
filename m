Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011038.outbound.protection.outlook.com [52.101.57.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D207B3C09F0;
	Fri, 15 May 2026 02:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778812514; cv=fail; b=p5iwTzCXhD6HMOYE0woHqtzcWwfJmR4nq6zMnnmEISvjDiBY9feNoWslWVXE6cijPDc8PnL9Pk0mIL7Si30/AdTf1CYhbe/MwL/gNX3KZyAz5FOuArPq1UlEe6FCIRVq7GA8B7Kiy8dVgnKTY1P16aM0UVbYh7KL45PWgfTW4uA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778812514; c=relaxed/simple;
	bh=obkBgJ7siV9U3brH1rgoEIABVwl0cP52k8oTb9q7fWQ=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=Nkl0G5mZhHLC0QKoZHyfGCznf4cVSA+s9qESE9Ub6p0V8LJCtd+jD22tFsFTmQLm4CGXjSeVQqvTjBLEvsk7xEX8pwzCuo2WwpobL2ARg5IESVSyUDlrM65kiRQh3RYRGNeSVZcoQxgW7/ICDKUMfS9inXDo6jQee3hE/0ExkLg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K0pPQ/e0; arc=fail smtp.client-ip=52.101.57.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K0pPQ/e0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=huKf7BGPWpFj6qrGPN9VTpayukn0eA704G16Wn4eGiqRjHWdt2anrGs846KsFkjRXcak3JV/CicnwQSKZD2Cs6dLvLyyavdNwuLcJEtpQVMr+srClUETA1lMyKPSGtjg9d1CbFdc3zDQI5WLpDaEA4wr0OM3BgbQ0Uj/EE5gz0GllThwfF3XCxoWwFLRqho5lBFCmMJAa6uNSx1AdSOIbUAKs077E04toUp7XcMDUs8PHYowibW45nybDbrT3wgeSRJNnC95j3tnFKO4vcZ7nQMF0GoTUXXqTtEbj0vIEWTl8vKM+dscncpYtc1AM/Kis4/mFiRM/oX+2i+DRldOzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ETuUQUYcSyn/4TEvLlH4ZnBlZsMp1lDqM1uQbHHb714=;
 b=bhH8ZCfw0twpCRnwJtkCEyyGDZixzaLPNQcYyXYrG+tB7NxCXAHeD3VrGqEJ7wfPk58dqokHa2htMzjF0mtALCClKjF+Byf4fakvOVeGYsk+0ZQgHvqrjd2rIssv5M99MsUp9NFfpFSZqRqqODFxTHA+diIoxT1+44ex0Dbiv8ZJCxYDy2ZVrhQmJmmazlc5x3jRfOO2j4XaA5x2TgeoMmTki9kfsUJAJuGg28e8SGglZiVCkGGoKMCIsX3I3BsRmMTBHHFaGKJvyI7AEvm+JIOXcWb/NHeG87mMhqKFM+d8B/fvlWcEq2DWURvIXlQvmaUYOb27uRZls0NYrJkUKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETuUQUYcSyn/4TEvLlH4ZnBlZsMp1lDqM1uQbHHb714=;
 b=K0pPQ/e09+btxNWNFXK39jUVcuIkRbPI9UxhBsZCYay0gf6i+vf587i9kAYFtw2SUQFjpsUrUdpEgucKvvxbNAgcjShwoSjMYBakSsD3xJvLQf8GFQ05sPPTGtDz98NCHeKjwqR09AmQjEKOXdgtHpbWXeyOJotex/Es1veY7nQpcb9fNlATSH+ZjUEbDYszHmARjbGxMzBfSvjZlrDKQyeEMTsqTvLh7WYwFFaGtSiPt9udiYAvwRinz7oaXS8LYLp8zfiLQnrmC9/1yW6jrCUz0elGFm1QXQ3FQuVPDwD/5gdCJJPbcBSBdnlx1VklQPUTA4+lEf1lhdskogoG2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB9161.namprd12.prod.outlook.com (2603:10b6:a03:566::20)
 by DS7PR12MB5768.namprd12.prod.outlook.com (2603:10b6:8:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Fri, 15 May
 2026 02:35:04 +0000
Received: from SJ2PR12MB9161.namprd12.prod.outlook.com
 ([fe80::d9d1:8c49:a703:b017]) by SJ2PR12MB9161.namprd12.prod.outlook.com
 ([fe80::d9d1:8c49:a703:b017%4]) with mapi id 15.21.0025.016; Fri, 15 May 2026
 02:35:04 +0000
From: Mikko Perttunen <mperttunen@nvidia.com>
Date: Fri, 15 May 2026 11:34:52 +0900
Subject: [PATCH 2/2] crypto: tegra - Don't touch bo refcount in host1x bo
 pin/unpin
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-host1x-bocache-leak-v1-2-a0375f68aeab@nvidia.com>
References: <20260515-host1x-bocache-leak-v1-0-a0375f68aeab@nvidia.com>
In-Reply-To: <20260515-host1x-bocache-leak-v1-0-a0375f68aeab@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Jonathan Hunter <jonathanh@nvidia.com>, Akhil R <akhilrajeev@nvidia.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Aaron Kling <webgeek1234@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
 Mikko Perttunen <mperttunen@nvidia.com>
X-Mailer: b4 0.16-dev
X-ClientProxiedBy: TY4P286CA0071.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:36d::7) To SJ2PR12MB9161.namprd12.prod.outlook.com
 (2603:10b6:a03:566::20)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB9161:EE_|DS7PR12MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: e6c6e5ed-0376-4ed0-2e76-08deb22a91eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|10070799003|22082099003|18002099003|56012099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	s3hgXGXsmQBWpzq+ucVM4/oH/sIaKsTknUtuRhiJskltMpmtPaOIhvZ8v0WWUaO4KENWqSklCV+Wg1CjpqndzPIX8ekHxNA5cpsvZuBjKxW1OWdNoe7ZFtXr+IzVkiinCL5ZRAIYkqIQIW6ypTM8VUlJg5ogL+qwx5FhS2YouekSSj1WgoOkmIc9KoUlbOhf6B5GIEqRPBSrla67OAgHd/Fouu6xk6bUbntLSjRaIVxncC4mfcAK+fN5V99zzD1Li1ZlXH2QXPuZgpz8rwK9r9KGY7HeGFNm5mN+yFy05i4ZDIcy7eP6aAXfOsRA2qT0ySQyBHNFe97powO7rw98FS2pt2GLTsPN5zbhv/hW0fUjVnodCK1YyTDtTFq1lol9KAVRurwr6bQlIGkYBTn/fRJMJU+U2CSoSiX62404SqSNqjEKbu6hHDHrqK7ZMxTGMQ5SatY1sYBkpZaD7+RSVXAcI81/pKJyTNMAzCuZc1luMG+NeHsR5P/KMgQmtxqnnW4vuB028KgAHlnzPOFaAic5KvDYBxIo9/rkEBviPw4us0smVQaunLrbv98wqmzkO2BU8SLzhYS9CtNRUtKg2Oupng9sqTXN19eL6KiIEs4ITm/PQrn+P+OzZGoDFOhaIsXg9prjig0MLgtNnG4BFdk4AhKSTPk+b5wQoKrWoTYWuQ5Z7eSunL3EWxp6kaTJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB9161.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(10070799003)(22082099003)(18002099003)(56012099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXZDU2J3OGc0c3JFc0luSE9XMWRHWURlNWZicFdkOXdTNjJZeS9xbFVuYzVF?=
 =?utf-8?B?K09ZeDkxeW5lRXhHTGFpbDhrZ25hMzhEcFVnVlpxb3dhOWRvR3krclZ6WG05?=
 =?utf-8?B?WHdicnZnRWkzaWthU2JqTmlpRXo0U1R5ZHk0NU9NQzJaWkM2eDVZZWg2VFlk?=
 =?utf-8?B?bTA2M3F2eDVPdjVNUi90WCtTdmIxZndEeDZLeTVxK0VqMHh4TTI3VXViRlhJ?=
 =?utf-8?B?V3h6R2FpMi9uNmRDeU1VR1hjZDRYMkIvYmFIbDlsUXk0cHpSNzlnTEVIZ1lt?=
 =?utf-8?B?NEJ4UElGRWNlZVpobjR3VGtINlBKK3E1OHVsUGZyeERFYkJtMWFobHdGbzJX?=
 =?utf-8?B?b0pTek5hbE4rYmthYzUvMUMxOGJYdUpnUnFKbFNWY2dVVkFLUzJHMzZaa1VX?=
 =?utf-8?B?K3RlUUNESXk4UmtzWGcyMkh0TEFKajJHYWRLN0V6ZFBqd0E3VjcrTW4xb3ZR?=
 =?utf-8?B?eFk3dCt3ZEdWc1JWeTFkbmR2cnpLblpwaHZKcFFlNllkeDNGaEMzc3Z5UnRu?=
 =?utf-8?B?L0dZWGdHeHgvY1JlOUVVME8vNmNQTy9LZkJ6cDRHSit6QVlHTlY5TW5zOHZh?=
 =?utf-8?B?LzBzdFBFODR5dGkya1hVT2M4eHVrR003bjdPMnVER01MWFlTbDdpTFNiYjh4?=
 =?utf-8?B?bkRrR0E4bTZOdU9pSjlQNUZMUCt5d2tGa2d4UGQwbjVnK3pZUjdRb3FmRjA2?=
 =?utf-8?B?cEFSTUJVd21qcEpLbGdFUEl2SWQ5ajk0bUxrYWJBN3dCa2dmZVoxTzZJZmc0?=
 =?utf-8?B?bUlQUURHVlJWU3FJVEpkR2RtTm02aWpYSVd5bjU5eWNMN001RDUzUC91eDFR?=
 =?utf-8?B?bWlnZHEyVG9SMk1tcTdwd2duL3E5N1BZZUFVTmRRUEdzdnhTNFZZNU9tdFoy?=
 =?utf-8?B?RzhrcTZuUHRaQUVPb1U5ZlI4b0hJcGsvRWdnV25FaXVJOXU0LzIzVDRrYmxR?=
 =?utf-8?B?WFROMmEvbVpjaTN1cEt4MXYxUVJRUEVMdFEyYVlkYlNiOExpVERGd0R3N2FO?=
 =?utf-8?B?U1NLbEZPakExY3hhRXJlVkRCbVFSamxQM3FhVlNIcW5GUUp5NzZLTEVvbEtl?=
 =?utf-8?B?M1pPTjF3Z2tTUDd6eVZEeWM2SG5wTW1HNXBkc0ZhT1R1NTFYUGlVRDkrNzd3?=
 =?utf-8?B?QzZzTHVNOHRkd0VqUE1INEZzdGZId3doUVRnMU1MaUNoV3B1Q2dxa2dqSFFF?=
 =?utf-8?B?c2NHdFBBcXFLZkZiR1htbzAvekRKTG00MFEzS0xVK09vMWRYWW5hditxSWxD?=
 =?utf-8?B?Zkh6aFFHNC82c012SGtZallmZy94ZnNvN1ZiYXVkdHRBRHA2WWltUGxaR1Rp?=
 =?utf-8?B?OFM2b3hONUtocStRWkxndXo4NE1DdDdES3NFemZlTmFvWkViYWtNdjdLSkp0?=
 =?utf-8?B?L2UvTk1OWWZLV1Z5TjM4YjVWUjRUV295aTlKSFJQOThjd0NERXF0TDVqclM2?=
 =?utf-8?B?YWI5NHpGR2JMSTVpMjk3KzFLZVdaMC9BRVg0K290UDhHUlErN0R2ZUJ6ZWJi?=
 =?utf-8?B?Z1ZiSkp0NkFnRTVGMU1FeVo5N0VxOXFqY3I3dVdtUGFBQzYyaXVDZ3Z0eVpJ?=
 =?utf-8?B?ZGxFREU4OHhsRStIdlpwZDI2VEJnbDd1eDUyZGhacXRodzBBSGtpd1hWMURl?=
 =?utf-8?B?OFBSTnpsd1NIc04wdVdhMTgxMnR3SjBTVURXNFQ2M1lOUGhTK1RHMDloRVk0?=
 =?utf-8?B?OFJGU0pSMVhBTFlTYU13eFEzczRZa1Z5VmJIcHIxdDE1V0drNCt5T0FEZzZl?=
 =?utf-8?B?d3M3c3hGVnBQdnhnYUZ6Nm1tU0ozaEp4QTJVM0JVNXdCaHZaWWMxMWUxNHJB?=
 =?utf-8?B?djJ6aTBtdzJOdzNXQTFwa01qWGVtbzUvWFZHRC9TY0J2RkdZN2l2Zmd4aVY5?=
 =?utf-8?B?UEsvN0had2QyMGNCKzRQRzE4bGw5YytNRytxczFjNEdaeVBOZGdvNmN4dDlI?=
 =?utf-8?B?dXVTUzM5NDdycnhWQS8rL0dSNEUyTDBHOTZ6cGx4U2NSUE5Fc1FRTlhqcjdQ?=
 =?utf-8?B?dFpBZHEyUE5rd1pESnBuT1I1S1lFMlF5Qm5mbWErWVVqVkl3MVhKVmhDTTdv?=
 =?utf-8?B?TnB2NDUvbmZ6OTBlaEoxOUVrMlBBMEo3QjliRFNQRmVsdWprZmNCa3VTMWRt?=
 =?utf-8?B?SnV4VTh5NElNeDlsTkxqL3gyL3d2a2NUd3FxYkVTWFBHaVBqOXpiRU9PZjhL?=
 =?utf-8?B?RFdIcnZhVzdwM0h1VWFFN245SVhQbWdoV1VaVVF4OXhPcmRNcmZGMGRpQS9k?=
 =?utf-8?B?dmtjNWRzUHdEdkxrdFlBQm5aNG9FOC9UOU5iUmFZSFpXaFVuaXZDUDg5TU1V?=
 =?utf-8?B?SGVkK0w3a05uNHZDZHBFQXJnMFJDRHpNd2tyN2lTZWlkZEl5N2wyVXBROCtM?=
 =?utf-8?Q?sM4pfP+a+KgTM5hHhjiQSPK2JawiIBVKsyDdfu3MQVa7u?=
X-MS-Exchange-AntiSpam-MessageData-1: JAcIyQgqHckD8w==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6c6e5ed-0376-4ed0-2e76-08deb22a91eb
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB9161.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 02:35:04.0915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B33s5h45QEMiwkoM0u4OkElEAf2qmF7JAYL95GSKEcctn20APRAXXu/6R974mCCptSF+hGYcgxrPoAG9TU3HAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5768

Since commit "gpu: host1x: Allow entries in BO caches to be freed",
host1x_bo_pin() and host1x_bo_unpin() handle the bo's refcount
themselves. .pin/.unpin callbacks should not adjust it.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-main.c b/drivers/crypto/tegra/tegra-se-main.c
index eb71113ed146..d7541a9c0a92 100644
--- a/drivers/crypto/tegra/tegra-se-main.c
+++ b/drivers/crypto/tegra/tegra-se-main.c
@@ -52,7 +52,7 @@ tegra_se_cmdbuf_pin(struct device *dev, struct host1x_bo *bo, enum dma_data_dire
 		return ERR_PTR(-ENOMEM);
 
 	kref_init(&map->ref);
-	map->bo = host1x_bo_get(bo);
+	map->bo = bo;
 	map->direction = direction;
 	map->dev = dev;
 
@@ -93,7 +93,6 @@ static void tegra_se_cmdbuf_unpin(struct host1x_bo_mapping *map)
 	dma_unmap_sgtable(map->dev, map->sgt, map->direction, 0);
 	sg_free_table(map->sgt);
 	kfree(map->sgt);
-	host1x_bo_put(map->bo);
 
 	kfree(map);
 }

-- 
2.53.0

