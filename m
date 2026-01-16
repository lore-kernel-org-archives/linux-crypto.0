Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30162DAFCA;
	Fri, 16 Jan 2026 09:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768555210; cv=fail; b=hkKOjlrkMlgMnD5ZkdF7d3iTlgiyZwJi45T890XXxcgIY4g/AyteVkJJyuDOYEDtNd+sdmoGTOdqvKb9AydCXZVXIKt2gdZHoMl8H/lOmES9V5/2lcXNLBosedqPD7YpOYTwKS30QYLhxH6yPnOirRBjcTrROPHe0vGTGanEXSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768555210; c=relaxed/simple;
	bh=rkh82qt8N35QO8rKdvMsLROAPihx78vv89EIKmB+KGo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZyywcRvtavPMCyqmZnJSPOrVAoYm6NQUvoyHuGFA8C6MQfUPGls2i1DSV95AFLba8iFp/3E1bocppx5xGBlLuC26pPopqTYPDPuxcZQext8jG5wBbf+VYIkTq8becgmOW+/eYEIJ8BedHjt3le4cDSjAnY8cPmmpB1GE2eviBaw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=SOdKCFTD; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="SOdKCFTD"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60G508DQ2502330;
	Fri, 16 Jan 2026 01:05:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=vGmDkjwv06aBk8Kk6wwXbBKXCOpXX7VhLQT/8gdmazQ=; b=
	SOdKCFTDVDxohWnFf3mUwPpQ6STwD25++8TBC4HIeN0kapp4a0ntczOD3BSWzZ9e
	vBDOW8ecKUkByObKiKMIYB4s9AhMqqF/3idv1VqgY50E+jGhEMsvkAidNSXNgJAT
	F6a0NmkvOEKkdp2hWeP5Xpz9N75uOKzzfBBqcL5+7dYTYKMZ9xm3lFnQvlbYToPH
	BR6pmA+C9KsTSM/5l7WPWrd6x0VNykCP1Nln/BesCasnpZq0OKfqglk7pD974tJO
	Bqxo9nJo61y8RlLPvtqCiIK+573IlcjyKYGHWIa7YMIGDuu7AzCsCVkrshZ7APpr
	B8TdwtmOCerOVVjW4ipY2g==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012011.outbound.protection.outlook.com [40.107.209.11])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4bqd8e88eh-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 01:05:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VVtQGLS9HM0Ouu+X4G/+3FA2iOpd+Nm/4gYvkXTyIk1GKf/gaFNmPAeE1JV347M/57EyO0PagxUs5ih5jF+pIeOBxr24jbOCPhaNeLxMbehTlFOjtMALA8XHBCXHWhS46hoHEqkCBPr0j+waoPcbOzQaO30/8JeICOVGPk6Av6xbsl3N+M+cAxJeiTZBiAKszYZNL3GJmCLR/1SsbuVgvaX7ykgdTy3MbwGaW8SUkcAkfAmMjpIlICFkJqcec8pqWr7KjHH5IWWM6HlAofveoPc1uIsTDTgBdgS/YtL/3F+Ke+C0lcECcA1fBWBsbHC+KghAVt3xlG/WzNZO+IKdrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vGmDkjwv06aBk8Kk6wwXbBKXCOpXX7VhLQT/8gdmazQ=;
 b=lYQn3TRbSOkdDBb+s2zV6BkWbzJpfr1IKyulzfvSXsLvTubCPF1xhHxLZ/yi4KcHJqlaj/zOnaybi1NqAkkOJ5g40UArKK5FvpJRgo6/fuiCR0bqxQXeGyaTuelcCvEPqXsjjHcAgnyuWYOUWCn6nHt8SkcijkPTWyM022kt869qxCirWflkoC5nQ9OPqDYoEyT6VLC0YSePhYLBfZvLRgSYPXI53i6918uSwNoLXKqCH1jBHVLaFeF1LI8wZzlkEG/s7fDHwgsRjuTl/j3ERNMH3pbXnl21q8n2vXFWrILoRWtYYLTY66GvAPBeLlutvJZHnJVtLzBRVIl4Un4E4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DS0PR11MB7736.namprd11.prod.outlook.com (2603:10b6:8:f1::17) by
 SA3PR11MB9488.namprd11.prod.outlook.com (2603:10b6:806:465::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 16 Jan
 2026 09:05:54 +0000
Received: from DS0PR11MB7736.namprd11.prod.outlook.com
 ([fe80::f7c7:f271:a7b:7a68]) by DS0PR11MB7736.namprd11.prod.outlook.com
 ([fe80::f7c7:f271:a7b:7a68%4]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 09:05:54 +0000
Message-ID: <1be41c0c-8b9f-4394-a0ea-d0aa704d3521@windriver.com>
Date: Fri, 16 Jan 2026 17:05:44 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: caam: fix netdev memory leak in dpaa2_caam_probe
To: kernel test robot <lkp@intel.com>, horia.geanta@nxp.com,
        pankaj.gupta@nxp.com, gaurav.jain@nxp.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, leitao@debian.org, kuba@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260116014455.2575351-1-jianpeng.chang.cn@windriver.com>
 <202601161604.ynMta3vK-lkp@intel.com>
Content-Language: en-US
From: "Chang, Jianpeng (CN)" <Jianpeng.Chang.CN@windriver.com>
In-Reply-To: <202601161604.ynMta3vK-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYCP301CA0035.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:380::11) To DS0PR11MB7736.namprd11.prod.outlook.com
 (2603:10b6:8:f1::17)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7736:EE_|SA3PR11MB9488:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a9ce779-8300-4b17-3460-08de54de7457
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|7416014|1800799024|376014|366016|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ellDU0plT1VqQXZFekN1ajBQVjRmSHJBSkEzWjh2UC9XWEkyMkNvOHhEa2p6?=
 =?utf-8?B?UjdHWGdSanlQeVJjaFFiL2ZWUGQrREhYaWk0cUxhYlZxYWRlMnN6NEQ3c3M4?=
 =?utf-8?B?WXptVVVmd2dlNjg0Z0RUTXZSeTRZdzhIeWlsR3lJYU15Vk0yR012NTFTVWty?=
 =?utf-8?B?d092VmJXR0RYb1hqdWZoSHU1THRHaDV4QnZJa1F3THNBend6elRnbVh1dlU1?=
 =?utf-8?B?d3BFZFg0Q3ZqWklRenhkMElmK2JZbU5QSXJiSjZLVkVzZkZyN0huRXd6TVhU?=
 =?utf-8?B?S0pQaVVRVXJHcVZVcTRmb2hIN0FQMTZYbUJWWVdzN0dRTFJTTElRWnlJMkxj?=
 =?utf-8?B?K2R0VlQ2K0IybXNnZDZsTDJqRHJjOTM5MWlIZnFRZm0ycVJ0V1E2RDBlNDYy?=
 =?utf-8?B?K1hHd2NGQWVJb09VVGN1N2dDZk1JY1d0Q1FYRDBkTjhzZWo2N0V1Y2hVSkow?=
 =?utf-8?B?R2RFazdaU2JUbXJ0QmZlREJXTkZZWlY1bEdyQ2lLOWc2UXozN1lTVXlHZDFO?=
 =?utf-8?B?cG54STN1S2cvdCsxcXh0OFRaZ1hQd05jcU1CSE81eVBNWlNtZ2V2a0QwZkYy?=
 =?utf-8?B?bm5OQW5sSklsUndTU3ZFL3k0WVZqTVhoTDE3dkdUWmIyeGFjZWNtUDdUNndh?=
 =?utf-8?B?MHpLSnQyRGxYb01tdUJkcXJxS2tPZFY1QXEyNFJSbHp6MVkybGxzV1l0eTZ3?=
 =?utf-8?B?YUJGRmUxMmI4S0xHazhoNGpqODhya0VDZ1V5UktrOG1UdUVTcGcvak1zWnVo?=
 =?utf-8?B?UWxPeGdDNE56Z2hqMFFnV3RMcU03aVE0WFp4ZkVIclBHWXlzZWNOSWNKSFds?=
 =?utf-8?B?ZWo5azRmVCs2Y3VNS0RRM3FFRXZmMFNJcHA3bjdkY0xuTEg5VTdFY05ua2Uw?=
 =?utf-8?B?TXl6N3JxRVJSdGdGQ0xLMGxXbkRaNVBSQ0NuWGpnU2dzdXhBeXBKb1ZCR1BR?=
 =?utf-8?B?MHhLaCt1alRwQTNiVzRIOThKNTRBcUhBaVN0bkVLcFU2NTJYK2trb05hQUpV?=
 =?utf-8?B?akRxTlk4TkRlTEZZQlZvdk9LT21od1BXZm01OTE1LzNDSno4RHBYaG95SUt5?=
 =?utf-8?B?d0k4K2dYZnhwM2F6QTFyVDBncVU0Q3ZOR0RDbEhvN1hlYkhhK3BTanVjNTFJ?=
 =?utf-8?B?L0RXbEhnQ0oxVTFsUnNsQ25pZnh3U2c4eWpKZURTNzFwd3FBN2hEK0hrZS9Y?=
 =?utf-8?B?aU83eG4yZW55K2pVSXhNVktLS1RTTmdYQ2xuQWNTR0JQN24yRHozYTlzZzRi?=
 =?utf-8?B?RTB4R2c2MmNrZ2lIazJJUWxoT2hzczRNY255dUhBOXZ2Q0kwZUNrbU9abTJ6?=
 =?utf-8?B?bVFUMFJEWjE1VzBUQ0lqaVhNS3l4V3A0ZDFJM2R0aE9oKzVKTXhIcnR2MnBp?=
 =?utf-8?B?YWplenoyckIzTXlxTWlYa0JWR2tBZXBLRDFWWHlrRFp5NGVObmVMNEhzQnkz?=
 =?utf-8?B?QUJuLzRmL3BwNGUzT2FxcytSYkhKZkcySThJTFBKU2FpdUxYYTZJMzNWYWRa?=
 =?utf-8?B?N1lmT3lramI1R3cwV2ZZSG0vL3Z5Z0Qzb1hyTG43VWxQekxDcXhtalpJNmVG?=
 =?utf-8?B?bXNzNVJza1dLb0ZEMUtINU13ZDlQUzBrNE5pUmxKOW9VOWF4WXd5RUpUcTk1?=
 =?utf-8?B?bFlRQmZ2UFR6YkhaT3J0UERWTWw0SWpvZG0vbUpjTTFBdHMrb3NjWnVjRFcr?=
 =?utf-8?B?ZnZhQmkyNzF6c21hUkEzZzNvUGZvQVZyUDR3SGxqb2hwQUQ3TU10bXppemNo?=
 =?utf-8?B?ak9YNDhLaW5BTjdSeUxpbW1PaHh6Y2cwMi9HTk1nS2RNZmdodFVMZ1l0RDFv?=
 =?utf-8?B?SDdJRWhLUVpDdmlaakx1WG8ybEVYaGF3NVF3MCszakN5ekczendESTNVaUpH?=
 =?utf-8?B?aFN2ZVI5MGF6WVJXZUJjcEp3KzNqOTBHc2R6OXNnR0FVVDFNK3FqZ3I0UjNF?=
 =?utf-8?B?bjlzODliMHorNWwweU54M1Yra2FUOXNPaWd0VHlQOHZpY3loelRNdXMwMmEx?=
 =?utf-8?B?R3ZNejM1Rm42VlNSVHlscU13VkpnbjdDQlkvM0tzcjRGbFhDaFRLbVFvS05k?=
 =?utf-8?B?ajJmc3A5VWcyM0h4MkNVV2djUkVUNSthTjI1OVcya3RKd1REREt2THZHSEl3?=
 =?utf-8?B?S1h6NlJpSitRMnlKc2FGV2Zhd2kwY3YxbmxsbXcxUDZmNmNWbGNMOURNMlVB?=
 =?utf-8?Q?mUx/56ftHj/8JneivG6reWvYS1cVRcX72irhHOJvNH3R?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7736.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(7416014)(1800799024)(376014)(366016)(38350700014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0pEV1A0R2dBZWRtd3E2RFBiUkhtS29qaC9DQkhRWlR2YUh3cDNGOWZydXNI?=
 =?utf-8?B?QW9vaVgvTUNWZDMxQUZFWjRvQWFQRDhRZHJMbHpGUko3VGRxT3JObEJMWE5a?=
 =?utf-8?B?VEN5YkdyZUdVcE1nWEFOeUdJbW1hcTRMdld5dDhtSWpPT1VLODFPWUdMMnlq?=
 =?utf-8?B?aTk0WTJpV1poWUE1eTJ4ZUJzdzdRVEtLZmFTbzUyRnlNNzFRTHVyd0tmb3gr?=
 =?utf-8?B?blhhVEtvR1RwMVowLzl0WnhNaFY3aG1TdWFjU3JmSXVuQWppdklLMFhmMWlq?=
 =?utf-8?B?bHcrVjRKWWVOVGRYb2c0Sy9SWlVBMjBJa1ZhdWZiRmRWaG4zK0RKSjhlN1N3?=
 =?utf-8?B?YW5DdmtoTEJUZTJ1MUx3YmpvM1lMWFJvaVMwVE5HVk1TNDBUZWtuMVIwMFV0?=
 =?utf-8?B?ZlZ1WVhpelVPQkdESVE4Wkw2L3VodmtTM29rVzhVNEVramtzVTc2ek1oc21a?=
 =?utf-8?B?L095THQ3QkRkWitsRnJTcWJ2eTlGS1RqeGxKbXdYNXcxSHdmSzNvS1kxTUdC?=
 =?utf-8?B?NTJIWnVOTHZCUE9BWm94bDBvWmdBM0Fxa0FEVldYTUM5OFNlY3FHU0twNkdD?=
 =?utf-8?B?TjJDWWYvV1JtaGtTbFNPQm9oU1BhZFhOR3h2aEtVT1pqZWZBaC9VZHBDR1dZ?=
 =?utf-8?B?T04yUFZLYjBXYzZpdHY3bDhWTEphYzEyUWloZkRFc2ZycE1DelFJeWYxNnFM?=
 =?utf-8?B?SXJKNkNLWi9PbW14Q04xMkMzSDFLd2t5b3NUb3B2VmdheDB1cVY5N2tKRVpS?=
 =?utf-8?B?bUVWT2JTWTN4OXU5aUVucHpKTlJ3VjYyTTB2aFg1RTF0c2pGVnJGbWtSSS9t?=
 =?utf-8?B?Ylc5bFBhWkxEWUhibW85VDZQNmRhUGhROVVUNmt0c3oxV1YrTjV4emwrMCtS?=
 =?utf-8?B?TUxZMHVTU0JDZUZVSHR5L1hnVmlaanZuYUFCNE9qcm1GaDBZNXBJRk03SEI5?=
 =?utf-8?B?R1c0SWJYaXNSVnc2TGFFa1dLaTAyTVNhd0Y0T29FbHdEc2lBUjVkWk9GMXl6?=
 =?utf-8?B?Q095ZTNjQUdFL3NoVWgzUHJLQ2dBR0Zsb3VZdlJBNFcvTGdCMHpidjNtSURq?=
 =?utf-8?B?aEQ3NEFGUlFHYmxhc3pmanVLL1AzY09PaGgzSU5zNDJzWm8wNDBNL2xoSFMr?=
 =?utf-8?B?S2d2ZzU0NG1tUEl1SVd0anpOelUrWGx6SWtkazlwVVl4cE5EdU5uMEsyVGxo?=
 =?utf-8?B?VVpIeEkxNU5HZ1hyZnNKZkdheFlrcVZzVDhLZDE0L2NTWU52MzE4ZlNaWGsv?=
 =?utf-8?B?Vm16aFN5OVhTSzRZZFp4cEhDK2JBbVN3VThqUTBabTFENDh3V1U2YmNIenZu?=
 =?utf-8?B?bFc1RzFuZ3dTbWdEdVV6OXdIR0VMZjlnM0kwZ0tVQUVCNXVYOEI1NDhkN0xP?=
 =?utf-8?B?ZDdYNFl3WFk1VFc5TVZqTmg5dm1kQ1F5cTdvam9Pcm5wc3phc08zcnRvUHhh?=
 =?utf-8?B?YXgrQWhwdU80Z3dBeEFRVlJ4dnRWUEFrbWxpWlhqbmtaSUpJZ1BjWVhKbUpG?=
 =?utf-8?B?N25jSjJaSFhvb2V0cDBvZUs0anl4Tms5QXhWMUdPYUY2VzlzTy9zS05QQnUy?=
 =?utf-8?B?UkMxY1h6Wms0RkpzamNNLzhkSHR2YWZmUTg4UXBydjJFQ2lCN2lhRmFtN21o?=
 =?utf-8?B?N09vU0xSTmRBcnNUTXZlSEFVS0dtRUV2WUd6UDArdzVLdzBvRVE2MTZXeEpP?=
 =?utf-8?B?UTNrNitPRjROTjBYdmR6TnFCWCtaeUFPZGdOaGxsbmRHa3lyNnJxTjBpMkI4?=
 =?utf-8?B?V3JaMjBicFBSTTlwbXBBOWh3N3pyQkVtMU1LQUthemNUQnhnSHhQVUdWVUQ2?=
 =?utf-8?B?NEY5UFJOQUpGVE0vNUJrbEMyZGJtL2dFMnBLL3RRR3p1bWdET3dpSlpld0kw?=
 =?utf-8?B?dWV1ZVQwRVBtWHNMNFJXcnZvTDVPcE1DdmNsOHh0cVl3RUpaQXZtdjlhZmly?=
 =?utf-8?B?NC9KUkhSYVA1SnFBUUVYbVZnZ01rUnFQOUFrMkEyMnZkdEI3a1BNcEx1NG5O?=
 =?utf-8?B?RzQxdVc4TER4NVdRYVdiamh2dUkvSkpCemk4UDB3SXVIUktGSFUwbGs0YTYy?=
 =?utf-8?B?Z1B0bVFTYVplY1JObkFMTXgwbC9RWDYrQlVpNzhjTVhYZldJaGpEK0ZSUGV5?=
 =?utf-8?B?SmFrWnpLbkYvSVUrckFXY3hEdWlNeStyRTBHOW9jdnNlNnM2Rjk3U3g4WW5y?=
 =?utf-8?B?NkhqVGhncVh2RlE5d3l0U3NOa1RZQTJza1ZuSnV1d09ScWpNNHdYT3lwNFhL?=
 =?utf-8?B?Z0h6VkYxaUZJWi9zakE3RklFTWp0T21tZ1J6ZGFRaFZEMVNPTFN1WktuOE84?=
 =?utf-8?B?OHdyQ0craUphUnE5ZlZFcnkzOW1CdEdETXJvcU81cnVJN2ZGeGc0Qytad1F1?=
 =?utf-8?Q?rcropPNAivY2ct+c=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a9ce779-8300-4b17-3460-08de54de7457
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7736.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 09:05:54.6951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wxCjwc0SFVcem925e8Cs9PthdzGjnpz1rRoKzo1Zn9/SFnDGFPKTAQKjt9zQqaVFKZgZWnU2he3YHdp8aD5fKudC1sbe4XvSqDIJGpMHEYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9488
X-Authority-Analysis: v=2.4 cv=U7SfzOru c=1 sm=1 tr=0 ts=6969ff75 cx=c_pps
 a=q3M5bEXgJc9IxHNyMLvWsA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=anyJmfQTAAAA:8 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8
 a=t7CeM3EgAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=UyA_29lnkp5uifny7-8A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-ORIG-GUID: AOkrY3L0PIVr-O-AK1D6_8wZ0ehkW3n0
X-Proofpoint-GUID: AOkrY3L0PIVr-O-AK1D6_8wZ0ehkW3n0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA2NiBTYWx0ZWRfX+38kMfg3f6vS
 A0VK1JKbbvUd0rd4x4MFNpF+E7EadPcnJ5lfLETGe28B7pipmatVDYZ/Uhc0RQHV2IAe9FxodPx
 5CL+Zj1D3kEcCsAsxI78TILJE+HzE6pME0PUo6I1zoWWt3FoFg+pHWCYL9Ucblavh6nzGIIBEfS
 YXCiZRpymXHqe04Sxd1ezNMWs911RQbd3wxcvJoaDb46Jpz8W9j0cF7Rpy9fyvzhFDF3U6VRQBf
 dfLeUvZtkbz1cw/qhB9FX0Cd4XS1HCs6e5Q33Fyd/yDcm3t0m1hymHVwMFBzhSr1lwTcWwnflO0
 QXevRgifN7B25GM6RltGY4ECYJXcySRat/VbLOxxE5O+raHNFhIdRk5uUUni1EW1RjZlkYkue4I
 xq1cdB2FDs+1L383FJdo2iXeHohsJur5O5Bk12ZRSpahTVRzE1eIaSVLRcgqVegXVmXSfqKinM5
 tivgX7ffNzdg8tneshA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1011 impostorscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601160066


On 1/16/2026 4:19 PM, kernel test robot wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender and know the content is safe.
>
> Hi Jianpeng,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on herbert-cryptodev-2.6/master]
> [also build test ERROR on herbert-crypto-2.6/master linus/master v6.19-rc5 next-20260115]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Jianpeng-Chang/crypto-caam-fix-netdev-memory-leak-in-dpaa2_caam_probe/20260116-094800
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> patch link:    https://lore.kernel.org/r/20260116014455.2575351-1-jianpeng.chang.cn%40windriver.com
> patch subject: [PATCH] crypto: caam: fix netdev memory leak in dpaa2_caam_probe
> config: x86_64-buildonly-randconfig-004-20260116 (https://download.01.org/0day-ci/archive/20260116/202601161604.ynMta3vK-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601161604.ynMta3vK-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601161604.ynMta3vK-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>>> drivers/crypto/caam/caamalg_qi2.c:5132:19: error: array type 'cpumask_var_t' (aka 'struct cpumask[1]') is not assignable
>      5132 |         priv->clean_mask = clean_mask;
>           |         ~~~~~~~~~~~~~~~~ ^
>     1 error generated.

Tested only with CONFIG_CPUMASK_OFFSTACK enabled.

Please ignore this patch. I will resend the patch with the error fixed.

Sorry for the inconvenience.


Regards,

Jianpeng

>
>
> vim +5132 drivers/crypto/caam/caamalg_qi2.c
>
>    5007
>    5008  static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
>    5009  {
>    5010          struct device *dev = &ls_dev->dev;
>    5011          struct dpaa2_caam_priv *priv;
>    5012          struct dpaa2_caam_priv_per_cpu *ppriv;
>    5013          cpumask_var_t clean_mask;
>    5014          int err, cpu;
>    5015          u8 i;
>    5016
>    5017          err = -ENOMEM;
>    5018          if (!zalloc_cpumask_var(&clean_mask, GFP_KERNEL))
>    5019                  goto err_cpumask;
>    5020
>    5021          priv = dev_get_drvdata(dev);
>    5022
>    5023          priv->dev = dev;
>    5024          priv->dpsec_id = ls_dev->obj_desc.id;
>    5025
>    5026          /* Get a handle for the DPSECI this interface is associate with */
>    5027          err = dpseci_open(priv->mc_io, 0, priv->dpsec_id, &ls_dev->mc_handle);
>    5028          if (err) {
>    5029                  dev_err(dev, "dpseci_open() failed: %d\n", err);
>    5030                  goto err_open;
>    5031          }
>    5032
>    5033          err = dpseci_get_api_version(priv->mc_io, 0, &priv->major_ver,
>    5034                                       &priv->minor_ver);
>    5035          if (err) {
>    5036                  dev_err(dev, "dpseci_get_api_version() failed\n");
>    5037                  goto err_get_vers;
>    5038          }
>    5039
>    5040          dev_info(dev, "dpseci v%d.%d\n", priv->major_ver, priv->minor_ver);
>    5041
>    5042          if (DPSECI_VER(priv->major_ver, priv->minor_ver) > DPSECI_VER(5, 3)) {
>    5043                  err = dpseci_reset(priv->mc_io, 0, ls_dev->mc_handle);
>    5044                  if (err) {
>    5045                          dev_err(dev, "dpseci_reset() failed\n");
>    5046                          goto err_get_vers;
>    5047                  }
>    5048          }
>    5049
>    5050          err = dpseci_get_attributes(priv->mc_io, 0, ls_dev->mc_handle,
>    5051                                      &priv->dpseci_attr);
>    5052          if (err) {
>    5053                  dev_err(dev, "dpseci_get_attributes() failed\n");
>    5054                  goto err_get_vers;
>    5055          }
>    5056
>    5057          err = dpseci_get_sec_attr(priv->mc_io, 0, ls_dev->mc_handle,
>    5058                                    &priv->sec_attr);
>    5059          if (err) {
>    5060                  dev_err(dev, "dpseci_get_sec_attr() failed\n");
>    5061                  goto err_get_vers;
>    5062          }
>    5063
>    5064          err = dpaa2_dpseci_congestion_setup(priv, ls_dev->mc_handle);
>    5065          if (err) {
>    5066                  dev_err(dev, "setup_congestion() failed\n");
>    5067                  goto err_get_vers;
>    5068          }
>    5069
>    5070          priv->num_pairs = min(priv->dpseci_attr.num_rx_queues,
>    5071                                priv->dpseci_attr.num_tx_queues);
>    5072          if (priv->num_pairs > num_online_cpus()) {
>    5073                  dev_warn(dev, "%d queues won't be used\n",
>    5074                           priv->num_pairs - num_online_cpus());
>    5075                  priv->num_pairs = num_online_cpus();
>    5076          }
>    5077
>    5078          for (i = 0; i < priv->dpseci_attr.num_rx_queues; i++) {
>    5079                  err = dpseci_get_rx_queue(priv->mc_io, 0, ls_dev->mc_handle, i,
>    5080                                            &priv->rx_queue_attr[i]);
>    5081                  if (err) {
>    5082                          dev_err(dev, "dpseci_get_rx_queue() failed\n");
>    5083                          goto err_get_rx_queue;
>    5084                  }
>    5085          }
>    5086
>    5087          for (i = 0; i < priv->dpseci_attr.num_tx_queues; i++) {
>    5088                  err = dpseci_get_tx_queue(priv->mc_io, 0, ls_dev->mc_handle, i,
>    5089                                            &priv->tx_queue_attr[i]);
>    5090                  if (err) {
>    5091                          dev_err(dev, "dpseci_get_tx_queue() failed\n");
>    5092                          goto err_get_rx_queue;
>    5093                  }
>    5094          }
>    5095
>    5096          i = 0;
>    5097          for_each_online_cpu(cpu) {
>    5098                  u8 j;
>    5099
>    5100                  j = i % priv->num_pairs;
>    5101
>    5102                  ppriv = per_cpu_ptr(priv->ppriv, cpu);
>    5103                  ppriv->req_fqid = priv->tx_queue_attr[j].fqid;
>    5104
>    5105                  /*
>    5106                   * Allow all cores to enqueue, while only some of them
>    5107                   * will take part in dequeuing.
>    5108                   */
>    5109                  if (++i > priv->num_pairs)
>    5110                          continue;
>    5111
>    5112                  ppriv->rsp_fqid = priv->rx_queue_attr[j].fqid;
>    5113                  ppriv->prio = j;
>    5114
>    5115                  dev_dbg(dev, "pair %d: rx queue %d, tx queue %d\n", j,
>    5116                          priv->rx_queue_attr[j].fqid,
>    5117                          priv->tx_queue_attr[j].fqid);
>    5118
>    5119                  ppriv->net_dev = alloc_netdev_dummy(0);
>    5120                  if (!ppriv->net_dev) {
>    5121                          err = -ENOMEM;
>    5122                          goto err_alloc_netdev;
>    5123                  }
>    5124                  cpumask_set_cpu(cpu, clean_mask);
>    5125                  ppriv->net_dev->dev = *dev;
>    5126
>    5127                  netif_napi_add_tx_weight(ppriv->net_dev, &ppriv->napi,
>    5128                                           dpaa2_dpseci_poll,
>    5129                                           DPAA2_CAAM_NAPI_WEIGHT);
>    5130          }
>    5131
>> 5132          priv->clean_mask = clean_mask;
>    5133          return 0;
>    5134
>    5135  err_alloc_netdev:
>    5136          free_dpaa2_pcpu_netdev(priv, clean_mask);
>    5137  err_get_rx_queue:
>    5138          dpaa2_dpseci_congestion_free(priv);
>    5139  err_get_vers:
>    5140          dpseci_close(priv->mc_io, 0, ls_dev->mc_handle);
>    5141  err_open:
>    5142          free_cpumask_var(clean_mask);
>    5143  err_cpumask:
>    5144          return err;
>    5145  }
>    5146
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
