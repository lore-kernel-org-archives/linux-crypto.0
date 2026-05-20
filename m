Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012008.outbound.protection.outlook.com [52.101.48.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D01365A1D;
	Wed, 20 May 2026 20:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779308594; cv=fail; b=bxY1arPNr0rFTThGM4HUCHrqMho2oP/4BCcN6HzskxuGtkmUUgfwluErJkUmLQcnI1KybTUX2pXjnD5gjiAPYBJmtvN9pFDQVJcnzjTWFTGX582/ogW3Ewbx0zWTR2PwEmVj7BwEdd5gVwM7nCQPwYcxO2IGISXs1kwKR5N3RoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779308594; c=relaxed/simple;
	bh=HqGcdYRJvSzw4Ky6A+O7kfZuGXxpNptIS3Ek/+lziA4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=seOUGHvpf0Vbm22Hq6DnxO66MschPXqPlmj9AYEAymIedq3ODs7aq4bXRgoQgFxL1GLXeIz/+GOUQPnl8xHGYD3Gjy5GsephvrNN79SaxeXzlTU+uaYK908LPFg2Gwu7jrG26hGXxX/yn88v0qFPBNVF8FAj4SFFM2PQkyPFMBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dDYJwLB4; arc=fail smtp.client-ip=52.101.48.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dDYJwLB4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iIpDZ1URsEMHYewDU9Rp9bCTJ6dNPXJ1jyEFr4wtkg3+gc/r4cguZ9KwRoB0dZ3am/xwlhdR1J2lTjV/Z/DfEyjsmeS28q3MsP9biIZMnjZi8DRlaX7gP+1j2JXQIrO/zkGzKlN8cFcSTiAwfAP56GVD1h7/wberuIADIw04NKfVMvCSHL2Nyta2QXAr8eyvFYenlXrivmDSoZJ6xhf+N5lTh4siN9HY7+buTlBd2s+5H8ofoc+QMVdIsgFt0+1KT6t7Di3HzEoul5+ySiSTqp2/oq1s97GGnI+EA42HwjF0aOauBUAmHQOvZP1yhJekGLoCRe1eTy1KyQstgV4CeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ye5ce2UcuSIVG2oyQnGhAhfEswC5s0Bmta3oVF9pfP4=;
 b=M5h/XRq/dOOYhpr+igdzcZJWR+2MzvSzP29d6xPAUHet4Z6t2L44NtJIRl+8tnEplF25ahZSOek3SH+sjjZE6bpQp6Xpo8YtcB4QYAOIfY8CYBLXJfFfkLi1Tb/RqOpqMV6wjJKRqmEhaBw4D/5Mo74WKgYdkS3vDufZtE7LpEbGa79OZuTcxphPEM0l3gOWtm//qtV7VuprnlakXkSujoRzxggHKsK0tli8SHa18g8hegvSiL9gkzJFRsXq9c2IbAPSfjH+4H4ENMxbswcwimcQ4hsytxsHqPE4jCxXSeqlxNo8Z0zpa0YISE1Hi92UNnBAr+7GmFLcf8t9hlGHtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ye5ce2UcuSIVG2oyQnGhAhfEswC5s0Bmta3oVF9pfP4=;
 b=dDYJwLB4OvZ7mAJQdN83+faWyvaEynr+i0AyNHiKJkYvyRhh9H6Or5Q48cfK2kWjTjVcjlq9U1P8DRfyhFI3V03i3Rs6K6EkvESQT2xevbsTD6Gyk4rs4sUMfGyF9jwayHIdo3B3+BBrSjbXy3++/soSKBz97vEwXU+Z1yTkWP0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH8PR12MB999204.namprd12.prod.outlook.com (2603:10b6:610:35a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Wed, 20 May
 2026 20:23:09 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9870.023; Wed, 20 May 2026
 20:23:09 +0000
Message-ID: <6d5fd5eb-e54c-47fd-943a-6d03aaafe243@amd.com>
Date: Wed, 20 May 2026 15:22:38 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
To: "Pratik R. Sampat" <prsampat@amd.com>, ashish.kalra@amd.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, aik@amd.com,
 tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com
References: <36137b565d183fa2f2985ad098f2e2096f1c432f.1779219958.git.prsampat@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <36137b565d183fa2f2985ad098f2e2096f1c432f.1779219958.git.prsampat@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0054.namprd13.prod.outlook.com
 (2603:10b6:610:b2::29) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH8PR12MB999204:EE_
X-MS-Office365-Filtering-Correlation-Id: 358d5df7-e52a-4884-c9a5-08deb6ad9b88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|3023799007|11063799006|56012099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Nn35xtiDx9ZZOaJEvBQ5402JVYDS8RuzfV3/yv0cQWqla4CIg9bIdEQfN31CMqbCc+sgRRZOWiRCcpKIUWXfSdbp6lQKbS+JRq/GYQavxTOATXdSOPr2qGkCWYQPvjhMnHdgV3exavDK8uwtkkB/HlExjBZrDfmIrXfv/gbnemcIRhIjVV+ZLkCfw4t0bieV1cj5ungBZuDDvek7zVLsFuJmnx3FOBD8NZdQvy3WENH+VitenQpAQcZEynP5EA9RWPAK/emOGYvzyc4KjjUgESmLrBe6nRClgtGkhbqTLXhfqgYbE01awi9gzayz1Ut0+cYOSAstaRGhpvHzv7kIoWlgsaf00oX+bjkY0KeL5IQTbjjsE8+ZI7xtbh92Tfw9a960y3fvJ8ufI+Bw9IrcBwvYFTBzkBHyQA/ZGnSenrtTX6AxgSwN0HfIvNjUfpUn4GQtM1aoewoYXzSZTMCqH35KJjyBwQQydGVwwzABGLuwvM8UXpx/xoKkZc8Gv3AcyxOK+ldrRkU+yaGQ0gBA8V+Rq1NVlsOMuVuCSuYZwz47sK5TSaetUS5RTE+xvkx3S4d/oroP+/WLmdDPKMTR7ICnfR1fA0B8sQOljFNQ5CyE1bzbUg0clnQ8MnGYXx4MHimGqc5pGjeal3PqOCxCDndJzWDqAUwtAvCs994+pOGL3DC1QsnRhQRqw9ZgYqGZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(3023799007)(11063799006)(56012099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1NnN1lGQ0pyTkZDVnhoNlRyUGJpejg3UTJ1eVVDbHM3MGpqTmt2SFZEellW?=
 =?utf-8?B?UVZQbWNsd3h4b2ZUSWtOMC9EeFpHWEJuSmcvKzBWTEpsdWU2amtsZXlqeWNk?=
 =?utf-8?B?L1kyaGRIekY5Tjd6UG1nVDJDZllDQWRxSU1FblZiTmJIcGdRT29CZmdLYTV1?=
 =?utf-8?B?UDFVR3M0SHN6RWQ1emlOSTJuTDhoUUZuNTNtOGlNMTc2Uk9aclM2c1ZVNDYv?=
 =?utf-8?B?bnhkQ0EzWVVJcWhPNEg2a3BuUExhTnlEWWIxWUg5amk5b3g3YzIwQklTQXJr?=
 =?utf-8?B?TzRxM1luamlNeGhTYmF6V1BOOFVHSEpCK0YzUWVlS1h3WnVrbDVlTWN6VkNo?=
 =?utf-8?B?SHI2a0dKWE5hcUlnVWR1dmlTWjBMZ21RMnRwZ0pxa3JqRnJFUTQ0Mncvb3hj?=
 =?utf-8?B?eFFnQ3VkNDZVdVNPZ0hpYXpaUVBVc1U4cjF4WmRoT3gveTdwdkdoS3ZkM3Ja?=
 =?utf-8?B?Y2UvVktwdlZpMVJVaWJtZEJpWGd3ZDJuZWZaSzhaTkt3cTF6ODg4U3NjMElR?=
 =?utf-8?B?c2dWK0Z5aWw5aldYT1dYbWdsTWRpb2lsQ2tMM0Q2SUhZeEhNaERGRGVEYmhH?=
 =?utf-8?B?d1M4TVRVdkFlOC9ibU9nMXZJQ3J5aVh3RmNkcUZHbTZ5WEpUUm9RWUVmcm4v?=
 =?utf-8?B?YTZ4MHJyU2NGNW5hNS9QRE5jbXZDQUVmLy9aWnNsOHNyeDNKZkFZcE9XY0tV?=
 =?utf-8?B?OHAvMm52RFYyS2RqZjlhbHpLbE92dkZBVDJCWmdRT0FlVmtmbGFNZTNINm9U?=
 =?utf-8?B?RzhVeXovRTM0c0Y0T25qeEhPNmxuS2IvUDNwUDlWaUZPYUhaRlBVaUVpQ1lL?=
 =?utf-8?B?TEg1UDZyWUt1eWYzWGlxdk9aUk5lQUVlMVdrc25MbGpjbXBEeDRwL0llVThN?=
 =?utf-8?B?MHBEUlpic2p2WDdFdi9vOUlabmtvQUc2djBUZkF5Z3JPS3E2TmNyTlhvNzZl?=
 =?utf-8?B?cWpmM0w3QlE3QW9GR1RIa25BTFJ2TGJ1YlowTEV0SXdFbGlFSytFa3A0YTV5?=
 =?utf-8?B?OFQrTWNMNkZjR0U1WW8yNk5sU0NhU2RBaThTMGJ6ZzFRN0szUUVkelVBZndS?=
 =?utf-8?B?QlZLOXhZK3RVWGRScWhzSS83Sm5jQy9BRnpzUHYwNmJiZ2JrVGxKZW1pdlY4?=
 =?utf-8?B?VzZEQ21uaENZdlJYL21EQVRCMjRFc2pzdlZZdVg0ZnhHelQySlNhMWxCSzBv?=
 =?utf-8?B?R0trWC9oZ1RJT1N2cVROQ05RZzJpQXNVWlI2MktwVkd5NVhlWmZCOXB6Y0Nu?=
 =?utf-8?B?eXFBUjMzS08yOFFPQUZ4MFlUdEJrZHRYZmFMb1UzakozS1QvZUpabGJZcGpT?=
 =?utf-8?B?U2pyNTQrTW1vb0RyQVZvOUFKVFNmTjcvUnp2ZEtjdjFpR2VGaDgvWHF0V2k1?=
 =?utf-8?B?M3NiSGxwTlJZTUNyYkxMa29XV3djbmR4eTdxbFR5L3lpempNSW96cnpFc2pr?=
 =?utf-8?B?SHI0ZlFZcGFOM3ZTajlmQ3FHd3V4bHJjVDNQeUhJSitYSVB2MXhrNHNIWnVL?=
 =?utf-8?B?NWNGUEc5UlRHRE1XRlZUWWV0NGtiNFlQZkl2Vkgvb1R5eWtNUDlwemMzZmp0?=
 =?utf-8?B?cmF0Y2JSbG9sR2Y5VzJxeEp4MGdrVFQ2b2pnRHVDUjVwSk1QQ1haR0FtWTNP?=
 =?utf-8?B?dGFsOUFYbllTVC95RHZPQ1Y0R1BtMDUyVFQwQzFmMjUwMWU4UTNtNmZDRENF?=
 =?utf-8?B?eEpyV2loN2JiWDhxKzFQMjRMM3JGYit4Z2FnM3gyNmljOHJXckZPR0hxRXJQ?=
 =?utf-8?B?eDFua1luT2pQWTF2bUNmUUQ5ZHU3cjVGUW41THJzQ2o1bFZWaFZRWFhKeUF3?=
 =?utf-8?B?c3Q3dkQzUVdRbWswSXB6RWlXaTgyd1NHVWpRZ3Zrb2lITmNic3djMGNMbVdY?=
 =?utf-8?B?U3RTZ09sS0gvL3lxNDRlWnVxSUR3NVBYYVpMc1RrYjNYUy9HczNjMHZYR2M3?=
 =?utf-8?B?S0E3N2FwUW5scmZmWTUvaFpkcXhCdVMxeFRnNnFGR2hSUnkzbVdxRnZFS2Vw?=
 =?utf-8?B?QnNxL1pwcGVtU3hsWStXNXZLOEp3RGQzVHZJY0F4ZWpLWUVBR1VPZGkxWGxD?=
 =?utf-8?B?WFVQT2k2aHl3dlZlQjd5b1pwNkExUmhhUSt5S25waGlBbnJDVFAwUllqVjY5?=
 =?utf-8?B?aXliS3kwcjVnUDFzWnZuNjRISGNFQmxLcEhkRExrbnBBNDJ3a3dZYkt2UnhH?=
 =?utf-8?B?TmZ5TDNybXI5dEt6TGRjb2RLVm9XNk9ndEpyamdoV3FIbi9SWWpsQWMxY1ZS?=
 =?utf-8?B?TFNFSjNQSExrZzRnT1FjVGZ5ei91Z2E1d2NMakwzTlpMYUNZNmRmd3hXWThY?=
 =?utf-8?B?N21wRzloVmlFVGUwSlRhckpyWCt3UlhVK0Q0L29MN0ZFOWFpakVEUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 358d5df7-e52a-4884-c9a5-08deb6ad9b88
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2026 20:23:08.9742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H8ZB+GFXPWci/H4lKR1pPwmgyvCTyqpUiSw/yt1u4y+o+6p/PA4eM3D5qGvMQ2FeQ8SNqX0IT04qT78afyDB8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB999204

On 5/19/26 14:50, Pratik R. Sampat wrote:
> The SEV-SNP firmware provides the SNP_VERIFY_MITIGATION command, which
> can be used to query the status of currently supported vulnerability
> mitigations and to initiate mitigations within the firmware.
> 
> This command is an explicit mechanism to ascertain if a firmware
> mitigation is applied without needing a full RMP re-build, which is most
> useful in a live firmware update scenario.
> 
> The firmware supports two subcommands: STATUS and VERIFY. The STATUS
> subcommand is used to query the supported and verified mitigation bits.
> The VERIFY subcommand initiates the mitigation process within the FW for
> the specified vulnerability. Expose a userspace interface under:
> /sys/firmware/sev/vulnerabilities/
>   - supported_mitigations (read-only): supported mitigation vector mask
>   - verified_mitigations (read/write): current verified mask; write a
>     vector to request VERIFY for that bit
> 
> The behavior of SNP_VERIFY_MITIGATION and the pre-requisites for using
> it are bug-specific. Information about supported mitigations and its
> corresponding vector is to be published as part of the AMD Security
> Bulletin.
> 
> See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
> more details.
> 
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> ---
>  .../sysfs-firmware-sev-vulnerabilities        |  17 ++
>  drivers/crypto/ccp/sev-dev.c                  | 172 ++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h                  |   3 +
>  include/linux/psp-sev.h                       |  51 ++++++
>  4 files changed, 243 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
> 
> diff --git a/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities b/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
> new file mode 100644
> index 000000000000..cc84adbac3c0
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
> @@ -0,0 +1,17 @@
> +What:		/sys/firmware/sev/vulnerabilities/
> +		/sys/firmware/sev/vulnerabilities/supported_mitigations
> +		/sys/firmware/sev/vulnerabilities/verified_mitigations
> +Date:		May 2026
> +Contact:	linux-crypto@vger.kernel.org
> +Description:	Information about SEV-SNP firmware vulnerability mitigations.
> +		supported_mitigations: Read-only interface that reports
> +				       the vector of mitigations supported by
> +				       the firmware.
> +		verified_mitigations: Read/write interface that reports
> +				      the vector of mitigations already verified
> +				      by the firmware. Writing a vector value
> +				      requests the firmware to VERIFY the
> +				      corresponding mitigation bit(s).
> +		The list of supported mitigations and the meaning of each
> +		vector bit are both platform- and bug-specific and are
> +		published as part of the AMD Security Bulletin.
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index d1e9e0ac63b6..eec4864c6597 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -57,6 +57,7 @@
>  #define CMD_BUF_DESC_MAX (CMD_BUF_FW_WRITABLE_MAX + 1)
>  
>  static DEFINE_MUTEX(sev_cmd_mutex);
> +static DEFINE_MUTEX(sev_mit_sysfs_mutex);
>  static struct sev_misc_dev *misc_dev;
>  
>  static int psp_cmd_timeout = 100;
> @@ -245,6 +246,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_LAUNCH_FINISH:		return sizeof(struct sev_data_snp_launch_finish);
>  	case SEV_CMD_SNP_DBG_DECRYPT:		return sizeof(struct sev_data_snp_dbg);
>  	case SEV_CMD_SNP_DBG_ENCRYPT:		return sizeof(struct sev_data_snp_dbg);
> +	case SEV_CMD_SNP_VERIFY_MITIGATION:	return sizeof(struct sev_data_snp_verify_mitigation);
>  	case SEV_CMD_SNP_PAGE_UNSMASH:		return sizeof(struct sev_data_snp_page_unsmash);
>  	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_addr);
>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
> @@ -1351,6 +1353,162 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  	return 0;
>  }
>  
> +static int snp_verify_mitigation(u16 command, u64 vector,
> +				 struct sev_data_snp_verify_mitigation_dst *dst)
> +{
> +	struct sev_data_snp_verify_mitigation_dst *mit_dst = NULL;
> +	struct sev_data_snp_verify_mitigation data = {0};
> +	struct sev_device *sev = psp_master->sev_data;
> +	int ret, error = 0;
> +
> +	mit_dst = snp_alloc_firmware_page(GFP_KERNEL | __GFP_ZERO);
> +	if (!mit_dst)
> +		return -ENOMEM;
> +
> +	data.length = sizeof(data);
> +	data.subcommand = command;
> +	data.vector = vector;
> +	data.dst_paddr = __psp_pa(mit_dst);
> +	data.dst_paddr_en = true;
> +
> +	ret = sev_do_cmd(SEV_CMD_SNP_VERIFY_MITIGATION, &data, &error);
> +	if (!ret)
> +		memcpy(dst, mit_dst, sizeof(*mit_dst));
> +	else
> +		dev_err(sev->dev, "SNP_VERIFY_MITIGATION command failed, ret = %d, error = %#x\n",
> +			ret, error);
> +
> +	snp_free_firmware_page(mit_dst);
> +
> +	return ret;
> +}

Should this function also be under the CONFIG_SYSFS #ifdef? Won't you get
an unused function warning if CONFIG_SYSFS isn't defined?

> +
> +#ifdef CONFIG_SYSFS
> +static ssize_t supported_mitigations_show(struct kobject *kobj,
> +					  struct kobj_attribute *attr, char *buf)
> +{
> +	struct sev_data_snp_verify_mitigation_dst dst;
> +	int ret;
> +
> +	ret = snp_verify_mitigation(SNP_MIT_SUBCMD_REQ_STATUS, 0, &dst);
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_emit(buf, "0x%llx\n", dst.mit_supported_vector);
> +}
> +
> +static struct kobj_attribute supported_attr =
> +		__ATTR_RO_MODE(supported_mitigations, 0400);
> +
> +static ssize_t verified_mitigations_show(struct kobject *kobj,
> +					 struct kobj_attribute *attr, char *buf)
> +{
> +	struct sev_data_snp_verify_mitigation_dst dst;
> +	int ret;
> +
> +	ret = snp_verify_mitigation(SNP_MIT_SUBCMD_REQ_STATUS, 0, &dst);
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_emit(buf, "0x%llx\n", dst.mit_verified_vector);
> +}
> +
> +static ssize_t verified_mitigations_store(struct kobject *kobj,
> +					  struct kobj_attribute *attr,
> +					  const char *buf, size_t count)
> +{
> +	struct sev_data_snp_verify_mitigation_dst dst;
> +	struct sev_device *sev = psp_master->sev_data;
> +	u64 vector;
> +	int ret;
> +
> +	ret = kstrtoull(buf, 0, &vector);
> +	if (ret)
> +		return ret;
> +
> +	ret = snp_verify_mitigation(SNP_MIT_SUBCMD_REQ_VERIFY, vector, &dst);
> +	if (ret)
> +		return ret;
> +
> +	if (dst.mit_failure_status) {
> +		dev_err(sev->dev, "Verify Mitigation - failure status: 0x%x\n",
> +			dst.mit_failure_status);
> +		return -EIO;
> +	}
> +
> +	return count;
> +}
> +
> +static struct kobj_attribute verified_attr =
> +		__ATTR_RW_MODE(verified_mitigations, 0600);
> +
> +static struct attribute *mitigation_attrs[] = {
> +	&supported_attr.attr,
> +	&verified_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group mit_attr_group = {
> +	.attrs = mitigation_attrs,
> +};
> +
> +static void sev_snp_register_verify_mitigation(struct sev_device *sev)
> +{
> +	int rc;
> +
> +	if (!sev->snp_initialized || !sev->snp_plat_status.feature_info ||
> +	    !(sev->snp_feat_info_0.ecx & SNP_VERIFY_MITIGATION_SUPPORTED))
> +		return;
> +
> +	guard(mutex)(&sev_mit_sysfs_mutex);
> +
> +	if (sev->verify_mit)
> +		return;
> +
> +	if (!sev->sev_kobj) {
> +		sev->sev_kobj = kobject_create_and_add("sev", firmware_kobj);
> +		if (!sev->sev_kobj)
> +			return;
> +	}
> +
> +	sev->verify_mit = kobject_create_and_add("vulnerabilities", sev->sev_kobj);
> +	if (!sev->verify_mit)
> +		goto err_sev_kobj;
> +
> +	rc = sysfs_create_group(sev->verify_mit, &mit_attr_group);
> +	if (rc)
> +		goto err_verify_mit;
> +
> +	return;
> +
> +err_verify_mit:
> +	kobject_put(sev->verify_mit);
> +	sev->verify_mit = NULL;
> +err_sev_kobj:
> +	kobject_put(sev->sev_kobj);
> +	sev->sev_kobj = NULL;
> +}
> +
> +static void sev_snp_unregister_verify_mitigation(struct sev_device *sev)
> +{
> +	guard(mutex)(&sev_mit_sysfs_mutex);
> +
> +	if (sev->verify_mit) {
> +		sysfs_remove_group(sev->verify_mit, &mit_attr_group);
> +		kobject_put(sev->verify_mit);
> +		sev->verify_mit = NULL;
> +	}
> +
> +	if (sev->sev_kobj) {
> +		kobject_put(sev->sev_kobj);
> +		sev->sev_kobj = NULL;
> +	}
> +}
> +#else
> +static void sev_snp_register_verify_mitigation(struct sev_device *sev) { }
> +static void sev_snp_unregister_verify_mitigation(struct sev_device *sev) { }
> +#endif
> +
>  static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  {
>  	struct sev_data_range_list *snp_range_list __free(kfree) = NULL;
> @@ -1670,6 +1828,14 @@ int sev_platform_init(struct sev_platform_init_args *args)
>  	rc = _sev_platform_init_locked(args);
>  	mutex_unlock(&sev_cmd_mutex);
>  
> +	/*
> +	 * The shutdown + init path can race with in-flight _show()/_store() operations
> +	 * which acquire the sev_cmd_mutex. Register the sysfs interface outside
> +	 * the sev_cmd_mutex and serialize by sev_mit_sysfs_mutex instead.

I'm not quite sure I follow this. The shutdown and init path can't race
with each other, right? In which case this new mutex doesn't really matter
unless you take it on _show()/_short(), right?

Thanks,
Tom

> +	 */
> +	if (!rc)
> +		sev_snp_register_verify_mitigation(psp_master->sev_data);
> +
>  	return rc;
>  }
>  EXPORT_SYMBOL_GPL(sev_platform_init);
> @@ -2796,6 +2962,12 @@ static void sev_firmware_shutdown(struct sev_device *sev)
>  	if (sev->tio_status)
>  		sev_tsm_uninit(sev);
>  
> +	/*
> +	 * Concurrent access to the sysfs entry will call sev_do_cmd() for
> +	 * SNP_VERIFY_MITIGATION which locks the mutex and can cause a deadlock.
> +	 */
> +	sev_snp_unregister_verify_mitigation(sev);
> +
>  	mutex_lock(&sev_cmd_mutex);
>  
>  	__sev_firmware_shutdown(sev, false);
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index b1cd556bbbf6..d5e596606def 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -59,6 +59,9 @@ struct sev_device {
>  
>  	bool snp_initialized;
>  
> +	struct kobject *sev_kobj;
> +	struct kobject *verify_mit;
> +
>  	struct sev_user_data_status sev_plat_status;
>  
>  	struct sev_user_data_snp_status snp_plat_status;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index d5099a2baca5..98666c5a6f79 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -129,6 +129,7 @@ enum sev_cmd {
>  	SEV_CMD_SNP_LAUNCH_FINISH	= 0x0A2,
>  	SEV_CMD_SNP_DBG_DECRYPT		= 0x0B0,
>  	SEV_CMD_SNP_DBG_ENCRYPT		= 0x0B1,
> +	SEV_CMD_SNP_VERIFY_MITIGATION	= 0x0B2,
>  	SEV_CMD_SNP_PAGE_SWAP_OUT	= 0x0C0,
>  	SEV_CMD_SNP_PAGE_SWAP_IN	= 0x0C1,
>  	SEV_CMD_SNP_PAGE_MOVE		= 0x0C2,
> @@ -898,10 +899,60 @@ struct snp_feature_info {
>  #define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
>  #define SNP_AES_256_XTS_POLICY_SUPPORTED	BIT(4)
>  #define SNP_CXL_ALLOW_POLICY_SUPPORTED		BIT(5)
> +#define SNP_VERIFY_MITIGATION_SUPPORTED	BIT(13)
>  
>  /* Feature bits in EBX */
>  #define SNP_SEV_TIO_SUPPORTED			BIT(1)
>  
> +#define SNP_MIT_SUBCMD_REQ_STATUS      0x0
> +#define SNP_MIT_SUBCMD_REQ_VERIFY      0x1
> +
> +/**
> + * struct sev_data_snp_verify_mitigation - SNP_VERIFY_MITIGATION command params
> + *
> + * @length: Length of the command buffer read by the PSP
> + * @subcommand: Mitigation sub-command for the firmware to execute.
> + *              REQ_STATUS: 0x0 - Request status about currently supported and
> + *                                verified mitigations
> + *              REQ_VERIFY: 0x1 - Request to initiate verification mitigation
> + *                                operation on a specific mitigation
> + * @rsvd: Reserved
> + * @vector: Bit specifying the vulnerability mitigation to process
> + * @dst_paddr_en: Destination paddr enabled
> + * @src_paddr_en: Source paddr enabled
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @src_paddr: Source address for optional input data
> + * @dst_paddr: Destination address to write the result
> + * @rsvd3: Reserved
> + */
> +struct sev_data_snp_verify_mitigation {
> +	u32 length;
> +	u16 subcommand;
> +	u16 rsvd;
> +	u64 vector;
> +	u32 dst_paddr_en : 1,
> +	    src_paddr_en : 1,
> +	    rsvd1 : 30;
> +	u8 rsvd2[4];
> +	u64 src_paddr;
> +	u64 dst_paddr;
> +	u8 rsvd3[24];
> +} __packed;
> +
> +/**
> + * struct sev_data_snp_verify_mitigation_dst - mitigation result vectors
> + *
> + * @mit_verified_vector: Bit vector of vulnerability mitigations verified
> + * @mit_supported_vector: Bit vector of vulnerability mitigations supported
> + * @mit_failure_status: Status of the verification operation
> + */
> +struct sev_data_snp_verify_mitigation_dst {
> +	u64 mit_verified_vector;                /* OUT */
> +	u64 mit_supported_vector;               /* OUT */
> +	u32 mit_failure_status;                 /* OUT */
> +} __packed;
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
>  /**

