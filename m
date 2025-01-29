Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5636D33C5;
	Wed, 29 Jan 2025 03:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738119646; cv=fail; b=eTvfKXX1aCr7z5n0OYeIYtp6y3YSv9SKNN0Eg8iCiAMr4GgwDyulOOLYLDEAn3Ftv/sdfD8BSAMTGUMI7gBLksLt2sUztGxjnover7wVNq7n9e5UAEMhVwymtH01XZreYFrHLI2ZNsokS8am+/6xb3otDq2YuBfRW+G5ufonw9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738119646; c=relaxed/simple;
	bh=7O7r9EgDZmw2EAu9QuGTgeb3hGYP5+/yB0beGsm89C0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=lqQ4Zh5Q/Yuw8z8CmiIDgQBGrtxJYRgLc8upPbRFIXtyhFLi4j7CzrCwjLUywKU8ujph6dG7QwEqwFlT1gVZ1omJyIU0zRLVPThF+MzIBjPLR3QnB1Nw8Df2lzLd8hbwEPQMyN5jLPpdWf/ayzWJZwZD/YyvN8Cl05s3sFiJZ0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dm/GHCMY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CADJ2e+W; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dm/GHCMY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CADJ2e+W"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50T1bPUe017682;
	Wed, 29 Jan 2025 03:00:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=5bKTZFQrXcQjNyZP26
	RR+djeG8Z3cxJXDEz2sknOMAg=; b=dm/GHCMYjEz7tt3JArCmIIFlM47kPp8GkR
	dq/dzBSbgfidZbm1iHaqf0PeJkSiVb7lerKQdsCdV3ONWV9A4fMe3m/gZq0JUTgQ
	4jmKwd3K9im/2s+3L6fEIOeNS3OanRw54m8q+vFd8tRvh+0iEVakdI/qJH/gzODH
	6StvTYzT8J1Mnp6BA0z8u8N3251vpkgcfpKOfjSugTdV7EqBbK1RV4RxNG3Fn6rG
	06v3uOj2/nDSm5USkJmqI+KXjAm5O21LfmK4mHWxpiFeG9ZR84jOvZuacxXELawO
	q9LLR0N/mxyBI2jRRMHi0hRBUVXD/T9L5leiLX/PPXSYKRoiuLLQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44fatsg291-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jan 2025 03:00:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50SNxAbs002859;
	Wed, 29 Jan 2025 03:00:22 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44cpd98be7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jan 2025 03:00:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qn99UjlA/nmpvasjhZzvaxrDjikZaypHU+xCYMmLwdqNITZO3vVLobEmkgFWZnrE/sCNDuTCRM5rp7NTRkp6G/78Ljqe5CZQTKXbI50cnJ6mxjWWkvvderP7VijaJMqSJ+uhsE+FGiy+7cW+3fbPrJUIwo9VTP3dhHhvl49Jt99V7o8XY3bcNgmHVWH+klcj06P4EXYcxH9Ed4hhsiH/PB7/ZssnxL4mRt81TkQ6wUQVzDHf4v6P/Ik3lS/zejUOXBmZvQvVjpRGygzXqfNct4MTAalrXg8XYJNiSjlJ3acqfvO2PNOeY+VE/x45hO6xbNRNiZVho+Yil0mLx7FbAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5bKTZFQrXcQjNyZP26RR+djeG8Z3cxJXDEz2sknOMAg=;
 b=hDVKpaGY7TnHTZqOyQ4ZoXXhK0t4WI2sYXC0ya45Q7teMwCl1bF0Vki/RgrfWfjk/+XRUFj3Cx5cOOQWYWuagWzfYZZdm2PmC+udDa7WIuNA1pplQOfzii/T57LpuxYAU8z+b6QwVeqIGhqUIuXl82wgHrZFSm21iUHGMvDyjwc9TK9dIQ1QKFYb39w9FsRRcIq5Uq3GTRR1JAsB0/YckTtCaK+AeiC5D6DZFe21DSNjBTJoTiK83gwSYnXl6J+PYxCfoMVzItKKDFNLURcO5HUinsoXxN8Mn0YCcJrbI4x08sQ1f0P6akJTGlWw2n4dkE+nW4LpndsmCGwsGyQ61Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bKTZFQrXcQjNyZP26RR+djeG8Z3cxJXDEz2sknOMAg=;
 b=CADJ2e+WPiv1l59CXO7jiXCBhN4I/H3s4GB4l+vCG+Wwx0IV3Cz2LQPJUQALSEGr5HiMMiTWeVQ9crvaCdIrytNX6OSgLoTB+kfPE4WazquVsOJ3yfdTcEbOlDtWGzqwmWqveczg7a8cLBONmM2symFHy0Fd7BYWHyJxtcxwdZk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA2PR10MB4426.namprd10.prod.outlook.com (2603:10b6:806:117::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.17; Wed, 29 Jan
 2025 03:00:20 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.017; Wed, 29 Jan 2025
 03:00:20 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds
 <torvalds@linux-foundation.org>,
        linux-crypto@vger.kernel.org, Ard
 Biesheuvel <ardb@kernel.org>,
        Chao Yu <chao@kernel.org>, "Darrick J .
 Wong" <djwong@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Theodore Ts'o <tytso@mit.edu>,
        Vinicius Peixoto <vpeixoto@lkcamp.dev>,
        WangYuli <wangyuli@uniontech.com>
Subject: Re: [PATCH 0/2] lib/crc: simplify choice of CRC implementations
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250123212904.118683-1-ebiggers@kernel.org> (Eric Biggers's
	message of "Thu, 23 Jan 2025 13:29:02 -0800")
Organization: Oracle Corporation
Message-ID: <yq17c6etjdd.fsf@ca-mkp.ca.oracle.com>
References: <20250123212904.118683-1-ebiggers@kernel.org>
Date: Tue, 28 Jan 2025 22:00:18 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR12CA0036.namprd12.prod.outlook.com
 (2603:10b6:208:a8::49) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA2PR10MB4426:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b4ef7c5-8870-4710-f675-08dd401110cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bZtW10eaYT6q4Vb/gGHFamgI+/0X6I1BVxymLjwXukWc3HBMZPBTF5lIAYPp?=
 =?us-ascii?Q?Igg9GeiPxG25YRNDnQVuk0vv3lFHkGF/+hl/AsWS2bYieLzpf+93MQOajm7J?=
 =?us-ascii?Q?Bj225Z+nvi5Xx1W9/Jew9HJrtHTGEbSn+108y3OKUCdjTcSln1zfygSbIP1j?=
 =?us-ascii?Q?T7nZSH2Gsa2pwE/tov6PIA3E1pNK3wAG6UE78yGX7r/7QPJz6Uzxl7U8JuP4?=
 =?us-ascii?Q?0BGkASceyjTus2VSuSon92Uoo19oaUKawb2bdXOpVF3Jm4X1nIbbfO6ZUeSq?=
 =?us-ascii?Q?mvMUvlgsJQyZ/Zu86DwdeNpMpfQXlNmP+mOAZW/ZhUL+Pt8GeVU8FaW/NoPW?=
 =?us-ascii?Q?lXZTTuQ9YjkTeZT7nicUCrCycWIjCnBs1LssBUOOeib/6vsxjvABUQ3o4W0c?=
 =?us-ascii?Q?N0BVKD2Ss2HsAX5EdAhsotT9QIyb0sw+DRBbR05il7Rj4wp32SB2oStkd0QR?=
 =?us-ascii?Q?rX/8L8mPA/q3Z8hkx5fNSprNPsyB0imInn/Jp8H9BFahEqJsbzKPHKSAV1ZJ?=
 =?us-ascii?Q?PkYwG2ixs0VcgfL53wnfUxvV7f+f600XxI51jN3q/j+QVTRvs9U4cKZARTlD?=
 =?us-ascii?Q?0U9bdXRO2WBJnlI+pXuHDOitl4e6gj788F5lDK/zbsiaH01moL+LwresGH6D?=
 =?us-ascii?Q?h5Bfw8rhtn/uCRUFdQth7rjnlA9JgwusUeg+yo2X5SIDpMzBGGd9hPHDDpvz?=
 =?us-ascii?Q?K7DOp8m3url8D9O8bzyW52RVLCilBo1m1V1Hkq59znooLr0OAsOKt9bCdWQn?=
 =?us-ascii?Q?ODhywmh0SxZCyuZnME8hj1W8oyBd4RpB23dbtvGe7/vSHmEZeDYgSzNM1etZ?=
 =?us-ascii?Q?3vPf5LBqrr9D3aK0MUhZ5ehjql7y3KhNIJFRuYguZ7VqJUd0PXUa2iIEVL1l?=
 =?us-ascii?Q?oyDpzQXvqBuZcTk5fqgnpcTpkOjnfHGhQfesU/BurnGuRXRWcPM8U8G8s+7o?=
 =?us-ascii?Q?5gqZjRG/vx3HIRwnumec0/8vwxnlkXULg758XQDcSNRHYAtxal5jD/caytrW?=
 =?us-ascii?Q?UVoYQEqNTy51ZCBq3TmUMkHLJ+c8r4bowGpUzbY/hedH39x5kotC8o8O2wNY?=
 =?us-ascii?Q?nknbGTw7SjfVr4K2dCElpOcLM6qz4ii7dBPmmqESj1mLDHsxYD36Mij7CiV0?=
 =?us-ascii?Q?8wwce1ovmAw7Le3ZCwwK+GjPBVb/UvXGzJb4o0SopLUBqdT6Zuub5MU3zNwQ?=
 =?us-ascii?Q?D/vfgcwIIu6UDZvvmT/Pe4Pdxk8sHYZP3kxhKz2jDYX974iWtX7a2Nh8XBnD?=
 =?us-ascii?Q?Ba4Seqj1CeOKi48+nnwCCfdAl6TyicrEV0J24kXYP+6IY1gbWqh7L1fnh7Fw?=
 =?us-ascii?Q?8KfJZS8JjP8iKu0AQQPtNUkjzO8VFiB1jqxY0nF7Cq2OCnP4weCRlMegff8m?=
 =?us-ascii?Q?11jMB0ZnH3ofnGo/IgWS16B6jjWP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A/mdAt8Giit0LVwmD8s3Nk315b6uVitvbpNyniBkSrGj4TjXSZrlGcgXUHJP?=
 =?us-ascii?Q?YY180wza1eym1l4hzHLeeDZ3ZjZH8fVkwUs6aDWAqmkldxq+qXHOqM2Ku2w+?=
 =?us-ascii?Q?7tcAlrwt+YejQEm06FOwLojbjnLe1wj8E9QPuofr3cr5dul1EtT6xkCJkMTR?=
 =?us-ascii?Q?YxsJeHMhF4/TQ50RRRVWE4iK5Se/v8RTO0RAE6/qqFHDc6QISYTDM3CVoGh4?=
 =?us-ascii?Q?ZkIraljDxW+6j9hLG9um+8J69bWDBVPKq7emp4DaTKXILzhWKgj1nPspCuEq?=
 =?us-ascii?Q?nbeYHMW4WthEVDvf3sTr7C1zXbq99qdjG2AMo86AMUZw9lSld9j+27Aijt2J?=
 =?us-ascii?Q?yaMlEYKJPHuGbMCfpq4J6P6UiXFFCfo6aLKY7bRutNy66L/GwI9dWqsagZyD?=
 =?us-ascii?Q?YX2iTELvFH1p82UIlcW3kYXpEmY3ybXbFniA6zurb5DmXDoqc1CO43InX/bW?=
 =?us-ascii?Q?pCHVJkbbcwH4Hr3Ktnw9Eku66mtCNa67p1s2/dZcYOn+yquDLEDuNSMrwblO?=
 =?us-ascii?Q?wP533YceLjDu4swEYwv5Gdg3n9j5k1i3TwuPikolqfo3O4wp4Q+yiX5eVgT4?=
 =?us-ascii?Q?PKrre7znlGdKHgkRwif/TK5uyASSP71Ps7sTciKcvLig1tpYmJVnPK7ibYth?=
 =?us-ascii?Q?shY+KmGKvA0gLTObVqhTO1RZhyxz8uChixLavcVhVb81ovZSdVZLm31b6An6?=
 =?us-ascii?Q?ne7XXAhnz4T+xcYC9TQc1RrhI8oN3FfW4TGGLQoe/bFkm35J5XbwxZhcl2Kq?=
 =?us-ascii?Q?0z7XgyHthnGUfMwv9mkkNUIuT4oqFhexEM0/k+H2JPPbexC5UzDAVKYCcChL?=
 =?us-ascii?Q?q/+LFnVttMwB8cbIPo8AxaFGb/TTSy7Non040ugbDKocAyeclYDZaKpVw5I1?=
 =?us-ascii?Q?6zvy6sSDHxcj5bgftbqryNpNHVTmEIc+W2rjzRLFWqea/cJMrd4H2ns+O4T4?=
 =?us-ascii?Q?tlFnuT2czAJ4stmIaPV3UDkSmLPKMWI9p8QMDaaSC1PKr+pG4vW8dzbX50zN?=
 =?us-ascii?Q?BNnm90G5XDP5bPgH/6BbD6EaT8D8ANWPxtN4fGS+FZakelfe/OpH+HwSTRXV?=
 =?us-ascii?Q?oJ4P3rPxpBo4Lc3fle9tYiKiBkbJH00y9WILESV1Ec3ALrBoHcyLGc3a/7Od?=
 =?us-ascii?Q?+LkS2NFfetQwVdlYLwTBdQkvels5tCK5wSrRLhnLpZzM1U1/Y/BJnL1lwb4B?=
 =?us-ascii?Q?HNaBdbY4hFp5Jm6x2ZXocpS9ATNye/B+HcIL1SgdbuJPzdZ0sT76bAKaaTFw?=
 =?us-ascii?Q?7RUOgL4Y9ekD4tvZkmlYsH1DWm0E5j37IjtEVYdUBCL7Sxg41iXtO0mg1k4v?=
 =?us-ascii?Q?+7cSXVVPLXKFsC9ULFd1E9y4lTeoOopp8VPeOisnFAzTbs7Y0IR1sgfTSknI?=
 =?us-ascii?Q?aKTVTcjMYi6mZv7ld94bBRkZrobY3iGqok+QnRo/AZBHJXwfNBmD1VIc3rMr?=
 =?us-ascii?Q?k3rYwXt7342UOTUv0/aN/SFh4bLVqJ9jiOJ1niU+j02oez1b3eidn93ghTjx?=
 =?us-ascii?Q?GYt5xjjYpi6oDntmz26xFkBXdOu7qscm/7i2auCkg5p00PZlS6L4gFYIFauL?=
 =?us-ascii?Q?5A0ZwGD2HA+R4iJOhVUidjwGxccAN8ONTirkBAbBx+6TJsJkFYiTy/mZAUf1?=
 =?us-ascii?Q?LA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pMI0CvFMX2m189Ulw+BWodzw9WoNE+UUL+S+7DvacI8DNmGA12PLfK8jxLIY//5omtyva8AmounRHXJm53Tx0QtkXfx2dAP1SD+fYEJVyJESftnU7tx1wUDM9f8AUqONh2U1278ci/goQ1w0nB3YomiNTKOQ3s42vnr7b0Trx8uuGqVgD6fqn5a0RZME9w9Zp7j+tdq/vYDz4rwAVYR0Ju9vm2cTVIaz3UBxpvWoJB9bWN0xdTU/K5hdxjn1rZPDT3a4gUqdFoAuGHBhWw9Vwm+fePCaf+sLlOVZXjOp17HrHNcV0VNaNsLgNXgJ1LKVyK1bdt1OFIxcLSzZkq62+ixjkQYC1B5rdpt8l2M6nXMXNqXZo8Ew8knFSNiL/kf4Rrrmc+iezt9Qgrso/3ocGWFlU6OELUkCPsSKGmLVA8+4+PK6kkUsw1U32XBzmoTIg5MRVsagXh/GSdABtkMMxmAjBMbfmO8xr4swPJ1K2qQMR8Sjzv1IgFJspKcjIVc1B0Ns9xBhNSJbD3NHDGO5scTlxlCn8I2x6mXLAPuM4Xu4Y87hlK/XJ4j4goIxDO92AvqIQxnR+hWHOCUvuojRRiPPii2SN4FDdtVUkecFVrA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b4ef7c5-8870-4710-f675-08dd401110cc
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2025 03:00:19.8833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6jlMc5og8OPuRcSPo2N3dMI/r/QvNOxyGVIlQFn1M9e66byRjwi8CovXSP3JmnwjEDwvjFkXZvc/oAQAeW8daWXwncpXGfsM27GBZcF4nXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4426
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-28_04,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501290023
X-Proofpoint-GUID: Zw3Wo2B1jOqVhbfl2vYMNaWumSdmt5Ln
X-Proofpoint-ORIG-GUID: Zw3Wo2B1jOqVhbfl2vYMNaWumSdmt5Ln


Eric,

> This series simplifies the choice of CRC implementations, as requested
> by Linus at

LGTM.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
