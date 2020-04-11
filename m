Return-Path: <SRS0=qmX+=53=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB582C2BA2B
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Apr 2020 11:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B09320732
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Apr 2020 11:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgDKLHv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Apr 2020 07:07:51 -0400
Received: from smtprelay0231.hostedemail.com ([216.40.44.231]:41940 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725951AbgDKLHv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Apr 2020 07:07:51 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 0D25D181D337B;
        Sat, 11 Apr 2020 11:07:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: force52_270ea654bb131
X-Filterd-Recvd-Size: 3427
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Sat, 11 Apr 2020 11:07:48 +0000 (UTC)
Message-ID: <d40b2b993d8e9764c5e7f6fd3f8ca037a9520b6e.camel@perches.com>
Subject: Re: [PATCH] crypto: marvell/octeontx - Add missing '\n' in log
 messages
From:   Joe Perches <joe@perches.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        lbartosik@marvell.com, colin.king@canonical.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date:   Sat, 11 Apr 2020 04:05:43 -0700
In-Reply-To: <20200411104458.21526-1-christophe.jaillet@wanadoo.fr>
References: <20200411104458.21526-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 2020-04-11 at 12:44 +0200, Christophe JAILLET wrote:
> Message logged by 'dev_xxx()' or 'pr_xxx()' should end with a '\n'.
> 
> While at it, I've introduced a few pr_cont that looked logical to me.

Hi again Christophe.

> diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
[]
> @@ -629,15 +629,15 @@ static void print_dbg_info(struct device *dev,
>  				pr_debug("Slot%d: %s", j, engs_info);
>  				bitmap_to_arr32(mask, engs->bmap,
>  						eng_grps->engs_num);
> -				pr_debug("Mask:  %8.8x %8.8x %8.8x %8.8x",
> -					 mask[3], mask[2], mask[1], mask[0]);
> +				pr_cont(" Mask: %8.8x %8.8x %8.8x %8.8x\n",
> +					mask[3], mask[2], mask[1], mask[0]);

Unfortunately, a pr_debug cannot reasonably be followed by pr_cont.

pr_debug is conditionally compiled and if CONFIG_DYNAMIC_DEBUG
is enabled, conditionally emitted.

pr_cont is not conditionally compiled and is always emitted.

So this is fine as is (or with terminating newlines added)

> @@ -1147,8 +1147,9 @@ static int delete_engine_group(struct device *dev,
>  		for (i = 0; i < OTX_CPT_MAX_ENGINE_GROUPS; i++) {
>  			if (eng_grp->g->grp[i].mirror.is_ena &&
>  			    eng_grp->g->grp[i].mirror.idx == eng_grp->idx)
> -				dev_err(dev, "engine_group%d", i);
> +				pr_cont(" engine_group%d", i);
>  		}
> +		pr_cont("\n");
>  		return -EINVAL;
>  	}

This one is probably reasonable, but I suggest that "engine_group%d"
is a bit redundant and this might be better as something like:

diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
index d04baa3..a6bb6c7 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
@@ -1142,13 +1143,14 @@ static int delete_engine_group(struct device *dev,
 		return -EINVAL;
 
 	if (eng_grp->mirror.ref_count) {
-		dev_err(dev, "Can't delete engine_group%d as it is used by:",
+		dev_err(dev, "Can't delete engine_group%d as it is used by engine_group(s):",
 			eng_grp->idx);
 		for (i = 0; i < OTX_CPT_MAX_ENGINE_GROUPS; i++) {
 			if (eng_grp->g->grp[i].mirror.is_ena &&
 			    eng_grp->g->grp[i].mirror.idx == eng_grp->idx)
-				dev_err(dev, "engine_group%d", i);
+				pr_cont(dev, " %d", i);
 		}
+		pr_cont("\n");
 		return -EINVAL;
 	}
 

