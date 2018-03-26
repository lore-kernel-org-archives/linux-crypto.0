From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2] crypto/ecc: Remove stack VLA usage
Date: Mon, 26 Mar 2018 15:38:59 -0700
Message-ID: <CAGXu5jKJ-05xb8x7A4dZmFQm10z5g9x1LhFbC1nzLT7kdVVbGg@mail.gmail.com>
References: <20180308215702.GA9902@beast> <20180316155632.GI7095@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Tudor Ambarus <tudor.ambarus@microchip.com>, "David S. Miller" <davem@davemloft.net>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <kernel-hardening-return-12741-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: keescook@google.com
In-Reply-To: <20180316155632.GI7095@gondor.apana.org.au>
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 16, 2018 at 8:56 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Mar 08, 2018 at 01:57:02PM -0800, Kees Cook wrote:
>> On the quest to remove all VLAs from the kernel[1], this switches to
>> a pair of kmalloc regions instead of using the stack. This also moves
>> the get_random_bytes() after all allocations (and drops the needless
>> "nbytes" variable).
>>
>> [1] https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Patch applied.  Thanks.

Hi, sorry for the noise on this one: I messed up looking at the ecc
code (I confused myself into thinking there was only a single instance
of the problem). The applied patch is both incomplete and inefficient.
I have a much simpler solution, and I'll send that with a revert...

-Kees

-- 
Kees Cook
Pixel Security
