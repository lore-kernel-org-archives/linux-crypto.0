Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3030E3A542B;
	Tue, 15 Sep 2026 09:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466215; cv=fail; b=FN7Zfg3v8dnV4d4199NpizHKQpMyOpyb//vOy2by06TTkkkbK1quDDPer1rqcJMTjnBvlocbLK2cYJhlvAX6jMoQ2/cSEkTOZgSguCjqGiCtgtOtZyGg28XKC4qiRGS8jxIxdu9Y5qYDOZVT2tGsc8vZwXq0PFtkyiPHG73wX3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466215; c=relaxed/simple;
	bh=v27iqbCBNd4mzZ1V2fiVYfiujSIiy9dJHAacoAUbHQ0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=F7SoFc5mBQ03LrRR+l2n14dtiMYnHpz3aCDLfVXgPmIT5+ZMDsfMDzeMBkUA0DtbW5OVbeXAERCkauJ3FXJ6qxFNVspCwaiCeBqMx0knuIv8yeWP8fFktMi9+NhtVu7l2LcNc1o/a69ngDGv5GEVpaS6IJcxawpTTyc49crpbWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Bp63/0pw; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=hIQO1fWF; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Bp63/0pw";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="hIQO1fWF"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9fKVK4098102;
	Tue, 15 Sep 2026 04:56:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=o3nLt6vGS9cHT63eyxVlt2ezTTkVEMnRZ14Hr7dOa
	y8=; b=Bp63/0pwRRHnRVEsU2Gmoqd/8iExC+PuWjt0yW/jdSwun+KmHhu9G4HKS
	QAPz/pLczFCaY8JeWa3B3jKdLK8YuAgKMJ4ooLeVzkQalLzi7ZgkWfGu7AzIubTY
	FpGMmJhc7vffyeKR9ZBywmJCKKEAAq6fEsliimw7wMcypJxgtd+TyzbBZ2mFvgKT
	GA02el5QAgy9+X59GwLGb9hrmuDobdT/bLvRxXpXkOKUd5SUEyX6auutfls62gcP
	+JPE+unfIET+YTrs1HiWvXsL0Ty46TNsbot0YDRMEaJa4idKogcqfByBh/ScTYBo
	8cj6y8hFpI8EJDt9epoGPsvOHbqIg==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010001.outbound.protection.outlook.com [52.101.56.1])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gpvpjakjw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:48 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ow6HEnQpybOF015qxdAPMcHWkFUwYDymvSTQ6Z8ZKqIeuCxlrqVSUkh5n0BPPtYqZoBJ/nWNckLwoZHIOROjp53hTDWAJhrThhSQW5Ro6UlalG+pm+zrXNNar+Rh8KdmYfJ/kAGVia5Fnoy8eglply0P8JW8EZIwosrYV1rmLhhG6s4BmjoSeaTQcLmeql/ERy6rzJvdOxzPkGEbv4zEb5pLhzXmvEKorXYVY/hIDnAj+DWxDCplbZGHJTbEUlb3HAmrCxIh5CogM7qOg1LCn69wNQgsi/9vVAYtM+Vval7t85+rDGmyq4jOuEKKLE+1M4U7dShgehm5hJnVT5Wbew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o3nLt6vGS9cHT63eyxVlt2ezTTkVEMnRZ14Hr7dOay8=;
 b=HwDrGRBvXonVK4os2IP/jyXQW8RvAqhlueGZeVKIMip8KKUWhSs3lDFP+gzxbb5C4ZquCTGY0QuiZBGNlrmX5cOiHwGhFOrDvY1Beh59YVHjeCR9zKIeaegpkaco3P0+O4fb3pgz/UH5XHPDU64yb80/boiGkvI/4pTTXyInAqCdeSMa9G0SWxoiKRM+6snXCrQ7dHzjY4Bt/xGFj8Q9+2R2hnlUbue03EjtP59uBjZgiKi8X/kzhHP4NlFACbn8Vl83NAdam/p55NVq9a0+l42h6SsxbYq0ysZCReo16szCeO4E2LjCjOt78Od1xfsdXP0aRrpPmo5bD1+ZSVxVdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3nLt6vGS9cHT63eyxVlt2ezTTkVEMnRZ14Hr7dOay8=;
 b=hIQO1fWFIXrHrzmo7JvaGvcqmiuuL/VHd19ZESMK3HG4UifEQ6a4Pv1vztSucysrAWQrVDyFGaf5BKi9e2YNIXYcwdpavhBFRxYJYB3dGLoNuai/fecCRMHLYzKFTzQBzOH0qDviitsv0kQBiOx5ohKht4WF8yZVxRD83ZbTNU0=
Received: from BN9PR03CA0792.namprd03.prod.outlook.com (2603:10b6:408:13f::17)
 by DS7PR10MB5198.namprd10.prod.outlook.com (2603:10b6:5:3a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.5; Tue, 15 Sep
 2026 09:56:45 +0000
Received: from LV8PEPF00000067.namprd03.prod.outlook.com
 (2603:10b6:408:13f:cafe::77) by BN9PR03CA0792.outlook.office365.com
 (2603:10b6:408:13f::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 09:56:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 LV8PEPF00000067.mail.protection.outlook.com (10.167.248.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:45 +0000
Received: from DLEE204.ent.ti.com (157.170.170.84) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:37 -0500
Received: from DLEE206.ent.ti.com (157.170.170.90) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:37 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE206.ent.ti.com
 (157.170.170.90) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:37 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB8F3000901;
	Tue, 15 Sep 2026 04:56:34 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:31 +0530
Subject: [PATCH 25/30] crypto: sa2ul - fix data corruption by skipping
 device sync on unmap
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-25-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=1352;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=v27iqbCBNd4mzZ1V2fiVYfiujSIiy9dJHAacoAUbHQ0=;
 b=sfmt85vUH7+2aXI9iVmmAIV1hcnJWsgGvvzldVymwYIzpwRtmk05g00n8UTbE8rOrmEu32CdM
 X24/T/+lrPsDaRqPU/SPH/6zKHcpIwIIiznorBmqdOfIbXp7MGRESA+
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PEPF00000067:EE_|DS7PR10MB5198:EE_
X-MS-Office365-Filtering-Correlation-Id: 53eb4fe0-064d-40df-8604-08df130fa6df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|36860700016|82310400026|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	BXr58zcyaqelI5wtTpvgdR1crn9WCV+Xs5QW+lup1E9q/1jCHYWqS9DoF0kAOw+bZiZXRwQCAgsIGeYEPrbqklnTaWPAvNvWLg4ny0fytuMjJJAvsdCRtO1oxvjSBueeRe5H9hXqrIZBz4dKWhJm0d0GqjdDvnmTL7LS7Ck9gx8zoSY8KsTqe4MMM7fpTBB0/1OAEoZ8U9VJ1GNwRRkWyBX4LX8sUz4oF7Ei75Kcp8A8d432/y6rtr7Hk/qxRU1tKIwPasu9GNAK5WRIgqMEQByHXggnXOicrG9qIAE4MLXrSOlGD3B00EtKqXx/z8q2zp5OY7vhnfKRYG/wf63mUx4irt23ljZZiDRN3OlUNQfWmUrqy1USxzBt4xpK3RWn7367Bh4zMcZWehUv2SWvx427WSudIwiXNqJGtD1aq1zJR+/UEBhQiTlb6ZtcVvJvju2bOhHBFdvJvLVNZQAebpP09f3MSQWkEwJNCluec89TlYqWzGz0o450AyOj4mz01nHaL7crahSg81qse6UiMIkkpZ8XgmQJSD0u9lfBFl8El+E8CuRI5EpvGfSTa1jMr/7+2kMZwnEjutXHyf4jle04jgdscS2I4pr4HdkDSn/SY0P5vX3VYJpwgefMY170ib1Lh5/8lOoI3rEkfyvPakTWri93RCgSywntErE7yIjPrFbGnm9fl3+B+3/foeQZ2XVZtHU2woj0OwayvN2FSQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(36860700016)(82310400026)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	K4ZrAIFS+CvR+7RwOSVAEZLimWhm+O0KebSb07cUJA/kNMLRC6aAUQKlTVwTvWD1yrp51XIcjoL891wBbB8SCiwU5QVqfQCziIRAkx6I1oBAztCT5OutgnS4zKhQxwZLHx1vB54Cknu9zl6ifdw09lEdrNetcY2w2oiE/u3Apg5hojaw7uadyICqVgf5BUhNoJOBXQDAJkUkZVoyQ4voUVy//M9C40hBbKzFktLfOY8aDinxYxhdW5WoAW3kL43ek+172wPEYAHJ0nx8ExViirOijt5g9LYqvc837j/3Klvd8TyN/qIRyHvfup314t9fLFT6OW5BfPFIA1Otz+cP6pGC7elimia1KerC2qZG+nJu890foC9zkVB4opS6P6RdAAAE+AeNC0veRXhs2rXv6n19P1H65WwB2TgB6CKPcbQIjpZhbEzC63JLaLmuIv/i
X-Exchange-RoutingPolicyChecked:
	jU2Zx74+5E5nzgk0M0IQm4Criu+aPLx/N4NjH2lmssJPTcxoSJ9uyAIRXLx/rQ+Z7882TcoGLPzY2K0bV30lfjCRlncDT0rHObKuaejN4nmCXcPwIlYNW9EX/g45emy4ZOVEm79IaNXQ4nKy6fanvTQf/sQCoSaTtd4Ljvtux5oVFcLPgIlrInhXzjptw3NH0G+yNxdEIKUi+hya7PgYm1y9mJAti9b8uMXFojsaP+cDgic6OULLgX/HCcC3d87GxZMCj7H5IiyndhoTAe/QBo0r0ExMt5A/sAEC+IJbgc3+yVTl+O+jfGQpiEGwL/fHD4TJ8MxGRsEv9xgqMB4PYA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:45.3788
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53eb4fe0-064d-40df-8604-08df130fa6df
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000067.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5198
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX+9iq3M2DrlTC
 9D6rFb3xTDj2tYocPOLDeEP0zfr3l0FVb4qNsonCsMMhqgPlBv+2J9wHpcCSMoxDnPHAbB7UUi4
 6Acj6gy8aCXX5lqUk8QJhKkIDYj6N/w=
X-Authority-Analysis: v=2.4 cv=KvnYSmWN c=1 sm=1 tr=0 ts=6aa91660 cx=c_pps
 a=qHW1pi9L+1RZ0SKNcL3CYw==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8
 a=6SFUuACjUt8MkCrBzXIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: odVJQ6S7cjWj576q_jK6sSbwHVIivzKg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfXwXDmdx/mW64+
 +uzE0dRjdqvK5ritZ+dxWhm2thEQLihupiNNcpyxb7kfVbyd4lA1Pc78uuxji0eMDycnXd9ZJ8Q
 FchSXLUrhd8KWLD/1Mn8RIWYRD67EYPJDTDX15s3N6T0MLmkJOg2jzRv2XrP8rbZfH7j3mk14w8
 AIFbaQIqZWPca4uPUY90VfUdPKHmbHrsC/Nt/6+Res/hczMiWDiHXE1fI/Y5OivZZB69y3JiO4Y
 r5rkaXuaCtWa5Cw++dhPpS7GDs2570aKcezDoKNb70NM1Utsz1yCT95x/PsfnpKhEZQzmKXWfx3
 ZJvb/Bzb1ZeO25xHImSoSlfcPCN8jPMZJRl6ufQPEWMRszWdY+IIwMTXr0t7xadSwf7C+15+TiP
 jnB8HzR0ekCiT5U8v2ILaQR0hV/kYaBePinW3/G9dSBuqMvrZ8DpzdlM3pr/8pXXehdzlQRN9ip
 hz9rG9sfvmaIfRGAFgA==
X-Proofpoint-GUID: odVJQ6S7cjWj576q_jK6sSbwHVIivzKg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

The sa_free_sa_rx_data() function is called after explicitly syncing
DMA buffers to CPU via sa_sync_from_device(). Between the sync and
unmap, the DMA completion callbacks read and modify the buffer contents
to extract results.

Without DMA_ATTR_SKIP_CPU_SYNC, dma_unmap_sgtable() performs a
device-to-CPU cache sync, which invalidates the CPU cache and
overwrites the CPU's modifications with stale device data. This
causes data corruption where processed results are lost.

Add DMA_ATTR_SKIP_CPU_SYNC to keep the buffer in CPU domain after
the explicit sync, preventing the unmap operation from corrupting
the modified data.

Fixes: 00c9211f60db ("crypto: sa2ul - Fix DMA mapping API usage")
Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index cd5cd9182bdb..5e0ef12eb02b 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1059,7 +1059,7 @@ static void sa_free_sa_rx_data(struct sa_rx_data *rxd)
 
 		if (mapped_sg->mapped) {
 			dma_unmap_sgtable(rxd->ddev, &mapped_sg->sgt,
-					  mapped_sg->dir, 0);
+					  mapped_sg->dir, DMA_ATTR_SKIP_CPU_SYNC);
 			kfree(mapped_sg->split_sg);
 		}
 	}

-- 
2.43.0

