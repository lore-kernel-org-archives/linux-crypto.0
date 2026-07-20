Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010068.outbound.protection.outlook.com [52.101.201.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3A0399002;
	Mon, 20 Jul 2026 17:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784566893; cv=fail; b=AzzyzX9avxQ4fTeCVjvSrnunF/vhp24tF2uMZO9CWgGXp21cwiqCiHvYt4AeBM5a3yZvZgpYvW65qZC/7syLbSaKl+AauLB93SShDQGgp94M1vVQftTGshaJTte76fYmo5tUdXf2ADYKNgNKVQGFVMLv3ovlHa1wJYS/Ax/Peak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784566893; c=relaxed/simple;
	bh=E6mizVF2ZpPSQrtq8t/+olpx0H8/dateQkgr8/AZziw=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MDDR2QFx89xXkXoaHemAQOlfLWkqjEHR97CeHwXXIvAPATMw/dwPLBM4GTODlpgmGqapMc+1Ev+/cas6V8VKwp3Wjj62q16OnUgAV1xMIr/Sv4s/EpyXjq9pzvxr3GxRoOtAn1iQl1go8p7Bq+4aWsi3abDO38HIK6OhQmIcz7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=rObvZKk9; arc=fail smtp.client-ip=52.101.201.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="rObvZKk9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eP5jjXCFYZrzqnvBANC7lxRkKlIpPctu4O5oNawoVRkl8y2Nxt1JW/pSWyBwViXyqEcWK2v1z1tMIUbEO83nAqBicl7EsqXbvsU0TRVtfYppuSJHpNfrr9FK+86LyyLfOLwo331g/hsInokn/1fVp7GQOcDctqUcpRYPpNl72w4FXhHiOIP3Q1UJf1adiqXYo/12+i1KCb509Vw3iaPeca0SAAhqgEBaMn7qltLF2GXtwGf0llnpi2Zta8ZtByg+IIxU+eLDu1p6HGgWCsLpm8KwSNmmgX/7tzkxRIJ2Wa2a7tZo2DwK8WgITEWgwCFhCh46xK18GVwoG9QojbhgjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G+utlblf61x1ZJ/6hP5EauQviTMOwGPtCPQ/GLB/Ubg=;
 b=cV0xqMZlnKCh1G/CtdfrUKlHCON+M5b8xaVBQ2vqe+NbomLb25sv7bHw77ZShBCD2wST/DqydgsyDmcP72Gk32xw5wraQ0mLyWkZ8CG9rE5QWaqEMiuLzMX0mvGLWIs3pG3S6qrNAT9392Vg+ZrBoCiO4jbfvz0JBt62W3obN6bqYyyvHp/LLeZ/PXeraOT/hu1VkQgoXK7CInzqtLc+tINmOFbp6spOTFGVfQGvAI8UxgX58AbvCWFySUVh2S3gXzyx1a9OOQV1DUCrxSW6HQu3QNbSQu+YOxvH0KrgJTuqtDI0WMe7LG7Qe22kEenMb545L75ArcNEUxkDCeeZeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+utlblf61x1ZJ/6hP5EauQviTMOwGPtCPQ/GLB/Ubg=;
 b=rObvZKk9kM0ZUD0OtxmmkBvp+++tHvH/UeXZKjS4W1azX9jPwCNlitwiyb6vp2+hp+BbYaquoCCufX3DLBqJq5FEXXF1kMl9tCrMHMD+orI9uupACmZ8osaqfMG9whg9JNnIgsHMEPgs3UVetK8Dfrn7K3h3fpFUM22ca3+M5fo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from IA1PR03MB8288.namprd03.prod.outlook.com (2603:10b6:208:59e::6)
 by BY1PR03MB7264.namprd03.prod.outlook.com (2603:10b6:a03:524::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Mon, 20 Jul
 2026 17:01:27 +0000
Received: from IA1PR03MB8288.namprd03.prod.outlook.com
 ([fe80::b5ee:28c6:e04b:5599]) by IA1PR03MB8288.namprd03.prod.outlook.com
 ([fe80::b5ee:28c6:e04b:5599%3]) with mapi id 15.21.0223.017; Mon, 20 Jul 2026
 17:01:27 +0000
Message-ID: <14962fdf-66e9-4b64-a37e-0e697c875cc0@citrix.com>
Date: Mon, 20 Jul 2026 18:01:24 +0100
User-Agent: Mozilla Thunderbird
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
 Demi Marie Obenour <demiobenour@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
 linux-crypto@vger.kernel.org,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Turning on DOITM at last
To: Eric Biggers <ebiggers@kernel.org>, Dave Hansen <dave.hansen@intel.com>
References: <5e739bc7-4252-4f64-90ab-c68fc5cc746c@gmail.com>
 <b2986cfd-6e2c-47c8-8a42-863582ebf1fa@intel.com>
 <20260720162934.GA21086@google.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 xsFNBFLhNn8BEADVhE+Hb8i0GV6mihnnr/uiQQdPF8kUoFzCOPXkf7jQ5sLYeJa0cQi6Penp
 VtiFYznTairnVsN5J+ujSTIb+OlMSJUWV4opS7WVNnxHbFTPYZVQ3erv7NKc2iVizCRZ2Kxn
 srM1oPXWRic8BIAdYOKOloF2300SL/bIpeD+x7h3w9B/qez7nOin5NzkxgFoaUeIal12pXSR
 Q354FKFoy6Vh96gc4VRqte3jw8mPuJQpfws+Pb+swvSf/i1q1+1I4jsRQQh2m6OTADHIqg2E
 ofTYAEh7R5HfPx0EXoEDMdRjOeKn8+vvkAwhviWXTHlG3R1QkbE5M/oywnZ83udJmi+lxjJ5
 YhQ5IzomvJ16H0Bq+TLyVLO/VRksp1VR9HxCzItLNCS8PdpYYz5TC204ViycobYU65WMpzWe
 LFAGn8jSS25XIpqv0Y9k87dLbctKKA14Ifw2kq5OIVu2FuX+3i446JOa2vpCI9GcjCzi3oHV
 e00bzYiHMIl0FICrNJU0Kjho8pdo0m2uxkn6SYEpogAy9pnatUlO+erL4LqFUO7GXSdBRbw5
 gNt25XTLdSFuZtMxkY3tq8MFss5QnjhehCVPEpE6y9ZjI4XB8ad1G4oBHVGK5LMsvg22PfMJ
 ISWFSHoF/B5+lHkCKWkFxZ0gZn33ju5n6/FOdEx4B8cMJt+cWwARAQABzSlBbmRyZXcgQ29v
 cGVyIDxhbmRyZXcuY29vcGVyM0BjaXRyaXguY29tPsLBegQTAQgAJAIbAwULCQgHAwUVCgkI
 CwUWAgMBAAIeAQIXgAUCWKD95wIZAQAKCRBlw/kGpdefoHbdD/9AIoR3k6fKl+RFiFpyAhvO
 59ttDFI7nIAnlYngev2XUR3acFElJATHSDO0ju+hqWqAb8kVijXLops0gOfqt3VPZq9cuHlh
 IMDquatGLzAadfFx2eQYIYT+FYuMoPZy/aTUazmJIDVxP7L383grjIkn+7tAv+qeDfE+txL4
 SAm1UHNvmdfgL2/lcmL3xRh7sub3nJilM93RWX1Pe5LBSDXO45uzCGEdst6uSlzYR/MEr+5Z
 JQQ32JV64zwvf/aKaagSQSQMYNX9JFgfZ3TKWC1KJQbX5ssoX/5hNLqxMcZV3TN7kU8I3kjK
 mPec9+1nECOjjJSO/h4P0sBZyIUGfguwzhEeGf4sMCuSEM4xjCnwiBwftR17sr0spYcOpqET
 ZGcAmyYcNjy6CYadNCnfR40vhhWuCfNCBzWnUW0lFoo12wb0YnzoOLjvfD6OL3JjIUJNOmJy
 RCsJ5IA/Iz33RhSVRmROu+TztwuThClw63g7+hoyewv7BemKyuU6FTVhjjW+XUWmS/FzknSi
 dAG+insr0746cTPpSkGl3KAXeWDGJzve7/SBBfyznWCMGaf8E2P1oOdIZRxHgWj0zNr1+ooF
 /PzgLPiCI4OMUttTlEKChgbUTQ+5o0P080JojqfXwbPAyumbaYcQNiH1/xYbJdOFSiBv9rpt
 TQTBLzDKXok86M7BTQRS4TZ/ARAAkgqudHsp+hd82UVkvgnlqZjzz2vyrYfz7bkPtXaGb9H4
 Rfo7mQsEQavEBdWWjbga6eMnDqtu+FC+qeTGYebToxEyp2lKDSoAsvt8w82tIlP/EbmRbDVn
 7bhjBlfRcFjVYw8uVDPptT0TV47vpoCVkTwcyb6OltJrvg/QzV9f07DJswuda1JH3/qvYu0p
 vjPnYvCq4NsqY2XSdAJ02HrdYPFtNyPEntu1n1KK+gJrstjtw7KsZ4ygXYrsm/oCBiVW/OgU
 g/XIlGErkrxe4vQvJyVwg6YH653YTX5hLLUEL1NS4TCo47RP+wi6y+TnuAL36UtK/uFyEuPy
 wwrDVcC4cIFhYSfsO0BumEI65yu7a8aHbGfq2lW251UcoU48Z27ZUUZd2Dr6O/n8poQHbaTd
 6bJJSjzGGHZVbRP9UQ3lkmkmc0+XCHmj5WhwNNYjgbbmML7y0fsJT5RgvefAIFfHBg7fTY/i
 kBEimoUsTEQz+N4hbKwo1hULfVxDJStE4sbPhjbsPCrlXf6W9CxSyQ0qmZ2bXsLQYRj2xqd1
 bpA+1o1j2N4/au1R/uSiUFjewJdT/LX1EklKDcQwpk06Af/N7VZtSfEJeRV04unbsKVXWZAk
 uAJyDDKN99ziC0Wz5kcPyVD1HNf8bgaqGDzrv3TfYjwqayRFcMf7xJaL9xXedMcAEQEAAcLB
 XwQYAQgACQUCUuE2fwIbDAAKCRBlw/kGpdefoG4XEACD1Qf/er8EA7g23HMxYWd3FXHThrVQ
 HgiGdk5Yh632vjOm9L4sd/GCEACVQKjsu98e8o3ysitFlznEns5EAAXEbITrgKWXDDUWGYxd
 pnjj2u+GkVdsOAGk0kxczX6s+VRBhpbBI2PWnOsRJgU2n10PZ3mZD4Xu9kU2IXYmuW+e5KCA
 vTArRUdCrAtIa1k01sPipPPw6dfxx2e5asy21YOytzxuWFfJTGnVxZZSCyLUO83sh6OZhJkk
 b9rxL9wPmpN/t2IPaEKoAc0FTQZS36wAMOXkBh24PQ9gaLJvfPKpNzGD8XWR5HHF0NLIJhgg
 4ZlEXQ2fVp3XrtocHqhu4UZR4koCijgB8sB7Tb0GCpwK+C4UePdFLfhKyRdSXuvY3AHJd4CP
 4JzW0Bzq/WXY3XMOzUTYApGQpnUpdOmuQSfpV9MQO+/jo7r6yPbxT7CwRS5dcQPzUiuHLK9i
 nvjREdh84qycnx0/6dDroYhp0DFv4udxuAvt1h4wGwTPRQZerSm4xaYegEFusyhbZrI0U9tJ
 B8WrhBLXDiYlyJT6zOV2yZFuW47VrLsjYnHwn27hmxTC/7tvG3euCklmkn9Sl9IAKFu29RSo
 d5bD8kMSCYsTqtTfT6W4A3qHGvIDta3ptLYpIAOD2sY3GYq2nf3Bbzx81wZK14JdDDHUX2Rs
 6+ahAA==
In-Reply-To: <20260720162934.GA21086@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0104.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::8) To IA1PR03MB8288.namprd03.prod.outlook.com
 (2603:10b6:208:59e::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR03MB8288:EE_|BY1PR03MB7264:EE_
X-MS-Office365-Filtering-Correlation-Id: a747cd57-66be-4fdc-48e9-08dee68089c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|22082099003|18002099003|4143699003|3023799007|10067099003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	GdE905RbqxdTnBtFeRgXvL0vBW8qqytUn8QeQ+M3/0iIYyhgW3LYwFDXM30FmNj2Ib/oO/dGDmt6ik4hSu9EzY48K2ULZBhh5iHSOVA2DJj1aZBA4Io1CyHvSPAcBZh4OnyuqJS5F/GIllLmcyK1vZscLgw5Tm853meIeAa0eTECQFvCswMUugDuTWtgKkjJCbecf7VpDm5aqIX4tAZpYoFWQ1IfvcHjAuL1+zoAemc5QndLKRonSSDJniaj72TI8+AQI2Vck51qhiKXW8f2cIg8e1f6SKwBONmwklCabjmWdC9NhRkOxcLwhVZprFJg8WIvRmNebN49FawOVnorNnUzHpQWGSs1DsRFEoJ1i8lI+kgnnXmH8whZIPmIoYZR1INXzVrBJtvMsErgOjqzCpSWKHXTAFdcpO/Ao7R2HERoVXlxpGlo33ZYxcDIg6VybABEZhu39GXNZyT/qvNlEGBK34fQwmx592yYo4rX2B1Cy86FXBzZmW+9Fbj7nQFg7ThMFa7i6S0mBd7Nl8FYPdjEXcpTcTEarCdn9aDtNXk+Pd1PysQussSAc2GVSIqD6cNM6vjnXTVYS/cs6TxgPv2UI4CzqQTYVGi2KXT0yWzraqifMw9gTbEU6rpH5hDe7Vb46jXaGmtKIngg34XS+uX+BIeNYYq1mA+WkIn8R18=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR03MB8288.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(22082099003)(18002099003)(4143699003)(3023799007)(10067099003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WE1PUEhMVG51MnZuK3NFRE1yZkx2Zy9oRDZNRDdiY1dreWF3cE4yaVorUUhi?=
 =?utf-8?B?bXpnMEFGNXZCWkpFOXRLRklrV3oyRitSUFNheEg0Ujc5MndHYkMvWFRUWmth?=
 =?utf-8?B?RGs1Z2J3dk1EbXhCTzBkRmlmay91REZoZnBSckNia3hUN0pQLzAvM0NqOHF6?=
 =?utf-8?B?ajlzeW13aGErRFM4WExUMnczaVNYRTA4akNwUmN0MklmZUZOcWFWZUJsNmJR?=
 =?utf-8?B?SUttL1E3MEdNblBhUG9qZHRMTlB1cVlhUVNmRTZHM3lJMG0vOGY1Y3U5UldT?=
 =?utf-8?B?Rkk0UnVRR3A4eXVDNnU1RDUybE5sQk5tYTdTWU5NVm8zWlpLbzlOZUZjdFhu?=
 =?utf-8?B?YUo1TVhvd0N6YzdmSElYLzhpTWtzRGk2WHIxNG54NTc3UjFQQVpEcDVWM0tW?=
 =?utf-8?B?TW95ODJvVHlGZkptQ0VGWGc5VHk4cVBqOFNjbGVoZm9KMk1saktSUVlpbHBD?=
 =?utf-8?B?RGxabHdyalpxQ1VDbUNQWDh4T2tpejBWbG5rNVZ6aUhNTDZQREpMVlRsRFB1?=
 =?utf-8?B?Smh3bGNWdlgvQnJzWGJqZnd4eUpTUjh3L04weTVock1vY2NpaW9zamFwaC9V?=
 =?utf-8?B?SUh1Zi94Nkd3VWszTGJrYWtZVDY1VHpQQUtoeE9rM2FVb1Z5bU4xMzRvU1Fv?=
 =?utf-8?B?MVNLM2JiMEUzK25GSVhaRk96b2NkUmJuN0V3QUVNTGNrZDU3cGs5NERic3d6?=
 =?utf-8?B?S0R6STN3Qk92TEdqVXYyVWYxMUFhRXl5cVhycEYxRkVSR1I0WURnRHpJZ3ho?=
 =?utf-8?B?ZmpqMTE0UVdFUEdtaFhrOEluKzBCc3pnTmdlRFgxMTNObUtxZE1Sd3VCdlBh?=
 =?utf-8?B?QWF5VnJSVGllaUY0aHgwUmtoRVVqdWFQNDVuSTZodmhKbHhGL2dXNituNFNP?=
 =?utf-8?B?elZuVitseFQ4UzFoTnllMEFmbmVobWRhV2xwUncxTzc5cTFwSEMwZWZTQS9h?=
 =?utf-8?B?aloxd0h4MzM0ZGdXU0t0Mm4vMlRudHR5RDFRczQ3SzZBRVFsYVhuZUhCZEt1?=
 =?utf-8?B?ZnBPQS9RcTM0dXFVcEhyNDA3YjgrVk9BbmNlM3FKSm11dXhYMG95V3FFb1Ja?=
 =?utf-8?B?SVl5dmFaOHI4enBBYzMrQlIzbjg3WEo2b21POEphL0tMVHZFNEE5ejZMMG1a?=
 =?utf-8?B?MC85WStJSmxFWUNick1GZUJ1RnZNY0FXdHB2ZlJBd0JYcG1VVG83SndpeUhp?=
 =?utf-8?B?WlFydExtNmZCK01vb3AvSWZlWjBhWW5CSncwVXlSQ0dQTTNQMlZGZ096WkE0?=
 =?utf-8?B?WjBMamFweHMyQ2R3QjJPL0hveUhmcFE1dmhyV3N4dHMyZ1ZBQmZlaHVlVXl4?=
 =?utf-8?B?WGJlKzJWbkNmZEtJME9UMFArRzlORHFjdGxIaTRkdk1CaFd2a0tianZEWHVE?=
 =?utf-8?B?TStOUDVFY1JxZmV5U3pCQ29pbTlQUkdTcVkvaFgwdGl1SSs5ajhMeit6Qlpr?=
 =?utf-8?B?OUwwRmRtYi9qOTY0cWEyVGhPemxJMDU2anNmUDVZb09vSEw2bjBsWWhQcVdZ?=
 =?utf-8?B?RzhQam5hcGVsOGp0Y2pjWmJkVloxOE1kd1hNNE9xWXRtSDl2QVJ0ODJBR1Jr?=
 =?utf-8?B?MHpKWDZZNW9LaUZjNlExZUlHREhvaWR2dUlXT1lYbVBOT2lYcVFVdGJxV2JT?=
 =?utf-8?B?cnFyK3E3M2RhbzZkV0FucDd5cktBSHd4ZCt2T0FyOXpuRWNUK1FjeFFFVk9Y?=
 =?utf-8?B?WDd1Tno3RlFubkRnOFVYT3BaSDFsTDJzV213bCtGaWd5NG8rWFBTQXI5Qk1M?=
 =?utf-8?B?NGtnZ2ZKVmZVQ1NCWXJjVWVEaGpFNXl0OVhtRkhjV1RaUW1RdzV4SVdvQ29w?=
 =?utf-8?B?cnNlbjNaR0s2a3FOU1FoNXA3N1lhWW5IOG1Da0ZsYytGL2x4QlRaaFI0Smlz?=
 =?utf-8?B?RjBsbDlrOENrNWR3WWpqR21UOW9kK0RWZ1BFeVRDSGZlU0JIZnQwS0ZMbUMv?=
 =?utf-8?B?UEJPS25OeWtacUEvTG1yd2xzbnlTNmVmRGcvbndkQU1qM0xmS1FrbE5LWElX?=
 =?utf-8?B?RXorcmJSbEtQSWs1VzFTVFZZK2VlOHlkL2NxL2ZGNTlNODBTV25NVjhwZWMv?=
 =?utf-8?B?b1JZNDBwSTcyRURmVys0bkoveGtLYlhiTDkvZVlBeGF4M0llbE84RXlFVWto?=
 =?utf-8?B?andJTGg0Vjk1bnVxWE1UZk1OVHloN1ZzM3M0eEtUcVFqU21hKzJweWtqWUVx?=
 =?utf-8?B?Y2U5cnA2cWdFcW5EdkVVZ2h4OGRTK1pnNTdlQm5LVXpmbE1md0kwTlBBQUox?=
 =?utf-8?B?OHpCSGI0dE9JNFR5WldUYU1yWHBUTXVIQ21qNVZWNEJMaFI0ZmVQOExHdnFZ?=
 =?utf-8?B?bTkybS9NTjhxMUk3ZHRzUXVEbTRNdVJ6bVAxUEFuNy9XRHREdERTZz09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a747cd57-66be-4fdc-48e9-08dee68089c0
X-MS-Exchange-CrossTenant-AuthSource: IA1PR03MB8288.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 17:01:27.5321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UzjKs+hEawvgl8fbdSlJeXBajsjHY9WGgTiedMCOBEP5qtx8V1l+cRcRYe4YNxnTf4SKEQ/hUvAt1NdLjUSld8FzsorbkRdpfLB3g8xKelk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR03MB7264

On 20/07/2026 5:29 pm, Eric Biggers wrote:
> [+Cc linux-crypto@vger.kernel.org]
>
> On Mon, Jul 20, 2026 at 04:55:19AM -0700, Dave Hansen wrote:
>> On 7/18/26 10:01, Demi Marie Obenour wrote:
>>> Is it time to go ahead and turn on DOITM?
>> No, I don't think so.
>>
>>> - If it doesn't do anything, it's a harmless no-op.
>> I kinda disagree with this.
>>
>> There are CPUs that enumerate support for DOITM but on which it doesn't
>> do anything. On those CPUs, every cycle spent twiddling it is a waste.
>>
>>> - If it does something, then that something needed to be done to
>>>   protect code that handles secrets, such as crypto code.
>> I really disagree with this.
>>
>> Lots of code "handles secrets".  memcpy() "handles secrets".
>>
>>> - The overhead of switching it on and off is too high, so it's best
>>>   to just leave it on all the time.
>> The overhead *is* too high. It's an MSR bit that requires a user/kernel
>> round trip.
>>
>>> - Even people who don't care about speculative execution
>>>   vulnerabilities, because they only run trusted code on a particular
>>>   server, still likely need secure cryptography.
>> I'm not sure where speculative execution vulnerabilities came in to play
>> here.
>>
>>> Xen already turned it on in the past.
>> While I very much respect the Xen folks and their security posture, Xen
>> is a very different project than Linux.
> The right thing to do for now is to just turn on DOITM at boot time
> (https://lore.kernel.org/r/20230125012801.362496-1-ebiggers@kernel.org/)
> to fix the backwards compatibility break.  With just one write per CPU
> at boot time, the overhead of writing the MSR won't really matter.

This is what Xen does, for the same reasons as you've given.

We don't even virtualise the controls for guests.

> For the insecure mode to be the default, there will need to be an
> efficient way for userspace to enable the traditional secure mode, *and
> then* several years for userspace to be updated.
>
> Unfortunately, since the hardware enabled the insecure mode by default,
> Linux inherited that backwards compatibility break without any explicit
> patch submission, and the burden is being put on people wanting to
> restore the traditional behavior.  It should be the other way around:
> the traditional behavior needs to be the default for now, and then we
> can discuss what needs to happen for it to be safe to enable the new
> insecure mode by default.

+1.

It's not just in Linux, it's all OSes and all userspace doing any form
of sensitive operations.

Insecure by default may have been a deliberate choice on Intel's behalf,
but it really is unacceptable for the wider software ecosystem.

~Andrew
