From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Crypto Fixes for 4.19
Date: Fri, 5 Oct 2018 08:37:02 -0700
Message-ID: <20181005153702.GB530@kroah.com>
References: <20170922084401.GA15541@gondor.apana.org.au>
 <20171128230929.GA17783@gondor.apana.org.au>
 <20171222064931.GA27068@gondor.apana.org.au>
 <20180105073808.GA14405@gondor.apana.org.au>
 <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20180919062201.ov5o4vljvholgsed@gondor.apana.org.au>
 <20181005020830.sy6xjsbdvtdqrtxr@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181005020830.sy6xjsbdvtdqrtxr@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 05, 2018 at 10:08:30AM +0800, Herbert Xu wrote:
> Hi Greg: 
> 
> This push fixes the following issues:
> 
> - Out-of-bound stack access in qat.
> - Illegal schedule in mxs-dcp.
> - Memory corruption in chelsio.
> - Incorrect pointer computation in caam.
> 
> 
> Please pull from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

Now merged, thanks.

greg k-h
