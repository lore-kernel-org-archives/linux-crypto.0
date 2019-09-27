Return-Path: <SRS0=di3S=XW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B85C4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 04:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D65C420835
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 04:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569557607;
	bh=avN3QEOC6m+85kRcyxawyudBF3pcKtGNoz8mkT6x3KI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=f26+QFTxfxs9dTeCuSH/0JGfg8wjwZ6gFltlCaRKQbRmpcOas6He4t8I2VYuv9cQs
	 5LQ5YedgUGCmE1SMqqh++a0pGpIzcBqeaOHP+GqNKHgrLJhvShd8DS3OHxgGoB8yOY
	 VSLPE1GuOa19k7vPmec5oaGjhT6SRQ5tdKySn9D4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfI0EN1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Sep 2019 00:13:27 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39820 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfI0EN0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Sep 2019 00:13:26 -0400
Received: by mail-lj1-f193.google.com with SMTP id y3so1081204ljj.6
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 21:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5UH138tG9PRYMsFiBULF307JYuT/lrT57+qHytLZwTU=;
        b=bBr8IhrV4sosw8kqW0dHsTq9GgR0+dGbb+WZnt90hJKIYvZIVl9uJsc+OuNBXNvjes
         O6N01AGJP1KsO+TyFpDEMT2T7EIMNKn4xgTgO+MVoe6U95I8Y9c+kh8bIUmhNNK5h9JR
         exqx/qee3opyNYZGxe07JPuXx9b8lC0gZSeiM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5UH138tG9PRYMsFiBULF307JYuT/lrT57+qHytLZwTU=;
        b=c0cQ4Yf7LrN3x/w8EApnJNR2VNk78hjacQkdJAksq/kp5sJUPD+S6NykLKVZ827Yvl
         +XqieKHpj6XtOCQ77nmAvAQVWzOsVlCvXC+yisgYSMTyfCDFB5RbiMX3iDKoHnRxvNa2
         L+rzwlRLVaj8Cxd0S/ohhg7XZSym9o+6DU+nuWeewOn6V1ZLnd3X7+RhaG34b6/jTJAQ
         ZwY0eCg9L4RkLZC6jdOiwNu/mkppp9jxoAlNNlQbjz0ea1Dr63lLU1aFHBX4Ol4CAHF9
         KHn1cFmR3sU0qm3i94Od/v82Fcw6mpRKlSMZjYpf+F4CI6lI/XMQBAIRJrLiRyaXBRVD
         yt4w==
X-Gm-Message-State: APjAAAXyXpI88jWy1rkskrdqTbrvrLnAa/VJahGWa00sos6NXAhIp2+X
        3RoX4WODq1J/ULdo/nh3oAHr1kH/aBE=
X-Google-Smtp-Source: APXvYqzZy9KTlRRcKB5BY6LEBilXb2A40Sb86zZo3vx+WZC8cBI6McQr8aXT5H2sijeqgZDddMoaXA==
X-Received: by 2002:a2e:9d4a:: with SMTP id y10mr1218665ljj.181.1569557604801;
        Thu, 26 Sep 2019 21:13:24 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id i128sm219371lji.49.2019.09.26.21.13.23
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 21:13:24 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id q11so808262lfc.11
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 21:13:23 -0700 (PDT)
X-Received: by 2002:ac2:5c11:: with SMTP id r17mr1187992lfp.61.1569557603654;
 Thu, 26 Sep 2019 21:13:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org> <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
 <CH2PR20MB29680F87B32BBF0495720172CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAHk-=wgR_KsYw2GmZwkG3GmtX6nbyj0LEi7rSqC+uFi3ScTYcw@mail.gmail.com>
 <MN2PR20MB297317D9870A3B93B5E506C9CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAHk-=wjr1w7x9Rjre_ALnDLASYNjsEHxu6VJpk4eUwZXN0ntqw@mail.gmail.com>
 <CAHk-=whqWh8ebZ7ryEv5tKKtO5VpOj2rWVy7wV+aHWGO7m9gAw@mail.gmail.com> <20190927040140.GA24370@gondor.apana.org.au>
In-Reply-To: <20190927040140.GA24370@gondor.apana.org.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 26 Sep 2019 21:13:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgJ0ZSsrCoPRKGx5a46cSWGB-Prb4wDRLR2oCeyaXyYyg@mail.gmail.com>
Message-ID: <CAHk-=wgJ0ZSsrCoPRKGx5a46cSWGB-Prb4wDRLR2oCeyaXyYyg@mail.gmail.com>
Subject: Re: [RFC PATCH 18/18] net: wireguard - switch to crypto API for
 packet encryption
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
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

On Thu, Sep 26, 2019 at 9:01 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> So there is really no async overhead in the crypto API AFAICS if
> you're always doing sync.  What you see as overheads are probably
> the result of having to support multiple underlying algorithms
> (not just accelerations which can indeed be handled without
> indirection at least for CPU-based ones).

Fair enough, and sounds good. The biggest overhead is that indirection
for the state data, and the fact that the code indirect calls the
actual function.

If that could be avoided by just statically saying

     crypto_xyz_encrypt()

(with the xyz being the crypto algorithm you want) and having the
state be explicit, then yes, that would remove most of the overhead.

It would still leave setting the callback fields etc that are
unnecessary for the synchronous case and that I think could be done
differently, but that's probably just a couple of stores, so not
particularly noticeable.

              Linus
