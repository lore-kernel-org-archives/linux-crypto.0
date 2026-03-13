Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBB636BCEB;
	Fri, 13 Mar 2026 15:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773415497; cv=fail; b=g90TsFPtp64ddVXuUy8EtBQi0itQjOwxYnv8/cqnBUjk50jd+WgYz2BO4bJTTXnBqPLJybzjOdUeK3N3tifwjLLbq5sE+CuusCcGteQRNlU2WYxj6HMX+zNCMpp+pk2ZKFG3oOj1yGaeyn/0EAxk1OlZQbu/M1/SmGo9vG8TNwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773415497; c=relaxed/simple;
	bh=WP3BuZIY92ceaw+qhWbJxoBrjmm26k1iAuZTC/YTaHo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=gkdTzmlpiBW1FdLOlZSd4llXMkvg2xafBmYEDdmz7iiCYQ+LBgkXpTlW39fodSdQC2NIQLVb+LVrrCleE5v+KhtphO735kqLtHgKosUwUfDZIelHavq5ISQ6z51BjR3vbl2LbKHmeu9s6jMF/E9fghptCmQyQangh7Agazqi3gw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fnV6GPl0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wlqOXkFC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fnV6GPl0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wlqOXkFC"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62DDnUfi427656;
	Fri, 13 Mar 2026 15:24:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=rfKBXk+lfqNah1pS
	1MKNMSchh9tTo9DYGpMk/+fNYKM=; b=fnV6GPl0JLaWg8QQ+lj4/iwgg0UU3FYA
	yEc9Sm95XLAdi35iK/3b2N21fac2exNaiqZjCIHGXHByMEiDcfgIDFnEc2d9lr3f
	SLu8L4fSDvJ/CouGuYWiV2rJaDeWEzBBvp1x+6B6370K6Xx5WNSfoYQgcBfXM5h+
	K1ca5giMMt/AnU3ur9PkoiXJ4dh6hN9HydgpBFZ/SwV/g9G9viRg6OPUK3GGcm+z
	cCyeOKb3xqvNjAAYNDXSXh00BKJfuFQyw7gp68MTYerIzYO8426NaUhGlQcE5OW0
	spz6b8aLT5/pfJKIHDZPKvYYfKThCawJMk7iSKOLa9B6MALySc7SWQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvg42gfpn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Mar 2026 15:24:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62DEp2c0033033;
	Fri, 13 Mar 2026 15:24:43 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011049.outbound.protection.outlook.com [40.93.194.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cuh5fmw91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Mar 2026 15:24:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hMr+VgTj47OJtLdEzzVmelQTz3v+pXFc0aZKdPT2BlWOcezDXhS9c4g59jkebXQVziagmnoR0TMEeyaGWvSV16Un675gSY3QFpE3rqf3nJyjMvQe2yfHcGgTeH5FZPKknlX6Ve2snjZXKWZO2Q38IJmOQWNRvKF0iYXXzIHRhLMv0zGYTUd4XK/+u0qmRWWm0ZQniG2X7jvhC/xadVh88reHpsy+0K4ARc/7Ug5ORBPmy4FaskPAi6AUKGifp9Z8tTfdUcgzM2Awd8mBGW1h21hLSfmD1lBeo/YCTAWt/qnyquWXXujzxie42ylGbm0dPDsusuFMr03uYiiE7Amrfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rfKBXk+lfqNah1pS1MKNMSchh9tTo9DYGpMk/+fNYKM=;
 b=M0QuvqjE1zJXzlB0b9kMbHQs1pWWBLDXKbuhJS52lSZF50lUnCzioem3+NlM5U4Nffiku98orz8gnTmVS4ok1V3zNgfyzhyieymIXovDMusEq7pLJroDfpUXuJzDbkXw5zPZHpvVfTgH1BSNRklTakDaMPFWSgqBzq/pWmPNAWdkKtK5xRYAZRxBl3hqfjZjycrGTBCYaNWE/GJQv9MxouJb/9opsWF0pqnn/wcb6PpqYN2SgiXfD2YKE1J0nnYe3LWwWcKzeHTdqoGDZ1E11CFMoQ/PSZ+6PxNMjFnu+jecfUGyOzrOChavLjZDj1r7o1N3uXY2tjQc5KOPGdjBIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfKBXk+lfqNah1pS1MKNMSchh9tTo9DYGpMk/+fNYKM=;
 b=wlqOXkFC0UiD1ZYl6siQ5e7fH5ImECNRchS9yxe3B3GPFrucRDOOBbALuSe/I8UvMhha5eeFusi6VDo6ca3Z7YCyUOjcyxMtr8QLpUHylbjcKIHjBO4esh4cUgIoS+lq3GiVVUx/NgOs7v5geIXdQIpZg5u7LZ+MQ4oerP5jSdg=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by MN6PR10MB7443.namprd10.prod.outlook.com (2603:10b6:208:46f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.16; Fri, 13 Mar
 2026 15:24:38 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::854c:c282:c889:45a2]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::854c:c282:c889:45a2%4]) with mapi id 15.20.9700.015; Fri, 13 Mar 2026
 15:24:38 +0000
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH v2] padata: Put CPU offline callback in ONLINE section to allow failure
Date: Fri, 13 Mar 2026 11:24:33 -0400
Message-ID: <20260313152433.504992-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.47.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0050.namprd17.prod.outlook.com
 (2603:10b6:510:325::22) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|MN6PR10MB7443:EE_
X-MS-Office365-Filtering-Correlation-Id: d90381ba-e5b0-4e57-bb6e-08de8114a3d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	45IWSA9k2SKIV6OQ9an+cPwUP2iynINwMsfhdsHsPUGLZNyNpAWAYzTSLB4XeO3mdzKnpmseW5JKxHg7Rxg7Sfpt/rQ919GH1t2ubbaqU5v5BgYeuxT0enPcZePM3ohx+WgVzQYjfzE5ik5V4MPolSC/HEUpbiEAC/DQoR2JVZhjyrwyNSKbM+0bGDigrzYSqzoeQlRdjxmComrBENkJGbi7QrOqtgXvggPd6Xo5GmL4wOO3WvV9qSLKSJ7bP+SNJIYgCCrhznV/iKgoFibqPzfwnJjOBXVqPvdYwRrgiW3S9vt5dCoQ/nTfdDhqQMHyc76IIkgvBE3UKXBDRma90lkuusCxwbU7ZT+Ge9/cOxVet0+7KJURlzrzglrqxVPBwo7C+aUJR6zF8f7C63ddaKs/SKNefPE3KIRLht978AKn8//AjdVorAVlqEItt+g+zeMmripIGad56raMdX7vLgcw6TBJHn3VOGxA0gqEBHjBn1O5CMQpU5a9oQ9vdCbZ4DrSbCAE4xUlWDgz8YSBiuZTs1B8uT8dtmDI7ovJjTSiQQMe3UMYPLBVZyJUyngZvbSADL5K2mKmJEP0qoEreWgIjXlz64fXFgg4sk7b9n/fE/bwD0P2oCJbAmz72EMQe7KyxICXHGnCQantJOzpBLOO1ZN+aBKlAyruhCXZLDZ1QstWrbK7/8qTy8ttNG9i
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SNVTNEsBq855LdJ+6MLjcG099rYcOof/WDkbsj6WKn+ybh5SEDgPKRkEc0mj?=
 =?us-ascii?Q?13BhkbWwZB4IaGLrPIJnrdJ5EVOHF0oPxIZBKyINqrRcTUvI2DG9Swr+LV4a?=
 =?us-ascii?Q?Cc+821VfR9oqteX60tHwP/qtuGLU5p8rLac8WWSOo9ybEi25OPHJW9UczkJs?=
 =?us-ascii?Q?gDIj7KufTUYLwGHefGftJS/vFly5vvr4doBJrp2sUEHV7fLYDc1Muc7ZFhRj?=
 =?us-ascii?Q?2EtnrXOzFMO2xFYbOv8BGyTtxuKYrEF1bzFJgrXqwodqo1PRmZ2XerJNM2xU?=
 =?us-ascii?Q?E46l2ESusB5NxmJYELNEf6BzZA5MaFjHdwbLmF2NSyDjRnL42FC+Rah4vrhZ?=
 =?us-ascii?Q?5cMbO62D8s3O+OkvFHn6mnbMLMOSeb6RONIIExSaLsUND9W4RwPoDt6p4elB?=
 =?us-ascii?Q?fNs7AjKptDB068/5I3MWEuwnZusl2kcwMgcUokIheAStrAIPGS2gyyJQ5P/0?=
 =?us-ascii?Q?k2ycpAAgQ05xb3Jk/NMiemA+qEh9nRdfv8+Sq5CMZ/SIhxAQG8GqkvN3IiZm?=
 =?us-ascii?Q?/5FX8eXQXyA5FLhaE5bGqs5C7GNGwfYxQIQ9NF6OoH12KndsZVUCuc0Bpc/Y?=
 =?us-ascii?Q?kv7ENfphWkI32tUqtXgMk7dpQD/UKjnwlg2XJzb/R8SjdSjUByS36/ywHgSO?=
 =?us-ascii?Q?2Vpw4B/y/Yh7p4fv7KuRk4oAdn026zzRrAmIlSpAKIS4OQg9uNh/etVGKVPC?=
 =?us-ascii?Q?CRgE45n7lzCITMHyUfR9q30Voe4brtsjQ62v775ncIR/4p+yQpYpuC6XURkj?=
 =?us-ascii?Q?mLtDJiervKeeh2pX11yxMExazpAjCIKF8LsydXx634Ci+HyZ/onEcbU0j8re?=
 =?us-ascii?Q?mxJENAqq4fg3Cs3dMtX1VIZWtxvzoaMcYGTRJ2Xgip1xFSSfroEC5m2RpQZu?=
 =?us-ascii?Q?vURe8isqGsVl2P+SY1qE1vR15OXhcDFI1UpOtKTKvLbz4l9fgh7+0ffHAwRZ?=
 =?us-ascii?Q?kxDzyZC1WHxjuMCBRMXwUS0nFzFMlTkAOKesKxigJpaisjv2enqSmdmli2Jj?=
 =?us-ascii?Q?LmkKiC5ELiqfx/A79zbirZigw47GBvL8FPrOeS4VAwla1r6bbyMMywJGgcgI?=
 =?us-ascii?Q?rJDcxKf8eeeTlLSExFYjhFwAQIxYNeF4mysYd+hrNDLCAL1niUgYUCiMK991?=
 =?us-ascii?Q?y0WChke2Jf0FQyXBf0WvGmvOvBpz483LUTqblruyszHSQwQzZtE5Z76IlzvD?=
 =?us-ascii?Q?OuI4JJKHWg4ZemekUnUeCRsIoRfQ1AmMKp+SNQAgmMrYUdYsXYcarZv3S7V1?=
 =?us-ascii?Q?w4V5OI6MHXFlaKpI2fMx2kctNOVQpTfAMnMbwgnxhM7A7NQ1FyOUL3JUsChg?=
 =?us-ascii?Q?CBye7MKAb42uFXlHTcJsQfhGWjUuL1a/r9KOUXVlP5FLxfobNkicISD8sAbI?=
 =?us-ascii?Q?DPXQdSkbiduRPk2UqTP/QSx3cN4HxY87y5wnLctd/BuQt7MPlyV638i2vx9A?=
 =?us-ascii?Q?mQiy+Nnw9dSrxLkxRCLnbDhhJM7pflBqRU96NuCbbzOLnf7RTg4hyuR44tAU?=
 =?us-ascii?Q?HCOqT0snu4N8Mu91SsVmsu2zg7HCPWPoKiL8FPFpXd9M6vj57hamPBizKd+r?=
 =?us-ascii?Q?sk0KH0GrfoEQgJQBZeg0z4JxxJKkKR39Ed7+mkfbEgCQhrpUpJkSvvMFm7V/?=
 =?us-ascii?Q?DdZtwyJnp50trnU0lFXtfpQYrhaRDIu56a1hFyDmhonuLCoyBj/krweGQDYG?=
 =?us-ascii?Q?6zSr8DENF+Uk2P+/jWgMYt2LducCHDNpXQCm0VrcSifiUTMjEed8IHhGKtWF?=
 =?us-ascii?Q?bd74pp1vhk4bGP/VBlCRHLf5f+lOkTg=3D?=
X-Exchange-RoutingPolicyChecked:
	FKIR/1aD1eNDp8Ea2iGqgisoYmk7g2/YUw40HZ9e4eI6rGIcknMLM4cWRkGwZzLZOPwh5zg1g90yZfPFOa7255o5qGSKWHPasg+GDF+HdpMqkz5fh7dMESXFAgxhutcp8cKJiFWwd0Bkj/wLYI2EjuxFKTwd3A82zDBSmd3OSuaxMhO1mMV6l+bsM4Lk1RDzfFWvE3m2tFTxRk+eMvj5hsT5+pOPnW2cTYMzB49Dg40VPI+svpCHnyGrKMXckAhw0pykcqdpL+zRnlFFbW6te8ySKHqpnm81DUKLDuBEACwZwakabOBVN8YgjzjThISJkBOmTKm6nB5fjRXH0ZWwWQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hmhRfDnsELmdYpYawK7QiR4pGxbHzNiK7uH2EKACO/jwpSSfdNEFXtDar18EG/ZWP826ng8U65ThI3Uy60c0MLbP/2f7U/ua2t7SCtcL7ewB6rQwaLnH1YcR9Bht4vke9FlgtZ3dXw3ssk8MkK1wia30nSgevp3EPTpRPcRdZnfonvzF7tAS4/R1o9xWBTxvt5J/bFK8un9JZfBBdqe6ds6l1UEMcEsngqIa9vy58bC587MbKy1Xdvgepw2F67oF5zfp0jLxeN2LCM1jmxuOA63LUsClYv+qLf0rwKjtXuMgyEnhV+6tQNLWrsgNo/TtGGRZ5U040O8RutZ9Oogg0fW5qZeJMM2CptGoKLaxJ5R2n/iw8IP0reCex9LAdOhepisjGdIEvqm4u+RXFy2rcKPgaIRJHTHeNlO35a/pVCQ8ZON6BIQdIYdD9fQckk8zxUtugeTYQkQR6cSBcLJzPaafCFEZrsj7iIgPNMWQFe/mVnizK2ryP2DDzLRbLgL9+hUINxzpp/0jOzZPajNoWR6Aye3179/rThz6wUm5X8guHaMk5YTzW1Vw/xGr1KZhHpeFf3uL/bSDuFH5E4hz1PYAYcpjSmu7JVahA+xCTEM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d90381ba-e5b0-4e57-bb6e-08de8114a3d6
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 15:24:38.4170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aMvuDjwmCllzR4/1yFDfx66Og6GbQ5EvOrKZww8WFpTTjdcaPVwTbr+Lz6qw7EUrn35cXPpbOIL8Y0S0azTQakaJr1765OKAKupDoOF5CRY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7443
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603130123
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEzMDEyMiBTYWx0ZWRfX6wYMWR7QEy+r
 XVm2S51Urb42EeA4TmK7IWdLUmsddy9LWcJ8GE8UtVdt0RXohXeW8mVPSbx4DunforZ5lVFMYpV
 80oudYICfiIhY4Mvg0hNtTK9h0koZmYaTNOP9egSM+4dS8jwGJk+9n8oNTDoDjZefZ5//cEZaMY
 ph5tVj19SYv9ehx3j5U+g1KAI5hjKreyJuGa1qW0aSPMKLICOmDl7cdA1CiCWq+fMmci0sn85U8
 yOBlkCQ592Tt8hEG3sXPv+SkIme8nNXfy/RU4gQFhmGUXInLhHRSE8bMA3b0DKlgUeA7duZD7hF
 Vn88srkfT7EL7YNPvbihBF9SKu1uM11PYqkp7vnsETWN1yr4T/I0wJ70AYV+vaIAoLMj8NoH9A4
 0e7riPT/WzZn0Yq2x70BfdyY0/UoWYmTwegO0cXEHik5gVQVT03ovKA8rkMlvu7t9aANSP4h3Wt
 2EiO8CKk/eeTIzxXUqQ==
X-Proofpoint-GUID: 9Z8KQ4cKCqnsNRkeqgfnfSNQvpAtOlr4
X-Proofpoint-ORIG-GUID: 9Z8KQ4cKCqnsNRkeqgfnfSNQvpAtOlr4
X-Authority-Analysis: v=2.4 cv=T5eBjvKQ c=1 sm=1 tr=0 ts=69b42c3c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=968KyxNXAAAA:8
 a=hSkVLCK3AAAA:8 a=yPCof4ZbAAAA:8 a=NzLmr5z_Duu4r8SRS8sA:9
 a=cQPPKAXgyycSBL8etih5:22

syzbot reported the following warning:

    DEAD callback error for CPU1
    WARNING: kernel/cpu.c:1463 at _cpu_down+0x759/0x1020 kernel/cpu.c:1463, CPU#0: syz.0.1960/14614

at commit 4ae12d8bd9a8 ("Merge tag 'kbuild-fixes-7.0-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kbuild/linux")
which tglx traced to padata_cpu_dead() given it's the only
sub-CPUHP_TEARDOWN_CPU callback that returns an error.

Failure isn't allowed in hotplug states before CPUHP_TEARDOWN_CPU
so move the CPU offline callback to the ONLINE section where failure is
possible.

Fixes: 894c9ef9780c ("padata: validate cpumask without removed CPU during offline")
Reported-by: syzbot+123e1b70473ce213f3af@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69af0a05.050a0220.310d8.002f.GAE@google.com/
Debugged-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---

v2
 - Use non-atomic __cpumask_clear_cpu

Applies to cryptodev-2.6 but not mainline since it requires
    https://lore.kernel.org/all/20260226080703.3157990-1-zhouchuyi@bytedance.com/

 include/linux/cpuhotplug.h |   1 -
 include/linux/padata.h     |   8 +--
 kernel/padata.c            | 120 +++++++++++++++++++------------------
 3 files changed, 65 insertions(+), 64 deletions(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 62cd7b35a29c9..22ba327ec2278 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -92,7 +92,6 @@ enum cpuhp_state {
 	CPUHP_NET_DEV_DEAD,
 	CPUHP_IOMMU_IOVA_DEAD,
 	CPUHP_AP_ARM_CACHE_B15_RAC_DEAD,
-	CPUHP_PADATA_DEAD,
 	CPUHP_AP_DTPM_CPU_DEAD,
 	CPUHP_RANDOM_PREPARE,
 	CPUHP_WORKQUEUE_PREP,
diff --git a/include/linux/padata.h b/include/linux/padata.h
index 765f2778e264a..b6232bea6edf5 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -149,23 +149,23 @@ struct padata_mt_job {
 /**
  * struct padata_instance - The overall control structure.
  *
- * @cpu_online_node: Linkage for CPU online callback.
- * @cpu_dead_node: Linkage for CPU offline callback.
+ * @cpuhp_node: Linkage for CPU hotplug callbacks.
  * @parallel_wq: The workqueue used for parallel work.
  * @serial_wq: The workqueue used for serial work.
  * @pslist: List of padata_shell objects attached to this instance.
  * @cpumask: User supplied cpumasks for parallel and serial works.
+ * @validate_cpumask: Internal cpumask used to validate @cpumask during hotplug.
  * @kobj: padata instance kernel object.
  * @lock: padata instance lock.
  * @flags: padata flags.
  */
 struct padata_instance {
-	struct hlist_node		cpu_online_node;
-	struct hlist_node		cpu_dead_node;
+	struct hlist_node		cpuhp_node;
 	struct workqueue_struct		*parallel_wq;
 	struct workqueue_struct		*serial_wq;
 	struct list_head		pslist;
 	struct padata_cpumask		cpumask;
+	cpumask_var_t			validate_cpumask;
 	struct kobject                   kobj;
 	struct mutex			 lock;
 	u8				 flags;
diff --git a/kernel/padata.c b/kernel/padata.c
index 9e7cfa5ed55bc..0d3ea1b68b1f7 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -535,7 +535,8 @@ static void padata_init_reorder_list(struct parallel_data *pd)
 }
 
 /* Allocate and initialize the internal cpumask dependend resources. */
-static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
+static struct parallel_data *padata_alloc_pd(struct padata_shell *ps,
+					     int offlining_cpu)
 {
 	struct padata_instance *pinst = ps->pinst;
 	struct parallel_data *pd;
@@ -561,6 +562,10 @@ static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
 
 	cpumask_and(pd->cpumask.pcpu, pinst->cpumask.pcpu, cpu_online_mask);
 	cpumask_and(pd->cpumask.cbcpu, pinst->cpumask.cbcpu, cpu_online_mask);
+	if (offlining_cpu >= 0) {
+		__cpumask_clear_cpu(offlining_cpu, pd->cpumask.pcpu);
+		__cpumask_clear_cpu(offlining_cpu, pd->cpumask.cbcpu);
+	}
 
 	padata_init_reorder_list(pd);
 	padata_init_squeues(pd);
@@ -607,11 +612,11 @@ static void __padata_stop(struct padata_instance *pinst)
 }
 
 /* Replace the internal control structure with a new one. */
-static int padata_replace_one(struct padata_shell *ps)
+static int padata_replace_one(struct padata_shell *ps, int offlining_cpu)
 {
 	struct parallel_data *pd_new;
 
-	pd_new = padata_alloc_pd(ps);
+	pd_new = padata_alloc_pd(ps, offlining_cpu);
 	if (!pd_new)
 		return -ENOMEM;
 
@@ -621,7 +626,7 @@ static int padata_replace_one(struct padata_shell *ps)
 	return 0;
 }
 
-static int padata_replace(struct padata_instance *pinst)
+static int padata_replace(struct padata_instance *pinst, int offlining_cpu)
 {
 	struct padata_shell *ps;
 	int err = 0;
@@ -629,7 +634,7 @@ static int padata_replace(struct padata_instance *pinst)
 	pinst->flags |= PADATA_RESET;
 
 	list_for_each_entry(ps, &pinst->pslist, list) {
-		err = padata_replace_one(ps);
+		err = padata_replace_one(ps, offlining_cpu);
 		if (err)
 			break;
 	}
@@ -646,9 +651,21 @@ static int padata_replace(struct padata_instance *pinst)
 
 /* If cpumask contains no active cpu, we mark the instance as invalid. */
 static bool padata_validate_cpumask(struct padata_instance *pinst,
-				    const struct cpumask *cpumask)
+				    const struct cpumask *cpumask,
+				    int offlining_cpu)
 {
-	if (!cpumask_intersects(cpumask, cpu_online_mask)) {
+	cpumask_copy(pinst->validate_cpumask, cpu_online_mask);
+
+	/*
+	 * @offlining_cpu is still in cpu_online_mask, so remove it here for
+	 * validation.  Using a sub-CPUHP_TEARDOWN_CPU hotplug state where
+	 * @offlining_cpu wouldn't be in the online mask doesn't work because
+	 * padata_cpu_offline() can fail but such a state doesn't allow failure.
+	 */
+	if (offlining_cpu >= 0)
+		__cpumask_clear_cpu(offlining_cpu, pinst->validate_cpumask);
+
+	if (!cpumask_intersects(cpumask, pinst->validate_cpumask)) {
 		pinst->flags |= PADATA_INVALID;
 		return false;
 	}
@@ -664,13 +681,13 @@ static int __padata_set_cpumasks(struct padata_instance *pinst,
 	int valid;
 	int err;
 
-	valid = padata_validate_cpumask(pinst, pcpumask);
+	valid = padata_validate_cpumask(pinst, pcpumask, -1);
 	if (!valid) {
 		__padata_stop(pinst);
 		goto out_replace;
 	}
 
-	valid = padata_validate_cpumask(pinst, cbcpumask);
+	valid = padata_validate_cpumask(pinst, cbcpumask, -1);
 	if (!valid)
 		__padata_stop(pinst);
 
@@ -678,7 +695,7 @@ static int __padata_set_cpumasks(struct padata_instance *pinst,
 	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
 	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
 
-	err = padata_setup_cpumasks(pinst) ?: padata_replace(pinst);
+	err = padata_setup_cpumasks(pinst) ?: padata_replace(pinst, -1);
 
 	if (valid)
 		__padata_start(pinst);
@@ -730,26 +747,6 @@ EXPORT_SYMBOL(padata_set_cpumask);
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
-{
-	int err = padata_replace(pinst);
-
-	if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu) &&
-	    padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
-		__padata_start(pinst);
-
-	return err;
-}
-
-static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
-{
-	if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
-	    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
-		__padata_stop(pinst);
-
-	return padata_replace(pinst);
-}
-
 static inline int pinst_has_cpu(struct padata_instance *pinst, int cpu)
 {
 	return cpumask_test_cpu(cpu, pinst->cpumask.pcpu) ||
@@ -761,27 +758,39 @@ static int padata_cpu_online(unsigned int cpu, struct hlist_node *node)
 	struct padata_instance *pinst;
 	int ret;
 
-	pinst = hlist_entry_safe(node, struct padata_instance, cpu_online_node);
+	pinst = hlist_entry_safe(node, struct padata_instance, cpuhp_node);
 	if (!pinst_has_cpu(pinst, cpu))
 		return 0;
 
 	mutex_lock(&pinst->lock);
-	ret = __padata_add_cpu(pinst, cpu);
+
+	ret = padata_replace(pinst, -1);
+
+	if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu, -1) &&
+	    padata_validate_cpumask(pinst, pinst->cpumask.cbcpu, -1))
+		__padata_start(pinst);
+
 	mutex_unlock(&pinst->lock);
 	return ret;
 }
 
-static int padata_cpu_dead(unsigned int cpu, struct hlist_node *node)
+static int padata_cpu_offline(unsigned int cpu, struct hlist_node *node)
 {
 	struct padata_instance *pinst;
 	int ret;
 
-	pinst = hlist_entry_safe(node, struct padata_instance, cpu_dead_node);
+	pinst = hlist_entry_safe(node, struct padata_instance, cpuhp_node);
 	if (!pinst_has_cpu(pinst, cpu))
 		return 0;
 
 	mutex_lock(&pinst->lock);
-	ret = __padata_remove_cpu(pinst, cpu);
+
+	if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu, cpu) ||
+	    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu, cpu))
+		__padata_stop(pinst);
+
+	ret = padata_replace(pinst, cpu);
+
 	mutex_unlock(&pinst->lock);
 	return ret;
 }
@@ -792,15 +801,14 @@ static enum cpuhp_state hp_online;
 static void __padata_free(struct padata_instance *pinst)
 {
 #ifdef CONFIG_HOTPLUG_CPU
-	cpuhp_state_remove_instance_nocalls(CPUHP_PADATA_DEAD,
-					    &pinst->cpu_dead_node);
-	cpuhp_state_remove_instance_nocalls(hp_online, &pinst->cpu_online_node);
+	cpuhp_state_remove_instance_nocalls(hp_online, &pinst->cpuhp_node);
 #endif
 
 	WARN_ON(!list_empty(&pinst->pslist));
 
 	free_cpumask_var(pinst->cpumask.pcpu);
 	free_cpumask_var(pinst->cpumask.cbcpu);
+	free_cpumask_var(pinst->validate_cpumask);
 	destroy_workqueue(pinst->serial_wq);
 	destroy_workqueue(pinst->parallel_wq);
 	kfree(pinst);
@@ -961,10 +969,10 @@ struct padata_instance *padata_alloc(const char *name)
 
 	if (!alloc_cpumask_var(&pinst->cpumask.pcpu, GFP_KERNEL))
 		goto err_free_serial_wq;
-	if (!alloc_cpumask_var(&pinst->cpumask.cbcpu, GFP_KERNEL)) {
-		free_cpumask_var(pinst->cpumask.pcpu);
-		goto err_free_serial_wq;
-	}
+	if (!alloc_cpumask_var(&pinst->cpumask.cbcpu, GFP_KERNEL))
+		goto err_free_p_mask;
+	if (!alloc_cpumask_var(&pinst->validate_cpumask, GFP_KERNEL))
+		goto err_free_cb_mask;
 
 	INIT_LIST_HEAD(&pinst->pslist);
 
@@ -972,7 +980,7 @@ struct padata_instance *padata_alloc(const char *name)
 	cpumask_copy(pinst->cpumask.cbcpu, cpu_possible_mask);
 
 	if (padata_setup_cpumasks(pinst))
-		goto err_free_masks;
+		goto err_free_v_mask;
 
 	__padata_start(pinst);
 
@@ -981,18 +989,19 @@ struct padata_instance *padata_alloc(const char *name)
 
 #ifdef CONFIG_HOTPLUG_CPU
 	cpuhp_state_add_instance_nocalls_cpuslocked(hp_online,
-						    &pinst->cpu_online_node);
-	cpuhp_state_add_instance_nocalls_cpuslocked(CPUHP_PADATA_DEAD,
-						    &pinst->cpu_dead_node);
+						    &pinst->cpuhp_node);
 #endif
 
 	cpus_read_unlock();
 
 	return pinst;
 
-err_free_masks:
-	free_cpumask_var(pinst->cpumask.pcpu);
+err_free_v_mask:
+	free_cpumask_var(pinst->validate_cpumask);
+err_free_cb_mask:
 	free_cpumask_var(pinst->cpumask.cbcpu);
+err_free_p_mask:
+	free_cpumask_var(pinst->cpumask.pcpu);
 err_free_serial_wq:
 	destroy_workqueue(pinst->serial_wq);
 err_put_cpus:
@@ -1035,7 +1044,7 @@ struct padata_shell *padata_alloc_shell(struct padata_instance *pinst)
 	ps->pinst = pinst;
 
 	cpus_read_lock();
-	pd = padata_alloc_pd(ps);
+	pd = padata_alloc_pd(ps, -1);
 	cpus_read_unlock();
 
 	if (!pd)
@@ -1084,31 +1093,24 @@ void __init padata_init(void)
 	int ret;
 
 	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "padata:online",
-				      padata_cpu_online, NULL);
+				      padata_cpu_online, padata_cpu_offline);
 	if (ret < 0)
 		goto err;
 	hp_online = ret;
-
-	ret = cpuhp_setup_state_multi(CPUHP_PADATA_DEAD, "padata:dead",
-				      NULL, padata_cpu_dead);
-	if (ret < 0)
-		goto remove_online_state;
 #endif
 
 	possible_cpus = num_possible_cpus();
 	padata_works = kmalloc_objs(struct padata_work, possible_cpus);
 	if (!padata_works)
-		goto remove_dead_state;
+		goto remove_online_state;
 
 	for (i = 0; i < possible_cpus; ++i)
 		list_add(&padata_works[i].pw_list, &padata_free_works);
 
 	return;
 
-remove_dead_state:
-#ifdef CONFIG_HOTPLUG_CPU
-	cpuhp_remove_multi_state(CPUHP_PADATA_DEAD);
 remove_online_state:
+#ifdef CONFIG_HOTPLUG_CPU
 	cpuhp_remove_multi_state(hp_online);
 err:
 #endif
-- 
2.47.3

