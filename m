Return-Path: <SRS0=1Yk9=S5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFADC43218
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Apr 2019 15:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3D39206A3
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Apr 2019 15:24:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="kSlSBJYF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfD0PYn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Apr 2019 11:24:43 -0400
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:33378
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728350AbfD0PYm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Apr 2019 11:24:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dz8egzYmy0mFoLEXBkbmY4OQZe7GHEaL/RNGMBjuCZc=;
 b=kSlSBJYFxPhyZfzzNduWEu0qHMnjCd+GXGa87qsxjR/SJ0KNE/lh8yqkTLZJ9lDZEJCu18lMp+DLSuFNcSeOFoYAAxnMTxx7KrsD/R1Nq5JzgyyiX8kcfvPFXGFZuB36NM2ZsBR/MarVvU/ZeCgMUfh1KcEeX8aH+52M2vn8wOI=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2861.eurprd04.prod.outlook.com (10.175.23.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Sat, 27 Apr 2019 15:24:38 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::484c:ab68:81c4:51be%5]) with mapi id 15.20.1835.015; Sat, 27 Apr 2019
 15:24:38 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/7] crypto: fuzz algorithms against their generic
 implementation
Thread-Topic: [PATCH v2 0/7] crypto: fuzz algorithms against their generic
 implementation
Thread-Index: AQHU/E4B9cUiZnJ1EEuei1pU1G4SaA==
Date:   Sat, 27 Apr 2019 15:24:38 +0000
Message-ID: <VI1PR0402MB34857CA032C0134714BE9A61983F0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190412045742.1725-1-ebiggers@kernel.org>
 <VI1PR0402MB3485A6BE1840DD5B060FACB7983E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190426165406.GA691@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [79.118.230.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13c45ede-9623-4014-c149-08d6cb247695
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2861;
x-ms-traffictypediagnostic: VI1PR0402MB2861:
x-microsoft-antispam-prvs: <VI1PR0402MB28610CF20237EADF10C73FA3983F0@VI1PR0402MB2861.eurprd04.prod.outlook.com>
x-forefront-prvs: 0020414413
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(136003)(346002)(396003)(376002)(54094003)(199004)(189003)(74316002)(55016002)(305945005)(8936002)(81166006)(97736004)(81156014)(8676002)(7736002)(86362001)(6436002)(6916009)(25786009)(4326008)(68736007)(229853002)(26005)(6246003)(102836004)(3846002)(486006)(53546011)(316002)(446003)(478600001)(186003)(54906003)(476003)(6506007)(76176011)(6116002)(33656002)(7696005)(5660300002)(91956017)(71200400001)(9686003)(71190400001)(52536014)(66556008)(66476007)(64756008)(66946007)(66446008)(73956011)(44832011)(99286004)(256004)(76116006)(2906002)(14454004)(53936002)(66066001)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2861;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gPOIeW18olWyWS/w8Z+Zg0UXkJR9fbaJu6u0R6be0jn+b/2LrWM9ideDUDwthwxLrFzswKJ75f+Xw519ViF6v0CsmTgR5+AV1gvIYLI4ZP20lphfQNAORQU02EJ9Wt/3OSoKo3tXT5fT072P/q+CohAS1rYttHulsVWUxlhjiE9QDgMluqDbhGRjgaNk4cDqj6X2bUNl1iIIiTZJaYdsRDvmsw07+yMsXpAX75ClnFD8wgkDccX29tq3n7tX+mmjnLRjuunux1o0qWw7WwJnObkuqKVylt/SwTco+eDmf7UQxDDVa6tkPshRzd7wct5vZbi70StYZih5NpT0gkPeq2ZXpssPmtHbAbLDNYjQS0bJUU0LuXGJsSQ2pyGQEZc1Ods7m6YZISqxX1NgW/lboo7wQjcHguScyOGs09jay3E=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13c45ede-9623-4014-c149-08d6cb247695
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2019 15:24:38.6909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/26/2019 7:54 PM, Eric Biggers wrote:=0A=
> Hi Horia,=0A=
> =0A=
> On Fri, Apr 26, 2019 at 04:35:05PM +0000, Horia Geanta wrote:=0A=
>> On 4/12/2019 8:00 AM, Eric Biggers wrote:=0A=
>>> So far I've tested all generic, x86, arm, and arm64 algorithms, plus=0A=
>>> some PowerPC algorithms.  I have not tested hardware drivers.  I=0A=
>>> encourage people to run the tests on drivers and other architectures, a=
s=0A=
>>> they will find more bugs.=0A=
>>>=0A=
>> I am seeing some errors in caam hardware driver.=0A=
>> They are due to error code mismatch b/w generic algorithm implementation=
 and=0A=
>> what caam driver returns.=0A=
>>=0A=
>> Random skcipher tests for block cipher algorithms are expected to fail w=
hen=0A=
>> input size is not a multiple of algorithm block size.=0A=
>> Generic implementation returns -EINVAL.=0A=
>> caam driver returns the status received from HW.=0A=
>>=0A=
>> This probably has to be fixed in caam driver, but I wonder if there's an=
=0A=
>> agreement on what error code should be returned in every single case (si=
nce I'll=0A=
>> have to do a N:M mapping b/w errors returned by HW and errors expected b=
y crypto=0A=
>> API).=0A=
>> Should I take the generic S/W implementation as reference?=0A=
>>=0A=
>> Thanks,=0A=
>> Horia=0A=
> =0A=
> Yes, use the generic driver as a reference.  I don't understand why you'r=
e=0A=
> saying there are so many cases to handle, though.  The only error cases I=
'd=0A=
> expect to actually be encountered during the tests are invalid input leng=
ths and=0A=
> invalid key lengths, where you should return -EINVAL.  There may be other=
 errors=0A=
There's at least one more in testmgr: -EBADMSG.=0A=
=0A=
> your driver could theoretically produce, but I wouldn't expect them to be=
=0A=
> encountered during the tests unless there are testmgr, driver, or hardwar=
e bugs.=0A=
> =0A=
Is the error code matching a crypto API requirement or a testmgr requiremen=
t?=0A=
=0A=
I think testmgr doesn't cover all possible failures. Thus if somebody wants=
 to=0A=
make sure the implementation is _fully_ compliant (and not only passing tes=
tmgr=0A=
tests), a lot of effort will be required.=0A=
=0A=
> But remember you must always return a -errno code, not a driver-specific =
code.=0A=
> =0A=
Correct, I'll fix this.=0A=
=0A=
Thanks,=0A=
Horia=0A=
