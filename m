Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010063.outbound.protection.outlook.com [52.101.201.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1549535957;
	Tue,  6 Oct 2026 16:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791304883; cv=fail; b=QjxAyB+/3PguXBbg+VBAcPr/N5gYfh9zIVZtlKzHnERbF2rHFJ8xUkQJs2QwdNUMaEmSIHYuDXJSuw4ZlBq5Es54znsXHG9Xf1BkmxUd7tFOUwVEbrpqAjd5xzbY41YAj07hzcLWBpVa5q2xcpsCA+AiSz5OsYpbmeoiL7sxetI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791304883; c=relaxed/simple;
	bh=HzY+r0Z8QT422G/2JljPreIP1jD2ALtoW3y8YyzJ2Kk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bZWlfnu3O5g2eJubAX3GYY3Jy6K93T+EmlYNNrRNecwuYVc3BZBYj2KwS58EkMNOVOyvz0dDGMWeU3ENlCNOnGrJQKMENSr+AN6P0VpMgc2Ugr/YDPOBIHdfFqR0K3xvaCU4WJ/23OB6Efbkb9KsU74qUZbt5XsblLaEcbg1uCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VReTjAYg; arc=fail smtp.client-ip=52.101.201.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VReTjAYg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZngBb+DMnBrnRFxF2Kipy+ljM1lZQcB5k6K6CjmoBS8D3D2cwMBzmkWuG+qgtffVidUdPyYofSCRCI3oso9oifSmKfo39Hc7/6ibDrHW1PDM3APS2GbYD7AVQDbpr32uBca0HNZGMr+WLaKwMkvGZD3pkf2/u0zR1SCb/ZmcAoCgLnNLPMPM7bRvJk+iY+zf/89R0o6216jx3fHwwLY2weL06uuUKnoReU8k1g1UrI4NqjBrMox11wYzHJjJrRucwiGMc4ZXZV0xnfGtzHEm1T3oJUSdckcmXdR9tSnx82fTzjbDsCYMrYafcMOJSbY9CmKIugTly22nu0X5ph/TCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UvI9OJ/1Bk4DTybNeOg2EcNrK6OqjawSsBq1Fvi/r7U=;
 b=qghBTptUjfhLh37dtc8NBDEsma2gzeAejS1GOLHqOOoz9F1MRBxIyoiEGvTG+YTyJ9s4znxZp+Af09uNldjj1MJhrg4RFTCaxzWTjZ5EKDqFkbx1/eFCD9pzr4FOE3WW+v6wDIsfPJ7E43JwNsIbUt7R3gTl46E26JaoYCoIo4NU3lFXyBrBKQwzmL7JfFaIxsxuf7OG9+OI7i9cJ4EI3GdjvFnFkJSd7YPxS2ezPBYGtygUz1LU+C4fy+51nfS/ZVHPCcnliMNnY/VusQIOBFA3prbk6Bj6MXhEgTkOMtJS6IHPYfw/vqEUa2LycYIjVVDZ36IvK8LMI0wb7t/uew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UvI9OJ/1Bk4DTybNeOg2EcNrK6OqjawSsBq1Fvi/r7U=;
 b=VReTjAYg7RgwjGXDmHW5xjb0xrLOvLs9v+wyVn9N9ocE20CcgZXwEuIlckmUEf5VK6zhnXRiDukC94xQnGLg7/EKFQeEkEjTJzoATc62UlZIgEuZOaflCq1pqvLjC6lg2/BFxNBpXo38CW4cgZfddt2bxmCoIkPsPu7zGk0Q5zs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ1PR12MB6217.namprd12.prod.outlook.com (2603:10b6:a03:458::6)
 by IA1PR12MB6211.namprd12.prod.outlook.com (2603:10b6:208:3e5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 6 Oct
 2026 16:41:15 +0000
Received: from SJ1PR12MB6217.namprd12.prod.outlook.com
 ([fe80::bdbb:19b0:4f1b:44e5]) by SJ1PR12MB6217.namprd12.prod.outlook.com
 ([fe80::bdbb:19b0:4f1b:44e5%6]) with mapi id 15.21.0451.022; Tue, 6 Oct 2026
 16:41:14 +0000
Message-ID: <028cdf37-2272-4d7f-a8dd-bd011a55774d@amd.com>
Date: Tue, 6 Oct 2026 11:41:11 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 7/7] crypto/ccp: Implement SNP Download Firmware EX
To: Tom Lendacky <thomas.lendacky@amd.com>, mcgrof@kernel.org,
 russ.weight@linux.dev, dakr@kernel.org, ashish.kalra@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
 aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com,
 shansinha@google.com
References: <cover.1791212077.git.prsampat@amd.com>
 <c03c5a47f3972486fdb144bf8c6f50ab3375da2f.1791212077.git.prsampat@amd.com>
 <4639287b-0fe6-4aaa-9720-c7f264019d06@amd.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <4639287b-0fe6-4aaa-9720-c7f264019d06@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR16CA0007.namprd16.prod.outlook.com
 (2603:10b6:610:50::17) To SJ1PR12MB6217.namprd12.prod.outlook.com
 (2603:10b6:a03:458::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6217:EE_|IA1PR12MB6211:EE_
X-MS-Office365-Filtering-Correlation-Id: 47c0a5ca-00e1-424d-bb51-08df23c8a30d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|4143699003|10067099003|11063799006|56012099006|6133799003|5023799004|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	gFzFnz1voXxTWPKmDCXKq6u6wPDWt33wLiVzBZwzqD450avhhTYNHPB6Juf/b7Tp580QLz45sAuliPBYksX/kwa24GR62RpPw/izCxEz/p4Kb1qZaGEbTiQI0hiTb91/JOxlHoA5tsGdg4hL0a1kmuYlq52c3b62fRHgH8RB2I2NXp2expR18a9P/fdDO+RbttV1qjP9Qn/X6zkcob1faRUlf8qifwiulcLqxTbQon9skH/PK70YPMxSF3leMzZQ2I7KHmUIsQSINU1lbGvwH17uryuYUhQoRpFYoDqcodfdJqQDwG057vWN4FmzGcitlUP+Mv+beLBIq0bscBLJtdgF/NQBkrGP9UEv3BEFLOQQFKyaV4cacETImxjp1QZ1BINEe7bQ0IKO3280iJuSXga5fNZg+y5hlZjpfMdzxNv2pKNtEX1vvncAt4MKrDiUd6v5x9r9Du4S0ziaaVwgNC2R8PFYzDDS9Ct0h2btDtQ6luFdO7VFz4Tqxu8PIbBrxVWfycPh14j9vZxHv1SElUnOsCgvzj/tDM/dN4h5kj3+ZRxkKy4WQZ4nfc1OhF/o4DmqN6wzrBwFMJeSjL8gx94+98eSHqsoFwKgWLYq2D49g6PU3oOXO1F/eedl1B+LRHc/tTEBOTRiMS6HCDZua1tam+aroe8lb6Ov5EL8w+A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6217.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(4143699003)(10067099003)(11063799006)(56012099006)(6133799003)(5023799004)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R1Z4NktCc091L0N3RnZybllRMWVmQStUMmxoWFB4QTFDcW9SSTVnWTRhYytU?=
 =?utf-8?B?RXBJazlOVmlUd3FYRjlLT1BrbUg5OFh1NkkyUzRFWUN2SmVNS1FVZVIzS3BM?=
 =?utf-8?B?VTY3aVVWK3pKQW5EK3pvQStIc3hyT25DSmNUeGpvM09RdzdXcmMwd2JOMElv?=
 =?utf-8?B?VFBnUGE2WmI3N1VOK0NBOTRqU28wMHN6cHU3T3pWUHBBb2xWQWNuN1pLL1JF?=
 =?utf-8?B?SWpSTU1MdlJVUTM4bWZKLzJMdFNJV3NOSU5MemZyczRyWWN0eGQyRWJub21a?=
 =?utf-8?B?SUs5SSt4SytYcXl0bnE4THN3Ulkxc1haZ2lZQjhZMkRGa0laWmRZTkxvTHUx?=
 =?utf-8?B?OU1uNThDUVZKWDRiQ0svRGROTWZnVEtiay9TOXJTKzN2K25VWXdtdkFDcHNB?=
 =?utf-8?B?c1JXNW41NlpUcVVDbmZIWUUxU0dRcndGQVFjNm54Smw5MXlpaXhGMHBEb0NV?=
 =?utf-8?B?dkdUMzdJc2pSN2FIeEFzaUhNYjJYQlZrVHFvSDQ5aEVzTXlhc3kreHlabkxQ?=
 =?utf-8?B?QkxUNElEdXFwS0hUcTFTemZPR3dURVdSb0piMUZNTXBNd2twNVdjNi9XY1BX?=
 =?utf-8?B?OW9STU0vTUhxVDl4WWw5N3JWRHFwbGZJaTVKRTVFd1dscTJhTmt1YnRmaDRh?=
 =?utf-8?B?VFlnQU01K0hUQXNIanRhc2ZBeStjWnRjSDBKaURCWkpNT0pIbXlRSWkvUTdM?=
 =?utf-8?B?R1MyUGxUdUUzMUdtakh3ZXQ4NmRFR3d3MHpUZEd1NHB0b2toc3IyanVYTG1V?=
 =?utf-8?B?QjJiLytvdXlQUUhPTVUxR0hyYUxOUnV1RFIwY0ZETFdZcS9KUDlRM1dEUGhn?=
 =?utf-8?B?RnpKUnU5UHlyZyszc3M0SGhpU28zVFNVWHZrRit2WWtWcGlSYTlRWmk0Z0dk?=
 =?utf-8?B?aDV2bEZtd0Rqb1ZwTmQ2ckNJRFVqTWVVWWRybWNNTUhBck1aTUV3VWc0MWl5?=
 =?utf-8?B?c2U2c2pHdGVOamFHaE9MM2tGTUd4eUlkd2tPWXpYYVZ2ZGhOcllJTUNVVVEy?=
 =?utf-8?B?RjNhaVBPdXA2aGhXcmNkWjI3ek1KT1AvK3hDanBoSldiTmVSckErOGtwNUwv?=
 =?utf-8?B?U2RDcUhOR3ZzdkhDRS94cC9oUlczVUQ5cDBFM1cxUGEyYjEwYjhuSTgxaHVI?=
 =?utf-8?B?M1NzczNHOFJlVTNVRy9xNUw4WUhIcXorWEllRW5ud29YQlBGcWFMRWpwYUdD?=
 =?utf-8?B?cmhocjR0OWVuWjJsYkVJaHB6WGNBWm05UFVrMkQvUGllNVZjeW1aNEJmeGZr?=
 =?utf-8?B?ZXRYdS83MlZBeFBCdVEycVArNkkzTzgvQzBBcVAzeUFUZjJlTzF4L3M0TkVL?=
 =?utf-8?B?S3JYTWlNVXphSDJZeEt4eGVBbWQvL3c2S1F1dVVXWUlXME15dlZ0azZsRkxS?=
 =?utf-8?B?anI1UXBuaVlyUStBQitBaTRhTEtXaXM5RnBsQUV3WUl4WVdFNk9kR3N1aktK?=
 =?utf-8?B?UUFNNG42RC9SV3RZQVhRdUJnbzd3ZHRSclNSc2pTb2JHbzVieGVRVnRCMjlS?=
 =?utf-8?B?Uk0xMUEwUGR4THFUTVRndi9GVzAySXNPaTljQ3NxMVhuakdsWWw0K1dxY1Fi?=
 =?utf-8?B?TXhScDNWRXd5MDFwOU9abVlrNDRXZmJHZ29mQWFIUDJXZ1pqZmtXUFdobFFI?=
 =?utf-8?B?dWNpSTFVTnFXSWtyUXQ4S2l3Z1FBWGFObDFVdmhJM1VuNjRuZ0t5MEFRZ3c2?=
 =?utf-8?B?K3luT0tlUGhCSTdHZzZlRXB3SkFwMCtuZ2ZDbkdYYmNIMFhkMzk2VVZLaUx6?=
 =?utf-8?B?UENCUENvU29vcFpocGlnZ2pubzhscjRNU1JPb1MzaW93dVcvS3VpRWtaWnJK?=
 =?utf-8?B?QkNQMFFsUDB1czRCa0xDNmd3M2wvSUVsMnk0S1JJZUtTSEJuL2lNYWtIQTFG?=
 =?utf-8?B?WHp6WmJmUXNxdElqaWNCVWhuSWF6cFVUa1pWRmRrSzNTSEtHM0VkdDBBYkIw?=
 =?utf-8?B?UWxxT3VHTzYxVEtMMzJRNnE5b1diVTI5ZjVGSnVzQXVLeHVhbHRQZm03S2dM?=
 =?utf-8?B?QWRjV05MWWp0M2l5NHlFb2tjSEV1byswUU9UOVpNbG9jeUxyQkZhajFhV1Nt?=
 =?utf-8?B?SHlEUTFiZVJTdk1OM0VNb3RjOVZSd1U0SlNKSTNuUTAvNTZLUUZ3L2JtTlVR?=
 =?utf-8?B?RzBRTVR0UzErSU5uWGNwOWRJN3R2VC9mMWJwWnBkNGVkV1RzWEhWZkR4U2sz?=
 =?utf-8?B?WDVtM2JuMHlKM0dweHZqRlRQSndiVDBkTWdRQVl2a0RhaXFPY01KaUNmc1Uw?=
 =?utf-8?B?cTdyQ2JHSlMvQnJiblg3R0w0UFFJWExyZE5NTWcwRDZGT1JPS0NWV2syNVFx?=
 =?utf-8?Q?Yj2tk5eeTpz8NwxNNO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47c0a5ca-00e1-424d-bb51-08df23c8a30d
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6217.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 16:41:14.8505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3GsxFjDseaoq5/VjTWm+Flct++VYmOT8/JvMPAOhv1l6c2Qob+anB8b80QOIbXOjMAZ8q845RQ9IARSBykbe3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6211

Hi Tom,

Thanks for the review!

On 10/6/26 11:10 AM, Tom Lendacky wrote:
> On 10/5/26 11:15, Pratik R. Sampat wrote:
>> Implement SNP live firmware update using the DOWNLOAD_FIRMWARE_EX
>> command.
>>
>> DOWNLOAD_FIRMWARE_EX requires the legacy SEV platform to be UNINIT. If
>> it is WORKING then legacy guests are running and the update is refused
>> as busy. If it is INIT, shut it down, release the buffers the firmware
>> owns across that shutdown, run the update, and bring the platform back
>> up afterwards. SNP is never taken down, so SNP guests are unaffected.
>>
>> To test run the following with your sbin file in FW:
>>
>> echo 1 > /sys/class/firmware/sev/loading
>> cat <firmware.sbin> > /sys/class/firmware/sev/data
>> echo 0 > /sys/class/firmware/sev/loading
>>
>> The COMMIT bit is left clear, so the image is only loaded provisionally
>> and the admin decides when to make it permanent with ioctl(/dev/sev,
>> SNP_COMMIT). To roll back, do not commit and upload the previous image
>> the same way.
>>
>> Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
>> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 284 ++++++++++++++++++++++++++++++++++-
>>  drivers/crypto/ccp/sev-dev.h |   2 +
>>  include/linux/psp-sev.h      |  19 +++
>>  3 files changed, 304 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 88cf60a9640e..e54f23ba1b9b 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -29,6 +29,7 @@
>>  #include <linux/psp.h>
>>  #include <linux/amd-iommu.h>
>>  #include <linux/crash_dump.h>
>> +#include <linux/sizes.h>
>>  
>>  #include <asm/smp.h>
>>  #include <asm/cacheflush.h>
>> @@ -252,6 +253,7 @@ static int sev_cmd_buffer_len(int cmd)
>>  	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_addr);
>>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>> +	case SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX:	return sizeof(struct sev_data_download_firmware_ex);
>>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>>  	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>>  	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
>> @@ -2213,17 +2215,297 @@ static int sev_update_firmware(struct device *dev)
>>  }
>>  
>>  #ifdef CONFIG_FW_UPLOAD
>> +/* Largest image the firmware accepts, anything above is rejected */
> 
> I may have missed it, but I don't see anything in the SNP ABI spec that
> says the limit is 512K. If that doesn't have a limit how did we arrive
> at 512K?
> 

The ABI spec doesn't mention it, but the firmware had this limit hard-coded.
This can potentially change without notice to the ABI. However, I did want a
sanity check in the OS and that's why had it in.

I can drop it and let the firmware fail if the image is too large.

>> +#define SEV_FW_IMAGE_MAX_SIZE	SZ_512K
>> +
>>  static enum fw_upload_err sev_fw_upload_prepare(struct fw_upload *fw_upload,
>>  						const u8 *data, u32 size)
>>  {
>> +	struct sev_device *sev = fw_upload->dd_handle;
>> +
>> +	if (size > SEV_FW_IMAGE_MAX_SIZE) {
>> +		dev_err(sev->dev, "DLFW_EX: image of %u bytes exceeds the %u byte maximum\n",
>> +			size, SEV_FW_IMAGE_MAX_SIZE);
>> +		return FW_UPLOAD_ERR_INVALID_SIZE;
>> +	}
>> +
>>  	return FW_UPLOAD_ERR_NONE;
>>  }
>>  
>> +static int sev_download_firmware_ex(const u8 *data, u32 size, int *psp_ret)
>> +{
>> +	struct sev_data_download_firmware_ex sev_data = {0};
>> +	int ret, order;
>> +	struct page *p;
>> +	void *fw_blob;
>> +
>> +	order = get_order(size);
>> +	p = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
>> +	if (!p)
>> +		return -ENOMEM;
>> +
>> +	fw_blob = page_address(p);
>> +	memcpy(fw_blob, data, size);
>> +
>> +	sev_data.len = sizeof(sev_data);
>> +	sev_data.fw_paddr = __psp_pa(fw_blob);
>> +	sev_data.fw_len = size;
>> +	/*
>> +	 * Don't commit to the new firmware immediately, perform an explicit
>> +	 * SNP_COMMIT after
> 
> Don't commit the new firmware, an explict SNP_COMMIT is required after
> update.

Ack.

> 
>> +	 */
>> +	sev_data.commit = 0;
>> +
>> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX, &sev_data,
>> +				  psp_ret);
>> +
>> +	__free_pages(p, order);
>> +
>> +	return ret;
>> +}
>> +
>> +static enum fw_upload_err sev_fw_upload_handle_err(struct sev_device *sev,
>> +						   int rc, int psp_ret)
> 
> Name rc something more specific, like cmd_ret, to better distinguish
> what you're checking.

Sure.

> 
>> +{
>> +	enum fw_upload_err ret = FW_UPLOAD_ERR_FW_INVALID;
>> +	const char *msg;
>> +
>> +	if (!rc)
>> +		return FW_UPLOAD_ERR_NONE;
>> +
>> +	/*
>> +	 * The command timed out: psp_ret was cleared and the PSP was declared
>> +	 * dead, so there is no firmware status to decode.
>> +	 */
> 
> Move this comment into the if block as it is explaining what happened if
> psp_dead is set and simplify it:
> 
> "The SEV command timed out and marked the ASP dead, there is no status
> to decode."

Ack, will do.

> 
>> +	if (psp_dead) {
>> +		dev_err(sev->dev, "DLFW_EX: PSP not responding (failed %d, error %#x)\n",
>> +			rc, psp_ret);
>> +		sev->fwl_rollback_required = false;
>> +
>> +		return FW_UPLOAD_ERR_TIMEOUT;
>> +	}
>> +
>> +	switch (psp_ret) {
>> +	case SEV_RET_INVALID_PARAM:
>> +		msg = "Provided image is not well formed";
>> +		break;
>> +	case SEV_RET_INVALID_LEN:
>> +		ret = FW_UPLOAD_ERR_INVALID_SIZE;
>> +		msg = "Provided image has an unusable length";
>> +		break;
>> +	case SEV_RET_SHUTDOWN_REQUIRED:
>> +		msg = "Provided image cannot be live-updated, shutdown required";
>> +		break;
>> +	case SEV_RET_BAD_VERSION:
>> +		msg = "Provided image < committed version";
>> +		break;
>> +	case SEV_RET_INVALID_PLATFORM_STATE:
>> +		msg = "Platform not in UNINIT state";
>> +		break;
>> +	case SEV_RET_INVALID_ADDRESS:
>> +		msg = "Unaligned address provided";
>> +		break;
>> +	case SEV_RET_UNSUPPORTED:
>> +		msg = "Feature not supported";
>> +		break;
>> +	case SEV_RET_INVALID_CONFIG:
>> +		msg = "Image rejected, unsupported configuration";
>> +		break;
>> +	case SEV_RET_BAD_SVN:
>> +		msg = "Image rejected, SVN < committed SVN";
>> +		break;
>> +	case SEV_RET_BAD_SIGNATURE:
>> +		msg = "Bad firmware signature";
>> +		break;
>> +	case SEV_RET_UPDATE_FAILED:
>> +		/* The previous firmware is still running, a retry is safe. */
>> +		ret = FW_UPLOAD_ERR_BUSY;
>> +		msg = "Upgrade failed, automatically reverted";
>> +		break;
>> +	case SEV_RET_RESTORE_REQUIRED:
>> +		/*
>> +		 * Firmware requested a roll-back. Declare the PSP dead so
>> +		 * nothing else tries to use it, and let the next upload through
>> +		 * so the admin can restore the previous image.
>> +		 */
>> +		sev->fwl_rollback_required = true;
>> +		psp_dead = true;
>> +		ret = FW_UPLOAD_ERR_RW_ERROR;
>> +		msg = "Live upgrade failed, please roll back";
>> +		break;
>> +	case SEV_RET_HWSEV_RET_UNSAFE:
>> +		/*
>> +		 * Following a return of HARDWARE_UNSAFE, operation of the SEV
>> +		 * firmware is indeterminate and the recommendation is to reboot
>> +		 * the platform. Declare the PSP dead so the driver stops
>> +		 * issuing commands to it while the reboot is pending.
>> +		 */
>> +		sev->fwl_rollback_required = false;
>> +		psp_dead = true;
>> +		ret = FW_UPLOAD_ERR_HW_ERROR;
>> +		msg = "SEV firmware no longer safe. Reboot recommended";
>> +		break;
>> +	case SEV_RET_NO_FW_CALL:
>> +		/* The command never reached the firmware. */
>> +		ret = FW_UPLOAD_ERR_BUSY;
>> +		msg = "Driver error";
>> +		break;
>> +	default:
>> +		ret = FW_UPLOAD_ERR_HW_ERROR;
>> +		msg = "Unknown SEV firmware error";
>> +		break;
>> +	}
>> +
>> +	dev_err(sev->dev, "DLFW_EX: %s (failed %d, error %#x)\n", msg, rc, psp_ret);
> 
> This is coming from userspace interaction, so probably should use
> ratelimited variant (here and any place you issue a message).
> 

Ack, will do.

>> +
>> +	return ret;
>> +}
>> +
>> +static int sev_fw_upload_shutdown_platform(struct sev_device *sev)
>> +{
>> +	int rc, error = SEV_RET_NO_FW_CALL, sev_plat_state;
>> +
>> +	lockdep_assert_held(&sev_cmd_mutex);
>> +
>> +	rc = sev_get_platform_state(&sev_plat_state, &error);
>> +	if (rc) {
>> +		dev_err(sev->dev, "SEV get platform state failed %d, error %#x\n",
>> +			rc, error);
>> +		return rc;
>> +	}
>> +
>> +	switch (sev_plat_state) {
>> +	case SEV_STATE_UNINIT:
>> +		return 0;
>> +	case SEV_STATE_WORKING:
>> +		/* Legacy guests are running, the update cannot proceed. */
>> +		return -EBUSY;
>> +	case SEV_STATE_INIT:
>> +		break;
>> +	default:
>> +		dev_err(sev->dev, "Unknown SEV firmware state %d\n", sev_plat_state);
>> +		return -EINVAL;
>> +	}
>> +
>> +	rc = __sev_platform_shutdown_locked(&error);
>> +	if (rc) {
>> +		dev_err(sev->dev, "SEV platform shutdown failed %d, error %#x\n",
>> +			rc, error);
>> +		return rc;
>> +	}
>> +
>> +	__sev_release_firmware_buffers(false);
> 
> Do the buffers have to be released? If so, why? I think you can keep the
> allocations. During platform initialization the buffers will be
> detected. Is there a shutdown path where they might not get freed?
> 

Shantanu hit this on Milan with an earlier version of the series that kept the
buffers across the update [1]. After DOWNLOAD_FIRMWARE_EX the new firmware
rejected INIT_EX with SEV_RET_INVALID_PAGE_STATE (0x1A), because sev_es_tmr and
sev_init_ex_buffer were still in the firmware state left over from the previous
image's INIT. Freeing them, and letting re-init allocate fresh ones, fixed it,
which is where this call came from.

However, a fresh allocation with SNP initialized just goes through
rmp_mark_pages_firmware(), so my understanding of what the new firmware needs
is the reclaim -> make shared -> mark firmware cycle, not necessarily new
memory.

Freeing seemed like the easiest option, but if you prefer, just cycling them
back should be able to achieve the same effect, I believe.

[1] https://lore.kernel.org/all/20260831204757.436751-1-shansinha@google.com/

>> +
>> +	sev->fwl_reinit_required = true;
>> +
>> +	return 0;
>> +}
>> +
>> +static void sev_fw_upload_reinit_platform(struct sev_device *sev)
>> +{
>> +	int rc, error = SEV_RET_NO_FW_CALL;
>> +
>> +	lockdep_assert_held(&sev_cmd_mutex);
>> +
>> +	if (!sev->fwl_reinit_required)
>> +		return;
>> +
>> +	rc = __sev_platform_init_locked(&error);
>> +	if (rc) {
>> +		dev_err(sev->dev, "SEV platform re-init failed %d, error %#x\n",
>> +			rc, error);
> 
> Single line.

Ack.

> 
>> +		return;
>> +	}
>> +
>> +	sev->fwl_reinit_required = false;
>> +}
>> +
>> +static enum fw_upload_err sev_fw_upload_update(struct sev_device *sev,
>> +					       const u8 *data, u32 size,
>> +					       u32 *written)
>> +{
>> +	int rc, error = SEV_RET_NO_FW_CALL;
>> +	enum fw_upload_err ret;
>> +
>> +	guard(mutex)(&sev_cmd_mutex);
>> +
>> +	/*
>> +	 * A PSP declared dead only executes DOWNLOAD_FIRMWARE_EX if it was the
>> +	 * firmware update that killed it and asked for a rollback. Declared
>> +	 * dead for any other reason it will not answer until the platform is
>> +	 * rebooted.
>> +	 */
> 
> "SEV firmware will only successfully execute the DOWNLOAD_FIRMWARE_EX
> command if a firmware rollback is required. Other commands may be
> processed, but may not execute properly. Use the psp_dead boolean to
> restrict execution to this path."
> 
> Say something similar where psp_dead is being set to true in
> sev_fw_upload_handle_err().

Sure.

> 
>> +	if (psp_dead && !sev->fwl_rollback_required) {
>> +		dev_err(sev->dev, "DLFW_EX: PSP is not responding\n");
>> +		return FW_UPLOAD_ERR_HW_ERROR;
>> +	}
>> +
>> +	/*
>> +	 * If the last firmware update returned RESTORE_REQUIRED, retry DLFW_EX.
> 
> I see a mix of DOWNLOAD_FIRMWARE_EX and DLFW_EX, change these to all be
> the same name of your choice.

Sure.

> 
>> +	 * We being in this state means that the legacy firmware has previously
> 
> s/We being/Being/

Ack.

> 
>> +	 * been shut down, so no need to do it again.
>> +	 */
>> +	if (sev->fwl_rollback_required) {
>> +		psp_dead = false;
>> +	} else {
>> +		rc = sev_fw_upload_shutdown_platform(sev);
>> +		if (rc) {
>> +			return psp_dead ? FW_UPLOAD_ERR_HW_ERROR
>> +					: FW_UPLOAD_ERR_BUSY;
>> +		}
>> +	}
>> +
>> +	rc = sev_download_firmware_ex(data, size, &error);
>> +	ret = sev_fw_upload_handle_err(sev, rc, error);
> 
> Maybe it's just me, but using generic rc and ret can make this possibly
> confusing in the future. How about:
> 
> s/rc/cmd_ret/
> s/ret/fwl_ret/
> s/error/psp_ret/
> 

Nah, I can see that. Your options are so much better!

>> +	if (ret == FW_UPLOAD_ERR_NONE) {
>> +		*written = size;
>> +		sev->fwl_rollback_required = false;
>> +	}
>> +
>> +	/* A rollback retry failed. PSP now stays dead */
>> +	if (sev->fwl_rollback_required) {
>> +		psp_dead = true;
>> +		if (ret != FW_UPLOAD_ERR_HW_ERROR)
>> +			ret = FW_UPLOAD_ERR_RW_ERROR;
>> +	}
>> +
>> +	if (!sev->fwl_rollback_required && !psp_dead)
>> +		sev_fw_upload_reinit_platform(sev);
>> +
>> +	return ret;
>> +}
>> +
>>  static enum fw_upload_err sev_fw_upload_write(struct fw_upload *fw_upload,
>>  					      const u8 *data, u32 offset,
>>  					      u32 size, u32 *written)
>>  {
>> -	return FW_UPLOAD_ERR_BUSY;
>> +	struct sev_device *sev = fw_upload->dd_handle;
>> +	u8 old_major, old_minor, old_build;
>> +	enum fw_upload_err ret;
>> +
>> +	old_major = sev->api_major;
>> +	old_minor = sev->api_minor;
>> +	old_build = sev->build;
>> +
>> +	ret = sev_fw_upload_update(sev, data, size, written);
>> +	if (ret != FW_UPLOAD_ERR_NONE)
>> +		return ret;
>> +
>> +	if (sev_get_api_version()) {
>> +		dev_err(sev->dev, "SNP platform data refresh after firmware update failed\n");
>> +		return FW_UPLOAD_ERR_HW_ERROR;
>> +	}
>> +
>> +	if (sev->api_major != old_major || sev->api_minor != old_minor ||
>> +	    sev->build != old_build) {
> 
> One line.

Ack.

> 
>> +		dev_info(sev->dev, "SEV firmware updated to %d.%d build %d\n",
> 
> Should be the same as the sev_pci_init() issued message.
> 
>> +			 sev->api_major, sev->api_minor, sev->build);
>> +	} else {
>> +		dev_info(sev->dev, "SEV firmware version unchanged: %d.%d build %d\n",
> 
> s/ build /./
> 

Thanks!
--Pratik

> Thanks,
> Tom
>> +			 sev->api_major, sev->api_minor, sev->build);
>> +	}
>> +
>> +	return ret;
>>  }
>>  
>>  static enum fw_upload_err sev_fw_upload_poll_complete(struct fw_upload *fw_upload)
>> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
>> index 7ec692e2147e..1e45a08c41da 100644
>> --- a/drivers/crypto/ccp/sev-dev.h
>> +++ b/drivers/crypto/ccp/sev-dev.h
>> @@ -71,6 +71,8 @@ struct sev_device {
>>  	struct sev_tio_status *tio_status;
>>  
>>  	struct fw_upload *fwl;
>> +	bool fwl_rollback_required;
>> +	bool fwl_reinit_required;
>>  };
>>  
>>  int sev_dev_init(struct psp_device *psp);
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index fab62228f981..b71154e9ae4b 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -890,6 +890,25 @@ struct sev_platform_init_args {
>>  	unsigned int max_snp_asid;
>>  };
>>  
>> +/**
>> + * struct sev_data_download_firmware_ex - SNP_DOWNLOAD_FIRMWARE_EX structure
>> + *
>> + * @len: length of the command buffer read by the PSP
>> + * @rsvd0: reserved
>> + * @fw_paddr: system physical address of the start of the firmware blob
>> + * @fw_len: length of the firmware blob
>> + * @commit: whether to immediately commit the firmware update
>> + * @rsvd1: reserved
>> + */
>> +struct sev_data_download_firmware_ex {
>> +	u32 len;			/* In */
>> +	u32 rsvd0;
>> +	u64 fw_paddr;			/* In */
>> +	u32 fw_len;			/* In */
>> +	u32 commit:1;			/* In */
>> +	u32 rsvd1:31;
>> +} __packed;
>> +
>>  /**
>>   * struct sev_data_snp_commit - SNP_COMMIT structure
>>   *
> 

