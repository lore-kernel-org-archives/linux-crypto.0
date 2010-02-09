From: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [TuxOnIce-devel] LZO irreversible output?
Date: Wed, 10 Feb 2010 07:38:56 +1100
Message-ID: <4B71C7E0.80900@crca.org.au>
References: <4B69ECE5.5060505@crca.org.au> <201002032354.11284.rjw@sisk.pl>	<4B6A4F07.3090509@crca.org.au> <hkneh9$djl$1@ger.gmane.org>	<4B6FCC47.2030705@crca.org.au> <874olq1fis.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Bill Davidsen <davidsen@tmr.com>,
	tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.crca.org.au ([67.207.131.56]:51989 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab0BIUgn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 15:36:43 -0500
In-Reply-To: <874olq1fis.fsf@spindle.srvr.nix>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

Nix wrote:
> On 8 Feb 2010, Nigel Cunningham verbalised:
>> That said, the actual code that TuxOnIce uses does already initialise
>> the variable to PAGE_SIZE, so it seems that I might just have to run
>> with the checking code enabled (with this fix) for a while, until the
>> issue is found.
> 
> If you push the fix somewhere I'll run with it as well and see if I can
> make this problem happen again. (So far I've only seen it with both
> compression and max_workers > 1, but I haven't done a systematic check
> for this so it could be an illusion.)

I will do - I've just been very slow to because I'm in the middle of
switching website hosting at the moment (as well as the week-to-week
parts of my real job!). Too much to do and not enough time :)

Nigel
