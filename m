Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E68316DC3C;
	Thu,  6 Feb 2025 17:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738864219; cv=fail; b=nPFTnVsW3XtT1wUNEc+cDSklY57KtmC/bDQN1I6iyakKnVvPvCjvdA9coVm7wm+ZnWqOZdWodSCHGhdnXG69ASdppGvo1IYc/YFWFcKST5gTp+jrEW0kQffBEN849/BPbJefpKMZd5rlG6ZA7ukOoI1UDjFJe54zFFkvsou7g1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738864219; c=relaxed/simple;
	bh=Kq9xCxUqe55R57TvTaTvCjXbperwdSDrnV/dcKhpOcQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=EvQmxBYkd44VIrK45NWWns4Phcpw816cwe//2yT9rzo/5P7R96p038/U0/SL9fLIpVgOENxdZbKYEr9TlPfBvdVoR2kXkR08YL7xV2dWs+NjMOdXrO4b9wMZ8MqfUZdOkzXkQbRyhYvVqmxExmtf64RzbadJGMyfEeeE7vL+lJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GxI07Ffp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PY/iwv0t; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GxI07Ffp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PY/iwv0t"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 516E5Nh8028724;
	Thu, 6 Feb 2025 17:50:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=7x6wH9TKkcsuUzS3ll
	PyXaZ0dtY6imkBOtBrPoWI3qU=; b=GxI07Ffp74idOUZ6R7Ps5qObf82JmOa9Rz
	RgDr55VYIDDHbJEMKwR18LUqIqp8sxt7mCJV/PjlDTPVPttM0ycOkFfVFmqKdkMn
	lR1LizMzvDFKuZ4KmS7GQQfEFNRrmizQxkqhoVEMN8IOOV25J3HFPnbnAEilYIjj
	ywKkhXVN5pGvIVC/Rq4LKygvtPnFZfwk+e2ewGBVpaQH3ZbqmIhZWmgofugn+v/h
	W5bY/9ol+iu9My/PWhJ2nA5Ffc+0B1NWyE7qUC6LIK8meZpizoYxjupHATcTlwzz
	07hc+kpKC2ZNrdZUGIzaMeGy8UR1ZY4by0zm5X06tKQuI4G5TC/g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44kku4w48k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Feb 2025 17:50:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 516HNdhY020646;
	Thu, 6 Feb 2025 17:50:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8fs6dc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Feb 2025 17:50:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BpjG0qPxht2JQt8Rc6Jh5W5dpg8B4Xv/w+ONolmCI7u1cH6F2YHjpCuE6F0ha7FkVVuruDQHlk0bs92J7KmUHiZo6maEOtY5CULvs3jxEMjAd5g5RqWPIbTHKT7Eddb1VzKzDNKEloWRemrbneusGzmNdf2cRFFlLfkzPyg2EsZNfyLGQDoiKRy5i1IlZvUUqB7We2skbbtk7pm0YKfJWbY6FeC4OCWua03nT1NA2y6ujdCjVv0yLwYQgP5K6cjXe5WlqEnkTIHlZTO/8cjNDpootCBU2wi7RZWqwSIWATdb+0U1iy/zSAYDbLz63pVqCoujUpvdmEX+533h/yLMDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7x6wH9TKkcsuUzS3llPyXaZ0dtY6imkBOtBrPoWI3qU=;
 b=PjX8MI39ypv2ACxBKvLoYxSVQ4aZyRTcKBXTLNVqflXuQFVBxvteLOIwQUug1Ydtbv4ntumd1tUoACNYbWt57HsU97qCxmnxMrOg+uO2UCuq8goHRQlX9zEWEudbirxnULuX3RDxt2g/xSsDQn4a4GmuxVYm6nkZ6gprbD4fQwEcKoDTGIA+WdfYIRJMcskq8qLtt1dxHupw9duorXzUMA2Hf3XJwgPg4kwphP4V0YtHjXlg5cloNBBTxGQcpY4Q3VaT76MuPgsy4/3c3Y14aBQ/7LfHX9DwKu7x3X0nYEmNqbrRv1nzLD97ACYEgB8SJBoerHyPYPeZ/Cz4/KGNmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7x6wH9TKkcsuUzS3llPyXaZ0dtY6imkBOtBrPoWI3qU=;
 b=PY/iwv0tkJxQvBcHBdAVF4e5vUek6/qtc820pyPJFJfk10fO5PeotKAeG7Kj9Eih4Ka+MiX7TjPsZNlcjJu9DUCMfIUggL98jz4i3F9IW7DTVF6VIp2JIPOxp9X5W5jnx47tpyy6eUy/3IqYbWRzD/UPy+s/mmCGNRnyI/7cXSc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY8PR10MB7292.namprd10.prod.outlook.com (2603:10b6:930:7a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Thu, 6 Feb
 2025 17:50:05 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8422.010; Thu, 6 Feb 2025
 17:50:05 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Ard
 Biesheuvel <ardb@kernel.org>, dm-devel@lists.linux.dev,
        Mikulas Patocka
 <mpatocka@redhat.com>
Subject: Re: [PATCH] crypto: crct10dif - remove from crypto API
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250206173857.39794-1-ebiggers@kernel.org> (Eric Biggers's
	message of "Thu, 6 Feb 2025 09:38:57 -0800")
Organization: Oracle Corporation
Message-ID: <yq1r04b9d56.fsf@ca-mkp.ca.oracle.com>
References: <20250206173857.39794-1-ebiggers@kernel.org>
Date: Thu, 06 Feb 2025 12:50:02 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0031.prod.exchangelabs.com (2603:10b6:a02:80::44)
 To CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY8PR10MB7292:EE_
X-MS-Office365-Filtering-Correlation-Id: 382c6e21-61e1-48b1-0fed-08dd46d6b065
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vWtky6wibmEvBjexJoZ4yzcfcSTcxZJvXad/9BXA4PFqNFH0X5Iiwv6UVw+H?=
 =?us-ascii?Q?rS+TyARVTzrS4z3GkNwKCyxkzSaok8+EeG9j+IGYrnm0+9AxetDrIlPSLJrD?=
 =?us-ascii?Q?RQDlxlkgIlaN4mmGj6p1VTrR9VrkmwFN34YIbpmFizANZ9lSVEFY+IUqA5yl?=
 =?us-ascii?Q?0iyPwQu6QuIM634JMOnzxwvjbosoijte1IXTviDAXUYIdGi9+xZACxsz1HI9?=
 =?us-ascii?Q?NEW1mITQWBVEHflztOv/yw0OeKkfKsVQIOoS/heXGGa8rW4RKS5DkLMpRlOl?=
 =?us-ascii?Q?Pz6vxY87DUTjoenX6zkXYXWFQUHZND9SIb4JTF+ESubuiYm6AV+I2vrAKeHO?=
 =?us-ascii?Q?ho7eo/RZUMesG7LA7QEZnGOwyfz2y3BW/u/VD7V+z3/ti7MBnSQdbVrjG8tr?=
 =?us-ascii?Q?UY+kSHRA4vxt1xXXpnjkIDVUxoltcTRgYKgD7j/r+hrVls4Vk1sbVtvIaDVL?=
 =?us-ascii?Q?F9ijYFLynocPSUMopms2lsSq5M1v1KhQfQCF3i64e8iazwGKrek70moqfmBn?=
 =?us-ascii?Q?HXMiV0cPMaDfeKdZt1MXO1kI/VmvfS7sxZG6pX6C9gJvGVtBpT3z9bhPPci+?=
 =?us-ascii?Q?YBGJ35q6I95EifGYTRNz7CH+qi46GdTvqn5SwZZvuqH0qFwUmM2V50CFqDGl?=
 =?us-ascii?Q?mSXL0dixkX70iVvubdBCbL3vQdFiC9iRRT50tq5MXddhqz/THfl7d1bepchF?=
 =?us-ascii?Q?Ki9uJu1IDLeiXkOQ73kaPC8bbP5D2+F0yrFxHzv51b1BFtph2wIMpbyRfRXq?=
 =?us-ascii?Q?ephoDonbocRwdM3/07Lg4QPMqfBc7BGRE6Iv0X1+SJ2V4YJcj9nrhAjxkoqq?=
 =?us-ascii?Q?d7pQxWwR40wcdqqTfRvT1FV8+ZfIroRGUgkHRr8n8jUWFUnxLRTWWXMb7Mpu?=
 =?us-ascii?Q?V3xCkxKht+zJWHIkXPCJxTNM0sssvDarp31rILZP5wq+AFWB69dJ/cMojZM/?=
 =?us-ascii?Q?jyHvv795aXRYuAh4er6jF6GZFCRZ8ux7T+R4BlUdm/UvYcQ48TMw75pVccsp?=
 =?us-ascii?Q?TLkDTXORTusy8Wvz+Fo9psB5JuPRbwyZikL2NqZjMd+/wPfdSs9APrApp1IL?=
 =?us-ascii?Q?3JAb9feb7x9Hfmr1veUen7aYPDzAE/JS6p20FPYsFAr2vR6ZpX1prlCd5z47?=
 =?us-ascii?Q?VL4mzGJYlFRKBjSURKwL7MK7+V0B+6alalISGIF7DDBGNVBgP+Zo62Wn4Iz7?=
 =?us-ascii?Q?BLAIlOyWEsqT8FACJocrHxUHLQcS+Fpc8MDap6EI8ZIC6XrNGVg3lsyQuAWR?=
 =?us-ascii?Q?+MHPaap9LDfD1MnOW7mjNLmfwaeemkrmQ8lg58Fi7NyHUYXsEcTUboIy3LrC?=
 =?us-ascii?Q?Shp0OqRd9CsDWJbpxUaVwPO9+jMUqivFWJb1yZYFdtn4s8rl+LoTraY/vmip?=
 =?us-ascii?Q?J9Vo2SX558V9prXnuDYlzReh7GVL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kBP/SSNW46mv7IoBFl/+g1sdfmByC6QnBFOUCVaxPNWxzF8y+jB6nnkcm0on?=
 =?us-ascii?Q?wk+8AbUTxojHVhX1Tnmy+IGpX7XdVcpCAmEBQ+F0KpX334kb1DqepkeGtbm7?=
 =?us-ascii?Q?9aZPa5dE3f6AdpZdb1UCl+XWfE2olRoZRw++MganeoCCLdpeUvJ9j9m+3W0o?=
 =?us-ascii?Q?VUu/3h9OcScJ4zHZs5kKLk0h3FeVVC/d66kbBF2D63cJ5Hbtv3Xfr+H9++rr?=
 =?us-ascii?Q?RJjPCB9amSxq7LiC4ArZk+Po9QypXVPkciaVeHWYXP6ZFq/3ONYzECeZn9MV?=
 =?us-ascii?Q?V2KsT03Vxwbu8z/iav9DwbPkYczZ6i+wVGi2jOIMD2l84RNChQL5IuMr4ZQ1?=
 =?us-ascii?Q?bCwsuZ3wISSEYEcgfiEhDjt0jVAldj0meL0D3n76zW0WbUMfqbvlcXiguUcv?=
 =?us-ascii?Q?M7dRlp2+oIowIM8Np0igsvtF52hIJKhZ4t0s6F7kR/dP9qeN4EPTlF01BLHR?=
 =?us-ascii?Q?kH4gD1Yx+/xl9f6hMt6thrbK687YbE3dC7sTG3zgUH9fF4Z6pt8GOdvd0sig?=
 =?us-ascii?Q?88HLKIakCuzW9k4CPNYvsXbY6Z2i2/aWvJPTtv2RI7omE23CvGNyk8+4cZth?=
 =?us-ascii?Q?5IAnvP00DSv4fgMz2XwdKAYB4IAmi3LEdfai1GBTWHFigyIBVQ2nKAsdr479?=
 =?us-ascii?Q?043AD0h9m6uO10QOyzU0Capjv9eeCCGtmQrs8v7Qd6x5lUQRyTtB8u+YaIj/?=
 =?us-ascii?Q?VR2qeFy99KB92tHm66ZL8fkqd21ShyF4WnPzeNnBJl43XklMXz76+kAZKkkT?=
 =?us-ascii?Q?NEJZYrb28mimozLWSHVHbixGRi7uK4Ab7NxJDdDcMvlLZ8WqBzd6ygryUumG?=
 =?us-ascii?Q?hDlRRkVny45SmcUgpQZcyJrgksc2JqvDUPjGQwYmbsDysaG9ZoESCmWTDwkx?=
 =?us-ascii?Q?WCAg9wQpb6JiPxazqOW6Tiz19sfnuDa7CyMXGxFql56i/18CONYZJgAxHwPN?=
 =?us-ascii?Q?BHgwQFxbpnyb1pfCXhkh5IpHMhUg+5ELYHk76BP+hLNKAqO1bKynEkFWVoam?=
 =?us-ascii?Q?MkamL02gpJKMXbBvY+lW5DL3zTZ/YDUjPLHNPW80kvXeIbio/ma41AnYjvC/?=
 =?us-ascii?Q?2/h7IfV8TlzH5wqdB+esHwdDV4yYyprFIeps+ixd02sjViOLIDZXFPcLIDfw?=
 =?us-ascii?Q?aE5i4xcl1hAjXb7xIyTVUeR1u7EQooNQ0tLVnI9ZRbpqiIjRzskRRrezjGES?=
 =?us-ascii?Q?zPOBUlOm5P4DqoThWsEjYlgHx4gAWGV3HPJxaqQWBd4aU4/QEbUdxo63s3cS?=
 =?us-ascii?Q?Gt1J4gYTDAWhqWb0n0o3o0vZFxj69c45m/HYYMpuimzrEc0j3nDzfpZ4GNXF?=
 =?us-ascii?Q?XyNWh1wTtDm4rWSlkf01H+GJ1nY5GqblaXjPQ25KBnyIviV3ox46SfKjtjID?=
 =?us-ascii?Q?8vf0kZERGOHlyA6k1Cdv+HVJ48Q6jkWi+ySWYb4CQO4lC8n7HeVH5qsa3rnI?=
 =?us-ascii?Q?HNYTzBPRM501zHByBSLbGfK0L4rjh5ojzqbpnyIMk3aB5KxQ157qN/+pZp9A?=
 =?us-ascii?Q?P+wVEoBZ0P18XfXfNF45DVhOKLnJ2JuUqwGSu8E1WUrKBUq9q7LP+LGJlf9j?=
 =?us-ascii?Q?LhU55gWqB9pfHJqjl2qoZPwh3TPF21L0VYDjGouyffF/omsyWeB5Effqv75i?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mslM2+nAIGXIthj6VuFnjGHz4HsDR02iKwW1/bV5MfHS0WJetY0CQ2rdyxMAqFH/YqIiBzoDyzeKrOyPUguXF5I9/jTSoNS+JTS95hpORE5SQSwSzhrNp60RaDzSojlHDZ8wFK7ouj3L50SblLtUqZI9QiazJNMEjvMwwDIoUk5f24h7U33ZXj8Yh2E95bS0AHt/RhoYPzPKjnDlGl4mjBxjN/EJaTGRh6Wur4AdHr0syod5VClKcVSsMrsnY4X5oRPpwvGXFG+h4dQaF6Wl2hmOVNDL+IoMJGZijlSJ8kUqzz6XWvQo7cfLqimkhnWAXxCP5pv9TCYVKb4zGopWSTUP4okC+XB64+rzrvmC9Jfon8x2sQgtlTHwp9c5zZ7jeXeedUvrZYXw0kr0yafnp9nUNtzTggjYm1oas8ePqfY+23WUnG1DDmbjwBjowfXwIOvdriSgQdohFvMHcVtZzJj6IAIiGK1n4ZYcRR6+kQgk4GTYvLJuyj0lR93lr2uLQJaK/IelZ2gGrw9mBFHp9aKPp5A0vGqvz2n15Plcfcpx+F5PjyokcZNfPDytEQNZki6J9J5t0OTXnfKSrQZjc9OAo7tZofJ2WT1fMuptIHs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 382c6e21-61e1-48b1-0fed-08dd46d6b065
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 17:50:05.4000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rjEslxAn2MU5RqYg5Y3feSOP36GQsrMyVW5hYLFJvwOhjUhuyDw32tjGX1p/vyCkQUatulwa8a4OipwvlWw0nsXD2TlTKcXAITVJ8FL5m/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7292
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-06_05,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502060143
X-Proofpoint-GUID: eecbrpMx9dMX7jlsZSlLxwVtERgBDNg2
X-Proofpoint-ORIG-GUID: eecbrpMx9dMX7jlsZSlLxwVtERgBDNg2


Eric,

> Remove the "crct10dif" shash algorithm from the crypto API. It has no
> known user now that the lib is no longer built on top of it. It has no
> remaining references in kernel code. The only other potential users
> would be the usual components that allow specifying arbitrary hash
> algorithms by name, namely AF_ALG and dm-integrity. However there are
> no indications that "crct10dif" is being used with these components.
> Debian Code Search and web searches don't find anything relevant, and
> explicitly grepping the source code of the usual suspects (cryptsetup,
> libell, iwd) finds no matches either. "crc32" and "crc32c" are used in
> a few more places, but that doesn't seem to be the case for
> "crct10dif".

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
