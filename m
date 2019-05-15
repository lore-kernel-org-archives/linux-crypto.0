Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B14FC04E53
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 16:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FD2B20818
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 16:27:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Xlj5mc+1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfEOQ1z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 12:27:55 -0400
Received: from mail-eopbgr130087.outbound.protection.outlook.com ([40.107.13.87]:17560
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726283AbfEOQ1z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 12:27:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zeCezhQ20Z5djXH4tg1Wv37DCdZJ12HszYLL/qEGwg=;
 b=Xlj5mc+1zbq04O9n0yUDk9YdQl0GSTCMcsBfQRwvBuwtD6kuW/mdI5ySIMFKbY9kfoW8bNSjsWtvn+4Dz2K5wegGWs5YmT/ej8Cqq8fil3bhHn3CDZfBnL0Y8ThjPZQfJ3RjaC/eehoRryryu3loaarUGHQDV6UowzN1K/M3ygU=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3663.eurprd04.prod.outlook.com (52.134.14.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Wed, 15 May 2019 16:27:51 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::dd3c:969d:89b9:f422]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::dd3c:969d:89b9:f422%4]) with mapi id 15.20.1878.024; Wed, 15 May 2019
 16:27:51 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH] crypto: caam: print debugging hex dumps after unmapping
Thread-Topic: [PATCH] crypto: caam: print debugging hex dumps after unmapping
Thread-Index: AQHVCx/9F6U6+SkDhEGkmCdE7Szycw==
Date:   Wed, 15 May 2019 16:27:51 +0000
Message-ID: <VI1PR0402MB348501BDC254E48078D746AC98090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190515131324.22793-1-s.hauer@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c591acd-ea2d-4e2c-99fd-08d6d95246a6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3663;
x-ms-traffictypediagnostic: VI1PR0402MB3663:
x-microsoft-antispam-prvs: <VI1PR0402MB3663F1E96E27D28D4D82A0EC98090@VI1PR0402MB3663.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(39860400002)(396003)(376002)(366004)(189003)(199004)(53936002)(6436002)(2906002)(110136005)(14454004)(99286004)(316002)(2501003)(9686003)(229853002)(74316002)(4744005)(478600001)(86362001)(33656002)(5660300002)(6246003)(55016002)(8936002)(446003)(305945005)(81156014)(8676002)(81166006)(66066001)(73956011)(476003)(52536014)(66446008)(64756008)(66556008)(76116006)(7736002)(66476007)(68736007)(66946007)(186003)(486006)(76176011)(26005)(7696005)(71190400001)(71200400001)(6116002)(44832011)(3846002)(102836004)(256004)(14444005)(6506007)(4326008)(53546011)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3663;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fuwvySUCksyRKct788S5NYD/F7LJym6BGms/9WjdAjGQr5FAhDrY/AmJ3FYzHHANFOR/2Hp4AA1Q5jiIbS40vwFQjo87cXx10H+OcN0eygw4wLdpx5YNPY6XhNxIwefDGsfOH3T9jhjr3/DT0oV8+qD8IkE0/Fzm5nOh62CR7tb0mJVAowPmQNUyeczorylQxSX2oKOr6OvQqcrxd9ZBMgmt8zdMJN73+fdEp6grFa0BQToFWm02qLTf0WAKOqwFiim65LU0Tyqc98x+cPkU/jaqutIojDRhckW8RNr0dWNpu9YP4bpNkpLzCjxIwR9qAfV3t9srgvvBrlpVCG/OZN4r1w8j4ak7ZG5kdAQT0eJ1RYO4cON51qLo3K/w6i80xlLOOWvgtD4wipADsKdSLprCV9EXfLfvUDBWRHkbMM0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c591acd-ea2d-4e2c-99fd-08d6d95246a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 16:27:51.4412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3663
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/15/2019 4:13 PM, Sascha Hauer wrote:=0A=
> The debugging hex dumps in skcipher_encrypt_done() and=0A=
> skcipher_decrypt_done() are printed while the request is still DMA=0A=
> mapped. This results in bogus hex dumps with things like mixtures=0A=
> between plain text and cipher text. Unmap first before printing.=0A=
> =0A=
The description is not accurate.=0A=
req->iv is no longer DMA mapped since commit 115957bb3e59 ("crypto: caam - =
fix=0A=
IV DMA mapping and updating"), so this is not related to IV DMA unmapping v=
s.=0A=
print order.=0A=
=0A=
Currently:=0A=
-for encryption, printed req->iv contains the input IV; copy of output IV i=
nto=0A=
req->iv is done further below=0A=
-for decryption, printed req->iv should be correct, since output IV is copi=
ed=0A=
into req->iv in skcipher_decrypt(), before accelerator runs=0A=
=0A=
Could you please resubmit with updated message?=0A=
=0A=
Thanks,=0A=
Horia=0A=
