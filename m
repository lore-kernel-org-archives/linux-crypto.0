Return-Path: <SRS0=di3S=XW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E70CC4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 04:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71FA0217F4
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 04:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569559051;
	bh=eokZR0QU/MEdg5xNwIt/H+MlFZDTmtpGw9NN9iq+r7Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ELueZxxQtgUPcTxqdE4IxGaes8Sy1n4Sn32EMTBCQg/ylvT4BJ7u99Mr9sdRNDARg
	 yLSZsuzSiRaTTbcMrdO6SR8obbbwRmbbfraMT2T/WXnphlDA9x/2vtiYzokyqLXdOV
	 p56WDe5/0DCAMAbHl+oUx8+UNdsUz20mRURd3SO8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbfI0Eha (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Sep 2019 00:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbfI0Eha (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Sep 2019 00:37:30 -0400
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8693D21906
        for <linux-crypto@vger.kernel.org>; Fri, 27 Sep 2019 04:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569559049;
        bh=eokZR0QU/MEdg5xNwIt/H+MlFZDTmtpGw9NN9iq+r7Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=a2/hT5LZEzF1NtCWpl4GeZNpM9S/9uQQq2vNlZvQHkKujHjSfIZqzcJIfO45PWYAe
         PVTG1p8QdY0zW6dry/lwz7g/WE+Y75xGrKgNiZMbA6f7SloblPvryF1G8ntr2pJvHw
         +M43KpM6meyxkcmaZn7DygcEKB8RN/sjqd/GdvuU=
Received: by mail-wr1-f43.google.com with SMTP id i1so1092486wro.4
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 21:37:29 -0700 (PDT)
X-Gm-Message-State: APjAAAVW1osd9dTtUFw71LQ1wc1VHAjO0fd+yuCXoTKLn/e6hU11Z9H+
        PVcJH6d31yq2pEHDgzHpL+KtV9Rz8EiOaJbjfxNKhQ==
X-Google-Smtp-Source: APXvYqwrftlm7qI7fsd0ba+Wsits6X8BpdrHVxzp1NpMrMUyP6+l8wrnnBSOLZK2x/KKKP1mETeG4SdEZLQw91H7YwM=
X-Received: by 2002:adf:e908:: with SMTP id f8mr1212909wrm.210.1569559048029;
 Thu, 26 Sep 2019 21:37:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org> <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
 <CH2PR20MB29680F87B32BBF0495720172CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAHk-=wgR_KsYw2GmZwkG3GmtX6nbyj0LEi7rSqC+uFi3ScTYcw@mail.gmail.com>
 <MN2PR20MB297317D9870A3B93B5E506C9CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAHk-=wjr1w7x9Rjre_ALnDLASYNjsEHxu6VJpk4eUwZXN0ntqw@mail.gmail.com>
 <CAHk-=whqWh8ebZ7ryEv5tKKtO5VpOj2rWVy7wV+aHWGO7m9gAw@mail.gmail.com> <20190927035319.GA23566@gondor.apana.org.au>
In-Reply-To: <20190927035319.GA23566@gondor.apana.org.au>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 26 Sep 2019 21:37:16 -0700
X-Gmail-Original-Message-ID: <CALCETrW28rDxLs+UOO+k5gfHJZHzy_xra-e0f6kBp6YdeWA36A@mail.gmail.com>
Message-ID: <CALCETrW28rDxLs+UOO+k5gfHJZHzy_xra-e0f6kBp6YdeWA36A@mail.gmail.com>
Subject: Re: [RFC PATCH 18/18] net: wireguard - switch to crypto API for
 packet encryption
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 26, 2019 at 8:54 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Sep 26, 2019 at 07:54:03PM -0700, Linus Torvalds wrote:
> >
> > Side note: almost nobody does this.
> >
> > Almost every single async interface I've ever seen ends up being "only
> > designed for async".
> >
> > And I think the reason is that everybody first does the simply
> > synchronous interfaces, and people start using those, and a lot of
> > people are perfectly happy with them. They are simple, and they work
> > fine for the huge majority of users.
>
> The crypto API is not the way it is because of async.  In fact, the
> crypto API started out as sync only and async was essentially
> bolted on top with minimial changes.

Then what's up with the insistence on using physical addresses for so
many of the buffers?

--Andy
