Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DF3EDE99E
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 09:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbjINJaD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 05:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236923AbjINJaC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 05:30:02 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B41CF3
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 02:29:58 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1c1e3a4a06fso5702405ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 02:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694683798; x=1695288598; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xFlzIZ6L2I8fd8nS6zzaHrZbUJ0yA9sDxrpRBVDET44=;
        b=ZAVtZ+9nEVyjXas/Pnw21moeALfoYjT9JWlTpJTkNky0yDUtaarflnxhHk8qzCzeCO
         ophGHAbZnZcJVvlAdAG56HxM2lnZ+VrfYS1eLpeY2Ib6ujyysuyYxUiUE9QJmzFW3kP+
         WkcJVrObf/O/DOogZT4azBrpZiu0Qr7amVZLDFwuiHX3sZ2d7vUZFs/dqLcgsnJnI5+V
         dfjWMG9q0c6dl5bzWcrhzdmcJzX4Hr1eZAvzlq0XBud1s9jYayqqkPGhukfON+T4wv59
         soeQgtKFMG4JqsgPQqooI/IDos4Q6PSPIRUA8EhihDMeaVhjXjYCobw555WkMhN9RHWx
         cEeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694683798; x=1695288598;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xFlzIZ6L2I8fd8nS6zzaHrZbUJ0yA9sDxrpRBVDET44=;
        b=At6KNs7RuJEtumo97HIu0E1no06IMo0ZcPZskluJcZdROgQ9WEwLYiZjxJtTAqjZpv
         faRvAJMVh2LoMte3jUVtdcjWndVThVUa7/Pl5KDQuSxlIrx7iOiadvTobqniGxd8Aobs
         Nh1fGc/LasLRwEEnVCmI7PzV+JYrGs39iGQJYhKl6bhWxm02xLw+zby5HbYCjBD8ME77
         DD3+G/FXuQV9u5qW2O5yn1yDXbI59KWzHjnGTWLRI30CGSCVkgZE1pa24E6Xq0oigT99
         uWUFpGnwVTuJnmjKVDT85tgvdCa2DunKxThEPfXrwt8jcJ4R0faFdMXrHSBSx5aYTWNQ
         9s+w==
X-Gm-Message-State: AOJu0Yz99BRgmDQN8RquDa5KAdn2xct+H6IGtgzlOtWEv2v9Bd2caDx9
        bYUNHjXrbKvTcbivzMavTuhCOj40ringKg==
X-Google-Smtp-Source: AGHT+IEHCtFzNnyPjxG+bpXFGCzcdfB2iMtHgaVuIyaNeF7bBNL2hCX1eEKn4ak2PNolYw0z+PCfaA==
X-Received: by 2002:a17:902:b7c1:b0:1bd:f69e:6630 with SMTP id v1-20020a170902b7c100b001bdf69e6630mr4286641plz.65.1694683798301;
        Thu, 14 Sep 2023 02:29:58 -0700 (PDT)
Received: from gondor.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id jo5-20020a170903054500b001b89a6164desm1110981plb.118.2023.09.14.02.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 02:29:58 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
Date:   Thu, 14 Sep 2023 17:29:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 0/8] crypto: Add lskcipher API type
Message-ID: <ZQLSlqJs///qoGCY@gondor.apana.org.au>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <CAMj1kXHLZ8kZWL3npQRavdzjRtv_uiRKmKDeXaQhhy3m4LvK+w@mail.gmail.com>
 <ZQLK0injXi7K3X1b@gondor.apana.org.au>
 <CAMj1kXHvhrUyShdSNCJeOh8WVXFqPPu+KLh16V6fJJdQKhPv1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHvhrUyShdSNCJeOh8WVXFqPPu+KLh16V6fJJdQKhPv1A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 14, 2023 at 11:18:00AM +0200, Ard Biesheuvel wrote:
>
> So this means that the base name will be aes, not ecb(aes), right?
> What about cbc and ctr? It makes sense for a single lskcipher to
> implement all three of those at least, so that algorithms like XTS and
> GCM can be implemented cheaply using generic templates, without the
> need to call into the lskcipher for each block of input.

You can certainly implement all three with arch-specific code
but I didn't think there was a need to do this for the generic
version.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
