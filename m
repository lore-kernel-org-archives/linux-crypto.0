Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DBBC04AB5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 07:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77CFF2083D
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 07:10:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="qOHNq0OJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFFHKK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 03:10:10 -0400
Received: from mail-eopbgr50076.outbound.protection.outlook.com ([40.107.5.76]:35297
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbfFFHKK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 03:10:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5A2Yp4IQbJFiax/+usUSdkY0IdyO9D6rI74ULukINbs=;
 b=qOHNq0OJF+2rPmIKUT37c/1TFCadbB1Ynxx9QjKLUkZuJY7wwnYCcxtf6TCse06n3l2Kj/P6gV/TR+Loa4emxcyhgI3oOVPjssBk7tGsUr8j+4vRv/MpjxU1BI91KYi9xbR8Yq49j2NruyJqda4ubeuOz2C1fm9RJ0UoutNbwuo=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3821.eurprd04.prod.outlook.com (52.134.16.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 07:10:06 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1943.023; Thu, 6 Jun 2019
 07:10:06 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Topic: [PATCH] crypto: gcm - fix cacheline sharing
Thread-Index: AQHVHDJUFTzexZfnZkK5jYnCMHmb4A==
Date:   Thu, 6 Jun 2019 07:10:06 +0000
Message-ID: <VI1PR0402MB3485A016A2E5FDEE57EBF48198170@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <VI1PR04MB444562A2352FE4BAD7F681258C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <CAKv+Gu-jTWQP0Zp=QpuzX41v8Eb5Bvd0O9ajwSnFkDO-ijBf_A@mail.gmail.com>
 <CAKv+Gu9JoC+GKJ6mMAE25mr_k2gbznh-83jApT4=FZsAW=jd8w@mail.gmail.com>
 <20190530142734.qlhgzeal22zxfhk5@gondor.apana.org.au>
 <CAKv+Gu8jJQCZwiHFORUJUzRaAizWzBQ95EAgYe36sFrcvzb6vg@mail.gmail.com>
 <CAKv+Gu-KBgiyNY2Dypx6vqtmpTXNfOxxWxJf50BTiF2rCOFqnw@mail.gmail.com>
 <20190606063724.n77z7gaf32tmyxng@gondor.apana.org.au>
 <CAKv+Gu-YtKRsUYMMD_PNoFvrPpmwTD7fJNs64Q-34L8-TvucqA@mail.gmail.com>
 <20190606064603.lvde6dproqi3vwcq@gondor.apana.org.au>
 <CAKv+Gu-DokZ179_Gx8_20v_pQ3w_CARKdO0xdsO8CRZJG1uOqA@mail.gmail.com>
 <20190606065757.4agqd4poer4rexri@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [78.96.98.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0f05391-8976-4a4e-246a-08d6ea4e00ff
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3821;
x-ms-traffictypediagnostic: VI1PR0402MB3821:
x-microsoft-antispam-prvs: <VI1PR0402MB38216E7292CD69CB4982095298170@VI1PR0402MB3821.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(346002)(366004)(396003)(376002)(189003)(199004)(25786009)(6436002)(81166006)(99286004)(4326008)(66476007)(2906002)(8676002)(81156014)(64756008)(66556008)(8936002)(66446008)(52536014)(54906003)(476003)(7696005)(5660300002)(446003)(256004)(73956011)(76116006)(91956017)(66946007)(71200400001)(14444005)(71190400001)(66066001)(7736002)(305945005)(86362001)(186003)(6246003)(26005)(33656002)(68736007)(53546011)(55016002)(6506007)(110136005)(9686003)(102836004)(486006)(3846002)(6116002)(76176011)(53936002)(74316002)(229853002)(478600001)(44832011)(316002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3821;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /uNQQeDFRAPWMU3ZRN6uylGKi/BfzRyFRy6Eo3PPeC9ryoX8LRkCDqMMGwahks4rW8uhI50+WIrzpzoLBMy7JEzpogKVB90UM0ao4jTaa3js+B3Zy/Bu8IuUr/thFxKEpkfJBq+gEuF7OKAX09i0LfHBGcpU7oJUwayQV+zDq5JIyKLtvI/z71gnj5V4qy6cFuDDtJcDni3fsIcVkDG8tuyC9HSKWCdTVWaHuPooYLFwtyY6Ot9o4E9xuXWv6j40KK7pGnvQMiLRudlGXRQsJN1/eOSXmw8/6wVlV7RESOKIkb0DynB0DwjHNBELSIWKqypgqir0sV8R7rooxG8U0+oFWBN+n8RWGrv3ai8Vx/t5ZWBlrhIvywIN/c072O+/IoP+wjWUVs4O+XSvzm6e2e1VoPF4O8FXyLmumrnPEhc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0f05391-8976-4a4e-246a-08d6ea4e00ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 07:10:06.2384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3821
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/6/2019 9:58 AM, Herbert Xu wrote:=0A=
> On Thu, Jun 06, 2019 at 08:53:10AM +0200, Ard Biesheuvel wrote:=0A=
>>=0A=
>> That same patch 'fixes' CBC, since CBC was never broken to begin with.=
=0A=
>> The CTS driver does not have something like the auth_tag sharing the=0A=
>> same cacheline with the IV, so CBC has always worked fine.=0A=
> =0A=
> CBC is broken.  Any crypto API user is allowed to place the IV=0A=
> in the same position relative to the src/dst buffer.  So the driver=0A=
> must deal with it.=0A=
> =0A=
That's the theory.=0A=
In practice we haven't encountered any issue so far, but yes this case has =
to be=0A=
handled properly.=0A=
=0A=
> It's just that the CTR/ghash combo happened to expose this first.=0A=
> =0A=
Yes, and that's what the patch is fixing.=0A=
=0A=
>> So I guess what you are after is a patch that, instead of dodging the=0A=
>> issue by limiting the copy to CBC, does not perform the copy at all=0A=
>> while anything is mapped for DMA? Then we can leave it up to the NXP=0A=
>> engineers to fix CTR mode.=0A=
> =0A=
> Right, we definitely need to fix it for CBC, probably in the way that=0A=
> you suggested.=0A=
> =0A=
Not really.=0A=
I am in favor of using the HW to update the IV, which would work for all=0A=
skcipher algorithms.=0A=
I have the fix ready, will send it in a couple of days.=0A=
=0A=
Thanks,=0A=
Horia=0A=
