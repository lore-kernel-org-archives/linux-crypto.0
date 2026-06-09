Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012014.outbound.protection.outlook.com [40.107.200.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00133AFCF0;
	Tue,  9 Jun 2026 16:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781021976; cv=fail; b=P5mo+mIr/PwK2XEN9q5fY69UBVcIljcWEPtNgGcFSp2Wrz/b08UBcAVmXQCEENuaVCq9eFppE9e9ElUbi4NvjOK4ENjtbsCJXJxbCwvpywxI6acV2x/a9aE9w8kw2NVa/OhNS5uSDv0rAjfgYwIZIAhU255ZsSZw8wtGLjl+gHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781021976; c=relaxed/simple;
	bh=g8d6UuSMSSGt/RWxgPde77Dy+IoMiugDmMt4gFWxLi0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f6Q8ijeYm/NpZkZS3Z2FwrWZKd+/xkKuYYumGHfHzvyoFCIAkfgU2TAaIheXRuZR7g8psEReov6GMyCZkFnR01R7Yj0erhm8SWGinz70r1oPHdObLPSmFJ7HSu0DDZCwC+SBX5CcvHXxUBo031dKFLubmEKYtNDaFQCUFRznLq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CfjGaTBi; arc=fail smtp.client-ip=40.107.200.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CfjGaTBi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kw+i2Lj64LO9WDnsSVmDvey2dEFzjDkn7TUk/9rxi967b6p+FCRhzDKPMHll+3BKZ7WWmwOUtn30Ft9YGH7ANsip9RN8oQTK2DSDkRCCLbtniS1ftyif+pqODDyXbAjtLbl/+0tVyPuAPaPdP9ZKpEkhfSpr6pEgKBfJnJKBg2tGTUH3udSXvO/bm3ICVxrUSEgoDAuAfCeA1zcMkOC9Lx4cpqu9MhGdtvcZh352b8i/JtKGZQsvcm+1Pch4rqpo4ySIIqPn58BefA6fX08Co0Ym8vXXCskG3nUxCBIKslV1aPhlxh19osoueF8p60PZEsjSHE0YkSf6/y48QwqVVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYkKNhW1XqwG/1rfQ7lX5Ef9WNrDLbf1Ez4+Z7Rpu88=;
 b=UcASjgMsfxWmQuF0hbjz3usJgopa0swsn+I+I9lHQ5PUJVRPGj6LNVJK7hQeFkEQSaCMYR4aTy1ScnO4zP650hFnZDACF+9CMRlsRGcE2YI8mx4JELDZjnx1icwT7+WXFwjQRp9VNf7E/0Fojq+PXakr9Dsa88LqPT1CllsvMyuVBAZm2irTXzku1JoXEeV2EQDoT5qcrZxt32la+X+B+rwQ2F26Iirx2vduKYDJ9l9fjTwneanUd6JrzCp2KtV02dvu21gSagLuFVgZe5S4glRm8W/8Cr6BcEgToYz5Wfl1kwFFcoPca7MrQ748/efeQvsLkFspG2HoQtoWVN9KzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYkKNhW1XqwG/1rfQ7lX5Ef9WNrDLbf1Ez4+Z7Rpu88=;
 b=CfjGaTBiy2KGUK3Q4Hhy2DsNnsZ1v2LLLEnAnrD6Z9QgJ1aEBrA3gNjUekB22kcPiYwVMoboX2cBd3dYA66q1TZ0+N9WnatZzWmqGpU1tRubQnpHkUko1cluKv4/znD/Xm4xy9QyRA5YYKS4oqSqtC3RaRBTpfNWJ7F9D0DCwr8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by DS0PR12MB8219.namprd12.prod.outlook.com (2603:10b6:8:de::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 16:19:27 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3%5]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 16:19:27 +0000
Message-ID: <6c9d6f7b-9d94-44f2-a73b-1dfe64bb6b87@amd.com>
Date: Tue, 9 Jun 2026 12:19:21 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
To: Tom Lendacky <thomas.lendacky@amd.com>, ashish.kalra@amd.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, aik@amd.com,
 tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com
References: <4957b07dbb4029a4c59bb3cf35f068c36284aa48.1780693665.git.prsampat@amd.com>
 <c00d4186-2a89-4c24-be02-6b6a05450fe5@amd.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <c00d4186-2a89-4c24-be02-6b6a05450fe5@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR17CA0019.namprd17.prod.outlook.com
 (2603:10b6:610:53::29) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|DS0PR12MB8219:EE_
X-MS-Office365-Filtering-Correlation-Id: d3921c23-017c-46a5-5e19-08dec642e05b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|22082099003|11063799006|3023799007|4143699003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	n0aUG5ZCGTp9wtSnePkT/O4czsFAXimpaZP0X7GdW7sCJAOhjA/Ljxn0DyhcMp9lH7os+WEopSMtygGHSivL+LWM1eYBq+JPZ6M1lwxKhqSuYrSOf4ppQNjLEJez+6c3+oJQMduaS2H2T4+rcm8mdtr3h0eg3lK7f1846WY2blSPTQaIB/Hw0EjA52YKfDTNSV3DbDbUuYSgtYm2t0eA+0xSvfn1uCmyaMSEglDQF9gtSTftQyyh5fw98udFMJlok33LA6CTGXp4LGvfAQpyzS06wEYU42CD/IO4UzalWJYgwxMg6SXQANyHcN3pla8iv5T6Xn7nVm6ycMN0cYE3+CuePTb8koNqpG3gjXlBuviPcMjFjitaF3XxJ7RdbiIN3Hdw7u9UtUA144ET+WG4iVKDCcexeS3wHDO0j5prt2sutkduzN6Z+E0+8ZEk41J8lyvpF6BdROAtnZUGIZT9port8xdZGDKZg8BE1r95MbaIL4Nrr20KpfbdYdnnyu1cCVyfLk+imSRsZrMG+7YS34D5LQZuy/MrytH5lqr7a6wa/VdpSN3f/FQJiBKUEdcVX8N+71QP8aHsV6FeH73LK/UuHW6pUUPIFQ8YIkNiy2mkRFvwVxMetB6f1A2d9/cW6esb4kFty6SGtUbznRvVhwLRnn7tXnUa4mX0cyC5gBiGallAay0W/yGgv02gJwJS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(22082099003)(11063799006)(3023799007)(4143699003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dktTOENhakZkdHlqcWd1NFJhSytYL3BiYm5DWEFaemxXWnhqS2ZuM3BsRElS?=
 =?utf-8?B?L0Q0WUhEek5PQWJmaTh5UTBjSTZMcWxPTUwwMjNMUlZqS0JZU0Rld3dRbWpT?=
 =?utf-8?B?NFdGMnlQZWF2M0VkUTNGbS9sdzdtUHNoZDZjbW40QlhjcU1iRDhHQ3RObVJu?=
 =?utf-8?B?ZmNwUlRPZmg2M0NqUGRDVlNOaUJWSEkwdEI0QjJvSjczM3k2YjRKKzhnSVFh?=
 =?utf-8?B?ZVozNEVadGtWVERYSCt3K25aaHA1aHJRYS9MSng3aVlMVjJXTVlJUDdqYlFB?=
 =?utf-8?B?RHV3aXk1NXlRT0RSU1FNY1p5aStFVCtTZGtNekQ5QUVIemU3MjNoZ0VaWHFN?=
 =?utf-8?B?UktqMjRYRHo0Wm9Vbm9aWEVrWEZuTHJhOFgwcWNhc3FHdzJrOS80SEJab1dj?=
 =?utf-8?B?ajhXTTB3bWdaN0YxRG9kZEJGVzc2bGF1YTlkVTU0aWlsWDRoSU1xa2E4Z1ZE?=
 =?utf-8?B?Z2hEL0ZNdW54RFgwNHdJWjU5VFpCNGlzYjM1K3FZWWlkcGNlNFFwNzkxUDhT?=
 =?utf-8?B?OCtnSXdjYlc1d0djREJwN2VzdmFLOUhkMkEzeC9VUVorTFhERmpJVjJUNDlh?=
 =?utf-8?B?VWd5dnR4VGRKbWxEci9QbkpZUkp2d2V4RVJjdGVUbGljRHBSZzJTNm92RUd1?=
 =?utf-8?B?bHZFUDAra1F1anJjd2V6Q1Bmd3VkOU1HOVlHbjRZc0hING9Kc0tjYUJjS0dL?=
 =?utf-8?B?Ry9xRzgyV3E0S2RMNE1pYWdvWkJrblZHcWlHNVhZRHJGQXpuRFF3KzJYZDZ0?=
 =?utf-8?B?S3BpWUpsRjBaK0VRNjFOOWE1WXEyRWkySmRVM2lGM1FReHp0U3NyeXNYRWdD?=
 =?utf-8?B?MlBrU1RsODVyL1lQOU9BQm1tRnNKc0Z0K2g5VS9BZlJCSXJkT2NqdlA1U1JL?=
 =?utf-8?B?ZEJFU0pETDM2WitUaGwzRStHcGtnRVhYSEVMc0tHalNpWXNqb0ZpZjhvc1pi?=
 =?utf-8?B?M3pJWUNCL1pobkIwSnphTGNJRDhlM0NDNEtaSVpPVXhTbFBadmpma242Vkty?=
 =?utf-8?B?THNQc3kwWnJzMTZMTmZrelFDNjZ1UVNhYXZNOFBheklTMEUyeUIyWnNYbWND?=
 =?utf-8?B?THBGM1U5T0JscFMwQ3hCRTYwSTZ0bFB1WUdSWVl1MVhCVlhoR3ZDN1hUSmhV?=
 =?utf-8?B?YnFyNnRqUGovZFVEQzNucDBYMXJPTXl5bTdHQW9YbjNBVUttZ2grYWNpcWt1?=
 =?utf-8?B?bU9TV2s3K2JqeUNWNVVxS1lxdWVJTnprZytjaW82dDZaOWdzbUNjNkFMSHIy?=
 =?utf-8?B?b1hhYjAzVW5CR21XVjlvTDNFQ2lqSnN0WkwyMEhzTGE4VnRMUGtHQ3BtM01S?=
 =?utf-8?B?Rm8vR0trV2wwU1g4SXlUVjNCSHFWKzNldDBDWEE5K3dybW54Y3AvUnhWejBI?=
 =?utf-8?B?Q1cvbE1Gc2c2R2JCMndsQUdwVmEyS085ZzlqV1lONzIveUM1ZjFCRGkrZ2lO?=
 =?utf-8?B?bDl3ZGVlNUhBbnRDc1Nhczl1QVJIdlZNYmVCVlBFZjQ2R3NIaUpValMxQVNo?=
 =?utf-8?B?S090dDR5L0JPQWdxWG93V280SG92aUM4L1FDb2FYVjk2UEtVRExVUzhVaTV5?=
 =?utf-8?B?eUJYUC9MOFJ0dk5Rd1ZwcG9tb3J1d2RjVlkwUkxTc3hvTTJ2V25ETXovN3NN?=
 =?utf-8?B?eUEwVEIvaWRmUWowWTRUV1RkNXZQcVBBSGZ1YjRpTmlUd0pZcFRiQmp3cEUz?=
 =?utf-8?B?SjEwZmZrZStSWlVwVG9vUDlIc2huQjJaZTZjM050YzBDbk1rL1QwdUVnZklO?=
 =?utf-8?B?eUg2bk1TNmJWL0t0WDBkK3dwL1NKaU1GYnRpRm5BYnZKNEp1WktRR1ZWU09h?=
 =?utf-8?B?S1pRQjcvUzJxdE05ZUFVbzNuSmI1T2pVQjNwV0tsY2ZFWWwwbWRZZ1l3eWRn?=
 =?utf-8?B?d20zcnlKWTdHTTlWNUFBZE5IczBJTjVBTm9TT01iOG8xQzVrTzBHcSsrS1Z4?=
 =?utf-8?B?Zi8rZEVaTVoxM0RnU1NyeXpqYVV0UlVZMnJ5Y0o3MnpSdGFpRlRQeU1TKzFE?=
 =?utf-8?B?Z082NkVIUjBXeFJIbVQ1MGRieGphcmJzblRzenRSbXZmSE90dGpmSXFnQWNj?=
 =?utf-8?B?cFBSUjNsQi9yeHNLMG1RdTJrZ3l1dWhVRHFWUlhzRUNQd3FjRGlIcXpwekVV?=
 =?utf-8?B?ZlVUTmxZQkN1WmI4VWJJUUIrWFU3RmpLb2FCbElpTFlzWVF0bThpOHk1aGMy?=
 =?utf-8?B?ekpPSTNkV3NVQzRHL1JkRWZsY0U3c3RpMXBYSDJCdjJuUmFTUWdWWmtLV0hP?=
 =?utf-8?B?cHpDd3dXVWFKNVdJNzJCbkY4RjJqcGJ5S0hnVFEzNCtDZS80SVRtWjUrUVgv?=
 =?utf-8?Q?iZt7BgvZ7b+Cta9sV4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3921c23-017c-46a5-5e19-08dec642e05b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 16:19:27.0144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mKhzf1Qkuy/wPvBNPOIJNUJC+quxhQukjQvtj2QbMKZoI19Vpx1WPT0DWzLtySzOPO9ngYB1E/6cGkx870JxaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8219



On 6/9/26 12:06 PM, Tom Lendacky wrote:
> On 6/8/26 15:58, Pratik R. Sampat wrote:
>> The SEV-SNP firmware provides the SNP_VERIFY_MITIGATION command, which
>> can be used to query the status of currently supported vulnerability
>> mitigations and to initiate mitigations within the firmware.
>>
>> This command is an explicit mechanism to ascertain if a firmware
>> mitigation is applied without needing a full RMP re-build, which is most
>> useful in a live firmware update scenario.
>>
>> The firmware supports two subcommands: STATUS and VERIFY. The STATUS
>> subcommand is used to query the supported and verified mitigation bits.
>> The VERIFY subcommand initiates the mitigation process within the FW for
>> the specified vulnerability. Expose a userspace interface under:
>> /sys/firmware/sev/vulnerabilities/
>>   - supported_mitigations (read-only): supported mitigation vector mask
>>   - verified_mitigations (read/write): current verified mask; write a
>>     vector to request VERIFY for that bit
>>
>> The behavior of SNP_VERIFY_MITIGATION and the pre-requisites for using
>> it are bug-specific. Information about supported mitigations and its
>> corresponding vector is to be published as part of the AMD Security
>> Bulletin.
>>
>> See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
>> more details.
>>
>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> 
> Just a few minor comments below, but in general...
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
>> +static ssize_t verified_mitigations_store(struct kobject *kobj,
>> +					  struct kobj_attribute *attr,
>> +					  const char *buf, size_t count)
>> +{
>> +	struct sev_data_snp_verify_mitigation_dst dst;
>> +	struct sev_device *sev = psp_master->sev_data;
>> +	u64 vector;
>> +	int ret;
>> +
>> +	ret = kstrtoull(buf, 0, &vector);
>> +	if (ret)
>> +		return ret;
> 
> Should we save some time and check for vector having multiple bits set
> before sending it to the firmware?
> 

Sure. This can be a quick sanity check and can save a FW call.


>> +err_verify_mit:
>> +	kobject_put(sev->verify_mit);
>> +	sev->verify_mit = NULL;
>> +err_sev_kobj:
>> +	kobject_put(sev->sev_kobj);
>> +	sev->sev_kobj = NULL;
>> +
> 
> Extra blank line.
> 

Ack.

>> +}
>> +
>> +static void sev_snp_unregister_verify_mitigation(struct sev_device *sev)
>> +{
>> +	if (sev->verify_mit) {
>> +		sysfs_remove_group(sev->verify_mit, &mit_attr_group);
>> +		kobject_put(sev->verify_mit);
>> +		sev->verify_mit = NULL;
>> +	}
>> +
>> +	if (sev->sev_kobj) {
>> +		kobject_put(sev->sev_kobj);
>> +		sev->sev_kobj = NULL;
>> +	}
>> +}
>> +#else
> 
> Just add the CONFIG option to the else and endif, e.g.:
> 
> #else	// CONFIG_SYSFS
> 
> ...
> 
> #endif	// CONFIG_SYSFS
> 

Ack.

>> +static void sev_snp_register_verify_mitigation(struct sev_device *sev) { }
>> +static void sev_snp_unregister_verify_mitigation(struct sev_device *sev) { }
>> +#endif
>> +
>>  static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>  {
>>  	struct sev_data_range_list *snp_range_list __free(kfree) = NULL;
>> @@ -1673,6 +1824,17 @@ int sev_platform_init(struct sev_platform_init_args *args)
>>  	rc = _sev_platform_init_locked(args);
>>  	mutex_unlock(&sev_cmd_mutex);
>>  
>> +	/*
>> +	 * Register the sysfs interface outside the sev_cmd_mutex. The
>> +	 * _show()/_store() handlers issue SEV commands that acquire the
>> +	 * sev_cmd_mutex, so creating (and on the shutdown path, removing) the
>> +	 * sysfs group must stay outside that lock. sysfs provides its own
>> +	 * synchronization between group creation/removal and concurrent
>> +	 * attribute access.
>> +	 */
>> +	if (!rc)
>> +		sev_snp_register_verify_mitigation(psp_master->sev_data);
>> +
>>  	return rc;
>>  }
>>  EXPORT_SYMBOL_GPL(sev_platform_init);
>> @@ -2752,6 +2914,15 @@ static void sev_firmware_shutdown(struct sev_device *sev)
>>  	if (sev->tio_status)
>>  		sev_tsm_uninit(sev);
>>  
>> +	/*
>> +	 * Remove the sysfs interface before taking the sev_cmd_mutex.
>> +	 * sysfs_remove_group() waits for in-flight _show()/_store() handlers
>> +	 * to drain, and those handlers issue SNP_VERIFY_MITIGATION via
>> +	 * sev_do_cmd() which acquires the sev_cmd_mutex. Removing the group
>> +	 * while holding the mutex would therefore deadlock.
> 
> s/would/could/
> 

Will do and re-spin, thanks!
--Pratik
