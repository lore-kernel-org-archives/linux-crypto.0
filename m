Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2085.outbound.protection.outlook.com [40.107.20.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28E0364A9
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2024 06:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="lwHz5BSq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ot6ZDpCGeTHsRf//+jjkKQ1QPByk0DwPcTk3SHoXN419AVhY4J5w0d6sWs/Ou2W1OiWXh3otODDRXRnKGiK46Lxyhf4CBsrpMzwmeoNeTnoZZjwx+6BzFt6T/zWKUj+UTrZXcqVZc3uQCOrp5chAjpi9TN3bZw6AS5NfbL0/Vvz0dfcCEi0EkygYahwyUEtomuTTsrS6mZZ4joX4NT4/obcMNL4IFuxkOcrhce986Lvphr5jLoo/MQRqLZG4UZlCj3sIPV7b/LGv8F6TiN/q9JcrSlaz2uCOF6D6IoZWc55QY4UHvPWs6cr9NTLkKrWn7GPUdHGs8SMfRQqZCYaouw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=atshYFnVVkGlXd2SB29sz4LPMHpvF/BEN2tB8fIbCHs=;
 b=dBbtHIANHn5NxkvyPGs2Tl/GThvpYYOkHqI6tvdcJB/yGUgdmAAjM1ESK9KbzTLO8bc9dhunPThmMc//v6Ywckjt2BxfWbwlz1hy7qSOhe4DiO71CwmC/JMTq9YBrLEpPvSTP99dnZ/bRWSDdpwPDjpnEHktXdQJ8tfHnHs7zD1zr+fOW7z+fy4EoNrlb9dt2datJvPKtnvrZipRPRN6iGW/ZnHIXFxbRHfgHCE51/4L4tg56w3W7hDLpm72hCid60qlGVigFRw9sxMbAn98crveM5lyUJeZ5yAVXuUX9nL7n1hUdaXsmf6q1F8CiFRnRbaWmzHXAWA8+A98GegMBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atshYFnVVkGlXd2SB29sz4LPMHpvF/BEN2tB8fIbCHs=;
 b=lwHz5BSqClxEI3VLuGIAzTl1pH8u1JXo5HK8Z5qxdPuFJVitrwei5h4+WV0spaWcVinkHFrvG50PaTishdrb+D/KiTvYdbjxbH1WpzZrS0vfAxo6Z9Wt2dSNzkdqGQkS/4hbEPAzs6rvBKwFqJjqc9J1cYfPv9iIvk0UrX293as=
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com (2603:10a6:208:11a::11)
 by AM8PR04MB8020.eurprd04.prod.outlook.com (2603:10a6:20b:244::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.27; Wed, 10 Jan
 2024 06:58:36 +0000
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::72db:548e:8011:b12f]) by AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::72db:548e:8011:b12f%4]) with mapi id 15.20.7181.015; Wed, 10 Jan 2024
 06:58:35 +0000
From: "Gaurav Jain (OSS)" <gaurav.jain@oss.nxp.com>
To: Kun Song <Kun.Song@windriver.com>
CC: Varun Sethi <V.Sethi@nxp.com>, Aymen Sghaier <aymen.sghaier@nxp.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "filip.pudak@windriver.com"
	<filip.pudak@windriver.com>, "heng.guo@windriver.com"
	<heng.guo@windriver.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, Horia Geanta <horia.geanta@nxp.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Meenakshi
 Aggarwal <meenakshi.aggarwal@nxp.com>
Subject: Recall: [REMINDER] Re: [PATCH v5.10.y] crypto: caam/jr - Fix possible
 caam_jr crash 
Thread-Topic: [REMINDER] Re: [PATCH v5.10.y] crypto: caam/jr - Fix possible
 caam_jr crash 
Thread-Index: AQHaQ5JthCuUgI2erk6Ah682H5PDHw==
X-CallingTelephoneNumber: IPM.Note
X-VoiceMessageDuration: 1
X-FaxNumberOfPages: 0
Date: Wed, 10 Jan 2024 06:58:34 +0000
Message-ID:
 <AM0PR04MB6004DAE9B9A4226DADB97B5CE7692@AM0PR04MB6004.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6004:EE_|AM8PR04MB8020:EE_
x-ms-office365-filtering-correlation-id: 5d9fd5e0-860f-4fa2-85d1-08dc11a99088
x-ms-exchange-recallreportgenerated: true
x-ms-exchange-recallreportcfmgenerated: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ZFLZTYccnkltt+Cwez/RyDk1Fb5HDbO0RYqMHmGycPIlf/Z3aD9+7SHMFDRJdH7Lr3AeoaR3T7nvHZy/q7ft+AFuVBzYa+s3qPTsSf8z2oFYHtt/UtmofRKeCL+LS4G6OVWy0CrojQZb32GmQ9Bvcgs9/sPNb/XSzH0YbV03AbkD28N9i2sUUKsL9K7ufUfWGaNoN6gywrOTJv7wr4OfaHTU28xa3Qe46aynqMKa5TBYenoc0uiGf6nugR6IssfwDtrjsISVWxJdXGawN2qti/1X9OzfLWKhMLuLPPz2Yv3CtPh1JWZ8LnkF6sM5T4mt76OAKU1H2RqylgNrnSbI2ogLNDnbErfkcahOLTRo9IlPGoS3iCgh601sPTsEDH4znWAibXpdBkFaoXsqycpy54s/TDhrzaJgeHqL6moq3dIxkffupPVL5I/luEIpCnBfxREwW0HDZaHCERKSNpOdEe4ry0Vs24IYQ0XW82bLItLdwj+0GQHalYB7PN0WTzb5FtxM9XZgwibQOdTys5MEzEX0ZfRJlP8uLD+Ac9gt6j4//zNVCzjmIZNFBKzHIO8NATL74gGFCGZCS9zQh0XRWN2ApU3cf1ExqdL3352jv4LJ/9AIJcOwmXVq1fQjstgZ
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6004.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(376002)(136003)(39860400002)(396003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(83380400001)(6506007)(9686003)(5660300002)(55236004)(4743002)(26005)(122000001)(38100700002)(4326008)(52536014)(8936002)(8676002)(2906002)(7696005)(64756008)(54906003)(478600001)(71200400001)(6916009)(66446008)(66476007)(66556008)(66946007)(316002)(76116006)(41300700001)(38070700009)(558084003)(86362001)(33656002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?7/z2b6uNSR19aRrCu/7ItDQ01btAP+ViRZYyZZcPs4Aawgl21EiKEKKGPpPE?=
 =?us-ascii?Q?TmMTCHCq8svw89qaFVUHy6S1n9Gi93/DRqMtv8u8lS5z2p9mI0z3ltx5ZoLS?=
 =?us-ascii?Q?gEbm6JKQDB1Nu+pgKbnT0HeYf8yZ4R5MogjvBh8LJpLomAOhdzKDlVmIimOG?=
 =?us-ascii?Q?Ml7l8HXPVApEqRAQAnFFOPhshsnFkc90R9if22IhCg6KgAgi/UWxBKONrOq0?=
 =?us-ascii?Q?8qevVRAXcRgmlvPAVrWh4rgYujH3HpeguL2uxhj+ajLzVK8PmXdLYxYn6Dq7?=
 =?us-ascii?Q?9X1neRsQI4tMQOl26+DMn74f4TEblZb5cxikInVz9A9SIMFdeS2F+gfA56dI?=
 =?us-ascii?Q?7KpeZdFnvi8z+LLbG+1pGihPj0f8xy6EhvqNrRvsekl9bL2sFC/F+kLglgtx?=
 =?us-ascii?Q?fbVavDpQxgtvwTDsFUldnziqLeg9fPsszuPOU66cvCJdM70WeE6Rbw0Ctb1Q?=
 =?us-ascii?Q?mirmXYGWFozRyemlnDIMRLHzKIS/CQPbgm7/RfeR4yGGnzLGL+ewQSjw57tl?=
 =?us-ascii?Q?by3hvnlHZiZgZsin/GRk1Jwe5DKc6m9JhfRRx0seFZvntr1Qwr5ewfzMxPmk?=
 =?us-ascii?Q?a/sCu0efCGB7XemFZ8t+ygQGVHfpg9KPgpcw/oA59VJtSetfVsTpwc6E0/Fw?=
 =?us-ascii?Q?zjzBUG6KgNTzsLUwJj9vhZSb8o2YPI3S1bi/b8+k433C+Sz/hJFB9gCOHtYe?=
 =?us-ascii?Q?9eiezpoYx/+JanF7Mdzvv9ufgjsHkewg1oipuBllAXt5io8fnr/qZxeQFlFd?=
 =?us-ascii?Q?APYnWdXEZxNCKMk+VZfLqaxD9SgaQsLOVHo/RYexy8B3KjwHprfMd5vvUQAj?=
 =?us-ascii?Q?qNn/1AjECvMqZ5UR7JtfD7qBfMZWJYbkgnuZadAmUGeVHLkoeSYFR1nani/p?=
 =?us-ascii?Q?pkwnI1CJjOwvrG0GjDfRHPkA9xAvcctp0zkwAfso2VtxbRuPIHj7OXmOxqmh?=
 =?us-ascii?Q?E3QnFFq0CV0K6T/FzOSBVB0zuqYBUQRr7zos49mW7xVP7UV5GY+Gdkuikpkn?=
 =?us-ascii?Q?EocZVfaojxmsvYI9f52hi5t5moWR8LE5je1o33kFxMWUwMsDRTIj8nfhrVW2?=
 =?us-ascii?Q?spjjYoP1msBToIy2Oc25obxyPJFbqauAO6TLZzKLu7i5XpUMxT11T7d62wEU?=
 =?us-ascii?Q?9KHUEjn/7Xl9qMQz/KuCjDlBa6LAgxoF/dIu3nimNt3OdGoVCY361IVqiBZS?=
 =?us-ascii?Q?E8DkNsyCfgra1D9ljrrhfdfau3z1ONUtZ+k27N820BOt/8f6EOmT6NwNHgo5?=
 =?us-ascii?Q?K3h4l2gAQTu7ohy1tVQ5DQAySCzXZ8ZcMOxeCV3qb3fsxVKX66LMRnHKRM32?=
 =?us-ascii?Q?tm0BuLVztmkHi2s0O5HKu6QrP1su9ZyfeVcx3HM/wqzQbKqBVuwMlT9oU24H?=
 =?us-ascii?Q?3RPqKVVdyJF8KSt6y2VsXkalZo6AjC1sGVuDQytC9UrJHB7COMmIqwN95/cn?=
 =?us-ascii?Q?WjRXKZ+UbiiFSEpE0sENnXO5H/DoimvykF9t376CzeYt4T5wUBwf3VA6M0zk?=
 =?us-ascii?Q?COP9cHra4EM7LQ8+3cfSggPPLQFNvjOZ1cugRsPBEepOc4EGY6PhsLRAJk9h?=
 =?us-ascii?Q?aq1hFGhIy1Y2poJfMmmTGpzMFCF25ZXqn8am3y7f?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6004.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d9fd5e0-860f-4fa2-85d1-08dc11a99088
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2024 06:58:35.1503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XhNNqkxWsszmqTZu732hayj2T5oR6Rjc2IQGO+v3XBN2teUHFcymbbbaRiQCGW6vCYlxKSaGHg7zJsoJkyjkjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8020

Gaurav Jain (OSS) would like to recall the message, "[REMINDER] Re: [PATCH =
v5.10.y] crypto: caam/jr - Fix possible caam_jr crash ".=
