Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFBEAD4C;
	Fri, 23 Aug 2024 00:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724373928; cv=fail; b=gbGidf+sfD81i/sc2D9rZ00Sr/qvqtXDjG9VtK+ayOnXBV3JaJKvytIga8iHeHolsCrAGBNqnnyD9Hfk+w3Hh4jO9GIIjDrJDgsTxWbEzPNBskVY+TE1SLel5jloOjY98oKlY1Hdkm7r+W6EAgR6mO0ETZ3/dO9nCSvNAbuOiU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724373928; c=relaxed/simple;
	bh=3yhN5zFu1t1icueuTbXzC0yxCl0MiYZ7XqkdmtmEurU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lPspKooIsJhTIfjk0OrxaJwJOUZ4eZTTUqNrqJvLnvM4XnkXliYCGaLhIplnzMQA+Glux/eSWqWxao2wlnzey5HcNreUanZfz5F1RYxwx1KlVNmLVSvBXK6Y85zBRhHYNJofsaHGPjpHA0KGzbqPmcB16BoZioin0oYQVEgXZzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LYDzSUaK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nkb0SHBU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LYDzSUaK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nkb0SHBU"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47N0C1o4023348;
	Fri, 23 Aug 2024 00:45:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=pOEn7vVb5MCF19w
	8/Tk4N6pXVzHqk6qFgwclROh6V/Y=; b=LYDzSUaKOVwCXJsDf5uz9D10G10hg1h
	lnubpswlhUTuVHAGaHlep43o3pw7EqH9TAgcA07riBs0c1UmR2r8BxH0t2ySbwKZ
	W8aMn7GTxrmR0DouJOFrvnSiF0cNHUTpzS2rgiwjDvSfmNEZ7iHtMQn74nijiD2D
	Dz/zdUeNeeOEJwlPONRuF9FslShDncn6T4Z22OmFAmoOObl9SXnVEjwy21S6cttM
	kNSaj340gE2xKiztAenLOEFwYLcwGN4WtQRNRCzpX0k+DiZCmQ7AoaT7+Fku7nFr
	QioNdB5eiomNyOW0fesgRAMDkV2PRN9mFMx/DWBEX+VT6IOoXrEky1Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412m3dukdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 00:45:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47N0Y8hM011957;
	Fri, 23 Aug 2024 00:45:16 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 416g0e8715-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 00:45:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lbsh06+1Y3w+Im/AnCGUMxAEgFCU+/skeQiR+6gqbZr/91LPOH9868Sb2RJ2rD67gAoFg9+4/2ivlRkjKT4gslLM9ZiUEJuFZvjC9Zz5cgm3/sJYCY3s2LQYwmQx5OBRkqs6mGizcT6iQlWU8rtDaM7Q3U3FMNfGgJo7I2iqwG/8oHFi4+bplsS3PpzAuOzUokaCJYQyH34whmBSeZTM/dx4x0a4CQ+UTlyEBePp+PfXaltvTPWNS+oDstqy9Fwk+jQR2uuWee1wHgDAvY6402KVIdgqYMTa4WHwv1TH2JdnETqkk5qMzc7/hicTxejydua5hgE1vIFBQuwHgNlgVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pOEn7vVb5MCF19w8/Tk4N6pXVzHqk6qFgwclROh6V/Y=;
 b=QlT/mXFTP83vtKIWKTSdG3lk6IWxBdWSQGAuLL+MMtJYzeKQUkJ+z7O1yFg7HwzYR4eQnTu8LcnkoIeXd4xJUdAeJPtIDlmy3/9VFg9/STMRQ1jY4WPzDk/Z0O77nSn4SRcwBN8hZ+U7yKhT7AZK3d7NbYxbeR4vZpV1SkbdXJ/Wo8wL6O3/O5hPYoPDjN/d1xIFcJHaFszCTLZO2lUSf7KFohwE6HJA1hJHDVYkqpXArrPJVqagcIvTAzUiNC6oAFurhJAEQB56Cw7zrcZz0xzyyRE8gyj2CNAioHxAOmMFxAthshsc+t5UAgXQ/fYgBJTgbfgt2KnSbnDHW8SoTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOEn7vVb5MCF19w8/Tk4N6pXVzHqk6qFgwclROh6V/Y=;
 b=nkb0SHBUx9bJjGrDnnJC7GyysWTVCZA9swYXSqmbf0yLvLRN+vZPEx3ehdahLdZPg/ifUW9AXGQi4iMKWH669sD3r1zso2q3mkrjTLRfKHN2BoCgIc2lQZ7enqANR9/dXi7YTfJvmgEFaQ3hrkS10wRbld5nM9zEEFQWCpRLTx0=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by DS7PR10MB5949.namprd10.prod.outlook.com (2603:10b6:8:86::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.19; Fri, 23 Aug 2024 00:45:13 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc%4]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 00:45:13 +0000
Date: Thu, 22 Aug 2024 20:45:10 -0400
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Kamlesh Gurudasani <kamlesh@ti.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Waiman Long <longman@redhat.com>,
        steffen.klassert@secunet.com, akpm@linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Fix possible divide-by-0 panic in
 padata_mt_helper()
Message-ID: <2ue3ogwfxwmnhncikcuwuyon6fpr7nvsbe53zvamfla7phppd3@ydwm4rvb3h4a>
References: <ZrgsU-1PdxvUVMOW@gondor.apana.org.au>
 <88c188dc-3664-45db-b54a-11feca59d7d2@redhat.com>
 <Zrgy1TDikPSkzaYP@gondor.apana.org.au>
 <c5cc5ea9-1135-4ac6-a38f-652ed07dae17@redhat.com>
 <ZsBNZXfVZbtZnb2Y@gondor.apana.org.au>
 <dgtppozpgkm2gtv7nnvranbkjudr7bwuvfe7hjbznipozcxyzd@3qcag7izn4fj>
 <ZsQWV_j5zMuYWqvH@gondor.apana.org.au>
 <3kexyvcrc5pxp4cqlgt7tvdbo3hbt225w76kczjdlzwitpeuto@addhycc4evbe>
 <87bk1mnvn9.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <878qwpoa3i.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878qwpoa3i.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
X-ClientProxiedBy: MN2PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:208:a8::42) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|DS7PR10MB5949:EE_
X-MS-Office365-Filtering-Correlation-Id: f6d6de66-a25a-4f64-31b6-08dcc30cd927
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lQ5kevsRAH4jPzXk98IxjcRk+n1c2p22gfFvmw64dFjItOIBm2xG6PQNxcBd?=
 =?us-ascii?Q?HXkjml+VqtzEMK7Ftja31QY/plKmSBIoTxkerJR2hp3z9aKrNxKgXHihvjM/?=
 =?us-ascii?Q?Cknyhp8VzcQGvXAj1Yomp7TLE/yD0DWpPLj+d2i5asBfVhV4UIWFGO2CUC9G?=
 =?us-ascii?Q?begaYvnxIrpVUGRbHBMTk40FOAdT2tBPyRwnCeRoVrT3cOHWWJ7jA5nWk3Mb?=
 =?us-ascii?Q?RuGaKbIp5rrS1fPu8jJ0nfWFDS14jTj1QvwQ1ucTIOPLfRc3xOF6xL6WQ8GR?=
 =?us-ascii?Q?PoWMCOIj+OhsWxIY58Wyy3E76WXdi4Q1uhZeLPFWpGzWjScyTcdvWAbswBus?=
 =?us-ascii?Q?9lGChpwM/Xb4b30M0SDYquUNhADOXa9QDMCNo9EcvSY4rP4XMYQ0NDq5qfNQ?=
 =?us-ascii?Q?x25m9gzlP0OjOI1KAZBdt2roAbOPc20OtJAOQzcNbYcpTqu7sr0rjhLyrvSt?=
 =?us-ascii?Q?fiahBMcB5ApV3rJ+uAeUmi/riSt4bCtJXE3EwF39pgJFZ2ir1cRo6PckiBWr?=
 =?us-ascii?Q?ManhzP7zpGdiKwPBqAiVK1EjgWNkHZspeeLV0ArpXSkprvNTIWtTfIJfT7wi?=
 =?us-ascii?Q?Fglb6jYkhFAa9HV6OQv27UPZPqbxpeBSAVvondDpPX3YJtvdnBwcbK9rMHm7?=
 =?us-ascii?Q?VO/SQ1oOGTC5bTeFJ/ly6DMFDXyF1qhZ0reBvh2x0HdvgJRpZF4U8FCgPLtY?=
 =?us-ascii?Q?voc/RpAGEpIUb9z26wscQD9ZBvxRdfwsume1XQl+br+yXahk9d1xNhMT38yR?=
 =?us-ascii?Q?f1d7Ck4qBbJwrSpTh7hwWzhcKlRQ63SKRg/T87bkCwtQFY6t4B+QMwdHxCaf?=
 =?us-ascii?Q?XFcidPo2CZ/O5wFjlXgMJ/Yv1k3MCliV9UYdmkEGH2qEC6lVlxyUHtqQSZs/?=
 =?us-ascii?Q?GLzUz4Sut4ua0823ZnJc/NJWJ74erOebFBEoAIcYt63cwz1C9l+EaQiWEjFN?=
 =?us-ascii?Q?Ii9CdqKzFep0mQ63rQTKeFiVC4T6gizb81HUDVv0LupFzUAzwfe57lqWCcH3?=
 =?us-ascii?Q?f/hxTkKR/OQ8zl68QMXuvjZ89oyK9slBX/oNv6+M9HcOGKRSMyU1kKg3wrb4?=
 =?us-ascii?Q?+XMZ+u2KeyyFsln6kOf8mvm8Bmesqbj8CQT6U15iOjHA7N6FYQamkwvPq/YP?=
 =?us-ascii?Q?m/11Qy1qnEuMFkoRCRuz0cP/nvyyLqFxK9NxU9tG0WXvzKZHas4nHEQgiB9A?=
 =?us-ascii?Q?eEduJvQLySMdUcO6jY5mjY55Cqc2e/GeVDKztyxj9z93ukir5CzIEsQ6v11c?=
 =?us-ascii?Q?oL4NfsUl4zF8nxPsjY69pJ6hJUvZc/WgPOrNhG5qdXhEQj2duV3XR3Ugc8xp?=
 =?us-ascii?Q?+jKf6PgRnOhHo5CL2JCKldmXq6RF6nLzi2GkfhKQ+KPBQw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aOAB5rGhkreGkftwQUoDo75J/hiRZ5Lf9qJAS+EdkycDMb2I3vM/MKLbANof?=
 =?us-ascii?Q?VqVlzvxCxlfUOjEt5kJFdHEJ6cZSdxUyV1lGUXw4xagmMpCTELQmVjIKCiUR?=
 =?us-ascii?Q?KQJGuYXCxbYFAOSWoHprZ1Z0/6YJPDaabZRwzfG2rxaYa86Y7V6U/P/mRRMC?=
 =?us-ascii?Q?8oIC01DXCUbpquYgyWn3hh7A7b8EagsTIapm1WFaXz1PI7aopZHZwqiKXfEi?=
 =?us-ascii?Q?WIrgoaMRHMl8vm5R1+Qxnu9YPDJDONwpetIM7cfW2JU8o99G2sphooE3EofB?=
 =?us-ascii?Q?al4ERTuxD3/cB/yqtWhE39Semefk5Ork28vkRlSLScCvFvH2FOcjzywFUlKj?=
 =?us-ascii?Q?Em6nRKV3Ibv3wcr3l1A/Au9hr2ZfaRJzQzzm5XD8dSZwVxeDl4oMYAULzw2P?=
 =?us-ascii?Q?Z9VhnGs+Fl9+0ugRM2fn2Ban/UIp95+A0cu0+3AB9kq93UCs/c2QtBFUoBB/?=
 =?us-ascii?Q?Qa2wXeJfnPUXh7aACAjCp4LwAatceX2TNywardxpwvHPP8a9yKgjeefvScac?=
 =?us-ascii?Q?GjINo7w1qeEZTo71Vjcrpc54AmVU9SCpdOoYixDJYE5mSodJLzvHJNO3KMWs?=
 =?us-ascii?Q?1lp6UNsvSccfKNVZl6vVAp2AmQDzCKsqsbvTxNFgUSQuQHYAce77N8+QSX5t?=
 =?us-ascii?Q?x0x5S0y++PK0UZgAe1n/oVPDFJeTJeDv840BcFJcAoJ9zWqZrzgcpWoQUwzI?=
 =?us-ascii?Q?HXGri2hcu+I4BiSawF03pCFx/PjfzToCXNWOmZv28JG0jPMpT0MwCQ2SheLy?=
 =?us-ascii?Q?01vT0NSzTKrH/eP2/EsQVwS1/eZGxwQaJZ/iuXW5GMzLZUGEf5fdLEbMudKy?=
 =?us-ascii?Q?REEpxdwc7qJfyS8OlYeNjqA4HEkZhqZTeCyXamtLzefNZ9m9O75zOA/w0cj/?=
 =?us-ascii?Q?zin0D9NYEmLdQdJqza3PfWVeHbMQjFwgejxJETchN5z3cAbtF0kdUdAGCuFQ?=
 =?us-ascii?Q?CKRT4kdZXuLd3/EStTMHBDU8S0FHFy9fAqaSSF8LaZPwdUlbr46QsJ6SreFw?=
 =?us-ascii?Q?c268QPrPfGnWMfvhMGWpcjS5ukHsOBsZgnsc2FV9qkMh98VL+WD+2C3wbsEz?=
 =?us-ascii?Q?EEazwCcMRRtvryf7tnladF6895CIUhPw+QnlNbswkHHc9aRqbMJaNxobwPAQ?=
 =?us-ascii?Q?7ekQpAVe7sFKrYKn3w2tds76IM90KwaynXvyyr5wE2nHs4bSPfM04Zpjr/NA?=
 =?us-ascii?Q?63xuUsUggO7UP8iZ0WwGDy7xpFHJFTU48Bk1wqLlNdOFPekSbZ90n6xQKovQ?=
 =?us-ascii?Q?405F4JZHrWoElZDFMZjw2KVZyjSPXtSafFuX99xpfSak6R99mLWinLkzdpQi?=
 =?us-ascii?Q?4tpX4SzA5ZAyE0DuehnzYIR+mx1pn1JepZ5VDjdI6JlqR4oUgmDk4q+bjvxt?=
 =?us-ascii?Q?K4gOszIPiTF4ne8g7GRQ3LfYbv9jMRhEIFTvYlC9ZzSVhWHLHKVlv6R9OyN2?=
 =?us-ascii?Q?RqVutjicgtbeqyyI0+/3oByFJjq/bnSr/5Z3X9GASU+CsLoHsfE048IY0V2g?=
 =?us-ascii?Q?kckyIG20TQpA7+4Uzlt5F3O+IWpxyF4sratStlPqD12oBtWBE+i7bRzeYb9Z?=
 =?us-ascii?Q?6fd9Gryh9sw8YLc/U0lSg+5LpCY9BmA9g4Ox1sgRQyVromsLBhPntrd+MINI?=
 =?us-ascii?Q?/g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3D8FbhllAjAe0XgyCkMOXFqxqBfaKcYAiYWhfpESpUtI2y3M9r0bcXI2jGE7DylClOVaJn4awMAjMrqm4vFK8WrFY8mZWaLm79HpxueTW7pJPVONxBTy9Sy7ZcOnjipMlSVg5YkA9QgV5f2PmiPQCkwwlGOJ3CiICsw/kPEGd+nlJelUdrsLSuGGmc7tLDrny+D8HrI/P46i8p5fVnQMOsN3Jfl1mLDeu27JbtQPPd91By0YJ1g5GMJfSJxBUDGB/Vhr6X5WF4WDQCvAnSeU8r8uz+P6ZPZEBI8aHuVW3FHPXBCAEkLJiJShppO3yIrkooTFdIJOtUF6S6ecxtds1olrK9QFOYLXFMXxl5Q+650U+HhP90inEUoDEDuZ+7JnCn4wFL0Aqsxwx1hv/hIhLOngCo1Q3ho5SzaTBOIXOtvWls8y+3Nocx4JNi6vbVc6y9vwq5Kff2cAqvErmOyaTX2C4CYWDK8Re7I25yZ1ph93AQWgI3JjiRVmqbLuumrqqgmORmwztIYxWkajvKIn+wTMTeN/By4a2SfHt5SE8tdceV/LfXBqmnQpHFLybY6zhZPr8mDaMU60tb8VhxVLZWcGUqECWSAEMRHbgagoEBM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6d6de66-a25a-4f64-31b6-08dcc30cd927
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 00:45:13.3195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jYVj3H6ZUBkj9G8zK2/SrdgjcL9RIgX2v5WuriuESF0nfG9eDKgR+lvZfm4x/bfCf4rLOPDZA/Qs82DN7f2OE8lK98ZJ4NMs1LjTzXnxM0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5949
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-22_17,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408230003
X-Proofpoint-ORIG-GUID: dn3dOAlXGoVC-qcpbu78kbYsVEh_6cuA
X-Proofpoint-GUID: dn3dOAlXGoVC-qcpbu78kbYsVEh_6cuA

On Thu, Aug 22, 2024 at 02:40:57AM GMT, Kamlesh Gurudasani wrote:
> Kamlesh Gurudasani <kamlesh@ti.com> writes:
> 
> > Daniel Jordan <daniel.m.jordan@oracle.com> writes:
> >
> >> On Tue, Aug 20, 2024 at 12:06:47PM GMT, Herbert Xu wrote:
> >>> On Mon, Aug 19, 2024 at 06:29:52PM -0400, Daniel Jordan wrote:
> >>> >
> >>> > The DIV_ROUND_UP approach reads a bit nicer to me, but I can imagine
> >>> > oddball cases where rounding up is undesirable (say, near-zero values
> >>> > for size, min_chunk, and align; padata_work_alloc_mt returns many fewer
> >>> > works than requested; and a single unit of work is very expensive) so
> >>> > that rounding up makes a bigger difference.  So, the way it now is seems
> >>> > ok.
> >>> 
> >>> In that case let's do the max ahead of the align check:
> >>> 
> >>> 	ps.chunk_size = max(ps.chunk_size, 1ul);
> >>> 	ps.chunk_size = roundup(ps.chunk_size, job->align);
> >>> 
> >>> If we do it after then it may come out unaligned (e.g., job->align = 8
> >>> and ps.chunk_size = 1).
> >>
> >> Sure, I think Kamlesh was the first to suggest max, so maybe Kamlesh
> >> would like to make the change.  I'll send a patch otherwise.
> > Thanks for consideration, Daniel. I'll send a patch.
> Sent.
> 
> Just curious about one thing on line 495,
> 
> nworks = max(job->size / max(job->min_chunk, job->align), 1ul);
> 
> what happens if both min_chunk and align are 0.

That's a fair point.  It's another of those things that's not supposed
to happen, but it's worth making padata robust to it.
