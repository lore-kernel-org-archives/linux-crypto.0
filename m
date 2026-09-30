Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3793E4C10E5;
	Wed, 30 Sep 2026 11:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767594; cv=fail; b=CC8/W8Khi+sVW8F5dq0mRom8xOSSpXw+cyriL4pWTno/z9AlRkM7p+Pco4qGIMxXNyA8qL4Xz2Ob8iSZCE+FpIrdv+BLW/jLTsws2GHCrnebrTtLq8B+rpt08faauCqc17lNpcGUqV8bbDyyhVVsvIIItH8eGfLP5+YuO5at3sE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767594; c=relaxed/simple;
	bh=UWNnQQFOWMldlulocf6By0PgAP5rrXm3/StInUh/bDg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FwCjTbc1PuKUFBFO1xDRKMGmoE0p2Z1HV7cuUxKn1gL74XMTR1Qp3DbzMOx3p4+6mNtCPMPi6WJvJjDFk9GKhEBqnkvS+ATPKXtyo+e34CBpvnqJiW0DqoA6wku0bKeFVUTHLfvim5WUCwvhTT4LXpfX8TH/H9ABrQVrmw2f12k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=gjx0wloe; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=gaRX+Z+s; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="gjx0wloe";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="gaRX+Z+s"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68UB5hiD3552586;
	Wed, 30 Sep 2026 06:26:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7
	GE=; b=gjx0wloeDQoCSaxkf8bUCyjntlJ0f96fE83IBXeswA13g5jUEFwF64Bzs
	J2t33IbSi79g8ei+ra5ifORNkn782/58MSNUY5/jKIQBxVhHt2V6hfHDjmNdm5+J
	9E+z0F3hG8sJm72vxHwzKCs6/GI7JdHeiqLGYtMWQpt3sxMacd2Fg+5Bz2fS6BVC
	tfI2SMiV8QvTpUSKonhqfHhfgTK/TFelC1X7iwhvVap299OZhkW4lQ78EvJpkuUo
	eR0cGw4t61EKFancLuaSSx4cpc2VaQ1pFAc/4GgOMhONmyNLceF39u+YhPLtdxme
	VKjsM5XVwEEcwqktfQLboZJXSuKBA==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013000.outbound.protection.outlook.com [40.93.196.0])
	by m0384305.ppops.net (PPS) with ESMTPS id 4h10s208g3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 06:26:25 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L0uSdAuYAhtJr/Ws8QxlF4SM9LlBTH7Q+FaOho8qZG63f2YB9Q/qOs6OXUmGtYKekZst/0ZZkwWwRGCg4SxkrC/tsMPp/QQE+IUPdGaIFkoLBNF680tHdIUFS+Y/0edrO1xkT4sCB5O62sWx4HFbvPXr19aVr3U5dwGCwDtZmkzbmtnsNF2F5PmDJgE/v8s4OQRwhMXflbRAd0ttDaz6NUNySRsg26yCy8F5n7ETPMjEeejr3j7yazR5ZHTtrcAkZ1BsF0NQxfG7ejs7a/LtcFAkTHapk5bshHfTBY+DZIEErkgh2GkiSD3iF9YjLNFjqXlxw8RJnYIhqDqcFSzT4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7GE=;
 b=rekUsjC9wulo18dPTxsevhfXdKt6CZBtRqjtnqzd+Unqd5J1HTdScEHIY7zg9tIaITOVB5WpQESVntS3NvIFNZgnqLifZqQ4gcpvvCsRFKzQeK0CF3jeM3FgnpXxLLuexfhJSm2TD84QDQi0Hyo8AF9OUPxxO/hpz02KmQ+G4cJHJsEhAb7ftBS+jvrlFhcGa1qJcMtrX3bQtAaPyELrjXW/s7W902mNfRMU93+XR+y03co8GEp0/CpbwdwC+4zEjgHgLLCPZg17tIMj+ZVfnajz81Pn7imrFYvxuN0yFTUYPnoCbImSV7u2OYCQnJsvQglPv1OJPpZU2EbAFMprMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7GE=;
 b=gaRX+Z+sdzeuZBxJBRsq5PCALNC5jMjr7VfGVumbKPGoQ7/o7rh86cFYJdkFng3q4aqh5ww6jtqQ8ozv8elWneYt72hAb/OkQBd9xgLkhxU3cj87/E7XP77SQB+GeOPAvA+70PJbFzDTRpVrHsG8XuhOWu7gO4QkA5VIwWH1ioU=
Received: from BN0PR10CA0005.namprd10.prod.outlook.com (2603:10b6:408:143::19)
 by PH8PR10MB6549.namprd10.prod.outlook.com (2603:10b6:510:227::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.14; Wed, 30 Sep
 2026 11:26:22 +0000
Received: from LV8PEPF00000069.namprd03.prod.outlook.com
 (2603:10b6:408:143:cafe::26) by BN0PR10CA0005.outlook.office365.com
 (2603:10b6:408:143::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.15 via Frontend Transport; Wed,
 30 Sep 2026 11:26:22 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 LV8PEPF00000069.mail.protection.outlook.com (10.167.248.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:26:21 +0000
Received: from DFLE212.ent.ti.com (10.64.6.70) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:25:46 -0500
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:25:46 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 06:25:46 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UBPi6N3025039;
	Wed, 30 Sep 2026 06:25:45 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Mert Seftali <mertsftl@gmail.com>, Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        kernel test robot <lkp@intel.com>,
        "Dan
 Carpenter" <error27@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 01/15] crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()
Date: Wed, 30 Sep 2026 16:55:19 +0530
Message-ID: <20260930112533.1593952-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930112533.1593952-1-t-pratham@ti.com>
References: <20260930112533.1593952-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF00000069:EE_|PH8PR10MB6549:EE_
X-MS-Office365-Filtering-Correlation-Id: 25f24b0d-8644-482e-cf75-08df1ee5a793
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|82310400026|36860700016|18002099003|22082099003|13003099007|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	F7S0DpYMg5afX66BX6cWBmIwHIVmMrH5ROZIw8MtJrTqFzYGNTkmayhL5Cz2OkzQXb8kGXqNa7GZ1+2fihybOlPG5qXW8Cd9s2+dYiUGWFPjj4S7UNMGc6uoUtVyRxX33Q0L6r9a4tJYpfArFfhGIpy2grs6DMENGIaHk87g0aCeQokk06Kwb5E5A4KIYlve26Jn/LkbZfaOpRk+ZMvxTDFSqWHXpzhxmbYFJNBD3CXdhuSHmMSnLeYUU//R/heqS8I/BEcI41KelfF3ixA52RXi68BAzCMvHOJRi0K7kI8qr25LgVNathzZFuL/0j8kmaDBLWPK4wCJA1Nu/AEdyV4K0AQTkvkfCKwKC6C8anjIEZud9D3GyGmvWctvc7AARvnhFPpEFGIgaf70eQjqj7vmyikWNlBaArD+JVkbZ9eYewsqvv+E64+EJupH7jcN3s3Sf7Z1oRblFvkmaDKL1DVib9pe7y0aLsZrou8ZjNhZV0gz1zgQGY7siNFQddFkY1Ei9IhdJp8LN1G9mz7omij6Gif7CcDYeg8kUz007LHx155hGZGdPcTA+7J4JNqk8nmlBk9s81aUU4FoxoiAiLYdavGfUOGxE3W8e2muq9rm4QGIrYXDt93tMyT9D71uAs5wAQMyzApUiKNx64Rx/Q==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(82310400026)(36860700016)(18002099003)(22082099003)(13003099007)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HmtdBlife6WoHKjDz2QAQsy1dREd0hA9RVfGjTVPnXAvnheCofRxqYzJH0cbazqfUHUF1iflCF6DHfJyFYTFhSPWa9No6EKyO0vCjPAS8wMMqQCnDL7zVNoU3UD16SmYbkf/Vi0+cDqGqvyCAQMNskO1g1OlH7N6uCDWBRV1y8llZH4RrDsG9aHhaIeGcv8fLmiA+rOA4BZIyfv7FfWTfnxLDyMGYkUP3jC1EKwsaArxJgdHCQiz7q0ZezwtzL3qXtJhSYPMyV5I+wARRAliKD60hwoyC+ZV1mZD9dn/8rG2Oha3TY/ERx611wOUMM6S0C9ec68IP6PUHtU3qhuAHddEzzf6dJZL5FI1ZWPpyLA57skmhkDZ49hpl6UsRcvTiIBP6tjfTojB8RqijCMgothTygSudJhAMejMYR8W3z8/6BWiJZApA7Fe7iP4tSbz
X-Exchange-RoutingPolicyChecked:
	MfPvwZlFujEtNESXDy2We5tUR3nBvPCOmyt+UOtKp9x8f0LuRfhVk2CDiPVcmZfuRvnBl1vRtfnvyDhj08WW0UTo7gtKuoA7l8TavllfHW1v2+LNI8DxUzLkb/OQiW9t6SwzmP2nfHPwUCD6TgHATkwi9GNNofv2g73YY8EuWpJt/ij7Y1zmW+8n24kf7SNiddsUf8iIndbj1vqxW73Q921IQjPeWg0nthfKN58Gh5YyOpyLareAkNkZVOKbHmhCFLNMQ5M6DDoZXF8QqDj4ebP7RcK/rNm8hojnUcomHkuPEbM7ANH5NLL2UvifRbBBaxBICRKck/78aZcQyCiYZA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:26:21.6411
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25f24b0d-8644-482e-cf75-08df1ee5a793
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000069.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6549
X-Proofpoint-GUID: 7sedVPXVPriRt8mEMwuVxrpzoDSFwzR5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX+ds3rA+z95gJ
 Nn4/4yxO1fS96z6wfcXsiNEeQijLVPgySbJvFX/piMMMCF1fG2W0eFVJO6chD6d8ZjQEZsdlqWB
 dEjAuoYRrNSpHLo3g6Ptg/5IlJUpbj5mSsMhaS9Dv7b4eMD4yFKga5l//nQBIFhqomQfeEe1TvA
 ID3wWtvp6ph2rc+lUbpTNyt9I3iHOpNadomkmGcrawcuTVdoR2YwsmMqLW2dkiMgYIG/dfFaXxm
 w3vU4+K8apbPsJoLuodq5VsjapiDYAkcimN4QlgwGSMvB0hvEnEiqo1ptiQ72MUyZk58OoGqJ91
 GKhymcNnobQvZOXHBoY7742YrIGtYyEtR5v1+SNyHF5/YLN+67XNyI9yWiRKlq0CSyLFu2vKuZW
 ZqGBVKTsUlU8WOjyk7qsnorJ4rY3DlSMmYjweJIS4cVFmWZgsLeoiWPx9k3AcAnI3EPPaKMgud9
 BWEyZBI1s9LjP0YZkkw==
X-Proofpoint-ORIG-GUID: 7sedVPXVPriRt8mEMwuVxrpzoDSFwzR5
X-Authority-Analysis: v=2.4 cv=G6aJgNk5 c=1 sm=1 tr=0 ts=6abcf1e1 cx=c_pps
 a=9AjoWhdl+q7f6/Aw5qa/DQ==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=sozttTNsAAAA:8
 a=HYHyqeARaHjSmq2Pe6sA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfXyyhgQpz3fcUf
 95IL3+vVdbAXTSufH5n07tRFgFVidRr627siDLx4fL1RjACsU5gukrPSvsSyfD2ezwWACr/M5wo
 +yeh2FtRnXhZzvPweJBT19pm88Zwgvo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300045

From: Mert Seftali <mertsftl@gmail.com>

dthe_get_dev() fetches a device from the global device list with
list_first_entry() and then checks the result for NULL. However,
list_first_entry() never returns NULL: on an empty list it returns a
bogus pointer computed from the list head. The NULL check is therefore
dead code, and an empty list would be treated as a valid entry and
moved around as if it were a real device.

Use list_first_entry_or_null() so the existing NULL check works as
intended and an empty list is handled gracefully.

[pratham:]
Add null checks on dev_data in callers of dthe_get_dev().

Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202606111933.69GGTKxr-lkp@intel.com/
Signed-off-by: Mert Seftali <mertsftl@gmail.com>
Co-developed-by: T Pratham <t-pratham@ti.com>
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 12 ++++++++++--
 drivers/crypto/ti/dthev2-common.c |  2 +-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index eb5cd902dfb59..4fdd24ee91637 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -112,6 +112,9 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
@@ -124,6 +127,9 @@ static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
@@ -571,10 +577,12 @@ static int dthe_aead_init_tfm(struct crypto_aead *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
 
-	ctx->dev_data = dev_data;
+	if (!dev_data)
+		return -ENODEV;
 
-	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
+	ctx->dev_data = dev_data;
 
 	ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index ba6cde75d3611..cb4b8b38a5ec8 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -39,7 +39,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 		return ctx->dev_data;
 
 	spin_lock_bh(&dthe_dev_list.lock);
-	dev_data = list_first_entry(&dthe_dev_list.dev_list, struct dthe_data, list);
+	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
 	if (dev_data)
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
 	spin_unlock_bh(&dthe_dev_list.lock);
-- 
2.34.1

