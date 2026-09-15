Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A40E47A86D;
	Tue, 15 Sep 2026 09:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466246; cv=fail; b=J7KQR715nl3+75lF/nu8EZ+c/iQdROfQHQ9YPzG0GqvUF+KgqO4iP7ie/5/SQSksIJ89B/DNmAflQdaHRbaZu2eyrvTezkAtPqHjryoKaY8AcHClIV4iBzXZgb0hZU2jYESbUlAferTIJ0Mk/cWroN70g4AqmXjCN2RHa9dJOms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466246; c=relaxed/simple;
	bh=RcDE9iVplKFnDV4Zf6Fhqe54OYAdajcI1iK42ktIVgg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=I0RNWVJ98DFOD4DWJIp/a8bEW7UMEADP+Ps0j2XrVafZ33FUiWGYGWOOqgJTDLc/sLBR/ySsSM8Zf3NaaWLLLsI+5xRHy/MfbEp60ht/rwVW5b4zyzd3VDQM2WuYQE0bW2fKxe485BWok5MYt0lof4+HE49QpP462eA04g8rtkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=eTRuEAhG; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=F8/5vnk6; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="eTRuEAhG";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="F8/5vnk6"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9fQUu4098377;
	Tue, 15 Sep 2026 04:57:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=e7vpzDaZ/hE37dxOKjcYG2utqQjsDtb4qlcQzB3Kq
	Ko=; b=eTRuEAhGPJdlykTLWc+5A7d4tg0shB1EJcYEG+sqt1h9lNXBemVBpFRlN
	snuxEgye/L3tDQGca4C0kLROoCBTt0UEyIjKhils6J6Dfgq8b32XvNlQ+VjVPBTB
	MHweuwtNaZFj5Vhade2HF/cxKKaZv2GPiqxr6kOEtjAdP3nqr8SGSvjP+PGGZmjQ
	I89vpNG8phe0+vEji60f40AWvwZjFHzxJb/eRatQEDhHT3PU8wdxTUtV2vK6RKn8
	MpIFbGLoCVS3GwlUsgDKzB0N9F7yrwN2KC2EjCiX3BaCzfujHeQeaRpUsw9u51XW
	NfBTUCiCPJAG1z4yMovkJpiAOySAQ==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012063.outbound.protection.outlook.com [52.101.48.63])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gpvpjaknd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:57:18 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WPfKyCCs43ZHRJwUoHiRn4ZVcGckyXxE4BH5qEQyTTNlN1gEimqHiXSSH0xMAqnorKb+CAQ8P7c0l7dskKd4MlMaSrkW+rFlSHKsQ6pbmKGVgxLiidSBuX8hS2wpxu2Q0MmMa2YsDoYyL1qpaNWycxN4d9tPRyP/eBFRxp8EN4CY2NWEAe7OMDwLS6Gtgbt9fV1IjQkitFzDatXWeZNJznZ45N282tpJRtmMlRDmdJVo5ysxsxll6u9UZtVbA1ij79gEKL8XoQ9n1EWd9Bybzq8OXaqyaKPmoZaMzeEg7R+M2H8k9VrveOzpg34YSgA/PbnGnOhdQXbqdMMOtlZcOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e7vpzDaZ/hE37dxOKjcYG2utqQjsDtb4qlcQzB3KqKo=;
 b=XDkCPa8T+klxC0dEEBjSrDyVNi8SLecIYsoKTcxaKWmtpBGLeOGSIfD+RLSRhgNPXyRqoMneeDnzfEC6/R9CbCd+15QmPOWhIeDcFs94RNebGQOB0wzPSLBo2fY4GS+I6XDOFW6HywSM8XRfwIDEdCwf/ksE0GX1gX/A9chxp/jnplKRPnWdX8c05+k7S+PBXOMa7ABEoCxRvzt/44XDTLxDy2fgghcl0lp+DS1u10A11iSh/QdWrE+7O0XB1YmEt+pMTgdH4qFSWIEbPJ8ql0XoP3Yb725QDNjSWCdENUcwMaTvM2+IXnkLLXw7lXV53ogPm8fE5Jo6N6VwqudkFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7vpzDaZ/hE37dxOKjcYG2utqQjsDtb4qlcQzB3KqKo=;
 b=F8/5vnk6dvX6Nl9X738DQZmAyWZBhP1MEjp9KFPmRsIqf7DqLJ4Ed3asDOzyF8YQ3y3DwnJBOi8dhUClNw9AVmf91oT3JZYZzUe7dQoGxpugqnBhqwHwIECcX4tmUw5i/OgzewHXDn9RPy88vZKjSLNsT/KbcOWXQOazrViY/N0=
Received: from SJ2P221CA0004.NAMP221.PROD.OUTLOOK.COM (2603:10b6:a03:5db::14)
 by SA1PR10MB6544.namprd10.prod.outlook.com (2603:10b6:806:2bb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Tue, 15 Sep
 2026 09:57:16 +0000
Received: from MWH0EPF000C6186.namprd02.prod.outlook.com
 (2603:10b6:a03:5db:cafe::2c) by SJ2P221CA0004.outlook.office365.com
 (2603:10b6:a03:5db::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 09:57:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 MWH0EPF000C6186.mail.protection.outlook.com (10.167.249.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:57:14 +0000
Received: from DFLE203.ent.ti.com (10.64.6.61) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:34 -0500
Received: from DFLE202.ent.ti.com (10.64.6.60) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:33 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:34 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB8E3000901;
	Tue, 15 Sep 2026 04:56:31 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:30 +0530
Subject: [PATCH 24/30] crypto: sa2ul - add more checks before processing
 ipad/opad
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-24-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=4394;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=RcDE9iVplKFnDV4Zf6Fhqe54OYAdajcI1iK42ktIVgg=;
 b=jl1VkAgxahZt8VCKtD+29iX40yedRAot0e0a2cZ6hhdd397XniE4W2wQW5SvDnLI8ZfazlOQN
 wjnHqtgy2u4CK/ehpEN1BX71kU1y2u+qahEWyXUp7sAvbpp5sZYssqD
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6186:EE_|SA1PR10MB6544:EE_
X-MS-Office365-Filtering-Correlation-Id: e9f3bd62-fe01-4481-9943-08df130fb84f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|36860700016|1800799024|82310400026|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	ewUmLs2ikykyzWfq9XbxYbulBsfO3k/d55o3jeKU3ytlJ/H8uEdFNsdV9o/RGOOGh9KVmM0pajXRmiaN/0v4eJDJdYAbFA2wdV9ywf0eaxdTn973RC8EsLnonaI7Uv5ddEuhkepP30lSiHfJceC0jqjGRAKdukohEbF21MZDsrt4aTBgOS9VO7PU1gVVB7F/MBjn6As1NjmE7N7zlfb57EdA6fVT0lBRgik8luZRK8mCJgQoPLErJ32xqE1k05YdJ5eIVnTfukjRXEIkv3h1WRfP/b6j9xg++RD+H15aKB8pXFrzHWizuu7plWUq6kko8QsRCTrgfPo+ACNACwT7c5gu224Zgj1gmUwD+0ap5LK8GBPMax7idR6PaT2QXdb9XKhrcnmFIELXJwueKkqiGarX7OhOAG1DKGC7I0EH7s8NniO8jazttNf8x1vB2qURtn7dO1U6tJq8QIaAOZ1pofL2CFVX0w3nwt8R7hCmfxk3ULVbGMl2XeZ+qUkoZYNi3QqIzYJckN2R22Rc4639RozCVfTKnoWeCmp4Y7/rGWi4r9ddPC+36KaTnwmvgDltZjzOYiNiyCXLvIcNIttDTRTwIxj7KqOIzRf+iIP4K+qRiUzO515P2yV21l7mykOCG8uzYO97NHO3jA60d1HVGZRVXZqLE9B7bBIbWr2igp8bONjT/bkhT8QOoqaBExeYryetueKit8lHYrGtq5fOnQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(23010399003)(36860700016)(1800799024)(82310400026)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/0aaw6lpIlpQ4GRM8/dLKi2KLbeGKasSRGeB0VDZYB3GORvOtxhKRXym1Jg5M5SY7cj5sUTe8+moYJ92K0/LSz0lo2fhw0dNr5gKVNmwVwrB474l8Et3x5xt2uzMniiTw/lckfVNrputljFy+IRq/n3ra8nCUaWqf54+6/fwiXQfUujv5jGYeU94oQIXRlyAX4sH/vQa84iNLZJL7pTV5Ic++Vusq7X58BIfKjcc7K2TZr6/gcox7jUh8tC3c/yaiDVAa1DwudaE/1etaJr1KZ5p769SO8Rjx9hunDGKha1iTaHYXcIMS7WkOemTB7nQbp9gNuzqo+CRwzURZLfBtsQwneUatO38uK0JPOX1PcIwtCWYNzIYt/OdptldZETGmM69sZtUI0xZoAEy0QF3lWVLi1qPtGaRBjMlR4aq4C4c0JuoI6JQcw424cSQHaXi
X-Exchange-RoutingPolicyChecked:
	cJK0syKDjjb5GIwdGsqvvFJEDCM+U9dDP91s3znsVrhk1J37zokeuqU1DhR61k8l4WwxVv5hdjVkLJgwwmzrV9Iw1j9BJVR8qrUIjg0d5FtrjsN4bLe+136ysQE7jGE3jTBzyOqaCe3y5VLFk/2ReXNQ91nKIlI5FRmALb+wIU3ZqcvTkDuJHaM0FotcSBsTsIsdu7TGnBQ0ck7MFVcbThqtwJFlV4ijSth+wt0UzZpeUq9YskS1+FttYi5Kvfs4fKr3PMcsXCQh2Bm5g6s1cpshXrn2I2vp9GlnG5J8gy06xPBPpBlpAt5Ra7R/vAr41YZITU55ujoIwmJeJIS8tA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:57:14.6154
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f3bd62-fe01-4481-9943-08df130fb84f
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6186.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6544
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX2LyIud6J7cd6
 pL4Z39MjlqWVlzqIZNbgriKNZguGcTSSrMFsD5LFkTJH2vrVKzczom5tGnVTcj6Zr7UpPTHk2GN
 4xvqiPG4e0H4jVMg6gwOCzyMnowCma4=
X-Authority-Analysis: v=2.4 cv=KvnYSmWN c=1 sm=1 tr=0 ts=6aa9167f cx=c_pps
 a=m+Y8nsmXU8Fd5URmI4pqsQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=K37ofz1H7Ls3PSt_8rcA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: uYpd4BoKT0xd6ZkuxLAH9wBvp_Eg1MLr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfXwnVATfRgWr+R
 pro8C4uwAt/vARLsROj/TfiPbLBqNj1XRducqrHMHpZ9yqpvHxQg9D+vkh8tF9Q6PNhqFeA/7Bm
 VByEbidf2+H7b9X1erVjobhQWB3BX5HCe3YK2pfyJl7DdWykmvaA0kKiYhV94V5GxcbPcW+noEW
 tAQCxg/GyXiIzDDXYsT0AJ3LFxzNJzB0tEGFzYftvKJn0VsJ+mQ59V1u1ARVsAw+phd0eSKwHxF
 EA6DE+s5+FbQXzZAUx899hu++GRtbwvneOy8p0S0NK5Hx3T8fXtxk1IquZMu9IK3mytoXOR9hhv
 iToABUM7i66cfkZ57bsNCHN3i0reBmk/ZILw8l5Zw8DocoHLi0GvE+f+MdQk2qvdnT4WkvWZIyT
 Xj/UEUBwcnnKfHMXLActZLwzFzZO5ehRn9Ph90boS59T9Ug50Hij76Tc6LKsaD+Fy/FVNmIv8Ww
 TOmCskfHtlVSzV2lPOw==
X-Proofpoint-GUID: uYpd4BoKT0xd6ZkuxLAH9wBvp_Eg1MLr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

When the key_sz is greater than the block_size then we need to hash it
with the transform to process it further. To avoid repeated hashing for
the key for individual ipad/opad, merge the prepare_kipad and
prepare_kopad in sa_prepare_iopad itself.

Also as per fips standard, there is a minimum key size requirement so
check that based on fips enablement to return the appropriate error
code.

Since the framework doesn't provide the intermediate hash, replicate the
checks of the framework and make sa2ul code similar to that.

Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 63 +++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 265d1afaad81..cd5cd9182bdb 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -12,6 +12,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
+#include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -24,6 +25,7 @@
 #include <crypto/authenc.h>
 #include <crypto/utils.h>
 #include <crypto/des.h>
+#include <crypto/hmac.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
@@ -368,31 +370,6 @@ static void sa_swiz_128(u8 *in, u16 len)
 	}
 }
 
-/* Prepare the ipad and opad from key as per SHA algorithm step 1*/
-static void prepare_kipad(u8 *k_ipad, const u8 *key, u16 key_sz)
-{
-	int i;
-
-	for (i = 0; i < key_sz; i++)
-		k_ipad[i] = key[i] ^ 0x36;
-
-	/* Instead of XOR with 0 */
-	for (; i < SHA1_BLOCK_SIZE; i++)
-		k_ipad[i] = 0x36;
-}
-
-static void prepare_kopad(u8 *k_opad, const u8 *key, u16 key_sz)
-{
-	int i;
-
-	for (i = 0; i < key_sz; i++)
-		k_opad[i] = key[i] ^ 0x5c;
-
-	/* Instead of XOR with 0 */
-	for (; i < SHA1_BLOCK_SIZE; i++)
-		k_opad[i] = 0x5c;
-}
-
 static int sa_export_shash(struct shash_desc *hash, int digest_size,
 			   __be32 *out)
 {
@@ -448,11 +425,34 @@ static int sa_prepare_iopads(struct algo_data *data, const u8 *key,
 	int block_size = crypto_shash_blocksize(data->ctx->shash);
 	int digest_size = crypto_shash_digestsize(data->ctx->shash);
 	int ret = 0;
-	u8 k_pad[SHA1_BLOCK_SIZE];
+	int i = 0;
+	u8 k_ipad[SHA1_BLOCK_SIZE];
+	u8 k_opad[SHA1_BLOCK_SIZE];
+
+	if (fips_enabled && (key_sz < 112 / 8))
+		return -EINVAL;
 
 	shash->tfm = data->ctx->shash;
 
-	prepare_kipad(k_pad, key, key_sz);
+	if (key_sz > block_size) {
+		int err;
+
+		err = crypto_shash_digest(shash, key, key_sz, k_ipad);
+		if (err)
+			return err;
+
+		key_sz = digest_size;
+	} else {
+		memcpy(k_ipad, key, key_sz);
+	}
+
+	memset(k_ipad + key_sz, 0, block_size - key_sz);
+	memcpy(k_opad, k_ipad, block_size);
+
+	for (i = 0; i < block_size; i++) {
+		k_ipad[i] ^= HMAC_IPAD_VALUE;
+		k_opad[i] ^= HMAC_OPAD_VALUE;
+	}
 
 	ret = crypto_shash_init(shash);
 	if (ret) {
@@ -460,7 +460,7 @@ static int sa_prepare_iopads(struct algo_data *data, const u8 *key,
 			__func__, __LINE__, ret);
 		return ret;
 	}
-	ret = crypto_shash_update(shash, k_pad, block_size);
+	ret = crypto_shash_update(shash, k_ipad, block_size);
 	if (ret) {
 		dev_err(sa_k3_dev, "%s: %d: crypto_shash_update for ipad failed, ret=%d\n",
 			__func__, __LINE__, ret);
@@ -473,15 +473,13 @@ static int sa_prepare_iopads(struct algo_data *data, const u8 *key,
 		return ret;
 	}
 
-	prepare_kopad(k_pad, key, key_sz);
-
 	ret = crypto_shash_init(shash);
 	if (ret) {
 		dev_err(sa_k3_dev, "%s: %d: crypto_shash_init for opad failed, ret=%d\n",
 			__func__, __LINE__, ret);
 		return ret;
 	}
-	ret = crypto_shash_update(shash, k_pad, block_size);
+	ret = crypto_shash_update(shash, k_opad, block_size);
 	if (ret) {
 		dev_err(sa_k3_dev, "%s: %d: crypto_shash_update for opad failed, ret=%d\n",
 			__func__, __LINE__, ret);
@@ -494,7 +492,8 @@ static int sa_prepare_iopads(struct algo_data *data, const u8 *key,
 		return ret;
 	}
 
-	memzero_explicit(k_pad, SHA1_BLOCK_SIZE);
+	memzero_explicit(k_ipad, SHA1_BLOCK_SIZE);
+	memzero_explicit(k_opad, SHA1_BLOCK_SIZE);
 
 	return ret;
 }

-- 
2.43.0

