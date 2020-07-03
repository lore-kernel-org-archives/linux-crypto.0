Return-Path: <SRS0=tj8v=AO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF0BC433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 03:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67324207E8
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 03:43:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="nOvp5h/a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgGCDnQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jul 2020 23:43:16 -0400
Received: from us-smtp-delivery-162.mimecast.com ([63.128.21.162]:46743 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbgGCDnP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jul 2020 23:43:15 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2020 23:43:13 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1593747792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=ZPxhMjIsOEwXELqGtth3hGXPWJdqH4+pdFDLPn65Aoo=;
        b=nOvp5h/a+LrMl+72xxFzzbDVDUgJ1gjmkLAToxcao/FpWUUd9ZYIDcLNXlPYn7LnrXiZp2
        9yz53I1yypCXkPRlYpVKh5VQQ/AJ/NXr3DNqhW3QrqxZQ73jqcOqtdQF2nuFD0yQHtGgs8
        8gfn8f3oGz0iDeavbK0SWapTMHPVZ10=
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
 (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-Qe3IM25iNGi0fgK9Srnz7w-1; Thu, 02 Jul 2020 23:36:54 -0400
X-MC-Unique: Qe3IM25iNGi0fgK9Srnz7w-1
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7712::13) by TU4PR8401MB0397.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7709::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Fri, 3 Jul
 2020 03:36:53 +0000
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::402e:74e4:29e4:6b82]) by TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::402e:74e4:29e4:6b82%5]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 03:36:53 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: No ESP response
Thread-Topic: No ESP response
Thread-Index: AdZQ6OLeMdJdrCYARMCKqKrhgWGGjA==
Date:   Fri, 3 Jul 2020 03:36:53 +0000
Message-ID: <TU4PR8401MB121625D980E4FEF13345BD12F66A0@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.111.203]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c67d2e50-a124-4f07-98ba-08d81f025434
x-ms-traffictypediagnostic: TU4PR8401MB0397:
x-microsoft-antispam-prvs: <TU4PR8401MB0397F5CCEF1CACB62BAC9210F66A0@TU4PR8401MB0397.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q9TAhkOWAosfolXaDtRcmWZP89lPQ4WPKrfH1CFI5nsCPU3CAYLs0BP2bXoJMsskbgI/4PwxhiulRcpUdKuXtkN1v/rhE96JOmhSQ//yrkEflZyeeTPMX2dhSjctKLtEd8XXlq4/KX/pw+diQY96U2EOakmn2i1CyDaQ8qbsG0Ep3r4nW1cx5J6q42HGxIJSgZyPxQHTKe4jGeagF5Uccjm6cIcDYzHo7S2BEhzegvep7ncHTD6P8sIFbWbyRPR2dNKvKffOqYEnORNBBLGqJsy+av8JTjToSvh64LtiMQhtInUoX5LmigO1kEUES8sNJBB4aejQleZJt72uXLzwEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(366004)(396003)(376002)(346002)(7696005)(99936003)(8676002)(478600001)(6916009)(3480700007)(76116006)(9686003)(55016002)(5660300002)(66576008)(66946007)(66476007)(66446008)(66556008)(64756008)(7116003)(26005)(186003)(8936002)(52536014)(6506007)(55236004)(2906002)(83380400001)(4743002)(316002)(86362001)(71200400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 6QdAkGP9y673NKYNlBupAt0WPWb7aIAM6zhrzUsI8Oqq1XgCV50ToxoawLbdayieWJ6NtB2ycJNfxZEGnT/cKTzPl2CAL4+kYHa+f014Pi3ZjvZYlnJpnaxRV9bya44spzU13Y1DALE1XOC1PvPen6BctzyUnmv2ZLVEWRJh498NDP1QHiGlohzZQ6GewHN6+wTgf89BdX+C2mlaqGYyFJP5q/iWoldSKjGqnRkUujD0lfEtHzqhuTNVa6K5uxjz67etTF81rIW/ecEdSY8Fc5xfqcmMeB8zPt6cYlxyo/+dAbesaW4osBd6TCtfoAmli1LvympgNjhJDn6OrVGpI2Smtc4Z52G+aH+ndHFm0DFZMFNfoQNavpA0IQoHCSZoND2TSMT0JnROBrlqOMUBor1MnQuDEfwMANoLMVy26SiScKUIGbMVx0j16WVmM8Q18fS5j0/bKpm/tCDUjM379/X6d9Wl84STgRa1DwEBSLGpdTZZ/3SKqruppJUQjA9G
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: c67d2e50-a124-4f07-98ba-08d81f025434
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 03:36:53.4664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D1zPI1aS7R0oVL3OrZDHxGvhPqV1Mtbi0qBkekt9CXqaVYiaqksw7pcnOL50h0VBRps/cvjnjJMKjQ847lhcxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB0397
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA62A171 smtp.mailfrom=jayalakshmi.bhat@hp.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: hp.com
Content-Type: multipart/mixed;
        boundary="_003_TU4PR8401MB121625D980E4FEF13345BD12F66A0TU4PR8401MB1216_"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--_003_TU4PR8401MB121625D980E4FEF13345BD12F66A0TU4PR8401MB1216_
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable

Hi All,

We are executing a simple ping test on our device in transport mode. Test c=
onfiguration and steps are as below=20

IP address of Host-1  =09=09=3D>  3001::200:10ff:fe10:1180
IP address of our device=09=09=3D> 3000::268:ebff:fe85:539f

1.=20
2 pair of SA's are established.
HOST1_Link1 --------------------- Our Device
=09--------------------> SA1-I                =20
=09<-------------------- SA1-O                =20
=09--------------------> SA2-I               =20
=09<-------------------- SA2-O=20

2.=20
HOST1 sends " ICMP Echo Request with  SA1 - I 's ESP "
Device sends " ICMP Echo Reply with       SA2 - 0 's ESP.
Decide sends " ICMP Echo Request with  SA 1 - 0 's ESP "
HOST1 sends " ICMP Echo Reply with       SA 2 - I 's ESP "

IPsec handshake are successful. Host is sending a correct ESP request. But =
our device is not responding.  I have attached the XFRM monitor logs and Wi=
reshark log.  Our kernel version is=20
Linux tron 4.9.180 #6 SMP PREEMPT Thu Jul 2 18:23:50 America 2020 aarch64 G=
NU/Linux.

Has any one experienced this kind of issue?  Please can you share your inpu=
ts??

Thanks and Regards,
Jayalakshmi


--_003_TU4PR8401MB121625D980E4FEF13345BD12F66A0TU4PR8401MB1216_
Content-Type: application/octet-stream; name="XFRM"
Content-Description: XFRM
Content-Disposition: attachment; filename="XFRM"; size=3219;
	creation-date="Fri, 03 Jul 2020 03:34:52 GMT";
	modification-date="Thu, 02 Jul 2020 18:02:40 GMT"
Content-Transfer-Encoding: base64

aXAgeGZybSBtb25pdG9yDQpzcmMgMzAwMDo6MjY4OmViZmY6ZmU4NTo1MzlmLzEyOCBkc3QgMzAw
MTo6MjAwOjEwZmY6ZmUxMDoxMTgwLzEyOCBwcm90byBpcHY2LWljbXAgdHlwZSAxMjggY29kZSAw
IGRldiBqZGkwIA0KCWRpciBvdXQgcHJpb3JpdHkgMjAwMDg2MzY3IA0KCXRtcGwgc3JjIDMwMDA6
OjI2ODplYmZmOmZlODU6NTM5ZiBkc3QgMzAwMTo6MjAwOjEwZmY6ZmUxMDoxMTgwDQoJCXByb3Rv
IGVzcCByZXFpZCAyMDEyNDA4MzQ5IG1vZGUgdHJhbnNwb3J0DQpzcmMgMzAwMTo6MjAwOjEwZmY6
ZmUxMDoxMTgwLzEyOCBkc3QgMzAwMDo6MjY4OmViZmY6ZmU4NTo1MzlmLzEyOCBwcm90byBpcHY2
LWljbXAgdHlwZSAwIGNvZGUgMTI4IA0KCWRpciBpbiBwcmlvcml0eSAyMDAwODYzNjcgDQoJbWFy
ayAweDgvMHhmOCANCgl0bXBsIHNyYyAzMDAxOjoyMDA6MTBmZjpmZTEwOjExODAgZHN0IDMwMDA6
OjI2ODplYmZmOmZlODU6NTM5Zg0KCQlwcm90byBlc3AgcmVxaWQgMjAxMjQwODM0OCBtb2RlIHRy
YW5zcG9ydA0KDQpzcmMgMzAwMDo6MjY4OmViZmY6ZmU4NTo1MzlmIGRzdCAzMDAxOjoyMDA6MTBm
ZjpmZTEwOjExODANCglwcm90byBlc3Agc3BpIDB4NTkzNzZkODAgcmVxaWQgMjAxMjQwODM0OSBt
b2RlIHRyYW5zcG9ydA0KCXJlcGxheS13aW5kb3cgMCBmbGFnIGFsaWduNA0KCWF1dGgtdHJ1bmMg
aG1hYyhzaGExKSAweDBlYzUzNmEwZWFiM2NhNjY5NjY3MDM2ZGM5NzMyYzFiMTA1NmViNmMgOTYN
CgllbmMgY2JjKGRlczNfZWRlKSAweDdmMTY1OWMxY2YyZGJkY2UxYjhlMWRhMmIwYjA1OWEyNWRm
ZjUyZWVkMDI3YzJlZg0KCWFudGktcmVwbGF5IGVzbiBjb250ZXh0Og0KCSBzZXEtaGkgMHgwLCBz
ZXEgMHgwLCBvc2VxLWhpIDB4MCwgb3NlcSAweDANCgkgcmVwbGF5X3dpbmRvdyAxMjgsIGJpdG1h
cC1sZW5ndGggNA0KCSAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCANCglzZWwg
c3JjIDo6LzAgZHN0IDo6LzAgDQpzcmMgMzAwMTo6MjAwOjEwZmY6ZmUxMDoxMTgwIGRzdCAzMDAw
OjoyNjg6ZWJmZjpmZTg1OjUzOWYNCglwcm90byBlc3Agc3BpIDB4NzdmMmVhMWMgcmVxaWQgMjAx
MjQwODM0OCBtb2RlIHRyYW5zcG9ydA0KCXJlcGxheS13aW5kb3cgMCBmbGFnIGFsaWduNA0KCWF1
dGgtdHJ1bmMgaG1hYyhzaGExKSAweGQ3YjZiOTk2NzZiYjQ1Yjg0NGU0NDhhMmQ0MWM4ZTEwNWNk
NzIzMWIgOTYNCgllbmMgY2JjKGRlczNfZWRlKSAweGE2MDJmMzE4ZWVlNzc4YjczNmI1NjZjNGYw
NzU4ZGJkMGFiNGViMTQwYjJjYzM2MA0KCWFudGktcmVwbGF5IGVzbiBjb250ZXh0Og0KCSBzZXEt
aGkgMHgwLCBzZXEgMHgwLCBvc2VxLWhpIDB4MCwgb3NlcSAweDANCgkgcmVwbGF5X3dpbmRvdyAx
MjgsIGJpdG1hcC1sZW5ndGggNA0KCSAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAw
MCANCglzZWwgc3JjIDo6LzAgZHN0IDo6LzAgDQoNCnNyYyAzMDAwOjoyNjg6ZWJmZjpmZTg1OjUz
OWYvMTI4IGRzdCAzMDAxOjoyMDA6MTBmZjpmZTEwOjExODAvMTI4IHByb3RvIGlwdjYtaWNtcCB0
eXBlIDEyOSBjb2RlIDAgZGV2IGpkaTAgDQoJZGlyIG91dCBwcmlvcml0eSAyMDAwODYzNjcgDQoJ
dG1wbCBzcmMgMzAwMDo6MjY4OmViZmY6ZmU4NTo1MzlmIGRzdCAzMDAxOjoyMDA6MTBmZjpmZTEw
OjExODANCgkJcHJvdG8gZXNwIHJlcWlkIDMzMzQ0NzY4NSBtb2RlIHRyYW5zcG9ydA0Kc3JjIDMw
MDE6OjIwMDoxMGZmOmZlMTA6MTE4MC8xMjggZHN0IDMwMDA6OjI2ODplYmZmOmZlODU6NTM5Zi8x
MjggcHJvdG8gaXB2Ni1pY21wIHR5cGUgMCBjb2RlIDEyOSANCglkaXIgaW4gcHJpb3JpdHkgMjAw
MDg2MzY3IA0KCW1hcmsgMHg4LzB4ZjggDQoJdG1wbCBzcmMgMzAwMTo6MjAwOjEwZmY6ZmUxMDox
MTgwIGRzdCAzMDAwOjoyNjg6ZWJmZjpmZTg1OjUzOWYNCgkJcHJvdG8gZXNwIHJlcWlkIDMzMzQ0
NzY4NCBtb2RlIHRyYW5zcG9ydA0Kc3JjIDMwMDA6OjI2ODplYmZmOmZlODU6NTM5ZiBkc3QgMzAw
MTo6MjAwOjEwZmY6ZmUxMDoxMTgwDQoJcHJvdG8gZXNwIHNwaSAweDA2ZmMxM2U1IHJlcWlkIDMz
MzQ0NzY4NSBtb2RlIHRyYW5zcG9ydA0KCXJlcGxheS13aW5kb3cgMCBmbGFnIGFsaWduNA0KCWF1
dGgtdHJ1bmMgaG1hYyhzaGExKSAweDNhNGIwZWM1ZDQ3YTBhZmIxYzM3NjUwNThmODlkOGZlOTk3
MTNmZjEgOTYNCgllbmMgY2JjKGRlczNfZWRlKSAweDA1ZmZiMjY5MGZlYzgyMGNhMzM2OWQzMTM5
Njk5ODk2MDhiNDFkNmE5ZmVmYmYxZg0KCWFudGktcmVwbGF5IGVzbiBjb250ZXh0Og0KCSBzZXEt
aGkgMHgwLCBzZXEgMHgwLCBvc2VxLWhpIDB4MCwgb3NlcSAweDANCgkgcmVwbGF5X3dpbmRvdyAx
MjgsIGJpdG1hcC1sZW5ndGggNA0KCSAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAw
MCANCglzZWwgc3JjIDo6LzAgZHN0IDo6LzAgDQpzcmMgMzAwMTo6MjAwOjEwZmY6ZmUxMDoxMTgw
IGRzdCAzMDAwOjoyNjg6ZWJmZjpmZTg1OjUzOWYNCglwcm90byBlc3Agc3BpIDB4MTNlMDAyMDQg
cmVxaWQgMzMzNDQ3Njg0IG1vZGUgdHJhbnNwb3J0DQoJcmVwbGF5LXdpbmRvdyAwIGZsYWcgYWxp
Z240DQoJYXV0aC10cnVuYyBobWFjKHNoYTEpIDB4ZDJjZGNmMDdjNTg5NDgyOTJiZGVkNmMzZTc5
N2VhNjIxNWFhMzdjOCA5Ng0KCWVuYyBjYmMoZGVzM19lZGUpIDB4YTJlNTBkNGRkNjQ2ZGQyMzUz
NmMzOTE4Mzk1NGQ5NzM4ZWJiNDk2NjI3YmQ2NGI4DQoJYW50aS1yZXBsYXkgZXNuIGNvbnRleHQ6
DQoJIHNlcS1oaSAweDAsIHNlcSAweDAsIG9zZXEtaGkgMHgwLCBvc2VxIDB4MA0KCSByZXBsYXlf
d2luZG93IDEyOCwgYml0bWFwLWxlbmd0aCA0DQoJIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAw
IDAwMDAwMDAwIA0KCXNlbCBzcmMgOjovMCBkc3QgOjovMCANCkV4cGlyZWQgc3JjIDMwMDE6OjIw
MDoxMGZmOmZlMTA6MTE4MCBkc3QgMzAwMDo6MjY4OmViZmY6ZmU4NTo1MzlmDQoJcHJvdG8gZXNw
IHNwaSAweDc3ZjJlYTFjIHJlcWlkIDIwMTI0MDgzNDggbW9kZSB0cmFuc3BvcnQNCglyZXBsYXkt
d2luZG93IDAgZmxhZyBhbGlnbjQNCglzZWwgc3JjIDo6LzAgZHN0IDo6LzAgDQoJaGFyZCAwDQpB
c3luYyBldmVudCAgKDB4MjApICB0aW1lciBleHBpcmVkIA0KCXNyYyAzMDAxOjoyMDA6MTBmZjpm
ZTEwOjExODAgZHN0IDMwMDA6OjI2ODplYmZmOmZlODU6NTM5ZiAgcmVxaWQgMHg3N2YyZWExYyBw
cm90b2NvbCBlc3AgIFNQSSAweDc3ZjJlYTFj
--_003_TU4PR8401MB121625D980E4FEF13345BD12F66A0TU4PR8401MB1216_
Content-Type: application/octet-stream; name="IPSEC_Conf_5_102.pcap"
Content-Description: IPSEC_Conf_5_102.pcap
Content-Disposition: attachment; filename="IPSEC_Conf_5_102.pcap"; size=2802;
	creation-date="Fri, 03 Jul 2020 03:35:07 GMT";
	modification-date="Mon, 29 Jun 2020 00:14:09 GMT"
Content-Transfer-Encoding: base64

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
bZlx+i28mNQB
--_003_TU4PR8401MB121625D980E4FEF13345BD12F66A0TU4PR8401MB1216_--

