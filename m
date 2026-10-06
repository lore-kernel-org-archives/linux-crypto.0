Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012054.outbound.protection.outlook.com [52.101.53.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5011624886E;
	Tue,  6 Oct 2026 17:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791307933; cv=fail; b=DLF/ixfR5UgG/CkR8DzE6MLu2iDQytWb/BVzPlAXoPlfwD0/3GAMujFb44g+mSiVho+K/Op1mAY5feXHsUSeeY5Gslsf/h5RokBn59q0TmsfA7PCDZOBYl+y1L20lC4mryHDWZKUib8QHr5jiYahiovW7NboC5S+d+rzAyZ6+oE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791307933; c=relaxed/simple;
	bh=W3GPYT0rFd2eTW1UCcAlpWCR+kfp8gH4Mq98/+kibhg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qqZ/Euy/sF+F6d77Zz/jMCTPOXHy3I0HZqKBXF2uG/UIx4BjkQ13N3y4kJSlDOeOBPMqtv3RejK7SKMNdA8AB58u2uL3YWlPO08JIDWGWt4IJRLiDsQo8M44TIa9rcoTMJM+O1g2g83X4jCqq4DPBhtbZDJ7KtGAV3+lfIE+g6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YM1IZDld; arc=fail smtp.client-ip=52.101.53.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YM1IZDld"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PgIz5xdprlMS9JkBEibs5BsslXsHFnUhvRCMS5GIpXiVucSfEDXRGc0POqsp5WQxQyYt0QaszGujVSHSkVDhpWRrRYWR8xbh2v9/yWq6fOzEkmc4ZJWhA7LE373wAewN9HP9J9xt9v71z7uY6x6xGkDNIsL5zTHCx4Ki8ycTVwfHQUWZNDsufutVlMUA6wUFZ7Y8afaivJnGY36rDx5B8rQtI5K01rhGOzEC1K/EPpnd2UgCmRsadhgTlB/lXZvMhHMJw5dLXDGA/JVMDmd1Eao6PKNmul7vR2+WAGgAfDkma/OMAxf4sEmi3zNYhuM/yQYrhHdXeQWGeZayHaTMvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YyeYl92vZm+255tUJcq7qlZGqYraocwbuCo0VHTjTZY=;
 b=uPz/Lq1a04lk9KyywrX+qn8xCiDGFC1yvWikUi1b4Rakd3XfN3XysBwPnmQu8FlVPrXbtBC5xqmR9meAPOrYrgkMP0AuDxvMDSO4shpXioHa2amN+4tVjRQVN+CLIPyqoWlrs7nOOcW3FskvQSwVBxheSIYF5/27cqgvVUMyDzWLwVzuRrQRXEcLWeQfyEMH7/qNNCOqT2ECD8qsSbIkKTmbX4li1VYH31MIUWghH31gM1FSFGJm7QtiOB2DToCbaV7f731MxSWx+CLsm4eAbKih5RN76SqJ/i21B+IRJNX2HM/rQDDYZdYG/xup/882PCtD86EZxwzKSrS21KjfCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YyeYl92vZm+255tUJcq7qlZGqYraocwbuCo0VHTjTZY=;
 b=YM1IZDldGGIEMuw4nxOBZ192T1nXXAj1Gnm+kPyTRGHVEJAS26EG/PE4xfI3FvH9wu/Yuu4X++QM9mXkplJnBmegcwyyhWyOWIni9dO0QmxIMbs5z+MQEIEOePlDJqYqsTyLkwyFFBIKOwkmaN+VBupKLFLSWJT8dOdxC/qpvcA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Tue, 6 Oct
 2026 17:32:08 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0472.016; Tue, 6 Oct 2026
 17:32:07 +0000
Message-ID: <66568327-9b4b-474d-bd48-667ec3bee6c8@amd.com>
Date: Tue, 6 Oct 2026 12:32:04 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 7/7] crypto/ccp: Implement SNP Download Firmware EX
To: "Pratik R. Sampat" <prsampat@amd.com>, mcgrof@kernel.org,
 russ.weight@linux.dev, dakr@kernel.org, ashish.kalra@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
 aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com,
 shansinha@google.com
References: <cover.1791212077.git.prsampat@amd.com>
 <c03c5a47f3972486fdb144bf8c6f50ab3375da2f.1791212077.git.prsampat@amd.com>
 <4639287b-0fe6-4aaa-9720-c7f264019d06@amd.com>
 <028cdf37-2272-4d7f-a8dd-bd011a55774d@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <028cdf37-2272-4d7f-a8dd-bd011a55774d@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS1P222CA0022.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:44b::6)
 To SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|DS7PR12MB6309:EE_
X-MS-Office365-Filtering-Correlation-Id: d4d318f3-3f59-47b3-ee27-08df23cfbe80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|4143699003|11063799006|56012099006|6133799003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	FOfxibBeyKM3YNHb3QRdGA3bKzlSgOyE8FwOQBI9aaOXSeJWvj5qnc3OE6gGKeknWeRD+OrmU5knkRxHs1FQ8VTHvITDAY5mB3Hrgl7tuQyHXguqiucsAf20DKeeT7U078pS8WG9hFBCp6Xuf+trlP3rBXEjnkKJbYA3A5E3eqYbUd0R2DC6c+4U/fi2/CtiYj9nYTexUdxhYdLDMIhPNkkEcdvQFBy+uzimQ93wjf0USpbYGT1FiV+Pi0UiM+a12ddzNza6fIHEuEBLfjDhHhXpp8DBfH1xF9wgCJ1Jx/VlttjshoIyDMSxmcKwuMmf1NyFbXAYPOUXYUc6Gm3B3YzFwnMj7Yr8csqCuDkRDDCxIGHxnsoy6zkySGRjvJmH844Kv/1mBljVPtLrQvOObtSDonJ0Jg0Z0/81QNSETrZN8aWM+EkDSrXTq0AHlbMZY30faQXX583QYf9oeqR2lzBxBeR3o4QPEY1/9SNhE05dYGrJ2jTSFH/2ellOAGGjSb9QdB+eOV0XRTTCYcK5bVo8wFvZqVAcZS3wN0zowx8pXSowdFASge/MpzcoXK7g45Nk7F8utErPSQ6nGNPzODvMrgtAMXV9KEV4+nvY1NmlQHNr0weXvPO72kbSvUProLqoG2B7Grv+Vv/T5lE7ePjvPvgEpunDDqAzPY8zoSs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(4143699003)(11063799006)(56012099006)(6133799003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K0xmczZHTXpXdnlxMjcySjYrdDRLekNnNllaWFVmZElmZm9WczZ2OU1DcWIz?=
 =?utf-8?B?Y0tlN3V6RHZuN29jeDAyaktWWmVHaXZSZFd6MWFwY0IyV0hCd255TkpYeFlW?=
 =?utf-8?B?SkI4NHcyNGY1cDdrNTBIRy9NNWJ5ODdmSGtXcWRJbFEyYUZxUlNyWENLd2Qx?=
 =?utf-8?B?VEdmOWxoYkZoVVp2NEcrb2RXQ0JNUmRBYk5vd2FGYmdqa1dkWFhQc2NtbjRr?=
 =?utf-8?B?MnR3WkpOUU5IK0trU0ZZZ29OcFV0eXFSMHk2KzRsVS96QVo3blF4Vm5QWlB0?=
 =?utf-8?B?b0hFb0xORHRHMWJ4NkI1cnVxTDZYVWVzazg1V0JqUHRUYXhXTzRZQ3BSMlNY?=
 =?utf-8?B?a0YzRnlhU2FseXRYUnU4WC9GbkE3VTYrUXowWTVGM280cFpFdzJpNnJ5dTB4?=
 =?utf-8?B?THJtVjNGRzFDa0ZRNk8wVWJSSnUxbllkT1RuTU9TcmJkYmtRTjFsTm5WWmsz?=
 =?utf-8?B?UkJCQi9BblcyVHQrVExzbFU2ajgzYndZVXI0bjZOMElmQm1TTGNzNVFvbkI3?=
 =?utf-8?B?RXY4YzNVT3dqc0huZzVMMmhmc1BPMHNlUWJpTkw4U0FMZFJ4ZmdId0RTQVBF?=
 =?utf-8?B?RmwwSWdXbmprS21xcTZ6RlhkbzRaZHFqRjlmYlV4YkNkWmQ3emdnT09yNTJm?=
 =?utf-8?B?QTFlRE0vb1BZVWFjQnFkZjR6NVhxcnJUSlVCQ0JLVGM4UkFuWmJ0V0JrZVZ1?=
 =?utf-8?B?bjkwdXhiUm5nZnV1dmQwM0ZucGpKcFN4Njg1WjFhb0h2RlFyakFtRWphaCs3?=
 =?utf-8?B?NzhLY3lXK2JkMmRRYUpPN2JJRmJzMDYybE43K1lnNXdVTy9qaGlMcERBNi9N?=
 =?utf-8?B?M1IxVzBpY2FWSk9CM1VRdWpaT0ZHV1ZjWUdMWWl6SmVURHR6V3cvMHV0VXZ3?=
 =?utf-8?B?NmVPRHJyVWoxL0c5YzlMZWk4T1prRDN1QWlNVFN0NXd2MmRFeit1d1RqZGg1?=
 =?utf-8?B?ZXBIbUdkYW9VWEY0M3ZFcm12ZDRkMWVvcUsraWtWWHJiTlNlOWxKeHVaWVRi?=
 =?utf-8?B?M0MyUWVWMEFHTDJPbHh5eTFocVdXK2x3NVRKZVhHZndvM2xScUZ5V2JEcVZH?=
 =?utf-8?B?ME5rVmdjcHVoWGkxZTJVTC9reFVodUY3cGpGMGhqQTV3dFl6VFNLZXB2bmRa?=
 =?utf-8?B?elBsT2FPSW9EWEpzN0xSK3lkMzFQaG5QaGRzak5aUVdoWHVvd0QvUGtaNkRS?=
 =?utf-8?B?MHp5WHd5MlZGY0lETHk0T3U4ckRmZFBDaFBmL2RqWDM1TTlnSmR0azFJTjZF?=
 =?utf-8?B?L1hwdXF4K2lMSTd4d254UUxmVjdJOUFTbnB6TEU3ckxEMWlzNGREcGFzRk9o?=
 =?utf-8?B?OXVJUjlMNWhlVnUvWmRQclVHdkNxeFV3RE5wZXFCSEdvR2pZblpram4zOXJa?=
 =?utf-8?B?eFVIT0ZVT0ZReDRHY2RtejFqaERhVlBWTEkyUWRvUng2RGpwdTRuVEhMSktr?=
 =?utf-8?B?dExaOWNnRy94eGhFbExPNzc5RC9RQU5DcXBkYkJadlBzMVFOZ1Q5c2w4dTBq?=
 =?utf-8?B?cnhEN2hCZVVOWWxtRXBRcjdwVzBieURMenhFS01ISkdtOTlKa2QrejI4cjhF?=
 =?utf-8?B?K0ZlajJ4NmFUa2dWNnRUTldNenk2OE5PeWdza0dRTU4wN2JtWHl6cFcxa3pM?=
 =?utf-8?B?RG9qSVk5TnlYMkQvUEZlWkVYUEg4NVp5clQ5TzdqTjBLbkZ1dkI1am5GS0ZN?=
 =?utf-8?B?bjFZTHlkTkdENGZzMVlsRGVidG9LSUtMRUZqWVNhbktURE9OVzk5aE5SVWdP?=
 =?utf-8?B?SWtmaEZrRWM1MVlBdFpRQkZvOStuWjVnb2xVWS85bGZaTTNFWmZjbUl3ekpt?=
 =?utf-8?B?d3BYMS9nMU4rNjJEaDJvYmhXUkhCTUdkZXl1RlNvRnhRZXFvNmhSd2IxNER5?=
 =?utf-8?B?S2daMjRzcW81OVVFcFNsbEJodXFjeGkrQzRzWk1zbEpZc1U0cG1VdFNheE8y?=
 =?utf-8?B?alU0dnRGcGFqRDlVLzJKN0VETDBDTGcydlRqT3BBTmtoc0pTckVQUGRRT2dE?=
 =?utf-8?B?S2dDdkhoQnlVd1Jxd0RPRmNzTGlTTHNVZUdJQS92M1pRd1FHcWRXWCtPMnFB?=
 =?utf-8?B?TUFrYmZCRGszZ1pTNkN1WW44WUdDTDhIK2lGVGVWOWRVOW1LQ01BRGIrTVRV?=
 =?utf-8?B?Vk5TTG9VTmYxTnJ5Umt2T1RqZ3dkemMzRHpLMVh5RkE4cGIzYzk1ak56UEd1?=
 =?utf-8?B?WDBsTWNkOVlTZE9sR1BCRlBvb0pPU29sTCttWHhtYSs1VWp3VFUxY3lEdkRV?=
 =?utf-8?B?T0xLd1h0VE5pQms0bGVONEJFaGJPTjU3V0s2VmFwMklBTTVwNHVrNkNzWGU5?=
 =?utf-8?Q?TusCrBmJCRd/Uby/6z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4d318f3-3f59-47b3-ee27-08df23cfbe80
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 17:32:07.2938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3C2kKflu+Br+rywYGO8h8hn0jGnFEIOgOOx+YIrWmLzXe2hz/xE5AvMtva4oIGVzIo7+OWuWXlzXDBD4ukBtcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6309

On 10/6/26 11:41, Pratik R. Sampat wrote:
> Hi Tom,
> 
> Thanks for the review!
> 
> On 10/6/26 11:10 AM, Tom Lendacky wrote:
>> On 10/5/26 11:15, Pratik R. Sampat wrote:
>>> Implement SNP live firmware update using the DOWNLOAD_FIRMWARE_EX
>>> command.
>>>
>>> DOWNLOAD_FIRMWARE_EX requires the legacy SEV platform to be UNINIT. If
>>> it is WORKING then legacy guests are running and the update is refused
>>> as busy. If it is INIT, shut it down, release the buffers the firmware
>>> owns across that shutdown, run the update, and bring the platform back
>>> up afterwards. SNP is never taken down, so SNP guests are unaffected.
>>>
>>> To test run the following with your sbin file in FW:
>>>
>>> echo 1 > /sys/class/firmware/sev/loading
>>> cat <firmware.sbin> > /sys/class/firmware/sev/data
>>> echo 0 > /sys/class/firmware/sev/loading
>>>
>>> The COMMIT bit is left clear, so the image is only loaded provisionally
>>> and the admin decides when to make it permanent with ioctl(/dev/sev,
>>> SNP_COMMIT). To roll back, do not commit and upload the previous image
>>> the same way.
>>>
>>> Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
>>> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
>>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>

>>>  #ifdef CONFIG_FW_UPLOAD
>>> +/* Largest image the firmware accepts, anything above is rejected */
>>
>> I may have missed it, but I don't see anything in the SNP ABI spec that
>> says the limit is 512K. If that doesn't have a limit how did we arrive
>> at 512K?
>>
> 
> The ABI spec doesn't mention it, but the firmware had this limit hard-coded.
> This can potentially change without notice to the ABI. However, I did want a
> sanity check in the OS and that's why had it in.
> 
> I can drop it and let the firmware fail if the image is too large.

The memory holding the firmware on the call to the ASP has to be
contiguous, so you're likely to fail on the alloc_pages() if the image
is too large. Up to you if you want to keep it.
> 
>>> +#define SEV_FW_IMAGE_MAX_SIZE	SZ_512K
>>> +

>>> +
>>> +	__sev_release_firmware_buffers(false);
>>
>> Do the buffers have to be released? If so, why? I think you can keep the
>> allocations. During platform initialization the buffers will be
>> detected. Is there a shutdown path where they might not get freed?
>>
> 
> Shantanu hit this on Milan with an earlier version of the series that kept the
> buffers across the update [1]. After DOWNLOAD_FIRMWARE_EX the new firmware
> rejected INIT_EX with SEV_RET_INVALID_PAGE_STATE (0x1A), because sev_es_tmr and
> sev_init_ex_buffer were still in the firmware state left over from the previous
> image's INIT. Freeing them, and letting re-init allocate fresh ones, fixed it,
> which is where this call came from.
> 
> However, a fresh allocation with SNP initialized just goes through
> rmp_mark_pages_firmware(), so my understanding of what the new firmware needs
> is the reclaim -> make shared -> mark firmware cycle, not necessarily new
> memory.
> 
> Freeing seemed like the easiest option, but if you prefer, just cycling them
> back should be able to achieve the same effect, I believe.
> 
> [1] https://lore.kernel.org/all/20260831204757.436751-1-shansinha@google.com/

Sounds like some good info to have as a comment above the call then.

Thanks,
Tom

