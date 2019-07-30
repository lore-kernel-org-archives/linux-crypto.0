Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62584C76186
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 00:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C8B32070B
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 00:37:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="biWNqr2o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbfG3AhN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 20:37:13 -0400
Received: from mail-eopbgr740059.outbound.protection.outlook.com ([40.107.74.59]:26544
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727723AbfG3AhN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 20:37:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PiNSfb+u0fZ53FF09ljilSx8tyy8xj7bWLPdi+NTXdlicSaqfkhMWPojEKmobwEU4AMRQgk+x5kyte25CJxfTyDInspmyuYLcqWNXJZfqnGwEQuux510r4XeU7EnFViN4Ngf0GtJYC6MZF0/CvCNZ8zjNc9jUd0ca0cB903J3UlT3FFhbwZPD5IyUoKMirlAWGdVtNVLWBoEpPKZ/GWBTOTyAf9GBzPVNw5BJ0Wet6XsLouFvHkdgplW+xeNXRSObhFePJJttGybIvelFaVFebAic5i1oc2l2Uuq3DrXqZL6RPR9EC/AR6l3V5J2ETNJGbGcBarYrwjnbtIBMn4Pyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmKYwfLsFK6tLCDRI53FL0NKOnAZxyulX/WcD9Em8BI=;
 b=SXcso3VWckTiavYGrnEKAo0NP9R8EHiyk8atZCireJDDl9ndifly4WY6RtTSE2ala7+LYn6KrHvFkFNy0knSzbaPpQ1TUUvvmFGbc5dy4eQ7oNTblylcYMTAHz/Xhq9vqY5PdOd4mZfhWlAxSTNRCrr2dQmqmmoGYyTTCTkgGfUTyRkFeCfV/W9YnMp1ARyN4zG0dJ4/rc/sMVY48tm6dNGJ4RlsvZVAFgdsrmxUJ2ubomrzlI7BCc6gAHaz6P6awVqSJjALm43it/3Hu3Zxywm1XQT3znCiYPbWmTq9NiJF6Uw5ZUmiVqygkVcGtYUP2nYrfqCnVLSI5V/5PmGblw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmKYwfLsFK6tLCDRI53FL0NKOnAZxyulX/WcD9Em8BI=;
 b=biWNqr2oXNSvr98+uR1KvVHc0Chv/coRrctj0bVQLqr6tKeRdP3kBacWf9HCsgfjyifq3vYyrPJVDQHMXsooJ3CnGWd1v1P0BRQVP0yjdCemxbw1fQnv+LPBN3P1MoETddAWOKVJOOS5nrHQTRX48fkILwdcG3zUGvyiB7cZBTg=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2877.namprd20.prod.outlook.com (20.178.253.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 00:37:06 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 00:37:06 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Thread-Topic: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Thread-Index: AQHVQgvgfaiGsuGw40GmRhVVq3++o6bgUEIAgAD6YHCAAKUVgIAAIDgwgAAmnwCAAAIuUIAAFLOAgAAK/IA=
Date:   Tue, 30 Jul 2019 00:37:06 +0000
Message-ID: <MN2PR20MB2973302B66749E5E6EC4F444CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1563960917-8236-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190728173040.GA699@sol.localdomain>
 <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729181738.GB169027@gmail.com>
 <MN2PR20MB2973C131062F1D1CABA77015CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729223112.GA7529@gondor.apana.org.au>
 <MN2PR20MB29736A0F55875B91587142D9CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729235304.GJ169027@gmail.com>
In-Reply-To: <20190729235304.GJ169027@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d41bf4b-f2ce-4cc4-e97c-08d714860c7a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2877;
x-ms-traffictypediagnostic: MN2PR20MB2877:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB287742E392A96B42DD08237ECADC0@MN2PR20MB2877.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(39850400004)(396003)(346002)(136003)(199004)(189003)(99286004)(2906002)(33656002)(4326008)(476003)(74316002)(186003)(26005)(486006)(11346002)(305945005)(316002)(5660300002)(6246003)(478600001)(66066001)(6916009)(446003)(14454004)(15974865002)(6506007)(53936002)(76116006)(25786009)(3846002)(9686003)(6116002)(55016002)(54906003)(7696005)(102836004)(81166006)(8936002)(8676002)(66946007)(81156014)(76176011)(7736002)(6436002)(68736007)(229853002)(14444005)(86362001)(71200400001)(71190400001)(256004)(52536014)(66446008)(64756008)(66556008)(66476007)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2877;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: x8CYVQK+6iMgLvQLxjoq0gA5os9s2s7VPSgSvIpC4CkbQWvgE0Vke4KEs4/PzGtkd40c5hwUioIxc3pPS0catuszG1PrN5HlZWfElkyq2DuhDXj8Zp7X9FtNHBehuLxZYOea+PggUrZuSKf1dOszghbU+MYFsaFIw0AcspItAyGbP0zpBcCoj6CphyhOyqax+HoQl+1orMlJF7LnUqP4/ybrKSeQl+4cz3qpJEzWvQ+mX59QTJPbKwpwOli7b7R4adVGdwePeKQkGwjigOst4H/LdbtHUw7KfVHPnHXgcwPcPKfzSKGRLXdd/pRAmXt5X6GCIZQPJykOKD5mIvhl1c6rAkdKPVDutexx3VgUf1nHIKOterk+/GsdVxPdpi3uLRKwHWoYvIV+nkNRW/T47CktppwTJ7pxzSzYjotQfQU=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d41bf4b-f2ce-4cc4-e97c-08d714860c7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 00:37:06.2090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2877
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> > You're the expert, but shouldn't there be some priority to the checks
> > being performed? To me, it seems reasonable to do things like length
> > checks prior to even *starting* decryption and authentication.
> > Therefore, it makes more sense to get -EINVAL than -EBADMSG in this
> > case. IMHO you should only get -EBADMSG if the message was properly
> > formatted, but the tags eventually mismatched. From a security point
> > of view it can be very important to have a very clear distinction
> > between those 2 cases.
> >
>=20
> Oh, I see.  Currently the fuzz tests assume that if encryption fails with=
 an
> error (such as EINVAL), then decryption fails with that same error.
>=20
Ah ok, oops. It should really log the error that was returned by the
generic decryption instead. Which should just be a matter of annotating
it back to vec.crypt_error?

> Regardless of what we think the correct decryption error is, running the
> decryption test at all in this case is sort of broken, since the cipherte=
xt
> buffer was never initialized.
>
You could consider it broken or just some convenient way of getting
vectors that don't authenticate without needing to spend any effort ...

> So for now we probably should just sidestep this
> issue by skipping the decryption test if encryption failed, like this:
>=20
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 96e5923889b9c1..0413bdad9f6974 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -2330,10 +2330,12 @@ static int test_aead_vs_generic_impl(const char *=
driver,
>  					req, tsgls);
>  		if (err)
>  			goto out;
> -		err =3D test_aead_vec_cfg(driver, DECRYPT, &vec, vec_name, cfg,
> -					req, tsgls);
> -		if (err)
> -			goto out;
> +		if (vec.crypt_error !=3D 0) {
> +			err =3D test_aead_vec_cfg(driver, DECRYPT, &vec, vec_name,
> +						cfg, req, tsgls);
> +			if (err)
> +				goto out;
> +		}
>  		cond_resched();
>  	}
>  	err =3D 0;
>=20
> I'm planning to (at some point) update the AEAD tests to intentionally ge=
nerate
> some inauthentic inputs, but that will take some more work.
>=20
> - Eric
>
I believe that's a rather essential part of verifying AEAD decryption(!)


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

