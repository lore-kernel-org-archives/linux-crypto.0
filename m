From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 07/24] staging: ccree: remove unneeded cast
Date: Mon, 13 Nov 2017 07:41:54 -0800
Message-ID: <1510587714.10883.73.camel@perches.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
         <1510584358-29473-8-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0171.hostedemail.com ([216.40.44.171]:60252 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753205AbdKMPmD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Nov 2017 10:42:03 -0500
In-Reply-To: <1510584358-29473-8-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2017-11-13 at 14:45 +0000, Gilad Ben-Yossef wrote:
> Remove uneeded cast from writel_relaxed parameter.
[]
> diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
[]
> @@ -167,13 +167,13 @@ static inline void enqueue_seq(
>  	int i;
>  
>  	for (i = 0; i < seq_len; i++) {
> -		writel_relaxed(seq[i].word[0], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
> -		writel_relaxed(seq[i].word[1], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
> -		writel_relaxed(seq[i].word[2], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
> -		writel_relaxed(seq[i].word[3], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
> -		writel_relaxed(seq[i].word[4], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
> +		writel_relaxed(seq[i].word[0], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));

Maybe remove the now unnecessary parentheses around
	(cc_case + CC_REG(foo))

Maybe review the use of inline in .c files too

$ git grep -w inline drivers/staging/ccree/*.c | wc -l
41
