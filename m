Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D81246BCD;
	Fri, 17 Jul 2026 20:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784320451; cv=fail; b=RnNMXX/PQbkXL5C8TRtc69CEXVqfxfpYLJGylYQ/SRxzhqePzLcNT25X6q849OKZ29dsxjf6ZhSPGysuKSKTHG3n40p8eUw2JjUdm3ourjvQ8wTp8++WEyBaKM+r5zpVqXAJmUJv9We/GiQJhA9TJye7ReAHmVV4W1H+x7m3QLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784320451; c=relaxed/simple;
	bh=j+zlI0+tI5GV1lftYqC/xeIAHPghI2cBADTYwXMF3ck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ej0Ckznspa7CC9mEFLbLXJobs+HULHSnMlXvA09iNkA34xKCbdEcIRcXcRWtNTce1woMMyLKR9m6CaW13pFiJxp+OGVRNxMSdhLakXVP4WBZh8FBKBTWcnpGSIhsO7jzVf4clzy9EEswsgI47XMETf1df7SdoR09ufcPp0PPvfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b6rh1Hxw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RVtcgFgb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b6rh1Hxw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RVtcgFgb"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HKNGM93862642;
	Fri, 17 Jul 2026 20:33:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=l0RB7jiBlWBHlDTbJZ
	I61SHVqkC5KPy+Fi0OXKqzBbA=; b=b6rh1Hxw9xWPcU4orCU5rgYujWfIK9ME2D
	EdJ4/RZkGk0pxpIxmSWs4Ruy7EM8aWqrNygJO3TzYcPhPLDjLGrmOF6J0j+1mzu7
	N8JgiDE8J2d5DP9ZAPjdQv7ihiCGynDV6JjilR49XfaDbClsV2EnEWCckVvUaUea
	9UxbmZCsmChvOl3y4bC07OuXAZaoWtw3X1+B2GLRKlITQbdP9cEwulYFQZQqAm8Q
	RgoZ/bMpnz92DW4XI80U88c+nhssV3zy1s11kS0pr+DitIlNIVQiROfRDtDIVcKN
	FjhPSthWfmUMb3e0TSKbvD0xvTbVHcKKyTB4YLVeMZZvb222tQ2Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbed2jyy9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jul 2026 20:33:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66HKXCH2030158;
	Fri, 17 Jul 2026 20:33:22 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010052.outbound.protection.outlook.com [52.101.193.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9ja1p3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 17 Jul 2026 20:33:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tnYAvkT60Y8/DtZCREwgXgxgeTptd5nttHplXN79YN5oDNBfeKBsJFZiVgEZybVUHXATyXm6Nh8n0D1lSFq/xOiwaeDU+gBxppjGSjviQlVBBD9LrmTlWoQEOR0WsoE4F4cV9yd0AisqvWwGHHf3+ewOpPjh3M6HE1v0WXc8qyqFgSNeRugUx/nS8uzFDhJAKvsMXEfUK+yjKjSbIyrde4hsWWD7BQcUjg2/PnckU3dbHf7iyha941J24Ftiks2iKW7DEBboP+Zfc4imxJaoVW6N+cvzFTKRHjqJEk9Pv279gNr99SS4nVGXexp0vNvNlFcZwZyGTTNpoqGiP9H7nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0RB7jiBlWBHlDTbJZI61SHVqkC5KPy+Fi0OXKqzBbA=;
 b=hka3Wj206KYLW1IKtTJ8mN1kUHBOPeZRnwSfi2NqlkmCp7NASb7o44euhLVXCbLcgV2Kk6ZXZl+fiE4HPQYuiLPhkeo/+jriYQl8re98VV66nWVJa9abiQCa69PEHbCzwD7jWBZUITjyd6zUKneEs3wXA039Iv2PXwlXhP78/kA0V/w0J2Wujw/DhfsvqQN3cgr2SWX9YRqcmgby8fuqBBpiN0iNBG8Lbz6TUnrZFPqstXVQBiSyc/0WtCLs4D8ApT2wAhFFiaFqMmkEGgWz9g8D6NSHNWIjFqOH00J0PebKh2XrTPdRu2WApkGx/tQgDydlOw3vp0pWq0cEtgkPgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0RB7jiBlWBHlDTbJZI61SHVqkC5KPy+Fi0OXKqzBbA=;
 b=RVtcgFgbhdER/EUD9ddg7X/6f7KiZZLiROHXNOcJGlpsVbSwUr7v+wnRfC6B4ebNRFk3phkHA8lIkYAJygVzeWJlRSB8GGWIochJoIGpdjlbzlfZBAp74fvcD9LlBA8tLqtIA/zwKARWw30lVsGAucUbWUetXBFCDprZ4dgGigc=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by DM4PR10MB6062.namprd10.prod.outlook.com (2603:10b6:8:b7::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.12; Fri, 17 Jul 2026 20:32:58 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::854c:c282:c889:45a2]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::854c:c282:c889:45a2%3]) with mapi id 15.21.0223.008; Fri, 17 Jul 2026
 20:32:58 +0000
Date: Fri, 17 Jul 2026 16:32:55 -0400
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 2/2] padata: Remove serialized job support
Message-ID: <alqQ5-dplG89Qy7w@dmjordan-vm1.corpdevsubnet.oravirtteamphx.oraclevcn.com>
References: <20260713223234.24812-1-ebiggers@kernel.org>
 <20260713223234.24812-3-ebiggers@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713223234.24812-3-ebiggers@kernel.org>
X-ClientProxiedBy: CH2PR17CA0002.namprd17.prod.outlook.com
 (2603:10b6:610:53::12) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|DM4PR10MB6062:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f4d32a4-ffe8-466f-bdb0-08dee44296e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|22082099003|18002099003|56012099006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	/V7/2JMZlwiK9vr6sL4cWVM6RBNMjRKbrBzN5q3wU2cIVH0x5GbjCQQF4lvIMSgK/m0znRuGXmTmJlqtkGJU3Pezo6NdL4mbn3lK9hm3slYZEI26sLBhp/W8zeC/sWKQh2VxiDieXxwKmvzQs9Vf8yBhizXjwlPfiP479lAuqJvYcd2M+PeQmJuCXe01lPBC8E8Ie6xT8RPALdQUTXl+WtqGoWyuIIpNtSnnxDIxzVH02dtRLVFiTl3rU2oQ/FtCVHYcp99YY2BapK94zSTms1JraFUaehQut5reOv5E7HNCPRiZST5SjfTXa1DVfaHgszJoZUFJXkVVaSL7jBBaZOlGOfxNvETNEkL9PYjglEpU/yGGGYZ/pREkJ9++Hi42bdSbBGZ5OGP4bm6PpRUbQpLPfdEBfUK9QJZL7hjur4AUoPihUKlw5Zj56Xwb0KzgbJezNbLCxW51sOl19NCjIn9TractUGF0LAOaaxDK3+nc0lgqmWNJxKRpxJz+i0N1oJEL9t9UMuN5fuUJvIcvRJxqhrvY6+Q70UQmY1B0lGGVIkDxe1lAH91DLJBrXzoxzf2vbBi1ns14wabQyjWE+FA2QlGEaf4cswP/kDE7Zf5qO+jom43Avws9CXVtjnfn4myBT80W5ITkkfkIDJByJWEVr3JTzSpdjqpxOK6+nP4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(22082099003)(18002099003)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ecnse/M/X3NmvxUGpNHwIGzA5ktB66pTh5Xstt8cgPHMQP5TOkrM/eUyvJGY?=
 =?us-ascii?Q?h0phqdVPoVBH+lD4Z5Yd46AJBAZviVngMPW04KO8Xour72lH0d5cMHbCy7lo?=
 =?us-ascii?Q?39m8TdJ8daszR/3TuXLZHOBdkP3B3BF5gG63SznUR8Ubb4SNxkOexJn4RXJW?=
 =?us-ascii?Q?fSsuPh5IWzS43BBj+rBwuBCSA/OQY7p5L0vVEIm3B5hSxhiwhFENQjMJvFPG?=
 =?us-ascii?Q?sO9guKAh52f/xpTHNPUuoAlvLt6015vvra1e8RnTp5gdGkThQMj9q9tuvSWA?=
 =?us-ascii?Q?CgnoBcpcgjFTNr0jUurLFH2bvXK5I1SOZO3YR94UJf+aJ+tjTfOqhRfBrcjn?=
 =?us-ascii?Q?OIRLjLy5ELFfu18Trq1L4nKxxcYTtpqsffk0L2mOfre1bCr783mOOxQUaTR/?=
 =?us-ascii?Q?JeoTkGDimtg7rHf6De8HQq1wdFOkm0vhTM73zn6niXEy4uIfwUjxpDXaUpAg?=
 =?us-ascii?Q?ovP4/x4Y6nBND5d2qcTRulpi32ad/k25US7pFejJDQbiKufh12i8tJ2RO7Bt?=
 =?us-ascii?Q?oanK/hMmti1+HiAiHBVXIMoGf7UP9ivc18IpYXMYcvF/AKm9tR/pu4PymUwQ?=
 =?us-ascii?Q?gGgBWOvBkXRiNrlZ5kPPCbS3jyJvOjvn51Q8sGNfT5KwI/yK3SYIEtoyR+7y?=
 =?us-ascii?Q?Bk/Y5mEAQ3njDAmybzthhdazDNg6CFdiRpzzsjLVFOcwb2x/pEZzgek6jqgW?=
 =?us-ascii?Q?bXKNwyWEjXUyJeiWGbIuuj48F411bpRmqL16/H4VszIlVODekK00SOAkRmxi?=
 =?us-ascii?Q?5BNWzVTBDUO2leh3Qrn/wYWze6/uLBNd1/CnBrRzVGDQC4Ee2KmJp2c9wkqQ?=
 =?us-ascii?Q?4IoubXl3BHKgNqHmvR+BBMQxUqrc79mHTVje7IT5LWFS+9DgxOwLOlpDaJrD?=
 =?us-ascii?Q?ePTo3uoR0Jl6O0qIG7nvzaZ5r/m5I7XoR+jBXPaDmuza+iS3OKAtj047k7ms?=
 =?us-ascii?Q?3rchU3V2NlC97hjDbi3oW38l4Az2Dky5xbTFGOLyJPXQoqa7yTYbGBHLx2yE?=
 =?us-ascii?Q?7GtOlUawVJ9NiNt0dLwe3HxHWezbiqt2CVQv8zPBKH7t3xpbRn8ogSx9Jj0r?=
 =?us-ascii?Q?656ekkjM+8FW+4WtsIfuUURMRryfeAx8NqTSA0th218392/VpRTNvfZqgQPS?=
 =?us-ascii?Q?WMaNQVz2PWwcdBXpsRLSngF4AWhLMUkMlsgOxiSqP7G5/KzsqJyIuJQgl3C9?=
 =?us-ascii?Q?M9tKJipvf6m6sj8uDuqKCMfNrvi8pTXIkY54XX4P8A7NYh49yAbkfCS6xZ1Z?=
 =?us-ascii?Q?OJSdk6ea0008SMy9MlzRYJz6gaH+z0/CgZgN0rgnQdfZBpW2Qs20GzEVXo+N?=
 =?us-ascii?Q?uVj0SWT2fFG3kHzaI43DCA66GMVac2r3rchcRDxeHwaLwshXd+xS6yMRAdnq?=
 =?us-ascii?Q?TMAydz3Pz6awHjC8kTp2l+L2iUKHpQ3Jlc5l8Hskj9XyfCTFTgr7hOTGomQs?=
 =?us-ascii?Q?+jIgZUD8lwUOidgF3HdrO5mbFWOyw/dWO7dtFFPUKWSQnziM8tDIRHcRPs9T?=
 =?us-ascii?Q?dk0kE0Bu9bPuNPlKYOcK3CEjTGEXeeh1K58SZo5+N3DAeMv25QqJ5/9C0F2J?=
 =?us-ascii?Q?NifWCjq8OOVa9tLgdKLOH8Rjfr/3OqisUQMO24KACmroO8SK5UDpiIVaxbgd?=
 =?us-ascii?Q?zaDgTJesbL7tGJQmJVNA6Le8nLqvGR0SPlwrK1Q+1ZNm0SR076VLyqGr4cr6?=
 =?us-ascii?Q?/TZsXzR4xTrEp4LOgypt/IKXSX07KBaXIJ1WDh3mgy7AdvzF3OYUeze9R0dK?=
 =?us-ascii?Q?23WKpbg1ursnHnDp8OqUJe2vzBfstBQ=3D?=
X-Exchange-RoutingPolicyChecked:
	fE+Q5tM93yMeFcOvgpGqexRY5BKoYlbFw/J1N2uJ7GjBB5VJ9ZF6fFm3sDBjyLPhE/31UiHQ4B6TAUXv8dn/vLp5cg4DSgVjrDF0Y2dlZrOFijbPgIof0Y5p1GcIF+X2IMU2kbCMdHFI+jbwMpHP5GnFhnaqjvFX0u7g+9T0vacLgc+ntCzQiR6qp+pLoSTszFk54Wv1DNdIcU1CjsPrXp/I69xapgUXqurNIaBNFweYEoRJTjiZpaXD+001VyEllKTMDQF8WSK8uDYOAnIp+1JcrDF6onOP52o+sxVSBuXzy7bnfM/hesjnUAOBUX8JVy00o01xWtZr2Upafy4hYw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ncrVCoHAPxujAoO+SEUVsap1bnli5+W6EXj19RHPPQky488aKsl2jKzvyW3D0U/NKXdSxg6cX7J2VeVpxGjQ9ZDAp8XCWYkbbHdZAs6brcy1dUjkYuBOuifNitZJyjQdPo/xp/EO1Vyt47xLLIcVd4rPHKdwNM3PQ5xbho4ljONpZc4nzU5cwS4VIc+m6iQrElZrqrFwh25yeYYWmvBFAep4iN5EDiwGpVLXWYCAxab25nPf2rEwJi0U/b+acslGew1tjtg3PemUTS80/zwBojlkuet4dwM8hk6HtCaOWt2F1Bk5ZQ4DNAeYHpuoSS8hl3J9IXU86aQ+iRNyHgkXIWoTPyQJDsOaiBkEfe1RieX/LaOhcmdaCoPo46smSBxPQbeQi2nfyqgn4v4OYmLISmj9rODSmUJS1al0IFJ6OIjVs7COcyLO3Yw/yVEXof8thWnSk7GUjLKMASeE3LkqV2HMaKWGlk/+P0mCJjeJdKK1BM7sH8XSFWAn0vejjeRSEGUzrrGf2sIXUKOjyoL7ssZ1BhNbict+4m4WbYCG7ypLB0vELtBj9Q6I9Qq+XXQndYB3X85lSn3qyE5nj0WwHdbQoMjtiwG4RYMoSe9KQ+k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f4d32a4-ffe8-466f-bdb0-08dee44296e1
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 20:32:58.6498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HgVbxiWRtk/N2QQfMhPLImgXyhjQMe/8CYxYX9wZrUEAWsmvwpevtTKhT9n5VF4ak7fb8xq5CPsghA66LVzaV6r+L4NyQR1Ih9PvJG7fMxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6062
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_06,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=930
 malwarescore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607170211
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDIxMSBTYWx0ZWRfXyxbSSbl7ZCIl
 88YCr8BLPyBAP5/9LBWZAHim9enYZE/J6dkCELeMONey8MA0NCnLEfO9xJVIw/sO86kWDCgQhaX
 S8kiRYNt+o7Au3RWLCOG/ChKqPyfRP0uwfpRSbMEnOki4CxTdOLNFT1NtUgSmiM6EYf+V4Q+XET
 mRIGbK2YqdHP2Z/QTWXDCcWoavO9Nj6ha+2MQoCN57c0Jr4oXNpZ0xa7jtn3WpF6p3f886ye4LU
 y/u4dRDXN6x128YdMtw7M18bC6NaAdidQuuCCk9Kj//+ddJCQQ61vjWBmanM8s+1IULLwZ/YJYu
 eUKjdH/AIxzfuo6CqJjHcMJWXKNbMlC2hXrGHvw7l3tn7cKLDvkve+WnhJnpb3Pq5Sz+nsWqgGU
 8Fw+eNJVtf8CdHi4nWXZC1qyZWDri8fTh1XHebG//UGQQbXDAIP1ShlBk9DPzxA1VIgFidTnewI
 0TU49pz5MxAUI6jBskg==
X-Authority-Analysis: v=2.4 cv=GcknWwXL c=1 sm=1 tr=0 ts=6a5a9196 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=7ZN4cI0QAAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=qyuDyX3VdW9-DoURe3oA:9 a=CjuIK1q_8ugA:10
 a=Dl0WHwQvj8hGZljrFLtM:22
X-Proofpoint-GUID: yE-NCMIb-24kMq4mAXXK5ATyb-C7wCkQ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDIxMSBTYWx0ZWRfX1J0Gq9YwM00z
 NS8tp6RfKIgXdYTqoGTlKelU2cTCbLA6g61abEMZ+BfJcLRuDBvAJX3dLiSYHkf3OPkrV6eP7Hj
 I7t/4iXcSCbG3v08P7Xn4tcjATBbxyCF9oy6jOrrjPaJ5JoIpPsM
X-Proofpoint-ORIG-GUID: yE-NCMIb-24kMq4mAXXK5ATyb-C7wCkQ

Hi Eric,

On Mon, Jul 13, 2026 at 06:32:34PM -0400, Eric Biggers wrote:
> Now that pcrypt has been removed, also remove all the code in padata
> whose only user was pcrypt.
> 
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

I don't know of any pcrypt users these days.  This looks fine.

Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
