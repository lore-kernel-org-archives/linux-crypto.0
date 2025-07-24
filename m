Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2073.outbound.protection.outlook.com [40.107.236.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000A4253F14;
	Thu, 24 Jul 2025 09:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753349751; cv=fail; b=LaL/+muMzqzCsRDTH+CrC/fJK6o5T4cjg2fBcO61HrjDpniEiZdUMvqISVU9Q+Zr/wFhZw9WALeJoJUZzHni+s3qoAm89H5Ajt9m5mOU0Qw5wN6JtPSpeCNIRkIRLWGDJlZd06geQlSziaKinpqt3g/nttfv4vVEsnCHCGWCo8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753349751; c=relaxed/simple;
	bh=Az6TtPwIcpGRvT/1q0D/DTQxCK3d4yoH2TIOdSQngjY=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JsoW4JKFH+b7Z8izbbAV5HuZdleY/3bAQUoZ+IHSeuL98Dx7AZFOMlPJaUUE6gUrKAAaxivHcgBlSM9epmf+Y57MAL2zlnZ+MPVra6MNyTVKGy1heeP0LnnkPe0S6VD39giR2PkLhgyh6sdLSfScQSr1SLyX4rrmItDwuqEixvY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Dna1Vbdz; arc=fail smtp.client-ip=40.107.236.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Dna1Vbdz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hpsTFlDMImaX296xKc9RQMygnNXnnrT15oH/bZuwgm8NTJy2Jgs2NZBA79IUFMjVMXDeomKoEJAcVvlvBvAbuyJD5d5mRLWxOMUWSXWK5ah3LsHiszriVK1jWIjFtuJkacDbwnIDk8LggW2ItrRRw9o9WD11niTdnlhDVtHS+T/JA/thcDWidPhTwAanMg0o7dyumpwkS01hd7PN5k9mLN/iJigi+sbOLaKUet6jDLdcSrvSeaWAoztWBZzespoI8O4OdvDmGYKohVvmwdo9e3ps+G35McnxIxViLmpyECpcoPf0dIqMDB8SABx/Sc0OR5N7ZcleUsytiVNwk5sGhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tZBZ3k91KzRaST/VqKg5KnsNbebG/WdMYzyHI88RQR8=;
 b=evM9481wc6HNtKCbVD9O3f9nHPHhbqcVTu080WOR1RiHrOhQjL8VC/ku75ehV+kbnbABba+96YyNBl9tsC5gQoMP7u0wzZu1fkSu2gKRcWqJ/S4GPu08pvNkEfaTNj/U8I7DF/S4nrsVdTBKTGolTHN0UTjNNXz24880JomJWX8DsinXVbuxynzMOCRFdY/R6iajehAzdJh2Rc3KxcVme//9DecvX9UtjvQm2OrBY8O86Kp4ijaGXYyIr5pzU8EEtjiGwtGRsOUVElOlEl9Ug7naIbMhtGOXaQ5RJ2OZyntRI3mmOKaCeYcy2LGxtq8zsb/v+rcTEq/BQNB9Hxc5ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZBZ3k91KzRaST/VqKg5KnsNbebG/WdMYzyHI88RQR8=;
 b=Dna1VbdzoDIzPG5jgy/eVt2cUPOCp/guMAIxYCEDcNSEiST/Wt2GA0ZWZGJXJWvq9tKwii6jhmY5M1HEi9o7yMeEQHVzR0S7TBRjYcXw15i0Z0P6TxqNLBpkF97ZWiQPUAEQmbCegbr5Nq9pvgEeVa3u+8nYlUcdIqWUO06T1Vk=
Received: from MN2PR05CA0010.namprd05.prod.outlook.com (2603:10b6:208:c0::23)
 by SA1PR12MB9489.namprd12.prod.outlook.com (2603:10b6:806:45c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 09:35:46 +0000
Received: from BL6PEPF00022573.namprd02.prod.outlook.com
 (2603:10b6:208:c0:cafe::60) by MN2PR05CA0010.outlook.office365.com
 (2603:10b6:208:c0::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.6 via Frontend Transport; Thu,
 24 Jul 2025 09:35:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF00022573.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Thu, 24 Jul 2025 09:35:46 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 24 Jul
 2025 04:34:29 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: Arnd Bergmann <arnd@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp: reduce stack usage in ccp_run_aes_gcm_cmd
In-Reply-To: <20250714145921.699060-1-arnd@kernel.org>
References: <20250714145921.699060-1-arnd@kernel.org>
Date: Thu, 24 Jul 2025 09:34:02 +0000
Message-ID: <85frem9blh.fsf@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022573:EE_|SA1PR12MB9489:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f726351-558e-4990-9c5d-08ddca9577e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xaP4ffAZJYP8MQW+MXHARMvqhJKLbz+Zgu3Mold9XIxVKwiGeOYmlw8MwjK8?=
 =?us-ascii?Q?B78+aK1+OAePjg+7/6MgWTRd3wss9LO9UGBznUbc4Oc1pV2k+GG7WmU9URKt?=
 =?us-ascii?Q?KF99xkLzqck4oJ94SPpVLmbl6zQhowO+d8OsFiYST0OwLCREKyibLwBu6JD3?=
 =?us-ascii?Q?RTX5p/yWpD90KVK+oXIOaJt46dwXnfkjdN41qGZQfL6QYFvNWpxNYbZDEF2O?=
 =?us-ascii?Q?0O50toL9KmVgU2WfUVmQoI6SNRwysWnhz9jQBhsJudU7NjKoT3mSSWUQ6aFg?=
 =?us-ascii?Q?Sy6ZTR2DuZkK9eMdgOJEU87XsrSsYWBWkbXDXGMtpuY4OpHE04lKu6oZrEo9?=
 =?us-ascii?Q?BHIuM9gWfPmFvbx/oz8FONvCFNk88sFLGIFA0/DptL7NcFIBnoH2697On96T?=
 =?us-ascii?Q?77gFYEvoaHS43mHmm/t2fVJDI1d3ywmHL6aR0smYZBq6WXTRrKe5dHMTNjry?=
 =?us-ascii?Q?VIe3IDdhnEOdPFFjMu3MtHBrn31mQXpfwYjecC7VbPEHLwr4JlpbF5XEbtCn?=
 =?us-ascii?Q?taOmwFhe2lx2ix3Mn6xLKYqO86plQVAEf0Am3gcxrY4aWI+liuBaPyCu1hvI?=
 =?us-ascii?Q?AcRK/6E8JYL2wEDTDyCF6NKVx8KXxA9JdWSJ/A7xAHsnLM5FYVhGQZy/5E7W?=
 =?us-ascii?Q?zcuO73lwZH3J3I7HU4ZHe6g5srcpAKxic3GFlSFJixDf61jxsIM/iR1OumtU?=
 =?us-ascii?Q?6N8T9ciccO2547AdY2vKGCVVonRaRGpPuwkhsWb47ixv035zojuAklaauOG3?=
 =?us-ascii?Q?6VFgy1ezE5gRBlOR3ww/gCkckaaRk7Gk+areqFOWzpNPJrBvWNkZU0dod7/l?=
 =?us-ascii?Q?y0rrp+GFhv3gedlCx7QX40yWHjx05npmVNZ7raW0L6gNEuJMDZn//6AwrDOo?=
 =?us-ascii?Q?zuWGgB+iQU3VR/HyUFbBjL6hWxHztNUHryxbFh+Dd22BjGmWtJI2MOUs6Wzn?=
 =?us-ascii?Q?7eK2HFJShRoebw8S1gEVp7xXKuhSWG1BUlraKu4rWzgaxXHt6ffFr1eUCcg9?=
 =?us-ascii?Q?KGcoy5dLsbFx10KHZW3xybTJp48bvaRFSliuMpp7F9XQ2n5DAg2Ho3S8/lbV?=
 =?us-ascii?Q?Rgp13cPhOFVhR4Bkad7bOfINiMIdkcC50//x/yxpTv2ysvAc2DE9UpcQjxzn?=
 =?us-ascii?Q?NdtWHfWNkxvsLP51HyI+dOUmV/TFF/kiHLM6vNwJJrxT0deQV4XTP8miNdLa?=
 =?us-ascii?Q?zEmjUnIvy3aL+P2yG9dIhFA2qxrRcD6or9wA9oao0BpjD5icMMfCmLS6ZBg+?=
 =?us-ascii?Q?2TuzbRUDCDvmYHHWp3N0wfJC3SL690TA6rBQ0j6KRjiUTYWkBZytYraWhRHh?=
 =?us-ascii?Q?FjAJ9vKsJ82aYQx0CG4s9kLBwTdiQPMTQkrX90fjVIuQCILdzritGNOoQKPL?=
 =?us-ascii?Q?NpLcAb70JC65G7kIJM1Iz6qGPORNp5pGxTTMzVn6NWBZHOR+iJJ03O2WFkZh?=
 =?us-ascii?Q?J8EEVOBXtv9YOdmNTvcjEfsNvvGhDb/WAU6pC9reGbINSxnuBrspLUWwzL2e?=
 =?us-ascii?Q?80XbPIZBtaQCTMjuYwebE8dLpws6tyaMW6An?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 09:35:46.6251
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f726351-558e-4990-9c5d-08ddca9577e1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022573.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9489

Arnd Bergmann <arnd@kernel.org> writes:

> From: Arnd Bergmann <arnd@arndb.de>
>
> A number of functions in this file have large structures on the stack,
> ccp_run_aes_gcm_cmd() being the worst, in particular when KASAN
> is enabled on gcc:
>
> drivers/crypto/ccp/ccp-ops.c: In function 'ccp_run_sha_cmd':
> drivers/crypto/ccp/ccp-ops.c:1833:1: error: the frame size of 1136 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> drivers/crypto/ccp/ccp-ops.c: In function 'ccp_run_aes_gcm_cmd':
> drivers/crypto/ccp/ccp-ops.c:914:1: error: the frame size of 1632 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
>
> Avoid the issue by using dynamic memory allocation in the worst one
> of these.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I'm not overly happy with this patch myself but couldn't come up
> with anything better either.
>
> One alternative would be to turn off sanitizers here, but even without
> those, the stack usage is fairly high, so that still feels like
> papering over the problem.
> ---
>  drivers/crypto/ccp/ccp-ops.c | 163 ++++++++++++++++++-----------------
>  1 file changed, 86 insertions(+), 77 deletions(-)
>
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index 109b5aef4034..d78865d9d5f0 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -633,10 +633,16 @@ static noinline_for_stack int
>  ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  {
>  	struct ccp_aes_engine *aes = &cmd->u.aes;
> -	struct ccp_dm_workarea key, ctx, final_wa, tag;
> -	struct ccp_data src, dst;
> -	struct ccp_data aad;
> -	struct ccp_op op;
> +	struct {
> +		struct ccp_dm_workarea key;
> +		struct ccp_dm_workarea ctx;
> +		struct ccp_dm_workarea final;
> +		struct ccp_dm_workarea tag;
> +		struct ccp_data src;
> +		struct ccp_data dst;
> +		struct ccp_data aad;
> +		struct ccp_op op;
> +	} *wa __cleanup(kfree) = kzalloc(sizeof *wa, GFP_KERNEL);
>  	unsigned int dm_offset;
>  	unsigned int authsize;
>  	unsigned int jobid;
> @@ -650,6 +656,9 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  	struct scatterlist *p_outp, sg_outp[2];
>  	struct scatterlist *p_aad;
>  
> +	if (!wa)
> +		return -ENOMEM;
> +
>  	if (!aes->iv)
>  		return -EINVAL;
>  
> @@ -696,26 +705,26 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  
>  	jobid = CCP_NEW_JOBID(cmd_q->ccp);
>  
> -	memset(&op, 0, sizeof(op));
> -	op.cmd_q = cmd_q;
> -	op.jobid = jobid;
> -	op.sb_key = cmd_q->sb_key; /* Pre-allocated */
> -	op.sb_ctx = cmd_q->sb_ctx; /* Pre-allocated */
> -	op.init = 1;
> -	op.u.aes.type = aes->type;
> +	memset(&wa->op, 0, sizeof(wa->op));

As the memory is allocated using kzalloc, memset is not necessary here.

Regards
Nikunj

