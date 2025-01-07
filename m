Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FD71F63C8;
	Tue,  7 Jan 2025 18:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736275514; cv=fail; b=mc6HgXEj8BAMqjaYksDJDy36l3qa1/8fInRZnoVqtlozoFJFfIHq/an4YSmil2Ga+FUoQNK46k6hXZb8yRLc+7q0dadcGYsgVUXwsomIKL4RuVra0XnQ0G4TrP4GMXlCxkAkMzvZQTx63KKK57OCsekPav6tvssWb4hVQe5D2Sk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736275514; c=relaxed/simple;
	bh=XJeWGUPXMmzbBK6MmKpgasAiDA5zhM3FHOnnUwleMa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LPVsfrmcKJeJ+JMosq5FfZyb6SRIx9c/ziY8hb3CyUp0KDgT8uIj1LIhWpwLTadsy0hmm2ChRxMri7L1iRUFPIeSsNgkkhjvXN/pgOvc6Uqhk4rGoX/1hG9MBn/i/66Fy2aKt3VDS3Jinlcplotx6TFVfgrmEDMYi3AYV2E1MRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HedTvCQC; dkim=fail (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ryOUJJ9D reason="signature verification failed"; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HedTvCQC";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ryOUJJ9D"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 507HMqQJ012756;
	Tue, 7 Jan 2025 18:44:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=6hu9cuOZneVflH8Vl2xrCmOdHEJtjEtgeh/zE1BWDn4=; b=
	HedTvCQCs8lLvX9EHkmu/Vz6wG2KtuV5Z+ZxOjlsyJi4+A+aiAfT5RLkMOh8Dtet
	gQebhvU+vM4Ysk8STakwl4syhvBNjeAykaaG6sIZtomOWcQr0M0BkNTkEf8fO7mE
	2rnBxGwtFaqDlPI8eSI/f80Qt4BWV3W98TCR+lBrgccIWHgt7LuuM1qjqOqjD4cl
	3UtrR0+cyvTpoqnPP/BA/RQn+g6byU8JxrhR0jbqMxnLaxPEzsC8+hfuQNgWbT3r
	pcwq1DCKqbXZQXpwHJyosACzoIEUQviFRjGwZIiHxdJdI7Brs4RewDa5iTf0Pe11
	aZIZXyPKpTulpcLDfvytUA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xuk05p7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jan 2025 18:44:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 507HU6Ya008536;
	Tue, 7 Jan 2025 18:44:50 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2042.outbound.protection.outlook.com [104.47.55.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xue8ngjs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jan 2025 18:44:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BLNFzp6UTk5IfyksMFOx0JFLjwxpEKMMprOWPCFZgwyT0upHROfI7DhFYKFrauuHFz/TS9tTu9XsrZRIVSMJHPd1P0RihMRwznWMmDcgbJZoXzDMombd91DDgfNnnoP9cdOMrwDwyFv3bcai7xChZoASqmBUsqNmjGDw4PW6vSYsOlEdrgIjopvHU0Fs3a/Inlc0F5uTDJB+uMBQUnqXp2eJ0lbgcUjPUhVi9efoQX+DtPoWAqaPvCR/doqBPrA+lqKl7f6/slbckwDT28jFnwGoEl9A2KaGKUn4gsCz07TRGPZCGVknUbSZCFz15Yx/V+T3R4Zc9hQy0L2Ts5Rsog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uw5deANRiiHE+6AQfM2cvoQgvG7a0PRNhB/3XaoWYfQ=;
 b=fg9H4v+JINsfe7RxEP8UdlPShXvdg3rAqi+3EBBV8UhfrHFxC8SjCYq716veOiv3V2Dv+d7IoNn6GAbkpdedAoFgWK8Ed/aMPbz83eGZUM/p1WbZW2omYjYAyC/bJqMB5dEekcGaCGhHKOmHsB/pt96fqo5EavAiuZ8aJWJNj09Lo0HlMk7vy4CSBraCPTMB3sHAPFUWMYtKoDRYUnaCZ1WsC0EdmmWWkgyzMtHrzqMf0ugrCn/uljiz+m1ENXixJfF2mCYjt8anZYvoJOF5hvaE/qpiRMHOZ5BH1zjSighNleRInRQP8Jh6nXG3KJIeaG3RPk2RE0+nSzSlXAgIEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uw5deANRiiHE+6AQfM2cvoQgvG7a0PRNhB/3XaoWYfQ=;
 b=ryOUJJ9DhTayT7C5TTH0is6ntKw6cBk5A6PQOxsAMN4aFATlTbMhHvRD4NLPc37MivpOLGQRVCqisL2TvqPOywkwpSNMVUfDbgbklAWveY1weMz58PNedRyk8sK0Njb0Gha4GHdLkd9WAp6sNQC42ZoQEng9m63xqgDQvpqFjdA=
Received: from DS0PR10MB7270.namprd10.prod.outlook.com (2603:10b6:8:f4::13) by
 CH2PR10MB4213.namprd10.prod.outlook.com (2603:10b6:610:7f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.18; Tue, 7 Jan 2025 18:44:48 +0000
Received: from DS0PR10MB7270.namprd10.prod.outlook.com
 ([fe80::1858:f1f7:dcfc:a96b]) by DS0PR10MB7270.namprd10.prod.outlook.com
 ([fe80::1858:f1f7:dcfc:a96b%3]) with mapi id 15.20.8335.010; Tue, 7 Jan 2025
 18:44:48 +0000
Date: Tue, 7 Jan 2025 13:44:45 -0500
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Kruchinin <dkruchinin@acm.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: fix sysfs store callback check
Message-ID: <glzyvnafetarrwewer2kfuhwnnxq2fjx4eqhgrwpovzueulv3x@4xymhc4znhfk>
References: <20241227-padata-store-v1-1-55713a18bced@weissschuh.net>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241227-padata-store-v1-1-55713a18bced@weissschuh.net>
X-ClientProxiedBy: BL1PR13CA0170.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::25) To DS0PR10MB7270.namprd10.prod.outlook.com
 (2603:10b6:8:f4::13)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7270:EE_|CH2PR10MB4213:EE_
X-MS-Office365-Filtering-Correlation-Id: 551577c4-5396-4803-6c3a-08dd2f4b5c95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?Oc5MR/QvbgjcSqW9/9sfUYTc8KqYrgaKehJE9HYoM+lf3sohI4hTZRpEo+?=
 =?iso-8859-1?Q?jOT3bxBP+3Yevx53jqNenQrA2wDK7YVHHPSq8nahjQVUv0+WtpMNTnw1Ol?=
 =?iso-8859-1?Q?8bdgj+5mFAVMtkB2W+TjPmPWkm6fVGqYgt0fQ5OHXl9Eg6wyo48qMf3lZf?=
 =?iso-8859-1?Q?YYM1TeQ7Oj+W3tHX6if8rr+mHo0jG0YwPHifrR4TyEehDiOB6yvg0qNlzg?=
 =?iso-8859-1?Q?C/TbRe6JbvLZY0Zb016BDkpPJ4jd7V+4IOg7bq6KG4mumB7xmx0c6CUgyL?=
 =?iso-8859-1?Q?M3cezCzVWEjgbQpVtofqotAQFX/Au/tYlqHi05T3SUOCZG7YAE4c2dFyez?=
 =?iso-8859-1?Q?fvn9xtzym/b5Q4bW2LdtiouV8yChBdcI65Vh94/65aBTyXuKvXaefQ/lm/?=
 =?iso-8859-1?Q?LJ46VTmG8WtIfhxJ/TMfsGAGA2DaP5ug3J6h0kYqqqMGK4tGW6YibN0WCY?=
 =?iso-8859-1?Q?4jvzZFFV4A4xA/1fG45C8rKEiKqT02+kDNlMzaLdWrgLDamHez1oCvSDlE?=
 =?iso-8859-1?Q?2j6//zuBqseOv8r0/LLsqjPdLF1D3+trG1G2PMnzz3N1l1O8zIre1pcvoU?=
 =?iso-8859-1?Q?L6Ekgx/vVaMXo21MR5uDqcgtoxV4Z6roHbAXYkuWfPqSpZAHqZyMbZCHw+?=
 =?iso-8859-1?Q?lwUtaOAnstqXFKpu1e48S36W+ZE9k81F+j2X0tzxbHWUce7hqLiaB24VRs?=
 =?iso-8859-1?Q?fCLf5EFOB4C7zriiitFI1cz9vbsh0e1zquk2YCxgpiiw6xxkUvugf8ARHk?=
 =?iso-8859-1?Q?i+iF8OfR9FmKC6ywSaIDIyO0zsMysNPi4eIBvyz9yUCXSwmBdU0SaWm0ZC?=
 =?iso-8859-1?Q?Qv67mr74YB8lSBEmJMgReyjNW3uCMy1ZH78cFHx2ZXRREB5LnGNGJKYonN?=
 =?iso-8859-1?Q?T7H5fYzTVVgJQlxAWIOKSfrLf/lVV6q7CqiGCjohCsW9ak/EXKLyQSM2ap?=
 =?iso-8859-1?Q?KuVyIUCK1Jnj2WtFYnIYsHGRJ+Dh0ZOziD4x1Jwy2oksfZGQN9nN9Hqgxe?=
 =?iso-8859-1?Q?HYmMscL4NPR9f262Iwd/4/2zhqnjb8QiOqqjqLXzsuZm9xCuqq6pwYNKTV?=
 =?iso-8859-1?Q?jCTOTXe7rL3llsbtNlDJ9qsFaXK/vr22jKcPWXHNKMN3ektKyb6b3IX974?=
 =?iso-8859-1?Q?M9I2TRYYu1bIO0aIf66JsOztUf1AEr26mBBdgAjDUxOGbHvB9GoAze+qqa?=
 =?iso-8859-1?Q?pehg4i/BGKRJ3Gi6JYFsULnF1RuIbMsqaEa6yn1XfiINFKrXWbt+wsKZ9c?=
 =?iso-8859-1?Q?JqvtTX2fufsCPAaLMW1L4YC3qFdrlXorCW532O/t0p9E8AthG4ZGyVsKIK?=
 =?iso-8859-1?Q?rkNoJdHQcVTDez9FD3Sf+jR69Y60Wv4k9JDrgPOlCeHwnEYmcIcbQj21gr?=
 =?iso-8859-1?Q?Pnb7cnRjgiHyBXsEqm5cQy03bmTP56sWHKcHgLL6HIy0jApbfZTt3+w+Ve?=
 =?iso-8859-1?Q?CFUzlmHIEb0bF2tP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7270.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?u69Gc6rayVMvgcE0Z9f5PQg9Drfq6eLYH8maZyawfpAzeNNozsyLW3guoJ?=
 =?iso-8859-1?Q?+P5Ygag/q9PPW8xenaaCbD/5j5zooB4MCGcrGViRcn3Ee2XWzrEzKlL0UV?=
 =?iso-8859-1?Q?bT9WIrVVZxl1dp1v0zTkIWwA2dPXtHQaNQ9t9aiI1z3VBdEN/QUB83NHS+?=
 =?iso-8859-1?Q?9NyHFYlFIQAbRkw4cm7Dakh7KKtK/mEd9NuMzVJROaXrblpN08DuZddt9o?=
 =?iso-8859-1?Q?N9XJPNYxrC5xtm0SzrhzYQ5fCumQMYmHirvdE016FNrHB3+yH38WHST0Py?=
 =?iso-8859-1?Q?PhEMZMMKjb6RaRh3rCJaVXrhymybvoiziMvkQkItDPnftsHeqRjBKJupYy?=
 =?iso-8859-1?Q?70QnPPicdmJawE1GN0F82d9Q7Qq5zzZla+Qa67srk/w3cm0CVDu2FKYG7X?=
 =?iso-8859-1?Q?rAutgc/A/4geVEfO+bVznonX+qk3ANROLNauFl6Lj7w9pr4aTka9kk5ubt?=
 =?iso-8859-1?Q?Jux2rbu5MdvAhEzqyQxEtz7l93V+bmY5rmmhEM1/NzuuxRFr/Lq9NtEvEn?=
 =?iso-8859-1?Q?3d6vRnu9x+VpaUU8ppEhK36iTnvptHReMOyE/1gsj1FifiDs19xRDvxN8T?=
 =?iso-8859-1?Q?P3spE2HjIcrGNXXFlmaS6+fvcQpJBZOLH9Fo5R/IIsksMB/uvsAJNbwHj5?=
 =?iso-8859-1?Q?cCcE/Y2yQthG90o/AbvQRqvZDkM6XtPmCbaRpO7EZx1deKDHv97eEODm6J?=
 =?iso-8859-1?Q?NoQ+7j7aGaU6Of6upKdw+Dt/2d293MTSe8mqW1LitlFJ6r4goaVz86ZlBy?=
 =?iso-8859-1?Q?VJ42C0ySVzGrpDI80ekafC8pezNO77RdJUKIxUELzMySYx8d362fos8N+W?=
 =?iso-8859-1?Q?HDkQcsQM5zO4ySqxmWokZuxz+YmjdcHP8AnH09XyMi9/xyqEXgoE8mrrkm?=
 =?iso-8859-1?Q?oLL2SUZdHUkOYb94tYW8HlokhtercSEizLD8+9BF+ai4miAW6H/tqxiCgw?=
 =?iso-8859-1?Q?H999lkZCpSmtTGey5Ws4sTtl2QVu0ctP+zePj1k25CVq3Sh4sXau/Xs6x4?=
 =?iso-8859-1?Q?vl3Gumnu5UtZqMGoTxyfwLtC7RKl0wt4dtP0xk4kat0OGzzYbWs9xeNHre?=
 =?iso-8859-1?Q?N9U7FmTkhUkfn3arCDZom6LjwwDPiwnj6mzaY1LTfD+WTyUPDoNl9OgJwG?=
 =?iso-8859-1?Q?8MBbz5kO2VMtBrMPejoG8cNa8T/mqPzjyYjGl0nC+4Tp8jEORsMh+bNPvQ?=
 =?iso-8859-1?Q?4YfWtiVRtDdyiQ/SUDRAkCLR4QemZzRVJPnn+4rDoKV2Vcetu0dEnxNMdk?=
 =?iso-8859-1?Q?IVh+MHpKK9FmVLmQfLoJjOyvQKd1NxV52kAF+cu++T+swl0nJB01ZrqFKp?=
 =?iso-8859-1?Q?X+/wawR+HtJSEBmCqEIAlg8teaKIdq1/HCNy8b9iHusxri17zrXZ9+Lhz+?=
 =?iso-8859-1?Q?dXFxIJe5qzYia05R78xIHwKZBu6aOFkNnSFWCkZN0HHianvy/5KM8fWsC3?=
 =?iso-8859-1?Q?lHucOI3ccCGT26Gg9k5+52o+VJeY5bLARFBbpCA+iAppV0xGM6j88lzAlL?=
 =?iso-8859-1?Q?IB80zmCtS0VPelMSdioFH9mp3L16ahfT8zmNoCutnMSUSYlP9eKDjY0p4a?=
 =?iso-8859-1?Q?FeDCJdn0Ay+FT99JshcW5+OStKi0bd6Jc3EY2pOV98oLHqHJo8vhyeqldR?=
 =?iso-8859-1?Q?KFKRs/1VzLEcEnkDwYOc/+UI5n48869PvkTp7umBeIaEh+DTrssFkTdg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7+dQHaIBAvzhmy2vfgFlwlc3Q9I+L8Ublgn0TgG+WTQeMyGcVFloVN8idZzRzuYu3inpRzZUIPm7oD76oQ3rlCe1x8sW7hMnSKekcmQNv/1RTO//QP7bjvPfulbnPZ8LA4ucU057y74cmJZTBArwjlnTJaDdJmx4494orHY3BjbvdW/Fs3UzFk8G3N//X8LEuWlYjfsdHtC1XnV65biCEvmMcSMWHvpzd0lSVjk742o289HbNvpBQ+A5G0h8vxTvLW39CHVsLdmOhlCBLA1bLvX29i2y03mkZpxue4kOYU54MUpTkOWFTgfDKBU6jeZSxsMYcgZPlG4K8+qbD3RlEnMEDq8PKWZNaXXeSKvUKUE72268yu0yXq5LE8hymCcINsqsccqNRIXBYYzscKfcMfBXvSUcnzFEQ/sNsIbEHBXheDac0QwRiyut9yqcMHIztsJmhzzo9w5gJRzoVUNLWIilvgC2e1HcFEPGSo2yuKaZL42Efa8ISi/biOp1MmY9LI5K06L2RxlZQS0IQW+tzX+JbHBWFRgTMr7fJq0nBtqz6L/rJ5fhXGgvb01cSb5XnRIZ7TXPz9Vjfma4xjy9vnl0ZOnWdw9Nz6wzFvZcaYs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 551577c4-5396-4803-6c3a-08dd2f4b5c95
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7270.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 18:44:48.0431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 33es5txpk6S7WpfuAcLUbsaLvbzBIk+eUi64s6oohULNUE+2vMWP9l861j7pOqLIpDsWz6u1yJtTPI2cN4GjW6Dlod1qYuwe4NKOQiRmjF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-07_05,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501070154
X-Proofpoint-ORIG-GUID: io1Mu_IxFiIo8WzoSVGbvjL0J1Hprkw7
X-Proofpoint-GUID: io1Mu_IxFiIo8WzoSVGbvjL0J1Hprkw7

On Fri, Dec 27, 2024 at 11:32:01PM +0100, Thomas Weiﬂschuh wrote:
> padata_sysfs_store() was copied from padata_sysfs_show() but this check
> was not adapted. Today there is no attribute which can fail this
> check, but if there is one it may as well be correct.
> 
> Fixes: 5e017dc3f8bc ("padata: Added sysfs primitives to padata subsystem")
> Signed-off-by: Thomas Weiﬂschuh <linux@weissschuh.net>

Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
