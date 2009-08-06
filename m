From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-crypt] cryptsetup with arc4 cipher
Date: Thu, 06 Aug 2009 09:46:59 +0200
Message-ID: <4A7A8A73.706@redhat.com>
References: <87zlaf3zl0.wl@obsidian.enotty.net> <4A7984A7.40109@redhat.com> <20090805203017.GA5875@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Stelios Bounanos <sb-lst@enotty.net>, dm-crypt@saout.de,
	linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47296 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbZHFHrj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Aug 2009 03:47:39 -0400
In-Reply-To: <20090805203017.GA5875@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Sebastian Andrzej Siewior wrote:
> Don't use this as a block cipher in dm-crypt, it is a bad idea.
> 
> The long story:
> ARC4 is a stream cipher and not a block cipher. Its internal state is
> reseted in setkey() and every crypto request (encrypt/decrypt don't
> matter) update the internal state of the stream cipher. That's why you
> get a different result every time you read the same block.
> 
> If you want to use this stream cipher in dm-crypt you would have to
> setup it up in ECB mode and use a key like "passphrase-IV". You have to
> set this key before a requests and wait until its done until you
> issue another crypto request (which includes setkey).

yes, I understand why this happens. I do not want to use stream cipher,
but apparently users will do that:-)

My question was why crypto allows this setting?
Or maybe what to do in dm-crypt to not allow user set such cipher
mapping (because it cannot produce anything useful).

IMHO it will not work even in ECB mode here for dm-crypt.
(also dm-crypt uses own IV function generators, but it is another story)

> CBC will not work because one of its requirements is that the cipher
> provides an inverse function which ARC4 simply does not have.

Again, why crypto API allows to use it and do not produce error then?

Milan
--
mbroz@redhat.com

