Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011017.outbound.protection.outlook.com [52.101.62.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC38A36E47F;
	Mon, 19 Jan 2026 14:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768831843; cv=fail; b=SGWpg27P9O4NUNRGvP8unZEhWh0a4CfFkAGlyucGmBcySZMmW7kX5faqjVA/0HNsLeXLm2TFsuMhHQTSStKHAY676q2ITopXQqlH15QkkSGkdpeUrw4b2LyUjrMrYvKkNzir7zdYpe3Srpa43HqfCnLe8CzdPLXVktMpn3zcUIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768831843; c=relaxed/simple;
	bh=ic825M2sdSAFIuyYgTFXtznWtCHZ7EfbpAlTQikpiBU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JOWqwOUJSM5YlaR7sPoruyl1PIJvZyp/ANdaucVJDjjmp/G1mY3G6q4K9TiiyGk8RjV9cWC4nlwP85ipvqanQ2CFiZxtaNoT6L7sWKSJM1cR8QEcJAlpIXHzoSHBFQ6hcRyZhbqE3mpiEeYyaVX+OjeTO68CcK3csix7iydrSF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TzjNm+zU; arc=fail smtp.client-ip=52.101.62.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TzjNm+zU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DWWkIz9esVUVFHMbI3UtVtNtb5/8Yct/fm8jBlgzoil4aVxVnbOy/1PrNL3P4aYOUBI5u7Hmq9m9CI5o/nXkqYRQeF83W6YenT9n3yfFTXTqmH+BrO7AzBk0Jxo13tev5qD98NfWL1TJj6fY/LZS5XdnYgEGjekU+faEESKLFVf9H32TCljTWly23UGrSlMF3vo0S+5RAvXMLMyj9rDbJOyzNQW8V6+UXxIpA2dwNWYO0ikZQNVipjEPsUy4EN32fHmwLAougm6cQXblqco06cz2GtFKqD2XgeMij2j+Oi1EFc6VCIegP7d0yt3pzcM6DvHC/yT6Xmnut6MrNsethw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daBfrgcyo7/PK3IdsXMl4S1MynDAMkXNB22iCu8XUbk=;
 b=OKOUpT60vHSdrkJ/FE7xXTuuTW4/4Xg67pCny53rgmH8LMKF2cjbbzCkv1c5GLB+wjecxyDMyI/EuL+srN8spGKM40X3Pgt2vam0kiUCut0Bt3Aa21SUzrgk42ER0a3Gz32iHJPael/fR4n7uge0pve8xuXprQ2FcpZ6x8XI9/2izEFg5A2l2MuJ1E4Asa28xc+NX0tGdNYWakkCEySvH2y6kvLBIhlz3/lBiwuE4u5qPQNgxzksEracj4X4JjryVMUyxt+wbAp09xFQlgZ2p2dr80NYsBhsXj8omR7pUh/rfAYbzGlMzgEAC3jYrdLMNZqRHv90Tq3TroIePu8t7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daBfrgcyo7/PK3IdsXMl4S1MynDAMkXNB22iCu8XUbk=;
 b=TzjNm+zU4pYmVahj1c3NhW9CLC0eG67ldZOLilJWBfGZaEF3NfQjW0qX7lSYncf+zlyzs+8ZvvBhdOD6nXwYd/92NkWDe+PeVtTN/nPj2u+zTB7LBna2F8s8hKbzZDmgpXac+ZtkvcZAtpZfvZeuCbbZc1ZI3M9i7nhReiAYb9M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB7434.namprd12.prod.outlook.com (2603:10b6:930:52::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Mon, 19 Jan
 2026 14:10:36 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.9520.011; Mon, 19 Jan 2026
 14:10:36 +0000
Message-ID: <b3e355f7-b242-4fda-ac13-f8cb90225fb5@amd.com>
Date: Mon, 19 Jan 2026 08:10:34 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/5] crypto: ccp - Declare PSP dead if
 PSP_CMD_TEE_RING_INIT fails
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc: John Allen <john.allen@amd.com>, "David S . Miller"
 <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
 <linux-crypto@vger.kernel.org>,
 "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>,
 Lars Francke <lars.francke@gmail.com>, Yijun Shen <Yijun.Shen@dell.com>,
 Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
References: <20260116041132.153674-1-superm1@kernel.org>
 <20260116041132.153674-3-superm1@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260116041132.153674-3-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0161.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::9) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB7434:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e402a48-ff14-4377-6d28-08de57648488
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3dMZlJvMEx0dy9GT24rZXA2MjU3MjZzeUQrd2JCU2NjaGdnOU9FSWRKU25M?=
 =?utf-8?B?N2J1YWpLUUpvMGtHcGpCbTdRSkNsWnFSMU9NUXZjSG5RK0RhYXNhTFpxK2Vz?=
 =?utf-8?B?UjZRTnl3eW5hVHlNVSt0VjJoSUNmVnVDNk5NTmN3bnd0ZHpKMlEzcWRRREVp?=
 =?utf-8?B?dFFVeEdBdVJEbjc1QlpLVWJLaUhkOU9VTnBpRytCMklGdU1Bd2FXaXRjRHlN?=
 =?utf-8?B?TVRhTDhxUS83bW9yS01vMlpUSkdVZUo4akpsUW8xanRtbUVQMUd0ZXR6MlZ3?=
 =?utf-8?B?dm1HMWJxR0tFVVI4T0VwL1RLdTZSSmVQOW40K25kZHZiNi9IaEJ1QlViRUVG?=
 =?utf-8?B?eFZqdUpMRjhnMW9GSzNsNkw3Z2dUcTV6OFJvTnVQUEdLbHF3Q01KOFJpMXRr?=
 =?utf-8?B?SzdJanNJM0krR2FmdDB2bkJLK0toUzIwRG5ZWVdqbWdhQXcrUGV1eEMyUHpN?=
 =?utf-8?B?RGlTYnZ4amFzTU5DM3VOdmh4TUNXRGphaUt3T3Z0TVdJWGFyT1RuTXprMXN6?=
 =?utf-8?B?M0o0bDdFT240bEk0bCtGSjVObkFqcE13L0dhTkNnV05paE1OYWVjdFplY3JP?=
 =?utf-8?B?emVEOHNKVWhNbTdTd2hZODg4bko3bkMrWTRHYThBazZOWTl4U0Y4ci8zbjdl?=
 =?utf-8?B?UGNKcWVTQzZaTDJQTXhKSVRLMURRVkVkRlRPUHhhUytFQkhCRUVhZnVnNnNl?=
 =?utf-8?B?bG1kV29MeElnQjlLaERtRlQ5S0h3a3ZqZEZhekZtemRIZUREdHZMVzBhYlpR?=
 =?utf-8?B?SFhZMkhHdk5DK0tRSHBaZnFaa0ZHRzRhRkQwTVZXelJiSjJZRUdDV3VSaDN6?=
 =?utf-8?B?OVZrYUtHNFF6bmR3cGtOam1wSUxyUDRKZU43SXNLYnVOeERHN2VIMWpqakJJ?=
 =?utf-8?B?cTdpQTk0Ykcranp0UFM2RDBEVndhRlBLTkhiN0tFcXFMbklTVi9reTN2Mm11?=
 =?utf-8?B?TVpZUlR5WFA3SGdUZkJVemFzVDBaUkVEUWZOd0NtdWduYWhPMzJwM0JhS2Yx?=
 =?utf-8?B?WE1WaFV4eWhnUGpOYWFkdWJ5RHVvenI5NzFiUjM5dThDWjM0MGFhVHBwZVdD?=
 =?utf-8?B?SFcwTGdOKy9CMzNMMlh6K0ZDRnp1U2NMdVpWR3FkMjBha1RLbzkrZVJWbW9h?=
 =?utf-8?B?QlVCNWJ5VCtrZXhEQ3d6OXd2Z3R5d0l4UUFDTHJNTXNnTm5IZXIrOURva3RO?=
 =?utf-8?B?SldablFDS0ZxTHVFSHBweGFCcFZtMGZDQ3VVa3Z0U2FDTkkvU3VJYzZmUnRZ?=
 =?utf-8?B?dHdmQmYya2VtTmdtN0VDa3BRc2tmMVNaTUxuQVNCU3Y3MjB0YkV3Z0FORzYz?=
 =?utf-8?B?MHdiUENRYVJnTU5EMHRCYVM2Q0NiVG8vN2NNZ1RMWll0T3RoSUU3SnlBYktj?=
 =?utf-8?B?MGx2dFc1TXZKMk9GYW1mZnJnbS9HQ1Jvc0dhQ2JiMjJhZnJ4UlU4bGlGWVZE?=
 =?utf-8?B?Mnp4anhUeGJuam41YTlIaDMvVFRBTlc2bkpJdHoyRkZ5Y2lmdXJnT2NTMGZ2?=
 =?utf-8?B?M3BTWG5XSXM3Vzk3SnNIaW9TZWV1a1l6VmxXakpGMnZ4OUU0YjB3VGZyZ1lQ?=
 =?utf-8?B?ZWJPVTBBRGRXVVlmdE5PNkdKYTVpRVNBaXVjRlBYTGNJMVNsQVBYd3lXYThl?=
 =?utf-8?B?RHNIbkFTZk5HN09pak5uTmZ1TTRJdjhzS2dZcExtMTQ0MXg4MzdSenlqWS9M?=
 =?utf-8?B?MFJnYnh0QmFoU2FsbjluK3F4UEt6aFJTQk5TNXN4Zis3blgrWTUxUkxsS0Zq?=
 =?utf-8?B?ZVNvK3creGZWb1dwRVNwV0pzd3kvSkJHR1NxbXV1WjJENzY1R0xMbzF1cko2?=
 =?utf-8?B?dzVMQTU2dkplVmRqbFpGemRsSjU1c1lySGM5dFN6M24rWXdvMjZESmdWU1lB?=
 =?utf-8?B?K3MrcE03T3piNWREL2tablFheFE4OUdPa0wvcG5VRTk3ei91NU5KNGl3OEwz?=
 =?utf-8?B?YTlnRCtJQVlhdEJ6TjUvYnh3VGhSTFRMV2ZQZG83K2hvS1B1MURhdW9EeWZ1?=
 =?utf-8?B?NnQ3cVV4UWkvM2VDNnh5a21JaWs2b2M5SmVlSitqcE43dWZnZWlOa094VnIx?=
 =?utf-8?B?YXduUm9yVjNEQ0FnNnhpYWdhOUdPNnJNVEtjb1FoTEFnZW5kV2t6Y3J5aDNJ?=
 =?utf-8?Q?aTSo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0JWT01aTldSSTJBODN4K0FKckUway85MGZHNGRyTG82Z0tRblZCNDBrQ3dv?=
 =?utf-8?B?YW95OGIzVmdSTForcElqY2VlMDJJVlRDeGhieWc2dFZ3UXJBZWdMbmFlZjNR?=
 =?utf-8?B?MExBVEFTVWZqOWlrejQxczZLVm1hZXAzaFE0UU8rYy84ZTdlYnNQTjcxOVRH?=
 =?utf-8?B?RTNST3g1OHlsWkpRNEZvMnFMMC84bzdxYmhCWkMxdFJKU21UTDNHZ2FJK3RU?=
 =?utf-8?B?Y1Z6L3JicklQRExGcVdNZitEZ1piM3NnUDBXQ3NsZm5JUnlGOGZKdlpKck56?=
 =?utf-8?B?R0J6QlpMekgvbWlhVnY1K0YvQzliYUJFSy82SGUrUE5ZMTgvYS8vVVFobUpL?=
 =?utf-8?B?TDN0WUtoL3hqbFp3RGtGZHV1NjdmbWR3N0ZlYXdpZUlSanUrL3Q2YXh3RUd2?=
 =?utf-8?B?RFlZK3FoZlJxYkN2ZWE4YzRsOHFlY0tpTHNjZ28yVlY0RVFIai9yUVhlcTFv?=
 =?utf-8?B?K1pGekNZUlRIbmNQNEZwbCtzOXFhcUY5aVFZK3UvL01qZTIzRXBObVdPK0lO?=
 =?utf-8?B?SURqTW9hNU8ydktaM1JXSkpuWmFsc2xVTWxVTEZRczVhM1JmY2ZpZU56WXZB?=
 =?utf-8?B?cVdSKzBramx4NGZuaGVMVy8zVXYrcFVJWUpoTTk0R3l6eEtkMXpSUk1hcytQ?=
 =?utf-8?B?MGxHQjltMGRJS0JiVy9XZU1tQUhDdWRsemZpNVJGNUU5OFN0ZTB0RzJ2c1Fj?=
 =?utf-8?B?bG41RlNRbjhSYnlXSE5lOTl5QncyMVJSb2dhdHhncEdNQnN2M0g0NGRuWFgz?=
 =?utf-8?B?dUJNR3RQclNpLzJZRzlyNzRLdk1UNlVYUjhuS25MYTd0b1NyRlNTL1M3LzZH?=
 =?utf-8?B?MXNJaTNKK3dPZWlCZ0lKWGlYR09xUUZ4ZGI0WXduL0pyR0U3OG9qampWYnkx?=
 =?utf-8?B?NlV0Mk5qRmp6VnI1MXVYSllkTHUrNFIyZ090citLU3h0VTZjajVLeXBGQzFt?=
 =?utf-8?B?UzNLRDVYK3ptSExzSFk0V1BRSVBpcG11dXBOdG4rb2I3aHM2dmZZZXZhV09N?=
 =?utf-8?B?YTBqekl2NUxYc1ViNlVPMmpPNW1DMGZhVEtxT1YyZk1hVTErTFRTa1JYQWR5?=
 =?utf-8?B?VUN4SDNCd3AxU2ZBajRLekF1ajJPZElpd25vNk00eXNWTXZpN280ZWsyNWZS?=
 =?utf-8?B?em9CUTdyNnFGai9KTzdMOFZDNm80ZkdNRjk3UXhXbmlZM2Q3bjNwaHN2cnN4?=
 =?utf-8?B?aGRHa21jalpIbWxycGhJWXlHRzZwVzh3VTRzL1NSYzZuTm5tc3VTV2hiYXo3?=
 =?utf-8?B?OVlHNjlZcUR2U01DdGYyTWszcWQyVnZrcFVpM3VaUWErQW1uMGJDTUZ4Zlll?=
 =?utf-8?B?Z3JaMldEbGpFUWlyYkVvQ3BTY2grdElhR2RSTmw5Rm5QRTE1Mm00ZVdqYnBQ?=
 =?utf-8?B?R21OWWp6cW84NTQwd1d0NEttSjVLdzBESWVQUnBmQjIyOWV4NDdONDVybWVO?=
 =?utf-8?B?WWtWaEVsdGR2N04vUnFwc3FNTUZWVWQ4UTB4T1lMM0dFNG1uS0dqd3lsTUN0?=
 =?utf-8?B?dXBYN0lzakJDa0IzUTVoRklhSllLT2xLdkxiOURrMGpHcnN0K241dGtjNGRQ?=
 =?utf-8?B?MEpkYmgxWTR3T3VlYnlKTHhFWXkwbWxLZGpyMHNGQTYyclFDWm5jMUVsenNI?=
 =?utf-8?B?R3lzNDJqWnNuV2tQVFA3S0N2TG1GWmhzOUl5K1Y3MWxTM0psazZXRUVlbSto?=
 =?utf-8?B?dUVvREd3NmVtOTZpeEN4NnlSV1YyNlFiQUtLay9zYy9heFd0bHpUYmpMckNE?=
 =?utf-8?B?ZElZMHk3NWtjd3V5OXRQMHhPRlYyZFh6VWhIam9tTXRxQjlGNHBCVTNpU0Yx?=
 =?utf-8?B?eGg0dDBqZUNJcndSc0V3S2VJVVNlNU9ULzV6ekdvRVlZNjdmM3hheWtTRDhn?=
 =?utf-8?B?ek96T3RIb0ZWMEx5TEdJWjI1Qk9hVVNOeU1LS0g0cGZma3RJU3BHTVo0RE9B?=
 =?utf-8?B?dTJkVlRicWQ4T3ZSeVl2bUZ6Znc1VkdZUE5kUGV0L3g0L0Y4KytEVncraGxx?=
 =?utf-8?B?Sy8vRHFmOWw1akt6N0ZLMlpTMmQ0ZlZsVlhlcytMK1hUWHFUWWdoYmt2TTBr?=
 =?utf-8?B?MFBWcjBIdlhZdTMwMnk3U0t2YVh0M3RxbFJLNTR0akxzSW5JdzB1bmhpOWNn?=
 =?utf-8?B?QTlvS1ZEMGtRakdhMVppT1pNeUhBT1k5aDJRTzBlK3FpUG93OUN6QkJCYlQ3?=
 =?utf-8?B?RU5IcnJJUWdYdVZZcDlEVVIrQzZIeFQrVjEyYWtPcjNBOVMzT0RxKzU3Ump2?=
 =?utf-8?B?bVhZRGdkdjZMR0t5YitPN2ZFS25sSlNkUitYN2oxeGQxRXBUNFh5R2lZVlpI?=
 =?utf-8?Q?ocyFmCGD8HZI7QBLXS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e402a48-ff14-4377-6d28-08de57648488
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 14:10:36.7020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /AV2uJvCCSDLC/pejkzyzV9PMuODDFfJeezkbkFuMo1zsZynt0WlQmms4h3+D8In5t2QtG8WYN+hlBXO3k9Sdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7434

On 1/15/26 22:11, Mario Limonciello (AMD) wrote:
> tee_init_ring() only declares PSP dead if the command times out.
> If there is any other failure it is still considered fatal though.
> Set psp_dead for other failures as well.
> 
> Fixes: 949a0c8dd3c2 ("crypto: ccp - Move direct access to some PSP registers out of TEE")
> Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/tee-dev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index 5e1d80724678d..af881daa5855b 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -125,6 +125,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
>  			FIELD_GET(PSP_CMDRESP_STS, reg));
>  		tee_free_ring(tee);
> +		psp_dead = true;
>  		ret = -EIO;
>  	}
>  

