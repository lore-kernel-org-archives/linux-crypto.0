Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE3C26E6EA;
	Mon,  6 Oct 2025 11:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759751631; cv=fail; b=Dj4QYCbZvA5cmZj0yuZur18zpIbaDrks7635nwg3xhMxsmC6D9OzjE6HXEdn7jvp6HUX22t+KIN+M245S+ECrhjtvr+Tcfgc4DmaeT3aK6Mhc81QJJ1pWGJXf/KkegooQOfkZM/LPghVEfWhUgISzEq/B/1MoWjuhHUZCvyblms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759751631; c=relaxed/simple;
	bh=lDV3+TJtW7U2VylFNrp5rAcw6pClSPFHAKCkhPryUy4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nEY1OlWgihTADDVEJxnmy3Nm7dBEUaFOgmHh9m2Shim6b+ocSYD/dmx4bCQVztEyPz+vBjFcP8LZtjIE9EXYYK8Rk3uAbm50IZoU5tlgzreCEyZdwqI+qGuHickR9V7tl0gbsEeP5DlZ4KINQ/GOEUs0JWPWgjUl++yeXtqCXdI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=r5bIO9H8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rK4sj1VY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r5bIO9H8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rK4sj1VY"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 596AvlwR013242;
	Mon, 6 Oct 2025 11:53:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Eb0hxdrz1pp5jW/csSnHXkYr20M89ezTE5JlNZZaLyU=; b=
	r5bIO9H8rMffm9lxcnMMPHcXSTb45e2cX98Twcdwj+6husymSMPRSBQJ73CCK6ir
	ZGiS5LJ/9bba87X7FcaV4edLRS/dl0Y6ViLg5kIhOKD4n5TNwrh8QKHkyxgynls9
	o/aQ6cOS8oPKfxqwuo24VDlIEo9Pw0mkc8x/Ct9BgMvQoBfdby5efwXjdYkOfDei
	4Z5XeYb9TPv99TJSh00NNDSPWHYjkzUaGmcYjeIAZ/Neq6cf06r3BdMKIo9pDhGL
	bk0fN3u9/+tR83gXnRT6lgWvdm8t5DnF4L72hneOSAfkPPMnHZXeI3zXQYZ70Lbi
	byzeqdXh9JG3c06Jfbt8wA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49mbs0r4re-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Oct 2025 11:53:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 596A19IE034907;
	Mon, 6 Oct 2025 11:53:33 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010052.outbound.protection.outlook.com [52.101.61.52])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49jt16rcbf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Oct 2025 11:53:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YoJ+jY9Z0+b3S9Lw8IVx1iNeXjgZQX4CKeu1NW1bppRgnUBTUIBUgQqUstqzLxxwnEx6kTW8POkgEpLWxH8n9WYg4RKBRfjmyXRWxS9lzpQhAl/SapxbSHTyPBjXmwC3Kx3Q/pEo94pW5YvrqNzzRf40axEoV/VMwcsljrG+N2uLkRmUAGpH+O97wlfFvJ4UBpiJft/9A4A7JSAG0KHbMAyXcFyp4kVWajIG8X0Eig/7JK/HdOIGowZqLwz4WtJ/QDYGRkLitMMsMZRF8HjHjuNKLSAMlNxcYZF+0+3n93I6nMlU14H8Yxtyts3PzxNQg3oRjO9I4RB140Qm5m8ykA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eb0hxdrz1pp5jW/csSnHXkYr20M89ezTE5JlNZZaLyU=;
 b=xEPHhZiYmILldLHEyP4pMbNXvT+ep6WrtMhUleYS3PEiY3B7dP8d56DxWI9bhuNsXNdC34YtzqHeyZ0CBr4EVdMv7oj5oIo+gvNctFUI0I3Rd8uSqJKM3omrxCNKMHkZ3nahXz5oigizGIeVQEELumZJrQCcKGmVBVm/yMQSX+41qn8LT7O3ZA7M9Kq09VEAK2586Sms99u+93n1vu5DMRd0FEdONVw70wrV/weJHlb2Zlh8a1WcyFWisenKXT3+O4gE5LzMphTSxpiXwM0vGinVJd5usw+ERXJTvKkFlFBpl+1uadszOTL5TR0jDiSA4qNO06SToVs5h2QmD6lSHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eb0hxdrz1pp5jW/csSnHXkYr20M89ezTE5JlNZZaLyU=;
 b=rK4sj1VYaDlmwUJrw++niosOOq54foRhUjbJLD/9P9fywMNHGvU87iiKljMAoNp9+m++Jns5uCDp2/WjubS6hc7AsbNSbgnNpOgLfcJpisiwb1BRX3aywuyjnxw+huAGdISFyQKOeZLsbHjzMJsX2MmC7D6pEAEIXx26cPvgCG8=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by DS7PR10MB5949.namprd10.prod.outlook.com (2603:10b6:8:86::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.20; Mon, 6 Oct 2025 11:53:27 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%4]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 11:53:26 +0000
Message-ID: <2981dc1d-287f-44fc-9f6f-a9357fb62dbf@oracle.com>
Date: Mon, 6 Oct 2025 13:53:21 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: 6.17 crashes in ipv6 code when booted fips=1 [was: [GIT PULL]
 Crypto Update for 6.17]
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, "nstange@suse.de" <nstange@suse.de>,
        "Wang, Jay" <wanjay@amazon.com>
References: <aIirh_7k4SWzE-bF@gondor.apana.org.au>
 <05b7ef65-37bb-4391-9ec9-c382d51bae4d@kernel.org>
 <aN5GO1YLO_yXbMNH@gondor.apana.org.au>
 <562363e8-ea90-4458-9f97-1b1cb433c863@kernel.org>
 <8bb5a196-7d55-4bdb-b890-709f918abad0@kernel.org>
 <1a71398e-637f-4aa5-b4c6-0d3502a62a0c@kernel.org>
 <f31dbb22-0add-481c-aee0-e337a7731f8e@oracle.com> <20251002172310.GC1697@sol>
Content-Language: en-US
From: Vegard Nossum <vegard.nossum@oracle.com>
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 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 8A==
In-Reply-To: <20251002172310.GC1697@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P189CA0046.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::21) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|DS7PR10MB5949:EE_
X-MS-Office365-Filtering-Correlation-Id: 45da2613-1079-488e-54a6-08de04cef5af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q0dWdmQ4QlptNjk0cHErSEo2Tkthd0lZNjdZTFBiQmczQWVpK0hUaUg1QXk3?=
 =?utf-8?B?eVVVb1BqYzRlMzlKSjdhdHRTYWhETlJraEU1b1RqUyt6UE05UktXblFFYzlz?=
 =?utf-8?B?YTVyZXZ1Y1UrQ1dJZVFPbTJPRkJoVE15QS9uakcwZjJjclNRdG90YS85WTMy?=
 =?utf-8?B?OCt5M01xbmJXamsxQmlseEFoYnpGZWt3M2VGQ1JSb3ZuK2JSdDZsR1M5TG1X?=
 =?utf-8?B?bDB1dmJhQUVNZE5zZ2p6YURwMSt4VGVhVVhkbXNGVnM3dW9Bc1pLd1VQdUs0?=
 =?utf-8?B?Yy9Va0xkeEVGKzVReTYrby9LLzNHdlZVcHl3WUZZUFpFNDBzTmoxblFPYk5O?=
 =?utf-8?B?QVBtU1o3SWw2cmoxRWs3WnFOY2RLVVVqNko3WVppQmtCVElVdXlMb0w4YXMy?=
 =?utf-8?B?b0tYUytya1V0SCs2UEx5NnZQK3NESEcrM0tYSDI2dEV5VGJoc09wMVBwR0hY?=
 =?utf-8?B?cGs0VHNPRnF5MEdMOHRaQTE2ZGE0V1NydGs3aFJFZFRCaUxWd0xMdnlZVjV2?=
 =?utf-8?B?aHhML1JpRjU0Z2lYK3NkTjFzVTZqRVgrMjY5T1RFYTl6ZEMvblNLcmR6WC9S?=
 =?utf-8?B?M3Z2OVlqM2wxdWc5empLSjRDNFFqcGRXZzFRcFE1R2QrL2w1aEtleDZMb0F3?=
 =?utf-8?B?ZUZMSk1OMkVJRkFIenprWjlVeWYxazRzUi9VaW5OY2tnYWJSbzAvaXNXR09G?=
 =?utf-8?B?YjNJc2hxT2x4RDZuWVVBRFVXYUM2VW9CZ2taa0o3bmgvYXBsd3BNdENGMDVs?=
 =?utf-8?B?MzlLN09PbG9yUW9DNTlFbUpEVW1BM2pibFZKU3REckhJaisyMnBtUVdrUklD?=
 =?utf-8?B?enpyZHVJTFpHN1hDZEgxNEg5QVdqODU2enVuZS9TT1N5T1liK0ZPKzJWNnVu?=
 =?utf-8?B?NDRxbFFLMWJwNnB0MWdMZVRsbnhGQ1JEU0FheW9hc2R4RCtrL3doMjUyUlps?=
 =?utf-8?B?QXNzcFBITklpaWpoTDhFQVFFRnNtS3hZeXVXMVlZSlhVcmRsaHJ0bWxNRVA1?=
 =?utf-8?B?dWdWdnJWdHMrRjlmSEdsbWZBa1NvQ2hzME1iZ1VhTXlMZnI2K3d3RkkvQXcz?=
 =?utf-8?B?RDQ5QjhLZWt6WXlxVlllUmxpZ005VFRUd09oWlQ5N2lSZW9MMWNuUHd3RXhk?=
 =?utf-8?B?SXBPQ04yKzZ1SWxDM1JyYW1QM213alVBcG42WDBZOWJiZDRJRUMrY3RRTnhD?=
 =?utf-8?B?ZjRkcTlRUW9yQjZBbzhhU3ZtalF0WW5YYnM0ZW9QMVJaVWVBTFhnK093bnNG?=
 =?utf-8?B?dVRRSnY5UGdFRTVSWEs3NmtNRGoxeUZoeEdvQWlvSExKNFFnbzNkTHFXM3pt?=
 =?utf-8?B?UCtCcjlTbVNrRit6SHJSMWlhU1BRdnpieG93NkwyTHhFVkhRaGsxajZQMjY4?=
 =?utf-8?B?THFuU3ZVUGZ6a0lKVjRVc0lKbzFNR1paSllFM2dNWUlIQVptS0lxTkt6ZzBP?=
 =?utf-8?B?VXIzc3NNS3R0WGx3cXkrcEhuOWlJWmZYdFpRbW9RV201UU52MVBScm4xTG8z?=
 =?utf-8?B?a25HblMwTE9XWEJJUnFMR3hSbnRqaVE0MUFqTkFPTjEyeTJ3bjJKYTNmZG90?=
 =?utf-8?B?N3l3RmJ5MWt0OE5DbC9pbDIybmowbHR1Rjl5MTFCeUV0UXFydk9YSXFLR2M4?=
 =?utf-8?B?aHROVWhTNmF0RWRkYXZ4S1VPZzVBWWVMOGNuK1NIMHRFMzBseDJqemp6TURn?=
 =?utf-8?B?bXdtSUVFK2pkOEhBeTA1bnZ1UVBUdzFsbFlLTGJPNEhkcE1aTGJNc2RHczQ4?=
 =?utf-8?B?TkN4TkxnWnVkZzRxQzRYdHJWaFNSYTgwaXhKT3VQMjJtcXhBY1IwSm83MWQ5?=
 =?utf-8?B?QmM3OFNZbjNLOFVaQ0xOTDd4ZGdZTGI1Nmd1QXZGWEdOVGl3TE5URVhYeS9P?=
 =?utf-8?B?a25BZlBBbWNKc010QVRKdHpEQyt5M09EY21NYzhUNWZHL0prR2ZjN1lRODZL?=
 =?utf-8?B?RnlaRWZqOFBURnpmNnVUenJVM2EzYVVyUmFaU3BlZVd6R3ovZXdGdVNsM29H?=
 =?utf-8?B?bEp5cGp4QkZRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2VDZlpCRnVWa2pqOHcrQmxGQTVFdzd0VllBQytqMDVYeXZMMnloSXZsSkRY?=
 =?utf-8?B?dFErUXRmWmlwWGpTRWJtM2sxa2g0SDVwdDRQREdjQzc0TG8zQnNrUXpqMmFu?=
 =?utf-8?B?WDJUa1B4QVpiekpIUEpsOHNraVlsQ2drQ0Z3c0dUWUN2bVdORmdGQ1VSLzNy?=
 =?utf-8?B?SW9UVjh4aDZwUzNKekoxQisvMU0xeUhGTUROaEhrdFhNSjZrS1A2cWkxR3hV?=
 =?utf-8?B?U1V3RUlOSHBLSVBRUkhTNUYxMklobERxT09JREFPTWk1a1o3b284djRUK3F3?=
 =?utf-8?B?THpqN0xEM2F6WW1LNnZOdGNZeXVkd1R4Z1ROcnh4dHgyZmJleHBYSkZINEpa?=
 =?utf-8?B?QWhmMHYrZ0Q0K3c4Y2plWkROSC9BQkNsaWloVHNIbDhrT1lkd3VvK20zc1ZZ?=
 =?utf-8?B?RlBRL1doYnlCS0lzcy9TVTJGRUhxMDNiSmtqaHYwOFdMYklXT0NqRytkM0RR?=
 =?utf-8?B?cHRPcmNyd043eUVEYjZ5SG9QY1NhWGpvZGZwbVQ1Y1gwY0c4OEtjR3FJWXha?=
 =?utf-8?B?TmYxQlBJUUdlbVpGamhkNmhqOWRsWEo4dUhyUWJ0TUpka3R6RHM0RGlXR2NG?=
 =?utf-8?B?VnNMWU1tZnRXM3VTL2p0SVVuWWNxOC9NUEdjdGxGY1IzZ2dHMVdtM1NEYkM0?=
 =?utf-8?B?ek1OYVBmbmJ0Zkt1YkE5NnUyT3d0QkdvSWE2QzN1aStYSlA3QjVpMG05cUk0?=
 =?utf-8?B?S3Z2QTNUUklJNWVmcXJiUk91Zjc5UlYzRGpxbFE0TksySUVIYmN3VHlubndC?=
 =?utf-8?B?QkFaR0FjMzZqNEt1Njd2cmhTbkFSMk9zNGk1dU1XQXdWcE0zN3dLaEQ1SnIx?=
 =?utf-8?B?VGREcGRMbUVEUzErb0xVRXhEZHBoWGFMUHVRSS8xc1owTlpsMzF4NnRsNk44?=
 =?utf-8?B?Qm02MHNkVjdTZldtS0Zxc1E0aFFhTDFwZnZHUis4T3RyRXpFQk00M0Z3Z25w?=
 =?utf-8?B?WlRoU0V6bDdMMWRMWVBRM1pYcVBFMkZ2V3ZzQmtaN0JDMjAxSDdxZWw5Ujds?=
 =?utf-8?B?UjVuNzhNUVVHT3BwMHFjWUxjaE9ZMzZaR0t2QnBVQzlDUldDeGdvbkdHbTc1?=
 =?utf-8?B?cWFHYlI5ZmZYcGU1OGUvN0prV1JOV2x3aUQ2cG1sUE5CQWNPQWkxeDV0cGhk?=
 =?utf-8?B?RkcxczV2aDRUM3VxRDhoSWNVVysraXBSLzBNNUNFWGVUSHQ2SHZ4S202YjUz?=
 =?utf-8?B?d081UVpidGZUQjZpeGxCZ1F0cEFyWkFBWUllcVc1VDNYbG1WQ203UXhDZmFE?=
 =?utf-8?B?d3ZjZjNlU0FqVzV2dDNIUU1vZkZyOUk2YUlwWUpRemlaTWd1UytZZXo5c2pz?=
 =?utf-8?B?VHFZTzU1Z1J6M2xVcXpScXZ1RDlTWEpDWW9BUEZIaURidDBoTHpyNi8yUUN5?=
 =?utf-8?B?c2pVSThrNkdmZ3ZlMXFGWXNaZ3dQUHV1U2txVlFscE9NWlBTclVrQktSVDB6?=
 =?utf-8?B?cnhGb2ZVVjUrazEwRjUrSkhiaGJadjRQMWg0YkR3eVhtL1pQWTlZVUZoYVM0?=
 =?utf-8?B?L1lPNFpickI2aDFqUEZSOUlTSUVodmVJdWdUMzkweWFIRG5QalJSSTF3MSti?=
 =?utf-8?B?RDZtSE02aGJWTS93RVB4WS81MGIyREdzaWZ2UUYzWWk3UHhNSXlFbnU0d25l?=
 =?utf-8?B?R2tRY21UTGg2K3J4U3kxRlRRMW5aSTVKOHRSZHg3Mkw3Mm9yUVNab0ltbG81?=
 =?utf-8?B?ODY5Q1AvS3I0WTRNS08yVWJiSTRPTmNPcG95RjVXdUVROGIya0V3UVE1OUNx?=
 =?utf-8?B?WUFaelJXZjBxdnVCV3FvYUpRQVVGbGh1ZXBQL2Q0TzhSaWtBTVdZc0o4MUVj?=
 =?utf-8?B?ZEVra2hoUEk0VmJIZVJXMmJwR1BiaEh6YUI2OGlQVjIwNnhYcm9OZllLR2ds?=
 =?utf-8?B?TGtMT1RpZm1pRkgvMGN2Ly95emJlb3JGbVpubEJZM2ZiRFJLVUlUc1c5T3Bv?=
 =?utf-8?B?V2pyRUIzczQ2RzFMUUs5L1ZJemdISEV3blNvK290d3hJaitVaWRnZVo0SE9n?=
 =?utf-8?B?ektCdzRubXNyMXltRTdscTdsWm1yd0hVZEVjVGc3c2xucitBbnJuOE96cHh5?=
 =?utf-8?B?enZUWUIyOXVvMHVHL0FHZHZIbkl4UHR0TStzdHo2U1pmNHpQVktEc2RjVkRK?=
 =?utf-8?B?YmJzWlFTdzNnSS9JdFR5UDIvUnFVUjZ1ZXNlcUc2U21Sc0ZxT3U0SklPMXVD?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ywJaw0R7ZTlPbpEKH/6n+hWmqFAxTOO8ynRIykiJsjamvchhepdKZ6D4gkEtmtz9y2rQLB7oMvb4ZQMbsLiOH/T20xOcglsyYG4M1U2Jifi9Ir3N5JwJYSLtReQpprhGlidAlEYqZSFzdWE7cQYUnc9Gl/wQqBkpdD7mIfm8CQjYXxurLtVumgyfYC8/QOSzl/vyYP02AWsY9qVnfqNRVloxMiEf6gCOhI/Z4tz7U15a4/uCZEjX5c2A1wqgNiADZlcmyqrHNJZS/cJl+Nu7tnLHtc4jPZAE9nbMeuVW0/AFyVBCYhvqT2FNQue6l82K1eaPDg0XogFKj+GRzzpeIqTjJFkNlEhTMvtPuCgzeife8zMUEoe2jEV83HSvu6paWDy/TkobMfUnnuLxg6ZZEzSZPvgRLiunrwARfKA/78dkC/vGW2zMbh8aa09pGSZKLeYU0x/JyMmURRYJbvaLGACNXOUDZzbi02/FyO/3+Yty6TpYtdjL7Pm0EWb2DmnCzjftHK+1KWsU/VqY4sD8OB3W5TEjCN7ujGlrpMpC4eScilEz9+wyfZ5WzwXAmXV6X1l5lytk8UTq2VZ0K9XduNazgxRQvyC6gVmDp2plYm4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45da2613-1079-488e-54a6-08de04cef5af
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 11:53:26.8266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 95QX7HU9tn5PxEXevgu6aqls/7v4UIopawFxVLMSRx1KiZuXFyCUlQbw5RJfvJKK7XE4GHE3d2vns/MrzrrsJsu05ChQ8OTrnNxMJkAsLNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5949
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_04,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510060096
X-Proofpoint-ORIG-GUID: 63Q-kUC8I-XXlwFb938gtsq-ut6c_z_r
X-Proofpoint-GUID: 63Q-kUC8I-XXlwFb938gtsq-ut6c_z_r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA2MDA4MSBTYWx0ZWRfX3A0cNfl9Bzv/
 UCW+MaNKKbDBcp4C5vXZNuY/2abCNn9mDBy5MgSXR8M61UH4dv4LTNxXkrMHJ5x1RpYTndxWBeA
 3Gna6u8WPMpiEXwS2jA3nkMWzOQHEgxm4jKRQ3lX7vdHgU8j6ij7DKINQfBCv1J6L3T6GI/cJbB
 acgxb7+8KLa1Tak7hQWZdJVLUYfFsoLYBfIjUSwbRh8vL8fR/l+JL/dMwxmy0R+VKllte7Ztsd9
 gI679UcV7cyENLoNqvX47LaLmwi+8G+E6s78ZuCZ+akg5DjKwMMuWNjq6ih9CviWiR6sgyGhAgB
 TPigjRDKxw9oFn+YPlQxCRWJDp6HFyqJpFUsjX960bjJjfCk+JaCLJVNE4bCSndUUBav85yyL5l
 efAtU3X+bv+LMiQTqTIBxgpb1xAqS5p9gQ2iSU7DvIO33Mwoxz0=
X-Authority-Analysis: v=2.4 cv=dZ6NHHXe c=1 sm=1 tr=0 ts=68e3adbe b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=eZTvT1lLvnAU4yA3RUwA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12091

On 02/10/2025 19:23, Eric Biggers wrote:
> On Thu, Oct 02, 2025 at 01:30:43PM +0200, Vegard Nossum wrote:
>> I'd like to raise a general question about FIPS compliance here,
>> especially to Eric and the crypto folks: If SHA-1/SHA-256/HMAC is being
>> made available outside of the crypto API and code around the kernel is
>> making direct use of it
> 
> lib/ has had SHA-1 support since 2005.  The recent changes just made the
> SHA-1 API more comprehensive and more widely used in the kernel.

Sure, it was available under lib/ but what matters is that there were no
users outside of the crypto API. Adding direct users presumably breaks
the meaning of fips=1 -- which is why I'd like us to work out (and
explicitly document) what fips=1 actually means.

>> then this seems to completely subvert the
>> purpose of CONFIG_CRYPTO_FIPS/fips=1 since it essentially makes the
>> kernel non-compliant even when booting with fips=1.
>>
>> Is this expected? Should it be documented?
> 
> If calling code would like to choose not to use or allow a particular
> crypto algorithm when fips_enabled=1, it's free to do so.
> 
> That's far more flexible than the crypto/ approach, which has
> historically been problematic since it breaks things unnecessarily.  The
> caller can actually do something that makes sense for it, including:
> 
> - Deciding whether FIPS requirements even apply to it in the first
>    place.  (Considering that it may or may not be implementing something
>    that would be considered a "security function" by FIPS.)
> 
> - Targeting the disablement to the correct, narrow area.  (Not something
>    overly-broad like the entire IPv6 stack, or entire TPM support.)
> 
> So: if the people doing FIPS certifications of the whole kernel make a
> determination that fips_enabled=1 kernels must not support IPv6 Segment
> Routing with HMAC-SHA1 authentication, then they're welcome to send a
> patch that makes seg6_genl_sethmac() reject SEG6_HMAC_ALGO_SHA1 if
> fips_enabled.  And that would actually correctly disable the SHA-1
> support only, rather than disabling the entire IPv6 stack...

I'm pretty sure the use of SHA-1/HMAC inside IPv6 segment routing counts
as a "security function" (as it is used for message authentication) and
thus should be subject to FIPS requirements when booting with fips=1.

> Still, for many years lib/ has had APIs for SHA-1 and various
> non-FIPS-approved crypto algorithms.  These are used even when
> fips_enabled=1.  So, if this was actually important, one would think
> these cases would have addressed already.  This is one of the reasons
> why I haven't been worrying about adding these checks myself.

I see some direct uses of lib/ algorithms outside the crypto API on
older kernels but at a glance they look mostly like specific drivers
that most distros probably don't even build, which might explain why it
hasn't been a problem in practice.

> It's really up to someone who cares (if anyone does) to send patches.

I'd assume most distributions that provide FIPS-certified kernels care.
As far as I can tell, they are all going to run into problems when they
start providing products based on v6.17. Maybe I'm wrong and it comes
down to an interpretation of FIPS requirements and what fips=1 is
intended to do -- again, why I'd like us to work this out and document
it so we have a clear and shared understanding and don't break mainline
FIPS support.

In the meantime, I think it would be good to stop converting more crypto
API users to lib/crypto/ users if it's not crystal clear that it's not a
"security function".

>> FIPS also has a bunch of requirements around algorithm testing, for
>> example that every algorithm shall pass tests before it can be used.
>> lib/crypto/ has kunit tests, but there is no interaction with
>> CONFIG_CRYPTO_FIPS or fips=1 as far as I can tell, and no enforcement
>> mechanism. This seems like a bad thing for all the distros that are
>> currently certifying their kernels for FIPS.
> 
> As I've said in another thread
> (https://lore.kernel.org/linux-crypto/20250917184856.GA2560@quark/,
> https://lore.kernel.org/linux-crypto/20250918155327.GA1422@quark/),
> small patches that add FIPS pre-operational self-tests would generally
> be fine, if they are shown to actually be needed and are narrowly scoped
> to what is actually needed.  These would be different from and much
> simpler than the KUnit tests, which are the real tests.
> 
> But again, it's up to someone who cares to send patches.  And again,
> lib/ has had SHA-1 since 2005, so this isn't actually new.

What's new is the direct user of lib/crypto/sha1.c outside the crypto
API since commit 095928e7d8018, which is very recent.

I don't think it's a good idea to duplicate all the logic around
FIPS and algorithm testing that already exists in the crypto API for
this exact purpose.


Vegard
