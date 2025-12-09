Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013038.outbound.protection.outlook.com [40.93.201.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13BD329C6D;
	Tue,  9 Dec 2025 17:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299911; cv=fail; b=GSHMB+jmGPHJFdN0wozWr86swKq6DceoR4RCFXhXVbf6TrfKcBQXT0ntsC8FAy1OOM3yPYIapdTwjzW912t8U/9n0lVOqK+7v+OQeMF0BBoOl5dY7KHpmJH+ynEi4xkbRwrwXvFm/myX82kQ/EAhnfY7rLnC7lgW7wuoc3AeV80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299911; c=relaxed/simple;
	bh=Z86cdaZkPlGbzuY9lOgbb9I9FQJR8igsJoQv+n7g8zs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=trCrRkcwfssKx8n/ZkCZK6c0rt7Zs4UIy/1e9ilU5SmSxdRedIK/drRq4ORU3jiufReLGbikiP6fNjetnnWqPHurHMzL4V/KsQW0TDTJ2JyXzMFMVMJFrGnhxrR8x0tjjqcPRslo9n79IbdUcS+6d3jX+nvp/ylyVuAUq/S7p3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=meaMWGwE; arc=fail smtp.client-ip=40.93.201.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="meaMWGwE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QfWFQBuX9ON8a+j2ktaxM9IoGXrFZqbiQgRGy/bklWSjz8Urrd1sP+h0lZLENsYbAgmdkCnL2jbfmT6WeOxDjIe5d6OSFsQqkD1rGzWYYWbZXLu25LyaIvINsJLbQfDU3uQqJ2HoE8UF8XpR8HIGWIymp+qb12lD6KYwZ88B+wmAhf8ioMAejzAeKWCo0HiunulMi3SSBmwvk8+tuDl2KCHTuATKVhWjceTE3fhA130Nt/g5j40R6MB8ExJ3/Nh+ssmYE5z6kuZ19mdSpFqWXsV02I39sTn5ViXgRJpkle/0geYLQczj2q/wTzjHIm+bQ6rGt8frfCrzBeaVPXAzOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jxa5YCRL3U0CO6mZpaqEnVEqvWZP1GmqHtOMLJibVVU=;
 b=rpxmW0J9V98kHChSEpaEiH/l+X6D0LARt/3k8sDzBEKFXF2u4RXXH2si2kx22TbiPi2Ghsl+UjdhdfoTZ6xLPHDVEdydGPl7Nh878XFW4vgUct8R3QvDKGrmjX7q0Lw5F0FULsgVWlicE/FBJtbZVmRo4cxNp+IiyVhkdhzi9E2zQrViYFsZzD0g2CDVONjbJ1Oo/YhA0+33nrwwRGj1yp4gex3eEByzffkCwqY04ai6Z4Pzujq05wo4NO06YmC3UFy5d4+RPgRcDN4kiz9QAL9IRyj5A6OZ5vSreVdbiEB4Mem6743lkV5JQrjkpQlqP+/gS90q21A4v6gAs+zmXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jxa5YCRL3U0CO6mZpaqEnVEqvWZP1GmqHtOMLJibVVU=;
 b=meaMWGwE2otin5bJbpWxe9dz2d4+UZtwp2fNwJdkDhgvlU4wqaIKWEB1Hd3/b9+pTGt1NdmizCTdcDGW4TaLmjzqfN69I5bHf+Jnu6tSNsCP1mpQ1yOS4aWnSqBNBx6vgmxya9HQdKyDNi//6B5zBvpzO/+xZFe2TYgvbYRxgEA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB8042.namprd12.prod.outlook.com (2603:10b6:8:141::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Tue, 9 Dec
 2025 17:05:06 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 17:05:06 +0000
Message-ID: <78425800-35f4-4455-8d85-fda6bc8fcded@amd.com>
Date: Tue, 9 Dec 2025 11:05:04 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next] crypto/ccp: sev-dev-tsm: fix use after free in
 sev_tsm_init_locked()
To: Dan Carpenter <dan.carpenter@linaro.org>,
 Alexey Kardashevskiy <aik@amd.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Dan Williams <dan.j.williams@intel.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <aTLEVmFVGWn-Czkc@stanley.mountain>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <aTLEVmFVGWn-Czkc@stanley.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0108.namprd04.prod.outlook.com
 (2603:10b6:806:122::23) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB8042:EE_
X-MS-Office365-Filtering-Correlation-Id: fb4fab97-606a-4c92-fc30-08de374519f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?blZ1b1Q4cGs0NUdhOWRMU3NKWTlDckl1Wkp6clVQTDRZOU1ncExxeGIzZXFs?=
 =?utf-8?B?VEQ3NTJPL0VzbC9qQm8vMEdxMWVFRFhpSnlmd3dBQWdMWHBDZDJiNCsvckpV?=
 =?utf-8?B?eGdqSWgyVUJsVEtGN2lBMElQdzBORENUeDl5NXhveFpDQ3oyT0JZYlZNbnVO?=
 =?utf-8?B?bGhocDRCd1lZb21kZnlXdkM0cHZkRWw1K09vT0JtNUtrc3Z6aGhlK2JGWUUv?=
 =?utf-8?B?NnFXQkc1Z2tpVm1JTDM5Rmt6RlRqLzZhZjg4V25sVUpYZVlPQlliK1U4elpE?=
 =?utf-8?B?WWZMTnZlSnZNSnZQSU9mOFR3cElkaGNpaDhpM2paVUJiNmpZZEMwaFRVVFND?=
 =?utf-8?B?TFl2SnYzaWJhQnZLUTZyejRndXd3UnQ1UEhIWE1ZUktTc1UvakZ2OEJZNVBv?=
 =?utf-8?B?b1pVUHlvMjQ1ZTMzNnBTNFdZcitXdXFnRHdEQVpacXlKN3pySVBiY0VlY1Q0?=
 =?utf-8?B?NHpEalhSVjJzUVQxZGhtdkVKY3daTWZ2K2Fyb2c5SThLL3lhQjZ3UU5OejNu?=
 =?utf-8?B?S2NhY3BPaDNuZldaNTBGN3VkSWRZK0ZhN2c4dEdXT0NSNmdMVWNneGUvb2k5?=
 =?utf-8?B?aFhOR0pSaHl5eTQwYk1jc281ZE1DbmxkQXVvaEtMVm5VTndIQkFlamhFMUZo?=
 =?utf-8?B?YXM4bHF6TlRZMTNsTlNIVy9TY2ZLOUc0TUNtV3ZFRk5seXJpdHZlUStwQlI1?=
 =?utf-8?B?MG54eXNudkI3bXQwQ25TNTdVbEwwbithdklQOUV6MjMwUHV2aS90b3dqb0V4?=
 =?utf-8?B?TkJLY25BYVhzR0lnSG12L2RxT0xoRE0xSXJ2YkpBajh0MzF1K2V0cURIQmpZ?=
 =?utf-8?B?MHZXQnFVeDdKQXppQjFOK3hFdU5jR2RpMlNobFZiYmhld2ZoMFMzYU5JVnBY?=
 =?utf-8?B?NkcwWmR4WVphNnlheTFIR2x6bkRJRE9DUGwvQ21IMVg3YStoZ0J3eUtlU2ky?=
 =?utf-8?B?WEQzeE05Nlg0YXBZNFdyOG1SY25EYVd5QmZwVnJ5K2JDNmc4czk3Mmc0OUxu?=
 =?utf-8?B?Ynp0SkwrUktPRUhiYi8rcmhjbkdGMlJ6ajF2TlhVekVGcHg2SGFNcmExLysw?=
 =?utf-8?B?ejBRK1ZuY01pUFZPVnE3TG1oSGhSTXlKZHpIeVo0VCs2OGl6dmEwTXAvL0pF?=
 =?utf-8?B?dGZqbkliSXlHcGJUVUxnK3NxRFlGeHhTVVBqd3VOdjBBSzJxaWNmcmVKS2dO?=
 =?utf-8?B?L3N4VkNMYzhneUl1bkNSbFFrMGE0cDlYMzhDSXl6Mjd0ZENzQVU3NkI1MlBD?=
 =?utf-8?B?TFozS3dHSTZwVmJUb0ovSURtbHR6d3hBdlM2MkJNNzE0dkRLSnZYamVIZVJW?=
 =?utf-8?B?VzVXall3WG9WNk10bENLRHk4clFXcXlJUjhJVmJBZmEvRlZjV08vNkJYTlVM?=
 =?utf-8?B?d3BGVC9xcGdjZFcyZVlOVzNzQS9QdlRybXFMVy9QdWRJdjdiWklDQ2hmYkhl?=
 =?utf-8?B?SGhYbW5XNUtnSXplaWc4OFJiQXRJN0NoOCs2ZVlNTU1uTWQreTl4SlpCdnFi?=
 =?utf-8?B?OUNBNitZTU1Ec2tiZUJQYndsd29sR1lQVnl0NFRVTUVKR1gzZDA1bVZyaU9J?=
 =?utf-8?B?Q3dKTnpFY1M1LzFrSmJDK2ZoZHRFNUtIcTRHS2IwazZKOFRrZXdkK2tPSGlh?=
 =?utf-8?B?RjQ3OVhENFlueERXZEZ5c3dXbnFGWVM5Q2FDL1ZjZFZhQTI2eUhPMWhwVG9a?=
 =?utf-8?B?eDNaOHF6aTYrR0Faa2lwZTdKTUtXKzJNcXpoOWYvNGM0WjVsbzlDM2VDeXNp?=
 =?utf-8?B?T1V0YWxGVTZqUlNNM0hQeUd4MWF6OFVSdWZGaUJ1QXZMVWJ1UWtKNSs2eGc3?=
 =?utf-8?B?MmZ6b2x4RjhwS2VZQWpRU3NSSWxuWWRMMk84aTlLNTJUY3Nla3NYeXUzcWd2?=
 =?utf-8?B?cXYxd1g1ajJhYlpUc2xkdWZZVUk3cVMwRHdvUkg3RDRkM3IyNVpObXdIMzRp?=
 =?utf-8?Q?4b7PPVpAcJDNVxD/I0xVBaAvFIIoJI1N?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WDZBRng0MHAwWTEySDQrczY5N21XYkQ0MzNjUEdZRXBHaW41MWgrV2p1eU1X?=
 =?utf-8?B?dXZLelF5bUMxOXNLYmI1SmhKSkhienpMMnRqTW1aV0JjUjRveDI5cncvWmhS?=
 =?utf-8?B?V0prTzFPaHVTdm13U3Jndy9vVG0xQ25yNkZvbm5BSjZ5MUI4a0pJZGVrZnBX?=
 =?utf-8?B?ZHByZmxScWpQSTUvS05ZUEJ2TlNuWWJUSHZucUtHQVBGR2tJSGUxVTlza0I0?=
 =?utf-8?B?cUtSK2luYlZKcUhFNjlwL2ZCSm4vTEk1WFVrL0NKLzZLeGZOdEo3bldVaFBC?=
 =?utf-8?B?TmtGc0sxNUw0ejFlbGovWWlERkpKWFpwdk1OY2huUjJ0UWs0NUQzVDVPZ0xM?=
 =?utf-8?B?eTNsbXozNUZ5Yk9yUlh3dWVWTzdMK3U4SUhEY2l0Wmc2NXRqbVRqemQ2clhW?=
 =?utf-8?B?YXhGaFdtenRIdkxpeHB1VU01MEI4RDlVbVJiU3lWTC9kQ2loYTJQTkpKSThY?=
 =?utf-8?B?MzNtZmZxa1IxNStvUy9VT1RIeXVrZ21QcU9qTzh3U1ZyckR4NDVxSWZ5K0JQ?=
 =?utf-8?B?ei9PM1BHaEcwNk56d3JvWDdFbEplSGc4VjNwRXBTTG9QbWZmdU1OaEtVRWhK?=
 =?utf-8?B?RXRBUzQ3RjNUWi9LUk54UXErWENGMldKWHJZMERqckVCSXZVTzNOeGhaYUtB?=
 =?utf-8?B?N1g2Sm5iT3h2NFR6UUp0eHlha1A3VCtzSkJ6MmdTUXJuQWhrZmhHNnBnakNJ?=
 =?utf-8?B?R3dUZ2NKMFQzd3pCT0grOVJQMUZla2Zsd3J1c2trMmtCRHBwNzdUVVI4ZWhr?=
 =?utf-8?B?dW1aT2dWYlRscHRia0tIakQ3RTNYWVBvZ280bk1YamNKZ3FUSFBVZnFwSnh2?=
 =?utf-8?B?Nkxxb2EyVkt5UUV4dWhFMUE0bXNMS1k0VkZxdXdvYnk4OGh3bG5CS2dWWnRO?=
 =?utf-8?B?RHplWm9VZDBYTW5IT28wcE9TSFovMU04RktHeGFiWnBJWC82OFl3Q3hRNi9j?=
 =?utf-8?B?dWk4YXBOR3o4SGhzN1NZOUh4WGlYa3BIKzdyLytSeVh1WGxERWkxS1B4VFlF?=
 =?utf-8?B?TG5hYjYwNW5wVlBvRERZSkRtbzUrZTRNbHMva2pwS29nMzQwcFJmWDRxckFQ?=
 =?utf-8?B?S2NKbXVyd3QyQVFacVhndndyaU5kSjZtTUtYMjdmWWxoYkFIMm9PMVlKUG16?=
 =?utf-8?B?akVFeFhSdHJiQnVuclFURW15czI3c1k4SWhlUzE1WXJ5cnJnVG1PWjFKN2Fs?=
 =?utf-8?B?YmI0dHRTek5ScE9BemFXd01GVTFuR3VKaUFDVTgxVDVSbEtEeVcvSm1URjJG?=
 =?utf-8?B?OHgvZk1sSHhrSTk5QTd4T3JHYXRUSnJ5NENRMkxEVEtMYmpVSUNXaktoNGRp?=
 =?utf-8?B?LzdNa3pWSjRLaXJRMG1Sc2N4VCtrcmZtQUJveDRIKzVoWm1NL280bnhlVW85?=
 =?utf-8?B?OXIrNEVHZThyM2N0eHBQVjVaNk1WRDVrV1FKRkpNU3lWL2ZyTVJDTDNXREdG?=
 =?utf-8?B?N3FaNHlDZ0MrbkxWaHFLZHN6a1ozeEx0K05yMnJKQUFIcDNRU3ppMmFKWWdy?=
 =?utf-8?B?eXF2R3V5RXErYXl5d1Q2MXdJd2pHY2lvNm5OOWV3eUhzUUY0YnhydjFtckhy?=
 =?utf-8?B?VGdlZFI3VmdBczlYVytsZGUyMVNUVkVLaG5hM0N3YXJiL0tZWld3UHFvQzJU?=
 =?utf-8?B?NHNYSmltZC9kbGpCL3hKclArTUpsL1NGeEJtb0lHQjBGSVdadXY0NmVsUUh6?=
 =?utf-8?B?MnJNY2VtUVJaMjl1dEVqZDRHcFA2L2QrSkp3QWJnSnI5dGU5WFkycTNjTnV5?=
 =?utf-8?B?a0c5RjJJYWZQUzlOVTMvbUNLN09LdzlKbk5Nc2ZDMHNvZktBNXVmLzZ5Q09P?=
 =?utf-8?B?bXB6TlJpN0g3NUU0bEJKS2VtVksxZDI4cE1JaVpWbDlLeGpRTkpsS1c1SzJQ?=
 =?utf-8?B?dmFsclp0L2M0SXo0bTVCd3JCVlpIQndIUVo2TXdjek9mb09Vajd2VUFwUzIv?=
 =?utf-8?B?Skt5TW1UMGZPbUdPMGNvY3JWYXJPdGNLenlXWnExMXpRN2R5VlBPTkRVNlJv?=
 =?utf-8?B?RkhsVHRBMTVCTGE5S2pFTjE0d1hsYmd4WGtEcTlTUXZLOGlDaWtaT0xaa1V4?=
 =?utf-8?B?a1UrTUJpR2pucTVQd2NCYmJqMG1qWVFrT0cwQnJTYm1WMFhpMW5Zemt6T0xj?=
 =?utf-8?Q?sJhwZqkTp4fIrtXeBO1W6phFb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb4fab97-606a-4c92-fc30-08de374519f6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 17:05:06.3190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vV+GjOLaz1qIUkKxSWKaDmZx78xigXj+H371r3zi7yNheVpH3BtmlB2VPKEWocKx3afpe88blaIeffmnEjqpLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8042

On 12/5/25 05:39, Dan Carpenter wrote:
> This code frees "t" and then dereferences it on the next line to
> print the error code.  Re-order the code to avoid the use after
> free.
> 
> Fixes: 3532f6154971 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev-tsm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
> index ea29cd5d0ff9..06e9f0bc153e 100644
> --- a/drivers/crypto/ccp/sev-dev-tsm.c
> +++ b/drivers/crypto/ccp/sev-dev-tsm.c
> @@ -391,9 +391,9 @@ void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page)
>  	return;
>  
>  error_exit:
> -	kfree(t);
>  	pr_err("Failed to enable SEV-TIO: ret=%d en=%d initdone=%d SEV=%d\n",
>  	       ret, t->tio_en, t->tio_init_done, boot_cpu_has(X86_FEATURE_SEV));
> +	kfree(t);
>  }
>  
>  void sev_tsm_uninit(struct sev_device *sev)

