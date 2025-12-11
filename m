Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011032.outbound.protection.outlook.com [52.101.52.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F57B18C31;
	Thu, 11 Dec 2025 22:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765490633; cv=fail; b=YtGk6moNJePB+b7GWh8E7Kl5iQNIRxuWwLIR0N+nHOtRGrtoZtwFXFD5frVKfdFxAsybMIJFKxODDqdD4lJpnbzEXzU/7qH9ZHODILOF3eyOdxivYURCH20F7YANlwYikkikN8BP57kcQLtvRVWEllTsrcUf/4rm+KpxMkYQCTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765490633; c=relaxed/simple;
	bh=PYM1HsQwUxV7tG0DJL0KfMWKux5FMx48nHBF0T4bukc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=izFzwpo4QSFpS+GvXhmm2FcKLTjv0e9niK7qsyOupdxp5N3dUO3SgUZx01xyFzB3IgpNiF5aSoPlGQybD+SOYbqpaLGsAP3DrutLNddNGwSlOzQ+ajAVKyYL0BI+ctSod3XkIkgvcQZmXOMg4PU6jW5R5n9rXlBo5HTaXwQAins=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BvuR5AXI; arc=fail smtp.client-ip=52.101.52.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BvuR5AXI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HFOcY56n7/isO7HpYgbQF+MONBckPGouy2k571LIujVzeDo/Javnv5E1jJuEO4RuYqu2T9mTgAWKtiZoIwZmLm2vCVjfN5rqJugA4svkdcDczSsYZAmD3wU/RQe0TeqqBx7ue1/j6MQDE5Uv72+zlp4BrCf6KYlMca0ttpjqw6k7UFzKoZmOLG8tDVlIcZb7Xx2r37X8rjU8YsLBOQYXjTYKJJ9UbmWDQ+F/iXL2huheu4I/m4v1Nrs8M1V/SLc2/FzfH16RBJKAtyKR1e3u8zvo/mRVNLDr3oIEmgui4WJP5b8pWpSGP9S4kMVWh9hER0ePjkPbXrjlaq5MOEs7Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BeykosqGGMNOq6oE8dYKj4sVaAF+SDTQBB2KE1BsEMY=;
 b=MiUOh66bxQgpH2U3dg9HmgEsiQ+x7oFIXHBrMORR8f9ujWZ0bESUwb7voFvIPD1HJ0aSYUP06fSzbyABZJHlY1h5B2a1GoTccWpe97NtBGTBCfpP4qrzRFXSI7hbdptBTo1X5xp3wKCDzx7xiinwik6XAVJdZ0xPCKyT3XZP6fvjxn9SIKtC0wMEBF17aVCRqyzKYyTV3BoUerYyjqR7xAlBQmBk1XdBpoaxyl8On4GlnWVBj8ePcwdjTG5UCkqSkROi7SV+6fqdYzdkQXqp7qybgsCK86j1cbx+4ey8UIB3mshtMzHM9xDuP5nGWnDzSZeECo+0qT6bAOyxOmIzcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BeykosqGGMNOq6oE8dYKj4sVaAF+SDTQBB2KE1BsEMY=;
 b=BvuR5AXIGR4dvyFQLzB82xuzsZf6TttTKCda2FGOEfQKJZK2drzowr1xzRplrYT6WOeK0gIoLALF3kbnwFpx+zFAWWgcc0TfflvC6u+e3olL7pcdnpHY1LDYex42J6pSVD9cJppCNc/EQarEfz6wnLFr2tjRmjXWETuoygoBG88=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH0PR12MB7078.namprd12.prod.outlook.com (2603:10b6:510:21d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Thu, 11 Dec
 2025 22:03:42 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 22:03:42 +0000
Message-ID: <41f436c5-d11a-4de1-b994-e88bf21047a5@amd.com>
Date: Thu, 11 Dec 2025 16:03:23 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] crypto: ccp - Add an S4 restore flow
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: John Allen <john.allen@amd.com>, "David S . Miller"
 <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
 <linux-crypto@vger.kernel.org>,
 "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>,
 Lars Francke <lars.francke@gmail.com>
References: <20251211212847.11980-1-superm1@kernel.org>
 <20251211212847.11980-4-superm1@kernel.org>
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
In-Reply-To: <20251211212847.11980-4-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0052.namprd11.prod.outlook.com
 (2603:10b6:806:d0::27) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH0PR12MB7078:EE_
X-MS-Office365-Filtering-Correlation-Id: e26388fd-c8cf-4307-131f-08de39012560
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0dmdnBKdFhSREVNQXcrdUxFTEhFdWFYTG8yKzNDak1WaTZwK0txR1dTa0lO?=
 =?utf-8?B?VENrNkpQZXhBVG9ObUNJRTY1NDZaQXU2alhVZGpmMXJOQVFLenhBQzczaHZG?=
 =?utf-8?B?dlJoczhsazQ5Ulg0djFEdCtYU2tVSEJDZXR0U3lLc24yOTVSTWQ0SXRCVEg2?=
 =?utf-8?B?MmFWOG14VGp4dFN3bFAzdTVrV3JtYk50NjNQNzVWcjFucFFnZUNpY2E4a2tx?=
 =?utf-8?B?cXZEeUtxcDdwbE5kNTRTMnE4aEhDdUdFN1A2TmVaVnliWEN5TXk2RWpsT0FK?=
 =?utf-8?B?UllxNklCTEgrSERJOTl0d1V3ZEdIcnc5TDJTUHZub090NEhuRmlDbFRtUTRk?=
 =?utf-8?B?RjZEYXRpWnYzZ1NQNDJTTXFyc1cwOWIwdkc0NUFOdDduNHpQaGFCNkROc2xr?=
 =?utf-8?B?aEo4QmFmK0ovZks0MkI2SmV5ZWZLRlJ3U0F1UmtrVzVmQXlkaEpJU3lIL1lB?=
 =?utf-8?B?NFBnQS9oR1lHWWFpYlBGODhlQ0xUQ2ExZjFNQ0RlUk1abEZHYk5xMVBMcHUy?=
 =?utf-8?B?V0dEcGhKeXNuS1pNZU5ydFNxWXQweGcvQWJydFlaaHprdmhSN293aUludjg5?=
 =?utf-8?B?c0Rhb0ovdzg4MWxkMGk2RENuMzhPVU1rMmlRUmFFTU9HcUczKzVNTDhGa0tx?=
 =?utf-8?B?V3hMNzBTWUs0TW9pN2J4aXMxRmJnVnY2QUhaUDVyRUJqeDFjYWVDTTA4U3JN?=
 =?utf-8?B?K3FDb1A5d0U3cVgyS1RHM1RjQno5dkxBa2JnZ3F0aUhIZE53VXc5b3Y4WGlT?=
 =?utf-8?B?WXhlSXRNTm0rb3QwVTdTZ2FlRnd3YWxvcGVnTjBUbFNIUzBYcVcycmFoK09J?=
 =?utf-8?B?RlQ1eXR4cysvWDk1b2xacy9sZGNGVHRlV1B2L1cwbklUaFJpS25MZmlVcDJL?=
 =?utf-8?B?Y1duYm5oSjZueHZuZHJSRmFzTHF1MVNtUXFWNXdZNFZIeXFSeFNSYk43UkVF?=
 =?utf-8?B?Z0I0TnZFeXZGNlhwd01RTjM4S0FHbFR0dXAyTEZlU1F6aHJCRTRmYVJLVW1m?=
 =?utf-8?B?SjZ6cjNzYlhGd3ZhY1dRS1FOZlh0Y2Rqd1o5Z21ob2p2cVZiWnNmRXRZVElE?=
 =?utf-8?B?TzVibTE4L0Z2ZWhvbGlCZXZMMzExTkN5RjUxSEcrWDQzS3ZsSEJMQURDQ2dU?=
 =?utf-8?B?SEVjVW5DeHJBUUVOV2xJS1B2UGVkbmNWL3ZEbkxxUlhGV01hQm5CVU5nK21T?=
 =?utf-8?B?NHQxZGtNK3VpTjEzYnlWYnF0SGxaS0svbFVJS1NYNDFIb0lTNHNmSitOU2FF?=
 =?utf-8?B?UkVLNGpMTGEyNFgzMTdsU1ltcEpWZkwrYWZqMnhEVkQ2NlZ2aUQwcWFsOFB3?=
 =?utf-8?B?NnpOZDNoRCtiemlwbkRnck40azUrVTduZXlGUVM0S3JONkd4N01lTHV1RTlw?=
 =?utf-8?B?WVhkU2d3aFNPbk9lbUVsUW9ZRDh0TFNGMFp4a3pFVy9xWHk3b1J3akovYnYy?=
 =?utf-8?B?N2FuaUM1Z3V2aS9XWXNQbGFEWFpYMjZhNVAwbUVxQmdaZ0pkTmdBVTNubWpr?=
 =?utf-8?B?RTMzejRVVzFseVdKbmNKbDR0WFpnVCtQZnA3N1RrRFZ1Q1BqMnBOek95NTA2?=
 =?utf-8?B?ODkxbHNmZmlwZzM0bUlhOEhqZ0hIeFlXN3MvVFZiRHJ0RDNCL2FsRmRMZTlh?=
 =?utf-8?B?R1JDcExvM2RPd1FtOG5mUXQ1cE5VNVFqUk44eWRjK05FVXNZYVEvUmo0bmEy?=
 =?utf-8?B?K3NmdWtDNDZmNXBjbWNJRFlud0phdTZid1crdkN5cXlES0ZCUlVWNFBWU3RF?=
 =?utf-8?B?YXpDOTZWeWdJeDdsMTRtWTMxZVNva210QnhFZW1SRmdWOFZ0WTV0dzdGUUN0?=
 =?utf-8?B?RG45WFExbWV5YlBtUnJhTFJidzBOeVN6L1p2cEFXd0JxdWZJKzN4c1F3TWE2?=
 =?utf-8?B?eUMxNnlGa1Y0K1dTdk9OU0RrSmYza3ZBaUhuS3JWOHQvbU5GeUxDOWQ5Ukd0?=
 =?utf-8?B?UXZLOExNWU5mQWY5Rlh1SDIrUmVQd1dVTkppRVFOQUdQMkk1ME9QSjN4YVp2?=
 =?utf-8?B?L2NKTEp4WHZnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3RNRUJ2UHprakNKV2o0U1pKVHFpOTROU2xHTG40NXoxR25wRmthOVZQZ1dw?=
 =?utf-8?B?YVl2WnhUYkUzRzJIWHlpTStFZndsNHUrQXh4cGQ5UjZqYUZxVFRhTU04MlhK?=
 =?utf-8?B?VHB3aEZ0YW9udlRIVFZRL3N6VUdPODVhUElwNjVsL1VacWQ5alJZTzh5bktu?=
 =?utf-8?B?a3FXNHd1WDNiQjZsN1FHS2NPUFdSTEdic2dMaFhvZ3FCSExCT0h3M3RieENw?=
 =?utf-8?B?TGo0QVI1TUZHeGE2QW96Z3k2cS9GSlZUNmU3b0VMaGdzV1djSVMyaStlNXJs?=
 =?utf-8?B?UmRzb2UvQ0t2UzM4R2lUdUFCVkYxcUFTbi8rcmkwelQxeG9wVnZKdVM1OTJP?=
 =?utf-8?B?aWRhdEZTQzhMcFhuVTQzMlZxaUlUSjUxQmx5aU45T1hnRTdHOVE5RGVuaFNQ?=
 =?utf-8?B?aDR6Uk9XNHJmQlNSZ2JpYlFsYUFEVlR4ZEJwZVlEcDRDbHAvYU0xVTFkN28r?=
 =?utf-8?B?VHhEaTV6bFlMTGRCSUc4QndPYXgrOXNhQjVpL0lxQUlSQ3dhR1FGUGo4clpy?=
 =?utf-8?B?eEtIM3FRakE0Y1YwM1lzeG4zbUxRNE1qbmJkNEEwUng2WmNDU05Xc3B4Wi9R?=
 =?utf-8?B?Z1pMUG0xdWRzMFBGQ2pPOTFkbXJLbmpvYTNFbTVLQW80UFFaMkZKaXdKZVVC?=
 =?utf-8?B?SWVsMWRDZkpUVzNqbmNYbGlwbUNhOHowQnRtNEhTR1dFR09RRHMxeWhsVXVD?=
 =?utf-8?B?bTlTRnNjR1hvU1BrNGYvN0pLQ3JZL3lUNHJGOEZ0UmRtS2g5RTltak1wY1Iy?=
 =?utf-8?B?MFYyMjJhSFM3SkMyV2xPbVRaZVlNcTVUSVZlWEVYZS9Hb2Z2WmVzenBRZFlI?=
 =?utf-8?B?L2EyOUxRaTZuOVN0bFlLckNYRmcwWk55ejUySzVFMXpIdTNuczdXaTF4SkNK?=
 =?utf-8?B?MWtRME5pOUFqMk9BTHlmWUhQZDV4N2prU2pkeDU3aGg3S1duR0N1L2QwTlpx?=
 =?utf-8?B?K1I4WjNGSDd4RE5rRlpFUnBjaG1xOEVSWXJxYjd3eURtd1pWaERtM0V3dGZi?=
 =?utf-8?B?MWE5OStiRzNPZldoeDdwdytnR0QzOU1DRWFwUlplTnRVaWVWVzkwa1l4citn?=
 =?utf-8?B?ejNxcVhDVHg4QWlFQ3M1dExvc0dmZHByam5tN3BnbE4waFhNVGVLUjIwd1ZW?=
 =?utf-8?B?ajZVL2g2MlVUd2preUJsbi9LcmV3dk1HN0Q1eUYwNG1lQ3B2ZllnZjlOTTV2?=
 =?utf-8?B?TmVJYWxsdXVGMVRuRyt2RDlXbEdsRmxSTjM0L21Wa0w3WUd6ZFVyM1hQMUUv?=
 =?utf-8?B?UjJJd202RXNQZ1dYVmtEZUF6UzY0cjRVOWJKZTV4Q0txRUNRUDdkZUdpb0dE?=
 =?utf-8?B?bVByY2lLZzJDYjJ6Zlc4bC9YUzd2b0lORXJkWlVZcFE3OWgxaWxPbFBhdzhR?=
 =?utf-8?B?dm45NkdyWmtXSVpuSmtaL2syT1Nic3h2TEhVclhmWkJBN0orMWFGTlNtYzBK?=
 =?utf-8?B?ckRoN1RoRE5tZnN4dm1qVFF4NEFmYWtUWXlnRmExTlZnbncxU2N3N1c1cHkz?=
 =?utf-8?B?SklRaUtxRmpxVFVSemhramhocittUkM1QjhVL1RmZW5DS2I4NGsvYVZNVmYx?=
 =?utf-8?B?VEI1eW5VTnBxRko3akQ1VTNmWHpKbXUzSGZXSjhXNlZpV3gwV2J1Y2czQ2ox?=
 =?utf-8?B?L2xWZE5wbzRxeWhQUXV3amRlUUdaTHl6R3JjN1hnWlptZUVFUXlwdFRSZFVI?=
 =?utf-8?B?dk5WbVNSN2RlNndNNTQxY0xKMEU5M05kNEcwVFducE41VzRteE81Rmx0UHNu?=
 =?utf-8?B?K0l3SHhTQitsajhuVWMyTDYxZ3VQbGJWVUk4bHZiVlhLWkJWRzdrWUx6THVa?=
 =?utf-8?B?SnVzUW1haDlUMzBOL0J0bkZVdFFzdXFXelRQUWM1V01XOFdpZ3UyR2ZWejIw?=
 =?utf-8?B?Zm1lNHB1Qk5wOTdQTnhTU2NRcHVRMURJZXRNTGxxTnNvTE9MbmJaS21HNXJQ?=
 =?utf-8?B?clZWc0pTL0FGRWRzeitQWmFnekpBTFAxcW82djNoR3dDYmZVNExKSGI2NEVL?=
 =?utf-8?B?eWtOd0hkemRlVE5HWnQ3bEZ6WGlORWFtalpDNkdCYTNiYmdqRDBIT3Azejdz?=
 =?utf-8?B?WlE1aVFidTR5WlJQdUdRTWxhbEV5NTN3aWgxU3NNR1BjMnIyck5CcytwMHlk?=
 =?utf-8?Q?qTbg5CVq7lBynRLgiSwht7sRG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e26388fd-c8cf-4307-131f-08de39012560
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 22:03:41.9911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q/TCJgn51rB6J4x7eI35qcEFMPGJt1IsrI8r/EmNgpp0Z9MnwhKSw1zJqaPXM0ZZhLtmixojm71AMfvivh1Nvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7078

On 12/11/25 15:28, Mario Limonciello (AMD) wrote:
> The system will have lost power during S4.  The ring used for TEE
> communications needs to be initialized before use.
> 
> Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
> Reported-by: Lars Francke <lars.francke@gmail.com>
> Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
> ---
> v2:
>  * Fix LKP errors
>  * Remove free phase
> ---
>  drivers/crypto/ccp/sp-dev.c  | 13 +++++++++++++
>  drivers/crypto/ccp/sp-dev.h  |  1 +
>  drivers/crypto/ccp/sp-pci.c  | 16 +++++++++++++++-
>  drivers/crypto/ccp/tee-dev.c |  5 +++++
>  drivers/crypto/ccp/tee-dev.h |  6 ++++++
>  5 files changed, 40 insertions(+), 1 deletion(-)

This should follow the same type of flow that initialization follows by
checking for psp_vdata and calling a restore function in psp-dev.c. The
restore function in psp-dev.c in turn calls tee.

Thanks,
Tom

> 
> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
> index 3467f6db4f50..e3fa94d14026 100644
> --- a/drivers/crypto/ccp/sp-dev.c
> +++ b/drivers/crypto/ccp/sp-dev.c
> @@ -21,6 +21,7 @@
>  
>  #include "sev-dev.h"
>  #include "ccp-dev.h"
> +#include "tee-dev.h"
>  #include "sp-dev.h"
>  
>  MODULE_AUTHOR("Tom Lendacky <thomas.lendacky@amd.com>");
> @@ -230,6 +231,18 @@ int sp_resume(struct sp_device *sp)
>  	return 0;
>  }
>  
> +int sp_restore(struct sp_device *sp)
> +{
> +	if (sp->dev_vdata->psp_vdata->tee) {
> +		int r = tee_restore(sp->psp_data);
> +
> +		if (r)
> +			return r;
> +	}
> +
> +	return sp_resume(sp);
> +}
> +
>  struct sp_device *sp_get_psp_master_device(void)
>  {
>  	struct sp_device *i, *ret = NULL;
> diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
> index 6f9d7063257d..37b38afaab14 100644
> --- a/drivers/crypto/ccp/sp-dev.h
> +++ b/drivers/crypto/ccp/sp-dev.h
> @@ -141,6 +141,7 @@ void sp_destroy(struct sp_device *sp);
>  
>  int sp_suspend(struct sp_device *sp);
>  int sp_resume(struct sp_device *sp);
> +int sp_restore(struct sp_device *sp);
>  int sp_request_ccp_irq(struct sp_device *sp, irq_handler_t handler,
>  		       const char *name, void *data);
>  void sp_free_ccp_irq(struct sp_device *sp, void *data);
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index e7bb803912a6..ce55563b224d 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -353,6 +353,13 @@ static int __maybe_unused sp_pci_resume(struct device *dev)
>  	return sp_resume(sp);
>  }
>  
> +static int __maybe_unused sp_pci_restore(struct device *dev)
> +{
> +	struct sp_device *sp = dev_get_drvdata(dev);
> +
> +	return sp_restore(sp);
> +}
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  static const struct sev_vdata sevv1 = {
>  	.cmdresp_reg		= 0x10580,	/* C2PMSG_32 */
> @@ -544,7 +551,14 @@ static const struct pci_device_id sp_pci_table[] = {
>  };
>  MODULE_DEVICE_TABLE(pci, sp_pci_table);
>  
> -static SIMPLE_DEV_PM_OPS(sp_pci_pm_ops, sp_pci_suspend, sp_pci_resume);
> +static const struct dev_pm_ops sp_pci_pm_ops = {
> +	.suspend = pm_sleep_ptr(sp_pci_suspend),
> +	.resume = pm_sleep_ptr(sp_pci_resume),
> +	.freeze = pm_sleep_ptr(sp_pci_suspend),
> +	.thaw = pm_sleep_ptr(sp_pci_resume),
> +	.poweroff = pm_sleep_ptr(sp_pci_suspend),
> +	.restore_early = pm_sleep_ptr(sp_pci_restore),
> +};
>  
>  static struct pci_driver sp_pci_driver = {
>  	.name = "ccp",
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index af881daa5855..11c4b05e2f3a 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -366,3 +366,8 @@ int psp_check_tee_status(void)
>  	return 0;
>  }
>  EXPORT_SYMBOL(psp_check_tee_status);
> +
> +int tee_restore(struct psp_device *psp)
> +{
> +	return tee_init_ring(psp->tee_data);
> +}
> diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
> index ea9a2b7c05f5..3409253ac557 100644
> --- a/drivers/crypto/ccp/tee-dev.h
> +++ b/drivers/crypto/ccp/tee-dev.h
> @@ -112,4 +112,10 @@ struct tee_ring_cmd {
>  int tee_dev_init(struct psp_device *psp);
>  void tee_dev_destroy(struct psp_device *psp);
>  
> +#ifdef CONFIG_CRYPTO_DEV_SP_PSP
> +int tee_restore(struct psp_device *psp);
> +#else
> +static inline int tee_restore(struct psp_device *psp) { return 0; }
> +#endif /* CONFIG_CRYPTO_DEV_SP_PSP */
> +
>  #endif /* __TEE_DEV_H__ */

