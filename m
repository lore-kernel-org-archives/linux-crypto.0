From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH 1/2] random: always call random ready function
Date: Thu, 19 Oct 2017 23:12:12 +0200
Message-ID: <CAHmME9oQRTo9b8g+mXuRjjTNMwzfW=u-C-yVDbSo=LERrd7omg@mail.gmail.com>
References: <CAHmME9qwoSwFi7fsg1Z+gcEh1fBY+KY2rJ81UTHYn2ZMcjjwFA@mail.gmail.com>
 <20171019204506.25090-1-Jason@zx2c4.com> <CAGXu5jJ_A11aCw04rJ2ktAG+OCL0RiXXGx387mgdHwhUe4P-=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Ted Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:33039 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751928AbdJSVMP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2017 17:12:15 -0400
In-Reply-To: <CAGXu5jJ_A11aCw04rJ2ktAG+OCL0RiXXGx387mgdHwhUe4P-=A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Good tips, thanks. I'll wait for more comments before resubmitting v2,
but in-progress changes live here:
https://git.zx2c4.com/linux-dev/log/?h=jd/cleaner-add-random-ready
