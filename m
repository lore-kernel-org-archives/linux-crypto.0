From: Uri Simchoni <uri@jdland.co.il>
Subject: Re: RFC: kcrypto - (yet another) user space interface
Date: Sat, 12 Jun 2010 19:40:27 +0300
Message-ID: <4C13B87B.9050704@jdland.co.il>
References: <20100610182237.1B48E4CD45@orbit.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www011.intervision.co.il ([80.244.168.31]:48571 "EHLO
	www011.intervision.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab0FLQrW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Jun 2010 12:47:22 -0400
In-Reply-To: <20100610182237.1B48E4CD45@orbit.nwl.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Phil,

Note on  implementation: I see that you're using the synchronous (blkcipher) interface and not the async (ablkcipher) one. I'm not 100% sure about this, but it appears to me that you can't utilize async HW drivers this way (there's adapter code from async client to sync driver but not the other way around).

With regards to interface, I don't know enough to comment about the proposed alternatives, but the use of write() and read() appears problematic - it looks inconsistent with the semantics of write() in that the user must not modify the buffer after write() - it looks like aio semantics but without the aio interface.

With regards to mmap preventing zero copy - In many cases you can assemble the things you want to crypt in the mmap buffer upfront. Still in other cases you need to copy the data at least once anyway, so you might as well start off by copying to the mmap area. Taking TLS as an example - you have to build a TLS record before you can encrypt/hash it. The header is poorly aligned and there's the padding at the end - there seems to be no escaping copying it once inside the TLS library. You may place your record buffers in the mmap area. So I guess what I'm saying is that the mmap approach doesn't break interface semantics, and in most important cases can be used to provide a solution that's as good as the zero-copy one.

Just my 2c,
Uri

On 6/10/2010 9:22 PM, Phil Sutter wrote:
> Hello everyone,
> 
> my employer wants to have a lightweight, zero-copy user space interface
> to the Crypto-API and I *think* I'm on the right way to realising this.
> 
> What I've got so far is just a proof-of-concept, tested only with
> cbc(aes), merely as generic as I'd like it to be, but with zero-copy of
> the actual data buffers (which reside in user space) and asynchronous
> operation.
> 
> You can check it out via git://nwl.cc/~n0-1/kcrypto.git or simply have a
> look at http://nwl.cc/cgi-bin/git/gitweb.cgi?p=kcrypto.git;a=summary. If
> you do so, you may in return flame me as much as you like to. :)
> 
> I know that it's far from being ready for use as the sole crypto API
> user space interface, but I'm convinced as well that it will never be
> unless someone with Crypto-API skills points out at least the very basic
> design flaws I've already created.
> 
> As this is not yet being used in production (of course), I'm totally
> open to changes. So taking this as start of a collaborative project
> would be perfect for me, too.
> 
> Greetings (and sorry for yet another interface approach),
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
