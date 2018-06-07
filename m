From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH] dh key: fix rounding up KDF output length
Date: Fri, 8 Jun 2018 05:28:01 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.1806080527570.7465@namei.org>
References: <0000000000009c221d056e0cf53a@google.com> <20180607191201.97080-1-ebiggers3@gmail.com> <CAGXu5jJf-cW8WkwMoPZT8zM2aUoO6P-EQs7MK6_uUTneZr0ehA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Eric Biggers <ebiggers3@gmail.com>,
        David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com, Tycho Andersen <tycho@tycho.ws>,
        Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@google.com>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJf-cW8WkwMoPZT8zM2aUoO6P-EQs7MK6_uUTneZr0ehA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 7 Jun 2018, Kees Cook wrote:

> On Thu, Jun 7, 2018 at 12:12 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Commit 383203eff718 ("dh key: get rid of stack allocated array") changed
> > kdf_ctr() to assume that the length of key material to derive is a
> > multiple of the digest size.  The length was supposed to be rounded up
> > accordingly.  However, the round_up() macro was used which only gives
> > the correct result on power-of-2 arguments, whereas not all hash
> > algorithms have power-of-2 digest sizes.  In some cases this resulted in
> > a write past the end of the 'outbuf' buffer.
> >
> > Fix it by switching to roundup(), which works for non-power-of-2 inputs.
> 
> round_up() vs roundup(). Wow, that's not confusing. :( I wonder if we
> should rename the former to roundup_pow2() or something?

Good idea, in a separate patch(set).

-- 
James Morris
<jmorris@namei.org>
