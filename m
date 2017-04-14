From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] padata: allow caller to control queue length
Date: Fri, 14 Apr 2017 17:44:47 +0200
Message-ID: <CAHmME9qDrq-ZvuE0weLFLKAz2qTyNtC53K4+Tc0JBCvBZ9O-5A@mail.gmail.com>
References: <20170413095213.23513-1-Jason@zx2c4.com> <20170414075711.GJ12763@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:56721 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752529AbdDNPoy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Apr 2017 11:44:54 -0400
In-Reply-To: <20170414075711.GJ12763@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 14, 2017 at 9:57 AM, Steffen Klassert
<steffen.klassert@secunet.com> wrote:
> Why do we need this? As long as we don't have a user that needs a
> different limit, this patch adds just some useless code.

My [not-yet-mainlined] code wants it.

But more compellingly, padata simply isn't a very useful interface if
it contains random limits like that. Different consumers will want
different things. Pcrypt has been the only consumer for years and
years, despite it being in kernel/; it's probably a good idea to
figure out how to make this more attractive in general, since parallel
processing is a useful thing. The 1000 job limit is particularly
annoying for systems with tons and tons of cores; here you'd want the
ability for more jobs to be allowed at a time.

I'm also open to discussing other ways to handle limiting. But a hard
coded random number of 1000 seems wrong.
