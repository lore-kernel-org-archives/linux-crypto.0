Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6A47A715;
	Thu, 18 Jul 2024 10:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721297520; cv=fail; b=Lx74epYhkcpuQTGxhryUNW+XBn42j7IMMJKfxjOEgvLU0aYzOeoty5++iWatRtcbq+UYcBEp9/6AIBq2gSupsNGbAeqsf80AMWZ006JRnds+cUePg1ui9P8vPHe+ioXGYHAHseBzIURPLoTUtujxlYYoa6w9GVW4MoMTuirCrzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721297520; c=relaxed/simple;
	bh=17P0Q6UP7XQGkmxiCUjfT8fVWAy0kJk8onhgymjkmrQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n9r4wiAh4VNq7FOx1Bvs6j6UqtyVatIjmgsur4mVWAGbVlV+w2PQiTqPKAIBwpCIGBotxvhC62Rh4OHsjzZ/2h/yJmw7VCXpEyM8DTYm8sfPS2cxL0d7InKlXWFN8eq5ikBjcwh9hvfKEovBv+XvKdkUxn1d/FpOKGOcH3zXMBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=LB2A7q7N; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="LB2A7q7N"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46I7P9SM015486;
	Thu, 18 Jul 2024 03:10:34 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 40exmt8hup-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 03:10:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZzsXUwSv01LKjuVb4zFzBiEFzNVDkc9cT7KpcKSnr9/NWOWE2bN32WKRRs31vqS/LdN9GjVJkNZb8MwfRcY3Mh47wdEYeTIl58NwMs0JH68nZN0uPBTx90IkNwv4I4jgwmWHayDgK7aJDeqn2l9Oh0K/59q3+zbRj+Y6kGFFoRD6muzvfvC9S/VDmD7GsTGJG2cQiOuPRz+1wjXDFyTB0J1IN0UVf8/aXLMEuE8cPsJcCMl998gnfSG/fp2iWpB1lk5KEbi4FzsJ8ZyxVCERUFGyp5FPpHyrBPbRteuuQANgO04CkhCKxgsMHNHpQzTGINxAPGO0LP98kcKWvgxebQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=17P0Q6UP7XQGkmxiCUjfT8fVWAy0kJk8onhgymjkmrQ=;
 b=V6TBrlPpPM8Z61ChVJ43FstsLVJpuPlOk3SnBwXo6Sqa7DWcTzqOoHfJQJPmQcORpAtuDiTxPWYqDNRClutdqObyx3Medv2eAYyRQyCjG5GJ6q/ZtXoOQTb4n1wEXfTqSCW0IrmNijoX1Bl8K6ZwAXrrP6hxu5+EbnZEC8btf3nhbwtfhNwafJlE1w5x2gHLl8JXHFrXMlZU8a2iEI2YlTbuyS+pn7s0T5KDu3SPpomJkFvzVxkvWLocYJ8e/jKGGbcaB+o3tmiBYwSntaUpUmXGOfj6+PQwzJmlAy/UVwY+ULImlRJNpWt143L5kVwLMx6W63y6n4AT5Ke3XtveaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=17P0Q6UP7XQGkmxiCUjfT8fVWAy0kJk8onhgymjkmrQ=;
 b=LB2A7q7NFxAPQ8BNHOkHaAFyOQevEM7h8S1aRsGX075sAT7FaOQApOO0KNnlls8/+AixcB+1qEhhq8k6/xNsjccNNrq59seM5PMldMUucsqSm9F+Y7vBwNMBMNQq0MU5pi3oGWt9IS73uM5REEDF3zv4DcCM/o9hqQpZ9PgKc6Y=
Received: from SN7PR18MB5314.namprd18.prod.outlook.com (2603:10b6:806:2ef::8)
 by CH3PR18MB5536.namprd18.prod.outlook.com (2603:10b6:610:165::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Thu, 18 Jul
 2024 10:10:31 +0000
Received: from SN7PR18MB5314.namprd18.prod.outlook.com
 ([fe80::f808:b798:6233:add8]) by SN7PR18MB5314.namprd18.prod.outlook.com
 ([fe80::f808:b798:6233:add8%3]) with mapi id 15.20.7762.025; Thu, 18 Jul 2024
 10:10:31 +0000
From: Bharat Bhushan <bbhushan2@marvell.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Francesco Dolcini
	<francesco@dolcini.it>
CC: Olivia Mackall <olivia@selenic.com>,
        Francesco Dolcini
	<francesco.dolcini@toradex.com>,
        "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH v1] hwrng: Kconfig - Do not enable by
 default CN10K driver
Thread-Topic: [EXTERNAL] Re: [PATCH v1] hwrng: Kconfig - Do not enable by
 default CN10K driver
Thread-Index: AQHazzj8Yap+zmGXuU+ZW1zlwARN7rH8VjTQ
Date: Thu, 18 Jul 2024 10:10:31 +0000
Message-ID: 
 <SN7PR18MB53144B37B82ADEEC5D35AE0CE3AC2@SN7PR18MB5314.namprd18.prod.outlook.com>
References: <20240625195746.48905-1-francesco@dolcini.it>
 <ZoiLd/Cezq2CS4Zp@gondor.apana.org.au>
In-Reply-To: <ZoiLd/Cezq2CS4Zp@gondor.apana.org.au>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR18MB5314:EE_|CH3PR18MB5536:EE_
x-ms-office365-filtering-correlation-id: ba35522d-8658-4bc6-1a04-08dca711db0a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?dWtmUUI3SmdUbWpTc0EyVTV1SjFhRm1nS2taeHIrTzh0YVRhRGRIbmp0MzZt?=
 =?utf-8?B?NDdoRkc4ekgrN2tTMDI5SnFRcW1nQlBXZ2ZlNk5xS2tWT2lGV0pNQ0dhVnpq?=
 =?utf-8?B?QS9BeFNWQzF3UHp3SVM2WDRyNGh5RUFETFZPTWtMOHB2YkpzOVVzcUFKR3FS?=
 =?utf-8?B?dW5UUllWQWNuRTBtSHZsV2NKd1JVZm1LSHRvMDRic29ONEVNcldnOGQxbE1J?=
 =?utf-8?B?R2RGSE5xS2ZpUkNMQzIyVWdTM3VIS3RQcFZxQzB5aE5vWjVFUk43MjZlNkNZ?=
 =?utf-8?B?V3lZM1U3dUhDY2NuelFGRTJNcTYyWXU2ZWRnMEF2ZDRqcDhRQ3Y3azVvOVB2?=
 =?utf-8?B?TUxZRGh1dVA3elJIZ3BiU1FYZHNVK0QxQStSS1FiRVQwaThyWHcvdmtRS05M?=
 =?utf-8?B?SjVma2gxWll0cFNZK3h0b0VaZitPaWs0cm5DQmwyQVB6d1IyNlF4RXpmUE5Q?=
 =?utf-8?B?ekNQblBqYzVkSWRSajZGMkxhOGcxYmpmWWdPbXFETTZMOVZjQWlkTzZJMDNH?=
 =?utf-8?B?NDNKSWJ3MGxSNHlrMVExbGJ5TjluOVRaSENKQisvOW9wNXFOY2pOd3RobTZv?=
 =?utf-8?B?YjRXcXpPcWZpOW1PSEFxbzdmaXBoNzlyNUxVS2FDS1V0N0NXQnVUQmhQekNa?=
 =?utf-8?B?aVBEcGhEUHhFektPcHAybFF4czZOSC83NXhFRGhwck51THV0TmFQeTM0bENz?=
 =?utf-8?B?eEY3NVBEa2NTZVNCZHlINnpRM3RVUVRjcDQybmRCUnMwaE1jbW50clFrNnhI?=
 =?utf-8?B?VDVFbnlhNmdzVTB0NjdHR0FCYThseEZERVkyNkpJd3VHbjhBQXc2SC9qak5I?=
 =?utf-8?B?WnpDak1mOHVBZjQ5V09RWVNSWDdCOWh2U3JaQTFuVFBYMTNNYmgwMU9XUFNy?=
 =?utf-8?B?QjlFRGxIUEwxSFBmcVBJcDRiRkU1RWJnY1pIb2JtRWYwSk5SeDUwNnRQVGY0?=
 =?utf-8?B?OWIzMStIVEtYNldNcXdiNXY4Nk5NOEczQm5WNzFTaUJSaGhUdUdXUlliVTF1?=
 =?utf-8?B?bU9XbVgyWDRWTWxFMi9qelVZbVdjS2NJR0RFTHVDZEZ0YWE4UlozSHVISGxB?=
 =?utf-8?B?ZGcydUkxZUtXSk9lU1I1eGpyK1JWSWcyQWhXRkNyeit5ZmR2KzNZT1U4Wisz?=
 =?utf-8?B?MG9nQXN6YzhZM3VUekM4OVp6MVpPV0N6K0hwMTRSY3A3SHY0aDJLcGtUK1ky?=
 =?utf-8?B?ZWZKTUZwbHZiSkVlTk1TM0J6QTVCUDlKeVJubDhHSnE5czVFV09iODBRZ2tZ?=
 =?utf-8?B?QUd4SFNtbDBwSHVWU0tZWkZQaFNlazdkK2VXaHVOU3ZsbVlwOEJFRUlNRFM4?=
 =?utf-8?B?cjkrVEc2cWUyTkdHcmp2aU9JRkFLQ09xZTFaWTVRNnFNaXVwQlJ2UnRkN1hR?=
 =?utf-8?B?WmNRNHVZTnhxQU5ibGZHcUtFREdkckdsOU1NbzRaMXBiTTA3dWpiWjV5MmhK?=
 =?utf-8?B?RE4wU0tONXVXT1NKa1FabWVteTRtTkVvTEVpcVZhcFcwZDJ0RkpFNlduSDJX?=
 =?utf-8?B?N2pELzBtR05ZS1p6ajh0M2NkaURvaEdReVlLNldpSGJpQjNtUENIQUhGTkEr?=
 =?utf-8?B?MDFZbFhlb1dtWFo1aTg2MEtGT0NKZHkzV2xNOHo3WktTbXg3UWlwWUU1d2N1?=
 =?utf-8?B?YkUzUWdlS0FsbGhsbWw4MVc1Smk2Yk9ZOWpCOG9WOGFlNE1HdVBVeWY3ZkRE?=
 =?utf-8?B?MWJDTmRMS2UwQ0NjejFtOHFQT01GQXJPVlhpaTN6SXdXa2lFUjRZbzhJUTN1?=
 =?utf-8?B?VmJ5SDRoNmxGaXJJeVBiTkFhbVZUbnNRTWtqbVpXYVF2bTlHU1lpRFVXUEFR?=
 =?utf-8?B?Z09xU3hpNXpPbC9rR254M1RwVGdaSytEUklGNHBCK2NBS3dJNE15WDllQUp1?=
 =?utf-8?B?NlRhakVtMkhFQkRiU1I1TlMvS2poanE1czRVN0pOaTFyNmc9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR18MB5314.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?OWtKM0l4T2puZ2dOY2s0UmFQTEt1NzBjL2VQNXc1Mkh5OEx6VTA4a0ltN3Ax?=
 =?utf-8?B?QmYwZTZQdzlnWS9UZ3FWRjM3aEU4Z0Q4cklBRzlwUXAxcC9Ba3R3VDJ5NTBR?=
 =?utf-8?B?UnFwTGFUeE5lWFRFeUJ1U1BWN2pNVUFrbUNDN3IvdjVBVDAvY2REalhUdy9t?=
 =?utf-8?B?K3RFandrN1VNekRXZVV3Zkl6OVNjdWdiUHZpbm8xcVRPczIwUWlScG1mZWls?=
 =?utf-8?B?VU9udjhFYVgwcUNrNnpETUtTeUs1QW0vbzlLRkl6aWE5cUtsUzVGYmo0UmJw?=
 =?utf-8?B?Z3dvd083WUk1T1BGRDFZdjB6UEMzcUluNEhpeGpuQld6aGFHMzFxaGV0M2h2?=
 =?utf-8?B?ajY5TXdGKzJGRnZPN0ZmNXVrblNFOHVVYmJ2b3FuWDBQa0hlUnNWWGhyQnp3?=
 =?utf-8?B?UmhONVJvZWpYMmhkbnc1a3RmSUJTMGl6Z3RaV2xVQ0F1QlRObTBrRkIvcHhJ?=
 =?utf-8?B?Ung0SnViODJoZGUxR1p0TGVrWWpiRTg4Zjg4SmUxbmg5NWdZam1ZWm53bm84?=
 =?utf-8?B?WTZUMGhnVFpYalJUakFwMlJPWDd2RHRTcFZOdGE1VDI4VEdDcFFQejZXa1Yr?=
 =?utf-8?B?NmxGdHJibks5TlBabUdpNzFVclZESW52eVJWbUFLOFIyL3FhdlUwNitOUVFp?=
 =?utf-8?B?UzdMUnY5VXRvbklDZUtQWWplTkN6UWgxTGVGd2c0RjR3TzVjM3l4Vnh2V2tQ?=
 =?utf-8?B?TnFDUU5lQnR3VkkyTFk0L1VGZFM5SWxNL2dwVGM4V09nanBlRFVvVTNoWm5G?=
 =?utf-8?B?Z0ExRE1IY0VvcHZqRUdqdnUrOElJWUlYdFpaa0FnaGNMaFc5RUNzQWRqck1X?=
 =?utf-8?B?NWwzUTBrMFRNU2RMUWtZN095VTZzM1g0RGJ3THpCZVpuWmh1d281RUU4ODZl?=
 =?utf-8?B?anhyblcxZUdmTnNoNTFFcVVvb25WNmxtdGFzd1dlUTNZWTF0ZnZzYXBXUXB1?=
 =?utf-8?B?cU9rUktPRUlHdWQ0Mlo5dVhCSWNIclBUSTNzV1F2Z3ltOTl4QkR5OExPcGR3?=
 =?utf-8?B?d0xDNHBhL3VmSklyK1FaUnorQTJ3VUdWbkZlYTU0MUN1SlpqV3E5YjhKSGIr?=
 =?utf-8?B?ZWRFS1ZTRG5uV1VmSWMxdEI3YmZRUHhOalpHdkU4OVpBcE1HaExDM0tpRGdo?=
 =?utf-8?B?Y2pCS3FzbWU2Ly9IMmtGZ0Y5dTlHZFI3ZkxDTTlQM3BCSzFEdjJ5RjFGYWJu?=
 =?utf-8?B?dEJsU05JOTdnNEo0cm1vUkZlU0FVbTBKUEs5Qmt1eVk1eGxSaG8veEUxYmhF?=
 =?utf-8?B?NDRTQms2aG45clQyTE4xUUEvaXB2SlVtU2toTjZYTXFEVi9ob3FnbmUwMkJl?=
 =?utf-8?B?T0V4T3NTNzhma2lpUVg1cGcvZE1BbFF1RzFncFZKd2M4Y0dwT0EwZHRhS0Jz?=
 =?utf-8?B?VHVrRWRTYU9uVFJZNWtLdk1FZjRhTGxhK3Iyd0NHUWcreUxLM2RFRzF5RGxL?=
 =?utf-8?B?Rzhqa3NWSVJ1aUw3ME8yY2N3WnQyYzVmZUNoa1UzaVdsVmZiYVFZZDdoWHMx?=
 =?utf-8?B?eHpBMzVpK2N2SVZwK1dnbjZqS0RVOEw5NCtGU25aY09WbDlOOEZwZE9KL1or?=
 =?utf-8?B?SU9xS2JaWGYxNFV5dEhYeHpCTHI2U21XS1plUjNYVVdXZnErbzgvc1doREwv?=
 =?utf-8?B?cTdUbjJic0RPWUVDSmVpNy8zMWhhaWY2RWFmSmx2Q2dobUZaVktPb3ltcFVL?=
 =?utf-8?B?MkpRWjF3MU9lMHUrZlEvV2MwdGNJakt4eEVUN0FPaC9rUjVtYzVqbCsvU1pV?=
 =?utf-8?B?UWlqdzF6U2t6T243c01Da3h3VmdOTmpjQ1RoUVF0YjFnTitVZlkxaDByNkl0?=
 =?utf-8?B?WlkrQXQ5c3pxL0NvNXRSWVUyS000R3lzYjI4M2Mwb3FJVG1zWGhDMXQ4OUVR?=
 =?utf-8?B?K252OUpZSDUrRUhlRmdPL2RydmhDMnhFbHg3azdNdFZNeStTQllGWVUzTjBz?=
 =?utf-8?B?K2Q2SDdBb1hNVk1PZ0MrWjZyVE9QU29PcGxILzAxVXE3anAyUVE1MG5qUmo4?=
 =?utf-8?B?MnhBd1YxN2xvQTdIY2hVdnBSSHJKNk9kQ2xaemRFTk5aVnRtUEIzYW5CV2xO?=
 =?utf-8?B?NTBNTnRHTUc4VmcyNW5zSlhJRmJKcTF1dFpvbmlIa2FQNWFJTUN0dzJMcDBX?=
 =?utf-8?Q?Fg6ciMy2Lngv6nylF43YeE8J+?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR18MB5314.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba35522d-8658-4bc6-1a04-08dca711db0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2024 10:10:31.0735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 50YnfqZv4sxe6jHB05YnmWAIkkJAyT9D3NbpUar+r31IyDMmBzatbSuQCLc4JXqFODC83crFM+GN9s2fn20MkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR18MB5536
X-Proofpoint-GUID: y-VheY6XuiJpMxepsndSot59Wm3TnJl8
X-Proofpoint-ORIG-GUID: y-VheY6XuiJpMxepsndSot59Wm3TnJl8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-18_06,2024-07-17_02,2024-05-17_01

DQo+IEZyb206IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4gDQo+IFNl
bnQ6IFNhdHVyZGF5LCBKdWx5IDYsIDIwMjQgNTo0MSBBTQ0KPiBUbzogRnJhbmNlc2NvIERvbGNp
bmkgPGZyYW5jZXNjb0Bkb2xjaW5pLml0PjsgQmhhcmF0IEJodXNoYW4gPGJiaHVzaGFuMkBtYXJ2
ZWxsLmNvbT4NCj4gQ2M6IE9saXZpYSBNYWNrYWxsIDxvbGl2aWFAc2VsZW5pYy5jb20+OyBGcmFu
Y2VzY28gRG9sY2luaSA8ZnJhbmNlc2NvLmRvbGNpbmlAdG9yYWRleC5jb20+OyBsaW51eC1jcnlw
dG9Admdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1Ympl
Y3Q6IFtFWFRFUk5BTF0gUmU6IFtQQVRDSCB2MV0gaHdybmc6IEtjb25maWcgLSBEbyBub3QgZW5h
YmxlIGJ5IGRlZmF1bHQgQ04xMEsgZHJpdmVyDQo+IA0KPiBPbiBUdWUsIEp1biAyNSwgMjAyNCBh
dCAwOTrigIo1NzrigIo0NlBNICswMjAwLCBGcmFuY2VzY28gRG9sY2luaSB3cm90ZTogPiBGcm9t
OiBGcmFuY2VzY28gRG9sY2luaSA8ZnJhbmNlc2NvLuKAimRvbGNpbmlA4oCKdG9yYWRleC7igIpj
b20+ID4gPiBEbyBub3QgZW5hYmxlIGJ5IGRlZmF1bHQgdGhlIENOMTBLIEhXIHJhbmRvbSBnZW5l
cmF0b3IgZHJpdmVyLiA+ID4gQ04xMEsgUmFuZG9tIE51bWJlciBHZW5lcmF0b3IgDQo+IE9uIFR1
ZSwgSnVuIDI1LCAyMDI0IGF0IDA5OjU3OjQ2UE0gKzAyMDAsIEZyYW5jZXNjbyBEb2xjaW5pIHdy
b3RlOg0KPj4gRnJvbTogRnJhbmNlc2NvIERvbGNpbmkgPG1haWx0bzpmcmFuY2VzY28uZG9sY2lu
aUB0b3JhZGV4LmNvbT4NCj4+IA0KPj4gRG8gbm90IGVuYWJsZSBieSBkZWZhdWx0IHRoZSBDTjEw
SyBIVyByYW5kb20gZ2VuZXJhdG9yIGRyaXZlci4NCj4+IA0KPj4gQ04xMEsgUmFuZG9tIE51bWJl
ciBHZW5lcmF0b3IgaXMgYXZhaWxhYmxlIG9ubHkgb24gc29tZSBzcGVjaWZpYw0KPj4gTWFydmVs
bCBTb0NzLCBob3dldmVyIHRoZSBkcml2ZXIgaXMgaW4gcHJhY3RpY2UgZW5hYmxlZCBieSBkZWZh
dWx0IG9uDQo+PiBhbGwgYXJtNjQgY29uZmlncy4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogRnJh
bmNlc2NvIERvbGNpbmkgPG1haWx0bzpmcmFuY2VzY28uZG9sY2luaUB0b3JhZGV4LmNvbT4NCj4+
IC0tLQ0KPj4gYXMgYW4gYWx0ZXJuYXRpdmUgSSBjb3VsZCBwcm9wb3NlDQo+PiANCj4+IGRlZmF1
bHQgSFdfUkFORE9NIGlmIEFSQ0hfVEhVTkRFUj15DQoNClllcywgbWFrZSBkZWZhdWx0IGlmIEFS
Q0hfVEhVTkRFUiBpcyB0cnVlDQoNClRoYW5rcw0KLUJoYXJhdA0KDQo+QWRkaW5nIG1hcnZlbGwg
Q2MuDQo+Q2hlZXJzLA0KDQo=
