Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95EB8C3A5A7
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Dec 2022 03:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbiLBDXx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Dec 2022 22:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiLBDXw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2022 22:23:52 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB53D78C7
        for <linux-crypto@vger.kernel.org>; Thu,  1 Dec 2022 19:23:51 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id w23so3479724ply.12
        for <linux-crypto@vger.kernel.org>; Thu, 01 Dec 2022 19:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yY6gYe0jMoQOUxAo/XW0gvLy18PjZJInyxKTnKGra0Y=;
        b=mWg+1k8tLdmRboO8CdEYOc/bgyxydYUdyFcVDc5S4AbOtPngnYlYkCITrTpxZfE4Dz
         XjQb9yqfGilIpKuXSJ5aSmvUvoQ5mpbhx4KbUNITsRD65szE5WKnL96uQO80aEgsClzG
         0Vw41ZQcyYCqKtNE5jslZhyGoHR0IkAzXbfMA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yY6gYe0jMoQOUxAo/XW0gvLy18PjZJInyxKTnKGra0Y=;
        b=PJvZc+TDSPWz3jQ/B26qBJ5LefBri7WxjAdGdNPui9Y5C2Dhh2hd8ayFvyOsa46lj8
         QadpDtCWK4ePe22rjsLXiHw6v1FVwS4Hr4lNDTLNIB3HtS/UGJQgx92BApVNBzJ1plio
         t4ruP4wSlGL/H/8488gtbdE07MXIICNEL0pumlkgdnCfbgTVBc495+O3A1w8s35ewLsC
         VUjgU5AQ+Z2xVx87ufpS0SyaVRnEfJl14swSv5Z/u+7Jv1X8shKBHvQDhSdKrHmzUu73
         AAtCqHI8Pj9nVK0MUNfDy4B796xDMYB3aISC1E4rxhD8btn7wLCM9/pHKr+8AAu1KsQv
         NRfQ==
X-Gm-Message-State: ANoB5pnYiqcyMNa+PN1ycV8n2UvjC+Brkuy4Po1Kl3+UVQHjdrL1CteT
        o9mccMubAHPZf/mZ7iyaclrezg==
X-Google-Smtp-Source: AA0mqf773jlXfFtvUNPzleI1zzwoMcdaJ5vS2QEyu1vN8eJZOdHbwv7AHWP1c1jEjeQ9lflAqG2XOg==
X-Received: by 2002:a17:90a:d34d:b0:218:a0ce:9d5e with SMTP id i13-20020a17090ad34d00b00218a0ce9d5emr63698522pjx.96.1669951430920;
        Thu, 01 Dec 2022 19:23:50 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l12-20020a17090a850c00b0020ae09e9724sm3697996pjn.53.2022.12.01.19.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 19:23:50 -0800 (PST)
Date:   Thu, 1 Dec 2022 19:23:49 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] crypto/caam: Avoid GCC constprop bug warning
Message-ID: <202212011920.A6648E9B@keescook>
References: <20221202010410.gonna.444-kees@kernel.org>
 <Y4ludwin631WFhcG@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4ludwin631WFhcG@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 01, 2022 at 07:18:15PM -0800, Eric Biggers wrote:
> On Thu, Dec 01, 2022 at 05:04:14PM -0800, Kees Cook wrote:
> > GCC 12 appears to perform constant propagation incompletely(?) and can
> > no longer notice that "len" is always 0 when "data" is NULL. Expand the
> > check to avoid warnings about memcpy() having a NULL argument:
> 
> Is there a gcc option to turn off the "memcpy with NULL and len=0 is undefined
> behavior" thing?  It's basically a bug in the C standard.

It's not undefined -- it's just pedantic. __builtin_memcpy is defined
internally to GCC with __attribute__((nonnull (1, 2))), and since it can
find a path from an always-NULL argument, it warns. I think it's a dumb
limitation, given that "zero size to/from NULL" is perfectly valid.

-- 
Kees Cook
