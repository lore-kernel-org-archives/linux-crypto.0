From: Codarren Velvindron <codarren@hackers.mu>
Subject: Re: [PATCH] crypto: tcrypt: Zero iv before freeing it
Date: Mon, 24 Apr 2017 09:34:28 +0400
Message-ID: <20170424053428.GA6763@hackers.mu>
References: <20170423161204.GA9489@hackers.mu>
 <10591442.E9JOlzuEgW@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from walmailout06.yourhostingaccount.com ([65.254.253.50]:45153 "EHLO
        walmailout06.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1046431AbdDXGF0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 02:05:26 -0400
Received: from mailscan07.yourhostingaccount.com ([10.1.15.7] helo=walmailscan07.yourhostingaccount.com)
        by walmailout06.yourhostingaccount.com with esmtp (Exim)
        id 1d2Wdz-0000n2-94
        for linux-crypto@vger.kernel.org; Mon, 24 Apr 2017 01:34:39 -0400
Received: from [10.114.3.31] (helo=walimpout11)
        by walmailscan07.yourhostingaccount.com with esmtp (Exim)
        id 1d2Wdz-0000ve-6R
        for linux-crypto@vger.kernel.org; Mon, 24 Apr 2017 01:34:39 -0400
Content-Disposition: inline
In-Reply-To: <10591442.E9JOlzuEgW@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Apr 23, 2017 at 09:11:04PM +0200, Stephan Müller wrote:
> Am Sonntag, 23. April 2017, 18:12:04 CEST schrieb Codarren Velvindron:
> 
> Hi Codarren,
> 
> > Signed-off-by: Codarren Velvindron <codarren@hackers.mu>
> > ---
> >  crypto/tcrypt.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> > index 9a11f3c..48a721c 100644
> > --- a/crypto/tcrypt.c
> > +++ b/crypto/tcrypt.c
> > @@ -384,7 +384,7 @@ static void test_aead_speed(const char *algo, int enc,
> > unsigned int secs, out_noaxbuf:
> >  	testmgr_free_buf(xbuf);
> >  out_noxbuf:
> > -	kfree(iv);
> > +	kzfree(iv);
> 
> Why would you think this is needed?
> 
>        if (iv_len)
>               memset(iv, 0xff, iv_len);
> 
> 
> Ciao
> Stephan
Hello, 

Thanks for bringing this up to my attention.

Kindly disregard the patch.

Best Regards,
Codarren
