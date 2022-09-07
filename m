Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D025FC38145
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Sep 2022 06:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiIGGpG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Sep 2022 02:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiIGGpF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2022 02:45:05 -0400
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 06 Sep 2022 23:45:02 PDT
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.129.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC094A11F
        for <linux-crypto@vger.kernel.org>; Tue,  6 Sep 2022 23:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1662533101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=XlEfWTXM9xLBeF7a3eztAviPGCqqY+d9bJIvSypIcdM=;
        b=PlJgzaqKhDj92ymg0T5aSWZw4vC7xPnC9wTHQR5m1E6JCU3aJ/tw+UdJ2In5k5hW5F3D/C
        dE9Me+22L8RZCaCvKkzSIvRRoZi5uP4IloJhpa526oSqwgoOrXAehS20IY8iR4bWn0LGf7
        b2qFl0mltIBfKcs78eaO5N0A4SX1R9UP0AA2eY6j8TALZkqUVwZyyF9JL39tVU636QtAyg
        4+fg/SwuXLWx5CAdrrqVPdJhii/vzb0sfnwjI7fkfX3EUx1ohZiZ7uQfTj8F4GiBxFuOGM
        jIAJqYhPyEWAG2dyxy+zBKFTcisxH+XA4RCINWTrixymdLcQK9T3rJg6YfhUUg==
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-7-5SHpjtNICOOnDvRJ40Hg-2; Wed, 07 Sep 2022 02:43:54 -0400
X-MC-Unique: 7-5SHpjtNICOOnDvRJ40Hg-2
Received: from DM6PR19MB3163.namprd19.prod.outlook.com (2603:10b6:5:19a::23)
 by CO6PR19MB4769.namprd19.prod.outlook.com (2603:10b6:5:34d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Wed, 7 Sep
 2022 06:43:52 +0000
Received: from DM6PR19MB3163.namprd19.prod.outlook.com
 ([fe80::b841:6e14:1257:774a]) by DM6PR19MB3163.namprd19.prod.outlook.com
 ([fe80::b841:6e14:1257:774a%7]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 06:43:52 +0000
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     Antoine Tenart <atenart@kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        linux-lgm-soc <linux-lgm-soc@maxlinear.com>
Subject: Re: [PATCH v2 1/2] crypto: inside_secure - Avoid dma map if size is
 zero
Thread-Topic: [PATCH v2 1/2] crypto: inside_secure - Avoid dma map if size is
 zero
Thread-Index: AQHYwZuhWToE3i/+MkuyVhPHlEoUrQ==
Date:   Wed, 7 Sep 2022 06:43:51 +0000
Message-ID: <DM6PR19MB31635CCFF3A6306FFB950701A1419@DM6PR19MB3163.namprd19.prod.outlook.com>
References: <de6de430fd9bbc2d38ff2d5a1ce89983421b9dda.1662432407.git.pliem@maxlinear.com>
 <166247285388.3585.6290053542530090542@kwain>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85a0101f-2b8b-47a2-d0f0-08da909c53b7
x-ms-traffictypediagnostic: CO6PR19MB4769:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: u7QK612EVyXw0O8tLjnwcgToAZjVOGYhDh9YSThhfFuMWyuAayLuqRV3sM+9u8xtjBX8QRKkkv5nols+ul0fK4cPAcZ05TyFGqex+ICR8bXOsQIe95OVCZSBEWr4EBnid/FUllo+5s+N/0HEbUsy+PEW0ssLpK1XVAP39hO1/A7oWfyIS09MlE7THUXruN4qFRQ1DjbQbRjf+hmAl7wtkNLtHzmateBR/3hHZzff3dKpmGBpvn8ywxk3gvHJ6XOxIQ3rTGK8OrzxDFo93UC1tT6F4fhV98bEexPQ9i7gxgNh9d8Yrfmw2QYtI2M0uCuRJvZoTDJBezxkNcj6yPF+G5E34jM0Mj/sAoxSkrsh2wVQm9IbHXm7wZgzGTuKl7/QRY7guLBgnPLC+qteLsoxR9UNxvnqBYwOWgFFrI55fFE4oJGZmZiifcl2uBdNfG4PZJD0fc2cfxxlLNoKQGsmks9YMvoslaRCHuMCydYdpidolA5T4741wYf+HRS+tr6HLnVMT/EoM3CZprEhQj1XX+SWhko6nZrJViLrKWZ/1VARGxaz6Nrg1ZV0TgJwyAGXEQgCNd4b8pvQF3oy2lUUspiOvwGrpX9a6uzcAIXz6Cx/aGLoZVywF+0A6dW673PWsKH3viG/Gx1LX3R0vb7+MLbUCdngfqtXm0e6FPzg7e5T/x21A1ekO3aTWoaOgAckTNuH2lGME77LdtfKMHHqA+FC7PyBZOehu7AZpyGAlvOKSkH1+lREr1IcIeFc/GI2A7d69kHPfF/+OZxaLtspZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB3163.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(39850400004)(366004)(376002)(346002)(107886003)(76116006)(64756008)(66556008)(4326008)(8676002)(66446008)(66946007)(91956017)(66476007)(5660300002)(4744005)(6506007)(52536014)(26005)(7696005)(478600001)(53546011)(41300700001)(186003)(8936002)(71200400001)(55016003)(110136005)(54906003)(86362001)(83380400001)(316002)(9686003)(33656002)(38070700005)(122000001)(2906002)(38100700002);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uYWZymrie8+R+Uci9M1gyzNM7V2XnhtZoYHbn9dnXcUBZ27uJPnhNJ6J55/Q?=
 =?us-ascii?Q?sSCypYKfEWfycbdmvvWNTGSI7GDRSprQ2JCYJ29evDTarg7wFgPWo1pIkrYF?=
 =?us-ascii?Q?YzLsTZTG9yiUrtuHkfcjL1ZwnWBlFClW6wv2WsqNwhPKQ0iZZa2DqX7zhKTe?=
 =?us-ascii?Q?S5Fv1cIXGt9OOW8daOU4wRQaD4bcui4kX2JDIS1bMu1+hdLN6L9RD5RKbSPi?=
 =?us-ascii?Q?t6vff8qdqeNqwaPnmg3+cthv33FB5z2zcYCMHlF4BEeEV3Jercr41QB6sWX9?=
 =?us-ascii?Q?RtZph8vVLQw880zRrU0E4yQUWBiBzxvTYof/upS+jdb56Rfsze5PdMfR3LS9?=
 =?us-ascii?Q?hqXDeJJS0qHTO0o+n17PkyjKmZu0Yv02WmR8VOtmZs8FcKq78pudBpOgARHe?=
 =?us-ascii?Q?NJQGBzt6Wy49J6M5zepVYe2fO6VWLbw9/C+GmkW2j9qM3r2xAKDeQQqg7T42?=
 =?us-ascii?Q?uvWSYCL1acAxTTGvCRK/fQ1bXlhZD497EPXwKgr/JqoFuhft3WSD/fF4GZIa?=
 =?us-ascii?Q?oTRgAxPTq4JJjqz6mUnjbg+POyu1DdQe9lFmw54/H9hc2bWThvpzpVNgtbSl?=
 =?us-ascii?Q?0+9lvrKSejs9uIqwv1tfeBTe8aBxAfnLYB1jKADux78JXxLH3MRT9yZHOZKb?=
 =?us-ascii?Q?p3lj8tWHj5+ZOfRpkiy4+5LHCYCWdizXENjwj/0wCdgG6U/IG3rervJCx2qq?=
 =?us-ascii?Q?UEAP3RqHNW8ALCVpeMvJdDKe1HnzeBvn5a+Suv1eUXwaM/UUzJNnWByxwT/0?=
 =?us-ascii?Q?5Pt0k2SBX48PXeJ+g30Ai0T6P+gVwRF6s/76aCF7gjS47DmzmTvzCAt4PBeJ?=
 =?us-ascii?Q?MU25QsasH+4RLRlniS+MLhNOfXLqoHgZ3o6tIcE52kbdnFH5pX0ywRkjTeGZ?=
 =?us-ascii?Q?iX8LrEKHOUaqCAIY3xQGFnhLDptQosNrucex6nAJI7rCxB7Ib+/en/QJ9H3Z?=
 =?us-ascii?Q?tf4x2u41HRVT26bL9HOvyjq4d7TlKCpz9ZkBQXfOD1sTMto5+vBfjMa/FWrA?=
 =?us-ascii?Q?//3ji6c/V7r1ZKXy/cBzs0s/YXEUg3asnU4fsDSsBHK3Y9/0saxocUUiVAtQ?=
 =?us-ascii?Q?N+IrnAC4a1SWVEnFAIXTSPuTTlu3I3gK8DILgmKacb/FtJDEpd1BNERozrbi?=
 =?us-ascii?Q?qGQpmURRPmU1QjYzIq8F+A9kGPlmemWeA+2j98dJ1GFejEjTUJil7s8QW+YR?=
 =?us-ascii?Q?Nfl2moupQaS9JjUbquy7XN0ae8ZbYVxKL961u4KiJxqOwa7x4Z7wcYdjFCSw?=
 =?us-ascii?Q?AsAOJe0mnFbeOJ54nZZ/0wA2DjSN9W8DLUv4RcSIKzWwVXPokwAlIVLOxeuD?=
 =?us-ascii?Q?Npb61rP4K5uZctTWrYEUbc+4W1IO3A24bwxPew7fp94/9qwWDAgc7xYL/orM?=
 =?us-ascii?Q?WOJqcv3IUXW0bYfUnNc2Zy0EuBhFBg0a0hb6MEz3gcZ+oWUQYq7w0x8BxKeQ?=
 =?us-ascii?Q?zsVvRGL4x4gvnWBdVejK2iBcprm5IEMaXlTvUy/NSapMotQ681Rm74eJzsKj?=
 =?us-ascii?Q?obAbn6zi1DHtY/YZxmjnsyiR9YvpBjclut8WEC/zmkeXB5mRTFhZfdexJrzm?=
 =?us-ascii?Q?VN1yyUQb1DXfnkV6qN4msFpmbT5qJm5/fC6ejy3ANu7oMgQu+77bftEbLBik?=
 =?us-ascii?Q?wg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB3163.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a0101f-2b8b-47a2-d0f0-08da909c53b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 06:43:51.9574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wiXieM8V7PnAHJ3jmrQieEzRixUjzYMtEEMw9QhTXJo7ZZWxIUSO4YV9GpJNhvfVegG9HQuYpbos0EKuq0nQVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR19MB4769
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/9/2022 10:01 pm, Antoine Tenart wrote:=0A> Quoting Peter Harliman Liem=
 (2022-09-06 04:51:49)=0A>> From commit d03c54419274 ("dma-mapping: disallo=
w .map_sg=0A>> operations from returning zero on error"), dma_map_sg()=0A>>=
 produces warning if size is 0. This results in visible=0A>> warnings if cr=
ypto length is zero.=0A>> To avoid that, we avoid calling dma_map_sg if siz=
e is zero.=0A>>=0A>> Fixes: d03c54419274 ("dma-mapping: disallow .map_sg op=
erations from returning zero on error")=0A>=20=0A> You can't reference the =
commit above, it's not introducing the issue but=0A> the warning itself. Th=
e actual commit introducing the below logic should=0A> be referenced.=0A>=
=20=0A> Alternatively since the warning was introduced latter than the logi=
c and=0A> this is not a huge issue, you might resend it w/o the Fixes tag a=
s well.=0ANoted.=0AI will remove the tag in v3.=0A=0AThanks!=0A=0A

