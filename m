Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED455C32771
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 03:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiI0DTC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Sep 2022 23:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiI0DSf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2022 23:18:35 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.129.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0029F855A1
        for <linux-crypto@vger.kernel.org>; Mon, 26 Sep 2022 20:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1664248625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=0o4BTnNa2d6Zn/BuTMKNiov47z5LKJG8v2S+UHbT4EY=;
        b=qIaA8Iuyu1smM3aJLwJ84D6/AdW3l7ICA+s5VSThroA5TDSvK4pzDWSjPdazXAJPXac8S5
        8FR7mPf5VxghWceNSSPV0Dan+FZZMQhIwmcdoiJzMeF7c4d4eDFvrn+GiWEkj1kyC9VzM/
        1zxYUQNNilZsOHP9JTIbMEcoO54+QvHQktANUm3mimAC9GtgMTL/AAgYt3/C4cPdeXXyrc
        lkEGk8+GXDBExHDUzh8T9uWm7dWA2aGwSd8AChUiAnM5ballhJ+Zge17G+UqpTAwpTV76c
        NbFIzEOREQfGS5Ip8mjF8P3AtNSpcD9W+zZi1dvXaUiwrcfxK0ReswqbjsdFEA==
Received: from NAM10-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-hEzdPG1rMQyLZapAwdZPZw-2; Mon, 26 Sep 2022 23:17:02 -0400
X-MC-Unique: hEzdPG1rMQyLZapAwdZPZw-2
Received: from DM6PR19MB3163.namprd19.prod.outlook.com (2603:10b6:5:19a::23)
 by PH0PR19MB5346.namprd19.prod.outlook.com (2603:10b6:510:d9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 03:16:57 +0000
Received: from DM6PR19MB3163.namprd19.prod.outlook.com
 ([fe80::d02e:2c4b:c65b:36b2]) by DM6PR19MB3163.namprd19.prod.outlook.com
 ([fe80::d02e:2c4b:c65b:36b2%4]) with mapi id 15.20.5654.026; Tue, 27 Sep 2022
 03:16:57 +0000
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     Antoine Tenart <atenart@kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        linux-lgm-soc <linux-lgm-soc@maxlinear.com>
Subject: Re: [PATCH 1/3] crypto: inside-secure - Expand soc data structure
Thread-Topic: [PATCH 1/3] crypto: inside-secure - Expand soc data structure
Thread-Index: AQHYzMc6iqtdBZ+VvU+yV/J0URY7ZQ==
Date:   Tue, 27 Sep 2022 03:16:57 +0000
Message-ID: <DM6PR19MB3163C89AA7963DFA66DB08C4A1559@DM6PR19MB3163.namprd19.prod.outlook.com>
References: <cover.1663660578.git.pliem@maxlinear.com>
 <131f0d802d4e251dd8f98672260a04c2f649440c.1663660578.git.pliem@maxlinear.com>
 <166392414185.3511.12102278740497366855@kwain>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR19MB3163:EE_|PH0PR19MB5346:EE_
x-ms-office365-filtering-correlation-id: ee55ffc5-2300-4b4c-e011-08daa036bc3e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: kHpGNWx4UW99HGEwaj7FHcGBVVgSJJTi0a+274al1O5KT/iDBX8v6Iu3SH5Wywdij+8EgkHzpzY8pNxSDqzij0KBK1N1OVn8Qr6SS302Ys0dBUMPV+xm23LXl96CdEAOUzqssJ6JT19mq+ebXlNZ3Z4JigWBZAtb8d4iBPBlzgUSv9AbIhESwklu2BH2zUO0gosNtUQIQ4YRrmxvlRHxAcBWcYQw8fgkGcI+LA917IQ2unHAlW3l3O5zUq5E0eGec432Qx5eEDHpmh3QwA6J9BhM1qqYTMsNQcvDX7z5x0meCDfgWYkoutM1ZWMfN07PP/wz2yyNOK0nRkzYQKSvGcZPKPvG8BV4prr9FosvofD1AY6M/vzAcSaTt7jzmpOzaEUSDugG1bMOaR0TNJipdv5LQn3UPzMiRvfkUryS+3wswPaPibRngiwjnh324PIUhwgTc5mQdc5EHanHQg5iZ6LC1X4ZkKuyu6TbSjt1TNmoLFjqx4vthXMoPdIqIR0X7PKXsbfsa+SEXXpYxhGZJt442OZD4MNPZ50NxzirHfWY+iLgf72GHQZ7ci4NOXDGnGoWoNEZA/F6yfAd5kHLQXnbSzc0Q+WOLpf1R65Ao+dpA6a4yjEDiXcX9nyGuWqftxP4cgmSvDkM1hfG0HHuHG6v1doUIrtLtRnUhYMOMgeCQJD1Xoev0YArCa31+76y5+bsd80jDP7AubwYnSUT6cVJpcQ1sHFojCZ7qq+/Q9VHovmzwP3jAaSNoY+cu9jBdyt5sj06NvdvTMkkdtBIJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB3163.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39850400004)(366004)(136003)(346002)(376002)(451199015)(86362001)(64756008)(66446008)(66476007)(66556008)(8936002)(52536014)(33656002)(5660300002)(4744005)(2906002)(41300700001)(66946007)(4326008)(76116006)(91956017)(8676002)(54906003)(316002)(110136005)(38070700005)(55016003)(122000001)(83380400001)(38100700002)(71200400001)(186003)(9686003)(26005)(53546011)(7696005)(6506007)(107886003)(478600001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FuHjUBCG1rOr9Xc9oQRXeVm1uHmSUFEcN5Ydm2qVRwn+JpxmdTqZ0kIJcw2N?=
 =?us-ascii?Q?ylLKLKBEUkz5IJySE3z/j9rQdWdbb2JHy31IrhnhirBCBx8ohiyS7t5wY842?=
 =?us-ascii?Q?SfQijdLgsLoc2Wbqlb+mCccKzSOx1jyYdg19ohLbwgDNLMoj+pMM7jL9N11g?=
 =?us-ascii?Q?dI51s0hex58kdCzVouKGiBCKqntFBZ4MZba8gmQgjct8GFEhyGfX26GbnOvZ?=
 =?us-ascii?Q?UN6KffbJwhsmvofYGJc+AofY0vtcKiWLb+95pYhFVAWuLFlX6vJMt2ghb3Qz?=
 =?us-ascii?Q?iJJ0YSjvWcZ15+f7yi6XrdT2IsCLI4CKMVpPrTpbW7xRUoweBe8fzIQT6WKk?=
 =?us-ascii?Q?HQ4uZ/jHosdnFgOr1/MxBOYSuBKQQlGbcO0Qdl3iogIFwhp6/MHEJPEL9TGG?=
 =?us-ascii?Q?C8gvums6EJnAeXe8g+0Wwe0jawUFqmZi1OLxonf5dWMiHQhyMYOCUtvvfAeJ?=
 =?us-ascii?Q?IXoPKXuWNS7PEZAVbysFOghXrzijkC+ZfnGhhsSSmxO3o5jPIQA99fXSLDVx?=
 =?us-ascii?Q?fUflwRddhfk3V5bUa0dSq85qSu9wxg/Ks2mBtEzRTX0Dx8REiMtPQSVvXMeP?=
 =?us-ascii?Q?3HVdFSEvL5hSAWWwBzYrVBf+9FZCap+k4/vL3ZnWb0gS2d/oPw676xgi7HFm?=
 =?us-ascii?Q?v84v7q1zLtrkMzp+klx+lKsb4FdhJFU31CEqytHSFHTrXjJSYnyRq35Fq7JP?=
 =?us-ascii?Q?LOMH1CnSMTsdYzODnkDFy60t3Um1z0d78SuVHOJdF2XZlKMJEEAL1JO7B8Pe?=
 =?us-ascii?Q?26XFyaXCMZ+mY3ELHp79GocccGfAoDNrVQgaHkWT/hjVR+ie+D2VeoHVGGA5?=
 =?us-ascii?Q?WqH9sxVB58fKlwGQrysC97khDM8f85D62zRf0d7XMNALNIn+yJWkDzy8NvOa?=
 =?us-ascii?Q?7NbTJb4uMf3NetIA6jXrVlZGQ9ZQpvZi4M77wy9rTpYxe13gpQ1TzPyoktzY?=
 =?us-ascii?Q?/Jkv8QuQjdMu7CEjImCc8vDXRlhN/IJdn4B2kxRXoQ2M9tREYFAdbdVCtoyi?=
 =?us-ascii?Q?UqKEKV/u6+4NjlgiSnJEqaTVBUavKT/S8wEp/+8zJoawx+pNkYfxExYPPwkg?=
 =?us-ascii?Q?UCFWGiXZMa51YmIuwFMIABO9rYW9YIdtBYeK9iEjUPGyJ6yhIuYTSKbz8DbC?=
 =?us-ascii?Q?4G2/QbFZ2IoN3XHGlGFdnKREAtWbUiL4PurmQFgzEJqn9YiSrusAojk3zGA7?=
 =?us-ascii?Q?60TtXq+xsfQkE/w6bEgSIufcUiaJr1EWpUC3LPkfaS4tcujMlSoK2chO/9F+?=
 =?us-ascii?Q?0QbMjvPlEn2fiNuUbcqQOD4AGbFS/FV+NJbISHz/iJFlnQ03UsH/mxswcY7T?=
 =?us-ascii?Q?igPGq/cku7l1/B0RqYkecYoaYEHXigyjrQrit8mNHQXXFl+8O15g7rYw9cbb?=
 =?us-ascii?Q?xL5LxsS6EcA/H3mtsuitBLjtp1L8QAqfegkyZm0sChthUupDZguEnds4GgY8?=
 =?us-ascii?Q?Y1ljEfx7Bxi8ggBW3tVKIslu7dGrSpEK1kDrUySzsuVYZZFRq1zyq9B+U7jm?=
 =?us-ascii?Q?fe7sd/1tv2zD6DJLlVYTikcK4cbJWunkNjVr9m6GqMTQWnNiecHAU27MwBzC?=
 =?us-ascii?Q?hnNW2fJC7i9vTYyElNYhqiBbktpUDVGvt5NCdIFsUyJePrzMTe+Om+F9mYB9?=
 =?us-ascii?Q?Fw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB3163.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee55ffc5-2300-4b4c-e011-08daa036bc3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 03:16:57.2949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1u3sEXBWbpWX1tTF6bBv72xNDvpF3KwJZZry2hB1NCkPxhKPRROZsE/4tmOzzzJBu75fEOeTYnPCZoYtWqd+hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR19MB5346
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23/9/2022 5:09 pm, Antoine Tenart wrote:=0A> Quoting Peter Harliman Liem=
 (2022-09-20 10:01:37)=0A>> +       default:=0A>> +               /* generi=
c case */=0A>> +               dir =3D "";=0A>> +       }=0A>=20=0A> Why "g=
eneric case"? We shouldn't end up in this case and the logic=0A> changed af=
ter this patch: an error was returned before.=0A>=20=0A> The if vs switch i=
s mostly a question of taste here, I don't have=0A> anything against it but=
 it's also not necessary as we're not supporting=0A> lots of versions. So y=
ou could keep it as-is and keep the patch=0A> restricted to its topic.=0A=
=0AThis change has been removed in v2.=0A=0A>>         {=0A>>              =
   .compatible =3D "inside-secure,safexcel-eip197",=0A>> -               .d=
ata =3D (void *)EIP197B_MRVL,=0A>> +               .data =3D &eip197b_mrvl_=
data,=0A>>         },=0A>>         {},=0A>>  };=0A>=20=0A> The pci_device_i=
d counterpart update is missing.=0A=0AI missed that. Thanks for catching.=
=0AUpdated in v2.=0A=0A>> +struct safexcel_of_data {=0A>> +       enum safe=
xcel_eip_version version;=0A>> +};=0A>=20=0A> The driver supports both of a=
nd PCI ids, you can rename this to=0A> safexcel_priv_data.=0A=0AUpdated in =
v2.=0A=0AThanks!=0A=0A-Peter-=0A

