Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4961D0E27;
	Thu,  5 Dec 2024 23:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733440030; cv=fail; b=fAr+iRnGI25heiyMk4xmY+NxWD6wbDIhk3H2+PnuX4qRc11DWOM1qK0l5cYxXc4MR3OvXcps3QPHNMcnjd2q0QOllmzt8i9qlaf74/lSiDmO51tUA/6rctyboXg4JWRiyGNnpDpOF+UOqgqExa7a6dL5/kR+78lQAQ9gNWDtpOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733440030; c=relaxed/simple;
	bh=tpzDJr5WZR1QbSYSh6QYjJZnQRUI0fY6gf2mpYIa+Io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KL+jUZo8YilwIqdLSME/oivGmUPdH2A4sfVKEQMI2E1u5aXQ7/oGRFwbO/GeTcSWW64BIhRhDRH9BeOWQPFdgb2t2VC+lIiIsfMUaCNRjWWsvKGDj9AM36vZ6Xb9lVCtC18Bnc7xMh5Auh/41XbF/NCbVEUTj7eT4G39Wllzsq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Fu8o1lPS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=V6aEg/ZM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fu8o1lPS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="V6aEg/ZM"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5LNYLI017866;
	Thu, 5 Dec 2024 23:01:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=CQ7rQig8Vjk5b19Opr
	mb9ypqv8UcL6x3H5cWs81I56Q=; b=Fu8o1lPS1IBTyUGafPenhgEV4gvMABuXu8
	zrzZiXMryD6daecg7MNSwNSl+c0BHVBhct98lf/59mEVGLwKic62qpislJzqrKhA
	z87VHe3cJ/TZZTaKqUTiDc3sdclPxZ2HA12DgaxZHnT+Nay67lz7m4FioqErdJo2
	aJO8oDhwq0hI3c5cYJFW6fK6EWZQrYVnJ8KV0mTO5QmPBmv5l4oe5C1/rOWkZVS5
	1CPy/lH6K8avArhzYNC0NCPZppLEgukJMQKFazAE7e6vabY7eMBxVV2SkLX9eGkD
	OWsw2I1U3zDWB5QW0pJw8DuglidkAzmHvuTf8HD5WciVIX9ec+aw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437sa04ep5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 23:01:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5LxnLO001419;
	Thu, 5 Dec 2024 23:01:48 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2047.outbound.protection.outlook.com [104.47.57.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s5bjbra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 23:01:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vjT+zrbY7YR/nENJJg3SqURWbK4k73OGVR/ms84OpF3N+SOID+10sYNuQ9OT87uiFtw83XI99KdAVsYjZHB3n0DsydGgM/h/64AQp9vehvhjV004yCI18D51YNSUbQP/hTf9FNqaNqgsmPlvwyWU2PM1H6KU/EDBscioiMaECDhhafycUFPHa8ClWbnW45tDCQzCUSNr+IKQHE9bwlo9arAJQJ3wIw7aX2QC9tgiyRZ0Ws8/n6IHz83YbAbWjQF3MCKaFUqiI5ZEUf64Et+w6Hl4knd4rVOsadyaFWHBKOqM67+X7sJqt2RFT6wCLx/qWI8SCkImsPBqJoUK4BVV/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQ7rQig8Vjk5b19Oprmb9ypqv8UcL6x3H5cWs81I56Q=;
 b=JF3NWtd99ju15DxxB4dpIgQ1IAykNkCwOpgd1FUhYIuDJ/Ai2UTtJ5jHTd2EwlBehOEx2pQ3ci24Ffr1XyS9IiJ8SWh1WortrAsmqB/nuIRs8Y4G+HjucvlsOr6SVKXHF8YaJrZ/LDyISOyzOKdcRka3u/Zu5yOfTMJvwvuIoYJwDwm4qxdTJ2XoeLw7iZ24Z8N+NlGvxygbzPdS0UXLOOL58hmrgPyy50u0SYItc1WhrzgCrHi0E4xuZ73IBHOGdnQ/qGt7izMTcKq5QLvrfK8o7OvWav7cjP9mVoqDdtn9jEJJS4nxR2L4fq3gTKV4Y5dJmGJ1eLJ0fvOd8kl/Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQ7rQig8Vjk5b19Oprmb9ypqv8UcL6x3H5cWs81I56Q=;
 b=V6aEg/ZMbs8YMFjpCe8YK4MUPkH4Twc0YR/7xhe+blp5kVeSgeiOdc0/qN6+wzT2vnOwFm1ebqTJHjXIAPNUIxaczOYMYHkAIk0RqtJ+ck9R7yx4k13d29i5wRVRrDq+A/OOBCwKiJqkbUWOjyL1xw2lhxKujaEZGv5UBJt7niM=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by DS7PR10MB5037.namprd10.prod.outlook.com (2603:10b6:5:3a9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Thu, 5 Dec
 2024 23:01:46 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc%5]) with mapi id 15.20.8230.010; Thu, 5 Dec 2024
 23:01:44 +0000
Date: Thu, 5 Dec 2024 18:01:41 -0500
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        chenridong@huawei.com, wangweiyang2@huawei.com
Subject: Re: [PATCH 2/2] padata: fix UAF in padata_reorder
Message-ID: <nihv732hsimy4lfnzspjur4ndal7n3nngrukvr5fx7emgp2jzl@mjz6q5zsswds>
References: <20241123080509.2573987-1-chenridong@huaweicloud.com>
 <20241123080509.2573987-3-chenridong@huaweicloud.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241123080509.2573987-3-chenridong@huaweicloud.com>
X-ClientProxiedBy: BL6PEPF00013E13.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:14) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|DS7PR10MB5037:EE_
X-MS-Office365-Filtering-Correlation-Id: 49e9e129-498b-4d30-53b9-08dd1580c9a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kZD+zDql/JKoOUi0+TZbyA060m5I3PHatAW8JUNOsJlZrHly7kN7nNoMEHns?=
 =?us-ascii?Q?Ps+kdowmPAwocR/MCS8GXCJk/LCjPKhjQnNoK77dJwTwKB3RCDBXjZRrASEd?=
 =?us-ascii?Q?6+gFInND89j8STdmvMgdZd9DFDrpBz1EERAtqOn52wgW+aBiPyvMpow1u40h?=
 =?us-ascii?Q?S6BW/F2KSXzEeSI5mIpyJCSzOsdIHcOa11JlCDU+/LXeq4QkSSOy7qXjUlMg?=
 =?us-ascii?Q?EvbIKQT0AMV9+ox5kSJgeQB49t9AsUoyvFbJkeNWPXDI0mOS4lOAFxQhixZF?=
 =?us-ascii?Q?qufwA9JZJBf76vqbfG0BaLwJBcB3ez6Ohc7xJ5XkRun8apHLu6fHt7othqT2?=
 =?us-ascii?Q?hpXUBdDL4m8hm5y49J+1VQCwnvM7RV/tVy1nuQ33Y47L5vPsnTmX0UKJmOe9?=
 =?us-ascii?Q?as+0HDMVd/dlKowl7LSoLV6juVwK4umzzuPkuQNE32hAvUZI+3Ofh4VpOOVl?=
 =?us-ascii?Q?UOS+4ehaa6oDdvwdmgzKkq/TEzw5yO4GqzwJRXdSR/QDs3xF63PFJ1dIS7Bc?=
 =?us-ascii?Q?H+aQNYYOpoCa7V/PzQ0Nvzb5fVOdEUf2PaDHUMJ/VfnFApHjjBY/k3IxQd4q?=
 =?us-ascii?Q?lwk/xLRcoLuBPNottV14RQsTICnmMGki5j7s6awMdENuemw7NoKOeQ662LeC?=
 =?us-ascii?Q?W4YaRtD/x9kIQkmZdBPF5pPRSR7hiZKofEybfg4F3bZKGrIsIBYLqd5SDNCZ?=
 =?us-ascii?Q?ixTKfqV9jUlWmiDO4ZQ7T3YsH4Kao+PDIlSGKrUuQO59DMWdR948PIpAKhd7?=
 =?us-ascii?Q?Jqw9fL7ihF52CIpfUC7KHssM1lWcIDt27MUIUnWf6TgDlb25WdLnrw7p/UxQ?=
 =?us-ascii?Q?8Fn1p5dgVvVswcXvdnmk+//86FR/P38BQVtbiWL+9neoz1yu4zl9h3cuTDFq?=
 =?us-ascii?Q?Ex9Lo1p7dXWzM22x8YfGavDGPfyBv7fwKOP7O0EeZ65hdC9YGYPimqK3tsB1?=
 =?us-ascii?Q?d2mX1sUYJIMZxmfFVFAKy5lOz9G8Xk4HCeAD1Tp8dRSkK/PXQmXJy2kmD53P?=
 =?us-ascii?Q?WPPZIINwQGkNhbjCClKvfbiYZmxplo5p/7Hwrptl5St52JUUhTkgYkg+ojwi?=
 =?us-ascii?Q?X/enevYf8+2EggPTQHe7aZ3A/zQ+kXLJdKAJ0Z9VzFGqKFzTJBy4wUWQT81C?=
 =?us-ascii?Q?AwCIZBnnyLZlzU9i3avKxrnI0HaXh2O7Jj70Qodwbn1bqrBS69rVxbWoDdS7?=
 =?us-ascii?Q?z13zfLbDoGBSUCJf/1/amJYoquDnlNUJIIY/lX1bGc3Nneg9TU/Lq+xjIPV7?=
 =?us-ascii?Q?5vXdKoZ9r//CuJev9P440czbtkRiGuZihDqsoXsZ5enbuHlAqO22v8KXctD2?=
 =?us-ascii?Q?KPv8+Uy7CTGm5BM3RttxEP98ykI80ZJ/qfdD0toPPidUwQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0WBRCORpVpiNgzUrnTz40WfiGohlaXzHp/Hl7H2JgsrVqa7Ui/RzF7kI+QXI?=
 =?us-ascii?Q?61dxrDflNXCH6byK0wOWieAhEOzhUkpU0cs66hwVfoNKcmKx71Q0nVP/MClB?=
 =?us-ascii?Q?gSmYj+p6CSNIcYNv+zaTCn3ECc+Htbr/t89wsEsdfzdMxToZ7wwh7++pP5jS?=
 =?us-ascii?Q?xNgLhvPJvYqnuN8yAHJ8CWUO4kipsysYVc7mwBnUDdZ0usgvRTWbnaMXuPGb?=
 =?us-ascii?Q?PgHQK+bllHL0gyNKAIJ+kE7ywoaNxSTpiuU0YdL/QXCPH4xeZeNIcF/bBwO8?=
 =?us-ascii?Q?ABeCrHlKBvoHVejms7rFRXofKqHd0+GWtp9Vr0ewZGu4floR6F5XXNOM9UMB?=
 =?us-ascii?Q?5pZlWr31d/I7hJNHbco+8PYFQQnOrxj5qSGnCNCbYPjLQkS6lciSY55cYFB+?=
 =?us-ascii?Q?Leo0Cb6LWMG230IUZxKrSrrRTfrtpAHh2EL9Y2GD6SGmS7LDLkim9F6gzAMA?=
 =?us-ascii?Q?MiJknE+CnMDPXLbPA4ibOmkLb9LvJcdtprKT0rmd8V6cPiOitD9aRJjXZLrh?=
 =?us-ascii?Q?2DMKbqXQniz2Ph5V+GaJyccmnr/lL9N/uHWYpw0e6BLC4NXSDUVwLjzPVFFT?=
 =?us-ascii?Q?c8fbqKuGguKhxGGyFGhVUMf3ZhtunoNVr6hxb/kPXD58O5uTAQ9kitzvEoQX?=
 =?us-ascii?Q?h6u4y/4Jj/6NQpznDmkh4QGPtm8BjctgWYLqgA3vZcAzxs/pvb7XT074XoWN?=
 =?us-ascii?Q?jw68OXbmdW/f6efW6FQ5N1SY4IUmfsfF3OcHfq62u+leB8NXedoWMB4LYH61?=
 =?us-ascii?Q?IX7vpKdwiA8unwAPPUFdklVsxOjX0JZCNVNZu4L7+1sDr6tsWNlmBa0xjgzw?=
 =?us-ascii?Q?mQKjxNlw6fXy/P2yCik1L6ozVy1e/E4Up2kbOyrzK1CH0+/mWuQYw+vQ4ayA?=
 =?us-ascii?Q?sG+Gw274zGqtLnoEDfREJlJI9+OrV92lFLO2J7HANjB00mNKPS3Cxh9lcWaO?=
 =?us-ascii?Q?b6GEAhU78sN77/o+j7dWolRHsalsZSDLmdwgwb9NhuJ7/9rLC8MVIjFcl3op?=
 =?us-ascii?Q?bYc9UgUuiZlt4JKORwUM4Riwgr7vqRdsYNO5G+lW9Sq0ZyoGG4tLqZaSQrr3?=
 =?us-ascii?Q?/iklDP3ls4ZxB/rpMKzvHiIhZAv6xomJ+ch2BDfK+DJDLjE7227z//BOGUB8?=
 =?us-ascii?Q?PJ9lvzpHcXahgyueF5QCv1wmrAvWRrXiWj9Fb/HWkKHgenWnEByF2qnU/iCI?=
 =?us-ascii?Q?XNwF60w1HuXBbTx7t7w92bP5gBw3r8qx61FELDt7vMuhZFfAkfK2/NAyPOf3?=
 =?us-ascii?Q?YIaBqmfCYCClB8XUSXCsLtQ3Eym2/qd1xMXm7sK9cYLifvzVe4ay/1gVPBkZ?=
 =?us-ascii?Q?nIeOc9cq72p5z0QXi1RKXGLDyu3BWe6D85+XjVEiQ3dlE/b1vb+YZdr5oKqc?=
 =?us-ascii?Q?bdj7Y9JlY+v2BOXNx4JG5Kg0E6oTbjdnpvgYsINx7Mgt1+fNFHMDD19shZiI?=
 =?us-ascii?Q?Kp+2KizltByl3afpipSq0hLyFTb0ojcxXt9SpKr7xVkPDZ5tHGJXCNqiRDHN?=
 =?us-ascii?Q?WU0TH+6PmYXUfIBVBqFEF2o3hY6jYbpIP3CpqbxGut80fJHvqEbCcqmvibDI?=
 =?us-ascii?Q?seJOfS61JAdcCFCDrwAdvL6r102eGA4J1qrNcLy/mu+yPX+6IkUYRWfWR/he?=
 =?us-ascii?Q?TQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NwL4HEVKFB82giXJKyWwAHEJoYKaGqWAA5OH4tud0E/Bmsn9Bhy4czReYunk+VnxJ9bMUsudS6vR4nY28DgHgimSq5nKwXoj3HQz15eEr1nHOyJRZ5/4BvbPXO95gYIJZNbX1u8gZ/k8/V6Hd5kUnBvnpcsZeBzJcRKS7V0MANF+0hyqD7P0GFaXM5/DdUVku1fGFYlq+mOs6xFYQGDDUDXiGgD2E1565wtmHeVLN139EtWnwrFB22ZZHp82859hWYZqtC6bgM9mQ8zxq5Su5XJRas78bYdbVC/ON/MxEqTZ55tiVDSqJa7hIVSUTgbWrjMw1NQndvN7UTtailO9WusuUzo69KyZEn4O8zkXcM3yoy2rWVokvqqbdHCVZIlKXJkCmNuBriJrQ+s1tQ1iB8SLp9vaOEdlqoVFTb6lzCdrxEIDw8CImrwGZgCjQN9IqNgf1EGqYiXeM0Ri0RUkfoWl8eHMi2fkQSXF4MVsHG3IMFVYoIGgaqXlTN/xs2/k0XUE+sxI13XgHwEQKJzLCSQq8gwPXBuPSnP3GJxE+zu8QEr8BnDCgdKVT42FMOqiQY+dac/ZGDgu3my1TLRb8TVtqJzLqGuQNLxE1bsNZJo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49e9e129-498b-4d30-53b9-08dd1580c9a2
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 23:01:44.1278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iwpthTR1odwzaLYOB31JBJi18xQ6Bnomn/OJ/fsKxMXHlyoCljDMN0ArOEIZEj0hZyuSXYFj/Sa2V6cII7DmYLwK/hjON2DNlZHktLGP9YY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-05_16,2024-12-05_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412050171
X-Proofpoint-GUID: -0Hr0G2g2hlBAtZTC9egicveSwGBnt2f
X-Proofpoint-ORIG-GUID: -0Hr0G2g2hlBAtZTC9egicveSwGBnt2f

Hello Ridong,

On Sat, Nov 23, 2024 at 08:05:09AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> A bug was found when run ltp test:
...snip...
> This can be explained as bellow:
> 
> pcrypt_aead_encrypt
> ...
> padata_do_parallel
> refcount_inc(&pd->refcnt); // add refcnt
> ...
> padata_do_serial
> padata_reorder // pd
> while (1) {
> padata_find_next(pd, true); // using pd
> queue_work_on
> ...
> padata_serial_worker				crypto_del_alg
> padata_put_pd_cnt // sub refcnt
> 						padata_free_shell
> 						padata_put_pd(ps->pd);
> 						// pd is freed
> // loop again, but pd is freed
> // call padata_find_next, UAF
> }

Thanks for the fix and clear explanation.

> diff --git a/kernel/padata.c b/kernel/padata.c
> index 5d8e18cdcb25..627014825266 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -319,6 +319,7 @@ static void padata_reorder(struct parallel_data *pd)
>  	if (!spin_trylock_bh(&pd->lock))
>  		return;
>  
> +	padata_get_pd(pd);
>  	while (1) {
>  		padata = padata_find_next(pd, true);
>  
> @@ -355,6 +356,7 @@ static void padata_reorder(struct parallel_data *pd)
>  	reorder = per_cpu_ptr(pd->reorder_list, pd->cpu);
>  	if (!list_empty(&reorder->list) && padata_find_next(pd, false))
>  		queue_work(pinst->serial_wq, &pd->reorder_work);
> +	padata_put_pd(pd);

Putting the ref unconditionally here doesn't cover the case where reorder_work
is queued and accesses the freed pd.

The review of patches 3-5 from this series has a potential solution for
this that also keeps some of these refcount operations out of the fast
path:

    https://lore.kernel.org/all/20221019083708.27138-1-nstange@suse.de/
