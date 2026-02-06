Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010041.outbound.protection.outlook.com [40.93.198.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D07A330656;
	Fri,  6 Feb 2026 11:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770377846; cv=fail; b=l+GE4Q0YVPwaLD/S8vTHsKBB9bWUb5geYPZg31oQ75PIH6AaQV8I7axIPnNO7oXKuuuQzBfvhjB7evpY21hVdYD8aO/bIhVm+LSRjZChmzgGAUPjUlf+cmECdTMY63rDtaDpWvRlaaHTSNVmuidZYTw34eyjBV1//UvNvCy1XiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770377846; c=relaxed/simple;
	bh=rQ8XFFTTGtw+O3YzyKUQp+qR0Pkz5ydroYKPuGsBjMI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=fAHtdHHDDyBVVH2QQmaxvWY1NohLN9nv5tvc9xau7PzCd9nptu6odWWU+tyAAFHtRiY/LApaTw0Nax+tvzcPGyNTbYzcAJtP3QfTl8le5/QiLHs8Xf8UZhBx3H+pbaUCEQw5WewzGdhfErRyHCMAypXxCwMIaWtnIq7qhJqyPH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=WKs/avN8; arc=fail smtp.client-ip=40.93.198.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="WKs/avN8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RBH7/PPyWxnp8db9tFGZUrF5dzK8A1i4vhcVgXHP7bCS82BonFJC6rgLBKDyLWI1mBw0K0+e2zoFBs6G9+E0rQK2/5i6cjHYKNiy9KioFoK3NkjRsbk3qvq4Krg7LKqObqGr6jzeP9LlZoX7TykU7v/NKKezE98dzWlbXrCYpMBCQfvxoJteSGok15Txc69upA8+S+pts6haOaQQYPvClsgSbx37YMlnAZO+s2Tq14Ys4GC0ejjRCipLIq2KgN976pfsedpgKnqjye/zeyIbD9hHXbgxocMcJjJarYJtRPyFLxD/+XgOGnlcgqkrOKQP9MrEDbGdXhbIMFJhOOotQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e8NzLziOp2dIgeNkBWxMzwUvtxHPH6p15qG3A1W3gDc=;
 b=GdOUuJ2B+CktTidnfo49qoExeAQE1dPbvFIEdNSJwPppuupmX91XPXGyMqCxPntUHxC9zZqQ+iy2Hjga8MkjHQKZnq0D5kAITVyiEb/xvDyErmPraEHswN9FWJ85/vZLZOj5XYMqND1iie/upYQC1sDUE2dkfEmC4gx+yx1Xg8KgqxrjoSUFLp0VpCjSkg5wZTsOBBmcFHD9/YDXxyao7DhKSCAnTTdte7cj7+dMdvwIcYVD/En+DomHbfs+pVvK1hyipaR8talYGUbcmdOtEFLwRPtzpp8tC+fcbVIQY5u2Czm1KMCGhe5OvVTZFrW9XT/wChOI1vv+kI31bvEPFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e8NzLziOp2dIgeNkBWxMzwUvtxHPH6p15qG3A1W3gDc=;
 b=WKs/avN8cGO5u2eu6a3ogDy3aizGhGUMyoCphidmiHbwJ1Ri3Ma8gFeQxKyynnQQzVDAXtRki6mZjIt3NaNFv9I+qZk3RWhWqm6+pKRuRaYawc56VUw0uBmgxAXwrW6RFR9/0OeQJfzgCYimeayh8BaujFgu8XD4IKNVm+2gz+I=
Received: from BL0PR1501CA0011.namprd15.prod.outlook.com
 (2603:10b6:207:17::24) by IA0PR10MB7349.namprd10.prod.outlook.com
 (2603:10b6:208:40d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 11:37:23 +0000
Received: from BL02EPF0001A108.namprd05.prod.outlook.com
 (2603:10b6:207:17:cafe::dd) by BL0PR1501CA0011.outlook.office365.com
 (2603:10b6:207:17::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.15 via Frontend Transport; Fri,
 6 Feb 2026 11:37:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BL02EPF0001A108.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 11:37:21 +0000
Received: from DFLE207.ent.ti.com (10.64.6.65) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 6 Feb
 2026 05:37:17 -0600
Received: from DFLE215.ent.ti.com (10.64.6.73) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 6 Feb
 2026 05:37:17 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 6 Feb 2026 05:37:17 -0600
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 616BbEde727161;
	Fri, 6 Feb 2026 05:37:14 -0600
Message-ID: <b3b9f41a-adc3-408f-9fc9-69618c4aa2ba@ti.com>
Date: Fri, 6 Feb 2026 17:07:13 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/3] crypto: ti - Add support for AES-CTR in DTHEv2
 driver
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, Manorit Chawdhry
	<m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>, Shiva Tripathi
	<s-tripathi1@ti.com>, Kavitha Malarvizhi <k-malarvizhi@ti.com>, "Vishal
 Mahaveer" <vishalm@ti.com>, Praneeth Bajjuri <praneeth@ti.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20260120144408.606911-1-t-pratham@ti.com>
 <20260120144408.606911-2-t-pratham@ti.com>
 <aYWsJAmf05EdotTX@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <aYWsJAmf05EdotTX@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A108:EE_|IA0PR10MB7349:EE_
X-MS-Office365-Filtering-Correlation-Id: 56d5bc13-b92b-4fe3-7947-08de65741765
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NFBwVk5jYnErNWplVmMvMDZneHJsMzlpNDJ4UVlnUXQxMDkrb3ZhNE16eTRz?=
 =?utf-8?B?MlE1T1V6SmtFeVlWeCtzbjMvclNrNmdoNkU5a3J5VUFidENOZWN4UmVOMklG?=
 =?utf-8?B?QjRZNzI0UTM0RG9RVFNmaVk0RjYvR2RRdHcxNGJ6bGV6dUQ0TTRyakcvNEg5?=
 =?utf-8?B?VVlnR09FSzc4TGJRbEoyYndvKzJQempKaGxzS0FzVHBwbGlSSkFwQVZWSkc0?=
 =?utf-8?B?QlJ2VGNXbTdrN2w5WlIxTGJaaDJmMnQzdHVaVWdjeENXblNCRE5iUWR5UVNq?=
 =?utf-8?B?VkJEdzJnd2hiaHpaakFXd0xlNTYzT1ZqUFNDOW5xSFpHZzdqY2NlV3dZMkVI?=
 =?utf-8?B?ZnpURi9NcWRXbERjbS9Db0x0RFBJWGhNU3EzaWQvTmxwTHlBMExoOERpU0RR?=
 =?utf-8?B?RFkxQnZ6WVpRUnZidFdyb3d1VmdVUjZhZmVRUWhCN3pLMW0rRXdhck5ad1Za?=
 =?utf-8?B?Zk51TEl5dGo5akdtdE1MYlVabjdCcTVITXNOVVZHWnFGVDlvUTRVZ3ByOGdH?=
 =?utf-8?B?QUQzMEtUVjIzd2d6V2tjRVJ3c01MdXZ4clZRTEEvVTF3MStZbldZZTI4dDF3?=
 =?utf-8?B?b3QxanBjZXd3Tko2enVWQllqRW1EUlZyS0hpUGxUQXc3NWVBYVd2dXZ3VGFM?=
 =?utf-8?B?clUrLzgwc3E0N0RmVEEybzdOYnIzSzBVVWprVE0xWldUdjVkTU16dXE5MmZK?=
 =?utf-8?B?Um9zRlJkWHNDRDE1cGxGNStESXVVcWRBTWRhTU9uTWtRbUhkUzVwRnNtRWtQ?=
 =?utf-8?B?WkRJUGVxYUZIaE5WbEVqSi9IdnJrR2k2ZlZYN3RraTJQM2lObjIyckdkN09P?=
 =?utf-8?B?OWhJVHN3cklHM2ZuenNRY0s4NllaNFVSRUEwRlk2YWxXM1F0OWFCdjBUYUxq?=
 =?utf-8?B?ZlgrM3h1VTcxMG5FeFF5OEhxdVBvM3ZXMHNheFRkSDdhNExyYnU3SDJCTytq?=
 =?utf-8?B?QSt6SGJ4VFFJMTdWOVBMTDFUcjc1am4yOTJGTzdkSUtSMkxPUkJtc2JtY1I3?=
 =?utf-8?B?TE1GUVdBVEtsT0k3MTBIeUw2OTQvbURBK20vT2luUVhDbkZ1TGZiMkxaMlg2?=
 =?utf-8?B?NGJDYnBXRnpSRUpZS0lJQkRuUndkVGpZcndsQmlDZm9CeXVSUU5FREdlMFo3?=
 =?utf-8?B?SUQwWU5VZTBJZ2NjNjZUdTBZTko5QnhGbjRZcHJKQ3J0cGFiMHp3WEVRbWU3?=
 =?utf-8?B?T0RuNCtLUW9zM2JQZ3FHYXdDbERVVlVWeWhYaTZiMk41Z2tiWkpkRVhXcUcy?=
 =?utf-8?B?cFRmT3ZGM3NLMXhmSkhheG9aSGxMYms4TjAyUHB0QXhZd1B3ZmJvaFp3L1Fr?=
 =?utf-8?B?aHUwdHNCRHJtaXAvVTV6WkJHUHhNb0JyUHNxTm5Vc1FlblpDZGQ5NUtQWVh5?=
 =?utf-8?B?Sjd5K0VIenpZbFYvZDV4TnpVYUFjdDVZRkdEWE0wZmhwK0JUdERiRGw5WVZt?=
 =?utf-8?B?NTNTUElLdm5sblhiUmRWaVBYakRZVktoZ0VuUWJuQyt2NFhvcDVCZUx2OEtW?=
 =?utf-8?B?WTFhRDB5cURGaWdmTkllSVNSb2E4S25TSFRJTVBJTDlDV0pGcDRjeFNQTzFP?=
 =?utf-8?B?NmdPaHFPUmtjR2ZWaDNreFV2Y2JJcTR2MGYxVHozeFlxRFN5TzZ4dnRXeHZK?=
 =?utf-8?B?RXViWWcyTEU4UjFhMyttQXppYm9ndDk5Z3RGZDJQMmpCa2pNM2VuK2R4aElW?=
 =?utf-8?B?V3pZdkFhUzQyQWlnbHFOK293SmFEaUlNaUhVWVp1dTRkMXZFcjZnei9UWHZx?=
 =?utf-8?B?VHdqcUV4ZXFYdWtLbUl4Y0hSSmRYMnJMOVpYaGVYTldDQm9CVDd6SVBIcmU3?=
 =?utf-8?B?U01XelFLVkZ1VDB6eXlBY0NONkZEY24xOWl0MDA1Mk1DQ0t3dUhxN1NxbEgv?=
 =?utf-8?B?VFFIN3oyazNmaG9ORVZ6VGRYNEdIRTQ0dTVncnRTMkRicGdTeU1xV3JvQXZL?=
 =?utf-8?B?UW1IbGtrMmJNQk1ZeU5EQU0rVXNXeGNSYjg0ZUpWUXdGQm13SHpwN3B4azB4?=
 =?utf-8?B?M0pyT1hUdHROeHZGai96MVQ5b2R4YzNza05pbWYzRENPM0VuTE1lUUMzOSsy?=
 =?utf-8?B?TnlwemUyVU1BYkFtaWhkdEMxMWNxc0Z2eHdZcDQwK1FEcVdOTkh6R1ZiamNK?=
 =?utf-8?B?MTdlb3A5ZU01RWJOZ3BOeEdFTjRnbnM2ZlpjT0h6QTlTaU5iSjhkbmFXOEUx?=
 =?utf-8?B?Yld1V09LU1ovaUN6c3ZCTnBhZlBod2Y5N2NKRmlhMVRyMm40eEZTdXlxSy9I?=
 =?utf-8?B?dmlWOWZXL3liNlRydyt5NVptRWhRPT0=?=
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	X2e+cMMOAGS7If/LQ1o25w7hLPpmcrjckgLyjqRtBBiRgVdHS1Ie+/1tZNKVDoaEN0hXHe0kBKTMKrAvd9zUVDfmP2UibrIlmYGiYCQYOE2BR4ZplvLYeiJ5HpNy1pZ0FFu6J759ll+KOS2D1uHURV80lZOlg3iHjDsHWPI7Ykh6+4KYm/VoYBik9F23VHEQ38SHIfRime6yU2O6GiQe/brYqiHKmDMmC2qA2FFE7elYS6hG1qfjZOKoZeb2qufCX6yTjSKb/AMQ5sxAIpYWjzOY7HE3O7X7VvDRyI1Et+az70GhBvEMHoGaWnBhRnmrDcf8FW5PaOym3hfS08M+6Okq8yJIf3Ld3rt9ZAsWNOucGVLgblWO827hkMFCB6QXSom4TLuY4a04tWnZBJLkBVTgVE76Ibscq2LoyJ7vMAV3NUd5PevekFR/409sQ0In
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 11:37:21.5101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56d5bc13-b92b-4fe3-7947-08de65741765
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A108.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7349

On 06/02/26 14:23, Herbert Xu wrote:
> On Tue, Jan 20, 2026 at 08:14:06PM +0530, T Pratham wrote:
>>
>> +	/*
>> +	 * CTR mode can operate on any input length, but the hardware
>> +	 * requires input length to be a multiple of the block size.
>> +	 * We need to handle the padding in the driver.
>> +	 */
>> +	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
>> +		struct scatterlist *sg;
>> +		int i = 0;
>> +		unsigned int curr_len = 0;
>> +
>> +		len -= req->cryptlen % AES_BLOCK_SIZE;
>> +		src_nents = sg_nents_for_len(req->src, len);
>> +		dst_nents = sg_nents_for_len(req->dst, len);
>> +
>> +		/*
>> +		 * Need to truncate the src and dst to len, else DMA complains.
>> +		 * Lengths restored at end
>> +		 */
>> +		for_each_sg(req->src, sg, src_nents - 1, i) {
>> +			curr_len += sg->length;
>> +		}
>> +		curr_len += sg->length;
>> +		src_bkup_len = sg->length;
>> +		sg->length -= curr_len % AES_BLOCK_SIZE;
> 
> Please don't modify the SG lists since they may be used elsewhere.
> There is no harm in mapping a bit more data than what you will
> end up using.

The DMA (at least UDMA in K3 SoCs) sends/receives all the mapped length.
If I have the dst sg mapped with length (len + x) but write len in
crypto hardware, the DMA gets stuck waiting for hardware to send the
extra x len. Similar issue in reverse as well.

Also, FWIW, I'm restoring the len in SG list correctly at the end.

> 
> Just truncate the length written to the hardware instead.
> 
> Thanks,


-- 
Regards
T Pratham <t-pratham@ti.com>
