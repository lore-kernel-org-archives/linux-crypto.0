From: "George Spelvin" <linux@horizon.com>
Subject: Re: Is ansi_cprng.c supposed to be an implmentation of X9.31?
Date: 2 Dec 2014 12:56:15 -0500
Message-ID: <20141202175615.31851.qmail@ns.horizon.com>
References: <20141202132233.GB3388@hmsreliant.think-freely.org>
Cc: herbert@gondor.apana.org.au, jarod@redhat.com,
	linux-crypto@vger.kernel.org, smueller@chronox.de
To: linux@horizon.com, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:59507 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751916AbaLBR4Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 12:56:16 -0500
In-Reply-To: <20141202132233.GB3388@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> That is an old version.  The updated version (published in 2005), and
> specified in the ansi_cprng.c file removes that language.

Oh!  Thank you!  I'm pretty sure I read the 1998 version.

In fact, apparently there's a 2010 version:

http://www.codesdownload.org/3761-ANSI-X9-TR-31-2010.html

I need to figure out how to get my hands on that.

Presumably this is the 2005 version with the 2009 supplement incorporated.
If I could read Chinese, I might be able to find it here:

http://www.docin.com/p-524511188.html

> The long and the short of it is that, if you want a cprng who's output can be
> predicted by any entity with the IV and KEY values, then DT has to be known
> initially and updated in a predictable fashion that is independent of the data
> being transmitted.  Using a real date/time vector can't do that.

Er, yes, this is all extremely obvious; I'm not quite sure why we're
belabouring it.  Fully deterministic generators have their uses, which
is why I had to ask in the beginning what the design intent was.

If this is *intended* to be purely deterministic, there's nothing to fix.
I'd like to propose a small comment clarification because a quick reading
confused me.

But when I talked about making it random, you said "send a patch", so
I did.  If you don't want the semantic change, I'm not upset.  The other
code cleanups are hopefully (after I've finished polishing them) useful;
just stop before the whole "union block" business.
