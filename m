From: markus reichelt <ml@mareichelt.de>
Subject: Re: New kernel hifn795x driver does not play nice with luks
Date: Tue, 17 Mar 2009 23:33:32 +0100
Message-ID: <20090317223332.GD1795@tatooine.rebelbase.local>
References: <20090317221703.562AE233FB@ws5-3.us4.outblaze.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7BIT
Cc: linux-crypto@nl.linux.org, linux-crypto@vger.kernel.org
To: infected@hellokitty.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:62622 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770AbZCQWdg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Mar 2009 18:33:36 -0400
Content-disposition: inline
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0KGO00IKT9BX3020@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-crypto@vger.kernel.org; Tue, 17 Mar 2009 23:33:33 +0100 (CET)
In-reply-to: <20090317221703.562AE233FB@ws5-3.us4.outblaze.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> I have encountered a problem with the new HiFn driver in 2.6.27,
> cryptsetup and luks.

the mailinglist you posted to mainly deals with loop-aes these days,
the dm-crypt/luks/mainline loop-crypto guys for some obscure reason
opted to start a mailinglist of the same name at
linux-crypto@vger.kernel.org, so you are better off asking there
(blame them for confusing people).

CC added, though I guess you need to subscribe to their holy shrine,
anyway. And keep in mind that dm-crypt/yada is still beta-code, it's
nowhere near stable.

HTH


> I am able to unlock my luks devices fine, but attempting to mount
> the device will result in mount hanging forever (ps shows it as D+,
> presumably it's waiting for I/O from the card), forcing me to
> manually kill the process. If i then try to close the luks
> partition luksClose informs me that the drive is in use. The
> hifn_795x module will be locked as well in the process.
> 
> However, as soon as I disable/remove the hifn_795x module prior to
> mounting the device, everything works as it should yet again.
> 
> It seems the HiFn card has taken over as the preferred module to
> use for AES, according to /proc/crypto:
> 
> ------------------------------
> name         : cbc(aes)
> driver       : cbc-aes-hifn0
> module       : hifn_795x
> priority     : 300
> (...)
> ------------------------------
> name         : aes
> driver       : aes-asm
> module       : kernel
> priority     : 200
> (...)
> ------------------------------
> name         : aes
> driver       : aes-generic
> module       : kernel
> priority     : 100
> (...)
> ------------------------------
> 
> I have no idea what the problem might be, but I suppose the HiFn
> card might not like my luks partitions (aes, cbc-essiv), or some
> other incompatibility or other issues somewhere.
> 
> Have anyone else experienced this behavior? Any possible solutions?
> 
> Prior to the 2.6.27 kernel I was running OCF to handle my card, and
> everything was working splendid, however the performance of the
> HiFn RNG is many times higher with the built-in driver (from
> ~300kb/s to ~2.5MB/s), and since my main beef with this card is the
> RNG I would very much like to stay with the driver from 2.6.27.
> 
> Is there any way to change the priority on these cipher modules so
> the kernel ones would be used in preference of the hifn_795x ones?
> I am perfectly happy doing luks and general AES in software, if
> only there was a way for me to set their priority by hand.
> 
> 
> 
> Best Regards,
> Frode Moseng Monsson

-- 
left blank, right bald
loop-AES FAQ: http://mareichelt.de/pub/texts.loop-aes.php#faq
