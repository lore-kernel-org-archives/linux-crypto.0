From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: Re: [PATCH v2 1/4] lib: Update LZ4 compressor module based on LZ4 v1.7.2.
Date: Tue, 10 Jan 2017 10:32:17 +0100
Message-ID: <1484040737-5400-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
References: <20170108112223.GA12798@kroah.com>
Cc: akpm@linux-foundation.org, bongkyu.kim@lge.com,
        rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, phillip@squashfs.org.uk,
        Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
To: gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:41693 "EHLO
        mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1765271AbdAJJcc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2017 04:32:32 -0500
In-Reply-To: <20170108112223.GA12798@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/08/2017 12:23 PM, Greg KH wrote:
> On Sat, Jan 07, 2017 at 05:55:43PM +0100, Sven Schmidt wrote:
>> This patch updates the unlz4 wrapper to work with the new LZ4 kernel module version.
>>
>> Signed-off-by: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
>> ---
>>  lib/decompress_unlz4.c | 13 ++++++++-----
>>  1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/lib/decompress_unlz4.c b/lib/decompress_unlz4.c
>> index 036fc88..1b0baf3 100644
>> --- a/lib/decompress_unlz4.c
>> +++ b/lib/decompress_unlz4.c
>> @@ -72,7 +72,7 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
>>  		error("NULL input pointer and missing fill function");
>>  		goto exit_1;
>>  	} else {
>> -		inp = large_malloc(lz4_compressbound(uncomp_chunksize));
>> +		inp = large_malloc(LZ4_compressBound(uncomp_chunksize));
>
> Having functions differ by different cases of the characters is ripe for
> abuse and confusion.  Please never do that, especially as these "new"
> functions you created don't follow the correct kernel coding style rules
> :(
>
> thanks,
>
> greg k-h

Hi Greg,

you're right about that. I think I put a little too much effort in keeping old function names here.
I will get rid of that.

I also want to quote your previous E-Mail here:

> And follow the proper kernel coding style rules, putting your patches
> through scripts/checkpatch.pl should help you out here.

Sorry, I didn't know about that particular script. I already put Patches 2, 3 and 4 through checkpatch.pl;
patch 1 is a little more to rework but I will, of course, do that.

Thanks,

Sven
