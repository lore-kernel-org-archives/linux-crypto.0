Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011060.outbound.protection.outlook.com [52.101.52.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567333D3321;
	Thu,  5 Feb 2026 12:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770294353; cv=fail; b=N3LdqvyR1eCv76uZtJ7irO/4vwagaeviu6CDXA3BojwaSoInovU71rzx9gCM3tcM6IBP+TY6wAzu2OkXM0qSycsXI1FqHjd9nnE/gtqupljpy2S5Ow2IzArQ5D5g21cFrKNycgRUe99fOTc/HeMVXU+alECTOsJBGtPbLsywMlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770294353; c=relaxed/simple;
	bh=EVj/v86039L0AXb1bU2f4eeol0OMODUw6rasyEGwcuo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HRDH1l2W7MXHhHz8QOFE8aVyzbeCfC86Yr6j0IDMfYFSh8t3wm2hi8gt4XkpSPkpV5n2pSKUGdpLeSogd5D2RginONuaDR8PYrcPGegrCsnYMKJBWE9qZ76Iiqy7WylpgXwgULhNvOo4Bt4GT1JiP+o06BYEH2hI528eCL1SfkQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=s3P0zN7z; arc=fail smtp.client-ip=52.101.52.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="s3P0zN7z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yAsK4bQkaZmzGnpU9wgFzjQa3ToqhlgZYI3gRoiujA07ZQpc4EVereU5JQiA/xLnBSwZwpIPvgy47y69wK48uuaeZA192SCFpntVH331Bl3Y4XYlKeOGhi/IZw+6Yixzvcj2lOpHi5dqnka3F6wmkqILVVNNiM2QBFTZDl3lP9QOngXZp7nV21Tf3NoODOcXWu/oFF1Ues4ElFBrPJY/07EztfyVgsvwa4BLSsocGjd1H17ODNPXEuHTHkaeJoH27pX8wa07EJEmn+l9JNOQdGNlfD0efF53TYaNhYVVPfIHuRb/hM/pBRJ/i/caNYeK2vniis4z3n3aBnci26WaUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O8eRYpMYfSFfu3njmBkw0OYE1sQMOleR3nzz9OTFz94=;
 b=WU5o5bGKriFDXF0fPYkgVVDwPBncQjqU7SvLjINUpkNmmUxqAfDF5xdhcBJss5zsZLnofSJPjCij5J64ZUbE6rTFkwkLT3Ns6+TSuzMNX1O+02emh8N0cyDy/Tda2f0Vr6Z56cJtzhREysYPjTtI7X4aEtOqA4xXQEGaKFWOgcfre/wS0I6nxjjY6TqmAGK0Hjxgad5/HPGSpQbN986loqqxXIHzUzCTtMlNDg+EG9BJlkbduaGBLfbWJ59xCOehQ+ri5VoaBAmN+AJKtNOsTkxr2dPwz6r1BOxt1FYGXE+TsCjg3jEcRbOecrEFLC++D6lL5hm3js44Yi/bjbH72w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8eRYpMYfSFfu3njmBkw0OYE1sQMOleR3nzz9OTFz94=;
 b=s3P0zN7zgP5Yk7nWZpz3fUMKv/gLMFIkQKJYVsa74Aij/Xo8azTrw7p+AsSy1A1DQNW9efHkeXIQfb0Y6Q/NLcKlyR8Pc7R3Z8vTBl5T6F0MKfEijLGqRMXm6jFUQxg7YPAh8A+JgDoEitwe9TAd8GBMLymilkGWTsFTmk+vV7U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DS4PR12MB9682.namprd12.prod.outlook.com (2603:10b6:8:27f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Thu, 5 Feb
 2026 12:25:50 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::94eb:4bdb:4466:27ce]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::94eb:4bdb:4466:27ce%4]) with mapi id 15.20.9587.013; Thu, 5 Feb 2026
 12:25:50 +0000
Message-ID: <2a514c32-e08c-4439-a4da-233e389002a9@amd.com>
Date: Thu, 5 Feb 2026 06:25:47 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] i2c: designware: Enable PSP semaphore for AMDI0010 and
 fix probe deferral
To: WangYuli <wangyuli@aosc.io>, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net,
 mika.westerberg@linux.intel.com, andriy.shevchenko@linux.intel.com,
 jsd@semihalf.com, andi.shyti@kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-i2c@vger.kernel.org, bp@alien8.de, ashish.kalra@amd.com,
 markhas@chromium.org, jarkko.nikula@linux.intel.com, wsa@kernel.org,
 WangYuli <wangyl5933@chinaunicom.cn>, stable@vger.kernel.org
References: <20260205114451.30445-1-wangyuli@aosc.io>
Content-Language: en-US
From: Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <20260205114451.30445-1-wangyuli@aosc.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0020.namprd21.prod.outlook.com
 (2603:10b6:805:106::30) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|DS4PR12MB9682:EE_
X-MS-Office365-Filtering-Correlation-Id: c2ab2cde-48e6-4f1b-61f8-08de64b1b28f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZThackZrc3NNcmV3RkJtaGhuUFh2ZmFYT2ZEREo4cERPVTV2K0JOSVByUWdh?=
 =?utf-8?B?VmM1L0VYWDdpVWRzeXQwWDZGUU1TSXZkQ1pXTHUyU214VWhob0pMNEdmSnJi?=
 =?utf-8?B?SHFoWnV4QWl2T2pzWnplckFPL0FGb1p4YUlWVjQzOC8zVXpNWkM2bUJhOTVB?=
 =?utf-8?B?cC8zdWNUdE80c2JWV0IzcTQ1dVBaeGJGSG5CVk04aXNzU2lzOGhxMmFRZXd2?=
 =?utf-8?B?aG9idUloSGxVZnNWYlJwRU9ZUHdQVkRYc1VXOW1HMGVKa2FHV3pqWllOM0Jh?=
 =?utf-8?B?WlB2SE1DbUQ5KzlCVDNhSmduRFhOTmRaSkwyQ3ZPU1BGQ2FFZ0w2RE1DVHRh?=
 =?utf-8?B?QmR2UWEvWXhDM1ZaNFFOVUx4S1lIYnl1WWFVNFRlTHVKOENrcUNPcjdwM0hJ?=
 =?utf-8?B?cWlIQWtEWFNleFVXMWQycFRRTmNVS1d1US9ReFl2a0k0WGdsc3poQmhPY0Vp?=
 =?utf-8?B?QjEwNFY5WW5tRGkwamFDK3NoT1VSZ1N2TzVPQzJoMGQzTG4vbE5Fb01HWWgz?=
 =?utf-8?B?K1h1WXI1UnMxbk1sWWlJTkVEakdOR093UEFhVFJiek1jVXZIekxDbFdSbjJz?=
 =?utf-8?B?ZUc4OUhBeXZYaVdNelJVQkNBUGwzSktmdkMyaFZ4a3NVY3VnS1RvTGV5QnQ5?=
 =?utf-8?B?Rk5ld0cweXczdVFnRE5HRWFqSnFCaklKa3lSR0RObzFSRUNoSGl6a0lRVmsr?=
 =?utf-8?B?aHoyaXo3a0ErV3lFa1E5Zi9vMU1GemdZTFFMYi9RaXdZei9zTGsvYkhOUFFS?=
 =?utf-8?B?ZGVpNHl5OGs1S0lORWt0V1drcTFGVHUybWYvV0ZJdFRWK1Nvcm84Y3k3YUtM?=
 =?utf-8?B?RWgvWlkzNnZmRHdlQWN2c3c3bDFXYnVGUHZRVWEyM1VjT3MvMGVFSkg0NkNF?=
 =?utf-8?B?d2ZUSFdCUnh6Sjd6ZWdXRGwyZkNubDVjRmh6K0duMDZ0VW9MSHEyTGFqUWpy?=
 =?utf-8?B?R3QrWUlJZjkybEZwR2hSeGw2NldjWXB4YWRMWlZ4dXhybmhXSHp3b3ZUMmdp?=
 =?utf-8?B?RlNVd2MrNHVrWW1YQU1lKzFXazQvclVEYmZxZmRmMHIrVU8xYlFHL0N6NFRv?=
 =?utf-8?B?NEMraVJ4RjI2T1NsZkxadU1uTHJlUkNDT0RwOEExajAzNW5Vc0EvL0dZNzY4?=
 =?utf-8?B?alJiY3NvMkhGSWRvc0h6UjJQK0FzdzIzSVZzeGoya3J4NXowYkcyd1ZmUFo1?=
 =?utf-8?B?eWNORkNqM3VqSGNwQnJ4bXRBbm9acytUZWNDMGRBUFh2MFdjMjh5a2xnRWZ5?=
 =?utf-8?B?WmdWZHNDL1lmMGpqY1NhblFWQW93dE1CK2FrcWpNMkpERkFzbmdVUUkrWDlX?=
 =?utf-8?B?cW1aOWY5VzBUMG5RbUFTYWR0SExBRWlNbW45MC9nZm9DNzBIZng2Y3psUWYz?=
 =?utf-8?B?bCthMCtDWGtQR05BSjByNmJHVFNmWHZueFdrVUVRMkRqYi91WERtOHRJcHFt?=
 =?utf-8?B?MnVTYm1XRFlYSXJ3S1JyZUlWbDVWdzBBWE8wVHd5c3JTaHBHNDVzL1BjMDY5?=
 =?utf-8?B?RXBEdUZ0SkUwbm4rK09KVFdMeGV2dm9OTXVMRi8xMnVwa3JBSEYvdEs3bnVX?=
 =?utf-8?B?RnpFd3pGRCtWaXVnT3VYTmlCTkdLcmZvUjRxSHhGYWxiMWFrR1RDdk81TnNs?=
 =?utf-8?B?dk4zZFc4MEhRZ0k5MTFCWGFvdUQ2cEFYZC9vSXJ1anhYeDcrSEVON3JHNi9l?=
 =?utf-8?B?NDc0QUduNmdsRU9QaFV0R2tVYTk0WFdpdmk3UlFjRWNzL05YVUQ5K3hIT2tB?=
 =?utf-8?B?UmJ6cmZhbWNHUGMrbXBqWjZNMkdKejdRaGx2MlFrM2Z2MVN3Zmg2NW1aOG91?=
 =?utf-8?B?djBKOFRSZWxiVyt2NUxKWU1wYW5vUHR2OFlXa0dhWWRPdTBkRHIxR1I1cEM5?=
 =?utf-8?B?N2E2LzJNOFJsU0JvVFN5ZTBNNURHL2hTWjBRN3ZhVEtQZ1lqU2lWbWljOG8z?=
 =?utf-8?B?OW9lWkYxU08rOXFyVkQrREdNc0hlQ3h4NW1ZbDh1UGt1K1lFNk55bUJHNkNz?=
 =?utf-8?B?LzN1SXB1ZjBRK09OdmR0MzdnaUkzUVFsL2NsU2VVcDRZSEtpL1lpYlJkaCtZ?=
 =?utf-8?B?aDJuMW9HSnRJRzViazBOKzVGZGVTMUp5bnRrOHphdmNvNDMyNnVYUHc4TnB6?=
 =?utf-8?Q?oLAM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dzZiWVRzaUdPOVEzcGpSM2xlNE55ZlhoRldKM1JtTHJlWjZaVnhZZDNhMm1i?=
 =?utf-8?B?OXpka3hwREIyaGM5SUxNZnZ3cnZBWEQrdmEvNUlwU0lpaVhuUGVITG1hU3hh?=
 =?utf-8?B?L1pJckR2aU9mT0lTRkRFSnJhRXpXS2F2a0ppWEdCNDMwNm9YSE9ib0x6cmdn?=
 =?utf-8?B?RlVUbFJ0ck0zQmowVU5rdmRkQXNmTXZZQXhqRG9RRGQ4YWo1dmVxNFFpMzVj?=
 =?utf-8?B?czZCc25HcVcrZEYrU1RMNFU0QjhCcFF4akJaK1RoR0VFTGs4WkRVOGdmR0dO?=
 =?utf-8?B?dHF3STV4dWg0V20zMVlKdGZxMWFpYXJrbE9TajAxenljU0xrdjBUbEFoRjE2?=
 =?utf-8?B?RkNYeDFzZGdiMlY4U3A0cVBhWmtxZVkxZnpZem5oZ0pwSDN4YmJJYnVHMHY1?=
 =?utf-8?B?QVd5cDFXbWlpd043Um5RWkRUUEV0dkw4ZE5KTmY4TCtmWmZiMEN0d3BHUkhh?=
 =?utf-8?B?RjhOMlNleHQ0MXVYYW5tbE9WOWZjMEkzSmFSR1dtU2tCK082ZW83MzNxVEJj?=
 =?utf-8?B?NVpOUU5uMkxpdXJ0eGJTOFQwRkRDb2pXOW9RSGR4dTNZMVlvUkEwalZaT3VE?=
 =?utf-8?B?MVpEQk5XcDNDcExabUhWeXNIMnltTWd1UkVDbEpmTklCb1E2WWJvVVpwbVBE?=
 =?utf-8?B?ODk0ekw1cFdBYVI1Uzdjd0JIRFhxT2hwc2JTOGQzYkZ3L0h5VlZwSHhvNVZ1?=
 =?utf-8?B?Y0xxZjRUb3V6cjN0M2tQQVM4Y0pPcmRMdXZOYXJhSDdBMlhvMWVTSlRlbDJZ?=
 =?utf-8?B?SXNsYkI0WkJFdVBHZTViRGg2TVpCY0tSM0V1c0pCWFF2SGhBck9KcUhRbDRp?=
 =?utf-8?B?MWRVck9VVmJHbW11QlI1dDRrZjBiZUhxRGYwWGxTbS9POG10Q0gvMXVTVmVX?=
 =?utf-8?B?aHR0NGt6VWlEdDFMaVYrbUE0cXc2UEt2M2VCSEc1N2Q0blhFbkZXaytTMUhS?=
 =?utf-8?B?aHlXTnFnc0Ivd1FQT3VtcXp3b0tZWDN5ZStSb2d3Uzhtemg1NkNLMnpQVWdJ?=
 =?utf-8?B?VGFCbmF1ZFdXMmlaNTl2ejNmWTdnSnlldHpUUmZyTERreGdCb3gyT1FJR0FR?=
 =?utf-8?B?MHdVMzE5a1ZPeVB4WFFEUGNtQUdDRGNxUGlsVjVvOTVvSGZXdGdjN21ra3hj?=
 =?utf-8?B?dks2ak5Hd1YxVUpTUG9tS1U4bXNmT0o1WldsVHQxcGtzMStJaGlkK2dPQjZW?=
 =?utf-8?B?c1NnUlphMy8rWEE5RWJhekF5RndBbUJ6OWFwWGZCSWVlbWxhNkRrZkNKVWtz?=
 =?utf-8?B?L2d5Vm0zbFU0cW5IRmlSK0V5emZJemdPVnF3bllxd29oWmZKWGJxNDVvWDZn?=
 =?utf-8?B?SXE2L1BBeldDMkJ5OWYwb20wdk1KNW9MU1E4Y3YxT2g1RHViclZNMVFVQ1ZF?=
 =?utf-8?B?dGpRcHlNQUtXNEFTbVFac1dZaWQzRzhSa01yVXFnbEVNQmhhc09IRFA1VnZQ?=
 =?utf-8?B?WEUxZkpVRytQcjdORmRQK0VMTXVScWRJcUVORnRRUisyTEhGU1IrakRUVC9T?=
 =?utf-8?B?eDRYcmIxd0J6S3J3MWdyT2g5UlJvZHVSMktFbHRzcjFNYThUT0pEb2VMeG5S?=
 =?utf-8?B?V2gxSkU3MDVjdENUeStFRFZJUkFJdm5UOWVPZXRwaTJLVytUWTNkYWMxVnFP?=
 =?utf-8?B?YWV5blVTWHRWWkFmT1d6WUhNdGl2TkJjdUhwdTV6NFFwakxqekdlRUtoemts?=
 =?utf-8?B?dlVUTTdMNnU4Q3o5VmFFeHd6bkpTUkhCa1hQUVNSMWs5VmQ4Q0J3QUxhSWI4?=
 =?utf-8?B?dDM3bXFjN0ZsNWlhRWhyOEx3VVdMdzBJWkZHYlhFcXhXWVh3a2tIVzhvYXh4?=
 =?utf-8?B?M1ljT0FSOGFlTjV5dGczN1luVzMza2lBN0dwZFZnMEtMUGZyWDlhN2ZFbG9W?=
 =?utf-8?B?ODRKaURXejBkL2syVENaQ2p6elpkbVJIRFpLVWJIUWFISnJic2NIS0JtU1J4?=
 =?utf-8?B?WjZ4Ukt3Ym5LMjZUYWp6M0lucUhoR3FFK3c3MWhyWmorOHRVSlBFUjJxbzd4?=
 =?utf-8?B?Z2pKd1pscE80TkpSOXkyWHM1SFNhK1FvRmtweFlTYU1tY1VldGw0WWdPRXVQ?=
 =?utf-8?B?NG1LRVpnNlFSNlpXQm5GMzRySDUrWkYxQ3JqeWpHaEpwZEZoRUNpVEp1RlQ1?=
 =?utf-8?B?bndKTm5qS1NTcE5jVHFvcVZPTHZreXRLMW95bDJPcDdHWmNPWWwrbkl1NExZ?=
 =?utf-8?B?SjJzTDFBM3pTdlc5TU5aR0hUVWdLZm4vR1ZrU3c2WHptdjRRaXRRVXQwb1Fp?=
 =?utf-8?B?VFlqc042Rm1MWnJUVDFNazhkNDc5dVJBN09HT1gzd2NCNzNzSFJLKytIZk1B?=
 =?utf-8?B?YjJ3ZzRDQjRjOGNKQ3JJN21jb3NGbGRocGVIcWJ2VWh0RmFEY04xZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2ab2cde-48e6-4f1b-61f8-08de64b1b28f
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 12:25:50.3250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rvXuubwXvBowXus7MxC2csH9HtPKemF8eh9Ls23xhlc3B/Du35L7mporViRI3aW3Dt8C1g0O05yilWE28CpOtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9682



On 2/5/2026 5:44 AM, WangYuli wrote:
> From: WangYuli <wangyl5933@chinaunicom.cn>
> 
> AMD Strix Point platforms use the AMDI0010 ACPI HID for their I2C
> controllers, but this entry was missing the ARBITRATION_SEMAPHORE flag
> that enables PSP-based bus arbitration.
> 
> Without proper arbitration, when both the x86 host and AMD PSP
> (Platform Security Processor) attempt to access the shared I2C bus
> simultaneously, the DesignWare controller loses arbitration and reports:
> 
>    i2c_designware AMDI0010:01: i2c_dw_handle_tx_abort: lost arbitration
> 
> This causes communication failures with I2C devices such as touchpads
> (e.g., BLTP7853 HID-over-I2C).
> 
> Add the ARBITRATION_SEMAPHORE flag to the AMDI0010 entry to enable PSP
> mailbox-based I2C bus arbitration, consistent with how AMDI0019 was
> handled for AMD Cezanne platforms.
> 
> However, simply enabling this flag exposes a latent bug introduced by
> commit 440da737cf8d ("i2c: designware: Use PCI PSP driver for
> communication"): the driver unconditionally returns -EPROBE_DEFER when
> psp_check_platform_access_status() fails, causing an infinite probe
> deferral loop on platforms that lack PSP platform access support.
> 
> The problem is that psp_check_platform_access_status() returned -ENODEV
> for all failure cases, but there are two distinct scenarios:
> 
>    1. PSP is still initializing (psp pointer exists but platform_access_data
>       is not yet ready, while vdata->platform_access indicates support) -
>       this is a transient condition that warrants probe deferral.
> 
>    2. The platform genuinely lacks PSP platform access support (either no
>       psp pointer, or vdata->platform_access is not set) - this is a
>       permanent condition where probe deferral would loop indefinitely.
> 
> Fix this by updating psp_check_platform_access_status() to return:
> 
>    - -EPROBE_DEFER: when PSP exists with platform_access capability but
>      platform_access_data is not yet initialized (transient)
>    - -ENODEV: when the platform lacks PSP platform access support (permanent)
> 
> Then update the I2C driver to pass through the actual return code from
> psp_check_platform_access_status() instead of forcing -EPROBE_DEFER,
> allowing the driver to fail gracefully on unsupported platforms.
> 
> Tested on MECHREVO XINGYAO 14 with AMD Ryzen AI 9 H 365.
> 
> Fixes: 440da737cf8d ("i2c: designware: Use PCI PSP driver for communication")
> Cc: stable@vger.kernel.org
> Signed-off-by: WangYuli <wangyl5933@chinaunicom.cn>
> ---
> Changelog:
>    v2: Remove useless comments.

Can you please describe more about your hardware and software stack that 
is leading to this issue?  The arbitration sempaphore has thus far only 
been needed for some very specific designs, I don't really believe it 
should be used on your hardware.

Perhaps could you share a kernel log and your kernel config 
demonstrating the issue?

> ---
>   drivers/crypto/ccp/platform-access.c        | 7 ++++++-
>   drivers/i2c/busses/i2c-designware-amdpsp.c  | 6 ++++--
>   drivers/i2c/busses/i2c-designware-platdrv.c | 2 +-
>   include/linux/psp-platform-access.h         | 5 +++--
>   4 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/platform-access.c b/drivers/crypto/ccp/platform-access.c
> index 1b8ed3389733..3f20cf194cb6 100644
> --- a/drivers/crypto/ccp/platform-access.c
> +++ b/drivers/crypto/ccp/platform-access.c
> @@ -46,7 +46,12 @@ int psp_check_platform_access_status(void)
>   {
>   	struct psp_device *psp = psp_get_master_device();
>   
> -	if (!psp || !psp->platform_access_data)
> +	/* PSP driver not loaded yet, caller should defer */
> +	if ((!psp) || (!psp->platform_access_data && psp->vdata->platform_access))
> +		return -EPROBE_DEFER;
> +
> +	/* PSP loaded but platform_access not supported by hardware */
> +	if (!psp->platform_access_data && !psp->vdata->platform_access)
>   		return -ENODEV;
>   
>   	return 0;
> diff --git a/drivers/i2c/busses/i2c-designware-amdpsp.c b/drivers/i2c/busses/i2c-designware-amdpsp.c
> index 404571ad61a8..8c1449993e72 100644
> --- a/drivers/i2c/busses/i2c-designware-amdpsp.c
> +++ b/drivers/i2c/busses/i2c-designware-amdpsp.c
> @@ -269,6 +269,7 @@ static const struct i2c_lock_operations i2c_dw_psp_lock_ops = {
>   int i2c_dw_amdpsp_probe_lock_support(struct dw_i2c_dev *dev)
>   {
>   	struct pci_dev *rdev;
> +	int ret;
>   
>   	if (!IS_REACHABLE(CONFIG_CRYPTO_DEV_CCP_DD))
>   		return -ENODEV;
> @@ -291,8 +292,9 @@ int i2c_dw_amdpsp_probe_lock_support(struct dw_i2c_dev *dev)
>   		_psp_send_i2c_req = psp_send_i2c_req_doorbell;
>   	pci_dev_put(rdev);
>   
> -	if (psp_check_platform_access_status())
> -		return -EPROBE_DEFER;
> +	ret = psp_check_platform_access_status();
> +	if (ret)
> +		return ret;
>   
>   	psp_i2c_dev = dev->dev;
>   
> diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> index 7be99656a67d..63b1c06ee111 100644
> --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> @@ -345,7 +345,7 @@ static const struct acpi_device_id dw_i2c_acpi_match[] = {
>   	{ "80860F41", ACCESS_NO_IRQ_SUSPEND },
>   	{ "808622C1", ACCESS_NO_IRQ_SUSPEND },
>   	{ "AMD0010", ACCESS_INTR_MASK },
> -	{ "AMDI0010", ACCESS_INTR_MASK },
> +	{ "AMDI0010", ACCESS_INTR_MASK | ARBITRATION_SEMAPHORE },
>   	{ "AMDI0019", ACCESS_INTR_MASK | ARBITRATION_SEMAPHORE },
>   	{ "AMDI0510", 0 },
>   	{ "APMC0D0F", 0 },
> diff --git a/include/linux/psp-platform-access.h b/include/linux/psp-platform-access.h
> index 540abf7de048..84dbdbeb61d6 100644
> --- a/include/linux/psp-platform-access.h
> +++ b/include/linux/psp-platform-access.h
> @@ -64,8 +64,9 @@ int psp_ring_platform_doorbell(int msg, u32 *result);
>    * if platform features has initialized.
>    *
>    * Returns:
> - * 0          platform features is ready
> - * -%ENODEV   platform features is not ready or present
> + *  0:            platform features is ready
> + *  -%ENODEV:     platform_access is not supported by hardware
> + *  -%EPROBE_DEFER: PSP driver not ready or platform features not yet initialized
>    */
>   int psp_check_platform_access_status(void);
>   

