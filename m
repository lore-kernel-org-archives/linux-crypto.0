Return-Path: <SRS0=Wzqe=4C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F77C3B18F
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Feb 2020 01:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BBB02082F
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Feb 2020 01:25:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="PEIIUVvu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgBNBZz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 20:25:55 -0500
Received: from mail-eopbgr10072.outbound.protection.outlook.com ([40.107.1.72]:27692
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727609AbgBNBZz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 20:25:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7ohnKcLGkvXtBqzuEXpt0n4ypAi/5EURKwOVVQ4XekmtwnhwqfHYgc/hHnMT5uLWmSJfSzK1UcNJCq6H8YBfP2z7rszXytWlW6ORFk3+eslM0Inh4RTIjDFDq23rd/9X1r7wDl9E4wyoxqI2SlomiIXMFbrAzEcDpfSFpMudvJPKmZYD/6hZ5yGdgH1zSsC+2jpaV5PXENpU8OtwU+xMATxofC/UYzSrX2+bBJzSGG9SUPzV/obLrQf9NOJU89noyHFi+G07CyB4MHDgcpKKFs/rtNY1Y5Ji3OmrLgOW3uzoCObVkjpavTAWLul1LOAbh2MJSkSEMezELTIDRFRPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Do6bAcNBB2L5dUO7R7CyqmXVlvOwWvafMnMKBdUfzqE=;
 b=XWF96zyyfEyLinxEi1E6ZtRJxV2W6zpTnRaJfBQCEAfyrrpjmmSPj4YJW4R1ulSCRJIZS6NnZP5xRR1GTY3JVR1Q+HB5qsjySEQ4qAijIGQTUIV05nZDvdZGDqmYbWKReWos2fhPlqXvu06+rYatAtWzmBZR7aYaV9bBs7MQsjmVugRuKqtWJ7ljSNXaB0QELtHj++CGHExj0Dt13ac59tpkcqtSnEzARYgn79nXoxs0gcx6ngoqxmFZwGZh6vvWwtph9rwtBh6SYhPyOBnLmGQw/OD4gsuKvpbUEBWYSKDzckwjztkI3cFBULp86sCpGpweBUSCWvynCE1sJOk0nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Do6bAcNBB2L5dUO7R7CyqmXVlvOwWvafMnMKBdUfzqE=;
 b=PEIIUVvuhpmqVVqX8EjJMLiFQImRE4lbAPaNDxA6VBzeEmpHwYMqGYjscin9AkBKXmoD96h0xYaIba4AUZYgUOrzoB4frBSYdryllKw/sjSygnD0haMx0voH/3Zz1xuMCCnUcTUcR52XxcYmbFldlNH3fVzuGgvMWsiIqtSTRV0=
Received: from AM0PR04MB7171.eurprd04.prod.outlook.com (10.186.130.205) by
 AM0PR04MB5442.eurprd04.prod.outlook.com (20.178.116.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Fri, 14 Feb 2020 01:25:50 +0000
Received: from AM0PR04MB7171.eurprd04.prod.outlook.com
 ([fe80::b8df:72f3:9624:1256]) by AM0PR04MB7171.eurprd04.prod.outlook.com
 ([fe80::b8df:72f3:9624:1256%7]) with mapi id 15.20.2729.025; Fri, 14 Feb 2020
 01:25:50 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Baolin Wang <baolin.wang@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <mripard@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v3 1/2] crypto: engine - support for parallel requests
Thread-Topic: [PATCH v3 1/2] crypto: engine - support for parallel requests
Thread-Index: AQHV3bM2rqEL0DY5X0yRqygyPRgnNA==
Date:   Fri, 14 Feb 2020 01:25:50 +0000
Message-ID: <AM0PR04MB717171C785D20ECC74B415638C150@AM0PR04MB7171.eurprd04.prod.outlook.com>
References: <1581078974-14778-1-git-send-email-iuliana.prodan@nxp.com>
 <1581078974-14778-2-git-send-email-iuliana.prodan@nxp.com>
 <20200213061808.t6udjbgskc2hs7sa@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 66899f02-96b0-40a3-dfa5-08d7b0ecd397
x-ms-traffictypediagnostic: AM0PR04MB5442:|AM0PR04MB5442:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB544247830EF2F9361B6E51FB8C150@AM0PR04MB5442.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 03137AC81E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(199004)(189003)(8676002)(33656002)(55016002)(53546011)(91956017)(66476007)(64756008)(186003)(6506007)(66556008)(66446008)(26005)(66946007)(478600001)(9686003)(76116006)(316002)(54906003)(4326008)(6916009)(81156014)(8936002)(7696005)(71200400001)(52536014)(2906002)(81166006)(86362001)(44832011)(7416002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5442;H:AM0PR04MB7171.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: co/mcR018eqbji2O/EgyWi/ccFJ//mafoRvqi6tnrt6NXnohgGkajazHgeO4QZT7oK3vdiK5KQIzhlceWW+LZXP3BL5x8L4fP0fdH8C/zEvB22Tu6ZXfelVX7a4O2gsNkzlw9sSjS+vWLru7EntRj1NehlgpMtLTZBv995mf7bnp55hfLZeFrYFE3YkogvUphRyJtg8hYfyjS3JwzN68ybh2OaPSmFRXAeh0nONjEvMf/Zpif9hVhoVrBox9zT5jk/v0sC7ZZm+U7D7fMkAipGSnKHGAXRXYAzZA7aXRux8er984wW+nOp+lOj1W1yIcYqlFzukWdu8f1TC4+4AByvuSWop5I6Pk9P2P1gZqlrjBP83eheMyxubgty+niD0p8ZC1vFiQRta40hzKK+CrVQ0sBDfJYNcBoTuppNsin/tL6gKvPYJ36PozIrgvHU0C
x-ms-exchange-antispam-messagedata: IXCru1uEMDv8DckwZvZ0bAhG77KEDFhKwHV/xrnJaDlNIDJ6GwYBBvshemmNRevwhHwyJzjnh/ks8lvqNxzdy4XJUX+WlSmeqZEeRkEJTIlnRwv589E+maNDqyuBYFK+LFU1IRLyr+lrDghm5yJLyw==
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66899f02-96b0-40a3-dfa5-08d7b0ecd397
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2020 01:25:50.3984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GVox/P56UsA0gc6eIIm0i12WC4TRPU0kZu+bt+RTjPIkBPNA9kzvPLKMldSo7yvWroCi9AU3G54sp+shl+Z9Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5442
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/13/2020 8:18 AM, Herbert Xu wrote:=0A=
> On Fri, Feb 07, 2020 at 02:36:13PM +0200, Iuliana Prodan wrote:=0A=
>>=0A=
>> +start_request:=0A=
>> +	/* If hardware is busy, do not send any request */=0A=
>> +	if (engine->can_enqueue_more) {=0A=
>> +		if (!engine->can_enqueue_more(engine))=0A=
>> +			goto out;=0A=
> =0A=
> Instead of a driver callback I'd rather the driver called into=0A=
> the engine telling it to stop/start, similar to how net drivers=0A=
> work.=0A=
> =0A=
=0A=
Given your suggestion, I=92m thinking of implementing do_one_request, in =
=0A=
the driver, to return -IN_PROGRESS if the hw can enqueue more and -EBUSY =
=0A=
if otherwise (solution 1). But, this implies to update all the drivers =0A=
that use crypto-engine (something I wouldn=92t mind doing, but I don=92t =
=0A=
have the hw to test it).=0A=
=0A=
My current proposal keeps the backward compatibility of crypto-engine, =0A=
so no need to change the other drivers. If they want to use multiple =0A=
requests or batch requests, they can implement can_enqueue_more, =0A=
respective do_batch_requests (solution 2).=0A=
=0A=
Please, let me know how do you want me to proceed?  Solution 1 or =0A=
solution 2, or=85 maybe I=92ve missed something?=0A=
=0A=
Thanks,=0A=
Iulia=0A=
=0A=
=0A=
=0A=
