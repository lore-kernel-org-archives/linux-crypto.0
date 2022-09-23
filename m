Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 136BAC54EE9
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Sep 2022 02:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbiIWCfw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Sep 2022 22:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiIWCfv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2022 22:35:51 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.129.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007F71162E3
        for <linux-crypto@vger.kernel.org>; Thu, 22 Sep 2022 19:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1663900548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=SbHq1wlfXy+Wwlzyaxm12qKhl5UTRn8gw/UuFu7KgIc=;
        b=k4t9rVgrKXUgtASndEGdH3d9IfZfAfxUD5VqxYrWvtx+H4oYS8vad6AnMceTgNMZDtQvko
        ljhTCFvMMfgX4YIa2cSJmtlo1s46tsFufw9x3hfCu6xkLLEQLxKuU/oafDVytWi2fLHsOc
        I/EPbxTI1EkHPlXjQ9gfTxQZjUNv6qYIgI5sxDhxvAHu7lmk9pNj8yZVf3OlDU0rpYUIU6
        1hGCou66maeqoPbhxb3ZjI/7DZeijujvSOT1qxqowAHLz9o+riIo4bqtuazZ3iwr2KfUvc
        2w2gzR5+Nu1tZj+05ooTht/zuZv9OAuggDpV/5455b5+Rk750MN5F2pu9cbmuQ==
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-frn4NQjjPQKYl0HOeYuB5Q-1; Thu, 22 Sep 2022 22:35:46 -0400
X-MC-Unique: frn4NQjjPQKYl0HOeYuB5Q-1
Received: from DM6PR19MB3163.namprd19.prod.outlook.com (2603:10b6:5:19a::23)
 by SA1PR19MB5668.namprd19.prod.outlook.com (2603:10b6:806:23d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Fri, 23 Sep
 2022 02:35:45 +0000
Received: from DM6PR19MB3163.namprd19.prod.outlook.com
 ([fe80::d02e:2c4b:c65b:36b2]) by DM6PR19MB3163.namprd19.prod.outlook.com
 ([fe80::d02e:2c4b:c65b:36b2%4]) with mapi id 15.20.5654.019; Fri, 23 Sep 2022
 02:35:44 +0000
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "atenart@kernel.org" <atenart@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        linux-lgm-soc <linux-lgm-soc@maxlinear.com>
Subject: Re: [PATCH v2 1/2] crypto: inside_secure - Avoid dma map if size is
 zero
Thread-Topic: [PATCH v2 1/2] crypto: inside_secure - Avoid dma map if size is
 zero
Thread-Index: AQHYwZuhWToE3i/+MkuyVhPHlEoUrQ==
Date:   Fri, 23 Sep 2022 02:35:44 +0000
Message-ID: <DM6PR19MB316310D792AC2839F7A1A5DEA1519@DM6PR19MB3163.namprd19.prod.outlook.com>
References: <de6de430fd9bbc2d38ff2d5a1ce89983421b9dda.1662432407.git.pliem@maxlinear.com>
 <Yxg/lipSWadoeD6E@gondor.apana.org.au>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR19MB3163:EE_|SA1PR19MB5668:EE_
x-ms-office365-filtering-correlation-id: 70b92c64-2d4a-4ba6-1c2e-08da9d0c50d7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: YIJ0f95XhaXw+OTfVk08I75vknvA8pFYMd5nbNTbyQe6TXmBAIihPYv2J7t+UGk5bpraT6/T0IBMe0lKBOWHRZxoNhI+01ZBKE2l+v7vjOtd2FdtIr9/Oks47fW2FOuE5jEDzratLSxbq/KVppGpwVCr0i7lCCx6WoZrKrBRTuQl/8E7ZQ6SiZs2PQJ+5HbdbsgghWHfW3oKEggGOJ/rYzLBawWGmapofwSrlPXEX9nNCFw2CikoAZXw8OLW6Js4vkq0Ss+vkdhavkbhlVSWZPuRpCs6Jg98z64/b59jnXiU1dQfqS201WpyGYF4C9dmK9/+KD/xU3FP3jB50ZfOlqguu97GCJcrPSFDwFjPfS2+7gcbayYGVMYYJgyJaYOcIDWE+ga6X9c2o1/pRlpzewQO/v0RAYYf6aORg9aH0IOL0chQo3XeESctJxwRHf6zOEbJ1AzzleOtlZ6rzL8qeK48pUgxoumzx7X8IcpL0jiOmacXburA5onYlWJ89207AqzcDl2/6vzflmwSvW3+S6KIjasypw+1ZpKnLPWbMvQ9FP6Q5HvGZb7pCKO28kR0NF6Zj67W0+Rq9gRdMvn0XwQ3PLsGzyPhPvOeZ74xdwwZiQ/s9JJ6S/CnhM9DdUSCwx4HTAUddy1VACD5jX889B7W9zifscLTxeO8Z1qZ7ieYeXpDdFrPvh9RQBjsFovGdyFh47IYK7WCxZ6A9HQ90f8M+SXSaQ6tu62glXO+d4hjUcZ6yn9EzCYwIS7qxdFJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB3163.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39850400004)(136003)(376002)(366004)(451199015)(38100700002)(122000001)(8936002)(5660300002)(4744005)(2906002)(186003)(86362001)(83380400001)(54906003)(66556008)(38070700005)(64756008)(41300700001)(6916009)(66476007)(107886003)(7696005)(478600001)(71200400001)(66446008)(52536014)(91956017)(76116006)(4326008)(55016003)(26005)(8676002)(33656002)(316002)(9686003)(53546011)(6506007)(66946007);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ej4EK3FrZpTiGNtUIl0A0zzwOr7YViq+8Bq1Ah+Kn53px3mZPAVhSLYs4wMZ?=
 =?us-ascii?Q?JGyuVf+CMSI5gDtBzKNHLgJ/66fvcMJ0A1EsELec2WnrMZwq/G7AZ46X9IKJ?=
 =?us-ascii?Q?f7co4S6mbl4U5N2+v/O2j+9okb9w3EqSzu4IQqKJMiZ2VJ/w+2fUy+Dx4yt1?=
 =?us-ascii?Q?ePCvqc2UCsCLM66//BTxWcXiJm0zfOeaMzq5RRqF1oeLBdHg51n1X2cQnV/F?=
 =?us-ascii?Q?JwXYGqrHHAcybPzN73N7h8cAzjLrlX/rSI+yk15c163ZFf1fwneaskQEPTlX?=
 =?us-ascii?Q?A7FWjWxEB2a1/3rdYdskbl2ozLvVksriyLWw0JPVxXJCot8CH5EuGLDeptk/?=
 =?us-ascii?Q?y6maWTpvF+r/w3fctiNLtHfKOYPX8QCWU287ephSK/UFZ/yuO1E+5wtDLow9?=
 =?us-ascii?Q?vjKVUcS8y3deG7eaXoNqQG6wN2/9uCNW7nuBx5JGc8n0um0SSyaPHpZMgGrG?=
 =?us-ascii?Q?TrUtBN9NFXDnCoUVmKhg778RBpy2qIXsJbGd4oX6oU0658YqjG+Xo0j9QxO9?=
 =?us-ascii?Q?vCMXI5L3cveUL+dv7LPG/vIvqKqvEOYHonpPnNEQTpkoaI9ONjaUp1Tv8ycq?=
 =?us-ascii?Q?s+qCXi1YRPB1g0h7fx/W0hhWfs6ilPnWK+bqaZVdndRG3i9XH/B/ABa5yLGj?=
 =?us-ascii?Q?RlUUN0OViBevEoLW39Xzgi3+XjU3BfM6nKXOBoUjJEkO91IXy71I6U7Eu63m?=
 =?us-ascii?Q?vXg92bcZVxBOfnNr+6u+uO89/qL2uwk2StYqDjrdoGPYi+fIrpF71UZ59md2?=
 =?us-ascii?Q?fRemL3DdnRciF83w/4CFfcFLriJ9fOeCSVbZVLOeslrFRwfwMx2PP7jfWtYV?=
 =?us-ascii?Q?ueQTMqYfOC2+vme87Epk5+gO4pp5UV/9dr8rxt2PF98Nr/2LNHqZoEpwIA3+?=
 =?us-ascii?Q?sYpCt1R72CZzI8gdlN/595+3qqkdTT6RpZnwneqF8gjXTFK4/8bVW9+Xc1/t?=
 =?us-ascii?Q?KLBvobdoxFUd+vAgujyYqhiNPAaUVqdXKnIsAbCAuGmlKra5DoCVAMnEn6u2?=
 =?us-ascii?Q?JPz2nKnZss3+I31d+1DB75dQVzih31e6KI8uO6GNuqbZgCC1FX/3og6WamVi?=
 =?us-ascii?Q?L3E7EVHfUfvM+zlG9/VK7yGe79IX+iCebOImcNTNfqk9ifmJh2ludGjtCnkp?=
 =?us-ascii?Q?9oVayK4+G18QJKIwbvQCdrLH8b7NyGnOWmNtQUbIu/TGUZtJgQA+3eL0BnBn?=
 =?us-ascii?Q?MaZbyARG2VT8+J773jbaKj9/OYuBt1dttEt11ZUqY84/dRC1HfB8AYoGarm4?=
 =?us-ascii?Q?+sEu1YvcYN38cqkryHX5ekeBj6HLmcQlJ5GXxvYZwoN4J52YKqFHCDCvFVKu?=
 =?us-ascii?Q?QGw1fm3HY9d5y2cwUOPLZCudKfYf02PNO1+F5IaWhbWOewUvmqVc/03w7sCS?=
 =?us-ascii?Q?nP0NBN2JWIHT4ntZ4neI8ChEewnAWBk2gz5rKG8AAmgSXFeZiw6vS+oHt8Pn?=
 =?us-ascii?Q?zvEX98Alnf2JF5Foi3x3ZV9mUV011TWAAEXRhRwtPslkGj+5/2z9TtUtUhwa?=
 =?us-ascii?Q?3DtAP06x5UUQICz80w5VHwyf8ypeInreW+AIi/LYJxon8HHEuqNZshahbOdD?=
 =?us-ascii?Q?vz9dP3T0v0Fp5B3xa3r9YE1/OxZ8apR+MS1Mpm3n?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB3163.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70b92c64-2d4a-4ba6-1c2e-08da9d0c50d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2022 02:35:44.7320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t39yUwMqs+zlOB/bz8Xc3LPLW8rzV1YQSFx/t667ZAS1NmUp6PUVGbr2pcRPB9hHumTEu0oBYTe0UdqINqezGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR19MB5668
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/9/2022 2:52 pm, Herbert Xu wrote:=0A> On Tue, Sep 06, 2022 at 10:51:49=
AM +0800, Peter Harliman Liem wrote:=0A>  >=0A>  > diff --git a/drivers/cry=
pto/inside-secure/safexcel_cipher.c=20=0A> b/drivers/crypto/inside-secure/s=
afexcel_cipher.c=0A>  > index d68ef16650d4..3775497775e0 100644=0A>  > --- =
a/drivers/crypto/inside-secure/safexcel_cipher.c=0A>  > +++ b/drivers/crypt=
o/inside-secure/safexcel_cipher.c=0A>  > @@ -737,14 +737,17 @@ static int s=
afexcel_send_req(struct=20=0A> crypto_async_request *base, int ring,=0A>  >=
 max(totlen_src, totlen_dst));=0A>  > return -EINVAL;=0A>  > }=0A>  > - dma=
_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL);=0A>  > + if (sreq=
->nr_src > 0)=0A>  > + dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIREC=
TIONAL);=0A>=20=0A> Where is the corresponding check on unmap?=0A=0AAdded i=
n v3.=0A=0AThanks!=0A=0A

