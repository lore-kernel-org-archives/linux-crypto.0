From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Tue, 17 Apr 2007 09:33:21 -0700
Message-ID: <ada7isb3qr2.fsf@cisco.com>
References: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
	<E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
	<38b2ab8a0704170741n619e169s6a2f3ac5b768a950@mail.gmail.com>
	<adairbv57s2.fsf@cisco.com>
	<38b2ab8a0704170914h3a766236t47bc7e1c8de67662@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: "Francis Moreau" <francis.moro@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:13797 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030775AbXDQQdg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Apr 2007 12:33:36 -0400
In-Reply-To: <38b2ab8a0704170914h3a766236t47bc7e1c8de67662@mail.gmail.com> (Francis Moreau's message of "Tue, 17 Apr 2007 18:14:58 +0200")
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

 > > I wonder if there's some way you can cache the last caller and reload
 > > the key lazily (only when it changes).
 > 
 > yes something that allows crypto drivers to detect if the key has
 > changed would be good.

It seems trivial to keep the last key you were given and do a quick
memcmp in your setkey method to see if it's different from the last
key you pushed to hardware, and set a flag if it is.  Then only do
your set_key() if you have a new key to pass to hardware.

I'm assuming the expense is in the aes_write() calls, and you could
avoid them if you know you're not writing something new.

 - R.
