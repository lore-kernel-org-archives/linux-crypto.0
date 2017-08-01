From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/16] crypto: AF_ALG - consolidation
Date: Tue, 01 Aug 2017 11:01:54 +0200
Message-ID: <88356288.VicKj4yezc@tauon.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de> <20170801085858.GA32240@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60918 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751858AbdHAJB4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2017 05:01:56 -0400
In-Reply-To: <20170801085858.GA32240@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 1. August 2017, 10:58:58 CEST schrieb Herbert Xu:

Hi Herbert,
> 
> This split makes no sense.  I don't see why you can't merge them
> into a single patch if it's just rearranging the code.

If you want to merge all into one patch, I am fine.

I thought that separating all out makes the patch review easier, considering 
that in two or three of the patches, small changes are implemented to allow a 
common code base. These changes, however, should not have any functional 
effect.

Ciao
Stephan
