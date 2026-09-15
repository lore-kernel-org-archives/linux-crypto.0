Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3684963D1;
	Tue, 15 Sep 2026 09:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466208; cv=fail; b=Zw48pC/SSGiiPxBqvO7Iz7yt/e4pQT1s0Jq9NdAcz+EkI+S0hriV17BnRNtUTksbz/ycVendYxi7oyK3QM3nGhx6a5GyEDLkkuufShLDBGaIz16DKazOCENvX7k0a5M7ngfYOQd0jlSASXskCJxhZ4rDAGIRyOiFTxqlzc9T38U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466208; c=relaxed/simple;
	bh=oWMtxN1/gD2kQoX7CeePf7DmmmtGpiRB0m/PrSh3XM8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=RrvpWW4h9XL2XkfVyhIL+HK+v04A8HEVzRvxmQaJHqiptduiQg3AnxrQtB4S1dBTTVonJ/OlJVN7sz3SuYM5Eid9dY0tRg4bY1svg4GCLtUIV8hamzViMgNKdF/AFt2KPtV2BX1NkSHYV4vvzOxUQ66n/sNm8n/WSIaTsMahAjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=PjTa166V; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=QO1pyqOO; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="PjTa166V";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="QO1pyqOO"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68F9er543889296;
	Tue, 15 Sep 2026 04:56:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=ZP2XJY9k7f0ffWq7FVpHtK+X9lyZQYEKpZaFoJs0o
	PI=; b=PjTa166V7/4Y0QdcJO3RoFr+jaDpzOXCJCnYCQ8Ghn0A4rQq2oc4AM8Gv
	ROHn7nEDVqHvt+IpIcPQzApfoq9ZMf4X94nTq+lda/pbyvAQBOzTlgOg8V/zM4wO
	IpSAXPjm2ZIyPUNrt6ZY3ZMsVAvU2vO7oiZh+pW4HX83QjyXlsm3ycr84P3qYVqG
	6gaIqjMlKjCCQdUErvEinJkNqZgT7BimOUkOH/qxvGw1cy2Do5kPRcO+AjDTiKIn
	lMUL31fgPdK6MTM2PRt/+g392H0w9RSJ+1Im3Hc75JJ+yarNCePXaDipDMrH+YX0
	4h6u3lGHL1+MieRNBSmlvRpMVBELA==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010043.outbound.protection.outlook.com [52.101.85.43])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gppxsm9hc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:41 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e0Ne+CUAy8sxUKzzE7Jwchiys8rY/rHQ/Ll2DZRUy7bbpHNmIiEruZJph0rxI2vkTv6iMixiIdSehP+GDOcNH/OLB0Yoc4tcR5au5xN1Iyf9LS+S9xH7SOGJU0SjqzLfgfu+9QwBFH8YgVGO76YRjENTgknFuwSZGbiBspavJjEN7YphRDMI+fkcwhzqLJlGCuuXWcvt1n9YJ4MvIbZqlZIrLXTvl2Nh/+Vv6VJQoLP4vAl3hWeHefQQWN8NPrJjH2XndX4ZPPJrV2Z1EpNYFnXr66dV2/PGOHABDWHomFOLG8PvolYv7WLY1tKP9M/Q+xy2YEWjyz327fR/sn1YMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZP2XJY9k7f0ffWq7FVpHtK+X9lyZQYEKpZaFoJs0oPI=;
 b=xBPYW8DzMwQtD1/kRsaCcohlmAPRgLhdNo5IHzO+LppkoPCvPiBl8qOmrIUkW+hzWSYRaIsSKfNacO6tsoqRmVEuxcd464gFCltvcD2udCO440RxFtrZvQ3MHgdTqmvYaQas0BNENPGqTITlfo7M9tAywDgxIuh3aD1TNMEH8HrZjmEFoYxn34PN3mcPEQPEE1LgL31xomDIs7GQ+hUOO46CF+2eLqJBI4E+3ZKUEbEVWwK7ozwPuEuxs8oHIomWoHGWxOHAbaBPnhRsfA43rqJm5MZn8sDp9hyvjqeuSwQToOzHolr+E3BNKCMv4NCWOquZN1meVW5tGj9+gu8dLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZP2XJY9k7f0ffWq7FVpHtK+X9lyZQYEKpZaFoJs0oPI=;
 b=QO1pyqOO3+02OezGtZuBCi5VLKS9AYsAG2k6u8zcpKe+TwT7CcQrBpHe7XzqkipBftf2c6LkUdjLg+ILZAmKjbyi3qqIgynaREFnLeu4aLy0ZN3tMfz2YbsaKNoKaKQc9yqGRAfcPN55RoYnhuWnbVZfPcWkqX/0dcJmWhNmgWs=
Received: from BN9PR03CA0239.namprd03.prod.outlook.com (2603:10b6:408:f8::34)
 by MW5PR10MB5666.namprd10.prod.outlook.com (2603:10b6:303:19b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Tue, 15 Sep
 2026 09:56:35 +0000
Received: from BN2PEPF0000449F.namprd02.prod.outlook.com
 (2603:10b6:408:f8:cafe::e) by BN9PR03CA0239.outlook.office365.com
 (2603:10b6:408:f8::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 09:56:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN2PEPF0000449F.mail.protection.outlook.com (10.167.243.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:34 +0000
Received: from DLEE213.ent.ti.com (157.170.170.116) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:17 -0500
Received: from DLEE212.ent.ti.com (157.170.170.114) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:17 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:17 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB893000901;
	Tue, 15 Sep 2026 04:56:14 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:25 +0530
Subject: [PATCH 19/30] crypto: sa2ul - generate dynamic metadata length
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-19-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=4700;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=oWMtxN1/gD2kQoX7CeePf7DmmmtGpiRB0m/PrSh3XM8=;
 b=B9spH3iPZoT1hUuYLardGG53dbrLWlCYcOLYdkBQ+t/HZW9xPePfcyo8ivh/JZ93+TotQftTN
 U9vJtfA7q1iCO+Bseop7HjDgIxkBXcRl5oCHYAtG4dN1+Nbn7uPidM6
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449F:EE_|MW5PR10MB5666:EE_
X-MS-Office365-Filtering-Correlation-Id: 726db987-cfe4-4ad4-2608-08df130fa08b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|82310400026|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	O4duBdsbgXzNhzghtMtPQGbTQw9hVIMWwehYTtxKBT4CDyGsOMNmHBftWog316NsAduLaw4Y0YWl1aXmsUimUlIhMTkSi+6HMSTZOHcCi6anFpr0zaB46CU2lQybanrH+BQ0gTFr2MXnh5QKOvr1pgk+K4NNHN/RQmuXLs0GPyXPMGnnFiPMs4Mycz+KF/xLTTYgFE79ByqaNjN7VaFgf1LhlMsGEIn1/DbgrKWzLtI/2KaDGMSTQEqq+NFbEG0vCxcK83LUiVQi9VEo3P4Hq/eNx+MJ3k6YLRtE96D7n0AQObREZ+9HQ62iXQhVZFfR768yxlIeFdRO32VgHhImuDmlF+uesabNYsT5zXd4YGbKZ3l6AhG+omY/SBgMyDbXX8R8bTHO44w21t88E24AjHyjKAerNvzBLhvIHAke40mtBFmClctWpmj2kydCGOOuDmUpS4Vg8c2+gZuouSk6pkwjc25w4m4ogvk9PIW9wdb6fWlelCc6RYX4goo2pWF17/zdaxKBeC8WFokmXwYuErl37pHbBikJmbmQWoyjEQcSkmdN4BoIIwQFKMmaw8BrdxtIy3BewtpGzfkHjgseAWrcZ1pkqqxoUUi7I5xBppzlH+c2ECjhPGvCuZYRzuv190eZNbIVxsrnndNMua6hN7mPZub8a/jOTMEdqjhrtsDWnqCTASBpW5iSkCJUsdI+
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(82310400026)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oJYZ3IMGw4TwFZPUq8EYmrPcQJcHM3LHqKzRQQ1oVzebgYtUr9PdBtxsbbnEyFbYaYQFqBs+85vBvupThz9Rxx7w/kB0zYcFEPRdN4PF0Mb6rKE+qabUzDCyzaKGNfXPZX4TKqMCvV1Foxo08vki6+Jnubo2re2R8GOCugiF1uqcmDr3cAfKzLYXCWM8qQW6iBhEupuVJ5Rcmi/zofVeijjl18RLPUfvusA0bnFmyeYKBkrI8QTCOBOdfpKVcqqvDpIy3/XRM7MBjj9jCt5MwZE7pbbl9CH4aVlpoZlPiqc2nerSj1w4B8n5YPm0k1niuKzqmEyCRxzsNgp3FOYPPjk1xyz3Ugbatqm2opL0sxV6/izLIV9wCDrl+PKo8MlZdNnU79lQNfzIYPyBRj5+DasNzQZuKQHiN+O9HwyqbS2mqTUGsxsYcEuyy8K3Zcmq
X-Exchange-RoutingPolicyChecked:
	CoUR3ohYfYNdjVSsR6VGIRlPn9J+6eSJ77r44rWOWZp3gmLq+FyUF3huGXp03qQbxfCgTaCq5YHSPT4EPrzsJI39/cZRHw0ZjgR3ZnBPmM2pqk9o7zdCy2NztrZHVjKjTXXM1gL6s+RSjCJ9Oq680fnhhM1nte2aq/Wn8zjQm2ZIevDAWopAqJph0G75j5isc5DUTSY98k/AhXXI8tHv7xgG6Ypui6P5+C940lc6UUyRYbcdGsgxsk5BPUhYNZe+PDa/jXmop0sUEHdLpaKGsPzuvPkJJihzI8wBzMhT1ycfgDT0GbKgAUrmWwt05OrhPwYmcTzmw/IP0ro28+MenQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:34.7421
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 726db987-cfe4-4ad4-2608-08df130fa08b
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5666
X-Proofpoint-GUID: dBdmXqtRRpU8G3qoS6uJ4zBDV4SgHqnG
X-Proofpoint-ORIG-GUID: dBdmXqtRRpU8G3qoS6uJ4zBDV4SgHqnG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX2tseZUvxnnUF
 4kxXEr4PcJWKFzu9ezKtj4xr4cw7IWZfNNqwNW55dFtN2xfugoyukWQz6NAh86UOMUUGuoFsIy8
 Qhy4kOICF948IyDur9rUx5XambukhghC8xMwuIX99APDCqOABrn0svkSiiCX4ZcT+k07k4hsyp7
 s49W190nQkWy3mf7zFbQAxiwKABYp5TjS62Y7GxzLRUzecAvxzgmX0xpr13UhTGMrYxLMikxviJ
 H0TOnvwIVMPc8wHHGGru8+PN04NYWpBnTcOs4FJFIr6QnCb+/j58UVWvtMqe3NXwhfXg2un+r45
 xkkany44vx1N6PfPgdypslmhx5BpgPAsTjOykFBJftVaMrVidKacdB+c3PW2+l+VQAvCKpsQUAw
 LcORDW0eBKO9fznekjPNm1s+IW9f1xgC94ImA5EfrFoKSjJGdDAkUdujW/tKn64WzDM7p+mcLI6
 Anobr85MurVDfVpFtvg==
X-Authority-Analysis: v=2.4 cv=bYP+w+PB c=1 sm=1 tr=0 ts=6aa9165a cx=c_pps
 a=630MGKGvePsHimlcG8SYgw==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8
 a=iV7YQO2jEIXJtVvt9CkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX8oPYgCxP8MOR
 5VDv9tyj2avq+5zq/Oo1yzGCsoGL29tce5A/rU+lTr4NoxbwMrA503nPWpv11RzD73wQb+EwvaC
 1AopSO8nEwprumHHNbXC240Oy5R8hHg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

Calculate metadata length dynamically based on actual algorithm
requirements instead of using a fixed value and remove the code that is
not in the spec and not required to be passed to sa2ul.

Aligns the index as well after the removal of those extra bytes.

Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 25 +++++++------------------
 drivers/crypto/sa2ul.h | 23 +----------------------
 2 files changed, 8 insertions(+), 40 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index cc9f2881efda..a60b968c21f3 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -956,7 +956,7 @@ static int sa_3des_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key,
 
 	ad.mci_enc = mci_cbc_3des_enc_array;
 	ad.mci_dec = mci_cbc_3des_dec_array;
-	ad.iv_idx = 6;
+	ad.iv_idx = 4;
 	ad.iv_out_size = 8;
 
 	return sa_cipher_setkey(tfm, key, keylen, &ad);
@@ -1028,7 +1028,7 @@ static void sa_aes_dma_in_callback(void *data)
 	skcipher_request_complete(req, 0);
 }
 
-static void
+static int
 sa_prepare_tx_desc(u32 *mdptr, u32 pslen, u32 *psdata, u32 epiblen, u32 *epib)
 {
 	u32 *out, *in;
@@ -1041,6 +1041,8 @@ sa_prepare_tx_desc(u32 *mdptr, u32 pslen, u32 *psdata, u32 epiblen, u32 *epib)
 	for (out = &mdptr[5], in = psdata, i = 0;
 	     i < pslen / sizeof(u32); i++)
 		*out++ = *in++;
+
+	return epiblen + sizeof(u32) + pslen;
 }
 
 static int sa_run(struct sa_req *req)
@@ -1097,16 +1099,6 @@ static int sa_run(struct sa_req *req)
 
 	sa_update_cmdl(req, cmdl, &sa_ctx->cmdl_upd_info);
 
-	if (req->type != CRYPTO_ALG_TYPE_AHASH) {
-		if (req->enc)
-			req->type |=
-				(SA_REQ_SUBTYPE_ENC << SA_REQ_SUBTYPE_SHIFT);
-		else
-			req->type |=
-				(SA_REQ_SUBTYPE_DEC << SA_REQ_SUBTYPE_SHIFT);
-	}
-
-	cmdl[sa_ctx->cmdl_size / sizeof(u32)] = req->type;
 
 	/*
 	 * Map the packets, first we check if the data fits into a single
@@ -1239,9 +1231,9 @@ static int sa_run(struct sa_req *req)
 	 */
 	mdptr = (u32 *)dmaengine_desc_get_metadata_ptr(tx_out, &pl, &ml);
 
-	sa_prepare_tx_desc(mdptr, (sa_ctx->cmdl_size + (SA_PSDATA_CTX_WORDS *
-				   sizeof(u32))), cmdl, sizeof(sa_ctx->epib),
-			   sa_ctx->epib);
+	req->mdata_size = sa_prepare_tx_desc(mdptr, sa_ctx->cmdl_size,
+					     cmdl, sizeof(sa_ctx->epib),
+					     sa_ctx->epib);
 
 	dmaengine_desc_set_metadata_len(tx_out, req->mdata_size);
 
@@ -1298,7 +1290,6 @@ static int sa_cipher_run(struct skcipher_request *req, u8 *iv, int enc)
 	sa_req.type = CRYPTO_ALG_TYPE_SKCIPHER;
 	sa_req.enc = enc;
 	sa_req.callback = sa_aes_dma_in_callback;
-	sa_req.mdata_size = 44;
 	sa_req.base = &req->base;
 	sa_req.ctx = ctx;
 
@@ -1398,7 +1389,6 @@ static int sa_sha_run(struct ahash_request *req)
 	sa_req.enc = true;
 	sa_req.type = CRYPTO_ALG_TYPE_AHASH;
 	sa_req.callback = sa_sha_dma_in_callback;
-	sa_req.mdata_size = 28;
 	sa_req.ctx = ctx;
 	sa_req.base = &req->base;
 
@@ -1862,7 +1852,6 @@ static int sa_aead_run(struct aead_request *req, u8 *iv, int enc)
 	sa_req.type = CRYPTO_ALG_TYPE_AEAD;
 	sa_req.enc = enc;
 	sa_req.callback = sa_aead_dma_in_callback;
-	sa_req.mdata_size = 52;
 	sa_req.base = &req->base;
 	sa_req.ctx = ctx;
 	sa_req.src = req->src;
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 04669bf7fcb5..fbea98981f10 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -31,22 +31,9 @@ struct sa_tfm_ctx;
 #define SA_EEC_CPPI_PORT_IN_EN		0x00000200
 #define SA_EEC_CPPI_PORT_OUT_EN		0x00000800
 
-/*
- * Encoding used to identify the typo of crypto operation
- * performed on the packet when the packet is returned
- * by SA
- */
-#define SA_REQ_SUBTYPE_ENC	0x0001
-#define SA_REQ_SUBTYPE_DEC	0x0002
-#define SA_REQ_SUBTYPE_SHIFT	16
-#define SA_REQ_SUBTYPE_MASK	0xffff
-
 /* Number of 32 bit words in EPIB  */
 #define SA_DMA_NUM_EPIB_WORDS   4
 
-/* Number of 32 bit words in PS data  */
-#define SA_DMA_NUM_PS_WORDS     16
-
 /*
  * Maximum number of simultaeneous security contexts
  * supported by the driver
@@ -219,16 +206,8 @@ struct sa_cmdl_upd_info {
 	struct sa_cmdl_param_info	auth_offset;
 };
 
-/*
- * Number of 32bit words appended after the command label
- * in PSDATA to identify the crypto request context.
- * word-0: Request type
- * word-1: pointer to request
- */
-#define SA_PSDATA_CTX_WORDS 4
-
 /* Maximum size of Command label in 32 words */
-#define SA_MAX_CMDL_WORDS (SA_DMA_NUM_PS_WORDS - SA_PSDATA_CTX_WORDS)
+#define SA_MAX_CMDL_WORDS 24
 
 /**
  * struct sa_ctx_info: SA context information

-- 
2.43.0

