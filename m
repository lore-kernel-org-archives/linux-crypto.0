From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 0/6] Add support for ECDSA algorithm
Date: Thu, 26 Jan 2017 08:44:20 +0100
Message-ID: <1944337.x0rFnX3oUE@tauon.atsec.com>
References: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com> <20170123142417.GD19957@gondor.apana.org.au> <113d3ef8-ef34-0651-71e7-be09ef55727e@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        linux-crypto@vger.kernel.org
To: Nitin Kumbhar <nkumbhar@nvidia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55654 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752867AbdAZHo0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Jan 2017 02:44:26 -0500
In-Reply-To: <113d3ef8-ef34-0651-71e7-be09ef55727e@nvidia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 26. Januar 2017, 11:30:04 CET schrieb Nitin Kumbhar:

Hi Nitin,

> > Who is going to use this in the kernel?
> 
> This ECDSA implementation is analogous to the RSA kernel implementation
> for signature generation / verification. It extends ECC family of
> algorithms like ECDH to support signature verification using akcipher.
> This will be used in a way similar to RSA.

So, I guess that I should dust off algif_akcipher now.

Ciao
Stephan
