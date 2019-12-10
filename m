Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8720CC43603
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 09:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5818720726
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 09:27:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="cPuGzMKG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfLJJ1m (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 04:27:42 -0500
Received: from mail-eopbgr10064.outbound.protection.outlook.com ([40.107.1.64]:30217
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726574AbfLJJ1m (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 04:27:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhG1tv/jGbVEY06rgXbFz5Mw9hGnlNHJvL27k9L7JbkPNoIkt65A/Rke4eGh3HJmo1cq8/gU/1iXgNDESXQ6j7X7iWSsIpMYOiD4azuJDMv1I9eDcmGesczUtS9ywvOpFzGD4j/wKdfwSxPcy3yWfFBGp0Jzf7C9gIZWj7JMq8sVum1Yt+L2or+YJ910bUXHyHoQotNqM3hX4btgaP/8STyGeMRHHh37ad3tS9lL6z8nHKVVkj9Y95BKzbqtunSMrrzuGCbqBWs7f/dGs03svxV/yKfpfwJH6tlTJzZ91wggxvU59rdy4EldGiUglyD7Szd2qOajNC5iR91OGX61fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6j8MCDT2xr4+/zoAj+Ms/v4LbIXbuAZDmLTTi6A6dY4=;
 b=FOyR8hSxwkq5Lg2h1griBQzGGKMXGHOT8KpV3pVX3GK/5HkqjdbcGO+Jz3tgQOm5JKAPNVw0JGAUqz/BQQRJdy+H1rn8at1chfUV6F4fKSnoO7qqFxUKvmVKpS0MSdM1p2iKYHqBI8MkDBIzaR8KaCTPPNFZnDH/34QmPIku5dNJLGz+HWZg9bEF1wRc1GSgQyNHt0eOdXNHl/a9DrjsPpjSlvdKMXq5GgdC0S21s36kP9oTO0O5dC89qHI8GZ72iITJN0FtcdCmBAnmLvrdrLoOBaiM0tqD7DQD+WVgjRCRSGDeC9ATtP9nmD/e2GXLswQSITctfRa39K7SrIGbzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6j8MCDT2xr4+/zoAj+Ms/v4LbIXbuAZDmLTTi6A6dY4=;
 b=cPuGzMKGLpe4wD+ZQvSacqwATKVuGYsXSBckj5gXKo8nMAMdoZmue37mJyl9GJVrwXqa9OD/ImK6B5zf6wYAskWM7Mqn4quKo2S7xJwS8l6I2aXshMdAFJkci0wkm/6PiAJN/05Yibjge5NQlc3h5tllMHSr8PvtmpSTOKgQqWY=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3502.eurprd04.prod.outlook.com (52.134.6.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Tue, 10 Dec 2019 09:27:39 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4%6]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 09:27:39 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrei Botila <andrei.botila@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] crypto: caam - remove double buffering for ahash
Thread-Topic: [PATCH 1/2] crypto: caam - remove double buffering for ahash
Thread-Index: AQHVrrIee3UpGuT8yEWtzvAic+JZ5Q==
Date:   Tue, 10 Dec 2019 09:27:39 +0000
Message-ID: <VI1PR0402MB348517448546120EC75D5188985B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1575910796-13897-1-git-send-email-andrei.botila@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 324d4264-500c-404f-34e2-08d77d533358
x-ms-traffictypediagnostic: VI1PR0402MB3502:|VI1PR0402MB3502:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3502A4BFC32AC6463C8B3BD4985B0@VI1PR0402MB3502.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(189003)(199004)(71190400001)(52536014)(55016002)(9686003)(66556008)(71200400001)(64756008)(33656002)(66446008)(305945005)(110136005)(54906003)(91956017)(86362001)(76116006)(66946007)(66476007)(229853002)(6636002)(8936002)(478600001)(316002)(5660300002)(53546011)(6506007)(44832011)(186003)(4326008)(4744005)(26005)(8676002)(2906002)(7696005)(81166006)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3502;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LX6JKw7TlQQwDw2YjmYvjcIm+RoO3cm/UNJCoIctWc6TDkROtJwuLkwDGANDaIZZZMV25vCXFR4JYOclYgh9BdI9aecd5dEeIuV+RmY1x1E/WGhG9V1JgMuXMCiMfRYquYWRBMUm2P+0SK4lCWIa2HT+x2Jty4ccNtHSBu6E9I0FQNc/VNBRGOR/ddCIHf+6FA9Brszg4A1FuPlfr3RCp0eK7lH6PgcE+5aH/3Eu3yye14hdEpyMkB1k0zEBZrCzowzhKVJoGiG0if97DqEuuxhE1mZ1Ns9X7Da74Fh7d2FlmdHLH18rYeppyisvHfCJWjZOiw7m9K6KdSQA6WHsjod+EeeN0Zs3AYnR6kLjAZ9i/zs8fWeGhX1IMeB0O6/FDfvDz5JUdSQxf+3IlaTOmVuDqQmcm37lyLfE5TL3SyaJLpsX7/3QkIiATzsEI4aL
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 324d4264-500c-404f-34e2-08d77d533358
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 09:27:39.2091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8PVkaR6iId+YIrCD/tSwxpzozq7PvW55u1yROQDjikSA6MghpjmfnnFy8ap06gNcLla4vBfC0sQgsGjh/TKR0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3502
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/9/2019 7:00 PM, Andrei Botila wrote:=0A=
> Previously double buffering was used for storing previous and next=0A=
> "less-than-block-size" bytes. Double buffering can be removed by moving=
=0A=
> the copy of next "less-than-block-size" bytes after current request is=0A=
> executed by HW.=0A=
> =0A=
> Signed-off-by: Andrei Botila <andrei.botila@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
