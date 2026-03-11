Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013039.outbound.protection.outlook.com [40.107.201.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2C929B200;
	Wed, 11 Mar 2026 21:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773265757; cv=fail; b=UtgHnepf03r9J0OELnIytHyZ3l4ejkoQE5RncilYO325KWFfFRyWCqApJYijRRZn6JBhUsf0z4dRUtBxtLyyAVzkOnvv1GP7hEbQKiABOUCM/R2ifexG4i0kA418BlUzvxn5wt+Gg/8Er3jXzNRsYoTGw74dJxub4DMtMIBIRBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773265757; c=relaxed/simple;
	bh=7fkyxSAMXK4e1xw7GQTpKPa6zT617z7mdihGUs1XpXw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nRAcWpAKHH9MZXVKMoOM6/cZJ5EDsf3aMfXm5Wcw/rquFJwCRVmS80+fsDL5C44lpLOOzm6t9hS4yS51aYFawmwG7yS8RuElFHlDhYypjuKOX5qfB4/CbpeIiRJqoE66DoiDpO8Kf48IPGwxZmQ3Pl0RCRz5g5S9yjvO/0Y45Is=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aW4+Z8It; arc=fail smtp.client-ip=40.107.201.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aW4+Z8It"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LtXrnIl1vxCBFm0/fD++YYa7rSZShhUVxaAc6Bh4LBUiDMlbdCSOnv3hzSgOIjXa9b6O6FB7E7SrUJRfV2qqENKpg5/cRsgwCohUOoVP8gQgac2lOAHSBLPgdWOu3B5K0Hh2AeFS+HlSaGFMXPijkO4Ur8gAgaitHgqE+up+4nQP2Bfbz9exJKFgDn7EL0y+Fb2dfp1jOGSBABrxHRmBNG0xcwRFCMxXg3SulrAO4buk1iSpdXsYY7+oFe/Y2rQQ2k6nLv0dcPo+U6qOmuW9Sw/W7sYrfqa3IY+o/zH1SuPPV4Qydk45c4ff73HXuwexsHl50OprerbAjd5oNqfOoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T0E2UwrWQQSaiVtH2GSHWZZoHkEj2b/5HtNo0M/uZps=;
 b=jI0s9+HM8udkfnr8eJUqgyj0IBuzpIeou80n0OMw/S9nLO9SOwXD+ccMxVaVaopUYAQ2tzqPD3eyV1lZUHltnJT4ka2kPzLHmBreU2p6uJ7c+uNJrjgjzThZJDV0TIDOneXIIBvabuDNlz3eaVBT+SsMI9a/kmQpssmoSfUuaeKvJ5hqPVPsTfFl68kLA1ED6uGA02nCkorKy5wltiVyPRBlrOmTYaDDqkc98XIFC0ev2Kab5RbVtz6kYxwQ3t3KShcZxTceQVBmWZdKO8AuGVycfGNUbF8iCPeFd1OZpMXNamZTVWcPl2qWZ1gPEOH97zICQsq8xWYSBMMYbafB/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T0E2UwrWQQSaiVtH2GSHWZZoHkEj2b/5HtNo0M/uZps=;
 b=aW4+Z8It7otDRNspwSv4O6+UswQXqCWw/PEL2DmUm0Qs4FtyWbz5/zZbYwu96jiF8sztVY/JC0VNin2SusaXZEE3jhNmtqAJVIrslcbxOvSfH5dwPcwmCH3i1r1ztfL7Tn/8NDsnGEkhYmZL2iZYSGMcgYsNuFXf6V0lnhQMf54=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH7PR12MB8121.namprd12.prod.outlook.com (2603:10b6:510:2b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Wed, 11 Mar
 2026 21:49:08 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 21:49:08 +0000
Message-ID: <75cd28a5-fb51-47ae-97c7-191fe9a6e045@amd.com>
Date: Wed, 11 Mar 2026 16:49:03 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] KVM: guest_memfd: Add cleanup interface for guest
 teardown
To: Ackerley Tng <ackerleytng@google.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1772486459.git.ashish.kalra@amd.com>
 <ce99dc548000b5a1f4486cdd3efe510b3874684b.1772486459.git.ashish.kalra@amd.com>
 <CAEvNRgFCTNr=LUR_RM7+A4z+qHCWBZOYKe_Cbokwx0UsCtzaVw@mail.gmail.com>
 <98313534-af6a-4c00-a016-9d9010f145da@amd.com>
 <CAEvNRgGdaA1ynF8jxQDPh9U0U8Q0RkE0=KJx4FNrh_=+dVRaLQ@mail.gmail.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAEvNRgGdaA1ynF8jxQDPh9U0U8Q0RkE0=KJx4FNrh_=+dVRaLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH3P221CA0019.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1e7::18) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH7PR12MB8121:EE_
X-MS-Office365-Filtering-Correlation-Id: ddb331d8-134b-4946-8aa5-08de7fb805a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wmZH/nCazV/l+o62Ic155IJcG1kFo1ej0DPBWjD7zuQsJGkJcImk5OcC7E8Wf8+haajnsyFug0MzXWegA0+65w6Omeo3sPjEy2BH/QfUuKccoweD4J2NLsbtQZbDZJn0wwuCmEGKfSbE0uw2JBEjB12R4AOm2gIAqNbcOMq1xA1HxnGidqdxHIpZpyz/cnBUnL4odakkcwX9g+KXyJukknA+nBYWAULdI5+Ssq5W3jLSGZ7Ai4iLnH4y33RX3AGkRUx4hy8vT1iW/OArK7Mo4z3hri0C50gFafy6jDYt6yXz6AuDFuUqB4jeLfp2z2AnJKgc1FglsgkNkggB0EkMzFU7Fes1NGNq4pHHehMtcdBLicDE70NRnjjsB3kqduTCTYuBSxYQhloB2p5udZcu/akhb4KyRwR+nXwrTYglMh08+DPeb7UY0p/DJSg7XRwKzo6hhwMT9e2O4l9SIszv6/3Yyf5m+ooYzhCOdjf5vVRsDkvRxet5U/ISwgnC39aFtxw33GXEWh66fc/3a+HdHmAIDjpPErp0MsluRUyGnEB/1ML5T6gxg82DhKKmAwM1tsjjNSgvJ7tkfunbfjc53m58ijKRbfhgH/97f32k0BU5tGqt6CKMFWGuDTktT/kG0DifMl0P4ObTqrTaY4d7zS1MUWSa6HkTe9ayEUzZs/bKHgnhFE3vCdRbwEnRq8x1XMp5cpNjE3ff4BDB23XyUlQzayxI1MRy922ccXApRc3BOxDued0G94Px9OW8AtbHhuqypdvSMVNGcXKphJGoTw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eTYxN1hySmdWbWY4bDcxc3FsTVU3WEZXQVFDZnQxbTQycUhXZTJ2R2tXYU1v?=
 =?utf-8?B?ZmY1YkJGOVZ5NDluTlN2Z1FrMmVwMy9BMFBFQ3JMWVQ4c0Y0bSticCtJdzdt?=
 =?utf-8?B?Ymk1bjNHM1A3cDRyK0krMWxDOVJBNWNKdDZtWjUySUJwQWNzeTFlNFRySGh4?=
 =?utf-8?B?QWNwb1ZaT3JnVXFGelc5cDhob01hcVdQZkVWbVliTmtLTFJTQkxDNThHTGZ6?=
 =?utf-8?B?bDlqMDN3WkJPUVlKakIwb2pPNlptZjBBSkFhOGhuaUZRbDV4UXBGc1hKbHBm?=
 =?utf-8?B?VTB6bm0zYXRYWmh0WDlBbnh4TFM2TXZsUHhPbVdqTjBsamliQWdXNTJiWmth?=
 =?utf-8?B?OE83U0dwclhxUU1tZUpSSmE5dW1reTkvYVkybEhESm5ndURsUkJacG9Zajgv?=
 =?utf-8?B?WDQydFJRQW9VVk5KeVJScStTcXZTY1YzdjAwR1puRU1lUlNPLzZmb2U2OG82?=
 =?utf-8?B?VU5mWHVUSUdEd2t1RUdPQmxYM1RGWjd1TmpCaFc3bjR5aTkwNWNUWDgvaWpB?=
 =?utf-8?B?RmRRRnhQRXJ0a3BNb2xqVUhHRUpFVUZiUjFFZ1JnLzJBS3RvSDhlSjdkTy9I?=
 =?utf-8?B?SmZleFpSQndlQ3ZvNHRQcGJrWExxNUNrcVBpZXhLUUgwbG5NNDNQOSswTFla?=
 =?utf-8?B?U1F3NzUwcE9kdE95RndsUC9VdWg5ZUx0UHc2MElXaTVRWjF6dFpMTkNXSysv?=
 =?utf-8?B?alRURkJzWXg4bElCdmhpaDEzUlBidkQ3OFI1Vmx1bXF0ZWVLRmpTU0M0R2w2?=
 =?utf-8?B?d21FL1Nzd3l6QWFtMEtUUEFEUkhFNVlBL0RBZklPcG81ZCtXSnJPSU1Idks2?=
 =?utf-8?B?NytWUmU4ZEJzZmdNc2FOU1hVOThhdmp4dnNGRjRIblJ0VzNzeW5yekZpYlh4?=
 =?utf-8?B?b2g1bWdqTUQxNVREUGRNNU1qQUxYbWZGWDNJTUZEQm9ZNklxNGNYaXdkWUh2?=
 =?utf-8?B?cHZYUWs2UXM4Z1g4ajhtakZpVHhmVjdxSHJ1WTVCWDByMW41R1dJcmdDS3Y5?=
 =?utf-8?B?a2hkc2pKWjFFZTFqWU9HWjdHdE9UUEI1VXo4WHV4SldjeEJPQldmOFM1T2hE?=
 =?utf-8?B?YW1XUnAwQTExNkV5Sm1iSzd4em5QeFM2c2pmK0x2bnBxNU5TT3JlQ0NYcnUw?=
 =?utf-8?B?bUhnbmZpODdOR3BXeTBsaU9lR3RiWHh0cnZDL1E1a0JZa2NJNU0rZjV4S3R4?=
 =?utf-8?B?WmduMlBqdVg0TzZncFlSc2xpVlhVRjIzL0JicjFPVVlmdWNIeThERnU1T0pQ?=
 =?utf-8?B?d2tWd3o5WHFjTnZQNnpwNUJUWTNJbWsvZWExeXBUVnI2djl6cFR3eUQ5bUIx?=
 =?utf-8?B?WUw3YzJEblpXZDlsRTVWR1cwYStpSHcxTUhGV2xHZTBPZVIyUDExUzlQSy83?=
 =?utf-8?B?Y2NwTjFqc0wrRjdXMDFRUFdEeVJISmd5aVdxcTc0bk5TNGthQ1U0THFsdTFz?=
 =?utf-8?B?Q3B3SjYvZkgxc29YRUcwbS90M0JyYi9jRjVnL3pTVXNJV09TTVZGVUJyVlBm?=
 =?utf-8?B?Qm9VQTd5bTlUQnplSHJXQ1hjaXpHb3FscGxScHVJYnFlT3ZVczY2NVQwTkF6?=
 =?utf-8?B?dDc2SDlaSVpJZW5yQWpYYXpwT0RsajVqQzJRUWZZN2F1RlVJcmlNTjlEQlJr?=
 =?utf-8?B?dCtQcFdIODVqekdhNzR4MjVCSHFVQ0ZrNmI3bWxGM1hwcytGR01wTEo4US9L?=
 =?utf-8?B?dEV4YzRFVUdXVjRmT0psSVYrNVp2Q1hxcHFFS29nbnFZL3JGV1FuNjNkbUkv?=
 =?utf-8?B?UlRjZ01uSHlseE4zTjFNSlJ3cm1FZ05zSWUxZHliWE1OeTVjc2xUZC9zNUdy?=
 =?utf-8?B?TFErNG80VDJaalFBUjEwTjdtcmpPb0hldzhkbzYzQThCd0tMK2ZSQ0JWVGJZ?=
 =?utf-8?B?aVRUNWJuS2t4UkVvaUptUXcvY3hZdkkzMjBEaUpVWlBSRmZoYVhuZ2NXY001?=
 =?utf-8?B?NHRIcUVYNkQ3WXUxVUZWanBzRFhZY1ppV3dsM0tvSXlJeTVncXpZR1NaUkty?=
 =?utf-8?B?cmF0aEd1NWRzSXIzWHVsUGFiMXFIeUNRenJLWWpPa3JSZlZ3amRaaDR0elIx?=
 =?utf-8?B?S1FaNS9ITkM1b05CU0s0d1FHSU9EaWFIOG1CYUZXekFKZEZ0ZGsxV1YxRmtR?=
 =?utf-8?B?SDdjYS9GRFNtSU9mZlVJQTVTUEVpYms1VUZLVlgxeFBtWkdvQjJOS1lqY1N6?=
 =?utf-8?B?SFpJYkVUYlZPQVZ4YnJpa000d1l3UmZkcTgxTGd0UG9Qdisrb1c1eWFCWm5F?=
 =?utf-8?B?OU15MlVScUI0bU90U3BtYUlnOFRmc2x3Y2VEWmxhKzU4Zzl5ek90VXpnWE9z?=
 =?utf-8?B?ZUI2QWpxYXA1ZGV3eE12cVc4Q2VhSHoyeFJBVDY5dGVKK0FTWngzQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddb331d8-134b-4946-8aa5-08de7fb805a6
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 21:49:08.0741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rrzWmzgvv3an99z6itaDkUGBIhotAP04UhtDynMhSaYvJyDJ2v+9KOR9/YXztuot6d2XkjiVNGlx2mUfKsp7Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8121

Hello Ackerley,

On 3/11/2026 1:00 AM, Ackerley Tng wrote:
> "Kalra, Ashish" <ashish.kalra@amd.com> writes:
> 
>> Hello Ackerley,
>>
>> On 3/9/2026 4:01 AM, Ackerley Tng wrote:
>>> Ashish Kalra <Ashish.Kalra@amd.com> writes:
>>>
>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>
>>>> Introduce kvm_arch_gmem_cleanup() to perform architecture-specific
>>>> cleanups when the last file descriptor for the guest_memfd inode is
>>>> closed. This typically occurs during guest shutdown and termination
>>>> and allows for final resource release.
>>>>
>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>> ---
>>>>
>>>> [...snip...]
>>>>
>>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>>> index 017d84a7adf3..2724dd1099f2 100644
>>>> --- a/virt/kvm/guest_memfd.c
>>>> +++ b/virt/kvm/guest_memfd.c
>>>> @@ -955,6 +955,14 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
>>>>
>>>>  static void kvm_gmem_free_inode(struct inode *inode)
>>>>  {
>>>> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CLEANUP
>>>> +	/*
>>>> +	 * Finalize cleanup for the inode once the last guest_memfd
>>>> +	 * reference is released. This usually occurs after guest
>>>> +	 * termination.
>>>> +	 */
>>>> +	kvm_arch_gmem_cleanup();
>>>> +#endif
>>>
>>> Folks have already talked about the performance implications of doing
>>> the scan and rmpopt, I just want to call out that one VM could have more
>>> than one associated guest_memfd too.
>>
>> Yes, i have observed that kvm_gmem_free_inode() gets invoked multiple times
>> at SNP guest shutdown.
>>
>> And the same is true for kvm_gmem_destroy_inode() too.
>>
>>>
>>> I think the cleanup function should be thought of as cleanup for the
>>> inode (even if it doesn't take an inode pointer since it's not (yet)
>>> required).
>>>
>>> So, the gmem cleanup function should not handle deduplicating cleanup
>>> requests, but the arch function should, if the cleanup needs
>>> deduplicating.
>>
>> I agree, the arch function will have to handle deduplicating,  and for that
>> the arch function will probably need to be passed the inode pointer,
>> to have a parameter to assist with deduplicating.
>>
> 
> By the time .free_folio() is called, folio->mapping may no longer exist,
> so if we definitely want to deduplicate using something in the inode,
> .free_folio() won't be the right callback to use.

Ok.

> 
> I was thinking that deduplicating using something in the folio would be
> better. Can rmpopt take a PFN range? Then there's really no
> deduplication, the cleanup would be nicely narrowed to whatever was just
> freed. Perhaps the PFNs could be aligned up to the nearest PMD or PUD
> size for rmpopt to do the right thing.
> 

It will really be ideal if the cleanup can be narrowed down to whatever was just freed.

RMPOPT takes a SPA which is GB aligned, so if the PFNs are aligned to the nearest
PUD, then RMPOPT will be perfectly aligned to optimize the 1G regions that contained
memory associated with that guest being freed.

This will also be the most optimal way to use RMPOPT, as we only optimize the 1G regions
that contains memory associated with that guest, which should be much smaller than
optimizing the whole 2TB RAM. 

And that's what the actual plans for RMPOPT are.

We had planned for a phased RMPOPT implementation. 

In the first phase, we were planning to do RMP re-optimizations for entire 2TB
RAM. 

Once 1GB hugetlb guest_memfd support is merged, we planned to support re-enabling
RMPOPT optimizations during 1GB page cleanup as a follow-on series.

But i believe this support is dependent on:
1). in-place conversion for guest_memfd, 
2). 2M hugepage support for guest_memfd.

Another alternative we are considering is implementing a bitmap of 1GB regions in guest_memfd
that tracks when they are being freed and then issue RMPOPT on those 1GB regions.
(and this will be independent of the 1GB hugeTLB support for guest_memfd).

> Or perhaps some more tracking is required to check that the entire
> aligned range is freed before doing the rmpopt.
> 
> I need to implement some of this tracking for guest_memfd HugeTLB
> support, so if the tracking is useful for you, we should discuss!

Yes, this tracking is going to be useful for RMPOPT. 

Is this going to be implemented as part of the 1GB hugeTLB support for guest_memfd ?

> 
>>>
>>> Also, .free_inode() is called through RCU, so it could be called after
>>> some delay. Could it be possible that .free_inode() ends up being called
>>> way after the associated VM gets torn down, or after KVM the module gets
>>> unloaded?  Does rmpopt still work fine if KVM the module got unloaded?
>>
>> Yes, .free_inode() can probably get called after the associated VM has
>> been torn down and which should be fine for issuing RMPOPT to do
>> RMP re-optimizations.
>>
>> As far as about KVM module getting unloaded, then as part of the forthcoming patch-series,
>> during KVM module unload, X86_SNP_SHUTDOWN would be issued which means SNP would get
>> disabled and therefore, RMP checks are also disabled.
>>
>> And as CC_ATTR_HOST_SEV_SNP would then be cleared, therefore, snp_perform_rmp_optimization()
>> will simply return.
>>
> 
> I think relying on CC_ATTR_HOST_SEV_SNP to skip optimization should be
> best as long as there are no races (like the .free_inode() will
> definitely not try to optimize when SNP is half shut down or something
> like that.

Yeah, i will have to take a look at such races.

> 
>> Another option is to add a new guest_memfd superblock operation, and then do the
>> final guest_memfd cleanup using the .evict_inode() callback. This will then ensure
>> that the cleanup is not called through RCU and avoids any kind of delays, as following:
>>
>> +static void kvm_gmem_evict_inode(struct inode *inode)
>> +{
>> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CLEANUP
>> +        kvm_arch_gmem_cleanup();
>> +#endif
>> +       truncate_inode_pages_final(&inode->i_data);
>> +       clear_inode(inode);
>> +}
>> +
>>
> 
> At the point of .evict_inode(), CoCo-shared guest_memfd pages could
> still be pinned (for DMA or whatever, accidentally or maliciously), can
> rmpopt work on shared pages that might still be used for DMA?
> 

Yes, RMPOPT should be safe to work here, as it checks the RMP table for assigned
or private pages in the 1GB range specified. For a 1GB range full of shared pages,
it will mark that range to be RMP optimized.

If all RMPUPDATE's for all private->shared pages conversion have been completed at
the point of .evict_inode(), then RMPOPT re-optimizations will work nicely.

> .invalidate_folio() and .free_folio() both actually happen on removal
> from guest_memfd ownership, though both are not exactly when the folio
> is completely not in use.
> 
> Is the best time to optimize when the pages are truly freed?
> 

Yes.

Thanks,
Ashish

>> @@ -971,6 +979,7 @@ static const struct super_operations kvm_gmem_super_operations = {
>>         .alloc_inode    = kvm_gmem_alloc_inode,
>>         .destroy_inode  = kvm_gmem_destroy_inode,
>>         .free_inode     = kvm_gmem_free_inode,
>> +       .evict_inode    = kvm_gmem_evict_inode,
>>  };
>>
>>
>> Thanks,
>> Ashish
>>
>>>
>>> IIUC the current kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
>>> is fine because in kvm_gmem_exit(), there is a rcu_barrier() before
>>> kmem_cache_destroy(kvm_gmem_inode_cachep);.
>>>
>>>>  	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
>>>>  }
>>>>
>>>> --
>>>> 2.43.0
