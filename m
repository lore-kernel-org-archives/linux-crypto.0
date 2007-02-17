From: Daniel Barkalow <barkalow@iabervon.org>
Subject: Autoloading crypto modules
Date: Sat, 17 Feb 2007 14:10:09 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702171316540.20138@iabervon.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from iabervon.org ([66.92.72.58]:4772 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932780AbXBQTQw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Feb 2007 14:16:52 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I was having problems with WEP (in 2.6.19, but the relevant code 
doesn't seem to have changed), which I eventually tracked down to this:

 ieee80211-crypt-wep tries to use "ecb(arc4)", which works fine if ecb, 
 arc4, and cryptomgr are already loaded, but doesn't cause them to be 
 loaded if only arc4 is loaded.

I haven't tried with arc4 not loaded, but I did try arc4,cryptomgr and 
arc4,ecb; neither of these caused the third one to be loaded.

(I also had crypto_algapi, michael_mic, and aes loaded, if that matters)

I can test stuff without too much trouble, but I'm out of ideas for things 
to test.

	-Daniel
*This .sig left intentionally blank*
