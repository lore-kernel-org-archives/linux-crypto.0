Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F2EEEA5;
	Mon, 19 Aug 2024 22:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724106610; cv=fail; b=SmSou7E4pD1saSAZpp962PtqOKkO0KSVXHUcLvC3epA36WvQOam7bIs7z5GARp82J4M666LeCJ/eQjKzXxe7bHxWmb20ih5zIC1M5DgsdsnARCTO8LQzsRhW4ZC023PdaTUm51PCNkF8WujXMXjJ5zFknJZYCJ0XrRa0hjcxgYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724106610; c=relaxed/simple;
	bh=cz4JYPLnrsnA0GiSi1hEgZKv7UbtMWBWNUxz05tzt80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=S8YYM3+JoABU/hQs/9/fcB5nAmAiO/DBudbAHAebKQEUdKpSRSAGpldl5whhk17bXGRTOxpgQ5roT3AiyRsGCTwSdVhBGNlXJWav5RfGmbUVJZqs8tukjCBY/D3J0M+Jmj++kn9tCGA1gKdcXd9EkI7vWxSXvAhkNz0HYVIxMuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MKxm1d0Y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tMKAsIX7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MKxm1d0Y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tMKAsIX7"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47JLKHea022312;
	Mon, 19 Aug 2024 22:30:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=0OcSgxgIAtJNVlg
	IVEFrnKsvZdg5ztq03dsYI47C1MQ=; b=MKxm1d0Y51+XSNwMpB1ir565iwkp+ez
	7t/J5ADke4k7/GBPv5R7NDC6OUntcClaPqZi6HL/a5R5pU6FO4mbWF6ZsYpyp+mX
	J02ScRHdcm9gzRbbUQKDd6Df5vjDSlO4nY9xMh2MCWWmyiRUUVH8+1odgGOhTiIo
	QZ3cSf1HF4azkbsN3x81K1SME0+UgSydd408d14UtaNpRm+nLM8/s1SgPQjN1Flj
	8sQr3dBceEKS3ChrKEyvRS0gH06bcCAMgaDHZHutLEX1Mg1Umir5+EQ9L33dkcTs
	qbkIbTB7D15d5E3696l4jj9vmqIlNrXuh/n19oriYX9KO4KF+iyqSxQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412m3dkt3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Aug 2024 22:30:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47JKp595009674;
	Mon, 19 Aug 2024 22:29:59 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2048.outbound.protection.outlook.com [104.47.70.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 414deujuhs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Aug 2024 22:29:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nQRNfPfLsxf+U7sJVRCEi/cMTJep3H/mfW14gftyDb/TbmIoTOCakDb7Yc4b00KdXXHT071xe96aIBXGytDpQeMiNElkk7CpYpEFdtb0HsUwbQLDR9R9iPZ8k2sE4Z+esbYwuKiGT+485aRwLjZxHN5Y/Mpv4l/7IjUlJDadc+SMipQdnuN243VPrQDD94VFj6NiGxd5dHizin5Y60YSWeYv2yRds86YDNRNCBK2rhxkGkZrW2l/MUdWNyQXeJIhADGHG6J5a+CasRLik5BV5aEcikzyzQgIOVDFLOwRzROVHk7hwYALhw8znnvRr/xWUs9L7Li2q7u8XJaiUKwnYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0OcSgxgIAtJNVlgIVEFrnKsvZdg5ztq03dsYI47C1MQ=;
 b=H8GwnHpmwczqDR9TfWVcCVUms0BwdGOE3gdlFpikoglCJ2IAl65wlqje3S5Vtkl+0jAPp403kej4Fhh2wkXDA54T+AaRNgbVhDUmskT1g18fLIOjzy03leRzBz5Ms6T2G+XoQ8OgphgD0ydFWqymWhvEE0ZKOfQFFETXaIGlFxbpt+0QpGWEwLtXj0ohVMbbDeYkkO6z5IXenbwVlydFpvzdVCV02ScSU4w7ld3wX+mPPRxmb1Xftmr/cP3yLyTmZwHeeSjRBORv8extW6ixJ4Ct3Yyx34AH17x67MrnEKZvTp8NvMnOmCc/FzwoeIAORS1O7oldaH23KhBSTnlwGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0OcSgxgIAtJNVlgIVEFrnKsvZdg5ztq03dsYI47C1MQ=;
 b=tMKAsIX7B86AGKHHrQ0OIurIQeIA6e/GuQISHPLbw0I6VdeNtgWLLCYZkiq9ZzrDOJESPahPftQD4Q+dTWxM186lI9MW4wNGGHcJf8VJrPg1vX1/tvz6QlG0ojkKJukyWH9j5MmQWVgA0l3rUor5LVBhFBEL/VXzOqKhm1suAj4=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by SJ0PR10MB4574.namprd10.prod.outlook.com (2603:10b6:a03:2dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.13; Mon, 19 Aug
 2024 22:29:57 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc%4]) with mapi id 15.20.7897.010; Mon, 19 Aug 2024
 22:29:57 +0000
Date: Mon, 19 Aug 2024 18:29:52 -0400
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Waiman Long <longman@redhat.com>, steffen.klassert@secunet.com,
        akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Fix possible divide-by-0 panic in
 padata_mt_helper()
Message-ID: <dgtppozpgkm2gtv7nnvranbkjudr7bwuvfe7hjbznipozcxyzd@3qcag7izn4fj>
References: <Zrbm--AxRXgfHUek@gondor.apana.org.au>
 <e752f094-adb4-4448-8bc8-e2460330eaec@redhat.com>
 <ZrgXtLI1R5zJ9GFG@gondor.apana.org.au>
 <91d29649-ca88-4f6c-bf1d-19e49c9555df@redhat.com>
 <ZrgsU-1PdxvUVMOW@gondor.apana.org.au>
 <88c188dc-3664-45db-b54a-11feca59d7d2@redhat.com>
 <Zrgy1TDikPSkzaYP@gondor.apana.org.au>
 <c5cc5ea9-1135-4ac6-a38f-652ed07dae17@redhat.com>
 <ZsBNZXfVZbtZnb2Y@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsBNZXfVZbtZnb2Y@gondor.apana.org.au>
X-ClientProxiedBy: MN0PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:208:52d::6) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|SJ0PR10MB4574:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ee38e2f-3836-4387-d589-08dcc09e7461
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CIELGKFKfkdw7nZ7FaFp6BaVtbUx6zgiNEgmPquXcX1aEy7xJnYUr9+VFeya?=
 =?us-ascii?Q?jAnGKrwP+wQBeZCww4lWgr5hr1kJ73wDW3KLFpbxyql8EJaflslXavEanAJ0?=
 =?us-ascii?Q?gxkjkYA/lZK+zUnIAfNnU/XswaAbkhEQPo+7x+NdZafC0o4N2JAWb8uA9j9i?=
 =?us-ascii?Q?u0/e6vCM85OpEQrF729VmWFN1Z+wUCEv75PmaccEzqq9NA+1be4/K3Hcp3nY?=
 =?us-ascii?Q?ZpGp50YmDQMSH+ItNUz8/mXzqf/Xw1Gq5LtROS/uAIqvB8tTMPSbqLhuDITw?=
 =?us-ascii?Q?+fREt7+79f+61XnuuOBwYouz860NRtQ/TpDDIwvoS8QXa6Kx4Y6jUTbfnixf?=
 =?us-ascii?Q?Q4sxgnetbe3NHfco4SVQimHr+zP+bRuTYRRkOoJ7q/10hGW66pDKmPrc9SW1?=
 =?us-ascii?Q?APFM9qMVF36Ts14kAOl5Kgmhr0zh5FeTX37/643gvC3Bs/bVySAQHeq2bg5m?=
 =?us-ascii?Q?Ku+7rOwZDuRuF62N9IbXMh2xtuqbQi3vnj0xnuqp9lo3NNlyoNVm3ZPkDN/O?=
 =?us-ascii?Q?fEXEduSs0HT0NEHbt12HCzSUN0/d5DS5aoj/r49OrxdMv6UyGxKCwwcX7E/z?=
 =?us-ascii?Q?/hgsOSWbY0qbGZfTOh2UBEL7EicUVlD1/Ss7rmre0rQmemU/HRI3S1Gh7q2I?=
 =?us-ascii?Q?C04l1hGwk8BLXQFKb4UWhHLfDh4l1yFFHgUOn7gpVUOpIlzKJjnXknZlTe5m?=
 =?us-ascii?Q?2lsU+zbjXelDySpP7wEErz9YvhCykEZVmFIWdYomwCuhdFBPYD/io5Vx4AcX?=
 =?us-ascii?Q?Wb/QH5AOa8zoBxwVXVRiTYyj+ww2JKCTKefxmK4wEsoLrFr8oB091HaA/2vZ?=
 =?us-ascii?Q?LAVsoIDBYDiQykHLeNpb2kzSyUxjDpqoxoczzgkrW+2dWYGGY+NtVQmwp8Od?=
 =?us-ascii?Q?wanS9V0EDpM+Pw+M83SZbCU5s390fE0BFyvqGV9uWEI4ctnJoBclxRF3CEfm?=
 =?us-ascii?Q?1CDaqPsx3TSsimKYsDht3SW2p0+7sxD8weLzMQMIxyXY9REF7ULVvTiA8pVj?=
 =?us-ascii?Q?QTrwUD6g5U7sZN9yubZsYU7yDSl/2MqZko3xmfYdjGrcr9oOo6VEXWE/YvRS?=
 =?us-ascii?Q?Eg6r2R4OXs4PjUhnHVLt1XIfg7EHbSzD9zvUeRgWlpJEVPJ5Z+6kI/LzTihE?=
 =?us-ascii?Q?3cT/BgUEDR8N94U/OJ4C1Qm9JIeBP9KznBB/XtB2w6XvEsftMCw+Mu1EQrEL?=
 =?us-ascii?Q?Nxpt4Y3s0PTzMr9w8vBT427yXtsaKiN/9+Z8jKswjs4bpTKjwSugQspZyZ5w?=
 =?us-ascii?Q?jHNzYey9+HxyZSzMUiL1gTsuGC8XBCVjm01V54Nl2hMS5Q5q7Vu3wnJUow7+?=
 =?us-ascii?Q?OtE3JwJApqY2JKPB4zybTNqmX46iuvy8fgibEbQR9gmuaA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EIOYKVx7trotKthYXj02OL+61UC8qbLVxUgIkkNaqi8karkNgXZR4zZegkrz?=
 =?us-ascii?Q?w/YsgBVxfpWIp7qIR4ta4ya2b8aW7m0BsgPb+HO9OgYlWAO+f+puX+N+UYoT?=
 =?us-ascii?Q?y7Ytbbb/Mp2bGM1TxYmeezer+sUKqd6tyjfTiokbRG0ub8tzyKnkzgQYcCph?=
 =?us-ascii?Q?0qNg6zNqPEnY0NvVCGJ+jmHO/raT2g7VwZmnp6w7i/YkzkRE7aeFaVhNHFw9?=
 =?us-ascii?Q?9qUvGZ4DqviKfCOdZJL03edj04eeOAEGsnPm3suLTRaliQC7x7S/Cw8GXJhy?=
 =?us-ascii?Q?Z4QTlxffuolJeoABoIkaiQy89OuGbfNdsl+Hu/MK9acDQft0AbC5U1oH96aN?=
 =?us-ascii?Q?XD2BYB0eOCRqA06Gh+2a9vhxJZER3PfwCVAcBOrpWc9nX86MgPkiH000mdVM?=
 =?us-ascii?Q?+o9+GqJ53VFR5wg6dS/R4I5lTJWx60+fJO/LNSEdcerskwHHeHBjDBER5wt3?=
 =?us-ascii?Q?8sP/asb4TAy3b8LvkPZ0wOXk915RpApVgJcehE5O8gDwdWUDOOVEACM3Sjqe?=
 =?us-ascii?Q?b8cMH2Wm9Nyau3PZa5VzSGDepmZO7eWPML30Db49emyD0KGRIhTdtBDys0Dp?=
 =?us-ascii?Q?0V399rXOV0Jht8xRuTb6zCBEOoHOTzCH8ViaRXiXBQFZMEy0Sh/E4jgycROD?=
 =?us-ascii?Q?kR13KxRue6I4qCq0pCEZ7Hf5jLVweSkYyC60l5bcZhWUzzRCHBl9yK5LSf0C?=
 =?us-ascii?Q?u+Ghy/ZU1E0J8W5uh4wYH5jXpCb1p7W6Mj/IaYJ9MOdbVpjCW7r02CtauJSD?=
 =?us-ascii?Q?7zDZuiZNNIbQJojNs5b7TwDkWfwhiL2i3Tb44jtJRmH7tk4Kds0W+JJ6Po7s?=
 =?us-ascii?Q?I0AzSAvZRUU61CTWOFQbTyEsgoz+Iucy1pj7mUp2eHHfFCMyohXqFEEQN2PQ?=
 =?us-ascii?Q?aBQa9NgnaJ8Ag4kmSn4OkJ6i0oj+aj+bWkJn4fw3IlRh8B5UFVYtB44pJdYg?=
 =?us-ascii?Q?vp87/2oMfMGbXg35U5KG9WCUq4BCkAQNoazyF6JMFhtZuEvB0ImLMt2QfX1H?=
 =?us-ascii?Q?9x+YDoEfXb5i2V7p9K5XGVU5IuQ0rfgjXgwBmSJJh4Z+Xf4rRNgfJOI0DaQZ?=
 =?us-ascii?Q?iFxi6ang0t2KI0+HZJriRj0aJG8SoUWO0IHa4xjukiQm8jc+RBQqK7QvMdVJ?=
 =?us-ascii?Q?pSETVvsAOPq8AyTuvviKGmTrVEWkgxUoJubWL8rY/am/OWvX3Qm5LZqq65XN?=
 =?us-ascii?Q?UZaMxG55BrxvuAAmJ2zr8/dgFb5i7eKIUOUNdEAk7z9KYj3fJACDIU5qqSFT?=
 =?us-ascii?Q?jGmUdXJMsfqP0/eTrYFf6vrthVppnxVGmOtgTDbgHEgN04Y4xggfEQrSyOHB?=
 =?us-ascii?Q?YV04u81s5NeypmjSkMf4s/G4oUGZCOH+Bfc5463wnkBTYyOOR/6lm6IOtBok?=
 =?us-ascii?Q?IoTX2JvMvSOHtq29G/3bFiR3u+ea3xAdwqLlpi4TmGTlRFZp1f05b6fONlMF?=
 =?us-ascii?Q?/3ji10gGozCIEvvJ3Gxts+Vl20XXkaMa7PP3N/Q2S+0rL8PL5eVbiT8DcofJ?=
 =?us-ascii?Q?tEO2JzMBCkpO2eZdJj2PEhAk5KGoL2p1wgUz7ZqbMWeVJkkj59lTJHyrozBl?=
 =?us-ascii?Q?m0w/U1KTn88ygwrkN2A6fgrC5QC+JqcIbZiMYTWSjMVhlRfuHn73lsPZsA9R?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ct4GjE9SoD2V8cpaOWCvV5XzQRDdm0wICBc2RfMbjUj5R6sW5tC3F9/A76OAEltBPDnq3I7WsXg8DSbjSYoZQ3wunjIYkmZcQQPFvFtMzSBgwYJHk9n5bUon2vZ+l8+2AR6TIlGM457TdqMbBfDb/84n9SF6vG/7GbpGnyznym6SQE89aPVdhXX7cs8DFVaaHkhllaURbZ1iLwc/whFURXfwoES5YfTjzEMrPUHgIfvftyD5ghDyyUbLImc2E8mAwd1avBl7849n/20uB7aC9K3C/7U+JEtQNIyK/9A8qT1Bkas0EFqGrXcX0c8bss9Fj69915Xfx5ytyGz2eA2dL0gomM9F8o/4qMguA0Nnpox8c9mYoZUoNlte10WDLCmQ0j8W1Y3kZHe12zB+YC5pzC8/gmDIxhOvXGBa+uPA/8+D3Y6h51hK0VIlI46Btt4kxHQcIfK0GkncHK5wtuuGEYQLB1rh4WYVLGL5VoxqfhXQGe3bOUNtYBW2GUvnx5yLJcCVHQLOxQG5CYo0Iq5Q/760BpgAlAymkFjJVI7G6EoDThU1wsfICQLnE068ulKDmOBp4JrfZcx+letWcaXN1lb+HmjaMgNp87l4NFqKk8c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ee38e2f-3836-4387-d589-08dcc09e7461
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2024 22:29:57.2853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JnaSnsY3e6CuZru0J45Ocka5eY+yAFyZRM9C9fbUyNSycgSsqk+oD/nrbfmlavfwR+Aq2KvwiaB6+rUkvZTtr1y2O3Sl7Dz1YRI/SaDHZk4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4574
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-19_16,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=752 suspectscore=0
 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408190149
X-Proofpoint-ORIG-GUID: 1hflN1r_03lrAoloca1JUEFYchUg0rg5
X-Proofpoint-GUID: 1hflN1r_03lrAoloca1JUEFYchUg0rg5

On Sat, Aug 17, 2024 at 03:12:37PM GMT, Herbert Xu wrote:
> On Mon, Aug 12, 2024 at 10:04:07AM -0400, Waiman Long wrote:
> >
> > Anyway, using DIV_ROUND_UP() is a slight change in behavior as chunk_size
> > will be increased by 1 in most cases. I am a bit hesitant to make this
> > change without looking into more detail about the rationale behind the
> > current code.
> 
> I don't think it matters much.  Just look at the two lines after
> the division, they're both rounding the value up.  So clearly this
> is expected to handle the case where work gets bunched up into the
> first N CPUs, potentially leaving some CPUs unused.

Yeah, the caller is supposed to use min_chunk as a hint for what a
reasonable amount of work is per thread and so avoid wasteful amounts of
threads.

> But Daniel wrote the code so he can have the last say of whether
> we should round up after the division or after the other two ops.

I think either way works fine with the three existing users and how they
choose job->min_chunk and job->size.

The DIV_ROUND_UP approach reads a bit nicer to me, but I can imagine
oddball cases where rounding up is undesirable (say, near-zero values
for size, min_chunk, and align; padata_work_alloc_mt returns many fewer
works than requested; and a single unit of work is very expensive) so
that rounding up makes a bigger difference.  So, the way it now is seems
ok.


By the way, this bug must've happened coming from
hugetlb_pages_alloc_boot(), right, Waiman?  Because the other padata
users have hardcoded min_chunk.  I guess it was a case of

    h->max_huge_pages < num_node_state(N_MEMORY) * 2
