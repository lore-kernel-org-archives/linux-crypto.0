Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011053.outbound.protection.outlook.com [52.101.62.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F80242049
	for <linux-crypto@vger.kernel.org>; Fri,  2 Jan 2026 05:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767330081; cv=fail; b=uvSbEdCQf+L4j4CvUhu8YbTyq4tIddKp2f10Dihw6S2jCopYs195hi2nkCG94XiQcYXneKEBepqNN7ppRYsfsc9DEMo7N3Co997kGyQKwBc7zvekQHWXadmv4SGthSFk941ibrAnsoJv/cQksfkmRGyTaBP9E2v6YKBIcPCo8Gk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767330081; c=relaxed/simple;
	bh=32KFy5CBm0z7iT1vwHzx0VJ4MAUKu3IBSSKqKfYgEBM=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JCnTFVMIQHDQa60BmjTR9uTqyAMv4m/tMtCkvU0BK3Y98/qaAZNscdoJcrO2uv6juHL4mmjYru+deSkuxG/cFE1x3O3wch928n4Et3Ee3RvDB57hpzLy0ciuzVrN99SfHwZ7NXazuYlQzPR0mVzSmaDFqx3UzOYOjOPkTPcaAyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=p7TXgbKQ; arc=fail smtp.client-ip=52.101.62.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="p7TXgbKQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sj+Q0FjaWINP9yaEsG27CiHUiS9CHNaDWZBTLrBPQWVQxfN2EJddFteW4j+uWFEaTvA/NscmqyVCOrUv/57cU6poflewVlYvJEtZ6MWxL2+50Znqx8KKMX56xWWU8xNplvDdJ7/Zggm5ksMOSt225532/jS8ejAFTU1YX3IYCOFXL/Fa4WaaPZak7AJJemQ/A8xYrP6HmESGtA0Vfelyh1/O4JFTY9xkxmAZM51lkz8Kg5Z3s0l74G+BCGS0Du16c7m+i8ZMnLxpl5bmeBD4EU2R5uUCdEIF9/ImSylLdThXX5trFGavpx2NIh+oh2yRJKNYAtCUcgdqFsgK9C8h/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GnkrXDyZkFO1z7SdDk1W2hTLGBdeISPkJTFs1YPxLyY=;
 b=MJTNNoWBul2D7uI2DFl2FZH6EQklrC9E2yem2cdhhZUfexEEyZmu8hPcSS1XIwSKrGWXLF1muR2JSROGMmP6odqbo8czgoWxw4Bkl0qvITx3R7ADnboh0FypMsnc8NVnkwxL/LnGabgmIgHD8L5ziE3sdNyvcGSp5Hrz8tNVvqRmlOpm0F8C5ChsVI7gsIOKWRLoB1SzZEIUb/srgTs6slQDBYAEY8crY+cvRDU3rsgpZQJyc20LrC6QTEyEPfeOO6A+25omr+1Ro6gllljPle0Z5jdO1x9HsQzybnMMWR5oTDLlhO5k8UXwkNMcG3RqSgZM3o8RaHkhkOuPql8bQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GnkrXDyZkFO1z7SdDk1W2hTLGBdeISPkJTFs1YPxLyY=;
 b=p7TXgbKQg3L5fJtPyK8irMNMAuO5hyAtTCjy0eLONqThjP1Clga8ZyluPhP7zt5+Vr3El0MSdxCZ5j6K8vpNH1OPbztbuImXlAJL/MkmCEmQg6kF/PwDrsXEC39Z6umpji27/ZJBnA7lQKhjh/SvJrIC5Qz1xCr5DopkoHwWst4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS0PR12MB7728.namprd12.prod.outlook.com (2603:10b6:8:13a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 05:01:13 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 05:01:13 +0000
Message-ID: <65af8cfa-915e-45e5-b590-2696f05761d2@amd.com>
Date: Fri, 2 Jan 2026 15:59:45 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: crypto: ccp - Use NULL instead of plain 0
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Tom Lendacky <thomas.lendacky@amd.com>
References: <aVHPyZIUZFLMdNYU@gondor.apana.org.au>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <aVHPyZIUZFLMdNYU@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYBPR01CA0172.ausprd01.prod.outlook.com
 (2603:10c6:10:52::16) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS0PR12MB7728:EE_
X-MS-Office365-Filtering-Correlation-Id: bf3678c5-fe41-43a6-c03d-08de49bbf37e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bE9mU0FOTW14SFB3ZjdPeTg4V3ZGZkhoc1d4alEzT0tMVFZKRE1INzBHN252?=
 =?utf-8?B?ZzNZWkVPOFQza1pEWFl5eHZ6N3pUbG9FdU5GMFNXVlR6YUVwNTNzdXMwRHVm?=
 =?utf-8?B?d1JrTTd4S2plS1M1Z09adEM1T3UzQ0l3WFVLYWxvVmhmZVk1YUFYOExTdlg4?=
 =?utf-8?B?bzNiODliejk1MUtOTUR3eXZhNHR1TTc4NENaelhCbkZ5djJaK1lZRWdZcWx0?=
 =?utf-8?B?QUJIMHhydElHbGgrN0pKemhzQ29yY1FhS1ZWVUxrcDFPNDYzalU0Nm81MjFU?=
 =?utf-8?B?NWd0OWwyUGRsTmNwM01LcUtndzNIK2xUQXhkbklPSjFxZVlpcTdWSU1RTmND?=
 =?utf-8?B?TnRtcldYcFMwcVorZG43ZWpaQklNOFlFVllwMUV5NUVNenZwMmx4VkVxcWZQ?=
 =?utf-8?B?SzhYUWd6ckxiRTN5RVYzeFU2MGs3L2s2OGxVbVgzSnp6TlR3dnJwVnc1VWRp?=
 =?utf-8?B?VnV0QWhydmlNUWo0Y0xCVjExQzFRRUN1cGtkZ001RmZYb3lWdnozL1NZK0I3?=
 =?utf-8?B?N1lsOXZNMGRsNi9EazIrTCtvRGFqTkNOazA3SnI1WGdrSFJSZEZOTG1Ta1dn?=
 =?utf-8?B?WVlxMUtaOUkvSk9HYUpBRVBTZ2p5eklxUEZPRnhZVUR2b0pPd21LMHBhVGJq?=
 =?utf-8?B?eDREUExMYlVQaXJZWGl0Mms5a3gvVVhINUpKN0F6a2dGNXJ1TVNyYlEzWFpq?=
 =?utf-8?B?RjJyUW1LdUNTanFEbXI2UVhVMS9BQ3FhME4wR2tnU1VZUWFGZzd6c0MzVmF5?=
 =?utf-8?B?Q0wwSDREOFF1REhZdmRvZnA0L1NHQ3UrNUU0R1RSSHQvTUVuQU9aR1l2VEhp?=
 =?utf-8?B?MStPS243TTVKdElOVWFYTmZla3NNcHh6SzlUclRuam9iUDFaY00vajc1UkpK?=
 =?utf-8?B?RFEzN0l6VWlPWXBsWVlDUUkrQkpQZzlwS2JxV3JiZDY4M2Q0am9jWUR5TW9B?=
 =?utf-8?B?bVA5Yno5T1NVcHlMUjBQR0NFODBQaE1SOVg0SUxPTnZXZWNZOGlUbGZuMkJE?=
 =?utf-8?B?emZpTlkzYjI3ZXdNVUpyWlVjMWljWnZVWWI2VDVZNkxYT2hrRUJncXppbk1l?=
 =?utf-8?B?Z1djL0lzWEE1NmpjMEJZZ2xxVS9MUmNSSWNkWlVmWWRVcy9xWTIycGEweWxW?=
 =?utf-8?B?VHdPaGZ4M2huZ21ENFFWU3hudThCYTBhRDZYdUkzZjZST3dmTk04aXRVWWpk?=
 =?utf-8?B?SjlxNXBqRlBWUlRMWWU2VTRMZm5ZNHRzU0UrWVByUTdqOVgwRi9SNDNlT1JQ?=
 =?utf-8?B?SEd0U0FYQUwvTDNzNVloNDZqUVkwZm1hSmg2M25TUUFPUWE4NGZPbU1jR2Fy?=
 =?utf-8?B?bndCbll2enJ6NFZFZEwxQXBMT2RBcHhMVmdid2E4aWpLRWRMOG51YWdFbFZO?=
 =?utf-8?B?SnpndURzek4zblAyQzI2SXVzLzVZeml2Y3ZUb0tkY1dvQTFJS3U3NlAxOU02?=
 =?utf-8?B?Z0drZzQyZXNiUDB3V1M3dW1OVUM5elJtbWNzeGVQVis1cXNyK3V1ZUVacXBS?=
 =?utf-8?B?b01uS0FOMXM4ZTdSY0cxQWVpMVRNODFBaFBYbGdEQkY5WjFIL1htTFQzblFG?=
 =?utf-8?B?ZkdaRlhmelJHTkhlWWVYS2s2V0luQ1Jhdk1nelE3OE5NbUFTc3ViQnpvbHJ4?=
 =?utf-8?B?ZFZRK01EZ0FkeEtaVlJDVisvNVRnUVlhUng5bHd4eFVFcFNOMi9FcUpDZG9S?=
 =?utf-8?B?QWZEZWRqNzNBb2xsS1lXbk1pNlVnd0pjbWh1cDY3Z3JQYzVwdU1PeTl3VkVq?=
 =?utf-8?B?U0xWaG9PQ2RWT0I5YzZHVGRMcVNUNElHc1dZbnhwRU9WUnkxb2FxTDBEKzla?=
 =?utf-8?B?ZjNScEZPc0JUN24wWlVhUCtvV081cUR2T0E2Uk15SGR5b0NleVBjekl0RTgz?=
 =?utf-8?B?NnZlemk3ZWJqbHBPK3htNUxyQUovRmtMZnRid1o2ZjM3QWdaTk5DU0ZWUzVl?=
 =?utf-8?Q?K5JggOgturzRZrizDOj1RFs9L8YCID5f?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d1BOZXVtcjMrZ1FVeTFyUzBBZ3krL3dYaTBjUFo1NzN3WnNGNUx6UUpQeksy?=
 =?utf-8?B?ZmNtOW5MYkZLRkowT21nTnhta0pWbGNzL2FMSG4yYlhqNFplL2FrYTJQN3lx?=
 =?utf-8?B?VXlad2VoUlh6QmMrNmQrR2kwbElpd21CMzcvV1A4QXJRYm1ocHF0UHMwT0xW?=
 =?utf-8?B?ejd3V1VhWm83NWVsYkJiRThZbFNETi81aUJDL0lEdFg1cEFMOEI2UE9QbGVu?=
 =?utf-8?B?cU96Uy95QVBRTGNvdGRUeEVwTlYxVWZsb2djRExjYnN2cGNiWGE5cjZMQmZ3?=
 =?utf-8?B?TlczUnVkRHBMaWtkMXVyQnlDekVpVmxaOU5vS3NubEdVRys3VlpsNVNhRUY3?=
 =?utf-8?B?UDFGOFgyV28xRUdPdURJeVpEMkJFTFBWdmNodjhhb01KMUtsb1AyVmxnbldS?=
 =?utf-8?B?Z2dXQTZITGtXbm5YdmdjM2FqQldva3dZUTJVTVFMbVpsZ0RRU2RoeGcvV2NK?=
 =?utf-8?B?KzloNjFiUVpXQ3daWms4bjBncGRtMEFUYUErWWh5QWE5dXdhaEliVXNZZHo5?=
 =?utf-8?B?bk1OclF1cm8rQXp2ZjhxOS84U01NczdZTHIrbi9tTmZWUmZuVmx6K2ZmVC8x?=
 =?utf-8?B?QVBwOUpyQmNKajIwZWFvZENGR00veEpuNWRBOVNUSWNXV1dMNkhRaUVIRkto?=
 =?utf-8?B?Kzd5WEFrU25JMTRmZ2U5Y1ROSjRuZ2swSkNUbEhUcS9YeWpaWWdQWnVYNDdZ?=
 =?utf-8?B?V25BSjZPWG9xWC9KSUVkTHpoUmFvNElaMzBGWnZSaldheExkTzZaSy9mVHV2?=
 =?utf-8?B?ZE5PZGtpaEZmK1N6eTNQMTNGdENjREI4ODU5bjFBejBrVG5iR0JZb3pPbWg4?=
 =?utf-8?B?RUh1dWlMQk1aT1QzRGR6RXdGUXBVZ1ZGWmZGWmlzTHVaN2M5aXNVOGlrS2tQ?=
 =?utf-8?B?Q2oyNWdLYXg1d3VTQ29IUUJmcitUYjVoWW9tQmlHOGRGTXd4K2FjemlzWENz?=
 =?utf-8?B?TmNyN0VjTnZ5OFpldlloTGV1TFJjQ3JyWEx4VmlqeFQ5bXZOaDgwMWszWEUx?=
 =?utf-8?B?WWtNYWtJWVpTWjZlYmRpV0dkdy9xcS92SklLQVpqZ2R0MHNhMk03bzZkZlNx?=
 =?utf-8?B?djJWcnNHNCtEazlmQVlYQ3haRnE0akh3V0JVRDNSS3lnOUJZbmNKdE9BM3Bl?=
 =?utf-8?B?alRHb1FJWTdIWHpkTUpJdlVOajJOVDdBUVVqYlJVTlR1U3Y4Q3daZHlGc00w?=
 =?utf-8?B?MC9CSlNweTRyRGE1OUkyVUZZVVlUVURwNmF5UUNUczZYMjY0SnB3SEp2NGpq?=
 =?utf-8?B?OFhkZTRNckJuTGJVUFhNUXA1cEdOMm1xanJtUHl2ZFFFUTRDTlBYUE5Rb211?=
 =?utf-8?B?SDFPZmlycU5NVlZKUEpRanRuQ3ZWSldvemk0K3ZzbFRnK3FnWmZyTzNsUVk5?=
 =?utf-8?B?bXFjM25ZVXFVRTV4ZGVyQlJ1SlRvUUE1NmZpN3M2a0t1U2lSaDJZWmlidUps?=
 =?utf-8?B?ZzVWNFRQY2RXV3JlR201d0NyK1NzTmkrLzdhTDhvUEx0cldrRlZZK3N0a1JM?=
 =?utf-8?B?cXd2Qmt6S2tvSEpEb1NDbm9teDZmRWVRWFpmbHZWaHpOUFcrb2lDRjVXZmV6?=
 =?utf-8?B?amR5UE9aU3ZtS1Bnc3VqSXhYbUtPMk1nQkhNRXBhb3RQQm5qUzQxWnY4R1c3?=
 =?utf-8?B?RzRKc0xmWWRFMTB4K2poTk5ubWgwb0FoNDRpcnh5T080cUdlbFhTNzRjSzNG?=
 =?utf-8?B?aGpHMnRRd1oxZlBXYXYzQjJaOGVwbE9JNkdDL2xiaENrdkhjRitKZW1GRERX?=
 =?utf-8?B?UEo2NUNkV09vQUR2VVFpN1RGTEhwNVdoVm1RZnIzZzlUa1gzMkRveFR4KzNI?=
 =?utf-8?B?ZEloSzZ1aGxLUGdydWY4WU9WS3Ywck45YzRqdXlIUTFiWWU1d3VpSDM4Ukxq?=
 =?utf-8?B?b3plVFZldWlmQlVNaU1WSlFNTldWc3o1OE9wbVZUeUNaZVhXaVJvVXV4b3Q5?=
 =?utf-8?B?ZnhUbzNOR2xuWS84bFpCaE1iVGJxY1FDanFtcmgzZmdiVXVML1ZKcUs3Qy9B?=
 =?utf-8?B?b2J0SW9Dc2ZOUXN3Skx0dmF0Y3RDc2xOZnh3dGhudUR4R3BLUXpGeDNqZW1r?=
 =?utf-8?B?K2ZaTThsTlBIL1VwMThDYi9vK2ZmTkZZcTkvdVUyZTduR3N6bjJ2UXNpVUhx?=
 =?utf-8?B?M3djWmFuOG9mb0xtMlJYSXN0K0xjUDBhUnUwZnBTOHVqYktRdU1tY2RIQjV4?=
 =?utf-8?B?YmxGZjgvcXpMVGN2Ump2TGhSZ0NxeGhMbHFUR0FGRFZuSS93VVg1QUJ4ZnBI?=
 =?utf-8?B?djR6R1FsQWkreWxsb08xemNXeklvS3ZTUXVDWDVjdWtGL0x0NHNoNVFQbmor?=
 =?utf-8?B?eitEQjg5aXlXVmdISXVFQ1h3RUZjeFJnZGVUL3dUNVVSNzlBSUkxdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf3678c5-fe41-43a6-c03d-08de49bbf37e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 05:01:13.1171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yjZI96XOHGAdDJB045elUUsBGY53uHHnUB5i7Z+vCQ1F2vicBQSU9IgX7tPazoz4H8R31kNpKJYsKZKmpW3Wxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7728



On 29/12/25 11:48, Herbert Xu wrote:
> Use NULL instead of 0 as the null pointer.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
> index ea29cd5d0ff9..5fd5a8fc60ed 100644
> --- a/drivers/crypto/ccp/sev-dev-tsm.c
> +++ b/drivers/crypto/ccp/sev-dev-tsm.c
> @@ -241,7 +241,7 @@ static struct pci_tsm *dsm_probe(struct tsm_dev *tsmdev, struct pci_dev *pdev)
>   
>   	if (is_pci_tsm_pf0(pdev))
>   		return tio_pf0_probe(pdev, sev);
> -	return 0;
> +	return NULL;

ouch. The code mutated too much, thanks for pointing out.

Reviewed-by: Alexey Kardashevskiy <aik@amd.com>

>   }
>   
>   static void dsm_remove(struct pci_tsm *tsm)

-- 
Alexey

