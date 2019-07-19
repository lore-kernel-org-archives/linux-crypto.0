Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CCCC76188
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 07:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADE412173B
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 07:14:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="mlR6bTFJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfGSHOD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 03:14:03 -0400
Received: from mail-eopbgr50041.outbound.protection.outlook.com ([40.107.5.41]:38535
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725616AbfGSHOC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 03:14:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VSoGI3DyoCQkDwB+FVT17B8+Sh0lonTbIlVu4UE2m6pjSu5gdaKw6XXCdqS+2/WrVV2EjCaYmGDE+YpfcVYl0gaWSR796bMfYAov6HkazjJl+CnUu23ci31Iifpoy1PmZHwZ5Vi79u6QJs/84K4muso2MEI/QIDuqcQXR5kdzGy5SW7cpYkw0Vq60QbIBzZR9zfBq5RcwxkAFjKZxJagOvFEoI5PmpgqPsQHsyvUlPaG/glQ+baOLrc4WyA4bYUak3DqGHE3+dN7HIwcEkGi9LHt2843z+48tyaEwkhUOHlzpQG65JblNt6CeiBQnZXHRJudfTEhZVrXjLTJ+CqAOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btft8QuLD/BG+xg1YQZesFjlzcFLoaTJjsFVL04PBz4=;
 b=PIijzwmave3+7aAJKVpvVtYcPpKGGWKEdjIuag3KNi/cOBnjW/hQ7uZeLH/sqsTximfTX0RUCHbwMjeTiKFFBnm1Mq4JezH1VuoemsSEAV6hHbdIT0TfZ8O4Wagw1ZafuaIrsIXVjq4Qcvk522GVRGOfoCIgBxBZF6LPygDbN3vPqCHkgE44H9/iCiZx8DpsPv0W4f5Ly00a1ounsHIH4IoxCJHiqU4l+bCLzEVxtTjtO/akJaS4fysE+G1ka8CeGHsDPK0SS4SKhDkpnhVtnpV8odiJ3xfaP6M89SIlKDK99ITcVp1guHCjcCNyPxM6k3POkZ7kYodRkqq5xM4+4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btft8QuLD/BG+xg1YQZesFjlzcFLoaTJjsFVL04PBz4=;
 b=mlR6bTFJdKMJC6OIleflrY5djm6zq0C21FJYU4oY8tKm0MkMioLNvcuCCjWavs9k0FBnGOU/tJDzScdAJwgemJ1vdEJ8F/dfT+vycRkkO8krvYzITQF2zUD5w96BhQ80FKFqk5EgMNEj4jNX5eiOVVM5HDmOqJ3srV84msSOO7o=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB5696.eurprd04.prod.outlook.com (20.178.126.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.11; Fri, 19 Jul 2019 07:13:59 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::90da:d60:f39b:14ac]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::90da:d60:f39b:14ac%3]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 07:13:59 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: gcm - restrict assoclen for rfc4543
Thread-Topic: [PATCH] crypto: gcm - restrict assoclen for rfc4543
Thread-Index: AQHVPXcr8KdyE5q0fE6fmVOxSMZYdw==
Date:   Fri, 19 Jul 2019 07:13:58 +0000
Message-ID: <VI1PR04MB444593F54DFB2EDC0016F56E8CCB0@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1563460984-24593-1-git-send-email-iuliana.prodan@nxp.com>
 <20190718144647.bbsd65qabqpafehe@gondor.apana.org.au>
 <VI1PR04MB44451D12B66EE3FADA1ECE208CC80@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190718145907.wercecqwr3wlny73@gondor.apana.org.au>
 <20190718151101.hutxnd7u5nfrikx2@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0effd44a-614f-4820-9cb3-08d70c18ab74
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5696;
x-ms-traffictypediagnostic: VI1PR04MB5696:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR04MB5696F0D6CBC3178D64D66B168CCB0@VI1PR04MB5696.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(199004)(189003)(6506007)(4326008)(966005)(53546011)(44832011)(4744005)(316002)(486006)(8676002)(478600001)(71190400001)(71200400001)(91956017)(76116006)(55016002)(2906002)(9686003)(6306002)(66476007)(66946007)(476003)(446003)(6916009)(256004)(6436002)(86362001)(76176011)(14444005)(54906003)(7696005)(26005)(66066001)(6246003)(229853002)(66446008)(66556008)(64756008)(186003)(14454004)(74316002)(33656002)(81166006)(305945005)(8936002)(25786009)(81156014)(99286004)(52536014)(5660300002)(6116002)(53936002)(68736007)(3846002)(7736002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5696;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RLaeY+GLJrlVau4nb6dhrGHqGKur5f3tAghrWlRiBpkNpUvtJOirjAYdSlQCcH9ET+/xagfam/2ViAwt4Oj6wiB60feQrGRvZHvDeiB1MNcJEW6Zae1wasuFG/0fxv0WKgiaH9RNwc35Zf3WA4um20OfX/1oEgvSBjAnMuAbEm8OZ/SDYC/dhB2GfoS8Z9BNPbX7OcosmEvTjtWHXAbAb+70yklCp1y3t0oGdGh7v0A8ECWF6TqhCB4+WN0Le0HwPiOt/FTEIV9g8eQwc4/VxeJI1PojV5Z2GoBtIne/4lz9LZziBzEYyUNPr9Qofgtma7eTKqjZ5+hIfrHvCWlqvaPP4Yt40Waut2gsbrlhnsO9J7JaFG519yOY8dfQ3IFdhcilBeJBBIQqzHaoTAf8lbOq/ZNyCzaFUCnkmn1r07A=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0effd44a-614f-4820-9cb3-08d70c18ab74
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 07:13:59.0020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuliana.prodan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5696
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/18/2019 6:11 PM, Herbert Xu wrote:=0A=
> On Thu, Jul 18, 2019 at 10:59:07PM +0800, Herbert Xu wrote:=0A=
>>=0A=
>> So I presume the driver does enforce the limit.  Please actually=0A=
>> state that in the commit description for future reference.=0A=
> =0A=
> Also have you looked at whether other drivers would be affected=0A=
> by this? It wouldn't be so nice if this change makes other drivers=0A=
> fail the same test as a result.=0A=
=0A=
I've checked the other drivers and I found rfc4543 support in bcm and =0A=
ccree. I've sent fixes for these two, but I don't have hardware to test =0A=
on, so they are just compile tested.=0A=
=0A=
Link: https://patchwork.kernel.org/project/linux-crypto/list/?series=3D1477=
47=0A=
=0A=
Regards,=0A=
Iulia=0A=
=0A=
