From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Hardware crypto accelerator for IPSec
Date: Thu, 5 Nov 2009 11:41:14 -0500
Message-ID: <20091105164114.GA8972@gondor.apana.org.au>
References: <b3f13ff80911042352u5c54c8fbs2662ac9bd810bdf8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Hamid Nassiby <h.nassiby@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38483 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751885AbZKEQlL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Nov 2009 11:41:11 -0500
Content-Disposition: inline
In-Reply-To: <b3f13ff80911042352u5c54c8fbs2662ac9bd810bdf8@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 05, 2009 at 11:22:52AM +0330, Hamid Nassiby wrote:
> Hi,
> 
> In a research project, I want to offload the encryption process of IPSec to
> one hardware-based crypto accelerator , which is implemented by a Xilinx
> virtex5 FPGA.
> The most noticeable question arises here is about the best location of
> catching the IPSec packets from their path.( Then getting them to the
> hardware accelerator  for encryption process and finally returning them back
> to the path they were going .)
> 
> I guess that the location of departure must be in esp4.c or aead.c and maybe
> authenc.c; But as I said I only GUESS, and I need help . Any recommendation
> would be pleased .

Please take a look at drivers/crypto/talitos.c.  That shows
how you can hook into the system.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
