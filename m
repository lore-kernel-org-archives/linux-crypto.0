Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33F217741;
	Sat, 30 Nov 2024 13:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732975145; cv=fail; b=HEAV/aFHGXlZllHjHakBzgzDcA4ltdyueF6fe5FpS3qr/MF6amh05YKplrrfa4XSV7rdBqki+0t+nG2cFlHlPJmXxjkbiPLQGSuccjjmjGSt7nF9GT+THaxriD+NjN6MJ044Coa+lAe9o4Fv879gOmZGbJRO/V1rGj3I94zxDZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732975145; c=relaxed/simple;
	bh=7l7gvJKzbR4nkuUtRdL2nEYd4t6IYbqw3JFJ5PvYey0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Jmmv09bJDb72lVLT8gIRRHOuEa9tOihvU1GIDVqHeDHhCN9j2d9d3pMRJVtw2p5zj9b4CE6zfRAQT1zRE4gn6rgHshG7AM71sHX9B+RHwIkVsBgbvt22rmTtb8iOI4bmpGnu2bWvMzk4wEcDsHossNt82MwRPbkZtLDRh7Rq+yQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AkuGwxvn; arc=fail smtp.client-ip=40.107.244.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AkuGwxvn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X53EDf/n1aOxtF4bmSMTtDAT1W8rrPMpfz0gWpm5t1bpilUkCgOgtXLpd7ld+2PwrzpesPCJWf2mzQe7O8FQo2Ge2wIQpqJyclKUTwT+Xi/qC63RiTzpbemkhbdt+OtaXx4c0bCahKrBluqokv83cGlTk81XCBzX/YieOQtM2c1O4Hv0O0HC/CfAm9JHJbaSVErvlz5gq6bc3jYpZdowEoaZzzdIH5dqRDee0t4Y5EH+Ou9VBfx8E0PG8AYKieTPsjDuwB9wxLH46USH9IDFMKQZ+WgH5cA3uC7E37372i+vYGMy4MbI4ESmqAmX9eNQ5fHBPwM/KFfDkjaAkCsISA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CweKUlnRp5J4ZErkKOQG+v+zdxSUCVdb5FaPPtGAkY=;
 b=a6Bl9W8w2nMNqPXdr7jhae+vHJAkOdzrrNy6ThNOzjs5asv5rkee92Pl35zuAko0nVWkhGeBt7WSnjpQN+8tl633COOM0CXFjpBJmEuGUxpkV287WHp8CMk84I6Yq5UAoRa7cJ2gyNbmOYqxU3ZVNsU9skL/8xdaP3OON1LpR94EExil6rUdGCMeFCQnOmEEndpzxvZHyIw9NnPlgsv8By/AfC8S2Lsl7AdZbgndtbMLN4jmoRNDnz1PxnURbGKDl/+Xiz79Z6RIavhiAJ8a19h7lDDFMG/8M91CLJgERwGWGSSVX6MeuZv5hHj9Ay9DQ5pb4z86oKRnuZGo0XVSAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CweKUlnRp5J4ZErkKOQG+v+zdxSUCVdb5FaPPtGAkY=;
 b=AkuGwxvnEH/WCi3I4dc3SddBXPcXVVNRhUcYKNmiI+t1Hj0Z6IesxUbN5BPkhnmstUgPgncB+8YT+nNXyuUJK7Tu/tn0+TQKlqtWpY5AH7HRkFPuIoX94J/3kiNT42SVTDOnb0N/1LqtdxEVsXdeMAY1Y7J1/lQHF5/RZEFT+D0=
Received: from BN0PR04CA0022.namprd04.prod.outlook.com (2603:10b6:408:ee::27)
 by SN7PR12MB7370.namprd12.prod.outlook.com (2603:10b6:806:299::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.16; Sat, 30 Nov
 2024 13:58:59 +0000
Received: from BL02EPF0002992C.namprd02.prod.outlook.com
 (2603:10b6:408:ee:cafe::16) by BN0PR04CA0022.outlook.office365.com
 (2603:10b6:408:ee::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.15 via Frontend Transport; Sat,
 30 Nov 2024 13:58:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992C.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Sat, 30 Nov 2024 13:58:58 +0000
Received: from AUS-P9-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sat, 30 Nov
 2024 07:58:57 -0600
From: Mario Limonciello <mario.limonciello@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Mario Limonciello <mario.limonciello@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, "open list:AMD
 CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DB..."
	<linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] crypto: ccp: Use scoped guard for mutex
Date: Sat, 30 Nov 2024 07:58:36 -0600
Message-ID: <20241130135836.338-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992C:EE_|SN7PR12MB7370:EE_
X-MS-Office365-Filtering-Correlation-Id: f1f4cb22-f95c-4a67-8a9b-08dd1147231a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IHF0510IDnPqRioYAjZ/SsnEN4+/aRw0V7DJe5ldOqx812eC2LKdrUspQzZh?=
 =?us-ascii?Q?+rpocZDUmK9W5v7uf6ylMAnyAWXNlTpNF0IrGCjYuGLmRXhhNmJujfkxJy+4?=
 =?us-ascii?Q?wQwhA+NwfQ25a10LkttQ4eOeOKu5ivrjaD5T8VASxSwL/VbEfxXKF01qE4kg?=
 =?us-ascii?Q?lv4JFtf5Mf1KHdYwMUVFMzhkxwpq1hIK9PVkxyjkXDH8Ag3PAU4VhBNZyOPB?=
 =?us-ascii?Q?Kyb/XalZBq40dFceOxncEoStms0TN2CvoSYJrffNSlRg1Ox3uKhFo4vIe4Ny?=
 =?us-ascii?Q?8Pf4llIjjcDIkfqhi8Ub531bePuoOG28vtv2H+znID0Owaip/oyxUQjyNAsq?=
 =?us-ascii?Q?tQh8npSOKyennTQ0VcLGm3GwKQAtIBwSQYrH42Rx8PGv8ZagbQ0xsRKfczxR?=
 =?us-ascii?Q?DWC+fUwhoYVzqK7Z4s8CYts7QbUj24C98HqbgDpx9YVAjh+FvvqT0grBm3lR?=
 =?us-ascii?Q?dsRqWKsiLMgLwc8cJmcz5x05mu91J3TNmYXPiM9RSZSJ5h5tU+RWLJBHmOgP?=
 =?us-ascii?Q?Wkc+7MaWry/Kw8dzSi5jS45ODCXS7kObNpC2zwMVlmHYpsFt/BZ4GP1q4HfJ?=
 =?us-ascii?Q?szOdjDirEScVVCZy4d5e+csipdtRWi1fnxOMld7H3skWCB8FjO7ALzBo4/wv?=
 =?us-ascii?Q?Sad9M69LXb21rMwHQyVg1959dqyaGjHDHIWcovOQvZlJxe2Wswii6f4PVzwR?=
 =?us-ascii?Q?LrqfsxYDrW8HwMqZQTy6Lxz0J6gFUJAAFi5F7tyihsou2td7SlcibKSWHpPR?=
 =?us-ascii?Q?ykMskHHPLE9bxhzPacsbdQTJ227YoUd1UmsziLkfZ3ACUstm83S7V5v/Q12G?=
 =?us-ascii?Q?j8i8C5YBoxAdhiw1h9NzfgLcTgodLbkJUaIriUWeHE4kprALc3h6mE00Ngyn?=
 =?us-ascii?Q?9I/F3vkKI3xac9aBkn1uO6hnAGX5xWXJ3LLR30WhEd/Z/gVj155hskhxZat2?=
 =?us-ascii?Q?QRRNPTyoki+DzcSyPICGVDamMongw/ARxmyJpCTF4sUxSJfGASJnNQ+JeGaE?=
 =?us-ascii?Q?DauZ/DE0SNWIFKAdoO6TpJZW9/BuHcNk/pVU6aclFrCGe4vSNmSqZ+Ysl8Jl?=
 =?us-ascii?Q?ATIWkmZtJhX4nqkbWLkeFN25Fn/LSxTKmk0JE7Yma6DQ0P3yUkTqiEz93t8I?=
 =?us-ascii?Q?cIcdghv5ORWtzo207kgV6IDmbjgADmZ0O5mdvo9Ig4gxe2lq8JLGTKPei9cT?=
 =?us-ascii?Q?Tij3UxbW2bYKFa2k9vTLssYZiGYEsshUJLUWG9jG5klZGiJuMgk2YYYWhp2t?=
 =?us-ascii?Q?xtVeG+rpdgV42Da7cry5W0lfpXuryY29VB9YjzV2Kra+fB0nQXRjzuW6McmY?=
 =?us-ascii?Q?DtQ2xlcG55/wV4ysWuuWrqTonZdCB8E/srfiChrhonVHNbGmQJL8MPnleekB?=
 =?us-ascii?Q?ucCzUF/kMUuRf4qgt2HFN/lhfc8k+JgR496sBCigiclABA5Us8DrvOpu3T4t?=
 =?us-ascii?Q?DutfbWElEozCvwakGY1AIDDFJtWuhDWk?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2024 13:58:58.4989
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f4cb22-f95c-4a67-8a9b-08dd1147231a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7370

Use a scoped guard to simplify the cleanup handling.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v2:
 * return immediately in default case
---
 drivers/crypto/ccp/dbc.c | 53 ++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/ccp/dbc.c b/drivers/crypto/ccp/dbc.c
index 5b105a23f6997..a3c6822b3829a 100644
--- a/drivers/crypto/ccp/dbc.c
+++ b/drivers/crypto/ccp/dbc.c
@@ -7,6 +7,8 @@
  * Author: Mario Limonciello <mario.limonciello@amd.com>
  */
 
+#include <linux/mutex.h>
+
 #include "dbc.h"
 
 #define DBC_DEFAULT_TIMEOUT		(10 * MSEC_PER_SEC)
@@ -137,64 +139,47 @@ static long dbc_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return -ENODEV;
 	dbc_dev = psp_master->dbc_data;
 
-	mutex_lock(&dbc_dev->ioctl_mutex);
+	guard(mutex)(&dbc_dev->ioctl_mutex);
 
 	switch (cmd) {
 	case DBCIOCNONCE:
-		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_nonce))) {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_nonce)))
+			return -EFAULT;
 
 		ret = send_dbc_nonce(dbc_dev);
 		if (ret)
-			goto unlock;
+			return ret;
 
-		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_nonce))) {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_nonce)))
+			return -EFAULT;
 		break;
 	case DBCIOCUID:
-		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_setuid))) {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_setuid)))
+			return -EFAULT;
 
 		*dbc_dev->payload_size = dbc_dev->header_size + sizeof(struct dbc_user_setuid);
 		ret = send_dbc_cmd(dbc_dev, PSP_DYNAMIC_BOOST_SET_UID);
 		if (ret)
-			goto unlock;
+			return ret;
 
-		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_setuid))) {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_setuid)))
+			return -EFAULT;
 		break;
 	case DBCIOCPARAM:
-		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_param))) {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_param)))
+			return -EFAULT;
 
 		*dbc_dev->payload_size = dbc_dev->header_size + sizeof(struct dbc_user_param);
 		ret = send_dbc_parameter(dbc_dev);
 		if (ret)
-			goto unlock;
+			return ret;
 
-		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_param)))  {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_param)))
+			return -EFAULT;
 		break;
-	default:
-		ret = -EINVAL;
-
 	}
-unlock:
-	mutex_unlock(&dbc_dev->ioctl_mutex);
 
-	return ret;
+	return -EINVAL;
 }
 
 static const struct file_operations dbc_fops = {
-- 
2.43.0

