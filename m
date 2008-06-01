From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: Re: [PATCH] tcrypt: add self test for des3_ebe cipher operating in
 cbc mode
Date: Mon, 02 Jun 2008 00:43:46 +0200
Message-ID: <48432622.1090300@swiss-it.ch>
References: <20080523195145.GA28328@hmsreliant.think-freely.org> <20080524000624.GB26747@gondor.apana.org.au> <20080524003458.GB10168@localhost.localdomain> <4841F6F6.2020502@swiss-it.ch> <20080601160349.GA29225@localhost.localdomain> <4842C9CA.9070506@swiss-it.ch> <20080601221839.GA5171@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:56951 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbYFAWnv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Jun 2008 18:43:51 -0400
In-Reply-To: <20080601221839.GA5171@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Neil Horman wrote:
> On Sun, Jun 01, 2008 at 06:09:46PM +0200, Adrian-Ken Rueegsegger wrote:
>> Neil Horman wrote:
>>> On Sun, Jun 01, 2008 at 03:10:14AM +0200, Adrian-Ken Rueegsegger wrote:
>>>> Neil Horman wrote:
[snip]
>>>> These tests both seem to fail on my machine. Did you verify that the tests pass succesfully?
>>>>
>>>> -Adrian
>>>>
>>> Yes, of course I did.  I clearly indicated that I did in my commit message
>>> above.  I just verified on a separate system as well.  You had mentioned that
>>> some of the standard NIST vectors that you obtained were failing on your system
>>> as well, is something perhaps misconfigured in your kernel build?  Mind you I
>>> can't imagine what that would be, and if it were just my vectors that were
>>> failing for you I could imagine I missed something that would work in my testing
>>> but fail in yours, but if standard vectors are failing it seems something else
>>> might be wrong
>> Sorry, I did not mean to come off so hostile. I merely wanted to find out if I was the only one with failing test results. I will investigate, why this fails on my machine.
>>
> I know you didn't.  I apologize as well.  I can't imagine why they would be
> failing.  I verified them in the tcrypt self tests again, as well as under
> openssl in userspace, and both passed correctly.  I've still have no idea what
> causes the failure.  I do recall there being a case in the setkey path that
> returned an error without setting flags.  I hit that writing my vectors.  I'll
> see if I can find it again.

I just did a clean build on a different machine with the current HEAD (ac3f925c2bb1b08a41713394d78098857d3f40a7)
of the cryptodev-2.6-tree. The two tests fail on that box too. :( I will see if I can spot something suspicious by
comparing the two configs. Could somebody else run the tests and report back the results?

Here's a shot in the dark: was there a mixup during the patch submission? Maybe you submitted a different version
of the patch than intended?

Adrian
