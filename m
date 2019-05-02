Return-Path: <SRS0=RoNa=TC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3B8C43219
	for <linux-crypto@archiver.kernel.org>; Thu,  2 May 2019 13:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A257F2063F
	for <linux-crypto@archiver.kernel.org>; Thu,  2 May 2019 13:20:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="i9DeDAIz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfEBNT7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 May 2019 09:19:59 -0400
Received: from mail-eopbgr60071.outbound.protection.outlook.com ([40.107.6.71]:47886
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726197AbfEBNT7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 May 2019 09:19:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZRAmgmYKa1BVMeIJI5p9zcWXjkKWkN3651YHyZHEgM=;
 b=i9DeDAIzs5+rOcG+sN/VhKzZLrmIHKUNGwrjIyp46eZaE8xjb1hy+28s+B6ERUl8y1ix5ggHhVXKzebv4RWjNCRnuKlMYcQQxghma0mpFCCv2oaqj4rSf/P/NM6HsM8WY8P3rOZWyWYJLjU0d7miz6ods/dxHbWksa73vGp31v4=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3677.eurprd04.prod.outlook.com (52.134.15.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Thu, 2 May 2019 13:19:16 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be%5]) with mapi id 15.20.1835.018; Thu, 2 May 2019
 13:19:16 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/7] crypto: fuzz algorithms against their generic
 implementation
Thread-Topic: [PATCH v2 0/7] crypto: fuzz algorithms against their generic
 implementation
Thread-Index: AQHU/E4B9cUiZnJ1EEuei1pU1G4SaA==
Date:   Thu, 2 May 2019 13:19:16 +0000
Message-ID: <VI1PR0402MB3485B519CE1932874ACABEB298340@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190412045742.1725-1-ebiggers@kernel.org>
 <VI1PR0402MB3485A6BE1840DD5B060FACB7983E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190426165406.GA691@sol.localdomain>
 <VI1PR0402MB34857CA032C0134714BE9A61983F0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190427170254.GA652@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e0ef8e8-9138-4d7f-e900-08d6cf00c6d7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3677;
x-ms-traffictypediagnostic: VI1PR0402MB3677:
x-microsoft-antispam-prvs: <VI1PR0402MB3677D6EC64EE2F27E3612B9B98340@VI1PR0402MB3677.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0025434D2D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(376002)(346002)(39860400002)(54094003)(199004)(189003)(476003)(486006)(68736007)(102836004)(229853002)(6506007)(53546011)(446003)(25786009)(186003)(52536014)(7736002)(478600001)(6116002)(3846002)(305945005)(66446008)(14444005)(256004)(73956011)(66946007)(66476007)(66556008)(64756008)(26005)(76176011)(2906002)(7696005)(99286004)(44832011)(55016002)(4326008)(76116006)(66066001)(74316002)(6916009)(54906003)(14454004)(316002)(81156014)(81166006)(33656002)(53936002)(8676002)(71200400001)(71190400001)(6246003)(6436002)(86362001)(9686003)(5660300002)(8936002)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3677;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3AamkvfIyCORWK2u1My8tGBi6UBR82MzXf8V60rGY+7BVoY7+CQ+TkTk4xN1NQm0FyUbpvY56bit3VGvqboVAnJ1riPzuflH3QMHFAeYpA1JqXZyqBgjRcl1UkV4o1Ijgyp43vwTBO4XmybURda9zAi/Z3ruNk7j+D9G8RXTJeWU5/RUzwnilAjiKEdrHzXu8F6AWiA1DvVbp4BY+CgWEdgb91U0G85H6is7juO7A+o+sfu035dYtPkIyaT8uE3uly+K8na84jDvVeoOTbx3MUPwaf3YM2Kusg2OcCRUBo4mbfqyLXF1xVtyRfAOEv6ED8Bx4jAN46hsJUzOI+Oc2eyXqWuhYy8FiUXybfxS+XxffdETMLwz2eA5Fzoe1DuKEQeTOLNKczMk8AOlFYyxBSlzGWtqCByggDPQN+HhOdQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e0ef8e8-9138-4d7f-e900-08d6cf00c6d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2019 13:19:16.1441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3677
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/27/2019 8:03 PM, Eric Biggers wrote:=0A=
> On Sat, Apr 27, 2019 at 03:24:38PM +0000, Horia Geanta wrote:=0A=
>> On 4/26/2019 7:54 PM, Eric Biggers wrote:=0A=
>>> Hi Horia,=0A=
>>>=0A=
>>> On Fri, Apr 26, 2019 at 04:35:05PM +0000, Horia Geanta wrote:=0A=
>>>> On 4/12/2019 8:00 AM, Eric Biggers wrote:=0A=
>>>>> So far I've tested all generic, x86, arm, and arm64 algorithms, plus=
=0A=
>>>>> some PowerPC algorithms.  I have not tested hardware drivers.  I=0A=
>>>>> encourage people to run the tests on drivers and other architectures,=
 as=0A=
>>>>> they will find more bugs.=0A=
>>>>>=0A=
>>>> I am seeing some errors in caam hardware driver.=0A=
>>>> They are due to error code mismatch b/w generic algorithm implementati=
on and=0A=
>>>> what caam driver returns.=0A=
>>>>=0A=
>>>> Random skcipher tests for block cipher algorithms are expected to fail=
 when=0A=
>>>> input size is not a multiple of algorithm block size.=0A=
>>>> Generic implementation returns -EINVAL.=0A=
>>>> caam driver returns the status received from HW.=0A=
>>>>=0A=
>>>> This probably has to be fixed in caam driver, but I wonder if there's =
an=0A=
>>>> agreement on what error code should be returned in every single case (=
since I'll=0A=
>>>> have to do a N:M mapping b/w errors returned by HW and errors expected=
 by crypto=0A=
>>>> API).=0A=
>>>> Should I take the generic S/W implementation as reference?=0A=
>>>>=0A=
>>>> Thanks,=0A=
>>>> Horia=0A=
>>>=0A=
>>> Yes, use the generic driver as a reference.  I don't understand why you=
're=0A=
>>> saying there are so many cases to handle, though.  The only error cases=
 I'd=0A=
>>> expect to actually be encountered during the tests are invalid input le=
ngths and=0A=
>>> invalid key lengths, where you should return -EINVAL.  There may be oth=
er errors=0A=
>> There's at least one more in testmgr: -EBADMSG.=0A=
> =0A=
> AEADs must return -EBADMSG when the authentication tag is wrong, but you =
said it=0A=
> was an skcipher algorithm.  Which algorithm are you talking about, exactl=
y?=0A=
> =0A=
The context in which I started the discussion was indeed skcipher failure.=
=0A=
However, now I am trying to make sure all types of algorithm implementation=
s are=0A=
returning the expected error codes.=0A=
=0A=
>>=0A=
>>> your driver could theoretically produce, but I wouldn't expect them to =
be=0A=
>>> encountered during the tests unless there are testmgr, driver, or hardw=
are bugs.=0A=
>>>=0A=
>> Is the error code matching a crypto API requirement or a testmgr require=
ment?=0A=
>>=0A=
>> I think testmgr doesn't cover all possible failures. Thus if somebody wa=
nts to=0A=
>> make sure the implementation is _fully_ compliant (and not only passing =
testmgr=0A=
>> tests), a lot of effort will be required.=0A=
>>=0A=
> =0A=
> Everything testmgr tests for is an "API requirement".  There are also API=
=0A=
> requirements that testmgr doen't yet test for, e.g. for skciphers that th=
e=0A=
> source data is not modified unless it coincides with the destination data=
.=0A=
> =0A=
> However with regards to failures, as I see it the only failures which *mu=
st* be=0A=
> handled consistently are those that apply to every implementation.  I thi=
nk this=0A=
> only includes cases where the input is bad, e.g. invalid key or message l=
ength,=0A=
> or authentication tag mismatch.  If you also have implementation specific=
=0A=
Ok, the list is not as long as I suspected.=0A=
=0A=
> failures, e.g. your hardware randomly stopped working or something, then =
for=0A=
> them you may choose appropriate error codes from errno.h.=0A=
> =0A=
This makes sense.=0A=
=0A=
Thanks,=0A=
Horia=0A=
