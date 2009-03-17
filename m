From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: New kernel hifn795x driver does not play nice with luks
Date: Wed, 18 Mar 2009 01:47:22 +0300
Message-ID: <20090317224722.GB6290@ioremap.net>
References: <20090317221703.562AE233FB@ws5-3.us4.outblaze.com> <20090317223332.GD1795@tatooine.rebelbase.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: infected@hellokitty.com, linux-crypto@nl.linux.org,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from genesysrack.ru ([195.178.208.66]:43374 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbZCQWrZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Mar 2009 18:47:25 -0400
Content-Disposition: inline
In-Reply-To: <20090317223332.GD1795@tatooine.rebelbase.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 17, 2009 at 11:33:32PM +0100, markus reichelt (ml@mareichelt.de) wrote:
> > I have encountered a problem with the new HiFn driver in 2.6.27,
> > cryptsetup and luks.
> 
> the mailinglist you posted to mainly deals with loop-aes these days,
> the dm-crypt/luks/mainline loop-crypto guys for some obscure reason
> opted to start a mailinglist of the same name at
> linux-crypto@vger.kernel.org, so you are better off asking there
> (blame them for confusing people).
> 
> CC added, though I guess you need to subscribe to their holy shrine,
> anyway. And keep in mind that dm-crypt/yada is still beta-code, it's
> nowhere near stable.
 
What was that?
Also, ml@mareichelt.de email was not in the proper header, so it does not
appear in copy list.
 
> > I am able to unlock my luks devices fine, but attempting to mount
> > the device will result in mount hanging forever (ps shows it as D+,
> > presumably it's waiting for I/O from the card), forcing me to
> > manually kill the process. If i then try to close the luks
> > partition luksClose informs me that the drive is in use. The
> > hifn_795x module will be locked as well in the process.
> > 
> > However, as soon as I disable/remove the hifn_795x module prior to
> > mounting the device, everything works as it should yet again.

Please send a dmesg output when card is blocked.
Thank you.

-- 
	Evgeniy Polyakov
