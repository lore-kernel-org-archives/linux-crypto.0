Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010008.outbound.protection.outlook.com [52.101.56.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E042D3E0720;
	Thu, 21 May 2026 13:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369181; cv=fail; b=FbH5wAbcYdE47zNftSqnm3t9bC2cFahW2wq6hq0xwvmPL8/aqtuTJHSU5NCEaOc19ULysE+gQVCsLIEmx3uEesoVCJNayord8OVbCtyDjA5X0Znm1OYLspyNgnmH3EJ01RIEO9D+3Q045hS6mgQ1CewgkURZFYNlAm+kxv38sw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369181; c=relaxed/simple;
	bh=HoTj+ONT7MRvWv/ztYz1ORwliPpKm4UBH23dq54RFBc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=a/Vf8cIQHixa6BEmQZDsmEUDbGbWBzSflo7s7MtJ7pxdU0RTNFLWPHmjrFkssIgAisnQ/RvrDAPQfKmnOiNURHIRtEenflz5I4eeYCJpFgm/oByIT1KW6bIQHgEr9SJWwVDVvDwcueZWrQhPKF2vtQVrKNf8y6EPP+/2pobTTw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0RdHlW0g; arc=fail smtp.client-ip=52.101.56.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0RdHlW0g"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AAS20ZfaLx6h/vwdv8JVQE/C8prQgqQxzPG5u4usqCDEm1JzMS/3wzvJq4ne5okE8mXt1XlZr8KC8TFT2XLcknz0ffYGV5WsSt62kaX4GBq9TDuDKYI/urO1qSnUenjiBS+xfOxv3O3jm4diDCBsMcb3/KQsas7TXif6QJoNXTaF7cio9uGsqlHx4D9VFQ2tv85eKZ7s0SzLlM5Tj5M3lUJL41xn91BXqu78Z+5t09hliwfy7kboV1v+DRuubrkgTTMo8AUlbpx0edDdRbwfcFArQuP2Uk8X0P5hq501XMzSpSfyX8AWWdM8oxH8QAO2WOoWmbkph6izty5GPFV98Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c9nYs1bJTpPArNdFRMqW95+22XisdqYMSXnwdOJXjwM=;
 b=JkvW84iELWYzX7uveu+bAcES1LLYscDrL/JgZFdnDXG4L2qm/2mAgPUZqOyksqi2czC/5FkUutKgpcIirM5Hu8QBX9AoyYOCCTKregK+Kzw9PhpxTHVSh9pdvlf67YnQNIE4U0gVgnE9RolRXAjERn3rIgHz9q/yr2VxigNScseYZYnyztnMK3KR6pOkyLm5H5H27NURGGUIZzPjpnN7m5qmo1gRvpQ2JFLwqVNC4d7Gb3BfPEMIxKraoqOY5T+SbnUgBsMHOUCvNR+tEklbt7XWiJ3Gzfs/wgVLjAtvJcal1587o9g+W4pE5eViATdYThtWUQT3hv39tvi9lDrAOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9nYs1bJTpPArNdFRMqW95+22XisdqYMSXnwdOJXjwM=;
 b=0RdHlW0gJPs2pNYhlUS7yWEdE6aki0adIyhBF2CXqupBudu15TbNIjKKw++SIRI8uTWtAyqGHUS6D52ihrwzanMg6J8aZ7XqP/yLvAA4BkGkhYLO1ZzMEkKnPZfUgodRc8iuOeO4IOcho2fo6fUQj9BBG1rv8gSoIqc6d+3P9qc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MN6PR12MB8567.namprd12.prod.outlook.com (2603:10b6:208:478::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Thu, 21 May
 2026 13:12:55 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9870.023; Thu, 21 May 2026
 13:12:54 +0000
Message-ID: <b02682e5-8890-454a-ab75-fff1b6566922@amd.com>
Date: Thu, 21 May 2026 08:12:52 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
To: "Pratik R. Sampat" <prsampat@amd.com>, ashish.kalra@amd.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, aik@amd.com,
 tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com
References: <36137b565d183fa2f2985ad098f2e2096f1c432f.1779219958.git.prsampat@amd.com>
 <6d5fd5eb-e54c-47fd-943a-6d03aaafe243@amd.com>
 <4ccf6dc7-88e6-488c-8314-5bcd95164661@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <4ccf6dc7-88e6-488c-8314-5bcd95164661@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0082.namprd11.prod.outlook.com
 (2603:10b6:806:d2::27) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MN6PR12MB8567:EE_
X-MS-Office365-Filtering-Correlation-Id: 92924057-1046-44f0-6f8d-08deb73aab6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|3023799007|22082099003|18002099003|56012099003|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	21P2L8zGKN5VUd0cLdXRMlqvgrQVLcH/QN3tNz94xqa7fpoXv1iwKKDZ7+2vNfWaEmLnmlk8hKrll9OZ7XbvhyndhK+/0isoeCPzv9AIGf6w1+lI0+0av6qNDDMVktqoCGG07QGke+9N9JELz3T00tNvwJQLC0W1mShq0xMxVnE53WFf2l++ySqZI57NrkpB+8IaJfnG/k7VUW6dneIx2VdeApxgghL/GYeiTxJ7a7+aDjJoyyR3sjWtKe8bgPvScywM6Pa+nFNW9W7SUZnu+IMxpy2CGQlAoJUrygEg+wKgxJGlkf5vogf9ZKrKycgwE8JpEr8o6R8I3yXBKPTCjGVAfeH/6SAk9/GfY+eWkJ6/lFgJREaViw1LS/5E/43hXYfLIRON+Bv9StkC8j9ANTbGkS2gc5sZZ4MiOuHmujnlD9ZenC5U2Lk7EpgsnvHk7xLEgvz7FEDpaGFG4vSDXHOnG+1MhcW752VxENbN9BoyTinXXOPs/EwydnASDJpYUEL38HHGTwOdfrBeDlfLbKJpT5ZxFomTKB+CtOq1/r4qauHZINIOLJSTnvZ73EAdmId+9xbc4JzsJLiIoruKIQXy/JIs6/uAdUa4Gw6MXpXpbPt2hcex5fiA/LBBuMBDPrne1K/PHu5axw5LVeg1b1ERLM6Z9bylgwZc/eeNUc36uPTNHkvHb10Q/Od/5Rnk
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(3023799007)(22082099003)(18002099003)(56012099003)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0pzWGtmdm91azBiL1hvTXlxYjdlaDh1TGwvOVo1c1F6TFZvVlB6eGFnRjlq?=
 =?utf-8?B?ZFBwV0RsNHR6V0NsZTlCLzJ0SStJR2duWEJVR1d4T3U0N1E1cjhyOVFZbHdw?=
 =?utf-8?B?a0FEMTFSdkRENzMvY0JKQ0tNaTF4TTF2NmhLZEZUeWZUa0dyOWcxTXBEVWxD?=
 =?utf-8?B?NE9jSE0zeTdzay9rL0t1UFM5ZmI2UjlTbk5KQ3IvbzhiTEExQ2NBdytjQkdW?=
 =?utf-8?B?R3c3aW9BVUx3d2ZxSVhwSThDUUMwWERvbWRwTks2YWdOVVI3YVo1NFpQNklm?=
 =?utf-8?B?RW5qYmVOc2F3UTBwNnZ0dGsvNXdKelhyRXFZTzlKVUQzMVR2c3ZLbEt3V2ZS?=
 =?utf-8?B?bDZoTFM4K1RXWDczalRzZW5JQlhwMWNlZlQzUmJGWTVWMWs5RDdGUXU5dVRv?=
 =?utf-8?B?ektRcnkzUW9EZFhnbCs5Z1MwaEpuK0tuSUNUeGE2K1h6MmxSN3NTV2ZqUkt2?=
 =?utf-8?B?RGI3WTUrekhlRzVEdkdnYTRuSmFpUzRoeEFEaDZSTlNid0VMNEhjamU1dk56?=
 =?utf-8?B?MUdDUVZQR1MxdlBudFFKcWhYVkhkRmF6MmMxSG93SEIwc2dzb2g1MGtZSEd3?=
 =?utf-8?B?dVY5RUVTajVLOFVsK3ZqeDl1UTFQMUIrTEpncHhXcm54cjRxc1ZBcFA0ZS9X?=
 =?utf-8?B?a3FDUHo4VU5EV2JWdzcxNzdCT1EzVlBKQnYwSTVYSlFyM3Nrb1o3WUY2NE43?=
 =?utf-8?B?VVNURlV5d2R1VnlDeUpuWG9aRmd4NklPMFlKMC9EZXFkZDlKUEkrVEZ5TnIr?=
 =?utf-8?B?UDFwbldmYmFWc0h1SmhLcWg2Rm5uSkpyYXdjR0xKYzlYSkFCaWRCamY5R2gr?=
 =?utf-8?B?YmdLd2JwT1lzNzlMQzNuODR2SWg0M09kNncrbWVTdSs5eldiSmpyNWNMRVBP?=
 =?utf-8?B?bnlCWEtmcXFXN3pOVTYxTG1LWGxqN3h3emxiT3FCOGpQYjRIR3d1YWpjR1pP?=
 =?utf-8?B?SlpCdjF2TnNGYmpMZU8vVDZQLzR3a3FCQXZnZ0JROG5Bc212eldQaHdCYyt6?=
 =?utf-8?B?UTgvdUR3em9kNC9tdU81QUVXd1A1WG5rekFpVVBQdGEzV0JuZjhBN3hld3FP?=
 =?utf-8?B?cWRDVWdseE9WMzhBZ1dSQ0FMcGg2T0xtbVQxc2wzbThGQjVtRjd6T3Z4bVBD?=
 =?utf-8?B?U0p3TlovUXJqRVZSbXZnTXlCRnc0WG1kcU5PaFZrZnFZR01IS01paHQrbm00?=
 =?utf-8?B?cTVmeU80Nms3d0FYb2pNeVFwUW1lK2dmRVh4U0VsdEo5dW5DM2ZuaFpTclFD?=
 =?utf-8?B?ZktpZHQ2N2M3U3dVWEJOeU5uU3F3dWU2ZVp3NEtaeUI2YmJ5TGdzMnFkQW9t?=
 =?utf-8?B?dUdKSkt4RmJneDFEZEk0WjZmSGJFQWE4SFJwa1o3c2Z5WS84TXF6cWVQTWRi?=
 =?utf-8?B?bGlKWU5mMjhIMy9jZ3pVakMwTXhIOCtTTGNoSDhnRDdPd0xPTjJnQ21UZ0NR?=
 =?utf-8?B?a1BnLzBiNEtmNlZ5TkkyL0Y4ZHV3UHQ3WTNVcTcrVmR3Z0RoVHJlMHZmU21w?=
 =?utf-8?B?Vmt6bVhLblorRVV3WEg4ODFCbjZvNFVnUUFLNWx6ek84NnN6TnpVNndhNVBY?=
 =?utf-8?B?TnZseitUVjFFUm0yWlEwYjJvUisyNFBJQTB1VTU3SldMRUd6TW96TUNRY3pu?=
 =?utf-8?B?MmlxQ2EzNC8wOE1teUNoNExGVk1OYWNrZ29qNXhLNW1uMUVod3J3Z2tTSUdQ?=
 =?utf-8?B?U0ZidVorNGpyQ3pJMEh3VDRZNS9YWXhwWW5MMlhvbXZZMU4zZzJpSEhzOFFX?=
 =?utf-8?B?RnJXL1NDb3d2MnFML2x2UGJOMlVHS3BSV0s2ZytiRHVjVFloSlFXeGFZMHAw?=
 =?utf-8?B?VTIwL05ZdTNIV3N0T25aTzJvOHJkaXVXMko2aVVQWmNQMWYrWlFiK3Z1RHUw?=
 =?utf-8?B?NmZyMFRTRzVUZjI0SlFHQ0VhUUIwSUVYU0wrenR4SHNiREVpVWoveXdmbHI0?=
 =?utf-8?B?UWEzRVJ1T2c1QnFPVHMwQlVSMDdraFZGRXBKbjloTmpjN29lK2V4UWFOemZl?=
 =?utf-8?B?YnpLWnVoQWcxdTFWMGQwdDFhOW0vUEVJYUZpd1orVzRyZVlVWnJKLzBHckE3?=
 =?utf-8?B?NXZFbmY0ZW0xOVJqZ0N0SUlVanVjV2Z3MjVJSjlsaVRmYXUrTUdIamlyKzV0?=
 =?utf-8?B?TmdRR3dMVW12c0hZNjdyTWxwTWhFamRyTXN4VlovY0hwSlEzRW8veXhLaXcx?=
 =?utf-8?B?TGRtMGpreTZQeHp3MUl5eEllWjdNck5iRXgvTWJWRjl4M1JjbnZYV0VzZzFF?=
 =?utf-8?B?VUc3eWxtTWxwcGVBOGlHL1NCZ3N2bmQ4NzJMVGMyVTYzcUxXNlA3cWNWQStZ?=
 =?utf-8?B?RWx0cUlCTzg2Y0JkWGVXRVFjNWZSazc5NEVXSDBtZU53Mm00Rk01Zz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92924057-1046-44f0-6f8d-08deb73aab6a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 13:12:54.7010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4iF1qjiZw3XCf2WlBd1XcASvMUZ0KdioejShk69ezDPYNzi///s3VvHsqFXE2U0n84OnX2EyHBRiQKecIlJFqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8567

On 5/20/26 21:10, Pratik R. Sampat wrote:
> Hi Tom,
> 
> On 5/20/26 4:22 PM, Tom Lendacky wrote:
>> On 5/19/26 14:50, Pratik R. Sampat wrote:
>>> The SEV-SNP firmware provides the SNP_VERIFY_MITIGATION command, which
>>> can be used to query the status of currently supported vulnerability
>>> mitigations and to initiate mitigations within the firmware.
>>>
>>> This command is an explicit mechanism to ascertain if a firmware
>>> mitigation is applied without needing a full RMP re-build, which is most
>>> useful in a live firmware update scenario.
>>>
>>> The firmware supports two subcommands: STATUS and VERIFY. The STATUS
>>> subcommand is used to query the supported and verified mitigation bits.
>>> The VERIFY subcommand initiates the mitigation process within the FW for
>>> the specified vulnerability. Expose a userspace interface under:
>>> /sys/firmware/sev/vulnerabilities/
>>>   - supported_mitigations (read-only): supported mitigation vector mask
>>>   - verified_mitigations (read/write): current verified mask; write a
>>>     vector to request VERIFY for that bit
>>>
>>> The behavior of SNP_VERIFY_MITIGATION and the pre-requisites for using
>>> it are bug-specific. Information about supported mitigations and its
>>> corresponding vector is to be published as part of the AMD Security
>>> Bulletin.
>>>
>>> See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
>>> more details.
>>>
>>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
>>> ---
>>>  .../sysfs-firmware-sev-vulnerabilities        |  17 ++
>>>  drivers/crypto/ccp/sev-dev.c                  | 172 ++++++++++++++++++
>>>  drivers/crypto/ccp/sev-dev.h                  |   3 +
>>>  include/linux/psp-sev.h                       |  51 ++++++
>>>  4 files changed, 243 insertions(+)
>>>  create mode 100644 Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
>>>
>>> diff --git a/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities b/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
>>> new file mode 100644
>>> index 000000000000..cc84adbac3c0
>>> --- /dev/null
>>> +++ b/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
>>> @@ -0,0 +1,17 @@
>>> +What:		/sys/firmware/sev/vulnerabilities/
>>> +		/sys/firmware/sev/vulnerabilities/supported_mitigations
>>> +		/sys/firmware/sev/vulnerabilities/verified_mitigations
>>> +Date:		May 2026
>>> +Contact:	linux-crypto@vger.kernel.org
>>> +Description:	Information about SEV-SNP firmware vulnerability mitigations.
>>> +		supported_mitigations: Read-only interface that reports
>>> +				       the vector of mitigations supported by
>>> +				       the firmware.
>>> +		verified_mitigations: Read/write interface that reports
>>> +				      the vector of mitigations already verified
>>> +				      by the firmware. Writing a vector value
>>> +				      requests the firmware to VERIFY the
>>> +				      corresponding mitigation bit(s).
>>> +		The list of supported mitigations and the meaning of each
>>> +		vector bit are both platform- and bug-specific and are
>>> +		published as part of the AMD Security Bulletin.
>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>> index d1e9e0ac63b6..eec4864c6597 100644
>>> --- a/drivers/crypto/ccp/sev-dev.c
>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>> @@ -57,6 +57,7 @@
>>>  #define CMD_BUF_DESC_MAX (CMD_BUF_FW_WRITABLE_MAX + 1)
>>>  
>>>  static DEFINE_MUTEX(sev_cmd_mutex);
>>> +static DEFINE_MUTEX(sev_mit_sysfs_mutex);
>>>  static struct sev_misc_dev *misc_dev;
>>>  
>>>  static int psp_cmd_timeout = 100;
>>> @@ -245,6 +246,7 @@ static int sev_cmd_buffer_len(int cmd)
>>>  	case SEV_CMD_SNP_LAUNCH_FINISH:		return sizeof(struct sev_data_snp_launch_finish);
>>>  	case SEV_CMD_SNP_DBG_DECRYPT:		return sizeof(struct sev_data_snp_dbg);
>>>  	case SEV_CMD_SNP_DBG_ENCRYPT:		return sizeof(struct sev_data_snp_dbg);
>>> +	case SEV_CMD_SNP_VERIFY_MITIGATION:	return sizeof(struct sev_data_snp_verify_mitigation);
>>>  	case SEV_CMD_SNP_PAGE_UNSMASH:		return sizeof(struct sev_data_snp_page_unsmash);
>>>  	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_addr);
>>>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>>> @@ -1351,6 +1353,162 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>>>  	return 0;
>>>  }
>>>  
>>> +static int snp_verify_mitigation(u16 command, u64 vector,
>>> +				 struct sev_data_snp_verify_mitigation_dst *dst)
>>> +{
>>> +	struct sev_data_snp_verify_mitigation_dst *mit_dst = NULL;
>>> +	struct sev_data_snp_verify_mitigation data = {0};
>>> +	struct sev_device *sev = psp_master->sev_data;
>>> +	int ret, error = 0;
>>> +
>>> +	mit_dst = snp_alloc_firmware_page(GFP_KERNEL | __GFP_ZERO);
>>> +	if (!mit_dst)
>>> +		return -ENOMEM;
>>> +
>>> +	data.length = sizeof(data);
>>> +	data.subcommand = command;
>>> +	data.vector = vector;
>>> +	data.dst_paddr = __psp_pa(mit_dst);
>>> +	data.dst_paddr_en = true;
>>> +
>>> +	ret = sev_do_cmd(SEV_CMD_SNP_VERIFY_MITIGATION, &data, &error);
>>> +	if (!ret)
>>> +		memcpy(dst, mit_dst, sizeof(*mit_dst));
>>> +	else
>>> +		dev_err(sev->dev, "SNP_VERIFY_MITIGATION command failed, ret = %d, error = %#x\n",
>>> +			ret, error);
>>> +
>>> +	snp_free_firmware_page(mit_dst);
>>> +
>>> +	return ret;
>>> +}
>>
>> Should this function also be under the CONFIG_SYSFS #ifdef? Won't you get
>> an unused function warning if CONFIG_SYSFS isn't defined?
> 
> That's right. Thanks for spotting that!
> 
>>
>>> +
>>> +#ifdef CONFIG_SYSFS
>>> +static ssize_t supported_mitigations_show(struct kobject *kobj,
>>> +					  struct kobj_attribute *attr, char *buf)
>>> +{
>>> +	struct sev_data_snp_verify_mitigation_dst dst;
>>> +	int ret;
>>> +
>>> +	ret = snp_verify_mitigation(SNP_MIT_SUBCMD_REQ_STATUS, 0, &dst);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	return sysfs_emit(buf, "0x%llx\n", dst.mit_supported_vector);
>>> +}
>>> +
>>> +static struct kobj_attribute supported_attr =
>>> +		__ATTR_RO_MODE(supported_mitigations, 0400);
>>> +
>>> +static ssize_t verified_mitigations_show(struct kobject *kobj,
>>> +					 struct kobj_attribute *attr, char *buf)
>>> +{
>>> +	struct sev_data_snp_verify_mitigation_dst dst;
>>> +	int ret;
>>> +
>>> +	ret = snp_verify_mitigation(SNP_MIT_SUBCMD_REQ_STATUS, 0, &dst);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	return sysfs_emit(buf, "0x%llx\n", dst.mit_verified_vector);
>>> +}
>>> +
>>> +static ssize_t verified_mitigations_store(struct kobject *kobj,
>>> +					  struct kobj_attribute *attr,
>>> +					  const char *buf, size_t count)
>>> +{
>>> +	struct sev_data_snp_verify_mitigation_dst dst;
>>> +	struct sev_device *sev = psp_master->sev_data;
>>> +	u64 vector;
>>> +	int ret;
>>> +
>>> +	ret = kstrtoull(buf, 0, &vector);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	ret = snp_verify_mitigation(SNP_MIT_SUBCMD_REQ_VERIFY, vector, &dst);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	if (dst.mit_failure_status) {
>>> +		dev_err(sev->dev, "Verify Mitigation - failure status: 0x%x\n",
>>> +			dst.mit_failure_status);
>>> +		return -EIO;
>>> +	}
>>> +
>>> +	return count;
>>> +}
>>> +
>>> +static struct kobj_attribute verified_attr =
>>> +		__ATTR_RW_MODE(verified_mitigations, 0600);
>>> +
>>> +static struct attribute *mitigation_attrs[] = {
>>> +	&supported_attr.attr,
>>> +	&verified_attr.attr,
>>> +	NULL
>>> +};
>>> +
>>> +static const struct attribute_group mit_attr_group = {
>>> +	.attrs = mitigation_attrs,
>>> +};
>>> +
>>> +static void sev_snp_register_verify_mitigation(struct sev_device *sev)
>>> +{
>>> +	int rc;
>>> +
>>> +	if (!sev->snp_initialized || !sev->snp_plat_status.feature_info ||
>>> +	    !(sev->snp_feat_info_0.ecx & SNP_VERIFY_MITIGATION_SUPPORTED))
>>> +		return;
>>> +
>>> +	guard(mutex)(&sev_mit_sysfs_mutex);
>>> +
>>> +	if (sev->verify_mit)
>>> +		return;
>>> +
>>> +	if (!sev->sev_kobj) {
>>> +		sev->sev_kobj = kobject_create_and_add("sev", firmware_kobj);
>>> +		if (!sev->sev_kobj)
>>> +			return;
>>> +	}
>>> +
>>> +	sev->verify_mit = kobject_create_and_add("vulnerabilities", sev->sev_kobj);
>>> +	if (!sev->verify_mit)
>>> +		goto err_sev_kobj;
>>> +
>>> +	rc = sysfs_create_group(sev->verify_mit, &mit_attr_group);
>>> +	if (rc)
>>> +		goto err_verify_mit;
>>> +
>>> +	return;
>>> +
>>> +err_verify_mit:
>>> +	kobject_put(sev->verify_mit);
>>> +	sev->verify_mit = NULL;
>>> +err_sev_kobj:
>>> +	kobject_put(sev->sev_kobj);
>>> +	sev->sev_kobj = NULL;
>>> +}
>>> +
>>> +static void sev_snp_unregister_verify_mitigation(struct sev_device *sev)
>>> +{
>>> +	guard(mutex)(&sev_mit_sysfs_mutex);
>>> +
>>> +	if (sev->verify_mit) {
>>> +		sysfs_remove_group(sev->verify_mit, &mit_attr_group);
>>> +		kobject_put(sev->verify_mit);
>>> +		sev->verify_mit = NULL;
>>> +	}
>>> +
>>> +	if (sev->sev_kobj) {
>>> +		kobject_put(sev->sev_kobj);
>>> +		sev->sev_kobj = NULL;
>>> +	}
>>> +}
>>> +#else
>>> +static void sev_snp_register_verify_mitigation(struct sev_device *sev) { }
>>> +static void sev_snp_unregister_verify_mitigation(struct sev_device *sev) { }
>>> +#endif
>>> +
>>>  static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>>  {
>>>  	struct sev_data_range_list *snp_range_list __free(kfree) = NULL;
>>> @@ -1670,6 +1828,14 @@ int sev_platform_init(struct sev_platform_init_args *args)
>>>  	rc = _sev_platform_init_locked(args);
>>>  	mutex_unlock(&sev_cmd_mutex);
>>>  
>>> +	/*
>>> +	 * The shutdown + init path can race with in-flight _show()/_store() operations
>>> +	 * which acquire the sev_cmd_mutex. Register the sysfs interface outside
>>> +	 * the sev_cmd_mutex and serialize by sev_mit_sysfs_mutex instead.
>>
>> I'm not quite sure I follow this. The shutdown and init path can't race
>> with each other, right? In which case this new mutex doesn't really matter
>> unless you take it on _show()/_short(), right?
>>
> What I meant here is the new mutex attempts to addresses the following scenario:
> 
> First, assume sev_snp_[un]register_verify_mitigation() are protected under
> sev_cmd_mutex:
> 
> t1                                 | t2
> ---------------------------------- | ----------------------------------
> sev_firmware_shutdown()            |
>   lock(sev_cmd_mutex)              |
>                                    | verified_mitigations_store()
>                                    |   lock(sev_cmd_mutex)  <-- waits on t1
>   unregister_verify_mitigation()   |
>     sysfs_remove_group()  <-- waits for t2's _store to drain
> 
> So sev_snp_unregister_verify_mitigation() has to run outside sev_cmd_mutex to
> avoid the sysfs_remove_group() <-> in-flight _show()/_store() deadlock.
> 
> Now, with unregister no longer protected by sev_cmd_mutex, a concurrent init
> can race with shutdown on the sysfs lifetime like so:

Can it? Can init and shutdown race? Isn't that part of module load /
unload, I'm not sure how they can race...

> t1                                 | t2
> ---------------------------------- | ----------------------------------
> sev_firmware_shutdown()            | sev_platform_init()
>   unregister_verify_mitigation()   |   register_verify_mitigation()
>     sysfs_remove_group()           |     sysfs_create_group()
> 
> Both sides touch sev->verify_mit without serialization. The same race also
> exists for init vs init which is no longer covered by sev_cmd_mutex once
> register moves outside it.

I don't think you can have init vs init race, can you? This just all seems
odd to me. Have you created all these race scenarios to test this out?

Would putting the regsiter/unregister under the sev_cmd_mutex and then
taking the sev_cmd_mutex upon entry to _show()/_store() fix all this?
After obtaining the mutex in _show()/_store(), you check for
sev->verify_mit and return an error if NULL. Then you can use the
__sev_do_cmd_locked() to issue any commands.

Also, on the register function, all you need is the check for
!(sev->snp_feat_info_0.ecx & SNP_VERIFY_MITIGATION_SUPPORTED) since if
!sev->snp_plat_status.feature_info is true, so is this this check. And, as
the spec says, the required firmware state is based on the mitigation
requirements, so I don't think you should be checking for snp_initialized.

Thanks,
Tom

> 
> So, I attempt address that with a sev_mit_sysfs_mutex guard.
> 
> --Pratik

