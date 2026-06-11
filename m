Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012047.outbound.protection.outlook.com [52.101.53.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012A73F20EE;
	Thu, 11 Jun 2026 13:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781185478; cv=fail; b=MnhAfMSZypW8G8gProk6gM4rHtnvqVk4zGQRm56z3FmoLta47SIIEuqLyPI5Q6cwCu0LvQQ6mXiFqjc0KRkH8cXGfiAye5WQ1qIG9yEpJuRpcitlvi++LxA1nG7lXSoSfqxs1/3aTs0emUz77O+RkW/7TEWHNr2gblnk6VSfl9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781185478; c=relaxed/simple;
	bh=tgDk1TAq8LvoUj2xxNiJtM9+2Cd1UyoBn2w3Szh6thc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l9Wc/Gek9+2jGeO2jc8nuj6h52DQx2yHtELZx/r7L1JFRsBXKcveJgApQKS0aftIU7DK47nxt9rM7BGM3pvWdyvwFf8CO7SFwcWmp3ZPG7Z9eIBpg5nsIlRwj5+Oup2PtdAEosXH/h9DyzEFoKS9RljofOSbCQ0szO4sCMuHvHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zCyxkXBb; arc=fail smtp.client-ip=52.101.53.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zCyxkXBb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LdkKfJPo+93t2QaX5BjRCb5ygkdOapz6Uu8HFPkSp7iKSNILIPBXrxyaSgIM/azSo++aETz3BS7fUjmEZ0Hr1IPNtlWYapir3ryZun97gwx3Yq8aJ3foex1Cj7j4k6jFx74clnd9NL62spBhCX8l9NgdoE+v1EmDqbH23OqRdKTwjhcexJMPumjBp6BZJ9MCCSxDl+AmBK/zhhx2/EgwlRqLrb9UvgBYKlcRyTazDSI0CYl/xPECoN1RYrVtsiOEuzLZegF8z3lSKGPKhKAOyKFDwVh9rJqmj2pfF159nsBAdKlnUONqmTtyuLXtRYtGGqhUm0S1jLNWqM0T2H4L+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9vkhD/Ibaazy5RM93ucamsssD42k5siAuRxXrRNLzWc=;
 b=evTNGoL8DdM7La9o7LIg7K0IPZwUThQljUSYWC8MWuLEWMukihGAz6VBRscU8cZzfEFxTRv514FhoatGiVd+C4FEvL4XM92ZAFb/M0sgwKNu82sxFpCT2noplebNe+HbdNyMHMQ3KJXIVkBeekeBVRJYn3vWqGmblP6bxpJn5Vmfy3E4X9XhcPl5KXJjb2UHtJ37y8KVrFAd4iYFfoP+obdGY0P2BTjeUSfKYAOIgJ6wpECnSUcZ4LVEedwmxXxnU29246ExyakYr8KM2OdcHtcuXEgZY/tp9FL9RPjgMudurSk5AcCMe5pREauKdtnMBcjLhhFAjidhRJAPEDowVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9vkhD/Ibaazy5RM93ucamsssD42k5siAuRxXrRNLzWc=;
 b=zCyxkXBbQKGKTB1xtAkYF6nGKVfuRLi+x/DXzdw2UGV/2LPtx4PQyfNWrXEhweSlAp/I9AWbo7u085g0XOOvoNO1aqC5byK1hZEWixcJyjOulFta7h7iVo0amCjC0jPd0Hxv2qMpQTgfWvfLyJjfol7uf9rd30/zPdIzowh1B3o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by MN0PR12MB5908.namprd12.prod.outlook.com (2603:10b6:208:37c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.18; Thu, 11 Jun
 2026 13:44:33 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3%5]) with mapi id 15.21.0092.017; Thu, 11 Jun 2026
 13:44:33 +0000
Message-ID: <d0f6d93a-6c07-4b33-bc89-a498d7d2c34f@amd.com>
Date: Thu, 11 Jun 2026 09:44:30 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
To: Tycho Andersen <tycho@kernel.org>
Cc: ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, aik@amd.com,
 nikunj@amd.com, michael.roth@amd.com
References: <4957b07dbb4029a4c59bb3cf35f068c36284aa48.1780693665.git.prsampat@amd.com>
 <aihsp-uQrd2g5vJ0@tycho.pizza>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <aihsp-uQrd2g5vJ0@tycho.pizza>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P220CA0005.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::8) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|MN0PR12MB5908:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e962861-6395-4967-de6e-08dec7bf91dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/PCFJnR88iWc4lQctRcXL2Dc+6qmKo56EwRIDX+F0IfAuoX+x2fQA9fCGRpboxQlPeoyTTtwVyFwNSdG3gGyYxYhTsqrjQkWL4dTivx0x3H+0LvX1IoqPezur9Z1KXoqvTDpeBO4EwLze1DrRp+4/Mim4sruqSg8l51IAaT9wJbSqKX1+cb8prO7ziFWu99DXSSgmYsVk9CSqnNbAmcWO7MegJtdc7YnyN0kxoKSSjrMOLOAr/w7+ISUWTu0DY69kf+zGC+x1IAInwTlN2PtfZs1x0FIOhZsZLK8kCaKGtNekHKbXCi1ZCI/M8K00hi80bxOrgMQokFpe7bvKDBozRl4Ca7cMzH4nA416epScR+OpKq5hGrbOcA3tQh9kHUBEWvc5O7z7gd0RXyZyeWBYaPBP1k6g16t89wkigWtxUjCMR7nYYMIqNu6StQbV/VEsp4F2MLbH9QICFalvGn7nd3IPVikEqXtmK4+Q6dhZWuObm6UetL8JWB6fNlfW5W+79CxICyJOH0Dn6llHRcTZ+G17c5BdALWKtNH1kHxr1/1PqiypLEEULhvTYJxDerjgoF5p2MJqeMIffNkNlO+OGBZsUCVyeQvPueTmo39IsU4Ubry1z3I54fi4TZsjFnnSgYAYtCCxtfwei4STOHMy7jzxtDD5muKk6ICqJ8oUxMuWbg8/hdEfJQmE1dS8DCp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGdvbFgwaG45MDdtRXV6a2Y5dVJUNUxDQm1rR1Fma3l1QVFHTlBlbWN4MnBm?=
 =?utf-8?B?SVVjSDh1R3RjV3Z2TGJBY0JCZzkxaEZBc0ZhTFp1NkF0aTFoWndJcnhPNnFE?=
 =?utf-8?B?dE1tUXdtWEtGOThCTXkvcXVndVFRTm4yOURLZXZuVXVFV1orTDczN2VkeVlC?=
 =?utf-8?B?WXF6Q3k2M0ZTelNvSldrZ0dXWnlUMmFFYXZHRk45OEkxN0dEQlpLcGVxK1cy?=
 =?utf-8?B?bXcvSm4wejN5WjRueFd3V3JRY0p6WjZ4THVMVEdzc2RPM3hVc2d2QXY0em1X?=
 =?utf-8?B?dHIwRDBvbzU3MzY0bTA1bXFlSVk2bnkvOFhxQTR0b0JyN0lpb2RqYzF4NCtZ?=
 =?utf-8?B?OWtyVTkwbTdHdEtCU3VzSWZvcHMzM2RUMjZEbGJ2Z3AxN1RkandDeHpKL3pv?=
 =?utf-8?B?U3Jrb0o0UmRib0JjY2haSzNsblJTT0RjSjhJMmtwUCtVWXNnWnVWOFpEdUxJ?=
 =?utf-8?B?QlFGY3Q0TGVIOVA3Z1hkRm45UGRDN2Nla1RQN3JxQVlIbzRMY09yOEZ4MUlh?=
 =?utf-8?B?bkljRktSZGt1Wjl3RSt0RHUwbkpQUURTVUQ5Z2h5TzRhbzV2RVVyZDRhQlRM?=
 =?utf-8?B?SE5McmgrcVRvelcvakt1YkVKQW40c3AvdkUzVjF0Tzg4dWlSWU5iNm56anEz?=
 =?utf-8?B?NEpvdXNuRlptZ1M0aHphZ1JyUWZhWGFjTEU1OTl1bDl3aTBZamcwL3RtTGVw?=
 =?utf-8?B?ZjR6RlNTdGxmQmdUT09neHFCMURJMTBYQnhYaEtVZStFT2FIYzJEV2tFd3Va?=
 =?utf-8?B?Q0U2aDNDNDBmQ2pOY09GbkN1dWdiak1hZHBMRFJKQko0dVBNTDllV2tjR2dM?=
 =?utf-8?B?NXdIVjFzbURpMzhLSE82di9XNVBmT2oyUVFzSHNyN00vSUcyOVlEczkzb2x2?=
 =?utf-8?B?c0ZpM25wME1TaGpNUCtSMWE0SW9STm9JK05rTGN6OElGMHc3a1VQR2pXNjA3?=
 =?utf-8?B?MW95TFU0ZjdmUTE4cDR1bEhEVlRYZ3FzOEpCbWV6cmdYQVlIM2NOdDh0TjR3?=
 =?utf-8?B?NGZiYlpBQ2JWMkF0TXpCc2VqZUU4ZUV1MnMya2tJRzRBakplVzlNRVExU3Bu?=
 =?utf-8?B?VHRCbTB3U0dBL1ZieFFIbTIzcHJoSWRhd1d6ZGpzNFBjQUoxUEJGdDNvLzhH?=
 =?utf-8?B?RXEveVB6dnFFNzZheEFBdnVyTk5lQU1OVFVmSThya0dMOW83SG9PMHVKR2Q1?=
 =?utf-8?B?R1JBQWJYbmthOXlFNlJ6ZnlNdExxK1Z0ck9CYm9vaHNxVmwxekJvcnRxRUFT?=
 =?utf-8?B?K29WazVVUk1hWktpUzhXZWx4aUhmQXBsRG51My9kOFlOS2IwaGthUTlESVVD?=
 =?utf-8?B?Q0hESis2dFBFRTlyMC9YUm4rUGE0MHN6KzBLaVhHMFRxRlRrejhSUC85T0N4?=
 =?utf-8?B?K2c4d1NRSTNIVEZrVE93cXdFYVlzWUtXQ090LzNFRU9uc1BVQTNVNGlQT0VX?=
 =?utf-8?B?VDhtc3BHbHQvY1Y5WFpXVmdQUzU0SVJjRzg1MEwrM1hVaFpGZ3p4RGxMd3Ro?=
 =?utf-8?B?RDNMWk4vN0U1RGxWSFFOOE05T1pkMHE5QlVBWU5DRTFPODdibjVVTndqVm1U?=
 =?utf-8?B?b3hRRnlmdkRLRjh5QUZlc2k2TVFyL0JsWVByUWhnaG5SZUhReCs2dXNFSzk0?=
 =?utf-8?B?U2ZvcWNOYjZEcVEvMElpcklGT2d0N1JaaDBVYndiL01URUxYY0tIZWtrWkF2?=
 =?utf-8?B?ZkkyaE5hRTVyczFZTFgyOGx0aWJJa1lWZmNraHVsekh0amFkcTBSY0dsRzhW?=
 =?utf-8?B?bUg1ZUo2NUVEaFRGaVFmcEFreGNUYit4d2UvQ2ZMUUdVakJ2RVRZRDRLR3hu?=
 =?utf-8?B?TmRndlVsZWZZVFovMGFLVFQ1ZDVuS2hOYUkvWFg1TkxrNkpEbU9STjdybE1m?=
 =?utf-8?B?alJmYWNkQURPVUp2a0NtSVYycDhhVVp5cm5NelllUlNtT3JGcjhGSlRXQWJj?=
 =?utf-8?B?RHlVdjNoS0o3SFdlNlhacTg1S25LakROVmFIUTg2OTJDVWxYYmg1eU81czN1?=
 =?utf-8?B?TXlXL3dHY2d6MVQ3SnY0eXJBaTNDNmNzQ0FEeVlsMjJMZVdLRWduREpzTHRD?=
 =?utf-8?B?VFpGNW9CbzZ2RWZqSlpCSllmTkFQS1QraEtoNExCMldQSGRlRXU0Y0hFOWZ1?=
 =?utf-8?B?Rm5jU0JBUCtWblpUa1VHUDhSaENkMnVpeDFXNWUzb0k2aWQ2a0JpeDI0dW5W?=
 =?utf-8?B?clRwclpvVjJDREpZWVl5NEJObFgwamlDNEpPMEVnTjZlbjlBUk16K2Q2NnR0?=
 =?utf-8?B?WVZ5cHMxUklSdVJ4UUJKNmRtZFlxdUxjY2Erd2JuVVIzT3hlTU1sWDJVeGVV?=
 =?utf-8?Q?vyaJ0WLV9LDYKkwyRf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e962861-6395-4967-de6e-08dec7bf91dc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 13:44:33.5332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oIGqRT2LuwdWsO5QvK39OupixpTrwMOE4TUSrFzBXwSELj0JEEjqNxTFQD84bDt9rHZybRUzUMQIzztwfP+BwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5908



On 6/9/26 3:48 PM, Tycho Andersen wrote:
> Hi Pratik,
> 
>>
>> See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
>> more details.
>>
>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> 
> Reviewed-by: Tycho Andersen (AMD) <tycho@kernel.org>
> 
>> +	if (dst.mit_failure_status) {
>> +		dev_err(sev->dev, "Verify Mitigation - failure status: 0x%x\n",
>> +			dst.mit_failure_status);
>> +		return -EIO;
> 
> Elsewhere the CCP uses EIO to represent a failure to communicate with
> the PSP, but here things worked, it was just in an invalid state.
> Maybe worth a different errno here, -EINVAL or so.
> 

-EIO is a bit awkward here for sure. -EINVAL seems to make more sense.

Thanks!
--Pratik
