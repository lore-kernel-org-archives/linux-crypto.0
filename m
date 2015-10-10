From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3b 5/5] crypto: marvell: factor out common import/export
 functions
Date: Sat, 10 Oct 2015 17:17:54 +0100
Message-ID: <20151010161754.GG32532@n2100.arm.linux.org.uk>
References: <E1Zkda6-0005Ix-2x@rmk-PC.arm.linux.org.uk>
 <E1Zke3a-00042e-Jx@rmk-PC.arm.linux.org.uk>
 <87oag78y8i.fsf@natisbad.org>
 <20151009235132.GE32532@n2100.arm.linux.org.uk>
 <87d1wn2ewu.fsf@natisbad.org>
 <20151010112925.GF32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Marek Vasut <marex@denx.de>
To: Arnaud Ebalard <arno@natisbad.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:53844 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbJJQSK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Oct 2015 12:18:10 -0400
Content-Disposition: inline
In-Reply-To: <20151010112925.GF32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 10, 2015 at 12:29:25PM +0100, Russell King - ARM Linux wrote:
> On Sat, Oct 10, 2015 at 12:31:29PM +0200, Arnaud Ebalard wrote:
> > Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> > > Software:
> > > The 'numbers' are in 1000s of bytes per second processed.
> > > type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes
> > > md5              13948.89k    42477.61k   104619.41k   165140.82k   199273.13k
> > > sha1             13091.91k    36463.89k    75393.88k   103893.33k   117104.50k
> > > sha256           13573.92k    30492.25k    52700.33k    64247.81k    68722.69k
> > >
> > > Hardware:
> > > The 'numbers' are in 1000s of bytes per second processed.
> > > type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes
> > > md5               3964.55k    13782.11k    43181.71k   180263.38k  1446616.18k
> > > sha1              4609.16k     8922.35k    35422.87k   333575.31k  2122547.20k
> > > sha256           13519.62k    30484.10k    52547.47k    64285.21k    68530.60k
> 
> Okay, the reason for the difference in SHA256 speed is because the
> "openssl speed" code *totally* *bypasses* the engine support, whereas
> the md5 and sha1 do not.  It even bypasses the normal method used to
> get hold of the sha256 implementation (EVP_sha256), and goes straight
> to using SHA256() directly in openssl/crypto/sha/sha256.c.  It looks
> like the same goes for the AES tests too.

Okay, what's required is openssl speed -evp <cipher|digest> and it can
only do one at a time.  That's really confusing and non-intuitive, given
that some of the non-evp options end up testing the EVP methods.

So, running:

$ openssl speed -evp aes-128-cbc

I get the kernel spitting out a number of these warnings during its run:

DRBG: could not allocate digest TFM handle: hmac(sha512)

I also notice is that 50% of CPU time is spent in the kernel, presumably
because the lack of hardware sha512 means that we end up having to do
sha512 in software in the kernel.

I _also_ notice that despite having the ARM assembly crypto functions
enabled and built-in to the kernel, they don't appear in /proc/crypto -
and this is because of patch 1 in this series, which blocks out any
crypto driver which has a zero statesize (as the ARM crypto functions
appear to have.)  I found this by rebuilding the ARM crypto stuff as
modules, and then trying to insert them:

# modprobe sha512-arm
modprobe: ERROR: could not insert 'sha512_arm': Invalid argument

So, I think it's best if this patch series is *NOT* merged until someone
who knows the kernel crypto code gets to grips with what's supposed to be
done in various parts of the code.  Yes, I know that Herbert suggested
the approach in patch 1, but that _will_ cause regressions like the above
when if it's merged.

Either the ARM crypto code in arch/arm/crypto is buggy, or the approach
in patch 1 is buggy.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
