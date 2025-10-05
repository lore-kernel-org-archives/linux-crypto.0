Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66BB34BA3C
	for <linux-crypto@vger.kernel.org>; Sun,  5 Oct 2025 07:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759649412; cv=fail; b=tbzcanKimJfivlZZxTqAah6aFgJ9asv8OoFG59B6paQ8ZFJquOJjYbA+SEKT5yuWSWPTtV0TQeGgj2sxtacIbS0jyXlTM/gswkvfdSkhdIivmPKE358YaVCyR0g/HfFng72jasuLqJQMHEkTkUjzUKojspFG+7grMUrptkYOJ1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759649412; c=relaxed/simple;
	bh=Z09l6XS1HCvnWyCNMp9utM+pCvMzwhwqG6X2JQ2/YiE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IXQ+O1T3ScgnEfC+uw4G8xgLpYZ0R4uJjts5xUqU/5CH05iG4Hp08neQF/8aO+6m1Cqpa3JQ8W4uUIiC+4JGoqEmiJnblm8SmwWUU5Hlp4eqPfupMAesiZvjTm8dJ0pj/hH3OrmXIEr4m12r+drueWWUj0bFsoBqePo3MZMen2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a4xwUBXj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Xj+VFRwl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a4xwUBXj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Xj+VFRwl"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5954mEg9009744;
	Sun, 5 Oct 2025 07:29:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xT5NMMRSMWpV6CGLJR3NVeSooN2WUsMA5gUlw22bfYE=; b=
	a4xwUBXjXVxIgGAqfLSeDUTqqcCf1M4m/6gzJJ/1kgsVqFTr5hSzCawEGkquz9Wp
	RhH3DuGdQoPM/XOR19g6r96vWyrcETnFyYc+RIA3CM+uaVLIyjtCiu55SCuqaIsq
	RrqdkUNPn455iTXpIyglmH0vokzSSlwB9oyN4Y9zYacM4UzpSaJynyHIhEFDfagA
	+VqYDCNiT1zkRqytvqNzBuE8j/XsFFVsGJND4ckSfseTJjlQDFgOTkgm4B4FOrGt
	XXNsmsXPD4X9hyZDuVsI5SuscoN5dB0TnkYVz0p5AOrbnjl4smdA5+PG95OGaGQ7
	iRIjEevKrtXkmyI/1URbkQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49kh7q03p1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 05 Oct 2025 07:29:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5956rLkK004257;
	Sun, 5 Oct 2025 07:29:33 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012022.outbound.protection.outlook.com [40.107.200.22])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49jt161e2w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 05 Oct 2025 07:29:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d3swkxuVA3mscsH6b2V2JhbpbEyMi1rlVcmV+DqhMvQHuFr5m7AdRrTnGoqgabsjI1027SC1nn+qpfJhzobcmkbnYyiPvZ+CKO7/UAQFC49p24LKfPazwCHqinmJG7WQ5no8/FF05XLkVrfyC/qC/YVeG/RhqoaSiTRVcE0VkeWRmox446GGBQA7igks47cCuowCynSNd9wT3dszcbPUeLuhkQEQcMoAdFYk5XX5gWHmeHSjuv9e7dW8eoX827OyHS2y5zOVkSZOSGum9t6L2hOHITW4bOFOZl4Dt5A+pNu9wCqAPijJIeYgHJRke6JY/XW/sOnFCk1itOiFUrAuWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xT5NMMRSMWpV6CGLJR3NVeSooN2WUsMA5gUlw22bfYE=;
 b=x5Axw5wKrTliGlJGNa8mo0TDwSCRrThblasSY/xURfI3ESPDrlEUnrwZbt5lioxy5kV5yEAK0kRQlgc0DLZm1VVIXkcVDLk91sx4X3MgbBNX+4B1Ss95S15nUnU09D7SBwBCknRp+7sr/pslt8HZpkhcI9pC7kwIxpCL+Ci1EVorDyAJAwKkyHSYfudooC9iWcvm5b5atEyi8OGTGSl0VDFLSwZQBRSAwmY2y5rMQxOe/KqQuJUVH/mZo5cUD0QBrvV5fZk703SRQl12BsSDUxcEyI7SObSWD+VSBV40w6tiKtWudv5bfKuToDTd2TYJDF0uaMVR6+Tx6C2KpCWGLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xT5NMMRSMWpV6CGLJR3NVeSooN2WUsMA5gUlw22bfYE=;
 b=Xj+VFRwlvEGQeR+BGqzmGalsI1dkHB2FHo9Mlw20ncHXDmDBPvdejRzUWQGF6Ru7UXg5HuZwAqFimYr1Zeypan+hz7dfdfC212QgLTzjo39AwiXPOo8lJJBCFQWxXu7aEL/fkgukCMrICIWPI+jmridDxoUwuiQC0lR7IAKldZQ=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by BY5PR10MB4130.namprd10.prod.outlook.com (2603:10b6:a03:201::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Sun, 5 Oct
 2025 07:29:26 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%4]) with mapi id 15.20.9182.017; Sun, 5 Oct 2025
 07:29:25 +0000
Message-ID: <a2496958-1423-43b6-b23d-e4b745af034a@oracle.com>
Date: Sun, 5 Oct 2025 09:29:21 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: 6.17 Regression: loading trusted.ko with fips=1 fails due to
 crypto/testmgr.c: desupport SHA-1 for FIPS 140
To: Theodore Ts'o <tytso@mit.edu>, Eric Biggers <ebiggers@kernel.org>
Cc: Jon Kohler <jon@nutanix.com>, Herbert Xu <herbert@gondor.apana.org.au>,
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
 <20251004232451.GA68695@quark> <20251005031613.GE386127@mit.edu>
Content-Language: en-US
From: Vegard Nossum <vegard.nossum@oracle.com>
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 xsFNBE4DTU8BEADTtNncvO6rZdvTSILZHHhUnJr9Vd7N/MSx8U9z0UkAtrcgP6HPsVdsvHeU
 C6IW7L629z7CSffCXNeF8xBYnGFhCh9L9fyX/nZ2gVw/0cVDCVMwVgeXo3m8AR1iSFYvO9vC
 Rcd1fN2y+vGsJaD4JoxhKBygUtPWqUKks88NYvqyIMKgIVNQ964Qh7M+qDGY+e/BaId1OK2Z
 92jfTNE7EaIhJfHX8hW1yJKXWS54qBMqBstgLHPx8rv8AmRunsehso5nKxjtlYa/Zw5J1Uyw
 tSl+e3g/8bmCj+9+7Gj2swFlmZQwBVpVVrAR38jjEnjbKe9dQZ7c8mHHSFDflcAJlqRB2RT1
 2JA3iX/XZ0AmcOvrk62S7B4I00+kOiY6fAERPptrA19n452Non7PD5VTe2iKsOIARIkf7LvD
 q2bjzB3r41A8twtB7DUEH8Db5tbiztwy2TGLD9ga+aJJwGdy9kR5kRORNLWvqMM6Bfe9+qbw
 cJ1NXTM1RFsgCgq7U6BMEXZNcsSg9Hbs6fqDPbbZXXxn7iA4TmOhyAqgY5KCa0wm68GxMhyG
 5Q5dWfwX42/U/Zx5foyiORvEFxDBWNWc6iP1h+w8wDiiEO/UM7eH06bxRaxoMEYmcYNeEjk6
 U6qnvjUiK8A35zDOoK67t9QD35aWlNBNQ2becGk9i8fuNJKqNQARAQABzShWZWdhcmQgTm9z
 c3VtIDx2ZWdhcmQubm9zc3VtQG9yYWNsZS5jb20+wsF4BBMBAgAiBQJX+8E+AhsDBgsJCAcD
 AgYVCAIJCgsEFgIDAQIeAQIXgAAKCRALzvTY/pi6WOTDD/46kJZT/yJsYVT44e+MWvWXnzi9
 G7Tcqo1yNS5guN0d49B8ei9VvRzYpRsziaj1nAQJ8bgGJeXjNsMLMOZgx4b5OTsn8t2zIm2h
 midgIE8b3nS73uNs+9E1ktJPnHClGtTECEIIwQibpdCPYCS3lpmoAagezfcnkOqtTdgSvBg9
 FxrxKpAclgoQFTKpUoI121tvYBHmaW9K5mBM3Ty16t7IPghnndgxab+liUUZQY0TZqDG8PPW
 SuRpiVJ9buszWQvm1MUJB/MNtj1rWHivsc1Xu559PYShvJiqJF1+NCNVUx3hfXEm3evTZ9Fm
 TQJBNaeROqCToGJHjdbOdtxeSdMhaiExuSnxghqcWN+76JNXAQLlVvYhHjQwzr4me4Efo1AN
 jinz1STmmeeAMYBfHPmBNjbyNMmYBH4ETbK9XKmtkLlEPuwTXu++7zKECgsgJJJ+kvAM1OOP
 VSOKCFouq1NiuJTDwIXQf/zc1ZB8ILoY/WljE+TO/ZNmRCZl8uj03FTUzLYhR7iWdyfG5gJ/
 UfNDs/LBk596rEAtlwn0qlFUmj01B1MVeevV8JJ711S1jiRrPCXg90P3wmUUQzO0apfk1Np6
 jZVlvsnbdK/1QZaYo1kdDPEVG+TQKOgdj4wbLMBV0rh82SYM1nc6YinoXWS3EuEfRLYTf8ad
 hbkmGzrwcc7BTQROA01PARAA5+ySdsvX2RzUF6aBwtohoGYV6m2P77wn4u9uNDMD9vfcqZxj
 y9QBMKGVADLY/zoL3TJx8CYS71YNz2AsFysTdfJjNgruZW7+j2ODTrHVTNWNSpMt5yRVW426
 vN12gYjqK95c5uKNWGreP9W99T7Tj8yJe2CcoXYb6kO8hGvAHFlSYpJe+Plph5oD9llnYWpO
 XOzzuICFi4jfm0I0lvneQGd2aPK47JGHWewHn1Xk9/IwZW2InPYZat0kLlSDdiQmy/1Kv1UL
 PfzSjc9lkZqUJEXunpE0Mdp8LqowlL3rmgdoi1u4MNXurqWwPTXf1MSH537exgjqMp6tddfw
 cLAIcReIrKnN9g1+rdHfAUiHJYhEVbJACQSy9a4Z+CzUgb4RcwOQznGuzDXxnuTSuwMRxvyz
 XpDvuZazsAqB4e4p/m+42hAjE5lKBfE/p/WWewNzRRxRKvscoLcWCLg1qZ6N1pNJAh7BQdDK
 pvLaUv6zQkrlsvK2bicGXqzPVhjwX+rTghSuG3Sbsn2XdzABROgHd7ImsqzV6QQGw7eIlTD2
 MT2b9gf0f76TaTgi0kZlLpQiAGVgjNhU2Aq3xIqOFTuiGnIQN0LV9/g6KqklzOGMBYf80Pgs
 kiObHTTzSvPIT+JcdIjPcKj2+HCbgbhmrYLtGJW8Bqp/I8w2aj2nVBa7l7UAEQEAAcLBXwQY
 AQIACQUCTgNNTwIbDAAKCRALzvTY/pi6WEWzD/4rWDeWc3P0DfOv23vWgx1qboMuFLxetair
 Utae7i60PQFIVj44xG997aMjohdxxzO9oBCTxUekn31aXzTBpUbRhStq78d1hQA5Rk7nJRS6
 Nl6UtIcuLTE6Zznrq3QdQHtqwQCm1OM2F5w0ezOxbhHgt9WTrjJHact4AsN/8Aa2jmxJYrup
 aKmHqPxCVwxrrSTnx8ljisPaZWdzLQF5qmgmAqIRvX57xAuCu8O15XyZ054u73dIEYb2MBBl
 aUYwDv/4So2e2MEUymx7BF8rKDJ1LvwxKYT+X1gSdeiSambCzuEZ3SQWsVv3gn5TTCn3fHDt
 KTUL3zejji3s2V/gBXoHX7NnTNx6ZDP7It259tvWXKlUDd+spxUCF4i5fbkoQ9A0PNCwe01i
 N71y5pRS0WlFS06cvPs9lZbkAj4lDFgnOVQwmg6Smqi8gjD8rjP0GWKY24tDqd6sptX5cTDH
 pcH+LjiY61m43d8Rx+tqiUGJNUfXE/sEB+nkpL1PFWzdI1XZp4tlG6R7T9VLLf01SfeA2wgo
 9BLDRko6MK5UxPwoYDHpYiyzzAdO24dlfTphNxNcDfspLCgOW1IQ3kGoTghU7CwDtV44x4rA
 jtz7znL1XTlXp6YJQ/FWWIJfsyFvr01kTmv+/QpnAG5/iLJ+0upU1blkWmVwaEo82BU6MrS2 8A==
In-Reply-To: <20251005031613.GE386127@mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0088.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:349::13) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|BY5PR10MB4130:EE_
X-MS-Office365-Filtering-Correlation-Id: 38663a1a-1e5a-4f22-124f-08de03e0e94b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WkJ0bEs0WjgrMFVZekdia1g0WGlVTHI3MmVnUndUcGxtVDlCNzNNN3A0ZUpD?=
 =?utf-8?B?a0dXdC9zZk03K045bzVCMDVObkEyZHJ3TDlIQ2ZpWkh3TnQwL3poUUhwV3VH?=
 =?utf-8?B?a2QvbW83L3RCMGN2TGxxZXR0UmRRUGRtYWFjd0VLTTJ4Q0lxRVZYVkNCc3Nj?=
 =?utf-8?B?ck8xaUwrdGQrMzZEaHhsSTcvZGc1Q3BjRXFYVTFvTXpyMXhmeld5UERHT3R6?=
 =?utf-8?B?cXN2Y2kvNWQxR3FZdlJ5Y1VuMHRjeUZDSlB0b1ZxdzduVmY5L0tNTUNiSno0?=
 =?utf-8?B?SE01T0poTExMZTlsTmU2WnQyRGxUZDltYXV6OFpqbTNyKyttTGVHaXVQbnZX?=
 =?utf-8?B?LysvNzk2T1IwcitVMytjWXZYUU5mSGVyUUJPYnZHVkxoR3daR0pxZFkwMmZv?=
 =?utf-8?B?WnBMbEJ0UXNHbk0vUW9ialNZTjUxYUhGMEREa0RVRmFtZGFOb2JocVhwNkNh?=
 =?utf-8?B?UWF2RFN2MnlXczBVM2ZjZkgzdCtQaTlQdXlFRU5tMER6M1dBS1crWTYvRDhL?=
 =?utf-8?B?dWQ2eWNHckcrcUUvS045d2tncy9sNmZDTWZQaTJXQlFSSHhhR3YxR1FoaUdy?=
 =?utf-8?B?bU1uaFVhVWZ3ckpRUzhFZ2trK1ByejJBNEhESFBMdDY4aTNKTkl3Y05vc0da?=
 =?utf-8?B?MWxUek9JWnNORVh5c2I0QlRncDhaOGVkY1VzVklqWml6R0NDVFFHQzJORVZq?=
 =?utf-8?B?dVEyY2pFdzV3SHdYWXh1SEJDYzBnUDRqWm4xRGxwc2d2WUVzUnJXeUhwbFhI?=
 =?utf-8?B?SHRJYUVieXVrb1hCa0FLQWtGWVdQcml5aUZmQy9TMGFNV1A3dkRVQkplNlNH?=
 =?utf-8?B?T3R3WUo3MXM5SW80eTdCQkdCbk1nb3lRSlA5UmR1TVU0clcrSEJndUIxNjd2?=
 =?utf-8?B?bDRZQ3JJbllScDdCOHM2aHRYa1pDUDBvQjA1cWYvclhlTU9rSUxXY3c0cWR2?=
 =?utf-8?B?ZE4vdkdNdGI5SmJibXlLOVBHZUpreDJ5bDR2UnhLRUdSTkFSczh0YzJCSCsx?=
 =?utf-8?B?QWZaRi85Z1krUlRES0tZamExcXhvbTUzbk81VzlWZFNoUDNtNnhUV3Rld2hP?=
 =?utf-8?B?STJlVG4yRmFBQ3BqNUJYQUsrUUZWNlBUODJUcDIyVzFoeE5WaFhzK2sxZnlG?=
 =?utf-8?B?SGNDdEEyR0lEYm5uV2w5WHgrMWtncThJUTZvLzJsajBmQllPa3RrZWY0TGxP?=
 =?utf-8?B?clRSR0RtVUd4S3ZocmVKSmZkelhWcG9CYUJOekVVaE00MkR4aXRrcURVODRh?=
 =?utf-8?B?WTdZbjZFaDY4ZVdnY25KUU8zVG5KNUVxTkcySnVmRWltclRzcmZJNUo3YlNn?=
 =?utf-8?B?K1ZUVWM5NHhCeVl2VWF1Nm90RXp5THJPVjVhQ0thY2l1VjFVaGk4eGlYK0V4?=
 =?utf-8?B?cGppZ2hXa0twR3B5cVNkNHV5WDFjUmN3aWM4OUN3Sk1MSXZVeUJRVG5vcXcr?=
 =?utf-8?B?U25aeVBkRTdSNjJjdzBlMzVPczk1YmNFS2hqWFREYmUwK2RNUEplNkM2RXNM?=
 =?utf-8?B?RndIK1FaVCszZGNYQVBQSEhFYzdlZnQ1N1VGbThzb0RHWEQ1V1V1NkRheENt?=
 =?utf-8?B?TWdFVXlNK2FjZWNWUyt2Z2haK1VuMDdpZTBTeldjc1IwTHpOYVlYQmtiOC9U?=
 =?utf-8?B?T1pqVHplVU9Tc2NVUnZ2SmxCQWpaai9oUkQwSVd1eDhaZGNRN0hlYXdTc1pk?=
 =?utf-8?B?RDZhUFV6b2pGZnFHejE1bUU1eExqNE1kMEo5TmFvbnVORjZaUTN2enVJQnRF?=
 =?utf-8?B?VDR5NWV5YUlXNGk2d2lOT0NzNWkvZHRsSkU4QVdscnhicHdwVE9tZTArM0hz?=
 =?utf-8?B?ODN6bWFreEVVVXZaalY3MytmQ011RGRUb3ZzRm00TDIzeWxPTzFRUk9LbWpF?=
 =?utf-8?B?MXZZekcvUmU3NXBLRGNjZWJWdGZKZWFURXdNbWVXY3NURHFZOEpibUkxRXRs?=
 =?utf-8?Q?aTNpG1Qd7NI7lYWFA0fkl3achEQzf/4y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTZVcWdEbjcvelRoQTA5dklnNTNnU1VoMThEajBpR0h1Uy93RE1HMVQzQ25R?=
 =?utf-8?B?QVNOZmZ6ME9pRHMxS3FURncvd1YwWGplQWpabFhzZnhNWjdCcVY1ZWZOR0ps?=
 =?utf-8?B?WGM5RVB4amJ4WS9Sbk1oR3czclZXaDJ2RWVzdXExclcva3hxUE9HdlFTdDZq?=
 =?utf-8?B?L0VrSjVlNTNsUEJ1YlFzL3BpTG9LREEvaDNTT3pnMnFPUHE0TkhoSThwTWtI?=
 =?utf-8?B?NmJGbVR0UUFWMnpCMC9xQ2gybERGYnZEYlpFcTI3VXVJclN5T3dSbGZ5VTRN?=
 =?utf-8?B?Q0JhTHI1RHRTZjJJYjVLU1NJbk1SQkdXL3hOUGQzQklhWHFSbFRTYnpzTmJR?=
 =?utf-8?B?MGxDOFJESWZxSW1CU3lQNnhXRDUzYlZudGJmZVhMT0kzN29tbjZROEMveEpP?=
 =?utf-8?B?emxjKzZ4NmV0dWl2VHhrTUlFYWZ3TXdYUEhnZHpzUVpSTkt0UDlOR0lGVG9r?=
 =?utf-8?B?U1N6MEZ5bldvVXRUbXh5ZzFndk9JSEdmUlJiSGd5Ni90L1RlWWNSOW1jazJy?=
 =?utf-8?B?TEkxSG9vRXUybFFVUjNPR0VXMGI5bUI2emFNbDRzRE5QNDhQTjdnWHErWGtE?=
 =?utf-8?B?bkdzTVdLTGdCR3NNcE1rWkJGeTBOM1E3OVB4d2VKMk5KNWN5ZUZGZmFyM0NR?=
 =?utf-8?B?OTBESG1wUGFjOGJJK0haVFBiWDlna3hXOElBMDhmK3UxYm9iQVlvdlNPcm5O?=
 =?utf-8?B?NGQrOFY5YkxsR2MvWUZ2VkFZcjRrWWNVdlU3M2oxQTZZNzJBTE51WWtHWHZz?=
 =?utf-8?B?V2kvQ3FpUnhDek9GVStrMVArVVhBV1k2dU43aGRGMWpsSWdOVW9lMFViREZD?=
 =?utf-8?B?cC92ejd2eFU0ZGNDRVJONkxXcFdOZU5OMElxZ2M5dklpUnhKMS9qZUd1ckhH?=
 =?utf-8?B?eTcxbFJNNW9ndWl2d21FTlgxeDFIS1hhRHZFVmVJZVlpOWNCM3VKcDduSkFi?=
 =?utf-8?B?dUY5czhwMTJZUVNENXZXbkRramdOZndkd0UvOHZqeklhRHJLQ25rcDZLZ1V3?=
 =?utf-8?B?VlYzNDc4ZVNqd2pBQkVVUWh1Qno5dy9zZWI4L0JBWThxNFdyTXQ4M3A1bDQr?=
 =?utf-8?B?ZDUvS0FsTFBmanFSNDZZMm1MTTlvNHc4UHZvbFdwT3hwbHpsSWdqY0hLR3VI?=
 =?utf-8?B?UHpTa2dWb3VRWnJLVW1HZjEyN2l1aWRiakpIV21KMXYwc1QrTjAwaWcrd2p6?=
 =?utf-8?B?Rm94VzdDdzBXZ3BoVjNNVCtUTlh1b0FQMjNvUUoxdllwUW9aVXpUWkh0UmZF?=
 =?utf-8?B?dURhbWN5WkF6Z1BVb2RxSWZvUzZGWlE2UUhpelNmM01aUVNoNVlkc2gyWmxj?=
 =?utf-8?B?QU1IWUZyeFdKNDIwS21Vd1JxTHdyaTBmNjl6NkpsT3NLL3Vrd2dyWExLS0NW?=
 =?utf-8?B?eVBlT3JJd3YrTG9NSGV3eXd0L2h3RXg4dmx6YUx1aVVsVmRjZW91WHFnYmFp?=
 =?utf-8?B?d2pkOHQ0K1hqWW10czhDQkpLYXJnQk5idHRLNmEwRWRua1RHaTQrWHNvY0hR?=
 =?utf-8?B?SFdoNGc3bEF3cVJZampUendmN1Z0UDlPWkI1WVdiNDBERzV6UE9zRnJTNXE3?=
 =?utf-8?B?TWJDSm5NbHhiYXBUVUxVdkk1N2JzdWpmNzBhNkd1MmpnaXgyQkhBandvMWk3?=
 =?utf-8?B?YjRSTWRhZGFTWVZKMjkycDcvNVdnMjFRZ3J6dUNyeTBnY21jUkVBL3p3YmdV?=
 =?utf-8?B?NWJ0anVLd2RWSEttNngvSEFjT2NDZ1htRmJMdURzMktzVForMmpIUVROdjYw?=
 =?utf-8?B?Vm5Ucm91bFhwdS9tOW45MC9YSW5Ia2VTL2N2ckRNZ0Q4MkhWcWVrTjJEdnBh?=
 =?utf-8?B?TDUyYnJ3a3haeUNsek9KbGJ3cGJlV0h5b3pwd1oyNmtwK252NEJJYXJLUTdt?=
 =?utf-8?B?WTB6Tlo3NmVpU0hiaUgxUGpITHdRRmxDTGRTdTR0a2dxT3dCYU1QSkxYR0l5?=
 =?utf-8?B?Q0V1ZTU1YkxlS0l1UVlvcHZtTW1HL1V2TDdKMGZDeHkzc25iaE1od2pTN0lX?=
 =?utf-8?B?MUJxRzN2dHdsSTAyNDk2RllYd3o1cndFbGwvZWh2VDhyYzdHcHFKTzk0amVk?=
 =?utf-8?B?VStrVlBvNFBpSkJqbnpYMzdray9WRENweitXMC9TTUdKK2w2bEVXVzVDeDdG?=
 =?utf-8?B?TnU0SUlJVW5nWTNsbHBpTEVwVjBIcUxDMkl2OVk1bzhNZTAxQWhZWXNSMnhG?=
 =?utf-8?B?ZkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C3WvqULHzn1YcVZpPfPbgyu5g3HkTCfbqpcJknCRXlIlUx3LhYupp2QDhv3YLOQvbEVIAwmP7NhZb1FQE9cUWz4xCMUkvEmty27UB/k01rwgMcvAFM6HLuDu/TZEPRc90RhR0BMXvEM9BJlgK8W+e+FVjWoXDpSpDe/MJNR80EYdMOzUxDJItDuv86uCC8/QY9ASC7IKucl/NHQmCFTKqIreuxbRUnoKRhKu0csVFjM6yrxLGJAThUz9Vtirqjp09a+ywgYehcPR5zdkJIx5UPZH5bZ/gs1XxkZsOv+vd+XtelPWmnUXabGJjIl+Er6t8zORtlp+snjED/iZiNIRgwo4Pr9qlJ7Fv0G3v/H3Y/lI3nrkLIpVDei6KVCWgJyQ+TSEVj2q4Xo8bgQiF2xyEpSXrUPrxkzkE+Ib1r7rdzTmZ4545ryxDOH/0ZsMTrN9lgsKkYF9CqNfSyXMlrVrQ4E/w+iUiLodv5HJyEZk1Ku4Dp1DaCALDQrNLblPS6+MOjSPPIIfkj2XGTLSoSBcaa7tL3eCCPmm8DQwsGXTcWEzNC1MP2BfSVzqmhQSemEBQ0KyHV1UfBIOGQsI2ZGJ2JWIS9AJje937wpU+NfYRMo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38663a1a-1e5a-4f22-124f-08de03e0e94b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2025 07:29:25.7953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wpGVw9E8MN3GCzzIXbzCd2yJoBnvUHLTzYEaZSi6D5QJka1kB/oCewYvffNoJX2LeZU1rw1ArAdg7YaH4EgB7Fh1YS/ztwEItrI9vdnSAfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4130
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-05_01,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 mlxlogscore=634 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2509150000
 definitions=main-2510050059
X-Authority-Analysis: v=2.4 cv=Wt8m8Nfv c=1 sm=1 tr=0 ts=68e21e5d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=tXJRXIvTlWhByAJOWg4A:9
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: IWp1SVVavkQ9U25XEF5hSNyjmCgWE8nv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA1MDAyNyBTYWx0ZWRfXx/x/sztjAPCU
 Bo6HNfreqmSY7tR9/R1AlHiWRi08g5+YQGzmIbNi64YkSmUc6mVS1us84Cu/o65CswcOAiXqsrK
 0mnVmEVOudqucLHbgzibsO9AiDY61D4eGOcYcXza5HssMSHsoVu9S/qK0bvoBfZNPny9iAk4kcv
 Q266TLbDFWSJv9S7S+j60WJizEkrnmh0W80UuUtUsJ0DHk32aRgWQh3+Db8zrIPRG2DUDcM0Ncz
 89NW3n8oUr40Mgd9YmpJ+t5xImhIBRWlYwj1iDdaS7mxug1B2vxn2D5FPTmC97uQG79JPXWxIys
 qNaW5d1oE49Zfve172zOnYDKRqsT7SYRuSuz5j310qqn9Awy3nIuhzmMYI29Q3cmYebY6WmxMkw
 HR8a4Tedn5WjkmNaeDsTCU1F2tB2KA==
X-Proofpoint-ORIG-GUID: IWp1SVVavkQ9U25XEF5hSNyjmCgWE8nv


On 05/10/2025 05:16, Theodore Ts'o wrote:
> On Sat, Oct 04, 2025 at 04:24:51PM -0700, Eric Biggers wrote:
>> But for future reference, if the people doing FIPS certifications of the
>> whole kernel actually determine that a particular kernel feature(s) that
>> use SHA-1 *must* be disabled when fips_enabled=1, then of course they'll
>> need to do that properly by submitting a tested and well-justified patch
>> for each feature that carefully disables the correct functionality.
> 
> There's a hidden philosopical question here, which is whether "FIPS
> certification of the whole kernel" is actually a good thing.

Agree, and it's an important one. In mainline that's the only option, of
course.

> Personally, I don't think it is, but if booting with fips=1 neuters a
> whole bunch of kernel features, and that is considered "working as
> intended", to the extent that it discourages the use of FIPS mode,
> maybe it's not such a bad thing.  :-)

I don't think anybody uses FIPS mode for the sheer joy of it. Usually
it's a requirement for certain types of workloads, meaning you either
have to or you don't. I don't think discouraging it (deliberately or
not) will move the needle much either way.

> But with that said, I suspect one of the things that distributions
> might find useful is per-kernel subsystem fips enablement.  (e.g.,
> dm_crypt.fips=1 which might make a whole bunch of existing users' file
> systems become useless, precepitating a whole bunch of angry inquiries
> to the distrobution's help desk, but maybe a particular user only needs
> ipsec.fips=1)

This sounds like a good idea to me, although I suspect it would be more
useful as static CONFIG_* options than boot-time options.

I'm also not sure if it makes sense without also having a standalone
FIPS module. It doesn't sound in-spec for dm-crypt to use SHA1 inside a
FIPS module if FIPS disallows the use of SHA1, for example, whereas it
might still make sense for a non-certified part of the kernel to use
SHA1 for this purpose.


Vegard
