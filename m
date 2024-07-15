Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2735818EFDA;
	Mon, 15 Jul 2024 14:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721055496; cv=fail; b=BUEjps2BgFoM6KfyaXTqpaxZalOUwGLkqgYDiAeiz1IAEaKiSQ5Vq583Abd82DPslak8Cu/ls1eJCwac0su8S7jCPb4KU41jnqDcaj8p/kAGW4+NnWQpniWTMcWxVRVd/JFB1JDU8ecQ8wddAHFwXhd9XD1ATrUPcUin0YRXmfI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721055496; c=relaxed/simple;
	bh=N7J7UOFLAqrMyW9sejP11oCewb4MtW2p4ZoAJsGRpy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=piIIMJPKTUClKo9Pbmza15+SZRZt63nLDFkzhkrQrBCLF/p3C4Fo+zElvhN+SfvWXG/VYMCTTAppAw0pn9L80IJ+Zocacj08yZwvXgJ1M7Nx2YcabHxY55OsPkSKiN6k/Htop5b7fOFV92qifhMJzINltfAK1V6Rw+0uTaeBrfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Jjp1rjLM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g+uD9lKe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jjp1rjLM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g+uD9lKe"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46FENbGF005763;
	Mon, 15 Jul 2024 14:58:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=G/i2jXjQKQtAotX
	6oykzv/jHuxbJgqVtP/G6DSt4Qu8=; b=Jjp1rjLM1JFwwADiv2govAEzEoFDc6Q
	26gV1cB6ouYQVtilRncz3vvY+gUm8rzWgBfFhnhqWsYYWsLHHg+PwsfDsUGpdWyW
	2KAH+ZI/pp1n/7QoEYHHIBo5ARmHFNM0m49qL5u6rweU9gaPBZqmWNy8jGZxmkA7
	G+Vr6JYnwGhqQtKeBwjIiN17Cz68bTjiFwkXcSh1DoRT7DLOzFVZOA6UtiVMYV89
	HxPpW/X4kWebCiPt0Vhqd0juPdR45OzN4Y6Egg5WtPx7PETjWIahvyja6zI7SxKM
	JWonk3V/4RAWKYe5OMRm6vDafcJzJAQ9+Ew4OBwEDlInlC7G5gW1z2Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40bgc2bpua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Jul 2024 14:58:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46FDQdB4040595;
	Mon, 15 Jul 2024 14:58:02 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40bg17pcw0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Jul 2024 14:58:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L3+JoBIYJhIIya8mtWm+bZnsRirHBks8gNh/UtZoz/PIRy4lKkRdTQkfUncGxhtu/6qBEO/U6/CjKM01hPLQ0ycDzM240MD61AgS338tCeIELt9UgXJ6mST0NsEvIbnWac5eK0kjPF1Cg1+wDQ7iHaqwMzjQpSFaUb3eupsannyUZiLXcsZ0OSPCJYGzUOQPWESb4si8EpMQiHzp48JZDDLThnJvjIa9VZoLg3pseyMtPFJvv8CAQ7Etvv7ZVaX07zWCNjqgZsfPOtsVIQs/l48f80ya8sOxVYsnM3WiX+NLc7+RxpcV0XW2nPeot99Fp7PtLpP5lEe5HaOJ7puWDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G/i2jXjQKQtAotX6oykzv/jHuxbJgqVtP/G6DSt4Qu8=;
 b=bx6PxPVkSluArnvIujjBV2hzxBm4BW0GLeakXiH6UQ9sKgOAOM/0n+LE+SYgDaDN1OIOYV9mynEYqbVcNyR54OVrl5b9bRBwfZ1stOV9cvWvaq2NMIlI2vrpULmACPCXV/J3qTdTCvJEs7HgIsKlZA8m9GKdeiG8OSDGt0wXBLqGsbT8iN9kWooiuq0fF06Y0bIWP3gxeCNPvep8bbRNR3kaQmykH19TyHL5nE1+aTZNMNQZPRa+hppEPcOMis6IBzX51SQ40oGvmEz/AEx5zd+gW5Ms888aVY0BEBkCnwQIpBZEaBYLd6TlrSJptazlMjoKUqzov+cTE+H41bpJDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/i2jXjQKQtAotX6oykzv/jHuxbJgqVtP/G6DSt4Qu8=;
 b=g+uD9lKekVB9JRQuAKRi6LLNFLhOI1ohtqOkajGR1MJtcDgRd/unfAitP5PQWj1Q9JI4Y19bByYKoxlQfi+A9ZTfXjqEb8y7sIDxrSqQmUdWyyr+r9CpLka1AUKpcPkcfn5vmTkAUE7Ny+saSU7zPqHwm1Ae6X6X4q01SNEIXII=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by SJ0PR10MB4719.namprd10.prod.outlook.com (2603:10b6:a03:2d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Mon, 15 Jul
 2024 14:58:00 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc%6]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 14:58:00 +0000
Date: Mon, 15 Jul 2024 10:57:56 -0400
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: syzbot <syzbot+2009b142f47c1e8fe762@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] possible deadlock in alloc_workqueue
Message-ID: <thmfb3q55cnqkqwep55rbngla3veaaw56kduriianxlwkgmbnu@rqmefdenius7>
References: <0000000000001ea4c3061d220fae@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000001ea4c3061d220fae@google.com>
X-ClientProxiedBy: BL6PEPF00016410.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:17) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|SJ0PR10MB4719:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c4071ec-5810-462d-a506-08dca4de852e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?CRYNDfoZC1R8mtR300ZluZEySC7FXW9WZGQ+9oVt873foO4IVLMpweqS7rjO?=
 =?us-ascii?Q?CVd+AEETmAEBfyAiPc2/Ta9S0Is8KneKeQC3oHgEsA79VMt4qspRzKPZAQg2?=
 =?us-ascii?Q?ZeZ4AqKEdR0Aq2nBBMkGG50tMjLYLP5u78HX1fNNTr4mQ7NP4fqoMAsG7bcT?=
 =?us-ascii?Q?A0knxEtmfAZ/7q80O63CmcuEHVor4cxjlrc/eAZa6X4CeK9TVnm67+uOvmnH?=
 =?us-ascii?Q?30jedrlzywv19VWScM6cGP+3bl5r4e01/CYn9IGvyULJKWD8pfH0sMSbKTz/?=
 =?us-ascii?Q?vGiLHk0NnQzkbadgP4q5bSU5Uyq/C7fkgB2zKTrgFckvvzXAbnJmbxsX8gCg?=
 =?us-ascii?Q?gDywYIqVjVxn65+qALmj1qxrMKloJXE2SPLPmNJpNQ3gCP+Yb1Ocn53CIS4M?=
 =?us-ascii?Q?En7YcfJSsowKCxDEWGoZVoM6KuWBHxiUOuNwAHSnI+tA46Kv5dRPZGeNJxiF?=
 =?us-ascii?Q?IVivj+2TiZ2eET8ASEW6Ac92uARMUepmkNNul5uUK2N3tmZ1tscbNOuzDue4?=
 =?us-ascii?Q?9javAk5KZz7gmYvNQbm4WHiM2iXrqqKiJgdYlQKYxzNDlKkIKBprfc0q9Tvn?=
 =?us-ascii?Q?UUUYGJAY7PCQHmadQQlsYhxC3ROWKaw62U1J8DNaElXq/dCYpF8oqV6whB+G?=
 =?us-ascii?Q?zDSb86YFoyJnT5Ew0g4ze1F5lxIC3CKYcGRxZKyskBPZXVKYRZvhb4BR9+Jw?=
 =?us-ascii?Q?+3A8xtE8aF+ezofXHISGxk0F1GKSn6Rev5WT9Hy4vFNovx8QuWXCIKnXcMaZ?=
 =?us-ascii?Q?7hrvGU9abkS0poznDGhNZdjpydXfRxom6+z/2wZ0WlsNZAh4jHcSxi/Jk+Uz?=
 =?us-ascii?Q?28ITR/0x+0B8JUIkyU8JnhKEta4wftRi+RUJFe2MjRjAdrockPL1H0FBEilD?=
 =?us-ascii?Q?GchXR41rd0qYhf5Kx8u3ghIgEGdNwK4aato2bRgiPFS5LKr/0mJoMRpVZNWD?=
 =?us-ascii?Q?NCayBo4QqLZMwxkhlm/FJdrQXVUJhnoKJS4c815RpOXuPEA+UBC7zetp240+?=
 =?us-ascii?Q?vUqyL0l1TecZoMmlflbPlok79CoK/frzEZw3AtK6a+i0X0JhZA7jIk/fhTup?=
 =?us-ascii?Q?b7UvTDPBOcxhHAEHI13KzLzkWm40iNKx38CZHKppbd+zMbIC8AI5TSLMc0I6?=
 =?us-ascii?Q?1n1aIT2uhxkTDd+lbnM+n5U6n9Ja3RDp7yJGcutENAciZe3JqaK4E7wFS1HI?=
 =?us-ascii?Q?EhsnUfeGrcWFK9zCj2lWZpcBSMrDyWIcDav5rFZuCMc+KGaCdJh59aKYcqJE?=
 =?us-ascii?Q?MXBDqypSjvkkJi5XBIMB0VN0xAPQt6nN9KspP7T4za0dpevq24L0BY2WM94j?=
 =?us-ascii?Q?+X0=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ThAfKpPyaZrY0XxkECB0KnrMa/EPVCEih+/kORe8wYQDEz3uoK2ZaeZnLx7d?=
 =?us-ascii?Q?meqtO9Ld99/R/Ue9SJgREzg1ZmBBTmT7QYtFicusMnXq6luQYDSdTPDh8WZ6?=
 =?us-ascii?Q?KYwbDUC9kQ6B32Ugx7KhNStJaWNh4ScbwxHxwyh0hO7Br844ykJhex6F0Gre?=
 =?us-ascii?Q?iA4moM5Lkd2X5FPyvj21XIPayGKFROzJ7qAgYki2HlVSJ3widKi3WSKXkPXd?=
 =?us-ascii?Q?1XcVrjcgpIO2HUoEKt2dsGhkr9q9DCQ7RR+pF36TsdIpKhLfsP+1f4P0Wq31?=
 =?us-ascii?Q?tZ2IkFWQUwOC2FMMG2FDFNs42QzYeUxzpCQY0TWjVXm8XyPhXxKG5TDSQ33c?=
 =?us-ascii?Q?bA6VP9b/ns9nh9S/SVoYusWdyTqp+6Zjwwx+AgNhlNO7ipTuGjvFzLJkNc/e?=
 =?us-ascii?Q?vEtZOvTdoND8Vkl7hXv4DwCQVjKV2AAdjpS+tXGu+PrN2p3JFNIp8WjL0eMl?=
 =?us-ascii?Q?uVEvPfliNlGPJl8nZE+pK42Mv11iZz1ZVqs7xQ/IRpSCBvETq1CB/T381ihf?=
 =?us-ascii?Q?sYsP4P+5mRixID52m7YGknM5EQW9jmI0U/q0B6/vCviNF+Kex++Giw97HhdG?=
 =?us-ascii?Q?eG7xFLe/leo/l/HfLwvcvAiqjd4I/5dWGw1ftPxyggdgjnJ00P5ck6bcsmm5?=
 =?us-ascii?Q?IWDXjC66MqPHbmyumbaipVwIjHVONG433iDWyHs7KYOCUz0EPRuqoVBbcDt3?=
 =?us-ascii?Q?NnWihWYa516Uq6lgkJnMIBHXYzCCOk5zuEohPACJJna3oQDMmabG8RcUcvDe?=
 =?us-ascii?Q?JWTYlq1y4L7O+BLGYV07KSvhvRmtuGudU1OZxINFIsaxiYf74xap9k8fIYLO?=
 =?us-ascii?Q?ZnqbgtgR4DkBdjvaE/udxTMSf0YxtMLzph7gNTPcyL3VBq4AIYMvUdOsvIUJ?=
 =?us-ascii?Q?XsSyEWEPej6vLifR/zoOUDb0VT6CR8Cug4GCZ+bQxtS1mYntQs4oAhMCYjt5?=
 =?us-ascii?Q?nkRaSvOczSbyqyughjuC4iO+96ugYyeLWS1YpbHRfByA1LYDbAXiYeQu6iTy?=
 =?us-ascii?Q?7AqsKikY2TUNLVWYPzsW9FhIIqzY3vDFmaxcysoyhGHiUuB/U5Y2swyzS4es?=
 =?us-ascii?Q?IPEQxZ8IfMBKGm9dlwh1A18LyZaeu7F2OMU92Y//Tu0fXor7cbbE3Cr1Yxt6?=
 =?us-ascii?Q?fNa5SgcE95vS4GMfMl7HB1+ErY5dajXcGctwlXjOgPYHPQRFCmpDoW3kOcZ3?=
 =?us-ascii?Q?ysM3kcSHw4OjNsb5qrnMD2z8gXLkUzVA1PwW23SYiGECFAj8zCj9fHBM6CY+?=
 =?us-ascii?Q?htvjuIcIYg+57xk1bKyuKtihYTcp5z+r4jQgCo+6thVRAcDNV/dhpdwdsBk6?=
 =?us-ascii?Q?4J6bj0hwfjaD5UB6CeBS568ONzEcT1/OtAbWSZzdpeLshoB2ow7gnOKpIOWe?=
 =?us-ascii?Q?p14D7cCc6AJcAojMypZh+NXojPsUsoWIUFws6ZrjwXkZxpBpCvC7Tsc8Et9D?=
 =?us-ascii?Q?pNbvSYNnoYfITVxC/nn6Y4TiXJXP5H4gd+exirjejL5op3OGZn0Ovpb6U4lO?=
 =?us-ascii?Q?1nrZhn6NmJYkwJb8+QMj8FXjzCP6NXYgJ0BVaDNmWPx5kOluUte1tPF44eP3?=
 =?us-ascii?Q?PnutzEa/IZE1qj9uEl6tzoM6j8G2lLvbWJsPNJPWpvUpfSYwyGRqFeJLGFkI?=
 =?us-ascii?Q?2Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	vXhcb0vkAOMvgnEaAy4MbYAT5LZjx3ll33Tw4rbYvRFZQEx56B1Bf+aI4y7FDnTXC9WtN0MAZ4mDH2ndy+rNwVbo3xhHUpVvxfac61bGQ4yz9wiikwHT0fyhje+v2u8dOe/k14HQiPeb8jYZZj3gr5QeuecjCdD6c1x1d/p6pQyh2KI2LRzBb2fRqh/jq8wigUEMWuTsUA7jJ3QlG4xel/IA1GYZG0Y7zlNP7i/zMQcWzl3S4dFw3N+yaaDsJ13N0FA6LtqSDcHV2Jx2w0GbKm+auBG7m00M6hYImo3kUzHcvioUyt9Ydau4SsTdRTq4AidFVIq7gEMKGSXiWtXVr/XHobamQ81d+NdDHqE/UgoPwBVBsG2Pd9hlmxtDzOoj4xhf5wTl8KbjSIRm5oDbVkMBPF6+mrTDc7+y4DNFMA6iWsRqYPdrhZ+7fXfrXbDplK4zfWOo55V+xpXHp8ok8IcKmqwGNwCfCMcfJdKxSTbkvl7xEknEtyIHfBna5lPLtUXpdo1iHOMpbsOnRQzYRyXglQxmeNk9dgs6NOGrI2+9I6YOKr9opek6993pid82TG14Vga23P/Z8xtPPG0zHYtvP1C9S/jeXS9FLbeUxK0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c4071ec-5810-462d-a506-08dca4de852e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 14:58:00.5338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cAQcZZ5KyFlkg7rA5UYx0E0eekIMydopAdhR2Xfnhp72uj2z6ju0L/ynmbKxsYo26YuD3FrkARvqv/1JPZeY4CCWlkmsFvLwnIkpjJh0DBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4719
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_09,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407150117
X-Proofpoint-GUID: RbVS4ueI6bmNDflrKgLOtp5AnAcNwD9C
X-Proofpoint-ORIG-GUID: RbVS4ueI6bmNDflrKgLOtp5AnAcNwD9C

On Sat, Jul 13, 2024 at 07:46:20AM GMT, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    82d01fe6ee52 Add linux-next specific files for 20240709
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15ecf3b9980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=95a20e7acf357998
> dashboard link: https://syzkaller.appspot.com/bug?extid=2009b142f47c1e8fe762
...
> ============================================
> WARNING: possible recursive locking detected
> 6.10.0-rc7-next-20240709-syzkaller #0 Not tainted
> --------------------------------------------
> swapper/0/1 is trying to acquire lock:
> ffffffff8e1d19f0 (cpu_hotplug_lock){++++}-{0:0}, at: apply_wqattrs_lock kernel/workqueue.c:5134 [inline]
> ffffffff8e1d19f0 (cpu_hotplug_lock){++++}-{0:0}, at: alloc_workqueue+0xb99/0x1ff0 kernel/workqueue.c:5719
> 
> but task is already holding lock:
> ffffffff8e1d19f0 (cpu_hotplug_lock){++++}-{0:0}, at: padata_alloc+0xaa/0x370 kernel/padata.c:1005
...
> stack backtrace:
> CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.10.0-rc7-next-20240709-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>  print_deadlock_bug+0x483/0x620 kernel/locking/lockdep.c:3034
>  check_deadlock kernel/locking/lockdep.c:3086 [inline]
>  validate_chain+0x15e2/0x5920 kernel/locking/lockdep.c:3888
>  __lock_acquire+0x1359/0x2000 kernel/locking/lockdep.c:5193
>  lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5816
>  percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
>  cpus_read_lock+0x42/0x150 kernel/cpu.c:490
>  apply_wqattrs_lock kernel/workqueue.c:5134 [inline]
>  alloc_workqueue+0xb99/0x1ff0 kernel/workqueue.c:5719
>  padata_alloc+0xc3/0x370 kernel/padata.c:1007
>  pcrypt_init_padata+0x27/0x100 crypto/pcrypt.c:327
>  pcrypt_init+0x65/0xe0 crypto/pcrypt.c:352

This isn't an issue anymore.

A workqueue change in the above next tree did cause this deadlock, but
it was reported at

    https://lore.kernel.org/all/CAJhGHyC=5FC1uFt0xzMwk42m=zm-_d9-OxoC4BQmSREAbAQrog@mail.gmail.com/

and workqueue used different locking to avoid it.
