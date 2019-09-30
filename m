Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB3D6C32792
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 20:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7159F22509
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 20:45:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="sUMnUVh6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbfI3UpR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 16:45:17 -0400
Received: from mail-eopbgr810049.outbound.protection.outlook.com ([40.107.81.49]:12860
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727508AbfI3UpR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 16:45:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBEY8BqneKM/iBwfjZXN25Bz0dua9bv+sHLm2zVrt5P6EJobVVvzwuxNLyYqKfY/g67QitwgmmAlY96WGoCrY1IBHYX+NGr5jrOoweXrZ9CpYZTFEVYNi6BG8flbayjx6Lo4gA0AImLc9xenlSSXih97+CCVUQpEsvr4mWZkGy5O3njTMButrNgsrPTZOEQT33kIPr7O+zVOAdAJV1bmaxSx0NYMalcy56kTJpRCKqSRB2iPta3R+zJKCA+uqzoJD31P6gGgDuDNPu9zklgDxNAZ/5xuKUsebnknPjGEEhe8iXhqbMrKgG6U0nbMMPZhZCv9jqrVwqNiV0BsDU+4fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPIbVktKM/JIpADJbjiLRJKgympdn7C6CMrqlVdZTYs=;
 b=RflDtPO9KsbkOl/z1eXK5TbIbSE6sb46qL30xvQhJX4+6VuWEACjSKZV5R6RxNuH2Cr3QXtRsbxrelRLuo+W6C1r55HMlXF4it6Y8YOTvn1ox9OMnItHZe9mWBkDthdrOStcYjlIC/SzNJeZF5m0GC1OcjC+GAjHBe79FpGPrvTR/t9YUQvbMawd0Lbp3CERBn9JOXZNXZ4ivp3EnGl30KlTNxNhIPhJB6UgOFvI9nlVc+LPGXJDTXWtwEjijMxbMrnWQUWNvruzZax2EwiOAtqP8BocDlHltPF2H5LAmUpjf34wX2Wgh+PoSC5lmHq7nNx5PP12y5R3+NFGE2IJhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPIbVktKM/JIpADJbjiLRJKgympdn7C6CMrqlVdZTYs=;
 b=sUMnUVh6V+LTQZF1Zqh80tzDqEWzvZe51bYUz+98DMzRmrg+EpDS2cA5P/5jInA8BvfL1UAcVcNkaSfVQ0tz7p7PMDyp0BI0Qp/SpmP2YsEhNlkpjeSmC44scR8VzFBz2VPZ4rNejfYPviF6QqSat6zRtIE7Nx0Jb5TnK3xv1Y8=
Received: from CH2PR20MB2968.namprd20.prod.outlook.com (10.255.156.33) by
 CH2PR20MB2934.namprd20.prod.outlook.com (10.255.156.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Mon, 30 Sep 2019 18:50:45 +0000
Received: from CH2PR20MB2968.namprd20.prod.outlook.com
 ([fe80::e8b0:cb5f:268e:e3ae]) by CH2PR20MB2968.namprd20.prod.outlook.com
 ([fe80::e8b0:cb5f:268e:e3ae%5]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 18:50:44 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] crypto: inside-secure - Fix a maybe-uninitialized
 warning
Thread-Topic: [PATCH 1/3] crypto: inside-secure - Fix a maybe-uninitialized
 warning
Thread-Index: AQHVd4jI0FLkks7xkkmieh+BnXbyw6dEj6DA
Date:   Mon, 30 Sep 2019 18:50:44 +0000
Message-ID: <CH2PR20MB29689C8C08D524BA05573EE9CA820@CH2PR20MB2968.namprd20.prod.outlook.com>
References: <20190930121520.1388317-1-arnd@arndb.de>
In-Reply-To: <20190930121520.1388317-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1113a9f0-262c-48a3-e4d7-08d745d719b7
x-ms-traffictypediagnostic: CH2PR20MB2934:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CH2PR20MB29340330782B095C36FE17D8CA820@CH2PR20MB2934.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:345;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39850400004)(136003)(376002)(13464003)(199004)(189003)(11346002)(102836004)(53546011)(6506007)(6116002)(3846002)(26005)(229853002)(446003)(33656002)(2906002)(5660300002)(99286004)(7736002)(305945005)(486006)(52536014)(54906003)(6436002)(76176011)(186003)(71190400001)(71200400001)(476003)(7696005)(316002)(8936002)(110136005)(55016002)(81166006)(8676002)(9686003)(25786009)(86362001)(81156014)(74316002)(15974865002)(66556008)(66066001)(6246003)(66476007)(256004)(66446008)(14444005)(64756008)(76116006)(478600001)(66946007)(14454004)(4326008)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR20MB2934;H:CH2PR20MB2968.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 28l2+VgICUBpCc+RpmlYwHHvFVX61rMs4ghLffNkdJ5OcNFG540Yln6Dpj8uGjezaIof8tS3nB2snGZX6LTdKj9wmp2uAzalMQQrM3hSWWRR1SesDXUpsLVKn3hYdICFI2iOVRdybQy8ILkZuATcwWjCT/wjwZQs+qFx18mnpPcQ/cxMJKw0LWtET2NEx47EWM/J6fbNQZNFLVvMmAMgvo33eo41i+0WRZcFXRTBEnQbESKKXUp0S+AbZ000tUVewOBwz0OPRxb+jYvicZs5mv6qA24Z/IphKVwUWWCMoiebZ0lMTApNFxdy7+8qdE8C+SPKfw4Th4e9jnh9n/+9/2FLUBQ93ZHlv6+bblsqpzRctfSWsrcRSJbhspbCg84Rtuy0E021Z6EmecGg+BwezoblA6lqDGZLCUfnMdLgElk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1113a9f0-262c-48a3-e4d7-08d745d719b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 18:50:44.5213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BJlPPiBYvaSDO3gnHWC9czdtR8HsWh1t/eFX/0fWTDUuJTj+2HdiXOtUIEdfm95wNlwuhGxkoDZj/hI09zsx3nMVp92vfMMXmnMXllc55XU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR20MB2934
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Arnd Bergmann <arnd@arndb.de>
> Sent: Monday, September 30, 2019 2:15 PM
> To: Antoine Tenart <antoine.tenart@bootlin.com>; Herbert Xu <herbert@gond=
or.apana.org.au>;
> David S. Miller <davem@davemloft.net>
> Cc: Arnd Bergmann <arnd@arndb.de>; Pascal Van Leeuwen <pvanleeuwen@verima=
trix.com>; Pascal van
> Leeuwen <pascalvanl@gmail.com>; linux-crypto@vger.kernel.org; linux-kerne=
l@vger.kernel.org
> Subject: [PATCH 1/3] crypto: inside-secure - Fix a maybe-uninitialized wa=
rning
>=20
> A previous fixup avoided an unused variable warning but replaced
> it with a slightly scarier warning:
>=20
> drivers/crypto/inside-secure/safexcel.c:1100:6: error: variable 'irq' is =
used uninitialized
> whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>=20
> This is harmless as it is impossible to get into this case, but
> the compiler has no way of knowing that. Add an explicit error
> handling case to make it obvious to both compilers and humans
> reading the source.
>=20
> Fixes: 212ef6f29e5b ("crypto: inside-secure - Fix unused variable warning=
 when CONFIG_PCI=3Dn")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/crypto/inside-secure/safexcel.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/ins=
ide-secure/safexcel.c
> index 4ab1bde8dd9b..311bf60df39f 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -1120,6 +1120,8 @@ static int safexcel_request_ring_irq(void *pdev, in=
t irqid,
>  				irq_name, irq);
>  			return irq;
>  		}
> +	} else {
> +		return -ENXIO;
>  	}
>=20
>  	ret =3D devm_request_threaded_irq(dev, irq, handler,
> --
> 2.20.0

Ok, this won't hurt in any way I guess, so fine by me (assuming that error
code makes sense).

Acked-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

