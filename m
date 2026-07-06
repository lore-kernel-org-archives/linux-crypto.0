Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11020118.outbound.protection.outlook.com [52.101.85.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5422A3F8235;
	Mon,  6 Jul 2026 12:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783339362; cv=fail; b=hQYPZpcut01Bp/RSUJb8Ew1ubZSVurAS/NyHJIri7DjPMxL3YjQ/uzhoE+1rSAuRRdXVSolJpnsYmbEJyGogeWS2hwN3MPxFBz3wAgyJLU+9xXMkRU/XcUI9AJsuZpjnjNaXt8bb8Xe4lWzIoHwx4DpTNPgB/mLrYJKAgDjVQvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783339362; c=relaxed/simple;
	bh=ZFDuNc+mme14yPmX3EyulSBmhTQO7bUaeAlUnvkWtVE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dbSwVvFWqtuW5mfKbdmSlG8aGsfxV5VZsNEvBSLwZOpanWgvwjXOQQOiWhj/M+/UyUWmweZpnaIes9QqhD/kQ+bldD4n9vtta3ekCHf09sxAc5X+EZ5al97uU8GY1bZv5q/gdNb/zA5npaaKMQeT1SYQux10If1/AR0cIsP8KOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com; spf=pass smtp.mailfrom=fortanix.com; dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b=RNYKQ2SV; arc=fail smtp.client-ip=52.101.85.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fortanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b="RNYKQ2SV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nVioy+2cFamgXEdrGoggcDm/6RQ8nnOSf9iIpS9wivs7hQnpkMgur33jehQZqqVq6khMFxsU06L69NWHl1Y8wWp+Huco0W9roSv7LAAmMPMgwGrrJlrJMwm/ivCrvQUihRbDC45lSEbir3cx81+4mBvSyWXRWTCUEwzmQLvnO7KrKWBvuizLuDEl1pnOTPAhCoSJIVBSBDBdZ9d/2bB1w70j4fws/5xhDfX8VrNNVAm6K3uZbtL4ufrTcncIObZLTlvyghjhZVaJeSy/hwWlowoeXYJ7WK8UxnOgs20950HABwRZw5XYWpLznNlHQca6rhRYJbzj9G8oSOQ4ubvJJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HsCYc4qfHs/lrGwGMMP6pe8TeYYB4kgd/IWSwWmT+WE=;
 b=G0gXJlG2nnMLaoscjBeJAVK0TX9RgzMYZKTTqRAkv/CbiDHL5vP/xQcseRdz04iYyfhmkpFsErrUlLcUbzigUs58ynfRHZg2/PDA/YvMFDMm7qbhLhsVyqsMKdE+9wiivh+Ezhb4GO1dvZM72lhrS1CiHhkOGWijdqgK2qLqvGxeID9IU+RLRN74IKxXw/S4FihMdoRJJsf9H+H5KSYlttw7A9JeuaySsSZDJvjT1WyEBCL/TmFLSbh2TAUYYA6syUkQNJMfZb/7dCGIeuXwwIriHcNUv8GWJ8JiDuofLU20TPbpK1eq+fCOOEGX5hndBJdtAEyR0z9av8+ZYVCpqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fortanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsCYc4qfHs/lrGwGMMP6pe8TeYYB4kgd/IWSwWmT+WE=;
 b=RNYKQ2SVt0xHUY4i0Sal9QhZmCLWGLImZhQZ078xAoVBmFn4v4St3JR9jE6GI+/cbKmi95sHabIdNO4uffrHyerf2gmh4K5dtU3klr7lbq/CiRkAII5+ymjC9cdGuV0eHnRDcWCprXMo8sUuZpCVo+mVmBNe98ZoFGE1eDa3Gwo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fortanix.com;
Received: from PH0PR11MB5626.namprd11.prod.outlook.com (2603:10b6:510:ee::15)
 by DM4PR11MB7349.namprd11.prod.outlook.com (2603:10b6:8:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 12:02:30 +0000
Received: from PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::64f2:5af6:ec99:cb80]) by PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::64f2:5af6:ec99:cb80%5]) with mapi id 15.21.0181.012; Mon, 6 Jul 2026
 12:02:30 +0000
Message-ID: <a29f5a3b-0863-42c4-88d9-021bcabdc53f@fortanix.com>
Date: Mon, 6 Jul 2026 14:02:19 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 3/6] x86/sev: Disable CPU hotplug while SNP is active
To: "Kalra, Ashish" <ashish.kalra@amd.com>, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <205a5259f9fd353dc0ca6b00565c8175a96768c7.1782841284.git.ashish.kalra@amd.com>
 <80f3f279-d70e-44d7-a179-c52068115e46@fortanix.com>
 <5147d9bd-42f8-4ceb-aca4-6ac5fd5cb7f0@amd.com>
Content-Language: en-US
From: Jethro Beekman <jethro@fortanix.com>
In-Reply-To: <5147d9bd-42f8-4ceb-aca4-6ac5fd5cb7f0@amd.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms010602060608090004060502"
X-ClientProxiedBy: AS4P192CA0024.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::16) To PH0PR11MB5626.namprd11.prod.outlook.com
 (2603:10b6:510:ee::15)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5626:EE_|DM4PR11MB7349:EE_
X-MS-Office365-Filtering-Correlation-Id: 21aba62f-ff30-424d-9a01-08dedb567423
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|23010399003|18002099003|22082099003|4143699003|6133799003|56012099006|11063799006|921020;
X-Microsoft-Antispam-Message-Info:
	AeGOH73NhYLh+9Ag6SsZiGutMbN31t43OveeNmjQd6wUY5mDKXRxFUyKaYJGwtaYuI8+EYDnFbdL4lM9MPlRjI4B+jl9VbPYV4hk1/a2oksmD4jky3m0fCmLsIE2/WZfyVzlGMR++nn498GLD/rXWAvDg+wbjS3JPl6XNELJZL8MG9Ll4hRcFct9kpehf450LJ3wvlVno/2cRn1SPIDKYfqFqqMqV5F6zo9gifuzAyktu6zNPCgZFTfdrEMDRKaj4/aAfXFp0B/KgqJwJckVheFUcNSk5lpE0JCueBT200OwZiZY9mfKg4CvpnWCLmgCd8AilZkj3b4sFNCUe7Lyugi4yllGgbFZuOwNv/TeG0RdiEGAMVQahbZiFcnD8pAUVhfCuLnbBYIdTe8EuWyGU0vWdpQRgV2wIAH1htRwFZzEwnbYeNoPHknjTtZzCzYvARdEGOjJUPvn+N2gelam42MnfdJJjAPQkUB6VSZzHqAPY9kyBDMAOMviUKPdSBOCDADu4Zq8Fc+q39PrFzylac2ckxOWZj3W4XtN8+alM+avwyY7cU2kpkwS6CucHXtH7pMCL8V4UT4zqL/WeD0wBpbGvwjZKXN+EGBoDXPkcNjA39IZeUy4gFdjgbD3VBZW2UzmO12uVZX9EWIKzpkgjD5OsrX9adPsVFh+t4MJSNJ+aPsmk/nire8yd5rTgD3+dsH+/07oRPDp9RRtOzPHiw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5626.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(4143699003)(6133799003)(56012099006)(11063799006)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NmtPS2lRVHpyNUNBaXJuWGJGNWVGdjRjWWNlcnhrU2R1WTd4RFRTM3dDT0NO?=
 =?utf-8?B?aE9mSnhxdEl5b1BwcWFscXhHU24yaW5YL1pXMjVrcDdTV1o1TGlLZFJKRWJF?=
 =?utf-8?B?Sjl4NCtET1Z6UGNqRUpFNmxwVlJwa0k4U1cvSjFtcTE0aURtZkxxRDVXVkxJ?=
 =?utf-8?B?VDJQY2F0TEVnS0dIS3g4WUZGZG9nTlkrUEd1eWd4bGhyTzczVDg2eWVqd3B3?=
 =?utf-8?B?VnVNVm94ZWd6L2VrWnJsOGs0QkdBMGRSN25VamJPOFNuNzVoc3NMTHZOb05I?=
 =?utf-8?B?dHpCcStjb0ZmWFNkcjJ6WHk1N3ExK1c2cFBZZlNSUUNhZ1R5VzV2OWhWSlJh?=
 =?utf-8?B?V0QxWVZkOTFEWFB5UjNpbERqZ0xlQmhzS3JhN1YzSmxkVktFVDNoeDYyT2hs?=
 =?utf-8?B?aVlvVWk1RDgvMDJIQmY5VTIvZ3lFM0RrckZ5ZzBDS0Q0Rlg4TTdUdUlFNldk?=
 =?utf-8?B?amhyVFVmK0ZPcVA4UW5xSGhXRUFSeUlDdldSOWlRamhLczlZQzAzZ0g1eUc1?=
 =?utf-8?B?Mm9UQWhCOU1RK29uc1BwNk1WTFhoRDhEaU9RWFlmdGgxM2NmWEZGRkJwc0xD?=
 =?utf-8?B?SUVsci9UK1FIbTY4YWdmbDFQczllNm4wOHNkb2w2dVlQL1daVHd6bmR3SXlU?=
 =?utf-8?B?R1E5NEcrVXFtdXp0N0s5Z1kyenRISHVnTU1rZVZJbVNKRXVjZUpwNnJaRVFm?=
 =?utf-8?B?VjR4ZnJ0UkVxbjUrM3lPZ2JLRW9OY1JBa1Q5cCsrRjRjZVR0SDBVQy9JMjBP?=
 =?utf-8?B?YVBqZWJ6QnpyY1JMaHptMXl3YjV5U3I4endnSFUzcnRRWGNtUnA2R215SzdY?=
 =?utf-8?B?dEc1dTVUWXJsbFN6UDEvYm9tOVhPN0NCV1ZFcU56UEdkVldUZVkyTGRzK0Zr?=
 =?utf-8?B?aFN3NVFmV010VDRVU0hwQWdnUDNkR1RHOTU2U01MbEZYN0RIUlR0YVJCa1Np?=
 =?utf-8?B?N0RHMGlIN09kYWx4Q24wVjdtRXNzTHVtcDloYldpTHRlc0poUmltTExYbmph?=
 =?utf-8?B?YkZrY2JRSUtSUExtUUlLU2ZGaytKOVBxUFdjTEhpalRIcmVSdXJDMlhmbmxP?=
 =?utf-8?B?b0tsQmhnb1A1ZHFNVm42czdpN3grYkc3TjJvZEZTS256YStPdnU2YWVwSjdS?=
 =?utf-8?B?dDVHYTBFOWdkUkJJWmZuNGRBYldDc3JBc0hBS3VFSVNsaVJTT3JJSFVyM2FF?=
 =?utf-8?B?dytNeVFKWm1ZSTROeVVEYnFVUjNNeHZUTlVlTXNWTkVPZC9Rb29YL3dVWEYw?=
 =?utf-8?B?UDM1QzNVMDQ0L3BWZGpDZDdJSHhWT2QvdmxMMzZGVlFxcHpZd3AwVEhJWEsw?=
 =?utf-8?B?RVJ0S0ZQenJ2MFFUMWk0MXhxOUJBeTcrMzhZUDZtNlAwbnFIak9weE9VQnFq?=
 =?utf-8?B?N0FZbFRFYm03N3lLb2dBRGpnUXlJSTNUdkVtem5iWDZCWmZxUHdkZldjRWx0?=
 =?utf-8?B?c0phZjlwSWs3SEkrelgyY0wzVEVwZTZSQjhRSXVQL3VzbmwvVmozQ0Yxa0hR?=
 =?utf-8?B?NmdPZGJ2aFhLVEdCZDZKbmJvM2l2SEsvcmM1aDd1NXNDajJtSGh1NytacEZl?=
 =?utf-8?B?eDdTaldoSlQycHR1aWtoKzZtUXBRQWF5eHdDb0l2NUJUTFRMZEtXTTZSTksw?=
 =?utf-8?B?WjZseGpkSlVXQ1VGdHRBZXM0dWNkZThaTERRTjF4NXlYR200QmFNQzduVnlB?=
 =?utf-8?B?ejhzeE81TVZBNHhGdTdOZDhSZDJpMjM3KytEckFYOG4xT3ZUaVJPWWdqeFhs?=
 =?utf-8?B?SWVacCt4RnBFazNvd0c5ZFNxQjUzZDQ0dk1qaVhCZUEzUmlQd2NhMUxjaGY1?=
 =?utf-8?B?QVZQa2x1TkN4R0ZmeHl4ckVLTnNpcHB4T2dYNkszaUgxV0dTSy9IbFUxVWFk?=
 =?utf-8?B?cXBOMlRtekNvUGVXT1crVjlUOVp0V0I3YUxqMjI4ZzVqakJHNUVKMXdEMllX?=
 =?utf-8?B?QlJhMkcwZUJMN0ZKdEVjYm9tRkV2UlkwOVVKeGVrWUl4UU4yRFdBMzFUVHZl?=
 =?utf-8?B?ZlFtK2FlVklVZkR1RHhUaG1IMTd0TkdKY0E4VHNQbldCVkJneUJhTmU2blJN?=
 =?utf-8?B?Vm4xYkpLY0V3VUtRWDRaMjdpaU4waklFamJKYVdQb2tVZjhsdnJOK3VaNloz?=
 =?utf-8?B?NnpuZXR0aVpDOUpERnlaUXg1ZFNSOHBDSlQzTjZlOFoxYWFoam1LY0hTaC8v?=
 =?utf-8?B?UVZndGZRc1ZGT0drVzBCa2Z6YUhEL21LOVY4ZmF2anU5N0V5SzRWeGw3Z0tL?=
 =?utf-8?B?QW80ZmQzOVh2ZXlpTnVIbjJHQThnNEZjRzgwbWpHcWRCLzcxS0ZBZGIwK05o?=
 =?utf-8?B?eWJNa0JGdSs1T0MrRXdQT2xxZS81RjlxV0V3enRmQjZYSWk4UmFtUT09?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21aba62f-ff30-424d-9a01-08dedb567423
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5626.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 12:02:30.0717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9lntPPfh0C5PaM/qJ8TMizYGISlNqkgbphfyLZGtyIGAm5KcRXlbmTVBfCUL8aJtX8yCwj5MhqbCbWISpYAiCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7349

--------------ms010602060608090004060502
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2026-07-01 23:25, Kalra, Ashish wrote:
>=20
> On 7/1/2026 4:40 AM, Jethro Beekman wrote:
>> Hi Ashish,
>>
>> I don't believe my concern has been addressed
>>
>> https://lore.kernel.org/lkml/0df3b665-3a9c-4c46-a7aa-14388e8e1577@fort=
anix.com/
>>
>> --
>=20
> The disable tracks SNP_INIT, not "SNP" in general: SNP_INIT requires Sn=
pEn to be set on all present CPUs, and a CPU brought online afterward wou=
ldn't have it, so the kernel that runs SNP_INIT must keep its CPU set sta=
ble. Today the only kernel that runs SNP_INIT is the bare-metal host, so =
a plain L1 guest keeps full CPU hotplug.
>=20
> Concretely, the path is gated by CC_ATTR_HOST_SEV_SNP, which bsp_determ=
ine_snp() sets only when X86_FEATURE_HYPERVISOR is clear and clears other=
wise=20
> (as Prateek pointed out). So a Linux L1 guest never has it set, never r=
eaches snp_prepare()/snp_rmptable_init(), and keeps CPU hotplug =E2=80=94=
=20
> including while running SEV/SEV-ES confidential L2 guests. Only SNP ini=
tialization disables hotplug; the other SEV variants don't. And KVM doesn=
't expose
> SNP to L1, so an L1 can't be an SNP host today in any case.
>  =20
> On the nested scenario you raised: if SNP-guest-as-L2 support is added,=
 an L1 acting as an SNP host would run a *virtualized* SNP_INIT. A faithf=
ul virtualization carries the same constraint as physical SNP_INIT =E2=80=
=94 all present (v)CPUs must be SnpEn =E2=80=94 so that L1 would have the=
 same (v)CPU-hotplug-disable requirement, just over its virtual CPUs, and=
 this same code would apply at that level. So the disable isn't too broad=
; it correctly tracks SNP_INIT. It simply doesn't apply to a plain L1 gue=
st today, because such a guest isn't running SNP_INIT.

Thanks, Ashish, Prateek, for the clarification.

--
Jethro Beekman | CTO | Fortanix

--------------ms010602060608090004060502
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
DVEwggZaMIIEQqADAgECAhA1+mGqtme9KUZNwz/3CNvGMA0GCSqGSIb3DQEBCwUAMH4xCzAJ
BgNVBAYTAlVTMQ4wDAYDVQQIDAVUZXhhczEQMA4GA1UEBwwHSG91c3RvbjERMA8GA1UECgwI
U1NMIENvcnAxOjA4BgNVBAMMMVNTTC5jb20gQ2xpZW50IENlcnRpZmljYXRlIEludGVybWVk
aWF0ZSBDQSBSU0EgUjIwHhcNMjUxMDA2MTEwNzUyWhcNMjYxMDA2MTEwNzUyWjAkMSIwIAYJ
KoZIhvcNAQkBFhNqZXRocm9AZm9ydGFuaXguY29tMIIBojANBgkqhkiG9w0BAQEFAAOCAY8A
MIIBigKCAYEAsHHTT4CjC0VzCO7TK6hGJjaIpQjXsP7B9AznOt+ZyyeluwC145jlL+r6kYYG
CvKHgK1sx4wIFTHiyiR9qCjigv6SG7guGTGSa2aHC0i8UV0p5z7uv41mfXpa9jbx3G6d7xcj
HwrtcFC4XzBlgIDLgWliUR76bEx17fgdYSPQPX+IFGDHq1tWiknb9xUI47t2hTRtwJoK2qqr
ekldESnznLRnDPTfq/MInS8oDjgpKyOOCwEbDjEUcvuLjQRkAj0AhDJi6LcKqOvmEexFzFlt
M+NFlg6XPA2Xv/cNqYsNhznMEHI8iPU5VOLyEGQgdV/BduTVWlW2nVSJZMTpA66AtvqGVSTt
8ogDhez9yUXxPBQnc4yr1qggENthQDDIC/Sz9l0dU9GIFy89GJTPInZNNx/6t6ORa6XbTFHD
X/IFLWvLuPLRPwS8O890P8G4KkuMRUS3FRP1R3l1igUbYSJwfSvtC8cgbUlHGiYvIb3tudch
YYBBj9D420+zctemH/HPAgMBAAGjggGsMIIBqDAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaA
FGaPpry3kyyd+bpJ5U/c6pBQEWqdMFcGCCsGAQUFBwEBBEswSTBHBggrBgEFBQcwAoY7aHR0
cDovL2NlcnQuc3NsLmNvbS9TU0xjb20tU3ViQ0EtY2xpZW50Q2VydC1SU0EtNDA5Ni1SMi5j
ZXIwHgYDVR0RBBcwFYETamV0aHJvQGZvcnRhbml4LmNvbTBiBgNVHSAEWzBZMAkGB2eBDAEF
AQIwPAYMKwYBBAGCqTABAwIBMCwwKgYIKwYBBQUHAgEWHmh0dHBzOi8vd3d3LnNzbC5jb20v
cmVwb3NpdG9yeTAOBgwrBgEEAYKpMAEDBQcwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUF
BwMEMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9jcmxzLnNzbC5jb20vU1NMY29tLVN1YkNB
LWNsaWVudENlcnQtUlNBLTQwOTYtUjIuY3JsMB0GA1UdDgQWBBSe7dyiO5/YCMtvaDsV/9eu
tMpB+DAOBgNVHQ8BAf8EBAMCBaAwDQYJKoZIhvcNAQELBQADggIBAORtEzFynaprV6QYTevg
bsSZltHZXq4EAbweXFLmATzA7HO0UbPn0EkBV+hFA9tN1h3YI3gAtIK6ztRU6JzSyQ0T3w3h
rRYEuo9yqMYlz3MiybGASg5P/paRzA+fUfYihZNEauwIEpNv2F0uAGow1G1lEOt0kljtCIjl
cBK9zxM3uUqjPwH+a5xcng7Ir58THtGqE3EWjc79by36xu06AMExkNGOxyN3EJdpN0TGJ7pB
bsRgm1PfiHSFRTunhKbzVLL82eyEimbt7ETTkU4/1SwEPKlkRznv0H1knJRzpX/NItoF4IjO
Z2q3beenj2FUs2ButRX3jO1tKpMey2y9W0uF4rDz9ZOInHtHzg6qQ4houXP0EoO3FakDtK/O
Zpg/W+FvYob6mwtwyd4S8TEZHqEsLoQ4WPF2MWM3VSiiXEIr66hxrkjkWv/wucj/pjo09zZr
aus5lvBNdIhEQhS5lmYICr4Gr6Dd55/zAL7pgSOhbyRO0sp+8z9T1OUcukHd2utlbMDkI8oU
G6uZpvxKY7ObZHm5EpkKkkZjSeZIhGy16IWT0RFgcz1D+tSdeX5jtS+xFQI8d5n/xn2st2eT
bgjYlxfe8DI1ITlzP6aKccLRucSvJloiT85y6Hzs1T6nGcNQ3Hl9K9vj6GCfNjdCKNLMIYJR
T1HVLSxFOrEyc3DCMIIG7zCCBNegAwIBAgIQB5/ciUBIivHZb9J0CmRVZjANBgkqhkiG9w0B
AQsFADB8MQswCQYDVQQGEwJVUzEOMAwGA1UECAwFVGV4YXMxEDAOBgNVBAcMB0hvdXN0b24x
GDAWBgNVBAoMD1NTTCBDb3Jwb3JhdGlvbjExMC8GA1UEAwwoU1NMLmNvbSBSb290IENlcnRp
ZmljYXRpb24gQXV0aG9yaXR5IFJTQTAeFw0xOTAzMjYxNzQxMDZaFw0zNDAzMjIxNzQxMDZa
MH4xCzAJBgNVBAYTAlVTMQ4wDAYDVQQIDAVUZXhhczEQMA4GA1UEBwwHSG91c3RvbjERMA8G
A1UECgwIU1NMIENvcnAxOjA4BgNVBAMMMVNTTC5jb20gQ2xpZW50IENlcnRpZmljYXRlIElu
dGVybWVkaWF0ZSBDQSBSU0EgUjIwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDm
Q+3UxwVE9dAx75DUrLZwgASWLLr/ID8bbGCfpcrSHIRsrR4ut5n49JGViu5DYE6addkpajbi
MA2Jaw1Ap4RncDjZ+0fzSWbqGKEE+vNPVLoKy7OVIrxf/9HzGUT6YaELSNrGTR0cYNcR+W5b
E3JTxTMQiLMAwBbMXH4qKXQUT+oyIXD11CIMUtM8ECoo2o7qdpw1zaZWwVvhXy9mkAaRgrkw
2NpddZUVbJKF/spsJa3lNVdSi3wcJpDDQAl6jxtBF/3ctkY1OjBQz32yRlArFymsPc+we9ff
HAgvfqbHVfXvgWG8urVith8/6MjmojHMCKqFoJueLbtTPoN8QhvVh49uoRYYAUUH0HOAYCOz
GBGrdJvMIYZqQsX90XlU7Qxp1En7vMkQswkQTvGmBPWrK/EwSAJc15BZm+i8QBxPqVKFORfL
ETLEC4ZrwomtW/oPxBP8zXPvQ0K1dQzAkw+JXxKv/KiwDryFFhU5xMMB3yKxO5NRYXlnqW9n
wfhdBTJScthzAtGO9KZQ2GPmq0NMVMuXe1XdCOmnPxOptKkMldBItkaYgrkTzqP1nzIAhVfU
4sNnHIxKPftwrZ9VMSc5Wkz88bOtAJyz3KQRY0qcAtR4LaeRkiZaEmprQA8EOpdJxtv03pBZ
taUnnTY6DsEwGQ0+P2mmB5IHB74SknyNswIDAQABo4IBaTCCAWUwEgYDVR0TAQH/BAgwBgEB
/wIBADAfBgNVHSMEGDAWgBTdBAkHovV6fVJTEpKV7jiAJQ2mWTCBgwYIKwYBBQUHAQEEdzB1
MFEGCCsGAQUFBzAChkVodHRwOi8vd3d3LnNzbC5jb20vcmVwb3NpdG9yeS9TU0xjb21Sb290
Q2VydGlmaWNhdGlvbkF1dGhvcml0eVJTQS5jcnQwIAYIKwYBBQUHMAGGFGh0dHA6Ly9vY3Nw
cy5zc2wuY29tMBEGA1UdIAQKMAgwBgYEVR0gADApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYB
BQUHAwQGCisGAQQBgjcKAwwwOwYDVR0fBDQwMjAwoC6gLIYqaHR0cDovL2NybHMuc3NsLmNv
bS9zc2wuY29tLXJzYS1Sb290Q0EuY3JsMB0GA1UdDgQWBBRmj6a8t5Msnfm6SeVP3OqQUBFq
nTAOBgNVHQ8BAf8EBAMCAYYwDQYJKoZIhvcNAQELBQADggIBAMJr11ncGIPKbaZxuuU2P1TG
yXF+gy+xH2TBNWNliJVL613nH1J7L2WcJQzqXYl77rKTzGeQexnKeYZ13MFwuE80vISif/gw
K569WLoyCvNVvGEZ2bZ+JL5K49mVhrv1gqO+MgMvc8iEENl1xoWRpJGD4EClk8t4u7NUCgBv
hYORiyzHCZcILHcEMvfEwmmFshMN6TqcAJdRjFT0Ru0hJcs5d7EFdM9dCa5ckXWrKK49cSNq
4qOaxqpG99EfDw6U2c70YcJ1/IhC1wL6z8qlGvhYQ0vJvqGJqW/DdeuWcMmrB+qZL9WbORQ1
nvlNggB6smEk0pXXYBr8HYjxT67XwtBBmkBXFpa7G6y4P0BO3kxWGBfvRBJHfyaiwREgVWa3
6V/WjXtPmV8VHcv04Rqgk64E4OlSUxgi9k9VC6kivTXJN+Gg2uJJBQdf+ptVhJqkkrtB0gAB
F+kQP0xsagKkrS3NVrVKo6peWMx0h7l52bGqT8ucu4Qe200KQi2xp/r8jpP60EE9U4M8D1gr
H3Kh9OxVOL4wykdoC/yGJNLKIl0BfsCVWB/GeSq5hxe/84K51OEJqpjDnOMrkRevfVzqGBFF
Aeg7Kg7uSysVR05wR+ltp3ytaIbjGJtKad8raIbM1qiNFErG7YB7v4baI3BP1s/rTDtPLoto
tahwHP7IqOHOMYIFVDCCBVACAQEwgZIwfjELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVRleGFz
MRAwDgYDVQQHDAdIb3VzdG9uMREwDwYDVQQKDAhTU0wgQ29ycDE6MDgGA1UEAwwxU1NMLmNv
bSBDbGllbnQgQ2VydGlmaWNhdGUgSW50ZXJtZWRpYXRlIENBIFJTQSBSMgIQNfphqrZnvSlG
TcM/9wjbxjANBglghkgBZQMEAgEFAKCCAxIwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
BgkqhkiG9w0BCQUxDxcNMjYwNzA2MTIwMjE5WjAvBgkqhkiG9w0BCQQxIgQgJEpkd60FR4hs
1P6EWSVE0+awTHFZ1N1IQKBs8Y1d9icwgaMGCSsGAQQBgjcQBDGBlTCBkjB+MQswCQYDVQQG
EwJVUzEOMAwGA1UECAwFVGV4YXMxEDAOBgNVBAcMB0hvdXN0b24xETAPBgNVBAoMCFNTTCBD
b3JwMTowOAYDVQQDDDFTU0wuY29tIENsaWVudCBDZXJ0aWZpY2F0ZSBJbnRlcm1lZGlhdGUg
Q0EgUlNBIFIyAhA1+mGqtme9KUZNwz/3CNvGMIGlBgsqhkiG9w0BCRACCzGBlaCBkjB+MQsw
CQYDVQQGEwJVUzEOMAwGA1UECAwFVGV4YXMxEDAOBgNVBAcMB0hvdXN0b24xETAPBgNVBAoM
CFNTTCBDb3JwMTowOAYDVQQDDDFTU0wuY29tIENsaWVudCBDZXJ0aWZpY2F0ZSBJbnRlcm1l
ZGlhdGUgQ0EgUlNBIFIyAhA1+mGqtme9KUZNwz/3CNvGMIIBVwYJKoZIhvcNAQkPMYIBSDCC
AUQwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzANBggqhkiG9w0DAgIB
BTANBggqhkiG9w0DAgIBBTAHBgUrDgMCBzANBggqhkiG9w0DAgIBBTAHBgUrDgMCGjALBglg
hkgBZQMEAgEwCwYJYIZIAWUDBAICMAsGCWCGSAFlAwQCAzALBglghkgBZQMEAgQwCwYJYIZI
AWUDBAIHMAsGCWCGSAFlAwQCCDALBglghkgBZQMEAgkwCwYJYIZIAWUDBAIKMAsGCSqGSIb3
DQEBATALBgkrgQUQhkg/AAIwCAYGK4EEAQsAMAgGBiuBBAELATAIBgYrgQQBCwIwCAYGK4EE
AQsDMAsGCSuBBRCGSD8AAzAIBgYrgQQBDgAwCAYGK4EEAQ4BMAgGBiuBBAEOAjAIBgYrgQQB
DgMwDQYJKoZIhvcNAQEBBQAEggGAn05DWLzPBWi9KV2wAuZMOUuewTa0l27UxK5dvWYf2vdM
94eF194tCSxbow44NYwr/eAa/jNw6SDgJe0ITY1fZpMd3tmdkezTCVY9nsqGd6YKM9TxfRtE
+cJoEAr2m1Yehvi9jGsVMTMhBLQnfIh3DZXsqFHCLLyZ01oC2rn3lhXkLha0fAFnGl6VQOHp
G5oqwNElXJkx/ILDsmxJk167B6/yQf9XaQU+vQnMEaT98wlEXdUNZhzi2cHlPT/AXM8RK6KA
xZdzENqCYcpQAzOPexznHBvR9mpNh4JLfOD0DwswFeUNsbRp3936WVFq5pqOQeSIFfcUsK02
AYPsjvTavfvMb7iYGXwCn5vKoWSVQ9+W6ehQFMFCw9MszM01Pr5a0WldrEVNjyKcrUfn30Gd
sEOiVK0LK3xP7K+NijoUxtjTQDVCJl+z0Lc22UWaNElhmX94uLxGhIZtJszWV3y8a3mdhJTR
3qFovIv+u5rTFowN45eDpuR0+1LBmlBsYe/cAAAAAAAA

--------------ms010602060608090004060502--
