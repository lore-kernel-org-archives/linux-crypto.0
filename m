Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A340F31CA4A;
	Mon, 15 Dec 2025 05:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.133.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765778196; cv=fail; b=o2VHbAR6ga3kNRGR6n0a+5VYxOtg6VbxVBDxK5lytpQse49EfaQRPdcpbPCkzp74vz7gIsQR26A8Ey5O4JLmM8ITuEhIBw/kXjnewGL2B8ZShJL4J8ADVALw5i0Oazs/2nmDjFAHzUm9gN2LbcvTyAIk4ytSg9LD7u1px5SxjWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765778196; c=relaxed/simple;
	bh=3OB+jI6BgB/UhEyp4zm/vEjNY96RCuADyb9tA90OaqM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ceaUV0d6uhSiFTFwQeYX+nUojPjM2dVs04DpkfMZlnIm0GpOINiVbA/g3oI4as+3V9E50PvlrdoSV+IKjOliofKKajkb8ajj8yHZlIW6v7n9Kf3lIQDWaJ8ABHSSundtRMx7kywKQGO202xQ0B4+Lw9tao2fcjGWmLmoCVJlheI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=CXwKmcVu; arc=fail smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="CXwKmcVu"
Received: from pps.filterd (m0170392.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BEB0MIx019889;
	Mon, 15 Dec 2025 00:56:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=smtpout1; bh=p
	K+FRP46iZVjcTqmqvNKXEeCpqIs0qbHPWSAn67d0DU=; b=CXwKmcVuvh9x055JZ
	t78kqr2opE6wMzQeHcXewxuSOccDt+7mlS+ckcDau/cupOVAs/2KXzu47FthP/4y
	htjWiCNR6+LsEgxJgAWgYW+HPbU/JJ/LUDoSbPaMCQg9gGXpYOseL4yE5vpvRYv/
	M4qDWSmvEPI4hoSNDjJ/GL3IYZNccBMwkcgv0Lnq54zAMDpDH+515QDLGv14q0RH
	cQOlXKP095ca1DNILamsJDaT+1oJCoQBWQnut8N2u4rRxsWk+mhD6TS1B7+6ugTF
	eU/2NOFpaIbkTrslCq7qlk0Sd7EbouVYCKC6QP0eNmglcTao2cHVQ5MU47j9DD/1
	raygQ==
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 4b146cvr2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Dec 2025 00:56:12 -0500 (EST)
Received: from pps.filterd (m0393468.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BF3vP2V016889;
	Mon, 15 Dec 2025 00:56:11 -0500
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010032.outbound.protection.outlook.com [52.101.56.32])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 4b1433etm3-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 00:56:11 -0500 (EST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jZ640L61v0/yWvXbqb+DnQzOHmgJmNFptZsDJVCddy9TiwMZvKm3f4+aqdwaYIlHMgh8OJjDFH3QsJwrFKGkQKDsO1TOivXiA72MyMok9OFyQMuVSw424n7DFPSww4ZD1V6bKCe22I3oFRTwDiULLCEHoY0JWQf2gyEAktWnBS5HmvWDDkNvHhmz9kM4L/PKYuYcu+ElMigHQP1XPbSj564dxTxNliRvzEoo4ZlSv6X2tV34NAtwjRcRp8rEFBCLPYZey9ZsX9+jMHmLoGZILh0+Q0d/fZTiRfTFwYbqJPAjyq6lfHoqV2Tgw9jEayJb8vsnx0bAadqhyDOrFcWhJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pK+FRP46iZVjcTqmqvNKXEeCpqIs0qbHPWSAn67d0DU=;
 b=GccLmjcrZcuqNTMMI34NgtYAnZxnuAVlFFhTYykhmGuu9ns7uNpRvgJj+bOX0AEsgH6t5RZLJTOdMCIxkJNOvNu5WCSbq3Qpjk6CEB8MIGDPbJWYt9VMRESvDeg8vT0zUKF363PQ/62O02etpKNMojUngIJBQvES8vO3vbaH4m5Y6wcASYdT1u3gVqfQfFGoUPcPL90hY6KfnKjfjLGEiDEj6XexFkzFu7bqLGF+2Fvr/Kizqk6Ufru9j7DIhJ8I2aevGxeHRSNhbyrN39QimXOe/2CTDv4BrTGUX+j7+2ZBmVM+2wClGM9GUUD0/JLQxVUdjdghA4GdRmj+xobpvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
Received: from BY5PR19MB3922.namprd19.prod.outlook.com (2603:10b6:a03:228::23)
 by BY3PR19MB4867.namprd19.prod.outlook.com (2603:10b6:a03:367::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 05:56:07 +0000
Received: from BY5PR19MB3922.namprd19.prod.outlook.com
 ([fe80::de91:63a:a814:6ed5]) by BY5PR19MB3922.namprd19.prod.outlook.com
 ([fe80::de91:63a:a814:6ed5%6]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 05:56:07 +0000
From: "Shen, Yijun" <Yijun.Shen@dell.com>
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
        Tom Lendacky
	<thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        shyam-sundar.s-k <shyam-sundar.s-k@amd.com>,
        =?iso-8859-1?Q?Ilpo_J=E4rvinen?=
	<ilpo.jarvinen@linux.intel.com>,
        Rijo Thomas <Rijo-john.Thomas@amd.com>
CC: John Allen <john.allen@amd.com>, "David S . Miller" <davem@davemloft.net>,
        Hans de Goede <hansg@kernel.org>,
        "open list:AMD CRYPTOGRAPHIC COPROCESSOR
 (CCP) DRIVER" <linux-crypto@vger.kernel.org>,
        "open list:AMD PMF DRIVER"
	<platform-driver-x86@vger.kernel.org>,
        Lars Francke <lars.francke@gmail.com>
Subject: RE: [PATCH v3 0/5] Fixes for PMF and CCP drivers after S4
Thread-Topic: [PATCH v3 0/5] Fixes for PMF and CCP drivers after S4
Thread-Index: AQHcbS2XR7fjiLP8002JGJrHI9RpurUiMrjw
Date: Mon, 15 Dec 2025 05:56:07 +0000
Message-ID:
 <BY5PR19MB39226E7829388FA91FDA2FFBEBADA@BY5PR19MB3922.namprd19.prod.outlook.com>
References: <20251214191213.154021-1-superm1@kernel.org>
In-Reply-To: <20251214191213.154021-1-superm1@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_ActionId=2c742833-3537-4219-b88e-f6d2031e3f20;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_ContentBits=0;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Enabled=true;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Method=Privileged;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Name=Public
 No Visual
 Label;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_SetDate=2025-12-15T05:49:25Z;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Tag=10,
 0, 1, 1;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR19MB3922:EE_|BY3PR19MB4867:EE_
x-ms-office365-filtering-correlation-id: 12cdd7fd-acc1-447c-9f46-08de3b9ea3e3
x-ld-processed: 945c199a-83a2-4e80-9f8c-5a91be5752dd,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?rQwrPQNU2EFBZ91AC4Gb9HfeDsxYoesg1q+G7gEjbrig7SNKRo8x0sk8QA?=
 =?iso-8859-1?Q?iNnthIuBIX16YduDqUOqJmTVB2wS8h+FaUZwQi5M8Oq3hxoUa3j2Y8kl6e?=
 =?iso-8859-1?Q?JtOmQHBCjz/ifDZUq1MiUh6X2scXwu2g3Oml0JLDmvm96s8wlx2bnEd0b5?=
 =?iso-8859-1?Q?k1LqG5fw5A1lXyywHb0WJdlW5UWEkUTYwQxpYgQMHws51XYBfS3dxT2NFK?=
 =?iso-8859-1?Q?Ey3CR/MDdSVSUmcOWCulS3/eRlYT1CbCyOISkuUSyr7Ub3MzHmKgKWhts2?=
 =?iso-8859-1?Q?03Hv4/GPQLAZI5AM1CTLRxepX+I0nI9vFVZqPJI36CJhj+qbG8s2CCqBwt?=
 =?iso-8859-1?Q?rVftJFCCJtoZpEvhYXq/OhOmYJ8C2H9AW8TqxMSkYh2Ycq1ATi7KU9adSQ?=
 =?iso-8859-1?Q?W5u33DJJqwSS0bTaUvhbX9xZTe+8CkCbPkN29TMuslkZSeDvrtE9XCM6ox?=
 =?iso-8859-1?Q?b5CDMevZm2IIGgqpMgPmSGFZma5uhgcdDRRUjWtUcylJjW0IHiCZ8IMqFw?=
 =?iso-8859-1?Q?dFumJG+CuOwgl/1XpPAZMBP576qynPXvVDf6gpCN9KS1krQn75jBOd/0bI?=
 =?iso-8859-1?Q?nD3SJG+Wfs3CSi5T/ZwnA2RWf5nwlQ3T1B/XT835az3pekq/I+0W1ZQXVS?=
 =?iso-8859-1?Q?IHHVPxyOkIgk8PMbMRmbgiVN+rD84jdCxOFxl8P4mM0TSXUVE1XSAGwBYJ?=
 =?iso-8859-1?Q?hh6c7ZLSxKRehokVIvl1uwJnTrJn6ombejtQy34t8sqIVWTQnQu0PR4Jug?=
 =?iso-8859-1?Q?prQthxLo9dJEi+PLLJNRtCBzG21ggfpnJQhQFiUg4dZhoVXP3J5p95VFN3?=
 =?iso-8859-1?Q?GZbeHs2m+FSARWybUWPbnHvOqpcxG/4p+MjmBEuQciQN73Liurx39mub5T?=
 =?iso-8859-1?Q?d5R1dzKakGlFsKGS6kcPHErcSDcAv2QTpCmXcnIJACZBJ+1NHDY2qNgsjG?=
 =?iso-8859-1?Q?FXL60JzpDBP1vVhk9N2ly1HJntvLnaMHbyV51NEzEE387y6MnMXus97Acu?=
 =?iso-8859-1?Q?40BFL6TiiSCw4yZuq6tzYQO7kjYODO2phT82f3uzb/YFiLdxWWilacz4zr?=
 =?iso-8859-1?Q?IS/ZqvjcCbwvWyRx0qloWYIQ8QUUNQA4Gz1GlYWpkrmkEA7SVifHnes14A?=
 =?iso-8859-1?Q?EyMuSDSQKFtj+s07uFifXZBHsbHBpJYfZ4P/+fhDejCEmRMLQh/5OGADu5?=
 =?iso-8859-1?Q?bndyr0LE1qlTLDrsYdpJIn+mJfO628PG0vsXeC/ksk8oBH+jNPuucJD/Fh?=
 =?iso-8859-1?Q?5bXwYF2f3yD62bU0ielBetOd/FPYZT/UJyiUOAYbmu/tNUFKZ6gvsFPig8?=
 =?iso-8859-1?Q?F9Of9yGQ8g0xhEY55U3WPPlc1Vowqq0z1WNeAQZZ4yEq7/OJ8FVmQqj8u2?=
 =?iso-8859-1?Q?EjmeP3hN/EDc0VznMXuEMayoMDSbwYmAXI0sG6GOYmZKQ0uV6u2ZyIWYUx?=
 =?iso-8859-1?Q?kApXclqK+JDnq54jWdws4YyP1DLpyMvCh2rTbAuSjWyzb2fOgvtfWs/VUo?=
 =?iso-8859-1?Q?v2hVdua7piYAw1hn/NE7GhZKQOosFXnuNuisY3wqYpRn1tV+p3KGR2HvSd?=
 =?iso-8859-1?Q?VHSnoGC0T2jEmgYXP3H8eHX7IcrG?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR19MB3922.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?VQNG+OMWBeYqLzbaKr326+D5Lc/M7D2SgqujoOInPwJuux3r2CSPEEpys+?=
 =?iso-8859-1?Q?r+zQCrsBpBJ31Rq88OQdSLZCmXSYitR3seF0uYD21gn9B2DLtDdTARf4Uv?=
 =?iso-8859-1?Q?YppTMkgCbcx7Zvus8LOjns8RSVSYm0cPwUKPEvlWCbJnUq+TruWC+a4phu?=
 =?iso-8859-1?Q?GyFoJh5ApCxYlIx6P6kLlIamdKpeHN6AQ9uNliBNNUKZMIdC0YkYPWjm4p?=
 =?iso-8859-1?Q?FQi47E5Ndco+7uexJZ0DEIHAQkHc3Q+DWc0n/S5Lp1XjBqc54CVUmOqcXu?=
 =?iso-8859-1?Q?ebcso/6zoOmraFYrl0CBQ6VNNagfAvdKXxgf+lq5ytse0gInnRmvMLiiF5?=
 =?iso-8859-1?Q?eQgp4UJ61vUfzDLBn4vyMQnVZ3VN5X0ZLfn7u120wtu3bidhjCJO4gcOhO?=
 =?iso-8859-1?Q?O7V+27v5qAXMnv3OyUbwcej2WjLTCjP2fbZdQlrc6kjSSP+/ziQKm4iImU?=
 =?iso-8859-1?Q?qahlshmU+vXbZrxPrYG0rMg6Zjk2Td4hNAAan1i6YjLe4IYSgqoh9X7V8J?=
 =?iso-8859-1?Q?YHodP7OeqsHDbAirIZB7HXhsdzbgFemI5tS3e+rfJeBPLV4EPyX5pxJh5X?=
 =?iso-8859-1?Q?YtQy8UsYmb8x3cea9bh2oKXwgjjwZllU4+100Pu0OPkZLcTJGcE0BEJCxQ?=
 =?iso-8859-1?Q?CeZksYLqE/IEyBs08Q38QFg4aTmMecTQs9+EkHSy8etD6n7zzQ8WYZI+fC?=
 =?iso-8859-1?Q?Yyf1EniNKVYsIjLv8K716/8QZT9OgX4wg9OHJyfP2mZETyA7jFwDWwCVER?=
 =?iso-8859-1?Q?yRzLW8kYQwRVde0zr3qza7/AUkeH83UboF/Wz6Ap3cZUuLVdrRz4t5giMM?=
 =?iso-8859-1?Q?ZdZ22ziP9vJCAhtupNzEotOYlQyuGFkjDQGL2EQ3sBxsXbe2sSTMiXtsMo?=
 =?iso-8859-1?Q?xbw7ojrWYK9wqrvbmYGfX9fj+UBPzo4g8hsUaGVaEN5s2FPskVAUJylkHu?=
 =?iso-8859-1?Q?iJpL26WqznPOnWe+yoClKMcii6uxy9KfMYZmO6f7BrK7gt5SsDlyDhygeg?=
 =?iso-8859-1?Q?/Ql3W/mb2FOFzo67/5zlwHWuBdPSJXl7yWBGUWvLaQcYJ3zedAWk5S8qqy?=
 =?iso-8859-1?Q?2lkbX5jM9Wpeh4S1ojBGLqoDVkJ7X1NIJhNXGMxnppDrSK4B44SrcbsNiY?=
 =?iso-8859-1?Q?J5mhOY5h56GDVlHgSm54G3yLxMbvcGoFfhsfVsNbQgqDYstg9w2NCnhgWl?=
 =?iso-8859-1?Q?2gLW6HmPqGLo7BS/fuDw/b1LdGlnoIrXfJrhJ4KrVIK+K8391DQkRI8dYM?=
 =?iso-8859-1?Q?zhS+TMexVElHoTaM9qtdA4dRIi6SrEPxhQLzxxWBIwECKRxEFOwkAKjPdc?=
 =?iso-8859-1?Q?8PJuEabrDku4w16ktgljkLn1L1KUBRBmH86yjtbgizFFxij2top0//FHF3?=
 =?iso-8859-1?Q?twsGQ1gmLUkS3MJPIfKMypziWI3UOOKEYTKClalZpo0pk5wCO/MvV71ShB?=
 =?iso-8859-1?Q?oHYKbi7HpwnJ5cnRAfUxjhdBSjZxHygiY4OjqncLfRFQK0ptPWDBQ9I1cd?=
 =?iso-8859-1?Q?y4woNtOMarGNxnhmw6aVjJMFVGGnx1mhgcqWwtQR9aR8DQ4s2sebMPsb99?=
 =?iso-8859-1?Q?QsfKy4Oj0l957FRm62taS+nEqV2MA4xZksn/MJI2ECIdNqH25/aWQufxXg?=
 =?iso-8859-1?Q?J95KIxvH3Bvg47dVtzFH4xiS7pury/LA3i?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR19MB3922.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12cdd7fd-acc1-447c-9f46-08de3b9ea3e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2025 05:56:07.3219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2PiJBd2lL05ccjsDfwOcbVasHYF//fBw8h7ZVDja6xK560KZzFjMGbjrzIznYhFi/hn7Ec3dCupbfN1Qak+VVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR19MB4867
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-14_07,2025-12-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1011 malwarescore=0 adultscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 phishscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130064
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDA2NCBTYWx0ZWRfX7XC6UxPM6asN
 EY7x3+jRXQwVkemD4GM51HrKq8YIHHHonGs05Ub9623CCRAVzMaHXfcLaIAy9umHsIUX1TXSAlp
 NTQb4FFZ5xZkahiQqx/Hu1ZtDl8aq8/31zlXbTzErhTNCe9/EBRDZGOwqBScgy/cM+lFX0wLhXZ
 eHiqW86HDm0FPyy8iValgNjAaf+JOK86fKxfWmHYp4SnmtyB0ik0Gz2WPFN03071JspvjO5nFVe
 qZ5R7+1/1xjJg90YnklkGlLCjiLrVQl5R64AV/SsDzEvLDyaYpmlthClotIcxaPjqHDfwvHJ9fw
 dPgY1y3zeQoi6Ke79sk05jE9wksJd2NhFrc0LJxBbpNbFfM5tF8G5jNPTLJEIJzEZdI/JLJUOA0
 6C57gcMBh+nmemYWHn11KZ09jrW6bA==
X-Proofpoint-ORIG-GUID: TxKNW7un75h5GIh9SIWnySm4m6atUErz
X-Proofpoint-GUID: TxKNW7un75h5GIh9SIWnySm4m6atUErz
X-Authority-Analysis: v=2.4 cv=N/Uk1m9B c=1 sm=1 tr=0 ts=693fa2fc cx=c_pps
 a=Z2e5DKjA+8LiMDv5v6mwwA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=zd2uoN0lAAAA:8
 a=FNyBlpCuAAAA:8 a=QyXUC8HyAAAA:8 a=J1Y8HTJGAAAA:8 a=pGLkceISAAAA:8
 a=iLNU1ar6AAAA:8 a=Ms5nY0dGa73ZpiRCkZMA:9 a=wPNLvfGTeEIA:10
 a=hlJyneSgMmFPbskH-t2w:22 a=RlW-AWeGUCXs_Nkyno-6:22 a=y1Q9-5lHfBjTkpIzbSAN:22
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 malwarescore=0 spamscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130064

> -----Original Message-----
> From: Mario Limonciello (AMD) <superm1@kernel.org>
> Sent: Monday, December 15, 2025 3:12 AM
> To: Tom Lendacky <thomas.lendacky@amd.com>; Herbert Xu
> <herbert@gondor.apana.org.au>; shyam-sundar.s-k <shyam-sundar.s-
> k@amd.com>; Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>; Rijo Thomas
> <Rijo-john.Thomas@amd.com>
> Cc: John Allen <john.allen@amd.com>; David S . Miller
> <davem@davemloft.net>; Hans de Goede <hansg@kernel.org>; open
> list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER <linux-
> crypto@vger.kernel.org>; open list:AMD PMF DRIVER <platform-driver-
> x86@vger.kernel.org>; Lars Francke <lars.francke@gmail.com>; Shen, Yijun
> <Yijun.Shen@dell.com>; Mario Limonciello (AMD) <superm1@kernel.org>
> Subject: [PATCH v3 0/5] Fixes for PMF and CCP drivers after S4
>=20
>=20
> [EXTERNAL EMAIL]
>=20
> Lars Francke reported that the PMF driver fails to work afer S4 with:
>   ccp 0000:c3:00.2: tee: command 0x5 timed out, disabling PSP
>=20
> This is because there is a TA loaded to the TEE environment that is lost =
during
> S4.  The TEE rings need to be reinitialized and the TA needs to be reload=
ed.
>=20
> This series adds those flows to the PMF and CCP drivers.

Verified this patch series on the issued system.

Tested-By: Yijun Shen <Yijun.Shen@Dell.com>

>=20
> Mario Limonciello (AMD) (4):
>   crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
>   crypto: ccp - Add an S4 restore flow
>   crypto: ccp - Factor out ring destroy handling to a helper
>   crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when
> PSP_CMD_TEE_RING_INIT
>     fails
>=20
> Shyam Sundar S K (1):
>   platform/x86/amd/pmf: Prevent TEE errors after hibernate
>=20
>  drivers/crypto/ccp/psp-dev.c          | 15 +++++++
>  drivers/crypto/ccp/sp-dev.h           |  2 +
>  drivers/crypto/ccp/sp-pci.c           | 24 ++++++++++-
>  drivers/crypto/ccp/tee-dev.c          | 54 +++++++++++++++++------
>  drivers/crypto/ccp/tee-dev.h          |  1 +
>  drivers/platform/x86/amd/pmf/core.c   | 62 ++++++++++++++++++++++++++-
>  drivers/platform/x86/amd/pmf/pmf.h    | 10 +++++
>  drivers/platform/x86/amd/pmf/tee-if.c | 12 ++----
>  include/linux/psp.h                   |  2 +
>  9 files changed, 159 insertions(+), 23 deletions(-)
>=20
> --
> 2.43.0

