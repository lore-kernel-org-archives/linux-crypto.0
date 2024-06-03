Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238C438382;
	Mon,  3 Jun 2024 06:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717397592; cv=fail; b=LHkyo6jTG3qGeQPadL8rlxJmtoeAqUXD34cI1kDSAk0wrYfJ5a+l7c9gSUW1ASrOPOAc6NJANYPUTSwsUCTIU7SIi33m0vBE+D66O3YwJ/zYvVSR8E87tQ6M/zMumlcyeFVGjzBDw7sK8GvbUxn9M5CQc+xeytIM/P3FFIkRDTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717397592; c=relaxed/simple;
	bh=QKe2VQKBky9T8GbkyI5wXBaxw0AjZ/0T9qOc/GyZy6U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tw3BuBO7OnLtGzsjwK5StgPirqmAFjAth01UfpCZXj/TFuRCppbvM78ARNFBFhkxagTJZQ9FCvuZ8xnjgkZfMwNq4KdREiJync+M9G6h1R+q8dp+A1TUpcOm64AjJ4dQR7WuiqWsD2Istt5Scd2YY1Q3ASw1OYrzWMh7+IHSK/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5NYIvo5L; arc=fail smtp.client-ip=40.107.237.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5NYIvo5L"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRDEU79/+Fn+jKgwWnmzg0iL2t8qr/Txrf5Zd1QnWxrKafBTe8nZnjAvAAcXwm72Rts8tuDHZCMcptWGA0n5o0k0TbBl1/vY8ImcYnC3ml6LW7sgf2wf5sBb4eOj97qXxaflXKEWPuuLzsNqIyuU0wHsTSp2JzMeUkhfAydlfZoExYGINZxykTgRTktWmvzgsvQtTri/Y/590IaFumgrdv6S6nW1cPpqQtfjM+Z9tSvOnyBbuAZjFwY+EH66rgpZ7w57kwjxzaoiFrkZOw3lYxKip3sJOW9MnY7MPlRY5AelgSwpnaqmbsuOIK00Kf03KoA66ggyMrt2y3JQlUbXWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K4ZGKYTmMOcoGi367cWk2I2hbkyWTZXbeygtzU10nEY=;
 b=M1qLrwDQtjVIsA+0opyIW1YqX2DIj6Q3UQ23Li/KGITwLbY3wiDG0iu8D/WwgvkCmaNEFkOnoSr7ZYjxklKlBqQiV50P4CSNHL3LKz8gE/K0nS280pyDmoSFJFPa8yOX+HdMTTAH20jZ5GwzNO1BaSFwF2VyNrupMjk9JN6HUxsVHL+7MwK18Mc4krEn6WymuN0b6M4hE9x6lJMcNnPSq6BCqNe7AQuLA/7xV+x/O0vyhuPgIu3/076CJxLiz+NIAaIPTCZvlEkvqk6JKHCpnwH8zreLuQHR4mH+qZK0/J3Dh1XdYCJHw+y07GZlA/fQHGk7E3X8oldLakJwmNrpgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4ZGKYTmMOcoGi367cWk2I2hbkyWTZXbeygtzU10nEY=;
 b=5NYIvo5LUQJc0nRO0HjmCkiQQQxwkJPiV7MwClNCUmp+Nrp1lymwQgLHguierpO3FeBm3DuAZ2gxjrcu0sZ0Gt6X5bUL0qvXoR3TrOYYiHdWD+j8fOEbqtwjAlr7MU/gWukmSmh/FQ0KSsErXTROY4oWIat1vqD/kooK5/0c/Yo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ2PR12MB8109.namprd12.prod.outlook.com (2603:10b6:a03:4f5::8)
 by PH0PR12MB7838.namprd12.prod.outlook.com (2603:10b6:510:287::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Mon, 3 Jun
 2024 06:53:07 +0000
Received: from SJ2PR12MB8109.namprd12.prod.outlook.com
 ([fe80::7f35:efe7:5e82:5e30]) by SJ2PR12MB8109.namprd12.prod.outlook.com
 ([fe80::7f35:efe7:5e82:5e30%6]) with mapi id 15.20.7611.016; Mon, 3 Jun 2024
 06:53:07 +0000
Message-ID: <610f8ca3-c2a5-4788-af7f-3fbdd67d0f6b@amd.com>
Date: Mon, 3 Jun 2024 08:52:54 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: xilinx - add missing MODULE_DESCRIPTION() macro
To: Jeff Johnson <quic_jjohnson@quicinc.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20240602-md-zynqmp-aes-gcm-v1-1-e431cb9b558e@quicinc.com>
Content-Language: en-US
From: Michal Simek <michal.simek@amd.com>
Autocrypt: addr=michal.simek@amd.com; keydata=
 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
 3i3l5DA=
In-Reply-To: <20240602-md-zynqmp-aes-gcm-v1-1-e431cb9b558e@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR0102CA0070.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::47) To SJ2PR12MB8109.namprd12.prod.outlook.com
 (2603:10b6:a03:4f5::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8109:EE_|PH0PR12MB7838:EE_
X-MS-Office365-Filtering-Correlation-Id: efd3fcd4-f9c4-493d-2ef1-08dc8399d2d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UU91ejJrV3hVZzkzOGdneVo3OURGWGdsOUMrb1NLajhWWTBMRmRkLzVmN0t0?=
 =?utf-8?B?THBnMmRaRlFsanIxQkRqTjZRbVEvY3o5aExtWkdXcUM4b25tZmUwVmVQVllm?=
 =?utf-8?B?YjhOTmJiaEV5dVA2VWRkaDI2b3dNMFBESHJkQ1ZwYm5aM0o1VEZZSE9WdmZY?=
 =?utf-8?B?OUkrMVZ0V0pxU2haU2dXTU4vWWNGc1NJY094QkI3VXZDcmRRdVExWVhRWHZx?=
 =?utf-8?B?d0d3THd4dGJQbFZ1WjNuYngwdVRqeUNDNWhjVUdPWmNoSDVjWlloR3dEZnNi?=
 =?utf-8?B?bGdIZk9MN0lQcFJrV0ovQm4zc2tTM1VaRVZBR0s2RXEzL0xiaUNaa0dNeXJ2?=
 =?utf-8?B?RDZGbFI3VXZtdDBsWndTbDhpNEJ4czRYMDJyamZGaGJ5aXlHWjltbTlDTU1R?=
 =?utf-8?B?QllvZ2FhUzBCelFMRjBhTGt4K1JkcDJlS05ubXJLY04rZlpxQ2JBWE1FVU41?=
 =?utf-8?B?eWJWVmExZGVXRFRwa0ZKL3Z1WmowRWRBTkVSak82V1N6VGtVQmhJQzIyMFM0?=
 =?utf-8?B?VWJ1L2JncDlseGNxT0I2MENXV2wySnQyMnpCRlE2b3FyZTU2WDQyUHhmZjVq?=
 =?utf-8?B?MFdFbDJsNXJWd05FTm5YUy9tUVBudk1vaDEzUEhqVFd2dEhDZlpyQzBHVjJO?=
 =?utf-8?B?UHc5RXNjKzdmbit1OGVJTjAyYUJGM0c2dWU3dk5MQVNYUUtCRlJyRjR2UENX?=
 =?utf-8?B?RTJlU3NFUGJsZUY4KzhuYk1jUW84cC9ONjVlcGdtNXhCeUdTbFRpanhqbGY4?=
 =?utf-8?B?KzFqU3l1ZzBxbkQ0cCsvMTN5Y1k4alV0QkwwdTM5WTBmemVDTkw5QnZ4eGJq?=
 =?utf-8?B?ZE1EaC9DYUY2NGlPc0E3Z29iV2pLcy9pMW1GTzlUUzNySXVFRkFOOWFhclhM?=
 =?utf-8?B?eVYwL2l0NlY4bFAzNW9wcjh3aFkyS1FseGJ6UDdtb1IvNVVXM2xxWVR4WHNx?=
 =?utf-8?B?VzdkVlJhdVFZVWN1bmRPelZzSnZkVVRmVUpvdmlnanNWTTNUS3d4UEgwdFBx?=
 =?utf-8?B?eW5tQTlXY2thS2Z4aXNwRG93TTZTakorSmcvU3hVQkJWRk5ka2wvN0ZNQS9P?=
 =?utf-8?B?MW1yejIxdVF5aUpnV0JzK1lvbzF1TStrNjd4di8xZnJBKzJLQnVNRjczK2Zo?=
 =?utf-8?B?SElEWXJQbHRyUWhtKzNlUEdyYWk1SFcxSGFvTzQ0Y3J4aUJ1dy9GTWtmRG13?=
 =?utf-8?B?ZnJ2QVRUK1FsaCtzaDFzQkRhb01adFBPT2lvL0kxem41bHVRWlNDL1A3U3hL?=
 =?utf-8?B?NElGNHVQSld2V0VIUEZWbDJHTzZhQmgvMmJkTERReWZXdDg0RTdOYldXemIy?=
 =?utf-8?B?eVdsVkVWWUxlekppT0VGM2xnY2JlL3dDL2pNNlVJY3pMWXZRejRCV3B3T0V0?=
 =?utf-8?B?ampnZzd0V1FIY2FPNDBCWVR5aEJOMW9CNHAwNnRGODhwQURlLzJHNk9jT3lo?=
 =?utf-8?B?Uk5HU2xrTC8rTkxxRFJoQTFYWjBiczkvY2NWZDkyZ2dDMWRycE83aHUrbmVR?=
 =?utf-8?B?eDlsMHNxVWpqR1ZyUFlwV1lxRXZPeUpHK3duOXlEOTlIYkhOS3ZWSVlsNFhp?=
 =?utf-8?B?RmE4U1JJTGxOZDdnQVZsVzlhb1BxTjZxRnoyYTYyVGQ5RmpYaFpxc2x2aGx3?=
 =?utf-8?B?S0Urb0Y4YTZaWlNIT0VidDM4dXREbkVZMXVKRFcrOE5vU1JEQnVkS0p4TVYz?=
 =?utf-8?B?cFh6YTh3NXFzSEM0dXBFL1RleUt3V2NKaWJhZURVOVY1TUo1THdJaENnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8109.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1BiNUl3eklLbDdBczF6MW05OHg4WjVMV0F5MFNPL0pqcjFmbWppSmN0Szhr?=
 =?utf-8?B?bGtFSUhWbXJiRWhVeU5vZVVHMm4rRjhRTE5ZYnl6SVBZOTJNNTFEV0VmeDRF?=
 =?utf-8?B?SDErVkEraVc5WS90OEs4MmFVakJUVlNjVTVCZUFwVUY2N1IrRkE1c3JPckdk?=
 =?utf-8?B?N1pQVWZTWWdDZXp6WDk4MjJ1NTdudHNzRDFqM1RFc3ZiOXgyVUtXL2RMQ2tp?=
 =?utf-8?B?YStBb3gza3BaZlU4NWtFTE16WFhYaC9zZ0k0MXlSUC9HUjEyZm9PVG9NYjZN?=
 =?utf-8?B?N3Q5OGwrSFFHM0FLc0ozZDBOUTFDd3pnU1hjU0NaRGxUZW04ZklQMjRmdnBo?=
 =?utf-8?B?VnVldkZUYXo5N3doV3VSRmxrSmd0bnRJVnZtMVB3TFl2YjBRUng4ODg5Y0NV?=
 =?utf-8?B?aEVNQlNQMUY4WWVac095ZjZWZUZyV1FwMk5rSk5nNEZYMDBjL0s2bjRzS0xk?=
 =?utf-8?B?R0EzN21IM1JiYUZtQ1RjZXpXZDlOazU1emVTb01NejZsRnlRanR4YjM4eFV4?=
 =?utf-8?B?ZzRHUFFXT2szMVJJSWNVNUNpY1VnVExtSW5QdU14Vk0ya2I0Rm1LU0x3bS9Q?=
 =?utf-8?B?ekZHc05SUkRkVlVMd2ZjY0xYS1NsaGgxMWpuK0dONFUzci9XRzdsbWdMS0Ir?=
 =?utf-8?B?T3gwQkhJNHBoU3UyamZrM3lmTDBHY0I1cVJzbGVOV3piZWZpUTljRHd3N3RK?=
 =?utf-8?B?N2FldTRPeFQxcll6ZUNFbURBcGNmRkNKTVJpRDlEWnlQWC9YVkFwUU1SY05u?=
 =?utf-8?B?STFZd3R3bGhVNHNLcDEwNGFqZFVMcE5JWW5mb2pvSkNZVlBib2orazZ6WWhE?=
 =?utf-8?B?OTh3TEphZC9rNjRnNmhsRk1LbFhPZW1JQ00yUzk3RDZMWGgyUHUvT2Zyb1J5?=
 =?utf-8?B?ODBwNEFVc1BYRFpiWEZCVm9wRDFOM2VDN2RZemUvdFpzL0c1ZUhxZDMzL21V?=
 =?utf-8?B?alppYS9nSXhzWTIyQmxNK1d2SUNOR2JPd3l5aHY4Y2JuNlZvTm1HT3hYYnVK?=
 =?utf-8?B?VkMzYlowUm96eXNYdlQyam5UV0dKNE1wOXFQcVNaL3hmcHpmamgyL1pzNXJ4?=
 =?utf-8?B?WlhNQURxbkdMSngydG5ESHBhcFJwRVFOb09jT0VjN0hKNTFBUlAyWDZGSzdy?=
 =?utf-8?B?djkxcGIvYnViREFoQ0l0SUZaL3hPTUMxKzE3OElZU0xkY3MvbmJBV2p3Ym0z?=
 =?utf-8?B?SDN2NkF0OHdDOVJ3R3gvR0NiVGtVTGNFejVxOFZ3WEpnd0pZcVNLYWx2bHVk?=
 =?utf-8?B?eTIxaXlWSUVIMHI0ZzJPQzAvZkRCRUZrMXpxZWpoNEtBVVFaaGlITFhNZDA5?=
 =?utf-8?B?VVUwemxNZVJDLytLcyttYUpjbmdFZFFiU2l3RTlTaUVXRUR1cnp0NTVyaDli?=
 =?utf-8?B?WjlNMUYremZ3dWM0ZnVuUDRycEQvRGV1NjFQOWI1Z2FiMVdkNkk5b1FLa2c5?=
 =?utf-8?B?NzEwYTY5NU9lVkRLejhpRFExQ1JLK1F2YU9tZ0xWUjBuajUzK1NuZGx5VVk3?=
 =?utf-8?B?b2RrbVR0Q01HQVV2a1oxUFZaemJ6bEo0WEZSMTRrS0Z3a3YzN1daZG55MWlz?=
 =?utf-8?B?bU8vWVNVMnQ0MDRVSm1vU2NWNkovRUJ2WU1tdTFmLzZjY1FxYkM1bC9CUkpI?=
 =?utf-8?B?dEJYcWttM0tIWmxDcUlsM1YzbG5saDRYRXZpRndHZUkzOEErLzc4c3BDS0Jh?=
 =?utf-8?B?V01xUHRxQUx6N0c3K2g5UG5FclJCRWNjcGtzbUNoNE5GQ2pkSmtYaHJQVnVt?=
 =?utf-8?B?UXAvSFV3R2pqWi9ENVNOeXpXcnlYdHNoYXFoUHN1c3ZrQ3E0cXpOU0pGeXdQ?=
 =?utf-8?B?Q2piem5lOU9YcG1kaUNRMlRNWU43UGF0VTROV1l5QmZqMEI2ODJOTW1Pcytx?=
 =?utf-8?B?MnRCOVMyNUVGVkRxdHNTUU5lSUFJbm9YcHhtam14VWNQWlhSUXN0Mm96Szhm?=
 =?utf-8?B?MTRHYnRzWW5nTHJxS21ONjVHUzBCUGdMWEYxRXBCdW1nVGo5VS9DQlI1V1p1?=
 =?utf-8?B?bEVOSjRPSlJIaHI4cGtzTEpicll2NUFYdEZlRmJabVljTk1zc0laTnlOOEJ3?=
 =?utf-8?B?U3c5NURPays1WlJLelRRTG9NS3Q4WTRmZXBROFk2em5CK0NtZVptUms3cTJn?=
 =?utf-8?Q?K13HJxoBZUOo05V4thuu6G7uS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd3fcd4-f9c4-493d-2ef1-08dc8399d2d4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8109.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 06:53:07.0977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0gZmzOOkmEs5YE+GeUQosPlxYO6VFPC7y6ZmZl1BbWzeInr2sQRvhkoZ/2/fcyhv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7838



On 6/3/24 01:17, Jeff Johnson wrote:
> make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/crypto/xilinx/zynqmp-aes-gcm.o
> 
> Add the missing invocation of the MODULE_DESCRIPTION() macro.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>   drivers/crypto/xilinx/zynqmp-aes-gcm.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
> index e61405718840..7f0ec6887a39 100644
> --- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
> +++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
> @@ -446,4 +446,5 @@ static struct platform_driver zynqmp_aes_driver = {
>   };
>   
>   module_platform_driver(zynqmp_aes_driver);
> +MODULE_DESCRIPTION("Xilinx ZynqMP AES Driver");
>   MODULE_LICENSE("GPL");
> 
> ---
> base-commit: a693b9c95abd4947c2d06e05733de5d470ab6586
> change-id: 20240602-md-zynqmp-aes-gcm-c46078273370
> 

Reviewed-by: Michal Simek <michal.simek@amd.com>

Thanks,
Michal
