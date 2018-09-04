From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v8 0/9] crypto: Remove VLA usage
Date: Mon, 3 Sep 2018 22:50:41 -0700
Message-ID: <CAGXu5jLHkNSGhR7Tk6wg8Vw-7nHPFfAgWyJ0NLMjGQw1BOKovg@mail.gmail.com>
References: <20180807211843.47586-1-keescook@chromium.org>
	<20180904051905.a2vyzijz6xyxvyhb@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Mike Snitzer <snitzer@redhat.com>,
	Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Will Deacon <will.deacon@arm.com>, qat-linux@intel.com,
	Matthew Wilcox <willy@infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	device-mapper development <dm-devel@redhat.com>,
	Eric Biggers <ebiggers@google.com>, David Woodhouse <dwmw@amazon.co.uk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>, Alasdair Kergon <agk@redhat.com>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180904051905.a2vyzijz6xyxvyhb@gondor.apana.org.au>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 3, 2018 at 10:19 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Aug 07, 2018 at 02:18:34PM -0700, Kees Cook wrote:
>> v8 cover letter:
>>
>> I continue to hope this can land in v4.19, but I realize that's unlikely.
>> It would be nice, though, if some of the "trivial" patches could get taken
>> (e.g. cbc, xcbc, ccm VLA removals) so I don't have to keep repeating them.
>> *fingers crossed*
>>
>> Series cover letter:
>>
>> This is nearly the last of the VLA removals[1], but it's one of the
>> largest because crypto gets used in lots of places. After looking
>> through code, usage, reading the threads Gustavo started, and comparing
>> the use-cases to the other VLA removals that have landed in the kernel,
>> I think this series is likely the best way forward to shut the door on
>> VLAs forever.
>>
>> For background, the crypto stack usage is for callers to do an immediate
>> bit of work that doesn't allocate new memory. This means that other VLA
>> removal techniques (like just using kmalloc) aren't workable, and the
>> next common technique is needed: examination of maximum stack usage and
>> the addition of sanity checks. This series does that, and in several
>> cases, these maximums were already implicit in the code.
>>
>> This series is intended to land via the crypto tree for 4.19, though it
>> touches dm, networking, and a few other things as well, since there are
>> dependent patches (new crypto #defines being used, etc).
>
> I have applied patches 1-4 and 6-8.  I'd like to get an ack from
> the dm folks regarding patch 5.  As to patch 9, please fix it so
> it doesn't rely on the BUG_ON to catch things.

Great! Thanks very much. I'll get a patch prepared to plumb
crypto_skcipher_set_reqsize() failures.

-Kees

-- 
Kees Cook
Pixel Security
