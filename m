Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD2E4B5CDB;
	Thu, 17 Sep 2026 10:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789639556; cv=fail; b=p6aDbO8uukajql5h1wkOgK120MWwbHWdJPoYgUfDqdOH3XXbaFCwipaCKKu2EYaKikx9HKx0d6U3KEV4qrXtPhd01CkS3SnDauycKTWxGUkVXFqj8CNKo8PXOQjZiGppN6jv9kYlmHuAIvNnss2TGX6xPqX6OdF7AocyRa1rzos=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789639556; c=relaxed/simple;
	bh=xgT+kflkwIGAG6Yrb+UVjbqrB801bj87zd+PuyodPA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dvGwvn5Ndy8RD43Qszr5u5ZchP3r/xmGEEIotPYyPyqUEYdaXZ3Eh3Anuzqy6WmvCs7Ts/ZXohNdIslfNDZJg3TTXFuki5y1xpSGqSr72n7cvI2qowXP2MiMzAm829ESe92urpuB53impe/unmFDE76AQjR3WhXxrKvfXsTmjQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=FFrhNWNB; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=ilEDMs2u; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="FFrhNWNB";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ilEDMs2u"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H9alCd990774;
	Thu, 17 Sep 2026 05:05:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=4bnKt+1Al4ixr0/ivg2/8cRZAJbVsD0C/dLl2hTCo
	e4=; b=FFrhNWNBFev6+R90HtTUQho9Eo4EKKNbPX75TURaKZ8P8PXWgE+Ryv5UT
	aEvtbIN/oS/BFQGGU3MbM/Irt/eM5+shfS4DzZiI9tOwIHM6U/4oLkVlN7NdWA0W
	8cNkaFj+TJqqma4zP4i+aYdhq+qVOQs5dpvoBBwRgNiqP7Ua+l3WESksfTH2dADP
	e7xUcGW5sekb2dInt8pI1b0DXoTRlkgT9jxiKoDG04DxPbHsOIGArfFR9N/XdBWV
	kSVTvn+j6JGu1FfPdimskHaC+JVtsfJNE+mhF3SgXtI+OM6yqX+VYVdtVhO6z2Fe
	ESL/Mb3Zp0qfphQNeCf5BrtKOClsA==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010011.outbound.protection.outlook.com [52.101.46.11])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gr8e924r5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 17 Sep 2026 05:05:42 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kqM46iAR94vWshR3OEsXMJemT+4F7TYk4TXhRoO09kPDdEGgGe9CVoZxlSnOxsGGe5OWQNu8XFaptA/FMskrXezhFYK3T1X0VjF5dczoMVztqqgCG2fNNGVHbN6ZQ+6lz4Ae2gb4I8ExJHIuJF3puVoMGtORHyEWX3fuqilfFYXmciw58gNCvVTZHGbVcihb61t5L+PmZuVlHjT8GVeUjZRuWV1B+zCPZ0jIJRskSbHPkYDHy99YXcrzBdIO0F72GkUSnSDDmKzWlYCmDz8iZgIVwTgTwA/dZqaJP3ba7cvhme03yGxhQCeoYQqLWsV5ysvNI5kLUKFuyl+Q8VrH0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bnKt+1Al4ixr0/ivg2/8cRZAJbVsD0C/dLl2hTCoe4=;
 b=qF/y1MMb+bpSSf94vQBtsQosMyy8DD6OP8GeVMJ12//oNVjuUDSoj8RNefIMNRqtju105b3VCrnbgy+tN7n7ERTjk3Fk3ZNBgq1uW8a4uyZWKHGI5YLPxoTugcs0GFyzNDeXmH/RsQAPVxouxMrZwrNBiE+jIRdor5jWqm9PI2kNgCoOiE6MFjzANpAZ+z2T5F/0cLHV2DNfdvhZ+tfeZnJj5BKOJZCXNln0NCd1xySHVs1wd0QPr5zQY2a81XbjqQJdNZb6sQ53bb0nlipadx2Bsnl3OBrJvEHqQsISNW/ZRRLiHntdLt19eTQ7Zo5HXUUL3e+YSt/D9L7pZkYgiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bnKt+1Al4ixr0/ivg2/8cRZAJbVsD0C/dLl2hTCoe4=;
 b=ilEDMs2uNSQtkUNEutuDrVlTkOamEt4WXDwTeCXDR5wkWtWFfF3K0qgrWHklolU+3mVQNTZbnuT4CbpiM1xL0zS6to6nL2qosD3PYG1TM5PpMfX42EgGnbHKZUCfsr2SihRZizyeNpoDXSeFpenGaRoy5Jp35AtDDOE4Q8bH7vg=
Received: from DS1PR04CA0010.namprd04.prod.outlook.com (2603:10b6:8:44f::13)
 by IA1PR10MB8212.namprd10.prod.outlook.com (2603:10b6:208:463::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Thu, 17 Sep
 2026 10:05:38 +0000
Received: from DM2PEPF00003FC3.namprd04.prod.outlook.com
 (2603:10b6:8:44f:cafe::1c) by DS1PR04CA0010.outlook.office365.com
 (2603:10b6:8:44f::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 10:05:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 DM2PEPF00003FC3.mail.protection.outlook.com (10.167.23.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 10:05:36 +0000
Received: from DFLE203.ent.ti.com (10.64.6.61) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 17 Sep
 2026 05:05:16 -0500
Received: from DFLE200.ent.ti.com (10.64.6.58) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 17 Sep
 2026 05:05:16 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE200.ent.ti.com
 (10.64.6.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 17 Sep 2026 05:05:16 -0500
Received: from [10.24.53.205] (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68HA5CxO2792834;
	Thu, 17 Sep 2026 05:05:13 -0500
Message-ID: <77e34131-04a3-46c4-9248-a35bb867e9c5@ti.com>
Date: Thu, 17 Sep 2026 15:35:12 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 28/30] crypto: sa2ul - route requests through
 crypto_engine
To: Manorit Chawdhry <m-chawdhry@ti.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Keerthy <j-keerthy@ti.com>,
        Colin Ian King <colin.i.king@gmail.com>
CC: Andrew Davis <afd@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
        Udit Kumar
	<u-kumar1@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
 <20260915-b4-upstream-sa2ul-cleanup-v1-28-57ab34e97162@ti.com>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <20260915-b4-upstream-sa2ul-cleanup-v1-28-57ab34e97162@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM2PEPF00003FC3:EE_|IA1PR10MB8212:EE_
X-MS-Office365-Filtering-Correlation-Id: 543c0e57-3c00-4f32-a964-08df14a33804
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|36860700016|1800799024|82310400026|6133799003|10067099003|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9vOlDX9ngl/8MD3sbh5g8/litlig/JvbaBQEzNxrqU2wUR+jkHjZ9IUIqTtSGsJz75hfFw06/obyyU9ySVUC0ZuY/m0fWxUdmNp2MR5r3QiowHZX5imLrtR6BL//sbyRm9TQQoI073oEG1F7m7GiYKwfalVdI8LEuzjS/7vapVZ4lvBjyzQIO0Wd5hsEf3sungW3vpWURAnsO7YIW412TovxKfztYY2iDi7gPGkUlojDMlOcxVWol3QJ/dRIKzDe+TSJxoEk/smAnSiK0fOVTXIRFc7sPllaNIszhNfMNOcjmzL6nq0KjPh5OwFJz2hE9j8fr0/JWwdJrMT0wLJHGK5ICXnnZn0rSUTtlYPCKVj1+Jc3jmOgu4wsMzYpStb4rb2o9jkk8czK41Usi+HUSSFzPSEvKmrNLDq3IuBs3WuBI58m7wKCT3xepr2YQP9inertUBHcZNvMsF/cnpbRHpgUlBhwCaOoGv8XAQdcblZGanO+a6LrzEvB5eX5+3u01LtaAseHDM+xqII92bvEyfdu9Qswh/Kxgqp2E+SgJ+RTTAu5KsgRUPzeTo/iiyzX0ydoFQkNdghUD6pNfdEQoN1xmRCgmdKfDdFWASKSpJVqM7HCDwkRilLLCWL350dAaF0KoTsu47+wVCZTqgmy+OeQQkAkbdMeudj2slZwZYw8pFQoxDsx047h4nbQNfD6SHjqFpusEW9M/iO01wivqg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(23010399003)(36860700016)(1800799024)(82310400026)(6133799003)(10067099003)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5RJLjk29X2Jxb2qn6cx+DMk97k06sKFM0USvM9Aidlgb4MjzkrMoG1pqUPo/fdZ3gXe1hd/S/Lw63h42MTQmXLuKz47nyZpeuutxvEeVOPEbRqpfiW+w0Mfzx91kQF0ChTLIh9/mgxUCb9rEFF1o7Clo30H+hjkBtAN5ldfjW4uEnxk4O+nl3Gboipzt9bEXFNGp7ob3gnjcxv3Sf2PcD6NFJd+SP8Gu8ZFsPYopU0L4MQW/mkTz9CHdfXLcKImPsGaYmLxSZBS3h/DHH6qoC3byDGYBPdJZSaAtGKuB5JQV7shltstswObt0UZqXuXKVrKZdhzvGfg2YYN1hNMLuMiNwSqbrVzV762uGicmMlNWiwfPu8TVBv/9qTKeIR9z3JMltAaSqcjClsfZhMz4q89QqJrzKGY7uQ7m+SuHHes9SuszZY+UEVrL/SBpYYch
X-Exchange-RoutingPolicyChecked:
	lTEtH6alY6DY1levKpIwl2zKJJ+okdia/z/ZeU5rYXxY4wU73fys9RAlF94xlUrOxKcBjeiQoVUT/s9/LEWJLRFDDJ44CY4ViWretrUYl94f7etj6BigHa9KXKRrACNNLdbWJHE6w9kYOqiCMCTl0teGGhgnEaAV42h9YCszEKdEYH50L7QBz9dgGfkLHfRwC1zhUKTRlJFSfUGrPAeWRQvay0XFjY7Vv4C+mm9WYw7UBAl50XikhBytJbaHA/riv4fPsn/2oPRzdCQmwVssRNnAR0SXboFrO7Zq6AQrxlSL446KlC68MdiK7QWErA4b3fObUrdoubTbK1jQuKMPVw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 10:05:36.0953
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 543c0e57-3c00-4f32-a964-08df14a33804
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM2PEPF00003FC3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB8212
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDEzOSBTYWx0ZWRfX0mNDxn5aL675
 RkuEyK/3p6FvUi5stAzO2FzEKF4raBPdjnxYCw/8c2AM0LH03InixQ7iU0xj63SEmxwohm9SaAZ
 4D6LkAIFPX7IhN3GRkit72KYC2QlG6s=
X-Authority-Analysis: v=2.4 cv=B9ssQ+tM c=1 sm=1 tr=0 ts=6aabbb76 cx=c_pps
 a=kVQeibrV0jayZGAE3rze0w==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=rl9yUtl6zSBYJuykwuEA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDEzOSBTYWx0ZWRfXxoDzwOf8hT/Z
 h0hfn8VeuvV1kvYa0c6NzisnXnFOH6shSWRHHH0deUsElF71NHZn2m859U0h0dUjP7MoMO675kU
 t/2pFVTx4mBE+PmhVLVWMPG8qJBAF9q5cg92mH22E7G1XfA0eY4lAKF/+62+sSVK7ZV9JFmEwOC
 C0MaCLu5crWJTNXKSjTwLi0+A6scrsLNZeE62694QCqtk9w+xjaZfNRH3v4ntnhIwIAGcu+KU2o
 HF/55GzFRGJ0egnlCatjWDxIP03TvKUK0X8ghzhQ2DonCRI8ZlUXVUOu6A+GVPFBK/FYilMHqcB
 XDucKH8KDknK6uWpeUW6IQ8FnIFQkqHDeNaycElN224R8exSlAsYw0Z63mzhU/Q5gdD6p5Q6Z0j
 JMTq/V8EjekhKPkt4RcFexn8cdcxuYZVuS32wW6+3PI5pq1k/Fr9Rimd56iMicNBDSiupgjIOoW
 b9bxd4b8KZEDRPZXxqQ==
X-Proofpoint-GUID: 4SvyI6krII8ykyFwMG3ajYTS1Uk3jrLU
X-Proofpoint-ORIG-GUID: 4SvyI6krII8ykyFwMG3ajYTS1Uk3jrLU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_02,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609170139

On 9/15/26 15:25, Manorit Chawdhry wrote:
[...]
> @@ -914,8 +915,8 @@ static int sa_cipher_cra_init(struct crypto_skcipher *tfm)
>  	}
>  
>  	ctx->fallback.skcipher = child;
> -	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(child) +
> -					 sizeof(struct skcipher_request));
> +	crypto_skcipher_set_reqsize(tfm, sizeof(struct sa_cipher_req_ctx) +
> +					 crypto_skcipher_reqsize(child));
>  
Last I remember, crypto_*_set_reqsize() type dynamic reqsize setting was
being deprecated in lieu of cra_reqsize field in the algorithm
registration struct. Should change this to that.

While we are here, also rename the cra_init/cra_exit functions to
init_tfm/exit_tfm as these are no longer associated inside cra.

-- 
Regards
T Pratham <t-pratham@ti.com>
