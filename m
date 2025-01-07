Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE181F2C38;
	Tue,  7 Jan 2025 18:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736275437; cv=fail; b=GIjo9lPiXjEzUb0QP4/Cgv+LoVm/wtAu2kSPV/TuYfhcGpaCxAQmF4sG1H9YMDZiHULKsRgC8bNCXhdmZEYB3hi8w469QNN/EnN8kdZ/S569ZpT+oC0GFL/Dsv1HZl9Gdiy4lGnyZltb7BRmfHQlSJr36E+O+wHuGOH5nrTFMp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736275437; c=relaxed/simple;
	bh=heajacrAlGaOpGxpASucEdWXQLoTlz7J4JiOFogx/Mk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GJTofKOoY9wGFCGJyiwWEi1HND/ZGooXS+kkj4rJoDaVK0ZnWzh81S2M4aiR5WhoRJqzhpa9EdOJEsja3MInNsLoLxo3DnXxs5w8Z4TnFwpxCOOYIxAaFfza33KOyFhdYlW6IIfE3jPP0OGZ5MxMJYG+VdayadPdMHjRGAvrmUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h5so5H1g; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b0AEn3Ar; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h5so5H1g";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b0AEn3Ar"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 507HN19s014306;
	Tue, 7 Jan 2025 18:43:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=rfbATAZZWO+98uPLgK
	YM4viX3mJgKqYEgAtaGVqAi6M=; b=h5so5H1go4C9nB+VHEsPnI6kBW2642HJ9Q
	JB32YsXWgiVnWAJ8shY/Z1O9A/wA+YRKkprphs2ijUHDEG8iKw0Rc7FaMfEtbiw5
	XvMXkitViMOCUN3xMwZ5p7fXNPxJzzlQDd36INA+OrIaEp6XH+yfbbc5kINmHRxZ
	vb53+DfGkwWma/oAjz3OHQq/Rz3yKCIot0fWLCyRPGEyVlY9Xm576jtHUMHyRc3O
	Z9SYZT9q1YtMTrzobwBwaLftSAqs+S92EG/7zJlIJO7TFuCNKp/zBjAxSHuX5diq
	HBtR5hCKvvFeKbbIJj6YGt8pW/fzDNZVAS2gMovwGkH9qmFRFGow==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xvksw4dr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jan 2025 18:43:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 507H4YuP022624;
	Tue, 7 Jan 2025 18:43:26 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xue8un89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jan 2025 18:43:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yolJgExyp0RJpse+wm4fQkfxIVLbIC8t5g53gL/hjY1E0BMrI/w34IiOtuIcBIU50THc4d8RZJJcTZ2aecZNSSTkZlXTF+jqgJ+OmfTjTLlPbFqxylGPgpJVUHKJtMmoDST3YX4dcfTTrT6qa5wv8YDei7twcopserSZk64U93DgdmUWYI0jocC5WLO7GXlbnN+EF7sPAorxtoGGmkvPDdrGcSxrDX6HqHmljXjT7IBxb9NegL2Sh7oxdDIkkoVea8aNTb+ocXTMhisv1GB3peLvNmImGkKYYCY9zLbHia6D4RJGq2wlPpEADJ5B2z4BIRiTNA7+HsRzPgsscI5jCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rfbATAZZWO+98uPLgKYM4viX3mJgKqYEgAtaGVqAi6M=;
 b=Ah/LOCN9br7+KTqqGR4K8ZZvmdUTApdLwLjA5lWUl03cZJlUrTxQetYjiLPV6S+O4qt6RRoJ+JEEAgGi9dDDK6OawE29c4b+jG5And4RMVd8QdPeqG8p6Wr2YLwgrM7u0b2AkSWTlcc8AO242HXH7ItH5b0rOFRfkOL+0VVhzy4wsEYbC2TlQV2CkYE3Fd1GLRvM8uPkKEkpX6gd1gcLKvposIPdoll/FLnbfhLV4r2jhUFZal6HQPo9zLClxcjjETxMtYz5gwuO+gcJ0bJkPeHpr+4cIgO4TshJH+vj9FHVBtk/rtJkfrWNOBSvplr3VO1OYaSAK2WvOOj3/WNFNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfbATAZZWO+98uPLgKYM4viX3mJgKqYEgAtaGVqAi6M=;
 b=b0AEn3ArkO52MUFjwot+/ybdwORzLcogXvIFx4OaX8VQmVWp6gn2Jl+cHMF/PaET0/Kfk8DMNVOvclcjIE/aA6eo/8Bp7BOMYTwdJ5HnorIP11de0YaGxRsvF0Py6wmv6GCQzp/xyG/WG+ecR19DjAllDeXv1AGVMkMOuDpI+9M=
Received: from DS0PR10MB7270.namprd10.prod.outlook.com (2603:10b6:8:f4::13) by
 SN4PR10MB5800.namprd10.prod.outlook.com (2603:10b6:806:20f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Tue, 7 Jan
 2025 18:43:19 +0000
Received: from DS0PR10MB7270.namprd10.prod.outlook.com
 ([fe80::1858:f1f7:dcfc:a96b]) by DS0PR10MB7270.namprd10.prod.outlook.com
 ([fe80::1858:f1f7:dcfc:a96b%3]) with mapi id 15.20.8335.010; Tue, 7 Jan 2025
 18:43:19 +0000
Date: Tue, 7 Jan 2025 13:43:15 -0500
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: chenridong <chenridong@huawei.com>, nstange@suse.de,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangweiyang2@huawei.com
Subject: Re: [PATCH 2/2] padata: fix UAF in padata_reorder
Message-ID: <jfjz5d7zwbytztackem7ibzalm5lnxldi2eofeiczqmqs2m7o6@fq426cwnjtkm>
References: <20241123080509.2573987-1-chenridong@huaweicloud.com>
 <20241123080509.2573987-3-chenridong@huaweicloud.com>
 <nihv732hsimy4lfnzspjur4ndal7n3nngrukvr5fx7emgp2jzl@mjz6q5zsswds>
 <2ba08cbe-ce27-4b83-acad-3845421c9bf6@huawei.com>
 <mffodsysfv4qakpyv6qbuqxzfpmt54q7cbpgne6paykzjx626y@f3ze6ti7cshp>
 <27690711-20f5-4e2c-8f43-17b7d3f10f86@huaweicloud.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27690711-20f5-4e2c-8f43-17b7d3f10f86@huaweicloud.com>
X-ClientProxiedBy: BL1PR13CA0301.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::6) To DS0PR10MB7270.namprd10.prod.outlook.com
 (2603:10b6:8:f4::13)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7270:EE_|SN4PR10MB5800:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f16a5e7-43fb-4a16-3d23-08dd2f4b27e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uUynP/FmjBnxslYhwE61OotiHZG7aHNU6U56Zh2CzGsZ2xxjrnp3PTzi1jHD?=
 =?us-ascii?Q?5h1awOYxbvAY6kraspvxbfhnIHHabg6i5hhv+wzBvS1Q57GYuZEBz27sIyFX?=
 =?us-ascii?Q?1NRf7HGje3QYtbr8gNUzt114oPxH1fyHkH81g4Oj5JNZLhhu2zAO0kgMTA2Q?=
 =?us-ascii?Q?txAzO6ac7xk+wpCZfOiKhlFK34RsT2ONqeC3Zzzy/EsGo5dIykikFeAhvyx2?=
 =?us-ascii?Q?GFBhSoJ6YHsR3wV53oOFwTwsfl1BV+1N/30We+gu+N5RSXLMukGlLKPekcwj?=
 =?us-ascii?Q?y3JGl1Zqv9HxLGJYoxZkX8WqRnliXA4bFbzvUo0k+XVtb0d5m665U0k2Xa7C?=
 =?us-ascii?Q?EOqGBBeTv9o5YteJvva01ePWjBzTXE4vsHyoNJ8D0UCvIPeuvqZCNkjC6dVb?=
 =?us-ascii?Q?7TAdiEBiu1dx3H02sE0hyNCxHFB3YApZtitJdOONjBhOHvi6R0XyTJ1ssqgY?=
 =?us-ascii?Q?hG6lUKWUKjnjl/Qtguk1+bIxr/tNB0wYELEiQbdslQ3mO8EIQY8uNg2Maf0B?=
 =?us-ascii?Q?az8i1DdxqkYCrHDg40Ss2wtheGSt3UeYCYMIdZEOQNUy4O93MWdlB9GasbxT?=
 =?us-ascii?Q?KvnjuvwWXo0qOkiKialtL88pYm6SUfnEWiyrU7BiOKlHt7AM4harkkSoppnt?=
 =?us-ascii?Q?SOeFKrXITgBXkkesfFJFHvHtLwI5+gCzcFVdHFpjgTrUMHLUT/EJDE19FzAk?=
 =?us-ascii?Q?z0fmUZEc83+m1hLrcQxVHiohZA2bpD+rRRsmMkfgWKeukFQnoBIrb+i5LD5Z?=
 =?us-ascii?Q?zaeDfkQTmNyO55K0P7SnEn0N0HCAzMlHwDo+yHJrCWEUdVa5g0uD+xbI1/d5?=
 =?us-ascii?Q?sWAE8XOVI7Q93xHFVG30C7kHmsTQUdRGIpM4zTMyRINoWXDjN5HdwPzTX9NQ?=
 =?us-ascii?Q?XRjiAy51gdzOnngRQ2GKTwf3H+UVYq3tSWPxiingBzDn1NyA/DAZEJcSRiRH?=
 =?us-ascii?Q?wcwbyR4RpphBjKxl/zeUGxFqcvxh+MOv9Q7C6T17tb9oLfZMDpeuWyqeVfj9?=
 =?us-ascii?Q?v21SxQER+7CI1S9Q5eV8MyEwO4T/hWz8RHkQ74ZNXaIHrAWnFdYnUlTEsy+s?=
 =?us-ascii?Q?CpSM6kz9AE/D4Acs5IdQMSC12+8Xb1Hihc/N544QBFgxlPzi2gaYljrhv/bH?=
 =?us-ascii?Q?IFO8C9FdWUIrKSBr5OdJvaFCRFLxTr1ngTTH/0lPPx6KMmyl5v2Mj9+CxO5A?=
 =?us-ascii?Q?fE/ZCRfuNg/H58GZs+ZJB4tzbaoWX0+cUwG+C6/nCjRkDybg0TCMu5ifjPZP?=
 =?us-ascii?Q?aNZnh5XJzyxSVLMXux7C5QhJ7T3zVznm5N6RMHvJzrgM94xoNzYJyIVKBWUD?=
 =?us-ascii?Q?ER8r3JR8GT+77a4+p2qXw9Gq66MctUY6NdEinojnlEfaaiDdHjbQqi1KSxAr?=
 =?us-ascii?Q?m88ah68F60ou1eB/moCtpWUAg/TNR4t44SfgPJB3/oeMGpvJUQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7270.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Lkzy5DgdNHdboWdWWPG1vbut/dVSldkpbmdAN3PE0CB9VPCxNFicbhpEz/JB?=
 =?us-ascii?Q?8hb0iLsfon3jcWIYOE5pcP8KJWFXM3Q29SheFn6cLpP+wIAh5C2v6fc67x50?=
 =?us-ascii?Q?lXTjZwEntJ7X3T6wP0jj5pswj3Nl3QUpPgPP3esUDafnRfLvNV2HzJKwLNg1?=
 =?us-ascii?Q?ozSYIFIf3/JAlqcJujG7qO/cFOcggaK/3JUkftPSyMnhbeNDA7Nucz6hMcTI?=
 =?us-ascii?Q?wydsC5NQVVrSYaqZYP/edVPHP1F/07lezgjEbKeA806vTob/erKznN5wHC9Y?=
 =?us-ascii?Q?LrbP27qOKqqEuDG+XRCmIEiR0A/ZOkJWKnckMogxeX0PdI7mRL5LKjUj9zQI?=
 =?us-ascii?Q?e4D+3Dss/xGje32wf5G9FhccRJi5jpURz3GnAZLtUMnAAkYCcmLeJeg2FNXa?=
 =?us-ascii?Q?XiNG+vlCnASIn81T+Plu1OZUXcB7lImPBNhyFdcrgRstuclpRGQJojS3qiut?=
 =?us-ascii?Q?chBaBcFGz1Li51SQtGNNxmmC6AJP+oVeFFK8Ohx1gLtzlvhTIOQE0bkwKUGw?=
 =?us-ascii?Q?f5iOFTZ4O4Z8/ZN/AW0ibeottVbcZ89DHKFs6wAqE1aDotRVgho+ezBxTVN3?=
 =?us-ascii?Q?P8vWonsGzym+Kr1EYrvKFHI5umu0HubHP1QgjiZLSeAlfmmAf/NUqosiECbe?=
 =?us-ascii?Q?VY04yzn55C9vI2I2DjiwRg4B9rTlcgxNW9HkBbn45rjrMu24nK53vsgJ9fQK?=
 =?us-ascii?Q?zY/fpXF5paVJPb3Mw8e1SFa4F5m1dg/vfigJQ+cy3S3od14NXIdEXHIVgsjc?=
 =?us-ascii?Q?hQ4bx5vX2XCWkTLahd4cXZRiq/CHl7QtAIcs7vF9JlFBBViCzi/cxB8N2mqk?=
 =?us-ascii?Q?V/TWnU/V3B2IhuB9d503zQd9Jd8Bun0fp4URcCqUtswTOycbYIp4D+SWWYRw?=
 =?us-ascii?Q?/od/4zncjOnXt2vMrPcNG6/fKtkmxZbQ5BgaO/whLmQdAPOYyUJv3iDdEkz5?=
 =?us-ascii?Q?cPUR95I40HUyJMBu1UT1ZXXqpAxF4/7aNsu3+XBndH1wEGUf6KbaAdl9uM6q?=
 =?us-ascii?Q?BM2b+E76Ey/e2EEQfdzWGLtL/nX7B4jOxkHGL0oG797YYm2G/TOlPiC6/TGC?=
 =?us-ascii?Q?WCTU0+xNemUcIJPl+ZccXAFQHQsQiPCajGpE5tBGvoL2x9zVWx/9TNVFMck+?=
 =?us-ascii?Q?1J9E5CJ0KIXA33zdw43qAteyAoBEkngwOTagx2cUh/H4sr1ytJCSDb9rLpCg?=
 =?us-ascii?Q?8NNbjDUF+I4M+LMS1Gphvk676p7FtL/DKhRSoKcnfpzo6Dnb/Io2MLLfq357?=
 =?us-ascii?Q?jHXOUksCm5Pwu1xZC/kqVqX4/I8CKlRBt+oafZQ8bzzhtIWz20JA6mMWv9ea?=
 =?us-ascii?Q?U17XF92ZogV9c7FcdoLqhOHSoaod5UUTkQUjLuw9mxFwLrrL9aSdwlqBmbqF?=
 =?us-ascii?Q?PLss1JZLUGRz6gLudneP9qPB0G98n6UiCTgzX8BlsPH2P+p2jrLvBPsEnvGE?=
 =?us-ascii?Q?kjGZ8lnr1QOQ6t1zHhwnyw2omTEeh0GVzK1P26WjxzUrkr93/1wuxKGwpa2X?=
 =?us-ascii?Q?99cAIxTSaAsGaF03NJh7t5XTwud88Sti04reet2nF00O/cYEymhABuDevJdB?=
 =?us-ascii?Q?JGsKikkLpkgfjD4ZV7Jyuy5NFoAUEMcIv7Fmfmsxoz/cDBNHXhn9utCMkh1Y?=
 =?us-ascii?Q?Tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mCg+fRxLo/WxxK74tv1ltAvZBlj2MmLs8BBfwkZK83JaQxO/U/crV7Voj8IOcsg5XuLNDqHqQa+ELb1FTIvKnDAobtqpe+i4+YRuPhV1ng8gd+OZdCBBC303gOu5OP+i6HLkZ7SnePxFO3zTIMjqi/5tDVYdUMvuMMTaxAJ6AkClWGbMBtPbDqHV+OkFVhp94AIIzc8QQN5jJVkUPS8M1qD99yugwbxEyGgu+AMQ/pTrouXHYHx0GMYX0WAvUGhz+dtLVy3Pzde3x0e5qTqGI70BlFk79nwBsGTqoroyA59iMzc+dQzoA8qurDQCwkoJMf3+DEGQSe/3Yt/NXd7B3Xy9wpWmz9VqzDnb5hZKeROVgaB2mBDahHW2yTcpXiPl6nChLX2b0S8BtzxVGFvslw8pJdpRkjYj2t0JKnKPlqiq3dBRssQrefV7B0SeXtt/eMILpPjmimhPUJNnsG9oXE3xlSKn8G3RcEw3zJthj3SQHaGDyRa9V/AhQHYWpIy1s4FUW/Z9mpFU36VbRe1FOJf/Vwsk7AXPHZSkW75zu2YYLQTtu+uKRkdNmeCMJJXbxJzsdyQljK48k98NST/uVEBibQeKWmiGUvSUcInXZiY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f16a5e7-43fb-4a16-3d23-08dd2f4b27e5
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7270.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 18:43:19.6898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ku2llDYuZoX/huykveCx+7LJgpVn5bj6CBHP3FZmui1TPbVvRhErhReP+WNul9q4p2ipNhpAybwTdGICMTg/LCMnFIrtxtFFlDuceKmpFK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-07_04,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501070154
X-Proofpoint-GUID: -4REtnPuN9e3wVhZny9WW1aHuJ2W9JYj
X-Proofpoint-ORIG-GUID: -4REtnPuN9e3wVhZny9WW1aHuJ2W9JYj

Hello Ridong,

On Mon, Dec 23, 2024 at 05:00:16PM +0800, Chen Ridong wrote:
> Sorry for being busy with other work for a while.
> Thank you for your patience.
> In theory, it does exist. Although I was unable reproduce it(I added
> delay helper as below), I noticed that Herbert has reported a UAF issue
> occurred in the padata_parallel_worker function. Therefore, it would be

I'm thinking you're referring to this?:
    https://lore.kernel.org/all/ZuFxD90UO8HadnCj@gondor.apana.org.au/

> better to fix it in Nicolai's approach.
> 
> static void padata_parallel_worker(struct work_struct *parallel_work)
>  {
> +       mdelay(10);
> +
> 
> Hi, Nicolai, would you resend the patch 3 to fix this issue?
> I noticed you sent the patch 2 years ago, but this series has not been
> merged.
> 
> Or may I send a patch that aligns with your approach to resolve it?
> Looking forward your feedback.
> 
> 
> >> pcrypt_aead_encrypt/pcrypt_aead_decrypt
> >> padata_do_parallel 			// refcount_inc(&pd->refcnt);
> >> padata_parallel_worker	
> >> padata->parallel(padata);
> >> padata_do_serial(padata);		
> >> // pd->reorder_list 			// enque reorder_list
> >> padata_reorder
> >>  - case1:squeue->work
> >> 	padata_serial_worker		// sub refcnt cnt
> >>  - case2:pd->reorder_work		// reorder->list is not empty
> >> 	invoke_padata_reorder 		// this means refcnt > 0
> >> 	...
> >> 	padata_serial_worker
> > 
> > In other words, in case2 above, reorder_work could be queued, another
> > context could complete the request in padata_serial_worker, and then
> > invoke_padata_reorder could run and UAF when there aren't any remaining
> > serial works.
> > 
> >> I think the patch 3(from Nicolai Stange) can also avoid UAF for pd, but
> >> it's complicated.
> > 
> > For fixing the issue you describe, without regard for the reorder work,
> > I think the synchronize_rcu from near the end of the patch 3 thread is
> > enough.  A synchronize_rcu in the slow path seems better than two
> > atomics in the fast path.
> 
> Thank you. I tested with 'synchronize_rcu', and it can fix the issue I

Good to know the synchronize_rcu works, thanks for testing that.

> encountered. As I mentioned, Herbert has provided another stack, which
> indicates that case 2 exists. I think it would be better to fix it as
> patch 3 did.

But Nicolai and I already agreed to the synchronize_rcu change plus the
alternative fix in the patch 5 thread:
    https://lore.kernel.org/all/87bkpgb7q6.fsf@suse.de/

These two changes fix all known padata lifetime issues, including the
one with reorder_work in case 2, and keep more refcnt ops out of the
fast path than the original patch 3.
