Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A590515855E;
	Thu, 24 Jul 2025 09:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753348973; cv=fail; b=P6+4BB1qZvTJyfKTAilcmotv0lj1bxvmQtVl8fZjFxQgFx6pwJ+9nqiL0BSJycRILllcdp9pxZdPc+I81GmPVyfcP04O2bhgI2aAkqbArASvOORT1vaEYuFLf3ZMPoL7lwWfCBaWU1sIZRnWhn4ym1y4rwuRD30mZ0dQ9JuYBcs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753348973; c=relaxed/simple;
	bh=fkZjYFP/6PTzz/08xVfD7Ij0Txh6gOHJVjqj9Nw6ITY=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PLGlnphSob+jCdlxQTnh/MllVdzCswcm7EootXPppg7tuvl2raeXcwkuUEkmLivMx0lIf3lrNHeQPmed/20Vtchovfw3vxe2lzalacoNtwmawsT8pmqyBEvWgs6mp+r2vVZaTMmyhXa2Nqxd8HVUQIDq4B6V1oq5OQlW/fZS6Hs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TSqLXprG; arc=fail smtp.client-ip=40.107.244.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TSqLXprG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jb6DuOZQUaRvMrChAGeDdc6wQngbn77Thyw7uMxY53ccUrFGzBESNPrw3Bd+QkapBkheDiI4BDR3Gq8emNazwD4htQYqAM5KLbrlHM+tVSwOCN/PEGkIFOb7vfIOOSXftOYnY63Fjnfjbejsj4PBBIxCUi4/DQusHtrZ9JQadAadiT6NuPOmDTYb+ITmKU/uykukk9aU6cIvntl4Imn6nethGFSSCfFP5Djg7tM3nBiZFX3H87ig9KQ1bHWaNbQNZTCKCYeZ71XBjXnaL8/EFyVRwWFjBVbHP0jVs6Ony7vNBNU7sMIXLIV/EpoxUT6GHYKvoUxEg4IS+J/onL5hXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fkZjYFP/6PTzz/08xVfD7Ij0Txh6gOHJVjqj9Nw6ITY=;
 b=OFtexP5rFyfDSpv9C+DaWAtDQSU2+Dze2G5RNKHPBB7L+5BHwJ2rQ8nBeC8M0sfCwx2GiCjJ+OFHY29DOsWI9V/mwzweflY4LLXyFlIjMyto/HA5JKnK454t4gfzxnbToswDavkUS8UnZJP23ZbBDP708oaTCl6pJ+8JNZ2yKlIgbGUKGNVznwz96hDrUnv7dCJce6AsAs8QAqibDmmv4jJQw93m74QyJbMvsYOzYBT2yPzHa1iVDU3XiEWThBkXu2xxIizT2EMkmDvDLTuqcsu54CY3DTZQlHonoMiXtkFXnFkOmQps3n/Fx/gddlJHxlg+7hlJ3uZqBudxppGOiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fkZjYFP/6PTzz/08xVfD7Ij0Txh6gOHJVjqj9Nw6ITY=;
 b=TSqLXprGM1WwDlDC2IqxeNn7w8U8g63bkDc0/z4N9Ax14/Lf9MznJq/KTZs0hJMUZCTqj8SYHnDStoGwrMsoPAMqRVeMwLe9oTqDoXKxf4xvTH8z0XTYd2Gz5XiqEctnHTGasyW1zJ+4LNJx80WbG7GNFBM79gpTdbm5tftzVEA=
Received: from DS0PR12MB9345.namprd12.prod.outlook.com (2603:10b6:8:1a9::10)
 by IA4PR12MB9763.namprd12.prod.outlook.com (2603:10b6:208:55a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Thu, 24 Jul
 2025 09:22:48 +0000
Received: from DS0PR12MB9345.namprd12.prod.outlook.com
 ([fe80::65ab:d63c:7341:edbb]) by DS0PR12MB9345.namprd12.prod.outlook.com
 ([fe80::65ab:d63c:7341:edbb%6]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 09:22:48 +0000
From: "Jain, Harsh (AECG-SSW)" <h.jain@amd.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, Krzysztof Kozlowski
	<krzk@kernel.org>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "Botcha, Mounika"
	<Mounika.Botcha@amd.com>, "Savitala, Sarat Chand"
	<sarat.chand.savitala@amd.com>, "Dhanawade, Mohan" <mohan.dhanawade@amd.com>,
	"Simek, Michal" <michal.simek@amd.com>, "smueller@chronox.de"
	<smueller@chronox.de>, "robh@kernel.org" <robh@kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>, "conor+dt@kernel.org"
	<conor+dt@kernel.org>
Subject: RE: [PATCH v4 1/3] dt-bindings: crypto: Add node for True Random
 Number Generator
Thread-Topic: [PATCH v4 1/3] dt-bindings: crypto: Add node for True Random
 Number Generator
Thread-Index: AQHb+/7BMgSKAU2by0u5lD59rEtzcLRA3zkAgAALI+CAAAH4AIAAE9Mg
Date: Thu, 24 Jul 2025 09:22:47 +0000
Message-ID:
 <DS0PR12MB93451B76213509A5D0A15685975EA@DS0PR12MB9345.namprd12.prod.outlook.com>
References: <20250723182110.249547-1-h.jain@amd.com>
 <20250723182110.249547-2-h.jain@amd.com>
 <a350e9b6-9bbe-4045-8d9c-e3886b758a99@kernel.org>
 <DS0PR12MB9345EDA907BB0438C32EF12F975EA@DS0PR12MB9345.namprd12.prod.outlook.com>
 <ab0294da-1ae3-434c-aa37-75532e538e56@linaro.org>
In-Reply-To: <ab0294da-1ae3-434c-aa37-75532e538e56@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=True;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2025-07-24T09:19:35.0000000Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=3;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR12MB9345:EE_|IA4PR12MB9763:EE_
x-ms-office365-filtering-correlation-id: 8f1bbc32-c5d6-45d8-f183-08ddca93a7cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018|921020;
x-microsoft-antispam-message-info:
 =?utf-8?B?ODZKOVdPa3hFbXFnRWZqYUdtSHVtK1NWRUYyN0tWWXp6YThkSWt0VTZxUGRM?=
 =?utf-8?B?a0FVWUJFdy9QNXZsYUU4VTlNSnl2VFdUNEdDdnQ4Z003Znk1Znp4S3J0NWdk?=
 =?utf-8?B?WWJrU1c0ZkViVEdxV2xFMjFOcGpGWEticEsvSDZ3cVo0enhFOGNhZUlWWnVG?=
 =?utf-8?B?QmxNM0RqS29CdHAvTkxLSnBTSjd4NW5CeDh6cUgvUHVYNVdXRHp3UkVKZ0Vy?=
 =?utf-8?B?YUpZeTlocGR3aEZrbzJucXNmc3dERlRSWFAzS1UybVBGcVQ3NFVDbHRSd0M1?=
 =?utf-8?B?SXQ5NnhRVHNncVg2MjZzSXVrRUdSdE1nZTYyOERjbVE0Q2JIV0hoQTlmVVhm?=
 =?utf-8?B?cDl4bitkaTBhNTRMOWJxL1M2ZDZCRjNWVTBDU0x4b09DRTlITFZuSDZJMzEv?=
 =?utf-8?B?VFBISHRQUHdpTXFuY3lxV0pQaHJJSDl4WFVkb2NNcEpZVmxoTTlUWVdmRmZ0?=
 =?utf-8?B?R0xHNCtwcU80OE5SR1FNZWdMYjU2U1NCSW9oMG1lYkkyVCt6UFlsUWJzZCs4?=
 =?utf-8?B?MXM3a080OTYxMVVhZE9ZbjFyOHpHaC9vMDg1QVllSkYxOFVKY3BuL2dRYjZB?=
 =?utf-8?B?azZVTytOZy91aG9KSnJNdXhDNHQ2MFE2UkhWYy9TdHUzY3VuTm4ydzVOWDJy?=
 =?utf-8?B?L3A1UXMzbHlMamEwWFpJUDMyNnpyNmRidmtxUkxQc1V5RUhpN1d2aEZGaG51?=
 =?utf-8?B?MU9qTm43YU5IbHlXV3g5Ym9UQlRZNjR4RGtCQTJOdzBKTFB3RFIwMmlzTmFy?=
 =?utf-8?B?UElGMm80UmplUDFuUUpTSDZVSUFPMVM3eEJ3Y3RwTjFqa2ZhUXZ4Zy9qbEVa?=
 =?utf-8?B?d25ITUJhemM2VVVYejJlR2NVemdCUXJLck03MFU3UXBSMGFzalo0eU9JVGFP?=
 =?utf-8?B?S3ZGK29yMVpRY3Nya2lWVHN1bktBVUJoL1BjRlgxL3NSUndEd2daeEVQMjRU?=
 =?utf-8?B?SkhPUlgvMlAraHJERkFSRitwbW9GN01uNWs5UHVQNk96QzBWVWYyUHN5Nmww?=
 =?utf-8?B?WkIwT3dWOHA1M29MS2VaTE5VWVcrZkExR3YwZG93NE1tZ3VUWE0zZEI5cWhD?=
 =?utf-8?B?ME9Id1VkTHFYQjJYaEk1Y3R2TmdUZXpVbjR1cGJTWWM2ZzhOUE5DN1JoZEE5?=
 =?utf-8?B?UlJDVlRvbFZGYWNiVDBaRlRsL2FObWJ6NllucDYrLzg1N0FWdnJVcXdIUU93?=
 =?utf-8?B?d1BxUUQvd1dycURuTWY2MzR1WklFZTdLL3RqekU1NWM5NnJXQU02UUZHRFpT?=
 =?utf-8?B?aVpCdm5FVTFpSXIyaW9ISCswNkk5di9yZ2JIV0RJVGtXWmpSRDE0Q1ZOeGpN?=
 =?utf-8?B?U08zRU5ZNTJjT0UzWFJkbkZpR3hsQnZNOHBzZ1U3TTdRUGRNTGw5Q0FXdURs?=
 =?utf-8?B?S0lFTmFudCt2b3NoUEhqUlRQSHU3YWJVdXJhYmkwQmZIdDN5NTFtNm5aR2Fk?=
 =?utf-8?B?eEZ2U0oxTVBOYm1MbnB0VWR5Y2o1dFVlbWk1WXdZUWJXZDRpVFI3TUcrRERu?=
 =?utf-8?B?TWtkRjY4YUFXZzgxdVN6aGkwdHlkSEtwUStNNGZ2bllBTFhtN0k4cjJ4bzhG?=
 =?utf-8?B?Rk43T2lOTHhXWTlmQWJoTFBHZS85Nm9OZ2VidjBpRytzSldNdTdNY216aVBl?=
 =?utf-8?B?VmdFaXZlRXFyZzhrR2pma0k2dzdIVk4xLzVVSE1zZVNsMTNteFVXK25DaTU1?=
 =?utf-8?B?OGtEeUN3WTd2cHNyL0JJOFcrdlViVXFodzRGWG15UDJudDBoTTlPd1pjQlRZ?=
 =?utf-8?B?cHo2aE1QbzJ5bjlKU3dJdTV4SFZYQVVkQ051RWFpS3JwMXdMMXBLSzlsS2lL?=
 =?utf-8?B?NEw0UnlzclRndTFqazAzbDJsTy9FOTZaSXJZWHZLc1Z2U1RhYWJkYTd4YTFX?=
 =?utf-8?B?YWdKQ1VtRHJVZmdsaGZ5S1ZOdGJKV3A3d3JvVXBkWmFLTmdFbjVBTWpaM3Uw?=
 =?utf-8?B?ZXNVbmJEVjhEUysyZ1lKYThVRVE2YmZXMEVEWCswd1VDWXdBUUxRMXlEYnBX?=
 =?utf-8?B?aUlnMExHUUNRT01jZjVxUWJVVmR6K3FPcWM5S0dzTEExRitvTTVRdjVHU0Rw?=
 =?utf-8?Q?VO6NcZ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB9345.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RFdFWk5nUnBlaVl0cnhNSVJnc2tNZUY2TElHOThiL3pMUnNzaEc0Y1phYWJh?=
 =?utf-8?B?cmhRcVA2M0xoZyt5MVhXM3VaOUhiTllkNkJDZ296aGdWVnM0MlN5eEFXNEF0?=
 =?utf-8?B?NmZVWUZSelNvMHRKcGkrdk5hS1VyclJNWEE2d0ZvOHlOTU02eStZYXo5Z1ds?=
 =?utf-8?B?eFMzYUJjS21aU2ZSOU5yNzU5U1ZCZTZ3UHh1UFRZaGxCWlplVnVBalV0OVZT?=
 =?utf-8?B?SzVma1ZiSHJ0Mms2Qis5RWZ0Mk9VdzN2RG9WZ1Y4SmdmL0xZVFgvVVlQY2py?=
 =?utf-8?B?VUJXelAwOW5MZ2pnbnJjMTZqWjYyRDdUYnltQ2lrLzJROTVqalpHbzByRVQ2?=
 =?utf-8?B?bVJucytqaWFDUkF6N2F3b0xuUm5GRThKQk14RkJlSlpJUFV4S2pwUWIvWUJk?=
 =?utf-8?B?cVZNQzlWaks3K3JST0pnTFpvWmxmamVieWxXM3JSVnZHSUtEMzBra09pM1pC?=
 =?utf-8?B?TjcvZElTUzBKalBDMEJPQjJmeXhwbXJuVS83OGU4dDhTeVh0MmZPODNXN1RO?=
 =?utf-8?B?VWZXSDRMZys0eklwWkFTVTNndEtsUDI1UUltVVBrS0Q2elVFOHUvNHJWSDcy?=
 =?utf-8?B?eW0xcUdncDI3U2xVSC9ucmFLZnZpTFBIYUxJRVAzNTJJNTdMOFBGUkhqb3lj?=
 =?utf-8?B?WCtZQ3pWSElCaXBiWW9aVG85NkpqOTVIL09SdGt5RVgrcGFXTUYzSVRKMDV6?=
 =?utf-8?B?WDZQNjhnaFlHalFrR3pjZW9QNVBLUUR5N1NreWNpL2xicnNRUHpUMGZZcmk3?=
 =?utf-8?B?a0VBYmlTbTJhNDlzeVZENFVRZmRIVmdwYWdaWkh0UEUwWXNUREFVbFYzbVRR?=
 =?utf-8?B?bklwYlMxMzk5cjd2R2Q4N2RPK0gvS3F2eXRVYTBOQzJNRTFTUjlkcXdtcXQr?=
 =?utf-8?B?NkN3M1NtSDg3TVlrQzhiYkxJaXpCa0JPQVlMQ0ZQN1JNYlhTOGtoV0NhSVAx?=
 =?utf-8?B?RUs4Q0w3OXUvVTVOSWJ5Uitxd3lidEhhVllkWjBDRWZpaEwyM0VaYkVHQTA0?=
 =?utf-8?B?WThiUWNlcjVFck1JcEZpUmRoM0NhUmNYVmZXa0tnemNocGZjZ20yZ1V2MGp4?=
 =?utf-8?B?dE5tRlREMGdNRkhDT2QxdFVHY1lMWSt4QnRCd09VcGVwU0FubjZNQnBOazM4?=
 =?utf-8?B?dHYxWktQK2I1cU5TL0RiaUcyTWpvK1dNU1lqWHQrVmVJYjM4Wk92OUtqN1E0?=
 =?utf-8?B?N2NvWWJmQUN2bE1NRm9uSmFaQnJKS2wwNzdwQ2NnZmhLeDBUWDFQNXdGbGFD?=
 =?utf-8?B?STliWEdJS2p1T1NoNnhHSTMwUk0zOWxXRG9NVXhXRWE0dWpzNDdFVXZ5ZllO?=
 =?utf-8?B?RzVtc1JUY0YvYlppTTlVMERqcE94KzlnYmdaVHFJZ1g4MGRTYi82SVBxYmxB?=
 =?utf-8?B?c1p2R3BPM2ZwakJJQUpTZWtUejFVNVRnemhQaklhWmJEMmQrUllZbWkwaDdI?=
 =?utf-8?B?NjFMUU0zdzJvUnFZK3ExTTZ2NkFHZ2F2Mnl1Q09DUm5LTTZPY0JCMHZ1V2FP?=
 =?utf-8?B?TjBQT3VLdEsyTVorN281VlJUZThna3E1anRWUXlFVWViVkZYNWRCOU1OUUVJ?=
 =?utf-8?B?c3ZMT2thNWo2bC9YK1dUYnFoZjNrYlZZaUtJaWFKa3VCN05La056Qzd5NzhD?=
 =?utf-8?B?d053RUtYcUIvODJGLzdOc09LZjZET1VGdHNwbC9UdDVKT0t2L3ZnUDFKeWl3?=
 =?utf-8?B?MHhGM25IcXZJL2NDQ2swMkZKOXljdU9hSURIL1hQb1NXRmgwNExyZlZTVGhv?=
 =?utf-8?B?d3AyMUVOS2FFNjhUd2NLYnlQZTQ0RU92OUQ0WlI4NmtWTTF2cjZobEgzL3pq?=
 =?utf-8?B?eVNsSXRWOUtWUGlWRWNSeVhTUnVtZWI5MjFWdW5TK1RwazJyWHcvOURMMzNM?=
 =?utf-8?B?YlV0SmlHallCZm1WZEhxTHkrUzVrUU9laUttRWl2VCs4S3ZQcDY5NU5Nb3BW?=
 =?utf-8?B?U1VLajRQbjhRRnFOaUtJTjVtL0RYTGU3YlRjaEdUOU5ZSkV4VmFsZmFmYVA2?=
 =?utf-8?B?OFlXZ1dDUENvejV6SHh1Q3FGbmxrckE5aEVkZU1KN240OHZlMWIrdWVDZUg2?=
 =?utf-8?B?dG1rZFZJZzRKMTVPbUh3MzExaTVzMlVoRDUvMVVBclpIZG1mRjg3RGhiM3dW?=
 =?utf-8?Q?jqxI=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f1bbc32-c5d6-45d8-f183-08ddca93a7cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2025 09:22:48.0153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AvRGvHUT5SBpWk8Q6/IzJLPTaCAi9Fw/1TSWwvtRFf3+qGKKyFYb68lAHimWaT7H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9763

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEFNRCBJbnRlcm5hbCBEaXN0cmlidXRpb24gT25seV0N
Cg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBLcnp5c3p0b2YgS296bG93
c2tpIDxrcnp5c3p0b2Yua296bG93c2tpQGxpbmFyby5vcmc+DQo+IFNlbnQ6IFRodXJzZGF5LCBK
dWx5IDI0LCAyMDI1IDE6MzkgUE0NCj4gVG86IEphaW4sIEhhcnNoIChBRUNHLVNTVykgPGguamFp
bkBhbWQuY29tPjsgS3J6eXN6dG9mIEtvemxvd3NraQ0KPiA8a3J6a0BrZXJuZWwub3JnPjsgaGVy
YmVydEBnb25kb3IuYXBhbmEub3JnLmF1OyBkYXZlbUBkYXZlbWxvZnQubmV0OyBsaW51eC0NCj4g
Y3J5cHRvQHZnZXIua2VybmVsLm9yZzsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IEJvdGNo
YSwgTW91bmlrYQ0KPiA8TW91bmlrYS5Cb3RjaGFAYW1kLmNvbT47IFNhdml0YWxhLCBTYXJhdCBD
aGFuZA0KPiA8c2FyYXQuY2hhbmQuc2F2aXRhbGFAYW1kLmNvbT47IERoYW5hd2FkZSwgTW9oYW4N
Cj4gPG1vaGFuLmRoYW5hd2FkZUBhbWQuY29tPjsgU2ltZWssIE1pY2hhbCA8bWljaGFsLnNpbWVr
QGFtZC5jb20+Ow0KPiBzbXVlbGxlckBjaHJvbm94LmRlOyByb2JoQGtlcm5lbC5vcmc7IGtyemsr
ZHRAa2VybmVsLm9yZzsgY29ub3IrZHRAa2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IHY0IDEvM10gZHQtYmluZGluZ3M6IGNyeXB0bzogQWRkIG5vZGUgZm9yIFRydWUgUmFuZG9tDQo+
IE51bWJlciBHZW5lcmF0b3INCj4NCj4gQ2F1dGlvbjogVGhpcyBtZXNzYWdlIG9yaWdpbmF0ZWQg
ZnJvbSBhbiBFeHRlcm5hbCBTb3VyY2UuIFVzZSBwcm9wZXIgY2F1dGlvbg0KPiB3aGVuIG9wZW5p
bmcgYXR0YWNobWVudHMsIGNsaWNraW5nIGxpbmtzLCBvciByZXNwb25kaW5nLg0KPg0KPg0KPiBP
biAyNC8wNy8yMDI1IDEwOjA0LCBKYWluLCBIYXJzaCAoQUVDRy1TU1cpIHdyb3RlOg0KPiA+IFtB
TUQgT2ZmaWNpYWwgVXNlIE9ubHkgLSBBTUQgSW50ZXJuYWwgRGlzdHJpYnV0aW9uIE9ubHldDQo+
ID4NCj4gPj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPj4gRnJvbTogS3J6eXN6dG9m
IEtvemxvd3NraSA8a3J6a0BrZXJuZWwub3JnPg0KPiA+PiBTZW50OiBUaHVyc2RheSwgSnVseSAy
NCwgMjAyNSAxMjo1MiBQTQ0KPiA+PiBUbzogSmFpbiwgSGFyc2ggKEFFQ0ctU1NXKSA8aC5qYWlu
QGFtZC5jb20+Ow0KPiBoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU7DQo+ID4+IGRhdmVtQGRh
dmVtbG9mdC5uZXQ7IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7DQo+IGRldmljZXRyZWVA
dmdlci5rZXJuZWwub3JnOw0KPiA+PiBCb3RjaGEsIE1vdW5pa2EgPE1vdW5pa2EuQm90Y2hhQGFt
ZC5jb20+OyBTYXZpdGFsYSwgU2FyYXQgQ2hhbmQNCj4gPj4gPHNhcmF0LmNoYW5kLnNhdml0YWxh
QGFtZC5jb20+OyBEaGFuYXdhZGUsIE1vaGFuDQo+ID4+IDxtb2hhbi5kaGFuYXdhZGVAYW1kLmNv
bT47IFNpbWVrLCBNaWNoYWwgPG1pY2hhbC5zaW1la0BhbWQuY29tPjsNCj4gPj4gc211ZWxsZXJA
Y2hyb25veC5kZTsgcm9iaEBrZXJuZWwub3JnOyBrcnprK2R0QGtlcm5lbC5vcmc7DQo+IGNvbm9y
K2R0QGtlcm5lbC5vcmcNCj4gPj4gQ2M6IEtyenlzenRvZiBLb3psb3dza2kgPGtyenlzenRvZi5r
b3psb3dza2lAbGluYXJvLm9yZz4NCj4gPj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NCAxLzNdIGR0
LWJpbmRpbmdzOiBjcnlwdG86IEFkZCBub2RlIGZvciBUcnVlIFJhbmRvbQ0KPiA+PiBOdW1iZXIg
R2VuZXJhdG9yDQo+ID4+DQo+ID4+IENhdXRpb246IFRoaXMgbWVzc2FnZSBvcmlnaW5hdGVkIGZy
b20gYW4gRXh0ZXJuYWwgU291cmNlLiBVc2UgcHJvcGVyIGNhdXRpb24NCj4gPj4gd2hlbiBvcGVu
aW5nIGF0dGFjaG1lbnRzLCBjbGlja2luZyBsaW5rcywgb3IgcmVzcG9uZGluZy4NCj4gPj4NCj4g
Pj4NCj4gPj4gT24gMjMvMDcvMjAyNSAyMDoyMSwgSGFyc2ggSmFpbiB3cm90ZToNCj4gPj4+IEZy
b206IE1vdW5pa2EgQm90Y2hhIDxtb3VuaWthLmJvdGNoYUBhbWQuY29tPg0KPiA+Pj4NCj4gPj4+
IEFkZCBUUk5HIG5vZGUgY29tcGF0aWJsZSBzdHJpbmcgYW5kIHJlZyBwcm9wZXJpdGllcy4NCj4g
Pj4+DQo+ID4+PiBSZXZpZXdlZC1ieTogS3J6eXN6dG9mIEtvemxvd3NraSA8a3J6eXN6dG9mLmtv
emxvd3NraUBsaW5hcm8ub3JnPg0KPiA+Pg0KPiA+PiBXaHkgZGlkIHlvdSBwbGFjZWQgbXkgdGFn
IGhlcmU/DQo+ID4NCj4gPiBZb3Ugc2hhcmVkIFJldmlld2VkLWJ5IG9uIHYzLiBJdOKAmXMgdGhl
IHNhbWUgcGF0Y2guIElzbid0IEkgYW0gc3VwcG9zZWQgdG8gYWRkIGl0DQo+IGluIHN1YnNlcXVl
bnQgcGF0Y2hlcyBpZiB0aGVyZSBpcyBub3QgY2hhbmdlPw0KPiA+DQo+ID4gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGludXgtY3J5cHRvLzIwMjUwNjE3LXJhdGlvbmFsLWJlbmlnbi13b29kcGVj
a2VyLQ0KPiA2ZWUzMWFAa3Vva2EvDQo+DQo+IEFuZCB3aG8gc2VudCB0aGUgcGF0Y2g/IFdobyBy
ZWNlaXZlZCB0aGUgdGFnPyBXaHkgdGhlIHRhZyBpcyBhYm92ZQ0KPiBleGlzdGluZyBTb0IgY2hh
aW4/DQoNCllvdSBtZWFucyB0byBzYXkgb3JkZXIgb2YgdGFncyBzaG91bGQgYmUNCg0KU2lnbmVk
LW9mZi1ieTogTW91bmlrYSBCb3RjaGEgPG1vdW5pa2EuYm90Y2hhQGFtZC5jb20+DQpTaWduZWQt
b2ZmLWJ5OiBIYXJzaCBKYWluIDxoLmphaW5AYW1kLmNvbT4NClJldmlld2VkLWJ5OiBLcnp5c3p0
b2YgS296bG93c2tpIDxrcnp5c3p0b2Yua296bG93c2tpQGxpbmFyby5vcmc+DQoNCj4NCj4gPg0K
PiA+Pg0KPiA+Pj4gU2lnbmVkLW9mZi1ieTogTW91bmlrYSBCb3RjaGEgPG1vdW5pa2EuYm90Y2hh
QGFtZC5jb20+DQo+ID4+PiBTaWduZWQtb2ZmLWJ5OiBIYXJzaCBKYWluIDxoLmphaW5AYW1kLmNv
bT4NCj4gPj4NCj4gPj4gV2hvIHJlY2VpdmVkIHRoZSB0YWc/IFdoZW4gd2FzIHRoZSBwYXRjaCBw
cmVwYXJlZD8NCj4gPg0KPiA+IERpZCBJIG1pc3NlZCBzb21ldGhpbmcgaGVyZT8NCj4NCj4gWWVz
LCB1c2luZyBzdGFuZGFyZCB0b29scyBmb3IgdGhlIGpvYiAtIGI0IC0gIG9yIGZvbGxvd2luZyB0
aGUgcHJvY2Vzcw0KPiBpZiB5b3UgZG8gbm90IHdhbnQgdG8gdXNlIHRoZSB0b29scy4NCj4NCj4g
QmVzdCByZWdhcmRzLA0KPiBLcnp5c3p0b2YNCg==
