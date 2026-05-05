Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010059.outbound.protection.outlook.com [52.101.193.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B781D9A5F;
	Tue,  5 May 2026 14:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777991794; cv=fail; b=JgSka+meA23hmCC2QNF+rTRbhDUJ/fBuKJLJe1QLxFLcYSBfL6y0MssawzMcaem/z8QVmHLNdxM6tDF+51wR/SHTmWkwecn7QgCL02u7aeLd+BezD9beuD8KMjjezwD+wByKfM5TNBlaRsM1cMhH5K5pBUFa0DJBLtBMP+Hhm/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777991794; c=relaxed/simple;
	bh=R1rGHpDF7phV1UFZ3ByarZ5KAj7ApJu0OuFqvizEn/Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dopj21NZiUK9psXlxRp/YQHvM94TnzffnYJDkO1kKmLGkgacCisCV6kqHR8GUWDq0NRCR/xZJHPi7ISyAVj0gvrMKElS8JS9zHeguqklzThYIukuWKOgiiIoaa90YTEGaTewdRsvb/2hOP04UJOGI7I8+YPGLilK0KeRIebgrbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MlHXRsW/; arc=fail smtp.client-ip=52.101.193.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MlHXRsW/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yyVzwjmy2QxLoi2ksIVnOBt4xNeFsZ92AG3zIKZmrAbE2xee59VMGHEVHFzdpyyumfWNXlRiqoGib6cHKUfHW6tWkjk99h228fcfMX7S5lph+LHP9rG8bDNmmuRShiqqeDpmAugMwwbSHw0TkrCsAQtZhanOYUmGgWKUeOhME/HqhXSzpeL/CrBfRJCRkijPdMNx4N4PoNYCGUzm8QWbbxeRE0+Df2q9+ZV0hl1YDIq3uxjR5jjhDNAzLjlcHG0wRq+M2Z8Tqq4ZjCAJwxhDTN+DCnx9QqqJWQzOxGYmScmoLnqEKorYzFSNC2xkRVSG9OozsXsK0MEWgSWq9ZYYvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hFEIWNj5Z6wMTEF/rSYESwMV6NZweMOy6jT/NuLm1bo=;
 b=PLsUDZGI+pqPNx2ifCyNAj4zVpjd994/oRQK9bWGjCetAg96FUhbS0cIBaH6Cm5/7veRpZW+Df9Q3cR9UXKbERN0qfBMYAduv69xs+lHkf4S+zxIZMEnqw6IJJcndqD3HDYwVDGfvogTp5nMK24/qGTnodJI16+2ZU4klc0Ext/immy8Wye6BeV/KyEhGPwcPwMWTQLlQZKreDp7kkJnPqdeFVQt+4cb4kdQSLkHg11+p4NYQwFBBgqY9YQVgUEKHo1810owNGQMD6NBt79Dj9oMUhLD8rmkYZLNHkXZnQ9CWrVEplkgsGVSgFLWP09EW0oEZoWkZroLnphg7RwMxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFEIWNj5Z6wMTEF/rSYESwMV6NZweMOy6jT/NuLm1bo=;
 b=MlHXRsW/iQfZsSbHygvzPMHNGpewAEJ8aDypMeRVou/UbH35aE1vXKz3dpR4zqrebfMV3Ec7r+Hz/r17f2V2NX3Dzel0Lsythw/HK6WjIY0cvmHz2Z9V+fOzXH+oY1hSujarCuWwZNHCL0bfgpKMtOam3nAtVqyJamJdcKysG4Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB6701.namprd12.prod.outlook.com (2603:10b6:806:251::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Tue, 5 May
 2026 14:36:28 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 14:36:28 +0000
Message-ID: <695413de-90cb-4f89-a067-eb4279c4d2c9@amd.com>
Date: Tue, 5 May 2026 09:36:26 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] crypto/ccp: Do not initialize SNP for
 ioctl(SNP_VLEK_LOAD)
To: Tycho Andersen <tycho@kernel.org>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
 Michael Roth <michael.roth@amd.com>, Alexey Kardashevskiy <aik@amd.com>,
 Dan Williams <dan.j.williams@intel.com>, stable@vger.kernel.org
References: <20260504165147.1615643-1-tycho@kernel.org>
 <20260504165147.1615643-4-tycho@kernel.org>
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
In-Reply-To: <20260504165147.1615643-4-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR20CA0024.namprd20.prod.outlook.com
 (2603:10b6:610:58::34) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB6701:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b8c25dc-4aaf-42d8-748f-08deaab3b12a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	m+ZyJgAaaJpTbc3hvY98LCWTq3LU3XomwAbU/bFgsyMQTUrkCUP+tpN5OHKAEcnP4l1XDDnomZewIAOM8dC9Vxf+mglcvZxf/nGhfocbLKg6f7eht4ZKI4mdePceJ89TNX4OZzfiLB/w8a4VVrrhqBCC/3y/IvERI6FsQ2GWWkfk71Kn+6gwGehL9O7vhgyTmAGnmeNGIkSz5pg26BRmycruq5rNy5sfIaTDqlqyZ9EkS97bVWRXJcOFTVJT7/RPRkqJO8uywd98XzCgiAp1hjCdznRXWeSwPCrsfSPlT3CUQnCOxiwWs1z3KLnBtz8d0xV0t6gpzNSZPwarLBm5rwEjFpK6PqylAFX8oeDnLQz1mzqLxiORiG2XZ2lS8lEc4kEDomj27gOZVIDFoes0vPg0L6n+ifa4B/0MwbSXUdcznxuEu8uXR/3LJ1FaqiBQ1/8y6SVwoSTnHB3wl5tE4wPM5kW7Ta4bDlQsCID2qfq4boO5yARZT5mUh3JnXNDhKGTDQCbuzAzq9oq8heoeclNRciDXPBtNtS6pZWio3V0Na5ZrnGtTvi2bfPFdl801UqfQsqwMKX3DFm3VXJa69BxfEK/XFaZX6Yhb5g19ARH+lV4csotmRY+NCdNATSHtEPJSZD4AyJGm+u82zf38/Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2VtSVJkUUsyeWlxL0ZvNGp2bDJPWit4Ty9zMHNRck81bDFEYm5OMnBoNElG?=
 =?utf-8?B?eVVqU0lWVVk0RW5IWHZ3dkF1bVRNOC9HQ0hIU3JlYlg1b3djU3k5RkxVTlBY?=
 =?utf-8?B?M2FxVjZCRGV0a1BnL0Z3YWlKbWxjRGU1R2Vya1c4REFaWmVnSmxtT2JYVCs1?=
 =?utf-8?B?L1ZmMXpxaHRmTHV5VUZsRzJVbXhjNmhOSnh4ZE42WHlkcW4rZ0xNR3hrL3VM?=
 =?utf-8?B?RlgzMVBxeGZFaVZVQ09DRStmWG1IWUd5S0o0V2dja2o0VkNMUGNuUW96MERw?=
 =?utf-8?B?MmpEN3NZNDFpeXBaa0hWTDZHb2JCM1dVQUY5RXR5VVNQakI4ZWdTVXErT1NG?=
 =?utf-8?B?WnNrVVhUZWtyciswQlVWRC93Qi9LcnQvNHhyQUE3MU45aEdoaHQ5Q1E5Ui9C?=
 =?utf-8?B?bEpiUFo5Z1VLWG56Y2ZNak9Pa2hzOVBnV0hNZVUzMFRJaXEzT2hMeVNhSEZC?=
 =?utf-8?B?ZGxNNFdaOXZDN1N3SXRzajRRcC9zai9ta290d0VwY1pTNjFLV3lxaVJ3Y2wy?=
 =?utf-8?B?alNQV3dmN041K2loa1IxbXVDSDc2a1hkdW5Oc1pJaWlpMXVqcjhzbVFmZWZE?=
 =?utf-8?B?TkV5OG1KUHV2QmtYelpVNlh2aDZtZ2dGNmpEZXkvVVBEOGxtZUJ1RE5jRWpQ?=
 =?utf-8?B?bmVVam04T1dneUFtM1EwMHZDTlJFcTBmSXZSYVBEaUhqK1pLR3VQbDRNVFJk?=
 =?utf-8?B?OXh6bGp4WkhSMnZ2bDdnV1QxM2V4ZFZ5Sm5SblQ4UmRqTll6bmdrRmh2WDV4?=
 =?utf-8?B?Zmx1ZU5CWE9vOFU5MTFWNGZoeCtGNmVodWZuVEIzcTZTaW9mREpvU25VWGVE?=
 =?utf-8?B?WkFCN05heXFzYllXaXBWRFBqZ2JITU92RjN0R1RPYm00VUFXKzdoTEhySlFM?=
 =?utf-8?B?Y1E3dzgxRjAvbTlveEtqWVF2cmNGRE01alhMOUs5aXdTdUxFMy9aNXRXK1VR?=
 =?utf-8?B?cmcyS2RuWkd3RlU5UW15eXd1R29rak9aM3pNWTRIS0JuQWgwSG9ScEI1ZnVr?=
 =?utf-8?B?ZElURlR3QXFsVHZlRDNPZ3dzQzduTDRERG03Mm5GUFd6N0trV0toenpBRThT?=
 =?utf-8?B?NmhGT0Rpam1EQmZOTlZOYnJ5QnhlRWsydGRvUjRaWllrejVQdlJ3YW5vejc4?=
 =?utf-8?B?Y1lnT2N6ZVFCeHp6djhiaVJyUHh5cVpkTDcvMmc1UFZJakpCM3RnOSs3NlBB?=
 =?utf-8?B?NWYxZkozVE11ZFN4MVRrc0R0ZDVSU1N5VWF0SjhjVmF0ZFhLazErZkw2NmZr?=
 =?utf-8?B?dDBwczF2ekVEY1NmSm0weWNGL0QxT1NPTW16ajBZeTdrRDNvNjJmRk5BQWtv?=
 =?utf-8?B?YzdNN0JWb3hpaTYyU0VIWXRwL3grZFhERUNsU0ZnaFlsQldNUW95WWJLSU56?=
 =?utf-8?B?NHQ4ZEVoMEJuVG56UTFha3ZTUVRTZVA4ZnVBNW1Md0hLc08xbkJ4UDNISUIx?=
 =?utf-8?B?OTVDT3owcnRTODRFcS9wWnF2N2VxS01SUkR1aTFjTUJoaDd1TjgrdXJTZE9L?=
 =?utf-8?B?a3ZiNU1pTmZwcUttZ3NkRTBhTWFOeHl2YVlCTk94d3Z6dXdTa0FTaWdOUVBV?=
 =?utf-8?B?akkxWm1VMVQ2dThLaDhWRG5sYUNDcWdQNHVPNzM1SnZkSE8zemlpRlVxc0dF?=
 =?utf-8?B?aWFpT0ZrUUhHbTAxd20xWFdFR1pHR1gwQ0xqVitGdmdscW11UTkybTlQaGF5?=
 =?utf-8?B?djA5cVpzaEpQSlRZUGpERWYyNnVFaldEc2hsWTNBZDgrQTVBRkN0Mkw2ajcr?=
 =?utf-8?B?T3QxSGEvMkhuUmpFVE9xRUUzL3UrR2pVRHZLVmZZS0JXT2QrQXJ3R3BzWFVI?=
 =?utf-8?B?cldwVWd5QTdWMnFrekV3STJmTmtQaGphWWZLVUJrUjFtWVIwcFZEZmtCREdS?=
 =?utf-8?B?ajRneXcyV2RNZ3dLQW9PWWNXdkFXWFZtMWlKNEk4RXhhc2UyZ3F3bStqQmR0?=
 =?utf-8?B?eXhZWFBRZ2JWUjJYQW55eVU2YVptNkljbFdqbUNvQUxUNkwrdWJYbHBRY1lC?=
 =?utf-8?B?ekkrVE5lWll2UmxLZWg5UEJ2dlJGRUk3WmhLZUxVUXFNMzM2bW5pM2pQSXB6?=
 =?utf-8?B?clczZFdkSnhpZGJnSGxXTVdiYkUvM3R3TS9VOWtPOElaNW1GWk9Ya01GYVFz?=
 =?utf-8?B?TXMxTjg2Y01xMFhVMlZTSTk3USt0ZjRJRnErTGV2aFJHa0g1K2tLYjRqcXI3?=
 =?utf-8?B?akpBb0FlNmxjQzZaZW01U0ZxS09xVVFqSDlhSFRtYi9OOW9kMnp3N1JsNzZB?=
 =?utf-8?B?NWxSbHJ0WXZRVVBHOUNqbk5DRUQ2SHhueGJOc2IxMnpucmNCY2VlYUJ1d1ht?=
 =?utf-8?B?TzNRb3daNnpYNkZXMmhYNnBhUEpURTd6QmxLYS9vbVpDV0wwRDdtQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b8c25dc-4aaf-42d8-748f-08deaab3b12a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 14:36:28.3132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nhWkJlTKo7gOn83/h4vEepU8aakukXJnYMHPCAInobLrT5VO3vcA+olO2epYQHWtHtril2lGVdFvfHQDhPD7Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6701

On 5/4/26 11:51, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> Sashiko notes:
> 
>> if SEV initialization fails and KVM is actively running normal VMs, could a
>> userspace process trigger this code path via /dev/sev ioctls (e.g.,
>> SEV_PDH_GEN) and zero out MSR_VM_HSAVE_PA globally? Would the next VMRUN
>> execution for an active VM trigger a general protection fault and crash the
>> host?
> 
> The SEV firmware docs for SNP_VLEK_LOAD note:
> 
>> On SNP_SHUTDOWN, the VLEK is deleted.
> 
> That is, the initialization/shutdown wrapper here is pointless, because the
> firmware immediately throws away the key anyway. Instead, refuse to do
> anything if SNP has not been previously initialized.
> 
> This is an ABI break: before, this was a no-op and almost certainly a
> mistake by userspace, and now it returns -ENODEV. ABI compatibility could be
> maintained here by simply returning 0 in the check instead.
> 
> Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
> Reported-by: Sashiko
> Assisted-by: Gemini:gemini-3.1-pro-preview
> Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
> CC: <stable@vger.kernel.org>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 572f06368d4b..ad6c2525a305 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2481,9 +2481,8 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_snp_vlek_load input;
> -	bool shutdown_required = false;
> -	int ret, error;
>  	void *blob;
> +	int ret;
>  
>  	if (!argp->data)
>  		return -EINVAL;
> @@ -2491,6 +2490,9 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>  	if (!writable)
>  		return -EPERM;
>  
> +	if (!sev->snp_initialized)
> +		return -ENODEV;
> +
>  	if (copy_from_user(&input, u64_to_user_ptr(argp->data), sizeof(input)))
>  		return -EFAULT;
>  
> @@ -2504,18 +2506,7 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>  
>  	input.vlek_wrapped_address = __psp_pa(blob);
>  
> -	if (!sev->snp_initialized) {
> -		ret = snp_move_to_init_state(argp, &shutdown_required);
> -		if (ret)
> -			goto cleanup;
> -	}
> -
>  	ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
> -
> -	if (shutdown_required)
> -		__sev_snp_shutdown_locked(&error, false);
> -
> -cleanup:
>  	kfree(blob);
>  
>  	return ret;

