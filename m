Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F80D302753;
	Wed, 19 Aug 2026 07:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787125172; cv=fail; b=i7vsybbjFoo19cW2Jkphu3a/GUkUZCT2i+Ymfmd3yw+5AaZF6S6/RFCUDUPINg4aOmJv1ouilGAVzgt7P9UYbIgpHhp8bF3T05sg/fiAauZGsrwjl/u4kzysPAH79M6C6Kscps7zKstA5HA52Wnz23AoDr569q92GqMz/kLrRkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787125172; c=relaxed/simple;
	bh=3QblOpWzuWCempJrenMhkWsMU2cg3Y9oVRQM9Yee6xw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Kb+bRiOatS6CTsArezwV4zWK9ZG5SXQnmV8f4b/jd6wYHE45hQkOYrwKufA3jPKzGGI3ZCPn84DEebJCGK65Bu3sP4mCWErzRNVoJZjhPexPgZRZC21vTPh13iSBTp94LgbYdtQ+BqEX+4PlWcLi55/f3uHbrSVxjJC9Q2RA1Pw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=OoJ2huGu; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=MmuqLs5D; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="OoJ2huGu";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="MmuqLs5D"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J6VRQ61392620;
	Wed, 19 Aug 2026 02:39:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=VGzUTWfBIcHjin4TBycGeFcOE6VOFc1LmefNfJrCL
	Qs=; b=OoJ2huGu+cUZvwiDUXap6lQd9D82AtL2I2/un1dRgRJXTzMYK/Z2d2l2x
	LR3F1PQZutEP4GTg2uZE4UWeBM3PzNjGFA445Mf3/duPrbnhwdzHOywkkWYkly64
	2GhXn9bVWVPEcQzBM1ZZxavoLVX1JxsLi43CuGn8KRPgF0yq3cZxZZQ3rf0qPSFP
	7zeYokLrA87p7EseZOeBmR5ozYo4K5EEDa3KW3nnEu4rDjX3omCI7H0Br+DSS3wy
	r+B3gwxGWzqQ0hGPaLS1ybn84TepTg4iA3RtTJT1/lG3miUhcIJuMLpCuBUXDi3K
	JasWyeGeE5ddp7Y+eSUUhRZ79sqXg==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010033.outbound.protection.outlook.com [52.101.201.33])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4g4yejjxd2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 19 Aug 2026 02:39:22 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BRtS6hbEG9WmgmUqts6gjWTYj3k3JqOI5vfIALeSy69GY9j+1HWPrEHLSgsmWQLXc8MRaFtRCks1jXLaKMpPsj89sQFFgoHNDTERf5DufuTOI+FVt0MBJiUvW2NO5f2b7pk6ZmixNTYiRYFvfkSvgCSplFR72WiZ+Trq1iKnVf61k7MwWJHr0ZYbmGru6SPrGxZiTODP4HqHu281xPnnx2DotkFPDDo//RkgBkGHI5ySJgdeUSmWPsY7TMpfiSw7vQBAlArL2PNradVoaxw0kAuDGIIZAPRq4wmVmL5u6dErsOiLxLtfT8l7ZU6FxI714jywJn/zXhROBM8V7js1rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VGzUTWfBIcHjin4TBycGeFcOE6VOFc1LmefNfJrCLQs=;
 b=HJ/l/J+V6hazAcVsqrt12P8xBmqzuFmZGzymgYDTImC4eM6b+7CM1Rq5cUvtF+CZ7TOIXPVsOvFPr80V13646yCH7ArwAzLPxprd0ADmA2mLfcO+Q9ICB6ZnCJ5ZOvATsSQubnqp2zPuPEGtYulusswfJ3W2xzVI7Y4gAcowwVx+nTmzgccYxyKZdwUm2R/QSl4lhjZkk2wYE9sfYlQrDl5kzXsdN4bR+pF/HsHrqNNSWX/C1g9EU08znUpJWK0xCGC3qXMAOZyBGvy38/MF5clDFVt31RIZUxiqtrdQtyASP/fyyPyDX6eXU0AvUex41oleJCDOt8eo73xaCRvvGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGzUTWfBIcHjin4TBycGeFcOE6VOFc1LmefNfJrCLQs=;
 b=MmuqLs5DBWz5/SHVoGRfiyA7riM1g2T1WlOWdjKabZebaogKFOJMJTHQYqdAlGftv7W2hmNENsiNErTXohvaEqgjU2IRvkOmyMCyrL9L/eKfQW8WQgsuL41Eqae//+ORcCaVVi+biRLZ7umCIr5W1CW2VlozdW0KkYP0IDBBJNI=
Received: from PH7P221CA0010.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::18)
 by PH7PR10MB6250.namprd10.prod.outlook.com (2603:10b6:510:212::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Wed, 19 Aug
 2026 07:39:19 +0000
Received: from SA2PEPF000015CB.namprd03.prod.outlook.com
 (2603:10b6:510:32a:cafe::2e) by PH7P221CA0010.outlook.office365.com
 (2603:10b6:510:32a::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.8 via Frontend Transport; Wed, 19
 Aug 2026 07:39:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 SA2PEPF000015CB.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Wed, 19 Aug 2026 07:39:18 +0000
Received: from DLEE215.ent.ti.com (157.170.170.118) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 19 Aug
 2026 02:39:18 -0500
Received: from DLEE215.ent.ti.com (157.170.170.118) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 19 Aug
 2026 02:39:18 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 19 Aug 2026 02:39:18 -0500
Received: from [10.24.53.205] (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67J7dESn2966579;
	Wed, 19 Aug 2026 02:39:15 -0500
Message-ID: <b2d9bced-9ffe-4ff2-87d8-20ac9aab33cf@ti.com>
Date: Wed, 19 Aug 2026 13:09:14 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/3] Add support for hashing algorithms in TI DTHE V2
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>,
        "Shiva
 Tripathi" <s-tripathi1@ti.com>,
        Sebin Francis <sebin.francis@ti.com>,
        "Vishal
 Mahaveer" <vishalm@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>
References: <20260807110501.975130-1-t-pratham@ti.com>
 <an-8NYJ1vo03NpRX@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <an-8NYJ1vo03NpRX@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CB:EE_|PH7PR10MB6250:EE_
X-MS-Office365-Filtering-Correlation-Id: f90abb38-eb6b-4aa8-c6c1-08defdc4fa5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|1800799024|23010399003|56012099006|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cjT8WsR9KtePkoxQeLV3I6sjHn3L8bFMyWX+e+9U1Yvy2gquqmRQ+gEodXvXWZZ7EnUnCGmBNVKGAof7c0I+QBu58bFxsNJpeFOHWnkOkgD/IXU5iUY14wKDMjhr1cO03TQPBVdKq+rl5OVnmpapyXCZizJUAcfo70HGodbWdLowZfqRyAUIhg7JBN485RNPegvwEr7FAetUQv/YtU0VMEUE6uK7IEV1anEUBjKvHEado8essA8le11DtIr2apSkrQgHupVQcSVLLiDJUnjP7lebk6BhQtdeOZxX73RpRy0j9URlSiTGf/lAgzpcs2b56yKUQ2BhdPwfUKsqVGnRrZgCGzFKkTmRY4FrRVAnyO+QGZ6hVUsOYlhilUAIhXUMyxzipGKQIGl5RVxdDlSEGamzBuhHnVK0GTVjQk7muipMdsQHgJ91+mLTwBVyhzS4/fGkguXKaLHzQAHsrBKotl1vRJlKay6tv7un1pBNvxdCLYbsXn7qZ0RkUH7J/dprsBvRVBG3z1/Pq3giowZKwsHuFwxgVPaYez9AjqbedgKELOlspVGcrdogA1qbxRsHgW+ffR2qIl5bT4Ubu6RFDcZiJceKtaqhC7tg1pi5hc834PuvJAT4jNmcKSE+MC/gwysFQx9gV37SICpooDujZw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(1800799024)(23010399003)(56012099006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1gZRchhqDC/K3Fpx320S+V3nkJL595sbtAadshr97OxsClEqtTzKGlFeaB+wH0lOAmKjGNB1c7WZ6As68IcQBi3kuB8aRIBKVaEoJHzq5AtdQVh2XpV62RbjKOJgwvKnVsNxQFaBg1hlaKhDGu82BjMVcZd4Pj5CCOMyaJfLqU17c/oKLlCHBuy29lHMRxhPcocGMhOuJgfFiROS/V9V2OBwO9LPFn17/Fo2IkJ5vwZy55+OFi7ZAMRKljG7T0yGITHNC+GUgYcH+c0rCqXDRX7MLZ/99TQa6hb6i8NMjCJzdGaYxxyf0bhA7dgci9qsf65Plox9VTjWQQf8bz7zVqKYXD7s3dCrI/nwHVf0IC4r4Q5SBu5x0BLIzuO+W3NAOHnQta1PAEB3wXYngH/qtMceEzlDA/GDFvqB+WOvgkXZzNSI7cnm4isafkbkq74d
X-Exchange-RoutingPolicyChecked:
	alxBZCa/waEXy3o1s/5BLFoJlG4vFidWFFPTL+A3gktJae1O+mZoHmawBZKMJw1lDYMZQGssao6ntDM/QG0V4LgfW6mNFIalHlsF0bYXH9FcE9s5/SO9XWT+BSvuvq8Ajr/eTfSlElnKB0L/5t/YhZREuWU9U/bci2chKa9LrbRwMbrqY9tvNysmaKZctdpw/LwqbRroa9PS4U24S/e2g3m+xMFPwFSmsECMmyzcHWrlxZ8qXw62ArNsgjd0C3PowSRyk9xOookBP0fVTF5UIJPkcyYzHCPqJSVg1Tn8vYFDZloKI9Ao1FAqFtHM0Skl5+bsFtfNNJmdB9kDyYPf6A==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 07:39:18.8265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f90abb38-eb6b-4aa8-c6c1-08defdc4fa5b
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6250
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA1NiBTYWx0ZWRfXzAxpJMmmJwZi
 KRpjl/clUdUSvF3D1lozzVieiSMxJehdR3KyGLfO/1lWRQBKDuaU5X+AscfMLWSZnWbr7ZN5BEp
 ZQlMZCvTPUipNsJXLLNiIz9zFHidcyg=
X-Proofpoint-GUID: J2t7RrXOuq3s6QPW0oR0c2DWeNflSgYW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA1NiBTYWx0ZWRfX4H9UW9hj1MMK
 nULsqb1oE7cBb2zqTG4Q3OwPPEXwfAQMa7LZlEonBROKFPj/U/Dx1E/pKiIpomYSMwU1z60e1t2
 iC7z8maBkdMK3yHiSHySmNHZHIH4cc7o2RQ68j6VgYC5ngZoj8HNgK00dt/btBDUTUJ4V53Yq/b
 0BVfgDS/GWOq+1M5xtQ22sF1OFVzg/H2MuphjrI2shFjncU1gN3JEXGna+zjq7Fv7dWsZqxhxve
 f2iX89+oQQkagHQRNUigV/ZCTK0tS4LpRn50BBe8y2O//G+x9pVl1DHYbLbMGlxctdrjc0l+dTc
 ML9A+h5vl51mZjvvme4ZoOS9jNg0zTn3ejwjoWIIEHOVINv6V/BQdIfO4T2FvVYZkdgB2MFdBym
 FErYn+00iItWwQSn8efG26AD6XNsQdkQeSE7Kk8rrJkEnmInm0+l8qD+M8iAV1bFoBwhsygiMs+
 YNGr2eoAJyYnyn7yMQA==
X-Authority-Analysis: v=2.4 cv=f854wuyM c=1 sm=1 tr=0 ts=6a855daa cx=c_pps
 a=EZwmcie8zcfNvCQIxZ7BwQ==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22 a=c92rfblmAAAA:8
 a=sozttTNsAAAA:8 a=AqCbb_Hx6d1N4N36wWsA:9 a=QEXdDO2ut3YA:10
 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-ORIG-GUID: J2t7RrXOuq3s6QPW0oR0c2DWeNflSgYW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_02,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0 bulkscore=0
 adultscore=0 clxscore=1015 spamscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190056

On 8/15/26 06:39, Herbert Xu wrote:
> On Fri, Aug 07, 2026 at 04:34:56PM +0530, T Pratham wrote:
>>
>> T Pratham (3):
>>   crypto: ti - Add support for SHA224/256/384/512 in DTHEv2 driver
>>   crypto: ti - Add support for MD5 in DTHEv2 Hashing Engine driver
> 
> As even sha1 is being phased out, there is no point int adding
> another new implementation of md5 into the kernel.
> 
> Please drop the md5 code.

Ok.

> 
>>   crypto: ti - Add support for HMAC in DTHEv2 Hashing Engine driver
> 
> Sashiko has found some issues with this patch-set, please take
> a look:
> 
> https://sashiko.dev/#/patchset/20260807110501.975130-1-t-pratham%40ti.com

Will look into this and update. Thanks.

-- 
Regards
T Pratham <t-pratham@ti.com>
