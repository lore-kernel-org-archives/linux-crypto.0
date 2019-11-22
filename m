Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E0AEC432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 10:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2220220717
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 10:29:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="opR4kLhB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfKVK3G (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 05:29:06 -0500
Received: from mail-eopbgr00064.outbound.protection.outlook.com ([40.107.0.64]:14563
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726100AbfKVK3F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 05:29:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hmcwqQ9JmPhXRcOalZGV0SE6BycAJeMvJQlcYeUanjyJsDkSgMh7TzbNaIITlYx92PgAto2Fuv93zcZC1/2QQzhUnRguVlElTvlERY+oeEtZD+S7mWrUwKZTfRTqYLRkwElJck6PXtRAl/UKdYdvOIYqGsZS+NACLso2w6SxUewI5n5NU26IxMQQIJ9vX+Q+cQnzoYpvSAVB5yTpw0aP6WBNFnyQxQBWbkiNqpw7zu0XXuJ+X8Z5V4CccdP2WKGDAEGTsT2OtvUTrPfRxUBYmN6j52CIZDsxmlSObIh1IPVqpZOuVzygfxBn/M+bTRY4GpnJabO6YnDy5faKXhBnMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xONinID+61XcouhLRcRwWMJPxFFLJX5+v5st+wfYztQ=;
 b=Tc9+lAdb8aXbm1R9BJCDNEFBmcZYAJi4C/tfAY490foD2TdlVKgfjGPtuVmPvK9sCu/WirMD0xKCVt3WbW8wkPqr+5n6AMFN+LuPBl4gLMWde6WdAvPCXb+0N1MFAbSKTAAhIM1mIuP1/TbV0xFKPb4luXWb2vue+MEo7q4i5xvQ0rD1e3B8b6tDl87FiJKM8fgK9zEUuJ05sBJolTw910hzlPCjBcPOfdiImD+vRs+J8pyw5wha3xVfzwIkJ5+61jfZ94uA6i45ewViJ3N38Y4RYwgQl19OlF4ivYFZY5vROZIkfosrxSaiosKFkFAGLCnWOnxa3BP80F/GCtaadA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xONinID+61XcouhLRcRwWMJPxFFLJX5+v5st+wfYztQ=;
 b=opR4kLhB/sxY4iHxoXydBymZ7yiGaeNfAOL6ZRyHrkSOAyE7SjIF25HycXw4lKDTZ3ehaRgIFnHDsAEg6p4xz46idM6fF4EcgK1vkhP/jaIPrzeKLFp777Pgvv2SdMwAdT6mJfNgjvHYvrR0eT7qUwP1UKBbFvLUK+KKXkihEIs=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB6144.eurprd04.prod.outlook.com (20.179.27.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 10:29:02 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::f:e0f5:1b95:a5d]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::f:e0f5:1b95:a5d%5]) with mapi id 15.20.2451.032; Fri, 22 Nov 2019
 10:29:01 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 01/12] crypto: add helper function for akcipher_request
Thread-Topic: [PATCH 01/12] crypto: add helper function for akcipher_request
Thread-Index: AQHVnZazFVUFTJ6/6kmX8sqUgv70rQ==
Date:   Fri, 22 Nov 2019 10:29:01 +0000
Message-ID: <VI1PR04MB44458463C3FFBF7C2D99B4DE8C490@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-2-git-send-email-iuliana.prodan@nxp.com>
 <20191122090819.mv3txjoxmiy4flv2@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a9d1f8d6-cc4d-452d-9e53-08d76f36cae7
x-ms-traffictypediagnostic: VI1PR04MB6144:|VI1PR04MB6144:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6144BF74D2153135D2390E418C490@VI1PR04MB6144.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(199004)(189003)(26005)(186003)(256004)(66946007)(6246003)(4744005)(478600001)(14444005)(86362001)(64756008)(76116006)(71190400001)(66556008)(66476007)(14454004)(25786009)(71200400001)(5660300002)(66446008)(8676002)(81166006)(81156014)(91956017)(4326008)(305945005)(7736002)(8936002)(99286004)(44832011)(9686003)(76176011)(53546011)(6506007)(446003)(55016002)(6916009)(7696005)(54906003)(6116002)(2906002)(6436002)(33656002)(229853002)(316002)(74316002)(102836004)(66066001)(52536014)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6144;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DiXVgzVKPEIVk7N6x8/hKqudeScxtzgeKs1f9t2sngghmhCgTllirLDhKWfMJuRXAT4wSlxdxO95YKrgasFbHWGgX6y43H8yUTqKTslQiYWJWq5lzPIacCl2QtIr7R4dWHA0uZXJdgdLCPEUiQB6lORuzTg00oX1s9SkCyrngy+yy+MjzgHf2Nt8uDrya104IX8WpjOlBGKJ43Qnm3+nZGk8ZNyUDiRqk0MiWcTIgHwkEW2qX3E8F30C7c2gSLI6mN4Us/VW20q1OaSi5dJzRGkkNPtuKIIpZO9RTrgGyqF5CaNm1NH/+YKvbyfOdooH7jZQSmxsWPG1hS+MYW5o1/qeVPuhhD1waY6HBxsj7x3ymhn6nhsDyUhWaKpBNPYQ+PrdI6bwyCdkVBrGYw5NAxbNIBa9rCJsdq6bbFAS/IPOjkfrKLNZRyHFGjbpuQA3
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9d1f8d6-cc4d-452d-9e53-08d76f36cae7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 10:29:01.8040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ibp5QB+JL3S5etBipIT7txDa0VcteGoLNkI7snuSKLE5SSQ5LAafWtAfzInDIBU5e7T1d69hYplUybVY50bpmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6144
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/22/2019 11:08 AM, Herbert Xu wrote:=0A=
> On Mon, Nov 18, 2019 at 12:30:34AM +0200, Iuliana Prodan wrote:=0A=
>>=0A=
>> diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h=0A=
>> index 6924b09..4365edd 100644=0A=
>> --- a/include/crypto/akcipher.h=0A=
>> +++ b/include/crypto/akcipher.h=0A=
>> @@ -170,6 +170,12 @@ static inline struct crypto_akcipher *crypto_akciph=
er_reqtfm(=0A=
>>   	return __crypto_akcipher_tfm(req->base.tfm);=0A=
>>   }=0A=
>>   =0A=
>> +static inline struct akcipher_request *akcipher_request_cast(=0A=
>> +	struct crypto_async_request *req)=0A=
>> +{=0A=
>> +	return container_of(req, struct akcipher_request, base);=0A=
>> +}=0A=
> =0A=
> This should go into include/crypto/internal/akcipher.h as it's=0A=
> only used by implementors.=0A=
> =0A=
> But having reviewed the subsequent patches I think we shouldn't=0A=
> have this function at all.=0A=
> =0A=
=0A=
Why can't we use this? There are similar functions for =0A=
skcipher/aead/ahash and they are all in include/crypto.=0A=
=0A=
Thanks,=0A=
Iulia=0A=
