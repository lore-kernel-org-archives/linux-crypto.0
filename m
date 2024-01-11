Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2041.outbound.protection.outlook.com [40.107.104.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AD814AB7
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 10:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="e/umVYjx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SlVUYhbqZtVaFR+Gp3zuEQ5J6715VV9kHYOJqLS9I52GQEwJRDZLGOrZ5EXPEvJx++KfFxeoHadyJAV04DppX5Mt053ERZvW83L1E/bCpVbCxyxeKatfxmUImIhx3iU4HCzJQDQ/5d8DEicXfI9NbsylN6fgmuPdAwUqMn+dBbG8GW4OjkEgdgkX8v7uh5q7ew/BY2kMqv60UvD/9+oM7d4fPRVIJebRfc3ySnTKVMSj6oYzZ7nuJ2ujDaNifajdWXk50FtEdv/w8wTAwvOJcIz75mZt7mt/XzTHZ+bgU1zkIL6aetJVunk3Ag32B3Zx/4569xZMeqbRCrOUtSrDQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMKyUlZzyDhyBVvUmNQRw17RWGKJ5pjqvv1HCxbf2ug=;
 b=m4vgQ4Z0B1j3TUGA3HaT2Iu4r2m2cm7LYWUIH4IEbowZ7v3CmOh/OypTkWnkw264nv4Wi829usWJ41OJUCWpawR3zNocvbuJNlPfvr5CjSuuq+7eoyH7X8plzgTao6fHPA6XX40HljVosc1IPciiRIE+NICzqN1kOchE7kYtxj/6CaoVoXAfw6BzySnBZcDJXj57vWjl4SnmlsdDfgSZv5W6Ewghfd1HfPCgEG6cd5eSe2H+1FF2KP2LvVAHIkxeumxM6MJ1c5bEsJNwNz5EsJqfpN09K/Pep9FXdHizkAaUy1dtik8YH6ejVOrR3Ha+gGp+85YGwcJEVnJKivpJMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMKyUlZzyDhyBVvUmNQRw17RWGKJ5pjqvv1HCxbf2ug=;
 b=e/umVYjxazfDjOxy3LyZOTAbubneCgqZwqq6CFz2PAUoe+mgW89/fAA1YKWUEIVbqbPnODkZbxw3l8dWNEnYV3cJrQebs1KXQZzYlIe3sZhTr8CoFXI31oZ2FwVcVBbpqgtpSPTpwfesvpXtsZ7ZF+5wdxQG31G3udYppQ61uCk=
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com (2603:10a6:208:11a::11)
 by AM8PR04MB8003.eurprd04.prod.outlook.com (2603:10a6:20b:240::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.17; Thu, 11 Jan
 2024 10:46:36 +0000
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::72db:548e:8011:b12f]) by AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::72db:548e:8011:b12f%4]) with mapi id 15.20.7181.015; Thu, 11 Jan 2024
 10:46:36 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: Kun Song <Kun.Song@windriver.com>
CC: Varun Sethi <V.Sethi@nxp.com>, Aymen Sghaier <aymen.sghaier@nxp.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "filip.pudak@windriver.com"
	<filip.pudak@windriver.com>, "heng.guo@windriver.com"
	<heng.guo@windriver.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, Horia Geanta <horia.geanta@nxp.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Meenakshi
 Aggarwal <meenakshi.aggarwal@nxp.com>, "richard.danter@windriver.com"
	<richard.danter@windriver.com>
Subject: RE: [EXT] RE: [PATCH v5.10.y] crypto: caam/jr - Fix possible caam_jr
 crash
Thread-Topic: [EXT] RE: [PATCH v5.10.y] crypto: caam/jr - Fix possible caam_jr
 crash
Thread-Index: AQHaQ56ceWii/sYVC0amEMLId/XZerDSu5zAgAA1WoCAAXn9AA==
Date: Thu, 11 Jan 2024 10:46:36 +0000
Message-ID:
 <AM0PR04MB6004AECDD044F1E6BF3B6732E7682@AM0PR04MB6004.eurprd04.prod.outlook.com>
References:
 <AM0PR04MB600455078CE01BE8246117B7E7692@AM0PR04MB6004.eurprd04.prod.outlook.com>
 <20240110115653.3170977-1-Kun.Song@windriver.com>
In-Reply-To: <20240110115653.3170977-1-Kun.Song@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6004:EE_|AM8PR04MB8003:EE_
x-ms-office365-filtering-correlation-id: 3223f9e8-ff80-4fcb-496a-08dc12929578
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 eAmku/kDovEuxEZsQ0E5X6TMrFq5Bc9z+5jgcM21enxaW+TRTjcqKt7pQEz0jOsv0r2GyZNl6p9C3gHOaAOYqJMK9ByhwmHcbdObxKBEFgN/mDDpvY8lFJM1BsfF4r7O3yl9ERpQzwz3egYinLQZiTUxlRx4KrDAKw5ffh8XjV0rwo7JkqD/PskWBFr9/RAxAn+pVKUaIDY9h3e2AiF7S0kZ8uYrAl8vOHYe3If4Dv4tB9cXD/sJqp1OLW9g9QS3rEf5wyJzI3ctr+OUIXfjSYcDOQStXrOv5UUT10Zklgpjv6zb0DCkq0KNcVEDbEFI24GKPq4Ozx8fXRL/iYFS9CuLKcmh7YPCwpr7APpWuBFQvm00QkdwjZFEm7LjjeLV5E14FQC6DNdiul3hTQNoY6M1op2UP3uqoUM7GNFy7XFlB33/ZGhG3G+HBwXHpl0ceDk9i1ZHkNw7cbZ4lNnzIDBmRBRaybGSwBf22wADhOAV2EoYx84ps5qaajQHviN+WLl47pgMvb2u73FwWN3RuITDyI1aZG3rxCIC8fzn/Lx+9eN5kbLiwX+AcHqxxlZZLCAIy/LON7e1j51ugsbSyIia/RYP9g8dfEVeUhgsr2/3VIzX2DX2CyXEfmZ0dZZfKu2X37qT65anmjkSOuvK2A==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6004.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(39860400002)(346002)(376002)(396003)(230273577357003)(230173577357003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(4326008)(5660300002)(44832011)(8936002)(8676002)(52536014)(38070700009)(2906002)(41300700001)(6916009)(64756008)(966005)(478600001)(55016003)(38100700002)(122000001)(45080400002)(6506007)(83380400001)(7696005)(71200400001)(26005)(53546011)(55236004)(9686003)(33656002)(66946007)(76116006)(66556008)(66476007)(66446008)(54906003)(316002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?/VeQ6l3ZIAwIB9MNEdIr8iQy7eMyQ3eIoJh6rQ7G0NUq1dxzpoPLxWrLxn05?=
 =?us-ascii?Q?gLx283AP4ecuLvw6cl21iz07HInIhuEPJLeRhollGWdTKluFBBDmy0kvKiOi?=
 =?us-ascii?Q?q4Vx7ibwlSZeZsCBVgI4LhCR/L+XbHdcVTSVg2MKLr5aqT+bl/gniDtUyZDm?=
 =?us-ascii?Q?betDpt54wwoLcqbBFyt03cj1JARF+lF8DAgax30XrnZ0ZkP69oBEbHSUcyV1?=
 =?us-ascii?Q?6e5nbyAlC9ENF9xJpuni1iffNvncXSnfEJgCLFKyykUoM6wavsNnHIWJRp2M?=
 =?us-ascii?Q?C34JImE+5wAFPa20Zn1LjfMPPj7IDov8SKVyA/xJUo51uc7qTWI3iQVynfs+?=
 =?us-ascii?Q?xeqCiaV4bji6tSnfPuzh3E9RaWhMyFz6FgWmcV5MNmzKYw6IV6wue5a4XCwQ?=
 =?us-ascii?Q?5YiLsL3wlFd5p6txTGuTpHvsv4D0IdFg/zpYaEwg/17ujLWhym6xAnVVVwTi?=
 =?us-ascii?Q?SEAk+bPZVmqOM+qEoQPWpmXmL/0NTd7PIkYUKQ2d//pxjXTXXmyyYO71OxBF?=
 =?us-ascii?Q?djUMk4rZ1zWsjB1it/yfnDLBtM4dWePjZPM4c/7gmeQ/+dqeAt+7qq7DZrVI?=
 =?us-ascii?Q?pOXeWvcdqtkWqdXM6GvLpsFpa0HrNZzxh34CQOo+Ubu7VvKm6wSebSFnbc3J?=
 =?us-ascii?Q?H8JHFje6jhT8EsbyrDncxOy8CcajlztbIOXtuaff3WtKw+Y6d1w22ECAK52A?=
 =?us-ascii?Q?PrUtuzBWXA9phyYQBg+tMTrzz485UX9sB5iolTpHBT21ZkpTJdSlDTEGnSPl?=
 =?us-ascii?Q?HaZUyNlPArZor9vdP/O1/h8WkeUBIcqeaKIXhU8ekabRDoLEEPRvBXS5nsbR?=
 =?us-ascii?Q?7Gsm3EeyqHJJ7Lzs3oyyU3VPmwxC5U+h5IdWTCG1SGqGUPAuIt76JtSoYT1G?=
 =?us-ascii?Q?E9tJXsBYfP9qeVi4sCZRQf+Nyajv+JF3Be13WJNMCjTrQA40TvsLQykl+RyN?=
 =?us-ascii?Q?i7vNLWjjSWe1FglbNUUtJ1T/jlZCCZ3PZQHkhgTZIRdvdBiV88AZrtZpQ7fX?=
 =?us-ascii?Q?uZ+Y3K83888212xhpvy7CnzEm8RULFVnzNo0r65cFx/SKHdZyai3XtjJmrdw?=
 =?us-ascii?Q?ipM7XsrREfZMhHAesslpJlbny7p5PaAKSYAalkgIRWbJaCqcyZH6w001Z5wK?=
 =?us-ascii?Q?5E5R1jzctZXUUsKpj2C69gRTxoQ0JQXmfLNDLJCD9np56ARecCsgYdS93TPt?=
 =?us-ascii?Q?PLo+oEZv916T4rXO2q4Th38CsTyW1YoSejqB/F8mz9i33CcSkPCSajbE3RxH?=
 =?us-ascii?Q?6+L2WiXSCXnRxHtJlV8eLjdK3nmZwFxhTG2uvgXJ5HSqrMhxGo8sZzvEtNCn?=
 =?us-ascii?Q?5VuCeE8w+Vna8ksJj4xN/DQstfg2eKjq1I0Qr4jNZ6DS7iIMZuCCODf3XyGQ?=
 =?us-ascii?Q?MZWrBYCQDgFVz5Y6XZPZoRD8zusVbosF8PN86Q66H1ROb3uuftYEgV3RRoKZ?=
 =?us-ascii?Q?bkL7CLu7TkE3qx24qwxQZC8SsivAcTYGxjPJom0O4MZo5AB2Gv9C6fRsumlo?=
 =?us-ascii?Q?r5Doy2HSQ5nMzWG3q5h4YEj/99JLiPoKaYvAocc3Rj+hqFQPn67DSy7RrhU7?=
 =?us-ascii?Q?MtgL4Rp1cSePpVi744UXd3P18w3gExVAkPWDNXaP?=
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
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6004.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3223f9e8-ff80-4fcb-496a-08dc12929578
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2024 10:46:36.1885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VMgkUVYzm3fMJvJescF4YI/fGHXkWUyV8+093RxNveI1Nc4e4TppOTJtk1uEmvfR7Jlay67+ns18oBPvFdFKvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8003



> -----Original Message-----
> From: Kun Song <Kun.Song@windriver.com>
> Sent: Wednesday, January 10, 2024 5:27 PM
> To: Gaurav Jain <gaurav.jain@nxp.com>
> Cc: Kun.Song@windriver.com; Varun Sethi <V.Sethi@nxp.com>; Aymen Sghaier
> <aymen.sghaier@nxp.com>; davem@davemloft.net; filip.pudak@windriver.com;
> heng.guo@windriver.com; herbert@gondor.apana.org.au; Horia Geanta
> <horia.geanta@nxp.com>; linux-crypto@vger.kernel.org; Meenakshi Aggarwal
> <meenakshi.aggarwal@nxp.com>; richard.danter@windriver.com
> Subject: [EXT] RE: [PATCH v5.10.y] crypto: caam/jr - Fix possible caam_jr=
 crash
>=20
> Caution: This is an external email. Please take care when clicking links =
or
> opening attachments. When in doubt, report the message using the 'Report =
this
> email' button
>=20
>=20
> >https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgith=
u
> >b.com%2Ftorvalds%2Flinux%2Fcommit%2F06e39357c36b0d3cc2779d08ed04c
> b389eaa22ba&data=3D05%7C02%7Cgaurav.jain%40nxp.com%7Ce1aa575fb6344e
> d3c60f08dc11d342fd%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C
> 638404846267170151%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMD
> AiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&s
> data=3Dx37XZurb8Lu%2BGnJtkPUeCkBnZfOROXxo6rl4XNBzM18%3D&reserved=3D0 -
> drivers: crypto: caam/jr - Allow quiesce when quiesced apply this one as =
well.
>=20
> Hi, Gaurav
>=20
> Our version has backport this
> commiti(06e39357c36b0d3cc2779d08ed04cb389eaa22ba), but the problem still
> exists.
>=20
> When crash occurs, the log will output
>=20
> <3>caam_jr 8030000.jr: Device is busy
> <3>caam_jr 8020000.jr: Device is busy
> <3>caam_jr 8010000.jr: Device is busy
> <3>caam_jr 8010000.jr: job ring error: irqstate: 00000103

I have discussed this issue internally and this is a known issue. when caam=
_jr_remove is exited with EBUSY,  caam JR is not released.
Disabling interrupt is only avoiding the crash for the jobs sitting in inpu=
t ring.
As mentioned in the commit https://github.com/torvalds/linux/commit/304a2ef=
e9d55875c6805f3c2957bc39ceebbc5c0
jrpriv & other register are freed automatically. So any calls to JR driver =
via crypto api will result in crash.

Regarding this problem, discussion have happened in the past but not conclu=
ded.
I will reinitiate the discussion to have a proper fix and will add you as w=
ell.

Regards
Gaurav Jain
>=20
>=20
> Thanks!
> BR/SK
