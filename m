From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 1/4] crypto: dh - fix double free of ctx->p
Date: Thu, 2 Nov 2017 10:30:01 -0700
Message-ID: <20171102173001.GA23035@gmail.com>
References: <20171101222517.41602-1-ebiggers3@gmail.com>
 <20171101222517.41602-2-ebiggers3@gmail.com>
 <93501fc6-94df-bf27-cdd8-7a44b04effc1@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        keyrings@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:54329 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754138AbdKBRaF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Nov 2017 13:30:05 -0400
Content-Disposition: inline
In-Reply-To: <93501fc6-94df-bf27-cdd8-7a44b04effc1@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tudor,

On Thu, Nov 02, 2017 at 12:55:56PM +0200, Tudor Ambarus wrote:
> Hi, Eric,
> 
> On 11/02/2017 12:25 AM, Eric Biggers wrote:
> >When setting the secret with the software Diffie-Hellman implementation,
> >if allocating 'g' failed (e.g. if it was longer than
> >MAX_EXTERN_MPI_BITS), then 'p' was freed twice: once immediately, and
> >once later when the crypto_kpp tfm was destroyed.  Fix it by using
> >dh_free_ctx() in the error paths, as that sets the pointers to NULL.
> 
> Other solution would be to have just an one-line patch that sets p to
> NULL after freeing it. The benefit of just setting p to NULL and not
> using dh_free_ctx() is that you'll spare some cpu cycles. If g fails,
> g and a will already be NULL, so freeing them and set them to NULL is
> redundant.
> 
> However, if you decide to always use dh_free_ctx(), you'll have to get
> rid of dh_clear_params(), because it will be used just in dh_free_ctx().
> You can copy dh_clear_params() body to dh_free_ctx().
> 

This is on an error path, so a few cycles don't matter.  I would much rather
have the simpler code, with less chance to introduce exploitable bugs.

Yes, I should inline dh_clear_params() into dh_free_ctx().

Eric
