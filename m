Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B714A13A0;
	Tue, 15 Sep 2026 09:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466269; cv=fail; b=gJjRsbEmXLGhk1BAOZODo2XRnHB5G3tN0KJMAW/iz2K2OICHda1u4EHe8HYOARzwqPPA9xWUpQ57lNzTpO1FcFLRyacI2ocWvzEQS1fIxw+UUuF02/q3M2p2oFonsLZBCUz1H+z7Yaqm5+q9WGp/DwTfaoNlnV1xBYId0+/fYfE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466269; c=relaxed/simple;
	bh=pqseqOuOMOhZwjIze1OBP//HbmrgcLJHJrVCOlX4Izs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=atE3BIWrwWf70j9aMPigNYhUTXgGQDm2JLRKdveV30ydLiTpoIqQbqIDvZgOfQEHYxEZ3+39y9f9xFrr8+lF6mSqv06S9EOEGRr+6x+fIGwAd0uY81o7p4T42qV3vWq0gEElDdK8bkz7W5GsDDHm47q059sNieSBDHVpzzoIbHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=k2LjfrbI; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=lxrbyxD0; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="k2LjfrbI";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="lxrbyxD0"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68F9ejHU1480546;
	Tue, 15 Sep 2026 04:57:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=s7/W3a1LIbgwkhfqSqj3Z21+8/+SpW8T1QEY+SFxu
	DE=; b=k2LjfrbIopi9st/JCrFQK4Sjd3ipnxyzheE9vgPKyv3exyjwBSKjWIybP
	DdJA34UjmSLVw1tJUqAndmUFA27dEImcs+/mmTDZjN0PG8TP+W+A8WB9EgLKWog7
	/SijfWL1DYGJz+Ua/p4yl8WmHh6mpalTHwG3VN8v5Z3pQM1wjJvxZ174eOzjSOB1
	axDazNr5aaRvJZZze5I+5QPQfRhUcGJ4T2xlfc5V9KCGzh8iGrFfg5bsIp+GKVn+
	Q9wyrWyeZB24AC6fAdSFzPXvQ/7xuAbbtQOABpidMwUbrJNhJ9buul0WC2k9YKZv
	NhEXbchmy0tklyUJVHCXWr5wcb7gw==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010002.outbound.protection.outlook.com [52.101.61.2])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gpvpa2j71-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:57:42 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pwB7tI+S0zonaNu4+IT7kqFxPSH2G2sGfwTAdd7yu6GRbqC+Sv23r679EZL6emjV2RoZ7972q3QCcizXe3yC6pKIbM+K5HomylMCJLHV+PXeK3sHjTNloQOgwxfRvHVAJbVYr2SIohzH1mgp3iZLsLBoMNjEsNDtADGjwJIyzzy69/riVdm3djh3Npupb/RRVGILRfVGDKCRYxeFoz+2ow/zfnZGXQUYPL1Eq7S7VOVM0ZFmmL8sbpssR0PM+kVI14FAZ3NQhbThlb/gIscQrNkJLc6cCLOCLTZZSrKQdihnjIyzuI+ZPOq2uR3CGeMcmeOvYomw4b/FaAk/E8TagQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7/W3a1LIbgwkhfqSqj3Z21+8/+SpW8T1QEY+SFxuDE=;
 b=gwL7TRWauDkKQPbKOjo3fw/hbWCqoDuXf4gF9EvFNt9b/RQZ5EH70z6hVZMf/uSGz5jAw1RqnGMqbl4u2Mub69p2j+kAyBeGpLOLSOvb+KKAm/80jYNN8dNSxBf1hddSmF7gAActI275ZgFl4iQ9jzvol/iMoO+8xSnxtAsjt0bllhIL4d+e4GAh9f891/kjXyCPesxDKuX/jGWnc5K82nqIs6BbtIOQvx5d+elbJ2afGOa8D98KAVAUiXk4LSSTd/0sjxwOfVgh46eaCoS0cInpUpIsWCUnsVWJgc9SLp/4e/U7mZ6cMq06wCQYwde1Dumk9hqDsKUVEpqoxImpkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7/W3a1LIbgwkhfqSqj3Z21+8/+SpW8T1QEY+SFxuDE=;
 b=lxrbyxD0fwh5JBGq1nB0LXV+gPx2ePZIaQDD1bEjE1ZdT2GONJFMbpHDnosC17RNJeM92ZV3zm7byCr8YUHNQIKgQgHNC6317CHAD13exv/We+DL+jvO6FRdhHfbKsd4vBF5nvpP16t846++d41UHsAUJCvgqfZt2zzQj2/NfG8=
Received: from SJ0PR05CA0175.namprd05.prod.outlook.com (2603:10b6:a03:339::30)
 by DM6PR10MB4137.namprd10.prod.outlook.com (2603:10b6:5:217::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 09:57:35 +0000
Received: from MWH0EPF000C6189.namprd02.prod.outlook.com
 (2603:10b6:a03:339:cafe::4b) by SJ0PR05CA0175.outlook.office365.com
 (2603:10b6:a03:339::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Tue,
 15 Sep 2026 09:57:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 MWH0EPF000C6189.mail.protection.outlook.com (10.167.249.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:57:33 +0000
Received: from DFLE204.ent.ti.com (10.64.6.62) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:47 -0500
Received: from DFLE209.ent.ti.com (10.64.6.67) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:47 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE209.ent.ti.com
 (10.64.6.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:46 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB8I3000901;
	Tue, 15 Sep 2026 04:56:43 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:34 +0530
Subject: [PATCH 28/30] crypto: sa2ul - route requests through crypto_engine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-28-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=30001;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=pqseqOuOMOhZwjIze1OBP//HbmrgcLJHJrVCOlX4Izs=;
 b=o2tRV2uf3McMRHro3K7tiwhSuLdWykIaPawisDzUBTKFAaYDfn8PdkOSmIe/UCrwREgdaDdZv
 zWsRYUZpKFaDnEr7vZp1OaQMCxmIWakYtTm8YqG4v5CWOH7PPwWgtoj
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6189:EE_|DM6PR10MB4137:EE_
X-MS-Office365-Filtering-Correlation-Id: ef02c08a-6173-49e9-ef65-08df130fc363
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|376014|82310400026|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	WHFwSFl13WDXne2lIQO530l5EoZVFwFLxJsP3CFAg3/pwMWSQb3iEqyp+HKm+8eYZmigAO4rRx6yRBsZId4jKtCBQ/I3t2FdSM60id1APkJA3S/Ubh19UloZYCjpLqFyyh3/iWuQwa+ItuYiDVom5QOH3UzKfHrXmzdpqX1w+KbrNbQSgsr2QLrTjanxXZZ5Q28Y4kIWhQYcQjgztiAjW4U1Jrvx0BhI8uSuSV6QneBNIAcuvL1njvNGaEi9NNVHgAgzAneFKIF2VlL2e9DbaFzCnvNaNzvKiHcwBuePSl6NcR+bTpRF6B+gqQD2lpF+8PwA2PF719kds3DbJW78/hp+s8j41qG2kebEYxWbRGjRI5hW4T7wNYin+4DlJGqzJegr2sgOYqg2bZU8Mfi+v8MMF+2X7D1pW7pXLsUpNvoztdP4tLkXmixalKA+IBQw1v+UKAOrgs2CMMhJ4QG8g5TIqkvfnrHMPoDnoEmdEpnc0Q42b0nD0FrylqFpzcN9x7uBMV0zoafKqNzYtZJfg+/OFiKuesAkATCpYrVwht+Tkh6TVP7SpX3C2W3miEDe2HlfoWEidygOZuDoTRTfNTKoJxK8kKNQk58QIkr3H0bPaNU4D7g688JvDWV3m58S7lw05SKJ6EfkR8+QpCJn007waayCkOqnmAtLeX5yBL/V17VcJ1a2GiVveZMAHo9s48AC46MCuCBf7e3roeIcHQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(376014)(82310400026)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GqjQVdzvkRWY6WOCb/5ESHHwMN1TRyuWWg1CZSQdjyXKSOqedO/yMl1RN0Wz9NW6/XiBI3QJcdHJlRxCbuRDQbN6xAjgmklaK/2Z8tG61Md7PeMFJHMPtWJpqtMzjuGHgAG1XiBOiJb8yn1fi80QXUDIYcr6n/assB1zAJsRoho3McuTzdatfNr4pxAxdci17DbraG8ZVoXa3p/HoTIPlZL8iB4kZH2ME/qztQjIu/+ytxSOcixzFQpxtgaSumEYfcMqxcI7LLkNSeSrSWwAlLQBMRarJ/aYLo0x0YttF4wiTE8e7RixHqE31PjWNgr2qnQWrUTu90XeicdoBPRThL+osEbcPA2CcCr/A8XrGgS3bPr6FP405BbLHn7TQe70uygfLw52HqixRzR+aG7KjKTZZw8Z2QMXTEnx3ue6kGFWlCIeGDhcbOkW3NaxAnvV
X-Exchange-RoutingPolicyChecked:
	NcIxrlr4EfGwv9OliN0pg0GAXnA597+/d0zmOHD+nAy+tdGusOy+fkW3FYjYd1R+JH+d5ck2X9ctE8Xh3M92UslVRLGdDypOsn8QuFNeVt6NkMNqLu+TZeT5f3BLRL3rqG5MJwPJMpw00+6ccqcb7rr0HORZAIgkC5SxoWe9u3yStvsPj0ZNWaZxxzLhaR5/BQkOUwcJH4Dkp3ECbCB0ti5AfMy5CnwZp1vePEMb/hEtkEMw/SGFUmHKwxersvfBYD3woKiJo4rfA0ESh2EuW4P7O+HcMouQw8flDyP4u/YxrY7cg84E4mVejjC8Tl25K4oWrjdaflg7ynr9fmTkSQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:57:33.2093
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef02c08a-6173-49e9-ef65-08df130fc363
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6189.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4137
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX98i3JH6iGujT
 BAJPb/WYD3ECIm734ae7XftiDW/LPvxlmyn2e6PVGRjt+9ozI25v7d9LUpRZrmWUpZqEsOOMbtl
 aS4+uQ+sBjfT/Xj7YXQ7Tv+Z1YTDFZmrCdvzrSiCfVbCjgAmAQK88b0Ky9wWbWQtrPhAQWzedpm
 Ji0njZ3mwK+gvoEtA24q7HtDjVpQsaV4yuqdlsDnEabxm8cE3o78xvWFEGgIynDoMFSS7FnBSho
 DESJZXMpcr5w9PaXyFN507rda2zn7hoMKdhhdRyDudzAvlxKY4X/fOGnCh9yX5GxZVpQIjN4fOE
 EocYPb9crEe3+fa50yS0nhcuEJOvCqJO5ONHTay/aSBVPQIM/wvzv5bf7rUm58Kq5B8k28Rm6nW
 tfH+mmRDW3dbWWQk/wPnYSEAk8GpZ4bJDPVPzjViK/5Zi6kfTxyM6xbfHK4iwKyKFn2hX/ClzBI
 UHHnlacpwxMX+OUspYA==
X-Proofpoint-ORIG-GUID: B_BxtsuwM75YRmlPEr7rabJu8HvLrnBt
X-Authority-Analysis: v=2.4 cv=U7cHnuru c=1 sm=1 tr=0 ts=6aa91696 cx=c_pps
 a=h3cS895ItAADrFIx/0pANw==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=7j_cNkhbxLCtgoFIOCQA:9
 a=QEXdDO2ut3YA:10 a=ZT8lLOp2prkQlNvCk5ZN:22
X-Proofpoint-GUID: B_BxtsuwM75YRmlPEr7rabJu8HvLrnBt
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX9tjLvcio4JyV
 5QcjE44xMACM4g+w9jaLSqCC/8ArEFS5FRg2Kyo3l/wzDGSjU4P3On1Obbm+Zj7rpZzIQHen8kx
 2tbJrE8JGdWyflyiBw3WCCTQ+LxVwXU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

SA2UL previously submitted skcipher, ahash, and aead requests directly
from crypto_alg callbacks. This mixes sleepable and atomic request
contexts on the same hardware queue and gives concurrent callers no
serialization against the single security accelerator.

Register a struct crypto_engine per SA2UL instance and convert each
skcipher/ahash/aead algorithm to submit through
crypto_transfer_{skcipher,hash,aead}_request_to_engine() with a
matching do_one_request() callback. The engine now serializes all HW
submissions to SA2UL, so requests from different contexts no longer
race on the same crypto accelerator queue.

Select CRYPTO_ENGINE in Kconfig and add engine allocation/start in
probe and engine_exit in the remove/error paths.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/Kconfig |   1 +
 drivers/crypto/sa2ul.c | 536 +++++++++++++++++++++++++++++--------------------
 drivers/crypto/sa2ul.h |  22 ++
 3 files changed, 339 insertions(+), 220 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 0189dfdcbbe1..c9596f0c9087 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -816,6 +816,7 @@ config CRYPTO_DEV_SA2UL
 	select CRYPTO_ALGAPI
 	select CRYPTO_AUTHENC
 	select CRYPTO_DES
+	select CRYPTO_ENGINE
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index cadc8db14bbb..d92ba1f581c0 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -33,6 +33,7 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
+#include <crypto/engine.h>
 
 #include "sa2ul.h"
 
@@ -150,9 +151,9 @@ struct algo_data {
 struct sa_alg_tmpl {
 	u32 type;		/* CRYPTO_ALG_TYPE from <linux/crypto.h> */
 	union {
-		struct skcipher_alg skcipher;
-		struct ahash_alg ahash;
-		struct aead_alg aead;
+		struct skcipher_engine_alg skcipher;
+		struct ahash_engine_alg ahash;
+		struct aead_engine_alg aead;
 	} alg;
 	bool registered;
 };
@@ -914,8 +915,8 @@ static int sa_cipher_cra_init(struct crypto_skcipher *tfm)
 	}
 
 	ctx->fallback.skcipher = child;
-	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(child) +
-					 sizeof(struct skcipher_request));
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct sa_cipher_req_ctx) +
+					 crypto_skcipher_reqsize(child));
 
 	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(0x%pad), 0x%x(0x%pad))\n",
 		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
@@ -1086,6 +1087,7 @@ static void sa_free_sa_rx_data(struct sa_rx_data *rxd)
 static void sa_aes_dma_in_callback(void *data)
 {
 	struct sa_rx_data *rxd = data;
+	struct sa_crypto_data *pdata = dev_get_drvdata(sa_k3_dev);
 	struct skcipher_request *req;
 	u32 *result;
 	__be32 *mdptr;
@@ -1106,7 +1108,7 @@ static void sa_aes_dma_in_callback(void *data)
 
 	sa_free_sa_rx_data(rxd);
 
-	skcipher_request_complete(req, 0);
+	crypto_finalize_skcipher_request(pdata->engine, req, 0);
 }
 
 static int
@@ -1337,12 +1339,19 @@ static int sa_run(struct sa_req *req)
 	return ret;
 }
 
-static int sa_cipher_run(struct skcipher_request *req, u8 *iv, int enc)
+static int sa_run_one(struct sa_req *req)
+{
+	int ret = sa_run(req);
+
+	return ret == -EINPROGRESS ? 0 : ret;
+}
+
+static int sa_cipher_run(struct skcipher_request *req, int enc)
 {
 	struct sa_tfm_ctx *ctx =
 	    crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
 	struct crypto_alg *alg = req->base.tfm->__crt_alg;
-	struct sa_req sa_req = { 0 };
+	struct sa_cipher_req_ctx *rctx = skcipher_request_ctx(req);
 
 	if (!req->cryptlen)
 		return 0;
@@ -1354,7 +1363,7 @@ static int sa_cipher_run(struct skcipher_request *req, u8 *iv, int enc)
 	if (req->cryptlen > SA_MAX_DATA_SZ ||
 	    (req->cryptlen >= SA_UNSAFE_DATA_SZ_MIN &&
 	     req->cryptlen <= SA_UNSAFE_DATA_SZ_MAX)) {
-		struct skcipher_request *subreq = skcipher_request_ctx(req);
+		struct skcipher_request *subreq = &rctx->fallback_req;
 
 		skcipher_request_set_tfm(subreq, ctx->fallback.skcipher);
 		skcipher_request_set_callback(subreq, req->base.flags,
@@ -1368,33 +1377,46 @@ static int sa_cipher_run(struct skcipher_request *req, u8 *iv, int enc)
 			return crypto_skcipher_decrypt(subreq);
 	}
 
+	rctx->enc = enc;
+
+	return crypto_transfer_skcipher_request_to_engine(ctx->dev_data->engine, req);
+}
+
+static int sa_cipher_do_one_req(struct crypto_engine *engine, void *areq)
+{
+	struct skcipher_request *req = container_of(areq, struct skcipher_request, base);
+	struct sa_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	struct sa_cipher_req_ctx *rctx = skcipher_request_ctx(req);
+	struct sa_req sa_req = { 0 };
+
 	sa_req.size = req->cryptlen;
 	sa_req.enc_size = req->cryptlen;
 	sa_req.src = req->src;
 	sa_req.dst = req->dst;
-	sa_req.enc_iv = iv;
+	sa_req.enc_iv = req->iv;
 	sa_req.type = CRYPTO_ALG_TYPE_SKCIPHER;
-	sa_req.enc = enc;
+	sa_req.enc = rctx->enc;
 	sa_req.callback = sa_aes_dma_in_callback;
 	sa_req.base = &req->base;
 	sa_req.ctx = ctx;
 
-	return sa_run(&sa_req);
+	return sa_run_one(&sa_req);
 }
 
 static int sa_encrypt(struct skcipher_request *req)
 {
-	return sa_cipher_run(req, req->iv, 1);
+	return sa_cipher_run(req, 1);
 }
 
 static int sa_decrypt(struct skcipher_request *req)
 {
-	return sa_cipher_run(req, req->iv, 0);
+	return sa_cipher_run(req, 0);
 }
 
 static void sa_sha_dma_in_callback(void *data)
 {
 	struct sa_rx_data *rxd = data;
+	struct sa_crypto_data *pdata = dev_get_drvdata(sa_k3_dev);
 	struct ahash_request *req;
 	struct crypto_ahash *tfm;
 	unsigned int authsize;
@@ -1416,7 +1438,7 @@ static void sa_sha_dma_in_callback(void *data)
 
 	sa_free_sa_rx_data(rxd);
 
-	ahash_request_complete(req, 0);
+	crypto_finalize_hash_request(pdata->engine, req, 0);
 }
 
 static int zero_message_process(struct ahash_request *req)
@@ -1445,7 +1467,6 @@ static int sa_sha_run(struct ahash_request *req)
 {
 	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
 	struct sa_sha_req_ctx *rctx = ahash_request_ctx(req);
-	struct sa_req sa_req = { 0 };
 	size_t auth_len;
 
 	auth_len = req->nbytes;
@@ -1468,8 +1489,17 @@ static int sa_sha_run(struct ahash_request *req)
 		return ret;
 	}
 
-	sa_req.size = auth_len;
-	sa_req.auth_size = auth_len;
+	return crypto_transfer_hash_request_to_engine(ctx->dev_data->engine, req);
+}
+
+static int sa_sha_do_one_req(struct crypto_engine *engine, void *areq)
+{
+	struct ahash_request *req = container_of(areq, struct ahash_request, base);
+	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct sa_req sa_req = { 0 };
+
+	sa_req.size = req->nbytes;
+	sa_req.auth_size = req->nbytes;
 	sa_req.src = req->src;
 	sa_req.dst = req->src;
 	sa_req.enc = true;
@@ -1478,7 +1508,7 @@ static int sa_sha_run(struct ahash_request *req)
 	sa_req.ctx = ctx;
 	sa_req.base = &req->base;
 
-	return sa_run(&sa_req);
+	return sa_run_one(&sa_req);
 }
 
 static int sa_sha_setup(struct sa_tfm_ctx *ctx, struct  algo_data *ad)
@@ -1689,6 +1719,7 @@ static void sa_sha_cra_exit(struct crypto_tfm *tfm)
 static void sa_aead_dma_in_callback(void *data)
 {
 	struct sa_rx_data *rxd = data;
+	struct sa_crypto_data *pdata = dev_get_drvdata(sa_k3_dev);
 	struct aead_request *req;
 	struct crypto_aead *tfm;
 	unsigned int start;
@@ -1722,7 +1753,7 @@ static void sa_aead_dma_in_callback(void *data)
 
 	sa_free_sa_rx_data(rxd);
 
-	aead_request_complete(req, err);
+	crypto_finalize_aead_request(pdata->engine, req, err);
 }
 
 static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
@@ -1751,7 +1782,7 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
 		return PTR_ERR(ctx->fallback.aead);
 	}
 
-	crypto_aead_set_reqsize(tfm, sizeof(struct aead_request) +
+	crypto_aead_set_reqsize(tfm, sizeof(struct sa_aead_req_ctx) +
 				crypto_aead_reqsize(ctx->fallback.aead));
 
 	ret = sa_init_ctx_info(&ctx->enc, data);
@@ -1897,11 +1928,11 @@ static int sa_aead_cbc_sha256_setkey(struct crypto_aead *authenc,
 	return sa_aead_setkey(authenc, key, keylen, &ad);
 }
 
-static int sa_aead_run(struct aead_request *req, u8 *iv, int enc)
+static int sa_aead_run(struct aead_request *req, int enc)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct sa_tfm_ctx *ctx = crypto_aead_ctx(tfm);
-	struct sa_req sa_req = { 0 };
+	struct sa_aead_req_ctx *rctx = aead_request_ctx(req);
 	size_t auth_size, enc_size;
 
 	enc_size = req->cryptlen;
@@ -1915,7 +1946,7 @@ static int sa_aead_run(struct aead_request *req, u8 *iv, int enc)
 	if (auth_size > SA_MAX_DATA_SZ ||
 	    (auth_size >= SA_UNSAFE_DATA_SZ_MIN &&
 	     auth_size <= SA_UNSAFE_DATA_SZ_MAX)) {
-		struct aead_request *subreq = aead_request_ctx(req);
+		struct aead_request *subreq = &rctx->fallback_req;
 		int ret;
 
 		aead_request_set_tfm(subreq, ctx->fallback.aead);
@@ -1930,265 +1961,314 @@ static int sa_aead_run(struct aead_request *req, u8 *iv, int enc)
 		return ret;
 	}
 
+	rctx->enc = enc;
+
+	return crypto_transfer_aead_request_to_engine(ctx->dev_data->engine, req);
+}
+
+static int sa_aead_do_one_req(struct crypto_engine *engine, void *areq)
+{
+	struct aead_request *req = container_of(areq, struct aead_request, base);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct sa_tfm_ctx *ctx = crypto_aead_ctx(tfm);
+	struct sa_aead_req_ctx *rctx = aead_request_ctx(req);
+	struct sa_req sa_req = { 0 };
+	size_t auth_size, enc_size;
+
+	enc_size = req->cryptlen;
+	auth_size = req->assoclen + req->cryptlen;
+
+	if (!rctx->enc) {
+		enc_size -= crypto_aead_authsize(tfm);
+		auth_size -= crypto_aead_authsize(tfm);
+	}
+
 	sa_req.enc_offset = req->assoclen;
 	sa_req.enc_size = enc_size;
 	sa_req.auth_size = auth_size;
 	sa_req.size = auth_size;
-	sa_req.enc_iv = iv;
+	sa_req.enc_iv = req->iv;
 	sa_req.type = CRYPTO_ALG_TYPE_AEAD;
-	sa_req.enc = enc;
+	sa_req.enc = rctx->enc;
 	sa_req.callback = sa_aead_dma_in_callback;
 	sa_req.base = &req->base;
 	sa_req.ctx = ctx;
 	sa_req.src = req->src;
 	sa_req.dst = req->dst;
 
-	return sa_run(&sa_req);
+	return sa_run_one(&sa_req);
 }
 
 /* AEAD algorithm encrypt interface function */
 static int sa_aead_encrypt(struct aead_request *req)
 {
-	return sa_aead_run(req, req->iv, 1);
+	return sa_aead_run(req, 1);
 }
 
 /* AEAD algorithm decrypt interface function */
 static int sa_aead_decrypt(struct aead_request *req)
 {
-	return sa_aead_run(req, req->iv, 0);
+	return sa_aead_run(req, 0);
 }
 
 static struct sa_alg_tmpl sa_algs[] = {
 	[SA_ALG_CBC_AES] = {
 		.type = CRYPTO_ALG_TYPE_SKCIPHER,
 		.alg.skcipher = {
-			.base.cra_name		= "cbc(aes)",
-			.base.cra_driver_name	= "cbc-aes-sa2ul",
-			.base.cra_priority	= 30000,
-			.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_NEED_FALLBACK,
-			.base.cra_blocksize	= AES_BLOCK_SIZE,
-			.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
-			.base.cra_module	= THIS_MODULE,
-			.init			= sa_cipher_cra_init,
-			.exit			= sa_cipher_cra_exit,
-			.min_keysize		= AES_MIN_KEY_SIZE,
-			.max_keysize		= AES_MAX_KEY_SIZE,
-			.ivsize			= AES_BLOCK_SIZE,
-			.setkey			= sa_aes_cbc_setkey,
-			.encrypt		= sa_encrypt,
-			.decrypt		= sa_decrypt,
+			.base = {
+				.base.cra_name		= "cbc(aes)",
+				.base.cra_driver_name	= "cbc-aes-sa2ul",
+				.base.cra_priority	= 30000,
+				.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
+							  CRYPTO_ALG_KERN_DRIVER_ONLY |
+							  CRYPTO_ALG_ASYNC |
+							  CRYPTO_ALG_NEED_FALLBACK,
+				.base.cra_blocksize	= AES_BLOCK_SIZE,
+				.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+				.base.cra_module	= THIS_MODULE,
+				.init			= sa_cipher_cra_init,
+				.exit			= sa_cipher_cra_exit,
+				.min_keysize		= AES_MIN_KEY_SIZE,
+				.max_keysize		= AES_MAX_KEY_SIZE,
+				.ivsize			= AES_BLOCK_SIZE,
+				.setkey			= sa_aes_cbc_setkey,
+				.encrypt		= sa_encrypt,
+				.decrypt		= sa_decrypt,
+			},
+			.op.do_one_request = sa_cipher_do_one_req,
 		}
 	},
 	[SA_ALG_EBC_AES] = {
 		.type = CRYPTO_ALG_TYPE_SKCIPHER,
 		.alg.skcipher = {
-			.base.cra_name		= "ecb(aes)",
-			.base.cra_driver_name	= "ecb-aes-sa2ul",
-			.base.cra_priority	= 30000,
-			.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_NEED_FALLBACK,
-			.base.cra_blocksize	= AES_BLOCK_SIZE,
-			.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
-			.base.cra_module	= THIS_MODULE,
-			.init			= sa_cipher_cra_init,
-			.exit			= sa_cipher_cra_exit,
-			.min_keysize		= AES_MIN_KEY_SIZE,
-			.max_keysize		= AES_MAX_KEY_SIZE,
-			.setkey			= sa_aes_ecb_setkey,
-			.encrypt		= sa_encrypt,
-			.decrypt		= sa_decrypt,
+			.base = {
+				.base.cra_name		= "ecb(aes)",
+				.base.cra_driver_name	= "ecb-aes-sa2ul",
+				.base.cra_priority	= 30000,
+				.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
+							  CRYPTO_ALG_KERN_DRIVER_ONLY |
+							  CRYPTO_ALG_ASYNC |
+							  CRYPTO_ALG_NEED_FALLBACK,
+				.base.cra_blocksize	= AES_BLOCK_SIZE,
+				.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+				.base.cra_module	= THIS_MODULE,
+				.init			= sa_cipher_cra_init,
+				.exit			= sa_cipher_cra_exit,
+				.min_keysize		= AES_MIN_KEY_SIZE,
+				.max_keysize		= AES_MAX_KEY_SIZE,
+				.setkey			= sa_aes_ecb_setkey,
+				.encrypt		= sa_encrypt,
+				.decrypt		= sa_decrypt,
+			},
+			.op.do_one_request = sa_cipher_do_one_req,
 		}
 	},
 	[SA_ALG_CBC_DES3] = {
 		.type = CRYPTO_ALG_TYPE_SKCIPHER,
 		.alg.skcipher = {
-			.base.cra_name		= "cbc(des3_ede)",
-			.base.cra_driver_name	= "cbc-des3-sa2ul",
-			.base.cra_priority	= 30000,
-			.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_NEED_FALLBACK,
-			.base.cra_blocksize	= DES_BLOCK_SIZE,
-			.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
-			.base.cra_module	= THIS_MODULE,
-			.init			= sa_cipher_cra_init,
-			.exit			= sa_cipher_cra_exit,
-			.min_keysize		= 3 * DES_KEY_SIZE,
-			.max_keysize		= 3 * DES_KEY_SIZE,
-			.ivsize			= DES_BLOCK_SIZE,
-			.setkey			= sa_3des_cbc_setkey,
-			.encrypt		= sa_encrypt,
-			.decrypt		= sa_decrypt,
+			.base = {
+				.base.cra_name		= "cbc(des3_ede)",
+				.base.cra_driver_name	= "cbc-des3-sa2ul",
+				.base.cra_priority	= 30000,
+				.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
+							  CRYPTO_ALG_KERN_DRIVER_ONLY |
+							  CRYPTO_ALG_ASYNC |
+							  CRYPTO_ALG_NEED_FALLBACK,
+				.base.cra_blocksize	= DES_BLOCK_SIZE,
+				.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+				.base.cra_module	= THIS_MODULE,
+				.init			= sa_cipher_cra_init,
+				.exit			= sa_cipher_cra_exit,
+				.min_keysize		= 3 * DES_KEY_SIZE,
+				.max_keysize		= 3 * DES_KEY_SIZE,
+				.ivsize			= DES_BLOCK_SIZE,
+				.setkey			= sa_3des_cbc_setkey,
+				.encrypt		= sa_encrypt,
+				.decrypt		= sa_decrypt,
+			},
+			.op.do_one_request = sa_cipher_do_one_req,
 		}
 	},
 	[SA_ALG_ECB_DES3] = {
 		.type = CRYPTO_ALG_TYPE_SKCIPHER,
 		.alg.skcipher = {
-			.base.cra_name		= "ecb(des3_ede)",
-			.base.cra_driver_name	= "ecb-des3-sa2ul",
-			.base.cra_priority	= 30000,
-			.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_NEED_FALLBACK,
-			.base.cra_blocksize	= DES_BLOCK_SIZE,
-			.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
-			.base.cra_module	= THIS_MODULE,
-			.init			= sa_cipher_cra_init,
-			.exit			= sa_cipher_cra_exit,
-			.min_keysize		= 3 * DES_KEY_SIZE,
-			.max_keysize		= 3 * DES_KEY_SIZE,
-			.setkey			= sa_3des_ecb_setkey,
-			.encrypt		= sa_encrypt,
-			.decrypt		= sa_decrypt,
+			.base = {
+				.base.cra_name		= "ecb(des3_ede)",
+				.base.cra_driver_name	= "ecb-des3-sa2ul",
+				.base.cra_priority	= 30000,
+				.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
+							  CRYPTO_ALG_KERN_DRIVER_ONLY |
+							  CRYPTO_ALG_ASYNC |
+							  CRYPTO_ALG_NEED_FALLBACK,
+				.base.cra_blocksize	= DES_BLOCK_SIZE,
+				.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+				.base.cra_module	= THIS_MODULE,
+				.init			= sa_cipher_cra_init,
+				.exit			= sa_cipher_cra_exit,
+				.min_keysize		= 3 * DES_KEY_SIZE,
+				.max_keysize		= 3 * DES_KEY_SIZE,
+				.setkey			= sa_3des_ecb_setkey,
+				.encrypt		= sa_encrypt,
+				.decrypt		= sa_decrypt,
+			},
+			.op.do_one_request = sa_cipher_do_one_req,
 		}
 	},
 	[SA_ALG_SHA1] = {
 		.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.ahash = {
-			.halg.base = {
-				.cra_name	= "sha1",
-				.cra_driver_name	= "sha1-sa2ul",
-				.cra_priority	= 400,
-				.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
-						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_NEED_FALLBACK,
-				.cra_blocksize	= SHA1_BLOCK_SIZE,
-				.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
-				.cra_module	= THIS_MODULE,
-				.cra_init	= sa_sha1_cra_init,
-				.cra_exit	= sa_sha_cra_exit,
+			.base = {
+				.halg.base = {
+					.cra_name	= "sha1",
+					.cra_driver_name	= "sha1-sa2ul",
+					.cra_priority	= 400,
+					.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
+							  CRYPTO_ALG_ASYNC |
+							  CRYPTO_ALG_KERN_DRIVER_ONLY |
+							  CRYPTO_ALG_NEED_FALLBACK,
+					.cra_blocksize	= SHA1_BLOCK_SIZE,
+					.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+					.cra_module	= THIS_MODULE,
+					.cra_init	= sa_sha1_cra_init,
+					.cra_exit	= sa_sha_cra_exit,
+				},
+				.halg.digestsize	= SHA1_DIGEST_SIZE,
+				.halg.statesize		= sizeof(struct sa_sha_req_ctx) +
+							  sizeof(struct sha1_state),
+				.init			= sa_sha_init,
+				.update			= sa_sha_update,
+				.final			= sa_sha_final,
+				.finup			= sa_sha_finup,
+				.digest			= sa_sha_run,
+				.export			= sa_sha_export,
+				.import			= sa_sha_import,
 			},
-			.halg.digestsize	= SHA1_DIGEST_SIZE,
-			.halg.statesize		= sizeof(struct sa_sha_req_ctx) +
-						  sizeof(struct sha1_state),
-			.init			= sa_sha_init,
-			.update			= sa_sha_update,
-			.final			= sa_sha_final,
-			.finup			= sa_sha_finup,
-			.digest			= sa_sha_run,
-			.export			= sa_sha_export,
-			.import			= sa_sha_import,
+			.op.do_one_request = sa_sha_do_one_req,
 		},
 	},
 	[SA_ALG_SHA256] = {
 		.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.ahash = {
-			.halg.base = {
-				.cra_name	= "sha256",
-				.cra_driver_name	= "sha256-sa2ul",
-				.cra_priority	= 400,
-				.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
-						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_NEED_FALLBACK,
-				.cra_blocksize	= SHA256_BLOCK_SIZE,
-				.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
-				.cra_module	= THIS_MODULE,
-				.cra_init	= sa_sha256_cra_init,
-				.cra_exit	= sa_sha_cra_exit,
+			.base = {
+				.halg.base = {
+					.cra_name	= "sha256",
+					.cra_driver_name	= "sha256-sa2ul",
+					.cra_priority	= 400,
+					.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
+							  CRYPTO_ALG_ASYNC |
+							  CRYPTO_ALG_KERN_DRIVER_ONLY |
+							  CRYPTO_ALG_NEED_FALLBACK,
+					.cra_blocksize	= SHA256_BLOCK_SIZE,
+					.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+					.cra_module	= THIS_MODULE,
+					.cra_init	= sa_sha256_cra_init,
+					.cra_exit	= sa_sha_cra_exit,
+				},
+				.halg.digestsize	= SHA256_DIGEST_SIZE,
+				.halg.statesize		= sizeof(struct sa_sha_req_ctx) +
+							  sizeof(struct sha256_state),
+				.init			= sa_sha_init,
+				.update			= sa_sha_update,
+				.final			= sa_sha_final,
+				.finup			= sa_sha_finup,
+				.digest			= sa_sha_run,
+				.export			= sa_sha_export,
+				.import			= sa_sha_import,
 			},
-			.halg.digestsize	= SHA256_DIGEST_SIZE,
-			.halg.statesize		= sizeof(struct sa_sha_req_ctx) +
-						  sizeof(struct sha256_state),
-			.init			= sa_sha_init,
-			.update			= sa_sha_update,
-			.final			= sa_sha_final,
-			.finup			= sa_sha_finup,
-			.digest			= sa_sha_run,
-			.export			= sa_sha_export,
-			.import			= sa_sha_import,
+			.op.do_one_request = sa_sha_do_one_req,
 		},
 	},
 	[SA_ALG_SHA512] = {
 		.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.ahash = {
-			.halg.base = {
-				.cra_name	= "sha512",
-				.cra_driver_name	= "sha512-sa2ul",
-				.cra_priority	= 400,
-				.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
-						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_NEED_FALLBACK,
-				.cra_blocksize	= SHA512_BLOCK_SIZE,
-				.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
-				.cra_module	= THIS_MODULE,
-				.cra_init	= sa_sha512_cra_init,
-				.cra_exit	= sa_sha_cra_exit,
+			.base = {
+				.halg.base = {
+					.cra_name	= "sha512",
+					.cra_driver_name	= "sha512-sa2ul",
+					.cra_priority	= 400,
+					.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
+							  CRYPTO_ALG_ASYNC |
+							  CRYPTO_ALG_KERN_DRIVER_ONLY |
+							  CRYPTO_ALG_NEED_FALLBACK,
+					.cra_blocksize	= SHA512_BLOCK_SIZE,
+					.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+					.cra_module	= THIS_MODULE,
+					.cra_init	= sa_sha512_cra_init,
+					.cra_exit	= sa_sha_cra_exit,
+				},
+				.halg.digestsize	= SHA512_DIGEST_SIZE,
+				.halg.statesize		= sizeof(struct sa_sha_req_ctx) +
+							  sizeof(struct sha512_state),
+				.init			= sa_sha_init,
+				.update			= sa_sha_update,
+				.final			= sa_sha_final,
+				.finup			= sa_sha_finup,
+				.digest			= sa_sha_run,
+				.export			= sa_sha_export,
+				.import			= sa_sha_import,
 			},
-			.halg.digestsize	= SHA512_DIGEST_SIZE,
-			.halg.statesize		= sizeof(struct sa_sha_req_ctx) +
-						  sizeof(struct sha512_state),
-			.init			= sa_sha_init,
-			.update			= sa_sha_update,
-			.final			= sa_sha_final,
-			.finup			= sa_sha_finup,
-			.digest			= sa_sha_run,
-			.export			= sa_sha_export,
-			.import			= sa_sha_import,
+			.op.do_one_request = sa_sha_do_one_req,
 		},
 	},
 	[SA_ALG_AUTHENC_SHA1_AES] = {
 		.type	= CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
 			.base = {
-				.cra_name = "authenc(hmac(sha1),cbc(aes))",
-				.cra_driver_name =
-					"authenc(hmac(sha1),cbc(aes))-sa2ul",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_TYPE_AEAD |
-					CRYPTO_ALG_KERN_DRIVER_ONLY |
-					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_NEED_FALLBACK,
-				.cra_ctxsize = sizeof(struct sa_tfm_ctx),
-				.cra_module = THIS_MODULE,
-				.cra_priority = 3000,
+				.base = {
+					.cra_name = "authenc(hmac(sha1),cbc(aes))",
+					.cra_driver_name =
+						"authenc(hmac(sha1),cbc(aes))-sa2ul",
+					.cra_blocksize = AES_BLOCK_SIZE,
+					.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+						CRYPTO_ALG_KERN_DRIVER_ONLY |
+						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_FALLBACK,
+					.cra_ctxsize = sizeof(struct sa_tfm_ctx),
+					.cra_module = THIS_MODULE,
+					.cra_priority = 3000,
+				},
+				.ivsize = AES_BLOCK_SIZE,
+				.maxauthsize = SHA1_DIGEST_SIZE,
+
+				.init = sa_cra_init_aead_sha1,
+				.exit = sa_exit_tfm_aead,
+				.setkey = sa_aead_cbc_sha1_setkey,
+				.setauthsize = sa_aead_setauthsize,
+				.encrypt = sa_aead_encrypt,
+				.decrypt = sa_aead_decrypt,
 			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-
-			.init = sa_cra_init_aead_sha1,
-			.exit = sa_exit_tfm_aead,
-			.setkey = sa_aead_cbc_sha1_setkey,
-			.setauthsize = sa_aead_setauthsize,
-			.encrypt = sa_aead_encrypt,
-			.decrypt = sa_aead_decrypt,
+			.op.do_one_request = sa_aead_do_one_req,
 		},
 	},
 	[SA_ALG_AUTHENC_SHA256_AES] = {
 		.type	= CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
 			.base = {
-				.cra_name = "authenc(hmac(sha256),cbc(aes))",
-				.cra_driver_name =
-					"authenc(hmac(sha256),cbc(aes))-sa2ul",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_TYPE_AEAD |
-					CRYPTO_ALG_KERN_DRIVER_ONLY |
-					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_NEED_FALLBACK,
-				.cra_ctxsize = sizeof(struct sa_tfm_ctx),
-				.cra_module = THIS_MODULE,
-				.cra_alignmask = 0,
-				.cra_priority = 3000,
+				.base = {
+					.cra_name = "authenc(hmac(sha256),cbc(aes))",
+					.cra_driver_name =
+						"authenc(hmac(sha256),cbc(aes))-sa2ul",
+					.cra_blocksize = AES_BLOCK_SIZE,
+					.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+						CRYPTO_ALG_KERN_DRIVER_ONLY |
+						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_FALLBACK,
+					.cra_ctxsize = sizeof(struct sa_tfm_ctx),
+					.cra_module = THIS_MODULE,
+					.cra_alignmask = 0,
+					.cra_priority = 3000,
+				},
+				.ivsize = AES_BLOCK_SIZE,
+				.maxauthsize = SHA256_DIGEST_SIZE,
+
+				.init = sa_cra_init_aead_sha256,
+				.exit = sa_exit_tfm_aead,
+				.setkey = sa_aead_cbc_sha256_setkey,
+				.setauthsize = sa_aead_setauthsize,
+				.encrypt = sa_aead_encrypt,
+				.decrypt = sa_aead_decrypt,
 			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-
-			.init = sa_cra_init_aead_sha256,
-			.exit = sa_exit_tfm_aead,
-			.setkey = sa_aead_cbc_sha256_setkey,
-			.setauthsize = sa_aead_setauthsize,
-			.encrypt = sa_aead_encrypt,
-			.decrypt = sa_aead_decrypt,
+			.op.do_one_request = sa_aead_do_one_req,
 		},
 	},
 };
@@ -2209,14 +2289,14 @@ static void sa_register_algos(struct sa_crypto_data *dev_data)
 
 		type = sa_algs[i].type;
 		if (type == CRYPTO_ALG_TYPE_SKCIPHER) {
-			alg_name = sa_algs[i].alg.skcipher.base.cra_name;
-			err = crypto_register_skcipher(&sa_algs[i].alg.skcipher);
+			alg_name = sa_algs[i].alg.skcipher.base.base.cra_name;
+			err = crypto_engine_register_skcipher(&sa_algs[i].alg.skcipher);
 		} else if (type == CRYPTO_ALG_TYPE_AHASH) {
-			alg_name = sa_algs[i].alg.ahash.halg.base.cra_name;
-			err = crypto_register_ahash(&sa_algs[i].alg.ahash);
+			alg_name = sa_algs[i].alg.ahash.base.halg.base.cra_name;
+			err = crypto_engine_register_ahash(&sa_algs[i].alg.ahash);
 		} else if (type == CRYPTO_ALG_TYPE_AEAD) {
-			alg_name = sa_algs[i].alg.aead.base.cra_name;
-			err = crypto_register_aead(&sa_algs[i].alg.aead);
+			alg_name = sa_algs[i].alg.aead.base.base.cra_name;
+			err = crypto_engine_register_aead(&sa_algs[i].alg.aead);
 		} else {
 			dev_err(dev,
 				"un-supported crypto algorithm (%d)",
@@ -2242,11 +2322,11 @@ static void sa_unregister_algos(const struct device *dev)
 		if (!sa_algs[i].registered)
 			continue;
 		if (type == CRYPTO_ALG_TYPE_SKCIPHER)
-			crypto_unregister_skcipher(&sa_algs[i].alg.skcipher);
+			crypto_engine_unregister_skcipher(&sa_algs[i].alg.skcipher);
 		else if (type == CRYPTO_ALG_TYPE_AHASH)
-			crypto_unregister_ahash(&sa_algs[i].alg.ahash);
+			crypto_engine_unregister_ahash(&sa_algs[i].alg.ahash);
 		else if (type == CRYPTO_ALG_TYPE_AEAD)
-			crypto_unregister_aead(&sa_algs[i].alg.aead);
+			crypto_engine_unregister_aead(&sa_algs[i].alg.aead);
 
 		sa_algs[i].registered = false;
 	}
@@ -2422,6 +2502,16 @@ static int sa_ul_probe(struct platform_device *pdev)
 	if (ret)
 		goto destroy_dma_pool;
 
+	dev_data->engine = crypto_engine_alloc_init(dev, 0);
+	if (!dev_data->engine) {
+		ret = -ENOMEM;
+		goto release_dma;
+	}
+
+	ret = crypto_engine_start(dev_data->engine);
+	if (ret)
+		goto free_engine;
+
 	spin_lock_init(&dev_data->scid_lock);
 
 	val = SA_EEC_ENCSS_EN | SA_EEC_AUTHSS_EN | SA_EEC_CTXCACH_EN |
@@ -2436,15 +2526,19 @@ static int sa_ul_probe(struct platform_device *pdev)
 
 	ret = of_platform_populate(node, NULL, NULL, dev);
 	if (ret)
-		goto release_dma;
+		goto unregister_algos;
 
 	device_for_each_child(dev, dev, sa_link_child);
 
 	return 0;
 
-release_dma:
+unregister_algos:
 	sa_unregister_algos(dev);
 
+free_engine:
+	crypto_engine_exit(dev_data->engine);
+
+release_dma:
 	dma_release_channel(dev_data->dma_rx2);
 	dma_release_channel(dev_data->dma_rx1);
 	dma_release_channel(dev_data->dma_tx);
@@ -2467,6 +2561,8 @@ static void sa_ul_remove(struct platform_device *pdev)
 
 	sa_unregister_algos(&pdev->dev);
 
+	crypto_engine_exit(dev_data->engine);
+
 	dma_release_channel(dev_data->dma_rx2);
 	dma_release_channel(dev_data->dma_rx1);
 	dma_release_channel(dev_data->dma_tx);
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 7ca385e908cc..53d2bfd895cf 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -159,6 +159,7 @@ struct sa_match_data;
  * @dma_rx1: Pointer to DMA rx channel for sizes < 256 Bytes
  * @dma_rx2: Pointer to DMA rx channel for sizes > 256 Bytes
  * @dma_tx: Pointer to DMA TX channel
+ * @engine: crypto_engine instance for this device
  */
 struct sa_crypto_data {
 	const struct sa_match_data *match_data;
@@ -173,6 +174,7 @@ struct sa_crypto_data {
 	struct dma_chan		*dma_rx1;
 	struct dma_chan		*dma_rx2;
 	struct dma_chan		*dma_tx;
+	struct crypto_engine	*engine;
 };
 
 /**
@@ -261,6 +263,26 @@ struct sa_sha_req_ctx {
 	struct ahash_request	fallback_req;
 };
 
+/**
+ * struct sa_cipher_req_ctx: Structure used for skcipher request
+ * @enc: True if this request is an encrypt operation
+ * @fallback_req: SW fallback request container
+ */
+struct sa_cipher_req_ctx {
+	bool enc;
+	struct skcipher_request fallback_req;
+};
+
+/**
+ * struct sa_aead_req_ctx: Structure used for aead request
+ * @enc: True if this request is an encrypt operation
+ * @fallback_req: SW fallback request container
+ */
+struct sa_aead_req_ctx {
+	bool enc;
+	struct aead_request fallback_req;
+};
+
 /**
  * struct sa_eng_info: Security accelerator engine info
  * @eng_id: Engine ID

-- 
2.43.0

