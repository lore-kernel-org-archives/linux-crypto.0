From: Aditya Shevade <aditya.shevade@gmail.com>
Subject: Re: [PATCH] crypto: blowfish: Fixed a multi line macro issue
Date: Fri, 8 Apr 2011 10:46:57 -0700
Message-ID: <BANLkTikGeCWy3gdeCOX+OYsjuckRMG+b+Q@mail.gmail.com>
References: <1302158960-20479-1-git-send-email-aditya.shevade@gmail.com>
	<20110408124501.GB19422@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52519 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859Ab1DHRq5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Apr 2011 13:46:57 -0400
Received: by pwi15 with SMTP id 15so1330562pwi.19
        for <linux-crypto@vger.kernel.org>; Fri, 08 Apr 2011 10:46:57 -0700 (PDT)
In-Reply-To: <20110408124501.GB19422@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 8, 2011 at 5:45 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Apr 06, 2011 at 11:49:20PM -0700, Aditya Shevade wrote:
> > Fixed a multi line macro with do-while loop.
> > Fixed some other minor tab related issues.
> >
> > Signed-off-by: Aditya Shevade <aditya.shevade@gmail.com>
>
> Your patch doesn't even build!
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Oh, I see the problem. I forgot a semicolon in the commit file. Making
the change.
