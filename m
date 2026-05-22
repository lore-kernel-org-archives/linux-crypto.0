Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012044.outbound.protection.outlook.com [52.101.43.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AD72D12ED;
	Fri, 22 May 2026 01:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779415094; cv=fail; b=pARbvr5EGA3NF9jM2d6R5yyJgDOG/I4zp+zC+LQ4Nn10TbPXeXbadRXFWDrU1CKLd340faKRd8FdqYkMtG8dgVhmgOte49568M/Jr1fwYJIhTFnFUXyy3loor9rjY/mSPCjGNMnvZWCgM5ol0z/PWMhJSRHieSJS9OgB8rNEGRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779415094; c=relaxed/simple;
	bh=NwUHdXHlMfR61/kzdGrOeHheHjLQuJ7E3ho0z6u7TvQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N8QXRmTsBW6zSWjGLxakp+mKRIa/zsgjwTNZ1f4fQtwUDniZ15/kBXivGc60SxhYI82c9zMA0f2sRqJJ1QG1ao9HPy4GpXtIvLS92BMibiVh8tDvdmOzSqltJAOva9ecVcroqETjLiE/Qs7hQgJD6QfSa7sFvJTucYSOFnCC9Xc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Jc7bgwUE; arc=fail smtp.client-ip=52.101.43.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Jc7bgwUE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PoUV/pI7ep2O6YsJ4zk/2PL0p9DnA0qaK1Er8WKPsSEYZCgekVcZxWUCevRwZLIGaRks4BKHaN8qfvqk6/Dx+SCJVOH+Mj1Yyd+ga5eeqPgfoa/p4D9UEQ83ByvVWOhAlnZgoc6dyc5x4JInpQDQ1eMe7NOROwOTBMY73dlmd1no+fWCcLp9ypWJCqtssIyz0ZK2zk0PbV+tV6DWHpRPpJD5q57+IzsyrMKm1CU/SmZRFFmgUaJj385q9+PEMCdGKOivJtM9tpf8JYk6n/z7QGVm63LBTjBXBXpmUVux57HfiDhfdr0IiH9a9nuWRuaoz80hCF6w7T9b8aqSk8ZCug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZIoYvyeiGIAuzTu9bMWtR1csQ0z7cGWxK9drnfGa6gg=;
 b=J6Yku5a/mJIcKiG+b4vACJqpjQuiBYL23mu6Mf7sRyZ0gq/5AbsiNpfC6LbOJQbX197I3stdBlSZVfki2ApN8xaMN0MUpM5IEDUQsYIwea0w709WXHfkpku/wwONd6mxwvSU+9kpGsQXR6+VO31ed0YAexyrepC8TTE04fe5cyPUuttpTS/bmdbad2ISy50VcZovSCuqzGN7vHCAYKfDGm1nVzdDgg5QslY8msh4xaoPchKVOnk7jWKJ4p9wBFq+NbMg/YyixGmiAd7F33PkFc/ZlrmGiakLghUdH+5i1TCS7cD33GISxbpkgEfG3zUHkkta+IpU0eJ/LbUQdKSQ/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZIoYvyeiGIAuzTu9bMWtR1csQ0z7cGWxK9drnfGa6gg=;
 b=Jc7bgwUEtuWsnGzHkM6hInN54HZDAZnNHIAbLHeHYdoG1PZRnYlLRIFj1BKiSAcfFk9Cb6A3nG6rEflj0l9k36SqhHX/dxjJuun71WBYHUMlK/wzJ2d1tKwNxpA1MdGjIoWOXoRqxWcFfOLjkNCIuft4UYPEAhYeeamVVzGZCRk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by MN0PR12MB6128.namprd12.prod.outlook.com (2603:10b6:208:3c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Fri, 22 May
 2026 01:58:10 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3%5]) with mapi id 15.21.0048.016; Fri, 22 May 2026
 01:58:09 +0000
Message-ID: <8375f32a-f8fe-4681-821b-e1f17fbafb29@amd.com>
Date: Thu, 21 May 2026 21:58:06 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
To: Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>
Cc: ashish.kalra@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, aik@amd.com, nikunj@amd.com,
 michael.roth@amd.com
References: <36137b565d183fa2f2985ad098f2e2096f1c432f.1779219958.git.prsampat@amd.com>
 <6d5fd5eb-e54c-47fd-943a-6d03aaafe243@amd.com>
 <4ccf6dc7-88e6-488c-8314-5bcd95164661@amd.com>
 <b02682e5-8890-454a-ab75-fff1b6566922@amd.com> <ag8c3v3GjWLWz-OS@tycho.pizza>
 <4362cbe9-b9a6-42c8-8066-807e4a82c7e5@amd.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <4362cbe9-b9a6-42c8-8066-807e4a82c7e5@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR17CA0018.namprd17.prod.outlook.com
 (2603:10b6:610:53::28) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|MN0PR12MB6128:EE_
X-MS-Office365-Filtering-Correlation-Id: 90fd3754-3c0c-49bd-ca5a-08deb7a592eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|56012099003|22082099003|4143699003|5023799004|3023799007|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	aTVbd3rBWg/HAlT+sa8JF7ugmqpw1/hq5oTcRtupz11XfJCnDdRxS0v99s1URjt4sFvePl+bkcIBM9rfWav5VuQNBodtX/vaXIHic+2oF+Ha558AQBfA23Tcyz+81Bin9ZZrZJx+cCBrkLRArIDapPXtmhW8IOt9MERrM6WbZ276CR/vmeZyLq7WJunJT6AjJpRQELJmd6Oiyy+c6dZjtjr39EdGGMeLzVuVm1l/RVLtK2BbayGGWnLr8NBO9k5Cyx/W8umPB/1rLSBHNeegbmMLjs1Y4sAXVU6QMdWkUKM+Am+eyN0zSqW0krVGLfrtn2Mjfe+5vF4eEeDhUWdGq3EGCAyyVYFpJ6UhcRfH0UGBGsBOIBq+8qZfFqaQfZAPI/EY19k5bL/hvdzES8sFdEJowVehjPnwkmdTa6enXonUV4AfmbST6QMc6FfqtSPTA4Z2AcdSmtsBB8q2A8nQ4qc1oBCm/M2khSH0KhJxyjl1KZ5asjMzGTfyGlu/H2hzjkFPb80WmCK1nhTaOejrZl3uhdAx+YhxejArdX0b23HkPDDMJDwGPOU4HXZretdQIPJGRgIoud9r/z78TqLP5g9KPjHSQMhBcdyl/LXMP6tc41kzel8ohPkdSsj2Cutjyaww4xCKwCAoo5ljRVPyDSpFZV/SuN1QVvnLN3ZV44A060npMyRzYk0NtP/etsvbR3QJ0pP0JSiGJ3XHIoz0wg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(56012099003)(22082099003)(4143699003)(5023799004)(3023799007)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SERXTHBkS1I3aWdHN2g5aEYvbmh5TUZ1NWI4UCtqK0V0MmhYQ3FoaTh0ZUJn?=
 =?utf-8?B?Ulc1Yjk0OFZ2bkVyZ3FDNnBCaHIxWCtMemVOdmtmQUk2anNCUFhMUjhWZTdM?=
 =?utf-8?B?VUJ5dG1MRDNwbktUeXI5bzhRcFZ0c1dmVHNBWUhNcXlLcnNOTEZTYTlzMG9l?=
 =?utf-8?B?eXVBWjJxUmpwbmZ0QkNiNEIzUzR5NWpMbW83S0IyZXF0L2x3aHJSVzZJUml4?=
 =?utf-8?B?NUJHRHAvVnpETzZkaWtmQVlGV3o4bzlFWkpLRGNEeEl5dERITWhmOG1wNThs?=
 =?utf-8?B?d2dURXRxZUNUZnN1UVFWdXhtcGtMTGJjREx5ckgzMmZ6anVHZTNKbWtYanNz?=
 =?utf-8?B?UlJKMVNTTWoycHZkYXZPMExGMm9WVzMzeUNpN1RNSysyamVibkhJYmRxQXJ2?=
 =?utf-8?B?azBkWjJVT1VSZHFwOVQ3aS9qVktrdlg0Zm9HK1pWL041S0VaaEIwWEc0aVpr?=
 =?utf-8?B?MDdKdExJdFprZ0t5VGZTS1Z3dnlmSHY5S3Bkd1JpWHVWTVdNek9JeDdvcDZK?=
 =?utf-8?B?U0xJaW1wZTd1S28yUDBHYVZKRHZpcDRuaHk1TFVkS0RjQTBKelBZdjU3b3g0?=
 =?utf-8?B?YXZzOEloZ0tJOElaM296MXpRcERRUERWU3lZQ21lNnRiUGVpU2I3N0V2L3c1?=
 =?utf-8?B?YmFCUzVRcSs1TUMrWFF6dGJnaE55QVNCUXVzcklHczFtV0RRVUVkU04zek5t?=
 =?utf-8?B?M1VpUmFYTVJCdFdQZ0cvR3AvcS9yRFUxd0pLK2FDdEkvcGVsUlJnQUJXazAy?=
 =?utf-8?B?cHk2NHlBTWNlWmF6cU92TkJ5eUtEaE9UbFExUklDdHZVSmUvcXIxOHdhMElS?=
 =?utf-8?B?SjZOV21yQ3BaL0J1eVE2WGZwTUlpOWxqc0Z6b3M5WGprbENFcTI2VnFYRFhN?=
 =?utf-8?B?S2Q4blpXTDlJUXdnQ2ZRM0QrditPSWYyK04yNUM3eTQ5VmxqWldmTXozeHVT?=
 =?utf-8?B?aWhkaUhaU2t2eXBtVFhMeU1WeGlWanlJS2NtVlkvZ0QrdTZKaGhxYmQzcXM1?=
 =?utf-8?B?MldXYk40S2hRVU50V0dCaUhDd0NPcjd6TlNPNS9VN3hKaTBVbHpWY3JuTHJD?=
 =?utf-8?B?bWZ4Wk5McU4veWdERmVpVmgzclFCbkxmbmR0TTJ6YzJWYXdRNzJuL3N2Rk1H?=
 =?utf-8?B?WkNyUHNmSGk3OENhbjJTdGFJZ0p4ZFJBeHBVZzM3cHhmNWgxc1BtSTY2L0N5?=
 =?utf-8?B?T25LS05oUk9GblFUcmphS3pNSnI0TDF0RW5XWTdZYlJFL3NNNnRXTmFwcFRt?=
 =?utf-8?B?Q21xeW52c0dnMGU4bm1oQkhJWm9laGFtQU84S09qUHBUV1UwZDVyeWpubnpK?=
 =?utf-8?B?RzV1WGdBamFJblBVL2JWTFRhM2NhOStSdDE3eHRjcFp6QklBYXNSQlA0Sisy?=
 =?utf-8?B?V29ZUTkyMGh5a0NJT1BwODNxZlY5MVkxUW1qcFJaR0JJOXd4QkRFVkdJeStv?=
 =?utf-8?B?R25KVk4yb0hkMmNnODJVSkszdGJFMDJVUkhZMmQ0aUl4MXhhcGJpbzBSc2Fn?=
 =?utf-8?B?cjhvK3NNNGtKTllBbWxXZFlEOHRRRU9qU0NHYmRLSGdpczdpdE00MW1KMjli?=
 =?utf-8?B?UGZtelYrVE5SMWs2WTk2bHlaY1BLamMxYVg2UzAydzZ3Y3dVRnNHUXFZLzMv?=
 =?utf-8?B?Nm5yR3dWUWQrVEx0SzVZM0ZtVjhYMEx5RENEa1JtOG1heDZLTHFJVlZEZWVT?=
 =?utf-8?B?Z0dKeTdIczRJR2Y3UjJlb2RFeWJkbUx2NndqenZNVzcrSDVXNStQSVdOY29i?=
 =?utf-8?B?LzNJbTNiWHdiVEJUM0QyZGMwWC9EMyt6ODdzR2s1QzdEV0E5N3NKR1BMUkFr?=
 =?utf-8?B?bWdOdXNNcDYxTk56STVNZUJPUmJsVm40bVIwMXVncEdhaDhNSlM2c0tWZ0tr?=
 =?utf-8?B?NmFlRDNHS2tNMnEzUVZ2MG96VXVJY2lJb1hZQ3FnOWJqaUpIcnRZSG5FZWlQ?=
 =?utf-8?B?eGxBZXloQWdpUHE4ZzBSN2c0K2VqWkRwZzI4WEllTjJFYmRURURvR0JNd2Zt?=
 =?utf-8?B?UHhwZGdnU3BQbWhpZkZERit0RC9vSFJwVHh1NEE0UkpMWnQ3ZnNWb2IxSXpU?=
 =?utf-8?B?d2FqcGpWcEt3UnFJeFI2c0ZVd2Q0M0VwbzVwOUh4SVk2eGVudTJtazBUbnBs?=
 =?utf-8?B?aWl0RnFxVGg4Q3ZEem9sL2dSSHBvV1pTdGdHWjZyc3AvaGdMM1AxR05mYldn?=
 =?utf-8?B?c3lQSEYvNzVYMDVBamwrbjJjeGZSMS95cmRqRWtEa0NOSGZHQUk5anloanov?=
 =?utf-8?B?L3dwREpOMmpPK2FRdnlGS1RleXFnNWFkZGRRUVRmNTFIS2JKVUtXemFvemZZ?=
 =?utf-8?B?Z3dOZDlOZEtkKyt0YTRCTmJ4ckRnUlpzelZvcHd3S0Vqc2tpbTVBQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90fd3754-3c0c-49bd-ca5a-08deb7a592eb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2026 01:58:09.7065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X9pgYTM5niDgqs5fwRGjG/HDYXcSaCs2Hwqg6futcYzK+aC7DDmZDF6pQF/TEEEsi7tLaBvzyRo10jBWtJPxZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6128



On 5/21/26 4:04 PM, Tom Lendacky wrote:
> On 5/21/26 10:05, Tycho Andersen wrote:
>> On Thu, May 21, 2026 at 08:12:52AM -0500, Tom Lendacky wrote:
>>>> Now, with unregister no longer protected by sev_cmd_mutex, a concurrent init
>>>> can race with shutdown on the sysfs lifetime like so:
>>>
>>> Can it? Can init and shutdown race? Isn't that part of module load /
>>> unload, I'm not sure how they can race...
>>
>> That's only true after
>> https://lore.kernel.org/all/20260504165147.1615643-5-tycho@kernel.org/
>> right? Before that, if the first init failed, you could trigger a
>> re-init via ioctl(), and presumably trigger the race sashiko is
>> complaining about by spamming ioctl() + sysfs writes on separate
>> threads.

Yes, this is the race I had in mind and probably what sashiko complained about
in it's review too. I missed this patch from earlier. This should avoid any
racing.

>>
>>>> t1                                 | t2
>>>> ---------------------------------- | ----------------------------------
>>>> sev_firmware_shutdown()            | sev_platform_init()
>>>>   unregister_verify_mitigation()   |   register_verify_mitigation()
>>>>     sysfs_remove_group()           |     sysfs_create_group()
>>>>
>>>> Both sides touch sev->verify_mit without serialization. The same race also
>>>> exists for init vs init which is no longer covered by sev_cmd_mutex once
>>>> register moves outside it.
>>>
>>> I don't think you can have init vs init race, can you? This just all seems
>>> odd to me. Have you created all these race scenarios to test this out?
>>>
>>> Would putting the regsiter/unregister under the sev_cmd_mutex and then
>>> taking the sev_cmd_mutex upon entry to _show()/_store() fix all this?
>>> After obtaining the mutex in _show()/_store(), you check for
>>> sev->verify_mit and return an error if NULL. Then you can use the
>>> __sev_do_cmd_locked() to issue any commands.
>>
>> As long as sysfs_remove_group() happens before
>> __sev_firmware_shutdown() it seems like it should be fine since sysfs
>> will do its own synchronization. IIUC we might not need this locking
>> at all assuming the above is applied?
> 
> That's what I'm thinking. I'll let Pratik confirm.
> 

Yes, sysfs should do its own synchronization and I'm assuming this means that we
don't need any locks anymore and I can get rid of the sev_mit_sysfs_mutex and
move unregister outside the sev_cmd_mutex.

I tested this with putting a msleep() in the _show()/_store() and in parallel
rmmod calling shutdown. This seems to work without issues whereas with the
former approach I could deadlock waiting on sev_cmd_mutex.

> 
>>> Also, on the register function, all you need is the check for
>>> !(sev->snp_feat_info_0.ecx & SNP_VERIFY_MITIGATION_SUPPORTED) since if
>>> !sev->snp_plat_status.feature_info is true, so is this this check. And, as
>>> the spec says, the required firmware state is based on the mitigation
>>> requirements, so I don't think you should be checking for snp_initialized.

Ack, will just keep the SNP_VERIFY_MITIGATION_SUPPORTED check in the next
iteration.

Thanks Tom and Tycho!
--Pratik

> Thanks,
> Tom
> 
>>
>> Tycho
> 

