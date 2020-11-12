Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B834CC55ABD
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 09:21:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49E11221FE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 09:21:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="VK/7GXAi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgKLJV5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Nov 2020 04:21:57 -0500
Received: from mail-eopbgr70053.outbound.protection.outlook.com ([40.107.7.53]:64619
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726731AbgKLJV4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Nov 2020 04:21:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJT7X7TssMJRmUvZNQvqHjQFRyCtJPJWgfJ9AbAbxjiKrQEhpnfMFS0eGv19L4p6ypLMZObeGe9ndyuEGXo9iyqqhbWh4yhnbk52QsUVzKBc2SiOO5zhsTYkeaEGlrd3h5fWMC4LS7ecUm8oFFsDpfH5sC1+eaKW8Ly5O6GbiOk0OK4rpGExsXKBYVlkP7f6R+kmPa+waZgQ177lCDAqUsy+3WSDH4s03iNZqu5b6991BBF65fFLGnwpTDApSVxJQfNfiOdicvf2qzxuQ/ma04S7yFXNkYv3G49JQb/iOHSM6hJBoTFzxVd2K6ROhTJNQ5xFPvr+IJIR7oDpNJ8XbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2f01DBq5EYbtcMvFJ/MC9vi3jrOuN9Ek0VZS5fvhRXM=;
 b=i3C8H7LvKKJsSxJBGs3XksCgw/v8oma0NgpwCFBmPKuSuD1KbVE3uRgv8FLe9zGC9eCsWhCWWnPrzop1GNTBHz8N7ev+4R9/c1/Ny8f1vCbsLBi1+JWNE9hseVq7Jd2Qcxc5qXLWvAPN8LHTv1VNco3Pcu47oJNyhE2Pgz9OxITP2LFpi0e12XCZa2mxb8xt9mQsjuSsqAjSxMfrPDqa2KXsRg7sU5WKeAUWj2FN6FpFYBbcXyXYp8DO61oZHoubshfTk3cxwfYrCYVOtvVVCRwlxfIkLJlZM+2MYN1oTGULg8kI4ZBxR0hEFbOMpc6YLja6urI88Sd7isxH8Lo5OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2f01DBq5EYbtcMvFJ/MC9vi3jrOuN9Ek0VZS5fvhRXM=;
 b=VK/7GXAiEyvXa/UyunrMk/ld4xpINBAIaWCvlvbpC+Pf2qoqMKAUqKzszJlDIvf587wbIUKunXFMAo7bkeh421jqur7rFDJAs94vPlJeYTMRVgEm6hYHlf9GkRkwxOS2i0agGOVSCh8Fkf4XtJVOmF/5BwkmFWZpX+1yDIrtru8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB3136.eurprd04.prod.outlook.com (2603:10a6:802:10::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Thu, 12 Nov
 2020 09:21:49 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::c44f:a4fa:bd16:95aa]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::c44f:a4fa:bd16:95aa%5]) with mapi id 15.20.3541.025; Thu, 12 Nov 2020
 09:21:49 +0000
Subject: crypto: caam/qi - simplify error path for context allocation
To:     Wang Qing <wangqing@vivo.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1604653287-16577-1-git-send-email-wangqing@vivo.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <7e8409c9-ce91-3970-6ae0-e6e06987c117@nxp.com>
Date:   Thu, 12 Nov 2020 11:21:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
In-Reply-To: <1604653287-16577-1-git-send-email-wangqing@vivo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM0PR01CA0118.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::23) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR01CA0118.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 12 Nov 2020 09:21:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 998d042a-d6c6-4bc0-d98d-08d886ec620d
X-MS-TrafficTypeDiagnostic: VI1PR04MB3136:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB313668A918886CA1A7CCF8B098E70@VI1PR04MB3136.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OtVp2X6n9RhozYngCodCmmtFDYgtffYGso9JJdpWZkDjBxMeMlsolavQGQQQpiEidGaac+Ivu6qvRl9tuK/lzMgJwiEmzqzXRNIJogiXWqOS0QymcgEqHkj4+6kDkQxSwW1mutUq/RIaDmhWf/aFwuXibSM210Rb1KLmzJxNH13WKyBQOs3kMoOZxTqTlTt8aisebG4Zgg9BzevFFABLfgOUWbUq/ITF/UhG0aHRDU1cFUaGPhhvl7tPXLXdrLfqgu2dUArSKknRNY6SzepK5TvYqx2HJe5TD/Ioc5jEO8+ht0xkTRcFtyYdAZBASghG7fLyEMEjFnFmGa1xMr4djQo4E7JQW6jH+quMfCqYC9WtT/70pAxOkt+QnaVHWqeK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(31696002)(478600001)(66946007)(66476007)(66556008)(8936002)(86362001)(8676002)(26005)(53546011)(52116002)(31686004)(316002)(2616005)(956004)(16576012)(16526019)(6486002)(83380400001)(186003)(110136005)(2906002)(36756003)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PHcXtOaLUPEbxPjPae2w4EZrYAh2pDBy7bVorF8vKjujtMWVNYKNsGlCE+aY1qpvk9w2NB5FHUHdzsbRrJrK3eH8dqyeDhkicoAxCIV88KlRxJb/zunrHxSH4JS5XSg9BkcxmNZMaUcdZX51orDnRrrXscdyCZ3du57pdt/SZyWSOitxNpBVAM5utnQ/z+4Ol9xgWE9WTNFEjhi8uhiZWT1wYnYYHMnSrzLWnNosW7k00Rw/vOsNcQ3+CO8Beuf9k30GmfxF6jToqf0vBP4yKmRgcDOsxGCXrOmTFqowUp95DLgXwbtk4MhidJjF0PssetFViIHnAOgoDoY6qLkjaj2S6StsXevO5M9bEfptdwKBxY6IIN5XE9Gp9R9J2sOo1cGJk7/KormLbW4u1HxuUSQDGVsVxJA9c0j4QJLKjc1iNu9DnbhbzPhoq1tQA9XO33XDzPp7QlHkX2iAsCTA+2LwULPZbHsT0b/GebpAfd7pMjvcnY4hhDzY9OsqsrEjixAPVTgjP1KaBeBo4s/dXKLSdJedrteTKRyx4GTzrY54dFVMIBXmqGlOCkzC1OibfOs5VSTY0G/LkE5e+90F+dpdx36jSlqAKvMv81DwG7Q3rWGN1n6raP4Tdf6RtgPljGUNyeoO5LHHTMPzDO1zsQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 998d042a-d6c6-4bc0-d98d-08d886ec620d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2020 09:21:49.2761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7B6PGagkS/e2jYyBAwEdxEuG29zhqhvhwHOp8zLoKPeGCrCG2sxxDoSCURXY2NAPYePbzTl/29rRwDzUvlvzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3136
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/6/2020 11:01 AM, Wang Qing wrote:
> Fix passing zero to 'PTR_ERR' warning
> 
Thanks.

> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>  drivers/crypto/caam/caamalg_qi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
> index 66f60d7..add60e8
> --- a/drivers/crypto/caam/caamalg_qi.c
> +++ b/drivers/crypto/caam/caamalg_qi.c
> @@ -1166,7 +1166,7 @@ static inline int aead_crypt(struct aead_request *req, bool encrypt)
>  	/* allocate extended descriptor */
>  	edesc = aead_edesc_alloc(req, encrypt);
>  	if (IS_ERR_OR_NULL(edesc))
> -		return PTR_ERR(edesc);
> +		return PTR_ERR_OR_ZERO(edesc);
>  
Digging a bit into the logic, it turns out aead_edesc_alloc() can't return
a NULL pointer.

-- >8 --

Subject: [PATCH] crypto: caam/qi - simplify error path for context allocation

Wang Qing reports that IS_ERR_OR_NULL() should be matched with
PTR_ERR_OR_ZERO(), not PTR_ERR().

As it turns out, the error path always returns an error code,
i.e. NULL is never returned.
Update the code accordingly - s/IS_ERR_OR_NULL/IS_ERR.

Reported-by: Wang Qing <wangqing@vivo.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_qi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index a24ae966df4a..189a7438b29c 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -852,7 +852,7 @@ static struct caam_drv_ctx *get_drv_ctx(struct caam_ctx *ctx,
 
 			cpu = smp_processor_id();
 			drv_ctx = caam_drv_ctx_init(ctx->qidev, &cpu, desc);
-			if (!IS_ERR_OR_NULL(drv_ctx))
+			if (!IS_ERR(drv_ctx))
 				drv_ctx->op_type = type;
 
 			ctx->drv_ctx[type] = drv_ctx;
@@ -955,7 +955,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	struct caam_drv_ctx *drv_ctx;
 
 	drv_ctx = get_drv_ctx(ctx, encrypt ? ENCRYPT : DECRYPT);
-	if (IS_ERR_OR_NULL(drv_ctx))
+	if (IS_ERR(drv_ctx))
 		return (struct aead_edesc *)drv_ctx;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
@@ -1165,7 +1165,7 @@ static inline int aead_crypt(struct aead_request *req, bool encrypt)
 
 	/* allocate extended descriptor */
 	edesc = aead_edesc_alloc(req, encrypt);
-	if (IS_ERR_OR_NULL(edesc))
+	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
 	/* Create and submit job descriptor */
@@ -1259,7 +1259,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	struct caam_drv_ctx *drv_ctx;
 
 	drv_ctx = get_drv_ctx(ctx, encrypt ? ENCRYPT : DECRYPT);
-	if (IS_ERR_OR_NULL(drv_ctx))
+	if (IS_ERR(drv_ctx))
 		return (struct skcipher_edesc *)drv_ctx;
 
 	src_nents = sg_nents_for_len(req->src, req->cryptlen);
-- 
2.17.1
