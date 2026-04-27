Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012032.outbound.protection.outlook.com [52.101.48.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E302D2381;
	Mon, 27 Apr 2026 14:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777300435; cv=fail; b=iowb11XIBvMeT6UanqAEsftOHviPn5ARkrNOcPc6uAAlBgWv0sUg5I7aS9sN2Nt6Qc8hS2zdYeskbDKY80IFaLgcKwqll1QE9f5S9G78g+xn0SL5Ihtn8RyBW7aC5qb1QJYyKgX3ibGpo5ChJfX9YCi6xdH2PJAwlab6OhApazA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777300435; c=relaxed/simple;
	bh=+9ERTYpYY2g1lZafE1D/O48eTdw5wvsUmcJdepMUe8E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JCZxluMNBIiG5Z3p91hp7LZNA4ctJ2GXQGT2MCjXVuIOLvJQqvOCWkLIIIUDRjyD2sQia0/FvWKrByF9glLIFoeLMCmnO5aviDKUTZELdley32VOd/JOzQDsIRKrird/F+y1e+SRZqHSwGAPyw9WL4OWIQpBUphZxCal+WCc9+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZViUPTFa; arc=fail smtp.client-ip=52.101.48.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZViUPTFa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YlGX0cHwuhaf9lvvJPWfGOM/r+1dZ0S/GAk0edKc/0HvO0LWPq4Eew5aX5mI+uohkCnaoMMfPmgxTvKJaIzYIQqk0fCFSkeOGCdWz32JYWfwnbIfr8sGtIWVjca0ySc6y4jeoQ2uSTBUo1C9F1Ocz9DDqXU0pNdgJZVvCoTXFiP48gTDgtBW7//s/xCCGvQ+0Ee2Yo+Ce7VqjB/p8iPjKqUenfR9XsIxJlaL8szihtzTef4z1pdQ8UbUL1hzqYEwIXDiW+OUu2vsm6rwnaTLEgJFdyqdV1EmesApWpYVEJ1Zr21cgRL0D8OCjd1XYeTep/qMpBAtzLBgUAwwk3gREA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jqg4PSq6hX3zWMOy9FoLNOp/BZMIzkQDP/GywSSk16Y=;
 b=kjz6hGSaRl3ZHUGdnaq/IzDYfYR+78aKWE0S8U5zUPdSe5YH0mmLpNesQ2UeL3UNmCU+S6je3Qj1Nn/Ybx46hWFBF0Ek7L3X7nkAcgyETE6IqSieeD6Ekg+sGxVXQCRpi/oCQSTwScp9NfIKLF7SY0xte3PFP1rxhLCpnuDZIIIGPLxoBfXF8ae+aTrZNeTPbAuyGOJ4PTSc7vnjw52hXvuu4WC+Mhx+u+7Lquenjk55KrjmiyO4nfDxfGUOCxIiPIV3+s45GmSDD6qbBycnGMEMpZNiIzDdUHl6LyiyRkAydAvuFO0WTLSFSeDzntouuusdAHatqy91byIga1bDew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jqg4PSq6hX3zWMOy9FoLNOp/BZMIzkQDP/GywSSk16Y=;
 b=ZViUPTFaerUEpOwjNVr4zMI0hSVMtjT2fugjSBZ2W+Jm7EIyFHyk/UG89QNIxjCLtkIYVudhr0uv8Z1H2lF2GCpg2BL4swwCWP2fe0vv5KEQa/UQuqJ9ojQ7amrV3Qmg1n03AShvnSNiPhM3sNp9ElbCfUc45gGhPz84DyjNKFQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV3PR12MB9187.namprd12.prod.outlook.com (2603:10b6:408:194::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.16; Mon, 27 Apr
 2026 14:33:43 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9870.013; Mon, 27 Apr 2026
 14:33:42 +0000
Message-ID: <9ed7d3ad-62e2-4d60-97d9-ee454d9ef2d6@amd.com>
Date: Mon, 27 Apr 2026 09:33:40 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: ccp: Fix incorrect return type for
 psp_get_capability()
To: Yunseong Kim <yunseong.kim@est.tech>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Mario Limonciello <mario.limonciello@amd.com>,
 John Allen <john.allen@amd.com>, "David S. Miller" <davem@davemloft.net>
Cc: Yunseong Kim <ysk@kzalloc.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260426-master-v2-1-dac9d1d99cfa@est.tech>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260426-master-v2-1-dac9d1d99cfa@est.tech>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0017.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11c::26) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV3PR12MB9187:EE_
X-MS-Office365-Filtering-Correlation-Id: 50aa1440-b680-46e2-1a87-08dea469fadf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	8ukqfUPeodkBcX666utYQdBZ+7CV4IEKZiyHYBdtjdalnhpBe5edImiX3jP3OaNRwj4UHCrdJI2DBOuBM2OfyNIQabkLy78z7+D1jeJODE/U29tEA8WiCloSn/N1OhFEvJdLC2ENGcknPrlwTmtBsWRlSCQfAgjHXLkLun92weUWtY0xPlktkkIiBPyUr550cWiqp8w0KPWfNi0m4x0DVROIyT6dz/B1j4a9NPpf8Y1bCWizn4SQIWmD64YW/cfcwSGh5kjlt+69yNW89bn9mUR4LN4nMUG40DB0RfACBeIIoIVkkLzh4BB3R8FDbwOCzgKCFZqHz69k9eNhjBOl+I6uYpTl5u85OxcT32yUIDQ1QAM1NhqTeCdmQsaqfqKCXz0XlG11qmBZkeyiTHc4e7Wf/aLlXQciWsiyjoShLEu3vT1dGl3WhbaNdYlfmREJex3in3woCpx+VHKXJrQNAEt3XFU2/bwlNz7rWFJE1zV4hc39A1ejCSsGyCVvv0T0XmKhCyQ++kevDSWS+1iIOpJ+aJyMwjjXSnoWXAi9HYHvm8rVGATBC1PCOi+V1JTzwwSE9cg3e4EuTbPeK/jvc7DrllKPYVFqQZOpS8timMWhVQohmAEHozHMC6Yz5MkMtRx8T6nhejeT7LUsRj1xAfolb9vpvEzZtCbQ2vhwbrjBFOP2YznFLZugyx7fG3qTWxK2fH2/wSg/mKfj9egeE3xIEDTmGZMKibxjIGtyIDE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZHduMFpaK20vLytkVnBtZXEveC9xc2w1WUZFdEZvVkRvQ3Vrd1hNN1BBWHNW?=
 =?utf-8?B?Si9ZcEtrTmpYNE5MWFlWSHZud2c2Z2tRTTdtNkZsYkFRb0JqRE9mY05kS21j?=
 =?utf-8?B?aEJTOTczSWRQSGlENGY1RDMvT3ZmMkpaSWprTG1ITHI0VG44TjdHU0t1bitJ?=
 =?utf-8?B?Sm83b3F5elhBZjUvUk0ybnFUYjRLdVZYc3dTaFk5WFJURjQ2SCs4MkV0ME5Q?=
 =?utf-8?B?QU40L1QwdloxSTFRZklDT1pNUXdKYmx4Nkd4MWtxdDJ0M1NGTDV4ZzFORENQ?=
 =?utf-8?B?OEM1VUcyTDEwNEpibFVYaUNSSmQ0WFN6WFNCQUhDTnNBaGI2eWRhYmhYSVQz?=
 =?utf-8?B?bEFJaFErUE9UZ0lGQk05d1BwZ0pBeXliWTAvQmo0MkNNcTRyS0VkWWNKMC80?=
 =?utf-8?B?dUZSckJKVm1rd3VzYitOWDFzdFcvclBOSkpibnBnLzFyc3FWUkw1U2w1d24x?=
 =?utf-8?B?NDI5ZlhpeklHOTZXY1Nidk1GY0l3TlROaEkzRE0zS3VRZU54OWVNdFQ2RlBK?=
 =?utf-8?B?eGgwb3FPdUNWY0p5OXpnTWdoeXZ6RDZSSVFRUVpHU2VEL1g3UjJZNlYxei9D?=
 =?utf-8?B?NlRUVDhxM0JPMjQydnlySkVqTjcrbDgwVXdKWG1HaWJRSi8zblY2SHZMeUwy?=
 =?utf-8?B?YXVFaW51R21mdVVzLzc1Sk1NQVhWMHdCV3FBVUF4cTl5RmtHTy94NlY2Yytj?=
 =?utf-8?B?ZVR0SkhLbnVNOWNnTDFpU1BFMlp0WFdobUpMRnJoOU5GeHpGUzRhRkk1RUMr?=
 =?utf-8?B?bTVtK2UzZzRDcUdsdlRjdllJbnNTUlFDMWRZSVJIY2tKdHN6WGlONVJRNkdv?=
 =?utf-8?B?alpTOWp0NWJ3MWhUMTlJcFI4YThCM2laMFV5ZnNQcGFkVXpQOWpvRmd4dUox?=
 =?utf-8?B?QkF2cXRxMktvVVgvczJYbkt6dzhrWndtMUp0R3ZMNkVmVHEvdUxhK1J3aEx3?=
 =?utf-8?B?L2VxbFF5M1Y5TzFQQ3ZQUVJCdm5tcDlQZGJwWU1oNHE0Rmp3ZkNSUmIybFQ4?=
 =?utf-8?B?YUlvV0dmOEtLTHI5UEhnaEpDKzNseFowT2loS1U3UGZlbCs4Y0F3QkNhanVp?=
 =?utf-8?B?aGM5cWkzZk9SZ0lVNXdZUFhRcEFJZHlNUWZTamRTWVc5WVd4RWFTUlZ4ZmFH?=
 =?utf-8?B?TTJGUk5DaDJtN0dQSXdmTXpoRlZIVE4wY09XUWoyQWZibXFra2ptUGh4a2t6?=
 =?utf-8?B?RDJ5THFOUEUvVWVVcUNKbDBCUE85dnFIdnovbWEzMmxiSEJRMXd2dEJtVmFk?=
 =?utf-8?B?czJSVHhSUWVIaW9UZXRWMzloVStEc2ZNQ3A1NkRDNlVQcU84L251bTdPdDd2?=
 =?utf-8?B?UnlIbEI2cDVoUXFxb1RXRm5jUVdEblMvb2RRbW1SaWlsWlVjbkFjbFEwLzNB?=
 =?utf-8?B?Ymc4Z3ozZmJMNzRnaERKZGlTSTl0WHlGTFkwSHRiNnlQeG9GTi83b0xiQUdu?=
 =?utf-8?B?K21BalpvbkNRdVFJUTFlVkZKTXN3TW9ZL2hmbVVhWHBpWnVLTDBSOFVWZ2ha?=
 =?utf-8?B?QWFRUG1VSmJsZ3VYdW5GZCtSL1gwc2QrODE3OGdNKy9LVDU5L1lkNmVmbzlz?=
 =?utf-8?B?eGRGc1UwYm13NHNzQ2JBckZic0xNWmRYZS9hN2g4Vkt2M3pzYTFreW45MVNo?=
 =?utf-8?B?TGlrdlFCSjJKQVpJUVVaUUpsVTZPdWVlS09vUVhQcC9Cakc4UExBWTRjZmpo?=
 =?utf-8?B?OEI1TU5JWkhuY0VLdG5INE8wV3Y5KzdTZGc4Wjl2N3FPSmltQW5UVGVhZnJK?=
 =?utf-8?B?KytUNzV3VjRhVlRvNnIxMUZRY3FQaEU0NjFVSWRlcngxRHdjTzBTUTIwZ0JG?=
 =?utf-8?B?QkJ1NlRlZHlPbmJUbXVvYnhZYnM0b1BYWTBMZHdaQnRpZTlqVml5VWROd1Zk?=
 =?utf-8?B?RzVaREs2V3ZleTlBRFZKSWp6VUJ6VWRoTmhIL21iVDR0TEVYQTZWYUprQW5z?=
 =?utf-8?B?WmQwMEZNUFQ3ZnJNK0ZQZ3pQcUJuTDlpczdibG1Hd3EvbllJeTUwY25QV21P?=
 =?utf-8?B?ckNSUVFrWFZoVDdNQnB3OHFVaGZmc3JQQTA4R1NuQlVCMEpXR0FQVnd3dTRw?=
 =?utf-8?B?Q25WN0xKYllVenNkaytHNzFqWlJ6YTRlZTYyYWVJVEM2UStMOWM1aDlkSDlU?=
 =?utf-8?B?OEI4MlNtWjdVV0hpdlNSVmMzYTRnUFVXZVFQSjFtdzcwdDBITENpZkVTY1hy?=
 =?utf-8?B?ckxMc3FrRXcrVmx4dG1XZzlpV0FZcGNML21hL2NYQzBPVkVrMUtmY0xnUUpL?=
 =?utf-8?B?L1RQTUp2OFJSMEhHZ0xjMXN1VkRSaEVkTW84UENvaFh2VmNBZjdjelluNlNR?=
 =?utf-8?Q?ISKorrGAw1OVnVu6IU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50aa1440-b680-46e2-1a87-08dea469fadf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 14:33:42.3546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQPJspGX24kkwWJXH0A780CUkuQRfn+LxQMJt19LpuVNiVXNKmfQqWCPAbA2MSE08ihipnYQumnBx/KglKCRAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9187

On 4/26/26 16:25, Yunseong Kim wrote:
> [Some people who received this message don't often get email from yunseong.kim@est.tech. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> psp_get_capability() is declared as returning an 'unsigned int'. However,
> it returns -ENODEV on failure when it cannot access the device registers
> (i.e., when ioread32 returns 0xffffffff).
> 
> Since -ENODEV is a negative value, returning it from a function declared as
> 'unsigned int' results in an implicit cast to a large positive integer.
> This prevents the caller psp_dev_init() from correctly detecting the
> error condition, leading to improper error handling.

Not true. The psp_dev_init() function will assign the return value to an
int and so it ends up getting the -ENODEV value in the end. Also, since
psp_dev_init() is only checking for a non-zero value on error and the
return value of psp_dev_init() is not checked, this doesn't have any
impact on the processing or handling of errors.

I agree that psp_get_capability() should return an int instead of an
unsigned int, so the patch is fine, but you need to rework the commit
message to be accurate.

Thanks,
Tom

> 
> Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
> ---
> Changes in v2:
> - Address feedback from Tom Lendacky.
> ---
>  drivers/crypto/ccp/psp-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 5c7f7e02a7d8..664cd51bbf0d 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -141,7 +141,7 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
>         return IRQ_HANDLED;
>  }
> 
> -static unsigned int psp_get_capability(struct psp_device *psp)
> +static int psp_get_capability(struct psp_device *psp)
>  {
>         unsigned int val = ioread32(psp->io_regs + psp->vdata->feature_reg);
> 
> 
> ---
> base-commit: 7080e32d3f09d8688c4a87d81bdcc71f7f606b16
> change-id: 20260426-master-eba8d68042ab
> 
> Best regards,
> --
> Yunseong Kim <yunseong.kim@est.tech>
> 

