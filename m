Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F412AC4649B
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 15:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C919421738
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 15:04:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="Gb3puUq9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbfGEPEo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 11:04:44 -0400
Received: from mail-eopbgr780051.outbound.protection.outlook.com ([40.107.78.51]:36864
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726005AbfGEPEo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 11:04:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iI68zIzLbWWSx25PI0HybUHFZcGdWH3U2YlyfcSK64M=;
 b=Gb3puUq9PVL3go1wRf8MsPCkSKf6RePeSfjuBM3Z0JPtBxiRkSv+HRHxvoXjfS0Dc3jv3/gvStyIHfjdxNohThkaNyMJ/tdDJ5CpG9tLK4RJkgPWBjWn9JqOPM/5AkoD17mWn/OJyWbTSz0rNG2g0N8IZxtQ9uwyoXCKM94AmZ8=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2959.namprd20.prod.outlook.com (52.132.172.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Fri, 5 Jul 2019 15:04:43 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2052.019; Fri, 5 Jul 2019
 15:04:43 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>
Subject: FW: skcipher and aead API question
Thread-Topic: skcipher and aead API question
Thread-Index: AdUzFZSC+g/TbhjQSoOcPg+7Aq6e8gAG+c8AAANZNuwAAL80AAAARBSA
Date:   Fri, 5 Jul 2019 15:04:42 +0000
Message-ID: <MN2PR20MB2973A20FC684AB0B994FED1DCAF50@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <BY5PR20MB296261AC5E07B6E7E2B7E6A9CAF50@BY5PR20MB2962.namprd20.prod.outlook.com>
 <20190705125930.7idte7awvhixvsnc@gondor.apana.org.au>
 <MN2PR20MB29733314C9338A20E587AF3ACAF50@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190705143516.s2ynxaej4qzfj4md@gondor.apana.org.au> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47a1d974-6773-4154-1828-08d7015a1c6a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2959;
x-ms-traffictypediagnostic: MN2PR20MB2959:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2959720B261434990AB9AD9FCAF50@MN2PR20MB2959.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 008960E8EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(346002)(376002)(366004)(136003)(199004)(189003)(81156014)(76176011)(52536014)(81166006)(476003)(8676002)(446003)(4326008)(99286004)(15974865002)(71190400001)(86362001)(14454004)(71200400001)(229853002)(53936002)(55016002)(68736007)(74316002)(5640700003)(305945005)(7736002)(2473003)(256004)(6436002)(9686003)(6916009)(2906002)(66066001)(33656002)(2351001)(2501003)(186003)(26005)(5660300002)(6506007)(7696005)(316002)(478600001)(486006)(25786009)(8936002)(3846002)(6116002)(66476007)(66446008)(66556008)(102836004)(64756008)(66946007)(73956011)(76116006)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2959;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fR5B1upVDDBABGxUlmWR8deEmIOb4WOsRatfFfnTEEtF/b2jGo6ELeAOqsxORWL/mzxuWqbq4VFODRirteuKD3Umx2ITAzRuT439Ky6vWcSeGEYpDD2PNRTDCXXKOZFmSSl4dTduiIbmhGrnKAOA7whmO6txWCdsqkMcC8hPa7rjoQfoBc9LsLgShFWfB3nwgFklPHq2KKOVQBHSfXV2McLhQeGz3H3RQXSVb9khi9vCqgxtV9su/zwAIGMc2jrG6Y2UxX1hze9iIaCu4JRW1LgEwVyAjwg8qjA76vj4yNl+UFJIz6phIMduPZoG1b06j9IX4433NdhJ8bD+TMCqQA3SjflkK0WYINMJ22U1f4DaeCg9pod3mU4H93N/eu894FU4JsF6J+4OxBZoH7kKFKDkwpp45heH42dw6p8VboI=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a1d974-6773-4154-1828-08d7015a1c6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2019 15:04:43.0084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2959
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(+mailing list +davem)

> > Hmmm .... for a HW driver, the HW would have to do the truncation.
> > So it must be capable of doing that AND it must be instructed to do so.
> > I guess big deal is a relative term :-)
>=20
> Right for decryption you'd need to use a fallback.
>=20
Or I need to tell the HW the size of the tag to compare. Which IS possible.

> You really only need to support the truncation lengths for gcm/ccm.
> AFAICS the users of authenc do not use the setauthsize function at
> all.
>=20
> We probably should change authenc to disallow setauthsize in case
> somebody starts doing this in future.
>=20
Actually, IPsec uses truncated tags for HMAC's ... so it may be useful
to have that there as well. And I would expect/hope the kernel IPSec=20
implementation to actually use the authenc template?

> > If I don't implement that function that I cannot tell my HW how the
> > tag should be truncated ...
>=20
> You can just read tfm->authsize as that's what the default
> setauthsize function will set.
>=20
I was referring to the case where it actually needed to be configurable.

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
