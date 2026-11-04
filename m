Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771178;
	b=5DFANo5Q5irBovqYsSg53s1Pe9Fcp2a6C0cpvCUvQHKs4deel1t7ZVnREBkrYRXXhE+U
	 cpJC9qPPxbI2Q6oU1qBnJ6sOLpn0JZkIjrMYPiJ924yCNzBUrrVFRD2Hp/hC4N6kc530P
	 bPp8Su50rO20/F6xjtLlQuHdRpojh75+DfOIcYQJUWzUUeI7iPxh9ThZ3TjUStcYoGTEm
	 D0o/YC91NjAjMZtgt7RFxU3oHGffDxZFhzLoZ/OYm+T+sRf5DUhtw/cWP7hOu8R2LLbk3
	 UzdQfsxNkBwiSj+NRje3qrjPpQpAOFjrI5G1ZZ+rVbhd+uSleXLegzeR56m3L6B28RQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771178;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID:
	 References:In-Reply-To:To:CC:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=RrT3hKzuEizkAHi7viYcfYG+o/L1fjQH2A9LzWna3sg=;
	b=QZsMb9fNSfuTNEl83uzuBlablTWnceJLh7WOJiDLQtj5QCV/wkVoz8UH8HCyff7rj+Wg
	 kU3JWjqsdWr6fBPneJJTQOKmHiRd+0etxTjA9Mq4fJJWNSIwfM7gRd7BGRAMMn6Xcek3i
	 bcQDzb/IJ17aWANUSu2+J0ScJrBUIdGOk0V8Xgpg2awm+FQ2q8wjX24IoM8ALpFElMoVS
	 d1k5joNq2WKkhBrvnQDnvB5zFbWUaQtu4W34QOfH1bOWcMvRNqENUi3ZnZMZBcVjAqjlW
	 z4wkPiDWBF5LE1JDnkr+4lbbx5hZRFrV4S231V/Wu6U0opGznzeEFc/Bz+QQy1FIaIg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b="kZcB/mNv";
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=S3dY0fvM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A9F606A335;
	Wed,  4 Nov 2026 05:46:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9A9F606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=kZcB/mNv;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=S3dY0fvM
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A40S4J3771704;
	Tue, 3 Nov 2026 23:46:15 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=RrT3hKzuEizkAHi7viYcfYG+o/L1fjQH2A9LzWna3
	sg=; b=kZcB/mNv0dIun7HciD2ZcnUDYX1TtQeoWcVPVuuvOF4sI8OZIMxfSPk4k
	2L2aZvbV+wFNg5t9P4dVi4plloBTnxyMu8hXbtgS0Rho6X+l9Vr/iyYBluA3P2JT
	zZW6pn2QSOUTaHAXAC89ulFrZti8Wnh3mrYGx8PIeXTu38OToDyjJ0CIZDHsguiD
	/orwzyF7akw8WCxgORuZdJG7ygCUZeij7CL3rpwxw59yy4jbQlUvYTavn5GpWgEs
	wIqp0B3hYhar9e9aWmdGqupW49CGNGMAeEKvs68kHN6LatJxzAT8AYT5r37W7ZIu
	pA18F3CQCNzZH72cERllfZ/G6Ui9g==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012042.outbound.protection.outlook.com [52.101.53.42])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hqqra25pv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:46:14 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y1BtHWET4MPSWN0FncnvmWnv9ScXIVvzc0tR8C6fem56oJbO589N68pS/yOftEx4WWJACm6oHllgomz5n889OTVkNkBphWxerCffzoW4w9jToSvXd4Fir6qmoE4Z42tZQqnKO7I//N4vU2Fb0RmjCjbUOB6nMoUUiyDxS873TqiqmuRMImCbJFQalJmlyCotF3F3t63bJe1tDYR/FiFNn2oL3m+7QXAbDgxttjC1opicuS4/HfWScrRdRxpfQ/qDX8CtwkPs35Vu7laFPK2w6tpkh7UFe1gBl02k5G82MUeV/alShFlzLOAdY7xT42sIkyhluaza2A/jhZq3JAtrxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RrT3hKzuEizkAHi7viYcfYG+o/L1fjQH2A9LzWna3sg=;
 b=Ge2qErW5T4/NadHZwWjNHdTjx7kaEr3wGUiFJPWXLU3ibwZxBiekNjzBa8yPDo/OrGe17Odcp9UU5s/+fE3SclM1xPGDsIaPIkt0biI0o888wlccKURP2HJnUprFxYRSm9fMqvR81Xlzl16MXO9uZSb0lYmq1VK5GxnklCerfOl70+o6Me/6SZzx/KYDH8NWwHdS84TJ47hWss8NPD2/urP8yha3eh5eozIr5W8+L7JiZ8AMgnWOmLP/KeLAYY4EZF5uLtjD8EYcxg9WSkFYqZ+CYsy2mExh6fnICPSSAaAn3ib2c0DlX9m4oUy7qxXFr5n3Y6CMh8Wrofwnsyd++A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RrT3hKzuEizkAHi7viYcfYG+o/L1fjQH2A9LzWna3sg=;
 b=S3dY0fvMJlxSTbwnbTEjl/GJ2yH7qL4NSsFNNycCYHNFJSQQI0yA45miH4Ulmnb6NuHxqM1zlqDyTc+gmmLYsmOdXW+qx9t4nmuSPpi0ZLJhVBGHOdt3CmU2wSwBB6qPAUqkivpUDBdwZCDsCNAjgCvB15juHoEVnssRF2SEANk=
Received: from BN1PR12CA0013.namprd12.prod.outlook.com (2603:10b6:408:e1::18)
 by PH0PR10MB5625.namprd10.prod.outlook.com (2603:10b6:510:f8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 05:46:11 +0000
Received: from BN2PEPF000044AC.namprd04.prod.outlook.com
 (2603:10b6:408:e1:cafe::1e) by BN1PR12CA0013.outlook.office365.com
 (2603:10b6:408:e1::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:46:10 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN2PEPF000044AC.mail.protection.outlook.com (10.167.243.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:46:10 +0000
Received: from DFLE202.ent.ti.com (10.64.6.60) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:27 -0600
Received: from DFLE210.ent.ti.com (10.64.6.68) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:27 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:26 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJ01521920;
	Tue, 3 Nov 2026 23:45:23 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:27 +0530
Subject: [PATCH v2 17/30] crypto: sa2ul - consolidate encryption offset
 definitions
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-17-15ab90b3f9c2@ti.com>
References: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
In-Reply-To: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=7349;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=mK3vmjyKc2C8sRVc02Ji6TDEV4IDSSad4jzkDbf+W/U=;
 b=PAeJvD1z6csuTsgfN97+GcV+tOI8nSSmoB0ftpFmjopRUys1WcR9th98HBp8ZU6Ewst/orcTM
 yQh3Ju/HWaoB8BPRkjOu4VUxYouf9c1LaY2Atta6l5aQ2LVgUtLX9/K
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AC:EE_|PH0PR10MB5625:EE_
X-MS-Office365-Filtering-Correlation-Id: efac327e-78b9-44bd-7d98-08df3a36edde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|1800799024|376014|10067099003|18092099006|18002099003|22082099003|3023799007|56012099006|261022113327099003|261021121427099003|261022075727099003|261021135927099003|261022115727099003|261021133027099003|261022105027099003|261021130227099003|261102123227099003|261026130827099003|261026135527099003|261026140227099003|261028144727099003|261026121527099003|261021123027099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	pmGlqQya9J5kGGkxibD5OK+8yXfH6SxZ86kTW700KkUfeoB6PFBIS6HyhF1jqrfyLnP+aMrezIK3pXbehAV3Ly5U3WpyFYkwo2zb3mm6/ks+7livK1gPldTzdtqwParFNMBZyG8lvnAKAFjOTCdcqwqgFWB1rynrAYrYPLtMgyabxR24ycIVMQiQdLGoxvNa+Lj6ZAM/bbedNGf5oQSC6sKMVuM7rbb+1LGzX+pxfjBhdrJpEI1i7ttQ1Pm4L2C30qjR3/NjSrZI+q763Qs2JE4/a1a3mRQmzeWL/Zluj58TI6xeRuzNbKiSmaV1/X4fmaPi7Q3a+7Qcx64EjdtQfyj6C8BBH9x9xBDh4c6WNZeZ0OzOU0vZFyLcA9zIKO/HQ0Ixcgn7aJO0htyTMbW8ZrOGACB0rZuyoPjQAKao3XiHlOaRPH0m9JHEOOSIqrAZ0cxpfHszThT/cyk1X/CLSB3dqp3AXjTrBic0jvSYMlb2jGj6Ie+Ox3E8baQWweXQvsAQoZl6qszHUAhPwyi5GfnZl6OzkBz5QiUdHOF7QW0c6DnqX4NwJDI2sAx8Y3T9HohRZAN3o3EhcGbrFjlZ7LqHBOOUhKtOj2pxT2aWVnwku2u1fsdjr4ZkaKySPljdbV+mX2ySes6AhS4KUT/pubEmUUyf+77IyxzsAFRTPs9gfkNRESM30jh9z+jdSY5BlN355RHSLPLguU4HMW9dVA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(1800799024)(376014)(10067099003)(18092099006)(18002099003)(22082099003)(3023799007)(56012099006)(261022113327099003)(261021121427099003)(261022075727099003)(261021135927099003)(261022115727099003)(261021133027099003)(261022105027099003)(261021130227099003)(261102123227099003)(261026130827099003)(261026135527099003)(261026140227099003)(261028144727099003)(261026121527099003)(261021123027099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SSlK8x7OkWHW0T7cjaJjbRNOsvrcwY01O5IbiR0C9Qht1e46KDfuhs6kNyyTP0W/0zY5HVulLnGYgefYUdBMYheKVr6ujWrynGWfhw0BzozwD/GTDIVb1G//C1iH2gEVBRAdyO8fFltaiMp/6N1JjO2RrjBzGDbD965KNtWxCGMmjt2fjAQWRMWvZgKM/f9FkCsUNAEWUI0FKWyKhMkpfTwm/srKmpyYZiFHJYqiOdHdDLMns8qHhcWJSntq/61XiOWCf1SXRxRlDbSRVG3JrrevGrwsK73L0jZ9lA7dBkR/pUFTc6/ABTgw99d9zTLB614QG2zmfdyzb4bkrnNo1pwNc4zO9omlOEW/eKbgehqhZEpg5C3b+x4ZdL2fLUvXAZFzATS5OeMxTgncxkKvd0trK4atx/Vquk/3uPL54ox2lXgdltAa1avB3m7kse+a
X-Exchange-RoutingPolicyChecked:
	xmoaVoTp1DkN2Mz3zRYkvRxMjpyXrPgnI65nE7TKSaYb5Jwobu/6AImkrWYYTqKPZ+F5wWmsc5EfNDn0UwwokQC9tGcp8NgqRydQYAPwqrmtDHBAyGV+mieOUrol6NpGEdl36U6pTRAKdDRfqxyftLpAJbZC0sblKZDrYbaUMvg54LFV9WoGWI4VSbhtn67TB4rkzLD1J8u4dNnmFplUD/KTqleCV+sjBScvSUHly37zGaqrk1j2DhKvq2r6df2DenC1gWTJZmpLaagJ9GUeUXGaAbZ7uclYgGPrBpqioH0puuKeRig/aLAxs2UMFBb7gimHtm0if+Dqm7Jvf5PAYw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:46:10.2197
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efac327e-78b9-44bd-7d98-08df3a36edde
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5625
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX2hSRmMKrpALd
 EAPIDYwFt6uU27xa2bxL7YmdhXbQ4Sm2BcdspKesf03sWg7fJE7Zt7k7G6v5Vl5pr9ks8amwYAf
 zdfeoWKyCHp9X+WwhbqoOH6H+3drh8s=
X-Authority-Analysis: v=2.4 cv=F9TC5ahN c=1 sm=1 tr=0 ts=6aeac6a6 cx=c_pps
 a=FJ4pSz/mJ8rARZfoadKCzg==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=3sdfgBQbHt-tfeuNKwgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXzMltl+d0FaiN
 WBdXmcabPIy1TSoslgoOrGU+yjOdCQj4s66we4V8pu0B6rnkhOz/A7oAN2TSqt6dfHHLZwcqXRN
 M0mpCtzQ8Se1PCUM0YYR3olmL0fg5h7rFQIhQ1lXFawXGEu3wS288NJtMURjqoV0CcCqJZxkyge
 2g7j64P9e+Lp8rQbbeF1gIEHf4EBrXd/vPBndG7WtyfInuyggJysida5sPYvlkWM1Q/P2VeZGGm
 wAg3SdI0Ro4rRwyu1iYXS8jvauECmpFOOLdrggYEPTqC6v2WZDvPby2iz/mGQtIVEdtUbn6Y4Bm
 Cr1uiPdFr9yMM31Lp8PNJrFvqYvMbNnXq7SVLy6VLlnjZSgCXKQg4o+D/gIhuq7R5weU9fPAyri
 RN78Jf1DOdWbpcO0c2qaK7nFxacP8VF7xfcVLg9GoQdhlhq3nRND4EL7kQ8QLErVgVfwg9A57nz
 TcxN3Giav4dtGdGAdhA==
X-Proofpoint-ORIG-GUID: CKcSqtm3L5uUsnAxCD0WRRQmXXIx7beD
X-Proofpoint-GUID: CKcSqtm3L5uUsnAxCD0WRRQmXXIx7beD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040022

Move all SA2UL encryption offset macro definitions to a single
location for better maintainability. No functional change.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 44 ++++++++++++++++++++++++++++----------------
 drivers/crypto/sa2ul.h | 13 -------------
 2 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index f5174dccc32b..dac0f8a147e2 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -32,10 +32,23 @@
 
 #include "sa2ul.h"
 
-/* Byte offset for key in encryption security context */
-#define SC_ENC_KEY_OFFSET (1 + 27 + 4)
-/* Byte offset for Aux-1 in encryption security context */
-#define SC_ENC_AUX1_OFFSET (1 + 27 + 4 + 32)
+#define SC_ENC_MODESEL_OFFSET (0)
+#define SC_ENC_MODESEL_SIZE (1)
+
+#define SC_ENC_MCI_OFFSET (SC_ENC_MODESEL_SIZE)
+#define SC_ENC_MCI_SIZE (27)
+
+#define SC_ENC_KEY_OFFSET (SC_ENC_MCI_OFFSET + SC_ENC_MCI_SIZE + 4)
+#define SC_ENC_KEY_SIZE 32
+
+#define SC_ENC_AUX1_OFFSET (SC_ENC_KEY_OFFSET + SC_ENC_KEY_SIZE)
+#define SC_ENC_AUX1_SIZE 32
+
+#define SC_ENC_AUX2_OFFSET (SC_ENC_AUX1_OFFSET + SC_ENC_AUX1_SIZE)
+#define SC_ENC_AUX2_SIZE 16
+
+#define SC_ENC_AUX3_OFFSET (SC_ENC_AUX2_OFFSET + SC_ENC_AUX2_SIZE)
+#define SC_ENC_AUX3_SIZE 16
 
 #define SA_CMDL_UPD_ENC         0x0001
 #define SA_CMDL_UPD_AUTH        0x0002
@@ -44,7 +57,6 @@
 #define SA_CMDL_PAYLOAD_LENGTH_MASK	0xFFFF
 #define SA_CMDL_SOP_BYPASS_LEN_MASK	0xFF000000
 
-#define MODE_CONTROL_BYTES	27
 #define SA_HASH_PROCESSING	0
 #define SA_CRYPTO_PROCESSING	0
 #define SA_UPLOAD_HASH_TO_TLR	BIT(6)
@@ -217,7 +229,7 @@ struct sa_req {
  * Mode Control Instructions for various Key lengths 128, 192, 256
  * For CBC (Cipher Block Chaining) mode for encryption
  */
-static u8 mci_cbc_enc_array[3][MODE_CONTROL_BYTES] = {
+static u8 mci_cbc_enc_array[3][SC_ENC_MCI_SIZE] = {
 	{	0x61, 0x00, 0x00, 0x18, 0x88, 0x0a, 0xaa, 0x4b, 0x7e, 0x00,
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
@@ -233,7 +245,7 @@ static u8 mci_cbc_enc_array[3][MODE_CONTROL_BYTES] = {
  * Mode Control Instructions for various Key lengths 128, 192, 256
  * For CBC (Cipher Block Chaining) mode for decryption
  */
-static u8 mci_cbc_dec_array[3][MODE_CONTROL_BYTES] = {
+static u8 mci_cbc_dec_array[3][SC_ENC_MCI_SIZE] = {
 	{	0x71, 0x00, 0x00, 0x80, 0x8a, 0xca, 0x98, 0xf4, 0x40, 0xc0,
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
@@ -249,7 +261,7 @@ static u8 mci_cbc_dec_array[3][MODE_CONTROL_BYTES] = {
  * Mode Control Instructions for various Key lengths 128, 192, 256
  * For CBC (Cipher Block Chaining) mode for encryption
  */
-static u8 mci_cbc_enc_no_iv_array[3][MODE_CONTROL_BYTES] = {
+static u8 mci_cbc_enc_no_iv_array[3][SC_ENC_MCI_SIZE] = {
 	{	0x21, 0x00, 0x00, 0x18, 0x88, 0x0a, 0xaa, 0x4b, 0x7e, 0x00,
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
@@ -265,7 +277,7 @@ static u8 mci_cbc_enc_no_iv_array[3][MODE_CONTROL_BYTES] = {
  * Mode Control Instructions for various Key lengths 128, 192, 256
  * For CBC (Cipher Block Chaining) mode for decryption
  */
-static u8 mci_cbc_dec_no_iv_array[3][MODE_CONTROL_BYTES] = {
+static u8 mci_cbc_dec_no_iv_array[3][SC_ENC_MCI_SIZE] = {
 	{	0x31, 0x00, 0x00, 0x80, 0x8a, 0xca, 0x98, 0xf4, 0x40, 0xc0,
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
@@ -314,25 +326,25 @@ static u8 mci_ecb_dec_array[3][27] = {
  * For CBC (Cipher Block Chaining) mode and ECB mode
  * encryption and for decryption respectively
  */
-static u8 mci_cbc_3des_enc_array[MODE_CONTROL_BYTES] = {
+static u8 mci_cbc_3des_enc_array[SC_ENC_MCI_SIZE] = {
 	0x60, 0x00, 0x00, 0x18, 0x88, 0x52, 0xaa, 0x4b, 0x7e, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00,
 };
 
-static u8 mci_cbc_3des_dec_array[MODE_CONTROL_BYTES] = {
+static u8 mci_cbc_3des_dec_array[SC_ENC_MCI_SIZE] = {
 	0x70, 0x00, 0x00, 0x85, 0x0a, 0xca, 0x98, 0xf4, 0x40, 0xc0, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00,
 };
 
-static u8 mci_ecb_3des_enc_array[MODE_CONTROL_BYTES] = {
+static u8 mci_ecb_3des_enc_array[SC_ENC_MCI_SIZE] = {
 	0x20, 0x00, 0x00, 0x85, 0x0a, 0x04, 0xb7, 0x90, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00,
 };
 
-static u8 mci_ecb_3des_dec_array[MODE_CONTROL_BYTES] = {
+static u8 mci_ecb_3des_dec_array[SC_ENC_MCI_SIZE] = {
 	0x30, 0x00, 0x00, 0x85, 0x0a, 0x04, 0xb7, 0x90, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00,
@@ -432,7 +444,7 @@ static int sa_set_sc_enc(struct algo_data *ad, const u8 *key, u16 key_sz,
 	const u8 *mci = NULL;
 
 	/* Set Encryption mode selector to crypto processing */
-	sc_buf[0] = SA_CRYPTO_PROCESSING;
+	sc_buf[SC_ENC_MODESEL_OFFSET] = SA_CRYPTO_PROCESSING;
 
 	if (enc)
 		mci = ad->mci_enc;
@@ -440,7 +452,7 @@ static int sa_set_sc_enc(struct algo_data *ad, const u8 *key, u16 key_sz,
 		mci = ad->mci_dec;
 	/* Set the mode control instructions in security context */
 	if (mci)
-		memcpy(&sc_buf[1], mci, MODE_CONTROL_BYTES);
+		memcpy(&sc_buf[SC_ENC_MCI_OFFSET], mci, SC_ENC_MCI_SIZE);
 
 	/* For AES-CBC decryption get the inverse key */
 	if (ad->inv_key && !enc) {
@@ -523,7 +535,7 @@ static int sa_format_cmdl_gen(struct sa_cmdl_cfg *cfg, u8 *cmdl,
 				SA_CMDL_HEADER_SIZE_BYTES + cfg->iv_size;
 
 			cmdl[enc_offset + SA_CMDL_OFFSET_OPTION_CTRL1] =
-				(SA_CTX_ENC_AUX2_OFFSET | (cfg->iv_size >> 3));
+				(SC_ENC_AUX2_OFFSET | (cfg->iv_size >> 3));
 			total += SA_CMDL_HEADER_SIZE_BYTES + cfg->iv_size;
 		} else {
 			cmdl[enc_offset + SA_CMDL_OFFSET_LABEL_LEN] =
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 0788d68bc30b..ecd8f09faf59 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -46,7 +46,6 @@ struct sa_tfm_ctx;
 
 /* Number of 32 bit words in PS data  */
 #define SA_DMA_NUM_PS_WORDS     16
-#define MCI_SZ			27
 
 /*
  * Maximum number of simultaeneous security contexts
@@ -60,12 +59,6 @@ struct sa_tfm_ctx;
 #define SA_CTX_SIZE_TO_DMA_SIZE(ctx_sz) \
 		((ctx_sz) ? ((ctx_sz) / 32 - 1) : 0)
 
-#define SA_CTX_ENC_KEY_OFFSET   32
-#define SA_CTX_ENC_AUX1_OFFSET  64
-#define SA_CTX_ENC_AUX2_OFFSET  96
-#define SA_CTX_ENC_AUX3_OFFSET  112
-#define SA_CTX_ENC_AUX4_OFFSET  128
-
 /* Next Engine Select code in CP_ACE */
 #define SA_ENG_ID_EM1   2       /* Enc/Dec engine with AES/DEC core */
 #define SA_ENG_ID_EM2   3       /* Encryption/Decryption enginefor pass 2 */
@@ -142,12 +135,6 @@ struct sa_tfm_ctx;
  */
 #define SA_CTX_SCCTL_OWNER_OFFSET 0
 
-#define SA_CTX_ENC_KEY_OFFSET   32
-#define SA_CTX_ENC_AUX1_OFFSET  64
-#define SA_CTX_ENC_AUX2_OFFSET  96
-#define SA_CTX_ENC_AUX3_OFFSET  112
-#define SA_CTX_ENC_AUX4_OFFSET  128
-
 #define SA_SCCTL_FE_AUTH_ENC	0x65
 #define SA_SCCTL_FE_ENC		0x8D
 

-- 
2.43.0

