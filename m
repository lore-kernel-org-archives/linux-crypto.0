From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [PATCH RESEND] hwrng: core - don't pass stack allocated buffer to
 rng->read()
Date: Fri, 21 Oct 2016 23:34:38 +0200
Message-ID: <d2f831d5-29ee-68aa-f584-6e6e42d89508@redhat.com>
References: <20161021204809.14068-1-lersek@redhat.com>
 <CALCETrUUBJT81Yxm7f19kX+dbyqx9skYEVjYMzMx4zm-vGWWXQ@mail.gmail.com>
 <20161021211739.GR11243@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Amit Shah <amit.shah@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kees Cook <keescook@chromium.org>,
        Matt Mackall <mpm@selenic.com>
To: "Richard W.M. Jones" <rjones@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933445AbcJUVem (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Oct 2016 17:34:42 -0400
In-Reply-To: <20161021211739.GR11243@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/21/16 23:17, Richard W.M. Jones wrote:
> On Fri, Oct 21, 2016 at 02:04:27PM -0700, Andy Lutomirski wrote:
>> https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=6d4952d9d9d4dc2bb9c0255d95a09405a1e958f7
> 
> I have tested this one, and it also fixes the bug I was seeing.
> 
> Thanks Laszlo as well for his fix, and sorry for not finding the
> patch above first.

No problem, it was fun :)
