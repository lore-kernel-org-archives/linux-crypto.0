Return-Path: <SRS0=tj8v=AO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8545DC433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 03:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CDB220674
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 03:48:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="eZ35rr01"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbgGCDsL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jul 2020 23:48:11 -0400
Received: from us-smtp-delivery-162.mimecast.com ([216.205.24.162]:37417 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726039AbgGCDsK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jul 2020 23:48:10 -0400
X-Greylist: delayed 672 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2020 23:48:09 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1593748088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rfDtEE96AyHWx5Y6ntExo7fUhaPUFOoykfyAU93syyM=;
        b=eZ35rr01kzocFa2YOPyH0tjV27Vcise/X+X+jthgHolt9oNwphwEYw4w/FNF+ssK4JBiiS
        c4wF+KKJNaosf0xc6GDH2mD46wQID20BrogHAQuwR3j9eHCPEipBiki94jpH7b/7Zfqs6i
        8h27YPRSwq8R8cl/TyG7NJbFZl5dHMo=
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-fJR2NMFVP9GsPSSeeId1aA-1; Thu, 02 Jul 2020 23:48:06 -0400
X-MC-Unique: fJR2NMFVP9GsPSSeeId1aA-1
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7712::13) by TU4PR8401MB1006.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:770e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Fri, 3 Jul
 2020 03:48:05 +0000
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::402e:74e4:29e4:6b82]) by TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::402e:74e4:29e4:6b82%5]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 03:48:05 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: PMTU is not working for IPv6-ESP
Thread-Topic: PMTU is not working for IPv6-ESP
Thread-Index: AdZQ63k9LdkefBzDRJaihakLenlcUg==
Date:   Fri, 3 Jul 2020 03:48:05 +0000
Message-ID: <TU4PR8401MB1216FD1EFDDD4366E3DBF807F66A0@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.111.203]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7037cc80-785f-46af-b303-08d81f03e4ad
x-ms-traffictypediagnostic: TU4PR8401MB1006:
x-microsoft-antispam-prvs: <TU4PR8401MB100669E454D0217C961285D2F66A0@TU4PR8401MB1006.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RQQJJRnWpiNs003WOc44oVEVakmLfxU7+IzM5ehkdluioAP26s0LI0nwei4K0Hpie58RIrHthsuGbZrQrV8K3VH5kx7lO4L42vWCzYUxGfD1M0KQkbYsBU3k1hBl+WR7Z8I+cPLR81k97h6Ng68IyQb8ChOTgEl+C4NwBK5ilHBu6iRxkLDOlHI8wTWQGH8JHsx9bXdqjNNRaVNtTrlo8ntaFNTYuxfoMwHeoEeLvoe36SafMkWigLRQxUqPydMuL5pzcIwSUgXQOXRhRxffhysEvs5v3zwNhgwsbv4g1UdJ3JQJ2q2RvvyhYrLs4q1C9mMuIlN/haJPF5Dj2ZOwSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(366004)(39860400002)(346002)(376002)(478600001)(8936002)(55016002)(6916009)(2906002)(8676002)(83380400001)(71200400001)(5660300002)(66946007)(66476007)(316002)(186003)(66556008)(64756008)(66446008)(76116006)(86362001)(7696005)(33656002)(9686003)(26005)(55236004)(6506007)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 8iqYktCjFfYE2jDqZUw0NPVI4J8Y2Dgplp7cIMHFc0N+5W75Jr/3bsY60c98iTH9gjyr7X2RGp8APnSkA3C0w95VBGppAcOwRcH7y/QN/hA4NHk8QwamcoVYdR4ipF8oQ2Pcc1TvNioKcaClBkOB+LMzgvkHsk7+vSjE8JK6gnbqe5M0vPM+b6Y1Rbc8EzgaCr/4C7SBiYlNpLPppLOf26BdnNIiRClm5AqWliJkiUfnlblJedtdMx3hN1A7Wr6iyPmi/wGxXJ2eJkWIoQB5O/6MXU4hfnv4BxYGOovEiNTLP/3oB7/8SLhfu2y8bxKDN57aaLnPk5RlDiDSEyf3dS1mcTmvPaf7JY+CmXqNQVd7wKY5Cb9vgRTGMR1f4zF6uzsBKzvW5xru37oFNASs0OJ7IZAgXoNnXwvZpuS0I1LBl6cu02ACqBsEbOVSvRhO6eB9a3pu0C3hrW/6bV17wcv6kx3KACEmuREkCzbEuVUPpAfwToq+RYvZcw780UW4
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 7037cc80-785f-46af-b303-08d81f03e4ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 03:48:05.3477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sM73S0bu0WbZOOC1619VLZITaW0Fo48xhlgNclhWEyT/YdIE4wEyCW24YmkcF1vZA8Fgilfun3xxHnYAfEPqXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB1006
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA62A171 smtp.mailfrom=jayalakshmi.bhat@hp.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: hp.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi All,

We are executing a ping test in TUNNEL mode. This is to test PMTU. The test=
 configurations are as below.

IP address of our device: =093000::268:ebff:fe85:539f=09
IP address of Host1=09:=093002::200:10ff:fe10:1280
SGW (Gateway address):=093001::200:10ff:fe10:1161

1. SGW sends ICMPv6 Echo Request from Host1 to our device within ESP=20
2. Our device responds back with ICMPv6 Echo Reply to Host1 within ESP Tunn=
el

3. SGW sends ICMPv6 Echo Request fragments totalling 1500 Bytes from Host1 =
to our device within ESP Tunnel=20
4. Our device reassembles ICMPv6 Echo Request and transmits fully assembled=
 ICMPv6 Echo Reply to Host1 within ESP Tunnel

5. SGW sends ICMPv6 Packet Too Big Message within ESP Tunnel to our device=
=20
6. SGW sends ICMPv6 Echo Request fragments totalling 1500 Bytes from Host1 =
to our device within ESP Tunnel=20
7. Our device reassembles ICMPv6 Echo Request and transmits fragmented ICMP=
v6 Echo Reply to Host1 within ESP Tunnel=20

Now device fails at step7. When I looked into esp6.c, I found that ip6_path=
_mtu setting never gets invoked. This is done in esp6_err function.
I am not seeing this function being invoked at all.=20

I am not sure when this function is supposed to get called.

It would help a lot if any one can give me inputs.

Regards,
Jayalakshmi

