Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B1BC6FA99
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Mar 2023 08:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjCLIHD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Mar 2023 04:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCLIHC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Mar 2023 04:07:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9924B5552A
        for <linux-crypto@vger.kernel.org>; Sun, 12 Mar 2023 00:07:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3507B60EC9
        for <linux-crypto@vger.kernel.org>; Sun, 12 Mar 2023 08:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CD1C433EF
        for <linux-crypto@vger.kernel.org>; Sun, 12 Mar 2023 08:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678608419;
        bh=f5U4nJSUYwCPc+uRYFxz6jID6orP9Is85SV55yUOm7w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LzunT/LczNCIo+svAsrZvZzhdp/NXcpBqR1NXlrWqhVyOtPZInUYnYixw7EZVXjE1
         H/yIr5cigGX7AsO718dyeAxccDNhcgnpBtAmdweJqXZAHRK5gzDdtTfo/UDmvLoEuD
         oWXjMV/meRkDSIR2/db02sfGYqiQp/otxCMQVGIpODP3FqaoZHr7shLIqsi70cCLCC
         zGISWeg8BqTzpWWtVGKx83h4esHdqJ3vGkG7Az2+auJPy1W7f0Pzh47saE8Sxhtccp
         aBk1bGlSDRO1kx99we85SMSS0ar3oHdb+klLqrj58HJUzvBHek0qf3fZrYlDdFAK8N
         lMjDB0W4o0cIA==
Received: by mail-lj1-f170.google.com with SMTP id y14so9625994ljq.4
        for <linux-crypto@vger.kernel.org>; Sun, 12 Mar 2023 00:06:59 -0800 (PST)
X-Gm-Message-State: AO0yUKWaf4sLjJQvFJZurfB8+xxO/wkY51IXjNYm/A67FpRf/5mjUOYZ
        U5IpRLf4w24rezjA5MWbJ9GMc4vj3t52GdLuuLA=
X-Google-Smtp-Source: AK7set+THq0qlKmYPnVU5LOR/dzTnmVtCTgflwu3yhOP8Ek06Fqz170fOVGsuskvHlMErfIgkeNTlpUhzTZY+Gkh70I=
X-Received: by 2002:a2e:595:0:b0:298:6d17:eaa7 with SMTP id
 143-20020a2e0595000000b002986d17eaa7mr4804247ljf.2.1678608417554; Sun, 12 Mar
 2023 00:06:57 -0800 (PST)
MIME-Version: 1.0
References: <ZAw2eHDQELdiVXcZ@gondor.apana.org.au> <CAMj1kXGC81=z_h-gcdQ0OoNA01kSAJz58QNiB1ixCPFA0_YnUw@mail.gmail.com>
 <ZAw5Ffv7X2mNmbG8@gondor.apana.org.au> <CAMj1kXEr8W1NP0Xcny7ed1xb7ofb7Y6R57TPNe6=jAASDzHzKw@mail.gmail.com>
 <ZAxAK2rlOsQjlgB9@gondor.apana.org.au> <CAMj1kXG_27v0YXoO_8Avjcz=YtYhCfX_6pcXowk0fy5cYR6gVw@mail.gmail.com>
 <ZAxDOhfuSTsgncMU@gondor.apana.org.au> <CAMj1kXHdNZ-=3-VuerRVWiRYixFf8KoeFk54Gz=09aV9Wwtdsg@mail.gmail.com>
 <ZAxIKu3t4NJEGz6I@gondor.apana.org.au> <CAMj1kXF6_JFMFTqzmXWxM=zJ7HmDqnivAKjUT=pN-34werkd5g@mail.gmail.com>
 <ZAxM5NLU6a2SUDuh@gondor.apana.org.au>
In-Reply-To: <ZAxM5NLU6a2SUDuh@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 12 Mar 2023 09:06:45 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG0eQ4fTxwadg5tqsm_Jw-cM4GL6CBpWc=N7hhj-deK1g@mail.gmail.com>
Message-ID: <CAMj1kXG0eQ4fTxwadg5tqsm_Jw-cM4GL6CBpWc=N7hhj-deK1g@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: lib - implement library version of AES in CFB mode
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 11 Mar 2023 at 10:42, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sat, Mar 11, 2023 at 10:25:48AM +0100, Ard Biesheuvel wrote:
> >
> > So what use case is the driver for this sync skcipher change? And how
>
> The main reason I wanted to do this is because I'd like to get
> rid of crypto_cipher.  I'm planning on replacing the underlying
> simple ciphers with their ECB equivalent.
>
> > will this work with existing templates? Do they all have to implement
> > two flavors now?
>
> Let's say we're calling this vkcipher.  Because the existing
> skcipher templates should continue to work with an underlying
> vkcipher algorithm, I won't be adding any vkcipher template
> unless there is a specific use-case, such as CFB here.
>
> But I will do the common ones like CBC/CTR.
>

Interesting. So I think having an interface like this would be useful.

However, to answer your original question, I don't think it makes
sense for James's stuff to be gated on this. In fact, I think
communication with the TPM should have as few moving parts as
possible, given how disruptive it might be if it fails, so I'd suggest
we merge this code in any case, and stick to simple library interfaces
where we can.
