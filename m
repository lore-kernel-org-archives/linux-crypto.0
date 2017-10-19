From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH 1/2] random: always call random ready function
Date: Thu, 19 Oct 2017 22:45:58 +0200
Message-ID: <CAHmME9pfwt4OYFShzJx8+D2OQmEYJsiFFYh_7KK0oaerR91AsQ@mail.gmail.com>
References: <CAHmME9qwoSwFi7fsg1Z+gcEh1fBY+KY2rJ81UTHYn2ZMcjjwFA@mail.gmail.com>
 <20171019204506.25090-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:49051 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754189AbdJSUqB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2017 16:46:01 -0400
In-Reply-To: <20171019204506.25090-1-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These are mostly untested, but I wanted to spec it out for a taste of
what it looks like.
