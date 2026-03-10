Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013032.outbound.protection.outlook.com [40.93.196.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFAA128395;
	Tue, 10 Mar 2026 17:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773162350; cv=fail; b=NHhCPquaRT0seRKsCsu+xm6BcHVTzlRhptIxYuzVbEe9nPAAct+jbX/QCgzygEktHjJahOf/lIvSgIb1f/g3uOKPcATFRHeRhVShava4ytNpSm228bgIbDu0TzMqQKO29xIMD0M2RO+ALD39ICaoxTgeNi1p1nLVVvFAWTdg5gA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773162350; c=relaxed/simple;
	bh=D7COoxu53yL8ZW1rkJ/DGXCyJHD8s78PWT63jO3X9V0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qIgFfIw+yCOAra1K/rS3fpB3dtZLYGarXx9PpSY1s7jirCROkuaSrmM2LAjR08Uh8X80eiE1guoHjTCyzHwlwf7FLxsGOHjQn1oRffofwN2NdBmk/YRbYBdJuxJusPSvE+tONN9w4LenJTSyBm5jrN1/XTDHvgFK0buAV1yVDtU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=cnmNRE47; arc=fail smtp.client-ip=40.93.196.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="cnmNRE47"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=abuIn2oI4aaoDUJVRf0DCWo98bwbIuAlxqMatNyRhDgJqFACUX1tkBWQErfPW3rTIde+enK9uQ4t7QL2C7t1RZqyMbXXuqAq0X4zSgzsZ8Co6q89b53GLTbHanUrejw5amEpoMzIjh5JfPIhBmT+CgkfxICNSn9mt69sUz1LjoIWzOkQAIPcF1tWPKZCTbHVbjJ6jo42a3zI8lp2sdeywkP0aFBxkP7Eo/FylAJiMjed8ewQGeAmPJS3hnECVIVFVWtUSiHrnyHaEQwl3ZfJPDdkyR2polMcsFpzfJKOhr0TczPhXw03Ng7vewFx0NM7hNGikR6CyYcxJAemztHJrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oS5BxVLdaqvpA4OKG4kb54wwqH/Y8JUyMQdF61z36xo=;
 b=zGmlztK4WX8KCrNj04pTLcfcvVH7MRe6AYhuDbC+DgNsM3FubMkNr7wmcAUqEJRVQp/zcLlCKPRXvfK816/V/vAu525xWsTWo8yBCWy1y/qW2u7Xmc7JqsLW3r2e8dCO9Mr1Pj8PCOkRxQX5TvjKrbALT4Ryt3ekB0xb5ZuUkTIvmA6BW3Orly/RGwTiNTRdkXwsCmQ/9ScpZjCpkx/KDKZ5QBtMydpnbylFnpopZDynMq99POfkVDklb1QX9VXBJZ0MRE7v9ru8GvaQcGhZ/KrzOuT/Zkdd5pk3I2F2jpE7SIobNfzj1dyDSX+r2+SIoQ6IY6uY06C3+TW1+YDRow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oS5BxVLdaqvpA4OKG4kb54wwqH/Y8JUyMQdF61z36xo=;
 b=cnmNRE47Pj1ZaAdmqICbCg6ALRuBlDt7rUy5b5yRziLz4wXhDYYqrZZu8O0S+kKHhccB9we2kPUsWB3fbpmlc2tnx4pCnCOR4suevQfmMupaja2LThkhW0T6/77zy3AAeGLuHcxgIVToAL5iUhBW4+oAJvsj+XQakjLlTqTxFow=
Received: from CP5P284CA0060.BRAP284.PROD.OUTLOOK.COM (2603:10d6:103:97::11)
 by IA1PR10MB5996.namprd10.prod.outlook.com (2603:10b6:208:3ec::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Tue, 10 Mar
 2026 17:05:45 +0000
Received: from CH2PEPF0000013C.namprd02.prod.outlook.com
 (2603:10d6:103:97:cafe::cd) by CP5P284CA0060.outlook.office365.com
 (2603:10d6:103:97::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.25 via Frontend Transport; Tue,
 10 Mar 2026 17:05:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH2PEPF0000013C.mail.protection.outlook.com (10.167.244.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Tue, 10 Mar 2026 17:05:43 +0000
Received: from DFLE201.ent.ti.com (10.64.6.59) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 10 Mar
 2026 12:05:22 -0500
Received: from DFLE205.ent.ti.com (10.64.6.63) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 10 Mar
 2026 12:05:22 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 10 Mar 2026 12:05:22 -0500
Received: from [10.250.149.68] ([10.250.149.68])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 62AH5Gah2954412;
	Tue, 10 Mar 2026 12:05:17 -0500
Message-ID: <26303ab7-cd14-4560-8872-021229faa137@ti.com>
Date: Tue, 10 Mar 2026 22:35:15 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/3] crypto: ti - Add support for AES-GCM in DTHEv2
 driver
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, Manorit Chawdhry
	<m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>, Shiva Tripathi
	<s-tripathi1@ti.com>, Kavitha Malarvizhi <k-malarvizhi@ti.com>, "Vishal
 Mahaveer" <vishalm@ti.com>, Praneeth Bajjuri <praneeth@ti.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20260226125441.3559664-1-t-pratham@ti.com>
 <20260226125441.3559664-3-t-pratham@ti.com>
 <aau2bg4gdM0VPcEo@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aau2bg4gdM0VPcEo@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013C:EE_|IA1PR10MB5996:EE_
X-MS-Office365-Filtering-Correlation-Id: ebb13361-ea29-4e1c-1f9d-08de7ec743fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	BfX2hDi7hnUE0/vkEpOqsaTKNprTvwEPOBWQm+J7b+gsJyxVUYo5azGI9StVe842aoPPV3IiPg636X7cWjtkLaTIE84v+T8QkLXzt+zi/XOYxChhF1++KNuUhLHMNEwlyyZkaI9PBujUFG5tFwwJJpfc/Tx2lvqeTSsTz45WTpWwPNm9zbfLEd0lY7LmuQI0njPoE1LDQpFYmSF4xmCSjPJCqTux/vLJHC41xvFnxL72hVrEH1p+FsJgO3AeQHroE2kB5PSZlF6+v9lrNUJtrPZd8jETNChebktDuAt1I2Ci95ZUC6ubukxBja6yNwi7TFNqLNfctSwgWdK6TSgSPaky28Klr7EjgXuSLawi9689tkmgWWMEDo7nIsHToPcfqtqRTPQxeO8xhHSrmZpZlS9KSHHIzL9dTaQCFySSW8BSUf4h5gM0XXu6Bt7JCVsIYLM89D0VzeDXAZNP+csJ4bLWaf6EZ4f/blXlutNRanYOfWcY4UaP1D73MhJkb9d/EHGR3n+8BUBzAiiKvB9th2EK4WqpvqOfNahRkNmxhhqF002J01kI8Zc0mOEC+ng3MTPHR/Bz/ok/5VvhGxJdco1Vri2f/2r5xZsVRJvppQZUmzp1YnnvhaCrkyHULdRGjNnlwv8lzXxVT6eXtZqVEEFJylRtnxkgqUJfCtGjrWWSTfSqhdAj2pb+MoFDbkiIT1YAm9jNfCq/4N8Ed+gYRWRuo2Pi1kfMndjVzPrT6oSiyajzOOlctl7vtQ3+2UgLohUuhMzSXCC6uLct0I96JA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nYgGMPOyBFYYmzjOGs2Mg8jEtXOQ+dqrxSBPN+uyaWzlzYFt4+j6/JpC+NatHYd4j7nox0jDKV12BsvYTo2tF2XNxZwR8zdPw9WfaS/NCgjF8Nubrwu/IUd7fQwNKwV9nE3oRFSoRuUBRMBfHKXWGTZcW91ob04jKcjlWL9OC7I9FtK8uXCmTk5LMVPI8btC4Dd11R0Jrxgvvbgv0pw4D38iNCWAcuKODHnFJCJwd7OyF5B8YBNVrRRNxvbAgS1v6LCJXUg6y0BnlQcWWyotqJ61HZdTdd3Z7xsF1o7w/IRPApeBMvuSqkgdvv302o8scKzB6vJalPuQPvVoRI3vcqtGflUOzFKm90GYBMUhT5+ydpEq30CgYDucYlv9iJcMbixgcjSzJETcpJgR6QYqJ1puewhG6N4P5NzCOYApkrfpX94PZPtwVtYsCDhCrACw
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 17:05:43.6305
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb13361-ea29-4e1c-1f9d-08de7ec743fb
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5996

On 07-03-2026 10:53, Herbert Xu wrote:
> On Thu, Feb 26, 2026 at 06:24:40PM +0530, T Pratham wrote:
>>
>> +	src = dthe_aead_prep_src(req->src, req->assoclen, cryptlen,
>> +				 src_assoc_padbuf, src_crypt_padbuf);
>> +	if (IS_ERR(src)) {
>> +		ret = PTR_ERR(src);
>> +		goto aead_prep_src_err;
>> +	}
>> +
>> +	if (req->assoclen % AES_BLOCK_SIZE)
>> +		assoclen += AES_BLOCK_SIZE - (req->assoclen % AES_BLOCK_SIZE);
>> +	if (cryptlen % AES_BLOCK_SIZE)
>> +		cryptlen += AES_BLOCK_SIZE - (cryptlen % AES_BLOCK_SIZE);
>> +
>> +	src_nents = sg_nents_for_len(src, assoclen + cryptlen);
>> +
>> +	if (cryptlen != 0) {
>> +		dst = dthe_aead_prep_dst(req->dst, req->assoclen, unpadded_cryptlen,
>> +					 dst_crypt_padbuf);
>> +		if (IS_ERR(dst)) {
>> +			ret = PTR_ERR(dst);
>> +			goto aead_prep_dst_err;
>> +		}
>> +
>> +		dst_nents = sg_nents_for_len(dst, cryptlen);
>> +	}
>> +	/* Prep finished */
> 
> How does this handle the case where req->src == req->dst?

What potential issue do you see? Both `dthe_aead_prep_src` and
`dthe_prep_aead_dst` functions use `sg_split`, which anyway allocates a
new scatterlist. Even if req->src == req->dst, the src and dst from here
on will be different.

-- 
Regards
T Pratham <t-pratham@ti.com>
