Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012023.outbound.protection.outlook.com [52.101.48.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833B8320A14
	for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 14:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769784674; cv=fail; b=SpQvEYEt6g5BgBfraqAJU8N5mVu63qJoLeICltQWqE4fapDmBP/i6iraDaz+yNY6A5XNV+G8pC06L4sVLKJ7hdQl8KOLCxBGpy8gB6+k1kZadtAWfc0EoQI8Psoh3pzdfCPJf1dSRSVqYW7qVfogT0E36oIZrSzjaO4z6B7SWuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769784674; c=relaxed/simple;
	bh=TJKn9H2l868ewCIAKCc4Clug7T8Gw01teyVxxaCTNZU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qfUemWnuoi7Bhkb4zFtA8mQHsTGsSnoEwEk2AlviO8bpIxDT2rISqI2rUVcpdUyJPqiVjRVdDY+H+wYMNiocG8Jjd6QY54SkR8hcFt0n1g3TWlLfkuGs11oDo2GOYqkxyS/uCYFQtH4Pf6+FYJdwLPMZGRxhjNdiMYJ9g15FhUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=NhluFFbi; arc=fail smtp.client-ip=52.101.48.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="NhluFFbi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S5oiNCAeWeXvjlvikbsxAK8UYsXg1+Tj5bLCeojws+J/D139xboMEf4ty3bJl7mIKh3oTgAMN47V7UrEUoIdxnPTWv1GjOTTctv+9DX68YjG88hQ5ecDAW1Vjjs7EaWMaPwLtTtBHfz90Ij1LzYH4VEdnWULDpFGTrO21epI5FDfWcMLX+qGYQqQRwVv4EbXJ9/RtuvA4nB57G/q8QpKQGjlLBsWc+5k8d4KJ6i3R/xB2sCQXHb09JlemfRBSdqovLh0Ulpkt/PFBozUIM12swuhJ/a/qmTT8ZEQRfqX5TpaNaYUxzSb3IegKKwVSH3yYpjrOqYBMjQAhOYLLGaTtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJKn9H2l868ewCIAKCc4Clug7T8Gw01teyVxxaCTNZU=;
 b=Ib+1M4qZ+mzbR/3OC5pFMu4CYQFQn+3FPXUvg8f6jYIgFJz2pPWJXdO4OkN0aJZ7CxtH8r7nj3IftSuCBFF2Nc3jcaCbsin0HlmzjfyOyb+9NfUn2h50BZfJddY7IVaM6rTEJI1N0dOy6pZLGvtEnx5ptjZucG29bWxeV1UdeXLzVYbTicZANEE+0MD1L1yXzyvIiCuRHth36tScvmCECoKof+TgafmWdI/88ayB4u8XwsrKHMGGw4SZdOyeh2GgN91JlSnFnz6Tl0rZUR07S/8EpmoNVGxteVU/mBSfvTUX3YeJUzZl3MQJbgxtRJEGCxtDhvxdu950SP76TizxEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJKn9H2l868ewCIAKCc4Clug7T8Gw01teyVxxaCTNZU=;
 b=NhluFFbipBaCeGTYp/GxWts/DaEyiIH8ySjXYhxxTVYuaTneQ9o/dBjfdsb94eY/qLIzhxdcqFpvP5lL8kud+cZkAhjtBpjBjl0L6FuWr1wbLJe1UWn8Wm7xHVz3pNp7fJeEQmctAeZIx6l5aZFAxyYiWAlG97pLH7DPSM5s5/XB6vuCJtOAmq6MeWePrzuwA/T5MrIhULHgLqrnLRaVRTY1atEV6KAWSd50xG1qgKUBJA1frwuqK/vC6Qs6j6be7M3ZlgCEor6U9xuvy03+v3Qea+pcv8WlIgi6NM4jDBbpGDA8ZAl+RHqU9Zi6FQW/51JhXlP4+uNa9nD6oNcr/A==
Received: from DM3PPF67FA1A8F8.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::f28) by CY5PR11MB6091.namprd11.prod.outlook.com
 (2603:10b6:930:2d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.12; Fri, 30 Jan
 2026 14:51:09 +0000
Received: from DM3PPF67FA1A8F8.namprd11.prod.outlook.com
 ([fe80::49f2:f63e:c633:5e11]) by DM3PPF67FA1A8F8.namprd11.prod.outlook.com
 ([fe80::49f2:f63e:c633:5e11%4]) with mapi id 15.20.9564.008; Fri, 30 Jan 2026
 14:51:08 +0000
From: <Ryan.Wanner@microchip.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <davem@davemloft.net>
Subject: Re: AFALG with TLS on Openssl questions
Thread-Topic: AFALG with TLS on Openssl questions
Thread-Index: AQHckTxGvIr0hmw/6UG4ScH02tuyNLVqKqwAgACiwgA=
Date: Fri, 30 Jan 2026 14:51:08 +0000
Message-ID: <6768ba1e-8051-4623-8d9a-4c3835011755@microchip.com>
References: <25e13e64-f39c-44b4-9877-1e3b6caed458@microchip.com>
 <aXw8-J2KRklumOa8@gondor.apana.org.au>
In-Reply-To: <aXw8-J2KRklumOa8@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM3PPF67FA1A8F8:EE_|CY5PR11MB6091:EE_
x-ms-office365-filtering-correlation-id: 835c46e5-3ef0-4b5d-6d97-08de600f00b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Z2lwUlNqdE5hMmxscjEvbXhUZE5TMEhrMWo0bmtrT1pvR01URm1KVUVDSGR0?=
 =?utf-8?B?K0VEbVQwak1mZlpZSDdGU3AxZ09KSTI0dVFueFJOTW1UclFLNnVuWFR0L2hm?=
 =?utf-8?B?RnRFYVprRDdHaE1WTHRodzRhQytRMEJ5N3YreUV5dS9nUmkyaWxJN3dMVi96?=
 =?utf-8?B?c0ZrdVowcEllaGhOdG9RK2k3R1k0Y3RET3FlaFhCMWVjdmFBRmNTVmlLN0xX?=
 =?utf-8?B?OXFDRVdOb0Z4SHJmUjdDRnRTZVBFek0rWHRrVllaS2V5ZDdKeXBPQzhxcXNm?=
 =?utf-8?B?SXJIQUxoUWZFQjFXbjU4dTEvT2JuQmtsM0lOaGRGOGpidHM4STZxdTJPc0Jt?=
 =?utf-8?B?ZnNNaUZEb013d3Z0THZBdVRlenVoVE5rMVNDU0ZaRmMzbmdvRFNjR012Tk43?=
 =?utf-8?B?K1ZaTjJOUm1lbWtsNmJRNngyL01xdllKTFMrZXhLRW8vZElmTU10M29VVHRq?=
 =?utf-8?B?Yk1LVEFOMGFRTWtoU2tIam9MSXBkaG16aFQ0ZzJ4Z2I5cWFaVStxT2pVQW5w?=
 =?utf-8?B?OE96M3czdkxHVmppdVhUczJ6d01SRGFDT2hTUXMvY3RrV29TWDd2aTVveW05?=
 =?utf-8?B?U0wrRUNzUS9xZG15eHltZXVGOUowL25NUHR0VkZEN2VUM0FrbXptMzRlQmpN?=
 =?utf-8?B?RWpJbDFuejIrdk5vbGVKL0c0MElxZ1VuZlZ1SFRPVGZydDVDZGdrc2k3RGFF?=
 =?utf-8?B?UmN3SmFhYU1SV2ZVaHdkbjg5SVRselk1VVNPZkdORzdobERlRGpZTVpUZHFM?=
 =?utf-8?B?YzNwRzdDZEtSWkYrbGd4UHNPTkJCRUJwanU1T3lBNUtlM3Rma3RKK3BVOFZZ?=
 =?utf-8?B?MUNjZVQrZUVVcFZhWUo2b29yRHhEeG00R09idHpsL2lyb1hYQ0JRU2hIZUt5?=
 =?utf-8?B?N0NwbW81akcrcDFHdmJlK1JGTVhCbGZYNitISWd3cDlZVm02N25aVU1za3pX?=
 =?utf-8?B?TGVMVzNlTkxOOFh5YUpPY0FpR2RLQ2JzZUNycjJLT25xMHpCcUYveU5TU3BJ?=
 =?utf-8?B?RzdIdDloWHFrSyt2SGd6ekJXRUJMSEN6Y0tHZnBlRXhkODZ1ejVNUlhjZEVY?=
 =?utf-8?B?UUEzWkZHZ0JxazdBYThPa0RHMG94NFAzRFZIbE94dWszL2VHeEl2aVMvbzBq?=
 =?utf-8?B?WjdZVWprQzlVeE5HWmFUS1ZwWit0Z3c2TkZYNFhVb1I3aEFrZENNcWhGU2Ir?=
 =?utf-8?B?Z2lvV1NBdHhKNDF6UW1Zb3lFNmplT0FBNkZxSXBTcXJVY2pRVGJ3MzVsWWNk?=
 =?utf-8?B?bm91S2pBdTRVMC8yYXVBUHN1RmllRnRtNVdWcGNHZGI4ckRROFFwUytWNVRF?=
 =?utf-8?B?SC8vcmtzL2QxS2NlUWw1WmR6WFYybVg2T2J3QnlkMTdiWHZ6SW03bnpwM0JW?=
 =?utf-8?B?WFk5c1h0aWE0d0Q4UDU5dmRiS2Z2TE90N29NTGljWmFsamNKVVZyMTFiUUl6?=
 =?utf-8?B?UHFWZlI5SXJUNkt5YmJJVHBteTgzTUdkYUluUk4xNUJpdlp2SXdWT2xzT2Vj?=
 =?utf-8?B?ckdGTTV3YkZEVm9wZzQzWkdORjBZVU5ndU1EM0lJU21wT21QRG9xSm4rZ2hG?=
 =?utf-8?B?T21XNStTRnlUanhCY1NHY0pFYkY1bFNySVFtQWlxcjRzT1lHMUx1K1lWUm1a?=
 =?utf-8?B?UGwzOTRkVmxwQk1kN1daOHB2WFo1ZWhiUmRMZWJUbHc3eTZiNEhlNy9NcFVl?=
 =?utf-8?B?blN3N0lvajd2S0t4Z3JueXFFTDU4MU5JeTA5STJJTUN5NENRVVIwaHFtRzB4?=
 =?utf-8?B?V1hRdnI0OFJLUE9iWGtRYUIrUldCWFdJd1lGbEkxRC9McHdBQUs4WEVmUmhQ?=
 =?utf-8?B?czR5blU5aEdvT0lRK2gza3RmZFBkYnQzVjBXaUVWVzdwVzJNd3libHRPMUQx?=
 =?utf-8?B?ZCswQ2FTVkVZLzRNclN3eVlTdHRHaURmTi96MjRWL1NTS29GNlRRZnlXOW50?=
 =?utf-8?B?L04rNUxFWmdpbThGWldxdE1zT2Fvczlma3RITFQvOU8raWFEZDZyek9PMDNZ?=
 =?utf-8?B?YTFtbEQ1MnZERnJITHRzWGQ3aVRET081NTMzMTZxNHZXbTF6aDRiV1dUbk5i?=
 =?utf-8?B?c05rUHVxVG1aVEJPTUNlNGljS1J5RldRSHpVNlZzY3B1ZjBVMUZjQXFtWkxW?=
 =?utf-8?Q?mEmtD3zElkeFx2ccPNqcO1Bm3?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF67FA1A8F8.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bGViTnFGTkVLN1ZhSDNMOU9vQmxhR3pRdWpLTWRkSG5sai9GY29YMG9kUXA2?=
 =?utf-8?B?d3pVelJzQXozOXkrMWRuKzVFeFQ2L2MvSzhFbHJKYTA1UHNFelhkR3JFd3p6?=
 =?utf-8?B?czRNSGRHRU9tYjJhdjh0anBBeEk3QS8rQTUvMS9hMC9TNDdxbzR3MDJIY25J?=
 =?utf-8?B?cEJIYklJaWEvVDZUVlg1NHFoTG9ONmZ4OEp2WTBxeTM4cmU5YXZOZEd0UEpK?=
 =?utf-8?B?dVBxdERrdkcxY2ZyZ2dwcFZoTEV2SUVHVVVhZ243S2FaOThmd2w5RTJneFpu?=
 =?utf-8?B?MnRQZk1Jd2xEMFNtOEQzMGVQZnlWTjhwbHV6VW1zZTl5aFp5UkQvVWtSVkhL?=
 =?utf-8?B?Q0xFMUFoUmhhZklGaUptR2J0clpTT3RwbG5CSHB4MXZGcjJOYktqY29jRUdG?=
 =?utf-8?B?cmpjWk9uS0o1ZkJyYUF3dkJEajVMS2IwZlRBaHlEamtENnUxR0xoUDFWZTVP?=
 =?utf-8?B?OEp1M3RsV3EzQVRLTzR3RldCOCtuMjZlZzBxOEJjdk5jT0lGd01Lb2psaTBn?=
 =?utf-8?B?NU5wbFVUdnhiSUIyb0RRMDgwVVJzZ1F3QzBISVBVQ3A2OEhKcHhWTUpsa05F?=
 =?utf-8?B?Mnd0UHc2L2pwRXV6TXM3WGF1UHBhWHhNbVZhTGM0R3FoR1dLeEhQL1pWb3NJ?=
 =?utf-8?B?QlRIVFV2YXl0bGJFQTV3ZkM2RFpvTUd2WVE5WW5TVTZQdVpGZVp1bkFDTG9p?=
 =?utf-8?B?RkhmaExiZG9CWUZ5ZkxBeWFrUUl1MWRyV2IvMW4xQUFBL256c0dVOU5FSjh4?=
 =?utf-8?B?QVZKM1d2b1kxbTdjOFVHOEpTdEIxVFpZWlQ2bDdWUFJJYUR6MTdITitZS3Fu?=
 =?utf-8?B?TmRjNURuRGp4SFMwVk44cTlWUUV2M0RFRmc5OFE4WWd6VFowY0NkUFA3aVZL?=
 =?utf-8?B?M2pvTmZNNE1tSFc2NmxsYWNBdm5ZZ1dXTkt0cVFaUVdvOWdQRDlTelVWUU5H?=
 =?utf-8?B?ZzRQckR5b1N0TUdQTzFOSW9ZRUdnNnZlZkpnWElQbThreXFkMWN4dEgzby9w?=
 =?utf-8?B?c2o4eUtlcmVQMlVaVUpOUHlkMDVIQmVIYWxxQnBSNFhFRnJMVHZmNkJvQWhh?=
 =?utf-8?B?SDdDNU85L3ljWkhzRDg5aiszcVZEcFl5M0o3TVY1dVk5dGNreFR2c0RaaXMz?=
 =?utf-8?B?VzdGd256QVpMTTIvRDVCaytkMCtiK1d6ZVVkMDd0WUxjVGVJSXpMaTFmcHFP?=
 =?utf-8?B?Y2oxakRKVnNzYyt5L3N0eE9ESjB6L1N2V0JqUVFvTGVyRDMvbkoydUNCL0Jh?=
 =?utf-8?B?TnU3UmNVckJ1NXhaZjlzK0FaNWJsNkN1WllTaC9YbSs5V3Vkb0U2YmdkUkdT?=
 =?utf-8?B?K2xTKysvWHJGMEZFdmxlejRoNXU0SzRnYi9FQ1A1SnRnNjRxUjE5YlhONTUv?=
 =?utf-8?B?a3lqNjhJcS9kKzFVL2haTFE1NzN3OWplY0FGbU1wTGY1elZxNFRJb1dLVmhk?=
 =?utf-8?B?QXpMaXFDTDBTWmthNUFaNGhPR0xFK1ViWURudzJtc0pHaXFlNEpsMFJpUXdv?=
 =?utf-8?B?MXhDcDdCNktUb1RTSGlTSUNqODBhQzlaRWlXb0tidlFFVGhPWVVlOCtWTW5Q?=
 =?utf-8?B?K1gyaHFHRG5oZUxPQWRqTkc3TkJCWXovM0hrWVFNc2V5NXd6QnRtTGg3SEUr?=
 =?utf-8?B?ZlB1SGpKRG9DaWk4YUFhelNsYmJIWmVUL3VJWEhHWlFrM0R3aCtzSlZEZmIv?=
 =?utf-8?B?S2gvbzUzR1E2aC9wMHpyZkxYSU9HUWZzVnZJZkNxdmdEZGI0S2lJVmRSQ1BF?=
 =?utf-8?B?bDYzYmFhRXYvQ2wwcDF4QWs1VTRCL1M1SG5uaEZodHRuWHB6Zzg1Vlcya0py?=
 =?utf-8?B?aW5XcTBJNUpPeUUzOG55elhaL0F6Y24zTXZRLytqekJCVkZxNkFjdlZTK3JZ?=
 =?utf-8?B?ZzVPQVMvd24rN2xzUTUyTUNySlh6TGpBaG9LMXFTZmRQaUo0dGg4YnlPNFNZ?=
 =?utf-8?B?MVZlaW5jS0ZiWnh6cUtKOXBkaTR5a2ZXcVBJNVBUOU9PMFVkOHVCakRMOHBV?=
 =?utf-8?B?dFJYV2VoS0hXS2RkcXJwS3draHZCVFE1Z0tGVjJFYTJPS3NoRWtvV2ZqUzdQ?=
 =?utf-8?B?OTd5SCtVZFZHdC81TmdVMnAwMEdudXI5aTl5MTlzMEpUNzNUeXBVRUVqSEpZ?=
 =?utf-8?B?M3VuUUUwVjlFY0hyZWtiTHEwQ292WmN2amZkUzM1Skxxa0lOME5TQ2dDTVNR?=
 =?utf-8?B?YWpEb2RVb0xuQUJxVnFQc0hES211R0Y4Nkw5R2U5Q0tKZXpqTit3ZEhXWTh3?=
 =?utf-8?B?NTdwSWkwaDhoRWx5R2cwbUEzSVNuN2g2T2VVRzdqL3lpdzVXTC9lT3BqeXJY?=
 =?utf-8?B?N3ltQncwaTMvZE5tTlZJWVBtZU5WWWZMb0FRdzQ2UzFyNWxJdGw4Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F53D47E9D4BF94468779A100EDBE91DC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF67FA1A8F8.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 835c46e5-3ef0-4b5d-6d97-08de600f00b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2026 14:51:08.5538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DU5BFoFlQaY6a1xtFzJ6bvGWB6/tyIfcW+j7nVbUYwPvsqxnaVYsTFzKOMENBVMCHc/1pMKeIDglqlrw0tg4Z22ydrCBlar5m1khRNcEXgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6091

T24gMS8yOS8yNiAyMjowOSwgSGVyYmVydCBYdSB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERv
IG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUg
Y29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBUaHUsIEphbiAyOSwgMjAyNiBhdCAwOToyODo1MUFN
IC0wNzAwLCBSeWFuIFdhbm5lciB3cm90ZToNCj4+IEhlbGxvLA0KPj4NCj4+IEkgYW0gd29ya2lu
ZyBvbiBrZXJuZWwgdjYuMTIgYW5kIHRyeWluZyB0byB1c2UNCj4+IGF1dGhlbmMoaG1hYyhzaGEy
NTYpLGNiYyhhZXMpKSBmb3IgYSBUTFMgY29ubmVjdGlvbi4gVGhlIGRyaXZlciBJIGFtDQo+PiB1
c2luZyBhdG1lbC1hZXMuYyBhbmQgYXRtZWwtc2hhLmMgYm90aCBkbyBzdXBwb3J0IHRoaXMgYW5k
IEkgZGlkIHBhc3MNCj4+IHRoZSBrZXJuZWwgc2VsZiB0ZXN0cyBmb3IgdGhlc2UgZHJpdmVycy4N
Cj4+DQo+PiBJdCBzZWVtcyB0aGF0IGFmYWxnIGRvZXMgbm90IGNhbGwgdGhlIGF1dGhlbmMgcGFy
dCBvZiB0aGlzIGRyaXZlciwgYnV0DQo+PiBzZWVtcyB0byBjYWxsIGFlcyBzZXBhcmF0ZWx5IGV2
ZW4gdGhvdWdoIGF1dGhlbmMgaXMgZGV0ZWN0ZWQgcmVnaXN0ZXJlZA0KPj4gYW5kIHRlc3RlZC4g
Q2FuIEkgZ2V0IGNvbmZpcm1hdGlvbiBpZiB0aGlzIGlzIHN1cHBvcnRlZCBpbiBhZmFsZz8gRnJv
bQ0KPj4gd2hhdCBJIHVuZGVyc3RhbmQgYWZhbGcgZG9lcyBub3Qgc3VwcG9ydCBoYXNoZXMgYnV0
IGNyeXB0b2RldiBkb2VzLiBJDQo+PiBzZWUgY3J5cHRvZGV2IGNhbGwgYm90aCBzaGEgYW5kIGFl
cyB3aGlsZSBhZmFsZyBqdXN0IGNhbGxzIGFlcy4NCj4+DQo+PiBJIGRvIGhhdmUgQ1JZUFRPX0RF
Vl9BVE1FTF9BVVRIRU5DPXkgQ1JZUFRPX1VTRVJfQVBJX0hBU0g9eQ0KPj4gQ1JZUFRPX1VTRVJf
QVBJX1NLQ0lQSEVSPXkgQ1JZUFRPX1VTRVI9eSB0aGlzIGlzIGEgU0FNQTdHNTQsIEFSTSBDT1JU
RVgtQTcuDQo+Pg0KPj4gSSBhbHNvIHdvdWxkIGxpa2UgdG8ga25vdyBpZiBhdXRoZW5jKGhtYWMo
c2hhNTEyKSxnY20oYWVzKSkgaXMNCj4+IHN1cHBvcnRlZD8gSSB3b3VsZCBsaWtlIHRvIGFkZCB0
aGF0IHRvIHRoZSBkcml2ZXIgYXMgd2VsbCBidXQgZHVlIHRvIHRoZQ0KPj4gaXNzdWVzIEkgaGln
aGxpZ2h0ZWQgYWJvdmUgYW5kIG5vIHNlbGZ0ZXN0IHN1aXRlIGZvciBhdXRoZW5jIGdjbSBJIGRv
DQo+PiBub3Qga25vdyBhIGdvb2Qgd2F5IHRvIHZlcmlmeSB0aGUgZHJpdmVyIGludGVncmF0ZXMg
d2l0aCB0aGUgY3J5cHRvIHN5c3RlbS4NCj4gDQo+IEl0IGNlcnRhaW5seSBzaG91bGQgd29yay4g
IEkgc3VnZ2VzdCB0aGF0IHlvdSBjaGVjayAvcHJvYy9jcnlwdG8NCj4gYW5kIHNlZSBpZiB5b3Vy
IGRyaXZlciBhbGdvcml0aG0gaXMgcmVnaXN0ZXJlZCBhdCB0aGUgY29ycmVjdA0KPiBwcmlvcml0
eSBmb3IgaXQgdG8gYmUgdXNlZCBpbiBwcmVmZXJlbmNlIHRvIHRoZSBzb2Z0d2FyZSBhbGdvcml0
aG0uDQo+IA0KDQpJcyB0aGVyZSBhIG9wdGltYWwgcHJpb3JpdHk/IEkgaGF2ZSB0cmllZCBzZXR0
aW5nIGl0IHRvIDQwMDAgYW5kIDMwMA0KYm90aCBnaXZlIHRoZSBzYW1lIGJlaGF2aW9yLiBJIGRv
IHNlZSB0aGF0IHRoZSBBRVMgYWNjZWxlcmF0b3IgaXMgY2FsbGVkDQpidXQgbm90IHRoZSBvdGhl
cnMuIE15IGFzc3VtcHRpb24gaXMgdGhhdCBBRVMgaXMgdG9vIGhpZ2ggcHJpb3JpdHkgdGhhdA0K
aXQgb3ZlcnJpZGVzIHRoZSBhdXRoZW5jIGFjY2VsZXJhdG9yPw0KDQpUaGFua3MsDQpSeWFuDQog
PiBDaGVlcnMsDQo+IC0tDQo+IEVtYWlsOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFu
YS5vcmcuYXU+DQo+IEhvbWUgUGFnZTogaHR0cDovL2dvbmRvci5hcGFuYS5vcmcuYXUvfmhlcmJl
cnQvDQo+IFBHUCBLZXk6IGh0dHA6Ly9nb25kb3IuYXBhbmEub3JnLmF1L35oZXJiZXJ0L3B1Ymtl
eS50eHQNCj4gDQo=
