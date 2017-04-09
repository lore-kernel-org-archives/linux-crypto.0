From: Willy Tarreau <w@1wt.eu>
Subject: Re: crypto_memneq not backported to 3.10
Date: Sun, 9 Apr 2017 15:25:14 +0200
Message-ID: <20170409132514.GA3970@1wt.eu>
References: <CAHmME9qjWeskvkVJCNnY1Xm7uAu4=gnuSsxX5KMf3kt6kqF9ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9qjWeskvkVJCNnY1Xm7uAu4=gnuSsxX5KMf3kt6kqF9ow@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Jason,

On Sun, Apr 09, 2017 at 02:59:53PM +0200, Jason A. Donenfeld wrote:
> Hey Willy,
> 
> Linux 3.10 is inexplicably missing crypto_memneq, making all crypto
> mac comparisons use non constant-time comparisons. Bad news bears.
> 
> 3.12 got these backported with
> d68e944a8fcb2c6212b38064771c9f5af7b0b92c,
> afe5a791d374e50a06ada7f4eda4e921e1b77996, and possibly others. I'd
> suggest following suit, since many people are relying on this kernel
> to do safe crypto.

Interesting. I remembered seeing some crypto_memneq stuff in the past,
and in fact there was one patch talking about this but trimmed down to
only affect other parts since crypto_memneq is indeed not part of 3.10.

I'll check if the 3.12 patches above can be safely backported, and I'll
have to re-apply the missing part of the one that was trimmed down
(commit 620c411 ("crypto: more robust crypto_memneq")).

Thanks!
Willy
