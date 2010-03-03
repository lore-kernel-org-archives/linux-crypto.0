From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: hmac(sha1)
Date: Wed, 3 Mar 2010 16:59:01 -0600
Message-ID: <20100303165901.df36c9ca.kim.phillips@freescale.com>
References: <4B8DD78D.6080707@siganos.org>
	<4B8EC3C0.60502@siganos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Dimitrios Siganos <dimitris@siganos.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:56919 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab0CCWyr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Mar 2010 17:54:47 -0500
Received: from de01smr02.am.mot.com (de01smr02.freescale.net [10.208.0.151])
	by az33egw02.freescale.net (8.14.3/az33egw02) with ESMTP id o23Msadk023838
	for <linux-crypto@vger.kernel.org>; Wed, 3 Mar 2010 15:54:36 -0700 (MST)
Received: from az33exm22.fsl.freescale.net (az33exm22.am.freescale.net [10.64.32.10])
	by de01smr02.am.mot.com (8.13.1/8.13.0) with ESMTP id o23N2g3T010852
	for <linux-crypto@vger.kernel.org>; Wed, 3 Mar 2010 17:02:43 -0600 (CST)
In-Reply-To: <4B8EC3C0.60502@siganos.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 3 Mar 2010 20:17:04 +0000
Dimitrios Siganos <dimitris@siganos.org> wrote:

> Dimitrios Siganos wrote:
> > Hi,
> >
> > I am trying to write a hmac(sha1) algorithm and I have a few 
> > questions. I have a HW crypto accelerator that does the actual crypto 
> > work. I have already successfully implemented sha1 by creating a 
> > CRYPTO_ALG_TYPE_DIGEST algorithm.
> >
> > 1) Can I implement hmac(sha1) as a CRYPTO_ALG_TYPE_DIGEST algorithm 
> > (i.e. use very similar code to sha1)?
> >
> > 2) Do I need to create a CRYPTO_ALG_TYPE_HASH algorithm?
> >
> > 3) Is it possible to implement hmac(sha1) as both 
> > CRYPTO_ALG_TYPE_DIGEST and CRYPTO_ALG_TYPE_HASH?
> >
> > 4) If I use a CRYPTO_ALG_TYPE_HASH, I need to understand the 
> > scatterwalk api, is there any help on the subject?
> >
> The answer to 1) is yes because I just did it and seems to work. 
> Therefore the answer is to 2) is: No, it is not needed.
> 
> I believe the answer to 3) is: yes. I believe it is possible to 
> implement hmac(sha1) as both CRYPTO_ALG_TYPE_DIGEST and 
> CRYPTO_ALG_TYPE_HASH.
> 
> I would like to implement hmac(sha1) as a CRYPTO_ALG_TYPE_HASH but I do 
> yet understand how to convert the scatterlists into virtual addresses. 
> The HW crypto api that I use, hides the DMA details from me and expects 
> me to pass it virtual addresses only. I can't see any examples of 
> converting scatterlists to virtual addresses in a way that is safe for 
> IPsec use (i.e. safe to be called from softirq context). Any help on 
> this will be appreciated.

not sure I understand; scatterlists come populated with virtual
addresses at the driver entry point (e.g. aead_givencrypt).  talitos
uses a combination of dma_map_sg and sg_dma_address to map the list of
virt. addresses into dma-able addresses (because that's what the h/w
wants).

the sg_virt helper fn should be used to extract the virtual address
of each sg entry, which sounds like what you want in your case.

> The ultimate goal of the project is to implement a authenc(hmac(sha1), 
> cbc(aes)) algorithm (for IPsec use) that will offload the work to a HW 
> crypto chip. In order to understand what I am doing, I am building 
> slowly upwards. I have build aes as a CIPHER, cbc(aes) as a BLKCIPHER, 
> sha1 as a digest and hmac(sha1) as a digest.
> 
> My next steps are to implement cbc(aes) using ABLKCIPHER and hmac(sha1) 
> using HASH and AHASH. I am using linux version 2.6.28. I can see that 
> the talitos driver implements algorithms at the authenc level but I 
> don't completely understand the driver and I am hoping that after going 
> through the exercise of building the smaller blocks I will understand 
> the operation of the talitos driver.

for talitos, the hardware does the cipher+hash in one go (via in-
and out-snooping between the execution units), so it's more optimal
than splitting it into two separate operations - the only downside is
that talitos doesn't currently support IPsec AH.  wrt the crypto api,
the main difference is that the aead request comes as an overlapping
cipher and hash request.

> Any help, especially pointers to relevant documentation or examples, 
> will be appreciated.

wrt sg: Documentation/DMA-API.txt, lib/scatterlist.c,
arch/$ARCH/include/asm/scatterlist.h

wrt authenc/aead request offsets:
http://unixwiz.net/techtips/iguide-ipsec.html

Kim
