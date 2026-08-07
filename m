Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754FB42FCD9;
	Fri,  7 Aug 2026 11:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786100792; cv=fail; b=AxAf3aiRWycQ3ZT56kSwwR0aawN/ykzWQ1Ksdk1hkPTmXcELB+1DfS7yhQ8m/O3lCTGsZOIGRvEnPj9B8UstoMjTXSA+jchK8Qopu99kqCIaFIT3PKDnaVV0abCTzNg2pKVhTrPk03/yDRZzTC1pIpJWlrJj0bHKUHZsNFkl5oE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786100792; c=relaxed/simple;
	bh=iKu3PR7tNQxltSK+nDXTxYsf+vbkKv6v0DnAYUi4zJs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JPXIUadyS+Z8VMko9BrexnjvdrpjKY1j/Tm7zON0DTJ6lewBTaowKYqDXBXEwotLeltWD5Ok4sGFzUjFANuUPWNRnh9QKlpYkBROa+Vyt81RAM1EKiEC6xOqTldGYqNJEYMT2YPy0hPA9iqG00I+jMnxIEVZyWiPxIHf3/CLz/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=SkFvdAu/; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=cpK5lAL3; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="SkFvdAu/";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="cpK5lAL3"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6777bYDr2210988;
	Fri, 7 Aug 2026 06:06:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=vbPgoWR35+38CeJq1jbnrtPT62+k80Lt15d6ii8Tu
	bU=; b=SkFvdAu/fWrc11RUU3BE8o/iep7dJE3ZFmQtXmPy4RzvA5QwdfoNfZI1Y
	kxXbJPiMaM9rG8B3c5yFuB2LgaVCxy81A86hWxayQgcpWT0ZjqZKhckHsZ2gYgqc
	hO9AsQqXIx6wE3enpoaWc0rodu/KZCqY45iX+Jpr63nhkxdKICnEyMrTcPVnO0aG
	xsivkbr7X0D+b7HM9ScXvk9HdPPwfdSpBHbIBxRbzvNXg0ua7XZIfcHRsF0sUDwO
	gGXmp6Hd0OZPHccwHdjh7AYi9HB0g2vjxgCp448hQ4K1bz7uS/ou0/YI7o0KzyMS
	RLyE25vq0cE/AqGFwrff7LUd3fimw==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011053.outbound.protection.outlook.com [52.101.62.53])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4fwb4wry92-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 06:06:25 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E1uY9mgR+mIroj7CokrYf1d/1A24Ix7Y9j6I+VkMMsyaVWE2m16w7Yid6AnzoKZmEYmMCxBULCOK3et6W82j6HZJcOlyYhyTw2TbCu4NVOvgkPCyWhwO2mMNvnPETSLQXzFJxSPfrQKrstJ7fXVTrDZTaTjBxEuc3mgsTuopR6v7VGz5Sj1X1/w4GDKdeDLru76sg/z5g4CS9H7wgbjV+xKnXotW4mZZZReei2Xgiuh0mBh29wZeKdfjHlp5jGS7cYzjIrZE6apf8IPqIBj7/oBoqSDmZezwfS//UnCnDFdSfsju8i4qtokVZKiFBL5+Uqgyu2JpCF4D+kINKYS2HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vbPgoWR35+38CeJq1jbnrtPT62+k80Lt15d6ii8TubU=;
 b=dJua/eQwwlAOwSB30MUGUM67OWbZxTSN1u+NC7lHVkbJCZVwZGmU5OtIjUKfVDaNtrEHYWrKpdWDx1L2enax9ThqBbDLvAoxX/Pe/CMB0g2LeVHoOVVOfWgLBS6GHAyi9/p8WXDl2Lpz1GZW/MEsug6efUuOhZYBkRV63bVDauPiOBbMtZkReZOmESO/3xUD2iT8iapLo9N3qgzrZ9bCkJ5MgqOa1/h6W83n2ago2OkNccjMJ247SKGWSxJC4qsiUvZzuLgSpRSmcngoA1VWM8BeEao9pf+VjUr68MfqC+4katzoDaTgR9cKbupjmHabAW2YEMyXb33sKnqp+w6bQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vbPgoWR35+38CeJq1jbnrtPT62+k80Lt15d6ii8TubU=;
 b=cpK5lAL3/jQMHkJJxH4xkZj/kdyWjEy5s9HgUqAKDJn8n4Nq1OlTs6Acb3lnKIGhocAJ4qMjMxQys6mxmbDiAP1trhWD8WcxnJhhWnDdeLRbyYd3x5k2KKWfzIDdKszuFY/mkOroTINSeBbw+HToCP+UgJTfrcTW/pY17Af3YI4=
Received: from SJ0PR03CA0187.namprd03.prod.outlook.com (2603:10b6:a03:2ef::12)
 by CO6PR10MB5603.namprd10.prod.outlook.com (2603:10b6:303:14a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:06:17 +0000
Received: from CO1PEPF00012E64.namprd05.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::76) by SJ0PR03CA0187.outlook.office365.com
 (2603:10b6:a03:2ef::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.21 via Frontend Transport; Fri, 7
 Aug 2026 11:06:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 CO1PEPF00012E64.mail.protection.outlook.com (10.167.249.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Fri, 7 Aug 2026 11:06:16 +0000
Received: from DLEE215.ent.ti.com (157.170.170.118) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Fri, 7 Aug
 2026 06:05:51 -0500
Received: from DLEE209.ent.ti.com (157.170.170.98) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Fri, 7 Aug
 2026 06:05:51 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37 via Frontend
 Transport; Fri, 7 Aug 2026 06:05:51 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 677B5nE41705312;
	Fri, 7 Aug 2026 06:05:50 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Shiva Tripathi <s-tripathi1@ti.com>,
        Sebin Francis <sebin.francis@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 2/3] crypto: ti - Add support for MD5 in DTHEv2 Hashing Engine driver
Date: Fri, 7 Aug 2026 16:34:58 +0530
Message-ID: <20260807110501.975130-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260807110501.975130-1-t-pratham@ti.com>
References: <20260807110501.975130-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E64:EE_|CO6PR10MB5603:EE_
X-MS-Office365-Filtering-Correlation-Id: e153a949-a829-4cb7-6730-08def473e706
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|23010399003|82310400026|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	jLdLuVZKgosXusPBiw7c/YFcL229WKb0jSRx0H2GpTnnYPdZoxslF6mIQMUaP/Bdb0NkFive0dO6b55z1JrB7CQz2o2EEYUWu+WBwW3c2gXgI/AVKwYN8SoQC0v5SwdjiVzIrPyhjRog58agZhswr9d5Ub3BSLGHGRHN07I4AX+zqwpdXcu0KmGL0YlvMKZruOcThx9WQy1cuDoQCAvlwKINK/JXY97mHb3aLxyrSrPtO/gfG0Aer8VaqHa8YnpOagML8nETNNxQlG3PI07l464n196udZkzw192iQzuW1/819L9dM2wedWXZH8BOlJUV0ql6VNN57G/iAZJq8eUzvoU3nhLee5sjYQJw8TSisPRp7FlpeboVSdZPqqusPT8+CrU8i8o9XQQAnsGn5uV1LsZ6S1SVKgh9qvvHsGUDDMcszi4bulIr3E/fdKIVXl7VChXB3P/5vYJx8L9V6eG5XtAQf5aC6E7ZpmWDoJbs2xlJjfOaqlTbcUxc5kLvSgGQ50Ss6W0+HeVAC0DcbsZ0SE/soSJY5TPHMk3wc2FtTorM1A1eUnIgI69RfgdGJF2srTII0rMTAeo799jJezHa2wkgsijIRdBrO6kOrfDTKuEso2doe49maKnWrdBIawMAI1ub65cMm6m+UAHlzqfpXaHLvSUf/cfLjf+5ZvlH91y5YyW+Ml5qzxEjiMWCKzUJ9RP3eKTBTwNZF+yvjKl6g==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(23010399003)(82310400026)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	I8T9xX7yKR7L5AIC3gvAKe0LS33NutyP4Ki7TGnsFuL8cLD9pqn01mcHEJ5nWcfRl7GqOZ56k1HoHUTXfKULG/21NlgOcpBSDgcTK0jE6ebXOjYEvCcEMtezVZ1Er/U1gPvT+YJs7EYfLa7CmWw6mAF95i5xS/rQ2SFKvESRd3DdueA6s7uTZcbTKvvteHDE0MOohJazLmqwdMC/386hSep49sySjhJoMo0+tik7HylcUuMbnUKX7FeNMXd3+AWdc5FhuYLxcdLGN+6m79UdDW5eQTZau6yIsHSh6Gv7/sS2STXox+e7co7aKLCmWv/sZEzuwoguVLk6Dt8Pb01kAMxGH2HPp31VOCGHyEZMkE17A5hhOw2dyJhF1WPWR79HMVC+T/+6fGxEg1WjCdjHrxRJ2R+KVKj2RZBQYfpRgOGYZSzDXlqt10ZXEuhCbxwB
X-Exchange-RoutingPolicyChecked:
	ZznFtaL5LAMcIHa21n4SduFAeZkwJw2jLozMp2dXI+WazphWZeDPvV9KCAfAIegOFuiRHn6+zMCqITjh9v6QHnaJHJb5Ki3Ca91oCP1s8Q2CW3i9Csu6vRVPybsLTJeOeGrZ9QGsn/lElnD2ocl8vp0PYlRBPj61s4c02ls/3EagdgnSGyq4cyPcoFb1MSC9A0uEux4dDyAsv2QawmJ3TSZjf4ZVKlTbiEo38QDGah4Iik8x/xczRbCaVM4V/J/J1RzedI5NtOQIuPBrxfqyYRKQewcPjUgTqcnfao653MDApmuh2fqmG9eArCHemamq6ZCnsANCaWGBKno3DhYhig==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:06:16.6208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e153a949-a829-4cb7-6730-08def473e706
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E64.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5603
X-Authority-Analysis: v=2.4 cv=FaEHAp+6 c=1 sm=1 tr=0 ts=6a75bc32 cx=c_pps
 a=9V9/KAGQR/RGwytZTnC4xw==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=_Bk9PBcLl1eLgj3c6_AA:9
X-Proofpoint-ORIG-GUID: JflvBGeaLzA4EomyID2sEP55-l94Into
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDA4NSBTYWx0ZWRfX9vtSRsJxq78z
 ggXnJ7xvou5tfd84EWGmN5P5W2AfArsVk8mfFXRLJxlW77/WbxqzJA/7mHua2qf3VEZ1AMiwV0O
 kpqUPdU/Ea5aUKTZ/9upfKnjePP9UxU=
X-Proofpoint-GUID: JflvBGeaLzA4EomyID2sEP55-l94Into
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDA4NSBTYWx0ZWRfX7CbBVsU0aRx1
 rHyCuIO10pT8e9CFk8gzVwrO/4WnCCSNdhlh8hAR4jk3tDZMY+JIMGqh2RHhiReeAVIIgUEqPyI
 pkXj3211CkDEyR9gnjGPDC2pLzJS7KAx1Cx8GA1FVYtVd7wEr6r7W7TiA07nHTjpm8PfGa7Ipc6
 GdU4B+tbF6Kwwb5iLv8WItRwlisx0ddTOpsMJosh3KC9pGkdpPCpo44/zKTYV3JOZpTPwVATK/R
 5MKDpFgoFSjtAiaiYd446qmtfhjfYm25H6JFWHby4JmaYjIapV/6sr2Gh8ovhKOrsEBUbrsO0m3
 N541Vw/IS8sPUH4MgOH948v8HLmVK6FuKcZVQs2tHNcufsbBWouTyiPNPkkhKbPWYl/V2gT1pU9
 Y4yD0+TG4Ihc9zcN9WUgMKA0hZT/Oan7SAor+RDE+GGY46DSdJjcNTrJ0BT0d6rYmJ2FfTmLqNc
 rpgHL4ahSQH3Uvtr4DQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608070085

Add support for MD5 algorithm in the hashing engine of DTHEv2 hardware
cryptographic engine.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |  1 +
 drivers/crypto/ti/dthev2-common.h |  1 +
 drivers/crypto/ti/dthev2-hash.c   | 47 +++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index 90af2c7cb1c55..9c2aa50cfbfbe 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -12,6 +12,7 @@ config CRYPTO_DEV_TI_DTHEV2
 	select CRYPTO_CCM
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
+	select CRYPTO_MD5
 	select SG_SPLIT
 	help
 	  This enables support for the TI DTHE V2 hw cryptography engine
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index d3fb7c5ff3052..2c6e06df16d35 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -17,6 +17,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/md5.h>
 #include <crypto/sha2.h>
 
 #include <linux/delay.h>
diff --git a/drivers/crypto/ti/dthev2-hash.c b/drivers/crypto/ti/dthev2-hash.c
index dc7a397a9e58c..1606b982e4581 100644
--- a/drivers/crypto/ti/dthev2-hash.c
+++ b/drivers/crypto/ti/dthev2-hash.c
@@ -9,6 +9,7 @@
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
 #include <crypto/internal/hash.h>
+#include <crypto/md5.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/sha2.h>
 
@@ -97,6 +98,9 @@ static void dthe_hash_write_zero_message(enum dthe_hash_alg_sel mode, void *dst)
 	case DTHE_HASH_SHA224:
 		memcpy(dst, sha224_zero_message_hash, SHA224_DIGEST_SIZE);
 		break;
+	case DTHE_HASH_MD5:
+		memcpy(dst, md5_zero_message_hash, MD5_DIGEST_SIZE);
+		break;
 	default:
 		break;
 	}
@@ -125,6 +129,9 @@ static enum dthe_hash_alg_sel dthe_hash_get_hash_mode(struct crypto_ahash *tfm)
 	case SHA224_DIGEST_SIZE:
 		hash_mode = DTHE_HASH_SHA224;
 		break;
+	case MD5_DIGEST_SIZE:
+		hash_mode = DTHE_HASH_MD5;
+		break;
 	default:
 		hash_mode = DTHE_HASH_ERR;
 		break;
@@ -146,6 +153,9 @@ static unsigned int dthe_hash_get_phash_size(struct dthe_tfm_ctx *ctx)
 	case DTHE_HASH_SHA224:
 		phash_size = SHA256_DIGEST_SIZE;
 		break;
+	case DTHE_HASH_MD5:
+		phash_size = MD5_DIGEST_SIZE;
+		break;
 	default:
 		break;
 	}
@@ -489,6 +499,10 @@ static const u64 sha512_init_state[SHA512_DIGEST_SIZE / sizeof(u64)] = {
 	SHA512_H4, SHA512_H5, SHA512_H6, SHA512_H7
 };
 
+static const u32 md5_init_state[MD5_DIGEST_SIZE / sizeof(u32)] = {
+	MD5_H0, MD5_H1, MD5_H2, MD5_H3
+};
+
 static const void *dthe_hash_get_init_state(struct dthe_tfm_ctx *ctx)
 {
 	switch (ctx->hash_mode) {
@@ -500,6 +514,8 @@ static const void *dthe_hash_get_init_state(struct dthe_tfm_ctx *ctx)
 		return sha384_init_state;
 	case DTHE_HASH_SHA512:
 		return sha512_init_state;
+	case DTHE_HASH_MD5:
+		return md5_init_state;
 	default:
 		return NULL;
 	}
@@ -682,6 +698,37 @@ static struct ahash_engine_alg hash_algs[] = {
 		},
 		.op.do_one_request = dthe_hash_run,
 	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.halg	= {
+			.digestsize = MD5_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "md5",
+				.cra_driver_name = "md5-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_OPTIONAL_KEY |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = MD5_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
 };
 
 int dthe_register_hash_algs(void)
-- 
2.34.1

