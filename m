Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6300CC7618F
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 14:56:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECBCD2080D
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 14:56:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="B9ViS5R5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfGRO4k (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 10:56:40 -0400
Received: from mail-eopbgr30086.outbound.protection.outlook.com ([40.107.3.86]:45702
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727848AbfGRO4k (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 10:56:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJGtT6w7Pv4vcnMpDaXDaCbYzkkUgS/2WpeTiiBixUR3X+qG+Co86fV1lyn53LkDGzR/2MKct0UKfry/wIP92uxg3FLMsUM+3kTCQJAAOLHwbCAkk0xmLh/ERu3/FmZwKYPa3jHw6gqYSP0FizSO4XKw/OzeTLVwFEm/BTtDQ/Sz/+USUtOAfNYDlL0yZfLr2CvkcrAFkHwqa6f1ZmRunN3FoEYWLtIt0mpFM6XYVwu8mrWcgDxfK0+gZ1U7qvsqrKskhjapyi/QjWafRDj+pAHCZhFKkC08uoY6d45u5MBWCXFnCorhRtrX6wTRD3WTEki78qoPRt+35aPC7N/TDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEqjQV0SAUvgavSZHKgVvzqDjrdKy+GSvVrHuK4T0dM=;
 b=aHv8+oJWOTKNk9lkYBYO0465kx1urUeNy73kOKKYHg51TMTLyB4a4kgJxMenQIyq+JOABMKkKCpZqiKQ0q9BGHkxwFYSaa7oYmyTUymRV2zcVfedtSYwXojGYkaN1F51/c/vAXV4Tv8Lk12cQTHgcOgy/kAMrkwY5RG25S763TyhBNvXkoRhHp2/sDNzuT3OU12Yw+vj5GRcOnLuj6++UdGilCLhflNhgxG+Co2qWMzXYSWTslcJu4YRRs9+9aZWwlMGGxIPiynCZWfxIliez7JUtDI24c+q2DD3sPNnhoYnbgEPNVjWkWGikVci3odRhppjAhzrmxii2CQPWzkPTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEqjQV0SAUvgavSZHKgVvzqDjrdKy+GSvVrHuK4T0dM=;
 b=B9ViS5R5IGhgbVHhhnWmaYFrzFqccVlDB/D8GcB8VEiMRsGmwQxOF7p49BdOPV6Xs3xUrM772V/u1z6v3RA2U/DnWO5Z4fi41y5Aruzlnwh+2y1k0ZwJfuwS9WNaxJXHlFZI6YA6h1Q+d7idCvCqGTHUCurbtyDkCuZBcDMTh7g=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB4829.eurprd04.prod.outlook.com (20.177.49.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.11; Thu, 18 Jul 2019 14:56:36 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::90da:d60:f39b:14ac]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::90da:d60:f39b:14ac%3]) with mapi id 15.20.2073.012; Thu, 18 Jul 2019
 14:56:36 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: gcm - restrict assoclen for rfc4543
Thread-Topic: [PATCH] crypto: gcm - restrict assoclen for rfc4543
Thread-Index: AQHVPXcr8KdyE5q0fE6fmVOxSMZYdw==
Date:   Thu, 18 Jul 2019 14:56:35 +0000
Message-ID: <VI1PR04MB44451D12B66EE3FADA1ECE208CC80@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1563460984-24593-1-git-send-email-iuliana.prodan@nxp.com>
 <20190718144647.bbsd65qabqpafehe@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54fa0fcd-6aa4-4771-0bcb-08d70b902170
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB4829;
x-ms-traffictypediagnostic: VI1PR04MB4829:
x-microsoft-antispam-prvs: <VI1PR04MB4829D2293DFC0344FA831FC38CC80@VI1PR04MB4829.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(189003)(199004)(53936002)(33656002)(86362001)(229853002)(6916009)(14454004)(81156014)(8936002)(6246003)(6506007)(6116002)(2906002)(53546011)(3846002)(9686003)(186003)(6436002)(26005)(55016002)(102836004)(7696005)(54906003)(91956017)(76116006)(66946007)(74316002)(316002)(7736002)(66476007)(66446008)(76176011)(64756008)(446003)(478600001)(305945005)(66556008)(8676002)(5660300002)(66066001)(476003)(44832011)(71190400001)(71200400001)(99286004)(4744005)(486006)(256004)(14444005)(25786009)(68736007)(52536014)(81166006)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4829;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 47bwe2qdgdhP0Tb33acVlR3vTCCtCtHeqp5iFyLV12rA/QnTiSDDD5zY9HDE6JlxPt1eXDXPEIirScgJrJ4r935oWakgOrGCI/hCsCppkMNqWsdLVJw5ns5JKz9VT7jwoVRVmkkyc7wFJLVZBpEfTov4uwcZRipoogIQU475NM3O0x9zix+6buK3yiTNbaB9V8a8exVfyLVcfGWHuhrhKDYfRQ2wLyf7xuf7+K1cSDa6Jrugqp5/pZfDXwH+L1JJacclOMaltEcM+o+cgPKOdFBf2ldY7kfmQe3L0tz2b11Wcn4TM35ATtkkgOgHTVn2aGFjUjjXnhJgqGN1oKH4kVebF/NkqI9QtXZXcQb1i1FxkQ+uBNo/UuHdBlX2ZQeNzJ128tVjvnC8+c8KhzYl+z1/V32PzhZwPZIT8e2Up1g=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54fa0fcd-6aa4-4771-0bcb-08d70b902170
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 14:56:35.9252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuliana.prodan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4829
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/18/2019 5:46 PM, Herbert Xu wrote:=0A=
> On Thu, Jul 18, 2019 at 05:43:04PM +0300, Iuliana Prodan wrote:=0A=
>> Based on seqiv, IPsec ESP and rfc4543/rfc4106 the assoclen can be 16 or=
=0A=
>> 20 bytes.=0A=
>>=0A=
>> >From esp4/esp6, assoclen is sizeof IP Header. This includes spi, seq_no=
=0A=
>> and extended seq_no, that is 8 or 12 bytes.=0A=
>> In seqiv, to asscolen is added the IV size (8 bytes).=0A=
>> Therefore, the assoclen, for rfc4543, should be restricted to 16 or 20=
=0A=
>> bytes, as for rfc4106.=0A=
>>=0A=
>> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> =0A=
> Why does this matter? Is it for the fuzz test?=0A=
> =0A=
> Cheers,=0A=
> =0A=
=0A=
Yes, this is for fuzz testing.=0A=
The generic implementation for rfc4543 considers any assoclen valid, =0A=
which is not correct.=0A=
=0A=
Regards,=0A=
Iulia=0A=
