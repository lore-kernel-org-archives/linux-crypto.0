Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010030.outbound.protection.outlook.com [52.101.61.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C2E423152;
	Tue, 30 Jun 2026 14:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782829131; cv=fail; b=WIy8u6TUXfhretA4uwAh9tq+osi0cYzZhYl1HF1ShF/A7Q6H26ZXmzlkYQplOBhIYDTytxZzvXhbc89JOdM5fx315rlWoEWdMYqh99+T0Bl1z2ZrYfkyyzm6C6wU2G1Gg4aQxIY3C1pY0ngl9lE79zkILwq1uUkYTwd+UWKhcAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782829131; c=relaxed/simple;
	bh=SzRRrG9agKQps18enGZP6awS/H0J5J5N4NXVBspDEuE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kwvCMKWy9gwSHqk0jBLQ3e++R9rppwMjpazNes5GL1ZVleMQfJbi4LOwFnC6hDFIJvtyecHtpVyD9zI2EVFo6SHnNK1P2p3Qtn2/TXsalFjtIgUfp6D3gZ6dY3cp4SXIPsQxjq9C22SYZa2vZu1eMaTFPBg4z8Rm2Wp6mbrL2Mw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gVOyawF1; arc=fail smtp.client-ip=52.101.61.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gVOyawF1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EIZGb4KZdyBmnF5mzh28FLnLIrfrLjC9SDIdB7dazrFXX6wj7NqvH7WEkYJN7xOREaNvIj34QGgNsEZ3hwbVtNhlFEhCBkEsowqwlQWo26kIsqKSmdHw6S9kYpFzp2vg9lD4kt7+X+GBP3eu6UBOhvvItf/YjlvbR18ievfZhtpBXZ7l6j9wcjDMycA5A/ObwqL/aXPm0eUmUZ23BJPvyOXbzwNqa3NP7QCKyWpxLKF5qN/SWP1hlTaYT8YXUb1Ri61qArbI2mZ4vM39XMkCh3oEs4QszWikWR5BZrrLWS0ixZG/p+5v4IpiMwGHVUFd46BPVKfjvC/cB1yd+rxXIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CweVT+oMb3viipkdZzlp8Y/c/7poTbUOlGVYHs/y60Q=;
 b=RQpyzckhdCwhk23kcvdDNiUudS9kVxHQl+SuU9hGBVTJW6WxWj+X+4EA/bK8OXTviNipY2CVHDc4ZZHX9a/o8bxXzcja/vWs1gcKggmIJyFBX3Uf3L6crewjOwvYM07Ui9OHE9rAXdLONri2f6MTw9oXwXJHqtwv63tIuUr5WtLVSsBkLguXwZFtEPwD+T3yfsmuVVWJ1uazqu6RHCTQgADwz47sX3Wv9qkCf27GBmvpxtCyY5qaSSh203AgGkGAjbaMN59VmrPfPfYfSI8figo04jeVU/rAYm2ZQOItf7JlXE+YKB2ohekltApUw93eflMuAn3rglJQL4Sf3O3dTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CweVT+oMb3viipkdZzlp8Y/c/7poTbUOlGVYHs/y60Q=;
 b=gVOyawF13Mkb2QVv8wTnKFmozqVd/VbD2SCHqapR4RfNNuFtGDYjJFyTqQOHj45ORR3bEFE/9BiwOxIfxjXy25hQ1s2Ns8IVSOy/iXL5zV3D9qIloiHMwtRteE+54Pb9P0Tpr+gtZFHb+19HGJ2Ypt1duilKDGIIo0rXZTr+vCY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by SA1PR12MB5639.namprd12.prod.outlook.com (2603:10b6:806:22b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.13; Tue, 30 Jun
 2026 14:18:45 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%4]) with mapi id 15.21.0159.018; Tue, 30 Jun 2026
 14:18:45 +0000
Message-ID: <c2752d05-617d-45a7-8a82-6c5dffc90518@amd.com>
Date: Tue, 30 Jun 2026 09:18:41 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/6] x86/sev: Disable CPU hotplug while SNP is active
To: K Prateek Nayak <kprateek.nayak@amd.com>,
 Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, ackerleytng@google.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1782336473.git.ashish.kalra@amd.com>
 <ba146ca15b7f76eee386c8c073fb3f1cc36e5781.1782336473.git.ashish.kalra@amd.com>
 <fe9927ad-a06a-4a4b-8122-12644513ed14@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <fe9927ad-a06a-4a4b-8122-12644513ed14@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0127.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::17) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|SA1PR12MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: 201d0212-be52-40ab-aeb2-08ded6b27df1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|921020|6133799003|22082099003|3023799007|4143699003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	bdr73dxXlK01hA2yeXq1G2J74nMRpdlnIvWIU5OAYzV6g3rtIsG2Ck3L5LVJ/ik0VESjYYwsOdpQYoz3ckXkGfDgV8PylksFYbBM8RWAAsajV7P0IbMhmi0mbZn9LveyhxmES8/N1Qpux8TuuAo4lLPL6dHxCrR8Gue0W2RvknzsnkG/flT8T5bnDd2mFAGlYv+r1mlgi/UKib8YsxexbQJe+g/cjpU7vDvsm/1OnuqohD0lPU+hgpxSp4Knw75lZTmq+r6xNhLgQutpRkEoDdRNq0/TJs3KQa/uUKiEzA2PEbAFjCf5vPLGqW/CWh7SeZ1nZCybMB0tA1k3HdRxuV0pznzrz8crUA769KQXM+XxYFysTHRZ14TPUh7YUlQYYazToC0yN00noHfgUjd7sHlLpTd6/NZjWHRofjMQbca/OAQRHyZrL/8eXkGQgJB5AcSVqzBooGyFsn+IuuBm5gj8cTosnZ7OMEBe+GrkTeeHDLDp8JGG2bcBe+4pt9C6alBe6x4MHhjM728TZT2o3/uoFe4qAw29nWilr13o3itK3mrl+uvz68rdWcJcCqnBFr/ieV3wSPzL7BOvYJlUkhqRgD9n4nngqHxbrR20T9b5i0rimhxyZ7NFZ6zq9jlR66hBGvR+s5cc9fR8pr8CMNITkngcejwht3urjirZ8eAGoDnRjTbD+Axd5JLYPqTMDyJJEFgukAUw7yAL6aF+ig==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(921020)(6133799003)(22082099003)(3023799007)(4143699003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3k1bHRvV0RWTHlDMlZDL0drYVFCTXF1OWFmOEw4eUFFcUpKelBIMnJERXFw?=
 =?utf-8?B?ejVaWGl1UldhaXZrL2k4RUVLelRIRnhJQXNSbWtiV2hNY3pENHlSUHcydzBU?=
 =?utf-8?B?S3Q2UG93M0IwUzMzd0M0V2h6bjR6dFVISmpmNVdiaE45M0tpTkZld01tb1Bu?=
 =?utf-8?B?YTYxcEhrRFZHWUZRK091NmErMW9rY09PTlI4eGx4MHZsNzVzVFY0OVV5ODBS?=
 =?utf-8?B?Y3FCNUtOWGdBdSt2V3ZZcHFndWp2TkoreVhPcmRyZS9HendhVEZWcjJOSy9Z?=
 =?utf-8?B?SVd2R0xVbDJIQkkvczh0WVR5QjlMWU9pb09hWk0xd0lpY014bXFGN1hLbnVL?=
 =?utf-8?B?MDFLbVUySzJDSGhHZE9pa1V5OHBRQVg3dVdEYmIwOW1WVTB0UjJsUzZvMlBW?=
 =?utf-8?B?bmNEVzZ6TDJON252c1F1cGo2bHExck80ZFFXQWtwbVI5WWV3OUxSeTFhNXdL?=
 =?utf-8?B?dWgxWHJTK3p4UHlZdEh3UHhYbjVONzdrZy9pVmZCYjdHbnpRTzVZcW1MQzZC?=
 =?utf-8?B?dlpURVhmempMYlBzNWtkbnJUaTZCOUxrazA5a3NkUnRFLzRsTWN3SG9tZUlX?=
 =?utf-8?B?TDMzZDNxSTAzSHF6UE5kK3ZOV1F2bzMwNzFqRXNvQ0NIalZZU1lHeC9CZHBU?=
 =?utf-8?B?TUNGS3ZWMDZBZWpEYlVWZHJZMS9sYXVndmg2QUpIaDZhL1hTRm93b3JzT0hY?=
 =?utf-8?B?clJhOCtaY3pYcmRYb2EvUHFCSlVCWkpXQUZ0Tmx1L2NFUGF0d2tDbHFLVWl5?=
 =?utf-8?B?OUFJSE9FQnJ5UDlncmtFd1RCeW1oc0pra2IzZEZJL1MxQXZ6aXFRQWVLNDl5?=
 =?utf-8?B?RjkwQndNTFFrdkRFY0JRb1VNRXZMQ3BoTnRmVWxpc0k3WVpEZ3RUUmhWcWJW?=
 =?utf-8?B?d1Z5MEJIOGU5N2lLSDFtSVdYQjZaR0lodzlwcE9IZDRNWklPRzk1K3lFWkdi?=
 =?utf-8?B?MmhSMVl2S1kxeWdZcFJIU042MEFJRzFrcVlwN3A3YjNTR0U0QXdCZitPT2Q0?=
 =?utf-8?B?RkZsc2tiaHdwZzRwalF6TFJQbmE4ZmNQeFpUSThGdjFLNnJmQklOR21LcXJs?=
 =?utf-8?B?VXQ3cW9sVzFNd3ROSVdyN09nQ2tSZHBvOGYvWjZRRHpzU0k4aVk1UEhoWEh5?=
 =?utf-8?B?YlN5M3BrZ2ZmTXdOR3VjQU02anhicXZhTHR3ZGZJNGFZY0FiOFF1ZUhqWTh6?=
 =?utf-8?B?eWNRUmtaRnU4NSt3UDgzV0hDeDNMb1MxNkFiaXNQM210VEFGODdyUUtkNkg5?=
 =?utf-8?B?WmFKRlFRUHJrNHZ6UWRKSSthcHpvdGs5WDdaYXhIc3h4NThaU0hnSldoK3Fl?=
 =?utf-8?B?OHZBbitiS3FwanAvK0ZhU0V6QzFRZlBwYW1oQUtBQlVjdEdHOWRZTmNLbDU5?=
 =?utf-8?B?NkkvZWpldVRaclNHdnk2MFRabkVoU3U3ci9wdXRKb0VkZkVWbUcyUURJRGIw?=
 =?utf-8?B?Q2xxNDlPR0FRdVFWNTl4aWVLQ0hKbUQ2RWhMeGJNK1JsVXVSVUIyeWJzV1hn?=
 =?utf-8?B?dWdMRVlZVkVHYjhPcDJSeU5pckVkQWtKb0xJYXFEQ1V1R1d5VFROa2t2MjZN?=
 =?utf-8?B?NDdMeElUMElRVmxIbDdhYnV4czEwdFJBN2NEQ0d2WkFRcFZEeUNTVHlYMzh2?=
 =?utf-8?B?RUVkdEJWLzM3ZWhycThsaUE3OFJzOGlybGdjQUVpRzM5eVVQWlU1TWgzWUhp?=
 =?utf-8?B?blFtZkI5K01wdlZ0VkJLZlFUTzNKU1ZNbllqVW9oNGREK3dDc2tWLzdBL0Mr?=
 =?utf-8?B?bXR0NU9HUDY0YzVWRXRNWjlIUFlzWWRHdkVoTlNnREV1bnRtdStrQ01YdmNR?=
 =?utf-8?B?Ym1RZ0FOYVV0V1pRci85cEFJcjE1VGwyS3l1TUIxK2xCRE1ZSllIWjdqMTJJ?=
 =?utf-8?B?dHJrNDZBTHpNMkNlaVBIWDZDZTVWUmhQSDdzWmlOdUpuUWVoZC9PemlEcWpr?=
 =?utf-8?B?NEVYTDhKQWlLVlp6OVlyK2ZDc1JXZGNSRWRHbVJReDUzRlVqcHhDM3NoMmoz?=
 =?utf-8?B?RnZKNFkwVGVMWGUvWVlheUZlYUdmdnM5dlMvTXR6cVhFSHlDVmhQeWtwdWVm?=
 =?utf-8?B?eGVkOFRwMzBvc3NvMmc5YWtRRUswS2dSQ21pMGhmbWp6eUwyaU11R2kyU2l6?=
 =?utf-8?B?WGZTMWlVTnBGcTJnK20xL3dpbUJObCtiWWdOdUttZGRHNTZsY2xIQmdUVWJV?=
 =?utf-8?B?bTMxTE4yNnY1MXhTUFhMSHFld0s2djh1ZzQxNC9obHE4d1NxdnhPV1VNMEFF?=
 =?utf-8?B?Tmp5RXlacWZWb2V1VTJRWGpSZUdVdFpSY0RKSHNPSUFpR254bWRZUG9CVTZM?=
 =?utf-8?Q?34TH2w46YCZ2QJrmzs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 201d0212-be52-40ab-aeb2-08ded6b27df1
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 14:18:44.5391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OxEx4Q9T96Z4NkDcqS/NWywe9CIoepwryXm1eCXqhGZ1giyeoTtbllWBz+lvcEQ4+ExVM6jk3pdWW0+j2xn8+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5639

On 6/24/26 22:45, K Prateek Nayak wrote:
> Hello Ashish,
> 
> On 6/25/2026 3:26 AM, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> While SNP is active, every memory write is checked against the RMP to
>> protect the integrity of SEV-SNP guest memory.  By the SNP architecture
>> these checks cannot be disabled on a subset of CPUs: they are gated
>> per-core by SYSCFG[SNP_EN], which the SEV firmware requires to be set on
>> every present CPU before SNP initialization.  A CPU that does not have
>> SNP_EN set and was not initialized via SNP_INIT performs no RMP checks at
>> all, so there is no valid configuration with SNP active and any CPU exempt
>> from RMP checks.
>>
>> The firmware determines which CPUs are present from the processor and the
>> BIOS/UEFI configuration (e.g. SMT disabled in the BIOS) and enumerates
>> them at SNP init; it is not aware of the OS bringing CPUs online or
>> offline afterwards.  A CPU brought online after SNP init was not
>> enumerated at SNP_INIT and does not have SNP_EN set, so writes from it are

SNP_INIT will fail if not all of the CPUs have SnpEn set. So if the CPU
was offline and didn't have SnpEn set, SNP_INIT will fail and so you can't
have SNP guest memory.

Thanks,
Tom

>> not RMP-checked and could corrupt SEV-SNP guest memory, and there is no
>> way to keep work off such a CPU once it is online.  OS CPU hotplug can thus
>> diverge from the firmware's expectations and break SNP.
> 
> If this is true ...
> 
> [..snip..]
> 
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 217b6b19802e..66475145b3fa 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1479,6 +1479,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>  
>>  	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
>>  
>> +	/* Disable CPU hotplug while SNP is active (see snp_disable_cpu_hotplug). */
>> +	snp_disable_cpu_hotplug();
> 
> ... then this should be done at snp_prepare() before
> on_each_cpu(snp_enable) right?
> 
> If not, then any CPU hotplug between the cpus_read_unlock() there and
> the snp_disable_cpu_hotplug() here will not have the SNP_EN set.
> 
> Isn't that a concern?
> 
> Also, this patch can probably go first since the FW assumptions on
> hotplug exists independent of RMPOPT bits.
> 
>> +
>>  	snp_setup_rmpopt();
>>  
>>  	sev->snp_initialized = true;
> 

