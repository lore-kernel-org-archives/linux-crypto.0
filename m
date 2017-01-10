From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: Re: [PATCH v2 1/4] lib: Update LZ4 compressor module based on LZ4 v1.7.2.
Date: Tue, 10 Jan 2017 10:21:16 +0100
Message-ID: <1484040076-5004-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
References: <20170108112542.GC12798@kroah.com>
Cc: akpm@linux-foundation.org, bongkyu.kim@lge.com,
        rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, phillip@squashfs.org.uk,
        Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
To: gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170108112542.GC12798@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 01/08/2017 12:25 PM, Greg KH wrote:
>On Sat, Jan 07, 2017 at 05:55:42PM +0100, Sven Schmidt wrote:
>> This patch updates LZ4 kernel module to LZ4 v1.7.2 by Yann Collet.
>> The kernel module is inspired by the previous work by Chanho Min.
>> The updated LZ4 module will not break existing code since there were alias
>> methods added to ensure backwards compatibility.
>
> Meta-comment.  Does this update include all of the security fixes that
> we have made over the past few years to the lz4 code?  I don't want to
> be adding back insecure functions that will cause us problems.
>
> Specifically look at the changes I made in 2014 in this directory for an
> example of what I am talking about here.
>

Hi Greg,

it doesn't. I didn't have that in mind until now.
But I had a look at the related commits after I received your E-Mail and will review what I have to change
(and, obviously, do the changes :)).

Thanks,

Sven
