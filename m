Return-Path: <SRS0=jmhz=46=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F277C10DCE
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Mar 2020 06:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1730C2072F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Mar 2020 06:12:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="uqbvT0Ry";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="py0mk77Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgCMGMl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Mar 2020 02:12:41 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45756 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725809AbgCMGMl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Mar 2020 02:12:41 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02D6A6JZ007355;
        Thu, 12 Mar 2020 23:12:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=H8KP0dxqlNqF+6HFylUPR+JsXygib/mpnclDsA4znQs=;
 b=uqbvT0RyaoYpjZBnc5GUIkkJoDskw4e7788HTcOJBy8cozW34cQgr6f+7IJqR+wcRIG+
 ja3gbmfeQoxNqTJt33NMa1nNhcR2I7PHcQGd/lK3wFIdy/0LrJUSQG1B3ERE/SPu3xgv
 flywr/X4BG6z+WW+idvocx6jQRnLJgyGs7/jKUjPZFbtWMhoQl/sog+/6MUrM1QiNvZj
 7mXPHffS207baoLlVwK0jRepHcaJ72d7WhejZrD2vBMd1ZmibW1K92dG0dZQ517GPel6
 +KIfNcTt+U9V2mTe3SWE4aH/9UXZWq0ASlGK2OJeOFKfxJCSrK79HOcBHMKPgA0zKyf0 8g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2yqt7f2hx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Mar 2020 23:12:34 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 12 Mar
 2020 23:12:32 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 12 Mar 2020 23:12:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLe8XMIwAcdIXGtj4/OH5Hu5xzupOf7M+e15nRiRn8GKfD7QxwU5kW/sQ4Jp+h+jsHoAPm9h8qoQ0mdlDSTOg5ayIepUYQDl9aLxSfubt1sRhkXLDg5WKpy+pPXxlhNlQKad20JEE0u788bhkB18DD5NeWedsgYpGIpr0O0u4sKeaCK/I6vCnY1RCH03ZaJxicbQyjqIE1YoeXpyfa99XpU2i09D4Sz5aGzLxBpZ9cl4+5ai9smMCOLb3PsfBQCgVlamhEmEh4Gr8MjgVFUDw++CGxhM02Dnb46JZjxwF42ynwaWQ5AZ+zyHO9Q3iRdbuFUBHuOA0+BDjCxnS0OIYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8KP0dxqlNqF+6HFylUPR+JsXygib/mpnclDsA4znQs=;
 b=akPLMCkQY64k3ccvbjlFJNCFLpIa2u8SDkxtUtzIFQfeyk06QWBhfiG0Z6vL86VmI7zBrZgH4RImkife8krUT69FlSOOe6skw72GHCNUEvn0G8150MqdKN2aHtgUG8KNkiC0aFq1y4qMt5KyspFcFeHbkDHbV7oEJSQ0z9GEwG4iFeoLorWbhSsUz7IYi3X2ujw2Bf9VjOZszN8ZuazpPDfDAWMk7biUL65rAF+mVrkDG+FtrBA15rPsOe+QY8fFoPhlr+Cd+Y4bQUXHoBzXGDXrDlBb55+88LoyLTPAJ1s87gD87/J8DIoC15aloGFo7k5EGec61BBWryzAVCOjbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8KP0dxqlNqF+6HFylUPR+JsXygib/mpnclDsA4znQs=;
 b=py0mk77Yew5+wUFzCFupQjZnxB+CGtVpKRbRUYm0KhSo7cq1+0eG/K7stWtP0VYqVLDf62u8tm6bm8hF9GOpUM2ZyjBKDCVPk/Bg5v7d7sK0711IFFHaCYbOs9+pBzeP2nzTzAkUl7TaPFnI92bMoA13b965cEghcqVRz7DfQsk=
Received: from DM5PR18MB2311.namprd18.prod.outlook.com (2603:10b6:4:b8::27) by
 DM5PR18MB1674.namprd18.prod.outlook.com (2603:10b6:3:14b::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Fri, 13 Mar 2020 06:12:29 +0000
Received: from DM5PR18MB2311.namprd18.prod.outlook.com
 ([fe80::6864:a22d:9bc2:5b91]) by DM5PR18MB2311.namprd18.prod.outlook.com
 ([fe80::6864:a22d:9bc2:5b91%7]) with mapi id 15.20.2793.013; Fri, 13 Mar 2020
 06:12:29 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Narayana Prasad Raju Athreya" <pathreya@marvell.com>
Subject: RE: [EXT] Re: [PATCH 4/4] crypto: marvell: enable OcteonTX cpt
 options for build
Thread-Topic: [EXT] Re: [PATCH 4/4] crypto: marvell: enable OcteonTX cpt
 options for build
Thread-Index: AQHV8iAJ9GH/Dubn4E6px4+g1P8BOKhE4sSAgAEzewA=
Date:   Fri, 13 Mar 2020 06:12:29 +0000
Message-ID: <DM5PR18MB23118009780551E779DD9739A0FA0@DM5PR18MB2311.namprd18.prod.outlook.com>
References: <1583324716-23633-1-git-send-email-schalla@marvell.com>
 <1583324716-23633-5-git-send-email-schalla@marvell.com>
 <20200312114355.GA21315@gondor.apana.org.au>
In-Reply-To: <20200312114355.GA21315@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [115.113.156.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a725c168-f99d-4b91-07cc-08d7c71582d0
x-ms-traffictypediagnostic: DM5PR18MB1674:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB16748E1C818545E236547F71A0FA0@DM5PR18MB1674.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:170;
x-forefront-prvs: 034119E4F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(199004)(33656002)(7696005)(4326008)(71200400001)(6916009)(478600001)(8676002)(81166006)(55236004)(9686003)(53546011)(6506007)(81156014)(55016002)(52536014)(186003)(2906002)(86362001)(966005)(54906003)(8936002)(107886003)(26005)(76116006)(66556008)(316002)(66446008)(66946007)(66476007)(5660300002)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB1674;H:DM5PR18MB2311.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +E7BuqR7x41wFdXj9XWOptSFrkh8iImua7Ona++8UJGc0kOSN1Jar+3BTHJht4DjKQWecqJVZFww0LuaUC2ALjT3jltwu5UpXstbQyLX9lrqV4/5ckUYoQ56ev03INO3dxnuszgdpPp/fhjrECBhanbuN5AVk478oMaBaHYC7+GZ1rTUOTwHZeUHUOsnV3VDQ2GyO3k46CK2DmrmgkU7uyJlRIlrMWs6wzDc6j0EbK/p1KUglPYqATfgSJEmvI3gvI8Mywy1l36dWaoXNNzUvFClPwiR1do+sw1Lp6TaEk95a0snQ2Nq3J+56CXrrflrN7zoV5I/JHQKZqotSTpJXq/qFLMlO3ah4S+6hCXl0qLUgp9I11PFJzO/66jyVqwsenDDAqVZlRW6tLNxD5os6C/b9jIJinQY9Gn2c6QrUTiobvLafaaD1WYemTZ0aS5+DTtaFVeLr+lQn6jKbgZ3USWpTEpIAsddZ0P9JtvRNxYszDhWstvmJiHdQCh51E8XtQvTuarg4grym/X35ugxjA==
x-ms-exchange-antispam-messagedata: YvPlSSlVdQAWTna/Q+rGV+YfULpm2chVuSytua6wHei4Ee+xULrrcYUBSoxszbnIOQGtdJgV5uW1YRYuOZLQZid6DJMKeyaz8gDqJ3K9g7GfIcQnxaxMKfbd2pgdyr4QIVSfo58wL7SSW3eInPTjcA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a725c168-f99d-4b91-07cc-08d7c71582d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2020 06:12:29.7227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x3H+YdpvGZR/UX6KXUyXNMBRkbQK4RNoBVpfqNFCbvf5ijtnbcg+Qia9K4UfnRX5RhAO4mxDb7q0ZFZMGLDvfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1674
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_02:2020-03-11,2020-03-13 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


-----Original Message-----
From: Herbert Xu <herbert@gondor.apana.org.au>=20
Sent: Thursday, March 12, 2020 5:14 PM
To: Srujana Challa <schalla@marvell.com>
Cc: davem@davemloft.net; linux-crypto@vger.kernel.org; Narayana Prasad Raju=
 Athreya <pathreya@marvell.com>
Subject: [EXT] Re: [PATCH 4/4] crypto: marvell: enable OcteonTX cpt options=
 for build

External Email

----------------------------------------------------------------------
On Wed, Mar 04, 2020 at 05:55:16PM +0530, Srujana Challa wrote:
>
> +config CRYPTO_DEV_OCTEONTX_CPT
> +	tristate "Support for Marvell OcteonTX CPT driver"
> +	depends on ARCH_THUNDER || COMPILE_TEST
> +	depends on PCI_MSI && 64BIT
> +	depends on CRYPTO_LIB_AES
> +	select CRYPTO_BLKCIPHER

The BLKCIPHER option has been replaced by SKCIPHER.

Will replace in next version of patches.

Thanks,
--
Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page: https://urldefen=
se.proofpoint.com/v2/url?u=3Dhttp-3A__gondor.apana.org.au_-7Eherbert_&d=3DD=
wIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DFj4OoD5hcKFpANhTWdwQzjT1Jpf7veC5263T47=
JVpnc&m=3DRtwtmKs1DMDh4ZHin6Hn9yZqcEAt5Pk8oJbz2CBzpPc&s=3DkUGS5TylH_VUzkI5P=
VgrtBKW7hclNNpEWzpTsRfvAuk&e=3D
PGP Key: https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__gondor.apana=
.org.au_-7Eherbert_pubkey.txt&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DFj4=
OoD5hcKFpANhTWdwQzjT1Jpf7veC5263T47JVpnc&m=3DRtwtmKs1DMDh4ZHin6Hn9yZqcEAt5P=
k8oJbz2CBzpPc&s=3DeCzo1M4w_9vJKDxgDzV6po1WXmJKbkJg_yeUiiEl6sc&e=3D=20
