Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011000.outbound.protection.outlook.com [40.107.208.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C9331A564;
	Thu, 26 Feb 2026 13:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772111662; cv=fail; b=PHPKgJoeEO9wyvfs/IF1FF1+o+cGSqfS5iGUHUFWab92BjpynffcjOLi3EQKLUpZj3WqA8oPAD56Zj1LEbwEWQ/BmfBEVS9oqfwpAfThCcK1+qygbkqkYXr75qI42jE0kuoThe8CHM2oQFiWs4VMEUg/A2wW1mFOL881H+bxvpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772111662; c=relaxed/simple;
	bh=5uotZvaGVqXRtazLZFEAczui1bdAjF7Jm75rPYRy0Yc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=AraPMrv07RDeDkk6cVKd/8fprPXeZIRUyTu2+twwK7eRP3ccW7cV0xZbdjrQslTVXT8/xQ5NB6wrXJf5sClxtYrKPPQOWKx6Q5w+bHTFjoDOlv/8dQNLdaexfbgWoTCDXPs0brkslOXzzVXnHVKKoPRA7/sREokXlyeuPE7lmt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Ig2E0rL6; arc=fail smtp.client-ip=40.107.208.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Ig2E0rL6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xaJm+HkAhJhHk6sAiUzS5Txq0g68R8c6NB8hswCQGO04rSVmWtbEsfQJ5cEvImbbahmucvUA7H1qOlj3bML+vRRn1VozAlfRvxP5b1IJcM+CdxjlfdCagAuHCk9aqFDEInmEjlSx20hhjBDRNuOto6HmnI/LLJUFR5neHw07q5E7Fbfi9ykLV9J1kIMEVxnCa5DYWaKA/pF4tdnnVgDZ1Vt/revtZGF6CmBn7Gxm7hD/8nbFJrpPXS7FPhPIFtoTM3IDvQiwpvAPdysbu1s+B58DfUuB4MfSwVryjo5dkEFP3FSuVmDtOl8rnJ9NpTBi/kJjc5GhU2dTWG3FUy3k3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s0hZrTzoZZ9IYVb8s/7iMyX04m0cHja5ptWjqujSmjI=;
 b=Z0K9ml51+o87nhrPMFhcdjqICUBkli4TMLhDSlTOoiyGVOfnZeSZXRyiFAainaFZRxQKnvUjTWUgh1tjoT8pU8sYuNelBXZDtpOXUxNVL/aHAVv8VfcwoO3JlNoNrWT7sjXon+mLQ8o/PA0OO7o1rpWb7eq2ttBSzqJnR0iAGp7KCzlYO0xg01KUq5kjX4mtA9PwNYNCFLg/zIJK8Xf6WKqdRYtNzy/W+Dqg/FDhViIvCL/wSwD23QHVLeEJto1tmiyRH4BXR1OfI9vv6xzrHi/AqCfpfGIryx1Q8Mvksr8PCgpuNu3mljYrdj4b7rXBXpjDKLIix9El1OQdMcM/+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s0hZrTzoZZ9IYVb8s/7iMyX04m0cHja5ptWjqujSmjI=;
 b=Ig2E0rL6jNLfZzOiZjqzZ8s6s7r/hYqHHgsG/LhHBJCNgDOg6LTBHkfA8V6L84qn+mFNKtvkXcT78lPqwzmQtjR2FvuSbz1FVkF77OQNRcjT0p4E9lio4eUUODmsrjz3nNcnalMaawn2pvCFvgJBmDVZWvSTMAn1w1cgB7KLNPA=
Received: from SJ0PR13CA0029.namprd13.prod.outlook.com (2603:10b6:a03:2c0::34)
 by DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 13:14:18 +0000
Received: from SJ5PEPF000001CA.namprd05.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::7a) by SJ0PR13CA0029.outlook.office365.com
 (2603:10b6:a03:2c0::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.0 via Frontend Transport; Thu,
 26 Feb 2026 13:14:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 SJ5PEPF000001CA.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 26 Feb 2026 13:14:18 +0000
Received: from DLEE201.ent.ti.com (157.170.170.76) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 07:14:17 -0600
Received: from DLEE201.ent.ti.com (157.170.170.76) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 07:14:09 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 26 Feb 2026 07:14:09 -0600
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 61QDE6ba1920306;
	Thu, 26 Feb 2026 07:14:06 -0600
Message-ID: <8b920153-5a5c-493f-b2be-908cb1f77c60@ti.com>
Date: Thu, 26 Feb 2026 18:44:05 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] Add support for hashing algorithms in TI DTHE V2
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Manorit
 Chawdhry" <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>, "Shiva
 Tripathi" <s-tripathi1@ti.com>, Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri <praneeth@ti.com>
References: <20260121132408.743777-1-t-pratham@ti.com>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <20260121132408.743777-1-t-pratham@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CA:EE_|DS0PR10MB7341:EE_
X-MS-Office365-Filtering-Correlation-Id: 52371a74-96ae-449e-da8d-08de7538f2a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|34020700016|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	inYXkpbLjtqJHboHCnKG0jZ79YOr7cAf/ceIZd5SK8NsvcThSFDl69R+7g5UvMA83g8EsuOcjMM8reRcBnS3qJafLQ9eSKKgvvFkuAfytQ0OhW2GkGuERwa+acQ3RVlLWJP7sYx09PigNQIIdj2Yrtm5O4q9e1k/alp3pnu6lj1TsvzRJGUVabjAEElGpPkYlpqB133KnT+pid2xIxO0WTY+MIvQ7e5u9Gp0ZuI/2n2txB++osaQqYfIq5mJPGBf+5Nzo4917YNui6+DNzeDrdXXUVL1wfH44RNrHBFs7ei58/bH2WvV48rOR9xNEwd6NkCxvTDgX+x92yU0PAE5YfrpyOrsd4dbJAY3rY9YQ7ys61oSTpuDRrTp6GUHEUcx2mKofYoGLatBYwBlXxz/aFag9M3OEc2BA/ewcPHhT9PTiGX9LQHoWJE9Q7kif8FtpqsVMfDFAaQnEwc9NZL1L21Dc4SuQAw8WTz6sGKRW6gWc6zsbNwIgOJNFEkE7zg6TuD/RYULq/SulkSqqOJmRqhcJ19SsYt8Y8e1Pj5x+ltFSdjV0axEtSg2wH6Vt4g334O5b23qpXeOvNZEbpqQgBtimrnMrxTZJ1wWOUUPwNgerkBLdNgC8xYAHl0RWJ66SvClGPOO5VD+zPNxupaIsWKfp7t3V2bOE78KXdHF6ZpBncpXTiG7krBo3WXzKZWI2UlZEAXr9854puePWi2ay+CoKzISkEJ1nXwEeMRc9i071i6+q9Cmsv1wSgzI1cOKD3URrRIZjw4tmfdahRlOqzuteLGDnPwNvtJnsG+3/Gk=
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(34020700016)(376014)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HmT33BQRmoip2GyWY06/hjV9NBQ5jS3ID7NDeFpLwoHbp1t62zoNW6EeHwLnNpcqQhht7jk+zcoyv29fvgF69HMCeXdnR3VwgFIeeJYJbs9v9EJDnW/aIdLQEuZ1mnklsr04FFPlup/FZXPSMlhciHzsMhO2sqH9ZIBQQVZ9tQHwwXGHWPNGvOOt++O8Q77Ond47QDb7N43RCpTYSh/ZskVRU4ap0O/wwBA9Mxu30rK34AtafsiiN8eUwbGuXtaz8Utozb3Yn8bJsX9m2VU5ZLAoJHZDCuTEzWeLjsLq4Atte8Wypxp3Q0ts8fmlSHgrJdSFaEDcal8LGKYNPAUDygkWCFO5PbccCq6V33qWoOPetGtoSzvN7qbNlOYEgQTSwRfWlw04ssH6oPJ4ONqYj1TDywzdFw0YIpVO0eDv3NRinxQzGa6M0sZv57MN0NNB
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 13:14:18.1541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52371a74-96ae-449e-da8d-08de7538f2a6
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7341

On 21/01/26 18:54, T Pratham wrote:
> DTHEv2 is a new cryptography engine introduced in TI AM62L SoC. The
> features of DTHEv2 were detailed in [1]. Additional hardware details
> available in SoC TRM [2]. DTHEv2 includes, among its various
> sub-components, a hashing engine which is compliant with various IETF
> and NIST standards, including FIPS 180-3 and FIPS PUB 198.
> 
> This patch series adds support for the hashing algorithms
> SHA224/256/384/512 and MD5 as well as their HMAC counnterparts for the
> hashing engine of Texas Instruments DTHE V2 crypto driver.
> 
> This patch series depends on the following previous series [3]:
> [PATCH v8 0/3] Add support for more AES modes in TI DTHEv2
> 
> The driver is tested using full kernel crypto selftests
> (CRYPTO_SELFTESTS_FULL) which all pass successfully [4].
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>

Sent an updated version with minor modifications:
https://lore.kernel.org/all/20260226131103.3560884-1-t-pratham@ti.com/


-- 
Regards
T Pratham <t-pratham@ti.com>
