Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC818C433E2
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 17:06:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95D5A6198E
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 17:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCSRFw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Mar 2021 13:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbhCSRFh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Mar 2021 13:05:37 -0400
X-Greylist: delayed 3437 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 19 Mar 2021 10:05:37 PDT
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54208C06174A;
        Fri, 19 Mar 2021 10:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
        References:Message-ID:In-Reply-To:Subject:cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uSAfUGkez8ZG0++WaHfLkBr4CBdHX0udqIExMWcpnFE=; b=mhF9wuZe936zo3byWW+7v68Ej8
        2fcqCplR1VsIiI+NQLmTgHtqjlLDKzGaoK16jjzyUiywYVmEPQnVwPM4PbkVCoZe5WZ8DEUnAJieB
        ER/+/EAFwGWL4TimMm5S1BZqclysiwgJ3Vdvd3dqBD8TduivgqqN7cmIMduJKMO5GzKWn57glRmY+
        uR7cZdkgFh+JGSZjztilYvPWSHaHSbKNnBISYcMnaLh6d4funzCpDaQG8mFTZR31MPjBQ4yyn5Jiy
        cl+/xdJHIBlCU/BkL+pCUK6RBmBMGUVErme2jCog2H9hCOWTTz7O1DTJNWxsiGr3CHVR0O2qhxJzs
        6T1z8ifg==;
Received: from rdunlap (helo=localhost)
        by bombadil.infradead.org with local-esmtp (Exim 4.94 #2 (Red Hat Linux))
        id 1lNHfH-001NV3-NO; Fri, 19 Mar 2021 16:07:56 +0000
Date:   Fri, 19 Mar 2021 09:07:55 -0700 (PDT)
From:   Randy Dunlap <rdunlap@bombadil.infradead.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
cc:     dan.j.williams@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yuyufen@huawei.com, songliubraving@fb.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md/raid6:  Couple of typo fixes
In-Reply-To: <20210319083540.31016-1-unixbhaskar@gmail.com>
Message-ID: <2b59cdc-fdb7-be14-ebdc-a49b47594b32@bombadil.infradead.org>
References: <20210319083540.31016-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: Randy Dunlap <rdunlap@infradead.org>
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-646709E3 
X-CRM114-CacheID: sfid-20210319_090755_785537_9BEE29E7 
X-CRM114-Status: GOOD (  14.39  )
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Fri, 19 Mar 2021, Bhaskar Chowdhury wrote:

>
> s/boudary/boundary/
> s/compliled/compiled/
>
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
> crypto/async_tx/raid6test.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
> index 66db82e5a3b1..c9d218e53bcb 100644
> --- a/crypto/async_tx/raid6test.c
> +++ b/crypto/async_tx/raid6test.c
> @@ -217,7 +217,7 @@ static int raid6_test(void)
> 		err += test(12, &tests);
> 	}
>
> -	/* the 24 disk case is special for ioatdma as it is the boudary point
> +	/* the 24 disk case is special for ioatdma as it is the boundary point
> 	 * at which it needs to switch from 8-source ops to 16-source
> 	 * ops for continuation (assumes DMA_HAS_PQ_CONTINUE is not set)
> 	 */
> @@ -241,7 +241,7 @@ static void raid6_test_exit(void)
> }
>
> /* when compiled-in wait for drivers to load first (assumes dma drivers
> - * are also compliled-in)
> + * are also compiled-in)
>  */
> late_initcall(raid6_test);
> module_exit(raid6_test_exit);
> --
> 2.26.2
>
>
