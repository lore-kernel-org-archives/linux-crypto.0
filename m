From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [PATCH 0/2] crypto: arm64/ARM: NEON accelerated ChaCha20
Date: Tue, 27 Dec 2016 10:36:27 -0500
Message-ID: <CAH8yC8kJiKc4Oz8RAob_5oRoQeACqvqXyj2UAsfv4bQ_TmKG-w@mail.gmail.com>
References: <1481207339-17332-1-git-send-email-ard.biesheuvel@linaro.org>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:32926 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750804AbcL0Pg2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 10:36:28 -0500
Received: by mail-it0-f68.google.com with SMTP id c20so33617815itb.0
        for <linux-crypto@vger.kernel.org>; Tue, 27 Dec 2016 07:36:28 -0800 (PST)
In-Reply-To: <1481207339-17332-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> ChaCha20 is a stream cipher described in RFC 7539, and is intended to be
> an efficient software implementable 'standby cipher', in case AES cannot
> be used.

That's not quite correct.

The IETF changed the algorithm a bit, and its not compatible with
Bernstein's ChaCha. They probably should have differentiated the name
to avoid this sort of confusion.

You can find Bernstein's specification for ChaCha at
https://cr.yp.to/chacha.html, and the test vectors for Bernstein's
specification at
http://tools.ietf.org/html/draft-strombergson-chacha-test-vectors.

Jeff
