From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH v2 0/3] Cavium ThunderX ZIP driver
Date: Thu, 9 Mar 2017 18:46:54 +0800
Message-ID: <20170309104654.GD7185@gondor.apana.org.au>
References: <1487135710-9692-1-git-send-email-Mahipal.Challa@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan.Glauber@cavium.com,
        Vishnu.Nair@cavium.com, pathreya@cavium.com,
        Mahipal.Challa@cavium.com
To: Mahipal Challa <mahipalreddy2006@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487135710-9692-1-git-send-email-Mahipal.Challa@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 15, 2017 at 10:45:07AM +0530, Mahipal Challa wrote:
> Hi Herbert,
> 
> This series adds support for hardware accelerated compression & decompression
> as found on ThunderX (arm64) SOCs.
> 
> As per your suggestion, we've switched to the new crypto acomp/scomp interface.
> 
> To test the ZIP driver, we modified the kernel's ZSWAP to use acomp API's.
> 
> Performance numbers from ZSWAP look promising.
> The "average time" for compressing a 4KB page:
> 
> Compression Software    : 278 usec
> Compression HW deflate  :  17 usec
> Compression HW LZS      :  11 usec
> 
> Decompression Software  : 20 usec
> Decompression HW deflate:  8 usec
> Decompression HW LZS    :  6 usec
> 
> Addressed the review comments from the RFC v1.
>  - Added acomp/scomp crypto interface support.
>  - Improved the error handling.
>  - ZIP command completion codes are renamed suitably.
>  - Removed some un-used code.
>  - raw_smp_processor_id() replaced with smp_processor_id().
>  - Some more miscellaneous changes. 
> 
> Patches are on top of "kernel/git/herbert/crypto-2.6.git" repository
> 
> Please provide your feedback.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
