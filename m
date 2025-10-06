Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E771D61A3;
	Mon,  6 Oct 2025 19:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759777929; cv=fail; b=tAWCOROXGTj/xguzUmJrkWvTtfEtB3+2b8BxODQmGmyNTBEa8hng4bbwq+QFx6pB1pyz/oXH6gGKlL6inCk9Uc4wu2GawH9hShXHsI+sVhp0Bc6CAU+8ToMGq96X9090LemFqeqruFx5tl/QzNPn8uALa34V/ujXBe906PczzXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759777929; c=relaxed/simple;
	bh=8XQmKqdxqkslznLt2laee0y6saqrKLqGL+N8bz5yltE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jMiIZsV9JksfHUBaAECmZn6AvLXEB1HHdhd90BG0kSi90364yEkcWPWrXoxjsjH10DlgWEQ+d7Eo2RrPO3DMZ50e7XejAUkstCK9/gEwQTnr4kIpWCNPE6upw/97y4/PP7i0Tvg2vxzgS+NPKGOdCbgtVVK1cVgRkcR8xhTLP2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CjIWI3Jy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yQD6cLfb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CjIWI3Jy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yQD6cLfb"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 596JBoO2027842;
	Mon, 6 Oct 2025 19:11:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BkUNDFfWx7NmMHD1kMBVQCZZ3q1EkXdX5Hv9kPaA/rI=; b=
	CjIWI3Jyc3+vLpomgE+/hEO4SQuo2CeOf8tnDbePJFgbSl8oCeBnP+1s2U9J++/P
	so67zI4wUen/gBRc6Dg0BIxlnPAjbs0pY9vOnoN2MuYIxgeXWebVHCyahfkQVAl/
	6De1SHek1WsA0qACIGGhKGx+152PPAxpNAUdOPaMWXOPclY/QmGI0yWhvWoLW8Yq
	Zd+x56/WkQb27UIbnYZNhGjAq4H6WYVDoUg9J49OG4Sh5AutgVE7L8kbP64LgvUu
	3UA2HButPLxRReSTKaZ2nKjwZpsJJSlJCPlSF018Jz9DFGt/olm8Y9myoFOazNCQ
	j9LLA5tPUe2bLd0qX2gmRA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49mkct01ck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Oct 2025 19:11:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 596IMBGD040828;
	Mon, 6 Oct 2025 19:11:54 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011040.outbound.protection.outlook.com [40.107.208.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49jt17ga8a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Oct 2025 19:11:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pmQjhMyL6WVSsZmD6Eaps1H8pbhcX8dhEfx8KdF4Gzy9xBeximsh8NviC894TnDZIsaME08MyZ67JaVUprpBi/QHJyMwlbDXaUqrG3T9ZZWkZMsnXNUZD7Z4GSxc6ZBwAtjbcO1yNfZPrSQyHu4rdWNVuR/h1lGAPW7n2LSQyHaJAUQITfv1Kh7a2vN/n4wJymzmLljHnYaLdju4P+WPxRFsusbvzPXDOwbx6shTj/OxfwNVNCOyRNVNvP2glB++8jOVKZyH5gStLvbldKh5o9pC1+eZOHT29tXadXw0TYx6CIr496ELvBvSCg+/b6gjKnCUMtdW9UAjmKgktGMT/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BkUNDFfWx7NmMHD1kMBVQCZZ3q1EkXdX5Hv9kPaA/rI=;
 b=GOt1irezyQ3h+1hEariL49Sah4TXFor69Gr3ERbnEeV8+G7DFM3Hk833t1jLT/0QuFJPh6RkuhqrIX9gbni139MrxUDgfkMR0bI/LA4Ji5ugd9iJUlQAZS9Hf+obEBEK39GBdHPpR9W+IpWckrWHVREiB7xhrwBPDv44arVh2WJgwwCaEgpArPCoDOYkGkoYGf3wcUviFnLSS4iiS73GTBP7g3UYZaRIvn+3vtnQdrBiIHR6H3RqDfWEZbeq4WkLxno18MGcivv4+so6A/2L3HiR1c6mAW6GxDyN++uncHL3y1OVIbp2S6TNRMkAoV9yNYNJzOONCJ7Sh57lvfJ68A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BkUNDFfWx7NmMHD1kMBVQCZZ3q1EkXdX5Hv9kPaA/rI=;
 b=yQD6cLfbccibWDYzVkSNkvF+rxzYD8OjgBztQSpsdxWb4Vw0f5VNBA6E5lh8eQGw2X7iHF66dKYiuLyaEbKqWBRFGgVmEOcWONhS4lrQaRHhCWx0iScwK6G9m8TJU650kyM5mH1mo3mSCoX9e1EQZ2vIhQid1GIQ4HYRxKwI83Y=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by SA3PR10MB6970.namprd10.prod.outlook.com (2603:10b6:806:315::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 19:11:48 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%4]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 19:11:47 +0000
Message-ID: <e1dc974a-eb36-4090-8d5f-debcb546ccb7@oracle.com>
Date: Mon, 6 Oct 2025 21:11:41 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: 6.17 crashes in ipv6 code when booted fips=1 [was: [GIT PULL]
 Crypto Update for 6.17]
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Jiri Slaby <jirislaby@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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
 <2981dc1d-287f-44fc-9f6f-a9357fb62dbf@oracle.com>
 <CAHk-=wjcXn+uPu8h554YFyZqfkoF=K4+tFFtXHsWNzqftShdbQ@mail.gmail.com>
 <3b1ff093-2578-4186-969a-3c70530e57b7@oracle.com>
 <CAHk-=whzJ1Bcx5Yi5JC57pLsJYuApTwpC=WjNi28GLUv7HPCOQ@mail.gmail.com>
Content-Language: en-US
From: Vegard Nossum <vegard.nossum@oracle.com>
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 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 8A==
In-Reply-To: <CAHk-=whzJ1Bcx5Yi5JC57pLsJYuApTwpC=WjNi28GLUv7HPCOQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0068.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2de::14) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|SA3PR10MB6970:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b1ead11-f58a-4466-8439-08de050c3259
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bkh1MFFDeVplUUlIQi8rOUoxMzBaWmxWcUVLODdYU3FsalBqazRMdlNWMXFy?=
 =?utf-8?B?UFY1bWc0SE4vaXJpeFpibHNndFNzZkdOSzZYWUlIT1c5dzVTNytzcWFsdER0?=
 =?utf-8?B?V0xYLzg5QUwyYWYvSzN3dkVDSUJVSXlJRGZSbVlXcmRSaEthVkZLWmNNUXRm?=
 =?utf-8?B?VjljMVR3czRYa0NObjNManJQb01JUVNpUkl2SlFuYXFCbTkrS0lCODl2QjRX?=
 =?utf-8?B?OFVmam8vS3hiZEw2MnljUFlQOEdzSVd0MThBRHFpWEhFVkVMV0FhUi9rMDd5?=
 =?utf-8?B?K0VSNHZGNnYzYngxdWZhU2NUUC9PWVZiR2R3Uk91ODkwRU5qTDdITWlCV2JF?=
 =?utf-8?B?dnduNnU0NkVadzd2bHBidEFDRGdCSnVFOG5jRjR3YmZROWlwM1p6Y1JoZWRU?=
 =?utf-8?B?Y1NlN0dzcmtSSkREdk5WVWNNbVBiZ21qdVA5TzJ2WE83SFJyNnNVUlQxWlZh?=
 =?utf-8?B?ZlFGUDl5VVFWSGw2UHlXdHJPc1FhOVJxb0E3dTFWbklSV3c5WHBiMnBhYXRz?=
 =?utf-8?B?YjFXaTFqa1lrcHBJdnRERVJJL0VHc2JuTE81eTBWYmI3dStyRzV4YWhGTDZu?=
 =?utf-8?B?d0E3ZjFGaU5IL1Bjay9rd1VmdTR1c2lsTG8wNHBGaklpRW5ma1lZS1ZiTUs1?=
 =?utf-8?B?NDZkUUUvcTdSalFYTkRuWFhvNzRyeXhFSE9uQ2grYUlDeUtWV3d6ZDM1MzNZ?=
 =?utf-8?B?dUVmT3VKNTVlWE43UE1CWUJaTlJQZ3FLRngydnlWcmo5bEpqcnkyVVNVNWU3?=
 =?utf-8?B?TXVWc1ExMGgvWnBRdGV4QVdjdnRSeWxwSDk1WVErQ09ZZGlmd1IvUGdEZVRO?=
 =?utf-8?B?a0owZktudjY3V1NEUmVrd3ZqRjZYV0VCWFRzUWxmUUFsMFRHZkluTlpmQk9H?=
 =?utf-8?B?WGJmV2gzSzNoeHEzdTNudjNROHB1bytBQ3pGVGZLbHMwM2NDZDFGQk5LTmp4?=
 =?utf-8?B?NEZRbVMzZXp0Q2RxYTZzRE5Pelo3VWVGSG1TVTVuM0lNWEZmOEN3Z2g4Sklr?=
 =?utf-8?B?M1p5SWJyUkFrZUtSdGFIUisrSUhodTF4R044enZFRENRUFNUOWxFdW1ZK0pz?=
 =?utf-8?B?LzhNUDNtcWFPcllwWG5NTmtJMXpDeEdnc1YzZC92R0JDTmZySkZqdVQ5TDkr?=
 =?utf-8?B?ekpTekdUNVJlZVV5bTVXMVZXbWlWd1VCelZ4b0orQXFGR2xmWXFtUVFad3BH?=
 =?utf-8?B?RnhCTGl5K0xHdGdQWkY5L2pJZDdmSnprSnZMWFl3TC8rU1pDeDdONGJybXBj?=
 =?utf-8?B?R0NKYXRtRGRVdkhneW04TzlnRTZmcGdBeUVMWWp2VEJWUGNrSThTbEFrNDBR?=
 =?utf-8?B?VnlqR2NOcDF6UlAzdHY1bkNNWWo4VlhBQy9jbDdvZ1BhcEVjdGFQa0ZscEw1?=
 =?utf-8?B?cEhzeHRUaVVLOTJOVjhOUFFjVHlhNENQUmpqZVprOG1tekV2dXRaNXZ4clRm?=
 =?utf-8?B?c1h1KzdCUlh6UXh4WlcwUDNHQUtkNUliZ0w4Vnl6bm9QU1lxT050NFQ4bmUx?=
 =?utf-8?B?S0xpY0xEdEFFR012bW5xazJvOWRBMkNqQ3ZZM09EeTk4Q1JRQ2xqOWJ0eWVx?=
 =?utf-8?B?WDlyT3ZtTmZuOGtDU3RBSWF4cjQ5VlZUOUFGODBNcUdDQldYaXMzVjNyV0s2?=
 =?utf-8?B?eUlucVBVVmV2RkoyWFF4Q2NGZisxTG1JclcyWHFub3JzVFJDemM2NWtOR1Nx?=
 =?utf-8?B?em80ekJHK1M5UnJiK2lQWXdJV3RFWnIxcmZoT21sSEdIY2hURGtMem4zVCtO?=
 =?utf-8?B?SnpHREFsUEd6Ylo5QVdQQ084dDVUWldBdk1YNm5RbXFpM3VzTFV0SUVaOSsw?=
 =?utf-8?B?enJ2NGZGUGJtcENKVmhTRksvcW1QQzJVdkZLNEhQTXNDcFFKYyt1Z0djT3Y0?=
 =?utf-8?B?SVNabEErM3ovODdNOHFTTjQwUjM0N1NDc1JXYXVVanBZbEtNcFIwQm8vOWtt?=
 =?utf-8?Q?F5IotoLed20f9zX64NAL9MCgmZ0o2YdW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L0poTC9KMnFuVTUvdHFhaFk5ZEE3VmxlcnRsNyt4ZmIvYW41aW5UcHdEeTFP?=
 =?utf-8?B?cFFtNHcvRWtYWkdZMm8xcWlqbFFuL2owcXo2eHlqNitlLzR3TVhZU3VtVnkx?=
 =?utf-8?B?TG5mZ1dSbk5jOFpFZ3ZxUHo3VlZDOWJWaVBrR3F3cW02QUZJalE3U2RocHN0?=
 =?utf-8?B?M1VZa0kxeitQYWpwelpsVTdMdUcxRmU1bjBsY1dKNzFxOE9CSTdXV1NjdmRO?=
 =?utf-8?B?bld4a1piUU53VVB6UmxwQkxrNTNGdytIUW9Na0thRFRnYlE0T3dqeEY4c1RI?=
 =?utf-8?B?QWIvSGNxNjNaQ3N6OFY1a1RCd2tzZ2lFSytPZUdlUExzMXdUaEVqK1JGZGg3?=
 =?utf-8?B?OGhIcXNDeEpIYmlFRmcydzU0QWU5NmJ2cFh6dDcxVWVZMEZMNjd5NmJ6OExr?=
 =?utf-8?B?NkJxOVFLLzhURXhRMW9JZ1hreDBKNE5BVzFibkdCczNDa2xyZ3Uvd0g1R1NQ?=
 =?utf-8?B?NXowY2tiNXYwRHQ5RndTbTRrN3ZGWCtSd29OZ2laOVZSKzR4dDA2c09YYUR2?=
 =?utf-8?B?cmVjSVgzWk1RN2FtdXd2cnBYTjNuMTZUY3ZiZGtMR3N2QnlEUGlZaHliR2s0?=
 =?utf-8?B?UFg2YWU0MEJBeXRrS3h3eGIzSWVUenQ4Z1A1cGJJOVZtbTVxVnoxUVBVZ2RB?=
 =?utf-8?B?U1phZGdBeklSZU9pWFN6eUtOODY4VEFCSEFBL2N0UXdyYit4TzJkM0RvNm1j?=
 =?utf-8?B?Q1RnMHBXeG9zNHBIc1NhakJBUUVub0QyQUhNY2FvN2VMUEkzalZvLzg5VCtz?=
 =?utf-8?B?b1BoUFlLb0UzQ2JCVHE4U1NWZGZldHBzUEs0d0F3NmtJQllRb1B0YjBPdXVK?=
 =?utf-8?B?YkZFdGVMMEkrMVAxTmRWek1yUVlxZjdZd2szcTQvK1RoQkVrUGRQeTdOOXdm?=
 =?utf-8?B?dXhDTGdCMjZjOWVVRUpKT1hlNCtWdllPRTJDSmd5dTlIVDZkQXZHM2FXTFY3?=
 =?utf-8?B?R29ZeEcrSFNSaGJOTXp1ZjhlYUk2c0JrUC9zMG9aMkNGQklpbFFZWk0zNUpB?=
 =?utf-8?B?ejBPT3ZGR2ZHaENHdzl1RWUyUG9CTXp5RW9BOUhkV3dkMFpSN2hCRWg3TkhM?=
 =?utf-8?B?S3Zic0hDMndpVlcrU2d6enRweHJEaERRd1FSZjJOZm1jbHJuVU1rWFJuQVJZ?=
 =?utf-8?B?dnpBNmVmcUNKTXdGY2xTc3RhaitCbi84dFlhVFRneWpPeHROaVVxZVdVeEJv?=
 =?utf-8?B?L1FUQmUrYThQek1vNUlZUWx4MnU0b0U3YTJNMUhsZHBNQ3U4WlpWUkMvcUxo?=
 =?utf-8?B?MUFvZGFGMlE0ZW15bk5KeGRDWUZTTXlYaW9SUEIwbnhCQTBFblpEcE9Oc1FT?=
 =?utf-8?B?bnpaSDhoUGIrT2JoaHJNN29ybkdZUFJFWFpWaS9mUDRUVW4wSjlEeUlLbGpo?=
 =?utf-8?B?SVh5L1h3OFdaVHQxakI2L3gvZm9lMW82R0VWWHBKRGczZlJhbzNGcmhCZFhr?=
 =?utf-8?B?cktrVWVFaWxUWjdtWjdTWEdJMmliZEYyaC9aMy8yWEpWYk1GUWk4OUJNRXJR?=
 =?utf-8?B?UnJQTU1kNCsyR0ZIaDNsZ0ZSUnoyUnFRdWJ3UDZXYTZSdjNUcHJnOU8wVzlx?=
 =?utf-8?B?c3BKa3NJNWZZOVVKNUlDUFp2WjNycFM4SXFYZ0VwZEVLTjZydEs0MVZSaTFJ?=
 =?utf-8?B?ZHQrYzJhU2RTQUpoclJTQjdmaDVwWUtiUGtuMUVGWG0vaGUxcmoyMFVDVXVq?=
 =?utf-8?B?RysyWWt2TGRZUVJROUdNMzVRenMySWd3MTMzdkxsUDRwMWNid1YyMFoxRExV?=
 =?utf-8?B?d2FyVmRhcUtYam1yaXozaU9IaXIzYTdHR1lSWU1HanFxNHFsVGgvWWFXZXFq?=
 =?utf-8?B?c0xQUy9lSzhZSHl1eTJXVlhrOHk5bFZ6RnpLcHpFQTNaTXFkUUJwcXlzdzVD?=
 =?utf-8?B?em1iNDhjQ1VIRGlmQUUrd1pmZndmR25SbmdQdE1XS0pWbmFpaDVqTG1xa1h4?=
 =?utf-8?B?U2h2MGlMSmExQUlFOHF2SWN3SzJzKzVzUHQ1ZjR5bzhKYTNma2ptMXNSWVht?=
 =?utf-8?B?NHVOMTRZcDNuRGxvUHZVVWM1dzhqSEpLM3RFZUc3a0FVUHVsSFlyUHg1Y0Zz?=
 =?utf-8?B?NHZDUENMYnI5SGNvUjFMbGV6NG9EZ1crUm9TSllRQ01Od0s5TzU2UlhXcXZw?=
 =?utf-8?B?WDQ4Ymt1cGEvei9vdnNzM1BlQkpDbldFZGc0Y3BVeTdDSUFBTjRxRllSc1U5?=
 =?utf-8?B?YlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OwLgYdkPiJWOrIxnwJdZD+KeIY7jZ8UpO5zv4XLi8D4rPgTTixcV5xmfcFbWnEgPU6lBvlCGU5dkN1s7PFPMbG83iZGIgd2qSb6T/Hqh1WkTalN98GferZinlHDesh0gHBH4LcynAJCOWVOkopqk49PD2An4y+pUfdb4DihBzHod2GUJqmmY+dNVFFMhcuIfOXifKA2Zr+g9+/IWX2LPdUe4So6Yh3iiEy0/ibG8BfHMLzqXMvhTtms4S6Yh1mUVDgaw54Q0cP3uFZHChNMEbaeRHIGiNvRURcemx6SrLZ6jnZ3wpz2LKg8qeGGiT/iGZNfDZyQDruEs7k5zqYRhOvxJPN/+rsBRyI0nJ6G7Ap+/+3iDul4JAzkb9QVetzcD5L7GzLEfz+4Ntf1RDW8i9Gxs6Bk5SP4jKTcu6qbqaRIzLiJdUe0j4erRjSBrTdo6gawA94Zqiw9htKrGtuq4v5fx2J6aRcW9HMJY+W/nSDYfxTWcq4mVvLk8HjkNwzI+2HPwQWeVOF0WHJ2VaPmhtdgC/xjn5ozbIA3YQaR4TbcSwuQouNDE3t5mG0K/mlZCBbBxSA7GdpbKxiIehVlKENA8POo+hQsjBWJAJHIGmIc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b1ead11-f58a-4466-8439-08de050c3259
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 19:11:47.8877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uzK3XHBdmys0ePdBnBN7jBr++amLRu8/MVjKBUJXXOLBI/lAohBSbuUjwUhXtsMaI0RKIcra+5LXhOgCvWO0pCvWigWW+pQANFP6bQZl7n0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6970
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_05,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2509150000
 definitions=main-2510060151
X-Authority-Analysis: v=2.4 cv=R4IO2NRX c=1 sm=1 tr=0 ts=68e4147b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=yiFPML3PaisbbmmCvLAA:9
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: KRbElGTQmhfofPU-221xJcsSWCjIIdYJ
X-Proofpoint-ORIG-GUID: KRbElGTQmhfofPU-221xJcsSWCjIIdYJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA2MDE0OCBTYWx0ZWRfX7J5Xd46YffBU
 VoNZzf/theUkIbgfnSyREbe7/gzQ2/TszvhCJH34EGFyzGAoEphNPKTx8jLDNbyD5gyIF348DXh
 fCoGjIld45QJKdOkvJz+xRi5VFll8L/VgecxjkiV0lgUhssx5s4eTVHtQjv3z5TfbPsYe5Nbl42
 EULATPeCrlnOs42+cQvrzM3DJaVRh/s8J6hqnnla9ZqyYgdLdqxD5et9pVBPi8YfQbsuzDKP2aE
 AACXbHOv1EUzPwSywZ82UcDRpNBdUeCVnCGCQTV0oNwER4450P4IEYlT3/fBvISfZ2cn4irs7xz
 8hDkQqHQ/Hp/0uMc+eat/CzQsTOsEDlzsqrf67C8rvDnfPwCsR5GXfnQVWchiuV1JgytPiwSBgj
 YUpSHbgjeGbeoKFMzdpIUZCLL30/8A==


On 06/10/2025 18:19, Linus Torvalds wrote:
> I think the other way of writing that is "fips=1 is and will remain 
> irrelevant in the real world as long as it's that black-and-white".

On 06/10/2025 19:11, Linus Torvalds wrote:
> On Mon, 6 Oct 2025 at 09:32, Vegard Nossum <vegard.nossum@oracle.com> wrote:
>>
>> Okay, so I get that we don't like fips=1 around here (I'm not a
>> particularly big fan myself), but what's with the snark? fips=1 exists
>> in mainline and obviously has users. I'm just trying to make sure it
>> remains useful and usable.
> 
> It literally caused non-bootable machines because of that allegedly
> "remains useful and usable" because it changed something that never
> failed to failing. That's how this thread started.
> 
> So that's why the snark. I think you are deluding yourself and others
> if you call that "useful and usable".

Yes, thank you, I've already acknowledged that my patch caused boot
failures and I apologize for that unintentional breakage. Why does this
mean we should throw fips=1 in the bin, though? That's a total non sequitur.

The fact is that fips=1 is not useful if it doesn't actually result
something that complies with the standard; the only purpose of fips=1 is
to allow the kernel to be used and certified as a FIPS module. But as
SHA-1 is still allowed for now, please go ahead and revert my patch,
it's commit 9d50a25eeb05c.


Vegard
