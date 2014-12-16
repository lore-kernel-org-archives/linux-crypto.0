From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: Tue, 16 Dec 2014 06:32:31 -0500
Message-ID: <20141216113231.GA13806@hmsreliant.think-freely.org>
References: <20141215113243.GA3803@hmsreliant.think-freely.org>
 <20141215220102.23129.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smueller@chronox.de, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48158 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaLPLcq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Dec 2014 06:32:46 -0500
Content-Disposition: inline
In-Reply-To: <20141215220102.23129.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 15, 2014 at 05:01:02PM -0500, George Spelvin wrote:
> > With that then, I'm really fine with the changes given that they pass the NIST
> > tests.
> 
> So here's the current list of issues.  First, minor ones:
> 1) Add const to DRBG interface, as per Stephan's request.
> 2) Revised version of that final patch that, you know, actually works.
> 3) Re-run tests at the very end just to make sure.
> 
I would recommend that you do (1) in a follow on patch.  Same with (2) just drop
it from here.  Then you can rerun (3) before you submit those.

> And the major ones:
> 4) Is non-deterministic DT desired?
No, I have no need for it, nor does anyone that I know of who is currently using
it.  That said, if you want to add it, as long as you don't make
non-deterministic behavior the default, I'm not opposed.  Do it in a follow on
patch.

> 5) If yes, how to request it?
> 
Add a byte to the seed vector that holds optional flag information? set a flag
to indicate DT is determined by the wall clock?  Whatever you like really, just
don't change the default behavior.

> On point 4, here are the primary arguments against:
> 
> * It makes the generator non-deterministic, which is a significant
>   interface change and may break some applications.
> * This is a crufty old generator, used primarily for compatibility,
>   and it's best not to upset its quiet retirement.
> 
> And the primary arguments for:
> * It's an honest good-faith implementation of the spec requirements.
>   Using a counter is, IMHO, a strained interpretation.
> * The implementation isn't particularly difficult.
> 
> After considering various options, my current (not very firm) thought
> is that the best way to provide a non-deterministic option would be via
> a separate algorithm name.
> 
> But externally-visible names are a high-level design issue and I could
> definitely use some guidance there.  Opinions?
Honestly, if you don't have a user in mind for this feature, I just wouldn't
bother with it.  Unless you see some kernel code that is going to make use of
it, its going to be a feature that gets no exercize, and as such, won't really
be seen as much more than cruft itself.  If you have an in-kernel user in mind,
then sure, go with a new name, maybe nd(ansi_cprng) or some such.  Or just use
my interface above so that the existing registration can be either deterministic
or non-deterministic.  

But, if no one is going to be using it, why bother to do either?
Neil

> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
