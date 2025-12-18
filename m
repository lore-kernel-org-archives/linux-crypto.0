Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BDA3101A5;
	Thu, 18 Dec 2025 18:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766082369; cv=fail; b=BRU6nGwQWagpXUCd2Ljv6aoM2JcEMiXGoiXiUdNS30ty9vYb12CqxMtez3jf/JRmzIicZRxAfsgf5OaXc5PSZqp2hk5Kgc6B4QwaHsusThQyM8XmGpQbVXR4zP4InSnXRta7XIDiULbHJmjvsAlCWudZcXPK16E250sOvKZAqHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766082369; c=relaxed/simple;
	bh=chRll4YiF/LGktXoWHEiS4qlGxFs4r/l5YtIOrlbR2g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q+ghlQt8mAplzcq+HKKO/PHDsX1nNSzJ7tpMLysWBp8pVDJUjwzU1HlV8bosgXXvqnHUcQxyQQTq3kGZiWucVQ5CqiL9QqQc1mIVbks8PicxbGeBoxrmRTELIHV/g4g4zlXNlNa5cCF4gZC+Y/81yLMY9HGDJwXdF6GC/Qzrh58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DaBjjmw1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=v7zl7M3t; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DaBjjmw1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="v7zl7M3t"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BIHg7Tl1395068;
	Thu, 18 Dec 2025 18:25:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MhPiSBw9WSD+mAV6kqpdj/82M6k4LWWeKC5AF7UKsBU=; b=
	DaBjjmw1tHfXDhnBf/eVXoiI5tbWsMjg5n9VZYeurLiSLGMoo1sU8SAPmpVpFkk3
	vHt3y94ikzhXE3a6+YWst/K/T8EiRNndlqkItA5OV/+Y1tIiaxiYPW5Fs+Cn8lAh
	D4H7Op/OkFKwsncPcT7RvuGZ7DGZz2mSYOTcm0/k2TGyXt2k//Ua7mRyH9tpZibV
	qbMuTd3Q09vnxC6ZaDzLC5JR3unCrc5yq6w5mbc9prffUp3N0NxzdsdiNsONphh3
	/1o5EUo7T04B0QZMTIt+xsD9z+cED9le5l5FCzuPoJjZUm0/d868qgABMIdJIeAB
	X5cBlH1mf+9SaJx44QAsKg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xja889g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 18:25:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIHFrkH022456;
	Thu, 18 Dec 2025 18:25:56 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011037.outbound.protection.outlook.com [40.107.208.37])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkpa88q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 18:25:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GdiAeIZjBxtgfhCV6a6M7zc5zMk72V5hM1E7F2a3aEynF+x0yEZsN3se+frg0VK/u9ueGKsJ+tTufciwbVHRQOFM2oRF2cGLiFmgnPZw2qdp6uwA8Yo+ppX8naTFnRI3V+JDqcmDKhQfwuHXEEHF7dOFiwcp99sP1AK0CEfxu/1xSOBQb+AnSlYeTYZcGapPhj602BpIg7aLBuQ6pdOUQCK8QMjEfnjgMDkNTYY8iix9RrX25vQxs5ZWdkac+gT8IV19xBkbOfy076oi43DOZY83W4spegkZVTmJPex+MpLvhx73WZ0i4H8SmgTUp7u/jAlwVVc3JD+6h1tS8W9UEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MhPiSBw9WSD+mAV6kqpdj/82M6k4LWWeKC5AF7UKsBU=;
 b=tpSsjQ0FFp8uNAK1UPVNU73rpN4ZKm2JkscZcxWiCJ6j6ldAsfCR2FQUFoMILeC/xmsMhqihXx7Ue57b83+CzLFa3AUd3zIY37CLmIYsXPLPQVKDvq7najJtL+25ubPdHEQIWtfF167htSr/S59RVJ6h6YTT+X4eER33nXVjAkhcA9I+p+GZrQ6JB+0pCm1hHHuALnv3lC9vMur4EAC5/ypBkxjAdqblM2OrqBN13W69zWnjV2SvfoY3XUrq9EiekMWpejTsqfz+VEfvxQOhmU28JJ/lSuUxhpzPZXsGU8PIJM76fpksAby4gN3G6hJZaptSWIbU3HwiIMX48ISkeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhPiSBw9WSD+mAV6kqpdj/82M6k4LWWeKC5AF7UKsBU=;
 b=v7zl7M3t6H1yyPAJfBvvCxLGR+40nQpwCsJdxhkhudWIrmHEyo1bxuHEyAZYnVApop7AWeqnVMTSCV429cN4+VP/6HGyvqvSk5jY+bT0xETMa2+/4TlLaaBa7uCzRUFYik7Gyy+i9dJe2waKDpQ5BOkvmCiNJT3dHWx84gKk3WA=
Received: from DS0PR10MB7224.namprd10.prod.outlook.com (2603:10b6:8:f5::14) by
 CH3PR10MB6763.namprd10.prod.outlook.com (2603:10b6:610:147::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 18:25:52 +0000
Received: from DS0PR10MB7224.namprd10.prod.outlook.com
 ([fe80::c57:383f:cfb2:47f8]) by DS0PR10MB7224.namprd10.prod.outlook.com
 ([fe80::c57:383f:cfb2:47f8%4]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 18:25:52 +0000
Message-ID: <e69b2b27-af03-41aa-a7ae-c4e9c6fe5e02@oracle.com>
Date: Thu, 18 Dec 2025 10:25:50 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: lib/sha1 - use __DISABLE_EXPORTS for SHA1 library
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Jason@zx2c4.com, ardb@kernel.org, dpsmith@apertussolutions.com,
        kanth.ghatraju@oracle.com, andrew.cooper3@citrix.com,
        trenchboot-devel@googlegroups.com
References: <20251217233826.1761939-1-ross.philipson@oracle.com>
 <20251217235745.GB89113@google.com>
Content-Language: en-US
From: ross.philipson@oracle.com
In-Reply-To: <20251217235745.GB89113@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR02CA0035.namprd02.prod.outlook.com
 (2603:10b6:510:2da::30) To DS0PR10MB7224.namprd10.prod.outlook.com
 (2603:10b6:8:f5::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7224:EE_|CH3PR10MB6763:EE_
X-MS-Office365-Filtering-Correlation-Id: dbaa7393-c7a2-42ab-ad0e-08de3e62e060
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MlNDblR3bVpBQ0w1SHUxR3dLVmF3QmpBdzFiUkdSZDZWWFlraFpLVzJRL0hH?=
 =?utf-8?B?eHNPU1k5RUZQSTlWQzJ1R2dWaHpmb2tLa2FYUEd6MFl4VFAvN3phMTJmS3Va?=
 =?utf-8?B?b3FGOUtTR1FXRUNpcU1xY1p6K015UDNQN0Y1bjUyc293YXJNUFVEbkZKbk5l?=
 =?utf-8?B?cFVYN3NLTTNBL0Q1dEZRbU83UGRxVnNkOU1NY3UxL1h5MHpLVVUrYTk2M0Yx?=
 =?utf-8?B?TkFUaUZZdlFsMDhyUzNvYzNyaVMrdytNRUdFc0ZzUnpvS3RpOURhNWFHT21y?=
 =?utf-8?B?Tlh2ZUJ6bVFCUHNaRGxUcHVmVU5weWNzdWNvMDFuRlB5Nk1PWnBPSUUrV2J3?=
 =?utf-8?B?OWh5N3YxbWNLKzZ0Q0VXTGdQaTFicm9YUmphTmtNYWY3RUtoSU12TFlhMEp4?=
 =?utf-8?B?NFF6YXlDckJncW5kdjRMVzI4cVNJNFdsSmVIYUxnVFZ5eUFTTXhpM0lZUy81?=
 =?utf-8?B?OFhrOThjZEliVkRzcktxaFdvdFZ3SWx0WkZjNEFWbkU1Vm8zVGNTVXZNM0FG?=
 =?utf-8?B?UUdrSEVEeGdGTU1MSDJ3SFpDUTZrKytrazA2MFJObjZWdmk1Y3M0L2tVbitP?=
 =?utf-8?B?TmlOOFYzSzlFc1dPZ2NhbUp4K0F5WEp6a1JlaUNJMUtnZy9OcFFQb0RZMkM4?=
 =?utf-8?B?VmNWUXNNeUM2NW40MXpWZWJXSWJoN3UrNFpYREhkYU9hSzJiK3lXdHJVK2I5?=
 =?utf-8?B?RXQ1RzdtbTBmUFZoNUI5YTR0RDMvRk43M0NPRG80NUg2Rm5ZeUZESWdpWTBN?=
 =?utf-8?B?MnJvVk1HdE9GV1pOVGMreXBRV0JCQldGMXJHa2lOSG9lbERXSmMxRUlPdTJH?=
 =?utf-8?B?R0o5eFFyTmRJNHFwY1Vmbnp2R0FER0M0dEtGcWIwelJ4UjlvOFdVVHZTUHZh?=
 =?utf-8?B?UnNHaTZ6WWpVZFZ3dk1FRVBwTFRyS0dQWXhjdlhGT3VQbE8weDVBVVlQNk1U?=
 =?utf-8?B?WXo2cElhN0VoSENreUNNL0J2OGlxVUdDRHlGY1lzWEpQZmp2bENLSkpFODc5?=
 =?utf-8?B?L1MrS0JxZGhBRVRXUlg1UmhyT2VzMDVNTGRwQkh1VXBpNzg5Z0JMVGtlNlFs?=
 =?utf-8?B?UEEwYUVkbGVSazNOa05KZURaTEVDOVFUakc4dFo4YjFsOE9ta1dDK2R2eFY0?=
 =?utf-8?B?SjRSa0VNdzcxSmJpU2RmY09jcVU2NytxR2pvNFpsMzM5UGtlSW9yelFoYnlk?=
 =?utf-8?B?RzUzMFlXS2FsaVg3VjVaemRRU29rNm0yODBjajBDNnJ0YnNuaFM2MGVZMHkr?=
 =?utf-8?B?emVQVW0rZ0NhRE9qYTJURGNwQWg5SW9Ga21WU0lIWFRMVkY5Z3lYUC8ydThQ?=
 =?utf-8?B?cjkrWk5ScmZXYVBDMjdJZncvWWhmT2FBTGFBVHBFblE0MGN4bzFNV3dpb2dO?=
 =?utf-8?B?d0Frdi9CbktneU9ZRmU1aWJBSEhqL3BLdWlUOXlMSnJIZ1I0U2dac2gxUXc2?=
 =?utf-8?B?WDFVRXBpd3RTRUdMbHF2bmhvQ05Sc1pRbXQ5QWJsQks3SS96UTBlcHUrT1JQ?=
 =?utf-8?B?ZDR5RzJaeDFXdFBpbnU5WEV5RkdYZWxiR0V1VXZERXdqYndGRWlWTTI2Q2pK?=
 =?utf-8?B?Snp1K1kxaFZHWUZrdUd6TlB6SXpQQS9xZ0VHUER4cmpSVy9pN1RKMTlob2Zr?=
 =?utf-8?B?bEJ1aXdmZTR5Ui9jZFpKeEx2aDdqNFhVU2VyUEZTck5MYytMV3h5ZTNPMHZ0?=
 =?utf-8?B?R3hRWDkzU2JhbWFYQ1dMQXhFRm1jdHAvTXA4OENEYWJ5TXk2MlVoODNlUFpS?=
 =?utf-8?B?NjhWemdHdWJxTXBnbTR1aCtzb1IzaENTNks0QmRlZHJIL0VTQXVRemkvUDVT?=
 =?utf-8?B?VzUvQ2FNV21QT1Z1elkzV3Y3Y3BmM3lWQzF0d1pGK2poVFZHdlQvQ2RRMUV6?=
 =?utf-8?B?WkRTS0dxTElTbUlKOWZiaTMyTks0N3pTVlg5L0hYYTQ4M2tYVk1qSlRhUTgy?=
 =?utf-8?B?NlBKaE5xejBHK1liZkc0ZDRQc3VLUUYxR3pGV3NFQXVjdjVHNDZEeVVmeTBF?=
 =?utf-8?B?djZNRlFNVDhnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7224.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bm9LNWJLVWFPMDJMSlZtZVg0VldFZk5LaEhEOUxFMklyekRXSW8veEVCeW9T?=
 =?utf-8?B?V3didFpycEc1NW1xLzFPbmxOb1IwRW44UHo1WUxVNTZsLzhjcTFGVFZDMWdZ?=
 =?utf-8?B?b01ycjcrK3drRGMzM1VNdzF4Wm0rNUlrem1seXVLUVFPVUlPMGdJZlhCc0pH?=
 =?utf-8?B?VWF4U0UrZHZ3V2EzVmRvL0cwK2x3VUhhaHF2dUc2akxrdXptOUtGQndPMzVh?=
 =?utf-8?B?bTNyeU9jSW90UkwzeTlEWmtBdTh4YmZNNjhCUS9sazZsZGU0VE9lNndmcFhX?=
 =?utf-8?B?L0p5SENnWVI0VzFMUjF0WExnbGR6bmQ4S0VKSWxTOGNrMERUaUFGbmVBb3Rx?=
 =?utf-8?B?MFZXbzRxQVVZa3lhWDNFaWJBUVR5MlpBekpTK0dOZTBRSitmU2NOVzUrbVFJ?=
 =?utf-8?B?OGtESUtxVm1HRkh6VXFIUmRmSE91Wm9oSkJ2b3BrVWdPcVpzTVNReVRMQ0lZ?=
 =?utf-8?B?aXF6c21hOG95bEtoZDM1MmEvcy9pc3hqK1kyMmpDYUN2SlRScUphb1lhUW9v?=
 =?utf-8?B?cnZlbmJzbmxza3NRR1ZUWTZZOFJndDhxT25PV09WTkQyWEhzM2tUWGhIZ25J?=
 =?utf-8?B?TTc3M2NOTng5eE1rRHFMK3YvVTFIS2VORVNJMUNTY1c2Zm1jOVhEVmJwRXgw?=
 =?utf-8?B?Qlkrc2RVOTRyejkyK2x3cW5EdVNiSEFHKzIwWWdydERjeGtkdTVLdFBXSzFi?=
 =?utf-8?B?ZVVvM2gwNEpRTTArbzlUZ1dkRXVDVGFzK3hlbkJza0hYQzI4d1QwYjFSczFn?=
 =?utf-8?B?Rko3Z2xpazNZc1dWdnZpZ0pNcHpOOW8vNGlIMDJiVk9xOGVtUEZkUGsyZVRp?=
 =?utf-8?B?eHpuN2Z4RGVXUGJ6NTJLaUdtb0gzMjFVYTE2bUxnV090NjkxZmVIeGFLRHVW?=
 =?utf-8?B?R0dnNlRnU3ByUVNjUU1HMXY0ZEVpT2xvQWMwNTBjZXN1azY3blo2aFpJM3N6?=
 =?utf-8?B?S0NEK1V4WVl4UnNDU2V4cjh5OTRxREN3aEptUkU4VlhKS0gveS9aOHNuRjAz?=
 =?utf-8?B?cjNZUjNmVmFCOU9CVCt5QkFLTTVwd2hmZE9pNFNUSHo2NzBIMy9Id1FqU3Nh?=
 =?utf-8?B?SjJsK2VZZHdxTTBOTnQ4Qm8reS94MFBmZFRMZWpMQW84RnJEKzM4b3FIbTRx?=
 =?utf-8?B?d2FQU29LNkpmSUFYSlhuOSsxTnBsRXV5T2FrL1Nza0ZMblI4Qk5ia1lwQjZI?=
 =?utf-8?B?SGFPdk80MGc5MGlvN2JTOTNYNC9wRmRia3lnZmlUVFpPTU1PSFBVcndYMnZ5?=
 =?utf-8?B?TFJHV3JCaTRSNkppMGxNQnErdUhtVWVVUjBmQkVZakd2Q3VxYmV4UEszb3pz?=
 =?utf-8?B?Si9PbG83Yk9OcFlmZzRtYVJFcGZ0T2lHSmQ0cHdpTWRNMDV5L1QvY1B5cmF2?=
 =?utf-8?B?OGxRanc2aTFPenc1VjFlc2E0RWpYUlRiZXZoVWowY3FNVnRmUUpWU1lMdEx2?=
 =?utf-8?B?b3BCUXRpNG8vQ3U2RDJHUDZUVmx2ZlpsdVkyTkRpc3V6QlZFLzF1YXRldk5F?=
 =?utf-8?B?RlVnYjFLU2hYb25tRUU2WmwxSUlUYktWQzdST2RPSHBOcWpHVzhKNXh5RG8w?=
 =?utf-8?B?VHRweHhEOVZMYStZalJLUlJSdk9NeHI2OUZFQzVDTCtWNGdQeHQweG5XWFNO?=
 =?utf-8?B?Y2h5aUgwaWRJUDE2Vy91RTF4aVJuNzU3bjR0ZTFiKy9xTy9yalFQYmd0eTJ6?=
 =?utf-8?B?cnNFbmgxQ2xFbkF6UThlVHNsWk9vMHQxNUFwQUhIV1pXRnZoUzdQcGtSVnpX?=
 =?utf-8?B?RE1pYnI0OGFJODdNeEJIMkF1eGRwdzhDV2huWWo3Tzh5RldYSTFXbUpwaGll?=
 =?utf-8?B?enRyaUlLQUQ2b1dGdEt4WFZINFRSQVp2a1JiTFQ0dndBbC9pK2RBUy9yVjNv?=
 =?utf-8?B?SUxqUjB0VHdQbDkxQ0lYY2FnbzQzR1BqMUttRnk4S3ZsaDhWd051bXhrMjYw?=
 =?utf-8?B?RGdGeXhMcjJtclJVa2h1LzdyMlM5RU9hWXZ3WUIxQUdsMDBrV0NKcUVwRGpZ?=
 =?utf-8?B?TVp2L0tlM3lyT0lKZUwxTG5mUi93SFowLy9YbjlEajRCdW9SS2hsUTdXckdD?=
 =?utf-8?B?bk83eDFJTzl1VVRnSFBvemU5VmZrT05zVUZBMUtPa09mRTQ4cU5HUHhmNm9u?=
 =?utf-8?B?L0twKzdJYjlNT1FOSkJwNFMxT2J2N3ZhUWpoYWVUVjZOemtQbEdGOWdSZ1Ay?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZObgcdl9Y5czFVGCU3WsZ0g22OLUvJ/RrAtGYHZChmkiBauJxCW8Q75C59OtfYuAaZk9iU+UTAa69rbsMsi0Qo5geddM8fe0V/2wNjGo9oPKXKaS0MhKQ1l+Sfj/GHXB72lyep9Dg4amB+TPrv7L4MnCZxJrbtIBVTDGOOtm0cgmKqlvNc188wcCM4QcS9YkJF+AY9rgfhAmJl9Rm8M/kmlerr37Ecnf4Dyi4fQqPjXqdUOFOtk/h/xrz0iIbVPCt+ei+rAARufCegekpO92ytwIsUjrOpyTHXgMvyO6LjVuMg5UNsxltXcl8Pk9na7bo1E3Kbs2tTMC3O0/DHjgLm/aTvc6KVOwNtlMb3tWc4pgmMEp0UVK0mv0VZXVQFsR23VxtRhllXWNZxXCLFoJZBuCzs1187w1wM0AfK6Xduy3Yd1fjd549jYNtXJlCc9TmxBwMa4/BsOg95ARd6R2LYJGwBqcpVOGir8Mb9PJTPyfO/T5ysM0LkjlJMEbsdCFxz3HqmxGM6qIQS1Jr/nRz1wbOmosCj4R5zapzorISpDwRnYLENdtc1impBejjdjes9kyHer3XToOyynDGg2LkWKhsLwkMqvWyuo2nfQzhPg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbaa7393-c7a2-42ab-ad0e-08de3e62e060
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7224.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 18:25:52.6719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lL+vnEy6NVqRx8aAdmaW+dTxoCiUcxDPl3zq5OcIFpppF307uOdQorG/12QteN0v266Kg6N/mU5j6TDeUGNzAW5Leab8uouNoIOE2JrjD+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6763
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512180152
X-Authority-Analysis: v=2.4 cv=TbWbdBQh c=1 sm=1 tr=0 ts=69444735 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=zGqzPf6a5MmwXQzlNkEA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13654
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE4MDE1MiBTYWx0ZWRfX9tKB7x6KLZ30
 TrCXVYBKmn3sqrlR3SpzMxUfWkipON/y0adYwLqpoIEJABU5HG6IH1KdCwr0+6fhhGXoESkHAmT
 +tssvXu9fhnG0/qT/c3k0VU6XF0Z98WZCZnFUzURUFhIQZmuJzZqvD70GhbTHjYuePgmocwx3xd
 GhGR4TlFv9KHTmPOGqqVC/xq2WBn+neYi6xplPlS1tfhnmKkYvm9hiwtQ38nWSzf07GQG9GSzZ7
 ue3I2oU10JzSPUpd3BUc024pTpCSGEilCZpHxa4o4/WDejOejllWOnkWcO53ilwWpMr0QbPdf8N
 sVxF/aSswKQ5YEYnYE+qxcXnSLqP5xh5GtWZo5JjBLoVXRka4QNdSc5yoe9QCR9gVU4OwX6YSwT
 1+wgZRY5CQj53Ze6UDaCbnOJfupHriEbc/k+dgGYpReJU5b3jYo=
X-Proofpoint-ORIG-GUID: D8uoBWoXosx_SFYI9QRTUglvTUxUP9df
X-Proofpoint-GUID: D8uoBWoXosx_SFYI9QRTUglvTUxUP9df

On 12/17/25 3:57 PM, 'Eric Biggers' via trenchboot-devel wrote:
> On Wed, Dec 17, 2025 at 03:38:26PM -0800, Ross Philipson wrote:
>> Allow the SHA1 library code in lib/crypto/sha1.c to be used in a pre-boot
>> environments. Use the __DISABLE_EXPORTS macro to disable function exports and
>> define the proper values for that environment as was done earlier for SHA256.
>>
>> This issue was brought up during the review of the Secure Launch v15 patches
>> that use SHA1 in a pre-boot environment (link in tags below). This is being
>> sent as a standalone patch to address this.
>>
>> Link: https://urldefense.com/v3/__https://lore.kernel.org/r/20251216002150.GA11579@quark__;!!ACWV5N9M2RV99hQ!NYVuWrBT2adow7b4eijfE5vI_FKAu7wblBsmNDxouC58woEhQhR4m9sOXOpa9xBoUtLLinpXb3T_AUGlTF-nUG5IjA9SszJw7g8$
>> Cc: Eric Biggers <ebiggers@kernel.org>
>> Signed-off-by: Ross Philipson <ross.philipson@oracle.com>
>> ---
>>   lib/crypto/sha1.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/lib/crypto/sha1.c b/lib/crypto/sha1.c
>> index 52788278cd17..e5a9e1361058 100644
>> --- a/lib/crypto/sha1.c
>> +++ b/lib/crypto/sha1.c
>> @@ -154,7 +154,7 @@ static void __maybe_unused sha1_blocks_generic(struct sha1_block_state *state,
>>   	memzero_explicit(workspace, sizeof(workspace));
>>   }
>>   
>> -#ifdef CONFIG_CRYPTO_LIB_SHA1_ARCH
>> +#if defined(CONFIG_CRYPTO_LIB_SHA1_ARCH) && !defined(__DISABLE_EXPORTS)
>>   #include "sha1.h" /* $(SRCARCH)/sha1.h */
>>   #else
>>   #define sha1_blocks sha1_blocks_generic
> 
> Shouldn't this be part of the patchset that needs this?

The way we read your comments on the TrenchBoot SHA1 patch, it sounded 
like you were saying to fix the issue directly in the crypto lib first. 
We assumed this meant a standalone patch but if we misunderstood, we can 
certainly pull this in our patch set.

> 
> Also, when __DISABLE_EXPORTS is defined, only the functionality actually
> used by pre-boot environments should be included.  HMAC support for
> example probably isn't needed.

Yes we need the first use of the macro to correctly not include the sha1 
header. Agreed on not needing the HMAC bits. I can drop them out too as 
was also done in sha256.c.

> 
> The commit title is also misleading.  How about:
> "lib/crypto: sha1: Add support for pre-boot environments".

Ack

> 
> - Eric
> 

Thanks
Ross
