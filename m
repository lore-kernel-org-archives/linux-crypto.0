Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471218;
	b=Pj/ECmck9fqRlf11cQ6UgCJwNL35YpUDRHsJ1ferl9/tmLz0GjUdvNhDiTOnYMS3qmsk
	 AH63iIIEcNYfmaEybxa+4GzRA5drJWsFoxWuetrFeqE9EmtUmlS9fMKOQmhCrUGLVok10
	 +srsydMM3Zw5QB/EgwwXibFX7hBSfIkWT8ye7Q1CAGIe3arDLNIcWeRVXW6eQukyC1iQI
	 bUDVNbdqHE0Urd+ve1UuH7ro2CVterDERHXGQMSuoyGnoJOt/otRosbCDeSqCoENT8ivY
	 uYLwm4bnfqCuvAWVM/viI0RvW3vkp7HEoB4PGdVjY6Da0QQQGTmFwsk+l/u2qNnjX3A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471218;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Received:Received:From:To:CC:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Z3h6/V7dtPpMqbupHYL5Bwzhb+ItUeqmXAAKF+1wUJI=;
	b=EfMbKxtGtvn99yP/sbukOiX/DMta0byawpHLJznWzZtYqCDBTpxCsqG92L3KsiMJpPP3
	 wO/mBUrxXKUhvZ2F9qoiBisz6SLQLebJeOxM4VrxVxnBb4vlAypsKO1YomOAJPNMgaFvP
	 yVy4M9vFf1ac6G8bYNCFYhgqiA0mofWLivwV4CEafelhTrkUrzRtzSOM56WVDEoHsl0LK
	 N3wdGk86hBX1K5kOQWq5E6HFnSyRt/QrRTDGfswX2YhcT8a1amCN1+R+6qm9D+dOKBV9O
	 iBcfXqT7QjG8EXivoI11O1hOppgRVxlgeJkrzedrgk/ciU21qV7xVgZKXvV2YOqh27g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=lRaRdluT;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=BfQ8z9ZD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB82606A337;
	Thu, 12 Nov 2026 08:13:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8AB82606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=lRaRdluT;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=BfQ8z9ZD
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC7vi1c2308559;
	Thu, 12 Nov 2026 02:13:33 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=Z3h6/V7dtPpMqbupHYL5Bwzhb+ItUeqmXAAKF+1wU
	JI=; b=lRaRdluTYcvfItf8rYf1Q13GMgW4M3RhOewEDwASIY+aWodk65GwhI7nq
	kTdA7MY56I31yVA2fmPDXGzcqy8spyac+TFFaep2ztw18lxiAziaxm1q5agZzbXi
	8s4MS6MgI8ggPluBdlwbCYW3fyiBXdIOjBojjowwaorYJEN/7Ghfa2bu9APj74yU
	wS8tcciIFVL/k43RHy9Sg0SJs9Ik29ImuuQGjG2k6I+RlPpLnm/h7M69mo8D8tUV
	1X4R3VY8lA7vCzjiChrMhVfoKpeRzKpTDYe9CYMZMwn+EDXNyJJ4YfEkCZEcgkoe
	G6n5hUXXXsBMzv7EMv6E0Qgsybrvw==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013035.outbound.protection.outlook.com [40.93.201.35])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hvvr6vfgj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 02:13:33 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fps3fe9rsFQBWNgfQBW7ReFwAUrFvqsmmG6DkFy9m6MWttGYWXFqpPkw3zNZmdQf0eJ4Ctq5xqBojYqu96G0XW/aeguEO/SRxKZ30K1p9CATFTvaU28yypjv4oz0Qin+GywFBuIhmS1/8HGsnE7TBQl3rPlIloqisOHX9Iqh2qHdDiainsQPF+WiyIHuJhycP8mvfrO8Mq0gcp1XAvNPv6EKGrKom08IeMHDWwrRxOhlxzwtz04mdPdqcUIxYHMbUdDP0dfK0oxxBjh9hGZkQd2KJ8vZ+oK54OCi9V918mGuJm6VcjAtp2w/f1r1PnseXKvKMeCbiub22YXW6rYEUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3h6/V7dtPpMqbupHYL5Bwzhb+ItUeqmXAAKF+1wUJI=;
 b=ltggv+FC7CR4yLYKcgS8Z5/YHfC7D4N8zflbqOeuxLhD+F1II8xo4Oh53Xil/ws++jlvkdx+a5t73nUIySbeVGsMxg2BH1qXFahZ2XF3wzmCHaFidES5w7vbhHeNETat/+hHzBXtn3Vty++Ku0MZ/f8tIETHWCdkpMlzS+EJiRIGqI4U8DG4HIJBL63LRfBepxe4NvX6Xa8dNqKgtLp0eB9QRyN8ujVG0z3gQZOmkUx9GistTNuoUlSGvRDg6QD5HW42MIejgR5v62xY6EBOmaGDAZZUT6ukLhQyQdANL9ZYV6SRWTlSPbetetOICzziBCWxNxVgeYTQeD4QcfETQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3h6/V7dtPpMqbupHYL5Bwzhb+ItUeqmXAAKF+1wUJI=;
 b=BfQ8z9ZD5RXdx6QfFTS5ypBZbF2B3iRyeBg/eNw9e/YAl/DlqXFH9aT3LiC2IXHCEjkXkh4GreIeS5AC1hfXaBUaTLxqr2juuAmODDeGiKJxugmHMpzvY+P/+jwm7RPzU1bdr/1qpAjGo+5/Nsn2Hob44SvQ8G+euoILBNpxO3k=
Received: from CH0PR03CA0329.namprd03.prod.outlook.com (2603:10b6:610:118::19)
 by IA3PR10MB8043.namprd10.prod.outlook.com (2603:10b6:208:511::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 12 Nov
 2026 08:13:30 +0000
Received: from CH2PEPF000166C8.namprd04.prod.outlook.com
 (2603:10b6:610:118:cafe::53) by CH0PR03CA0329.outlook.office365.com
 (2603:10b6:610:118::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Thu, 12
 Nov 2026 08:13:30 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH2PEPF000166C8.mail.protection.outlook.com (10.167.244.230) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:13:28 +0000
Received: from DFLE212.ent.ti.com (10.64.6.70) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:47 -0600
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:47 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 12 Nov 2026 02:12:47 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6AC8CkkK1456108;
	Thu, 12 Nov 2026 02:12:46 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v13 10/15] crypto: ti - Terminate DMA on all error paths in AES to clear descriptors
Date: Thu, 12 Nov 2026 13:41:58 +0530
Message-ID: <20261112081204.1146395-11-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261112081204.1146395-1-t-pratham@ti.com>
References: <20261112081204.1146395-1-t-pratham@ti.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF000166C8:EE_|IA3PR10MB8043:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c5958d8-e795-4349-b2cc-08df4094d54a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|23010399003|1800799024|36860700016|261028144727099003|261026140227099003|56012099006|261022105027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	EgUxwjTe0ACwQRhish8wgDlJ1ESJw9DoMGEBXp1ozSDHjAD/eEJtcViBDA72JnY7xWLflRdhc9ZRpZ0KKXHnQ79gcXvR01FeVe7n2Dr4EPwM04p+qyRvaaY3tSIDe/Ph+RS7lzhUodtUd2Vsx8/Cx1gDcSxT1WP+NaZBkrZxpexFyiMwa7uxj2fqsirqblNWAxf4q5aOQ9lecZywA/L0oI76DI8bSWGvVlIZIrfL9ujbZpm4MVqQIP7OIOv25T0/skNl3LU8SG6mBl39FZRuP1zNNWghHc2i8qkaXnxQlfGQ381Lxe5nqg5FJytGcMhhdzMNfWMPzz2gKbIePSapL9DxqLzi2RYKFJYypZOZ8ZJHx4emTzZ5RMu1aD+qnbuE15+IRLhUZmMkJuR9Efri8TRrma/Da1jjDQTNM5sWo7wekUOh6FtAWOTtsjxp3o6RLKuuHNso0qhNdKywdJ2+2b00dXlST7awpdDOTmwEbNLmwJpH3NTSgN0PeNr44h78RxOIDH/XfvzbOw4VTmDfRvdQ/J7HSel0gsDAQM82Mi0Qn9HkvKrzegRTp/rqRo/xaIYKMNwj6lDpYJpIhNS7tunmLKlTg1b2A3zUf3g3n7M42YlM2ARfs4Ny17HizkT4knNHGHqfYfMNdSuSnGV32XbQig9iaX8p4sTvEqC6GfC2p1RjEfPgQW3ir06+FWL4mDSVxytT+sDSxcBj3L216Q==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(376014)(23010399003)(1800799024)(36860700016)(261028144727099003)(261026140227099003)(56012099006)(261022105027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ubn6S9oC3AU1nS0z4mGQA1tmgNyBZvk0Qvs+cFGxVXU1ik4XMsboEH7YOw5NZ8jbEwhdxZV+BqjSA+kG0WK6OJMb9Zj2mHQO73o+CXRdqNgGDJg47+5jLQZsQamxmxhJ6HKsgx1Mq1ZerslTtwTvSHXm2KQr/A1f1hlht2Fud6/NR3gT2ScUSAa5di1op+ffrNSAfdSrVlS39gDv9C5TM4e2s/7mopmeP/cWtqCfmzccNIKHuyR5OEcKfLOz6yvmT7KSWly3HeFQuTrCZ220j8OdUtDCEgHYI9urbd7tcJ/ADCfw2CA+pR+2D7NJpiX6REPYiEu+wG/f6HtE/akYsG8G2M84qm0LbycJVYaS32iLd3dECtyVHH8r62JhkkemT++YloIeGu86fXQrkDYTmBTR0ovkY5LWZ3oFhA2zbBIBrA/7epzM0mLcg4gBo/v2
X-Exchange-RoutingPolicyChecked:
	j5CO7BOLoRUucZz5Zv2gYIjR2Ied6RkVXfEvpdezR9Q9WYR0Nk54M3vbrlN1hHJUub3ZFeAMXVDG5NkMPtCsJ3gRv6HMheJc6IPDMfK6ZtYT65jB1tGOeWoG+iLAcJRVjlYgon9sY+0caBLrFcbYYAh+s+ZldF/cvoEB/vaXP0UMsOppV1uL8Z+6TlMNpcbfmygRtKNXKXo2tyyiJXHc85MgZdHbptmohB0saHHuYb51svpoShLo0c7lvnmFvPvacLDVGZngafmImIfnN2YWZem0CaZtFF1OxutQdvoZ0kTrbSuzaCuynY4PC/tOKtcnTdSYg/G+9+ACQGoupWX59Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:13:28.6815
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c5958d8-e795-4349-b2cc-08df4094d54a
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166C8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8043
X-Proofpoint-ORIG-GUID: A8yrHpbmAIgsRgOz98xWilZtSB9-SfPv
X-Proofpoint-GUID: A8yrHpbmAIgsRgOz98xWilZtSB9-SfPv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX/Zz+ClORSE3V
 3oFQu5JGhCHZZSloRhT0JNCPZJ0Sx3YUwa34bMJhikYle0mxQlJsH0sI58PnwY7HC0hgcpwHr4q
 Y/WoNy86YTlOx8GkCRgJ6EcOfMMctMP+PNhCmcNjCLfOKjiAzY0ZugII6rorTdKXseP/JJj3bCv
 puOF1zyRToyxyxe39uF2utAT3aOBU1S9UxsWHuDYv7iBHHRLGzmaamuqcDdjvM+3G2QY2Gl07zt
 zmilK8u+VHKh0zggmMenvsvb2r6AIDqz3LYO93PX0yh931qyFSAfRooehFjD+g6jwhRM2fFvn/q
 KrRLEH5tAIHoM4RnjsH9DqFZLbE9iBSSkaVYhCMxNGWW3GXrfmOUJT9u3UJUSMmcy4NB/46FyPa
 VI3l4l/lYmd1lC4m5qRaAGC0PDhSjBzSHS0VnxZ7clNkvJnoDjSXY84kMp68ocI25chGRGnFD9U
 xZmbJNaDjVhe9xj1ycA==
X-Authority-Analysis: v=2.4 cv=MpLHeGae c=1 sm=1 tr=0 ts=6af5752d cx=c_pps
 a=5s0qIa4y+KO52koKvlB/mg==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=T1XiGUNGXxSxoSVzcpQA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX9T4HV/uGCM/Z
 Mg7XdN+3p6ErhvMdnYHaWLfe2igBeOkLvY43CX//TAX24Foblajg7tJ7bvBd/E88kKz9YL232Wj
 XZv7rP+i1E8ppXi31bvr8jjdXnGtNWk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 impostorscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120032

dmaengine_prep_slave_sg() allocates a DMA descriptor which is freed on
either successful dmaengine_submit() or on dmaengine_terminate_sync().

The error paths after descriptor allocation was not clearing them,
leaving the descriptors orphaned and leaking memory in case of failure.
Add terminate calls in dthe_aes_run() to appropriately clean the DMA
descriptors.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 38278ad42f904..ed79b873b463d 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -449,6 +449,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (!desc_out) {
 		dev_err(dev_data->dev, "OUT prep_slave_sg() failed\n");
 		ret = -EINVAL;
+		/* terminate to free the orphaned desc_in descriptor */
+		dmaengine_terminate_sync(dev_data->dma_aes_rx);
 		goto aes_prep_err;
 	}
 
-- 
2.34.1

