From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: Camellia encryption module: incompatible
Date: Sun, 07 Sep 2008 12:55:42 -0700
Message-ID: <1220817342.24115.0.camel@brick>
References: <20080906124449.GB28842@frittella.fluido.as>
	 <20080906144250.GA8829@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Carlo E. Prelz" <fluido@fluido.as>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:55224 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbYIGTzj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Sep 2008 15:55:39 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1276394wfd.4
        for <linux-crypto@vger.kernel.org>; Sun, 07 Sep 2008 12:55:38 -0700 (PDT)
In-Reply-To: <20080906144250.GA8829@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 2008-09-07 at 00:42 +1000, Herbert Xu wrote:
> On Sat, Sep 06, 2008 at 02:44:49PM +0200, Carlo E. Prelz wrote:
> > Hello there. I see you are the person who pushed upwards changes
> > related to the Linux crypto susbsystem for 2.6.27. I wanted to let you
> > know that, on a Core2 laptop platform, the new code for the Camellia
> > module generates different encrypted content. Both implementations
> > work, but a file that was encrypted with pre-2.6.27 cannot be
> > decrypted with the current code. 
> > 
> > Was this intentional? I saw no indication about this on the notes that
> > went with the patch. 
> 
> No this is not intentional.  Thanks for reminding me.
> 
> Harvey, I think I'm going to revert the bitops change for now.
> 

Please do, I still haven't managed to to track down why this changes
any behavior, I'll resubmit at a later date if I ever figure it out.

Harvey

