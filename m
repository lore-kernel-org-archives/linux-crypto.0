Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A0BEC433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 15:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 006102064B
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 15:10:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="QkNICgKk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgGHPKX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 11:10:23 -0400
Received: from mail-eopbgr70104.outbound.protection.outlook.com ([40.107.7.104]:6094
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729022AbgGHPKX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 11:10:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jBMx8S7ToZiVEXIFf54RkEbCQryGyGWoLKq8hrJjKR52mfIQvY3oSWlkLf+yF0vdyaMxlzsCMOqddpgColTdEJR9Jxu5y6lfu1c12v0y2DgS/0CnhZcqsuUua0qY1O9cHMNunvmZjb8ixLILUraSCm7O1NkUvhyjM+DG7LhnSnNZ4We7pL4EJltTlXK7wsbT1HxJSWeozOFkxhqXVieYEGIcea5bS+j01RGc+4EJw2nv+CKRmiL+nUMGL9neP2o88N8Yie61TD1sXxfxHil8ZyIIE8IJEthwZ/mDPVnS6pZv4AdADcQxj6XZ0enloqTMVNwrP5vwpYv72KJ9v4FS5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAdFblfSHw8bcOI/heroPcWyFme7XIEn9J8XBONW6aE=;
 b=cZNtmLnJiYGcC0B1YSK2AEKZUvtmikropm74csPg+MSt0JiLy8onOx0CDl2cU7vQsXp3GvUuZNp91ZZhSbsW1Pvb3N6lsY4Yx/cNTXNRCznpKmdFv3emDBgm40e+VQufv0eFNyZxJtcWBLcTSvaikcW69MxeNWGQ4Qqe3TOlFLVrdDDshLsm5Twmvkib+Ow9+heBs/mngd1lyCShYYQIutfNhhVVVnwdxsWTDWD1KSUzbOGvQ8c9jPGtbEZNqEE4b/BoGTetU/q2SFe51dVMLFydBV1w/v/2m7eCsDYGdjvDw95obvK3UcCgld01HWPnuttQrSDiAZQZSxmylOGJEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAdFblfSHw8bcOI/heroPcWyFme7XIEn9J8XBONW6aE=;
 b=QkNICgKkC7+odwYOvDQZMPt7vRF516kV3NUtX+vct74VCXtIlKM9NK8wjEJ/wbz11GHdlwDzGR+drbiSoWfFThyIoBWk+QgvxXx4ol0hB0zObhAWzLtRU+TUaQsMeFIwloEaQ/zLXmUfPIEtQ6UHqIzBFtpt+LmA3nwz3MvvLzM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM0PR05MB4226.eurprd05.prod.outlook.com
 (2603:10a6:208:57::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Wed, 8 Jul
 2020 15:10:19 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3153.030; Wed, 8 Jul 2020
 15:10:19 +0000
Date:   Wed, 8 Jul 2020 17:10:18 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1] fixes
Message-ID: <20200708151018.sdoufm4jnkedelsz@SvensMacBookAir.sven.lan>
References: <20200708150605.60657-1-sven.auhagen@voleatech.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708150605.60657-1-sven.auhagen@voleatech.de>
X-ClientProxiedBy: AM0PR06CA0089.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::30) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (109.193.235.168) by AM0PR06CA0089.eurprd06.prod.outlook.com (2603:10a6:208:fa::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Wed, 8 Jul 2020 15:10:19 +0000
X-Originating-IP: [109.193.235.168]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35b223d6-e213-48e2-d2cd-08d823510736
X-MS-TrafficTypeDiagnostic: AM0PR05MB4226:
X-Microsoft-Antispam-PRVS: <AM0PR05MB422602A50AF15C6723848965EF670@AM0PR05MB4226.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W0yNf/FzZJp2dOInRGDT91LTSLoFa18zxP/TCGE3hdQl+0+px/yqvkN1WOo50a30JWx6zNIYDYu8Eb8Rg8ad4dnFSs1tWrcKImGa4hrC6kcdOyz3L5JartIjJuCtKxG/CgRXi5IX/4I2ge5G1R5Hk5rQ7vqElSa+DSbGMs0ZezUzufvWB94ESScTuHugppCLq3miJsY4u5L16Fi0T3086gs6LX/HuAnSGQSwmYpgYYPaSFbcdGEb9Xr0pbtGA2jARTVeFGEDjRFoxAktGUJ/jRr62t6Dkst3/H2SR5rIL7G3lqUD4O0Xpt9csSrSoHVsR7nHfud78Tz7gTZclozM5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39830400003)(346002)(376002)(366004)(396003)(66946007)(1076003)(66476007)(66556008)(55016002)(9686003)(2906002)(83380400001)(5660300002)(8676002)(8936002)(44832011)(956004)(86362001)(16526019)(316002)(6916009)(508600001)(26005)(186003)(6506007)(52116002)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: rZO+eUGDZBd8YxxvR3ldW6avhfAlkbWcGjWXrWFGKjlWbpaoY6AxK1hPaFoiVn1Ah/z3w5XrYJHnK7mhsfouNCE74IvyrL3B0Vi1nnfJFLhcpvkgFoEWeIfYZMy3lUKO5TYOSDkv58eE7UnwWmLDf2k5NRTnG0V9nyFh+DOhoIzAEsQA2knguw20ppA0du+Olgc/HK02wsc3W30up1ZYjP32MJ2TThUdvn06KHYt2sgsJSNDOsHMW5vf9kN6GjLWg/VebTyeCrRggEjMh0oIQSmkq38Am6UHhBlva6BmbtjXtM0CLe0dOH5Gt6AVMV0V0QnFxJIHn2gf8DcnxO2GdYgNIScKe3pswWuhq6HKglGnLqTJV+tKMRKUfRg6u7kEF8AYtonbr7V0R6Sp/x9tP+Uej+tBJb8uM2/3p/yPhPZUMpvi8YYq1+1Jrk3NDzJZKJhVu1nY8WgMvpDsDfJbRrR6qLA77uMx9qBu5HEJywqpnbwNKwbi7BpPmad8l+K+
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b223d6-e213-48e2-d2cd-08d823510736
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 15:10:19.5080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nEl4BGLj7DZnOopYCSKUDIKVt41Mv2i0XMqXiWm5koOO/WdCAclgtx8FSjTsHrOoGx9oHsXRYmj4P29v8alqcPCgHlBq6h6yf/Q7DpKI7lk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4226
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I am sorry, please ignore this email.
It was send by mistake.

Best
Sven

On Wed, Jul 08, 2020 at 05:06:05PM +0200, sven.auhagen@voleatech.de wrote:
> From: Sven Auhagen <Sven.Auhagen@voleatech.de>
> 
> ---
>  drivers/crypto/inside-secure/safexcel.h        | 1 +
>  drivers/crypto/inside-secure/safexcel_cipher.c | 6 +++++-
>  drivers/crypto/inside-secure/safexcel_hash.c   | 6 ++++++
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
> index a7ab1183a723..7341f047cb2f 100644
> --- a/drivers/crypto/inside-secure/safexcel.h
> +++ b/drivers/crypto/inside-secure/safexcel.h
> @@ -40,6 +40,7 @@
>  
>  /* Static configuration */
>  #define EIP197_DEFAULT_RING_SIZE		400
> +#define EIP197_DEFAULT_RING_ROTATE		50
>  #define EIP197_EMB_TOKENS			4 /* Pad CD to 16 dwords */
>  #define EIP197_MAX_TOKENS			16
>  #define EIP197_MAX_RINGS			4
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> index 2018b7f3942d..2c4bda960ee6 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -1218,7 +1218,11 @@ static int safexcel_queue_req(struct crypto_async_request *base,
>  
>  	ring = ctx->base.ring;
>  
> -	printk("Ring %d queue length %d\n", ring, priv->ring[ring].queue->qlen);
> +	// Rotate ring if full
> +	if (priv->ring[ring].queue.qlen > EIP197_DEFAULT_RING_ROTATE) {
> +		ctx->base.ring = safexcel_select_ring(priv);
> +		ring = ctx->base.ring;
> +	}
>  
>  	spin_lock_bh(&priv->ring[ring].queue_lock);
>  	ret = crypto_enqueue_request(&priv->ring[ring].queue, base);
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
> index e1d65788bf41..55a573bbb3ae 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -744,6 +744,12 @@ static int safexcel_ahash_enqueue(struct ahash_request *areq)
>  
>  	ring = ctx->base.ring;
>  
> +	// Rotate ring if full
> +	if (priv->ring[ring].queue.qlen > EIP197_DEFAULT_RING_ROTATE) {
> +		ctx->base.ring = safexcel_select_ring(priv);
> +		ring = ctx->base.ring;
> +	}
> +
>  	spin_lock_bh(&priv->ring[ring].queue_lock);
>  	ret = crypto_enqueue_request(&priv->ring[ring].queue, &areq->base);
>  	spin_unlock_bh(&priv->ring[ring].queue_lock);
> -- 
> 2.24.3 (Apple Git-128)
> 
