From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] crypto: arm/aes-ce: assign err return conditionally
Date: Sat, 11 Feb 2017 10:15:43 +0000
Message-ID: <20170211101543.GC13432@osadl.at>
References: <1486560979-25240-1-git-send-email-der.herr@hofr.at>
 <20170211093946.GA749@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 92-243-34-74.adsl.nanet.at ([92.243.34.74]:50192 "EHLO
        mail.osadl.at" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751009AbdBKKP5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Feb 2017 05:15:57 -0500
Content-Disposition: inline
In-Reply-To: <20170211093946.GA749@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 11, 2017 at 05:39:46PM +0800, Herbert Xu wrote:
> On Wed, Feb 08, 2017 at 02:36:19PM +0100, Nicholas Mc Guire wrote:
> > As the err value is not used unless there was an error it can be assigned
> > conditionally here. 
> > 
> > Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> 
> This patch just adds noise to the commit history.  So I'm not going
> to apply it.

ok - I was not sure about how sensible this sort of changes are
either - will drop those code-to-object refactoring experiments
then again.

thx!
hofrat
