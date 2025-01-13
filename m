Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFF44D8CE;
	Mon, 13 Jan 2025 17:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736787642; cv=fail; b=aOCE4LvDe+CxKiZZbzSTni+LumPywB1KxKxXR6qPYMR9UFD6s8JZLdUuTdwVtET3zRP9qVAyeTVPyi8QwVyTrXpTTFkDpmvJqu7RO0udMsDDZWXU/NmGz7WOtcVeFRC3SvbpNrUNDak7hSsfPeGNkdtMzLpVwyeYCuQALDOnY+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736787642; c=relaxed/simple;
	bh=cW/hAEvj2VCPZBKcXXdJMz1egdr65xgIh1JISaykiD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fHZvpd5oiVVTxX7M6IDZXWKidlCYW5SCOdJ6GlNSbxg5ljFOW6/sRpnXjKhzPRkdSwvy1bUHiVh6RAu2g4szbrUUa4UMVczcvX8X1u5z96g52neEJAJ61zrhyyJN5+72xU80iQhLv+eb3nmsfKMZiNa7WxJtymmZ4+EAIAhOGLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Gw373lt0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d2z4gJT2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gw373lt0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d2z4gJT2"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50DGttjH016199;
	Mon, 13 Jan 2025 17:00:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=x1Ue0VhIuEKbQHnZ1g
	tDfQh4SVdyPPlrJxdNFi4w2iw=; b=Gw373lt0txhTnPwmII07HZXdD5pRWS1XD6
	a04WMhv3dThUJcNUEXtdfR5XfXI7zF6W6j2xdjahP/GNtXt6ZbmZ5WBp6SexUCCo
	FkY8q4yu4gOBk8iwJr8Sx98wux/JoDj4tajuKQALHqTXySxTAaJpIypDfg867wah
	e4KUWmrK8k6p66enlv6q3mc/6FjkPlctYEVRdZM2Dq5Xx28LqUxQ/hnJ6HlKqHAv
	zagBMiCnyNj5oeYWYeMS4G0kF8hOSmuOBhvkD7FRk+pen0hjz7oDAdW0yYKWZF0l
	o8MC3SoXTOmhZE73ncLsX8jNuarefWe9En1E9keir7PeNj1NWd+A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443gh8uxh3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jan 2025 17:00:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50DFoKiN037167;
	Mon, 13 Jan 2025 17:00:21 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2042.outbound.protection.outlook.com [104.47.55.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 443f37qn98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jan 2025 17:00:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AFd2Rn0CtFfjOTRcGAOk1/enAixNNvSkJ0Vw+WfDU70QECHYMT0Yn9lI6eN1lxifSyjinkAcmVUL+kzYuBjqRAJT9L0T9WiPPqdkiTcRcFla0vJjqzgvhat5JWMS3K7aXW2A/NOfAqG8uRkkXnA8lAgcgKNO9FA9xI9PGcVdE/9ABA2lZrwPCKFpUgW8TSobFyjARPMUP8uqzyXUpXnQEpxSEg+ehJ5QUaQllF8o8kAKSLMea6/LuDYDHh75CmHSd8VvM9ijGKGXcy3RRHQlX2Nebb7aQ72Bu24kV378jIEAm13KSnyM1aB6fk/2s5LCAFTXoGTY+IyyO7y05WIA0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x1Ue0VhIuEKbQHnZ1gtDfQh4SVdyPPlrJxdNFi4w2iw=;
 b=dhxycE6B0/FooIjFjpFrHV3HCw7vGovBEJw+OoCLH35Tt8jD52YY0ps13EqXFbTtb0G9NMFltWD3nJ0x86Y6TudgXWKu6tNiBz15Ct1OjUEwxKKczKPDmwHldZjnAjkUUl0FFLl2ZeTn+htw8bwTSVqHpucVAJpEUp3Gi5D8v672363SwQwomz/8bbVczU/zdTnKTNTEECmGgOy8ajp8G3qR7NgM7YcVWqJVfqff0zGkc/AwYBFwz80csNg8MGZWP01XveeTCHnni5gCg8NseISeKSUjG3ff8fzwbAD5U1qWNUR6TXuVWbipTxgjFcgdVzhWInDzShmR6vz83duxVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1Ue0VhIuEKbQHnZ1gtDfQh4SVdyPPlrJxdNFi4w2iw=;
 b=d2z4gJT2dwbeOdgadh16F7snsfT51eUcsg4SGlSO/R8sH6O6x/PbOxvVVUWzhqszsEwlJf8hhvE79UlNPfwuZzOFQRBOmSsu+w84WvAU7j5L+uZE76pl/XDcdNmf/jeE6fUxfy968ZdQKexBXX8omserBuGNQGpuL8ZJZzfAtsk=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by CH0PR10MB4988.namprd10.prod.outlook.com (2603:10b6:610:c8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Mon, 13 Jan
 2025 17:00:18 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc%4]) with mapi id 15.20.8335.017; Mon, 13 Jan 2025
 17:00:17 +0000
Date: Mon, 13 Jan 2025 12:00:15 -0500
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: steffen.klassert@secunet.com, herbert@gondor.apana.org.au, nstange@suse.de,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        chenridong@huawei.com, wangweiyang2@huawei.com
Subject: Re: [PATCH v2 3/3] padata: avoid UAF for reorder_work
Message-ID: <vub7syv7k5t44snkkkdrqsco6jlw6bfen5xbbvyz5wothfjfv5@n3w3gdqjrx2p>
References: <20250110061639.1280907-1-chenridong@huaweicloud.com>
 <20250110061639.1280907-4-chenridong@huaweicloud.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110061639.1280907-4-chenridong@huaweicloud.com>
X-ClientProxiedBy: BL0PR1501CA0008.namprd15.prod.outlook.com
 (2603:10b6:207:17::21) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|CH0PR10MB4988:EE_
X-MS-Office365-Filtering-Correlation-Id: 19a1ff3d-1786-46da-9c9c-08dd33f3c1c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ise+XIYfWmk3uQCZlfeCMnZWgOR1n2HmF/5nPV3e5yLUYADpCuK5TQt419P5?=
 =?us-ascii?Q?9S2fI6bqUBVDXsoJb2cwVzn95+hbxUG7RINFhXQmzo71JlSOUDw8wlq6e3CO?=
 =?us-ascii?Q?LBuhsivSUqlPDMeHvKcK/qcCZWI3IF7eZTPUo0yC+gTHDyYLJda7FHjjdzWi?=
 =?us-ascii?Q?E492rx7uDXqv3RQ9Wq4kizLjsNgpozKybhrRLLyMqaa4HskDYYjTX80SWCfI?=
 =?us-ascii?Q?nltvb0XdRxx2H3oXYrzMR8IE64vZ3hMHkskTv+49n69OqCI1hv4kZb+/Kcl7?=
 =?us-ascii?Q?xXtl5ZS29QKDdTARyXNj3j2ZzoE+Vg6F3nGgvN1EsaOgF12Y8wH6u36r57vI?=
 =?us-ascii?Q?PgZ5G6o4LsZyLb77m6ZJeck3tXFnar7zFB154mzGN7gAPpaqzzFcP+FpRjWV?=
 =?us-ascii?Q?kcqdkt9xYmPrxTGKtk7mE0tGDYX1y8V8FYdFByHTxaSaG8reZ8LE75G0UvQw?=
 =?us-ascii?Q?bx9aL65CNISeML19rCDzgOeNtrVDbma7kUNCyCgHPQhYbEqCa9uvEkFnSglc?=
 =?us-ascii?Q?tdP4KWismyMHwfYyOxEF8fuZMFNoGW1g4iHHDw3hmbqn1yrJ4Pgtob5R2lEO?=
 =?us-ascii?Q?P9m/2BNPJr2cXorij2Qnv//QexLG5jU4dBClnS2t3VQhszYoUiLkp0xOfySJ?=
 =?us-ascii?Q?A+LzZ1OTFwSNjfpmkFy2pbL+lbL4bSbj0Qgdp8LXN8dboBHJSgRbwz3PG7Cf?=
 =?us-ascii?Q?ZlZzZ7K58/PY0tf8RGRacOoWMlAZzkTKVW47O0OSR25KAoBXZ7dKoFNPCwVy?=
 =?us-ascii?Q?0WpyFEAQVq/ieo9EQiIBHch6QtbvGyE4EkXEXSO5dOJenU8nEn+z446vfeAD?=
 =?us-ascii?Q?yUs6fg9zBX03MGokxCfAUZFDGYxFyvu51n9QW8N/QfN43UKMZQ68UAyZ6EBg?=
 =?us-ascii?Q?TLkt9qdIGfJSa+cPByI6h7eV/Z5sK7lFXLi5LqntFMtnfGgczptk4DrYKfjV?=
 =?us-ascii?Q?gNQKz//CADanjZnTyvs2JJa6CskVYRgWl8TMoflptW/4AuQRZeTw2wfoXq8u?=
 =?us-ascii?Q?t5l8DthMx7wqk2AhE21jd4HbFuinDuD3tSWtGmtuuyuQPeKYV+vGoOqHh7bh?=
 =?us-ascii?Q?xOs2fIFk8Z3DmBZSg1CPspxEJDDJ68T6h2JRqPOeBGy/7AVNe3Z4mlqjGCOF?=
 =?us-ascii?Q?oO2lxm1wd9T4Kqi6wh+iD8V4Clut/2rdTbGixjLeq8Bi+98S5GLFZoM16a8L?=
 =?us-ascii?Q?nWGZw0/czWRTDqJMHaCQQc2DzqoLDS1UThzMNledFWhsf3+EqfzAG63ZKUgv?=
 =?us-ascii?Q?gAZLoWuro3AEtVF7xHz1h1lGP26zkrzWpywvc4urPYLnb7i0VikQG9nHXOhg?=
 =?us-ascii?Q?NEculTecbQ9C9EJG3J23uqVUIHB4/QN4QFJwYcSEj1OazmENVWInDYpnA/M0?=
 =?us-ascii?Q?jp/XzngDhu6JuOj16qJ3Rn2Gf84t?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?50j6ZJJ5RrJ97kh744Gs+kzeR43OIK3ZZRXOon5ocgPZk1KtX1Y4xhmjQJwm?=
 =?us-ascii?Q?JOBouzQX52C5KDZmU/eZ6A19ru66FWaRHtDXSsbF8BFvmG4kqVurz3EWkk4P?=
 =?us-ascii?Q?N3+id4FTCDF+Lqze6IktNNZWcP4JEeBeuUfVCKtnMJ3YSM72PBgeE1k0nTI1?=
 =?us-ascii?Q?1gONse2oD3FCZPV2uhirwVflHsoWNQvOPkWCIgj4yNoXA7vpzC5t6wUD1Q3U?=
 =?us-ascii?Q?ZiLQNPdcOM88o7hi4FQIfOOqT4/SMB64YR3YuyjmVSwllupKrelyZlJhJKhQ?=
 =?us-ascii?Q?uWsTG64HHfCJTef4wI1DvoPWAc4qRMm4tQUsEuY5T/j3EBikCsOSHvFqtRCa?=
 =?us-ascii?Q?NEoDJ6iy3PTfteAu3SwBkukmNOWZFxMRcT/AqLdP4IArYjpMq0N2WkF3a1ZI?=
 =?us-ascii?Q?O4VVuiNepF9i4b7ejf3OriuEkDxDKtTk337l42AEAXZnXzdfx7L5mcmtDgMq?=
 =?us-ascii?Q?Jq4oVRJdVWCgtbvS1lYOAOKTzKzokUUz4t6u2Wi9F61aHHi/d/Hif/xFRwo5?=
 =?us-ascii?Q?AR0o1JrIZytPlgfMopbvP7qATO92JZVmL+wqsI27WytNPnUZsyqHVn86zLSX?=
 =?us-ascii?Q?Rky/ik13o7fH0myB4Ktws0Fb1D7TW838XViuud+ELh8m4qlCAhNS+HWcXsEJ?=
 =?us-ascii?Q?6KdPIIkc69Yg7T8tt0u5v4t0rkYwDSSdvVS4syePvqqxmOsm8FC/2BxoT4N+?=
 =?us-ascii?Q?O48g6sBX90d2IIvIYJmhODRPvTg5xD4aCEWBJB7VMWyuMWpxhNQ69t+fanm7?=
 =?us-ascii?Q?zbdkB44NlwOMTE1FmRVqOCfkgUIoLBh7AxliSmeMJxkESadst/nJSEEpIvSq?=
 =?us-ascii?Q?aODLjlp6Dp6EKWJsvhKLiJiALmjjEJWpbgVkh1RFP2Vqxceidr1aO5iTW96X?=
 =?us-ascii?Q?PJrGyHmNDoNOdYgCLiVW/2m19p+5+O5xuIKxl0CiQgy547fb/K5fDGULQSi8?=
 =?us-ascii?Q?5CCVhMQRX90i7UTJeVeD3zM2kjJqGDqiq9K/dGFfc52CB6SWMWKP+Y3sNf1F?=
 =?us-ascii?Q?qcgNdvanmQbhOcA3o552U9Jc9DbeWYVwWUAZv4WBJ23iDKS2uLo0bCvB+3pe?=
 =?us-ascii?Q?fk2+wFWVzSIBXCmMnOnf3RwxvfjBfYE7m825yN7x2pQnIl1vbtuF7WTmopD7?=
 =?us-ascii?Q?WkP9CQzLTL+CwP4kFiK7sEvRkRFKlB1bcNc9eftWhbfSXM8pdnkOftDwkhCy?=
 =?us-ascii?Q?gsSWACcgaOLOXxKz0bAD1VU8IwgW4oahDWjIrSQ0nuhQW8FTdr7TVH+w5c8s?=
 =?us-ascii?Q?uC3leO3RvOVT14ntRUL2eGfcZlsSBKHWzYg4DTf9vSSdsvW/BkLL9juStk7u?=
 =?us-ascii?Q?GoxM3iuxkkcyaj9/8jgUPl/fNclNtR1tIivNxVXplbknWHgZpCp+GnXxuB1Y?=
 =?us-ascii?Q?LnEeb/BZzL4ymgvM26iq1QasSkrK3zku+4fLvQaoDVtwIP4S71cAEf1QnedF?=
 =?us-ascii?Q?v206AU7vmxwSoRFjteg5Z8TdFTYO2v98zWEVx9/D8E3X+ols1mZE2OiFTMJt?=
 =?us-ascii?Q?iwCaag7O5rHmwgyfloUL/jU6iPJnrms/+3h6y74K5+fETbkAOjaw4+vYDlOh?=
 =?us-ascii?Q?OB0rfCnmaB28Jdi2FE8fQG/kN8u7kaoshSpsmTSf20Tue63Leteliy1ivLoN?=
 =?us-ascii?Q?PQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	F8DtjZCwoajQyvmHydUJFpdBUIw9l80T1j4SigEGWINWKXAYspW2wIIno3TQEC/0/HmUch8jIL2RnB7iH7gV617TOv1V728MoNDDJqN+jb09gvA3qDC+8xHepBUkDT7XiWoiNn4ykZdRJ5W1F/35ZMhmQuYbCxqGxbd/lL2VsaDzvyneam7SL3l/YGhGa+fLQ4pe54m+ZaX2cKZ4FohPpwxI4nGLD3Hwx0YSSVvCL5gx0Mdn8d9WrHLqgtteMBPvfZhDerjQUwyxfx0MctS6EzS2oIS2alFE+1SpQbByZQDkpaCF3R4Ki2qmhMoyZJ3cmCqMu0mWP6rYvwKujhAPhpit0lSZ/4UNn95p0hOpEtoAy8ZKNZvKpVkltH/kglOZsdoXAk7IaySjrJsv3HuXnAoM/YobgU5w4zbbYeMNSdLvAQHgDTkdPbjs6STB/0XzQN3WKbKySBwvk6C5Vmkq2BtKPi+ia1XI3Ae496d36+zHAU6f/zQ9q5MjYTUVRO9JeOce+OLz1jfUhVI0w9CWWquBw8BqM3kuqpnX4ZDEx8XPRs+fg9D66KZZCuFt4ZOEFxhpoAkYdSxl7AqEKo/xwSQAaDIqAMUQHbZm9rZut90=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a1ff3d-1786-46da-9c9c-08dd33f3c1c6
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2025 17:00:17.8661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DFHcEFwhqvQHWbYnVmL72pLwISClzSU7ruUlOWi6ibKYXV/74THbZyUIjdJu2eCR73QZeUAeMc/RuQixgqeu9IrFfv3E3wcajUh6ZoWucWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4988
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-13_06,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501130138
X-Proofpoint-GUID: E_QxfA4rqwlZ28lypFyDiRKTi1Z3KFql
X-Proofpoint-ORIG-GUID: E_QxfA4rqwlZ28lypFyDiRKTi1Z3KFql

On Fri, Jan 10, 2025 at 06:16:39AM +0000, Chen Ridong wrote:
...
> Fixes: bbefa1dd6a6d ("crypto: pcrypt - Avoid deadlock by using per-instance padata queues")
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Series looks good, thanks for the persistence.

Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>

> diff --git a/kernel/padata.c b/kernel/padata.c
...
>  static void invoke_padata_reorder(struct work_struct *work)
> @@ -364,6 +370,8 @@ static void invoke_padata_reorder(struct work_struct *work)
>  	pd = container_of(work, struct parallel_data, reorder_work);
>  	padata_reorder(pd);
>  	local_bh_enable();
> +	/* Pairs with putting the reorder_work in the serial_wq */

s/putting/getting/
