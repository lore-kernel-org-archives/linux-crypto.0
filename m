From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Counter Size in CTR mode for AES Driver
Date: Sat, 11 Apr 2015 22:42:47 +0200
Message-ID: <1972934.BfLcYekyhv@tachyon.chronox.de>
References: <CAHTT9V+VXHYMc1Nkc9hh0Ew7nZy28zTc=rip4op-+BvC80MsTw@mail.gmail.com> <3837185.yfoG22Ljkb@tachyon.chronox.de> <CAHTT9VKt_uWGWuRcUQR98T-Z_MWC2ovZBxJNQiH+NOMmezfOuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: sri sowj <srisowj4linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34117 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbbDKUmt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 11 Apr 2015 16:42:49 -0400
In-Reply-To: <CAHTT9VKt_uWGWuRcUQR98T-Z_MWC2ovZBxJNQiH+NOMmezfOuA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 11. April 2015, 09:07:35 schrieb sri sowj:

Hi sri,

> Hi Stephen,
> 
> Thanks a million for the information provided. I really appreciate
> your time and efforts.
> 
> In CTR mode counter size is not fixed , it varies based on
> requirements like for rfc 3686 its size is 4 bytes, for other "CTR
> Mode" operations it is 8/16 bytes. So how does linux crypto HW drivers
> like nx-aes-ctr.c or omap-aes.c etc handles these variations?

Without having looked at those implementations, I guess that they simply 
implement ctr(aes). That means that they simply have a counter value of 128 
bit (to match the requirement that the IV must be block size). Then they 
simply increment them.

Now, the logic of the kernel crypto API kicks in: there is the rfc3686 
template in ctr.c. Thus, when you use rfc3686(ctr(aes)), you get that 
particular logic where the counter is interpreted in a special way and thus 
set up accordingly.

Now, the rfc3686 now provides a very particular interpretation of the IV -- 
i.e. this one initializes it as needed (in .fact, it uses seqiv as initialized 
in  crypto_rfc3686_alloc). After creating the IV based on a particular 
requirement, this template simply invokes ctr(aes) which simply increments the 
given IV/counter value. Then at some point, rfc3686 takes over again where the 
IV is again massaged as needed.

As we have segiv, the full power of rfc3686 can only be used by the caller 
when using the skcipher_givcrypt_* APi from include/crypto/skcipher.h. For an 
example, check the esp_output function that uses the AEAD version of the 
givcrypt API. I drew a picture in [1] that illustrates the structure a bit 
more.

[1] http://www.chronox.de/crypto-API/ch02s07.html

(the rfc3686 is logically very similar)

> 
> In CTR mode nonce and counters plays a significant role while

Before continuing, you need to detach yourself from thinking of the counter 
value in form of 4/8/16 byte nonces or other values. The "raw" counter is 
blocksize, period. Now, some code may get an initial value of 4/8/16 bytes (or 
whatever size). Now, that implementation must do its magic to transform that 
input into block size before performing the CTR operation with the underlying 
block cipher.

> performing encryption or decryption? ,So I am trying to understand
> these aspect from linux kernel driver aspects where crypto H/W engine
> is present.

The crypto HW implementations may or may not implement the specialities 
mentioned above. That is the true power of the crypto API: every part 
inside/outside the parantheses can be implemented in independent components or 
in joint components. The kernel crypto API selects the right implementation 
based on the cra_priority.

For example, the rfc4106 template has the same issue for GCM as rfc3686 for 
the CTR mode. And rfc4106 is implemented in the HW implementation for AES-NI 
(see arch/x86/crypto/aesni_intel-glue.c) as well as in pure C (see gcm.c). 
Other HW implementations of AES or GCM may not implement rfc4106 -- they would 
use the C version as fallback (the API does that transparently based on the 
cra_priority and registered implementations). So, there is a full freedom 
available what HW can implement or wants to provide as usually there is always 
a software "fallback" present.
> 
> from the user it might be possible to get request consisting the
> counter size of 4 or 8 or 16 bytes.There has to be a way to deal these

The user can never request sizes of a counter used for encryptions. All 
implementations will eventually align the initial counter values (which may be 
given by the caller) to a blocksize boundary. Otherwise, the math will not 
work. Thus a caller may provide some initial value (depending on the chosen 
implementation) which is then somehow padded/aligned/massaged to block size.

> variations from linux kernel crypto subsystem , but i am finding
> little hard time to understand this.
> 
> Just to give a thought, is it possible  to find size of these fields
> like nonce or counter from IV size ?

Either I do not understand this remark, our based on the description above, 
you see that this question is not applicable.
> 
> BR,
> Srisowj
> 
> On Sat, Apr 11, 2015 at 2:21 AM, Stephan Mueller <smueller@chronox.de> 
wrote:
> > Am Samstag, 11. April 2015, 00:30:30 schrieb sri sowj:
> > 
> > Hi sri,
> > 
> >> Hi All,
> >> 
> >> I have seen multiple open source drivers for AES(CTR) mode for
> >> different Crypto Hardware Engines, I was not really sure on
> >> countersize,nonce etc.
> >> Please can any one provide some info on the following
> >> 
> >> #1:How does AES driver identifies the counter size during the CTR mode
> >> of operation?
> > 
> > I am not sure about the question, but the block chaining mode is
> > orthogonal to the block cipher.
> > 
> > Thus, the block cipher does not need to know of the counter size of CTR.
> > That applies to any block chaining mode.
> > 
> >> looks like AES in CTR mode supports "countersize" of multiple lengths as
> > 
> > below:
> >> >>1: First is a counter which is made up of a nonce and counter. The
> >> >>nonce
> >> >>is random, and the remaining bytes are counter bytes (which are
> >> >>incremented).
> >>  
> >>  For example, a 16 byte block cipher might use the high 8 bytes as a
> >> 
> >> nonce, and the low 8 bytes as a counter.
> >> 
> >> >>2: Second is a counter block, where all bytes are counter bytes and can
> >> >>be
> >> >>incremented as carries are generated.
> >>  
> >>  For example, in a 16 byte block cipher, all 16 bytes are counter bytes
> >> 
> >> #2: Does Linux Kernel Crypto subsystem increments the counter value
> >> for every block of input or is it needs tp be taken care by Kernel
> >> Driver for the respective Crypto H/W ?
> > 
> > This depends on your choice -- the kernel crypto API provides crypto_inc()
> > for the increment, it provides the ctr template to wrap a block chaining
> > mode. The kernel crypto API does not restrict, it enables you.
> > 
> >> #3:counters and nonces are something which will be extracted from the
> >> IV i.e., IV = nonce + counter
> >> Note if "l" is length of IV then first "l/2" is length of nonce and
> >> next "l/2" is length of counter.
> > 
> > What you describe may be on e convention. But the ctr.c template
> > initializes the counter value to 0 during init time. So, you see that
> > there is no hard fact. The counter is in fact just an IV.
> > 
> >> Any information regarding the above is really appreciable.
> >> 
> >> BR,
> >> SriSowj
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-crypto"
> >> in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > --
> > Ciao
> > Stephan


-- 
Ciao
Stephan
