Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6F64248D2;
	Fri, 18 Sep 2026 10:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789726178; cv=fail; b=SjDxwf4TZs2TymIs8uD52DLmdHNHstdptYYD3HPdIEFgL1mCfqHIfIm+jznea/Ow4TcafZsW7YWjIzJgVb2xnwTnJTq36uZucQRIFklZ4Peq/2d7vVE0zES9N3k7sYG/NYWYJScHAwDrH2M6osX2O65sI5wLcvHNRHlay+OszYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789726178; c=relaxed/simple;
	bh=bIXTuZgxn9Gv2S6i4F3FBD8t5+A+PZvM3EFhdFdM+0c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WyPGCB7Cn3gPonOK0QM1Bv5bszp6M2Oxitry42OaCQ4rsM78zcF0u0ipMUxMUE7Dokir9p2ALzEK1Mbwn/l4Ib4Z+0PYFQjnX26NNAdlhxuLJd8BrYF3Rp/xg97b9jCz3HPgJSkPMsWDhTsLdL8PONnikegrRVfbpoaPOu74i8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=qW1FD/V6; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=KRJ3SNwq; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="qW1FD/V6";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="KRJ3SNwq"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68I9dBqF1233790;
	Fri, 18 Sep 2026 05:09:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=inAPZemJykgtZPP09CSGQZz2GdD0zx6hZQomdmEaZ
	kk=; b=qW1FD/V61XaBfkXGUUHP3So+ra1M5GZl779b0kKvuXTMFHJrxnhj8YBqw
	NijqkxtHndjT1/XIs2+grynU39evBozkCmFkqDGxRWEg5vCgxtAo3rAMLZzSp+od
	fa13w6MbhoylJpxo/mkPM3006IOjck3GGG4F3293UgJXGDYD8+vYwOdY2WyfzPdI
	WZZ3XcvmjBzjYQt8YGvpxjjQM2mxKJ1PZaUaV9WGSxOhOv2hlZGhJA57wS8qCWoo
	kW7rWerzut1bmafn0yr9/n7k2225cacTDqq3ig5YdRPlfNhOUe1su+E2WUqiGMtW
	uRmt9bbWb5swP9+KouB3+ozsXUwtw==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013053.outbound.protection.outlook.com [40.93.201.53])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gs2ux04y2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:09:32 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qdw5fsw/zIt1lipAXbifsTobAmzrq2GcA0iQ2jpydDk+OCloRf35tmdpIhJ3l9ndsbgF/dfqNMsYWTBUUQwSrKmi4+0nKBNZXqiZTT2SWoybaIOqokDsewhgya5mkIIPEdw7vgGy0gxhk0we8Bxcaa4GatbIxra27+LmZUDmKFTHLOBGM273GvmlwdCbf1oV/8mdRZTFm4l6JJGdqZJD/TFYOFCiPyOfaK/ZXKRdH/YYUEU6chZqpKA4D+X4NJUOEPw/W2PdksDvYvWkUhav6MkrwaiuTRpSMJGAf7X7DXagLBoeMK3Psr4Wi1jMpvA0WuBDKf0uvYm/MMnVBmVspg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=inAPZemJykgtZPP09CSGQZz2GdD0zx6hZQomdmEaZkk=;
 b=G4fS/rX36HWxmd4Csvfc1diq4V3fB/qsE1uUhs+ISFtIq2hMu0WPmn4Sphw7rYQae0t5n0gUGSR8jG3vnKwQKCT1BqB7ByK16fRvx8efNg8Rjik8REoOwDALVXBSnK8lM1aKOPZh7pYu2ewu47/QpdmP73Nejln1J6BNQ2mKJuUSv3TI0Zp+GYjVYxU8RjRgggmM+jxy8fGEoFJSD+S+BA2y1YdHaowxh+IqITzNwlDX3BGmHpjLTGHYsjOiNvebiHjM0A2oDEX6YgwAjNfvRUTZ6ABUpVheZJU8hymkdQ+DvGwt0Nk4fuOv2AMGIODLLOlznh4yI+fdG8qR6OgayA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=inAPZemJykgtZPP09CSGQZz2GdD0zx6hZQomdmEaZkk=;
 b=KRJ3SNwqo4dheMY7glt4FOnnQyB+cZ21VuVmmk8wZfq9cNTLIr3UuLOEcpd3jf9ycKWZZ20SSUoAsKwz1ZUNLS/q91OnF5LD6c1Q4ZrWw59oSv6BMZ3j33yfEtCx/fONsHMYg0+LQ+IQ+aMCjNRDgqmriF8Az25gsAZvbBbZy7A=
Received: from CH0PR07CA0002.namprd07.prod.outlook.com (2603:10b6:610:32::7)
 by CH0PR10MB4905.namprd10.prod.outlook.com (2603:10b6:610:ca::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Fri, 18 Sep
 2026 10:09:30 +0000
Received: from CH3PEPF0000000B.namprd04.prod.outlook.com
 (2603:10b6:610:32:cafe::6a) by CH0PR07CA0002.outlook.office365.com
 (2603:10b6:610:32::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Fri,
 18 Sep 2026 10:09:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 CH3PEPF0000000B.mail.protection.outlook.com (10.167.244.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 10:09:29 +0000
Received: from DLEE200.ent.ti.com (157.170.170.75) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:09:16 -0500
Received: from DLEE200.ent.ti.com (157.170.170.75) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:09:16 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:09:16 -0500
Received: from [10.24.53.205] (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IA9DtG1515345;
	Fri, 18 Sep 2026 05:09:14 -0500
Message-ID: <02123ac7-71db-477b-af81-fc8da6e55e93@ti.com>
Date: Fri, 18 Sep 2026 15:39:12 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/2] Add support for hashing algorithms in TI DTHE V2
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S . Miller" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, "Praneeth Bajjuri" <praneeth@ti.com>
References: <20260910180424.2131193-1-t-pratham@ti.com>
 <aqz_7a2MFn0566pN@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aqz_7a2MFn0566pN@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000B:EE_|CH0PR10MB4905:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e6a542f-7346-4a76-baf2-08df156cedcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|82310400026|376014|36860700016|56012099006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/Q68/F01InO3cfuiac10d7+O5mMptq3RjqA6GAB+POfxp6NIu+mJ4JY2cXhbx1oesiS4J8jc1rVovlF606u49IFh+HBOJeW7PtjfHEex7sY0etJAhUo/+FD1xP+MqQlQOlpGVUbBjDVqQtVGMO6BAXp5NalxwYeElCqIARuN4HNYySChB4UaEO2aOn7dXNk8juhavVgn19mT6kfLyp3Xldh4JSWcC+rRIx6vt60zRZtV9H4paaOT5ytSZDFSaVokpk95s86HC/e34Dl3fUz3toSRrLshkwcjLM23cHuylLvJmJ/1hzyF25/7pmlvNyLJpFD6WM6PIQLdf79fEEgKRJLSBonaySmr6nlNAcHOKJGZfy4vZ8aR82EB+MJ2ImQqQTCoQH+2nzTC63x4s1oAwalstpnJ95m0W9amwPV05g5FnMErkQz/10/uhKvhwldAxQEg2dTJeKNqvr2wOysuv2Ze5/X879cXwnC07MSWScu3+ifZwpxT/hkfFmG+F/OsbcaIpaX2LEx1P+LWSMJPFu1K6qj12T51MaREKVGBTeByfbVqEtaQhMA6EQ51bYTomye2/2H1IobbeH/VM5DbTcnqpKk5bu4mukR2oCSR/CVt4tcySnMPfsuuBXefsG8+pBmx1d3oM/G4xnzTPA2VUfizxQEfQFtwkFUY4ykdZhheh4DGG5qwkEigexDvNV78c2FGkoVHeRHRNnoRPiBv/Q==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(82310400026)(376014)(36860700016)(56012099006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	y1bPy3Uu7o67ZLeVA+Jxi1jkKZEW4SmFETj2hWdemXJDGdAjljP7+Qbsu7LHc6YTPwbwwu1CGJjpF1GVjhM8KvjQnocEwfCXtEBYLVnQb5W38QagqnVDymdKgSkf2FsV//QyzWGWVx2KV6MDYx+W9H4V02MxDnGMoDZUwgwfpJU297hMKG1Bix+DK4G99BZizj0nOLj7sR4P2vzadfId8rdPS5V7T/knUdWkh8fU0XFRrEyaNVJF5lZ3TUXv9sxrTtMTtlHZKkAZ3vfdLruFb/1uw+ZSEsPllyJ4dUeuV+H94ZHShQwNdiuZTQW6ZIUeTNNWTicdrvUzV9S/NfaJrMj61XXAZD05nXNwRErRwvOJByCUpRZICFeBt7SLE8AWS9dGAc6xySodUsbi0D9k6q/AuO6XjkSSdxYgBGVTH7dVyjFKtjKpS2FlmzJtTpE9
X-Exchange-RoutingPolicyChecked:
	h9HyJcCs7NTwGH4wJ9nLcL7po8+aGxvCTV6TWFuLCRDS/NUFnjtDJj3sqq9zIYqxM7dTP/uZ23xiiF/sn/ZVupsBkUWd58SVCH/i1tUdBOxn2BY6u0bSN3dLg2kvYiFL1Eq9wBe/FD5wFuOj/E25nQifgCYnsm9xAARr5Bm5MAtIgjEs9Suko1ti6Ndad1P6sRQl+18t4EMI94b8lR4z4iFZHI+26qN/IdopfkAN8b2P63jQ9KCSRJ/+478l+G7r0SRnwe9FKg00XRSOTc4zAyeLQGIX5KwZM2EGLoOOOG16nnLdD2d1N5JbSxY2cv8UCp081OkwHf66BR5liTcsmA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:09:29.9231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e6a542f-7346-4a76-baf2-08df156cedcc
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4905
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0MCBTYWx0ZWRfX+Hsmh0pzRnud
 N7go66isEoLwkGUEUF7I4bZns9akMyNgFo0Q9F1ID1A35jqTssNyCCGMu4LWgvVsTJIXEI/iip8
 izUn2TZ9icJnwxiOVGqvbq0kTM1ch5kfm0EfvMSOhYCfLoTQqIHlqmLJZtNxVa+f0FPbN9m8Lli
 BBHbvUCG5RtJx9hrxLBqqaPwTqaq0NpoEjelru0r/7mSN0t35zmsV0Ln1P46BXNJwnzOrI24BZq
 yjOERaOUeTk+tnENtI8yIooq6B7rhTEQxmN3kjgTX3EyaMP6K8eB6VHKcyxwa+0qZIJg/uK5b/K
 iryD4dguC5YfRfeyyDp+AyxS8DNl7yPZ9lA7ZDudHquIut8kRxCjUPN6gnifi/KeQB5yOC3Q5Yl
 tBSPAautU/bgodFZ6xgXxRFlCGdBjbDdkjj9gYWZIku2YEMN10BF5mpaq7oxdqRFHvJGnQ10X0Q
 g/VaPqfKqoHRgCIjgKw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0MCBTYWx0ZWRfX+XnwIouFb0wW
 89pzSEMSa7qgKMDJ+AyYP83MC7pOy9I8HxqD/0uB+STnjB9VeqT2AHjVPeIHb8v02QEpRzDN10/
 l158aBWxCjMHIoHc8Zp1VjHjXRtJdpg=
X-Proofpoint-ORIG-GUID: DfrWgkwi6szHJpkk0uTkgqeSloQ3Bf-x
X-Proofpoint-GUID: DfrWgkwi6szHJpkk0uTkgqeSloQ3Bf-x
X-Authority-Analysis: v=2.4 cv=adH0Dhot c=1 sm=1 tr=0 ts=6aad0ddc cx=c_pps
 a=IxQEmK7OG+ZB3KQxmUR4Jg==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8
 a=EVhBSQp3IoMxQHL3a9EA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180140

On 9/18/26 14:40, Herbert Xu wrote:
> On Thu, Sep 10, 2026 at 11:34:21PM +0530, T Pratham wrote:
>> DTHEv2 is a new cryptography engine introduced in TI AM62L SoC. The
>> features of DTHEv2 were detailed in [1]. Additional hardware details
>> available in SoC TRM [2]. DTHEv2 includes, among its various
>> sub-components, a hashing engine which is compliant with various IETF
>> and NIST standards, including FIPS 180-3 and FIPS PUB 198.
> 
> Please send this after the existing algorithms have been fixed.
> 
> Thanks,

Sure.

-- 
Regards
T Pratham <t-pratham@ti.com>
