From: Eric Wheeler <linux-crypto@lists.ewheeler.net>
Subject: Re: crypto regression in 4.1.18: Check that kernel supports
 aes-cbc-essiv:sha256 cipher
Date: Mon, 7 Mar 2016 04:02:30 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603070401170.11530@mail.ewheeler.net>
References: <alpine.LRH.2.11.1603010129330.3635@mail.ewheeler.net> <20160301025853.GB17542@kroah.com> <56D727A7.8030800@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"Wang, Rui Y" <rui.y.wang@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jean Delvare <jdelvare@suse.de>, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:41120 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752008AbcCGECi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 6 Mar 2016 23:02:38 -0500
In-Reply-To: <56D727A7.8030800@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2 Mar 2016, Milan Broz wrote:

> On 03/01/2016 03:58 AM, Greg KH wrote:
> > On Tue, Mar 01, 2016 at 01:32:05AM +0000, Eric Wheeler wrote:
> >> Hello all,
> >>
> >> We updated from 4.1.17 to 4.1.18 (same .config) and now get the following 
> >> error when trying to open a LUKS volume.  We've reverted to 4.1.17 and it 
> >> still works, so except that I'm not sure which commit caused the problem, 
> >> it is likely one of the recent commits:
> >>
> >> When we `cryptsetup luksOpen` the volume we get this:
> >>
> >>   Check that kernel supports aes-cbc-essiv:sha256 cipher (check syslog for more info).  
> >>
> >> Note that I do not see any dm-crypto commits so I don't think its a 
> >> dm-crypto issue. 
> >>
> >> I'm happy to test, but can someone who knows the crypto stack suggest 
> >> which of these patches I should focus on for testing? These are the 
> >> commits in 4.1.18 that could be relevant:
> > 
> > There are some pending crypto backports to resolve this that hopefully
> > will show up in the next release, whenever Sasha gets to it.
> 
> Also there is already released cryptsetup 1.7.1 that works even with this kernel.

Interesting.  API change?  I'd like to read up on it.  Is there a commit 
or mailing thread on the topic?

-Eric

> 
> Milan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
