From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH v2] crypto: Add IV generation algorithms
Date: Tue, 13 Dec 2016 11:01:08 +0100
Message-ID: <d6d92865-98fa-4d02-035f-9080bc265c35@gmail.com>
References: <1481618949-20086-1-git-send-email-binoy.jayan@linaro.org>
 <1481618949-20086-2-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>
To: Binoy Jayan <binoy.jayan@linaro.org>, Oded <oded.golombek@arm.com>,
        Ofir <Ofir.Drang@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481618949-20086-2-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 12/13/2016 09:49 AM, Binoy Jayan wrote:
> Currently, the iv generation algorithms are implemented in dm-crypt.c.
> The goal is to move these algorithms from the dm layer to the kernel
> crypto layer by implementing them as template ciphers so they can be
> implemented in hardware for performance. As part of this patchset, the
> iv-generation code is moved from the dm layer to the crypto layer and
> adapt the dm-layer to send a whole 'bio' (as defined in the block layer)
> at a time. Each bio contains the in memory representation of physically
> contiguous disk blocks. The dm layer sets up a chained scatterlist of
> these blocks split into physically contiguous segments in memory so that
> DMA can be performed. The iv generation algorithms implemented in geniv.c
> include plain, plain64, essiv, benbi, null, lmk and tcw.
...

Just few notes...

The lmk (loopAES) and tcw (old TrueCrypt mode) IVs are in fact hacks,
it is combination of IV and modification of CBC mode (in post calls).

It is used only in these disk-encryption systems, it does not make sense
to use it elsewhere (moreover tcw IV is not safe, it is here only
for compatibility reasons).

I think that IV generators should not modify or read encrypted data directly,
it should only generate IV.

By the move everything to cryptoAPI we are basically introducing some strange mix
of IV and modes there, I wonder how this is going to be maintained.
Anyway, Herbert should say if it is ok...

But I would imagine that cryptoAPI should implement only "real" IV generators
and these disk-encryption add-ons keep inside dmcrypt.
(and dmcrypt should probably use normal IVs through crypto API and
build some wrapper around for hacks...)

...

> 
> When using multiple keys with the original dm-crypt, the key selection is
> made based on the sector number as:
> 
> key_index = sector & (key_count - 1)
> 
> This restricts the usage of the same key for encrypting/decrypting a
> single bio. One way to solve this is to move the key management code from
> dm-crypt to cryto layer. But this seems tricky when using template ciphers
> because, when multiple ciphers are instantiated from dm layer, each cipher
> instance set with a unique subkey (part of the bigger master key) and
> these instances themselves do not have access to each other's instances
> or contexts. This way, a single instance cannot encryt/decrypt a whole bio.
> This has to be fixed.

I really do not think the disk encryption key management should be moved
outside of dm-crypt. We cannot then change key structure later easily.

But it is not only key management, you are basically moving much more internals
outside of dm-crypt:

> +struct geniv_ctx {
> +	struct crypto_skcipher *child;
> +	unsigned int tfms_count;
> +	char *ivmode;
> +	unsigned int iv_size;
> +	char *ivopts;
> +	char *cipher;
> +	struct geniv_operations *iv_gen_ops;
> +	union {
> +		struct geniv_essiv_private essiv;
> +		struct geniv_benbi_private benbi;
> +		struct geniv_lmk_private lmk;
> +		struct geniv_tcw_private tcw;
> +	} iv_gen_private;
> +	void *iv_private;
> +	struct crypto_skcipher *tfm;
> +	unsigned int key_size;
> +	unsigned int key_extra_size;
> +	unsigned int key_parts;      /* independent parts in key buffer */

^^^ these key sizes you probably mean by key management.
It is based on way how the key is currently sent into kernel
(one hexa string in ioctl that needs to be split) and have to be changed in future.

> +	enum setkey_op keyop;
> +	char *msg;
> +	u8 *key;

Milan
