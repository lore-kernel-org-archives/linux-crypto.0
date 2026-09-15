Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3AF4A1DEF;
	Tue, 15 Sep 2026 09:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466269; cv=fail; b=pjzE01u9ilSMBZx1UeCAexv9JIvEoWwKldvdASS54rxbtPNAEhWYqhUuCAbwQD0m58vBTy9OXvFTmynnGGDMeeXRzNjH5/Pw3UHf/P8xIuufZmmowtmQf2zccS4376o9GzMdstbtXG88QWnjpp+X19SQmJLfx9qQA1lLQc+0aSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466269; c=relaxed/simple;
	bh=87FoaMFEzPbnoTJqFF5CtXfl5HeHsDnSXNyOG8JHc70=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=IQhhodrQThIkQrUE9Iih2VoRukUrpuF1Lo0GCYyoTjzoEEsctIQMRUpwqcKZMiofNGOtcw5LQhssyxUEP/ekToav7/arFafjVvlJO+QfREqXR/zrp7RjI5ua++StZtdc1N99CkGOsZOsH0GTohzo5nppdByHGWiVgvUf5QUX+uw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=INT+u97x; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=tczQAzLK; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="INT+u97x";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="tczQAzLK"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68F9eigU1480544;
	Tue, 15 Sep 2026 04:57:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=cgs+xVdzOQlRGuPry19s5qAU6JrpcMNK/IdYlL5Z7
	Aw=; b=INT+u97xFxWTPocxfBT4AZXhdTohSriry7ta4A0MDpPZ7/lABqBL2Y5Fv
	9EKm9RJiFcEDMCCuhdMpWSModohq9tEl6k28CX664z2GOacVSLn4aKYsB5wtsprc
	DJGFOcPXtODd0DJWqdNtCT23/CbtWcotqaJpsPMwlz/oF+QigJWxbwyGNyBSBX3S
	LBrMaSUOKNOwvvYfARnUDRtsPNsW88xLXdSdSFiPLdTVqrb4oK60gZSi9/MFYAoa
	pW+j/GDc7kTSEI8FtVmzMooVKtd+pM9Q/Aa09CzHcQL+CIUjaWWa5LJ1rF2FcXbs
	yHYfFL+UDhqL4iW7UtAaKlfl5pEWg==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010005.outbound.protection.outlook.com [52.101.193.5])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gpvpa2j74-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:57:43 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IkinJhbdaMt7X/688iNVSIz36QyikkPEAUq7MVe4Rnf4FWF7cCoh0RwsX97w1/VqKFcaxOP0vvF+vPkpr9PeNxNpLlYeCiFcZ+XZFJjad/j6NUViHd2Pf9Cdyk3M8RHlw4Ai++4fFstSRrbaaKsUG0UldTDa+zCYPsavorVE/Xn5OyR2iAiaddEuh6dXj1JCH2V+MAsjUTscwaua5AsFCrnVCKDa6QgPNi8rpFTe1lIBBBwNbSMIZNLNnGxAcFfpUHORwZZHcrLEMU98jvPM7L4e3TDhQNV7HvsN1QiFm2Mpth93ZFesKZ2DEFJbeGPKlpcM5el7uz19+09hdfnv0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cgs+xVdzOQlRGuPry19s5qAU6JrpcMNK/IdYlL5Z7Aw=;
 b=EnC5PmLiF3ZSlVuoe99w8kcD0+2BrVkCyu8xULkvW1ac7h+VJR5KXzMf2YHk4u2nfH6/7hvA3SSjVXvVFmCq7K/oyiZLePNLWlqJwc3GJVl/R9k3mexugBI1XDOkEPJ/LNzc8mEiGKNt/hOwZSPNwEvUQD4ED+D3Gx9khGiJgR7nN7m0TbnB5lpnLeebWkqdq+61XqQSlf6XaRS5TV6YluwTbzH5u5iMxdzxYNQalIIKXSY/CuQpdO8XUt3OivXeMZRXoeIv380+XKC1bJC+WySv155FtWZR2b9tDxuqyiDReE/RupbsDQf+hAKRz/p1diLZ1UJeT8sMc6qkBCBj+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgs+xVdzOQlRGuPry19s5qAU6JrpcMNK/IdYlL5Z7Aw=;
 b=tczQAzLKiDYdNHYvB3Ycc336/vbxAMnSsO12XmGGgoKfZdhA2JqLwtq8IIxWktxs0RGtkod3qz1bVNSE68TE/7661LpsZtz74DASjMxiILKXxMNG/pVQ68zo+RMJSowTKRtzHQk3OxxrKo0eaLuN/OoPIL+AW/uleRHhIlfgOoM=
Received: from SJ0PR05CA0160.namprd05.prod.outlook.com (2603:10b6:a03:339::15)
 by SJ5PPF25BED9404.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::794) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 09:57:41 +0000
Received: from MWH0EPF000C6189.namprd02.prod.outlook.com
 (2603:10b6:a03:339:cafe::82) by SJ0PR05CA0160.outlook.office365.com
 (2603:10b6:a03:339::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.8 via Frontend Transport; Tue, 15
 Sep 2026 09:57:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 MWH0EPF000C6189.mail.protection.outlook.com (10.167.249.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:57:39 +0000
Received: from DFLE200.ent.ti.com (10.64.6.58) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:50 -0500
Received: from DFLE203.ent.ti.com (10.64.6.61) by DFLE200.ent.ti.com
 (10.64.6.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:50 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:50 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB8J3000901;
	Tue, 15 Sep 2026 04:56:47 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:35 +0530
Subject: [PATCH 29/30] crypto: sa2ul - report SA engine hardware revision
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-29-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=2394;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=87FoaMFEzPbnoTJqFF5CtXfl5HeHsDnSXNyOG8JHc70=;
 b=IywzhRvKceqAo1nEMBb5yvoSH5jMEIzT+DSnSbMa7FQMD+HBM9m4dClU4sFzze3ZvLSY/a2bP
 xbDWyFJjljwDumZ5xKvdvjlniR78cOfe/6piPjR/iknDVZiFXPaoLB4
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6189:EE_|SJ5PPF25BED9404:EE_
X-MS-Office365-Filtering-Correlation-Id: 76e61ed7-6210-42ab-eab0-08df130fc72d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|23010399003|6133799003|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	vVqG6awREs5KMcU4HX5Pc69WRlxLBj2ogd3dL8pA6+SMJsazXSoO6kotGw0/riFeS9o8A8MsxjBQ7HdqUrhAwna/v+M7UyM2g02BskOgpjGdTmISSs3AGbY2co+88BVOwsM9rtRzlUm/VEzfAu5W2mg+GYN/Idpw3ymlJYHc79wFcAmBBW7Hf5sjQvB3NXIB13lfCeIiJYa7wbZpq+aXc1mQ7g9lqTWpJ84+mhD3duhDh8OpNCuXywBlfUY0QOpLMtJoTBV0G4Diu/IRT5e+PH5GbdAKwuKc2YcXPMC4NnZN6z926WitjcOgX5qwzzUwFtRchzgzFEDdKM8Z3DLTW/eUlu9yrMXpQuSpHa7w4U3DGX0DBC+4U65pwPS2BM+h+xN0VTZwFFSnF75oqqzJwgfzj5bDbN4dO1NjkOWPMKkqz0qEA15V2ZDF8GpJ00HgSLcmFpJwqdaeirKI8GYHqGlqLvkHxxNTxvI8se8gCn+0e7p4+MHJxWsszFexj+3nMySiXYVCU0ZhWPL7FdJauUtEBj5cSbAfQFayIMOULS+psJ/Py89sh6xRno44sJeHZQfyCxAijAQd6XMURRz9g3Ib2H3YCtvjsq6+WA6eoLxM1BazUvExw6qqRz0pO28Z+s7Se9/MEA4qzguBcCcU5iwUHtv+yyPrMQsX7HGHlD8KR249jJKGSySAP1JSpsVmrJzsdsoPBE7D8E57WcjMYg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(23010399003)(6133799003)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1SPLlzJ3UtrpnOM0RjarM2eUnkpZZLMsdrLcduJue6bTzG1u3+WDfyrQJLfcd7c89ESCUZ9VcxLT2oJSPg96rvmwsDd+OZLvfcOweMc31ZBnVNkUEqGFouEImxpdLe75BLSquvyzWen7mCo3p2i0I0gShckWRp+lO7xnFEp0ECLK0gV99S+946KWmAJgvNzA6z5pOAIb5F2OPMe5wjJ7n8pzoxEZFKsyxcCY9opCpGy2xk4HGrifKNGmlnjKOarQmcWxgJ7hf18GwIPnSikfm3d6xDN8qwPMpWJ6S1JP0KUQuyVVbdog5aV6DnZBlf6mdiJKPKeHskLeNhknAbAnOBtFLLkqIyrwy5VFSUt6n186w5A11YgUOHUxL6no/63EudpvCUM/acvmYzoroRRg6Fc+j8O1HY5algpkqkYPwsUv87c1U0Aju3IbLXoeN7qd
X-Exchange-RoutingPolicyChecked:
	X2GPMAMcDJ29bMzTABmjCOISNTilwW79qmSPixiPeyP6nNopYQqKM2NnYhrXnha09+M2sTkQvc87Tdiz3yNOAI7+EopgwXNZr6hWVl4CXhGKanhdQbNR9cF9Pnyrfda0PodvxAhsmDldDzcu8V7O9pXG4xuU7UATJ5vHwRqJpq9kVbm4P/FxAUxzGRK0YWrIfgHg0db6R+b2FgyvayC01DLeOakGCO34yZw+jwhbeRW2D9yKpgYezQLnXP4eDM6BbtSxV6NfIVAzpV3NR3H4S81ZPmf58oKJJ5xRQ5/9djRRY9yKF+IHEA7m21PbeMDwclIFN4oc7MTMYE6FcPNsBQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:57:39.5691
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e61ed7-6210-42ab-eab0-08df130fc72d
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6189.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF25BED9404
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfXzYvjxfxnMsrH
 +fEApZABMfNulhbLGezTROyjzEfpIkyBjuBRDaQwG0g9iSzo/AENbLpBbpo9y1wDe+W9v1/ZlEZ
 LFc2P+IZPe+wgw3F7PZ1XA11BUzQKYVvA0IePDpFXqyInlpsqCCGWJim1NxcP8p8pYy8owBetK6
 TW1lYkU2A4hn9T59yCNSuK5yfgaTWeBJtp66TLGhHtFyJD4HfbH1VbesWtYc1wh7pwl7tNkZoRz
 zwyV3b0pP9D74gzA+CXhs3QM7tZcXqNYa/Jwmjyp23tD3jZpxUjK/NuriLXEtwK9K0n2mE5Z1kK
 UMfdvZ53kJNCK3fcXqX3EL+UwddVhK3GsB/kW1Yp+35ilX07efnyYlYd+i2SfUzBU7UDqntZ9j8
 aYn4dOGblwg0DM++CCsja+dB9KdxcKJHxA1Rv5iJzhR3Mef+0z9GgaeBhrc2OqGBp55R1uMNt1d
 grcGCkTMSR3AsJDCoow==
X-Proofpoint-ORIG-GUID: GW2_xo8qMw-wFe1GUM6tke3eBkhaEzZA
X-Authority-Analysis: v=2.4 cv=U7cHnuru c=1 sm=1 tr=0 ts=6aa91698 cx=c_pps
 a=v0elvT+g34jhj2ItdigShQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=Oohk0lFMm99HtjJkPXAA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: GW2_xo8qMw-wFe1GUM6tke3eBkhaEzZA
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX1PfaIOczXzU5
 BbQ0bRO2b+JSOcODNxZmSnN7wy+9hyPmHmuF2Ijc9LM1YtyhvsHAk66i0OVakzD64G/AHNHdgwT
 mtDLGYMTw9lgUsaIMY9busQ50N+Gflk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

The SA2UL/SA3UL crypto engine exposes a REVISION register at offset
0x0 that encodes the major/minor hardware version (major == 2 for
SA2_UL, major == 3 minor == 0 for SA3_UL, major == 3 minor == 1 for
SA3_UL_CM). This version information is needed to detect the AES-CM
(SA3UL_CM) variant so the driver can enable the extra TRNG-priming
and AES key-expansion workarounds it requires.

Add the SA_REVISION register offset and its major/minor field masks,
read the register during probe, and log the decoded version via
dev_info() for diagnostics.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
Assisted-by: Sisyphus:claude-sonnet-5
---
 drivers/crypto/sa2ul.c | 8 +++++++-
 drivers/crypto/sa2ul.h | 9 +++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index d92ba1f581c0..9c4748110eef 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2465,7 +2465,8 @@ static int sa_ul_probe(struct platform_device *pdev)
 	struct device_node *node = dev->of_node;
 	static void __iomem *saul_base;
 	struct sa_crypto_data *dev_data;
-	u32 status, val;
+	u32 status, val, rev;
+	unsigned int major, minor;
 	int ret;
 
 	dev_data = devm_kzalloc(dev, sizeof(*dev_data), GFP_KERNEL);
@@ -2494,6 +2495,11 @@ static int sa_ul_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	rev = readl_relaxed(saul_base + SA_REVISION);
+	major = FIELD_GET(SA_REVISION_MAJOR_MASK, rev);
+	minor = FIELD_GET(SA_REVISION_MINOR_MASK, rev);
+	dev_info(dev, "SAxUL_VERSION: %u.%u\n", major, minor);
+
 	ret = sa_init_mem(dev_data);
 	if (ret)
 		goto disable_pm;
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 53d2bfd895cf..c5e73ed14f44 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -16,9 +16,18 @@
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
 
+#define SA_REVISION			0x0000
 #define SA_ENGINE_STATUS		0x0008
 #define SA_ENGINE_ENABLE_CONTROL	0x1000
 
+/*
+ * SA_REVISION register fields (see REVISION Register, offset 0x0)
+ * major == 2: SA2_UL, major == 3: SA3_UL (minor 0 == SA3_UL, minor 1 ==
+ * SA3_UL_CM aka SA3_UL v3.1)
+ */
+#define SA_REVISION_MAJOR_MASK		GENMASK(10, 8)
+#define SA_REVISION_MINOR_MASK		GENMASK(5, 0)
+
 struct sa_tfm_ctx;
 /*
  * SA_ENGINE_ENABLE_CONTROL register bits

-- 
2.43.0

