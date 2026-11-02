Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.5
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793628744;
	b=HLkXF5DkP6CXA4y6nWSVG4tMHN1UYol+IiL9iPdp+fR7stfM4BxJ/Yn2+HZbBKW054yg
	 7c4xktpjCGyv+uAmIMc4cyOywtPTJLjXQHf3P8pPejJm+soNAeluJ8OnPqhDk6mh+eRvc
	 NiYUZUHRJtGYXQRTvLqsmb4cHcIuLrOuDzqzPOfV7K0sjrmTx2maufw4Se6MXzVbMQfkV
	 RmpZ42hHIBLaNCo7RqRPaqgRzQu5kU7TfXyy0xSKGQexfBiVy6GaBQVwcdNcymCCXSH1v
	 B5d54yRm0CaEnqp3Bg/8vO8YfolMmUEp0TIppEjshV+XtaJrztsAgffFARQfTZr7M/w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793628744;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=AFz8AhkP+Hlsihi/lwAz6XLQdYYIq49NbymlBa5DHmg=;
	b=fXp8PgkjjeJ79N7lOeb4IEcvfaa9xpqwBcnhz4JKo8c5m0SiFEGrupuiBCJzx+lVfBuM
	 5T92G1cfEqEmO/uNyuXT1TAK2WW6zhEuFAjI/bqsXFQuPVM1B4ivCTB59GuyDNXGYd0H6
	 MH7eFdqU0EC3f1CJtAJNiS43eUCd5y6ChmW4Vc1CXmHsbQghwrbrvnjzsKI60RzBl+hRt
	 iu5IR0rARTizpeU9Q0vC/Krvf3KZ9LTspfo+vk1GbqoqExqhyABoJ7MvGLrpgxSs4tKTz
	 Hn1bUtO1NYUFU3Dn4qMshU8/4g00vN0qJEcrWl4nxSdE5Yn6b9E/JI26PtDhu35jwVg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=uDKLYVGS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.5
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013005.outbound.protection.outlook.com [40.93.201.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CA7606A32F;
	Mon,  2 Nov 2026 14:12:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87CA7606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=uDKLYVGS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FEmJsy0msX7zVVow2UFGywT7Mn3krH3mcqNca3PjFGrKeruXgMC+hOntSf+N3McLvLZyvbjeTrKXk5q+/Wc4bHY9xzKFHOamsGyr358L81GmqGPfpTcyd72fa6xnGB6UZHtIX1ZVXnlYZCTX00n/RiGoVBBZS0OU2rwLfSLUoxyQdUPiF3L8QgLfZpB8bCUFRECIYuG018lXeRyjUMxGMaCBLubrsKOtf0JY8ZfWScq+krO8anWpNTDkEfBm+W2cbYZSHk6+O8UidWkV/VrVMEITRjZTFYGDPN+5GTeMVlCaefmg6LD6xiXpD/dIUO7fTcrqM1Vp534VSaOA2+w+ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AFz8AhkP+Hlsihi/lwAz6XLQdYYIq49NbymlBa5DHmg=;
 b=r+uXU9CEk5NXvHl6bqzuhbMvrOQ5er+dKwfT6tf3RYfAK7/jnFSBFBh6l0Iy8uStFH0YJRlAV68DbdF07CxZRlZuKWpUgw/xp2qOik9/inB07y4mNEHYAbgvwDVvUu0LTwp19NMQcgzipOy6F/MZCivygw5bG080kzJptRy6ExjPDcM/N3ho3l+PVh5fvxo9///fcS4caWNuHdWUpUBQbidpREgHDHx+rce/S4496HLA+yemwwVBx1MC65+PGthnYhaFIyhxRyc0os0l71kw/DgdCfVKOv075Cc63JJOd2Y1d0bWO8AzeHuDPieS+XjKZjWLJU/hru2SsU2la6zdeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFz8AhkP+Hlsihi/lwAz6XLQdYYIq49NbymlBa5DHmg=;
 b=uDKLYVGS/b4tb2NuKcNyknurc+Pc1FyoTWiuIs5ixLiQfKtB7q6GpuYvRNgJqsa5S0TUW2zsZVOwM/3Wp+qx+Y2DyNy5k9+4/YU7a+iTtA5nLLL7gM1J8lUlLpVS5h9uC4H4+kWPpBmGJtCncaaFYtdnii6ZLm5ZunQQ7IcCzZA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by CYYPR12MB9015.namprd12.prod.outlook.com (2603:10b6:930:c8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 14:12:20 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0569.009; Mon, 2 Nov 2026
 14:12:20 +0000
Message-ID: <414b2fc2-a55a-4b2d-ac70-4def101c4aee@amd.com>
Date: Mon, 2 Nov 2026 08:12:16 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] x86/sev: Clear RMPOPT when segmented RMP is
 disabled by firmware
To: K Prateek Nayak <kprateek.nayak@amd.com>, Borislav Petkov <bp@alien8.de>,
 Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
 pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, ackerleytng@google.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1793216372.git.ashish.kalra@amd.com>
 <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
 <20261102052841.GBaugfibOXxGorZKgq@fat_crate.local>
 <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5P223CA0001.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:1f3::27) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|CYYPR12MB9015:EE_
X-MS-Office365-Filtering-Correlation-Id: 02c5a035-13e1-4b2e-a892-08df38eb4eea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|6133799003|10067099003|22082099003|18002099003|56012099006|11063799006|4143699003|261026121527099003|261021121427099003|261022075727099003|261026140227099003|261022105027099003|261009223027099003|261028144727099003|261021123027099003|260925022911599003|260925021911599003|260925021311599003;
X-Microsoft-Antispam-Message-Info:
	DHCTsDPDQHcTsaIM3ITdrzd+vkJ517m+KRqPcqr6eDdGBsmvn1xDugTxi2hE7XLZ6eQ/8ZPY+UebLRDFgaZpqi5VM1omTqXGjZ9qGJPAXdashheKxcDyGxODvQOvy2QyB1oA4V8O7+9sywlTjDfyIvQtuwmHHJSoXhicAcEGBz0Drt6CuRVw8gTWxALBiDMWcaIkFxZl7MWK02TWCSWa0MTTdfILgKD0ebUqGH3lI/s8rde3P1NX0mLF+ui4fE3gNZeHVj1nSmcOC2EfT+h+mPtDIIcADtFrnxvHCrzdMG9jGnvS8TTK/FynszHL8Mj0wt9RgEV2XXojLRA7iD8kDmtrBL10WR0Nl/Xit02xxo76R3tL7RcQzeC0TJkQOyvR697pIHd6XPpaOIstSwt3JD7hH09LkIFj/tLiWks5B6rjmvMreJT5BPOjogR7J42kZkPqirYPSEGwC7bMudTB4FTqsakUJ6c0NPaF94GIQ2PaZfSdrMHrhqV0bp7p8MnwZQCMFd1DmwADKqf3r5EBug5Eq5uJ/4TzS7O/VMIV8C0Rs2g9dZXGSnT6IsI21tlvPTfdRqeFOIbiZaqQ1Vbox0/l4DDQlXBmcLDgY4YHLFS2Vl3ojQqlgDOdLBMYYt4+
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(6133799003)(10067099003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(261026121527099003)(261021121427099003)(261022075727099003)(261026140227099003)(261022105027099003)(261009223027099003)(261028144727099003)(261021123027099003)(260925022911599003)(260925021911599003)(260925021311599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1M0aS9yZ0ZGVS9OZXlKZktoa3Vsc1kyUFpOK283M1Ztb2M1SXhCOERtZENJ?=
 =?utf-8?B?NGV4dzdIQzU5ODhDM2FzZXRVVjFnaWhtaEprcldnekt6TXJzREpTZVZqZmdD?=
 =?utf-8?B?MnBKbDdqQ0tIRXZ6S01wRE9WMS9XampSN3I4YkFvdGtCTFBUVmFia2FVSjVJ?=
 =?utf-8?B?Vnl0WUNwZUNGUWs0dDM0STJwTklQSWxsMjNsZXlNWWc4dDdCYU5JdmRqTTVx?=
 =?utf-8?B?QXlvTTlmbDdiZFdyOXdQT0lQWG4wNXJZK1IwWW5LYVFjNnVMN0R6RS91aC82?=
 =?utf-8?B?cWJiU1kxaGNDNTAvcHRDd2IzK2R4eHEvK2ZlUUl6dXNpT2NJa25JdVNoaWZ3?=
 =?utf-8?B?REYwZmNZcEVsZGluS29idGR6RGVNR3JjSXNNdmVhNXhidDJqNzRXUm5SeXhY?=
 =?utf-8?B?bldCTGNXZCsyRENmV1NnUWQ1TnkzYnlPWnFqRWtnRENYbkVmNE5oWHVDZ1hr?=
 =?utf-8?B?dndJcEU5dnZ3MHQ1YnNZUndpNUt2c2N4bUJ1a0xjdlRVU0tISnZBZC9LUjE3?=
 =?utf-8?B?TzNxREYvYXoyL2FKQi8wY3N5U2ZHVEhHQ0h1T1p0ZHR2d3BpYjh6cWwwVDhC?=
 =?utf-8?B?bnMxWFFpOW9sZlFJcFFvcjVFSzJFOXJPSUN2ZklmUjV1ZTZxK3ZQZnB5ZWd3?=
 =?utf-8?B?R1BBMHgyd1VoVXJzWWRuc01ka2dObXFGeVlyakhVN0pZdFdrVUVSQS9aWGdN?=
 =?utf-8?B?a0RZWnZ0SDM1bHp0TmlpWk1uUGtCb1lFMFI5RkprdXhyNXVsa3NoSDJBTUNZ?=
 =?utf-8?B?TzBiZzhITDZJbUx6enppNDIxdFdVZkhFdSt0SHdaYkhBUklIRk1hOG13dlIz?=
 =?utf-8?B?ekp4cm1LeFVLVm1GaklzcW5IVWpYSkVWNFpoV01zeVRvUnBtLyszSWtkU3pp?=
 =?utf-8?B?eUVkYzIxYmRYNDZkV3BPYTRDUGduQUo3ckVMT08wd3REVE03ZHBhZklzSWc3?=
 =?utf-8?B?akJ1RjcyVlJoZ0NNbFR3SHFWWDUzclp0WGNrMVpQMFpxekJRSitYNUhSQnJ2?=
 =?utf-8?B?OUJ3OGp5bXJMUnl3ZDRFUmZRamtTSUtnMXJIUXcvZU13R2NoajVDcnl4TWth?=
 =?utf-8?B?V21JUHQ2bE11NTA4WXUxWVZVbjFneHRCUHlrUXBBRU1RRDdHWVQ5cWhqMW4w?=
 =?utf-8?B?RE4vdEM0bDMxa2VJT3dXUVJoRysxM2V2R1lUZHBGdFAzN2hERXBsKzU0bkZn?=
 =?utf-8?B?a09lSnJJUnd4bTJESGt4NFVKdDNXZmcwWFJOaEVMRTA2aER2eXhRdm42Y1k0?=
 =?utf-8?B?ZEtwZFdRM0o3SzNQazFsRFZ0RTQ1M0l1T3RtVFF3YktvWE1VWDZFNjFKamVz?=
 =?utf-8?B?UTRXYWRlQjJtU0lOQ21ZaERDR3RlNHdEMzh3RlNBMEZVSXgvNURxTTFtUUxB?=
 =?utf-8?B?SXNKVkU0NjgyRjhCMWd0WTRwcHgvNFdQamt0MXRsV1NlWCs3Vk9jM1NIWEFZ?=
 =?utf-8?B?aDRYWldsMVJVcndTWmlFN0ZqWHN0YUtPUHloOHRPUmpDREN4N2FjenpMc1pC?=
 =?utf-8?B?V2VXV2JjVThuS2txYXB0VUtqSDlaZG41MENLZFkrV0NSWERxOUNNU3ZVZkVk?=
 =?utf-8?B?SW9MZWd4OFY0bEVidDlNTndJMzRUYU1ZQjdLMWlzK1dlRkhUd3dyanlBNmRD?=
 =?utf-8?B?YXlnY3pQTDhGeFNoZTJiWTlLV01lZkU0YjZBdHJicE83VkFHc2x2V2sxdWd0?=
 =?utf-8?B?UzdHSjdET2JWOXZUejQvYnVCdk5Cb3dOSFhwWW50SkM0TFpTcW9XRU1ic0hC?=
 =?utf-8?B?NXRiOGVkWUV2cmlOVXU4KzdRaGVaWElxMTFaRVQzS0NVeFZJcXhScFMzbG9D?=
 =?utf-8?B?eXUxTzlyNU9QNUh1OXRUTXhYWGNoWWpqaEZmanYzQzVwakhUa1dNYy8zTXRK?=
 =?utf-8?B?ekRKdys4K0pPMGtiRkZULzBMKzNiM2VUcXFWZGZjZzdCWjZkK3RWL21zVHB1?=
 =?utf-8?B?b0ZneVBYdXIwTng2Vi9WWjFESkQ3WmNlTEpKWlJiK2JJQzJQSHBRZ1VwV29I?=
 =?utf-8?B?SzdnU01CRFNaWGc1VkZWbU1ucmI3YWUzZ0pZeDUxRjhDTEIxY1oxSnlvLzhQ?=
 =?utf-8?B?WnBreHUrSjR6cmZvY1hGaVZxV0dPbHNwS2sxNm5OeGtUOWpNYmpLMVRBUm0v?=
 =?utf-8?B?SlJJZlBpM0VkV1NGWHpRanJmUU5Oc3NHRGFhY2VDWkhRWEZhZ1hZd1NGc2pq?=
 =?utf-8?B?M2NJaVJ3OENPeEFuVlF5S3BnS0U3aXBQVkpSMUZCeUMvcnJISURvekxYNldD?=
 =?utf-8?B?MVZVQXovNTZWSkNweW1NMUpEU0FrN1R5S1lVT0wzUDBodFBMa2pic3lUU0J6?=
 =?utf-8?Q?yt6xLIO3vyppO153GR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02c5a035-13e1-4b2e-a892-08df38eb4eea
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 14:12:20.4648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FOOOnqvfoOwkdIRxiPHlFhllS3+uwZ2emlMfsyhMN6JmNaE/BFTB7tLx7ecV4G2SGAxxTJh9vJBvpGSvhANgCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9015

On 11/2/26 00:12, K Prateek Nayak wrote:
> Hello Boris,
> 
> On 11/2/2026 10:58 AM, Borislav Petkov wrote:
>> Segmented RMP support is advertised via X86_FEATURE_SEGMENTED_RMP, and the
>> firmware enables it via MSR_AMD64_RMP_CFG[SEG_RMP_ENABLED]. The latter can be
>> cleared in platform BIOS by the user, in which case the system runs in
>> contiguous RMP setting.
> 
> nit. In the latter case, SNP is disabled entirely in bsp_determine_snp and
> the system won't continue with contiguous RMP.

Heh, I don't think that is a nit, it is broken.

I think the code as it was read fine, but that's just my opinion.

Thanks,
Tom
> 
>> snp_probe_rmptable_info() does not clear X86_FEATURE_RMPOPT in the
>> advertised-but-firmware-disabled case.
>>
>> As a result, this does not prevent snp_enable_rmpopt() from trying to program
>> MSR_AMD64_RMPOPT_BASE, which raises a #GP on the MSR access.
>>
>> Make sure X86_FEATURE_RMPOPT is cleared in all cases where segmented RMP is
>> not enabled.
>>
>>   [ bp:
>>    - Put the commit message on Ozempic
>>    - Flip the logic in the function so that the segmented RMP disabled
>>      case goes first and the flow gets simpler this way. ]
>>
>> Fixes: 15d974be0a3b ("x86/sev: Initialize RMPOPT configuration MSRs")
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
>> Link: https://patch.msgid.link/56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com
> 
> Feel free to include:
> 
> Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
> 
>> ---
>>  arch/x86/virt/svm/sev.c | 21 ++++++++++-----------
>>  1 file changed, 10 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
>> index bd70c4d0b774..ff6d17795054 100644
>> --- a/arch/x86/virt/svm/sev.c
>> +++ b/arch/x86/virt/svm/sev.c
>> @@ -817,21 +817,20 @@ static bool probe_segmented_rmptable_info(void)
>>  
>>  bool snp_probe_rmptable_info(void)
>>  {
>> -	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
>> -		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
>> +	if (!cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
>> +		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>>  
>> -		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
>> -			if (probe_segmented_rmptable_info())
>> -				return true;
>> +		return probe_contiguous_rmptable_info();
>> +	}
>>  
>> -			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>> -			return false;
>> -		}
>> -	} else {
>> -		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>> +	rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
>> +	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
>> +		if (probe_segmented_rmptable_info())
>> +			return true;
>>  	}
>>  
>> -	return probe_contiguous_rmptable_info();
>> +	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>> +	return false;
>>  }
>>  
>>  /*
> 

