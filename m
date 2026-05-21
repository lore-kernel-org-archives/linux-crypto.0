Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012054.outbound.protection.outlook.com [40.107.209.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B8919004A;
	Thu, 21 May 2026 02:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779329421; cv=fail; b=IqAa7mxaRe+QxY4hVpXJPvMdwWFvsCAiv+Wvf5t0qs2oQXe2iEL3leWzAk6uW6M/hxH4HPwv6f2UZp4vPsEYbyqTxfo/IgVcgLFHQcTXYCnW0AVz2DJC9DjQdSb7++kSTh15V7pOu7U4HK6/VyhyzRWqJ65wC7MCuqGRmMjjwbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779329421; c=relaxed/simple;
	bh=bRhNG+4UaVIG4uZcDE58P+gJARfyWLxmTczEOsJBNAQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i/+woQ5glGTwcVRN/i1YqcS0y6yVpuqhSzZ1r9QWZvzI4lhmNYzlGCoqjGEeI7RoJNe5UnQeVViRTEatvStRbR/BOu8mypvNwv2bWw4kd4iEUPzudsPW0SbgHiR1Sz//PzgQgwsfYPJWKd/y+DXUKks2SnrEaVKnylec8A1m+ho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Pws9kwwY; arc=fail smtp.client-ip=40.107.209.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Pws9kwwY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N5Qqj2y9PEvQ6e6uBsCUVOxGSPQ0iYSYH2J/IF7BtjqX1p0iKDjNDtCqgthpQtg899v3yjrQFzV+ag4jMEH+P2s78w3OPbDMgV9WKREN3wXFWJdsPJsoJAG3OvXnD3A8BL4EBk9O+ZyruwEePOa7i2xunK7P7c6ep/5iqk8gmUCWjxR6FaRsEH+iNPqL9IaIS6KlOAQd8sLthoNPgrRpriePT8TemrcPuE3g7cakQzjibcNH3Zi51YHEiP7h2MCq4noFgwnVZpJu3RbSRstXk3I4TVwCjhbe6XF4YQa197SZfc3qxfAZLHvwwWYaPRjI9ewaXwJ62WPqiChakITQjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jr3a2xTUno7qe8RZ++3pMFcwLao7WLhd3M0V+c42yBE=;
 b=a6VuqydolRF9S8zuYf9COd8e9Nh+2NlMsSuA2yzFMUcYDewSb+rrchPc0cc2kVjeBpafhjImfuAw+iZr91iK5XUZCNK+JcHTNfMdmypGesh1x/vYdh3qyjagJr9hQnLjPZN92fEddP6PhdduxGOtxzCKEw6G9F2Sbz8YdZdmeDVcfbbqkuJ3q4RjFZ0SKtYwr86SeVZbh2M8UzjF0R1qCKPdI2vf9Prc2KbD5t/BH8QDP8ulKOdbq0OzeUgycDdyx7WKwYV0dlbED926Qk49lI5jCJL1tNUymlyiAjqSzoG42y/sSrenS4i6yJLBWkwOqeE+ASVS99SDplDfr+TKdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jr3a2xTUno7qe8RZ++3pMFcwLao7WLhd3M0V+c42yBE=;
 b=Pws9kwwYma43BTUFfBtGPdaFyQllHOjd3DxkxN06jkdx6v2rrAixFJ83lcgZ2XrRYgW/QMR5D4BUvATD+DoMwtK2w3qklptoZNBYi1gl3E/PTniiW48kDgFWphSacJtYtuw7CCjw5YeS2u44KN00eB/cz2OJf5ordoJcgyrlrKc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by SN7PR12MB7299.namprd12.prod.outlook.com (2603:10b6:806:2af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 02:10:08 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3%6]) with mapi id 15.21.0025.023; Thu, 21 May 2026
 02:10:08 +0000
Message-ID: <4ccf6dc7-88e6-488c-8314-5bcd95164661@amd.com>
Date: Wed, 20 May 2026 22:10:04 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
To: Tom Lendacky <thomas.lendacky@amd.com>, ashish.kalra@amd.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, aik@amd.com,
 tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com
References: <36137b565d183fa2f2985ad098f2e2096f1c432f.1779219958.git.prsampat@amd.com>
 <6d5fd5eb-e54c-47fd-943a-6d03aaafe243@amd.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <6d5fd5eb-e54c-47fd-943a-6d03aaafe243@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0064.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::9) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|SN7PR12MB7299:EE_
X-MS-Office365-Filtering-Correlation-Id: e0207082-8705-4ed1-98fd-08deb6de146d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|22082099003|56012099003|18002099003|3023799007|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	5BxaQkPs76n8yBVm91U0TkLQZrDidg2sXrbAjWNVROoMkenpO5y6piC/4vjWpFHI7UmmnVwXJHtKC4aqLQiRd1qUGe+hPkC2oBpySslKe6PcKq0iBCzwh0KPTP/58rSVx35LK9E2jVn8gr/bmmDXWfO/QpBd+VBLCtheRItR88Okvj2NOqhQqf+6KNjbHmuSdpvbWJ0zqDJVlQRALMt5qXExN7NW1ZNkiofzTGsjnsiUoO+qqaQvLFNgT4obFebpPG/FiVA5A/FY5gwcP8NaSXnKfjh0y31REu5bXDUiIreBGPGvecXFjQSi72TJPDhIEBbfWMMd7P4IV4AkFxxc7UrLjosZl5irLXPCGBgB7S8bDORb0zCCuPnkSNMPyYEYEFZKxS4HqL6cVxWJXgse7KUFUfibEdFPW2pPgq5IgzP1tYsNKQ+yjpjQ1OxeD5TpO6dX3y06WiR3geT2d8LhQfjzzzfObNkSboilpdW9R4gkaUZjVJH+GR/Ta7mtfud0n1lwp1atSEnAlETBuMhPYtUs4wNWDGAm45HnHb7vki7HU6Exa4JEjokYMMYKnWd/ehihpy8z8k7+Wq+Pg7jCZiszBIiQKjJImafJ0Y54KGF6ZyeGwahGEwMfwp+svjdLp37pNBsBZg1325DbVdTqYwbDggy5tDikYgTTYb6CjK0iQVqBOcGYlEb9fkl3jv6u
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(22082099003)(56012099003)(18002099003)(3023799007)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzhZdCtmb2lyMERpZ2d5UDVxbmRzWUIrQk9zekUzcFM4MUd4Mzc3bXk5WVRy?=
 =?utf-8?B?ZjB2SkF0bzZoeS9ZZWg1TE5YT3dGMkdhZlRpRWI3ZU0xbldROVIxU3UwU2dv?=
 =?utf-8?B?a0lpU3pTR3VBSFc2R0NaZy90cEo2SEZvUnFKMUVMUk16RyswT2xvQnp2YlRH?=
 =?utf-8?B?MVFZdC94N1dJR1FwWDJ1cmk0QzNQallMcEdQaVAyd0VSK1BHV2loeldjY0Jq?=
 =?utf-8?B?RGZXMmpHVG9KdHllVzRzSXR6OHVhbTJaUmViWmtPMFd6SDRhYW5TWWF1SUd5?=
 =?utf-8?B?cjdQUkRjekJpNGk4TVZiRkNNb3AwTXFEeVpvcFIzV2FEWTFzS2ZydXhsWGRx?=
 =?utf-8?B?bEgvRUViMFJIMW4rdUJsdHV0aGF3VG81VmtxaThGbWVMeS9ZNzJvdVk4WGJG?=
 =?utf-8?B?MzlsUkZ4V0tQN3BBWlZiMWZYVXgyNGhLTnlHTCt4RHZaeDR3RGZGdUEvYTMr?=
 =?utf-8?B?TEhBSW9jQWxIV2UxU2g2TlgyTHh4U1VIcHdEZm1rOUVtN2hBQ3ZET3U3THdH?=
 =?utf-8?B?RXdmNE1lRm9QNlMwbTl0dzZIdGFZM1Q5SG84aUxiUVh5YWlsN3duQWphZ3pQ?=
 =?utf-8?B?Uithb2JmR1hFUzZTV1FlckdLYXVkOVI1M2RxZUY4SGVuejZ0eFhqSGVieElG?=
 =?utf-8?B?SkRjUnpTL3FCbnB4Wk5SN0ZEMzBSNGM5ZWIzVURLMFBpSGJzQkJhbmVKdnVz?=
 =?utf-8?B?NGJBZDlEcGYzL0pNdXI1SWNLclpzdzFaTk1qdC9nWmVsVDJ4UWJwaGFHbThK?=
 =?utf-8?B?OUhEbmU2amM5dFQ2d3BEODZySUNBOThVYytHbHZib0hobVRPTnl3bFNDTEth?=
 =?utf-8?B?NDFPSGFiL3J4L1BNN1lDN1o5SkRBOENPN09NUStGdU5pellJYngzdE43MmJk?=
 =?utf-8?B?WnZyemNKU0xJRldUMHNRYTBNak5Bd1N3QkI2dHFXbkRGZm5DMklCaHpnamNi?=
 =?utf-8?B?Y0lGa2drTDN6N2FqTktNWTNOK2xMLzErWU91UTFLZEdGSXZ6WmJqeUNENm9h?=
 =?utf-8?B?SVh6TEZ0b1lqTldsbkR5RDRyc2ppY1psV3AyQjZxZXRuaUdUdlF3TDM2UTZL?=
 =?utf-8?B?b0RUb1VSUDRuOUtnREZaUit3aC9JcHEyOFhyOTNRSVpKNEVzbkZvMW02NVRr?=
 =?utf-8?B?WTB6bm94R1Z3Z3pvSEQxazhhcFpyVTFwRThHSCtoMlZ3T3g3TjZOcHU5RmxW?=
 =?utf-8?B?T1VHT0VxdHNyalEvWFZjL0hmZUVXTTBpNHF1SkdCckZMdDEyRVZPRGQrZ3A4?=
 =?utf-8?B?bWdCbEtJNUVDOXlneE9oRzdZOElTaFUxOSsrRkZGRFFKNU9kL1FyY1pwU3dU?=
 =?utf-8?B?aEVITnF4MDlDcjhoZEtJVGxKU2xLYU1RMlFGcWVEMVhyTHM3VnpaQTk4ZEVM?=
 =?utf-8?B?WnR6c3FSRHhTT1ZGcENqR2VWRlZCWE5seDdiM2drVzBaQUVVdXRMYXlRdVZz?=
 =?utf-8?B?Y3hqRWpjOUhDbFduTGUzQk8wNjh5WGZyQWkybEwrdzZqRlRCU1VyYmR2dnRh?=
 =?utf-8?B?c2l6YUxkVUJ4c1g4RDVVdnZZaFQzVW9FWW0vV1RLclk1U1VKT1Rkdm1Ba3Z5?=
 =?utf-8?B?RzAvTWFndFkrUU1sVVBhMEl6UFJtczFZMkExUDBOZHZQTlZPMFdtNnRsNTJL?=
 =?utf-8?B?aXAvYkM0MXNIaFhXajVTY2phRVVjTnZ3ZzVZTEpJRFdzOWFZK2JxbURESk5w?=
 =?utf-8?B?ZHJUd29UcXA1VVkzc1N2NDJJK0QzT1Nicko3MFBRTHpHNTJjaW55dW5OUENU?=
 =?utf-8?B?WUVObmk4QlcvV3pRMldxTkhtdGd1N25ZNzNHVEIzZXpxQWZvMHgwcTh0N0pn?=
 =?utf-8?B?UitnSzQ4QXE0WS9GOEhIYUVDL3FWVmJTakR1TnFMRm80Y3VWRFVSUVZBV1NZ?=
 =?utf-8?B?cEFYWGxyZDJDN25PQXBkS1RTWU5IMWxsSVU2V1dWTXhROFczdEE4MWwzY1dT?=
 =?utf-8?B?UmJSdVNQRWVtN3RWVUdLMXlyVjloNkg5emVaWFhBY0hMSnYra29jMHkyQWFu?=
 =?utf-8?B?ZVN3SEgvYTRpb295Zll6QlJrY2RBNm1TNWYyeXg0TUhEWlNyL0hRcVprMHpu?=
 =?utf-8?B?Q0VEU2pkUE8zVVVtZGJsUWRZMFhia0tFSzBzY01lbDdiMGk2SUlVeElTd3Vu?=
 =?utf-8?B?L3Fld25uQkZxakZrYW41R1lRUXM1cXEraU83RDBmN0kzQW5RUTRzVUYzZ1Bo?=
 =?utf-8?B?bXZkd0xYZjRSTVlzSHNIeldPS2tpVzRINFl6V1VMTWhiSG9TQk9qK1M5KzJz?=
 =?utf-8?B?L3VuWVpHK2RZOWRjLy9NMjhrR2VOekJSc3cyeEg1Nm9VVDMzRFdDRTRGUEYr?=
 =?utf-8?B?M3BaQWhVY3FQS0ZKQ2wvZlpLU3V1cDRueGFCUEdHeHR5SEhzMS9Jdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0207082-8705-4ed1-98fd-08deb6de146d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 02:10:07.7825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ePrSzofmo3PU06A4QoT9NmERcpLFVWlDHFnI2UnT8VwF30flCN5B2+GiVEWe0BsP1tcsIbTYtB8cKJrnuGqyrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7299

Hi Tom,

On 5/20/26 4:22 PM, Tom Lendacky wrote:
> On 5/19/26 14:50, Pratik R. Sampat wrote:
>> The SEV-SNP firmware provides the SNP_VERIFY_MITIGATION command, which
>> can be used to query the status of currently supported vulnerability
>> mitigations and to initiate mitigations within the firmware.
>>
>> This command is an explicit mechanism to ascertain if a firmware
>> mitigation is applied without needing a full RMP re-build, which is most
>> useful in a live firmware update scenario.
>>
>> The firmware supports two subcommands: STATUS and VERIFY. The STATUS
>> subcommand is used to query the supported and verified mitigation bits.
>> The VERIFY subcommand initiates the mitigation process within the FW for
>> the specified vulnerability. Expose a userspace interface under:
>> /sys/firmware/sev/vulnerabilities/
>>   - supported_mitigations (read-only): supported mitigation vector mask
>>   - verified_mitigations (read/write): current verified mask; write a
>>     vector to request VERIFY for that bit
>>
>> The behavior of SNP_VERIFY_MITIGATION and the pre-requisites for using
>> it are bug-specific. Information about supported mitigations and its
>> corresponding vector is to be published as part of the AMD Security
>> Bulletin.
>>
>> See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
>> more details.
>>
>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
>> ---
>>  .../sysfs-firmware-sev-vulnerabilities        |  17 ++
>>  drivers/crypto/ccp/sev-dev.c                  | 172 ++++++++++++++++++
>>  drivers/crypto/ccp/sev-dev.h                  |   3 +
>>  include/linux/psp-sev.h                       |  51 ++++++
>>  4 files changed, 243 insertions(+)
>>  create mode 100644 Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
>>
>> diff --git a/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities b/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
>> new file mode 100644
>> index 000000000000..cc84adbac3c0
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
>> @@ -0,0 +1,17 @@
>> +What:		/sys/firmware/sev/vulnerabilities/
>> +		/sys/firmware/sev/vulnerabilities/supported_mitigations
>> +		/sys/firmware/sev/vulnerabilities/verified_mitigations
>> +Date:		May 2026
>> +Contact:	linux-crypto@vger.kernel.org
>> +Description:	Information about SEV-SNP firmware vulnerability mitigations.
>> +		supported_mitigations: Read-only interface that reports
>> +				       the vector of mitigations supported by
>> +				       the firmware.
>> +		verified_mitigations: Read/write interface that reports
>> +				      the vector of mitigations already verified
>> +				      by the firmware. Writing a vector value
>> +				      requests the firmware to VERIFY the
>> +				      corresponding mitigation bit(s).
>> +		The list of supported mitigations and the meaning of each
>> +		vector bit are both platform- and bug-specific and are
>> +		published as part of the AMD Security Bulletin.
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index d1e9e0ac63b6..eec4864c6597 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -57,6 +57,7 @@
>>  #define CMD_BUF_DESC_MAX (CMD_BUF_FW_WRITABLE_MAX + 1)
>>  
>>  static DEFINE_MUTEX(sev_cmd_mutex);
>> +static DEFINE_MUTEX(sev_mit_sysfs_mutex);
>>  static struct sev_misc_dev *misc_dev;
>>  
>>  static int psp_cmd_timeout = 100;
>> @@ -245,6 +246,7 @@ static int sev_cmd_buffer_len(int cmd)
>>  	case SEV_CMD_SNP_LAUNCH_FINISH:		return sizeof(struct sev_data_snp_launch_finish);
>>  	case SEV_CMD_SNP_DBG_DECRYPT:		return sizeof(struct sev_data_snp_dbg);
>>  	case SEV_CMD_SNP_DBG_ENCRYPT:		return sizeof(struct sev_data_snp_dbg);
>> +	case SEV_CMD_SNP_VERIFY_MITIGATION:	return sizeof(struct sev_data_snp_verify_mitigation);
>>  	case SEV_CMD_SNP_PAGE_UNSMASH:		return sizeof(struct sev_data_snp_page_unsmash);
>>  	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_addr);
>>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>> @@ -1351,6 +1353,162 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>>  	return 0;
>>  }
>>  
>> +static int snp_verify_mitigation(u16 command, u64 vector,
>> +				 struct sev_data_snp_verify_mitigation_dst *dst)
>> +{
>> +	struct sev_data_snp_verify_mitigation_dst *mit_dst = NULL;
>> +	struct sev_data_snp_verify_mitigation data = {0};
>> +	struct sev_device *sev = psp_master->sev_data;
>> +	int ret, error = 0;
>> +
>> +	mit_dst = snp_alloc_firmware_page(GFP_KERNEL | __GFP_ZERO);
>> +	if (!mit_dst)
>> +		return -ENOMEM;
>> +
>> +	data.length = sizeof(data);
>> +	data.subcommand = command;
>> +	data.vector = vector;
>> +	data.dst_paddr = __psp_pa(mit_dst);
>> +	data.dst_paddr_en = true;
>> +
>> +	ret = sev_do_cmd(SEV_CMD_SNP_VERIFY_MITIGATION, &data, &error);
>> +	if (!ret)
>> +		memcpy(dst, mit_dst, sizeof(*mit_dst));
>> +	else
>> +		dev_err(sev->dev, "SNP_VERIFY_MITIGATION command failed, ret = %d, error = %#x\n",
>> +			ret, error);
>> +
>> +	snp_free_firmware_page(mit_dst);
>> +
>> +	return ret;
>> +}
> 
> Should this function also be under the CONFIG_SYSFS #ifdef? Won't you get
> an unused function warning if CONFIG_SYSFS isn't defined?

That's right. Thanks for spotting that!

> 
>> +
>> +#ifdef CONFIG_SYSFS
>> +static ssize_t supported_mitigations_show(struct kobject *kobj,
>> +					  struct kobj_attribute *attr, char *buf)
>> +{
>> +	struct sev_data_snp_verify_mitigation_dst dst;
>> +	int ret;
>> +
>> +	ret = snp_verify_mitigation(SNP_MIT_SUBCMD_REQ_STATUS, 0, &dst);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return sysfs_emit(buf, "0x%llx\n", dst.mit_supported_vector);
>> +}
>> +
>> +static struct kobj_attribute supported_attr =
>> +		__ATTR_RO_MODE(supported_mitigations, 0400);
>> +
>> +static ssize_t verified_mitigations_show(struct kobject *kobj,
>> +					 struct kobj_attribute *attr, char *buf)
>> +{
>> +	struct sev_data_snp_verify_mitigation_dst dst;
>> +	int ret;
>> +
>> +	ret = snp_verify_mitigation(SNP_MIT_SUBCMD_REQ_STATUS, 0, &dst);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return sysfs_emit(buf, "0x%llx\n", dst.mit_verified_vector);
>> +}
>> +
>> +static ssize_t verified_mitigations_store(struct kobject *kobj,
>> +					  struct kobj_attribute *attr,
>> +					  const char *buf, size_t count)
>> +{
>> +	struct sev_data_snp_verify_mitigation_dst dst;
>> +	struct sev_device *sev = psp_master->sev_data;
>> +	u64 vector;
>> +	int ret;
>> +
>> +	ret = kstrtoull(buf, 0, &vector);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = snp_verify_mitigation(SNP_MIT_SUBCMD_REQ_VERIFY, vector, &dst);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (dst.mit_failure_status) {
>> +		dev_err(sev->dev, "Verify Mitigation - failure status: 0x%x\n",
>> +			dst.mit_failure_status);
>> +		return -EIO;
>> +	}
>> +
>> +	return count;
>> +}
>> +
>> +static struct kobj_attribute verified_attr =
>> +		__ATTR_RW_MODE(verified_mitigations, 0600);
>> +
>> +static struct attribute *mitigation_attrs[] = {
>> +	&supported_attr.attr,
>> +	&verified_attr.attr,
>> +	NULL
>> +};
>> +
>> +static const struct attribute_group mit_attr_group = {
>> +	.attrs = mitigation_attrs,
>> +};
>> +
>> +static void sev_snp_register_verify_mitigation(struct sev_device *sev)
>> +{
>> +	int rc;
>> +
>> +	if (!sev->snp_initialized || !sev->snp_plat_status.feature_info ||
>> +	    !(sev->snp_feat_info_0.ecx & SNP_VERIFY_MITIGATION_SUPPORTED))
>> +		return;
>> +
>> +	guard(mutex)(&sev_mit_sysfs_mutex);
>> +
>> +	if (sev->verify_mit)
>> +		return;
>> +
>> +	if (!sev->sev_kobj) {
>> +		sev->sev_kobj = kobject_create_and_add("sev", firmware_kobj);
>> +		if (!sev->sev_kobj)
>> +			return;
>> +	}
>> +
>> +	sev->verify_mit = kobject_create_and_add("vulnerabilities", sev->sev_kobj);
>> +	if (!sev->verify_mit)
>> +		goto err_sev_kobj;
>> +
>> +	rc = sysfs_create_group(sev->verify_mit, &mit_attr_group);
>> +	if (rc)
>> +		goto err_verify_mit;
>> +
>> +	return;
>> +
>> +err_verify_mit:
>> +	kobject_put(sev->verify_mit);
>> +	sev->verify_mit = NULL;
>> +err_sev_kobj:
>> +	kobject_put(sev->sev_kobj);
>> +	sev->sev_kobj = NULL;
>> +}
>> +
>> +static void sev_snp_unregister_verify_mitigation(struct sev_device *sev)
>> +{
>> +	guard(mutex)(&sev_mit_sysfs_mutex);
>> +
>> +	if (sev->verify_mit) {
>> +		sysfs_remove_group(sev->verify_mit, &mit_attr_group);
>> +		kobject_put(sev->verify_mit);
>> +		sev->verify_mit = NULL;
>> +	}
>> +
>> +	if (sev->sev_kobj) {
>> +		kobject_put(sev->sev_kobj);
>> +		sev->sev_kobj = NULL;
>> +	}
>> +}
>> +#else
>> +static void sev_snp_register_verify_mitigation(struct sev_device *sev) { }
>> +static void sev_snp_unregister_verify_mitigation(struct sev_device *sev) { }
>> +#endif
>> +
>>  static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>  {
>>  	struct sev_data_range_list *snp_range_list __free(kfree) = NULL;
>> @@ -1670,6 +1828,14 @@ int sev_platform_init(struct sev_platform_init_args *args)
>>  	rc = _sev_platform_init_locked(args);
>>  	mutex_unlock(&sev_cmd_mutex);
>>  
>> +	/*
>> +	 * The shutdown + init path can race with in-flight _show()/_store() operations
>> +	 * which acquire the sev_cmd_mutex. Register the sysfs interface outside
>> +	 * the sev_cmd_mutex and serialize by sev_mit_sysfs_mutex instead.
> 
> I'm not quite sure I follow this. The shutdown and init path can't race
> with each other, right? In which case this new mutex doesn't really matter
> unless you take it on _show()/_short(), right?
> 
What I meant here is the new mutex attempts to addresses the following scenario:

First, assume sev_snp_[un]register_verify_mitigation() are protected under
sev_cmd_mutex:

t1                                 | t2
---------------------------------- | ----------------------------------
sev_firmware_shutdown()            |
  lock(sev_cmd_mutex)              |
                                   | verified_mitigations_store()
                                   |   lock(sev_cmd_mutex)  <-- waits on t1
  unregister_verify_mitigation()   |
    sysfs_remove_group()  <-- waits for t2's _store to drain

So sev_snp_unregister_verify_mitigation() has to run outside sev_cmd_mutex to
avoid the sysfs_remove_group() <-> in-flight _show()/_store() deadlock.

Now, with unregister no longer protected by sev_cmd_mutex, a concurrent init
can race with shutdown on the sysfs lifetime like so:
t1                                 | t2
---------------------------------- | ----------------------------------
sev_firmware_shutdown()            | sev_platform_init()
  unregister_verify_mitigation()   |   register_verify_mitigation()
    sysfs_remove_group()           |     sysfs_create_group()

Both sides touch sev->verify_mit without serialization. The same race also
exists for init vs init which is no longer covered by sev_cmd_mutex once
register moves outside it.

So, I attempt address that with a sev_mit_sysfs_mutex guard.

--Pratik
