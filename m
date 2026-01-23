Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010008.outbound.protection.outlook.com [52.101.56.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7620C24A07C;
	Fri, 23 Jan 2026 16:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769184097; cv=fail; b=CSMT5SNrm1i5ZswWqjP7tT+MIZWFZX30uZYIo0VBAp+idvFvdHXF98SluiDHd6hPOYvqFZ7udF0mMRso+iAUE4sOAbvyi6VdbtKqTrrw9uj/+cKtZelKEdMDIaglSO4qKz5Jd4/eETOuvSzvyYuIUgdNGX0lz56iBjnkZvixqU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769184097; c=relaxed/simple;
	bh=j9xKLEtpJvYIt3M6e2x9JGZihls6ZMCFCYxhagYjjkA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZS0GsRqH7f28s1fH00iKkjEwfh7JlYA4cqXfiFtwJqn6wpzPiYWU4oTCaiZlD2EWVJkSKKCBrQgiko9mqCwj9tB6MV3ZelQkKgEGtctl9NVVDgwZf+SSvWpnDQQsIL+BFvvuSH/YBGZZBygF1ZZUTyXHOgSL/uoOML9yNsoHXFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Qs/SfqYW; arc=fail smtp.client-ip=52.101.56.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Qs/SfqYW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y3vGxdhI7olzFj8Bc/AHx0MmYxMba9sDz9qKHzKD1Jz2vbYeV7v1b/VAtabw2y5Ng42xzZnwwY5GSbIvddhvY17vTyHPO9K0FYAb0aKQI32i5tHIJGmHyT8tuhPFSOEDTwqKSSxvQ3bpFSnsS6S7IcKO7GSIrJFctkgScEntHBcWw4LXXoF9HRfil5CMC0itDtBnIjjhcV6S4c+5k5R8iXybH0hQizAXErj2p8W0MkHEzIJ4WA7gqGsCjIv9m2A2So0WAh+2VoG4f4VEsOybed0Kd2zW51RRqDsomuVE9FoHdIYt2oAgesYBfmYRbWuaeKjr+SujyGOysynzMvaJWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qvoz4qVuGkflgbumd7P3B8dSxfbTN9eq+muem+fsIfw=;
 b=xn7E3qvaCSMAY4FWyLJp5aIIjRObc0rt+GYq2z53jczLhfC0JnH53KKPcfrxJkcrp0IBec5nWUpRYGpkhYWHGNAQV/GOUq+G7jAbDXoh3b9AF7Rk2qkx+WKKSD97L/tU7plkfKEyXS1g5rN6Ic/aXS46YnAhTe49bD480DzKs8NjbJqmobID0bxX0vFIxYygYUCGWNKkr3cr9ihADtFnFQuabncgK18aXN3cHPCn/x3jMs2XGvgDJw8y9rjxBEjg3P0ZuguBhpBZzs9TFjzjDIX8zkkv8jLn39RgEIJhgUtIgWSSqDm6La2zNYV9Vn0KDTZPEwUEVapjeKsDVb5mtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qvoz4qVuGkflgbumd7P3B8dSxfbTN9eq+muem+fsIfw=;
 b=Qs/SfqYWHRLavxOsuauVEINcc9V1fHSFExOogQc23PvOLGFFiKfjzLlQzZi3kxxTtKugX26vO3Rs1Qi6ketTuVGTlKKeuYeSvaPWJkwmmSWDZTLRMP3mrg/NLOwMd9RFCKzfcI0Y5SiikFXStPLWA82XqrJYkYvZuJfTIHDeuhI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS4PR12MB9770.namprd12.prod.outlook.com (2603:10b6:8:29d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Fri, 23 Jan
 2026 16:01:34 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 16:01:33 +0000
Message-ID: <686ec310-282e-4e3d-a67f-f5e049cd7cdf@amd.com>
Date: Fri, 23 Jan 2026 10:01:31 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kernel 0/2] crypto/ccp: Fixes for PCI IDE
To: Alexey Kardashevskiy <aik@amd.com>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Dan Williams <dan.j.williams@intel.com>, x86@kernel.org,
 linux-coco@lists.linux.dev, "Pratik R . Sampat" <prsampat@amd.com>
References: <20260123053057.1350569-1-aik@amd.com>
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
 CwQWAgMBAh4BAheAAhkBFiEE3Vil58OMFCw3iBv13v+a5E8wTVMFAmkbaKgFCRZQah8ACgkQ
 3v+a5E8wTVPFyg//UYANiuHfxxJET8D6p/vIV0xYcf1SXCG78M+5amqcE/4cCIJWyAT3A1nP
 zwyQIaIjUlGsXQtNgC1uVteCnMNJCjVQm0nLlJ9IVtXxzRg0QKjuSdZxuL5jrIon4xW9hTJR
 94i2v3Fx5UWyP2TB6qZOcB0jgh0l01GHF9/DVJbmQlpvQB4Z1uNv09Q7En6EXi28TSv0Ffd1
 p8vKqxwz7CMeAeZpn5i7s1QE/mQtdkyAmhuGD12tNbWzFamrDD1Kq3Em4TIFko0+k5+oQAAf
 JFaZc1c0D4GtXwvv4y+ssI0eZuOBXapUHeNNVf3JGuF6ZPLNPAe5gMQrmsJinEArVYRQCuDA
 BZakbKw9YJpGhnSVeCl2zSHcVgXuDs4J2ONxdsGynYv5cjPb4XTYPaE1CZH7Vy1tqma8eErG
 rcCyP1seloaC1UQcp8UDAyEaBjh3EqvTvgl+SppHz3im0gPJgR9km95BA8iGx9zqDuceATBc
 +A007+XxdFIsifMGlus0DKPmNAJaLkEEUMedBBxH3bwQ+z8tmWHisCZQJpUeGkwttD1LK/xn
 KRnu8AQpSJBB2oKAX1VtLRn8zLQdGmshxvsLUkKdrNE6NddhhfULqufNBqul0rrHGDdKdTLr
 cK5o2dsf9WlC4dHU2PiXP7RCjs1E5Ke0ycShDbDY5Zeep/yhNWLOwU0EVo1liQEQAL7ybY01
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
 /5rkTzBNUwUCaRto5wUJFlBqXgAKCRDe/5rkTzBNUw4/EAClG106SeHXiJ+ka6aeHysDNVgZ
 8pUbB2f8dWI7kzD5AZ5kLENnsi1MzJRYBwtg/vVVorZh6tavUwcIvsao+TnV57gXAWr6sKIc
 xyipxRVEXmHts22I6vL1DirLAoOLAwWilkM+JzbVE3MMvC+cCVnMzzchrMYDTqn1mjCCwiIe
 u5oop+K/RgeHYPsraumyA9/kj8iazrLM+lORukCNM7+wlRClcY8TGX+VllANym9B6FMxsJ5z
 Q7JeeXIgyGlcBRME+m3g40HfIl+zM674gjv2Lk+KjS759KlX27mQfgnAPX4tnjLcmpSQJ77I
 Qg+Azi/Qloiw7L/WsmxEO5ureFgGIYDQQUeM1Qnk76K5Z3Nm8MLHtjw3Q7kXHrbYn7tfWh4B
 7w5Lwh6NoF88AGpUrosARVvIAd93oo0B9p40Or4c5Jao1qqsmmCCD0dl7WTJCboYTa2OWd99
 oxS7ujw2t1WMPD0cmriyeaFZnT5cjGbhkA+uQGuT0dMQJdLqW3HRwWxyiGU/jZUFjHGFmUrj
 qFAgP+x+ODm6/SYn0LE0VLbYuEGfyx5XcdNnSvww1NLUxSvuShcJMII0bSgP3+KJtFqrUx9z
 l+/NCGvn/wMy6NpYUpRSOmsqVv0N71LbtXnHRrJ42LzWiRW2I5IWsb1TfdMAyVToHPNaEb0i
 WiyqywZI5g==
In-Reply-To: <20260123053057.1350569-1-aik@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0009.namprd08.prod.outlook.com
 (2603:10b6:5:80::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS4PR12MB9770:EE_
X-MS-Office365-Filtering-Correlation-Id: 903ab7a1-3e45-4eec-1600-08de5a98ae01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TzJTbDhoQTJkaEFZUHRXNzNKMWFYU01MMUFJekltUklEZlo4MERORjNNQ0I0?=
 =?utf-8?B?Mi9iVkJkemJFTTBlSS9XKy9HK20xc1hBd0lLcE11ZmJSSFZISmZuT1ZRRVkx?=
 =?utf-8?B?MDdDVTZFTVhVV1ZEWnBPSHIxS3BDdGoxeVFuSVdtQU9mbWRMS1dBZmhHUE5z?=
 =?utf-8?B?KzFyU0FLK2F1L0NWZTRQQ25hOU9LZUxTUTJsVWtCNG5vTGY5N0xpamNLcEsr?=
 =?utf-8?B?M3dNVFBhM0xRbTVQL0xlUUxidUIxQ1ZkYXNvRDk1dDBNUGZ6QU1ya2xpUHN0?=
 =?utf-8?B?RDNDYUE4UG9Oak9ONDFxQ3VkNUtSMlk0NDFGSjJoYUkvUDFqSWpjRDVDNkh1?=
 =?utf-8?B?MnBmUmRMSXdmU2U0cmhyWG10SWxpR0I1OWxaaUx2dVRVSVlEc3FEYkJjajgz?=
 =?utf-8?B?WDVHeithYWhoQXI3V3JJd1IwMFZXSnUzdVFzMWp3bkM5dmhMY2JZcHMyVjEw?=
 =?utf-8?B?WFZZbjFMY1pZZXh1VTBJNDdUTnVIckRiVmIyY05pZzRuT2NUdTE3aERsV2VL?=
 =?utf-8?B?Witnc1FiK3NkaGpBWUJDT0lUNFIrNS9ldktFRFJwUVM2UFFLaUJNaG1iVURj?=
 =?utf-8?B?OExKQ2lQSzRjV01aQ3FkaDRRQkxuem00UFJMWlR6SjdZeVhFQzN4K3lEdW1Y?=
 =?utf-8?B?WXU5MTYwdG1nOVRMNVNaeFpFUjFGTitCa21MNjEzUUFyVmRUdWtLQ3VFSWRw?=
 =?utf-8?B?bDFxVVdjTTdnNVQzaVVwZ0pSMFZtSmtuNW1kaHVBWWhMQm1yZ2RYbFhKSWcv?=
 =?utf-8?B?OXRNbmZSaHp6SkZOc3Bub3JmS3JTVW04aWxkb1ZYNjdwZTZVb2srZ2pUQzNQ?=
 =?utf-8?B?UFloSE53d2ZoZFZHVWxJKzRiQjB0WkphNDRiSXhpak84V1I5VFdpRVgrQzMx?=
 =?utf-8?B?akpNNHJiUVRBNVVWSE9nam10dGJjN1I1YWxNUXFRekVEOUg0MTRDZlhGdUtt?=
 =?utf-8?B?M0p3VFlLdTduYnJnck5VdExtbHgwSGxpRDY1bzNYSjEremFEMEt2bHUzeE9L?=
 =?utf-8?B?RmF0VUdBK2xiaGxwTTNvc1NBRmxuOE9SVFRXdm54bUM1d2pobmlZN1U4YlBR?=
 =?utf-8?B?Y3dtNW1sVm9VOFlyZktnU0dHR21wcEEzZGs5Y1A5ZDJnRWc3enR4azJFSkVm?=
 =?utf-8?B?NlI5SXErMWVuNzcyT1NWdjhuc3VuM05XZi9BL1Q3MnU0OHpXUDhydGZLcVZ0?=
 =?utf-8?B?Qm5zYnRVdmdhWWRnajhHNDZYMDVoeGRZeXE0SUZrbXJqL3pmUTUzME9wWmpp?=
 =?utf-8?B?QkQ0dGFWTi9WOFo2MDllbGd1eEd0U2hpVWFsNVEyWXZIcTNVTVpUdjlVeVZ5?=
 =?utf-8?B?MnJ1bFlEOGdFUVU3UFAzU3lwY3JaUktYM0w4WVVwb2htVzVycjFKa2RJSFAr?=
 =?utf-8?B?eS91OHdFazhNYnd1RW90Q1Fla0hkSVRFTXFrZFB6eFpyMDFCL3lTdElCMXZa?=
 =?utf-8?B?dlZIbjM4aEtDN3Bac00va2QrSXFBQnRLYkQva2FDVWpNdXNjYmxIRFliUity?=
 =?utf-8?B?NTBXaW8wbmZObUVBSlZKV25YYjdHajBnNk1xRVpqZU41eEZKWWo4bWhBbUt4?=
 =?utf-8?B?Q2hIVENVQmlDakh6NWREQmRHUFp1L0J4UDBWUU1GZHk0QjdkUFBkZDBIbGRG?=
 =?utf-8?B?UzU2VjF4OGJtMmE5ZGtCTlN3ZVkwWlplL0orV0dZQlRDQ3NrbzA3ZFBKSU5P?=
 =?utf-8?B?Q1BmYU5VdW5MR085WDJYK2VZYXdxMncxM0xZWUFjbGd1bElWVjd5WDZ3Y2o1?=
 =?utf-8?B?WlA2WnRMdUFpV2J4WUlsWVpoS3AwdGhFREx5MXRRMXRLNmFCS2dpZUp4MVcy?=
 =?utf-8?B?SzV5TkhoTmo3bHBGb093b3dRaEQxT0FLWTdRWVZyU21IaUVQMHo5ck1VTWR2?=
 =?utf-8?B?QnpTYm8yRW85Uy9lL05lV2o4YVVzSmtZUExaNE93a0M0WFZpT1IwZHhBcGVn?=
 =?utf-8?B?aVMwdUl3Nm9NSGhQdEJPMFViNE1tSHRaUGw0UlZXbHZ0U09VTDZtbnN5NjhN?=
 =?utf-8?B?b0Rjd0FkZkFBQ3dIWG4wQ3RvbE16Q2d4aFh0YzJmdWI0RlR1bVlHUDVxcmti?=
 =?utf-8?B?azJJdnJHQ3QxZjBGODJ4WFpBQ25oL3poTU5HQTh0V2lYQmRDUXBrbUpzVk9D?=
 =?utf-8?Q?BF4Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUxtdkVHNGEvZ0VmekYvR2JwTThtMzV0U1hndG9sejlwb0ZpaTJBVFRuWGJn?=
 =?utf-8?B?U2pGdnczZjh6RkdSYmRPdzNXM0t2Y3RtRTh4eGVNUGpYQVNaVmN1SmZaVkpQ?=
 =?utf-8?B?OWtVcDVUUENhTHVpeGxKOTBMUytLMU5KK05sSHBUWDVFdkh5YjFieWdzMEhL?=
 =?utf-8?B?UGRrajdIdXMyVlk4Q2YxdDhwM21jWW8zRHloTm1nVGxyOEVNNWxWK0FXU3dw?=
 =?utf-8?B?UisrYnljdm5DVHRnSHlxdFJibjZPUXFsWEZTYUhBNVJEZ3h0N2VJdmY4YlN2?=
 =?utf-8?B?M0RRNWp4VGYrN2x0bHU5VEZuNGxWcEFoOHdnaFk0RGxFakwxZ1NFb2N4Yys3?=
 =?utf-8?B?WEtSRjFRTkJrVGtMRTNBQ1h1WmlXM3dtQmZQSUdBL2VzcmVvQy9sNUhjdHEy?=
 =?utf-8?B?dHR6dVBscWFRUHJJOVdRNCtHdU54a1hQR0p5TzNKQk5YSERmN043K2pLS0FR?=
 =?utf-8?B?Q3ZlbE9uNVZKajRyclVBOGh1RnBPTFhhbUZBZG9UWHF5bVNTMUhLMkdMc2NJ?=
 =?utf-8?B?N3M2VjBHUjZmL2NFN2Y3K1FtOXppM3N5ODVaa01hNXR1NldFaDd1L2VuMkEy?=
 =?utf-8?B?amJ0OVBXWTN1UUo1VDVFWnNNOVU2VmVFR2pQdG1RdXpNT3VOSkt1dHF0aTVN?=
 =?utf-8?B?TWdGd2RkdmdNT0ZVQlhzN0d5bndpc3JGQXorMFJoYmRrVVNobzJZY29jdHZ0?=
 =?utf-8?B?VHVpaW5Mak9PRjUwSGpRcFNzc3lpMnRpV0wyNmpGRXM5V1BSOUd0TzZmVDZK?=
 =?utf-8?B?N3VXTzdueC9FOHkybFJrVXJsRXpTenJqemxPZFB2SkxWOHI4UnJOODAxWmZi?=
 =?utf-8?B?L2MyRUE3dkJkOEh0MGMwVHNpVDM4ZTNueGg5bTR4L1NybW5BZHNyS1BCQ20v?=
 =?utf-8?B?OUtHc1J5d1JueWlmTzJCZmUzUXlReXA4dURpYVhmU3ExN0hGUzkwZHVtWHV2?=
 =?utf-8?B?djBCKys1RXYzMFFpaFk5SVRXWjhFZmxzdzF6UFdGbDhXUGlKdXd3K0gvMDJK?=
 =?utf-8?B?MnVrSEJ4RlVBQnByV2FtQ05aM1Z2ZkJXQWlnMG9BdnNiUS9Bd0UrRm9VUmF4?=
 =?utf-8?B?RTNqTzdpWG5qNmtYZ3NQam9adkNzL05nY1lVK1IvKzdDTitONzU5YjQrZ1Ba?=
 =?utf-8?B?QTFISThnK3pZUFNjbWRwdFFpeUEzT1FWVm5KalpNQkgyc1grNm4wNHFyTFZ1?=
 =?utf-8?B?aEtVZHZEVitHZzNFVzR3ZStEbXJnQnNoYUVFV01wbFNIK1FQeC8xVWZxSWJ4?=
 =?utf-8?B?N3dBeUxEODZpZTRuWmQ5SURmdFJ1SFMyOTFycU1jcFN2MEtSdWRRbFpmamY4?=
 =?utf-8?B?a3llVmZneXp6ZUY5WHJOajk3c2k0Ymk0Vk1iVk4rUUdJejc1T05ZYlN1U1Qr?=
 =?utf-8?B?cEs2Y3diVzVlbmdwR0ZVc0dTZFZ3RHd1c25samF6VU9OMW9oTmlNdENzMDNH?=
 =?utf-8?B?Mm50NG5tMnUyWEJ0MG1tVEhhZUtTRE9jZDRFS2pYR3U0V1pOcmFKbWhraE1O?=
 =?utf-8?B?ckM4MlI2bGhrWVNmNU0yVTRZd3V1aGN0OEJGWVZOSGNEdE9Rai9DWDhWWC9y?=
 =?utf-8?B?S0xMZ2ZBdWlFaVE4MWlQb0o1RXA5WGYvem5vMmFXRjBRYjcxaXozY2JwRmdL?=
 =?utf-8?B?SG14UzlIUCtlTXord1FiSU13Zm1OWGh3M1g2aVpsQXRuTVpzM04wRFpoMmdF?=
 =?utf-8?B?NUVxa2RVQXB5VFZjM1g5VkJvWUNKdUZoUFo0bGlxazJ3SFJtSmJZNWNHNjJt?=
 =?utf-8?B?NlgrNVRvcTJLcWRQTVpvTXJhVVdTcUcwV0Nkdm9VS0xISjdvdkhzQTE0bGxw?=
 =?utf-8?B?Zno5Vll1cDNiNGZVdk5RNHpPa0x1YUlGcTM4d3YyMjdQaGtwdklNSXRCK1RT?=
 =?utf-8?B?QitHSW5JUGtVMTZEeGZhb0prZ0ZwR01HNGhMMjJsOG5LUW9sVXpxNFZvZDJK?=
 =?utf-8?B?ZzhPa010ZmlKT3hDZXRpMElRR05vN3hsV2JhS1ZCelBnQlhYeW1lMkF0Z212?=
 =?utf-8?B?OUFSWFpwaUQzLzZXYUpmK2t5WU44ZElYVzhsNkh3WXhCaSt1NE0wQzlDWWZS?=
 =?utf-8?B?RE9QUHhwMERoNGM0OUlGb2tGcnFTZW5yWXVyRUlWbE1wK3VIenJ6TjZPL3h5?=
 =?utf-8?B?NDdJZGtiNUxGM2tQcjREck1OSTNydEZDMzhvUFlacHJ0UDlwOURrc1o2dS9T?=
 =?utf-8?B?MlVjK3BvZFF0U0RuQzZBV0Z6UU9vQ0RSU2R2dkp5YVF5N1NWS1d6VUY1d2RO?=
 =?utf-8?B?R0xaOXhBamE1N3ZuRDFFUXV2SURadUgxR2ttMW5pbjh2bi9hVDcycVE1QXZX?=
 =?utf-8?Q?Stx1UkUDTQIvfbiCf7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 903ab7a1-3e45-4eec-1600-08de5a98ae01
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 16:01:33.6384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xlE96pmDUla9BtW/eMUE0c+np9d57+odsZD7ZENl/DzDzBtgYdNsngqyPCa7uTkr6HV09cddJ90KO9TDE6Hs/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9770

On 1/22/26 23:30, Alexey Kardashevskiy wrote:
> A couple of fixes for bugs discovered recently as we got more of
> these devices and tested more configurations with multiple devices
> on same and different bridges.
> 
> 
> This is based on sha1
> 0499add8efd7 Paolo Bonzini Merge tag 'kvm-x86-fixes-6.19-rc1' of htts://github.com/kvm-x86/linux into HEAD
> 
> Please comment. Thanks.
> 

You might want to send a patch that adds you as a maintainer of the SEV
TIO files/support, too.

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> 
> Alexey Kardashevskiy (2):
>   crypto/ccp: Use PCI bridge defaults for IDE
>   crypto/ccp: Allow multiple streams on the same root bridge
> 
>  drivers/crypto/ccp/sev-dev-tsm.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> 

