Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7601516FF28;
	Tue, 28 May 2024 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716910208; cv=fail; b=qj6TjMSJdgmhlkoADJvnqH9i/p8tHUUsoz6k0x+UNz0vAOVTm7e49H98jIg0SNpr6miv4ihBTatb2cGaaEKbyEmBMImrN3khm1EG5GWxB1axrkl4XiHJZosSjwtob8gckgVJXlK3UZJousiCW/xcQ48S0Uv3ZsHXwQ4C0tpH1iA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716910208; c=relaxed/simple;
	bh=B7sq+vji5SlJaaq9uJG1n2+LjTG1pDykonmoidMwyNg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cGkU8d0hhX99E26aoZdtyzuJxS6MQpQnKMq2lWDuZJHUb6Uubrkh876z4jHXa5q2P03gNJAC6WhiSCUFKT/EHo1uEBhAfLGw4Ltedo4iHh08oNohgIYqZpdqtuc6etXKkeU3uKwKQGZJJ5FN8K033JRauo67FlxzA1cIHqXuiMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XffhsTrE; arc=fail smtp.client-ip=40.107.94.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XffhsTrE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPHF4y7qojS4HyUUWDSEL8roQ9X/OBV0wF0kZ+kg1TmNgPW+8jGC2nZWLRNrs1Yd6ShWDIujh1A5lSj2HWHI94c97aNvdys6QS4dtYHvKA+/GG0VA7rLzelzUG5Abcf4rXndFr6XQ4BMmGpSSmUec874PDBXZHWZOGdZWDQLIb6+ohbpVWkUS1DVQdcYhHu4yI/BXVxzVHbqByOQFv2oE/2mqt8qzq6KyHVlMUyB5yEqtEz97sMJZaK1LETR9JkG4BO8QLdddnHfKZPVpLeikNCts7IwxByWSpQ8EaZOHhd0uUFTh5Op/NDYoZBhdLMAD3bFI40NyNEzDUHG/cPTfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pShp2dvflYoA4CyYXB4VK3cQ9Tc3/17O5iKx7gFJgfA=;
 b=fei+BTqLztI3BbAK0cp5BTkElYKvLfrqu95oNIAt6Ka4hgYAGkWuj6+EZPoo+zpuLsJJ21iuLfooKWacaFgkc4gHCN850bX1lakVlak73E2KkKlWkBh+NoMQ0VQfdrcAdW/AW31hnWWS26U1YCzPrOi8KEQN1YdxxG1ls46DOyDyUV7B2PkuCzEZu7Ddz7neWUl+KX5hJcqkwDrl+5MHscpJ9xERW+7HYLU5N+XOBEf0TzJvLdp9V39UdMuBG68wKfw39qS/tB/XvsprUvML6QFjHcfrr7MkOHysKzmF8wLcH3jdLSGgrpQl1LyOUlf+laMBOBA5KoNXYbH/sTV+3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pShp2dvflYoA4CyYXB4VK3cQ9Tc3/17O5iKx7gFJgfA=;
 b=XffhsTrEokQvgwDA0yCtXJO5Yt2i/HSqr31AZCeFig16uY4G2aovvNiWbsZ6GdCjyeUnrSWv1ug3tQnqAdelY+VQtgDzJDAgXh9ucxDNMgX4qoplZb2OP03nCgwnrW5OU2ZEZjOFj2XxYQFY9bK8FIhO8RbfTXIGqmByOFet5+Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by CYYPR12MB8749.namprd12.prod.outlook.com (2603:10b6:930:c6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Tue, 28 May
 2024 15:30:04 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7611.030; Tue, 28 May 2024
 15:30:04 +0000
Message-ID: <91836dfb-2670-89a1-2bb7-6a5047185f60@amd.com>
Date: Tue, 28 May 2024 10:30:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/5] crypto: ccp: Represent capabilities register as a
 union
Content-Language: en-US
To: Mario Limonciello <mario.limonciello@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DB..."
 <linux-crypto@vger.kernel.org>, Richard Hughes <hughsient@gmail.com>,
 open list <linux-kernel@vger.kernel.org>,
 Yazen Ghannam <yazen.ghannam@amd.com>
References: <20240527152649.3722-1-mario.limonciello@amd.com>
 <20240527152649.3722-2-mario.limonciello@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240527152649.3722-2-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0088.namprd12.prod.outlook.com
 (2603:10b6:802:21::23) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|CYYPR12MB8749:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e46ab87-ada9-400f-c744-08dc7f2b0bde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OFNIeS9zMGk1L21QM1hacENqc2JJR0JQUHh3RmN3dUUxTi9vN0tKQTlCcWFX?=
 =?utf-8?B?TEp4UUlvWlM0ekNTbEptUmlHdEdIMHJCVVpFQ2Z1RXV1VElyYktlSm15ZUp5?=
 =?utf-8?B?aEw4RnNndzFpWnhSUVlsYXZTVEsrSUFUK2dzMmlwK25maVF5REdZOXpvRGw3?=
 =?utf-8?B?TCtrZUd3aHQ3QWdjaGVZVlpSM253LytGRUdxbTcxREgvTXRlMmwwZEMxakNr?=
 =?utf-8?B?OGZMT2ROVU1zVFBuSTNEU0hJcktmQ1RpcllkcWRNMUt3cFdOMXgzZkpoMllz?=
 =?utf-8?B?SEtvckZnYk9sbG5JdzZvUURwc2hKMGErcDZXUWRXVktQejNZL3VxODFyUlUr?=
 =?utf-8?B?YVk5MGlZNUk1RTBNRmtzeVdpT051NGtlQ1NOMEt4SjE1YW5wSE9GUTNXK2d6?=
 =?utf-8?B?c2JNQVkwL3ZRMU1WTzRSNE5ZTGVodVovL3F6aElRTGxSM1VJN0ExeEdYMzh0?=
 =?utf-8?B?QlJIVFBsT0ZyUzJqTnFaNm5ZVTErbUlxNStoQlVBYW13RTUzWldmU0FCWU9B?=
 =?utf-8?B?cUw2cklidzNrOFd6ME1OMC9XTmFzRGdCRWZ1NXJHaVVDa0FOZ0c5bEVXSnUv?=
 =?utf-8?B?dGlWekd3Tk13dXlxNnFqQWN1R1IwOEtzTzg1aExHU01ReWUvV2N6NVdjaFpp?=
 =?utf-8?B?emk5Rmw2TncrSG04YkR1YzVGOTZLektBUFR2T2gyTXlYNTJFVHNSd2VnNXVS?=
 =?utf-8?B?SXdsMFFkR2dwcHl4TmJZNFB1SFc0dEtEblNUR0ZYNzQvTDJHVnF2bmxzUk9q?=
 =?utf-8?B?TTlSdDF0STZRdWNURWV3NllBbFY5WGNRNWx4eTJGMmhZWVNBalo5aGZDektV?=
 =?utf-8?B?K3J5NHJhdk5DWEZ5b3JYQmViT0VZd0JLcWJLb29jdXBoOHhZUVUzSmZQTHJv?=
 =?utf-8?B?MmVKbVhqNUV1MWZ4TFdRVVoxb0M5MWU2R1JGVE1MR0xPdTJjVTNNQTU2ZStF?=
 =?utf-8?B?cTNhWEJWa3ZuTnYybXdWN2xrMitEaVYyS3FYVDcyUmxTTktZM01wdEVSRzMz?=
 =?utf-8?B?TjZhTnhIRENwa0Jac3FCSzZyWEZCdXFMaTJvWmQyZk8zVi9GbzdyRVl6bXMv?=
 =?utf-8?B?bGRpZG9saWNFVmh3ZXVhY0NSVUdFNHZpVTVZR0t3NElDcnNBVk1xY244akwz?=
 =?utf-8?B?b085aVJQMm1aNUc0MWI2VXdndEtDcGNjdG43YURleVZLUEZhdlBORnF5UHBN?=
 =?utf-8?B?NnlPMDhkWHhjY0JDQTJ4RW5JajMrbWNta1pFbjgrY1JReFI2VGhwNitlQzQ2?=
 =?utf-8?B?cVhHUWZ3VUpMeVRzb1diTDZhc3h4MTk4TjZFMFNENjc4ZXBaaWdQL0VBTTRQ?=
 =?utf-8?B?SkVsSjFVaUpuQjZ3bFhOOFhYN1BTaldrY3N5T0lqYzJ5alVxTmJla1dMZjc5?=
 =?utf-8?B?dDNCai82YTVpT2NlRjJVeXZQV0dUUFdhdHB2bHhvK0RQdmthcGZCY1I4UHV2?=
 =?utf-8?B?eDFOZFAzVENvc0NsbVQzSHluSlZ5RFBweGlwVjVWVm1KTWZvTTdnRlNndDZ1?=
 =?utf-8?B?am5rbHVCYm83MEd1VTZZMk82WDVZVkRIZE1KTzAvNjY5ZWpKZiszbWxmbUMw?=
 =?utf-8?B?Ym1BczZmZXY4cHlHL0RWdWhQOXRTcTVJZ3drZk4wTFVYQVJwdWVUaVdoUkhy?=
 =?utf-8?B?U3ZVdnI4WUd2dlMrajVBL0hlSm04SXRtZW1KZE5PcjRFRUd4dkFrNE92dFpj?=
 =?utf-8?B?OHhSSHNka3NMK0RBRVFnMTBMTVBUMlgwdGtOdkdSbEEvOUZyNkxOenlRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGx3L1VGczhkcVJIYW11QUlvdnRlaEJwcXFNSmhjWHN0MUdsQ00wMWRST1BV?=
 =?utf-8?B?NGEzV2dMQ3VZSXk1QXhnSk5UQlJOcDZJQTFIU1JNUmJUbXhUWFhkZXg3d3pU?=
 =?utf-8?B?ZlBrb0ZiMW5id1ZzUU1RSWpiUkk2ZktIUE85YldyZTYrOFVDL0Q2Nm1qRjc5?=
 =?utf-8?B?RDlsVVNLelR5VHRjdlprY3NHaDJQRDlEbll6SW1Pb0NaR3NaV1lLSmxoTDgv?=
 =?utf-8?B?M0g5Q1psMmdJazJBRFVaM2RnUUhmeWlDc2JreHFtYnVlWDc1TWF2U2hkN0tG?=
 =?utf-8?B?ZE40WXZsek4xdUdrZ3RJUzYvc0Z6YlhWb001QThxN3Q4U3ZTSUhXTGFLUE8y?=
 =?utf-8?B?VnVGOUdJeWt1ZFY0Q0l5SGtsakxVcUNjUUJlQjAzTFVocmRldWx2VjZtd3Bm?=
 =?utf-8?B?OURrNUNJL0s2ZjFmdExFWTJqUXk0cjFNM21rSFdjdmY5clp3WjBFeDJ5Skgz?=
 =?utf-8?B?RG9OUCs3RXd3QVNtbE1wR01HbUFrYlNMaEZLSDl1SUNSNmFJOVM1aUJOa3pN?=
 =?utf-8?B?N2FIMWVRN3lzcHJ6Z1RqVWJtYWZvU1l5TnJ4Vk9mcWJDRXhHVExuZkdXT3Bv?=
 =?utf-8?B?YjcvM3dEWTBZMGJQTE1nVFFySnhPSjdOcWtVWkYyQlk4b2RJNEovOGh2MGdK?=
 =?utf-8?B?c2JZYlczUVBwK0pyVm1lb3pzWGVMbzZOaHgweDZSL2lxbmFiYm5xUUdkN01M?=
 =?utf-8?B?V1FKdnNTV2hWa1RFb2o5cHN6Nk1IOWRyWmJFODBPRUFJZkVFZFFKUWZmZFBz?=
 =?utf-8?B?Rno4dEt5STVVa09IZEdUY3Y0aHFFWXF3NUlrdGQvOUZUeWFseVZIY3BZdFUr?=
 =?utf-8?B?dFRrdUxsV3BHVlA1QlZCWlpRNmg2bWQ4SnBHbEowOUJoUDZCSHlnRWhZbnFV?=
 =?utf-8?B?WmJ3cWJZcllYN3Rya1VzTkNEQkc3V1IveWtEWHEzb2l4SGc0M0pxUUMybGM4?=
 =?utf-8?B?NjRMeXNySXJNZm5QZFR3STFGaGVzTUhHTTFzWTcvVjRSZytwTy9VNnU4bGxn?=
 =?utf-8?B?TkNjWExFNm45aU40bSttUzU2Zlg1dHdJc09Yc3EzWUVxQlByMWJPMGFzcFBj?=
 =?utf-8?B?Uk42bHpvdWo0b2pSRDlCZFpFU3FYL1YzSVRFbEFCS1YyTFkvUUJZTy9wbmRx?=
 =?utf-8?B?Z2pEb2hFUGxPbGRGOGhMMFhJK3ZwcU1jaExGM3diRGgzTk80YXVrY094endR?=
 =?utf-8?B?TGZyOGc3a3pnbTdBWHhRRi9NRk9GZ0lGMUhibks5SklqRjgvcjZiWjF2T0x5?=
 =?utf-8?B?UlBlWm5KT00wOVFhSjFON3BHSG80dG9vZUE5NkhKWnRKOGVEdnRpdmRRYytY?=
 =?utf-8?B?K2taUFhtWTBFVGlUcVIvazdZY1NJWnl2TVR6WmNoWHAvRk9YTkdQbmhaVWhq?=
 =?utf-8?B?aWRQclltbjVQZERQL1NtK0R1TWdianhiTkswZHVhYWNSRFZPRmZ1VFZKTy9Z?=
 =?utf-8?B?NVpIMllYdDc0SVBmUlhnVUhXSTkwTko3Y29JSDBXWjdQQ2JobjR3QnNOVU1v?=
 =?utf-8?B?bFR2UDNZRVhmSEkrTEp6cnZzVGZEYllTMkpLTzgvMnhjb2ViWkZVb05mTW1K?=
 =?utf-8?B?TFZKbFY4cEZSK0tBdXdtd1V3QUJrVkk5SGRFWEVFaDRVTXFLL1JMMFFiREpa?=
 =?utf-8?B?ZFNNQUtFM044WWtEQVVUTTVsR2lCUkNEU0dBZHVMK2JWZ2l3YU1jTmV0L0lU?=
 =?utf-8?B?Nmd2Zm5JTUZvQ0RGeXkyZHd3d1JHQkVZOVp0ZCs1Tkl4R0kwZkdaMXNkdUhP?=
 =?utf-8?B?NDJ1ZHdMTis5dHRwZ20xQitGems0OCtyTGxSVnVvSGZZYUJEWHlTVDBid0Q2?=
 =?utf-8?B?K04vUTh0NmhkWm5mMnIzbTQvN09sK0RpWk5NbDJ6ZFJVbXE3a3JpeGpOaE1E?=
 =?utf-8?B?KzB2NHR2aUNJKzhXaEg3azNMSElheHhPTTQrZHB3OWEvRSttL0RSN3pFbS9E?=
 =?utf-8?B?S1p1YmlpeDlzMVRPUndldlQrUGFhdGNCRytjckZLTDM4cHhRa1RONTRRSDJO?=
 =?utf-8?B?NVJsSDNwU09uSC9pUWRpTXg0eHExY1dIeFUrTTZNSW1hQXJNamFIVStHMWRQ?=
 =?utf-8?B?M1BFTmFlelBBNVNwRjVmbzB5YUlOQVB2ZmlMZzZlVmpTYzQ4TG5LSnFhaTh5?=
 =?utf-8?Q?JaloS+jMz50xmvhNCwebGNFSW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e46ab87-ada9-400f-c744-08dc7f2b0bde
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 15:30:04.1200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qGnCixD+yXJtPLOna9eMA32Smg1U/ALyJZBjKvPfKiKXDTzAA/F904SbuhyPP1a9s89yVi7MGpyhA/Xxq+vUWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8749

On 5/27/24 10:26, Mario Limonciello wrote:
> Making the capabilities register a union makes it easier to refer
> to the members instead of always doing bit shifts.
> 
> No intended functional changes.
> 
> Suggested-by: Yazen Ghannam <yazen.ghannam@amd.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
