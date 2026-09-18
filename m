Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A704E73A9;
	Fri, 18 Sep 2026 10:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727048; cv=fail; b=EUFRnZpBT7kq9Q4ioXUe1NbgqjKMvuoXrVrlV/UOB6VoDHtswB+Bj5mSskkEU2aBwhxbPuXyRHCfiP2AKrtENPAptZuBcrGHQLFqrFWMSWL5M2EShzAeLKl5yq/DV9PQF42tHkA4bjUNxJM/odJeS/mrpW3xXAL5Hl3jSV1DIGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727048; c=relaxed/simple;
	bh=14+lpbbjuBYbleZZptnnErmVsbsXKn0WAKM8jdF9Cmo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BTX0qWidcfLk8D7mBsZCPtzlAQ6lkzAujr7nGbsZ3S+n3tQnpIKpbPgzff9uVzu8MaBN0kczRUhi819ilMajyXLUcmRXRVNkYApO0c39GdMEdyOiGTHaXistJbvwf//3mvsthKSIt3gucQQ2lgNfmA2UtJ+Jw/1KpXsdvRruZr8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Jo8viOJw; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Tqn/z6O+; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Jo8viOJw";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Tqn/z6O+"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I9eIG43768370;
	Fri, 18 Sep 2026 05:24:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=WCBqois36VGrEk3wC02QqgtiaiTky+9IMvxqB6ixU
	u4=; b=Jo8viOJwrPjmQT7+6TFC8advQdPlFyQIf5uGFZAWs5X0qbBbi9xsmgUX7
	1TZ9dFZMgMFSgwjQUkHYAjKvZsfchQhIxZyKMFRcQ5jyF3+TcOeXFU1PmKMbZm7S
	FKE2saTqq2nieV1cxH0nbHawrn1h/EMw3VNVcSEL+eNeYAq8lxsnBEOOJ6LuLMrt
	4nohy2qGfAhT1jKInvAUH7Amtki4STqHPcF5/ovqduQ9qN3K2B/Gey0Vs/xMn7Za
	b1/rxVLV7uQKaRcE+pdWW8dDyQL0dDvaCZr3ecLHuizbyrrRsCxmNOEXZCA3IKC2
	sID/dSmwefywUBdcWWOF+TUXu2eAg==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011024.outbound.protection.outlook.com [52.101.57.24])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gs16cgspd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:24:02 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iOvlCJEnFDzqgs+qukY1tWGhXOHSzdQhkRbNcTQWRO809BPo7Nd9jAweGr1H8zfDmbO+V+X3EZYz5GOaX2Chmpv5Yxu350f4F76UYRRRwID/LdjnshH96IIbHg8ZjLVfPWmsnqAKpdK2alJPwoyFd4e6mMpwchBtGWtMxgYMmtaxjewNPcdOa5VhapJWpFaoL9m+fcVgpAnxA/sCMw0OGLOY8wgZxYvCGSLEGhmV5D65xa4ylIiSCZJHxmbGCL/PwViLHc6i4KlQ3ijq8M+vZDQr/UWCVoa/q/5Iu0WDp8kxurVNvYjrExNTGiE/Wc7sAwBD1KMU6LWME9Vo4bKY+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WCBqois36VGrEk3wC02QqgtiaiTky+9IMvxqB6ixUu4=;
 b=m07lsR3tWDZ/S8SpilJv89F8BrKsLdqYKqpWcstZOCSz8MbYJUz8pwF74Zu/XYZrPgT43dxhMKU1LfbggrQmqJPoUteWjnz6hIgHUqRsxZFagmgmx+nRvCsNeoJbn4VSyzp7nRUcPAJwsJ+0pzSHBBztHFYWJKfJQNPmcyjh67ojVY+UY2VZEsHe31u6TsXDHaLjjALKY18jho/tbnc7oxZQSaybDjeyoecb/fLJHNznKQErS7Q02fcHr+MaNXqeWa1+wIhq8DQNoeX6WM6XbV2DBokmSfIZzm8PZPjtPZE67yfOiYO2kW4RAXKuvGsIxT3E6x1SSE97NbU9ymch3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCBqois36VGrEk3wC02QqgtiaiTky+9IMvxqB6ixUu4=;
 b=Tqn/z6O+SkYD8QfBnCBblxSM+4N+mNhBoTYJA3mLOneQtjOKSrhUPwDWRukKD4y2G+urNMaxzQ2z0fyqK1NkNCWAdOLf5+AYyVuqVKlzqxvlMXuW2uewUBut5CH+14Z8qgqfHZ7zj2QbQjlliWVH/+3Xm6Ez4euaVXIU5MPYPaA=
Received: from CH2PR17CA0022.namprd17.prod.outlook.com (2603:10b6:610:53::32)
 by DS0PR10MB6975.namprd10.prod.outlook.com (2603:10b6:8:146::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Fri, 18 Sep
 2026 10:23:55 +0000
Received: from CH3PEPF00000016.namprd21.prod.outlook.com
 (2603:10b6:610:53:cafe::73) by CH2PR17CA0022.outlook.office365.com
 (2603:10b6:610:53::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.13 via Frontend Transport; Fri,
 18 Sep 2026 10:23:55 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CH3PEPF00000016.mail.protection.outlook.com (10.167.244.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.0 via Frontend Transport; Fri, 18 Sep 2026 10:23:53 +0000
Received: from DFLE210.ent.ti.com (10.64.6.68) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:09 -0500
Received: from DFLE215.ent.ti.com (10.64.6.73) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:09 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:23:09 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IAN7mj1534438;
	Fri, 18 Sep 2026 05:23:08 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 05/15] crypto: ti - Trim scatterlists to correct length in AES
Date: Fri, 18 Sep 2026 15:52:35 +0530
Message-ID: <20260918102245.2784000-6-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918102245.2784000-1-t-pratham@ti.com>
References: <20260918102245.2784000-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000016:EE_|DS0PR10MB6975:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d78ad67-e072-4cef-7b22-08df156ef0a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|376014|6133799003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	to/TldSQKInW1npcVZEoKjbifNKIYogYpfxXCJJEiOMkEAXJdb33QbRLEZqgd1yINUd1d45yN2INMp75gJF6YUK7CQ8b+C+gMXcZtVQ3WH2obhNta71CzbiTdhWWu08K+EoL8Qxf3XubBP2FQrTs/iM7HRYmJPGCnJjhiJEaUM/EWlAx1jH6bXzeF+EGuRW0PKirsIMJUT/w07ByU2prIWd0XQZC+0wzJDy9ea/kwFk4nU/SJi3Q9+AgEHCbPl6iRNJyMerqBDRGfhMoWFoSFcFpE4503qQbMBXYMiXSpn/LHxr2Z5oWlnGZ0XOMCHAh3TSUOIt7tstoFZcpAfUElushamjLX3D6ZkaxYJ3GfwXWEE3rHZyKi1GuDom9akZnZsFIYjFfJL4ZGw1rj4hYpee3JMnzcNx6TDVkDHQsUgBnk6NzuPCIr9MFu0Jw2vcGq8A/3CQ//7Eq8P548hfTv092zmOwEkiJ3IqLQY3GkXuvZIqKmtHz8U+JCKQLS2XSPXVkQy8lKxNrzOOpZEFu/db1aC/4PxWtNgiTrFukmTYh9hAJMPT5VUUQ58azehrur9v6fe5UmnXvW+lmcL/Iv7Zx/NZQf+kgWqK++w8/SDekVpUYKyGMdis7S6CQ4EkOd6SY3Jfaeq88W+eGtqubdFqOKPYIxl0PvFIffZmUmxRurx/WatVNRyv42KPIbLioyJWs/ZZolgoxTdyBzjutBQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(376014)(6133799003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	p3SBCJ4tEmBwt2jnAIdNntcMuJV/1TzqlDsGo85ok235LMXalmcIoOAkthaKJ1g4fW2EfRUWIoUgEzDcAmiHWBQ8AO2cpSEUkJ4NZUlz7wWKqTtjocVqV2Mht6sevdhAdFFnnhkqrfI7LNx4LtvHe2FCRXDT1HTT1IKRDAZ9XVGjB/e+YZ3a8SvuFL9LFmAKUyeh3dR6WLjUFA3LGn/tOWitR+MpydpdLndDSYrwFJqiZByHyVeS3u48naLLE8ustB3A9lxclSGZJ97kBOwu+17l0PyyI2f1vsbu7t5CLRzACOSpsdccYrjYX5cjlugX/F+6fhhiUfuX3jxSWTzhTDKEqcrqN9BJ/WwpvfXfMHeZzi0rcZz5xMTGtqea7ofjmflBVen8kMukdSMdfR1ueIdM1eeE7PeTZX/Ez/fndZiz4gvjfEj++bnw4RJOtCv1
X-Exchange-RoutingPolicyChecked:
	NonM3bjtaiiKIgzOBqzO/tXj2W8eMQ7MHlztAQR0wkZhdVJFTolrClFinOyoZZS0IZaLvv4BfTdwF92dVSI6YFoRD4+t3VJvltiB4yFdZnpIPWYMeOcFDkuUOWbRbSPqy/IKU+Oi8nZeuhj4aGtP0RPlb7f3BpIta/zriODvJhro0e1QKlF9o4nzz7dkb1QpZ9wBsSmfYllpPWF/s6n82VJx/efCW6luqxgzJMd1PyKkh02wyGKXrSNUSdNpGPPp6t0fNrWHLfQHt0Wq984UszdtYdZEEq/Drmp+9CzahaJctSlq874WrvHGxijVhRYDhDoifQS/++gkSMfAFAQzRg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:23:53.7041
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d78ad67-e072-4cef-7b22-08df156ef0a9
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000016.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6975
X-Proofpoint-GUID: E_0NtfSK4q-5EYyl72rNm-FaCF1uI0Zo
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX00E+6JRllG0q
 4O5p2Hpt2xj0gOs4uH4qP5T1HCczaWZXCazwYRVCgRHYRoNtbCZZyl7V1lqI8Y1BxE04LogjcYW
 vwpMs+7lAv+0dADggZvpICkUhMWxJos=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX6aKH7DGFrirp
 N0hbvXt5jc2WeVxhW1fsUBK2l8GspvY3VGkIxoUkxx5BTaxNovsuEnI3N5d7CMkvfXSAhUeKaa+
 2vrNIB8ajIHLAVt8q+CXhXB1O1H9ceYnePq7GV4R5PjM9/IAbwBZ57tGvL4DijDZDI9run35xN3
 Aw4ribByW6n0vvgmSmtYkcPJd/xZnAlcVX7JHqOvwsoxI7O/yf7w9qD/wTxpk6Zgcsnisic72fd
 q6jzKhnH7hEn/LCz1PUUIKgwiWqX5Dh1bBaOwTuWDMdRhbdMkdXy5jIYdc58XMZfRMteP+v604y
 fhcVvEhnWNAWfyt1m8vUzrqQgctK/TfKULATpjObbrXGW3z1lZ1/wSDPp9W41wtV0Bdb5BiFPlh
 bQ+dakvrrP1tAFyHghTdii404jStTQh8bfpf717B0Dwx4d9rMHsCQ7r7sXZAR/jM+/vNLS2vaD2
 1j9wy0Hzls1nzUWHyfw==
X-Authority-Analysis: v=2.4 cv=cKh1IVeN c=1 sm=1 tr=0 ts=6aad1142 cx=c_pps
 a=//qFBHKSfAsNB7iC0FeI3Q==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22
 a=sozttTNsAAAA:8 a=Tpn98H0sjD_mw3BxSIoA:9
X-Proofpoint-ORIG-GUID: E_0NtfSK4q-5EYyl72rNm-FaCF1uI0Zo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180144

AES functions were using src and dst scatterlists directly provided by
the request. This is problematic as it is not guaranteed that the input
scatterlist is exactly the length reqired. This problem was seen in
IPSec use case when the kernel provides the scatterlist which contains
space for plaintext/ciphertext and TAG.

The problem comes when the scatterlist is mapped and sent via DMA. The
K3 UDMA sends/waits for the amount of data equal to the length of
scatterlist mapped. So when the last mapped nent contains some extra
length, the DMA keeps waiting for the extra data and eventually times
out and crashes.

Mitigate this by copying the nents to a local scatterlist, copying only
exactly cryptlen of data. Note that this does not copy the whole data,
but rather only the scatterlist mapping. So it is not as penalising on
performance.

Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
Reviewed-by: Kamlesh Gurudasani <kamlesh@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 145 ++++++++++++++++-----------------
 1 file changed, 69 insertions(+), 76 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 6a8fbe67ef6cd..be7ec62ab2513 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -108,19 +108,6 @@ enum aes_ctrl_mode_masks {
 #define POLL_TIMEOUT_INTERVAL			HZ
 
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
-{
-	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	ctx->dev = dthe_get_dev();
-	if (!dev)
-		return -ENODEV;
-
-	ctx->keylen = 0;
-
-	return 0;
-}
-
-static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
@@ -154,19 +141,24 @@ static int dthe_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
-		return -EINVAL;
-
 	ctx->keylen = keylen;
 	memcpy(ctx->key, key, keylen);
 
-	return 0;
+	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
+				       crypto_skcipher_get_flags(tfm) &
+				       CRYPTO_TFM_REQ_MASK);
+
+	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
 }
 
 static int dthe_aes_ecb_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
 	ctx->aes_mode = DTHE_AES_ECB;
 
 	return dthe_aes_setkey(tfm, key, keylen);
@@ -176,6 +168,9 @@ static int dthe_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
 	ctx->aes_mode = DTHE_AES_CBC;
 
 	return dthe_aes_setkey(tfm, key, keylen);
@@ -184,24 +179,19 @@ static int dthe_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 static int dthe_aes_ctr_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int ret = dthe_aes_setkey(tfm, key, keylen);
 
-	if (ret)
-		return ret;
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
 
 	ctx->aes_mode = DTHE_AES_CTR;
 
-	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
-	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
-				       crypto_skcipher_get_flags(tfm) &
-				       CRYPTO_TFM_REQ_MASK);
-
-	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
+	return dthe_aes_setkey(tfm, key, keylen);
 }
 
 static int dthe_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int ret;
 
 	if (keylen != 2 * AES_KEYSIZE_128 &&
 	    keylen != 2 * AES_KEYSIZE_192 &&
@@ -209,15 +199,12 @@ static int dthe_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 		return -EINVAL;
 
 	ctx->aes_mode = DTHE_AES_XTS;
-	ctx->keylen = keylen / 2;
-	memcpy(ctx->key, key, keylen);
-
-	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
-	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
-				       crypto_skcipher_get_flags(tfm) &
-				       CRYPTO_TFM_REQ_MASK);
+	ret = dthe_aes_setkey(tfm, key, keylen);
+	if (ret)
+		return ret;
 
-	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
+	ctx->keylen = keylen / 2;
+	return 0;
 }
 
 static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
@@ -340,8 +327,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int len = req->cryptlen;
+	unsigned int pad_len = 0;
 	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
+	struct scatterlist *sg;
 
 	int src_nents = sg_nents_for_len(src, len);
 	int dst_nents = sg_nents_for_len(dst, len);
@@ -384,38 +373,38 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	 * We need to handle the padding in the driver.
 	 */
 	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
-		unsigned int pad_size = AES_BLOCK_SIZE - (req->cryptlen % AES_BLOCK_SIZE);
-		u8 *pad_buf = rctx->padding;
-		struct scatterlist *sg;
-
-		len += pad_size;
+		pad_len = AES_BLOCK_SIZE - (req->cryptlen % AES_BLOCK_SIZE);
+		len += pad_len;
 		src_nents++;
 		dst_nents++;
+	}
 
-		src = kmalloc_array(src_nents, sizeof(*src), GFP_ATOMIC);
-		if (!src) {
-			ret = -ENOMEM;
-			goto aes_ctr_src_alloc_err;
-		}
-
-		sg_init_table(src, src_nents);
-		sg = dthe_copy_sg(src, req->src, req->cryptlen);
-		memzero_explicit(pad_buf, AES_BLOCK_SIZE);
-		sg_set_buf(sg, pad_buf, pad_size);
+	src = kmalloc_array(src_nents, sizeof(*src), GFP_ATOMIC);
+	if (!src) {
+		ret = -ENOMEM;
+		goto aes_src_alloc_err;
+	}
 
-		if (diff_dst) {
-			dst = kmalloc_array(dst_nents, sizeof(*dst), GFP_ATOMIC);
-			if (!dst) {
-				ret = -ENOMEM;
-				goto aes_ctr_dst_alloc_err;
-			}
+	sg_init_table(src, src_nents);
+	sg = dthe_copy_sg(src, req->src, req->cryptlen);
+	if (pad_len > 0) {
+		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
+		sg_set_buf(sg, rctx->padding, pad_len);
+	}
 
-			sg_init_table(dst, dst_nents);
-			sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
-			sg_set_buf(sg, pad_buf, pad_size);
-		} else {
-			dst = src;
+	if (diff_dst) {
+		dst = kmalloc_array(dst_nents, sizeof(*dst), GFP_ATOMIC);
+		if (!dst) {
+			ret = -ENOMEM;
+			goto aes_dst_alloc_err;
 		}
+
+		sg_init_table(dst, dst_nents);
+		sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
+		if (pad_len > 0)
+			sg_set_buf(sg, rctx->padding, pad_len);
+	} else {
+		dst = src;
 	}
 
 	tx_dev = dmaengine_get_dma_device(dev_data->dma_aes_tx);
@@ -502,19 +491,19 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 
 aes_map_src_err:
-	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE)
 		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
-		if (diff_dst)
-			kfree(dst);
-aes_ctr_dst_alloc_err:
-		kfree(src);
-aes_ctr_src_alloc_err:
-		/*
-		 * Fallback to software if ENOMEM
-		 */
-		if (ret == -ENOMEM)
-			ret = dthe_aes_do_fallback(req);
-	}
+	if (diff_dst)
+		kfree(dst);
+
+aes_dst_alloc_err:
+	kfree(src);
+aes_src_alloc_err:
+	/*
+	 * Fallback to software if ENOMEM
+	 */
+	if (ret == -ENOMEM)
+		ret = dthe_aes_do_fallback(req);
 
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
@@ -1240,6 +1229,7 @@ static int dthe_aead_decrypt(struct aead_request *req)
 static struct skcipher_engine_alg cipher_algs[] = {
 	{
 		.base.init			= dthe_cipher_init_tfm,
+		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_ecb_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
 		.base.decrypt			= dthe_aes_decrypt,
@@ -1251,7 +1241,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_priority		= 299,
 			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
 						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY,
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
@@ -1262,6 +1253,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 	}, /* ECB AES */
 	{
 		.base.init			= dthe_cipher_init_tfm,
+		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_cbc_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
 		.base.decrypt			= dthe_aes_decrypt,
@@ -1274,7 +1266,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_priority		= 299,
 			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
 						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY,
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
@@ -1284,7 +1277,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 		.op.do_one_request = dthe_aes_run,
 	}, /* CBC AES */
 	{
-		.base.init			= dthe_cipher_init_tfm_fallback,
+		.base.init			= dthe_cipher_init_tfm,
 		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_ctr_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
@@ -1309,7 +1302,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 		.op.do_one_request = dthe_aes_run,
 	}, /* CTR AES */
 	{
-		.base.init			= dthe_cipher_init_tfm_fallback,
+		.base.init			= dthe_cipher_init_tfm,
 		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_xts_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
-- 
2.34.1

