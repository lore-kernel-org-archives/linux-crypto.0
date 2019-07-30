Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9396C76186
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 01:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E9A820651
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 01:26:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="XV8yQx1f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbfG3B0W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 21:26:22 -0400
Received: from mail-eopbgr790080.outbound.protection.outlook.com ([40.107.79.80]:41880
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728352AbfG3B0W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 21:26:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BnHZFHbRC6AyccUkUofWsWSJd8CjRk2CJbhaUaGhrdwYsTnlAOlF1Xdqr7Gj1wGtkUPPQ97fqPHgruSsVX2cv1sa6l+7+VRkPCfLNS/+iOWrpxzvg3b1xePn+alEt7ZGFMBghgH1/VUdJnqFsTrHLEBHAfC5ZdNxD0tx9X3onCgZzKefQX3rUgOxemSEjs2AP02z+FH+ylx4Vqaf1bNO82mU0hmMWj8z5poql4FCoJCzft5i/Nzy7cW4TC88e0cIoBjpxeJ0t3vw1QdkUToIoR13tGRzsv9I7jqdlEWWtI4JHNR+oyyBIN1/0Et5ZnbfdqF/JS+jAsEmGXitiPejJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vN4Ai1vgZ2l+M94bySFg4BDVgbvEEZ9zXtYaWHPALsA=;
 b=JFTMMl3d+8q1OEqX3YmzyFuqS8nb5d2c7hWUPgo2mCFmTHKbi2v5XYP83zio8uoOA8A8uK/hEkZowMPE1tAm4iwYcpqzWCP5m/M8WghY8sjm1KbOnzJILzoBbGa15oel0CRLGJBgHqTVevkqjpW4bt3SbUXzX6vlUspJB+icuredt2RRAY+/zFfDKeKNYyYThhcF6oPsI8ZafZKk0RryiYMBU/IRLo5Aj00PRqng7GdSNk9AE1fyoJrl0KtXd92BU8wXzi4E/mVG+Ie4rAtJHbY16OE6f4/XKTi3fcssO00kyyLsESzyl9lXIia14nhistzWuQmIeC3ZDcMXMNjCmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vN4Ai1vgZ2l+M94bySFg4BDVgbvEEZ9zXtYaWHPALsA=;
 b=XV8yQx1fvNZDWj0MXWUFiHZBPTgAHLKNccU5luFuIYynJ6b0/3AQA/b+Gvq3MARWfyeq/FGFjMk64F+CPhl7gILQiiR0TgOc9XSQpagZXz5a1T3Jur9W+rvV/6Ouq7Cr4972I24rooTiGNWFZ0AUtC1SqtNeF+2NWFgBr53kAbY=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2701.namprd20.prod.outlook.com (20.178.252.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Tue, 30 Jul 2019 01:26:17 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 01:26:17 +0000
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
Thread-Index: AQHVQgvgfaiGsuGw40GmRhVVq3++o6bgUEIAgAD6YHCAAKUVgIAAIDgwgAAmnwCAAAIuUIAAFLOAgAAK/ICAAAZ4gIAABRaQ
Date:   Tue, 30 Jul 2019 01:26:17 +0000
Message-ID: <MN2PR20MB297328E526D41CE90707DAFACADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1563960917-8236-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190728173040.GA699@sol.localdomain>
 <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729181738.GB169027@gmail.com>
 <MN2PR20MB2973C131062F1D1CABA77015CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729223112.GA7529@gondor.apana.org.au>
 <MN2PR20MB29736A0F55875B91587142D9CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729235304.GJ169027@gmail.com>
 <MN2PR20MB2973302B66749E5E6EC4F444CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190730005532.GL169027@gmail.com>
In-Reply-To: <20190730005532.GL169027@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8103654-afae-42a6-d0a3-08d7148ceb8b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2701;
x-ms-traffictypediagnostic: MN2PR20MB2701:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2701FF61BC8CB344D411B787CADC0@MN2PR20MB2701.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(376002)(346002)(39850400004)(189003)(199004)(99286004)(7696005)(6116002)(3846002)(71190400001)(71200400001)(11346002)(2906002)(76176011)(26005)(186003)(14454004)(102836004)(446003)(6506007)(486006)(256004)(15974865002)(14444005)(52536014)(478600001)(966005)(68736007)(476003)(305945005)(74316002)(86362001)(5660300002)(66066001)(7736002)(25786009)(9686003)(6436002)(6916009)(76116006)(6306002)(55016002)(66946007)(229853002)(4326008)(81156014)(81166006)(8936002)(33656002)(54906003)(316002)(66446008)(66476007)(66556008)(64756008)(6246003)(53936002)(8676002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2701;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qbP1o3USO1HcrAc6KfvaWuNXOyy6NzBKY3bQYXETZXgMVIHylhlYNZdSx4H/zSt2qbHVL/QFsf8CjAyoVKekomndlvv4roXeeta7TGzt2BVvEheiTQN9Q/OVDSOh42nzAIYxCk+pX5aQkLTWFbNkbnK7lATcYBTyeXzQP1P/68nrgCjYyHmItEIJuAa6w8W8TZXBIzQH0tHJKUtcJGisLEAxfp1k/uPH8YMvsr5NB+HSeOAa8tnhsKwpyv2G/m+KFhIAtH/334t4vXh5kQExPQ191cTQVM0IWq/ZM3I1IIL14IsvAZfl5awBGEOtZkaIs80Ue3et1tRlLToPKYTqz6ImKt+AxNtvvnGehJtiMQiL+4tqGP2Nq4iPIOzQSn7jr1hzxG+tLxj2cQLLNofCQFibp4T0/8I2nirHwbb79XQ=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8103654-afae-42a6-d0a3-08d7148ceb8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 01:26:17.5490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2701
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> > > Oh, I see.  Currently the fuzz tests assume that if encryption fails =
with an
> > > error (such as EINVAL), then decryption fails with that same error.
> > >
> > Ah ok, oops. It should really log the error that was returned by the
> > generic decryption instead. Which should just be a matter of annotating
> > it back to vec.crypt_error?
> >
>=20
> It doesn't do the generic decryption yet though, only the generic encrypt=
ion.
>=20
I didn't look at the code in enough detail to pick that up, I was expecting
it do do generic decryption and compare that to decryption with the algorit=
hm
being fuzzed. So what does it do then? Compare to the original input to the
encryption? Ok, I guess that would save a generic decryption pass but, as w=
e
see here, it would not be able to capture all the details of the API.

> > > Regardless of what we think the correct decryption error is, running =
the
> > > decryption test at all in this case is sort of broken, since the ciph=
ertext
> > > buffer was never initialized.
> > >
> > You could consider it broken or just some convenient way of getting
> > vectors that don't authenticate without needing to spend any effort ...
> >
>=20
> It's not okay for it to be potentially using uninitialized memory though,=
 even
> if just in the fuzz tests.
>=20
Well, in this particular case things should fail before you even hit the
actual processing, so memory contents should be irrelevant really.
(by that same reasoning you would not actually hit vectors that don't
authenticate, by the way, there was an error in my thinking there)

And even if the implementation would read the contents, would it really
hurt that it's actually unitialized? They should still not be able to
influence the outcome here, so is there any other way that could cause
real-life problems? (assuming it's a legal to access buffer)

> > > So for now we probably should just sidestep this
> > > issue by skipping the decryption test if encryption failed, like this=
:
> > >
> > > diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> > > index 96e5923889b9c1..0413bdad9f6974 100644
> > > --- a/crypto/testmgr.c
> > > +++ b/crypto/testmgr.c
> > > @@ -2330,10 +2330,12 @@ static int test_aead_vs_generic_impl(const ch=
ar *driver,
> > >  					req, tsgls);
> > >  		if (err)
> > >  			goto out;
> > > -		err =3D test_aead_vec_cfg(driver, DECRYPT, &vec, vec_name, cfg,
> > > -					req, tsgls);
> > > -		if (err)
> > > -			goto out;
> > > +		if (vec.crypt_error !=3D 0) {
> > > +			err =3D test_aead_vec_cfg(driver, DECRYPT, &vec, vec_name,
> > > +						cfg, req, tsgls);
> > > +			if (err)
> > > +				goto out;
> > > +		}
> > >  		cond_resched();
> > >  	}
> > >  	err =3D 0;
> > >
> > > I'm planning to (at some point) update the AEAD tests to intentionall=
y generate
> > > some inauthentic inputs, but that will take some more work.
> > >
> > > - Eric
> > >
> > I believe that's a rather essential part of verifying AEAD decryption(!=
)
> >
>=20
> Agreed, which is why I am planning to work on it :-).  Actually a while a=
go I
> started a patch for it, but there are some issues I haven't had time to a=
ddress
> quite yet:
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/commit=
/?h=3Dwip-
> crypto&id=3D687f4198ba09032c60143e0477b48f94c5714263
>=20
Ok

> - Eric

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
