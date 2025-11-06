Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012049.outbound.protection.outlook.com [52.101.43.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B56830170C;
	Thu,  6 Nov 2025 08:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762417555; cv=fail; b=sDttsLO/YeWbt2l9h/ASSxS1glls6Q/SD29gEqNTG9VfpSRphTj0aERAZGZ/5PohoF2UZEoUG9n6oTrbHy6HqpPBOuh8WKlMS34qbxERPmfadbo/6G1/z/aOS1gdsEB5i6XyW0obGAzr7z8ZIk+2YsC+oN1M/UaWgjQJtMTr4ck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762417555; c=relaxed/simple;
	bh=Fhi2pumzgWII1oMyvmJNe4QYWBPI4iv7GHCgbWrKd6g=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=uMKhtaUpU1ckRI9CoNS1RIRf/qZda4wmPgPliAim0v1hMYPEHC6t0EN/3oA+CSPBEoqZvO4yB05E57OK3iiwJ+kQTOVucyuV4R6tx3h0UNCpaPgyP0B4F+oSUWfv3AmX/iKrZh9S4X1EMI84MU+j6zIx2YhhkeZOkn0HWYAJQ9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=CqBuS2gp; arc=fail smtp.client-ip=52.101.43.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="CqBuS2gp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D8p4DOEcGlzNFsSXC3eBWP/zOvycVOyDkwFkWOsLus7UiXzfjDj+jRvcLO0ApaACE4yT6c3/gtm58fEuMYhdOaMA3xaaPlmXJPb4diBlNF4QJyJ0lPkzZNDVMrQ0WOqa5hd94eQfVMZN6qPeZyT/XeeoeQb1DqXid5VwGL6Y+6y22o/W8D0YCDqDOucFqGejHZfcfdiQjD+fT4IAgntK54VkMQl060uyLj5IFBb0QmaNgLbmmtI5PEevuxyhxqOCqo/16LS0wAX9oBsg9THhb8mknv4XTr8outgXmXg3W75gzSqMONaJidFXgOBgvZdOY4V3apfMA8fQv7/TZdTt5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=40bxVa9NdKeTMQZnQAZ/jDR3xNVbQvwwLVMioTyJXms=;
 b=oTQAsPKEdpqqR7qEhMOFkUEpdjWi9Y+Wb1zCgCo9RCjxyv5h7wOEXioM9zfo1PLN1bdsyq/URTRxqEDL1x4Wof5ObklptLq25U7C837HlVJOISU6KVKDU0H0YNJDaALgIRIy9F0DGVPcFXEz0iZavmJzDdvCZanzmdFzlniTnlbxlemMsf2NfgCBWySmJZ6Ilej2tQ8DKerVrPdWJ44/Nppgjd3SEOT9pC8AG0RXu9WgCNH+WT/U83bBoVrJ7ieCGM9h1sdwdIAJHmdvGEq9wG/S1LrCBrQCdN+OQuG3R7ya88T2P+QNfSNXEeYpOYfInkIOwE5tI0+RIBm5ehV7ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40bxVa9NdKeTMQZnQAZ/jDR3xNVbQvwwLVMioTyJXms=;
 b=CqBuS2gpZ/MDgDjAs7n2PPEBUjOCmo+DBjrQMJ+XFhp/0mS/BczukeRSGWdferVyjOzt8vhMSW4MZwXEnNrVucoMGHA/3sf8j83tstG/Nmpnny2d1RqLfVK6PbulV2MW3oM7HcpoFjqb+sh3+iSPOZ63UoILpW564XBaYwJC4pk=
Received: from BN0PR04CA0136.namprd04.prod.outlook.com (2603:10b6:408:ed::21)
 by CY8PR10MB7266.namprd10.prod.outlook.com (2603:10b6:930:7c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Thu, 6 Nov
 2025 08:25:49 +0000
Received: from BN2PEPF000044A4.namprd02.prod.outlook.com
 (2603:10b6:408:ed:cafe::ff) by BN0PR04CA0136.outlook.office365.com
 (2603:10b6:408:ed::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.12 via Frontend Transport; Thu,
 6 Nov 2025 08:25:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN2PEPF000044A4.mail.protection.outlook.com (10.167.243.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.6 via Frontend Transport; Thu, 6 Nov 2025 08:25:49 +0000
Received: from DLEE204.ent.ti.com (157.170.170.84) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 6 Nov
 2025 02:25:45 -0600
Received: from DLEE202.ent.ti.com (157.170.170.77) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 6 Nov
 2025 02:25:44 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 6 Nov 2025 02:25:44 -0600
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 5A68Pf2N953136;
	Thu, 6 Nov 2025 02:25:42 -0600
Message-ID: <afabae10-95fa-43c2-8929-c6d8164a56f2@ti.com>
Date: Thu, 6 Nov 2025 13:55:40 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] crypto: ti - Add support for AES-CTR in DTHEv2
 driver
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, Manorit Chawdhry
	<m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>, Shiva Tripathi
	<s-tripathi1@ti.com>, Kavitha Malarvizhi <k-malarvizhi@ti.com>, "Vishal
 Mahaveer" <vishalm@ti.com>, Praneeth Bajjuri <praneeth@ti.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20251022180302.729728-1-t-pratham@ti.com>
 <20251022180302.729728-3-t-pratham@ti.com>
 <aQSDLpD2LXlqILku@gondor.apana.org.au>
 <f4c339e3-0964-469e-9cec-eeaf2e2f078b@ti.com>
 <aQxM2z9kC6sTqBZ5@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aQxM2z9kC6sTqBZ5@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A4:EE_|CY8PR10MB7266:EE_
X-MS-Office365-Filtering-Correlation-Id: df25480d-ce9a-49c5-24dd-08de1d0e1765
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|34020700016|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z2hpREs3bG9kMnRPYXl5NytqS0hVR0Q1ZnFlNjFHeWNBM0lGL0UveEYva3Ns?=
 =?utf-8?B?YXNpekU4M3V3aXJBQ283ZTFuR1JmZzRjaWFBTUZBMHB4K3ZMcGJZcFNERWFD?=
 =?utf-8?B?NjNkTSt6ZkphQ0grdWZBL1N6dzlHYlRFSndjTU5VeGVnRUN3bkNFQkVHTGUr?=
 =?utf-8?B?STR5R05CZDRrTVNZcGVjd0dQakJ2MUc1RE1XK0M0a2duSmV3M0dPSXZsYnd2?=
 =?utf-8?B?TmJUNHlpdWVJeFpudGNubTlqVUJzM0tBVXcrVkF4dUlINlNyT0pvTXpmRTUy?=
 =?utf-8?B?cStxQlJ3aG41RmpoNlozRGhobURpWXJHcXdyUHMyRnVmY05JNnFOOTZnQ2s5?=
 =?utf-8?B?RFRFQzBpUDQrbnlXaTA4Y29YTDFDOEVZQUxSdEtrSjYvcldtdG4zK08zNnZu?=
 =?utf-8?B?blVFcFBJaGtxdUxISVdaWkJVSUFoNXdSbnRaZHJZL2dzQ1R0SFkxeXRwb2hp?=
 =?utf-8?B?NEJLNjh3allweTluc0hCSkt0eEVTSjRleG93ZnorZGRhV29YVEh1b1gyYWZv?=
 =?utf-8?B?ZGZweVp0WDFxV3ozNzdVdFUraVpPbEZlMkx3bkQ1a01TbzRJRE9tN0ZGYmxI?=
 =?utf-8?B?b2hWbWZHRVVpNmNVWUdzbTVKRGlnRTdQZnZzTnNpYUhBdW5NYTNRUGdtVnln?=
 =?utf-8?B?UUs4bVc5cWdJMW1WVExmUjMxd3lpcjdtemxZck1nc3h6T1A5VFJsTFE5Q0t4?=
 =?utf-8?B?RGZDK1J1Z1g3ZFRCUTJCY3VqcXZqazFkVFY5WUNjbDBNMkZ2L0FDN1JuQmJI?=
 =?utf-8?B?TUROcXpQWG1hb3A0Y0RNeXQ5YklRdVU2aGc2VjFkSnZZR1RZTk51U1ZZcTZO?=
 =?utf-8?B?dmIxZEJObTl2cWVQaGNZNTlTTDFxUkF3dElyS0FnUlNHY3F1dmNicS9UQUt4?=
 =?utf-8?B?MkJacm53TTBoSXR0ZFJGaUR3VXhLa0xPWEpabTcybGFaM0pmYVMxekh3L2tv?=
 =?utf-8?B?N0IweUEwckgraDBnT3VreUkvOERjRkM1VHUxOGRTNVNSSFJHdXUxYkVHWjRt?=
 =?utf-8?B?cVI0K1dma004aXFLR21aR2EzcXBTSGwzRENNZWUveUt5cjBFOE1ZdmtUeFpR?=
 =?utf-8?B?cVZjR210cEkwZGVKTzNkTCsrSktzdnlWaDNlV0tRTnMyREVoNW05OWFWMTFZ?=
 =?utf-8?B?N2svdmlTNm5ZVDRDSFlYZ0JJcmxnSzJiZzdGd095ZGtNaFV3YUZYUFpLVmRp?=
 =?utf-8?B?WHRvL24wMHFTU0NQaXp6aGN1RTdFVk9ha2Q3OTJGaUZGWkc4SGwzQU4rMjh4?=
 =?utf-8?B?SzhWcjhYc0ZXK2h1OHU0c2F5OXZHZWNsSnZYb2RKWnMrYXljZUlMWGg5TDhk?=
 =?utf-8?B?SURIeXBWdmFmRnFKVWdwUW9WQVh5T2tkbVRFRFRqTEZQUXBzOTBOcUxEc0Q3?=
 =?utf-8?B?OEg5ZG0wVEVqdjNZeGhkOWt4VzluRDRSNU90T1kwQUpMTXQ0ZnIzVjBNT0F3?=
 =?utf-8?B?K1BvMFV5TzNIS1ZIN0VabkE2UFRVd2JCWHFwcFh4OTlGczRXODJhRkxwRHc1?=
 =?utf-8?B?K0VUU1FBOUwzajlYVDdIQUU2alo5VFRrMFFSdmJoelBIeExVdWtRSlJPSnoy?=
 =?utf-8?B?VTQ2ZXBFZVhGblhNUzY2N3JIRFJsQnRvR2NEOUNRRWtwaERwMXp5YjdzSndX?=
 =?utf-8?B?VFg1eFJwTmZ5M3ZHM2ZkNnBsUW5PZFBVa3dXZ2VwVkFIS05mczdwY1Zyb2xa?=
 =?utf-8?B?T0xrdW5oSFB6SXhLUXQwcmRaTVU4TklVS0ZERDRQTE1Uay9iMDJrMTVxVkVK?=
 =?utf-8?B?VEZRQXJQSGN0dHBHWTNPMkU4Y2hTV0tEVURoaHN2VUtSby9xdDZjM1JGRC9y?=
 =?utf-8?B?aEJFU1l6QldtTWk2U3B1Rkt1bnFuLzVHNERjN0dQbisvSllSR2oxak9CZFpV?=
 =?utf-8?B?YWZsbTlpQlVZc1BHdU91REFVR1VPcUVmUGtYVEdLWGFOVTZsT1NHRjM1QjM3?=
 =?utf-8?B?Sk15THVaNDcrTVRnUzRicittTVpRbXdqUFgrRmgxTy9OU2pXRWc1a3p1Ri9q?=
 =?utf-8?B?THArNGFRSDJOcnVhOFcweFV3TnluUUtXRzJkVCsraEJLNVlDSVhhRVo0TEsv?=
 =?utf-8?B?QlVXc3RGZG9NYW5oMnNWR2RQS29HZTR0RGQ2bUhYS01oMnBvK2QwQVpQSFBw?=
 =?utf-8?Q?2zgw=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(34020700016)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 08:25:49.1223
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df25480d-ce9a-49c5-24dd-08de1d0e1765
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7266

On 06/11/25 12:53, Herbert Xu wrote:
> On Fri, Oct 31, 2025 at 08:11:34PM +0530, T Pratham wrote:
>>
>> Let me know if this is fine.
> 
> Yes I think this should work.
> 
>> However, I suppose we similarly cannot do allocations in AEADs as well?
>> If that is the case, my current code relies a lot on it (using sg_split
>> to separate AAD from {plain, cipher}text and applying padding like CTR
>> here, both of which allocate memory).
>>
>> I can change padding to avoid kmallocs like CTR easily. But separating
>> AAD and plaintext/ciphertext without using sg_split will be a task. Let
>> me know if this is correct, so that I'll split the series and send
>> ciphers now, and AEADs later.
> 
> OK it's not totally forbidden to allocate memory.  However, you
> should only use GFP_ATOMIC to avoid dead-lock (GFP_KERNEL can
> trigger writes to storage, which can in turn call crypto), and
> provide a fallback path to software crypto when the allocation
> fails.
> 
> Cheers,

Understood. Thanks for the insights. I'll re-spin the series with
necessary changes.

-- 
Regards
T Pratham <t-pratham@ti.com>
