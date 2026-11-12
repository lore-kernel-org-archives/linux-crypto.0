Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471247;
	b=iY8Vs6TR0vlH2rdXiltNOi4/ppGMkQQftz3JvWThqT9uubXmqIo7Z3LppQfgyXXXhrKo
	 KX3XzK0O+i40ZYNskLrHd0x0lpg/U8nlguu9vsVKq0G3rjZ5ZJQjEaRks0PLFg0EG38H2
	 /O60sTDRX+nGGz7eiT6+k7y2onqCBTqwqYTqY7sEDRasLBJggRc8pewZsCl/KlWQzyu2I
	 GCOG/HyVF+ahdxP502Yb+9lroIz5AWXysROMRhwQNmk15RN72RU+dobyOFyXveHtRBNaF
	 UFeRBvoWfjIZSXgKPBJaFR0uk3gzsW4uO5uUhhjthTKqYCxgTxsQMoY1AP+S3XjDlwg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471247;
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
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=mOdUUE7n7jgN7EXFwQ2/FB0odBNA35lFrZiArfDlsXk=;
	b=uUmHUKqDiDrYjYIQ4bjwIOntFwV2Ug9k8GzXrkY60o5gYmxxPTnnD/8ah+RK41McUboA
	 8Ri94MNnAt/MLVD7gej5f0PXPdhjBzH17RttlIP2oRudAZnbEFNv+qhB6kXk9ZuwTHYVh
	 TbbZa+Rdk6TRDxi5Hn2RCY7NcYtSDg44rSIZZupfiC4tgD3PWenZjSEbRrlWT/Ruw7nLa
	 4Sl3fn4q4JonDxD9nq/jt0VlgIuakBH2/K7ZShtbaGwMVZNYX3EloN0CEKHd3ORrm1eNV
	 +yG0a74+WExENtb5ZFvVrwX3/vkcjaBfqlQRKD7bGwENCuUyJM2S1jTTFrwIhTtlPDw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=ciGFvcbk;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=idMihhmx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418A2606A894;
	Thu, 12 Nov 2026 08:14:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 418A2606A894
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=ciGFvcbk;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=idMihhmx
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AC5ipi72297454;
	Thu, 12 Nov 2026 02:14:05 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=mOdUUE7n7jgN7EXFwQ2/FB0odBNA35lFrZiArfDls
	Xk=; b=ciGFvcbkTjC0N6fapY1ICqKnWtco7AMweEDoDtYRFSvLdWySM/URN2pP2
	Vy3TDQ07J6ust67xwSeoAW82sVAJaaCAnCfeEE+1yGn7uudzXuQf6SReBZdgfw/D
	iQyUuS9M8ALVM+nrVMBAMPU7gk0SgWL9GUWRzqaMrS+fJ4RF13JarHvNMtaUI2HR
	YMxpe2gO11tgPbFRj+8+rXIfWhU74J1umwMHZpak1/n6+2fKfZfj/YfUabuuk1uO
	gnElgxiXInXhXHgPlwc/o4LRJvat1LyCjtRIsvvgUEYpPu0GcRPaa9uu8Qrd8fOi
	AYRLz/bEwDL0nwrleqQkNSqDPVpLg==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011037.outbound.protection.outlook.com [52.101.62.37])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hw7k48w86-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 02:14:04 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CiZMP1ueh8afcwYRUznUUGGbLmHXduHHf5zsouHxOJn92MgNaR4IyQRLBYOpFbxzahDSzOEPuJQwLL5K8HgX2f7AMsjzoYhimULF1kUgNGaEoW/5M1HPZ3a2UJrEmrmCCjLghZ1H0j7OoaWYaKntxHwuYeW9WrdoGxh/9hUhLPn1wxNz+FLvchh8gUTZ89Wes2JXKzW5q5mIfXfwRVGD4pRkvM9q78sAGoZIOFhLJsa0Puhiae4Pl8F9J763vaX3lcVB0uVa4m76ClW9/HO1tWRLy3JO3X8baT2ThtlhXmv06orqIk2LIP6yzib3KdfbHKC24qdDhHvNUuT2eG8gYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mOdUUE7n7jgN7EXFwQ2/FB0odBNA35lFrZiArfDlsXk=;
 b=rqwrCPBg6D/k0arXJQNzQe0dSIEbUcP2WguIy45n+QXCjDH0SSziLQoGfnIy3sXG+jJ17qJEZrNtr5jycniylHjtJHK/g5rr0WJE4spgS3tQaiTDkmiPoAWVS25Rt2+8qtek+yfU76MPo+1/yy0RYI1Op3y5gESnxtvGmwQrQn+brjlCJTAcfZ81G3pwUUi46/LxyEa9Jbh4cMZmUYi5DGRJf4fuFE8iV5Mr3Pw0nTV4SPTgEQ7QUzQuh63bvNv1rT1IrTlPkodDQj2/mJPVcxEgGk0Y48SVOtiAT/vZH3cDTnxG3M8a+lrhyJZwo4b3oG0JR+4s1ENRKmCjhOFOQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOdUUE7n7jgN7EXFwQ2/FB0odBNA35lFrZiArfDlsXk=;
 b=idMihhmxhCdyPgJhnpM1Tj76ghh9INqtv+5uTely49ua/u4Dl8DoKBIed64gvHvTuKECMARQ4pzvXluIu4mpjK8y8+BQGwYtC4ws4iII6iM46DE64TEzGkckFoKex5RSYB4MXmfFpYDPGkU8QBcUGlOmwufpSrj/pLHDcI/FRIo=
Received: from CYXP220CA0006.NAMP220.PROD.OUTLOOK.COM (2603:10b6:930:ee::10)
 by BLAPR10MB5025.namprd10.prod.outlook.com (2603:10b6:208:30d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Thu, 12 Nov
 2026 08:13:25 +0000
Received: from SN1PEPF000397AF.namprd05.prod.outlook.com
 (2603:10b6:930:ee:cafe::4c) by CYXP220CA0006.outlook.office365.com
 (2603:10b6:930:ee::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 12
 Nov 2026 08:13:25 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 SN1PEPF000397AF.mail.protection.outlook.com (10.167.248.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:13:24 +0000
Received: from DFLE212.ent.ti.com (10.64.6.70) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:50 -0600
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:50 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 12 Nov 2026 02:12:50 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6AC8CmwL472618;
	Thu, 12 Nov 2026 02:12:49 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v13 11/15] crypto: ti - Terminate DMA on all error paths in AEAD to clear descriptors
Date: Thu, 12 Nov 2026 13:41:59 +0530
Message-ID: <20261112081204.1146395-12-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AF:EE_|BLAPR10MB5025:EE_
X-MS-Office365-Filtering-Correlation-Id: 38e304b3-24e8-4dbd-e59a-08df4094d280
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|23010399003|82310400026|261026140227099003|10067099003|56012099006|261022105027099003|261021121427099003|261021123027099003|261028144727099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	TJhCy3Ddrm/p7OOaiPlk1hp83k7zTwot7yiZdbqi10I1yIbZRK2zA8uTtX8qRkjv9+ZOpOXSfU6NGbROukJf2SuB3VHPhr7QWJ/LDomnhJLmYBqUOCahZ3MfcqfuTtnr0Rcs7mzH1dJnf3fgrHEFVMcNhicmRFpwa0qpbtKNKVQPnsekIThRYyNHamiEJ0pJURYfSSSo1uohx+Vlz7xq7RHwZNVjG29LevkHE8pYtxKB8fKE/u8Qm0gAWmhDsKe2cko6c5rBxZAAPitVVif0wrq9OvTAtDz6NrnrwdFmEY7HM/D/KUvl//eDhkspAuGFRaHOc/1A5ZkE3FO3pamIIIV5EnZUvAe+bw1IgeePoxerfBm1i41O4Fm5RQG45Vtw3qDRm3kmpQf9mX7MYtES1N1KD4Ql3iZzne8z9w/0tVJyQNwMute4r9PXlMeMgL12hebw9BWyA42BPrhSajEmI1kMypaHzMf+SLCkZ8tPa0yI/GWksigS42fHT+Co1Rp75z7ukyIOBbZTRltZ9JBgf9X2zhVe46L8xsibsW8+4+1OD3lczyhtV17fnkAUTqL7c+JIjy40VRkM6+KZgOmyqtNOo/bPZ/M8Nw73X6mw/kGubXy/6BHqpMxWpjTZHyP2HpfeJtZmZIOaK1YI3WSpei29U/CLPGQpbfk5aZTVxIwOTJLSb07N+50044fZEOy4Xut9QlAxMJ6JPj3uQKPgIA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(23010399003)(82310400026)(261026140227099003)(10067099003)(56012099006)(261022105027099003)(261021121427099003)(261021123027099003)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xZt454k0gYMxJIHVIlPVfxr2jVk1B4dEsif4Xr8n31F69hD88ujacBJVtWFTjv5E2m2bpbeZJ5eM8wW3xixLW8EBtDA4/p4y9W2Jt+UuoEVxTNrguu8+1q3PUS2AYWoTGKIzpKisJksNYZRiMh/mWJejI4vSaVkqgBGm7AHs3OxWBDXodKCXSuaWah82bW5MAZ91GW7tK/DbKcTaNxVQ2D2mCoWyGZZ7vexxoPYAn/CkAqhkdtSJuPbXZc+P92MfFjQG/S+RywcGW1R+O1RgE5Fq0jrzvcMQ6PhInQmyhNoYoC6FnvqoIAr3VkTkd7MXrMK/HZP/9aY+R3qJ9Bb7mNJdN8fQh7NAioHgwFstXZQei8grcVe//ShvM/0X49MV3bXLpBKZ7U2A26ccr2XvPpdouY2A7HhBg0SdT9xOzFVBTB9TiZRca9fPyuOgG4mA
X-Exchange-RoutingPolicyChecked:
	oQPvkt9CoOaZ4dd4fJThnAc/wiTC4cOYlp7ewY+o1S6XYyVMBdSl8XivWdmFOZsiigZlgdBPZWQVyikY2zhmc5NdVbTnRVyx0IT57BNZLmhMf3qi+EkiYaaHuc4f+TvlRThmjMYn8zS6XcKzeiqRBW79hsdp+XT6Ms4hNJW7UznUSsFriiZkz5Ts6sAf+n276rXhwQ+WlnvQ2fV9hp2uMnhQGeWlUxC+ffJS0sKqp+KuF3ysg2k+CqtDK6+rKVGbOogk8gs1vurHss76+Ke+L01O+hNoJ86mL2fUF6vjb00PlR4NJ1IwsiY3E7XKxze1VmSCkBHldzhHoDCzadFk3A==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:13:24.0138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38e304b3-24e8-4dbd-e59a-08df4094d280
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5025
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX2QWHPk8v5Nvh
 kkllcpLJj7cgSQYYCrhe60PpC8JnXRRAMPa4EU4DkdeiR9TxfXsyiJyL6Z/YGTiivvVGp6S6+gC
 xg/R1SokuF4q0+oG73v3DNQTVSPTgVw=
X-Authority-Analysis: v=2.4 cv=fNCsTpae c=1 sm=1 tr=0 ts=6af5754c cx=c_pps
 a=S2IqtmjrQAXuShkhhqPLog==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=noPYQ3j_lezN9luSq70A:9
X-Proofpoint-GUID: XIv0gArgmKN0fRqL7_Z9djjSnIo38tjV
X-Proofpoint-ORIG-GUID: XIv0gArgmKN0fRqL7_Z9djjSnIo38tjV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfXwjT3By7stDnj
 /nvzhYjph3KQBRT96I44P/V7DFrLtfARQAAjjM/VU2whdcLhoF1UPPfH1axHYFmx1bInMO1XjAK
 Hq2SZO3IF3VkiRqqz8OKUqImJRmU/gL6JivSyM/H2NlkBt8cFnjwuQSZA4bWwrgoikPXgzDmeKn
 X8i7EI2a01F3tOPwL+gChXYyuwTMV41QAgmUoM+FRwDFCYVka38/yzqYsCaiMh20fxXE6ia9fIz
 4qSq/wmAdZ8TCZlKRNgt6BN/07136CoSohm9SbtnlGhvNmG1WR247dFb553s7PFKEC9nsKYYynk
 e461iyGf0/l2uCjB1ij5F1pDUsC9lJaKP3Vq1m6UElvDYzj+XL85OGFIhdK/v+23oJWF1htBRNn
 izq6dTE4EW9a2LSJbf7TU71ZkTKlukOXFn5kgw/zD5Iqz98VCJMqrzy8ESVKKaT3IL/iiiP4HXA
 2K1WinofRLjX4UGT6YA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120032

dmaengine_prep_slave_sg() allocates a DMA descriptor which is freed on
either successful dmaengine_submit() or on dmaengine_terminate_sync().

The error paths after descriptor allocation was not clearing them,
leaving the descriptors orphaned and leaking memory in case of failure.
Add terminate calls in dthe_aead_run() to appropriately clean the DMA
descriptors.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index ed79b873b463d..f1f12126382aa 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -914,6 +914,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 
 	struct device *tx_dev, *rx_dev;
 	struct dma_async_tx_descriptor *desc_in, *desc_out, *desc_aad_out;
+	bool cleanup_tx_chan = false;
 
 	int ret;
 	int err;
@@ -1014,13 +1015,15 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		src_nents = sg_nents_for_len(src, cryptlen);
 		if (src_nents < 0) {
 			ret = src_nents;
-			goto aead_dma_prep_aad_err;
+			cleanup_tx_chan = (assoclen != 0);
+			goto aead_dma_map_src_err;
 		}
 		src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
 		if (src_mapped_nents == 0) {
 			dev_err(dev_data->dev, "Failed to map ciphertext src for TX\n");
 			ret = -EINVAL;
-			goto aead_dma_prep_aad_err;
+			cleanup_tx_chan = (assoclen != 0);
+			goto aead_dma_map_src_err;
 		}
 
 		/* Prepare DMA descriptors for ciphertext TX */
@@ -1030,6 +1033,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		if (!desc_out) {
 			dev_err(dev_data->dev, "Ciphertext TX prep_slave_sg() failed\n");
 			ret = -EINVAL;
+			cleanup_tx_chan = (assoclen != 0);
 			goto aead_dma_prep_src_err;
 		}
 
@@ -1038,12 +1042,14 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 			dst_nents = sg_nents_for_len(dst, cryptlen);
 			if (dst_nents < 0) {
 				ret = dst_nents;
+				cleanup_tx_chan = true;
 				goto aead_dma_prep_src_err;
 			}
 			dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
 			if (dst_mapped_nents == 0) {
 				dev_err(dev_data->dev, "Failed to map ciphertext dst for RX\n");
 				ret = -EINVAL;
+				cleanup_tx_chan = true;
 				goto aead_dma_prep_src_err;
 			}
 		} else {
@@ -1058,6 +1064,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		if (!desc_in) {
 			dev_err(dev_data->dev, "Ciphertext RX prep_slave_sg() failed\n");
 			ret = -EINVAL;
+			cleanup_tx_chan = true;
 			goto aead_dma_prep_dst_err;
 		}
 
@@ -1147,6 +1154,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 aead_dma_prep_src_err:
 	if (cryptlen != 0)
 		dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+aead_dma_map_src_err:
+	/* Free any descriptor prepared on dma_aes_tx but never submitted */
+	if (cleanup_tx_chan)
+		dmaengine_terminate_sync(dev_data->dma_aes_tx);
 aead_dma_prep_aad_err:
 	if (assoclen != 0)
 		dma_unmap_sg(tx_dev, aad_sg, aad_nents, aad_dir);
-- 
2.34.1

