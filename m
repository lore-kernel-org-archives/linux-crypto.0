Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2071.outbound.protection.outlook.com [40.107.104.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FD416C6A1;
	Thu, 21 Nov 2024 11:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.104.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732188362; cv=fail; b=C4wMKCMryvrvCXcP/mauC2DscDswd6Rr4beCEavdse1gSjK/3vScJiTrIMZCZfMyBmt0v3XdbLT5T5gfJMwCBAYOxifVki5eRYJT+9VZ0KiDHhDmpKhFqktCajedF+NPUhO11Fvps7qDI8s/xhLtQj2gilGwJucJHLpTp19MhPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732188362; c=relaxed/simple;
	bh=QsAD2tqfkjX7HZbv208FvnjWm40Wfb+l4ICOhQvcpkc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YgplRndoJcpbV4t9ix9lRpspm/ca+l7bKyIQZVbCZ8incJ0MpCQNi7nqj7Butq32FVU5dPGB+J+FiDifizU98Q1UvMRZm9rwd33PS6x4ko+efbVpUih0gUZAotlEbadQyXtgAW6GjF+xqMBj9jfc6uIogSLVUGLgZ5w8lvcdy/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=I5Y/kqU9; arc=fail smtp.client-ip=40.107.104.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="I5Y/kqU9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rQMI9x7Rl60EygW4HoeVGZsIKsg0V9FJIti4Rdvktvb8l/XzYblzWSs9bSAJSRHEgYUf8F/km0gusJ2ufr2/Eodzw+h5eabDzAIJncXExdFi/9g9gx2Ud/aRwiXirfwGUT/QEK9h06d1ZKSLevaC7oRyXYgptfJ29KGXl8HH0kO+5YhU9JtYyvXxv6HPqbptyFS1EcLvPb5Zm7vVNlBiAe8CE7Z+8PaCwRw+uCw/pIxnMGe4BJuOwUg4wKEQJjfisg8HgEKTfsY5oMq/5xc0mjzelEHaF8xudYTOePM70BQZ9gyLTilO6sE4UtXHu+lAcYkN8fpM3K5dfKq8Iix1vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FfFRCE7yOxSXEOqbYH+4L5WgPX3Vjq5f+fXFVBEY4+A=;
 b=Kz8qd/4x0zd6jmZYdTOzsgbmSxXpArNeL9vDP9eb0R19V8I65w2n0GJxxzkW5QEeCw4DlGL6QggKJtupGCnCZ/P9IYkLMkTCofzmOncsZ9v5dREoGVoIaVKdIwuQbuTSR+3JMEOlaKRgrHv5a4piesxS63bVm7Yp/jnb9S+uhxoPoeWVASdQY2hE2myEtwJrOrDlM49ALtbteqbvaO8oTa8yUnvTdd86JSqUcXk+qr7ArA08anlSv0YL9TLzxf7kp0G2W/Vu76XEuiZu8awQF48edKOv3fSan9wurCeqZY1D2rUOyMXHPo30cyGJM4o/4Cra3b8HLfA2xiUDG7xOjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfFRCE7yOxSXEOqbYH+4L5WgPX3Vjq5f+fXFVBEY4+A=;
 b=I5Y/kqU9sdMhUH5ws6oco9vkqGJaz+QamqFOy3YBb8AcUPT6nc2VjIcO53JJvtnnyWG46Dbw4eRpm5DfX0doqOpggBCSQ7EtrvTLHVlD1rbwqacxkd8My2iCIwVWL+agJjR5K0qNuqeJp1mY2X8oEmooms3gpSjhw0wqiWw7F7RpdSSX8LIif6uCNB+qzpe2D7K9uJSfgovsabqVOg98MkgX0V30IpHs79oCVGm825dM3NOyEk92oIRJ220VLAKm1T3D1PasLjklQmn7MT/F4HaKC+TclA9ZJ/WDCsp7SbzieL5D2bqYAJ33bhbGKSyPBK1BA7H4div41drqKbvskA==
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com (2603:10a6:10:244::6)
 by AS5PR04MB9894.eurprd04.prod.outlook.com (2603:10a6:20b:655::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Thu, 21 Nov
 2024 11:25:55 +0000
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637]) by DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637%3]) with mapi id 15.20.8158.023; Thu, 21 Nov 2024
 11:25:55 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: Ahmad Fatoum <a.fatoum@pengutronix.de>, Horia Geanta
	<horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	Silvano Di Ninno <silvano.dininno@nxp.com>, Varun Sethi <V.Sethi@nxp.com>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>, Sahil Malhotra
	<sahil.malhotra@nxp.com>, Nikolaus Voss <nikolaus.voss@haag-streit.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Pengutronix
 Kernel Team <kernel@pengutronix.de>
Subject: RE: [EXT] Re: [PATCH] crypto: caam - use JobR's space to access page
 0 regs
Thread-Topic: [EXT] Re: [PATCH] crypto: caam - use JobR's space to access page
 0 regs
Thread-Index: AQHbNDLCDWLDusYcd0ahxOrmX4dKwbKyAD2AgArNUHCABM6tgIAAClCQ
Date: Thu, 21 Nov 2024 11:25:55 +0000
Message-ID:
 <DB9PR04MB8409639D69460AFBB9FE6DF9E7222@DB9PR04MB8409.eurprd04.prod.outlook.com>
References: <20241111121020.4013077-1-gaurav.jain@nxp.com>
 <93e915b3-ef8e-4b98-aa7f-7759ae0b3091@pengutronix.de>
 <DB9PR04MB8409AC6672B7A209ABC8F9DAE7272@DB9PR04MB8409.eurprd04.prod.outlook.com>
 <54c5de0c-3c5f-4411-a345-a34852cf9112@pengutronix.de>
In-Reply-To: <54c5de0c-3c5f-4411-a345-a34852cf9112@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8409:EE_|AS5PR04MB9894:EE_
x-ms-office365-filtering-correlation-id: 67fbc3f3-8bbc-4b23-ef87-08dd0a1f43b0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|921020|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?vL5oaoBvR2URKD9hNJisndW10sLAqV5CJo8WypI4W36ela7SPoJY1W8kG1V+?=
 =?us-ascii?Q?lEIUQ6/rS50BiWdY++QsN9ZUIrFcEBnScHhVq3ENFTei2F5CWk9NPBehtSVE?=
 =?us-ascii?Q?/qzGIL+67HjsCrbbplQLAV0bz7kco1v0WFaHcf6/7+tn7PmhleuHByGVa2GJ?=
 =?us-ascii?Q?Ta8++IYQTYYb0Q5VxigkvgOWZQ6EGNgUWUo7L1I11ssVNgTImo6PR09JOojh?=
 =?us-ascii?Q?8IW4RwqDYdPVNYBju83+pAcXFEQ0xbfzLZ31kxRVIG3nLcub1ERaVCNIKu/L?=
 =?us-ascii?Q?fMsB50vQI6TmfpC3wwVUzAv1GY+rsGGY/kvpvq6MNzSvQQHMzgMHXUchtMr7?=
 =?us-ascii?Q?2zhK4GgkJvmmQEle/LzawYhXPlE93ZdSZs3D4J6aCLjFMpxp4i+xINyQfU3+?=
 =?us-ascii?Q?hWPNKJ1Yr01TopW8WZv3PRtgFBv1hASmFsnkMXVWWu5WRHAcBKOO1yEaLq3l?=
 =?us-ascii?Q?t0QIGy06mdtd1Pd7PSgxCA4nvkJKxp1TOgKsHyCWODVLUUNMrp0HKjsKCofc?=
 =?us-ascii?Q?jATqNPOQ53wR7F3mJF6JDTTQFiiKUup5SBEOOlX4MERIeZLS95Yq8c9eFPFB?=
 =?us-ascii?Q?aJ9iosP0+hABhtyo+Dn5d8SoCn79aD6kirWNAQA8CA/i/e/Z/AJmwgp+XoJ8?=
 =?us-ascii?Q?oki4hiA5xi49W3+ELXjDfqOnHMp8N2sx2gCCU5fUR7simxJYoAD2GAqyShwn?=
 =?us-ascii?Q?maOjOqV3LVeU4cdw44tjObdl9OYUhozs+eU8r2ZbsyYLJYHEj2lttjzuWwm6?=
 =?us-ascii?Q?ercH5CI3+CXLIGfKLnQKgy2t/l2ViT4cHXtGG56g8K93J8vuZVfVQmZtva2a?=
 =?us-ascii?Q?B2Ru1xRBrIUIoGlkAZ7sd63EopVIW4S0f92YzZHQuOIipEOa4r6L7uP1DIQI?=
 =?us-ascii?Q?euPVnngm32bW0AuTJrS+Mqs59N1epLVUZ9nTg6RGeSKg3ejq0k4vUUeAVAUk?=
 =?us-ascii?Q?IimnDiA7sk8nn/ZSNsMYu8bXHt9TStJLRD+5QPDQrrAtVKFllNi2bts2jswR?=
 =?us-ascii?Q?sHeSWc1tb0vbQOfQHAsKdxcQbCNtyBUiKcFIE6FOqFTi0yMeRAKMTQa/rY/z?=
 =?us-ascii?Q?AYDImEM+MYdo3Ud0XsEVeTWlCo3PVTXnQ42yYHAU08qdE1oJbPTo9TKmzpFf?=
 =?us-ascii?Q?qbX+TwFb74bXDrIRIn2B+JqIiZw4HPF3P2D5KCGfVjQmL7TJ/R3oZeNewVTo?=
 =?us-ascii?Q?ZH64PSOo4OWRnrYV7Z923nkfZxmHeFbC1msWn7j90kHLgV58Tosry6oNWZqn?=
 =?us-ascii?Q?niLy0fpD/RryxjmH1ce0t5nJOi9i3DA92Rg+mHq7XzzrQN+8yhEVVIIFVgD3?=
 =?us-ascii?Q?x1oyjUVdtJQXrfhfSa/zJbLLaSe8Q2E6I1FJ0U+a2kq9FGTGUlTVvRrvowiR?=
 =?us-ascii?Q?sI/T8/cKxyUxEFlv9+FqWQtng2Ns?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8409.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?gEDjRe5k9PsDeITD9rndM7niAaqSGGhqpAgPH9KVIvQDioYtorkbsI+6TidN?=
 =?us-ascii?Q?lKjgEamoxMiViq1GiaTgeg7JQ16dO/SZTGYqQh5LSlyF/F+Ij2Z6TSkk4Kta?=
 =?us-ascii?Q?DTmH1F8k4F7MRzbxFMcMvbkd25unu/Kyal5amAdSMt/c5XGsKDjQU5vxwbQK?=
 =?us-ascii?Q?6b2mRdz8FmPhndTbpdjJ4xim8a4qFp7TaWJd0RSyFQnO+4P05rUpbTOUv0Af?=
 =?us-ascii?Q?5pRQviG0bVjlx3ziilOOATykb5s3BnQ7UQhdtC/tr9WbHCeBQ3GmMeggZrE/?=
 =?us-ascii?Q?XSM5pLwu02TeeANkMR84kXmMUJ5+MgLC/lzfkCTMAVgD5g8vk6u//mVAUx2k?=
 =?us-ascii?Q?coKbSk7heIOkm34NPQtbu0N5+1Uq5BACy9wCN9G0DyF4r3RJh0a+P6YFWYV/?=
 =?us-ascii?Q?P2lYNf0QduIe9SjG3B+DYyOpJhQZ63Rao0AZAWl4Ugc8NBq7PvGwCCc6xMO1?=
 =?us-ascii?Q?vQnFFEICXi5NsDaO6O9Vyiaye4kCmaH3eeHa0sl+DVc0j0CL1looVCEYhxwi?=
 =?us-ascii?Q?q9I52FDCHpqFSEK0yO6sTK3s8kYOA1CyD8MSDyqnOcI6p/UUfLj1tcAJECrA?=
 =?us-ascii?Q?84ptt9EIaYSvy4FG59v+mKYDFt0acFgaDEE438GU0hm7ZRa4rICErnzvXdFU?=
 =?us-ascii?Q?zpXTWFNorppYGc1Meo37Pfmh9WFYXTuZ/RcDEkpes+7d7wv+Xzx1ROWCpLnA?=
 =?us-ascii?Q?YEokhxX+ZgiW8dc41cqGjcm1PBlbGAqaFbqvXX1772HLH0aTER8qoVF1iikJ?=
 =?us-ascii?Q?5PqF9Pf4XqqkfEsRUWxTsFs0j8LVxOjEMCa35pSKTdeLFTWLlo23I+9EUPZC?=
 =?us-ascii?Q?W68b/J1purG6tE8Xu2YsMBnwB2zeK+hevkb5ic1hCGM40WNivcxRGzE77OzQ?=
 =?us-ascii?Q?krcUXAd74vaUylKeKjURkDBL7EM+sBxdCjhHvNinQHm9Bcl6lcw+PaBhc6jX?=
 =?us-ascii?Q?i88tEFG7Pmbm/9+emzQxx94mVprD4yYfqlY4eX5HFiPEShkKtqvThQjnHks1?=
 =?us-ascii?Q?GrQAlUgxU7ozA0ZoKcK19k97p8CJFCzGy1cG65NB3txP2kCO/f77UymGiXmf?=
 =?us-ascii?Q?Km22vDII/5SrJzL2R6cLFsZoddHxvSrFrO48UfYX1JQy9WeEv18e8Jg/8Qv0?=
 =?us-ascii?Q?tulPSnrioLjvquTvKdDRmOPuFdySjmLid79UIYN0yjMwGc3bdESYYvqYRNj/?=
 =?us-ascii?Q?6FPqUrugq2T1LgNh31NnmTQhAUc79ORU/pOtlpb/O9+tq0tkV8RCwZnHIQNo?=
 =?us-ascii?Q?R/TG+qBSdx26rwAFtevUoHejuSNng96yI+OrmbOIJ+UsFPxKcda+4nGCBqyQ?=
 =?us-ascii?Q?KDOo4qr24FEU3EQsCYZoQ+uvBA8yigYV7rFY5puEo94eL2intKRnISmA3014?=
 =?us-ascii?Q?QsL+yMhJr+5xDCwQ05qrSSniASUyIW322f6sJBLOV7gw9UIsW/rUB7d+Rufs?=
 =?us-ascii?Q?umV2x3MFzK91iXYIyV12ZiJ7th3m7yIEhjIwMqZiN/gMZJX9gmez2rk4U6ZX?=
 =?us-ascii?Q?Lj9/D+8/MOV9cvnmAAwouRnap8d9K00wKda91vKrXYnZHJYFeLCQQxCwOEHX?=
 =?us-ascii?Q?vlUzbuEHGhUiL4AQc0kK6TzsiMw9DM+zmMXE+Vwh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8409.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67fbc3f3-8bbc-4b23-ef87-08dd0a1f43b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2024 11:25:55.2105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mbf2+9/7BiSBtkNI1H+tlA9wQJOWh6pO84PihGS3kSLi9OCLTsws7xwFsvmeTtcFvBlbCYZBc0wvqr9LY/uBZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB9894

Hi Ahmad

> -----Original Message-----
> From: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Sent: Thursday, November 21, 2024 4:14 PM
> To: Gaurav Jain <gaurav.jain@nxp.com>; Horia Geanta
> <horia.geanta@nxp.com>; Pankaj Gupta <pankaj.gupta@nxp.com>; Herbert
> Xu <herbert@gondor.apana.org.au>; David S . Miller
> <davem@davemloft.net>; Silvano Di Ninno <silvano.dininno@nxp.com>;
> Varun Sethi <V.Sethi@nxp.com>; Meenakshi Aggarwal
> <meenakshi.aggarwal@nxp.com>; Sahil Malhotra
> <sahil.malhotra@nxp.com>; Nikolaus Voss <nikolaus.voss@haag-streit.com>
> Cc: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org; Pengutron=
ix
> Kernel Team <kernel@pengutronix.de>
> Subject: Re: [EXT] Re: [PATCH] crypto: caam - use JobR's space to access
> page 0 regs
>=20
> Caution: This is an external email. Please take care when clicking links =
or
> opening attachments. When in doubt, report the message using the 'Report
> this email' button
>=20
>=20
> Hello Gaurav,
>=20
> On 18.11.24 10:31, Gaurav Jain wrote:
> >> -----Original Message-----
> >> From: Ahmad Fatoum <a.fatoum@pengutronix.de>
> >> Sent: Monday, November 11, 2024 5:52 PM
> >> To: Gaurav Jain <gaurav.jain@nxp.com>; Horia Geanta
> >> <horia.geanta@nxp.com>; Pankaj Gupta <pankaj.gupta@nxp.com>;
> Herbert
> >> Xu <herbert@gondor.apana.org.au>; David S . Miller
> >> <davem@davemloft.net>; Silvano Di Ninno <silvano.dininno@nxp.com>;
> >> Varun Sethi <V.Sethi@nxp.com>; Meenakshi Aggarwal
> >> <meenakshi.aggarwal@nxp.com>; Sahil Malhotra
> >> <sahil.malhotra@nxp.com>; Nikolaus Voss
> >> <nikolaus.voss@haag-streit.com>
> >> Cc: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org;
> >> Pengutronix Kernel Team <kernel@pengutronix.de>
> >> Subject: [EXT] Re: [PATCH] crypto: caam - use JobR's space to access
> >> page 0 regs
> >>
> >> Caution: This is an external email. Please take care when clicking
> >> links or opening attachments. When in doubt, report the message using
> >> the 'Report this email' button
> >>
> >>
> >> Hello Guarav,
> >>
> >> Thanks for your patch.
> >>
> >> On 11.11.24 13:10, Gaurav Jain wrote:
> >>> Access to controller region is not permitted.
> >>
> >> It's permitted on most of the older SoCs. Please mention on which
> >> SoCs this is no longer true and which SoCs you tested your change on.
> > Yes, it is permitted on iMX6/7/8M SoCs but not on
> iMX8DXL/QM/QXP/8ULP.
>=20
> Ok, please add this to the commit message.
Ok, will send v2.
>=20
> >>
> >>> use JobR's register space to access page 0 registers.
> >>>
> >>> Fixes: 6a83830f649a ("crypto: caam - warn if blob_gen key is
> >>> insecure")
> >>
> >> Did the CAAM even support any of the SoCs, where this doesn't work
> >> anymore back when the code was mainlined?
> > Yes, for all SECO/ELE based SoCs, CAAM page 0 is not accessible from No=
n
> secure world.
>=20
> Same, this information needs to be in the commit message.
Ok.
>=20
> >>
> >>> Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
> >>> ---
> >>>  drivers/crypto/caam/blob_gen.c | 3 ++-
> >>>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/crypto/caam/blob_gen.c
> >>> b/drivers/crypto/caam/blob_gen.c index 87781c1534ee..079a22cc9f02
> >>> 100644
> >>> --- a/drivers/crypto/caam/blob_gen.c
> >>> +++ b/drivers/crypto/caam/blob_gen.c
> >>> @@ -2,6 +2,7 @@
> >>>  /*
> >>>   * Copyright (C) 2015 Pengutronix, Steffen Trumtrar
> >> <kernel@pengutronix.de>
> >>>   * Copyright (C) 2021 Pengutronix, Ahmad Fatoum
> >>> <kernel@pengutronix.de>
> >>> + * Copyright 2024 NXP
> >>>   */
> >>>
> >>>  #define pr_fmt(fmt) "caam blob_gen: " fmt @@ -104,7 +105,7 @@ int
> >>> caam_process_blob(struct caam_blob_priv *priv,
> >>>       }
> >>>
> >>>       ctrlpriv =3D dev_get_drvdata(jrdev->parent);
> >>> -     moo =3D FIELD_GET(CSTA_MOO, rd_reg32(&ctrlpriv->ctrl-
> >>> perfmon.status));
> >>> +     moo =3D FIELD_GET(CSTA_MOO,
> >>> + rd_reg32(&ctrlpriv->jr[0]->perfmon.status));
> >>
> >> I believe your change is correct, but I would prefer that ctrlpriv
> >> gets a perfmon member that is initialized in caam_probe to either
> >> &ctrlpriv->ctrl-
> >>> perfmon.status or &ctrlpriv->jr[0]->perfmon.status and then the code
> >>> here
> >> would just use &ctrlpriv->perfmon->status.
> >>
> >> This would simplify code not only here, but also in caam_ctrl_rng_init=
.
> > As already communicated by Horia, a separate patch is good to cover thi=
s.
>=20
> Are you interested in writing that separate patch?
Yes interested but cannot send this change immediately. later will do it.
>=20
> Cheers,
> Ahmad
>=20
> >
> > Thanks
> > Gaurav
> >>
> >> Thanks,
> >> Ahmad
> >>
> >>
> >>>       if (moo !=3D CSTA_MOO_SECURE && moo !=3D CSTA_MOO_TRUSTED)
> >>>               dev_warn(jrdev,
> >>>                        "using insecure test key, enable HAB to use
> >>> unique device key!\n");
> >>
> >>
> >> --
> >> Pengutronix e.K.                           |                          =
   |
> >> Steuerwalder Str. 21                       |
> >>
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fwww
> %2F&data=3D05%7C02%7Cgaurav.jain%40nxp.com%7C0fdec24d19fc4e21578
> 308dd0a197a2c%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C
> 638677826741678192%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGk
> iOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIj
> oyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DRKumouL64QDlhqgV8lV%2FHetWt
> cU2bFLctzolWoY5iDo%3D&reserved=3D0.
> >>
> pengutronix.de%2F&data=3D05%7C02%7Cgaurav.jain%40nxp.com%7C758768
> >>
> 98a8044b366f4808dd024b7740%7C686ea1d3bc2b4c6fa92cd99c5c30163
> >>
> 5%7C0%7C0%7C638669245367988594%7CUnknown%7CTWFpbGZsb3d8e
> >>
> yJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIj
> >>
> oiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DaaQ65iMsvuHn3q
> >> 0bo5UU%2FYU7Fpyw3El7wNVHd%2BMNee0%3D&reserved=3D0  |
> >> 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0 =
   |
> >> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-55=
55
> |
> >
>=20
>=20
> --
> Pengutronix e.K.                           |                             =
|
> Steuerwalder Str. 21                       |
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fwww.
> pengutronix.de%2F&data=3D05%7C02%7Cgaurav.jain%40nxp.com%7C0fdec24
> d19fc4e21578308dd0a197a2c%7C686ea1d3bc2b4c6fa92cd99c5c301635%
> 7C0%7C0%7C638677826741698749%7CUnknown%7CTWFpbGZsb3d8eyJF
> bXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiT
> WFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3Dh09U3v1B3wkZdemP
> IyiRsoMlDuRMPG%2F2IgXkvqdAOng%3D&reserved=3D0  |
> 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    =
|
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 =
|
