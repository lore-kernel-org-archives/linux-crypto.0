Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2052.outbound.protection.outlook.com [40.107.101.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A98E7F481
	for <linux-crypto@vger.kernel.org>; Thu,  2 May 2024 14:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714661807; cv=fail; b=XdZvLhD/65mqXQswzgOHE4N4+OVCks5l7rNCatb8xhEqCLL5fpZK9GaG8eHzziMEBlRz4KVSqCITbO+FuMwmfRe8Lq/Fn4ISQOMQMhPo/StdFquwXReeWgCLzukk95uFnPzGNdajbFPlpE41xlSpgPl7Eas9CaLevLhMD8fHXzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714661807; c=relaxed/simple;
	bh=5K2yEzzRfhauIxI3Smc9ZjkHBVRkHigGUMjtgl9jQp0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K19nSQCUEe0IPVmerBCmR0yxzLY9PiwXXTuNpvdQSwugUCix9wDWkZyp5k2RhCIDEKcHdKZt4H9VEpy8CnzsdMBatRUQngovAoycAKRt07/Y3bNqJq4z403NdYkUYZJUid7/tG1SLMzFj+d6+fpc/KN6fds4K/w6Zbkk9YoKCpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eCXgRcEc; arc=fail smtp.client-ip=40.107.101.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eCXgRcEc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAhId503Xsqa9mtQfPy9u0zUsiTnUkksHemWVNivATayrxnIZnbZ+12+sEN8K3t2/WU3gnA8GxeUN/oQgcXK2SC5SUK0AJ/HtkX4DB4RvCfSxpCz2Ug0vhZkijDjgm2wtCGw4T6I9Zl6FGldYCR6lrAD1hP4qiF1Vcco57Xhkvfz9zpPgzZF9nZ5TKRUPNtfIFKhQosx3n38zI+Nna2X1ODkr1AvYjouwbJdevMlezTFMV6eoKXrFwf0nyspjpRf75TdNwIq3BjJvjkl7HbzRLdqPRRIp8PtPw+B9NZd+st+beldoljowpBgQIjwlimB0Ffn5UBn46SkgAk+Ii8pfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PY/qiPavNdQwBjmUnbFLjF0Xpnotit2fH9zytCgJatE=;
 b=eXewHroqjzERJKANVSU/MPrrKNDrF4ZrsNcW8y9DcYTUvF3JUVqbbiL3m6JZJL+DsEVe77KmpivvuKY+vArrQ9AujWfvrkCMLhkEAlFGcjvNYxXGxgNOA51MpKo65f+N9rpcVpvpUv3xmsj5U6+5GlfUrgo/nEUMA8nkFvCXy/Vqyjqq8VDIEoj45VA3C0y/QvwfhIb+qXGuIYEIsJ3/nzxQ1GqDyfPsA+f9hv6RWvocDBiSpyOrnErojbTs/G+P/xkdtDaMGnXh0LxfiC1Gf6pyhSfNR/Y+/1kiH7Ajchctn79yVVDmlU9WQAbqTYz/U4RlFpFPGZOJfpbj3eVCbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PY/qiPavNdQwBjmUnbFLjF0Xpnotit2fH9zytCgJatE=;
 b=eCXgRcEcy1YhR+tbmlksTw1Oe1QImU64hphDvMcI+6CNhaJslcdibQyCKAu4h9PVWeNgg/ZdFRXPxVMdiQwlgsjz0oCQuRyvzAykzCUYUNYfFi4KpoBLlsrTFAV0CgDSKO4U9Vblzhvz9+pSqnkxfgZJ5saKfhrIg/GwAQ97x45Q+RfZp9nlDDH/+zMTdFRIzxAgHXr1U6Jf9I0/8wMFHnCED23nrkHvZpOzMdzZq/2zpw0LOTuLnZZDlHWF0KqCYBwJR00awuUiFSfq5Ap9NS8e3DZIvHrLUIKAKXjeSyUzIPtHejdeSFmJvmrReYyRHh8Yamo2s7Hw3UuOuUgYZA==
Received: from SJ1PR12MB6339.namprd12.prod.outlook.com (2603:10b6:a03:454::10)
 by CH3PR12MB8725.namprd12.prod.outlook.com (2603:10b6:610:170::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Thu, 2 May
 2024 14:56:42 +0000
Received: from SJ1PR12MB6339.namprd12.prod.outlook.com
 ([fe80::e696:287d:3f92:3721]) by SJ1PR12MB6339.namprd12.prod.outlook.com
 ([fe80::e696:287d:3f92:3721%5]) with mapi id 15.20.7472.045; Thu, 2 May 2024
 14:56:42 +0000
From: Akhil R <akhilrajeev@nvidia.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>, Jon Hunter
	<jonathanh@nvidia.com>, Mikko Perttunen <mperttunen@nvidia.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH v7 0/5] Add Tegra Security Engine driver
Thread-Topic: [PATCH v7 0/5] Add Tegra Security Engine driver
Thread-Index: AQHaha3gsfDBlfEn5kWsP3WoOvnfvbFkS2CAgB2iPLCAAEO4gIAAB7lQ
Date: Thu, 2 May 2024 14:56:42 +0000
Message-ID:
 <SJ1PR12MB6339E3A141B161F28E5C76B4C0182@SJ1PR12MB6339.namprd12.prod.outlook.com>
References: <20240403100039.33146-1-akhilrajeev@nvidia.com>
 <ZhjjNWKexg8p8cJp@gondor.apana.org.au>
 <SJ1PR12MB63391878683E395E6A3641FAC0192@SJ1PR12MB6339.namprd12.prod.outlook.com>
 <ZjH3zzInVjY+qOH4@gondor.apana.org.au>
In-Reply-To: <ZjH3zzInVjY+qOH4@gondor.apana.org.au>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR12MB6339:EE_|CH3PR12MB8725:EE_
x-ms-office365-filtering-correlation-id: 6d1655d0-a091-4b76-3880-08dc6ab81443
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?p34nNvkvqPh2RK2jZI7IJrlRvM9mcMnqz8lSi6EnNVaErQhMApBTogG5qDyX?=
 =?us-ascii?Q?GaBHfJQkBbnm22DhcA+4IrviAe/D6pI2YcQhjhaN70cPJ1VRWNvaUw4cYtQt?=
 =?us-ascii?Q?RhXDTltmaOFxy3wvzIEuZ2zIeOZXVw8ktzXPpcxcobBwzlJ2+xO7qVMekN+/?=
 =?us-ascii?Q?MSLOYIaCjcK9lCaLkycvijE1ZQAFrP7Mrtfh5A41eK4vbvm5sSwPumSh8aoO?=
 =?us-ascii?Q?Yu4/51a1Q/tTPCwj6Zqt68uJlGkdVG0bx/Gato+52HVJIdpgYrHiOacPU/++?=
 =?us-ascii?Q?NopSUcQOXfjUYunuFZHdUTZx6pqnYLAiP+AuyPvdd/Z6W5r2lGe6qbnaFmsS?=
 =?us-ascii?Q?wYXutCI02UscfHJXypgtfB/StigQW5VZzVTUv/fcVJgsqt0XbmFROU7i12Yg?=
 =?us-ascii?Q?pzXL8ilr9XscTgCmTuiDrWe/wOwvPEmjBkUyioeajJhUuTQzwTUjGYQOLnLt?=
 =?us-ascii?Q?pdY9qsWPPuOc8WsjPGXz5ciscwAD83Un4bZO6LMPR5F8fbCfa6jTsblXMrlk?=
 =?us-ascii?Q?sctHNhuDN5oB+UmIydEENEGoZv4PcFyX/8NENoixpITR8MvQDu6d17Kho4/u?=
 =?us-ascii?Q?mZJz9C7q+Ir2oI7zks7+WneoolgTLYVfW3Vtg2h36J35NB8H+pwS26ZfgNDC?=
 =?us-ascii?Q?um5WWGlUxbd7AxxB2lyw70hcceYhhvWhAyUYjg8Kv1zjy964mBnAAsm1ETfP?=
 =?us-ascii?Q?L6JbHx4Bdzx2o6PzCMyRmLb8+1RzQCWvajueaBzXrkicu/onHnlKGnyybSY6?=
 =?us-ascii?Q?ldmri6vxiiMd7YyQ26iY787LZ++AhJlWFWngx4dKLPG68p4xwyZWbWGhd0wa?=
 =?us-ascii?Q?Nrx/TLUn2wVn9h5AoCCcLpGVT+KyAg0NknFpMFrLrivDHg8KUKKBX3zAkZQL?=
 =?us-ascii?Q?CnQM8UN0pC55T7IZ6HEAVNvOx3oX06SVq0rL0IjSCiWMgFkhKVa5//Xn5PTF?=
 =?us-ascii?Q?gAFAqW9P1EWzohVjb/Yu520muCcrH9zRL82EzM35L4RgvRGYVt+ert5b/Rje?=
 =?us-ascii?Q?Jr2SMv0/pJXAPrpMXuX7QZN5OJtQRmoxZQe/3MkC3W1grkj8/H7x3D2xFWlV?=
 =?us-ascii?Q?ELyass4RfctrVQejC7hSkp49rRHEQzr6p/D9U+s6WpqhTskBGKihO5Wzlhbn?=
 =?us-ascii?Q?GFyFw3MBbLz1lERYBqh4RI9b+Wr+hl9rHAx4qowHInkB0hMmIuefFd6m6+Gd?=
 =?us-ascii?Q?AcmMeHLug3097DsUAkujtKnRhX9gV504l9hWeauGU+CxyTBcYi8wivGwnkDj?=
 =?us-ascii?Q?xE7Np/K43/GMjzBI34lQTvMyrgF/vdyeGbztZ3VL3B+tSN3dlR+Nwk7Cm63d?=
 =?us-ascii?Q?iwR473Nd8RN56bXII0s4+QW1vjwsRgU4VCKnvZdxTLRvgg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6339.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ok9ApIG76wzgv4ONIx3fCMy9Gcb3yt5pfoHF8VHrYdTCknztuCO1w3UGErvg?=
 =?us-ascii?Q?b0tHBxdT9zAYM9VIJrn8rMcj5Zcfm3Xf5uJKylJiT3SSNsi84C4bx820LsKX?=
 =?us-ascii?Q?YOQB474vSRLyV/HUXZQMC5MWZemMO61uoLn1g1/Sdq+g95sVf1r4jnbP0Vks?=
 =?us-ascii?Q?LusGL7UxBneR5KhrPf/Q1lNKdNnj9zx7HEmlGvqDLjP5UvUNhT2RHGKxIpbL?=
 =?us-ascii?Q?hN0aPjpoVcXphJSG2e7MyoOkDRfE9xF25nAeYak82PcO7WI2+txiPVDdWi0B?=
 =?us-ascii?Q?Ixq1MFhxf4ofhHFx2JFf5NyaGNuMM+q4ePoC+JDIVS5hoz/4cIjHCk70u82r?=
 =?us-ascii?Q?OJktw0xGJ+TvViZqFyIn6BnywSav+Qc/GmzqrFO3a60OpKNfI2FVc8hinEyd?=
 =?us-ascii?Q?Fth2BFsSPDVKDSyYXXQgL9PqXvgf8/aqARZfW93GHe/fRxghDvpkXhwI2Cw9?=
 =?us-ascii?Q?M5YQO2p/P/TMFTtNVOjjftbtN8qJUDmuN3k20YsvU9ddcU2fl3yub21Cryne?=
 =?us-ascii?Q?Lsau9CmaPTASDSr7gpexbx6Xk7S/OkJrCgeNF7Fl2RPV+xJrpgkSRlqmiYhn?=
 =?us-ascii?Q?6bTyt0tkRpiO/8QwVQVQNQ8ID/XowRFRvMbtfYh+gJocHOhXQBm+B+CcI39m?=
 =?us-ascii?Q?DPl7oCX4QUZOFwEsoPz4wCXIwhfuPFbWU0CdJ8TsSmXOv5G+kWTFik2D6LYe?=
 =?us-ascii?Q?ctpj4nmPsNPPV4xpPkqJRD8HtlUGR0f1GPB6HAoNh84Fuu66o2SZZvqYv9HJ?=
 =?us-ascii?Q?FkMQFPGk7gnVqQyyLU9DyEAAfQwfArN7NJu3e/hvvbRqp7+dQ+qGpi5pV91J?=
 =?us-ascii?Q?QcdgcDLhOWOmWTFdkT1fDxnzi/foT6IBN37+vi0VxYs8zCHelw58Za6yuD2G?=
 =?us-ascii?Q?ciiF4/PJ2wcelB/QtPq5ZKzjQxM59mhjndyABVfQc7SjBrn8byb7DYOdbweW?=
 =?us-ascii?Q?acvBi5xiXHtA/VJLvt+eKdDLenCCA53H6Fo6jYVSFE5MfzHN44kdmpa+VE89?=
 =?us-ascii?Q?dwakgTWd4kIeuaPYQyBE+xrMtr5XXgKF9Fen+VJPVwPp4bcMTZOZLXjEANRA?=
 =?us-ascii?Q?LZvL8zccS+BOqHAtMeMieF2bR5g04z4Qw6bhVvh2w0ZkHLSNiTn+4KcaFGr/?=
 =?us-ascii?Q?unLSzYx/RDUr4JpPWIaXjnaxCQbkn47irsyAMsO++bgIpAaIVOQTukq2worT?=
 =?us-ascii?Q?nVv6WxAP8cS0EQpyRyyuvA/iSMRnOF6pwDFanl/QOqqX8pGZlrkRF+4fIMkW?=
 =?us-ascii?Q?cOwmZ6MXBRQ9rPUo21xP5RFCHIblaiJ6/P6TaEX7qvps5oTESzbWNgH+aSha?=
 =?us-ascii?Q?hfG+U9zQfNO62pVon1BZETmBvHPLkw2rmI89FnBu56gw5gfoxBx94/Isb/qY?=
 =?us-ascii?Q?ZD6Ll78tPgLY8vEkXxPk6/MpZ7vQpW64mendPoa0AFEa7g8BCeJHCguWYsmN?=
 =?us-ascii?Q?PdpYN1MkO2RLdwobu/6G4SnVt2V4tya7EiRGSrQMaOaZvBph3pwHb6J1yJ0Q?=
 =?us-ascii?Q?TJZbEn3z8ODWlEqHI3BywOofeaoQsrkRMfpJApqr4/qZeI3M2+Y79e85nIp/?=
 =?us-ascii?Q?r5FWGXDlC/yLnpik1J+H9CSUd59XQiKD+kmveXHPZ3ldHhGsG2t65QsyiOkB?=
 =?us-ascii?Q?yuZT0/vJgaSQj19IkqWJeTOa+xapG9NpkOel5BOqJidd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6339.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d1655d0-a091-4b76-3880-08dc6ab81443
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2024 14:56:42.6082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DIq8NijbCCtlhCVwbtQtzsmTAgk+lMVh0qFFPtUBFwzztgDOozk89knYhvDzFHlwOLQXcPbAg4puc9GRCXWsjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8725

> On Wed, May 01, 2024 at 04:52:05AM +0000, Akhil R wrote:
> >
> > I had a question based on some of our customer feedback with this drive=
r.
> > While running tcrypt mode=3D10 with Tegra SE driver, it shows errors fo=
r lrw(aes),
> > rfc3686(ctr(aes)) etc. which it does not support.
>=20
> Algorithms that are not supported by your driver should automatically
> be routed to software implementations.  What errors are you getting?
I get the below error. But this is because we don't have CONFIG_LRW
enabled in our defconfig.=20

[ 1240.771301] alg: skcipher: failed to allocate transform for lrw(aes): -2
[ 1240.778308] alg: self-tests for lrw(aes) using lrw(aes) failed (rc=3D-2)

So, I suppose enabling the defconfig is the right and only fix here?

Thanks and Regards,
Akhil
