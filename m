Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A99C433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 13:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2D7F208E3
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 13:35:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="k/w82AxF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbfGaNfe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 09:35:34 -0400
Received: from mail-eopbgr00055.outbound.protection.outlook.com ([40.107.0.55]:16931
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726219AbfGaNfd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 09:35:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eX47rG0WgLo8GDGC4m97tTj0smBjEnUEYsXhEDqxLta6dFBy8sTtu3jocQf6cDOKIMTShYjKlhMGjETY7mtg6/LRnUKqiK8yEpeliMbWZcLj/HIFHPfbQwVOShi+EeXdAKqsfeBd0FPWSNAB3dxskViXSjj1iBIWY0J4uXAZiCBWJHF5K+gG5LJ0RqNzMyoGh+zAA4CA/wYhxKsriS+UE4rD6buxH30ie/cpUnAaQs58dyj49C4b9Lxwl+GK2dMKJimm737L62mSO6Y5vTuB6UVEeNshg1COqvOR6PSOxNWSAul7I29pltHI2W/g+yhMrT1hbQZJ6Uf+gTgwmoaOMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYBCiFoR4tOzFJKhdTO64d/9ZhXVoURedETAtik4p/s=;
 b=VvmzJ2hxX9JqB1GLFH/gY65Wp5tr9ySzKKh+//DLUdj+cUCIfr2H+8u6U1yvAL6a3BmNu3klGtvBoPk4KihNGfxiAjD0hgIJSxEFV6WDp5v7RgAihLyMVaqrvd6HCUQiK5nmE/f6gfzJUP6cI+zu4bDyYlwjhwXHp+VxGdtQIreKCSXoRhdPa/GxIvj+bEE4Yp6svMRRIQqPeF8v5QYvn3M+hgWHTMhf9eS426c7KE/wy9OY5PXwng24gxwMgVwK2+hGphuvWnHt0WUNDrUsx5QD7f2/sbFuOSgUk43zTrWpiDqiD5AQ5myM3jMUDyWps6hdkHoF3yNG8YZQP5R01g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYBCiFoR4tOzFJKhdTO64d/9ZhXVoURedETAtik4p/s=;
 b=k/w82AxFFgXcgkppxFSq6v+0N5Sxlkc3fwuS1oJJMZ7KjMYdoyCH6bsWE3GtTZQ4fIiSuEUub9IUurXpumv8oRKXGfmxUtLkhlvBQjh56+FjyWJBakqIOd+9FuLnrrGNctF/vtk/pLMyd48oYuluvKWZl1v1zelw4FTqWYDnRn0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2766.eurprd04.prod.outlook.com (10.172.255.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Wed, 31 Jul 2019 13:35:30 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Wed, 31 Jul 2019
 13:35:30 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v3 0/2] crypto: validate inputs for gcm and aes
Thread-Topic: [PATCH v3 0/2] crypto: validate inputs for gcm and aes
Thread-Index: AQHVR6TR78bS9d+svUKdGLQI7wpYQg==
Date:   Wed, 31 Jul 2019 13:35:30 +0000
Message-ID: <VI1PR0402MB348576458A879D8F162D01C098DF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1564578355-9639-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8c093ef-8629-4a8e-1a9c-08d715bbf4bf
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2766;
x-ms-traffictypediagnostic: VI1PR0402MB2766:
x-microsoft-antispam-prvs: <VI1PR0402MB276602047B23FC4D90F4116F98DF0@VI1PR0402MB2766.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(189003)(199004)(74316002)(66946007)(305945005)(66476007)(66446008)(64756008)(66556008)(53936002)(4744005)(81166006)(81156014)(256004)(14454004)(99286004)(8676002)(91956017)(76116006)(110136005)(229853002)(25786009)(66066001)(6246003)(52536014)(71190400001)(54906003)(5660300002)(478600001)(7736002)(2906002)(316002)(33656002)(6436002)(8936002)(86362001)(102836004)(4326008)(76176011)(53546011)(446003)(6506007)(71200400001)(68736007)(55016002)(186003)(9686003)(26005)(486006)(7696005)(44832011)(3846002)(476003)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2766;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ir2t7ERCnew1icxjoFUXWKPtSGI2M5/h2BL1ujv1PQAvvIu1YW4DS/+cPzKr/GP/rxcDLGuUkrXJp9xzN0LjKVbarJm7YwtmF9yf5E+nIAat0DNMZ6FvAs2/ohKju++e/v2khC70UOcf9iVU8ixBDETEWE8gjAeJYgBFfNpvkQX9p5MTWj3EMTVhuXkzDXodoOeZtuzgf8Puly54G2wb9IUpkPioGAMXetB7iB7iDHbDtmJqHKVQ9PnSQ1daJQJPHqcokp3HZew42mmfZcFEwLPeG18W//I3Mk9lEWk7FMZBbtMfzL4D1b9KWpUM5HjdVyPddA2fN+70pZVB4sqjkGvAhUt/+gpn4fpzjs94dZcANjnX6aZ4uRLG+VCFGviCtmbo796LgX+WGJG63kF28mHrYd3VqySIWOUr1Y6FEcA=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c093ef-8629-4a8e-1a9c-08d715bbf4bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 13:35:30.4127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2766
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/31/2019 4:06 PM, Iuliana Prodan wrote:=0A=
> Added inline helper functions to check authsize and assoclen for=0A=
> gcm, rfc4106 and rfc4543.  =0A=
> Added, also, inline helper function to check key length for AES algorithm=
s.=0A=
> These are used in the generic implementation of gcm/rfc4106/rfc4543=0A=
> and aes.=0A=
> =0A=
For the series:=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
