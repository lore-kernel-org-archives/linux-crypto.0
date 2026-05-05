Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012058.outbound.protection.outlook.com [40.107.209.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CF91D9A5F;
	Tue,  5 May 2026 14:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777991560; cv=fail; b=hpq32wxxDdxQ2B8JPF7EhlqogUqZwApAw29yJ7rjLLNsk/oyv5C3LRn3bRnzcjciQOJ4QRro9eVnKT8VR2gmfeUvY8ZLZ3LG6ooiAlQDZD5DHHa81Tg83eUKjV6TtkvjRvkGDAoiCZs3Prcr5p8hF0tjMxFk+/2EpKI0rn75ff4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777991560; c=relaxed/simple;
	bh=GJWiTTIisFNnsgUTWRulgKnCJz02x218bYUa/6oGb+o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Qwi+mjqVyyHlqNu7PHw5nTHLqZT9rFIZxOUqW01oCl5pag6RUof0OIHanBHIJusdE/s/VkmB5hFUP699vXYvQXP5J02i0UI29OMXC3u/B7NDo/HtYm8j4pPPtjQ9W471gx1YVpWYnG2qUxRXeRGkbVAbnRPp+30FB1BwEQJ+9Zw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KXeHlkxI; arc=fail smtp.client-ip=40.107.209.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KXeHlkxI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K3W0vFcsbc2ovw03uy7FuorgfAPfGDgX2vOkmIrnqGy//GJ1ZrJkFpx+YTqloK7B5XhGTLOezkqMNiJkG+oEuVX/Qq/2zGLuZnI3OMIYVQE3bxJFVh5xyW+YH1cULLPUD8s9mbNhQ4nTVp4WpzOWaNFrvR2GEV32mCSH9iEH6Cw968sX8nd74MWEfFCyDwb+dBTJKvGPllGIo3TGKmcNJjSacA4mSjJZzmRwC83LZVDCE2xFXrFntomS/xoojyVWMCvuKEoeS5BXGkJ7l2kTqLhj1pmUR5y/EdNuNcpVIAgaIbdzLhLdy6csGLvG0lNrl+pJDI52SaU5v4WcdeAaMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzeYHYu7D7Ri5kxIcvEVyidBoj1BvkWck/gv+ksJYXk=;
 b=Pwr24Snc6qaGaoSIYd9URXrYTD2TbS1EyZpoBeWTYXnpFRWaBHALGxu3NtWnpOp6eInsq2zVL85NRQ9+RsJ0/La6q4TdHqPIqR51+dMVt9WxUSImdip/LMWKUFqPXmHeBFFCxUaASvJFkikuRhRPBw4bs8k4sRabTneYjKn5flWABpFrdQczlh0Jj+OQXAomzOZI+9fgVPdCMXrzRisvCCnyKvgkpsJ5grPgXRrTERKCEX48/LSpUIrwd/IoLHWuhVXF1CUV9Vee51MMs+rbIW3dDq6GqQkaAEZ77VDSOvwauqBiqg7zH9eODcJc/53tDbKdkEkxsg7HwxWF1YCMtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzeYHYu7D7Ri5kxIcvEVyidBoj1BvkWck/gv+ksJYXk=;
 b=KXeHlkxIjqCEYPKxZxlulOjWsh/y3yXW6U5aRXzvQ15NoCXfjl4NffE0TBEzK54E0mDDHM7nVTKuNH3m2JiqDcFC4Zpbn7UZhxBJpnSG39tv3QTIUzWQM23ZZsinF/NiPyr79X6Dpj4Ae84KeVSdndhKpRHCmSOu677TDf+BAbA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV2PR12MB5990.namprd12.prod.outlook.com (2603:10b6:408:170::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 14:32:31 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 14:32:31 +0000
Message-ID: <d8eb94fe-c2de-4d4f-939e-d09673890965@amd.com>
Date: Tue, 5 May 2026 09:32:28 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp: Treat zero-length cert chain as query for
 blob lengths
To: Sean Christopherson <seanjc@google.com>,
 Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260504222812.2339526-1-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260504222812.2339526-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:610:b0::7) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV2PR12MB5990:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b16299f-9c1d-45cd-8799-08deaab3237c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	QdAX+K6CuhDkdTesWOGVrOaoLjwuUTj3DTMrYxhtQZAgYl6RVPC18X/U9pCGsUxKNbVFQ/pM1+llJ9FWcpDuxPpDwKphR/c3ssPje8qrCt2aMPKbBKK70GbPEmbX4Eh0mU8UCdXVEadADksHg4T5cxnPJGDBoyrABdYwdeJ67s5vkMGinqnhs7LTmFDp2mY1mOYXFSh2YSNqaVFvgam+z16M/FtgmEVEAuR9ybRwoLYZYI1+oyM1PxWZ/vtOnQ6FggCJLtz5RrfCKuqfHutauuyQPJL5wrhbnNHxArttqJU9Cl39I/sVaAA8ljswGVjcHM4wO+C8rRTvv1edcUklAMZpER/yWrTsGmPTzR5iK9iUsR+QQ9Z9PDS7wZxoupbHBRGWaVKR+EmyZ2nbiiJhsMvz5NF0dohqz1CC8sqbYEA5txE60GdAsn+6dQAdlme4YByAdPUJPmS+Eejp3uony7uRiMzdgb6jHCVcIcFmozSlmXGorkW3hWY14y8kmiKzcrGTXUYOu/aGcoCwG4iqkYwjOFPy8YllimoJE5kUf2VlVpIeUL4oCom5kYuNHdCv9/+FtF2CCag810NJ43awfykc6+xJ6u2/nJKqKUrFYh9BzYbzAeQqqza5C4vYZILVg6LbUbDb6kArySog7ejTmMCGQepO84EdLu9t7wJBecYEM2yOzZNLIOZ4/VRekgzg
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bHdPdVJVTVNGVjRzby83Z2ZhdEVoVFFSNHdvQmw5MnBvaGYyUlRwTTBGS2hU?=
 =?utf-8?B?cU9qeTJpaDRBdGVTdE5ySlB6VCtKR29WcVdDbTFpakF1c2FaLytBSXdhM1NH?=
 =?utf-8?B?QTVOME9FSFdQQTJSTHBPL0pTRC9YZkJrMzB2MVJFZGJxaHlMLytKU080b3ph?=
 =?utf-8?B?c3dFa3AyUlRCc3A1cUJvZlBET3JrRXl6dEptcmhOOHN3bnRhaWJ4ZCtBRmNN?=
 =?utf-8?B?Y1FSRGFvUnIzUm5keHY4R3NTTWtaNzR1TnM5dDZsSldQbHlENU5yQlYzVUZr?=
 =?utf-8?B?d21XMXd1ZzNEcGQxNlozdUhxUllNVm8vQmZhWEJSTHZyMHgxWWkxYSt3VzBF?=
 =?utf-8?B?ZVpzMFphQ1lyNEduay9DWnQ0SFRIQy95bTBWRDA5bkhWN2lJNDVKVW1LbUhS?=
 =?utf-8?B?UHE1b2VmTEJnR29BeFFGdFNCNUlGRVdzdEt3NWsyYkNBei9aK0JxOFNFRmVv?=
 =?utf-8?B?b2Z4d1BTVkF3YkZEa3F0ZkFWYjJSZ3ZabXl1Zm9qUy9kZ2FtRUJpSGFjaFJr?=
 =?utf-8?B?MXVCUWl2UlNWODZRbzhSckZQUGxaaDFGbVBhTisyeU5PNDNscVFlblNRSGhq?=
 =?utf-8?B?VW5YRWJPNzNZSjR2U1YrbnJMVzBRM3lYWDZEVW9wUEkrdC82SjZWbVJWMURR?=
 =?utf-8?B?WnZvSndjcE5rdlNEVXN0cGJ3Q0E2OCs0ZzBFNmw3dGVMOEVrc05KN29mSi9W?=
 =?utf-8?B?NkVHRVk0OWNJSGo4WlFQOTJpSWU5N0RMUEx4NDBNVWs3RTNaSEpUYjdvNzNK?=
 =?utf-8?B?R2Z4U0xJOU55anFzeVcvVVNjWkJHaWJWRllXODY3R1RYYXhLKzdnZDdQV0FU?=
 =?utf-8?B?Z1psUHZ0SGFZc0Z4b0dwQjhNdUtFL2gzSWU3a2lqYTQwU3U5SGhQK1lHTFhH?=
 =?utf-8?B?UXVBYmhSUjJmSWZaQW1DcXF3SGpPRElBYjdCckRyUWp2eWpSWDkvaDd4Ynl5?=
 =?utf-8?B?WjVKcE8xT3VBbkRvVmVLOXhKb2JjMDRmaHU3TXM1L1N6SGt0OTlpYU1EWjRR?=
 =?utf-8?B?V3FMV3FSVzZNd3NXcldkL3NKc0FqamVXUzljMFJNaGRycXIxbVlQOUdoSmhp?=
 =?utf-8?B?WFBuR1FncGFzVElXMTBINDNITjdDYzEySTBRblRna1lFMDQ0L0hkdGMwaHIr?=
 =?utf-8?B?QnNFK0FjeE1ESmdyYjdKNkxwZ3dDWmJvcVl3dWxicUlMbm9sb3dZT3pjT3B2?=
 =?utf-8?B?VFpUdWJrUVhRWjFCUmtwd1ZEemdXdWlxVVRZc2NCeHd0dDdISmFmZ0VPcUpR?=
 =?utf-8?B?SzN0TjF6QVFZbUJoWjB0cG5FN0VXaE01OVFTYkE2T1dHYmV6cU55TWRldEpX?=
 =?utf-8?B?cU1OelV1RDdLT0M4RTJFKzFtRVpNL1VnU3NKeEFrWWNianR2R3pNTkF4SitR?=
 =?utf-8?B?SjVBblRRTVVnQlNiTTFRRVAwU3BZckdmSHJGL3IwejRBRm54ZGdvSEd5dC82?=
 =?utf-8?B?SWxpRTlFaHNEZVgrS0JBeTRLVjB1WkZXdzVMOE1BOVdYbmoyZWdlWFVFa09t?=
 =?utf-8?B?WmRpeUJYZjVIUDZyaldScDNVcmY0a2pXK28wSlI5bmNtS2kxYzNMLzNJd1hk?=
 =?utf-8?B?cENyU3l5VkxCOVhVVlJoZXpwNTBkRllGZXdFQm8zdGZQamV4NzdsM0tiSEkx?=
 =?utf-8?B?bnNLZ1NQUTBlODJ2MXl0ZVBmc3lsRmZOSDJKckl1TTJ4K2RZZmQxMVA0cGF1?=
 =?utf-8?B?ek1VUlZiczQrTmhYU2JSbm9IUW5xR3ZQMytMeENSZWZ6K0xVUUc4cDJqYi9l?=
 =?utf-8?B?OEF1eHFQeEZBTWgzd1ZORlJldXJJSmdtTzRaSGZRcHBaNllEZnQvNm9Wb0VR?=
 =?utf-8?B?S1FQd3lDY1JzVFlTWWtPNWxzMWtQNjlGSDZlM0pBRE9uaFZuN21MQ1k3MCtT?=
 =?utf-8?B?V1dEU0d4V01BRjF6UmlSZ0I1K0RXSFB3MFVRV0NlUVhwdG81QmV2RUpIK0Zv?=
 =?utf-8?B?eGtSSEhNL2h0dGdObTNsZ25FL0EyNzVFMkR1dUp2Q0FVMGpodGF5YURveEk0?=
 =?utf-8?B?K3ExMk40QnZpNXhsVlZVNEFmWHRzVUxjcjlDZm9hVWhsSWlvMFE2a1IzV1NZ?=
 =?utf-8?B?a05qSjhtZm5kUG80SnNCTkFrSC9Fc3lOY0NFRGtDTWpJUkdKNENwOCtxNFB0?=
 =?utf-8?B?eCs3OUcxM2Jmei96cWJucmNKVkI4VjY1aFZVVy9hUlRzbGQzQitVc0szOEZY?=
 =?utf-8?B?NzAzTjZpcGg4bENEeis3ei9xcFVhVlE4aUF2a0oxRUJzM2NYSkF5WWJNN0lv?=
 =?utf-8?B?NllpT242V2l0c2dwYyttYVpFaTBYWDh0SENMSVlHRmx6MW02dHhpN1pFeWhR?=
 =?utf-8?B?Umc1ZDhNZHBxakFzYldHbXdYY3pHOFVyUTBWRUJYWmhQQ2VOZnFXUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b16299f-9c1d-45cd-8799-08deaab3237c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 14:32:30.9628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1CbFvaYob9CxJwxvcAWUyLr+2oqCyR+WT03z40WCSqfG+rUS7c4lJkRnxzcbOvuMBj7/HFmAXoCMf2Odd95xXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5990

On 5/4/26 17:28, Sean Christopherson wrote:
> When handling a PDH export, treat a zero-length userspace cert chain buffer
> as a request to query the length of the relevant blobs.  Failure to account
> for the zero-length buffer trips a BUG_ON() when running with
> CONFIG_DEBUG_VIRTUAL=y due to trying to get the physical address of the
> ZERO_SIZE_PTR (returned by kzalloc() on the bogus allocation).
> 
>    kernel BUG at arch/x86/mm/physaddr.c:28 !
>   Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>   CPU: 30 UID: 0 PID: 28580 Comm: syz.2.18 Kdump: loaded
>   Tainted: G        W           6.18.16-smp-DEV #1 NONE
>   Tainted: [W]=WARN
>   Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 12.62.0-0 11/19/2025
>    RIP: 0010:__phys_addr+0x16a/0x180 arch/x86/mm/physaddr.c:28
>   RSP: 0018:ffffc9008329fc80 EFLAGS: 00010293
>   RAX: ffffffff8179110a RBX: 0000778000000010 RCX: ffff8884e6992600
>   RDX: 0000000000000000 RSI: 0000000080000010 RDI: 0000778000000010
>   RBP: ffffc9008329fdf0 R08: 0000000000000dc0 R09: 00000000ffffffff
>   R10: dffffc0000000000 R11: fffffbfff126d297 R12: dffffc0000000000
>   R13: 1ffff92010653fc8 R14: 0000000080000010 R15: dffffc0000000000
>   FS:  0000555556bec9c0(0000) GS:ffff88aa4ce1c000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007fd3159e7000 CR3: 00000004fbc44000 CR4: 0000000000350ef0
>   Call Trace:
>    <TASK>
>     [<ffffffff853d3869>] sev_ioctl_do_pdh_export+0x559/0x7a0 drivers/crypto/ccp/sev-dev.c:2308
>     [<ffffffff853d1fdd>] sev_ioctl+0x2cd/0x480 drivers/crypto/ccp/sev-dev.c:2556
>     [<ffffffff82549ebc>] vfs_ioctl fs/ioctl.c:52 [inline]
>     [<ffffffff82549ebc>] __do_sys_ioctl fs/ioctl.c:598 [inline]
>     [<ffffffff82549ebc>] __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:584
>     [<ffffffff8630115f>] do_syscall_x64 arch/x86/entry/syscall_64.c:64 [inline]
>     [<ffffffff8630115f>] do_syscall_64+0x9f/0xf40 arch/x86/entry/syscall_64.c:98
>    [<ffffffff81000136>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
>   RIP: 0033:0x7fd3158eac39
>    </TASK>
> 
> Thankfully, the bug is benign outside of CONFIG_DEBUG_VIRTUAL=y as getting
> the physical address is just arithmetic, and the PSP errors out before
> trying to write to the garbage address (which it must, otherwise querying
> the blob lengths would clobber memory at pfn=0).
> 
> Fixes: 76a2b524a4b1 ("crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Heh, you beat me to it, I have the same patch ready to send out.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index d1e9e0ac63b6..ed3b8065f59b 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2301,7 +2301,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	/* Userspace wants to query the certificate length. */
>  	if (!input.pdh_cert_address ||
>  	    !input.pdh_cert_len ||
> -	    !input.cert_chain_address)
> +	    !input.cert_chain_address ||
> +	    !input.cert_chain_len)
>  		goto cmd;
>  
>  	/* Allocate a physically contiguous buffer to store the PDH blob. */
> 
> base-commit: 2d4aef3da2981e326a88f8b07249083150ae3ef3

