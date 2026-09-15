Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F94F489880;
	Tue, 15 Sep 2026 09:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466200; cv=fail; b=RlNXWXvvhuFjBx3rgBgyHy6HSMstq8rMGNXZIlq9TEBr/xaxk5G1btvj6RdfNKUgSddBtJ1QM9bueB5eVzwH/qRF9WpJkEuosmBVss7UkiT8lFB9cc2oWx/AlvDaqUSpNlT3Rv9Oxlf4PwSzJkP4pRrnI+lyojMiLAp8OwZys4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466200; c=relaxed/simple;
	bh=ZgQNzFQwy5Bm25q7i4u6MuBiNs5zBjwT+dWYrGEw6UE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=m3+UIPeTxJmCM7+kjgvuI5+yzi1iVg/m4JpFV0JFvxWpJymRsfrW+02tvGFS5G+qqidNsS0RPj0n9Xka0uqwtfkyPG41DREiT8tnRz5NWolgq47Dqx9XDGy6jHnndaKIa7TFobrb5FMlCVEf5vKRxv5nAzhF+W9IFhPH0C76wro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=kW/Mcz3+; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=G9QZbU83; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="kW/Mcz3+";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="G9QZbU83"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9fCNB3811029;
	Tue, 15 Sep 2026 04:56:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=ILDOmEwf1i0BmaeYTLLHUOIT4vwwkilIwjVe7qP2k
	JY=; b=kW/Mcz3+/eNYvSBug5Y8DDt9rpcn4QjGyuvRuzk0X0rvSKkukUFgpxWiL
	9L6OEmGXn2Y/Dg4td3urNdl8Llyu7cV6xor8JFs6jMcGUjK12y1QM+CBouEQQDNp
	oX3WnEv+KqyZJyXJovpaHfGg0xTZV8bYY891+rpVSo/K3be4xeYWmrpCL/rdVug+
	ucRemqSiiF97wGKWZPxs+gX0jxGLzJ7WoKu/q/3QZsYB2KwKUHtImNCXAfOKvAMf
	wGwwIb5+Tt+eKICutpYKKm32s0HWtiwtaVicmXN7XPWFv6Oii4isnMjwbeT4cgdX
	tirbir6sx/UoHDmnXmSHvLbzcF6eQ==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012034.outbound.protection.outlook.com [52.101.48.34])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gq362r9xd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:32 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mmG6uJfM4+YHfZ7R+kf0CyCZl/pQCTuUYCk2ux5XbXr6pquFSSBMgBFrWXMNPUNzZ1P5OpmHgHDBTxOyA74vXf4+EdbHZ4UO1BXpHJDH5CvIRKq+NCtIrfrZ4Lc1kiTdK9sNosZNvNSpPQO0+hxMQ+lU0htAX5tlDazhJzDT5fVVsd7dlrlq1U39DGeJYYR4KvoI2VLTLXldWH6WECjCHC1gKYfjE9QBLgbc1oV/bVChw2oPPb3QRQ9w27XYLlkI6wzamwdskvQrD9aKIvlF/T+X17Tqt3SWN8wlXkjPDg8euYz3hn5PF1uUjMogopwcpBsBT1bQBg92+yg56Phtnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ILDOmEwf1i0BmaeYTLLHUOIT4vwwkilIwjVe7qP2kJY=;
 b=eRCEbE4R38XkosCHnuGaDem1U8rjC1iEnpDsP4lk80c2GGyMjIgxuFPAnezUUigcJb4I6BBzABKZg9Od7yTdKiH5GUtnmaT+Wk2waEWGuae80W5d7MIVZ8eH9ZgF7pXG8L+YEmrH4TlZrSvzRkUw67bi7Txk4XAi5uJtajunSbYcZAuDisQu+b7uB2rM+HN9IUXBFMc6zNN/eptJXR/JjBg2NinnRoe4Ti84knAui7VyyfKk4nkgyqjT1ggJ27yTVCanr7qMzddlMPcU3IvekFcXrc2PM+X69RuHl0yBMqwABINzYH/tObVr3WzvWwtgNFVE8iZqaN8k1fgdd77fEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILDOmEwf1i0BmaeYTLLHUOIT4vwwkilIwjVe7qP2kJY=;
 b=G9QZbU83xV2C8c/6v49GxemFSf8GnrIBc457lTjRtW894b8cmiYTn9TNxKFkoFOoUHJEi06/sxPSZeUekZHxW4ez5FyYijLzyx0u/K2jPJNnaAA8gbL5LpgyWtD825Jjl7f/yAtTOhISzys+BCi3TooUBcfF0PIWhTh3/v2y75Y=
Received: from CH2PR12CA0008.namprd12.prod.outlook.com (2603:10b6:610:57::18)
 by SN7PR10MB6449.namprd10.prod.outlook.com (2603:10b6:806:2a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.8; Tue, 15 Sep
 2026 09:56:30 +0000
Received: from CH2PEPF0000013D.namprd02.prod.outlook.com
 (2603:10b6:610:57:cafe::61) by CH2PR12CA0008.outlook.office365.com
 (2603:10b6:610:57::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 09:56:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CH2PEPF0000013D.mail.protection.outlook.com (10.167.244.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:28 +0000
Received: from DFLE210.ent.ti.com (10.64.6.68) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:58 -0500
Received: from DFLE202.ent.ti.com (10.64.6.60) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:58 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:55:58 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB833000901;
	Tue, 15 Sep 2026 04:55:55 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:19 +0530
Subject: [PATCH 13/30] crypto: sa2ul - fix struct documentation for
 match_data
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-13-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=778;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=ZgQNzFQwy5Bm25q7i4u6MuBiNs5zBjwT+dWYrGEw6UE=;
 b=JXGmy3xc3BatJPU3EseJFpZ4deaQOIPxpkHFWssMDzKt7sx8CKftY4V/6PQPc24La6QKntcbb
 mVuIlTOuLEjAC30Rr+59btHUFooU+8L89tpfuifNQ/MAyulu5c1XBR2
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013D:EE_|SN7PR10MB6449:EE_
X-MS-Office365-Filtering-Correlation-Id: 28fc820d-8616-407d-dcea-08df130f9ce4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|36860700016|1800799024|82310400026|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/xOLXF5PVLQ6wwCgokfMSUrNxLSa3faBNpWu7oUaXf6cuf0R3SvuLTMK0zK6iLoczOChE0BnNERO+kzQodAikwVkpYvWifdDylMk6jmRRt/j0ajhXA9H0wXivkkMCTP5STYo/MlzYmdZcEWhiEkL/cHY3oJSoTQcqUHq7v4Q0eQk8Ujz/00Yf/7Y1e+xZb6/cNRIolfX1opSktwjylrygQ0tXKHP+ALx+UbVXFjH86ydO6jYoGs/FKWgBRx17FZRR3Toi9aWcwxrenhDc68h4Z8Cbj6nMB2jhjjt/wkDKaRoJEUXJhNeCpNTqoXJc9TsbczIKedi4gXYZGHgGWWTAV5Xv16VNKwpsl/LMCRyo6VekOyhEN1PqDDomFLgU+sPvAvBl2HT9//Na+EPeJ5/XxSTvTl9CbF2UHwsJpJwmWBIXBby+5oixOatAYeQQR2H5rYcgGQtMQxLRZzK4wUgIdQmtommwciO/bOL+fo9DJGTuDDnPTjtOKpB8LVTf5g5UgKRunStwXKq55dJSvmGT3tUBehpmPtCiIa/Csp33T8kBA6ZHoNQfDfs+F3DugwvoWLiMAz8mBPotFr9quSCu1WdZLkb2PDscBNZY4G5WCosFIP2l77AyMtwE2qgzIcWrVMvJqJLkkZn8lU/OfpAffTCf6X1CPIi6fvjM1xDgH6+qwzmd12NMj6MRo7oUM/nUOomcVi8dCg0JiByInA8hA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(23010399003)(36860700016)(1800799024)(82310400026)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	59LL6thcvPhxUqCcSpHwT40+yaFlQ1ZeJwA4Zucktta7lpdRswsb86OUBlmqpiqrOvxgu+9ROZTwKi9hpLTc/4MiNsrFaBNmfKwjn/HufUjxo5U+E0+YJw7NvbM0mDuDfMiuEb7boic7gOB2oRyEKDf9opNpMT4wsXgdIop5FQxUiMY74435My2p+8FdM+ntG3enU8VQx2SOTm0sn9jC5iA4Hn6416JV59vcFZSuFwHacDFhxe4z+oibUM8EwC/n55IzEYr7w/vPwXDefMq2Ff38BzRIExPj5sfyZn8MOYO31uI745PLolB2KC6TjW4TNwK6/8FFCp6wLW+/iRRaNTIlOol0WcFPxrFVq7SCjKYN3Y/cglDuOXGsbJ6LEZoRNfc0bX3ESDPLJU+5DEvbEHAAxc38d7T7OCrJM/udKqHbDjBG6RvQk+vvsUXypEIt
X-Exchange-RoutingPolicyChecked:
	UBn2W5w+RkFRAw/Pe2ZW/PNPO53+5Dx+tu3lj2KNVVATJec3lNbIyAqgLQROnXBr5BiyFYAoERLUUedznET/yR1Y91jERvigWoPisG4TmWsCtXAmLdWQG8/wRNCjMj9Tc+eO3iGBEaNgR8wnglph6c3faTyvO4GgrXBuBMOHfqTLtpJA+SYxD7G9URrvkArxXvrFDcbHth2OCjunP6/M8jECBsvEI8PHLWE6a98mP5c5T1Pgk4cMvd3KGNTlRjpIC4srPGVfINB9Re9mq+PNvMv80tFI3ZRYZcNc6oWF4qigaZ8F7h+XC/53/qbkoBqzlhn2T4IOl5YjVZkXRUxd5g==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:28.6701
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28fc820d-8616-407d-dcea-08df130f9ce4
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6449
X-Authority-Analysis: v=2.4 cv=P9yvFSAu c=1 sm=1 tr=0 ts=6aa91650 cx=c_pps
 a=Vk4XJBOTeTkE7YKYzYQsKA==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=SBzYsTgxBfknYJ6lt_UA:9
 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
X-Proofpoint-GUID: 0ib1Fv18guMZ2RZQ7V9bGL-gjX5-oyOS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX25IsLbUwM6zv
 zIOTRDUO2spgqNCuNNhwvQHaIc9+On8DAQniu4CUH689cYSyQihs7Kf0+BER9JcbGJKomfhYve0
 v/Eww7h2sq4dpfNSUZUB+kZuhrfIIbm6luPHVgdll9ZZloh9KA7YbgAARpG8bWXMKMpSEaXE1ms
 W670Zip4DXCtFx0z4QHxirr/tO6MfU2PrYfG5+DEV15RXI/+556QpPWIRU2ORzIFqUUikBmN385
 QL6raB2mcxVa0MJ2HK17RSIdB0XA1cUrwh9zgikXMKffiYWrqjsVu5FihEzJXVMRHVtgij6Lv6E
 aDKbu7Ai+hj9IL1uDJViHbk9R77RGHdh29vKRfPDmXMn9Iou72JXo5Iy1cKN0UsDLxJJWJmJjBJ
 n2miHoy/CrWChVh9s4qUqUKeR9Gmgwc6r94/TrTzIcbiRwHEZpKWjk9UsfXxvEsA7H+wFBEAMRk
 zuknVLqVFv/0kq1XaAQ==
X-Proofpoint-ORIG-GUID: 0ib1Fv18guMZ2RZQ7V9bGL-gjX5-oyOS
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX6585Om0XtJZg
 heK+hgGKeOxROEcieSyZS0zxRpG5sRShsA1Q3R+By5VdYAfTl34pGhz1JsY40YeKRvmmT1kli+R
 yTgHPkQYtJW3C6QILYWppT+4ji+v2Y8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150143

Update structure name in documentation comment from sa_of_data
to sa_match_data to match the actual structure definition.

Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 7c0ca2ca966e..04669bf7fcb5 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -162,7 +162,7 @@ struct sa_match_data;
 
 /**
  * struct sa_crypto_data - Crypto driver instance data
- * @soc_data: Pointer to SoC specific data
+ * @match_data: Pointer to match data
  * @pdev: Platform device pointer
  * @sc_pool: security context pool
  * @dev: Device pointer

-- 
2.43.0

