Received: from mx0b-00154904.pphosted.com (mx0b-00154904.pphosted.com [148.163.137.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE58D14B959;
	Wed, 15 Jan 2025 15:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.137.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736954661; cv=fail; b=uqeiRiq7ATXRyVPYWsUY4FNbsaiu5ADGrdbSxsrmWMgiji3v5koAsTF6DF4+VDgcgSY9iCutGGDPqSiyzr5Z7XTQ5+15qjKLr8MIf/hdd10kCmbPrjo61c5N6ryWCvnWIlcNDeEYrqDf+a4djYOVfsOmpOze26Un2JbjW7fCeaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736954661; c=relaxed/simple;
	bh=sYVBlCao54nQF5NqyoyMRocF7DD/5aHDKHx215/BJfk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aUd7YePHzu2qlcIqyAUWGiwpUnAXkNSpFVaeci50JPJ0bu9kan8eRlZ2QtXO2KMLrNc93fJe7jvQN9Ew9qQnyULGzOIrDHwZwfdGDpwzKk/MkGhfqdeeP2UoZd2Tjf63iZDbyP5oTXUoyq3ajCMzFFKNKmnmYEPUOLzbCBL5yfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=Q8c9zT3R; arc=fail smtp.client-ip=148.163.137.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="Q8c9zT3R"
Received: from pps.filterd (m0170398.ppops.net [127.0.0.1])
	by mx0b-00154904.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50F9iBbe015667;
	Wed, 15 Jan 2025 05:39:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=smtpout1; bh=3
	NoaUl57V56AFAb1cghgkzBF55fUPNkiLdbfom4+1Vo=; b=Q8c9zT3R8likq4JHW
	Vfj2YLsjKMrrJkm5p19y8PyQvoyRhoLGNRa2zsrxwmARIhv5867mCjSTw5IuNvwj
	0jzXXbrgq93rJKTJVJSqu5B04i7qFVqv6LDXByW0YTv3dz6YIlN2xqK+WoG8BaB+
	46AeN2IUbrqA4R1E8KdKkCo30Gx445S73MXvmhjLPBCzXkU7rFWIUJ20LPpOtT0c
	/PsGlbd+Jl0DM47kLyl8ogyKi8nZDmYTRBlAPWqlURWw6O1vvI6OLeGlmWZz0AUY
	EXokgWz6WHYG9V2taFkox2oCJRu29ohNQViIxb7qRVhJIsHWQb/Y8W3cGTaCaWrL
	veEhQ==
Received: from mx0a-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0b-00154904.pphosted.com (PPS) with ESMTPS id 445y6mjnbd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 05:39:56 -0500 (EST)
Received: from pps.filterd (m0089484.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50F9q99V020656;
	Wed, 15 Jan 2025 05:39:55 -0500
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 446arhrk6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 05:39:54 -0500 (EST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=toRMVUTcEN3dJFtdWsRu962K5DAb6ptxNpI+mXWn177eww3JOdpRkd7QgPSvzWIS0qiXPz3Vwaye+gt+FxCsGSSymmY9HKr5Lpx3P2enVcileWAnN4OblSyYkr7ZrUIDzBDFg3scw/ayKPnkltnmjRDRH4uSiMBJaNutFtS8xlI0S45tPylMRzMvtmHOBb70rsJdvv6Gs4mN9eWXGX6P02zyavZVqRGDbu1JW7u4YvSrFlJjD+C2m8z5gvX+xdHU/kKpTmlAZrObUDwbYYMmQbEIYJiiEQs9wrZeZJUccrKE6TtOKIW1tfcPPWF9vmoE11VF6ikVSCQUvTzeZ9uehg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3NoaUl57V56AFAb1cghgkzBF55fUPNkiLdbfom4+1Vo=;
 b=miuEJUDVc3elnxS6if083XbvsmbdKj2a/KvGvAK1C0Pu82eqHvw/l0wx2jq4vwheNz9qKxehmnZbwAUE89AY2Fg14i1JUO+q5JKa7s86InSVGLYJOkjKOrKfUe1lzfOdHK4Z6IXWcwTok5Esw5cTEElbyVlIAIl2IhUeWbiFLrKmj7DIDx2MD8pmemnSFFnZXZjV0R+Q32xOv0VHWet8Zg8Fjt7JICoaIctLQIU5wkicHGr57COvbfKLbHxcDJ14K76I0sU/rtgENNzo06DYNtHpSuYE3r4u5sCzMwlLMr1QWc97GJv3Xa6Xuz1dCJbN1X/jq4omauq70VfCniPDpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
Received: from SA3PR19MB7399.namprd19.prod.outlook.com (2603:10b6:806:31b::6)
 by DM4PR19MB5788.namprd19.prod.outlook.com (2603:10b6:8:65::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.18; Wed, 15 Jan 2025 10:39:51 +0000
Received: from SA3PR19MB7399.namprd19.prod.outlook.com
 ([fe80::76fa:571e:44e4:4855]) by SA3PR19MB7399.namprd19.prod.outlook.com
 ([fe80::76fa:571e:44e4:4855%7]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 10:39:51 +0000
From: "Zheng, Yaofei" <Yaofei.Zheng@dell.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Qunqin Zhao
	<zhaoqunqin@loongson.cn>
CC: Xi Ruoyao <xry111@xry111.site>, Arnd Bergmann <arnd@arndb.de>,
        Lee Jones
	<lee@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "David S . Miller"
	<davem@davemloft.net>,
        "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>,
        "derek.kiernan@amd.com"
	<derek.kiernan@amd.com>,
        "dragan.cvetic@amd.com" <dragan.cvetic@amd.com>,
        Yinggang Gu <guyinggang@loongson.cn>,
        "Zheng, Yaofei" <Yaofei.Zheng@dell.com>
Subject: RE: [PATCH v1 3/3] misc: ls6000se-sdf: Add driver for Loongson 6000SE
 SDF
Thread-Topic: [PATCH v1 3/3] misc: ls6000se-sdf: Add driver for Loongson
 6000SE SDF
Thread-Index:
 AQHbZmqu8tAi0zKGP0afKxhL+p3HzrMWDkWAgAAHKwCAACxMgIAA5D8AgABTwwCAABWA8A==
Date: Wed, 15 Jan 2025 10:39:51 +0000
Message-ID:
 <SA3PR19MB73993DCBDE9117AA1E77C127F9192@SA3PR19MB7399.namprd19.prod.outlook.com>
References: <20250114095527.23722-1-zhaoqunqin@loongson.cn>
 <20250114095527.23722-4-zhaoqunqin@loongson.cn>
 <ee65851c-4149-4927-a2e7-356cdce2ba25@app.fastmail.com>
 <97000576d4ba6d94cea70363e321665476697052.camel@xry111.site>
 <2025011407-muppet-hurricane-196f@gregkh>
 <122aab11-f657-a48e-6b83-0e01ddd20ed3@loongson.cn>
 <2025011527-antacid-spilt-cbef@gregkh>
In-Reply-To: <2025011527-antacid-spilt-cbef@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ActionId=e105abfd-9b04-4f1d-82b6-aa1b59871c41;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ContentBits=0;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Enabled=true;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Method=Standard;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Name=No
 Protection (Label Only) - Internal
 Use;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SetDate=2025-01-15T09:15:37Z;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR19MB7399:EE_|DM4PR19MB5788:EE_
x-ms-office365-filtering-correlation-id: 7930ccb4-e4e5-4dc5-b84b-08dd3550f146
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-7?B?Y0lmWHFxWnA5cXZlaGpjTW5hd1RKOVM4TXN1RWNpemtGMjlRcFpJL1JtZHhj?=
 =?utf-7?B?V0VJT1FEZUZidkowbkhCR1VVUjUwRkRSUkw4eXJWYnZjOEx0ZDhNUGIrLVpm?=
 =?utf-7?B?QU5YdEU0YXY3d3NrdDV0TUNTcW9NdEZ2cXhUSU9HUHRHQTExNXN4SDY3eE1Z?=
 =?utf-7?B?eXFRSjRJbXVkUXZNOU5aaXZaYjd5RS9uUWhiOVJSZWJFelJsMURUSEQ2Z3Y1?=
 =?utf-7?B?c05uWXlKVmtibUM1ZWVONHMzN1ByWWhqMy9GMFVHc0VpOGJJNTlmNVFJdkhV?=
 =?utf-7?B?c1o4SHJ2QUROY0c3bnBDMjJBWXZyREd4VjFhSk1IcVl4dGZ0NU5mWC90bVJm?=
 =?utf-7?B?TGsweXZFTGpoS0xkWDRlVTdLQjAwWWVXQ3d5YTFiM1BGalpHMjBuazlhMkll?=
 =?utf-7?B?dDdnN1NlYjBMWE9WMnJvTGxRdXhqcUp5S0RIM3cxZ3JVa0s1bTZFOXh6czBF?=
 =?utf-7?B?enlmWE5lcTVrYXdMdVZkaUM1QmxOUW8rLUdzcUI4a3hrNGlXOFB6QnFPb25P?=
 =?utf-7?B?Q2x2NndqcTc5MzcwYUUwTTJ4aU5FV0ZqZ1JHclZ3N2paZnhTZ2ZZckdRL2pU?=
 =?utf-7?B?UXlnOVVJMVJQaHdpblhrVndSalZzcGFMVGwwRXBGbVhyek1Tc0dBS3RKVDZR?=
 =?utf-7?B?T2pVNEVwckNNbzB3R0xnV2JZYVB5cVlWKy0yNVcveFFCY2JhZnRaQTVlV2JX?=
 =?utf-7?B?M3dSaFErLXZ1dWhjZGVMQk5ZVldQeXZMRkhKNjNWYm1TaUh0NGF6R21OdWRR?=
 =?utf-7?B?dE8vWjY1bjkwNXUrLVZKYzJ5djZUZGtWMElVU3Qwb0orLUV2bTczeFZWQ2x1?=
 =?utf-7?B?aFRVZXA5eXlpSkRQZVBaT041VThkQ2V4ZDM0anpFN3hZbm5SNU5uSUFPZzNu?=
 =?utf-7?B?SEp4Z0lkSXBIelNyT3B3aWtES1pacFh2QjU1M0dSaW1YbnEwOEt4ZjE5Ung1?=
 =?utf-7?B?TnhEaDRMdDU4Ky11blQ0Y1NHRSstUkJhWGFScUQrLUlzalVXZ3ZEVEJvVi82?=
 =?utf-7?B?ZkExMHN3SmlRRFRCbWR4MWNXMzRkSEJ1VWozRjlYMDR4WkFWZnVjKy01Unl5?=
 =?utf-7?B?RUQ2Ky1ZdmhTQlk1Z1RkeU45OFh5STlEQUlTQUh4aGJmejc3ZzZUVWlUMWlB?=
 =?utf-7?B?R0srLTN3M01iOGFOL2NuS0tocmZvRk95SW01amlPS2ozbzZkZksxckx4M2w=?=
 =?utf-7?B?RCstOXYzYW9pMjQ0bEJ1ZGQ0Sjd1a2pxVDNNV2RzZ3hCeXZCaEVWR3dNVjY=?=
 =?utf-7?B?bSstcGRPUTVoeDRoejRYUVQ4bDRXYmNjcklxbHU4VmVvbXVMMExtZnpYaEc3?=
 =?utf-7?B?S0FGQ2oyQncrLTJYMExuRistRmtKS0VrNlZwKy1maFVWYistY3pXSTVWWGF5?=
 =?utf-7?B?WjF3Y2JDT0FrNkI2NystQ0NUR1ppZjRzKy1MUzllLzh3ZTNtWTM5cnNNYmto?=
 =?utf-7?B?ZGh5YW9Kc0ovMlk0Zk9mdzl5bGtvYUFaMmZ2dDNQKy1OaGV5cnhsUEJZaTd2?=
 =?utf-7?B?ODZ0Mm9aNDhWakcvQW1tTU1ZUVBWRVl5QXV3VjJUNGpBOUdvTkxncmd3SThj?=
 =?utf-7?B?SkQyT3RDVEpkOFNGQzZkTXVMNWxxdmpMbDZaNC9pVHlXOGxOSm43cmIvN2s0?=
 =?utf-7?B?RGRsQng2NHVUUnd2NnZhdTQzQUZlaUtLUDVuaDNadkgwSXk5ajMwN3RyRXpt?=
 =?utf-7?B?THoyS3ZGaG1qbnUwYUM2eHdnUystdVc3dGlVNWdVYnZXbTFXZ3hyWUVyZGsy?=
 =?utf-7?B?d3ZQNzlNbFhyQnkwaHBXN1I0emFtYVhVRHFRZ1RzZDJsMlM1azR3U08vbTNT?=
 =?utf-7?B?TmJaUEpDWnFKOC9RMEVqa3k0TkpSWUhIanNQVGptekRCT0xmZ1laWDQrLTFh?=
 =?utf-7?B?UmpvZDRRbnV0bWVMa1MycHQ5Q0ljd3dvZkZEYmhXYUVMWnEzSkw=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR19MB7399.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?MzZGYkIwQ1VFYUF6Z1c5eUcrLXAvWm1OVXpGRmh3S25jejA1ZnJpMzF1S2p0?=
 =?utf-7?B?RXpZSWtEY1p2d1l4dEhUeENvMzFZUGVYSHpzcmpkcVd5ZUp1ZFpUbmdNYXc2?=
 =?utf-7?B?cUxKMUhzTGR5aSstenFtVmFwekZtZVR2UDZqcnZUTVBWVndYdE1QajgrLXlM?=
 =?utf-7?B?TFp2d1lWckNuYUpsNG43YWJaaTJwaWVDMW9yMnRUeHdTaVZsOWpKRmVQOXo3?=
 =?utf-7?B?dmFibVhsYXFpdHZXSmRoYktvd3BRbE55RVdkU0dsVkw5ckpTRUNJWFZIaWFh?=
 =?utf-7?B?clovV3FNbk9HRzRId01LeDcyRTF0RFcvVkQySmROSVk3V2lzSXZzSzI3Z0c2?=
 =?utf-7?B?RXJxVVVNZHF0YXhUOG80YTRMQ1NDVExQOGRnRGNVR1VpVkQ3N3p2aDVkSmlk?=
 =?utf-7?B?TmQrLXV2dFM5M1ZPbHVJOVFYdTA5ZXBHcVlUVUhidTZ6TkllMGtRN1pTQ3lo?=
 =?utf-7?B?TSstS3FzSk9DR1gwQU5DSFJlUWdRQkpIM3JqMkVJVEhPQ01vN2ZNL3l3dncw?=
 =?utf-7?B?L0RxQU9uRGNDd09rNjhSMUdQS0hHdmdkUXhhazJHSERyTDN6MGYyaGhSVTNx?=
 =?utf-7?B?YSstQWUyaFdYZUNvdFhRWHQyZzBOQUNUNk9idnowL2w2VXJtd2wyNS9WMWRI?=
 =?utf-7?B?SzNSMUx0SFc3cCstanYrLWo5Yk1Zb3NqODhVWk5FdWZSdkh4Y1Q3Q1AzdnNh?=
 =?utf-7?B?M0c5TEdsVndlcG1UUXJwcHRaY2xXcnA0NzBvSmh4OHFETDNnNkhBVWpUakxO?=
 =?utf-7?B?M2VGNnVHd21uRUg4YWVYV2JMN2xrVXVZR3FlZ1RHQ1RIMnVxL0VhTnFhZG1E?=
 =?utf-7?B?ZXhtejNKVzZ3cXBZaDNPaHlSenQ1V21TZGxNTVVONjJkYWU2Z3NLdkdGZGwx?=
 =?utf-7?B?WXZOM0ZjRG9HR1FjNy85WlRocnU0M2E3WS93U1ExeistYUpsTTJMYmNodW15?=
 =?utf-7?B?dVVpbTB2VUZ0alpadXpnKy1nZEFYWnN6S0xteEdaWUI2ck5uMkNiSWdleSst?=
 =?utf-7?B?emdYOTZuZnBZdkYrLWNSWlF4aGxScGVSVUZ1bWxhdExHZlRGUm9GS2hucGRL?=
 =?utf-7?B?WTBibzdFOHV5TnZEYXRrSDMxWSstaldSL0lSTXBaUDRwZW5NbFZyNEtjZGFq?=
 =?utf-7?B?dy9tSnI5c3hVWUUzYWF6R1ZrNDZXMTVTaC9vb3dpWDF4bHFGUVZvMXlra0Fy?=
 =?utf-7?B?N3ZTSVZqeHhMRG9Wc0h4NmtpdkZvRistc1pMZndUak5JWSstbWJ5elk3bXBN?=
 =?utf-7?B?MmJmM0lFWFRINjFkRlN2OGdUWFFoZWpCSG1ZWWlyQldMaVIwN2lkL0tEaHE1?=
 =?utf-7?B?RzhIV1V2L0dvWG1UWVZST09uZjdoM1NEMnpmaTQ0OXllcms3Z2ZNdjlHTTA2?=
 =?utf-7?B?TFBvSllHRGswSExwNUZGOVpCbk10Z0NUZG9Pc29keURWZ25jNistcjR6MUcw?=
 =?utf-7?B?VzY0YkNyMk92enFLa2hmVW5ieGlyNzhQd2JTS0FqWVlOTlVBeG5XNTV6T1ZQ?=
 =?utf-7?B?eWlmTWxUNG9TbVdWNVpIOFBUZXExQWoyWkVESEQ4M2FLSUFQcUtScXRzb3hl?=
 =?utf-7?B?Q3hJSWZPL1R1YnNncWhzQW5jQXFPMnVidjVmN3Vob1prL1B5ZHhaWnZCWWMx?=
 =?utf-7?B?cFhBTkNQNU53cjN4T0FrTGR3bEp2ZTAwMUhQRDM1TWYxMjJ6M281Z3hmTTFD?=
 =?utf-7?B?VFg4UnAwb0VzZGRuYXA1V0hYRlRQekxGMnhoZG1yKy0rLUJBNk9hSjBlUVBY?=
 =?utf-7?B?SGFCemoxTWtic2UrLS9sdGR2V3FJWGtBTU1teTFUb243SGpIQ2N2TTUvcGZG?=
 =?utf-7?B?Tlk4REJUVEdyL3lJZlZJVlBla21WOWtYS2ZyZ1FLUW9Ia3FuUEVKQW1VVTlN?=
 =?utf-7?B?a09mNktnanprM0ZNWXFsODVRYzl6bVVVWGo3MHNVV0VLdWtYOGR6NzhRczZl?=
 =?utf-7?B?Q3pGSjYzaystb3hyVldmUHZQTkd6N0xLcDdpMmgrLTNKMG9VYk93Ky1TWkto?=
 =?utf-7?B?Rk9ZYWttS3A3VEpETi9LM3JySHpiM0orLVF0M2dnSFpFbistMGpCdXNtS2wv?=
 =?utf-7?B?VWZza1lTL0ZRODJwWjJjT2xCNWNnekdiR2hPemNiZ3oyQXJJRW4vOWtwTUtV?=
 =?utf-7?B?ZHlVM08wSDY4ODl0OC9iajNwaSstSEJrZGlId3ZqVU9rM2svcnpWaWxhNkpq?=
 =?utf-7?B?VGF3SCst?=
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR19MB7399.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7930ccb4-e4e5-4dc5-b84b-08dd3550f146
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2025 10:39:51.7606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uWh0gPH3j4SNqRMvDVt/3lLbqi3SoOqGixyQ5IyTM+jExqJRv+ntQ5+9eeg733h78c3VhHnG745O79njLf8ixg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR19MB5788
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_04,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 lowpriorityscore=0 adultscore=0 mlxlogscore=846 mlxscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 phishscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501150080
X-Proofpoint-GUID: blJxzriEerB_JRbymEeNvCtK44yarIIM
X-Proofpoint-ORIG-GUID: blJxzriEerB_JRbymEeNvCtK44yarIIM
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=804
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501150080


Internal Use - Confidential
+AD4- On Wed, Jan 15, 2025 at 10:58:52AM +-0800, Qunqin Zhao wrote:
+AD4- +AD4-
+AD4- +AD4- +Vyg- 2025/1/14 +TgtTSA-9:21, Greg Kroah-Hartman +UZmQUw-:
+AD4- +AD4- +AD4- On Tue, Jan 14, 2025 at 06:43:24PM +-0800, Xi Ruoyao wrot=
e:
+AD4- +AD4- +AD4- +AD4- On Tue, 2025-01-14 at 11:17 +-0100, Arnd Bergmann w=
rote:
+AD4- +AD4- +AD4- +AD4- +AD4- On Tue, Jan 14, 2025, at 10:55, Qunqin Zhao w=
rote:
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- Loongson Secure Device Function device =
supports the functions
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- specified in +ACI-GB/T 36322-2018+ACI-.=
 This driver is only
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- responsible for sending user data to SD=
F devices or returning SDF device data to users.
+AD4- +AD4- +AD4- +AD4- +AD4- I haven't been able to find a public version =
of the standard
+AD4- +AD4- +AD4- +AD4- A public copy is available at
+AD4- +AD4- +AD4- +AD4- https://openstd.samr.gov.cn/bzgk/gb/ne
+AD4- +AD4- +AD4- +AD4- wGbInfo?hcno+AD0-69E793FE1769D120C82F78447802E14F+A=
F8AXwA7ACEAIQ-LpKI+ACE-g7kUt84vOxl
+AD4- +AD4- +AD4- +AD4- 65EbgAJzXoupsM5Bx3FjUDPnKHaEw5RUoyUouS6IwCerRSZ7MIW=
i0Bw5WHaM2YP7pZ
+AD4- +AD4- +AD4- +AD4- IcYiDQOLf3F+ACQ- +AFs-openstd+AFs-.+AF0-samr+AFs-.+=
AF0-gov+AFs-.+AF0-cn+AF0-, pressing the blue
+AD4- +AD4- +AD4- +AD4- +ACI-online preview+ACI- button, enter a captcha an=
d you can see it.  But the copy is in Chinese, and there's an explicit noti=
ce saying translating this copy is forbidden, so I cannot translate it for =
you either.
+AD4- +AD4- +AD4- +AD4-
+AD4- +AD4- +AD4- +AD4- +AD4- but
+AD4- +AD4- +AD4- +AD4- +AD4- from the table of contents it sounds like thi=
s is a standard for
+AD4- +AD4- +AD4- +AD4- +AD4- cryptographic functions that would otherwise =
be implemented by a
+AD4- +AD4- +AD4- +AD4- +AD4- driver in drivers/crypto/ so it can use the n=
ormal abstractions
+AD4- +AD4- +AD4- +AD4- +AD4- for both userspace and in-kernel users.
+AD4- +AD4- +AD4- +AD4- +AD4-
+AD4- +AD4- +AD4- +AD4- +AD4- Is there some reason this doesn't work?
+AD4- +AD4- +AD4- +AD4- I'm not an lawyer but I guess contributing code for=
 that may have
+AD4- +AD4- +AD4- +AD4- some +ACI-cryptography code export rule compliance+=
ACI- issue.
+AD4- +AD4- +AD4- Issue with what?  And why?  It's enabling the functionali=
ty of the
+AD4- +AD4- +AD4- hardware either way, so the same rules should apply no ma=
tter where
+AD4- +AD4- +AD4- the driver ends up in or what apis it is written against,=
 right?
+AD4- +AD4-
+AD4- +AD4- SDF and tpm2.0 are both  +ACI-library specifications+ACI-,  whi=
ch means that
+AD4- +AD4-
+AD4- +AD4- it supports a wide variety of functions not only cryptographic
+AD4- +AD4- functions,
+AD4- +AD4-
+AD4- +AD4- but unlike tpm2.0, SDF is only used in China.
+AD4- +AD4-
+AD4- +AD4- You can refer to the tpm2.0 specification:
+AD4- +AD4- https://trustedcomputinggroup.org/resource
+AD4- +AD4- /tpm-library-specification/+AF8AXwA7ACEAIQ-LpKI+ACE-g7kUt84vOxl=
65EbgAJzXoupsM5Bx3FjUD
+AD4- +AD4- PnKHaEw5RUoyUouS6IwCerRSZ7MIWi0Bw5WHaM2YP7pZIcYiCFoP-hu+ACQ-
+AD4- +AD4- +AFs-trustedcomputinggroup+AFs-.+AF0-org+AF0-
+AD4-
+AD4- So this is an accelerator device somehow?  If it provides crypto func=
tions, it must follow the crypto api, you can't just provide a +ACI-raw+ACI=
-
+AD4- char device node for it as that's not going to be portable at all.
+AD4- Please fit it into the proper kernel subsystem for the proper user/ke=
rnel api needed to drive this hardware.
+AD4-
+AD4- thanks,
+AD4-
+AD4- greg k-h
+AD4-

Hi Qunqin and Ruoyao,

+ACI-GB/T 36322-2018+ACI- is just a chinese national standard, not ISO stan=
dard, not an
enforced one, +ACI-T+ACI- repensts +ACJjqINQACI- which means +ACI-recommend=
+ACI-. From what I understand
 it defined series of C API for cryptography devices after reading the stan=
dard.
Linux kernel have user space socket interface using type AF+AF8-ALG, and ou=
t of tree
 driver +ACI-Cryptodev+ACI-. From my view: +ACI-GB/T 36322-2018+ACI- can be=
 user space library
using socket interface, just like openssl, if must do it char dev way, do i=
t out
 of tree, and reuse kernel space crypto API.

Best Regards.
