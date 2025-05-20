Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18EA19C578;
	Tue, 20 May 2025 16:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747756836; cv=fail; b=Uh3mINeDmv8ebVMt+ZqwS6GXoV/hFZt5AQzSpiTpnpATD8MMLlrqkdmywmke5YpVJIKYDmhmxqTp77IqS3K0I9eIimp38tMLE8hcx22hpi+Ztn4anBYGvzs4HSgAZmaE3VqXX3NuuiBkSbrJL/iD01POlX0d4IB8RsvGxEaHDr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747756836; c=relaxed/simple;
	bh=++JNFg5SyNRA/hqfM9CElxrGQFjec0q6KRBQt3ehZ9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=h96XGbl38YjbYokXPhugXAtvlMuiEm8kA5ofzKBZSAu0WkhFrEBF7YuhyvLAByFp6uNOguHWPH8UOQhTRbhmKIwTe78+eC10x/gAfLXmDyawRwXdHkUoQcRu+kyxXbA2lLnA7x3U4KwvvnJPB30VflVtQ+K5W13l4xpbAq90ckc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nZ7sqw4V; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HqzrPRld; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nZ7sqw4V";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HqzrPRld"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54KFMEtP006294;
	Tue, 20 May 2025 16:00:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=tgmbnWHp1NR2T7CAJe
	nK0TKvNFeqmlFDXjd4hpnfvmU=; b=nZ7sqw4VgW20O1aXHhs8hiodX/2MH5Tc0N
	kdbTZr5v9Q63F73gsLekSu+HlyVaoa/WvFrbtYs5OEwa53iebDNYZQ3NDbYowKuJ
	tiEg6L4FKkryjgTpmKH45ZnWNHo+yRmFwiFFercrsJcoqZ5ZJ5LMZ6RLuUhXdre2
	GUmOrC6QObZ5KnySwuWSNRr+pRpQciBJE807EqvBPamT3nIlpqs3G99PIBACzhdL
	WuE0xS0WHRtM1m7Rq5CmIdUgJpByBP4MZzLlRfPHVPR8bqcsIHGpZUbCGy7K9nNA
	Drn3gZiLBXVWfU4cjvovoN/AGj0QW+AjAbWftzXNcTzz4LOxNhog==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46rvahg2ue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 16:00:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54KFGsGl037162;
	Tue, 20 May 2025 16:00:20 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2075.outbound.protection.outlook.com [40.107.236.75])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw8yk9t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 16:00:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M/QPcdk35BllD+G5hl9RXrXzSWqw/XvzSt8oyGOWkDNXHGchqaGWR/1ziabQDndL+YMdeLKmFSoo/5KfhychJ5yLKFclb5J7uDJhVqboimsKlCF6iH6wOluugAsA9xhsmKUODvEs4/WWH+q98qUOMpyduKea89PieDOD1ruafsGoxsPuimW0gpJD/xhQjqr1HdceJzfTWyBeGIJJtJxHSWi9eSG7qp9j+MgYM+gtqON1oxeHAfM7+QJEqvCV71w6VYbfSqJohpdFs+il5HOxphrtcikd73ly4C4/dEVpLYI8/cr2iej4Qgh9LjmZ7ftV6avh16u1A87m9PC6kaCLNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tgmbnWHp1NR2T7CAJenK0TKvNFeqmlFDXjd4hpnfvmU=;
 b=MSrvWI3wWf1SF+liCZMurg9gOw62NjPpRQIKz0ksUQL7E9j5wQojvWTxNA3krxiBh/eym6/E87Pb2WWudP7Kfqts5w0StCnGOlFGP5ljR/zLWd4SnPbCVcTkIsV0yMOMM7rkw1Z/Umk9SP1kEwiObq+B2ahYH8L3TPc+bFIyvH4VPzLJL8eoxd+0eSvRy/mz6AzAhWwCYASzIkan/Zx1dhGQRDJQcmAkPjzEKcoKBZoy4GPuWVXBBvMLTc+FDDblgl7RiHpDc8NtYrZsZ200yJdXjAWKIw+rPx6wEwnb8vL02vgttUFBjUigyuuneDLNT26eoxvZmyomPDYGmKon5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tgmbnWHp1NR2T7CAJenK0TKvNFeqmlFDXjd4hpnfvmU=;
 b=HqzrPRlda6EaDBveryn2CLUFLCxWnlzZxlryZ6N2ApCtUewy3/Am9T/68gbSk+9kCqZMni7vUESOdh2xP52CUAZRcS3j2fbheoT2e6VDB3L0MXL2oKA2GRZsKPjVToL50SsrZ5YmS9vF7E9jlGcGKrxHEQdwniW7bgtVdCRDZuk=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by BN0PR10MB5208.namprd10.prod.outlook.com (2603:10b6:408:125::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Tue, 20 May
 2025 16:00:18 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc%2]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 16:00:17 +0000
Date: Tue, 20 May 2025 12:00:12 -0400
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Dominik Grzegorzek <dominik.grzegorzek@oracle.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Chen Ridong <chenridong@huawei.com>,
        "open list:PADATA PARALLEL EXECUTION MECHANISM" <linux-crypto@vger.kernel.org>,
        "open list:PADATA PARALLEL EXECUTION MECHANISM" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] padata: do not leak refcount in reorder_work
Message-ID: <jmo6jjku7t4ftutfycp5zxpy7fhdvbprrkjpl6rijdwdz4z5xx@fzqjm5o2heol>
References: <20250518174531.1287128-1-dominik.grzegorzek@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250518174531.1287128-1-dominik.grzegorzek@oracle.com>
X-ClientProxiedBy: MN2PR20CA0011.namprd20.prod.outlook.com
 (2603:10b6:208:e8::24) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|BN0PR10MB5208:EE_
X-MS-Office365-Filtering-Correlation-Id: d2ab6147-aaf8-4f0f-511d-08dd97b76a58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?48YUk9fkuOguZ0n1g7DjlI6z4EBlA/c9cPA9w0xuriWTQ4CAPAuWbHKvzZIU?=
 =?us-ascii?Q?7zC9igzQkmQUNfQYOEzfp0Q+QO26S4u3BzjKWmEXXR3AP1Pm4dhU6hwWn6Iq?=
 =?us-ascii?Q?kNW0YPdZTQ16HUQkA8+Oak+0uUxoiQ7HkYhNJhW/KaKSBFV+RtuX4g8NqM1g?=
 =?us-ascii?Q?1jTvfIRUqKEjKVUQMJz9vNh6H/mKtlgfRGUt9+l6S8M+/PUOO4pj+k4NrCiJ?=
 =?us-ascii?Q?5u11PxS/hg2RuYFUvClA0iCJiwMr3W9HNrIsD0D4Uw1pbCHjqSEo6hQV7S0V?=
 =?us-ascii?Q?uBiFuFhpn7RKiAuU1BVggRh4KZu1mWrjvMR/Qk3FaP8/dE3WNmsBZddht3dy?=
 =?us-ascii?Q?Kj3uHMc2DGNtqg1wCMWVia9dS7dLTQ1JJQQjK+nl5RsYeisVPXXnEO3m5CXi?=
 =?us-ascii?Q?dMVpXOYbc54+ADxaYb1amzMjjrDRiouZmZwngJDPIEFsRtTSuq4FXmPutRSj?=
 =?us-ascii?Q?A34GCup7rn+NxeTETnjBOp1BNl3uHd+w1sluwa1tSAy6PHlFTgOYPRIKuYMj?=
 =?us-ascii?Q?1/xOX4WT2OR7HJDMwbhrHUsBzxLeuD7iamWoF7xKY9EGe1U8NUNp7nAE0mG1?=
 =?us-ascii?Q?VOEDD+vQwvNdMMq9Yc8UnveLB4Do45InCsOZahXKHyUweOvvPGX89J7PB9BD?=
 =?us-ascii?Q?SYMIewKBEPkj4oaKt/RcnBW9DiTJCY0HIvpKZpZ8/OJg8roe1pXTT1qhfrTI?=
 =?us-ascii?Q?BwIAUd00YTenM0DjCsahsdDrch0VcxgDcwX9Vhlx47+1jxjJcTk4nDS16kYS?=
 =?us-ascii?Q?FwuJpXwwm5fbmdKMl0btJOLI+Hy9UtqxxZ6+TN/g23VFgUN6fASPsRD6s0Sw?=
 =?us-ascii?Q?9ca7jdrt4oU+wVpIJs0nIdTkrPe5O7gbv2gSePi3/cvXXhPg1D61eFbdMvjE?=
 =?us-ascii?Q?/PCVpfYJN89cDINR97cl440475UgNPc2jK4/OnA88EXV/qQWEMhZDPN4JfWU?=
 =?us-ascii?Q?JHuLqqf4eJWpAU4Tj07kMXmUVnrkTy2mD85XfbwTvVnThtt8dHXuPLq31/2u?=
 =?us-ascii?Q?DCFv4Paq2MPvlKle7OxZN/DgU+hL7tvWAdD1wOyryVxcFJmN2Ia3is5s6A7B?=
 =?us-ascii?Q?e7ysefRwlbl64qciCp4Gt6h/oFpH8e/GozzrI6+uPp86s/JazTpbynTKx8LZ?=
 =?us-ascii?Q?aEuiS29f9/R4pfycK3PFzuS9yzyCeAMgMSP2E8v3emyYipduvHEfbCIm2K7d?=
 =?us-ascii?Q?/gdXRsAPWLP/2KkgqjH8BXDasfXnr2CO+Urc5BP47zqj6YJbmwvH31KfnL1q?=
 =?us-ascii?Q?N3FOfHCpSJ3GnsJLtKUZLXij/3D/tiCh2Bg/ddZFit3f/o4gHzeHgmuh/qSl?=
 =?us-ascii?Q?u9kJpLcYP1k9eaPQ34Jx6U7oPhxKYIyyN/CHK970PbFI9c9psqWrNfHI/X05?=
 =?us-ascii?Q?8jKWU/HdjrRGohNkEXBpo4uUpw/edR+FzIbhvWaB+oT1NjI3JmCVPuTAZbxH?=
 =?us-ascii?Q?l0kzSgOJv3U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D7hsLqHsQGds9HBPVSzKmR6t5/wDSz5yVwCM3C4pd38VnJaW8gBoZFEphcY5?=
 =?us-ascii?Q?9ptoQq5shaqjdc/CuY+ToNsOw/ft8uxIMR4MLRuOp7lkujC/NT+8Uh5LqojB?=
 =?us-ascii?Q?sCEMUqzxUSXkZlKOSTlLPEipkyOkU3uORqrWJz8YwokvEl1fGrm3MtUNtFNf?=
 =?us-ascii?Q?wT8+uDKahZHYTqkp0Rgp+NFdd3f0ugPdWvXl3d8S/dMXL+J6k3NrXLqUVU+N?=
 =?us-ascii?Q?/QGXoyBsnePo5xpb3p9LYi19E8lf2Ca5H8zXmO/SvA0rd6oktYwUlYSRe2kl?=
 =?us-ascii?Q?Z9khbZPk6UI3lDGawMTpnT9Ri4iuTtXTCANtOqVPWv+y45ct8JHDCWqAaRhy?=
 =?us-ascii?Q?+g+IVD38kemJdaSoeZxYOriC6cGax1S+5y7mpX/6rXK+tbj5EKbfiIP0+x8O?=
 =?us-ascii?Q?aLk8JxhDqEQ3ohR2+AAwHRngrpXpGociAAwRcJy/DsiyVDEZkgufYW5h9xi7?=
 =?us-ascii?Q?kHdGaKAWgcmE+Rmg6i9v5SqjkRh0r8i5s5G6qmWgKtbVYNUSpX8b7/83l9aa?=
 =?us-ascii?Q?HbJPkUL2uI2SG92Qm2UmrHHb1HyASGYKtN1hBgyEhXG7UxFvY6HmKFRb/y+q?=
 =?us-ascii?Q?My8HIDcXSt9G5wY28QbAsLx2l9kOZ2Wl46feoWs2JOaDqV1I6FnmPIDJt38v?=
 =?us-ascii?Q?olGmLaa7GaX5Hz6ydPXYmXbuQ8gPB4CobY4UU+6jKlevgF8V/YhZaNnKzRvC?=
 =?us-ascii?Q?dLJMiyeKvLf2FezI7M2S862DXguGYy3ZQZVCh5B9+1ZEwIZ8e1bAKQ2/p/3/?=
 =?us-ascii?Q?GPqCeKCg/fIRdiaMnw5rWm12QDdwG6eJh2qp3xzhqzQisg/ujZbuQo3rM8Xq?=
 =?us-ascii?Q?AiKmn/W2/rrAt7W9PM73kFuE9CI5fEdA+JT8ztCFEQMFtcwaeGjU4Tpt2P22?=
 =?us-ascii?Q?7JevaTKJ3R/gVX7rgmaxYukUnIxPuPp+g+mIV4Y4m3ZtpouNh8dWomuG2LCF?=
 =?us-ascii?Q?xg6a1rs4B5TjtN/p+bTnUGJyDHoQFGo0ZPGM6yY5jDBW6cqJ+LkNLEqBTLvK?=
 =?us-ascii?Q?elxaNpY54hQQTEMK3ffkfDlRxAlFSIyoYuWTeVDQGfXw7QRqh4TN9ZkBrnXt?=
 =?us-ascii?Q?EkD0x/tVQG9aQTLgXDntZnBiu2yV7FratK5od3oGfM/tBZ/Aw+F1wgLj75bs?=
 =?us-ascii?Q?8807Uvjxmc8x0L6CJjNyckaUy2SnPf8xB06eVLnZdwQkxKQ2kf/gteBK9CfN?=
 =?us-ascii?Q?vIVk/SaNMzOtaxvOMk68r6V4x+IBkEsELOuG+qsRNV5LDNR9Xaoqlj9+wFJv?=
 =?us-ascii?Q?fLqLMHy8pDMhEjGYA4SafKLR8ebyO0ddcthTxa9L4SPDetrHKq10KP/81xTA?=
 =?us-ascii?Q?cGWRgHTgGI08qtIVs0FXUC+NAz8aW+Hh+dAhAn/YjJhsZRkYHeUOcyI+U422?=
 =?us-ascii?Q?qpd6TdEPdfdkI6/ANMAfJyQR5oi5mV1GXTLzMqGMqhLCCYz9ZBXZxxgNlJ4n?=
 =?us-ascii?Q?H/dDWHOTq4VmGDfEKK9QtvDQ8BTuQXEuhPzFTAUCDunUUnWOXeRVeoEFCiIn?=
 =?us-ascii?Q?8JyOlmG/61QBCdWLk76Eee7GllU7pFp7NY/P08Oyf+wyN6oK88fEw/8aEMQa?=
 =?us-ascii?Q?qIHuZtHKBKlBDAYXTUbd0L96H9bLqMbIhq+xHIpzltnDF5KD4FnyNMcCa33s?=
 =?us-ascii?Q?vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1LjvbEchCOmJVbNLVX41Q/hH03CbA8P+2+BQnHLf4V5i4fu1ai0GQ3Nk1ODK7Waf2vBPGigU8MEkdfapMgaSxO64ppD0eD8J2LGXt/xFiL37PX3SDrfGZ96xifJXkP6lrdPK2nsu3dy3HtMpvBOal5D1NVFGAFGTaDNeVEV8gX3xdrdnxnbrFtITsk2sSdpKzooT+o+tDJTeVS1k4CMwCR5aknjhX0gzaIjItYxQotJ9Vpv8eoMYYzxNTB3F0j2n6EFFDVj2yeal4B77Bw4oOhx7kcN3kiSITffP//CIem0yOTmNkpVxbP1rI2gLpr78+TGfz/7Vy6HqE0Lki3Ah1KxcLuOs2h+jmrhEEM7WTieNTZcmNi0pbO4z4AALX+W8QoOJrbmR8Yt4lXprTekibts+n1nCPMW5fI/Zaaa1n/O2PhH1XovEShrsZadu5DTWQVDz4DUwbDahZngeXfq634MrS8A+nTfmi3TPgXbd+OOKxLHU6dnMK5CKQecLzpfgeNWqsIA35TaibmQ7c1DAhA2TXGcM9HpWeDcfSy294lR0JkqrnwTTS9n4qXHL+RtjIY4dh503S/6IyW7mPBlNdISlnV2n3IpvD8d6AwTmqOs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2ab6147-aaf8-4f0f-511d-08dd97b76a58
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 16:00:17.8327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NXYca9o2B31S2dXAaxpAMSCUqwWRxIz/3YKoWR0g1qsuL+GGw5ZsRv4OfwqqUJyNYxX0Lt7x3hC96MyvLvOCo6Zwg/wYxMOcuEjLT+X4g2I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_06,2025-05-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505200130
X-Proofpoint-ORIG-GUID: c0RVD75CwnGHvmqIFZMbJv3sm0u8lV_Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDEzMSBTYWx0ZWRfX4+OfVtmtCJ9J xw5YNK8g78M1GpE9vEXtET3HuNh1a/BTJoBRHZwkWLJq4vXTckKoFKFNszcxr4fju7cAazbseXQ b7VSpYwsoiatOJWbxHHBzE5lWMoRy219ylCG0ziBtvU2e8H0lN9i2y9wWPjrq5LFXrLMHLfNXTi
 QK6VCe1+NKQDKiny4V7UXFy+gnFT6K0IAAGxiJKafs+7GdIwgIovLXtc3JDE119Z5Y2UnN70Ta7 oFr/XBRaQedgicDIZAnXlmwddvuANiQ6qx78XlDSLXpf2DxQYmdwTq/QmDrMDKKML+HXBRyXezt 3EupSdEyBMZs1NHE+MT8r5DHBh6SjZ7G/705zTt9tICSm+kvPqYpnEZ4k0kYjGP/7OkwbgDxc7o
 WVKElxlev2nNz7LcGsDg1QrI4cG3MZI16vzTQX2SgvWdwenSGDnv6938Od9teP1K22Ll9bXf
X-Authority-Analysis: v=2.4 cv=Qupe3Uyd c=1 sm=1 tr=0 ts=682ca715 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=SVQQfSjRMWSnINH-ms8A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13189
X-Proofpoint-GUID: c0RVD75CwnGHvmqIFZMbJv3sm0u8lV_Q

On Sun, May 18, 2025 at 07:45:31PM +0200, Dominik Grzegorzek wrote:
> A recent patch that addressed a UAF introduced a reference count leak:
> the parallel_data refcount is incremented unconditionally, regardless
> of the return value of queue_work(). If the work item is already queued,
> the incremented refcount is never decremented.
> 
> Fix this by checking the return value of queue_work() and decrementing
> the refcount when necessary.
> 
> Resolves:
> 
> Unreferenced object 0xffff9d9f421e3d80 (size 192):
>   comm "cryptomgr_probe", pid 157, jiffies 4294694003
>   hex dump (first 32 bytes):
>     80 8b cf 41 9f 9d ff ff b8 97 e0 89 ff ff ff ff  ...A............
>     d0 97 e0 89 ff ff ff ff 19 00 00 00 1f 88 23 00  ..............#.
>   backtrace (crc 838fb36):
>     __kmalloc_cache_noprof+0x284/0x320
>     padata_alloc_pd+0x20/0x1e0
>     padata_alloc_shell+0x3b/0xa0
>     0xffffffffc040a54d
>     cryptomgr_probe+0x43/0xc0
>     kthread+0xf6/0x1f0
>     ret_from_fork+0x2f/0x50
>     ret_from_fork_asm+0x1a/0x30
> 
> Fixes: dd7d37ccf6b1 ("padata: avoid UAF for reorder_work")
> Signed-off-by: Dominik Grzegorzek <dominik.grzegorzek@oracle.com>

I missed it too.  Thanks!

Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
