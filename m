Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206451DE4F1;
	Sun, 18 May 2025 17:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747590415; cv=fail; b=DTrsEM/CLBUQK9krkeVwFDlfEhk3et89hwOJoVghSNEZPHVcsXRn7rSzSwUboNepft2iPSaE2WkCuNHwMDuTtekKRyHzetl+UPWVpuG1Od8SNebqygDk3qoXXdUWDpvFr4uwPEN6aTlgcdETW2KSYAvSPxlQWCUP6NY0EvMrpWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747590415; c=relaxed/simple;
	bh=wRFkmpP6JMBtrcvWa+Sm/B6GJVMPFJxYEevrAcizuM0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Zl2NFnfX0ezkw0SGtPAsRizZ4aQz1u6qCVeHsVGjG7ZMhB7adewdcJAi2wZaSDyWjN0IHlmNMQAAU2gtMS11YZttHz5NPo1JDQZS+nga3bgGw+9GSvMDvv3o57xX58xfUDUN1vR7EqwM4Yg9etqtzQDSXO6WLrNHvvnV50WvFNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZtP6imZk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DhrL2VLe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZtP6imZk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DhrL2VLe"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54IGP2Gd009358;
	Sun, 18 May 2025 17:46:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=dYHQ8bnAoGwAIZX7
	09s02zrSLO0fHrZBT8TwTJDOGUc=; b=ZtP6imZkPhmpwvdq8apIBqpBtSMd2YKq
	OJ161vhtPIlNVwCpt05B2L4bakqbpat6Vch/FO2bzX04NbE7J2iEuYJwkkdoXItp
	FfY7r0tsuE600GpNsI/wRPSz49Qymfd3djr6TRLTDT47cTY8pMq+MYX5Uqd+MJMh
	Ja8f4t2svfepdHMH83dDOg4TCMhCgjccktwcyXi/JQDJhzxLv7J8Skar8iy8TbuH
	P4caO2FLTgCpk6ohdnhmjNUc1uvaUngXBF/DeyAIwd2Xg6K0nPLhVxUI/mT9K16d
	Ks0gVTSE3W/psd1PYaKwdcjHLIc+4OjaS5+rDOgzMK2sYAuI2btJlA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46ph84hkt5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 May 2025 17:46:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54ICE0x9011382;
	Sun, 18 May 2025 17:46:29 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazlp17012037.outbound.protection.outlook.com [40.93.1.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw66m7w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 May 2025 17:46:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fFHY/A1xmEuybWwVZFnxVnQ1kM5v97Xdt5Th3Sj0OedKCeIg8m+KwaP11OWH/n5rPORbua0q0CFtppp90hzJ/yqQclM8iVggxuaPiqrYjgPgBZGPn685BfPtVFN4RoYK6J72Ld5vmSgHOdriKua2Q5qnaMEGbnEoIfwOOIJdlXtG8eZWQMjDJYK/hFFtZtsKUZFJMGvEN7rCXy2qztvUPWh3pADEf2f2xUXYc+/MCueHn3D5wXjRUwAaMwLCx/JCmkOOU9NdVzYr1cRERSyp1JkJhfFTlmsmhhTRicRsYw0uWa3kmimUUD4LqKhAnLhDpxtRYX9sFq7jGefgYh0vLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dYHQ8bnAoGwAIZX709s02zrSLO0fHrZBT8TwTJDOGUc=;
 b=x+MLUdLwJ/EL9ZZdxnN/WuPa9YZe3sSEGUUQF1vekilSKifnfDv9uv6HInVH3ZP2z6ECbVOQKKt/Dcxkb/79TY1hHPa4dgiQLWlFPaXz7zU7iBjnIbrdtu6S9uN7DdX0DTfniXQ8yaf07GuL6JwXcTRuPfG56qOgI9XuI18Y6SRrANL4w3XFISRXsrnziz7xDYlqxp2JojWmN7fdMZJNKlBpIsYFdyQTZhY6CSd2gkORW0uxvjXSgtgn3yfEoIceS3KDtZLr14RQ+yXYlZaCWD9eXlIprMCUSn302ILWt7+z+kXKAMF0vQx6IYY49s8Clp8Fs9fkjRMs3Qw0epcwXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYHQ8bnAoGwAIZX709s02zrSLO0fHrZBT8TwTJDOGUc=;
 b=DhrL2VLe9OF9YbFvu8boezlueCr5Uavu3jogfnObkIWp8O9ozHpqXZyZ3NByR7E1gR751p4WxadPWV23A9JJatVAIkusQ7172mYwCS2U5+AIcPmu9KU1Ea0gZrHLuud3tlog/l24AFYhyBILfLkv5GvVd8VmrtsMOWIO/g+Rg5w=
Received: from DM6PR10MB2939.namprd10.prod.outlook.com (2603:10b6:5:6d::33) by
 PH7PR10MB6508.namprd10.prod.outlook.com (2603:10b6:510:203::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Sun, 18 May
 2025 17:46:25 +0000
Received: from DM6PR10MB2939.namprd10.prod.outlook.com
 ([fe80::3583:2675:5213:714a]) by DM6PR10MB2939.namprd10.prod.outlook.com
 ([fe80::3583:2675:5213:714a%7]) with mapi id 15.20.8746.030; Sun, 18 May 2025
 17:46:25 +0000
From: Dominik Grzegorzek <dominik.grzegorzek@oracle.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: dominik.grzegorzek@oracle.com, Herbert Xu <herbert@gondor.apana.org.au>,
        Chen Ridong <chenridong@huawei.com>,
        linux-crypto@vger.kernel.org (open list:PADATA PARALLEL EXECUTION MECHANISM),
        linux-kernel@vger.kernel.org (open list:PADATA PARALLEL EXECUTION MECHANISM)
Subject: [PATCH] padata: do not leak refcount in reorder_work
Date: Sun, 18 May 2025 19:45:31 +0200
Message-ID: <20250518174531.1287128-1-dominik.grzegorzek@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: WA1P291CA0020.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:19::24) To BYAPR10MB2936.namprd10.prod.outlook.com
 (2603:10b6:a03:84::29)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB2939:EE_|PH7PR10MB6508:EE_
X-MS-Office365-Filtering-Correlation-Id: f1032b48-9d3e-466f-3505-08dd9633e878
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wA1I9LfM5ZC5v7SvZ/nceLy57pT3lqUiI9cgmnfuwwt4KXfS8tCvvkYBlQJ9?=
 =?us-ascii?Q?yQhFYxZZxYJGcfUVSruGuFn8LmT6UzvwHQvDSGu3rrZL04Ko3+jTMidCndSt?=
 =?us-ascii?Q?xa1QC8Jm9qPBLlWE0u1wFTgeuQNadriwNMs/8JsHGK4+35MVSQnhP8/97Bjb?=
 =?us-ascii?Q?BziITYXjrJpibr+dO8avI+0+Kc0m4zDxMWXUEAnvAbRg6w/oMU7OlzvC6iLM?=
 =?us-ascii?Q?88yrk5OTUH5EkLUPyGTj2mS2NA/9wv6Vx+hebf8TLv+7+gV3KMRItDEhmp3k?=
 =?us-ascii?Q?w32zlI+mJIlWkq1HhJsFvXgBQKkhYtedQjKNPxQciB6mn1zQzPY0yxHXHZKu?=
 =?us-ascii?Q?BEHbNkmP0R+mgvWexq+6yIMAGTXK+7U2u4oFuBXjR3mkaT7i0BAOOr2kKjV2?=
 =?us-ascii?Q?SPGinPWLxMYYC72hwqQGBlDXCdBmwE8EYMYXafs/Hr4MHmGkaK8wfYkRF7Bm?=
 =?us-ascii?Q?Tp3Cw43LE3gEK941jj/Db6zw25WqgjLLrrmzSEvsRPOVZpLcC++qBI1rNjeC?=
 =?us-ascii?Q?2uAEGO3KT16AshuCsRIxa+UeSPxiV1JQEgadsYFzzMMrwZIRG6XKrK7Dl04c?=
 =?us-ascii?Q?7Qq/vfcPSNCrjk6bXq6ywRxXk/Xkvp5BZwrJ5SyiOZxkqmUXatawpIOaqEaz?=
 =?us-ascii?Q?JK75Dr4LP9d1nNs3ywmEexU/ToVXlHfDcym3GsVrUEh77QqM6omWHUORNPvu?=
 =?us-ascii?Q?+UFX+EqkWEEriZ63byTB7b0OYkldZY+1o0t7b5uuixK/74ivK2C6+4pROoy0?=
 =?us-ascii?Q?cUxdNXwVjNbsOp5tjSDq+H1NCG3lxncYAV9GDykWsHthQynRQgqkQW2mC3dv?=
 =?us-ascii?Q?Gp50r6jEdWozAeqO9+hlEpiMPMRMoxQZh1QmkSunnJVzDWQB8+fuu9m5SdFL?=
 =?us-ascii?Q?mJJGyKSEAV8FmpjGAB37LVJhinoWxn4BzJc757wn0R8RZaXTM45ggNVlsDEA?=
 =?us-ascii?Q?CXvu2qjR81pHlj1j7vog89GIk2KMPwRPDKk4oOmqjGYCsFTMY/v8jDkJKkDI?=
 =?us-ascii?Q?c/TzzcHSwLqqih2cJawxTxmMLLZ6HF6DSsloOElZuxZMgie7tlARn/wzdI8b?=
 =?us-ascii?Q?o6dkHQsKMdq6FuqNQ5vAOMVnqmn9X/Jh0eqNMI5mB+IgB8aho7Rd2DgZT9QP?=
 =?us-ascii?Q?nUUiQ/qhaP6uTq+MvC8aKchDp/21C888aiu7fvmc9VzUYZbnNj4HH/7zCOg3?=
 =?us-ascii?Q?pKKjaP5B3tWPeaNZoL6r2UnKfHdwyEqoLH6JQq64K3YTNFaw9c3OGLEJwE3Y?=
 =?us-ascii?Q?5A/7DlQCx9MPb+zAAseff5YMS4wFm6Q877R4E0v7ASpfiBniQMhzJ+1eVMR2?=
 =?us-ascii?Q?OVHOITX9Q9BEbG+Gs0TCeA62cZxRq/LPirH7Oz13getc+xzTjnc82+MRkLka?=
 =?us-ascii?Q?nPMAVMJhTIQ3w+kY+ozVIOHqc1GaN3y6CxHpDqNfG4h/A6inA7ei9VqRWmrs?=
 =?us-ascii?Q?jJFlwk1EIQI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2939.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K3gu1aEIgdXmVNnGVIdnJnUOESdB5e0n+VmH2nCEsqTJQ6TZrV/yD0Myc+9f?=
 =?us-ascii?Q?T6/ZcxGqUx7aVvGNAsiJBp13un7TgeZE97gAkD5KR9HjhvrrFdY9j/Oj2OEF?=
 =?us-ascii?Q?8vipra+KxfoddMqT5y5a7Z4ve/BBlF8V5W2ixx8K7svvePBOFPle1D+Uc6s7?=
 =?us-ascii?Q?h8MB1BcBKcJNjfu+to/KJB7XbnSCCMY3dbgLwDhQZtojXatArJYVj81fan3g?=
 =?us-ascii?Q?Gyl2TEmQu5cWKhL7jWcmsrl5DbbOUtBq8ci4WjQq2oC1LN292H57XT3q4QSe?=
 =?us-ascii?Q?rk2v2xcosSPH/j2+iksMcoGJdFuojnfXx+yR3eE8dL7iQWl9fUnhNJykVaQb?=
 =?us-ascii?Q?qZG61oucwGa8oAXFFZ1ybICrEjb9dEtI76s39Rks2XPMdINlnPGT6jBahmV5?=
 =?us-ascii?Q?1qCDDr1efkq4QRZv3R4ZiI53vHj+8NIY6bcTrFyIaxO9Tq8A+WHIALl9L6KR?=
 =?us-ascii?Q?4gwwGy6/M19Ui0IavdnnOLYdd7IcE4QjCRzLBB+I0IGs/JmJ28rNiJW1rXg8?=
 =?us-ascii?Q?qX6kI1HZWgQ9yc+kyS8AmpFVtpJalG6+HkivRPcXJjNnS3aQLgaK57091Nz6?=
 =?us-ascii?Q?LBcGtpTUU5Fu3YEMSJ3wBC1c6tK7P+yHneksmIpcVVV/AXTh7a0HUwWgys08?=
 =?us-ascii?Q?gMiX01zeqUZzxI0yX67Rrb8Y0ELpOC1j8aVAtxB3XMhxlyUr2cEqwTOOB2rH?=
 =?us-ascii?Q?VP9QybVPTRzUkq/R/59/uZpZq9zUuB8oBOVTCnqgQpcFX5IMd9/Lxwc5m7Ca?=
 =?us-ascii?Q?JfYR0g6KKR/FKlSW5u47P0g3PVR3LlQiwtqOaoYXa5sVWSXo1vwkS+LZk6pA?=
 =?us-ascii?Q?yrhiuRJzMNu9qXGcLGy+DcBxpvVHT2ZHSk9h6EDv8gqkSUs0btH6maAP7A/x?=
 =?us-ascii?Q?AAJ7cvp9rhmvclLDx542wOgZacJmIk5AfUz1QQM9IbzkEerOv+Ao5SsokEOt?=
 =?us-ascii?Q?RQRzcLFoL+DBMIq4KSSoc4Hs8o7zLSIDEMUeo8VrcEyjcSPr9ul4tQ9Fw5T1?=
 =?us-ascii?Q?anxNJ19QzMlby7xHBhob6a0abdq0QHDMXQKBb08A0ZjytHUDTuNo3E4PFUfd?=
 =?us-ascii?Q?nHqIKbD2Vqvdu+GkOmAhLnGXvKwVlihVFQRaF+alQo0UxiYASjzdHHt/f1mQ?=
 =?us-ascii?Q?JbHYF1Vqd+rTUNxTkNmv8CBa01IacFeuHSgr5UtMnN3XZf+iTVlo9/dFxrQp?=
 =?us-ascii?Q?I4nY75QisHFwVOkLT6nFtI3E4cKA6UCZT/TkNZDXj9SLmvKC+IaQRok5DIG/?=
 =?us-ascii?Q?XumMxDw847q4v4U0COxDPjDCV283RZD/iNxw6QoiH216lJMQ7Lk4Z/gtUy6c?=
 =?us-ascii?Q?wA6UnJrmC7VmmQRlKZwKWqvCov17adHk3hxcgaBC6FkFA0bFkteyf5Pc5YP5?=
 =?us-ascii?Q?xQKJPvBSqIye70f00Bpta4Pmejpe7DULja23A6ohU3IKt5BhOmehkME4Hmpp?=
 =?us-ascii?Q?elz2YIYMlqnAHrCmnroMbyKF42DhM3qJEKzNoN6lpxPtQWol/NdyrxzRO5u4?=
 =?us-ascii?Q?bKONa8jPHGGt/GCgbtW1ctq1YmNMOvYwVbspzENZMPlQvyn3HbjmszZWU9QU?=
 =?us-ascii?Q?+GXCMg+USioibcvRKVdrK41xOY+O1IqIXLj8g6gutt1wb3JaDWbPvFSZzTTu?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7LiWyJFxVD42VojpU71Hx4b/7LOyGb4Bpt0RT5BPep3hcML33S8nv7UmqRWqRBl3OfbzWsDPZRvx53JeIvP2sohd0hMz/2ccS66x1jvP7CHCqYWbLe4Vn8EQFBJcG6c4Ixnm4qL/BoV8wrXlMzaBqRHBiPHORZesxmiQSdHYnemvTynKgykQTyOROJGdtWmFefoLezU+xmROtAr1bwVMnkmzqpZQ9t9FoKboXbv83KM5wOVE90JTJJ5QMNFIqJ7bzjY2iwZq/KCiUfREDY0gYFCMlfWkUxGvZVGzPPZ4gnpeZsDjL+FCG1Kh3niEmuYqnWqWbmdAHgeqyl7eI0JqY9n/heDi+LAFR/j7BrO7tlDGXHFTmgP2d/rLYk5nq/U4EekY6t6HLrfRw+vPhFCs3jszBp1FhOy+KT8FPOMnk4BB1qHGm9J+MGlezNHBR+Uv2oNtj96/9JQSRQT8Bl+6I6ptlwRJ8ppDb9ijZBaTJuj0R/sYTG/M8niGHSrG12eDtUoh0fQ38l0v1JMF8napN4m/NSR3Ce7gHL/Kb0UgBw1xqy3bS1TV7MT/i20n4oOwyu+Xii0Zw2KI720HfdoM7EzGFXlIR+kPGF/cB94bAyg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1032b48-9d3e-466f-3505-08dd9633e878
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2936.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2025 17:46:25.5178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XNIu1MhioujZaKP/XwpIQdM89XCYTJB2UJI+DfwUJjcC6fWEBJ5Rx8Na8aqAMKs/GHnUlGY1BkurW//GzTG7jdvJkzT09xfUe3xHMB4HHsE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6508
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-18_09,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505180173
X-Proofpoint-GUID: BJ_BmkeFXBsLSxMbHjFPC2dWbbru3vZ4
X-Authority-Analysis: v=2.4 cv=YPSfyQGx c=1 sm=1 tr=0 ts=682a1cf6 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=2uqWE9R1tOt9VcI0hM4A:9 cc=ntf awl=host:13185
X-Proofpoint-ORIG-GUID: BJ_BmkeFXBsLSxMbHjFPC2dWbbru3vZ4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE4MDE3MyBTYWx0ZWRfX94wNFLjohSXl lGngn5ebi6TXzSFYZ3XK//gBm3L/mGkomlXF34o+GAMjhbtXTMQc0m9sycvg63omF3uOhwFfYFK wrryWnxSV0iZz4MsLF8bGl9e7Str/UVu5onydrkDoZKNnbvnifU1D75Toeukny/IyscNAnr/CSC
 QKIbNbCSP299LEI0B9qnv8jncK13DEIhTa7y7IcDZgUYHChn/UzyJt6ixogZpXSYbJBNDsawioc mgXtEEbugotw+ldYEWTTuBReJ+6sLvsDc/6Ifignt18tWn9UEkPMtCbrJ5iKS+5p1GDzJxE8u19 BV38tLN61SxLNRXV+4VT3dHGmuaLfUu3CD+QORtBFwt4EYpOXFPAYHKkAqqtOOPJe/UCjSbn/sd
 EZN66yAN30k2g9hR5h5F4tH6K9AnPeoo9lDpBgRCy/UstcoECGY2iJHyUBFkSz0AGOMp1vbC

A recent patch that addressed a UAF introduced a reference count leak:
the parallel_data refcount is incremented unconditionally, regardless
of the return value of queue_work(). If the work item is already queued,
the incremented refcount is never decremented.

Fix this by checking the return value of queue_work() and decrementing
the refcount when necessary.

Resolves:

Unreferenced object 0xffff9d9f421e3d80 (size 192):
  comm "cryptomgr_probe", pid 157, jiffies 4294694003
  hex dump (first 32 bytes):
    80 8b cf 41 9f 9d ff ff b8 97 e0 89 ff ff ff ff  ...A............
    d0 97 e0 89 ff ff ff ff 19 00 00 00 1f 88 23 00  ..............#.
  backtrace (crc 838fb36):
    __kmalloc_cache_noprof+0x284/0x320
    padata_alloc_pd+0x20/0x1e0
    padata_alloc_shell+0x3b/0xa0
    0xffffffffc040a54d
    cryptomgr_probe+0x43/0xc0
    kthread+0xf6/0x1f0
    ret_from_fork+0x2f/0x50
    ret_from_fork_asm+0x1a/0x30

Fixes: dd7d37ccf6b1 ("padata: avoid UAF for reorder_work")
Signed-off-by: Dominik Grzegorzek <dominik.grzegorzek@oracle.com>
---
 kernel/padata.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index b3d4eacc4f5d..7eee94166357 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -358,7 +358,8 @@ static void padata_reorder(struct parallel_data *pd)
 		 * To avoid UAF issue, add pd ref here, and put pd ref after reorder_work finish.
 		 */
 		padata_get_pd(pd);
-		queue_work(pinst->serial_wq, &pd->reorder_work);
+		if (!queue_work(pinst->serial_wq, &pd->reorder_work))
+			padata_put_pd(pd);
 	}
 }
 
-- 
2.43.0

