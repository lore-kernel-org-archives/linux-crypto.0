Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012041.outbound.protection.outlook.com [52.101.43.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB8D538D92
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 13:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986317; cv=fail; b=ujItQK0UyevJfn6lrWfDzyr7mA69+oayBrDsNc5Yjdd94v9HDcpZNqBU9VxdoTmwT5++U6T4GCvA7zL/U/VO7D61wsTQmsll9ZQR89aVkif5MUDXZNxeMXL2mHZ5KLZrMxv+F8Y3wtjghuSq1uiBaR9PqxOZBnyzHz9IY2bHke0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986317; c=relaxed/simple;
	bh=sb4Erk5iFvbPpU1c8Ex/965COk2mzwCNbQm7o7JeY5M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uAwbBhuExyh17kQSiHcNYSnAb2j7JiIHTBxzxgSDfx9tXsSnm+77w0e4lNynUXEncX15N1YYLjSs7KdPpmU6NClQWXAE5JF//oYETdJTU5PLkc32KGh12xfMNFAKRuru5XncKs+SX2uxuFT4OCGpct/A4P7RX1M1aMS+hw6aPmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uVI4siNL; arc=fail smtp.client-ip=52.101.43.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uVI4siNL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ciDIgoV+iREj999i5ZjvJ+aoTB7B2lePZaPoj5UcIgUt6tj9G6io1eFkF+lZF0zrr7pkgPoQ/XHOIy5fJ+HwQt8NX6xWhvfLsRwTEa4uirfZqA/aW9bfC8bPovnx9FuMednpQmZR2Q9uNY/5/mWN28TRvGbWgIKDpMINWdDGgU6xbYKSHmLauNqg9hwoC0lqtVaLAxzDSEomjslR3tLc12NEuQdesIA6oI0+eHzqf+pKMg8ruS2X1II4EMS5MgTRIPmAckUedDnUQ2J9SIUVXrXCULVyGAAI+cOFL7bo1v3K1AjBUqJZj2wnYyirsO6J6khchw5WD8OCJScw3KEPqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JST0HWbTphRyWjbK/cUeWiELhxXdPyv5/HZ9+XdamxQ=;
 b=HdOqSItYBdUiLUSugIZVuxBLoh9AEFHroBsaEBzq9+QA/2njZBLzk2EnYZTTznY/NttiZmHbxY7tAyoAH1uUt0KerRHfy2pflVZvSME/bSpeeXEIeLS9CNCJHqEjcUKQOzAaEfmUfB3uAoERx6zC01GHjT6bID8Ptii/WZJEfxPA/TT0UBeY+gnwtPKo8c3uu4WvCjmWGndTN4oZ23Hsy5FifKl7jyEC9hIWkVfCYnZauwwq5aVUEZs1msLHlIpC2ttujuVktrgXjXnZZGJeljfPXXUbI5sHP1iyTYIVfN+qcygvPNvzC4xg9eKuc2wxm+i35C2LRvXA9L+uBZp5dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JST0HWbTphRyWjbK/cUeWiELhxXdPyv5/HZ9+XdamxQ=;
 b=uVI4siNLsMulvtcl0sCh1moRCaV0bWTJff2pHIyHyZb5nKJL5oo61dCojTC+SqmjyuEwx8E9Yb0R2yOk2w+58hmEY0Sofwr9XaEpapuRbG3w0zSeAO47H3SXFH30vBh2RZ/sbzTG5RC25ZxetTpfCYdqzdAHTnvcUEOOjHLTLnE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by PH7PR12MB5620.namprd12.prod.outlook.com (2603:10b6:510:137::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 13:58:26 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0496.021; Wed, 14 Oct 2026
 13:58:25 +0000
Message-ID: <26b55a53-7d19-4ea3-9a56-a34d71b2b4ee@amd.com>
Date: Wed, 14 Oct 2026 08:58:23 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] crypto: ccp - Make usage of sev_cmd_mutex more
 granular
To: Michael Roth <michael.roth@amd.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, ackerleytng@google.com,
 ashish.kalra@amd.com, aik@amd.com, seanjc@google.com
References: <20261014132145.1726322-1-michael.roth@amd.com>
 <20261014132145.1726322-4-michael.roth@amd.com>
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
In-Reply-To: <20261014132145.1726322-4-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR06CA0077.namprd06.prod.outlook.com
 (2603:10b6:5:336::10) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|PH7PR12MB5620:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fa0f9b5-097e-4789-e298-08df29fb377a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|11063799006|261009223027099003|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JtKiysszvs5QsjSDGYLYyn3jsReLcH8n9fE7CWI6lMKIozfbufsWRN222MB0RL9nRGaznRi4c+DzZLZuGE2daIXl8xFSZGXEILSCioQyfXjvYw16G9QaWLxcFDyTIouKVQOnwcMZ29AyRWPFI3ZoiD4DMCjeaQPMhk3+PxZ1jBVyU8yOROlQovkGFpUGHW06TctqNzYj531Tcn0mXFqYoNBrUL4ISHjn3axNIgBfoyyY6g0BmAZJr8CXAgFVn1mq3OUObAEBhdkrx5p6wA+4dHVjNk6W7GOcHw2Df2kevpPAohs+JNpyWQY6AZou1UaaX3LKURy9SHhNp6mhsupX6Hq2cjEgJcvz8POaaTREbcgtRjAFW+3sGoBAbyj1nLKu2JTTcyEMdpM1XyEa8JSN+Exopr7EP8VMfl5oE/dRresvTjhML5iKA4tLGwdFgygl/GvETQDNX/GQ9XJ33DLRfGwwcpBJeEFfg4HHHSC9y5Pm2MhT+GL9lQVbNP4Wy1deOCwZ1DFEqVOJkOXYDCRlvaLPgFhJwJvonViDzIMSfrOCWE1my7/sjcpe66u65uTBDJ8ZUe5A7JNdZrTCcmm+KJGvFRGKZG4nU+RuMEuurO+4Wp3JccPnpQLPVvkSxkgkSkFI61HG3cx9B+p+MtvrIPvT9Pozc3rjAJV9+2JMHn0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(11063799006)(261009223027099003)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eW5nekhlTmpCaTBlUWk4N3NrNjltSzZXV3h4Uk1LSTlWRFh2UDZBU01YSlpk?=
 =?utf-8?B?QW5jeGRyc3hQOUYzNlV0VXdqcVpTNy8yVlVwRnErZkpHcjlnLy9yVWk4Wmlw?=
 =?utf-8?B?d0VpNm5ZUXhwZ3FUcmZHWXkzK1dsclRjTk14c3VtUDNYVjZnVmV0bXZGL0lV?=
 =?utf-8?B?Q25vbHJhTzNqQkJiNVJQRWhtRnJkWXdCS2ovZFY3Zk1LTS9JSEZVOFdnbWFR?=
 =?utf-8?B?UDVtNTRmRkh4akpqS2NMQ0ZWcXpEWmlmbjVNTjJSWkFzWCtNSktQMFR3Z095?=
 =?utf-8?B?NFh6UjJmZ3lISnRDblY0S1pLZjZFS1crZGJzZGdkU1NrSlJucDVmT2c1MEJz?=
 =?utf-8?B?UEVVcVE2Y2lrSGhOWWlRdzFtM043bEErTXM5WWFyMmRNZ05aTGFhZkh6VXB1?=
 =?utf-8?B?ZnZPcHdvWC9wOGU3RFZxVHB5eWpSbzI2ejZEclpaTG1Ub00xYy9qK2hIVSsy?=
 =?utf-8?B?K2pmVklhaFk5ZnZTYW5iaSt0b3UycTh0MTVOb3liNEk2N20yUVZ0TG9zVmlj?=
 =?utf-8?B?S0ZRRnZ6ZjQyQUp2akt3c1hqT21NMHVqRzZtNmpiZEpmT0pSMG0ybXArWVQy?=
 =?utf-8?B?YkNQcDRqM2Fsd3Fvek5GWlVyckVBeTNRemNpUk5OY0x6UzdsUnBzWnlYMHZ4?=
 =?utf-8?B?WnRZVG5QZDJucmVqVHFSSFluV2pTVGd3ZTA2UU40Q2J2Z2ZIVU4rTnRkMGlY?=
 =?utf-8?B?SWpxUFhUYnNOemE1UGpRbk1SWGVRdGlBQzc3cm16bG1yR2FWK2JHYkkwUmVW?=
 =?utf-8?B?Ly94dHlDZWhRbXgyODhpeFdKeWtHQ3hieHF5eHRyR2g2bkJxL3FlQUxhVkda?=
 =?utf-8?B?NnJ1VDd2Z0t1cHZwTm4yOGw4d3BXL1ovOTlwekdWSkszTFQrNjRGc0w1RlMz?=
 =?utf-8?B?QXNFOWI2Y242cWJMdW5yVnBOaXVQMVZ1N3JOOFFSc056VEVqN0JtTFBYWlZJ?=
 =?utf-8?B?QkZmU1prMnI5SHhYMGkzek9BaFRIanRKZ1ZhZmxzWUVqdUNCMGxESm8xMzJq?=
 =?utf-8?B?YjhmUk5SeExLRUxYYnRPZEVjaUVOVVJxK0VRdWgzOWZPNDJYTzIxOGNYMzc5?=
 =?utf-8?B?TitTL2NHL3QxY0w3UjNPb1ZVTHBad3Ywak5UM3VNc1RIMDlkQXVQaFlmL0dF?=
 =?utf-8?B?R05HblYzN3RDMzVKM3dRUHBBRCtHc0wvckNadk5vaGZnVWc4Sks5MWZGdTF1?=
 =?utf-8?B?Q0xEcFJpanN1ZllheUlqbUNXSlBEQkNHaG1rNVNYUGMxMjZkRWlJSnVvaDRj?=
 =?utf-8?B?blp4ZVorMkRMWTQwTGF2UWNublFVL0hVbXpWM1RxREJiWFFqaGpCcXljeEVB?=
 =?utf-8?B?TVZNQWozNkYxOWlidnR4KzgvRWdKTms5VkNDSjh5Y0FYOUlFUVN2UXBmN0pK?=
 =?utf-8?B?b1ZxVlhYVFFWL3lJWXhMdFBlTXVIcXBZQ3hRYUdrdENrUFdvekNJdmV6UXMy?=
 =?utf-8?B?MTNrR2pTTmtTc0F6QkJNcDhqRktoTHBwRE5XN3dxYlVPSEdiWkViY0NiWGJS?=
 =?utf-8?B?dWM5M0hZOC9JSWgyejducXdueUdRLzJwMnlJYnNNUkx5b2RJZFZia09PWHhs?=
 =?utf-8?B?MkVXQWhBY24xVGF2bHpjUVV4NnhXaWZ2dEVrait3czBDdHBYdUVPOWhyNS84?=
 =?utf-8?B?cklrbzRyRUVibUNNeDdOdkJObUJlRVVsRTU0b0orMGIwMmVxUVltSTZUY3Ro?=
 =?utf-8?B?VUk3UWdLWlVnWGNzb0lDTldDVnNWM09lZysxTjRlS1EyZTVkZ3hYcXRDUXBI?=
 =?utf-8?B?bmluT3RNY1pVZUUyeFhJOHF2elJ4SHR5bVNPYkpmU0k4RVhPcmxvUkU0TVFE?=
 =?utf-8?B?WHVIRlZxNGdYYTdhRVd2aXFYZWpSaUhBNDVVMS9zL04vaDRVTmpYWkQyUGdF?=
 =?utf-8?B?QkpEV0NTMHJha0VTbUFVei9vbnRUaEFscHB4WTJBb3hXa2JmRmZ1VTlIeEhH?=
 =?utf-8?B?QnZqb2ZqajZwbEJnRnBqaGtYTFlEZENleDRqNE05bHF6T1NsTDlQL201L3Y1?=
 =?utf-8?B?UmtGeFRFRjR0SldMM3E1QURwQktNNFJJK2FlY1ZEUUY0dHBVL2NKWFgrWEpG?=
 =?utf-8?B?S1kvM2grKzV0N0RUSE5YSHE3TGdrQU0zNmQ0SXJ4NWZENVNFbSttaE1SUktK?=
 =?utf-8?B?VEMxeFdlakNiSWo1ZFQ3TGxBRFlpekp0VVBHYUJoRVIzbkxEMjEwQVliYlky?=
 =?utf-8?B?RmEwanE5cCtXeHExTEZFaXVHMmRmekc0T1JFa3MzbHNHbWF3cEY1Rnp0Zyty?=
 =?utf-8?B?Y041QlQ4NXhraTBPRmZZRVVPczlCT2wvbXFuR1RSQ2lTd0tvT1FITGlzWkZI?=
 =?utf-8?Q?r7DBRWbNxCVDGSkrk3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa0f9b5-097e-4789-e298-08df29fb377a
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:58:25.5714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ybdoY/S8yQU0v6y9LLZ5Vf6EJrtNhnuWCI9qK31idLjaXnX2rwE/4X1avXRwM25mu8MnItYRgvoEP7HWotyhSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5620

On 10/14/26 08:20, Michael Roth wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> The current code makes very coarse usage of the sev_cmd_mutex; for SEV
> firmware ioctls, it is essentially taking upon entry, and ends up
> wrapping a lot of potentially time-consuming prep work that may need to
> be done before issuing the actual firmware call, which is the main thing
> the mutex is meant to protect.
> 
> Additionally, some of that prep work involves
> copy_from_user()/copy_to_user() calls which can generate page faults and
> unecessarily lead to potential deadlock scenarios. No known case exists
> in current upstream, but with the upcoming KVM/guest_memfd support for
> in-place conversion of the same PFN between shared/private state, a
> special fault handler is needed that could theoretically deadlock if a
> malicious user tries to use guest_memfd pages as the source/target of
> target of said copy_from_user()/copy_to_user() scenarios.
> 
> There's no reason to hold the mutex across these problematic scenarios
> however. Push sev_cmd_mutex down from the top-level sev_ioctl() into
> each individual command handler, acquiring the mutex only around the
> platform state transitions and firmware command execution.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> [mdr: rework commit message]
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 98 ++++++++++++++++++++----------------
>  1 file changed, 54 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index e42cf3aee50a..c8c229a6757c 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1914,6 +1914,8 @@ static int sev_ioctl_do_reset(struct sev_issue_cmd *argp, bool writable)
>  	if (!writable)
>  		return -EPERM;
>  
> +	guard(mutex)(&sev_cmd_mutex);
> +
>  	/*
>  	 * The SEV spec requires that FACTORY_RESET must be issued in
>  	 * UNINIT state. Before we go further lets check if any guest is
> @@ -1946,7 +1948,7 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>  
>  	memset(&data, 0, sizeof(data));
>  
> -	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &data, &argp->error);
> +	ret = sev_do_cmd(SEV_CMD_PLATFORM_STATUS, &data, &argp->error);
>  	if (ret)
>  		return ret;
>  
> @@ -1965,6 +1967,8 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
>  	if (!writable)
>  		return -EPERM;
>  
> +	guard(mutex)(&sev_cmd_mutex);
> +
>  	if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
>  		rc = sev_move_to_init_state(argp, &shutdown_required);
>  		if (rc)
> @@ -2014,16 +2018,18 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  	data.len = input.length;
>  
>  cmd:
> -	if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
> -		ret = sev_move_to_init_state(argp, &shutdown_required);
> -		if (ret)
> -			goto e_free_blob;
> -	}
> +	scoped_guard(mutex, &sev_cmd_mutex) {
> +		if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
> +			ret = sev_move_to_init_state(argp, &shutdown_required);
> +			if (ret)
> +				goto e_free_blob;
> +		}
>  
> -	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
> +		ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
>  
> -	if (shutdown_required)
> -		__sev_firmware_shutdown(sev, false);
> +		if (shutdown_required)
> +			__sev_firmware_shutdown(sev, false);
> +	}
>  
>  	/*
>  	 * Firmware will returns the length of the CSR blob (either the minimum
> @@ -2317,18 +2323,20 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>  	data.oca_cert_address = __psp_pa(oca_blob);
>  	data.oca_cert_len = input.oca_cert_len;
>  
> -	/* If platform is not in INIT state then transition it to INIT */
> -	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
> -		ret = sev_move_to_init_state(argp, &shutdown_required);
> -		if (ret)
> -			goto e_free_oca;
> -	}
> +	scoped_guard(mutex, &sev_cmd_mutex) {
> +		/* If platform is not in INIT state then transition it to INIT */
> +		if (sev->sev_plat_status.state != SEV_STATE_INIT) {
> +			ret = sev_move_to_init_state(argp, &shutdown_required);
> +			if (ret)
> +				goto e_free_oca;
> +		}
>  
> -	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
> +		ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
>  
>  e_free_oca:
> -	if (shutdown_required)
> -		__sev_firmware_shutdown(sev, false);
> +		if (shutdown_required)
> +			__sev_firmware_shutdown(sev, false);
> +	}
>  
>  	kfree(oca_blob);
>  e_free_pek:
> @@ -2372,7 +2380,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
>  		data.len = 0;
>  	}
>  
> -	ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, &data, &argp->error);
> +	ret = sev_do_cmd(SEV_CMD_GET_ID, &data, &argp->error);
>  
>  	/*
>  	 * Firmware will return the length of the ID value (either the minimum
> @@ -2430,7 +2438,7 @@ static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
>  	data->address = __psp_pa(id_blob);
>  	data->len = user_size;
>  
> -	ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, data, &argp->error);
> +	ret = sev_do_cmd(SEV_CMD_GET_ID, data, &argp->error);
>  	if (!ret) {
>  		if (copy_to_user((void __user *)argp->data, id_blob, data->len))
>  			ret = -EFAULT;
> @@ -2492,21 +2500,23 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	data.cert_chain_len = input.cert_chain_len;
>  
>  cmd:
> -	/* If platform is not in INIT state then transition it to INIT. */
> -	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
> -		if (!writable) {
> -			ret = -EPERM;
> -			goto e_free_cert;
> +	scoped_guard(mutex, &sev_cmd_mutex) {
> +		/* If platform is not in INIT state then transition it to INIT. */
> +		if (sev->sev_plat_status.state != SEV_STATE_INIT) {
> +			if (!writable) {
> +				ret = -EPERM;
> +				goto e_free_cert;
> +			}
> +			ret = sev_move_to_init_state(argp, &shutdown_required);
> +			if (ret)
> +				goto e_free_cert;
>  		}
> -		ret = sev_move_to_init_state(argp, &shutdown_required);
> -		if (ret)
> -			goto e_free_cert;
> -	}
>  
> -	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
> +		ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
>  
> -	if (shutdown_required)
> -		__sev_firmware_shutdown(sev, false);
> +		if (shutdown_required)
> +			__sev_firmware_shutdown(sev, false);
> +	}
>  
>  	/*
>  	 * Firmware will return the length of the blobs (either the minimum
> @@ -2605,7 +2615,8 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>  	if (!argp->data)
>  		return -EINVAL;
>  
> -	ret = __sev_do_snp_platform_status(&status, &argp->error);
> +	scoped_guard(mutex, &sev_cmd_mutex)
> +		ret = __sev_do_snp_platform_status(&status, &argp->error);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -2623,7 +2634,7 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
>  
>  	buf.len = sizeof(buf);
>  
> -	ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
> +	ret = sev_do_cmd(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
>  
>  	return ret;
>  }
> @@ -2642,6 +2653,8 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
>  	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
>  		return -EFAULT;
>  
> +	guard(mutex)(&sev_cmd_mutex);
> +
>  	if (!sev->snp_initialized)
>  		return -ENODEV;
>  
> @@ -2674,10 +2687,12 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>  
>  	input.vlek_wrapped_address = __psp_pa(blob);
>  
> -	if (!sev->snp_initialized)
> -		ret = -ENODEV;
> -	else
> -		ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
> +	scoped_guard(mutex, &sev_cmd_mutex) {
> +		if (!sev->snp_initialized)
> +			ret = -ENODEV;
> +		else
> +			ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
> +	}
>  
>  	kfree(blob);
>  
> @@ -2703,8 +2718,6 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  	if (input.cmd > SEV_MAX)
>  		return -EINVAL;
>  
> -	mutex_lock(&sev_cmd_mutex);
> -
>  	switch (input.cmd) {
>  
>  	case SEV_FACTORY_RESET:
> @@ -2748,14 +2761,11 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  		ret = sev_ioctl_do_snp_vlek_load(&input, writable);
>  		break;
>  	default:
> -		ret = -EINVAL;
> -		goto out;
> +		return -EINVAL;
>  	}
>  
>  	if (copy_to_user(argp, &input, sizeof(struct sev_issue_cmd)))
>  		ret = -EFAULT;
> -out:
> -	mutex_unlock(&sev_cmd_mutex);
>  
>  	return ret;
>  }

