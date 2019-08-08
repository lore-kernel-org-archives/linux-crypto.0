Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127CEC433FF
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 18:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99CF22171F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 18:01:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="hZMX+R2L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732609AbfHHSB6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 14:01:58 -0400
Received: from mail-eopbgr60048.outbound.protection.outlook.com ([40.107.6.48]:63193
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728825AbfHHSB6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 14:01:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BY3KRnEvVvpd5UgD/eHj/34roG4rY8QtrzAloP08I2Lcimw0z6iwE2CIzEZnzsIqFbFNqxLNF0k0qHmXvhg69c/mtIvbuk6nlOm6gpraPDhs9s+avWjjjuFQJCFuwVuxlM0IAkIR7MH6Z6vAyGnpFneyMERn7G96xd1mdfv0NYOHkNGkLVJYVlxuXcBNT1GP40q3ENv95olRYVQmWyYrnyfUgwqyR8Qk5CKpT9lXGCk6vvXAzoNXgjsvjcwaIK6+pYnuxdbqwfiy4SZi9j7xM8W4adp+wD6xoPMrXYda5RwtA2QdQMpeVG5cZNDjsovbtkEyElAnB8oiRDWr3bL2Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5C9tncCs5myN4axKclR6KvBg3pfrGtLUML69yH3zwo=;
 b=L0ELHl/Di3q7mh4gdGm8vbbjX+SFgu1n87vrNPBPp2h9NxPR+4cB1RvWSqV8iL0LxWRtYhtXs7xQwCYE+I5LOOmiuiG7snwL0M1+uWZ3H7ZK5CtE5j14NNfUPnFzgYqCbQphIjMUEmPtIDawENSmgmuZ+ZiA3ChjxUnBRuWxmSXze0xd557ujT8DfEAHPTARaNeLfBEZJjrLBMumlolCUxq0TQWuvl1Hj6R7zkZXLUObTyaaoRBXWHc0t5iV010fXtf+8WBnPQNp1f2RC41ikkJk5J2szI0CExQ84jJkZUGVZ6tWQWxzR9GHr2Vv0m9jVdomDx8JG5c/odTnD9kjEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5C9tncCs5myN4axKclR6KvBg3pfrGtLUML69yH3zwo=;
 b=hZMX+R2LANPiM0twKM/+EfkMfmUc9Hd+tXDeGfMVzvHOJ0cP0P6YWJ12hEIKrxWEAXiWvws98IS4ZFpKlZUDKQYgsqJQW5vrAcF6xP0LwQWLRt2s+XTIlA7K+lxJ8cO7xkb2qdW4kDxxQcj0trY4f7mjJPXps+foRuwJNDdfTqM=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3392.eurprd04.prod.outlook.com (52.134.1.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 8 Aug 2019 18:01:49 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a070:859:ccf8:3617]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a070:859:ccf8:3617%7]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 18:01:49 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Milan Broz <gmazyland@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Topic: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDg==
Date:   Thu, 8 Aug 2019 18:01:49 +0000
Message-ID: <VI1PR0402MB3485689B4B65C879BC1D137398D70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190716221639.GA44406@gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
 <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <b042649c-db98-9710-b063-242bdf520252@gmail.com>
 <20190720065807.GA711@sol.localdomain>
 <0d4d6387-777c-bfd3-e54a-e7244fde0096@gmail.com>
 <CAKv+Gu9UF+a1UhVU19g1XcLaEqEaAwwkSm3-2wTHEAdD-q4mLQ@mail.gmail.com>
 <MN2PR20MB2973B9C2DDC508A81AF4A207CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
 <MN2PR20MB2973C378AE5674F9E3E29445CAC60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-8n_DoauycDQS_9zzRew1rTuPaLxHyg6xhXMmqEvMaCA@mail.gmail.com>
 <MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
 <MN2PR20MB29739591E1A3E54E7A8A8E18CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20f4832e-e3af-e3c2-d946-13bf8c367a60@nxp.com>
 <VI1PR0402MB34856F03FCE57AB62FC2257998D40@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <MN2PR20MB2973127E4C159A8F5CFDD0C9CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [82.137.9.55]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f4376e8-9ac0-4d54-2e93-08d71c2a7c4b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3392;
x-ms-traffictypediagnostic: VI1PR0402MB3392:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <VI1PR0402MB339226FC2D1322351380439698D70@VI1PR0402MB3392.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1079;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(199004)(189003)(4326008)(74316002)(52536014)(33656002)(5660300002)(478600001)(110136005)(6116002)(316002)(54906003)(30864003)(14454004)(99286004)(81156014)(66066001)(8676002)(7736002)(71200400001)(229853002)(81166006)(966005)(3846002)(305945005)(71190400001)(2906002)(86362001)(44832011)(186003)(476003)(53936002)(486006)(6306002)(8936002)(6436002)(55016002)(26005)(9686003)(64756008)(25786009)(446003)(6246003)(66946007)(91956017)(6506007)(14444005)(66446008)(53546011)(76116006)(76176011)(66556008)(7696005)(45080400002)(66476007)(102836004)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3392;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OwwW2AObu0bEdBZigQIITGqE1jYcPFpvgMBS+8PxHRfxCCG/lmS+iKBk7hYWA8CrKPDByi5DCDoIkz7eCHbQ0MdQCUtPzEPSOBREYQ1qb/bUEABVsFLYWtLtLGfOyQeBrX/oRldZkhQ272ptjzL7OqCp3nDL4QKWnExMqkng3M4I2vjnLMx9WntNAoup37SyrhWW+6kxmrglwTieDAXclWhktSe2kzLn+guNYOXlKEZ6Tv6fVRtVkTapwX7BW/Oawy01KRA28yy4fBGNjL+FGoX1WFiTpPaDqqpe2Zb5GeSIZHBfLFD7dczw7yNNNVv1apvWHEyn/kuzOcWYJc2Knnr3SgHeSCsxJq+9JrezRQuTkNYq1ZDIO8Zlr+cxCiL/do0CwT1jq0W+xi+rSI9oo43Ml5o1Q1y1VEUyfjOYqBc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f4376e8-9ac0-4d54-2e93-08d71c2a7c4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 18:01:49.4041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qRAGpy/c4casTlx5Y7QU2hIQSNxuW93ploOus38xb7Ne1Ax+k1x5nggD8a/uelhY99DpuyNGFVKsRBizOXPrxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3392
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/8/2019 4:43 PM, Pascal Van Leeuwen wrote:=0A=
> Hi Horia,=0A=
> =0A=
> This is the best I can do on short notice w.r.t vectors with 8 byte IV.=
=0A=
> Format is actually equivalent to that of the XTS specification, with=0A=
> the sector number being referred to as "H".=0A=
> =0A=
> Actually, the input keys, plaintext and IV should be the same as before,=
=0A=
> with the exception of the IV being truncated to 64 bits, so that should=
=0A=
> give you some reference regarding byte order etc.=0A=
> =0A=
Thanks.=0A=
=0A=
I've converted the test vectors and generated patch below,=0A=
which is based on a previous patch you've sent:=0A=
https://lore.kernel.org/linux-crypto/MN2PR20MB29739591E1A3E54E7A8A8E18CAC00=
@MN2PR20MB2973.namprd20.prod.outlook.com/=0A=
=0A=
-- >8 --=0A=
=0A=
Subject: [PATCH] crypto: testmgr - Add additional AES-XTS vectors for cover=
ing=0A=
 CTS (part II)=0A=
=0A=
Add more test vectors (provided by Pascal Van Leeuwen)=0A=
for xts ciphertext stealing checking.=0A=
=0A=
They are derived from the test vectors added in=0A=
commit "crypto: testmgr - Add additional AES-XTS vectors for covering CTS"=
=0A=
where IV / tweak was truncated to 8 bytes (and obviously=0A=
different ciphertext).=0A=
=0A=
Link: https://lore.kernel.org/linux-crypto/MN2PR20MB2973127E4C159A8F5CFDD0C=
9CAD70@MN2PR20MB2973.namprd20.prod.outlook.com=0A=
Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
---=0A=
 crypto/testmgr.h | 310 ++++++++++++++++++++++++++++++++++++++++++++++-=0A=
 1 file changed, 309 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/crypto/testmgr.h b/crypto/testmgr.h=0A=
index 717b9fcb9bfa..453bb6473f13 100644=0A=
--- a/crypto/testmgr.h=0A=
+++ b/crypto/testmgr.h=0A=
@@ -15351,7 +15351,315 @@ static const struct cipher_testvec aes_xts_tv_tem=
plate[] =3D {=0A=
 			  "\x7b\xe3\xf6\x61\x71\xc7\xc5\xc2"=0A=
 			  "\xed\xbf\x9d\xac",=0A=
 		.len	=3D 20,=0A=
-	/* Additional vectors to increase CTS coverage */=0A=
+	/* Additional vectors to increase CTS coverage - 8B IV */=0A=
+	}, { /* 1 block + 21 bytes */=0A=
+		.key    =3D "\xa1\x34\x0e\x49\x38\xfd\x8b\xf6"=0A=
+			  "\x45\x60\x67\x07\x0f\x50\xa8\x2b"=0A=
+			  "\xa8\xf1\xfe\x7e\xf4\xf0\x47\xcd"=0A=
+			  "\xfd\x91\x78\xf9\x14\x8b\x7d\x27"=0A=
+			  "\x0e\xdc\xca\xe6\xf4\xfc\xd7\x4f"=0A=
+			  "\x19\x8c\xd0\xe6\x9e\x2f\xf8\x75"=0A=
+			  "\xb5\xe2\x48\x00\x4f\x07\xd9\xa1"=0A=
+			  "\x42\xbc\x9d\xfc\x17\x98\x00\x48",=0A=
+		.klen   =3D 64,=0A=
+		.iv     =3D "\xcb\x35\x47\x5a\x7a\x06\x28\xb9"=0A=
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",=0A=
+		.ptext	=3D "\x04\x52\xc8\x7f\xb0\x5a\x12\xc5"=0A=
+			  "\x96\x47\x6b\xf4\xbc\x2e\xdb\x74"=0A=
+			  "\xd2\x20\x24\x32\xe5\x84\xb6\x25"=0A=
+			  "\x4c\x2f\x96\xc7\x55\x9c\x90\x6f"=0A=
+			  "\x0e\x96\x94\x68\xf4",=0A=
+		.ctext	=3D "\x73\xfa\x69\x0b\x1c\x21\x3a\x61"=0A=
+			  "\x83\x88\x5e\x57\xe3\xf2\x79\x1f"=0A=
+			  "\x6a\x64\x79\xff\xa2\xaa\xf2\x70"=0A=
+			  "\x67\xf5\x06\xf9\x48\xb2\x96\xa4"=0A=
+			  "\xd7\xd5\x48\x26\xc9",=0A=
+		.len	=3D 37,=0A=
+	}, { /* 3 blocks + 22 bytes */=0A=
+		.key    =3D "\xf7\x87\x75\xdf\x36\x20\xe7\xcb"=0A=
+			  "\x20\x5d\x49\x96\x81\x3d\x1d\x80"=0A=
+			  "\xc7\x18\x7e\xbf\x2a\x0f\x79\xba"=0A=
+			  "\x06\xb5\x4b\x63\x03\xfb\xb8\x49"=0A=
+			  "\x93\x2d\x85\x5b\x95\x1f\x78\xea"=0A=
+			  "\x7c\x1e\xf5\x5d\x02\xc6\xec\xb0"=0A=
+			  "\xf0\xaa\x3d\x0a\x04\xe1\x67\x80"=0A=
+			  "\x2a\xbe\x4e\x73\xc9\x11\xcc\x6c",=0A=
+		.klen   =3D 64,=0A=
+		.iv     =3D "\xeb\xba\x55\x24\xfc\x8f\x25\x7c"=0A=
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",=0A=
+		.ptext	=3D "\x40\x75\x1b\x72\x2a\xc8\xbf\xef"=0A=
+			  "\x0c\x92\x3e\x19\xc5\x09\x07\x38"=0A=
+			  "\x4d\x87\x5c\xb8\xd6\x4f\x1a\x39"=0A=
+			  "\x8c\xee\xa5\x22\x41\x12\xe1\x22"=0A=
+			  "\xb5\x4b\xd7\xeb\x02\xfa\xaa\xf8"=0A=
+			  "\x94\x47\x04\x5d\x8a\xb5\x40\x12"=0A=
+			  "\x04\x62\x3d\xe4\x19\x8a\xeb\xb3"=0A=
+			  "\xf9\xa3\x7d\xb6\xeb\x57\xf9\xb8"=0A=
+			  "\x7f\xa8\xfa\x2d\x75\x2d",=0A=
+		.ctext	=3D "\xe6\x9e\x4b\x1b\x27\xf7\xc0\x0b"=0A=
+			  "\xf9\x39\xa6\xfa\x42\x51\x4b\x4f"=0A=
+			  "\x72\xba\xee\xbf\x3a\xe6\x97\x21"=0A=
+			  "\x64\x29\xcd\x30\xae\x38\x66\xca"=0A=
+			  "\x2b\xff\x1d\xf3\xd5\x3d\xe1\xf5"=0A=
+			  "\xa9\x8b\x7a\x3a\xda\x11\x13\x71"=0A=
+			  "\x2c\x1e\xd3\x2b\x43\x73\x53\x3b"=0A=
+			  "\x6f\xc7\xfd\xfc\x1f\x59\x9e\x99"=0A=
+			  "\x39\x90\x42\xcd\x0c\x38",=0A=
+		.len	=3D 70,=0A=
+	}, { /* 4 blocks + 23 bytes */=0A=
+		.key    =3D "\x48\x09\xab\x48\xd6\xca\x7d\xb1"=0A=
+			  "\x90\xa0\x00\xd8\x33\x8a\x20\x79"=0A=
+			  "\x7c\xbc\x0c\x0c\x5f\x41\xbc\xbc"=0A=
+			  "\x82\xaf\x41\x81\x23\x93\xcb\xc7"=0A=
+			  "\x61\x7b\x83\x13\x16\xb1\x3e\x7c"=0A=
+			  "\xcc\xae\xda\xca\x78\xc7\xab\x18"=0A=
+			  "\x69\xb6\x58\x3e\x5c\x19\x5f\xed"=0A=
+			  "\x7b\xcf\x70\xb9\x76\x00\xd8\xc9",=0A=
+		.klen   =3D 64,=0A=
+		.iv     =3D "\x2e\x20\x36\xf4\xa3\x22\x5d\xd8"=0A=
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",=0A=
+		.ptext	=3D "\x79\x3c\x73\x99\x65\x21\xe1\xb9"=0A=
+			  "\xa0\xfd\x22\xb2\x57\xc0\x7f\xf4"=0A=
+			  "\x7f\x97\x36\xaf\xf8\x8d\x73\xe1"=0A=
+			  "\x0d\x85\xe9\xd5\x3d\x82\xb3\x49"=0A=
+			  "\x89\x25\x30\x1f\x0d\xca\x5c\x95"=0A=
+			  "\x64\x31\x02\x17\x11\x08\x8f\x32"=0A=
+			  "\xbc\x37\x23\x4f\x03\x98\x91\x4a"=0A=
+			  "\x50\xe2\x58\xa8\x9b\x64\x09\xe0"=0A=
+			  "\xce\x99\xc9\xb0\xa8\x21\x73\xb7"=0A=
+			  "\x2d\x4b\x19\xba\x81\x83\x99\xce"=0A=
+			  "\xa0\x7a\xd0\x9f\x27\xf6\x8a",=0A=
+		.ctext	=3D "\x1a\x87\x62\x2b\x05\x09\x5e\x06"=0A=
+			  "\x94\x16\xd1\xa5\xae\xd8\x34\x86"=0A=
+			  "\x1f\x12\x80\xef\xb9\x7c\x00\x7f"=0A=
+			  "\xf8\xda\x89\xd1\x85\x0c\x0f\x79"=0A=
+			  "\x14\x96\x9a\x54\x5c\x0f\x11\xe1"=0A=
+			  "\xd8\x2b\x20\x28\xb8\xe5\x8b\x73"=0A=
+			  "\x83\x90\xb3\xc6\x1e\x00\x07\x22"=0A=
+			  "\x8b\xc8\x0c\x5a\x1d\x74\xf1\xfc"=0A=
+			  "\x31\xfd\x80\xdb\xfd\x63\xc8\xd8"=0A=
+			  "\x80\x27\xcc\xb6\x3b\x70\x58\xc2"=0A=
+			  "\xef\x52\x59\x4d\xe4\x9e\x4e",=0A=
+		.len	=3D 87,=0A=
+	}, { /* 5 blocks + 24 bytes */=0A=
+		.key    =3D "\x8c\xf4\x4c\xe5\x91\x8f\x72\xe9"=0A=
+			  "\x2f\xf8\xc0\x3c\x87\x76\x16\xa4"=0A=
+			  "\x20\xab\x66\x39\x34\x10\xd6\x91"=0A=
+			  "\xf1\x99\x2c\xf1\xd6\xc3\xda\x38"=0A=
+			  "\xed\x2a\x4c\x80\xf4\xa5\x56\x28"=0A=
+			  "\x1a\x1c\x79\x72\x6c\x93\x08\x86"=0A=
+			  "\x8f\x8a\xaa\xcd\xf1\x8c\xca\xe7"=0A=
+			  "\x0a\xe8\xee\x0c\x1c\xc2\xa8\xea",=0A=
+		.klen   =3D 64,=0A=
+		.iv     =3D "\x9a\x9e\xbc\xe4\xc9\xf3\xef\x9f"=0A=
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",=0A=
+		.ptext	=3D "\xc1\xde\x66\x1a\x7e\x60\xd3\x3b"=0A=
+			  "\x66\xd6\x29\x86\x99\xc6\xd7\xc8"=0A=
+			  "\x29\xbf\x00\x57\xab\x21\x06\x24"=0A=
+			  "\xd0\x92\xef\xe6\xb5\x1e\x20\xb9"=0A=
+			  "\xb7\x7b\xd7\x18\x88\xf8\xd7\xe3"=0A=
+			  "\x90\x61\xcd\x73\x2b\xa1\xb5\xc7"=0A=
+			  "\x33\xef\xb5\xf2\x45\xf6\x92\x53"=0A=
+			  "\x91\x98\xf8\x5a\x20\x75\x4c\xa8"=0A=
+			  "\xf1\xf6\x01\x26\xbc\xba\x4c\xac"=0A=
+			  "\xcb\xc2\x6d\xb6\x2c\x3c\x38\x61"=0A=
+			  "\xe3\x98\x7f\x3e\x98\xbd\xec\xce"=0A=
+			  "\xc0\xb5\x74\x23\x43\x24\x7b\x7e"=0A=
+			  "\x3f\xed\xcb\xda\x88\x67\x6f\x9a",=0A=
+		.ctext	=3D "\xe5\xb4\x02\xac\x01\x3b\xa8\x73"=0A=
+			  "\x9e\x5b\xa4\x72\x9e\x41\x85\x0f"=0A=
+			  "\x60\x13\x6b\xc5\x7e\xdd\x32\x9c"=0A=
+			  "\x2f\x95\x5e\x95\x3e\xbc\x7a\x65"=0A=
+			  "\x1c\xf6\x0d\x61\x58\x87\x1e\xff"=0A=
+			  "\x96\xb8\x01\x86\x5f\xe2\x36\x84"=0A=
+			  "\x61\xf3\x99\x2c\x06\x8d\x00\xc3"=0A=
+			  "\xef\x07\xf5\x24\xf7\x6d\xac\x11"=0A=
+			  "\x0d\x40\x1f\xe7\x94\xcd\x02\x3e"=0A=
+			  "\xd2\xd8\x67\x71\x08\xad\x8c\x71"=0A=
+			  "\xac\x21\xc7\x09\x92\x3c\x59\xd8"=0A=
+			  "\x91\xfb\x43\xf2\x2a\x67\xca\x97"=0A=
+			  "\x3c\xc3\x78\x44\xa9\x90\xd8\x4b",=0A=
+		.len	=3D 104,=0A=
+	}, { /* 8 blocks + 25 bytes */=0A=
+		.key    =3D "\x70\x18\x09\x93\x10\x3a\x0c\xa9"=0A=
+			  "\x02\x0b\x11\x10\xae\x34\x98\xdb"=0A=
+			  "\x10\xb5\xee\x8c\x49\xbc\x52\x8e"=0A=
+			  "\x4b\xf7\x0a\x36\x16\x8a\xf7\x06"=0A=
+			  "\xb5\x94\x52\x54\xb9\xc1\x4d\x20"=0A=
+			  "\xa2\xf0\x6e\x19\x7f\x67\x1e\xaa"=0A=
+			  "\x94\x6c\xee\x54\x19\xfc\x96\x95"=0A=
+			  "\x04\x85\x00\x53\x7c\x39\x5f\xeb",=0A=
+		.klen   =3D 64,=0A=
+		.iv     =3D "\x36\x87\x8f\x9d\x74\xe9\x52\xfb"=0A=
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",=0A=
+		.ptext	=3D "\x95\x08\xee\xfe\x87\xb2\x4f\x93"=0A=
+			  "\x01\xee\xf3\x77\x0d\xbb\xfb\x26"=0A=
+			  "\x3e\xb3\x34\x20\xee\x51\xd6\x40"=0A=
+			  "\xb1\x64\xae\xd9\xfd\x71\x8f\x93"=0A=
+			  "\xa5\x85\xff\x74\xcc\xd3\xfd\x5e"=0A=
+			  "\xc2\xfc\x49\xda\xa8\x3a\x94\x29"=0A=
+			  "\xa2\x59\x90\x34\x26\xbb\xa0\x34"=0A=
+			  "\x5d\x47\x33\xf2\xa8\x77\x90\x98"=0A=
+			  "\x8d\xfd\x38\x60\x23\x1e\x50\xa1"=0A=
+			  "\x67\x4d\x8d\x09\xe0\x7d\x30\xe3"=0A=
+			  "\xdd\x39\x91\xd4\x70\x68\xbb\x06"=0A=
+			  "\x4e\x11\xb2\x26\x0a\x85\x73\xf6"=0A=
+			  "\x37\xb6\x15\xd0\x77\xee\x43\x7b"=0A=
+			  "\x77\x13\xe9\xb9\x84\x2b\x34\xab"=0A=
+			  "\x49\xc1\x27\x91\x2e\xa3\xca\xe5"=0A=
+			  "\xa7\x79\x45\xba\x36\x97\x49\x44"=0A=
+			  "\xf7\x57\x9b\xd7\xac\xb3\xfd\x6a"=0A=
+			  "\x1c\xd1\xfc\x1c\xdf\x6f\x94\xac"=0A=
+			  "\x95\xf4\x50\x7a\xc8\xc3\x8c\x60"=0A=
+			  "\x3c",=0A=
+		.ctext	=3D "\x91\xe5\x35\xf2\x72\xcc\x15\xbb"=0A=
+			  "\x2e\xa3\x6d\x80\x25\xad\xb2\x14"=0A=
+			  "\x3e\x0e\xb8\x33\x68\xc6\xc0\x3f"=0A=
+			  "\x21\x2b\x02\xbc\x90\x97\xee\xf0"=0A=
+			  "\x72\x0b\xa9\x5e\xfc\x95\xaf\x30"=0A=
+			  "\x14\x5c\x83\xed\x97\x4f\xda\x61"=0A=
+			  "\xf3\x53\xff\x6f\xcd\x0a\xb3\xf5"=0A=
+			  "\x5f\xdd\x46\xa9\xf0\x8a\x5a\x8b"=0A=
+			  "\xeb\x99\x2a\x07\x9f\x16\x49\xa9"=0A=
+			  "\xbe\x4e\x3b\x93\xa3\xbe\x17\xa1"=0A=
+			  "\xa3\x51\x87\x49\x25\x94\x27\x8e"=0A=
+			  "\x49\x38\x7b\xfb\xe4\xaa\x6a\xb9"=0A=
+			  "\x85\xa2\x3a\xa3\x0e\x8c\x0d\x03"=0A=
+			  "\xa2\xbf\xe4\x7d\x71\x1b\x4b\x4f"=0A=
+			  "\xae\x4e\xbd\xff\x94\xee\x22\xbc"=0A=
+			  "\xb9\x47\x0e\x7c\x2c\xd4\xa8\xb5"=0A=
+			  "\xe2\xaa\xa9\xbf\xe7\xad\xdc\x69"=0A=
+			  "\xfa\x51\x95\x0b\x90\x10\x53\xcb"=0A=
+			  "\xc4\x8b\xc9\xcf\xec\x0e\xc6\xc3"=0A=
+			  "\x4f",=0A=
+		.len	=3D 153,=0A=
+	}, { /* 0 blocks + 26 bytes */=0A=
+		.key    =3D "\x5a\x38\x3f\x9c\x0c\x53\x17\x6c"=0A=
+			  "\x60\x72\x23\x26\xba\xfe\xa1\xb7"=0A=
+			  "\x03\xa8\xfe\xa0\x7c\xff\x78\x4c"=0A=
+			  "\x7d\x84\x2f\x24\x84\x77\xec\x6f"=0A=
+			  "\x88\xc8\x36\xe2\xcb\x52\x3c\xb4"=0A=
+			  "\x39\xac\x37\xfa\x41\x8b\xc4\x59"=0A=
+			  "\x24\x03\xe1\x51\xc9\x54\x7d\xb7"=0A=
+			  "\xa3\xde\x91\x44\x8d\x16\x97\x22",=0A=
+		.klen   =3D 64,=0A=
+		.iv     =3D "\xfb\x7f\x3d\x60\x26\x0a\x3a\x3d"=0A=
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",=0A=
+		.ptext	=3D "\xfb\x56\x97\x65\x7c\xd8\x6c\x3c"=0A=
+			  "\x5d\xd3\xea\xa6\xa4\x83\xf7\x9d"=0A=
+			  "\x9d\x89\x2c\x85\xb8\xd9\xd4\xf0"=0A=
+			  "\x1a\xad",=0A=
+		.ctext	=3D "\x76\x4f\x62\x8f\x46\x50\x93\xdc"=0A=
+			  "\xee\xb2\x92\x00\x48\x58\x0f\x0b"=0A=
+			  "\xb0\x47\xb9\x70\x1a\xa3\x81\x19"=0A=
+			  "\x34\xef",=0A=
+		.len	=3D 26,=0A=
+	}, { /* 0 blocks + 27 bytes */=0A=
+		.key    =3D "\xc0\xcf\x57\xa2\x3c\xa2\x4b\xf6"=0A=
+			  "\x5d\x36\x7b\xd7\x1d\x16\xc3\x2f"=0A=
+			  "\x50\xc6\x0a\xb2\xfd\xe8\x24\xfc"=0A=
+			  "\x33\xcf\x73\xfd\xe0\xe9\xa5\xd1"=0A=
+			  "\x98\xfc\xd6\x16\xdd\xfd\x6d\xab"=0A=
+			  "\x44\xbc\x37\x9d\xab\x5b\x1d\xf2"=0A=
+			  "\x6f\x5d\xbe\x6b\x14\x14\xc7\x74"=0A=
+			  "\xbb\x91\x24\x4b\x52\xcb\x78\x31",=0A=
+		.klen   =3D 64,=0A=
+		.iv     =3D "\x5c\xc1\x3d\xb6\xa1\x6a\x2d\x1f"=0A=
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",=0A=
+		.ptext	=3D "\x02\x95\x3a\xab\xac\x3b\xcd\xcd"=0A=
+			  "\x63\xc7\x4c\x7c\xe5\x75\xee\x03"=0A=
+			  "\x94\xc7\xff\xe8\xe0\xe9\x86\x2a"=0A=
+			  "\xd3\xc7\xe4",=0A=
+		.ctext	=3D "\xd5\x08\x32\x1a\x5d\x93\xbc\x62"=0A=
+			  "\xd6\x1e\xc4\x8f\x42\x12\xe3\xc1"=0A=
+			  "\x0e\xb5\x99\x0c\x6b\x64\x1c\x40"=0A=
+			  "\xe3\x0f\x4f",=0A=
+		.len	=3D 27,=0A=
+	}, { /* 0 blocks + 28 bytes */=0A=
+		.key    =3D "\x0b\x5b\x1d\xc8\xb1\x3f\x8f\xcd"=0A=
+			  "\x87\xd2\x58\x28\x36\xc6\x34\xfb"=0A=
+			  "\x04\xe8\xf1\xb7\x91\x30\xda\x75"=0A=
+			  "\x66\x4a\x72\x90\x09\x39\x02\x19"=0A=
+			  "\x62\x2d\xe9\x24\x95\x0e\x87\x43"=0A=
+			  "\x4c\xc7\x96\xe4\xc9\x31\x6a\x13"=0A=
+			  "\x16\x10\xef\x34\x9b\x98\x19\xf1"=0A=
+			  "\x8b\x14\x38\x3f\xf8\x75\xcc\x76",=0A=
+		.klen   =3D 64,=0A=
+		.iv     =3D "\x0c\x2c\x55\x2c\xda\x40\xe1\xab"=0A=
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",=0A=
+		.ptext	=3D "\xbe\x84\xd3\xfe\xe6\xb4\x29\x67"=0A=
+			  "\xfd\x29\x78\x41\x3d\xe9\x81\x4e"=0A=
+			  "\x3c\xf9\xf4\xf5\x3f\xd8\x0e\xcd"=0A=
+			  "\x63\x73\x65\xf3",=0A=
+		.ctext	=3D "\x5c\xa1\x21\x53\x96\xdc\xeb\x13"=0A=
+			  "\xf9\x91\x31\x8a\x65\xc6\x32\x4f"=0A=
+			  "\xea\xa6\x3e\x70\xd2\xfa\x37\xcf"=0A=
+			  "\x9b\xcb\xc3\x4a",=0A=
+		.len	=3D 28,=0A=
+	}, { /* 0 blocks + 29 bytes */=0A=
+		.key    =3D "\xdc\x4c\xdc\x20\xb1\x34\x89\xa4"=0A=
+			  "\xd0\xb6\x77\x05\xea\x0c\xcc\x68"=0A=
+			  "\xb1\xd6\xf7\xfd\xa7\x0a\x5b\x81"=0A=
+			  "\x2d\x4d\xa3\x65\xd0\xab\xa1\x02"=0A=
+			  "\x85\x4b\x33\xea\x51\x16\x50\x12"=0A=
+			  "\x3b\x25\xba\x13\xba\x7c\xbb\x3a"=0A=
+			  "\xe4\xfd\xb3\x9c\x88\x8b\xb8\x30"=0A=
+			  "\x7a\x97\xcf\x95\x5d\x69\x7b\x1d",=0A=
+		.klen   =3D 64,=0A=
+		.iv     =3D "\xe7\x69\xed\xd2\x54\x5d\x4a\x29"=0A=
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",=0A=
+		.ptext	=3D "\x37\x22\x11\x62\xa0\x74\x92\x62"=0A=
+			  "\x40\x4e\x2b\x0a\x8b\xab\xd8\x28"=0A=
+			  "\x8a\xd2\xeb\xa5\x8e\xe1\x42\xc8"=0A=
+			  "\x49\xef\x9a\xec\x1b",=0A=
+		.ctext	=3D "\x51\x64\x9d\x92\x46\x64\xe1\xc6"=0A=
+			  "\xb7\x38\x26\x2b\x74\x14\x24\x3d"=0A=
+			  "\xba\x17\xc4\x8f\x72\xc2\xa4\x01"=0A=
+			  "\x39\x48\x19\x74\x69",=0A=
+		.len	=3D 29,=0A=
+	}, { /* 0 blocks + 30 bytes */=0A=
+		.key    =3D "\x72\x9a\xf5\x53\x55\xdd\x0f\xef"=0A=
+			  "\xfc\x75\x6f\x03\x88\xc8\xba\x88"=0A=
+			  "\xb7\x65\x89\x5d\x03\x86\x21\x22"=0A=
+			  "\xb8\x42\x87\xd9\xa9\x83\x9e\x9c"=0A=
+			  "\xca\x28\xa1\xd2\xb6\xd0\xa6\x6c"=0A=
+			  "\xf8\x57\x42\x7c\x73\xfc\x7b\x0a"=0A=
+			  "\xbc\x3c\x57\x7b\x5a\x39\x61\x55"=0A=
+			  "\xb7\x25\xe9\xf1\xc4\xbb\x04\x28",=0A=
+		.klen   =3D 64,=0A=
+		.iv     =3D "\x8a\x38\x22\xba\xea\x5e\x1d\xa4"=0A=
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",=0A=
+		.ptext	=3D "\x06\xfd\xbb\xa9\x2e\x56\x05\x5f"=0A=
+			  "\xf2\xa7\x36\x76\x26\xd3\xb3\x49"=0A=
+			  "\x7c\xe2\xe3\xbe\x1f\x65\xd2\x17"=0A=
+			  "\x65\xe2\xb3\x0e\xb1\x93",=0A=
+		.ctext	=3D "\x85\x83\xe0\x8c\x0a\x4e\x68\xb1"=0A=
+			  "\xe4\x3f\x64\x03\x0b\xf8\x72\x76"=0A=
+			  "\xdd\x9e\xe0\x92\xe6\xed\x7e\xfd"=0A=
+			  "\xdd\x86\x48\xb1\x8e\x2d",=0A=
+		.len	=3D 30,=0A=
+	}, { /* 0 blocks + 31 bytes */=0A=
+		.key    =3D "\xce\x06\x45\x53\x25\x81\xd2\xb2"=0A=
+			  "\xdd\xc9\x57\xfe\xbb\xf6\x83\x07"=0A=
+			  "\x28\xd8\x2a\xff\x53\xf8\x57\xc6"=0A=
+			  "\x63\x50\xd4\x3e\x2a\x54\x37\x51"=0A=
+			  "\x07\x3b\x23\x63\x3c\x31\x57\x0d"=0A=
+			  "\xd3\x59\x20\xf2\xd0\x85\xac\xc5"=0A=
+			  "\x3f\xa1\x74\x90\x0a\x3f\xf4\x10"=0A=
+			  "\x12\xf0\x1b\x2b\xef\xcb\x86\x74",=0A=
+		.klen   =3D 64,=0A=
+		.iv     =3D "\x6d\x3e\x62\x94\x75\x43\x74\xea"=0A=
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",=0A=
+		.ptext	=3D "\x6a\xe6\xa3\x66\x7e\x78\xef\x42"=0A=
+			  "\x8b\x28\x08\x24\xda\xd4\xd6\x42"=0A=
+			  "\x3d\xb6\x48\x7e\x51\xa6\x92\x65"=0A=
+			  "\x98\x86\x26\x98\x37\x42\xa5",=0A=
+		.ctext	=3D "\x84\x4b\x14\x1f\x8e\xbc\xed\xe3"=0A=
+			  "\x95\x08\x7d\x6e\x5b\x62\xf9\xbe"=0A=
+			  "\x82\x08\x5d\xa2\xfe\xac\x39\xf3"=0A=
+			  "\x05\xfa\x24\x78\xf3\x96\x6e",=0A=
+		.len	=3D 31,=0A=
+	/* Additional vectors to increase CTS coverage - 16B IV */=0A=
 	}, { /* 1 block + 21 bytes */=0A=
 		.key    =3D "\xa1\x34\x0e\x49\x38\xfd\x8b\xf6"=0A=
 			  "\x45\x60\x67\x07\x0f\x50\xa8\x2b"=0A=
-- =0A=
2.17.1=0A=
