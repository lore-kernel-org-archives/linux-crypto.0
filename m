From: Stephan Mueller <smueller@chronox.de>
Subject: Re: algif_aead: AIO broken with more than one iocb
Date: Tue, 13 Sep 2016 13:29:51 +0200
Message-ID: <2583617.pBW6uKOzYt@tauon.atsec.com>
References: <6245755.LbXSUvPjJL@positron.chronox.de> <20160913101246.GA30851@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47952 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750999AbcIML3x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 07:29:53 -0400
In-Reply-To: <20160913101246.GA30851@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 13. September 2016, 18:12:46 CEST schrieb Herbert Xu:

Hi Herbert,

> I don't think we should allow that.  We should make it so that you
> must start a recvmsg before you can send data for a new request.
> 
> Remember that the async path should be identical to the sync path,
> except that you don't wait for completion.

The question is, how does the algif code knows when more than one iocb was 
submitted? Note, each iocb is translated into an independent call of the 
recvmsg_async.

Ciao
Stephan
