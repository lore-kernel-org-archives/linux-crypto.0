Return-Path: <SRS0=MfKA=CE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB12BC433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 05:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A02BA2071E
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 05:23:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hqt2kgu+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbgHZFX1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Aug 2020 01:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgHZFX0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Aug 2020 01:23:26 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B788C061574
        for <linux-crypto@vger.kernel.org>; Tue, 25 Aug 2020 22:23:26 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id v1so247403qvn.3
        for <linux-crypto@vger.kernel.org>; Tue, 25 Aug 2020 22:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dTsMwQU3eVZt3RKaNpwezO3ue3PVVm4YHGjPcdSi/eg=;
        b=hqt2kgu+BldltBIEBE4hpQRWSvPlopG8LTpD3ZYJBcNNXhxI54bV9ULHRtRXP6578y
         vetEfAEBBjHAJPAF3GW0wRBsy2/ftPLijxtIqUPSurPjFVz1f+mK7Ey9lTSBN05ixuXN
         SI2Hr6k/podDwvV/+tO47+zktUfgVcvkv0j83iFF/WXba/C6o4pyJNgXI8H2urUfYByi
         KsJA5cMi9jbWmVI0G0S6XEzfB9dRkWq1KQaHNnPoHY5MUnK+N9WguC1CQd/nZestkJiD
         OflBXvdwSH47GDQ03Bk2PdfQL3EQRUEoeTk5tFqkZrh5vyH14IT7bveof6vxkZldtE3/
         zesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dTsMwQU3eVZt3RKaNpwezO3ue3PVVm4YHGjPcdSi/eg=;
        b=Nc1PYlYdj1QA40CHDLtlkknF1peflQajAFWfWdOL2iyn1MzmFnyl2RhzEiRfPsN0c7
         nia7ElPvHFaJ7VMT6mm2tqLbkjxkCXZRrjaZYlPpsgRI+J08p8fhJmq5jZBZiEyV/TuK
         qMSl3dytXOmN0yj5bt+1rvaMCCnppOwMTVnVscRhYjczJgaVKJOVS9/Qw+qp4t3U2uL/
         qDzZq66oefXSfp03hO4iuUbZP1l/gZrOiC2hehnmObGdhwBOdpLMrqhQRoE6yU0Fi8qB
         wpUw4lS01TI4/BCmZY5Vy117BahGUQl3kyS6x3LAMCLS9AO/eHKNvfBo2woVNKUy8t8j
         vKVg==
X-Gm-Message-State: AOAM530ZPpGJIbLm44PHKaUWKBC04panWjt7VXjoJ49el2q6LYrr7Ykd
        iBVCPuka1U02SIDcmfwviaI=
X-Google-Smtp-Source: ABdhPJxRVvW8aj/Uw4gZ7dJxdh970m+m+78+ZD6X47uLY18sO+N/ExqvO8hUzWenyt5kRfovC7t28A==
X-Received: by 2002:a0c:f1c9:: with SMTP id u9mr12603983qvl.76.1598419405752;
        Tue, 25 Aug 2020 22:23:25 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id d20sm876200qkk.84.2020.08.25.22.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 22:23:25 -0700 (PDT)
Date:   Tue, 25 Aug 2020 22:23:23 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Tero Kristo <t-kristo@ti.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: sa2ul: fix compiler warning produced by clang
Message-ID: <20200826052323.GA1906591@ubuntu-n2-xlarge-x86>
References: <20200825133106.21542-1-t-kristo@ti.com>
 <20200825133106.21542-3-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825133106.21542-3-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 25, 2020 at 04:31:06PM +0300, Tero Kristo wrote:
> Clang detects a warning for an assignment that doesn't really do
> anything. Fix this by removing the offending piece of code.
> 
> Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Tero Kristo <t-kristo@ti.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com> # build

> ---
>  drivers/crypto/sa2ul.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
> index 5bc099052bd2..ff8bbdb4d235 100644
> --- a/drivers/crypto/sa2ul.c
> +++ b/drivers/crypto/sa2ul.c
> @@ -1148,12 +1148,10 @@ static int sa_run(struct sa_req *req)
>  			ret = sg_split(req->dst, mapped_dst_nents, 0, 1,
>  				       &split_size, &dst, &dst_nents,
>  				       gfp_flags);
> -			if (ret) {
> -				dst_nents = dst_nents;
> +			if (ret)
>  				dst = req->dst;
> -			} else {
> +			else
>  				rxd->split_dst_sg = dst;
> -			}
>  		}
>  	}
>  
> -- 
> 2.17.1
> 
> --
> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
