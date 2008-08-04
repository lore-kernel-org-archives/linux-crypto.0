From: Austin Zhang <austin_zhang@linux.intel.com>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
Date: Mon, 04 Aug 2008 06:58:01 -0400
Message-ID: <1217847481.20845.37.camel@localhost.localdomain>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <1217844725.3454.580.camel@pmac.infradead.org>
	 <1217846139.20845.25.camel@localhost.localdomain>
	 <1217846726.3454.589.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:63893 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752568AbYHDK7p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 06:59:45 -0400
In-Reply-To: <1217846726.3454.589.camel@pmac.infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2008-08-04 at 11:45 +0100, David Woodhouse wrote:
> Are we deprecating libcrc32c, then? Or just turning it into a wrapper
> around the crypto code?
Maybe I can pick up =EF=BB=BFcrc32c_intel_le_hw_byte and =EF=BB=BFcrc32=
c_intel_le_hw
into=20
one arch-related file and make the current new crypto  interface and
libcrc32c
call it.
> Either way, does it really make sense to force all crc32 users to pul=
l
> in the whole crypto framework? Some may get fractious about that...
If there were really few (or no) user using that previous interface, it=
 will
be reasonable to merge the crc32c totally into crypto subsystem as a
digest method.
And I remembered Herbert had mentioned he will convert those previous
interface=20
calling to new crypto API. For the crc32c, he had done for it.

BTW, why did I always got each email on this thread twice:(? (the same
email twice)=20

--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
