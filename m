Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010012.outbound.protection.outlook.com [52.101.61.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625C539EF0B;
	Mon, 18 May 2026 22:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779142181; cv=fail; b=dUmIpAnWQexnnGZ35DDQiXFfi130A3EZI/IlXEg3fhW2TR0Qa9dd3Y3TRjpqc75LebMcldJGyz/AJAKMJmJBA7P+dy+ki8Eb0CFUFyqeAn0U2DFS4OyLG2DwbAiOe2m9aD93p3ISx0pryW+0yCKfrdIS3VSvTpct8kO6yJCPw4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779142181; c=relaxed/simple;
	bh=TviyH8Z90V6vmqViWBbUSeMZp+smabMhpbVkUD7xQbw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rBxMrfRZR6wkT211DKXsVoxSlNVWMtJAONeXxoMc/KXiHJUPU0eHqr+l/sY2DTK2nh9lGAdvLwR3cDvGi/9h15BirhWjFFJPTg1ITOAzv3V678FBWsRGN+1i9qVVsYQ0Ho4KKSCYhC4oA/dNCMv96HHPk2xTdtwg5BZQs8tgHbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=METRNYwf; arc=fail smtp.client-ip=52.101.61.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="METRNYwf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X12A5j4G/RD/ol+c5OUtOM+1ly5e5LTMASSV8st/KKbjvqv7uo9if/oMsdnWNbMJdcLJ6zUPQktDBoBhrGzelX9LZLhHl3chjufcaynkm8fNsiIBvqFXkGgnbb/28UbUhF1jl1Kl/nCVRiB+PVQ+cDVewAejFmn2M1AQ+xjTvAA1G3b86quT1juVWpSwPV37iMlc4zuCopEGssaYwQzEcqadR59vOKeqjBEF43eOvANFv4jBuXP5kWhXUIWmUruICXCNmk078W2jLX3oY8KJlKvoKumpK1BhRosKxHw5KbkqAMB4GbpfTHrQ2Suo4tbs994b07wspcq3xPVGwrFOkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7sfG9+jHoxWMFkwbE4vn++U359mW1Y/Bm2YdOl40Szw=;
 b=TjtNkbUnWh4ShviFTpW00x93NO3rJXdoDyZ8q7F11/AU5Za2FERaTAnHmbfAeH00Gpe8A9xncarPFAkSynCc9uzgOHwEYmq8qRg3hJ0hBEZ2cCxiWyOYo5b097StFUIhGn9rsHDRFCzUEGCoeIPIQpvAI8LG8QMmxg+3jgq3cwBzho+y5falwooa1ohKbizLuQYMPZMNeW01Pw+oo70SFhKf5+i9YGVFI2eOur8JnqOOu0QTseQglvj6tIRcpWV6TQknxt9w8IkfGHiduLEBskdlsl4iY755QhOvouh1Vq3KJbz/gy3BUVdl3OXU4SITRJb8P0calcc29eVoAVer+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7sfG9+jHoxWMFkwbE4vn++U359mW1Y/Bm2YdOl40Szw=;
 b=METRNYwfWU9IgHo9Z5Jq4RTIoiM7SOZKkMdKrPnXif4f/uG3NOkNkDXDddQNgMC4PcZQYFcEJO2YZCY+sFNrTlJ4kW1a//vCb+e/FSRrveh9gABKxneDBpUVnBHBlKlRC+N/jiCzlpjAQx5gHvNp4Sflx+azWm7L8lOQyaVttWw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CH3PR12MB9453.namprd12.prod.outlook.com (2603:10b6:610:1c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.24; Mon, 18 May
 2026 22:09:35 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.21.0025.023; Mon, 18 May 2026
 22:09:35 +0000
Message-ID: <6e365465-9ecf-416f-9561-67cab6428e15@amd.com>
Date: Mon, 18 May 2026 17:09:29 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/7] x86/msr: add wrmsrq_on_cpus helper
To: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1779133590.git.ashish.kalra@amd.com>
 <c9fe5c2fef063f5006cc9bfa03eec824ac015db7.1779133590.git.ashish.kalra@amd.com>
 <c9f1d4d2-e567-4090-b342-c76125673f61@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <c9f1d4d2-e567-4090-b342-c76125673f61@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:806:f2::28) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CH3PR12MB9453:EE_
X-MS-Office365-Filtering-Correlation-Id: e65a6798-61a5-496b-d9d7-08deb52a2521
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|22082099003|56012099003|18002099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	RIGE8KtZqN4TTeuqoDd2oC3sS6NUkbeLNVUJHpAWAljsxWh2jd2l6Db+lQz8uYIRpZqwUgumIUiJdxfhm8OlNqU5rN5FQpTb8pVPcX+ykrGUWiG2rPA8lByFmzrwI8AKYfrem/8+wbil9S1J5ibTIeKEOZaB62qNsIZpcgHsDw+qHELp2X9KTLReAZXxsyvY1BbXI19YOiRli7cKLHMic6fS5zxc6n41CJGKaTo5npG9oYf7gulWGabe+NaL39CtGE6VW4pfsl3R31penjEJvNWr4ow9lscFBQof1FmFx730dAC1hSrgI7jFT/KyCVFTGpCmweLBl7qP87qgCij8kcK4brxSe8NhP34S6203cI2XsDjep8lymz3wsz42QU/VocW5jx19MBVt9JXRHCGAfZiDGifJ8qtqtxuaeGeVBzAr4FAKXTPurJ6rzre8tj/tPhd6B6lgxqkzu2YRlaG3rSxVGZzbap0+sNffAyKq04xdfBcITI2YO+XZt0LQToO9gyUbnzimVgh9/h7Unx8A+f1TAbFMu7g8/Xqru1PlwQEV9d4f8d1bLke04HwunKTPmOd7xJa0J9SVa/qzHjr95D2okm3XDFss0rgX3sndnRSVkxPsu0C7F63BjtBqRbMEmLZbX3H61BUJm0vaWV8R/a0Lqu99uJpInLAhn6xBBCAdtkWu9f9Cql5AYvvF7d3RDZ7Qsm4RQlt2E6aiVGonadJPsWdGDMsSuoOJCAJiRYY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(22082099003)(56012099003)(18002099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bGJuOFJOZlBESWpNZEV0ZjkwYm03cFhVVVJiMjhEOWJJenZJdURtQXlCVFV6?=
 =?utf-8?B?L1lpYytNeCtrdHYvc0poRmVtdUZPVkhnTGoyMkkzakkrYVorOCsrR2s4Sjdh?=
 =?utf-8?B?dUErMFUzV3FoZWN1Q054ZXFUV1ZnV0VBbnZ0Q2JUSkhuRUhsdWMvWExHYUJT?=
 =?utf-8?B?L0dBMFUrdWk5aVhMeUpWcGZvc1NuaWFZVlNxZWZvbUJra2RJTkduZVRpeTRS?=
 =?utf-8?B?K3Zia05YVkRMTkpUT0RUSDlmOU1lRlVUWW1uS0VaMTREeUVNb0VrUHJLQzlk?=
 =?utf-8?B?dWhDdUlta0V1a25MNTdncHk3WmxPbklOa3BMa3NhVXBpd0MvbFUxR2VmZWYz?=
 =?utf-8?B?UWkvZm9BQ1QzZDBza1VRSmhha1dQSzdqWU92Q3FtdWJnaU9VaUtqbUxPbm1r?=
 =?utf-8?B?aVRBQXpHOUVoTmR6bDVPclEzd0kzMkpFWFdyd004N05ack82TytNblN6dFEv?=
 =?utf-8?B?OGkvU1IzWm5xK0NBRHFNcVRFQUErNWVqMmN1WXkvY3VqSUxXYlgxSjBjVlUx?=
 =?utf-8?B?RVBGNUFtM3RTWmh3empHNmJjbUs2aW1vZU5zSE12bUhDTTRCZVo4YS9ZcWNE?=
 =?utf-8?B?ZnkyWVhvaUs3cDJFdExpdGFybzVybnUrTEtVWmpDNU1KTy9ydklkMUZ5Q3dx?=
 =?utf-8?B?aEF1aVZINnp5RDlBZndvVzVXS1RxSzduUDJmdzFCc0lWSG1JWEN1ZEJJWXdl?=
 =?utf-8?B?WXdVdklwZndnOWdtVkM3YjNYWnFHQ3BiUzF4cnBxMEhQY2Joa28rdmNmOUk3?=
 =?utf-8?B?RDB2RCsyc1cyMHVkL0gyNEppNVArZ2ttV084ZndqeERDOXRUWnJncFArZDlh?=
 =?utf-8?B?M242Y1BXeTF1bmNNVUtTVWQ4MkFtaVI1T1d2cDN3MEJnZEtCeFdnbHNtUmlV?=
 =?utf-8?B?WVE3bFMwVSszNUJIS0VUM3dZdTEzRkdsWTJmTzJxVmtTd3ZOdWp4bnlFeXVX?=
 =?utf-8?B?ZVZLS3JSOVoyd3o4MkZjNGpwMDJ2cy9jZXkwck5DWmQxbzl1bXpRUU1jWHBS?=
 =?utf-8?B?aFhWaXp1d0dvalMwOVF2OFUvbXN4UUZQaHZRc2JZN0N6SVlGM0E1SVVZMUJr?=
 =?utf-8?B?dHpJM2dHU0JibFl1aDRBcWFRMWpJZ09YVENrTmhHUlpnOTFjZmZxbktSdXRz?=
 =?utf-8?B?Y3lpTzU2WWxtYU9pUnJzbThkcEV4anRMTWhmaHgrVi9XLzZhSlBQcG1JWlBk?=
 =?utf-8?B?ZzZUWnBzZlZ4ODBNbUEzOWlFamljMzdabWlhZVVGT2w2bTRrM3FsRXhpaHJp?=
 =?utf-8?B?OC9aU2M5c0JnT0pNVHFTQWlNTStUQUgwbzFpcXo2eFNjRzR4TzlQUXhFWVRR?=
 =?utf-8?B?SzFlR1RESURrbVZDVTdOM1U4MUxGYVFIL2VoZUhOK3NjVGdSQXg1Kzk2VSt0?=
 =?utf-8?B?ai8yZ1NnYnpuS2ZuUk56QWlZZlJvcit6Wnk5Y09NUmhCM3hkNCtEUnBNREs0?=
 =?utf-8?B?VXRsSmpnYk1jcU1Ka05LL3JNa2RQY0MyeWs5SUMrR1BKeVNuNGE3MnZnRHM2?=
 =?utf-8?B?cEpCTmRiUUJZRVB0K0UyWnE3b1VER1QvcjNKdnZwZlludzVrOHgzY2JORUR1?=
 =?utf-8?B?OVVMaEFlRnJxUVN0L3o0bllFanY5VmFhMlBsQ0JkQWdxaVhHbzZqMWZtVXdM?=
 =?utf-8?B?R2s1YVlVZjd6L3JMbmNGYnVkUEhtbWM2aHZjYkFwSHlta2ZaV3Zla2NhSk1j?=
 =?utf-8?B?L3Q4ZWNGanY3WlRPdHR3RHpJUjBocTlOc203b0V0MnM3UVZ5NkVlcFp1cUl3?=
 =?utf-8?B?emRnNE4wcFVldk9HOUFBTlptMlBnTldubCttL2VvWnB4VExzYndSQ2Y3NWNK?=
 =?utf-8?B?ejFFaHhQZlViYzczRXpzU20xVzg4WGJzVzFEK1I3aGJZSDVPVXoybXR4dGY3?=
 =?utf-8?B?dEg0MWF1bU5wMnBZSzVzVktrOXA5ZE1ybitRaUJwTHZaMVRlVHRqVE94QVFp?=
 =?utf-8?B?V0dZRG1DU0pEY0JZb04zWWx1V0xXa2tOaElCV2tSOE9qeVN5OUhhMW5FL28x?=
 =?utf-8?B?d25ldXg0MXBaN1k2dFFNT0Y1UU04WEFCU0lEcFNxTmNWblZ0RTJjZXlRRGYz?=
 =?utf-8?B?cDRLSXNVY0pWYjVlanJSTG9rc3FUc0NsTzhxeTVwTTBISEw2M1N2OW1VYUpW?=
 =?utf-8?B?K2V6a0lJQ1FSYWpldXZPOU43QXRsRUFVQXBYWWxkNS9JWG9lWm9FZGh4aHk2?=
 =?utf-8?B?bWF6dXBxN3NhcEtBVEp1OU9nNkI0WFd0ZUY3cjc0eE5oNm0vTHFmNEtyYnFF?=
 =?utf-8?B?UlpzZ3NaT1hWeUN3SDNld3c5SE9tc2NsNzNudUNaUDhHVWN2MWZiVThkZVBz?=
 =?utf-8?Q?CZdQBVh0vFmyBF0vBe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e65a6798-61a5-496b-d9d7-08deb52a2521
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 22:09:35.3469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rufOwT3IXO/jqKQV3qS8d5QplkXnh4pUkd8NCsz9jd80x2gzeGgSErMVGqdiKlvoa82OOKB3dvq4Vi6JUOIKag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9453

Hello Dave,

On 5/18/2026 5:04 PM, Dave Hansen wrote:
> On 5/18/26 14:42, Ashish Kalra wrote:
>> Co-developed-by: Dave Hansen <dave.hansen@linux.intel.com>
>> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
>> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> 
> Hi Ashish,
> 
> Sorry if my memory fails me, but I don't remember signing off on this.
> Could you point me to the place where I gave you my Signed-off-by?

Sorry about this, added this accidentally. 

You had suggested the code change, i accidentally took it as a Signed-off.

Thanks,
Ashish
