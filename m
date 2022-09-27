Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D951EC32771
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 03:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbiI0DVg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Sep 2022 23:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbiI0DUy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2022 23:20:54 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.133.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E76814D5
        for <linux-crypto@vger.kernel.org>; Mon, 26 Sep 2022 20:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1664248725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=l2+JzL+QLMYLXaTYz8T8SEjKNeNnrP7n1PZzUh12EIA=;
        b=nK6m9NCy4pCBj07rRr3LP+H8WM75XMVEmhpXub7sqlyG+PzMBDE7R2j4zvCWzCq+ZYGf98
        L2vQYP2735nBG7yFBwrJ9Vp7f/AYKeivDxcOm5sVC2pXPZk0GXWYWEstS272kXWqHedKaF
        LTic/MULpcBLTAVBayMAVikVKek1FYSpvaaEm3LYKPFYczXIP2X0ACKHy3qaru1fwlye7F
        UJJOprQN+06Ov06p4DvMghhWTF/0BiqWd770+U05B47TE2/h6J/HD1Z6PjMMyhPDWsmoj7
        opqIP8EQADnNsyLcgMtHIKCeb7IjaGw6o8laY0jP1dKmlkminEdk2ws8Slze7g==
Received: from NAM10-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-FmAKuXe0Paia6OdhZnnZPg-1; Mon, 26 Sep 2022 23:18:43 -0400
X-MC-Unique: FmAKuXe0Paia6OdhZnnZPg-1
Received: from DM6PR19MB3163.namprd19.prod.outlook.com (2603:10b6:5:19a::23)
 by PH0PR19MB5346.namprd19.prod.outlook.com (2603:10b6:510:d9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 03:18:41 +0000
Received: from DM6PR19MB3163.namprd19.prod.outlook.com
 ([fe80::d02e:2c4b:c65b:36b2]) by DM6PR19MB3163.namprd19.prod.outlook.com
 ([fe80::d02e:2c4b:c65b:36b2%4]) with mapi id 15.20.5654.026; Tue, 27 Sep 2022
 03:18:41 +0000
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     Antoine Tenart <atenart@kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        linux-lgm-soc <linux-lgm-soc@maxlinear.com>,
        "pvanleeuwen@rambus.com" <pvanleeuwen@rambus.com>
Subject: Re: [PATCH 2/3] crypto: inside-secure - Add fw_little_endian option
Thread-Topic: [PATCH 2/3] crypto: inside-secure - Add fw_little_endian option
Thread-Index: AQHYzMc89CwiwoNeCUewcQAI64xzvw==
Date:   Tue, 27 Sep 2022 03:18:41 +0000
Message-ID: <DM6PR19MB3163D23E28C2C6106AC2BCEBA1559@DM6PR19MB3163.namprd19.prod.outlook.com>
References: <cover.1663660578.git.pliem@maxlinear.com>
 <29cf210c9adce088bc50248ad46255d883bd5edc.1663660578.git.pliem@maxlinear.com>
 <166392497841.3511.3731514363575087582@kwain>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR19MB3163:EE_|PH0PR19MB5346:EE_
x-ms-office365-filtering-correlation-id: 52e7ec95-98d2-4081-088f-08daa036fa74
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Eut7xDs86SAdiIrO8XzeN7Z4jO8MQ2m3yu1CA0M9Pv5jQ8cgNCMeyHoS0cINsr/sUDBVZppcX/GCSj+ZR/YBQbdGnv5itvO7gF8X2JAKWNd1Y0vbAYi1Wkl0cIwiiDqZGXD+q3S+P1Np6FsC8p/1jZJtNnbd5K5voq7OJITZpjOSe6q5UQ4wveeChVtXbavQvkp7Y61eKW1CZBRwxSUe/nxcsig7WHjiq0Sm7x1kSZBa7AiPXbfgW5yQgLadsr12PK8qv7UO5x5zX72jgzdRe2BUNHQEF2hKVzfGKbnItHax0wMU1G0gnD6tFGBBtRh7iCwYh05d56lx53q24xMhSj041N4sORQ7PtE3OCGY92U/VqLo0cbpzc5NpVcIoCtXuS7oZcaxcNPIqFGM4L11O+bhVOIQfQeF+fQ7EB/JN3lPlhZWW2RX7d8WLhpqjc6fbsgK/Q4oOZ65oYgKKDJQ9HatlGVXLBpmGdVZK1m7LKhN5B0wLwLDWf2z2lpsCbsBLt34ajNWAbYXcHjT2Wp8zraMTs9V6XieEOKK/Ulhnr+a/kkAGOPnvIs3TBaLyVLJvduQDFsHRBfKMv9Ud20eP7WuakqYDslLXuQ/8q3avvtjB01fVTG/UYB67A7l4zbax32qz5H4XoB3OqqHRuJaEzl2JUbR/zqzTq1c6lUky4aovV3qzy3rQXkOdi2/yOcFoQCiZrmx8xnSxEj4VWDTPd90WL9pCNINlDNEU2OenHwCG6MPkDA01yF8T1qkuUlcXJb/tqUhfcvBSY3jNzC42w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB3163.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39850400004)(366004)(136003)(346002)(376002)(451199015)(86362001)(64756008)(66446008)(66476007)(66556008)(8936002)(52536014)(33656002)(5660300002)(4744005)(2906002)(41300700001)(66946007)(4326008)(76116006)(91956017)(8676002)(54906003)(316002)(110136005)(38070700005)(55016003)(122000001)(83380400001)(38100700002)(71200400001)(186003)(9686003)(26005)(53546011)(7696005)(6506007)(478600001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kA+l/z0tjVX9diljN5GDybW3GqGojQV+gf1YFIZXhWpyD6YFVLQWO3UgpZQl?=
 =?us-ascii?Q?it8Uc5ZH4OqSky9ZBEgTEZC9I87TgEd6TIc7eq++nem9siPfj0nxRv0rUdOt?=
 =?us-ascii?Q?1C5xtDMpqHXjCohj7IwA5HyHaimYen9KegLdASSV8Mcz3Hxch2f3i1VSioEn?=
 =?us-ascii?Q?rBNJkyTK7zQGpzQOct9WylJa+Tu2+rpCVEk/uB9N869jKL8OpEIINAj2uOTy?=
 =?us-ascii?Q?WvzHVDiCksW0WqB46vsUDwQKWyD6C8Lv0Xvyfi6nO7v7OO9GzCJPbF+2uuE5?=
 =?us-ascii?Q?9GwOq8rnXsFpYMvBUMMb//jokPB8Dv4n3NhhGAu9Vp86uX28RsTUZAJOqExB?=
 =?us-ascii?Q?zmcFluVjE9dDTD7xFPo7z8R3d3GW6dQD2brcitzl7MeVGo7hObz2tetQfgfj?=
 =?us-ascii?Q?mJG7nvqFRSzeqp/q0jSgrmBDetLw3WzCbm1jbQEmr8tVgbxsQzntesKIKIjX?=
 =?us-ascii?Q?Eo7eijGCidPxqpyo2L7W9H4iG13RbzG4xmyHtWv52I6IFXXI5VhkPpqNRE2N?=
 =?us-ascii?Q?Y1jtfHwHGYvRzJcKFyCFekHPqv34zCviBdW/5bOV5lsLEB9f7vlEzvT9lBGE?=
 =?us-ascii?Q?LTWpnkGcKV3CpnLX0QLyWGtNbU9ayG1cUGAC6xmpFEoo4z0risMoYRNV6TLt?=
 =?us-ascii?Q?JOou3vWZkhh1fEgC5p7q63YViSPWM+qIviG5kCxHdfrSDe++0gZX1tqYPbJv?=
 =?us-ascii?Q?qYO29HyoXJO0jgZjMQ/H+xt9QOWzf5MRFKbEjNELI4mTsuYJKZclU2PVy2Iz?=
 =?us-ascii?Q?uk9XG1f50EVZmpkM+6jCxp/p8DSzYpqUjSJKFIc5LzGV2XqcQ7RP7YbyNaw8?=
 =?us-ascii?Q?NsasG85oKcge5tV06ng9kPcvAVMmMrfdQUJwQeBxFeef4hJv+R9+/2diiQ20?=
 =?us-ascii?Q?Cmc4j5xTHhT3lDc+BsXMtEdhV0TIZwu+h6HaIzYHim9RfUSzK6b7QlgvUo9d?=
 =?us-ascii?Q?D2YpuhJKbW6u4vXCPe3kZvA2b+puWkS63Pdzmx0UUokyAmv3lBDdL26i9ONE?=
 =?us-ascii?Q?5pmqUWmiqpvKhkNGDUDzhhJrzXZqwyk1JurilXvoA520V0czvCFSbSbI71XY?=
 =?us-ascii?Q?gMcIOE7rTiJm7qrImC7kpXWxnLs044C7oYfIDuEcGaoDoIJa6uhepKseMXXK?=
 =?us-ascii?Q?P9WfbrxW52W4pcxrRKA1oiyi9+UTk9UfyYrECQnRRrnqfp09TLdJCLSBHumJ?=
 =?us-ascii?Q?LoL8WTnvkq9wC34qrEwmTptMSv63LAWuGiCO2HiDi8F4pZzXm34VIUx4HXU1?=
 =?us-ascii?Q?UoyGmFZNnrBgV0KRY6treMzlGlrHVdVNDREMQIduTapPQ2cjqn92qAWM6uGe?=
 =?us-ascii?Q?7g4f8sRMfJXOIdj4Sv4Ikc1ZhSKDWCWlkHJHdNVzE4hSv7mDpbeGq4iqcHCK?=
 =?us-ascii?Q?4iOUPpvNOOrOgKtNPSuKrMrq7CGjU21Qe89rZqu3r6C08igMpeeNoOsQfh+1?=
 =?us-ascii?Q?q/fWfOhoBJQEn2HYhxe0ZDWmY1mU8Oc5nRHDg05PImFfdQIKmxvKaiSC8jYN?=
 =?us-ascii?Q?5/ZWG6LEtMR5qiFs90xe84275+5+CQlhdfjq8H/XznJFm29wT0ujwVVmCEfe?=
 =?us-ascii?Q?iYA6DWYZaUJLrr7TlmlFUZr9fhxpbMg5QYbT/Cdu3E3Jc+oPx1t/vscDpyXR?=
 =?us-ascii?Q?jw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB3163.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52e7ec95-98d2-4081-088f-08daa036fa74
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 03:18:41.6464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ueE/pKA0Uxv0IPUuFu9o0wxGBQxcjr5i+bnxDheaI3Vz/lC2UqKuqiTqe1V2J4lDNFw836jQGqVTKvhEXBDtAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR19MB5346
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23/9/2022 5:23 pm, Antoine Tenart wrote:=0A> Quoting Peter Harliman Liem=
 (2022-09-20 10:01:38)=0A>> This is to add fw_little_endian option, which c=
an=0A>> be used for platform which firmware is using little-endian=0A>> (in=
stead of big-endian).=0A>=20=0A> That's surprising, releasing fw in various=
 endianness.=0A>=20=0A> Cc Pascal who might know.=0A>=20=0A=0AIndeed. Would=
 be great if someone could help confirm in case I'm wrong.=0A=0AThanks!=0A=
=0A-Peter-=0A=0A

