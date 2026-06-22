Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011043.outbound.protection.outlook.com [40.93.194.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6B636C9C2;
	Mon, 22 Jun 2026 09:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782119741; cv=fail; b=uly9lgu1KVLJkzEpxhJqfz0zQXQ1IQrNigaIz5gOBcv/A47/+fmGv1ykS7hbvLL20yOcFPYCkfxBZMjv5yZ65uvz9GAfXGk4bZpPsJG5k3hp62tIWu7bJqS8QDic8ddQNsmNtxGL00ZiS4dMmKY+1bFTV6c3KGLRh3u/F9u9skY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782119741; c=relaxed/simple;
	bh=UjaUMvuPb8KPecLXsvxDAldry1ko0dI75laFJs3ynvk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ktkKyekEhhF8Y2F7Sg/r48jDgfFZ/8Nzb575Mod21E/dD65WFUT0fcfqMppxmdHyuFu1trknfXjXg+w8UlOTpoXKmkWK1zaiIIQUYY03jTmOTXHUI5G2dsw6/mqLwc1w7h8vJrNMY5Yhq8T6Lo6uTQzkVGtE9NjmWulk4PeSLjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HomFplGN; arc=fail smtp.client-ip=40.93.194.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HomFplGN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O/Yxas6CBBWrwVyVxWYUWOiTmIidUd0yB41piwXvEvGOp1DaTQpKeeiV+AqQlelfCwNY2bXiIbrgpamHat0h/ZNhJWc3PiieIuWMEdv+7yk4ow/mhnLmscnA7Tx8dilIDI3X85Vk6UwX6HVHb8DqtPkDRsg0YIMq5pepOqTGVPpdfjinBrSbX8js/vyia+IkXdm8RC2IXEtsuXnGmDKCdPpzSp4rWsPjmWnS9OPcZZ0GiyQAZg/W+Vpr64+hnZI0Lyvnr/Gm8i7D+08prcTpYlO3Ys0XbKvWt3NDfgZO6Qvj5/1ylRmniljBXPX/9sJAyfR4ksr5E0qzNbRqFwaf1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gtlDKiNHIds+t6+ScbEFDLLKqfVPruttD+psXsyALgw=;
 b=DoU9skz/vQyWm9DqoRdv4ftykRRINzif1Tsm3FjNyzdWjF11LwK/OtSsoz3HxadUlX0flRCa9PvUSGhMV/XaA+Oq5qdoE+INJJejYP9c8apmW8EYnt+ZSsoNLoathT0nawIqdWxKtvtps+ecWRnv13TA2/awiIZtQPFMdx3Iy7tOgi3Q3BGK0K2cFDTa5Y/NASZS//4mOwX3U7O/gmXQErCBXeOUvfL4FyGJyYwMPhGdHXQZhrKl4Dg9FCRA4GqWIYaYhCu2wDBIvqgIAcH1T0qQFKgHPIW4/EHBlUaYfnQ6qGpb7cMkzJgmS7uDeR4P30D7aJ6gd308Qmrk3mSL5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtlDKiNHIds+t6+ScbEFDLLKqfVPruttD+psXsyALgw=;
 b=HomFplGNfi0sYkXVxRXR61Y50ur8kBE3YMRNVDirccIhxjarh0cMQxU3i2LkJ1hbmzkhd20QWlIajeO3Ip+5CYR2qBPVW+KXYKRSD3WGu6rcmgNDdHyTclRVFKNBo4uBN0bEZKzJaqF4jagTa9w+OW6oef9SOjoNVKTu/Xl4FSk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SJ2PR12MB8690.namprd12.prod.outlook.com (2603:10b6:a03:540::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.18; Mon, 22 Jun
 2026 09:15:30 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0139.018; Mon, 22 Jun 2026
 09:15:29 +0000
Message-ID: <07b6d905-11b6-48b9-9a51-f8f98bf89281@amd.com>
Date: Mon, 22 Jun 2026 04:15:25 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/7] crypto/ccp: Disable CPU hotplug while SNP is
 active
To: Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>, mingo@redhat.com,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
 pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <1feccf6e2a56d949b30f403c0ca7949f580e5982.1781419998.git.ashish.kalra@amd.com>
 <49380c3e-c275-4211-876a-c51f644aeb17@intel.com>
 <bd2dc2e0-e975-40a9-8e0a-4403db858316@amd.com>
 <20260619221022.GBajW-TvxyCuGo0FWX@fat_crate.local>
 <d91bf0a8-0c4a-4552-9009-0ecef46aa279@amd.com>
 <20260619232007.GCajXOpyPbiu4FVZIW@fat_crate.local>
 <e68a126a-6f2e-4a76-a691-f514b7f37489@amd.com> <87fr2gmav6.ffs@fw13>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <87fr2gmav6.ffs@fw13>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0290.namprd03.prod.outlook.com
 (2603:10b6:610:e6::25) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SJ2PR12MB8690:EE_
X-MS-Office365-Filtering-Correlation-Id: c09e6c39-0f20-4dd0-4963-08ded03ece1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|18002099003|22082099003|56012099006|4143699003|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info:
	fZ8YMUqLXOIoXot2YH2WqzeOKNGNgUTXOXkWGsXPSPW+PAW3WKfAleIweFf7NQ3DxQICt7XkRG1RZUrV5Df+SUKmLku0pD2Qc0jGdi452I90QA78bXWygLh8as2hoxnaDG15BmPZOMqCKW3sfJiJOZ2LAdjkynJdNpINLOIJceQoW2v9VkFomnyahxpk8AJ3YKuZm9vZU8GpFuyRyp9G9YDpdJd8nBlQM40yDgIejGx1kJWxek7TCmCmLYhvOluSoCV7TW9HxznC6o/PxZP9/P3PhvjnPci0NwlnMuAdcTSxQUXmWQfuEysFAgU3C1twzgV35rZe4kZwRvkMUtao1ITM75OlA4klIuXgO7SzGVTNC/eBGvfvzGk8iF6iwYcTGIP65UzYPNSoacE5rnlX1Eszq54gFaWkg8cBTlwCYpK0T4ggBxR0pvv5Hr+6iwGIYxwW+pprgGKCoR9Rgb1DPOgPmLWRhTB/8L7HfZRuVHYP4JmPHVYVlY0KQ+e82qZtU4XIr5kfgL9WU0IF2EoMbJDzEbr2XZh8WffTjiZmZlum9AT0+YyEXLJCpVWQ2TvztFCk39D1hosUSGR+LzeSy2rBK8MPhKazXLDK+4QgI68U5dEGRubaAgzquKBqN7WKObeSGHYaxxsloSWjjqhJXrBju3NZEV4SkUA6fje8Gh4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(18002099003)(22082099003)(56012099006)(4143699003)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkVOdEFMeS94Y1VCU2xsVjdHYjVOcFo5aFhZSE0xK29qR2R3cUlkOThaWWJN?=
 =?utf-8?B?cWE5czFkTHVDSzZiM0FPd0plOHUyajlBVVRKRk5aUlJBK2l4dG5mYmJPd1F2?=
 =?utf-8?B?cERQV1dkWmp0K3p2azFnK2JpQ21kd0M0SFFPWW9od3gwRi9VNWt5RlJ2RE9a?=
 =?utf-8?B?SjRSeUk5aWc3ZlRiNVZoa1pZR2ZUaTF3TDl0UW8wa2lRV1YxSWxHeWJvQW42?=
 =?utf-8?B?OTZ5TExMWURNbElscGQ0bnhqaXdlblAyUlRxaDJjOERtYmIrNkx1cHRKdG1z?=
 =?utf-8?B?M2VrUHdqVUZ1SDVoK3N6TFNpQ29pb2w4dHdpSWhMYXYvOVBZcEc5SjQ1eFZo?=
 =?utf-8?B?djJGY2tHUHQzMDhEenY0UlVpbnpQaDFmRXFGeDlwVWpjdXdZL3E4V2QvTDhk?=
 =?utf-8?B?UDhzUENjMFdER1ZmWVB6MHhuU3dWaWpSNWdHejhQNkFuWDNiaEdPVEhVR1dI?=
 =?utf-8?B?bytra09XNE4xUTZwMGNDc1NLc2tZT0JhbGZOZ0lUdWZNWkt4bWUzbjFpbHBj?=
 =?utf-8?B?bVh0SHA0b3RCODduOGlaNEVleHJLM3JYZnFURUR6VGtEY1FZeHpXNWdXSDJ5?=
 =?utf-8?B?TGtrUDdvVVhmNHduMThUUm9TVjNIRGNvQXhnZG82Q3ZQaUVkUmpKUW8xTFN0?=
 =?utf-8?B?VGpJMFFRd0d1MU1VZjlJcUZMekIzRlp0KytRUktMZ3o0MzFBMm1aUlRCOG9C?=
 =?utf-8?B?ckcrMVpTQ05Cby8zdFJ4RmI0Z2dBRnRBLzNtWXdsdkQ4YVFuRkUzZWVPWXh4?=
 =?utf-8?B?TDJrNWl5UnUzT1IwWE1KcHRsOGZPRjNBNkcvVUgxaGZGSFdpRzluc0grbi96?=
 =?utf-8?B?QkwxQ0cvQi82UGdMRXVqS0VjZStaOE4vcHJTOWNULzFjV29GM0xhbERLcmNx?=
 =?utf-8?B?M2ZXU1hHVEh5eHFZWlQ0VTBlUFJibnJQbElGTmRobmxEeCtnZUlLWnRGWjB3?=
 =?utf-8?B?UnBlR3RVREhiY3NwRTBvMjZST2RHNXVDTVRJbjg0ZzA1eDVoQmhPa1NraDBU?=
 =?utf-8?B?eXc2YzkyNlIxRHlkU0xJMGpuUmlZVmpHNHpIWG02cUk5Ym04cDFVRTA1NmU4?=
 =?utf-8?B?aXdjU1lRY3BycFhDb3d6YnBESXV2YjFUbVV5ekdPUjlZdlBzQTh3bTdrTGFm?=
 =?utf-8?B?NW44YngramhyL01waGVxbGkvbHBIUFlZTzFFOWJsaHJJVjVzdDVtaDJ0b0Iw?=
 =?utf-8?B?bmM2amlqWFkxTGZ3UzJiTkU1Rk9MWjcrZFdCTm1iNnlmWVRjeXVHMGVlUnpY?=
 =?utf-8?B?cFBvenhNNkJHSzZ6bm1jRzZuc2pQVDlaaSs2MTA5VkNmM1VHN0hhZStGV25z?=
 =?utf-8?B?UFhqbXJIL3FSTnJlUFBDQzBaNGlNMDAxLzlZSEtIaHpjbjNXdTBPNCtaMXZt?=
 =?utf-8?B?aExSWTNIbzlIeGt1K3RKcnJxajI0NlhmSDV3SUtDNEROMWJRUzI2OVZqNjJo?=
 =?utf-8?B?S1ZIdXlCMy8zZlpmUkJuR2M4cVRRUUxBZTV5SUpPeUhjdlFmMGFoWTBKZXJ6?=
 =?utf-8?B?bDIxRkl4OURtQklPNXRjTmFYdXFwTlVFaUphaVArRTE0Y0c4clBIMDF5YlU2?=
 =?utf-8?B?NVp6bVY4WTNlU01NZngzcVY2T3Uvc0NRRGFKZ1NiVmo3ZjdqZ1RFdlZ1T3FL?=
 =?utf-8?B?WUpnaVRoYUxzbjhNVDdVWHk4c2tIZmZwV0pMVW5ZdWNzWWYxQm5Kei9aREl3?=
 =?utf-8?B?K2lnQXJ5WFlySVJNMXlXcENKQnhmajdKb05nbm40My9PRUR6VkdSRUN5dTdi?=
 =?utf-8?B?cURveWlYNEVvVS83bVIvLzA3eFpUbHYzV1VjQ0JTZ0t6QmNZWloxNThDRXRS?=
 =?utf-8?B?enFUcmxnbUphaStxaWJOSFUrbVhsNTVBRW5rRTFIRDYzYjdzTTJMcFM4bkoz?=
 =?utf-8?B?Njc4RWF4Y0FaUWNERlgxT0N1aXhRWXg1ZjNjV0pCQlhSQ0IxTWxDTkdJRDU4?=
 =?utf-8?B?SkJ1Rlh1bFNPSGlLUHYvQkZNYkpLcXZ1YkZGQlhrY3VhRDZLcGdQRitMWlQ2?=
 =?utf-8?B?TkNyNktoZHJwV0RtVVVoMm0wT0drWHgzbjFBZUNhSHBEK05lWTFDVU1JNXhP?=
 =?utf-8?B?Q0pyN1F3cU9FSElhdXdiRm92RTRqNkxJT01NNzJlbjI0RXd5Q0MvcWI5aTUy?=
 =?utf-8?B?c0pQRjJzL3F3bVBtVnc3VVBud00ya2laWVVremx0MzNFaGpjQ2tOQWtxYUpy?=
 =?utf-8?B?L2dZd1QvSkZjRVdSNU1qV3R0WUdaZHFmVDJHT1Nhd0Z5Tjc0U0I1QjFqKzA5?=
 =?utf-8?B?NWRkUHVlZkowMi8yZjc1UGtZckFEQ0twT251eHFMeGQzNDQ5emNBc0pCT0Rp?=
 =?utf-8?Q?+wDT+mTuFAecdgjEX6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c09e6c39-0f20-4dd0-4963-08ded03ece1a
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 09:15:29.8959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: syJD8rfHr/lXYviUXg4X4A6Un8+CMKDrwPfqrdXP5XWqpAckNd23soWM1riohXxwnZmcay6fcY5L3oQqatzIrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8690


On 6/21/2026 5:44 AM, Thomas Gleixner wrote:
> On Fri, Jun 19 2026 at 18:51, Ashish Kalra wrote:
>> On 6/19/2026 6:20 PM, Borislav Petkov wrote:
>>> I'd let tglx maybe give a better idea but this cpu_hotplug_disable static var
>>> in kernel/cpu.c could get a getter function and be used instead of you
>>> reinventing the wheel in here.
>>
>> I don't follow — I'm not reinventing anything here. Patch 3 will use
>> the existing CPU-hotplug callback interface: cpuhp_setup_state() with
>> a down callback that returns -EBUSY to refuse the offline while SNP is
>> active. That's the standard mechanism for conditionally preventing a
>> CPU offline, and it keeps no private "hotplug disabled" state of its
>> own — so there's nothing here for a getter on cpu_hotplug_disabled to
>> replace.
> 
> That's not a standard mechanism. That's a hack as you have to start the
> offlining operation in order to prevent something you already know.
> 
> The return code which prevents offlining is there for situations where
> the subsystem/driver is momentarily in a state which cannot be
> resolved.
> 
> That's a very different story than knowing that state at the point of
> installing the callback already.
> 

Sure.

>> I chose the cpuhp callback specifically over
>> cpu_hotplug_disable_offlining(): the callback can be torn down with
>> cpuhp_remove_state() when SNP is fully shut down, which re-enables CPU
>> offlining. cpu_hotplug_disable_offlining() sets
>> cpu_hotplug_offline_disabled, which is __ro_after_init and one-way —
>> there's no interface to clear it, and adding one would mean dropping
>> the __ro_after_init marking and a new core "re-enable offlining"
>> API. So that route can't re-enable offlining on SNP shutdown without
>> new core plumbing, whereas the cpuhp callback gives me that for free.
> 
> That's exactly the wrong attitude. Hack around a core limitation in a
> random driver by abusing the provided mechanism instead of sitting down
> and doing the extra five lines of code which makes it entirely clear
> what's going on.
> 
> When Boris asked me how to disable hotplug, I had the impression that
> this is about permanently preventing it. So I pointed him to
> cpu_hotplug_disable_offlining().
> 
> If I had known that it's about temporary prevention during runtime of
> something, then I'd pointed him to cpu_hotplug_disable()/enable() which
> is five lines farther down in cpu.c. It's not rocket science to find
> them. The first AI chatbot I asked pointed me to it immediately.
> 
> cpu_hotplug_disable()/enable() is _the_ standard mechanism to prevent
> hotplug operations temporarily. They return -EBUSY without invoking any
> callback or changing any related state.
> 

This is the interface i have been using, in fact this current patch (v8) is based
on cpu_hotplug_disable()/enable(), but then this thread started from review feedback
on the v8 patch using cpu_hotplug_disable()/enable() that it looks like a hack — 
the concern being that cpu_hotplug_disable() reads as a temporary lock rather than a
way to enforce a basically-permanent system state.

That's what led me to look at cpu_hotplug_disable_offlining() and a cpuhp down-callback
as alternatives.

Your point that cpu_hotplug_disable()/enable() is the standard mechanism to prevent hotplug
operations temporarily settles it, and the disable/enable pair being reversible is exactly
what's wanted here: it's undone when SNP is fully shut down, so it isn't actually permanent
(unlike cpu_hotplug_disable_offlining(), which is one-way). So I'll stay with 
cpu_hotplug_disable()/enable() and drop the alternatives.

Thanks,
Ashish

> So what's exactly the new core plumbing you need?
> 
> Thanks,
> 
>         tglx
> 
