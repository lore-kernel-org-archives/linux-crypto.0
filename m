Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771223;
	b=Qiw6lmrlr+XlcthrvFhy+E4rvn66DWHvhz2aHr4NWyIdqt1CIsKdbcGxM3Vy4ssTfF0u
	 GOGeZJ9wL2YSI4BjwtP/PnPKWdqr3vDJhowmkTnfIy41km2enPJD73WOlZGH6gF29OZRL
	 YoScZ+ajLzD932SIlmFBmsjPEdYvzPcmHfrsSEgKKYhuwioZdGbR6REbyKOLqvvhKBJZ8
	 JJBZ3BbF81xphP80kagWH8xXZzKF8E/AKyNW39EtV5Y67BVOgYslNNXiHNrptQL0uJ4ks
	 KNd3ok1OLX8lsPPffeK4OAiL6HXnpoB3VplWzdRipcl8HqPWs7Q7Pv4xmOl+i9o8yMg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771223;
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
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=8CTNLu9AnJQ1+DGDVUHz9aYyRgF9o4/R53g04SUawFQ=;
	b=Iph+A57/zMjY12357eQr4EcU22vEIEO44/rgoOdMlxg9CVuk33djzvsUipBIINoKzpbC
	 8wzJxnxMWpWnsOol9mp4pqAwNE3BWfz2UeZlM6I4zt1MTKkEzGWBjahN5AUmyXXAtaQ7b
	 D8Il4YK9O0cao91anE/mWWpobJHvhjlTc5G8rpF0HE2PvlpS/M6xYD+7XwTQXNchSuptp
	 ZV6n5RAuXcgwcJJMAX+A7S2YJCv2aU4bSE3I4spQjduK1TbwSSGMmju4Sm5ofsST0gz2z
	 YjY0tG9XrL8iISNPrZeAHE9/hzuElKiwNQeiq1zw1qA6hKcx3EFXKi8+i7NhPYD9GcQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=NhuxEBKY;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=afVBF8kv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36608606D801;
	Wed,  4 Nov 2026 05:47:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36608606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=NhuxEBKY;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=afVBF8kv
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A42TLVH601424;
	Tue, 3 Nov 2026 23:46:59 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=8CTNLu9AnJQ1+DGDVUHz9aYyRgF9o4/R53g04SUaw
	FQ=; b=NhuxEBKY8kx8l0rsLQunFPeQu+MdbuuRJ35Ab3XVGyIiWGuCoF5kuENsm
	vFUBx1KI1hT9e6X2akyR0woet6rsXoN7S26hWrl7XSZiIKD62A+hIqW0vmxoHyfC
	iGT7Ndj3ddGbt88hup8LnSYbAggC9iqAUiG/Xowco9VN2uHylntCkX6QQUd2Tm8h
	8deWegFIuUYWtEsZAGg8BjjDMCzx43hf9iHxtvtxWsB2YJxNbRT9Btat1nz9wTsO
	z+aPu8B/UwyP9q8B9LzHU4eYFc4XUrawh1GMmHQXY6pDDYUfaSaxDQetC2KtOLcy
	ufKQr7qCi6mBXeaLOR21cTcONk0VQ==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011037.outbound.protection.outlook.com [52.101.57.37])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hquyf0tvd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:46:59 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wbPQ+Ej8DZWGi0gKFgcmQRglFgHN4Wrbz8i7ZzTVkDvMtzJGxNtZsK1RH3qH24ImCNQX/k6j+QJH8Gxu2zz77dNUEDrYExM/kcy8swM0KCDEJO3pRGmUZ8ee1HmSga4sOCqqUvfGYFGGtYChuFb+3ihpny20hHchvOou4i1Na1RP9x4eUwlAk9WMl+dBA1la0GNUJnb0WY/A8M1WQIMQyFpLFIEHcsgg0Jb4GkfSTyv1gY2G2K/of4+G+X7EYQpdDDGzL9L4vs19htjtgNqyaKm30lsLBriTglTNuc63y+OiwaGEajTRI56NGON6gnEYK+87PfnWiLv5glOAERZNXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8CTNLu9AnJQ1+DGDVUHz9aYyRgF9o4/R53g04SUawFQ=;
 b=JThg65YMMOtUmj6RrUrx9ERusCohZ3KpaAbME/cEYjX/ad+sDPNInUGInWez/bld5nkafLKiypUiO93wuAVvYcfR+ahmbopRK9zFw7O/7YeLv9REy21kTYkNQYF36+KJ4S+ucBeZgqtFD+UroDD9z4RJcrRLk2NSbNACuvpT/D2q4QnBBXt7Ua1KfMfcnSrMxxsB/N1wr9nt+GUgA/Ji3R3K131auU8nZIUDqGZT+/RouEdqPHqqcduX2k3BHGMqQuq3t27lQH5JhQ0XT4KmmUQfNSKfIezPlOvfgAqG0DGAJlFuUmrieX/CsyJ1EvqI0HNJhQPfaDy2UCuu0FURVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8CTNLu9AnJQ1+DGDVUHz9aYyRgF9o4/R53g04SUawFQ=;
 b=afVBF8kvGD2h+PIH3NUWp9YofYSI1nrRy+qyyzPsWDJpm0UV2ix1CPk11NkG1YB61yMw9aEWHwsv+f8c8apTRLrSEId1m5/tuovqJeKP/fVXPq1wvkFZsCEv3gDKju2/XZ6vhFFH7r/Thqw/0sS+IFdPegCa8efIeN/0THY/1Uc=
Received: from MN0P220CA0020.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:52e::17)
 by LV3PR10MB7938.namprd10.prod.outlook.com (2603:10b6:408:217::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Wed, 4 Nov 2026
 05:46:54 +0000
Received: from BN2PEPF000044AB.namprd04.prod.outlook.com
 (2603:10b6:208:52e:cafe::68) by MN0P220CA0020.outlook.office365.com
 (2603:10b6:208:52e::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:46:54 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN2PEPF000044AB.mail.protection.outlook.com (10.167.243.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:46:52 +0000
Received: from DFLE204.ent.ti.com (10.64.6.62) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:46:13 -0600
Received: from DFLE210.ent.ti.com (10.64.6.68) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:46:12 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:46:12 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJ0E521920;
	Tue, 3 Nov 2026 23:46:09 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:40 +0530
Subject: [PATCH v2 30/30] crypto: sa2ul - add SA3UL_CM AES support
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-30-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=8296;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=lBgq95aB7ywlSG8iMMYbEX+dmj5muke7QlhRGpvwOdo=;
 b=UoimRtekMRsy5lyvufHM0dn59jlCV0D3KPchqzk9BlVgqV4NsE21ed9xOtf9iIuGU50CcCH9W
 on/AHBTunRGDohtes93WadYAucsC0XN6ph4pLo8E6kZJv7/fhHNCimY
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AB:EE_|LV3PR10MB7938:EE_
X-MS-Office365-Filtering-Correlation-Id: 2655b0c5-a058-4226-aff2-08df3a370744
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|56012099006|261021121427099003|261021130227099003|261021123027099003|261021133027099003|261009223027099003|261022105027099003|261022113327099003|261021135927099003|261102123227099003|261022115727099003|261026130827099003|261026135527099003|261026140227099003|261028144727099003|261026121527099003|261022075727099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	G95DAipZCqXlCuCvANJFnrwkmoBuULgry2CsGV28VWXphjr+0enqArhEt+ch32yFu9NlWmdJ5piVofPi7XEjmtGbPR1YrixzQRWEznec/y8dzI6P0enyfYY8XlapCDLOMPhrmNRU2ahXiiNBfiZj0tOIQ932LjNujipRoBF1EwOjGC8sPVZbEwVT/XxXOg9ixT9psUExU0IdC1DYZ+XbChbmf1fcRdz0BdQ9NnuWAJBLvRjlqotAt0z2t7XAvuznWKzlWG9yUSmbEPIQZZbrtHv0R57ZY8263B4FrSUpaKqf2aObxB/DUhuOkAByfSUfohFIpYOuOxnSJ/ns/rEfF0FmPhxPW1VMidimsOcJ1lO5Mq9StrBoDo77iRVuGnq6f+tg4nVhSfDgRq4ESZDfGyfAj/3xS2I2/ZjEm0AtFiMdZVyc02wVnmd4bTdna9fyS72jUMDEyqwiLxkQCn+2uS/Jzj3tXMZrybcUr/NtFEvSp48uKXiYfvkneph2/8HeSPzV5uUq5nzgCgOgcYlpeKL5j/sSreLYRui+L1z70/g2Y69M4zQ5qHtJ9u/R5iVkTmfEYCPHYrmr025j3SxOEWs4LwvH83mpSuPs+IXHHRwhKGp4bdG63tKl0g6zR6IWkNSJR1N64MzcN68C4t4ZHaHcbEcN0DDvFIYnM/7CMdyGxYFm2hT/WwI4Vb0BYuST
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(56012099006)(261021121427099003)(261021130227099003)(261021123027099003)(261021133027099003)(261009223027099003)(261022105027099003)(261022113327099003)(261021135927099003)(261102123227099003)(261022115727099003)(261026130827099003)(261026135527099003)(261026140227099003)(261028144727099003)(261026121527099003)(261022075727099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	whKwGgDckoy76DzOwk5XfQ5EWIDHiiazmwvb9zGPX2MZC3OG/mvsXtW+E0MZTnSPx5xSkGTltgIRB0+/TNpkOVfZOwqBCxdsX1mDjUUgXX9CFxupgwGwGXbUjQuf/WnnYTKkh72TRosKZRlRj+u0RhhAWK9k/+kfCQbzsBp0g7OhmQINYishDxWjx0cPXxXXW1mveYx0MxQS7jrp8V0IJJaZjCTXV7AbxJOCUucPIlVvhHsdCHqMdWLSLGFfOpWYZOhl6SxLOVXgNH9arzL08QYS5vEShfJuQFEAiZohBiwfFf1Donevq7/3LK5mjLENdmhEpk6Bei8XYRhSzhqlO8KHutk7QFWWiEUk8na7HuL1ICmhsIQSaRh8IopOENGQZe7KNEJqjLgNXgVhlOSglqJA3fWInsPvyYeKZkPy0qng/Un/xpFXm3MEaCKZjB5d
X-Exchange-RoutingPolicyChecked:
	wGwJqwpoXo5XhI9obfFpRs+MmRZ1RRE/JqE3JgLELKGwwoXAkabW+UlwF45n2wzpDoV1OJD0Kxh4y1eTuFVJ1f24r71xZKrAYptZobzf9LUQF1ATPy0ugNcnY5SDZl7olSSe6qN15vBrL66aDjuHUqGsbyXU+yHGd0DOfHnhAgSWf6/W+vkoOmbavGsJZMnn4qd3lxVHVc117Nlsi5c6pKWebzJ/9YzXTBh/D9BXNz990iAR4Z/rft1T8BG+urqSF8OhrTLTgyVIxFQaiTwRHuLmiGDMBcXdCUzi4bNLr3aG7Jr9TYs4qV1rkygMJ/f1iiL61/f0Fzxiqe5jC2zNqw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:46:52.8219
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2655b0c5-a058-4226-aff2-08df3a370744
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7938
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX3igr2UVprkr3
 AJuDkZ0l3TZi3ZC8TgFJHRJamqErMsswwjHvQZA3jCzQdkb8jsCC9NoIRbPjoy8NMmwB/sxIGRh
 KFD1fKc+boEbm5MvUXxYskfn0MY82qel+xeZzaTIBlatYjXfkoiAXOH4GOlD8CSHD09i4Cz4tkG
 xIZaCKuIeMvx9qUYZNmpSWjiRBX55Bj1BbM0JSg8FBhEMMSV5xMhXJjUqzkngK9G4Ekhi5+iupn
 Eu81HvjgLqWkf0t4hHyIdciZkDccgCYHiyrwvKqDf/zvzJLrSl0Gu73CGvylgJPWoNdSqc/7brN
 dNzXPsP5OnynYCVI1twynaA+hjuHyyBpP9N6FY0FaeSLlREFSnX4lv9EkmTcoWqka/xZGavymIe
 DvEvE0YfpFMVDr320sDYNBq1T7nByij8M2G1nvnK75pcagokyKhpZ34OWFzTnQnGOPNZVc28DaW
 pQWUmlFKNfXQ2ricr2Q==
X-Proofpoint-GUID: rYURHuLxn3a7bfn3jKx6iXeUtxnxbQ_Z
X-Proofpoint-ORIG-GUID: rYURHuLxn3a7bfn3jKx6iXeUtxnxbQ_Z
X-Authority-Analysis: v=2.4 cv=MpzHeGae c=1 sm=1 tr=0 ts=6aeac6d3 cx=c_pps
 a=S+V0rrE8P+iIDgN9m6arSg==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=3T_XwJiAtBnqFbxq5rgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX2hhqLZIL6w+v
 la5zQKgC27DNrf2W1Lh7xuhlafNQ/Gpl8HSRbbhsOCIXD8KRlAKkOGBPTefshMDCfB3T0rjSsQZ
 NXPYHjcijGAXD8L5oj+v2ViF3w9/Rc0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040022

SA3UL_CM revision 3.1 needs an extra key-schedule round for AES-256
decryption and a random AES-ECB operation after power-up to activate
its side-channel countermeasures.

Derive round 15 in a separate temporary and wipe it after copying,
rather than overflowing the expanded-key array.

Prime the hardware through sa_run() before registering algorithms,
so self-tests cannot precede the random operation. Use a temporary
context and a callback that releases DMA state and wakes the waiter.
Use a DMA result callback so an aborted or short transfer fails probe
instead of being treated as successful priming. Bound the wait to ten
seconds and terminate DMA synchronously on timeout before releasing
the temporary context, buffers and stack-backed completion state.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 156 ++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/crypto/sa2ul.h |   2 +
 2 files changed, 156 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index d7ea61452577..59e1b049c648 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -13,6 +13,7 @@
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
 #include <linux/interrupt.h>
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
@@ -21,6 +22,8 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/random.h>
+#include <linux/slab.h>
 
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
@@ -401,11 +404,22 @@ static void sa_prepare_iopads(struct algo_data *data, const u8 *key,
 	memzero_explicit(&k, sizeof(k));
 }
 
+/* SubWord using kernel AES S-box */
+static inline u32 sa_aes_subword(u32 w)
+{
+	return (u32)crypto_aes_sbox[w & 0xff] |
+	       ((u32)crypto_aes_sbox[(w >> 8) & 0xff] << 8) |
+	       ((u32)crypto_aes_sbox[(w >> 16) & 0xff] << 16) |
+	       ((u32)crypto_aes_sbox[(w >> 24) & 0xff] << 24);
+}
+
 /* Derive the inverse key used in AES-CBC decryption operation */
-static inline int sa_aes_inv_key(u8 *inv_key, const u8 *key, u16 key_sz)
+static inline int sa_aes_inv_key(u8 *inv_key, const u8 *key, u16 key_sz,
+				 bool aes_cm)
 {
 	struct crypto_aes_ctx ctx __cleanup(aes_zeroize_ctx);
 	int key_pos;
+	u32 round15[4];
 
 	if (aes_expandkey(&ctx, key, key_sz)) {
 		dev_err(sa_k3_dev, "%s: bad key len(%d)\n", __func__, key_sz);
@@ -418,6 +432,24 @@ static inline int sa_aes_inv_key(u8 *inv_key, const u8 *key, u16 key_sz)
 		ctx.key_enc[53] = ctx.key_enc[52] ^ ctx.key_enc[47];
 	}
 
+	/*
+	 * SA3UL CM hardware variant needs an extra round 15 for AES-256.
+	 * ctx.key_enc[] only holds 60 words (rounds 0-14), so round 15 is
+	 * computed into a local array.
+	 */
+	if (key_sz == AES_KEYSIZE_256 && aes_cm) {
+		round15[0] = sa_aes_subword(ctx.key_enc[59]) ^ ctx.key_enc[52];
+		round15[1] = round15[0] ^ ctx.key_enc[53];
+		round15[2] = round15[1] ^ ctx.key_enc[54];
+		round15[3] = round15[2] ^ ctx.key_enc[55];
+
+		/* Decrypt key = round14 || round15 */
+		memcpy(inv_key, &ctx.key_enc[56], 16);
+		memcpy(inv_key + 16, round15, 16);
+		memzero_explicit(round15, sizeof(round15));
+		return 0;
+	}
+
 	/* Based crypto_aes_expand_key logic */
 	switch (key_sz) {
 	case AES_KEYSIZE_128:
@@ -457,7 +489,10 @@ static int sa_set_sc_enc(struct algo_data *ad, const u8 *key, u16 key_sz,
 
 	/* For AES-CBC decryption get the inverse key */
 	if (ad->inv_key && !enc) {
-		if (sa_aes_inv_key(&sc_buf[SC_ENC_KEY_OFFSET], key, key_sz))
+		struct sa_crypto_data *dev_data = dev_get_drvdata(sa_k3_dev);
+		bool aes_cm = dev_data ? dev_data->aes_cm : false;
+
+		if (sa_aes_inv_key(&sc_buf[SC_ENC_KEY_OFFSET], key, key_sz, aes_cm))
 			return -EINVAL;
 	/* For all other cases: key is used */
 	} else {
@@ -2474,6 +2509,114 @@ static const struct of_device_id of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, of_match);
 
+/*
+ * SA3UL_CM (aes_cm) requires a one-time TRNG-seeded AES-ECB priming
+ * operation after every power-up/reset before its side-channel
+ * countermeasures are considered active.
+ */
+static void sa_aes_cm_trng_prime_callback(void *data,
+					  const struct dmaengine_result *result)
+{
+	struct sa_rx_data *rxd = data;
+	struct crypto_async_request *base = rxd->req;
+	int err = result->result == DMA_TRANS_NOERROR && !result->residue ? 0 : -EIO;
+
+	/* sa_run() bypasses crypto_engine, so complete the wait directly. */
+	sa_sync_from_device(rxd);
+	sa_free_sa_rx_data(rxd);
+	crypto_req_done(base->data, err);
+}
+
+static int sa_aes_cm_trng_prime(struct sa_crypto_data *dev_data)
+{
+	struct sa_tfm_ctx *ctx;
+	struct algo_data ad = { 0 };
+	struct sa_cmdl_cfg cfg = { 0 };
+	struct crypto_async_request base = { 0 };
+	struct crypto_wait wait;
+	struct sa_req req = { 0 };
+	struct scatterlist sg;
+	u8 key[AES_KEYSIZE_128] = { 0 };
+	u8 *pt = NULL;
+	bool ctx_ready = false;
+	int cmdl_len;
+	int ret;
+
+	ctx = kzalloc_obj(*ctx, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->dev_data = dev_data;
+	ret = sa_init_ctx_info(&ctx->enc, dev_data);
+	if (ret)
+		goto out;
+	ctx_ready = true;
+
+	ad.enc_eng.eng_id = SA_ENG_ID_EM1;
+	ad.enc_eng.sc_size = SA_CTX_ENC_TYPE1_SZ;
+	ad.mci_enc = mci_ecb_enc_array[0];
+
+	get_random_bytes(key, sizeof(key));
+	pt = kmalloc(AES_BLOCK_SIZE, GFP_KERNEL);
+	if (!pt) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	get_random_bytes(pt, AES_BLOCK_SIZE);
+
+	ret = sa_init_sc(&ctx->enc, dev_data->match_data, key, sizeof(key),
+			 NULL, 0, &ad, 1, &ctx->enc.epib[1]);
+	if (ret)
+		goto out;
+
+	cfg.enc = true;
+	cfg.enc_eng_id = ad.enc_eng.eng_id;
+	cfg.iv_size = 0;
+	cmdl_len = sa_format_cmdl_gen(&cfg, (u8 *)ctx->enc.cmdl,
+				      &ctx->enc.cmdl_upd_info);
+	if (cmdl_len <= 0 || cmdl_len > SA_MAX_CMDL_WORDS * sizeof(u32)) {
+		ret = -EINVAL;
+		goto out;
+	}
+	ctx->enc.cmdl_size = cmdl_len;
+
+	sg_init_one(&sg, pt, AES_BLOCK_SIZE);
+	crypto_init_wait(&wait);
+	base.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	base.complete = crypto_req_done;
+	base.data = &wait;
+
+	req.size = AES_BLOCK_SIZE;
+	req.enc_size = AES_BLOCK_SIZE;
+	req.type = CRYPTO_ALG_TYPE_SKCIPHER;
+	req.base = &base;
+	req.ctx = ctx;
+	req.enc = true;
+	req.src = &sg;
+	req.dst = &sg;
+	req.callback = sa_aes_cm_trng_prime_callback;
+
+	ret = sa_run(&req);
+	if (ret == -EINPROGRESS) {
+		if (!wait_for_completion_timeout(&wait.completion,
+						 msecs_to_jiffies(10000))) {
+			/* Stop DMA and late callbacks before releasing the stack wait. */
+			sa_cancel_dma(dev_data);
+			ret = -ETIMEDOUT;
+		} else {
+			ret = wait.err;
+		}
+	}
+
+out:
+	if (ctx_ready)
+		sa_free_ctx_info(&ctx->enc, dev_data);
+	memzero_explicit(key, sizeof(key));
+	kfree_sensitive(pt);
+	kfree_sensitive(ctx);
+	return ret;
+}
+
 static int sa_ul_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -2514,6 +2657,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 	major = FIELD_GET(SA_REVISION_MAJOR_MASK, rev);
 	minor = FIELD_GET(SA_REVISION_MINOR_MASK, rev);
 	dev_info(dev, "SAxUL_VERSION: %u.%u\n", major, minor);
+	dev_data->aes_cm = (major == 3 && minor == 1);
 
 	ret = sa_init_mem(dev_data);
 	if (ret)
@@ -2545,6 +2689,14 @@ static int sa_ul_probe(struct platform_device *pdev)
 	if (val & ~status)
 		writel_relaxed(val, saul_base + SA_ENGINE_ENABLE_CONTROL);
 
+	if (dev_data->aes_cm) {
+		ret = sa_aes_cm_trng_prime(dev_data);
+		if (ret) {
+			dev_err_probe(dev, ret, "SA3UL CM TRNG priming failed\n");
+			goto free_engine;
+		}
+	}
+
 	sa_register_algos(dev_data);
 
 	ret = of_platform_populate(node, NULL, NULL, dev);
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index ba3fb91daaa4..199eff4467d7 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -194,6 +194,8 @@ struct sa_crypto_data {
 	spinlock_t		request_lock; /* request admission */
 	struct mutex		dma_lock; /* DMA setup and cancellation */
 	bool			stopping;
+	/* true if HW is SA3UL_CM (SA_REVISION major=3 minor=1) */
+	bool aes_cm;
 };
 
 /**

-- 
2.43.0

