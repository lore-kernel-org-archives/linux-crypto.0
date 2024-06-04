Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2059.outbound.protection.outlook.com [40.107.102.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E4314B95F;
	Tue,  4 Jun 2024 21:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717537017; cv=fail; b=P4m1HowZ5tMrD7dfw5rqmAFjBclgyzy7AMU1a8TQaB4OjGtkkaK6QxaW7vd9lxpv158mlQCLPeqSgRF1oSrXgnl+TJv2ViCIshHtX9CQE2+3vRbDF4bTcX6s3GOtflTCiFAK+WeVHteimKNDI/b7GGpgs9w+mKIvIhZ0RoLFO1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717537017; c=relaxed/simple;
	bh=pzagUsOfsMe7nXY2qy+H9ZNEIN7F6kwY/FvO2gt0gR0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IJL52SnXbK+QTFAFATCmIh+hHWbeKUszEYJKH7V39+MmaayIXXfjn74keOTuR89fXk5+cEubPWoH6493iaUvwGquK3OAahhLYVVyF/qMrjQXMWJpwzlGinxAaePtJVCGYVfyE8+2OtoOe0+5KOOUTELrChyLIbxaFK4+qM/ljWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xu/+hKng; arc=fail smtp.client-ip=40.107.102.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xu/+hKng"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3VOjwxZ8tr33ux6cu+uNlPiXfW9MqWdQK98r/UEFHvjN4lV06RulPWlsgq+pzpjvsCgSLLdbx+u5MOQr1CFDLeY7f8ff+wVW2Y1p+e9Ku4TsESF/KRlgMNXe3EDNgnAt82S3K5G2dX7kKHe1iYsv4wEMD4ZyNMv3svhWj/oScPSy3aQpZDbMKS0xWShGPANW0QcTqm/phiu69EWC0eTPueUJ3Y7ecMPX+DjDS9jmf5bhokAJBj2I93F59sW4nqryRlQ56giDGNjJkeaKe3z3dDwHl1PzdqLEq4yhE3/yk3yblI3vLZ+lFH6d3hTKmVteeUYZkz7DW0WRvsbrsdPxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9+/fc2V7uQQyTIERxgNjfWlwpgFYkP+MvSI2EWb22mI=;
 b=CO6UKiNnsqMp966F8GNlX3dOwd10LlotypNUDUv0RS7McUhtgM/MPvogR8bwagjEbUkijvwjY1+r7TvgHVVtxYOZAWcJZQNAG6TOCX91arXOBqUxJoS6yKnCeynxBE7iciP4dNNSmlPJXQB+cK3o0BH7LfOPDnX71v8yeeP0IolDU5kf8LKIAZV8zvEUERITzHChnZYK+oBQensXgnrpdhURRxod7n5m+woEjZL4wdqNXpz0etZPub6+v1lc/+Ewg0MeodQpRk+9d2YWjgz1HkloCgrNj5K0WrsT1b0Wb9Vd0Lljj2R4T5SU8n32PDsv4MV4wlNvzj7r97082ZxWuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+/fc2V7uQQyTIERxgNjfWlwpgFYkP+MvSI2EWb22mI=;
 b=xu/+hKngT4BPmFh9pfAVDcrs8aDcnEYcuymSBM+YEcrH1rTrEW0tknVSJ4cP62meoYIvJG+JpLgVGO4dC3O8/ph2YfdCN90x4McfviI2ZB3iZMhO+f/P45zs6HUJAmC7jrh+4DJ2Vt0MEKTW8P46QjPoFE5d67gcanbZIrcO59A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by MW3PR12MB4492.namprd12.prod.outlook.com (2603:10b6:303:57::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Tue, 4 Jun
 2024 21:36:51 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 21:36:51 +0000
Message-ID: <49ef4f0a-683b-ca2a-20a9-65820f8c5e37@amd.com>
Date: Tue, 4 Jun 2024 16:36:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] crypto: ccp - Fix null pointer dereference in
 __sev_snp_shutdown_locked
Content-Language: en-US
To: Kim Phillips <kim.phillips@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>
Cc: Mario Limonciello <mario.limonciello@amd.com>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Liam Merwick <liam.merwick@oracle.com>
References: <20240604174739.175288-1-kim.phillips@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240604174739.175288-1-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0133.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::35) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|MW3PR12MB4492:EE_
X-MS-Office365-Filtering-Correlation-Id: f0fdbf95-a7fc-4d55-f9d4-08dc84de7235
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXZRaDBFVEQ3Wm85NmtHNUJjZWJQZXVNMmlQZ2hOZWZIdy9idytpeVR5bTFF?=
 =?utf-8?B?RUhHY3ZxYnRwTWM2YitGZWp6NDVaajZ0WU5nMmdHWFkxRDIvR01ZN2hlZHc3?=
 =?utf-8?B?NmxIaWVkVjAwS0Vkd0pmMmYzVHpCdUo1ektuM2JVbVh3UVdQdmFMMTlDY290?=
 =?utf-8?B?S2RLakN2NmdWTFRzY0p3dTJnT3QzMkE3eWRnczdxS2xaTlpjK0Zhb0ZSY0ho?=
 =?utf-8?B?U08xY3VUcEdsVzZJaE1Nbk9RdG8yUTJZNElWQnIxeGtyRnlaNUhnNnU3Sms2?=
 =?utf-8?B?QWxLc3UxNlV1a3RQRmFPMm50ZnR5c1R0RGRlWGdYRnN1eWxpMnVudW5oY1V0?=
 =?utf-8?B?NXNsaU9nMHpndUdsbXdVRVhKdWJPZDQwUldiN2xCcWNwZGdROFpIMXJ0OWdE?=
 =?utf-8?B?djRzd0tqa25IN3pyWHlnN2pyQkhzNDFaTEc0Q3ZLdHI3czFjZjh2NnhRMTZR?=
 =?utf-8?B?eGw0OGtIcThQUmd1aFFXSHFXSTNhQUpSbWdKZUFORmNxWkRodm0wRk02Z21N?=
 =?utf-8?B?QS9BZXNUVHBrOWlmeGNwb0F4bG8xR25JRTVQQ1FCNlJGZGJSemJVeHhnUTQr?=
 =?utf-8?B?d2MrTHhwVjE2RWJaaHlVNFQzM1F0OTcveUZxSjZZOGRzc3YwQ1JlMTdDV0Q3?=
 =?utf-8?B?RlBKYit1Q0NsZ3VuRlBtdEtvQ056Vk1hbDhYczMrMXVnbXdtRkJULzhVeGRl?=
 =?utf-8?B?VTVuS0tNbDVHQTZZcEd4aWVnVjVyQThHV2ZiRnJDL2VMcnRrOG5OUHhTdWZw?=
 =?utf-8?B?bmhicW5aNXMzU0ViNzd4dmNhQU5jK2VYb2VKdFJiZU01VkFaUmN1QUd2Uk9k?=
 =?utf-8?B?aTQ5VXhQZnhVNFBHYzhOb3VWWHdnd2NXU0s3Zlh5ZFpncDkrNit0SXcxa3hW?=
 =?utf-8?B?TjE2bXRtUlAwck9hQkJobTAwajVhWE5INTNQWjVrSUNkTWh3amlJSldYRnd1?=
 =?utf-8?B?Mi9EaTdlZUVLZktrb1ZFd1hLUC9NUE1xeDV1dDF4YVdWZ0RKcmJuS3hzWXZC?=
 =?utf-8?B?alFyZ0I4bjNHMEcyVTFnN0ZDM1VHcjZTOEpKYXR0ZWdWRHo3bzdGMWJFWGJC?=
 =?utf-8?B?WjRUQUc0dDFVbjJ4MzlCWWYraFZaVHZCNlMxemNGUE9yTzgvaEx3eHVDSnFP?=
 =?utf-8?B?RUp5VW1Sa010SGhXQ1hWaWhmN3c0Z1VCYTdwV3M0UStZSWdWOWlVZGlsQVVS?=
 =?utf-8?B?Y0N5M3VINUhRWXZ0QnpPUTRmaG5vYVlBQ2pkVzhPc2JycjdUcDZoM0V4U3Rm?=
 =?utf-8?B?Y3lYbW94RnNKRkwyUVdjVjFWNGpTajEzUHZVYkNTcHdJckhBNHNtQk5PZnlU?=
 =?utf-8?B?M1RYS01rVFo2ZEVkTU1hOXY1aEg5RFNlZVY0c3lHMTZoNHNGb3lzbEh4c2c4?=
 =?utf-8?B?L1dlcUw4Tmp3dmhzWFcrTnhGeG10ZlBuWG9HZ0lyeUlLaVI3ZkM3R2R6Rm9S?=
 =?utf-8?B?L3l4c0p6b05DcktuR3Z3blhSSW9haG5STmtXbndJZWY2RHpFOHVMa2hjL0Uy?=
 =?utf-8?B?NitLVE9WNk50MHROS2EwMEN1WHhBNjIxWkZWSnlRdXhNOGdGbDMyOWVMWWhH?=
 =?utf-8?B?NzQwNVFESFJxbVhMWFlsUlRZQitLSjgyVE1iL2FMSGtvTHBCTlpIenhyeUwr?=
 =?utf-8?B?VUtiaFdWRjNaVXN1Nzhsd3ZjVTJZR1BvanlHM2gxY205MXR1NGNicVZpckVz?=
 =?utf-8?B?SnQwTnlhWFlqejZUWXpjaTQzK3A1YjRMeFl6MzJ4NVpWLy8velNScGNnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RmJlS1Y4amdkS1pJeFJIb1AzbFo4ZkV3WWwzNCtWb1FUOHYvL01OYS8rM0lP?=
 =?utf-8?B?ZExRMDVpTXZBdVRhV0pKWVNwOGhaSUV6OVRLcWVWTDZBL3A3V2gycC9nVmxi?=
 =?utf-8?B?cXdCcmZtaGRkcHZBQmRTR1QrazNkcGdIVzhEb0twa0xSL1UveFJBSzBtazVs?=
 =?utf-8?B?UURzTUJrZEhYL01QR0p5RmlnQVNOQi9NcDQ1V240TG4wOU13Um1uZjdVaGtv?=
 =?utf-8?B?M0Z6QkNrazl1c3REdEZtN2d0Y0s0dm5ISkk5eXdEb3QyMVZvYm9zMU4yeEYz?=
 =?utf-8?B?alpWMVMzbjYvdHRlMzdZTnluYXBIdWtQWGRUZnRFWG9mYTNzc2ZReTNnTkc0?=
 =?utf-8?B?R2QraENEK090cE51cVJHM2tvV21OdFkydEdoby9CUmNLQlVhVFpnMXZzcGVX?=
 =?utf-8?B?TGloTkVhNldPUklGYlFkWGhRWmpQUnlqYXhteHg5bk5wekRuODczekNUVzNS?=
 =?utf-8?B?N3RCUEo0NEJpcmFLZHIxRUxzYWVhdFpGK1NvcC80cHdQRXBhMTRZRHE5aWV2?=
 =?utf-8?B?eUxvTC9WeG11c3p3LzBrMThVL0Jka3lSaitHVncvM2NPU2l3ZDROYzJTRXRr?=
 =?utf-8?B?V0l2dmxvVmFBYVNDVGdQVTJtVyttOTZEQnlTaHJQVjZIbGJPUWwzQjIyL2c3?=
 =?utf-8?B?N3JXcE1adU5ra0RLcnRpc0NKTEc2YUcrSkp0T1hXcUdjbkpwZ3pBRG9zMGtP?=
 =?utf-8?B?Z3g2NUlwT1AySTYxbmxNYlZpSU5HQ0k3amhZM3hjbkRUczRNeTVNMndjTDNH?=
 =?utf-8?B?ZkhiRm9WRERldHVuVmQybzg1WkhaR1VQc20xdWhpTnB6WG9EV1Z0bWlBRFVG?=
 =?utf-8?B?b1JQREJVeGh1cFdTSFFsS0cydUFkamk5cXIxSnd5cFl0QWhYVHlzSUVnb2Zi?=
 =?utf-8?B?dU9HOCsra3ZRbWdKZDJJckVCalZMVWhUTnlUaXR6TkNXSWZrVWxiQkRyOUNL?=
 =?utf-8?B?ck1qNnN2SUJaUmRlYU5sL3pOSkUrRWp0U0ErbStEc0p2aDdMODgreHZ2SG8w?=
 =?utf-8?B?Q1ZJWmduRVNBM2NhRml6ZnJZSUswUWllclVMd2UzYmNSSDBOalNoMTNKMVZy?=
 =?utf-8?B?dURhUVF5bE12cGtsNmlaeFVKZjc3QmpCemlYRERGbXpBQkRFaTZEV2lBZUlr?=
 =?utf-8?B?blJDOHV5RVpUQWV1dk9KakpYenB0N205RXpTc0xyWWFDMGNDeTRDbkhoRnVs?=
 =?utf-8?B?UXhQVGZYaDUxQjh5NlFmWHFwaUZlQWh2TDBFcjNOQ0pFTFRXQnhtaEJXZVNp?=
 =?utf-8?B?QXQ0WElnODlSRlVDdWN0clFYL2ZCdy82aWdaSkJ6VjN5eFExWERQZlJ6SW9s?=
 =?utf-8?B?d0dyaWtDVk5DVW5QWGZMcVpGU2IrMk5IUUlCcTEzMnF0VkZwVThqSmZTdVdN?=
 =?utf-8?B?Z2t1M00zVXpxNnZiUXBmOURuQVpXaUttRW5FU3ZGalVRd2Z3eTdiR1NZV3h1?=
 =?utf-8?B?d1h2bUM2VmdEUEwvd3BpSXJTdk5IYWVvRFpjM3BoL2JlQzZFaEhwdjMzb2w4?=
 =?utf-8?B?aFVDZTlONmNOVGhwb2VpU1lOeDhyV210ZDNWUU1HWUxsN3ZZN0pLR2JGNlF6?=
 =?utf-8?B?Ykd2R0VkeWFlenUyL3dqK1BCY0lkTDYvZk1yaW5LWHYzcG1yQjB2Rno1a21s?=
 =?utf-8?B?TEE3dFlmVnRlNG9wNnZqUExId0FCcUNqQ1NYRjU4dkVMWXE0WElCNGlTQUJ5?=
 =?utf-8?B?QVlzSXZWSTlZWkxOTjBpTE9idjVHYS9BTC9wNnEveGQ5S1k2TmlrUzl0TzlY?=
 =?utf-8?B?cXJVajJIZmgxRXNOWnE5SW9RaDBIb0pYZjRoUjFTQlNQVlBYVW9sdGRObUV4?=
 =?utf-8?B?bGRMRHVtOEw3a2xqOFNoS01XcW85MUVBaFpYVEFNMEs3aWdDbCtnbHQwYlJL?=
 =?utf-8?B?YXAzVXArMUxEdHNTTlNwTTR4K2hrZ3RLRjFhZ1B5cEdvdGpJcFFwY2V5endp?=
 =?utf-8?B?Zy9EdGxGTUhKMThEbVArR2FxVk4vazhCZ2xLSnErNkFHWFZ3OFpDY3ZNa2U5?=
 =?utf-8?B?Rk94NkU3NkxwMmQ3VXdQRnFpcjA0U2E2KzQwbWxhSGRJdFBNOXZVZkZ5Y2NU?=
 =?utf-8?B?Q3FOVlhrSVpUTmhMblNnZ1l0WlMwaEZxZ2d6NWl3SjFINzMxSXVPcUMxNkl4?=
 =?utf-8?Q?2+LzzgGu08rDo7H83QP7iYvFl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0fdbf95-a7fc-4d55-f9d4-08dc84de7235
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 21:36:51.5262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uODF1g/+Xikewebp0Gykg/8OBJs2E47U7097fJwdOC6A4khHbsbxzinqYqqOSD6OOIKj+NUeUvuMu2LjR1552A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4492

On 6/4/24 12:47, Kim Phillips wrote:
> Fix a null pointer dereference induced by DEBUG_TEST_DRIVER_REMOVE.
> Return from __sev_snp_shutdown_locked() if the psp_device or the
> sev_device structs are not initialized. Without the fix, the driver will
> produce the following splat:
> 

> 
> Fixes: 1ca5614b84ee ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
> Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
> Reviewed-by: John Allen <john.allen@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> v2:
>   - Correct the Fixes tag (Tom L.)
>   - Remove log timestamps, elaborate commit text (John Allen)
>   - Add Reviews-by.
> 
> v1:
>   - https://lore.kernel.org/linux-crypto/20240603151212.18342-1-kim.phillips@amd.com/
> 
>   drivers/crypto/ccp/sev-dev.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
