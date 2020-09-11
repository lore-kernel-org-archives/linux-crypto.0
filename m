Return-Path: <SRS0=Quof=CU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B6C0C43461
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 09:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBBC22087C
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 09:16:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="OwLUOwYo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgIKJQZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Sep 2020 05:16:25 -0400
Received: from mail-eopbgr20080.outbound.protection.outlook.com ([40.107.2.80]:19843
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725730AbgIKJQS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Sep 2020 05:16:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUpzC1bX5RfzZ5YzKwRQ4zkKii4clj8vTzuZ/fjcmpdyImaYbgMa/RhG+iP378Ny6c2iikKoCd7s3lxwPUMgzdPCqR5u4OZsUGHUzR83Bvz8EpYk7XMQ/nQC+H7lOa6pvPybiLfu69HojPIoywjMMgD9q9ieO/7fsdNMBdsSNLKyL7wCk8iWPy12AbvwgYkhfgpCWA/B99+UG943Hc5lHCk+LM67U1cy7izqpyNsL34S4PAuQy/aFFv5pucJB4mLY56yV/2ESt6IZSwIC/yltMO6evMH39vPpLVwX5JEEBEwJ1JasQa3GIREyhSGjfGNa0caTsMNJFTs06srZwJOtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYA/tJaCtuW7xnqyJ1o+mSRaYTouDXyTw9ofBbw8bjo=;
 b=gFuQAo52QCuCtYsiGFxTvfOC9H9Wc6dDwqLCt54ARn5+slhm040Yh8V+VL9ghQjZLjbFFShw8JYnwA87C3vrrdgu3DGHNHP7fWgnR8OxkHVlz5b/wPeTarS3ZTE8QPf3ePDTh3u92XtSBai2mz+lecDrILBIjte4ttlo2z6tEPBm0AhJm5yPfCM1igP2qlyQAMPINZsxdYxTkCcL2Nq1rbQ2o3oh4/MvztC7HkpGKppswqje8+WwCadh7rhwDnbMb2nmnkNlzC4ymfKtSorV9f9U0KhirUP8dVs8bQLdwAYQ3ohxAGr3VHnc9B2FogskV7tcNNCV9RqLJPblIAG4ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYA/tJaCtuW7xnqyJ1o+mSRaYTouDXyTw9ofBbw8bjo=;
 b=OwLUOwYotn2Jv1S70Q4YzDOoh3SsCsy1QQEVSMF7uoncMQ8hfp/Yyk6Zm1YIWAmzMSP1bfYjN/zPMeCW1LlObCaWTe+yOE/uCJbFkNHd3BRNDPJvltl1MpywwPldXs2+iZSX0TB1RdIb6Vnh1xNQ8nGVYWIW7JXI/Va5sBlgQJM=
Authentication-Results: st-md-mailman.stormreply.com; dkim=none (message not
 signed) header.d=none;st-md-mailman.stormreply.com; dmarc=none action=none
 header.from=nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR0402MB3615.eurprd04.prod.outlook.com
 (2603:10a6:803:9::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Fri, 11 Sep
 2020 09:16:13 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::857c:9b92:ee9f:10d0]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::857c:9b92:ee9f:10d0%5]) with mapi id 15.20.3370.016; Fri, 11 Sep 2020
 09:16:13 +0000
Subject: Re: [PATCH v2 1/4] crypto: caam - Fix kerneldoc
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
References: <20200910192919.12503-1-krzk@kernel.org>
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
Message-ID: <5c4b306f-3075-b06d-4ed6-21271df2bd8d@nxp.com>
Date:   Fri, 11 Sep 2020 12:16:09 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20200910192919.12503-1-krzk@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR07CA0026.eurprd07.prod.outlook.com
 (2603:10a6:205:1::39) To VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.16] (86.127.128.228) by AM4PR07CA0026.eurprd07.prod.outlook.com (2603:10a6:205:1::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.5 via Frontend Transport; Fri, 11 Sep 2020 09:16:11 +0000
X-Originating-IP: [86.127.128.228]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3f94b566-fa12-4efb-4c07-08d85633546e
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3615:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB361598A3084FFFDE3D0BD6808C240@VI1PR0402MB3615.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g2FdvmOUuR0578F92rP04ouRPFXdBSnnsm2jvMCOHIozxUYOlab1WPuTY+dk+mgJFlwvWOFb187E+BlJcStPd4pABNLrXaS7L7UQ5DK6vXr+EBUWP5gv0gvC7grSTEzgcOJWZYJvVonRQnKNa+HJ9cQZkfnA9fVX+4xwZ8nn/nKk/iIo5DOWnRrd1kzCoVxWgOaXGTo5w6B4VIazImZc1pag6lR1xEwNz6zubDKH2Sa42roEYlWsbHe/9+578iGT7XCqIORfyVTlYiLVjb6EKAerc1WFSlRM+JRlF4mCtVb7FY4v2T1On5ePB5poSfjtqtlTcjRwEaWsNwnh8BhMctmozcQVGQ+htus1VCw6RbwOWciirvDNIBgecok/jchIaPcnocMltHAEmC0Ufqou6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(53546011)(83380400001)(956004)(16576012)(8676002)(316002)(110136005)(2906002)(36756003)(8936002)(44832011)(2616005)(478600001)(66476007)(16526019)(5660300002)(52116002)(7416002)(6486002)(186003)(66946007)(66556008)(31686004)(86362001)(31696002)(26005)(921003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: z+J+/8mOSlnJMoIyq1QcksJ9U5ylzm0QhsIM3z6f66GhSAhmMQcSf545ACira4l8KRgYcDyuhCK2tkDXKmLzmM5nmSDKVXa0roWwAyVh+XMsTm0TZXzq845FfziWEntCnLeUidUWloflnIlnrkb/mTbKkCu4T64spaHyhkIzDjslIUHdix82cEpIpXeF6m2o5QRXaT7KDkCZGI3uMt3TTr5QGrIZ0jqKWvfgMkLzIn851tYKy00Yz0lgg+ZvjGecr8r3VAT2lAaPG+Trg3iufjtUfRRnWuWVAqUcbe4y8yCUIkHySpGSgUb5nMn+IgBT+yiKdPb3oGsHOHmmiiwxyB9fb4a1pVPzCQYBb1yq5PqSIyWUFO7qJb/9PWL3EcsVQypoBk4kyGDDmG7875PNqEDkvESMxnJtRIMGv03x00Pza3h6P3YGXwHfCz8OdByQrTpOZ9U9J9E3zTcoZFVNdUsTF1WE11KTPh8NL+YlxKKzMjGBJcE2ra7FvdjIesv3dCTZQVwYIpczra73qHKjhvIZD0MZyMHlLMb237UUHV0YCIr2UF18tYHa18Dz+CFX2PEd4hETMziAoyYkOSgW+AtLqyUOKIkaMCd9KN+hEjUvvaY3+CcYA72HRjjuWGHNvXo8ytDDDTeYGCNLmnvz3w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f94b566-fa12-4efb-4c07-08d85633546e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 09:16:13.6308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7zYVqgl/ip2jBh0vD1DbAMsAE5BQJNEDJlJ9ya6ONHnxftoroPCaZDWnShF81hw02xeIxnsMz20UbSNW2RNONg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3615
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/10/2020 10:29 PM, Krzysztof Kozlowski wrote:
> Fix kerneldoc warnings like:
> 
>    drivers/crypto/caam/caamalg_qi2.c:73: warning: cannot understand function prototype: 'struct caam_ctx'
>    drivers/crypto/caam/caamalg_qi2.c:2962: warning: cannot understand function prototype: 'struct caam_hash_ctx'
>    drivers/crypto/caam/ctrl.c:449: warning: Function parameter or member 'ctrl' not described in 'caam_get_era'
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>

> 
> ---
> 
> Changes since v1:
> 1. Fix more warnings
> ---
>   drivers/crypto/caam/caamalg_desc.c |  1 +
>   drivers/crypto/caam/caamalg_qi2.c  |  4 ++--
>   drivers/crypto/caam/ctrl.c         |  4 +++-
>   drivers/crypto/caam/jr.c           | 10 +++++-----
>   4 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
> index d6c58184bb57..f0f0fdd1ef32 100644
> --- a/drivers/crypto/caam/caamalg_desc.c
> +++ b/drivers/crypto/caam/caamalg_desc.c
> @@ -373,6 +373,7 @@ EXPORT_SYMBOL(cnstr_shdsc_aead_encap);
>    *         with OP_ALG_AAI_HMAC_PRECOMP.
>    * @ivsize: initialization vector size
>    * @icvsize: integrity check value (ICV) size (truncated or full)
> + * @geniv: whether to generate Encrypted Chain IV
>    * @is_rfc3686: true when ctr(aes) is wrapped by rfc3686 template
>    * @nonce: pointer to rfc3686 nonce
>    * @ctx1_iv_off: IV offset in CONTEXT1 register
> diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
> index 66ae1d581168..0441e4ff2df2 100644
> --- a/drivers/crypto/caam/caamalg_qi2.c
> +++ b/drivers/crypto/caam/caamalg_qi2.c
> @@ -59,7 +59,7 @@ struct caam_skcipher_alg {
>   };
>   
>   /**
> - * caam_ctx - per-session context
> + * struct caam_ctx - per-session context
>    * @flc: Flow Contexts array
>    * @key:  [authentication key], encryption key
>    * @flc_dma: I/O virtual addresses of the Flow Contexts
> @@ -2951,7 +2951,7 @@ enum hash_optype {
>   };
>   
>   /**
> - * caam_hash_ctx - ahash per-session context
> + * struct caam_hash_ctx - ahash per-session context
>    * @flc: Flow Contexts array
>    * @key: authentication key
>    * @flc_dma: I/O virtual addresses of the Flow Contexts
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index 65de57f169d9..f7adcf6ecea5 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -444,7 +444,9 @@ static int caam_get_era_from_hw(struct caam_ctrl __iomem *ctrl)
>    * by u-boot.
>    * In case this property is not passed an attempt to retrieve the CAAM
>    * era via register reads will be made.
> - **/
> + *
> + * @ctrl:	controller region
> + */
>   static int caam_get_era(struct caam_ctrl __iomem *ctrl)
>   {
>   	struct device_node *caam_node;
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> index bf6b03b17251..6f669966ba2c 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -324,7 +324,7 @@ EXPORT_SYMBOL(caam_jr_alloc);
>   
>   /**
>    * caam_jr_free() - Free the Job Ring
> - * @rdev     - points to the dev that identifies the Job ring to
> + * @rdev:      points to the dev that identifies the Job ring to
>    *             be released.
>    **/
>   void caam_jr_free(struct device *rdev)
> @@ -349,15 +349,15 @@ EXPORT_SYMBOL(caam_jr_free);
>    *        of this request. This has the form:
>    *        callback(struct device *dev, u32 *desc, u32 stat, void *arg)
>    *        where:
> - *        @dev:    contains the job ring device that processed this
> + *        dev:     contains the job ring device that processed this
>    *                 response.
> - *        @desc:   descriptor that initiated the request, same as
> + *        desc:    descriptor that initiated the request, same as
>    *                 "desc" being argued to caam_jr_enqueue().
> - *        @status: untranslated status received from CAAM. See the
> + *        status:  untranslated status received from CAAM. See the
>    *                 reference manual for a detailed description of
>    *                 error meaning, or see the JRSTA definitions in the
>    *                 register header file
> - *        @areq:   optional pointer to an argument passed with the
> + *        areq:    optional pointer to an argument passed with the
>    *                 original request
>    * @areq: optional pointer to a user argument for use at callback
>    *        time.
> 
