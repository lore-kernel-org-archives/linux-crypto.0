Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3041DC76190
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 15:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE1CF204FD
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 15:21:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="KuKEaz6d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfGVPVn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 11:21:43 -0400
Received: from mail-eopbgr130050.outbound.protection.outlook.com ([40.107.13.50]:41675
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728312AbfGVPVn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 11:21:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mko8P1lN2rVsL+cX1bcGMkIB5TS2g+fu8ICYFjNz/Na4PLsWy4gtN4kr8MRy4QoZw/jx8C1xef8UZgF6v8WFKMIo4SioaT8YSfyasAH9ku8oa/NUZJymZMJYq07wlvy+Vwrdx9nENr44jLLBNi5V3XWCms4Ng15Hiv1xDLuwzMBwIYjHDZMWrgVLoE/SU5z/qm0nRFkRnMyFal6RfJiWzY4ethhhXC0+AfkGZZG1zc5WvV4E8Y0SC7Kb5x7kTLlWzQPYflaOuKhE5PgCnTST3IiOtfUztJ/nf6uwBclWOlUJnWRjQTygqLmDB60DvpXZFzB+NCacfj+No6/Qs7Mnog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1qi+jKjufLxkx/Z00Jg8lHJJKbIr1QiHnywHjYylVrE=;
 b=T4tbMcWssQ361E2aFtlkosiz/xA2BNkADwkknslSvi2fZQOAanwazgdVVlRJEZJlOoct486wC8npOEVnrzxDhEAKAs/8o1qgVsHkYjV8JOvQpI75MLAQyry8rsxkfm2e4QtmIcsKs806KO8nKGQi398OBReS8By5+RpaCXpvYIs/ElICyPSQYsfLhzl1PAJuQt47GTc4w9VlMKziZVGEdd46m6Qmf05L+hxfVnnNiV31dQ9n1YdGlb086fjWCekin80+66jTt9v+F209TQ3GbXiMAkKuL3iAHiAKDyPyNmEW44yIzN811ijmHRKWOs9GPgBP8MjlAqv7Kd0GvOjtnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1qi+jKjufLxkx/Z00Jg8lHJJKbIr1QiHnywHjYylVrE=;
 b=KuKEaz6dyxm3q4JZkWOTWah7E60UMbCJOfTSY23vybhn1KD756lrKTGxv2EuKMKw3Aq+s28Y+G2pqXdwYSUQmqCBQGQ1HOHZRBG2jBYR3unRgSEPG0z6l/hJN0Jp7/b9NqythXmJmlfDTh/qQWn08tSdi9Lhu8ESlprP5zgAuOc=
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com (52.133.50.141) by
 AM0PR0402MB3586.eurprd04.prod.outlook.com (52.133.43.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Mon, 22 Jul 2019 15:20:57 +0000
Received: from AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::2080:6953:47fc:bcd]) by AM0PR0402MB3476.eurprd04.prod.outlook.com
 ([fe80::2080:6953:47fc:bcd%7]) with mapi id 15.20.2094.011; Mon, 22 Jul 2019
 15:20:57 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Topic: [PATCH v2] crypto: caam/qi2 - Add printing dpseci fq stats using
 debugfs
Thread-Index: AQHVPiRTTO5nYvxvX0qf2jZsStExEA==
Date:   Mon, 22 Jul 2019 15:20:57 +0000
Message-ID: <AM0PR0402MB34767A06ADA7BBABD25CF13B98C40@AM0PR0402MB3476.eurprd04.prod.outlook.com>
References: <20190719111821.21696-1-vakul.garg@nxp.com>
 <AM0PR0402MB3476F392D3A791DDE2F5B67898C40@AM0PR0402MB3476.eurprd04.prod.outlook.com>
 <DB7PR04MB4620F4D9DCCF4894E0C6941E8BC40@DB7PR04MB4620.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b5a3a61-d480-4114-5d7e-08d70eb8324d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR0402MB3586;
x-ms-traffictypediagnostic: AM0PR0402MB3586:
x-microsoft-antispam-prvs: <AM0PR0402MB3586451F50A958967F158F9898C40@AM0PR0402MB3586.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(13464003)(199004)(189003)(81166006)(476003)(8936002)(81156014)(446003)(74316002)(256004)(8676002)(68736007)(486006)(305945005)(54906003)(14454004)(7736002)(316002)(2501003)(6116002)(33656002)(3846002)(26005)(99286004)(4326008)(86362001)(2906002)(76176011)(66446008)(102836004)(66556008)(64756008)(6506007)(53546011)(6246003)(6436002)(52536014)(66066001)(71190400001)(71200400001)(5660300002)(76116006)(110136005)(229853002)(7696005)(9686003)(55016002)(91956017)(44832011)(25786009)(478600001)(66946007)(53936002)(66476007)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0402MB3586;H:AM0PR0402MB3476.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5JlH4gsQZmA/WzC/aFiUMw6mjObBZbQ49codvZxgc8IuY9f0R7Ynj0mKpE5lVSQHSJGQg2fsOiGnB3lNLc4HcpgDoko1oPUcvfVmqgX/8XA/0WZaPrfUOAiAPdDn0W0OwORJWK9VdzfvIB8ZDI5vfUc8aDWKaEA846IevwJH2Hwq4jKUJYVDJSvFFlGmoJSnhjtB9bhfRqeSSZ7nDbI6BVDjYYb1pqAJZf6PSUO4ZC0KYklQrJPM24WPTFh4+KlrWdIPxbNzqMKzE/4qLGSF2FVi0OvTPrrZ7nkbmxrxTNHsA2MVhFRSfCGRDW+UHjxAOVrjqCNfvQe+YlqGYdSFMekalrzpmQ2T4SHL9Ky9UsLUvUvWS88Z1IrMFE5LQUZqQJK0WVvUU2prOGyVvLzr1VKknKixt6vPhn6hyHb6ZAw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b5a3a61-d480-4114-5d7e-08d70eb8324d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 15:20:57.5827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3586
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/22/2019 5:29 PM, Vakul Garg wrote:=0A=
>> -----Original Message-----=0A=
>> From: Horia Geanta=0A=
>> Sent: Monday, July 22, 2019 7:55 PM=0A=
>> To: Vakul Garg <vakul.garg@nxp.com>; linux-crypto@vger.kernel.org=0A=
>> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>;=0A=
>> herbert@gondor.apana.org.au=0A=
>> Subject: Re: [PATCH v2] crypto: caam/qi2 - Add printing dpseci fq stats =
using=0A=
>> debugfs=0A=
>>=0A=
>> On 7/19/2019 2:23 PM, Vakul Garg wrote:=0A=
>> [...]=0A=
>>> +if CRYPTO_DEV_FSL_DPAA2_CAAM=0A=
>>> +=0A=
>>> +config CRYPTO_DEV_FSL_DPAA2_CAAM_DEBUGFS=0A=
>>> +	depends on DEBUG_FS=0A=
>>> +	bool "Enable debugfs support"=0A=
>>> +	help=0A=
>>> +	  Selecting this will enable printing of various debug information=0A=
>>> +          in the DPAA2 CAAM driver.=0A=
>>> +=0A=
>>> +endif=0A=
>> Let's enable this based on CONFIG_DEBUG_FS.=0A=
> =0A=
> It is not clear to me.=0A=
> Do you mean not have additional CRYPTO_DEV_FSL_DPAA2_CAAM_DEBUGFS?=0A=
> =0A=
Yes.=0A=
=0A=
>>=0A=
>>> diff --git a/drivers/crypto/caam/Makefile=0A=
>>> b/drivers/crypto/caam/Makefile index 9ab4e81ea21e..e4e9fa481a44=0A=
>> 100644=0A=
>>> --- a/drivers/crypto/caam/Makefile=0A=
>>> +++ b/drivers/crypto/caam/Makefile=0A=
>>> @@ -30,3 +30,4 @@ endif=0A=
>>>  obj-$(CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM) +=3D dpaa2_caam.o=0A=
>>>=0A=
>>>  dpaa2_caam-y    :=3D caamalg_qi2.o dpseci.o=0A=
>>> +dpaa2_caam-$(CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM_DEBUGFS) +=3D=0A=
>>> +dpseci-debugfs.o=0A=
>> dpaa2_caam-$(CONFIG_DEBUG_FS)=0A=
>>=0A=
>> [...]=0A=
>>> diff --git a/drivers/crypto/caam/caamalg_qi2.h=0A=
>>> b/drivers/crypto/caam/caamalg_qi2.h=0A=
>>> index 973f6296bc6f..b450e2a25c1f 100644=0A=
>>> --- a/drivers/crypto/caam/caamalg_qi2.h=0A=
>>> +++ b/drivers/crypto/caam/caamalg_qi2.h=0A=
>>> @@ -10,6 +10,7 @@=0A=
>>>  #include <soc/fsl/dpaa2-io.h>=0A=
>>>  #include <soc/fsl/dpaa2-fd.h>=0A=
>>>  #include <linux/threads.h>=0A=
>>> +#include <linux/netdevice.h>=0A=
>> How is this change related to current patch?=0A=
>>=0A=
> =0A=
> It should have been here in first place because we have some napi related=
 things in this file.=0A=
> It is required as I got compilation errors now.=0A=
> =0A=
Indeed, this is caused by including caamalg_qi2.h -> dpseci-debugfs.h ->=0A=
dpseci-debugfs.c.=0A=
=0A=
Compiling this patch without the inclusion:=0A=
=0A=
  CC      drivers/crypto/caam/dpseci-debugfs.o=0A=
In file included from drivers/crypto/caam/dpseci-debugfs.h:9:0,=0A=
                 from drivers/crypto/caam/dpseci-debugfs.c:8:=0A=
drivers/crypto/caam/caamalg_qi2.h:84:21: error: field 'napi' has incomplete=
 type=0A=
  struct napi_struct napi;=0A=
                     ^=0A=
drivers/crypto/caam/caamalg_qi2.h:85:20: error: field 'net_dev' has incompl=
ete type=0A=
  struct net_device net_dev;=0A=
                    ^=0A=
scripts/Makefile.build:278: recipe for target 'drivers/crypto/caam/dpseci-d=
ebugfs.o' failed=0A=
=0A=
=0A=
Other driver files include linux/netdevice.h indirectly, via compat.h ->=0A=
linux/rtnetlink.h.=0A=
=0A=
Most *.c files in drivers/crypto/caam solve dependencies by including=0A=
compat.h, but this approach is messy.=0A=
=0A=
Let's keep the explicit inclusion then.=0A=
=0A=
Horia=0A=
