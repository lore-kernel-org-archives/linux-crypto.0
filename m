Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09242C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 07:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE717610A0
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 07:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239532AbhIWH0G (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Sep 2021 03:26:06 -0400
Received: from us-smtp-delivery-162.mimecast.com ([170.10.133.162]:30782 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234343AbhIWH0F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Sep 2021 03:26:05 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Sep 2021 03:26:05 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1632381874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wpC8kapF2veLCI5Vu6+LGRE4ihJBOu3lpnuN9nZKK20=;
        b=PMJ4ogf1ua6/T12aJmKyUeSEiHzs+JbFQHzwoKob4FBddbXHVQT6MW/vlMU4yTNZEYwaHx
        Njwya8/2kF0opQqM+24FgLm2YSDbosD4qGxgk6OP9SjOlbL6P5lt6AmXpi5zJPiHMbr0i7
        ki1hpxjPnS0k3mnFe52rwPiKVHS3moM=
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-5-VTw5i5PW6Ev4hjVu4r-Q-1; Thu, 23 Sep 2021 03:18:26 -0400
X-MC-Unique: 5-VTw5i5PW6Ev4hjVu4r-Q-1
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7712::13) by TU4PR8401MB0590.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:770b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 07:18:25 +0000
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d975:8f40:b3f8:58c9]) by TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d975:8f40:b3f8:58c9%5]) with mapi id 15.20.4544.014; Thu, 23 Sep 2021
 07:18:25 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     "'linux-crypto@vger.kernel.org'" <linux-crypto@vger.kernel.org>
Subject: RFC 4301,3602 and 4868 support in Linux kernel 4.9.180
Thread-Topic: RFC 4301,3602 and 4868 support in Linux kernel 4.9.180
Thread-Index: AdewSy81jPJe8Z5wSe2JLtUyTWuODg==
Date:   Thu, 23 Sep 2021 07:18:25 +0000
Message-ID: <TU4PR8401MB1216089F2D1773ECD03561FFF6A39@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-bromium-msgid: 8380b4a8-b2b5-4255-a6d7-d40ca50ff3e1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e1352dc-94b4-4b99-7031-08d97e625595
x-ms-traffictypediagnostic: TU4PR8401MB0590:
x-microsoft-antispam-prvs: <TU4PR8401MB05907DF0F06B19F569386EA1F6A39@TU4PR8401MB0590.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: tCrE8PfhNp6j5V9xFWOIdQLHqhQf+Y4G4i5D3qkb5KA4awlyD7DyYYou69ExjWA5UVvdOTmHN7q0FRonGk69iBF5TvqJ38Umofb540tCnWlMARJ0pJtj7jOeeQPl2Sm9l843lBmau5kNiiIaF0bfHE2zxDM7mrveTREkR0+5JvsK9HonghJxTh9n6n3Mvu8mV4RrA73XvjQ5Bb5/VAh2vJ6xPvcG0wurcrT11+2HZcVoGGQFkol9AZE9QJkcQSW3eeyQX/Exklnrniec2otz1syzfj04XZs3/LeDlRg+54iGhb5Rd3c53NSt49i7vhM7Jvd5xPIgbOpJlYdvlP91clPIu6ZIK5GYEcrc/Hq5OPD+rIUbVFGJsWj1ScCb/oIyAfmFHWAieVTAyk7wCxe+t9wPzDtNQ91fxnUtO/p2Nh17lIigXW6e8kCPpzYSA975JLA4cVsupPhETw1qx15IIyfYy51PoN9N/QCF001O9tS2Js9Bp9u/Me6XLCSUlddb+YX8+a7Kj7sQHTpZpkLnDwaUxa+0/26w3Wm08aEGf/XPdq98tyGcsL0ZEWe/ZxM545pE6PGRn5H5iX3k8tlzIS1azoWVinMJ9gtjhRGmzhiq+ZYrMxpV24z5WSf9+H/5UhEkXmFJZKJGvoBDuvQ0gFvlWkfnfxBQipa5hb5RuYjaW22HXYq2UBOgAYSJJXLBJk5GkcqMhQUg1GFLaFQ1zZSnRIB584ILweHnVE8MgJeXC+EVpVLhdt/4+SY3BbrPWnREQmioo66NlqVYT99BSgOrR8WQgMDRlA7ABIICt+3y5DNCv9PtIIvP9ptMFJEc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(55236004)(33656002)(38070700005)(8676002)(83380400001)(5660300002)(122000001)(52536014)(86362001)(6506007)(55016002)(76116006)(71200400001)(9686003)(66574015)(7696005)(4744005)(66946007)(966005)(8936002)(66446008)(64756008)(66556008)(186003)(26005)(6916009)(316002)(2906002)(66476007)(38100700002)(508600001)(491001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mIXKQZvCV715k9fED3/k1YmxvWHlrikHVR3vQ/CuY4rvoCAXHg/OA8g17zru?=
 =?us-ascii?Q?vFe6FXdaUxDAZEis/vg3RVo4YpYy8Izkzf81WYl1ZUmzXH4iJ5LOh1eHnfJS?=
 =?us-ascii?Q?IwB0CSQ9wD7SU8l4c5wzauzYs+GD9yskm0KBpkIYbqf+fcLzmYfktaC1EIaU?=
 =?us-ascii?Q?Y7D+jpJQNNszmUKiAPlKSmO46VJM7UA6p0fE1U/o19IcFr/8Y+peNBRL7pLe?=
 =?us-ascii?Q?+rC6S8fPCpiWu5ZLlWa8nsGkQPTPv21QFwdOEBKrHueJJ5tfoUQyaGiINgvx?=
 =?us-ascii?Q?HL1N3p4uz0VUHD2jTfSAL0QKS73A44Tn+fl7RtfBY/BRxL+muPkGkONEUHU9?=
 =?us-ascii?Q?Al85A2WRaih1Me2LpElySLoMrwfOy9kwcKxWfBK0Lq3ss9toa3GCUog6zHKy?=
 =?us-ascii?Q?xnCqM9X7yymBVHAPR2c0i3l8cpu1PWONc5Ouvj6n9p6VmuNkzhUPK2XzUACO?=
 =?us-ascii?Q?bSAPosP0fjz0k11A8VMwQN2iHDTM4Jj03FGpvQkvM6TszL1shNv5zGILwH25?=
 =?us-ascii?Q?bBxSPhsOO1dh71nG69zKcPm9yKJxisE3ta77MZsMFtl7GDPit2sScyYRBpsW?=
 =?us-ascii?Q?FwvkYmgzIHhiFAA1rGcl6zz1dPz7ZCDB7zFr4Ci7EvF13/E8FXLa7a5u3fB4?=
 =?us-ascii?Q?1StBErzvFsIpCS/yeodvAUFtAYY+w0I90jfMlSVGQgAI9Pu2FbHXYzASDfr1?=
 =?us-ascii?Q?8qgVW5YfNlpuFUg0jzrmMWhStJavm6g5RzNSeHB7NyR0V26u5rgYLED1IAoz?=
 =?us-ascii?Q?xOD/UMFunkRgoSnx+Q+tBtoZ8/5+dkXPp7Ek3lN9+S39LuymQrRZks58O/y5?=
 =?us-ascii?Q?Y6lrwifXT1gf7rsd7fZsow9H9Ep7b8iUsagA4BwelG52Qia/kc0kWBSXZYM3?=
 =?us-ascii?Q?TBRJBcll5Lc4CwmVT8ONgQPA8vBdhURfyR72XB8qRczVdlVgfQ7/Eh/32qy6?=
 =?us-ascii?Q?Gb+octSJshmHPbTQNXRuz51URgEgGvri0jMnP+yFAMq4utE61CoAvZE8JLY5?=
 =?us-ascii?Q?O3ulTd52+OhTzdSra6RyJ4cJYnABb+4OHCO9D2eBTDZeKfcZtkIf7ScUXZLg?=
 =?us-ascii?Q?BmxQnXixaBmOejZnmASc/syk91wxzLpM4goTLAm/niFE5mJVBcWRFXFBeF6L?=
 =?us-ascii?Q?0YSOACy33s/kzLexGf+FcmHAtV5j0QzCF77BPqIeKK3VZBncaol428cQHzbe?=
 =?us-ascii?Q?zrgz/XUiRvQ+ik1PkUkhTbKLX6UnsEiAOddCP3KmbWlPX/P4jGrvdKjyAQLh?=
 =?us-ascii?Q?6Jbe89B+fNgyGqXPHZ3oMgfuzB3Rg/Fq1SRDjkx1Nq67aX2Qhu3x2+pKoDQ6?=
 =?us-ascii?Q?s4SBxFflWCUfh60Yj4H0Z2ot?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e1352dc-94b4-4b99-7031-08d97e625595
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 07:18:25.5848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iGPx6CGISu/6bsCg+4VIlED+Zp/b5D4/8tRGzS7Gx06x7rLemcGG7gdoIhl94S2YC7k2jZEIKUW9MoIYLHgrVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB0590
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA62A171 smtp.mailfrom=jayalakshmi.bhat@hp.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: hp.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi All,

We are in the process of submitting our device for Common Criteria Certific=
ation. Our device uses Linux kernel 4.9.180  for aarch64.  We want to under=
stand of the Linux kernel version 4.9.180 supports the below RFC's. I looke=
d in https://www.kernel.org/doc/rfc-linux.html, but could not get enough in=
formation.=20
Can anyone let me know if the Linux kernel support the below RFC's.=20

*=09RFC 4301 (Security Architecture for the Internet Protocol)
*=09RFC 3602 (The AES-CBC Cipher Algorithm and Its Use with IPsec)
*=09RFC 4868 (Using HMAC-SHA-256-, HMAC-SHA-384, and HMAC-SHA-512 with IPse=
c)

Regards,
Jayalakshmi

