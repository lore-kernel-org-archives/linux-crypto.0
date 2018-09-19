From: Randy Dunlap <rdunlap@infradead.org>
Subject: process? [Re: Crypto Fixes for 4.19]
Date: Wed, 19 Sep 2018 09:10:55 -0700
Message-ID: <d8c061a9-b415-e092-c28f-9e433d83b59b@infradead.org>
References: <20170714141855.GA29426@gondor.apana.org.au>
 <20170922084401.GA15541@gondor.apana.org.au>
 <20171128230929.GA17783@gondor.apana.org.au>
 <20171222064931.GA27068@gondor.apana.org.au>
 <20180105073808.GA14405@gondor.apana.org.au>
 <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20180919062201.ov5o4vljvholgsed@gondor.apana.org.au>
 <20180919132324.GA24399@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919132324.GA24399@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 9/19/18 6:23 AM, Greg KH wrote:
> On Wed, Sep 19, 2018 at 02:22:01PM +0800, Herbert Xu wrote:
>> Hi Greg: 
>>
>> This push fixes a potential boot hang in ccp and an incorrect
>> CPU capability check in aegis/morus on x86.
>>
>>
>> Please pull from
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus
> 
> Now pulled, thanks.
> 
> greg k-h

Hi,
Just a process question:

It looks like Greg is not adding Signed-of-by: <himself>
to mainline git commits, although the prior mainline git committer did so.

Is that omission on purpose?

submitting-patches.rst says:
The Signed-off-by: tag indicates that the signer was involved in the
development of the patch, or that he/she was in the patch's delivery path.


thanks,
-- 
~Randy
