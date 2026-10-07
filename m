Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010019.outbound.protection.outlook.com [52.101.201.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0C14B95D2;
	Wed,  7 Oct 2026 15:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791387555; cv=fail; b=pyN3FWtAfl+EowWKZ5YJjQwn1P0dvy4vBvlAbhD02a2P8M4P6pwmKjqsTFqt1VqZCAkSXoFSZB3vl48/BYOQOOFgZ2ozYI8H2rw7pviIXn4bCzk96OO8sxBr0fXXKAplXZBwMsiKIHH8aP28AclyHBE/zyc1INYCTjMxUaZacs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791387555; c=relaxed/simple;
	bh=v3FZA9OOCn9bkG2Kuc9wHA1Ox7dSHOnq7zVH6tVrJLE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lrq/MoLAuE4oNqlzQtxidw2qF7ajDpnmJ/I2tjXMiWCcPZpwAElvcFbbgcX8Z2h5AqVpImVy74jVMHn5DK/+USKbmROMkbldG7/BOGkD+w7zKpitfMYX1WO8N9ngvwLntAwBN0XO6oD/f24DptOrcgzVv4q8SpPzGHSkW6ssS0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4PMowi7/; arc=fail smtp.client-ip=52.101.201.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4PMowi7/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uAVgZgT/jV61mZ+Tj3DtV6b22OojD+kKPdqnv4wzaq05x8eQ5g/2hWOxnizJCWhhJKJJl4v5wnaBBUG8eR0T0ow8CNCDN3Ur//DR1mcVPaylxrG0UN00YwvxCo5DbLTpdIrK2Dupqku/mqRAe3D9ScBhfsQnZOz+H8rZ7HfQ5ynvcjHRcUQu3bqA7jk2lmPgYT5OQ5YggQZJrUNSOMveLSc6uqSHbEU9SAN5wyGeGJ02IHr1DNVuk2bsU2JtzQnm82APhhCoyCuq9GvN5luJ77qM1B9yL67/gzhPL1Aru2lSLBl56M/qFD4vUElluoDjGBftS6ZFslUGGfFHDiOYow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5kS38SFFPd4PM1dvS26knCW1hoim9hf1/PjDTkrdt8U=;
 b=SL0vKts1xP+Apfk8JYc2i7A18IYNTgODsDuzGpkuIhn2crLQMsRLzOeoMMm3g1/6xt8yoRo2ar8Bj8WOatr4jzlukwIPQ9ElO35338GlRJm0Si5AAlYnP6DuNby+S1EVb5sPthRS8G+TAClgEZcjVm3y52YsNLISL3jpHDJcTPXDx79y9f9p+R/XpuOMZzTPqqPDYz/de7MWJhbLNo3sx71vvgot+YZKHOxNzR4LUem9wCnnCD7UZD3nExl0skaArHdWs7qyIUTq/+NM7X/9yAKoli89FEn+lAUprLtlvj5LNeSDsLyEKrKRL8AWLx+Jke6jSL3WFaNG9fLQLhWXYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kS38SFFPd4PM1dvS26knCW1hoim9hf1/PjDTkrdt8U=;
 b=4PMowi7/zjhw9nWJf9Snclf934VgGv697IpY/DkXIud/dELVUMmykUs6i/xq5cOXasObaKzqnTnfM73ckzW93U+/6O4H63mtkKqiAi6ABOV9ZqIVlxoktM/pi8duXX+LyIuWEnUXp+mMGb7MdOwipW9Zy6vnkTRhUIlE/6o6H2c=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ1PR12MB6217.namprd12.prod.outlook.com (2603:10b6:a03:458::6)
 by DM6PR12MB4449.namprd12.prod.outlook.com (2603:10b6:5:2a5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.33; Wed, 7 Oct
 2026 15:36:35 +0000
Received: from SJ1PR12MB6217.namprd12.prod.outlook.com
 ([fe80::bdbb:19b0:4f1b:44e5]) by SJ1PR12MB6217.namprd12.prod.outlook.com
 ([fe80::bdbb:19b0:4f1b:44e5%6]) with mapi id 15.21.0451.022; Wed, 7 Oct 2026
 15:36:35 +0000
Message-ID: <27c4fc52-c565-4173-b2e4-714ffc90a0fe@amd.com>
Date: Wed, 7 Oct 2026 11:36:29 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 7/7] crypto/ccp: Implement SNP Download Firmware EX
To: Shantanu Sinha <shansinha@google.com>, thomas.lendacky@amd.com
Cc: mcgrof@kernel.org, russ.weight@linux.dev, dakr@kernel.org,
 ashish.kalra@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
 aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com
References: <c3384e1e-6fa4-4b3b-aaa5-a325bffcd10d@amd.com>
 <20261006210914.2708183-1-shansinha@google.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <20261006210914.2708183-1-shansinha@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0083.namprd03.prod.outlook.com
 (2603:10b6:610:cc::28) To SJ1PR12MB6217.namprd12.prod.outlook.com
 (2603:10b6:a03:458::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6217:EE_|DM6PR12MB4449:EE_
X-MS-Office365-Filtering-Correlation-Id: aee15467-a0c0-4f49-54c9-08df2488c525
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|56012099006|5023799004|11063799006|4143699003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	5TqS7tB/nrLd0JlCDUJmyIWt+0IEFnmkpKx697fBYxwlXvEGgZfk8en+Xl9vlUkVhaD2MUU/1WzHKitkERhhny9OggQXkaiW0KeU0Om49of+VRO6aXv10EKH//G5Cor8Ts6NmLtIr6eFJgMBlv4QkAA0+uSwnRzrJW5ltOGmsox0A0YFI+J9xGVPkduEzTubV4s3pqhrSSQsB8cR/PDuk/xhiAEyZkVftD8bkw81BOeau6ytPgaG0mtopJ740vXC15GebEElnoilnk1/lDmZIe1jnVjXY8dLO6oIH4omlYP18QDdG3hGONgzslyw7u3cDLEuywL+YeFprgJmvNpWucaU4wIaA7/eyLMPVtamvfB2Co8ukl/iA+O/SrOC24CIwoT3YCSUzNKR8AFasZslE5wrrdvHw+TPeEaJocSoeO7qu4W6C/56DW71/HLH/MEbAbgQrbiQadvptK3mHeWAjhfMnn07uuLoAwH7ZJ5R2R4XtOgJtbwY3O12DuaAN3rmG1Fxjy+9o8jOwg6nG1e68wY7ApiQEglQemCPgtaHiGtVVZuLtCCX/NjLWow0PMQutxRtXgWEBQ6qrS+sQxtZf3MNwD2OhEAo6RMijqdaf2fQQsL6i4uWH2p6LASnRI/KnlnRuALc6qzmfGa/lwZvinUIZJ/NuR6DED6gXXNwVM0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6217.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(56012099006)(5023799004)(11063799006)(4143699003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YitXUU1ZaUtYbUVRSXZlODZ3ZEN3YW9OSmxOSGtLLzU5UmRuWmpHekpRN21t?=
 =?utf-8?B?Q2M3UU1xSEQ3TE82Q2ZuUlY3aWpGckFPV29qV3ROekZUS21jK2lSbGdqbkZF?=
 =?utf-8?B?RU9NeHNWYmFBV2ZBSC9seC9aWjJ5WFpLajBwK3VOZXhPRjVtSFFLM3B0RUh3?=
 =?utf-8?B?SGJWaUFoOEl4SER1Q0MvSkJDeU55ek5rMnRqMDBFb3h5dG95bnN0aEpPdnhY?=
 =?utf-8?B?eS83cXNXVG5yN1E1UmV0Y3hoOUQvM21UdncxRnZKL016ejIycm9OeXFUOHZB?=
 =?utf-8?B?OUhvN09TUFBaUDU1RHhIWkdtZXpPWm9BR1ozRGNycUZLMkxOVUt1amtUUjZH?=
 =?utf-8?B?TTM2UW10cW9QR09KM1N0eEtYOW9FTlJicXlxbXFXMTY2ejNwL3hhc3FpUmVz?=
 =?utf-8?B?aGJndHB3bjJGRU5LQ21JdU1XN3pTZ2lUdklWdVNLVUVmOFZMVVlrQ1Mybkw3?=
 =?utf-8?B?eDlMTlJVNURBWFhNNzhxd0ZJMThFV2E5Vnc4SmFBQnk2YzhsSTRXdWxRZWNI?=
 =?utf-8?B?Z2VpM1JUZC9LQ0pVR2hBejZFN091WHpXZXNZTHRWQzVKRG1TS3MxY2NVakxH?=
 =?utf-8?B?cEpHWFduN3dieWRhUUk0UHVaOUFYSFE2NVMrRFIwMmYydXMzakt4YzJ1YVhy?=
 =?utf-8?B?SDlLRmQyelZmL25nL2hLNjNXaXdGTDVWTDFVOTQ4a2hCSDhvS0NWTDlLN2sw?=
 =?utf-8?B?YStLVWRoTUZIUEo5TWEwRytOVVZhOVFGcWlJbEh0YnA3YkxXTFVuL1VlL2Fk?=
 =?utf-8?B?R2FZbHRXRldrTmJBaG9sb3Ruek5RSFVFcnh0SGgvKzlKU3NRQkpRWDVqR2tq?=
 =?utf-8?B?Zk9zbCt6clU4WFg2MnJJZHArZVFkZ2Z5SzZmWDRhSXIzWXRMMXZLeWRUck1M?=
 =?utf-8?B?dGFybkljY1grUXIraHR2anZWNUV2UnRmc2dFUlJUczVQQkJPbnRMVnlvdDJO?=
 =?utf-8?B?dktwZ0tsdmJKY2tLTVZ4TklDd3VFaDBnZmozZEJuVTMrWjZLS1g0SlZvd1p2?=
 =?utf-8?B?OVpMeGwybk5ER0VzQWhvVVRwMUF4UElNOGVNVUhuYkZZV2RvdUNhcWMwd21O?=
 =?utf-8?B?czM2ZjhTWHVaQ3V0Vlp3R0tUT2JKVllYcTE3SnpZeWFoYXdMVmVPU1JVWEpw?=
 =?utf-8?B?R1JlWTdUSWl3cUo2QnVzVlRpdzhwOHBwWnl3cWp5eStnNTFseHdNYzc3TmtU?=
 =?utf-8?B?cURpN21mbDl3azJIWXo4Nk9pMTU3V3JpSGNGZHZTdmRjV2pmb3QrNFgrZTNt?=
 =?utf-8?B?TkhUYzlPYkVwUis1cm1GQVhmUlpTMXplN3ZEeE9OaWRtQldjRElkMXFZcVlV?=
 =?utf-8?B?UGpQNHpQNnFHaWI1eTF5eFJSL2dHS2FvVzRrMFY4NWRyN3cxbEVsejVzNU9P?=
 =?utf-8?B?WUVBVjIyVUxUU2FXc1E3bWpzNk1Kak1SWjBjWWJuZjloaFRsdm1mazBEd0Y1?=
 =?utf-8?B?a1RwcVV0SXpTdUZuYkZKN0JFdzZYaktwQVNtdXUrVTdFVUswU0RVZW5iYWdV?=
 =?utf-8?B?MUtVdGs1UE9vK0NmdXF5Z1JQZEQvZllTV2kwNUxaazkvSmFtZmJJeGxjdWdn?=
 =?utf-8?B?OFVNb2lTOWZSM2JkaVdPT21qNnBUUldXNmN6YnFFMHdWOGZ5ZWtjUGxuZW5P?=
 =?utf-8?B?L1RPSmx3OVhMblFtb0JzbXptZFRVRDloN09Ndy9yb1Qyb3BCZ2RNeExpaVVr?=
 =?utf-8?B?UzZkY0V6SEdDdGlxMU0vMGtNQ1ExV2s0NnliV3ZWSE1rSDZVTm1sK3ZKVEtB?=
 =?utf-8?B?QXpGcTVHNjd6TXVFN2d2TjhiU1g5OG5vVDRIV25Oa2QvR0w4RVgrbXBzZGdD?=
 =?utf-8?B?TVZFK0JZZmhHR0tibnVLN0xKZ1Q1cVRDSFlTa2lCTDVLSzhUc09manFaNVkr?=
 =?utf-8?B?Q00rV0ZIWEc5blBYS250VktNdkk1QU9udlM4TVdDTmMzcVFMenVuZ1N1U1hH?=
 =?utf-8?B?eFdkYnRVR3RDWHJwR3JLZFF1OGJtMy9neEkzNzVTcXpOQlUvcVN0dlY0WWNR?=
 =?utf-8?B?Z0NCVjRDQ0IwNHpNY2t1YytoRHIrUjFRWXFRZ0ZQTjZ3cVd4YU9JcUF1YTk5?=
 =?utf-8?B?QkU4Q2FaeGJlNGtta1BHWTc0NjMxK21Ld0tNQlhTbDNTdnZHRm42WktST0Ni?=
 =?utf-8?B?ZitUK2tiTUZJd24ybFJ6RXY2aGwvR2UrajBjN1FWRnpsbGl6TEZoRDgyaHhN?=
 =?utf-8?B?eGZyVnZ6bzA2YmpGcjdZRysrZSt0cmJ4Q2lMcEpOc1F5cU5aMUZHWUoza2JF?=
 =?utf-8?B?TjFRMDIrT1YrV29LQUJZa3o0bDZ0RmkwckR3L1ZNL2U4R3o3SmdpelFwbUdK?=
 =?utf-8?Q?/gyXlESZYl7IzK5XBd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aee15467-a0c0-4f49-54c9-08df2488c525
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6217.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 15:36:35.2820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jGbPUpJgWZ5HduuXqX9de4JFLsjD2AV7/sqTYC/fhOCj3eN0iHAXB4s6lWC4b4BjOXLZD4rvGzyJRgDa8kvKgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4449



On 10/6/26 4:09 PM, Shantanu Sinha wrote:
> On 10/6/26 12:55 PM, Pratik R. Sampat wrote:
>> On 10/6/26 12:32 PM, Tom Lendacky wrote:
>>> On 10/6/26 11:41, Pratik R. Sampat wrote:
>>>> However, a fresh allocation with SNP initialized just goes through
>>>> rmp_mark_pages_firmware(), so my understanding of what the new firmware needs
>>>> is the reclaim -> make shared -> mark firmware cycle, not necessarily new
>>>> memory.
>>>
>>> Sounds like some good info to have as a comment above the call then.
> 
> I had looked at cycling briefly, but it gets tricky. If we reclaim the
> pages in sev_fw_upload_shutdown_platform() and re-init gets skipped
> because of RESTORE_REQUIRED or a dead PSP, the buffers are still
> allocated but aren't marked as firmware pages, so all subsequent paths
> need to be aware of that.
> 
> Reclaiming after the update avoids that, but relies on the new image
> accepting a reclaim of pages the old image's INIT left behind, which I'm
> not sure works, though I haven't tested it.
> 
> In either case, failure handling also seemed tricky, and the fallback
> would just be free and re-allocate anyway.

Agreed.

> 
> The only issue I see with freeing is that the TMR is a 2M buffer that
> needs to be contiguous. If the new allocation fails, INIT carries on
> without a TMR and without any error (it's only logged in dmesg), even
> though SEV-ES is now disabled. It should be very rare (since we did
> just free the TMR and can probably get the same block back), but it
> seems worth mentioning in a comment.

Sure, I can add this to the comment too.

> 
>>> The memory holding the firmware on the call to the ASP has to be
>>> contiguous, so you're likely to fail on the alloc_pages() if the image
>>> is too large. Up to you if you want to keep it.
> 
> I think it's better to keep the explicit check and error message. If the
> size check falls through to the alloc_pages() failure, userspace sees
> device-busy, which doesn't communicate the right intent.
> 

Ack.

> One other small thing. If the platform data refresh in
> sev_fw_upload_write() fails after DLFW_EX has succeeded, it returns
> hw-error even when the PSP is still alive and the new image is running.
> I may be missing a reason for that, but would something like this make
> sense?
> 
>  	if (sev_get_api_version()) {
> -		dev_err(sev->dev, "SNP platform data refresh after firmware update failed\n");
> -		return FW_UPLOAD_ERR_HW_ERROR;
> +		dev_warn(sev->dev, "SNP platform data refresh after firmware update failed\n");
> +		return psp_dead ? FW_UPLOAD_ERR_HW_ERROR : FW_UPLOAD_ERR_NONE;
>  	}
> 

I haven't typically seen this fail for any other reason apart from potentially
failing the PSP call but I do see a few paths where this could potentially
happen. So, only returning an error when PSP is dead makes sense to me.

> Apart from these, everything else I tested in v3 works on Milan.

Thanks, for testing this out!

--Pratik

> 
> Thanks,
> Shantanu

