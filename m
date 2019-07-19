Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B499DC76195
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 15:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B20D2186A
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 15:39:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="J10u7SVE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbfGSPjm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 11:39:42 -0400
Received: from mail-eopbgr00082.outbound.protection.outlook.com ([40.107.0.82]:4672
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726072AbfGSPjm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 11:39:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+gYuGlubl45IGEqMjNbrVtORzM+PVwMcUXFbYsnoerCyvU99WAGA1L120Ha0LFBuN0ZD3zuB3NRJHB/krfnOZaB+AUa/wiVgU34eLmz0NPUvX4r3/Rxbk66GiIsjjIRz/9DU86GIQUHfmwAWf9OydloXJtT7OBnhwo47OjREUO4bGs90Ha+ma0IKnDbpgL5daZE3S1w0HBeiTJW79DSGguZ1gMOaYge64163tLjmE0TmjwDnf1mZCUmi7ByxeFRXGaULj9MZlSikX3LjjqghQBH2wIHONObvda0DwhiXhbpzKLs/qx7jLuiQlWucmx8hHLCCyJRUdBS91J2Q/pvkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgQe892rj7n2nfuT4dN2gcYWqNUDpeUrtnkRbY6g33k=;
 b=gJT6txnZvdektvQcNelR5tqgr5GGqYsmxGRExYW9Ie4B/325O69oMvt4IdIj/v3umGwMRc4oYefSr1oieGG+7otaunQVKGJRg40ebCWnOYSjVdTp8bl3p+9or8khxQmDBDHqc8Qr7f7K0KSzc6Kb1NizsEV2VquErwCqqZLLiUPn7HwR01zOrWI8G+YjXTlfNKg2fnE0EAzJc5yY8GXhJpTKHyHkv0/Dz0D0Y7wf5qUFTPCiLh1/fcbmLUwdzgt358fOBF9qpxtjrq4lbpzsb4fatC16tjoMIG7KzmjEO9aiGZTTGFV69/V01LRhtoxyd59TMRplIDwgqhAQzJmgwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgQe892rj7n2nfuT4dN2gcYWqNUDpeUrtnkRbY6g33k=;
 b=J10u7SVE6+6c7EQ6j3ZQt+WZJHXRJk9MMWTPrXJWpHrlvKDGRB2LD7tfA8ATWNq+GN0UVSyv0TIecoWNiEf6uws4LrTFBjVIZerypSr/aIS9ZHvy4FctKbPP6xM8W7KsNocAlIj9UZkRThPuC5ZCqH6BR3+d5Se0SBlF2OPh44k=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3822.eurprd04.prod.outlook.com (52.134.16.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Fri, 19 Jul 2019 15:38:58 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 15:38:58 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 08/14] crypto: caam - update rfc4106 sh desc to support
 zero length input
Thread-Topic: [PATCH v2 08/14] crypto: caam - update rfc4106 sh desc to
 support zero length input
Thread-Index: AQHVPcSrFTz96tsd1UekZXZsXHKV8A==
Date:   Fri, 19 Jul 2019 15:38:58 +0000
Message-ID: <VI1PR0402MB3485F402A65391E3B145063198CB0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1563494276-3993-1-git-send-email-iuliana.prodan@nxp.com>
 <1563494276-3993-9-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b00a670-b744-4b4f-44bb-08d70c5f3781
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3822;
x-ms-traffictypediagnostic: VI1PR0402MB3822:
x-microsoft-antispam-prvs: <VI1PR0402MB3822C411C91426310A2B192F98CB0@VI1PR0402MB3822.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(199004)(189003)(99286004)(25786009)(7696005)(305945005)(446003)(6246003)(53936002)(229853002)(9686003)(76176011)(55016002)(6506007)(53546011)(6636002)(14454004)(74316002)(7736002)(102836004)(6436002)(478600001)(476003)(4326008)(54906003)(110136005)(8676002)(86362001)(33656002)(15650500001)(66446008)(486006)(44832011)(316002)(2906002)(81156014)(52536014)(3846002)(66066001)(26005)(71190400001)(71200400001)(186003)(6116002)(81166006)(68736007)(64756008)(8936002)(91956017)(66556008)(66476007)(76116006)(66946007)(256004)(5660300002)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3822;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nRBCflkctFqiGkX9p1zuGW7jNJ8BgxhJoKzf/3Yj4n3fNWxJXYly6SBGuOJ4PpeQjJQoyh1joJM+1AwQ+ZX4i7CtlfCdahtCBVxWIBl68ofOAXAPCJ0zkRdWw6xkTkGR/oFSthZ5Xryqd7egvfPlGQFhD2gTEzA3zSmsQqvncXe1GTCyT3Fqs7sUIVvTtgkTLAe4sNVEXP4PQpApTu1gEYCCcxmoV2+/Rn+ozR9ylfK17GrvII3mEDDLze/m3UQR58gHYpjhbD0CF/yX2wOMGitqaAGwYygCXFByk+HDmWsuF+XOGU1ulfNLNRVemch8Q+go2eIxYvRtqqv0l64IV0OvayPGSTIiSBjSzFSPKTAD4jRAuFa5mxoE0bz0+83a07shH0yFvQF1mQ82rYyX/HZJyghMOIvAKwi5t7fkSxc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b00a670-b744-4b4f-44bb-08d70c5f3781
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 15:38:58.7690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3822
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/19/2019 2:58 AM, Iuliana Prodan wrote:=0A=
> Update share descriptor for rfc4106 to skip instructions in case=0A=
> cryptlen is zero. If no instructions are jumped the DECO hangs and a=0A=
> timeout error is thrown.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
> ---=0A=
>  drivers/crypto/caam/caamalg_desc.c | 46 +++++++++++++++++++++++++-------=
------=0A=
>  drivers/crypto/caam/caamalg_desc.h |  2 +-=0A=
>  2 files changed, 31 insertions(+), 17 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caa=
malg_desc.c=0A=
> index 7253183..99f419a 100644=0A=
> --- a/drivers/crypto/caam/caamalg_desc.c=0A=
> +++ b/drivers/crypto/caam/caamalg_desc.c=0A=
> @@ -843,13 +843,16 @@ EXPORT_SYMBOL(cnstr_shdsc_gcm_decap);=0A=
>   * @ivsize: initialization vector size=0A=
>   * @icvsize: integrity check value (ICV) size (truncated or full)=0A=
>   * @is_qi: true when called from caam/qi=0A=
> + *=0A=
> + * Input sequence: AAD | PTXT=0A=
> + * Output sequence: AAD | CTXT | ICV=0A=
> + * AAD length (assoclen), which includes the IV length, is available in =
Math3.=0A=
>   */=0A=
>  void cnstr_shdsc_rfc4106_encap(u32 * const desc, struct alginfo *cdata,=
=0A=
>  			       unsigned int ivsize, unsigned int icvsize,=0A=
>  			       const bool is_qi)=0A=
>  {=0A=
> -	u32 *key_jump_cmd;=0A=
> -=0A=
> +	u32 *key_jump_cmd, *zero_cryptlen_jump_cmd, *skip_instructions;=0A=
>  	init_sh_desc(desc, HDR_SHARE_SERIAL);=0A=
>  =0A=
>  	/* Skip key loading if it is loaded due to sharing */=0A=
> @@ -890,26 +893,25 @@ void cnstr_shdsc_rfc4106_encap(u32 * const desc, st=
ruct alginfo *cdata,=0A=
>  	}=0A=
>  =0A=
>  	append_math_sub_imm_u32(desc, VARSEQINLEN, REG3, IMM, ivsize);=0A=
> -	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);=0A=
> +	append_math_add(desc, VARSEQOUTLEN, REG0, REG3, CAAM_CMD_SZ);=0A=
>  =0A=
Why is this needed?=0A=
-all math registers are zero when descriptors start execution=0A=
-all caam hw revisions have support for math instruction=0A=
with ZERO as first operand=0A=
-descriptor size stays the same=0A=
=0A=
> -	/* Read assoc data */=0A=
> +	/* Skip AAD */=0A=
> +	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);=0A=
> +=0A=
> +	/* Read cryptlen and set this value into VARSEQOUTLEN */=0A=
> +	append_math_sub(desc, VARSEQOUTLEN, SEQINLEN, REG3, CAAM_CMD_SZ);=0A=
> +=0A=
> +	/* If cryptlen is ZERO jump to AAD command */=0A=
> +	zero_cryptlen_jump_cmd =3D append_jump(desc, JUMP_TEST_ALL |=0A=
> +					    JUMP_COND_MATH_Z);=0A=
> +=0A=
> +	/* Read AAD data */=0A=
>  	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |=0A=
>  			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);=0A=
>  =0A=
>  	/* Skip IV */=0A=
>  	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_SKIP);=0A=
> -=0A=
> -	/* Will read cryptlen bytes */=0A=
> -	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);=0A=
> -=0A=
> -	/* Workaround for erratum A-005473 (simultaneous SEQ FIFO skips) */=0A=
> -	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_MSG);=
=0A=
> -=0A=
Erratum workaround is dropped without any explanation.=0A=
=0A=
The trigger condition (SKIPs both in input and output sequence) still exist=
s.=0A=
The descriptor should be validated on a caam with erratum not fixed (era < =
6).=0A=
=0A=
Horia=0A=
