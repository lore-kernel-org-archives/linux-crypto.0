Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2530C43217
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Dec 2022 11:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiLALxF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Dec 2022 06:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbiLALwv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2022 06:52:51 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133BB1C7
        for <linux-crypto@vger.kernel.org>; Thu,  1 Dec 2022 03:52:49 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id g7so2115478lfv.5
        for <linux-crypto@vger.kernel.org>; Thu, 01 Dec 2022 03:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hYw83hza5KUMmqWdnnIZoi5MZPfbnrDq+x3Y/unYtZg=;
        b=vD2UqwkTJAdcg3y/oUqJgFc3UVogimvWO+4kpmGX+TGc9tVoGR9rkXDLrMCtRLETgo
         bxsYGqwobSEhw9hN/Nngc+tO1s9dD5fSg14NnrSML2G+ooyUQy9y8FQj01/SK0WRDcx3
         6+LjpN3epjNRgUY5MCzuLeH/YqOyHhQdskM/nj2XSSDTiyyQDTcB4HU8TucCtY52+QgV
         ohnxhXafcU0Uonkxgr4v8p5Elsw4yytzcRbcnj2+fVMaqftRBHJngBdkvbpVpSY2Dw6s
         qsovl9p4Ur+0g9xU35hUEDQ+A3bQ4jlr+7zu2ATmM5lP7OEi7sRCqqgbWLg5Oy8l72QO
         1uiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hYw83hza5KUMmqWdnnIZoi5MZPfbnrDq+x3Y/unYtZg=;
        b=RmahM7Cknt4mDMTzC6wWf1OqnTzHzecfo+rp2rRpSXVWNeAbGMgG96cdjf3UTc9LmO
         Pm951c0u1veOz1WJdR86NoEd/Z4lAqgIAtdxgmdw1BEDNVoBxPs/u+scc2v/i4N0C8fG
         CQq3pTCVaeNqHXQIp5bgwwdr/Y2ddfuumd9qG1Ntkuo9M4XIixmQw77WDHrOWAxLW12M
         qKfehuXXoAtIxPxuZbHWYQafOjgeu9jdlqx6MwZTG8N7Ex2CrCpRB9Zzal9xhxe3ZqZL
         No27Npp0OfmsyYVu3Djlov7UUJhY4oSWMuZ0ih/bb1vd00lhDjzKO7+jkJ4qU4nIw3QU
         FKYQ==
X-Gm-Message-State: ANoB5pkYJGuYI6Wdrp2wdwAnTzJL+x7LxlGNk31gFpF5rVUZDKj7g0SV
        x+LD7LG2O9h9aqUcLxXMIwpSEw==
X-Google-Smtp-Source: AA0mqf4NukWnTlL5ndtanUTMfybizS9IPfBYR879OXY1cGNyCpRyVLgsx9HeT/wlsRdkZTnNG/rd8Q==
X-Received: by 2002:a05:6512:3153:b0:4a2:da6:d969 with SMTP id s19-20020a056512315300b004a20da6d969mr19251541lfi.671.1669895567330;
        Thu, 01 Dec 2022 03:52:47 -0800 (PST)
Received: from mutt (c-e429e555.07-21-73746f28.bbcust.telenor.se. [85.229.41.228])
        by smtp.gmail.com with ESMTPSA id bi41-20020a0565120ea900b00492ce573726sm625609lfb.47.2022.12.01.03.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 03:52:46 -0800 (PST)
Date:   Thu, 1 Dec 2022 12:52:44 +0100
From:   Anders Roxell <anders.roxell@linaro.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel test robot <lkp@intel.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto/caam: Avoid GCC constprop bug warning
Message-ID: <20221201115244.GC69385@mutt>
References: <20221028210527.never.934-kees@kernel.org>
 <Y2TVXDfQUwlYFv9S@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2TVXDfQUwlYFv9S@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022-11-04 17:03, Herbert Xu wrote:
> On Fri, Oct 28, 2022 at 02:05:31PM -0700, Kees Cook wrote:
> >
> > @@ -163,7 +163,7 @@ static inline void append_data(u32 * const desc, const void *data, int len)
> >  {
> >  	u32 *offset = desc_end(desc);
> >  
> > -	if (len) /* avoid sparse warning: memcpy with byte count of 0 */
> > +	if (data && len) /* avoid sparse warning: memcpy with byte count of 0 */
> >  		memcpy(offset, data, len);
> 
> How about just killing the if clause altogether? I don't see
> any sparse warnings without it.  What am I missing?

I think that was fixed in sparse release v0.5.1 [1]. The workaround 'if
(len)' was introduced back in 2011, and the sparse release v0.5.1 was
done in 2017. So it should probably be safe to remove the 'if (len)'  or
what do you think?


Cheers,
Anders
[1] https://sparse.docs.kernel.org/en/latest/release-notes/v0.5.1.html
