From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: Tue, 16 Dec 2014 08:22:06 +0100
Message-ID: <19706951.Vh6MrmHIBE@tauon>
References: <20141215220102.23129.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: nhorman@tuxdriver.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55074 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbaLPHWR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Dec 2014 02:22:17 -0500
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SC8C9> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Tue, 16 Dec 2014 08:22:07 +0100
In-Reply-To: <20141215220102.23129.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 15. Dezember 2014, 17:01:02 schrieb George Spelvin:

Hi George,

>> With that then, I'm really fine with the changes given that they pass
>> the NIST tests.
>
>So here's the current list of issues.  First, minor ones:
>1) Add const to DRBG interface, as per Stephan's request.
>2) Revised version of that final patch that, you know, actually works.
>3) Re-run tests at the very end just to make sure.
>
>And the major ones:
>4) Is non-deterministic DT desired?
>5) If yes, how to request it?
>
>On point 4, here are the primary arguments against:
>
>* It makes the generator non-deterministic, which is a significant
>  interface change and may break some applications.
>* This is a crufty old generator, used primarily for compatibility,
>  and it's best not to upset its quiet retirement.
>
>And the primary arguments for:
>* It's an honest good-faith implementation of the spec requirements.
>  Using a counter is, IMHO, a strained interpretation.
>* The implementation isn't particularly difficult.
>
>After considering various options, my current (not very firm) thought
>is that the best way to provide a non-deterministic option would be via
>a separate algorithm name.
>
>But externally-visible names are a high-level design issue and I could
>definitely use some guidance there.  Opinions?

The standard X9.31 is called ansi_cprng.

Logically your non-deterministic approach is a constant reseeding of the 
DRNG. In SP800-90A speak this is called "prediction-resistance". Hence, 
my DRBGs use "pr" for that approach -- e.g. drbg_pr_sha256. The name 
follows the structure of "RNG type"_"[pr|nopr]"_"algo".

For the X9.31 RNG we do not have an algorithmic reference as we only 
have AES128. We only have the RNG type and the "pr" reference.

Thus, I would propose "ansi_cprng_pr" as a name that is analogous to the 
DRBG implementations.

Ciao
Stephan
