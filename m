Return-Path: <SRS0=i+zF=BU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A2D7C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Aug 2020 10:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B1E120658
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Aug 2020 10:20:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rambus.com header.i=@rambus.com header.b="BlSMLHSe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgHJKU3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Aug 2020 06:20:29 -0400
Received: from us-smtp-delivery-148.mimecast.com ([63.128.21.148]:43132 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725846AbgHJKU2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Aug 2020 06:20:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1597054825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wdPHUdLgoITcjMmvFy6Q9J8k3dKrWILdmzSW2M8hHME=;
        b=BlSMLHSerXaR09O9HzoNSB0dQybTTEruZ6tykaZv5i7/aNDEkxztVgs8whUu3rSuCOAqnw
        h96bV+iAn8JLvCcfRQmbLyHTwgI7/OukG1NBk/eJvCmsQLBt4kBX98SAoNQSDTvI3YDAlR
        traP1JZZGP4rZiLFH1r+AlCgtje/U/E=
Received: from NAM02-BN1-obe.outbound.protection.outlook.com
 (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-TNcdsf2NPZ2mqrPq7GA2qQ-1; Mon, 10 Aug 2020 06:20:24 -0400
X-MC-Unique: TNcdsf2NPZ2mqrPq7GA2qQ-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY4PR04MB0201.namprd04.prod.outlook.com
 (2603:10b6:903:39::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.22; Mon, 10 Aug
 2020 10:20:21 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::a0ee:e26e:64fc:61b2]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::a0ee:e26e:64fc:61b2%3]) with mapi id 15.20.3261.023; Mon, 10 Aug 2020
 10:20:20 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Andrei Botila <andrei.botila@oss.nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@axis.com" <linux-arm-kernel@axis.com>,
        Andrei Botila <andrei.botila@nxp.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: RE: [PATCH 19/22] crypto: inside-secure - add check for xts input
 length equal to zero
Thread-Topic: [PATCH 19/22] crypto: inside-secure - add check for xts input
 length equal to zero
Thread-Index: AQHWbNc/iDlrjFSjSECEGLk+jBQoDKkxJAfg
Date:   Mon, 10 Aug 2020 10:20:20 +0000
Message-ID: <CY4PR0401MB36528610C3ABF802F8CBF35FC3440@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
 <20200807162010.18979-20-andrei.botila@oss.nxp.com>
In-Reply-To: <20200807162010.18979-20-andrei.botila@oss.nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [89.220.222.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51b7fcc0-d42c-47a6-f87e-08d83d16fc79
x-ms-traffictypediagnostic: CY4PR04MB0201:
x-microsoft-antispam-prvs: <CY4PR04MB02010B1EC4B353D56A532A6BC3440@CY4PR04MB0201.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wYycDT5wp0iUnyD4UoVeYrXm9mG5Y1ThG/tiinEkUoo//Tq22iLCiHJ7R4mDFma7LVO/xvDjyLeu6F9PhnWCeyB+jK6NYsHMs2hMUu7lLvN5YB9PpnJkxnBjs+drmvPtqQJvw/Ad9JmhPb0VT/KB5yzcP/0xBxycUIzMV8DqX9zM8EQ8xdYtYfYWF91c/so2N6Ybis2266Bl85Gll7ytTuiKIUQf+gHGq6V9SpuUlcTm+XdJBJWmPlos6OZivVQm7uDPwOdNkzByMU+HSuXSX/OOWr+aGNkob6sHGCzMACPrHBc92a89QWcvJYYuj3z5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(39840400004)(396003)(136003)(346002)(376002)(478600001)(66946007)(66476007)(66556008)(316002)(52536014)(54906003)(66446008)(64756008)(110136005)(83380400001)(8936002)(4326008)(7416002)(8676002)(2906002)(26005)(71200400001)(186003)(33656002)(76116006)(7696005)(55016002)(86362001)(5660300002)(53546011)(6506007)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: e3zwTi6Mbu6vPpF3rZQjQPlmoycSUXeGZ4EdQhjVGwGcqtDyYMQmfej3PpBXXqg0bCI9qWAmXVgTQbvT6pB+obPtpERAwG3ye8KCPD0QXbhDwgIN7V13O2Z6ii80Wp/AYWqTR3lr+8IHNqnSfnEXDsQvz5sukjT4Vuhe4gxs8IRlaHhGJVhLKE+z5nLl3G42UUQBKBGqFvWJy+U9QzxPLyapIBeyjwpfTDiYmxbuLt5omNtenX90ofKwnCSpNyWz0hvL1QjZkYv0j9mT25fGsRtxBWFgrSAi8FJJli46ViiZdOCtt6TW+C0SGMqhDZESBIR3E5PQ80gAZtbZa1y9oTugL5lmSbLhpIJnPGI2pzJK9CDNz0ZCFct5Pfe+nZUOV9PoJTS5t+IsYsTT9/L/dLxGWBNNiTeue8DXbxFrEiTG1nTKF7oRSe6vb0DIHiOXbFRLso2UpsHCG1uEagB4qAQIRF8MuOB3XfFi6piaSYhRFs3pjN7COKb6YpDIiWynkC3ko8yWg6IWZAOXepiLmS8/DrGb6l/oRWMza4lk4rGG/7JGDk7O7c4hlFaWhbM+Fntm+pCBDtFhAIPEx9fkfPL9QR4tOBO6FQxXSpjK6X/Hx/o4WJ+oqxqbu1RwRq8DiDwKcx1PUiJPGqMu36NWxA==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b7fcc0-d42c-47a6-f87e-08d83d16fc79
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2020 10:20:20.4843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2+83ez5vIVfG3scjY2OX2a+wrcfl9ARrAZXNHKbK4wcEgwyew4TnTdcG6x/Hv2DrkD8bOjunyeAzWTPH3Eq1OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0201
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA48A24 smtp.mailfrom=pvanleeuwen@rambus.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: rambus.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of Andrei Botila
> Sent: Friday, August 7, 2020 6:20 PM
> To: Herbert Xu <herbert@gondor.apana.org.au>; David S. Miller <davem@dave=
mloft.net>
> Cc: linux-crypto@vger.kernel.org; linux-arm-kernel@lists.infradead.org; l=
inux-kernel@vger.kernel.org; linuxppc-dev@lists.ozlabs.org;
> linux-s390@vger.kernel.org; x86@kernel.org; linux-arm-kernel@axis.com; An=
drei Botila <andrei.botila@nxp.com>; Antoine Tenart
> <antoine.tenart@bootlin.com>
> Subject: [PATCH 19/22] crypto: inside-secure - add check for xts input le=
ngth equal to zero
>
> <<< External Email >>>
> From: Andrei Botila <andrei.botila@nxp.com>
>
> Standardize the way input lengths equal to 0 are handled in all skcipher
> algorithms. All the algorithms return 0 for input lengths equal to zero.
>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
> ---
>  drivers/crypto/inside-secure/safexcel_cipher.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/cry=
pto/inside-secure/safexcel_cipher.c
> index 1ac3253b7903..03d06556ea98 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -2533,6 +2533,9 @@ static int safexcel_skcipher_aes_xts_cra_init(struc=
t crypto_tfm *tfm)
>
>  static int safexcel_encrypt_xts(struct skcipher_request *req)
>  {
> +if (!req->cryptlen)
> +return 0;
> +
>  if (req->cryptlen < XTS_BLOCK_SIZE)
>  return -EINVAL;
>  return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
> @@ -2541,6 +2544,9 @@ static int safexcel_encrypt_xts(struct skcipher_req=
uest *req)
>
>  static int safexcel_decrypt_xts(struct skcipher_request *req)
>  {
> +if (!req->cryptlen)
> +return 0;
> +
>  if (req->cryptlen < XTS_BLOCK_SIZE)
>  return -EINVAL;
>  return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
> --
> 2.17.1

With all due respect, but this makes no sense.

For XTS, any length below 16 is illegal, as applying CTS in order to handle=
 non-cipher
block multiples (16 bytes in case of AES) requires _more_ data than 1 ciphe=
r block.

There is no benefit to explicitly check for zero length if there is already=
 a check for
less-than-16. That's just wasting CPU cycles and  a branch predictor entry,=
 for no
benefit whatsoever. (except for academic "alignment with other ciphers").

XTS has very specific use cases. No one in their right mind would call it f=
or a
situation where it can't be applied in the first place, e.g. anything < 16 =
bytes.

Regards,
Pascal van Leeuwen
Silicon IP Architect Multi-Protocol Engines, Rambus Security
Rambus ROTW Holding BV
+31-73 6581953

Note: The Inside Secure/Verimatrix Silicon IP team was recently acquired by=
 Rambus.
Please be so kind to update your e-mail address book with my new e-mail add=
ress.


** This message and any attachments are for the sole use of the intended re=
cipient(s). It may contain information that is confidential and privileged.=
 If you are not the intended recipient of this message, you are prohibited =
from printing, copying, forwarding or saving it. Please delete the message =
and attachments and notify the sender immediately. **

Rambus Inc.<http://www.rambus.com>

