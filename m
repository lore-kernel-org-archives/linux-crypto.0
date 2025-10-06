Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1433244685;
	Mon,  6 Oct 2025 20:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759781375; cv=fail; b=j47humnImD7FfcAXLWnneWWM7c+DfRfos8jE8Ov3oLJjnJ6FPU/WdCShknGp+biGx28TC/TRuAniUn3t3GDxYQyKiM520cBup4XN+BWg9qGZe2WIGtyIWLq7wL2G9R35yVCxVEW+NVE6mx9+QuX/Nz2cO6KJq0xhueTVydZ0QHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759781375; c=relaxed/simple;
	bh=jJEd+cDaPG7hZtAm96+e9e9Jil9gHlP/Cv0stnRtrAs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q2ee6w7+B16DL2Uq0/X5tDb9XgREdwLX9iDyxlbGa41TVif3mCE1lE7X2w21gwlUpCmjO75uc+8hVPzamUSdHC6I4G9W5DX8xuFoGLg3cnT6L0iQfV5zXnCGzDQm3AF9WX+WKYAx8Ag9sPbeB9Hy6PYMSXUsr+KkSw8MLDglBNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KiadqSVM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cNveg3wk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KiadqSVM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cNveg3wk"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 596Jqq1l031654;
	Mon, 6 Oct 2025 20:09:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DeqifD3UPLxrFvSitaOk8heTu9YQalRhaU5afpipYGI=; b=
	KiadqSVMjydJewHBUOdazY2O7rUB1u1qVrGDCBMixjZLCkmkOVGwMGOXi1pJBT8Z
	wzFBmMEt7h2hPUWfwMMluDpFU1Dj3u2OJRQhJtJdD4qQC8hWx4BxNG1fawotcbMQ
	14/CNl0PyOeYYPdHAGttZFXIum/uYMrW/R4tmNaMoUo2isLQJfetMVjFPkRp3k3m
	Fl+tyQSmFhd8exYj7PUDNQyfutaUqbwROQWm+rNGhiZz047HGrV97dMIOkAnDnTl
	ESfC5Wb5NZkGkHqL100wsy2bnc3T40wJzkhjkoXq79DBe4txKQf0JeYY36Pf8oIo
	oOUtjFVIfLBL6y37u1BxEA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49mmacg12j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Oct 2025 20:09:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 596IMLSc001773;
	Mon, 6 Oct 2025 20:09:18 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012008.outbound.protection.outlook.com [52.101.48.8])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49jt17j7re-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Oct 2025 20:09:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SfjcfOVLOisukMrjCQ4gJ06tsOBvI5pho/I8XTTh67tn5q8vIDJzDCwcWVaKtw+vAI4g9XQwtzBnwu/ymCjA0Jr3EaCrzhSqw9/Cn8OX0E3axCKIeuvszg5XBQv5iu47WC0Se68MQxC3deQ/lYzR3OnGTtLxBgmeHWbbbV4IwOrEXGj6zCnNkMT4gSle9bhryOJkzbxpVbMcp3FHK9/VZLZqm93uDUCdiAc/QwZO/LyuiDDfPsMeCfjTrQ0/KEL8shpbSxBBLGvMOks2ehMbN0siJyZqnc5Cx1fRnFyvzdelZM9n15HtRlXw8zijh/nDeUQy6VyjtpbDznyVjTV+Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DeqifD3UPLxrFvSitaOk8heTu9YQalRhaU5afpipYGI=;
 b=C5gdplkyF2bhKiS5fCjFRAF8tL0T/iaSyOtfNIWbzAvMcW6AzQqEocAF0oc+h15IHjLjLlceZU3nkbRd1KIRiIN96CDv9OYyrENwUwd5YtH8SfLNDD4EcLKtzXYZ8dr9l2MqwW2tjauCRBmRsiMzhIn6RLo5xEinMXRvP4KJbHEg3VfPoC93svMNCcVCI7Iz6Q8M9bPePuQ8tk2QG5F2GeIgfS2MO+g3zRh6Z8uKBOWoCscxXkjzR/4wdWC30gx8zwmDeoJ4I21YXtfJXYXt+ihA1QOGvkpiwOaVxPSixiG1iZ5apKdNzD8WSQPO+6gbpZ9WXz3Wmd1qoC5ukt3j/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DeqifD3UPLxrFvSitaOk8heTu9YQalRhaU5afpipYGI=;
 b=cNveg3wkO/WoF0SVzphI0GITg60cSUuHXfw7f1bzY+6lTr7eVJrA6edHpfOXjGDTQKyiV3GuYBtotr5QxKIsrRxtl8TcOPyGiTrlzC08mPvh7yVT19JcrM/fgJPAOQYHJsFfpMAbG84mERfN2LumvT6MXWUset+yEQ6pydv+wrM=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by DS0PR10MB8125.namprd10.prod.outlook.com (2603:10b6:8:1f6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 20:09:12 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%4]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 20:09:12 +0000
Message-ID: <a90447fc-1847-4307-a210-df15cd23f9fc@oracle.com>
Date: Mon, 6 Oct 2025 22:09:07 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: 6.17 crashes in ipv6 code when booted fips=1 [was: [GIT PULL]
 Crypto Update for 6.17]
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, "nstange@suse.de" <nstange@suse.de>,
        "Wang, Jay" <wanjay@amazon.com>
References: <562363e8-ea90-4458-9f97-1b1cb433c863@kernel.org>
 <8bb5a196-7d55-4bdb-b890-709f918abad0@kernel.org>
 <1a71398e-637f-4aa5-b4c6-0d3502a62a0c@kernel.org>
 <f31dbb22-0add-481c-aee0-e337a7731f8e@oracle.com> <20251002172310.GC1697@sol>
 <2981dc1d-287f-44fc-9f6f-a9357fb62dbf@oracle.com>
 <CAHk-=wjcXn+uPu8h554YFyZqfkoF=K4+tFFtXHsWNzqftShdbQ@mail.gmail.com>
 <3b1ff093-2578-4186-969a-3c70530e57b7@oracle.com>
 <CAHk-=whzJ1Bcx5Yi5JC57pLsJYuApTwpC=WjNi28GLUv7HPCOQ@mail.gmail.com>
 <e1dc974a-eb36-4090-8d5f-debcb546ccb7@oracle.com>
 <20251006192622.GA1546808@google.com>
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
In-Reply-To: <20251006192622.GA1546808@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0196.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:36d::9) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|DS0PR10MB8125:EE_
X-MS-Office365-Filtering-Correlation-Id: 45f629f4-ccca-4d42-e2c9-08de0514374e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T2NUdmx6YWVGNE8yODJoRG1TRlhMMXVGSWJLUHBHalFWRFMraEFHLytOdndW?=
 =?utf-8?B?aUZ2Z3RreUZMYlZzUnV1L3pzc0xIY2lYUVdBbFppL1VLNEFWdG50dGU3cFBE?=
 =?utf-8?B?b1ZSam5MMnJvUmFheEs4bDdzb01CTW1hZ0ZTdHdvVWs4OUNxbVhtQzVsRHpM?=
 =?utf-8?B?QjdIWkhHTVVNei96bkNDREQ5SjI0anNGTzlLVlJWOVlFMmdpckVYQ1BMWmhy?=
 =?utf-8?B?RFI0SU5lVGVzZzQvL3ZlbW5TYTBnMFJhMkdJYnBKM1NWcmJ2N0dpSUNKRGVj?=
 =?utf-8?B?ZXo2NWRHTlFwK202UjF3aTg5WUo3RDV3VGxFYTA1ZDdObUZ6UzF2aEd5MmRk?=
 =?utf-8?B?c3I3L0x1SEk3cFp6RXd2dEV1a1MwNFFzTlk0M3ZDMkQ0SjdlcGhwR2dYaS9i?=
 =?utf-8?B?ZmliM25yV0lkNHJ2d0E3M2NZcFZkUEhMRmFjR0NsNnQ5MGd1eFdncGVZODFy?=
 =?utf-8?B?UTUrVnFacmlha3ZScjdmSStUUGtpZUlaRkJuYVJyR2NQSm9jb2JkQ1JZS2Nv?=
 =?utf-8?B?ZkFuSHpqR0RQVlY4aW9tRkFHUGs5WUxhL25SRVdRajF0L0JhTDNiWlNYbXIr?=
 =?utf-8?B?REtJSFVXc3RrVlg4R3YzQkxuU3BkSVF4cWlMV0dBRStRYk5wVUFITEpVWFJE?=
 =?utf-8?B?bGt2MENpUWRheHdRRVZKeGZ5OStlc0N3cExRYm9maXMrRTdxemtYRGs3aUNl?=
 =?utf-8?B?UTRCRjF5NzVjQyszRmZvOUhickZibUVJNUtjVUJhRGs1UWhGR3J4bXkyL2Fx?=
 =?utf-8?B?b2toa2o4QjRpSGo3YVhEcDV1MkUxKzZSVGVFeTc1SERVUDBCNkIzNk9CZkZv?=
 =?utf-8?B?Z1B1elpoamR5SVUybnh5MCsrT2NyZUloUERJelgzZCtmT3ExL2VFTVAxVDAx?=
 =?utf-8?B?c0J3bDBNMVNnRXN3aVRUMTdXZGZwdkROWExrWFZSVmIxdWxmV3FuL3FPZzha?=
 =?utf-8?B?UDNuY3RRamlPZ0FGSW5FNWV0Y0dDUmFKalhtazFzczdwMFVKbWQ2b0kzTzE3?=
 =?utf-8?B?WnJoU3FQcVJGK25mN3dvNDkrbVRqSWYzOW54TVRqaThRS016Y0ZyOWo2dVJo?=
 =?utf-8?B?Y3IxN0d0VE0zUm9TRXZvOVFLaVNoV2hCWjRHM1lwNGF3eE9DRGk4M3Z1bWVH?=
 =?utf-8?B?NHUzTVZXSUxwY3lKT01aY0ZYU3pSTzBCaEVRazhoRVJlUmVqRXNOWCtINXZr?=
 =?utf-8?B?UTV2NU12MUxyYXJqV011czhQbXk2c1duVUtYWnhxU0NQMHdqYUxJWWpQRThD?=
 =?utf-8?B?RnZ1a2gzdUNiTlk5MU1ydmkvcEVKL1FjRWJ4NXk0dmxoVktVM3ZtaXpzSS84?=
 =?utf-8?B?WU9yQWpDU1RxZ2ZlY20xYnZRVDN4SHExRTE1dXEvY2xEc05lTzlWWkNiS1B0?=
 =?utf-8?B?NVZTbWJrTTE0OUswa1JzdHUyQmZneHZWQ3hvUHhlVFVwMjNTVGQvR0gwTWg0?=
 =?utf-8?B?bDVrdE5KbzVXMXg0VDByM01KdW5Pb013VVhxb05KaURPTTdvSmJWbFkzVnNi?=
 =?utf-8?B?QXgvL2xCejZzK1B0VnpYZVY0aW1jNi8xQ1MyRjNoT1lETUdBTXNsT010NUxz?=
 =?utf-8?B?bGxuLzBKMnNLc095b0ova0Yxd3RRZ29POHRDckN4UEFJMEFKbTEyMUhSRUc5?=
 =?utf-8?B?dWRmdUUwcWpZY3hVOWRaQ21sN2NWd2gyY2psSmZSeW1KWGFSaTcvTXR0VVIz?=
 =?utf-8?B?NjRaSHEzaWp1OG9hWVVSeWJLYXlKR0xWOE42TmNjNWJQQldxSnVCaVNEMm5F?=
 =?utf-8?B?eFZ4ZHF5WnVSbGFyS1BGMXo1WWJMb3pBM0lnRkFIWVlJSFgwbjdVaitCRFh6?=
 =?utf-8?B?dFdybGw4WmdxSUxuRGlVL21sTE1kZXdPbjFzeWxkZ2o3U1ZEbFppZ0FmNWxK?=
 =?utf-8?B?OWwxdzlpcTZkOURTWjZ5Tm52cWVMK3dVd01qMkJvSlZWTFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUZFVnF4YUx6cWJLS2VhMEQxTStleEV1YmVVZWNESjh5Y2paZWwxaENsaTcz?=
 =?utf-8?B?d2s5NHl1VndOdDRRY0xKNVZibUxRaVR3NEZJUGlOa3lnRk9jNEVJS0Jydyta?=
 =?utf-8?B?ZnFTMGhXT21EUnFTdklIemRUL2w4VGVDU1pPSjVBUDNjQTAwSjdidFFENHND?=
 =?utf-8?B?THZKeGRQWk9KeW02VmI5OVZFcWRpQmFwZHkzT1FyQ09EdFJYb043UzVvWkNF?=
 =?utf-8?B?VlNJeE9hcnU4LyszdHlkQk56c3hZR3NNTEd2dzJoTEx4RmF0bnhYaVhHRlNX?=
 =?utf-8?B?WmJUc3BZYkY4Z1pWTjBKVmRGcUk2eDVTWHNLL3cyeFB1bEp6TlRNQ2hTSGp1?=
 =?utf-8?B?bUdrTFQ2VjdWeVQ1WVd4TFdIbEEzdUdvbndFTllEQ1FKVUFuMFAwenJ0KzMv?=
 =?utf-8?B?SUErblhMbDJOelBtNjF0eGdXN0VlOUZQbkZydkttK3J6cGsxWUFNVUlwc1lC?=
 =?utf-8?B?Z0J4cVEwLzQ3YWF0ZGdCV0RRSjYzRll5eEVFeFlPSC9nY3E2aGhXZktFYnRT?=
 =?utf-8?B?SWE5WFgyWjI3VGVpWjNJVnRrZFhOMnNZa003UnFoYis1eGk3Z3hpVkk4amE4?=
 =?utf-8?B?Y3I0OUhaekZwek5qaWZpOHdtdnAyWHJ0eXdqWHZyZUVPY3BkMEQwMjZOM3h6?=
 =?utf-8?B?M2VBbUVrNFhhTFFYZ1JKd2pyVkxHOG0vUTFIemVrZFQ2VjI3UXZIOHZtNkpK?=
 =?utf-8?B?QlFJVkh4ODh3M0M2azJYY2kvaGMxWGgrTFdyVEl2dkJhd0Z6c1RBcG1wV0FR?=
 =?utf-8?B?Ti9JSlV0WlgrWHNXRlFpdG5NTXg2SVFRT3JTdWt1Mjl0ZndIYVpFN3ZXL0JE?=
 =?utf-8?B?RDZyM25tTE5ya0htTC9Zd0tXNUtIa2dLd2pUTjNzdDN1bnQ3S1RPRGcway9h?=
 =?utf-8?B?RWpNdGxFYitUeE5rTmxMSm94T2dIanVkbTcveWhpdUFnZjJzdDVSZCtFYlJs?=
 =?utf-8?B?M3R6Sk1aVnJ5ZEx5a21DNGF0QVZQTGhEWit2T2hVL2oyRTBwaDZPc2NGYXkw?=
 =?utf-8?B?S2xoSkJ6UVd2NnhNRkl6cTFXL1pvMEY3NzdrRFZOVnplTU5HSUdqcm9QaEt5?=
 =?utf-8?B?T3pkR1JrNEdSU09QTnlZZDdoT2NaQ3Nzc0FCV3hCd3RyUUkyeWhER2pEeUp0?=
 =?utf-8?B?dFhHeEs2RXVtQUlpQVVzcHNOeXg1MnRWektVY3Z6eTdob05ISnFZRTFvSUo2?=
 =?utf-8?B?dnFaUjBIL29zT3RyeE1pZ3A0cVF4SW1IVEVhRUZEcFRtRm1vVGRUSFJ6K01R?=
 =?utf-8?B?RWFYeXFRc3RXYlpJei9DR1czUDd5M3dWaTRUWlhYK1ZmOXlCcVlsMzBONmFM?=
 =?utf-8?B?WGllUFZpSUVuS3hNMTVzTXVhR1UvYlhURFZ2enhnM0VwNFZDQW9jdVVTYUl6?=
 =?utf-8?B?SVJZZDVndVpNR2tOMnJtUTNHTDBTekZaV0FCNkNVUkdQUEEveGw1czhPaGkx?=
 =?utf-8?B?OU9pQVliMjhIOFMzRTdyWE51Yzc2eWE0ZDI2OGYzaVVzb3JRUzNSNTVLdHZN?=
 =?utf-8?B?RHZ3alZCVnJDZzl1bU8wOExjdlp1ZW8rQWt1SUI1WjRtRkN1V0hmak1tRUF2?=
 =?utf-8?B?RUk5NnF5VVBuZ1llRGU4SVo2clhIQWVDWlRwUSt3UXlMZnE1VFVtaGJNaURl?=
 =?utf-8?B?Z29GbUI4Q0tSRy9PSDJhL3dTOUhVM3hodGcyTzd5UGZGeHkraHd6cWkwd1hs?=
 =?utf-8?B?c0FjeWhCOFFYMWpWMHkvUkRxTE9qeFExeUFVL3ZxaVhKbExlWUF2WkZXc21S?=
 =?utf-8?B?TFZuSW5kaHVrN1BHbWN2eUNSY1N2QWVobHBmMFJrMm9NUnRmdklISWtkdlNm?=
 =?utf-8?B?MFQ4amt1NW12WVFtWkEwNVhZZ3BFNjNXb0MwaUgvK3o2Z1ZhWWpISTd2NlZo?=
 =?utf-8?B?bEVmRTdzY0tRYy82M0duVFZnSGZhZ2owVldVN2JrbW96WlI5UHVXY0JuTHNL?=
 =?utf-8?B?ZE96NE1VWUJYb0I0RytsT0tMbytIYmd6TmlxNWFUZE4wcnhGbUVqbEV6Sm9F?=
 =?utf-8?B?N2hNbTVDVmlGTytXQ0JxWVF0N09YL2toaE0vVElaTGl3cHkrM0xpTnZmK2ZT?=
 =?utf-8?B?VGtHcCtLaE8yNEhPR0I5V1k2K3RqZXhQTlpRNGxRTnZLSlFKUGt4SnB1djBz?=
 =?utf-8?B?WHAzeCtXRnV6Ukl5U284em11Szg4Ui9MNFBEVys4S3VhWWdBWlJIaWN6V21k?=
 =?utf-8?B?NFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/xF1T2hBGbYMR2zWHMfIHRITJDSAC1h+zQtcHiulmdi4I2YHvvQzPH8FNYdyug2NB0ldEd4eUaz5QyUEZNdhAye1AIYukGUeuc4wDpRogPtAt5vC4zw0qeOE2LOZzjUchRoFbteKoko4K0yiM7QaST/+GJNI0TxQRGCvoU22fSsV5X/YDla/vIOyzzC8SDNbtFfFPJdPC9ID2wVjHeqSRfnjMU3nu1WbvBWMl8pLLd6teQkpoiqhJrLwUQG0G3TFQT/1OJCh1uCa1TgXz45pPB+5OrTgycGxvwm7jWvuOH7CFdcQQZjr8bVz7R61NafpXjR9tRfK6grwnpYKVGVW54+bdC/0e30vxaPoZDTv2616jgrUt8g7mGsG6aNLvm/eABpXxRrwdWD/vFP01njHqMUi78ZZPaCLa3CI/GGpSxBeAbIoIu4nAfIuWEyF55fRWMh6sNbWDwgRL9r23TVcSADnIycyOGfrKFuZnjoln4iwN8rbP5POwTh0xtUWeIYCWPzLckPZfwHpxxcxA0nNSvzqWuUP22kz90E+3RmJQu1+bPzRyz45g6fDnQMkXQmfRco4AYaiDYg29zHPYknJLFxjOrx+luGMEG1ZZVUaR3o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45f629f4-ccca-4d42-e2c9-08de0514374e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 20:09:12.0417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g425dudH1VNd3HmKXxnAId+42X+nIovn14EFV2JKEtys+zEAchoqOCdBhzXw7jAqWCbAGsDfVJ6DlV9RjsdsWFBpWA2607tqTct0l+DyEIw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8125
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_06,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2509150000
 definitions=main-2510060157
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA2MDE1NSBTYWx0ZWRfX2lU3ZR/Arjkc
 n0yvekPT8Xsq3PHIXOo9BYSenFF3cW9XlclopI3CHPOmPIvDzn3in7Gfrpd+D5LNYoQWF/Lbm+N
 7H7yFQeG9j/jKtUx7Jw0kJgJMm5vBszeBBCGrbwk8A0A2bPHp3yKy1tTU6btk/n6+jpD5Ho7O8s
 Afr4qZp4wROCRWQIXodU4IXZJhLDOECS6/H3f/2fiJ2R439R/+ec/tBelDWXtH+AtmnZmKBlZEO
 jUFZHN/sHc8oEGkfcdtSneXN/Mg2i129/jf8Ieyf+VLVi2+V/qDX6YHcL8A3sZZJ4USp44Nqz5K
 nXnejS//csxQkwcEMxQ+w5O8ibTSGCa0HZ0vHqH8aipVlSPYXoUC+J0GjbH1HFvW+WdDeEv89l0
 DtNoUgiSHm02CSXsnpJ5d8ehwEO+Jg==
X-Proofpoint-ORIG-GUID: DPNwlKBZ8J9V6hjFnCwJ0v5cFXOJCBB5
X-Authority-Analysis: v=2.4 cv=YqwChoYX c=1 sm=1 tr=0 ts=68e421ef cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=Ntg_Zx-WAAAA:8 a=Iez34sYJxVUvvupeOEYA:9
 a=QEXdDO2ut3YA:10 a=r3OcyC8UWvYA:10 a=RUfouJl5KNV7104ufCm4:22
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: DPNwlKBZ8J9V6hjFnCwJ0v5cFXOJCBB5


On 06/10/2025 21:26, Eric Biggers wrote:
> On Mon, Oct 06, 2025 at 09:11:41PM +0200, Vegard Nossum wrote:
>> The fact is that fips=1 is not useful if it doesn't actually result
>> something that complies with the standard; the only purpose of fips=1 is
>> to allow the kernel to be used and certified as a FIPS module.
> 
> Don't all the distros doing this actually carry out-of-tree patches to
> fix up some things required for certification that upstream has never
> done?  So that puts the upstream fips=1 support in an awkward place,
> where it's always been an unfinished (and undocumented) feature.

I can't speak for all distros, but we have a handful of patches, around
6 or 7 I believe, most are fairly small. (We are, however, looking to
move to the standalone module I sent the RFC for, which has a lot more
patches...)

But yes, mainline fips=1 support is in a slightly awkward place. I see
no real reason for anybody to ever use it in production unless it's
actually a NIST certified build either.

That doesn't mean we shouldn't try to minimize the amount of downstream
patches, though. (IMHO, anyway.)

I would like to try to document what fips=1 is currently and how to use
it and how to program for it (if nobody -- however unlikely -- beats me
to it). I came across this thread from over 10 years ago where people
are asking about the kernel FIPS docs and we still don't have any:

https://mta.openssl.org/pipermail/openssl-users/2015-March/000904.html


Vegard
