Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63A4C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 11:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E5B664F10
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 11:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhBYLQg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Feb 2021 06:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbhBYLQf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Feb 2021 06:16:35 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96ADC061574;
        Thu, 25 Feb 2021 03:15:54 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DmVZr71ldz9sBy;
        Thu, 25 Feb 2021 22:15:48 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1614251751;
        bh=Vca/imfcO2yn/YdTghwR8DqtTxd3FAFwqDWZTbVefq4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=l8g3SqNmOf5alYyLAsWGsuOdqzrJtVJj4EJ6aKNBYE4wELIlH1+ejvW9kSQyaxuqX
         /JME0W7NjR4gvc5TZ8X+Pmu0aJ3RI+WvleS4b40NwCo+3OBwh5EpP+pJ8q2+LggIjZ
         V8ycZ2v23ZkcE6LEQpJT0knqp9OG2YMPwaSlBmpvzYPx1bo8OEOg8b1YlzvDkfQC8q
         PdeABa2WJRDW12/Mq3gQmB1vjzY6/bkq1y20EOd/X+Kl45PjgOIu+rmLa16Lxqcwnz
         Si9rFvNiSTJgGxcYsbALHAvSuneDoY2ed/VXVLP2kx0c/+cUvN1uhLfYD4+JrHdumW
         QZgzAwZOuMSGw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Yang Li <yang.lee@linux.alibaba.com>, herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, benh@kernel.crashing.org, paulus@samba.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: Re: [PATCH] crypto/nx: add missing call to of_node_put()
In-Reply-To: <1614243417-48556-1-git-send-email-yang.lee@linux.alibaba.com>
References: <1614243417-48556-1-git-send-email-yang.lee@linux.alibaba.com>
Date:   Thu, 25 Feb 2021 22:15:45 +1100
Message-ID: <87v9ags8im.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> writes:
> In one of the error paths of the for_each_child_of_node() loop,
> add missing call to of_node_put().
>
> Fix the following coccicheck warning:
> ./drivers/crypto/nx/nx-common-powernv.c:927:1-23: WARNING: Function
> "for_each_child_of_node" should have of_node_put() before return around
> line 936.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/crypto/nx/nx-common-powernv.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx-common-powernv.c
> index 13c65de..b43c457 100644
> --- a/drivers/crypto/nx/nx-common-powernv.c
> +++ b/drivers/crypto/nx/nx-common-powernv.c
> @@ -933,6 +933,7 @@ static int __init nx_powernv_probe_vas(struct device_node *pn)
>  				NX_CT_GZIP, "ibm,p9-nx-gzip", &ct_gzip);
>  
>  		if (ret)
> +			of_node_put(dn);
>  			return ret;

Sorry this is wrong, the if needs braces.

cheers
