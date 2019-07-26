Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1717DC7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 15:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D466220838
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 15:45:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="DQNQkaLy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfGZPpa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 11:45:30 -0400
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:61294
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726001AbfGZPp3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 11:45:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4dWuLCWrZFpBcqSdYB61M8HoU7G51eoTffLkwoK2YhXgQXYJbY5KJm6Rs7PLGfBGlhv3ZH2Ipcwh28nRREa8JWITe/UspknfjxCw2r7RNp2KvP6Dz/9cEhyPIS03Jt6T5/B74V4yN2+Iq50yKBMlfYrEpYw9tZKo/5FC5uWCFMqRIqjPivxQ48opygTBNNNSElkCLQx5A6cxpH50sxCsauYlIUFJraPNv7iWcOSnwc4eNOPjSN+At6FZO/yLWeMQjxTEFOET3scmC5AlOZW4n3hgeOh3t3u7CFgzt7J5cpl2/oTtx6CjKcpU9KgH7AYlWmmmVeiNGWEM9M9k6/b3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsM+nicFgzOzMHhIxxPMDZqdOKFFDdBcNtEju536osU=;
 b=a/jhSpZ6qXRoR+tOKb/N8a6jNiH+31ERGxvKbsHC6+OWlbkHGRyTTnaeHic9H0RGQNlA31xYMYn262QDnt0F1vEDYcUX0T4q+nmexTPwl+jtRhURtt/fU+v7Xfqkc2Cylzyz+pSK4csFTxZZyZbW32XexyjQSdBxoA1MgP7p0akgcpxLt8LjKdZph8Yg3JZ4r5oNvwQQ0H4j3zZr8g+3ocA2ILfcf2yy0u4y4dTkYHup3isgCOAFJLYU4f2HuSAIsWk3xNLpqQ1ifOybswWVryV1zBKHl6bkBkLwHNfFcP+y5CZPFGOJ68csjMnayQ03p3vrgwbekFqbk1Yn+sLV0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsM+nicFgzOzMHhIxxPMDZqdOKFFDdBcNtEju536osU=;
 b=DQNQkaLyW/9eABgjbfbIkCjXkvGGTLXaDFmH2QgepOr/CHrWYWGFDqJoDyTaUAyPu0xCBPptVb/g+T82M/eXxXBOmy+fAUIlsHbrLnhEl3NUwZEX3S28O3GeooZsSK/w82N5UvEfJ4Sbt5jKr0bh62QhS0mEqbcUf1NuI5TGHNQ=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2813.eurprd04.prod.outlook.com (10.175.21.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Fri, 26 Jul 2019 15:44:46 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 15:44:46 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v3 08/14] crypto: caam - update rfc4106 sh desc to support
 zero length input
Thread-Topic: [PATCH v3 08/14] crypto: caam - update rfc4106 sh desc to
 support zero length input
Thread-Index: AQHVQvERbpsKgfpmokSM8mMCvyAc5g==
Date:   Fri, 26 Jul 2019 15:44:46 +0000
Message-ID: <VI1PR0402MB3485D09690F994E1CE5220D198C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1564063106-9552-1-git-send-email-iuliana.prodan@nxp.com>
 <1564063106-9552-9-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [79.118.216.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1f3c677-b55a-44fb-b3e6-08d711e02f84
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0402MB2813;
x-ms-traffictypediagnostic: VI1PR0402MB2813:
x-microsoft-antispam-prvs: <VI1PR0402MB28136ED140F6089A8B5040D998C00@VI1PR0402MB2813.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(199004)(189003)(7736002)(25786009)(256004)(74316002)(4326008)(71200400001)(3846002)(6246003)(6116002)(71190400001)(66066001)(53936002)(486006)(476003)(55016002)(9686003)(2906002)(186003)(26005)(305945005)(86362001)(446003)(44832011)(229853002)(6436002)(110136005)(54906003)(6636002)(68736007)(316002)(5660300002)(52536014)(81156014)(8676002)(81166006)(8936002)(33656002)(76176011)(102836004)(6506007)(91956017)(14454004)(66476007)(66556008)(99286004)(7696005)(53546011)(76116006)(478600001)(66446008)(64756008)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2813;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mJwDEr4raKM7YK6utHqstZoWivPpmDH21zyQQC6BmvdyAhvrVE4kp4voJIMB5Cyp9wd42QF6RWoJ99oCa7G4sHx4WwsDtxSmHoaqrULMTybFyHKhJBXj17mjGgjkY4WWsPaxm21/MNehCUMybCwXIP+BnQZm8SRH1RhT7KDl/+enxiIZNyTVAmwTB7uD3+r5X5MjZqwWwSUT/qEVR4JVcvJZBhTZOhSZoA03AqBxTseJ/dJD4bkMCOHWH4StEulrq3Jsr3mLEWr9n/IOu/08tLPWm3oiVWaFspBNPuaIAqmLpCfNv5RYv9S06UFdAqRMiVEPdyCL+zw6NZwg85S7RPjB5euNfj7xLn48Iw5QDYm/theM4sHqjEIRBwITRfmdizEi12c5C9fQTX+rO1QL7BRv/cDAw1znR5VTEDPn0qM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f3c677-b55a-44fb-b3e6-08d711e02f84
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 15:44:46.3117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2813
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/25/2019 4:58 PM, Iuliana Prodan wrote:=0A=
> @@ -892,24 +895,26 @@ void cnstr_shdsc_rfc4106_encap(u32 * const desc, st=
ruct alginfo *cdata,=0A=
>  	append_math_sub_imm_u32(desc, VARSEQINLEN, REG3, IMM, ivsize);=0A=
>  	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);=0A=
>  =0A=
> -	/* Read assoc data */=0A=
> -	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |=0A=
> -			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);=0A=
> +	/* Skip AAD */=0A=
> +	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);=0A=
>  =0A=
> -	/* Skip IV */=0A=
> -	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_SKIP);=0A=
> +	/* Read cryptlen and set this value into VARSEQOUTLEN */=0A=
> +	append_math_sub(desc, VARSEQOUTLEN, SEQINLEN, REG3, CAAM_CMD_SZ);=0A=
>  =0A=
> -	/* Will read cryptlen bytes */=0A=
> -	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);=0A=
> +	/* If cryptlen is ZERO jump to AAD command */=0A=
> +	zero_cryptlen_jump_cmd =3D append_jump(desc, JUMP_TEST_ALL |=0A=
> +					    JUMP_COND_MATH_Z);=0A=
>  =0A=
>  	/* Workaround for erratum A-005473 (simultaneous SEQ FIFO skips) */=0A=
> -	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_MSG);=
=0A=
> +	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA);=0A=
>  =0A=
The workaround should be moved further down, just before the "Skip IV".=0A=
=0A=
By moving this instruction as far away as possible from=0A=
previous seq fifo store, the chances of DECO stalling are reduced.=0A=
=0A=
> -	/* Skip assoc data */=0A=
> -	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);=0A=
> +	/* Read AAD data */=0A=
> +	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |=0A=
> +			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);=0A=
>  =0A=
> -	/* cryptlen =3D seqoutlen - assoclen */=0A=
> -	append_math_sub(desc, VARSEQOUTLEN, VARSEQINLEN, REG0, CAAM_CMD_SZ);=0A=
> +	/* Skip IV */=0A=
> +	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_SKIP);=0A=
> +	append_math_add(desc, VARSEQINLEN, VARSEQOUTLEN, REG0, CAAM_CMD_SZ);=0A=
>  =0A=
>  	/* Write encrypted data */=0A=
>  	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VLF)=
;=0A=
> @@ -918,6 +923,18 @@ void cnstr_shdsc_rfc4106_encap(u32 * const desc, str=
uct alginfo *cdata,=0A=
>  	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |=0A=
>  			     FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST1);=0A=
>  =0A=
> +	/* Jump instructions to avoid double reading of AAD */=0A=
> +	skip_instructions =3D append_jump(desc, JUMP_TEST_ALL);=0A=
> +=0A=
> +	/* There is no input data, cryptlen =3D 0 */=0A=
> +	set_jump_tgt_here(desc, zero_cryptlen_jump_cmd);=0A=
> +=0A=
> +	/* Read AAD */=0A=
> +	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |=0A=
> +			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_LAST1);=0A=
> +=0A=
> +	set_jump_tgt_here(desc, skip_instructions);=0A=
> +=0A=
>  	/* Write ICV */=0A=
>  	append_seq_store(desc, icvsize, LDST_CLASS_1_CCB |=0A=
>  			 LDST_SRCDST_BYTE_CONTEXT);=0A=
