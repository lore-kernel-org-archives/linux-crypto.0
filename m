Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39D537107C
	for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 02:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772072769; cv=fail; b=BJng1mfaCf2ERozUgZT0gZ5yyyJA9DLln8rGvDnez2SzcaAFJPxACZhwSkYXO7Tzfe9tfe/Y9DjN4aMZ+qbNf8ENBDyO9G+yiiZ+3Z83f7EIYT0qtBv9C+CglY0z67h4+c2qUViMSxK+RoUX+RaiposjDlxObtdXPaGQmLobvEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772072769; c=relaxed/simple;
	bh=Pfr9DGYNlzeTGHFKJ5ZGKbllBUJW1HGTTN15udS0hFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NVwBuWYCFb179VPZMowIQ4Fi3yWdrrVfyCzOYM9Vu0a37ZyL+BWZMGPimCgEnYWzZbd/6tDBs8KHCmoT3yMvX3ffZixlxxx8CfUVzejEwA/ubnqcHhaFAwbyy+3ozzk1lDnQ+PqocvItEGbNGWA7TM3uz+mTi9VM/os4vs2OYsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T8jBhu4A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m1YFhHSK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T8jBhu4A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m1YFhHSK"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PNvR5Y2724818;
	Thu, 26 Feb 2026 02:25:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=uRkzW93K5OsVeHijGp
	Qn10c7kBr9GClfgVbkj7JAgLo=; b=T8jBhu4AtMRTa1OmZyyFq56sumSCZsuOw+
	2ASlQUtVJA3zhjL7jEHXQPPmrWU2kNmLvavMPD+abfehJlJaiYyOMCKRRm3TSLrS
	fNT2yvbE8+S9hGVoaBnUhVlKga5Q+juAW+SggbIWeda8F5JT0taBOXCEvy9mLL0M
	FJdJVNhAXsa+ZF4TMm2a61asx2no5q/1LZQx0TykfsF+0CZ1dwncxxq+XiMqV+1k
	h1RrYc3e82JT9Xr1mnH6Wxr1/j5X7SzjZ+mX2Mjg7SXvGeR5rjlxFtLgfhspNbwE
	Z5NXKeB6jqiyyDUGzzzMNToP2HCHH0AaWnU9VRIDwmhePM4DhDew==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3a07jv5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 02:25:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61Q25iWF006261;
	Thu, 26 Feb 2026 02:25:47 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010013.outbound.protection.outlook.com [52.101.85.13])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35c534k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 02:25:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AO1XjyZ6G4xv0YFzBdePULAd2Awzq06UzG2HTFW+mD1Kam1viCdLKi4eCz0XAvZ+HwFMzxWE4Bwylw5Dnk9nPjUfOssCVgxjdGJrawWmCky1chXSsmvifoPAmyyo5Na9YR9T9lLpVzl/slqJpdg39RaR0laDmjL1ZG7gJ0xvMLXmEJtR8dCsHU3R8VAXvo3TG7cTS4erKDntG4Cg9RA/tM6bvenBRQ/i3cN215YVO7il70iW511DsaONa/+QN22r4c1ZlCklihddtYwMmSkoSUKEUQ2elZE4+xBAw/ZT7q4oqOutAph1dgHGHo9R53VoZzD/UCezY4xbG6nvwOTw8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRkzW93K5OsVeHijGpQn10c7kBr9GClfgVbkj7JAgLo=;
 b=yxwRaDKvWjoLl8/nmxnjhNb/8HY9pnMHlKqcUUiu/aznTdi+pmdi0ciThzCtzNm/g75/lvwXKe1TeK0eNLfbXfCVoNpP5WrE2j4iLoYFnJazLtul73kIChmqTJMoGx39Zs9lJ/FOnwObOuMH6f0g7nAMNxAjg5+CkTD55x8izEGLad68ckkvqoNkRNzlTpV9su5Av6hnsfelQh6KHOmyQtEhcGALi/kBo9hX+bCj9KwqTDt+KNvrkZfOmGO74awCvhR3JkJhlAR7XivPhJwg2Ght8JwJ8NHK9opfzujzzDi788s67xbFChsekdViJrnozJ4NiCVh+IJ19ZHXYjndGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRkzW93K5OsVeHijGpQn10c7kBr9GClfgVbkj7JAgLo=;
 b=m1YFhHSKtBmPrqCPEYE3Gx1qI9WDvWyZNeOC1Hmfk7ZYjY/jxzZ9a3sqSUp2SFdy3N77bOpSeGypwWzCOMxqs7D8kRTvbuGfWEQB335P01uCOYaAG5nFzz7kSwK87v6YH6MnK/5BDFWLTHRcyIelpb64Wr/7P6ER9RKWORgm4AA=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by MW6PR10MB7550.namprd10.prod.outlook.com (2603:10b6:303:240::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 02:25:43 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::854c:c282:c889:45a2]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::854c:c282:c889:45a2%4]) with mapi id 15.20.9632.017; Thu, 26 Feb 2026
 02:25:43 +0000
Date: Wed, 25 Feb 2026 21:25:36 -0500
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Chuyi Zhou <zhouchuyi@bytedance.com>
Cc: herbert@gondor.apana.org.au, steffen.klassert@secunet.com,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] padata: Remove cpu online check from cpu add and removal
Message-ID: <aZ-trNKwNEribGQU@dmjordan-vm.corpdevsubnet.oravirtteamphx.oraclevcn.com>
References: <20260210153922.3435735-1-zhouchuyi@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210153922.3435735-1-zhouchuyi@bytedance.com>
X-ClientProxiedBy: PH7P220CA0153.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:33b::15) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|MW6PR10MB7550:EE_
X-MS-Office365-Filtering-Correlation-Id: 271450ed-0231-475e-c866-08de74de5738
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	Q2uWXFuyEMoEZ/bw6515a10czuDRza9GzF0fmDKZ/FWLXvYLVhwdds3eFdc74ho2NzW6D2+jaEV1ODCgAsKN3Saa1yX2lDOL/SdnM/fkZ/YObUoSEYARaB0GOLiYe5pZmcv9jZw9zR6Rynl5pupF5YJ4QnQhYzdh98pPCuIZQgWugK3xI4T5vIUeNSb5wYaNf9pYLZs+h2id6xhhNb6QiygVOQqT/1/Y2YHZ6XhXVndk54tXcIvlthc5riHoH6SbTFgU9PWxwEjtau6ZZ05WYUa+cp+1OJnDVmCyEv1tSt3Vc5VsgLJTc/zJENy5WtH3y18T4uZV647CXd1dv8pI36qhy4FULuRnsCnUs+BqRRAJ+UicmaY2EZWN/csl6QevYbJZDkWNvkYVDK0LAnB3LoLsmo+ObTTI7ct9OkxX1R6Dh+jo/wdFg1ZJSiO5d0M0nlnqtT5rsjysfDsqeZivNwtzycn5wnJstcZ4cwF3nyLPnwqDxU9+QAAMw3N5Kjp2t3AJIpPAwkwolJwphbuo6eCHrD+9R9yvafEerv2OQLZdjbRdRtd0RoXaal65tAHM0FKv0gmRnRerbzYIcdVfxoXjJeLPfiImcmUSr/CncS0q5SgDTNkhmHxGeDEHhV1x8SH7p+fNnvtEMFJmZhQjo9Ay9hEk7Twn7r+6CXK39sOK4ug51U2tHgMWjvD1Aw3dsmAhwO3N3HDyWrgh3TjuXxWPCZ4nsztzpk9fyAvKJv4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t2t04Pw0nNWchScvmtweLD6FpBRBaoG3xcrjWFAfVJ8+mqpCeUeERIgr81vd?=
 =?us-ascii?Q?9myY6Vp5nge1TfhedlkIwbGkb9oc1b4rwmjbglK5gA9hI5OuBoXxrYGPBb24?=
 =?us-ascii?Q?BVtPqsJVrAYGplhcMjZI/YvVnbOUjqmvrrs0XNMZ3YPDPo673RFi7DnpHEHh?=
 =?us-ascii?Q?9W0fOqgqXh0fK1iwsd+8hvK+vmInYfyQCZYYGfeTlXJDJ28FMWvF4FeUjEiM?=
 =?us-ascii?Q?YSgOhpmRQ63HdnPzeh8mrrb45EAruflIVYeK/FbhvB/Wj0XuTGc/lUSqykbZ?=
 =?us-ascii?Q?uvKdCjIKqfHUUOPJORwUPsLSVSBwWi0Q+m4ajhLgJH2B1FoHpZyMX1L9xfHp?=
 =?us-ascii?Q?iXoHXn5hoel12xpB0zjmO8owV5UDqZZJ9IsOE4l2HYbty1dQ8RJ3JBN8acfQ?=
 =?us-ascii?Q?VdWxrLffq3zBX+EqZQJQGtbcGf9jJx5IFLKWTYGFLaqwNxs/bztg71Y46L5a?=
 =?us-ascii?Q?67cyuNItq9EQFTkri1hFESlbFq/rb3pS/2UgPRykMjfsQic81yZTDw2fMxjK?=
 =?us-ascii?Q?age1A/cZNRwEg9+azMxO6n2DFEW+9kU9zvfOaeMGG2rO0dVFfONIYwc2YrkX?=
 =?us-ascii?Q?N/z6Dyc7cuygvgLb/I8J912KwXcu2UQGjTgVtejq57jp9DiWDoMEDL88XZn7?=
 =?us-ascii?Q?5jWNx6/fJaXiw440jNVLw422lww97qu8z+W1F04OgClj3ndLWonfFUmrGgw/?=
 =?us-ascii?Q?3al38IfOLqro1Ux1aRMun6sGXaPgmALi2ZnMgj5Vj0dSJ+1SVy9ZOivTFVJ6?=
 =?us-ascii?Q?pl7/uwtdvY00Tigq5ty8EeuE6H06oOFAD5GZDKmec7J6mJor+DwFrqXBHF1g?=
 =?us-ascii?Q?TEkZNDshllcNrdJYQKZvgFVtLau+Zw5utzeiH7oIgj3ugcbX72zIRudeVgmv?=
 =?us-ascii?Q?dYiJcaNVhQh+DJYnTGmZSt3xVwl5Su4XYztaSxCimZMk0Mi0tSII3RiefN4v?=
 =?us-ascii?Q?jqQ8ladOEXoI2tSNGbvg90e8niN8+DLNeJNl1zpVm870yBQN4GkDgnpo7xMU?=
 =?us-ascii?Q?F1aTTe/B8HjPHLw974owRxNUh/cmaMh4wo+mAsWTgAyaW0GtweTZn4xdC4TC?=
 =?us-ascii?Q?4ePXhvcUX/IczHqEqq9hG9pgRYDZzAIAYFnJQSMI1lLGItCwp7s0Svw92qOQ?=
 =?us-ascii?Q?3TROjSA3XUvVzXSOC3PD71jKnSzxwjR7u3IfQSooz82/NcXcvKM1EFlUzrZy?=
 =?us-ascii?Q?DSLVR7A129xTjgs+0AZQYnqhp5hf1c+h0gvV9PFVKJ8gNd9TsfImp+bUik+y?=
 =?us-ascii?Q?ZQrd6+A+Qi73n1Px+VKYnFjo8H2OYsfFxjE1vmrmQ0swYeMA2lY4+u/eCMA9?=
 =?us-ascii?Q?P24pIm46Bj5VCkuwaaa2qDWrK+A00FQcqrqAgkacnu+Ri6wnjDZXMjX71+eF?=
 =?us-ascii?Q?N1kSv72oUi02+39NuZ/jrCYxrTwuxhzL7wqx00cF0TORP71Ai06vL36w5oJa?=
 =?us-ascii?Q?hkEVu/PMz+9RffZkpyFHQmFFCUyMYaKvvoFlZKpjEzS8iaohEqA1oquSaNPk?=
 =?us-ascii?Q?ZsQlfb8EgwgnOuIZqOUi0e+dN9daoQCXmMDHhcX/134qRAzR5V9HS/bWl97z?=
 =?us-ascii?Q?hsM/rCrGakqX0pOszTb458Fv/0gSHab+Zob0KKIHb2ZZpPTe8keJRm9yaANQ?=
 =?us-ascii?Q?ql68HBLh9fSKXV6HSmHyxVFsqp8zTFo7a2yyp+fEfQqjUrSclmWJ1/dXDUNO?=
 =?us-ascii?Q?9OUh/a3AmgxyIxQwSPSHrlFlKS1jwDo+0gfHL4mtWR1k1tsZcY/M0xqX2TCI?=
 =?us-ascii?Q?T62X2j+7uvqCboSmpSe2pb46XiCFNxo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	80UqNDmwfTsLXO0EejNFmR+RV50hL5EToQOcOXz2OlwV3HQ6vfAGoz9b9Sa0RTdyREh+k2kiiFae9/j/HMKWEMeSR2a65zvUOGMbTVAvPoeE0dGQ4DpX0K0d0HKJc37q7r8KAEXWsWRQezrgPw3PDM0Z7KT1VyRTkx5vboXdaqzTcX+q/ZxGE+7VRc7Zb+6umYmoKhOf5yga5s0gBeKecRuXOq95h8Y7nlQLG9WhV4b7YIfzI5J3LpkklfAMm6LavV58VyYWD5VxU11QCzxNWAlnH64961+8VcJO22TlCSzX4ZUVH8boPBpo/4a4jsANStswDH2pr+YSQDq1kMW+Puub2cY5W/ULEfJg5EJJDjtunb/0tKcszkrd2Tk2Dk+Wjl3jiIbwgHAex29Wi4svGfPvFhCWKDATgySTBURfzJ+/xK2CVlxxAnzuj6m9gQMYtOAlM/7D16vFKWISr74e83ttzqyMCqXuVoPlDxk/c0wE1cI1iCiYuogB3sEHnMAaFB4w5PMszg/FG8ve57BugGCmePRJ7ZE6iBi5ULGHq5r33lDYrTaRMs5st1Q57hCdUsIg9Y2nDhLKCsIM/JpuitjASZWaORUMw090qGKpVKU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 271450ed-0231-475e-c866-08de74de5738
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 02:25:43.0510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xpYUIZKmt2nSl+TCkftaowKsWpvjOniDWMiuLLl8osqDYRBAhdoqsGqGXXiko81GwH+zs1qyh9/nNpaiFpPu+zO0pNHddSkiWHh9AYp0Ka4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7550
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-25_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602260019
X-Authority-Analysis: v=2.4 cv=IskTsb/g c=1 sm=1 tr=0 ts=699faf2c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=mBVMRrI0Z2ZZWWFD35sA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: KiGn7v5dFBNM_qhYImAERVnzLFkz5N6n
X-Proofpoint-GUID: KiGn7v5dFBNM_qhYImAERVnzLFkz5N6n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDAxOSBTYWx0ZWRfXyzLuyJVRCwHk
 gCh+eMJgmiw8IvrO2TtSQxyT5w9Ej3WGW58lS9qGClcXy2ci8X1UKvEUssoT+dNQyLc2+dr529w
 R3Ri1C77GYoOC7rVRTRULFdkFGt6Q3iyTiPXN9nosvWOVCU6c4zHAiBw7rT38UUzyQ1IjTDr04B
 RzYi+aJEOHiX4Nj5sGTZ8tU6oqPQn8di/OeEXYafp2ZqAXuJbSt8jouF+20ksaOAeudJ4cVKzmB
 zeQ35sBW15SaolRIVecSO/dYZvKzGiFQ8xo9f6r1pNQjzHUj2da3HB+Hqzt6VU42/OHX2CCiYel
 J1L/+vZRf2UWJs1icO0GwNVwQOp8xaBX8/P+o2ml/WOvrZsN1iyW29W/+m6s5zFIXLvr/PDSsB/
 4ML9XS6QkCl9bHZLwiwlrz7/kVapNaSTw/YWoPfqPkTGkkaeUcXM2dpW4FvL3/OGJf5NxQUD+jI
 93apgBV+DzrBunfXJNw==

Hi Chuyi,

A couple of nitpicks I didn't notice the first time around.

On Tue, Feb 10, 2026 at 11:39:22PM +0800, Chuyi Zhou wrote:
> diff --git a/kernel/padata.c b/kernel/padata.c
> index aa66d91e20f9..53ce56053dd3 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -732,15 +732,11 @@ EXPORT_SYMBOL(padata_set_cpumask);
>  
>  static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
>  {
> -	int err = 0;
> -
> -	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
> -		err = padata_replace(pinst);
> +	int err = padata_replace(pinst);
>  
> -		if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu) &&
> -		    padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
> -			__padata_start(pinst);
> -	}
> +	if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu) &&
> +		padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))

Above line is more readable when it doesn't start in the same column as...

> +		__padata_start(pinst);

...this line.

>  
>  	return err;
>  }
> @@ -749,13 +745,11 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
>  {
>  	int err = 0;

Setting err to 0 is unnecessary now.

> -	if (!cpumask_test_cpu(cpu, cpu_online_mask)) {
> -		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
> -		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
> -			__padata_stop(pinst);
> +	if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
> +		!padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
> +		__padata_stop(pinst);
>  
> -		err = padata_replace(pinst);
> -	}
> +	err = padata_replace(pinst);
>  
>  	return err;
>  }

Actually err can just go away entirely.
