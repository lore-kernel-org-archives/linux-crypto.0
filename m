Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F28C4CEC4
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 11:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BC6121D7B
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 11:19:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="fzX/uU6y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389541AbfISLTZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 07:19:25 -0400
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:61254
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388922AbfISLTZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 07:19:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gz9NVHeoQSA5u6uNi6mhF27kIbLxMN90vkXsCZscYm3RebTmfdL+4QcbT34jr/2/phPvoD+AJNRgsEPnPIDGgo0YPrwVrzQ68jkqyLueZE9Q2x9yswAZ7No99LUvohnGfRo9+NWdQLIk/a8hq1I5+nAimK9jdimBXmIMsRXxescq13k896NOGMiYjenqaFk5SgbBEPW5eXilgM6JLaFRSiN7waHt7eDuDVQ4arXnjEYAd3K26o3NCQhyLZWCv7VO5Mi8jSKucSiXIA+F9hVC8669hf3sabiTDPoCoOL6wyUoYWfSChdsqXd9olg9sLU7Hc4fGXcU3C2PEl5cpQOePQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJG9rC6q1jEMRBVxmnUazzHiFj21KU6Ar+gL/kjV86I=;
 b=KPz06XdrWyC2IkBdHDPed8BCRQFCHgPfCagjCiyFmFpaY9Sacp/Ggv1KUMsj/ROeIe7jJCN+c58dK121sGQDY4Y1yWOYjh++n737P8zWEYHefFBVNspdnAmit5S3wWBgm9gH6yXBL8A8EpYWS/WmPJ/QQCQzMNZX/adm2ZTdlRyENo9FY6kum8BT/KID7XcS/R9tVg/w0f61hNnZFT7cPhnQsjG3bExxldSmDMg5LLQiRMAa4TirUU/N5YWoPNVXNa52nLDFBLqv7NjnO5seZ2JN0znEoEooNg6fR0Tl46oo5VexNxYBpMh5K4Go23kYoSBweUQIzl3PzeJTjUAvAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJG9rC6q1jEMRBVxmnUazzHiFj21KU6Ar+gL/kjV86I=;
 b=fzX/uU6yl+eFFdUWNQvmKRG2f+91VTO3yvYkyblOus5CprW3GMtBii+Vtpcmc//+B5o7ABf3gXQn/gIjhB9i0E+aOqfPL+LJqzxr/2CggWlLCoe4tVRuZENt/Ndecborpo0KzBXUtST6nnM0iXxXGftgp55t6x41gpQvfFGRVKI=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3871.eurprd04.prod.outlook.com (52.134.16.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.18; Thu, 19 Sep 2019 11:19:22 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::70b4:7829:2e8e:1196]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::70b4:7829:2e8e:1196%7]) with mapi id 15.20.2263.023; Thu, 19 Sep 2019
 11:19:22 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abel Vesa <abel.vesa@nxp.com>
Subject: Re: [PATCH 12/12] crypto: caam - change JR device ownership scheme
Thread-Topic: [PATCH 12/12] crypto: caam - change JR device ownership scheme
Thread-Index: AQHVYsl3Q5EXd/LaakqIGGHztQ1o4g==
Date:   Thu, 19 Sep 2019 11:19:22 +0000
Message-ID: <VI1PR0402MB3485F8B3E4F73EB62A70DBDF98890@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-13-andrew.smirnov@gmail.com>
 <VI1PR04MB7023A7EC91599A537CB6A487EEB30@VI1PR04MB7023.eurprd04.prod.outlook.com>
 <CAHQ1cqEkdUJGxUnRQbJSG9L32yC0HVmddzi4GyOkVfq2uvJOMQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9c1f23d-4360-47e0-2ffc-08d73cf338e1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3871;
x-ms-traffictypediagnostic: VI1PR0402MB3871:|VI1PR0402MB3871:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB38711AEAA03CF35663AA900398890@VI1PR0402MB3871.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(199004)(189003)(53546011)(52536014)(305945005)(6506007)(6246003)(26005)(186003)(102836004)(4744005)(66476007)(66446008)(71200400001)(446003)(7696005)(5660300002)(91956017)(76116006)(86362001)(14454004)(6116002)(99286004)(256004)(66556008)(64756008)(71190400001)(9686003)(6436002)(476003)(81166006)(54906003)(33656002)(110136005)(316002)(55016002)(25786009)(7736002)(74316002)(8936002)(66066001)(478600001)(8676002)(66946007)(76176011)(81156014)(2906002)(44832011)(486006)(229853002)(4326008)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3871;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9UvbIGEBe8LtQyFxwFhmf4ylrIH3XKEoaHbHO0OuuaAcbqMkNuyvFmeN/VIB70Ed/PsNBymJN6OM/qB/gqbyIiz7vg3hVPrcU6HC/Rf72/2YiuEtgpifO11/qL3KHiMHJNwyjZv+8dzqHgf2Y7gD522NY8d5h8nLprykVgjZtW43X45UGlkuxKvk3zo5hWboo/mr8bVQEr1Lpi3NLEmPUtabW0+RqLtdieyOd1k6aqUinUuYbf2bKQbbw4cKNL9WRrFTVZscnWeQSoCyxcxJ8IhiFcqCzfbdm0tIsjQDvp1bAd/Bc2FOUGHWfPtm6ETV+XbXcaRROX9JYxm5V8wgFEUx3HzD4fpzrDNayztXIYI9VrbG64yZ7RAuoRBuz15+sigp9whM9KAmUvKZZ/y6q9V2XeDGGken5mpupErW3EQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c1f23d-4360-47e0-2ffc-08d73cf338e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 11:19:22.4126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gu6T9DETEFeL7rgaohBFDfgUp0vaGZB2zjkc5y1rQZDhxWgHnb/Z6iIi2gtG4Q4getmkvGrwjDjtH4HOQLOs7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3871
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/18/2019 6:13 AM, Andrey Smirnov wrote:=0A=
>> I think you need to do some form of slow wait loop in jrpriv until=0A=
>> jrpriv->tfm_count reaches zero.=0A=
> Hmm, what do we do if it never does? Why do you think it would be=0A=
> better than cancelling all outstanding jobs and resetting the HW?=0A=
> =0A=
Herbert,=0A=
=0A=
What should a driver do when:=0A=
-user tries to unbind it AND=0A=
-there are tfms referencing algorithms registered by this driver=0A=
=0A=
1. If driver tries to unregister the algorithms during its .remove()=0A=
callback, then this BUG_ON is hit:=0A=
=0A=
int crypto_unregister_alg(struct crypto_alg *alg)=0A=
{=0A=
[...]=0A=
        BUG_ON(refcount_read(&alg->cra_refcnt) !=3D 1);=0A=
=0A=
2. If driver exits without unregistering the algorithms,=0A=
next time one of the tfms referencing those algorithms will be used=0A=
bad things will happen.=0A=
=0A=
3. There is no mechanism in crypto core for notifying users=0A=
to stop using a tfm.=0A=
=0A=
Thanks,=0A=
Horia=0A=
