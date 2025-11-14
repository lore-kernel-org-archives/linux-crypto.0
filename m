Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012052.outbound.protection.outlook.com [40.107.200.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2ADB35CBAF;
	Fri, 14 Nov 2025 12:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763123190; cv=fail; b=bf4Bjo3moraHQb2JcxNX9l3cxkrArPTLw+zeQSXN+KCoX5f6WuLo+LGEvTBjC3LMIzpK0s3igsRY1maME3pKRx5/rZldxDlcX27X8f5LJbhIYPnBoJFI8ooKRxV4lJr7Q6NcxJ7nU1zrLd9nDC19/VAmVoBoAhwcLt+hDbBWElM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763123190; c=relaxed/simple;
	bh=P1Z7UbezDRZ++JgdKwZxV7Kz4aCTyrGC9gTsIQaOclQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=AoleAqA+IaFHa7r/PdpLg2IQvIiOqPIW3YjA0oUpmkE014yvkS4H5uYNi1CmIjtyHcbXp5NmA198hp7cXYdT4V2MyTxzmiNRhYSuKvqdcWHIkwuoRE+0JAnwI++3HxykKLoZv6gslZzFKKzX6QW/p4LJ2U1j7n6zzajKHCPCfB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Bfeo5ele; arc=fail smtp.client-ip=40.107.200.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Bfeo5ele"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nIGyN5g1n10scvMjQWh7yWwNKdVrrgDDWBRjDZN1t7HzIRoxZIoPxpGVBKLeopSwgQYm3iRZJAcLvoGsuYPcna3h2GRAQrqvJ1Yw+ilMc3ipK2WXlVLT5dWupy4JnAHAs82z+qygghGpTzrZpNey5EBLe+PBvAPCQrlJL7P9gYpuBL+fRQG10aEq9zMOOTUPxfV33zo8aPdZzzgshc31KvKPGDQrW3EPUmPTlkplp37XOqDxiIDdLIkL2XdV7+sllCFoFzZQspoP6wUnbZkoRIfMDzys90vBHGBcnJLKJWeyzwmFdbDOTrVpViJiIZbqajEEJRAu4T00UkH2gIgc/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KBgB4YUBtpLDIioodMNTAw4p71N1uV2hlJNpOb7kBqE=;
 b=wImtTtP7IUsw7Ao1jirtSQSL1peuD7MZdK2G7HZF4gH1APqBdruF1AFORfNcTqrciLm1Vfd7oG8kWxaOxgr+c08uSizXBeTWxkgfDk5Gr3abrnBMFI0xqtuU5Q0u8ECbKyCNJCKmL7n1jLwZzaCbitLIhZ2p2It0FmrKTnLzwbs3LLjnudGBYsCjiSdPOTsMk7KSQsmw6fyJoQoONdY9hBA6cLoo1TeoEcGTDJg9H7KbS//fn+QPVPiwRKvXbSz4+14T9P2JdK3gAT5x0xEtlxx7eeIxMMKADVwy2DWLbm5cN/GI+IB32xeEvrJ06E2wQGAcGTcHUwG4gEM/jIQ1wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBgB4YUBtpLDIioodMNTAw4p71N1uV2hlJNpOb7kBqE=;
 b=Bfeo5eleCmD58kzty3J3VRPkUoJW0D8tr4dIg04STH1KYLoUPYEz7rmsJwW+OAkRateMqX99ZThUT/thDT0cLk0v4PWDOP7WszYSQO+70RZMkc0vRV4vCbyL8T3hvM3we3XAr0W5b4jRj8wN9wqNqMTDSF81LCxol0KH/NNdYizq11qxd7+Wb/fXM0zq17Kt9XeVJLxa+uC5mAAwh+tH3W1mcIkfHmt6VSYDnVMhl72U9h7AuI5Z5s60jTdTOC+VyYwUyqLh32z0ipp//Kvc+nzqmF9V8iu+LtJ8H2BwPqaPO7rVZR018CKsK3e+yDD1iKanZYaVHUVcTvbRC5yIAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS0PR12MB8294.namprd12.prod.outlook.com (2603:10b6:8:f4::16) by
 IA0PR12MB8277.namprd12.prod.outlook.com (2603:10b6:208:3de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Fri, 14 Nov
 2025 12:26:23 +0000
Received: from DS0PR12MB8294.namprd12.prod.outlook.com
 ([fe80::d6a9:5e83:27dc:a968]) by DS0PR12MB8294.namprd12.prod.outlook.com
 ([fe80::d6a9:5e83:27dc:a968%7]) with mapi id 15.20.9320.018; Fri, 14 Nov 2025
 12:26:23 +0000
From: Colin Ian King <coking@nvidia.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: scatterwalk: propagate errors from failed call to skcipher_walk_first
Date: Fri, 14 Nov 2025 12:26:19 +0000
Message-ID: <20251114122620.111623-1-coking@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0212.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::19) To DS0PR12MB8294.namprd12.prod.outlook.com
 (2603:10b6:8:f4::16)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB8294:EE_|IA0PR12MB8277:EE_
X-MS-Office365-Filtering-Correlation-Id: b8e41a67-c742-49c8-da8e-08de237905dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+IgATc0nRLFCPShwwPKe91Dhzc4dNylMKLmue9XX4cqzVx+DE3uYh3+3El8M?=
 =?us-ascii?Q?i6m0J4CV5dXRD+eTyjV+3AAk9qlaAm+vO641soxCNd/qa09KoQ5moTfTHXxm?=
 =?us-ascii?Q?NOcdIG6DUDh6KR++Gpoc3FNvkoc/T3N2jPX/MtOCL3JXfmJsvk4Y3hTAkwYx?=
 =?us-ascii?Q?lVGImMMsy9SzS1mj5EeMsJaftGckfyTj4eWdjCPhcW58lFaxHGh7bXzFQcZG?=
 =?us-ascii?Q?gCVs1YIaMWSIDItst7FZIuVZemwesea888ejMfp8GPPWZqG/XDX5wQBwIGAY?=
 =?us-ascii?Q?QJ148nb5nK/JX7ycxOa7K6oRKPvr/UWi+k7NMq97KimHGxSntG+3pl3/8CQj?=
 =?us-ascii?Q?kZkZl0Zn2uRZYzrbhmu9Z8HQu14GKIm/H8O8DQa4FkVXmw72/FxzE94EJWE6?=
 =?us-ascii?Q?I+WxLzwN/7NEZDJktcKQp34Qp2PGyn63NYh8gXc+0eBvJ/53bNsAWFPlQpx1?=
 =?us-ascii?Q?PIOS9H9x/RDoQKfe943o6GtaoUC0WdmuHrX8PlohtNaFNajT1lsLOea8jOZo?=
 =?us-ascii?Q?nAFORjhIlgAna2pr8ZjtfgN5NqfyqXB2NAuZ0Upx6kfkzwCrnQGUjT06oynB?=
 =?us-ascii?Q?Tk/SWGsYvrBQUXTN0/EVl+x+mHkSAuXGt9FlkpYDcewjD5wfbK4+vCdBJjvN?=
 =?us-ascii?Q?jByMktqTLRglkqV2Nf9gnMdHU7cRfQLsnbYlT5f/dsKyrLp3rGZnvLT70lis?=
 =?us-ascii?Q?1SQjfDMWQqAypU2LWRKg62+7kJ7E7S5mDm2H1bbdbnmEp0GWcCv08aHCyrHc?=
 =?us-ascii?Q?E48hpQ/VIBQ2usb/qrhJ7GSfPiudwHLCbFVoaMD2mQL82KylQqq/M6O7mt5N?=
 =?us-ascii?Q?MfmCbum1mH1SkrC/DQ/o22Uu4EPH7ln1CuYRNJwrHgxlwzOmBQ1ZYIpiwsdT?=
 =?us-ascii?Q?bcDov1rTii8RXza8MapAjquAdN2c+1++b54oel04iWfATrA9+y3P2ny+KlEX?=
 =?us-ascii?Q?rnlYTwkgoROX0dbPLDdgqUvSFVC/Mj+vDj9IqMsRc1KHv0iccLa3EvK8nqk5?=
 =?us-ascii?Q?VVmILRUwg+1HKwXPRF5G5ivneT0tTR+efuz9ASjG8id1EupAgAKxaimVaIgt?=
 =?us-ascii?Q?Xi4NS0upa+D3dHJ0C5z4E5AzEY23VuvDBFPH6xPb6f6qQhImRSRHIaXd5HAZ?=
 =?us-ascii?Q?LKgmXimiV8/cBBxcZq7UV6M2oSqaQy1TztJmv0cgiH9LzPa8vDKzERCs3iLQ?=
 =?us-ascii?Q?BVWNijs2iFxXyfCbl3bxtPTsn/a8xYRg7gx3NwtGoxJeedPhgb/6mlt/Wom4?=
 =?us-ascii?Q?vTvyRHO64wXYHpffDGyky8SokFRf//VrrC1tRv84tY01vQWHeS1Ff6MAhI+e?=
 =?us-ascii?Q?4nr7liFqaQnEewzTNrMz7FCQU0RkJksOYyNNXI/5WhI1tP6Av6pq/B3la+Mc?=
 =?us-ascii?Q?RUQApvLP5xBRj/4cwksPPpXPWJZ74YbKozgt3B8JUuxMG19GvC2Q0Y9os4uD?=
 =?us-ascii?Q?66Bm+9ppw/kMCI/l93e26hG3ndRLOYnT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB8294.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XAm6cfl/rz4XyO0digG5goK+DrCZyCZgMh2TmdSuOPLnHGyvhWfHxjzteTZL?=
 =?us-ascii?Q?3aVQ2KUfzc7yQcrj8r/SU2rb5/sOa5qr84Upooe5tVBA7+saUK9EnpwP+SSX?=
 =?us-ascii?Q?L2LX2bQAA75/XgHLYnO+RD470En2RYlEyjRUHwW/RmEnYx3K3bdRY7wMHThA?=
 =?us-ascii?Q?5EIN7NT5+NjZQjKEMP1KCziHxs7G0qxVPVoCnIE/xMWoYvlyDaLeqyagWD8b?=
 =?us-ascii?Q?rNrJbCb9NCV/TqE6W6r85aYVvyYg70Vnh8uB8O8+V4UCrwi4cYNF8KgY4LUr?=
 =?us-ascii?Q?ibkVfB8VtdnV19cwuz3Cb7YYY7kCViwWC6rneyZ3KbxC+zhsJa58Y+RjH7em?=
 =?us-ascii?Q?w9vL3o6KvpEPMNiXLgemRwWkfGvpiOUhWK1IiqgSNt08Yu6gulEIUeiJ9514?=
 =?us-ascii?Q?Q8xZ0FvDeF75295cp+apdjhqRcd3zZA/7eR/1374RALblDch/aGeEx/hZ4uh?=
 =?us-ascii?Q?wP6uRZcRF5SXMLdaKwneX1ed14CHnXlm79Xsf0+mHHHBSPSX9EasHFYNf/Xk?=
 =?us-ascii?Q?Jsf5Q/p8g8cvPA1mQqcoOb9KmPIcyy3FqFEoQoe0Fa0SWZ3MMDvS3PKYUMdT?=
 =?us-ascii?Q?60Q87oK7qzZ4JaIc4Euun14IhVo34sGyP2Y177JV+IhTr5yl7/H3m40q+cDx?=
 =?us-ascii?Q?IOa/aD1TJB0G/gnCmwQGp5UG0F3luwaikDfB7Y+4ZgUU1fJmDqzBFytwtv7h?=
 =?us-ascii?Q?UEMkX6/C6bhSTtCh/KXCx2B5aLjZEM4wtTLxbfgoCiO+CSlibhPGIurjBTrO?=
 =?us-ascii?Q?JW67yBLaPqAzNCFQNEQ8KtqnQNhbsa86tTeBBbBHH6XfRNhjGqC+cp+Jlnp6?=
 =?us-ascii?Q?Fc2C/twuepiwROcHym7fm1BRxsW/fiExnNxpuEh9eoNG2UHNJwkd5g/58rpj?=
 =?us-ascii?Q?2Z5Zeu8Nam6Tpuqwsa/HsvOj3pX4Dn4Xczti5cpN6lgVbHRlGMcPuKf+qHhU?=
 =?us-ascii?Q?KhnQF3Log6W/oCBXLSgE0wnjv0vfMIRKA9dRkeQAZLQMR5RYtNWfoj6z7DS4?=
 =?us-ascii?Q?oW/a6+JXrizlwBbxI/CeDkv3Dr1Yw1iezzT9oDqu/L67hp3vQgGjFCEjbV4G?=
 =?us-ascii?Q?BdaesM4BnMTOZlee5dEzGhh6hD4SJfo5X3+mk7VvYW/rNMJxw47ttJkQIBWR?=
 =?us-ascii?Q?qpW/OQUXa7Tyg+jMGB6DifhDY9vcOMuXOxAJFkTxwf2AeoLkwGf3Zj/tZMBL?=
 =?us-ascii?Q?/nzVW0smPqqTE6U4m0ntv+DwmzgzQD9HwA8+rJxEdo3OF0ACxtGCbMUrkyQv?=
 =?us-ascii?Q?ccEUurhSvp08luQvnfziZg0oAoYo7dTDI6an3ztjHlvHkAxo1r1ci0BYxofU?=
 =?us-ascii?Q?PN5/SCc+dXt34KEQhALcEmMG741/I1VDJoZT2LlpKAN9JRdF+z1cGI+EqLqN?=
 =?us-ascii?Q?9fH2aSuK22J1wS0fRoU++wJcN2A5Lt+CM75VHmu3Tbc7hA4C0EhChjmp1r9X?=
 =?us-ascii?Q?6bgKv7lyxNlOFJOegyVBdEfUSERyAHY0dAVMaxZ/ZON7d1k4V/xLTimLKWTw?=
 =?us-ascii?Q?6SfALh5G+nUHdeDrXNOBuBfyizeDmENghq2MTMZnwydA40IQzpExkV+SXVMU?=
 =?us-ascii?Q?3d0g6CgUKRZENNiOtexn3Ts4KfaTsdQnFtyKr6+6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8e41a67-c742-49c8-da8e-08de237905dd
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB8294.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 12:26:23.2509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uc4npt8U3Gt3qaIbjMNr25GaDwNkaHFGUBuBLdWeqIAKluFasos5iXcQttSvp28gY7NFZHOSmrSymd7qNxwn1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8277

There are cases where skcipher_walk_first can fail and errors such as
-ENOMEM or -EDEADLK are being ignored in memcpy_sglist. Add error checks
and propagate the error down to callers.

This fixes silent data loss from callers to memcpy_sglist (since walk is
zero'd) or potential encryption on the wrong data.

Signed-off-by: Colin Ian King <coking@nvidia.com>
---
 crypto/algif_aead.c          |  8 ++++++--
 crypto/authenc.c             |  4 +++-
 crypto/authencesn.c          | 11 ++++++++---
 crypto/chacha20poly1305.c    |  8 ++++++--
 crypto/echainiv.c            |  9 +++++++--
 crypto/gcm.c                 |  5 ++++-
 crypto/scatterwalk.c         | 11 ++++++++---
 crypto/seqiv.c               |  7 +++++--
 include/crypto/scatterwalk.h |  2 +-
 9 files changed, 48 insertions(+), 17 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 79b016a899a1..fd571bda0799 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -199,8 +199,10 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		 *	    v	   v
 		 * RX SGL: AAD || PT || Tag
 		 */
-		memcpy_sglist(areq->first_rsgl.sgl.sgt.sgl, tsgl_src,
+		err = memcpy_sglist(areq->first_rsgl.sgl.sgt.sgl, tsgl_src,
 			      processed);
+		if (err)
+			goto free;
 		af_alg_pull_tsgl(sk, processed, NULL, 0);
 	} else {
 		/*
@@ -215,7 +217,9 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		 */
 
 		/* Copy AAD || CT to RX SGL buffer for in-place operation. */
-		memcpy_sglist(areq->first_rsgl.sgl.sgt.sgl, tsgl_src, outlen);
+		err = memcpy_sglist(areq->first_rsgl.sgl.sgt.sgl, tsgl_src, outlen);
+		if (err)
+			goto free;
 
 		/* Create TX SGL for tag and chain it to RX SGL. */
 		areq->tsgl_entries = af_alg_count_tsgl(sk, processed,
diff --git a/crypto/authenc.c b/crypto/authenc.c
index ac679ce2cb95..1abb4931ab59 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -202,7 +202,9 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 	dst = src;
 
 	if (req->src != req->dst) {
-		memcpy_sglist(req->dst, req->src, req->assoclen);
+		err = memcpy_sglist(req->dst, req->src, req->assoclen);
+		if (err)
+			return err;
 		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, req->assoclen);
 	}
 
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index d1bf0fda3f2e..6dc61dd4ab1a 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -174,7 +174,9 @@ static int crypto_authenc_esn_encrypt(struct aead_request *req)
 	dst = src;
 
 	if (req->src != req->dst) {
-		memcpy_sglist(req->dst, req->src, assoclen);
+		err = memcpy_sglist(req->dst, req->src, assoclen);
+		if (err)
+			return err;
 		sg_init_table(areq_ctx->dst, 2);
 		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, assoclen);
 	}
@@ -258,8 +260,11 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 
 	cryptlen -= authsize;
 
-	if (req->src != dst)
-		memcpy_sglist(dst, req->src, assoclen + cryptlen);
+	if (req->src != dst) {
+		err = memcpy_sglist(dst, req->src, assoclen + cryptlen);
+		if (err)
+			return err;
+	}
 
 	scatterwalk_map_and_copy(ihash, req->src, assoclen + cryptlen,
 				 authsize, 0);
diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index b4b5a7198d84..c15ae1a2d666 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -145,9 +145,13 @@ static int poly_hash(struct aead_request *req)
 	} tail;
 	unsigned int padlen;
 	unsigned int total;
+	int err;
 
-	if (sg != req->dst)
-		memcpy_sglist(req->dst, sg, req->assoclen);
+	if (sg != req->dst) {
+		err = memcpy_sglist(req->dst, sg, req->assoclen);
+		if (err)
+			return err;
+	}
 
 	if (rctx->cryptlen == req->cryptlen) /* encrypting */
 		sg = req->dst;
diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index e0a2d3209938..d46fb04c16f4 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -40,9 +40,14 @@ static int echainiv_encrypt(struct aead_request *req)
 
 	info = req->iv;
 
-	if (req->src != req->dst)
-		memcpy_sglist(req->dst, req->src,
+	if (req->src != req->dst) {
+		int err;
+
+		err = memcpy_sglist(req->dst, req->src,
 			      req->assoclen + req->cryptlen);
+		if (err)
+			return err;
+	}
 
 	aead_request_set_callback(subreq, req->base.flags,
 				  req->base.complete, req->base.data);
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 97716482bed0..2c40df82ad20 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -928,10 +928,13 @@ static int crypto_rfc4543_crypt(struct aead_request *req, bool enc)
 			   crypto_aead_alignmask(ctx->child) + 1);
 
 	if (req->src != req->dst) {
+		int err;
 		unsigned int nbytes = req->assoclen + req->cryptlen -
 				      (enc ? 0 : authsize);
 
-		memcpy_sglist(req->dst, req->src, nbytes);
+		err = memcpy_sglist(req->dst, req->src, nbytes);
+		if (err)
+			return err;
 	}
 
 	memcpy(iv, ctx->nonce, 4);
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 1d010e2a1b1a..021368d1c519 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -101,26 +101,31 @@ void memcpy_to_sglist(struct scatterlist *sg, unsigned int start,
 }
 EXPORT_SYMBOL_GPL(memcpy_to_sglist);
 
-void memcpy_sglist(struct scatterlist *dst, struct scatterlist *src,
+int memcpy_sglist(struct scatterlist *dst, struct scatterlist *src,
 		   unsigned int nbytes)
 {
 	struct skcipher_walk walk = {};
+	int err;
 
 	if (unlikely(nbytes == 0)) /* in case sg == NULL */
-		return;
+		return 0;
 
 	walk.total = nbytes;
 
 	scatterwalk_start(&walk.in, src);
 	scatterwalk_start(&walk.out, dst);
 
-	skcipher_walk_first(&walk, true);
+	err = skcipher_walk_first(&walk, true);
+	if (err)
+		return err;
 	do {
 		if (walk.src.virt.addr != walk.dst.virt.addr)
 			memcpy(walk.dst.virt.addr, walk.src.virt.addr,
 			       walk.nbytes);
 		skcipher_walk_done(&walk, 0);
 	} while (walk.nbytes);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(memcpy_sglist);
 
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 2bae99e33526..bfb484b2514f 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -64,9 +64,12 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	data = req->base.data;
 	info = req->iv;
 
-	if (req->src != req->dst)
-		memcpy_sglist(req->dst, req->src,
+	if (req->src != req->dst) {
+		err = memcpy_sglist(req->dst, req->src,
 			      req->assoclen + req->cryptlen);
+		if (err)
+			return err;
+	}
 
 	if (unlikely(!IS_ALIGNED((unsigned long)info,
 				 crypto_aead_alignmask(geniv) + 1))) {
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 83d14376ff2b..ee9fa43bc82e 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -278,7 +278,7 @@ void memcpy_from_sglist(void *buf, struct scatterlist *sg,
 void memcpy_to_sglist(struct scatterlist *sg, unsigned int start,
 		      const void *buf, unsigned int nbytes);
 
-void memcpy_sglist(struct scatterlist *dst, struct scatterlist *src,
+int memcpy_sglist(struct scatterlist *dst, struct scatterlist *src,
 		   unsigned int nbytes);
 
 /* In new code, please use memcpy_{from,to}_sglist() directly instead. */
-- 
2.51.0

