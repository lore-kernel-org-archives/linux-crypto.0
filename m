Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5E9FA3728
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EA6321928
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:59:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="QWmDgKMz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbfJPP76 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 11:59:58 -0400
Received: from mail-eopbgr140047.outbound.protection.outlook.com ([40.107.14.47]:19430
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727881AbfJPP76 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 11:59:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lp9fQj7irYirL04vh0yp4XhhYv7KRltXXVFvNynAIz+SfjZw8UKrL2XHqG8he6GSrWQS+V9DEbMn7RKa87Ct9vjqmZWD8v6d7uGtS2RPslto6Q8VfV5shEFWNV7rWTV6oBL+ZE/TaHYbpsspzIGoJ/6K+WC7vcf33PCWfSTeEus7dD/3BweLPJWchYTIJMaiJRQTJ9I6Uw92aawrps+sPM7Nln2tmBh313eIGD7otoeAwBnBOgwgJytyZdxEKgHmD9+k5E03rpNy933xKn4vwcPJOjN/9Nb0oIh6J6wfV+Hf74p7SU3i7Rnyilzl8njMWjRkSFg4d2z8XnKohBxZxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6Ahsux/oCqXs30SJCwnXjrqt2oCUgizyF4ltv4PT2c=;
 b=d7JD7o+uJtqHDf3Dre3weAUMG3B9wesYUimlrAB37CfV2CFuMxwq1jCoxrE+FnC9ad+s0/E4/6SJ8e19HXmnm5SlU3tuIXQKsBzDOxJ48gAxpp0LqAf8+gFR6IBr6TBKOvxQgywqsdJxw9KiOyIhXKKbcYppbpdTt5GI136hpcEl24CQwAXGHwGoqeWMCETFhPR3oHcVsEThfXhsStvksmIlqK9YOH7B/FQwpT3iHg5VTlTB55hFVcPqShhFHld4EGh4zJjNubFHfedniA1vaScMMEilfdoCRpZ418mTgYaI5//zsu04cKH69jrHCzxF7Bu3MslozMu3Ghr7RmPreg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6Ahsux/oCqXs30SJCwnXjrqt2oCUgizyF4ltv4PT2c=;
 b=QWmDgKMz2KHinrLgmSVIFRKbH9+A4Ro5ymIsSMuE20q9CM9Te0QCArGoiahATcmwP7XDHlVOPV5QyFOu7XxuzjccxjU9VIawWrplXZM3WRav14dXMPuYYo/LoEkElpmTdir3UFJ6gKlDR1fDoLRRDiLXBAcsUDN9wCMBPcX2m0w=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3453.eurprd04.prod.outlook.com (52.134.3.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Wed, 16 Oct 2019 15:59:54 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ec9b:b8ee:6fa4:7f9e]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ec9b:b8ee:6fa4:7f9e%6]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 15:59:54 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 16/25] crypto: mxs - switch to skcipher API
Thread-Topic: [PATCH 16/25] crypto: mxs - switch to skcipher API
Thread-Index: AQHVgomysWWO9xvSwkmhz+CnuRW5ww==
Date:   Wed, 16 Oct 2019 15:59:54 +0000
Message-ID: <VI1PR0402MB3485D17490694EAEC115371E98920@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
 <20191014121910.7264-17-ard.biesheuvel@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7fa95d06-a18d-454c-f2c8-08d75251e296
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR0402MB3453:|VI1PR0402MB3453:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3453E4BCFCEBA903B92C9CF198920@VI1PR0402MB3453.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(199004)(189003)(26005)(9686003)(110136005)(186003)(5660300002)(76176011)(25786009)(4744005)(66946007)(66476007)(66556008)(76116006)(64756008)(66446008)(91956017)(102836004)(53546011)(2501003)(71200400001)(71190400001)(99286004)(7696005)(229853002)(6436002)(81166006)(54906003)(6246003)(55016002)(3846002)(8936002)(81156014)(316002)(8676002)(2906002)(6506007)(6116002)(4326008)(305945005)(7416002)(52536014)(74316002)(33656002)(7736002)(486006)(476003)(14454004)(86362001)(446003)(478600001)(44832011)(66066001)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3453;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jeb6UQvug9WHpPvGzGEYHlDh7jLduCPMhNBZDnSDUyiK7vh+fhN44cYuOCoj3v+pH31b3/VwXc1P6/5fYqqp8nczrBhjTx4sQq50X/BawDwnVbXlk+VwkJd/EESyqLIVhhqQD3th5UOX4nc8jbFSuhG1dm+EZVu+I75plxZePZbBKg9Dtr7AAdtMezejVN58/gnYgB+OPwUcBVkOHikwsyObsLpjsGTfiuMdNn1gdqNbHLOSREtk9v5Aeu+zhmW0ECp+AHayBiCIYmOflWB9KcSubRCnZDShbBIdBdM9BB5EBKczlEkt89GIsZyd0oDidm454RA1dUP9DEpFF3JbO4+FXQ2bkbDCSVFGeRsdT+qVhKoTwe3HImzFxDoGwtan4wTb5bFpGHt55my2B6rblYyqvk4HUaB/U4klLst85K4=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fa95d06-a18d-454c-f2c8-08d75251e296
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 15:59:54.2647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NqkCFiIDEWdlL8VzUh6lLIm7nWTeTkUc/4a9zz+BozI83VSjwFCe7kA/JOmuFfZP4lZH3pX90WfknhRJHi6rmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3453
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/14/2019 3:19 PM, Ard Biesheuvel wrote:=0A=
> Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher interface=
")=0A=
> dated 20 august 2015 introduced the new skcipher API which is supposed to=
=0A=
> replace both blkcipher and ablkcipher. While all consumers of the API hav=
e=0A=
> been converted long ago, some producers of the ablkcipher remain, forcing=
=0A=
> us to keep the ablkcipher support routines alive, along with the matching=
=0A=
> code to expose [a]blkciphers via the skcipher API.=0A=
> =0A=
> So switch this driver to the skcipher API, allowing us to finally drop th=
e=0A=
> blkcipher code in the near future.=0A=
> =0A=
> Cc: Shawn Guo <shawnguo@kernel.org>=0A=
> Cc: Sascha Hauer <s.hauer@pengutronix.de>=0A=
> Cc: Pengutronix Kernel Team <kernel@pengutronix.de>=0A=
> Cc: Fabio Estevam <festevam@gmail.com>=0A=
> Cc: NXP Linux Team <linux-imx@nxp.com>=0A=
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>=0A=
Tested-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
