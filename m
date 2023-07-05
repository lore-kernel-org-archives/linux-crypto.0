Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B96EB64DA
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Jul 2023 12:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjGEMSQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Jul 2023 08:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjGEMSP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Jul 2023 08:18:15 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-mr2fra01on2105.outbound.protection.outlook.com [40.107.9.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7081699
        for <linux-crypto@vger.kernel.org>; Wed,  5 Jul 2023 05:18:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oE1NFGzka0RgBrguQ07XHC3nLxm4TtIJQpgHxMqEjAf7cNGVmld31PuZqXco27MjYa80Ed6f4FtZGOubGyTH32BaQ3mnH9PtBPCAnY0KeLesGRf1YFw/LdGA5RcMejU69Y0nkdBn31eUQOgJm1xluTQ+IbNjftERyp5W9fucTLUjutBvIh4F80jScSc28RIgAEcoZj1gX1PQLX3heb+tW+emMhBT0utj2R1HcMiFwcJ65PWdeSAQ/TXSXFSm6mSrz4sMEU4VNKI7D1zBaEiZ4+798YpPcp1pU/7PfeTVEi1RZCt9l4uaN3F81ItgxmEa7DCm3bdZey36ngO4lSn+vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODlv/njykoMZOlhlLkWRKSgmixVbLLbMZVSAtmQ9F9g=;
 b=fEbwlbPQ2LNmCNZ6g/A4UP6i5fiNU8SyxgGzz/QL9i9en1Nff9bFZAK7c4PQ6hEMi0ssFcYv7Zvw9RybtdoELbRjg/uixVSw2ftzpIo/ffsm0BrtPlalFXSNcEUAKzWnhTUoBmY3Jra90fXtKTqurSSkazgFwawI85Ialejo9FaQcuQnJNf81B9eZA8VGIOrUdHN8A3hICHHJ1xGp3cX/CT/D3PSf31EdAGGRUp2MFUJUCcLtSlWXiN9AtKpcggfVVCQHPI3Tz36cQR8M94BpiXx+FRBH85YLMJxdriMfg/8UZmQ98qTCgd9kzaLNwae76zSL9dkETM3UBjSaVE2AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bertin.group; dmarc=pass action=none header.from=bertin.group;
 dkim=pass header.d=bertin.group; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bertin.group;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODlv/njykoMZOlhlLkWRKSgmixVbLLbMZVSAtmQ9F9g=;
 b=Cuvj4MpjxIgDb8P/K19mpwu1fGRSI7jFj+Uf2Gm4gLpdsPilYHV/BXrNS+AjgH3a/5sz43V1c4+MaMY5kiY1KssDovcgvcCMYd059Vuw30wcEANpEq1zZI3u2AG7lx0fIdrF60mseBQYcqAvqV0vNzmHIKDh87D7HW+A05RwQk+Hbskt2BbbiOFhTBthzrkmWFpayv08e6UtlrG503HNwQ83Xl7Gj9JNoeQXaIl+2+Z/37kqpKHHNo/hKxRQ73wP+5jgbZuCHcP15GyYz4GnEltM0NFiVNiM5xH4N5U8yiSHM4wibRV4/3e/WMILZxFn5aiUGyCgHU2qQ1bymHl98w==
Received: from MR1P264MB1876.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:2::16) by
 PR0P264MB1612.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:167::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6565.17; Wed, 5 Jul 2023 12:18:10 +0000
Received: from MR1P264MB1876.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7b8d:7ba7:721a:fc6b]) by MR1P264MB1876.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7b8d:7ba7:721a:fc6b%3]) with mapi id 15.20.6565.016; Wed, 5 Jul 2023
 12:18:10 +0000
From:   "DUMAS, Victor" <victor.dumas@bertin.group>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Xilinx HW accelerator priority
Thread-Topic: Xilinx HW accelerator priority
Thread-Index: AQHZrzkvSPuhR83BME+/1ezfdNm+4g==
Date:   Wed, 5 Jul 2023 12:18:10 +0000
Message-ID: <MR1P264MB1876BD45BE30638DC69E1EE5F82FA@MR1P264MB1876.FRAP264.PROD.OUTLOOK.COM>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bertin.group;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MR1P264MB1876:EE_|PR0P264MB1612:EE_
x-ms-office365-filtering-correlation-id: 4f5813b2-527c-41b9-b96d-08db7d51e5a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P81cviVaWpoJECPqrsUxxPYJ5a4zQb0zMZgWoPSPBhQdTY3N2RWbnpg2Vy3cjTizuYDeAaGS8Ycjfbhp1uY2Vo6AhvN5p4pNzJER1PnR+EnFXL21GFzwuUcaWwnxqo8/fJNrQPcyl110l06S21GKklcjUYhguCTwi6BgYK03mm5qa2lGsyEVJrlj5ZQfg5HFgnBWMotAmWOx/hqX9F+OpME4v17K3si4DqADjO9NkCVTWymAQkqlIpwtPPEHDcPt4tQPOH6P9TPG1B6d3j5H9nKQCll7qYpGdMt1kPz6RXW1LYcxtZPARd2D3qDTIKEFZ5NFtuGUEX+QZHjhPrRsXXnSsEuGyyrIkY5KFwyU0WkYJwgKmPUiQxUhsxHFM77G7vLhAm03lQ/+Of8NygEx8RVRr3fKaG5bJu/xNi966EvgoIAkLTqnOfQFPNFQU9zvr5XuRdlyp1iFRQ+XZO/JY2OWtjrF4rnbweNU6SghXpuwJtuAzRjeou7A4Hak5+9BcRQKYgqcWLnmCmfJzJ/FVQWfqIKtgk9gNXQuVDgnbFnSDFz29w+P+48BOTEEq3KqrYdYks/z/g37woUVa8wCQjTmP7DRU8jW2n7d285U6wS5JlUvlYi6mbkWFI4AjHvT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MR1P264MB1876.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39850400004)(136003)(376002)(366004)(346002)(451199021)(76116006)(38100700002)(66476007)(64756008)(66446008)(66556008)(6916009)(66946007)(122000001)(55016003)(186003)(86362001)(33656002)(71200400001)(966005)(38070700005)(7696005)(9686003)(6506007)(26005)(478600001)(8936002)(8676002)(4744005)(3480700007)(5660300002)(52536014)(41300700001)(2906002)(316002)(83380400001)(46492021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?EfvA331PvVVmHniyqxisuH3UPeocqiQDQDu46JVmlrM1l0qJgDOoA6D/tV?=
 =?iso-8859-1?Q?iINaXSuIOt95gZ0KyzOZovx7eleekn0yKIyG6e7VjGVVxX10tKVGS4mfqw?=
 =?iso-8859-1?Q?eXMijlV7ZdLHaPVQX9RxZ8vBmD6rNA3qeGJDjYlMrA27UO7ci+USsZYvRt?=
 =?iso-8859-1?Q?gjGAodSmJrbAep8lwcLPL6+Q2O6R6SVIhjHjeQP0wXQ3noudsRinhfDrPr?=
 =?iso-8859-1?Q?i6xtbYoxKWx6XgDyn9rSPQlCrOL+12j7vJHiVkcVvCZEtDJEzGy2c+D0LI?=
 =?iso-8859-1?Q?PgvdpPDFArDr970N1oBgV2sVDqCV3h9tIEO3e6/f9d72GtggNSEEu/62HJ?=
 =?iso-8859-1?Q?hzZtmMoU/1P8Rr6wC9cYiRursSO0xBaLpLAxLbfH17uIBHEP02jVcuzWNj?=
 =?iso-8859-1?Q?oKa6x/IAd3hKaD8BDfXzLbguBqecZUavJZ0DmzdPFmsbooDmX8BAILcyxe?=
 =?iso-8859-1?Q?Z9juZWFFvYGrNo3mDtTWif091h3LHE/vGLVt2YFLgGQeC5hEEmV2vwRGfO?=
 =?iso-8859-1?Q?v3T6R6Bw0XIyCPLHSqbVASkIQTKpchAbizUFZl58l6VYWvF8CXPxdIov9m?=
 =?iso-8859-1?Q?uEwwtsyWGt0YUiT9KxXwg+Rv2cYdBj8i3kqXs66kPRHJpfgIpIFxKz+kRM?=
 =?iso-8859-1?Q?r0/iq4yS68y8z4ZEkS4e2bz5/Tb4BmxjSXiQVQQ9TOgaodUepoj0BcvBe0?=
 =?iso-8859-1?Q?0dwFZA6pI6zPxhGhoLEkD/IAzpB5EHQqrp34AYHQe85b7cuPa3LqipQb4s?=
 =?iso-8859-1?Q?Y/Ni5dKXOWPdQ0rFQZNwopAD6EfhEjMQYhSorKlgQ9zRvjX6SULN9+4F3u?=
 =?iso-8859-1?Q?jllG2X2PUyKT6O6NGsJ2XhT3qbIlM7WFUoTuZX0v9h42x/zHNLAGLzDdqF?=
 =?iso-8859-1?Q?ngk3fMFTCYu9enIo5I4EzE4aDXO3+CKUGOPXxDg86XwmBazZBh/GCD/w/+?=
 =?iso-8859-1?Q?roPWr/BtFbrj4IP9pUi7LZy44BGenvVf+Ut3etBSAz8PchVvpl0RXHzjcp?=
 =?iso-8859-1?Q?mofMQoyrIWht/PrkbcVJxZXdiTOiEe6R2qqJa8UYDOTlQ6iD6cCGiN5Xdr?=
 =?iso-8859-1?Q?jfWLWclT25BkL8VFfD8xyBt2/jUKpuXUVohe3ZcWXHL6RWNcwI8MXuHuAP?=
 =?iso-8859-1?Q?y+Iy3W1cbHiQiItSySP/62PHX5yBndvE/pzXDLmzy3JEr6UpvptHNkjm3Q?=
 =?iso-8859-1?Q?vgXf9gJQIRmcaMjMxLbnB5YeP95Towoaa+SmSisMAj9F/oT0F9NRCS8cfK?=
 =?iso-8859-1?Q?DjCXb/LTZivg64i2kBUl7kzl9jygTzOWORBkY9Df/PQiJ1DQ83YGeebUDE?=
 =?iso-8859-1?Q?jwqKomv/hVGzi1WHYL9h4Bkc4jJyWLKzDvpYM1HeE4/YkeKQPxs3IcFwwX?=
 =?iso-8859-1?Q?N8x5tndmim5+iR5EPRV+cls7nUVqPFcmApKRnI0ptrvnLWHpbJiF7/XAnG?=
 =?iso-8859-1?Q?vlvuaO67f6Dm1Hl7kRsWXjsVi292GAnSCDmgTljG0TVCIGgL3ue14zdKhQ?=
 =?iso-8859-1?Q?RolsKNOSGCnu5IXOmg0O4UJsJ1owlnWEeZGEQi2i1IbCynZT3BWwoqXpMq?=
 =?iso-8859-1?Q?aGw4WRABSlBnpbnWT7KMeGJbvqFk1zdrrDrnSZNcTw8DxVPq9pdFOuZ7KC?=
 =?iso-8859-1?Q?hZ6SuyYUXnBUF6FtEF8IfpJ72HNnGADx71?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bertin.group
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MR1P264MB1876.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f5813b2-527c-41b9-b96d-08db7d51e5a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2023 12:18:10.1891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1e10334f-2f1e-4a9a-88e4-9bf591d1ddb5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pyLBi7Y0o6nmZBMdsjR06Sz5Cdj07sgKldhwXecVKPvuMVozBv1AZw77f9kI8i+32XquzXn4BMsubnf3tsq1NfwH74yltx+BK0mg9A9CaPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB1612
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,=0A=
=0A=
I'm currently trying to add cryptodev support for Xilinx's HW accelerator (=
zynqmp-aes-gcm) however one question was raised. =0A=
Why is the priority of the hardware accelerator lower (200) than the softwa=
re one (300) ?=0A=
Here is the pull request in question: https://github.com/cryptodev-linux/cr=
yptodev-linux/pull/86=0A=
My tests show that the hardware accelerator is at least 2 times slower than=
 the software one but it frees up some cpu cycles.=0A=
Is that the reason ?=0A=
=0A=
Cheers,=0A=
Victor=0A=
 =0A=
  =0A=
=0A=
  =0A=
=0A=
=0A=
  =0A=
=0A=
  =0A=
=0A=
  =0A=
Victor DUMAS=0A=
=0A=
  =0A=
Engineer=0A=
=0A=
  =0A=
victor.dumas@bertin.group=0A=
=0A=
  =0A=
=0A=
 =0A=
 =0A=
  =0A=
=0A=
  =0A=
=0A=
=0A=
  =0A=
=0A=
  =0A=
=0A=
  =0A=
155, rue Louis Armand - CS 30495=0A=
  13593 Aix-en-Provence Cedex 3, FRANCE https://www.bertin-technologies.com=
/=0A=
=0A=
  =0A=
=0A=
 =0A=
=0A=
=A0=0A=
=A0=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
