Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B8CC48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 15:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB4AC20656
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 15:42:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="H+2LL5+O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfF0Pma (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 11:42:30 -0400
Received: from mail-eopbgr60088.outbound.protection.outlook.com ([40.107.6.88]:64470
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726187AbfF0Pm3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 11:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZmMG+3mhDhJii0St/DwldzzK2dCRqUaLmMlVPzSIcD8=;
 b=H+2LL5+OTEpaqTpwi/ZlqoSmcqneKgB5Ln0PozHmWq4RNGUYE8SyflCmQkLp7hdaqBvhJrwJ8RPEFNoyC+roRPXJcBnhORyaRW6Zl6c88dCA3WGJyYGelZR/0nSgbWCoWyUdWAUCBa4lFDzSmV7nK5hj2/8zAd6VXM0yuggyGTc=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3661.eurprd04.prod.outlook.com (52.134.14.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 15:42:26 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::14c8:b254:33f0:fdba%6]) with mapi id 15.20.2008.014; Thu, 27 Jun 2019
 15:42:26 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
Subject: Re: [PATCH v2 00/30] crypto: DES/3DES cleanup
Thread-Topic: [PATCH v2 00/30] crypto: DES/3DES cleanup
Thread-Index: AQHVLOBU9WVYloJzzEKdnAEeqc/5QA==
Date:   Thu, 27 Jun 2019 15:42:26 +0000
Message-ID: <VI1PR0402MB34859B9771D3F0B8AC7458BF98FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
 <VI1PR0402MB348548C6873044033C94F63998FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu-JtxJ9KHRx6f6pAKKd17BojJqy-nrju64oKTT0tM2KrA@mail.gmail.com>
 <CAKv+Gu_v5e0q=txrTNKvpNi-qr=QF2P7DTHTZ2qXOZi_ot=EVQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19630c9f-2566-43db-a1ed-08d6fb160e34
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3661;
x-ms-traffictypediagnostic: VI1PR0402MB3661:
x-microsoft-antispam-prvs: <VI1PR0402MB3661F51EC0D165FB852D09D898FD0@VI1PR0402MB3661.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(136003)(346002)(376002)(199004)(189003)(66066001)(71190400001)(6246003)(478600001)(4326008)(6506007)(99286004)(71200400001)(7696005)(256004)(14444005)(53936002)(25786009)(6436002)(68736007)(53546011)(229853002)(76176011)(316002)(9686003)(33656002)(54906003)(55016002)(81166006)(81156014)(5660300002)(476003)(446003)(52536014)(44832011)(486006)(76116006)(186003)(66556008)(66446008)(3846002)(6116002)(73956011)(305945005)(7736002)(64756008)(74316002)(66476007)(6916009)(66946007)(2906002)(86362001)(14454004)(26005)(8936002)(8676002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3661;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Q1M7CjpE2yTG2iDjwkJhxGvOxqGAUlWuuxjZoKwHUs/zEBZmQdmWDSql8vJGJfVhn+mVGdO+C4/yvp+6/JYL1zWqrABulItuncg7sQjmYqTLpC6wW49xDT/HTr/mR6qcNhb3EAcrNGGSEw1RDzdzO6NjRVVL981/s/4+RpoeQYtiHf2aU3N7J+wa/rZXCUbwqkapqHAUl2eo9T41EXz2FVzIh8tPq2980ssX5qKuYZQW7XHqiKQOQVRQGk0y2/1BT9jAw0f4iiy8rDsa6akrtKWVHcxO6hnuJ94GsUlQEuSebU0gZcXO32nUT3+BF/vbJ5zY46s+wlNnw1xUIrs+NMO3I+cc0KS9rF3RJZt5uGE2d2D6kyBSyA4XdU4e8MjARB1hmo7MkRyLKImfDSX+rj5KHqC+z2i8W19v5QOMvAE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19630c9f-2566-43db-a1ed-08d6fb160e34
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 15:42:26.4717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3661
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/27/2019 5:54 PM, Ard Biesheuvel wrote:=0A=
> On Thu, 27 Jun 2019 at 16:50, Ard Biesheuvel <ard.biesheuvel@linaro.org> =
wrote:=0A=
>>=0A=
>> On Thu, 27 Jun 2019 at 16:44, Horia Geanta <horia.geanta@nxp.com> wrote:=
=0A=
>>>=0A=
>>> On 6/27/2019 3:03 PM, Ard Biesheuvel wrote:=0A=
>>>> n my effort to remove crypto_alloc_cipher() invocations from non-crypt=
o=0A=
>>>> code, i ran into a DES call in the CIFS driver. This is addressed in=
=0A=
>>>> patch #30.=0A=
>>>>=0A=
>>>> The other patches are cleanups for the quirky DES interface, and lots=
=0A=
>>>> of duplication of the weak key checks etc.=0A=
>>>>=0A=
>>>> Changes since vpub/scm/linux/kernel/git/arm64/linux.git/log/?h=3Dfor-n=
ext/fixes1/RFC:=0A=
>>>> - fix build errors in various drivers that i failed to catch in my=0A=
>>>>   initial testing=0A=
>>>> - put all caam changes into the correct patch=0A=
>>>> - fix weak key handling error flagged by the self tests, as reported=
=0A=
>>>>   by Eric.=0A=
>>> I am seeing a similar (?) issue:=0A=
>>> alg: skcipher: ecb-des-caam setkey failed on test vector 4; expected_er=
ror=3D-22, actual_error=3D-126, flags=3D0x100101=0A=
>>>=0A=
>>> crypto_des_verify_key() in include/crypto/internal/des.h returns -ENOKE=
Y,=0A=
>>> while testmgr expects -EINVAL (setkey_error =3D -EINVAL in the test vec=
tor).=0A=
>>>=0A=
>>> I assume crypto_des_verify_key() should return -EINVAL, not -ENOKEY.=0A=
>>>=0A=
>>=0A=
>> Yes, but I tried to keep handling of the crypto_tfm flags out of the=0A=
>> library interface.=0A=
>>=0A=
>> I will try to find a way to solve this cleanly.=0A=
> =0A=
> Actually, it should be as simple as=0A=
> =0A=
> diff --git a/include/crypto/internal/des.h b/include/crypto/internal/des.=
h=0A=
> index dfe5e8f92270..522c09c08002 100644=0A=
> --- a/include/crypto/internal/des.h=0A=
> +++ b/include/crypto/internal/des.h=0A=
> @@ -27,10 +27,12 @@ static inline int crypto_des_verify_key(struct=0A=
> crypto_tfm *tfm, const u8 *key)=0A=
>         int err;=0A=
> =0A=
>         err =3D des_expand_key(&tmp, key, DES_KEY_SIZE);=0A=
> -       if (err =3D=3D -ENOKEY &&=0A=
> -           !(crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS=
))=0A=
> -               err =3D 0;=0A=
> -=0A=
> +       if (err =3D=3D -ENOKEY) {=0A=
> +               if (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_FORBID_WEA=
K_KEYS)=0A=
> +                       err =3D -EINVAL;=0A=
> +               else=0A=
> +                       err =3D 0;=0A=
> +       }=0A=
>         if (err)=0A=
>                 crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);=0A=
> =0A=
Confirming this works for me (on CAAM accelerator).=0A=
=0A=
Thanks,=0A=
Horia=0A=
