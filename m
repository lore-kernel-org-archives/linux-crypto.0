Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793717976;
	b=DpZPtdD7CkZ97cn09bRB9LpjVXC3JsrsQUxj0ZYlYPDEh1QyJWU6pFVe0AiH0c7AAtAD
	 msXD9iOL1Z3YO8hBHBOqgxtrz9hmW3EDN0TE/GGs+KhPIIZoqqauQaB1lsFOisxMwFhbN
	 /TAHWICFsOzWTztk6q1Jpps4f7auC7pKlgQsN+o/HPSiB1ZHlXmZtk2hi1IO3/JNbezhB
	 9jn5BvBzqLaxl006jGjXb/VNZvl+k/IjNqEEnn6BdZq3YtHCqPS83sbVAMYCCjtXTEB1b
	 +ehTw7qz9JFbnEwUsrT2W7ylqAFSzHmhezwYFMJGFfVkwxJkYYwWa2lmUq1tcwdSolA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717976;
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
	bh=vZf9bwigy/nxOYJJncYoQ5DNFEG8/DPB1XKly9jy+Kw=;
	b=re2XP6iTe2vqjg1SIS+qS4df16IfrIT7IQRPYDJJZKH5axawZq0dtaZYJvNfONUAb0PP
	 n9viTA5EGGmv4ntsH+Gz4RcXzITUNQRqoiNIMcBKZ7CGDJR4paSdH7/BYVH239p8d305H
	 NIFf8vm0rgfUh39uVNHQXwcyrjmvuw9s09E/AgyqESobkNegtlOfVSyyCdq5Fd4yrrQN/
	 W+Ytpu6Wun5gv2vIxjHNbuqoyahMSANY8M5ADALw5m8/p2+ZufGz2/KviQ2A8g7GAaEnc
	 R7JQ6a8OW3S21tsGfEc3LaY1IwSABMf15Wk+BzqDCZYMec5JmlwG8nb7jcLlYRoom9w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=lqSstJ0A;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.57
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012057.outbound.protection.outlook.com [52.101.48.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C29606A337;
	Tue,  3 Nov 2026 14:59:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9C29606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=lqSstJ0A
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b+tuGtCnJTk+UbtLz7rqcPFxn3H3k8UDCGH56z4iIvyCJ5BPbR4Wi2chb9i0y8LqBOqC6OWX8LVIIxsdQVohFl7ot3ckRXafW2pauPU+fy4wXGFFjb1jzf0PopGSB8+LQ+0BgM4Osr2UIIROtkv7knYwKV8uPV18kPIvmyAj0EglG0C0ZnV6VnVvnbQzuAHk1YQMAn2BexrZjQiE1Z6Mc70yWhbeki1SywQpkB0b8uwUQlh5qPGG+/PThMPyseZMHNGz+g+f+SK55e+S4on4JXwuzJJ8L0tRgXHSCkUZkiEndlCRMrlr2VORdBnsYmSrfJ9Khi5Y+NH645BmAb6LCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZf9bwigy/nxOYJJncYoQ5DNFEG8/DPB1XKly9jy+Kw=;
 b=xr4EmHiHoUeiEaJalRpk3sbKnfloWhIE+CkKtpBNoUwif6SuNvSvaZWwLTwFJ/AQyMX+fyjWlyOT/LdwuCAdWaIx3N55XCLbli1fvzGa6Zj6WCpM+FsG5Hqn5KrhBXE0J1EA2Zh0uk+FPL12jTtJV7Cph4834f1OTsvWqMwX+nU5NQ5Eb1CkKbVwdiP2u+CVqRSt0Lm+nu1QsC5KPxBHgsQPMaq8WvTP/KfKXOL5UkGzF7xQdEYuQ9gdkq38TI2FJ2ZHpq+hwCNC/+9umSf2OnyT8mAn53jqqETTKo4Jrk1bsW+GQZvMFkW/u0id+xYpHEHo5wtSbRs/umwl4Mhxvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZf9bwigy/nxOYJJncYoQ5DNFEG8/DPB1XKly9jy+Kw=;
 b=lqSstJ0AHKdBbzzHuLeLlt0ee0/hlLOde5eqcvSEXE0y3PVsPdYNRNHGWRISsBbOY0r1fFcxhCccGujrCZ4OHh+zlKZAoESesuKz2zNNe1gGkdQEyDXSFtxsYREpQkiwbbLUsHj09g3fXG3fnkZeNXknZDw4k/6uaYOyveA4aEk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS7PR12MB6286.namprd12.prod.outlook.com (2603:10b6:8:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 14:59:30 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%4]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 14:59:30 +0000
Message-ID: <78bc08d8-211c-4de0-b99a-2932d5612282@amd.com>
Date: Tue, 3 Nov 2026 08:59:25 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] x86/sev: Clear RMPOPT when segmented RMP is
 disabled by firmware
To: Borislav Petkov <bp@alien8.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, tglx@kernel.org, mingo@redhat.com,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org, pbonzini@redhat.com, aik@amd.com,
 Michael.Roth@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
 <20261102052841.GBaugfibOXxGorZKgq@fat_crate.local>
 <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
 <414b2fc2-a55a-4b2d-ac70-4def101c4aee@amd.com>
 <20261102144805.GCauiipTaEXcg6Lr59@fat_crate.local>
 <d81f6807-26ac-49b9-a205-c89c394ec1d4@amd.com>
 <20261102193116.GDaujlBJc3XjG3xzLj@fat_crate.local>
 <9ebcb83a-1c0e-423a-8730-eff6b710634b@amd.com>
 <20261102214343.GFaukED8ep3EMmQxfx@fat_crate.local>
 <30947e17-bffc-4c70-b19c-56504771c9fa@amd.com>
 <20261103004531.GEaukuq9sXbCs_PjfL@fat_crate.local>
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
In-Reply-To: <20261103004531.GEaukuq9sXbCs_PjfL@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0123.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::10) To BL3PR12MB9049.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS7PR12MB6286:EE_
X-MS-Office365-Filtering-Correlation-Id: 188d5245-e017-4d26-589f-08df39bb0fe0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|6133799003|10067099003|22082099003|261102123227099003|18002099003|56012099006|4143699003|11063799006|261022105027099003|261021121427099003|261021123027099003|261022075727099003|261026121527099003|261009223027099003|261028144727099003|261026140227099003|260925021911599003|260925021311599003|260925022911599003;
X-Microsoft-Antispam-Message-Info:
	WV0Mv7zbtx++lhugKuXZameyxtqYhkx8ErSXIOgN+f5c6uRlwo9L29l3HmFqGBdbHxTUySsWoSqpGOyMZtD6BkiR+QTOKP5Yko8Kcr8A5wfJ9PUCxitz61I9UHATfsfuiNhj8j1nxIw9J2VrvUCGpvmDDY5B00bDwOveTKupC7f5pyOhQw1htDYmTWLTWThrKrYpASeuvlSGBezO0yhIQQGtl0NYRO9QyVoRi368L5kaUuhiXWT9Nz5kKg09y4BA74kQV3i/r+SGaXfu/p4YGraKkPqYHmgI3sZRy7cEr03h5x1XUiGyd9v9LIyAadbNGoEAy/oFfaiYj9N7l6HBcgU0w3XVoKrsX8H7r6MvHAVFmiMLYTs87KjJsQ1EPPfSvjI25AhSDJV8xrKj7cF5Hp13rvii+xk43aQJNjfjbEw4CLSO83VSVzFlcFRucRh97X72MtkETASxuQSUp8QRVBkBE9HURgVl6PRdIHKoqcrukF8mWZdApOvvEzOKD16CQp83iLZWb77tKVrQ7uJ/XZVmVLHGZFDgOd9hVWtVtR1Vif44qwJWiEZR2bahoATmZMLlc1jJ0sCB+5SmvghESBrNbi5wvoqQLxDtqM0TaXd5f9hIYm0iKi65NNr020m3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(6133799003)(10067099003)(22082099003)(261102123227099003)(18002099003)(56012099006)(4143699003)(11063799006)(261022105027099003)(261021121427099003)(261021123027099003)(261022075727099003)(261026121527099003)(261009223027099003)(261028144727099003)(261026140227099003)(260925021911599003)(260925021311599003)(260925022911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZE54Yll3RTVvd2JlRGpOdjZVNCtQSisrVENSRlFpMUM2YnovR3RxMTNIcUp3?=
 =?utf-8?B?SUEyci9LbGxsallvcmpPRmVDNEZXOGRBN2g5M0FDcDFKZmNzVzBxS0w1Tk1L?=
 =?utf-8?B?dWg1bU1BNkZtQ2JGMHAraHM4QzZRZ0lEY2ZnRTY0bzZYVmdkbmpJd05FYUl5?=
 =?utf-8?B?ZmllQkJ3UjltcFlMV0NZL1VmQU83eG54a1RrRDZKSGdYbzBuQ3plb0tsV3hT?=
 =?utf-8?B?WTF1L1A4M09EdnFPNkNwUXRVWFAyNTdHamFpUVV4S3Z5cGRxMzVUU2U5b3VF?=
 =?utf-8?B?U2MzZ2orcjJrNUlNdUdxVSt1bmV6RHdiMURNZnlaSGxwbDkzYWRmNWVWNWNK?=
 =?utf-8?B?TXF6Tk1Xc3pXSHpLZkkvNCtPVWcyenc0RVIxKysxRTdUaTRYY25HTnhSWjd2?=
 =?utf-8?B?YkVVNUdkTVBPUHhQN0ViRDZzQnpBZGtiUXdSVmRQY2RTOVNSTzRBazVMdUhs?=
 =?utf-8?B?Qlg1eXI5YXl6ZGZEZk4zZG4vZTcwb1JyKzYyMG11L0VCa2hFOFF5K2gvd3U3?=
 =?utf-8?B?RnJmTGxNSkVpWEdZS1JQN21CazE3NlcyaWxPNFBFS3R1NUpta1phR0gydXZO?=
 =?utf-8?B?U3g2M1hNRFNoK3preUw3d0UxMCt6cVBERVlUOU1qTHhiMmxvcyt3T29iZmtN?=
 =?utf-8?B?bGIzOTJMWUxadmQ5cVVES3VGRnlJeTNsdVBtYmNpaFpTd2FVNDNkTHJJYWd3?=
 =?utf-8?B?TGlIZEFKejA1RzB2b0VTWTJ1VnJkMm1WdXVsTCsrWGx2bUJ3a2ExOUdUVG1G?=
 =?utf-8?B?dVBPaW5BUndLVzltU2pyRERwTG9BbGNVNEtjbi9xVU1XOWRzaDZ1Mkw0UHJM?=
 =?utf-8?B?dXdiUVVpYWV3U2hNMFdsaXpMamdLWVhQUlEyRm9QcE1ZQzJqcStObUVmNyto?=
 =?utf-8?B?MCtGZDhWWnlVQU9VbmtoOFpIZDQ2YnBoMGp6bFREL0RrSXFGb1oxbkRsWkI1?=
 =?utf-8?B?QVJWZVk2dlN6WENZcHJiMXZUc3JyMUhsWXY1bFNPcVFOWVdDWmZsbVJwTDIx?=
 =?utf-8?B?b1NBcjBiMVBoWEdzSWlmT21ZMzRKTW5vR1B1bUFHVTVuVWI0dmQ3TjMwdTFh?=
 =?utf-8?B?YUIyam4yU3dYdVNTQUM0WDdWcW8xOHpkeXFyOGh4RklzanQ5bVF5S3Z6djRZ?=
 =?utf-8?B?djNpZ1JuMkJlekp4VVZURHBoUlRBRlJDWU9JVmd6MkpDTlpaZVgxNFdCTGZk?=
 =?utf-8?B?ZXY3ZFlGMGhiMnN2cGFnWVpEVnlnK3FmSkdSNGF3U1BJVjB3RDZhMC9uVW9y?=
 =?utf-8?B?STRkMHMzVHBzTE8zVitsL0ZLN2MvU21JYWRDdHY0K0wzQWNyZmNEWUhmZFhZ?=
 =?utf-8?B?bGE5Q2p1aGFhYmRsU0dTSnoyWnVQckVvK25GNytMTUpPeFVFd251dUxtamR5?=
 =?utf-8?B?cTZCU1Vnc041UFdIZlU0bGs5Q3RXM3JaUjZLblhId1E0eC9RZytLdE81SXgy?=
 =?utf-8?B?Qk1IRmV6Vi9sTXBvQURUWCs4bVlRMXkrMnVJbi9GU0szeGRveUw1cWZnVXJK?=
 =?utf-8?B?L05JZjdEV3NGdmkvMFYxbExmeHN2a0NEc2NmZFBYMlZGL1lZdlZmcWtUdnJr?=
 =?utf-8?B?R21NRFZGZ2o2bldLdG52V2hQa3ZlSnNram0weUNCWGtqUlFMTHlabWFFTitk?=
 =?utf-8?B?dG1lZXhkM05nazh3ZUpMVkRsTDVRL3I5ckdCSkFzQURZTm12TUR5NGFlYVN5?=
 =?utf-8?B?ckxNS3pUM0Z5c0xPWmFPd2JjWFpFTVpxM1J3ZXZ5N3dvM2MwMUxXeGdhMEJ5?=
 =?utf-8?B?anNsTWduaXhnUDgwVXdDQ21qOXVqZnRBaWFVczlDVm44SnFwREx1TUx3cFFZ?=
 =?utf-8?B?NXI3NW13ekRUZHJXeXEyQkh2TC9KYnVqT1lZNEdKeklhKzlWL1pzSFlCNmxx?=
 =?utf-8?B?akYvUjdSRVp0TlVPTlZUZlh0c3ZIN0txRVVITXRzb2VSTzQ3dHUrcFZEVXFM?=
 =?utf-8?B?Y2ZIeEE4TVhrNndxUkVyOVRrd3FEaUFqbjFGNVFDTndXTEFJWm9pd3NpVUl6?=
 =?utf-8?B?TzZjWWhGUmhnSG5NcjZXN1pHZ25CeTFEZjcxRXNmMSs5WFloR3NmUnFBbzd2?=
 =?utf-8?B?SnF3cXJDZzlJZ3hxZzVUTkl1Y0FyVFlWVHhyYkVGNEM5ZnVzTk1mNSs0dEts?=
 =?utf-8?B?M2U2cnlnMDZTL29JRndSVXBXMGVRZG42UkZQeFdGMHg5RmN1STdJNUpUMWp3?=
 =?utf-8?B?R0xxUlA2Mk0rTk1iN2lQelU3WXkrUGlHSU91TWFnNGFLS3ZaR2s1MkEvaXJi?=
 =?utf-8?B?ekNqMkVSWTlUM3UzQW1nRExraTRrUHpYbkdGY3Q0NlhRYnZzdEdWQUtKaHZr?=
 =?utf-8?Q?x+8grgTPtNop0SYr5i?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 188d5245-e017-4d26-589f-08df39bb0fe0
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 14:59:29.9907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lVYsJWtq15DNiVQHbxHGGXq7RWEj0AaSXd1d6EpnkAL8DPxsMdH985X9k7Oan5Zks2DqoYMkUmhNSQOw61RZCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6286


On 11/2/2026 6:45 PM, Borislav Petkov wrote:
> On Mon, Nov 02, 2026 at 06:07:35PM -0600, Kalra, Ashish wrote:
>> LGTM, tested on HW.
> 
> Ok, thanks.
> 
> This below is what I have now, and the code looks a lot better. If there are
> no more complaints and it looks like what you tested, you can wait for me to
> push out the two patches and then you can test tip:x86/urgent again.
> 
> Thx.
> 
> ---
> From: Ashish Kalra <ashish.kalra@amd.com>
> Date: Wed, 28 Oct 2026 19:49:22 +0000
> Subject: [PATCH] x86/sev: Clear RMPOPT when segmented RMP is disabled by
>  firmware
> 
> Segmented RMP support is advertised via X86_FEATURE_SEGMENTED_RMP, and the
> firmware enables it via MSR_AMD64_RMP_CFG[SEG_RMP_ENABLED]. The latter can be
> cleared in platform BIOS by the user, in which case the system runs in
> contiguous RMP setting.
> 
> snp_probe_rmptable_info() does not clear X86_FEATURE_RMPOPT in the
> advertised-but-firmware-disabled case.
> 
> As a result, this does not prevent snp_enable_rmpopt() from trying to program
> MSR_AMD64_RMPOPT_BASE, which raises a #GP on the MSR access.
> 
> Make sure X86_FEATURE_RMPOPT is cleared in all cases where segmented RMP is
> not enabled.
> 
>   [ bp:
>    - Put the commit message on Ozempic
>    - Simplify snp_probe_rmptable_info()
>    - Fix feature check order in snp_enable_rmpopt()
>    - Add RMPOPT feature dependency on SEV_SNP ]
> 
> Fixes: 15d974be0a3b ("x86/sev: Initialize RMPOPT configuration MSRs")
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Link: https://patch.msgid.link/56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com
> ---
>  arch/x86/kernel/cpu/cpuid-deps.c |  1 +
>  arch/x86/virt/svm/sev.c          | 17 +++++------------
>  2 files changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
> index 99801e844b30..acbcec394ef1 100644
> --- a/arch/x86/kernel/cpu/cpuid-deps.c
> +++ b/arch/x86/kernel/cpu/cpuid-deps.c
> @@ -93,6 +93,7 @@ static const struct cpuid_dep cpuid_deps[] = {
>  	{ X86_FEATURE_SPEC_CTRL_SSBD,		X86_FEATURE_SPEC_CTRL },
>  	{ X86_FEATURE_LASS,			X86_FEATURE_SMAP      },
>  	{ X86_FEATURE_INVLPGB,			X86_FEATURE_PCID      },
> +	{ X86_FEATURE_RMPOPT,			X86_FEATURE_SEV_SNP   },
>  	{}
>  };
>  
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index bd70c4d0b774..417e6a41ac60 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -669,10 +669,10 @@ void snp_enable_rmpopt(void)
>  	u64 base;
>  	int cpu;
>  
> -	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>  		return;
>  
> -	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
>  		return;
>  
>  	if (!rmpopt_soft_init)
> @@ -819,18 +819,11 @@ bool snp_probe_rmptable_info(void)
>  {
>  	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
>  		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
> -
> -		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
> -			if (probe_segmented_rmptable_info())
> -				return true;
> -
> -			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
> -			return false;
> -		}
> -	} else {
> -		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
> +		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
> +			return probe_segmented_rmptable_info();
>  	}
>  
> +	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>  	return probe_contiguous_rmptable_info();
>  }
>  

LGTM.

I'll wait for you to push to tip:x86/urgent and re-test there.

Thanks,
Ashish
