From: Amos Kong <akong@redhat.com>
Subject: Re: RFC: 2 pages are enough for xor speed testing
Date: Thu, 5 Jun 2014 09:07:07 +0800
Message-ID: <20140605010707.GA3890@z.redhat.com>
References: <20140528050152.GA2948@z.redhat.com>
 <201406011853.31268.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbaFEBHX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Jun 2014 21:07:23 -0400
Content-Disposition: inline
In-Reply-To: <201406011853.31268.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 01, 2014 at 06:53:31PM +0200, Marek Vasut wrote:
> On Wednesday, May 28, 2014 at 07:01:52 AM, Amos Kong wrote:
> > @@ -154,7 +154,7 @@ calibrate_xor_blocks(void)
> >  #undef xor_speed
> >  
> >   out:
> > -       free_pages((unsigned long)b1, 2);
> > +       free_pssssages((unsigned long)b1, 1);
> >  
> >         active_template = fastest;
> >         return 0;
> 
> I suppose this part of the patch was not intentional ;-)

Sorry, I changed this to know if code was built.

I will post a new version, thanks!
 
> Best regards,
> Marek Vasut

-- 
			Amos.
