Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011038.outbound.protection.outlook.com [52.101.57.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D433BFAD5;
	Fri, 15 May 2026 02:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778812512; cv=fail; b=aFBhvSlfYrr2fIL+jyj8i60w2hAcVXSv5XUSLIsbqnCixSpoUVZsOPbDaLbXURWiJK9H/BXucn0Mzq4fRTOVn75Hs+IR9Cxoijmgt8SEQ8D/uys4UCn11ILt14s+WMpBPy+yNt5/RzcGBnVf8CAF/v88l0YjgAHcja2Ay+9Au2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778812512; c=relaxed/simple;
	bh=XLivQGvAp3ys7FbKtv989yJyZU2v7Nbm3qDUZ+mrXto=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=uL4GNzF3p7mKAVyjvb2dlD+DOqERiMSCUeUMjVEnL5kgzlnTtmqNNko99JiSo/9TYAdnOZqKWrUAorMWlzWzxMIwcEAcYumJdurzzFtm+8movjjXwgCi5R1oa64HBRJN84NPHrihhe5rPWqtgg61uiTF6PbNwpI/JAMMoM/NEQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FbaXuC7e; arc=fail smtp.client-ip=52.101.57.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FbaXuC7e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jCRS9C54CRA8PVShmlp2UYrvTUEbCGjj5IyXvhFEEX1EM88j06nVtvoYnvQYVN080uI9cAgGUZYtD51FdWHIIrI03h46iNsOccvIyb883EDIjMoBoDgFOAuVrVmGLaN9CDkFi0xdGg+jfSJCClIQImec42tq7Oh3jy1maNG6AvP+WPmSl+PFd/FPilyCy50oWv9lyhXMTwExnjocyoWX3h9yetfxAIhfhKHy/Gp1x36bKAkcNv17BENn2Yftt/GZUMa9GKuzFkxipEZszMRXT6v8FB78WrXa0JHGIluya5QwcK0T4Zd4nrlvuGdPdFqr02AV5gjlxF2FyoxSUpPzqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UnetqmXittDaN/ciA3HZxILGrGHT71bB3zFnsrjN8IE=;
 b=fbBJ+9xC6FjNxhzRUiv1REASoPFDZLVcEXrdh97lqF8Y9n741kN8ia9pZ2NAGA7x2gr5LOhZ8vwJBMWnjwcFE3D7OrHjKNfM+57/VqufdTlWoOpD11Rw9l2J29GP6HV16VEvHgFqnC6Mr1SyEzyC042hVak2nj+/e4iATDBrpxV5LL94QriROnPG/zgC4Vf91RgU0Arm75OEYAP6/9vb2ZDJ+PdElaogwvKcfEdgWAY3lYdcd812OM+AVZ5EfiSA1PBJagIai/EQgZzw5YjeoVC2dUuJsoQ36pMDuATPsuXPEY501qWHJqvI2ocFuqPbeOI/8mNX7SDFP5f1EdoLzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UnetqmXittDaN/ciA3HZxILGrGHT71bB3zFnsrjN8IE=;
 b=FbaXuC7erZNzTIDtYgA4HOPrq86IxNs3x6KzNQEBUkgFCCicosQxftfsJIFeLI1XhHTlCOHLcv2+v7VoRvVObRzndjeCuJsRFj/wXNPJKiz46JbqK02fC3Z5W8Lms9RjYwgmrrov77Yo9s5Lo74JT7HvAZ/WbLD8YWd2yOrlAXir7kxSoCWZ9GRB8PkZt7UFuIyHRSEt/yY6Cjc03W9cMS4QMjbeCghZutmia2TRoM2gR0l4jnQV5BefJB0iRW4AG1sXBBG1qsPq4nI/PzFDyd4lVDlmpG98NHgQDvtK2hcRH0iwEiNMCcJKPvrZo3At9pw6eEihShH/fiRQ5Oy91A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB9161.namprd12.prod.outlook.com (2603:10b6:a03:566::20)
 by DS7PR12MB5768.namprd12.prod.outlook.com (2603:10b6:8:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Fri, 15 May
 2026 02:35:01 +0000
Received: from SJ2PR12MB9161.namprd12.prod.outlook.com
 ([fe80::d9d1:8c49:a703:b017]) by SJ2PR12MB9161.namprd12.prod.outlook.com
 ([fe80::d9d1:8c49:a703:b017%4]) with mapi id 15.21.0025.016; Fri, 15 May 2026
 02:35:00 +0000
From: Mikko Perttunen <mperttunen@nvidia.com>
Date: Fri, 15 May 2026 11:34:51 +0900
Subject: [PATCH 1/2] gpu: host1x: Allow entries in BO caches to be freed
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-host1x-bocache-leak-v1-1-a0375f68aeab@nvidia.com>
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
X-ClientProxiedBy: TYCP286CA0131.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b6::13) To SJ2PR12MB9161.namprd12.prod.outlook.com
 (2603:10b6:a03:566::20)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB9161:EE_|DS7PR12MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: 9da03d72-cad5-4eb6-95a6-08deb22a8fc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|10070799003|22082099003|18002099003|56012099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	mLZu7wpeOIMdJdkYS+ctNXIUeAe07Gj1auMLEWA0jxI1RsvqkHVHw5dO3nPh1uVdwSF2zni9Iphn9q9xAC4Ka/2rBCEk+74tpCSSo4PVYDPh886cnx+PyX8dUtif2kv853zG8NbU2ei6phT9RJpHnVjEX+utlnpmz348fLlTVS3RC5mUzXCpQshEDNrA1n8yiwYmtAR4IJ0xi+yF8jkDcHZPZfZa2BnyqkgRoCYeZBkMJxIYdqnO9CrLE5Wyjh5HHy7Qxq7OM9Xa10nzL300e+1y2U4ZQMiEB25TLczgzL5lWm7I/alUlOgXKd2Qa9JgMqZmzI/5sW2roQV4utEGYZJntL5kSzdj32UbBFsdTr00yJ7/XRsc4Bat1duQpd4XNAi5rkDdMNGxN2B4kh4Prt9gyWhDf1KFny8G9Mk5VqLaJrG0PCO+ghc6jRjxjbXAHVo/rWd0TyBD9XNdPxUV1EB4vKKEVPvKTq+9AC+XeSh65FVqSClR0x4zwwNQqXQyU6blI3Boda13zDaWq+ae060qND5na2UBJJVeTPul7NpRzDwVFXOGBqA3S/9cMug+M4P2dnq9UecSTuygjmhOiNmLGC6zG8KIHFQJxn2NmtVq7JvBj7MasjDN+3QPQq9/q9jHG2LS7Yq8JORli+SPAaL77V3OYKMuQRK+MOByHmEi8RQXOKiLUulm+sbv/Ez2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB9161.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(10070799003)(22082099003)(18002099003)(56012099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YTI3RXE0NWVrdVA4QXM0cGRsbTJBMHpydUc1VEhJSFNNdVFCQ1d5ZVdtaCtZ?=
 =?utf-8?B?UDEzOVdaeGxrWDRFaDBhZWdyQ1c5NWRObCtYamRnLzl3bzBJZ1gyR0I5UlBP?=
 =?utf-8?B?WmFNZmpTcGlNenA0Rm1LbXFnY0UvcWMvL29mdHlocGE2OHA5MDcxWno0TEZn?=
 =?utf-8?B?MGV5UGxtSFRrbWpvaGppK1ppd3F0MGpEN2lNS0k5WUxybnErdlVYd0hza3BQ?=
 =?utf-8?B?OVFrQ3hlMEpRdGk5TkQ5QUhybE04Ykc0SDhQTElIZ200REJpTTVWVTZ0OGhi?=
 =?utf-8?B?L0hmSGNEbjQ1OXlydURZR0ZueGVkdUx0cWs4RXg5TFd3SFY5RVR5dnBKS1N1?=
 =?utf-8?B?dG9wUzlvWmM4cmlSdTNjUS9kVE9qUWQ1ZG9TK1pVN0poS1dweXhoVC9DNXBR?=
 =?utf-8?B?aU4zMktSVXF6K2ZiQXAwVVZ6SWNsSTRiWG0xTCtSMDRnUkFmcllJaVdiUFp3?=
 =?utf-8?B?Z0lhdEY3dml3dHcvR2czdFJqRWJPcmtzbUNHdUkzZUN4RzVHTy9MR3E0bGVV?=
 =?utf-8?B?RDRXcDQxQjY5NkZLWUM5SEtOdFdBZGlHb3pXSE9rdGNUdlJtT1pSdDJMei9D?=
 =?utf-8?B?NjdMY0dYMjBwSVNudlNPaHdLWS9VaXZIRWxCMmNPS012MGRRakgxVVFlZnRr?=
 =?utf-8?B?YTlRT1F0dmY0OU5ZSWRMRjZyU3Z0aXVka3ZSYjgwSUgwQ1NROFZ2NXZNcEov?=
 =?utf-8?B?UmlxSU05dzJhaGRHMFloZWtySmtzOTJDVEYyL1o4TzNkZWVFUEJZdG9CYjlP?=
 =?utf-8?B?bUszbkJLY05DOFliM1VMNlZlSGxFaHJwTmt1d1RuNkRzcytock1VQjdwQjc2?=
 =?utf-8?B?byt0blZVSVo3QWJxbWdNRk1NQ2Y3MUNjM1lyWlFrMkh5UWE4MTdiV1hIcmNW?=
 =?utf-8?B?T085UWVsTnM1Sk1IUHNpYjdnSU1SeCtMaWxNdk42UUN2Qk9qdnY0dmFnWWZQ?=
 =?utf-8?B?S0NVbUVCNXUzZ25wZHNtY3Bsc3h5NTB5UU82dGlJQ1FsQTFER0EyMkhuWk5t?=
 =?utf-8?B?eUVJWTJoMGZTWmZ6R0VxWWxOSTZ0RjFkMUNrL25zUkQ2TzV6S25nVGhQd0J0?=
 =?utf-8?B?N1N2cTBsOGgzNEtCZ3VyaFhpeWRJRHlvYzBlZG5ka25rZG9OV285ekltekNx?=
 =?utf-8?B?a3hnVmpXS3hUMy9hUXMzQTZ5NVNkOTdHT3RZVHFHWVc0dU1RVkV1Q1VtdE8x?=
 =?utf-8?B?SHdGbnhtcklYY1Rad21KN2o3a043bmNMMytra2pQNXF1TzMza0pwUXZHaG5z?=
 =?utf-8?B?bVdkWXZqSlFRTzE1dEJVOFlCNkRJdUhGbnNoWHdOME0xMDltTU1IVFNhSU04?=
 =?utf-8?B?TGRLN2pkUmV5VlAzQ0tuTmcyVmFhbnFiWW8wS2x0QTBUOC83K001WHhsWFAw?=
 =?utf-8?B?aXh5S2NWZkdSTkhWV0QrOW9LY0E1REUvalZ0MTNmbCs0UUhxSjNFK1FNN280?=
 =?utf-8?B?djZISTVaYVFRZnlNMGFhZTQzZTkyTVBObnlWQ2dZNzQzejZRMExUY2dOY05Q?=
 =?utf-8?B?WjRaVDR0aHgwRUxpVUxHYi9aeVVKOGdUNkk0QWNYRTV1V3RHdStIUnNCdUsz?=
 =?utf-8?B?RkdQOGc0TFdLYStBbW1lcUVlQ1R5SWtXdkV3aHFKQ1FkV0M3dFNWeVhYL3Qr?=
 =?utf-8?B?bGRSMkJycWZFZzFydngxOEMxQzRzeC8rL2IzMFFSQjhsdFovQ0tpa3VtV0Jk?=
 =?utf-8?B?ZjM1QkFMMUNMb3owbC80L3hTUzNKWXB4MEhROXFZSDBhNEd1b2lXMnp2U3lv?=
 =?utf-8?B?bHVtWjk5eWhxeEs5elRiWE1tUEY5ZDlWZ2c0NG83YVpVR0twY0pIM09DclBC?=
 =?utf-8?B?aGY1UlZmaUQyeWZEVGUyWmwwcmZhTlY4bEVEV3p4T2ZzeXQyTVE5Zk5aSmZo?=
 =?utf-8?B?ZVhYUWNOb2pwTTZHVXFyRVRsL2tVbTIrZlRtT2pwQi9pNzc5NFhZSkNqWlZN?=
 =?utf-8?B?OHpnQUNjOFJ4Njc4bkQxeVpOWmpMTk5TWGdpQW11dnRsOE5Pc0JjZkN5cThU?=
 =?utf-8?B?MW9mYnRuMWxoRytZcDRybDM1L1ZLRk50Z29QdWU2VTZsSUhDYzBweXlzZkwr?=
 =?utf-8?B?c09jMlJvVUFOM1l6d1RSM2NxSUtkeXBEcSt5c3hvTWVIN3BOeFlVUUREU3Ux?=
 =?utf-8?B?b0JUd0xXNTlyd3hZRndvQk5SOHBBYW1aN0k5NDJiU1p1VGVLUExJYkMveVV3?=
 =?utf-8?B?VDFsd2k0NkhCOEcweFZqc1dYR2ZnRmpQNmk5N3Z4UXFPWEN1cC9YNVVaSDBN?=
 =?utf-8?B?eDRJNXpWSmtnRUNuT3dTZmE2WER4aklBL3ZGTUQwN1FWNUYxWlRKaGlhK2Ru?=
 =?utf-8?B?YlZMeUdOYWhINkFDWC9vV2Rzcys3SWRwdlFIaVQxOUt2RzIwTVNBYm9NN1dY?=
 =?utf-8?Q?e9bBwWXWhfWChOuCWF7jfZGZF/shjfe7dGV07i03CDnNJ?=
X-MS-Exchange-AntiSpam-MessageData-1: WDHbyXayXiSqzw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da03d72-cad5-4eb6-95a6-08deb22a8fc7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB9161.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 02:35:00.6052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7m4LxUxNNH/+JfDEH8aPDqOBaqIBnpKhPeEBoL/Qtwdj3EiRLQ26BJLcHzaIdhBe418mVN46jcw3nqgtCyZCsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5768

When a buffer object is pinned via host1x_bo_pin() with a cache, the
resulting mapping is kept in the cache so it can be reused on subsequent
pins. Each mapping held a reference to the underlying host1x_bo (taken
in tegra_bo_pin / gather_bo_pin), so as long as a mapping was cached,
the bo itself could not be freed.

However, the only way to remove the cached mapping was through the free
path of the buffer object. This meant that if a bo got cached, it could
never get freed again.

Resolve the circularity by holding a weak reference to the bo from the
cache side. This is done by having the .pin callbacks not bump the bo's
refcount -- instead the common Host1x bo code does so, except for the
cache reference.

Also move the remove-cache-mapping-on-free code into a common function
inside Host1x code. This is only called from the TegraDRM GEM buffers
since those are the only ones that can be cached at the moment.

Reported-by: Aaron Kling <webgeek1234@gmail.com>
Fixes: 1f39b1dfa53c ("drm/tegra: Implement buffer object cache")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 drivers/gpu/drm/tegra/gem.c    | 13 ++-------
 drivers/gpu/drm/tegra/submit.c |  3 +--
 drivers/gpu/host1x/bus.c       | 60 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/host1x.h         |  7 +++++
 4 files changed, 69 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index d2bae88ad545..2377e2b76397 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -69,7 +69,7 @@ static struct host1x_bo_mapping *tegra_bo_pin(struct device *dev, struct host1x_
 		return ERR_PTR(-ENOMEM);
 
 	kref_init(&map->ref);
-	map->bo = host1x_bo_get(bo);
+	map->bo = bo;
 	map->direction = direction;
 	map->dev = dev;
 
@@ -170,7 +170,6 @@ static void tegra_bo_unpin(struct host1x_bo_mapping *map)
 		kfree(map->sgt);
 	}
 
-	host1x_bo_put(map->bo);
 	kfree(map);
 }
 
@@ -509,17 +508,9 @@ static struct tegra_bo *tegra_bo_import(struct drm_device *drm,
 void tegra_bo_free_object(struct drm_gem_object *gem)
 {
 	struct tegra_drm *tegra = gem->dev->dev_private;
-	struct host1x_bo_mapping *mapping, *tmp;
 	struct tegra_bo *bo = to_tegra_bo(gem);
 
-	/* remove all mappings of this buffer object from any caches */
-	list_for_each_entry_safe(mapping, tmp, &bo->base.mappings, list) {
-		if (mapping->cache)
-			host1x_bo_unpin(mapping);
-		else
-			dev_err(gem->dev->dev, "mapping %p stale for device %s\n", mapping,
-				dev_name(mapping->dev));
-	}
+	host1x_bo_clear_cached_mappings(&bo->base);
 
 	if (tegra->domain) {
 		tegra_bo_iommu_unmap(tegra, bo);
diff --git a/drivers/gpu/drm/tegra/submit.c b/drivers/gpu/drm/tegra/submit.c
index 3009b8b9e619..e5841857c937 100644
--- a/drivers/gpu/drm/tegra/submit.c
+++ b/drivers/gpu/drm/tegra/submit.c
@@ -76,7 +76,7 @@ gather_bo_pin(struct device *dev, struct host1x_bo *bo, enum dma_data_direction
 		return ERR_PTR(-ENOMEM);
 
 	kref_init(&map->ref);
-	map->bo = host1x_bo_get(bo);
+	map->bo = bo;
 	map->direction = direction;
 	map->dev = dev;
 
@@ -117,7 +117,6 @@ static void gather_bo_unpin(struct host1x_bo_mapping *map)
 	dma_unmap_sgtable(map->dev, map->sgt, map->direction, 0);
 	sg_free_table(map->sgt);
 	kfree(map->sgt);
-	host1x_bo_put(map->bo);
 
 	kfree(map);
 }
diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
index f814eb4941c0..772e05a7b45b 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -887,6 +887,20 @@ int host1x_client_resume(struct host1x_client *client)
 }
 EXPORT_SYMBOL(host1x_client_resume);
 
+/**
+ * host1x_bo_pin() - Create a DMA mapping for the buffer object
+ * @dev: Device onto which DMA map to
+ * @bo: Buffer object to map
+ * @dir: DMA direction
+ * @cache: Cache in which to store mapping, or NULL
+ *
+ * Creates a DMA mapping pointing to @bo for @dev. The refcount of @bo is incremented
+ * until host1x_bo_unpin is called.
+ *
+ * If @cache is specified, the mapping is also stored in the cache and not released
+ * until @bo is freed (refcount drops to zero). This improves performance when a buffer
+ * is pinned and unpinned frequently as in the case of display use.
+ */
 struct host1x_bo_mapping *host1x_bo_pin(struct device *dev, struct host1x_bo *bo,
 					enum dma_data_direction dir,
 					struct host1x_bo_cache *cache)
@@ -899,6 +913,7 @@ struct host1x_bo_mapping *host1x_bo_pin(struct device *dev, struct host1x_bo *bo
 		list_for_each_entry(mapping, &cache->mappings, entry) {
 			if (mapping->bo == bo && mapping->direction == dir) {
 				kref_get(&mapping->ref);
+				host1x_bo_get(bo);
 				goto unlock;
 			}
 		}
@@ -908,6 +923,8 @@ struct host1x_bo_mapping *host1x_bo_pin(struct device *dev, struct host1x_bo *bo
 	if (IS_ERR(mapping))
 		goto unlock;
 
+	host1x_bo_get(bo);
+
 	spin_lock(&mapping->bo->lock);
 	list_add_tail(&mapping->list, &bo->mappings);
 	spin_unlock(&mapping->bo->lock);
@@ -918,7 +935,12 @@ struct host1x_bo_mapping *host1x_bo_pin(struct device *dev, struct host1x_bo *bo
 
 		list_add_tail(&mapping->entry, &cache->mappings);
 
-		/* bump reference count to track the copy in the cache */
+		/*
+		 * Bump the mapping reference count to track the mapping in the cache,
+		 * but do not bump the BO's refcount. This allows the BO to still get freed,
+		 * triggering the release of the cache mapping through
+		 * host1x_bo_clear_cached_mappings.
+		 */
 		kref_get(&mapping->ref);
 	}
 
@@ -948,9 +970,17 @@ static void __host1x_bo_unpin(struct kref *ref)
 	mapping->bo->ops->unpin(mapping);
 }
 
+/**
+ * host1x_bo_unpin() - Release an established DMA mapping of a buffer object
+ * @mapping: Mapping to release
+ *
+ * Unmaps the given @mapping, unless it is cached. Decreases the refcount on
+ * the underlying buffer object.
+ */
 void host1x_bo_unpin(struct host1x_bo_mapping *mapping)
 {
 	struct host1x_bo_cache *cache = mapping->cache;
+	struct host1x_bo *bo = mapping->bo;
 
 	if (cache)
 		mutex_lock(&cache->lock);
@@ -959,5 +989,33 @@ void host1x_bo_unpin(struct host1x_bo_mapping *mapping)
 
 	if (cache)
 		mutex_unlock(&cache->lock);
+
+	host1x_bo_put(bo);
 }
 EXPORT_SYMBOL(host1x_bo_unpin);
+
+/**
+ * host1x_bo_clear_cached_mappings() - Remove all cached mappings pointing at a bo
+ * @bo: Buffer object to release mappings of
+ *
+ * Drops references to any mappings pointing to @bo left in any caches. This must
+ * be called by any host1x_bo implementers that may be pinned with caching enabled
+ * before freeing the bo.
+ */
+void host1x_bo_clear_cached_mappings(struct host1x_bo *bo)
+{
+	struct host1x_bo_mapping *mapping, *tmp;
+	struct host1x_bo_cache *cache;
+
+	list_for_each_entry_safe(mapping, tmp, &bo->mappings, list) {
+		cache = mapping->cache;
+		if (WARN_ON(!cache))
+			continue;
+
+		mutex_lock(&mapping->cache->lock);
+		WARN_ON(kref_read(&mapping->ref) != 1);
+		__host1x_bo_unpin(&mapping->ref);
+		mutex_unlock(&mapping->cache->lock);
+	}
+}
+EXPORT_SYMBOL(host1x_bo_clear_cached_mappings);
diff --git a/include/linux/host1x.h b/include/linux/host1x.h
index 5e7a63143a4a..d8f052a85b75 100644
--- a/include/linux/host1x.h
+++ b/include/linux/host1x.h
@@ -143,6 +143,12 @@ static inline struct host1x_bo_mapping *to_host1x_bo_mapping(struct kref *ref)
 	return container_of(ref, struct host1x_bo_mapping, ref);
 }
 
+/**
+ * struct host1x_bo_ops - operations implemented by a host1x_bo provider
+ *
+ * @pin: create a DMA mapping. Implementation must not touch the bo's refcount.
+ * @unpin: destroy a DMA mapping. Implementation must not touch the bo's refcount.
+ */
 struct host1x_bo_ops {
 	struct host1x_bo *(*get)(struct host1x_bo *bo);
 	void (*put)(struct host1x_bo *bo);
@@ -181,6 +187,7 @@ struct host1x_bo_mapping *host1x_bo_pin(struct device *dev, struct host1x_bo *bo
 					enum dma_data_direction dir,
 					struct host1x_bo_cache *cache);
 void host1x_bo_unpin(struct host1x_bo_mapping *map);
+void host1x_bo_clear_cached_mappings(struct host1x_bo *bo);
 
 static inline void *host1x_bo_mmap(struct host1x_bo *bo)
 {

-- 
2.53.0

