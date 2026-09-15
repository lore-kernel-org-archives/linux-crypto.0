Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA19B496D42;
	Tue, 15 Sep 2026 09:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466212; cv=fail; b=A12q/Jl6bmRlEWcYxCyEBuMZh2/z1q5R5/iAfGmwNIlrIPox5GePUzrbDIReu9/JmtoovUnb823ViQEqW0lagmxkNZtN57bjlN/Ci2Z3D6A4H2TzZMbmQbB6OxfPo6EsK6xsyawSBIoJy+Rw47FaXSUJCwCocslvJESHtpsJFJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466212; c=relaxed/simple;
	bh=RTU9a9Jfk+9KKkW4SLFWJDg6vliwPpbeJTjMsGaxils=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=tDkzNFq67VstoQg9v0iZRLqE+v3pn1/f9w2xsGChd0X8gucpf9yenVHBD+cJpTtzH4HZAItV6YcqVocfRt5EgTi7hknTA2vg9tUb0iRj3juXDXVQkFhunXd8hEspdbSq6qRyPE3+MOkYwpRrat4cKTroKdO0oNe9oS678d8yBo8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=lZw8Lcad; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=GNtbHJQf; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="lZw8Lcad";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="GNtbHJQf"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9fBmF3810825;
	Tue, 15 Sep 2026 04:56:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=ezgsnIVBbD5j1+lkPVQxk+QbT7H1Tei7WoYan47Q5
	E4=; b=lZw8Lcad5NGV20DAdZo48Iil9ioOHCgd+niJIyvcS2Oh3CSdIolLS1GCU
	JrsBGMw8lvXqvE24rukrOYMdqCU4LroMJ6esCsEPBK/mx/J/5pAqhVlc4H6eFtjP
	al1gvNMCysV9nWiIUJIqcGJG9mpF1NKZPv7hh5jZPS88hGIPLZamHR1FPk1uhw7y
	HtSOBCBuypH0FKcDGLG0RUxAWbo2JJIcAXR/11sBD3dq6wzuDCBP22RrrkTLOC3D
	a3PUQLiEl8aan/f7x9MD0Fkd8SNiGuyasbPmr2eebIPMRRdgI4X/eYkv1gET82Vn
	eyq4uihhopaEDT5wFEM9qLfyfXlWg==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012048.outbound.protection.outlook.com [40.107.200.48])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gq362r9yr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:44 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P411Fg+qfzKb9vUUGgGXLGqVj7yzctn6cT+sGySh7AlAMTJraKFjY0u7VayK3plQlj+43NfvS4M75OczjM3EbN64S5VWFX5sO4DH5eXDtXV3BYUuwffJLcR8sGwGB9MjNYjOQnZpA1s46J5p85RqAT/NPjmtYfjYXTSd7B0IlLFre9GQ5P8VM2UAKfDqkPQR4FIJRsJckIt+/9sHRPUvBe/9+l7YHYmEu20MLM732Ng3evTwZyttLigLSdCGF6KP9R9reG4kqJPaYhDNEKkm1ikgjMxV+9CEigvf4NEIGVb/dv8CeQZAQsGjp0n/PUjioQwcTltInT4pxr3nJst72A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ezgsnIVBbD5j1+lkPVQxk+QbT7H1Tei7WoYan47Q5E4=;
 b=TFdyDn+yLUhxmrH20h/ts5Hr+B1U844Wp1AelmYIKPg4CgRpMZdoo+vE0bQTU+/gxpyzTbttA5uMaGxoesV4HubKXJKWuK7LLdDy48+Hj+5+5ibUOFXOqqY4pYK6luZn68TusBqdpT4pJVXNgF5qDZuJUqWraZALe8QlWqy1tMWQqfcTsCootiqc5TFRnnOGsKnCl0GcQ8mCMUrMly6IxSKrmiT9690GGTm2hfmQQHntqsmppik5DATz7shVlcodQIS+Jpej7emcx4wEj7QlFk73Zz3Eq25JRov3Ia0O1QdW5ozTHKazSxe8uclc1GKjTSHuBR9l/P5bkUYT1FT+Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezgsnIVBbD5j1+lkPVQxk+QbT7H1Tei7WoYan47Q5E4=;
 b=GNtbHJQfVBIYnZ8C9/viV71uFKvS6OZwn+XRvXt3F0T+hFDOP2tBu1VU2bzvicI30jnduFGu91Vcj0nKP9nhTimLN3T1VvDwE8yQUpbPLQMun0ZpeMU9LG18fxZbDy5xQnucbAg1G9+CiZK0sR9itXA2JsX9iW2FpxcsKDX5HJM=
Received: from SJ2P221CA0012.NAMP221.PROD.OUTLOOK.COM (2603:10b6:a03:5db::16)
 by IA4PR10MB8659.namprd10.prod.outlook.com (2603:10b6:208:56b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.8; Tue, 15 Sep
 2026 09:56:36 +0000
Received: from MWH0EPF000C6186.namprd02.prod.outlook.com
 (2603:10b6:a03:5db:cafe::27) by SJ2P221CA0012.outlook.office365.com
 (2603:10b6:a03:5db::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 09:56:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 MWH0EPF000C6186.mail.protection.outlook.com (10.167.249.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:34 +0000
Received: from DFLE203.ent.ti.com (10.64.6.61) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:55 -0500
Received: from DFLE202.ent.ti.com (10.64.6.60) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:55 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:55:55 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB823000901;
	Tue, 15 Sep 2026 04:55:52 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:18 +0530
Subject: [PATCH 12/30] crypto: sa2ul - remove redundant sa_sha_digest()
 wrapper
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-12-57ab34e97162@ti.com>
References: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
In-Reply-To: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>, Keerthy <j-keerthy@ti.com>,
        Colin Ian King
	<colin.i.king@gmail.com>
CC: Andrew Davis <afd@ti.com>, Pratham T <t-pratham@ti.com>,
        "Kamlesh
 Gurudasani" <kamlesh@ti.com>, Udit Kumar <u-kumar1@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Manorit
 Chawdhry" <m-chawdhry@ti.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=1724;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=RTU9a9Jfk+9KKkW4SLFWJDg6vliwPpbeJTjMsGaxils=;
 b=S2QKNZyBecFpKPveoQsJHPJqupvh2Svf9G3cGOC8XwJCd/OP897cv8bqwbZGbojHjk9Gshbbx
 Fsq2Pi6XDLQDZBv5ndyJL4tQYfvxbNao51Wkjb/2miHZzeQ0xH15YlA
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6186:EE_|IA4PR10MB8659:EE_
X-MS-Office365-Filtering-Correlation-Id: 53c52097-bb5e-4c71-f1b8-08df130fa05c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|23010399003|82310400026|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	SjoouWh7EYPSQBc0SiU8ImXFJZbsXODrvHkfG2SHkAdiGhyzJUpxh2N52W1dECdZmWxz8Fv9Hn6PgZOxk+/c15KkXWnZA++Sa9GnA8WCSCAQpce3LrvKsUZHXQweXKJ+KeTz4mOK22JjvOVRYkXnAeyo4jciioSf/aVmhIjWY8pTg/8AYSPDO4x/qhLUB2v1TNzBdabUxd3iZk09lqX0JqlnbjsYTzVHU4JOz6zrv37oQstvhavp1xUuz6V1aZMGawMDTM4tvFgxRZsQ5wh/GhbhVaTzR0yc9WmCVrWqrt9tlnXTwLQKH24A/tpgUJY77LqVGukC9oWdcdKjIhdWI5uop39G/EIqj03ugglcY/7CZZbEKWxwZgubUjepGoJEvSvVxnI6W9aJ0+ZlHIeeuUSSbU4Z+AzVousYp+X68wE+244G8kZGTmLpjuM1MumIsftFbefvYXJz7j/Mq4j3WgYyt0iAjRy4Gu46J6AT0KwyH58HdLXALDS3QqSIIaWz/CNf93sT6dGFPVgKCzXxJvWUuRiyQQq6cMYvkQKJujEy3N3mkN2zY6SKavJ3awI+TgbdOYCOaJLxWv92ow2uN0ETCvCzLbIvzSrXZtD3AwJ6NnuN7zQVK6gQ/3yAyxKNLp53gYxbTJmS8JDRVsCD9RZSXQOFXL/WaMd0/2WHX2ux2jfnCz+szoFtJAc1FYII7sXtSJNHNo/jYvasQFRTAw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(23010399003)(82310400026)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5nE9X8Q4hvhJVmGhdOO3nOMb3HHL6C2XqBMw+PFUe7h4qwUr8/jfY/T2uNNH2uyU8XA4rgkVOEJQatSRH5b+RA7p9S1hP2QESF1O9mtfMCES3Kg/bvp7/6WyeGI9jllewCVp1/lx04fpzyk+iWh8lyTYtx9AIrQHDrrR6GdSm9ewMMTbkVOAgAdImv+SBe2aqUpzluM7Khey+ZBzRL3NcCaMp6VZoecHTUZPCBVXlJZ796YVOySwWd9ulY9+t2GOw65/nbS+tebemDR3Fuldkh8CzMZBZsFFrlV+ry/0G+4FX+SN3fDRHPOGEotLJDVZqaSFce07xmNf09qlLjeugN0TuH0s+uhDqA6CrB4qu9EqPfg7HR9igxmF3l8Ze4tRk4rlengbarzqF52HYxtgP5b89eAURBH7k4bzxoWQFPig46zOUFddD/3+htgcDoRL
X-Exchange-RoutingPolicyChecked:
	3XIQxMamfajxbxhced69U/3hc9Jo2VWjoCBNEoNAAUK/hz/ShNtQGuRHCkY+F8u45fviKBzNw8eEZNV5pfJkitbZ4WqOfwzhaXX49OaiXA8Je3wWmOgR4vRL1sGFJZ/FPPXCaR16I8UJMfeSPOySLbusjQ13/jdsytj8eWr05Fif69GlFo7DF6AAF9dKj0HO8FoVPD1dKr70D767dTKpg7O1jtxyqGEDGOQ3mfYBgjgdpFvimGgqw465/HuUJxGq5lJy/Cjm+5AH0eYlIkaJx+L1V+I5qX0DaNgoj2oNPlPoMCsms0JuRzlXOnsgtBR35jjixESPBibfyXBROVxPRg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:34.4422
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c52097-bb5e-4c71-f1b8-08df130fa05c
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6186.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8659
X-Authority-Analysis: v=2.4 cv=P9yvFSAu c=1 sm=1 tr=0 ts=6aa9165c cx=c_pps
 a=JJStoDgKLvGmSPu1zToK9A==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=SUp_HzdAlOlFxKILCdgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: wInvk3OOdvv61eUtn3BghPIDroFZ4FKo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfXw5zUDXXBroVx
 Od7VqyGJTJ1yxYuulZP5M8WKhvL9BjKnhNlDxTkRnxzt/dVJlsLK2cnYvNOfxR1Oz+vMRFL21Lz
 nSwWhdF2zOpop66efBW59BtW+TzN+o6/0JqVbuiDsUkuoug/Joor97xOKedJxtaor6+LsSfKqkK
 T4b9Wz3wnaP9hhnpuk28o2pca0GWzdjauMWuMoJQ8zxzCuCE7inGZkecNjS51ZYJvWaoEN2t6dc
 nLc52ncMNaPLfChDj1cVk8Rwk57qd0S3dE/rd3Jkf2zSOsGicvb837NoTIBAQdCpJjBViEG57HZ
 Ze42TJbMa6oHLBtk2aNbWoE5ZLaqnOsbMMGxqWEbBN3GpsnvvBu2ZqDLCYT+t7rv5TYnA9tpoXa
 taKKZVdcU0dOZvm52JWhEeDIKHc9j8UN7Ha7V6zCD/KfAtHwLTzzSYUoxvFfHis/1mxGoiPKiBL
 S2MJ4XJnDTp9pfYKzLg==
X-Proofpoint-ORIG-GUID: wInvk3OOdvv61eUtn3BghPIDroFZ4FKo
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX/u7M9IFoR288
 01eU1bZdWf6a3qdIN2aE0BxlMVO7AWhFZN04xohen51Yh9U8OKbbJSAcBNx5uCwjxH6g+X+h10t
 jMft2ZuBgWsV4hsGQniuog4Zy7hKtgU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150143

Remove the sa_sha_digest() function which was a simple wrapper
that only called crypto_shash_digest(). Replace all calls with
direct crypto_shash_digest() calls.

Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index c774447e7a5a..673cd1458948 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1476,11 +1476,6 @@ static int sa_sha_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 	return 0;
 }
 
-static int sa_sha_digest(struct ahash_request *req)
-{
-	return sa_sha_run(req);
-}
-
 static int sa_sha_init(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -1997,7 +1992,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.update			= sa_sha_update,
 			.final			= sa_sha_final,
 			.finup			= sa_sha_finup,
-			.digest			= sa_sha_digest,
+			.digest			= sa_sha_run,
 			.export			= sa_sha_export,
 			.import			= sa_sha_import,
 		},
@@ -2026,7 +2021,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.update			= sa_sha_update,
 			.final			= sa_sha_final,
 			.finup			= sa_sha_finup,
-			.digest			= sa_sha_digest,
+			.digest			= sa_sha_run,
 			.export			= sa_sha_export,
 			.import			= sa_sha_import,
 		},
@@ -2055,7 +2050,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.update			= sa_sha_update,
 			.final			= sa_sha_final,
 			.finup			= sa_sha_finup,
-			.digest			= sa_sha_digest,
+			.digest			= sa_sha_run,
 			.export			= sa_sha_export,
 			.import			= sa_sha_import,
 		},

-- 
2.43.0

