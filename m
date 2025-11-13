Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010069.outbound.protection.outlook.com [52.101.201.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4319826F2AC;
	Thu, 13 Nov 2025 14:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763042910; cv=fail; b=RJobB6EPIbN9hQF9B7AqPFPnxipaXsHjXKj1jYRuNgZIesY+kftoEnHyr/BlvOUZOSeutAhgwde4S7R4WhUoV9pmCKpW5oSiwI8hsjQvzxxcgfD9wIXcu65G7XZVGfqdI9bwWvOlnWmGmSyYEaQj6T+o0VJyhjraiIhiH5s12Tg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763042910; c=relaxed/simple;
	bh=bijiED3waRnrfhEn1OXomHEVmGfmd9CKZImKLpXToMU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iKIEwFMKP1jiKGP3Ddpjg1GcgB1I0Kz06QsSW9kOrrmFoMFi3mLXdwq6ZfFjA21/6g7y0UTowKBH7Hi1u+cqcWpQ4e8BqmTeStLhHxCjoYzT+L0vUDYRYT8mWV4mN2yTORfgL6lQJ/DSmETOJV86crh4h4WvPh5OmHLXzJfj8a0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=OK11rXwX; arc=fail smtp.client-ip=52.101.201.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="OK11rXwX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R6iOn9GYZlt98vW8tc3pj1kJO1PL1rZhVzfxrLWsbWvjfEGZeYa3tYCHtHvQdlLh6ro9pRsJ3Wm3LsoF6l37cARWxFHVajxbw/pwhQ4/rceVGz+sPvA9+fzRt4UOAhDKJRSSwu7jHEX8oWLxrDiiI6ZNRq8JojbyGCwv7PjcpwAHAqg31Wx2PC091l7aDhAUuIpp/x2qyPttsq0mUSMKEaIKpjrPeVGJcRMsrpQ+L+qaK2bD8xN0nNd+lMyV7r6evGuGG5Vtng/KMyaDnq3fyQrO1vBHB6v6Yf+ouf9btIX/sryCZ4mEPTZjWOUehWgyI3Eg+RR/ZJiDhsIjD4U0wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51L8M/eKotKFaYQ2OxK48bJTGQmL0j6+hH0lQYIZ4FY=;
 b=kcopPZnafC13zLg3BTaD6puvEyzgXcYu7vmkZvd3pSgp5VEIxz1Fg+HefTV9xjlVuh7GR2Hbi+jI4UgpG7h2IgiH6/mtdBlemlEv2IJaZPhUe+UWnCcuD/Rckjm/febsNK4ACAP9qIufE1w4bNXy1k6Wk2Nt/h6760oMJk9t84mwy7LS5KSd3YXslmh0gMjlkpOcisVy7eCrZH6t62rn3TyvLtl1P/CUe1W2aeRIvuFS4Q+ETpCB88so9lCcS4aWO1lq63DBcilk3aLHMo8xlXYotU5+/QzOwFn2Zkos6cwIOa1Yd/tNpV2p/XcSZxXwcHvKEbHeq7o7DmY0ADKwLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51L8M/eKotKFaYQ2OxK48bJTGQmL0j6+hH0lQYIZ4FY=;
 b=OK11rXwXTYb4i0lLJn2BP8LQeoSphXYHxIk/8PJZa7NR8W1fyZVz+LnhXu9bjTbfLcQhht8bromv9dN0x1CciaVM04FhEWjuJ0b+dCAZIs6D84QPlgjXMbNQ/MiVcJmPJeHG1DPUVyhKQStHzMTMwa9hTgXwBj+NQyD6qlSbT+Q=
Received: from DS7PR03CA0254.namprd03.prod.outlook.com (2603:10b6:5:3b3::19)
 by MW4PR10MB5750.namprd10.prod.outlook.com (2603:10b6:303:18e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 14:08:24 +0000
Received: from DS2PEPF00003445.namprd04.prod.outlook.com
 (2603:10b6:5:3b3:cafe::2) by DS7PR03CA0254.outlook.office365.com
 (2603:10b6:5:3b3::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Thu,
 13 Nov 2025 14:08:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 DS2PEPF00003445.mail.protection.outlook.com (10.167.17.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 14:08:22 +0000
Received: from DLEE211.ent.ti.com (157.170.170.113) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 13 Nov
 2025 08:08:17 -0600
Received: from DLEE200.ent.ti.com (157.170.170.75) by DLEE211.ent.ti.com
 (157.170.170.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 13 Nov
 2025 08:08:16 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 13 Nov 2025 08:08:16 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 5ADE8Fmt344544;
	Thu, 13 Nov 2025 08:08:15 -0600
From: T Pratham <t-pratham@ti.com>
To: <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S.
 Miller" <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Manorit
 Chawdhry" <m-chawdhry@ti.com>, Shiva Tripathi <s-tripathi1@ti.com>
Subject: [BUG 2/2] crypto: ahash - testmgr false failures with CRYPTO_AHASH_ALG_BLOCK_ONLY
Date: Thu, 13 Nov 2025 19:30:13 +0530
Message-ID: <20251113140634.1559529-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251113140634.1559529-1-t-pratham@ti.com>
References: <20251113140634.1559529-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003445:EE_|MW4PR10MB5750:EE_
X-MS-Office365-Filtering-Correlation-Id: 17867920-deaa-44d8-5a8b-08de22be1ad2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FjobrQFLkHtDXGZNHmj9dRuOqqVKGXTc+swVs9dgljngVgxCs8lcY+mVirbz?=
 =?us-ascii?Q?gLTPobOs67+9h+cIGYTTMp6U0CInJJsSoqIgYeVcqWr+asfzoZ1dbxabdjS3?=
 =?us-ascii?Q?mRmLRCdcFsWc6OSLKtqNX/2hZyiIUjcm3vKJVlw3FEnrCQloph7iIFmcYXl+?=
 =?us-ascii?Q?NjBiJCmerAqarskwePb+DR+mT88m/zW7qX7IBvVjpj5QhONwfsdjOQ8h9QzX?=
 =?us-ascii?Q?OJdQ7ZNoApOg7Mr69th8CMRMqkubuAzwrL3gtc6wu9sZvtrnY+bL/qolDmjh?=
 =?us-ascii?Q?c67DfgXXogxKHfT4PRYNwrzsKoSIPbd0FSkCuLePaR699ZaGhFsmQZ0XAgdr?=
 =?us-ascii?Q?Xt6PKGN344Ucxn3YPof6Muf3EiCZveCvd7/vwdc934IFc40v/pbLwfj4oT1z?=
 =?us-ascii?Q?KlyuZ6m3h2wrk+PedjD8N29K6E2D5ABvqxGJ1QnenZBSXM35UWvBZsQYHyPx?=
 =?us-ascii?Q?8rkpghy+1PWXKxg5DU5boSFGZPnJnKemGxGHeIu86N1I7QLLdi0b+4u8qj9W?=
 =?us-ascii?Q?Dh1mbxnUDhSn1NA1pKn//6zx3yne210IE2Y4KuOcR3YlYVGaIQiT1sKrutgm?=
 =?us-ascii?Q?68gWuCMY8jBYcI17tMY4cAu6UFj0PSSDl795Lr/Q7uc/Cjkn7t//+TfXfgO9?=
 =?us-ascii?Q?N41I9thbvQtic+kxO4DZMhxWgkcn/rEAM5BZ1p2W7HOHq21TXvunKhewNC1f?=
 =?us-ascii?Q?tQobCeE7JxVYF1QhwHn/KDJhga6kYRjrCBfLu2UdK1ZO4IfHsHmGzPK595Bv?=
 =?us-ascii?Q?ShGmRF0FUlgZoNRcXrktu6C73V0q2fO2LcieVert4uW1oDKBFcXbJFooSsTo?=
 =?us-ascii?Q?3ZyoNH26zs4ckn8iyZEmuuPHbD29/cMwxUfW4e93eLbjmAxbJboknDccyd01?=
 =?us-ascii?Q?heyd9hJN5JRe+Oj7oQ1Vd6pbmRih45XykzXsxEMsS5ELJLtWk96jJ/oM8bc2?=
 =?us-ascii?Q?HiUBpnfQE689JqEMnFMkoV00Jk8H7Z9KwjNEAeMeVubdArnwWsJxdFv0Uvsu?=
 =?us-ascii?Q?Ev62N1yrOWj79FPjbIh4CT0iae4+JtFQHugXldGr7LX9GnraIBoKRV0NSkLp?=
 =?us-ascii?Q?GjJawkw4Q0/AhNkMh4n+3PJT8sFYm2849c+ujc3PkCLD05QXLCQBvCjZqYNf?=
 =?us-ascii?Q?lMqKaJXiXRwdoqhNomsRcG/6+XCLg+LD4oYLMn8Af4YbDsl1+QfOequwGsoe?=
 =?us-ascii?Q?VTQkhda48nSuzTQ3gNgI5uLK1re7b6fuDkmjJeMjsUOFjD7++QvNeUFM2Phr?=
 =?us-ascii?Q?eidj/ckObY0DBXRGeY9dHtD6Gsj5Clv8ScNLy/zPmwJ5HV64PfUYMU0p9vAu?=
 =?us-ascii?Q?nF/lJaq5oQb2gK7ZotUKDUFghccWGb41Etgx3XTlpukkSiiKLSKtUC3z1++1?=
 =?us-ascii?Q?v+eiiEApIMfE1jR2zZcHJYDy4Rt29oaPSaKSmOf2ye9qpLe1L9PdcmIy/aJL?=
 =?us-ascii?Q?6afIRA05unW8YuSGCRFBGlhGjLFWXwJ4LhjNsFqTo6Xu9BwpG6TK35dVZ1Hm?=
 =?us-ascii?Q?1/XA0s/6lpuoZZP39KjRt2JuGnrai91f2wJ7hWF7l6/n9AQJAt37UhzxUrly?=
 =?us-ascii?Q?bKoTz06JAb3IevcLue4=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 14:08:22.1496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17867920-deaa-44d8-5a8b-08de22be1ad2
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003445.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5750

Hi,

Commit 9d7a0ab1c7536 ("crypto: ahash - Handle partial blocks in API")
introduced partial block handling for ahashes in the crypto API layer itself.
This enables ahash algorithms to return a positive integer from the update
function to indicate the number of bytes in the input which are not processed
and should be buffered for next update/finup/final call to process.

It appears that the testmgr is not updated to handle this positive return value
from update(). As a result, self-tests fail (falsely) for such ahash
algorithms. Below are dmesg logs from my (work-in-progress) TI dthev2 hash
driver:

[   12.933924] alg: ahash: sha256-dthev2 update() failed with err 62 on test vector 4, cfg="init+update+final aligned buffer"
[   12.951212] alg: self-tests for sha256 using sha256-dthev2 failed (rc=62)
[   13.008108] alg: self-tests for sha256 using sha256-dthev2 failed (rc=62)
[   13.361625] alg: ahash: sha512-dthev2 update() failed with err 126 on test vector 5, cfg="init+update+final aligned buffer"
[   13.376311] alg: self-tests for sha512 using sha512-dthev2 failed (rc=126)
[   13.388088] alg: self-tests for sha512 using sha512-dthev2 failed (rc=126)
[   13.389503] alg: ahash: md5-dthev2 update() failed with err 15 on test vector 6, cfg="init+update+final aligned buffer"
[   13.421488] alg: self-tests for md5 using md5-dthev2 failed (rc=15)
[   13.478062] alg: self-tests for md5 using md5-dthev2 failed (rc=15)

Note: the driver works completely fine on a TI internal v6.12 LTS tree where
this buffering is being handled by the driver itself.

Now, while debugging the issue, this messy fixup in testmgr code works fine and
my ahash driver passes.

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6a490aaa71b9a..523507e79f760 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -34,6 +34,7 @@
 #include <crypto/kpp.h>
 #include <crypto/acompress.h>
 #include <crypto/sig.h>
+#include <crypto/internal/hash.h>
 #include <crypto/internal/cipher.h>
 #include <crypto/internal/simd.h>
 
@@ -1571,9 +1572,16 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
                                                pending_len);
                        err = do_ahash_op(crypto_ahash_update, req, &wait,
                                          divs[i]->nosimd);
-                       err = check_nonfinal_ahash_op("update", err,
-                                                     result, digestsize,
-                                                     driver, vec_name, cfg);
+                       if ((crypto_ahash_alg(tfm)->halg.base.cra_flags &
+                           CRYPTO_AHASH_ALG_BLOCK_ONLY) &&
+                           err >= 0)
+                               err = check_nonfinal_ahash_op("update", 0,
+                                                             result, digestsize,
+                                                             driver, vec_name, cfg);
+                       else
+                               err = check_nonfinal_ahash_op("update", err,
+                                                             result, digestsize,
+                                                             driver, vec_name, cfg);
                        if (err)
                                return err;
                        pending_sgl = NULL;
@@ -1614,8 +1622,14 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
        if (cfg->finalization_type == FINALIZATION_TYPE_FINAL) {
                /* finish with update() and final() */
                err = do_ahash_op(crypto_ahash_update, req, &wait, cfg->nosimd);
-               err = check_nonfinal_ahash_op("update", err, result, digestsize,
-                                             driver, vec_name, cfg);
+               if ((crypto_ahash_alg(tfm)->halg.base.cra_flags &
+                   CRYPTO_AHASH_ALG_BLOCK_ONLY) &&
+                   err >= 0)
+                       err = check_nonfinal_ahash_op("update", 0, result, digestsize,
+                                                     driver, vec_name, cfg);
+               else
+                       err = check_nonfinal_ahash_op("update", err, result, digestsize,
+                                                     driver, vec_name, cfg);
                if (err)
                        return err;
                err = do_ahash_op(crypto_ahash_final, req, &wait, cfg->nosimd);

While I have not tested any shash code with CRYPTO_AHASH_ALG_BLOCK_ONLY, it is
highly possible that testmgr will report a false negative there as well.

I can send a fix for ahash. Let me know if it is better to just add a separate
check in the testmgr (in which case, I'll cleanup the above diff and send as a
separate patch), or should we modify the crypto_ahash_update() function in
crypto/ahash.c to return 0 as it handles all the buffer management inside
itself. The callers of crypto_ahash_update() anyway don't expect a non-zero
positive value on success as far as I can see. 

-- 
Regards
T Pratham <t-pratham@ti.com>


