Return-Path: <SRS0=di3S=XW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4500C4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 04:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B39AD207FF
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 04:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569559001;
	bh=HWXGSg8v7PMtX2AtP+Cj10Yp3jFpXmeRJ7sWexKkbRA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ZQLsPHq5sODwF0Xf6DWctvkFIQW6d0UT5Xl/BkB/q0Wh52xIwvg4ot2D9bPog93jP
	 rv9jbLaRM9/Zzec+nl1Tbu5uBRXy4S78ssitySByTm7PVcQ4TNe7MSCMKCha44nj2Q
	 7hMiTE00mY9+iFv9OaCoyOprUjcHLHa/+MHPIUYk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfI0Egk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Sep 2019 00:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbfI0Egk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Sep 2019 00:36:40 -0400
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1F6321920
        for <linux-crypto@vger.kernel.org>; Fri, 27 Sep 2019 04:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569558999;
        bh=HWXGSg8v7PMtX2AtP+Cj10Yp3jFpXmeRJ7sWexKkbRA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BgiVQRF5ok2sLpmM7sYDzoJc4cPQhJZftyNrpCPOx2Gc8HNz0u8iiBrsiuE0G1T7Z
         B61SfNfq3UnTgXqh8Jb2qLFw1j3d8yTz4nzhVUSHIXvXFc94w88V9Qq02tXLx64yFR
         IzQpj50mjsfnVgY1+wvAhT7PmFNs//sZuvqJBDXQ=
Received: by mail-wm1-f48.google.com with SMTP id 5so5005252wmg.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 21:36:38 -0700 (PDT)
X-Gm-Message-State: APjAAAVCLW9kQrOc4FFxcgS5/x4ZTMFTbq3xpdIES6lim224VGzpYFRk
        z5/8sBRd7sScfQaLVknsMv2p7cnRL+9gLJzxlITLsA==
X-Google-Smtp-Source: APXvYqzj1HLQsMd2PmSxW2B6qKm90Gu2HeZkUPjkQm7cbVdmcR6dOh2UevoBS7cKL6nqBIdpydaXzL7jhyzpQEXBD3Y=
X-Received: by 2002:a1c:608b:: with SMTP id u133mr5519478wmb.27.1569558997223;
 Thu, 26 Sep 2019 21:36:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org> <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
 <CH2PR20MB29680F87B32BBF0495720172CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAHk-=wgR_KsYw2GmZwkG3GmtX6nbyj0LEi7rSqC+uFi3ScTYcw@mail.gmail.com>
 <MN2PR20MB297317D9870A3B93B5E506C9CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAHk-=wjr1w7x9Rjre_ALnDLASYNjsEHxu6VJpk4eUwZXN0ntqw@mail.gmail.com>
In-Reply-To: <CAHk-=wjr1w7x9Rjre_ALnDLASYNjsEHxu6VJpk4eUwZXN0ntqw@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 26 Sep 2019 21:36:26 -0700
X-Gmail-Original-Message-ID: <CALCETrVPr6g=vx2Ero2VDZpYzvTTzfdTWqNjTo1JNYzQBRy37A@mail.gmail.com>
Message-ID: <CALCETrVPr6g=vx2Ero2VDZpYzvTTzfdTWqNjTo1JNYzQBRy37A@mail.gmail.com>
Subject: Re: [RFC PATCH 18/18] net: wireguard - switch to crypto API for
 packet encryption
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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

> On Sep 26, 2019, at 6:38 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> - let the caller know what the state size is and allocate the
> synchronous state in its own data structures
>
> - let the caller just call a static "decrypt_xyz()" function for xyz
> decryptrion.
>
> - if you end up doing it synchronously, that function just returns
> "done". No overhead. No extra allocations. No unnecessary stuff. Just
> do it, using the buffers provided. End of story. Efficient and simple.
>
> - BUT.
>
> - any hardware could have registered itself for "I can do xyz", and
> the decrypt_xyz() function would know about those, and *if* it has a
> list of accelerators (hopefully sorted by preference etc), it would
> try to use them. And if they take the job (they might not - maybe
> their queues are full, maybe they don't have room for new keys at the
> moment, which might be a separate setup from the queues), the
> "decrypt_xyz()" function returns a _cookie_ for that job. It's
> probably a pre-allocated one (the hw accelerator might preallocate a
> fixed number of in-progress data structures).

To really do this right, I think this doesn't go far enough.  Suppose
I'm trying to implement send() over a VPN very efficiently.  I want to
do, roughly, this:

void __user *buf, etc;

if (crypto api thinks async is good) {
  copy buf to some kernel memory;
  set up a scatterlist;
  do it async with this callback;
} else {
  do the crypto synchronously, from *user* memory, straight to kernel memory;
  (or, if that's too complicated, maybe copy in little chunks to a
little stack buffer.
   setting up a scatterlist is a waste of time.)
}

I don't know if the network code is structured in a way to make this
work easily, and the API would be more complex, but it could be nice
and fast.
