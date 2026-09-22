Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010043.outbound.protection.outlook.com [52.101.56.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FD85349D6;
	Tue, 22 Sep 2026 13:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790084773; cv=fail; b=djAM/wvPHN6RQgDxyh43sZm02iOUYecEap2IShqwUCbtAZcJzz3m7M6KcF8qGttZym0LUeb59J40oua5U/mx7EM363ADThdQaI5FEotdzdW79GRCSIvEFujRKSiU9E69YRwXTOuYa0VTlcOueehKiJnx2qT3HXgXroEnczmNB9s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790084773; c=relaxed/simple;
	bh=5oIBQ4fHztXdflPbs68m/GlIAEnA4Ox4oIN9jKckbjI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Qb2uRCoY6k3WVQcUUUwUaihH591HmfLkZk5C6GHnLVSN5874zKE+jedjQ8aTRD7e6IPycgx/hRPGND5gMoicKWXoVpQmdKzg7ng/GUEPJAenBSgvyRvPne2fnKNwexPxISYmTAKCxYKxDe60wl+zsRLgzi7vRL4Xn1uYdz1D3xw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=REgJPqV8; arc=fail smtp.client-ip=52.101.56.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="REgJPqV8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k81cxNX42ZcXM1CAllDBOxz0Vv2aJP1hKuJRviq8UkwTgjY9L18NmZebmWr8TJvVHqEyZFBQndWOPw+0crJhGvgehU4ezYdxDijDuQ5QdaI93RLOe86VBBPX0cnz/iegWtjDJ7F7Z5h/IQPHkwfj2sMRCZ6b+1YHs9ecEn4X07vBnJTPnOKvAAo3r6oSMthfcOS89iHTZP6dW67+Tc7ogpMqO5k/mS2wEnbq/oz9nMX2BrxMws+RL1xSSFsOTtRYJldDVvE/1YZIEXTVwBlM/Uz6zAn+T1+o8ZL27sQIZakD7HhF5mAaEPwXvqMeFYnevEvrppcAtld03jfBGZgKAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3tHf7J97uBFW6mWotyXcpk0cUAExJGR8NXipS2an/Hk=;
 b=qGf67J3y9fBbiVVHeKWDiJMHTrd7O5vCDeHXA3CFgDB76z+aswniWaQoaDF5OnI/nbR3JfHvcryDR9PzmOTU8q+KLn1mzezetKWRteWg8g7qS1CJUGA+34GNpyfoRWzVIey9jWP8kfPo5cd7rGAQfWkh8floH34NG1I2pkkChWKO3vV7Sm6TSMjsgXzHWIccXdh4AfXmnNhQTeC48H6Ja74G3TuuWexsl9OFTkOlGVk6IkQLk3VmAuWowNHjYyuHHhqtIzg+t+evchms2cJjJKJqfOZ9K+uf8yJzdjRFt2J4K/7NnGXBploOaELtTEcqiuttAz/+o5xUkygxRX70Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3tHf7J97uBFW6mWotyXcpk0cUAExJGR8NXipS2an/Hk=;
 b=REgJPqV8HAuKszRR5Viz7wi8XBr1smW+Cc7mPmb4Iw+3ZDReuwsumEx0bc5KwceAZxEhyHODIQy22K7YjIA8bNhs0iQqevoqvMsdhM9ZcSGiHNnTb9gjOXvqOEszmBBflLgVR6jpVGyDqXKqpUxzulsmgxuI4jp5kIIRNNzH+KM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by DM4PR12MB5889.namprd12.prod.outlook.com (2603:10b6:8:65::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Tue, 22 Sep
 2026 13:46:03 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 13:46:03 +0000
Message-ID: <f7c1c234-bdc3-4db4-8bde-dc823d18b6e6@amd.com>
Date: Tue, 22 Sep 2026 08:46:00 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: ccp: psp-sev.h: clean up kernel-doc warnings
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Ashish Kalra <ashish.kalra@amd.com>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
References: <20260918232736.3095763-1-rdunlap@infradead.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260918232736.3095763-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR15CA0002.namprd15.prod.outlook.com
 (2603:10b6:610:51::12) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|DM4PR12MB5889:EE_
X-MS-Office365-Filtering-Correlation-Id: d404afb3-0019-47c5-3bdd-08df18afd7d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|3023799007|11063799006|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	6rgBvcRUvXHGTJznqk/T8czuPX07vWnWrBLPfeA9NGLLbm9sArSY4CwcPcCrAR5qwxTzr856u8uxJ9tXWvSMJ62BNECIKrsQsMPLsh/3ZZZ3E+PdCvSzYRsPlpTuGbXg9M+xTRdQ3cwAO9CqZc5U8Ts5gLVOG4uvDwnMqWiNEZb+0UwAR/4LMPhJYCHwJC23f6222NgyCQWfu2XJYP40CoZZWQwpIfPoUfgJWyMW/ZFlBqoZ7K2SkpfVTvxVtchKYZEAfLGLH8cRN5AR5CA38qa+vw7hwbjvWaonK9N8O1onraOgbUdzk/fFXpUL28DEBstYvi0t3eT7Jic9zzWviYc6UEo5rKv9lzcpD2LYyMqs8OJnvz8Mt1WFq2D6SNQ8S6Hwrfr4V9qQLVmtU1JSfQJHcJhW4hTP8PTgw4CNA5h7s/OTez9WdH00zChbe2BiS0r/cRIEc8sZi3euy7Sd1RU2bymnhyLhy20EhxPvdfaU/Co/Lnt7Tu1NaCQT67ZwzmWOjla419WdxYOfDC040SmdoUsjNfmwgTIPjlFa/6vcLUbGFdBtKeMUwDeyTLPVGaSBWgkLqlkSnu+NtU7l6Oz0Ik/jAXUQAp0dNiyhfpXhke9EqFJWSlfBH4Zc64n2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(3023799007)(11063799006)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d21pZmZDUDh0QUhIVmtWT0kycDRoNmp1ZVNWSExMMC9mdUgzOEhyQjNSRmFu?=
 =?utf-8?B?M0VERXpVWlNheXI3QzZ4bTg4a29Fd3hQanBxdjRYVHN1Q2RyMEEwYUhkTlRz?=
 =?utf-8?B?VTBjTFV5bE1nVElCMGc5K0hOSUNOYnhDWUR2WG5CeiswMitPRTJ5OTVVaklM?=
 =?utf-8?B?V21Sc2sxbTV6WE5DRmM2S1RMSVY5TXplK2hQWFpxWm5YVmM2Ulczd3pmOUxC?=
 =?utf-8?B?Vzc4UDE4dGhrNXYyaElnZktsNGMwdmVpd2RwTkh4c2NuRExYWnVwcmQrN1BO?=
 =?utf-8?B?ZWQzMG9QSmhrRFlLZlNZZFdyVlZ4TUc4clk5NGhFWk9TTHM2UzNZMUo0Zkgx?=
 =?utf-8?B?QWtYcVBWQWVNSzlZLzFZWG9tT0t2VFhvNTlTY3RNMytocmNIMTZidDd5YWhp?=
 =?utf-8?B?NkNWdWl0WlloaHpZOTd6UWVvcjZ5Qy8ybmNnK0RucEtodjNUQ2hSYkJTT3ZH?=
 =?utf-8?B?TUNaaDd0K281QXpDZ3ZwVHFwODlHcEkwdHBQZUkrKzBjbmhiMHRNSkhCcmNs?=
 =?utf-8?B?dWM0MHJwK1phc252a0dNUGNSSTZ5K2VkV1BkMWJZWndXaVZBcGk3Ny9aVThk?=
 =?utf-8?B?UG94eG5FNGZmd2xqVWdWOGtlNWFka3lBZE9YZkdYSjFYMzAzY1Y4UW5lbkpB?=
 =?utf-8?B?QW1uOU5XMWFlK0FaRi9nclpzS0c1S1NySEoxQnRDR1MzOE82d1dYSUVQd0Vm?=
 =?utf-8?B?SXNQeTVHaGczVndCRHJUcE9ycjVZK0J6UGY0a3djSUFmTXk2b0MrUFZCNmFx?=
 =?utf-8?B?REYzTlFTYWg0ZXp1cUFCMjg2eWVWSU9FTENCU0ZHR1hGVFh3MXBpL3gva0pC?=
 =?utf-8?B?S01JUmlvR1hoY0U5OUtEM29nS2JId3pLT1NrcWFxYS95bGMyNE9mQUVyOTFv?=
 =?utf-8?B?VktHSUpvZG0zeFk4K2VXa1VyZGxZaldGV2hCcTFNTHZGSWxyaGRPcnN6NHVv?=
 =?utf-8?B?aFM3NW5KSkw0Qjk2aFEyQzdtaEVlS0Z6NDhKeUtmVHNlNklUczgyZTJhbjAr?=
 =?utf-8?B?MExScm12WU44Wms0Z3N0eDU1ZU9UK1NOdFpUMmJVd0tiM2hzczErSzloT3dX?=
 =?utf-8?B?QVlxOHN2MjhpOEY0Wlc2Y3dxd0hwSGY3QzFsUzM5Um9MWjFsakt4R2NXdUFo?=
 =?utf-8?B?UDZFVlRZT3ZwK2E2dW9YQU54M1JURVVLNU5XSWxob1Rqb1VUQTk0d2NkcWZh?=
 =?utf-8?B?MXFVQTRZVDlIdmZ2NVQvbzhOa1VXZndXUnhpTGxxQkR3a0RYam5NcUpwUVlE?=
 =?utf-8?B?dVQyb2l0cDBHa0xlcDZLYmxHaXBXazRnZkdmSFRXTzQvMHlpRHM0TmNpMEl5?=
 =?utf-8?B?Y1hFSThRTmltdlZLZVdxb09UYWlxTVdTNE03RmZQYjZFRWdJaTFkUldUdkQw?=
 =?utf-8?B?dTdqK0hrMHZVdTRsQVdyNHBZeDVSaXlpL25xVFhNcW9nRDhkand2TUEvbW02?=
 =?utf-8?B?Q0pBaEJWZzE5MTJkaDFxWmJHeGdlRG1jcDdNY0xaUFB4aHVOcjlQZDhkRExt?=
 =?utf-8?B?QVVjQU1JdTB0T3JNaXo3aDNxdkpUZ3NnSmc3TlExenN2dm1OV0l5NG5YbHQw?=
 =?utf-8?B?WmtSdDhnTmhDbncvZWx5K2NnTCt6bjROSkEwQ3hENmYzYTUrOXZESUpJYW1V?=
 =?utf-8?B?NDdNRmdrSWRVQUppNzhqa2diWFZyakpJV0Y2TFd1RmZVMmt2V1NaMjlBcG9h?=
 =?utf-8?B?MUJuV3p0NkZ6OEYxMklwOEZoQmJ2Yko4STFBWXdaSmVxY3p3VnVqN2dKbnFM?=
 =?utf-8?B?V0xmVG9GRjRYNjlvQS82STFxRmdDK2ROdW91NkU4Z0tWYnZSR3pTSXhneVJ1?=
 =?utf-8?B?L2xReXg4MDF0Sjlvd1A4cFI4ZUt5eGh6amljQm5DS0VXdmN6RTVKdkpPS3Fo?=
 =?utf-8?B?NnE1RlNUallGcXptTHpRYjY5QmxON2s2UmFlWkt5a2hkbERZQTlFeGsrVzBX?=
 =?utf-8?B?K0tYODdNNFVSM1UwQW1KSWZmYk96anI2cGtEWlBYTUpsWGVySjBnbzVQU2Rk?=
 =?utf-8?B?ZWhhOFNjZ1dlZU5jUmR3VWZHZmhRUHdCVkRkN3VUU2o3UHVEelhpcDR2UWhL?=
 =?utf-8?B?SnN5M0ZIdkZlZGdBdGFqRnYrOW5HemtlbnkvTURSK0RrWTdsVHJCbTdGK054?=
 =?utf-8?B?K1RYYXZabk9Xa2hic0NxbmZIM3c4RFNBVi9KMldzWXFmNSt2YnlSb0gvYWox?=
 =?utf-8?B?L0lJVXQyL1YyWTZtYzlVa0s2bVdIa2lUNjVHOUtZUm9lZjM0Yzd2UHBDWUVM?=
 =?utf-8?B?MnZCNnh4eVhGRjliZ21NM01qRHRSaDNobVN4VDVwL0Fnd05EUVpiNmpsNU9F?=
 =?utf-8?Q?Rnt7hKhFJmsbn9fumw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d404afb3-0019-47c5-3bdd-08df18afd7d2
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 13:46:03.1192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E6iIIIC5XZWa5YBO2zmUdgjK9zCnW+ABzRhAQR4ZHnQRgUVZPDeSuFKCHQcaN6ZJHVKxQph3+uuDKNGthbXmsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5889

On 9/18/26 18:27, Randy Dunlap wrote:
> Clean up kernel-doc comments to prevent warnings in both
> <linux/psp-sev.h> and <uapi/linux/psp-sev.h>.
> 
> include/linux/psp-sev.h: (62 lines; edited for brevity)
> Warning: include/linux/psp-sev.h:52 This comment starts with '/**', but isn't a kernel-doc comment.
>  * SEV platform state
> Warning: include/linux/psp-sev.h:63 This comment starts with '/**', but isn't a kernel-doc comment.
>  * SEV platform and guest management commands
> Warning: include/linux/psp-sev.h:167 struct member 'reserved' not described in 'sev_data_init'
> Warning: include/linux/psp-sev.h:187 struct member 'reserved' not described in 'sev_data_init_ex'
> Warning: include/linux/psp-sev.h:216 expecting prototype for struct sev_data_cert_import. Prototype was for struct sev_data_pek_cert_import instead
> Warning: include/linux/psp-sev.h:253 struct member 'pdh_cert_address' not described in 'sev_data_pdh_cert_export'
> Warning: include/linux/psp-sev.h:253 struct member 'pdh_cert_len' not described in 'sev_data_pdh_cert_export'
> Warning: include/linux/psp-sev.h:253 struct member 'reserved' not described in 'sev_data_pdh_cert_export'
> Warning: include/linux/psp-sev.h:253 Excess struct member 'pdh_address' description in 'sev_data_pdh_cert_export' (did you mean one of: 'pdh_cert_address', 'cert_chain_address')
> Warning: include/linux/psp-sev.h:253 Excess struct member 'pdh_len' description in 'sev_data_pdh_cert_export' (did you mean one of: 'pdh_cert_len')
> Warning: include/linux/psp-sev.h:446 expecting prototype for struct sev_data_send_update. Prototype was for struct sev_data_send_update_data instead
> Warning: include/linux/psp-sev.h:469 expecting prototype for struct sev_data_send_update. Prototype was for struct sev_data_send_update_vmsa instead
> Warning: include/linux/psp-sev.h:506 struct member 'policy' not described in 'sev_data_receive_start'
> Warning: include/linux/psp-sev.h:799 struct member 'rapl_dis' not described in 'sev_data_snp_init_ex'
> Warning: include/linux/psp-sev.h:799 struct member 'ciphertext_hiding_en' not described in 'sev_data_snp_init_ex'
> Warning: include/linux/psp-sev.h:799 struct member 'tio_en' not described in 'sev_data_snp_init_ex'
> Warning: include/linux/psp-sev.h:799 struct member 'max_snp_asid' not described in 'sev_data_snp_init_ex'
> Warning: include/linux/psp-sev.h:843 missing initial short description on line:
>  * struct sev_platform_init_args
> Warning: include/linux/psp-sev.h:893 expecting prototype for struct feature_info. Prototype was for struct snp_feature_info instead
> Warning: include/linux/psp-sev.h:956 missing initial short description on line:
>  * struct sev_snp_tcb_version_genoa_milan
> Warning: include/linux/psp-sev.h:973 missing initial short description on line:
>  * struct sev_snp_tcb_version_turin
> Warning: include/linux/psp-sev.h:1053 function parameter 'filep' not described in 'sev_issue_cmd_external_user'
> Warning: include/linux/psp-sev.h:1053 function parameter 'id' not described in 'sev_issue_cmd_external_user'
> Warning: include/linux/psp-sev.h:1112 function parameter 'data' not described in 'sev_guest_decommission'
> Warning: include/linux/psp-sev.h:1112 function parameter 'error' not described in 'sev_guest_decommission'
> Warning: include/linux/psp-sev.h:1112 Excess function parameter 'decommission' description in 'sev_guest_decommission'
> Warning: include/linux/psp-sev.h:1112 Excess function parameter 'sev_ret' description in 'sev_guest_decommission'
> 
> include/uapi/linux/psp-sev.h:
> Warning: include/uapi/linux/psp-sev.h:18 This comment starts with '/**', but isn't a kernel-doc comment.
>  * SEV platform commands
> Warning: include/uapi/linux/psp-sev.h:39 This comment starts with '/**', but isn't a kernel-doc comment.
>  * SEV Firmware status code
> Warning: include/uapi/linux/psp-sev.h:125 struct member 'api_major' not described in 'sev_user_data_status'
> Warning: include/uapi/linux/psp-sev.h:125 struct member 'api_minor' not described in 'sev_user_data_status'
> Warning: include/uapi/linux/psp-sev.h:125 Excess struct member 'major' description in 'sev_user_data_status' (did you mean one of: 'api_major')
> Warning: include/uapi/linux/psp-sev.h:125 Excess struct member 'minor' description in 'sev_user_data_status' (did you mean one of: 'api_minor')
> Warning: include/uapi/linux/psp-sev.h:153 expecting prototype for struct sev_user_data_cert_import. Prototype was for struct sev_user_data_pek_cert_import instead
> Warning: include/uapi/linux/psp-sev.h:168 struct member 'pdh_cert_address' not described in 'sev_user_data_pdh_cert_export'
> Warning: include/uapi/linux/psp-sev.h:168 struct member 'pdh_cert_len' not described in 'sev_user_data_pdh_cert_export'
> Warning: include/uapi/linux/psp-sev.h:168 Excess struct member 'pdh_address' description in 'sev_user_data_pdh_cert_export' (did you mean one of: 'pdh_cert_address', 'cert_chain_address')
> Warning: include/uapi/linux/psp-sev.h:168 Excess struct member 'pdh_len' description in 'sev_user_data_pdh_cert_export' (did you mean one of: 'pdh_cert_len')
> Warning: include/uapi/linux/psp-sev.h:263 expecting prototype for struct sev_data_snp_vlek_load. Prototype was for struct sev_user_data_snp_vlek_load instead
> Warning: include/uapi/linux/psp-sev.h:273 expecting prototype for struct sev_user_data_snp_vlek_wrapped_vlek_hashstick. Prototype was for struct sev_user_data_snp_wrapped_vlek_hashstick instead
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> v2: don't use private: for reserved fields; just describe them in
>     kernel-doc (Tom)
> 
> Cc: Ashish Kalra <ashish.kalra@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> 
>  include/linux/psp-sev.h      |   86 +++++++++++++++++++++++----------
>  include/uapi/linux/psp-sev.h |   26 ++++-----
>  2 files changed, 73 insertions(+), 39 deletions(-)
> 
> --- linux-next-20260918.orig/include/linux/psp-sev.h
> +++ linux-next-20260918/include/linux/psp-sev.h
> @@ -49,7 +49,7 @@
>  
>  #define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
>  
> -/**
> +/*
>   * SEV platform state
>   */
>  enum sev_state {
> @@ -60,7 +60,7 @@ enum sev_state {
>  	SEV_STATE_MAX
>  };
>  
> -/**
> +/*
>   * SEV platform and guest management commands
>   */
>  enum sev_cmd {
> @@ -157,6 +157,7 @@ enum sev_cmd {
>   * struct sev_data_init - INIT command parameters
>   *
>   * @flags: processing flags
> + * @reserved: reserved
>   * @tmr_address: system physical address used for SEV-ES
>   * @tmr_len: len of tmr_address
>   */
> @@ -174,6 +175,7 @@ struct sev_data_init {
>   * @flags: processing flags
>   * @tmr_address: system physical address used for SEV-ES
>   * @tmr_len: len of tmr_address
> + * @reserved: reserved
>   * @nv_address: system physical address used for PSP NV storage
>   * @nv_len: len of nv_address
>   */
> @@ -201,12 +203,13 @@ struct sev_data_pek_csr {
>  } __packed;
>  
>  /**
> - * struct sev_data_cert_import - PEK_CERT_IMPORT command parameters
> + * struct sev_data_pek_cert_import - PEK_CERT_IMPORT command parameters
>   *
> - * @pek_address: PEK certificate chain
> - * @pek_len: len of PEK certificate
> - * @oca_address: OCA certificate chain
> - * @oca_len: len of OCA certificate
> + * @pek_cert_address: PEK certificate chain
> + * @pek_cert_len: len of PEK certificate
> + * @reserved: reserved
> + * @oca_cert_address: OCA certificate chain
> + * @oca_cert_len: len of OCA certificate
>   */
>  struct sev_data_pek_cert_import {
>  	u64 pek_cert_address;			/* In */
> @@ -240,8 +243,9 @@ struct sev_data_get_id {
>  /**
>   * struct sev_data_pdh_cert_export - PDH_CERT_EXPORT command parameters
>   *
> - * @pdh_address: PDH certificate address
> - * @pdh_len: len of PDH certificate
> + * @pdh_cert_address: PDH certificate address
> + * @pdh_cert_len: len of PDH certificate
> + * @reserved: reserved
>   * @cert_chain_address: PDH certificate chain
>   * @cert_chain_len: len of PDH certificate chain
>   */
> @@ -304,6 +308,7 @@ struct sev_data_guest_status {
>   * @policy: guest launch policy
>   * @dh_cert_address: physical address of DH certificate blob
>   * @dh_cert_len: len of DH certificate blob
> + * @reserved: reserved
>   * @session_address: physical address of session parameters
>   * @session_len: len of session parameters
>   */
> @@ -321,6 +326,7 @@ struct sev_data_launch_start {
>   * struct sev_data_launch_update_data - LAUNCH_UPDATE_DATA command parameter
>   *
>   * @handle: handle of the VM to update
> + * @reserved: reserved
>   * @len: len of memory to be encrypted
>   * @address: physical address of memory region to encrypt
>   */
> @@ -335,6 +341,7 @@ struct sev_data_launch_update_data {
>   * struct sev_data_launch_update_vmsa - LAUNCH_UPDATE_VMSA command
>   *
>   * @handle: handle of the VM
> + * @reserved: reserved
>   * @address: physical address of memory region to encrypt
>   * @len: len of memory region to encrypt
>   */
> @@ -349,6 +356,7 @@ struct sev_data_launch_update_vmsa {
>   * struct sev_data_launch_measure - LAUNCH_MEASURE command parameters
>   *
>   * @handle: handle of the VM to process
> + * @reserved: reserved
>   * @address: physical address containing the measurement blob
>   * @len: len of measurement blob
>   */
> @@ -363,10 +371,13 @@ struct sev_data_launch_measure {
>   * struct sev_data_launch_secret - LAUNCH_SECRET command parameters
>   *
>   * @handle: handle of the VM to process
> + * @reserved1: reserved
>   * @hdr_address: physical address containing the packet header
>   * @hdr_len: len of packet header
> + * @reserved2: reserved
>   * @guest_address: system physical address of guest memory region
>   * @guest_len: len of guest_paddr
> + * @reserved3: reserved
>   * @trans_address: physical address of transport memory buffer
>   * @trans_len: len of transport memory buffer
>   */
> @@ -399,10 +410,13 @@ struct sev_data_launch_finish {
>   * @policy: policy information for the VM
>   * @pdh_cert_address: physical address containing PDH certificate
>   * @pdh_cert_len: len of PDH certificate
> + * @reserved1: reserved
>   * @plat_certs_address: physical address containing platform certificate
>   * @plat_certs_len: len of platform certificate
> + * @reserved2: reserved
>   * @amd_certs_address: physical address containing AMD certificate
>   * @amd_certs_len: len of AMD certificate
> + * @reserved3: reserved
>   * @session_address: physical address containing Session data
>   * @session_len: len of session data
>   */
> @@ -423,13 +437,16 @@ struct sev_data_send_start {
>  } __packed;
>  
>  /**
> - * struct sev_data_send_update - SEND_UPDATE_DATA command
> + * struct sev_data_send_update_data - SEND_UPDATE_DATA command
>   *
>   * @handle: handle of the VM to process
> + * @reserved1: reserved
>   * @hdr_address: physical address containing packet header
>   * @hdr_len: len of packet header
> + * @reserved2: reserved
>   * @guest_address: physical address of guest memory region to send
>   * @guest_len: len of guest memory region to send
> + * @reserved3: reserved
>   * @trans_address: physical address of host memory region
>   * @trans_len: len of host memory region
>   */
> @@ -447,13 +464,15 @@ struct sev_data_send_update_data {
>  } __packed;
>  
>  /**
> - * struct sev_data_send_update - SEND_UPDATE_VMSA command
> + * struct sev_data_send_update_vmsa - SEND_UPDATE_VMSA command
>   *
>   * @handle: handle of the VM to process
>   * @hdr_address: physical address containing packet header
>   * @hdr_len: len of packet header
> + * @reserved2: reserved
>   * @guest_address: physical address of guest memory region to send
>   * @guest_len: len of guest memory region to send
> + * @reserved3: reserved
>   * @trans_address: physical address of host memory region
>   * @trans_len: len of host memory region
>   */
> @@ -491,8 +510,10 @@ struct sev_data_send_cancel {
>   * struct sev_data_receive_start - RECEIVE_START command parameters
>   *
>   * @handle: handle of the VM to perform receive operation
> + * @policy: policy information for the VM
>   * @pdh_cert_address: system physical address containing PDH certificate blob
>   * @pdh_cert_len: len of PDH certificate blob
> + * @reserved1: reserved
>   * @session_address: system physical address containing session blob
>   * @session_len: len of session blob
>   */
> @@ -510,10 +531,13 @@ struct sev_data_receive_start {
>   * struct sev_data_receive_update_data - RECEIVE_UPDATE_DATA command parameters
>   *
>   * @handle: handle of the VM to update
> + * @reserved1: reserved
>   * @hdr_address: physical address containing packet header blob
>   * @hdr_len: len of packet header
> + * @reserved2: reserved
>   * @guest_address: system physical address of guest memory region
>   * @guest_len: len of guest memory region
> + * @reserved3: reserved
>   * @trans_address: system physical address of transport buffer
>   * @trans_len: len of transport buffer
>   */
> @@ -534,10 +558,13 @@ struct sev_data_receive_update_data {
>   * struct sev_data_receive_update_vmsa - RECEIVE_UPDATE_VMSA command parameters
>   *
>   * @handle: handle of the VM to update
> + * @reserved1: reserved
>   * @hdr_address: physical address containing packet header blob
>   * @hdr_len: len of packet header
> + * @reserved2: reserved
>   * @guest_address: system physical address of guest memory region
>   * @guest_len: len of guest memory region
> + * @reserved3: reserved
>   * @trans_address: system physical address of transport buffer
>   * @trans_len: len of transport buffer
>   */
> @@ -567,6 +594,7 @@ struct sev_data_receive_finish {
>   * struct sev_data_dbg - DBG_ENCRYPT/DBG_DECRYPT command parameters
>   *
>   * @handle: handle of the VM to perform debug operation
> + * @reserved: reserved
>   * @src_addr: source address of data to operate on
>   * @dst_addr: destination address of data to operate on
>   * @len: len of data to operate on
> @@ -583,6 +611,7 @@ struct sev_data_dbg {
>   * struct sev_data_attestation_report - SEV_ATTESTATION_REPORT command parameters
>   *
>   * @handle: handle of the VM
> + * @reserved: reserved
>   * @mnonce: a random nonce that will be included in the report.
>   * @address: physical address where the report will be copied.
>   * @len: length of the physical buffer.
> @@ -781,9 +810,14 @@ struct sev_data_snp_guest_request {
>   *
>   * @init_rmp: indicate that the RMP should be initialized.
>   * @list_paddr_en: indicate that list_paddr is valid
> + * @rapl_dis: whether RAPL is disabled
> + * @ciphertext_hiding_en: whether ciphertext hiding is enabled
> + * @tio_en: Indicates that SNP_INIT_EX initialized the RMP for SEV-TIO
>   * @rsvd: reserved
>   * @rsvd1: reserved
>   * @list_paddr: system physical address of range list
> + * @max_snp_asid: When non-zero, enable ciphertext hiding and specify the
> + *  maximum ASID that can be used for an SEV-SNP guest.
>   * @rsvd2: reserved
>   */
>  struct sev_data_snp_init_ex {
> @@ -841,7 +875,7 @@ struct sev_data_snp_shutdown_ex {
>  } __packed;
>  
>  /**
> - * struct sev_platform_init_args
> + * struct sev_platform_init_args - parameters for sev_platform_init()
>   *
>   * @error: SEV firmware error code
>   * @probe: True if this is being called as part of CCP module probe, which
> @@ -879,12 +913,12 @@ struct sev_data_snp_feature_info {
>  } __packed;
>  
>  /**
> - * struct feature_info - FEATURE_INFO structure
> + * struct snp_feature_info - FEATURE_INFO structure
>   *
>   * @eax: output of SNP_FEATURE_INFO command
>   * @ebx: output of SNP_FEATURE_INFO command
>   * @ecx: output of SNP_FEATURE_INFO command
> - * #edx: output of SNP_FEATURE_INFO command
> + * @edx: output of SNP_FEATURE_INFO command
>   */
>  struct snp_feature_info {
>  	u32 eax;
> @@ -954,7 +988,7 @@ struct sev_data_snp_verify_mitigation_ds
>  } __packed;
>  
>  /**
> - * struct sev_snp_tcb_version_genoa_milan
> + * struct sev_snp_tcb_version_genoa_milan - v1 SVN payload
>   *
>   * @boot_loader: SVN of PSP bootloader
>   * @tee: SVN of PSP operating system
> @@ -971,7 +1005,7 @@ struct sev_snp_tcb_version_genoa_milan {
>  };
>  
>  /**
> - * struct sev_snp_tcb_version_turin
> + * struct sev_snp_tcb_version_turin - v2 SVN payload
>   *
>   * @fmc: SVN of FMC firmware
>   * @boot_loader: SVN of PSP bootloader
> @@ -1037,9 +1071,9 @@ int sev_platform_status(struct sev_user_
>   * behalf of userspace. The caller must pass a valid SEV file descriptor
>   * so that we know that it has access to SEV device.
>   *
> - * @filep - SEV device file pointer
> - * @cmd - command to issue
> - * @data - command buffer
> + * @filep: SEV device file pointer
> + * @id: command to issue
> + * @data: command buffer
>   * @error: SEV command return code
>   *
>   * Returns:
> @@ -1056,8 +1090,8 @@ int sev_issue_cmd_external_user(struct f
>  /**
>   * sev_guest_deactivate - perform SEV DEACTIVATE command
>   *
> - * @deactivate: sev_data_deactivate structure to be processed
> - * @sev_ret: sev command return code
> + * @data: sev_data_deactivate structure to be processed
> + * @error: sev command return code
>   *
>   * Returns:
>   * 0 if the sev successfully processed the command
> @@ -1071,8 +1105,8 @@ int sev_guest_deactivate(struct sev_data
>  /**
>   * sev_guest_activate - perform SEV ACTIVATE command
>   *
> - * @activate: sev_data_activate structure to be processed
> - * @sev_ret: sev command return code
> + * @data: sev_data_activate structure to be processed
> + * @error: sev command return code
>   *
>   * Returns:
>   * 0 if the sev successfully processed the command
> @@ -1086,7 +1120,7 @@ int sev_guest_activate(struct sev_data_a
>  /**
>   * sev_guest_df_flush - perform SEV DF_FLUSH command
>   *
> - * @sev_ret: sev command return code
> + * @error: sev command return code
>   *
>   * Returns:
>   * 0 if the sev successfully processed the command
> @@ -1100,8 +1134,8 @@ int sev_guest_df_flush(int *error);
>  /**
>   * sev_guest_decommission - perform SEV DECOMMISSION command
>   *
> - * @decommission: sev_data_decommission structure to be processed
> - * @sev_ret: sev command return code
> + * @data: sev_data_decommission structure to be processed
> + * @error: sev command return code
>   *
>   * Returns:
>   * 0 if the sev successfully processed the command
> --- linux-next-20260918.orig/include/uapi/linux/psp-sev.h
> +++ linux-next-20260918/include/uapi/linux/psp-sev.h
> @@ -15,7 +15,7 @@
>  
>  #include <linux/types.h>
>  
> -/**
> +/*
>   * SEV platform commands
>   */
>  enum {
> @@ -36,7 +36,7 @@ enum {
>  	SEV_MAX,
>  };
>  
> -/**
> +/*
>   * SEV Firmware status code
>   */
>  typedef enum {
> @@ -109,8 +109,8 @@ typedef enum {
>  /**
>   * struct sev_user_data_status - PLATFORM_STATUS command parameters
>   *
> - * @major: major API version
> - * @minor: minor API version
> + * @api_major: major API version
> + * @api_minor: minor API version
>   * @state: platform state
>   * @flags: platform config flags
>   * @build: firmware build id for API version
> @@ -139,12 +139,12 @@ struct sev_user_data_pek_csr {
>  } __packed;
>  
>  /**
> - * struct sev_user_data_cert_import - PEK_CERT_IMPORT command parameters
> + * struct sev_user_data_pek_cert_import - PEK_CERT_IMPORT command parameters
>   *
> - * @pek_address: PEK certificate chain
> - * @pek_len: length of PEK certificate
> - * @oca_address: OCA certificate chain
> - * @oca_len: length of OCA certificate
> + * @pek_cert_address: PEK certificate chain
> + * @pek_cert_len: length of PEK certificate
> + * @oca_cert_address: OCA certificate chain
> + * @oca_cert_len: length of OCA certificate
>   */
>  struct sev_user_data_pek_cert_import {
>  	__u64 pek_cert_address;			/* In */
> @@ -156,8 +156,8 @@ struct sev_user_data_pek_cert_import {
>  /**
>   * struct sev_user_data_pdh_cert_export - PDH_CERT_EXPORT command parameters
>   *
> - * @pdh_address: PDH certificate address
> - * @pdh_len: length of PDH certificate
> + * @pdh_cert_address: PDH certificate address
> + * @pdh_cert_len: length of PDH certificate
>   * @cert_chain_address: PDH certificate chain
>   * @cert_chain_len: length of PDH certificate chain
>   */
> @@ -248,7 +248,7 @@ struct sev_user_data_snp_config {
>  } __packed;
>  
>  /**
> - * struct sev_data_snp_vlek_load - SNP_VLEK_LOAD structure
> + * struct sev_user_data_snp_vlek_load - SNP_VLEK_LOAD structure
>   *
>   * @len: length of the command buffer read by the PSP
>   * @vlek_wrapped_version: version of wrapped VLEK hashstick (Must be 0h)
> @@ -264,7 +264,7 @@ struct sev_user_data_snp_vlek_load {
>  } __packed;
>  
>  /**
> - * struct sev_user_data_snp_vlek_wrapped_vlek_hashstick - Wrapped VLEK data
> + * struct sev_user_data_snp_wrapped_vlek_hashstick - Wrapped VLEK data
>   *
>   * @data: Opaque data provided by AMD KDS (as described in SEV-SNP Firmware ABI
>   *        1.54, SNP_VLEK_LOAD)

