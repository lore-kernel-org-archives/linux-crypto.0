Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011009.outbound.protection.outlook.com [40.93.194.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA1A5616B5;
	Wed,  9 Sep 2026 13:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962125; cv=fail; b=bMt4QZyEat54nlGmu3lRUdW758kODDg39PqbagK5M4fZu1NXo11XUlfk1Eg96oEeDuD/D9npojxjnO0ZNJUsBfIKGwqQ8o/SoR02ZhiIkA6O5dPATAyApcvEfXOgBrf+bPxtP12eNSAw/KZdYDAvAvqNIrCI1okbmDmefhwD0Og=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962125; c=relaxed/simple;
	bh=ADSHUauvMNxiW2ns6gHMiNUOc7Jo2XfqCR8n7Cz+jYU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pJmL9m8stnRsGIN5sRqsYhZXhpNspgOfJqYwq9vc4f8uNI3YiaJyNuElhlF22RPp5kG17KoyYmsagT27/WuCj4NVCB0ZKqZOvJLp7sgfu/AuTwAmreCkmdx8uRcVIvKSQ3zRIY/kvfSmHN+vbpN2GqEJjp3omIFxLLjuFi4o0/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZUcD6XZm; arc=fail smtp.client-ip=40.93.194.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZUcD6XZm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qTGUs11TlmgAbnrRKb5bh/nsauWGcUcUw/ZpCGDoXXRXYgB9TDVB//TtRwFI74B0MeNtnbW923nlTwxNP/Fvfl2AXAgKnKq6XheMgJfSgnWPkv2HiBlc1v1Icb9tvoqXT+6uWiyWzGxXTO1lftEP3qs4UENpNQr+zqA5wgDc1J6HGOiw2kkcP6F6lpVaM9pa4mc+klXeUnTZie8qQzZp5SAC4kd29G892z50FFs0r1kxdD9Nf3HErq8WpAdca+0f2U1WdKDhEhzNPmLV1jIoJPFV6AGUuVxMISfq8A8rd6w/CzVIo9Yqx5kJkw+Pdz0cHn2YCPNVH3s3yqKkZvqakA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t/66H6DxMk/GCGpZp1ZXDrbDZTZTLdH3h1fZMppmi9s=;
 b=AjM91xTCYNDpDf12ItlJMhW5x6JVL73Fqr7Ufa9eXJghUhSC8sGJn1HYuJdCddHmvIwx7O8P4XESxxeJKqZwW/2m8jQVXOu+6CGvkjmQt98WPFzg7Sruu7Lz2aZPUHK9w6B4xJX8pyT/Ok+8HZC8w3tlyeFifXLP1qxHPao7U5edMUVOgxp87MkMGdLndJpt/yC/56X6bCdOLi1WE2jJ/8c2cnlRBRzJr0/eUe8uNAJ9qx4lGfBcJQ4QZEW33jIWWmgSW1UF7h9raVxpDLpUuHXIWA2BLu/haT7YXoP6x09BkL9zdNK9/h/PpRvNDYUieUzNeRDRHrRW4F8pPqfPvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/66H6DxMk/GCGpZp1ZXDrbDZTZTLdH3h1fZMppmi9s=;
 b=ZUcD6XZmXwqpiwREhl117ndbvsS57ZS4AFXVUROxYoDlCsopulzatvvAvSHLjhY7IJwgrxLmxzE6BSwa9BZRdp3oGtIabHblrFy+fddmSScf/EsqNYD1fZfVRXCo4GdMXAeOCVT16gt6vE9Nc4Y9RPqFgik0kxmQ279CO6VDv5c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CY8PR12MB7564.namprd12.prod.outlook.com (2603:10b6:930:97::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Wed, 9 Sep 2026
 13:55:18 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 13:55:18 +0000
Message-ID: <84497e1a-7e07-4c56-8996-45d2e897af38@amd.com>
Date: Wed, 9 Sep 2026 08:55:14 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 4/5] x86/sev: Add support to perform RMP optimizations
 asynchronously
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1788296083.git.ashish.kalra@amd.com>
 <a31fc8c6d3f6c6bbe50dc4542c7091b0899d3e1b.1788296083.git.ashish.kalra@amd.com>
 <20260905012945.GPaptwicVjJ-SwXYzl@fat_crate.local>
 <4b940989-1c27-49a5-8112-d9f991ad1d48@amd.com>
 <20260909015228.GBaqC73LJDUow_Xu6v@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 xsFNBGnyeG8BEADrp4EWc3KHI3tz7Lnw4HgRJRG6U+IJKAp6EBnQA5uimlJspSAr+jf23I2a
 T0mr1uiTnZG0JkfgFpTgwBYcR+d8J96WP9LDeId9z6R7b5jyB64fhYqX8Hpich3lon2Woijn
 azEZ++sSUtAU75m2j9ZE6lkkPM2Ti9YWSBsSg92KDVVROXLO9n6U80lzudJrKAKHE0/PagzV
 D5gjV/s7lb9PX8khKVK3ockGRuy97lw2mAcw17EV8GE5cuToOOzpP8ESXBt1g7xoXVcbHYol
 yuX1ljHEfqy7cCtTsBk1+LzPuhZ7532MIfVmFtDcNUSwCGeGgwNRZno7lAJ9xd6fLkZPTEZ4
 UNsaViyzmJ22P7xMiZqXWQWSk1LohnGhZZdTaIwidWT12c8RX+qVUCzesaFXGqKt0PNTipTp
 L39iEZO8m/+lC1BmTo0EoYtsNfrlngwNPsSU7rtd/t00RuW4YHhXALT2JUbulLCHGK1w9isH
 E7dJXprYjUiZRVF3SaeTF4zg5AzkWRB+0yL2KzWQPumDx1gscLNFev8J1EbdrYClcpUuNxKG
 MMG95wPqWtZm/HaNyG08alXDZcnq8hhxA7AbJLnPYpqWd108p0qp3Vr0UrvuekBKZ6Y7be+m
 Hb4A1xRX3hE2kB971lsVp0lXSEGFHB9TJw7FH/S8paITH58y4wARAQABzSNBc2hpc2ggS2Fs
 cmEgPGFzaGlzaC5rYWxyYUBhbWQuY29tPsLBkQQTAQoAOxYhBOnNssdBmZnznITYhaE6KKJw
 lji/BQJp8nhvAhsDBQsJCAcCAiICBhUKCQgLAgQWAgMBAh4HAheAAAoJEKE6KKJwlji/q7AP
 +wfg5wOWq+f7eB3uh0agX5Ax/o5r5hlK0EMyl+srJ4jc+NmNKKuVPwx0EwZEpuEcbDLlQuO3
 JIyi13wm6n6FvIBOCfWjvndpaci1QGTMtZDnxueXM8UeFST3KjIEWFXbvgiAyiZBE+lHaSBp
 7UfAL19icIomKdCVCRtnqOsTvv7mcyPL8qs+OAOu8akvp3NlGsqLrkSB/YTEBKmh8oOR0aXz
 4VBIHpfTIppIu+F5l5PxOQGwNv/AfQ/oN+Aeo+o8i3s57gViqP8uVlVcI/vi1S4hngmc87Ah
 3p7KdbrxxPzahD+p1fMXsCwEf0dyJIRduDgAkpktmSLoRzBGkjtOX5nvs75QgA3r0WsvcfxF
 zly+nnhu2GsptY+uu/ZzW6PCz6p0pHMiDfPAL1cfizY8eTMFJN5fnOW9rwXvKbM+DHbowfkw
 NtF0DecH3qjmqAzGg2srE9XJxwOotS1JgeBp1TZsah8pXBaY+Z7s1iaY58H2TrdiDbz88DD+
 TGX4ZHPjocpqeUuwxn7gTCKQq3K1fjt6IKY0A1ocxQEK33pjQMRTJ8lwy4z37V6EohmvCs9w
 5qyvI9D1gnMnFrqpbry1Jz7z1HB4sFFYxIxyMh86uOcUxGmHRrCiII3YqiSmzizvq4aUmHxd
 YE1Wy+pKx2HVobhnuKIKoSJj2JgYV0+O5dk6zsFNBGnyeG8BEAC+BGciGUt4ODNq38ouK/6E
 jlkJPpnxlksBhlhwce/p1vvARFceifVbawkM8ePHyIXrzxho0PUDjteGFFDjP1o/N0rQzgbf
 0INfkbJpHME+SYETxrkm+j9oe8DiHXZhdatY5rupZoypodNQJDD1G/HoT7bBQxPj6xDBgHWH
 OyZbg1jjQXSWESgVX118uiQ5M9RdO+gc/YGLt5FDvN892uWs8899QBm804SdSlwkZGMKXZXv
 12qKw+swQoVzBdCqSLOOtIhGevkl6Ul5+N8iT7xeKMVZffAxkz7DF1yDovhJhrYtgKyUMQqW
 qCINhtp9wHvPt+wfutzYsCLVJvVLMIj3fPtfYBSPXQu2FP0z2Nx6oUxQR/LjilP4UezSdXt9
 WWpb+mvDLmelNuoA7WUxRauQBKu6tR1zoFl3zTdW4ZiSqZRgKInSfaVhINUMv8gqcLlAzkVS
 seOwRrwNDUosSW3gVwj28m/T9JSfGR62i58WmH0sFQG42yuIbq/uE4crf2oQDrpFNzTJgx6+
 Ede711weViGHEQz5vsgERmQrJDddRTgl/SlGtkAYNpVFJgYV2N/jYjiz98hgE2MYgZ2Kd8WL
 T8dvswsQguvkDMpWJZ2BunYhRLGIpyVDhepu05qyFuNYA50GX/qcj7POBSEx/6mBaIQC7oXI
 ffsirWGyL5WEVQARAQABwsF2BBgBCgAgFiEE6c2yx0GZmfOchNiFoTooonCWOL8FAmnyeG8C
 GwwACgkQoTooonCWOL/tdA//RIcNr6dB4ZZaKWDe5SSw0KD7hKExIIiBkxIv5XILcazPK21x
 LlDbXUHxWWaG+9wezceRRBe3GjRo2aKEpQzuAOgR5Ix5tRe5yJAFozO/CCGixiBzQ2I2TGIv
 rp8xZqqvmgogckqz3RE9Rx5VF7bqKriuGbF+WciPU6+YSuN1rH+esS40yoFu2skbYAMfm+Av
 AvEMDAmkR1o+weVZZAZMjm+2ZpCm2xXk5bjAqPQ+GoH70x/kPVv+TXjTN68xIjmP6gwA7c1P
 qozwWzaA2Q2HO5D76clT3tmHbtzMuYt3cfwbWbCpNaqycaHvktATiRjy60Bz9FvRL8cMt0+4
 jumtJoa0nAEmx88QzaMOK3QDW6KoDKzV8bqAHBPtrwH+jhOKId07yHmWCZxIGJAkhwqsdEx8
 bXpP3nTer40r1tvds54lxhKxOlVvf5iBoxa3kC8f6cTNJeGm5ettvD5iFSR+fwAUDEyZEtxQ
 f3Brs3CLkBfijS0zCw9rWqlZJGSst5xwV8UdfppsPWkU9lAUR8UZFsO+g1xCxtBc0nucygzh
 O+mvU01WFeZGTnW7INdP+eDIvj4XYmVSjwCSNvDphJkPccAn2KFcPxYh8PJAqCDw++nfNDrc
 BXA1uh2XzCnnzbc62A+AjwXB89wvlctBLptKlnKBVtrsKEFIoLugtmfIsa4=
In-Reply-To: <20260909015228.GBaqC73LJDUow_Xu6v@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::18) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CY8PR12MB7564:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b20ea89-fd67-4cca-9674-08df0e79fb69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|11063799006|56012099006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	g4xyY91F2+ujkDXBfAVF6hjvbkUuZ/qwKXg9qPeWIKenEGeVHN67gfrfi8I9YJX9Msne6HKgw77z+fkSso3WhOUh28ZU+hLN+Hb+E5lYsg79r1aHBldHqRzXIn8JvJMObhBh95JsGPCir6rx14oaD+t4T8IG32KQ8XOvFeKtDE6Kod5WjqBXr0/NLDRIYlB9XhzuPq4VRazLumeTLjEIS8vVYvD7oN6OLfHDZhhDhK6n7MX9LAqZCZdXA85WS4JtmJAklC2rAsmTEZLnPMMYzQtDc7vHhyFL0Ql3MLjWFQifsOAyhbHIBtRQ72BFSIxhRTjSCOIQ8VGdsDTUgU3FAV0pZJ8LzAw2KYUGXHZ7BLB+oj8mGILlt908N5ptsVFX01J1I317cCruV4/foLcyVCR6M0mtpo+Wa1kQNva6fuzjSs0Dme91OtTAbiRRXIYWTIYS9P9zU6xMWFyA8O+FKQl1sT6E/bAUncQfS9pUdft6Qy9/++URsvidTDWs+0oODpbSDmr/PM0AMqFofIzc+iR3JXNn/I6G5OSnjemxHlT6Yv9AwF8nAlVQ/IRVpJs9cf21q1c8zMvL5cFPbK2G2GCKs+N+W00NXPaDOdT5umSub+jnWbIb9blaRPvlGL5+
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(11063799006)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFlWM0puUDZJV0dKQ0JmcURGcXpBSlFrVEcyWEFoYjRCRlk1Mk5HazZ2RTlH?=
 =?utf-8?B?SUhzOEdXYlp3aVp1MWQveE51L2NQUXkvMEFMQXBid2luN2RmNDJieHZoSDRU?=
 =?utf-8?B?eTU4UExvSFhCbDUrNTRjZklNRnBrY3VLdW1raUtvSkNzWGxVbUZ0b3k5Ri85?=
 =?utf-8?B?enkybE1HSkthN0F4LzBmUnpvQmZZanBkeERnVG9LODhOZGlIdFBhMUY2T3VW?=
 =?utf-8?B?T1pmaWh0WHcxN1VhRnpFakpkb2tjM0JqNk1TNnhzaXd0SmQva0JHKzB1ODFK?=
 =?utf-8?B?L0c1dGJQMnlzUFIybytGTmZjQ1pHVG1qY0oxT255UTJ2WWVXLzdQWHUrSG5O?=
 =?utf-8?B?U1p2Nkh3N2FFQ0pKcURsaEd0TEZIZDBpcTRCNnk2SnlObFEvVnJLeFJ0VUdV?=
 =?utf-8?B?SFFhOXhFbU5tdC9vaTNQUEdtdnhqTm5tRUN2cEtxbkxpMS9tMm1GeUFXU1N3?=
 =?utf-8?B?cHZRdFl4bVExbU5JTDhVQ2xIMVQvQUxHSWtuOWQzTll4UnFoUGZxOVBYc2VP?=
 =?utf-8?B?dllXS3NkNkNCdkNLTCszNm5Cb21kS2JXcmVhSkQ1RWJJVmFOTEJtd0ZGdi9J?=
 =?utf-8?B?MzJRbE1VYzR6bi84cXlnSlRTbTlsaFZETVlmRUpFZU1HbTNYMVkwN1JJYlkr?=
 =?utf-8?B?WUIrRkxPRU9Vc0xqeWxMZnNVR1Qyem4rRm1udFhkSThBWFUvcEtiRkhpems0?=
 =?utf-8?B?MWdPUTd3SHBJd0JDeGQyNitLbkd3YkxucksvOUhTVmxoK3FJNkdaZ1JDSHdU?=
 =?utf-8?B?Unh5NUFFVExjd0FxbTFTOXF1cTlqSFV6bFZWd3Q2WlYwT3ZJZ3NxdlVPUWEz?=
 =?utf-8?B?UWVKL3lhcVJwaWxJMHpqTHkvTS9PN01YdjZ2bFdZeUJ2RzJkQ2pOZHJQRWdE?=
 =?utf-8?B?Qzg0SUFEZm5lUm5DaDNuSkc5M0doV3ZTRno5L2Z5UmdPNkdJMnl1azJ1bDQz?=
 =?utf-8?B?T3N6eFlkT0ZPSjk4dkd5WTFsVnArenpXZHUwUlBjNVY3VFpLWDR0SEl2TnNk?=
 =?utf-8?B?bld2Ri9hdTBaUlJuNUZQWU5aS1hEMkFiaXFQc0dPTExwRHF4MVBic1BOSGZr?=
 =?utf-8?B?N3I4MEszaHJ0bWVNWmk0VlJ0NnJOdmVhS29uaXpTc09yQk5kTmljbHhoVGhP?=
 =?utf-8?B?VkhSQmRCWHhTdVNrUWt4aGxNcEs0aE1udGZGVGtlSWVSS0ZaYlZJc3JNa2py?=
 =?utf-8?B?dkoyOU5pb3p5RjludVM1Qkl1VGlXaEFlNThDOStWZ0R5U1pla09rNzZ4WGV6?=
 =?utf-8?B?eGllYjB1SDY4WnVjNjNYR2VBMTh6M2U3WGtwbXRzbnQrVHFBbVdZUXdWbGJX?=
 =?utf-8?B?V2dreWdwamdmbzNuTzRxeC92ZjBaZ0NqR2J5R0Fpa1ZZYjlhcHF4bUFvMGtL?=
 =?utf-8?B?Ti81c0pPR3FEdURRL3Zsa2ZvM0JIUzRsVTJobjhwTCtPVExQNHZXR3JlOEJk?=
 =?utf-8?B?VkE4TXVrMTJNdzNLZkNFVlNaYWFBeG52cndaSDJ0RWdQQUJlUjZuVW5ydS9a?=
 =?utf-8?B?bjZmZnJjcWdVRGRvT2ZLaS9nSGY5OHc4b1dyWTZBMDBKb2dlRExSM0FFczYz?=
 =?utf-8?B?MVF6VlVtMDdLQm4za3AvZFBGb1l4TWpETTd0UVdWL3R2alRZczVUWjVMREdr?=
 =?utf-8?B?VlZXUU1QSnBSNlBIZzR2bEs4Qy9HSjdVeTVOQ0t1VEVtRW55M2paZEoxYlBn?=
 =?utf-8?B?N01YaWkvMnJ3RjJVOEhDN2p3cHA4d3hiVDhyVDUyVExHcUdBMElCRVFDRUF5?=
 =?utf-8?B?KzFlTVBwaDdhSThPWGFJKy96cFFxRXBtSnhId20xaElNN3NXSndNOFJkd1BY?=
 =?utf-8?B?cS96UFM4RzFWNU1OVVhISmhmSHlZcy9PSEZxc1NyWjNsOGlaS0hDV1gvVFN3?=
 =?utf-8?B?a0hLSHJyZGYxMjJoN1Iyd2hjYmZEN2o2TlE3NHRwcHdRZEFXRi85M2UvM21m?=
 =?utf-8?B?MGxGSG9LTWpiaDZOUXU1Zm4wM3dkY1VneHBOaXJGTE5kV0kzaEh6Q3VQYkxI?=
 =?utf-8?B?M2szb3M2WlRXVWlkdjJ4bEJQWjBTeEtmWm1PZ2JBSDBONlRVTWZVNUFXTmZq?=
 =?utf-8?B?Nnc1WHZJcE1leFlGZWtBbGI5NmpoVUgzRkJ4WDRpMWF5ZzFlRlBOSURESTh6?=
 =?utf-8?B?MW5kSmJyQmt5NGJ0bmNMSHZ4Z3QxY1Y4Z3JkVit1TW9oNnN1RkpHdDBRWGNl?=
 =?utf-8?B?VVIxTnRMZmlqbVE3eXE3clhhMkJCRTRoWlVoZGcvL211OEVydHkxVDZGeHJx?=
 =?utf-8?B?OEVQaEQ5M0UyZS9MZHpEMHlHaHhGMEp4dk1GMDcyaGxhKzNobjFyalFjUTA0?=
 =?utf-8?B?N2tVKzBmL2lRbzlQalVjMlNhLzNBMjVGZXcyL2Y1ZkxuaVgvMzIwQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b20ea89-fd67-4cca-9674-08df0e79fb69
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 13:55:18.3734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: osurUqZ5undI2Y098eokxCKp9UwZS3xyScA6iGm/+dKRtXmJHw9ZXbn63qdUb8LWCGZkD9HzmIn63rGTuj4R/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7564


On 9/8/2026 8:52 PM, Borislav Petkov wrote:
> On Tue, Sep 08, 2026 at 03:21:31PM -0500, Kalra, Ashish wrote:
>>>> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
>>>> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
>>>> Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
>>>> Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
>>>> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
>>>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>>>
>>> R-by's need to get dropped when a patch changes in more or less significant
>>> way.
>>
>> Tom and Dave gave their R-by's on v12/v13 series, so probably i will keep their
>> R-b's.
> 
> Tom gave you a R-by on v12 before I asked you to axe off a bunch of stuff from
> that patch. Dave gave you a R-by to this revision which is still under
> discussion and you wanna keep it regardless.
> 
> There's a R-by Ackerley which you carry at least since v5:
> 
> https://lore.kernel.org/r/6f1ec3d8ebcf3aaceccc099c07d0deb545dd4ab9.1779133590.git.ashish.kalra@amd.com
> 
> to which Ackerley is STILL GIVING YOU review feedback ON THAT SAME THREAD:
> 
> https://lore.kernel.org/r/CAEvNRgGfyb7zvZ1u1j7YLomD%2BJdAxnVW36gtvNG9gxgZ80vMyQ@mail.gmail.com
> 
> and yet you're still debating.
> 
> From where I'm standing, it looks like you don't understand how those tags
> should be used.
> 
> Do you need to go refresh up on the docs:
> 
> "Both Tested-by and Reviewed-by tags, once received on mailing list from tester
> or reviewer, should be added by author to the applicable patches when sending
> next versions.  However if the patch has changed substantially in following
> version, these tags might not be applicable anymore and thus should be removed.
> Usually removal of someone's Acked-by, Tested-by or Reviewed-by tags should be
> mentioned in the patch changelog with an explanation (after the '---'
> separator)."
> 
> ?
> 
> You're using Suggested-by tags also willy-nilly:
> 
> "A Suggested-by: tag indicates that the patch idea is suggested by the person
> named and ensures credit to the person for the idea: if we diligently credit
> our idea reporters, they will, hopefully, be inspired to help us again in the
> future. Note, this is one of only three tags you might be able to use without
> explicit permission of the person named (see 'Tagging people requires
> permission' below for details)."
> 
> So all 4 people have suggested this patch?
> 
> No, ofc not. You have simply received review comments from them which you've
> decided to integrate into your patch. This doesn't need a Suggested-by tag.
> This is normal patch review process. You should try it sometimes.
> 
> And this is damn well documented but you're still debating.
> 
> Well, you can debate all you want - those patches are not going anywhere until
> you do them right. This is solely your call.

Thanks, Boris for the explanation and for quoting the documentation, I'll get these right in v14.

Tags: you're right, I was crediting reviewers as if they'd suggested the approach, when they were just reviewing.

I'll drop the Reviewed-by tags that no longer apply to this patch -Tom's (from v12, before the rework you asked for) and Ackerley's
and note the removals in the changelog under the '---'. 

On Suggested-by, I'll keep it only where the approach was actually proposed and drop the ones that
were really just review comments, including my mis-tagging of your own feedback. 

I'll apply the same cleanup across the rest of the series.

> 
>> So the fix is: keep the setup allocated once, but make setup always
>> (re)program RMPOPT_BASE — then we never need to clear it on disable, and the
>> cycle case is covered on re-init. Proposed fix: 
> 
> Yes, you basically do the *minimal* work that is absolutely necessary and
> leave everything else untouched because it is unnecessary complication to all
> the code and if one is going to toggle SNP and hotplug, then one has bigger
> problems than some leftover facilities.

Re-init / hotplug: agreed - I'll do only the minimal work that's
necessary and leave the rest untouched. Setup programs RMPOPT_BASE once
and simply re-arms the pass on re-init; the disable path only cancels
the pending work - no tearing down the queue or clearing MSRs/state.
And I'll drop the re-init reprogramming I was defending: as you say, if
SNP and hotplug are being toggled underneath this, that's a bigger
problem than some leftover facilities.

> 
>> A full‑physmem RMPOPT pass is a warm‑up scan plus an IPI fan‑out over up to 2TB. The default system_wq is per‑CPU and concurrency‑managed,
>> a long‑running item there runs on the queueing CPU's worker pool and can stall (or be stalled by) other work on that pool. So we wanted it
>> off system_wq and use a dedicated RMPOPT specific workqueue.
>>
>> Another thing i looked at is for long-running unbound work, probably the standard shared queue is system_unbound_wq, which is probably built
>> for this use case and won't clog the per-CPU system_wq.
> 
> You can't:
> 
> system_unbound_wq = alloc_workqueue("events_unbound", WQ_UNBOUND | __WQ_DEPRECATED, WQ_MAX_ACTIVE);
> 								   ^^^^^^^^^^^^^^^
> 
> 	__WQ_DEPRECATED         = 1 << 19, /* internal: workqueue is deprecated */
> 
> So if you do an unbound workqueue and then block migration around it, you're
> basically doing a WQ_PERCPU one. So why don't you do one of those and drop the
> migration toggles around it?
> 
> All this talking is to get you to get the hint that *whatever* you do, it
> needs to have a good comment above it explaining why it has been chosen this
> way. Or put that info in the commit message.
> 
> So that people who look at that code in the future, can change it after
> knowing why.
> 
> And you should not do excessive commenting - it suffices if you put a couple
> of key comments which explain non-trivial things only. The rest people can
> figure out by simply reading the code.
> 

Workqueue: As you indicated system_unbound_wq is __WQ_DEPRECATED, so I
won't use it. And you're right that migrate_disable() around the local
scan makes an unbound queue pointless, so I'll switch to a WQ_PERCPU
workqueue and drop the migration toggles. I'll add a short comment on
why it's per-CPU (the warm-up scan runs pinned and primes the shared
RMPOPT table so the on_each_cpu_mask() fan-out is only cache hits), and
trim the redundant comments rather than over-commenting.

Will respin with all of this.

Thanks,
Ashish
