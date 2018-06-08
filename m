From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] dh key: fix rounding up KDF output length
Date: Fri, 08 Jun 2018 16:37:58 +0100
Message-ID: <17595.1528472278@warthog.procyon.org.uk>
References: <20180607191201.97080-1-ebiggers3@gmail.com> <0000000000009c221d056e0cf53a@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, Tycho Andersen <tycho@tycho.ws>,
        Kees Cook <keescook@chromium.org>,
        Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180607191201.97080-1-ebiggers3@gmail.com>
Content-ID: <17594.1528472278.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Eric Biggers <ebiggers3@gmail.com> wrote:

> Commit 383203eff718 ("dh key: get rid of stack allocated array") changed
> kdf_ctr() to assume that the length of key material to derive is a
> multiple of the digest size.  The length was supposed to be rounded up
> accordingly.  However, the round_up() macro was used which only gives
> the correct result on power-of-2 arguments, whereas not all hash
> algorithms have power-of-2 digest sizes.  In some cases this resulted in
> a write past the end of the 'outbuf' buffer.
> 
> Fix it by switching to roundup(), which works for non-power-of-2 inputs.

Applied.
