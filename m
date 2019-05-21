Return-Path: <SRS0=VBnc=TV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB7CC04AAF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 14:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 006B92173C
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 14:18:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="AxoWZ6TG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbfEUOSU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 May 2019 10:18:20 -0400
Received: from mail-eopbgr10078.outbound.protection.outlook.com ([40.107.1.78]:23360
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726750AbfEUOST (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 May 2019 10:18:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5ut99AYanfwbPz4JuKZP5ugvRWkJVj+8nWCB+RBiWQ=;
 b=AxoWZ6TG9PJ/RRbRqFLKIJDySrnQIGPvu3QreP1iHyOib/7lBuDvD1C2ug6t6vClUGR1fuR6iccgbl7y8gGbFXz8+k4vcGKmXMaO5zzQl3/1ZBSCM08uxsmkqPLt6ywgvZrk7EMfHIn0DlHfdLKxyOTZWqZFSkSYXecLMasFKXI=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3725.eurprd04.prod.outlook.com (52.134.15.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Tue, 21 May 2019 14:18:16 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a450:3c13:d7af:7451]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a450:3c13:d7af:7451%3]) with mapi id 15.20.1900.020; Tue, 21 May 2019
 14:18:16 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 2/3] crypto: caam: print debug messages at debug level
Thread-Topic: [PATCH 2/3] crypto: caam: print debug messages at debug level
Thread-Index: AQHVDJL8mmT01przhESHS2q17fhpQg==
Date:   Tue, 21 May 2019 14:18:16 +0000
Message-ID: <VI1PR0402MB34858BA974ECCBF303931CC198070@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190517092905.1264-1-s.hauer@pengutronix.de>
 <20190517092905.1264-3-s.hauer@pengutronix.de>
 <20190517095018.7qcufwb77nu3owb4@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [94.69.234.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 124777c3-a56a-4f1a-8abf-08d6ddf72afc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3725;
x-ms-traffictypediagnostic: VI1PR0402MB3725:
x-microsoft-antispam-prvs: <VI1PR0402MB372587121AE1AEC309EBD18098070@VI1PR0402MB3725.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0044C17179
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(396003)(366004)(346002)(199004)(189003)(316002)(66476007)(5660300002)(2906002)(15650500001)(66066001)(7696005)(76176011)(110136005)(53546011)(6246003)(6506007)(99286004)(25786009)(66556008)(6436002)(9686003)(68736007)(71190400001)(74316002)(229853002)(478600001)(71200400001)(14454004)(55016002)(2501003)(33656002)(44832011)(486006)(186003)(53936002)(86362001)(476003)(6116002)(446003)(3846002)(305945005)(7736002)(66946007)(64756008)(66446008)(73956011)(52536014)(26005)(81156014)(81166006)(4326008)(76116006)(8676002)(102836004)(256004)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3725;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TJmVFahiG4G7BIFXG2IDWNl/nu4o7KIUu9qYK48Lhle08GoIJkTplX+VH+0k01VyIRKjcjBhgQ5LS8D4VGG7Yx7OKpUnptH5G1yaHUu4zNRMZSLBLhIStLiIOah3ZZrCABv8yfIdRIby3TAlu6xN/QXcQp1fLOB3sKuYX5wDcYW/4yn5mXYF+Qu4z4XwcMHLSb7eO+EuRORRpDCmwNqQRi/ljmZp/3Q/x9A7dbU2/0tVrqQmHbPOg2Q4O+CEV9QbKEd8jMsE8onmthNaxbcVVGuV5HHQynWU40qDES0nRJ/aE+qhfNgW3X4xk6gdYmpdUwKcdDuq9YewUEeazBqpFSHRPyBmHFUrrqz3eCgpi2gxQnFA1EJFpVgScOQ8HNA41YSuRUBrUEDzfcPL8V62a/+G/stnhwWtXrj0e4qQBe4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 124777c3-a56a-4f1a-8abf-08d6ddf72afc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2019 14:18:16.6378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3725
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/17/2019 12:50 PM, Sascha Hauer wrote:=0A=
> On Fri, May 17, 2019 at 11:29:04AM +0200, Sascha Hauer wrote:=0A=
>> The CAAM driver used to put its debug messages inside #ifdef DEBUG and=
=0A=
>> then prints the messages at KERN_ERR level. Replace this with proper=0A=
>> functions printing at KERN_DEBUG level. The #ifdef DEBUG gets=0A=
>> unnecessary when the right functions are used.=0A=
>>=0A=
>> This replaces:=0A=
>>=0A=
>> - print_hex_dump(KERN_ERR ...) inside #ifdef DEBUG with=0A=
>>   print_hex_dump_debug(...)=0A=
>> - dev_err() inside #ifdef DEBUG with dev_dbg()=0A=
>> - printk(KERN_ERR ...) inside #ifdef DEBUG with dev_dbg()=0A=
>>=0A=
>> Some parts of the driver use these functions already, so it is only=0A=
>> consequent to use the debug function consistently.=0A=
>>=0A=
>> @@ -993,20 +978,17 @@ static void skcipher_encrypt_done(struct device *j=
rdev, u32 *desc, u32 err,=0A=
>>  	struct crypto_skcipher *skcipher =3D crypto_skcipher_reqtfm(req);=0A=
>>  	int ivsize =3D crypto_skcipher_ivsize(skcipher);=0A=
>>  =0A=
>> -#ifdef DEBUG=0A=
>> -	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",=0A=
>> +	print_hex_dump_debug("dstiv  @"__stringify(__LINE__)": ",=0A=
>>  		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,=0A=
>>  		       edesc->src_nents > 1 ? 100 : ivsize, 1);=0A=
>> -#endif=0A=
>> +=0A=
> =0A=
> I just realized that this print_hex_dump_debug() needs to be inside if (i=
vsize)=0A=
> because since eaed71a44ad9 ("crypto: caam - add ecb(*) support") req->iv=
=0A=
> can be NULL. This is broken with or without this patch, I can include a=
=0A=
> patch fixing this up when doing a v2.=0A=
> =0A=
That's true.=0A=
Since this patch set is orthogonal to the bug, IMO the fix shouldn't be par=
t of it.=0A=
=0A=
Thanks,=0A=
Horia=0A=
