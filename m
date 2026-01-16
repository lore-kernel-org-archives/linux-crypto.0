Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013018.outbound.protection.outlook.com [40.107.201.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B418C28371;
	Fri, 16 Jan 2026 08:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768552413; cv=fail; b=OOpE7MtfzgLvbZWDfZeD2CtzZ0lGkaoR0mdYfhhPIdU2pou6I7LfAIRdQ7vB63zjkpjP8UBHkQ9S0dNH0RC55SeJASAWvneyyf8BqOiotttbOxTVZde8xstiPy3hySg5otIqK827xPdPUgKIeN9aGaXtfh4UBD/qaQUGTgcaEOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768552413; c=relaxed/simple;
	bh=qXGjIe6qUCw1iIEXoBWNjET+PwpYMnDWO/J/AA3GrDA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FNMTlywzKwVw+PEOIQkGU4TyUXuiWrhCiaI4mqWuYaAMZQIJkITESGqjFtrvgt6dmRa/2mB837Vtyrb74BkDw+zYGaev+GzDNUaq++0FPlo1MR6RWe4vFYDqbcQoF7EbMjjKQXbP5/Yen7eJoq0BX/MQEeqnnkGEpWbLK4cx8r8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=aq8tUJK6; arc=fail smtp.client-ip=40.107.201.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="aq8tUJK6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=diT7t/EBQsWAUPD/97fB4f2o+zacMw8lZIw8t1fsLREFstwY2Qs/QEaVN97zsI3EBoI5NWpnEzOs3QenrbrlWjq698ekOTwHv7SnOBCvCgFYodHNdw9blVaas3pFYrIn7PrB0humU5nIWhn+KVYigIaFBQa4n6Q7UMwDtg9B0aWotzMUwJuiqhZZNGNgHLQnzs/7TY8lhNiiHSvS+dBtO60uk5losDurrWSPvK2eRAikDzrNrIMJQ2+NCqP4bgEiO99v6FiiWULZ5cpMQgXjl2ciJcDA2Z1Vp2XrCvaJS9BxS0cEFTeVJrUT5+56RfIQKsc7DoUCv7tFbvDwuxFn6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KrYZbK030oRb+RlambYP0hy6gGBr++L8ybSoFD/g5Ag=;
 b=ELxWGW84Qj8IOy1CRTwxv4mLqnrQ48Ej98baYj1mygua/Gr7SnoBQPZnXI5UVzDc9WnQcKHaXYwHhWwavaps77PkvJ/3rpUsc7Br1DA3cozv4gpGbam5nG8cxn1pVdkrHMSIBDyOQnPqsAUGXpONCXE03p8z5N7mY6AlEP7NZqYgn22cjs7yT/6DF6vt8dfiY68paRLszF/lynvf/6SjuwDZN7bNHDxdcJSMIcVQ2JDmKWoasv8eDsJPEYBgRwbXhZ7P9k+KszDsw6OlAfGwUIeDaZqZBv0TfZ07i1NM9Yb+tDTU6aH6TvtKTuCB6MWoB00CQmjKUpJu0iwbhc+k5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KrYZbK030oRb+RlambYP0hy6gGBr++L8ybSoFD/g5Ag=;
 b=aq8tUJK61J8NR4O4ziJxYZwYaZReg+q2sBsaa7hf4eTjXH+lB+4cBnR1ICMGKWjBVZjCdUq8jUIJ9hU7sqbv/eyulyK93NtmnYG+rfqBUZF7uVmeKzvPtVTIIWmTqKOZ2phraDhBFKAZGc+/FKFuG4PEKBwhMIgo9ZAKe69/8M8=
Received: from BY3PR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:39b::26)
 by SA2PR10MB4779.namprd10.prod.outlook.com (2603:10b6:806:11f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Fri, 16 Jan
 2026 08:33:29 +0000
Received: from SJ1PEPF000023D1.namprd02.prod.outlook.com
 (2603:10b6:a03:39b:cafe::6c) by BY3PR05CA0051.outlook.office365.com
 (2603:10b6:a03:39b::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.2 via Frontend Transport; Fri,
 16 Jan 2026 08:33:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 SJ1PEPF000023D1.mail.protection.outlook.com (10.167.244.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Fri, 16 Jan 2026 08:33:28 +0000
Received: from DLEE200.ent.ti.com (157.170.170.75) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 16 Jan
 2026 02:33:22 -0600
Received: from DLEE200.ent.ti.com (157.170.170.75) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 16 Jan
 2026 02:33:22 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 16 Jan 2026 02:33:22 -0600
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 60G8XJuZ2855179;
	Fri, 16 Jan 2026 02:33:20 -0600
Message-ID: <f9890350-cbe2-4cff-b5f2-1c76cd42ab4b@ti.com>
Date: Fri, 16 Jan 2026 14:03:19 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] crypto: tcrypt - data corruption in ahash tests with
 CRYPTO_AHASH_ALG_BLOCK_ONLY
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>, "Shiva
 Tripathi" <s-tripathi1@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>
References: <70710115-6bde-465b-91f2-a005bede1602@ti.com>
 <aWmisYTEC07wOO2i@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aWmisYTEC07wOO2i@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D1:EE_|SA2PR10MB4779:EE_
X-MS-Office365-Filtering-Correlation-Id: fcf0e1ec-0b11-4d47-a915-08de54d9ecc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|34020700016|36860700013|376014|7142099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TDZBTDNKbXNWU0tSdW80SUVvbHhMWCtCalNPMmtNbm5SdjB2YmpxM0MxS3NQ?=
 =?utf-8?B?UGRDTzZONFZGYU1UMFVKd2lmZ1pFNWF4ZHgxZDdyL1hUcnNRUjQ4ZXZmQVZm?=
 =?utf-8?B?RXF1VjdaUkZianBZQUN3aVdadFVjR096Q3cwaHhnSmtDVmxoaU02cDhuU0pW?=
 =?utf-8?B?WWhRUnBKRS9QeGFXWlNDaTRncHFyVUU4ZlJOK0FFbGpVc2FpL2k0T1gyZy9T?=
 =?utf-8?B?aVpERHZRQ3FVT01WcjM4OWtCZHZKSXNuNnhkK3d2QUphdnhaTU10Y1VjNzFi?=
 =?utf-8?B?ZGE5UlBFeldRd29rd2w2bGVSSlpQUnVBMEMvSUxZNHdYN2tRbElZWWNjV21a?=
 =?utf-8?B?WFlDZHNsYVZrYm1YZHVzVDBPS1J6L3NqWjRaMzE2VWZjZ1BSanVYbTkzaFEr?=
 =?utf-8?B?djBxbDcwWTRLN3h2Smd5NWpGalRMaHJrRUIrMXBZNVlkaXJGRkVZQ3dnSHZY?=
 =?utf-8?B?K1dMQmxSSmNKZjZvaElPbU9mTWJlRnAvMUZyRlVtV0NzcjBXZTdvYjVTSERS?=
 =?utf-8?B?RDRTWkdnSEFzekN5WE1OTWpGaCtILzN1d3R4M01VazNjbm9veUJKd3ZRaXJH?=
 =?utf-8?B?WWN1T21wMGNSclFDNi9ydzJGZmhLdXFQSzEzeTZrbk9LaEg5MzcrOEJ4T0wr?=
 =?utf-8?B?dnJPQ0pveURqUjhiMjl4RHlsZHJxMURFbVVXZW1aTU51VWFiODBDbUJDRzYx?=
 =?utf-8?B?a25TUkkxaTIrdjVIaWlkY0RKY29YdkVIQWRJUjJPZmRJRzgyRStidGRUUCtG?=
 =?utf-8?B?NERlOW9WREZlTHlzcHQ2NTNhWGs1K09zOE5Qc3NLY0pCWHg2Y3lFYmVEQmNi?=
 =?utf-8?B?V3F3MFhSMHR6TVU3cDlYYzB5VFFmZkxIMnBUdXUwTWxsS0JqNVBvS09PNUsy?=
 =?utf-8?B?VjZ4bHlZRThvbXR1SmlGalpvenBhc2hiZDFwTmphT2ZrZTk5RWY3TUZRc3hs?=
 =?utf-8?B?ZUxFVGtUL20vbUZQRzI0VzkzK3hpQy9ZbFljUXhUdit1UmFPb3p0SGZ0RVZy?=
 =?utf-8?B?czk3SlNPbVZtcmlNdXRIc0UxT3VhT2Q2SHJVTUlJNzBidDV1ZFJWL2l4UGFt?=
 =?utf-8?B?N1VBcHViZjZmcWxTOXNPQ2phSXB1OGJZSkdpaDBVWUVOYTJtK3dxM0duVG5U?=
 =?utf-8?B?a2c4SFlJUjgyZElVeG81ekMxTWVjSXVIUUFuamdpb0hFVkNJWGNxTFVSWmRU?=
 =?utf-8?B?RGVidFdGSGFKR0RqeVBadnFoZCtNbmxUdVU2RkRyY0Y0TWlEME1ZNGdjS2pF?=
 =?utf-8?B?OEhFbEFsazZKN21PajR0WmVscVpxNGJPWEJ3U01ZSkpqd2NsQThTRGFEZWFJ?=
 =?utf-8?B?VmttRnM0UHFlN2lrS3lhcGY0c0tOT1RhNGZnd2NtV3dZZ0NSUlpJZVdxN0JF?=
 =?utf-8?B?WUNkbCtwTUpENVJid3YydVRjcndKODlMVU5TZE5iQ0s3ZUFvN3cxakZDK3hM?=
 =?utf-8?B?c3ZqZkFGZ3NIUTIyMmp0Mk1iNXRaQVpCMEF0SURERStHTEhCNE5ubzNPRXpU?=
 =?utf-8?B?WlJXM2w1V3hYeVlvMDJFenZxVlVUUE16YitzUHpvMTVSMTJMaUhCWUJRdmhV?=
 =?utf-8?B?cW83ODkyMkx6YlpQREpiWTNibmtWajkrR0s4dWhxSTgrem9WVWtta0taZ2VM?=
 =?utf-8?B?S1RPcmw4OFZEN3RPckcxWXF6NllqcFFkK3U4L2pBME1SeS8xMUMvRjJERzkr?=
 =?utf-8?B?Y3dPNkppWUVSdk5RNVJTSUNBcWp3Z2kyeGNTb0JTYUcrWk5YdlZqajVMU0k4?=
 =?utf-8?B?aXhBRmgxSWZCbDdFdElEMXN1OUQrYy9qbUl5RVJrVytXelAybEI3THBGOGFx?=
 =?utf-8?B?UVoyVUQwV20waktGQ2QrNXV0SXBDaGd1djNtTUVnYmRSSmhQaVNWMmF4TC9G?=
 =?utf-8?B?QWhsYUR4cmtaZ0w1Mjhzc1ZMYlI2N1FHK21mVlpmNG0rUDI3Y0JIL0xqTEVl?=
 =?utf-8?B?UkdEd2d1ZEdVTlR5L1lFZXNGTEFiQTVaaVloYjk1eDNuNGV0SmVUREdsYXRQ?=
 =?utf-8?B?d2xzNHVYNDFZcXRMTkJyeC9tc1BEbmRWcTZKRVZKQiswSzBsdlpjdHNNRHFw?=
 =?utf-8?B?QUtjWjh4YWJwcnphb3o3cnJNc1Flb3VNR0ZSV29KU3MxMVh6VzdBcTlmSjEz?=
 =?utf-8?B?RVorZFQycFF6cTl0ZTlhSC9ob1dNTThadUJHcHhySFdXZTRoaWcyQ1J3akhl?=
 =?utf-8?Q?PLWSdNHJ3Lcqi/U8flNxq3SNXl6ingP9bLrkf0o9r4dy?=
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(34020700016)(36860700013)(376014)(7142099003);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 08:33:28.9086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf0e1ec-0b11-4d47-a915-08de54d9ecc9
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779

On 16/01/26 08:00, Herbert Xu wrote:
> On Thu, Jan 15, 2026 at 03:38:50PM +0530, T Pratham wrote:
>>
>> However, in tcrypt, the wait struct is accessed as below:
>>
>> crypto/tcrypt.c:
>> static inline int do_one_ahash_op(struct ahash_request *req, int ret)
>> {
>> 	struct crypto_wait *wait = req->base.data;
> 
> This is just broken.  Even before the partial hash block handling
> there are code paths where req->base.data will be modified prior
> to final return.  That's why the completion function takes a void *
> instead of just passing the request back.

Yeah, I realized this a couple of hours after hitting the send button.
Only that partial block handling is the first place where I hit this.

> 
> So we should fix tcrypt to not do this crazy thing.

Yup, looking forward for this.

> 
> Thanks,

-- 
Regards
T Pratham <t-pratham@ti.com>
