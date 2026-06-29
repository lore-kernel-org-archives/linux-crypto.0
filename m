Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012026.outbound.protection.outlook.com [40.107.209.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC5713635E;
	Mon, 29 Jun 2026 03:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782702728; cv=fail; b=NYCsQIODjXyvumF6TowKjAu/3UDm51n+1C/TMGm25Of3hoJN1NkG824LpHNE9g4wASeJu4fomtr87MA01gk+z+hzdn2pgU/1rfvjGeaIWCUhHXHxZDT3G/c8u+yz4sf6rBc/Rf2lQeTA59BYsQ99tmrZe2d7L4Oe3LfnQPtj9JU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782702728; c=relaxed/simple;
	bh=MPZQmF4uZXzRFCGfEd3+cwpc0viSyY7+q9s5QT/f8r0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MefI547ZUZXd+0nsOZOV4+La7+Gt7zfSX1aIWQk9OuluGv4rz7cOFJjBCE+0GmQuowQ2sBSrDL0v/WxT0Ly0v6uPOSxTeFusch+5FN5d1ge1QwJBOeK1pEbmTHPYrb1hYWhzuqQKMjt+pYnBjiMXoqk7z/7806PN1vWORFGKwQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JQwnNhj6; arc=fail smtp.client-ip=40.107.209.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JQwnNhj6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wjvddafg0DnAewFv+aO85bC3g/ZG4auwfBZF3oPytY+wYMl43wmdlwxoRQvaG4qMWaCj9PXABWbTKw6+6FxLlBjkzDaky5sZFnvKisUQWex6QPei6GK2QwT8qFuHGKsMbj/Me4BnvKyvWMJKsKMFUYIg2FZ2FwfKWyAKEB+H3tzCoklcGRK3F9l3y61wJoQpveI2SLW9Uxvn4PtDG4DXGGhrrymopORBS8znwjq4gBe7vt3eQ54TIJcHp/vbUcon2uSqYmAPBelWOxL4w82btEOc6XXbeBj3qzJEHKey+KlQmXnzevFsvBKT3cBuEV02LJEltkZuRIySlB4GBSnUlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XL7dWaXTcZk1r9nELZt9gEaPnC5pVpzDjqkTaCc0nLE=;
 b=K5KsatCPv2rCwu0WGJIEs7DzgkeK4JoK8vc7Ai3/Czm9NsS48hougH4wReq0qXL92PjgI0aG5cZSbVZUEV/0lcgg+8wsXbxabhR+zPtJBbA2QwmnF94kWC4CrvrGTe7FLGRRjZHF6YzOVzFnnxxIkQ9jSmB3Z++ojO9mOmAzeRKdeW6a1198xnZDl5WHp/kFb5rmzDvxEJ7K0B0G0qTHh057x7nI2ooi5zZH3J9KiYCaWOR4ppeFclrdHUgQyRjI9YSaDzFq4US4u+YaiBgzroS6wQK7V08Xvd5p8SRd7C5zyJCe0PPqoV5Weq2v7rlv7+omlyABg2/Y+6N8Ll3LlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XL7dWaXTcZk1r9nELZt9gEaPnC5pVpzDjqkTaCc0nLE=;
 b=JQwnNhj67JksWZ28etnadhsiN7zY8VGsRTsXsNY4ZzH2yALCGGcaGN25XoU1+OkqnQchnpcq9zt/KOlElsfnuccUgh6yAlo/SCixSCiL71g7ykgV29wSpBGgKw7wu+ypX3VNOv/ny4MoEz3p8tx+4lo/STR+RkV6Kk/lMshWav0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH7PR12MB8180.namprd12.prod.outlook.com (2603:10b6:510:2b6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 03:12:00 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0159.012; Mon, 29 Jun 2026
 03:12:00 +0000
Message-ID: <976721b6-f6b7-4808-944d-3d15411e1582@amd.com>
Date: Sun, 28 Jun 2026 22:11:59 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/6] x86/sev: Disable CPU hotplug while SNP is active
To: K Prateek Nayak <kprateek.nayak@amd.com>, Borislav Petkov <bp@alien8.de>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, ackerleytng@google.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1782336473.git.ashish.kalra@amd.com>
 <ba146ca15b7f76eee386c8c073fb3f1cc36e5781.1782336473.git.ashish.kalra@amd.com>
 <20260625150253.GAaj1DHZC8ULg6PzbI@fat_crate.local>
 <7c64d96f-f932-4db9-8119-b9e40d5b7fd9@amd.com>
 <20260626164032.GDaj6rgHq4xPd-qjvG@fat_crate.local>
 <9d019b55-739d-429c-bb34-ce792e8340b6@amd.com>
 <20260627044117.GEaj9UbSvTExfmFilu@fat_crate.local>
 <75a397c3-5251-45c8-8aba-a185685b382d@amd.com>
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
In-Reply-To: <75a397c3-5251-45c8-8aba-a185685b382d@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::18) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH7PR12MB8180:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b6dfc74-0262-4608-9d20-08ded58c2f9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|4143699003|5023799004|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	SmVX2v1lN8hKkK3vyRTu3gHDwdrVoke1PMhgA0jxR2y845ChtMbm/1xbymZv2Sz5ziaeWGB0BY850RL2yN1G3NSF235s4iKPx16kfgkPWw+aF3LLaoHuhZCg78niQ1L9M5F2GOhQ5A8/6AqUp3hlZ9anf3V0OOTUi9OCPBokKOtJf4TcxFqyRPZzPZip17Dv7zQtrGvsWYmrvav6Mn5NvfW0e5/kdWTWeWuyMmrUU61vbYgK4nTcGh0jkBydpW51ARZEbY7ubAYIuzmwyhyOIvtRUoLbslVwg79SlWf2txD+lL/+xvxrrZsXf64c/roOWvNSZd6vb2aRh0YlC81gG1w/nx0GnJNLBpZXYsLipX/Q7sUG3/9udH5hIMz0rgXx/ototOwqF3RDXVO4vG+9VQdYVojYp1pYaQKTOxxOVusmvxDKxZFa+xpNF9cFHjH9ukyCVwwWl4v+TPzfqF50ssViDhSztR0Vi0FFhfJiSHXrqtfHQ5U7yyM0Mv1ShzWCSDZxJipgjFZ2VrBksqIUX6/pQ5kvJwZNSKHKg8EfSYO58xGwVrEJSdGvq0lfQmwC7H3o5Un7ENUbe9Lbvq2XejVXJQgAXdPPReEahZCThZQSR0TmtjjT4YITmuot22yZ0W0xLp9iq6/85GpQn/swff5iL/oh19DB7qrTmxCgpsw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(4143699003)(5023799004)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3BialJLcmdueDV4Tnl1SUoyY05OQzExZDZ2N1RvRjVkOTBKVklqV3MyVnI1?=
 =?utf-8?B?OGlWRXE3eWRhMHlMTWhEUmVJdi90OXRidFRQN1NGeTlhT01XYm5IdUNKT3B5?=
 =?utf-8?B?YVNOV3FiZ0IzVjBtV3FjWElWalJHZGU0VjROUXFHenVOZkthZE9MQXNaSTJF?=
 =?utf-8?B?ZlQ2cjJSd21UMWhqU3JUSHNVb0RDemtqcG5aVEcwQnpnSXZGZlhnbkxGd0tH?=
 =?utf-8?B?TVVjK3Z2YlJMT3hTSTFFUkZQZWJsYnZFcXl6bnhUZXJ0bHlna2xRRDZGbDRF?=
 =?utf-8?B?THVPSzNteE92UGRrNEo1MVpyL2wveTBZa1VkZDN6OTFaZm0wNWMvNWRocFMv?=
 =?utf-8?B?cEY0OUpxdE9VckdDYWl0QjVYL1d1K0dUelZ2YmJwSDJwaHVsd2RTOERUdjdu?=
 =?utf-8?B?QU9iOHMrYzJMVUVFMHI5T1FCVU51a2FnNTl6MFB6NzJ5SkMxdmg1Z3graU9n?=
 =?utf-8?B?dHRERlpPSFI5UDVUblJydFZVWnFVUzBSR29iM1ZUOUFBSHYzRDliNTZCR2Zw?=
 =?utf-8?B?R2FlVXBhVlVvc0dxM2dnNlduS1JUMmxBZTRPSnZ3dlZwUjRQaUsvejE2RG1X?=
 =?utf-8?B?eVUrS29yNzdjUktzb1FCMTJUbHJOeXpYNXRQakRtRnRaWXI4NUJWRktXbEZL?=
 =?utf-8?B?cVp6eHp3NDExNnFyMUNvVEtpbEpnUmt1elFvcEJEQWxDTHJDV0Fldkx4Q2p0?=
 =?utf-8?B?blB3QlFONHdlL05QbDVONnZKVWd1Q252VFZSQitRMWk4WlA4SnFoZ29mRzM1?=
 =?utf-8?B?Mk1oME1XMUNrUUJZMmwra3p4Y0hSY083dUNvcS8yVWIyVTRuRTNWL2Z1WmxS?=
 =?utf-8?B?ZktXeHMvek5nZitOZjNrdk04R3V0K0toeHpYV2pCTjRlL242aXVDMlVXVkFH?=
 =?utf-8?B?Mm9NeXg5YjU3UXFvQ3VCQ0ovVjdBcTNpMmQzaXJnWW5XSkM0aWVpcnpTUWd3?=
 =?utf-8?B?WUIwbFcvOG9NTnNRaS9TTHlZMTQ0QWl5RmhFZlZSV0dVUFc0dFVTNFhMUm1E?=
 =?utf-8?B?U0ZnT0dIdnRZN0pRV3EzQ1FPY3RnZHVpTDNzY2JkSXRhMWk0M2pUZFJ5c0Vz?=
 =?utf-8?B?QkdyOEM3eFB4SVN0Z2pIbnpQMEFlQXQwa1hYaUpERUtIdEkvQWVoVjM1Sk5q?=
 =?utf-8?B?cFdsbVV5aWl5bGVOcmdwT0d0b1dGTU9GWll1NmtwNFhoZlJ5dkxYOElobHpH?=
 =?utf-8?B?dzNpbXl6RnlsV3MxQTZrcjlSYXV3TmhYRmVqVUgwRjdRK3R1Z2xSSkZHT001?=
 =?utf-8?B?eWptL1l5OUwxTEoxSm83UUdsMUNnL3JudkFuVi8vS3ZiOXVFMi9WeVk4TC9J?=
 =?utf-8?B?MG9hSk1MVSsxY29mcjEvN2JvdUFmVEVmWC81TTBVNEorTHBjWWtHckJzZFhj?=
 =?utf-8?B?NFFLc09XODdVZ1lKR21CTEJ6d1o4Zmx3aFlVaG9QZnhhZUlFSE5GM0Y3WkhX?=
 =?utf-8?B?aDdSVHcwWW1UeW9Wbk9scUtkWVVaTVdpTmxSMXUzRTFuRGRsYlZXRWU2S2Jv?=
 =?utf-8?B?UGFiWExyTHJjbVpRYnJsM2N3bk96NUpyOEFmTnV2dk9PdkN6U3NHaEpkbmFl?=
 =?utf-8?B?czNDWGs5aS9iYzc2S3Z2MHNydTlxOGN6RXE2YlpaUlA4L1BVYkZRUzV4TFMv?=
 =?utf-8?B?T1U0bGxDOUY4bXVXaHFmeVRjZGNrd2ZLQ2ZuOW44S2pteXc1bHRJKy9yZW05?=
 =?utf-8?B?Y253eEtWa21seEl5QStTWFd6NDY5UVE2TS92L1NjY0NWSWJ5ZHU0L2VlZGlW?=
 =?utf-8?B?L1F3RXdOVmc1clJUdlh0WUJUTnFuMDhxVWpvRTYwaTlBVysvYlU0a3lLRnFH?=
 =?utf-8?B?TUY0T0JPNXM4amo4ZndWSXRxZ0U3ZXVlU2VSTmN5RmYwampiY1Z5cEE5cU9S?=
 =?utf-8?B?V0dBdWhGQ2kyd1ZBUlBoK29jK1R4WmN1TGI5KzJzV3RidjN4cXRXYk5LcE04?=
 =?utf-8?B?MXpUZjdOeUpBMllOUDN0dDl0WElzRC9QOWQ1dUQ0T1R5SzNsaXY1SWtVTllI?=
 =?utf-8?B?SDd6dGc4K2FnNVlWTzhIV2FELytaeEM3dUV4YnZLM3VoY3RWdzJrcFdHelhl?=
 =?utf-8?B?WFBidzN6SDZoUzMranRxY0NVU2pmOGE1WUhab2JkTEg3cjZ1WFpBR2tIVjh3?=
 =?utf-8?B?MW4wSEJtazh1dmd1Wk50dkU5NFV2anB6VElsQVM2MHVFQkF2Z09VSkljcUND?=
 =?utf-8?B?NmFpUUMzOVVqb3ZXZWhvelFUckZHNENzc25JMlF2VXFJTiswVVg3V1JXd25C?=
 =?utf-8?B?dStkZTk4TEV3TzJOempVVi9ZU1RVb2dKdmo4Mnhnc1I2WWVxaWZyZ3NWUXdi?=
 =?utf-8?Q?oPei6vbltk/HKs70LM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b6dfc74-0262-4608-9d20-08ded58c2f9c
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 03:12:00.5742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KxrOU/iigHoh7YEl8rkFH03aWxANwONdWDTaV1VmdE4JpuAwIJJdGpA7NLgEdG9yt6QicOT7noKIB945yIYxrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8180


On 6/28/2026 10:05 PM, K Prateek Nayak wrote:
> Hello Boris,
> 
> On 6/27/2026 10:11 AM, Borislav Petkov wrote:
>> You could also block hotplug for the time being by grabbing cpus_read_lock().
>> And only when you know you are all clear to disable hotplug, then you can do
>> that in the end and drop the hotplug lock.
> 
> This is bad idea because it'll stall the tasks trying to do a hotplug
> until the last SNP VM exits. Instead of simply getting an -EBUSY, the
> users will start seeing a hung task splats in dmesg.
> 
> Also, since the last VM has to re-enable hotplug, you'll need a
> up_read_non_owner() variant for cpus_read_unlock() to unlock the rwsem
> from a different thread compared to the one that locks.
> 
> I think cpu_hotplug_disable() is the correct way to go forward but if
> you are not a fan of the global "snp_cpu_hotplug_disabled" flag, maybe
> it can be turned into an indicator like "snp_initialized" in
> "struct sev_device". Thoughts?
> 

As i mentioned in my previous reply, i have already removed the global
"snp_cpu_hotplug_disabled", the new implementation is flag-free, and
does hotplug disable/enable by following the SNP_EN state.

Thanks,
Ashish
