From: Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH v2 0/5] crypto: Speck support
Date: Tue, 24 Apr 2018 21:58:32 +0000
Message-ID: <CA+_SqcAjXkunPErsQ3LomTcANjm3sTQQq3j=YN_fFTv+Rg8z2g@mail.gmail.com>
References: <20180212235209.117393-1-ebiggers@google.com>
 <CAHmME9oA4j=iGrrBYME92JfUsyi5r42PnAvzWiuXzGCRXMnXtA@mail.gmail.com>
 <20180424181623.GA174675@google.com>
 <CAHmME9qG+nPmj5c7hU4+STUsmWmwSBsKe-0mOLEXH+hJ1z4z=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: noloader@gmail.com, Greg Kaiser <gkaiser@google.com>,
 herbert@gondor.apana.org.au, ard.biesheuvel@linaro.org,
 Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>,
 Patrik Torstensson <totte@google.com>, Alex Cope <alexcope@google.com>,
 Paul Lawrence <paullawrence@google.com>, linux-fscrypt@vger.kernel.org,
 linux-crypto@vger.kernel.org, gregkh@linuxfoundation.org,
 tashur@esat.kuleuven.be, linux-arm-kernel@lists.infradead.org
To: Jason@zx2c4.com
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAHmME9qG+nPmj5c7hU4+STUsmWmwSBsKe-0mOLEXH+hJ1z4z=g@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 24 Apr 2018 at 13:58, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> On Tue, Apr 24, 2018 at 8:16 PM, Eric Biggers <ebiggers@google.com> wrote:
> > So, what do you propose replacing it with?

> Something more cryptographically justifiable.

I'm keen to hear recommendations here, if there are options we should be
considering I'd like to know about them.

> That's the thing that worries me, actually. Many of the design
> decisions behind Speck haven't been justified.

It seems to me justified about as well as one would hope for a new cipher -
  "Notes on the design and analysis of Simon and Speck" seems to me to give
more detail on the reasoning than went into eg Salsa20, which I think also
hit a perfectly acceptable bar and was a good choice for adding to the
Linux kernel. Of course it's building on the fairly detailed understanding
we now have of how to build a secure ARX cipher. Given what a prize
cryptanalysis of an NSA-designed block cipher would be for anyone in the
field, the sheer simplicity and straightforwardness of the design, taken
with the very large gap between the full cipher and the best cryptanalysis,
and drawing on my own experience attacking Salsa20, I feel pretty good
about fielding this design. But if you have a specific alternative in mind
- a 128-bit block cipher (so we can use it in XTS mode) which is fast and
side-channel-free on ARM processors with NEON but without ARM CE - I'm very
keen to hear about it.

Could you say a little more about what it is that separates Speck from SM4
for you?

Thanks!
