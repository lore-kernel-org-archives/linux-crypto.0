Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C09DC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 09:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245049AbiBKJS6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 04:18:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236708AbiBKJS6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 04:18:58 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540EA333
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 01:18:57 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nIS4o-0003ie-I4; Fri, 11 Feb 2022 20:18:51 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Feb 2022 20:18:50 +1100
Date:   Fri, 11 Feb 2022 20:18:50 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Harman Kalra <hkalra@marvell.com>
Cc:     Arnaud Ebalard <arno@natisbad.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Srujana Challa <schalla@marvell.com>,
        linux-crypto@vger.kernel.org, jerinj@marvell.com,
        sgoutham@marvell.com
Subject: Re: [PATCH] crypto: octeontx2 - add synchronization between mailbox
 accesses
Message-ID: <YgYp+mHwwEiLHhCk@gondor.apana.org.au>
References: <20220204124601.3617217-1-hkalra@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204124601.3617217-1-hkalra@marvell.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 04, 2022 at 06:16:01PM +0530, Harman Kalra wrote:
>
>  		offset = msg->next_msgoff;
> +		/* Write barrier required for VF responses which are handled by
> +		 * PF driver and not forwarded to AF.
> +		 */
> +		smp_wmb();

Who is the reader in this case? Is it also part of the kernel?
Because if a device is involved then smp_wmb is not appropriate.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
