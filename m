From: Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 2/2] crypto: Fix out-of-bounds access of the AAD buffer in generic-gcm-aesni
Date: Wed, 20 Dec 2017 11:35:44 -0800
Message-ID: <2283674.Cix72tvP9W@js-desktop.svl.corp.google.com>
References: <20171219221750.34148-1-junaids@google.com> <20171220044259.61106-3-junaids@google.com> <20171220084210.GC6565@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        andreslc@google.com, davem@davemloft.net, gthelen@google.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:39508 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755534AbdLTTfr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 14:35:47 -0500
Received: by mail-it0-f42.google.com with SMTP id 68so8118280ite.4
        for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2017 11:35:47 -0800 (PST)
In-Reply-To: <20171220084210.GC6565@zzz.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, December 20, 2017 12:42:10 AM PST Eric Biggers wrote:
> > -_get_AAD_rest0\num_initial_blocks\operation:
> > -	/* finalize: shift out the extra bytes we read, and align
> > -	left. since pslldq can only shift by an immediate, we use
> > -	vpshufb and an array of shuffle masks */
> > -	movq	   %r12, %r11
> > -	salq	   $4, %r11
> > -	movdqu	   aad_shift_arr(%r11), \TMP1
> > -	PSHUFB_XMM \TMP1, %xmm\i
> 
> aad_shift_arr is no longer used, so it should be removed.

Ack.

> 
> > -_get_AAD_rest_final\num_initial_blocks\operation:
> > +	READ_PARTIAL_BLOCK %r10, %r12, %r11, \TMP1, \TMP2, %xmm\i
> 
> It seems that INITIAL_BLOCKS_DEC and INITIAL_BLOCKS_ENC maintain both %r11 and
> %r12 as the AAD length.  %r11 is used for real earlier, but here %r12 is used
> for real while %r11 is a temporary register.  Can this be simplified to have the
> AAD length in %r11 only?
> 

We do need both registers, though we could certainly swap their usage to make r12 the temp register. The reason we need the second register is because we need to keep the original length to perform the pshufb at the end. But, of course, that will not be needed anymore if we avoid the pshufb by duplicating the _read_last_lt8 block or utilizing pslldq some other way.

Thanks,
Junaid
