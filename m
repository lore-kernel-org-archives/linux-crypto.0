From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warnings after merge of the crypto tree
Date: Mon, 13 Feb 2017 10:42:12 +1100
Message-ID: <20170213104212.73c09fe2@canb.auug.org.au>
References: <20170206122837.0226fb89@canb.auug.org.au>
        <20170206090340.GA9531@gondor.apana.org.au>
        <20170210141251.03b39b40@canb.auug.org.au>
        <20170211105621.GJ855@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:42991 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750882AbdBLXmQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Feb 2017 18:42:16 -0500
In-Reply-To: <20170211105621.GJ855@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Sat, 11 Feb 2017 18:56:21 +0800 Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Feb 10, 2017 at 02:12:51PM +1100, Stephen Rothwell wrote:
> >
> > I am still getting these warnings ... I have seen no updates to the
> > crypot tree since Feb 2.  
> 
> Sorry Stephen.  I have now applied Arnd's fixes for this problem
> and it should be pushed out.

Thanks, its much cleaner now. :-)

-- 
Cheers,
Stephen Rothwell
