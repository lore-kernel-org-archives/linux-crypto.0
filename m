Received: from mx08-001d1705.pphosted.com (mx08-001d1705.pphosted.com [185.183.30.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9091D15539A;
	Thu, 19 Feb 2026 23:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=185.183.30.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771543335; cv=fail; b=Acv/F+axw9QWrPXNkdazBTuLiUQbZITpeSbYdF53eIlJbR+E6MEXWvXTu/hG2qnsrc3ED95SKwxb5ahs25TA+LrkbpT2BA5hTM4qe6/98+LWih5aRwI8HIX/ak8gTwcNlqgn/EdwT9BrLaP+9eVKv/a/42TH3LQdnmAX0R3d3A0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771543335; c=relaxed/simple;
	bh=u/i3k/3zG7xP21WAWIK/CP46RbfPiM6f93k3XSFGFBk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=az6Y+E8NiTpi3dx0Girf5+4PLYx/0DnS0mJwLTpqFvhGOCrIEOgAV6AzL/EI5XSTLxjNXWe6SdSmlC4jrU6uSzy/5YA2SrSurx12d540//j3PdeCDc59FafVwCP8MjT2/kbeigH/qcvBPTwBAcGKkZAdXZSNDzBNONWL7BF7xOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com; spf=pass smtp.mailfrom=sony.com; dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b=R5IJeq0q; arc=fail smtp.client-ip=185.183.30.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sony.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b="R5IJeq0q"
Received: from pps.filterd (m0209323.ppops.net [127.0.0.1])
	by mx08-001d1705.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61JJlIYS772628;
	Thu, 19 Feb 2026 23:21:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=S1; bh=u/i3k/3
	zG7xP21WAWIK/CP46RbfPiM6f93k3XSFGFBk=; b=R5IJeq0qrEtPu3l6FphR805
	8mBwMRRx+ZCooHU6gJOKgB8zg27QIn7ihYNK+z/zbgVWtg9SXGWDJhp4tMccKw7I
	2QtEADz65RdmtntxGFdAQ+KzWCh74N1Yfoob/Un7KAgf1/GHUmjVOUUNVqBtqSDk
	Y8liqk+VVQWfKco0hNVXIA/WYUy2SxaNUO186zs12TgNRdDIUDT+DPqbrsw3LPsP
	pXV49sVJoMfh/s9VJslfdL+nO85OBgTIeseMsc4A6ujVDeWvxbokL8kAcK3RnlJY
	zPjVEMLH3g0cl6xx2/HyiKWoihw36+8LwcunILJCbxgIqRefa+xVy0A3HLnjqlg=
	=
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010022.outbound.protection.outlook.com [52.101.85.22])
	by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 4caj2466u8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 23:21:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KiV7FAvhRiyHKSeiBQ8rEQXMsGjccByO3aSSHroZFJO1FQNuGKYeWX7QL4M9g1kk77qV5LfkVvJzpNUf7WyqsHzTd7r4bHu7j5997ONsaJBuHx7zqlEF1uYZWtt/f1J5lmNq65HgWoKk90AqYOe9eYNkZ3ZvZxSfqzO55TP6bdQYcRGYbSHAlTB5WFVxAbiDdaFAz6Kkfc0kN3nUt69jTDLaoffFA0Bsvmph/b7tkaeaquIsf1JAqmmTvhPOtmd0FmmZO5rWN63Pc+gR0PqWPwB493iBLwLoKJ9EeEnSi1IJPQs/HKvboj7TEm++NjKHnQLojJXpRsYdI3WmRjFZEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/i3k/3zG7xP21WAWIK/CP46RbfPiM6f93k3XSFGFBk=;
 b=tOuCl5MoRHt5JQxxVJDS8vmdaEILtZCDXVbsmn/Cs2Z/kfgtrJhZzjQ4z+x4DWqvDv4xpqMnpfTXeKKdICetKpM9vDcq5zjjuvdIc8MGoei1cUZ/ol+zm90gd76HWwjeFNQssr3hJ0eY//+PtPbmoHF+v3eIzhv/C6+nTnQHMJTFwO4uxtJj8eAC/WIAKkNzZTLeCt4MVHTJs8q/oMe6jy5n7dCbKsjCEI2LrDPsDtX9ve4Z9UeyEaJUHGULgiOtZqwM6KEzempgNoSem6aitTRK11ASgWx8QUFBdEyqNoECQ++m1CxF6t2YkBf/gPHLl4Lk+H4faJ+XCWfVN6uX4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from MW5PR13MB5632.namprd13.prod.outlook.com (2603:10b6:303:197::16)
 by SA0PR13MB3967.namprd13.prod.outlook.com (2603:10b6:806:9a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.15; Thu, 19 Feb
 2026 23:21:40 +0000
Received: from MW5PR13MB5632.namprd13.prod.outlook.com
 ([fe80::29e9:b355:cabf:66f1]) by MW5PR13MB5632.namprd13.prod.outlook.com
 ([fe80::29e9:b355:cabf:66f1%4]) with mapi id 15.20.9632.010; Thu, 19 Feb 2026
 23:21:40 +0000
From: "Bird, Tim" <Tim.Bird@sony.com>
To: Vitaly Chikunov <vt@altlinux.org>
CC: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "lukas@wunner.de"
	<lukas@wunner.de>,
        "ignat@cloudflare.com" <ignat@cloudflare.com>,
        "stefanb@linux.ibm.com" <stefanb@linux.ibm.com>,
        "smueller@chronox.de"
	<smueller@chronox.de>,
        "ajgrothe@yahoo.com" <ajgrothe@yahoo.com>,
        "salvatore.benedetto@intel.com" <salvatore.benedetto@intel.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>,
        "linux-spdx@vger.kernel.org"
	<linux-spdx@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: Add SPDX ids to some files
Thread-Topic: [PATCH] crypto: Add SPDX ids to some files
Thread-Index: AQHcoTQbBh6mZATRN02cQiVFWvtk77WJNfkAgAFwgeA=
Date: Thu, 19 Feb 2026 23:21:40 +0000
Message-ID:
 <MW5PR13MB5632D1755F187B28DB79E1FAFD6BA@MW5PR13MB5632.namprd13.prod.outlook.com>
References: <20260219000939.276256-1-tim.bird@sony.com>
 <aZZiNnEEIvAKgtGj@altlinux.org>
In-Reply-To: <aZZiNnEEIvAKgtGj@altlinux.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR13MB5632:EE_|SA0PR13MB3967:EE_
x-ms-office365-filtering-correlation-id: bd454b4b-bd07-44cf-07b8-08de700da2e8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VXJPalNtV1BlUjF6WTJlZjAxNkZOeDgwYjZITFpkcStLOGR6Y0lUcVhXNFpB?=
 =?utf-8?B?Zlk4eHUvYW93YUVCbGJoa1RBODJZQVlkejdFQ2IxNDFYWnQ0REcyTmhVU2ZG?=
 =?utf-8?B?RmI4b3R6NERBNmJWc2VlOUVaOXRSekFxSk5GektuUU53VUdvR2ZKaEVhbkI3?=
 =?utf-8?B?SUlSclB1dGVlR042c3FGTHJ4aFJ2QmJBbCtDSUp2OEVxOUlBOFIrKzllcitq?=
 =?utf-8?B?eXdjZlQ4SnR0bFJrV2U1cWpxcGFFQmZYYWhjcWlGaTNUazB3V3V6UFJrNTgx?=
 =?utf-8?B?eFV4Um5rd0dKdElNMGcyT1I3Ym0wYnhtYmc3cnBMZ0RpZGFacWUzOHg1aHM4?=
 =?utf-8?B?bCtRVUhiUCtRYU8zUWI5b0hxNC90U09aWHpHdWttNUJvK1prb01FSms3U3FO?=
 =?utf-8?B?a2J5K2pGUTFNM0hLakVEbXk2RUZ5d1VGZ3pUeGo0RGRyWG5jS0lwSDhoY1VD?=
 =?utf-8?B?dFBrRWRoQVR0QmJEMElOempvaWdTSUdtQkJwYVJJazRZemx3K3RXQ1ExSEc2?=
 =?utf-8?B?VW95Qm5QYmZuamI5MVhzZUJPaHRWTUEvLzhNaGwydWFEcmhENGdxelRMd0N2?=
 =?utf-8?B?dndIZlUvcnJmdzVqV2d6aVJmMWgvaGhUNDlBMThVK2srUkpaWEZzZHZubGRt?=
 =?utf-8?B?THc5OWhJV3lSbnQ2U3lCNkdJRE8xbjJnYlFVTjlrTXZaUEUxYVBaQlZwMTU0?=
 =?utf-8?B?Um1MRWU3TkxsSmE4S1VYbHowSnJaU1k0M3NMYktDSXo4UGlrcjUwZUw5SnZx?=
 =?utf-8?B?NjJBUHBFNDJaQUN0bWk5NksyT0VnNG5PM0xVT2c2MTlhTmJka3ZoOG8yVDU0?=
 =?utf-8?B?Y2tWR0xhYlRxWlZ6WGxEcGFOUzZIdUpKb1FaOVYvY0tycGZOOGtVNlZ1dmpI?=
 =?utf-8?B?enZWTEIzd3lYWHBrL3JQV1lJREMyN0xpQlJkUWlBU1FJelF0UkNTQXdRcERx?=
 =?utf-8?B?TE5PRFVySzRadU1WVXJodHNZV29XMEwvb3VROUttdkMvUjJQRXdKd2xqdEhO?=
 =?utf-8?B?TmZWd1NFUTBvaWllTU5LYVIwZ2JFSTZ2Z21NSGpwZWVOS0dPdkErbTFNa1Jz?=
 =?utf-8?B?ZnYwOHlERUZmRHJnUUorbHZ3cWxGSTZZQlNMUElWMVp6cHR3eVFxNTZ4YjFH?=
 =?utf-8?B?VHJ3cTgrL1l6RW5lVXY0TUQvem10aHdla2RxYTJuUlVveURnVjdxV2ZrT0hl?=
 =?utf-8?B?R3EyWG1SL1NvOXVweVd6ZWkzU2tzMW9PblVIODM4bW1WS0RiN1pNWHl1Z3Yx?=
 =?utf-8?B?SFY2d0V4T1ZvRU50MFNTck41U3pjNjU5citpYlFzbHdwRFJ6Tkw5VkdsVG9k?=
 =?utf-8?B?S3lSbkdxZ0t5dFFBeGp6RlJRK2xmWU5IMmo2emlyU2h1QXhaai9QdktRdlpK?=
 =?utf-8?B?YjJYQzRpOUZwa3dDdVAydHN4RTNNV1IxdHJ1SWgxMGFJQWhuVnJWZlh0anpq?=
 =?utf-8?B?RjhHRXpHNnloNkpIUjBhdzRBd3JGcVQrLy9ueGwxOC9RT2gvSUJHYWRaSjdx?=
 =?utf-8?B?bHlQZWZmWjV3QWlNZFJkNmZWV2JVdmZVaWdGMlVpN20wbDM1ak5vQ2FmSzdC?=
 =?utf-8?B?QVoyVnpYaHNDNmU2dElIWWExQVZDU3gwMU0vcEtJTjM3SEpFTEcxQnRielRV?=
 =?utf-8?B?OXREQVh0NnFFeHQwZDFjbWY1MlJkNEwwZjliL3J1ZkliL2pEMG9qcEd4ZStI?=
 =?utf-8?B?elRROGpNeGQ0dExHSFlwOXFFTTJXME1ZYTRQT0oxaHljQmQyekZhRzNadHdG?=
 =?utf-8?B?ZjVlV2VyeDNnNHF3cHVzNGhKU2RJM1NqZm9Wd0lmdzJKZGF0NmlON1lFMTNK?=
 =?utf-8?B?VjZUVkdEVGhLZjFCakY5SThhRThtZ3ZieEN1SE5lcWkxWWxxc2dUUmxnREY5?=
 =?utf-8?B?MVMyL3ZJVGw5QTVlMHdSRkh4bUhmUVRxTkNyOGZCQUt1SHFSeHJRS2Z6QkVI?=
 =?utf-8?B?MmN5ZFA3cVA1dHUwWDBGZzZGVFZCOW9Dbk5vaW0yZjE1Mi9PellONlNIR09n?=
 =?utf-8?B?TXpIaytDSDJ5clJJVStXbFkvalhRY2RNOEZabGN4K0pZNHMrU20yZ3R3dUJo?=
 =?utf-8?B?L1hWSmIrOWFTdjErMHdBdWx1ZnhHSDJvVE1GOXdPTUg4YVJ3VTFQUmI0dm5Y?=
 =?utf-8?B?OXBZMWZmUWVtSkx0d0swODZoTC9jenhpQVNKMVRjYzdOUTcxWVZnOWw1Y0dC?=
 =?utf-8?Q?pMiltH7E7x8dJrF7ekgTVPk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR13MB5632.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bFZwYUx6WmhjZ2l3OEVZL1N2emVpaU1ialVVcDdNQjRoYzYxT3JWM29kTWFq?=
 =?utf-8?B?a0hxMHZsU2dQRjRsU2dsdGo1eVRzRFdpMnZCZkpTUlpCaThQNTByOElRcy9m?=
 =?utf-8?B?dTlBQ3V2VkttOHRrU0ZHakRrZHl4dnlKcEFRVmV0T0M0WWphb0UvNXE3MmM3?=
 =?utf-8?B?bFcwY0N0R2VZNWVFbEVhUTFTVWd5MkxiT0FRY21WamtLZFNUbG85ZnpCMkJ2?=
 =?utf-8?B?ZUFaUkdsYjJoM2Q1Zm9IdnRFd0Q3bkhJbklOdTBKMkMwWklxRUh6aFJVLzBD?=
 =?utf-8?B?WUlBUlNzaEJFZkNlSThJdkxoOWU3VnBOYzNnaHQ4Ris5Wm11eU5lc2dPYmlH?=
 =?utf-8?B?dVprN04xNHFBSDVEUUVCY2dlN2RjdGJGamRBcG9FTmlUSmE4RkFDdXI2T1N1?=
 =?utf-8?B?cVptcHduckVVL2huZ2IyTU0ySSt4dUQrb2V6L1lFUGxuOGlRUlczcFBVZkJm?=
 =?utf-8?B?bDlkNldXZW5zZGQrb1o2UWlCZXZmVCtSaTN1c2IyaU8xdlBiRlR0aUg1RXNk?=
 =?utf-8?B?RUl2MGFvNWcwSThqOEVsSmpNSXhHZjB0dWxlUGNvcHlacW4xd2dMVUNwcXlY?=
 =?utf-8?B?T09nYVgwV2YwMnZONlhEUU90RDBQU2VhUkM4V3BWQ29VVVN4TXllQ0VSQlha?=
 =?utf-8?B?WjJyRU5zQmdGd2w4ZHE5cUJKVVJhMUcwS2Z5eVV5cThBT0tqeGxMS3pjbTcv?=
 =?utf-8?B?R2FMMk9WSnc5Y1VjY0MyU2NFb3pJUW5hdk40VHhTdjNXNTUvZ3c2azFjMWx4?=
 =?utf-8?B?WFAyQ01mUjZxNC8vcXM4QlZFNU5pR2tEQW91L2szaHkxd2VlbTJ0eDR5WEZV?=
 =?utf-8?B?QzJxUHRoUDhYYWlLNHR0RUV1ZkMxNGdtTmtRUUsyT1htcGRqa2RIVVRRS1NC?=
 =?utf-8?B?TytycXJuWVhnOW5EWE84OXdqSEFxRU5xWGlBTGsvSStSUG9SQzNSMjlPeWdW?=
 =?utf-8?B?ZjBudGRESEJrTHlWR3pWT01jT1BNSVJxNkR6OGhrSEVBVy93bEpXdTkxM1NP?=
 =?utf-8?B?OHJETUNVMEsrY2tPZVNvOEdXZ05qYnAyUFI2cyt2ZGczTlZvUXR1TmNHbHZu?=
 =?utf-8?B?TlFxWTltYkNOaWZBa3k3R2ltMG1BN3Jvd2tvSjRiWXVtK1M2NjM3QmRrdEhR?=
 =?utf-8?B?TUJoV28vZ3poVG8wV3VQd2FRVVpWNmxkUWFkQXlKdGhuOERsQ01xS2FJSkw4?=
 =?utf-8?B?N01kL3pHb0ppaTd6bTNIRnJGOTdjeFh6RlFNamU3VHEwM0VsRmJ1KzdVbFVG?=
 =?utf-8?B?M00yUHpDM0phcUxnNU83RS9sU3NaVXI3MkthbXpxZGdaaFY1Njk5cmhpUENx?=
 =?utf-8?B?dmRKdm1oM0tkNmRmcllwVWx6cHJhT09OTVhwbHRpUU9WTk9pVUplV1QybGo4?=
 =?utf-8?B?RURpNzdhTElTUUhNdjBQMFkwSExQYWszUnZzdlNId3hoQkhJTDJkTnNMbFgy?=
 =?utf-8?B?SWVKUlJmbVpsZnZ4ZmpDU3RQSXRwdWttTXh4Z1hXK1U1bnc0UFZvaU9PVkZt?=
 =?utf-8?B?OEp3ZjlGNVZYUU1SQ2xxZzFxVzNna3RMUG9adjE4MzI0NnFiWTFOalN6L2pt?=
 =?utf-8?B?Umxqd1pIdHl4TCtEVEdDZ0NRN2hGSE9EblIyMWJDQXl3TzZnWlpuWlpZeXdl?=
 =?utf-8?B?cnRaZ0NJNElCQmxyeDdrVzVQN0JqRnJhU2QwZkhJY2p4T2N2am9NaHFKZmRJ?=
 =?utf-8?B?SEErLzZKdDdCNEpzc2U3UFN0aHNrcGVnSytCM0dhTHV0U2c2eWUvdlVSOUJt?=
 =?utf-8?B?cUZPb0xsS2RHYTZaTll0V1ZDUzdZUERsNWdrTDZoOWZZcGh0R25pL0pHdktZ?=
 =?utf-8?B?SWR3N2lVeTUvNTlVNG1Hd2RaYU1mMmN0Q2JzWWY4VGpCT2ZHWEgzTWtEUnZQ?=
 =?utf-8?B?RHVSV0haYkJZQlUyeGRleHE0OXNhSWJSZitDaG9kQ2wxektzcHRFUFUvYVVS?=
 =?utf-8?B?UmZtS0ZmYURDREkwVVBWZWZFOExXVE11QkNWNy9aV09YUStkSnh5RXFNZm1R?=
 =?utf-8?B?VFA2KzVFYVJPNzNLeVY3ZzZva0lOMGRKVnpjWC8vSksyUXRwRnlmYzJGZFpy?=
 =?utf-8?B?ajZwUXQyLzlWeVdLWjZNa1hBLzBDTGhzNWxMOW4xb1owSW5ZOFI3NzJlQVhX?=
 =?utf-8?B?Tk96TEU5TlpyOTlWVjBGWVpha00wNnhSNC9LelE4WDJwQUU0bXRNUDdZUnM4?=
 =?utf-8?B?cFZHd0FOOFpoZFF0SGsvZnppbzd5K2JqMHJzeTIxTmNZTW4rcVVCcW1ITWtu?=
 =?utf-8?B?TnY4bVl6dnNsa0NNZGIrcWgyR2RFNm1CcTZZeWdNajgrV0h1YUEwMzJLYWZ2?=
 =?utf-8?Q?90PBBXCM7zHCptHoxo?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WFJPd1ClZxCvq+4o2ohUk7vO7IkXk01Uyf/bwA7gv3aUV2daNGc6VksEzcbxt+WJjpgIHDavqYUC1ZBuiAboTifeikctqhIzMNQ0lFoDNPla7FKi5FB0gPfY8z0TzCsNu4DaEHqe64QQzaxFh1b1+iNtnPRQ4q90xY0xwpOBsODtWdwtFEL8wXj9G02ALqI/Mnc4mgZSZaN5D1I4XoN9vYoh2DjVAYtov+GkpqI+0bEaUJe1w7hu8K07wEQGXIx7i+C62Tux7tLj2m6sFChmZ0w6tzQmDKBs35XxswQtdxJQmE22vdDRYACVm+Nyluzz3UFjaDZYslZmpAfdGY7L5dvQvJIec4wYkRxEjtYCIQSw1HM6EsLRaU26tFbcOUdqm6tveH/kjBH+9OMKOqMXeG7wfOWTDUo6gVQj1W+VBWLbCv0kSiy8F1p8YjtQ3frnH8G6ZvGQK4cfIz9HIIipXobRYwwX9NiWpq9LNw3Hi/4/TNqq+uJNgnp3jD5gckoqQvvzvw00G+6z0JNRTlUjPCkaWCj6o6pSZH4d5ydiBIFDNavOcNdcvyKjvEhhZ0ObPrF2RQn849w7uJ41HVrtj0iGxANkVXmoW8YrciSziz0nBRwUABTNxun21Z3w3en7
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR13MB5632.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd454b4b-bd07-44cf-07b8-08de700da2e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2026 23:21:40.2760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: an7Vig67Lv6GXE9dJoNWUz9quQb1WtaHBwX8SJfcWdBSoAyFmC/1HHCx/XxuZF3BSuRCU4cCEC2r4ZKWwuEO6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB3967
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDIwOCBTYWx0ZWRfX6XZtugZr7B3+
 W02KQzyUxfUWvJctIEDk+QwZ0lKWfOxOskZQEzo1jZ1OxTD4Z6Kj3ervpLpb5bNUoAnrqGA6Wjy
 eR1axLU+Z3tlZ/LJI90Ztw+nxrYNSA5lUS4jqf+dgf2JC7D8CUMsfb5v/fVNkDQdxb5xZFZ3QMv
 40yz7iIyI/zOWhvVIgmIuAaSgEjParKQHpyJI2y0BsTiAuclitXEMtLP1ihCQs2AkIL9M0zTT7Q
 ZAyhjp8WKlaUHgBfbAUrvTQ4g4afRCptLczebS5ZBGo94CKedolwQQP7D3G99f6KSQ7uuowhPwB
 QP487ITKBOuEoHe1h/sdGb+kfvXrtgV3sC69rznWzvgVAqOcNhQkYpog0BelFZJt8Mm8LMFPh5d
 rx89NtaAKHOjCqTRVscTeNDRm32rjAuwK9Ae/EY6vhgEtEyInBmAbjqGz2I1dD5c1V0+BUiG8Bf
 nzF3a3rIM1e/M9P14yA==
X-Proofpoint-GUID: 3LKGzzDP_6DINBmtqjG2TXKn0cNbHhtv
X-Authority-Analysis: v=2.4 cv=UcZciaSN c=1 sm=1 tr=0 ts=69979b08 cx=c_pps
 a=0Qqeoa/8LQ4SOC89qm8Uhg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=xR56lInIT_wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=bH78PYQqAAAA:8
 a=z6gsHLkEAAAA:8 a=CjxXgO3LAAAA:8 a=tXN3nQlnXBvBYzmA09QA:9 a=QEXdDO2ut3YA:10
 a=TrXR8j8ql9YpJ1_1srv2:22
X-Proofpoint-ORIG-GUID: 3LKGzzDP_6DINBmtqjG2TXKn0cNbHhtv
X-Sony-Outbound-GUID: 3LKGzzDP_6DINBmtqjG2TXKn0cNbHhtv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_05,2026-02-19_03,2025-10-01_01

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBWaXRhbHkgQ2hpa3Vub3YgPHZ0
QGFsdGxpbnV4Lm9yZz4NCj4gVGltLA0KPiANCj4gT24gV2VkLCBGZWIgMTgsIDIwMjYgYXQgMDU6
MDk6MzhQTSAtMDcwMCwgVGltIEJpcmQgd3JvdGU6DQo+ID4gQWRkIFNEUFgtTGljZW5zZS1JZGVu
dGlmaWVyIElEIGxpbmVzIHRvIGFzc29ydGVkIEMgZmlsZXMgaW4gdGhlDQo+ID4gY3J5cHRvIGRp
cmVjdG9yeSwgdGhhdCBhcmUgbWlzc2luZyB0aGVtLiAgUmVtb3ZlIGxpY2Vuc2luZyB0ZXh0LA0K
PiA+IGV4Y2VwdCBpbiBjYXNlcyB3aGVyZSB0aGUgdGV4dCBpdHNlbGYgc2F5cyB0aGF0IHRoZSBu
b3RpY2UgbXVzdA0KPiA+IGJlIHJldGFpbmVkLg0KPiANCj4gWW91IGFyZSBzYXlpbmcgImV4Y2Vw
dCIgYnV0IGluIGF0IGxlYXN0IHR3byBjYXNlcyBpbiB0aGlzIHBhdGNoIHlvdQ0KPiByZW1vdmlu
ZyB0aGUgZm9sbG93aW5nIHRleHQ6ICJyZXRhaW4gdGhlIGFib3ZlIGNvcHlyaWdodCBub3RpY2Us
IHRoaXMNCj4gbGlzdCBvZiBjb25kaXRpb25zIGFuZCB0aGUgZm9sbG93aW5nIGRpc2NsYWltZXIu
IiBBcmVuJ3QgaXQgc2hvdWxkIGJlDQo+IHJldGFpbmVkPw0KDQpUaGUga2VybmVsIHNvdXJjZSB0
cmVlICdyZXRhaW5zJyB0aGUgQlNELTMtQ2xhdXNlIGFuZCBCU0QtMi1DbGF1c2UgbGljZW5zZSB0
ZXh0IHVuZGVyIHRoZSBMSUNFTlNFUyBkaXJlY3RvcnkuDQpJbiBjYXNlcyB3aGVyZSBJIHJlbW92
ZWQgdGhlbSwgdGhlIHRleHQgaXMgYSBtYXRjaCBmb3Igd2hhdCdzIGluIExJQ0VOU0VTLg0KDQpJ
biB0aGUgY2FzZXMgd2hlcmUgSSBsZWZ0IHRoZSBsaWNlbnNlIHRleHQgaW4gdGhlIGZpbGUgKGUu
Zy4gaml0dGVyZW50cm9weS5jKSwgdGhlcmUNCndhcyB3b3JkaW5nIHRoYXQgd2FzIHNsaWdodGx5
IGRpZmZlcmVudCwgYW5kIHJlcXVpcmVkIHRvIHJldGFpbiAidGhlIGVudGlyZSBwZXJtaXNzaW9u
IG5vdGljZQ0KaW4gaXRzIGVudGlyZXR5Ii4gIElyb25pY2FsbHksIHRoYXQncyB0aGUgb25seSBw
aHJhc2UgdGhhdCdzIGRpZmZlcmVudCwgYnV0IGlmIEkgcmVtb3ZlZA0KdGhlIG5vdGljZSBmcm9t
IHRoZSBmaWxlICwgaXQgd291bGRuJ3QgYmUgcmV0YWluZWQgYW55d2hlcmUgaW4gdGhlIGtlcm5l
bCBzb3VyY2UNCnVubGVzcyBJIGFkZGVkIGFub3RoZXIgbGljZW5zZSBmaWxlICh3aGljaCBJIGhl
c2l0YXRlIHRvIGRvKS4NCg0KSSdsbCBleHBsYWluIGluIHN1YnNlcXVlbnQgdmVyc2lvbiBvZiB0
aGUgcGF0Y2ggd2h5IEknbSByZW1vdmluZyB0aGUgbGljZW5zZSB0ZXh0LA0KYnV0IGluIGdlbmVy
YWwgaXQgdXBkYXRlcyB0aGUgY29kZSB0byB0aGUgbmV3IGxpY2Vuc2luZyBzdGFuZGFyZCAod2hp
Y2ggaXMgdG8ganVzdA0KaGF2ZSB0aGUgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXIsIHdpdGhvdXQg
bGljZW5zZSBib2lsZXJwbGF0ZSB0ZXh0KS4gICBIYXZpbmcNCnRoZSAnYXBwbGljYXRpb24nIHRl
eHQgKGZvciBHUEwpIG9yIHRoZSBsaWNlbnNlIHRleHQgaXRzZWxmIChmb3IgQlNEIGFuZCBvdGhl
cnMpDQpsZWFkcyB0byBsb3RzIG9mIG1pbm9yIHZhcmlhdGlvbnMgdGhhdCBhcmUgYSBwYWluIHRv
IGRlYWwgd2l0aCBhbmQgY2F1c2UgbW9yZQ0KbGVnYWwgYW1iaWd1aXR5IHRoYW4gdGhleSBhcmUg
d29ydGguDQogDQo+IA0KPiBBbHNvLCBpbiBvbmUgY2FzZSBiZWxvdyB5b3Ugc2tpcCBkdWFsLWxp
Y2Vuc2luZyBpbiBTUERYIHJlY29yZC4NCj4gDQo+IENhbSB5b3UgYWxzbyBzdGF0ZSBpbiB0aGUg
Y29tbWl0IG1lc3NhZ2UgdGhlIHJlYXNvbiB3aHkgeW91IGFyZSByZW1vdmluZw0KPiBleGlzdGlu
ZyBsaWNlbnNlIHRleHRzIGF0IGFsbCBhbmQgbm90IGp1c3QgYWRkaW5nIFNQRFg/DQpJIHdpbGwg
ZG8gdGhpcyBpbiB0aGUgc3Vic2VxdWVudCB2ZXJzaW9ucyBvZiB0aGUgcGF0Y2guICBUaGFua3Mg
Zm9yIHRoZSBzdWdnZXN0aW9uLg0KDQo+IA0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogVGltIEJp
cmQgPHRpbS5iaXJkQHNvbnkuY29tPg0KPiA+DQo+ID4gLS0tDQo+ID4gTm90ZSB0aGF0IHRoaXMg
ZG9lcyBub3QgZmluaXNoIGFkZGluZyBTUERYIGlkIGxpbmVzIHRvIGFsbCB0aGUNCj4gPiBmaWxl
cywgYXMgdGhlcmUgYXJlIGEgZmV3IHNwZWNpYWwgY2FzZXMgd2l0aCB3ZWlyZCBsaWNlbnNlIHRl
eHRzLg0KPiA+IC0tLQ0KPiA+ICBjcnlwdG8vYWxnaWZfcm5nLmMgICAgICAgICAgIHwgIDEgKw0K
PiA+ICBjcnlwdG8vYW51YmlzLmMgICAgICAgICAgICAgIHwgIDcgKy0tLS0tLQ0KPiA+ICBjcnlw
dG8vZHJiZy5jICAgICAgICAgICAgICAgIHwgIDEgKw0KPiA+ICBjcnlwdG8vZWNjLmMgICAgICAg
ICAgICAgICAgIHwgMjIgKy0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICBjcnlwdG8vZmNyeXB0
LmMgICAgICAgICAgICAgIHwgMzMgKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+
ID4gIGNyeXB0by9qaXR0ZXJlbnRyb3B5LWtjYXBpLmMgfCAgMSArDQo+ID4gIGNyeXB0by9qaXR0
ZXJlbnRyb3B5LmMgICAgICAgfCAgMSArDQo+ID4gIGNyeXB0by9raGF6YWQuYyAgICAgICAgICAg
ICAgfCAgNyArLS0tLS0tDQo+ID4gIGNyeXB0by9tZDQuYyAgICAgICAgICAgICAgICAgfCAgNyAr
LS0tLS0tDQo+ID4gIGNyeXB0by93cDUxMi5jICAgICAgICAgICAgICAgfCAgNyArLS0tLS0tDQo+
ID4gIDEwIGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDc3IGRlbGV0aW9ucygtKQ0K
PiA+DQo+ID4gZGlmZiAtLWdpdCBhL2NyeXB0by9hbGdpZl9ybmcuYyBiL2NyeXB0by9hbGdpZl9y
bmcuYw0KPiA+IGluZGV4IDFhODZlNDBjODM3Mi4uYTlkZmZlNTNlODVhIDEwMDY0NA0KPiA+IC0t
LSBhL2NyeXB0by9hbGdpZl9ybmcuYw0KPiA+ICsrKyBiL2NyeXB0by9hbGdpZl9ybmcuYw0KPiA+
IEBAIC0xLDMgKzEsNCBAQA0KPiA+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIu
MCBPUiBCU0QtMy1DbGF1c2UNCj4gPiAgLyoNCj4gPiAgICogYWxnaWZfcm5nOiBVc2VyLXNwYWNl
IGludGVyZmFjZSBmb3IgcmFuZG9tIG51bWJlciBnZW5lcmF0b3JzDQo+ID4gICAqDQo+ID4gZGlm
ZiAtLWdpdCBhL2NyeXB0by9hbnViaXMuYyBiL2NyeXB0by9hbnViaXMuYw0KPiA+IGluZGV4IDRi
MDFiNmVjOTYxYS4uMThiMzU5ODgzZDk5IDEwMDY0NA0KPiA+IC0tLSBhL2NyeXB0by9hbnViaXMu
Yw0KPiA+ICsrKyBiL2NyeXB0by9hbnViaXMuYw0KPiA+IEBAIC0xLDMgKzEsNCBAQA0KPiA+ICsv
LyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vci1sYXRlcg0KPiA+ICAvKg0KPiA+
ICAgKiBDcnlwdG9ncmFwaGljIEFQSS4NCj4gPiAgICoNCj4gPiBAQCAtMjEsMTIgKzIyLDYgQEAN
Cj4gPiAgICogaGF2ZSBwdXQgdGhpcyB1bmRlciB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vu
c2UuDQo+ID4gICAqDQo+ID4gICAqIEJ5IEFhcm9uIEdyb3RoZSBhamdyb3RoZUB5YWhvby5jb20s
IE9jdG9iZXIgMjgsIDIwMDQNCj4gPiAtICoNCj4gPiAtICogVGhpcyBwcm9ncmFtIGlzIGZyZWUg
c29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkNCj4gPiAtICog
aXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBw
dWJsaXNoZWQgYnkNCj4gPiAtICogdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVy
IHZlcnNpb24gMiBvZiB0aGUgTGljZW5zZSwgb3INCj4gPiAtICogKGF0IHlvdXIgb3B0aW9uKSBh
bnkgbGF0ZXIgdmVyc2lvbi4NCj4gPiAtICoNCj4gPiAgICovDQo+ID4NCj4gPiAgI2luY2x1ZGUg
PGNyeXB0by9hbGdhcGkuaD4NCj4gPiBkaWZmIC0tZ2l0IGEvY3J5cHRvL2RyYmcuYyBiL2NyeXB0
by9kcmJnLmMNCj4gPiBpbmRleCA1ZTdlZDVmNWMxOTIuLjQxMGNlY2M0NWFiOSAxMDA2NDQNCj4g
PiAtLS0gYS9jcnlwdG8vZHJiZy5jDQo+ID4gKysrIGIvY3J5cHRvL2RyYmcuYw0KPiA+IEBAIC0x
LDMgKzEsNCBAQA0KPiA+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMCBPUiBC
U0QtMy1DbGF1c2UNCj4gPiAgLyoNCj4gPiAgICogRFJCRzogRGV0ZXJtaW5pc3RpYyBSYW5kb20g
Qml0cyBHZW5lcmF0b3INCj4gPiAgICogICAgICAgQmFzZWQgb24gTklTVCBSZWNvbW1lbmRlZCBE
UkJHIGZyb20gTklTVCBTUDgwMC05MEEgd2l0aCB0aGUgZm9sbG93aW5nDQo+ID4gZGlmZiAtLWdp
dCBhL2NyeXB0by9lY2MuYyBiL2NyeXB0by9lY2MuYw0KPiA+IGluZGV4IDI4MDhiM2Q1ZjQ4My4u
YzM4ZTRiYzBkNjEzIDEwMDY0NA0KPiA+IC0tLSBhL2NyeXB0by9lY2MuYw0KPiA+ICsrKyBiL2Ny
eXB0by9lY2MuYw0KPiA+IEBAIC0xLDI3ICsxLDcgQEANCj4gPiArLy8gU1BEWC1MaWNlbnNlLUlk
ZW50aWZpZXI6IEJTRC0yLUNsYXVzZQ0KPiANCj4gVGhlIGZpbGUgYWxzbyBoYXZlIHRoZSBsaW5l
Og0KPiANCj4gICBNT0RVTEVfTElDRU5TRSgiRHVhbCBCU0QvR1BMIik7DQpUaGlzIGxpbmUgaXMg
bm90IGxlZ2FsbHkgZGlzcG9zaXRpdmUsIGJ1dCBtYXkgaW5kaWNhdGUgaW50ZW50Lg0KSSdsbCBk
byBzb21lIHJlc2VhcmNoIGFuZCBzZWUgaWYgdGhpcyBtZWFucyBJIHNob3VsZCBhZG9wdCBhbiBP
UiBjbGF1c2UNCmluIHRoZSBsaWNlbnNlLiAgU2luY2UgdGhlIGVudGlyZSBrZXJuZWwgaXMgR1BM
LTIuMC1vbmx5LCB0aGVuIGFsbCBpbnN0YW5jZXMNCm9mIEJTRCBJRHMgYWxvbmUgYWN0dWFsbHkg
aGF2ZSB0aGUgbWVhbmluZyBvZiAnR1BMLTIuMC1vbmx5IE9SIEJTRC13aGF0ZXZlcicuDQpCdXQg
aXQncyBwcm9iYWJseSBiZXR0ZXIgdG8gYmUgZXhwbGljaXQuDQoNClRoYW5rcyBmb3IgY2F0Y2hp
bmcgdGhhdCEgIEkgbmVlZCB0byByZXZpZXcgTU9EVUxFX0xJQ0VOU0UgbGluZXMgaW4gdGhlIGZ1
dHVyZQ0KYW5kIEknbGwgYWRkIHRoaXMgdG8gbXkgdG9vbGluZyBmb3IgdGhpcyBwcm9qZWN0Lg0K
DQpUaGUgcmV2aWV3IGlzIG11Y2ggYXBwcmVjaWF0ZWQhDQogLS0gVGltIA0KDQo=
