Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F029519CC3C;
	Tue, 10 Jun 2025 06:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749536742; cv=fail; b=PYjMDM8xmKM6iz5WHp0d2CuYFrspS7kLBNQvvs9M79Xw3OrNkCVhGzTHlh2R8yMNfRCmiroDs1ztiFmmzvI/5MzylxcM2wCIDZ0snxi0nZ89sd4daxC34udIXmQUl4ukXeO17bOeCSFTzXBXHW/Bb1m/9hQ6CId89VvuGGYpBl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749536742; c=relaxed/simple;
	bh=NLZ4dqYc+wqWE2BLaYJpwoo7S9O0ym3fv+3zE99C904=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rDzFznfjNM++Nc05iu6uMD9sVf7S/27yHIz3qzITZdlzE3U7AWiXqHv5q9/yPhDkvf0Rj0kB3p+DOqMhQyzocQ0wckfh1rZYgmmxLD7SyuOCO5gt/3os9FD11VC1VWvlrotbp5PnwtBMCm4cW4ya0ths0TCl7IZA1Fc/G6IgkCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vVUIVrTf; arc=fail smtp.client-ip=40.107.220.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vVUIVrTf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jOQWvh/CvqQhaWl4RAHKSawS1yNZ4DKEkMWuuT8rFtS3lvhQx3kG2gT7XVsLbhRO+wT1Zl2dtY8R8f0gdeiQj4HTohgrlmKpN68XOFiByG/20hCfTmdV0KcXGhYnaOhJ7vAAkVIbqOtpYcPS+LpgWcMTbBzent/IJqWZQiu7UMorE6chV+tLfBdNj2UtBysK8CMOo9z2/QCLLhuG24S4+E/V+Gc0xA+WQdRAYoxsCw9fv8Fnjgv7qmgabpZL+2ubcg4RF+KgLoOll7h+wvdr0T1JM4Vp+/BE+sZ1aRirGFfDjjsRtElewSzVlv4iX/vPDmPoscMG06+xVAh/38ph1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NLZ4dqYc+wqWE2BLaYJpwoo7S9O0ym3fv+3zE99C904=;
 b=MwTPc1CLDILHt0BN13iFPPh2C5hUMAMUz7eUrVUe8HkccS8H0UMdRpR/wfUAyPehrq+AQe7xrOoFMvl7lOG6+a1+EAkenZZGRDxpNdImn61CWCYh7CGJ7pqLvtgZt4eziQoM2tC5P7YXuQinDtViFYg7S75ou9uKoeYamuB468o27JXXA4pUjX38b/uk/53POYhmvkp6tK8LGLsLAtNVegYiJaA+Hf8Pv/zZgYazkpGcojq9VWprx9vXjVDCOHytTCBHEebldjkVhTgZ7qzuqJrwx8ZDhLq2stfvT1fo8/I4IR1o1lmR2Bq35/B71n6m+U/L35m6dFWAQ52ypBBR3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLZ4dqYc+wqWE2BLaYJpwoo7S9O0ym3fv+3zE99C904=;
 b=vVUIVrTfB16+RLy60p0iMUETeZNpvO3QaASXMBKuyJIUZZX903Eh8pBODRlAz0Pw3Yi1DmiVR0epyrGu/Y/gMxgsneNABvaciw10bn9A9nJSO13Kq9SlVzsGCnKLvd0z9RIN1turFjrav+x1/US2F2aCPeFwPvqooXzcROwB38g=
Received: from DS0PR12MB9345.namprd12.prod.outlook.com (2603:10b6:8:1a9::10)
 by IA0PR12MB8929.namprd12.prod.outlook.com (2603:10b6:208:484::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 10 Jun
 2025 06:25:38 +0000
Received: from DS0PR12MB9345.namprd12.prod.outlook.com
 ([fe80::65ab:d63c:7341:edbb]) by DS0PR12MB9345.namprd12.prod.outlook.com
 ([fe80::65ab:d63c:7341:edbb%3]) with mapi id 15.20.8792.034; Tue, 10 Jun 2025
 06:25:37 +0000
From: "Jain, Harsh (AECG-SSW)" <h.jain@amd.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
CC: kernel test robot <lkp@intel.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "Botcha, Mounika"
	<Mounika.Botcha@amd.com>, "Savitala, Sarat Chand"
	<sarat.chand.savitala@amd.com>, "Dhanawade, Mohan" <mohan.dhanawade@amd.com>,
	"Simek, Michal" <michal.simek@amd.com>
Subject: RE: [PATCH v2 4/6] crypto: xilinx: Select dependant Kconfig option
 for CRYPTO_DRBG_CTR
Thread-Topic: [PATCH v2 4/6] crypto: xilinx: Select dependant Kconfig option
 for CRYPTO_DRBG_CTR
Thread-Index: AQHb2Po5iuwhGFDFlU2DnCWoq8gOPrP77MaAgAAA4+A=
Date: Tue, 10 Jun 2025 06:25:37 +0000
Message-ID:
 <DS0PR12MB934522D61F5A16FA42A9F4E3976AA@DS0PR12MB9345.namprd12.prod.outlook.com>
References: <20250609045110.1786634-1-h.jain@amd.com>
 <20250609045110.1786634-5-h.jain@amd.com>
 <c1c36fb1-67a3-4660-816f-a2f15786f2a9@kernel.org>
In-Reply-To: <c1c36fb1-67a3-4660-816f-a2f15786f2a9@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ActionId=dd366010-475f-4d08-937d-894dbe44aebb;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=0;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=true;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2025-06-10T06:20:49Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR12MB9345:EE_|IA0PR12MB8929:EE_
x-ms-office365-filtering-correlation-id: 565b221f-27dc-4e50-7daf-08dda7e79d8e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?c1NRWnRNYXR0eEpycXZqZlA0K3lFSGJiNE9xcTFublhlWXlnaG5xeXRmdWQ5?=
 =?utf-8?B?NzRqR045eEkzTEJSbjhtRDVsUHM1NTQzdXo3QmlJNWtnRFBHNGczUVN1Zms1?=
 =?utf-8?B?Smh1UWZTdlNBc2w4Q1pvL1dxdmt4blN5M3M2bnZlNVUvRWh1Mzl1QXZJeEU3?=
 =?utf-8?B?cE04K29Zek1yWnVGSUZoN2RVeFFhRk04MU9JeWZhOG1oSFJDVEJzYkNJSUpB?=
 =?utf-8?B?MWpFR1MzT05oOEp0U0haaFhveEVaNHRaWlFlanUvVnV2M3libk54MFV5TUs1?=
 =?utf-8?B?N0ZySHlBaHA1NU53aFh3RGwvd3FTQUg3OVJsa0R2T0lxN2h0R2tXSE8ybkRx?=
 =?utf-8?B?Y2hYaXdpZnVvVnd2VHgrRThSZnJzTkVVSEhkM1hsa3pVYjZKSUZweG5YeHhC?=
 =?utf-8?B?YW56L2xxeUh0eURqU3pLalZDVnRacFNxNFpCNFRUSWNRVWxUYnBPbGprb05T?=
 =?utf-8?B?Yk1IYkwvNEhibjRtRml5UE9HRUptdkxoWTVzSHZRNmhZUWc1S3VlZFgzWlRa?=
 =?utf-8?B?eWh6YkphOWVDRVZnSy9BeW02V09PdlFUMW1BTUVaaVd5aDdldXVHQ0FOSWxO?=
 =?utf-8?B?TStQdlIzUSt5anpnSEpiQXI0NlpLd2FVN0pwenU3YXVTY0h4M001UzBxNjFU?=
 =?utf-8?B?aUwra2wrUHlkMFR4Znp2akZOMndXNHlsM05sWEtXQ2JtOTNibEVPdU91Tzho?=
 =?utf-8?B?Y0tXNmZXcWFvaEppZkdjckJqMHN6UnNXVDdibXptNFZ5S2x1Z2hLM0crNWNz?=
 =?utf-8?B?TFB1b1VwU2t1RkR4L2VZWlRyZ2VvV0dnbDRrN1ZTTVJSNFJuVDM1c2RYQS9a?=
 =?utf-8?B?RmVKOXk1YnVoc09EZTlwNzM1Q3RhdmVaQ2pNaE1mWC84aDYyRkhxWUpwNnBo?=
 =?utf-8?B?SDV5Q1p1MG1DZmEvbHJOYlpjcGR5RWwvYXFJbUZwNnNCWWg2REkyZHo4Q0Zx?=
 =?utf-8?B?UWxicFVSK0JMazBiczVNWlZBSHlZYmUzelJNU0kwclc0ZzFzTDRYOWRLSVZ2?=
 =?utf-8?B?TFhEc1VCRHB4Vk5MREhheUNUMVlvaElrRUtsMVlIQlUvZWdkZ0hsOGxoUU1z?=
 =?utf-8?B?Z2hiUm54WjZhNTl1OXZOekE0c1ZjL2gzTklOUGpGTFBmVXAyVm1Oc0hpUnhy?=
 =?utf-8?B?NmR6Z2tkeFo2dnMwYlBqZkVDdnJTNUhFQTBmRnk1LzBuTVJzTlAvSFEvMHNq?=
 =?utf-8?B?RjA3bFNZbitKUWlaNExqVUFVMHhBdGlKOTVMZ25NVXFMOTVLTktUN0g1ZDcz?=
 =?utf-8?B?Um94MURtWWhBdXlpY2VZa1JyelRHVEVRVHVHeXE1OEc3aE5iMjBpMmZQWWNm?=
 =?utf-8?B?TGJLV2pLY3FVR0xtZjQvU1hPZnNZaWQ3RndUeGFhWnlpZGNXQmFvUHlqM1hK?=
 =?utf-8?B?SncyU3dUeGI4Y0lMbVhOdCtmZ0FCeUpMQzFxQ213cnZSZGxvcFFQNXl6MFFM?=
 =?utf-8?B?UEZyTi9ERTRuSnIyTXRRaDl0bkFuQ3RSK3lnUDR2b1BrWmV0cXV5Wk1mWWt6?=
 =?utf-8?B?S2tJa1JEQW5aS1pad3VFcGdMb0x4RzU4TzhRNnRKaFlYRkdyQzN0dlk3b1BT?=
 =?utf-8?B?L0NJVmk3L3h1ZWJhQi9Jb0RPbTJkWEFIQUUrbHVoZHQ4Q1Bvb0RzdkRjMG5s?=
 =?utf-8?B?YUNYb3oxM29nZDlSWVEybW1zZWpBSW1Nc295S2p1SlowYldXMlJyMWIzTVYz?=
 =?utf-8?B?UjQ3Y3VIR0c5VHNaNGM2YTFwNkVEdzNwb1VLU0F6VnhEbldVRXplTkhSVjNI?=
 =?utf-8?B?VE16SkFNNXk4a2lwVmxuY0FadlBUTXJqT1dYR0VtU0Ivc1gwYjNsOUFaR05r?=
 =?utf-8?B?dE5RenhYUmFLcHp3c0ovR01oREluUms3YlBDOC96N2g5eHVJa05YQStQdlNk?=
 =?utf-8?B?ZTFVRTJicnlmWmJYTEprMEtlMnRER3c0SkxEWTkzZjI5U0QwbmF1UitESm5u?=
 =?utf-8?B?WWV4bHRTT0Nqa0ZYSnZ2VTF3ZEJnaFQ4RWNJV1RZYkRhN0VlU1RobXFNQk0r?=
 =?utf-8?Q?1ZCMerFJc4/Xarj2dZGeMSFPdPJ+KU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB9345.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZUh6U3BoeWQxYkxNanUyMG5uWTdBZ01PdkNOUkVxVGZsT2VUMHJRSnRUZXd6?=
 =?utf-8?B?b1h2MzlKMGdHTHk5bTZZZHVFY2JneUhhMW1PdVBJMXR1aWxhUzRJQ0wyeWtT?=
 =?utf-8?B?TTlycW9pUlFaRlIxaDBKeVZFTmFERzBMQ0NacFZGeVRuelhNMWZvcE9mc0FQ?=
 =?utf-8?B?bWo3dkxPNllRL2lYUUFtak5iQVI4QlZROWpIY2wvUjkyQnNHS01jUkhmQzZw?=
 =?utf-8?B?ZEdCSTU4RGJlNFF0Nm8yNi9BUEM0S05qRWJQUzZHeXpoc1VCdFJNeC9oajZB?=
 =?utf-8?B?QnZwa2trKzFJV0UzeGxtc0F0Kzh6TE1rTjdhNU9teVh2ZEtZT2pOUjF3b2l1?=
 =?utf-8?B?VlhOMGZCb21RcWxrWEU0QVM2N1Q5V1V0RHNmQnBWcFR5ZDFCb2lXMEREVjFQ?=
 =?utf-8?B?NjhsbnkrZWttQWVWcVdNcUZLd3F2OEk5RG5acFM2S2o1YUZrWXBodnRsZUVD?=
 =?utf-8?B?S2RPd3BwaHA1dUQ1aGpYaGZDRllvd1VkditxbGYwekNiSSs1SGYxUm1mS21S?=
 =?utf-8?B?Qk5FVmtSSVpTTVRYUHU5ekxEYWQvaDh6NkIvMUtQUWpRaVNnNGlLckgzMkFH?=
 =?utf-8?B?MmRqcFE3M3dKT2lEVWd4aThoa2I4bWZVaEpjdDY1M2w4MEtweW9ZRzZMaFRl?=
 =?utf-8?B?dk5vNUc4VUplVHM0NFI2enlkS2d4bWRGRStFZmJselpROG84V1VxUlhudDh3?=
 =?utf-8?B?VVVRcFR2cTF6ZUpRRHNqUVdtLys3YlFyY2NrQ1BHWVdoNDFoR3IyQUZOMTVk?=
 =?utf-8?B?YVBFb1U5TWVESVBMSnorcnhFZXVLR1dieWh4OFRIU1dKRzZuUzRFSmkxdXNu?=
 =?utf-8?B?OTgyMnpFV3ljcUt5R05KMjhVTjBjS1E3allQdEl1UXFYS05KQy9iRDdHaGoy?=
 =?utf-8?B?aDk3djFuRlNlMTBsY2hUUjZKYXRPYU5nblFQb29wOVl1dHJBZ0VFWnI1MHZt?=
 =?utf-8?B?NndSM2NXMzF4Smdoa1R5Nm9PY21EbnhTMkg3b0xYcktCMWNONWlTRWNQWTNR?=
 =?utf-8?B?QXVybVErVEdnSmMrNHc2U05sdzBHbUdEMmlvdjBlNnQ3MXBQNjA5MVhTYjdE?=
 =?utf-8?B?SzB3S3NzanFNdzBwUkhZbEVQUnRBTmtBRUlFVVowL3E2WVFyWkRvVUlXUXlp?=
 =?utf-8?B?YlZ4aVVrSXFySUxYcFhPUmJ2djdLMWRyMFdSTnFiOTVKaEd0SWJzSkhmaFBX?=
 =?utf-8?B?ajFQbWtjb09DcFhVdjFCUTFkZ1JNbzVUQzZyMlRFREloaVJVOW5Tc1hjNCtG?=
 =?utf-8?B?OHljeW9SdmpYdnlNcnZJeFExZ21md1FqVUc2T2N6R0xnaCtiZnB3VFJ3ZG4z?=
 =?utf-8?B?S0xqY2ZuMi9ySVVMQzN3eFduNDFVSXl1aDczRlZyT1h1emJQRUNTcjdoQnFD?=
 =?utf-8?B?Ni8vdklDTnh0a1p5RklOanVJS2xyb0VRaG5kRzlsdmtDbnVZdVUwMi9tanNq?=
 =?utf-8?B?SjRZd1JpdlFkSm5ZWGMwMU1GMUlrdmtMaEhxWHl4YS9mT2VxVlVuRnZteXli?=
 =?utf-8?B?dXlhM3dBbjFJbC81dmhtbUdGVjZ6dWc5NjRUNGRCaHBuMDMwRmNTU3A4RzQv?=
 =?utf-8?B?SE9HcFlWUFpHZStrditqTUJsNUNpWERaN3Bxc1hPaWFFUG5zOUYyY012djlB?=
 =?utf-8?B?YmpHcE9VQ2dxOE83U1dsdFViY0xQa1VKUDBBazkzREsxZW5ZK0kzOG83VlVV?=
 =?utf-8?B?UG03RVN5TGVjenJ5aXVFZCtFSTNrUkpORldTQ1A4RXFkbjFOS2RvbW5IaG41?=
 =?utf-8?B?aCtVc0ttdGVPOFRWZGpDeXBoVVlwWjdMT0dtNDU3MXZjTGM0aHplL0lRa05o?=
 =?utf-8?B?ZUVIUCtTekNVSit0bkRZSkQzUnN5QnVnUjdlSHZ4d2hYVVZuZFNlbXlSYVdj?=
 =?utf-8?B?bDhFNFJzWjRnZ1Zjb2RiNkpLRStyM2Nza084ODJpVzZpS3cyWG9IZ3pkOEtG?=
 =?utf-8?B?dVZJb0VhR0NWdTBBTkJIVG50ckNEN3FBMC9WeGJZTlZGTXJwNXk3RnZNKzRv?=
 =?utf-8?B?U0k0YUt3cDFZcDJUTENNQjVKaVRNK1EwZy9oOEdRQmlpZ3JlYlQ1M2pyUDNt?=
 =?utf-8?B?RCtkcXVXemhYWXhDUDI4S1hRTGt5ZXhzL0JEbGl3VFE3RnlMY21IUWJXM1dF?=
 =?utf-8?Q?vVKM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB9345.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 565b221f-27dc-4e50-7daf-08dda7e79d8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2025 06:25:37.8947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dbl7JBq/e1qZmUwaM6dkBP/OXSeUdw5U5qp01t630/YT30Zd/EYBjFM7lRh13wYK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8929

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEFNRCBJbnRlcm5hbCBEaXN0cmlidXRpb24gT25seV0N
Cg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBLcnp5c3p0b2YgS296bG93
c2tpIDxrcnprQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IFR1ZXNkYXksIEp1bmUgMTAsIDIwMjUgMTE6
NDggQU0NCj4gVG86IEphaW4sIEhhcnNoIChBRUNHLVNTVykgPGguamFpbkBhbWQuY29tPjsgaGVy
YmVydEBnb25kb3IuYXBhbmEub3JnLmF1Ow0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBsaW51eC1j
cnlwdG9Admdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsNCj4gQm90
Y2hhLCBNb3VuaWthIDxNb3VuaWthLkJvdGNoYUBhbWQuY29tPjsgU2F2aXRhbGEsIFNhcmF0IENo
YW5kDQo+IDxzYXJhdC5jaGFuZC5zYXZpdGFsYUBhbWQuY29tPjsgRGhhbmF3YWRlLCBNb2hhbg0K
PiA8bW9oYW4uZGhhbmF3YWRlQGFtZC5jb20+OyBTaW1laywgTWljaGFsIDxtaWNoYWwuc2ltZWtA
YW1kLmNvbT4NCj4gQ2M6IGtlcm5lbCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPg0KPiBTdWJq
ZWN0OiBSZTogW1BBVENIIHYyIDQvNl0gY3J5cHRvOiB4aWxpbng6IFNlbGVjdCBkZXBlbmRhbnQg
S2NvbmZpZyBvcHRpb24gZm9yDQo+IENSWVBUT19EUkJHX0NUUg0KPg0KPiBDYXV0aW9uOiBUaGlz
IG1lc3NhZ2Ugb3JpZ2luYXRlZCBmcm9tIGFuIEV4dGVybmFsIFNvdXJjZS4gVXNlIHByb3BlciBj
YXV0aW9uDQo+IHdoZW4gb3BlbmluZyBhdHRhY2htZW50cywgY2xpY2tpbmcgbGlua3MsIG9yIHJl
c3BvbmRpbmcuDQo+DQo+DQo+IE9uIDA5LzA2LzIwMjUgMDY6NTEsIEhhcnNoIEphaW4gd3JvdGU6
DQo+ID4gQ1JZUFRPX0RSQkdfTUVOVSBLY29uZmlnIG9wdGlvbiBpcyBkZXBlbmRhbnQgb24gQ1JZ
UFRPX0RSQkdfQ1RSLg0KPiA+IFNlbGVjdCBDUllQVE9fRFJCR19NRU5VIHRvIGZpeCB3YXJuaW5n
IHJlcG9ydGVkIGJ5IGtlcm5lbCB0ZXN0IHJvYm90Lg0KPiA+DQo+DQo+IEZpeGVzPw0KPg0KPiBJ
ZiBub3QsIHdoeSBpcyB0aGlzIGEgc2VwYXJhdGUgY29tbWl0PyBBcmUgeW91IGFkZGluZyBrbm93
biBidWcgaW4gdGhlDQo+IHNhbWUgcGF0Y2hzZXQganVzdCB0byBmaXggaXQgbGF0ZXI/DQoNCkkg
YWRkZWQgdGhpcyBmaXggcGF0Y2hlcyB0byBoYXZlIFJlcG9ydGVkLWJ5IHRhZ3MgZm9yICIga2Vy
bmVsIHRlc3Qgcm9ib3QiLg0KV2lsbCBzcXVhc2ggdGhlc2UgZml4ZXMgdG8gb3JpZ2luYWwgcGF0
Y2guDQoNCj4NCj4gPiBSZXBvcnRlZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5j
b20+DQo+ID4gQ2xvc2VzOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9vZS1rYnVpbGQtYWxsLzIw
MjUwNTMwMTkwMC5VZmVna3k4Zi0NCj4gbGtwQGludGVsLmNvbS8NCj4NCj4gVGhhdCdzIHJlcG9y
dCBmb3IgeW91ciBwYXRjaCENCj4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBIYXJzaCBKYWluIDxoLmph
aW5AYW1kLmNvbT4NCj4NCj4NCj4NCj4gQmVzdCByZWdhcmRzLA0KPiBLcnp5c3p0b2YNCg==
