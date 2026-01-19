Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012049.outbound.protection.outlook.com [40.107.200.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B9235B15F;
	Mon, 19 Jan 2026 14:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768832203; cv=fail; b=Dpu0EsaXeYm6oZXkprZn+uqlyrbYXuTosfu4HHxigMaoAk8E4usRngsvz5k2Rgz27TkjoSwl+dNEU0ZHbcvpxoeJEXK+XquUEJB62oACSk9gsZ71U8DnRrorx6bfsR/L8fmXn8NyU6e8qiNsi67gEjp66HlQU5A0h5YuXQ1acjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768832203; c=relaxed/simple;
	bh=72R2ksfY57Y7u6dEGnB3dkOR9kQgLDpIALpH0uz6a7E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DvBcGu+o/xqU+8b9szOsZkyFdT9UlB3NNgzzrNqn9Ox22QZf577cC13QrvakZptVWAqMdoo77OnGOQgevZUra7L7JewxlqZHW2Zog5q0jRu9gI0/QMFivq+nQTGEcLLiocNug1iuGMA9vSdu2npbKaj+86kPGuMvo/0S51e7294=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OigLjvLf; arc=fail smtp.client-ip=40.107.200.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OigLjvLf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gibz9K3ta0JBQpWNAicHyFFuNwZcXLmEX9RhszTbLW/dACUITjnn87yU/x9vD2vCoPnnzLuz/I18NtOm4Mmv/MKs1y1E0xMZsLb53QZN1Yw4Gqyqhhb1C3T2qsFe8JMzxoY5coDP8wSS188AW9BltddwRLod/W0otdDBm4J/orhc2mCkJ1eANyXKordzF3HWXofEJaIqaOpCI002fydeTV7UQM81N8Qgxwv3JdxeiBuD4r9HMy7GVPoZiuup56V93bmSs9B8Rx2DI3+jnYnVc4K1/aSAHxAMbzfrIhlM6NiF0zYkUyersUDcjdR/S2eav99k4jK7swf1gi8OHuZsTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PS6NlnZn3zNq1AFSUnJKv5SWdSgxSZ6/3oSPdX4sdxc=;
 b=apXwyrM8r1zzZvWf3XesGts9Gyx8EAzI+O6fKJB4ZQvMTF3/sIXVpXwugF2uOU0ip19jLDmyQET/TSBSQztftVULREJWpnjvwa8fuAHZNC3p6qoyFiaRC0QIVMXPVBSduQaFM2zM7EULYOwvcZHjBqOt9jiC+/mg8EdZFQJ1FPah/z8Kln9ptKUWxXMgYI1sYICrNcjaLC2zBipPG701SKIRT0MfcKW2SLHuNDGr3xRwe1fNzP8GVwNrxb9ryYMJnb+Kawvw9IEYV2n6qlhfPfZE85Ef/rO5wRcyBnmgaPTznX/wRok/DDeDJJJ2nGNeU/vQnEpJW4CMiIe60FXhMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PS6NlnZn3zNq1AFSUnJKv5SWdSgxSZ6/3oSPdX4sdxc=;
 b=OigLjvLfzJ+PPCcirz7IZKEFNsjDeKh+sQJtD/YM68oab6IJ4wDrEpeawwZcvJTaZcqfwmOMUBGeFicIrUHk07jnG2CuCA0wVqwTJlTvNem2Kpr9VEXMdO6fKKgyhzIzvtWciS/np6HkBFYfmbrkBOI7idyhI+efSymbz8fni9g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB8334.namprd12.prod.outlook.com (2603:10b6:208:3ff::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 14:16:39 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.9520.011; Mon, 19 Jan 2026
 14:16:39 +0000
Message-ID: <9619ea74-7966-4819-b908-121374481b08@amd.com>
Date: Mon, 19 Jan 2026 08:16:30 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/5] crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when
 PSP_CMD_TEE_RING_INIT fails
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc: John Allen <john.allen@amd.com>, "David S . Miller"
 <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
 <linux-crypto@vger.kernel.org>,
 "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>,
 Lars Francke <lars.francke@gmail.com>, Yijun Shen <Yijun.Shen@dell.com>,
 Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
References: <20260116041132.153674-1-superm1@kernel.org>
 <20260116041132.153674-6-superm1@kernel.org>
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
In-Reply-To: <20260116041132.153674-6-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR06CA0049.namprd06.prod.outlook.com
 (2603:10b6:8:54::35) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB8334:EE_
X-MS-Office365-Filtering-Correlation-Id: e5ada66b-a585-4da8-b253-08de57655cf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UlcxSlJxUGtMQjcyWWVhUGVneFFkVkIyRmpVTUFWUWJ6a1RSOTNXa2lrd2o2?=
 =?utf-8?B?Z09EdHZnUnZ0UTJqZy9yL2J1cC9RSmVBWEp6Z00zcU5lelYvZXF0cWpHUTF4?=
 =?utf-8?B?b1p6ZGVJbVVmanF5MW94dEFIUDRHc3JydTVsWkpvWnllUHd2RThBL01QSzdL?=
 =?utf-8?B?YlVYTkRoeHhVSXcwNDdOc2xCQVgzdi9WV0VqVnJXNlR6WnBBZjY4eG5Jd1Qr?=
 =?utf-8?B?cGd5QjAxR0pnSkpFRmh2OG5xWk84cVJYNDV3UmxxNmgySHhqcWZmanhaY2lr?=
 =?utf-8?B?Zkc1VStjYy9hV2xJUHRkbjZUOW92UWY3cm9GcmJGbHMzNmVwZy90Zi9BcElS?=
 =?utf-8?B?ZStBeUIwVDBRUHY4ZmxXV1kxeStVUDlqMkdDZ2d0bUJkemhicnRvYUgzOU4z?=
 =?utf-8?B?ak5wQklCMFBGRE1ta0Y2QXZzY3lCK0FSYm03L3c2REVyVFVRZFZjZTVHaG9P?=
 =?utf-8?B?SEJLUWF5TVFUUnU0UitnQU5MTXNZeFh6b2dKdEtWbUlGUzRNT2crUy9kR1U4?=
 =?utf-8?B?MUdBcUcxRFJlTnFQZUF5c0JyVEduT3h2SzhpdnJIa01zclUyZVJjMDMvL0xu?=
 =?utf-8?B?MkEySmdmaGNsd2U0ZVFVMmJOZmpyNzB2YU91dUloeTZUNFVTemRzQWpuN1JT?=
 =?utf-8?B?OUl3TFJ4Wkd0NGtVeUs2MmZoUDVOcUtwd1VwQ1dkam5hRkhZL21nWUJXU3A1?=
 =?utf-8?B?amF1VjZNZmw2SmsxWUdLZjRodGdQN3pjYlBneFRuZDAyZFBORkJYMXNVTHBk?=
 =?utf-8?B?S0IxMWR4bXhMTUhIM0hxc1lCdkd2UUgwa01FSUQvMVo3a1pHYktjYWtRRFcx?=
 =?utf-8?B?ZWoydHBjbFNaaDk3T0hJb3gwM1puK2N3MGFYMzM5Nm9IY1hVV3d1c3R0dktK?=
 =?utf-8?B?d0JGWDhuV2dCNkIzTnpmQ1R4UjlNWWRZK3ByeE04Ui9zdm1YVFBadHVGNnZE?=
 =?utf-8?B?azZPZ2lBQ0J2L1MzMWRFcS9qSXdFU1FVZDNoeDFKSFlNSm1LK25zTEdDYUxq?=
 =?utf-8?B?cjI5YzQ4ekpaemxHTngzbGJqREUxazdPNUQvSVlTVnlQdDArK3BJVGhxMEh1?=
 =?utf-8?B?SUljSUo5Zjl3YVR1dWR3MjJ5SWRTYVBxZUtCNjFTNzdnNzZsREpKVDcwOS9P?=
 =?utf-8?B?bVRrL1NabndUNE5IeDlPVUNPMVo5VFlzNEJQMFpPYnNzck13WTU0dTc4MlRr?=
 =?utf-8?B?VDdIMzRHSytJRlJzbWgrdHcyaW1ZeEwwT3NGZldxVFBHdVV2dVIzb0luUWZi?=
 =?utf-8?B?ZW1udHlXRHFrYmUwWi9DS1FZMlVCL2pkbHZtWTQ2YVloQTkvazZRNWNCUFFn?=
 =?utf-8?B?QTRSaUgyc1hwbSs1YXA0dkJtNWR5RVZ4VklDbGx0WnVNRS9xaStkdnZRNFY5?=
 =?utf-8?B?RkRTODcwY0NGQlVDc0Qyc1dRLzN2WUtQekpOblVkVmZMSTNHZjBocXpaaWV6?=
 =?utf-8?B?eVhhTEJWYmFVa2JHYUk2VmZlNnhISEswTlFNMjZLekg4RjRUSTFXM29BMUVw?=
 =?utf-8?B?aWlJVmUvZDl0Q1QzZG5VVnNrMUxRM3RKZFJRZGg1TytkVVltcmxtbGJtTW9K?=
 =?utf-8?B?cFkxNnRGeG9naGJoWHNBOU5CamlsUlAyOWdvN3huL0NYQUNSejZqOFZhZ1lJ?=
 =?utf-8?B?RG13dlQ3RitDVXNQandQeFpJZnZIVG5IZHpta21zMkxhWGswbVhMN2NzbHNO?=
 =?utf-8?B?aDFnczBweGt0azRqRytkaGU1R2FSR3dOYVUxeXVnRUtFbVY0OXk1VGhNT01H?=
 =?utf-8?B?c2FKSWp4ai9sZ3psMmRpYkh0WmJnWngyM1NXd1MwUkhzSEJ6L1M4WHJUZ1ln?=
 =?utf-8?B?alZ6Q3hRVU9YSnpqSHlxS0VDYXNVSE83T1lkQnV5WmJkVklaTU5Xc0hQUm9r?=
 =?utf-8?B?YUZCSDFEK3JVSDlhZGZGNGZqMVN6WjZXM2prc2V4TTlTYnByWS9lN2E0WUpV?=
 =?utf-8?B?dERuamI3eHJacTF3TWpqTDQwZHNMNWxZc1Z3M3lJTkc5OWNIaHM1VlR6cFJD?=
 =?utf-8?B?M3dWWWExcU4wZldxTzdQZzBkWWEzZzJ0U08wbVVoVlp4U0xMYWNlY1NzbTNn?=
 =?utf-8?B?VEhHcHNGMDB1Ui9lTjNDczFWV0VQZmRzQkVWdGRwV2daSWJPRlp3M0lQQTBJ?=
 =?utf-8?Q?qSKU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WVNrbkhjMEJxZ0tqSUJVdzY2Sk5hNzdnUGM1K3cvT0ZYRFJqazNmZ29OMkMv?=
 =?utf-8?B?ZlBRbCtHTzJYdTB2T3I1S1REakp1QjBqTkxpN0F2RzFoT2dxWlhIenhEWUFt?=
 =?utf-8?B?eklRdnNqZlJHY29wQURsclBiaDFGZzFTcHh4NVpNT2pNSWFOSGloUWRRN2dL?=
 =?utf-8?B?ZHdsbG15d3RhbkdWRlp3NThhMlhob0ZnbWFoMFpTMUFvdGFza3ZHOTVjNlpE?=
 =?utf-8?B?MGI5VGN2QUdVK1BpRkZuUmt5Snd4Q2ZFTkZFaU96VDllcE56Vjl6Q2cyRHVM?=
 =?utf-8?B?NTZ6Tld0L2FkZ29WdklCWU94eFpWWEJxREFHWkw0Rm9FbEMxb2wzaHJDVUJT?=
 =?utf-8?B?ZDUrbFRDVFh6L1MvK1pTeWgyTnZsek5VR2tkYUwvdk9VN2VFQjZXZGt2NTZN?=
 =?utf-8?B?R01FTWJRMWd0U0lYVE9GazB4V2JNeC9Xck5MblhOcVNCK0xNOTljdVF1MEhk?=
 =?utf-8?B?ckoxQ0NGMmZUY09LVnlNMWZnRUd3U2EzcElUdHBXOW5uUFlvYmVPZllUSWt3?=
 =?utf-8?B?ZXBmM0xrVHpIRW8zSDRRb1NTb0ZtdVVEdFh2NWxZR2Y3c08zdk9DYlpiZnZT?=
 =?utf-8?B?VTZ3S1FaOTY3TlVrODU0MEhialNuZDRJTW0wd0p2ekFqZ3BRVTN1TlZYS2pK?=
 =?utf-8?B?STJidkRic2xOVDJwWkFtYm9PM3JtVnJMeVpyakhoS3RnOWFUd1RwSmp3SVFC?=
 =?utf-8?B?akhPVFdhTFBzdnk4Q3BwczVjSEhoZk9nQkFKa1JnaDVVUHJvSmJwVDd2bnVr?=
 =?utf-8?B?N0k0bFh3VWdoQkgwVU5zV1ZMNklERGU4Nk8zN2RoVWVRT056Umh3THBtZHRO?=
 =?utf-8?B?WVlBTmpiVHJGaEhyOUpBZ2xBVWRzenJOUjRNU1Z5WDV2alAxRFJHcTI3c0kx?=
 =?utf-8?B?anZQWWJWcTNqblRleGkzbE5TTXBXUWZEUDEzbGhuUzdqcHltSE5Cb3M5OUlp?=
 =?utf-8?B?MTJRMnBYdkllalJ4cEtNTHc0QndFYnBKeXFqcXQxSnRWVjNVdFRqZjJtZzZj?=
 =?utf-8?B?Sk9OSCswdklrVGVSUURsK0dhSmlLYnlyVHVRaWRjaWRWejlpK0NtZkJVY28z?=
 =?utf-8?B?ZUhFSVlQZ05LTTFVcnZsRVFXSmNORmMzS1ZXa2QwL1ZBaUc0dkZ6Wlk0YUth?=
 =?utf-8?B?RVNYRDdIWFpYMk9TdVgzNWZjUFJWZUJkZE9JQWl5U2krdkxuMzhoOEZleXhM?=
 =?utf-8?B?dDArb3U0OFo2NG53NmlodmgxdXRLMHZBRnFSYlRnc0Fqa0tYczR5Z2RQT3cz?=
 =?utf-8?B?TE5ZZzV1VmVDZ1hxZUtSK2ZCcFA4VFQvdDRvbE9WQzBPMU1XcExCWlVPZnVD?=
 =?utf-8?B?WThGblc5cjVZc1NMMVNqWWQzRHVKazByTittL3Qxei9kcXprdVBHcUFhNnlB?=
 =?utf-8?B?eVZFa0ttYmFLamYvRnBiVzZGY1lseHJrVnc5Rkp6Tndrc2RjNnJ2VGxjbUxk?=
 =?utf-8?B?alZTQ0NJeTJmMk0zQlYyTS9ZdlR6ZVdkWUVJWC82VTNjRTVnZ2s4UGR4bitZ?=
 =?utf-8?B?MHJaaGUrZldIYmZ6UnZkcllCaUtiWUtKaEFXemFOazBzMzJuWDRzNFo0OTVr?=
 =?utf-8?B?eU5qSzNuSy9yU3JKdG5iaUN3RlVlNW1BTzFqeEhEZ3lYcGxldTQvc1V0NDFn?=
 =?utf-8?B?Q3NraDY0T241WkRseEU1TFhBVmdGMndqMGkySzVMWHRjWGt5cmlRbnR2KytU?=
 =?utf-8?B?aW00QnhzMTgvK0IvcU9Ka0JoRjA5WG43NWR1dUNTM0JOaHRQaGI5MlZHdXBI?=
 =?utf-8?B?RXhCY1hSWU1uMFFVNkxORkpiZHJ6SVVyeUZ5Nk0rUmtCVXdrbTRQTk92K3ZM?=
 =?utf-8?B?ZG9kSVJQS0JKZlc5ZHg0a3FrOWY5eE9QajZLcEI3VzlnMzczeHptNDRCdzVK?=
 =?utf-8?B?WjFWYzhtM015Uk80cnZvMG9oZERoL0pMOHlydVh6OGJBeEErN0tieFlBcTJG?=
 =?utf-8?B?RHp3ek5yMFpLS0pLVDdLcDFSQXJ6UzhwRUVKbHZ2QmZIMUI3c0Nsdit0TTIr?=
 =?utf-8?B?OVJNZEtDdlJIM0lVKzdrRy92K1lqWDdnWWlLTnBJUmtPbzE2ODd4dXVvWnJG?=
 =?utf-8?B?dUIzdWYwcUFkckszTGsxZ1YyMXB2V2p3MUdXVUhEeUU0Qmw1NkEwQ1RGUFVo?=
 =?utf-8?B?TUhVaVVMV0c2UU9YRVVJeFduUzhNVktSREkvSWhTTWdkclNmZHRPelUwOXNh?=
 =?utf-8?B?Q1dJWENHMUlDdWEySzlNc1UvSXZMRkp1czI0Y0NRd0pvSEN0RjdNaGtVTFdK?=
 =?utf-8?B?WVp3bmwrbGUyTkhoajlHbDBBTHI1ejIwSk5hcEFlTHVyUjc5Qy9pT2NXcXlq?=
 =?utf-8?Q?p+K2c+hrAn8ceoX+L4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5ada66b-a585-4da8-b253-08de57655cf2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 14:16:39.7222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JAw35kSZpu97sm6h9dKPyphN12oYa7LKmjm2KndiujRKD74I7EqVGtxMagH15dlShc+ts6vDfROcPZCkhA3v9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8334

On 1/15/26 22:11, Mario Limonciello (AMD) wrote:
> The hibernate resume sequence involves loading a resume kernel that is just
> used for loading the hibernate image before shifting back to the existing
> kernel.
> 
> During that hibernate resume sequence the resume kernel may have loaded
> the ccp driver.  If this happens the resume kernel will also have called
> PSP_CMD_TEE_RING_INIT but it will never have called
> PSP_CMD_TEE_RING_DESTROY.
> 
> This is problematic because the existing kernel needs to re-initialize the
> ring.  One could argue that the existing kernel should call destroy
> as part of restore() but there is no guarantee that the resume kernel did
> or didn't load the ccp driver.  There is also no callback opportunity for
> the resume kernel to destroy before handing back control to the existing
> kernel.
> 
> Similar problems could potentially exist with the use of kdump and
> crash handling. I actually reproduced this issue like this:
> 
> 1) rmmod ccp
> 2) hibernate the system
> 3) resume the system
> 4) modprobe ccp
> 
> The resume kernel will have loaded ccp but never destroyed and then when
> I try to modprobe it fails.
> 
> Because of these possible cases add a flow that checks the error code from
> the PSP_CMD_TEE_RING_INIT call and tries to call PSP_CMD_TEE_RING_DESTROY
> if it failed.  If this succeeds then call PSP_CMD_TEE_RING_INIT again.
> 
> Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
> Reported-by: Lars Francke <lars.francke@gmail.com>
> Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
> Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> v5:
>  * Add retry=true for the retry case (Shyam)
> v4:
>  * Add tag (Yijun)
>  * Move and rename PSP_TEE_STS_RING_BUSY (Ilpo)
> v3:
>  * Add a comment (Tom)
>  * Add a define for busy condition (Shyam)
>  * Rename label (Shyam)
>  * Upgrade message to info (Shyam)
>  * Use a helper that validates result for destroy command (Shyam)
> ---
>  drivers/crypto/ccp/tee-dev.c | 14 ++++++++++++++
>  include/linux/psp.h          |  1 +
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index ef1430f86ad62..92ffa412622a2 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -113,6 +113,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  {
>  	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
>  	struct tee_init_ring_cmd *cmd;
> +	bool retry = false;
>  	unsigned int reg;
>  	int ret;
>  
> @@ -135,6 +136,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  	/* Send command buffer details to Trusted OS by writing to
>  	 * CPU-PSP message registers
>  	 */
> +retry_init:
>  	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_INIT, cmd,
>  				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
>  	if (ret) {
> @@ -145,6 +147,18 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  	}
>  
>  	if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
> +		/*
> +		 * During the hibernate resume sequence driver may have gotten loaded
> +		 * but the ring not properly destroyed. If the ring doesn't work, try
> +		 * to destroy and re-init once.
> +		 */
> +		if (!retry && FIELD_GET(PSP_CMDRESP_STS, reg) == PSP_TEE_STS_RING_BUSY) {
> +			dev_info(tee->dev, "tee: ring init command failed with busy status, retrying\n");
> +			if (tee_send_destroy_cmd(tee)) {
> +				retry = true;
> +				goto retry_init;
> +			}
> +		}
>  		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
>  			FIELD_GET(PSP_CMDRESP_STS, reg));
>  		tee_free_ring(tee);
> diff --git a/include/linux/psp.h b/include/linux/psp.h
> index 92e60aeef21e1..b337dcce1e991 100644
> --- a/include/linux/psp.h
> +++ b/include/linux/psp.h
> @@ -18,6 +18,7 @@
>   * and should include an appropriate local definition in their source file.
>   */
>  #define PSP_CMDRESP_STS		GENMASK(15, 0)
> +#define  PSP_TEE_STS_RING_BUSY 0x0000000d  /* Ring already initialized */
>  #define PSP_CMDRESP_CMD		GENMASK(23, 16)
>  #define PSP_CMDRESP_RESERVED	GENMASK(29, 24)
>  #define PSP_CMDRESP_RECOVERY	BIT(30)

