From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: 15 Dec 2014 17:01:02 -0500
Message-ID: <20141215220102.23129.qmail@ns.horizon.com>
References: <20141215113243.GA3803@hmsreliant.think-freely.org>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux@horizon.com
To: nhorman@tuxdriver.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:39822 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750764AbaLOWBF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2014 17:01:05 -0500
In-Reply-To: <20141215113243.GA3803@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> With that then, I'm really fine with the changes given that they pass the NIST
> tests.

So here's the current list of issues.  First, minor ones:
1) Add const to DRBG interface, as per Stephan's request.
2) Revised version of that final patch that, you know, actually works.
3) Re-run tests at the very end just to make sure.

And the major ones:
4) Is non-deterministic DT desired?
5) If yes, how to request it?

On point 4, here are the primary arguments against:

* It makes the generator non-deterministic, which is a significant
  interface change and may break some applications.
* This is a crufty old generator, used primarily for compatibility,
  and it's best not to upset its quiet retirement.

And the primary arguments for:
* It's an honest good-faith implementation of the spec requirements.
  Using a counter is, IMHO, a strained interpretation.
* The implementation isn't particularly difficult.

After considering various options, my current (not very firm) thought
is that the best way to provide a non-deterministic option would be via
a separate algorithm name.

But externally-visible names are a high-level design issue and I could
definitely use some guidance there.  Opinions?
