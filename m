Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2081.outbound.protection.outlook.com [40.107.96.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF43B17BA3
	for <linux-crypto@vger.kernel.org>; Mon, 18 Nov 2024 21:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731964458; cv=fail; b=SMAzRxjGSaZ0FRDIQqqCZ0m7cek46VH2A/T9kdEXAgw1oGVq7t9s0eneATJ+OWDQsVHI23dvXcWuwR6ZbeXU9ibQaNUw/MW2BlxkacSSJe4Rl9WAsJhBhkWWCxZ49LJO2afpHjuko7d/DW1noFBjqH3ik/8n8f7fRLS3c6OmG5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731964458; c=relaxed/simple;
	bh=TfGVhQGpVdyeYrWrc3mBehflT1ltBnP1nRYDywrWqIo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RoBYR8F17iOQ698mGmIp/7IBMr69vrIKfp7h2ZuKN9ctfyVmNW/0I8oyPg/J4eGyXe80lfQDuHem5P9BsyugjvOLPK5wppxQirW81ZhZ+/O4dsfWwMugnu6uH5CDn0ItyiF1vdi1umiozzIhrVfYQrmggWYYwBVrXEktaBUUEs4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EKJ2eTui; arc=fail smtp.client-ip=40.107.96.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EKJ2eTui"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rS0bokcUHQA4DAFKhtPC73Om0S4T/3Z7cNGAsO8qXZttL5pzQRtelKd2pJVSJJyKc0AWkx8txL5ls7BZi2f88uu9hDaz+8PtMYbF+nSpDva3h4hYbO2r9FmQL2Ddny+6qZ7itazTD73xrx0ojgpU84SgxxX23y+jTBlNqzu+PoQM7+T5KnnlIQFW5zAzOa+FrPSWzklfAJi7xwBN+fCYPN0xGnF+SdT+HAfr3GhPl5BeBHOWIQBGznhCqW2v88MkN5/SKC8q33WRjX4dRM+Hj3SqfBfz+vBuRooIektJoxAWazpVJFzmjjOYYo7odtWUGVvNOEICkRORHdEgmtj6dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9k7BaQPNMHbcTDi4U8WddPY/CTUwC6/2b9/kboVbdNU=;
 b=JLcg+5w6l2mkd77t1WkWqlUa9JjQ2eg0j7DDIXFNsHR6Vn3a/77SmY6mKs7HgVBy8jgbCtn4GcP6kAysf0I7gIfddOXZkdLtrcpRPlSAuk55wRp81GYeCetfYqor6HMHlzp1qJPivYEIM8IKb1rGRGH9Fmcszu7zpHMOof4R9KIOhCXcbeP5OkRnAPP6VAriwGW7nb8PcHhIOu0mPj/q+d0dhKbNBGVqUBp4xvREf6f3asVnWfm6hqSOh3xdsw8Zlj99OLU8ZarJBbVQWwuf82ms1h1VgbpzYIItaa0bJ4hrJO7f9VX5zaAhFH3NNfhoph2ynwhqD2niwpmWd9Gjnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9k7BaQPNMHbcTDi4U8WddPY/CTUwC6/2b9/kboVbdNU=;
 b=EKJ2eTuipaHcOeOu669dBG+f3kBRmUTr4/02b0BbcVAec1xR3g45e86/0/hmCnqz4iwgf0J6hzi0JEh6dFpLVjy2VsP1QvPijkJ/cLHysI3Xc3XQgklpKnepUAAMzsG5nQImDnb76aDNpPQwvHWRElpFGMqeU8CdWAw2BX+VMTk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by LV2PR12MB5798.namprd12.prod.outlook.com (2603:10b6:408:17a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Mon, 18 Nov
 2024 21:14:14 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca%4]) with mapi id 15.20.8158.019; Mon, 18 Nov 2024
 21:14:14 +0000
Message-ID: <2c5fbf15-7b16-4b19-8c4a-c1a9df9d9037@amd.com>
Date: Mon, 18 Nov 2024 15:14:12 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: CCP issue related to GPU pass-through?
To: Jacobo Pantoja <jacobopantoja@gmail.com>
Cc: linux-crypto@vger.kernel.org
References: <CAO18KQgWZ5ChFf3c+AgO9fneoaHhBEAOcfUmRFw80xLnE68qWg@mail.gmail.com>
 <ba984939-ab50-4450-a3c6-7b8845de1ad8@amd.com>
 <CAO18KQhxrXGPoBgnkVoxfRvav5M25Bx5Ymdyo3Vbg0SB5Zqp_A@mail.gmail.com>
Content-Language: en-US
From: Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <CAO18KQhxrXGPoBgnkVoxfRvav5M25Bx5Ymdyo3Vbg0SB5Zqp_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR08CA0019.namprd08.prod.outlook.com
 (2603:10b6:805:66::32) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|LV2PR12MB5798:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cc71bde-6737-4d2e-e3fb-08dd0815f420
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V3FnL0xiczZGZ2lUY2tLWGVnbkFGcExsWWE0ODhXcEFkSVlUeG1RL3NzeG9n?=
 =?utf-8?B?YU9Cc05HY2ZCN2htNlhoOTlHeTZxd3hTMHdoMkVhRDFhTmkrNmREbmN1dVdO?=
 =?utf-8?B?WENQUVJNYloySWtuUnF2b2paUEJOMVN3b05ncmpsS1lzUWdielp2TUNXVDUw?=
 =?utf-8?B?elpCY2lhNkxCcGRSMDYrVDNUUzlvdXBiTTAyTWpGMmlUcExQekJXMitjZDcr?=
 =?utf-8?B?L1lvTXRiRkZncHdnMGZLNk40MFE0THY4K2FVKzEzbXZEOFROaTZCb3ZMV3Rv?=
 =?utf-8?B?QzNxOElNQTRzWUUxR3NNMzRkTlNQMk0yWEw1djN3STVmN2FXTTA5T0x3Uzhj?=
 =?utf-8?B?RWpCYWZXSVNuR3pLSkQvY3pQc2hmMy95TnlTUlFqZEltUkJoNlJuOXd6Mkxn?=
 =?utf-8?B?SzVZcmxpUXRXeC94VTRISEMrVVg5S0xFNU96RHdQU0FocVJvQU5zaHorWWZy?=
 =?utf-8?B?bUhhUjNRbGhGT21TK0VTOW4yZFFMUis2KzJzRjdOc0lvZ3VtNmhsUkxRSVZG?=
 =?utf-8?B?Z240cVNTYkYvcHpOMXluRzVsTEFBQ1d1OFNwZ1ppeUo5aEFVTE5abHA3TUs2?=
 =?utf-8?B?WnNPYTc3T3daaGpjZmY5TkpMekF5RWxVYlNSNnVDMjFBaFI3RHVyU040NHNl?=
 =?utf-8?B?ZElDZlhBOWZDY3orT2J3cTI3UVBOVjF0a3ROTUNJMkQzTENxWmQxOXRmRWVX?=
 =?utf-8?B?bnRoZE5wM3lzNjQ0VE5wYUNnSUZOQytMVjErOUJ4K2ZwKzRmelUwM2tGMFlX?=
 =?utf-8?B?Sjk2ckxyR3lVZnFDR01VQkZGdFJVUG9RZm5nYkpWU1JMVjZJMnVRSVZaVnM3?=
 =?utf-8?B?K0t6M0N1TmxRUE9uaFEvQmpFL1ZySkVPM0RQNVZLV2J4cG9MazcrcjFNZ213?=
 =?utf-8?B?QTkxZFFpcG9wWC9xOG95RlBld3MxOFlaWWorQXlpUmZXUzNaYzRqUFA0SkdG?=
 =?utf-8?B?M093K3JHU1hxWTgrd1ladnBjNGJrQlNoQlJlMHlRNTdNZi9janJEUFJMeVNR?=
 =?utf-8?B?SWZPZFBFV3M1SWZxc1NGaGUxbWZFWUF4eS9yMGVXUkNmMGJPSDBLT000aERx?=
 =?utf-8?B?bWZ2WlZCdER1VHA1Szh0R0hoc3N0eXVVR3o5c0tqV2lxS1ZUTUdJazRxZ29a?=
 =?utf-8?B?MHp2RXYwRTZKcjhQL2dWd2pNdUtPTnRHZEFPNjVxdUxEVkJpUjgwb3pGbDha?=
 =?utf-8?B?eXFyRTNtSUVzUVp5K2thQVpDanNmdWJzS2t2NUhwamVXSDl6d0lFaFhrSlFE?=
 =?utf-8?B?RVNsQWFORmg4Njd2UmU3cGg2R0M5UUZZL05sRXlCNkIzU1VCYXI0S2RVaExk?=
 =?utf-8?B?ZGZXcVY3Y3FzK3F5bmRiWXF1Z000bFZRWGF5SGU4azRuQWM1M1MrMnY0SDVi?=
 =?utf-8?B?dzRwcTRTek10K3dOSnpBUC9tdzR1RmRYY0YrUWNObHdEMU5JdHlvQjBudFhH?=
 =?utf-8?B?UXlSdmk0Ky93NWJuRnQxb1MrdkpiNGhMNE40bWE3dGQreTd4a0xHZm9qb280?=
 =?utf-8?B?VHNNSGp1S2RPaGZoUWpaMnZPQitsNC9aT0JsVnM0dWp4TmE2bTJ2RDJrK1A4?=
 =?utf-8?B?QkRxZDBXUmQyaTB2UlFXRVhReVl0czFaRHdNZnIwaC9yajc3TlEzcFoyeDZZ?=
 =?utf-8?B?bGtVcjVJUGRBY0Y0MW53Zi9IUjBXb0FLRW52VDIydU9wcXIxYzF0Z0JENTNR?=
 =?utf-8?B?M2c0TWZRdWhPVzVWZVlOdHdkVVgybFliaFRUUkhnZFFrZXc2amZrT3pQamVq?=
 =?utf-8?Q?5hzld0cCJ46DjHo2uEPfwMx+LHD2PNw/mK3SYNp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MkwwVUJmZmpNdGYwMnNTZk5ZZXdENXhOTGRQd2hZVU9UZTJmSDBDbXVrYUdX?=
 =?utf-8?B?RExrZXJsTXF3U0hraE9MSFR5ZGkyemVITE16TTVFVjNiNmpPVjhvMnRSRXJo?=
 =?utf-8?B?eFJPL2FMY1Uwb21tY3dkRGxmV0xMejl6QVdYNm9US2lhMUt3QkVYYVUzOWRT?=
 =?utf-8?B?c2RDa0ZpalVFVFFiRWptV2xQSUMreW16OTRDVmZTdEM5NGVmQU10WkZiZWhz?=
 =?utf-8?B?V09jTFNXenkvRW9KNXFhalhkNHRoY2NJWWlnUG5NZ1NDd05PN0ZrTm5DQTdj?=
 =?utf-8?B?Nm43WGdueHVxN0c3bHdtWFR1TTUyV2g2SGRsckdkVWFxaXdZVVpPWHI5Ukgw?=
 =?utf-8?B?aXNFalRiS0hqOVdXS2pBbGhLaVJTamM3SzQ1alJrZWh6TnBYb2Zhb0s5UXQ3?=
 =?utf-8?B?VjJvMEN5OTRaUkJTeXk3dXdXSXoyNlNXUDZSb24xU0E5dGc1MWtNVnVUZm5j?=
 =?utf-8?B?MkRzRjM1NDRycWpEK2s3bDR5emZIa3VXcEk2eG9JS0xyQUswSWZzZjlId1lt?=
 =?utf-8?B?azI4NTFLSzhvanlkUVpSSlo3OEtiNXVzTVJCN09CbldDTHpNdEtVSEpGTmx0?=
 =?utf-8?B?Um9HQW1McEZ6VDgyREVFYnVuZmVFNjJGTjFZaGhRbHJva0RqdFg4RUlFOXl0?=
 =?utf-8?B?cy9ZMzFrTjBZaEJIbi9wT2cyQTFzQ2xFRjlNOUQyT1B5RnhiQm5DSlovOEZ4?=
 =?utf-8?B?bzNvdDIyTnUzREtna3g4SHpod1VJbFN4ak5VOTE4R2NVSzFJTzlZZjZFR0RF?=
 =?utf-8?B?alZ4bmc4OGtLRk5uYTVEWkVRZHVpalVFQzZ1UGVpazZjaUFDTzV2UWsrRFVs?=
 =?utf-8?B?Mnl0cUtMaWZpQlI1NHRXOTlDdTB1Tkp3NDhyNFhZTElncitUM2xGUDBla21s?=
 =?utf-8?B?c3dvcmxoM2MvbzJUVThOUSttZnRxTEJXeUl5MDBPYThsS2lveEZ1RU0rcEtL?=
 =?utf-8?B?TTJaWFBXelA2Z2R0MUFLSW94YjQyQmRqSDVNYXoybnZnamFsKzBhZFdpNG5H?=
 =?utf-8?B?UzBFdU5HSGtLK1VjK2tVNnlXbC9qam1nRmhoSEhCcStEZG85cjlLcnVXTGpB?=
 =?utf-8?B?YXVDSzZZNzYwSm1LZ2Y0RHp1QmM0Sm05UG9WcHh3UEpya21QR2srMXZSb2hl?=
 =?utf-8?B?L1Z3Umc0aTRleW1JTWxudzU2Qzk0T0c0Z0Q1THN5YmEvN1J5WGNTNlArRzla?=
 =?utf-8?B?STZ5Zld2cDhMZzYxSTByMmR5OTZESGZuUHlWa0RvRm5UWTIwYmxSVDVTQno2?=
 =?utf-8?B?ZStHTVFBZFY5UEJObEk5bkNNa3NjbmRVQ016SkFqUXhuS0V0Mys2R08zRmEx?=
 =?utf-8?B?NWV3REdEU3BDanJTYkZmckl0MXZLbkt2eGkwc2Q2YmlUb0paV09LeEcrRzQ5?=
 =?utf-8?B?ZXZQMHpoREJNeHF6OTdYYlVOSDRERzNxT2R6aW1YRWFnZlVBc3J2Y284aVhD?=
 =?utf-8?B?OGlKSkg0clJML3ZBd0pDU2ovTmc4Qm1BeXhURTc1YTczOHpZdDBIa0R1c3BT?=
 =?utf-8?B?RThEMk5oNWN6NDlnK1FidXI5MmpQejA0a2UrdGs1UWJhSXRyMXQ4ZHNuWW5Y?=
 =?utf-8?B?OVhNOXFVeXVxcVdQTWVmVWxTeXRNc2FyR2gyR20rbHFQenJPTjJrYzU5Uk1Q?=
 =?utf-8?B?ZmF5UHFVN0lKdTgrL2NldXh6WjdTUkZwekdOcU5DUXJGdGh5ODVRNm9UNVFt?=
 =?utf-8?B?clZoQkc0aExFNTZWMndqQmdXU2RHY24wQVN4Y2ppMDdjYmRQYTEwYW1UK2Ju?=
 =?utf-8?B?RDlaa2UxMStsUjlyQk5qbzMwbktRYitXbFRCeENyM2daZ1Y0ZEJrd0FLZWhj?=
 =?utf-8?B?WndvM2REcis0dFdqNm03MGEwMU14bkVUVFl2UmgyeDA5cWZsN0M5WndFY1Iz?=
 =?utf-8?B?aHhLK2U1ZmpKZVl1RGpLYSsva3RjcEFkSDJ6bjNlN0tPM3lvNDk2MjRnYmRF?=
 =?utf-8?B?eWZoWWhvcnRnQVdtL0dqV1c2a05ZdWJrUUhQSVBGdTdpd0VWM1A5V0FhK2pC?=
 =?utf-8?B?b1o3MzgrOVIrQ2JacVYvZGwrR3F4Ni9odUJJTDh4czRYcmxocEs2R0ZPUnhN?=
 =?utf-8?B?Wmc3MkRRcXFpWm5NeEdVOW1PNGIzSzZpQlhCTFpBcWg5RU5yRlorT1E5ZU1y?=
 =?utf-8?Q?UHsYPJnOF7c/yZUaLfpMgmTsI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cc71bde-6737-4d2e-e3fb-08dd0815f420
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2024 21:14:14.0947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5jM1D14rciRuFjQr4sxQSBeeBD+gekG3gLUaZZYJHkktlOaG/Rp6XaOvS9ZSZBygWZXZsdgMFbC0pzv45d6cGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5798

On 11/18/2024 15:11, Jacobo Pantoja wrote:
> Thanks for answering
> 
> On Mon, 18 Nov 2024 at 02:20, Mario Limonciello
> <mario.limonciello@amd.com> wrote:
>>
>> Hi Jacobo,
>>
>> On 11/17/2024 11:42, Jacobo Pantoja wrote:
>>> Hi Mario / crypto mailing list:
>>>
>>> I'm trying to pass-through my AMD 5600G's integrated CPU; I can do it
>>> easily with Linux guest, but I'm being unable to do so with a Windows
>>> 11 guest (which is my end goal)
>>
>> What do you mean "pass through the CPU"?  What exactly is "working" with
>> Linux guests and what exactly is "failing" with Windows ones?
>>
>> Is this related to passing through the graphics PCI device from the APU
>> and having problems with that perhaps?
> 
> Yes, sorry, it's "GPU" pass-through. I typed it right on the subject
> but not in the body
> 
>>> I've noted in my dmesg the following line:
>>> "ccp: unable to access the device: you might be running a broken BIOS"
>>>
>>
>> Are you trying to pass through the PCI device for the PSP to a guest?
>> What is your goal with it?
> 
> Just want to pass the GPU, nothing else
> 
>>> Tracing it a bit on the internet, I found a couple of fwupd commits
>>> done by you stating that in some platforms this is expected (e.g.
>>> 0x1649) [1]
>>> Comparing, in my motherboard I see that the Platform Security
>>> Processor is 1022:15DF, being that last number in the same code you
>>> applied the patch... but I cannot understand whether the ccp message
>>> is expected on this platform (chipset is B450, if it adds info) or
>>> not; and if this could be related to the pass-through problems.
>>>
>>> Any hints would be more than welcome
>>>
>>
>> Those messages are referring to some cryptographic acceleration IP
>> offered by the PSP on some SoCs.
>>
>> Not all BIOSes all access to it and it really is a case by case basis if
>> it's expected behavior or not.  When it's not accessible that "just"
>> means that you can't use that acceleration feature.  There are other
>> features the PCI PSP driver exports such as TEE, security attributes,
>> dynamic boost control, SEV etc.  Not all platforms support all features.
>>
>> If you're just shooting in the dark for your issue based on the warning
>> about the BIOS not offering CCP this is probably the wrong tree to bark
>> up.  If it's actually related it would be good at least for me to
>> understand what that message has to do with a Windows guest.
> 
> I'm just trying to discard potential issues in trying to achieve the GPU
> pass-through. I'm pretty sure it is related to the way the GPU driver
> starts the hardware in Windows, because when the guest is Linux,
> just passing through the VFCT ACPI table is enough to get the GPU
> working. But in Windows there's something different and I was wondering
> if this CCP "issue" could be somehow related.
> 
> But I get from your message that this is most likely unrelated to my
> GPU pass-through problem.
> 
> Best regards

Got it. Yes; this CCP issue should be unrelated to issues with GPU pass 
through and Windows.
