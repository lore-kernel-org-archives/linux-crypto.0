Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012000.outbound.protection.outlook.com [40.107.200.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CA13612CD;
	Mon, 19 Jan 2026 14:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768832175; cv=fail; b=dLj5IpbD4OipvAfcNYwfytj92l6HlUo/+iTmxxh+obNeBPMq6ovymFy14wYUYl2mUB7hUXTC/fzybmUdY+RQHgob2dqJYIzXA7hs4Fl5dzvbljbz3VflsBiiCxPincNH75ojsqzQhVvCHpFBZYIhYia5Ri73k0IhHBX7zVK9dL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768832175; c=relaxed/simple;
	bh=1pqSvfQEe5C+inQuhnAauoXiDCKRgQFefrDjCMZOQA0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LVcu9o3NVGQohafGwbnfEVH9KGquocmLXHVMgQQAmadx/7xG3385YiBpX7WDZ+mEn9qhh8F9ouu+6tvjaB872Rr8iBZeuKo8fvWCup04sTZ3pZD8XJi3lX8kEDjVa+q3QMhg9X6tUsYJnSWWCtiwX4d/ydqb8PU2Jc6uRbMtctw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mh/4BW+3; arc=fail smtp.client-ip=40.107.200.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mh/4BW+3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LZZpD3/LepEg9yHP07ZHQ4ZVnLVp6EkXnE44AbT96jXR+oAVhLxSFRlbhXhnDM9E+6AnshFxB0VoskFLVaCNZGnRp4cdy43N5mXOymdqbFoBPVNrWlXoFQD69M1MAETS54szbpFPpBqY+TvWr0RoTkRbT211S6RUV4LJOOh7iTNEEE9gzgCTWA8VX3tIdHgZqCfmXMKoV93wmzYZo6L8Hpyit9Mw/+SCvsrm5/TzlZkjB4P5OKiXnOZJIUZs+PvbwvWdCuyM5eYbDXqNpQrA/Jm24J3jE6+Sr5WAI6O5gXkDdwwjadUo0pD3smjgKaBlcRXMI0boH8aR7JuBPasY6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k5+2Mw970nmXfUD3LtwZw9ss5c/0q0se74DfXzkNXOY=;
 b=lL90deMEHtuT/dbFg8yVlGRJffe9VcjgzCjlfxkuHvYcabx50bMTJRkL21qJWtwI1VuRsmYDH/ysT83lcg1gGncW+LeAcmBn+92Tt7bFLK8oKYerlkjvPykB2t+fQ28k3RiVfsxDDbo9P1bCE9EH8wUQmg+3ewed+qsDV1M6gYp7xGhgBM1C7Suy9yqS7jaHwM96C05PmWgLH4ZaGKZLsXIwis3tn8txCGziQqGWSYBW9NXvueM8SGE3sB9B0KLl5kbOSGT3LcXF+L7dov6ZFD70pNo3SMgs0Ay/Hi+7PrqiDtsBGe9EykLLRVYha0dTG9HJWin3DQCG5SFvm/tEFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5+2Mw970nmXfUD3LtwZw9ss5c/0q0se74DfXzkNXOY=;
 b=mh/4BW+3kvFgocERcio2/jh1+kY4+SorTzussicvsEoNe6MfrW5OxalE1QJg7GK+roE514+PiPgP+tCKp0wmbtHrds3KyhKAlCm40jwo4vmzp6Toahq4MSVtYhV40Nkv4FQ4O8eAhGjIZSOfe+X91QBcz5J4uKmc7wX7EI3bKNk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB8334.namprd12.prod.outlook.com (2603:10b6:208:3ff::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 14:16:10 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.9520.011; Mon, 19 Jan 2026
 14:16:09 +0000
Message-ID: <9ebfcad8-dd35-4a6d-8e14-8eaa0f9550d8@amd.com>
Date: Mon, 19 Jan 2026 08:16:08 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] crypto: ccp - Factor out ring destroy handling to
 a helper
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
 <20260116041132.153674-5-superm1@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260116041132.153674-5-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:806:20::14) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB8334:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d94c2a4-7d61-4ccd-62af-08de57654b27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ajgrSTRCNDZVYVFGZGQ2Rms2MjMwSWIxSUlzMUNuVTIvUmQ2anFoUTU1WUhG?=
 =?utf-8?B?TEtiY2YydCtpdGgxamI2aEg0V0RKN0cyOWVJTE92ZFRHa2d0L0hMK29jcjdP?=
 =?utf-8?B?WGpMYTVJL3lWQXpYaHZ1VEQ0aWN1V0xHLzY0Wnl0TjJDRmVpNm9ta3I4aDZm?=
 =?utf-8?B?Y0lpd1UyZFBKVjJENWoxMnhhR1pacm9UWVpoODI0Z25CMFdTd1dZS0NRenJm?=
 =?utf-8?B?UEdib0dRV2l4Vnl6ZDJPRnRvQXVuSjBtaklYbXR2c3Z4R1owMGQvK0xMemdu?=
 =?utf-8?B?UlpnRlI4TmlxZW40ck1xL05IcjlsOGhxRWF0K1F0cEFnMGMyTnhtTGRUVHpj?=
 =?utf-8?B?bUJhNzJjN3c3YW1ONnpEbnlzUW01RTZuUHlnTGp5SzJtQ052VG95WTNzT1FO?=
 =?utf-8?B?bURaOEZxTTNJdVZMMklMblZPcmJtaXRvRnlldmlkMlMxNFcweHU0SWdFSklj?=
 =?utf-8?B?NVdSV0QwUERJb21kV0R3eVppdEJMd2wrWXUrTk5Mb09RK01ZcFphaGVNd1Z2?=
 =?utf-8?B?dk9FdWJXMUYwYkY0d1A3enhHK3l6RXdjWHB6am9TWDNCdlQ4eHpnTkZMK0VG?=
 =?utf-8?B?ZzYvZmk5VXRjcFRRRHBkRksxK2tscW94VUNWU0xQdjhKSmczSHdmejNjUksw?=
 =?utf-8?B?dzVFaGdlR05RRndkUFM4bkNwbnVadjF6RHVsdkpPZnRzL0ROZm5uWXptKytQ?=
 =?utf-8?B?YkRwczB6UzlhU1ZSbDlVa1NDUHBUYnZ2MUlYOEg4UnJWVFJySGFFd1N5UWFD?=
 =?utf-8?B?SmJ4OCtQb0FoUStZV0JqdTBTQW90OVR5NWE2aW8rZmN3eEZoQk1OaDUyN1Vp?=
 =?utf-8?B?dmlxT2d2dnpWeE10VGxrcTRTVkkxcDJmTjVlZDMwUk41dzFWdXJwZC8wSksz?=
 =?utf-8?B?dnpUM2ZLaVBKUDloOWpoSlp3a0xob1ROSzREcHZPSzBnWGx3a2ZpWmtyUjN6?=
 =?utf-8?B?NklmUGc2L290RytxSnh5SjljbjBudm0rZGkzYXcrQVBhWCsxdFNLMUhoeGJM?=
 =?utf-8?B?VWJyMlh6SmtTeHY2ZUJ5NkU5aE94QmR0amtZVmd6OVd5em1FZVFIdExOSm4x?=
 =?utf-8?B?TEc1ZHJRbGsxdGU2RmxpNVREYnlxeXorQmZERW5ITkg1cFphUVZZYjhqZU0w?=
 =?utf-8?B?YXVkcTVOSVVnYWd2dzRRb3l3dTB0TnFOTUF1TXJXOTUrN05yQTFDMEZlNE1S?=
 =?utf-8?B?eHgraWZkaFRiN1lpQk8wa0dtNWMvcFI5MXJWMzd5Q1crN3BEemh1MjBQRDl6?=
 =?utf-8?B?NjE5dTlDTmxkT0s3UnhGcmFuUWFrVjJwTmdWbDRUWExOZjM4RklZdTNySVBX?=
 =?utf-8?B?SkNZbkpzRlRBS1BWamYxUzlJTWpvcFpnSHJoNmVKYW1jdWEyd3M3THNIUDEv?=
 =?utf-8?B?ekx5RXEwMnpIMVYzYjlFTCtJNEFsaUEwL3ZQdGNVaTM2bWZzWGlZYzdRc3dM?=
 =?utf-8?B?M3k2UDI4amVGdmhzMHVnRTRndzkwcDh2cEFyVzBTaUpQc29veUduZlgyeXor?=
 =?utf-8?B?bnlXQ0Nha0NZQXMyMFpoalZxYzgxVkYxeFV4blBicVBUVzlteVFocHdXUG8y?=
 =?utf-8?B?WVp0bG1oOG5sMGR0bWplNm91dk9GN0FYRVBNK3BTNmtWSWE3a2ozdmVVWXhr?=
 =?utf-8?B?eC94UnpFRnNQU2dLS1pMVXMvN09sUmtlcWlhcnJaVURzaUZRNUpuc3BEUm9H?=
 =?utf-8?B?Tlk4bGpjbmpNVmpkRTk3clY4V3NZbDZaR0p6R2ZQbHVWR0M5MWdxMTlocVhs?=
 =?utf-8?B?b1RoRUdJUzFDM2RVU1U0YStoQVNsRkxKL1dTT0pwSG92ZTNxR1IrcjZxdG95?=
 =?utf-8?B?dUFybFVHQ3IyR28vYm5KTlhPQ1hFeGFQMVNoOEkyeWZpV052cmMwaEI5RWZS?=
 =?utf-8?B?dWZjZDN1dzJiWjZWVmhySFRBdUhJd3g5a0VwSEVZZ2dDV2gzKzlwNkxQUmZu?=
 =?utf-8?B?bExnd0VCRWFVaE1XN0NLTXlHUVQwZEo0MWoxcEpzQ0o1dHpwbTNMdzM3dXpP?=
 =?utf-8?B?WEZGTFR0bTJENTU0UENiZktUemczRElTUzhhUm9kcTF5VWhnVTBsY1AySG44?=
 =?utf-8?B?MXN0VTNSV1pmbk5jZzZKTDNERUdlNStVZmhQSHpiY3o1Ukl1b1d2ZlJ0U3Bk?=
 =?utf-8?Q?beIk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXJFcVpJSFJmdnB2eTdqcHlRNzd4NXEwQTNQWStPZWhsb2N1SW1PMG9WVVVi?=
 =?utf-8?B?ZlhFbjFVN3lwaTkrVWJPcGZNWEc5QU8vTE45UDF3bVlVS3krY2ZMU3BaWVY3?=
 =?utf-8?B?SnNBVUVQNDFMeENaM0Y0c3RBcE1pekRVNnRGZk5NN2pWb29PdmZoTVBuV3Qv?=
 =?utf-8?B?ejhJd0dTQitpU3JxK3hEek93bjlBelM1Mk5tRXZkclpPYVJMUXYwT0pjWFZQ?=
 =?utf-8?B?ZU5OaEdSSjdVMHZXZzFhTkc2ZmVBdUtZQnVlZjcvS1I5dDBYcGFYNVc2NDJI?=
 =?utf-8?B?ZHMwOGtna25xMzZTRFFQREFXY1dSbDczRktCK0lvdG9MeDlRZlF0dTBmdWhv?=
 =?utf-8?B?OTMwRWZpL3RqQkRWVU54Uno2L2VwTm5sMU1NWnhZWGpSU0dKaUxCdThRRWdU?=
 =?utf-8?B?aG03ZyswVWpDQnVXbnlLc3A0MW1iMFhySWE4YzV5YW5PL3dtQzg5anRKc0U5?=
 =?utf-8?B?TUFsTmxJejNnWHFic0NFV2ZFRjJTajhGRklsczM2QnVOK05BZGt2RmQ1M1BG?=
 =?utf-8?B?MGFad3ZMTWx6VllJNXlJb2Q4Um92NytIbzFRR25hcXVQQndqT2xnRkxDMXNW?=
 =?utf-8?B?MTc0cW5GL0wwcThQOTd2VmRSTmhLTWF0VllKZmhzeWZwVlJYNnppZ3kwWk91?=
 =?utf-8?B?YnhaLzdQdGRiZiswdTExdFJIU3lveVd6bWhGU01xZ08rRWRSVHJReDBFNTFM?=
 =?utf-8?B?UEFsbTF5VGVVRE1PNWJGQ2kzVENwNDhab0VJZGJLZWNqSWpjZ3JYYmFFOUpK?=
 =?utf-8?B?SHE1YVp2MnhqbHRNQm5EYTZkOXF1K3RMVGZ5V2xtUnB4TW5Ldk9vQ3VOK2lF?=
 =?utf-8?B?eUhNOXp4dG55MldSaE41aENYaTFTS3BSS1VFOHFSVkgxKzVBeXB6aWhhU1hG?=
 =?utf-8?B?Z1c0ZExuREZZYnA4SEkxQ0FCZW40SlIzSTdkYzlka2RlSURDeTNVaDd1MnF0?=
 =?utf-8?B?ZFFPQkZiR09ZbXdzYUkrcUxxZXdCajhvZ0hYbFpYYVdNeVpCUndEc1Eyd1Mz?=
 =?utf-8?B?ZjBHNmFleEZCZXkvUzVSbElxcTM1L2hiY3lLaXQyQlVLM2Y2Q214QXZNckMr?=
 =?utf-8?B?N2xlMkZ5RFBFNVlINEhSWHNDQlRpYTlzOTVzTFVycjNrQWFOM2hIaFNKRnUr?=
 =?utf-8?B?MitmZHVBNmlMUU9pOGZuVXJBSFh1MjdEb3RLbVVYbG1KOTRWQndNWjRoUEp0?=
 =?utf-8?B?YVVVZDVJUlp0UnZaWGxJMUp4elcwNGlqTUhFbmtwQ1AxZ2Vkc3lmd2Eyck53?=
 =?utf-8?B?MlBPUG1oQVhtRjB1YmkrMjNKTHpUMkNIbkxXNnUvRHJkWFUyMWJDRlI1S2l2?=
 =?utf-8?B?am5BRGhZdUE2THFFYWZVaWpWbHBSYVpoTTBRTXdMdE5JNndMMGxZV2RrTnhW?=
 =?utf-8?B?eVdUbWFOTW5IU3p2dkNBRG9yWGd1QWJUR0d4OHN0RmFSYW04ek9yeGduaU9H?=
 =?utf-8?B?QndwUTFhc1ZqTE9mMDdhb0lTZndMNG5sNXA5a1plSHB5b2lvQ2QzVEJZZEZ2?=
 =?utf-8?B?bFIzWTViRWIxTGhVWS9pSC9EeHBkK2JRZlBpRjJUbGp6VEVmSEtaTGVXVFdX?=
 =?utf-8?B?Unc5aklZVnZydHdMa0JMdlJwOGpOM1RSMmN2Q1g4NDUyclJEWm1OT01Qb2Rm?=
 =?utf-8?B?a2tETDlyK1JyeFpYTmY1VE80TnhheHRMK1R3S0RMUXN6V1dVbmxJNGhNdlAw?=
 =?utf-8?B?WG5QbDRpQ0FYRmE1YUxQZEE0dE5lcGJ6OFFZLzltTzFiSVdmVVJrdGErak5z?=
 =?utf-8?B?Qy9Cb1B2bHM2UURtYlhlTUZoMFFadzZTWGxMaElQUHB6WERQZm1DMTF5dnY1?=
 =?utf-8?B?cHNBYXRiU0hnUDI5TkNvamZyNzRmaUgrZ1Y5ZEFlMEN2TDlwK2VqQ1ZkZXVB?=
 =?utf-8?B?b2lIYXJBMVUvZmcyRjFnd0pSUm9HdjBvc1ErWmhzZllweWxXL281ZXJnZ3Yz?=
 =?utf-8?B?dnhodnhSKzF6MCtvYUxBV2FGOGlhMjJqUWgvcjc5UWZqVXllMG55WXliWUQz?=
 =?utf-8?B?MXdzeHFWVkRyTk5EZmhsMndaejFnekJWR2ZDRmJnamtjcEYrTHdJQmQrMVBS?=
 =?utf-8?B?aXlsaEpNR1lFK1I2S24xN2UybUZZQTBuSlNZc2xKL205UDBZMHUxMHNtZXRs?=
 =?utf-8?B?R1o4Y2ZyY2l3NHJZamhIUlY3VVFqRENSLzJBckZ4YW5sV0hmUUJSOUlHbitJ?=
 =?utf-8?B?MFB5bnNleGJSa1RpYzZOZ1FqOEI1RTdrTHpOVXN0a0xHelE3dDIrLzhZaDV4?=
 =?utf-8?B?VFlHdmNsMnU3WDQ1Y1VhaGlkOUJZQ1dnaUNqTXlid2hUUFRTSXIraGNLWXl5?=
 =?utf-8?Q?IhV3ojdwQeUDYoD5BT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d94c2a4-7d61-4ccd-62af-08de57654b27
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 14:16:09.8783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gB4eCkTg2M4LyIMYLmImCgE8Sty1O8eCdhm3xBlCe8kJtIY6CvY9YXvDdpWBtCqGw2x8qvGRcHLDYnIYm7x5zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8334

On 1/15/26 22:11, Mario Limonciello (AMD) wrote:
> The ring destroy command needs to be used in multiple places. Split
> out the code to a helper.
> 
> Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/tee-dev.c | 36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index 11c4b05e2f3a2..ef1430f86ad62 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -86,6 +86,29 @@ static inline void tee_free_cmd_buffer(struct tee_init_ring_cmd *cmd)
>  	kfree(cmd);
>  }
>  
> +static bool tee_send_destroy_cmd(struct psp_tee_device *tee)
> +{
> +	unsigned int reg;
> +	int ret;
> +
> +	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_DESTROY, NULL,
> +				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
> +	if (ret) {
> +		dev_err(tee->dev, "tee: ring destroy command timed out, disabling TEE support\n");
> +		psp_dead = true;
> +		return false;
> +	}
> +
> +	if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
> +		dev_err(tee->dev, "tee: ring destroy command failed (%#010lx)\n",
> +			FIELD_GET(PSP_CMDRESP_STS, reg));
> +		psp_dead = true;
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>  static int tee_init_ring(struct psp_tee_device *tee)
>  {
>  	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
> @@ -137,24 +160,13 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  
>  static void tee_destroy_ring(struct psp_tee_device *tee)
>  {
> -	unsigned int reg;
> -	int ret;
> -
>  	if (!tee->rb_mgr.ring_start)
>  		return;
>  
>  	if (psp_dead)
>  		goto free_ring;
>  
> -	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_DESTROY, NULL,
> -				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
> -	if (ret) {
> -		dev_err(tee->dev, "tee: ring destroy command timed out, disabling TEE support\n");
> -		psp_dead = true;
> -	} else if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
> -		dev_err(tee->dev, "tee: ring destroy command failed (%#010lx)\n",
> -			FIELD_GET(PSP_CMDRESP_STS, reg));
> -	}
> +	tee_send_destroy_cmd(tee);
>  
>  free_ring:
>  	tee_free_ring(tee);

