From: Samuel Neves <samuel.c.p.neves@gmail.com>
Subject: Re: [PATCH v2] crypto: xts - Drop use of auxiliary buffer
Date: Wed, 5 Sep 2018 16:30:14 +0100
Message-ID: <CAEX_ruEtrJ2_Mz8FPOJuCHNvLpdGXR+4Nhn6HWng-5hYYxujig@mail.gmail.com>
References: <20180904080642.26897-1-omosnace@redhat.com>
	<20180905063231.GA6813@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180905063231.GA6813@sol.localdomain>
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

On Wed, Sep 5, 2018 at 7:32 AM, Eric Biggers <ebiggers@kernel.org> wrote:
> Note that if ever needed there's also still room for optimizing the GF(2^128)
> multiplications further, e.g. multiplying by 'x' and 'x^2' in parallel, or maybe
> having a version specialized for 32-bit processors.

Given that this is used to encrypt small buffers only, skipping ahead
seems like it may also be a viable strategy. For example, for the XTS
polynomial x^128 + x^7 + x^2 + x + 1 one can multiply by x^64 very
efficiently with

u128 skip64(u128 x)
{
  u128 b64 = (x >> 64);
  u128 b63 = (x >> 63) & ~(u128)0x01;
  u128 b62 = (x >> 62) & ~(u128)0x03;
  u128 b57 = (x >> 57) & ~(u128)0x7f;
  return (x << 64) ^ (b64 ^ b63 ^ b62 ^ b57);
}

Calling this twice skips exactly 128 blocks, in which case we can xor
both halves of a 4096-byte sector in parallel.
