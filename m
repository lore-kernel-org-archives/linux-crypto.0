From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v2 1/2] crypto: Fix out-of-bounds access of the data
 buffer in generic-gcm-aesni
Date: Wed, 20 Dec 2017 13:05:20 -0800
Message-ID: <20171220210520.GA38504@gmail.com>
References: <20171219221750.34148-1-junaids@google.com>
 <20171220044259.61106-2-junaids@google.com>
 <20171220083616.GB6565@zzz.localdomain>
 <9910967.v2CO5Rsaj0@js-desktop.svl.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        andreslc@google.com, davem@davemloft.net, gthelen@google.com
To: Junaid Shahid <junaids@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:40884 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755637AbdLTVFY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 16:05:24 -0500
Received: by mail-it0-f54.google.com with SMTP id f190so8382793ita.5
        for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2017 13:05:24 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <9910967.v2CO5Rsaj0@js-desktop.svl.corp.google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 20, 2017 at 11:28:27AM -0800, Junaid Shahid wrote:
> > > +	# adjust the shuffle mask pointer to be able to shift either 0 or 8
> > > +	# bytes depending on whether the last block is <8 bytes or not
> > > +        mov \DLEN, \TMP1
> > > +        and $8, \TMP1
> > > +	lea SHIFT_MASK(%rip), %rax
> > > +	sub \TMP1, %rax
> > > +	movdqu (%rax), \XMM2		# get the appropriate shuffle mask
> > > +	PSHUFB_XMM \XMM2, \XMM1		# shift left either 0 or 8 bytes
> > 
> > Is there any way this can be simplified to use pslldq?  The shift is just 8
> > bytes or nothing, and we already had to branch earlier depending on whether we
> > needed to read the 8 bytes or not.
> 
> I am not sure if we can use a simple pslldq without either introducing another
> branch, or duplicating the _read_last_lt8 block for each case of the original
> branch. Do you think that it is better to just duplicate the _read_last_lt8
> block instead of using pshufb? Or do you have any other suggestion about how
> to do it?
> 

The best I can come up with now is just duplicating the "read one byte at a
time" instructions (see below).  One way to avoid the duplication would be to
read the 1-7 byte remainder (end of the block) first and the 8-byte word
(beginning of the block) second, but it would be a bit weird.

# read the last <16 byte block
# Clobbers %rax, TMP1 and XMM1
.macro READ_PARTIAL_BLOCK DPTR DLEN TMP1 XMM1 XMMDst
	mov \DLEN, \TMP1
	cmp $8, \DLEN
	jl _read_partial_lt8_\@
        mov (\DPTR), %rax
        MOVQ_R64_XMM %rax, \XMMDst
	sub $8, \TMP1
	jz _done_read_partial_\@
	xor %rax, %rax
1:
	shl $8, %rax
        mov 7(\DPTR, \TMP1, 1), %al
        dec \TMP1
        jnz 1b
        MOVQ_R64_XMM %rax, \XMM1
	pslldq $8, \XMM1
	por \XMM1, \XMMDst
	jmp _done_read_partial_\@

_read_partial_lt8_\@:
	xor %rax, %rax
1:
	shl $8, %rax
        mov -1(\DPTR, \TMP1, 1), %al
        dec \TMP1
        jnz 1b
        MOVQ_R64_XMM %rax, \XMMDst
_done_read_partial_\@:
.endm
