From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] crypto: convert crypto.h to UTF-8
Date: Thu, 3 May 2007 20:32:19 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0705032028580.18504@yvahk01.tjqt.qr>
References: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
 <20070502044345.GA29384@gondor.apana.org.au> <alpine.DEB.0.98.0705030711020.17390@sigma.j-a-k-j.com>
 <87r6pyqg2b.fsf@pelargir.dolphinics.no> <alpine.DEB.0.98.0705030915240.21257@sigma.j-a-k-j.com>
 <Pine.LNX.4.61.0705031719080.18504@yvahk01.tjqt.qr>
 <alpine.DEB.0.98.0705031132220.24982@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Arne Georg Gleditsch <argggh@dolphinics.no>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, trivial@kernel.org,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailer.gwdg.de ([134.76.10.26]:54535 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbXECShx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 May 2007 14:37:53 -0400
In-Reply-To: <alpine.DEB.0.98.0705031132220.24982@sigma.j-a-k-j.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On May 3 2007 11:35, John Anthony Kazos Jr. wrote:
>
>> >non-stupid/non-broken distributions of GNU/Linux and other major Un*ces 
>> >should be based on (or at least compatible with) UTF-8 in basic 
>> >operations. Files like the keymaps will be more work to convert, but they 
>> >can be as well.
>> >
>> >I'm operating on the assumption that anything in the tree that isn't UTF-8 
>> >is ISO-8859-1. Of course, I'm also checking it by hand to make sure a 
>> >small-O-with-umlaut doesn't become the Klingon logo...
>> 
>> This is probably all you'll ever see:
>> http://lkml.org/lkml/2007/1/8/222
>
>Does this mean you're doing it and I'll be ignored, or that few people 
>care and I'll be ignored?

Nah. I did a walkthrough once, and my discoveries were that
iso-8859-{2 .. 14} was a real minority if not nonexistant,
leaving you with almost obvious choices to guess what a file's
encoding is. If a name looks good, it must be UTF8 already.
Else try ISO-8859-1. If it still looks odd -- perhaps because
it's a weirdo character like "1/2" or it "does not sound right",
try cp437. etc.

> I figure if I just repost my patches to LKML 
>once per month, they'll eventually get merged (or at least I'll get 
>comments on how people actually want them). Things are tough on a 
>high-volume list. I think the git method may have the best chance of 
>success. We'll see.
>

Jan
-- 
