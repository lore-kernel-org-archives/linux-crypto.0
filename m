From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] dh key: fix rounding up KDF output length
Date: Mon, 25 Jun 2018 10:14:26 -0700
Message-ID: <20180625171426.GA180889@gmail.com>
References: <20180607191201.97080-1-ebiggers3@gmail.com>
 <0000000000009c221d056e0cf53a@google.com>
 <17595.1528472278@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Morris <jmorris@namei.org>, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, Tycho Andersen <tycho@tycho.ws>,
        Kees Cook <keescook@chromium.org>,
        Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@google.com>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17595.1528472278@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi David,

On Fri, Jun 08, 2018 at 04:37:58PM +0100, David Howells wrote:
> Eric Biggers <ebiggers3@gmail.com> wrote:
> 
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
> Applied.

Applied to where?  When are you planning to send this to Linus?  Note that this
was a regression from v4.17 to v4.18-rc1.

Thanks,

- Eric
