Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD5425A658;
	Fri,  7 Mar 2025 21:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741382475; cv=fail; b=lHeXjBd0gC0NfdEi1kVtXjdCR6XXR3yq5XOrnIIfLs5yDer5Yo7edA4y3WINr3hhn11TblMamWt4aci+dLZDm4I3EgQqbX3jmqLLMnZq5HIMuZhvzemsqH62gL2w++bPdOhzn4vMPG9xwCa2g2GOhuWCps2oWaV3TeOMgbvp5aQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741382475; c=relaxed/simple;
	bh=Ip8eNfqDCXfpzD6Re40hCr/oiSA7UpQhF4TTBWRaQMU=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QcENN+85jFEQ7ip6cPTyaPjOx9JADLW9PBxe1Q//0A5wLuA2iaoaHAqZE7VunEpi0DCDArDi+NbOMJVyiLc3lg+DSvcbDmeWc2CPagpWnAF4t22PfwRGTueAnZaR6d1N7vkjYyEStgfjwNdypWv+AXg57W1hBIcAQ+MYUEBT5bM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NJfjVHuL; arc=fail smtp.client-ip=40.107.243.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NJfjVHuL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MSQBRWGCYz75z+iDnXA8UhV1obMS0r3DO/J1nd7eQg3BJWUKgTXxFd2bJFfm2uTPgE4Gl43iNYbafOlphmybcm6X0ws0uAdsYAEKKZimAA/BmrfT8p4Eo0plU0EZSmYVvnLcJkRKqXyenAn2wMTgnNUVw8PLySo3/Src/tzJcOSUx6IicUMPssZGMZuOUuawBAVjZ/+ZpsEEb+s4iB3qsvYd5IsoMz3NXZcEjFj2GrWQZHEI5R5s1TotjhJscOpBCvB/0/tfzl38RpDJi1OAFO3MDmUG/bKMpN1MMp8NDqrxeyERBiCfcGRDn+Cg7UFMa3mtJ5vp9852+QRCTTEXqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YAHWwW410VbAH/sBK520ObO+P742lTsyaZAJLAkdSak=;
 b=euiODszSkng8IFE2Xxf42s+f5YRu1Y4NRfJRfjAaJwwdXh6BtmJb0mjJf/9IymowPKVifbA1Bvued9FGf2yq0MIIVFK3QecCSD6/oRBoqP41L2dRn6U7l9MudNitQp2o5hrXSKMh14/pNGXy7TYMZW3iZUAM+R9wpRi0aPw1pf19aXad2LsIpfBBG2eqRXW5PQcdDLirKPXU4bGjYsc2KA+LYi57oYUtUQDnA7FfBryOvnE3W+gGZKTjM5os4ua7SVl+kIK+ZQ4MhOydty+KdiGYFEJXXYVdfxJ24oNUp5JoYW4XH6oKe3d8kRfJ4seevW8lBEqHZ/Q5k47kd6+GXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAHWwW410VbAH/sBK520ObO+P742lTsyaZAJLAkdSak=;
 b=NJfjVHuLJpks+i/ycNfrDKpMgbUEMR7l6ukJbiShgdKtuxgSN0JSuUM05cuXo6x8gO+nASDKA8ndLe6GJ+OEQcjRyRftmsHMwCTrA4dSJSYF0RD0qMPmZghVLynHWAp08nx7YKYCy5T/pR/POdJa5kr8KiR+O+xAVyS9VXM1xNM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ2PR12MB7868.namprd12.prod.outlook.com (2603:10b6:a03:4cd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Fri, 7 Mar
 2025 21:21:09 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8511.020; Fri, 7 Mar 2025
 21:21:08 +0000
Message-ID: <e133579a-c295-bae5-56fc-f39e601c6be3@amd.com>
Date: Fri, 7 Mar 2025 15:21:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 4/8] crypto: ccp: Fix uapi definitions of PSP errors
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
 Alexey Kardashevskiy <aik@amd.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 John Allen <john.allen@amd.com>, "David S. Miller" <davem@davemloft.net>,
 Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>,
 Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, stable@vger.kernel.org,
 Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>
References: <20241112232253.3379178-1-dionnaglaze@google.com>
 <20241112232253.3379178-5-dionnaglaze@google.com>
 <d6ad4239-eb8a-9618-5be4-226dcf3e946c@amd.com>
 <d72dbe54-2d50-9859-7004-03daf419be86@amd.com>
 <20250220164745.GGZ7dcsXRG2hFOphRz@fat_crate.local>
 <947722ae-f099-d08b-0811-a9f967134640@amd.com>
In-Reply-To: <947722ae-f099-d08b-0811-a9f967134640@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0036.namprd04.prod.outlook.com
 (2603:10b6:806:120::11) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ2PR12MB7868:EE_
X-MS-Office365-Filtering-Correlation-Id: 99545728-2726-4ef5-12cd-08dd5dbdfa46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cWFzRG9OcyswcDh2MGhSZHJWUmpiRlhCSE1VSXcySGVobzVCSG93cVBQTXRN?=
 =?utf-8?B?SjgxM1dTZjFCd1plelN2ZFVBajlqdGQvQlNpWDBmNC9SYVlBemZNZTR3T1dH?=
 =?utf-8?B?U0U0SExQMVBwMFplSEtSajVQQmJkUjFZK2YzU1MrU2NkQnQvUGhxbTc4MXlD?=
 =?utf-8?B?N3piUkpjUUhXVE1tdUhiTGxpQk1VUXhxRy9PTmQ0UUwxV29hWnExL3M5K2lW?=
 =?utf-8?B?a0F3YUplYisreEEvaEJlR3BSQVZhUGtlMmt5RXJlRTJTT3UwcjZjN2ZSNUQ5?=
 =?utf-8?B?VG5DSzNRKzA1UW84aElMTnN5Z0FSTE9RRTNxYVN5YXMwR21OQXhPZm1Da3l0?=
 =?utf-8?B?R2FWQWdsN2RhZ2FrbFE3cFFDMjVwTXlncUo3TmNOTnQzSUFhTGFpeWQzVE1L?=
 =?utf-8?B?UEw0akJ3UzlJc1k4S1BXRTJJMGVHcGRJbTBVblNYL3J2ekJqZzZncHhHTkxs?=
 =?utf-8?B?Q21lZFI1MEI5RFVXVzcybjA5N1JoWno4elI3Z1BTd00xa0Fwc3YwSkRjTTJo?=
 =?utf-8?B?WTJVMnozSC91MkNINzhPamdMTjBLNGlBNXVqRVFzakxOTmV0NGNhTGRFVnUw?=
 =?utf-8?B?VGRXRGhrSmFKRlJic0RlUGdGT25UUW94SnhyTjYzRjRyUlBUVC9YVHVGOTVq?=
 =?utf-8?B?K1FOUlNqOFRxWDdrbC9RcnJJQzNtNzNLMjdURURhWjRBaU0zOWJZZzRVTDE4?=
 =?utf-8?B?WXE2MU5EL3ZLVkRHSmpSNWlYM1RHRGFQT2QyVDFOUXAzNWdNaDFxS2RJdWc2?=
 =?utf-8?B?bnNFcXEzZlZKcTNSTVBPeTBQMjQ3cU8yblV6Si8xNjU5ajkwU2lVOXoyaFA5?=
 =?utf-8?B?bWZyUDVsdmlQaGtEMHRGcHFNYm42Y2p4U0QvOTl1Q2k5ZGcxTHdrM2RHYlpk?=
 =?utf-8?B?M1pjVDdRSWc2WGlvT0thbDJPL1F6ZUFtbm9uY3Z5S2V2Y28wOC83cEhueXZ3?=
 =?utf-8?B?Z052aG02OVZVRmdLMWtidjFtUG1NdHlCa0RseUFPeElPNnJmL0hLWkFZK3Fl?=
 =?utf-8?B?dlNIaVMzVEZQWVF4VFR5YUxNaDc3M1l1Tk41VWMxbkxWZmwzMG5LekJRQWwr?=
 =?utf-8?B?Y1M1cjFtalRhKzZ5dXFuNzlUUnZoN2wrRVkxY2d4U3JrVzBkUmxiUWMzRE9x?=
 =?utf-8?B?a3RaMWxTdFhPM3ZDbmt0TUpDdStQczU5RW1ZSHJTcFNOanZiSUp6ejZReFFw?=
 =?utf-8?B?cWE5SFkxNmN6dTNvamwrdFB0ZzN0YTQ0eGJUNXFlNlBZelFmVWJMbStvSzZt?=
 =?utf-8?B?OXJtUktDNUpRbzBxczJxTnQ5bzhEWTZKL3UwL1I2MGZGelBvMHZWZG9SMlBL?=
 =?utf-8?B?ZmxWa2ZrVURjdTNvMUdtL01FQW5yaCt1NDBISUVxdzBwTUxIUGJrdVVrMXJI?=
 =?utf-8?B?RjZCK0s0SElqNUsrRVFhU0p2RUc3MmZBMEVPRlpBcXFiVkRySFpyMHFQODYx?=
 =?utf-8?B?UXZDd2JycFI1aStqNHBBMVpZZmxzSHBlNzlDZ2lOKzVFV2FtUWdQVGluZUVy?=
 =?utf-8?B?QTVLNGdBOWdVS3Y3eDBjTFN2Z1ZsbjBSVEJ4dEgwVTdVQ0ZFY3JpSmxjQUVp?=
 =?utf-8?B?TlNpTDRSZTkrZFB2Yk9RZzc5cUNkWFN1dkIyVC9wemlFbHRTYzNLL2NEekcy?=
 =?utf-8?B?dDZlajhGeWxYSlFaZXU0Z1laY1dkVUJVZkJqUU5Hd01zcXpmL1NHbkpIc1B5?=
 =?utf-8?B?U3ZmeWZwRzFJQ2N0TnRPOEFjMWZwdGo2Y0d3TTJRK0JWVVhpQVg3ZXd1V2w4?=
 =?utf-8?B?V1BPZFlzN3ErZHNRQjgvaUFMSHkreTI1bExxSHNLWmtaUENUOURhRkJlUzN5?=
 =?utf-8?B?Q0RRVUU3SFIyV2xScytKcXh6U0JlN2dESHZiT3hHbDZWV3NkU1hraXBsbkMw?=
 =?utf-8?Q?GsENUxhCMpDU9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TkRNY0pFaHlSd3VHR2UxdlU4U2YzTVk1WWoyT1FYU2dTWVhxaGR5NHROOE0w?=
 =?utf-8?B?dk1Td2owRGhNUFNuQUpHdndUNUxrUE5EOFE5MzBsK2gvVkZ0ZW5uR1VGejNm?=
 =?utf-8?B?OVR2SG1wMTBEbWdoN2VmeFFOQTRNdTgxc2dDcEczSHByc2tPaFMwL2F3Q2lI?=
 =?utf-8?B?WGZTR01XUUcxS1cyV2VMMnFvbkE2SDdpVTlhRnN4UERBWkhoVmpGUFl2d3pr?=
 =?utf-8?B?UDh1b2dZaXRsaEZvRnJWT1prR091aWloT0c0SGI5K1NSZ2krbTk1VFcySEtG?=
 =?utf-8?B?bm9iS1pwNlZJTVpoZmpKYTJrWmVBNmlOaVVKbm5Wb2FZU1FwQjA5bmJ0TU5s?=
 =?utf-8?B?Vllhend5OWZkWGgxbktVUTQ2Yk90M0ljY255ZGZOOTRRQmlVZ0VrNzJtVmp2?=
 =?utf-8?B?cVN2V202N0xIWVc3bU5tcVEzazRLRXhTZThSc1VtekRUZFRHTHRkN2JPbXN2?=
 =?utf-8?B?MnE5T2dzZytSd2YzQXY2a0tYRCtLdXJlQ1YxMnZmTHBXZFFqOGpFR2J2MG9Y?=
 =?utf-8?B?MVoxYSsvZzFWUHY5QU0vU3Z0VGpaOXA1Z2llR1AvS1hLWWk3STVmSEpYZXpY?=
 =?utf-8?B?MDkxSHJLQzllWnN6WHNOdDltbERZRnNsdk5DZUJWS3g3ako0L3BKcTBjWU5W?=
 =?utf-8?B?WUN0NWlRMFpQSGQvV0Z3Q0JBUDJYTWVzWEVQNG5XcTFUdTNYNjhhRmh1ZHQx?=
 =?utf-8?B?MXVVQUdiVGhSTHp3YlRvdGRleEJtSG5NWjdNMldZdTh5MmdIT0ZkcUFvbURI?=
 =?utf-8?B?S3Y0aloxOXJaMisxS3lkZ1JHdXgzMnpoanlmMU9OTlc2WmNGc2NuZGhkRUNC?=
 =?utf-8?B?cnFZbHNWK05ZRng1ODJjY3JJWUpSZDB6MjdGNVZicDN4Q2dKVlBpUitHV2Np?=
 =?utf-8?B?QXVPNkc4by94ZlZWTWdaZTZBWGJTNEphb21ZZ3lQZ3cwOTcxVUVtWU1keWR2?=
 =?utf-8?B?ZVlrSWxESkFvZUdTckszZm82MjRpaERWbnhRUFc4Zk9nTFZMOGgyUW1aelRL?=
 =?utf-8?B?d1JMK1owbEZ2c1JQam9kRDFZZCtmcmxhNjVtVllOZ2tWQVpnTWhNVzFSK2Vq?=
 =?utf-8?B?UlZvaTZLR3pEZjhXSkNvdGRMU1NLZFNrK2Y2T3NiVThvRXVZTGl6bys0dnVp?=
 =?utf-8?B?bmNUaHRFSHV5d1EwUVhrUHdCZE1QdFBzOXJEYm8vM1NoM1B5RVpLNUtHTm9J?=
 =?utf-8?B?dTlkbis2YjdwaGRVLzV5c0lOQlRXdER1RnRxMmtVQVhGRk1kZFc0a3d1bVlx?=
 =?utf-8?B?RDMwK3dxNEQ5aUhnZjVQY0hYOVpZSCtCU1dkcmhrUDlDMHFhTDBMUlN1WkJ1?=
 =?utf-8?B?RWNOcWsxUWRVNmh5bUo2cHhLRTJMS3VCV0RQNWIvY1l1cVppV2xOVm93dlEx?=
 =?utf-8?B?bEJTNUpRMGk4UTErVGVCa0RBSHFrMndHbTdhOVRFVUgwLzFKUTN0dWg2VGVK?=
 =?utf-8?B?U1NBaGNmbER3RHdvdHVEVS90NzZUU0V3Y2RFcmJhNmVLSW9zdHBhK0t6VzRk?=
 =?utf-8?B?TDRKT01qNk54NlI3WHYwRjhSSHlKQmJPK09KNzNiQ1cxQkhxa2hYTHBUZmJ1?=
 =?utf-8?B?ZHV2WWVybzVWeEQxaHgzSnJpT2I1WVZWYXN3aWZGR2pHQVhFSC9OYlBmU041?=
 =?utf-8?B?bFV2ZGVWblFvWm1uYWY4dWVBR2UzNVFVU2xiUDhja1V3NUdvWjZjNDgrUkZO?=
 =?utf-8?B?Q21sWmdJbXZRb2w3VDlOQ1JHaXNaZmpRVDBXOEErNFVHcHhuTTV2Z09FL0VD?=
 =?utf-8?B?YU44MHBrTVNwbzJ5UGJuL3F2RElKSTREbk1neWFMWnVvWkgrUUtVNmRWWUNT?=
 =?utf-8?B?MTZmQzZ0bFlSWVRpT3Vnckd2Z2N0dmdHektnWXdLTE5iUjNoNlNadlZLUmFU?=
 =?utf-8?B?LzZjRXdjT3J4VjA1S3o1Ymo2MXNuL3hvYWk2RjVMZ05ncE9Wb290b3lKMXpk?=
 =?utf-8?B?RWcveDYrQnU3aGNTeEVjTjRQYWtFMDJvQ3IzU2NuSTRVSEx5OWwvaHlGMUMr?=
 =?utf-8?B?SE5DNVVTakJPbklGVVk1U3YvQ0pmRmYvc1VuWVNqWHc2VDZ2eFhOalM3bjFy?=
 =?utf-8?B?dm5DdzROWnF5dFdTSS93eXpERWlxRU9WVlk3OThJMzRhRmhKeDlIYTJZQm9o?=
 =?utf-8?Q?Qv3dlWBJUnUl5SI1AvEhBmT2V?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99545728-2726-4ef5-12cd-08dd5dbdfa46
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 21:21:08.7971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2YQMiKskN9cwovcCCc4zrct42rPlo6dUPKXVDOJd3wWcte4ny3o2HFv9S2nQIjW1IAo1Yi5w+TycVpCydVynw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7868

On 3/7/25 14:28, Tom Lendacky wrote:
> On 2/20/25 10:47, Borislav Petkov wrote:
>> On Thu, Feb 20, 2025 at 10:34:51AM -0600, Tom Lendacky wrote:
>>> @Boris or @Herbert, can we pick up this fix separate from this series?
>>> It can probably go through either the tip tree or crypto tree.
>>
>> This usually goes through the crypto tree. Unless Herbert really wants me to
>> pick it up...
> 
> Herbert, any concerns picking up this patch?

Sorry, looks like your previous response got lost in my email system.
Either Alexey or I will re-send.

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
