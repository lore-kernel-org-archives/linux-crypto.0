Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010016.outbound.protection.outlook.com [52.101.56.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43B1338599;
	Fri, 31 Oct 2025 14:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761921706; cv=fail; b=p0NHgcjh5sbuupERg0sjESDzNgO2/QYZvXrqcHRI+SyUijbmS55PYupHUUC3PJ3hRE/kTqkkmhFpqD1ObYLFuFkSXwhSrAnCSnZFouH6s13Ew/mFWWVwa7/G/7zuAEalwbSE99LwRR53S8vX68dKNcfHXFgA82nm4P3LRqLkm6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761921706; c=relaxed/simple;
	bh=bC6kqbhX/tNNoMmKpRT47WkQ2bDtm0R5iLvNeVeEMSs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ksFysze/VZzD3HrtoywGChnA/WgAENfA+7My3S8PIZXw3PRlleu5svZjEP3vcTIc73r/TEe0rUtc2cJR3vtX+cGFhb1mLldvNzZulB+AUxNK73TSSLWgX0mJDAjRkJnkZ1/Ljz/RM74Poec7oQUqAj0pwWWa6oxZkB+myHMg2uc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=AfRa71Le; arc=fail smtp.client-ip=52.101.56.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="AfRa71Le"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hvu5kGIPmR6rFKDz690N+eg6Tev2JUrenwxNk6phnCq38wXvNIR8GAYMykCv5P5rnuNM5f/hR0xisvs3+GJq/axTYc7/uTWE2HQhTRMr0rN03Lz/QXtP+EWCt0P376ylnWevhbyoxmbkjF7lVoqK0VNHQoGtRkljmmrUsB/dE9dzxUb8ss4VPXm1mjrIutdZvZgZmiXHTOwtKVUq0pc7RCQKw11d230Orjpd/dKeECZW894WWbu6KGqGFxdW/j9sZjbX/d7w7NH5NmBGkKJa4VafpQ6/klXg3obb9+hp01q+/Y0winCbGwLAeSk/ZZJZ9fsDyE50itIrvhdncgloTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7tNS4baMkGKSze/CAhA3s9qBc8zfR6FPR68feQL91Tw=;
 b=meA6KcdkSUxUr/9ddr9CqrThNQZaHsW5IckcdITneKpLgHCo26bjbb3x7PFAH3VXG9vfG53RzbhRmH5cqMZH2a+8I6ByG/BrnX1NCprvPm0zlpB4yAXfFdn8PG+fE0N5UM0dU8cAPSho40SvSCGCzNX6OqljhfAz4skv4DoAZ2kjMSQqCeamUy2V1Bar4mH9X+Ek57AqEWNmj1EHCQFpP8sExcshGfroNlGnsd1TjFH+fTJ6wSWghXr8UVQPlxaktunc9/A4sbbfckR+WlOm3BYUmbYjZt2pRBTyLTPayiVHx9I5vxaWjSbo7rO08A65dDW0d3w7f6oyR3qfTC5QfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tNS4baMkGKSze/CAhA3s9qBc8zfR6FPR68feQL91Tw=;
 b=AfRa71LeIFaLBn9yfGO5MWf6rgcnq9ioRwAZmr4GXNAkPNEeXYcldWoVT1Qa2QXXKWnFxFQyesK1HLJfK7osyuV2fiOCfW0jtUGptxcUSJyVP6WjB01FVfFT/Fzk1bQjR3WAG4yWkI0Wbe51WcDldCfig64sGAAL/lKS4+lViAs=
Received: from BL1PR13CA0024.namprd13.prod.outlook.com (2603:10b6:208:256::29)
 by DS7PR10MB7155.namprd10.prod.outlook.com (2603:10b6:8:e0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Fri, 31 Oct
 2025 14:41:41 +0000
Received: from BL02EPF00021F6C.namprd02.prod.outlook.com
 (2603:10b6:208:256:cafe::f6) by BL1PR13CA0024.outlook.office365.com
 (2603:10b6:208:256::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.5 via Frontend Transport; Fri,
 31 Oct 2025 14:41:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BL02EPF00021F6C.mail.protection.outlook.com (10.167.249.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Fri, 31 Oct 2025 14:41:41 +0000
Received: from DLEE212.ent.ti.com (157.170.170.114) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 31 Oct
 2025 09:41:38 -0500
Received: from DLEE214.ent.ti.com (157.170.170.117) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 31 Oct
 2025 09:41:37 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE214.ent.ti.com
 (157.170.170.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 31 Oct 2025 09:41:37 -0500
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 59VEfYPr4063662;
	Fri, 31 Oct 2025 09:41:35 -0500
Message-ID: <f4c339e3-0964-469e-9cec-eeaf2e2f078b@ti.com>
Date: Fri, 31 Oct 2025 20:11:34 +0530
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
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aQSDLpD2LXlqILku@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6C:EE_|DS7PR10MB7155:EE_
X-MS-Office365-Filtering-Correlation-Id: d4491dd4-bd15-44b1-7f0e-08de188b9b1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|34020700016|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dS9jRG5JcE5rbTFRM1pyeFNGczVaMnhxaUdZZlptN0E5bXh2OEJqbEIyR0Ry?=
 =?utf-8?B?aEVQNXFWUnNTaHhDb0tPK2FkMGpJZDVWb0I1VmdRQWNEY1Nick8zVXFRVkRh?=
 =?utf-8?B?ejE2ZEhGYVpYampVQkVabUNCZlVQYXJPVjBqWTVWbk1XeFpsL3R0Skt1SkFl?=
 =?utf-8?B?MHpXYjVvMklsS1dPRWJ1NlpzTlkxQ29GQjN3eDdRc1dEVHFRVGljWEpoV1ly?=
 =?utf-8?B?a0tCSU85Y0lMQ29DZkVYdktuQ0o1MkpiL2lwRTNONjVnbnJGRnNLbjlxVU1X?=
 =?utf-8?B?YlRxN04wUnU4Vk9uZVJIS2w4c01mSlJGQVhhakpOSWtxVGI4TWVQQ0I2UzR5?=
 =?utf-8?B?TVgxVHBPRWJzWW00aWh6a1pHUWgwWG9yV0FsYWozZEVkdGhPWThnaGpMZGFp?=
 =?utf-8?B?Yjlkd2ZmQXEvbE5VRk8xNStlK0s1K0ZxbkxWeXhkekFSYWdTOERvLzdZZGFS?=
 =?utf-8?B?c2JqQUZZZjU3WUdtdm15Zzc0eDlEVGJ2SklRZk9xYS9xRlkvTHBtdzV4Q01Z?=
 =?utf-8?B?Tkx4Y3A0WWxVRmh6bE9oVVhaUnpSckRuQkJ4WFNjUzFFanJJdS82bTZCbytt?=
 =?utf-8?B?eTNVNk92S1haWGFIa2dESmVGcjlQSjhUbGpLM0lVdUU2QzNwSGh3WDk0MHc5?=
 =?utf-8?B?OVZJWWJwR2pWS20rWEdoZXExT0ZjaTlxZXFQRHV5U2RLMjhZTW1UMUJHTWxP?=
 =?utf-8?B?bUFJUktiNi9rbktqUWh6d3I4V25Oa1ZoaHFsdGVtUis2WmdCT0ErUzNzYUNB?=
 =?utf-8?B?dXZmUTB4WkVReUlseWdBMlhGN0gyUll5d1dPSWJzNVBLelhmc3RJWWpPbUxn?=
 =?utf-8?B?Z2FpOUhkQVhFaUlzRno5bFRYZTlUUkhHenZXR1Q4bHdyUGg4aWsrcmhNUVhK?=
 =?utf-8?B?ZWRrSXVxK21qN1pla2ttWVE5MkF4SkpQZnRZYWJsUlFubW9jMDNFYy91QWVo?=
 =?utf-8?B?SE51Z01tcWVVcURGa2YvR1lyRWpxeHdZcUYyTHo4dnBMc2p3bkp0WGw4Q1R4?=
 =?utf-8?B?M2t2YmVIajJ0MEtUQ0VnU0NsMXVPS1N0eVQzb2NyRmpUeWFpS3J5UG9rQjhQ?=
 =?utf-8?B?cUJGNTdvQlU5NW9SZDkzektOcXA3dGM4RitabzhybkpvZ2ZpSHN5d2tvVFRG?=
 =?utf-8?B?cEovTFkrVGNpZkRrRkJXUmVSQXg2c0hQS3Q2N1lNU2J3b1ZoQ3JMRXRJcjNo?=
 =?utf-8?B?WHlNZnpaa0FPRGtQdkY5emt5ejd0NnUyQy9XRFM0YnJlYk85b2pmbUlpTmQx?=
 =?utf-8?B?eFJMR1ZsMHJDa3RhcHUra25kblRoOVcwQUFRUHhzN2dLQTRmQVIrNVFwUUZy?=
 =?utf-8?B?TG5pWFNEQ21vZ2J4RDMxSFlrd1FaSG1LOTFFUmpHVGQ5UHNBeGl3RWxGdnJy?=
 =?utf-8?B?cEZGUERjdS9IYmtwVUZHNzFJSW1RV0xrNUdiRzdkQm1sNno4d1JWbFgrcUdY?=
 =?utf-8?B?MEJUbWp1NVprSDJkb3luajA1ZTdndENla0cramRaa1RyZktxcHM4azNMbDh3?=
 =?utf-8?B?Z2VyekEzZDBKeGNpTnpGNXNpWklwY2E5dVp0Nk1Ta1RtUEFQaCt0UDhzSXp3?=
 =?utf-8?B?empCTlBwU1JNMWJ5a0VTdktDd2F6RGhXckpiR1NnYnY1UzRveU05elplWXVH?=
 =?utf-8?B?dGRoNkpPbXBaVE14azhvOGhJa3BJK0VxWExQZ2U0dVRLUzA5bm9UOHFaVWpw?=
 =?utf-8?B?djQzc0pKMnNsSit0bTBva0crU2dFZVp4TnJmVW5ZeEl6T25BU3A1UElxYjBh?=
 =?utf-8?B?MFcwNmUrYlcrbG1MelMzalVCdS9pUTNxS3JzYjlHVWlSWkUrOHBnSGlXRW43?=
 =?utf-8?B?YVZLdTVBMkJQM3Bsd3pxNnNEQ3krVEFCaWxBaFNGb1FCWjB4K0xuR0VaWXFj?=
 =?utf-8?B?cWlpWVlMc0VMMG5wSEFRRDJ1M1JXREtXVWpLMzdjem9xN1hUcjN5WWpEQld6?=
 =?utf-8?B?ejdiMnk5aTJ1bCtTbG93NTFDRGRUUVI4VTZLU3czc0YyVGdFN1ZLaGM1NjIw?=
 =?utf-8?B?Nk9Xb1NURlpoazFGWDdvZFhrSGFZVUc3TnJ2dWRnc3JVVy9YbG5JZHFLbkly?=
 =?utf-8?B?RlZJV1RoOEFIQk4xeTViQ1FTTVBoTHFtS1Z1a1M3TjZkbTd5YlNzY1BCNFpq?=
 =?utf-8?Q?O/Y0=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(34020700016)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 14:41:41.3877
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4491dd4-bd15-44b1-7f0e-08de188b9b1c
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7155

Hi Herbert,
Thanks for review.
On 31/10/25 15:06, Herbert Xu wrote:
> On Wed, Oct 22, 2025 at 11:15:40PM +0530, T Pratham wrote:
>>
>> +	if (ctx->aes_mode == DTHE_AES_CTR) {
>> +		/*
>> +		 * CTR mode can operate on any input length, but the hardware
>> +		 * requires input length to be a multiple of the block size.
>> +		 * We need to handle the padding in the driver.
>> +		 */
>> +		if (req->cryptlen % AES_BLOCK_SIZE) {
>> +			/* Need to create a new SG list with padding */
>> +			pad_len = ALIGN(req->cryptlen, AES_BLOCK_SIZE) - req->cryptlen;
>> +			struct scatterlist *sg;
>> +
>> +			src = kmalloc_array((src_nents + 1), sizeof(*src), GFP_KERNEL);
> 
> You can't allocate memory on the data path.  The request might have
> been issued by the storage layer and doing a GFP_KERNEL allocation
> here risks dead-lock.
> 
> Failing the allocation is also not good.
> 
> Ideally you should make the hardware deal with the multiple of block
> size data, and then handle the trailer in your driver.
> 
> But if it's too hard just send the whole thing to the fallback.
> 

Understood.
Ideally, I'd like to avoid fallback as much as possible. While it does
sound lucrative to handle the trailer in s/w and let h/w handle blocks,
I have another proposal to avoid memory allocations here: using
scatterlist chaining.

Padding:

struct scatterlist src_pad[2];
struct scatterlist *sg;

sg_init_table(src_pad, 2);
sg = sg_last(req->src, src_nents);
sg_set_page(&src_pad[0], sg_page(sg), sg->length, sg->offset);
sg_unmark_end(&src_pad[0]);
sg_set_buf(&src_pad[1], pad_buf, pad_len);

if (src_nents == 1)
	src = src_pad;
else
	sg_chain(sg, 1, src_pad);

src_nents++;


Cleanup (restoring original req->src's last nent):

if (src_nents > 2) {
	struct scatterlist *sg;
	unsigned int i;

	for (i = 0, sg = req->src; i < src_nents - 3; ++i)
		sg = sg_next(sg);
	sg++;
	sg->page_link &= ~SG_CHAIN;
	sg_set_page(sg, sg_page(&src_pad[0]),
		    src_pad[0].length, src_pad[0].offset);
	sg_mark_end(sg);
}


Let me know if this is fine.

However, I suppose we similarly cannot do allocations in AEADs as well?
If that is the case, my current code relies a lot on it (using sg_split
to separate AAD from {plain, cipher}text and applying padding like CTR
here, both of which allocate memory).

I can change padding to avoid kmallocs like CTR easily. But separating
AAD and plaintext/ciphertext without using sg_split will be a task. Let
me know if this is correct, so that I'll split the series and send
ciphers now, and AEADs later.

-- 
Regards
T Pratham <t-pratham@ti.com>
