Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011027.outbound.protection.outlook.com [40.107.208.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9AD1D5ADE;
	Fri, 26 Jun 2026 15:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782486461; cv=fail; b=AKM+nVCGdCCOCq2OEOlhZQxWwc8F5kknuOJ/2R6NBxkTpBTlehj3CyL/fv+GXQVUxIl/4x3Xh7Uhc+vaXxHZA6E3JJ12EKP+3dCSjCuslGKQtL66PNFXXKPTURO1TAVqN/jRA1jcZN8WrBKveVokksiBwBsSEshQWXrOF8xYtJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782486461; c=relaxed/simple;
	bh=4v57BDCmnjvZYHbV/ADwoQMxoARkygg41ALj1Aiw+bE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cPK1jDRtxDE2knbmYlS048+e00wxAaNkMLDgLk0YJrtrOIj6T+7fM7ltQw7wJ+5Um7buw1bX7Ozw37NIPJRrb7U42IVQz+Zq4dO0yotbU90tKg+BxEic42rmt+wPZZqzntrSSxqV4CxBRFU69/8g+TOF/1XMBtCE9aylj2vEneI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=urjBklV6; arc=fail smtp.client-ip=40.107.208.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="urjBklV6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mrXTLuLlX4SHTAHtYmWu5Np5xnWKuphUK+8IYndIbOgI3aYzIVfm0gAeefQiKzbgpBqe4xMil5RJHwezHoFfL2CuFqxSYGvzJBKQg17ToQ143dS7jy5O20jeqd/vEmP3yTejQuO293u5LJVCetTrWw/rZ1CDoBYrdA6HORA2YEe1DTMotlQnaWOQXDZQVZ8Xa265l27k1VMfvPYmw6egLQIm2sYn9am7rf05+g3X6a11dN5yPa9prek/t/aOFm0hw/Mijr///2VHg9b7gVm7EONQWN6sIfJzgndr5LWN1YIFlJd4l+nFFJTACbuIh04jg3lDzBnYjiZOs2ZBB6yt9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L5eXkn5GP07eRs/dNhARGljfr/HRmEEG0/vTJNTJShQ=;
 b=FgrozDERYoJ8DWs+R18F6l3QTp02UlXL3xPIrTtytjBD70JXvGECFcsNVze9mlCHM28MVUP7EV0XW/U2GyHz0lYHWAJdalOhnoe2FxolUOpc5EzSP1vZXTlBSg17PLNMucdMZ6OZZ1aZzlPpRa2Jd2c0z90nBM51yu+vfrc/Y2uBIywpSvhPiDiym8U+XFhq719nOLAcY7eGW+4UMNuy1Oe+ZJzvFoUVYMpOia08wAX2ulxtXDVkEgMgDQe7BlUCnz6OqTwlpqZB3Hn+K7rkiMabv6HguhLPo39GRLLx38gwZOnwVgw9XZnhzm08NfIsCTfpi875YsK2wwgIf/JEbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=iscas.ac.cn smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L5eXkn5GP07eRs/dNhARGljfr/HRmEEG0/vTJNTJShQ=;
 b=urjBklV69WuwP7yzDSKdHJuak5MfS8KZl3sMG9oEcwpK4bkE+koS8oIuZVInV2V4ExMT7nXXY4l3GhAGNyN+Wt2JOyEEvT/xiGw/E7uLhF3WCvYYBhKmlcClq1Vx6AqPYAEqG8xs+tIh4DvqoFtKHZZSSU4HJ/cUuRsv7EeL93t4vTozy+EF7wj1o7cAyWqA41sm8gfYuuGqkqEglwB9THOvTZMAnsegPIx8kmZmHHPyJqLFu4N44/x0ghcHdiyc6QSIyiTNFNhwjeobm3JunUt0t41OC4WdzXq43jRotkRE6lowUbryTQMKFMOxcKMPfbBreNfGv/tTp7RRDRjLWA==
Received: from SN7PR04CA0045.namprd04.prod.outlook.com (2603:10b6:806:120::20)
 by DS7PR12MB5792.namprd12.prod.outlook.com (2603:10b6:8:77::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Fri, 26 Jun
 2026 15:07:30 +0000
Received: from SN1PEPF0002636D.namprd02.prod.outlook.com
 (2603:10b6:806:120:cafe::6a) by SN7PR04CA0045.outlook.office365.com
 (2603:10b6:806:120::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.17 via Frontend Transport; Fri,
 26 Jun 2026 15:07:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF0002636D.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Fri, 26 Jun 2026 15:07:30 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Fri, 26 Jun
 2026 08:07:10 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 26 Jun 2026 08:07:09 -0700
Received: from build-akhilrajeev-noble-20260602.internal (10.127.8.11) by
 mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20
 via Frontend Transport; Fri, 26 Jun 2026 08:07:06 -0700
From: Akhil R <akhilrajeev@nvidia.com>
To: <vulab@iscas.ac.cn>
CC: <akhilrajeev@nvidia.com>, <davem@davemloft.net>,
	<herbert@gondor.apana.org.au>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>,
	<thierry.reding@kernel.org>
Subject: [PATCH] fix: crypto/tegra: tegra_se_host1x_submit: timeout path leaks host1x_job   reference
Date: Fri, 26 Jun 2026 15:07:05 +0000
Message-ID: <20260626150705.5658-1-akhilrajeev@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260626121453.35043-1-vulab@iscas.ac.cn>
References: <20260626121453.35043-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636D:EE_|DS7PR12MB5792:EE_
X-MS-Office365-Filtering-Correlation-Id: 8117e62f-411c-48fc-b459-08ded394a498
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|23010399003|36860700016|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Rt2afTNBnNwN5zMsjuNYw35p6pIhW0ioRWMzhAnWGE3WqotIuJ6B16kpjmFNTTll7QynTtwNkySjRSJGZoPZTZoUulWUASTP0lbwH3QvxiAm1D0y/A+10wPOFS+M9UeUXAsqefsUlXBS3ptSJk556bF8n+u//3vP1lqvkiKbPQfDwbxVP8O8wdiKKEmm4QkJ51xbi8FY56HeKZXDeLNsOyaHFv2Vx2uSU4J1b6rXhRH/YbJl/MqBxAGyTNFfTxOWxvFT8O+4YZs4XnQgRVGgyt1quREiYJ8e9H9dhTnHh+of4CumyKKvDrEfIN/dq6eSudQKzZ60cKRT7YKbk4+MdwUEZmQXNQ3bdkj5C5PINPIAOJBoZ1UlVCasS/7EB+UKeaY86yXEYbZwXViQ5r25fU6awwCIkpBQXjOx3ik40u/yx68g/WYfVIa6BnG8nK7F/UoIoNxncioWd14C7e6ggPT1Onnwycpi5xfLti92q2bHp26HgiCtGDRl+O5+l1OeETLDoR+k8C5lQAj0HJIjmCxUhJZTNXxWdua3IWgcbNr44JGHyCmxnVj1oF/FJtbDrQoIWa6rnWrx21uYs3FL/XWtQ20Mq7ydiog66HnDEMFcHbgoWdH/lmvr59UO4os2wEGHYLuV+JbfEe6JDvcyEYI36uGnS/aRqBouILtOnwq8olXXcU184Xeu1tArXQONNpq1qtOneD4blopGz7z9Og==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(23010399003)(36860700016)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Evs8waAw52CjidUGQl/oU8SA0wxTw6wKv/zilbA3kGHButWAM6BmGaL5UL9VoOPy25Od3nGe2ymA7mc36eiwiDGi9pupj+9/huw7VoUZ+0egGf1/lXqrsj+C9IlFs12udysht7edA8Cw6YTwj/DxB04loaZXgOREgf7ZfZuJ6WyRlvN8N5BhsjIgFmhO5KdWCgZCm58flYZzga94G7KPCnXSoLH1VTgkQnciXFvqUENUDKwSOlHZXrl5BE+9FMmAtQIRavx32Z5UfjvtpQ55z2+2gnZiEXQp9RMk/eh7XxEtI3vHpQ7f1ah1mEIC7nKcheZoDXaxy72mHOWxP/ybvJv84pq7d+TRboLapkegCWlh/PZ7fVTmIgbawYo98qx7RBj3xytN5b2+RDoqdN1fNL9bD/HJDjr2lKnjGLYnP14PHVSoN5ogqRj/0T64xEBb
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 15:07:30.2055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8117e62f-411c-48fc-b459-08ded394a498
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5792

On Fri, 26 Jun 2026 20:14:53 +0800, WenTao Liang wrote:
> When host1x_syncpt_wait returns a timeout error, the function returns ret
>   directly without calling host1x_job_put(job). The job reference acquired
>   by host1x_job_alloc is properly released on all other error paths via the
>   job_put label but is missing on the timeout path.
> 
> Cc: stable@vger.kernel.org
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>

This fix is already applied in linux-next as commit 6ea0ce3a19f9
("crypto: tegra - fix refcount leak in tegra_se_host1x_submit()").

https://lore.kernel.org/linux-tegra/aip3_Hqk876NZFHf@gondor.apana.org.au/T/#t

Regards,
Akhil
