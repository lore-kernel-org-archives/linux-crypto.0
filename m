Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063453;
	b=UF9R5eCM16J4Xw0hKn5H3DGT0s2ukYMuiJ1ACpzJe+ZYRC9Gsqb1LWxUKQfeEmCT2Aip
	 AnPAY3WllE8Wx/AhJKMEPI82583ZxOQMp+Yf5NHxKwBNmY1Vkncys0QmMNnKjgyiCdbfa
	 +C2OhJw5gX4tviXdP3AahL1tg7Y+BPHCnlajGLxy6lt731RJtoyLe4ACtJYf6lU5eQ+1X
	 4Q3ppe7BNER5xfFWwXGiJiItN3j7DOc3hOQR/wyABMab1D1/sW+Yk1fWAKlRhrDI0h+VJ
	 8VOY889J8xYq8KYqQqMDW+GmA557EInig60dSE6CVKTN/wQCn2WBHOIphfyOJNgJLqg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063453;
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
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9inM=;
	b=e6mBn6CnNAUkM1Z0lgYdbst3FHoQHGYs95eVC3GWY/e/h2P5Y+b+c55FARK9B9cDDGie
	 AjtMn+65rYlQmGRv7GjP0FsqKlVVOEwXdk8a8RBqkd0LHilZ+gpKxGSL2mRa+hyVcRTTY
	 EOc/9KD1OzIj06vni0TZ2ukDo47G4ajIa0/a9UKq+IMIGRPDWwGAQpcUMH51qPt7mV776
	 aTwVgXNJh0CSkcM2H47DCxDC5SQjpB4DCJPwnzEJOSjvNiXKUlM2fnSIo/Y9ZENKoB6PS
	 V27bIMG4AAG1xgv/smaCE9hs0GfyPjvcmdkR93Sni2LzoUgTlw+IwSYtSmIqon7pk6g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=k58YDHzO;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=BW35vvdX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA19606D82B;
	Sat,  7 Nov 2026 14:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEA19606D82B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=k58YDHzO;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=BW35vvdX
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A7BwVDh1609413;
	Sat, 7 Nov 2026 08:57:29 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9i
	nM=; b=k58YDHzOVcAQZlPWa6bEKoprrJBdsAT+AyUGhmY693YklPOtIz6GU7hRj
	bG2fWhuV/umxhykoKRX10PjmQrRcj8UUQDgsbeaMGrJ5sG79AoqqhwCNw8HPOZBa
	J+3ONlIs/WSnSj84X9RZ2EsztYbK3gFjYyfxlSIlMGtcRxHD46NL1g4I0DVZk0R7
	HVRKEOjTE0wwrs5SpnT5fY7QlIYbqfbEUFdXKW7UbKYG/zggUMmS2H0bS9KLI+47
	x9rJ7ga58pe5AntydV9LyQGNnE6S+we+z+TsZeyhcZ20volF9i+PCu6ayRs2LI9f
	TE0cZAkpPj71Ux3ZRoz23mYjRu7Ig==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010035.outbound.protection.outlook.com [40.93.198.35])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4ht0wqs08j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 08:57:29 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=COL0afMlxlzKRUywfUW69GV2PTk6fBB78UR6MrLyUEHGIZA4EzD/Dv+tPCmVQCfM5Se8VXDoZOOUXzGTbNvtDVmx9INvpQ5+IGodagMjUweqsUFGnpVbIWoFQvtWsvBh0DBZ6SukN+9evnroVh5ILDg2hYI7Nv/MQA8/PreB+PifRPScKVn/hftHLKlxKuKMnb5b/FzQ5UuEnjcJXlT5sHRtCYxFzNTTUp+HHOfyWARILCRyxysuUqK8jZ2reB9Kh7eaHEMHClvRMyhk6EfI9BKsUla+dvBBXv6QgburZ8PbILSllYasvP02sEWXfF0u/X1rGZszi7zQfOdT5gH88w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9inM=;
 b=jCbmav8clywNdah48W9GrGW9BoHM7N5aR4kLOkDd8Suhv9Cda1qdmwfxUpIrcKXL9BzSzBWKj2xAJ0QWpIZgVlkbY6ju/8EQkPtFCWV6DBBRc543qflWk5RgialkfeynLueP60VGAg4V2RDg+uM5Yo5hLYp0DV20g6/CkVKzfMvw1zm/mA2dTgIVj0BZthr4HZathtyhPR1L8ztGRMtb1SjW2EmYN/j5H7FqYNjRIgSAOafkT5G+xX2ITHHRhhct5FYiZSkVLUWs1AuyfXvVHP1JO14sXUrZX4eh5AJNnf7zn5pr8+3u1cDIpOH/6PkXif6/VeqyODAM5oGjauujSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9inM=;
 b=BW35vvdXScxKrc6o+mNKK+ckgK0+LJfJOPozvFs2vbIwFPLeietH/BP+rT7Z+R8wBBW1q/wUho2pbalSb7qqdi4Wqiv2oWEUzKEeU8jO8M7ih6gAKa1uMDUXaE1Jz+Jmx8agfadBlSUDI8Dwjg6B+L2zTbv3hDZl+BH/eFABi3g=
Received: from PH7P220CA0151.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:33b::11)
 by BN0PR10MB4982.namprd10.prod.outlook.com (2603:10b6:408:12c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 14:57:26 +0000
Received: from BY1PEPF0002695D.namprd05.prod.outlook.com
 (2603:10b6:510:33b:cafe::a4) by PH7P220CA0151.outlook.office365.com
 (2603:10b6:510:33b::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 14:57:26 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BY1PEPF0002695D.mail.protection.outlook.com (10.167.244.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 14:57:25 +0000
Received: from DFLE210.ent.ti.com (10.64.6.68) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:57:01 -0600
Received: from DFLE212.ent.ti.com (10.64.6.70) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:57:00 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 08:57:00 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7EuxQo190749;
	Sat, 7 Nov 2026 08:57:00 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v11 08/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
Date: Sat, 7 Nov 2026 20:26:11 +0530
Message-ID: <20261107145618.2349562-9-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107145618.2349562-1-t-pratham@ti.com>
References: <20261107145618.2349562-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0002695D:EE_|BN0PR10MB4982:EE_
X-MS-Office365-Filtering-Correlation-Id: 5529ce5f-ff75-4ef5-4680-08df3cdf6f51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|82310400026|1800799024|36860700016|56012099006|261021121427099003|261009223027099003|261102123227099003|261026121527099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	1xXFVVXQIwRTgkSfgnEVHmNU1VR+ciWO38S5mkwwzRmcxDcCdoqtX76MZd61m1nfj5jc24DgcB2GM9hX838dYSHFXiKLAXqdf3s2hIaISqcrQXEQjr6o3QkCkFtSJZl421UP0YKnO1IrAJjO0Q/B8RaJ3WIMHTOZxzuExK2MD1a2OEE9tgmxFlPThkDRT0f85CdzQu65Kw73ekb3E/gfTwJqbfNYP6+p01DZV8+j1rGbawblmTLRVL97YD51puhP+1KldBzb8QnEgBrBM0t/jc3384shr2sRIRVPjZzLfdAKHbZBSCje9f68H0YDGz3hrXSwZ7P/8mFzXJURxEv0pwwHdPt7vsBwYhfbfkLAdD7BnOY81QNHFDuOptPKA3kvIHpuT1enDS84GS+2KSXKWuC6snQuSQbqxXrw4BZCZBLlQW5EPratwUNWqRG43PzvyDcjVZascAL0LiTrj+a1at2dwjDLMqXQXsZeRaAvcftPn170iyJneQiRBga9FUBUTQy21oTdzdZvCb04P8IeSa5FYKdIsMKKMz06/bhwibxQdxU9Vq1qEONHJnlN9LtlWGMHy1djAnE9+rEvVNHMNvTHAbz+2Zeg5/zwb9/XQYdkelgPKQveymrbOs1UcirklOC+DYtC+qRJ/zkf9lI3by3aY6UYD3JS5/vpWXu8SJ0Ga7EVkUciPCAWYlKF9wTqafWU8/Mv5MlQKW3vOohbRA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(376014)(82310400026)(1800799024)(36860700016)(56012099006)(261021121427099003)(261009223027099003)(261102123227099003)(261026121527099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Kq472vHTkpjZt6vSz4X1+ypz+0gRLbFeCgBtcnJ2C7O4VfswAS7+eUMvdc/+njQxWYS5afjVXllvQ5r16Dx/kXnV1cecUQ4DxIlngHjay9kk7/+fZwoiQEx/caIEZQhhWaq0a7HPvtHuixjyZLgAL5/lFwRPFKp2H9uDnq0RuszYxkc1aX+/NJ37INKM5PgjlBNOnvcjbluBOrCrkOqPu+LAAZwAO8sU21cp3zWdMHJz/O5gJ97HPvTHP34odb+30WoxbOuhvIGweoHJ7D/WpCFeMlcpILY3r42b5KxpLHO+/BrG4j4/TO/ISgyX4/awfuu76mt/B8D29lLldSkfAcGvzzsxLMzoCWAdrQgAgPC6sPE5k1/Vxg+McPgCVdIAqLVuR6lMsizVQCF1XqFIRvoP2LcqQPywXfLTvE6xwKgdSAhryFPFejNV1DwkfKtL
X-Exchange-RoutingPolicyChecked:
	iovXj4yTWqVWwXGBjC6ex/fTcNKcecWDC4eS8u5UXGtKFK6l0qoApT0Y6pLtfUcjX7GzP8xLCZDFoTqbtm5geWxYKc2YmoKzjEE42DxlB82qI4FxzshX1KaWaBWgfUHC+XgnAwRlIQgId07nYx4UD7v3gTK0KORVH/BHW3pj8EcBVwgcFahu1Vn0j2CtK6UfuWsUM7M6jg41P5gc/9vx5QVXjFzeRwbfNubEscMEtDgozNKbXSrX4I1Cph/4PMJl9Wnmw+aF8FFydg00lAvPLMNR0BaLAlGglkAnQBfalaxXtI2Y/frO4otVVq5NFXlBirqdFJoLstGtWx32BIAAgw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 14:57:25.1482
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5529ce5f-ff75-4ef5-4680-08df3cdf6f51
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0002695D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4982
X-Authority-Analysis: v=2.4 cv=H/hOUOYi c=1 sm=1 tr=0 ts=6aef3c59 cx=c_pps
 a=WVTIIPXEjO/6WBYygohQVQ==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22
 a=sozttTNsAAAA:8 a=wrH6CD59uMa574BPOq8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX9zuGIa5MmQA6
 IEsinE7UivnQnQVvb/SFx79kfs+Llm2hFWV8MbD2jkQesXoWctpkA6EbA5plPpqiAa6HRxSAyIa
 FExK2kfai+uoDIV9yHqu9ZiBqufwkEdmDiNT53KU77XicpRaj31Fio8L3ejspC4F54MdxiA7YQX
 BeuoWAyC6ofssbEZk7e4ta9+AeHM7c01En12167Wep/rgLcEaB+ohMmcUi8Y1+AHOXm1nBq1OLc
 5tzfaodGkBlYKn7SE6sleRjZx7tiDlskGk3tVA+njxFYrJXG8zubSseVZH4yKrWOZjazP0JZgTc
 xF3cIfuovzBjPjv9M9QfIbGdcHDnzT3OBRba3rTNBwnsuCE7nnWY9M+itSACjVuh2IBaMjqG/VA
 0tAWPI+V6fNJy+WOq/O3a+i22DAXvKO0p/tTg2k1rr6PdTI4/KTQtpM45LjEj1SgK2b96pFCxTs
 tGNcXOOTVKQTdAqnTRw==
X-Proofpoint-ORIG-GUID: eb41MgTgTqGX2oSbxXHPoDNekq9dtmbv
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX9RarMQw3of/8
 NJieugXvTQlwRTtsxWniNx+w57mGFvGMg94w8jvuLeCXCkDGauURwgzAiqpU2Du0onogjDyIPVG
 eNLG+2OlaCdK/+QyfRGZwjz1lvWypnU=
X-Proofpoint-GUID: eb41MgTgTqGX2oSbxXHPoDNekq9dtmbv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070059

sg_nents_for_len() returns -EINVAL if the supplied scatterlist is
shorter than the requested length.

Add explicit checks after each sg_nents_for_len() call in DTHEv2 AES
driver.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 83d964e884086..0447144b77ffe 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -354,6 +354,11 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	u32 aes_irqenable_val = readl_relaxed(aes_base_reg + DTHE_P_AES_IRQENABLE);
 	u32 aes_sysconfig_val = readl_relaxed(aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
+	if (src_nents < 0 || dst_nents < 0) {
+		ret = -EINVAL;
+		goto aes_inval_nent_err;
+	}
+
 	aes_sysconfig_val |= DTHE_AES_SYSCONFIG_DMA_DATA_IN_OUT_EN;
 	writel_relaxed(aes_sysconfig_val, aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
@@ -512,6 +517,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (ret == -ENOMEM)
 		ret = dthe_aes_do_fallback(req);
 
+aes_inval_nent_err:
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
-- 
2.34.1

