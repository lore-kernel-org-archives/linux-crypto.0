Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011043.outbound.protection.outlook.com [40.107.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D61328469B;
	Mon,  2 Mar 2026 15:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772464646; cv=fail; b=BugnXvsNkXV2s6HLwnRqu2iWP6mPtDIc6O7yHVCUpov6N9a0gJlbquJEf0Yh/6eIvZG52Vu4TSCor1cPNB+l18WJvTfkotjRmSujT69FCKpGvNITlaD2xbNGoStLrWciqS0HBwPoxZ8MukhrbqXPjpCkNY2aVJ/RpCk0FDiUHKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772464646; c=relaxed/simple;
	bh=rEsKevQPHCKsJ2nXU4HXMf0PvXu9eSx+ZnsfTcsXgos=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=di50s7Mwx1sXJ8Nn9mUX81lccQfnkq7DPEUo1V47SKG5XK11u5wsTtCVieutoQvh0QOIY55pUnwWn74UV6VqKZpVAtaxs5Melteka+A4DODU4b87Osjoia2BEJeTT1dqHp6A1wzRmYapEqGNaXasee1unvkUT6QXg7p2ONzIVcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KuJaGAs5; arc=fail smtp.client-ip=40.107.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KuJaGAs5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QYOy8G4WEcBG+7pLsu5gXrz/k56KkwQgLAp1dCueqqrTjWY303+p76ehHsdexlVcIwG8E2uOn3Y+lIkarXqqqRErkI064ifoAYXDq0jYoHWnB3MOjFwGlgHbyak2fxhzCboFWq0aLs+nfhdY9HUEbQXRIWFLCZ+FZFMS77FKbnWGsSXzFW1oSw1oFJGXpnrhLEJ8oTItPchcCMUMFq2bNiwwPiYO+bWLt8yakatrfhaxsGXR7kUjBWb47IPSbniRDmJrtVs0BcCh5AZHCmFYrqH6J7kyfH27HE5gg8dPY/MSnP1u4QFxDBXdxdLLfFdKr/F+Tid94jp0754ZkmVKPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0v6L26q6T7VlynhQw4Em60/mOl6mj4svOsXkpzLcEiQ=;
 b=pX9pzW1qO5WehrYRut2QECugRbLDWyRxlm0q+69SoYvDQggbm2fJyYxb4weA0zKrX384LfJXWr68m1JC1xlwt6iVFq9EqzUpegkFm6ehP3fL7KsChW1iNLr04c+1fEzs+bogTODrlO9U8WnDDsgqxKVYxbB78PRGbFSN4PnkE35fP1NrojPJjMYPE1s/4ztZJLaKvNomuIcLZNGK5ndUjTea7JD/zE6tc+CzHyB7T3n7dmqrWXZH1ATWu2KGFuh/teZ/3c4cpzLfKfM3tUycSuoa2sronuubaHJK67K6FO+qDw3ZwJ2Owlxf1d3DW10sx26DLBb2SUlDX/lsBbm+9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0v6L26q6T7VlynhQw4Em60/mOl6mj4svOsXkpzLcEiQ=;
 b=KuJaGAs5PC3zbxh4zwoBq/zcQX39ryOKy4W9WvtXX+MEi2gTJfsDNFljgH0WFT2tsxDzEs0f1/+RJqF+DWcUCzESD5ryUa40xC65miHAoA4nehimJfMCfTBKEs+JImgoLVS67ST7C+r3PtzpoAGjSbxakK6rC/Il4nz4ounE8/M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY5PR12MB6408.namprd12.prod.outlook.com (2603:10b6:930:3b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 15:17:21 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 15:17:21 +0000
Message-ID: <12950d00-8b67-43f7-b1ca-457855d96c01@amd.com>
Date: Mon, 2 Mar 2026 09:17:19 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] include/psp-sev.h: fix structure member in comment
To: Tycho Andersen <tycho@kernel.org>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260302150224.786118-1-tycho@kernel.org>
 <20260302150224.786118-2-tycho@kernel.org>
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
In-Reply-To: <20260302150224.786118-2-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:806:130::28) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY5PR12MB6408:EE_
X-MS-Office365-Filtering-Correlation-Id: af492830-0e16-4887-74e6-08de786eccc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	36q8ftvtaHY5vYEji+bCodraA539+O5BnjaGmM5GHs2Fxck9MeFlgYZykwYnd0zBEF5zUx1Nu+gqNs8NDu8c7MyIRgfqLm2pvyL7LnQ0icretQZJk5o/xZzFmipmpi5q5rmcVmbGsxkB5LCQdnIGr+KSNu2AyuADN3fICTOAtweXJ5izHUIOapGaPLsQXEoA/HhYCMsTFHB/vQ4s3qVJ3n61V4h1yE6clFkx22GttnTclsyIdq2bjtQWhaLNDtT3pjB4acCLYOVt5L5NQE8hvzO9o7Qor7sLD8OoraSycZb6NsU4O/EpFdr40Ikhi2WoJrzHyApvxbbPNFXNT018cR47B3u4kMAPFLh9VLQcM3mId22QyAhdLbz/oocGazVDICEk6M8PQ+N6XCpnkckN5OxYXthe0u7qgx/4xsCNmLhhO1GYGxl74JyJIiQ7pokz8Ss9zGg8NWAHmZ7tXi643DubPvOh3HLY5d+apiq/W+WxodZp6dYvSeH7Ro6iSW4HAfAD9wjPDl77ejqcSoeajVBQLqGhjX40fS+BLpGDMN6D25sFCtB44Mjk2THV3o/gnL8Q94FglJaNWX/Cn8iTdi4QKTMm47MZkj15D59MyDL/gYQsvkh19Z7gSJ+XQ+I29lpyJBHGeOt3UUMx0GruO9l/3n5Siq+avmskqXSsmJFUgY24jZHwCK6buuunDraBUPu7YGZjsObGntTgzOm+ICabPTVqT4F3DsfwyZITnTc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1VGUjRaVFFNWSt2OXYzQ0hSalJOdzZ5SFlVSzhmdExyWUExc3BVMHhNSllh?=
 =?utf-8?B?a3VvcGFSc1B4bitGeXJrUCs1RGl3aVROUks0a0ljU3FWUEhqU1lRcmZSWU00?=
 =?utf-8?B?OFNqRWl4QjUyaU4yYVlEN2M4OXNFdElXcVVON3plMkpJbXdQRExobE5hdCtp?=
 =?utf-8?B?c3BEVEhpbS9qRms4bU8yL2FDMzllQk5GUjl4VUNaTDlWZ000S2JyeDl6Vk5u?=
 =?utf-8?B?OUQzYUFqUVpYbWQyRzN6UEtxYVhIUlVhMkFBZFJ6R0JLZUhKalZCNmE1SGVW?=
 =?utf-8?B?b3FmVC9vSnIybE5oUzgyclVOTGRiVWdMZ2E2Rm0rMVBxVVczU3dXSWx6enhF?=
 =?utf-8?B?V3p0ODNpRzFuM1pSdFkyK3orUkdCQXp0disydGdsUlZwQ3JENXMzZ3VmUXE3?=
 =?utf-8?B?UnBDK3pvZXpaeTh4Sm9IWUQxbGg5Z3VEcjVGVEJFTFZDazhvRTJLL2ZnaWtC?=
 =?utf-8?B?Mklrbk9CMUZCUHhvczNobDhFNnJjdUFOTDJKaGN5YXFvM3ZmUndQTnVCSTlE?=
 =?utf-8?B?VEN3ZlVMRU1xWjNCd2dLN3ZLN05vOVh4VXhwNTE4WGJwVlNDZUVEQU4yZ2R3?=
 =?utf-8?B?TjRRQ2IvbTQrTHZWUlNWaERad05tK3Npbm44ZE1xeklhdjY4Z1FCOXYwbS9q?=
 =?utf-8?B?bDZCS3ZRR0ZyQlU4cGkwR0NoTGdCSkVuLzZVdTdYRGhyTlBpcXdRSDRqVHhV?=
 =?utf-8?B?dkZzMEthVXdwVXZDKzk0MkpsOHdpSmM1Y1VsN0x2dEdPU0pYZ1NCMS9Nc2Z2?=
 =?utf-8?B?T2RUNkJJTXJTUmdYc2UwTW5BRFJWbFY3MGZzOXJvSkg3NnVFZ0JZcmFiMzVa?=
 =?utf-8?B?bnhkRXFvN0JjZFFRMm9haFZLcWhwU3AyTGNsTGkyNUVFY2VSWDJwMk1XU2Ew?=
 =?utf-8?B?amZYdE5oMG8xVldHOFlFU1dSUTFrdmJQOTlJeU1rK3JqOThxTjIzVU95ZWlW?=
 =?utf-8?B?dm5Bb3VDZ1RlOHc3dTVoNit6RmRoWmkwMVlGWVN3ekpPa0wyZHlOQ1VVa3RX?=
 =?utf-8?B?ZFg0NUk3VmRBRkFqajlXcDczdjVjeGZ5eHRaUVBnVGpBeGtJbEdCVlNUdmJa?=
 =?utf-8?B?bEJyd0FVMThDUVdPMXh1VktWT0JTZFB3ZEFUYXpxaTJqMk5CaEtodFRNczBV?=
 =?utf-8?B?VjV6NGVoRnYvem80VWN2bGZJaUJqajcrTURGcWhWQ1RzbUZORjZVMmxFTWJw?=
 =?utf-8?B?cUcvY1diUFRmR0tXZ2RQQnlJbjhGaVJRUldNaUJkT0srL0I2VkdJd3cwYURR?=
 =?utf-8?B?ZlJtc1ZWSEpDeVV1LytwVXV5MzdXay9FYk5OL2FFRHNYR2NvK2NueCtGSW84?=
 =?utf-8?B?UGpuM0FpeG9rQkZtK1hvVXJqNGNHNWsrbzRDTHdVVTdUOXpRYWd4S0pNYXcv?=
 =?utf-8?B?UGppbEU5SDMxUWNPamVpNy9hdzNvZ3dXa0JtNy9MelZIaG1OOXMxdmIzMzNF?=
 =?utf-8?B?NlN6WlVDZFdLLysyRTRwWlMyL2h4czFUMUU0UXIzb2cwTkwyOEZXaXhDMUNI?=
 =?utf-8?B?bWR0c3gwTXp2RkpCZXlSemwwcjY1YkJIT2k5NWZiZmtuK2x6TDdobWZxM0Ji?=
 =?utf-8?B?em1LMDBEaThOVENxQzVIaTByRHlHamMzTnlyMGpOeEg4dWt3c01rdnNXaTJP?=
 =?utf-8?B?cmpKWFVYQmpFRm1PTVJDZDhXZmdBcFRSZUQ3TU5XeG9mdDVGdGw0S0c0QnFU?=
 =?utf-8?B?MnZIK0pQZzhMS2ZpZmV4L0x2TGZNTDAwSG9pNHpYYldZY1ErT3E2RXN2cnAx?=
 =?utf-8?B?WnpsM015K1VaOTZaaDJhS1FGMm9KVzFLSTVmNWNxRjBycWZWbFBYZUd2bGww?=
 =?utf-8?B?R1RxclpNaVNSMEhZdml0MkpzUTNyVGdKbEtCd0k5cVFTdzU2WFR0bUhvaUFv?=
 =?utf-8?B?RUc5b1lEdlRtZ2F0dlN4dktQVlI2Y1R0Rnh4YklncUVTUEROejc2cnpoWFZF?=
 =?utf-8?B?YlpRZk9MQmo5MFd3OHU2bTlzVkFCaU44RENhWlBnRTZnMXpXdnNGcDkreUY0?=
 =?utf-8?B?VWQyZmNjZkplbDN5MUNaNXFQWG9ZWnp4cXhMVHZyaTY4QTJXMlQrS0VpWGo1?=
 =?utf-8?B?Zm9XeGVYWXlSNktKQzZYRERXUndXa1NEVVZpRGx5ZE1wbzBwd21xN3BYNGtw?=
 =?utf-8?B?TitYeUxwbXVNWTk2czBKRGJqaElXN0tkTmg5RDVNYWljcDZrZjdTbldXenMw?=
 =?utf-8?B?U2haSHA5Zzk5WHBIUHptTFozT3lBeUpaOEVwQStwYTRQcWJqQm5lNFpQRTl6?=
 =?utf-8?B?eWUyLzJOcUtMN3poRlJQMUkxVWJzMU5ybWFWS3kwTW56UmVvQURPdGZGdlFV?=
 =?utf-8?Q?+WDhcu0CZd/nbHF3ra?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af492830-0e16-4887-74e6-08de786eccc0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 15:17:21.1530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pM7wVC11o5OnmSKwGpqJ9p/Y5+ifrVR3DexUQ8Q9NX6xcTyeqrX1x7EfuQiIdfh7b11AzQLDW4aBsi6cBBw04w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6408

On 3/2/26 09:02, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> The member is 'data', not 'opaque'.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  include/uapi/linux/psp-sev.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index 2b5b042eb73b..52dae70b058b 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -277,7 +277,7 @@ struct sev_user_data_snp_wrapped_vlek_hashstick {
>   * struct sev_issue_cmd - SEV ioctl parameters
>   *
>   * @cmd: SEV commands to execute
> - * @opaque: pointer to the command structure
> + * @data: pointer to the command structure
>   * @error: SEV FW return code on failure
>   */
>  struct sev_issue_cmd {

