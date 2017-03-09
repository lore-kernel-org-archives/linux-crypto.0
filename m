From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC] how to handle AAD copy operation for algif_aead
Date: Thu, 09 Mar 2017 11:02:41 +0100
Message-ID: <78373946.kaJU5cUr5f@tauon.atsec.com>
References: <13406914.zeok8basum@positron.chronox.de> <20170309100011.GA6844@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:57942 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753847AbdCIKD2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2017 05:03:28 -0500
In-Reply-To: <20170309100011.GA6844@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 9. März 2017, 11:00:11 CET schrieb Herbert Xu:

Hi Herbert,

> On Fri, Feb 24, 2017 at 02:24:47PM +0100, Stephan Müller wrote:
> > Hi Herbert et al,
> > 
> > attached are two patches where each patch has a different approach to copy
> > the AAD in the algif_aead operation. I would like to hear your opinion
> > which approach should be taken.
> > 
> > The patch 0001-crypto-algif_aead-copy-AAD-from-src-to-dst_separate.patch
> > simply copies the AAD over from TX SGL to RX SGL. The pro is that the
> > patch is small. The con is that this approach does *not* provide an
> > in-place crypto operation.
> 
> I prefer this patch with the proviso that it copy the whole thing
> instead of just the AD.  That way you can just feed the dst memory
> to crypto_aead for in-place operation.  Of course you have to mangle
> the tag data onto the dst SG list for decryption but it shouldn't
> be too hard.

I thought that is exactly the second patch. It copies the entire data to the 
dst SGL and extends the SGL with the tag in case of decryption.

Ciao
Stephan
