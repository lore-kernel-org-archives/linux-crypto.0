Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE8CC433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 08:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F68C2220C
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 08:56:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="cU4vbUqh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgGHI4b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 04:56:31 -0400
Received: from us-smtp-delivery-148.mimecast.com ([216.205.24.148]:53554 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726144AbgGHI4a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 04:56:30 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jul 2020 04:56:29 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1594198588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XIwTan65lQ/nDIgvUsK1Bl1YxmHn2c7QVUkKFjOU9/c=;
        b=cU4vbUqhsToM+6ixHlIDNvRaG2zp/LEQ3/7UAwpUxxG/aRcRu/6j2fCuwaiQkfYAGTokHz
        885dql25yn2dyRL1sMb192RTcDS8JNtS1lTskhDYv3nJmYX47uaHHZ5l8smXYoBmBdOG3c
        2qeFKo9dh0qjAV3Wdv5LWvw4vqlI7Ms=
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-RILfvmhIN4Gt0jiMJLKoIw-1; Wed, 08 Jul 2020 04:50:19 -0400
X-MC-Unique: RILfvmhIN4Gt0jiMJLKoIw-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR0401MB3651.namprd04.prod.outlook.com
 (2603:10b6:910:8f::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24; Wed, 8 Jul
 2020 08:50:15 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::c5b1:ff88:4c39:34d8]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::c5b1:ff88:4c39:34d8%3]) with mapi id 15.20.3153.029; Wed, 8 Jul 2020
 08:50:15 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: question regarding crypto driver DMA issue
Thread-Topic: question regarding crypto driver DMA issue
Thread-Index: AdZVBDBo9ipAzqBdRAO9+tIch7rFqA==
Date:   Wed, 8 Jul 2020 08:50:15 +0000
Message-ID: <CY4PR0401MB3652172E295BA60CBDED9EE8C3670@CY4PR0401MB3652.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a506ca9-6af3-480d-ca2f-08d8231bef12
x-ms-traffictypediagnostic: CY4PR0401MB3651:
x-microsoft-antispam-prvs: <CY4PR0401MB36511110CFB12B87AE1ECAB8C3670@CY4PR0401MB3651.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MCknplI/mdRmEm/6VHnymbCL8osdx951UDghlYa6wb5eKS4UtiOKy0U1ZR0kNGmlpqa7gNxRgQba68qDo0B4LFMXslaYTZV1LDE3JYcKGvH6CWH9xG9XjLsh6/nBu2u+khJToMGuCCb5tawUTtOH1hscw47oGJw21t4h8lZ68YuajVG4pv443yu8LPdnwMgHYjDFKyWylpJM+8HlTwlitqvwla4XEYaTZy7hko+2NlR9NkEmodkdGDX4jPvL1EoHLHka9dsnXeCPKnN2Z2O4So7MLeUZ3L7I7ukMF3zYuKIbG2XghwjEo9ff3QQNXnNVhLyjYrPGm0hsnQZOAOFscg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(366004)(39850400004)(376002)(396003)(136003)(6506007)(66476007)(76116006)(66556008)(71200400001)(66946007)(2906002)(8676002)(64756008)(55016002)(6916009)(8936002)(316002)(52536014)(186003)(5660300002)(33656002)(26005)(9686003)(478600001)(66446008)(86362001)(83380400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: VGa+w7CnkQvfAq/4Y8PVnpJjkScovxVJJvXUyecta3rMpkITWRkKNROqPbGrOvQXOM2GVhnx+ZIvpaYH2JFZizi4S5LK92vfLtiIIivrvxJYj59m53irnrSM3cRiFJIK3lYS6aqvpTsucet0vGENyBBhkLfhTC7UIk1EchzkmnoNQlBpxwNcqKKkc0n2d7U1jTcCyijFE93BtJyCfXWmaiiNSRPtBrfO2J2ejGKO6CjJsQhXsgJJocmzlHWCb9ZTcui2L3K/pgaj4jNBxiZQV2oAcz0h3F6mWHJ8uRirBGdx80mJKRBP32tDfHSxvyMu1H7g/6zYNP5xyLXiHyo2iwvpntQxUxMOxIPLFC/8P79AJVgRHXiVBMeNuv0ABpDoFxLzVQ5YK8UkJO8YjNopIlcnzC7/ZzEN9DYo/lxmo9pdS1D1AnRT6KbcygszSEXm16KzD4Rbm2BJc/Y0BgiuW7RKHuLVK4xyBGtVpy26sfdc6FgwVBrJ8u0g8nbGc5Ql
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a506ca9-6af3-480d-ca2f-08d8231bef12
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 08:50:15.1362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FL4QcvIJiFqF7oKluSB/+kCgcfG9L5mdtFlV4ULelClo7NFJ0CCtZVK1ow5WF/bXOcDnrpNVZLte1/sEqSaQxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3651
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA48A24 smtp.mailfrom=pvanleeuwen@rambus.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: rambus.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I have a question on behalf of a customer of ours trying to use the inside-=
secure crypto
API driver. They are experiencing issues with result data not arriving in t=
he result buffer.
This seems to have something to do with not being able to DMA to said buffe=
r, as they
can workaround the issue by explicitly allocating a DMA buffer on the fly a=
nd copying
data from there to the original destination.

The problem I have is that I do not have access to their hardware and the d=
river seems
to work just fine on any hardware  (both x64 and ARM64) I have available he=
re, so I
have to approach this purely theoretically ...

For the situation where this problem is occuring, the actual buffers are st=
ored inside
the ahash_req structure. So my question is: is there any reason why this st=
ructure may
not be DMA-able on some systems? (as I have a hunch that may be the problem=
 ...)

Regards,
Pascal van Leeuwen
Silicon IP Architect Multi-Protocol Engines, Rambus Security
Rambus ROTW Holding BV
+31-73 6581953

Note: The Inside Secure/Verimatrix Silicon IP team was recently acquired by=
 Rambus.
Please be so kind to update your e-mail address book with my new e-mail add=
ress.


** This message and any attachments are for the sole use of the intended re=
cipient(s). It may contain information that is confidential and privileged.=
 If you are not the intended recipient of this message, you are prohibited =
from printing, copying, forwarding or saving it. Please delete the message =
and attachments and notify the sender immediately. **

Rambus Inc.<http://www.rambus.com>

