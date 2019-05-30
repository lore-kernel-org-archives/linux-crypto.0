Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC36EC28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98FD7259CC
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:45:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="a4w65cG1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfE3Npw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 09:45:52 -0400
Received: from mail-eopbgr20089.outbound.protection.outlook.com ([40.107.2.89]:27968
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726851AbfE3Npv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 09:45:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNuPzzuKwevPJZO0nIXfqNwbwVit452pWgKVnnPz04c=;
 b=a4w65cG1JtTVNOGrwhcdpml1TQraoPKn0kPH4vUJZJ1JoZFDCLV6Pp9KzaKjHLIgD8z8X0HHatx0/e7n9jYXGnKZaXmBb2/WwvDRMCLSVdYjXcLpaqTYGIMtVSMlcXK0ousD9VEpu2AEApcC4oHqA5yeicBH0cODwi8Y1LF7dz4=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB6304.eurprd04.prod.outlook.com (20.179.28.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 30 May 2019 13:45:47 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::39fd:f3c3:46fc:f872]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::39fd:f3c3:46fc:f872%7]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 13:45:47 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Topic: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Index: AQHVFkF/PjPULMOhfkiEXDJZ6fiBzQ==
Date:   Thu, 30 May 2019 13:45:47 +0000
Message-ID: <VI1PR04MB444562A2352FE4BAD7F681258C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
 <20190529202728.GA35103@gmail.com>
 <CAKv+Gu-4KqcY=WhwY98JigTzeXaL5ggYEcu7+kNzNtpO2FLQXg@mail.gmail.com>
 <VI1PR04MB44459EEF7BCD3458BB3D143D8C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190530133427.qrwjzctac2x6nsby@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fdc518eb-467f-48d6-18bc-08d6e5051ecb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB6304;
x-ms-traffictypediagnostic: VI1PR04MB6304:
x-microsoft-antispam-prvs: <VI1PR04MB6304CFA91476FBC72E9929E08C180@VI1PR04MB6304.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(136003)(376002)(39860400002)(346002)(189003)(199004)(55016002)(66066001)(5660300002)(6116002)(3846002)(54906003)(256004)(66446008)(8676002)(81166006)(9686003)(86362001)(64756008)(81156014)(68736007)(2906002)(25786009)(74316002)(14454004)(76176011)(52536014)(316002)(8936002)(71190400001)(446003)(99286004)(6436002)(7696005)(478600001)(6506007)(102836004)(53546011)(305945005)(4326008)(186003)(26005)(73956011)(476003)(66946007)(486006)(53936002)(71200400001)(66556008)(66476007)(6916009)(7736002)(6246003)(44832011)(229853002)(4744005)(33656002)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6304;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aVa2+YfeH68Fjdmp3lt1TeFEjGJH8+w2aYa9VHrnwzb1Ci2xTZKvwxHyp6L8OWPtfWm8xx0EA4w4JU9QOukuPsF3q5BxWwicWkhfopSmObzPUKUDrmg6Rfr/ToL+GCbCjpHVWQu5Qwc5IiApxQ8aTgptR0gFxtOy8tK71IMnS3nmpe0P64QVmlf3OyUEqaHfHn77pYFDwLwfw0k9KUwoHT1AaLNjZzPH1RMtKAwlZAyfzLXgrpjnbdbcXwVcHKm7tV5JNqpXCK+W0LOR6qqkBbWkbXx/caDxm/jH+/81rhnAAFVBpUgBaml3CQA4E3a9N9ZcnE/M/z7D9/JCz7fcxiktOuvJjxplsbYO8qe5cXXWqG/HvMYjMLyDN3gkTyhOjIZorXN/6OEBSR9ekAOcbPoz8DdgnLNYq4lbfIg3CuY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdc518eb-467f-48d6-18bc-08d6e5051ecb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 13:45:47.2378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuliana.prodan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6304
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/30/2019 4:34 PM, Herbert Xu wrote:=0A=
> On Thu, May 30, 2019 at 01:29:41PM +0000, Iuliana Prodan wrote:=0A=
>>=0A=
>> I've tried coping the IV before the extended descriptor allocation, but=
=0A=
>> is not working and to make it work will need to make more changes in=0A=
>> CAAM. We need the original iv, and if we move it before=0A=
>> skcipher_edesc_alloc we lose it.=0A=
>> The fix exclusively in CAAM drv, to copy iv before DMA map, is more comp=
lex.=0A=
> =0A=
> Why doesn't it work (apart from the fact that this only makes sense=0A=
> for CBC and yet you're doing it for everything including CTR)?=0A=
> =0A=
> Cheers,=0A=
> =0A=
=0A=
On the current structure of caamalg, to work, iv needs to be copied =0A=
before memcpy(iv, req->iv, ivsize), from skcipher_edesc_alloc function. =0A=
For this we need edesc, but this cannot be allocated before knowing how =0A=
much memory we need. So, to make it work, we'll need to modify more in CAAM=
.=0A=
=0A=
Thanks,=0A=
Iulia=0A=
