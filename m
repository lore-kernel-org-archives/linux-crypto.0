Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1868E35AC32;
	Fri, 17 Jul 2026 20:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784321445; cv=fail; b=U7ufJ18XkZc4wxsCldUQLnt7FBghkW8kqXSmCTuHOmpd6+V35qfuAu4uul4gwtrDe/6pln1yj+3e18Rs4Ftx8AlYv2+JC6rQhNDrDbRUQFeOYpOcd2/dl/+b8qRuFajmS6uZ3ojzxaXJMwaECmI/sZ/bV7fFxroxMwSsyjjm7ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784321445; c=relaxed/simple;
	bh=b3I8NvAIb7c1ZKJFz4hC5H8pcn+FHtS/DsxPwbfLsyU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Fs9fIDucYQb4Szuxgah6FPU/oq8vCMAjDQH62aHhqOkGW9m9BT73JbeWpZYCKm6GuC1LzbrVqMEK01IBQ4iiYPKP4sUP27VLTfqDU+5dOB1xPtGjXgXQ9RH0HaFuaThkgz0xMluQ0bMtnkTPx7g3AvsBa+lj6x8b4hUoqAruaVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NfWWDEm1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JBwBoyrr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NfWWDEm1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JBwBoyrr"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HKN0Um3911454;
	Fri, 17 Jul 2026 20:50:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=BiuUHVzrNiLhFyGu
	mGWHcrObVtGoz4A+si/op7rO7Fs=; b=NfWWDEm1hn6taCYYaplawf3uG2eMepLb
	8s6tLhgWEcIN+Bt5ccBsg7ZdTRoJ9SCegT/KfEKWCi+4CY8O30Ys2jRB3J3Rw9X5
	33xpUbxdLKmg2aGseRVV/mCXD1DtZfB+f5dl2FRYNUd72phkHcn+di/R4PlXRqR/
	KLtMnfooleQpqy3d9EXuL+b99bbURZQzvScykyBIGCdVQ4SPvbJl0AudCNEWzfb8
	NJGxbOF9QUMMZ81hgxhJcbLMlEY89niUjjC8Vyp8bKupgPGa2xoXoQ163vlmr5s1
	p1KXaRfBQBztyGWY3/3vVwGvLHNj9bJXrR4RKMM0ZHHhPHrUXTgKJg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbef12vsk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jul 2026 20:50:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66HKm9Ou030862;
	Fri, 17 Jul 2026 20:50:35 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010037.outbound.protection.outlook.com [52.101.193.37])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9jadr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 17 Jul 2026 20:50:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NfBSMugHOpDoew4AahdWbZ0k2BPKX1m7duZY2B/UvYtuFiCFZ5mcxMq++WmMJPNqc6bnpejI8pJ+d0ZKx8jsXwln/O3GieP4ed+EyOhNKhxEIWcewNVI0UvWsuf3cr9CL8Q9TReSYvpgEJxqRdlRjauA4zn7WH0NPSkDBkDP1o59ZexFpC16HICtdYkeTt5MEqOAcQ3AHe72Gmcaw+ZX7O2P0eksyY4BNOX6b0pU5OCejCG8Gx5HiN35LIeXhJ66EUcVsTg666a5UA8+YxynWqbqyGcq5By4adav+Ki0AvmgyKi4oYcpkknGkvwcP0MJsfZM0MOz84mmKw4DHemTHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BiuUHVzrNiLhFyGumGWHcrObVtGoz4A+si/op7rO7Fs=;
 b=fFJnE5ID6adAOOPJ4nNKp0Z6KwTUHcqPsWUutP7Nwt9Gikg5xW+wHE9m7OFJT9wJCYS2/HUkzf7dG/Pn1Kof0OdYKnUBNDnhhDD8w8JOQwZrGpWNKEuR+arJ8QAZFFpF8Y60kI33BoP9YwmWpx4/eEIHa0KdlIuQ43TJ835R7X5Sf/RBmG8Lo8W6QnPiR8pahoG2cH3ZlLkYe7pIMqho9SC6mHc01gU168Gd8R2bJHqDWexWFjCRvFi4oB01r17u3yyBVv1kITIdkX0ctUBxJD1okaQKURHjY5e1Pm7RLf6N1gWfPMqM/utBFsMr9iOqOKa89znHAw3D9/LbMcvOfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BiuUHVzrNiLhFyGumGWHcrObVtGoz4A+si/op7rO7Fs=;
 b=JBwBoyrrkVQ3i5L5VJVSl1QXHQYDxKXikP0zLpkMmHBuI490FIJiWSJMWT68aLUwX1b7B+wDiG6pcfeJGi2e9c2eljA8wwGJTwEt7YtwjDqZ6nnbVJAPJ6JS0/CKhSEcBiFzGKclS+6t7mTzuydK2GTsSXfKNug0sO+tqqhNPws=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by SA1PR10MB997629.namprd10.prod.outlook.com (2603:10b6:806:4b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 20:50:31 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::854c:c282:c889:45a2]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::854c:c282:c889:45a2%3]) with mapi id 15.21.0223.008; Fri, 17 Jul 2026
 20:50:31 +0000
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH] padata: Replace bottom-half spinlock variants
Date: Fri, 17 Jul 2026 16:50:28 -0400
Message-ID: <20260717205028.63847-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0276.namprd03.prod.outlook.com
 (2603:10b6:610:e6::11) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|SA1PR10MB997629:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a52ce66-5691-4f46-10bb-08dee4450a3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|10067099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	0+5ebzcGIY3LSqhUuFFYuX/Q/R5XUlVSeBk4A5VJ95NpLW6upnDqLueVUqKPSDoMmJ0ZXSiABfFH1b257N/Slvpsxyb7rI0Kecrfk39+1NMbWxTKgbHn/xV8DbqkubUZm4gjN/GQDfGcbpvSibIRbj9vjAVq2ANCYajAnLlf0XBQq0uFbIGd8zGPRhBO06yMg0j/GFXgZ4MG/aMF8pBSIAJqHEEBAPag++rl3esUA6wXxNyj223IfqKlvgEqPUGzHVvUg1m6x0T4m5wQFQ1VsKXpzHugfKcjbGMnqG3HiAuhMcaHZcGyPOd71lTsaZCky/GiMhuJzt1nnInH89tre7hWoyVxD0SFy4CBieKQ8GpinUx839prP0X7Oa+LTbxufmD7HpWlYb9aWoTG+p2gCxTQX3UcvljFfBTqy/iIsCi+mcIqNRP/+blFwJUWCntuUXx/w8O1yvrO4Ci+wkv2J0B63TQA2aqoGbsAisvl3/2efsBwKL/UN0ELkzufrQIEtGEgAXr0opgOI2fauAOTyjJgm3Iv7Du+eNxUK48VbSnVjIeE8DFdmN/52myUo3JSA0vuz5JDIpSWgzBWIb2AKDWjXBqbmSBeE5vRD5A8ZVM9VnMGncLax+dXg5f5hRsr+1a7w14/nvDNJw+ejZFp31URFxx3BagXhlKCuQzMymk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(10067099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5xMyd860BpAytnUjPLC+pPL8o83YglXcBCEBiL46TUcPVLh9ic0iFsRKj2ty?=
 =?us-ascii?Q?5sCwk3zKWD5t72GzYBq+U/30rp01b9dIu5nd3jeZNI8txl0CDl62OAfcIOJ0?=
 =?us-ascii?Q?V0IUYKp4G7VAsT1iWUN6yOrrYdVNWWxyoLFfsvVgvZa+C9QTZJLZgl1O3qoE?=
 =?us-ascii?Q?2qACfxO9ydhg71taDRncYXPNKE6nJt1d8DSVzpAjHpvj63y44uwdpIyP9Cuk?=
 =?us-ascii?Q?xAzP6Is6uVT/H852uhzIrzUIENAxQmKD7j9a96pnvdmkz7r+I3Y/DS+VG6Th?=
 =?us-ascii?Q?xboqFMCsYNQEjqchzlSDMjvFcOOQHOfb4zc4hSsUX7MbNP2ud8wZLWWk8Ifj?=
 =?us-ascii?Q?XS3/W7UHGUh6C4nlosvgcZM1ST7N827iZTqA9nDK5q1YdLV3LFb+VMPXdz5W?=
 =?us-ascii?Q?taVRxbHR5QmP2tntmgdi1STyhNLcyhO47TQ2seat6Xazvw8QUbj0HUhwbGMm?=
 =?us-ascii?Q?RT1ahUKMM8wnaDxz3YCixSntZWarxc3/MfnG5+tkEsfkgzofgkUDvc7zFX09?=
 =?us-ascii?Q?22HaYX8cZyYGvlJHwdryh1ShlvgxIfBFa4PvieMD/qJYX+CsIrRmF4Y9dIyc?=
 =?us-ascii?Q?al8xe7shxDYz+DPGJdXbp70gr2E4aK+XeSZ4ZOGQNQY66rfKlW2nrQNZRZdJ?=
 =?us-ascii?Q?Yzal1fMdJhST7Ma0iuCPYrJib9levl0dfb+ZdABDi46nH5wPIuPHxDMUzZaV?=
 =?us-ascii?Q?kMaDlHFAZe8bn7IMnCPWToWX7+AKIRKjkY0I5upZHu9owhJqny+EEfkQq1Ac?=
 =?us-ascii?Q?1Va3Vx6JdWrirx2nfka0IXXKZCFZPOgIGQkM/ILDb4Y1gE9SaxA7BKdpzK10?=
 =?us-ascii?Q?LwuY4K87qb8nUOJ47yjI0+FIaVr9jP8M19QXEsNuNQKbGTqxOg8YEu3RpmnR?=
 =?us-ascii?Q?SpEPb2fpPoEJe/779USkzwxSKBZsDPbmh2JAUq5Gz40pZJG1fkDiZBTi26rO?=
 =?us-ascii?Q?k2XfSfkMC9zRMVJaS6p78cji0G8Z3Iynq0q9Rt3GZ6pm0sK70xCEf5L0gO03?=
 =?us-ascii?Q?UbHatxa2Fbq8H4Rm8CxURHZc4ASx0SsM+F4JnjCvXh0BRjJy3c3oWm2piOlI?=
 =?us-ascii?Q?c6jekqJkxN/kOUZrj9UrcQ4nSVdeS2sK/rBqwmGVyjTcg+q2WwW6W/CmQua6?=
 =?us-ascii?Q?auY+GP86tDsp5NY3fI2a5bpl/MGBa4O5UhBKFxJEQe9JBxyaw3hE225tUJ0M?=
 =?us-ascii?Q?DVqepj/IsEURzC+RdLHhfhL8mf28IdrkyWhunwDAjWJ8L7dAnh/AixifM9nZ?=
 =?us-ascii?Q?FBbSTVPgCZklE9LxbvmEeIEiHTNmYUuvWGmL6X/9VoUTA3a/0e2xPKBQrlnj?=
 =?us-ascii?Q?GHNxi6/EAz9xTLuZvHPWjoP3VxwxY6HWtbT6Cw7+wuz7vE9QdcSZU88Q7myT?=
 =?us-ascii?Q?+pei6F2zMl0lzeMKkmETBE8ok8mLtquJAk6gCEVMM+H/uaXaVvdok2CcF8yP?=
 =?us-ascii?Q?7gUyYs8xDHZwrkUC+iTtkM81QoZVQk0lCYut4TBBpAZU909PgFjcFzXvE3SI?=
 =?us-ascii?Q?uK6b5Ev+YR4DuJite3X+cWpEQJciRPk7l1TmU7r+FaSuU/FwlAXGn9TTDXjp?=
 =?us-ascii?Q?Iy8DxZXKoMYMm8hLr7+ngiAoItnXsWvavdt0rPeMb3zLS0HXT/N7+TpKz0zE?=
 =?us-ascii?Q?OikUdve9pLU+PkJd3prbwUtuhoL7YNkhV7uOarefUQaypaNxyHVl74ChzPD0?=
 =?us-ascii?Q?mjBMO4TCOcUe5POVHQ9TO+aeX0yagCOYXE4FBiFlW2jkVkVQDxQboVloLh+/?=
 =?us-ascii?Q?BmRESVZEd6kYrJnTLvQuGUtajDPcKTg=3D?=
X-Exchange-RoutingPolicyChecked:
	ijimjvC//bItBoLM4Nvep5z5ww6wyOJ6RfuYX8M1e0f4q2ct5i95vgpi/1pZpfIk422PJ5TymYuZRjV8bQVmtFt3BWxU993W/A9b/bvoOR0k4ProX9CYq7+W3zuF/JPkhZpskP4OJM7RMjM2g4LJdDvFsOWDiqYL7UFvwoHPhP8bNJqbXRbNqQf2IxgsZvawhPQkP8txntySTs9GMZwDA/eSZY0+GuXODN/BRTJgN39b0XAR7q7VFtxomUAKBn/3nowIaW3NGajgUAMzCbCeO7jS/nvR41sKtNOYCBoiOhAYP+sw9jnGKSpNjfDObD3I0a6lNdGX5J3YRDO39hm6WQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Oow8H/pgOEewxgHdzkIuf0SOivxz5vSM5sDMiCUMl+ElFHm0xlAV6zo1q4TQwYeymQjXwxtw4loiJ4uXeqXOuiuf+Ni6GrVNhMHTFmcS6p19nY9ZQ0AhP4hghVVkDRG3h6uvj/Hfz+Sy8ckeeuxUfkePHmYjN1w/sbo6arkFkl5v7+2UiKPQil75U7e6jhForRRELHrIRA6ES5gDwyndpJryNmK+CPeB70leZJgw6hR+4upP6APNeuCSv4xhl0mCh8mPhQKe8ZgrzTMWhb9tq0zjqLeBYTU8EkDM8ViJn7uhx4MlwoREyD7oBFKBASmfrjvXe2+iTEz1Dj6OQ9G8q/4OMcTxbRNZ6N9ZfaDpymUT/KY4si8tlcMmsDPcHOlDYPPmRfT3effYrMagQiL4WPdwGFBEyVrSqy6/ENxkO6eMsrJgsdLdDYMXGGlh60B5YypRo/SgPQFI7CuwlRbEz7TAwzMmwRHSm8SzviF0VEVgY9sXdoH3Zratjl1OjTAzjbLlm696IA4whDScjoYs5p5/P2pz47IItvUH5HizFRf1ASK823qMuggkv5ucjmSwlZaIiOS9A69alB3WhhKXFw5YIyUgwJl14fQyRk/TmPw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a52ce66-5691-4f46-10bb-08dee4450a3d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 20:50:31.1107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FKbc5GPG+V+whDrearlZwNbb5X8PzskLpi3cpo8WEIUamL5mgCZ57qGGNp3+Ow6OaTNLf9e7cKiu33YzImWQulxANlRF/ClC2ntJUL3qL8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997629
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_06,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607170214
X-Proofpoint-GUID: 0KYMSgAGPMyafHX6O2eQhDOEP56Hn41D
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDIxNCBTYWx0ZWRfX4TVS5h+5SiNf
 57e6eZ52qPfGSyQqHOtE3mGOqN3IsT1638Y5TKoS6DXQAX1QSd9BNRRLs/N+BU80ZPSlLSHidBi
 fKriIYsBh2UmrIji/YMXggis21ez79KY7/qF41oO1q2dKTF5AUex
X-Authority-Analysis: v=2.4 cv=KJZqylFo c=1 sm=1 tr=0 ts=6a5a959c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=TJ5QuZLhkMazlTwe8HkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDIxNCBTYWx0ZWRfX7dqqPZEeZwtG
 XbbSqBuikoGP26zH5IIr24vEwQ/zPPE+J1yHIaVMOwfSuPtpIU3PDOf7OMVQUCFxJVW9Bz/8j/9
 1P2NjutkNYvRr9pHCPy3lu50jFGEJDTkIsZR8Alw2Xs/tl8JIKCl5axjlNHkAG8kIKIYGm/sd0n
 BG9VO6Y+9A8ZsUZ0kKwdWjNS4i2lzVl49/tOURzQRVznJuzrhERDpK2jad5tZM2R67BVsnvxLFf
 RuE/tthavp301RRe7iHHpjcg6SQkm7Nkj5eh33oCZHHisoLe2RMzGiHggdwOEbw635AltDhAUmv
 tY6pnk5SjgqnoD+P/Q1xHM+nlSzc5rBzI5csobl+coWGCGzkqUvLONgHcDqvsEyQI1EEGQaiwEG
 93+gtWSTbqTW2a2crI6salUFy7jODtuebKwVForeS10ygIGhavhN97tuakDsHon/leGS4dey3uU
 VkZSk2PsjaCGXslOKhw==
X-Proofpoint-ORIG-GUID: 0KYMSgAGPMyafHX6O2eQhDOEP56Hn41D

Padata no longer runs in softirq context, so normal non-bottom-half
spinlock calls will suffice.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---

Based on latest upstream plus Eric's four padata changes from
    https://lore.kernel.org/linux-crypto/20260713223234.24812-1-ebiggers@kernel.org/
    https://lore.kernel.org/all/20260717171831.27994-1-ebiggers@kernel.org/

 kernel/padata.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index a28fe0c4f66b5..1d095986add28 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -75,7 +75,7 @@ static int __init padata_work_alloc_mt(int nworks, void *data,
 {
 	int i;
 
-	spin_lock_bh(&padata_works_lock);
+	spin_lock(&padata_works_lock);
 	/* Start at 1 because the current task participates in the job. */
 	for (i = 1; i < nworks; ++i) {
 		struct padata_work *pw = padata_work_alloc();
@@ -85,7 +85,7 @@ static int __init padata_work_alloc_mt(int nworks, void *data,
 		padata_work_init(pw, padata_mt_helper, data, 0);
 		list_add(&pw->pw_list, head);
 	}
-	spin_unlock_bh(&padata_works_lock);
+	spin_unlock(&padata_works_lock);
 
 	return i;
 }
@@ -103,12 +103,12 @@ static void __init padata_works_free(struct list_head *works)
 	if (list_empty(works))
 		return;
 
-	spin_lock_bh(&padata_works_lock);
+	spin_lock(&padata_works_lock);
 	list_for_each_entry_safe(cur, next, works, pw_list) {
 		list_del(&cur->pw_list);
 		padata_work_free(cur);
 	}
-	spin_unlock_bh(&padata_works_lock);
+	spin_unlock(&padata_works_lock);
 }
 
 static void __init padata_mt_helper(struct work_struct *w)

base-commit: af5e34a41cd607c00ef752e00331736570992354
prerequisite-patch-id: 57ddb64f17182e9382163da55150610d385274df
prerequisite-patch-id: 9ea2c856c57f6c92abe7f2b52e701e46398cb5bb
prerequisite-patch-id: d64acc3296775ba4482d99b5a7d567af22a859a5
prerequisite-patch-id: 095134ce73f4279a0af1708ed2de4135bcb3e2eb
-- 
2.47.3

