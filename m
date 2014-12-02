From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: Is ansi_cprng.c supposed to be an implmentation of X9.31?
Date: Tue, 2 Dec 2014 08:22:33 -0500
Message-ID: <20141202132233.GB3388@hmsreliant.think-freely.org>
References: <2067542.hCsFeEhKF1@tauon>
 <20141202045518.27813.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, jarod@redhat.com,
	linux-crypto@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40473 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbaLBNWr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 08:22:47 -0500
Content-Disposition: inline
In-Reply-To: <20141202045518.27813.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 01, 2014 at 11:55:18PM -0500, George Spelvin wrote:
> >> The other one, which I have to think *very* hard about, is whether
> >> using the same seed material as /dev/random in this much weaker
> >> cryptographic construction will introduce a flaw in *it*.
> 
> > I have no idea what you are referring to here. The caller is requred to 
> > seed the DRNG. Typically that is done with a call to get_random_bytes. 
> > As Neil mentioned, the X9.31 DRNG implementation does not seed itself.
> 
> Er, yes it does.  Not the key, but the IV vector V[].
> 
> Here's the closest thing I can find on-line to a direct quote
> from the ANSI Spec:
> 
> http://www.untruth.org/~josh/security/ansi931rng.PDF
> 
> "Let DT be a date/time vector which is updated on each iteration."
> 
> This timestamp is a source of continuous reseed material.  The spec
> doesn't impose specific resolution requirements, but it's hopefully
> obvious that the finer, the better.  The goal is a vector which changes
> per iteration.
> 
That is an old version.  The updated version (published in 2005), and specified
in the ansi_cprng.c file removes that language.

> There are limitations due to its finite entropy and lack of catastrophic
> reseeding, as Kelsey & Schneier pointed out:
> 
> https://www.schneier.com/paper-prngs.html
> 
> but it is intended as an entropy source.
> 
Again, that language is removed in the more recent version.  Using DT as an
entropy source, and updating it on each iteration also destroys the predictive
nature of the cprng when two peers use it to communicate.  That is to say, if a
DT vector is updated every iteration, and the resultant R value is used as a key
to encrypt data, the validitiy of that key at a peer host using an identically
seeded cprng to decrypt is limited by the granularity of the DT value.  That is
to say, if you update DT every second in cprng, an entity that knows the secret
key can only decrypt that data up to a second after its encryption, unless the
decrypting entity also knows at exactly what time the data was encrypted.  If
you share the DT value, any entropy it provides becomes worthless, as it becomes
widely known.

The long and the short of it is that, if you want a cprng who's output can be
predicted by any entity with the IV and KEY values, then DT has to be known
initially and updated in a predictable fashion that is independent of the data
being transmitted.  Using a real date/time vector can't do that.

> Hopefully very soon I'll have a patch series to post.  (Unfortunately,
> I just managed to oops my kernel and need to reboot to continue testing.)
> 
> If I don't do much more, it'll be patch 13/17 in the series.  I think
> the use of get_random_int() is a good compromise between the raw
> random_get_entropy() timestamp and the (too heavy) get_random_bytes().
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
