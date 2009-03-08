From: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH 6/6] squashfs: Make SquashFS 4 use the new pcomp crypto
 interface
Date: Sun, 08 Mar 2009 06:47:52 +0000
Message-ID: <49B36A18.5030506@lougher.demon.co.uk>
References: <1235569394-15217-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090307104637.GB8731@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:53591 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbZCHGr4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Mar 2009 01:47:56 -0500
In-Reply-To: <20090307104637.GB8731@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> On Wed, Feb 25, 2009 at 02:43:14PM +0100, Geert Uytterhoeven wrote:
>> Modify SquashFS 4 to use the new "pcomp" crypto interface for decompression,
>> instead of calling the underlying zlib library directly. This simplifies e.g.
>> the addition of support for hardware decompression and different decompression
>> algorithms.
>>
>> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
>> Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
> 
> I've applied patches 1-5.  I'd like to see an ack on this before
> applying it.
> 

I've not acked it because I've not yet made any decisions as to whether 
I want it in Squashfs.  Also as Squashfs maintainer I maintain my own 
tree of patches to Squashfs, and so I'll prefer to add it to my tree for 
subsequent feeding into 2.6.30 once the merge window opens.

I'm fairly agnostic about what decompression library Squashfs uses.  The 
only thing I care about is cleanliness and usability of the API and 
performance.  If the crypto API is cleaner or the cryto zlib 
implementation is faster than the current zlib implementation then I see 
no reason not to move over to it.  But, I've seen no performance figures 
and the API seems clumsier.

Two API issues of concern (one major, one minor).  Both of these relate 
to the way Squashfs drives the decompression code, where it repeatedly 
calls it supplying additional input/output buffers, rather than using a 
"single-shot" approach where it calls the decompression code once 
supplying all the necessary input and output buffer space.

1. Minor issue -the lack of a stream.total_out field.  The current 
zlib_inflate code collects the total number of bytes decompressed over 
the multiple calls into the stream.total_out field.

    There is clearly no such field available in the cryto API, leading 
to the somewhat clumsy need to track it, i.e. it leads to the following 
additional code.

+		unsigned int produced = 0;

[snip]

 > +		length = 0;

[snip]
 > +			produced = req.avail_out;
 > +			error = crypto_decompress_update(msblk->tfm, &req);

 > +			produced -= req.avail_out;
 >
 > +			length += produced;
 >

[snip]
 > +		produced = req.avail_out;
 > +		error = crypto_decompress_final(msblk->tfm, &req);

 > +		produced -= req.avail_out;
 > +
 > +		length += produced;


Whereas previously, only the following single line was required:

 > -		length = msblk->stream.total_out;

2. Major issue - working out loop termination.

It transpires when decompressing from multiple input buffers into 
multiple output buffers, determining when the decompressor has consumed 
all input buffers and has flushed all output to the output buffers is 
difficult.

One might assume loop termination can take place once the decompressor 
has consumed all the input data - however, this is insufficient because 
the decompressor may exit having consumed all the input data but it 
still requires additional output buffer space (stream.avail_in == 0, 
stream.avail_out == 0).

This leads to the exit condition (stream.avail_in == 0 && 
stream.avail_out != 0).  However, this still isn't sufficient because 
the majority of blocks in Squashfs decompress to an exact multiple of 
the output buffer, i.e. stream.avail_in == 0 && stream.avail_out == 0 is 
true at the end of decompression.

(stream.avail_in == 0 && stream_avail_out == 0) == true may or may not 
indicate the end of decompression.  In other words the status of the 
input/output buffers doesn't give sufficient information as to whether 
to terminate the loop or not.

With zlib_inflate this is irrelevant because it supplies a suitable exit 
code indicating whether it needs to be called again (Z_OK) or whether 
decompression has finished (Z_STREAM_END).  This makes loop termination 
easy.

My biggest criticism against the cryto changes to Squashfs is 
crypto_decompress_update doesn't seem to give this information, leaving 
to the clumsy introduction of a check to see if crypto_decompress_update 
produced any output data, i.e.:

-		} while (zlib_err == Z_OK);
 > -

is replaced by:

 > +		} while (bytes || produced);
 > +

This is clearly suboptimal, and always leads to an additional iteration 
around the loop.  Only once we've iterated over the loop one last time 
doing nothing do we decide the decompression has completed.

Not only this, but the loop termination also suffers from a major 
unanticipated bug:

The loop termination forces an additional iteration around the loop even 
though we've run out of output buffer space.

Consider the usual scenario where we're decompressing a buffer into two 
4K pages (pages = 2), and the buffer decompresses to 8K.  The final 
"real" iteration will have produced != 0 and req.avail_out == 0 (we've 
consumed all the output bytes in the last output buffer).

Because produced != 0 we will iterate over the loop again.  But because
req.avail_out == 0 we will load req.next_out with a non-existent buffer 
(we will fall off the end of the buffer array), i.e.

+			if (req.avail_out == 0) {
 > +				req.next_out = buffer[page++];
 > +				req.avail_out = PAGE_CACHE_SIZE;
 >  			}
 >

If for any reason crypto_decompress_update produces unexpected output 
(perhaps because of corrupted data), we will trigger a kernel oops.

Obviously in the majority of cases (which is why the code works), the 
"false" additional iteration doesn't produce any output.  But it is 
distinctly bad practice to have code in the kernel that in normal 
operation passes a bad pointer to crypto_decompress_output, and relies 
on its behaviour not to use that bad pointer.

> Thanks,

Currently as it stands I cannot accept the patch into Squashfs for the 
above reasons.  The code is less optimal, suffers from a major bug, and 
has a number of workarounds stemming from what I feel is a less 
"featureful" API.

I'm willing to consider moving Squashfs over to the crypto API once my 
concerns have been addressed.  The promised simplification in the 
"addition of support for hardware decompression and different 
decompression algorithms" seems quite attractive.  But I'm unwilling to 
degrade the zlib support in Squashfs for this future promise.

Phillip

