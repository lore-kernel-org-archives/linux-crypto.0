From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: Fix out-of-bounds access of the AAD
 buffer in generic-gcm-aesni
Date: Wed, 20 Dec 2017 13:12:54 -0800
Message-ID: <20171220211254.GB38504@gmail.com>
References: <20171219221750.34148-1-junaids@google.com>
 <20171220044259.61106-3-junaids@google.com>
 <20171220084210.GC6565@zzz.localdomain>
 <2283674.Cix72tvP9W@js-desktop.svl.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        andreslc@google.com, davem@davemloft.net, gthelen@google.com
To: Junaid Shahid <junaids@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34798 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755607AbdLTVM6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 16:12:58 -0500
Received: by mail-it0-f67.google.com with SMTP id m11so12657142iti.1
        for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2017 13:12:58 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <2283674.Cix72tvP9W@js-desktop.svl.corp.google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 20, 2017 at 11:35:44AM -0800, Junaid Shahid wrote:
> On Wednesday, December 20, 2017 12:42:10 AM PST Eric Biggers wrote:
> > > -_get_AAD_rest0\num_initial_blocks\operation:
> > > -	/* finalize: shift out the extra bytes we read, and align
> > > -	left. since pslldq can only shift by an immediate, we use
> > > -	vpshufb and an array of shuffle masks */
> > > -	movq	   %r12, %r11
> > > -	salq	   $4, %r11
> > > -	movdqu	   aad_shift_arr(%r11), \TMP1
> > > -	PSHUFB_XMM \TMP1, %xmm\i
> > 
> > aad_shift_arr is no longer used, so it should be removed.
> 
> Ack.
> 
> > 
> > > -_get_AAD_rest_final\num_initial_blocks\operation:
> > > +	READ_PARTIAL_BLOCK %r10, %r12, %r11, \TMP1, \TMP2, %xmm\i
> > 
> > It seems that INITIAL_BLOCKS_DEC and INITIAL_BLOCKS_ENC maintain both %r11 and
> > %r12 as the AAD length.  %r11 is used for real earlier, but here %r12 is used
> > for real while %r11 is a temporary register.  Can this be simplified to have the
> > AAD length in %r11 only?
> > 
> 
> We do need both registers, though we could certainly swap their usage to make
> r12 the temp register. The reason we need the second register is because we
> need to keep the original length to perform the pshufb at the end. But, of
> course, that will not be needed anymore if we avoid the pshufb by duplicating
> the _read_last_lt8 block or utilizing pslldq some other way.
> 

If READ_PARTIAL_BLOCK can clobber 'DLEN' that would simplify it even more (no
need for 'TMP1'), but what I am talking about here is how INITIAL_BLOCKS_DEC and
INITIAL_BLOCKS_ENC maintain two copies of the remaining length in lock-step in
r11 and r12:

_get_AAD_blocks\num_initial_blocks\operation:
        movdqu     (%r10), %xmm\i
        PSHUFB_XMM %xmm14, %xmm\i # byte-reflect the AAD data
        pxor       %xmm\i, \XMM2
        GHASH_MUL  \XMM2, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
        add        $16, %r10
        sub        $16, %r12
        sub        $16, %r11
        cmp        $16, %r11
        jge        _get_AAD_blocks\num_initial_blocks\operation

The code which you are replacing with READ_PARTIAL_BLOCK actually needed the two
copies, but now it seems that only one copy is needed, so it can be simplified
by only using r11.

Eric
