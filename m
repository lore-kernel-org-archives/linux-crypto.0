Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010011.outbound.protection.outlook.com [52.101.193.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B77B3A9624;
	Thu, 30 Jul 2026 19:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785441168; cv=fail; b=MeO2yXIu18LGAUb7MOMMWphUOFXbb0rp5loMAk4sngzdR+a44EsRwO99dRnzyrZIVC8ZJT3lexcN8GCR6EvcKNOcZuQOeBsyVihFMhW/yo0WR5hayakDVV3B073LpWKg+iqEzRC0L4sqKMSxjs5m4vD4d/qRKy4YjXkgbYZMWwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785441168; c=relaxed/simple;
	bh=FE1Cg/Hqmm+ytkGk/CCGqQZQgdqrIJVyN1po29oQsus=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S0Mb/TMXgGU+PLGZsuLVEBT4V4xyvpiNuJPDs/uw9fCi937s33w6fMGR03vySA39Gj4ZD3mVZk+MUzezhlfjpeVGFs3r0e7zWhZrURs4PHp1MiIsPEtDYdnHS7lhGkjUEjuMGzNIydPJO7p8lKAeM8U4hA0EVsabdb9oAKJtci0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BmILbT6V; arc=fail smtp.client-ip=52.101.193.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BmILbT6V"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jNutFo60aOz2FXZIahgtigrJJLEvnY+ex8eNThw/rGk4fqqp0QCQWYc40k5MSklQWK2DYivnrgu8gGsXgBK08BeWRPTiVD+7xerM+Z8jxRfD3z469KuCKKw5AOw6U/wboYOGL+HtaGAhviU3x4fuYICoK/3VlQaBZzJtp7g82n5SkQ9Xk3CCcD+/aGdqNZNcHzEu2fttTm79sUsJcOTs8+6ZYL32l2atYgmqXKCqYDhbwbmJPx2FYY9MjHgXrhUAXjNJGzuanofiuUfw37KuNMGY7j0dV7CRzJA5+JR6w9ql2LBvrYkMBhsyvQB67Cuy7xotUdZd3blPM45+4ZUZkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cld9vitXzjOyjIYCYgeYIKWN1QXOHlOWG0AyyOSRYpo=;
 b=b78TRkLuAVxjrLWTDld2hkF9S1Jz8B/ngf545QFOEUQyQM9ImMCPf424ClWBpqIzb1Im5ZXFchJeynH21QIQQO97L0scp1606oNM4UC0S3JIKfnSNKktL/hAcO1RCffyShqO6qxdCUtRjZPhz3D2t40Ok6DCjZUdAu4V2mZwu+knZPlxNSGvLp2H1pgJq1ki5gmJ+2oX5c+JGpMHW5U0jieHhrgtRKQGyzvJ1jY3+jK2XSVvsZVY06z1pjH+XFy7llfJoMvbxBDoLQiH8k8jrrDF41+0Fv2a/bjnmKouLNtH+G8UR5qbxYx6rQu2nra6OTyp5rvp2jKNVnUNfZgxjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cld9vitXzjOyjIYCYgeYIKWN1QXOHlOWG0AyyOSRYpo=;
 b=BmILbT6VxKokVm9x2PTnskQgUeGDz6ezynTMpBHybjlQQBgDInl3BV4677yTZXHT4GobY6dZPFZBEwYsYlMBJC2DFhn8pVtpPs/lhhuYaiXtkAkksqyZ/q0k2hS2wXxW5XUhgdN9LpN5iV/wliyJTYZkJBLkNnUQEmZqjrd5f1w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH7PR12MB9150.namprd12.prod.outlook.com (2603:10b6:510:2eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Thu, 30 Jul
 2026 19:52:37 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0270.012; Thu, 30 Jul 2026
 19:52:37 +0000
Message-ID: <08fe1cc8-b281-447d-a0a8-fb80ececb6d0@amd.com>
Date: Thu, 30 Jul 2026 14:52:32 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 3/6] x86/sev: Initialize RMPOPT configuration MSRs
To: Borislav Petkov <bp@alien8.de>, K Prateek Nayak <kprateek.nayak@amd.com>
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
References: <cover.1784844080.git.ashish.kalra@amd.com>
 <ff346ea1770cf996e1623270a085ac08d21888c6.1784844080.git.ashish.kalra@amd.com>
 <20260730020704.GGamqxyPy5oJAmC5Oy@fat_crate.local>
 <7f837674-786a-42b7-a289-4c048fbec6b8@amd.com>
 <20260730033907.GFamrHW3v3dbb0UmFL@fat_crate.local>
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
In-Reply-To: <20260730033907.GFamrHW3v3dbb0UmFL@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0012.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11c::16) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH7PR12MB9150:EE_
X-MS-Office365-Filtering-Correlation-Id: d5e620b1-40c0-4f43-b995-08deee741a56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|22082099003|18002099003|10067099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	gaPk1EAQvRG6Z7CaZFOn1fd7+Tm2cqd+/24QwjT+X4V8C74txvPpkgZ38aGHOuGUyrzhzCewnTdRspwzqAMvtBktAO6KGjXglQiOYgmehFuGDIE/KG/SkSEWugqdG1cQ1NWPjPbiy7GOpTiRErlh6sR8XnMu/dkkm0R0h3oTp8PJhl0GJK0llHx33EyZVG263SxCg/DTfFiHjnlMxNnFrsHvo5+l7B+wq5CBpV6OTYbj2vpAoUslpMmNSilP/goT4wVVy6kPLzkLghJCaaUWem3sYauEYYj/TETXFyBB+u04CLokOU3S+h9xKle8KiDPcV1L4xzPEzKWXgw21Rj7BCcMtEamlYrgGSL77IFb4xybEFxQTk0soILWLpOtY3LGOziUfLm9bSHcMyBjwGWb8SfrqW1YOutAqj+AWofMlgQs8VzRmOAt/19+ezKNcLBnU3Q06nGLvyXlm8Wn0KuYv4lP5W+G6/n3yxmvIQahAb9nsrvqkbsP3fRy1k5a1fMupHFfGFAUWa0FkAODngxReYT3O2t9SvN+FT0WuVt9IDiPjH9Z139fuzmuWKstAUElnWycse7Xwf3hupGO8JkHsVA/n42O+UyO0vM0Ea8pQtxn+7Wv3XFTsuTAZCvgx31UuETLylfbRSvvX9kR5WarO9zaplLF4c1Yid6Zmit3SB0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(10067099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWhLRGt0bHFacVJxSldZYXhOck1OVXBQWXNIb3JyTlYzRUJmaTdlemJ0L2xZ?=
 =?utf-8?B?c3pqUWgraXRldFV1MllFVDN4VWY5TDV5TnBiUkxUYnpWc2NtRXNldm9qdWIy?=
 =?utf-8?B?OGxHeTJQZHRnUFc0TDRWU2NoZGMydWNIelFxMVkxeUZEWUluRmdUTzN0dzA5?=
 =?utf-8?B?RWsrVXBVUDRLY0JibjFRUEhnMDQzeGl2RFVhMlJnTW1FZmdJbWN3WGlNbUpB?=
 =?utf-8?B?SjNtK0VWYVQ3YWEvK3lmWjk0Z25QVG16Yng1ZlBGcUd0bS8yUHhFaHdEVzRw?=
 =?utf-8?B?RVl1bStiSmFEcWd2cWh2eWtBQVU2VDJqcUtTc21WUktyMERlY1NzajBnWHRJ?=
 =?utf-8?B?QnhPSStsVnkzQkVFaHRyamltLzJ5RWd0Q1BmZEZqTEUzSDNPbklxeXJGU3hQ?=
 =?utf-8?B?SWs3UmlBVEYxTlh0TXAzS3A1ZUpVdXNxSHFZS0JmR0JCeUVnMEZhMGEzQUJw?=
 =?utf-8?B?Q29FeVRCS2dacms3ZkRYL1Vwa1ZUY0RkRWdTYWZWeFlhZWs0bjFFYUlsSEFt?=
 =?utf-8?B?WThleXJvcmsySFF4Z2U3QUs3WDJFU1E5SEpSVVR3NFpjRGdrd0luUE9qZmpJ?=
 =?utf-8?B?Tnp3VDJ0dmVvNUFOTXF1djZVeHp6S3ExZDB3Q1JXNG5QeStCSHVLZUZ0b0RP?=
 =?utf-8?B?WHdpNDdOdU4zRGpiU2MvMCtUWUFlVS85cHJuZHBjWnBqSUsyMmJVZWt5cFNE?=
 =?utf-8?B?bXdYTzhPSzhvSUhDTkJTcEpqQUROaHEyNXJXd3kxcGtUZG9WTUZpZ2FpWHox?=
 =?utf-8?B?RUthci9ETU5OaVBYWUp2MzEvdnlRbHFhcXZieTUxZVhkbmJiMTErVWdMNGZa?=
 =?utf-8?B?OEdHaHdyVDdFRkFtQi9Hc2VSdFo1T0ErdkpYZFB5Mzg4ZUM0UU9LWXJtL0dp?=
 =?utf-8?B?b2k3djllT3dmbkNWcHk0ZVcyeUZZRU1UeTRJNmYwZ1cvdmRsdm9pVm5IbDR4?=
 =?utf-8?B?VXdFSTgvdW1NeVZ4WnRvbmNQUm5oQ0ZUeTRRMGkrNHdRR3Zld2RmYmx3Uzkv?=
 =?utf-8?B?MXAxcmowaTFYVVRQc3JYUnJwU1o0TGU1QlJpdFp5THJHaEJDamlveHJEZDZi?=
 =?utf-8?B?eW5vRU14dHAyRXR2UGNFYWdZWm5tNnJ6SG53OHM2b01CbnBjQ1JXSlViUUkv?=
 =?utf-8?B?d2pmWTJzQmVYZ2dqYnJra21uWldhUzlYQkphM0FsMm1GSGpuYUxhbXpocTNh?=
 =?utf-8?B?YXlMTjEvcldMcUtVTTRWNkh1aXUxVjVCWHpQUzlBYy9DVXhRajlIWWU0ZWhh?=
 =?utf-8?B?aU42RXJ4UHNtNUI3bFRuZnVKWmptRWxvUDRWdHYra2RoS2dkN241ZXo3OFZO?=
 =?utf-8?B?a0thR2s0MFY3eCsrUUJ0aE5HeTk1cTFRemtUV3BPOTFQTi9GYkFqWHhQZStC?=
 =?utf-8?B?NHBxendteUZTcXFEbHZWVVlvaUxpOHFhYjZVZmROSjNpMk5NRDRWbXRaQ3Rn?=
 =?utf-8?B?MkdZM1JzaUdlb1F2WHQyTGZoTmxxTWZremNwdWRZN2NhZytWaUtHblE4cko3?=
 =?utf-8?B?NjYzS1BRUnV2UjRXcHY0a0pSa2d0ckh1YnNLMVVhK3JDRXp4OHl0REw2K1JB?=
 =?utf-8?B?MXhhS1FmVUpOYU13SVFCWjNlcWoxSTZIdW8yUVphQUl5bWZlY0dUY3EzOWtD?=
 =?utf-8?B?Q3Nkc1pnMUdQbEtCa0FNSVdvdmtOYmNXZ3YxaDJrWU84WFdSREZFeWhwL2gr?=
 =?utf-8?B?b0c1VFREWmtkR0pTUGN6dDdCV2I0Vzg4VzUxZlVncjFidDhkbXZPRHdVSkgy?=
 =?utf-8?B?OWh0cDNnWjFmejYxRU5WbmxTNG4wS2kzczBQSEpLRW80alFNTDNraEc2WFpv?=
 =?utf-8?B?WVd2TWNKVGVZVGtLWDI1dmZHWTNVdWdOQ296OUk5M3FjTVEvTU5COFkyT2xJ?=
 =?utf-8?B?dW0zejFmYnhyUnhnbWx0M2FWWGs4L0l5YW9sMTVnZDdMRnliNjJ4dXVTQUNW?=
 =?utf-8?B?NXhFeHlYWHgwK1BuN3FqUGJ2bm9DbnBCUi9WdHRvRXp0dUhDSXkyWWZJcThY?=
 =?utf-8?B?U2x5NlZIYWU1amFEWStsR3pRVWs3Q0VhRG5MMTZZWS9kc1pNNi9kQWR4K1NJ?=
 =?utf-8?B?bEdwNlZBWk42YUlMT1dmOENyYmtXVHdUM2N5dDdObFFOM2pHSTluRGNZUGY0?=
 =?utf-8?B?WTh4NjBhU2RUZXl6UXhyZjFMb2dhZ1czcDBrdGhGMEcvVWNPekEydTEvdnJ0?=
 =?utf-8?B?TXFMZFJ1Umo4b0E4RTViZmhRaEtIbWIvKzNZTXBTNGZ6bWFPeVZhNURnbVlj?=
 =?utf-8?B?WUdBdi9hRHVrOU12czYvUUd3ZHBXTjFxM3dXUTkwaE5OYTM5UHdWOWM2SXc2?=
 =?utf-8?Q?LiSQqFl3F22FK9ljgi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5e620b1-40c0-4f43-b995-08deee741a56
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 19:52:36.8211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4uBH0U4uct34oJXJKqGW8EiWr3l9SJUmmeYLCaQsEUSDr+vuOW00MN3gm8y+2H3d9d66lDLn5f1QdRMkZM9WQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9150


On 7/29/2026 10:39 PM, Borislav Petkov wrote:
> On Thu, Jul 30, 2026 at 08:25:37AM +0530, K Prateek Nayak wrote:
>> I believe there can be cases where CPUID advertises
>> X86_FEATURE_SEGMENTED_RMP but rmf_cfg doesn't set
>> MSR_AMD64_SEG_RMP_ENABLED because otherwise checking rmp_cfg in
>> addition to the feature bit makes no sense.
>>
>> In that case we should attempt a probe_contiguous_rmptable_info() even
>> for X86_FEATURE_SEGMENTED_RMP.
>>
>> Essentially drop that "else" and do something like:
>>
>> bool snp_probe_rmptable_info(void)
>> {
>> 	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
>> 		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
>>
>> 		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
>> 			return probe_segmented_rmptable_info();
>> 	}
>>
>> 	/*
>> 	 * Segmented RMP is either not supported on the platform or
>> 	 * is disabled by the firmware. RMPOPT is not not supported
>> 	 * without segmented RMP.
>> 	 */
>> 	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>>
>> 	return probe_contiguous_rmptable_info();
>> }
> 
> That makes sense.
> 

Ack.

Thanks,
Ashish
