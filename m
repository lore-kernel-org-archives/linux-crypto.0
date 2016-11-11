From: Stephan Mueller <smueller@chronox.de>
Subject: Re: algif_aead: AIO broken with more than one iocb
Date: Fri, 11 Nov 2016 14:46:00 +0100
Message-ID: <2044553.0GVHUPAKnW@positron.chronox.de>
References: <6245755.LbXSUvPjJL@positron.chronox.de> <20160913101246.GA30851@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:50874 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756297AbcKKNqJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2016 08:46:09 -0500
In-Reply-To: <20160913101246.GA30851@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 13. September 2016, 18:12:46 CET schrieb Herbert Xu:

Hi Herbert,

> On Sun, Sep 11, 2016 at 04:59:19AM +0200, Stephan Mueller wrote:
> > Hi Herbert,
> > 
> > The AIO support for algif_aead is broken when submitting more than one
> > iocb.> 
> > The break happens in aead_recvmsg_async at the following code:
> >         /* ensure output buffer is sufficiently large */
> >         if (usedpages < outlen)
> >         
> >                 goto free;
> > 
> > The reason is that when submitting, say, two iocb, ctx->used contains the
> > buffer length for two AEAD operations (as expected). However, the recvmsg
> > code
> I don't think we should allow that.  We should make it so that you
> must start a recvmsg before you can send data for a new request.
> 
> Remember that the async path should be identical to the sync path,
> except that you don't wait for completion.

Just as a followup: with the patch submitted the other day to cover the AAD 
and tag handling, the algif_aead now supports also multiple iocb.

Ciao
Stephan
