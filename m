Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270E6C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 23:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjBPX6h (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 18:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjBPX6f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 18:58:35 -0500
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DE719F02;
        Thu, 16 Feb 2023 15:58:22 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 4ADC837E;
        Thu, 16 Feb 2023 23:58:21 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 4ADC837E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1676591901; bh=OrlW+bHWaNplSx9uW+ZXBTW+rw7/dVEsIhPM+UBVxuE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ICwycA/yqOeONYKU/AWFZuh6jfd1cjQBakJiN3TNOvVgKVkT8P4LKqgEaxuo3O2hT
         PezHOZYb6nHee41L627C8ZJddiTLRyKcq0Et5pAtH/reVPyyxdEFHdEiZIdupE1rlZ
         Q+7RugLESn68zBiKNXLyj/P7PStZsuUS8iyCJFh7O6IKA7C9QXgZxv6SqmnscJt0Xe
         pmWDLfWA3M1wBWdcNzFpDsBVI9QGd0paGAO12FvCk9wti+qIhhekiAmAm8UrMpGaUc
         VRQ2P+rNfOZay6Who3iy/Pn2aPWDXBW/Yq2a+erGrqWBpEyboaonXc2GcjzSli+TbR
         CR4j1GvQ4xQAg==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Mukesh Ojha <quic_mojha@quicinc.com>
Subject: Re: [PATCH v3] Documentation: core-api: padata: correct spelling
In-Reply-To: <20230215053744.11716-1-rdunlap@infradead.org>
References: <20230215053744.11716-1-rdunlap@infradead.org>
Date:   Thu, 16 Feb 2023 16:58:20 -0700
Message-ID: <877cwhgo2r.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:

> Correct spelling problems for Documentation/core-api/padata.rst as
> reported by codespell.
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: netdev@vger.kernel.org
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org
> Cc: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
> Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> ---
> v3: split into a separate patch as requested by Jakub.
>
>  Documentation/core-api/padata.rst |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -- a/Documentation/core-api/padata.rst b/Documentation/core-api/padata.rst
> --- a/Documentation/core-api/padata.rst
> +++ b/Documentation/core-api/padata.rst
> @@ -42,7 +42,7 @@ padata_shells associated with it, each a
>  Modifying cpumasks
>  ------------------
>  
> -The CPUs used to run jobs can be changed in two ways, programatically with
> +The CPUs used to run jobs can be changed in two ways, programmatically with
>  padata_set_cpumask() or via sysfs.  The former is defined::

Applied, thanks.

jon
