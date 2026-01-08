Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012016.outbound.protection.outlook.com [40.107.200.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1005829AB07;
	Thu,  8 Jan 2026 20:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767903159; cv=fail; b=tVslkW5Rn6WgJ1O2mBNPoZik9reW4TNbktLduGJ82QdUlJfKgSExOHXyB3XVQxkRjvJt3l7BMWTdUSWcS/A62TdKAXkaM3Svg0uTm9XmFiF5fSbV/S7LhYMWFhAHFJJMzMh5pl0d3xkjuE+Kte3+IVNLNC01QDM2Qmuw4/xnyTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767903159; c=relaxed/simple;
	bh=92Lfb886BYeYwUFp3hrjkp7NCLG5k7wTqpcwDJBQzoI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nrpWOR+ZUErDn734PFMYZA5dSa0naWTmd3XdFccpnZuzQF3r/c2M1pzHGPupn2wcrWAW7+rFPckpihoLjpFNImNd6HAbHKGjRJxk11LS5xV1yHpQQ4M64dHNEOY6ZuTLxft7YbJCbKiKc9QEEp/4bBzO2KlPBEj5WYw0ZuzdFIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VpaVny3a; arc=fail smtp.client-ip=40.107.200.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VpaVny3a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ipokj+KtTwiO94G0kDxt52RHJtCi4DP06Oa7LXHXkUGyKWqdTH8OP/ys1IlTFCTZ6pM7pnYRoi4JEXx11cDraYb6/T4NxCU3q7FpyHu8n8aqUUYR/+vNoA2t6e5F+9cKusTX874PUahhXK1A8VBiNAGxe/6ObNLPXDP00fnLvDXeoaesiIwJn5bz88CCMkB4428aPWbYaToMDzo+X08ASMG6YcHduX2PYDuIu9fDHDsYtj68a5f4IDFjAvYp8YnmKDLGkRkCIRJqdjuq28aVujv48BgbynMUxVyD6cy9j8n2fR1rcHpJhVwnDmurcAP7s66G8/l+RKDQR0FTSKIT8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zp2vI4Ohw3BX9cUazlmkh2yIyeKKUagytFhsXgYTR1U=;
 b=mvdaAZnef3Qu1wL5wjdW9O6YgXvV3a8eEaeuEM9BK84NhskSUEYB9iJPqnSG/DOUTySGuo0JsY8Cvb/dwVuX5QMi3YgxDaiSrstjPnZ8opPhcrKqxv0oh14brIgpTguCWA5kzY8wVdJKqFR832jHwrTMkFV3+l+4aAUsFdtruMEjPolumIIUgIZe9D9s+ZscSVFBIm4y3CvjkhZiTpulo2j5fzaK17wTWuMAzvbwOr+VDhrARydywUAirXH3WsLCCscXF45r9L9E429SXX+F+EmkUM5p3I1F30Ir36IleXgVi/B649UfbOUXfffBbDgwUaWe0U/NQCq9eOF46dBASQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zp2vI4Ohw3BX9cUazlmkh2yIyeKKUagytFhsXgYTR1U=;
 b=VpaVny3aVPzuhl3G4rS9lrjCeHn26Zj2TuXuSf3sVI5M0dEx0MDbmXYG9XSqiKmHzRON2WMXgtaasv8sNuVRBEzYtEI2kTL/PvhMsxiVDAnotsnxmAIzaC/eVGaUb68YhOnAU5ITbIypx/vpYjzuA3M50sgY0KUT/CYvn3vSpXE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BL4PR12MB9534.namprd12.prod.outlook.com (2603:10b6:208:58f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Thu, 8 Jan
 2026 20:12:35 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9499.003; Thu, 8 Jan 2026
 20:12:35 +0000
Message-ID: <e584b8d6-2469-4d62-8689-b9a22b43c569@amd.com>
Date: Thu, 8 Jan 2026 14:12:33 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/crypto/ccp/ccp-ops.c: Fix a crash due to
 incorrect cleanup usage of kfree
To: Ella Ma <alansnape3058@gmail.com>, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, arnd@arndb.de
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 julia.lawall@inria.fr
References: <20260108152906.56497-1-alansnape3058@gmail.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260108152906.56497-1-alansnape3058@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0210.namprd04.prod.outlook.com
 (2603:10b6:806:126::35) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BL4PR12MB9534:EE_
X-MS-Office365-Filtering-Correlation-Id: f151d15d-bfbc-4dd5-8f78-08de4ef24323
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RU41OWpZWmJRL0FlWHV2RzdCcTZJNmlEQ0RqbjhHcDJZWW81eEU2OVpoYjEx?=
 =?utf-8?B?T2NsS2wrZysxKzZFM1Jsa1dPTHcxS1Fkc092Z0Y4U2NuWTFMaHhTTDZGS3RR?=
 =?utf-8?B?bDZQSkptWVFUWE03OVVCTWZySjJVZXQrRlBic2x2YUg2aVBJUUVVMURic1F1?=
 =?utf-8?B?UUlUa2k4cDVad3J2b2xrUngwS0wrb0xnWC96TThJTUkwRVRvWEJoaXNYdWpk?=
 =?utf-8?B?RE01ekhWOE1iV3BKQVREdXRXelNHM05DV0FCb1BLa2JWNGJlN05NNHZSQjFH?=
 =?utf-8?B?K0FIalgyV2h6V1laR3hlbWo5R2FMQnVKT2ZsYXh1TDNibmpPa1ZDaHdnTEVz?=
 =?utf-8?B?QkFvTVdRTzdXV3VxeXExL2tqajdBTEVGZzhjMEhQemdXS09Wd2NPbTdlbmlQ?=
 =?utf-8?B?bGticWRCWTlpOGl3U2dXZS9XbDA1MERYa1FMTVpkZU5UZVZERkQ2QU92WGY2?=
 =?utf-8?B?ek04TTJUM21kTGJqbldMZmJpUDF0TGl6VHN1cHgxWFU1dGdONzQrWVEyR3Bi?=
 =?utf-8?B?QkRWS0JpSnJnb3ByV1FGaS9WZlFlRVdCQTNJZHlrK2gxOVdMaWRtT1pWUDAv?=
 =?utf-8?B?d1BDTzVtcWh4QWpHa2o3TENkK3dla0JaZUdleWJQbEh6SkJVeEY5c0hoa09y?=
 =?utf-8?B?QW8rVWphYkwxK1lVNjRTYXpFQWliMG5xd3YxMDE2ek1QbHM3SkZyZElMWGZv?=
 =?utf-8?B?bWxkWlJVaWNmNmdyc21QREdDM3kwQ0JYS2Q1Y05lVHhIaTZLaHVLNFNMZzhZ?=
 =?utf-8?B?WjExc2ZWRVhJM2xqelNjMGxhR080SHFuZEJkUks0djJ5L1B3UEZPcWhoZzVS?=
 =?utf-8?B?UDhrWWtxTzJzMXdvSkFYNTgwbFhjQU1YMk5pRkF5Um9nTWZSVFlJNnp0NkJB?=
 =?utf-8?B?S1NVMU82bWs0TG1FcmU5NFFCWDlINnlkNGI4Si96bG5XUW9IQU5VQkhGNjBV?=
 =?utf-8?B?dVlnMGxodnlxd2hERlpFS1luQzlWRDNzYVM5OXF4QTdGS2JvS1JFbnJjWGhm?=
 =?utf-8?B?SFdBbFhLZzVDczRON3RCM2d3QXYzZ0pLbDR5VzdvVDlKRmlzOXZYd2FFUitt?=
 =?utf-8?B?QkNPV3ZzNFMycGhTOE53dE9nejkwbHZuS1JDMzdZeEc1c3RmSWhmZ29GSElS?=
 =?utf-8?B?SXJvVXNCUHVRblBzWE85eDdnMWR0OUtMb2toT0lzU3BTYmdsSTY4c3BHYzFK?=
 =?utf-8?B?S255bU56R0NiVjdnRDFFMy95OFFwbU1Wc1hkZEhGdk8rZXl4VVhpQ1A4YXJk?=
 =?utf-8?B?bUJIOHJ5NWR4bFYyMGxzcyt2SjFLNDdCcWV4RjUxNkJNaERxdnhNcFl3Qnk4?=
 =?utf-8?B?ZlNJVXlNb0ljYXUxSHhhaVlOaE9rRFc2VmkvVU43VjFQbHRybm5peThKZUV0?=
 =?utf-8?B?SVhlRW15TEs1WTduajJXQ0RaQnVOU2FaOG8xcTlRUnJXdUxsd3ZvQTcxdGds?=
 =?utf-8?B?L0JTR094OEJSSTdoZnlidk94aGcwWUdwK1NsZlc1T2lMaFMrVVZZMVBYSXQ3?=
 =?utf-8?B?OWdsNlJUTUhFM3poTXZnWXZ3VE5mUEFzUDhneExRQTlVU2FFWHZzenM5Uy8v?=
 =?utf-8?B?RWZPcjE3UngzY2FBWGtseHV6V05xYWkxUklFSDZaS3F0a1R5L0hqaHBJZ1pU?=
 =?utf-8?B?azBkckVpaTdiQXIxVlFWM1ZCemRkT3VWb2JqUFhLbG9jODcxQUEvNllKeGtV?=
 =?utf-8?B?amhrMGZlWm1MVGptSEVKQk11MEJ3RER2UWoyUDFHZDRKQS9wOXFFdFVTTUF1?=
 =?utf-8?B?Vm13bm9GUDA4d0VlQ3VUNmtuL0NEWHhiMVI1OUlsd0tNRm16Ky9NSkhubTRC?=
 =?utf-8?B?VCt4akF4MnNlMmRXdThQdmdXbmtNZy9wWk95K3B2cUUvNkxsbk5TVXBOWURo?=
 =?utf-8?B?Z3ZWN1RKbXFNQnMvT0ZXVlBocVB5Z25pY1dDODZ3dCtYMnI0aEhsb21tR1Jt?=
 =?utf-8?Q?yuLebEmHnEwTcepo/VQUrk/n6zF7n79f?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVJoOUNUYjdYeGxmWkV5YkU4cHE1SUU2Rm5ZOEJnenM5ZGF4QmU5R0JPWWc0?=
 =?utf-8?B?TWs3NDlYMlFCSU5EZkhYNm12SmNqSTVKdTNQT2pXT3lseTgrQWFvbW9OdTJy?=
 =?utf-8?B?OEU5ck9ZUElqSjZmTmU4YjBEOHliTGNzb0NpWVlBZHNrTzdiNXFrQTQ1WjFQ?=
 =?utf-8?B?K0x3ZkxHcXYwVm91WjR0VnlId3kyMC9BUTVrK1kvSGFCNExVdm83VVE4L1pr?=
 =?utf-8?B?QTN1aTJScGxCc3lvV2NhRzNnYTNSTStWU0w3N2Vjemh4NFpzTEh6V0lyTFdj?=
 =?utf-8?B?Yy8zNkNQUUQxbVYwd241dm1Fb1M4WHZvaVlMd2RudmpiRWRPTUNwTFMwaUJu?=
 =?utf-8?B?UHowUmtYTEtvcldBL295bGJDc1R6TnJoUHhyOHB5Nkg3bTU1WCs0UWpSYVFT?=
 =?utf-8?B?MXZpS0orSUl2MHp2cm9ocG44VDd0cXU0dEwreG1IcWJEd1RyK1Vud3JVeTRG?=
 =?utf-8?B?bVRza3dxMmFsL1hST2YyOUxXdExCU09kelFWM3VSQWxzbVZQT2VJZEYwS1hM?=
 =?utf-8?B?Z0cwYU9RamgrUStHR2FldzVWV2p3TGM3NFVwcTd4RUN5THBQVG4yRWkxUXZu?=
 =?utf-8?B?QVNyRjVoODIwdVg2dVQ5eWlSY0JoaDZGdkxTbHlaV0hYb0NnTC9UdTM4dnVU?=
 =?utf-8?B?cXdpZVBFZjVWVlUxQk85dWtYR1dRYWtHeXhBd2RjOVludEZZcWZ2U0NIM01N?=
 =?utf-8?B?QUJuTlloaVo2cmVEM0dWZlkreW04TElvWVFLRWNvdjdDOWRac1dDbGZMVGlH?=
 =?utf-8?B?WEc2c2grZU9leVVGa2FsYmxIRVZ2a0VLYW40SHRObS9Gemg3bEdraTZXTXgr?=
 =?utf-8?B?b1FZV2tUa2lTTG9RQUJaMnllQlpXSjZqeXJyS3o1REVObE5WU243VW1wanFL?=
 =?utf-8?B?MEowL3ZnYzRwR0kyQXJSeFJtSmd3MlVITStBVENQTXV0eFZLZUc0MHcxamNO?=
 =?utf-8?B?ZnExeUFZSnYyZGgwRWRGUmJRdkpWa1JkMkNkeUdEY05VeWE0QzNQbUpabSt3?=
 =?utf-8?B?UFdZZmhDS0k0WWkwL1lSbGJlTDRza3QrQWpBOTd3WGlUem9rQTN3MElYcmNG?=
 =?utf-8?B?bWxYNjdSY3lKYnFjMHBYcE40SFY3bWtOcUppRHhOUHR3U2ZITHpmV3VsVEJv?=
 =?utf-8?B?YjlDRm1kd3ZUdmtjMktCYXBSYzJ3N3lVYlgrbzlRT0JpdCtFdjNKTkFxd3lD?=
 =?utf-8?B?Zk1pN1pqZHNFN3JwREJkQVNsZENRWkJWbjFqTGNWb2pWcDh4RFVKei8xRlJw?=
 =?utf-8?B?VWR0ZjVGYUtoMVVLc0tEcG1XR3V6UVJDZnVab3I2WXplMWROZGRQbnlZSUhG?=
 =?utf-8?B?WmVRUVF4aWlrei84V2tFNllGNkJtVkp6YWg1bGR3eElQZkUxRTFMM3RPaHlj?=
 =?utf-8?B?VDNORzBhUlJKV0NPbVM3R2hGaXhiMnRHNjdRSnBaMEJxc2pOWUxISjN5NUJK?=
 =?utf-8?B?ZktRaVRLMndERDBIaTkvYjU4ZDN0YllJck92Sm1DZlJJWWpzbUhPeFpzaUdX?=
 =?utf-8?B?RFI2ajJTb0NQd0hUTEdSTkNJMDRVQkdZeU1zN0JTbSs1M1ltVjNpai9JZms2?=
 =?utf-8?B?YXRlWWp6dnpkZVVKL3lTeCt5R0xoWFVGRUFsS2JFaHh0RENZUm1DNTFlVzhu?=
 =?utf-8?B?Z1V4UW5VK3BJLzk4UEZXSkZrTHErMnAvYVJ5SXhtWWF0NWpKWnhyNFBWUXJE?=
 =?utf-8?B?elVhRzBUR0t5cWZSc3ZmMUlLOFRmb3o3dnNrd0QvZzlRZjJtcnE4bzZmNXkw?=
 =?utf-8?B?a0xyZEF6K2xCZldyT1Nhekp2RVRiVjRjZG9Vb0ZMMklrQnJTcXlkRDBuNUR6?=
 =?utf-8?B?ZVd0eWVQL0w2UmZQdFNRUkZHTm9jWjJDSTJrdjNIUC9nWGptQ1ZwQkVjdHZL?=
 =?utf-8?B?bTE0K3FLZUU0d1dUdTZVUDJWZ3pja0xuQzJhdjI4c3BLcHVLZDkrbWVzeVRH?=
 =?utf-8?B?WDBlVCsvL2ROOXFkTWRMeWl0Um8xeStJd1FERHdsTjRsbStEc3ZQRlZlbGhU?=
 =?utf-8?B?S3NRdjJtVDJxV3o4WlAyemhSZ3phQXhmVmp6WnNZQzN6WU1jUlJ5ZXIxN0RV?=
 =?utf-8?B?MGpnQnJEdk8wYzNYalpBc1Urc0dJc2NOcnNUQWxZYzhUemlLRURibXEvaFZz?=
 =?utf-8?B?SHFQNkRvK0YwTmNKL0IvUWZmZUhwZUNDaGhVUm1aM1NJb2F1UTkreGErSGtJ?=
 =?utf-8?B?Rkd5MmdOWkdjVmlYSmlqS2VyMndrUGwzMXhtZGd6aWdPZm5hWVRwMkFTSFdy?=
 =?utf-8?B?ZXhFT0pvMHJyRklCOG1kQndjV1ZEWitHTndpcHBORzdCcTRKYjJnVWpCUWJi?=
 =?utf-8?Q?Wf7YVwRiZUVYbwT4++?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f151d15d-bfbc-4dd5-8f78-08de4ef24323
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 20:12:35.0402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iEoV5JLtOVfQPhJE1ZouhSdT54ZT4YG6evfy7kzEJHFox/4J5HH5fDDThiQqgoi7rSzvpyXTjsweF2xN2gW01A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9534

On 1/8/26 09:29, Ella Ma wrote:
> Annotating a local pointer variable, which will be assigned with the
> kmalloc-family functions, with the `__cleanup(kfree)` attribute will
> make the address of the local variable, rather than the address returned
> by kmalloc, passed to kfree directly and lead to a crash due to invalid
> deallocation of stack address. According to other places in the repo,
> the correct usage should be `__free(kfree)`. The code coincidentally
> compiled because the parameter type `void *` of kfree is compatible with
> the desired type `struct { ... } **`.
> 
> Fixes: a71475582ada ("crypto: ccp - reduce stack usage in ccp_run_aes_gcm_cmd")
> Signed-off-by: Ella Ma <alansnape3058@gmail.com>

As was pointed out by Markus, subject should be "crypto: ccp - Fix a ... "

Otherwise,

Acked-by: Tom Lendacky <thomas.lendacky@gmail.com>

> ---
> 
> I don't have the machine to actually test the changed place. So I tried
> locally with a simple test module. The crash happens right when the
> module is being loaded.
> 
> ```C
> #include <linux/init.h>
> #include <linux/module.h>
> MODULE_LICENSE("GPL");
> static int __init custom_init(void) {
>   printk(KERN_INFO "Crash reproduce for drivers/crypto/ccp/ccp-ops.c");
>   int *p __cleanup(kfree) = kzalloc(sizeof(int), GFP_KERNEL);
>   *p = 42;
>   return 0;
> }
> static void __exit custom_exit(void) {}
> module_init(custom_init);
> module_exit(custom_exit);
> ```
> 
> BESIDES, scripts/checkpatch.pl reports a coding style issue originally
> existing in the code, `sizeof *wa`, I fixed this together in this patch.
> 
>  drivers/crypto/ccp/ccp-ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index d78865d9d5f0..f80a92006666 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -642,7 +642,7 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  		struct ccp_data dst;
>  		struct ccp_data aad;
>  		struct ccp_op op;
> -	} *wa __cleanup(kfree) = kzalloc(sizeof *wa, GFP_KERNEL);
> +	} *wa __free(kfree) = kzalloc(sizeof(*wa), GFP_KERNEL);
>  	unsigned int dm_offset;
>  	unsigned int authsize;
>  	unsigned int jobid;

