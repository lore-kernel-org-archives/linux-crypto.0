Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9A82391A4;
	Thu,  5 Dec 2024 23:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733439833; cv=fail; b=t9JMFEOrQwWgL5SKO/TUTtI/O3BaG7+GZjCtDHkG2AHFprOh4fbv//80j5Fd/X6GW+pBLIqEVlwA7e9YDYHG0Pn3fLZFuk4zV+yElaotCsd9DiqPJb/wMO+nMxiGnCBjwMRIwynFnwUg6rSC4viKZ1ggCoK7eg3z715EiiTQeKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733439833; c=relaxed/simple;
	bh=LnSJ3Mn9Q6V960KSuzPUHlFA/+wR3TPVeuE/tcwczpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BkItUFi5zTqQZcujjqz0XVK8h2P/v5MQHxxvKS0hn3jZc1B69QXwk5eqtXAU6Qb1p2cTg+QIgcjCm8H6fnNB8z6Gn7s92EaRlVS93oM/Rz/Ihk05WrD6Uo3EC1Jz015dlrW/Exc4/5U/OF7Gdxij7f5KTn+6OWCHt1j4E1JU7zA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SdMnf6Ox; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=skmGsFyT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SdMnf6Ox";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="skmGsFyT"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5LNY7Q025105;
	Thu, 5 Dec 2024 23:03:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=UiAUXLjwlRLuHcSmok
	3gd8m2uL427c3kHZ5DGQ31vaU=; b=SdMnf6Oxf+k6fs9DO30UCkNN+oNEkZXCgS
	SQuWFkzu0Ewk6lQoy6RnJDcFrz/zbPKanQRSAd8WtYFnj7WT0vMF1LKyCkWg+uOY
	XIdj0PMO49Q8tI1Vbf22H/zriWOece8dQTovhkc4B35LsvUp562wy8vF2I+CHpoN
	EP/2AoOy4crieXtCI6xs8pKgCYYvmO6kOHRcBFSF7iym2JKb8NZUkYQif1qqtAaU
	mYvB3uo3Y8kPURMj3hGxtZH9zbsEfYZ2yIwfbUVkoYWp+2DT8pni1/k9G9qY76d+
	TYfalsuOCToKB8hisEOGvFanNjhwIJbPFROlZ6WIYI8bepWlMPJg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437smamf38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 23:03:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5ML0J7011632;
	Thu, 5 Dec 2024 23:03:36 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 437s5bjejp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 23:03:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mGr4ZNrtPPxClMJyc1uay1M9RXoy05DcAVzg2GZZouEoQr7lEwdBUmfc9AnExpNshdMjKblVy+50aSjYvsfBMKfXdbsiJUMFoITybH0LVsDrUm8yZr4gHJow0qMNPbrXVXRjhSr9iQ3snMo5l0xfcwZqcgMlhY5Lxim0gwa5j53B9Q3ZskLiSZc96mBNrckVPMTu8lUWknX7yO5ZEGTm3XmfiHATa1U/VQ5VLzUlP/fThB26ALBwgnP7xh2gQLOb9Z3Htv8eCVxSjWJBdJKpuikbPv/ntBjOuUhGiU7bEEnmOy/XUXuUe2+ChUq0mEivWeqUhTOudqiWrwNlI1sjjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UiAUXLjwlRLuHcSmok3gd8m2uL427c3kHZ5DGQ31vaU=;
 b=gIsA7A8SIlrReMnaKtQi6uqpEBjnZUatTajhiBps0NWS2dLmmu58tgXxHyvE2A3R8g8Y//0S3ZTg/vOaaZF4UM3CTin3FiBqYwF+XR978ZyRCMF8EYtXhm3Eq9QeYzD3/LIapx5/On83+mQlre8WEmemH+Z91DuBkgiUPthGEbDxbWfWNBF1IhrY/qIc9J2wR9E7YOBrdzRr7VS/Y+IEOvlEoRIXNqSbaacmMFu1Sfw5Xc91J3tvkJ4TKatymIpIU5hHhODXWh7DxhPkhlvw8pPrkVlifyTGbg6sYq4fr72M4S5SbUguw8QfI4a6nPvH1X0Zd68OSqzTBA21E5pr5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UiAUXLjwlRLuHcSmok3gd8m2uL427c3kHZ5DGQ31vaU=;
 b=skmGsFyTJq4oEpIX651wxHSIdsxjPf83EeJ9iO0zaMLoAzO6lZoe65GmbV8EFLYV8Ockf0Jns0tN/z+RJ2k1IUBF0HJYtns808+Oo1tlP57KadX2LaI/uL8BJGT5RYG+O7dwkYp5nG7u7KxKkdtcwzJWv5gww2qKHwKbFkFQfs4=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by DS7PR10MB5037.namprd10.prod.outlook.com (2603:10b6:5:3a9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Thu, 5 Dec
 2024 23:03:34 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc%5]) with mapi id 15.20.8230.010; Thu, 5 Dec 2024
 23:03:34 +0000
Date: Thu, 5 Dec 2024 18:03:31 -0500
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        chenridong@huawei.com, wangweiyang2@huawei.com
Subject: Re: [PATCH 1/2] padata: add pd get/put refcnt helper
Message-ID: <pr7mhqz6twrtnlgy2nphr2nznk747tymlnooxab7xvvgolykmt@lr4z2a72tqur>
References: <20241123080509.2573987-1-chenridong@huaweicloud.com>
 <20241123080509.2573987-2-chenridong@huaweicloud.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241123080509.2573987-2-chenridong@huaweicloud.com>
X-ClientProxiedBy: BLAPR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:208:32b::34) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|DS7PR10MB5037:EE_
X-MS-Office365-Filtering-Correlation-Id: b225b3fd-8ab7-48e9-a4c8-08dd15810b74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Lo0qASAXSF52FugFAj+wchANwA/LcNAs5v7O7X61M40wd0hADSmlpU/PgP6w?=
 =?us-ascii?Q?UjVUzKBvxwj93OY6juB3tkbnNEg3lIPJVrOYkDGcJS/5oRJM9u2uf1u0xbea?=
 =?us-ascii?Q?B9Gf92i56cw3+obGLnEahB64oqbFw8yqtivyB25mEt/wOaDNq+Ixvx5NFhn2?=
 =?us-ascii?Q?XgxUM9v5ZVYcWdn/Lu8Gx6u9+qR1sBZ5a/B4IIo9P3yabqoamo4n3eVwyXFj?=
 =?us-ascii?Q?jleSqo+tIYzKeCwrN2PpqU2oiGG9PzsD2N3BBVEdAAf3VgZdMcR066NT1CjI?=
 =?us-ascii?Q?VFrvXkYBqPSiC/Qo/OHLLiJ4eRFAxne1gbcku/7wExBqeqcXievkPezRKUZ1?=
 =?us-ascii?Q?eB7dGGMldDIo3VUKRFZE3LjpxHufRoweWFvDlUL+TF399RdjBNQ8A55O0HZk?=
 =?us-ascii?Q?gJEYvKZ9KVnkJdvZpputOa8uKx1JwVFxvB8mcMptQDklUd2bbiTCtnppME4x?=
 =?us-ascii?Q?7fm8VJBoTQEETclmtxeOuqTQqxNE98bvf0mSyXAwIr5ORC5M6qyTqMynY983?=
 =?us-ascii?Q?HtejeqcqzbmoulGSwzckn3C8UNo/ix/8VYODX0XqQRNcSwCGwUeT8LstJmJA?=
 =?us-ascii?Q?mDS/bM7UPAv1S6ScGi7oPzKAAbSqdkjZSOLD3wxCEkqBzWsiwqGAJ3vAGGVz?=
 =?us-ascii?Q?84aaYIQyqgGXQhnoT1lyOjtKDrhc2UQH77rcPnahf0l9Z7zFEuCRFsz9xob3?=
 =?us-ascii?Q?n+rPCoTlrU1vnVGoAMtYgNttw8+UJGLVfQCCjramKY6P+x+deSVJMdWxDema?=
 =?us-ascii?Q?BW7YRY96xYc4WOfEBtUSbRntOv2VhU9DmcE6QXuQFFJk9uA73FhZ6RbytSmK?=
 =?us-ascii?Q?9eI9rvD4L5L+nhNH2D5HAcNymzaxu6zouwvspG1XsAO1GmPev1q8VSLS6MiZ?=
 =?us-ascii?Q?njhpwXPOK6QZirJeDoY71daTIkWhl5+5SfrkncR2pxmWpa3rsuTWkauB3Ucv?=
 =?us-ascii?Q?isjK3S/QJz1cqbmqetXnoDaXMKigt5d+hZmtPcQxT6iJL+cxR5UkfxhX+5+N?=
 =?us-ascii?Q?+rDxkTirdLsKIt552gkhjxvqIVW1XB4A1aU850Ebc8Zb2Chnmocj7f5wP/uB?=
 =?us-ascii?Q?E1eKn11B9SPD7DjukZJSUi7oSE0MGTGW0RGN2G6WQjqLivM+OhW3XYmlaRYC?=
 =?us-ascii?Q?0JeqsjuvfeAo9IP8JkV85LH+yzlUsKCQ1UoD+K94limgiAaqGRfo8speFVKz?=
 =?us-ascii?Q?Dl/5HUqZpzHWCV0By01ki9zrc/yTUR6bRpQ19FtS9JewTvKQyoOtXx73YFPi?=
 =?us-ascii?Q?hI56idEwFSedfEnPvbE2HQc9espBVRBou0fYT2h/wC1RHBxVvRhnh6chNTq1?=
 =?us-ascii?Q?p5aVZ5I2vB1xH7nCQnK/XqsH4yMITw1uBz5FeJ8rY06D7A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R2kzRZo5JEUu44o6Bbx/DQrMs6B/kwepLbyiHfIqp00dXgtZP3jaEf9sr/3y?=
 =?us-ascii?Q?6k1Shea5POBT6ulcteHU/7+z3LOnXt+kM8n1EYxZCosFoRafvG+Cu3GIdKi1?=
 =?us-ascii?Q?d4kIf9MTrJp4NrBAewqvExSWS4miHGY7+x1/aGRVO3org7fYH6A0hbyUHDmq?=
 =?us-ascii?Q?mDhNGrlubQZ0WmI85dCBi3bqFT5tFqUhF4y9Ydz4s/4RBRhVJbZ9ruU+Cnhg?=
 =?us-ascii?Q?i2rLN/hHOv+LjTfnDpSwyAXPSxM0J24dkrPvDOnafkX8ArpWVAZ1k4EoRlVD?=
 =?us-ascii?Q?p3rFeaowfwFuXcnpLxE2iY1EC2MBEp8sV1MvcZe1tkyJurb3ULHiGjcQUvl0?=
 =?us-ascii?Q?x4gYIJogRHNR4+AqNcWaUIEiErzuGdzUWNfuI6O3x9a8I5Nh8xDrOXG5Ywcd?=
 =?us-ascii?Q?ggTntLDkEN7x2qss60gd0XGV+A7JltryyI8aRYy7XxGfBY2/HAEE1X2uWHNg?=
 =?us-ascii?Q?Ia+ciRbu3N7hFhJ9d0SEHV5z3oNkmFTquypT6I/ZQS2Dw7dZYUTwrYI8IYhN?=
 =?us-ascii?Q?u2VFo74iMDJ7Q4jPQSin5jt3u4F+a3Ha5OljNXpb4CV1Lde+sSneII7HJQ68?=
 =?us-ascii?Q?DRVp2cZTf0V4H0gqX8VOnRCslfN4DTHvXqLqVu4FmFikOvBLggsqxse1Xexo?=
 =?us-ascii?Q?+D/8ta4Sd0OUpKfahM+XSD6ipc49SJMWBKw9ZP5dKvbcnIOESS7gB7YZGpjj?=
 =?us-ascii?Q?m1+3xHVBB4BTA7n9aVUBR6VM+qcv6mrIaDjLoSJh952zWJTbPVX6+SLQo4AY?=
 =?us-ascii?Q?ygyuagpNm1cpwc5kE/wbkVAz8KhvbGHG4iUk1qX9MibQ8uiCoSSAKSKqHzK0?=
 =?us-ascii?Q?ESzVi3qmSg7L4PFvBadXWhiDSCAmQAUsweoifId7e8hmtu0UE9PgXTLivUoV?=
 =?us-ascii?Q?lTaJ4We0MA7Ipy+HhPDxY9yu4MRHwt33FUc9k2Oq+pe3qpB9R0dmDlZxIWQN?=
 =?us-ascii?Q?GJh/ZMRMgd+rhEmguppwJm5Ia3jKRTmJ4TC8IaA86W+gRxywurVar6nRVXZd?=
 =?us-ascii?Q?ZLdFvXmGfW8z3c5oHpYGQb0WxJze6mILiY8jTmnc7JvuhAVGJKjRB6o6/nwJ?=
 =?us-ascii?Q?7t9q5RanbgqGUSP2b+1AhPpNUSmrs1um53jSK9fO/XAwms3K/VBI8yoj8+I0?=
 =?us-ascii?Q?gAfxeyb9ibRdhQfnEv7/VXUEnO7JWgJeioeObfpPW5CqFpMHwjnDeklUDBO1?=
 =?us-ascii?Q?eUYCS02pYnrP5o8v2vrs4opTNAkxn0NYizAxk9ZaioaA8PescWdwL3lu+uOu?=
 =?us-ascii?Q?Lv3SpxRIedmxBCHljmED+OWcu7kJVvguxAx5IDcNtCZKvF35H26kTsn+vHWT?=
 =?us-ascii?Q?ddkYHjuDjx71HZaIiSInGe4wz+6dCR9/gmcmPPO8K5fbIZg6vxDgkNzDKLzq?=
 =?us-ascii?Q?673Y2lhi7wr0ni6BRE1M/jZJfVLhqNRlbb3z8s7Xbg4Ck+s6XUnB2Edt+TcI?=
 =?us-ascii?Q?mOcdnzaKMhqmVMSDjent+hTgIendoytitJtOJzD/lp+O2/QpHhE9ouBdyXw8?=
 =?us-ascii?Q?AN/NO2KVBPUFXK+lUl+uaqnF3WWz6MJD42ewnxaxIrc9wrmG3Erln8IsVWKt?=
 =?us-ascii?Q?Wvuaje8VeIf/mGRY4KBXlLXhBcnSZ+m08JaRehFeMzn7EkoHvcnyYzdIAFDz?=
 =?us-ascii?Q?kA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RcF2eic//DNzZZUJfvlUtCesJ6XnFf2+vUUirOzS/cghQnPlHZZ5t26DZ8gpYdjgfSo9swbmz/Xlf7ZVt7KQLmGO7zYA8yWNJbMi03i3XQ3DemlfvDjmMf0SgokVuK+izKDniPpDMXtWjN7m+NDmrqWkdPTnmRVQ00tLBvOPKJauvtJ+r12iPuA5XzxKGHx7zBi/eC3RCVne8+Owjr1n8jispBKqyRxLkm1CLamIevPNJBdHz++fTGR10RaUvkwL/uvBbqcr8WdlfaizSofMxFtACq4GGP7a6izIenUI0Qn3UjmlgB9tvvyDjrGwNduWnzBVGgCyQOtILeriwcEFiev3vt8hEn+UAtQGukB4Rgdd+/zYPLWO99LZ6esEzpVyO2cPQ1ubxZc1FaGAy+D9yXoXbxDLwGXVWvkUNA6f4htWHuC3mngEdRx5uLODk3Qn5udsUVxN65NSQTEuqNzj9HvU2svCaQqAJ4j4oT8NLf8RcHAgxa5XvTawkgKjlCHLeQRJLHiomSO2n7ih5ZqVqMBl4/3fGXJ4RmMeIdC48h44W6RlifYufhEpVl4kRi23W9IKXAVDZ2CA4NWRfxMCJOW/9NP+sDZdc0+73E/1I/A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b225b3fd-8ab7-48e9-a4c8-08dd15810b74
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 23:03:34.5100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AHYz4ZOwpW67Oo8JSDe0XxkUObbSAzl97HzS/jUZ1BPyP9P7hYBjWzqySnOIkeGrFo95mpB5Cim4hRpo3q5nTPPKGXIUNMsLmFDLuqHRuck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-05_16,2024-12-05_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=923
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412050171
X-Proofpoint-ORIG-GUID: TYw_l1lcB4geHoe1FnFi89k9CkQNnVNJ
X-Proofpoint-GUID: TYw_l1lcB4geHoe1FnFi89k9CkQNnVNJ

On Sat, Nov 23, 2024 at 08:05:08AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> Add helpers for pd to get/put refcnt to make code consice.

Seems reasonable.

> +static inline void padata_put_pd(struct parallel_data *pd)
> +{
> +	if (refcount_dec_and_test(&pd->refcnt))
> +		padata_free_pd(pd);
> +}
> +
> +static inline void padata_put_pd_cnt(struct parallel_data *pd, int cnt)
> +{
> +	if (refcount_sub_and_test(cnt, &pd->refcnt))
> +		padata_free_pd(pd);
> +}

padata_put_pd could be defined as padata_put_pd_cnt(pd, 1).
