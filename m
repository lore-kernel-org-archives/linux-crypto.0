From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v3 0/2] crypto: AF_ALG memory management fix
Date: Thu, 16 Feb 2017 13:55:55 +0100
Message-ID: <1562177.Y0EmCeTO2L@tauon.atsec.com>
References: <1652737.cgCBfDoNyd@positron.chronox.de> <2976339.VnMoFl3GdB@positron.chronox.de> <20170216121021.GA18940@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59666 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754622AbdBPM4D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2017 07:56:03 -0500
In-Reply-To: <20170216121021.GA18940@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 16. Februar 2017, 20:10:21 CET schrieb Herbert Xu:

Hi Herbert,

> On Wed, Feb 15, 2017 at 09:47:19AM +0100, Stephan Müller wrote:
> > as I just saw that you marked my patch with changes requested in
> > patchwork,
> > may I ask which changes should be applied?
> 
> I thought we agreed that we would not do the TX offset thing and
> keep the existing semantics of consuming all TX data given an RX
> request.

Ok, will do.

Ciao
Stephan
