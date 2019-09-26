Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61D1C432C2
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 08:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E81E222BE
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 08:46:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="s7XNIa5t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfIZIqM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 04:46:12 -0400
Received: from mail-eopbgr140087.outbound.protection.outlook.com ([40.107.14.87]:17488
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725890AbfIZIqM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 04:46:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jgrcChpzB+9ZPKsI2ZGt8xVQ/GtokTWijIp/dmG6btwhtanwkLqtbu7RbW5sP5gK53j9nY7rnpHvddgoI5+PbSMwCBkTXfqcAYRGqfmGKyVCB9OcOSFMCGAHMuhj5KuuxlAYHrs+quXyApNEKiwa+hiBbJ9WV3CywciMHzkqxsFD8r0gmRi+9Xc6twnrG3Cgoonf3Xfc0NW3C/p+WYdtIBdaJzZAdm7BsPNmo3NZwfIw50/nkDDX7vHwYi1zJfasSkyZAAqqid9P+Jex4ckaZTDssjuKL7dISykZgw/m56DLjYcUCZCxd5GnfGAFojxVshlIEMAO13dL8uA2+wbD2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKBg3xVT5WYxa8yreXdCOOqJaeLIACB7fvKdfE82aYI=;
 b=GTfkZIvqjNcHYJAELDzD5Wmm7m5BdwE24+XnIFw/zxK1HoGMaD/drj7tORMvWNINEYvrLWSCLgNzRtKGoxX4rt5zeoTaGGa7wR433isxrRbG/BS1r/u2mMk2e48sGRdJL5DvvLRT+kOzFLbsE5fYDAz/pSm28C6cpg1u3djyB/PiNrLVF/L4Fo+8JOxquDeiUbcAyjQMNcbGVq0tEKgXwnZ9xE81KmmsCUfym81tx+dvD7GvWJPMlrdgSl0fhKFhIbaYL3qMbTrZGyFF7iXuAgu/PFluaX+E+IdDtcnPRmXowLYR+pyfmBP9Nyil0Vd82JCucV1YEfqPrw0c6U6ypg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKBg3xVT5WYxa8yreXdCOOqJaeLIACB7fvKdfE82aYI=;
 b=s7XNIa5tSumW9yK8cs6zlI8QPPNF75jxfOYPxP9/zrcaHf0yadChzeftgUoOhAW4gW1tCZo3JSVSp2VT44fBjEEZuo4P3WA13PgxsFmbc+ekHuDmpgDLJ+tGQ6epksBJHa5UJT8YXgfQ7PhEwAxL8Q4UDAVhqvjB7nwTUMZ6Gbk=
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com (20.177.55.161) by
 VI1PR04MB4430.eurprd04.prod.outlook.com (20.177.55.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Thu, 26 Sep 2019 08:46:08 +0000
Received: from VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::b0fb:6d6d:1cf1:1e8d]) by VI1PR04MB4445.eurprd04.prod.outlook.com
 ([fe80::b0fb:6d6d:1cf1:1e8d%4]) with mapi id 15.20.2305.013; Thu, 26 Sep 2019
 08:46:08 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: caam - use mapped_{src,dst}_nents for descriptor
Thread-Topic: [PATCH] crypto: caam - use mapped_{src,dst}_nents for descriptor
Thread-Index: AQHVc6HVRilcPP2scEWFlBN1yop6QA==
Date:   Thu, 26 Sep 2019 08:46:08 +0000
Message-ID: <VI1PR04MB4445C876D859CE81028D23728C860@VI1PR04MB4445.eurprd04.prod.outlook.com>
References: <1569416676-21810-1-git-send-email-iuliana.prodan@nxp.com>
 <VI1PR0402MB348551336691838632965ADA98860@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7819120a-5e24-4792-bab9-08d7425df994
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR04MB4430:|VI1PR04MB4430:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB44309144C603EF407E9C23708C860@VI1PR04MB4430.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:962;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(189003)(199004)(54906003)(44832011)(14454004)(6436002)(256004)(25786009)(476003)(486006)(33656002)(478600001)(4744005)(7696005)(14444005)(86362001)(26005)(2906002)(81156014)(66066001)(55016002)(8676002)(9686003)(446003)(6506007)(53546011)(76176011)(81166006)(66476007)(52536014)(6246003)(6116002)(3846002)(102836004)(229853002)(5660300002)(8936002)(4326008)(99286004)(186003)(66946007)(66556008)(66446008)(7736002)(64756008)(76116006)(71190400001)(71200400001)(91956017)(316002)(74316002)(305945005)(110136005)(6636002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4430;H:VI1PR04MB4445.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ApOMSmRHF0e2rLrD7EWI3ND0rtuFyojjBMjCBIYE5YuWNk6i7hqsiTxdftq7I2tzMzq3nipiwJf/Ua115/gOTqkqpRgbuzDLPcRIQ8DYmgYURmlrhq8juD6f8OPqO3bTinNTQWHwKspLpB4oZ/0Vy05VsYrWbCat6BtMaNZSFMh3IhevZ4K6Ju+hU1iNucjI71Na+ssjfqRD+vY3aEYraRovOatbvh3oMxfQPSM2xVWAKwOQHa5wCGM32s0kCU5S2bOB6wPmqDZhgBRU12zS2tYbJDPnJGNFiI5z87KaG2yR2dHf0I+jMt9ZUM3QUwc1WivCZSqDa8gPiJYw3eAZypIpdpcWE2FNmOG+bxsZegR7brqXaFXFFKfWW1Ng1+dI9RG8EuyESufoodGkbi7rnd8ED2xBO2xmgs01sbkOF4k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7819120a-5e24-4792-bab9-08d7425df994
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 08:46:08.1111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sjo7jPm7y5PCOP6tPwfQ1wVnZvCdoW0IvyvtzLrYg1FypLrGTNhIdzhuDJnKsJ8Ql/U5Sqb3YD2z1blsL7iEgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4430
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/26/2019 10:17 AM, Horia Geanta wrote:=0A=
> On 9/25/2019 4:04 PM, Iuliana Prodan wrote:=0A=
>> @@ -428,17 +433,18 @@ static int set_rsa_priv_f1_pdb(struct akcipher_req=
uest *req,=0A=
>>   		return -ENOMEM;=0A=
>>   	}=0A=
>>   =0A=
>> -	if (edesc->src_nents > 1) {=0A=
>> +	if (edesc->mapped_src_nents > 1) {=0A=
>>   		pdb->sgf |=3D RSA_PRIV_PDB_SGF_G;=0A=
>>   		pdb->g_dma =3D edesc->sec4_sg_dma;=0A=
>> -		sec4_sg_index +=3D edesc->src_nents;=0A=
>> +		sec4_sg_index +=3D edesc->mapped_src_nents;=0A=
>> +=0A=
>>   	} else {=0A=
>>   		struct caam_rsa_req_ctx *req_ctx =3D akcipher_request_ctx(req);=0A=
>>   =0A=
>>   		pdb->g_dma =3D sg_dma_address(req_ctx->fixup_src);=0A=
>>   	}=0A=
>>   =0A=
>> -	if (edesc->dst_nents > 1) {=0A=
>> +	if (edesc->mapped_dst_nents > 1) {=0A=
>>   		pdb->sgf |=3D RSA_PRIV_PDB_SGF_F;=0A=
>>   		pdb->f_dma =3D edesc->sec4_sg_dma +=0A=
>>   			     sec4_sg_index * sizeof(struct sec4_sg_entry);=0A=
> AFAICS there are a few other places besides set_rsa_priv_f1_pdb=0A=
> that should be updated:=0A=
> 	set_rsa_pub_pdb=0A=
> 	set_rsa_priv_f2_pdb=0A=
> 	set_rsa_priv_f3_pdb=0A=
> Yes, right! I'll update them in v2.=0A=
=0A=
Thanks,=0A=
Iulia=0A=
