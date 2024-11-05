Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2078.outbound.protection.outlook.com [40.107.236.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A2313CFA8;
	Tue,  5 Nov 2024 21:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730843930; cv=fail; b=n31784X6lnGLkUKptjMXQyUQBcXY1NfU4+/MqDY5ArKVXQ2E3r21U41LtnhzvwnldCNy2MCCFfFBkeg2qRrSxuuaVslvZW2JeQtmdPHx4aBcURrnLgqSnHi6YKRIt8VqYdP0sWoXoS47B+9adDQkKry6Jx7dLc7Xm/XbZPfM5Lk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730843930; c=relaxed/simple;
	bh=01u3AUsDZtZ9Erfd9VZR9bNKYm6ehD5e+48k6Jv6lcc=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=KlRjd8AM3Sva8sc1ynvqbNuYb0W5dbfPXMCa69A2zTfziNlOtBoKZ79ksDiPNhgNelVt7dPYIw3cPCBcd+OT6k+25Ui6QvxAeJFAkxpmxBCxHu7tC3KwveXp6t3uF8tcELsSWraXK82xFzkrhgOu9O/4a7mJ9fbVF1hN4xAQNZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fzzuY5b4; arc=fail smtp.client-ip=40.107.236.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fzzuY5b4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LWZq7YMQqXoAQUbT7/zcU/WoHUSpYwhR10bkqLkrOw5C+RKGilpENtUb/nMsbGI38xwqsTJlF0SSArEmhd/DeKx85fI7aqRHG0dGfVOyrEX3Z0eGvETBY0w1qZ+1Y1Kz25+ptj0EtwAKmQbn9yfzTa/TbUGw9eFprwDj1nH7IDDu2yP9C4WdxKjIsiMyeqMI3+dmOKs61BOXME1/3zlzpnHxoa9B+xi8eJZUCE97uZw8uI0lEvXB3cx8sh1ZwmV3GB3G1eVh6PVPP10BwvwXyyFytMbI24vmg3wkJoKKxocQtIsXCSrTu9DvEOIk7k28HRdeK44W1vqQsL692CY9BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7DtbRl3+v0x0LvCtxgL9B9Sxb3ZwQ3IMCRVw402SGs=;
 b=O3aF7Ercx4yp4ljpzlLqlRlxfpjRP8PVQzGFh51jX+bbnQYxhQTXAQ1Oop9gkUWE0U+FjwfXNLOALG3btmim/folL2PAte+xMjOIvx71rHOC4FraBS/bLEzbXk5O66CYnLom6Zd4sAvNGf3OXmCtYadr7GOamiSvjc0FAocJJq9zLjJOcKDcOF1kNjptcDU8IL9auWxRo2E5XckxFigLBVU/ZGrGNKqdn8CXYPcXA2EP5EMMABOUoccgLz1CNVlAWmIhGjl52JauXs57RViY0w/SuyXiWQb0XLZFOO8Crw9kzY7TfQvOkwxUqyI5c641Fu6n5A1zbLZlw+rVH8CLsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7DtbRl3+v0x0LvCtxgL9B9Sxb3ZwQ3IMCRVw402SGs=;
 b=fzzuY5b4A8dDIPvKaf4PJF7VxezKnbWzod6ZmpIsOYXW3Ni7uvdPaBWkdFtSqgss4bg5g89xeuZO6pO7I532/BxFD70+eXlyX4nLv3MCiWtXf4zcqeufXvlBzLsVEPmkHbBCHzjUoE6s6gzhMGTsQ/2a9cxko4ajGTcrh+0T0kQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV8PR12MB9229.namprd12.prod.outlook.com (2603:10b6:408:191::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 21:58:45 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8114.031; Tue, 5 Nov 2024
 21:58:45 +0000
Message-ID: <f6810eb0-3834-e5b4-6c1f-9422dfff5560@amd.com>
Date: Tue, 5 Nov 2024 15:58:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Dionna Glaze <dionnaglaze@google.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Michael Roth
 <michael.roth@amd.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-crypto@vger.kernel.org
References: <20241105010558.1266699-1-dionnaglaze@google.com>
 <20241105010558.1266699-5-dionnaglaze@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v4 4/6] crypto: ccp: Add DOWNLOAD_FIRMWARE_EX support
In-Reply-To: <20241105010558.1266699-5-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0111.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV8PR12MB9229:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f31b00d-0e3f-4a07-4b9d-08dcfde50522
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TjA0YlYwQTVwMUNZMG0xZXoxbG1iQVBRY3RCcnBDWjRLT3FiL3E3UUI0d0J0?=
 =?utf-8?B?UWF1QWdUOGFPYzF1RzVBdlVtQXo0UGExcVBoSDNlOWcvNkRzdC92bkFVUXFS?=
 =?utf-8?B?OUFUNDNCR2JiVFRjdmFla0pPQnJLa1l6RDU0bWVBc01CQjZqUWNqZWdGKzYr?=
 =?utf-8?B?Uk9IQkdIVkNMYlJwNU1xR2JTenhhbVp3eXhmb09HZDVIYU9nL0xaVkZaTDBw?=
 =?utf-8?B?WW54YXZKc2R4ZVhremhxUmZWQ21INzBPNTVOWUJDZmgyZ2pUT0MxZWRBMVN0?=
 =?utf-8?B?UmhxUWNwMUc2SGRQMDJxTEF4TW56a2JaMytLK25lZEltemhPRDVEUFp2My81?=
 =?utf-8?B?YXBuTGk1TDFQbjdVK1BlWENmYy9naENXRkwxcEhKTCtteG5ZTzAvL081T213?=
 =?utf-8?B?MmJ5ZVh5NDJLR0hDWkIyOTlsZ2Nhdk9HQm5jMmxFZGkzM1FZL25XaTRiUUQr?=
 =?utf-8?B?NnJlb0lwVWJiUk0vODU2bkJXSDdlYnp2b20xWTI0Yk9CUWQyc2lUelR2MW1y?=
 =?utf-8?B?Q25hVy8vV0VvOVMzM05lOGMzcnkwczNDNUswQVNNcEoyRjJibkVkMXlLT2hO?=
 =?utf-8?B?Zy9XbzZUdWNUSUxDdjVLN3g5ZEtrcWVmeFBJUmpFc2NURnBvLzJmL0x3dGJs?=
 =?utf-8?B?UnJqR2lmWE1TQWV0WWh6Ym9VNGJhOUljcExDQUQ0MUpqZ1o3N1dxcFhDck5Y?=
 =?utf-8?B?V09XaWtybjlpMDFnNHFZZVFGcW5NUzZST3JrdDBBejJjdFFUeTl2NXFacEV4?=
 =?utf-8?B?T3F6ZzczZk5NbWo2ZlRkRzBYVmExOFpNL3llS2JQU1NXQjVHUVlnVk5GdzdC?=
 =?utf-8?B?cmZTVnl0VEdRbElVMFdiZ1M1bld5ZFc1bmh5cjB4QWkwaEFTcWlRQ1pOcW1B?=
 =?utf-8?B?djU4aHk0R0NnWnQwZVFnRnFrc21RNWJ6V3JvTjMzaVAwUTkyUGdqcmZLeEpW?=
 =?utf-8?B?NnhOZm9aZlJTTXU1aXc0ZjRoM1U1cm16Q3BCS2tOY2hxQnhLUEJ1VGNGZHpW?=
 =?utf-8?B?MGl3aFNVblpGdjh5TkxpYVJ3dGlUY0FicDd4TllyZGRrMzhKWm56ZzdZWktR?=
 =?utf-8?B?bEwxeTNrNmVLWEtVMGN5YnhLREtPVW1zbmI0YVU0UjJZYjhSVEhQdXEycU9o?=
 =?utf-8?B?Uzhqck9iMXFpNndtVi8vVGhFOE82bE0yK1NSYUwwYWFCOTJkVTVIU0R1dGh5?=
 =?utf-8?B?WEtUQ2cvTi9USk5DYWp3OTlDTTlSTFJuZStJQUFsQmMzVnplcHdkcW5BclJM?=
 =?utf-8?B?cTA2SzE2S0VTcUVVYVdzb2J5MTZHcmo1L1JERHhTZkc1VGkrY1QyU0ZSQWg3?=
 =?utf-8?B?ZWF6amNNVC9SMGw4b1A2cDJqWDNrWU9QMStidTUveHBrQkNFZTkxdStsUTd3?=
 =?utf-8?B?TitlQVhraFd6bVZDOVR3VW9VOUFUK3lnalYrNk1GRCtqU1dGYU51eXFMOUFN?=
 =?utf-8?B?eDljendHZ2JyWVpwKzhSbTNaRGdiNHRrNVc3OEJKSU9HdWJneGJUVzNIcU9o?=
 =?utf-8?B?V0IwY1lYYXVjY2JDTFNOMUdMMjBJQ2MzWVcyZ0NBVGQ1ZmhONTJIU1RMaGNy?=
 =?utf-8?B?clhyU2xjZVhkQU5xVlZ6K3d0RGRQZGJwTlhJRzBzQlVmdGJOZU5TMC9UaGF2?=
 =?utf-8?B?UXNUZE9sZWJmcm5vSk1LTGFsaVFHaXhBa0lieTliSGdNWXN0bFRjM09tUnU1?=
 =?utf-8?B?dHNRelFOODlzSnMrWVF1V016ZVNNNyt1UDhReklNN0JxeHoxc2RmM3hxWlV3?=
 =?utf-8?Q?2MMhe/MHHBGH+nD95msL8DqNoRTBkE3SFVFBgQA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3piWjJKVnd4TEtrZU9qdTNZeTNhdUR1NWF2dGVYR1RPK1d4aHVqYjZSa2RQ?=
 =?utf-8?B?dU1vZGw4WGlLVThuVzdqRUhSVkhSYURUb3MrdEowNExNelloRnFiM1lZYjhz?=
 =?utf-8?B?ckFwTWhIRThQWGxLSzB1L2tVTUc1dTk5VXEzalB5WDAwZ3V4SEJMZjd0aTZY?=
 =?utf-8?B?bFZUVmNpTXpEMDc1RG43Nk5oOHVIUnlXa2VvajJXQnZ2b1g1QjNHNERybnQ0?=
 =?utf-8?B?K2Y4NDZrbTF6cHlMa0VQcUl2WEdENXJrUXhocXhMakx6M3R6dVV2blYzVCs4?=
 =?utf-8?B?c2YwaGt3S05xMWp5RXBBaUtZWHZXdGVLSFB0WWNYVHp3bDcxQmZMa0NNc1NE?=
 =?utf-8?B?cmRLR1RIeEdydm5MRDljdGxySEp4akhjUCsyMU04akpTcnlmWkg5TGQzZ0p1?=
 =?utf-8?B?bUdzUkVvU1I1RjhuRWZieWRwaWVqeENTY0NFY0JrYjlVTkpFWmw4enhPMzhW?=
 =?utf-8?B?VmN4cmZiMHR4anRGR2xzdjRTN2w5anZJT2MzeTBQZk84Z1JkWERjcnZvTUxJ?=
 =?utf-8?B?MWRBSGdSU1BJSVBGZFN6c3hmejZGNldGNU8vekpIeUsvOU5Ic0tWcnRxSENi?=
 =?utf-8?B?M1NxVUNSS3l4amhnSWszRWNMYmJtb1ZobkZCMXREM0Y5VHhOWUN6ZkJ0clhr?=
 =?utf-8?B?Sjg3bmR2cEVyWkd1enNRT1pOU2F5eWN4Y0VsN29FR2tXeXloZFlVRnR3Q092?=
 =?utf-8?B?Sjk0WDdWZTVlMHZTVXA1Mk41RlRRNkd5WWZDWnJUbXN6LzBraVg0YXZIRFY3?=
 =?utf-8?B?TG9SQzVYSlZlZ2NMNFlWVW1CQWZFZUZHd2pDbzZEeEdlVGFVYlIwVkJsT2NS?=
 =?utf-8?B?VkNjbUZIRFRaMG1rOFZyRGJCUGJXNFRlOVVnUWEwdEs2bERkTHIwSFN5T0lS?=
 =?utf-8?B?b0pqeUUyK1JlNnJoOUJGWlpIekZ6R1JEblNGTHBCMUEycW9vdVh6OWxUeU4z?=
 =?utf-8?B?WW5ERW1Td3ZXLzRBeHhGeDdSR1JpY1JSYjdseFArdEFtemM2SnRGcUxBaWVq?=
 =?utf-8?B?SisvS09JWkRXaW8yK2J0dG9UNTdodHVVNDczZXV2U3ZGbEJ2ZVNJUU9ma2xs?=
 =?utf-8?B?RTJwU05kcG5BQ0FqYTUwbHBGdFphU0RmbFNZTVJFZTdTV25ZTHpZTCtvbzFh?=
 =?utf-8?B?Smd4TVVvYlAyVHVHL3lEL1lRMHBueldlOGZJM2JDSWdBaHA2c1pLMmdyY1Zp?=
 =?utf-8?B?MysyTlNjMThzMzFzV1RhdFkxeEdsNHdXL25xRHM2NUJiL3M1U1NkODNmRmtv?=
 =?utf-8?B?MFVpRkErL2VmVTJWcGhBcmJ1djZrU3FpVHlXTUM2TG1HR0hXeTlCamV2VGov?=
 =?utf-8?B?d25YdjEwR2pmb3orb0VRT0w0Qzd0OTdROHBjdTFFNmdQU0kzb0ZmVnc2VGda?=
 =?utf-8?B?SFlwRzBqNzJTcVNhTkQ0OE53bmhJazU5ZHd3bVJKcy9HVUJEdGhVSStwOUFF?=
 =?utf-8?B?WWZaYmpqUSt5QUVyeitlc0pkQ1h6N0w2bVNUZEN6MWFQbGFyQ1lqTUxvOG1u?=
 =?utf-8?B?L3JucVc2MURYTFJocEsrKzRkZUh5V1BjMk1sOTFNTFF3aHFJTWxOTWlucWZP?=
 =?utf-8?B?SWorOE96SFY5M1UzQ3RxYWhaeXY3VElBMVZlOEVtWm5lMEErQk5mWE5STjlZ?=
 =?utf-8?B?TElRQ0R4OW1aTHVIU0xwQmpFUFU5cUt3ejNxckRWY0lVaCttZ2VmTFlsRWtn?=
 =?utf-8?B?RTF4ZGhJeDIyZThmb2hXdm1UQXdsRW1vTmUzSmF2STRSU0dsZUJRd0Q3RG4r?=
 =?utf-8?B?WmlDa3pKcyttMkN3eWtFNE54b2tMV2hBRE9KaVMzc0VUQldRUWxUNUt3Y3hY?=
 =?utf-8?B?ZGhzKytMTk1XS0l5YkdmNjBmeGlmMnJqRVJRUTNmUFJ2NXlnNWVybW10RDFB?=
 =?utf-8?B?R1BERXB1MnpxSzFrTEkzZjI5bGNRM2c2MXNyanNaV21Ga09oMXlLWU9abFVW?=
 =?utf-8?B?S3RKVm1adjE2ZEFvS3U2dmRQU3VZY3FRVUhoMk1mNys3Nm9XV00yZ05CNHNx?=
 =?utf-8?B?QWR3WGU4T2lzaHhmeDFWTURPY2loNGw3SktCbGwyQUo1d2dYbkw2VFBNRmlv?=
 =?utf-8?B?ZW9DMG5NWUtpM1pLWEtvWmtUTDZva2gvZERPWnN2eitPMEV4Ly91aGF3SWhS?=
 =?utf-8?Q?GZsfDMRwsTQKY9VoPvo7hwdVE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f31b00d-0e3f-4a07-4b9d-08dcfde50522
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 21:58:45.7042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sLjbQd1gtjoQNgH7CdinzEXqcFRJn5r8aMklorWdCeLVH5WQjiaMJYYwpOKLkQjvc8KVaYi1v2db6CDkzSQUEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9229

On 11/4/24 19:05, Dionna Glaze wrote:
> The DOWNLOAD_FIRMWARE_EX command requires cache flushing and introduces
> new error codes that could be returned to user space.
> 
> The function is in sev-dev.c rather than sev-fw.c to avoid exposing the
> __sev_do_cmd_locked function in the sev-dev.h header.

Please say "why" this is being added.

> 
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 66 +++++++++++++++++++++++++++++++-----
>  include/linux/psp-sev.h      | 26 ++++++++++++++
>  include/uapi/linux/psp-sev.h |  5 +++
>  3 files changed, 89 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 9265b6d534bbe..32f7b6147905e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -223,6 +223,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
> +	case SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX:	return sizeof(struct sev_data_download_firmware_ex);
>  	default:				return 0;
>  	}
>  
> @@ -1597,14 +1598,7 @@ static int sev_update_firmware(struct device *dev)
>  		return -1;
>  	}
>  
> -	/*
> -	 * SEV FW expects the physical address given to it to be 32
> -	 * byte aligned. Memory allocated has structure placed at the
> -	 * beginning followed by the firmware being passed to the SEV
> -	 * FW. Allocate enough memory for data structure + alignment
> -	 * padding + SEV FW.
> -	 */
> -	data_size = ALIGN(sizeof(struct sev_data_download_firmware), 32);
> +	data_size = ALIGN(sizeof(struct sev_data_download_firmware), SEV_FW_ALIGNMENT);
>  
>  	order = get_order(firmware->size + data_size);
>  	p = alloc_pages(GFP_KERNEL, order);
> @@ -1645,6 +1639,62 @@ static int sev_update_firmware(struct device *dev)
>  	return ret;
>  }
>  
> +int sev_snp_download_firmware_ex(struct sev_device *sev, const u8 *data, u32 size, int *error)
> +{
> +	struct sev_data_download_firmware_ex *data_ex;
> +	int ret, order;
> +	struct page *p;
> +	u64 data_size;
> +	void *fw_dest;
> +
> +	data_size = ALIGN(sizeof(struct sev_data_download_firmware_ex),
> +			  SEV_FW_ALIGNMENT);

This can be a single line.

> +
> +	order = get_order(size + data_size);
> +	p = alloc_pages(GFP_KERNEL, order);
> +	if (!p)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Copy firmware data to a kernel allocated contiguous
> +	 * memory region.
> +	 */
> +	data_ex = page_address(p);
> +	fw_dest = page_address(p) + data_size;
> +	memset(data_ex, 0, data_size);
> +	memcpy(fw_dest, data, size);
> +
> +	data_ex->address = __psp_pa(fw_dest);
> +	data_ex->len = size;
> +	data_ex->cmdlen = sizeof(struct sev_data_download_firmware_ex);
> +
> +	/*
> +	 * SNP_COMMIT should be issued explicitly to commit the updated
> +	 * firmware after guest context pages have been updated.
> +	 */
> +	ret = sev_do_cmd(SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX, data_ex, error);
> +

Remove blank line.

> +	if (ret)
> +		goto free_err;
> +
> +	__free_pages(p, order);

If you remove this...

> +
> +	/* Need to do a DF_FLUSH after live firmware update */
> +	wbinvd_on_all_cpus();
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
> +	if (ret) {
> +		dev_dbg(sev->dev, "DF_FLUSH error %d\n", *error);
> +		goto fw_err;

and remove this...

> +	}
> +
> +	return 0;

... you can remove this return 0 statement and the fw_err label.

> +
> +free_err:
> +	__free_pages(p, order);
> +fw_err:
> +	return ret;
> +}
> +
>  static int __sev_snp_shutdown_locked(int *error, bool panic)
>  {
>  	struct psp_device *psp = psp_master;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 903ddfea85850..6a08c56cd9771 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -16,6 +16,15 @@
>  
>  #define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
>  
> +/*
> + * SEV FW expects the physical address given to it to be 32
> + * byte aligned. Memory allocated has structure placed at the
> + * beginning followed by the firmware being passed to the SEV
> + * FW. Allocate enough memory for data structure + alignment
> + * padding + SEV FW.
> + */
> +#define SEV_FW_ALIGNMENT       32

Does this need to be in include/linux/psp-sev.h or can it go in
drivers/crypto/ccp/sev-dev.h ?

> +
>  /**
>   * SEV platform state
>   */
> @@ -185,6 +194,23 @@ struct sev_data_download_firmware {
>  	u32 len;				/* In */
>  } __packed;
>  
> +/**
> + * struct sev_data_download_firmware_ex - DOWNLOAD_FIRMWARE_EX command parameters
> + *
> + * @length: length of this command buffer
> + * @address: physical address of firmware image
> + * @len: len of the firmware image
> + * @commit: automatically commit the newly installed image
> + */
> +struct sev_data_download_firmware_ex {
> +	u32 cmdlen;				/* In */

This doesn't match the name above in the comment.

> +	u32 reserved;				/* In */
> +	u64 address;				/* In */
> +	u32 len;				/* In */
> +	u32 commit:1;				/* In */
> +	u32 reserved2:31;			/* In */

These names typically match what is in the spec, so I would expect to
see length, fw_paddr (or fw_address), and fw_len.

> +} __packed;
> +
>  /**
>   * struct sev_data_get_id - GET_ID command parameters
>   *
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index 832c15d9155bd..936464d4f282a 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -80,6 +80,11 @@ typedef enum {
>  	SEV_RET_INVALID_PAGE_OWNER,
>  	SEV_RET_INVALID_PAGE_AEAD_OFLOW,
>  	SEV_RET_RMP_INIT_REQUIRED,
> +	SEV_RET_BAD_SVN,
> +	SEV_RET_BAD_VERSION,
> +	SEV_RET_SHUTDOWN_REQUIRED,
> +	SEV_RET_UPDATE_FAILED,
> +	SEV_RET_RESTORE_REQUIRED,

Hmmm... yeah, as Alexey mentioned, these return values are not correct.

SEV_RET_INVALID_PAGE_SIZE should follow SEV_RET_SECURE_DATA_INVALID

so "SEV_RET_INVALID_KEY = 0x27" should be moved after
SEV_RET_RMP_INIT_REQUIRED

and SEV_RET_RMP_INIT_REQUIRED should be = 0x20, since RB_MODE_EXITED is
0x1f.

And then you might as well include RMP_INIT_FAILED in the list.

The list should look like:

	...
	SEV_RET_SECURE_DATA_INVALID,
	SEV_RET_INVALID_PAGE_SIZE,
	SEV_RET_INVALID_PAGE_STATE,
	SEV_RET_INVALID_MDATA_ENTRY,
	SEV_RET_INVALID_PAGE_OWNER,
	SEV_RET_AEAD_OFLOW,
	SEV_RET_RB_MODE_EXITED,
	SEV_RET_RMP_INIT_REQUIRED,
	SEV_RET_BAD_SVN,
	SEV_RET_BAD_VERSION,
	SEV_RET_SHUTDOWN_REQUIRED,
	SEV_RET_UPDATE_FAILED,
	SEV_RET_RESTORE_REQUIRED,
	SEV_RET_RMP_INIT_FAILED,
	SEV_RET_INVALID_KEY,
	SEV_RET_MAX,

Of course this is already upstream in uapi, so I don't know how it is
supposed to be handled.

Thanks,
Tom

>  	SEV_RET_MAX,
>  } sev_ret_code;
>  
