From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 3/5] KEYS: DH: don't feed uninitialized result memory
 into KDF
Date: Thu, 27 Apr 2017 22:26:52 -0700
Message-ID: <20170428052652.GA7172@zzz>
References: <20170421034448.GA626@zzz>
 <20170420054633.14572-1-ebiggers3@gmail.com>
 <2035658.QVN4rZd2FW@positron.chronox.de>
 <20170420174602.GA103004@gmail.com>
 <2707352.sSpDZZo8GT@tauon.chronox.de>
 <28956.1493306119@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        mathew.j.martineau@linux.intel.com,
        Eric Biggers <ebiggers@google.com>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33464 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755738AbdD1F04 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Apr 2017 01:26:56 -0400
Content-Disposition: inline
In-Reply-To: <28956.1493306119@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 27, 2017 at 04:15:19PM +0100, David Howells wrote:
> Eric Biggers <ebiggers3@gmail.com> wrote:
> 
> > > > By the way: do we really need this in the kernel at all, given that it's
> > > > just doing some math on data which userspace has access to?
> > > 
> > > It is the question about how we want the keys subsystem to operate. The DH
> > > shared secret shall not be used as a key. But the DH operation is part of
> > > the key subsystem. If there is never a case where the result of the DH
> > > operation is used in the kernel, then the KDF can be removed and my
> > > patches could be reverted. However, in this case, the entire DH business
> > > could be questioned as this can easily be done in user space as well.
> > > 
> > 
> > Well, who exactly is asking for Diffie-Hellman in the kernel at all?  If it
> > can be done in userspace then it should be done there.  Having it in the
> > kernel means having yet another API that's callable by unprivileged users
> > and needs to be audited for security vulnerabilities.  Just because the
> > kernel can support doing hashes or has an arbitrary-precision arithmetic
> > library or whatever doesn't mean it's the right place to do random crypto
> > stuff.
> 
> I understood that there is the possibility of offloading this to hardware.
> 

Okay, but where is this hardware, where are drivers for it, and how do we know
this API is actually going to be compatible with it?  Will it be just for
performance, or for other reasons too?  None of this seems to have been
explained.

Eric
