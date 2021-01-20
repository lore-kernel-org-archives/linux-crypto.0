Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9446DC433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 12:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D13B22573
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 12:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388326AbhATMfq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 07:35:46 -0500
Received: from mail-db8eur05on2139.outbound.protection.outlook.com ([40.107.20.139]:56289
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388259AbhATKwr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 05:52:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=na52zEOFVgKaDq/r/BT4Dzx0nMR139i04fY65RoCGfk50CHIuGiG5NkR6+fUJghkc8HiuDQbG6FqwQORNDal2eOZTzHeQrfR3cfHxypIUmGk8T5ZQnS+jdGW4zQXu2a9zY+i96CBUEWYdbXRiXKxIXoL9WLrNT5foXHC7eLhdv+8w3TaCfcChzjx9P3nK94K1uBT/wBEt24rpyNdckXEl9jgIS1pxFha++2mQ6SCBneTV9UR4L/P05HXD8GdZHzzUOve05iDs95XZjSrMeex8jI+llBFEEwn/qabu4xQ6UMMLBa5j1AUaR3+XqQgI9qwwbpvOaaCQqelPrY+28BdPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNmPUoAmlvMIvE6TbRWd+CvodW5JBXLG/gAYw568brQ=;
 b=AVBv236jqD3N3T/HUK9K3fwlLsbpzF7XSB23ug8gYomRsuFh4Ion80ImoCx67oOTX+V7hqmbu8DOoqzZTuGrewI699u/3CCUyxwzc/Kj6W5JNBV9JrYQOFqxklmpeXAwlsjrE6iLeY2toRDlqOCeAE/IgJ2Q4lJgi2ARarQxuPOqv1hPNlq3yDWzFdan6jbiah/KOP3a3ONgzscNZulQn9wLmXdjdVAcZ1Mc/ti2L8/7UXTyw4agNwCY5bE489DTzgFMG9+xuIznWG/BAjyy6iPPoHu32AjAMN1zWsWtFUI2MR7hSkLnAE410jBzOAtb5yWoyG9V41Jf0QIDrv7lzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNmPUoAmlvMIvE6TbRWd+CvodW5JBXLG/gAYw568brQ=;
 b=e7nmzQ3Xy6yeVppG8muS78BvqMvdiLLpFCaWBYODid8Uwqc7EtW+B40P+INWucK1p6TS0A17aSgSHlH94doSTqtB/P4pXbcIk40ec/0a92J2DuNNybi02cNpH0cZWt8Iz6kKqueO/Xs2t8tsSGhHGtB+8xnPkv9L79Rf/63cNS4=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB6355.eurprd05.prod.outlook.com (2603:10a6:208:142::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 20 Jan
 2021 10:51:55 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b%6]) with mapi id 15.20.3784.012; Wed, 20 Jan 2021
 10:51:55 +0000
Date:   Wed, 20 Jan 2021 11:51:43 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: marvel/cesa - Fix tdma descriptor on 64-bit
Message-ID: <20210120105143.dhthi7aqonr457bi@SvensMacbookPro.hq.voleatech.com>
References: <20210118091808.3dlauqgbv5yk25oa@SvensMacbookPro.hq.voleatech.com>
 <20210120052629.GA7040@gondor.apana.org.au>
 <20210120054045.GA8539@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120054045.GA8539@gondor.apana.org.au>
X-Originating-IP: [37.24.174.41]
X-ClientProxiedBy: AM3PR05CA0088.eurprd05.prod.outlook.com
 (2603:10a6:207:1::14) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacbookPro.hq.voleatech.com (37.24.174.41) by AM3PR05CA0088.eurprd05.prod.outlook.com (2603:10a6:207:1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Wed, 20 Jan 2021 10:51:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d997de30-8f41-4d4b-57ac-08d8bd316744
X-MS-TrafficTypeDiagnostic: AM0PR05MB6355:
X-Microsoft-Antispam-PRVS: <AM0PR05MB6355ADF9DCB5A880B18E8BDBEFA20@AM0PR05MB6355.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gExQu31tF7eF7bl5oJmu4v/z8AnUOngspWzMOu6DcNjowBTNCmhjMgTkB+9kuX5pg7DywIgHa3EfFzr9Z/hwY5lwlu/1YHz6xEBxFiz21ES5DCrppp75diNXxv8/rrmYai3c2LbFsaRJ6PfBJEu1dYPdsigZDJKiZveQejYZ+AEjBFbLVj5M12rIhyoflDkM9kn+2MSuLn8c6iRnE6N2EtPO27z3V9v7FIuzxBO8jZKBmr7xmPD7OQqVaiYtEntM7FoM65bWTjc4X3+srY9O2lAlQvtYSx+ljkmeVWLcZriLBivLxKQ5eAeRuDgr+333tKB2D+rPpc/7TdKyj1yTDya5k6yWuOlZMyORVwHqGi7D/qHW/ysgiIjAa4aA4mP1Ky4w0G0d5Zwdw4d+b9GbbvpHv3wiDYJY10SIp/Awl/oJSXCIW9VCd0JQNHusrX5CPFq71bdBztd+LSlSIbgeeqnBElDnVoFZVh+csrRBWZIXyNASRMi+v4E4PbibyPGD5XJ7f2b5pXz5cUcRgbiEQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39830400003)(396003)(366004)(136003)(86362001)(478600001)(9686003)(5660300002)(7696005)(6506007)(83080400002)(55016002)(8936002)(45080400002)(4326008)(1076003)(83380400001)(16526019)(26005)(956004)(44832011)(66476007)(186003)(66946007)(2906002)(52116002)(66556008)(8676002)(6666004)(6916009)(966005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rJA4TUmkWWyzjbMCGtlkdaatJE39GkrzIDlRfyg/UhYdHx2QPTHZfG89Og17?=
 =?us-ascii?Q?Pke++lrwlPBMK75/qzDFBWbkUz+gGg/qlXfszcIPpoCRsCZvHZV9TTOwaFhz?=
 =?us-ascii?Q?iqLmTfST71drurOGWQyVC0HvRdMIm9r1xtTEWGpc6FZqSe93oBXMTGBpuShR?=
 =?us-ascii?Q?/UZRSAe0XWzGYyMRJS/RsLhrcrw6EjbOErGArw5EN78vWpeD0lGSsrmmIPrr?=
 =?us-ascii?Q?kxuPtJqaWjhPQh7gsQOY1Ggjw5p1OOp9/cB/xMbQAL0ymmSvD2S1UxRuy/Rz?=
 =?us-ascii?Q?Ed4aJ766P7vnWQtIENE4+7XRQAUrwUuFr7da/HhuE2QYzOErJjkxdeOfbNoF?=
 =?us-ascii?Q?/EwBoH/c8bPkNbFAVEmvH2qe99UFTMIDt/3xVXR7+quXlJnUUol3qyyXq4aU?=
 =?us-ascii?Q?O036TAVZgH5Zi5T9JZTtOKpVS1PdyaDtb24QuyVCjAvL7b47qWq/Jd9u8DNg?=
 =?us-ascii?Q?p0i1QDJtIeRreRhyCf5xs6zeachI5qlo2k0PGq8VAuqEa3BxkiNXNla5pai8?=
 =?us-ascii?Q?8UmHTEQRK3YyGyCMkPb9I5/urApQigH0y+bujjvhiH+xI+lV89X+NTvHHZgK?=
 =?us-ascii?Q?H+bMAFonU/1Chc/K5hW4mByWfPgEGoztgg7w0jyE7NpF653IZX3e4GLlrJZ6?=
 =?us-ascii?Q?+MzWkVofASxmT9weMESyyxnPzQh2eVyLNk1MzNfdDTpKUoOpW8ja1DJPEydc?=
 =?us-ascii?Q?bYyz+MbWHarNh0Nece5HnZ7FxEl470Mrx6XfD0omRVPJ8rqFnj8u0RSXHm/z?=
 =?us-ascii?Q?vdlwHbfpW0soxJ8FMd5DmWyhRJ+nbKq4hR0ftAIAm8oOdI6FY/VRLVn0OCj/?=
 =?us-ascii?Q?rmxeOT9vLY1+2lqXlkkjbBDhSKlWnSYL5VVodCffbHqeKFU8HKelBqmYz0nR?=
 =?us-ascii?Q?NPqULD8pmHzsyk5FKhWUcwDtLvuqnO0ZO5zjrGQZ8+7Dx/+TkGPrgOLvBXiz?=
 =?us-ascii?Q?hDe0HbWnsld4PA7glpE+gE/G/HfQK3F3Er+cPdGbo6ocYYxOEe+cEKydu0j5?=
 =?us-ascii?Q?kv0o?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: d997de30-8f41-4d4b-57ac-08d8bd316744
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2021 10:51:55.8495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vDPa+5a/cvpCE12/GLwBn5Pyq2ugVBtzknNCmiTSA06Qo1kCdJndjpTMuQoJ+L/TTKz+mgmwecgrw3RA7Xo0RFuag+YWQ5AWZU4Dv09zfJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6355
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 20, 2021 at 04:40:45PM +1100, Herbert Xu wrote:
> On Wed, Jan 20, 2021 at 04:26:29PM +1100, Herbert Xu wrote:
> >
> > Is your machine big-endian or little-endian?
> 
> Does this patch fix your problem?

Yes, it fixes the problem and also the failing hash test.

Thanks and best
Sven

> 
> ---8<---
> The patch that added src_dma/dst_dma to struct mv_cesa_tdma_desc
> is broken on 64-bit systems as the size of the descriptor has been
> changed.  This patch fixes it by using u32 instead of dma_addr_t.
> 
> Fixes: e62291c1d9f4 ("crypto: marvell/cesa - Fix sparse warnings")
> Reported-by: Sven Auhagen <sven.auhagen@voleatech.de>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/crypto/marvell/cesa/cesa.h b/drivers/crypto/marvell/cesa/cesa.h
> index fabfaaccca87..fa56b45620c7 100644
> --- a/drivers/crypto/marvell/cesa/cesa.h
> +++ b/drivers/crypto/marvell/cesa/cesa.h
> @@ -300,11 +300,11 @@ struct mv_cesa_tdma_desc {
>  	__le32 byte_cnt;
>  	union {
>  		__le32 src;
> -		dma_addr_t src_dma;
> +		u32 src_dma;
>  	};
>  	union {
>  		__le32 dst;
> -		dma_addr_t dst_dma;
> +		u32 dst_dma;
>  	};
>  	__le32 next_dma;
>  
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: https://eur03.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2F&amp;data=04%7C01%7Csven.auhagen%40voleatech.de%7Ca0b247450d1b4580bc8408d8bd05f397%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637467180564502107%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=HN3G1xs2oayGqA7gCAuPe57Fshkjci1ObQIz7PouXC8%3D&amp;reserved=0
> PGP Key: https://eur03.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2Fpubkey.txt&amp;data=04%7C01%7Csven.auhagen%40voleatech.de%7Ca0b247450d1b4580bc8408d8bd05f397%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637467180564512065%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=6VdTmXDuV4ed5p%2B8ATbjpn%2BObkSqBFyqjkRYPod8sC4%3D&amp;reserved=0
