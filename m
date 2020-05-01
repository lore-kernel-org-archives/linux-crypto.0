Return-Path: <SRS0=G1bP=6P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58781C47253
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 10:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30BD12076D
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 10:54:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="HR5OYLGI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgEAKyj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 May 2020 06:54:39 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:24540
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728352AbgEAKyi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 May 2020 06:54:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cs8fXTZDAtaBpzqGN+Se7Ht4bG9a9aoAObSn3zTHHcnU0O7iOikxDQdojXUCJkr2egGRcYHn1GE61LiiUkGmHfFc/HchN350WxTzgOM5E3KDPh3F4P7KYUrAKfdfdIS7my6y9jhqnkgFJRolRY3Y60iDrQwPelJLI0ni7myJTpNd04aOSqFL0vNpFMfz4ss7JHweGKELl2F+B7MY7oPp9zxVYGuqCiY+v4waHWX7RrJ70K5Fsyey/Axt1QIEBt3m38otucVSJOuC1rEDlBrNASJ4dJRcQTiRCz6GJqhu9gAcQ6pE63ZLKRvkN71E5JKY4aPZ6qckIjngla0hUAzeaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skGwslQs9ZwCwYlK6qeFkutpOtuCKA28v4//bcjGlmE=;
 b=KT59P2u1QBjVgTvA/ylx+zF5tgEafLbSaPfPrObZ/qJhsug9c2jjf6aHYnL9dbBaiftJN8ZzBHmOPZYAHPsG3Fh6/uWvHoE0hN137cv0Fe09CH4G8bbpat5C8IosJe0FYKOvxYKNT7Z3zkCNg77NYC3JdHjUTXz4JmDYZEIsBFWWE636EgnWe4eI0dhJFgtHfkj+PiZ634UddBBoJVguh4m67/El+MpTSofb7hG8wIbNtZVU3fNb+Pz/86rpxUhDkxPn+nDseTPh1HVHRPz42FNLUIxZRZCXm95d8ePrLEcwp0dP0YLwCzKpoVCHwvbOdsVe3ZT7QD2x4F8ImbVOhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skGwslQs9ZwCwYlK6qeFkutpOtuCKA28v4//bcjGlmE=;
 b=HR5OYLGIcQJejFcLML/79Q/n13otfk86EZIGoPOknwwPOoNdd5oIoifmRtDEkqnZBgMEKyBa9t6ycMogjvJnBXvo6Z5CXnXXCwhKGM1jmSRy6e+q1HmZ0I1vc8jYqumQiqm2PKmshpCEAXzm6zgcuLdf9QC+36n+rDojUu/AMBQ=
Received: from BYAPR02MB3941.namprd02.prod.outlook.com (2603:10b6:a02:f8::18)
 by BYAPR02MB5734.namprd02.prod.outlook.com (2603:10b6:a03:11c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Fri, 1 May
 2020 10:54:36 +0000
Received: from BYAPR02MB3941.namprd02.prod.outlook.com
 ([fe80::10b5:a33c:e9c7:6c0a]) by BYAPR02MB3941.namprd02.prod.outlook.com
 ([fe80::10b5:a33c:e9c7:6c0a%7]) with mapi id 15.20.2958.027; Fri, 1 May 2020
 10:54:36 +0000
From:   Rajan Vaja <RAJANV@xilinx.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Kalyani Akula <kalyania@xilinx.com>,
        Michal Simek <michals@xilinx.com>,
        Jolly Shah <JOLLYS@xilinx.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH char-misc-next] crypto: xilinx: Handle AES PM API return
 status
Thread-Topic: [PATCH char-misc-next] crypto: xilinx: Handle AES PM API return
 status
Thread-Index: AQHWH6FwO0uDx7272EWw1r+zokOZdaiTB8WAgAAGjuA=
Date:   Fri, 1 May 2020 10:54:36 +0000
Message-ID: <BYAPR02MB3941AE74C305FD0452E2B868B7AB0@BYAPR02MB3941.namprd02.prod.outlook.com>
References: <1588328091-16368-1-git-send-email-rajan.vaja@xilinx.com>
 <20200501103021.GA1416784@kroah.com>
In-Reply-To: <20200501103021.GA1416784@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=xilinx.com;
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6dc03efb-f4c0-43ab-5ab9-08d7edbe0a04
x-ms-traffictypediagnostic: BYAPR02MB5734:|BYAPR02MB5734:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR02MB57343C1AD4CF307C1AF8568EB7AB0@BYAPR02MB5734.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0390DB4BDA
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JfWMaBE7hdWcWvrGWMbP9j3vbKHJXOuwS45crumNhlAPG4xLw/NYRk/s07TQ95eAE/pyw8OxZWzgPwHn8N2iu7vx2hdDLz0R/W08INDUW3APVEEUbkv3haMWxCgAST3MXXel9VPepDdx9YOutJU0ou5ne9bHXOeg+1KTPzljgCJMRJKI4S25nMh06Xn4662SSL0dABAk5X1czuFg4HT3jaAniZ/hGcNTBF+10rVvZxYlme1YyqYgyV/qY0m46i+rYVn41lfkm74+CJx+hAMYPHFXPsHkdwYQYvtJQE4DLKQqdKYd80RcrX2kOGuujQOR/Ix99U6Mj/3KlrkyK6JoudCj8yS2USugadU9LNqVuD5N9K6IyXiGUFxBA4vP5GQW+Dmhpy0ivSToNJx+hr2vZo15Rt/K3GU59I+JxwjE35ppoYOfubv2tnO8b9ZRkmJR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB3941.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(53546011)(316002)(71200400001)(9686003)(6506007)(478600001)(8936002)(52536014)(66946007)(26005)(5660300002)(6916009)(55016002)(66556008)(66476007)(64756008)(66446008)(76116006)(33656002)(7696005)(86362001)(4326008)(186003)(8676002)(2906002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: dhEN5tpHCtQgiWtl5vv7sC2lSOlrkT4Hzzf9oFxA33/TXsRdfCWh9/HPFi+On7upRnl55pPFTH6F+aj/ztg561NB+B8E7TNiWXLbGLgricqtcXJ6AWN5GtjrF1f1sl0aLH5gPv2fTpEDSMyqXOTtAAlJXVIph7Oe4o3NJWJoTxPvhPuxVGz2XcfYK1BgD5gJoivzGlExp7P1+fNJcUQeATcEu7EmDbhYnE0uCDz4kyRga6Bveb9XSzcGeGiG6rgu3Wujv2wo+FrmbJybIQuyWNbx1C7/dMDAQXt5lXNKD9zt0bDxEQOs5TN+lrJGl0EFkD3ugGY6LKdDOk2l1ourmtRxn43BrHlU7SrS/dTpJJTrVDySYi16qrs47yYmXLVN1uv04s07oCiSr7rcX0uCVPT56Qnkl12JB5wYnY6a1fwLdI26WQuyout9uwoAfsM/SqhoLoEft2cAZK/2mKp7wC7qNqorm1sVV2aqv57TFi+7qaCHs2WAoITg7mWeDvRDrQerZYJ62CbG/b3nBTWVDqu6jGWyRRIqpo6k72PP+JGOMPbqXHOWPQjAUiAc3QpU1QrYH5E9GjG5/aXLnQOCYrnmLKSA2hNrsDiLVdurnNbDmEKF3hKtHSHw2hBSof57/SFfP19zOZTUTzmYZ4nYlvEjP8EfRiVAyOWLnPxs1t1GyZV7ss+dGNDf2nZgwX+XQDuZtly0cCJBW2MevuoQ1+ZP4eaGjMw/r/xnM8WEAqgWKljwg8qgJAnSbomO47jVz6DyVz64h4cxsb9STXsHpYRDIWsbiX57a6ax+9LA7mQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc03efb-f4c0-43ab-5ab9-08d7edbe0a04
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2020 10:54:36.2621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YjEbF8dwDe/zBt12sfKyzJGARs23U6h72FEmzQ0Ib9bwjZ0w9igu1IOZRt24M+9WqTjLga0r0EhPFtVuGZv0PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5734
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks Gerg for review.

I have updated reported by and fixes tag properly now. Sent v2.

Thanks
Rajan

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Friday, May 1, 2020 4:00 PM
> To: Rajan Vaja <RAJANV@xilinx.com>
> Cc: herbert@gondor.apana.org.au; davem@davemloft.net; Kalyani Akula
> <kalyania@xilinx.com>; Michal Simek <michals@xilinx.com>; Jolly Shah
> <JOLLYS@xilinx.com>; linux-crypto@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH char-misc-next] crypto: xilinx: Handle AES PM API ret=
urn
> status
>=20
> CAUTION: This message has originated from an External Source. Please use
> proper judgment and caution when opening attachments, clicking links, or
> responding to this email.
>=20
>=20
> On Fri, May 01, 2020 at 03:14:51AM -0700, Rajan Vaja wrote:
> > Fixes: bc86f9c54616 ("firmware: xilinx: Remove eemi ops for aes
> > engine")
> >
> > Return value of AES PM API is not handled which may result in
> > unexpected value of "status" in zynqmp_pm_aes_engine().
> >
> > Consider "status" value as valid only if AES PM API is successful.
> >
> > Signed-off-by: Rajan Vaja <rajan.vaja@xilinx.com>
>=20
> No "Reported-by:" line?
>=20
> And put the "Fixes:" line down in the s-o-b area please.
>=20
> thanks,
>=20
> greg k-h
