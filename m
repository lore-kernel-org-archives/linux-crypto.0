Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012041.outbound.protection.outlook.com [52.101.48.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D379A368299;
	Fri, 31 Jul 2026 12:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501446; cv=fail; b=Fq4+t2XXVulB60WcdtDKrMLF59PCAVbp65x79aeYEjIlsMzmP/E9K4fr/wMElcjjs44nvtzQOFaLTzFoPg5YOFdB5bskxZQ5kUud3g2ornZ1QDZ3w7hhg9atPRm9tQpi11ADoKLZTnhBpeNdUlJXcEiRdQ9BjndJo3c+E1sF1Yg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501446; c=relaxed/simple;
	bh=baqvbXmykWdcYvnmaTbpzjBQtRrsuAMwy3/9s+ae7Uo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tOzoXRs3ybol5Jk3OhGmx/MCBuSNGJeINl/LHTgjL/UQ2OeqtrJX3d/+IL0eCAOHDAN8ylgnhN4IwFtIxcZrvJUbUslXFjE00jYc5GDFoM7KS3kvy66daUIlGJdNUZkf7NEu2hMIU0qmcX5y3BFpNYCp7zopg4cFuqpo9Q7w3hM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Qo92x8pG; arc=fail smtp.client-ip=52.101.48.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Qo92x8pG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OYHOBIsBJmgo6egEXnJeRADOV+mig+zUaQmO3OenrujQmODTkNgu+hcS8kPOncf7Ph7xx5roulm4sL0q2GZgw4ZvIi45JLxUSWU966vyXuUIsj2+Q6OF1IXEi00i4bO33f9B5ZG78zvHHxxpBV6eCoKXxhOGXeJpYLH/nxBkh98nAA3OqMlM0meZx8v3/tBzUtoGsPztZH6QzxpM7XR28sIEx1dcDND/tJCuIMU0s19bztZFJsn+7+bOPlgyOWy3KsPgvkGFu6Ky0/aQ22dbPh1h08nHiZPBhnFKaS9O3y2o1GcPwz9JCGxpzO0PBO5J5FSYQ6aDAU94EiFdr87GKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDCRY6PQvC6I38Om+0zdG+0VFkrdKMHzFQfJPRcGWy4=;
 b=pcCmOl9lgmNHR48DapPaNaPrIDGVaBcY7S64debLnYTag8uJsYOqOMUCBT7lYjL6zg6x2eHkLyxT92I4EQ7+OmpW8j+OEQEa8TWMZVxbT3kBlCTDDlrgrjvBrPHKKUxcszUZ5t81nQ7vr27hQ2PLzsxkZUtFaQBvAoehJwBJDWE/C1fTuHPD+kjxFwoC+7qBCBdfWKlcuwUmKy53gHUWZiTZvjloyDcwmWoREmkCTcoY5eFkIlazXnPZBzWvO5jepFS9Wz/WtGGULFLb7n31SfQ/teZ3Ap3Y9dwZaKytu3DfReFJEU/ZQ0wqMVeqJW9SygB+GGY7JsU4HrnhwQP/7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDCRY6PQvC6I38Om+0zdG+0VFkrdKMHzFQfJPRcGWy4=;
 b=Qo92x8pGRUQ7i8OO6ZD5l3J824LoS2K4jd99kk0caiz5o/2dcwe3llF7qxp98NtA49CiOHUvqGdooGHjrMa3OWw0ozuKtfhIh+IH4PHIB73ZhbDBS8yJDF7p9zZHQESqgr7f7PF93NHm6r4oUVUTmNn9y22VbdLfa4xjyEYMQj8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA1PR12MB6436.namprd12.prod.outlook.com (2603:10b6:208:3ac::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 12:37:20 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0270.015; Fri, 31 Jul 2026
 12:37:19 +0000
Message-ID: <ecd09557-ed93-4d05-9850-d02c31900f87@amd.com>
Date: Fri, 31 Jul 2026 07:37:15 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 4/6] x86/sev: Add support to perform RMP optimizations
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
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1784844080.git.ashish.kalra@amd.com>
 <7f582569acea933c3045be604a81975e29b5ee2b.1784844080.git.ashish.kalra@amd.com>
 <20260731054425.GNamw2OelKuNhVwnrU@fat_crate.local>
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
In-Reply-To: <20260731054425.GNamw2OelKuNhVwnrU@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DSSP221CA0008.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:8:3d5::14) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA1PR12MB6436:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d0f0bac-33b9-42f7-d9d0-08deef007621
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|4143699003|6133799003|5023799004|11063799006|3023799007|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	yv/DR0Gzq/NfnMJDlVevZ3EijNSms31N3HyefZKeGSwec9l24gNgziJiHHj1NuS+Ru394xl2Amvjdekm8SeoPfjKZYVJAJ4A8Nm3QjxafU+RjS1AwVUu8VCsm1NDKueikE2SZZyD83dltigzdUBeIESaaUwU7EVv+qZqsiC3sG7JARMqKPwSRQy864vD32UQJdkpfpA5sX6jk/BqQPJFjfla6yxN6ZeN7wM/LBLB91kZMADoG0/INOU9w26M2zP064faEWhWbNXOZDbdmbhPGYGIXxm2t80HCDD43J8IHGtCyFIH37YEyIlT2iuvY6z5ywFRQrUvqvIpRbHYhKnFgtf7zybiASk/2OFS1Wf4n28oWP8PAIYe73sHTGhqOl/ePP0zW+gx5QqJl52ss7JjDLbf0lmr2E+uqsJBB9JPz7DxVqWi3X3SjfefItq0hzEUfArMFqb5wzB3E0z7Hq7Z8REre//8ZlEJ5h18aS+yCGj+DyczqGwWcg0/27b9h8b0lX2ySxoqEDOS4hsgxKjXCU6meFfhXJ9KJCdMP+K70UeX/1MVXO1w9MEwrnWQlgvEeb0qltbVJmrEWxcOn84eC4C3V8HoxHkgUhToyNsSgfuElDNhiV5hlBE5DQYpPJE8AzsBS+ZGZ3WZkEliT6+aw85CLBdelCTrHIxFlHzRDPs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(4143699003)(6133799003)(5023799004)(11063799006)(3023799007)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzQ3N3JSOVZYUkVVL3VlNDNQWnFVQmlqWkN3ZldXYjByR3JWelN6alhXWTBj?=
 =?utf-8?B?ZkUxMXJMNGxpcUhhQ0k3SHJNbnhFcHd3MnNrQmtla09lKzJlelNsT1ZjSFQ1?=
 =?utf-8?B?RWNGRFlSNnArVlh0Z2ppTzJaWEdka2ViTTJEVkxMQXJxUWl2VVVmNytUcm5p?=
 =?utf-8?B?Q09RVFRhQ01qeXBNRVRhN2kxK2UxVUFFR2xmd1RmUThSYWlNYW5GLzFPT2Ns?=
 =?utf-8?B?d3RZaHdmNW9VanRhQndvMWd1UXJHRmVSU1M2d0ZNbmNUZFMvQmlIKzB3emZG?=
 =?utf-8?B?ditZVHdweWNqL3IyK2RlWTR5K3MrTGlsZzk2dzQ0L3E3YkNWTXV1VmFmWmJx?=
 =?utf-8?B?MlJHZDU2SGxEbEoxVlkzTE5lT2Z4ZHhYZHBjcnpxRkFDVFNyaWU2YW9Ga1hj?=
 =?utf-8?B?NDRyM21QMXRjSi9vTDBXOXJ3bm9MbVBlT29sSHZNREtwbitQRnh4cS84R2ta?=
 =?utf-8?B?YW8wNGI0UWhIQ2M4L01UOHUrcGhCUFltczl3YjF2U3NHN0RMSFFCQ0pyVHp4?=
 =?utf-8?B?MXRhT2Y3YkxCZFBIL0J6Wk82dVNHYWlnYmc1Z0ZHVVM0Vk5sN3duR0lwY3NE?=
 =?utf-8?B?WlVNYnJ4Um1Tck41N0hqS092K0pvWnd1Ky8yZVVvckFlVkFEZXppckc4QXYw?=
 =?utf-8?B?OUpNcG1PMEs2ZlBYYzhGdnNhM0U5eUVMK0M5UWVVYTlyenlXV1V6RUc3NFVC?=
 =?utf-8?B?N2NwZU1BRUdHRStYUHpVRlFqUzZxMUVoSUU0WElBalpaKzltYitOSm52WHQ3?=
 =?utf-8?B?dzd6dzNnK0xlZWREbWtlcFhNYjZOcWVxQTN3Mlo0czhDZWN6V1FSVFladkRG?=
 =?utf-8?B?L2JtMGJIL2xUM3lOZHNMYnN6aGN0bFVTRmtacVBCWm9CM1E5K08wVGVDanN1?=
 =?utf-8?B?K1lLeHIrcjVnRWpHeGlybzFsUmlBSXNacGVMZ25lTlRTRHpDN3RSSnp2LzZB?=
 =?utf-8?B?UjBKVVUrNHJDaE1MSGYxbk0rZm01YjFiOC8weTdmWjhMYVlIV1d1dWZ0aXB1?=
 =?utf-8?B?L3RKbnY0SllyWE1wQmZCWGtORnhEZzBFZ21TVzRzMXZWVUVPY0Z1dHVrZ0ZS?=
 =?utf-8?B?cHQzY0ZtUjZsSmtKZ1VVbDdmZ1pOaEZGRTVzRk16SnJuNnJoT0x5UTJFRENr?=
 =?utf-8?B?ZWRtb0RDL1NMMmdOWFhJdWlhM0luL0VpWU5jSWIyUUYreldXem80UHF3VVh3?=
 =?utf-8?B?QVRBN1ViNElYT0dIaldlL2NicGI1UExSZGJOYTl2OTVMOVdVS2JOczZZdTAy?=
 =?utf-8?B?elZWd2VWbHVpM1UycGVKZ1lvM0M3ZDZuQ0RQR0JNR2Z0bVZhUThpT1R3S2lu?=
 =?utf-8?B?TVFtWTl6ZFhJM2VNY2ZaVzVNb2llaGFNaW1TVis5KzY3TW5aNStTQzRNVnl3?=
 =?utf-8?B?d04vSnp6clF3MExMYnF4bytZYlhxRXB3NDJQbXFZcmx0Sy8wZU1hTnptSUZr?=
 =?utf-8?B?M0hnejRrdTdpQ1hGcmRXeVNsYzNMWGFPZGtUVWw3TTVPUGlIcWxld2ZvdU56?=
 =?utf-8?B?YkpsdlAvODBTbk5JVHdxZ3FheEtMUWhqclAvVHdEaFFpMGZUQm94cTBEcFBR?=
 =?utf-8?B?M0pTaVhqanVFdVNzejhaQzVjcDZ3OHJGVUJscG5RamNlWGM3OEd6N1MyWWhN?=
 =?utf-8?B?eEhocVpaM0JHVXd6QlBWVWJtWnlUSVY0U0oyVDdZQnpGRi9lNmVSWnVMNkZC?=
 =?utf-8?B?dzBiRU16NnNNTFB5TThhM3NpUHJiZnJVT2wrUGphOVlmaHp2NkIvQjNrQjNI?=
 =?utf-8?B?RWJ5a2FuTGF6Sldpa1UxYlVxQWdkcTFnYjMxQ1R1SnZ4ZGQ4ZXZMUGVCM2Fu?=
 =?utf-8?B?ajlhUUhRcHFUTnVmUHRoRjdXbXZ6UXUvSUxOcTM5Wkg5eDN1eFZ1N2lXem1y?=
 =?utf-8?B?SDczNzlXckRkNTFNOFg2TFVQQnNtUWgrZGVMZDFaUThkUUJRcEF6ZnNwVm1j?=
 =?utf-8?B?c2RCTDhpMTZvVXd0c1RVWURIU2liWlRDQVRXZDhEUVg2OWFLV2h3R1lJOW9v?=
 =?utf-8?B?Tm1YVHVOTkQ5TU9GN1RFVUxCbjdYVURJSGdVTUloQmxyalEvZ1EvemNSVTBE?=
 =?utf-8?B?MmpiT0F0ODE1SmRZYllFRWpBMDVyaG50R2N5Wi9Gak9EdVdFa1BWaHZRVjdx?=
 =?utf-8?B?SGE5ZnNYOVlHb3Rlcm15bjVOSEpsU0NqdUNKL3l6M0ZpKzNGYzE0aEEzR0xM?=
 =?utf-8?B?TnlCdUdjdENJdW1SNFlhVjQ4YUc4QTV1NGJOYXNQaEp4RjZpYVgzVWxvdzB5?=
 =?utf-8?B?eVo4UkVIR0NSaUlzdEN3dkNUcXlGSEdKZ1lFUXNmWjdZQi9kaHFQVDdKNVVG?=
 =?utf-8?Q?F6MXnYcl+MNwJUdY8j?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d0f0bac-33b9-42f7-d9d0-08deef007621
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 12:37:19.6697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CEyJqkrSA58EpkUqYumk8nj5HRDiRQU7zkWvKAWTsYbspS9NfyZCfSxxmWPMpIx1tkk61Ndr73vaYmZ/Lie8TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6436


On 7/31/2026 12:44 AM, Borislav Petkov wrote:
> On Mon, Jul 27, 2026 at 07:05:29PM +0000, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> When SEV-SNP is enabled, all writes to memory are checked to ensure
>> integrity of SNP guest memory. This imposes performance overhead on the
> 
> s/SNP//
> 
> The checks are done not only on SNP guest memory but on *all* memory, as your
> next paragraph suggests.

Yes, the checks are done on *all* memory but for ensuring the integrity of SNP 
guest memory, so that is what the above paragraph is mentioning.

> 
>> whole system.
>>
>> RMPOPT is a new instruction that minimizes the performance overhead of
>> RMP checks on the hypervisor and on non-SNP guests by allowing RMP
>> checks to be skipped for 1GB regions of memory that are known not to
>> contain any SEV-SNP guest memory.
> 
> Let's tone down the abbreviations. "SNP guest memory" is enough and let's
> stick to that.
> 
>> Add support for performing RMP optimizations asynchronously using a
>> dedicated workqueue.
>>
>> Enable RMPOPT optimizations for up to 2TB of system RAM starting from
>> the lowest physical memory address aligned down to a 1GB boundary at
>> RMP initialization time. RMP checks can initially be skipped for 1GB
> 
> Why "initially"? What are you trying to say here?

"initially" meant the init-time state — before any SNP guests exist, all eligible 1 GB ranges are optimized — and the
last sentence covers how that changes as guests launch.

The other way i can put it is: "RMP checks are skipped for 1-GB ranges that don't contain SNP guest memory and 
as SNP guests are launched, RMPUPDATE disables the corresponding optimizations".

> 
>> memory ranges that do not contain SEV-SNP guest memory (excluding
>> preassigned pages such as the RMP table and firmware pages). As SNP
>> guests are launched, RMPUPDATE will disable the corresponding RMPOPT
>> optimizations.
> 
> Because it will add pages to the RMP table?
> 
> This paragraph needs clarification.

Not by adding pages — the RMP table already covers all memory. When RMPUPDATE assigns a page to an SNP guest
(guest-owned state) inside an optimized 1 GB region, the hardware clears that region's RMPOPT optimization, so RMP
checks resume there to protect the guest memory. I'll reword the paragraph to say that explicitly.

> 
>> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
>> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
>> Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
>> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  arch/x86/virt/svm/sev.c | 160 +++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 158 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
>> index 8bfd80284836..04b19e64f832 100644
>> --- a/arch/x86/virt/svm/sev.c
>> +++ b/arch/x86/virt/svm/sev.c
>> @@ -19,6 +19,7 @@
>>  #include <linux/iommu.h>
>>  #include <linux/amd-iommu.h>
>>  #include <linux/nospec.h>
>> +#include <linux/workqueue.h>
>>  
>>  #include <asm/sev.h>
>>  #include <asm/processor.h>
>> @@ -125,7 +126,18 @@ static void *rmp_bookkeeping __ro_after_init;
>>  static u64 probed_rmp_base, probed_rmp_size;
>>  
>>  static cpumask_var_t rmpopt_cpumask;
>> -static phys_addr_t rmpopt_pa_start;
>> +static phys_addr_t rmpopt_pa_start, rmpopt_pa_end;
>> +
>> +enum rmpopt_function {
> 
> 	rmpopt_op_type
> 
>> +	RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS,
>> +	RMPOPT_FUNC_REPORT_STATUS
> 
> RMPOPT_OP_VERIFY...
> 
>> +};
>> +
> 
> /*
>  * This timeout was selected this way because...
>  */
> 

The value is a heuristic that came out of review feedback on the series, i can add a comment here
documenting what the timeout is for (coalescing SNP guest teardowns into one re-optimization pass and
letting guest pages convert back to shared before the scan).

>> +#define RMPOPT_WORK_TIMEOUT	10000
>> +
>> +static struct workqueue_struct *rmpopt_wq;
>> +static struct delayed_work rmpopt_delayed_work;
>> +static DEFINE_MUTEX(rmpopt_wq_mutex);
>>  
>>  static LIST_HEAD(snp_leaked_pages_list);
>>  static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
>> @@ -565,11 +577,20 @@ static void snp_cleanup_rmpopt(void)
>>  {
>>  	int cpu;
>>  
>> +	guard(mutex)(&rmpopt_wq_mutex);
>> +
>> +	if (!rmpopt_wq)
>> +		return;
> 
> If there's no workqueue, you skip all the rest, including undoing things which
> are not workqueue-related?
> 
> That workqueue pointer must be magical and special. Yet, I don't see anything
> explaining that.

I will add a comment spelling that out.

> 
>> +
>> +	cancel_delayed_work_sync(&rmpopt_delayed_work);
>> +	destroy_workqueue(rmpopt_wq);
>> +
>>  	for_each_cpu(cpu, rmpopt_cpumask)
>>  		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
>>  
>>  	free_cpumask_var(rmpopt_cpumask);
>> -	rmpopt_pa_start = 0;
>> +	rmpopt_pa_start = rmpopt_pa_end = 0;
>> +	rmpopt_wq = NULL;
>>  }
>>  
>>  void snp_shutdown(void)
>> @@ -599,6 +620,96 @@ static bool rmpopt_capable(void)
>>  	       cc_platform_has(CC_ATTR_HOST_SEV_SNP);
>>  }
>>  
>> +/*
>> + * RMPOPT: F2 0F 01 FC
>> + *   Input:  RAX = system physical address (1GB aligned)
>> + *           RCX = operation type
>> + *   Output: CF set if the range was optimized
>> + */
>> +static inline bool __rmpopt(u64 pa_start, u64 op_type)
>> +{
>> +	bool optimized;
>> +
> 
> 	/*
> 	 * needs a comment here which says which binutils version
> 	 * supports the RMPOPT mnemonic.
> 	 */
>> +	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
>> +		     : "=@ccc" (optimized)
>> +		     : "a" (pa_start), "c" (op_type)
>> +		     : "memory", "cc");
>> +
>> +	return optimized;
>> +}
>> +
>> +static void rmpopt(u64 pa)
>> +{
>> +	u64 pa_start = ALIGN_DOWN(pa, SZ_1G);
>> +	u64 op_type = RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS;
> 
> 	enum rmpopt_op_type op = ...
> 
>> +
>> +	__rmpopt(pa_start, op_type);
> 
> Looks like the __rmpopt() carve out is not really necessary and you can merge
> it back into rmpopt().
> 
>> +}
>> +
>> +/*
>> + * 'val' is a system physical address.
>> + */
>> +static void rmpopt_smp(void *val)
> 
> You don't need that one - you can use rmpopt(). But keep on reading...
> 
>> +{
>> +	rmpopt((u64)val);
>> +}
>> +
>> +/*
>> + * RMPOPT optimizations skip RMP checks at 1GB granularity if this
>> + * range of memory does not contain any SNP guest memory.
>> + */
> 
> Put that comment above rmpopt().

Will merge __rmpopt() into rmpopt(), drop rmpopt_smp(), and switch the op type to enum rmpopt_op_type. Will move the
descriptive comment above rmpopt(), and add a note that binutils doesn't support the RMPOPT mnemonic yet, hence the
.byte encoding. The CF result is unused on this path, so will drop the output operand.

> 
>> +static void rmpopt_work_handler(struct work_struct *work)
>> +{
>> +	cpumask_var_t follower_mask;
>> +	phys_addr_t pa;
> 
> So either phys_addr_t or u64 but not both for a pa.

Ok.

> 
>> +	int this_cpu;
>> +
>> +	pr_info("Attempt RMP optimizations on physical address range @1GB alignment [0x%016llx - 0x%016llx]\n",
>> +		rmpopt_pa_start, rmpopt_pa_end);
> 
> This is going to spam dmesg every time the workqueue runs?
> 
> Nope, zap it.

Ok.

> 
>> +	if (!alloc_cpumask_var(&follower_mask, GFP_KERNEL)) {
>> +		pr_warn("RMP optimization pass skipped: cpumask allocation failed\n");
>> +		return;
>> +	}
> 
> Why? Why isn't the follower mask allocated once at init time?
> 

Will move the follower mask to a one-time allocation at setup (alongside rmpopt_cpumask and freed in
snp_cleanup_rmpopt()) and just recompute it per pass. The work handler no longer allocates/frees it, which also drops
the per-run allocation-failure path.

>> +
>> +	/*
>> +	 * RMPOPT scans the RMP table, stores the result of the scan in the
>> +	 * reserved processor memory. The RMP scan is the most expensive
>> +	 * part. If a second RMPOPT occurs, it can skip the expensive scan
>> +	 * if they can see a cached result in the reserved processor memory.
>> +	 *
>> +	 * Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
>> +	 * on every other primary thread. Followers are "designed to"
>> +	 * skip the scan if they see the "cached" scan results.
>> +	 *
>> +	 * Pin the worker to the current CPU for the leader loop so that
> 
> Isn't worker == leader here?

Right — the workqueue worker's CPU is the leader. Will reword the comment to use "leader"/"followers" consistently and drop
the redundant "worker" term.

>> +	 * this_cpu remains valid and the RMPOPT instruction executes on
>> +	 * the correct CPU. 
> 
>> Use migrate_disable() rather than get_cpu() to
>> +	 * prevent migration while still allowing preemption.
> 
> No need to explain that.
> 

Ok.

>> +	 */
>> +	migrate_disable();
>> +	this_cpu = smp_processor_id();
>> +
>> +	cpumask_andnot(follower_mask, rmpopt_cpumask,
>> +		       topology_sibling_cpumask(this_cpu));
>> +
>> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
>> +		rmpopt(pa);
>> +
>> +	migrate_enable();
>> +
>> +	/*
>> +	 * Followers: run RMPOPT on the remaining cores.  cpus_read_lock() is
>> +	 * intentionally not held here: CPU hotplug is disabled for the entire
>> +	 * time SNP is active (see snp_prepare()), and this work only runs while
>> +	 * SNP is active, so the follower set stays valid across the whole scan.
>> +	 */
>> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
>> +		on_each_cpu_mask(follower_mask, rmpopt_smp, (void *)pa, true);
> 
> An IPI per 1G pa?!?!? On each CPU?!
> 
> Instead of IPIing each CPU and inside the handler, doing the loop?
> 
> Nope.
> 

You're right — an IPI per 1 GB is far too many. Will restructure to a single IPI per follower core: a new on_each_cpu()
callback can loop over the whole range on the CPU it runs on. The leader will call it directly (migrate-disabled) to populate
the RMP scan cache, then one on_each_cpu_mask() will run it on the remaining cores.

This will also fold nicely with the earlier cleanup:  __rmpopt() getting merged into rmpopt().

One important tradeoff to be aware of: each follower IPI handler will now run a 2048-iteration loop with IRQs disabled — 
but followers are RMP-scan cache hits (the leader populated the cache), so each rmpopt() there is cheap, and this only runs
at setup and guest-teardown re-optimization time.

Thanks,
Ashish

>> +
>> +	free_cpumask_var(follower_mask);
>> +}
> 
> Ok, enough for this part. Part II coming up later.
> 
> Thx.
> 
