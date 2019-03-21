Return-Path: <SRS0=F/PC=RY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51EB8C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 15:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17118218D3
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 15:34:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="FHLMYfXM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfCUPeR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:34:17 -0400
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:60510
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727138AbfCUPeR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Mar 2019 11:34:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XH8NwfsQxoaGDQ7MHNQBtijz9VjTLW2EDlQ81iT6qzw=;
 b=FHLMYfXM5Nl/nHI63fog2xL4BxZgDO1OzHqxxa+X1PRAi499Ch9J7OzGDD2T1OW3hXUvFkTpMXn/5tFXyapjr1Kqkbe+fRvdTyj4m7miGxgM7SLfSkfJnseHisHzertQAfY+ah9Sq57b+3v/YjN0BZsRfQyUtJkIR3wpTCdm2TU=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2927.eurprd04.prod.outlook.com (10.175.24.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.15; Thu, 21 Mar 2019 15:34:14 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::9c05:647c:6f6c:c531%2]) with mapi id 15.20.1709.015; Thu, 21 Mar 2019
 15:34:14 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     Aymen Sghaier <aymen.sghaier@nxp.com>
Subject: Re: [PATCH v2 2/3] crypto: caam/jr - Removed redundant vars from job
 ring private data
Thread-Topic: [PATCH v2 2/3] crypto: caam/jr - Removed redundant vars from job
 ring private data
Thread-Index: AQHU3/uJ401rQ6D3SEi6socERvyNLw==
Date:   Thu, 21 Mar 2019 15:34:13 +0000
Message-ID: <VI1PR0402MB34851FE3F3FF4BED3D56EFCD98420@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190315112238.24337-1-vakul.garg@nxp.com>
 <20190315112238.24337-3-vakul.garg@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 809ea3c9-2053-4415-dc7d-08d6ae12ac35
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB2927;
x-ms-traffictypediagnostic: VI1PR0402MB2927:
x-microsoft-antispam-prvs: <VI1PR0402MB2927CA9F45FB524CF163A3A698420@VI1PR0402MB2927.eurprd04.prod.outlook.com>
x-forefront-prvs: 0983EAD6B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(346002)(366004)(39860400002)(396003)(199004)(189003)(25786009)(4326008)(2501003)(99286004)(6346003)(186003)(102836004)(26005)(7696005)(53546011)(6506007)(76176011)(44832011)(4744005)(66066001)(476003)(5660300002)(71190400001)(446003)(71200400001)(486006)(14454004)(86362001)(2201001)(256004)(33656002)(305945005)(3846002)(81156014)(68736007)(74316002)(81166006)(8936002)(2906002)(478600001)(7736002)(6116002)(8676002)(316002)(110136005)(6436002)(53936002)(106356001)(52536014)(229853002)(55016002)(6246003)(9686003)(97736004)(105586002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2927;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: k2kphL12hcmeuLEpthnyZfNYJfynhYHc8ugzLViHoiYL2yrQfYUk6qFxN7XfDEhTYShJS8HU2cZXsaNpm3lq9bG44wsT8U0+4IL/wzTiqgevbWJcVkuVASRfxxX56nrTXqGTSjCjLpLfuUwhYStIIoKEQBikqr+sNyF0ujnL/p9zBgOkBaL9siA+QKOCRJi1lbFCjxpJkSek4Ss4Zg42nU+un/WTcuvtMXEiqbCrG4je8mlu4VNfD/Espk1x5s2IFswyHqa4HYpfsjDS2GBJfKUWXHUPySn528WpD9F/C5YZ2KR30/jO534bl4qO1zjPpdaEjlUQjc9lTbyLlQKxcEdCYVpJKd/s/uoN7IXJJcVuzKlun5cTMnuXgmHcLff1l72zXBBfVUf6xW34NbIi3bH5HDODh/WW08PXq7pwWq8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 809ea3c9-2053-4415-dc7d-08d6ae12ac35
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2019 15:34:14.0078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2927
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/15/2019 1:25 PM, Vakul Garg wrote:=0A=
> For each job ring, the variable 'ringsize' is initialised but never=0A=
> used. Similarly variables 'inp_ring_read_index' and 'head' always track=
=0A=
> the same value and instead of 'inp_ring_read_index', caam_jr_enqueue()=0A=
> can use 'head' itself. Both these variables have been removed.=0A=
> =0A=
Typo: s/inp_ring_read_index/inp_ring_write_index=0A=
=0A=
> -	int inp_ring_write_index;	/* Input index "tail" */=0A=
[snip]=0A=
> -	jrp->inpring[jrp->inp_ring_write_index] =3D cpu_to_caam_dma(desc_dma);=
=0A=
> +	jrp->inpring[head] =3D cpu_to_caam_dma(desc_dma);=0A=
[snip]=0A=
> -	jrp->inp_ring_write_index =3D (jrp->inp_ring_write_index + 1) &=0A=
> -				    (JOBR_DEPTH - 1);=0A=
[snip]=0A=
> -	jrp->inp_ring_write_index =3D 0;=0A=
=0A=
Horia=0A=
