Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010010.outbound.protection.outlook.com [52.101.61.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D191EF0B0;
	Sun, 18 Jan 2026 15:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768750284; cv=fail; b=KK9HeLBMTU9BBorERFuscgOhtbUiO/QVlJop3iX9QTOWkH5MG+elFbdTuGn3bPIu0hTnp01gIjkR5UrkiDXIsVOFCYQNLxpEw5wIH8I3z/yCzs5d2Rqf2xX8BgF9SSeFpM6l+QxpP66HKlSAICySlYFTdFR8tW9cCLihEq0rFDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768750284; c=relaxed/simple;
	bh=R81Gf4q+pfQ5QWKW+4Qe2tKqatfIisKTrGR9kwyQArw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qxQw2FnzeCg6QufcKg3tlS8kV0Vy/OPE0ZvwbnkSuJ3qAC8VUF+Kf0Xb09jpxqAzuq9Qp6hIO4AN3h6/zi/EOjYvemow9UFiTAkrjIU01mKF0bflWDwldSNfFaBkZE9NtFD0PY9KVyh4suNImnqDbuzogJJs0S+J33l4buw/Y2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0F0NfW0+; arc=fail smtp.client-ip=52.101.61.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0F0NfW0+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u+CQ4VJW8/Z25CJrwJ63E5/SDZT03HrrDWNUwNDOIbFjAQ/16EVSgJjeR75Vnq+tb9vaNb2QTQBGk4HjN/Kcm7Ro+ayFZycdx3/JQAU8SY83QdhRA5e0+XN4QHXTh1N5VRThRv+i2sFiRXMyTD9XGx3zbr/lJM9bwWT03lpN8lJcbhNSBXhDtCce6TpdxhfRQtPOtn/wfZ99CXzeD3c6csohEA1f3YyWaUtIymwg0aTTcce+g/9uVr64XjkTnVB0mNGfSFKgVq+LYNMYFziG684Zo6Dq0yHXovmR1fGRIn1SEzXs0prPB0WDDLcxtvCcJ5kq7wtLwoqlatSF0hBBoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a1UW4Xr/hA8PfATQua/Nq31pIMTnk1dd0aIbigasgos=;
 b=hBime4eLlWU5GYsBOsMCcetbkSdnRLiJlPeqrAb6WzBiwUpuRpLiHVhGVwMN5lM4V4/TnxmhXXi4kTezzvJC+6mqUvWcqMR64WYRFWBskVf5xG8+od4mPbUHldIKf53XrrM2Pent47Yj0snGLfCeWHb7lrsaSvkkMSCsNZIBUXojQOzB2M95t8rTHWIgk6oZbLDQ9HObEgAW3ndIfq07pmsXCQzZwamdTGqpiKfAlaInNr4Sya4rgjKIcKy1cS1HxWtkS9w9hfb6uaFDWp5Xb3G+gGIRh1DfsLpLxsIAMT/bv9AwgvHeLgbH19fvOL6PlmbI8kVM/O8TpaxegQaT1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1UW4Xr/hA8PfATQua/Nq31pIMTnk1dd0aIbigasgos=;
 b=0F0NfW0+mjjKw8gndZA8P1Vftxrou0z2ylls/x9cm7G3I9Qp/zPXdg5XvbPBCta6SqouYsiY99+u7oPCS6UFKoNmoKberIBoVEgxZnKXDjwfF3+BNPRnlZkkSp8T8KwpVZf+a6uZ8eUvYZl6ibIT143g0QKPLndRz5pRud2vVrk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by DM4PR12MB5964.namprd12.prod.outlook.com (2603:10b6:8:6b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.11; Sun, 18 Jan 2026 15:31:20 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::91cb:8f10:c6d2:d683]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::91cb:8f10:c6d2:d683%5]) with mapi id 15.20.9520.009; Sun, 18 Jan 2026
 15:31:20 +0000
Message-ID: <550acaab-6007-4972-ad83-df6c0d51f6d7@amd.com>
Date: Sun, 18 Jan 2026 21:01:12 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/5] crypto: ccp - Add an S4 restore flow
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
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
 <20260116041132.153674-4-superm1@kernel.org>
Content-Language: en-US
From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
In-Reply-To: <20260116041132.153674-4-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0066.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:267::7) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_|DM4PR12MB5964:EE_
X-MS-Office365-Filtering-Correlation-Id: 5eb377bf-b77a-49e8-e2d6-08de56a6a15a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0M4Wmdmb2ZvYjZwUXpIZ3pCNE1PcktwTGJVRCs0ZDNLVExVaFBDeDZOK2FG?=
 =?utf-8?B?TktNUlRTTHBuUkowckpLOUZSQkxOUFJPTDJYSkFzWWxpRzJMY1hzWE5rU1R4?=
 =?utf-8?B?OFF3NThBbVJCRWhBL1RvdDltY202K1V4L3F1cjVkQlFqSGJmVjRLYjVXTWdq?=
 =?utf-8?B?OWxGZW8xZmFld0FDRjA5Vmx6dkI4UkxCc1J4RnF3SUE2SC9UUm9Od1Q1a3Nu?=
 =?utf-8?B?QTlpQTYxOFJKaGM4L1BGcTVVYjV4YXpmV2hyQmVpNkIyaVBsRzFMUmU0RVdK?=
 =?utf-8?B?MTRWT0FlcyswejF3TEp5aURjbm5RVy9ZQWQwZHdRTEFKeVEvS1hIWE5rN2E3?=
 =?utf-8?B?bUFjMnI0K2xGN0cvZmZJTCtwVUUyYXY1ODVVdFJZZUIvcWhSVEE0bzVyc25F?=
 =?utf-8?B?L3F0OHZQVDdQcEFXUWQzRXlkSVZ3NEpwS2ZJSmxHOVM3cFVybmwxa0F2VVFO?=
 =?utf-8?B?ZHYzVmlkeXVKZS9CVVpoUjBidk02TWVMVXFNd3N3MXp4dGo0V3FZSVhuV21R?=
 =?utf-8?B?SExtMzUxUGpSR3hTeERFbGsyeWlheGpUU1dkdE90S3RJdU9ScXFKQU5XQ1ZL?=
 =?utf-8?B?SjYvMmFyclhmRC9aRlFnb0RUZ2ZJRjdka2lsQnltVk95NE03ck1ZWDF5eDhH?=
 =?utf-8?B?aHlmOHdTMTBsazRvQTRiV1BoSy9ZczdVcW5XY25jSGk1UlY3VisvRkhmOVIr?=
 =?utf-8?B?aXBRalBpUVNNZ2dlSDNSbnh2UG9WUGkwY0IrSFBxbVRpSVQzNVAxT09WWGJq?=
 =?utf-8?B?VzQ5d3owcGV1NEpWMkJEOW43Ulh6Kzk0djJZQktFc0t0RVYrVENqOVhjWHBY?=
 =?utf-8?B?Y0lPWlZBZzJIZ0doOHhxVmhaVWhDZGtlNE1pNnF2WE4ybTBSZzJLM0l5czVh?=
 =?utf-8?B?c0NlOWR4Tk11VmMxcEo1RzBaT0J1NUN5RDRZVVpZRlN4YjlYU1VocG1wVTlM?=
 =?utf-8?B?b0NaZkdnRWlHZisxajFnTFEyemRrbCt2SytiY3pyaXFHd20zbFB1MkF4SU54?=
 =?utf-8?B?VnJOek1Hd3F5UFRseGRXLzEvSGNuMis2d1pyUGNRdEh6azR3U1Y3MWMwdVh4?=
 =?utf-8?B?ZndrdTMxYm1raVBkY0tCM09qSXZiMitnWFZLV20yNHVqb05LVzhNNkFsTlZF?=
 =?utf-8?B?Z0pkUGFhSXZSMm5NbzNmcDRveUN4cGd2UXZwem5wcm1weUVmemZwUStEY0FH?=
 =?utf-8?B?di9sbm1XNnlLMGtUN2tGeEdYVDZuRFdCY3pzcDJVbDBDUkhhbUVHY2E0aEEy?=
 =?utf-8?B?NWtxMU5SbnBkL0dObUhvYlF1R0QxMFdzZkZ4OW5sZUtUZkhIc1pYTkI4bnky?=
 =?utf-8?B?UFAvVWJIN1JsZzdxNFIrbkdLVW8vd2U4VitUd0wwSVdqNmVHbG8rZjhOQ0Ru?=
 =?utf-8?B?NGZWdWJRRkpjWGt0bXdiTFB1eFBpQk9MNDgzU3JyTFo1aGJaTTlpNkp6ai9U?=
 =?utf-8?B?UWhTWDBjaGZQNlJzVkNtUlphQjE5c0puZnBTMUpjWUxIekRPMlhPaGZWQlJR?=
 =?utf-8?B?TEJpWmN5RFZpckQyVWxTWXZYNGxCS0lGM2NyZml2Qk5GTEpheEZEOC9PRUFW?=
 =?utf-8?B?L29YU3ZNdDBxU2MveXJlVGlmSU9YZXNVUVNnRk9lbnNlRG82eTRoMVVlVXNu?=
 =?utf-8?B?aktGUGpJUnBJK0srY3lNd28wdFdTNlgvL2FaOFJoMmkrM1NWU3dWYURsQktz?=
 =?utf-8?B?eDlHc01FaCtpbkc2cFUyVVVjWG1YdkgwMmdQblRSc2pmcUZSZ3FLVWhXWW1B?=
 =?utf-8?B?ZE1ld0s2cERURXJHd0c4bTQrRmpmYlVhSVUxVFJ1NnBwU1NybGx5YmIyajB1?=
 =?utf-8?B?anZhTmtLb2dnakhBMGFNM2VHNy85TlRudzkwT2ZWNzNsN25CY1prVndadUgx?=
 =?utf-8?B?SDBZT3lNbisxblNNcFp1OTNyb0lkTFlnZzJQa29WVlNVTVJSRmFlMFBxY09H?=
 =?utf-8?B?VWtqc3BRL3ZSVTdFNCtqaHhtVzRka01YcjZneEdGT1NWVCtvS3ovSjVDR3ZL?=
 =?utf-8?B?Q0NPZ3ZGVk9vVUdKR1BjQUx5RE1ZcWxMemlCd2N1Z2RIQ1dVSWsvS3dDRDli?=
 =?utf-8?B?WTY1RTZ2ZnYwTGlzaVMvdldWSXNrTzF0RjUyMG9mVlhYeTdMS1RCUmd0Nysw?=
 =?utf-8?Q?8TdQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejMrUEJ1cGFZd2U3Y0h4cEk5WmFVOTcwSlVZeDgxUHRFS2orSUptR0pPK2ZP?=
 =?utf-8?B?RDB3Mmd1VlhFVkFnTWcyYnBVRTJnYmFrcXp6SU16MlcxZjFMbzFIaXJYUmp1?=
 =?utf-8?B?TCtyaFUyZGVJdFh2dWtXdFdtTCttTkNDRUZWdE5MOGJzL0NEb1pKUE9LY24w?=
 =?utf-8?B?R25BdERvb253UlZuZGQyWEVhWGFkOWF2alU3V3ZzY0dIMWppSzRHbG9nZXdQ?=
 =?utf-8?B?aHdMYXhBTjV4RTR2dFpJYXI5WEFNUnR5UUpOVVJxdkRRNldrQjg4SzF0aGFI?=
 =?utf-8?B?Vm04VmE4cVV5T3R3YmVkSkdmVFNFcFlERFEwOW9tZzIxZWkrVklhSVBsTjRI?=
 =?utf-8?B?OER1aWZyeTB1eW9oc0lQMEpybUFTZUdoOGE2QnFpcnR5MC9CMldYMFoweitN?=
 =?utf-8?B?N2JlV05oL1doMzZsZWxVVGNaUmdsVlFmRDFJSm5BektJZTByd3FjM252SEpF?=
 =?utf-8?B?RlN2VkJyN3IxUnVKbkFCZHVFRG1lUzY5TTZNQWpPOTdFY0U5aXc1ZHljSm83?=
 =?utf-8?B?dGJLdHBjWFJhbWtQZ0tXVERPN3lXTXdvQTA0NWxkMHEzbENGVDJXTGllL3BJ?=
 =?utf-8?B?WXVpZXkwQ2krSW9BSGpwd3R0cXl5WWhUbStFQUErNHRhdHpMd0g0dG1zVkd5?=
 =?utf-8?B?RWN2QU93VGFGNXdDM0hiVFRqWFhRcVN6cm81UzQ1clk1RDJXalloTTZvUWN6?=
 =?utf-8?B?Y0grQUZmd1NGNEY5Y1pMRUkvVi9Nem9CSXpXTE1qYTJGZnd5ZzdmYkRSNlh4?=
 =?utf-8?B?ZEFzVE1ocWVqZmQ5TUJQZ043ZkVHUTZyYm5YZHhuM1QyVWMvdzVmb1JXQjYv?=
 =?utf-8?B?QS9MSzZUTWJLK2FFcUpqdlFWcUVVVk41NlQ5TzZrdHBhekhoMktraVBqRGEx?=
 =?utf-8?B?ZnVscDRhaHZoN3I0OVBpc0d2eVJEbUtnUURYd2plVVNSNUhEN3QwdllTT0Zk?=
 =?utf-8?B?VUlGblF4eDVtWDNKbTEweUhET2xWYnVIM2dTZGFSMEp5ajlxT1p3RGZQR0dL?=
 =?utf-8?B?VzB4dVBqcnRxZDM0c2hlN2tranVDRzZKSFJsWFlvWVlNb3d0aDlLVVNDVmZ5?=
 =?utf-8?B?dzNBdDVRajUwM0ZZWGNQQkhVSU5FeEJwck9Hb0txWngxZFVHRkVyTG1hMWVI?=
 =?utf-8?B?WUgrTFBtRW5nbjZ3SHVoNUEwUlVHbjNYTzlvRU9TbkdDY29OVkxmWlJJY0hM?=
 =?utf-8?B?NHlqa1hYVEh0VFNkSEV6d2ljSFJENVovaXJlQ3E0L2ZlT2lxOFFkWnNWeFVT?=
 =?utf-8?B?ellHMDdHWXEwWVdvb3U0ZTJFM1B5Ky93c2ZwTnhaU0lxc2ZuRDV2amYyd3Rh?=
 =?utf-8?B?cFhmNU13RmNBS1R5anE0WHJRWE1aWlJ3OElHSit4a2NYazF6dUNzTEhzdDF0?=
 =?utf-8?B?cVlLckpVMjRaL3lkN0xnTXBIMjhQRm9mSUFtandLR3NJYVVlWkY3blBRT2VG?=
 =?utf-8?B?OVdaVE1ia1BaQVRZRWY2dFEzaDQrbDBURnlWS0N5cUx3TjM0UjFYUUxGN2F0?=
 =?utf-8?B?d2NGbUUrMGx0M3Y1U2Q2ZW93U3YrcitpMDBESWozOVNXZ1FMM2JVemw0UDNS?=
 =?utf-8?B?dlpjdS9IMkNRZlowczgrbFdDS0h5dEVpUUlMNGx4YjRCeU1NaEN3cEhwb2M1?=
 =?utf-8?B?SFhvaGxUK3FFdGw0REFEWmgzSldpaUdWM1JLU09WcmhHcnlUU0ZCZDJNakpl?=
 =?utf-8?B?eFF6aEZTS0hVeFdLRnBnWDM5T25JaDEwM0orcUZVVGtmMTh0RTVYZFN4Lzgw?=
 =?utf-8?B?d21rNy93dVJib1c5d0F0Q1ZpNnh6bytrTzhHZVJyY3hFSnFEUWJrTm9pRC9x?=
 =?utf-8?B?UzlkNFFXU1pIcHc4VGRPWGMwR1RLWUxuWHc5QUVjMWhKT1VpV1F2S3E3cHhC?=
 =?utf-8?B?YjdyUmJqejcyRmRlTWhnSFg4ektOR0wybGRuRU54Yy9MbHBxOE9jbXBWQXlU?=
 =?utf-8?B?anQ0TFYyU1psakM0S09LT3Z3d2tyblVNSXZEVEJIZGxPNU9hejV1WWtwa2I5?=
 =?utf-8?B?emd4ZmtMMzdwN040UURNdm5VR2llZjJpVkUxOTUzaVljNVk5QXBSRFJvcmNn?=
 =?utf-8?B?TWhqWlJSUUZIVngyMTltWWdrb1FPNEJabXExQUg1NEwxemw5T0IvTTZOVlZH?=
 =?utf-8?B?MVRRTU15WWNYanNhekMyYmNXcWh4enk5Q0ZXWERxYWsydHIxZzRhWjhXQXNS?=
 =?utf-8?B?RzJXZVEzR3RDdit2alM2MktWcENXQ1VKZnJSVEFqKzYwWFlzdEd2OGU2M0l4?=
 =?utf-8?B?Nm1pU0JBVlZjZFR2a3p5VjJwV1FFSnlsakRlRlFtZW1VVnNPMnNVMXpLbHp5?=
 =?utf-8?B?VkNVVzEwRzJmOWRSY2NxeEdXeWliclBMSXlXUWYxREs4QUxYWnI1UT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eb377bf-b77a-49e8-e2d6-08de56a6a15a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 15:31:20.5904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yZHNJuTxC4/YAmF+OjbdE5fT6U6ivxtoxwXH4wA29VpcLxNGLbMl0YG0CfArjinfp60fHrIYsqfa6fpaTT4zlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5964



On 1/16/2026 09:41, Mario Limonciello (AMD) wrote:
> The system will have lost power during S4.  The ring used for TEE
> communications needs to be initialized before use.
> 
> Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
> Reported-by: Lars Francke <lars.francke@gmail.com>
> Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
> Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>

Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

Thanks,
Shyam

> ---
> v6:
>  * Add sp_restore() flow (Tom)
>  * Drop CONFIG_CRYPTO_DEV_SP_PSP conditional behavior
> v5:
>  * Fix return for psp_restore() (LKP robot, Shyam)
> v4:
>  * Add tag (Yijun)
>  * Remove blank line (Ilpo)
>  * Adjust whitespace in psp_restore() (Ilpo)
> ---
>  drivers/crypto/ccp/psp-dev.c | 11 +++++++++++
>  drivers/crypto/ccp/sp-dev.c  | 12 ++++++++++++
>  drivers/crypto/ccp/sp-dev.h  |  3 +++
>  drivers/crypto/ccp/sp-pci.c  | 16 +++++++++++++++-
>  drivers/crypto/ccp/tee-dev.c |  5 +++++
>  drivers/crypto/ccp/tee-dev.h |  1 +
>  6 files changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 9e21da0e298ad..5c7f7e02a7d8a 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -351,6 +351,17 @@ struct psp_device *psp_get_master_device(void)
>  	return sp ? sp->psp_data : NULL;
>  }
>  
> +int psp_restore(struct sp_device *sp)
> +{
> +	struct psp_device *psp = sp->psp_data;
> +	int ret = 0;
> +
> +	if (psp->tee_data)
> +		ret = tee_restore(psp);
> +
> +	return ret;
> +}
> +
>  void psp_pci_init(void)
>  {
>  	psp_master = psp_get_master_device();
> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
> index 3467f6db4f505..f204aa5df96e2 100644
> --- a/drivers/crypto/ccp/sp-dev.c
> +++ b/drivers/crypto/ccp/sp-dev.c
> @@ -230,6 +230,18 @@ int sp_resume(struct sp_device *sp)
>  	return 0;
>  }
>  
> +int sp_restore(struct sp_device *sp)
> +{
> +	if (sp->psp_data) {
> +		int ret = psp_restore(sp);
> +
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return sp_resume(sp);
> +}
> +
>  struct sp_device *sp_get_psp_master_device(void)
>  {
>  	struct sp_device *i, *ret = NULL;
> diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
> index 1335a83fe052e..a83751cfd0060 100644
> --- a/drivers/crypto/ccp/sp-dev.h
> +++ b/drivers/crypto/ccp/sp-dev.h
> @@ -141,6 +141,7 @@ void sp_destroy(struct sp_device *sp);
>  
>  int sp_suspend(struct sp_device *sp);
>  int sp_resume(struct sp_device *sp);
> +int sp_restore(struct sp_device *sp);
>  int sp_request_ccp_irq(struct sp_device *sp, irq_handler_t handler,
>  		       const char *name, void *data);
>  void sp_free_ccp_irq(struct sp_device *sp, void *data);
> @@ -174,6 +175,7 @@ int psp_dev_init(struct sp_device *sp);
>  void psp_pci_init(void);
>  void psp_dev_destroy(struct sp_device *sp);
>  void psp_pci_exit(void);
> +int psp_restore(struct sp_device *sp);
>  
>  #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
> @@ -181,6 +183,7 @@ static inline int psp_dev_init(struct sp_device *sp) { return 0; }
>  static inline void psp_pci_init(void) { }
>  static inline void psp_dev_destroy(struct sp_device *sp) { }
>  static inline void psp_pci_exit(void) { }
> +static inline int psp_restore(struct sp_device *sp) { return 0; }
>  
>  #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>  
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index 8891ceee1d7d0..6ac805d99ccb3 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -353,6 +353,13 @@ static int __maybe_unused sp_pci_resume(struct device *dev)
>  	return sp_resume(sp);
>  }
>  
> +static int __maybe_unused sp_pci_restore(struct device *dev)
> +{
> +	struct sp_device *sp = dev_get_drvdata(dev);
> +
> +	return sp_restore(sp);
> +}
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  static const struct sev_vdata sevv1 = {
>  	.cmdresp_reg		= 0x10580,	/* C2PMSG_32 */
> @@ -563,7 +570,14 @@ static const struct pci_device_id sp_pci_table[] = {
>  };
>  MODULE_DEVICE_TABLE(pci, sp_pci_table);
>  
> -static SIMPLE_DEV_PM_OPS(sp_pci_pm_ops, sp_pci_suspend, sp_pci_resume);
> +static const struct dev_pm_ops sp_pci_pm_ops = {
> +	.suspend = pm_sleep_ptr(sp_pci_suspend),
> +	.resume = pm_sleep_ptr(sp_pci_resume),
> +	.freeze = pm_sleep_ptr(sp_pci_suspend),
> +	.thaw = pm_sleep_ptr(sp_pci_resume),
> +	.poweroff = pm_sleep_ptr(sp_pci_suspend),
> +	.restore_early = pm_sleep_ptr(sp_pci_restore),
> +};
>  
>  static struct pci_driver sp_pci_driver = {
>  	.name = "ccp",
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index af881daa5855b..11c4b05e2f3a2 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -366,3 +366,8 @@ int psp_check_tee_status(void)
>  	return 0;
>  }
>  EXPORT_SYMBOL(psp_check_tee_status);
> +
> +int tee_restore(struct psp_device *psp)
> +{
> +	return tee_init_ring(psp->tee_data);
> +}
> diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
> index ea9a2b7c05f57..c23416cb7bb37 100644
> --- a/drivers/crypto/ccp/tee-dev.h
> +++ b/drivers/crypto/ccp/tee-dev.h
> @@ -111,5 +111,6 @@ struct tee_ring_cmd {
>  
>  int tee_dev_init(struct psp_device *psp);
>  void tee_dev_destroy(struct psp_device *psp);
> +int tee_restore(struct psp_device *psp);
>  
>  #endif /* __TEE_DEV_H__ */

