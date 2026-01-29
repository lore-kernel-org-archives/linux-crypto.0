Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8212D6E7C;
	Thu, 29 Jan 2026 06:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769668491; cv=fail; b=LAg4wiIlf0VUkM3Gc4ZTR21ProTY4i2fuRwrGD0BFFOSRJniwvBkKCzVZUfwHKs6x2TNAjyuHCBJEq70qH0HzGSGTZx1ZOpQh2AX63J4pJErHpW4ZLnsVuRwFoNMt2I6cYCbHKotHocikIpldOw7zuliFPjgLXGidrUlIogRcvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769668491; c=relaxed/simple;
	bh=CTjF6vSdYn1U9ppJhb4USaUr2y136jfnLFifwFosCvE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y0i4oP9KqvGVOu0V6bDF+U8YU2Frww/dZyP/Iy/6Zt/N593zE87BIbCfq4JMXjvkOxPYH46I+PRA73QQWBVoLoA8Lk7G5djm+PcApwWlQkOmJAKzKQRDN+sOCTMITLXdbF4DhLJfaiLBHw5FoEyljcbz5G+2pYntzzL98256IrI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=JLRlkrrx; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="JLRlkrrx"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60T54VKg1280539;
	Wed, 28 Jan 2026 22:08:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=PwZEvnYOgds1PZqVjfRYj8H25Gq8Yw8Vg1t44V6DdYE=; b=
	JLRlkrrxRqYTBE6mTxWM7RmgeuNenlvwGNE9IU/4xo3x+fLSbyNs7YbpTPa2GJBa
	A0SIiZjN4mI7hVfDQiYPon1dYA/aBMBoUJyrp5fOtHxgtLLnErz2SxObYfaGpWW3
	uZmthr4JFAuXZ1gnyYeiIXkwSvZnBeTsYEBNPK0prETIp6hmyMI+EVF9KQzPAZf/
	GAccuipn7Vd3272rSjeOhZ8/AXF0gpwnmF3O2lznaAi5nz9zrLTwVOM3lrapP6qm
	2zjKEhkmWSR9EARLrtfgNQFpQSWrSRYE3KcN3l6bd1kJPHj9hy6uk7EqP+NK72oT
	NQJinoac6qMKqaCoFOn6Mw==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010007.outbound.protection.outlook.com [52.101.61.7])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4bywwrg6et-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Jan 2026 22:08:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iShEgLGLRJf+pyg8aD/Lzb64AFgK98Pj7SQRM95oVdGwqXZML6KBP0n25tdVhRgb47DCo6NVgb0Es1rQDiWrkd0oRsmNeEqV65WgNsTUvDt56asBe04smaQpZT1b1+n3vudQjyzcVvDrwGE/C/cXEYCXaZNI+/ZFUQdrkOLefWShuNCTegxlmplI4wj2KrxL15PS/qhqZAtftvVIC4XH9umRNm4yxJJ7nC7FZ1v8r6rCVJG9Wpd/e+iT5H27Qy/cyufwBjXeaCncnRUhzmyAb6qR/Vhl3+Mt9l5W8ihRhl8UUJ82qn02g4/+1NVjHOk8vyFqi3bkXcg97G+Xcz/L3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PwZEvnYOgds1PZqVjfRYj8H25Gq8Yw8Vg1t44V6DdYE=;
 b=uy7K6E0lOaVBoRIya2S2kYM8N7p38/KHkbwiKaHPuL3t0u6tcJ2CjPojp+qk1t7n2iAWKhZFMbYCo/tYiE9vTRMyI3UQiG52ZnKvdA3eHoVFc+aNfrtLMgKWcWzra2HvTJCB8iIDwrIZ/1Bfg4X8sJdJZVVlnYOeE8iso3eShubpe/hOSnHM+Vd+um187ZYBvuNJlwLQyjmKqUbK0gBAV9VDSSN17Bg3ZLIcxs2jG2h18VvEnEgYXFZP+TB+nFljb/KRzzILUXu2rT+CSyQLhpnY8uT6xazcYFdawd8gfPdWz9DGwg4WnIOcglq9RTe+M9TEWmjn3FVJe6Lh0xA50A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DS0PR11MB7736.namprd11.prod.outlook.com (2603:10b6:8:f1::17) by
 SA2PR11MB4810.namprd11.prod.outlook.com (2603:10b6:806:116::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Thu, 29 Jan
 2026 06:08:47 +0000
Received: from DS0PR11MB7736.namprd11.prod.outlook.com
 ([fe80::f7c7:f271:a7b:7a68]) by DS0PR11MB7736.namprd11.prod.outlook.com
 ([fe80::f7c7:f271:a7b:7a68%4]) with mapi id 15.20.9564.006; Thu, 29 Jan 2026
 06:08:47 +0000
Message-ID: <c6ca990e-0d53-430e-9ae9-4eb0f79f2cdb@windriver.com>
Date: Thu, 29 Jan 2026 14:08:37 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 PATCH 1/1] crypto: caam: fix netdev memory leak in
 dpaa2_caam_probe
To: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net, leitao@debian.org,
        kuba@kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260120015524.1989458-1-jianpeng.chang.cn@windriver.com>
Content-Language: en-US
From: "Chang, Jianpeng (CN)" <Jianpeng.Chang.CN@windriver.com>
In-Reply-To: <20260120015524.1989458-1-jianpeng.chang.cn@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY4PR01CA0029.jpnprd01.prod.outlook.com
 (2603:1096:405:2bd::18) To DS0PR11MB7736.namprd11.prod.outlook.com
 (2603:10b6:8:f1::17)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7736:EE_|SA2PR11MB4810:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d3409c2-21ba-404d-4a2a-08de5efcdd8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MVY0MEhUNWRTMmxqejdsZHdIUWI1ZExrbkFQMkwyV2l4ZTlvVnpwclErVFpJ?=
 =?utf-8?B?SDluTnJxalNYYVhNRkViTTNnZWlMck9BUlU2V1pZZ2IwTzFJWUVkYjdJQU9s?=
 =?utf-8?B?M20rKzVKS2lwUEdYcXd6T2s0MGRmcWJrM0VXMnRSandhR2NReWJ0WGpuRFBV?=
 =?utf-8?B?UTJENTFZRWgvbkllNGUySUtQUXg3a3A1Y0VJTEtqeTRoRXFTZVdtb05Sc0Jk?=
 =?utf-8?B?VXFzQzV3NDBsYm1TTCsyWmwxY1ZSQXo2TU04cDRXOFpEMW00SS9WNlBpdzZk?=
 =?utf-8?B?ODB2QThWZjJheEdydWRiOVhMRzhNTFBGb1JFVWcwYVhPUWlyb1ZqWXlkZmxB?=
 =?utf-8?B?bE9rWUFibXd6SHZOYXB4cHNSNExBa3BhNlRDZEtFbG5WQThacUlxU2Y0eTRC?=
 =?utf-8?B?aHBjNk5hUVRHYnpzZFVxVWcrblBTODFVOGlnWXBLMWxDL28wOUIvWTlIRVV1?=
 =?utf-8?B?RmpuWXc3a1poNU9xSnMxY3o2L0g4SjJFU3ZBS21OdlRNcHpQZUdWYzhUbzV6?=
 =?utf-8?B?NDhQNk9XaFBiM2N2L0ZoYXF2WkZYdUV0S0ZzSkh6Tkp2MEt2SzVmOW1vTjRv?=
 =?utf-8?B?ZEVTdlRZUTlTUlRCMEl1ZW1iL1BzRDJlQ3FxRkduWnZWUkJTVlFodU02M3Zi?=
 =?utf-8?B?WFRYczhkOHRjRDJ1T2FJdzczZEQyaHpiRkZMU1NIRG0rNXpFWlRUWmg3NHBT?=
 =?utf-8?B?U0xyMjVUNWRCSjdxckhyY25qdGZxQWIyZ0Y5S0ppSjllWk5hZXlVNW4zcy9F?=
 =?utf-8?B?VVFmSmg2Ny8xVHl0ZXNjUDBsNDRISVFJaERwdTFMWTBUVFMwWnYyQ3hqQ1Jo?=
 =?utf-8?B?WVNZdTk5TzlBYzljbFZ6cmpUSGZTRCtDOUNtc1pTRUVHYWxldWdlSFREZWtY?=
 =?utf-8?B?WkdRUnYrYlNiTDIzWUJZZktDb0JIa0t2dUZLTlN6VjBlZ2dRUTNpNnBBMUsz?=
 =?utf-8?B?ZC9HUHEwLzBGbmpsdGQ4QVJuTEI5aVFrZXRoSEtTditUQlZmK2h0ZVFRQXZD?=
 =?utf-8?B?a1UzZFdPZWJSS1JhcDRobE9aVlZXNFVVbmZRai84WFBZdUFCSWx3N3hvZisx?=
 =?utf-8?B?Ylp4TUYxYjBXN3NRRlg2V0kzYnllRjY2UU5sZWd3T0M2QVYxd3pLOFJCSGEz?=
 =?utf-8?B?K0JScFFCKzNuZ0ZPRWNBUVRZR28rT2dOQmUvYXhPK2tiRFQ4RW5xRzR0N1VU?=
 =?utf-8?B?MlhKRlE0NHhueWdjeDMxZWpONGxaeHYvSzNzT3BHZHpyeER6aDI1eExRalZW?=
 =?utf-8?B?b081ME83VlNaa1ZtUmU4K2gwcVh0UVN1aDYweEpOQWwyazJWd1VIV2ZPaVd1?=
 =?utf-8?B?UjlDaGwwU2NJZFgwdVlLZ0NHaTVoNjVtS0J0NHlQTTRhOFpLRTBTZHF3TndZ?=
 =?utf-8?B?T0RyQmxGeUdxR3BLMjMwbGs2VFZWUTNOajZkR0dWNzEzcGJkWG1YdHI5ZFJV?=
 =?utf-8?B?Mm5BM1krR1l6ZTF3T01aZXcybVFKNXFaTVJnVzRaaWpsK1FqaDlJdDlRRGNy?=
 =?utf-8?B?QUljaW50Q2xHYTl6cnFkWnBYVGtudlBrRkY0Y1NISFVROStNdU85emh0ZlYz?=
 =?utf-8?B?WTZJMnVyVmZqUUhiRFJSS01lMDFsbWpST2llajY4V21XZnIwayt2U28yNU5w?=
 =?utf-8?B?RXcxM3o5cnJ4cWVveWxvTjR3K1ltRHZ5Y2haV29RaThyS1VhK1E3QVVtZ2Zm?=
 =?utf-8?B?R3EzMloyTnlUNmtsdTBIT3FORU9tZUt5Y2ZHTFlKS0RJQ0hETjJDWmpDOFpW?=
 =?utf-8?B?S0hOUWJxNmlpR09oT21uU0RKdE44b2ZUMC9lR2xwcHBmNHpROWZyWHRDRGdM?=
 =?utf-8?B?SEJYRGI3M2cvMDh1VHMyMmFVRXoyYnBuYzQwZDR2eUprV3QvSFlxdjBidDd1?=
 =?utf-8?B?M2RSM0RiMjNGL2Q5MkJwTE9mM2FvdTVtb0RmMHRUb1FvQlFrMGNQaHNLdjY5?=
 =?utf-8?B?YThIMzRsUmR5NlRXV0tGeXlweFlEWWFiNGNQWGRCby9INkRlZUFoWlFka3N0?=
 =?utf-8?B?Ym5ydGsvY0podzI4YlU1anB5cm5DcGlyd3B3b29KR0tQSnRud1NVdFhUREtP?=
 =?utf-8?B?QWtDNlBKbWJNdXFIOFovR2d0L0hTVGpRSHo2LzJIREVUMXJBVUo4UVpyazNt?=
 =?utf-8?B?eFFxa09XdnFFc1VrZGdWbFRzK2RvclhUdnR2dlhGWDJhYTBZL21lTnNyT2Mv?=
 =?utf-8?Q?fb3ZlBA8jK5HONxeyuhG274=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7736.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z0cralBzVktRdW9tMjJFendFaFg3N1JrMFREaWxNVGljNlQzMEpHa1FIeUF2?=
 =?utf-8?B?VThVd0pTQmxkVWp0cExLb2grS3l2akhWR0dZM2kxMlZncm5laXhjOXVaOWwx?=
 =?utf-8?B?U3RyZllOc1h5Mk5ZeDNiR1pITTQ3UVN2emFCcDZLa0crSDBJVm9DQjVyRHpH?=
 =?utf-8?B?b0ZndG52ekw5VjMvNlhNcXJvUXRPSUFYeWNESDNvTWxZcTBKaTZtbG9zdnQx?=
 =?utf-8?B?K2dVbVFodTRUdnBySmdmejI2YTlIQldWTUFlZkxaQzlSbUFZWDNmVUFEVXB1?=
 =?utf-8?B?d0czc3V5V0RvaXdMQXdlL092NWFvUnUrUE8yVVdZVDRVcEQ5amFLd0tRMHE0?=
 =?utf-8?B?elVXWm9nR1hBV3lKb29vWWNsdWhpUUNjL1lmdWZnRXdpUEo0Y2xtaU9JdkJy?=
 =?utf-8?B?c29QMDAwZGVmK3RPWWZpc0IwLzBuYUU1L2lJUnFTbktaV0QrclE2U0NPRUVL?=
 =?utf-8?B?NEZpRlBXVGpYaTVTeFhodFFoaUppWHFmL3dRY0EzSDR5RnVuTHhrdFNzeUVN?=
 =?utf-8?B?MXRibk52WDFZbm11M2ZIWUUyV1NJQW5jQk04RTJYTHlDUXM5cEdxT2NVWWlX?=
 =?utf-8?B?N0NiSjRLWVllZDZaY2hUaUZuZVMxTUcvM2lOcWR4NFBPaUI0WmhwTWF6dWI0?=
 =?utf-8?B?MG5DOC9Ha2lNaTlhUDBZcHNNYkx0MUI2ZUFGZFZkZkY3SzhhSGVpWTJ2WTha?=
 =?utf-8?B?MG9naTJHcTIydkRKL1hkZjQ5aENRN3dmTEFXWmR1R0VTNkVaRit0dWZiYXBS?=
 =?utf-8?B?RDJxdk84anFkS2FZYmp6eVQ1UHhlUzZicDBRdW5XYTBBQlUydml2RUl2VVVO?=
 =?utf-8?B?dThDaUNweEh4MGYvcGtTUWZ5RGQyUjliMnVNNm9rV3VEWDdrdE8wUFRnN1lC?=
 =?utf-8?B?L0lVRVZvOVZua1FvaUdUQklvTWhLaytHb2VrUzNhTU5qeTB6MDk1R05tTS9N?=
 =?utf-8?B?ZjZhekhSRVhESmd3VlhsbXdhOXV3UlR3clNKY0FPQkJKMjVqV2RzRFM0OFZu?=
 =?utf-8?B?YjVDM3hEeFlQTEpud21UcVlZZDl0dlc1ajlhTXNkc1VtQUc0bTVVbkhEQk56?=
 =?utf-8?B?eU9hS1JuTTRsSUF5eDdXVitHS2V0a2RBeGdFZUIyMUtZOE4rbGRTdlo3ZE5F?=
 =?utf-8?B?OHNiVnpUZmxFdlJmcldiMEtuOWRnUGVOSG11emF6MGlxL0tuWTMxWkF5Y1BR?=
 =?utf-8?B?ZEtpUVRNYVQ4SGdXSndaS2ZVVU5hZWhSSllTVkpyQmFqaGZPNmpmNG1nanRO?=
 =?utf-8?B?bi9YQVVNbHk3QU5ZR3FuNmNmcTBXT0hjU2p6OU5lbVRPZjBoTmNabTBJSlJn?=
 =?utf-8?B?bFpWa0g0b0xwZzNnRXBwQ0IzNW9EdUJmNUsyMlRwdFg3U2lIT3IzVHl2THRl?=
 =?utf-8?B?WkZFM1Bzem9GVlg2U0NKWHRjWlR1UXR5UHhqRjNMTzdrQXV2a3FZRDh3a2RX?=
 =?utf-8?B?dVRWVVhtVVNHRUJWVDlBOUF4aWVwU1lYcmJuZjZWSTRmQVJ0MkticnFYdStB?=
 =?utf-8?B?c3RCT1dkV3ZrcTg1Wjg0Ny8reW9RWWhMUTgxVHZLNVVwTTh5cnQrL1FENFpW?=
 =?utf-8?B?R0pwV0FhVytPZmw0ZzB5WmxUMm11OUlUbXZuSFNTaUlBRE9KeU4zeEVYYklO?=
 =?utf-8?B?US9nQXpENXRtOXgrWnAyR090WXJDOFR0K0NTRzBmMFdyRFNMbWloTldMYjJw?=
 =?utf-8?B?S3l2NlRib29ta2hxZ2RLbW8weGVBRFl0b1U5U0FnSWgzaWt3N3c4TUs4QzV4?=
 =?utf-8?B?eWUvTThOL2RhRGZ4a0dMLzk3K1NVcVdlazUySnU3T2FmRS9VdXVYbHgrRmZv?=
 =?utf-8?B?WXV2VGVCaGNiVmxNQ2lUTjQ1LzVObUFGOGxQcTd6TjhaTmZLaWo1eS9ONzZW?=
 =?utf-8?B?SE5rNmg0QXhQVUEwb2VPdGZtRFJpMlkxQXBPN2Z6Q0VxVFpFYU1PVGQ5MnV0?=
 =?utf-8?B?MDVQbUVjV0JRMEVSeFAwbUl3dTdXd1l1SE41MlROOHdiUkhCYmIwb3FwbXl5?=
 =?utf-8?B?MllIcCswcnh6SlZKdTgyMVZyNVl5Z0FCcjNnN05XUlBFb3FLVzIrRlJWWjlV?=
 =?utf-8?B?OWRJeERTc0lSNk8vNjBZcDRpUXh2VWRxWjBGWnBja1pnazJMRzFlcFJVdjFn?=
 =?utf-8?B?OVdqbTE2RXVvZi9WSnMxVUQvbWxtMERiV0dkRXRoQVg1RFhhek1pYUx1Zlo4?=
 =?utf-8?B?d1JUOGhPM3JyZ3p0ejVuRi8ydk1LSU84QXRjNDlxZjJhamhMR2hJbHhqRFo4?=
 =?utf-8?B?ZmM5a1o2Ty8xNk1zRDQ5RlczMkNRc1VmQ0RXaDZwWDhUWVlsWGdRYm93SW1Y?=
 =?utf-8?B?L0REQVNyV2JBU0daQ1BDMUVkeWQvMVRlY1RZMTAycW15U2pmWlpiQVVPbVBj?=
 =?utf-8?Q?vBAZkQBuiTUApYkk=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d3409c2-21ba-404d-4a2a-08de5efcdd8a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7736.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 06:08:47.6448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wFtSn/hokUeml7+qbQ+kkYSqdhUktwpZcKXtVSVoQLTO/ebW76et6aXRia0JU0SnSKdhBtuPMRgV7ykxONbIRp8ew4WlVYZo9+DfNI6GPm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4810
X-Proofpoint-ORIG-GUID: QDxmJp2WBc4S2SXq7htJrXKO04Xbkg0S
X-Authority-Analysis: v=2.4 cv=KMVXzVFo c=1 sm=1 tr=0 ts=697af972 cx=c_pps
 a=jRvQvoFr2LhS1HEjeZSEyQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8
 a=JsD9d7vnUduF5mTwcQIA:9 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDAzNiBTYWx0ZWRfX7I0fVTg4MNCc
 Zm8CE4/0ep4yghXvlE65FmJpnEfyTTDqunrOk5UlBaIGoc4ZqTJHP3ibBhvujyB+85yCsoKB2+Q
 DLq10To0+/+JMKs/CfIi08Si+Qfcx4R3pscvyoZyYJsw6fM+DplHMvYiTgGFJ4m6ccGlAMa7VPI
 RoVk56z4XEccSRr4V6QkASZys2rHJga1AlPT3uhMS2iJr9AShGNXVG+Ko66MgADkJWqmJlMWLIc
 kZscThEP1YTcP2K1iYzkmGddJcz2p0N4CMHUzxJ8AUXhTyjShXAa0e4VwCmbHsZ0JT8OXtKp0Qg
 hjxLf41xGPXOBsQLg6PW7mUzOyOCNBcOYyZE/q76cAlQIfPuYeInwuoOt8X6nRK4L9Fw2r43Ge7
 VdqDoDHJ+q4jTmS0/KG5y7cnJ/ZKqDMpi2NlVEXhO8SsikukUcikguoPWSs1ELpDIaD7oTQByaW
 g67WpyMIId8YIhrUZbA==
X-Proofpoint-GUID: QDxmJp2WBc4S2SXq7htJrXKO04Xbkg0S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-28_06,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 clxscore=1015
 spamscore=0 adultscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601290036

Gentle ping, any comments on this patch?

Thanks,
Jianpeng

On 1/20/2026 9:55 AM, Jianpeng Chang wrote:
> When commit 0e1a4d427f58 ("crypto: caam: Unembed net_dev structure in
> dpaa2") converted embedded net_device to dynamically allocated pointers,
> it added cleanup in dpaa2_dpseci_disable() but missed adding cleanup in
> dpaa2_dpseci_free() for error paths.
> 
> This causes memory leaks when dpaa2_dpseci_dpio_setup() fails during probe
> due to DPIO devices not being ready yet. The kernel's deferred probe
> mechanism handles the retry successfully, but the netdevs allocated during
> the failed probe attempt are never freed, resulting in kmemleak reports
> showing multiple leaked netdev-related allocations all traced back to
> dpaa2_caam_probe().
> 
> Fix this by preserving the CPU mask of allocated netdevs during setup and
> using it for cleanup in dpaa2_dpseci_free(). This approach ensures that
> only the CPUs that actually had netdevs allocated will be cleaned up,
> avoiding potential issues with CPU hotplug scenarios.
> 
> Fixes: 0e1a4d427f58 ("crypto: caam: Unembed net_dev structure in dpaa2")
> Signed-off-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
> ---
> v2:
>    - fix the build error with CPUMASK_OFFSTACK disabled
>    - instead of the movement of free_dpaa2_pcpu_netdev, implement it
>      directly in dpaa2_dpseci_free
> v1: https://lore.kernel.org/all/20260116014455.2575351-1-jianpeng.chang.cn@windriver.com/
> 
>   drivers/crypto/caam/caamalg_qi2.c | 27 +++++++++++++++------------
>   drivers/crypto/caam/caamalg_qi2.h |  2 ++
>   2 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
> index 107ccb2ade42..c6117c23eb25 100644
> --- a/drivers/crypto/caam/caamalg_qi2.c
> +++ b/drivers/crypto/caam/caamalg_qi2.c
> @@ -4814,7 +4814,8 @@ static void dpaa2_dpseci_free(struct dpaa2_caam_priv *priv)
>   {
>   	struct device *dev = priv->dev;
>   	struct fsl_mc_device *ls_dev = to_fsl_mc_device(dev);
> -	int err;
> +	struct dpaa2_caam_priv_per_cpu *ppriv;
> +	int i, err;
>   
>   	if (DPSECI_VER(priv->major_ver, priv->minor_ver) > DPSECI_VER(5, 3)) {
>   		err = dpseci_reset(priv->mc_io, 0, ls_dev->mc_handle);
> @@ -4822,6 +4823,12 @@ static void dpaa2_dpseci_free(struct dpaa2_caam_priv *priv)
>   			dev_err(dev, "dpseci_reset() failed\n");
>   	}
>   
> +	for_each_cpu(i, priv->clean_mask) {
> +		ppriv = per_cpu_ptr(priv->ppriv, i);
> +		free_netdev(ppriv->net_dev);
> +	}
> +	free_cpumask_var(priv->clean_mask);
> +
>   	dpaa2_dpseci_congestion_free(priv);
>   	dpseci_close(priv->mc_io, 0, ls_dev->mc_handle);
>   }
> @@ -5007,16 +5014,15 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
>   	struct device *dev = &ls_dev->dev;
>   	struct dpaa2_caam_priv *priv;
>   	struct dpaa2_caam_priv_per_cpu *ppriv;
> -	cpumask_var_t clean_mask;
>   	int err, cpu;
>   	u8 i;
>   
>   	err = -ENOMEM;
> -	if (!zalloc_cpumask_var(&clean_mask, GFP_KERNEL))
> -		goto err_cpumask;
> -
>   	priv = dev_get_drvdata(dev);
>   
> +	if (!zalloc_cpumask_var(&priv->clean_mask, GFP_KERNEL))
> +		goto err_cpumask;
> +
>   	priv->dev = dev;
>   	priv->dpsec_id = ls_dev->obj_desc.id;
>   
> @@ -5118,7 +5124,7 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
>   			err = -ENOMEM;
>   			goto err_alloc_netdev;
>   		}
> -		cpumask_set_cpu(cpu, clean_mask);
> +		cpumask_set_cpu(cpu, priv->clean_mask);
>   		ppriv->net_dev->dev = *dev;
>   
>   		netif_napi_add_tx_weight(ppriv->net_dev, &ppriv->napi,
> @@ -5126,18 +5132,16 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
>   					 DPAA2_CAAM_NAPI_WEIGHT);
>   	}
>   
> -	err = 0;
> -	goto free_cpumask;
> +	return 0;
>   
>   err_alloc_netdev:
> -	free_dpaa2_pcpu_netdev(priv, clean_mask);
> +	free_dpaa2_pcpu_netdev(priv, priv->clean_mask);
>   err_get_rx_queue:
>   	dpaa2_dpseci_congestion_free(priv);
>   err_get_vers:
>   	dpseci_close(priv->mc_io, 0, ls_dev->mc_handle);
>   err_open:
> -free_cpumask:
> -	free_cpumask_var(clean_mask);
> +	free_cpumask_var(priv->clean_mask);
>   err_cpumask:
>   	return err;
>   }
> @@ -5182,7 +5186,6 @@ static int __cold dpaa2_dpseci_disable(struct dpaa2_caam_priv *priv)
>   		ppriv = per_cpu_ptr(priv->ppriv, i);
>   		napi_disable(&ppriv->napi);
>   		netif_napi_del(&ppriv->napi);
> -		free_netdev(ppriv->net_dev);
>   	}
>   
>   	return 0;
> diff --git a/drivers/crypto/caam/caamalg_qi2.h b/drivers/crypto/caam/caamalg_qi2.h
> index 61d1219a202f..8e65b4b28c7b 100644
> --- a/drivers/crypto/caam/caamalg_qi2.h
> +++ b/drivers/crypto/caam/caamalg_qi2.h
> @@ -42,6 +42,7 @@
>    * @mc_io: pointer to MC portal's I/O object
>    * @domain: IOMMU domain
>    * @ppriv: per CPU pointers to privata data
> + * @clean_mask: CPU mask of CPUs that have allocated netdevs
>    */
>   struct dpaa2_caam_priv {
>   	int dpsec_id;
> @@ -65,6 +66,7 @@ struct dpaa2_caam_priv {
>   
>   	struct dpaa2_caam_priv_per_cpu __percpu *ppriv;
>   	struct dentry *dfs_root;
> +	cpumask_var_t clean_mask;
>   };
>   
>   /**

