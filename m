From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] dm-crypt: Add support for stream ciphers
	using blkcipher interface
Date: Fri, 23 Nov 2007 20:22:59 +0800
Message-ID: <20071123122259.GC18862@gondor.apana.org.au>
References: <fd3e431c0711211338r5b7f04e5s4466e193b3f3743f@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dm-devel@redhat.com, Linux Crypto <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <fd3e431c0711211338r5b7f04e5s4466e193b3f3743f@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 05:38:12AM +0800, Tan Swee Heng wrote:
> Current implementation of dm-crypt supports block ciphers of the form
> "template(cipher)", e.g. "cbc(aes)". It does not support stream
> ciphers of the form "cipher", e.g. "salsa20", that uses the blkcipher
> interface directly.
> 
> This patch adds support for stream ciphers using the blkcipher
> interface directly. It uses a special chainmode called "stream".
> Example of usage:
>     cryptsetup luksFormat -c salsa20-stream-plain /dev/loop0

I'd really like to have a new format altogether that does not
involve dashes as a separator.  The reason is that dash is used
as a part of the name of certain algorithms.

Once dm-crypt starts using the givcrypt interface instead of its
own IV generators, we can get away with just a single algorithm
string, of the form

	geniv(mode(block-cipher))

Obviously stream ciphers would just be

	geniv(stream-cipher)

So when that happens we can just use the format "-string" as
that's an invalid specification in the current format.

Of course we'd continue to support the current format as well
which can coexist with the new format forever.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
