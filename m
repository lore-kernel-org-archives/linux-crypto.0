Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5800F395240;
	Tue, 15 Sep 2026 09:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466170; cv=fail; b=WuMIvHag6bIlDJOUxly7mHERikEDNizZJAE+HtxIjIPALT9dM95laYNCJY7AeyE6PGL/p2GEJyZnOf3y9WYqyuFslFQBbXEexbraCyq9gw4xMsr9s3EfjAZE38B1bTeQGBvtcBkO+/9ZmrWoSbEcs36qoadSyvXZoS+WoNgQhFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466170; c=relaxed/simple;
	bh=6/VplIb+j+VWwzm5NwnKlWGX0BhB+L7F0fBG59Gh9RU=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type:To:CC; b=aZzvkyfGOxn0XPRTScWakEZidWuJzpUDVvTDY1+4vKoQQeMUe2Q0+JtFufqYn2Vs3aEjPUdgSPHCV5FFE9mmqV6ESCUdmZxZI3Dfz5gU4b0iXJttZYrb0rr0rgHEzQykcYIeFDNZS6BAHg8igeuvC7e8sSJr31M7YGI2hDmQZPg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=KAlMSHok; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=dAOhLrkM; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="KAlMSHok";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="dAOhLrkM"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9fBSR3810938;
	Tue, 15 Sep 2026 04:56:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=R0/uluBBqhqrF
	xmyQlYBggr0zff/qwSnXXgZ4alkIbA=; b=KAlMSHoks8Ytf6HP1YFKD3HnkUiuu
	Exy4+KiD6x/HHa65UI27U/OuCOei24J8x5EOWXfmGcAq1Ab3fXXH/gFTY6tt0AXU
	Gl3ctdMGV4tw+gFECjsUj+GqcGbWqpNYJfD4+jzmyqHOOAy2Lizz5kpmfL/4FDh0
	xkq7o+E0ruogyV0J1WdvTrYKK2M9PnwjtbjsOEhv9g+RQq6mE6L75SBxCBavsocN
	lT12wupbt/jOB+fExd+ddC1j2VJ5pGRbyN8t9CYo0QXhfHLERCefe2DY+btEr6Jy
	YDD/xJ4xJ1HnC7LUVhrmp2viM0fpCpKeoCEDeq2bYQn7nLwbus2A4HO3A==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010026.outbound.protection.outlook.com [52.101.46.26])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gq362r9sw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:03 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gtdngJj7k35d5agqdJenjG4WeQZEd1pE2XmKTQiFR3vC15Z6D5nyGYL/T8bMBGYIzNOpKXBoQd4JnnEBUn/6IDTBlD+/FiXKXmbnoxGo10dZFioEpgAut+YrTUZxc0iJMO3LYmJQzz4HhWClysjo0iuV2VVyo0RxONA2ATtnkzdf83a1vqgvvhcMysCWUblfoMyXsUtlehHVO6a63DzfidZKn44YScB2/FpXKQbyWJ3hM77lV6Xq8PHu52BJn9S6fZrtTF/dOOjifpXryvLBRqvlZRipBvrD7gaslZTRFHy4b8q2njLBFuYnt88lSQGGwNpBcXPUWYsyPzpt9sVjEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R0/uluBBqhqrFxmyQlYBggr0zff/qwSnXXgZ4alkIbA=;
 b=dsyJGkclmSMryU9b8yDx3CR3QckvjhyR5sh185qYOcMzn9RIZ+9rPCPkrQAXthQXPiew2Wie/i4kLmmyiQEmdnSgGejSO+60rrn6i28zQbTZpv5m204mNzwdd3LCZ3EPK0/QFOkjrBnS0wLmCrdFdZfo0Cv3NN4Rbltp0gGNa6GCw9NGlgu+HJIV4VybqFkpEUK8lz42Zk8nUoxCGTJQjed0acH/lGq3i8nYF2DArj7nhWa857vwtlVYGWm+Id6wFkU7JMZaI0E/PD9opFDJoqLRwWl7m07N0blFfzjyNQ6jkFXdF4oMHeB5bawYKs/e/Kp/hUojue+baP9teN9J3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0/uluBBqhqrFxmyQlYBggr0zff/qwSnXXgZ4alkIbA=;
 b=dAOhLrkMQQTR68vYt7sZYG+0tw4nUJjbDxuuao64YUI4PHw7WsNUYTieAo61Kc53YFY40kI8QZhRO6bvSCNYTT96kmfS9aFZQbjHW+YlMgZ0aGYqg/3U/olZetcfdTfXYcoXZLyFmR2EzGVdw6KCvK6P+fouwF6swUXmjbBMDZs=
Received: from SJ2PR07CA0009.namprd07.prod.outlook.com (2603:10b6:a03:505::6)
 by DS4PPF6D651AD93.namprd10.prod.outlook.com (2603:10b6:f:fc00::d27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 09:55:57 +0000
Received: from MWH0EPF000A6732.namprd04.prod.outlook.com
 (2603:10b6:a03:505:cafe::93) by SJ2PR07CA0009.outlook.office365.com
 (2603:10b6:a03:505::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 09:55:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 MWH0EPF000A6732.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:55:54 +0000
Received: from DFLE209.ent.ti.com (10.64.6.67) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:15 -0500
Received: from DFLE202.ent.ti.com (10.64.6.60) by DFLE209.ent.ti.com
 (10.64.6.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:15 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:55:15 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB7o3000901;
	Tue, 15 Sep 2026 04:55:13 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Subject: [PATCH 00/30] Clean and improve SA2UL driver
Date: Tue, 15 Sep 2026 15:25:06 +0530
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPoVqWoC/x3MQQqDMBBG4avIrDuQBLXiVUoXMf7aAU1DpikF8
 e4NLr/FewcpskBpbA7K+IrKO1bYW0Ph5eMKlrmanHGdtabnqeWS9JPhd1bvysZhg48lccDQza0
 Jd0wD1T5lLPK73o/nef4BpWySimsAAAA=
X-Change-ID: 20251106-b4-upstream-sa2ul-cleanup-ce85d40c7eb8
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=2783;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=6/VplIb+j+VWwzm5NwnKlWGX0BhB+L7F0fBG59Gh9RU=;
 b=BytyFNtzLEmXwAm5hNaUVEa/8p76ySFwgNOWhjrqMzW+R9Bor/wXvzLVehOXGx4+9BSYI+h8/
 awiDu40AtM+BPbtwPH0z9U3DfrujnAiP236aAEczFlBKwNXSrbizd8H
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6732:EE_|DS4PPF6D651AD93:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c18c641-55e4-4f13-de9d-08df130f8893
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|36860700016|82310400026|376014|13003099007|6133799003|10067099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	euEpcHtHoIMZ7lUs2qdEOJyFNYS10ZzeHaw2ZR/9jPzY8ySOXdUXNhLwqKrrghZ+4LKavdf0e1V5UxBwdXE+gjJok1iFeZTccZrUwVN4ZNth847B0wRBqg1Qw9P1Yvkthv9komw1SdHwkbezJ58BXzrpT8vvemwu+aWjsuw3clz6tuvMM0wIytpAoRcp7WGJFYU2edxhfG3EP/to6ZnPQsNxhYRUySfkacwQss2Uu3QCX465mjfIFPaJioikxs9Y7ybnJ1ErUOzc1X58ZIqFj1oHHQ/PH3mIByOt0IQFRasuimClGHGbRpdo7E3d0SSNUe5GZ2bV89DZaFZ073cvXzoOi2PsixDO16EncRabaEK7nul+uTH/0TqY05Of/oQU4C2fpuxIlGkkBxQngvlh6cJ0wvONQZaUMFYJ5A3XtoDC9IvvOFBnmegOLH++OX0S1nhUfPnjT0Y+keTdDMqmWrqMf6lQB2X6vukU/rcruGeG5UlsiEbgZtWgDGfyQK5OprDM9DZdsrDqSF6A5G5+7U2dVXmYOyPzDbBcEQ5Sq+jfmEFFPAyyqmwksxtU5g8e9RVpn4nwV5chZlXyBF0dqm1TuiP01l4pAeVUelO6dLkLX2REVzbGX+TFRWR+4AbAjOOMuEJCg9asbLQqF0wDidnX8HrEbX/bEi8AwFRIi03lx0e/DOVaKlDzNGaLvkMKKDWdFJ4XhtSOhJs8jfBblA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(36860700016)(82310400026)(376014)(13003099007)(6133799003)(10067099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	H000JOLs2WQbxfOcWW11kvexISXsrE/QT6r0Aq5mQ/WYuQ6ysiyZq6TXi02c2B4nEqqgZl0I6bDVpwiguxta0hTAD6weSupYVlrCNQS1GUAC4xCwX0wgar+dGVnhPspaTmBZsUiIwS/E8VczISKgk32Ctosh5Z3R7dSuNpKcnWpn583Y9DETnF/cZ322Oe6ux3rD1xXAKwa3gck/xLLYxzBUdfrVPUifeWqDEj4lO7AH9uWZwOU4aLU8I9A+vj+g5xRUcO5jROVligEL/cf1a7cQZr2b6wOWdPaDiZ9GjnHKZnR+8YyVYwO/sMXQR4zBPTTE4U1SoyvKwst6gsYrLvlagNEU3W5m31V1vZPJy3e2mQxo+tqs61kF1wpFkNaPRgPAAdgBvNAR2Lw3OCyBQKh0OBtxiIhTr7juzmGWseLQr45qU+SUGQ6EiY/svPnC
X-Exchange-RoutingPolicyChecked:
	cYVFIOpwbkPu6xPpAO1bXMjvuNqP4MV6bH56kscPUSGG/E0/ytxxpET144ziRkcKSzrEsX4HRDbZ+AK8XWiNaMB8Y764r4q140GVkAfKKGKkEbIEAIDbvVOV1E7pdHU8B3yXEFGp+9Nsz8KQVeLK5IqEF/O0ejgklmfA8UJ2IEdjpaamK4xaLEoOcs3AHZoFniQhczPOTB85KgLP9laeLjolo5o0x1GRxEYFST5mszJn+rNhnxJoaog7iOQLks8WEeQuZLufQfIqBfgV1LqCa84Du2mr5dZNYHbcogATLkOxUXH+P98eq/qfRTW07MvvT198GT6qW5lsymGZN1AKIA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:55:54.5350
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c18c641-55e4-4f13-de9d-08df130f8893
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6732.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF6D651AD93
X-Authority-Analysis: v=2.4 cv=P9yvFSAu c=1 sm=1 tr=0 ts=6aa91633 cx=c_pps
 a=oJ9tI0XfeScUaspqi3eqJg==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=NEAV23lmAAAA:8 a=sozttTNsAAAA:8
 a=Oh-L7DK_aKt1G3Atd0sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: iOWDUNfesZKPfzmuXejW_uuMJvvfPihg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX1q2BpF3VaBwd
 fHu3p0v60WI3RootnXNOsDHiV6tZAIqnWAF3m4wDRKjYjeo6uypLwK68kHF355wC9ya13kwjNjS
 uuEwxN0aEv04It7XlqQAyZUu/30xk4uK6pLHX/H87XIvIfNRvh44kV71Q9M+LR2MiT9viMZ1ULQ
 FK7QOlwyGdeRL8yDEfpEOpCMA6aSaF4+11c5fSRgyLJQX9QyS9vCArscnurML8/FdGrriY4pSVq
 vl765wj3p9Vh7OJljTq0Y+LnYDRJNZGHuYLRKuiTqMx42IrZiPjvSXkrP/RDw69xBmxLNZqxRb5
 17bDQErh3SG8WALR5iw6yaNGNkks/D1XgGG5CYAlpQ1HeXRpEXm8EK/SSaGBb1GLaMjX+Iynsau
 yO7EkMPOu3WXLCbqIpGmGSsQuJcLlgA0PlZPvEsXDje7pijHTMG5AXzDMv+FSd1RGZnXv1wDaWU
 x0khkUgJsjiLFYeZFTQ==
X-Proofpoint-ORIG-GUID: iOWDUNfesZKPfzmuXejW_uuMJvvfPihg
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfXwjQQl18yMBys
 Us++MLR1RzdpVfjpBnVPDdR3lE6ohd0YBh7RbA1biJaOJAZQa9vZ9qpNROJQPObLw7J10h0TgcV
 7suvsuiQ00M6X/ToIRzUuukeS0nemes=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150143

The following series focuses on some cleanups to the sa2ul driver, it
starts with very trivial cleanups then goes to fix some bigger cleanups
and migration to crypto_engine which help fix the broader race condition
problems with the driver, thereafter it adds the support for AES CM as
per SAxUL 3.1 IP. KASAN is also run alongside to fix the issues caught
by them.

Self test results across K3 family: 
https://gist.github.com/manorit2001/544587ec3535125663e3ca9dbc186e96

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
Manorit Chawdhry (30):
      crypto: sa2ul - remove dead code
      crypto: sa2ul - remove totally unused structure fields
      crypto: sa2ul - remove unused algorithm ID fields
      crypto: sa2ul - remove unused fields from sa_cmdl_cfg
      crypto: sa2ul - remove unused fields from sa_tfm_ctx
      crypto: sa2ul - remove unused macro definitions
      crypto: sa2ul - consolidate encryption offset definitions
      crypto: sa2ul - remove unused SC ID range tracking
      crypto: sa2ul - remove unused base register pointer
      crypto: sa2ul - remove unused includes and defines
      crypto: sa2ul - remove unused line
      crypto: sa2ul - remove redundant sa_sha_digest() wrapper
      crypto: sa2ul - fix struct documentation for match_data
      crypto: sa2ul - zero out security context on free
      crypto: sa2ul - fix context release on errors
      crypto: sa2ul - fix resource leak of sha in init_alg() error path
      crypto: sa2ul - fix resource leak of AEAD in init_alg() error path
      crypto: sa2ul - fix DMA mapping leak in sa_run() error paths
      crypto: sa2ul - generate dynamic metadata length
      crypto: sa2ul - fix command label stack corruption
      crypto: sa2ul - fix error handling in sa_prepare_iopad
      crypto: sa2ul - move export to appropriate location.
      crypto: sa2ul - fix stack overflow in sa_prepare_iopads
      crypto: sa2ul - add more checks before processing ipad/opad
      crypto: sa2ul - fix data corruption by skipping device sync on unmap
      crypto: sa2ul - use correct DMA direction in sa_sync_from_device
      crypto: sa2ul - change dma_alloc_pool to mempool
      crypto: sa2ul - route requests through crypto_engine
      crypto: sa2ul - report SA engine hardware revision
      crypto: sa2ul - add AES-CM (SA3UL_CM) TRNG priming support

 drivers/crypto/Kconfig |    1 +
 drivers/crypto/sa2ul.c | 1042 +++++++++++++++++++++++++++++-------------------
 drivers/crypto/sa2ul.h |  162 ++------
 3 files changed, 661 insertions(+), 544 deletions(-)
---
base-commit: a9d7ced84989ec05be09b4b8428759ef60450a0f
change-id: 20251106-b4-upstream-sa2ul-cleanup-ce85d40c7eb8

Best regards,
--  
Manorit Chawdhry <m-chawdhry@ti.com>

