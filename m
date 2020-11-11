Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3316C388F9
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Nov 2020 16:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5469D20756
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Nov 2020 16:54:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="nMxm8D5l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgKKQyG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Nov 2020 11:54:06 -0500
Received: from us-smtp-delivery-162.mimecast.com ([63.128.21.162]:24688 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725979AbgKKQyG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Nov 2020 11:54:06 -0500
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Nov 2020 11:54:04 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1605113644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cqdmt+N0hjMcPqzaNqax2fmW/EO1X9ZjdtLF9oyYhwM=;
        b=nMxm8D5l/3lcwFXqi/9x/BunJ4CBpJHnZWqpJ9/uTeBmZQ9hQgWKgKmh2YundXrIdFUafd
        WSlkZ7JaVaXomp/hE5P5ZuKRnejnTLj4Bv1FdZDaX3hhpH+x+5oXb5VZ8KKytCXznyKAW+
        U+vNj65EfjEsUDZ2EFCbrjL+GHIkkAc=
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-TL8vDY85P6aHbAYQoo23Rg-1; Wed, 11 Nov 2020 11:47:49 -0500
X-MC-Unique: TL8vDY85P6aHbAYQoo23Rg-1
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7712::13) by TU4PR8401MB0351.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7717::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 16:47:48 +0000
Received: from TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c03a:bba9:ff3a:ae3c]) by TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c03a:bba9:ff3a:ae3c%8]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 16:47:48 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Question of ESP failure when device receives Packet Too Big ICMPv6
 message
Thread-Topic: Question of ESP failure when device receives Packet Too Big
 ICMPv6 message
Thread-Index: Ada4SmAp9DMGJIC2RlyDCLYetrfJqw==
Date:   Wed, 11 Nov 2020 16:47:48 +0000
Message-ID: <TU4PR8401MB12164E982A4DF41593AAF1A9F6E80@TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [49.207.215.91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99150b30-d323-47ba-302b-08d88661857e
x-ms-traffictypediagnostic: TU4PR8401MB0351:
x-microsoft-antispam-prvs: <TU4PR8401MB035184D528F965E94DF05E11F6E80@TU4PR8401MB0351.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: vuZ2jf7N1IFD+rwlhiBwFxwk7f+kvCYaxCUcZip3v51aUxkfWP0imRrIpE/tA/Q9uUy3l5T1rS4OxzB44txPvjWV5LLJyBUmPrazpR1qIJ29bcs4JmPTpVmTDYd289fr7DGOMdS3DHmwhhrfyWG4OxJDA7olM4rQsVfy2P4vpYUKY5OrdjLYnAo2hsM9n5j2+0zhYfXogaOdtxyQbXI4RVNU7owb4FtOJvaoyf57XonNeaG+y2VbUMLy7aawo/cJcth2ORHC2KojtDJgrRG5LZFaqfuO61CTo2g65iKCx3DWa5BHcuJeA0JYr1tmPz0eZsyKcfUZmWpaa2cVgI/eGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39860400002)(366004)(396003)(7696005)(8676002)(52536014)(66946007)(6916009)(8936002)(9686003)(71200400001)(316002)(2906002)(26005)(76116006)(66556008)(186003)(64756008)(66446008)(55016002)(66476007)(66574015)(55236004)(5660300002)(83380400001)(15650500001)(6506007)(33656002)(86362001)(478600001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: 83qAOa72e0ET5cexBSfPS0h91UKDWy0e/OdoPz8u8FBHzTNd95LQu04loAqh/odwen2afGi2znNrD6/5IapePb3zaPU4B6VVj7L1PhxEVLOZZybfruqPo63I98849DQ+oFRHC68iGB3HktmwOaPEhfgO/e7R/uJoqu3WRJJE0H9x87rZNVG9MrSxNXwwhJTQIIlRKUBmv9p0CglDXa7ncqUvm49Eb4UeQtoxNpGu5O2Ja5/vA8Xx6s/xt5jkXzVOW+Vv3xa5WiYBzf3KmFuFh3NQdLmzx/pKEYsGvVsXWpq20qPdsnh5ec60mjMn6q/PBI3xvL7RWmLEdVeS45k/CjrJnuTklnnIZ4UemXEr3l3fvZKfoIBKrLdcI54TWq97M/MABZxaX2ptWbpZP+CIjQ360Y2nWXzlar3RyUkpyS7/CM5lRNvX0yOWOLrvQSu7uFR2UFt0LxMYlDNCnMzejm2z/zUGXt0hZ5vBYo1RC6W/k6FlZc3UBa3KVvMfT4hL8eZObyj/OKqU/cFqtI9i8QTuRCopu6IowSibl5mZPneSNhY33KR8AX2T6M0S89styruf0OKxw+WTl9CE04iP5Rs0mpX+sgPhpj8jFDS0lwTgTgBVX5KyNimgCq3v4oTkU2W05rqnLXlxKAPeLV5WKppfRGC8qcvkTin8qI9AaFpl+8wlfFR7Ow3B5YVfR669GwjnQyC/IBAobAdJE+E6VqYZX3p/XB0bZ5VrJ/v8oSmo92zYCngZgi4QlMgavGcUhVmUoZEmIPKUhs7L3jAUEAB+KaHNHkMOr293OomtimeU6gj+4TkuQxv9SBlfr835Fdw136DqjhR1Vyh7Q6NAodo2CrAN3HJUM8cLAA56MMkxRnBeRySFHL7sp2bJhZe8LuORgoMY/pLR6QMnxc8iUA==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TU4PR8401MB1216.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 99150b30-d323-47ba-302b-08d88661857e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2020 16:47:48.1255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AEZgiJqdp9wQm3d15C3X92d/BJg4mxG4+VicfmhIwRQvx1eVNEaeVj7bbgIx/W/vl5GVO4PbhdquFqe9v09kNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB0351
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

We have the below scenario. Devices are IPsec tunnel mode configured.   Ref=
 device  sends fragmented ping requests. Our device responds with unfragmen=
ted ping response. Router send packet too big with proposed MTU as 1280 and=
 payload
as ESP packet number 3.  As soon as our device receives the Packet Too Big =
ICMPv6 packet, device becomes unresponsive for the next ping request from r=
ef device. However our device is responding for ISAKMP informational messag=
es from the=20
ref device. Has anyone experience such issues.  Our device configuration ar=
e  Linux 4.9.180 #1 SMP PREEMPT Fri Oct 23 23:29:20 America 2020 aarch64 GN=
U/Linux. Any inputs are appreciated.

Our device =09=09Router=09=09Ref device=09=09=09PKt Num
<------------------------------=09|----------------=09Fragmented Ping Reque=
st=091  (ESP)
<------------------------------=09|----------------=09Fragmented Ping Reque=
st=092  (ESP)
--------------------------------=09|--------------->=09Unfragmented ping re=
sponse=093  (ESP
<------------------------------=09|=09=09=09=09=09=094  (non ESP)
  (Packet too big)
<------------------------------=09|----------------=09Fragmented Ping Reque=
st=095  (ESP)
<------------------------------=09|----------------=09Fragmented Ping Reque=
st=096  (ESP)


Regards,
Jayalakshmi

