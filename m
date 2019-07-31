Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8BDC32751
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 08:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9A6F2067D
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 08:35:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="UtElmvjM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfGaIfR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 04:35:17 -0400
Received: from mail-eopbgr40047.outbound.protection.outlook.com ([40.107.4.47]:60265
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbfGaIfQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 04:35:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YkSk4rJJ9G3y5PDecZ3tfQNdR8kOD5g5Qv4HiXAlgtaHgTBOiZVoA/Y+44EOSBgGzCHcwst1POycSmk1Nh0hgv8qPoHVvxp1XrAAL7pMgcjuntRKHzL9fgJdZmSGNXxCuROQpklqek+sI5b9r/mAITe5uDRxKKOL+ykPmL1G+eAvWlTFjhoNxmuU8gbfgCDCbd8TjJJMdEVNKBpgAtAC1tZXkxJEBbCbpIS5bPB9eP6SZM3ifP3l7eoADG5SDmewfMycp1dAEUMOnETq9esg2vu39H9/J9RL8bkfrp7AlCjaj/QV57pXcLG43Ka8iDXefVDDuhgImnd9rnn69NnPgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDSFnPY+DtXDwB2NCW6YkPz00dJGxpv7SWdk4sABAxw=;
 b=QrdXxv4RZ9f2TMDoWNEjjeyqyitClHXcwC5dm40uAHiBYq3kJfs/uVNue3h5wAxpUL1TqE3XuxjLckWOFxSHvJ6WCbtYGPdyo6zqK5AMPX46Ss42bc34IL1krqnPUMqeQ8P6AJSFcCy1BxUN++y8pC6Ex+ICV9EPOnQ1z+m5P/nRdOx60PETNc+E2f22iKgnU9lO6sGI+eO1PFu+2sIaTVYz9EDwYcgeUowKtnjFjGZGfUge5nN7VHA//vs2CpOcLxvdTSjHTJD/ugyHy/g1CxJUf4a/RNNCVzDkfeYKJcAbk4/Ywjpbp9BPnR6FeMV5PI9l0lOUu7i34VUPdS+Ohw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDSFnPY+DtXDwB2NCW6YkPz00dJGxpv7SWdk4sABAxw=;
 b=UtElmvjMaw9bkr/dcSq+qfzRWldEsq1sIfA9Gzad3FpJ6Do/Z7Py67oCR+fVUDTE89U4hPn7mKLOiNleaViLpQDLffF9xRCqlnEB382e/bnsMCRSo1Vg1R58TB9nvEQi29E7lbzVVT+WQrUt8cFInHazKFCCW2Sd8oNThwfPS6M=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB7167.eurprd04.prod.outlook.com (10.186.158.71) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Wed, 31 Jul 2019 08:35:11 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::8d42:8283:ede8:9abf]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::8d42:8283:ede8:9abf%7]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 08:35:11 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 2/2] crypto: aes - helper function to validate key
 length for AES algorithms
Thread-Topic: [PATCH v2 2/2] crypto: aes - helper function to validate key
 length for AES algorithms
Thread-Index: AQHVRsJGGygGIA51lU+Z8jnkVf/oFg==
Date:   Wed, 31 Jul 2019 08:35:11 +0000
Message-ID: <VI1PR04MB4445AABC9062673BD4FA3CEF8CDF0@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1564482824-26581-1-git-send-email-iuliana.prodan@nxp.com>
 <1564482824-26581-3-git-send-email-iuliana.prodan@nxp.com>
 <CAKv+Gu_VEEZFPpJfv2JbB02vhmc_1_wpxNDBHf__pv-t7BvN0A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62d67aec-f89e-4f38-b9ae-08d715920066
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR04MB7167;
x-ms-traffictypediagnostic: VI1PR04MB7167:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR04MB716728C9EC8E8396571FEE9A8CDF0@VI1PR04MB7167.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(189003)(199004)(6916009)(64756008)(71190400001)(66556008)(71200400001)(76116006)(3846002)(26005)(66446008)(44832011)(76176011)(66476007)(6116002)(229853002)(7696005)(25786009)(6506007)(446003)(486006)(91956017)(53546011)(66946007)(2906002)(86362001)(102836004)(476003)(99286004)(316002)(33656002)(55016002)(54906003)(8676002)(5660300002)(6306002)(9686003)(7736002)(81156014)(478600001)(74316002)(14454004)(966005)(15650500001)(305945005)(66066001)(14444005)(186003)(6436002)(52536014)(4326008)(68736007)(6246003)(256004)(8936002)(53936002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB7167;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NayUkmzwUYIHJYt4YhrGhkMs38r9w9X2glI8E8fTkDSiILJhZn/wsAP1NW1yEhw0luQ37B6mctyzwXDgfAjyAnduZtgvEmIjrMOx4ZCDNDcTyJj0DWAiYUgtMvn2g9mFpKojfXf5tT4e4Kb+Bc/1OK8oLjzUo6FdbawV7tQIrn/wzV4+otf+BDhq1py3+qM/p/Z8tYD/hcjWgFUsEGIoiPTeYcBb5QGf4XVpPwxKw6reut18PucWTl4qoVNsuaVtt/tylskq/TCxR1+PKUg1wwKHH2AxLP+7RyJAJet6uwlDvitUNEvBN4JW6pF7n8gtjlwKLlT/YIkqh9Zeip08WtVnbbaPi+GMhrxWwLsZycu26yHV+H3TVrbaXPlk3EXIE+PPRkTcyTbwK7t37qsvugx1rBxSr9WZW2Qag44DCJo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62d67aec-f89e-4f38-b9ae-08d715920066
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 08:35:11.0546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuliana.prodan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7167
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/31/2019 8:33 AM, Ard Biesheuvel wrote:=0A=
> On Tue, 30 Jul 2019 at 13:33, Iuliana Prodan <iuliana.prodan@nxp.com> wro=
te:=0A=
>>=0A=
>> Add inline helper function to check key length for AES algorithms.=0A=
>> The key can be 128, 192 or 256 bits size.=0A=
>> This function is used in the generic aes implementation.=0A=
>>=0A=
>> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
>> ---=0A=
>>   include/crypto/aes.h | 17 +++++++++++++++++=0A=
>>   lib/crypto/aes.c     |  8 ++++----=0A=
>>   2 files changed, 21 insertions(+), 4 deletions(-)=0A=
>>=0A=
>> diff --git a/include/crypto/aes.h b/include/crypto/aes.h=0A=
>> index 8e0f4cf..8ee07a8 100644=0A=
>> --- a/include/crypto/aes.h=0A=
>> +++ b/include/crypto/aes.h=0A=
>> @@ -31,6 +31,23 @@ struct crypto_aes_ctx {=0A=
>>   extern const u32 crypto_ft_tab[4][256] ____cacheline_aligned;=0A=
>>   extern const u32 crypto_it_tab[4][256] ____cacheline_aligned;=0A=
>>=0A=
>> +/*=0A=
>> + * validate key length for AES algorithms=0A=
>> + */=0A=
>> +static inline int crypto_aes_check_keylen(unsigned int keylen)=0A=
> =0A=
> Please rename this to aes_check_keylen()=0A=
> =0A=
I just renamed it to crypto_, the first version was check_aes_keylen=0A=
- see https://patchwork.kernel.org/patch/11058869/.=0A=
I think is better to keep the helper functions with crypto_, as most of =0A=
these type of functions, in crypto, have this prefix.=0A=
=0A=
>> +{=0A=
>> +       switch (keylen) {=0A=
>> +       case AES_KEYSIZE_128:=0A=
>> +       case AES_KEYSIZE_192:=0A=
>> +       case AES_KEYSIZE_256:=0A=
>> +               break;=0A=
>> +       default:=0A=
>> +               return -EINVAL;=0A=
>> +       }=0A=
>> +=0A=
>> +       return 0;=0A=
>> +}=0A=
>> +=0A=
>>   int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,=0A=
>>                  unsigned int key_len);=0A=
>>=0A=
>> diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c=0A=
>> index 4e100af..3407b01 100644=0A=
>> --- a/lib/crypto/aes.c=0A=
>> +++ b/lib/crypto/aes.c=0A=
>> @@ -187,11 +187,11 @@ int aes_expandkey(struct crypto_aes_ctx *ctx, cons=
t u8 *in_key,=0A=
>>   {=0A=
>>          u32 kwords =3D key_len / sizeof(u32);=0A=
>>          u32 rc, i, j;=0A=
>> +       int err;=0A=
>>=0A=
>> -       if (key_len !=3D AES_KEYSIZE_128 &&=0A=
>> -           key_len !=3D AES_KEYSIZE_192 &&=0A=
>> -           key_len !=3D AES_KEYSIZE_256)=0A=
>> -               return -EINVAL;=0A=
>> +       err =3D crypto_aes_check_keylen(key_len);=0A=
>> +       if (err)=0A=
>> +               return err;=0A=
>>=0A=
>>          ctx->key_length =3D key_len;=0A=
>>=0A=
>> --=0A=
>> 2.1.0=0A=
>>=0A=
> =0A=
=0A=
