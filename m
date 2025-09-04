Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7AC2E8DE9;
	Thu,  4 Sep 2025 22:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757024967; cv=fail; b=Of0QYW3RfYr5LzbiR9w/I8GrHA/3ydlNsSZjsYdCWXEE1JzEtjxz/KrerY/aOBUh9afbidJMaAHHkCovtcuLa9fB2ZQcXnm0EQrnehPfq11x2fC5/BTlKv+U4FBwgwpCXmsdrntADTN0kUsWZ8n9gk8dET0HijZoDBl+GTVdqjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757024967; c=relaxed/simple;
	bh=p9yl893xAswA6JRyJgAXm7JcHth9p+k2VctT0CyZ9iE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=V7zp+qXATLmStrY2xM0sdcNDDf0rbj+/oIQBSfyQ/k+cER3gZhGp6iqEZsTrq3D9lov2ndx/qXn/dh/nHmNhvu36SYEQy4DaQ5TSsc529012xcUIZDB9CI3zIPa+vRTjjrX9oh5t54y0S/SjYl8t9LTEsXvpliRkLSaOxbSV650=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ikBEv7Q3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xW7TAQV/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ikBEv7Q3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xW7TAQV/"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584M9n62026186;
	Thu, 4 Sep 2025 22:29:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Yo/DeoZgVD6k6PrNlD98WyNCGH7fXMG4j8jSktI97IU=; b=
	ikBEv7Q37G+jArAP7VYZ5FVlshYnWbkTu0y5rHj3Bh27QjaSIfdgQlmiRrUiJDYr
	gS/t4fUOFxngEW1XTPmX4aySkeHDxWDBSBJ4pnoy3uXIcVdU6tIhVwc3i208TjKb
	vFcRKm9/Dw2/e4uCpANrNUps1UsqF/lI9nDBJYa7AUfa9DCohb8/YjEwhFRuaq05
	GKnXj9vCUTry6/58FkI5i4UsAMFv4qNxKu1k3gJ3Z9bk/ON7MnvQBe/HPaZxaX3c
	tGJ/jRdfss+7NQB8MmRkfPXAzN1baOfg6vabvLX8qT/m8QZJEcF9nVcy+FYP54Jw
	pp0grpNfJl5SsSNSb5SXkQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ykak014h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 22:29:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584LJR58015810;
	Thu, 4 Sep 2025 22:29:08 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48v01rdm5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 22:29:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EKkKudEmJOgmrcMjlZUeoKgrH+0O1fLhTkw21fwoVa37ZGgkJMk5l2/Ixi4kqaddqhKQM+cFW1ic12CLS7YOt3BhZqv/sJodbZqgdpnjUKNYY3ihD0Xu9nAD8Se9Si5ZRo7A1uHdFXETiQYGSLGG0cjBC9WL7Ms4jn5Q+JVz/YsRdF7ZnM7am/OiyjAjECIhWIEilqjkf7UOyW5b4m6mI/MDlQERvyBWqdxG5nKcSoXFCRwAiYoTdn/SO1xuwA1T3dVcJQK2KcvWldZGlEKdBIEFdp7F7iA3/yTEQhfR1NS/YKoU8pTWXIVrObc7Be/33kozO0BzsRkB0pMHFEA7WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yo/DeoZgVD6k6PrNlD98WyNCGH7fXMG4j8jSktI97IU=;
 b=MrYL7/jfCedTYfX8UB/nBCig31H31/5n0HknbI0anu8ICdNQqwvll17mrbz4WZ2HvFhvIVBpCLeKeCnucrKz04ia+qavRKYNXwogms+YR/y889uVeylCcNbFYophNREV/lqj0LUIa7q5geFgRycl2aZS9bH7CFOirRaZvtd8BUvmm/OqBXaW98VFfvJw38OFPUvMfux4vCROughgi41Kf4XSXBPjWcxLCVHslwrtzKIPCxMlEa11xrsLXQb9hVRhql8HKmaj9GgGaE9halbfSnskb4HxOBKfVntv3Ow1G+ioLE/LAqvRHHKsUb7fbL1MGlNh/8WooTrGDqV0nUBlHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yo/DeoZgVD6k6PrNlD98WyNCGH7fXMG4j8jSktI97IU=;
 b=xW7TAQV/naSpU/VNNwC4l7nU6/55sY5NB37IoRLdEalmF93KvITBorMaA5P37bkn6kx5+ydn1jrc4gPWWK+yFdiLz/untin2pImR8XmsMteOKOGREQpA40+Z5VpLNlIo9L2v4TkYUqsgSwh3soEZnAawnctoYw65ec2xDQkxngM=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by PH0PR10MB4517.namprd10.prod.outlook.com (2603:10b6:510:36::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 22:29:05 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%6]) with mapi id 15.20.9073.026; Thu, 4 Sep 2025
 22:29:05 +0000
Message-ID: <51974d92-776d-4688-bc0a-4e5ad5f04ade@oracle.com>
Date: Fri, 5 Sep 2025 00:28:58 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 103/104] Documentation/crypto: add fips140.rst
To: Randy Dunlap <rdunlap@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
 <20250904155216.460962-104-vegard.nossum@oracle.com>
 <de23961f-ae2f-414b-8473-ce9eb17646fb@infradead.org>
Content-Language: en-US
From: Vegard Nossum <vegard.nossum@oracle.com>
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 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 8A==
In-Reply-To: <de23961f-ae2f-414b-8473-ce9eb17646fb@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0047.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::14) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|PH0PR10MB4517:EE_
X-MS-Office365-Filtering-Correlation-Id: f5e97733-c841-479c-4ac8-08ddec02748e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TnhDeWY4cjFLb1RNcFd2N0N5NkRMQUlCZWcyOUQwY2dMTSt3Y3AvWUs0YnVp?=
 =?utf-8?B?ZEhnOXFacmVzRFZDSFhXQVR5TGpVUEp3NzZKdW40MGZCTnduVEFNTGtQQTRh?=
 =?utf-8?B?bDgyTXUyTkpyTHJMNnNuTFdXdUx4dEttb0VOTUNWeldvdTRXQzVaQS9UZ3lL?=
 =?utf-8?B?dCtNbjRQQkp6MkdHSVo5djN0NFRNMkhod3RzVlJSWDNIcEhHeHFLYll0dzJE?=
 =?utf-8?B?Rmo1M1V3YmlTYzhINHg0c2RMU0UvRkwwMXQzNDJxeUJGWG9mUm1sd3gycjlQ?=
 =?utf-8?B?aWVrdm05NXFwMndLZVFzSjF0T3hIR2RPaXpkdkFwdEhLNHNTdktJeGhmaVdP?=
 =?utf-8?B?UzJlc2Q2b3V1SXR4UmlvZlMyY2gvY01JbVVIc1h2ckFOTi9pZXVFc2RiUmRR?=
 =?utf-8?B?ZWNxYUZ2TktpRUdHRm1hd0ZDN25ocnFKb2xacjB0VUVHTTVLeFNEeWZ4dTBk?=
 =?utf-8?B?VmFwTkZrN3N0Wk9rS2J4elBvQzB2SWRLbS81Vk8rbHh1SDljWDhLUG1ielF5?=
 =?utf-8?B?TkFvV0EveHVsby8wNUVsM080QmxXTmJ3ZGIvNThWT09jTlltTEVJZlpVUUQ0?=
 =?utf-8?B?NUt6cmIyc3l6RVRvb2duRVFWUXo5N3NubFE2bkZzVEdaenRIdkU0V2piMVIz?=
 =?utf-8?B?L2lJWm5TREYrN0k0aHRMcG1EQjBBd3NBOHBFOFE2MFdMS25pVGlQM2phRDlV?=
 =?utf-8?B?OXg3blFlSkZKdkFzdUd3NnRpV1UrZTBYRXJhNE1wRmRKeUFVb2VFUS9oTHVQ?=
 =?utf-8?B?cFRjejZvRWx5WC9mR0R3MncrMFBnRnU3VHRoMDVTNGl3cC91blh3aHk0TUhj?=
 =?utf-8?B?cWVzS0VvSm9kaXFzUDM5aU1rL2NybTJKVlpMNFVBRTFpZFZGMmlyWFRIYTlU?=
 =?utf-8?B?ejF4R3YzMGtvVVJVOEVLbGhCb3BKMWdueEx0d2RGMHd5bU5OU3pJMVRBRXlD?=
 =?utf-8?B?Z2cxVmQ0MXhKbE1nZUVUL2czdXBUbTg2Kzk5N29KSHBabU56eG5TTUJBUlNl?=
 =?utf-8?B?aTZEclJYSzJzM3JTcWVYQkt6aGxOYTIySUZrSHBqWFdJcGV3S2pXaEhTVzlU?=
 =?utf-8?B?SlhyUWxQNEk3emhYcllMQWZNS2pCTWQyWi91RmdnVFc5ZG9FWTFTNmY3L0tT?=
 =?utf-8?B?a3ppN1gyU01KVDRzaVA4Qm05bTdQRzNOQWJsaVpibEpSQWJYVWQwVkY5NjJi?=
 =?utf-8?B?aDVQWDEvbGpRT3lmb1o0YlpPRlE3UG4yb2N0Znk4cWxMVEJORmhnWDYwNjlN?=
 =?utf-8?B?UkFPUzZRWWNuUlBydGFkMzRLZnJQQWkySGJKdGNIc3dPMjNvVDJJTHZ5YVBz?=
 =?utf-8?B?eS8rWmtwSVVnbEJ4UjFoQ1RZUHRGbUpiT2NYNVNvOFB6N2ZWeWw4V2VTNzdx?=
 =?utf-8?B?VnlQNlBPSCtkZTlkY2FXU3QrUWNQbGR2VnRiMFFRbE44Q2NZQXVJQkc5amp0?=
 =?utf-8?B?U3BOOVJ0T1pQSTFQK3dUQndJTG0rOWRMelJOSkpPRjhSS1hRUStpRFlheG42?=
 =?utf-8?B?SGo2aDgrT0N3WDRpYWZkWm5KdzRwVUdyM2pPeTZQdHl2R3o1cGNVbTFwQm9F?=
 =?utf-8?B?elVhd241bVpoV2lLUmJQcER3a0hIMy9xd2hoLzlTcDJqdkQwZEdJNHMxWUVC?=
 =?utf-8?B?L0Z5MFFnSmZRaVJmUUhLdEEzUFB3N2NSMEFvTVZxaGZJdk1JN0xJNDU4YTlW?=
 =?utf-8?B?dncvNHRsRlBmSTJ2TTBxWWxTTUU3KzI1ZGpabUlFTmFOdk1kOHBJNlNNY3Vh?=
 =?utf-8?B?UDIzZ0gzWDVXRXZ0ZUtyWTNicTlIMXNiQ3RqQmQ3ZTRKbDhneWR1Q0FLVlcv?=
 =?utf-8?B?ZmNuazl2ZXNKVnVzc0liOVA1TTRWYkxOcVhhUGE3bXgzaUhWTEFlakR6dVZ0?=
 =?utf-8?B?ZHJIcnovSHpKZGFST2tMTlJSMElUSDNNblhJczNjbnE4QlpGdm5GRk1DbzBR?=
 =?utf-8?Q?lIMmmuzfC5A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0xpWXJVLzdlOXBaS1JBMStraHZxNzcrUytKUFR0SDM4MDU2eWZlRFZOczIv?=
 =?utf-8?B?ZHhRMnc1WW0vdWQyc2VnaTdmcFlPclRZb2IxWFBZM29xdUxRVnMrWnk3Zk9y?=
 =?utf-8?B?Q0d0MkxRRmRUaTN6dFM2RloyNm9pdGVkOXp0c3M1WFVuVG9VM092OEhSUUJV?=
 =?utf-8?B?cFY2anBLZHA5OXVhUVp4bVQ2VTN0ekZXWk5Jb1REZHl6NURuYzBOcVdNaEVa?=
 =?utf-8?B?R1A3ZVNodWlxUWtIVVRSYlRmcjVPY1FDSWdJRTB0Lzk1WDNBT0JUMUQ4YWpU?=
 =?utf-8?B?Uit2YVAxTUtOYlc2ZlNrRzlMUW1IaDVCUzUra3BKekpYeld0aE5EWE50THha?=
 =?utf-8?B?dmpsd1REazlUcVc0WktQZ3R3Qzg3VGVUM01OMDE5Z0hrTzhTS1FVSUJTZkIy?=
 =?utf-8?B?bi9ZVWRtWXlraXVBVE5JTThaQ3lvcXVDMjQyWkFxTk5oYmRJVDdkZ3pIOWZP?=
 =?utf-8?B?cjJ1ZXFjYXJmM3I2UWZuOW9QcUNtSFdOUU8xVFdPMjh4UlBQS0xNSHBjaE1N?=
 =?utf-8?B?UzBvUnhieHhjT29KcVBKYnBRMmRkdzdQWFVVWDNqaHc5S0J1N0dTaSt3aVdS?=
 =?utf-8?B?L3JJTEdaNWVCZS9udC8xM2ZWTzEzVjVQRWc5Rkh0aUVrZ3FlYmRsTHdVQXJB?=
 =?utf-8?B?OC9mSk9QWFlGemk1ZUtBdjBVVndmRG1BclgrczNrYSszSUtWcGhTaFNNbUVU?=
 =?utf-8?B?V3JzTmN3VmV2UVUyeHdFWFVyTHliMDNub1NiZE84aGl2NlRqSHcrRk1rVlcv?=
 =?utf-8?B?dHZkcE9sZXV0WUFKZWJYRW1KdEw3ZTdab0ltVzcvakdFd25nY0JMbERhZHFh?=
 =?utf-8?B?c1ZtL3FlcUtWUlpYOUJ5enN2czU2aXdTRU9VRHBGS004a3NKb1ZGMjdseHMx?=
 =?utf-8?B?WC9mUVdmWXUyWkR6S2tIVk1TUTNqeWlzOEhRTHF4LzhXVDFRai9JTFliZjVH?=
 =?utf-8?B?Ym8xYjIwejIxWE01VEM4M1B4MU03RloydWJuMXhLNDdHZVZmbTBnRG9rWk8r?=
 =?utf-8?B?cDd1Ym1vQ1hWRnFkMk02RnZtVEVlK1hxNUFhRVV0K3hGNG1TUUE5amJFUUgr?=
 =?utf-8?B?ZW1FbEN4eWxlRjNXeS9DZFpxcFMyRDlEZ1NjV0pBV2gwbWw3cmoyVXNtUFdx?=
 =?utf-8?B?UVQwemNEMFhPaUY4RmFxT01kV2d2Rjh2VUdtVElYdVN6bWpnbGRDM0Z1SzI4?=
 =?utf-8?B?MU9UUFl5SUh3c1liWUhzdmFQTXRCMDhuNWZBRlJOQkVyRU5sZlhqaEJuYnMz?=
 =?utf-8?B?emhXRHpiTVc5ZkhPc3ZWOStRVzNRdUtNaW5yMkxuYmN2eGpkanloRU1vU0Vl?=
 =?utf-8?B?UDdJbnZ5d0EydzdDK2ovRk4yMGRSa1hSeUJJSVhmYVB4cXl4aU93eGtiODhh?=
 =?utf-8?B?eFczNkNsRjFNMk1Wbll4WW1Feld2RGhDNUZ5OEFoUjFHZDJXTUluRWtuM0dm?=
 =?utf-8?B?NTlyUTZ2aENraVJkNTJLLzRwU1h5b2tMYVhnK0U4UDYvSmVXdXhDSXZtSFBs?=
 =?utf-8?B?bDZnWnpSQ0dWL0p2SU9UYzFwSzI1ZUthbzkzK0pGNzhHaWYrcnNjbXVYc3JC?=
 =?utf-8?B?bzIvNlRQWVUwTVZtWTl1OTNWdWZsTllBTnpPOERaNUc5YnBaTGovN3FTbXZl?=
 =?utf-8?B?WnpqejFoNHBIa3JLbFhYSzN5T213ZU00NHZqSTk0RkJPaDJRKzVNSlU5R1Bx?=
 =?utf-8?B?aStWWG5OaGxYbVEyYlBrR1ZWYlo3MUt5OEZMOEJJOGQ1bTZHRmFNR1dGVUpO?=
 =?utf-8?B?RzFSR0hpSDdVY0djQ01LcE1USlBZc1ZxNGMvNzJkeWlFUEt6M2Q0a1ZLOE5L?=
 =?utf-8?B?ZS9HcHYrLzYyQXdDWUZRWWlNZmhrUXB5Y3pwc3pPeDdJOU5JcFVzNWVhWXF0?=
 =?utf-8?B?Tm1lOUhnR0lQR3NTeTBDRnZQNW9YYVFibFFlNGZCc1RCMEI0VlhxRFZ6cXdY?=
 =?utf-8?B?R3BGZVhOU2hpQWREdTF6aXFYaGJVYzBkKzE4WllnMkwzOXNQQVFyN0hKZG5h?=
 =?utf-8?B?S2VmTXlVVDFGME9XaVhxeDJvYlVrK2FBeFhQaEhDN01oRExwM2g1c3oxU1ls?=
 =?utf-8?B?TlhlUmEwcjUwT0NsaXVCd0lmdVg3K1pyS1ZYM2FNcjBQc2tnOVh5MGQ0S09F?=
 =?utf-8?B?M0ZEd2gwN09RMDdwWC91cVhkYUoyTy9BVjh2dzZOTjhYMFVBcnh0ZnRXNHB3?=
 =?utf-8?B?eGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CmXFOKW8AqUeqIMaZYGY68y9DckaHItU41leuCeHOtHqVx/dGd3qq6gal6MFBpJFYeSf1gLCsOLOieJ5IZXuCBc1hY9Ox+APImXIvzYFD4L3XntG5nC5D1qI7SzmJAlpQg8RJja0bWKXscn3tObuTtmV/oP5779TZmB3vmRWM19uIA/g/iMVgraNeOmhVEtn6XsFoVYpMHIyhcSizkPPi0Jenlk/+JPn++ZpIQ9M8foD2+1M9sqV49InadZ+6Rlsc4s5XGkTZ/o8mJzd82QtkZkaPQSQJVU+qR2GKrU6zCp56iGgjtclNAeWIAXo3+q1yeJ7fb38RIsFXE26R+lW+fyjnEWrU40QkuqPhW8291XdS98ZP5xFdOjVXPLGkwyTY7HFjLWujK8wo87eMaOgc9qZ3J7wGJ+RgkcQTKKzEsqieEHDpeO7ZwIJE8vJq0gVkdSAqKOjsX06mj30RUj7Ti3/cfXsfMCqKqs9nILi6/5uqIV73qPp86+uue57iu9u1NNOqy/nTJvDzCtKVgYkcbFdHI7NB7MpsyVd+ZxtCW7KPBNiN/yvAYDrk9xKn2+vKY9UoQ1i0IkM2wqi1ef5gBact9XsMPni70QzT9xOwOQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5e97733-c841-479c-4ac8-08ddec02748e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 22:29:05.3457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TXdtJVHoPHd06Ig9nGzYkmj3aY7yaR4TmNYET54VoVUMAruODwARDflL8TSVVTDwT0fx5i692Qg4s5iDPcSXn0LgJSnxFeY/fAd/z3AUwiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4517
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_07,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040222
X-Proofpoint-GUID: jfz-IFhHyTcUFq1A_yT_kRxkzNibNUpt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDIxOCBTYWx0ZWRfX0x0GeWmO2uBy
 bjIdMbtxTAyRivo87u5vFjDLdUerPUOaFt6u0dvaCH8T9GsgvXah/EBZdFs1fo+5hEdg/Iy2CB/
 5++YtN+bwBCjjJ++xULJvcMhmVRSIf2F1TEbQU/XsQ4/9j7Ubohf4+voP7wuJougyPm2CUYpKLI
 wYzX5aksuutC8bD/dwOPAtg40eRCG/IV7h8+ZS8DcgC15+67ADvR7G7mZZzvMxXLukHrTlrf77/
 wJ7VXU/8gp+Em+U5xEkmSyDNnog9iqU2oZgsV06ulpRJclvD6SP+DFZ+/wpbFgUNEAD85f056mV
 vofz0L86qTlX1x3XJBfw/HPPMc5wPKm4W9bVX2m0FPoB3+gpeWS5nu+44m3Hg6XWcfmT51EDPxY
 NQ++8pAF
X-Authority-Analysis: v=2.4 cv=ds7bC0g4 c=1 sm=1 tr=0 ts=68ba12b4 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=PYnjg3YJAAAA:8 a=07d9gI8wAAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=xd1Fjx2OK_jiiDW1tk4A:9 a=QEXdDO2ut3YA:10
 a=e2CUPOnPG4QKp8I52DXD:22
X-Proofpoint-ORIG-GUID: jfz-IFhHyTcUFq1A_yT_kRxkzNibNUpt


On 05/09/2025 00:14, Randy Dunlap wrote:
> On 9/4/25 8:52 AM, Vegard Nossum wrote:
>> +``fips140.ko`` is not really an ordinary kernel module -- it is not
>> +meant to be loaded with ``modprobe`` or ``insmod``; instead, it is
>> +embedded into the ``vmlinux`` image at build time. This avoid any
>> +chicken-and-egg issues around how to verify cryptographic signatures
>> +without using unverified crypto code. ``fips140.ko`` is loaded during
>> +early boot -- before any crypto code is used by the kernel.
> 
> Hm, I was going to look at how that is done, but I cannot find any
> downloadable fips140 source code. Is it available for free download
> somewhere?
> 
> Is it GPL-v2 licensed?

Yes, it's the existing kernel crypto code but built as an external/out-
of-tree module.

>> +References
>> +==========
>> +
>> +.. [#fips140] <https://csrc.nist.gov/pubs/fips/140-3/final>
>> +.. [#static_call] <https://lwn.net/Articles/815908/>
> 
> Where are the other 103 patches?

Sorry, I guess git-send-email doesn't add everybody from individual
patches to the entire series. Here's the top of the thread with more of
an intro:

https://lore.kernel.org/all/20250904155216.460962-1-vegard.nossum@oracle.com/


Vegard
