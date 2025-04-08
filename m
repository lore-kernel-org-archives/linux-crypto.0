Received: from esa14.fujitsucc.c3s2.iphmx.com (esa14.fujitsucc.c3s2.iphmx.com [68.232.156.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2E3204583;
	Tue,  8 Apr 2025 05:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.156.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744090769; cv=fail; b=M+taEwdj7dmcZOtlemHMbX7CUH24RoixM7JG3PGFvnVkZhlFtgpk9Ki7pwNlPZ89wFoqiPrj321h/xawDsAMsx9mJMBMa3wgqQb+H+M9vbuwcCdpqruA/Boq4oZwoe7Wy4xun3tmvhfkDYVYVZWq67JsUm4hqz0J8ntTecCvF8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744090769; c=relaxed/simple;
	bh=GFuSxmhKYn6STESuO3iWXrKf5NQFUo8tUnmdsmv3LvU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fpw+sAkh+BzbzL+OBnHmw8cZmgaIlvpXCMDlFM4oQR759vCUnhL1XpdTInB4yseUW7eDOKVKVOiPws54+1PcN7DPteOkGS8jPvi4w11K4Pt0vc/WgFMEWbdZk+s5+PfdQtl5m9frzsdQQOu5sDo4D9cuzq2n/1l5RlpMiFH7u10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=tsDJLYWC; arc=fail smtp.client-ip=68.232.156.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="tsDJLYWC"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1744090767; x=1775626767;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GFuSxmhKYn6STESuO3iWXrKf5NQFUo8tUnmdsmv3LvU=;
  b=tsDJLYWCts4NBehGCTDeL0gvKg6ogbmkOA6rcOhdKmAape74RCNLNPmV
   e+3uyDQFFo9pJ/s+H2Fqsqt51UiBCD6tCFN64uMpbatpLkCYQPkttkJHI
   rIFbSkUsJm+9yXF8L7PfebTagD9BmUWrcrMGLfDmlZKqYWX92/Mg4ZPYe
   VWEXxPi2Dn0v3MFbt2lNHz3g+Z5PKPZgqJex65jQwwdjf46mcyJCq2IcY
   CVGVz5p30HxcU9ZqGp+/RdWA0n/wri+YCS9BHX/mlg8C0K6NuBlagBWFl
   2BHQLoZjieSN/XwdlX6835V2DpdBEBmQYyHmDeUfX21TJDID0janxLMOb
   g==;
X-CSE-ConnectionGUID: eNq3s2f8SaWj9pb04/jSVQ==
X-CSE-MsgGUID: owiZ+jKCRVGKZoH+z9xEVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="151685196"
X-IronPort-AV: E=Sophos;i="6.15,197,1739804400"; 
   d="scan'208";a="151685196"
Received: from mail-japaneastazlp17010002.outbound.protection.outlook.com (HELO TY3P286CU002.outbound.protection.outlook.com) ([40.93.73.2])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2025 14:39:17 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W1lefCV0kuFn7To9KUY/k2dKsgg9U71tEUA4jcKDJb/0CXFPvoIUmQbRiAAqXL+IIeKldWOEcpzF+rQ8AAFEmhQPEMpCNS5cONn4qVqujmPJMk6NSYYRARvJ+z9ggYzrX8JcjGKtdxgYLRgjI+WEc/DNhK+hGEFEa8aiyJaMhsm8l2tVrqH700mHcwj5wL8t3Dk03IVewvmhWklNS7c9UD4vDEM+9rgXYnTVeOPq6tZfeGhAGNBXKGIXwZk/+hiI2yuXh2jbdlNpLG6sVFdnvf7MccPjMHqg7beKxtIreM+/ifH3+80ishsfaqcx2GXQrnQqSxHN5lIwqUdaBUQACw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFuSxmhKYn6STESuO3iWXrKf5NQFUo8tUnmdsmv3LvU=;
 b=cXkJAxANBluAP3A+y0NCFOlGQEIY0sNk/vjJ1hIYFsbz+euHHDfJKflPmA7Q5ZQh/8OB8s35qWm3vrYYTZPTmaCtTNt5/DbTGIjo1nB7ZZmxiNP9bpWbDqAuRKiv4SWDHQz/we8OXqL59QP7sBCb+JaEzzYw6+p2wh+fNW58x1HdD6IPsDlZThN4tAbLdre+pDKQTCEQC+I6O5SCcuDsPFANAJa//ueocU0fTZjKfjPEfp930O/w+QNUSwfmQE+YPy2uMQnNO3+SHOOarAWulugrxmjWzFO5ey/WGjsPzSOaxFkBqvkRHESnS36gbjPx2/+zNJU/ilrb9chYY5p18w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by TY4PR01MB12733.jpnprd01.prod.outlook.com (2603:1096:405:1ea::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Tue, 8 Apr
 2025 05:39:09 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%4]) with mapi id 15.20.8606.029; Tue, 8 Apr 2025
 05:39:09 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
	"alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
	"linux-stm32@st-md-mailman.stormreply.com"
	<linux-stm32@st-md-mailman.stormreply.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Erhard Furtner <erhard_f@mailbox.org>
Subject: Re: [PATCH] crypto/testmgr: Fix acomp_req leak
Thread-Topic: [PATCH] crypto/testmgr: Fix acomp_req leak
Thread-Index: AQHbqD0S0MeQRANwAkuj6EjwIPLoc7OZKyWAgAAVeQA=
Date: Tue, 8 Apr 2025 05:39:09 +0000
Message-ID: <2693ad49-a706-417a-ae96-67bc3b679fe8@fujitsu.com>
References: <20250408041647.88489-1-lizhijian@fujitsu.com>
 <Z_Skef-ZAYAzPfOF@gondor.apana.org.au>
In-Reply-To: <Z_Skef-ZAYAzPfOF@gondor.apana.org.au>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|TY4PR01MB12733:EE_
x-ms-office365-filtering-correlation-id: fa1ed245-26b6-4d51-e4f1-08dd765faf80
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700018|1580799027|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?bmJSYUVHWUhnRXJ1YjRvOG5HYzBpL1k2c2M4dTFmSnZLRnFnU2pIMGdxM0V5?=
 =?utf-8?B?OGlNMUg5SjB3SVIwdC92SDBhaCtwVVMrMWNTeEgrYVJZS3JTSFJzS21kM0hj?=
 =?utf-8?B?Snk0cHpJbVQwUEQvUkNCY2xWTlA5M1E5bTVjcGRpZU43ZWN5UjJzWWR2bGx4?=
 =?utf-8?B?Y1pEZHM1RERyV0dDZ01CQTA4ZmdwdGt2cWhseWM1bWwyVHgwTi9OU1BndkYr?=
 =?utf-8?B?c0RmVEZ0dWdhUUl6S0tod08vaTR6K2pMTFhIZDZtekpmZVhDM3Z5N3ZLa0xJ?=
 =?utf-8?B?blFwcFkyT2Z0V1pvNWNoZUlkQ2gzVndtUTBJdDNVYjE4cHNlTFVZMWRlcnEv?=
 =?utf-8?B?akhvbXovdmJWSEhPaGV1Tk55V3RDOU5rbkxkd0FxOTh6T21kQmFzdWpTMkVQ?=
 =?utf-8?B?WmlpMU1lM0FwaUFMVkNLdlMrWWw3bEZ5Y21jeW1UWkIyRThTRkxVVkxyR2VJ?=
 =?utf-8?B?UkhIbVIrWmxWNEhmcHF0SnZsMWZYalRHL1dMYXE3ZlFCL1pkM0hBaTNaWm0x?=
 =?utf-8?B?Q1MrMk5SaVhQUVBxbkg4SHBGUTlHWmsxd2l5TTNvMlBTTFBqTXgxT0UwUWU2?=
 =?utf-8?B?U2ZzVEJIMVg4aU5qU3g0OC9sWEMrUm40Y3pyOXIyeU5iVGYxNVplZTZHTTZB?=
 =?utf-8?B?QzNJWGdXQ1pOcjl1V0N3Tmovdno3dFF4SVE5YzM0N2VOc2lveFBBcVdVSDV2?=
 =?utf-8?B?aXErandvaVhnYWFJK2syQlQ0ZlR5YUsvVzRteFdLU2toQnh4NXVNSTJjZEFZ?=
 =?utf-8?B?K3lQQkJKeXdKSkluZW9uaVUwOVBlUk9acXVJQ1VHRy9DenQ5ZHVzS2U5eU0r?=
 =?utf-8?B?bk5qWXZUZEFYVlBGdXNYNnNJUFlUbzdVVTdaRXFMSzdUY2pvNEtWdFhpQmkx?=
 =?utf-8?B?VlIvTmxWYm1nemVtTVlwRkNmMUpZSFFTbGhsUEV1NThPd0k2cnFoUU1NY0pP?=
 =?utf-8?B?dmIrOHNNdEpueVQxNWFGenpzRFozWWo0R1VOak1WTGJSSGJhdTNBdFBoY1Jy?=
 =?utf-8?B?L0hvZGlKU1V2NXdmM3Y5UFlNTmxhdy9WQ3kvYWR5R0dyUVhxdUJHWFZsbTM0?=
 =?utf-8?B?K0NFWTc3d2NiMGZXNVJPeWN1S1BoL0xqNFBMeStsdHJJYXA2TW5vZDBGYkth?=
 =?utf-8?B?MUNQUUhERWNBekR3K1d1M2ZJWUd4NThDT2NVSnB3UzRhTHJYSmJDVXJhTWZQ?=
 =?utf-8?B?Q2RoZUhCY2c4VjhGVTMrY20xSWJzTVZOUkpxaGE0RHRzQm5hcE95dHhyeExM?=
 =?utf-8?B?bVF5aXIrVXBONHpXUVB2ZXRlY3lURUE4U3pudDBvVlgvVllsWDdEREplK3Zl?=
 =?utf-8?B?bmwvckVpR3FvUGZXQlVncVZQaGtSOGJ2UHM4aGx1eUNLd3lXT0h2OHFRdzls?=
 =?utf-8?B?anV3c1A4MWFTd0FKZHRmOHdYT2dpUDNWNmtIYW1JZjZzSXFlUkllUkc3K2VR?=
 =?utf-8?B?ODBDNnBVNnhxelpORWo3ZXVZcmhGME5FVU5mdE9ubDJhckJHYll3Q0FyKzh1?=
 =?utf-8?B?WWtoNHFBL2xMSkxlK3pvSk1rdysycEV0WmtHbStnU0FhdnQvOWhld240RTBP?=
 =?utf-8?B?V2tTcnBLQ2dobFJFdThhY0o2V2o0dTNvUjYwdHoxMk90WDNpd3Y1ZXJHQmRD?=
 =?utf-8?B?NDlqTWlScXJTdnZnZEltWmthRTkrYUhTZ21SdFZWV0doejVoTCtYSllsbk4v?=
 =?utf-8?B?TWJmOU51RTdKZDhGVGtqSVpDc1FkOVN3ak4yZU50ajdTSStucmZLUTlOT2ll?=
 =?utf-8?B?V1R6bXpkeUpuSFZUM3UwTXFnZ0FMZTFaaU5CLzB2R0RMclcwSHBmRTBoRTBF?=
 =?utf-8?B?TGZsU1BLTUg1RnZSQXNCOHlyY0craHBBenBTdVVGcEx0TmF5aUZWam5NZzZa?=
 =?utf-8?B?b3RVakxsb0trSDZJUUxPWEpPVDFFRDVZRCtqUVQrcjVVTHREZEZHSGtsNDhY?=
 =?utf-8?B?M2RaL2dkUTViQjkzbElxS0tTZEhUUFgzOEdLd1FKUWwydkcvUWRHSUJmZ21S?=
 =?utf-8?B?NTlPOVpIbTJ3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018)(1580799027)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WmhFdW4vcGt6eHBub0tqTWVkcDRHblV6blZBWnR6bkEybEZwZXp1SWY3SEJO?=
 =?utf-8?B?YkREendVWCthbDR0YWg4OVZySWxYdlRuQVcvSUV5N2NwdXFyTVZsYmlzVFVX?=
 =?utf-8?B?ckU2bVhWMEt6Z0dvbWpYcDk0aXhqNEFmbnQ3cFl6SWhHR054THlwbW5tM1g5?=
 =?utf-8?B?Y2NiNzJPeXFWc1ZEOW82cnA4c0pRMUE5Sk4wTFlYOEYvOXRmUUQ2a3hKbDNr?=
 =?utf-8?B?SitMRDJLM0htMFZwZHcyMWdzMkJaaU5tRENwK0VQaS94aTFRamZjcTRwOUV0?=
 =?utf-8?B?Wi8yN1YvK1RJVlBqS3VBSkQrK3FXTHJHcnpKSGFWWk1hZnpWeHNXUlp1WEl6?=
 =?utf-8?B?SDdyWGRXQnFLc0VuUUFIYVBUTEZYeDRSTHBaVFN6aFR0UHhJOXl4dzlJZ3B0?=
 =?utf-8?B?ZlJ1NEk0WXRuczNzekJxa0NlWkVzK3VsNXhhNE5aaVhvYlZ0K1kzZEptbUN4?=
 =?utf-8?B?aHQ5NDJFYzd3b2lHZ3RVQWJZdTBkZndkUXFnc0p0WTQrV1BvajlrRFJqSTBh?=
 =?utf-8?B?dGcvOHdVUDd1c3VuOFYyYjZHc3VlNFpLWHUwdDFUQVdVczlDYnE5Ykd4RGtU?=
 =?utf-8?B?RkNPcEc0VlpoUTVJKytCYnh2cGJaK2pveHNBRGpjZHRDbytYS2pZT25jaVN3?=
 =?utf-8?B?TE04OUF0NS9lVUNOU2FCL0pBL3NlRkJDaTI4SmNEbjV3aUhVQWFsS211V01t?=
 =?utf-8?B?ZHhUTFFJa21aMDNTZVBkK3MvS1BhWGo2c1JuWE1TLzVmbjZBMGtFUnpOSmtM?=
 =?utf-8?B?bzVQWkdvUjRhMVBEZ0VESFl3K01YVFpFYUFqc1ZEZDIyZFhkSnZDTFFWTVp2?=
 =?utf-8?B?aTNWV1FoTU9hWjY0K3B3L1Q0NlZUQ3FVSEtseFhwY21GQkNrUDJ0WDFlc1Vh?=
 =?utf-8?B?cGRnTWtFdExvTmdwSUJ5aW5ibXpUK2VzOWFPNUdIVFlqUHJoSmovV1VZT3ds?=
 =?utf-8?B?Q0gwNmpCYVJaVm00RktqaXNCbGtISmJWSTMwOHZNVEdBeWJPUERpWHpPWWNG?=
 =?utf-8?B?TUVTaXVJRDdCdHJHUEZuU0JwdTJxUitlbWNKeGxtMGpvUXB6bXExRVB6amJV?=
 =?utf-8?B?b2hha1oyV0IrcXcyWkVlcG81R21NZGZoRTlUMUpCdlRnelY2L3lLRi9EZmww?=
 =?utf-8?B?eVF5Wm5JWVdpeGhKL3UxNDRGMXROYjE5blplVGxqVCt5Tm8rRGIrOTYzNnlz?=
 =?utf-8?B?WnllVnN3QUtNQ1krNERtcGdiUmo4WERRZEw0NjFadDhFbDBCTnBsT1ZKYk9B?=
 =?utf-8?B?b0JVczRKRlNNaXpuRCtONDBtOGdpc1IxN3R2RzdSc3htbXZDdFMrblAxL2V2?=
 =?utf-8?B?NnhReHNNc3k1LzdFUXYwZC9QSWVqVjExbXU1WmJiNEdqdzJrM1lqZWh3djA0?=
 =?utf-8?B?eXhoVGJxQTVHYisyQUNPTm5Vc3V2aUg3MURpeE9NVDJnUzJyYWIycWhxOHAy?=
 =?utf-8?B?c05YQXo4WjBKekFrQm1SZ2lUVEpFdCsveUlId2xGUEUva25ORGkvYnpIV1U4?=
 =?utf-8?B?cmNLTlJVOURlNkkwT0JkWlJ3RVJhMk50UWJoN1JEd1JxZmIxY0Z2WmVsN1Qw?=
 =?utf-8?B?M00xTFpwdXBuS3VtVU5TcGVmM0hhZnhwU2owWHlFRjdPUlZNcGd3ODVPMkFW?=
 =?utf-8?B?a0V5dDhEbDV1ckcxZWdCWExINTVmaFdpNUlpNk8rVndYWFFNemxDSlZ1UWRk?=
 =?utf-8?B?aW4ydWdSdzF2aExuQmR5cFJnNE1PWU5WakhZYUUwYVprZ3B6RDFWQjFMdTJI?=
 =?utf-8?B?eWlpbWJhcGRCRHNWL1phQ0VqUUZRTEJONXNaeUdDNkRqVnV4S2ZRWTJWSEtS?=
 =?utf-8?B?ZnpUMW42VEQvMHdhbzB6dmVKM245RmJ1MHdtdVZmSnNCbE5ibk9LSjBtK0Zy?=
 =?utf-8?B?eGcxVDU2K0ZPeHQyOFdiU2QwMDRtV2M0Ym10M2JKMTBQMTRKeGQzWGkwVlhl?=
 =?utf-8?B?cnJkdnBCSHFzK3M0c21OWWgxalB4SCtpRGdhMStISVF3S3h0WFNVZGM0SEVn?=
 =?utf-8?B?UVdEdHp1UENDMStoWFBrbnJjdE85eVZQMHh4WXFSNnRqSlBob0tib2tFTE9r?=
 =?utf-8?B?NllDSndUUE54WS84akpRMHVrV21wN0hzb1NlUUYwa0tVWWVKazF1OFh2cVVY?=
 =?utf-8?B?S3FCUFFScWx6eGlINW52Mmg3UUxTeDVwY2xkM3FhRWRvM3ZvemYrL1o4Mkw0?=
 =?utf-8?B?YlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <96F4F43F308DEE40BA1F4A3856B6344B@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jagSG4y3J7QZHUL6GPkecNs0yBt2Nbm3z9NLCkhKp9taGILNULIxAI1bpznwJmOWw3eU6ISXB2Y4rCuXWIPO5qbSCJfnSjH7VSuiLxx9O5kcUaR5z5JACiwitvdO7ctmUHQliBR21Z0fJYoFIwcBvXw0TtiQsjFoKbtaAHxNForpikIKg9gGHDPgq8jQivyNtgvCIQ3hAE9oqxBBX2mt2/UwGlBN+45iqnqJpMDbIXeMBhfC2Zy7/QPk4i4vWKfGNIGjJuEuM2uixA/mhezhUesFT71duAcRqLZM/rf56HGHHRrgC3o/XU/x5IHT2ZWJRBZ9RztHXOZ92UPZbnrmKzQHLLx18IMevsrG7RvPFGXX2C1XIFfsQeWF5cjE8ERiUzT/fqUZfqR1mMQZ17jh6uCssRsmyd3GFMDQNHeT9ybfUf3u7FR4y43qSQrZltrkmHC2INQukckBYG3IrdvbDbAg/OPFTyI8R6KTD+D7tHLcHI1ABUOcvTDW2wa90ND+9fPdh3LtxXc4/Nqs34qJTiKU6KKwdYMsJL7RklUYxgDY5+/Wjb4u+5cPY3sFcZBhaHEeHNAKYN7HeW6r73zSCZwZpL1pgbpQAyguWuWGY+jGmtRln0bGwptVcUSQNa1K
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa1ed245-26b6-4d51-e4f1-08dd765faf80
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2025 05:39:09.4285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j39NwuB++UNRJRMtG+lo/JqCArU2PfzSLek+52u/6l9H2trRxFpqNO5HDBvHfMrM29D/relI2stOKKJFRkpdwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY4PR01MB12733

R290IGl0LiBMZXQncyBkcm9wIHRoaXMgcGF0Y2guIDopDQoNCg0KT24gMDgvMDQvMjAyNSAxMjoy
MiwgSGVyYmVydCBYdSB3cm90ZToNCj4gVGhhbmtzIGZvciB0aGUgcGF0Y2ggYnV0IHRoaXMgd2ls
bCBiZSByZW1vdmVkIGJ5DQo+IA0KPiBodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2pl
Y3QvbGludXgtY3J5cHRvL3BhdGNoLzA0OGIxZTE3NmRkMzUwN2VjMzE0OTdjY2YyMTU2MzBkYzJi
MmVkMDQuMTc0NDAxODMwMS5naXQuaGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Lw0KPiANCj4g
Q2hlZXJzLA0KPiAtLSA=
