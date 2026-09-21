Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012033.outbound.protection.outlook.com [52.101.43.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA654A5EAF;
	Mon, 21 Sep 2026 15:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790003453; cv=fail; b=AQ63m49787CIxS95e84n5+8EUdYaWH2hbglN0z3Q54cZJ6YVYN4+5D7HI6ykhvh2XjdVW/O1cs5MonacOSJCPn57iOM5g7YcQd2/3ldd9uD5T09gzuu0GupkhIVkTFy/WmpuyzrV071zYsKius3JRjg2Cnf6fDbPc3OqcB6hv8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790003453; c=relaxed/simple;
	bh=HW07MZW7Kf5E2OhcpU/Hag2AP579j/bJvIRVK7j+5Kw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PXChE33jCzlMG6N4IRZfY0grhqyCCGLlTI7RTSZxW0AgqVRHpOJTX1xwzt7p+9fc9VXo0GxEJmnFUudQfSqlHGjpAMQKpKOAnqO93IQ9+Kk1XnnqG4ii6Qh4PaEr5fALELZm1embDOYKTOQIaRZ4o6iqAVWmoVorIK8d0VP0pNU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zDvo+L6R; arc=fail smtp.client-ip=52.101.43.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zDvo+L6R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u788Y+BbFDmpTQwqBX4HsHFntjfyCB/gytzukHcgOpc08ByPKYimD5si0/3YfO26nFpgZ7d1rsygoVd3yDgA30q6ae+zQKjzFDbMQr2y2mF9PiCfyZEBU12BvEk7j96eO/ZbSDxOpeKKFOhWB8XbYFZx+xHrLgZWnReY9M1ShIWZr0qbJzGhlObQ6gg2Vj99jo7MqRZGd12rI5VrtZYVNYZy7AP14mdqzbNNIONafYmP79tBqVL84gBCLeYAtTKLRSSC0+yzgEX3p28ID0XvsaKU7TyjzQwctJFruu+ehlb+jc07wp1JzK73GkVVVu93YBduLlpIx513w08L9bWVxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ienidFfoN6IVkHBUMDqdhCvqAxPe511B67mgjCDvMNs=;
 b=UR36mfsdj89eC86doghIlua8/l113y1Lb8LHYLojAVWYcTtiwBfvH0/XVbeTlB7v2QwJakhtJASYLsjrCp+rSfchXQNduqPPlXziBGm/htjLWo/1MhWCaH0BjJ0nhGm/Qmgq6b9SFyNuYcwZhnSg95EKc7mmPHkklR3KjXnN8Sk7dntXBIAOVnN+xay2ixi6/RSQQjBkIal0I0R40a7amb3aJPR9ef8ehTsCE4mB/6w/2gvlzB8ElWcjW0WdGjrgiNFXv4JXu27T9Bbuawh2sDScp2OHDU7AKiWIANa/2DeinISBf8lcNicPkwOh3/5xOqiQldJ38WLf3QvQlIFitw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ienidFfoN6IVkHBUMDqdhCvqAxPe511B67mgjCDvMNs=;
 b=zDvo+L6R4PlrVLE3S7dKkTyFEx01ECcZXl1x9IxMZNLByGCmNzUvSU+89+9mr7/Q0aXabD6B96/W05W+hxzbp7MzprUTe4LXEjCLL1X+vgyjldtFuhh+Go/gmN2Ii4GMEfL6ToVuAdeBAKo+GcefYbJdiPEkNfjxD1kQaCIzE5k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH8PR12MB6914.namprd12.prod.outlook.com (2603:10b6:510:1cb::21)
 by LV2PR12MB5990.namprd12.prod.outlook.com (2603:10b6:408:170::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 15:10:46 +0000
Received: from PH8PR12MB6914.namprd12.prod.outlook.com
 ([fe80::2893:177a:72b0:6000]) by PH8PR12MB6914.namprd12.prod.outlook.com
 ([fe80::2893:177a:72b0:6000%7]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 15:10:45 +0000
Message-ID: <10469a97-1e55-438b-a9cc-7a7cf650c104@amd.com>
Date: Mon, 21 Sep 2026 10:10:42 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] crypto: ccp - two PSP init fixes, and the AMD BC-250
Content-Language: en-US
To: Mattia Tadini <info@mtsistemi.it>, Tom Lendacky
 <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <178984289056.12336.17662860552012704364@mtsistemi.it>
From: Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <178984289056.12336.17662860552012704364@mtsistemi.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0001.namprd10.prod.outlook.com
 (2603:10b6:806:a7::6) To PH8PR12MB6914.namprd12.prod.outlook.com
 (2603:10b6:510:1cb::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB6914:EE_|LV2PR12MB5990:EE_
X-MS-Office365-Filtering-Correlation-Id: d8b89e6e-950d-48f7-fed6-08df17f28267
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|10067099003|56012099006|5023799004|11063799006|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ltPrbZmnyVVKjSESmmFIuJtT6KDyOiF0dB3DWLSWVJC53x+QLyUWMSUePtC7tkDip1g5ek5/h25w83WIw0htLKRCPQXvLgu2ADr1gYT1JC8G7mEdkiFsSEYJZ3No376cNgcXhY9SYBxrPRydAcTPLapOXSsjlgT6AAyxTVSCyM5CIp4kUMRH4eotUmp39SfRkjaN0ViohV/cwcEvxCEl6BHpQXzoGRykKtuygsjacZH+VJO0S0BGDAq1Rey4rxJQzJFkEMnXLE3i8aojlr/n0gmQX0RaIUTRKJ7GcjeAOdcemwcxvJMiHuMFCeh0cENtlRW9ga+0Yj2Vz1QK1xt306+jRIpTXhlhvkJncUSsW85Vtb+oDioXofiaOKXXoK1UsPldd3gHtJJtc+ivWHQ1Mj5WtUdpbWBOTeZ0cKYKmGqxDtLDgSafdJjIDC3M1hBVPYAjZNrg+5hlM1MImx16TDHPP7Uc8YDYcLWi1o+Mz83QHZqYaGs19ICYtvm85IMjR+aknkGeRzHucQyMvcC5yWl63YDa6I4XjJMTIcs+l79RAy00sjHKDLHL+/eP+d7VFbSNJ7OOAkMnkp11BRdk+4xkPmTWy7I3AeFSxIZNb2PhIS6hZ9mQvo2+SMzfYbD74oBo2flWTLjvR+zeX8NAIQU+OD3WPvvWTTTS3Gk+9Ds=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB6914.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(10067099003)(56012099006)(5023799004)(11063799006)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEpOd2VKa29oS2s1b0Mvb0NORldPMVB3cDIrK2FDUFFHLzNUdzdqWGk4azVY?=
 =?utf-8?B?S2VIWC9KV2txZjZhQzhicXkyMFM2aVdUOHU2S1pLTjFKcDdrUTJobklmblJq?=
 =?utf-8?B?OS9WSWNaaDBHdmpGb3VobEhaNWdldHZ5Q1loRTB6UTh5cVZ6TTQ4bk5sRzhO?=
 =?utf-8?B?UkNsN0R4MzZDU01XMmQ3Zmt4R1dRYlg3TFJiRDIyY1FwTkllOWZmbE92bU1T?=
 =?utf-8?B?a09Idk5lOE5obFMxQmFjdEJSWFM5Y1l2N3ZZbEtGc3NoMVk0d2dWa3NQUVVQ?=
 =?utf-8?B?cDNKNEgwTlRUVWdjRStYQVFLTWUxSWhZSHVORW9pa0lJOWczM3RIcGs0Wmxo?=
 =?utf-8?B?aU1RU1lHcm5TZ0ZnbTBUOWE4eVQxTGNjSEs1Rk0yK3lsMm53OHg0UmdNNHdz?=
 =?utf-8?B?VkZvRStKaHA2cWk1OUtndmdnbWJTWGpjOHNHazhzYnUzOEcvQXFQMnFINGpI?=
 =?utf-8?B?VVNPc3p4WGxFYnVBTFBzbUQvdDFGVGwyWjFtd0V0a2pwVEpId0l5YWFDM0xM?=
 =?utf-8?B?RDJpVDhXUFFUVGdZQWdWdmtiS0FRNDlMdSsybUlCWFl6aUZ6VnFPbG9CK0xw?=
 =?utf-8?B?eFI1dHR6NGtnVW0rWWI0NXpUK2RRTk1OQzlqM3VDVFBzb1pRcGZYVVhnY2xx?=
 =?utf-8?B?SUpSUGo2VFV0dzl4dkpoMUJvVXB1NWZoT2M3bWRQRWFnaDA4R05EQWh2Y2tn?=
 =?utf-8?B?dXpDR0wwbmFuQWIvVHdmTGdveU9DWG9NdnhqeXo1ZEg1SmpaZEt1ZUdQWk5h?=
 =?utf-8?B?YmJ3MGtzSmR4ZWhJM0RqV2p3aFN6cGFaVGFmSXI3TmF6SUdzZDlDc20ybEpl?=
 =?utf-8?B?WDlpYi9sVkFSUWxiNldRcGlKVkVGV0FsUkFUWWJMdnlnSGxocmhIWVhVc0J6?=
 =?utf-8?B?blluVFRTbG4rNWsxUTJEYlZUTVJ6dnlaWGFvOXM4K2JCak1adlZ6VzRZakRt?=
 =?utf-8?B?Y0FDY01QNTdINkY0alVMUmsxRy9JMnozdy8xQys1SDdJd3hjNHNIYm1abkxN?=
 =?utf-8?B?eDJ3ZnpoSFdncmhqM2N5eVFvVVFVYmNCUFNSd01xOW5FSS9MdDF1OWovTDAv?=
 =?utf-8?B?RHo3ajVOZmZQdC9wb2dSeXdFWW82YkxscVg1NEJkajBMQVlSL3g1bERvVUlp?=
 =?utf-8?B?VjdQRGkxenVIVXJFQWtlQWcwY3pjVjRjRDJzM21BM3RqYkNsOXYyOWt3VEp2?=
 =?utf-8?B?ZW5vaDZPZGZ3blZxbEtqTWluY2kxc3V5NHdhalVjbG5MZ2dUR2ZoaC83T0Zj?=
 =?utf-8?B?Y1lhS25VVjVqRjdzellCZS9jaXoxMldVMThMdFYzSklSb2pnQUh1THk1RVVM?=
 =?utf-8?B?RzV2TXQ1aGdUZnQwRjcvRzRsSW1hMnV5ZUFmNnBOVTZBejFOcFd4R2xnUFhy?=
 =?utf-8?B?TlVjNmJ6SDIxMkVUb3VGMHQ3dmhCNFF0emFxVUJ0cWM5emRKRkNhVkZpRjRY?=
 =?utf-8?B?UWJ0RVJLQ3VvUHJMeVFJUjhWMjkxckJhbFN5VklVWFU3d0tRMDhlOWx4bkpF?=
 =?utf-8?B?QUtJWlo5ZjR1dkQzVUFra24vbTAvR0xQUkNLM1FWRlNHcFFtTlJpaHVrbi8y?=
 =?utf-8?B?Z3BySzVpRXVwS3VML1UwcEdWdzV4WnpEOUIycklPTmNMcEFSV2tSd2Q0ZERK?=
 =?utf-8?B?dXk4UDhuaHVVSDdSUTk4TWlXYTRZNk5XQS8rYWFvYUtVVy8yL2dBcDRNY09j?=
 =?utf-8?B?Wk1UOHZUbVhkc1hFQklGdGcxZXNxL2dvL1JsK0dzYVpEQnBGZ0FnSE80aWE2?=
 =?utf-8?B?NDVSa09HMCs3TW5SKy9VVlN1SndwYVRqc3A0QWUwMzFpMnlFYWFuNXlLSmI5?=
 =?utf-8?B?WHJ2Kys2eWQzbmNUZTgxRnFTL2hGWmZWQWI2S3VqNkU5UVRwakdEM2JNMU9z?=
 =?utf-8?B?L1lMaDhoL0lwKy9XTmgzNUx4Q0FMR2hTdnJjZnVHYjFCUUVKdkdZb01WYkcx?=
 =?utf-8?B?SnhUS2IwTGRXejA1M25UL1RIR1FuRjhjYWFic3RhUUJyZXFhY2hpT1JwbW5B?=
 =?utf-8?B?cGV0VnZSaWppTGsweVQ4MnlmZkU0VUhRZExLZURBS05tUDIwUmNDN1hzTjM4?=
 =?utf-8?B?SjBseGhNOFJFc3ZjaDdiYjhHNFpnNFREWVgwWVJGaUV1cjZ5WXM5dnVzeU1x?=
 =?utf-8?B?ZTVnMVNjVUE4NlhuRnBGSFZUdTZDL01TRGJOOHlKcDJhZDZ4M0Z6RzdRRncv?=
 =?utf-8?B?RlBHR1VkK0VlTUdPcG5JbmV5ZnRWeDNzZzg5dy9YazlVRm5QalNRQnJ2YkxI?=
 =?utf-8?B?UnFmaU1yd1NVbEF5cHNaSGQrTU85QWFOajVPSFk1emk0NnlEZW9xdUdaWG54?=
 =?utf-8?B?cFNWTlJmL3NEcjhXRmhkTmlsbEtqS2Qxbkc2RktCMTZhMDlmczFLZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8b89e6e-950d-48f7-fed6-08df17f28267
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB6914.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 15:10:44.9586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IUbfH0GK3mOnI6mXxEhJ/m1cdxRV6FKHcu5oTiDkjb8zPrpvQtVsKN/zKUGQ833q7yHZcpfTa6rD6OQBzPr65w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5990



On 9/19/26 13:34, Mattia Tadini wrote:
> The AMD BC-250 is a Zen 2 APU board (Cyan Skillfish) sold as surplus mining
> hardware and now used as a small desktop by a fair number of people. It carries
> an AMD Secure Processor at PCI 1022:143e that sp_pci_table[] does not match, so
> the device has always been left unbound with its memory windows disabled.
> 
> Adding the ID turned out to need two fixes first, both of the same shape: the
> driver decides what to bring up from the hardware capability register alone,
> and then uses the psp_vdata pointers for those features without checking that
> this device has them. On this board the two disagree, because the firmware
> advertises a TEE whose ring never comes up.
> 
> Patch 1 is a NULL pointer dereference in the sysfs is_visible callback. It
> oopses during probe. It needs no new hardware to be reachable in principle:
> any device whose firmware sets the TEE capability bit while its psp_vdata
> carries no tee data hits it, which today means pspv1 and pspv2 parts. I have
> only observed it on the BC-250, so I have not added a stable tag - please add
> one if you think it deserves it.
> 
> Patch 2 stops a failed optional sub-device from taking down the rest of the
> PSP. Without it, a psp_vdata that deliberately omits TEE gets nothing at all,
> platform access included.
> 
> Patch 3 adds the board. The register layout was read off the device rather
> than assumed, and the numbers are in the commit message.
> 
> Tested on a BC-250 running 7.2.6. Before:
> 
>    01:00.2 Encryption controller: AMD Device 143e
>            Memory at fe700000 [disabled] [size=1M]
>            Memory at fe884000 [disabled] [size=8K]
>            (no driver)
> 
> After:
> 
>    ccp 0000:01:00.2: enabling device (0000 -> 0002)
>    ccp 0000:01:00.2: platform access enabled
>    ccp 0000:01:00.2: psp enabled
>    # cat /sys/bus/pci/devices/0000:01:00.2/bootloader_version
>    00.1c.01.02
> 
> with the platform mailbox answering commands. Dynamic boost control is probed
> and cleanly rejected by this firmware, and HSTI reports nothing because the
> security reporting capability bit is clear. There is no CCP crypto engine
> behind this function: the version register at 0x100 reads back all ones.
> 
> The series is against v7.2.6 and touches only drivers/crypto/ccp/.
> 
> Mattia Tadini (3):
>    crypto: ccp - fix NULL dereference in psp_firmware_is_visible()
>    crypto: ccp - do not start PSP sub-devices without their vdata
>    crypto: ccp - add support for the AMD BC-250 secure processor
> 
>   drivers/crypto/ccp/psp-dev.c |  8 ++++++--
>   drivers/crypto/ccp/sp-pci.c  | 24 +++++++++++++++++++++++-
>   2 files changed, 29 insertions(+), 3 deletions(-)
> 

Sorry; but what's the point of adding support?  You can't access the 
crypto engine, it doesn't run SEV or TEE, it doesn't support DBC, it 
doesn't report HSTI.

It seems that the capability register isn't even populated on this system.

To me it appears the patch series is a lot of "fixes" to let you 
read.... the bootloader version.  Am I missing something else?
