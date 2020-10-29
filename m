Return-Path: <SRS0=z7PZ=EE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E3BC2D0A3
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Oct 2020 13:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C2C720809
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Oct 2020 13:28:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="fzg7iB17"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgJ2N2I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Oct 2020 09:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbgJ2N2H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Oct 2020 09:28:07 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B709C0613D2
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2020 06:28:07 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id l24so3012928edj.8
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2020 06:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oyeiy5Q1TmGmr/PgxXO0r5cep4TDtJRBLYIRB17UjEA=;
        b=fzg7iB17YBdH0KzkgMDVvq7cF0jMFUr8q5sXJvSLpWrXm3yLyg3cMVJ9getLlTtEOb
         AOc0aAl4dnfJx9/Z62oWMFZ6+lSC02DHunAcVjsLPM3mmKjkVObD10gBjZ1c6j8p1SkS
         axfqPy+WY7Gi4IuOLi0Qrn0JuFwu3uuNJBekf/Rjyzyb23GHM9w26va8O6kT5A4x4Eec
         qe1r8Uba+HJT0CL2swpTnk3nTUJwHOw6aUBoDOw0nQ/NznCUlUhXhRzrRKRNXf5FkgM6
         hE+A1n6xzfiz0aEr0IJx7wGCceMUbG0S//6kfH//rfrkC4VH/Md1wMT2IGyNwGzQYgBB
         ADMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oyeiy5Q1TmGmr/PgxXO0r5cep4TDtJRBLYIRB17UjEA=;
        b=fPCElY7c1VDlwYSUWhzNglVX1pV8iQoJ09FjJBVElWuvBHq8vCL1hKzRL6eN3ExMX6
         2mznl+dDKEJZgha7fVEFIIyG2PMyYPg72SirIec/WlKF3hjE5Au0Bdqc+DDe0cNBmtfs
         rYTwIsCilXkuZ5QZShFQ5o3mylnCEZdMMjVdUsccDZQMosjCA8F3PuZ1GYuTUAuf2wj/
         rQuzBib3WPMjEe2keTOARlo95ePH5NdVGUCZXRvFlro0jTAyUfD09pwcpwo8P3PB0E71
         6EfhJlYMXPnatdzM9Mnn1tmRgWK1CfgaR4GSLdhH1+mFeEQPPSe4zVOaafesAkiioYHg
         U2mg==
X-Gm-Message-State: AOAM530qw6o9+S7mVY4K+AiCtr5VZVXh2ZVDCBkdQrwkB0TuLqOAiqHZ
        zhkhz4bmnvBqsAHA1aapcJrN6nk5V0LJPfxL+fG1QQzLSfsZOg==
X-Google-Smtp-Source: ABdhPJwQ5HbVCufig4+3RLBmiXBpdxafNIGuSdENMCreFHr0TSLZnK0rJgL0SzvN3vuA4v0TF4qOvJ7YFKRSncQHKsc=
X-Received: by 2002:aa7:d1cc:: with SMTP id g12mr4037019edp.195.1603978086248;
 Thu, 29 Oct 2020 06:28:06 -0700 (PDT)
MIME-Version: 1.0
References: <20201026230027.25813-1-ardb@kernel.org> <20201026230323.GA1947033@gmail.com>
 <CAMj1kXGYgxe_=1kQjKZKOxc7KkxjM4g7D5jsexBfrM++_FAiGw@mail.gmail.com> <CAMj1kXE6nxmwbyJb3kJdThmpf1wGQEe73Zh=2e7zcj=9wh3MxQ@mail.gmail.com>
In-Reply-To: <CAMj1kXE6nxmwbyJb3kJdThmpf1wGQEe73Zh=2e7zcj=9wh3MxQ@mail.gmail.com>
From:   Andy Polyakov <appro@cryptogams.org>
Date:   Thu, 29 Oct 2020 14:27:54 +0100
Message-ID: <CABb3=+ZU1Exw697+zMCZAG43mDKFf5NkjAZqE35cn7-da+aGAg@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/poly1305-neon - reorder PAC authentication
 with SP update
To:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> (+ Andy)

Thanks! Applied to cryptogams, pinged openssl. Cheers.
