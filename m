From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Fixes for 4.18
Date: Sun, 8 Jul 2018 11:31:16 -0700
Message-ID: <CA+55aFwe3HrgMBUhyHC7kAOCvp31S4kpAqDSFQ+BQY6r=WBiiA@mail.gmail.com>
References: <20161213132414.GA7898@gondor.apana.org.au> <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au> <20170922084401.GA15541@gondor.apana.org.au>
 <20171128230929.GA17783@gondor.apana.org.au> <20171222064931.GA27068@gondor.apana.org.au>
 <20180105073808.GA14405@gondor.apana.org.au> <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au> <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180708162035.zunfeflnq5hgwq6n@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180708162035.zunfeflnq5hgwq6n@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jul 8, 2018 at 9:20 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> - Add missing RETs in x86 aegis/morus.

Side note - I queried earlier during the discussion about this: how
was this code taken despite having clearly never tested on _anything_?

That's a serious question. Code that simply has never had any testing
AT ALL should not have gotten in.

The use of 'int3' in padding showed the issue, but I don't believe the
code could possibly have worked with the nops and fallthroughs.

               Linus
