Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9583A2222A1
	for <linux-crypto@vger.kernel.org>; Mon,  6 Oct 2025 10:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759747499; cv=fail; b=otMJ0oP+wxrZuAf4jQZ14TfwzQ8mzybeM5mQHc/vkz5sP/TEnTh0O70PH+U4RTneTcGUoDSfOaHEpg2gcxtGCKhW7mHIlKpz2VcX/YNT4ZNhds+UMx9REMgpNLjQBsfhAgwfNxT5QLBwIOIx9H7UDM2InxkTnsuhMy3ePoHcCQw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759747499; c=relaxed/simple;
	bh=Eu/HHJ0ksTCiYKJ72SqfEnwqcOEg8MieM4eotXZiAxg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bFwCf8JlZHsoLp+L90fzlToI3wE7u7AjiWnzQmp5jRHaKVpRGz91djZNoNZpVu5JnccrxKpbmUlZRq54SF+1zhAV7Q41nSbvDTZrdM4EZ9Azlt7i+Fui8obgGXtlNb+dJRaqkbbAgLcTXXmEWs8GTEGPqZUbTNdzpkBVVhUWg6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YgKZ0jlU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PRJ3/CiH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YgKZ0jlU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PRJ3/CiH"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5968u0IS028331;
	Mon, 6 Oct 2025 10:44:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Eu/HHJ0ksTCiYKJ72SqfEnwqcOEg8MieM4eotXZiAxg=; b=
	YgKZ0jlUYwZjCqaKNI5DHgwFQIfvRi/ZWkluhpCBEkEXKEonTSGbtfzEFpCQPTxY
	Sny0DhdnDuNXFRnNYdlJEIt6J7dnX//GObJyuA36S50kj1IUfUgV9WNYkXTmpedY
	/DNAZf1Ji+ObkrpU5A2rkIUpwk+gK8NIzM4k8bCYs+Rhg95SxRIgHiHutF6qSr4R
	iYbtJGo0mFWUcItxvwMJi5AX3W5r1pAwNb2Ve8yzA592aXtnyhEXOaJzVyyZ8uKx
	ks30zcFV0neqyTXpd3bk1ZCB6bOxmCygthl+ShoQVsmtNR+fz5WSV4RW5blTGcv4
	cBfhgnMMmLHCPuy35Fm8fg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49maeu86et-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Oct 2025 10:44:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 596AM4r0028613;
	Mon, 6 Oct 2025 10:44:20 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013057.outbound.protection.outlook.com [40.93.201.57])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49jt16nwa7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Oct 2025 10:44:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FAMyS6/fIHEPnIREcadj102q6iJpxzJm+J+Qj8BnhRFCR8Fi5kTZr6aZ5UhbjwNj4Bo+Tl+lqOj7/Ze2sOHzx1lsSCKAvmMYPE8XRUGm9DgrLHFt0yfxErD78BRXCPQwDsO4cLu1zCSfpDh5u1XKghvdY604ODT5+O5dcAshLUguNMf0PTssajWTFZx5CKVe+EGUEs1eyyxg0oaSHB0/obwZ/n2IrMAOY0/bXVXjaLY3kvg32P6zbB41knw6RwhCVEAb+ij9vP/esk8/xHIZUAnMnSqHWTjeW3w4vha2V/kC8yhcx/d21rlNxRCmLX5WEn9ByzlhLOhyNZVgGHWV5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eu/HHJ0ksTCiYKJ72SqfEnwqcOEg8MieM4eotXZiAxg=;
 b=xmOdfAYWt1UZbatMy4wyj920lkXCsDVZ8Ok38gWw7Lh4P7N8ywuMjtYpgdGGAbK/kw+l2VTbe3R1rTjDJ3EQHqLPh3BGF2JWPy7xbcv0VGsoj+JALkVjX9GMhOkXyxUb/GaeAcBVd5e2Sc3hRCqtu/CrSiy59dutFRiV2FbkhfXs8b8E8RAhJzfiTg0DVImNiKuy/a+br7GLX2gy31+HyQU3heyNSRgR3rVsp5vbb/zQYuApkgSJJBkZoLIK8Y6CkyXRC7CqYac+NcmjraKZMumqTOm6EyGv9gOgOkeFUBMJUv9ELRtuPm9Rp23vMxFraPvmv7FcKQzxFubay4pBwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eu/HHJ0ksTCiYKJ72SqfEnwqcOEg8MieM4eotXZiAxg=;
 b=PRJ3/CiH/zoda19Jf24J/9OIdyxvmVZc/v+xSrleGRhCz/itW4Db8IF3bpmulwA2aWi1h7kODhFMz09vE//ecmDtZb1g8J1T9fyOsdEF9UStcXk0+95o6+uw/hKXWFf5Ycl/INLJAlpfEPJ8RE5atwiK/E/5X/Q2F/w9nI4wxX0=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by SA2PR10MB4793.namprd10.prod.outlook.com (2603:10b6:806:110::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 10:44:13 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%4]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 10:44:13 +0000
Message-ID: <45ed5ca2-f371-4030-9fc7-0a8bfc142b41@oracle.com>
Date: Mon, 6 Oct 2025 12:44:09 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: 6.17 Regression: loading trusted.ko with fips=1 fails due to
 crypto/testmgr.c: desupport SHA-1 for FIPS 140
To: Eric Biggers <ebiggers@kernel.org>, Jon Kohler <jon@nutanix.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Marcus Meissner <meissner@suse.de>, Jarod Wilson <jarod@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        John Haxby <john.haxby@oracle.com>
References: <20250521125519.2839581-1-vegard.nossum@oracle.com>
 <26F8FCC9-B448-4A89-81DF-6BAADA03E174@nutanix.com>
 <ec2b9439-785e-475f-b335-4f63fc853590@oracle.com>
 <C9119E6C-64C8-47D7-9197-594CC35814CB@nutanix.com>
 <20251004232451.GA68695@quark>
Content-Language: en-US
From: Vegard Nossum <vegard.nossum@oracle.com>
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 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 8A==
In-Reply-To: <20251004232451.GA68695@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0183.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:344::10) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|SA2PR10MB4793:EE_
X-MS-Office365-Filtering-Correlation-Id: 92c5805f-08eb-4e59-eb57-08de04c54a15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N2xGRHlwcmxnQ1Bpa0M2L0k2RDFndi9sQURHOGFaWUdQSU56RGVqc0Q2QU1K?=
 =?utf-8?B?MGF1Z2VjZXBUR3FQZWErUzBiNU5nM2lJd0VkQkE1TmVzczVTQzU2aVc1MlV2?=
 =?utf-8?B?cjJYU2tsTXBwNVNWYzVJNm9melZIdlBuencveFF1SE82WVBwUWNCNS9wYTBk?=
 =?utf-8?B?VnREU3U5cU50bkI3STdyYVNGNVZqYkZNK0ZUOVV0V1lBUHNnSnpkMklFTDRG?=
 =?utf-8?B?NGRrd08xYjl1OEk3bW9JSmFGWTNOR0tnWlNIMDZhWml6UTZHWHdia213Qjhu?=
 =?utf-8?B?NGNsWHNBMUp0WWViS1ZpeEtoSW1BTHMxc0ZvTkxHaEZUdzJxUU1BZUNFV3Jt?=
 =?utf-8?B?Z3FUcHB0OEFEaXRmTk9PTDN0Ky8rTmZzdG90UEg2ZUFQR0tjVFFDRHlsNFVa?=
 =?utf-8?B?MDdVWGJ0cDNlVHo4V2h3bHFuSHdQdkRJYWVpOHBXd0VBdisxTlYwY0ZsVy84?=
 =?utf-8?B?ZU1QbzFPdTRnaEhXKzFpbG9zcFhYcmgvOWwxMG9PUTZhYWJNbzVPQWUyaXhx?=
 =?utf-8?B?V3ZrNEdwZkVoMzZFOG01M09seVVmKzFqcG5zR2VidnY3d25BT081UlBIdGVS?=
 =?utf-8?B?azJSNU5lamNnVmNBeGE2Ynk2czlEOWpRb3hWczc4Szl1Y0ZjWUF0dU9BS0ZE?=
 =?utf-8?B?clVIVVYvcVdEZEdyN0Q5UkJhcWxNL292ZEFybVZ6cndoY3dJdEFWRFpkbDRv?=
 =?utf-8?B?cVZSY3NzejFQcWR0emRFVDNlRnh3bkxxN3grd25wNUN6WFZjakhIR2ZGT3ls?=
 =?utf-8?B?cUZFK3RxMnlrNkhmcmRzaEpUYkZGUFRHeVRtRW5ONlVZUkw4OFJiMWFwQXJT?=
 =?utf-8?B?RC9FTlpkQzc1bFl0YjUxN2dOSVZ6Y1hjNThaNC9DWE9GcUY3TC9jT1Z5aU5N?=
 =?utf-8?B?bjF6TFhYMDY1ZjJIWVhjMkxYazhJMlBodm41VHhoOTV4MjZUUTB4QjkyTjJ0?=
 =?utf-8?B?UDIzdjh1WWFVY3BBQkQyVjJ4LzR2NFU0STg1RWJ0d0VxckZJVWdrT3hvaGFk?=
 =?utf-8?B?V1FXMHQwT0hXK2dpQmUyTHgrY1F1L2R2OE5xR0N0ZHlrSXFqYnA1elk2RUY3?=
 =?utf-8?B?Mk8xSkxsakcwczBmZjBRTkhWR2FFQVlQTkF2L1Z0UVZRWjZRUDR1SFNFWkJu?=
 =?utf-8?B?bHdyV256Z1RSbVRoSEFyVUkyMlpSektNY1cvSDRZNytlVWx6YlRHOUkxek9D?=
 =?utf-8?B?eUpoVFAvdTMrUk1vWEFTVHpKeXJOWjRXUEZFMWFVZk8xNjhmeDh2cWFvUWE4?=
 =?utf-8?B?WXhpeUV4Q1ZGMm5mODRBZnRaenBwcUh0ZXZNZ1cwZkZ1Q0hVOG5menJkVlpv?=
 =?utf-8?B?ZTE1bGpSWHRISURuV1N2TXZQQmhOQlRxTGE1VWtFMFdKTVVtZWJod0YyaWZC?=
 =?utf-8?B?SHAydnlmUS9qeXlCNWRRbUI0VFBweER0WFlJblo4S2hrRm02TWwxa3VtYWU4?=
 =?utf-8?B?NVBKdGFORnRGNXdSREpYRWVVUDN4RjFwZjdHZGU1cUd5YjQ2Tm9Vc040WDk5?=
 =?utf-8?B?bzE0MHpieHhkYkR0N0lZbFRFLzJLbmRHZDBVVHFMOUxveU4xUWFUWFB2WWNW?=
 =?utf-8?B?MUNkaHJpMGJOQVRxNThEejJjZVZ4SmEzellIZG9IQStUNlc2bk1NSzZGbk13?=
 =?utf-8?B?MVV1eFlmVzhKSngvMWYzYVF3RTc0UEtmTWl1Tk9BdU00YUEzUE1oL2dZWm8w?=
 =?utf-8?B?dlZteFhmNHlsVmtzRWQvMmppMmROeGZHYlVHS29VdlFFRmNPQWJORDlpVTN1?=
 =?utf-8?B?Z0JoakFNNUJQZ2tvL3ZRTDNsaURWV2t1OWlsaWFjSHRjNVcrdGlmdmlRWnJB?=
 =?utf-8?B?MWdLd1o5d1g5SDJab3FSTnl4cEw4TG1pZEJpS1VEY3drRHNVZ1pWRmR3WlM1?=
 =?utf-8?B?dXlxdXczV1ArSE45TkpsMjVNUHBHVTE4UG5OUEZabXZvNWJSUXMxRStLRGV5?=
 =?utf-8?Q?iQ6WZzUIpbYiz6I2rhPU755jjnBskrM5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bnMzczZSM3RkMXV2SnhzbDdvQnFlSjRXMWFyd2ZpdmhobXVhYlFvNFBOU0N0?=
 =?utf-8?B?VlhaZ2Z2NUJyZjVjWDNqUGZZSTZBSHg0THJDMFVKODNHdklJTU1UZFBOUzZM?=
 =?utf-8?B?UlFWRVNKR2szUnR1Y1pqL3ViVTBycWdQblFKdE8vQ3NHNzY2TXhXa01IYlFx?=
 =?utf-8?B?eXZ4bXEvSWtoL0QzbVVjdkczWm9RS3V4MVgrTHR4MEJlZ0FYTkpvYTd2Skpt?=
 =?utf-8?B?cWlrVVhSdEZnRkNtSHp3aEo4dklLcjBGTFJUYUc3NnNsYmdDaXYvQVl3Y0JX?=
 =?utf-8?B?VVFuaHNwbUtsWmphQVQ3Z0tMTmxPZzhhVldlQ0NCU1g0RW5CUVJwdjdteklX?=
 =?utf-8?B?Z2lXTXVwc1hoZTlwejlkeGRyb2ZidElCVVJSVmVQWTBoSklTcS9zaDNHbHZx?=
 =?utf-8?B?QUdad3hVMUxUMHZRWVFZb3BtM1hscWtyc0ZtWXZXR0l1bXNIZHhSM2VqT0xs?=
 =?utf-8?B?Y09ybCtscVZIWm5tUFR3dSs2SW9YYlJxejRnTmVqVEcrRGpEbHl5ZlB2em5h?=
 =?utf-8?B?eVA0RS9FS1d0RkQ1NDNCb2ZFM3dXR2lMMWZpVUlNd2IxZE5lY0Z4MlZuM2Z0?=
 =?utf-8?B?MVk0b3F4ejM0YmNMeVZaVXNiT0JaMlpZcEVVVGpqdE1STUdmcUNPVW95Mk5x?=
 =?utf-8?B?RlYxNjFaeFJ0RTAyMm5XY1lFRHV1Uk41M1p0MnlLSDZpSmd2OGVjY3dOeEZW?=
 =?utf-8?B?R2hoNkFwamp6NnI0b2JhcVYzRUorUkRDcDcyUnoyTE9KcWxVTHJOeEVoeGNB?=
 =?utf-8?B?T3ZjSjMrUWlCdEV1UEJhVFN2K1FXaFlhWS9tc1VqdUVMMkplc0pXVXdOc3hm?=
 =?utf-8?B?bUQ1Q3ZheWM1TEJDMDdnUDhheXQxYms0dlA4eDlSN25nbTN6UkhsVXR1T2Qw?=
 =?utf-8?B?RzJqQm8yeVRMV09EQ0ZnVkM1a0tjU3ZqdVpLQzk2eXJpMTRBbjZzZHZsZ1JY?=
 =?utf-8?B?ZXV3dkEwWS9NQjYvaFM0Nm4xRWJXVXYrQk9xVW5PeUorQ084U0p2U0RMR1J3?=
 =?utf-8?B?bTEyZFZvQmhyd3VVeVA0ajJLanl4WkEyQUQ2LzNlT2FBMlVDWmdnNmNMYnpa?=
 =?utf-8?B?VE56VTYrMU5haWZRYzRxMk5zdzhITnluT1ZobHVLQUNrcEEwVVB6ZVFHTCtU?=
 =?utf-8?B?SmpEQWNZbHRwdkVia3lxYXVYTWxWNXlEcDA3d0FuNVRnMGtDNEV3Y1pGMlRG?=
 =?utf-8?B?RjVYbHpZaXlJSDBRbWNyNDNoWTJ2Yy8wQTNaNE1MN04rbkNEbks2UkdOcVV0?=
 =?utf-8?B?QlMrK0FCVjdHeExUQTRmSXE0NGFhbzBIYU9UUVNxU0ZSTGNEc3JZTVRwcHMv?=
 =?utf-8?B?U2JRQkVRa2phZERNODBYN2U3LzBUTHd0VDF2S1ZYNnA2SUwyS29NQS8wS3Zh?=
 =?utf-8?B?d0pEQlJYVEo4NHAzRXlZNHhMd1lRa2ZsbmVEemVnbFVjMXhpV2JPS1Z2bzZW?=
 =?utf-8?B?L0MzZkVBQ1pnU1Y0SkplVldGNmxBTjBkZjJVSmo5SXdLSmR3WEZuZDhwNmV3?=
 =?utf-8?B?OUNtdkRjR3VtWVE3NzJzc2Irc1BVQytyVDNNTTF6MSs4OVAvNCtmcitZNmZt?=
 =?utf-8?B?L2FSSW83cnBGNHNsL3ZLMzRJbXZXMmp2R2h0alVMYUlFMkpWekZzclo1aER2?=
 =?utf-8?B?WmpmT0ZDMytUWjQ5aXVNVmhyR0FtYnlZZUlzTFc0UEhRR2RjVHQ0YXVLY3Zt?=
 =?utf-8?B?SkRscXRhVVlVSUxrTUpMbVlwNWlsS3crWEUwTS9nTGl4U25PTE15VGgyOHow?=
 =?utf-8?B?TWpDRG1zdGZzaEtZa29MR2NpOWVJK05ERVJrUmhwdnhzYmpRSmR4UTlTOG53?=
 =?utf-8?B?RlBtUU92ZjZabmRhbHJ2SkxNQjdlWW1sNDhCTm9aRk5RdkFYRFNZazFrMVIw?=
 =?utf-8?B?SUxUeEQwa2s3NHVlSk1VdVlpajhQTEJ5R0NOcnRkOWhOMUd1cjd0VVVwYXdR?=
 =?utf-8?B?WmpiNnpWNXFxYUZUd2hTUlFqRE1lMkNGTHY4VDZLQUhwSFQ1NWYzUnlWYmh0?=
 =?utf-8?B?Wm12NXVUajNXdnZRUkJXMExCa3Q3eWUzNEVTSlhFSXNhbWlBV3EzYURkQ2JI?=
 =?utf-8?B?N1lSbzlsUldneUNuM2wvSVZ6RXNLcXplcnd4eEMwZDhBV3VkTzJqYWFsZXVq?=
 =?utf-8?B?d2xYdGFObU5aVlErNmR4MUcxTDRBUCtGS0QzSWVOVlFIVEN3VEhIV3NMNThx?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DrrXqsYbwjNwEo/EYKJGG76Es6pKWeXun8ACiHaC6QO4i/j/d/5n63uZaK5L62BUsNxo79wn7buX4oidg6CXicdJDxgePq+s0LTSD6f8KackDKIffPRJ9YigTt8MXWEkVy+LQ9UTI2sEvaccSTAuNSSTIunvE18AZmKw9atcwwByRGyiQy95lxpq6lO5tUJPXxpw792Gxugd+goW6SectTzH9SnOg2XTGo2H2KIsUYP7tRuZv+Md/YjaWlGRPqs38f9gSw7e/mRwzPKnN/GhfoxsD5+iC1N+WCVMY42dapSHhzP/IKn+ne3CiNSUNSJjY8YE0Ffn0+FEszu2i1QInzlGb8Hu2MkxGG4na+pnL016n7fOrpQVMMbJOzm8W3UolMs036kHCcYwczHtsUW5lsEmziFXRrkAalvqzn01lwk8dlh31fYXuBknYoifBmLhHP80xA/d8a0OWQqsq6cqPr8MEsjyWaSWYYoII+ibfmgr04cVEUrQTjG1aJ/NDnFrQLvLd0J3omm+TH0GctrmTM7uIxEU3XrNSQHGOyxSWdJaPC++vc4w2kUgE+3fAtY1BrLSaR/zzFCwnHXqODHJpTxca8PxQ08j8ucDUSdDIck=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92c5805f-08eb-4e59-eb57-08de04c54a15
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 10:44:13.7022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AhpltWdiHVMTELOYjxQfYBNXJ61Tlq3QCHshRYRLJhk9R8LFHz3MSUT/V6DLkEeYDnfVNKPLMPJGyoFir9uaeT3+Hj2vAOlyhxxHFQgutwk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4793
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_03,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=968 spamscore=0
 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510060086
X-Proofpoint-ORIG-GUID: 8Obv9tLttFbIFoS-edleH48JtVnKCc4s
X-Authority-Analysis: v=2.4 cv=Y5P1cxeN c=1 sm=1 tr=0 ts=68e39d85 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=E0f8PibGMHfFMVJ22vYA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13625
X-Proofpoint-GUID: 8Obv9tLttFbIFoS-edleH48JtVnKCc4s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA2MDA2OSBTYWx0ZWRfXwh0YH/ECzJmI
 s0/OHM11lgT1zSiksL5mrKtdClAOAkmaH7lgVwMkinTvjZ/B4x/TJaTsE5qJGxT4UVvIQQhakJa
 51SlFoylJUWGiiZAFTFTwb5QmnPkyYY+LPxotPWGlatr4yFNZBA2a8+WmcxZcOnY8/+SW3Lh4ij
 vfahHkKCl2QJeYnIhVxy6BgeAq12OeYgcpqldH0VxcjMEdmgeKJX94uVWWnIb0iqv/clczFKYL5
 /PSzi7/2KL2CaYA05Pu0zUmPj+s3iq+ONJrxYxthOerZUg5Q9amKkvO5l1nPoUNoAK1z1ip/yE7
 ZTGfQmPZ4RI7ZbjSAnynYzmVmgVLtcej5/KWRDt7ZdaPQx0SNb5Z+NrC219JdwBEnyUWo5wW0r/
 BAosGBpxPCLQrHl/Bojb2iO9QZe5cZ+VhxWeVMq+oh7aTHrwCBU=


On 05/10/2025 01:24, Eric Biggers wrote:
> Submitting a broken, untested, and incomplete patch that makes the
> kernel fail to boot and dm-crypt.ko fail to load isn't a great strategy.

Wow, that's a highly unfair characterization :-( The patch was tested,
but the dm-crypt failure only appears in certain configurations that
includes both the hardware and the specific kernel config. Furthermore,
I think the underlying bug was merely exposed by the patch to deprecate
SHA-1 but I'm not looking to point fingers so I'm not going to say more
about that.


Vegard
