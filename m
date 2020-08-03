Return-Path: <SRS0=sEgb=BN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1FAC433DF
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 05:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11A98206D7
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 05:11:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="DYgzwwJQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgHCFLm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Aug 2020 01:11:42 -0400
Received: from us-smtp-delivery-162.mimecast.com ([63.128.21.162]:45952 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725935AbgHCFLl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Aug 2020 01:11:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1596431499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nT3O0+43GUvPaKwdl7Vbzy2+9/trYq5LWtHZ4V8GaeA=;
        b=DYgzwwJQH4AjvomnZ6266r8aI1IQws4FX1O7Cd29Cy4O2Y1LhBcjSuOWMwgOkinsL3GZlM
        m/j4WsNTqa95ryRnoM6NZAy0OqS3CFS3aGsm9zIc4lW9xp0foiA4KYWE7sQhv+42TmgaB5
        QB78p4yTP9nvbJ6YQ8215cJZ+Dvi9zY=
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
 (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-f05OtCFvMR6iqZRkNLyBLg-1; Mon, 03 Aug 2020 01:11:36 -0400
X-MC-Unique: f05OtCFvMR6iqZRkNLyBLg-1
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7712::13) by TU4PR8401MB1294.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7715::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18; Mon, 3 Aug
 2020 05:11:35 +0000
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::402e:74e4:29e4:6b82]) by TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::402e:74e4:29e4:6b82%5]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 05:11:35 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: XFRM tunnel issue.
Thread-Topic: XFRM tunnel issue.
Thread-Index: AdZpVG7m8mx+U7beT0Ow03dB9bPnXQ==
Date:   Mon, 3 Aug 2020 05:11:35 +0000
Message-ID: <TU4PR8401MB12162F28D0409D90561054A4F64D0@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.105.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82883052-6602-41c2-f2c9-08d8376bb1ab
x-ms-traffictypediagnostic: TU4PR8401MB1294:
x-microsoft-antispam-prvs: <TU4PR8401MB12945B7B22502EEEBF6C67F9F64D0@TU4PR8401MB1294.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uI/BT9urLts3o9KpgdbjFCuL6voct5XFuBj+XWopWEewNgeJwcHDF7rZkms1jCYQKkoWG/r/ZI5vpEZgG49RfH9VCoM7DZvm7G9EdqU8PNh3g0ss6LZWeB8ouUsx+8sMhM+E5JPKJbyRpdl+wEHrMcE6IzGXJil4DHyuVgZgz9aZ4XKoE12NzNBfwXK2roGZ8qTpC0zlG8OXU2K7nQzc7TYC9rsIdTT4bsB1kTYsxHzkEL/i3qk/E20/Wu5awzb5x7LCVIpriykVfzivXNW8lM1LZQCy370/tG1V0T/r443PVe8XbLS0Sp0D6DtoSZ2NC5Ec00UiawzFegTPAH8LWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(346002)(136003)(396003)(366004)(71200400001)(5660300002)(55016002)(9686003)(83380400001)(7696005)(52536014)(7116003)(66946007)(26005)(86362001)(186003)(6506007)(33656002)(55236004)(66556008)(8936002)(8676002)(316002)(66476007)(6916009)(66446008)(64756008)(76116006)(3480700007)(2906002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: tEqupCFeDYUAFwY1ogqSeJRfGliHgQzEmITa9PzMM1WGtRgy5WQ093M7ZO2q2klueio3reup0KdADkIiVSdcnEX0o5JsN1eas5KTK7DWTKSVDExJaJDVV4IwXwKkupXGn8S87gse7KzL4ixVSWJGz/7eN5YDGzB8fKEQZAqE51h89Zht44XBuQQGB0TuYs549CTE5ibpBExU3iPdvwHqypPbCQAfM2Mwx13C7aaFsf1C9Ouim4iZHCA0GS6pxeqOPzeDYlhelebqV9+NMIGuxtGVvXFJ6cPn7IEiD1nAQSeXH4pjMFUqiTgG98aP9Csl187G613OmkdeljY46WBTTSVb+TXrtF2bSruirXXDtn5ExMscZt7AtD6MHQpLQlBK1n/2iQothAO1N+ycwP0G7EtfNeO4SyltMLididfyu/P6D/6oMRvn07aeqYDXg4JUGym2c0s2jzZ1Av55ZKAzdwzGvNlLXjvn4uj0O5HRk1yvFxfL6MVVJzIkAvCTBrIxBmGOcIgHIAKKR6F9WIYMIsuf/tOSZS/kB92PLmXiPZGt/UjyQ+Frr5Fs+p0FJ6CZxkfwe2WCX2mw585vo7ffrexUmiwOusVOPJv9fQPUecKGfnhDujS0KoWqSDnvEOBkQ0Np6x6osvlB/tN0ThcYaQ==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 82883052-6602-41c2-f2c9-08d8376bb1ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 05:11:35.3730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LH/Gp9GEDErhkpdK5m1vUWqsmldsNbJrB7/nAJ7WJYmWJDtvrduekBwsW3Iz/jRww2FWtYu5L/ZDaS6+C+m6oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB1294
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

We have tunnel test scenario as below

IPsec tunnel gets created between =20
1. Our device    =093000:0000:0000:0000:b25c:daff:fe67:f173
2. Gateway =093001:0000:0000:0000:0200:10ff:fe10:1161=20

There are 2 hosts behind the gateway
1. Host1       3002:0000:0000:0000:0200:10ff:fe10:1280
2. Host2       3002:0000:0000:0000:0200:10ff:fe10:1161

Packet sequence:
1.             Host1                       Sends a ping request
2.             Device                     Sends successful ping response
3.             Host1                       Sends a ping request (fragmented=
)
4.             Device                     Handles fragmented packets and se=
nds a successful ping response.
5.             Host2                       Sends packet too big request wit=
h MTU indicated
6.             Host1                       Sends ping request  =20
7.             Device                     Fails to send fragmented response=
, sends ping response.

Issue is with packet number 5.
1.             From IPv6 recv hook, packet comes to XFRM recv hook.
2.             At high level, there seems to be no issue with packet. Hence=
 XFRM state gets allocated to packet. And IPsec peer addresses are assigned=
 in the state properly.
3.             Packet gets decrypted by ESP and then reaches ICMP recv hook=
.
4.            Again XFRM policy look up is done. This is failing as XFRM po=
licy seems to be invalid. Hence packet gets dropped silently. =20

When the packet is received in xfrm_input and assigned a xfrm_state as belo=
w
daddr   0000:0000:0000:0000:0000:0000:0000:0000 =09dport  0  dport_mask 0  =
prefixlen_d 0
saddr   0000:0000:0000:0000:0000:0000:0000:0000 =09sport  0  sport_mask 0  =
prefixlen_s 0
family  0   =09proto  0  ifindex    0=20
daddr  3000:0000:0000:0000:b25c:daff:fe67:f173  spi -1503044001  proto 50=
=20
mark 0 0=20
saddr  3001:0000:0000:0000:0200:10ff:fe10:1161=20
=20
In icmpv6_rcv hook when XFRM policy look up is done
mark    8   =09      248=20
daddr   0000:0000:0000:0000:0000:0000:0000:0000 =09dport  0  dport_mask 255=
  prefixlen_d 0
saddr   0000:0000:0000:0000:0000:0000:0000:0000 =09sport  512  sport_mask 6=
5535  prefixlen_s 0
family  10   =09proto  58  ifindex    0=20
type    0   =09action 0  flags      0  xfrmr_nr    0 priority 20096408=20
daddr   0000:0000:0000:0000:0000:0000:0000:0000  spi    0  proto      0=20
saddr   0000:0000:0000:0000:0000:0000:0000:0000 =09family 0  reqid      0 m=
ode         0 share    0 =20

We are using the Linux 4.9.180 #71 SMP PREEMPT aarch64 GNU/Linux. Did anyon=
e face this kind of issues? Can you please provide me any inputs?

Thanks and regards,
Jayalakshmi




