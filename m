From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [PATCH RESEND] hwrng: core - don't pass stack allocated buffer
 to rng->read()
Date: Fri, 21 Oct 2016 22:17:39 +0100
Message-ID: <20161021211739.GR11243@redhat.com>
References: <20161021204809.14068-1-lersek@redhat.com>
 <CALCETrUUBJT81Yxm7f19kX+dbyqx9skYEVjYMzMx4zm-vGWWXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laszlo Ersek <lersek@redhat.com>, linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Amit Shah <amit.shah@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kees Cook <keescook@chromium.org>,
        Matt Mackall <mpm@selenic.com>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52166 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933575AbcJUVRo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Oct 2016 17:17:44 -0400
Content-Disposition: inline
In-Reply-To: <CALCETrUUBJT81Yxm7f19kX+dbyqx9skYEVjYMzMx4zm-vGWWXQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 21, 2016 at 02:04:27PM -0700, Andy Lutomirski wrote:
> https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=6d4952d9d9d4dc2bb9c0255d95a09405a1e958f7

I have tested this one, and it also fixes the bug I was seeing.

Thanks Laszlo as well for his fix, and sorry for not finding the
patch above first.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
Fedora Windows cross-compiler. Compile Windows programs, test, and
build Windows installers. Over 100 libraries supported.
http://fedoraproject.org/wiki/MinGW
