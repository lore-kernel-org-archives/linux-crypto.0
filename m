Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13295C31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 22:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1A1B2063F
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 22:09:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uQLU12AB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfFQWJQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 18:09:16 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:34313 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfFQWJQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 18:09:16 -0400
Received: by mail-yb1-f194.google.com with SMTP id x32so888323ybh.1
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2019 15:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VUedwG7q1HcxF8RaUiGfQxLHb9vHac7c8/AVVop+fYE=;
        b=uQLU12ABbnpYpgy9TCYXPsolDveLu2bvjkOPQXDYHYnXFT5QTU9RJbmO7SA8fMrvY4
         cbLbLNwbquAARFhXLOwbJMFWrRDPoBazAOZCr/dNUoxQbiIh73EdSpcQFQTNX5QKLBfn
         SMUonM8cCIWGbYi6HqwhPAIipIXRzYmNiwLhWrdX4xlKpMrmGtvXhvupoGZGSO0mfUtd
         i2v+Sdyzytejl0gYm+PqLK74JQfXnL8w/soK2zNkIEDjeCbnMhdYdoOuoyuaTWARe67N
         kFLpzwH9ndAilHs/esgztLn/02cECoA/Lct+X3lMVlceom1bTOT45bLiuhHj4tSFf2at
         fWNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VUedwG7q1HcxF8RaUiGfQxLHb9vHac7c8/AVVop+fYE=;
        b=K4ZdWdNbLoxjnul87yM7mhaEwjsimLdt5XJclA3fyzskhMFzrwv0woZ5U861I76BJG
         U/JKhlGZSE49DjxH/OWaBaOvDAOix3EmK5rVElYkahMWnT9Vn1JXbD8bJofNz7VSL7Jx
         K81m8VqdF25ai6kS4LNjda8JExBEdvy0htDAgrNcj6M/ppRuRSbcMAGLD8MvUuIJ/h8Z
         U8odecCLPFGMMBLPqJd3AJ7NxyCd06vbe1ofpvHUyQF88hADQoqTW7mEstddyq9VLIaI
         f1cznSMsGGbUfPRgqw/9JTDNte1RxUna+4U2pYHiv4iUpNtEjTgZq6RQUtxQJCzUuySU
         pUKA==
X-Gm-Message-State: APjAAAUEsrfk2BC/T8KbLHYSWrVY/zHs0h9pzXn72oJg181KrZXL0jmn
        s97Sc8hzBpeeLjnyORMVv1swJXLBEOmOXgKOzZZ46w==
X-Google-Smtp-Source: APXvYqwziMEAxQCXH78EJr9kr/kMAcBobQUNpI30yZoNqr0Z7+/0VaKwrz4dYQvEzjvq+w1R8vLCo9zxMRxuOgzChZU=
X-Received: by 2002:a5b:c01:: with SMTP id f1mr55916841ybq.518.1560809355108;
 Mon, 17 Jun 2019 15:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190617080933.32152-1-ard.biesheuvel@linaro.org>
 <e1c4c9b6-3668-106a-69ef-7ef6c016a5f6@gmail.com> <20190617.135712.1886619234506210997.davem@davemloft.net>
In-Reply-To: <20190617.135712.1886619234506210997.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 17 Jun 2019 15:09:03 -0700
Message-ID: <CANn89iJnJchyZr9LSjQT4+MB9nQ88-RFoAGZg8Ugg8NVX=b5Gw@mail.gmail.com>
Subject: Re: [PATCH v3] net: ipv4: move tcp_fastopen server side code to
 SipHash library
To:     David Miller <davem@davemloft.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        netdev <netdev@vger.kernel.org>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, ebiggers@kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 17, 2019 at 1:57 PM David Miller <davem@davemloft.net> wrote:
>
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Mon, 17 Jun 2019 10:00:28 -0700
>
> > All our fastopen packetdrill tests pass (after I changed all the cookie values in them)
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
> I'm going to apply this to net-next, I want it to sit there for a
> while.

Yes, the patch only applies cleanly on net-next anyway :)

Thanks.
