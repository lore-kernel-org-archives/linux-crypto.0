Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794426083;
	b=bPCNshRSligR4iMbT8zU6jcqhOtp5pRNiIoCXSl8+gOo5xW1LHTIaMcB1PKjWzVRiCi7
	 Byax4+ivjYWU5U/HJGoxU/YYuPrj0YBJp43R2Qmj781cSlzEpQq+Fi1Zvc1kd8IHn6l52
	 2LJ+k02lON86ijuQmVtnieK75VPzb+9iUruwj9rd4uSavklvMdW695io++EzC1PBCMpmL
	 K5xRhN1zti8AkX5mHYywEcuJG17UftOphBdhCh5/PKRUIOknw8YGIJr+Sf51zm5SUiHSB
	 QlkHAjMZQrDE2yb+8O0o95j69i0k/7dFhkI4nxy1iceYDcPdkxEFQLkjYdnLRvc/dZA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794426083;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=7Nog3zzi3pIrhdle3ZahoWRgpP7KUVkJGXAnpdbpo20=;
	b=mSjcN8c57iiDKA+jpOgim+n1P5QiBSZ7kfJhu6kOyRPCnEbHtr6TOLWMn5VKg0eCPtao
	 B5fahPrvOsiEikOYV+tVQPcnlPcwB32W7rs/l4oKyfacyWGablyG6wsHOqMOK/3VcaTb9
	 vpSAnoZ408rHl1Y+8Fu+dxOUvcf1aeYupi2OG5LUKtigR1INnV2cp8qLCgg86HN82E9x6
	 spnohsMFrSAX72eJjsbJD6P9O9Kn3AA72tmFntnDCsUKfrOoZDUdhxsDTN+45+keaLKvT
	 Mosw0ZuAFzDadnT4xCWFQ0/msOquOB9a0vllaIu4wSl9LaNp8vrwPkBVQC4vfGuFbXg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=NGEf42JY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.14
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013014.outbound.protection.outlook.com [40.93.196.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C8F606A882;
	Wed, 11 Nov 2026 19:41:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47C8F606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=NGEf42JY
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EIxciRhnV8mmcjufF4wB6uDSImCxpSuL2nAnc1MY8LyDHuEdw1A4I8tVB1dywP7ep6w9DpyQ/oQdrSg/Tu6v+DoXqJqyO005KMLfZKyAf++KDoR3x1cORHZl764S8jYuc1I75IEj1Cdpp8v57aFampbmneVxzGriTJBv/accGEO7OAbK3UzoSmRGVVQz9cFSXgjV4H5uPtOxIoutlv2UvuUnUcLLrmlMTUicZ02YlohUgkBheCK8EqSFOL5YqBma4ymQCkJVHrEeXZS/16jdb4G7YBV3qCVQuvWb1IHccsXaKb+BB+7FSN0vUkQ7Pw2KRVZgzcgPJvRFBo3AeZ3Mnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Nog3zzi3pIrhdle3ZahoWRgpP7KUVkJGXAnpdbpo20=;
 b=Vrp/MiIuaytCgIoUt41zvYUlps0jcS40dwmZQC5spTkAXwNiYprCRZOxSW5GTMAwGHoEJY2fBAN6zA5ixgS1LBoRlK0/E8kmL5oslwCm+nvqkwryi5kI+vkBkryQsNrdQlhP6o2zJ+TgFfM/MivPIcBclF1wecbNt0HaPvpC7GZcrSr9brhHOy3JHnCmTv7uNmiR6jWc5F9Ay4LGnspw4gfl+7/lPFhw+FCtulwlqvxtY2UIMXVyR0x3ijVpZcpSpn4QvRacaWRYXtZsx0tjlD3+3OYgQcPKMi2v9kml8j5aIuYpQ5z8qTzuQw3F7IL/TPpeV/EVNtwYbWeYD9CNug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Nog3zzi3pIrhdle3ZahoWRgpP7KUVkJGXAnpdbpo20=;
 b=NGEf42JYuM0xsrEImgGUi3HaAvqPdBl6RrktMe4ZDKD38mYBX8O2tjY+GVt4EO3VaQilvRiwEQPy3B01Cq/5gyy+XewmZCS4WHdkgL66Ly+cSTFt8z6RUcgZ0Ra+5IokonVNuKf8DKOgzwQi7KqU6LkdRIZ5lPu2CvmPOCN/o0o=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5310.namprd12.prod.outlook.com (2603:10b6:5:39e::10)
 by CH3PR12MB8584.namprd12.prod.outlook.com (2603:10b6:610:164::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 19:41:20 +0000
Received: from DM4PR12MB5310.namprd12.prod.outlook.com
 ([fe80::1bf0:6a94:a990:14f5]) by DM4PR12MB5310.namprd12.prod.outlook.com
 ([fe80::1bf0:6a94:a990:14f5%6]) with mapi id 15.21.0615.008; Wed, 11 Nov 2026
 19:41:19 +0000
Message-ID: <c31651a5-0e52-4b9c-b988-786efb566aef@amd.com>
Date: Wed, 11 Nov 2026 14:41:14 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v5 7/7] crypto: ccp - Implement SNP Download Firmware EX
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: mcgrof@kernel.org, russ.weight@linux.dev, dakr@kernel.org,
 ashish.kalra@amd.com, thomas.lendacky@amd.com, davem@davemloft.net,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
 aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com,
 shansinha@google.com
References: <cover.1792599491.git.prsampat@amd.com>
 <fe86fe10f9def87a2b463a6d4b44e266dd9497dc.1792599491.git.prsampat@amd.com>
 <avRKB59olTJmKQun@gondor.apana.org.au>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <avRKB59olTJmKQun@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0021.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11c::17) To DM4PR12MB5310.namprd12.prod.outlook.com
 (2603:10b6:5:39e::10)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5310:EE_|CH3PR12MB8584:EE_
X-MS-Office365-Filtering-Correlation-Id: cfa823da-839d-4932-0105-08df402bc23b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|4143699003|261026140227099003|260925021311599003|260925021911599003|260925022911599003|11063799006|56012099006|10067099003|261022105027099003|261026121527099003|261022075727099003|261022115727099003|261021121427099003|261021123027099003|261028144727099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	aFVYgaRFmG7tH4nZrim8BYpEKljg4qjqVwef3xVeKxDYecKrh96LgVpT84Rf8yv9PD+eSBCfD9kY3yVrMKXt5nNLw27YDxg+3fDX9AMb4KwtxwW/QySHi3GOVTdjgw8XTp1P9pNObCeLBYuZ94P9/HpOo6RWYKEyqvyijfTRD9fnslS2ag4482pYrlJVS0WEM+Zh/OpsqXVC0WEWLL1rNNfX8mZryZiR6N7ljnr9HAAjTvOplk0lTqc3s1sNL1fIR8mUWFuikF0/NJOBmQPbC4FcZtVb0pgRUZAslekstzR9KVVUakfg6SY3ZK1j02X1MzN+deR+MIcCsg1CRPriCoBUVaAkzRizQwBkECZ347dyK5h2wdlu68bzQRhjax1Agf9tysQsMaH9pz/ekY0RXGdcNhxGUumREiGLpccmgRcn4gVtjc/u2hOARx6VDfWFkPncTBlxq1pClQ7fN61aAnoFVsl1B2ljhSL8J3KglWijwV4kSZxhW001fnd0RlYAtpZ/I1RjfznxkLGo82/LWy88fiuTA/dXNkRudYGzqMV3Tx2dgKKeci2KdgkY5tlYvgE3sb4YvihbF3KeP/ggmCW1s/JLpRQvjH6w4FbGEbg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5310.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(4143699003)(261026140227099003)(260925021311599003)(260925021911599003)(260925022911599003)(11063799006)(56012099006)(10067099003)(261022105027099003)(261026121527099003)(261022075727099003)(261022115727099003)(261021121427099003)(261021123027099003)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eEdpK2RkeGZLcE1qRTlVOFE3QkgrOEZsb2FqZ1ozUTh0S2crZXhPNyt3bmRr?=
 =?utf-8?B?OU1uZ2hOakhnMkZoU0tFUUpVQ0RjZ1k2UVZRMVZFbEwvNlQ0NlBlRlFlK0xq?=
 =?utf-8?B?VVZnTUxCWmJpZzZrSmJoeEVHNGM3emtNTGJkUFAzdXkxS1IvZGJGVE5hZnZp?=
 =?utf-8?B?MzNGUlNrRzZCQXFLMEcwS0x2SzU5SDhpblZGb0NISUFjNDNNd2h3QTBCN2l5?=
 =?utf-8?B?OHFpWFhZbDIyQXRKOUpnNE1kWkNRWEFHZ2FaNjBBMzBNUkN2SVpSY2lGUy9m?=
 =?utf-8?B?VDY5UktVangxWWtXV01FTXczaFFKSGJ3Z1pmVWVtWCtLcEsvUTUwN0dUK3FT?=
 =?utf-8?B?TWhTOUZRK3RheXljbGdVYzQ4b0RQTDBmWjJIejFTeFFCZW5Ob3FJNlcwSUN1?=
 =?utf-8?B?WFEzL2F3ZWNnVDBqZUJUMG4vaWJyS3MxYm1WdFFtUjNZQy8xc0hQZjdUTVgx?=
 =?utf-8?B?QXQ2c0lQVDF2bmdLbnVpeVFSZkNmMHpMb3BJalV3OXhQNjlSRTdzeTlkNi9u?=
 =?utf-8?B?blhuNmEweEc1b0tjbXorWTRJWWJyZHRvVkdpTFJIN0hDSDFEZE12QWRaek9T?=
 =?utf-8?B?bTcvVGIxamxIRnNOclBGR1FCU1lOZUM5cDFWNTU0c1Z2SzRXSW9JWWRxcVl6?=
 =?utf-8?B?Y25JRWR0WmJWKzRPWmtWNC9ST3hJcFNVaWYxUEtCaUFZa2VyR1YzMVVVRGRB?=
 =?utf-8?B?SFpJOGRNLy8xRDNDbFdFMjdZbWtpRzM2aHdvUFdKZUxDcnJKVGJnOFFFaHJJ?=
 =?utf-8?B?M3JnY0ZBM2h0YUw4Z1lhTVFIVzVxbk4rUU5oc0lCd3p4UmxHQVFQVGxTMjJV?=
 =?utf-8?B?T3BMZlhwTlBNRUk0Yi9aTDg0Yk54dlFrZWM1QTdzeStpTjd1SkxRK2pwVUM4?=
 =?utf-8?B?Z2dKM0h5bjhhQloxTVEzc1pSUTh0dVorRHV1ZEFUWUx4VnRycGlYalJFY3FQ?=
 =?utf-8?B?SElNTGJoVUxCVjFBWGVGTm8xa2FCaVkzUCtCTWFHWnNGeGp4cFhzQnMxZkN3?=
 =?utf-8?B?Vm94d3M0aXBqNUk0TnRiNDR2cWtHSW94Zk1XVWFHd0tkcWNNb05nekhlNkpv?=
 =?utf-8?B?RW9tZlFpZDhhekJhd0hkbWhLSWRPWVI4dXNaWWFzaTcwUFVraFFFUU9tQTFw?=
 =?utf-8?B?ZTdROFlzVXNrQlhuMS93NUNNVWM2Y0l0aFFhTUZPNHNPVStNNVlrdHp0U1VP?=
 =?utf-8?B?YVNpTmlMRmEwUjhhWlRsRlZJMFIvR01uNUluUWtLbUd3SzMxUnJOTXoyRVZQ?=
 =?utf-8?B?Uk5yelJJM3g4bmR2MHpQN2NKQ2tNNENVeVl2bVJKOE52TnpheGV1NVFZc0xV?=
 =?utf-8?B?MmlpZnVtNHd2cGw0dEJxcnJtN1BDbHJBNjAwSDg1VzhBei9PYmNnWjdNcjdT?=
 =?utf-8?B?TE5rb2RzNHIyb1pmREMxaDc3OHZ2a1AwTHZXMFpQQ3c5NVZlcVRiSWhXNzFn?=
 =?utf-8?B?RXAyM0JEZ29TTHd0TTZucTBBeHlKTlBMYkRZQzBjQUIvYy9mUWIzVjlEaW1V?=
 =?utf-8?B?VkNXbVRpYTRjdXBKbHZWd2grdHdkYlBERjArTk9xVGpQUGlwMXZyZm4zTjNm?=
 =?utf-8?B?RWx4WkFEQkVROXBJNno2NjFoWHRtVEtDS0JhZmdSdGlmOU1CSDdBSGtDTkMy?=
 =?utf-8?B?SWoybkdsUTlEQnBJTXBZbFM3NCtlN3k1b3MyR3JlSkNvQ0VmNXdydk93TWFw?=
 =?utf-8?B?RkRLZmVSaWpWWWxFWnRxZkJYemk3bTA3N3l0WUZJSURPSXJ0bVU2VmFiZEVT?=
 =?utf-8?B?czR5WW82TzNKZUFrTzJuMllodXY1cXcxQ1JQK2F6eXVtS3hZS0p5NituVkkx?=
 =?utf-8?B?ejBRbitSWlJiYm1PaTJpTGgxODQyU0F4MzhNc3oxcFZURVdhc1VxR1l4TjZl?=
 =?utf-8?B?MElJTHVqNkh0dmx3cDg5a1pXbmtSNXJmcTlqVEE3K3hDZ1NCZG92dGFxWUFT?=
 =?utf-8?B?dGl5Tk9KTEgwWVRuRXhPUjZzTmtoODl0KzlOTnlWb2FrdTNuYkxlL1hGcjZ1?=
 =?utf-8?B?Y09pcFA2WDdDNVVBZVo3d3RvTkk1aTl2U0ErUUxxMUg3MHorRVlRZmN3WEVY?=
 =?utf-8?B?NmpoRWgwbkVrSXZYeTU0Zk43eXVnWDdGYW9pbHZjVTNGMXRTcnVBYXRoaEFI?=
 =?utf-8?B?MDJscFl5Z3k1YkQ5dkpFa08wK0cyRmpoVGUrSHFNUGJWTS9yUU1DaFRCSXpK?=
 =?utf-8?B?RW92THJjOEFEVVFobWRtTDBZeEFrM3prWFJnNmUzQWJFVUl4QnZZNzRiSGIy?=
 =?utf-8?B?a3FUd05rNVA2ejIrdDhCSlAwYUxOcWh3cDhXZ2xqL3dmM0ZmOERqdVJyekxV?=
 =?utf-8?Q?kpc4qQdNzc7N/4AeK4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfa823da-839d-4932-0105-08df402bc23b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5310.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 19:41:19.7648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pSak4EOe9Br8o3MlV8VgDyE7nSGuv42ITv/zs6DAcp6xLep4QlNEs9E0s445AGs9LThn6TyWjM1uU8Kvo451SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8584



On 11/11/26 5:57 AM, Herbert Xu wrote:
> On Wed, Oct 21, 2026 at 05:05:03PM +0000, Pratik R. Sampat wrote:
>> Implement SNP live firmware update using the DOWNLOAD_FIRMWARE_EX
>> command.
>>
>> DOWNLOAD_FIRMWARE_EX requires the legacy SEV platform to be UNINIT. If
>> it is WORKING then legacy guests are running and the update is refused
>> as busy. If it is INIT, shut it down, release the buffers the firmware
>> owns across that shutdown, run the update, and bring the platform back
>> up afterwards. SNP is never taken down, so SNP guests are unaffected.
>>
>> To test run the following with your sbin file in FW:
>>
>> echo 1 > /sys/class/firmware/sev/loading
>> cat <firmware.sbin> > /sys/class/firmware/sev/data
>> echo 0 > /sys/class/firmware/sev/loading
>>
>> The COMMIT bit is left clear, so the image is only loaded provisionally
>> and the admin decides when to make it permanent with ioctl(/dev/sev,
>> SNP_COMMIT). To roll back, do not commit and upload the previous image
>> the same way.
>>
>> Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
>> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
>> ---
>> v4..v5:
>> * Report original firmware error on rollback failure - Tycho, Shantanu
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 297 ++++++++++++++++++++++++++++++++++-
>>  drivers/crypto/ccp/sev-dev.h |   2 +
>>  include/linux/psp-sev.h      |  19 +++
>>  3 files changed, 317 insertions(+), 1 deletion(-)
> 
> Sashiko has a comment on this patch:
> 
> https://sashiko.dev/#/patchset/cover.1792599491.git.prsampat%40amd.com
> 

Thanks for pointing them out, I had missed looking at Sashiko.

I'll refresh the platform status before sev_fw_upload_reinit_platform() to fix
the stale version report.

Calling sev_get_api_version (or a new __locked version rather) before re-init
should also close the short race window.

I'll respin the patches with these changes.

Thanks!
--Pratik

> Thanks,

