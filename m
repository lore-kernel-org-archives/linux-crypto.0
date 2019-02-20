Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D4EC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 10:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17FFE2087B
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 10:40:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="oYMZezB+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfBTKkg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 05:40:36 -0500
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:46816
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726209AbfBTKkg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 05:40:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L55KjWKrBzDwe+KwpVpPXfhFMoPljnJyDBLoGSIHcp8=;
 b=oYMZezB+O0BhffxsQcDtua2XLyE1BCnHrKj/V1KfjgXC8M8RD3bPvvyjTL3VkmnsWUU2FORz00M3fcP6vSitQKEOTbMjQ4Hj1JvcXLW82+/rK47wEAN7emLKgE8ndR+pxVOo9LfJQpYDp1S68WapyELbMUxxgFIbN2C1Z8MmNs4=
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com (52.133.50.141) by
 AM0PR0402MB3427.eurprd04.prod.outlook.com (52.133.43.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.14; Wed, 20 Feb 2019 10:40:32 +0000
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::d17c:74b4:7765:9b85]) by AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::d17c:74b4:7765:9b85%3]) with mapi id 15.20.1643.014; Wed, 20 Feb 2019
 10:40:32 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Chengguang Xu <cgxu519@gmx.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypo: caam: remove redundant likely/unlikely annotation
Thread-Topic: [PATCH] crypo: caam: remove redundant likely/unlikely annotation
Thread-Index: AQHUyQM+113zqeHug0SPiStcU+kHsw==
Date:   Wed, 20 Feb 2019 10:40:31 +0000
Message-ID: <AM0PR0402MB34767A3F29F91CB5C6ECCC9C987D0@AM0PR0402MB3476.eurprd04.prod.outlook.com>
References: <20190220100032.32098-1-cgxu519@gmx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca351b3f-4f1d-47b7-f45b-08d6971fd6b3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR0402MB3427;
x-ms-traffictypediagnostic: AM0PR0402MB3427:
x-microsoft-exchange-diagnostics: =?iso-8859-2?Q?1;AM0PR0402MB3427;23:pQnFLpWG0jyTEALQli8fCdjJmlRQA9pr1kun9?=
 =?iso-8859-2?Q?lyqIHLYyxwJcT7XFumx/APMiuoa0dcEqfURPRaD6emQaHiBFworBf7VXoF?=
 =?iso-8859-2?Q?wJI/lU8GFAYG76h4JD1wHbqT7ka/GJ/gH7GWhulUK/UhTdW2ngMPKq2DPN?=
 =?iso-8859-2?Q?Q5CGBhIszzzyvC0ISBCRP3o7b23/n4pYHdCTb6qljsStN2A9AJhF6u0Ts/?=
 =?iso-8859-2?Q?4IU+8LBIe3YXqgPbksyuJhrlDUubjFIleezhoJZ5mHMzyeVTv1jBvCIbTr?=
 =?iso-8859-2?Q?0cAsaOdCWOXnLdQjPOoRleEq5HbG7IvpeFyuIpkSrnxXKfn/U+wl4wCTbx?=
 =?iso-8859-2?Q?du16m2LmfdxYdqRSiC9YispAW+eCKFlEG9URUzyaSstGiu2dkjKfu07NL5?=
 =?iso-8859-2?Q?f80sMeKSgUC0YVXxSsz5SvXyj/3nVGAD7we0ykxQJXo9k43Ke7gf9sTVi1?=
 =?iso-8859-2?Q?LNXWnXq+iI16dU6nZB4F/4qPLfvdMksVyTxnE8XgOBrAurJfISOHHNzFnB?=
 =?iso-8859-2?Q?R/PkMdrYJP3wx1EjUx/9e+uYAucNNJ6R7qICMgk3bIaBO5gPJGE0KAJUnN?=
 =?iso-8859-2?Q?Z602BG5/41YTulZA7ElfPyOvFfOAC9f1PQaGj5mzpciZzclAK37DHPR5xN?=
 =?iso-8859-2?Q?cjLrmZtQszoUqtF3/Tk5d8o7aY7/THiMTe9+13LqpzhdSrT6st+0wN6AxU?=
 =?iso-8859-2?Q?m0gF3JhJIHWm0V/dpYOuyI7E7p+eHy/VZqoIyKwjaIh9Y6PlarKGmn1L4X?=
 =?iso-8859-2?Q?VahJ4BSMAiWWGRJ+oLr2btCFRg6PMImxsz6xaIjFtNfsn+FxgfpfDOdeC7?=
 =?iso-8859-2?Q?Tln4NqdKMqVf8FJzJAQrmzSRv23WZ2i0QTFisaUf5fm7xiyun+w1+Q3AIC?=
 =?iso-8859-2?Q?04b6767Ccac9hJDur2cdlDfV/VoI+P6rVkXkdbDl8+deI6pQOb7mGWga60?=
 =?iso-8859-2?Q?1pUopMHmvcU6nRY3Rukfq83KHlttRPHTGBEUATcC8JOt4Wq6cqEhI7B5xo?=
 =?iso-8859-2?Q?g7o4R2pmiyt1naNxivPbEqH3q38KQV36levYT5Vqm+HkrBJqYsBnj280dj?=
 =?iso-8859-2?Q?3ZCfjhLq9lVkYuJDEvVAsbXuDgmP+g6Wxlh90MTkMLcl5TuxjgmbYEssoV?=
 =?iso-8859-2?Q?pmtcjSKLRty4562DxfPRYAaj3g9vT1jB/Od9kijmruZiYmFSmfF79dpl/I?=
 =?iso-8859-2?Q?HnywrR5vCroEgqea6cOvtvLjyiapY1Rnj7eLIe+g79lDSlafqxlrOyq5KH?=
 =?iso-8859-2?Q?I3RIrvfi2qP5v3YZuq2R+UyrzL8j/0Mu8X113H2FJ1fiH1I3BSuJw3Kwt7?=
 =?iso-8859-2?Q?pv9qMlEyP35ITIbA24/rT0F2QOUwb2aWFEQXJWQaLD7rkorxqiWdBG0Hk9?=
 =?iso-8859-2?Q?MWfnHqsBv6EPSt1YknoSWeBsUInBETr8ovXdCBmeABOtqiGDe02qQ=3D?=
 =?iso-8859-2?Q?=3D?=
x-microsoft-antispam-prvs: <AM0PR0402MB34273D6413BB9EBCE25F4C01987D0@AM0PR0402MB3427.eurprd04.prod.outlook.com>
x-forefront-prvs: 0954EE4910
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(39860400002)(366004)(396003)(376002)(346002)(136003)(189003)(199004)(81156014)(53546011)(8676002)(81166006)(99286004)(6246003)(4326008)(97736004)(68736007)(74316002)(76176011)(105586002)(8936002)(7736002)(6116002)(7696005)(25786009)(2501003)(106356001)(3846002)(2201001)(102836004)(86362001)(6506007)(256004)(305945005)(186003)(446003)(66066001)(33656002)(26005)(110136005)(2906002)(71190400001)(5660300002)(14454004)(71200400001)(478600001)(476003)(558084003)(6436002)(44832011)(229853002)(55016002)(53936002)(316002)(486006)(9686003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0402MB3427;H:AM0PR0402MB3476.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FRGJzDyI3rKZRA/jhv4QpXCITHGFZ42X5yQGcXyhuebTt1S1Kj2byHjCI8wvq8/i8h2cVFoy4D8WpjtWSfaQ/mc5nIbBeZ2x/YKTwJ+ePzjqMoqU6SZXLIvkr+JeyiGf9KjB7czfy7J0yo35D9emkxbhjy86JWm1VL9bfQViI+w4cJNh3mLB0Ek/0ykX1UvVj4ojWMffvXCuPS+YxzaQeVn+YEidtKrSxIK88/+ZZ3mwUhl56dvillqFvFcKS0o5u+BC8FfLBJRDksPDkqScB9GcJv/hsuZmuFYbFEVmI32fOkEBwQ8r8KYjtEhszWkRAQpcn/IDnSzmvnIfLovO0OwDmIQgsr8hpQu4jHID4X5mfsrSFrZ1JdB0+W60r9Tt5zGkZ5RNXa3O1Z4f5QAiKSYPuBcAz05y/ySMtMM/wM8=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca351b3f-4f1d-47b7-f45b-08d6971fd6b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2019 10:40:31.9780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3427
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/20/2019 12:01 PM, Chengguang Xu wrote:=0A=
> unlikely has already included in IS_ERR(), so just=0A=
> remove redundant likely/unlikely annotation.=0A=
> =0A=
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
but please fix the subject - typo, format:=0A=
s/crypo: caam:/crypto: caam -=0A=
=0A=
Thanks,=0A=
Horia=0A=
