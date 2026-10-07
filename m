Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011002.outbound.protection.outlook.com [52.101.62.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAA03815D0;
	Wed,  7 Oct 2026 15:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791387448; cv=fail; b=F4ollm3xzGMXdVsAsJScHqV9rlj3HzrntGAUSogw5pkdeik9yKJI0gal86qfYbpnvUHjE1N40kwIny+hj2um5V5tF9EXT5lfEeyGiI9TjJsN0pOpnhFysYkIwNK679oxiZothT4YjGNrzzORvzsZKL51HM64F5ZhykwGabq8Y9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791387448; c=relaxed/simple;
	bh=tfWEt6ST/3rIeSIQa4UP5ZONMd/4pTggacVSgKnS8qc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U04oHbbDJFAZOQQ884ilRvaTw6ggqHVtwGdF4thJJHkgTu97KV+GTVv6GLLw927+pj21dLbdv6lAvmGOJIZqX43WXriQxVYZHGI02U0O2gzJL9MNy7bdZhQUYxLzTrUPDs+uhP/IlpzZ3MGf7vv2UhQBfRSQbq/F8uK0RXlyAYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jPPevRE1; arc=fail smtp.client-ip=52.101.62.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jPPevRE1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qeWQGF67hXytTwEOXT5oRKZj2tsTEeUPqG8nWhEHwKBtql5xuYsYguFuUY5vYEtBRVsD7dtCu+tKgmhtIHsOXpnjCsyxqmbYFk855rOH7L9XVC0VCl0cGMLFLA+hYBJPPJ9F9X39Hexj7Q481HdaDoZub0hWVafBAWaNMqITiTKC7nbmoZ5oK4YHNxxQuaOUHzgnZy7RWHAIzNI6qgj/z1NfzYJLdr6BrA+KN55jTiFGUffMTXOQRBBo4MBCGPx/U6Q9p4r+bl4tLnTeWGxSq7BtLy23d/iIKFETSyLXv3TXhK7U3luZznp6JIxfpjOzqDjtPh2ytUkOCWSd1Uy3OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pl3RSqsJ60zEBQA0rmG7Q55tJwTN9ZyEDN2Usekiodw=;
 b=j4P76sBalfNMl0ydgo1YXR5IWbs1GXj93aT7TNHvps04cKNyzX2Mt6MDlF63ARPATG5I3w4nZBN2x92sYeHHN/hqqOcwdk1B284zQkKEET2qGzTdko0pOFpvSxDGDDKYo0GEAvSXLzNNh9r8fCHZjhr7D6LONDqMlfttsltQ4HRMwP06QJoa7qyCm+/7KGevqY4Yb/Hfod9X8q9XgTqE8Xu1OgEr4YTicUI18XUZe2tYUCvggksXHqsBBxaJq/N3B8qYZvdr0Cy8PFGyBrfHKnhV11fNKnWAYfbpsDIwwUWj5wI/ZUdNw53RxcCLCFUgmKFhbtPTmTA937JbB+IH1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pl3RSqsJ60zEBQA0rmG7Q55tJwTN9ZyEDN2Usekiodw=;
 b=jPPevRE1ESpZJssILz1593npuKKvv59w9TK5Abgd+8pJbN5aeYgd4S1VD2pkLGgwTQVmZlut5RrIrLSGO9qS2dLJ7sw0Mep9B9lweJte6MVYm7SNI2clqAwMVoXcSNIYzx6yeqSmgc0ZbRdUv1Ypi4mdkZZdMhWe+a4mIs78lUg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ1PR12MB6217.namprd12.prod.outlook.com (2603:10b6:a03:458::6)
 by DM6PR12MB4449.namprd12.prod.outlook.com (2603:10b6:5:2a5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.33; Wed, 7 Oct
 2026 15:36:32 +0000
Received: from SJ1PR12MB6217.namprd12.prod.outlook.com
 ([fe80::bdbb:19b0:4f1b:44e5]) by SJ1PR12MB6217.namprd12.prod.outlook.com
 ([fe80::bdbb:19b0:4f1b:44e5%6]) with mapi id 15.21.0451.022; Wed, 7 Oct 2026
 15:36:32 +0000
Message-ID: <f278ca8b-91f1-4484-b075-72195d3b1628@amd.com>
Date: Wed, 7 Oct 2026 11:36:27 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 6/7] crypto/ccp: Register with fw_uploader and always
 fail
To: Shantanu Sinha <shansinha@google.com>, thomas.lendacky@amd.com
Cc: mcgrof@kernel.org, russ.weight@linux.dev, dakr@kernel.org,
 ashish.kalra@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
 aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com
References: <35ce536c154380a2f8f3af9b2b50069ce16804d0.1791212077.git.prsampat@amd.com>
 <20261006202444.2676092-1-shansinha@google.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <20261006202444.2676092-1-shansinha@google.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7132f67b-e7ab-4b31-51c2-08df2488c34d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|56012099006|11063799006|4143699003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	l6siYLhjj/wxdzkmX6nFU+vXKNV3Zfrs3GcFwKEhOo06eUG6YU0wF775XbhNnSAKt4CI8qAbPmvIQJG/KlU4AVdUmfrBnWG4FBdJ5+2tUetkchlDq5R1DM3IFzshJwh8g4nFYQac/zX6FHr5TEB63QXSgNYzZojWXxptMTVByJkGo3Gxq4xWiGbS1ZF0ASlB11MeheiRApWyyzx0s83Z/xaKfnnd84eJY+C0gAvErumI5E9XCQROJeWIkGyLhYW94t0aOo1HNQOX3wO2va6o0/oScPWqC1Gr22JRQKEDIzRlt49TkGs1qS8+heUNmBbMVR5pBcWYCw52qd1WTMam7AGU7EaifvhkVvDvyKrCow+68ddFpv4jTfLIhOlmOPfTaxOCMigF44HxjMCkYxtMc+AoNJl/JB2fXKAC0n7Ei6mrOEOcTT+c/JQaNfzYcBcPGzbf+YOy1pgciLtP+V8ho7YSHJiZFkb5qVkSlixMNQ4HzD6sKUEioxWf4SqIccqBCk39Qcgl8KUyXBeVI3Isyev7PLJR3oDGTViHG9HbxqDg0s626o+J48obOsto3GwTtGkc4zb1GltEPi13qYH9aL/7BQtbhIblMeZPzW5Ku88yf+r0oUfK3gaC0QUDL0oJjBpAHG5xN7oKrloxuS5c95KFoR7xiyaLbC6sXI2Uzfw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6217.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejFkdVNvRS9DMG9maXBuMUhEVFVIZWxDT3Yxd3M4ZFlwUUpteC9seFgwWHVD?=
 =?utf-8?B?Qzc3MUI3ejAxTjZxV2t2UUxKdDRkd1FiSU5kbVNrS2JwQlBuUXVEU2R6a3gx?=
 =?utf-8?B?K09jcTgyVURFWU9SeS9mNE0xanNYRVZmdDVHdmlCaXhQNE9jMWxBVXJ5VWpa?=
 =?utf-8?B?RHdRckFaWE1HUzdyM3ltYmZJOXJWa2tTTVZSZkRlcjRmVWtoMUExaVd0OWlx?=
 =?utf-8?B?S2MzelpTbUVWSXlORzJHTHVnaCsvWG9rajFLQXliVHdsOGRvSkRyZGNVRjMx?=
 =?utf-8?B?VUNZTjZhM01oUlpTVHpIL28vNkNBZ0JKZE83SnFzclY5VkZuV0JUUjd1aUVJ?=
 =?utf-8?B?ekxTOFpPaFdsR2RiM0JScEV5UFZFRGNxQ2dscDY1T21IZVdIRzNnenIrYmNh?=
 =?utf-8?B?YWhwcSs4RVNrYzQ2bXBZSVRTbG9DR2YycDNIbm9tbXRUK0FKcW93emk3aC9P?=
 =?utf-8?B?Z09yM0JQenJ3M3NubTdhd1V5ODBiR3JyN3Q3K2ZCbnFIa1cyZFlER1RRdFlQ?=
 =?utf-8?B?SFhLV1dPeHdCOEx4TzIrdHppSGlERUZPaGh0eDQ3QWFMcEdEWGk5Q3JCQzhB?=
 =?utf-8?B?TVp6TjdFTW41bk5tYmM4Q2EwMm5yZ0ZCVERGV3JtUzRLUVRhQS9UV3ZObmJG?=
 =?utf-8?B?ZnRzVDZOelFhbVhKTzF4Yk8xL3V4TkJ0ajlCUk1XbEtVbjc5RzdhUStidGhY?=
 =?utf-8?B?YWo3TkhGd3Z0UWN0OHV1QURMaEVxd1BnanpCalZkaDNyT2ZiUkE0M0JPOXpj?=
 =?utf-8?B?RFAvc2lBSEpEVkJOVHhMMnpvVXdFOHhJTXRvc1ZTWWliL1pPcElmRHlKczdR?=
 =?utf-8?B?VWtMbHBXeURxOURQcWdHTDJjQ25qYmRLVjdrck9MODVJZUprVDVQb0NKcGxS?=
 =?utf-8?B?RmJPcW9PY0RJRVBWUnF0WWVkQVZOeXo0MFY0Z2lUaDF3b1ZrenRpUDBKaGE0?=
 =?utf-8?B?aFpCWURQdHB1T1IxbVF2bzdtM01laGhSbVJ6UVFCZituQ2JDM2E4UmRZcXZm?=
 =?utf-8?B?Z21MY1k3WGtOcVE4Mzh1VkRpZ0tGK24reiszQWIzN3ZFMDIyRHRGaEoyTjhI?=
 =?utf-8?B?aWhVNklvbnBuMmJnOUdxbXlOUWViOENHT2ZFTGZ6YXUxYUFDZ2Y2UE9tVXNW?=
 =?utf-8?B?RU00RXlBMlZ5NGxkek95MjVLQnBVZi90S3N0MGsrT0lSbEQxbGZLSWlHalBw?=
 =?utf-8?B?dE1NMTlHeVdiZ2hCS2dDbDI0UXZueDNGRzkyWVBWQlpDbC9lWkpYZGt2ZzZa?=
 =?utf-8?B?NnFWYloxenVHS0VRVjdHV1lhVTlrWlpHbldDMVZ4UUt6ZW5wRllTMjNTVWlK?=
 =?utf-8?B?MW5veE51U3FjT0cyRDBxeHNIeUNXWkFNcWphMVV5TlN0N25EVWd5cXNBZW52?=
 =?utf-8?B?cWduNExQRk5GMmdObWtkTGJidVNQUm01ZnlsL09PYVA2L3pzRFM0M2VBaVBN?=
 =?utf-8?B?MDU2TnRNVWhTV1NyZlVMUFNybVAzV2QweVNOMVEvRHdUV1g1V3pUdmhPYkdp?=
 =?utf-8?B?bnY0ajJwd2s3YjNGbEdZRXluM1V5cWRvTEM4OWlTVkVMeDZLS0xocXBtRVlm?=
 =?utf-8?B?VzRtc09KNE85MlpEZm9JdU15dVcxUitoWXY4T0VKeTdPeUNvdXpvRVp6MkFi?=
 =?utf-8?B?YVRVdk9YdDYrejlxek9rTWo2blJaMW5GTC9kV3lDR2tkd2d5Ly9qdVBCcCs4?=
 =?utf-8?B?cnVGVVQ1blFYZ2ZWS3RjZGY5dWlhZ3dlaWt1SDQ0RW41N3BOYmJORjV2NVds?=
 =?utf-8?B?enorWGVWWmRPWnFySnFyMm1PODFJeG5jQmlRZGQyMng1ZW9QS3RLSWt5ZUpO?=
 =?utf-8?B?b2FGT2hhMlpFR3QyS0E4SGx3aEtCbWNTMXlkeEZleDRPQVpwdGlvQWNZV21I?=
 =?utf-8?B?Z2ovWkQ0TnJWNFFtTFBpRU0zSXVKdlBqYkNlVkh6RVRBTU9FSDhUSGdqYm5G?=
 =?utf-8?B?c2pBUFU4cWFIQkZ1OUxFQVhzVTJRM081VTJjbXl4bE5OV1ZyMEtpaEY3ckpW?=
 =?utf-8?B?RjlMSmJWTzRzVS9qYUsrSlRmeENNK3NmSjFRRzdEQ1pTSU5nSW5TZkdFaFVK?=
 =?utf-8?B?b0EwVUsyN1RNWnNSNzB2NkVaaktZTGFjTHlkQWJGcFlzYUFCWE56TCtZM1Fx?=
 =?utf-8?B?dHMxaVM0SlVDbmxuRTk1aTlyK2JpYmhwS2F1TmRXS1BCd09VOFdRRXUzcWpV?=
 =?utf-8?B?cjlvSmFKb0Mvdk1hQWFNZ09GSCtkV0xWeWREQnZqelVUWDRyeUNraC9HcHNC?=
 =?utf-8?B?d3ZhWU9NUVBudUprV3Z3VVFiait3QU9vVFBhUThwbjhIZVlqVGlSdXVNaTdC?=
 =?utf-8?Q?fywMovD/5saJP8onfG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7132f67b-e7ab-4b31-51c2-08df2488c34d
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6217.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 15:36:32.2051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPhKrqW1sghFFWjaPQeC5MYXIs1H2XQ/o6w++/azceeIOTO6VR3/b0LXkAx+A5eP1Moof8l7UVR7uLv1o8qt8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4449



On 10/6/26 3:24 PM, Shantanu Sinha wrote:
> On 10/5/26 9:15 AM, Pratik R. Sampat wrote:
>> +#ifdef CONFIG_FW_UPLOAD
> [...]
>> +#else	/* CONFIG_FW_UPLOAD */
>> +static void register_sev_fw_uploader(struct sev_device *sev) { }
>> +static void unregister_sev_fw_uploader(struct sev_device *sev) { }
>> +#endif	/* CONFIG_FW_UPLOAD */
> 
> There's no Kconfig change in this patch. Should CRYPTO_DEV_SP_PSP select
> FW_UPLOAD? It defaults to N, and the other fw_upload users select it.
> 

Sure, that makes sense. I can select both FW_UPLOAD and FW_LOADER when this
config option is flipped.

Thanks!
Pratik
