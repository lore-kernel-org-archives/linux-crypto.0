From: arno@natisbad.org (Arnaud Ebalard)
Subject: Re: [PATCH v3b 5/5] crypto: marvell: factor out common import/export functions
Date: Sat, 10 Oct 2015 12:31:29 +0200
Message-ID: <87d1wn2ewu.fsf@natisbad.org>
References: <E1Zkda6-0005Ix-2x@rmk-PC.arm.linux.org.uk>
	<E1Zke3a-00042e-Jx@rmk-PC.arm.linux.org.uk>
	<87oag78y8i.fsf@natisbad.org>
	<20151009235132.GE32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Marek Vasut <marex@denx.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 36.223.133.77.rev.sfr.net ([77.133.223.36]:35839 "EHLO
	smtp.natisbad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbbJJKcG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Oct 2015 06:32:06 -0400
In-Reply-To: <20151009235132.GE32532@n2100.arm.linux.org.uk> (Russell King's
	message of "Sat, 10 Oct 2015 00:51:32 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Russel,

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Sat, Oct 10, 2015 at 12:37:33AM +0200, Arnaud Ebalard wrote:
>> Hi Russel,
>> 
>> Russell King <rmk+kernel@arm.linux.org.uk> writes:
>> 
>> > As all the import functions and export functions are virtually
>> > identical, factor out their common parts into a generic
>> > mv_cesa_ahash_import() and mv_cesa_ahash_export() respectively.  This
>> > performs the actual import or export, and we pass the data pointers and
>> > length into these functions.
>> >
>> > We have to switch a % const operation to do_div() in the common import
>> > function to avoid provoking gcc to use the expensive 64-bit by 64-bit
>> > modulus operation.
>> >
>> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
>> 
>> Thanks for the refactoring and for the fixes. All patches look good to 
>> me. Out of curiosity, can I ask what perf you get w/ openssh or openssl
>> using AF_ALG and the CESA?
>
> I would do, but it seems this AF_ALG plugin for openssl isn't
> actually using it for encryption.  When I try:
>
> 	openssl speed -engine af_alg aes-128-cbc
>
> I get results for using openssl's software implementation.  If I do:
>
> 	openssl speed -engine af_alg md5
>
> then I get results from using the kernel's MD5.  Hence, I think the
> only thing that I think openssh is using it for is the digest stuff,
> not the crypto itself.  I can't be certain about that though.
>
> I've tried debugging the af_alg engine plugin, but I'm not getting
> very far (I'm not an openssl hacker!)  I see it registering the
> function to get the ciphers (via ENGINE_set_ciphers), and I see this
> called several times, returning a list of NID_xxx values describing
> the methods it supports, which includes aes-128-cbc.  However,
> unlike the equivalent digest function, I never see it called
> requesting any of the ciphers.  Maybe it's an openssl bug, or a
> "feature" preventing hardware crypto?  Maybe something is missing
> from its initialisation?  I've no idea yet.  It seems I'm not alone
> in this - this report from April 2015 is exactly what I'm seeing:
>
> https://mta.openssl.org/pipermail/openssl-users/2015-April/001124.html
>
> However, I'm coming to the conclusion that AF_ALG with openssl is a
> dead project, and the only interface that everyone is using for that
> is cryptodev - probably contary to Herbert and/or DaveM's wishes.  For
> example, the openwrt guys seem to only support cryptodev, according to
> their wiki page on the subject of hardware crypto:
>
> http://wiki.openwrt.org/doc/hardware/cryptographic.hardware.accelerators
>
> Here's the references to code for AF_ALG with openssl I've found so far:
>
> Original af_alg plugin (dead):
>
> http://src.carnivore.it/users/common/af_alg/
>
> 3rd party "maintained" af_alg openssl plugin, derived from commit
> 1851bbb010c38878c83729be844f168192059189 in the above repo but with
> no history:
>
> https://github.com/RidgeRun/af-alg-rr
>
> and that doesn't contain any changes to the C code originally committed.
> Whether this C code contains changes or not is anyone's guess: there's
> no way to refer back to the original repository.
>
> Anyway, here's the digest results:
>
> Software:
> The 'numbers' are in 1000s of bytes per second processed.
> type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes
> md5              13948.89k    42477.61k   104619.41k   165140.82k   199273.13k
> sha1             13091.91k    36463.89k    75393.88k   103893.33k   117104.50k
> sha256           13573.92k    30492.25k    52700.33k    64247.81k    68722.69k
>
> Hardware:
> The 'numbers' are in 1000s of bytes per second processed.
> type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes
> md5               3964.55k    13782.11k    43181.71k   180263.38k  1446616.18k
> sha1              4609.16k     8922.35k    35422.87k   333575.31k  2122547.20k
> sha256           13519.62k    30484.10k    52547.47k    64285.21k    68530.60k
>
> There's actually something suspicious while running these tests:
>
> Doing md5 for 3s on 16 size blocks: 32212 md5's in 0.13s
> Doing md5 for 3s on 64 size blocks: 23688 md5's in 0.11s
> Doing md5 for 3s on 256 size blocks: 23615 md5's in 0.14s
> Doing md5 for 3s on 1024 size blocks: 22885 md5's in 0.13s
> Doing md5 for 3s on 8192 size blocks: 15893 md5's in 0.09s
> Doing sha1 for 3s on 16 size blocks: 31688 sha1's in 0.11s
> Doing sha1 for 3s on 64 size blocks: 23700 sha1's in 0.17s
> Doing sha1 for 3s on 256 size blocks: 23523 sha1's in 0.17s
> Doing sha1 for 3s on 1024 size blocks: 22803 sha1's in 0.07s
> Doing sha1 for 3s on 8192 size blocks: 15546 sha1's in 0.06s
> Doing sha256 for 3s on 16 size blocks: 2518030 sha256's in 2.98s
> Doing sha256 for 3s on 64 size blocks: 1419416 sha256's in 2.98s
> Doing sha256 for 3s on 256 size blocks: 613738 sha256's in 2.99s
> Doing sha256 for 3s on 1024 size blocks: 187080 sha256's in 2.98s
> Doing sha256 for 3s on 8192 size blocks: 25013 sha256's in 2.99s
>
> from the hardware - note the "in" figures are rediculously low, yet
> they do wait 3s for each test.  Also, the sha256 results are close
> enough to being the software version.
>
> No ideas on any of this yet... but I'm not about to start digging in
> the openssl code to try and work out what it's up to.  As I say, I
> think this is AF_ALG with openssl is a dead project.

Thanks for the time you took to assemble the information in previous 
email. Yesterday, when reading your patches, I ended up on [1], where
Marek (added him to Cc: list) basically has the same kind of conclusion
as yours, i.e. openssl w/ cryptodev is what currently works better even
if AF_ALG is the expected target for kernel to provide access to
hardware engines to userland apps.

I had a lot of performance results at various levels (tcrypt module on
variations of the drivers (tasklet, threaded irq, full polling, etc),
IPsec tunnel and transport mode through to see how it behaves w/ two
mvneta instances also eating CPU cycles for incoming/outgoing packets)
but those where done on an encryption use case. Some are provided
in [2]. In an early (read dirty) polling-based version of the driver,
the CESA on an Armada 370 (mirabox) was verified to be capable of near
100MB/s on buffers of 1500+ bytes for AES CBC encryption. Current
version of the driver is not as good (say half that value) but it
behaves better. A Mirabox can easily route 1500 bytes packets at 100MB/s
between its two interfaces but when you mix both using IPsec in tunnel
mode on one side, you end up w/ perfs between 10 to 15MB/s, IIRC. I
think it's interesting to see where it ends up w/ the engine exposed to
userland consumers (e.g. sth like SSH).

I cannot promise a huge amount of time but I'll try and find some to
play w/ AF_ALG using openssl and CESA in the coming weeks.

Cheers,

a+

[1]: http://events.linuxfoundation.org/sites/events/files/slides/lcj-2014-crypto-user.pdf
[2]: http://lists.infradead.org/pipermail/linux-arm-kernel/2015-April/336599.html
