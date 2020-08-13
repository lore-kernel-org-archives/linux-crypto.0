Return-Path: <SRS0=zaW3=BX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0819C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 15:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96BD120771
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 15:56:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="nTXIYPkN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgHMP4y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Aug 2020 11:56:54 -0400
Received: from us-smtp-delivery-162.mimecast.com ([216.205.24.162]:33357 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726131AbgHMP4y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Aug 2020 11:56:54 -0400
X-Greylist: delayed 24920 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Aug 2020 11:56:52 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1597334212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fK7EDLUuNYJb9ieLIsbOjHI5OINnbC+fN5zVYUtpVHg=;
        b=nTXIYPkNqxMRLTyaRFotMErmSLSIw2NOgfY7BFB7YsgvnNRO6MznpVs+D69g+dvU3YsNmn
        dNHPTVGoy5NF3aU+SLo6ak9GbMpk5MABPs0nMf4E0tZB1VOTozzDCuOQqpz0CZPU5+6g/9
        YHfiZQok2NEgvK3lHQeB1NA2gxPWrvI=
Received: from NAM04-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam04lp2054.outbound.protection.outlook.com [104.47.45.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-mylKuz3WP0eYGHOLPZY3LQ-1; Thu, 13 Aug 2020 11:56:51 -0400
X-MC-Unique: mylKuz3WP0eYGHOLPZY3LQ-1
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7712::13) by TU4PR8401MB0653.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:770e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.20; Thu, 13 Aug
 2020 15:56:49 +0000
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::49d2:7bed:b12b:b354]) by TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::49d2:7bed:b12b:b354%8]) with mapi id 15.20.3283.015; Thu, 13 Aug 2020
 15:56:49 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     Stephan Mueller <smueller@chronox.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: Information required on how to provide reseed input to DRBG
Thread-Topic: Information required on how to provide reseed input to DRBG
Thread-Index: AdZxT90HuxgE8CzuQx++WGnAfz8h1AANP/iAAACUzxA=
Date:   Thu, 13 Aug 2020 15:56:49 +0000
Message-ID: <TU4PR8401MB12168D750EEF9AB43607FE8DF6430@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB1216EDF43D02A616A8022320F6430@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
 <24177500.6Emhk5qWAg@tauon.chronox.de>
In-Reply-To: <24177500.6Emhk5qWAg@tauon.chronox.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.105.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61c2e1e1-c9ae-46d5-506c-08d83fa17cea
x-ms-traffictypediagnostic: TU4PR8401MB0653:
x-microsoft-antispam-prvs: <TU4PR8401MB06530508CF24835754AE82D4F6430@TU4PR8401MB0653.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mMHdM1GVRYvuEoJwmaIOuk2p/ld3wEV5PBByaqJ/difn7E7p7tQcCpWT1i9UQLLe+iIceQVA2g7bf9qc+9/8TQiZ0scQqCaT446uxxYKzUPxU0FcpvErdNs7PxvzlmahTv0IWQz03Ppl1N8zJ9vsA2OjNYNFANCr7k+34YOkJmKZndUdp5HlnTt04d2b83Rnb/bmZwjapUBzvSjM64JVAu6ZcgzzlS9oaPcOhaupR42wUTGgBwbsavHAgjsRZxQldQpXaqpOR0MBvc7l2Oba0NMWQ24q0c+TXV2l7S3kDggcAy+TysT90HqrIE3ptnR+atSj/XaQ491111k98mp4LA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(376002)(396003)(346002)(8676002)(5660300002)(33656002)(55236004)(186003)(8936002)(26005)(52536014)(478600001)(2906002)(64756008)(66946007)(66476007)(71200400001)(66446008)(7696005)(76116006)(83380400001)(86362001)(66556008)(53546011)(6506007)(316002)(55016002)(110136005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 0rZi1Z9IntSi408WKmWktpJXj8xArKOIAbZKRIutqaH8AgQSYx08o0tXcGjbfqjKKmtp8pUbiran/9/M0O8s0BnOjlyzrfb98Y/AQgBMS75/6G+YsyLij+MZhQoWvd7sVC2Dr2TIwc+33S4u/P9mqo2Wyrc2F5HuZtAaUVCV9Bx5DBy5HWqYIuy6bA2+u7H4lRM3EqthxQBww8i2DIjHtyWK7BG5z00Pbxc8ljw3vpT9d7vnDVYR5XeICUIVWXyLUgHleh6j3Zmp5Sv4MzaQ6CxcUxpBuMN9jGXwkdv8zjaXu+cQ8r4r4j/VarE/DfaVahxU/6ptGpZ3DPQPNohqCnD+VL1mjw+Ahcg14MVjqnhDpjw/Ale51DPcfqVUU7mGt5D8aAjyHMSWXHc4vpDSTX8OC0U6KkbBfH8nBOdNiMN5x91tERnjStICq+2kFh+Me5yet4DlZBFYX/f0lb72BsnXWU7h8hEtxMoSbOCSLif1YFY/7Qyjiliqg23evlQr/q6bkWOE5BN1xdkM9rMZ+C5RBhlRH8W1OyU4rEECFyJvT/CDQ8aRPuyj5644yE7XXrJeNl1/lgGOUDB6qfpsSOoDAkTHd/oNIzTqV5RuqK1kmPJmBQitkuNRnBTkYCM9CCqla+k0NMNelcr7c+T5kQ==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 61c2e1e1-c9ae-46d5-506c-08d83fa17cea
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2020 15:56:49.0340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ianhWQUCZeTB9BxCDNcRsefZG0wVvYom5A7p4eAnqett469SYXc22NdixGiB0M0P/FMxI8NdrnqqVE0oBFIiYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB0653
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA62A171 smtp.mailfrom=jayalakshmi.bhat@hp.com
X-Mimecast-Spam-Score: 0.004
X-Mimecast-Originator: hp.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephen,

Thanks you very much on the response. I actually went through the code that=
 you mentioned. My question is on inputting reseed. Example input I have is=
 something like this

"entropyInput" : "F929692DF52BC06878F67A4DBC76471C03981B987FF09BF7E29C18AD6=
F7F8397",
"nonce" : "8DB5A7ECEC06078C1C41D2C80AB6CB5EDFE00EA7B1AA6F4F907E80C9BAA008CE=
",
"persoString" : "C99B39DD7B8FB0F772",
"otherInput" :=20
=09 {
=09=09"intendedUse" : "reSeed",
=09        =09"additionalInput" :  "32ED729CD8FCC001B6B2703F0DBE04D5EED127A=
615212FEC967566ABBFBC8913027D ",
=09=09"entropyInput" : "6FE46781AF69B38550A4D2C3888C8E515D28A2A4F141A041F3E=
2E9A753E46A30"
     =09 },=20
=09 {
=09=09"intendedUse" : "generate",
=09=09 "additionalInput" : "3C758EC9ECFD905E5865FD8343556815FBD8A064846252C=
BC161BFEAAC4FA9AF4D0DB8D8B9FD2E06B2C7A3FD55",
=09        =09"entropyInput" : ""
=09},=20
=09{
=09=09"intendedUse" : "generate",
=09=09"additionalInput" : "8F8F3F52D2CEF7FA788E984DA152ECA82CF0493E37985E38=
7B3CFCEC2639F610431CA0A81F740C4CD65230DD291733",
        =09=09"entropyInput" : ""
=09}

I understood=20
how to use " entropyInput", " nonce" and " persoString".=20
how to use " additionalInput" and " entropyInput" from generate section.=20
My question is how to I use " additionalInput" and " entropyInput" from reS=
eed section.=20

I could see only below APIs available to set the values.
crypto_drbg_get_bytes_addtl_test { crypto_rng_set_entropy, crypto_rng_gener=
ate)
crypto_drbg_reset_test {crypto_rng_set_entropy, crypto_rng_reset}
crypto_drbg_get_bytes_addtl { crypto_rng_generate)

I am not seeing any API to input reseed values or to trigger reseed? =20

Regards,
Jaya


-----Original Message-----
From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.or=
g> On Behalf Of Stephan Mueller
Sent: Thursday, August 13, 2020 8:48 PM
To: linux-crypto@vger.kernel.org; Bhat, Jayalakshmi Manjunath <jayalakshmi.=
bhat@hp.com>
Subject: Re: Information required on how to provide reseed input to DRBG

Am Donnerstag, 13. August 2020, 11:01:27 CEST schrieb Bhat, Jayalakshmi
Manjunath:

Hi Jayalakshmi,

> Hi All,
>=20
> I could successfully execute the CAVS test for DRBG with=20
> ""predResistanceEnabled" : true" reseedImplemented": false.
>=20
> I am trying to execute the tests with "predResistanceEnabled" : false;=20
> "reseedImplemented" : true. But not successful.
>=20
> Can anyone please let me know how to provide reseed data to DRBG?

See, for example, how drbg_nopr_sha256_tv_template is processed with
drbg_cavs_test()
>=20
> Regards.
> Jayalakshmi


Ciao
Stephan


