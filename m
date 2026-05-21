Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011048.outbound.protection.outlook.com [52.101.57.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A283172621;
	Thu, 21 May 2026 20:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779393857; cv=fail; b=dOTJO2ISmlx8ZpP3CR5K9FJ+xtAZjDgFa4FarmYS0/6IAXX+1w5T5aJUXVpD6lebiyAsd2PMnqWRawP60QEPgYYcIR4jMpfrXBTMgfN3Rt06SPdfVlyS2nYnaFsx5QI0CvlGP26O/0r6/bZY9P4MnnM2WFGzwm7ws8mfLmNWMlc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779393857; c=relaxed/simple;
	bh=AJ4O9OUyjv4IjgmzHmGLGCTly+Bz7H9wt2+e/ikcUTs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=klkezCJz4OeTrk0G8Ug58Z71W7xB1uMtFq5MSL+/k/OEkGCPFoy2JCIprUzlSSba11iw7FS9HgNp45hCxOn5vby75r55+6YE+TWj0FNdP1ludlvO04MU91VUckVH2gF6QhgwG84o76jXmw6r3J4Sdd+dbIfaNz4hLGNqQ6rKKK0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zgJGUsHg; arc=fail smtp.client-ip=52.101.57.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zgJGUsHg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W5v6bdWs57QEhlUnGOPgkCvvsIbVZ28mDUc389UpVL79By+8UZnDihWxEXA+Zwml9/ey9xcQ/JVmS5KtY4cKgZh0QY1Kqj/OQ4W+eN+NsSmPU5mpAi90LlW3fQn8iI9OJhZIbUyaIJrZK3MrgNpf2iQnfN+RzhQ4Y87QtBV0rx8PAeBrkta1qKsZ1zuA/mQ5qxpaKNgjCBvNqZp7g1GDVDQ9/uCJX/8SSDq3VnDKtyntf2lKtjrlatccgCxtgJ4UIR6UjqnYQ7gJT60Zh3cOHYf+ScZQ0q1hTrrJ3A6Sx7lqa9zbIq2CmUVg2XZGDpJ4FhjBxVvjS2vu4V6yDRwVYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ZtfwHM5K2YVxaEpNYq3/lvSztNtT8K8KYTPAdz0Fh8=;
 b=Q/LDOI4xF9nlXNWDwDWvH4R9vBD5wOvFXp0hyccYH8vaV1hc5q/BcmzEs+zHs04IleTOJi64kbTlUS7fJHemSpUrzWJId8mvlJVdvKMyLrhu6XDjbVTzQQRo7K8TxQBCGGWzC/LcXUcmj/ZbDGiIo0LbiYMyr4+ubOK/Sa6a3x1cddXDs4oe5u1rrBUHRJ9m91S7iMJwZCJBZVZOo95Dfd3iRXOgMbikzkKzUrEnM2BHZQ4jzHWOvfxL11pS6neooy063tJFFjyzDumnMekMJys8ciSO19O5Jwj+N0qeSZKoH9aWyMNsMtO78lqi0lo0ohJ9vP+dB88xssTJEK/gaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZtfwHM5K2YVxaEpNYq3/lvSztNtT8K8KYTPAdz0Fh8=;
 b=zgJGUsHgCqOnxJXTo1QmqhGH1/dba1HskCnotMlfz8pFCFkrEwn4BdpEPjf1JKRsvJvvaoZEVUr6CXzRzu8gdUgXsoL+jnHrpd2vfJr4+YltgSkU2v9MYcuWxvVi2f42sSLde0sR7JjY8FWRABMW5jAhqedsstsxPF1qIZp26AI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB9193.namprd12.prod.outlook.com (2603:10b6:610:195::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.24; Thu, 21 May
 2026 20:04:11 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9870.023; Thu, 21 May 2026
 20:04:11 +0000
Message-ID: <4362cbe9-b9a6-42c8-8066-807e4a82c7e5@amd.com>
Date: Thu, 21 May 2026 15:04:09 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
To: Tycho Andersen <tycho@kernel.org>
Cc: "Pratik R. Sampat" <prsampat@amd.com>, ashish.kalra@amd.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, aik@amd.com,
 nikunj@amd.com, michael.roth@amd.com
References: <36137b565d183fa2f2985ad098f2e2096f1c432f.1779219958.git.prsampat@amd.com>
 <6d5fd5eb-e54c-47fd-943a-6d03aaafe243@amd.com>
 <4ccf6dc7-88e6-488c-8314-5bcd95164661@amd.com>
 <b02682e5-8890-454a-ab75-fff1b6566922@amd.com> <ag8c3v3GjWLWz-OS@tycho.pizza>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <ag8c3v3GjWLWz-OS@tycho.pizza>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0087.namprd03.prod.outlook.com
 (2603:10b6:610:cc::32) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB9193:EE_
X-MS-Office365-Filtering-Correlation-Id: abf0863d-4c4e-431e-b101-08deb7741fca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|3023799007|11063799006|5023799004|6133799003|22082099003|18002099003|56012099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	Rp08R/CVLLJ5zabNaCENf9eVQxdWuAm89+J3PJ8NbqdFtjqmQg0lR4uvMnEQA8AwlPrrucby1gMnaJUeEwgE70PgOw1lRLUOv4cdcpU/gtVc0h48JqMQS0+8SSY85MlHJGgOZK0t3ZlBkGFyKSt7PaH0EauriBKx1Ct989bB3vsUI/Tb7HGCSZZ5DBj6+F7U5ijXjBh1Y3M/F5XpXwDFOSUd1TAWzva3akDsfsghnvq/kcqlaKCNEMsTbEhn59loBdWUmdvpo8zi+H4vHIy1Omu0dgjfzbT2rVNR/CQplCz5iFotCNqKdnS5apNIH7njU8xBO4Uuh0BiYrwLywOnQvZLUKT+d+5WR2ihwj/Tuen6oH+piBlzczDMAmeyXixqYCqx6n61OxNxRIKCpBt7Q0/izT/cvUgebjyiJmr4TSKoXKuIAVBoruDY6N+BVb/am5N2USiTuGY/J1LtOa1XAgplwFth152ZJyamZ9XZ0z5nScMTh2X2DxQpi+qmNW1h7liLRxclX0NcMr7mzxg7vYi99sVg/OS4D9ftdsT1FwouCBH5Aac0uu2SalqXUgXMqC3dUQjUmyvhj8URoGnvNEG89/6bnohehK3xjWTDgSm388RiiYH9U5EZnsRTQ5a7amIuc/yqq6jQ8gCWjyRuIs/D0piwudJNOUpIfCq3pzci6dFmz2h0YV8M+igXfA1SOYj1fy/1Ma+u5scPSQzvTw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(3023799007)(11063799006)(5023799004)(6133799003)(22082099003)(18002099003)(56012099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QzZ4NGpYZ3JnRGhmMjVPUVNpQ2RUMW1Wd2JTdCtxa1Vwb2pxY1p2SUxjTXJD?=
 =?utf-8?B?R1pSNmlwNEhFWHhHVm1aUzN2ODA2ZFR3SFhRazQ5ZVNycHJTcHM3WHFsVndM?=
 =?utf-8?B?L0hQNjJHcjlDSXRWUC9veFhsZ1hHN3lzOWZnOXBnZ1drM3Q0cUhLSVRIelRC?=
 =?utf-8?B?NkdzYVZDaDhneElyTUI3V3VJbnJsdDM1WFVEeElOYjMyUjlmUlBwY0pWTXN2?=
 =?utf-8?B?MFRjWSswRncwejhuemI5RW1oYWkrd0hwSGJxc0dKbDZJNDlabENuL3RKWmVC?=
 =?utf-8?B?anlWdjNSYyt5ejVBRHlxaFZZSnRpTEx0WjFyS25WU3VBR2w1WnFyUHkvdmtq?=
 =?utf-8?B?UzFwcDg5aVZlNlhCY3F4d3VCKzFTYUV2NzErdEQrcjRFeHhHRG1DUnpBTFJU?=
 =?utf-8?B?N3d1OURnbVVwb2JCNnhDRHVMaWpqVnNlR0hTSzFXaHFnS1hXNHhmWk9WT0VQ?=
 =?utf-8?B?eUtJNnM3UlBCSTRYNnhtTnMzNXFkMnUxVDhKQnRVcTg3WWg0T2N5MDIzOXBJ?=
 =?utf-8?B?dTFXeEZEQWJlaXRWU1RUOUdSMktSeG1SMkswTWlaRHBVVzN0LzJrQTB2bXky?=
 =?utf-8?B?Q3ZMckU5NGV6L3A2WEJRVFRCZGpibkxGb3Z5SklBVkp4OGZYS2FEZjFXVGE3?=
 =?utf-8?B?ZytneXZkWlZsSnhCclhtWWpqWDZNRXVQWkMvUVFSZ1JMbnNvTUM2cHR6Y3Br?=
 =?utf-8?B?Z2NsRzc5amkrN2NzejAweDhRdTZCSVVVcHliWGlQZWhjSDhFRHN6OVhGRHBt?=
 =?utf-8?B?WGVybytQM1phdS8rbHhJd0tTTkdnSVU3Yk9yb2poaEhIWEtnbmFzdFNFN0hK?=
 =?utf-8?B?KzVXWnRVaWRGRXN5dVZ6cy8rb084K2hqUUFlNWt6eGZNay8zWVVqTFhwYTZk?=
 =?utf-8?B?ZmdvcStCUFVQdjhPYndGOWp4YjVEVGR1aWlTTkdJa0JaOWlTYjRFRG4rUWRP?=
 =?utf-8?B?YWlFUGhWTWtkc1FsVkJkckhWcXVETVR3aytkL2lBQ2Z4TUNNNkEvRjVVQWoy?=
 =?utf-8?B?ZUNNaVdOOGNHSzFsZVIyTHhmNGo4WHRSWmYvalo1SG8xZTBHN1B2dVZxMjNI?=
 =?utf-8?B?ODdJaWh2ZmJ5bml0RHpVRm0xTVNIZEh0VVV2aHVBS0FSUDF3ay8wVzhjS2pv?=
 =?utf-8?B?REUzTHJXVmFhQ0VvaWJtUmlZZEZWd05Db0lmZWwxNytweHpYWVRvdlRBNDJi?=
 =?utf-8?B?aTdIZmRCaHNsbUNiV0syYWNlbFhScnNpOE9mRFpQcUpJTk1ETkEwOVNOdjU4?=
 =?utf-8?B?N2pubmR3dS9adWlGWksySDU4QS9aaVpGTXM5WkNzODdidHVrNHZmQk9aOTVq?=
 =?utf-8?B?K01ScTdzQy9TeGlyMnRPaVZaTlROY1BSNkRzMUJ2Q1ZyUnNhMGJ3enorRzlk?=
 =?utf-8?B?WHhPelFzQysvaVR5eENxVVg4MWFuVnppY3g1UzNJRjZEUUNZLzFYWFRQcjNa?=
 =?utf-8?B?YlJVYnF6ZlJ2OGQ1eTBqRUVyQllKOU5BaXIwa2hEYUhCNkJDK21HbFBKZVdI?=
 =?utf-8?B?UkZOYzhVT3JIRGkzNHBQRnRFbmFzTkRvQ3ZvN0cwZXRETE81Q3JVSkpWZjVC?=
 =?utf-8?B?KytYZnBSdHkrZkJUTkxhbFZvRndGL2RHOVh3L1dpN0ROQ3QwaUtlTm1DaXI2?=
 =?utf-8?B?dGp1N1htdEpacXQ3KzRIRzZNbEIwUm9zT0dUYW0yYzdLeklpd3NmaWNLaTRF?=
 =?utf-8?B?Q01OckJTVXp6WWd1T1NaSkE0K0FPRkRFeTRLS2ZieG9QU29TWGdkQm84YlU2?=
 =?utf-8?B?dTdhMzlNU1hKQ3BwblZPWU9YNTU4a3VZbHV3MGoydld2WElPdG1LZGZVKzFD?=
 =?utf-8?B?Rm5pclJxZWNkdXUyM013WDZGbWxiem5oajhOcFhONkhmaEVFeWJrU1BjZW5K?=
 =?utf-8?B?cTdxK1hqSU9mRFp1Y0NBREUzWXRkSWFsaUJ0NnhYN00xTEY5Zlh5VEovSTFE?=
 =?utf-8?B?Q1crL2FwY3FqVVNDUlVNcENaTzIxVlFLS1Z6elYyTHI3M0NQN0QyM2tYQk4y?=
 =?utf-8?B?V05TRGIrM1dmNjczdm5CSGRtWjdpZWRVVE96djgwVEtFVmJOdVZ1MXZHcWk1?=
 =?utf-8?B?bERmdldQT0pBSys1Nk44bmMweVkrOFBwd0JEdUtoV3Y0QytBc2lVRzRoc3Fj?=
 =?utf-8?B?Zk5XS053UHVBK21SazNhZ1E2UUoxNU8yRlQ0bEt6WURJbklxT3BtZld6Mmhi?=
 =?utf-8?B?dDFXN1JLR1YzSHNXd1p6bGpYb2VzYjRvSEd6dXZXcDhUTkdXa0JtZUNoV20w?=
 =?utf-8?B?bmpxcEdsWlduMkJKTm93OTQ4WXFJcHpUWWgwMG5FZC96RnJXZmFWaFljQjJE?=
 =?utf-8?Q?hXwdtZ2ojUfV0TR5qt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abf0863d-4c4e-431e-b101-08deb7741fca
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 20:04:11.2922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mylLYoVEy7PBIvBBafkLRtzfIQ2o1ZdxJXF8uLh/ceS9oKKultPuw23/rEBb1OJXJ3FS0irNUBVOX96QnI7tTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9193

On 5/21/26 10:05, Tycho Andersen wrote:
> On Thu, May 21, 2026 at 08:12:52AM -0500, Tom Lendacky wrote:
>>> Now, with unregister no longer protected by sev_cmd_mutex, a concurrent init
>>> can race with shutdown on the sysfs lifetime like so:
>>
>> Can it? Can init and shutdown race? Isn't that part of module load /
>> unload, I'm not sure how they can race...
> 
> That's only true after
> https://lore.kernel.org/all/20260504165147.1615643-5-tycho@kernel.org/
> right? Before that, if the first init failed, you could trigger a
> re-init via ioctl(), and presumably trigger the race sashiko is
> complaining about by spamming ioctl() + sysfs writes on separate
> threads.
> 
>>> t1                                 | t2
>>> ---------------------------------- | ----------------------------------
>>> sev_firmware_shutdown()            | sev_platform_init()
>>>   unregister_verify_mitigation()   |   register_verify_mitigation()
>>>     sysfs_remove_group()           |     sysfs_create_group()
>>>
>>> Both sides touch sev->verify_mit without serialization. The same race also
>>> exists for init vs init which is no longer covered by sev_cmd_mutex once
>>> register moves outside it.
>>
>> I don't think you can have init vs init race, can you? This just all seems
>> odd to me. Have you created all these race scenarios to test this out?
>>
>> Would putting the regsiter/unregister under the sev_cmd_mutex and then
>> taking the sev_cmd_mutex upon entry to _show()/_store() fix all this?
>> After obtaining the mutex in _show()/_store(), you check for
>> sev->verify_mit and return an error if NULL. Then you can use the
>> __sev_do_cmd_locked() to issue any commands.
> 
> As long as sysfs_remove_group() happens before
> __sev_firmware_shutdown() it seems like it should be fine since sysfs
> will do its own synchronization. IIUC we might not need this locking
> at all assuming the above is applied?

That's what I'm thinking. I'll let Pratik confirm.

Thanks,
Tom

> 
> Tycho

