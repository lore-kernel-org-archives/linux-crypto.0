Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012001.outbound.protection.outlook.com [40.93.195.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE58502562;
	Fri, 18 Sep 2026 15:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789744562; cv=fail; b=aXfXalhrHx783teK0eLUanFJX0Tvh6F8x8TiT5rpQaINb7iIYpT5sYE+kN1wJvMnhclbcpoxT78VBlaY+HyU7rQh2jXZLI+uXShGRynhxVP6i5gWxU1ZoaVOcRV+IOhx2sVR1r7A4aQXEcKpzHiAUSVo2l4wxqfVDTyxDuMT2BI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789744562; c=relaxed/simple;
	bh=pK9rcYBS3/btEzhLGgKu1nGc4egpfBAoxAhoHG+Hhbc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aqQjg14iYGUL9l2YPU+SkaJZLwgEGdwhL7xXKeUAC5r3+p/Yn2/t84kblLV8kb8Vw906bvOPbBRpzbAwHdBDIjg/jwy6dfjdDUr8rPI8t4jRckY6jFFT/9WQIT/LAM534Ad3FwA2CB1j7HR89Q8TSsxF/OlgEOlKC6/YnEyJUo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Josd/GJA; arc=fail smtp.client-ip=40.93.195.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Josd/GJA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sjYDv/DtlqvK/2+b04RX/rJfVKqvR43PocwcINaJodS8lxBSO4JUCuzVQxR2MtF0ihrMCKuP33MxvggOKUOClR8lfjYJSZWUHLY3zaVbgL2AObm/l4f8Zv0e+bZzV1F5iVqrLM2iKMxGZMGo60lLLvVvf/N5FPT/ZqsL9Qn89zMHMdrdMKGxaiwue3IerHaryQ9mc4ny5P3oEbRpwoG8UGyZX3gKamhOLdHs/qu1+LPTlb3EyrloOLDZlbWV1f4tIZI2ahfGkPc/zx/PL8SUpppZcossjvM81DLyLffmS4rP4pGPera0suDoGhcq3BF3kzsJPYVne0YlgBBRtWbOqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grLkfa9PO0bYj68BMLBfd1dNUHCMRFogYf/b2ykbSS0=;
 b=y40PJ3cOG5VYXh72CCoHJE514g/VcnblnGo/rynZWRfnderQ+JW9y+lwlpCK9F6HhaFTTPN+iLNo7C22hV4u7vHNwxd+QM5XO8IPbEeRfAm2yHJnL13wLE9COCuZhANlIRaK0rABAIId02oYxeMYd8TAnlL5lYfKXKAhx8BfcKaqG1BRuS85H9f8sAEMAyZJsfDhS+Q+Yg54SsJPQ4FLnUm/b1+NyyT3HQvL809IwQQxt0nXXQUtgwkhHKA5jZk6ZkMNZZ4TyEaUxbg1ZbZRxWHdMFCmrQtOe9wJpKLmuVd/Cax3rh4+OqlqX0YQUG1QE9WDPQMhbVdbToRvChSDdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grLkfa9PO0bYj68BMLBfd1dNUHCMRFogYf/b2ykbSS0=;
 b=Josd/GJAtoBuuahVfPP/A+l0MEKKzDbRJknSOpri4aMEZ/IAvKjWHI3YC3dYBdt8ZryAiKhQRTMBRRVUfv/+4a/6QONBw29o5FWkR8USKoiZH5bsKeWctJnI0upfYDbqIH+7zHIjAEPE1CXqq8DUMBUd+rq7gnlAa1y7Qab0Guk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by IA0PR12MB7649.namprd12.prod.outlook.com (2603:10b6:208:437::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 15:15:52 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3%5]) with mapi id 15.21.0406.014; Fri, 18 Sep 2026
 15:15:52 +0000
Message-ID: <fc7b6f2d-9f5e-4114-8e31-cfdfccee5068@amd.com>
Date: Fri, 18 Sep 2026 11:15:48 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Implement SNP live firmware update support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: mcgrof@kernel.org, russ.weight@linux.dev, dakr@kernel.org,
 ashish.kalra@amd.com, thomas.lendacky@amd.com, davem@davemloft.net,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
 aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com,
 shansinha@google.com
References: <cover.1789059391.git.prsampat@amd.com>
 <aqz-vc9IPCkYHYfc@gondor.apana.org.au>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <aqz-vc9IPCkYHYfc@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0391.namprd03.prod.outlook.com
 (2603:10b6:610:11b::10) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|IA0PR12MB7649:EE_
X-MS-Office365-Filtering-Correlation-Id: d9b04473-6f95-4088-14db-08df1597ba56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|22082099003|18002099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	900pwpQZNZB8cpXWcVlq4rpWH8RJQALnVz5igY50E36Bl9q0iHVr/wcHDmhvAbr7KIShw+fZc2uc8DjMZip3Cgh5ugRMLPO1EiQhHk+9I6l2g+9/6kAL38+DBBE0sqDaD1EDhmomCKscWv56ztZE05gAaAjk5C2YLo5nNbBsIA7Iwu2Kdvpuf4d/5CGpl25Fuka6MjPUgMiJFOShO7jjHW6oTB1PHPXEcUR5U+5RoFjLXui2Kny/VsQj1iMBFPmlmsNKhWBt19/sDjwC2dFo80S8fkDAOQUh8UkQ7clAnx52xfwnIwmY8FmJfH4/cI0jHWDU1XHjsnpt/AQ+oMkEl0j0R6urHYkOgA0+MZHC8Q44v8mQi0S2XC1js6afHg73KZtNAz8pINHRqZ0y2B9+vcjcQc11N+v4H/KwQIBq7WeDRaCmbSDad4UM0CH7gTlZFXYlihVMbwhlNcBYMAljJNkOlVAQrIpOsbO5mVSoOK44ocjbeGMC/INdnqeQXpVJKpLcHuXcDE1KvBfYbrJmLKiN6l8B/EPcfa5drKEpleGIdWZGwbEuYOawviVIWsxwqcHiCxGq4y631y0HXMza69dhtMEjL4Dt7ij/LZszXPc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OTRJMlkrcXM3OGdTWERNUU5tVGNrWnRFMHhJMXZOMXUwV3NESkNVaWg0WkZt?=
 =?utf-8?B?dHNRYnMzbTlNaFRKWUNmQ2w4T2djN3hRZXo4ZG5lZmRheU9EWjRZbm1uYnla?=
 =?utf-8?B?Q296Tk5FMHkxQnh0L2g3SlZIMmNOREx1WlZ0NFp5U1dJQ2YrWVZ2QTg2eVBD?=
 =?utf-8?B?dHBGTk5tS1pSd05NWlJhRGxwcW9McGZHMDRhclNiaVRNYjFMQXdNQkJuYURv?=
 =?utf-8?B?NW5McG03NUFudWdaWC9PS29vd0t1TmRpRUN6TkJKREpwSXl0M2p5Ny9GN0xL?=
 =?utf-8?B?RGJjdk82SFk5ektUWlFLRWVFeUxpUjZ1aFFkMTZneDRLSXR5bHRhY3V6ajZY?=
 =?utf-8?B?SERDUUQzOENiTGVJNXN0bk9Vczk4UUVBT05UMTg4YSt2dzU5UkhTc09YeDVm?=
 =?utf-8?B?b1hCL3REenVnMTFxRWlValJFeUhiZkx6emxtTk45QlhkTVJMRTJydWNqdXRi?=
 =?utf-8?B?SXB1NW9zM0FFSmZ6b1liWXJMWis3K2djWFhQSVdxcHVTWEtIa2NNVWV2THhC?=
 =?utf-8?B?TWJIU3BJMDZ4dHdWRHlablptd0ZoYzNnMmd2Y3RLWEsxdUoxSUtGVFQ3YmUw?=
 =?utf-8?B?cHJBaFVpUWU3ckxPREZZeGVCcDE0Q3hzKzlpS0tLd0haWFdhTzhpcWZGNVpR?=
 =?utf-8?B?TXN3QnZYNFNMZHBHbElIeExLMjF6emM1TUJOQkVtWVNzLzkrY3FvRzVndHB3?=
 =?utf-8?B?WVFCZGpzbGttd2hTNVMyNkpQVWUzS0FQS0tuWno1Y3ZiZXl1Y2ZsVzMyL3Y5?=
 =?utf-8?B?dlJNNVNldytnWDBpUm91SWhyb2ZyTkVZWDl2Q1drcnI2TytUS2x6enowdWZr?=
 =?utf-8?B?dnZNdXIzbHE0c05xbFJ5RG5rOGhoK1kyWGVZS1VBVnIyYk1wazhYY1NibjdT?=
 =?utf-8?B?dGlGTFdMZXV6N1EyU0lSeThnZDZ2TElQTFArbWlxZ2d2dGsvZGZsUjJadS8v?=
 =?utf-8?B?bVBxMERBUmI1clI0YXpTaWNuNG4weXg3NUJXQWhkZzBlVm90MExhVDkxb3Ju?=
 =?utf-8?B?RjZQQ2d6Y2tJOWhGajMvK2Ura1dreWovTitDQzZYV2FhcUhrYjF1UzJWQXg5?=
 =?utf-8?B?VEFYTTNLWkNkVHV1MDQrc2IrMFpzblN3U2MyaGg0Mm5kOWtvWjJvNWo5WFdD?=
 =?utf-8?B?eTlUc1N5RW1pc2N4ZUNVYUxxQmhtTTNYeUM3WVBOSzVzZWhGbTJBTnZCcWlM?=
 =?utf-8?B?N2JvdUJwOEdKc0IzdGZscFdkdGlUL0VDcGwwR1ZPK0luaDBuSFFYcEtTUFRK?=
 =?utf-8?B?bThuUzlJMjJSVEJEcURwT0RpNFRKQ1M1TEhSM09namJUSXBZQ3lDdnl2alFE?=
 =?utf-8?B?L1cvL1RRTG9mUFQ4VWJHK0djZ0UwUXppVEFSSmlMcDFwMXE4NFNPMm13Wk5v?=
 =?utf-8?B?NjRidlQyTm5SR28rN29DclBEL25OeFhMQ2JMSlpWY3VGSTA0amFLeTFGSGpH?=
 =?utf-8?B?d2JYTUZZb2J3aHdyME5vUWk3SkNyK2R3WnNjREM0QzFuTVU3NzlIbVlXcThG?=
 =?utf-8?B?dUZTclM2Mm11UE13c1BnbzFhYTVNejVGUlBMOGJHUm5TVDRPbWVBWXdMaFlm?=
 =?utf-8?B?cGtTa2d5dm44SUlXS3NJZE9ySUZqdTA5cnovbmNMenRQRWxlR1VnOVJndnV6?=
 =?utf-8?B?bW80aVJWRGg2djducUVXRy9GWndlU2pvekVueEVGaDRLbkNkdU5jOHFyL3py?=
 =?utf-8?B?a0pmeGhLNnRNYTVqL3grUVp1L2tmZnZUWFRRd2EvRnZsY3VYUFhQdVdWTzVJ?=
 =?utf-8?B?QjVUbFZzTXRlOHdEaks0VXE4SkpEdFZKQ0M3SWsrV2huZmx5OU1BREJ5VUhX?=
 =?utf-8?B?UmxSL3ErTWlHOVF4NzNaRjV0ZDMva25FbWhocGpnYTVIemhvejNRYysrbFlC?=
 =?utf-8?B?bHJ6dkhLWllBTzJKWWVWTE5vSEFHc0lKbDY0UXJnR1oxMXlIeWRqZlBYemJ1?=
 =?utf-8?B?alYwcGxDbHVlM3ZNRnJLM1BkQWV0U2Q2Rm5CNzh6K0V3SGJUZ2J4QUpvVW5u?=
 =?utf-8?B?MTJNcHBxMllGTENlNzAyMXl4RU1Oc1BWL3pHa1dub3pPem85cHJ2QUJibW1u?=
 =?utf-8?B?YUNwWWFzVFdQMDFrcnZUSWROSENWWXkvUytXWUZzTHQvMnJ2cmRIMERPc1RR?=
 =?utf-8?B?dVlPcDFKZFpBb1RCdGhEWTVVNDlmcE1wWDZ5ZU9WWUM2S3VkT01SWTVRVnA5?=
 =?utf-8?B?SXExTk1wRnpITG9LejJNakNjOS96WGg1NGg1SkJoVXcrZUVLTlVlRlpHTzFp?=
 =?utf-8?B?OGl6OVBIbGkvWEJSSHoyMFVLV3dVTThIa2xZODJncUVyUXNGd0kzdFFkREJl?=
 =?utf-8?Q?UMrTO51Lr/AH5nIJ1O?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b04473-6f95-4088-14db-08df1597ba56
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 15:15:52.3080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1HoTaSOb4/96RM1jzQoCcp56Xqgm1FYLp9m0YH/rfD+PoVH4GYxDRDy1uofqJO+fqcsNmZnMYtgPtD7PgU9H5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7649



On 9/18/26 5:05 AM, Herbert Xu wrote:
> On Thu, Sep 10, 2026 at 05:01:55PM +0000, Pratik R. Sampat wrote:
>> Introducing support for live update on AMD SEV-SNP platforms via
>> DOWNLOAD_FIRMWARE_EX.
>>
>> This patchset is an extension of the RFC patchset from Tycho
>> Andersen[1].
>>
>> This series also fronts firmware_loader patches from Dan Williams[2]
>> which majorly cleans up refcount issues so that registering the upload
>> interface no longer pins the module. Without which having live firmware
>> update will cause failure to reload the ccp module as well as break
>> kexec.
>>
>> Patches based on cryptodev-2.6
> 
> Please check the Sashiko comments:
> 
> https://sashiko.dev/#/patchset/cover.1789059391.git.prsampat%40amd.com
> 

Thanks for pointing me to these comments. I'll address the relevant ones in the
next iteration.

--Pratik
