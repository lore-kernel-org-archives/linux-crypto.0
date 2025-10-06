Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306322874F2;
	Mon,  6 Oct 2025 16:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759768363; cv=fail; b=o05/KVjLxBVfIpJt1zVzZr5Ea47ozfCqA4RxTUb7xqFTm1etFqdnzD/1sLXZbgAIBmGa1wFnPLTiIp0Uf4+fO/dZlrv/9ENsstq/CM+p4iYduE1O2Ml/d3CiSYdYLibPGfyN1LEZJNl0dDaf2NAoEmVRw23RenKL1Yla75rxi0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759768363; c=relaxed/simple;
	bh=jGO9Mly+qNxHfAmdX2itSXsNjQ1DYHjypp41lz2eNYs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TOlIQm4BtFSJ3q1WgX5TVKg2c2Uu/afedKskvosgbTfUuYmAq6VZNDUWnj/f1Ohw5zGyWsK/499FwculwQK4sgp6qKINtxCztV3VnJFg04fNlMtIUzFh52lWnow4gsm7M0tbJFwrcQz7LimA+M3rDI6hx6cx+5puP5EzoGgl3BM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z13sGx5C; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mBaqyCKh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z13sGx5C";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mBaqyCKh"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 596GQNGn002826;
	Mon, 6 Oct 2025 16:32:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CuqJc16Cj+/2EKvItpq0RssbeYrnkgkqalj6s9VdKNM=; b=
	Z13sGx5CN4H1IN5QnBpbvR2brhAd609Dnrs7EDROkfOcBpW9ynrf9cuqtUSvK9Jh
	PFRJztJuGHI3ya8FHPI/y/fkstbaIMgDpV1lgGKe0cQUDmLIG6NLvOpnfNvIJqS4
	yWJcxHo0yJAsoFDKuaThyoy4gT7pbYdzYh/ZROgBdoQANKJWzVwI3uBPfIa4Eesw
	GocZA+JCY13tIfsg9k7izAzuyJPsDHcFzbCjGbfpcs3V82MU6g7hWSpBrLF/PaRM
	596UdpK4cl5NQwbKcZeihTrmX6Q2ZbY3y1qt9Kuc5mm1L0329uhu4Q9w2n1Qg7fJ
	CsJV24xD+kdSvXyKYuXW1Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49mh1u01st-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Oct 2025 16:32:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 596FbC72028667;
	Mon, 6 Oct 2025 16:32:27 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010067.outbound.protection.outlook.com [40.93.198.67])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49jt172uu2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Oct 2025 16:32:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y9AGd6mYyHexUEx+l4xBTwiNNlEXhfuYiVSNi2q1sGgcJZJJhbBkgVGwyAnFt5dm/nj2ZuumC/oYrqtxqRbMh9DKO/0/0tmEk8fwRR3D6dZIanQZwi0OCpjF7E0MjV0Dt1XqQKxjvzsdeL9yWcLwIKnHKP7evpm7fr58i1/nqvy+0ySakxs+r9IafxQ96vVthoTpZjO4LFTkYJTUK04PEztSfYeXYs/34eQDRsKcNoD2wABZUHA9RdSE1iozVUw7U4rrOSCBYqVH1EaPVxhNLoFBmRiefzz6USz9si3xljv8Q5CSujXbxXm8MLrhteXSdoE1Jz/zUN42gc/mvaL/Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CuqJc16Cj+/2EKvItpq0RssbeYrnkgkqalj6s9VdKNM=;
 b=v9jls92bq/V+PvThooPLCTsbLg9xJjEB32hSftTDZoJn2M1+Aar88PORyyJXyAVVvdx+WPTsqeYQN/TDgBOcH5xVD5x2jh+APY+yaya7KYJFD8j63lPfTpNtJEcVJfP4sYXbOnN2CMCjb0oKRsE9LcFyqC2+E+68/8xaSV3QegHi4S/QSYeGc5HXdlal8ZLP433sRyCoX+50cjnts0+hFIFVJilYSkUHbhKGZKRr9p1BwjbkWd1YI/5xgYd2PJORwuFrPrvZB0VmwRL9l8L0ThkhhIjcBa+C5BPsQHvXvBTXivpViAQ2Kc8/dauYBtqAOO9cPcPCi5dcVGSqlBI6Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuqJc16Cj+/2EKvItpq0RssbeYrnkgkqalj6s9VdKNM=;
 b=mBaqyCKhh0VZuZGs8hWpYddOtDhiXZ54nk7DA31rVK1y5LT0zzVXCqccwq0+lRE7M23/bP6HWVBSMQON305oYB/Rnze3JKGncNfRi8JCmAuaCmzKnSfBr3uoqKjNDAixEIY04UX+5Qgb8DZXe0KWCtdpczQTHUxYLnNebnvXsmA=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by SJ5PPF7F7BBD994.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7ae) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Mon, 6 Oct
 2025 16:32:21 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%4]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 16:32:21 +0000
Message-ID: <3b1ff093-2578-4186-969a-3c70530e57b7@oracle.com>
Date: Mon, 6 Oct 2025 18:32:16 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: 6.17 crashes in ipv6 code when booted fips=1 [was: [GIT PULL]
 Crypto Update for 6.17]
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Jiri Slaby <jirislaby@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, "nstange@suse.de" <nstange@suse.de>,
        "Wang, Jay" <wanjay@amazon.com>
References: <aIirh_7k4SWzE-bF@gondor.apana.org.au>
 <05b7ef65-37bb-4391-9ec9-c382d51bae4d@kernel.org>
 <aN5GO1YLO_yXbMNH@gondor.apana.org.au>
 <562363e8-ea90-4458-9f97-1b1cb433c863@kernel.org>
 <8bb5a196-7d55-4bdb-b890-709f918abad0@kernel.org>
 <1a71398e-637f-4aa5-b4c6-0d3502a62a0c@kernel.org>
 <f31dbb22-0add-481c-aee0-e337a7731f8e@oracle.com> <20251002172310.GC1697@sol>
 <2981dc1d-287f-44fc-9f6f-a9357fb62dbf@oracle.com>
 <CAHk-=wjcXn+uPu8h554YFyZqfkoF=K4+tFFtXHsWNzqftShdbQ@mail.gmail.com>
Content-Language: en-US
From: Vegard Nossum <vegard.nossum@oracle.com>
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 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 8A==
In-Reply-To: <CAHk-=wjcXn+uPu8h554YFyZqfkoF=K4+tFFtXHsWNzqftShdbQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0110.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2cf::16) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|SJ5PPF7F7BBD994:EE_
X-MS-Office365-Filtering-Correlation-Id: 06ade020-5c88-4c07-f2fd-08de04f5ec10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d0E1ajRPcHQ4WjFMcnJYcXYvSTlwakNtSnVlUkx2WkExWVR4alJsL1l5NWNK?=
 =?utf-8?B?ZWtMVS9MbmxIeUNsMy9pcldqdkhSaWVDVGFtWnZPRk5zbGVGcXNOaGpkenZS?=
 =?utf-8?B?dVlDeFE4NjBSZ1lpSEFqZVdBS0pmeTlZZlNvQktSeGs2SmUrcVhPRXZFRXpW?=
 =?utf-8?B?cThmcnZTZFJEVkV4M3JMN3ZLQ2pDbDI2L0h1SS9qMk40TEdoZjEvVThTRzB1?=
 =?utf-8?B?SUpObXFCWHcwT0dRNzJWbmFYMEhuOS9vZVVSZk1TVTdVWkxJUDJyelZkQXVz?=
 =?utf-8?B?cWtxVGNSUmw4UVBuS3pCcFJhRytndW4zM0E0K1NjeE9lSmVGMGtmeHVpNmVL?=
 =?utf-8?B?bGFna2ROOE51bWNmbHJQN3k1cE40V3FMMW05MlQwNDB0ZUhIc3VFakRUVnlI?=
 =?utf-8?B?ODk4dTY3ME1wWnF1a1llbzVyZlZ4dVFCaFlrb1lXZ0wwbE9pZkNIZW9hMHZp?=
 =?utf-8?B?RXl1cGY3MUt1RzlwMS9HOFRXbEwyZEFQL01QaHBSVERGVHNNUnRqcGs2cVJJ?=
 =?utf-8?B?MkJxbW5NQ0krSC9DRExNSXJVTVBhNFlZdEdzSmNua1pZTy9XR0JPUmVHNWNZ?=
 =?utf-8?B?Q0I5WnhGa1gyNERHdU9EbTJPUkVoS2VCUjFJcWwwMDdBSThCazltaS9VTDFi?=
 =?utf-8?B?TGdCd21WVmMyb1l4M2FtVDlVSXJscGF6cnBnbWFValNZaTlNeDYrR1FVN1Bp?=
 =?utf-8?B?WVlLbFc4OHhlb1VGVzltRTZOcGcrbGR6OVZqV3AzdHBuaGtkM3FyQkRGTXhk?=
 =?utf-8?B?R1NacVJsY1FvUXdxanBmaVlWSjhkaENabHR5QVBJcXEyQTM5SDlQRUlRZnho?=
 =?utf-8?B?aVlRMy9DMlpleThGcnA0emRqa1R2ZnVwVHFhSWdoVGFQZ2dVTTZ2UEE3UVdX?=
 =?utf-8?B?aTFNOWRGSm1OcU5iWEpxT09YS09rZGxiTjZucmlOWjZadjhxU2hiYmxHKzc5?=
 =?utf-8?B?VWZ6M21FRGRyZWp2Uy9oWm9BKzhLdnM5WFlYMWJkLy9oVGdTSEptLzZLa2Y1?=
 =?utf-8?B?VmV0WHpvaitJajhIMFBRUnFzRGxBNmhSKzJCdmJScGV3QUkybVVHWmF2MUdZ?=
 =?utf-8?B?c2lWVTBlYUJZdkJSSy9QdTFpYjBYRGFVaitrVkRtOTZHWmJOQkFSOWlELzhV?=
 =?utf-8?B?RHR2ZXFnUm9HeTUxSUxzZzNKR05ncndOMnROSXJoRzZ2RDBHdGIyOVl2U3do?=
 =?utf-8?B?L2lrL1RGNlVWZHY2RG9SUTd2MzUwMGUrUWdaUjd2alpyZGNiUTN1S096Ymcv?=
 =?utf-8?B?cmNFY3hJY1pIY1RPbFVsS2FmTCsxTkUyWDVrRTZnUTJZdjlyMnVHUGlGNkhz?=
 =?utf-8?B?N215Y2M1alc4MVk1ZU9jbmViSitOb25kODc5M0Nuc1B5N3Y2eXRxTXowWUhM?=
 =?utf-8?B?MElIN215NnJ1eXNzbVVDUmRqQWNkSFpOWFM1eVdCMnJZTU9GRzJ6N2dRc3Jl?=
 =?utf-8?B?QS9vMzdxdm1Wek9BN09tQzhIem41UUx5V0VIUkU2dHFjaTdWMklLRkNIVy8r?=
 =?utf-8?B?N0xTSzg4Qmt4Yms3aTlCUG9MOFc3WFpabnYyREJyU2NicGhWcDVNQ2xseFpB?=
 =?utf-8?B?Qjc5Z0g3eUxJRVNmejBOYXh6bmxZcExwYzh3cU1COGl3TFFOSExLN0ROR0h1?=
 =?utf-8?B?VmFnNEZDZnYyT216MkFJYUVXVnJ2WlNMQzJ0eDJqbUl6b3IrSWpCYmpwSStC?=
 =?utf-8?B?SmlhNWVka0FqKzFXLzM2a3IyQi9EZnF1MFJHODloVnorNGRBcGVFalRsVWtZ?=
 =?utf-8?B?VE5RVHdRd2xqdkZMdHRON1BhQmlpMUdtTlI3cDJrdmVaa09YalNmdUNocUhI?=
 =?utf-8?B?blNXK2NLVUFWbGVYRUpwL3M2M20wVUYxV0RqYWxsTE84ZytpYUdsN2RhMHdx?=
 =?utf-8?B?YlBCKzVXdSt6OUozTUNWTkxZeVUycHk4Q0dkT0FuZGMxV2doajllbTA0Y3h3?=
 =?utf-8?Q?cL2kmdnoC35AsFacDLrM39vxFvWSCJ1b?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzNTV2FnSGNPMG1KV2xsNEc4ZEVZR0NZL0NKSTl4aFAwVVJOM2dFbXRuYkRY?=
 =?utf-8?B?N3YxODIyOXlKT2xsS0ZtRTIrVGFLeGJCellQT3hQdkNOTzAvUmNSTGxEQzNr?=
 =?utf-8?B?UVpKWDJNTjd3Nk1wT1RsQ3RjbjQ3SWtZQzBCUlVHc2QrMjdJOGovRTVkOHpq?=
 =?utf-8?B?RUdhUFFIVGNQeWswVmtHQjJid3gvamhOWlpJeVlRMzFPQzZ5LzJiQUY2SEVa?=
 =?utf-8?B?eUFSMmI2YjhOVmxacy9NR1RmUEdYR05LYWV4cWpaRG5JeXFXSmJQQ0YyYjRP?=
 =?utf-8?B?Rm42STM3dWdMRzJXaWhrRWQ2NG9jQU1YQXFZUHh1aVlCZ0MwVjkyVEpVbjVy?=
 =?utf-8?B?emZ6T3JjbjlUZ3o4OEhNY1oxam8xWTdNUTlzUjdFVmhkMGtwNEJqSnRzcUlt?=
 =?utf-8?B?Mk5pWmlNVURGM1MwbGNHRkF1K1ljZ1A2WjVxY0tjd0NrTVBPR2VSSGFJa3Zj?=
 =?utf-8?B?LzlWbEtCNW8wbGRIano2TEdQUFdLWUVBendxVCt4Z3NIaTRHelBmVmN2VVdL?=
 =?utf-8?B?QXgxai9ZaTJZRldqNkxqUkttSFZNVFQ1R3ZFaHFoNWhKdjREWjRsM2daVnNk?=
 =?utf-8?B?S0ZCKzFUTitXSjV3QkRpL2FPN2tBN3lCSGZkSjhPbmUyM3RXQTRKcmtIOFM2?=
 =?utf-8?B?eHFJbGxVOTdFcEdPQnBEdTFNRWF1UVVlOHhFcDd6c2ZGQnJ4S3MzdlVOQXFZ?=
 =?utf-8?B?ZDVwTSs0eGFLb0s2MVZKQi90U0s1VnpIY05MS1lVcTU3TTJEL0RhS0c4Z2NN?=
 =?utf-8?B?Ui8rc2dqRTNEZGxGcU91d2dEZkgzb3dEMUdnZnNSZlBtLzl5MUhjVGlrcVFD?=
 =?utf-8?B?Z3hMZ2lWekNtQU96alFadzhRWU9UQjdRdkJvTjZzQ2FNbU1ZbGlTc1g0Q1N3?=
 =?utf-8?B?MkFuZWhpYXJtMTlNRFFNaFgyOWx3aW8zNVg2ZGxGMnlVdTRuK0ZaLzRuV2Ez?=
 =?utf-8?B?YnNYWUJZbHZJdW9pN1l5ZXJVYklqTk9YUFRCYmhTM2dXZTFvTkFKcCtvdFRQ?=
 =?utf-8?B?MmdxdnZlQnV5U08rdnFnS21EQjJYWFkwbjltR0VCZ2VDVFBKaWNuT1B4K044?=
 =?utf-8?B?WjRjdlFjc2tGalUwbjV2YXo3Tkd1RU03OWxVZ1FXamxkbExadXVKbTgvSjdr?=
 =?utf-8?B?Y3o2YXowYjRGcktpTzdEaHpUZzY2Nm5LUEVGU0d2MUk3ZXh6VnBQb2VDZ0dV?=
 =?utf-8?B?VUlSbDF5TE9URnVvVy9mT0ZxcmxHdStsSDg4czBsbW5OQXI4VklsOU4rWlhx?=
 =?utf-8?B?amE4bUl2M1ZiclRKN3hJUlNobzVQMUVZOWNXTUlkdDRMbW9VaEJQTS9tWldS?=
 =?utf-8?B?UmJ6bWVqTkxteHB2QnlJMzZnTEVwTXdVWk8rQk5KNWl2ZFFzbXh2dHJZano2?=
 =?utf-8?B?TWdlbjZQQUJuMm96dFdaMzNVbDRkVVQ5aW83d0Z4enZKTnJza05POU94elFJ?=
 =?utf-8?B?TXZMUnFhdlFZOGhUV3IzUWRoM3Z2dVZKb0xyQnJVRXFDYUxuVXpjS2Y0WmQy?=
 =?utf-8?B?Qk5rTkVMbFdVcjVyUXB4aHNYWGhxWHRZMGRKaFVRZENUS1p6SndBeFNJeXV1?=
 =?utf-8?B?NG84MGdTUDJrMHRSa2syNmtsbHZ4bmNTY3dPRlZEMHc0dVlXTlNwRnN1djlC?=
 =?utf-8?B?NGxUSkR3WFYzM1gxc3JrYXZXenByQ0l6NGFSZjA3UnpvbERQRXA4Qk4rTzVF?=
 =?utf-8?B?UVorLzE2bEdSTXM2Y0oyeEZEWUU5R1d0V05RMmFsMUtLME1MN2dIRWtjVjBY?=
 =?utf-8?B?NmRycUhkMERvUlNTdFZUcktoYWVNWkdCZVZVUDlvKy9KT0x3VVIwcTN1dVQ4?=
 =?utf-8?B?ZitXekdyM09KbXNhcHZoOHd4ckNySkg0Rm5ubVllUUczZWU3V3FUUUVlWVZm?=
 =?utf-8?B?VG9LclBwNS9uNHdvTVNibEJVWUJuRVZJaW96dWhWY1dWS2Jsb2tKQit4U1JL?=
 =?utf-8?B?SVUrTGFTWmlZbUk3cjZOR1NlK1lVVjFGZVk2SHdSaVl4bm8yeVRNQmI5SFI1?=
 =?utf-8?B?anVMMVhlZnVYZWUvYXVxMHZxWGxnemZ5ZFdEM0FTRU9hc1B2b09QZXFQT2kw?=
 =?utf-8?B?M3V0OElMdmRkYmdKS0gweUtzVGs1dkt0YmE2OCtrYTg1RHlDUkFMaHZCK29m?=
 =?utf-8?B?TnFxVmVNMlg5eE9pMnhWL1N4QnN4VlBucHJEMTFJTnplYWF5bktrbHNMZHlo?=
 =?utf-8?B?a2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	02QXLn3JiI6ic3xk4Mku9rUjwdO8k44uZXuD3Kt/nLpBRTwm31jUEBJnsSie66T7047G+q3UiOedGA31hdUKDZWCC+vMz5ReHwBSb5DfmjGSarEGIEb3/ElnE7OHbsn8D4sCRPW1gr28rDEz8iDJmfiVq8RVlqLszfF1ywAvQfWj+i30MiKqR8MjfNt9y7Sh2ZhOQFk3cdF7QfBrGbqurbiH/Fcu5lbSX74/6d2lPKF4OEHy19m58pWSz+aNiEco87Bx5Cc7zHv05g6SwvGXVI0YrZr52Lr9dT1Y9OUno+wblTMrU4YfCrctQAKKfME0XnsVCbvj/iE8hWzac6wtr8+6LMonp4gk+zbSSTmfLW6gadRhhHZdmPBLSRrKM+EuEixMBAcFHOR4qdEPD28JhdgC7mYBXmcGgdYWtgnqt2FrYjYWdYya8NzP95z1PAHyUmKy4k+JuNlgiMDpyWiflnpI/qy3lT5OYQIgHuGKW9ZLD1tWKngojonMH+oszlNWLsGTmU8xYmlW/ewITLUs3voKdlX83xanjLH40t+fiHnkyNSWaneVfh+Xj4XHLrqt0mdnO8sE1JnfHDk8w7nhIr86Q4mSFNWTjpgW7rlCYKA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06ade020-5c88-4c07-f2fd-08de04f5ec10
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 16:32:21.0500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7+R7TEWF1N+UaZjOV+fZ339wMq1BVEEuwAzCfgqv0I56158ux80KuMIgltnK+7sUskq5r3C1BT2xxKrf/w7JeIYKX/2o8K2bvMxnC0nvrmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF7F7BBD994
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_05,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510060130
X-Proofpoint-GUID: AxxPeeNw-okqkGirTUlFefjJ8D6xFrwy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA2MDEyNyBTYWx0ZWRfXzcuFhVRC6GWo
 axF0DtLLap6xJnZS7oc1EHcAlTCzIR5WvwB3EpM/rhB7L7OAlbptiXYnooplcRo/ZdvoQcfdtNC
 ZeO9Lou3GgqOKhW8C97vS//18hndhLXfZAPlb7+yLdu0D1KEGanWM99ZGQ/1zlvDfuO86n2W9kC
 xRlfhYUdsTFbRFTG24hhkeK0SYzAQ36fnixJIStcTxJeCQ2trtNfjwXLDckziJWTQaOfe+kI8Gu
 A2NiS0H1R4sFVgpdGh0u+1TiHXmaSsnfhP5rQZahLNhCExXZ7px1F6LkHzQsvXj7jsvVeLMM7nJ
 SwjB7d1epPwisvJ26mRm4e5gvok1mNQQEa//zJaqVMS6/8CquFb6Si7e4+E74S18nThCXDn05Af
 sKawmG5ZwWHoAkUaoDIel6/wmEOHnQWxUm3V2N8JAMFplLkYu3Q=
X-Proofpoint-ORIG-GUID: AxxPeeNw-okqkGirTUlFefjJ8D6xFrwy
X-Authority-Analysis: v=2.4 cv=WuQm8Nfv c=1 sm=1 tr=0 ts=68e3ef1d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=boi6gIZG_qWuzYg_CM0A:9
 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10 cc=ntf awl=host:13625


On 06/10/2025 18:19, Linus Torvalds wrote:
> On Mon, 6 Oct 2025 at 04:53, Vegard Nossum <vegard.nossum@oracle.com> wrote:
>>
>> I'm pretty sure the use of SHA-1/HMAC inside IPv6 segment routing counts
>> as a "security function" (as it is used for message authentication) and
>> thus should be subject to FIPS requirements when booting with fips=1.
> 
> I think the other way of writing that is "fips=1 is and will remain
> irrelevant in the real world as long as it's that black-and-white".

Okay, so I get that we don't like fips=1 around here (I'm not a
particularly big fan myself), but what's with the snark? fips=1 exists
in mainline and obviously has users. I'm just trying to make sure it
remains useful and usable. Otherwise we're going back to the
jitterentropy situation where every distro has their own downstream
patches to pass FIPS certification. Is that what you want?

Confused,


Vegard
