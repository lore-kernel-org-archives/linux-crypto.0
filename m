From: David McCullough <david_mccullough@mcafee.com>
Subject: Re: [PATCH 1/1] arm/crypto: Add optimized AES and SHA1 routines
Date: Tue, 9 Oct 2012 07:00:22 +1000
Message-ID: <20121008210022.GA15013@mcafee.com>
References: <20120807020103.GA21410@mcafee.com>
 <20120906202024.GB24269@gondor.apana.org.au>
 <E7C3A19B6E9F994EB4D796DB533BD7F5B9184896D8@SAFEX1MAIL3.st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Ruggero SUSELLA <ruggero.susella@st.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dnvwsmailout1.mcafee.com ([161.69.31.173]:49029 "EHLO
	DNVWSMAILOUT1.mcafee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2JHVAr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Oct 2012 17:00:47 -0400
Content-Disposition: inline
In-Reply-To: <E7C3A19B6E9F994EB4D796DB533BD7F5B9184896D8@SAFEX1MAIL3.st.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Jivin Ruggero SUSELLA lays it down ...
> Is this code compatible with GPL ?
> 
> To me it looks like it falls under the OpenSSL license which, accordingly to Wikipedia, is not compatible with GPL.
> Where am I wrong ?

The license on the 2 asm files from openssl the explicitly states:

	@ ====================================================================
	@ Written by Andy Polyakov <appro@fy.chalmers.se> for the OpenSSL
	@ project. The module is, however, dual licensed under OpenSSL and
	@ CRYPTOGAMS licenses depending on where you obtain it. For further
	@ details see http://www.openssl.org/~appro/cryptogams/.
	@ ====================================================================

If you follow the URL for the CRYPTOGAMS license and read the actual license
at the end of the file it is very clearly dual licensed.  So I think it is
ok :-)

Cheers,
Davidm

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Herbert Xu
> Sent: Thursday, September 06, 2012 10:20 PM
> To: David McCullough
> Cc: linux-kernel@vger.kernel.org; linux-crypto@vger.kernel.org
> Subject: Re: [PATCH 1/1] arm/crypto: Add optimized AES and SHA1 routines
> 
> On Tue, Aug 07, 2012 at 02:01:03AM +0000, David McCullough wrote:
> > 
> > Add assembler versions of AES and SHA1 for ARM platforms.  This has 
> > provided up to a 50% improvement in IPsec/TCP throughout for tunnels using AES128/SHA1.
> > 
> > Platform   CPU SPeed    Endian   Before (bps)   After (bps)   Improvement 
> > 
> > IXP425      533 MHz      big     11217042        15566294        ~38%
> > KS8695      166 MHz     little    3828549         5795373        ~51%
> > 
> > Signed-off-by: David McCullough <ucdevel@gmail.com>
> 
> Patch applied.  Thanks!
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
David McCullough,      david_mccullough@mcafee.com,  Ph:+61 734352815
McAfee - SnapGear      http://www.mcafee.com         http://www.uCdot.org
