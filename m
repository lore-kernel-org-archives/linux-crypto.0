Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010068.outbound.protection.outlook.com [52.101.61.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0E15012B7;
	Wed, 14 Oct 2026 13:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984084; cv=fail; b=E57qWrZf2rl5xzucVEKD+0epaNBexr5IHw4LI/P1LkzkQqzmT6m54tpHrJIPfpENqZSInJND/fPdTeS+MFQL5VTSfIucgr4pAciACU8+vUvC9o4nPA4EV3Ppc7l7gL8oeiW//hp/c3Q0BFnEh67fFajpN/rFyseOwzQgWEl+0gk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984084; c=relaxed/simple;
	bh=HzGKqNjIqNLLjHG60Bzh7kvTX3kgVJxh8lAMbp3C0TA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UBBeaepWD1Pp1KWTXTVj6nL/LFGlcFLvQ+Syg+vnl5OJqQnKssFbie5eXIpDgeysru6qd+TRmyr03GJnSiECAWFDJwHnQXqCX6cDBpuxbhYeYiIZSI09/VFz3PrKS81wASLxQzYrJez/fPCNQZwgaGxGEVvUx50yOkkSD1tPMx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JwotqQk1; arc=fail smtp.client-ip=52.101.61.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JwotqQk1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pb1kG0ULYyfcCtK9nEdkYcDM27246GLYhR/IcJNcCmlVcB4Dz9Mc7bIU8F87FELo7hSjh2B95ebavLIOuaoClY7ojjxgmXXgc+vYSUbQnjeU3W3YoHFZfzjs7yFVR9/6EPmXG6dseNB5bIhdEtBVkHdOcB97Z8Uz8kHc3KpKpLUnRAI6Ybd7xF1KKcBmmYg7a6qqNfS1Rkg6plNgAYiN6PYQzU+g2QQVk5ERCzZHOlFyAIU/zBGQsS+TwUHq6obR2ZGu5zldp9KStpj5RHUUsz6hKhk+2TfmAV5Z7ZpZQsawIIUKMIQPmF6gtOk8tEcPpvpwxvuY6CFZxINBs9ceJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/+JYZDjTDWi8ZlEsbZGbQB5QPGTXV+U1DzJEZsVuJI=;
 b=XJBA23eYp1L+KHA77WL65rsb+x1ZLEyGu3BQO24EptuX5Vj5NkU7ChjWVVWxCYqRUUfJXBAUs7FEIqOtkm/3fXosfP4uWCTvYkHpgHLif9w/jA/8kcoJ4+UABiyTmgNaxOiRCzc/mSPsrrC7x9Q8ZY0Rkye0GVvj1lTjSCSFYh0oIWzSQpOGMDgR+aobGvbjLI3h3B0Szaf6e2t8oLxJL8dSeLf9Mhpo7fq1LGDoqXe2inMQQ+dZ/nVKjAkMFAqqlc4cd8+Rf0iuzQ61eJBxwRvwT/eKRimWqvXRoSZEsk57ZxWkQj8JPH74XudD/Kz90c6TCwVNJIGYmo9tnJvKdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/+JYZDjTDWi8ZlEsbZGbQB5QPGTXV+U1DzJEZsVuJI=;
 b=JwotqQk1ofutbDwYjMnMkkifGNFygH16UIaVy7wizmif4SlNyFC3lP+pygNpOp8wW8cOpvnQEGc58AN32/Sn7koWkcdfh5a0Z2gFxgkoFj8ISH0UFpJ8KfuLE//Rkqd8QLkLPYkOOsOU6+8mrhxqGnXDVDRFaXYUTMo0OAfb+IA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 13:21:11 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0496.021; Wed, 14 Oct 2026
 13:21:10 +0000
Message-ID: <54671419-f2de-404b-bc91-00cc6cb2db6c@amd.com>
Date: Wed, 14 Oct 2026 08:21:06 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/sev: Clear RMPOPT when segmented RMP is disabled
 by firmware
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1791905953.git.ashish.kalra@amd.com>
 <24ec806222fb8cda660269d3360780687403d150.1791905953.git.ashish.kalra@amd.com>
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
In-Reply-To: <24ec806222fb8cda660269d3360780687403d150.1791905953.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0281.namprd03.prod.outlook.com
 (2603:10b6:610:e6::16) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: 809e8cca-b798-4673-e480-08df29f60347
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|6133799003|10067099003|22082099003|18002099003|3023799007|921020|11063799006|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Ev83yAWwfmFmOTBAvNWfaeYTNAOxDrDl0ivO8+ptpe5bm8RadfxXkcHF4uQ9CCIh1G8Wu9zmZ36NxuCyrjR5xi1wWamca5aBcSYiUsZkhoffMiEoXNN3gfFekjJJW683/QsFxYdDJc+7UU9jaD12TuIYvlQtDDBriHIKmEFnMXIuMQX5VkypACV9NgogDnJck3b/c9Nx8iNVCPUwy6oB65A0jWKLeUJSZheuiXZUuDick88cpZm/o6NcwhvcGwmHZmXGBO/F/z6kPjtbozLu9ojQfDKlpTfYbmaWmDdNCotoeaU9n4eHfQ87VTMhLYbNxrS1kTaVvUIFkQik/iWvfOa59I5w8Tr+sJRAPfI0+KbcmHRrcQ7Klgs9xQ7LxWKaoj+XieqwmkHz0rLV5eKQ9ZHtgCy9SgxfiF6yhblfCYLV/3PJVpO1HYfvY0LSA6lUZtaoMJOrT1TO4C+R6sUHPM1C4TwRTfMzXfKNWOlZvxnAn+uY8TkU++6hkScjKy7G5MoC31oceKLST5EvLOyRDYPzIxAVcNmq79ntWfO1PQQEQKxqjKCj8X+H7O3SDg7URWncKSG9dR3HxwzrSTvEF0z/t4TjCxr8ACV7o0DqQ4aBg/mSgJc5VIFidIScaSwzQ3fSWdewmAiC0c6Ftm9p4ze6fhy63XlN6Z/vgbjxYcuU4xXFIlqmwDV3bPGdqA622SEBl2/c8aoQnEkn1W4CsA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(6133799003)(10067099003)(22082099003)(18002099003)(3023799007)(921020)(11063799006)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejVGOGN3a2JwaUVlQ2FlUTlQM0JXcjNzblN4eVBXTHd2WDZoN1c5RmF6Uktv?=
 =?utf-8?B?ZDBIelpiVkUrOW5ybEpTK0pZeWgvY3pVSUZmR0E0bUYxc2R4QkltMVZDYWox?=
 =?utf-8?B?elJwZW5lQTZ1V3dLVytFWGJBbjZyYk14andDOE00dWM0THAwd29nS1BnaDVw?=
 =?utf-8?B?RWxCMmIzaVJ6bXk3K2JkSFRpVTVZa2hYeVQzd0hpR21RWWZLbnlPSE1FbHlZ?=
 =?utf-8?B?U3VHVXg1R1RXYXpGbWlzc0pLRGNjcWsvRmlvbGNsUFN5YWRiMG9nOVFCL1dR?=
 =?utf-8?B?NUlCeUF2WkpFTFBTMUdzQ2k5SVFNVy9VR1hDcUtvMldYbjRQUVZQdkJTUm01?=
 =?utf-8?B?am0rQ1VlZ245emo5SG8rM1NrVEJmalhZOGErdkRzS3llbG8vY1pVZHljR3dx?=
 =?utf-8?B?Wmw1UjBzQlV6MkFRaGtWbmo0ZGU0RGtka3Z5aTRIbFV3dWR4TGJCeXhMM2hM?=
 =?utf-8?B?bkZ5QnhSVEpmcStkVjJKS05rUHhaUGlRNGhNeGQ1YW9jV0Z5YkYwdFRtMGZk?=
 =?utf-8?B?dS9SdWVUVHdpMmtuMjVna2NJdkhNRm1XWVQ1NEtrS1lNd09DNmRrR0NuZks2?=
 =?utf-8?B?WUl2Z1orQWZsV2dlQzA5ZDljWmlxSUtscTFvc1pUMVhQV0ZJYUNQOWlRdk9K?=
 =?utf-8?B?YTFOKzVwdUZuNVAxZUc0NC9waXRpYzVmV3pER0pMcHNJSFhGUFVmZWM4ZlNR?=
 =?utf-8?B?VTFDVU5McDhkVHlTMTZDV05JRmphNS9MRkdMNStPNEFtTmZCOGJtRGpVMm51?=
 =?utf-8?B?blQ0YVN5YVY5ZEVtTW4zM1NqK2xTOGVGYmgySk1YaVN2dU5lcEtteUc1NytF?=
 =?utf-8?B?dUhOQ3BtemRGWTArenpwcWV0SndkcllicnJycDJ5OUxLYXZNZTJtdGIyWU9Y?=
 =?utf-8?B?WlhHakJ4YUcrVjM3Q0ErMFlDU1N6UndLZ0lLSlRLRkE2Z2xKRFR5ZUUvcmUw?=
 =?utf-8?B?ZS9LVnFDUUl3MDc2eFVLcjFkNE0vSVIzSklGUkhqeDRheGhQazJ5TTVYVjZ4?=
 =?utf-8?B?YUZGRnNzTzJqK1pUenRsQWFDdnBSWGxIM1ZNd05IaExFS1BYZDNtSFJRUWht?=
 =?utf-8?B?ZWVib2tnVWV1MkVOS21ZT0x2OHhZVnhpR2hLZ3ZqVEZxLzQ1aTUxS2Z6Z05u?=
 =?utf-8?B?d0ZxL2ZQUmRva08rL1duOVJvT0gwNGlOM0pPQk0yQmhXZkVFVzBuTW5tYTVj?=
 =?utf-8?B?eFFuanVjcGlsaU1TUytpcERUaWlyRnQwYmN2R0EzVG1KMStZbHVIQms5cklv?=
 =?utf-8?B?ckVVZHBIT3dyd3F4bDNJMFNHWHp1bzNsVTFrcUNqUEk0Zjg3WHZZU3pYRS9I?=
 =?utf-8?B?NFhiaDBxTWR1L0FFSEExWG9MZEJWQUFscWFFVEl5LzgxZmFyYTkwcmdtb3NK?=
 =?utf-8?B?MVBxR0xZWlhoWTNxZlBaSTNKVHJicUZ6aXkyN3ZBaXV3azkvckQyZEdHVnZs?=
 =?utf-8?B?N0h4Smtja2RQSCtzR3QzYloxeTFqNFFpWFNpdy9iMUljZEdGZjJ1OG11YTcr?=
 =?utf-8?B?VWVCcGdtcFluaFRkNFpNRXB6dVN0MElDV3JLQmI2RHFCYytNdkVpWW9VWFpB?=
 =?utf-8?B?MzZqU0gxZC9RMGFTRmFuK2tIaHdNV3JrT1Z2RHNzbHpmVEkwVXlEZ1VGUjZY?=
 =?utf-8?B?bWRqSy9pRjA5dXR3c012OTdqWkRsQW1BZG04RmhLTHYxTFlxNGsvL0RKUE1Z?=
 =?utf-8?B?dUpmbFNGL2I5NE9MZFhNR3BNTm9JRGQ2S3VnaXRFeHRHNVdsUm5wVWM5TzFO?=
 =?utf-8?B?RTE1WFpoOGdOZ21JNDUzWEFmNm04ZTJqbUhVVVB2MXNRWXBraWgyYkxyYVRT?=
 =?utf-8?B?UE1lVTRvS2REb2dOYk5VK2xXcFM4dHFtM3ZjUGlobmk2QnZNSWZwQk4rMCtj?=
 =?utf-8?B?Z1A2TW5DSzY5ang3QndSMDdrdlBYREl1V0xBdjNHd1FKYXpXMnhqcHc4eVdi?=
 =?utf-8?B?R25qSXlkNmN5YVpLRHFlZHBKMGZoSUtWWS9GdGs3eTZKbjZJZUlJZUFFUmxL?=
 =?utf-8?B?TExlaks0ZEk3T0w0RUpmVFR2d09hNTVYMjZwZ3crRmlkUkp5ZWltVmVVM1hM?=
 =?utf-8?B?Z0ZZQmZmSlNNd2FSSUQrSnpqYWJVU09kYk93TXVmSGtGWHZSNEVwdmlIMU5S?=
 =?utf-8?B?TjNHdGsyR0NtWmV3VGxRbDB0V20vNHY0MHBBRkNxQmxscDFSVWJ5TkRJVzJv?=
 =?utf-8?B?ZWJSRWo4aC9JYjlBRWY3ODFUK0h3NjcvV1NZKzFLTWEvOHJPNkdUUFlXNlhN?=
 =?utf-8?B?WVpFT2QwN21paWt1RnhxRHIwb0F1ME1FdCtHUWQ3UDNveUU2U1U5WFo3WDdG?=
 =?utf-8?Q?dxnhRf8BYPo0no9l05?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 809e8cca-b798-4673-e480-08df29f60347
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:21:10.6541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rcVrASBK/q1I3GaHgH16ZRmoNHCkU29moRbFkXduP6KGzJNp8n7alDl/BU6OXPT4LzNTQxiTNQ6329qWUM09Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813

On 10/13/26 10:44, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> snp_probe_rmptable_info() only clears X86_FEATURE_RMPOPT when the platform
> does not advertise X86_FEATURE_SEGMENTED_RMP, or when the segmented RMP
> table probe fails.  It misses the case where the platform advertises
> segmented RMP but the firmware has it disabled (MSR_AMD64_RMP_CFG's
> SEG_RMP_ENABLED bit is clear), so the system runs with a contiguous RMP:
> that path falls through to the contiguous probe with X86_FEATURE_RMPOPT
> still set.
> 
> X86_FEATURE_RMPOPT is a CPUID bit advertised independently of whether
> segmented RMP is enabled, but RMPOPT requires an enabled segmented RMP.
> With the capability left set, the RMPOPT initcall programs RMPOPT_BASE and
> issues the RMPOPT instruction, both of which #GP on a contiguous RMP:
> 
>   unchecked MSR access error: WRMSR to 0xc0010139 ...
>   general protection fault ... snp_enable_rmpopt
> 
> Clear X86_FEATURE_RMPOPT on the common contiguous fall-through so it covers
> both "segmented RMP not supported" and "segmented RMP supported but
> disabled by firmware".  The clear runs at BSP init before alternatives, so

The clearing of the RMPOPT feature runs at BSP initialization, before
alternatives patching, so the ...

(Not sure this last line is even really needed, though)

> the subsequent cpu_feature_enabled(X86_FEATURE_RMPOPT) checks observe it.
> 
> Fixes: 15d974be0a3b ("x86/sev: Initialize RMPOPT configuration MSRs")
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> 
> Note: this restores the snp_probe_rmptable_info() structure from the
> posted series (v16 3/5), where a single setup_clear_cpu_cap() on the
> common contiguous fall-through covered the "SEGMENTED_RMP advertised but
> disabled by firmware" case (called out in the v16 cover letter).  When
> applied, 15d974be0a3b narrowed that clear into an else branch and dropped
> that case.
>  arch/x86/virt/svm/sev.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index bd70c4d0b774..43e4945e6cdf 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -827,10 +827,16 @@ bool snp_probe_rmptable_info(void)
>  			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>  			return false;
>  		}
> -	} else {
> -		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>  	}
>  
> +	/*
> +	 * Segmented RMP is either not supported on the platform or is
> +	 * disabled by the firmware.  RMPOPT is not supported without
> +	 * segmented RMP, so drop the capability before it reaches the
> +	 * initcall and faults programming RMPOPT_BASE / issuing RMPOPT.
> +	 */
> +	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
> +
>  	return probe_contiguous_rmptable_info();
>  }
>  

