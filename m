Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013040.outbound.protection.outlook.com [40.93.201.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9E74E56D8;
	Fri, 16 Oct 2026 15:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165173; cv=fail; b=RQb5WTNBhBCi0xbLHS3Kdrfexz4wdkpprsQ9N0qE9kyLRR0ZE0Wc58Ymnaw/xYFfMZ9dn6/WL6xZhqRS2VIsTrjWeIOtY987DyCmLHEVshh/UgKVN5rgln2ZBiCiI7oPk0Aw2JU/h/9/DRIQ1ouqZZaMo6TYUCAg+XCK8TyeBOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165173; c=relaxed/simple;
	bh=UmpqYHhsGLAvU0j25k5euZHaHB6ACPV0tr5rs+F3P8I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=vD/dgNOu6wvIW/odLtnsArHb6qXXKq4MZSKsFzlXkXCgiowUn23Q9Ivh5kFhnFqwLw2SkFH/+073o56rkl15wccmAygneGBOv6jVILdili6LZQ7/Tn/Mvk5yCYZaHF4mOM1zgOhGyNQXtS3LWjJUwo5z7og9MvJZf+sUWuxb54Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Qld9C5AS; arc=fail smtp.client-ip=40.93.201.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Qld9C5AS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Aoi7NwhA6gMxBwujrCVHwRvTeAjD2yJbCbAtozUtofP98p9/MTRByIbsh/selx77KT/0cENxAk6FmsAbeZOeYGEnPrey4gMNzXsJW9kLRCy8d3u4TWcP2RxTNQWMFS+uG+duNhdkhRk3yyZXQsVFti/CuhOfUMKKdrQXYO8of5+uLPzqnPjgrlrKBwVQvG7dLOtKffcIAdtE2vGrQvPOKzPHoSb04CLh3bM1yLjatOsduzj/xGNYUxybbsyPyTzyanpE4r44xqQ8XX6OFIYZ/1Dc/rW7mV58ippit8VOEp3Tp8v5uM6SN+DmL/UVN1CiDMTpFzlhJVzq9pBanmU2fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3w+jIJd4vzAXZi1AIb81YTUvmnoIw6dn36AZw5uGJi8=;
 b=wnUpZ5uGWZSr7FNiEQ48Jj2et6ootcbOJTqPEs9xeLCTQZinRUD06unOnhn69T0gx+20oCcsQta2uHY/wjG1H/uRIGqxO8QGROJwUMGOQyJp5m0d36hxyLXgdqvh7sbvPfBCcjWPmnDASffZZHwkcvrNm0v/W2LiLQbkhXFq2Q5jNGWzlgqdqvUb4EWKABvraW6/kLGrm1iraz35KEnlXlFeIeVVzU2p5baYpXeoK0MQL5k801SchYLKXhwF054nAnph7xdNuGkoqTfDUeRQpfGSvyWxy20PauYq6hy+IqPoFpCnFtE/YYiEggEpuLm/hdSaDxGyrXSp6b5dG8JcTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3w+jIJd4vzAXZi1AIb81YTUvmnoIw6dn36AZw5uGJi8=;
 b=Qld9C5ASkolIUxekKdt5L6TliXXALG5BcxwpsFSNLuWMGaizXf1fMp+s18MaCxDHHK1Yt31zRoRtn2o8XTQcztiP7Lst6mtQn8GdaI9KDxeoltIIWRmML1WHZQI1D6d7+LhndiY8Z25YBIAWhC0ufPJ9Rh6ziw+7wxMBpdZVExw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5310.namprd12.prod.outlook.com (2603:10b6:5:39e::10)
 by DS7PR12MB8323.namprd12.prod.outlook.com (2603:10b6:8:da::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Fri, 16 Oct 2026 15:39:29 +0000
Received: from DM4PR12MB5310.namprd12.prod.outlook.com
 ([fe80::1bf0:6a94:a990:14f5]) by DM4PR12MB5310.namprd12.prod.outlook.com
 ([fe80::1bf0:6a94:a990:14f5%6]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 15:39:28 +0000
Message-ID: <0ca5a165-0b32-4ffe-bf9b-e3ef8e9627ca@amd.com>
Date: Fri, 16 Oct 2026 11:39:24 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v4 7/7] crypto/ccp: Implement SNP Download Firmware EX
To: Shantanu Sinha <shansinha@google.com>
Cc: Tycho Andersen <tycho@kernel.org>, mcgrof@kernel.org,
 russ.weight@linux.dev, dakr@kernel.org, ashish.kalra@amd.com,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
 aik@amd.com, nikunj@amd.com, michael.roth@amd.com
References: <cover.1792014060.git.prsampat@amd.com>
 <55c189e9130a7d22c0b756440f10a056415404e5.1792014060.git.prsampat@amd.com>
 <atElnAcDQFTnmdVr@tycho.pizza> <267f5e92-651a-4874-936e-70f3fbfe1e16@amd.com>
 <20261016012208.3220126-1-shansinha@google.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <20261016012208.3220126-1-shansinha@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0186.namprd03.prod.outlook.com
 (2603:10b6:610:e4::11) To DM4PR12MB5310.namprd12.prod.outlook.com
 (2603:10b6:5:39e::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5310:EE_|DS7PR12MB8323:EE_
X-MS-Office365-Filtering-Correlation-Id: cea534a1-14f9-4ae2-5373-08df2b9ba9e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|11063799006|4143699003|56012099006|22082099003|18002099003|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	CQJfb7t2FbZUH02DK62Fu5x+/uBHDuHtFi4FgAGlBY8cXgrng28GTI98hDqhp03ERx7J4VbzJuFbKgtkVPfRLwmZIEZHyjNOLZ/YKvK4A2yRxxFgCu40qlOseo6BQfUy+8PY5FJKb/MSglAWxe154v1LpEM1bc56+VCJydwa8VlqAmo4ZIlTUIYzfVILCZvefGUecq0pv3wynVewxBLDn6NLTjhRem77i6kmlY7r5XET0XONR9gkeuEFeOyaE6Wiutmsqf1tXQ6ULf629zS7Kpgk9GFvnuMzXls61dQnPQ+YBYQID+07f/KFswGaMpnYCN9IaH417cbI0n5NnEG1gtCtkQE/pO3LQ0loiF+nNafoCXCr7MkNctX994sZuH0DFvJebzmLECkOR/6KFLvoXnTazC5Ey6yEWSgaveBBEeXHNa+oRyTh6q5EEz2SzA0rI1OO8wiwtcW9/LJST8BfAzKsfEIgNf0jc2b1PneC5bt6vL6G2tF9hAXF1EzP7ALGX/4SLu+AEuRzcxJf+czyrg16fQglC4IYsBH5qsbEIrMn6FDj7M9Cwj7KdoPvLIpEPk9pWUG99yUljWVKWQxWooPQ8sOjXF2OC2wjYSg/JDa5fVcY49bixRcvP5Db7a0W
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5310.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aC9rMEdKdmg1MkRORmdGaTFFNWlLUXJpeTNMaSs3NklvT2V0KzB1OHhpK3BX?=
 =?utf-8?B?c0NFOW1LOEVNYUNCWEZsMGhIbUZ0b3dvWDU5SkU5eFFDVzJNTDU2YTF0RDJ3?=
 =?utf-8?B?VjJ2TUhNRVlPNmU1cHJ1STFjR0FIUTRYZ1ZvYjJQZmdUN2h2U0pQR2RCTFYr?=
 =?utf-8?B?NzFjRGlTMHRDcVBrZjFwV2F4RXNla1BUYnhHRHhMYUJWTHU1TE1XY2FKcEhj?=
 =?utf-8?B?c0tiZWM2dlpPaXFNa1JWYS83V2tSOE9ldXFGMTZ5YWFIV1RLZThwQnNpeDI2?=
 =?utf-8?B?S2JVQ2NDZGJBWk85enZIVHlEQ3JrVE5ENGQwOG9TcUlBNDEwMjZ4VnlQSDEr?=
 =?utf-8?B?MFNIZ01HUGpBcHhSZUtRU2dESTQ1RWFLSEExNXZvamxtazU5UEtPcDFJemQ2?=
 =?utf-8?B?QU5RU1ZkSXhxaExKT00wWW9MNUE0SFROY0hzcGpXbFltNVUwSXhva043UlBE?=
 =?utf-8?B?L09jejlTS0ZEekNhV0FrYjlGZWE1cEZCYlZoQy9MZHN3M1VwZ0l1VlFGbnhr?=
 =?utf-8?B?MEQ1RTdXUHBrdmRBcWRDMzU5amRkTkZIWURubnp1TnpKSmFTZ1lWRVNiVG9j?=
 =?utf-8?B?QnZaVk5MTkQ1VndCMVE3S3hlV0NDOStTWDB6clFRQkNQYjlELzFHenNiK0RQ?=
 =?utf-8?B?RkRsR2VPZWoxVDVSZkJ0WklIVU0wQkJzNFlXWkhEbitmL0NHWG51VUQ1YXdS?=
 =?utf-8?B?VzhVMUM5YnlTNEo0aTM3WHEwSjZCalg1RDFXSERwWGI3d2FYcnQ5bnFrUzVB?=
 =?utf-8?B?TzI4eElERGNNRTkrN3ZEdDRxN1oyM2R4NDExd24ydTkrZ2gydEkxelFpb0k5?=
 =?utf-8?B?cHRUSVlJQVA0aVl6NmVmcHhqTkgwLzBkbk1lSVk5QXUxR0REK2NiZHdxWW1J?=
 =?utf-8?B?TFM0YldYV1gxR1ZiSzVBZTNCbVM4Vkt4d1k5WEJOWnRKUld4bWpVdXNlNlFC?=
 =?utf-8?B?WjRhaU0wNnNvRUxVN2JzbFVyN0E2cTI4Nnp4UzFmNmx2RDFYRmg5VjZydmtL?=
 =?utf-8?B?QUkwc2xSemVPMEF5SG5CalpGRGtIamwzN3dvRGxkS0duaDF4NzlKcHRFNE9k?=
 =?utf-8?B?N3g1cUNOMThIaGNXQ3hHdjF3b3RIaXRGZ2xCdzBENlRnTmY4NndTUVhtVi93?=
 =?utf-8?B?ZytORG9BVFRXMEhINnJoeGE2MFNqOUdObEsxSnBnSi9DNjFGcldPQytveTB4?=
 =?utf-8?B?UFRkMjVtWjdOMVEwTzJ0NStGRTZtbGNDS2x6dmNYOHlXU0Z2Y1M3RkZJVTNQ?=
 =?utf-8?B?U3RLdVFSREtHbDFSWlJ2YWx4U0J0SjJLWnl3ZDZ5bU9nRkxVMUMveldSRHhK?=
 =?utf-8?B?ZlRubjgxN1FkMzA2MjZRVzZkVzZ2akh0UmxEdUYxK09abHE4VGpoRE1mc3FO?=
 =?utf-8?B?WWtJUGVGTFpPTi9OcGdNbTYzNVpzbUtnY2RiRWF3ZXlpYWVpaHNqZmFnRi9T?=
 =?utf-8?B?QXlsZ3UvUkVFN2ljVWszUTFXdURCcWt3YVMrMWJkc3ZHelZvRWxLUnRwMUtO?=
 =?utf-8?B?VTZzWEZuRnE2RzdsYko5M0hUdlZ1dGdjK0ZuRlBqZTNHTjA0SkNLMXdDRXZk?=
 =?utf-8?B?ZGlkMkVNck1WYzNUSE1wV242MmRmSHN5b0p3UnFKRHpjdWNTODdMYXUxbmds?=
 =?utf-8?B?NE5wU05HdmxGckVYUkVqREZmL3hVU05XYWZncE96bkd1RGZ4dkJXeG9qbG9i?=
 =?utf-8?B?c212NEx6eVBBTm4vaW5PMGg2aytMRlRIcVJadWJzSXpqRC9ZZGEySWRpTmpP?=
 =?utf-8?B?Y1NvOGdnZlB2Q0RjQTF2RkcyczBzZEJXOEhnYlJ1Yk1lcExIMTRWVlp1RG5F?=
 =?utf-8?B?TXV4RG0yYVhxc2I0Tnc4QmhnQStORnM0aWdNVitOS1ZuazBtVUxScjdDK0Rr?=
 =?utf-8?B?dFlxd204Q1F5M1JlNFNTRHhoUTFtVkVFckg2cndrakxEVmZqdlJOZlNtYTN0?=
 =?utf-8?B?VUllZzgybVY3K2xmbXZmVEtZTlRCakNNczdKTzlENWFHV25JODBxWlVoL2t0?=
 =?utf-8?B?UXVwcjZhRUlQSXZoSnlVUjloR0hTMkdtdFRINHh4YUw2VFFGa0JZcUNHd01j?=
 =?utf-8?B?Y3BZbGVjOHFMQnpHUUd2QlVSeUNMS2NkUUYyS2VZV2x1Zm9BV1QwZmExeGJY?=
 =?utf-8?B?STlnWE1lNEFPdVJMQmlnZGVycFBUeWNjZzN1cjhCK0I5dWIwSVl1RkJEc211?=
 =?utf-8?B?MmR5Ui9uVkM1VmNKRUg1NnRvdG4wTWJFU1B3OEpLb25tYVVRazlTcitEMktw?=
 =?utf-8?B?MVFaZ3JtcVQ0WTBwcWd5Y0J3d1NEU0F5dUxjS0xGcFpIY1Z4ZlZ1S1htb2Mz?=
 =?utf-8?Q?xJjYu65AEKRvbPQvfr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cea534a1-14f9-4ae2-5373-08df2b9ba9e7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5310.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 15:39:28.6666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ybh+yLFoIPABsnVjh6qVehJTt69Br/7xLiLRCpbkQOxP93oBq7kPSq29IBGkKsKKnb1YHY39v85mOzHj7YluDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8323



On 10/15/26 9:22 PM, Shantanu Sinha wrote:
> On Thu, Oct 15, 2026 at 05:09:38PM -0400, Pratik R. Sampat wrote:
>> On 10/15/26 3:38 PM, Tycho Andersen wrote:
>>>> +	/*
>>>> +	 * Firmware either just requested a rollback or a rollback attempt
>>>> +	 * failed. Keep the PSP dead for all other commands, only another
>>>> +	 * DLFW_EX attempt is allowed through.
>>>> +	 */
>>>> +	if (sev->fwl_rollback_required) {
>>>> +		psp_dead = true;
>>>> +		if (fwl_ret != FW_UPLOAD_ERR_HW_ERROR)
>>>> +			fwl_ret = FW_UPLOAD_ERR_RW_ERROR;
>>>
>>> I think this error switcharoo could use a comment (or maybe just be
>>> dropped?). e.g. if the user does something to set
>>> ->fwl_rollback_required and then tries another firmware upload that is
>>> the wrong size, ERR_INVALID_SIZE -> ERR_RW_ERROR, which seems
>>> misleading to me.
>>>
>>> I saw some discussion about all this:
>>> https://lore.kernel.org/lkml/20260924213737.3833625-1-shansinha@google.com/
>>> but it's not clear to me why you need to reset the error code here.
>>>
>>
>> My understanding from that discussion was that userspace errors should
>> fall into clean buckets. read-write-error would mean "roll back",
>> whether it came from the first failure or a later rollback attempt,
>> since a failed rollback still leaves the PSP dead and needing a
>> rollback. dmesg would still log the exact reason for the failure.
>>
>> That said, I see how it can be misleading, and I'm fine with dropping
>> the override or putting a comment and re-spinning this.
> 
> I do see how it can be misleading.
> 
> I think dropping it makes sense. When I suggested the changes for v2,
> psp_ret was only logged via dev_dbg(), so the sysfs error was the only
> clean signal userspace had. Since the error code is reported in dmesg
> now, I think it's fine to keep the original error and have the sysfs
> error reflect what happened on the upload rather than the action
> tooling should take.
> 

Sounds good to me. I'll drop it in the next spin.

Thanks!
--Pratik
