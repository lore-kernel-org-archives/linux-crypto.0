Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A897FC43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 11:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 598502145D
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 11:46:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="NtlUlLyZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgIULqV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 07:46:21 -0400
Received: from mail-eopbgr60044.outbound.protection.outlook.com ([40.107.6.44]:50396
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726402AbgIULqV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 07:46:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CqhvJrnV6p9y3RCBLspRbe0yWOWnPzXm3fh0NfccjUHcyh5LjbvjSn+luTKljGwp9B2le8T9IBXTxCU/x1Eo3lb42+BXbY+MDE7owFBYmZFxC211nXqGvZp4Qg8Xd1fQ5ijHBEEDxNQfMJio377U/4mttePPKm41VRge1nBbJ19PlL4I/83L4fIWxNN6MgQhG4FlE/axeOat46bmXnqx5pOC1KCBll94BoAASkOMexZyFl9RnQ2qTn+bQTmCmsiwl82H957LA3wMtJV60JG52WAmGUIaQY5rURv2u2RKI8q+U7S7CEAL8xqliQSPEDRU0NbYjXpEqOJhIuKTHhE50g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8sspuQjwLdycxgm4/D6cXMrqqdgdxqvaaeBfsoXntEk=;
 b=k09r7ElpsnC3Vg/O09xBJSNtQHBu1yThrQXzoHSbaNWwZSIMOBZi8vXrdxOhCb7nac4FxCowiLLSEc5DYAYLIDRcrpy1vW6S1RnoDA1k2x3ZlkhX+Ay5Khd2Y6FOVW1T2/NHDgcvlaSoiEL943993pZEvhm3KRtHrtsQf8qRBG9szF1NVZq0l3xla1zrGex1+Jh7MhrMcA6yXmEze499rlp33IiJ7yfu0xXCj/VN/PZ7YE9OkpvwbLXK+EW1bbjnUtBNFqzZMGOSAdfxp4PXNfDgJWyFRpLQo90LjSLSaBx4ninT/mxYyT5wc6Jx3ry265sTQAe1/ZbNE5mYndVUww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8sspuQjwLdycxgm4/D6cXMrqqdgdxqvaaeBfsoXntEk=;
 b=NtlUlLyZmM2twT54Cfc3xtYmIiOYs84Hwy5qFAvXGVsyi76SGxpHGZv17lVS7/5eTyIk4sZH+8OW2uXbEQDWJiQapIZcrF7p4NRunNYh2MiowHA+XHROdFBJN9JQuGmJuP7fS3+34BLZ/fTdyThL7W4IUUl+ojhZO9HMthmdkcU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB5039.eurprd04.prod.outlook.com (2603:10a6:803:59::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.17; Mon, 21 Sep
 2020 11:46:14 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d%5]) with mapi id 15.20.3391.026; Mon, 21 Sep 2020
 11:46:14 +0000
Subject: Re: [PATCH v2 01/12] crypto: caam/jr - add fallback for XTS with more
 than 8B IV
To:     "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
 <20200921073205.24742-2-andrei.botila@oss.nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <3e51633c-c020-8e5e-d54a-90282d5e2cda@nxp.com>
Date:   Mon, 21 Sep 2020 14:46:10 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20200921073205.24742-2-andrei.botila@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0106.eurprd02.prod.outlook.com
 (2603:10a6:208:154::47) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR02CA0106.eurprd02.prod.outlook.com (2603:10a6:208:154::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 11:46:13 +0000
X-Originating-IP: [78.97.206.147]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 24bcb38b-55b0-4246-3801-08d85e23f1b5
X-MS-TrafficTypeDiagnostic: VI1PR04MB5039:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5039941248777861725D1D6D983A0@VI1PR04MB5039.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sn4GLELYzR6AgJ0fD9+/Aypv17hpvSFMAHu4c7B1iykL/RNPauGMJup/XQlH0F4TFtSlbXsurHx0YHEvrJ96s9VnyIbZ54DVKyb5UQVJ8wy/Rt0KpCh//U2njsjyboj4EeYZejEkrepBDKmc9+5LkThpabIOLd60t3V1VxVl3qISeY2Vsujau3IzIaTmCysn1bSzBkwtGaNOEEXGPK2sa6hmvVRMmZ3oinCwzW16K4tBY5Ix5K7jq6e1ZsouSluoKUg4y27Fiye1haVYvmYqEbPD60uL0yW8AwqswnNbv2lNrr4py6uLTy77D0RKd+vBKw8SnLHbNo60WEyM3Ro1Xgi1LHMKw481NyLkdR8XJW765f+dQ5E1+juOVS4YnX8t3pYhGohoBCOijCcbevqH1rPEOFg0fMoyi3aNChMos5o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(26005)(52116002)(110136005)(66556008)(66476007)(66946007)(16526019)(186003)(16576012)(316002)(4326008)(36756003)(83380400001)(31686004)(478600001)(2906002)(6486002)(86362001)(2616005)(5660300002)(31696002)(956004)(54906003)(8676002)(8936002)(53546011)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zvmZEf2u90gK78IDyMWa9e5jvPAYmnqOt7H1tgD3EXbZp63xIZ3jVk62bNNJT4FkItgjJKPHe4zPD6Go0ZZt587IKDgRxC+IWv0Eg+xdanm1T3uSdkulR9Gp7X0c6eWY2X2m4kRyf23X1LZboe4EHcmAEoTaIUo19n4qCiSzqbIXV9k1f+MFHYMyjIEQEPvuxbNfb2aWfSLT3D+oPLLPjDLJgdp8XzVAbwYAEvVX1Z12GQR/pYf+EqbfwgybwVG+uc9ldRd8Ny9dxrlBb10fEjNKMrIy1kGvHSsRdFUVSPHlMJRyUhMurknBjdH9fe6kDsy9i3ofrSla95fmYs6y+3ow3c+kBaFiMcbUOzkar9ls4mk184IHyp8ybZ419Dl/yBn1oMqjRWCKTO8hWpLm9WD9eeydY4s0j/mQft0lHVQG8ol5WQ89/HzTLWSS9r4BYbhQGopoIXovzS7OIVWZ18If9LcS5/MaVvBPQ0pyne7eo5L16VvZTCAkhR+LiHfF4wILTJliprJXZZHfZieVOcPoLG2qJD/D7laaMlKwCyACLPvQ8LeMZMWPhWLb4G1FPkvRb4+G6a33UJr9T2tJM74Q3NsqGZEBg1dBziScBSX/zsXSe49s97D2jX7NFjPbObmQ44AQY6l/V+yzreaoVg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24bcb38b-55b0-4246-3801-08d85e23f1b5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 11:46:14.6655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QK/R4jvombHuR9YsEgjt0Q5y5V1Yh0xV3DfDWa7l8JsRYkFcy1BhsUORpD7Z7wRwYukE2soYtrru3lFlsLs/1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5039
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/21/2020 10:32 AM, Andrei Botila (OSS) wrote:
> +static bool xts_skcipher_ivsize(struct skcipher_request *req)
> +{
> +	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
> +	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
> +	u64 size = 0;
> +
> +	size = get_unaligned((u64 *)(req->iv + (ivsize / 2)));
> +
> +	return !!size;
Just get rid of the "size" local variable and return !!get_unaligned(...).
Also the function should be inline.

> @@ -3344,13 +3379,30 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
>  	struct caam_skcipher_alg *caam_alg =
>  		container_of(alg, typeof(*caam_alg), skcipher);
>  	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
> -
> -	crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx));
> +	u32 alg_aai = caam_alg->caam.class1_alg_type & OP_ALG_AAI_MASK;
>  
>  	ctx->enginectx.op.do_one_request = skcipher_do_one_req;
>  
> -	return caam_init_common(crypto_skcipher_ctx(tfm), &caam_alg->caam,
> -				false);
> +	if (alg_aai == OP_ALG_AAI_XTS) {
> +		const char *tfm_name = crypto_tfm_alg_name(&tfm->base);
> +		struct crypto_skcipher *fallback;
> +
> +		fallback = crypto_alloc_skcipher(tfm_name, 0,
> +						 CRYPTO_ALG_NEED_FALLBACK);
> +		if (IS_ERR(fallback)) {
> +			dev_err(ctx->jrdev, "Failed to allocate %s fallback: %ld\n",
> +				tfm_name, PTR_ERR(fallback));
> +			return PTR_ERR(fallback);
> +		}
> +
> +		ctx->fallback = fallback;
> +		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx) +
> +					    crypto_skcipher_reqsize(fallback));
> +	} else {
> +		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx));
> +	}
> +
> +	return caam_init_common(ctx, &caam_alg->caam, false);
In case caam_init_common() fails, fallback should be freed for XTS path.

Horia
