Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF9DC55178
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 15:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B7CB22404
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 15:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Yr56Uhga"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1784035AbgJZPgk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 11:36:40 -0400
Received: from mail-vi1eur05on2054.outbound.protection.outlook.com ([40.107.21.54]:65152
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1784036AbgJZPgj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 11:36:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+wo8HkbKr9g78isxubQfpMee7TzLh0rzq1nTpiZGYRhIT9XMFMLs7qUfNn9TSQo+LVE343lmvyN40KRYn+i4B18SkvePt0DmlVDlifm0OGHXrCRsdpB/6fRJWPIPc6nGY7LFqRO11tf6jkrQvlW/7MR/JZnfF/LwxYIO4R1hTktY28jY2TgMeR+vb+oa/OA0eVTBt1yuaRyAdBxWdCulRk5PrJSfRlUY2ScSLbJfLr7XZ7AsEyDmukiWsMfZ07HmjmvfzG3K7m3GAxrQeiJUp5ls8JyjCDEAjHYRfbg0YY/9BoKLHEHYcp7/UBp3GIpKtoYGIdeFz0y8mLXlfKwuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXmqF2ORvTBPIV7ByxOqFBlCmIRLDb4eKIGIp6TQm/w=;
 b=ndKgb9dwfX8AaEOTsVgAkYpfSrj2iDOSF1UV2KnMEJKnWcoVDM1QL9t3b8bsjwUIke0o1NNgNfwh/l2lz2DS9ovrg3ChU63tu5LQThKrLnRMwPHiTC5ExUSbnXQwj2qTqsHBDXiWDBoyO4WOjV8AtdEBjsxeP2M/X4Kuudn/s+D8XOPh9W6JBUsLQL1SkYv7htUuEtAHlDYFtJeakFL29AK0EfEuH8NilD76h2ooLcu+bPARFcpGfx5bT7o0n4R0Oekxo8ypYKQU5HftCfPgUu4YB6+5CnwMiKBVY19JdFKkRQac+OhCZOLvyI1sBFz0R3Vs1vhYAE04Ma8Mn0HGAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXmqF2ORvTBPIV7ByxOqFBlCmIRLDb4eKIGIp6TQm/w=;
 b=Yr56Uhga4I5ukp4i2/Zpy7nuWFWAaZhnX2IZRLZqEaDwqiGU8eTYrTTIotOP0LZL15oElAuk4E6kmy2XHGfbVOrqBs7vFzV/dpzMnVvGm4cEEfQaFFlIEatk72o1EMXAX/nafPu17uX2oU0OFylg6W779e0hZjhhdiYVs0SQXrI=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB6141.eurprd04.prod.outlook.com (2603:10a6:803:f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 26 Oct
 2020 15:36:34 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::847a:fcdb:3b92:7a7d%5]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 15:36:34 +0000
Subject: Re: [PATCH] crypto: caam - enable crypto-engine retry mechanism
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Andrei Botila <andrei.botila@nxp.com>,
        Dragos Rosioru <dragos.rosioru@nxp.com>
References: <1603310810-25307-1-git-send-email-iuliana.prodan@nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <d54a2528-11a4-8a54-6454-a0d0fe06f39d@nxp.com>
Date:   Mon, 26 Oct 2020 17:36:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
In-Reply-To: <1603310810-25307-1-git-send-email-iuliana.prodan@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM0PR07CA0012.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::25) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR07CA0012.eurprd07.prod.outlook.com (2603:10a6:208:ac::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.4 via Frontend Transport; Mon, 26 Oct 2020 15:36:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 604d887e-8219-4488-295f-08d879c4eb4c
X-MS-TrafficTypeDiagnostic: VI1PR04MB6141:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB61416A4D3C14EA8BFCD603E198190@VI1PR04MB6141.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +O2wzNZmo4laNrO3/Tv6gFZt+tT3liks9+EOGaYe8IRV58ByaUtkSQZci8bhORKps8TMHvBmgjfFyof1UoMpVSdXfkAMmfaql8bbuneHkvn5D+pLu2FWYoPB+j5Q4xCTd33M20rBJnxrGO7GefmXJ8sGSxNX36RJxfHaDN3qjGJCDMBn/6cV+U6B4jjIfg9D+z2MHsyZglAUnslGUiAtpSKYzUp8dzBnJdBpE82hL+rMqxBYdCAPPQW7jVJaToi9/JfyEc5BBtINX4MEN+HqQ/2fAflaegs6Aeu/YMXxPYJKXRH+s6gGx/+ydwt8cM0N0HlB+mfX6WrrAwhU/jAOfTZTaQRWrsr7hXGLjwvCTIqerBVh1T94yVLLivm7tM9b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(366004)(346002)(52116002)(316002)(8936002)(2906002)(83380400001)(6636002)(86362001)(36756003)(2616005)(31686004)(31696002)(4326008)(956004)(5660300002)(8676002)(66476007)(54906003)(16526019)(16576012)(186003)(478600001)(66946007)(110136005)(26005)(66556008)(53546011)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cNc5J149tz9dZc4VV5ETVu5pkRqAebggc4pMRYpgWWKWtE0GTrIsTX9yY6ar7Dq2V/I6PusG3k/Mdij4Nx7AqTvKmGiiUCXaGHrcPIriGcbuTCz06AQaAzknnWwM4lPL98dNidVLxQTo2U6eMpuyWL9OPyLEoBTrfH6BkcT/Eg32QRZv0oKFJP2XH4l7xhHXaGlcQBszZRArghWiv9jtqlh1wjoyz8e0xdUtbUtCLbxR4JMTfe4sYG7jeXcbrjmtockSu28hhZ9inXuKejPmMujrFSzEDYq4hd8nWZ8pso30QHOaMKmRuLTqm+6j01qoVTPelTrg+/2aupI1P/X1suPHDMPFBBSA4F8g6scT3G3uGU64cB1MZ2P3QNuaYsWONxCa2W3MDgX8fIeJ6VeyeVXfxDWvc66NWSORumT68zKbo7KFtkPzGAhAoyoQ2Se9ekJSfodvA47ekx7bFzff+wUuSl8ZQRo17ri89OsZaVV60/4y6ALuxsawCMuSb1Rix4XffC5Wocd+5qsIFP/VB8NGMDTCWKf4SO/sinJX3crM2uQ0/+RiN8IslzCGZuBNjumohJB/pRoek/+bUzity2rWang2g1KxfE4btaEsvYv4tw7cK/Reou0zFPZvqbyYxC3C1jiQjqLw1BRYp5P46w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 604d887e-8219-4488-295f-08d879c4eb4c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2020 15:36:34.3521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5YRi4i9u9TzS5JjdnlIBMSRxeqZGgZw5m76F4mZTK0y77gzEj9MpdchC6zaHh7QQMe6LB4QTjUr4AdLs1/Htw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6141
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/21/2020 11:07 PM, Iuliana Prodan wrote:
> Use the new crypto_engine_alloc_init_and_set() function to
> initialize crypto-engine and enable retry mechanism.
> 
> Set the maximum size for crypto-engine software queue based on
> Job Ring size (JOBR_DEPTH) and a threshold (reserved for the
> non-crypto-API requests that are not pass through crypto-engine).
				       ^ passed

> 
> The callback for do_batch_requests is NULL, since CAAM
> doesn't support linked requests.
> 
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> ---
>  drivers/crypto/caam/intern.h | 3 +++
>  drivers/crypto/caam/jr.c     | 6 +++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
> index 9112279..44fe6ee 100644
> --- a/drivers/crypto/caam/intern.h
> +++ b/drivers/crypto/caam/intern.h
> @@ -16,6 +16,9 @@
>  /* Currently comes from Kconfig param as a ^2 (driver-required) */
>  #define JOBR_DEPTH (1 << CONFIG_CRYPTO_DEV_FSL_CAAM_RINGSIZE)
>  
> +#define THRESHOLD 15
Unless there's a comment added for THRESHOLD (e.g. what's in the
commit message), I don't think the define is helpful.

> +#define CRYPTO_ENGINE_MAX_QLEN (2 * (JOBR_DEPTH - THRESHOLD))
> +
What's the logic behind multiplying by 2?

>  /* Kconfig params for interrupt coalescing if selected (else zero) */
>  #ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_INTC
>  #define JOBR_INTC JRCFG_ICEN
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> index 6f66996..88540c9 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -550,7 +550,11 @@ static int caam_jr_probe(struct platform_device *pdev)
>  	}
>  
>  	/* Initialize crypto engine */
> -	jrpriv->engine = crypto_engine_alloc_init(jrdev, false);
> +	jrpriv->engine = crypto_engine_alloc_init_and_set(jrdev,
> +							  true,
> +							  NULL,
> +							  false,
> +							  CRYPTO_ENGINE_MAX_QLEN);
Let's make the argument list more compact.

Horia
