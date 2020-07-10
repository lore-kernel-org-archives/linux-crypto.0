Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82CB4C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 00:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62ACE2065F
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 00:16:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sAcPdBSb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgGJAQX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 20:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgGJAQX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 20:16:23 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7C3C08C5CE;
        Thu,  9 Jul 2020 17:16:23 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id dr13so4136181ejc.3;
        Thu, 09 Jul 2020 17:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SeE4mVVnUBNm2sdoUXO/sXXIz4sYexLJOEDokzvwJcE=;
        b=sAcPdBSbr/CDqjcyynsYyIGAOzfym++0lfmyCkEGJI3khVo2/JKXRYnw6yZNpOTNM8
         5JdLUvpXMP6mbi8WfFmcwvfgKEBBTh3zCvyaInq+wT+lVSlOPOfM0ujMIDoEWBe4B2LL
         4GTefctjAIXrVyPoEm16Rvfuwg62S4FYkBUaENEKo3P5cv+RrLj3q/QpIwsdFUKxsdMF
         7bd8yCprcWO9wiL0W030itN7R37XyCXUU61W/lSHQ/GQvGZ4OYPXvdD+slE5lHjyRwZk
         XXaHK1L7+LLx+0ppBsubSN5vqugQNnQ4AbEP486ilLPqDsqxMqs9ahjXvSK3ZUdj2CW8
         tsuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SeE4mVVnUBNm2sdoUXO/sXXIz4sYexLJOEDokzvwJcE=;
        b=CIPA4lBoVTl9xEFzIxqHrgJ7e13eVBuSh++8R9rz6UGpYfZ1h0U39+ORY79Qw8TssI
         uNdRtgkOR925slssWCCbpspZ8cDCylt2rXS+wT3YKoD0YahlOui9UxqHIbZ6Wgdok+XN
         nj+j3BX1XsJYauUbagBKnSjPMn94JC4idiADI7GIcDCP+87K00JO9ht+Xu1kV6nmb39V
         +Nm492G/NCYZe9qXi08iQkzck8JdQy+VUiay+EokjeqRN0F0quY42MjkXEQ8ru/qnKeb
         WhFZepk1MRCcpsAvIu4lWBdZ2QpJ9zwCiOdJADv1cICMwoSnLAz9qlWtT5Y7URwKjiNs
         OnVg==
X-Gm-Message-State: AOAM530iPXBwC7WHlikXCwAv77/9huKzmZaERUSFqForHDCyF1RK9yXX
        mYtWhGQCpjq95guOYiKG9fw=
X-Google-Smtp-Source: ABdhPJwA/umm+AiGyQJ9IjKL40K0uPDdzfujzwjzZTjsnrre5Emtb/1qye3Xl8NBBS6U6V0LBqsqMA==
X-Received: by 2002:a17:907:20ba:: with SMTP id pw26mr57395987ejb.425.1594340181902;
        Thu, 09 Jul 2020 17:16:21 -0700 (PDT)
Received: from ltop.local ([2a02:a03f:b7f9:7600:c80f:e21c:9480:e854])
        by smtp.gmail.com with ESMTPSA id o6sm3002223edr.94.2020.07.09.17.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 17:16:21 -0700 (PDT)
Date:   Fri, 10 Jul 2020 02:16:20 +0200
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-sparse@vger.kernel.org
Subject: Re: [PATCH 5/5] crypto: arm/ghash - use variably sized key struct
Message-ID: <20200710001620.he3twpsil2wnl4vj@ltop.local>
References: <20200629073925.127538-1-ardb@kernel.org>
 <20200629073925.127538-6-ardb@kernel.org>
 <20200709082200.GA1892@gondor.apana.org.au>
 <CAMj1kXE8HELm1j3jx-+mHrK3OjG6Rjp4jtP_QEYorRBnRxA+=w@mail.gmail.com>
 <20200709120937.GA13332@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709120937.GA13332@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 09, 2020 at 10:09:37PM +1000, Herbert Xu wrote:
> On Thu, Jul 09, 2020 at 11:51:10AM +0300, Ard Biesheuvel wrote:
> >
> > That looks like a sparse bug to me. Since when is it not allowed to
> > pass a non-const value as a const parameter?
> > 
> > I.e., you can pass a u64[] to a function that takes a u64 const *,
> > giving the caller the guarantee that their u64[] will not be modified
> > during the call, even if it is passed by reference.
> > 
> > Here, we are dealing with u64[][2], but the same reasoning holds. A
> > const u64[][2] formal parameter (or u64 const (*)[2] which comes down
> > to the same thing) does not require a const argument, it only tells
> > the caller that the array will be left untouched. This is why the
> > compiler is perfectly happy with this arrangement.
> 
> You're right.  Luc, here is the patch that triggers the bogus
> warning with sparse.

Thanks for the analysis and the bug report.
A fix is under way and should be upstreamed in a few days.

-- Luc 
