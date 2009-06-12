From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: add optional continuous repetition test to
	entropy store based rngs
Date: Fri, 12 Jun 2009 10:23:08 -0400
Message-ID: <20090612142308.GA29341@hmsreliant.think-freely.org>
References: <20090604195030.GA11300@hmsreliant.think-freely.org> <1244146450.22069.216.camel@calx> <20090605000456.GA10883@localhost.localdomain> <20090605003006.GA5236@gondor.apana.org.au> <20090605014816.GA15462@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51166 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758972AbZFLOXT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Jun 2009 10:23:19 -0400
Content-Disposition: inline
In-Reply-To: <20090605014816.GA15462@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 04, 2009 at 09:48:16PM -0400, Neil Horman wrote:
> On Fri, Jun 05, 2009 at 10:30:06AM +1000, Herbert Xu wrote:
> > On Thu, Jun 04, 2009 at 08:04:56PM -0400, Neil Horman wrote:
> > >
> > > Not sure what to do about this.  The intent is to provide the external reference
> > > to the fips_enabled flag (which is either defined as an extern in or #defined to
> > > 0 dependent on CONFIG_CRYPTO_FIPS).  I can cut'n'paste the code block from the
> > > include file and put it in here, but that seems like a worse solution to me.
> > > Let me know your thoughts, and I can change this accordingly.
> > 
> > You can put the fips flag into its own header file, e.g., linux/fips.h.
> > 
> 
> Ok, that seems like a reasonable idea.  new patch below
> Change Notes:
> 
> 1) Moved fips_enabled flag into its own header, included in all the appropriate
> places
> 
> 2) removed flags field from entropy store, keying continuous test on the
> non-null status of the last_data pointer
> 
> 
> FIPS-140 requires that all random number generators implement continuous self
> tests in which each extracted block of data is compared against the last block
> for repetition.  The ansi_cprng implements such a test, but it would be nice if
> the hw rng's did the same thing.  Obviously its not something thats always
> needed, but it seems like it would be a nice feature to have on occasion. I've
> written the below patch which allows individual entropy stores to be flagged as
> desiring a continuous test to be run on them as is extracted.  By default this
> option is off, but is enabled in the event that fips mode is selected during
> bootup.
> 
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
Ping, I don't see that this got picked up in the crypto tree.  Are there
subsequent objections?

Neil

