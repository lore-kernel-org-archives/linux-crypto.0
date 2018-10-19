Return-Path: <SRS0=GKHD=M7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:55531 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbeJTC0s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Oct 2018 22:26:48 -0400
Received: by mail-it1-f194.google.com with SMTP id c23-v6so5329904itd.5
        for <linux-crypto@vger.kernel.org>; Fri, 19 Oct 2018 11:19:36 -0700 (PDT)
MIME-Version: 1.0
References: <20181015175424.97147-1-ebiggers@kernel.org> <CAHmME9p1aiqWZ4+viaLscO8+qmixdVhMA1MAtMAFEHPG36DcPg@mail.gmail.com>
In-Reply-To: <CAHmME9p1aiqWZ4+viaLscO8+qmixdVhMA1MAtMAFEHPG36DcPg@mail.gmail.com>
From: Paul Crowley <paulcrowley@google.com>
Date: Fri, 19 Oct 2018 11:19:24 -0700
Message-ID: <CA+_SqcDszvqfH7qvEyi8QW2RqkA1kpV6L7VWxhtw5Ogzeovhbg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/12] crypto: Adiantum support
To: Jason@zx2c4.com
Cc: ebiggers@kernel.org, linux-crypto@vger.kernel.org,
        linux-fscrypt@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kaiser <gkaiser@google.com>,
        Michael Halcrow <mhalcrow@google.com>,
        samuel.c.p.neves@gmail.com, tomer.ashur@esat.kuleuven.be
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 19 Oct 2018 at 08:58, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Before merging this into the kernel, do you want to wait until you've
> received some public review from academia?

I would prefer not to wait. Unlike a new primitive whose strength can
only be known through attempts at cryptanalysis, Adiantum is a
construction based on
well-understood and trusted primitives; it is secure if the proof
accompanying it is correct. Given that (outside competitions or
standardization efforts) no-one ever issues public statements that
they think algorithms or proofs are good, what I'm expecting from
academia is silence :) The most we could hope for would be getting the
paper accepted at a conference, and we're pursuing that but there's a
good chance that won't happen simply because it's not very novel. It
basically takes existing ideas and applies them using a stream cipher
instead of a block cipher, and a faster hashing mode; it's also a
small update from HPolyC. I've had some private feedback that the
proof seems correct, and that's all I'm expecting to get.
