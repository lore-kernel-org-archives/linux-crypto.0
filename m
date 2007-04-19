From: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Thu, 19 Apr 2007 10:07:53 +0200
Message-ID: <38b2ab8a0704190107x2c151bafx824beca052f97ef6@mail.gmail.com>
References: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
	 <E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
	 <38b2ab8a0704170741n619e169s6a2f3ac5b768a950@mail.gmail.com>
	 <adairbv57s2.fsf@cisco.com>
	 <38b2ab8a0704170914h3a766236t47bc7e1c8de67662@mail.gmail.com>
	 <ada7isb3qr2.fsf@cisco.com>
	 <38b2ab8a0704171024m3d838bdak14370a7d0931557f@mail.gmail.com>
	 <adalkgq3nx6.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: "Roland Dreier" <rdreier@cisco.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.232]:3176 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993191AbXDSIHz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Apr 2007 04:07:55 -0400
Received: by nz-out-0506.google.com with SMTP id s1so389734nze
        for <linux-crypto@vger.kernel.org>; Thu, 19 Apr 2007 01:07:54 -0700 (PDT)
In-Reply-To: <adalkgq3nx6.fsf@cisco.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 4/17/07, Roland Dreier <rdreier@cisco.com> wrote:
>  > > It seems trivial to keep the last key you were given and do a quick
>  > > memcmp in your setkey method to see if it's different from the last
>  > > key you pushed to hardware, and set a flag if it is.  Then only do
>  > > your set_key() if you have a new key to pass to hardware.
>  > >
>  > > I'm assuming the expense is in the aes_write() calls, and you could
>  > > avoid them if you know you're not writing something new.
>
>  > that's a wrong assumption. aes_write()/aes_read() are both used to
>  > access to the controller and are slow (no cache involved).
>
> Sorry, I wasn't clear.  I meant that the hardware access is what is
> slow, and that anything you do on the CPU is relatively cheap compared
> to that.
>
> So my suggestion is just to keep a cache (in CPU memory) of what you
> have already loaded into the HW, and before reloading the HW just
> check the cache and don't do the actual HW access if you're not going
> to change the HW contents.  So you avoid any extra aes_write and
> aes_read calls in the cache hit case.
>
> This would have the advantage of making anything that does lots of
> bulk encryption fast without special casing ecryptfs.
>

I'm not sure how "memcmp(key, cache, KEY_SIZE)" would impact AES
performance. I need to give it a test but can't today. I'll do
tomorrow and give you back the result.

Thanks
-- 
Francis
