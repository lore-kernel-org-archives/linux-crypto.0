Return-Path: <SRS0=95aS=23=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED66CC33C8C
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 15:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8D56207FD
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 15:00:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="pvVb0yS0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgAFPAR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jan 2020 10:00:17 -0500
Received: from mail-am6eur05on2061.outbound.protection.outlook.com ([40.107.22.61]:26849
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726296AbgAFPAR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jan 2020 10:00:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AVaR4RZPLdua0Ekp78bi/7guaBw7wIuUw04RgXMrtbFuF1NOkROxns9ZEnZcl9Z71jm+2QgNjZQ4krDabTKjVFa2SPM+HgggLI4EfV7alLu+1EoI54/6nEygS5Ow4wVC7YQt2esh68dhDLFvV+B84jZEK3I5UkIPY74ekbp1xuFjw9nzEZE5F9zV4huVDMH8eJGZL5qtIp6iPP8NLVBlGgEkWxXCsGZRA4k+mg+eTBIQECaAYqZkb86B23LtxKErlPoi7Q3eXdPBRDiXPT7h/DCaMjhI4Qv1JlngzgebZsHMdKLheYuwUAwPzktumVGZeHxjfFeCv9yF1aElPcNnaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RsZcm8gBKCqHt9iiM/iNy0OGvWgz7aWi3iy7NWvJSvU=;
 b=iIMpreU7/Uud0vfjEuBsmVfojo4Dg2DgkJ9J+7UjX0HWgmUMK8t80xIhG2JgUoorkYTXV8BQPWBKH14m2TvX9DTIlxFGNC/CIxfBYg5l1jS8oGraE6L1VmFnuftwODJoMBOGCzpVzjhv+Y1z3dNYSGFOJKx6WOS2L/vXUd+mFx7e8DWR142SFc6FXIGqs0p0m890YZhXWZ96s5iMFVkR8WCMk8VN8KqpQMfUIa0/RV54yhgBiRKqmlFT2aQlWiH0ZxL6JCFoUex755RXptVUcQkPS6qjfY0cLYOol689tdtdwbdeaAnqvznKBEBMYeWOf1jX9t3+nG6YiOwZLjgBfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RsZcm8gBKCqHt9iiM/iNy0OGvWgz7aWi3iy7NWvJSvU=;
 b=pvVb0yS0UE2iBU85pkHq6XIM5RpDpeSZhw5TdjxgZmP9jQToSNRiPVGZz5nRLLSiiZFB9XLrTFZI0VkIBLnvnqX6aEiLu5yyzQGY6tycmexYJDF118MnOaHN7tTnJ4TfUXmnjNx91fGwHqaYuu9iFPPu4g/wVHxMxVx2lfKN1Sw=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3424.eurprd04.prod.outlook.com (52.134.7.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Mon, 6 Jan 2020 15:00:13 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::85e9:f844:f8b0:27d%7]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 15:00:12 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 6/8] crypto: remove CRYPTO_TFM_RES_BAD_KEY_LEN
Thread-Topic: [PATCH 6/8] crypto: remove CRYPTO_TFM_RES_BAD_KEY_LEN
Thread-Index: AQHVv4qNwU5qG3JMY0aYyVWztfKm3A==
Date:   Mon, 6 Jan 2020 15:00:12 +0000
Message-ID: <VI1PR0402MB348509941C8A211DBEBE6111983C0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20191231031938.241705-1-ebiggers@kernel.org>
 <20191231031938.241705-7-ebiggers@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [84.117.251.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6ffbcf84-be04-4294-d735-08d792b921c0
x-ms-traffictypediagnostic: VI1PR0402MB3424:
x-microsoft-antispam-prvs: <VI1PR0402MB34244687DE78F05279B5817A983C0@VI1PR0402MB3424.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(199004)(189003)(316002)(110136005)(8936002)(66556008)(33656002)(64756008)(9686003)(186003)(66446008)(8676002)(66476007)(76116006)(71200400001)(66946007)(81156014)(81166006)(91956017)(44832011)(6506007)(86362001)(5660300002)(53546011)(7696005)(2906002)(52536014)(55016002)(478600001)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3424;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NKCXpb5klySjmUWQdIAP3G1vjYkHd6zcmJ9bXTKSn/vD7N3FHFOkqPGUSIfkc8CZ0Hvi0BfOMerRG5zw09DKSfT85h8vguh+le8RFtjNRUHxxTumhRC7lqQJ+xFkzU23zYRX4VCqMusFmooFEN9QQ6kvr7NPQHEJqBO7lhWh7jV11xbic1pS6iWGiKamrO87c1nuQaw2ES1f3X4v+LE73DDs36LZy9gbD9WUjg+quQtOrMZzUndRgyBc1tDMiXZ5VlPUvqr3bf7a4+SSb+DWtoS57gUhVipIZ+Y3hMyGObUaMA9ABZLb3T/fn075Q6BJTWq8VrETewSWpXAXxzXNTcYVz5wsqzpk4orvN/pHKVldObsGuEouBrV58OJ3qmdy3tzpDx15jbcg9FPp6NjP7lDR7HtotN5P0lQNi8NebgGulaFmum1XqWpsOksDDaLk
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ffbcf84-be04-4294-d735-08d792b921c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 15:00:12.8216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0wDGQRnr3zHOzREYuXPOjRR2SPdCMJCIOVuXZNLfNGhYwlaUca49EBPR550n5TzqmSCP4GgL82EmkHDtY5IvrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3424
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/31/2019 5:29 AM, Eric Biggers wrote:=0A=
> From: Eric Biggers <ebiggers@google.com>=0A=
> =0A=
> The CRYPTO_TFM_RES_BAD_KEY_LEN flag was apparently meant as a way to=0A=
> make the ->setkey() functions provide more information about errors.=0A=
> =0A=
> However, no one actually checks for this flag, which makes it pointless.=
=0A=
> =0A=
> Also, many algorithms fail to set this flag when given a bad length key.=
=0A=
> Reviewing just the generic implementations, this is the case for=0A=
> aes-fixed-time, cbcmac, echainiv, nhpoly1305, pcrypt, rfc3686, rfc4309,=
=0A=
> rfc7539, rfc7539esp, salsa20, seqiv, and xcbc.  But there are probably=0A=
> many more in arch/*/crypto/ and drivers/crypto/.=0A=
> =0A=
> Some algorithms can even set this flag when the key is the correct=0A=
> length.  For example, authenc and authencesn set it when the key payload=
=0A=
> is malformed in any way (not just a bad length), the atmel-sha and ccree=
=0A=
> drivers can set it if a memory allocation fails, and the chelsio driver=
=0A=
> sets it for bad auth tag lengths, not just bad key lengths.=0A=
> =0A=
> So even if someone actually wanted to start checking this flag (which=0A=
> seems unlikely, since it's been unused for a long time), there would be=
=0A=
> a lot of work needed to get it working correctly.  But it would probably=
=0A=
> be much better to go back to the drawing board and just define different=
=0A=
> return values, like -EINVAL if the key is invalid for the algorithm vs.=
=0A=
> -EKEYREJECTED if the key was rejected by a policy like "no weak keys".=0A=
> That would be much simpler, less error-prone, and easier to test.=0A=
> =0A=
> So just remove this flag.=0A=
> =0A=
> Signed-off-by: Eric Biggers <ebiggers@google.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
for caam and talitos drivers.=0A=
=0A=
Thanks,=0A=
Horia=0A=
