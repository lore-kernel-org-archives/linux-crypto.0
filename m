From: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Tue, 17 Apr 2007 19:24:04 +0200
Message-ID: <38b2ab8a0704171024m3d838bdak14370a7d0931557f@mail.gmail.com>
References: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
	 <E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
	 <38b2ab8a0704170741n619e169s6a2f3ac5b768a950@mail.gmail.com>
	 <adairbv57s2.fsf@cisco.com>
	 <38b2ab8a0704170914h3a766236t47bc7e1c8de67662@mail.gmail.com>
	 <ada7isb3qr2.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: "Roland Dreier" <rdreier@cisco.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:12422 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161133AbXDQRYH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Apr 2007 13:24:07 -0400
Received: by wr-out-0506.google.com with SMTP id 76so1873286wra
        for <linux-crypto@vger.kernel.org>; Tue, 17 Apr 2007 10:24:05 -0700 (PDT)
In-Reply-To: <ada7isb3qr2.fsf@cisco.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 4/17/07, Roland Dreier <rdreier@cisco.com> wrote:
>  > > I wonder if there's some way you can cache the last caller and reload
>  > > the key lazily (only when it changes).
>  >
>  > yes something that allows crypto drivers to detect if the key has
>  > changed would be good.
>
> It seems trivial to keep the last key you were given and do a quick
> memcmp in your setkey method to see if it's different from the last
> key you pushed to hardware, and set a flag if it is.  Then only do
> your set_key() if you have a new key to pass to hardware.
>
> I'm assuming the expense is in the aes_write() calls, and you could
> avoid them if you know you're not writing something new.
>

that's a wrong assumption. aes_write()/aes_read() are both used to
access to the controller and are slow (no cache involved).

thanks
-- 
Francis
