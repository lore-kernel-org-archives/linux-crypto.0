From: Ruggero SUSELLA <ruggero.susella@st.com>
Subject: RE: [PATCH 1/1] arm/crypto: Add optimized AES and SHA1 routines
Date: Mon, 8 Oct 2012 16:24:23 +0200
Message-ID: <E7C3A19B6E9F994EB4D796DB533BD7F5B9184896D8@SAFEX1MAIL3.st.com>
References: <20120807020103.GA21410@mcafee.com>
 <20120906202024.GB24269@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	David McCullough <david_mccullough@mcafee.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:51540 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752229Ab2JHOYw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Oct 2012 10:24:52 -0400
In-Reply-To: <20120906202024.GB24269@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Is this code compatible with GPL ?

To me it looks like it falls under the OpenSSL license which, accordingly to Wikipedia, is not compatible with GPL.
Where am I wrong ?

Best Regards,
Ruggero

-----Original Message-----
From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Herbert Xu
Sent: Thursday, September 06, 2012 10:20 PM
To: David McCullough
Cc: linux-kernel@vger.kernel.org; linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/1] arm/crypto: Add optimized AES and SHA1 routines

On Tue, Aug 07, 2012 at 02:01:03AM +0000, David McCullough wrote:
> 
> Add assembler versions of AES and SHA1 for ARM platforms.  This has 
> provided up to a 50% improvement in IPsec/TCP throughout for tunnels using AES128/SHA1.
> 
> Platform   CPU SPeed    Endian   Before (bps)   After (bps)   Improvement 
> 
> IXP425      533 MHz      big     11217042        15566294        ~38%
> KS8695      166 MHz     little    3828549         5795373        ~51%
> 
> Signed-off-by: David McCullough <ucdevel@gmail.com>

Patch applied.  Thanks!
--
Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
