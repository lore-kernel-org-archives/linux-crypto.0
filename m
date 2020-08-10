Return-Path: <SRS0=i+zF=BU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B9F9C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Aug 2020 15:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3116220855
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Aug 2020 15:21:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="NcAo+z2n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbgHJPVs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Aug 2020 11:21:48 -0400
Received: from mail-vi1eur05on2043.outbound.protection.outlook.com ([40.107.21.43]:56702
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727963AbgHJPUW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Aug 2020 11:20:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtUzkYpCgeXgSvoH7szD01hV67lfzPb0Rrlafqg5C1gvXIRD2Ls0VxfaSLswimE2IPqcnej0WnFITJyIJFzUld8KhXRaHAJwu6ndoIzPaWlBsrwvo/oN2exFSkxSPJYrVn1dZIuBPsgYYlobKLYgn1RQAippuy4pmYCYy0MucAiu40F1+wGHK3xrSmOR5WePXLWTHmrZr7FSvGmVSGEMoX2LM54eFDxsMk3nzZ2PYRKO3yCsK61sD0s8gkrwvPYJcaNrLKMDbWSyPkW8hd70pcc+/gMC9wFrxC0s3GoJwYNN3gft8Od/s9Y/UAjh/W3MR02y9kkuBojkwQ7NjxT1cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K15VQfxCtfnnDKo5xSiA/RYO5nOsfwZ2tQYxCZSvE0E=;
 b=bGWB4+OP1Qs5uNcbMbQvRvNymmZp2CJPSHILHV2U3sSdMy9WCzhKfXZ6n4tyqMUYLZVo1GDQTHYPlom5zZwfiMmOwWWSh/FnPKL88zxB36lNbKbsceHPSuD8ik11pdEgDxnu03JgMrEBcGjtKawtRwid6T9Yb3vt/8xtYucgcj3XI8XLp6NL56GkOOfVS3i3LdQlL+RG8IJBf0F90a8RM6ulCYBwCeri4sQLfiJ9AglRjGAHDcriw3qbiV5tC6sqD+O7UJZaLFej8ze5htn6aZf4DCjSAVryZS+44alcLnY3RlVmR2F9Se8CufT/QpElPhMMsPz2+RPxD1mLABrgKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K15VQfxCtfnnDKo5xSiA/RYO5nOsfwZ2tQYxCZSvE0E=;
 b=NcAo+z2nVUKfAbXHX8+/JNQRLxd3L2+2MbudJnBUuVna9YFxYPAOK/RQQeBrxsMHI76UhBuJV5CUrng5n68QqpOhHIu2Oe8hA8+Npdois/QJG6nntjdZ1I7n6Dffhr7DaSlMXJJjS9aOJsLkCviQ8JZGJKd7lgfsg7NBMwWmouI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR0402MB2878.eurprd04.prod.outlook.com (2603:10a6:800:b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.16; Mon, 10 Aug
 2020 15:20:19 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3261.024; Mon, 10 Aug 2020
 15:20:19 +0000
Subject: Re: [v3 PATCH 10/31] crypto: chacha-generic - Add support for
 chaining
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
References: <20200728071746.GA22352@gondor.apana.org.au>
 <E1k0Jt6-0006MN-FB@fornost.hmeau.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <cdc28bf5-69bf-5915-db6c-92f287ef8f07@nxp.com>
Date:   Mon, 10 Aug 2020 18:20:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <E1k0Jt6-0006MN-FB@fornost.hmeau.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0101CA0076.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::44) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM4PR0101CA0076.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Mon, 10 Aug 2020 15:20:18 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f6231a2-e506-4341-f36a-08d83d40e459
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2878:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2878103B4A4CB77749F71F2298440@VI1PR0402MB2878.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8qERiSY11USb9X/xnMYpRziVXSdvBP4ubjEgdlqKB4PBlZnq8w4cPTRPKZCgy3ikaZcw0XvYk/W9/ZDYHSG+gr0Io3qgKJoRiBBwvs6EWU4Nl/oImx9EWzf/B43Z6T6vuq6aIYGkrZq6OZKaQXpBuvSte5CPFr4xVrLBW4wFkbndmvsofSwOr3imn14Y3nf/JXSMOYQss90P+tfDr8jYdzl4+ekDSJ3/tWI1ZoB3BTc5bRYUiP9efLqiyC5AtF9F+QmU0xitcXGrqIf+E58BdTq1uG2uoGLX10xN2ugZv9moGFutTc1LjKuW6ddvLXJlefs6b4DxxBCqaEcyV4FozY6fQ/naQ2T93CCqDqwSibwUj38oe0zLf/ZzXYWrkUDRhrcS6itUncVs6hRNX673Qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(366004)(36756003)(66946007)(66476007)(66556008)(2616005)(956004)(5660300002)(4744005)(16576012)(52116002)(186003)(83380400001)(31696002)(316002)(26005)(16526019)(110136005)(53546011)(86362001)(6486002)(2906002)(8936002)(8676002)(31686004)(478600001)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ExHNwHG8npPpePB3JUpWrHEAcasDpMFCY4LYoVxzjJxgCokB5WT7XoK0Sl3xOrn3Cvd7Rd/7PwW2zjTEwiPHPh0c0X78UlQYoXbcCBctln/SWrCiJD1ndhEazO/h9vpl6jTO6iP4eP1N6uunSIH0ZTPWVxgWxyN4KaoXudwS/B0oFIkXqC4k73QfMusCX7N1QiUxejIxULpuUM2u9l8f6ou6O92G7g+oHrq8ELdq4nR/WIdNInbkB/eQGVXQ1k5QThAqwQPrGQ4IcKm+tIOlp8JhsuPiNqHic1gV+S3HUO/PdUK94FqzJ584VpBY93nwzWniD54bp9BFfFCmP7NZHyE4rn5QsWQlBXkmTrjAfztqJWeRfIG+P6fUGCb3NRl0wnXuAUcStZyv++hckNOos31LqZJOGWW8mje+soa8oiIvel0Bm6EdpjdgOY2WRFQO1jQCX/XfItF3tdmxZ4C66h+4m92VoNa3yWDQRYg40infrkxQPCFdiut5XKnrD2DkReSsyOkbWfdgeYC274VJ9CWqvzydLclp1LanIVRn+AMUc957Jg9wfTLkWVsSH1/5iwL7LWlNA+m4eh79mXNgf3Kp4sXa16BIMoBNMHs3ErGsIPb8u+9H2sRoJymeF908CZ8RQZUimEczQJBaZIQDLA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f6231a2-e506-4341-f36a-08d83d40e459
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2020 15:20:19.4025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2rHuPGZFhAHkB9vhmBFRo8yZKu38v90VAUBOYT1Nn0wf5ItmtegIGrgfjfxxmPDM9LTNq2SzOqea760D+IG/og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2878
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/28/2020 10:19 AM, Herbert Xu wrote:
> @@ -40,30 +39,41 @@ static int chacha_stream_xor(struct skcipher_request *req,
>  static int crypto_chacha_crypt(struct skcipher_request *req)
>  {
>  	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct chacha_reqctx *rctx = skcipher_request_ctx(req);
>  	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
>  
> -	return chacha_stream_xor(req, ctx, req->iv);
> +	if (!rctx->init)
> +		chacha_init_generic(rctx->state, ctx->key, req->iv);
It would probably be better to rename "init" to "no_init" or "final".

Horia
