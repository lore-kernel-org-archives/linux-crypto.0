Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010010.outbound.protection.outlook.com [52.101.69.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC342DC765;
	Fri, 28 Aug 2026 19:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787945135; cv=fail; b=K+3fyCzz2l0lUTA06OsfYrXmyukmCez7PVc/cao+hiPtNDwJzFRdAWKrJiozLnrLOViN429pHhvkWiWGsyF/0xbrEBPnFWjb873WlPW0OatKjsJlmXE1xGLyiAH7onOF6vFgHg47YIkeZDmwm0IlyKlWiDWtpQatiyUCLT9PQng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787945135; c=relaxed/simple;
	bh=unewhsB5HlWmX8FJX7z2VNLs4MRYjGmMyOdYr0ga0lY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nSWUQcLFY1fwgxFXFkAlwK4T6NGVGGP3LvZAmfdwtTM6eEMp+bi//6sxHsMUZ3JYAmVGah7WEiB6cint7PloOIUBij9C7sTMEm7CoWMUd4mUK02lNpSx1f3sA0dFXB98nNTJXuSY/BBa2iIXyO0wtBNX+JK4ZIEBeojIi+o5lrI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=v5hg4np5; arc=fail smtp.client-ip=52.101.69.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="v5hg4np5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xns2pypv7ZE1Y+l1BqxXm57Pf7+jj7C61WxVPUJwvR0dz78QezCEKoEXE9ow0CCCktKgINM63XQb+AnOcwOE9yliIH1R4pPubuosiOV69arSAlk0j8WHDg4UMOlBR3tLHrpWLlLT7YO18+62cPxWTroKEvADOrZLlkXioUBKQW+n8re7kyYqeYW5xHJ+/hvt0CzqzbpRK5kxBFGI8j6GqIbozl26kYEOeztmIz3fNJNu4kHEB/zHR4eybpwm5JTuH1YxYBHUF2jcNIN3xNU/7ADgNP/Q5XGZmqOEHrPD4+R0eaue2NASMLCJr68j0aN4UPJ1Sy8EUUHunJVY7lCw/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5TAnZ8sExFxW6oNv+UvoCeeODAWEmkjbKvwDKq8bQkw=;
 b=zUXI0FYobfr5YEE834IGYmqOlrdwobHwpfiER/M0hqsBVnypiPDsw1Yie8esNtxDWB+DdZNCmHPpx7KPgyXko5C5d7hGD7k4wlPvm2Ag7Gx/b/DIrrdhvKAM6X5HxlVUDcLccTrXjYJJxl3kJLPNlf83EPT6kqlcGwCNi32SKaLkhw8WTLj/H9LySNTKy8YxDN8S1LDy38wnbX8/beJdXHhPbNFf0K2apQDzD9OSErkRmTMHK9XisqZgBJCsSO1H82ZNfkJvFa9oE0BAj325LIjx2D6/g/hI0gWosZLcDUDuOCD5zU33nrNbiXiFjHKwJKIJuPp0VDaZjtaXVGiiiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TAnZ8sExFxW6oNv+UvoCeeODAWEmkjbKvwDKq8bQkw=;
 b=v5hg4np5pUbejQ6q4iFdlAuStQxoGylaEC7Bi+Ei9mqmun3COiCTAh6Ho3H+eQ04su/qcsYQZbZYd8I0H7GWM3JElLcr/IYAx7QYso2zyop9tk5dgYDEmJLnEnVBHQHLsH/69abi4MktsnCP+TCvMa+DgQq2r8MigG/upLlYLees9EefHM0//hpKbzWyq/I68rZJDCIgyMvx8EyuyVDe1k4sJsGmYDPg82mqicJ5mu27v2Xq0kvYLk1ScNURm4YB6z+J3SMkVyrEOV93XsG+a9OFyjZTV5+x7TbCSMkfYuk/Bxd+77hp9C1Qa9WtNVE/IrUlRWz72O/mqpIEKAEZcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by AMVPR04MB12674.eurprd04.prod.outlook.com (2603:10a6:20b:775::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Fri, 28 Aug
 2026 19:25:30 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 19:25:29 +0000
Date: Fri, 28 Aug 2026 14:25:19 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Linmao Li <lilinmao@kylinos.cn>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Frank Li <Frank.Li@nxp.com>, Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Radu Solea <radu.solea@nxp.com>,
	Franck LENORMAND <franck.lenormand@nxp.com>,
	linux-crypto@vger.kernel.org, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: mxs-dcp: handle zero-length skcipher requests
Message-ID: <apHgn8-IcTshYnfv@SMW015318>
References: <20260828093209.3179074-1-lilinmao@kylinos.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828093209.3179074-1-lilinmao@kylinos.cn>
X-ClientProxiedBy: PH7P220CA0082.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32c::17) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|AMVPR04MB12674:EE_
X-MS-Office365-Filtering-Correlation-Id: c4bc1c12-9588-4e18-bffb-08df053a1ea8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|7416014|23010399003|376014|1800799024|366016|10067099003|56012099006|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	MXKytR4triVahEi9d68VxWg61n1NL0q8Y8Ik1dtR4+sOlJryql7/vBYRBGDKn2xrwF4qj6q+6gwRy0URKVKxFU4X4DEiJT3UHo9PfcFOADXed82eKpsM78yYsmCKbR9fPnJC+FmtnUO03zoTWuC3B5oklUKyxX+qtzgWpHAhkEgBv+ncf4pHRhb0QM7bRW0/nWYezOVn5mlnMrzVqXjxRy3it8eZzEV/7ImDyLfbu2UfonTN4yoO4njqBrU9qVbpFuX6vu1bO2ZjqNJSSE0clBwek+tfhZtX7ljA18ouFr2dG+V1qtUgcVkSVj1z5f4GkwYdQgO83ZLk3kvy/DKj7bsdpPwqy51LnQqj+CJKxwf2xbywR1WWse86V8oMbFsZuzUeM+Sy/ydG4HUkYQsBwaivuOf309+O0AlmfYI8h5tXaGDJoetqN4QsY/Cpw75x1c/VC4lNyof+CgRMDR/kC+aCBRLaKa3fV4Q551BFHnGOYHsQVL6jkuqRzBO8HM2TC6k1RkvXWLR0Grcplen/+FAEvoyF0oa1VxvTGsaSIfLxUXSqKzgl8mDjhBvGm7IQaQCcof5SB6uGchB0fq4jL6shvuBds2qLWwLFtnTvAHXuSIGriu1wqbpupL4mpiXKAPw15f3chdJGAh5veuzn9NzCBEZzFytIddQuxh4GIOQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(7416014)(23010399003)(376014)(1800799024)(366016)(10067099003)(56012099006)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nHUyYRXQSpIXbFBw9uA6dY4fedzgncE2fJm0zqJbANFARXL17SUlqrlXnyev?=
 =?us-ascii?Q?z3F8cxakhdymMzOmz6EE68XF80pT0uPtdVA8ZLe2h712ehx3edudLxYro+/E?=
 =?us-ascii?Q?t0i/xMBmiQDL+yFeuy7L3hkyNGRfpJJBDBsy8m0pAb4VEk6zEX/XW7NjmVWA?=
 =?us-ascii?Q?1zOR3rdpEykTr7uU/Kv+20NisN+KerIUJZT40/5laDh8Kw+JAiB9jUwPbJ2P?=
 =?us-ascii?Q?0DAvZjPfg74FHpyP2F5CMsgg/J0JQ1phXeDBvlsfcrvCk0ZNbHqc9kuvAXlh?=
 =?us-ascii?Q?NPkc7BdG4zVajSfecmKA8Za1Oi43G8pV8BFonPJ38z+/xLaDR+2erFxe6StQ?=
 =?us-ascii?Q?da1Hdm3uocQVo0owaXYXHW+1N4yu/zLmspB1dhJOrP0Bu/sCgCubCVgkyFxi?=
 =?us-ascii?Q?xqFChgRXpjBpwN/PQdA7D8kC98KiWlYd9D+gBVXWVCyq4UANR8iTrfzgcoVk?=
 =?us-ascii?Q?jgS/gjxwD4Kbn6Xa1dNqNkW4QqJHvkRI7Bj4y/Smr3cjTrTnVx4x7TIsPaP3?=
 =?us-ascii?Q?KaKgRndowFc0J/55usLxeEMXrQmHVU41lFNEcJo3YU8sfz4pkh/N/3SaDhPK?=
 =?us-ascii?Q?2mNFZkKZRTGXeA9jo+O9dlS7JKXBx4lUZlpjw8SrP2tuUNsxY1US1w9EfKcV?=
 =?us-ascii?Q?T/s+gimJw5bLt/HWLpNy8Kd4VcjGlFtnFkM4ZtmP4dlQY6ORGBX59lI9tq7s?=
 =?us-ascii?Q?rDi6TUQ7S0PXGl2LGADUU4wV+7HLE6QUZCxmatdExucYQ765aHJ39xO39BCP?=
 =?us-ascii?Q?ZD1GKawfp0wNgBmhwrQZlTpjAOnPBjoeA9SXfz/b8Ddu5XFfFRnodO7vr6/g?=
 =?us-ascii?Q?tfxfL/WG+CVRcSZ2un8YPH1yVw2CN5X6B6PleaLSqWBghOdZVwrzHLKDQyFY?=
 =?us-ascii?Q?r+o8mkB/GvyhoJi2EZtwdyGcT6bsEE34Ii+rQ7xXEGJmfMiFWD5mQhom44Qy?=
 =?us-ascii?Q?9ANX6GpsrwWuldrBIH5DBbaSJhmsjf2LLW89IBRac72beUA84MsYfbip0cqN?=
 =?us-ascii?Q?vTlwFSA35vxHDEZYho3KH08FR0H8rdG4wAZtGFNdACWMAe/pwLWzQ4nQ638S?=
 =?us-ascii?Q?ouS3NdYC81R4X5uTNNisvfUHvFGLIfHhImJtmKVD25Wsosy3GSNlMZ+vXwYD?=
 =?us-ascii?Q?Pdn+Jfnk9dwFSP3hEBjK805EQCmsTfHj+FMTz3jVr+3cnvqdOvKu6AmHHkea?=
 =?us-ascii?Q?0PQoQLENtXaQdTdVB73nII1HNkGzlOJvaotyJdowj84PIoxtODCySFGzHLyc?=
 =?us-ascii?Q?iltI0tuq3ZPlS76GjC0vJMQgXU3TJ1fGYrtJzbY+G4NQrdXBaCEFAofARMsb?=
 =?us-ascii?Q?59ZIk/TerayCmQwb+XCLkdu6XKg52quRMCTIgD6EwZ9fkzO/KR5PRpsI+Hg8?=
 =?us-ascii?Q?FDB0aP2CA2hHEX3r4oxrhEUoc25B80lFlpb+MD9fI4UF2nybV3SN1X2/Pfx7?=
 =?us-ascii?Q?PARFs1fyZ8jeR5i0+3n9jENxFRbFbS1xocuH452+OrVSxziqx6fpHOjiszr3?=
 =?us-ascii?Q?hVy5xdD8fjrAiT7trSVVBVatgpA55qg8mY8jIq/untEfIWxodoz0DVuNxSoy?=
 =?us-ascii?Q?A6Rkfgu4P+EH55mbNbHUEL2BC7PkiZ/2TZlX6rYR+6/klHLbyTkUWpHRNjKh?=
 =?us-ascii?Q?fsXETAuHXJ5BlYlA5S2sSAtoeo6t8bbxzeXRrfTwa7hHjeXFjifDtkIlarHn?=
 =?us-ascii?Q?VvrpSkmlP5wgZkzF4xHqDtCYVQ0/8NSxyHOlS9HnoFw1pBV8iiNWteJ47O22?=
 =?us-ascii?Q?2OKknFsyo02HAGZYA7aS9k59QT9+M/RitaAfXV95Lx2K1kbf1Ul4?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4bc1c12-9588-4e18-bffb-08df053a1ea8
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 19:25:29.7449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G6zkYfzVYl115+rziZ0jnT2OKb5xQnhe/j/dp65pLNzrxJGJU4v8X1FA8HdUiOMQx1lgww0TN42e7ZqqFHdklX9pQB+FZ02ofvba1xh3vnZEMAXBLAgHLReBYYT2cnp8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMVPR04MB12674

On Fri, Aug 28, 2026 at 05:32:09PM +0800, Linmao Li wrote:
> [You don't often get email from lilinmao@kylinos.cn. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>
> Zero-length skcipher requests are valid no-ops, but MXS-DCP queues them.

Any document show it? if return 0 when cryptelen, it is async, no
call crypto_request_complete.

Frank

> When such a request reaches the worker, last_out_len remains zero. The
> CBC completion path then subtracts AES_BLOCK_SIZE from this unsigned
> value when updating the IV, causing the offset to underflow. On
> decryption, the resulting source address precedes aes_in_buf.
>
> Return success before enqueueing zero-length requests. This avoids the
> invalid source access and leaves the IV unchanged for a no-op.
>
> Fixes: fadd7a6e616b ("crypto: mxs-dcp - Fix AES issues")
> Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
> ---
>  drivers/crypto/mxs-dcp.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
> index 133ebc998236..60794b4d49fa 100644
> --- a/drivers/crypto/mxs-dcp.c
> +++ b/drivers/crypto/mxs-dcp.c
> @@ -473,6 +473,9 @@ static int mxs_dcp_aes_enqueue(struct skcipher_request *req, int enc, int ecb)
>         struct dcp_aes_req_ctx *rctx = skcipher_request_ctx(req);
>         int ret;
>
> +       if (!req->cryptlen)
> +               return 0;
> +
>         if (unlikely(actx->key_len != AES_KEYSIZE_128 && !actx->key_referenced))
>                 return mxs_dcp_block_fallback(req, enc);
>
>
> base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
> --
> 2.25.1
>
>
