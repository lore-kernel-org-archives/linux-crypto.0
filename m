Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010031.outbound.protection.outlook.com [52.101.193.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798433546E0;
	Mon,  3 Aug 2026 22:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785795751; cv=fail; b=Rv45NCO6e+t3FMpIOMgjxrZlARZ12U7DrNyC5eh1PoqqZxzvuTw0xJab+M3UQOr8VzeqcoTOHSyO3Xcq8sEaR2s0MMAfThVd2hF6sEycSK5TOTkS69Qx3lebPmbEyuke8mx3EveOdVEVVCwgOAo3Mwrdw3Wu5jI9rSd8nDIaE/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785795751; c=relaxed/simple;
	bh=fkge+sE05DfIT6GScc3hMbqZmPZ7nsL7NX3Yk0Gzwmo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Tpf2MLuBSjEV5i91ZUajhyKkhUjRmH15TomuutpD99iexsLpBzsW+FTazsvQFavJXyeqANm6JraczEraGqxx+++tUqdfr4tVUyW1Jry8CQcwl2bTrRCs3ZteKhRahXu3H1CRUvjROy5rQrodUTM/6OX0dtnOQuHHHNLX3K5Ty/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3GH17UC3; arc=fail smtp.client-ip=52.101.193.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3GH17UC3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=napYWoC+LZtXqaB+CAnOR9a1oZ/yEOP/jroSl+SgogaDNuX5c1EimJ/bu+JVYTy0hhZjoO21yXIxGFZdGCgrETFnRJ/MAOv5TTy6ZXftpSZAI3HAiHW96R67uljDX7e6J4WY8LrsNev8+mFvpKLps3guGd+DZEFqCc1mgtmEuok2IOeY9ATzzGf0R8vC7h8fLHREXZCl/TFL/2hKLBUNG3mukKLk9RvUxmanjNJdkUEwh+NGIQ4sqJxfm0Q6piHXNprAED3T4dV4OoXHhx2c2bRWHgHhA2zBFtIVH0RtgWYltNBqw2L+Nlw+OY8ckDlw8EZuw8Xfykc1AM5MuKNtFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8GGZquf3pDA9MPNto8zHC3Ql+6NEpjMU8HXzBPMRn90=;
 b=T9grzCdrht+1CVx5LVPhd5idb2feZEBtXczCQCH9wxmCa5ipWp6/GKyAL8F4/J8PbdTwBIT7QwzhdCPFXuVAzJYBZ3hGrboZssYiC7pG29EAalgojWgMwke5SdmRX3Ljl/8P3czvTxDRFdEGdspn4RxC1XHTpy7kYpUM1hDcXuR5C2X5Cvk9r3n2TAsgUkdtKe2VJs8AiIR37GBxt0/nq5sNyWa+ibdsg+Q34jGSBvIWTNzyiOOTruv1VD3kmBjEy06ZwlnL7bE6hQ34C0i8NJc872i0A7vdhogMBREeAcvlgkdt6NOZ/mZ1uY97snALTodZt3EsrO1AEulcSPeuLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GGZquf3pDA9MPNto8zHC3Ql+6NEpjMU8HXzBPMRn90=;
 b=3GH17UC3F0r26UGECyP72c9oHzf4nDxJjPqnHAabWFROY9gXe2A+yzRGU/57vNHrkByZGbzLSX+jo03zqWxk40vFBWUxdAeBxSB+ijFS0qHmeFfOa2He+JbsptpzZqIX9hB/57bcqotxxmgE4Wi6Ll03mCR78VK7UPE3Xar3fmo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA1PR12MB9468.namprd12.prod.outlook.com (2603:10b6:208:596::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 22:22:23 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 22:22:23 +0000
Message-ID: <59e8b0cf-0ab0-4b7a-9e05-4de6f83c9a10@amd.com>
Date: Mon, 3 Aug 2026 17:22:17 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 4/6] x86/sev: Add support to perform RMP optimizations
 asynchronously
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <748785f1-f176-4f0a-8b8d-eadf46b20960@amd.com>
 <178578506318.2377606.14791252769672870038@Ubuntu-2204-jammy-amd64-base>
 <df5f5f6f-7278-42e7-bc7d-8e56187d1438@amd.com>
 <8DAAEA48-F2FA-4D52-8E56-4B7213155F12@alien8.de>
 <d7a17bde-4af0-45ad-96bc-4717a1fa1545@amd.com>
 <60B4B369-19E7-44DF-BCCF-FC8DD851B2E7@alien8.de>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <60B4B369-19E7-44DF-BCCF-FC8DD851B2E7@alien8.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:806:20::30) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA1PR12MB9468:EE_
X-MS-Office365-Filtering-Correlation-Id: f0b990b2-bf3d-430c-0ec4-08def1adb104
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	AREljTcQlzjn4oDJgF+tu7GX9Bpmp6+kK8JGdHvQI5vQR3X2E6PI/xB8u4AKXivWp0aVT7ACVhrLsvKAkO2O5p0FImfES4/I7JZPk9pKcPPgT7ubaYPL7ZFLEO7031YOwVb2z11fFZ6qsIcHlo4AEELbQQvZEcxHl8sywhqxnpSUt4zdEgADKGf5VUuq+AZ+mwzny9SiEzQIFC2yOpf3B1X22+YiWNNmATYTiOsevOFD2WAg4jSRU0XohTIqRVlXgUj60tULVGJM4EeytQyH6TSbnSvQYGCltg3n1Fc41HtYF+zvztCRYOSFZDL8QtqO6OMv9Ag7Fy9e7lVu1RxFs15iH2gfTXm1fZS2AEHjXi0981MPesDPSm2C0e+RyY2bH1eghYAXaGCj1rjbj6aDjvzUq4uISKSo640juGnXNPnrVH4Cwvm8gPX60yN1u50vHYAsLfjj+gQ+8iHwIJiqnuY/oH61g4v6Ah0V3lpaasxa42v96gxOPE+6sdI26QH+YKr4XvL925fzeeZsok/65DQU9dDzUAjVE3yqc2JQQjqDjwwanIHaeoTDJrbnoBhXleqkBt2RDIglSZnU2tm6t22wVbR2Qgkssd59t1CGpLFvnZusD6nLJaJbAl/IyGPmh+NapHsVjgIJi1rmAI+w7Kf2TIHw1+cnXa8CqKD/Cy4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1pYNHBBU21hWC9vb2lRTnM3eHJzNGU1MmFNbEJQM2g5OHhSR1JwL242UTRE?=
 =?utf-8?B?YkNCcEZJWlhEWktVYThnM3E3NjNFbHF3MnBLcnZPaFhyWDFnejB5R1BHdnhx?=
 =?utf-8?B?UEk4TmFsVGlQV1MyUHNZOTZZK0lSY2I1UjZzWXpuRkluOGNFNk1tNWFPZlNK?=
 =?utf-8?B?S05kT2pBcWhyV1AvakxjbGQzb0lOYzVmS0JwemY4QmRIWG1vcnFhNHIyQkND?=
 =?utf-8?B?QVRoSkx0SWJobEJaalFWWFpZNlVNMUpOUXJFeFpUdStuSXpVNE0xRlFDYUlH?=
 =?utf-8?B?K0oyZFA0bGxSSGVKL3REcW9uWXFiTTVkRUQ3NEdsOUVFVzc2WFA5MHFmNUhQ?=
 =?utf-8?B?Vjh3d2REZGt2bjBYL2hjTGxVejRrQ1JmR21PVkFQMzVXdEVUZVI3L2drOU5p?=
 =?utf-8?B?Q0wyVGYvbUlpbVc4U3BMbkxsQ20xWldCYm5EcW56azJTRUxxMXJoUVk3RC81?=
 =?utf-8?B?Y0U5TE1JQzNVQWRoMERRM1JPYlQwbTFKeGJ3L2lnK3FWSHZSQXlLU2N4MGVQ?=
 =?utf-8?B?T1FEMkpjRXVtU2h1cHRKUW1WZzFwNS9xeTRTKzNvOGFJWUhWY1JGd0l6MmxF?=
 =?utf-8?B?dTJEQlo5Uk5QeFBVMUQ5clNoNFdDOFgyakRoMElpS1hlakV4MFo2Yk83aTF5?=
 =?utf-8?B?UFQxOEZ0cGxsa3g3Y0lXMWlpMlFTTGpqQUFCUEp1aC9CbnU0MngyMFRzYWVL?=
 =?utf-8?B?Q3BoMHl3Qi9qTFRpaXVTYkQ2T3ZtMGdaQ1hkVjlISFlrc2FPL1FtOW1CMGF1?=
 =?utf-8?B?MXBQMk5EU3RvUzNEMEJjL0VWWW15djVnSHNmaUdsb0pzdDdLanVOVXA4dEVz?=
 =?utf-8?B?cElGcTl4NVB1TGdsY1ptQVpUekRxWHI5SjRNL0JPWFVpd3YrMnZKTElSaVRJ?=
 =?utf-8?B?NG1LMExSSEVqZHhkcUNsZHBVQjVOdG1rZHc4ZERpakt5MXpIeWQwaUE5bitn?=
 =?utf-8?B?aDFhelljNysxSnNmVmtoVG5YelpTVW53ZCtPbnRiNHBkVksrekd3OWIzZXc4?=
 =?utf-8?B?bmwvWFZmbnFVcURaRlFrbGUrRzl2dzdKSmg2a1BZSTRjNWJMdldONlExOXpk?=
 =?utf-8?B?WXlJM0RuTFcraGszbkZTOEIvV1ZQMWU1NWpmSmZUMG8vVnJlTTZBc2NQWjNo?=
 =?utf-8?B?cEJ6Zy9lY1g2bWhsVlJrNGgwWjhZYldLaFJ0Zm5CU3BYSEhPdVRiTCtvWmUr?=
 =?utf-8?B?RjZvYktHeXdtWVpPVzVKbkRnWjBHUGhZMjA2TXhBODlZd3pxSklNWWxZRlZM?=
 =?utf-8?B?bnpPTU54S2NmWGRYZEtsOXB4UmFlNTQ1RDd2cWt1V1hvZHN4N3dQTWt4NGxM?=
 =?utf-8?B?NnUrdFl6bTNvT21kS2VvdDJPN2RHMzhHK2VuTDZEcTNEYU1qWGFtWXdmcWU4?=
 =?utf-8?B?YkpWemhnck5QWUo5U1JOL3N6UTNGalVzYWp4ZENjSkpQZ0Y2TmpCMUlpS0tq?=
 =?utf-8?B?MjVVeTNUY1VkMklSa3U5UmdwNENTcm1odGRJaXBZS0VHenNzQVhHTnl0Zkkz?=
 =?utf-8?B?MTRaZmVpcmpSb1NwTGN1QnRyNEpCUzhpQkpKZWZ2Z2pDWExXVkZza3BCY25S?=
 =?utf-8?B?N08yTlJSMWlnaEhUcXMwTVlXTkxSQ2hLaFhjZlFLYmdHc0NwY3pXUWxMVG5T?=
 =?utf-8?B?ZjhMQ3BLN3Jwdi82dVpMclJBNDFub3NnaGVOam9ha29XZ0oxaXk3NU5zbExR?=
 =?utf-8?B?dE9XNnphNWVMeUx1cnBIZzY2VkVHRXYwT3BVaTZHNGlraVpMejFubm1pTzMw?=
 =?utf-8?B?NXROU3doZi92UUhLTXRYRzA1NFN2a2o0K2RHYWZUb1BaeXZYRTYxM2pJRCtS?=
 =?utf-8?B?eVBub28zczZwNGhEK3JYL1BBM0IxR3Z1Q1VySDZuNU1LVDJTYkUzb09jdnhq?=
 =?utf-8?B?RWQ5N1o2TmcxdlovUXBlanFZazArelJwbDFJSTBwcFAxcFF6dG9mbGJtalN6?=
 =?utf-8?B?RE8rTWxqSU5DdkVFTERGNzNRTkh6R0dyZ25ubzQ0QS9ac3dHSUI2eXpEejIz?=
 =?utf-8?B?RG8vQ0tyRmovdkJRQjVzZHErZWMrbG5DMXlpYmRDQ3RqSmU3MFEwL0dBVXdZ?=
 =?utf-8?B?ZDMzQzBsZktmNUdYcUMwUnI2ZVIvLzlFV1BDTStWdjdsZUFmT2M4SmZNUEhk?=
 =?utf-8?B?QnMyRFVPY3JjVVNyNnhuL2l3b0lscVVvQ1M5STV6cUN4NkJFSm1hRHZ0bDF3?=
 =?utf-8?B?SHlZb2FFL3NWa1AwaE5xRkVEQjMzaHBuT2c1TlQ0WUM2SVBvVkJmaXF0MElm?=
 =?utf-8?B?ZmNxNzhyU2dFdWZTSkQ1TGp2RGc3dUo0bm42OHR2WHNjV2RGaEhFNWFtVTYz?=
 =?utf-8?Q?wQ4lIAsCplkNCasOdL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0b990b2-bf3d-430c-0ec4-08def1adb104
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 22:22:23.6836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJTqy1Ny88YyDBZNWnv+6ulUnRZcUEZlCtFRAUhuLsPS+ZIRYpB/aDbgpvLixRJcWR+JQYZfMC/6fiJslZRdIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9468


On 8/3/2026 4:38 PM, Borislav Petkov wrote:
> On August 3, 2026 9:23:41 PM UTC, "Kalra, Ashish" <ashish.kalra@amd.com> wrote:
>> yes, that's what the "optimizing during 1 GB page cleanup" sentence is about:
> 
> What about doing the optimization runs periodically?
> 

Periodic re-optimization was already considered in an earlier RMPOPT series and dropped because of being too disruptive — 
a timer-based scan would run on all cores every time it fires, even when no memory has been freed. Running it at guest
teardown (batched by the timeout) is a better fit: teardown is when large contiguous regions actually go back to the
hypervisor, so the scan only runs when there's real work to do instead of on a fixed timer. The case of a guest freeing
a 1 GB region mid-life is then handled by the 1 GB-hugetlb page-cleanup follow-on, not by a periodic scan.

I will also like to avoid looping on this — periodic vs teardown was already worked through in an earlier revision, and
this is where we landed. Happy to revisit if there's a specific new concern, but otherwise I'd prefer to keep the
current approach.

Thanks,
Ashish
