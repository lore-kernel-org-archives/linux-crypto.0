Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=40.93.196.67
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793664464;
	b=D7tjlfPTi+5I6ZQK1qnOWt3tbKxyM1rp0tRLjrDEkLLlDiEJtwfDsEbLRBfQxy6QgojM
	 4stDjCAbDAB49Y8qwHmuDY3PnjI2g+jKCvd2kR9EjJo8yCCCuru77dkNyhHUh614a4Mw7
	 p7pyYoNJ2sE5d3GwbubHZ5QtaIkYA8p9kWW4HS8Tfppny2Zbock3HDP+0AqmMr1iDQUzJ
	 Z2SN0hnvSLi+1NPndc3df4FhbxT79Cun7oXprBX45x1TSpLnsTfrOxg4mdOABmYmJGluu
	 DcMxgBmX02+5PbTr8jNxhbdvIcLapM+h8vOoXiMkejavB6qy7lZA21MpbBAlT9h5VoQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793664464;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=qnx4f931yCHuVNIpF3TyJYIuJPwLd/bStE4QYZ0JF4M=;
	b=jwxXBTUmhskedgaFk7Cum3vnBiMAk3ewkVPQ5wW3vBbBqTE+rJVrIC++cFte5ytb9klS
	 iPOYWrduFU/J99aWj+4IEqt0tZhWlWm32yNfKHIiBlF4sO964taSo3JP0O/FQyMKB6IK7
	 U+iGPyBq9smhVpn/YEL0BNIet2P0EjS6+Io2saLw1QCLyqB1tg9Qvie8Kiag6dR6m6ZqU
	 Cj4+5nQV6YysLIQkQe2O4s310HKwjmuRo4zxF/HVMSVAYrXDsX705vaYebT37aDnA0HBy
	 kcFslLrNMaCLmsj8I7E5R6iIJXTcWGJnuBYnt0H4xRc6t13ipvp/tgxiv/HTm/OgPQw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=XuSMP7Kd;
	arc=fail smtp.remote-ip=40.93.196.67
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013067.outbound.protection.outlook.com [40.93.196.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBA1606A32C;
	Tue,  3 Nov 2026 00:07:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECBA1606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=XuSMP7Kd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ULXaD0faSCfsKvWAUHt5m88nTQNy9bspXnciS8X+/E8hx78vdM1a3gjISA74HNFTYK8ipLE1tQjAdzu4QP9B84mw8TMs9mPlkPn1hsoPoOzPzpw6lwb3Cu0wGiNyhz+5DfgDeNPiF88IN9MgkIgwJAcu34rgFNxN7ozrppvuXF82PX4t9DxeMfysPQYDKkbTYyC8hQ3o3gxXH+iJhNLDlj52gfsyLb4SAEqjq6BJOb3w5JwEz/D7/hzVDOB2QhBphQ3mpUlVo9bPIWpqqEha0S/6/NtmgwSMmrgOXVbIg0QINj7lldh9xH7BwKUSqKAtLxWJSXJiki7fGAJh3Dj29w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qnx4f931yCHuVNIpF3TyJYIuJPwLd/bStE4QYZ0JF4M=;
 b=CUcmOBP3RSuBy7lWWliiM5mqnuDEkOIgRt8ho+mMDNjwxiHfAndWvJd68T6rLYoURWE61jFo584IQxc/MD1s5ZGJqnnyOH4dk+M6D3PLNN6vlg59vrBxFpZg7wulLKeIrRmUeItUANGkb9yN5q/onh/EhC0lwMQ/IN7I1+YyzCblJkNg0L+mpuL+P+awxxgSP7hXN9z+/7x+aoVq0KvwCXgHKRYREBGdmNRXb7QtRNIYMSKqD/E7t8cKimTSPbW4W8NJoJwclwGGnXxOzXwpeypXBxeGIEFftoAHWb98miLE+vB/tkP7kG65I2vgS2cPe7G3HZVVoQn/Auk1Vil3ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qnx4f931yCHuVNIpF3TyJYIuJPwLd/bStE4QYZ0JF4M=;
 b=XuSMP7Kd0SWpuyMrF0D4ch+0bEbz+6RgzPqVHAhc0RV1Ey/0E1rjg6q41ay3UE0aQpR4ZgsY154QPhgxbxA0Rg6GSSGUl/1EhLZMqmx4EFblajlPYBKFAoHKvSXt5CvwWgVjJbqloGtYuXKCt/xpzXXIJrI5/1d6DZoLZFee02Y=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DM4PR12MB7622.namprd12.prod.outlook.com (2603:10b6:8:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Tue, 3 Nov
 2026 00:07:40 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%4]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 00:07:40 +0000
Message-ID: <30947e17-bffc-4c70-b19c-56504771c9fa@amd.com>
Date: Mon, 2 Nov 2026 18:07:35 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] x86/sev: Clear RMPOPT when segmented RMP is
 disabled by firmware
To: Borislav Petkov <bp@alien8.de>, Tom Lendacky <thomas.lendacky@amd.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>, tglx@kernel.org,
 mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
 pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, ackerleytng@google.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1793216372.git.ashish.kalra@amd.com>
 <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
 <20261102052841.GBaugfibOXxGorZKgq@fat_crate.local>
 <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
 <414b2fc2-a55a-4b2d-ac70-4def101c4aee@amd.com>
 <20261102144805.GCauiipTaEXcg6Lr59@fat_crate.local>
 <d81f6807-26ac-49b9-a205-c89c394ec1d4@amd.com>
 <20261102193116.GDaujlBJc3XjG3xzLj@fat_crate.local>
 <9ebcb83a-1c0e-423a-8730-eff6b710634b@amd.com>
 <20261102214343.GFaukED8ep3EMmQxfx@fat_crate.local>
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
In-Reply-To: <20261102214343.GFaukED8ep3EMmQxfx@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0178.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::26) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DM4PR12MB7622:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ef221f2-f07e-4679-40bb-08df393e7973
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|1800799024|366016|376014|56012099006|11063799006|4143699003|261028144727099003|261009223027099003|261026121527099003|261026140227099003|261022105027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	tUEx8n2zo/rNCFBXfsonsvJskQxo0rNZKABbRg0vnG3knUjgWb9aQotEjLjMWvXd+3IrMfbHU7nNse1MnwZrgQ+avuuap/9nLo7arKlPWwwXfu6iVFeLHj2BWbuL+9svSP8NOz08YqkktjBXgc8HrZ2MY1xp8yuf2msxI/FP9a1cJhUoh4/K1xdT8swZSVJmyL5HuM7yJADoPkQ6RWGbpZWw9U1IBlPnekW3URclpalOMS8zyNIKtQgZ8CAgeaL98f/S53JLR3lZnqQGRKq8dMzRORv/BXj/399NPyK+MuBhcIue/ok5xaslCPuG+AJQvP7kQ5n67W8gydxmfao6fvlZs4KI3rQ8itCiLgGbc/U0eerpS2PNAz8Ah4gYBb1+STjsb8x+qXSbzybhkimQHuKZ5ft7EwQX41H+9CswSTgon8AiP0volQVrolTqakvxQLFFqcBfkwxOXicMVTKd5B3jwfjHUpwmrGVuFMzWAsHfASalenB0oQudU7l/vkPaiFPgUO/itxI4AxUvfthV8yAzS3biOhFXZV+fyYHmMPmUf1hQAaZv+UkvvrTUX/mTu8ZgalZovEun0NM0ukfWGwWqzRipr9AHnVZl3lx5oS1pV/446XfVag/uRGvJot+koGtp1uyhc6QHtEpAycxuCBuSkTHpvW+uI8PRTSDK0UA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(1800799024)(366016)(376014)(56012099006)(11063799006)(4143699003)(261028144727099003)(261009223027099003)(261026121527099003)(261026140227099003)(261022105027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TDE1U2dVbEt1bis2dENVcGdNbHNKMHpCOTN6a2Z0TFJ6WUw0TEJveTRSYS9n?=
 =?utf-8?B?bkoyY3JXTEJZb1JRNi9qOUYrUkZ2NnVIUW1kU05FZDA2UTd1MHJXdE10WUdT?=
 =?utf-8?B?M0xvRzNTdG0vVnFJelgxYVdEOFZoU3pCMUpUVHREOURlb2xzTTYrM21oZndt?=
 =?utf-8?B?amtGKzNUVSsrMnpTSlY5V0dmb01YeVRCL091SEhzZDVORzhIWVM2REI3bjU0?=
 =?utf-8?B?RHNXME9hQjk2OGE4UlpoTHVQT3c2T2V6OUExMnBUQ0FSLy85ODJJQ0RQZzNU?=
 =?utf-8?B?Y1k5UVZianVJSjFmcEt4TWY0Wnd3QzZLRDFId0RjdE1QdEVJOEd4VmU4L3JN?=
 =?utf-8?B?VHVUNllRcG9SYXlXR0ZkZHIxMlNUREExRVBReDk5KzBYUEkxK2RJMjB2QVZF?=
 =?utf-8?B?cDdCOHFyUzdzMUdKbVBtRkFIN3F4U1lhaHlWS1UvRUpCYTRmaFNBU0xqWEZW?=
 =?utf-8?B?UEN5VmM2QkJRVEh2ZXMrU1dQaTV6WlJYamdtaDhGOHdMS1BhTkJNQVV6K1Yv?=
 =?utf-8?B?SGZ3OUMrWno2YVR5NDI2QmpBOGx3NW90UGFtZ09zYmVxdlpBOUdqc01kOUVP?=
 =?utf-8?B?WHptckhwa3BnUzdQdUhGQS9nYU9wQzNlZERVSEFXN3RRL1Q2Z05SOXNoZjQ4?=
 =?utf-8?B?VHIwZnkyTjU5K1F4NFROSGtXY29pVmFsUmJ2NFdRczA2RDlVdmRrb0FMZksr?=
 =?utf-8?B?YXBLTWU5QUg3eDlnbTduUi9FVzJwYjZQU0c4UzM5QkV6WGN4L2tDL0R5ZHpr?=
 =?utf-8?B?ckVxdGJBeUFqWlZlRGd2Ykw0Q1ZZVXRvZFllY1hhUVFiRFVRTDVZcmU2N0xI?=
 =?utf-8?B?eVpmK1d4c2xFWldVa0IxWEdLcE94YktNM1FKbzUvbHZiUFcwNEw1MUh5ZjNR?=
 =?utf-8?B?bUNnWjIzSGhLQm9PTDIzeXB5YVlMUnUzbEtGZWRQczBNd1h4VzEydy8wTDdu?=
 =?utf-8?B?MkFVUlM4bktPbEFUY08vbzNZaGhUS0tSMjd6VDhDKzlFTnE3RlYzUEhaV2pP?=
 =?utf-8?B?NFEzakVNbzJjelUrbC80YUV4dHdKU2lDRkl3K1ZzTkVFNVgwNlFLaUdJdTd0?=
 =?utf-8?B?eVFiWEJWYkJvaVlJbUhSclRiODE0Ymg2dzJ6VWFqSkJRU1QzT29iS05Yand6?=
 =?utf-8?B?Uk9FK1pxK1BxbHc1OGwwRFEzOHl1M3VuQnR4cy9ldndJaHdZak5IQVFlU0JU?=
 =?utf-8?B?STVzZW03ZFVRb1RTVWhDSng3TEc2UEpGc1huRUFnNnR5QVFCYnA4c0RsQlVx?=
 =?utf-8?B?UHRGVHpOdUoyaVkycjZ5dkNId1B0T29DZzdxcTAwYTBLWU54V25kcXlzRndy?=
 =?utf-8?B?bVdXV1h2blBFLzM5bmFYOWpnVHZkSWYzV2JrS05NL3czd3BSSkYrTnZtZDNL?=
 =?utf-8?B?MEJJcERMQ2xZbGhFL2hyK3EwZ1JMOG1iVGplK2tiRkpwaWV0Q0NNNVAzNTRE?=
 =?utf-8?B?eUNFSmFwY3RTY244dFphWEtuRFZVQmhpNitGcmNnM1ZjQjk3V0h4U25qczNn?=
 =?utf-8?B?Ym9adFA3WlZvc1QrZWNlbFBIb0ZXNHIzcnpRWENGSjlsNy9aVDczRjNXblhF?=
 =?utf-8?B?eCsrNmRRUE1uZ0FuNTZUQnJWbWFMM1R1anBrTDIycHdaMGs4Y0NlNDdUVnVv?=
 =?utf-8?B?VWF5S292dldzWU16Y3RDZjdHNGVuNGFPM1RqZUdDKzI2Q2dlY2FmU0lnKzRK?=
 =?utf-8?B?azBUSHphQVhPVU9qMHY4cVJPaU92WUc1VTgzRjA1WkFzbjBqTTFoOVhkTkY0?=
 =?utf-8?B?RU9kN3ZhTUVDMGVyRFE5Q21md1h4RUhzeXdxcC9kcndtTEhxL0pwblhYQ0hr?=
 =?utf-8?B?cVVXSjRVSmcvSTdOTDZldkJiTnZPUm45TXVxUTlkUXFNMTVmeHlINUE3eGFL?=
 =?utf-8?B?b3F2NzFaREt0SEZBVVcxUndWZHhhWWJpc2JZZVMvTDZkOUdOaVJORzFzcy80?=
 =?utf-8?B?bmJubnlnZVdESmMxR3RRTS95QXNQUjNSbXZvSGtnUlpLOFN4N3lBaVdFeXpy?=
 =?utf-8?B?R0NKVEplWjBuNzdpRDJ1TVlIRmdlSHNTZHEwLzVkSTNUeFdkWlBKNG9zWUdX?=
 =?utf-8?B?OUh6aGpSVXNNOEpPYkt0RUZHNW9YTlRMOTBUVkFONWRzazFOMDhzVCtZUlJL?=
 =?utf-8?B?UTNDT2ZGNE1vODdwdEVOeUhUcFRhTzk3eC9ZU0V1bHl5bWxaczc5NlZxUmQ1?=
 =?utf-8?B?eTJMSkE1QmNzYWJsajUrSjBuVEN3alU5VXppL1JxZ2xBZGp5R1RmWjhFR3Bo?=
 =?utf-8?B?TTNqdkE2Vmk4Q2FNVXpZcldlQnBTU2VjZUt2d2h5ZXc4WlBJSFJnS2w4QW1I?=
 =?utf-8?B?VmtjdDZNcUpPUzFtWmZYbkk0R0xjNkt4eFF1OGljVE12cVVJNWhhZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ef221f2-f07e-4679-40bb-08df393e7973
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 00:07:39.9759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OLLE20TMilKQ+i7l3eQszrHJadVDftqKkDUKPFazqlZtM2tVvaQbpacq7JPOgOZ9fxTMUG46Hec4erpipbREVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7622


On 11/2/2026 3:43 PM, Borislav Petkov wrote:
> On Mon, Nov 02, 2026 at 03:25:52PM -0600, Tom Lendacky wrote:
>> The current code clears X86_FEATURE_RMPOPT when
>> probe_segmented_rmptable_info() fails. The above code doesn't.
> 
> See the hunk in cpuid-deps.c
> 
>> But since SNP will be disabled on failure of snp_probe_rmptable_info(),
>> I guess it doesn't matter. In which case you can eliminate the goto by
>> doing:
> 
>>
>> 	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
>> 		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
>> 		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
>> 			return probe_segmented_rmptable_info();
>> 	}
>>
>> 	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>> 	return probe_contiguous_rmptable_info();
>>
>> Which looks pretty clean.
> 
> Yap.

LGTM, tested on HW.

Thanks,
Ashish

> 
>>> diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
>>> index 99801e844b30..acbcec394ef1 100644
>>> --- a/arch/x86/kernel/cpu/cpuid-deps.c
>>> +++ b/arch/x86/kernel/cpu/cpuid-deps.c
>>> @@ -93,6 +93,7 @@ static const struct cpuid_dep cpuid_deps[] = {
>>>  	{ X86_FEATURE_SPEC_CTRL_SSBD,		X86_FEATURE_SPEC_CTRL },
>>>  	{ X86_FEATURE_LASS,			X86_FEATURE_SMAP      },
>>>  	{ X86_FEATURE_INVLPGB,			X86_FEATURE_PCID      },
>>> +	{ X86_FEATURE_RMPOPT,			X86_FEATURE_SEV_SNP   },
> 
> This hunk.
> 
