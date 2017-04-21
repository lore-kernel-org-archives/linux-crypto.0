From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 3/5] KEYS: DH: don't feed uninitialized result memory
 into KDF
Date: Thu, 20 Apr 2017 20:44:48 -0700
Message-ID: <20170421034448.GA626@zzz>
References: <20170420054633.14572-1-ebiggers3@gmail.com>
 <2035658.QVN4rZd2FW@positron.chronox.de>
 <20170420174602.GA103004@gmail.com>
 <2707352.sSpDZZo8GT@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        mathew.j.martineau@linux.intel.com,
        Eric Biggers <ebiggers@google.com>
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33467 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034977AbdDUDow (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 23:44:52 -0400
Content-Disposition: inline
In-Reply-To: <2707352.sSpDZZo8GT@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

On Thu, Apr 20, 2017 at 08:38:30PM +0200, Stephan Müller wrote:
> > 
> > By the way: do we really need this in the kernel at all, given that it's
> > just doing some math on data which userspace has access to?
> 
> It is the question about how we want the keys subsystem to operate. The DH 
> shared secret shall not be used as a key. But the DH operation is part of the 
> key subsystem. If there is never a case where the result of the DH operation 
> is used in the kernel, then the KDF can be removed and my patches could be 
> reverted. However, in this case, the entire DH business could be questioned as 
> this can easily be done in user space as well.
> 

Well, who exactly is asking for Diffie-Hellman in the kernel at all?  If it can
be done in userspace then it should be done there.  Having it in the kernel
means having yet another API that's callable by unprivileged users and needs to
be audited for security vulnerabilities.  Just because the kernel can support
doing hashes or has an arbitrary-precision arithmetic library or whatever
doesn't mean it's the right place to do random crypto stuff.

- Eric
