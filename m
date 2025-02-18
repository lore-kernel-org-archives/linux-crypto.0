Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2050.outbound.protection.outlook.com [40.107.96.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C91269CF4;
	Tue, 18 Feb 2025 14:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739889743; cv=fail; b=UmqnwnhR9ZsSo7Lkws6DkykWenHNt5qALCkgW5W+7uZPhb1QXfbWdtwfjUOgLfYYowpD1MfIwlJP0tt+r21KYQYtY5sClAj7uHnsmmWYKQoKFLP3GEF6MJ5wZOfrpPqeQFlVOTma8mjX2XQVKzgVkOC4JY+sQj3g46m36T+RuPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739889743; c=relaxed/simple;
	bh=/81MYHzOxDuUjYL19I32Cprq5InvLK625tyeqSDUVjo=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=nT2tc9YRspBG9sFgHjBSQFKlvzf7GHpYZlQgM+VPz2cbWgLZVTRFbmODmabhju86zQtwKr81YLuC64frV1zRgWU3NUMUX74UMr2zR8wNy/y70Vz5EfeGQDQaFk3VndHnEJswVLb5eDegLMpxzY5KFNtm/AK4x3KkTXmJ1GdAC4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N9V+S/6I; arc=fail smtp.client-ip=40.107.96.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N9V+S/6I"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WPli4u83V+fULRTWf8UzjrFFxgOXRHcA+mFCHD++SyYia1IaM4mtUP8P3eKZLUpGuR+yQRKFngY0pUoF5jPQfJ80a/FQu/KEp5rfTbqbUEa7AdTrmJnG4DRZAaOUrPpHTHA8sFGJd0YK3e57iJESATaz+bJzO/Ljez9i23NS8VRb+6rUj0FjWD3AC4K1lBCRF2jg5LN1Hwxy38oL/WkzBHdRYRk+ApCMZYDt48f2fiDeICrlDV1s6cyqsT4RrzBa1bQqjZdNX0L8U25KXi+zVLC64J+OxBfRb2A82v3LQYnn9BrPvR1jGle8hS0+LBr7keNjitm6BT4u+41qZFYS+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ma9IxAGiXK0XAJJKStXx46FniqLGzfv35sYvYokV5TY=;
 b=UlV9bDKFeXFtne6xKGfztFsRu8+eOK1M2x3lvUw0BRHUWWBNB1qZX3ZacvbVuzuDyh4Ak1cARUseyLVDMupK7VKNusJUSjf1GYYnuH+hb9qybZ7ErZyf/dPnmggYq4w1RyX2QjuxknrDzRINiTuF5YktOKSZx+M4HJLkbPGhsU8TnuJ2467LLcYanu4RucQB1AxBNGCxmDxjbb+LCo8asyH544tvzFSkXtTGOP4Q/ElTFUxfT7WxbpWxbqNL4ubel0iTLHGX1LSzpuOqkijPFONBpBmuPZPmZaujEeS1YKErViqdNdtoTe7f1Hfhk7mDba5poqA48RLA5idL/OfnBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ma9IxAGiXK0XAJJKStXx46FniqLGzfv35sYvYokV5TY=;
 b=N9V+S/6IpnEo1iIbfLmjnq8F8nsjINBlm/SAQ2j7ypjA/Sv4wc9omRBdEP66+53SMuQZSMqsFQ+k96O57sMyBIFriy/B7CTeJ/522qgYs1EZIBKaHBHPU75jDvDZKFAx2dSph8FOVKC/Gx9Y6xhgnN0b5fEf4tzxtnQPrZSfPWE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BL4PR12MB9484.namprd12.prod.outlook.com (2603:10b6:208:58e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Tue, 18 Feb
 2025 14:42:18 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8445.020; Tue, 18 Feb 2025
 14:42:18 +0000
Message-ID: <7f744fd1-da75-ca75-e724-fdc9bfd595cf@amd.com>
Date: Tue, 18 Feb 2025 08:42:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Alexey Kardashevskiy <aik@amd.com>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>
References: <20250214035932.3414337-1-aik@amd.com>
 <8050badb-8671-400f-8bb6-04255c761ba0@amd.com>
 <a0d4b2ab-c20f-444a-a1ca-d0cccfe862fd@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] KVM: SVM: snp_alloc_firmware_pages: memory leak
In-Reply-To: <a0d4b2ab-c20f-444a-a1ca-d0cccfe862fd@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0056.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BL4PR12MB9484:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a7ffdd0-9a4b-4d23-ed4e-08dd502a71d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N3BkT1Q1UGN6TmQramlCYkVjNTZSTytoaldQaEUyelZpZ0pIR3RkS3lUSUFu?=
 =?utf-8?B?OGdSMFVsZTh3aitNY3htZ1lVTDJ6aTZkZGFXUlBmZmxVY1NoVy9rd0xtQURN?=
 =?utf-8?B?UGV2UnB2eTM0QkQycXdRMzBWcGxqZjFvb25pNUhqZ2tRcXlWM2E1TkE1SXp5?=
 =?utf-8?B?ZmVORnVhS1Y0R0p1VzlSSzNaZ0ZTNXlIMWdjY0pWalA5UFIyRkxiV0lGVXA2?=
 =?utf-8?B?SGJqYlh1MnNEK2R2Rmk5ampOMC9PLytRNXdsL3dYQ2ZvUlJic1VDZndhM1c2?=
 =?utf-8?B?UU1Sd3FUZklZdjVpZFFtMVczQUgweGZoWWNTNFVjWnpjNUZVZ01VUTV5b2lC?=
 =?utf-8?B?REluMkxudm9vT3ZBZ3hHTk9wOVd5cXhTNmZiNnJNTVNnS1dmVzVjUlNPMTNy?=
 =?utf-8?B?YnVJWVR5OHh4UTdMYzg4clNWd2svSkZNL2lseVVkMytSV283eGJvMWxHa0M3?=
 =?utf-8?B?UjBKTGtha1dTMWxpR0l3M253VktPYXk3ZTdWUUd3dGRQcnhJQ0M1YjI5U053?=
 =?utf-8?B?NndrdlRXaVlLTE9OMmtNV20zOXR5ZjRCRElkWUN5V2xQY2JEQUR2SXYyUUM0?=
 =?utf-8?B?OFV1bnJRcDNQMXpORXBSVHV3SzZjbUdCTkRKa3g3VWhsVjBWZzNDN04zVVVL?=
 =?utf-8?B?ZmJ3RFYzc3EzVXdtY0Zxd21BYndHd0dmS1JPRmZKQ3JQd2dZSGo4UmZYUmQ0?=
 =?utf-8?B?RWVqQ2JOLytJaDhvS29RRUgzeHpKWUwxeXZEOFFuTFhGVFg5MEtPTXdXWXJr?=
 =?utf-8?B?UEQ1Z3R1NlgxSmU4Q0xVYzZ2WWR0VjM3SSszUi9wVjNiMW1CR1BJT09UbTZG?=
 =?utf-8?B?M2tqRThYSTlLbzJtd2RSSHcydnJVRmlTcm9mZG1Od2dvRTlObEhIZXNDZnAr?=
 =?utf-8?B?ZHQ1cStJb2dHVjJPejBpVThuSk1jRDhGMEswK2Z2eWx3RkJ4eE5GQXBXeHF5?=
 =?utf-8?B?RytpZFh5aStBcHNXcUt1eVgrSUdNTlFXTytLK3RnOUw1WVNPcEdFa1ZTcWxo?=
 =?utf-8?B?N0VycW1KSWMrUWxMS3ppR28yOGhMYUFZb1dwZnVlUzZJU1UzVkhPb082MDdn?=
 =?utf-8?B?enZVRjlycDhsUUM3TGtDR2ptLzIzdzlTSFpmeE1aYk5VSmdGeWkvang5N0lT?=
 =?utf-8?B?L1FZUi9BcU9vbkZDditwNXo0T1phUWNMalNHYmt1N3VMMEdmaUQ0b0YwcTRx?=
 =?utf-8?B?UVhOeW43ajB6S0dEUzFzSnZaZEpjOWtlaUpqT0Fhby9tZ2lBY2xHa0IrbDNk?=
 =?utf-8?B?ajFib1hVYm96ZmI5dExXRVdtcEd2aUxtajk4b2lkaTByblR6UzFoSCtWOWFr?=
 =?utf-8?B?ZGVvYTBxQVVTVjBQVVFiVVlQdVJEN2pyZWJ2KzhBK0RXN2dTbWYwRFhtUXRU?=
 =?utf-8?B?UHJqRU1LY0JkeEU2eTRtTEV3ajY4aWpjd3RKSjFxRGtNNFVKSk1mK0l2NjVP?=
 =?utf-8?B?Y3JTdVBuK1hSMkhub3c4Yks4UktpcEMzUXFqS3pjc1FtTTAvTzF0V205eFdr?=
 =?utf-8?B?RFZleWtMUUE3dnFwaFE2dzg3TWtYNE1ESzdiZTQyVEswamxkUGN0V2pZZnRT?=
 =?utf-8?B?VFRQdWhydU1TcmJjcEVJOHlmZGV1cEpOZmQyaUlTQnR2S08wMkQxM2F4WEZU?=
 =?utf-8?B?UHJJcHBmdFA5ZklQUzQ3RXVKY3NpNkVCSjcvdklwaHI5ZzhDTVBQVDhvZjdj?=
 =?utf-8?B?KzhiVDF0YXhkZ1Jma1I3cy9kRWt5V0FZbFZoNUpreldWY0FFM1NQZVpLMTEy?=
 =?utf-8?B?N0swNTZvNDlDR1BoMUIrUy9tck13b0V6UnZpWWpiWEp3Vit0L3JHUmV4VUpF?=
 =?utf-8?B?T2dFU0RWWFY3bzV4VDFvTm85QnV6RW5Md2dZUW9HWTlaM2FHcURlTTRPQVBH?=
 =?utf-8?Q?CAG2Qhagj3mnq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WmN1R1dITUQ0OER4ZjlCdS9EeTFWY3laZGZwejNHQWRXQjAyemdiZTNzWGV0?=
 =?utf-8?B?RnBEaU5tTlBOS1ovSk1kUTNqcmI1dVRZVlpFU3dNY1ExeXluY08ycitCcm9s?=
 =?utf-8?B?ZU1JT2xVZnBUOTdPVW1jY2N1dzFTZmpOWlNxT2d2UTVweFp2TGFzbWVqOHh1?=
 =?utf-8?B?N0ZtUWVOWmJTSWJKU3BzeDl6WTJFSkxHVXZpYW51V0hzeTBjY0gvYXZ5bnlS?=
 =?utf-8?B?TndETi9QUkUvaFk4NUxqRHF4OXdJZ2tMUFZYdHBYdGRKRit0b3J0ZmhUNEVM?=
 =?utf-8?B?MGVsRmgraGZCVzJNUUE2aUJFRDBUMkl1Z1NlL2s0U1QrTnR1bTErZnp5ZXBB?=
 =?utf-8?B?WFdBM0JncVc2ZHBOUGp3VlNHTStGQUk4Q3M2WkJ6b3JLUGZYMlZnUmpIbks4?=
 =?utf-8?B?Yno4blM1NDcwRUo1YlBSQVhrd2lDQll4Y3FYVTJ1K0xFanhDMDdQTnVIZUNn?=
 =?utf-8?B?V3JjTC9zNUN5NEE3TFN3NEN3eFYycEh6WkpLc21HeGZnKytIS1NhWlVjMFgw?=
 =?utf-8?B?bTh4cHFmVkxNQk9aWjNSeTl2YUREUTl4cm43c3hYUjRyeG5vUGkyYVVpc1ZT?=
 =?utf-8?B?U0Z3Q2lZSG0rTERrb1BxRkxjcEVxckREUkNUczVGWFlEdkorSHpxNGsvNW5O?=
 =?utf-8?B?Z2xBOFE4NUxsakJNS2tHZzU0UmF1d1NRM09wdTJnK0JEUk44UGd3Ni9kQ3Zv?=
 =?utf-8?B?VnRtWUJpbGJ0SnNhTkdMME9XTElkNHJCWGxyN3lkbStIL2pmNUJvQ2FEVXRt?=
 =?utf-8?B?YnBMK3FUUkl3Z1htV3BzMFhEQThsWURESUpsV2VjMkFsM2NDbFR3VWhLc254?=
 =?utf-8?B?YndZaERkRTA1VndLM2NENkVIZmtjWDZRM05QWit1K0wyOWNDemU2VFZ4VUVN?=
 =?utf-8?B?K2JTVHlFZ1RuampUV2Vhc1FyaW84V0NrQzZ2T2FjOExlRkRnbHlRcm02S2xw?=
 =?utf-8?B?SnF5MkN1YWtGdjNjUmxZc29QTWp5SStyd3NzT2I3ZExCd05tdC80Zm03Sit6?=
 =?utf-8?B?dytJR2JVVDh3L3dFd29UTTB0cDBCT3d6RGdwUHpQbE13TkRvcFl0UEN1U1Fy?=
 =?utf-8?B?NEpVSURZVjdaOFlxd2RMR0Qwd2gyNTF5a0thRjkvdXdlcXYrMG9TbzZJbEVX?=
 =?utf-8?B?TFRQK0hSVFlXY1E1cEx5bUd0ZTU5NzgzV25CK1B2NlhHRVBXMjZzMEg2c1JM?=
 =?utf-8?B?VHNOQkZvVzdLanArenFzSWN5NkMrbjFvUE9HUnQ2S05ac3Z4alljaldFTWJY?=
 =?utf-8?B?TVNPOG9BZ0ttckZLbGdva0k4MjNnS2VvVnZWWm16RkVjaUdDc2xha0FXZUJF?=
 =?utf-8?B?d3JvbUV6WHhEVGVjU1h1VGE0WXgxeUpFdDB4OXlKa0EzTTFEdndUeURCeVY4?=
 =?utf-8?B?cnQrbG5UZ2p6ZHBuZHdWTDY1UjlnQkVjZmxpWEdHeUlRamZSRTRYR3lsTmdq?=
 =?utf-8?B?MGU0b2pqZ2tvMzBSdkZYOEQ3Q0tzSU5vdWx6UU5RNGc2OVBXOWJUcktLenZv?=
 =?utf-8?B?bDNieWhld3RCWXJ2SGI4RmZrVXIxcFp2VUMwZ1QwZjJGM3NkMFJyaTM4SnB1?=
 =?utf-8?B?Tm02blJCNFR2cUxURkZtRXpnK0FaZnQ1TklxbmdKcm9qenNjYXZsaUlORWd0?=
 =?utf-8?B?a3U4T3Y0VkVQVlkzNU5DeU0wTHlIYWF1eGJvQjJ6NDdjOUdVQlNJZ0ZNaUsx?=
 =?utf-8?B?a2JvOHoralRBTUh2cXJiMUxiTFMvdkwrUHEyL2paOSsrVGIrRU5FdkNsVDBy?=
 =?utf-8?B?Ym9ycWM3bk5VVzdreDdsdlZMaCs3SUVGOG5sdUJkZXpSc0ZrRXl2bXV6eUs2?=
 =?utf-8?B?T2Z4eXR0U0REaGQ4a2tKTnRvY1FHOWdnSUoxU1dLOUV0aWtNR1RqY01GTE9t?=
 =?utf-8?B?eFZmQng4SDV6WGkxcUNJRXlMQXBsMlZwVk15RGdReHQ1aWUwVG8ydVliSWk3?=
 =?utf-8?B?YVhIbyt0bnBJZDVqY0lLdFRZcDN6UkZKTkQ5SUw3eVlVWUt5bGtQUXk5dXBR?=
 =?utf-8?B?UHAxdlNSZWlwQ0p3TUVsUk5mRjloMXE1N1JleHVRVTJ4Z3o2UUY2RXNMV0g3?=
 =?utf-8?B?MjdUZVUyR01leTl4bXRhUnB6Y2t4cUlWeW5ic3BIV2x2SkZ3MXFPb2xwcHJE?=
 =?utf-8?Q?/XUBfKtQewrqQz+nt5l+1CRgR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a7ffdd0-9a4b-4d23-ed4e-08dd502a71d0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 14:42:18.6501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6y5JEQPFfHS9qf6s2H7+am0JWRcTSxCq8Z8IIWnSRjK/j1JsXIvXPAkVsqtvW8ItndlNf/FF0dk/wkI6SKA6Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9484

On 2/17/25 19:24, Alexey Kardashevskiy wrote:
> On 15/2/25 01:53, Tom Lendacky wrote:
>> On 2/13/25 21:59, Alexey Kardashevskiy wrote:
>>> Failure to rmpupdate leads to page(s) leak, fix that.
>>>
>>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>>> ---
>>>   drivers/crypto/ccp/sev-dev.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>> index 2e87ca0e292a..0b5f8ab657c5 100644
>>> --- a/drivers/crypto/ccp/sev-dev.c
>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>> @@ -443,8 +443,10 @@ static struct page
>>> *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
>>>           return page;
>>>         paddr = __pa((unsigned long)page_address(page));
>>> -    if (rmp_mark_pages_firmware(paddr, npages, false))
>>> +    if (rmp_mark_pages_firmware(paddr, npages, false)) {
>>> +        __free_pages(page, order);
>>
>> I'm not sure we can do this. On error, rmp_mark_pages_firmware() attempts
>> to cleanup and restore any pages that were marked firmware. But
>> snp_reclaim_pages() will leak pages that it can't restore and we don't
>> pass back any info to the caller of rmp_mark_pages_firmware() to let it
>> know what pages are truly available to free.
> 
> oh right. But there is snp_leaked_pages_list which
> __snp_alloc_firmware_pages() could look at.
> 
> Or just replace __free_pages() above with:
> 
> snp_leak_pages(__page_to_pfn(page), 1 << order)
> 
> so memory leak leaves traces in dmesg, at least?

I haven't looked too closely at the error path, but it might make sense
to have rmp_mark_pages_firmware() leak all the pages vs trying to do any
cleanup. Also, have snp_reclaim_pages() leak all the pages on any single
reclaim page error, because it looks like, in general, that the pages
are never free'd if any single page fails to be reclaimed, but only the
page that failed and then the remaining pages gets leaked via
snp_leak_pages().

Except in sev_ioctl_do_snp_platform_status(), where __free_pages() is
called if rmp_mark_pages_firmware() fails, which doesn't seem right.

And I'm not sure what to do if rmp_mark_pages_firmware() fails in
snp_prep_cmd_buf(), since __sev_do_cmd_locked() is using pre-allocated
buffers. But it looks like if snp_prep_cmd_buf() fails or
snp_reclaim_cmd_buf() fails, then the buffer usage indicator is never
released and commands will just fail at some point...  But those buffers
are allocated using devm_get_free_pages(), so nothing good would happen
if the ccp module is unloaded and those pages are freed in the wrong state.

Thanks,
Tom

> 
> 
>>
>> Thanks,
>> Tom
>>
>>>           return NULL;
>>> +    }
>>>         return page;
>>>   }
> 
