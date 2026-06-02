Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012020.outbound.protection.outlook.com [40.107.200.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89250367B90;
	Tue,  2 Jun 2026 20:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780433938; cv=fail; b=meUD7e+WC4b21nFSwafLjvQfKhyKT0G2woNDhbV5jGD/702gbnFjsAQU4cT8bMVgB2rr+3npqw0tdKPTyiOigasNRqbEjOUKzrlKXWSucc6MOzYEDgNkaFFPcHy1IKfDC09+5SrdRx/zbHkBylefjrBOBCiY+8C2RkJLBttESqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780433938; c=relaxed/simple;
	bh=EoNSAojcKfbss11N3HQiyPNIa6EnG0JnGkqKsbBykfU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jnx3yhcHoE/H/D49KkciYKnhIJ79IgqXU7YudmWlWPT2xkDUSo6S8vealQuDwg1eYUsfdsvY075EKTwPcs3TGnA+Ewv1rHrwbnmesI4xGBoTHEjSHmDdBP9ord6B5BTN9/0Y4I1Dp4q6MDjdWuzlp8P4CIh0JBuWZDDZ1ArC9LM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HjrLWBoy; arc=fail smtp.client-ip=40.107.200.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HjrLWBoy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qfcY1GzeL3lqFyxudsguZoqhUnaeE4lE/NIc3Lg1Cw68fUUrtuTF0mts4YhZmqmwyFIx43SBDjDMaWMbNEeVdyAev553wWodZzubPiO54Az4Y3SBZBQBDVyQafxVr9mQ0su3t8mxGe8viHtK+0Yff2Ejbfm6/GOTZXKlI1OFJsBhNz27Vj4PbaNSHjDbh6bf+IA0KRpuopb7negO0KX5sggBTuf6ClRl4LJ7JI5qVDD1lFe4j1bIu+NVKCCYPlLGqZJ/6I8nBEpH4dIW+UnwP+8XFDHbpD2SoQuMjT0v1PpgGc7xoXP4t3/75r12StUn3ac1TZztm5l+orqqAv1iNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlLwzgh7XeR/nE6PWLYn4lvHqfGb3mDY/qqEPNqoeJg=;
 b=YTlOarRMpp66avmMCUuKNq8IhwDA5vF2mBrwf3yS4VEj8B4kEf1vyozzHTL+YAm7vaDTHlr6s5yaof6JK9aqxygqPHd8kHhf6F9zhpMxc3DJ2waODQORAGvFMPN+CEhDW0Mawp7faTjKociVS0T3P1RYysP91Rv7jOOhmHz85R4IlMhoUs1fEIwDJsU5iAM3PaLNZdncyRn8eTRZTXvJ+tp/2ms0vJ4mXBIHL5UhCtw3/17ykd07QvwCQD7QElFtPYxtlcoT3CL7pRr64AYf8WZAvBJKUZqP25BvyXkSr/Xc+JwR/M/0oVJh5CfCDEDckkpwq7du6Y0i7gFsmOmnBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YlLwzgh7XeR/nE6PWLYn4lvHqfGb3mDY/qqEPNqoeJg=;
 b=HjrLWBoyJog8dCsCbkFHGZPK2ktr3sIdmtWnnDLAPO4Loj8qNuyNQjIrf4T9j+RnlQuHv57GxdgvEHmwVVk4i7Ddgn9Up89bELz2olQwIW2uhLCCxV05+WwQpE9+SwWlr8Xizg1y2CWdk5U5Zlf1xAz/vyu6r3S0QowLBeaOOkE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB7316.namprd12.prod.outlook.com (2603:10b6:930:50::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 20:58:52 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%6]) with mapi id 15.21.0092.006; Tue, 2 Jun 2026
 20:58:51 +0000
Message-ID: <47e2ccbc-7438-428f-90c2-285771b8ab29@amd.com>
Date: Tue, 2 Jun 2026 15:58:49 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: use two-argument strscpy where destination size
 is known
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, John Allen <john.allen@amd.com>,
 Weili Qian <qianweili@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Srujana Challa <schalla@marvell.com>, Bharat Bhushan
 <bbhushan2@marvell.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, qat-linux@intel.com
References: <20260525103038.825690-4-thorsten.blum@linux.dev>
 <e94278a8-52df-4758-98fc-e6d7e5b55491@amd.com> <ah9CMYSp27OSPxkv@linux.dev>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <ah9CMYSp27OSPxkv@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR18CA0021.namprd18.prod.outlook.com
 (2603:10b6:806:f3::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB7316:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c482465-628b-45c7-85f6-08dec0e9bff4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|18002099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	A0plQ44FioftqKYn/Nf6a6Ukwl4wdwOB5qIOO8jAN5nmpjZlFZZijloCVqk5q+N898asmYYD3omMJ+6MzFAA7fRaX8Fm4+iCd0q5khWuFoziXTFylZfivymet4qWsGEHhx/4LIr6mIHOhhEKdMYDeDCNHSoItODWO4uvFmAxJI1EUgO/IkmlEggzAlryCg2q5hCUCVtomJjstDfCg8e4vHmK5tTLyaVqcqA6AoCTZNm9gePkuTpYpEIJyKVujJE7zHRudKjOiqf3oURmfxfVCrNy3dwq75KOQzkash5I7OT+9q5A6i1qwuh1ywsB0gsq1NWThhgbR4K/u0SD1VXtkyxirZBqN1daL1WaXlwfYDQ+t7ZUAIPqPELWUdqmBzTxpqtrOxZCi3ILqO1KFKb0/T4GFkmgQsETPGPYhbTQKYiMSgV84YHBcFr5/4RAe9ON73KUnYighKmUr+zvOO/yda3Nw95jaPKD5DSy0nQPzGB1iCyu/PP0jFlQNJsXjUOboQLjtBq+CIkgOXzKo0QoU1iK9km7sSy4IOT7dcZSBXZgy3/0VbJ7qmnFp8ue1UQGZUVifzhumSUmRnWGh8At4T7UZZpn3WpTyQV2rUQoUXNwLxmIGJpOukNqM/PnVTqVpumzCV5C64Vkn6Y2Anh63+YWlr+05LVrzZVBPqmlmGWf+aSlCcnCvaAtou0UqZcD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzlkR0tRejZ0UnQxb0lrWVhOVGxUWnFzbGJOZmlzNjREVkRMakE1R0pKZ01Y?=
 =?utf-8?B?M1RxNXk1c2FyY3lYR1RsVHc3TmQ1NFRYUmswWm9DKzYwZW1JREh3cHdvbThp?=
 =?utf-8?B?bllHbkR0cmJ0SGowSlBNSExubExWams4SlJMdlVQRXNZeVJHTUQ4bTZoU2dS?=
 =?utf-8?B?Q3FUZUF4UFJITkdBOFduY25uVXRTdDQzTHV4RjlpSVFoTVpmSC94VTE4Wk5h?=
 =?utf-8?B?bi9nMUZjOFU2bzBmOW4wbnEzeCtycjZKMG5uYW9uMmtMM3RaYmsySXk1MEEy?=
 =?utf-8?B?N1JGcHpiNTNIZ0t5aCtvUmEvUHlhaWhkNzFweVR0QVhQeTZYUzJTNE5qdjM4?=
 =?utf-8?B?bE1ySlNydmg2clk0QzR6STU5eWVMZlpXM2cwRGNpRkRSWHdzOVZJdmw0Y3Q4?=
 =?utf-8?B?TmVLYVlEVlUxQjdlSDkwWldySSs0cjNUYTRkci9SVm9pTjJ3ZmYvdlNhUHdV?=
 =?utf-8?B?cHM0MjE4UlpMYmJGbW1jM0JkSkdLYW1qaTE1K2d4OWFhUW5XQjc2cHRDUncr?=
 =?utf-8?B?a2FwZTJ4OG12RGN0ZWtZaUttVnZEdnExWkFZS0U3NzVBQ0FoOG1VbHdLbHpV?=
 =?utf-8?B?OTdOMG5jZVAzaitnczRrWkFhVmZlRjl5T2lyYjFhUmNHaEtGMGN2azBaWDR1?=
 =?utf-8?B?aDlLVVJYR01iQkFrZ2phQitGRXBERFBEUm5heDh5SjBmd2JySmtxaFN0RVF0?=
 =?utf-8?B?bmQ1Z2grbkYzTDRIL21ZR3dvM1duUzVZRGtYRWlOT2d6Sko3ZWlnTWpySGwx?=
 =?utf-8?B?dHJpd05qRXdDZ21MQUh2QzBiTzUvdmVKNEUrQTI3L3psbVNaVEFUczdUWHFx?=
 =?utf-8?B?WUNMampyRXI0YTdTeG4xT0loTlN0MlYweFlkLzE3ODRIUEZWdVFkdEhpL2Zy?=
 =?utf-8?B?T09SSnlmMlk4MTd2RVlGVlBKN3p2MjJMc2kyZDQ0Ym1NV3dtanFzay9sZmFu?=
 =?utf-8?B?bXJsYW9USlllNmNYTzQvcjVweFJJcU1QaWgwNlBZMTJVMVFPWnBVNno1dERl?=
 =?utf-8?B?c0czVUpyYklsbFVJNldHc2NsLzNsSjJzQWJWV1l5OUY0MkZzSUlEbmZkcXkr?=
 =?utf-8?B?Z0RNU2RoclVpelFNbm8rVFhxWURoYm1KN2V1OFYvdmYrKytJN0lRQk1LTHJW?=
 =?utf-8?B?c3huTTZYcnUyLzhoblRYVDJlNDNZMzNPazJYRmVZWGk5Rkw4MnpVNGtaTlVW?=
 =?utf-8?B?MDdNZHNQQVhkSW1GcVRQY2xscVhjSFZueGpzRnJhcUpWbCtVV1VRZzlwd3JZ?=
 =?utf-8?B?ZFNtcllFTXA3UlkvTytRanptR3hUbE9sVmRtQTR3bTFsS0I3OElSeDI0UHhk?=
 =?utf-8?B?b09kZGlQNzVSVUtSaHJvdUp2ZWhaT1JNQ0dqOU14Q09vQ1I3UWxWK0cwWk1y?=
 =?utf-8?B?N0M1ZlZCTjFucUhoQjlMbGZqeTZrUHdxcHBFMExlZnAvVTZ6eGU3M0VwUStk?=
 =?utf-8?B?UlYwVkF1T3czKzg2bjRPcWlUajNzeU1zSUR4dGdqb1FqSDVMNmg3VFh5Ui9D?=
 =?utf-8?B?MzdjSWkzOTQ1V2VKK3dvS2Nkc2ZFNzEyTEgyaVlpTEYvQkZQR1ovWmRLMVNq?=
 =?utf-8?B?azhDYlhtTUU3N1FvL0U1aVNoaUU1aWQ5UXR2S1A2YkxHd0RiU25PSkZlTmFi?=
 =?utf-8?B?U2t4aFRMRTgwdnFlNlBUZHJSQVhiL0t3Y2dFcC9MZTNERGhTT2tFWngvaXBq?=
 =?utf-8?B?T1FCek5XYiszYUFIUFl1RzdDNTR3TVp0bmtRV0g1ZURJa25uMFBlNm96eDRS?=
 =?utf-8?B?aWFNT3RTV1Q0bDc2U09xVS9tbUd0dURiYlpzZHBYOVpGT0hJYXZRNDJDbDh2?=
 =?utf-8?B?NHJQUVNENmdqMXNleWVObzRrUUM5Nm42ZjB3MHNGNEEweDBWK1NiUlZENnZO?=
 =?utf-8?B?VTAxOWpGcXZWQzN3Y3VjcmcvQnRBWGRaNjJteSs5WW41cWVRUkhiakZXU3Bz?=
 =?utf-8?B?UW9OWVFpUHdPMmJCN1NzS0UzVmUyUzM3YVNJNDVZL1dVemVyVnZpRGJoV3lT?=
 =?utf-8?B?R1VmRDZQakN6SGZXNTBrSVh5VnR3MFRad2ZuMldCZWU5WE1ZMmNLY1M0cUps?=
 =?utf-8?B?eC94TDJNVVVtdVd4UCtWY2FSRjhzUythLzZsWG5TNDNHd0VIMDRmMGFDemNU?=
 =?utf-8?B?d2gwSENuUGxtOUtJZTJNUnpSZ1pWazgzb21SY09USWc0ZDlReVNUb3haMmwy?=
 =?utf-8?B?SWpnU3d3TFNoaFJycmVHdVhwZU94bDVodXF3S2ljbkRNcjBWZ0JMSVJRSG4r?=
 =?utf-8?B?SHNrYVRuRUtMTnJKakJoWVFaVXliekVvT1lzdmNwSjZnMUIxbWdmOU9tU2ls?=
 =?utf-8?Q?W4zarUhmvnMW7DDXh/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c482465-628b-45c7-85f6-08dec0e9bff4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 20:58:51.5841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IEP6mvZhYSYk8ZSgVQpCJFf/4mxGqKzbCt/cCuD+0II5zDViLp+PoOefpADCeaLxtoaSgWQUKmeKEZvPpD5/zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7316

On 6/2/26 15:50, Thorsten Blum wrote:
> Hi Tom,
> 
> On Tue, Jun 02, 2026 at 03:24:06PM -0500, Tom Lendacky wrote:
>> On 5/25/26 05:30, Thorsten Blum wrote:
>>> To simplify the code, drop explicit and hard-coded size arguments from
>>> strscpy() where the destination buffer has a fixed size and strscpy()
>>> can automatically determine it using sizeof().
>>>
>>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>>
>> For the CCP driver changes:
>>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Thanks.
> 
>> But I noticed that there are a few other places in the driver that I think
>> can be changed to use the two argument strscpy - essentially the strscpy's
>> that involve "cra_name" and "cra_driver_name" in
>> drivers/crypto/ccp/{ccp-crypto-aes-galois.c,ccp-crypto-aes-xts.c,ccp-crypto-aes.c,ccp-crypto-des3.c,ccp-crypto-rsa.c,ccp-crypto-sha.c}.
> 
> They already use the 2-arg strscpy(), except for the one in this patch:
> 
> $ git grep -n strscpy drivers/crypto/ccp/
> drivers/crypto/ccp/ccp-crypto-aes-galois.c:227: strscpy(alg->base.cra_name, def->name);
> drivers/crypto/ccp/ccp-crypto-aes-galois.c:228: strscpy(alg->base.cra_driver_name, def->driver_name);
> drivers/crypto/ccp/ccp-crypto-aes-xts.c:243:    strscpy(alg->base.cra_name, def->name);
> drivers/crypto/ccp/ccp-crypto-aes-xts.c:244:    strscpy(alg->base.cra_driver_name, def->drv_name);
> drivers/crypto/ccp/ccp-crypto-aes.c:311:        strscpy(alg->base.cra_name, def->name);
> drivers/crypto/ccp/ccp-crypto-aes.c:312:        strscpy(alg->base.cra_driver_name, def->driver_name);
> drivers/crypto/ccp/ccp-crypto-des3.c:196:       strscpy(alg->base.cra_name, def->name);
> drivers/crypto/ccp/ccp-crypto-des3.c:197:       strscpy(alg->base.cra_driver_name, def->driver_name);
> drivers/crypto/ccp/ccp-crypto-rsa.c:261:        strscpy(alg->base.cra_name, def->name);
> drivers/crypto/ccp/ccp-crypto-rsa.c:262:        strscpy(alg->base.cra_driver_name, def->driver_name);
> drivers/crypto/ccp/ccp-crypto-sha.c:429:        strscpy(ccp_alg->child_alg, def->name, CRYPTO_MAX_ALG_NAME);
> drivers/crypto/ccp/ccp-crypto-sha.c:487:        strscpy(base->cra_name, def->name);
> drivers/crypto/ccp/ccp-crypto-sha.c:488:        strscpy(base->cra_driver_name, def->drv_name);

Gah, I was looking at an old tree. Sorry for the noise.

Thanks,
Tom

