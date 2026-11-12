Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471201;
	b=4flMSU+VXx9lNJsxNFt9x87+sjQcmrPb6YsY7cDoBH9Aa2Y2PxIQgQO+LTszsIUhR85D
	 w3zyWIbD1K1aaDvzFT/py9VkJKrv9STZrqD8bMVcoWlKcY4wXOpDS1QLqRgGgumv8oPD5
	 5orewWuZ9l2YcaT0dGa8H14ovufTjYC4Q9obOWYFqExv4SjUwcpTEdY50vuX3vg7PeYr8
	 3mN8Wcfuu9caTtEueBXlFkyZoSXcXhsqj3gOq7o9AxuGwrhSNzSoi85WDAEdnqBnvKV+o
	 8l4++3gQi+PHjrXPjvc7YiN3ebnahkrIWKPbPX7CZPutLBCgMeqQ/H1VgEms4f/KHlg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471201;
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
	bh=/V6IPqufulCuxv1/+VYGEm68l3b1Qk2hd3m2V+/D0Ao=;
	b=RnH9wRmq5ceNIMW2DjuYOmbR47YR2Pe1v4fUAXJ2t5ulg8AVmyz+hwmrik5UyvdFRHPy
	 cvxJhTPBIev7LF2h0vUJzIWg1JndkKzQ0MwISQeH5kFJ9/nY2KDASZc+eXvQKncn8klrf
	 qddZqeR+xAWs3aREH1Ld189Tb+2eiTeHsk/+kw3FIhuk7rzl93coZTAzIzUgg8Q+MbFMZ
	 HkqV7yVcXmB0G/+M5vdhqUeuGqUGyXxfHsY1WQ2crtQXaL1tCf7YV4sm3mMOF8ygTdDNr
	 qEQTHBKXCBjQK6d/qIF2jvSKp6wtl08nhL1NjvuIcvn72up5ozyH1OJ6T1P739PpyHg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=fjYG4bYX;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=BpptIKmT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459B160A6F6B;
	Thu, 12 Nov 2026 08:13:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 459B160A6F6B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=fjYG4bYX;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=BpptIKmT
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC7guUL2308431;
	Thu, 12 Nov 2026 02:13:17 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=/V6IPqufulCuxv1/+VYGEm68l3b1Qk2hd3m2V+/D0
	Ao=; b=fjYG4bYX+aJg9C1CU17VbJExjvYKuuZ5bbNLeL31vHoejXPy0/0CnpHdx
	d85tlU8aHnXAFDleH2qQtR614zKsXoZPr2AkMIAgBZI4AQ/kMoWRXDS/5Xvwowzf
	X7sQ83gfPxa/nVnXN4jYfazd35WSh7myCX7f6+ImTZOZJeLnKKUfVZ3+38GRD0YB
	XEX/NI5y0gaNJwmNCosPXI4YJoRUqKCJMBEmZA7SfzeRbA9VqIj60xg5Afc7hDrD
	fjD3KdlwFdzGc0VUq97WhhMGFHcsdSGUX7LB7zmCPKUoo/z0gAFB0Xhghp5PfoBV
	Fyty1mIPLp8GQrYrx1MLmiIuTR79w==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013054.outbound.protection.outlook.com [40.93.196.54])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hvvr6vffe-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 02:13:17 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dVFDepLJo2+VrQkbNYpCzKBZY/yshv1LY/zAUknv98Q+MZHJOv4JQOKKxKO1fC8wRKMw44fjO1AUNpf9PECnx0NPCIjfG66inQpm38k6wR4JkKg54yCzD5yV6YXz4nNyt8Kpxhq79a+b7vPV4hax29/uK4ASl8naQBWYB0tvHBFa5znOZEmc6RYdNmm+KFsOucnQkX+8uxlpVBuEuRC0yBAVhRYxLhb2u04dHiRsOi2KuRO8VUHqYdFAAhTF4xj1I+RVr+arzHYR3SyYrBaxOijOJKRZZyZPdhr6Aflmtxqkzav2uhownPpLIQHeF2G8KQMpHMzXOinSLjxsMDEE3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/V6IPqufulCuxv1/+VYGEm68l3b1Qk2hd3m2V+/D0Ao=;
 b=fH/l/fZp0jtss25VFP1jc2DMYURO4Rd46JL1t+98H/bLETQMM6IUJFmU/WYiBFVfwL05JiqgiKzINd3RO5M3qU/DNLofNr4cfBZODqKg8+LlcFHO3fpT+YCwErWJl5IDPW/Qs5b0zmdiFOIkglZVBLViUR2cDzxHbjLALBEcJRBmWxYmahg9/ElpbbkE4e60OOtNuC4ItyI6ktXkWhKTWjzYrSFLIrW0B0eQjzWDyfn7XImHHN8Way3nPWIj3M2X/RbO3zmAugE3hzYOni4TR1im66b6YxWLU2xopWBL/GrYV9DmFO3G0K7X6dOlu7Q5hCIG4C7wloaaAn1PE1NN1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/V6IPqufulCuxv1/+VYGEm68l3b1Qk2hd3m2V+/D0Ao=;
 b=BpptIKmT8PkZoE/0O9bVkNlGt0/WYfcPjX+n4cT+AkjLGFXSZbPGN7MvRtEbyVXfG1wWG9AYAEuf82dsJFc4vu7qHdufSYcyU4Qg0ZEgq9RB2xHcBtWa8J6p0bOcLTjdZeGrA0tE8Dhui9n1S/CcFALGwVlv8l58tw12dQcuCSw=
Received: from CH0PR04CA0002.namprd04.prod.outlook.com (2603:10b6:610:76::7)
 by SJ0PR10MB6432.namprd10.prod.outlook.com (2603:10b6:a03:486::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Thu, 12 Nov
 2026 08:13:08 +0000
Received: from CH2PEPF000166C6.namprd04.prod.outlook.com
 (2603:10b6:610:76:cafe::30) by CH0PR04CA0002.outlook.office365.com
 (2603:10b6:610:76::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 12
 Nov 2026 08:13:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH2PEPF000166C6.mail.protection.outlook.com (10.167.244.233) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:13:06 +0000
Received: from DFLE212.ent.ti.com (10.64.6.70) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:31 -0600
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:31 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 12 Nov 2026 02:12:31 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6AC8CTs81455771;
	Thu, 12 Nov 2026 02:12:30 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v13 04/15] crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal
Date: Thu, 12 Nov 2026 13:41:52 +0530
Message-ID: <20261112081204.1146395-5-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166C6:EE_|SJ0PR10MB6432:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fb7d0f6-9a65-4f42-9bb3-08df4094c7e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|376014|82310400026|56012099006|261021123027099003|261021121427099003|261028144727099003|261026140227099003|261009223027099003|261022105027099003|261026121527099003|261102123227099003|22082099003|18002099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	q6ApP11PSwZ9Ud/c6Vzz3bIH8PSlXIm/IpWUlDzEZkJxeU1XfjBO3VdCnco/8ukCKcNZBGZ0dbcyojPUbxythNsbqDOxkDkLGGVe7OroaKKzpnIn4DfxiWBNXbmrOEnTTUVbFEITwb9YpbzFK7iWGdpgMnNuhrWXde/fmPIz+1xRSN4PP3M8w6U7uNJLwXV2l6Sv8KPkwxRPgXBUazh3P9/4P7szmCj+fclOszXZrB4lxGEY2kvatv3NGxu5qKCl3vl4u+tQMeuSkupzw7tha6O30ziqUWVqc1nQKjHL+40SQFfTpI6/nQ2GW/05xWOIpeuh1Cx6XV80K+Ap0RW+/WKgH2Gq2mKE5geVS0TN2kmnnv8QNNH2deePLC6aTxB/MxYuLpKQCjR4mfsVpk1M/NBD8PYCRYiYtREFo2kep31a9hh5ZuFmQlBvSvq46wf7kKDiQRESJaBZhNB351R0eK3layGzFuP3waOflC4eannFx7Wu6T/33B0wL8RLIRX8+EvMu2swPKAddKNfRdMF271sgWolufiPFgoShUSaJ2D4OV2UmgIlpGGHLz/tdYxaIDD+qj/LapCVmU+oB2pqYZVIMyItvtHjHryeATE1vv0N9IQiSYjciJqTGOg6e7NCwnm+6TN1K7HFn4lyXs2Uco8EZDOd2bdr2DOuAeS1ypvRYWfPOlC3p6QGPlThZ8a26yCmqd4DSYOOOxuteSvUBQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(376014)(82310400026)(56012099006)(261021123027099003)(261021121427099003)(261028144727099003)(261026140227099003)(261009223027099003)(261022105027099003)(261026121527099003)(261102123227099003)(22082099003)(18002099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pFi/udQ0/zNC9FMepB3D9uUuMn6hlk1VedYNxUBck/1DnU+KkP9MOU6fLjHNnAJx7CjFEQlcIkkWaTXh5h9rSmtj2l1ybmAletU9zzSOlVLr9CGRFnxgBAbDHL8Vw9kDe8mTXjBuu0SVM2PYnzEnZItKkhJ7V4fDF4JjQ60IeiRKxlmIyOtueEWvdzOTQ/WHNz5k81OVkIy0faKMed4GZIsFNnLwlfteK2f7glHIu8z/iy82dnfCIbss0bQOPuiB+sjDjdAvWlgK7fVDWUW/tFMbnHtCj250gh5sQ6yVGbCnaDX3OGsevhrJoU3o+/M72+udwkfin1IqXYE00NZmvvBEMxPMV/G4cA1lUyJmaasQI3VYAtOo2jaxY5zdv9naHvZQPNNZ3TFMfekW/8JeEbMRim+wcs8sTZQ0s/ftl9URN6bjX92n+/rnYnAtCVU7
X-Exchange-RoutingPolicyChecked:
	nG2MnbHYdPFsJra4bY9PjFgXYUzpx17guL68ENq93dfpFKSZiO0H4OziReVQs/geGXKow60lgC5CT7w3/p3+GOIF06guXoOEQwEkP64iM+h73RTXNH6REGw/x+zN2FSMFQ4HyzuTOgHNccpIK5cZgYb6c6kQAeUsiQLXf4wjfuqmbM+vJZI+mWi5FTlmaDO9MIq/ULMQIRAWBwC2wcPbRvltYHpm53Isjt5aIDFf1UdLT0wg0N6LVNsDL2116HXayDW0RtrRt60RKi8Llx5bqRnMx/BIUlcLxCnHr75tHGPqSn7bWvG52jzDmGHHrt6qHO63kXh1HuNrtiWM3ATgKQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:13:06.1884
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fb7d0f6-9a65-4f42-9bb3-08df4094c7e4
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166C6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6432
X-Proofpoint-ORIG-GUID: D2rb9UaiBNBduCrJIlfr5iZI9i84vdMb
X-Proofpoint-GUID: D2rb9UaiBNBduCrJIlfr5iZI9i84vdMb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX7VScvTef1CsS
 J4Os4Zwhrp+IoIqZyjFOtqbmZOCXKehV+c0W77O7EL1rGxMocEf6j1ka5N0Kft8lLShI857YrRD
 DlVYmXQ07h60uM6oAd1gjoA8sFHfbRL8EfTnc0idhjP7643sCsf05NtLUvqMOEojrkvXV2uvgTd
 08caC49ovFd6lnDqQRSreo2l2tSw8Z8rTQufaejxZ0Vm4xRGz6KsPldv6XU+AHZATkCeGSlgEqe
 KDBX46q4CAxSgwEeLITObJUy/YOa4YrIedimLQycd3d/iK1EG4jF+C2CwepWT4S2NDjfsxNb8Iy
 s2OWglRufaSC/GV7xC+XDh67YlW0xnSrsFtXupoWP/FaPfJ2oe9eAAbF1CiB3XwQDl71AwaPZwu
 L4FbFPuvJLdq0xQFLU3mdw0yjIV/G8+pYuyDXAwtQoLvIeD+x9odcqTZrpbWhA06Dh3oAVR8T+J
 +gSh4cBGM2PnANgP7Ew==
X-Authority-Analysis: v=2.4 cv=MpLHeGae c=1 sm=1 tr=0 ts=6af5751d cx=c_pps
 a=S/uo/C2bPHUhgLefKkPNaQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=LyTUazvdhpDvXpZ2q5YA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX9nh9oMOQIf6V
 6V2hMdOxIoPKMzIEFYPesfzdoO+EIsduPoRFj4WA6BWfOn0+sXbmWCe1ETccDYpsjeAcOzXErLx
 9txGx56qCqdqkorDCrNQJ1pVGeEiLdc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 impostorscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120032

Each *_init_tfm() caches a pointer to the per-instance struct dthe_data
in its transform context (ctx->dev_data), but never takes a reference on
it. If there are tfms in progress when dthe_remove() is called, the devm
allocated dev_data gets freed. Then ctx->dev_data will point to a memory
that has been freed.

Move dthe_data to req_ctx structs of algorithms, and store the device
pointer in tfm_ctx. Add a kref refcnt to struct dthe_data, which
maintains a count of number of requests enqueued in the crypto engine
queue which reference the dthe_data object.

On reaching zero, this counter triggers a completion which is waited on
in dthe_remove() before doing the driver teardown.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 80 +++++++++++++++++++++----------
 drivers/crypto/ti/dthev2-common.c | 53 ++++++++++++++++++--
 drivers/crypto/ti/dthev2-common.h | 52 ++++++++++++++++++--
 3 files changed, 152 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index dfb26be6d20ac..75361afa1b3f3 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -110,13 +110,13 @@ enum aes_ctrl_mode_masks {
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!ctx->dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
+	ctx->skcipher_fb = NULL;
 
 	return 0;
 }
@@ -124,20 +124,19 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!ctx->dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
-
 	ctx->skcipher_fb = crypto_alloc_sync_skcipher(alg_name, 0,
 						      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->skcipher_fb)) {
-		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
+		dev_err(ctx->dev, "fallback driver %s couldn't be loaded\n",
 			alg_name);
+		dthe_put_dev(ctx->dev);
 		return PTR_ERR(ctx->skcipher_fb);
 	}
 
@@ -148,7 +147,9 @@ static void dthe_cipher_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	crypto_free_sync_skcipher(ctx->skcipher_fb);
+	if (ctx->skcipher_fb)
+		crypto_free_sync_skcipher(ctx->skcipher_fb);
+	dthe_put_dev(ctx->dev);
 }
 
 static int dthe_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
@@ -225,7 +226,7 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 				  struct dthe_aes_req_ctx *rctx,
 				  u32 *iv_in)
 {
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
 	u32 ctrl_val = 0;
 
@@ -337,8 +338,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 {
 	struct skcipher_request *req = container_of(areq, struct skcipher_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int len = req->cryptlen;
 	struct scatterlist *src = req->src;
@@ -520,14 +521,17 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
+	dthe_put_drvdata(dev_data);
 	return 0;
 }
 
 static int dthe_aes_crypt(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
+	int ret;
 
 	/*
 	 * If data is not a multiple of AES_BLOCK_SIZE:
@@ -553,8 +557,18 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 		return 0;
 	}
 
+	dev_data = dthe_get_drvdata(ctx->dev);
+	if (!dev_data)
+		return -ENODEV;
+
+	rctx->dev_data = dev_data;
+
 	engine = dev_data->engine;
-	return crypto_transfer_skcipher_request_to_engine(engine, req);
+	ret = crypto_transfer_skcipher_request_to_engine(engine, req);
+	if (ret != -EINPROGRESS && ret != -EBUSY)
+		dthe_put_drvdata(dev_data);
+
+	return ret;
 }
 
 static int dthe_aes_encrypt(struct skcipher_request *req)
@@ -576,19 +590,18 @@ static int dthe_aes_decrypt(struct skcipher_request *req)
 static int dthe_aead_init_tfm(struct crypto_aead *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!ctx->dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
-
 	ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->aead_fb)) {
-		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
+		dev_err(ctx->dev, "fallback driver %s couldn't be loaded\n",
 			alg_name);
+		dthe_put_dev(ctx->dev);
 		return PTR_ERR(ctx->aead_fb);
 	}
 
@@ -600,6 +613,7 @@ static void dthe_aead_exit_tfm(struct crypto_aead *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_sync_aead(ctx->aead_fb);
+	dthe_put_dev(ctx->dev);
 }
 
 /**
@@ -711,9 +725,9 @@ static struct scatterlist *dthe_aead_prep_crypt(struct scatterlist *sg,
 	return crypt_sg;
 }
 
-static int dthe_aead_read_tag(struct dthe_tfm_ctx *ctx, u32 *tag)
+static int dthe_aead_read_tag(struct dthe_aes_req_ctx *rctx, u32 *tag)
 {
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
 	u32 val;
 	int ret;
@@ -734,11 +748,12 @@ static int dthe_aead_read_tag(struct dthe_tfm_ctx *ctx, u32 *tag)
 static int dthe_aead_enc_get_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
 	u32 tag[AES_BLOCK_WORDS];
 	int nents;
 	int ret;
 
-	ret = dthe_aead_read_tag(ctx, tag);
+	ret = dthe_aead_read_tag(rctx, tag);
 	if (ret)
 		return ret;
 
@@ -753,12 +768,13 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 static int dthe_aead_dec_verify_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
 	u32 tag_out[AES_BLOCK_WORDS];
 	u32 tag_in[AES_BLOCK_WORDS];
 	int nents;
 	int ret;
 
-	ret = dthe_aead_read_tag(ctx, tag_out);
+	ret = dthe_aead_read_tag(rctx, tag_out);
 	if (ret)
 		return ret;
 
@@ -859,7 +875,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct aead_request *req = container_of(areq, struct aead_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int cryptlen = req->cryptlen;
 	unsigned int assoclen = req->assoclen;
@@ -1130,6 +1146,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	local_bh_disable();
 	crypto_finalize_aead_request(engine, req, ret);
 	local_bh_enable();
+	dthe_put_drvdata(dev_data);
 	return 0;
 }
 
@@ -1137,10 +1154,11 @@ static int dthe_aead_crypt(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
 	unsigned int cryptlen = req->cryptlen;
 	bool is_zero_ctr = true;
+	int ret;
 
 	/* In decryption, last authsize bytes are the TAG */
 	if (!rctx->enc)
@@ -1191,8 +1209,18 @@ static int dthe_aead_crypt(struct aead_request *req)
 	    (ctx->aes_mode == DTHE_AES_CCM && !is_zero_ctr))
 		return dthe_aead_do_fallback(req);
 
+	dev_data = dthe_get_drvdata(ctx->dev);
+	if (!dev_data)
+		return -ENODEV;
+
+	rctx->dev_data = dev_data;
+
 	engine = dev_data->engine;
-	return crypto_transfer_aead_request_to_engine(engine, req);
+	ret = crypto_transfer_aead_request_to_engine(engine, req);
+	if (ret != -EINPROGRESS && ret != -EBUSY)
+		dthe_put_drvdata(dev_data);
+
+	return ret;
 }
 
 static int dthe_aead_encrypt(struct aead_request *req)
@@ -1214,6 +1242,7 @@ static int dthe_aead_decrypt(struct aead_request *req)
 static struct skcipher_engine_alg cipher_algs[] = {
 	{
 		.base.init			= dthe_cipher_init_tfm,
+		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_ecb_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
 		.base.decrypt			= dthe_aes_decrypt,
@@ -1236,6 +1265,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 	}, /* ECB AES */
 	{
 		.base.init			= dthe_cipher_init_tfm,
+		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_cbc_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
 		.base.decrypt			= dthe_aes_decrypt,
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index 911e6bbe4d241..0507bcf952c29 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -31,22 +31,54 @@ static struct dthe_list dthe_dev_list = {
 	.lock = __SPIN_LOCK_UNLOCKED(dthe_dev_list.lock),
 };
 
-struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
+struct device *dthe_get_dev(void)
 {
 	struct dthe_data *dev_data;
-
-	if (ctx->dev_data)
-		return ctx->dev_data;
+	struct device *dev = NULL;
 
 	spin_lock_bh(&dthe_dev_list.lock);
 	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
-	if (dev_data)
+	if (dev_data) {
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
+		dev = get_device(dev_data->dev);
+	}
+	spin_unlock_bh(&dthe_dev_list.lock);
+
+	return dev;
+}
+
+void dthe_put_dev(struct device *dev)
+{
+	put_device(dev);
+}
+
+struct dthe_data *dthe_get_drvdata(struct device *dev)
+{
+	struct dthe_data *dev_data;
+
+	spin_lock_bh(&dthe_dev_list.lock);
+	dev_data = dev_get_drvdata(dev);
+	if (dev_data)
+		kref_get(&dev_data->refcnt);
 	spin_unlock_bh(&dthe_dev_list.lock);
 
 	return dev_data;
 }
 
+static void dthe_release_drvdata(struct kref *kref)
+{
+	struct dthe_data *dev_data = container_of(kref, struct dthe_data, refcnt);
+
+	complete(&dev_data->drain_compl);
+}
+
+void dthe_put_drvdata(struct dthe_data *dev_data)
+{
+	spin_lock_bh(&dthe_dev_list.lock);
+	kref_put(&dev_data->refcnt, dthe_release_drvdata);
+	spin_unlock_bh(&dthe_dev_list.lock);
+}
+
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
 				 unsigned int buflen)
@@ -168,6 +200,9 @@ static int dthe_probe(struct platform_device *pdev)
 		goto probe_engine_start_err;
 	}
 
+	kref_init(&dev_data->refcnt);
+	init_completion(&dev_data->drain_compl);
+
 	spin_lock_bh(&dthe_dev_list.lock);
 	platform_set_drvdata(pdev, dev_data);
 	list_add(&dev_data->list, &dthe_dev_list.dev_list);
@@ -184,7 +219,11 @@ static int dthe_probe(struct platform_device *pdev)
 probe_register_algs_err:
 	spin_lock_bh(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
+	platform_set_drvdata(pdev, NULL);
 	spin_unlock_bh(&dthe_dev_list.lock);
+
+	dthe_put_drvdata(dev_data);
+	wait_for_completion(&dev_data->drain_compl);
 probe_engine_start_err:
 	crypto_engine_exit(dev_data->engine);
 probe_engine_err:
@@ -201,10 +240,14 @@ static void dthe_remove(struct platform_device *pdev)
 
 	spin_lock_bh(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
+	platform_set_drvdata(pdev, NULL);
 	spin_unlock_bh(&dthe_dev_list.lock);
 
 	dthe_unregister_algs();
 
+	dthe_put_drvdata(dev_data);
+	wait_for_completion(&dev_data->drain_compl);
+
 	crypto_engine_exit(dev_data->engine);
 
 	dma_release_channel(dev_data->dma_aes_rx);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 75d9a097650da..03a0b426041ac 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -18,6 +18,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 
+#include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
@@ -53,6 +54,9 @@ enum dthe_aes_mode {
  * @dma_aes_rx: AES Rx DMA Channel
  * @dma_aes_tx: AES Tx DMA Channel
  * @dma_sha_tx: SHA Tx DMA Channel
+ * @refcnt: Count of requests currently using this instance.
+ * @drain_compl: Completed whenever @refcnt drops to zero; waited on by
+ *		 dthe_remove().
  */
 struct dthe_data {
 	struct device *dev;
@@ -64,6 +68,9 @@ struct dthe_data {
 	struct dma_chan *dma_aes_tx;
 
 	struct dma_chan *dma_sha_tx;
+
+	struct kref refcnt;
+	struct completion drain_compl;
 };
 
 /**
@@ -78,7 +85,7 @@ struct dthe_list {
 
 /**
  * struct dthe_tfm_ctx - Transform ctx struct containing ctx for all sub-components of DTHE V2
- * @dev_data: Device data struct pointer
+ * @dev: Device this transform is bound to.
  * @keylen: AES key length
  * @authsize: Authentication size for modes with authentication
  * @key: AES key
@@ -87,7 +94,7 @@ struct dthe_list {
  * @skcipher_fb: Fallback crypto skcipher handle for AES-XTS mode
  */
 struct dthe_tfm_ctx {
-	struct dthe_data *dev_data;
+	struct device *dev;
 	unsigned int keylen;
 	unsigned int authsize;
 	u32 key[DTHE_MAX_KEYSIZE / sizeof(u32)];
@@ -103,16 +110,55 @@ struct dthe_tfm_ctx {
  * @enc: flag indicating encryption or decryption operation
  * @padding: padding buffer for handling unaligned data
  * @aes_compl: Completion variable for use in manual completion in case of DMA callback failure
+ * @dev_data: Device data struct pointer
  */
 struct dthe_aes_req_ctx {
 	int enc;
 	u8 padding[2 * AES_BLOCK_SIZE];
 	struct completion aes_compl;
+	struct dthe_data *dev_data;
 };
 
 /* Struct definitions end */
 
-struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
+/**
+ * dthe_get_dev - Get the device pointer after increasing its reference count
+ *
+ * Description:
+ *    Picks a device instance and gets the associated device pointer through get_device()
+ *    to maintain its reference count by the kernel itself. Callers must ensure to call
+ *    dthe_put_dev() at exit to decrease the refcnt.
+ */
+struct device *dthe_get_dev(void);
+
+/**
+ * dthe_put_dev - Decrease the reference count of the device
+ * @dev: Device pointer to be released
+ *
+ * Description:
+ *    Decreases the reference count of the device pointer obtained through dthe_get_dev()
+ *    by calling put_device().
+ */
+void dthe_put_dev(struct device *dev);
+
+/**
+ * dthe_get_drvdata - Get a reference counted device driver data pointer
+ * @dev: Device pointer
+ *
+ * Description:
+ *    Returns the instance's driver data if it is still bound, with @req_refcnt
+ *    incremented, or NULL if it has been removed. Every req accepted for
+ *    processing must call this and balance it with exactly one
+ *    dthe_put_drvdata() when done.
+ */
+struct dthe_data *dthe_get_drvdata(struct device *dev);
+
+/**
+ * dthe_put_drvdata - Decrease the refcnt of the device driver data acquired through
+ *		      dthe_get_drvdata()
+ * @dev_data: Driver data previously returned by dthe_get_drvdata()
+ */
+void dthe_put_drvdata(struct dthe_data *dev_data);
 
 /**
  * dthe_copy_sg - Copy sg entries from src to dst
-- 
2.34.1

