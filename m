Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012069.outbound.protection.outlook.com [52.101.43.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4CE2E888C;
	Thu,  6 Nov 2025 20:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762462131; cv=fail; b=KQDHJ+jV1AqnEGMoivItWvWakTipDpvfUtANycok/hzKC3QW0WRpD73eCYjzw/tfZKTNySILVbxP8jg4vQCW+a4nf532wgqZ9++2xxiWpdpNQWe0GtQfM1s4Qm97oTnLSgYdyFOl2lOzVaA/OLLl31igKhhtWZvE683UlDzF2Cg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762462131; c=relaxed/simple;
	bh=aDLCyTKrNm4PpDwRW8XiyIst67LdHIk+1g3quE97KE0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=a2acYZDgBo6NCMKHRqvOUkSPpCFETQawp4XzZGifpzny1ck+hNoPu2lCppx45YcJdEsij2rbBL4Dxhrlrz3b8u7d/Y76rAU/s8ZACaGm/Xocg/c0dJxGS74G69/GMMUgmThw7Zg2ix5FlZ0O42E3SnQiljxlQPb7SsnjN0YSruM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=G7hC29sV; arc=fail smtp.client-ip=52.101.43.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="G7hC29sV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wcPuJqYzcFLooEKEl52vcFVoJB8V5H5B1rFxPGE2dbL+15OG/YXPumT3e8VVSLRNek4VU0qV07EF2i1pBHoezKoPoYCc+W+VPJG5RPl4vR3ZERVQ5r5xdnldY8GQmnf12Zff4WTSbCfIJdjCCdSIwIZVTxmba+bxAyL+UxqXZb3Di2CQd4PXa/MAYoBlQiKoqYc6nomVEhs2X4gt3VhT1/0uZ+6lCzFlMqCrYpFLeKFyfPIt/Q8d0sB/lz2avRSs3DEdYJELvLqygGmqvtsbf7ZePmkIls4MkoawhqsWMZ670E+xqBxUsRV7uS0SX/zoA/NOyjDVziQAfnc6p6bW5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFKN8hhyZ3FizE0UFxRnrLC+oBUfU8rLDOtBuOPK63g=;
 b=CC/ZVKTfc4LjkBELBhtp8RZVH5KfOv0kjKn8N3Tn3PlidwV0vMrKd87Ew+/h8vKRerPj6JmAiK+6HY8lsxBG0TdkWnAO+3Ty8QNIjuyYf0CWJd2EUGL9QRJG8TD66mKZALvRDXLo9xJnGcrQ4FKnacTlHxvfi/DER0BBi+Ic2J0N0OjpgqH/MuXuI+xEL9+DRuSPy/7XUCHsAKk+rUkzNllJJrfaDqY/HdpDJtIA20dZWMOG1aKxWEeoWDkHsegunIwf5RUQJXp4OgcTj9RnqmMlj15SBb9LkRO8ePhX/DBU3wyt754cF1nAQGQxkrpqtorK2wFPuyz3owNPRKcz8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFKN8hhyZ3FizE0UFxRnrLC+oBUfU8rLDOtBuOPK63g=;
 b=G7hC29sVlR6DOIOKfxPDqs62Q+6sdSWQVbzWRf+7fW96TCxn0frqlXrOHDLciGfNuOQYdPPGXfCkQ/BN8DP5jD5EXiBdfDOQqV8UXsT7TWh9VoBhdaF2xsJGE4kC7v0p032FWgeLEO3Dbq9Zm6oZzn6FjpmnQMqvrA3+ThQBVVI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by DS7PR12MB6096.namprd12.prod.outlook.com (2603:10b6:8:9b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.7; Thu, 6 Nov 2025 20:48:46 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%4]) with mapi id 15.20.9275.013; Thu, 6 Nov 2025
 20:48:46 +0000
Message-ID: <2ff82e42-8e17-4bbb-96c8-fbe57dc76966@amd.com>
Date: Thu, 6 Nov 2025 14:48:43 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] crypto: ccp - Constify 'dev_vdata' member
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Ray Jui <rjui@broadcom.com>,
 Scott Branden <sbranden@broadcom.com>,
 Jesper Nilsson <jesper.nilsson@axis.com>,
 Lars Persson <lars.persson@axis.com>, "David S. Miller"
 <davem@davemloft.net>, John Allen <john.allen@amd.com>,
 Srujana Challa <schalla@marvell.com>, Bharat Bhushan <bbhushan2@marvell.com>
Cc: linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@axis.com
References: <20251106-crypto-of-match-v1-0-36b26cd35cff@linaro.org>
 <20251106-crypto-of-match-v1-4-36b26cd35cff@linaro.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 xsFNBFaNZYkBEADxg5OW/ajpUG7zgnUQPsMqWPjeAxtu4YH3lCUjWWcbUgc2qDGAijsLTFv1
 kEbaJdblwYs28z3chM7QkfCGMSM29JWR1fSwPH18WyAA84YtxfPD8bfb1Exwo0CRw1RLRScn
 6aJhsZJFLKyVeaPO1eequEsFQurRhLyAfgaH9iazmOVZZmxsGiNRJkQv4YnM2rZYi+4vWnxN
 1ebHf4S1puN0xzQsULhG3rUyV2uIsqBFtlxZ8/r9MwOJ2mvyTXHzHdJBViOalZAUo7VFt3Fb
 aNkR5OR65eTL0ViQiRgFfPDBgkFCSlaxZvc7qSOcrhol160bK87qn0SbYLfplwiXZY/b/+ez
 0zBtIt+uhZJ38HnOLWdda/8kuLX3qhGL5aNz1AeqcE5TW4D8v9ndYeAXFhQI7kbOhr0ruUpA
 udREH98EmVJsADuq0RBcIEkojnme4wVDoFt1EG93YOnqMuif76YGEl3iv9tYcESEeLNruDN6
 LDbE8blkR3151tdg8IkgREJ+dK+q0p9UsGfdd+H7pni6Jjcxz8mjKCx6wAuzvArA0Ciq+Scg
 hfIgoiYQegZjh2vF2lCUzWWatXJoy7IzeAB5LDl/E9vz72cVD8CwQZoEx4PCsHslVpW6A/6U
 NRAz6ShU77jkoYoI4hoGC7qZcwy84mmJqRygFnb8dOjHI1KxqQARAQABzSZUb20gTGVuZGFj
 a3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29tPsLBmQQTAQoAQwIbIwcLCQgHAwIBBhUIAgkK
 CwQWAgMBAh4BAheAAhkBFiEE3Vil58OMFCw3iBv13v+a5E8wTVMFAmWDAegFCRKq1F8ACgkQ
 3v+a5E8wTVOG3xAAlLuT7f6oj+Wud8dbYCeZhEX6OLfyXpZgvFoxDu62OLGxwVGX3j5SMk0w
 IXiJRjde3pW+Rf1QWi/rbHoaIjbjmSGXvwGw3Gikj/FWb02cqTIOxSdqf7fYJGVzl2dfsAuj
 aW1Aqt61VhuKEoHzIj8hAanlwg2PW+MpB2iQ9F8Z6UShjx1PZ1rVsDAZ6JdJiG1G/UBJGHmV
 kS1G70ZqrqhA/HZ+nHgDoUXNqtZEBc9cZA9OGNWGuP9ao9b+bkyBqnn5Nj+n4jizT0gNMwVQ
 h5ZYwW/T6MjA9cchOEWXxYlcsaBstW7H7RZCjz4vlH4HgGRRIpmgz29Ezg78ffBj2q+eBe01
 7AuNwla7igb0mk2GdwbygunAH1lGA6CTPBlvt4JMBrtretK1a4guruUL9EiFV2xt6ls7/YXP
 3/LJl9iPk8eP44RlNHudPS9sp7BiqdrzkrG1CCMBE67mf1QWaRFTUDPiIIhrazpmEtEjFLqP
 r0P7OC7mH/yWQHvBc1S8n+WoiPjM/HPKRQ4qGX1T2IKW6VJ/f+cccDTzjsrIXTUdW5OSKvCG
 6p1EFFxSHqxTuk3CQ8TSzs0ShaSZnqO1LBU7bMMB1blHy9msrzx7QCLTw6zBfP+TpPANmfVJ
 mHJcT3FRPk+9MrnvCMYmlJ95/5EIuA1nlqezimrwCdc5Y5qGBbbOwU0EVo1liQEQAL7ybY01
 hvEg6pOh2G1Q+/ZWmyii8xhQ0sPjvEXWb5MWvIh7RxD9V5Zv144EtbIABtR0Tws7xDObe7bb
 r9nlSxZPur+JDsFmtywgkd778G0nDt3i7szqzcQPOcR03U7XPDTBJXDpNwVV+L8xvx5gsr2I
 bhiBQd9iX8kap5k3I6wfBSZm1ZgWGQb2mbiuqODPzfzNdKr/MCtxWEsWOAf/ClFcyr+c/Eh2
 +gXgC5Keh2ZIb/xO+1CrTC3Sg9l9Hs5DG3CplCbVKWmaL1y7mdCiSt2b/dXE0K1nJR9ZyRGO
 lfwZw1aFPHT+Ay5p6rZGzadvu7ypBoTwp62R1o456js7CyIg81O61ojiDXLUGxZN/BEYNDC9
 n9q1PyfMrD42LtvOP6ZRtBeSPEH5G/5pIt4FVit0Y4wTrpG7mjBM06kHd6V+pflB8GRxTq5M
 7mzLFjILUl9/BJjzYBzesspbeoT/G7e5JqbiLWXFYOeg6XJ/iOCMLdd9RL46JXYJsBZnjZD8
 Rn6KVO7pqs5J9K/nJDVyCdf8JnYD5Rq6OOmgP/zDnbSUSOZWrHQWQ8v3Ef665jpoXNq+Zyob
 pfbeihuWfBhprWUk0P/m+cnR2qeE4yXYl4qCcWAkRyGRu2zgIwXAOXCHTqy9TW10LGq1+04+
 LmJHwpAABSLtr7Jgh4erWXi9mFoRABEBAAHCwXwEGAEKACYCGwwWIQTdWKXnw4wULDeIG/Xe
 /5rkTzBNUwUCZYMCBQUJEqrUfAAKCRDe/5rkTzBNU7pAD/9MUrEGaaiZkyPSs/5Ax6PNmolD
 h0+Q8Sl4Hwve42Kjky2GYXTjxW8vP9pxtk+OAN5wrbktZb3HE61TyyniPQ5V37jto8mgdslC
 zZsMMm2WIm9hvNEvTk/GW+hEvKmgUS5J6z+R5mXOeP/vX8IJNpiWsc7X1NlJghFq3A6Qas49
 CT81ua7/EujW17odx5XPXyTfpPs+/dq/3eR3tJ06DNxnQfh7FdyveWWpxb/S2IhWRTI+eGVD
 ah54YVJcD6lUdyYB/D4Byu4HVrDtvVGUS1diRUOtDP2dBJybc7sZWaIXotfkUkZDzIM2m95K
 oczeBoBdOQtoHTJsFRqOfC9x4S+zd0hXklViBNQb97ZXoHtOyrGSiUCNXTHmG+4Rs7Oo0Dh1
 UUlukWFxh5vFKSjr4uVuYk7mcx80rAheB9sz7zRWyBfTqCinTrgqG6HndNa0oTcqNI9mDjJr
 NdQdtvYxECabwtPaShqnRIE7HhQPu8Xr9adirnDw1Wruafmyxnn5W3rhJy06etmP0pzL6frN
 y46PmDPicLjX/srgemvLtHoeVRplL9ATAkmQ7yxXc6wBSwf1BYs9gAiwXbU1vMod0AXXRBym
 0qhojoaSdRP5XTShfvOYdDozraaKx5Wx8X+oZvvjbbHhHGPL2seq97fp3nZ9h8TIQXRhO+aY
 vFkWitqCJg==
In-Reply-To: <20251106-crypto-of-match-v1-4-36b26cd35cff@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0025.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::10) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|DS7PR12MB6096:EE_
X-MS-Office365-Filtering-Correlation-Id: 60cadc2d-71ff-47db-c459-08de1d75e128
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T2ZZZmJBTFBPQlR4SnBBb20wMVI3YnNMU1hkTWNVMFYvb0kxQm5VMmNXbWh0?=
 =?utf-8?B?SndYQ08vZmdIaTRlMVgydzdjczFNVnNub0VDei9Kby90enl4UW80QmhER25R?=
 =?utf-8?B?dU9YTWVHVzNkV2xSNW54ZDZrdkpQbkhrYXZPd0trd3kraEVrNE42U21uZUZz?=
 =?utf-8?B?eThMUWRCNUdDcUFhTGsyWWhSNE5tcmdaNXpMY0U0a0pEK2t3ekVtbGdjbWJQ?=
 =?utf-8?B?TzhyaG1Jc0Q2dFRXTERISGJIbWVCeGdRd29oUVN2OEljVEJJQlhBTzNsaTFJ?=
 =?utf-8?B?Q3hUMTRTU1MzOVpsMFgzbE5ja1o5OUlhelc0TTFNTldyaTI1MVRxMlBObk44?=
 =?utf-8?B?UFFDS3pWa2VzMkhTNjRXaExpWXRsc2FwMktubGlvRElqVTVyVVBjRG1jc2xs?=
 =?utf-8?B?TnEwVFUwMjdMdmVvaWJySlp5RG1DR2dCcHZ6VEhnTTZ2K2gybkFldlhOaHc2?=
 =?utf-8?B?bC9rODZDV1hKWmRzMDRkWXRRL0JIN1JMcnlGa1RmQ0lRNzgrbkR3REdLamZJ?=
 =?utf-8?B?MWNWWWNxODcybEZXV01UcUVQbGlDeEJRUXI1WnIxZEs2Q3NrbzZzOUQ3UzEy?=
 =?utf-8?B?KzR2dk8rYTV3Q1BIOXFuL1ZNeVhWVHZZdnFFR2YwbHVySTNrY200WnlPbWZV?=
 =?utf-8?B?Y3h1NUU1eCtMUk96KzhtcHFSWTlSZTJYTWZyWFBSV2pVUkt4KzFFdUppTTlu?=
 =?utf-8?B?UEZldmlQbnBJemcyYmFKY0xIOWptOFJxSFBhMDNVbzRMeXFtd2ZEYWFvaUg3?=
 =?utf-8?B?SzhLNXRiVkVhREJvVS84RWl4RDFIWWtMT0hNMEVaWk96RzRFK1RaTVYxamJI?=
 =?utf-8?B?eEorQnNmLzNKdy9TOUZIaElpd2l5ME9TKzBoQ1Zpdk9MSThVZVlsN21sOVZX?=
 =?utf-8?B?anJvTHVGZFQ0RksrZTk4b2l5dnhsd0hGaEI5WnZwMkVQakdKcHlwaHZRQ1Qw?=
 =?utf-8?B?dE45citPQXZlc3N5Q2JZM1E2emJuZ0x5aHpuSkxvYVVweUlOS21heWczT3pu?=
 =?utf-8?B?YkkvN29IOWpjemNsczFoUlUvOEZjUkg4VjViMmZlTVhsSTNPVXhnUUNQVGxH?=
 =?utf-8?B?YUxNbUxqR2F5Zm5xY3BmeFVNa0NBYmkvVFNpajNxRll0bUNWQVJEQmV2dDY3?=
 =?utf-8?B?UTl0VEhjcUJvOTNtaXRkajZCOU1iOSszSy9EQi9ZUjduTlU1ekRFTEwvUnNV?=
 =?utf-8?B?cURXdUUzdGhQN284NEF5S0prOEZZSVRFWFRYOCtMWWdWT09ERVpkOXNTYnFo?=
 =?utf-8?B?RGw0TFFiYjh6cHRGWXVsczFpWVRuejJONmRLNGQ0dm9xTDNPdUdQRTRVRklB?=
 =?utf-8?B?Tnp5NnpOSFRKN1pkdmpRbVVUREt6ZmVYZ3lUTS9DUVdXS3BENkNFWVprZmNR?=
 =?utf-8?B?YUZRcXd4QVZkT1V4d3NZSU81aEJuU1dNZmVaS1E5K2lIZXYzRC9meXU4d2VO?=
 =?utf-8?B?UTlRdVJaWjFMK2cxRm1CRUN1NDJzSjFzbzFxMVFCOUI0MURXOU4xNitMeElY?=
 =?utf-8?B?cjFVUzU0QVlJUmViRVRtUXFIRXN2UDBJVG1nTVlYeTRYeS9kNXVHb2VDUmpv?=
 =?utf-8?B?TkUxeDExb25ySzhmOGZzWTlSa3dGMjAxKzdNcWt3QVYzakxLM25vYm1MVldW?=
 =?utf-8?B?WFhNSWErYUtQRmJPakNveFQ1bDZjREMzMmU1Z1YrYVM5UWdoSTUzMTZwVkF6?=
 =?utf-8?B?WlQ4d09VUnBHVFV1bm1ORHNoSDJNa3RSQkdrNFdydzNrRUdNMW4xdTBmQzNQ?=
 =?utf-8?B?TVkrVndkMFh5VlZ6bjZRcW56bFZoOGlLQjdNaXY0VFZxNm1qdml3VXY4anlr?=
 =?utf-8?B?VUs1TTNaUnlldytncTZPS3lIL2NsRVRxYUhNbjB2cVlURGRpenFWZndXcmtG?=
 =?utf-8?B?TWd3WkhpTDdYQU41YnJBWU1ERjI0dHh1cFhPSEFnSm5aY21haDZHVWdvQ0dH?=
 =?utf-8?B?MVkxeWFrVlRCQzF3MnBSR2orK0tuYzNXWFNpWnJMT3RqcGZHUTZsNFgwUUhh?=
 =?utf-8?Q?djMjBwiavPn3+HEu6JJpPaN1R3p7sU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnlBbnhvM2JtbmpSSHBaWExwUm55akFHdUprU3RlSFJSa1NxT0NFZmlGYzVZ?=
 =?utf-8?B?Y21NV2pqYjNTK1VtTFp6NTlvV21kS3F6NHBHNjhkWnhmVmhDYUEvYnhkTlQz?=
 =?utf-8?B?eHlPZHdUdmpJTHEwQXUzYi9jdkgrMzFzQjZ4VjRPemxzenRHMzNIanp6RnVt?=
 =?utf-8?B?V2o4M3RrVTRwaE5MUk50cGh3MjJrenprMnlKUkZocE1EL2xuencrd2ZFdktE?=
 =?utf-8?B?SW9JMzAxWW9WNmNsdXNubko0YnZQRUhaWDZUU01ldEZPOHhtWmxZNTlkcnZM?=
 =?utf-8?B?eEU4UkwrTTZKMXY4ZHN5ZVJXM2dwRG9aSmx0bXhnVURQU1RjdkkvMjgzb1NR?=
 =?utf-8?B?Mmp3dkx4QWJEY0x0ZkJOc0tINkxENG9SdVlMd2pGSWpUSTh6ejl4ekFHMGx6?=
 =?utf-8?B?MDYwZzcrcGo4K1BqVncwWUNBcEZSdm9Ja1BSNDJZS3FsV2tENys1elB5N0s3?=
 =?utf-8?B?NHpXZVU0M3JITjl5bEx6a2JKZURIMWlEN1NHSkowamx5WHpZaVcwcVZYQ01u?=
 =?utf-8?B?UUdzY1hVcCtINXFjU1pnV0t3Q2RqZHovUkM2M0VXNjJVZ1FXcUhoRVhvQ0l3?=
 =?utf-8?B?emdabWZ5WlYzb1JjWmlWNnpwYWlpSEpqUUFDOENtK1ovV0Y2T1FuQzU5R1FK?=
 =?utf-8?B?VUVGbDc3N3FtZ3hSMCtYM1ZFby9vT2VkbDBQb0RmR1doVnRlclJ0Z2RIbnZo?=
 =?utf-8?B?K0NuNFNGaGl2eXMzUHhwUnkydlAvWTdBNmJrY3BraWpQdjBUeVNhTE05ZzQ2?=
 =?utf-8?B?a3FiOVAwY2I5RDM0bmJSazhFU3VRZkhYa0hoMVlFS3FVWGVvR0ZtL1Y2L1BU?=
 =?utf-8?B?YXlNcWUxT0JON1RpU1RqcEFpU3dRWE5YbjlOTEFtaEswWE1yTHorUFdaY2lQ?=
 =?utf-8?B?RENzUEJMc0Z0NnBkN1liaElKZzVkMTBmc0FsQ3JGaEpWQlBhOW5PeUtmeW5C?=
 =?utf-8?B?SGZMeks4SlNwYXNuM3Y5SFNXdTc0NERRT3RxWEV3Y1FwcTd4dTd3SFNzaG53?=
 =?utf-8?B?OU1wNTBJT0NDZ1U2Vk5GeVhqdzFqUVpsMU5jaDZaRHFuV3BXeXVsMXVhekZL?=
 =?utf-8?B?S1FSYUVuUUhyeElxRnpFUUhneThpVlVIdFpCeERxVjZrelE5NnFMQ3hGL3N6?=
 =?utf-8?B?SEdlZzRZb0RsRmZuSGNTRXV2WWhjc0xFcTE3ZnhLL2J5UWMxZ3JETUNGMFUv?=
 =?utf-8?B?RC9xakhuVWhkZkdGeGN5RmRlNDdLRjJXOGZDTm01dkVIMkJmeVNrcVowUWQ0?=
 =?utf-8?B?OVowS244dnlvbm8vM0pnL0ZzcGNJWHhTZkdyVzNqb0w2VDBIUmpjaXZDSFFK?=
 =?utf-8?B?cGlrbHd5bVNyRXVRczlWS0w4NXdmazU2VTd5WmhMMWJrUFUzaWZyZkkwc3Y5?=
 =?utf-8?B?QkpqL1dscGdoSUVyRWppQks4eHZKK1VObXZ6bFZXeW93K0FJWThlTldLdmhj?=
 =?utf-8?B?U2VyeXdGZmpybjhQOXVlQStOTS8zRlc5bXZydCszYUVpb2tvNjJMbmhsNWFN?=
 =?utf-8?B?dzRvUXRNa0JTYXNBQVczMC9ZOVFKVEtVM093MDdKL0VKd0M5ekp3UmFUWmhm?=
 =?utf-8?B?UThqWDhiL2hhVHI4d1M0V0tTVlZhdEYyenlOQXNnVFMrQjh0N1lwYzFuRnJz?=
 =?utf-8?B?RXBJR2dNekdTTUFkVWRSS1ZYR0tjRTVTOHIzd3BwMzNKUWhBOWEzMysydHRj?=
 =?utf-8?B?andSRUR3djR2ZGo4K2tBZGNDNWczL0dCQjBqM3BOaGNuaEZ4cEY1S0k1YnJ6?=
 =?utf-8?B?QUdYUHZjaVFRMmJiZmM2b0tUL3VxeWNBa2JsWWx4ZEdid3lVbnF3U0pKekc0?=
 =?utf-8?B?NlVMSXZOOVVDVlhaVU1BL3FhQkIzbkVEeG4rN2NId2Y0dFp5OFJZci9aZUJC?=
 =?utf-8?B?V2RtM0hwQkpOMDRNeGQ2ejJpN0RyQlRxWjRxK3BHRytqYWl1K2FZUXFxMVg2?=
 =?utf-8?B?QURFMllUOHhVcjErYzFRZ2s0REtiUnQybGNRQ2c2T01NY2g4QVZoU0JLV1gr?=
 =?utf-8?B?TGZDRmU1MVN0cFdSMUhUODBnT3BHR25VLzFaeWJQQ2JRSmx1YmsrVFlvdk5h?=
 =?utf-8?B?bVVRMjNLYnRWMnVXdWNWNVdhd1Y0VXJJR2l6YUZrclJFVzQ3bm5WYnJLdERX?=
 =?utf-8?Q?fM5eu7YqMociW6HPM025EssYP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60cadc2d-71ff-47db-c459-08de1d75e128
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 20:48:46.1014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ePpeu1ua36lJW0rBOLqIC4mlom1JpNu+sfvDIFW6cdtKpnt6TOiQZGFiA4ZGgq/r16nc/+bqHth+0HAnDMntZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6096

On 11/6/25 10:31, Krzysztof Kozlowski wrote:
> sp_device->dev_vdata points to only const data (see 'static const struct
> sp_dev_vdata dev_vdata'), so can be made pointer to const for code
> safety.
> 
> Update also sp_get_acpi_version() function which returns this pointer to
> 'pointer to const' for code readability, even though it is not needed.
> 
> On the other hand, do not touch similar function sp_get_of_version()
> because it will be immediately removed in next patches.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sp-dev.h      | 2 +-
>  drivers/crypto/ccp/sp-platform.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
> index 6f9d7063257d..1335a83fe052 100644
> --- a/drivers/crypto/ccp/sp-dev.h
> +++ b/drivers/crypto/ccp/sp-dev.h
> @@ -95,7 +95,7 @@ struct sp_device {
>  
>  	struct device *dev;
>  
> -	struct sp_dev_vdata *dev_vdata;
> +	const struct sp_dev_vdata *dev_vdata;
>  	unsigned int ord;
>  	char name[SP_MAX_NAME_LEN];
>  
> diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
> index 3933cac1694d..de8a8183efdb 100644
> --- a/drivers/crypto/ccp/sp-platform.c
> +++ b/drivers/crypto/ccp/sp-platform.c
> @@ -63,13 +63,13 @@ static struct sp_dev_vdata *sp_get_of_version(struct platform_device *pdev)
>  	return NULL;
>  }
>  
> -static struct sp_dev_vdata *sp_get_acpi_version(struct platform_device *pdev)
> +static const struct sp_dev_vdata *sp_get_acpi_version(struct platform_device *pdev)
>  {
>  	const struct acpi_device_id *match;
>  
>  	match = acpi_match_device(sp_acpi_match, &pdev->dev);
>  	if (match && match->driver_data)
> -		return (struct sp_dev_vdata *)match->driver_data;
> +		return (const struct sp_dev_vdata *)match->driver_data;
>  
>  	return NULL;
>  }
> 

