Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E9AEC4332F
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 16:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A00561058
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 16:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbhKBQi4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Nov 2021 12:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235028AbhKBQiq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Nov 2021 12:38:46 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E73C0432C5
        for <linux-crypto@vger.kernel.org>; Tue,  2 Nov 2021 09:28:36 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id k24so16453895ljg.3
        for <linux-crypto@vger.kernel.org>; Tue, 02 Nov 2021 09:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EFG0W4zbuZBKc8KwN//b04i0rLIBd1L+XKZX7MrXoOc=;
        b=hpAI9rD1GQefjY1Adn77Zrw92FmMVgTkMn30tMZmiv+NzH79bDofjvVfqKAG8t/k/X
         RX50bQ0reQiJiASa+Wi3Ks1ITAO2X1a1eJlnJACu0G3dfCj6pzLhRwt8ttFnbVlWmoih
         YPvqmqixTXafViP0iPMRbo61wTri5tdAgB7Xgql0KMeJu4DRONJOd+Fi6ZlSTyat+I+Q
         5xy0YYH3X0UkObJm99RE+K2WL4jqLBDPTTC+Tzj6E00Dm9qb+8BNDCtMvoqEYLD0zh/b
         IqW8SERdtvpoDMuR6KEkDkzZ+qx8Wj5KfkegnFR8YN9De6j7NaUULuVOt67gpk6SN3hR
         u+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EFG0W4zbuZBKc8KwN//b04i0rLIBd1L+XKZX7MrXoOc=;
        b=3csLoukBQWn9+6xE/W+DL3vwhoTBW4yIYPfMzCsTWNOqYhAkDb5t1L50Gj14RaQqZv
         p7eGb9tQ33L4c30ciVjZ3pjr7vqVUCXiM4KumqJHf2wab5fXx4/qmOvMQOFcCKY45cld
         t+Unsj6ql4nI6GGw4dslAsnPknpWGG/fqK174lHkq9L2UrzdXkPJtfUas0NAYlXmV9je
         2b9zsYEvr6Gp78EuhUL09EUITYmPH+kcEQM1pHtxwBdxousqCHGPYCwKu1dUF7YG1c+M
         f6P1rmxLXCjKDLrVcG1FHH96ushKbUKaVW51rM8HoHhPcezm5AtQy+zZzvJ+1zbwNwgc
         gq5w==
X-Gm-Message-State: AOAM530x5J3L9QImI5sn7HXBi9xpFDwHImJwxjRy+QRJq1KRJsUORxCx
        C2oKSMj0dPG4r+dMHA6p2tailmHPYXo0joJBzC1smw==
X-Google-Smtp-Source: ABdhPJyjGrPaYpq4OUOloYJA4hOuXnQyAusv+PW6kvERDc2Qqy0X3OdonYHzSsLN1pu41EWzSDjt6FFszoZuWuMvlVI=
X-Received: by 2002:a2e:9a18:: with SMTP id o24mr34636588lji.426.1635870514872;
 Tue, 02 Nov 2021 09:28:34 -0700 (PDT)
MIME-Version: 1.0
References: <20211102142331.3753798-1-pgonda@google.com> <20211102142331.3753798-5-pgonda@google.com>
 <0701eb12-a60e-381f-ddd0-9ee9a0fa3edb@amd.com>
In-Reply-To: <0701eb12-a60e-381f-ddd0-9ee9a0fa3edb@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 2 Nov 2021 10:28:23 -0600
Message-ID: <CAMkAt6psP-qK3DJiDD=54_LKQ6cA8xHndD7wLmsOkrmvA=+EVA@mail.gmail.com>
Subject: Re: [PATCH V3 4/4] crypto: ccp - Add SEV_INIT_EX support
To:     Tom Lendacky <Thomas.Lendacky@amd.com>
Cc:     David Rientjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 2, 2021 at 9:38 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 11/2/21 9:23 AM, Peter Gonda wrote:
> > From: David Rientjes <rientjes@google.com>
> >
> > +
> > +     nread = kernel_read(fp, sev_init_ex_nv_address, NV_LENGTH, NULL);
>
> Not sure if you missed the previous comment, but kernel_read can return an
> error, shouldn't it be checked and fail on error?

I did miss that comment. Updated to make sure nread == NV_LENGTH.
>
> Thanks,
> Tom
>
> > +     dev_dbg(psp_master->dev, "SEV: read %ld bytes from NV file\n", nread);
> > +     filp_close(fp, NULL);
> > +
> > +     return 0;
> > +}
> > +
