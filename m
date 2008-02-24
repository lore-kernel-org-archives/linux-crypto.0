From: Stefan Hellermann <stefan@the2masters.de>
Subject: Re: [RFC] padlock aes, unification of setkey()
Date: Sun, 24 Feb 2008 12:54:20 +0100
Message-ID: <47C15AEC.5040705@the2masters.de>
References: <1203850864-16681-1-git-send-email-sebastian@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp11.unit.tiscali.de ([213.205.33.47]:54235 "EHLO
	smtp11.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbYBXMO5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Feb 2008 07:14:57 -0500
In-Reply-To: <1203850864-16681-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I'm got my Via Epia SN Board a few days ago and could test everything related to the
padlock engine, I'm especially interested in the aes-{lrw,xts} combo, this doesn't work at
the moment (last tested with 2.6.25-rc1).

Cheers,
Stefan

Sebastian Siewior schrieb:
> From Sebastian Siewior <sebastian@breakpoint.cc> # This line is ignored.
> Subject: [RFC] padlock aes, unification of setkey()
> 
> Hello Herbert,
> 
> I sit on those two since November. Back then Michal dropped me an email
> and told me that he will test it and get back to me. This didn't happen
> so far.
> The binary format of the key was the same, the last time I checked, so
> the second patch could really work :)
> 
> One thing I'm concerned about is the stack utilization. The initial
> version had a structure with 256 bytes on the stack. Mine has a bigger
> structure with 484 bytes. I'm not sure if it is better to dynamically
> allocate it, move it to the private key structure or pad the generic
> aes structure in order to enforce the required alignment.
> 
> Sebastian
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
