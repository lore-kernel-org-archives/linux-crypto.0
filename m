From: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH/RFC] crypto: compress - Return produced bytes in crypto_{,de}compress_{update,final}()
 (was: Re: [PATCH/RFC] crypto: compress - Add comp_request.total_out
Date: Wed, 25 Mar 2009 10:12:38 +0000
Message-ID: <49CA0396.20705@lougher.demon.co.uk>
References: <1235569394-15217-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090307104637.GB8731@gondor.apana.org.au> <49B36A18.5030506@lougher.demon.co.uk> <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be> <alpine.LRH.2.00.0903171345040.7595@vixen.sonytel.be> <alpine.LRH.2.00.0903241729540.4446@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:64967 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753086AbZCYKMl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Mar 2009 06:12:41 -0400
In-Reply-To: <alpine.LRH.2.00.0903241729540.4446@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Geert Uytterhoeven wrote:
> On Tue, 17 Mar 2009, Geert Uytterhoeven wrote:
>> On Wed, 11 Mar 2009, Geert Uytterhoeven wrote:
>>> On Sun, 8 Mar 2009, Phillip Lougher wrote:
>>>> Two API issues of concern (one major, one minor).  Both of these relate to the
>>>> way Squashfs drives the decompression code, where it repeatedly calls it
>>>> supplying additional input/output buffers, rather than using a "single-shot"
>>>> approach where it calls the decompression code once supplying all the
>>>> necessary input and output buffer space.
>>>>
>>>> 1. Minor issue -the lack of a stream.total_out field.  The current
>>>> zlib_inflate code collects the total number of bytes decompressed over the
>>>> multiple calls into the stream.total_out field.
>>>>
>>>>    There is clearly no such field available in the cryto API, leading to the
>>>> somewhat clumsy need to track it, i.e. it leads to the following additional
>>>> code.
>>> If people feel the need for a total_out field, I can add it to struct
>>> comp_request.
>>>
>>> BTW, what about total_in, which is also provided by plain zlib's z_stream?
>>> Do people see a need for a similar field?
>> The patch below (on top of the updated one to convert SquashFS to pcomp) adds
>> comp_request.total_out, so you don't have to calculate and accumulate the
>> decompressed output sizes in SquashFS.
>>
>> Notes:
>>   - This required the addition of a `struct comp_request *' parameter to
>>     crypto_{,de}compress_init()
>>   - Still, there's one of the 
>>
>> 	produced = req.avail_out;
>> 	...
>> 	produced -= req.avail_out;
>>
>>     left, as this is part of the logic to discover the end of decompression
>>     (no bytes produced, no error returned).
>>
>> Perhaps it's better to instead make crypto_{,de}compress_{update,final}()
>> return the (positive) number of output bytes (of the current step)?
>>
>> Currently it returns zero (no error) or a negative error value.
>> That would allow to get rid of both `produced = ... / produced -= ...'
>> constructs, but the user would have to accumulate the total output size again
>> (which is not such a big deal, IMHO).
> 
> Here's an alternative patch, which does exactly that.
> Phillip, what do you think?
> 

 From a quick look, it looks OK :-)  I'm not ignoring this, but I'm trying to get a release of
the 4.0 tools finished ASAP (now 2.6.29 is out).

Phillip
