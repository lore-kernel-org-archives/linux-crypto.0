From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v2 0/5] crypto: Speck support
Date: Tue, 24 Apr 2018 11:16:23 -0700
Message-ID: <20180424181623.GA174675@google.com>
References: <20180212235209.117393-1-ebiggers@google.com>
 <CAHmME9oA4j=iGrrBYME92JfUsyi5r42PnAvzWiuXzGCRXMnXtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jeffrey Walton <noloader@gmail.com>, Greg Kaiser <gkaiser@google.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Michael Halcrow <mhalcrow@google.com>, Patrik Torstensson <totte@google.com>,
 Alex Cope <alexcope@google.com>, Paul Lawrence <paullawrence@google.com>,
 linux-fscrypt@vger.kernel.org,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-arm-kernel@lists.infradead.org, Paul Crowley <paulcrowley@google.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9oA4j=iGrrBYME92JfUsyi5r42PnAvzWiuXzGCRXMnXtA@mail.gmail.com>
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

Hi Jason,

On Tue, Apr 24, 2018 at 06:11:26PM +0200, Jason A. Donenfeld wrote:
> Can we please not Speck?
> 
> It was just rejected by the ISO/IEC.
> 
> https://twitter.com/TomerAshur/status/988659711091228673

So, what do you propose replacing it with?

As I explained in the patch, the purpose of adding Speck is to allow low-end
Android devices -- ones that have CPUs without the ARMv8 Cryptography Extensions
-- to start using dm-crypt or fscrypt.  Currently such devices are unencrypted.
So, Speck is replacing *no encryption*, not another encryption algorithm.  By
removing Speck, you are removing encryption.  It's great that people are
enthusiastic about debating choices of crypto algorithms.  But it's unfortunate
that "no crypto" tends to pass by without comment from the same people.

We really wanted to use ChaCha20 instead.  But it would have been used in a
context where IVs are reused (f2fs encryption on flash storage), which
catastrophically breaks stream ciphers, but is less bad for a block cipher
operating in XTS mode.  Thus, we had to use either a block cipher, or a
wide-block encryption mode (pseudorandom permutation over the whole input).  Of
course, we would have liked to store nonces instead, but that is not currently
feasible with either dm-crypt or fscrypt.  It can be done with dm-crypt on top
of dm-integrity, but that performs very poorly and would be especially
inappropriate for low end mobile devices.

Paul Crowley actually designed a very neat wide-block encryption mode based on
ChaCha20 and Poly1305, which we considered too.  But it would have been harder
to implement, and we'd have had to be pushing it with zero or very little
outside crypto review, vs. the many cryptanalysis papers on Speck.  (In that
respect the controversy about Speck has actually become an advantage, as it has
received much more cryptanalysis than other lightweight block ciphers.)

The reason we chose Speck had nothing to do with the proposed ISO standard or
any sociopolitical factors, but rather because it was the only algorithm we
could find that met the performance and security requirements.  Note that Linux
doesn't bow down to any particular standards organization, and it offers
algorithms that were specified in various places, even some with no more than a
publication by the author.  In fact, support for SM4 was just added too, which
is a Chinese government standard.  Are you going to send a patch to remove that
too, or is it just NSA designed algorithms that are not okay?

It is unfortunate that we had to choose an algorithm that has some
emotional/political baggage attached, and of course we did expect some pushback.
But I hope you can understand that all *technical* indicators are that Speck is
secure enough, and not really backdoor-able other than a new cryptoanalytical
technique that would likely apply to other ARX ciphers as well (in fact, you'd
probably have a different opinion of it if the authors had simply worked
somewhere else and published the exact same algorithm); and also, the trend
towards stream ciphers such as ChaCha20 has mostly ignored the disk encryption
use case, where a block cipher is still needed.

Thanks,

Eric
