Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010017.outbound.protection.outlook.com [52.101.46.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3A82DAFCB;
	Wed,  8 Apr 2026 13:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775653815; cv=fail; b=BeNG36fbj4D2owKrjYGDaT25WbOwXC3R0trxmFFL1HHFaSgLkSnIaIuKhMkB/5sznDbinzmhGPfUYjV2OXX2ZiUO1Kp5+1g96jna5/wZxfZufDYRCkkvOZXOlk5pTqWlmL9bcfRA72D7+X6HxiFtUssmpQ1URORgPpI4t6OvSJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775653815; c=relaxed/simple;
	bh=NAdDE0ZLcGXwDYAvA5jddR2CObjskIV3OqL5G7C/ws8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Hk4ZdRYXGMgd5IJlOOhMSOZkpTmkXWDKkNTshgfOAUKUrqhfUWBVYtFcd65rjPCVx5P3fgR39tHJVuJAFQfk5kbf2kvq1Ylm2IgV2nkaySAk6DOHizu/qUpdWXQbM9/FuXkIz6LtOsDBlOc64rZxevAEubdvTpczPModQHxH9Vs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fONfx9Md; arc=fail smtp.client-ip=52.101.46.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fONfx9Md"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OrixeQbGLbKpjti+5uy3ozPQ7uKx++rydCrp7SWvSviNOFhkgchXrq0eRIo3XUSCs1r9LVKYhw5H1M8E6ZSqq3hBG37jzvncrIO1hvw1RbXpD4i1GqWt37VlYG1lwdqwJ3VLHdUqeEI7hGdY2W3CQirebAuJJ82CNg0O2pFzK/kNcqUjSy2Gr860IYNJDlc/PcD8tRStFm3Nxb7xJdti0PY/h9ofiFsvZQAVYdg1HQVJJRmLjXYJAOaNE/m5pcnma96Ue5JvQbxBCknGEW7HrLgaymbtPUaE/rFrKeqT8trZfUP10JQ0V29O3+wYE2TdakWPAsb0Zx3XXD6d0Fjolg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+lChuils6QVCdP4VQ21kDQYmLBvMNFweQYfmYTux8g=;
 b=S6Mfm3PjppoXPhBgVSLNiySzJ0hkQIQAiCtf3KhZDQnhoFBYCxaf3VH+6UyTaD99HyUIdSaroZmy1SVy/6hftoLBsb2FLAdApa6jjRRW+HKkIgG8WH+BYzdm9uZxDYfBnC841y9rPrs5IHDLbkm4gO9L9xYg5Rvte1DyAvFliZY0iq6EMFtATJ8wqd1pYuIU2H71go6zDBp6N4HqBubXPopNUthIP4L0DHGFxAT79Q75uy9tbXi38ttnBe108EuLfxR3kN60qLoUsguXyBlcW/G5J7P7Y6O+F2eR1gm3VwZU/RwiQWmjnlNfxvFLzavv0ALosHMpw6qVlhceaRMs7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+lChuils6QVCdP4VQ21kDQYmLBvMNFweQYfmYTux8g=;
 b=fONfx9MdbQ3U5Km24wipVgtRdRpuhRndo0I25avZtQhbdXf3RBGnUjU2MJ9kcIoVsLz1941VRHtAffm2a+e8ZWqwNDB3lihyDnYt99AvI4tTwMPI1KF6UIt6KIIIPCpVxyrfA2A3w4x6iEXYqQ4plYly6TRx39//2qoJ1s4EpRs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH8PR12MB9814.namprd12.prod.outlook.com (2603:10b6:610:26b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 8 Apr
 2026 13:10:11 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9769.020; Wed, 8 Apr 2026
 13:10:10 +0000
Message-ID: <c88d7a24-1806-4ceb-9e0b-1a07ecf955ce@amd.com>
Date: Wed, 8 Apr 2026 08:10:08 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] x86/sev: Do not initialize SNP if missing CPUs
To: Tycho Andersen <tycho@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ard Biesheuvel <ardb@kernel.org>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Kishon Vijay Abraham I <kvijayab@amd.com>, Alexey Kardashevskiy
 <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Kim Phillips <kim.phillips@amd.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260407174713.439474-1-tycho@kernel.org>
 <20260407174713.439474-2-tycho@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
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
In-Reply-To: <20260407174713.439474-2-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0073.namprd04.prod.outlook.com
 (2603:10b6:610:74::18) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH8PR12MB9814:EE_
X-MS-Office365-Filtering-Correlation-Id: cba845e0-0d3b-4979-1b28-08de95702a04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	UsCKHQZwC6EvGVCLJcaz2RTDS80l9KOM2xpY/i4u9XQcHf7//1BozOGy63k2ZoF5rl/lEUwtIs2Zbb5pkXsK/P8ePrZy0SLZdZLTCGPHb4J5qIG+8b8+ktzK09PcVZ9CynC4VMreGFsJZ+2dXY/z6lbJFmmI01m/HwdG7wI4wPRhgn2RS7OZfAZLW7kZFzv8M9oJ9nHu+7VqrE/E4+Xk+AxaoejNtSRFP7Aqy+k+oGbtRH9Gm0gm329WIkrWDGxeoKjH0iwVSpzLaxKZqHBE0+3sbBVTz4khKhFI/Fx/fR0jmT7lUdaPlJZtSDsM9ya14XAx5fZvriB6hdzhxDsVsiCU+Awq9xsYkBnfIJKWVEnC7IRJmHyQZiy71ITtJF1aXM4ldwr7XUXs/VihKA4LpBoJEkTRCAhUg/Ru91bjkKPBhWBs1B6upTz0J0lFG0gFczdc9zq7SS26/UE1jcMoWcNPJdr1AWqTUTRsYeCJZpb03mOiqcYE315xjtpTpk+D9Fg4M7M7adDCiJZAkL9wqfqKV+6+ni53+yxL28sZLpjrZhhkLChCDIoJQOjDNguyoTAH6HMVN+m5dpoyinJZk8NpxCUYTPJCLRfO8egGnH7UrExD90IZ03qbwmiPKhDd9RpVeGqA+Ccq6M9WAEtoFOG12XkeTvQn4Zr68+HEDhnUDcrgm56I0apTGFYY6paq0SQi7dtlHmIgAblpuocWcXBjdi/xT0HNitWQfVwXxFsgvXToxKLGUbsRNkFCwgVZvaO49mRii82fylUg7p5DMw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alJvYW1xSS95dkQ3OWJMTmZ1OE10Z2hhWmJmcHU3OEwxTnZnVXlaM0dsSGZ6?=
 =?utf-8?B?KzFrTlc1dWc5eEYxOWp0TnE4YytVeVBsZ1BnclU2d1dhcXMrUDBjbzB2czYy?=
 =?utf-8?B?UVZPQUZoWE1CeDF1RWNuejBzcENmWXJEK2dFV3FSeTdwT2RTR0NWNUFCMmZk?=
 =?utf-8?B?OXVzOFlla0Z1UXlZMWxiS09raDJtcHpqbUk2cjQzb2ZMQW9xQmxuRzZEelYw?=
 =?utf-8?B?ZTlpbVFWN0E4RnhYbFI1WHhkQWRJNTUzZjdyVTRTNm5kVUdkaHZBVU81RUJj?=
 =?utf-8?B?Y1FQWTc3dHpsZFFBREQ1cnpDNkppbUdaTkRkU3NzUlhPY0JyRTUrWlA5S1Iv?=
 =?utf-8?B?aytKd1A4YUhKT1R6czJmdVNsOEM4dFd4blhXaXplS0xtdDlscnRoTEF4R0tT?=
 =?utf-8?B?L2FBWGloczAvaCs3bmhnbFQ0Q0k1N0tCNXVNeDlHeENHSDQvVkhCcitLMjlq?=
 =?utf-8?B?NnhEcVBseHI5Y09PZGVObEVHcEM1OG5PTTNHRThqM29sUWpQemZRaEo1V3JH?=
 =?utf-8?B?SFpHZ2QveEhGK3M2OUFOSVJwVitUZnBKUzJWZzgwNGcxbXg0ZVpOTi9KNHR2?=
 =?utf-8?B?Q0Q2VmdXdENFQU9GZ3poRUlBZjVrUk0yL2tzbCtKU1VXdDZSaGEvQ0VFQTVs?=
 =?utf-8?B?NXhvaVZ0OTZ3bzMxZksyUXFnQjliTzB2ZlVLUklqWTJFc0V5RzA0MzZkVHkx?=
 =?utf-8?B?YnUrUE1ON21acVA2Q005WG5xUzRzb0FXcUY5RW41UENVZml2c1BkMUc3VU0x?=
 =?utf-8?B?TitENXhBWVB0Z0E1b002anB3cTBZeER6dFdFUXJZVlRwS05IdjhQZUIzWFJK?=
 =?utf-8?B?SG4velVBRC95RHYvN2VCNE5sK2UxV3o4OFRUQStBdDlCVjdObjFkNXk2T2dt?=
 =?utf-8?B?VldtbFRGUWFkNGhhMHgyYTduVUJQWC8wd0NEaTNNL1JNQ2lQRk1kK094azFB?=
 =?utf-8?B?dVFUZy9tS3pTOTE4eHBwODRBS0VOdWl4OEdqdStYQm14Z3VFc1NjRklWVEFZ?=
 =?utf-8?B?UjF5MnZOa1NPRWNxc2N1bW5oSTFOaHc1UTFnMVJteWMyQUpzaGhOc0VyL1BL?=
 =?utf-8?B?U1EyMkdTS3RyMlBFSEs2T01idFRFdmZGK1FnR3FGRGtGN0pQSzhNUHRkZGlx?=
 =?utf-8?B?UUxBMU90ZHM0ckl1UGorVS9hZ1pNellNT21nQ242WkhiTHdJVEYyY2FqREdi?=
 =?utf-8?B?dTVYbTRKbk0rUmhhNTYwelhDZ09tMFQvc1hCUXV4ZDBzeVREOTJJcXRuc1Zi?=
 =?utf-8?B?Umg3MzQ5cWJZd05lcU9YS2IxSGRrNDhaNzduQ0h2N1RXY01NeGt2MWZCRVFE?=
 =?utf-8?B?TmRTbVhac2lDdFhreGdQUkxoUUhQYitSQ21rdHhWbWNNQkFOVktTeElyU2hr?=
 =?utf-8?B?YUowOWdoa0NwTU9ENzE4dndvUlVEZFZaam9nL0lYc2dURXUvOWRROVQ2dnBl?=
 =?utf-8?B?VWxzcEtRYTFZSEh1V3NRTmpnemxHYTFvcVVJYzF1cldmMllTZURLdzBuQ0Fm?=
 =?utf-8?B?b29aZFpPQkhPR2RTTW1mV1BEOUpZQXpZMmM4R1RYemo4SGx6cmxYNWFDVVlq?=
 =?utf-8?B?eGx5eXgwaXZTTXZWZGJNRTZCclNwOFB4ZmNvbUVMazhSeWdHVTFhUkorUVY0?=
 =?utf-8?B?Zk9iNm00UU5SMENZUWNsTlE3OWVPd3lTNGFIOGpnaHdnZFAzK1hyNVIzL3FR?=
 =?utf-8?B?QStibGxZQ2hYWkZRbWVoK3htWXBCcHJuNlFDditOTEJtc3gyTzRlQUlLeVMz?=
 =?utf-8?B?RTluR3I2a3ZaYURZTEd1Q2hZYkFwUWNIZkorNDE0d1ZUM0xpS25iVnIwcVow?=
 =?utf-8?B?RjR1dGdBQzZ5UXRRSjljQkZjQmVDdGtlYktxdzNLa0tSMmRyb1VqSktsZ1Fl?=
 =?utf-8?B?VGd5N2Q4aWlCMHI2VVo5c29VMkNjcHpwWWVjNHpxeEFvWFVaUDJXZzY5VVRN?=
 =?utf-8?B?ZkY0TzluV3VEeWV0S0RZTkd1QXlrWUVabjREbFdOVFhCTGRLM0xFRTRwejFw?=
 =?utf-8?B?VmpXU1RacXpZSm1aT0x6WFhmNkJHV1JYU3RySFdnNlpoMGlEMFBYbHkyUUo4?=
 =?utf-8?B?bW10dUhsM0dvZDU4cWZJWG5UVUxTT0hZUWx3VFUzUlRZTTdkeS9OUUFzdmlF?=
 =?utf-8?B?ZjV0d0R2U2ZMZzRRT2xkNjUrY3FRNWdhQ0ZJa3hJdHcyOHFIUnBxR21RRmwr?=
 =?utf-8?B?QWFpbTNkSCtHYytMbXBEd2dOTjVJNUNSNTQ4eHpJK3lFL1BtUGNZWjVnRW1N?=
 =?utf-8?B?WmFvMDNBUGVNbUtiWEpUa2NPMm1NdExTTEFLQWpNUEVvaTY5bXROY1VvY1A3?=
 =?utf-8?Q?hfNPhd/aW+9PFn2262?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cba845e0-0d3b-4979-1b28-08de95702a04
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 13:10:10.8393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wro/gwmjGg2apswqLH5BQ6zxbtvXCA28KtmgWR4tUFgaKvvfdXHPXmLB1m2Gi9vZ2CIhky1MQX0EMvvxa36wSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9814

On 4/7/26 12:47, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> The SEV firmware checks that the SNP enable bit is set on each CPU during
> SNP initialization, and will fail if it is not. If there are some CPUs
> offline, they will not run the setup functions, so SNP initialization will
> always fail.
> 
> Skip the IPIs in this case and return an error so that the CCP driver can
> skip the SNP_INIT that will fail. Also print the CPU masks as a breadcrumb
> so people can figure out what happened.
> 
> Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  arch/x86/include/asm/sev.h |  4 ++--
>  arch/x86/virt/svm/sev.c    | 15 +++++++++++++--
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 09e605c85de4..594cfa19cbd4 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -661,7 +661,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
>  {
>  	__snp_leak_pages(pfn, pages, true);
>  }
> -void snp_prepare(void);
> +int snp_prepare(void);
>  void snp_shutdown(void);
>  #else
>  static inline bool snp_probe_rmptable_info(void) { return false; }
> @@ -679,7 +679,7 @@ static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
>  static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
>  static inline void kdump_sev_callback(void) { }
>  static inline void snp_fixup_e820_tables(void) {}
> -static inline void snp_prepare(void) {}
> +static inline int snp_prepare(void) { return -ENODEV; }
>  static inline void snp_shutdown(void) {}
>  #endif
>  
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 41f76f15caa1..160e60f5f3fb 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -511,8 +511,9 @@ static void clear_hsave_pa(void *arg)
>  	wrmsrq(MSR_VM_HSAVE_PA, 0);
>  }
>  
> -void snp_prepare(void)
> +int snp_prepare(void)
>  {
> +	int ret = -EOPNOTSUPP;

I prefer seeing the return value set in the error condition, but that's
just my preference.

>  	u64 val;
>  
>  	/*
> @@ -521,12 +522,19 @@ void snp_prepare(void)
>  	 */
>  	rdmsrq(MSR_AMD64_SYSCFG, val);
>  	if (val & MSR_AMD64_SYSCFG_SNP_EN)
> -		return;
> +		return 0;
>  
>  	clear_rmp();
>  
>  	cpus_read_lock();
>  
> +	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
> +		pr_warn("Skipping SNP initialization. CPUs online %*pbl, present %*pbl\n",
> +			cpumask_pr_args(cpu_online_mask),
> +			cpumask_pr_args(cpu_present_mask));
> +		goto unlock;
> +	}
> +
>  	/*
>  	 * MtrrFixDramModEn is not shared between threads on a core,
>  	 * therefore it must be set on all CPUs prior to enabling SNP.
> @@ -537,7 +545,10 @@ void snp_prepare(void)
>  	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
>  	on_each_cpu(clear_hsave_pa, NULL, 1);
>  
> +	ret = 0;

I would also prefer a blank line here...

> +unlock:
>  	cpus_read_unlock();

and here. But, again, that's just me.

If you don't need another version, that's not enough to redo it.

Reviewed-by: Tom Lendacky <thomas.lendacky@gmail.com>

> +	return ret;
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
>  

