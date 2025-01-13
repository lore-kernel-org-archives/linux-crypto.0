Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6B620AF73;
	Mon, 13 Jan 2025 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736787454; cv=fail; b=Q9CyWX2Z1sYul6mEAwlXVp2yw0tTD3Afw/aTeGF2zDmUhs2nIrZB9MDHKH0SaZL9dhbVRQKx6eGo8mZRrSYCqXDafdyym1hBc0bUnAzC2LqeKF2oDCNVNWfe0OQHXm4YMUYVIONzPucboJkvOAzg7Zx3K3tpQglbJNC7H7GBuHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736787454; c=relaxed/simple;
	bh=Lmiy7kg30r/Pk1UdMuJ4dclh4GUIjcWn7UaH5Lgl16U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZA4RWVjD2rzf6xnPJf09y1vp2+X8L1E0mB4nhlSI2ahkrOC0hF//cqlpdJs/H0m/dIoCgHyliu+TToVrnrvvBEuNbWsKSbhHdwQbUHxOR6RUJy7Asmh60mEf5MgeKZkWYwUf6HThqYUmQkCDRMn7TkjiYLDZJHNQhWLRyNZXQwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GsD/Ozso; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sUoFTFlw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GsD/Ozso";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sUoFTFlw"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50DGtugZ021502;
	Mon, 13 Jan 2025 16:57:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=v+KT5AlgJ/mi1FBDxp
	fKgGMQ0ht7JdeTkBRipglz3qg=; b=GsD/OzsoP1vgbIE8e93BIVez5ZIRATPzv+
	4GHC6++TsqwySYBqlvM85nMOdJoVPFPCDCKl8Iftu9gaLbjuyBVbFACDTAhhVUH8
	iIhe3INFudHEpMHgE6p30wNDbeSY9aQfvfncfDn1yNgRZ2rHoc1mccjLHekqAG53
	ySdy8SptD7ZIZjQ7nr/ZZc+TSBeJcJDn56gaak2EskijZ6gCO0jKw0LLWK1KBvI1
	X9Y6kuvu51XMWBLXx9EMt41S9y5i8qcZE/U3FvQkKpuJaoERb836rJvqvmKYCW1F
	zK1fEfSRbc8HOLJM5KxDUEYSkNHx4/v2jH+rKU0GVYWYQTH4ue/w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443h6suyjj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jan 2025 16:57:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50DGEVOS030053;
	Mon, 13 Jan 2025 16:57:06 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 443f3777jy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jan 2025 16:57:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ywXtctIK4sm10+A1f28BcPXCHTr8jNyIvjAyWq0tqhDAWZt+RPv/MlHH6OGB2fXYMRWOCrrebCv97MqXwj7OSKvhW6dl0ad3s5P6b+Oq921Rfd7emiprTvpIM/VpKlcverP+3N8bI3OsoT9o7jB+VhrXiVuchr9v2rXQIasGSyLLB+979nifHHQNS8fePUL4pXGvMRmyLb33VX3kHwlJi7ruLm2uxQy18KfzPWBEXCpYLI7WEubIDuGzFOqVfKxxYaZQ0j+JvCgG4/xb2SneIwuD3mU2spRCmB+Of2vFUa5FwIs/tF4L0JY7F7Oh/wRk9FFHaoSUBmr8z8pWPB4wDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v+KT5AlgJ/mi1FBDxpfKgGMQ0ht7JdeTkBRipglz3qg=;
 b=MG0W35/GX1wx2uiVLpytm5khxyQCbdtUFOUCNOoAEtTVeBNE1i9xHE8xdCzjWCm/pVyfEzQpLCQJDs/ZpdVdTb/Vp7bJtOn2V5fYFOXgBcY1RZBjLANgjGYwd2NlfzUdxlRjUfgEh9d7lixC+KpDWFrup0xGyRW4zLPrslSbbUwAVOK1Ws52g+IZkQ+Wc8hF9JlhPxyJRaMtZ++UWrDonNvEYCHh3o7TR7CHbx/paCImCbDj66HldD9ak8mWZA4VRYW3PRpiGhD4t6UyagO+6J9adJa4OlUCocr29PkVF+Q2ynxjQhXF5CfIRB0YZn+l71CDLWffp2jeLjPVECWCAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+KT5AlgJ/mi1FBDxpfKgGMQ0ht7JdeTkBRipglz3qg=;
 b=sUoFTFlw5YBHfAHH4QPKKXwOTtoMCkIpBOmcZIo9NzZ9bX94ViA36xslarS1XvQkFwQ/H5kkbE/qTuETQGaYmNmUAEaneJ5QxDFxJhjTC/mLxFbLH/DrLcBYn+hIedUW4rTe++iMOdxDOwJCSe0WMsjkuw5LFQyQpNlCOjA/0fU=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by CH0PR10MB4988.namprd10.prod.outlook.com (2603:10b6:610:c8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Mon, 13 Jan
 2025 16:57:04 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc%4]) with mapi id 15.20.8335.017; Mon, 13 Jan 2025
 16:57:04 +0000
Date: Mon, 13 Jan 2025 11:57:00 -0500
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: steffen.klassert@secunet.com, herbert@gondor.apana.org.au, nstange@suse.de,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        chenridong@huawei.com, wangweiyang2@huawei.com
Subject: Re: [PATCH v2 1/3] padata: add pd get/put refcnt helper
Message-ID: <jsqdyckjudqbwl3657udz6qmyikulaklfhlvn44kdxflftampt@pj7535mluqkh>
References: <20250110061639.1280907-1-chenridong@huaweicloud.com>
 <20250110061639.1280907-2-chenridong@huaweicloud.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110061639.1280907-2-chenridong@huaweicloud.com>
X-ClientProxiedBy: BL0PR02CA0082.namprd02.prod.outlook.com
 (2603:10b6:208:51::23) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|CH0PR10MB4988:EE_
X-MS-Office365-Filtering-Correlation-Id: af1e1845-6b6e-4a57-bdfc-08dd33f34e40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VESB69YQIh0INeCji7V2bd4Hna7mCnvqFm9FbH03TY9wQUl8tI+xwlykLePQ?=
 =?us-ascii?Q?vpMRUSWfG0rHNPVZwbsMktefjyl1d721s4XWVHtQoVjzefRS4GBUZUu5X7sT?=
 =?us-ascii?Q?0g/LB+vxAL7TVn3LZgGlGi0gZuH3HVZc9rLU9IgaF8QYgSVm7EOtt9MKhCo1?=
 =?us-ascii?Q?MtjSQZIqUqpqeDZWEnC9aLfdF55SiRpv9Fjs6RN1wjoqfFvHlnc6p9vvNEXA?=
 =?us-ascii?Q?OnJGAptLrl9Vu4YJ+Iz/PyVJEt7E00Bk1Sabg2v+D4zCC89UM/YvDx2PHtT8?=
 =?us-ascii?Q?7Nc63llF7wpCb5XpGHECyk5Vvf0dqug1WZEhq8VYbXziTvii2UA18qgLSLY/?=
 =?us-ascii?Q?ht4HEwc7Ls026+vz0yVa8/Op3X1gX7n/dl0q/as4tLgUk/lpjxuLALEw+Tab?=
 =?us-ascii?Q?TZljq/AfDVOIyk4vBFD37JHs9znToW7y5OWvEJT/1Pkom3HfVEmDZTrPZE4i?=
 =?us-ascii?Q?ak8mCkiCxu1mzp5SLQUlYRLKzUWF3f0keDgxTP9ZiDmxXxY1JQS/e8AHW3Ox?=
 =?us-ascii?Q?1uRLjrzB7TnuKpKJFiA5SGTUgeCeefB0sJPn9lS0wiEwN2bMNy4w2tXSxwEA?=
 =?us-ascii?Q?yzWbZ8pqcOrRvQzImckkoFZmDhdOePcbJYYH1pb9Ynp4KUzcmfLwOwALuIlC?=
 =?us-ascii?Q?F2r1C+J7sZDkGE4frFbW6EkNrHmTL9j8G2s8DxNgleTMPufERoXZuZ/v8IQP?=
 =?us-ascii?Q?v1SGZ1hNQZPAKEf1y4KMJGwtadRgAlCk6JzFOed3mn0nM4+cpdasBbZ7yQza?=
 =?us-ascii?Q?7b0qVsayai6hAjjcMPeJTL+2uFLMKg+XsWsMMG8NpQg5M2X2dfki1Ja1Ns4n?=
 =?us-ascii?Q?KZkYf1yBl2uRtZHeoE+4aOdsEvVpKzOLsUFTUyr5J9PMjc+53xdNb/6ezVDq?=
 =?us-ascii?Q?DUSCdhkYWsWAoF7rB3mb3lXl2qzyv4BNoJxudTl1DXY++mMjBJngzlvCSKui?=
 =?us-ascii?Q?FXFbhAq/MfKpEm3rW6FBqZGCUPVAUW37c//N8RXEISLtAznOrO9OMsODU1Sv?=
 =?us-ascii?Q?v46yaNvpTon26eIQGOce0k3PEbfkDCDnHL4ZZ3khktXfqLV9BAsALyE+tueo?=
 =?us-ascii?Q?diO1FPRkQlICMJ01KCxciG9R1xV2z+piJsfUfZARgTIjQe/tLW0LwVBdsiQu?=
 =?us-ascii?Q?h0kEtMWf/mXXlATmLLLDLhU9HTpWNl6LioZfjzi2HQ9vJiI1/CFlBjc+tRN6?=
 =?us-ascii?Q?sJ4kQFCuQQKjkyCQGCs+D9WwxlMF3H42i/p/Xh0Yj2vuSMe4ohQh3rzWa3aq?=
 =?us-ascii?Q?k1sgJyIuxfrx7474MFeWmBA1WqZ3/9W47G410SYS9V5a5QVYKncwjzaqsAVu?=
 =?us-ascii?Q?uGidZOD54+rvCeRqtwXhMsmkwlk5v+jlAqqoW/YQ91It2i/pe1fXkHHZaJP1?=
 =?us-ascii?Q?x2f0ciA3qGVZc9Fv1vYolSWj/oOi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MJaMGHvc4Ru0M+PMW9iZomTmK78vmWPNzEBUwzf57smElkGPxMI8odoMMxFa?=
 =?us-ascii?Q?LBgM/rWUDQktw79gQ3E7k0wZwWHVG8khgMEeZTOqejs0+EHYy+fes1CSRfAA?=
 =?us-ascii?Q?vzAPCZBvEu+raesZO/xPMHjur8DVAQvGYaQhUQ78kp/Wg8nhmRiHhnlAXBPk?=
 =?us-ascii?Q?EpvXC5SiY19kW5mQF1UV+gx+1jf24LM49BlmcIGHo6NuNn7fz1uyjSo120X4?=
 =?us-ascii?Q?zFcYlbbIuSae+45k5p+su6gZ+nmhLM3OYfsXGfWLvot3Kf4izus/bmlKSRhW?=
 =?us-ascii?Q?aZgTs0gSL4cpy0d8B63g7lVf1KJRh/8loq5oxCiVl0FrQMhaDjFKCVQpeXpR?=
 =?us-ascii?Q?05CofceJalYCnuYZktIBZUFJ8Mr/0EcTn6fR/yQs+0SEGeTrhQAi7QmKKSzT?=
 =?us-ascii?Q?+pBd4D2iWMmylydRKak2pS53gjnQ/mXOWn9K0eJpIZCwjTS/OjtCtSUYWTJF?=
 =?us-ascii?Q?wNLwEE8WavtPxMnZwxRrOBa4oQICjrVQlgeV0znFWc5/7zQmIxBhakYC96lT?=
 =?us-ascii?Q?mXzW5SWW56iezHRwwXutJRVeNVtd3E/spfK1z2havH0ZpxTVqde1Ernz9+bx?=
 =?us-ascii?Q?LW/Tns4N0q4+w1ZUOfEfNVWuizUVZg98uoxSWiHufqW2MjXdtp6DPwoKbchR?=
 =?us-ascii?Q?0JByKyCktr3S+WX7UBqXT6YumVp21FhXTLI+jQFu/OkvYU/tIQmeBJZaw0X5?=
 =?us-ascii?Q?Eoz2bqZmwLZ67hT7pyFn8hGcAc/94aASQhrJKgDDwQ+s7mJpbHQNia8cyU2Z?=
 =?us-ascii?Q?NeQsbDOoo7MAK8esOp47t3/xMk+UbcoB20i7i7iFeJo/kWfZ/Fp+XEbaNVGy?=
 =?us-ascii?Q?hn9v+9u6KPejSCeYGiJ6TkYcb1qoqu7UbWE0N3kFuRRdQ4XTmbS0szDQqzfz?=
 =?us-ascii?Q?kCmE3lh67vnE6bRzxDjNaTWlBr7AmxDmHna/sgH6QyCODK1WvkNb3CrRxGRl?=
 =?us-ascii?Q?8MtoNWOuGqjLkAdBxJ3xGEgvCF0wilor2JtFpGNI/IlM7XiZlNY9VV+1mamq?=
 =?us-ascii?Q?h3bSJFvuptvYvQew7zj8c9Fl1TknTKxblgpaIX+NBMuiebAaouFWP0D2be7u?=
 =?us-ascii?Q?AZZtn98Ia4rLE9XjvRzJg2gHInXXeXE4nrJO1DHi3WPnCZeoboi/X24cSdk9?=
 =?us-ascii?Q?0uQ+1r5lwkYH1xCFZlB1RUkj+nq0aC04r8NNCivqFfmiLqXh7B1G8E4uR/St?=
 =?us-ascii?Q?MPlhgA5D5r+ZPNsuH2Kr7ABWaR+w6/8056F1/3ANLCefo1WFKP8nPZr8syoS?=
 =?us-ascii?Q?PbWjDcC5n4ABEgjtJ84xws5ewJJ2Q3TIJOoKec18yoTdaxOs2GQ2eIUhw197?=
 =?us-ascii?Q?iJJGZ4Rz0NwoYUn2e+ekRJRMz5uSI2AlUiCPfj6U3OSjh8IMKyv8JzGtJqJc?=
 =?us-ascii?Q?jSk6LAXJSFCnS49jLHqrbiPaDYsZnjVh7DuIgO3ZtohAG5FHZtlyrsZavRTC?=
 =?us-ascii?Q?oRuDm3RBPJJz/SkDeI+4xKTdePDEuAsC7cGkWJETWpxy+Hp2KWjKtjDIuYy5?=
 =?us-ascii?Q?875yyYzYR3Sei0JZScV4tYb4xFzyS/QwIb07O1Ngl3oDdYDM4pmFaIpr9fup?=
 =?us-ascii?Q?hOKtIwh3M3DFEpYdhWiPy639Rg4PNA8aH+QkCNr3n9vQl2JOZCFgxOa9TNml?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3dQpUVUvmY6Se/T4vt9oS13It4fr5wyCZ7CJWmmWxUYW8wLQDIcmIoxl0aNtcLCGpb8ZFCAnQ5Cp+GFCJtufu0j7qGNE09QzmRarfOzwVOOafsvCFSBH7BGQ6XltVxdROb9VMws2X5OPdp5uiV8/5wJRCCNL3qo3/QFCS0+mMysP2q+AI0sllEN/j6HnPYFxEeXpSEathzTeM8y7ozhPrHSKzcXgC45Z9hHqqLOj93CeyzHW7ea2ar1BJ4vgDio0SIZcEG5+Sff7G5KIsHbxBVbnRDH689fTUUJE77vondYb82HVinQn5RV0TQQMmCmXl/C23r09011IKCuI3YCpypyGGp1VY6VhPkjwpkkqPUzhEGkl9AwFj5aVea9L0eIhoIF2a6NMwFPnUnbVTt7I2AK7VfFML3oJ5zv4xWDiZbr0OJ5yggOk19xGntyDJImC+uXsJxbFGaEawAulZYufR9pJfojumHjoTqLUYqwWJxEV8HCo0etv0VU15IvU/xCTKD0O11qIisPVWFUP/nDttyRpEQGmLJU7F6IhhriHSZ3uJX4eFSe5O/IIWixGDaC2FdLyQIEu35DQAIS55nN+GfdJxSq/ztN23DmpebZyGj0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af1e1845-6b6e-4a57-bdfc-08dd33f34e40
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2025 16:57:04.1548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pIqPJ86uFlDREwKDmGAvqV7HOzwWhIyttHMxIhbEhRo0kX3Na2+IARdeNrPEb1COIjOqO48gQs6v8ISU4ynxPgBhKIeA2nuiVdUAPc1vx3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4988
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-13_06,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501130138
X-Proofpoint-GUID: zUQVa75iL8TeVjtBRhJoMv9QSfaUNR5F
X-Proofpoint-ORIG-GUID: zUQVa75iL8TeVjtBRhJoMv9QSfaUNR5F

On Fri, Jan 10, 2025 at 06:16:37AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> Add helpers for pd to get/put refcnt to make code consice.
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
