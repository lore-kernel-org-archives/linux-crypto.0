Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021108.outbound.protection.outlook.com [40.93.194.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E6D3CF690;
	Wed,  1 Jul 2026 09:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782898850; cv=fail; b=FgOYjcwr8lmE+fXHMpKNs+B9UnIdQ5rT4imkIfuUGc3q+4c9ZFyWq+UBpbZ8kWhmP0S75sNCzJmIECmaCQwuqOvqALq7Tag5czuO0WAfCYFPGfsdeC3fDSCIX4MeSt+gzF/vgylLC5wczMJHIzxDDZl3M6deadCJuVmazEhrrzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782898850; c=relaxed/simple;
	bh=0iKv+VpA/sk7MJdZ9p/i8CTpExLmYagx5q8GEl6QcZ4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dpv+SLY7xQNIo9RUAUaYIS/nHqYwQhFa0g2uvplPucLfjRGWdXgg2ohNxhFLNeKvTZJKn8dxgFlRPnD5+Qa8vPRIWuydMQOJN6HSHe1zaACijvKXPkQdt8F4XdNwoW4CwzbKn+M3ENA002hA+najOwtQ2kP460VSo5wqWEbj2Tk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com; spf=pass smtp.mailfrom=fortanix.com; dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b=MheQMyAA; arc=fail smtp.client-ip=40.93.194.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fortanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b="MheQMyAA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DABlj6tSrVeP9O09MYbslPjyQEYi8dM9IzTAy7MJNmpZDWaWoWGjpzCd4VergHyIIeRwIkUAL8AdI5Wcol2Fnqcp0gZGpv0Zw5xHbMvKgGaYz7shsERG63iwjzXVJSgnrI1n9ptPdMgoDkmrQCR+jL+7ypxCwmKr+DGbewiRwBkjZ1AJYE77zVpVTk5b+bGhMfUEXNiwRHHHmiRL/Gu7i16yB8cxswk5wnoHECOWGsYDdabZGGpUIG6x55H+ir09/2P49lJXsbUTPBGS5ckWTgeS6xiHm9rTsGdgWxsHauCBd/xYwA509G3G9h+E6xp0yrZliM8n1/x8rS0KRcGhKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=odagmxp/NX1cnFM+GqvoGA1oVVi1H8/dDZkzkCkiUSg=;
 b=iXR51tY6S4xlBOxtRam0pCQQelKESLHXs8A56+k62dlaiU3FrHNQde5Nm01MBJazoOufx5/9+lZ4n9klTToV1bHy8uZFud+i8DTda1OrQWpIQzE/TYrQPab+sdWmAq5DWnEqM9hiBj73juTasnK2K6vcoESy3pp2VmxqP8FbuBWrbARERs1PkwgW4eMQ/bfy8BT4GgFtEN6WvBZpj1NJludqi9RWZ+73vanTMUXYwEcb4RMP6uNyFpGDO2035Tc9ANieBjpkfsNzMAM2Mwncz6EERnL6ZkRcdnjETfJqBxj9Xfn53cwbRlCPdrF31THosxYja44Am/wX+RKN9GhFkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fortanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=odagmxp/NX1cnFM+GqvoGA1oVVi1H8/dDZkzkCkiUSg=;
 b=MheQMyAAAugGZPWj4Zsncnc2f5F9ktwuPbjHFpmb1x+YD2//E6rePZfUu7wkdnO+HrO6nJQT1L7C1Je81IapeLEc3STYqkwbOYpnH+bH/PWvWYt3p+DjLBORYcmD4DjQCGvITpl/ke2PRfhHiawMULEN5wkeUBesMAGTUtIYZ1Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fortanix.com;
Received: from PH0PR11MB5626.namprd11.prod.outlook.com (2603:10b6:510:ee::15)
 by SJ5PPF524F3F9FA.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::829) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Wed, 1 Jul
 2026 09:40:43 +0000
Received: from PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::64f2:5af6:ec99:cb80]) by PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::64f2:5af6:ec99:cb80%5]) with mapi id 15.21.0159.016; Wed, 1 Jul 2026
 09:40:43 +0000
Message-ID: <80f3f279-d70e-44d7-a179-c52068115e46@fortanix.com>
Date: Wed, 1 Jul 2026 11:40:32 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 3/6] x86/sev: Disable CPU hotplug while SNP is active
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
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
Content-Language: en-US
From: Jethro Beekman <jethro@fortanix.com>
In-Reply-To: <205a5259f9fd353dc0ca6b00565c8175a96768c7.1782841284.git.ashish.kalra@amd.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020504080608050802090102"
X-ClientProxiedBy: AS4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::18) To PH0PR11MB5626.namprd11.prod.outlook.com
 (2603:10b6:510:ee::15)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5626:EE_|SJ5PPF524F3F9FA:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fc308d8-fa26-4680-5b11-08ded754d1bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|22082099003|18002099003|921020|5023799004|11063799006|56012099006|6133799003|3023799007|4143699003;
X-Microsoft-Antispam-Message-Info:
	v+UJwkPr38H0uvud3GolYzYbDX9alU64Dp/AEmtuxeQTgbKBowetSrhu28I9oyskvVSXi1mdFCtiHlQTQZdOaZ399jrgKu3PLiXFZzkK0QnF+bp4ttS82gMkzqbfL9m6x6e1ZIDRBO5zzI3Uts+nU8qf2WMaJrfVB+zrzyQlf9fGTf3D5IA/XPFAVtTm8b9GZ3NZjhiah2OzTkNdS/anIAzLapKyHgrj7fP6L7hRk5SIOe9HC92domPzCsMMMnAlVk4mCLQdSQrEUPBnyu5ZLfW4nkbEfh6XAlpwdd6/ZUvXyNr4yPMzOBiKYDlTmv7HeVpz8rePFd3l/uc6Ba05dEApbpY/+AvrS/kw/kbMDOdolZeEGR8YyrpuU1qfAdRM2xexKE6pPXneLKQfJoGwjtTJ2xxXh+g6909yg++ai4GuDqU6Ai0MkpsQpvdPzN6CC/8iSnAoxGipcutg50ABRtT4wwD/ZGSc47ACVNSzp93VhO1Ihb/j3D9gE5Vd/zpI3dZ5WrB88Kv32abv8MK/cEvfnHdqemXjCgesgXSD+5OPWUxJUhSvdDXTOHAokekeHUfYx8bg4yvuxf7wDEvjsZe1i8mXMDSwr4X5aUovfUcNZxXdDw2RhZQ92UbvGFzTRcG4N391VENEVyKb/0STWM6DOYgE2E9tyI7TMf3GvxMQU6Taxnk0ZPu9bofp7f+6A39eID5+Ecp6E4OlhgbUQA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5626.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(22082099003)(18002099003)(921020)(5023799004)(11063799006)(56012099006)(6133799003)(3023799007)(4143699003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WmsycG9oTWRYckN5c05mYTc2MG5xSHlWYkdBdEtpL2s5NUlKeGJ1U3dBZkVK?=
 =?utf-8?B?RHV1bE4rbU9GdklNcFFRUnFxc3NheklWVERWUUJnc05Ydnh2bnNxbllUcE5V?=
 =?utf-8?B?NWlRYW42c3NtQ29BTEtnMFhUd1ByNUthT0NuU3lrMHlvTzlmZERCdmJuejhZ?=
 =?utf-8?B?MmZybGJxTTVlUjJSK0drcWhXZ3lCMzExaElySWp2bHp4WHU0cXd4R3RnMGxa?=
 =?utf-8?B?YTZoaStJQ2d4bE1WRUc2N0VlYWRWSkt1ajRuY0VrVHlCOFhwSWxJbG5POENJ?=
 =?utf-8?B?L2F1NFAvUW1iTm50cWJWY0RlN3V3NThHSU1wNi90MEJFaWdPaytyQkdObkhy?=
 =?utf-8?B?WXZZdWxlMjU2MlZGTU9ua1pQY1NJYUp5U3pEVnhaMzNuVnR0OVk4KzFxbHM4?=
 =?utf-8?B?VUxXSy82WjRjd2x5TUZOb1hHSmwybE1pWHgxY3FCZzJjZEZ5RXFLdEZ2OFlt?=
 =?utf-8?B?M09LRmE3N1F0NmtwendRc1pzRHdJd3Fib1p4MCtlMFAya281UnJJVHdOaVZ5?=
 =?utf-8?B?bXF6L2RvVjFZYXFYNk05SmZta0hncmRHRWtIZEQ3NnYyRlVOQTBtbExoM1pY?=
 =?utf-8?B?ZEI2WTgvZm5mQjdENURzY0pZcTBodEU2cmg2TFBVSzduZ3c2UHgwNFhIMHdH?=
 =?utf-8?B?dzdHWUwyUjNvS1FVand6R3crUDdVR3VHWnQxUW1sVVlNSzJnSmJhaW1kaVY3?=
 =?utf-8?B?dDJacUNLN1kxQlpvY0ZhNXlGYXoxdTR1OFByTDk4TDZ0S3RrNXpwVVVtU0NL?=
 =?utf-8?B?Nnc5Z1FtRjRyTHRTeDJzUkQrenp5VkJQYkJ0ZkcvaXo1UVN6VFJmNXVORlZH?=
 =?utf-8?B?bi9OLzNzTVUxc0lmd3RJeDRHcmtWSnMxc2Z6U2pnclRUUENKMGFEblFVQXJx?=
 =?utf-8?B?RTlZQUlrd0lYbW5VZ2hnbDRjTGVrT0phc3R2VEsyNkZsUC9kZGQrNlFOQmlH?=
 =?utf-8?B?YzlSUmh0WXYrRzBVWk04SlJmODQwVUx0Nk41cEdNeURkTDJSVGRuRWozdHNB?=
 =?utf-8?B?Q2RmcTBmY2RjK0QyMFZqcXFCaHJhVDNEaDQwdXNJaS9iUnR2UWRaYmVMV3BH?=
 =?utf-8?B?TDRqM3hZbHRxQXJxWHBRU1oyd2hKTW5pQWNvTHU3UHJpVGhZTEd2SXYrVXJH?=
 =?utf-8?B?bThhZTBnNXVOelg4ZXdVRStyby9qbUdkVDY2VHQyNkFCTk85U3NsODgzZUJ0?=
 =?utf-8?B?R2plS3p6dURPQThJeFdTb0xsaUxkUFUrQ2FlYUZxaG5tQVFIRFp5S01xc2Z4?=
 =?utf-8?B?NnBCMGtNeFF2NUFrS01wNFdXVlh3WEtONEFzQ2Q5TjNvUWQ0UmtwREtjbVdD?=
 =?utf-8?B?bjlGVmRGZXZRdzRobGtQMjU5UTBIV3JMYUkxNHhLbEhveUQyNnNsdmQ5Z3dB?=
 =?utf-8?B?dWRzQWVwdWJvc0dQeDBpeGYwc0x1L0UxSVBRUHJRVTFjclVNdnd3Y2p2aDNX?=
 =?utf-8?B?MnY1ZkRPMW1DYzlnZjBnQXZQOFprcWwzWExjTEVpUURSdlFTYUJRTVI0Q1Mw?=
 =?utf-8?B?WDZnUWRlK01UR0NjK2U4VGRJNEhEZ3hRTDVyeGZwNVJIbWh6cFF0bmV5OXFt?=
 =?utf-8?B?d2FobHJmYjlCOVkxdElEQlVtUzRxN2YrVytpNUh3SzI5OGdEa3JZOUJYeE1D?=
 =?utf-8?B?QjZpNHpRd3NhbXdOU3R5Qk9OSE5jdzVwU2F3M3lLUmV3d0FNYU1RdGNDNTZ1?=
 =?utf-8?B?VGFFUlNmdUxsK0ZWKzdRTXYzREJwdFczTVR1QUNjTnB0enh0L25laW1VWmFU?=
 =?utf-8?B?ZWZURUtUbFdoemxjaGlhd1k3aGZSVTc1eUFTTEpnaGlIbUpjVHRoeEEyTHJI?=
 =?utf-8?B?STFMUVhidWNrR0ROQU9hVHhrTUxBSWNvVVN2clhmcEx6TjNGYWxPeWVRK01n?=
 =?utf-8?B?UHhxRHZDWnRZV0FkWE1LaWtuZXoweU9mSE1QYjFhS2M1ZmpQaFNoYWtSdHht?=
 =?utf-8?B?eThUdWxVdEpqNVloV3lTN2NUdmE0VUIwcklDVkJhTGN3eXhMRERYcDZNUk01?=
 =?utf-8?B?MXMzKzN2OWhNYTZxWGNLc1VUcFVGTGcrdGxhVHAzWVR6T244UG9JVysyRG1v?=
 =?utf-8?B?Z2h3OGhmTkE2RUFQWHBiczVDUEFnZVZwYWxGV2MvZThqNFlBMmE4L3Q3SHQw?=
 =?utf-8?B?ZU1jaHZHRGloakhJMnRlaGlJZkk4VGxSU0drZGE4dVZod3V5VlJQWG9aNVRi?=
 =?utf-8?B?cUFxWTJsbFVQVy8xVFhDdDluNWlLRVBZTkIzK0FOL20veGpHVCs0eXVBTFNN?=
 =?utf-8?B?RnhqbUNIc0VNM3IwTy9kRnA2U2FROVJNc1IzN1VUUEEvcTZUVWN5dEFjSFdu?=
 =?utf-8?B?b1NLY2dTMG54V24xdXJscWlQYUpuZ0Y4Z1dneVEwR28xUEZrTnVtQT09?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc308d8-fa26-4680-5b11-08ded754d1bd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5626.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 09:40:43.3696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eIII+qzQuwoI63W/1fvSkNWozIpOMIOEjcCz18+en6mu9kxMdJ3S4kx0DhjzGnxAazr9HoID6ErwgTtARCCFYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF524F3F9FA

--------------ms020504080608050802090102
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Ashish,

I don't believe my concern has been addressed

https://lore.kernel.org/lkml/0df3b665-3a9c-4c46-a7aa-14388e8e1577@fortani=
x.com/

--
Jethro Beekman | CTO | Fortanix

On 2026-06-30 20:11, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
>=20
> While SNP is active, every memory write is checked against the RMP to
> protect SEV-SNP guest memory.  A core performs these RMP checks only on=
ce
> SNP has been initialized via SNP_INIT and the SNP-enable bit in SYSCFG =
is
> set on that core; the firmware requires the SNP-enable bit to be set on=

> every present CPU before SNP initialization.  A core that is not
> SNP-enabled and not SNP-initialized performs no RMP checks at all, so
> there is no valid configuration with SNP active and any CPU exempt from=

> RMP checks.
>=20
> The firmware determines which CPUs are present from the processor and t=
he
> BIOS/UEFI configuration (e.g. SMT disabled in the BIOS) and enumerates
> them at SNP init; it is not aware of the OS bringing CPUs online or
> offline afterwards.  SNP_INIT fails unless SnpEn is set on all CPUs, so=
 a
> CPU that is offline at SNP init does not have SnpEn set, SNP_INIT fails=
,
> and there can be no SNP guest memory.  OS CPU hotplug can thus diverge
> from the firmware's expectations and break SNP.
>=20
> Tie CPU hotplug to the SNP-enable bit: disable it in snp_prepare() befo=
re
> SNP is enabled, and re-enable it in snp_shutdown() once the firmware ha=
s
> disabled SNP.  If snp_prepare() fails before enabling SNP it re-enables=

> hotplug itself; once SNP is enabled hotplug stays disabled, including
> across a failed SNP_INIT and across the legacy SNP_SHUTDOWN_EX path, bo=
th
> of which leave SNP enabled.  A kexec target that boots with SNP already=

> enabled disables hotplug once in snp_rmptable_init(), since snp_prepare=
()
> bails when SNP is already enabled.
>=20
> This also keeps the CPU set stable for the asynchronous RMPOPT scan add=
ed
> later in this series, and ensures cpus_read_lock() in the scan is
> uncontended.
>=20
> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/virt/svm/sev.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>=20
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index dab6e1c290bc..04a58ac4339c 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -535,6 +535,15 @@ int snp_prepare(void)
> =20
>  	clear_rmp();
> =20
> +	/*
> +	 * Disable CPU hotplug before enabling SNP, so no CPU can come online=

> +	 * without SnpEn while SNP is enabled; it is re-enabled in snp_shutdo=
wn()
> +	 * once SNP is disabled.  Must be before cpus_read_lock():
> +	 * cpu_hotplug_disable() takes cpu_add_remove_lock, which nests above=

> +	 * cpu_hotplug_lock.
> +	 */
> +	cpu_hotplug_disable();
> +
>  	cpus_read_lock();
> =20
>  	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
> @@ -560,6 +569,10 @@ int snp_prepare(void)
>  unlock:
>  	cpus_read_unlock();
> =20
> +	/* Re-enable CPU hotplug; SnpEn was never set. */
> +	if (ret)
> +		cpu_hotplug_enable();
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
> @@ -587,6 +600,13 @@ void snp_shutdown(void)
> =20
>  	rmpopt_cleanup();
> =20
> +	/*
> +	 * Re-enable CPU hotplug now that the firmware has disabled SNP; CPU
> +	 * hotplug is not re-enabled for a legacy SNP shutdown.  After
> +	 * rmpopt_cleanup() so RMPOPT_BASE is cleared with hotplug still disa=
bled.
> +	 */
> +	cpu_hotplug_enable();
> +
>  	clear_rmp();
>  	on_each_cpu(mfd_reconfigure, NULL, 1);
>  }
> @@ -645,6 +665,8 @@ EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");=

>   */
>  int __init snp_rmptable_init(void)
>  {
> +	u64 val;
> +
>  	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
>  		return -ENOSYS;
> =20
> @@ -654,6 +676,15 @@ int __init snp_rmptable_init(void)
>  	if (!setup_rmptable())
>  		return -ENOSYS;
> =20
> +	/*
> +	 * On a kexec boot SNP may already be enabled (legacy firmware leaves=

> +	 * SnpEn set across shutdown), in which case snp_prepare() bails with=
out
> +	 * disabling CPU hotplug, so disable it here.
> +	 */
> +	rdmsrq(MSR_AMD64_SYSCFG, val);
> +	if (val & MSR_AMD64_SYSCFG_SNP_EN)
> +		cpu_hotplug_disable();
> +
>  	/*
>  	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP pa=
nic
>  	 * notifier is invoked to do SNP IOMMU shutdown before kdump.


--------------ms020504080608050802090102
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
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
BgkqhkiG9w0BCQUxDxcNMjYwNzAxMDk0MDMyWjAvBgkqhkiG9w0BCQQxIgQgHzJtDNGoxLgy
mFiBc6xv4LQVX9sS+eCYO/pzyjbi1DcwgaMGCSsGAQQBgjcQBDGBlTCBkjB+MQswCQYDVQQG
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
DgMwDQYJKoZIhvcNAQEBBQAEggGATXyY1P4GR3LcGajM+KBos+ETtZvyVXalr9ALvKUafb7y
KpZZg14FfsTh07Tt1b12PITreZKEn15NLIs+blQC/HCceupZJLd6hfshIDsUG20K8qAWn/eA
n7NqC1BU/c6aWemw4Otu4KGTe2SZ7/sEsn01xvCRHIK7OeMXv+cY03465tGHhSamF6Mt5lOO
jZIJsH0kqDnAIXZ9t/KhzJovcoDPsK3zW8Ht3QrTzdPM8BPiZHtu0z3g2Dot/Aqxjow7Aq/4
bwghTYhuhWoGt0AZme7phkfZWiUWuWfA4ZLliKpMzS2y8gCqFg+YzBj7xPcvmTqwoZ/mzrZg
gWqUIF+Lz7MH54mHbKME0u4yptOuKtJ+SQJQ+3I9fFiV/v6B4gVA8gv0ct38sSt6BVljQBZH
vSJNAM+L/ij//4zvUsDrtcHnQaIwv1NPldPww3l63n4UVudev77fOg2D4eg0q0uuKff+zF+J
P2Uu7RrOf4VAO6MTv41UGVgnCKAcN3xs3UEBAAAAAAAA

--------------ms020504080608050802090102--
