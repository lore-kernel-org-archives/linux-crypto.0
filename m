From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v8 5/9] dm: Remove VLA usage from hashes
Date: Thu, 13 Sep 2018 09:41:45 -0700
Message-ID: <CAGXu5jKfR4JD5O1brLh=NFUvu2jMHHZ4JF93ZKwfk1CuuhGbbg@mail.gmail.com>
References: <20180807211843.47586-1-keescook@chromium.org>
	<20180807211843.47586-6-keescook@chromium.org>
	<20180904031318.47jc3jrxcdjeac5y@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
	Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	device-mapper development <dm-devel@redhat.com>,
	Eric Biggers <ebiggers@google.com>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>
To: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180904031318.47jc3jrxcdjeac5y@gondor.apana.org.au>
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

On Mon, Sep 3, 2018 at 8:13 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Aug 07, 2018 at 02:18:39PM -0700, Kees Cook wrote:
>> In the quest to remove all stack VLA usage from the kernel[1], this uses
>> the new HASH_MAX_DIGESTSIZE from the crypto layer to allocate the upper
>> bounds on stack usage.
>>
>> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Can the dm folks please review this patch?

Mike or Alasdair, can you Ack this patch so Herbert can include it in
the crypto tree? This is blocking some VLA removals[1]...

Thanks!

-Kees

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

-- 
Kees Cook
Pixel Security
