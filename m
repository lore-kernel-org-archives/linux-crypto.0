Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010008.outbound.protection.outlook.com [52.101.201.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2530B1FCF41;
	Fri,  5 Jun 2026 05:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780637690; cv=fail; b=L03l9mo8o4WGtR+aaUpAO/QaH+TH3Eb8BupAYELILRqvDFMspTTrtNoG3hjqcvcGEeS2Q1B4uehWqCTRuOCXkTya7OZo+J1W6kCeB4ONanvosCrUUSdPAN05OFCiIqQMXUtf1ZmbeR53ohMl4Ts0ovIZgWp0/8W8Tg6rMT/JC4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780637690; c=relaxed/simple;
	bh=ofynJZykRO7utYdseh7eMj1ydWzzX1fwF4Vp7MZ+0U8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HgY0B9RgQGhc61lOl2hDtmXRgu1bb1R/Qpy3l84He/t50E4A2dTv0WLoVs2UnBDEOzX01W+Dp8InINklOUlIhkwKjHSe7nzeUQPetUf9NxbMEAGoNgGAot+kXhHgOX9c/W+0gTGZlBe1nZaBsKv+uzxrZvLy0BOzlb842fBO968=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IvpD+GYG; arc=fail smtp.client-ip=52.101.201.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IvpD+GYG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c2+YiOLDSGf0z3DBd3hWyjHpkv6zKglvtH9p/37DXL2G8cNPJ3VeK5AHi0vEDFrit4hfKGW4MD3DPkhXGsOik9ix4qkfmtkuQC8LFNcspAUSngubrt4zXPhK7Dk7GkprMfD7DZrNZ4iUzXVw6uDkHY/E3dBOKVErTB40jYc2SFyNsUlKB0RfQ7CM+P04Ou/CCdNvJpYhG2XrsbK/nf1tpeZxtx7d4LFGiLXqdgMh6/vtx2dw67CqLK7sDN+KxLsyFo8dBzl654Ko3ojivi4us3ssHV9gwC80Y6bp7fNqDJOuJ/LWcfGVKaOhDlzEEenifKuQHz1OebR+8xtPcBG92A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P7oABNf4MB0O0LPodZD7JRIJ6SwosMF4U/v1h/CRifU=;
 b=o0nX5HvcC564Yh6vGVMVsBcC9A25mRQep7rQMIpFA/oFiZI63vlDsOSGHUR4FLl3KoUkuIDtNBkq5J5yTmYIJftZRd+KT7GaTyGhgFR8o8QdZn4f0cRE2z4xH40Np2s0d1XyIa3rXnTYCmZfIgNjkkb7mrY0Ot5wbxVMp2qu6YalXcpKOinFrB/s9qh3r+pm7Otqr5sY3DKdc5qmgKkfMED6LiNKeo03q+9pw5R7ueI4kIycVJ8iCDcuIxY+b5UCT/OKIjGsEWwZAbWO0cLblcyI4w3Nd2GbLMsXCsf7/T24E/RfE5cxxI8FTuCsryc5lH8mGJkUSZqVNntON5vDeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=iscas.ac.cn smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7oABNf4MB0O0LPodZD7JRIJ6SwosMF4U/v1h/CRifU=;
 b=IvpD+GYGb/JYEkY1r3ZY/cYmxw54tejm2YcOpPMXDAiPq8Qe2ebmwsyT/0KWYrJFlJuuxMWSNm9QVpfsRYFoekA/n40D3xdB6YkfQcprSwtDXZf8DvOLNm5J+ORuF3E5uCL2mJjFOXxWGpu8I0nR5Go7H5SqeQvDok46aQx6xCss/uSF/NUT+ZTf96GTNxtzUX3ZdyzmRp7W4WAF09f2gqA0EHFiYagliGWWI85Rr0y6UStDrzkVprimQqUSmPhIHUafPq5yiR0l/mupI2gCi5d2WzYmsxhPMcDZjRjt3SjFluJMc7GIMT1sAsEzhWzrWVnJDHu+h5fHGG3v3SeS4A==
Received: from BY3PR05CA0041.namprd05.prod.outlook.com (2603:10b6:a03:39b::16)
 by BL1PR12MB5706.namprd12.prod.outlook.com (2603:10b6:208:385::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.9; Fri, 5 Jun 2026
 05:34:39 +0000
Received: from SJ1PEPF00001CE4.namprd03.prod.outlook.com
 (2603:10b6:a03:39b:cafe::37) by BY3PR05CA0041.outlook.office365.com
 (2603:10b6:a03:39b::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.8 via Frontend Transport; Fri, 5
 Jun 2026 05:34:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00001CE4.mail.protection.outlook.com (10.167.242.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.5 via Frontend Transport; Fri, 5 Jun 2026 05:34:37 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 4 Jun
 2026 22:34:32 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 4 Jun 2026 22:34:32 -0700
Received: from build-akhilrajeev-noble-20260602.internal (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.20
 via Frontend Transport; Thu, 4 Jun 2026 22:34:29 -0700
From: Akhil R <akhilrajeev@nvidia.com>
To: <vulab@iscas.ac.cn>
CC: <akhilrajeev@nvidia.com>, <davem@davemloft.net>,
	<herbert@gondor.apana.org.au>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>,
	<thierry.reding@kernel.org>
Subject: Re: [PATCH] crypto: tegra: fix refcount leak in tegra_se_host1x_submit()
Date: Fri, 5 Jun 2026 05:34:06 +0000
Message-ID: <20260605053406.4142008-1-akhilrajeev@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260604102706.3787771-1-vulab@iscas.ac.cn>
References: <20260604102706.3787771-1-vulab@iscas.ac.cn>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE4:EE_|BL1PR12MB5706:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f35b96d-c965-45c6-7f29-08dec2c42251
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|376014|56012099006|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	GSCOVTNrf6uLP480moDW6PH7/xCjhEIA1DX3UmHrcfpA/cuTBfhCkLC770Y28JvZ2maxDeZMxxtYyMPfom2nXDqXg5jzoTDWgpgXnVGTIHuQbpibhdT8Rn2dtV0uodClm2F7Y34sYUPHIoGc6XLLGORbCj4pqKKgqoagdUC0wSa8MFk0QaMbgWN/pqznc6IO6P5qo9H2CawepbEZIpjxm0WJW3VNL6Q6Pfa4YpvIkIGNRnOYysPvE1OeX5baGZ6+Rywf7aYL02nsVR0HW+OwJes4yNwiKyzZ+lSgYjW3uNie8yAroIHQrMNLP5nzc+H011eyZzI9PGRWll9s8pMrL+To1PnX8OXupXLhcD3eqDBogig/ZkVCBzc5BAeiHzbfEjzKLJkg+DnpLOLKlDpqYYosaT93JODkTGNVu+j0c7yrLSo9nhCSHh0uHRdehnCvbWmQLgXwfZY+zfi7Kd0d+xhWz95o2gy6xKq8WM5SCf3OZ4JoXKLPlWbT+W64dcgfIBQbT8fuN3RFB8+V8n20m0382LAaWrYN9aFq/sa6GQ1DkRQyNxh+X+6Z/hLq/NEhEAvu9M0D7BAGyq/xGKo2a90EW/ehEIz4CYWAvX0+OOx8VDC9PWJQCSPiv1EhzjHVThZsowOwMMzfGf1PIdIBh7mq18enTKTfKj66kbdVACLlwQ2qAG9Bjk5scTy6NPghBVtE5KhK2Dzy/pfjKDP3kwJfF2ySHA89NC7sXtT4MF0=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(376014)(56012099006)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zBuPS66bA9gcoQuIbrSG3luPuW8FINZ58TUTs1xIX6HZkGgZwCskAfop1SK3BR92sW0gw4FnZvRJz3NYWhDKKiVeVmSeDsst0sNYhG2gzztrrSvpc2xCvrnX0dZOezDT3SS/MQeN+fyRPhuPCKY4ZmBzx0pEJMZlLsAPKXW0WIF0LP9rTH3++8EFQkswkeT9CFw/VwH2x0CmFDlVa04L72clxBQ4N0lSTP/omoJnr3ymdsL3yw0keV+dzyTE3aUVbgbCZHFNeoGsgTUDdHjOSQ88jxcr20iqu0ADan3SZRQNWcYAhLSoRZDvx14a9/gpkH42xCXPZGmVJG1590O/I+VFwNRG9/ThWet+uAk8HZoQsm3xSuJLcvDPHBcLJmuRg+vleuErYrAOvHTueTrGzXdP6Sid/bZS8JZ8ETWBH3gmCLKIWT9dZpqKJ0a/MmKI
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 05:34:37.8033
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f35b96d-c965-45c6-7f29-08dec2c42251
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5706

On Thu, 4 Jun 2026 10:27:06 +0000, Wentao Liang wrote:
> The timeout error path in tegra_se_host1x_submit() returns without
> calling host1x_job_put(), while all other paths (success, submit
> error, pin error) properly release the job reference through the
> job_put label.  Since host1x_job_alloc() initializes the reference
> count and host1x_job_put() is required to drop it, omitting it on
> timeout causes a permanent refcount leak.
> 
> Fix this by redirecting the timeout return to the existing job_put
> label, ensuring the job reference and any associated syncpt
> references are consistently released.
> 
> Cc: stable@vger.kernel.org
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Thanks for the patch.

Reviewed-by: Akhil R <akhilrajeev@nvidia.com>

Best Regards,
Akhil
