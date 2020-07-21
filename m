Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703E3C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 21:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5195B20717
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 21:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730300AbgGUVcT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 17:32:19 -0400
Received: from smtprelay0196.hostedemail.com ([216.40.44.196]:47834 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726658AbgGUVcT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 17:32:19 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 469E718224D68;
        Tue, 21 Jul 2020 21:32:18 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: loaf72_4608e2426f30
X-Filterd-Recvd-Size: 2717
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Tue, 21 Jul 2020 21:32:16 +0000 (UTC)
Message-ID: <11ac49bc33546ef9ebc4120878206bd882667d8a.camel@perches.com>
Subject: Re: [PATCH v4 16/17] crypto: sun8i-ce: fix comparison of integer
 expressions of different signedness
From:   Joe Perches <joe@perches.com>
To:     Corentin Labbe <clabbe@baylibre.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 21 Jul 2020 14:32:15 -0700
In-Reply-To: <1595358391-34525-17-git-send-email-clabbe@baylibre.com>
References: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
         <1595358391-34525-17-git-send-email-clabbe@baylibre.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2020-07-21 at 19:06 +0000, Corentin Labbe wrote:
> This patch fixes the warning:
> warning: comparison of integer expressions of different signedness: 'int' and 'long unsigned int' [-Wsign-compare]

I think these do not really need conversion.
Are these useful compiler warnings ?

> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> index 3901e3401c6b..7b2a142c9b8d 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> @@ -566,7 +566,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
>  static int sun8i_ce_dbgfs_read(struct seq_file *seq, void *v)
>  {
>  	struct sun8i_ce_dev *ce = seq->private;
> -	int i;
> +	unsigned int i;
>  
>  	for (i = 0; i < MAXFLOW; i++)
>  		seq_printf(seq, "Channel %d: nreq %lu\n", i, ce->chanlist[i].stat_req);
> @@ -778,7 +778,8 @@ static int sun8i_ce_get_clks(struct sun8i_ce_dev *ce)
>  
>  static int sun8i_ce_register_algs(struct sun8i_ce_dev *ce)
>  {
> -	int ce_method, err, id, i;
> +	int ce_method, err, id;
> +	unsigned int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(ce_algs); i++) {
>  		ce_algs[i].ce = ce;
> @@ -858,7 +859,7 @@ static int sun8i_ce_register_algs(struct sun8i_ce_dev *ce)
>  
>  static void sun8i_ce_unregister_algs(struct sun8i_ce_dev *ce)
>  {
> -	int i;
> +	unsigned int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(ce_algs); i++) {
>  		if (!ce_algs[i].ce)

