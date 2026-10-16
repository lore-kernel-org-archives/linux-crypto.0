Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012043.outbound.protection.outlook.com [40.107.200.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FB6395AE9
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 04:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792124094; cv=fail; b=jPGxCT8oy7KzLddIwwvwDT27351KZDMuLt1qHRS35ZK9QyYj7rxn7ez+lG1WWUIpn6LSisfY7J8DFjzFGqP9XTacAMh6xnI24YpdW1qFtv8lfqU/YyAk4zU0a0w0p+aZxCLqeT9pmF4cByPFR29xqkvAaykEgwlCW5mk6n48BIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792124094; c=relaxed/simple;
	bh=QJiMY93iiditd/laZP/Iq5PATII1wHayUZehE2i3iFI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pBCGzKS5MqyTG8TNxOlodWwRJZ+L5LdzEuMlzzcMF2Uj0AThq9dQVhGIePXF/5DOSvoFNfNhYnqfhK6joi9YTQLnPKUJ6FgHm3IY9D88cYz3gFQwoU+7l1NBZIy7re7Lzr/gY+MXXVi78bNqTri9Ul+ntZc+r6fqv+yVx24VqBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Op7JTdLb; arc=fail smtp.client-ip=40.107.200.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Op7JTdLb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TTV4lyemtxe8EOPg/aZsXHLyD2W9XAgGy5gV2X8yZVuRJMsEy0Dj7Wzh+7AjWdjqfnLzH/bkdB2V2ifiwc8c3xhcJ7f9orEj834bGn6uxMNzyrIjJAE6NDWP4TZ34K01cVzmoYvQ1EVFHYfcJtI4+VvcidQGK0825E/NC5uy1HvDwuvjFGCje/AiM7wviJ2KKu9JXFqTwO/LMr84JPloq5wakkLJwZ9mwxWIPVqaMNErFfIXXmBiFBKk9hc2bq2O9YZfcdjnaeeL6AM+QV6K4U/DF+y5aiI4Rc51ajN9VoJ19j9OOEcIukJsNAaPzG2fzWqy9m/MLFwsDwWv3VsK5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNFWrpFElLpzv1RdlZ5h7lRmGT0qNNolB+7l8EXd63c=;
 b=rdCHe5NBEXOD4gfMVWNBkmGjl6G1Q+3Nytqoa7mAyGWEorkBXIvSIdRm/95S11ebNcpQ1He7xim1pKsSZeq1410eMMNuwV24CjoHiAwqWRHy7FPnK8mUj+ftwelceP8MeQd4Lx4bWCF7/Yadz0gPGOepNiziPifrm5OIYUioJTe5NisMS7odpCs/vw/9KLb3e881M6j2yFXVNYa/nTs8Zcsl9FPBqbIwbC4ILy+VKR+/GAUEL5DNi+yYHAnjvASYr22L/wIMSuSQVwvQwDJfX5s8tK0QvSHeCfO4EOLJsfXXhmXMrdyzcPY4fMvd4YyEDS37moi3DAHC4qgvWLLYJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNFWrpFElLpzv1RdlZ5h7lRmGT0qNNolB+7l8EXd63c=;
 b=Op7JTdLbMZMa2suU/Ql+qU6sJobjgY74gCXDSGVXX5w6tPj4ChFmExt9MDjA0B4IS7LmKLHkUQ1kYVYWmPnFgK6FsrDmW1yAyN5SIvpLrsDwq7Iq8/6Gy2Kywnt9tx1bwcxi0UkorDZLp/DwOw6macFoUYrLIEqw1rQ84TrYDS8=
Received: from DM6PR06CA0074.namprd06.prod.outlook.com (2603:10b6:5:336::7) by
 DM6PR12MB4089.namprd12.prod.outlook.com (2603:10b6:5:213::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.14; Fri, 16 Oct 2026 04:14:49 +0000
Received: from CY7PEPF000000F2.namprd05.prod.outlook.com
 (2603:10b6:5:336:cafe::31) by DM6PR06CA0074.outlook.office365.com
 (2603:10b6:5:336::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 04:14:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY7PEPF000000F2.mail.protection.outlook.com (10.167.247.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 04:14:49 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 15 Oct
 2026 23:14:42 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>
Subject: [PATCH v2 3/9] crypto: ccp - Use __free() handlers for sev_ioctl_do_pek_csr() allocations
Date: Thu, 15 Oct 2026 23:09:31 -0500
Message-ID: <20261016041109.1778673-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016041109.1778673-1-michael.roth@amd.com>
References: <20261016041109.1778673-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY7PEPF000000F2:EE_|DM6PR12MB4089:EE_
X-MS-Office365-Filtering-Correlation-Id: b274eea9-caad-4070-fddc-08df2b3c0531
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|1800799024|22082099003|18002099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	X2+uMWH6ehRpy/y8AzR0VhXPyep1vKlY9oAiNk7NJxs1hp/cZVCd4/P7ZZbHNOaXXncI7ABQPm6gUkgZp3S81WxuViDNVw55ExEbXYUuorbnl806Rin+otssXqaUGx6FXa+7FSe+l7Qm+1BWSgDbZ7rJ9Pe1KPFetgym2LaQTfbcbblehLfsNoOP787bMbgttdSNBlsI5KmjsNWBUE2AvE5bpqQIxfwkBctU+BRhHgXjLsLDB+yaLZoY+OKag4aJYvTNmiAHSLG8OVNSHEQBKjXeKDvjqO/30qOKP1SDSzw7DujWmkHS5wCGUBlxOcW1CViLWgJnomTZd5PDThoOqizE9ub7Y0PJJze7mRfQrEYZViVh1lF6imiT1m7NF/EyAmlWaDxKHxa54cjBdV1G35rwbja7qBBeNuIXPzH5wQe3zCQvIUVZ7m5h78LehdrNCQsi7mZKTrrGpy3wtBYFVZuxAE8ucN3F74yt7yPmW6hgCzRrSDH7Qfn83VgAJauO3bAzr4woUIcics/xpcsPzFUBuB/310pJYXBvayPtYVvH+leu2gtaor3Y+UsexPnDOzMhU2GyagN9D+2Jd+uEufHWPXnIGfYnnNtU4KbzrJfK5IPc/iKKWaTUTE2tdILZL+k76AbYn9BUZZ7eCdd+3dwkd+M1U34svFtjfYUkD/+dxVbkOp6sofO5MCRyej+Siumoy7ig/EIlo24qz7yCrQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(1800799024)(22082099003)(18002099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qmSU2BHAEse7vO6OmfFfYlNTxWjtlaSS3l7ims647ujg2bRy3kyrxpcvCX88178x7CxWnmeJFxKlagrw1H66cI7gW0MMqU0MXQh3iDa39rRKScRiuzLJQeL+2kDvTrKBB/9OQNhOkoJq5e39x7p+5Pgd/s61s87vdxciAL2OncrIUHEETn5LB78nTEm637pF4LBPRAupuBhchJ7mqHuwgeyZmCY3EdgrtATcIrhH0F/IGpWBZmobHWCGAg3Tn+NGMKO58hirDMt+gX6sO/0Bz2ySIoQ9ueHNKF/BEXZ+xzR4SulkwabZMccokOtL6oijLv1NDDXX0BaS+E9vT3YHObik2JhCkK1ZgUxva8/98L+4qjfMH8tQ5JpJy7qb6r9juZIKvoszhBIJevaxGGtme6Uag8CEjdvvRZp7FlmTofPCta4HKdJVd9sKonrfxWeO
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 04:14:49.4208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b274eea9-caad-4070-fddc-08df2b3c0531
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY7PEPF000000F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4089

Make use of __free() handlers so that the related goto statements can be
dropped. This is in preparation for switching over to using mutex
guard()'s.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index ed60f3db391c..f6d06242184e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1986,7 +1986,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	bool shutdown_required = false;
 	struct sev_data_pek_csr data;
 	void __user *input_address;
-	void *blob = NULL;
+	void *blob __free(kfree) = NULL;
 	int ret;
 
 	if (!writable)
@@ -2017,7 +2017,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
 		ret = sev_move_to_init_state(argp, &shutdown_required);
 		if (ret)
-			goto e_free_blob;
+			return ret;
 	}
 
 	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
@@ -2031,21 +2031,17 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	 */
 	input.length = data.len;
 
-	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
-		ret = -EFAULT;
-		goto e_free_blob;
-	}
+	if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
+		return -EFAULT;
 
 	if (ret || WARN_ON_ONCE(argp->error))
-		goto e_free_blob;
+		return ret;
 
 	if (blob) {
 		if (copy_to_user(input_address, blob, input.length))
 			ret = -EFAULT;
 	}
 
-e_free_blob:
-	kfree(blob);
 	return ret;
 }
 
-- 
2.43.0

