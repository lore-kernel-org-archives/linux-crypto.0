Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8D779D2;
	Fri, 23 Aug 2024 00:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724374242; cv=fail; b=sg+WZM5+XARavX+wZVvxJ70PDAyQ25Lx2NLKjE58RSZ8vIqXUUtO1Bizgws0un9jwJA7UKUaqGUX8n7C0WKHXJbo/f+bvU/+1LOtkd+UScU7m7rf6hXuCZdU/HXlmh8GI9+eAlYTUHqAW9nRdKkIgV0HpdeKYd5UfAbisoyOXds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724374242; c=relaxed/simple;
	bh=Stu+gWwJgUJRRkbhnxI/pJWr1NqpSXNHnIvrd8QjBg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bgac5Ev2BuVHagv0Pt/O933ASnaiGHufzMK/Sojibc8Cd966aVrOtmjlr4qMSXryif+9gxSIrwspegMlNjIg8KvLGUvo7qq62jYhIdfgIgoQc4qgR4xSBnS9ff9yWwSAmsxTMit5pCWiHiFc4ErGUsTNfgCbjg+8pcpAxQLCK+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D1TC3sRk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DjSn3IIa; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D1TC3sRk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DjSn3IIa"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47N0BV2a026912;
	Fri, 23 Aug 2024 00:50:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=DDT7jmBxeDDYTwB
	xGVNHTv/KNIgb9YVp34Q+aIlSdy0=; b=D1TC3sRkCi+5F8qVaLjNr2nKYE8Cijs
	V0feH6kTcSmuOr8mD2Y1sGETYIA36oVY2KgOegDdcAvgnlFWZLwqR+XhBS3kjMUo
	tK3cgqNxiTQ29KDuXjWoIVZp6mbS8xcHK4ttLwv7r+EHnvKsT66ge5oeAT1barvF
	0kPPlqrFAK/mCIXmiodDP/5tCtFVCH2BuM3K7KS2K/bfHfuufxZQVAYsXxWQAsgM
	WckYdbaWkNMTd1WJOyw3y6eSX+Jwr3EwZ0zQEz/B1XJ0gJnQqfZsP0RKuDX/v3Nk
	fl9fKhrXKToWJlM++4YNOlIvA1L3CbPadqHwVQJHGuSp0EZ4KBzA+HQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412m2dkcmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 00:50:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47MNdAGf027636;
	Fri, 23 Aug 2024 00:50:26 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2041.outbound.protection.outlook.com [104.47.55.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 416f6jhs5f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 00:50:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y39Ti83DFy03kRsTZMISzIDilS/01bo6u6xOxtLBGJsacVLUV+YEiYYBs0gDRQBz4msJLlBt87mWooVukkCYK/cOxagEYrYmjWArirSY8COHkPi2p9qDplOFNSg2QzJ1+qmhtJTbDxMVGo+EE87+HUiHO28ZOXW+1zYAVFoaY6J4H8HNsb8hSECiOaBc3I5Xj1Dx3mhfgFBjxJ64cAiAjO3InFEqEe7F9a1SfUy8TJDj2RX9aRQMADDsfq2lBlk7LhKTHk+BXO06BWsjq1PC6vpRYHRXi3UeT1k9Om8cjfv3ZNyb4rv8wEChcoQe0vo5vjFcn7BAFUCCMG3jyxKbQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DDT7jmBxeDDYTwBxGVNHTv/KNIgb9YVp34Q+aIlSdy0=;
 b=DsBHLkeoZvxLGDdckcCeceN5rMop3nH9D1eTb5zeH7lxXtFnEubO+Hc/5YF4B+hD8doGNm/R/7Kcsg1SXTHq9kbXuxDizqdSOEIq+nsQxnMGwGxMOOtgE1Ew2awkQRq3sqXKY+3llCbZln7rePj4KpwJQnJ+hXwbw4g+2lUE5urzxCqTYbG5ECiGV1+AT7aMZ+EGlxQEvKfbMPNVgLMC0c46njHlAJVERdknrFk4smhALbvjPK8RDESpEbd2WgOqSJWS0dIJsxYK4e4jgwFf1UFi9IkzzSJzRx3530QDC1jKVDLPjykEGST987E2/egz2X2u0qjmJi2xPZ9wqjUnMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDT7jmBxeDDYTwBxGVNHTv/KNIgb9YVp34Q+aIlSdy0=;
 b=DjSn3IIamAz3LS7PTzg8UnFdPhNs31yLJPCYwaBoR1EiLnDJgOPBqjqYxwp+lK+bYx30AJ2T0Wwd9ZGf6cR9oDVTGDt6ecpQlI5Hat/gcD+gJ8gbwjCVMNSmj4ZNf2Wfc2Tc2ToWD7fwP/iYkfKmuquqwa8bvKWx/SWzWQ33184=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by DS7PR10MB5949.namprd10.prod.outlook.com (2603:10b6:8:86::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.19; Fri, 23 Aug 2024 00:50:24 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc%4]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 00:50:24 +0000
Date: Thu, 22 Aug 2024 20:50:20 -0400
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Kamlesh Gurudasani <kamlesh@ti.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Waiman Long <longman@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Honor the caller's alignment in case of
 chunk_size 0
Message-ID: <iqhynhx6xx67b2jpjazmzufh63nh24uqsawn7thlvlo4ezb3pp@rtvz6u5cc4ug>
References: <20240822-max-v1-1-cb4bc5b1c101@ti.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822-max-v1-1-cb4bc5b1c101@ti.com>
X-ClientProxiedBy: BL1PR13CA0410.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::25) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|DS7PR10MB5949:EE_
X-MS-Office365-Filtering-Correlation-Id: 25404cbd-b433-4ed7-c929-08dcc30d9292
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YRHOQDm4CO9JOvqvziWXAGmdYvNS3mGLlM8v/jyeC+lrtEd5g6EcN4xCTBTD?=
 =?us-ascii?Q?8OHjzzO7Z0H9pzKzhauVw5Dckw5OQneiDx80f/o/T1IqEea08zdVPElVk3l0?=
 =?us-ascii?Q?cIbrHcQfj/3NqMnMGyCR5WGVsrjkz8/6yzRlHZhy9QXCTt8PvgDLJPrQ2ssi?=
 =?us-ascii?Q?0KTiVjNIl+p/NE8LFXTUAG5bbNccv/ZoRHs1Z5EvMq7oMcIUAPLxPKVFOXPX?=
 =?us-ascii?Q?ZwBWV1LvgL8F9JFxO4F/7wpUOldLxym69KSb3Lft6jxjDzmP/y22SMSIjkDX?=
 =?us-ascii?Q?wCBRTRcrtRaDM4u9iklFJqXXmLHNpxPNf5ylnr3KbC0wWWnVWiH+Vjy4SYy7?=
 =?us-ascii?Q?AxpOYf72WsUY0TR8gTOUeK6vuZkjca0iem1HICkdQr3YvJuP4AWeNcZRXFk9?=
 =?us-ascii?Q?Dx2L3FNk4OK0ktUs+cUAR4Nhe096AT8SOucOPlqgQSmiPlwAkAL/8CrZRYdw?=
 =?us-ascii?Q?ie50ZTMWu8WpYFow4ibDSvcYS3Z8QV/WFkTsrKrSXTIwEEaUZhLwrT6bPD+o?=
 =?us-ascii?Q?RexpFT2EOycUpmTerBwbBaJXVLqLhWK1KFX0rgwO92sLgItgpOjegIRAFO7D?=
 =?us-ascii?Q?Ymnwq4lpTtl8//8n3MysVEf6c2oFZDfhqh3D4i6U9o8LpuAuh1y3M4MBPtbJ?=
 =?us-ascii?Q?FTqMgY13Ofr6GipYXED9ZrKCJ1mD66mKu0F57TX1S9mUWFBIYgiDDCbha6Cx?=
 =?us-ascii?Q?B8qG6xNk0mrv+WVJxrS8t1+NQIY47Dtf9FX/6ljJMWF9+KfvIUXGdSKITJD5?=
 =?us-ascii?Q?2CzKIJysC972UHzVn/tEgKXa8e6OzqV/PQjPW8j+7BLDNmY/9wPUTPovkFm9?=
 =?us-ascii?Q?PE5YhGlHv4HJj/UOOw/3Xpy9Fk9JCfy5OJt8D2qoci0wQff8t2OuXNJYswFd?=
 =?us-ascii?Q?ThqoWoiekfBxo4VFnkss/GKX9Abey6c3g99C9QdcRliOlfCsnq0P9izWgei1?=
 =?us-ascii?Q?S3HjF4mTFwmizI8tSNsJ8aLD1ZzziKUcvrmK/nIElfs1yNF3NpBEpTAwYR8B?=
 =?us-ascii?Q?2XJAc7lqJfrsany2huKh54llVRdJ4qFJM8UZBAbVipXztm67ZmZ1ZEUHsDap?=
 =?us-ascii?Q?KlJMe8xVIV9kbScQFMymF90MwXEOObRR6AFr0xJFNUq0hUm7ot/XI/VC/6Zm?=
 =?us-ascii?Q?b0akCkQgyj/jOqVCNXvdtnSUe8L9JlEVT2LLsR3xJFHmFFVGz+6l8GoS9REg?=
 =?us-ascii?Q?NasIpqZHuPfo+MklVdIookLpUbsBA7BS5okBrV1YR8vK4/SkiPQ3+HZmL8Mi?=
 =?us-ascii?Q?PGhzlXU5qh9nXmJCThiBNQs6NCvMxRIQc+LvWSOy2/SEbbEtOyDawgHop/n4?=
 =?us-ascii?Q?RXGALZdSzw7MAbrwwfeciKsDMEMIDp9Y0b/gr2brqRdvuQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f9JVa+c9qAhDRJRHwYT7pENfGTTq0SxFSXv+Y05ik+uxoTBR60GmwReGAxef?=
 =?us-ascii?Q?ZOgbJUTbOtWvLdikUTKWO7FGZ1p98ybyfJcQo7mkBKfx0Dnij8sLlwPFRxsE?=
 =?us-ascii?Q?Nqs5dl59rBm3UBDSMYEOkcZ22LMr6E14ERkEURci9L22q8s4aLF4VkvnFzHm?=
 =?us-ascii?Q?D6eSD0dVxKYe9ErPVvRVPp8IYWIu5Xm/aHlY/6XC4sUGeQbdOwMPQ14b7YW2?=
 =?us-ascii?Q?t2Ke3TWJy+l0A2fV7gGPIHOM94nqGBcW3qjjFXFB6uaL6m7KNPFtYXAPTz7/?=
 =?us-ascii?Q?2Y90MtvgZyGuuNe1/n03NxyJjuNEahS1hiVMCTHnCUVEccoS3sOZ3tUTgWVx?=
 =?us-ascii?Q?+9/K8W8KpmCRNQV4LiJ7WyxWE9xukZDyqta6dzNbK8/ZN7+kDRPQMMmynKOo?=
 =?us-ascii?Q?5CU4gJolQNb6s9eDzBcKD4pVd7ACDOfX7X6gCd8l5bv3BroRlvUSzp0w5xn6?=
 =?us-ascii?Q?5TW3riUYwODGia9Qlx3/+/IXoPKQLgNJWfgBFWIe60YWs5JoAwoHt7SdREHF?=
 =?us-ascii?Q?Kon0PxGG2qeXCt0mqLEVrrpJtdNum4VS0OsB7tGhg+uEJx0xzgzw0SE/vrc7?=
 =?us-ascii?Q?8uBoEg9rG6OVPTppqafN7SF/0JpS4Oav6XcaiwHxa1LT0n0/u00Mb+DkN4Hz?=
 =?us-ascii?Q?b7xiSBqmy3bZmCZ8feynF2kBXKw/KDvQm3t9Yo8LX0h5awH163/3oaHxRKN6?=
 =?us-ascii?Q?h187FZF29Fb2/SgaftTmdUQT9cq9GbhHiS5Szb548wO5Pg6i0XMlbU9GtjTJ?=
 =?us-ascii?Q?2w/JlOHXnd1xhe5ZX6N3oInIYZ+ygE35EWiR7QNL83MM144eOdx4wg2ujtR1?=
 =?us-ascii?Q?O5X1zDxtqXx/CP/pFGOsCFyEyZy+TBsv7sON9Vd1BXqy/dzSu9WWe2YkyIq7?=
 =?us-ascii?Q?w/CWGqv001DSmzrzIX/0sHb4EU53i7QeKiK9r0pztxh765Mn3uozVGhexerF?=
 =?us-ascii?Q?NInNLFHllNr8L0P6CdTKKLwtMKvoABYeIdOZARKH4lMpxMpjoS2bDQFdo5xK?=
 =?us-ascii?Q?x36qxvV/DUZV7zjNTJcCONBRBYTQrorp4a1AWJTlcU9IpmFpePxueRwJqklt?=
 =?us-ascii?Q?7oV31LW8f+f4TRWudHHisOl/bNwA6b6/Z9clja5xGHaP25T6aTelx44q3gVS?=
 =?us-ascii?Q?hPL2gr3OA9Bd1fAUvUrG+yUmEHcAGstXYRkX+BOJkhhE51Px1jANIVVruzVD?=
 =?us-ascii?Q?+P8eSldxoS3VIaaKQfpWXcUNCg9FFs+10csbBeHI7aillcp0qKwHL55B8+RP?=
 =?us-ascii?Q?MYcRXTaI0y+XAt0X3zKJnqHga1KdDh28GmBAeRewvB1k+av3LlLChVyRm0jr?=
 =?us-ascii?Q?ufA8vtN6oXl1b9ZvcoK9meXcLmXXbksLqqoVt30Z7RPWSqP0Keu5QShuysZW?=
 =?us-ascii?Q?DUwr3sIwaCd2tShLUwtiFXkvbfRUESgaY+c4kAqYvBjspXN7SREPbceuFZx7?=
 =?us-ascii?Q?uZxw88+lfN6oRVwaVMizB5ILRr3JHu2PIn0swpBC7681xl5HtgvDvK68hRR1?=
 =?us-ascii?Q?19obD58TDEqY1GtqnEts24cWlC02v7/m1ahp2sdb1R4UVj9Ff95HkEf1QjS1?=
 =?us-ascii?Q?1lfeibMMrTZ312zhwIZhkfKm2+5OaXNdYW/uNsgxVETZg/Xej3SNGXoMu3Tn?=
 =?us-ascii?Q?8A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+zoGSlQMEaQdJm/OwmnH1tbgxOh62LoUq9ffkggzOIHJ+fas80F9HBfxjk5ydu+J7V3ziy7bH826nCJdXZ6HQ3F6vPIV2KDaoL+YzQg2HaaAbqMZXsv/HSU5W2FFhRa0YzcXHJXSNuwgE/4zu0erETM2vOHRazajZ4MeOVPqJqwEFunUhrM2cpuFzY9+SE4k8jf8hCrsLvjxDcVTlgZ/o6XrpHolvrZx4vjsCbKZ92R3qYMJt0OGp4/Sq94BU4+tQScg1nQclfsJ8dklgLfuTox0iXLqjAnn09Yhac+GcNWf4IVrA9K32G0FJTtxRdQHIUou16Wllp1eKLPj3CqDnvhy0c6RXRiehtsiPVYONvr6RYMrBNhD+IfyuhOhi+/Gsrk54jd6i54D6Ba7Hl7XMURb4nVjDn4WvXpuR5mqIGCLlq8rDNxbMTmq28WLAQrDoEXCQeO3yrnNfrkiiiF4bDa96Ws6025SnV+Xi9/oohyFFnPcj3PNCMSukfIwaOr0osWwbQRWv+sJmcpfJUREcbehDU9jSpC2/wWYysk7OrcImNuFn3g7H4l6FpUwCshU+I2frST9EAE1N8Ah3NB9eDHUrQZ/Ng+yFc37TY0OINc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25404cbd-b433-4ed7-c929-08dcc30d9292
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 00:50:24.3026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JT5xvvHKGHyEMXb5gGVkgNzGelxNm/sIB7C0EPWeu8hLh00rDSuO6cU/Y63nWVx7KP34TasS62fgKHX/71ruh+XfinHAu4Q3rUqtPb20gj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5949
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-22_17,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408230004
X-Proofpoint-GUID: NYjvHQW8KD3YdBd3c9n6pEWif-waIlNY
X-Proofpoint-ORIG-GUID: NYjvHQW8KD3YdBd3c9n6pEWif-waIlNY

On Thu, Aug 22, 2024 at 02:32:52AM GMT, Kamlesh Gurudasani wrote:
> In the case where we are forcing the ps.chunk_size to be at least 1,
> we are ignoring the caller's alignment.
> 
> Move the forcing of ps.chunk_size to be at least 1 before rounding it
> up to caller's alignment, so that caller's alignment is honored.
> 
> While at it, use max() to force the ps.chunk_size to be at least 1 to
> improve readability.
> 
> Fixes: 6d45e1c948a8 ("padata: Fix possible divide-by-0 panic in padata_mt_helper()")

Looks fine.

Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>

> Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
> ---
>  kernel/padata.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/padata.c b/kernel/padata.c
> index 0fa6c2895460..d8a51eff1581 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -509,21 +509,17 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
>  
>  	/*
>  	 * Chunk size is the amount of work a helper does per call to the
> -	 * thread function.  Load balance large jobs between threads by
> +	 * thread function. Load balance large jobs between threads by

Though whitespace changes like these just add noise...
