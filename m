Return-Path: <SRS0=juaY=D6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2030EC4363A
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 15:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A65B7221F9
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 15:39:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="quUw+PfL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750940AbgJWPjc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Oct 2020 11:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbgJWPjb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Oct 2020 11:39:31 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70120C0613CE;
        Fri, 23 Oct 2020 08:39:31 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id m65so1230177qte.11;
        Fri, 23 Oct 2020 08:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qOVd9UhLI7kiQ0IFAtx6IIBCdi5AELKItNtYBhHqjaE=;
        b=quUw+PfLbV4wPtNKWLIK18uDCTR/vnjL1PpASoBAg6skamnBWdCoxbomE2UaiFRcfH
         C/OCG1ZWJH7A3CCFyQ6noJzm9/9rDsZdOdUIoYBWuinPvI7z2qEFe5t/wa/9nMNZqhLQ
         8WP3dlER/Og+jaZFHrq3G3AGuCkY3OM+MCxR6s7pW9pGSeZQLLZBCI0Z+isdbuLypFIG
         TSVzsy7mfpYYy3FwTWRp6qzsUeauVbKowyxQs3pJ+KiZoDNJUW45Omjg1wxWzRg9Q3r4
         3b2agoNIVfAmYieQ+87HRtHQ8fQQHliJg2tgAbh54O2iB24gsa28xowP9r4Wzl7CakFx
         AbvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=qOVd9UhLI7kiQ0IFAtx6IIBCdi5AELKItNtYBhHqjaE=;
        b=Sc5QY8QHy5znqbQAprHMpQ9NC0RWUZc0/QeTlY+sFEUMP/3jQ/1K9LHVhPbZIwo0U5
         JRfU6+Wggcoxw/nXO7BZguvk+E+Q69c2jYv23xstRfoRzb3oArTZuojTadf6NSJMxzfS
         4yGxh4Xot/+R/tt5NGJUwuIlKqzN5GJFsnJKCzhlh2K0zFLwkXlWK349JSLWmypKCT6t
         EbVBYWiU7B4VKrny8z6DeRPVgYMqzVY7O8oPainae2mYgM4mvOZWre+Meh82s1qd6QYP
         ctueR3vTPe7EuhuhWixAupgF+YA8Mi7P//ICcUlEfT6BLRacpWPt7DQs0fKN47WXnwaG
         eM4Q==
X-Gm-Message-State: AOAM532rm1oosHuWzlghfc0/Zc6DBTU3G8lDd2lmSqHBTnJKjH6RyG/+
        /TLTVlTa0yHirRyXyi0AcrrFXfqF5Fe6Tg==
X-Google-Smtp-Source: ABdhPJzpUlxpPQmTafPPSGazWRhpm0nfLHeey4rvt8RMPB7oYxwRIW/EURbv3Up4on/hzT5TFGRy0w==
X-Received: by 2002:ac8:1095:: with SMTP id a21mr2690776qtj.260.1603467570567;
        Fri, 23 Oct 2020 08:39:30 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id q7sm1063618qtd.49.2020.10.23.08.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 08:39:29 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Fri, 23 Oct 2020 11:39:27 -0400
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] crypto: Use memzero_explicit() for clearing state
Message-ID: <20201023153927.GA217686@rani.riverdale.lan>
References: <20201020203957.3512851-1-nivedita@alum.mit.edu>
 <20201020203957.3512851-2-nivedita@alum.mit.edu>
 <20201022043633.GD857@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201022043633.GD857@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 21, 2020 at 09:36:33PM -0700, Eric Biggers wrote:
> On Tue, Oct 20, 2020 at 04:39:52PM -0400, Arvind Sankar wrote:
> > Without the barrier_data() inside memzero_explicit(), the compiler may
> > optimize away the state-clearing if it can tell that the state is not
> > used afterwards. At least in lib/crypto/sha256.c:__sha256_final(), the
> > function can get inlined into sha256(), in which case the memset is
> > optimized away.
> > 
> > Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> 
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> 
> Maybe get the one in arch/arm64/crypto/sha3-ce-glue.c too?
> 
> - Eric

Hm, there are a few more as well like that. But now I'm thinking it's
only the generic sha256.c that may be problematic. The rest of them are
in _final() functions which will be stored as function pointers in a
structure, so there should be no risk of them getting optimized away?
