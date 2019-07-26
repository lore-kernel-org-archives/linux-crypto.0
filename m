Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACA4C7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 19:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F419A218B8
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 19:17:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="JLlDysSk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388405AbfGZTRX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 15:17:23 -0400
Received: from mail-eopbgr80073.outbound.protection.outlook.com ([40.107.8.73]:10977
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387455AbfGZTRW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 15:17:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJF8AStgYTvljnfJK8VeYlosraMURkKSjA9U69bsqXnpj6uOTmyUb3w2Ki+nmXt1wdQ9lXgEnK3YEgb5I9UqGyocX2Qqhe4fmxVJqo7UFnkiX14hT1I89a6qhDmtbQb67T1clcyUahqGYIAFzjbbzBCsG/iR0jW5vWgxBh3/X0GieF4mOXEI3ecPueGnR1DVrZ28v7abnscyA6encGJaj2luGvFbpsfIr3DaGL3JLGQf91q05dmsm7OlrjxgtQgaG44pbKVHQf+QUCphyD5suIkMd8liywed1f29dXdWsRAAyFlt0vSKfkaOiy+rGwhQVVPCkqLsg99CreUrGfZJ5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iAnfMjLM5pnx8Oa0rP3Z0NZOiPpeBPR7cbcIXNi+Rek=;
 b=FLH5jIhLdfU9yJt58CPPhYHGjmLWm7gU/rYjkp6IbYTClaS2mbQgF+7P1iadu7eGRBcAH67A1ZFEAXLZYn+OhoclQaN0EjmuEyJh+B5wLqMP/t7MCjIWj3XP8/v/cZQddlanTjBK+a/rLJxtI5nKN7WJ9YuYezUaL/tyjduC3BEbXhD1w+3awhFXrep5Km3s4HAAfuOHlfwR9V6nKI9qhdXEhO/sD2JniQVpXu8vbRcO32oA9GbFZQSTDFpXiqY3PBXAFbu9vQl+yK29ijdItoAvxZYag97aliN/X8/vXsT6Bu3eCQgw3O6BGRu/umsyxvdxTyY43GxkH/SyT7s27g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iAnfMjLM5pnx8Oa0rP3Z0NZOiPpeBPR7cbcIXNi+Rek=;
 b=JLlDysSkzBOW7U4GdjlCf07a8kfw/lsd/ngd7fgNkR4oTXzWEtP4AZ7OqAHyiEwlesa0KluqPnUE9xDJIm7L0MrxHtzkpuBXTqH3YhGW8kEKHrY94Kah/GL6FqbPVoO7OFQLXtCKFOlzqS3gZ+5/yfgRIBG1LKBPPO6k2eQhAZ0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3342.eurprd04.prod.outlook.com (52.134.8.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Fri, 26 Jul 2019 19:17:19 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 19:17:19 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mhl@iki.fi" <mhl@iki.fi>
Subject: Re: gcm.c question regarding the rfc4106 cipher suite
Thread-Topic: gcm.c question regarding the rfc4106 cipher suite
Thread-Index: AdVDye9KM2tcbGm7SBqcTnCLF/Sp0Q==
Date:   Fri, 26 Jul 2019 19:17:19 +0000
Message-ID: <VI1PR0402MB3485F5C63904F1E87F5193E998C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <MN2PR20MB29732701865BDB3860142CD1CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [79.118.237.121]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d38a138d-a140-472e-da5a-08d711fde0dd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3342;
x-ms-traffictypediagnostic: VI1PR0402MB3342:
x-microsoft-antispam-prvs: <VI1PR0402MB3342F82170036431B3432F7B98C00@VI1PR0402MB3342.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(136003)(366004)(376002)(189003)(199004)(129404003)(486006)(52536014)(8676002)(91956017)(110136005)(26005)(33656002)(316002)(76176011)(5660300002)(54906003)(44832011)(8936002)(64756008)(446003)(71200400001)(66946007)(476003)(14444005)(7696005)(256004)(99286004)(76116006)(71190400001)(81166006)(66446008)(68736007)(229853002)(66556008)(305945005)(66476007)(81156014)(186003)(102836004)(9686003)(6246003)(6436002)(2501003)(6506007)(53546011)(53936002)(55016002)(25786009)(478600001)(6116002)(66066001)(3846002)(14454004)(74316002)(86362001)(7736002)(2906002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3342;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: b1uPrcnf4rGwgxEl5EJkTyEO69tzIgZA6T/HRm+YepzbClJ+0tQQa8hv0If/1M45kJ22VcmFY4lAlAoHpo8sAHeDK+j0kKh2PQnoo6+pWUHyVloJcLEYx8ZUS9AZ5vkg+MujISOa+JVcuDBESpFQ0TbQYAi+eT1SqqaeCeGeuDfWymqkINysL1ovPycFfHeLPUaOOpNhGCb3fYR4TlJ7kZaKXw/VC22rUq4Kj/VRTRCJXlbCw3tPxb7aO6QCPVcY4jq75eUfWpCJniq9/fDrxuZs5YQ31vhj/9sWUFu1Gjyak06IpOpdLnib4Nzy27LIDQxw3HY05QWFSylflqBefcny+sQWdIhEY3F/bvqpskkqqrtzqAp96b0UKa9JW6IYea0855i1i/fsmj7RHjTRCpaxsl9mWZiUi94lnYcx9Fs=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d38a138d-a140-472e-da5a-08d711fde0dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 19:17:19.2148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3342
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/26/2019 6:55 PM, Pascal Van Leeuwen wrote:=0A=
> Hi,=0A=
> =0A=
> I recently watched some patches fly by fixing issues in other drivers reg=
arding the checking=0A=
> of supposedly illegal AAD sizes - i.e. to match the generic implementatio=
n there.=0A=
> I followed that with some interest as I'm about to implement this for the=
 inside-secure=0A=
> driver.=0A=
> =0A=
> And something puzzles me. These patches, as well as the generic driver, s=
eem to expect=0A=
> AAD lengths of 16 and 20. But to the best of my knowledge, and according =
to the actual=0A=
> RFC, the AAD data for GCM for ESP is only 8 or 12 bytes, namely only SPI =
+ sequence nr.=0A=
> =0A=
> The IV is NOT part of the AAD according to the RFC. It's inserted in the =
encapsulated =0A=
> output but it's neither encrypted nor authenticated. (It doesn't need to =
be as it's =0A=
> already authenticated implicitly as its used to generate the ciphertext. =
Note that GMAC=0A=
> (rfc4543) *does* have to authenticate the IV for this reason. But GCM doe=
sn't ...)=0A=
> =0A=
> So is this a bug or just some weird alternative way of providing the IV t=
o the cipher?=0A=
> (beyond the usual req->iv)=0A=
> =0A=
Try to track the aead assoclen and cryptlen values starting from IPsec ESP=
=0A=
(say net/ipv4/esp4.c) level.=0A=
At this point IV length is part of cryptlen.=0A=
=0A=
When crypto API is called, for e.g. seqiv(rfc4106(gcm(aes))), IV length=0A=
accounting changes from cryptlen to assoclen.=0A=
=0A=
In crypto/seqiv.c, seqiv_aead_encrypt():=0A=
        aead_request_set_crypt(subreq, req->dst, req->dst,=0A=
                               req->cryptlen - ivsize, info);=0A=
        aead_request_set_ad(subreq, req->assoclen + ivsize);=0A=
thus the subrequest - rfc4106(gcm(aes)) - has to check for a 16 / 20-byte A=
AD.=0A=
=0A=
Hope this helps,=0A=
Horia=0A=
