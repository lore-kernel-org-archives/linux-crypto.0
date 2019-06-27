Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89331C48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 14:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56E1B20828
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 14:44:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="ngV5Z3OK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfF0Oo6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 10:44:58 -0400
Received: from mail-eopbgr140040.outbound.protection.outlook.com ([40.107.14.40]:19076
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726425AbfF0Oo6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 10:44:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=aLkBMZ80MPgCxTBerSf7D9k9J/1C5ybTn+/wFibKLhvy7dnknl3J90D/M0HkrHCihEJihICXFii4fcoCVPC4PoYr9uLvMx/mEW0HWxe7GdVWWmzyAjXt/PNhJCIZlTiXb8C6DhMN0/uEJjcpe/EPmWsjF/jmIY/NzzMxVoCzRX4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a90xYsQ8ZXmPPh2yP63G7aLes1lWx/zmwpNsaQ8QEkY=;
 b=S8x/IxJLMzyaKDGkCWGl2RjHzVv0V+t4cyGjPOjhE35vfHu7MtyuHiIkqPi+zYjJO5C3yXc+5PKlrK4qaDIZpZac/jhplRjAH/3QcIWt9cRrIVK6BC9j6GMd2A2aZgG3dVSShxVf/0CWJB1sFBn/kV+PMngjZsOarKrXYQLrELY=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a90xYsQ8ZXmPPh2yP63G7aLes1lWx/zmwpNsaQ8QEkY=;
 b=ngV5Z3OKNPQ7DbSYuVUewz2ypNye0JJfIhu3eRPyMPROc1xWR6ax0T+mYufWWZmuL2VeIt7XeID2vJsGL0M/ywj9moLV0U2nhVZePyhhLdtfuzsj+AZyAdzO0MhXv1ZW1GiumsPSqAPsPB8t3WFB5dELLLipRLLG7FHIFRUsIDQ=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3520.eurprd04.prod.outlook.com (52.134.4.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 14:44:52 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba%6]) with mapi id 15.20.2008.014; Thu, 27 Jun 2019
 14:44:52 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
Subject: Re: [PATCH v2 00/30] crypto: DES/3DES cleanup
Thread-Topic: [PATCH v2 00/30] crypto: DES/3DES cleanup
Thread-Index: AQHVLOBU9WVYloJzzEKdnAEeqc/5QA==
Date:   Thu, 27 Jun 2019 14:44:52 +0000
Message-ID: <VI1PR0402MB348548C6873044033C94F63998FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43b7f4ea-cb63-468d-9939-08d6fb0e0375
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3520;
x-ms-traffictypediagnostic: VI1PR0402MB3520:
x-microsoft-antispam-prvs: <VI1PR0402MB3520DB87FE3F0B978F6F76CF98FD0@VI1PR0402MB3520.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(396003)(136003)(39860400002)(346002)(189003)(199004)(53546011)(110136005)(4744005)(66556008)(66476007)(6506007)(99286004)(6436002)(52536014)(102836004)(229853002)(2501003)(53936002)(6246003)(26005)(73956011)(4326008)(44832011)(86362001)(8936002)(5660300002)(14454004)(66946007)(76116006)(68736007)(64756008)(54906003)(66446008)(9686003)(76176011)(55016002)(66066001)(14444005)(8676002)(25786009)(256004)(33656002)(7736002)(476003)(446003)(81166006)(2906002)(81156014)(6116002)(71200400001)(3846002)(486006)(71190400001)(74316002)(7696005)(478600001)(186003)(316002)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3520;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SCFg+aBDJF0XxaYVnGHO93XuK+C0zp04sJcK2j9Yd5mO2iB/On4dl9HLd6XB2eTsrC/24fjuLTKH8XGJnTHttKsqBxVU0u8pDMu9SLrngw6G6SGMF2KS67oz0oFwhyxZrLAAh9ImJd5r/SG9HfNA1PYNU2p5r9+P9WuptoCgH6zuwIlyqImFdb67aSAY42UVt2b+tudvVkSSJYt7BbfRaI/GPDzoUKiHNYBglpRSKL/Lo5hzPRHK6yV3ujKJi/i4ZIQ8wPnA550m5BMB3s69+y5eAkrfFyyNZrgarY2gTzZ8IeF23es6OXktTw9YNHIjMUrcXsDbjxWXUIfIreZkCzLWTEbrmNe4Nyngr0Vh/unGvkhFuaqw9ICjUfzEmHB78GWqdDM2SsD6fONByJIIA0vNxCFptREHKLz1PyK9ZhU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43b7f4ea-cb63-468d-9939-08d6fb0e0375
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 14:44:52.4726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3520
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/27/2019 3:03 PM, Ard Biesheuvel wrote:=0A=
> n my effort to remove crypto_alloc_cipher() invocations from non-crypto=
=0A=
> code, i ran into a DES call in the CIFS driver. This is addressed in=0A=
> patch #30.=0A=
> =0A=
> The other patches are cleanups for the quirky DES interface, and lots=0A=
> of duplication of the weak key checks etc.=0A=
> =0A=
> Changes since v1/RFC:=0A=
> - fix build errors in various drivers that i failed to catch in my=0A=
>   initial testing=0A=
> - put all caam changes into the correct patch=0A=
> - fix weak key handling error flagged by the self tests, as reported=0A=
>   by Eric.=0A=
I am seeing a similar (?) issue:=0A=
alg: skcipher: ecb-des-caam setkey failed on test vector 4; expected_error=
=3D-22, actual_error=3D-126, flags=3D0x100101=0A=
=0A=
crypto_des_verify_key() in include/crypto/internal/des.h returns -ENOKEY,=
=0A=
while testmgr expects -EINVAL (setkey_error =3D -EINVAL in the test vector)=
.=0A=
=0A=
I assume crypto_des_verify_key() should return -EINVAL, not -ENOKEY.=0A=
=0A=
Horia=0A=
