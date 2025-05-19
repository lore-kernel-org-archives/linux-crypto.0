Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C41280009
	for <linux-crypto@vger.kernel.org>; Mon, 19 May 2025 14:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747666209; cv=fail; b=RAwBKz/QjecqsR0PaluGIFAjNcQmaM7BkuCUCW/jE+01ywfTRquEO/VpV2an800WBBJKzDAE559AzM6GmOdoY7gTqwbSvdn1fu5TAeszlubJOwlb/jpfTMvt/21ehJ34tbmKnsSjtgX7JCv5L9/pglWcn6PLvJz2FgHwaMREKLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747666209; c=relaxed/simple;
	bh=zPqZLOQ1NkbU0AwYEdMoEL4EdtpaTdeKllUOSIJuE8U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=p/50X7FrJuFBSOfMwjNwulxRadfgJ4CevXzTdI1moMyYs795CN+lqWc4YVhzBVRKpeTZayGHhmNX5uR7hEQWsa2gVunBhkI3td3YnQ7Onz9T1XDpSFuxYW+bu7kVqbe1K/TO9b85sIJbeq/JI6aYqJaLY6wJszBOMWg4aA9qHDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=dWV6hp30; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="dWV6hp30"
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 54JBimYR011941
	for <linux-crypto@vger.kernel.org>; Mon, 19 May 2025 07:50:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2021-q4; bh=zPqZLOQ1NkbU0AwYEdMoEL4EdtpaTdeKllUOSIJuE8U=; b=
	dWV6hp303x/RRrHe8ZM+zpMf7ig8m3ABE9F/WJYVzBN1ijFlU8CJcz8vz3oYsvIK
	yoQQWWbj+k+/UdcqFhRQpw7rcoiUFKnKlK+9G0rHjv7Y+8vyWCr3n66rKd9dGtGx
	2ADAZRCMYshNVOO+ydB98Zis0kUuG0OQTIb+QpbPWJHXKRloy+bU2DeFQHT76aUx
	+LDAMlkke6La4AyLJ7gMUFzIB2cPLKer+2E3vsF20qVbsEGZAKbRz3LMTj5Z5/li
	Vf6kraiWxl6QtVNrfwwMBlKKLseI1zPdCCT4tvrvu6ukZqmI2bZMdWjyooE3Did9
	JaRCW0thX0y8Q+QGlJIupQ==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2049.outbound.protection.outlook.com [104.47.58.49])
	by m0089730.ppops.net (PPS) with ESMTPS id 46qhb4dprb-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 19 May 2025 07:50:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aIAfvffhsh8pQXWgu9K5ecXG2heganEhAqbdzXfZJXdysZ9Gt0m2mGnIje1f/WiE4FdOnPLDsMdc6+x+bbt83bvDKid1NLMY6wxo52lRb/J9dvW1hzxxYHIzjeUu9tYdOPEi4dNLxdR7m/21oq0GUigvZVauyROXVhtoOgSYuN7zauDV0xMkM0pPN/Y0Jccpn6J31W3vWO0O6ZVuZCf+lQDU8Eyu0f5Yo3aJIJ26O3BuRajcKceGTSmIxeIwIhRZ2GLDJcFIjkWumvyPmr3y/kSx9jf059puPrmuxDQWL1LNKSP6liP18zSGRxMbqhOZiiWZYBavQNcnawbBUvipCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fZGjHbLqD8ayBp8NW0sBcOQRHl40+2b7FEtV92n84vQ=;
 b=nHJYDeSwP1lnr3BiGnJsgF5gprrZxIttHpQCAHGZ9fFKUL1/8o+RckW1Id0zU4Qyszipubrgv82+GVKfhPAilvEfNoKsqbEXxaybeXjorbMHhJVEwVYFhgUEqfjvwt11EKgthD2O1Ly7770dnEThMd5rc8EvRH6tCmEQdH/ZFFcOIDIr78a0za2Y20fmuMgWCWexpXobhvWWr04rA1NFzOhUrlUoHmKhGOljRgO+lBDtjAY67zrguALqyjkIqOhvxoN5MF0ITSSm+SKJnMv4msaqUeqjM+YMt9u51LKt9jqKkRReyH3RPgADDjSiBarhbxhh/1cj0pCVbYtaKSemMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from MW4PR15MB4732.namprd15.prod.outlook.com (2603:10b6:303:10d::15)
 by SA1PR15MB5030.namprd15.prod.outlook.com (2603:10b6:806:1d9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Mon, 19 May
 2025 14:50:01 +0000
Received: from MW4PR15MB4732.namprd15.prod.outlook.com
 ([fe80::f3ab:533:bb24:3981]) by MW4PR15MB4732.namprd15.prod.outlook.com
 ([fe80::f3ab:533:bb24:3981%7]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 14:50:01 +0000
From: Nick Terrell <terrelln@meta.com>
To: Eric Biggers <ebiggers@kernel.org>
CC: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "qat-linux@intel.com" <qat-linux@intel.com>,
        Nick Terrell
	<terrelln@meta.com>,
        "dsterba@suse.com" <dsterba@suse.com>
Subject: Re: [PATCH] crypto: zstd - convert to acomp
Thread-Topic: [PATCH] crypto: zstd - convert to acomp
Thread-Index: AQHbxnl+g6NhjsDetk2fwLJXBGO1CLPVfNcAgASQwoA=
Date: Mon, 19 May 2025 14:50:01 +0000
Message-ID: <30EB61A2-ECFE-4025-84C2-A6C97F1654C6@meta.com>
References: <20250516154331.1651694-1-suman.kumar.chakraborty@intel.com>
 <20250516170642.GE1241@sol>
In-Reply-To: <20250516170642.GE1241@sol>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR15MB4732:EE_|SA1PR15MB5030:EE_
x-ms-office365-filtering-correlation-id: 9115a8c4-c956-48be-ffd1-08dd96e46f29
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?LzRMaDhoNy9EdzNZQ3hndTRUdHIzd2Z5V1RUd1IyZUtQQmRaNFJNeFExOXp2?=
 =?utf-8?B?RFRuT1dBQkk3NTVQR1I3RG5oZGhienBsbXEvN1NiQ242SFF0V0djNTg5bkg3?=
 =?utf-8?B?NjAyOVQ1SVE0VmNoSUdjb25UOGZtbDEvUlY1Vy8wdVl3TWJEY0k5NXlwQ1lX?=
 =?utf-8?B?eXR0WGxKTjY2SjFEYi90RWViS1VDcERJcUVkWklCN25Bd09BYUJrbHZualhS?=
 =?utf-8?B?dXMyYUxaVk02MndIVEZHVGIyTHczbHA5STdHaEVTSktubGlLeEp4Q2tPVHdi?=
 =?utf-8?B?VUpvWlFncUx2SWRFenZJNUZwMkxrNlpRdHVnMTIwS0ZjaE1JRDFnYkJmV1c4?=
 =?utf-8?B?TDRsbjRJWHgvUkUvOGpVUUFORlFjcnhWOHovdGdZMERmb0FhTG1qUG9pbmIy?=
 =?utf-8?B?QzNXSHB1dHQ3VW9qYjR0NEtMMGVyTExSTDZreWo2NnBWQnF1aU1mcHpRTmNG?=
 =?utf-8?B?Z3dSODJtUXpVRkV1Yzc4MWZKZkJ3R0pPSDNydFp3NFlnVUhlSWJuUVQ0OG16?=
 =?utf-8?B?d0pTYWtSQVRyTXVtN3gzTG55TkZUMEorNFY2ZlVObzRFK3FzZy9qWmJ0UlFW?=
 =?utf-8?B?T0hYSGpIQno1WnVoVDU2VFdab2k1Q3RuaXRPMzA2Y1AzZFJXVHZuTkEwV0Z6?=
 =?utf-8?B?RUQ3QVdlMWhQR0J1VlFjU0FXRm1uQVQ2anFVOWRiMlBmK0dnT1FNU2xmU0dC?=
 =?utf-8?B?S2QvdnlXOGE4RmxHVkoxbUQwQmk4amF0YmdyTHpMak5vZVdrVEdncGlvV0xR?=
 =?utf-8?B?c2dwdmI5OEgvMXZjSjdpWDZZMEpxZTFjZThoYklzNENaTE55VGNWTVdYRVU5?=
 =?utf-8?B?NHhSVDZ1UjNYUjVzOFRHWm1uNnl6a2kxOXlUdUNwMi93VHRXcFFpUWROeWYr?=
 =?utf-8?B?Mld6M0J4SVVYcklOR1lUYjRGSW0xRnVzRVM5MzZCZllTdFBwaUJ0UlJqR1Nj?=
 =?utf-8?B?ZnhrR3N5TW9TaGJpMDU2YmZkN1I2STFIaXQzN1l0SjVGTFlrQktha2pXUFpt?=
 =?utf-8?B?QjdsQzNEc09LSDFNQ1NEUGhhdVorR1oxOTQwREZNNlRQVU1ONzJjRkRHMmNm?=
 =?utf-8?B?OW1la3RteWkrRUs3Mkc5RDR3OFVrVThxSjhvME9YUk5wcndOUU1FUzNlNWNI?=
 =?utf-8?B?cUk1UWZOWFdtejNzY0xLR2hMU004aVdwKzZIZWpiQStIUWdYQlV0c2xSK25i?=
 =?utf-8?B?bFZFcU9lUkNzTW41Y2NJRy9wRlpDQ2dCY3hrV3lYOUN6UmZYcVY2VHFnR0Rl?=
 =?utf-8?B?NjdScFBRQWxLQUE2dnBlejlWQWpEMkhDZjVnYnhMU1BvUmdlKzkxSWFOQXFo?=
 =?utf-8?B?bFVOWkxnSW83aVI1N2pMTzcvZlZicnpPckFDc3AxRFZtbFR1b1FZVHdndmZp?=
 =?utf-8?B?OXgxaUM4QlRSZWVzSzV1UHVpSDdJKzN3citkZ2dqbGhuWThRcGtVQXQzZHdZ?=
 =?utf-8?B?bWJkOTdjR1FaSHc2Tk1SY2FKYXNoQVNnc0lyZ2ltSDlVbkVzeVd3YTllK0Iv?=
 =?utf-8?B?cWtDSUtqTTVqc2xiaGVtSHRQcy9zdnJzU0pLZEt2aWg4OWZyYkZtank5RHZH?=
 =?utf-8?B?Z05LRnNLYWJTUU5tVDczbVBRYVNkOGF3YmNXVHc2WHRTWnVONWt0bEUxOUZv?=
 =?utf-8?B?OUtPM2tYVk41SWhwVUNxRWZ0RjJhVDlHU1Y4amZ4dEhFbjNuZXEyeEpDaW9r?=
 =?utf-8?B?UDZRcW9uMDgwY25NaHdnNGxjL05CSWxnNFRRSm9KN1k4T2tyWG51alRZZnJo?=
 =?utf-8?B?RWdoVE9zSjJSM2czeEJyQ1BsbmJveUNxaTBtOU9aWWNjemxWZWJVWEZ4RHJ1?=
 =?utf-8?B?THYyOWJBT0tJYWczSHV5NlA5NlZzUXZod3AyQlg3SUtOZGd0dThnTUhUa2JK?=
 =?utf-8?B?TW5aZlpmTk9pOU1JOVdoSURhM1Y4S0dySFZvUDdPL05RSkRhT0puVXpQZGhh?=
 =?utf-8?B?ekhNWWp3MVQvUDVXeWdHUTE3S3NqRlJhQzFXRlkyRmNWNmJmcFRzaEpTSXRu?=
 =?utf-8?B?UTJFTjdvb29RPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4732.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RDFvSDF0aWZFM0oyc3JHOFBYeHBDNDJGQ1pYekZnbjE2eWhiTG9HKzdwa1RN?=
 =?utf-8?B?V04zT2gxU3Y4MDkvYllQM2RObnBEYWRnOEhZTmdFVG50dDRjQUdpcy93Tktp?=
 =?utf-8?B?MHBnbVFibG8yK1Z1MFV5WTZ2OTRKdEhZK2taRjBTVnNJNmExdTlpU3JqODhr?=
 =?utf-8?B?QjRrYTJ4ckpORldNSHFxczNaNmtnaFZzUmZhTXJKY2lZbzM1ZWRIeWorb2FE?=
 =?utf-8?B?cXBKQVhhZXNXaVg0WFUvMWRaVlFOT3drWllkVU1DRWpmWmdvRmJ4Tno2QzRM?=
 =?utf-8?B?MTZHNGFOYlJ0NUI0Ky91M2o0bjVMbU9mU01FcTJuNVovWkhZUk1oRUNEejdE?=
 =?utf-8?B?bGtkNFQrU0F4eUdPS09HN3ZrWGlVY0k0cnBRZ252UVJIVDR4Q3JWd2F3NnZW?=
 =?utf-8?B?UEhzNmJTR3hrVktTaDFKYUx5SHBKNmg4Z1BGQ1pRVWM0WkEzQzA4ZDBONnJD?=
 =?utf-8?B?RjVxMFJ0bXROZGNBQXlWRG5XL2VXck94N2k4ZDVJcjFZVFFFYzZZQUlscFNk?=
 =?utf-8?B?c2pPUjQvSnQxQkx4cEZNNzlnWTVxTUdmcnlvZ0h4eFo0SnIwWkRibjlsUkJR?=
 =?utf-8?B?czBjcDdjcFgvdjZ3ME9rK1Y0d0NSNTQwNk1mTjFmWjRzMWJHSUdWdkgza1F6?=
 =?utf-8?B?eGZvakhVWld0UFdlbngvQ2pKQ3llY1VVQnlKUzhudWtlQ1dvWDFPMVI0VG9Q?=
 =?utf-8?B?ZUUwbTJFdFhiaFY0VlhxbjdYaTVHMGtOR1Y2dUZrSGQwRFNiaERrajhEVEYz?=
 =?utf-8?B?U3JpMy9ubUd5Q1pzVlM5OU40cS96ZXRocG9pazBHMU91eWNjc1p5ZlRxK2JT?=
 =?utf-8?B?MnRybDRKUkk1djVOaTBsaUVyMy9iWFRDcmQ1dXRtSklBZG9FTmtETkVxTGJU?=
 =?utf-8?B?K3VYOWc0Y3ZPc3VkRStHdDE5ZVBkWmxIdlAvNk1FclhxMnZBU1pmbTZ0UW9t?=
 =?utf-8?B?S2JIWTlMd2dvTU9LeW5FaURZWnZvOUN3WWVKUU5uS3Nobys1U2duSk4yMHEy?=
 =?utf-8?B?R2k3ZGt1L2FuVS9PaUZwMGJxTEkrUkQ1N0ZZc0pQbGV4bWNIZ0VzSEV3alJT?=
 =?utf-8?B?TitJOENHdk1qcjhkVW5TSElQbjlPbkd5ZTgxcGs5b2RBKy9COG53YjN1MG9N?=
 =?utf-8?B?eGh1WWNISW5MbGd6d3YvNEI3Tlh2ZDJOQkRsVFhHZG5Kdms4Z0kraVZ0STR2?=
 =?utf-8?B?alVhNXdaSnlzaFFKVzlyUGRPc25jbS9tNC80eUkydE5GeHE1QVBTOXZ6dTUr?=
 =?utf-8?B?VDZsZSswcmtTS2tpV09Ec3pMS3JORm45Tnc3TFhGRTRJaEpSTEVzY1VFNERs?=
 =?utf-8?B?MmJ2a3BFcksrdDM4MGtJY0hma2NNTVJISFhxdEZ0S3BxZ09YS2pOOUhTbGJC?=
 =?utf-8?B?NEg2WXp4S3hFRTBDOU9DeS94clgxVW5DZUdVVVVma1hLUDEyd3ZPTlViNVFh?=
 =?utf-8?B?MkhkNUpRL09PaEJoUmtiZjZRQWpTck1ZTWoycklBQWlqNHdzeGtVNkpXTWN6?=
 =?utf-8?B?VGM2NEdQZHlUekdLdm1pcjlScm0xaU1IbjJHV25PdjVDOCtxaTdNSHg0d0RB?=
 =?utf-8?B?a2s5YnN3SU9ndm41SFB5Q2xXL2hzbldHSlQ5a3VWeExiRGQ3N21nbzRWblVp?=
 =?utf-8?B?V21jRlZmL3dDOXprY1hKQm9MQzVrVWtiWHhtdjViWmgrcHJhUzNmc0VOMDY5?=
 =?utf-8?B?ZXRQSlRsNHRLWWg3cGVndWY5N0hqUUpQMEY2bHcyeVpDMGFSSHVpcTZSQUpv?=
 =?utf-8?B?bzM5M3pydkxKZlRzOUIrZ1MxaGJFTis2Y2ZYZVRtOFhNb0NQbzhHMFd4azJZ?=
 =?utf-8?B?Y0Z6ak5QNnI2NmY3SHpGUGo0T1ZIMkRWZUxiWnd4MStKMUR6U2VjdDc5bnBv?=
 =?utf-8?B?Q21kbXFsM0Ztc3JYVWpHeVdvUUw1NnMwSzFzVHI3aXk3cTBaYWs2L3JrOG5w?=
 =?utf-8?B?V1VuVVhKeGJFcVdUdWxiYWFPeTFyVThIbGRwTnNjelBqVEhVWlRnWDgvVnVP?=
 =?utf-8?B?TElpQkEyb3ZXVUNXUDlsNzBXbFUzcXVrdHFyakNMVTFzeU1ydThhSUFub2JJ?=
 =?utf-8?B?ZXBhS0tWUzFFMmxOZmdiZ2VlY0EzQm52NUpvMXRYNE9TS3NNUEEyTlppYkRs?=
 =?utf-8?Q?f63Ii5chLgePTpol+DXPg68vN?=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4732.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9115a8c4-c956-48be-ffd1-08dd96e46f29
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 14:50:01.7580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3VPEscTAjeMjkxFrC2H+3ljxIdXs9UQbQGJIQaJjhPYzGI7/Y0HOofaOmS3h6enIQxBmadrKCqHfpFk81iJFXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5030
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-ID: <0547F9724E377B4E8FB54EECD7F71539@namprd15.prod.outlook.com>
X-Authority-Analysis: v=2.4 cv=Qrhe3Uyd c=1 sm=1 tr=0 ts=682b451c cx=c_pps a=SX8rmsjRxG1z7ITso5uGAQ==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=yuojUXLQk8SsYmorvBIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDEzNyBTYWx0ZWRfXxcCzA3lDOKlo /2/yJ7oU9z8E46u4inmx1BuwgR0bOUzB3dDCW1J2G/OxUupyBuYeZ0yhWNqYWqjfdbvCStUeB1H YiwLzP36TJALAUvLXoUPof9+n4ydShgiST/aBMoHX9UKVk3WOrANe/TccdgDTBStR42XcY0wgJP
 RtrabyBitgQkOu0RkIjy1XTJGXq6WhcBjeO0qHB6JKUok57l9nak9x/2f3cqoIu5tuB/HUlm4Nf wUKiIrN3UjSRCsS4ae2QTfMDOCakrRdHuTyQklcVdQXgsFwNN5mD0bG9GrLNzuWDN40nwmi672g DAedUBvrRX1wCBhg5Mb59NlIGglyeeiQciqQftnFNFRSsrOmVkeQyMiyIvKvMyFBMGnh/L4Zysy
 iucOHXEDD9/TxZs+5yVfETjR+c4rLvux98FkUaRC5teHjRUCCJUTomWJwaPmhtB+kcTGmxss
X-Proofpoint-GUID: lHU5o-9JuzsUEnHKMwXEy89FuJqW1jP5
X-Proofpoint-ORIG-GUID: lHU5o-9JuzsUEnHKMwXEy89FuJqW1jP5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_06,2025-05-16_03,2025-03-28_01



> On May 16, 2025, at 1:06=E2=80=AFPM, Eric Biggers <ebiggers@kernel.org> w=
rote:
>=20
> >=20
> On Fri, May 16, 2025 at 04:43:31PM +0100, Suman Kumar Chakraborty wrote:
>> Convert the implementation to a native acomp interface using zstd
>> streaming APIs, eliminating the need for buffer linearization.
>=20
> How does this affect performance?

Zstd does two extra things when using the streaming API:

1. Allocates a buffer of (Window_Size + 128KB).
2. Both compression and decompression have to copy data into / out of that =
buffer.

This means there will be an extra memcpy during (de)compression.
I don't know how that will compare against any efficiency gains from
switching to the acomp API. It would be great to see benchmarks here.

When all the data is presented in the first call to the streaming API, and =
Zstd can
guarantee that there is enough output space, these memcpys can be elided. T=
his
happens, for example, when the data is smaller than the buffer chunk size.

Best,
Nick

> - Eric

