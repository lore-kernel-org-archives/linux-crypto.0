Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022063845D1;
	Fri, 13 Mar 2026 09:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773393535; cv=none; b=megmL0TIHrBtGe+qbJ/1zyIYdxNmTc5OWC+zILpwwzfHsyN7s0KFjVI1RqTu+SntwuV3QLOs+BGW+Ba6nOSsrFNKAtH66Fzvh5Ayg1eKJ+7KQEBSwn/ZeYFZZOrERRvuRcOgYbFXXLssL4hlS0xyEELQJm4w4y8fzCOTpDQddN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773393535; c=relaxed/simple;
	bh=Ew/61NN7RIZyr8s2Meq1/Hx2cAxVhcwSsHUlA2bXw9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUNzHmwxHNl9XO1tvtFhqFqNH/fz8JEAmy4YqyKbx8KeTjBOnr347CeNwjk3FsETxUrcFixhyKS54zSDHRElm0CNDXz621FsYhae4RvGb+4W7YuZE+yGVHgCRx3X/7v7ewJ6yfycCtxcTvp4VHIWGQIamWevtlS+u4y66luE6Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id 08AF02020219;
	Fri, 13 Mar 2026 10:18:43 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id E200F16917; Fri, 13 Mar 2026 10:18:42 +0100 (CET)
Date: Fri, 13 Mar 2026 10:18:42 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Kepplinger-Novakovic Martin <Martin.Kepplinger-Novakovic@ginzinger.com>
Cc: "ebiggers@google.com" <ebiggers@google.com>,
	"horia.geanta@nxp.com" <horia.geanta@nxp.com>,
	"pankaj.gupta@nxp.com" <pankaj.gupta@nxp.com>,
	"gaurav.jain@nxp.com" <gaurav.jain@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"ignat@cloudflare.com" <ignat@cloudflare.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] crypto: caam - RSA encrypt doesn't always complete new
 data in out_buf
Message-ID: <abPWcqeDo549UhIk@wunner.de>
References: <aZ296wd7fLE6X3-U@wunner.de>
 <e1d7ad1106dbb259f7c61bdd1910ac9f08012725.camel@ginzinger.com>
 <aZ3Uqaec79TUrP2I@wunner.de>
 <e36dd6fa756015ec1f2a16002fabfa941c33d367.camel@ginzinger.com>
 <aZ6vF1CHpcp5d5qk@wunner.de>
 <5f9c1e7ec61065a2665a2ec70338e05e551435d4.camel@ginzinger.com>
 <aZ_zfnKVnTaG_4bk@wunner.de>
 <1a65ac92579fadb4bfc76b32a3a4f1c6df022801.camel@ginzinger.com>
 <aaBKWqY57OSxhx7q@wunner.de>
 <c5a24c835d09d759e555070f7a6f6b4f55d2dddc.camel@ginzinger.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5a24c835d09d759e555070f7a6f6b4f55d2dddc.camel@ginzinger.com>

On Tue, Mar 10, 2026 at 08:57:36AM +0000, Kepplinger-Novakovic Martin wrote:
> Am Donnerstag, dem 26.02.2026 um 14:27 +0100 schrieb Lukas Wunner:
> > There's an endianness issue here:  30313000 is the zero byte prescribed
> > by EMSA-PKCS1-v1_5 ("in_buf[ps_end] = 0x00;" in rsassa_pkcs1_sign()),
> > followed by the first three bytes of hash_prefix_sha256[] in reverse order.
> > 
> > Then 6009060d are the next four bytes of hash_prefix_sha256[], again
> > in reverse order.  And so on until 20040005, which are the last four
> > bytes of the prefix in reverse order.
> > 
> > How are you generating that hexdump?  What's the CPU's endianness?
> > Is the caam RSA accelerator using a different endianness?
> 
> imx6ul is armv7, little endian byte order and the following returns 1
> which supports that:
> echo -n I | od -o | head -n1 | cut -f2 -d" " | cut -c6

Please double-check whether your .config enables CONFIG_CPU_BIG_ENDIAN
or CONFIG_CPU_LITTLE_ENDIAN, just to cover all bases.

> I always print the hex dump in the following way (here "out_buf" at line
> https://elixir.bootlin.com/linux/v6.19.6/source/crypto/rsassa-pkcs1.c#L247 )
> print_hex_dump(KERN_ERR, "out_buf1:", DUMP_PREFIX_OFFSET, 16, 4, out_buf, 32, true);

Please use 1 instead of 4 as 5th parameter of print_hex_dump().
Using 4 only makes sense if the memory location you want to dump
contains 32-bit values.  That's not the case here as the signature
is a bytestream.

I guess if you use 4, print_hex_dump() dumps the 32-bit values
in big endian order for human readability, but that's confusing
if the memory location actually contains a bytestream.

> Again, with this revert, the problem seems to be the same, only that
> the data that rsassa_pkcs1_verify() is starting to check here
> https://elixir.bootlin.com/linux/v6.19.6/source/crypto/rsassa-pkcs1.c#L266
> is still "old" but now zeroes, not the input-data, thus failing with
> -EBADMSG instead of -EINVAL.

Actually the "out_buf2" that you've included in this message...

https://lore.kernel.org/all/1a65ac92579fadb4bfc76b32a3a4f1c6df022801.camel@ginzinger.com/

...looks like a valid verified (i.e. encrypted) signature,
the only thing that's weird is the endianness issue and
that there's a bunch of zero bytes at the beginning of
the buffer.

Please re-generate the hexdump of "out_buf" after the call
to crypto_wait_req(), once with a stock kernel and once with
8552cb04e083 reverted, and use 1 as 5th argument to
print_hex_dump().

Thanks,

Lukas
