From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] crypto: add missing KERN_* constants to printks
Date: Fri, 6 Feb 2009 17:58:38 +0300
Message-ID: <20090206145838.GA28197@x200.localdomain>
References: <498C46DE.8040700@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux kernel <linux-kernel@vger.kernel.org>,
	akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, frank@f-seidel.de,
	herbert@gondor.apana.org.au, jarod@redhat.com
To: Frank Seidel <fseidel@suse.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757996AbZBFOwv@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <498C46DE.8040700@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Feb 06, 2009 at 03:19:10PM +0100, Frank Seidel wrote:
> According to kerneljanitors todo list all printk calls (beginning
> a new line) should have an according KERN_* constant.

Forget about kernel janitors todo list, fix a bug instead.

> Those are the missing pieces here for the crypto subsystem.

You're inserting KERN_WARNING everywhere, what for?

> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -74,7 +74,7 @@ static int test_cipher_jiffies(struct bl
>  			return ret;
>  	}
>  
> -	printk("%d operations in %d seconds (%ld bytes)\n",
> +	printk(KERN_WARNING "%d operations in %d seconds (%ld bytes)\n",
>  	       bcount, sec, (long)bcount * blen);
>  	return 0;
>  }
> @@ -122,7 +122,7 @@ out:
>  	local_bh_enable();
>  
>  	if (ret == 0)
> -		printk("1 operation in %lu cycles (%d bytes)\n",
> +		printk(KERN_WARNING "1 operation in %lu cycles (%d bytes)\n",
>  		       (cycles + 4) / 8, blen);
>  
>  	return ret;
> @@ -146,13 +146,13 @@ static void test_cipher_speed(const char
>  	else
>  		e = "decryption";
>  
> -	printk("\ntesting speed of %s %s\n", algo, e);
> +	printk(KERN_WARNING "\ntesting speed of %s %s\n", algo, e);
>  
>  	tfm = crypto_alloc_blkcipher(algo, 0, CRYPTO_ALG_ASYNC);
>  
>  	if (IS_ERR(tfm)) {
> -		printk("failed to load transform for %s: %ld\n", algo,
> -		       PTR_ERR(tfm));
> +		printk(KERN_WARNING "failed to load transform for %s: %ld\n",
> +		       algo, PTR_ERR(tfm));
>  		return;
>  	}
>  	desc.tfm = tfm;
> @@ -166,14 +166,16 @@ static void test_cipher_speed(const char
>  			struct scatterlist sg[TVMEMSIZE];
>  
>  			if ((*keysize + *b_size) > TVMEMSIZE * PAGE_SIZE) {
> -				printk("template (%u) too big for "
> +				printk(KERN_WARNING
> +				       "template (%u) too big for "
>  				       "tvmem (%lu)\n", *keysize + *b_size,
>  				       TVMEMSIZE * PAGE_SIZE);
>  				goto out;
>  			}
>  
> -			printk("test %u (%d bit key, %d byte blocks): ", i,
> -					*keysize * 8, *b_size);
> +			printk(KERN_WARNING
> +					"test %u (%d bit key, %d byte blocks): ",
> +					i, *keysize * 8, *b_size);
>  
>  			memset(tvmem[0], 0xff, PAGE_SIZE);
>  
> @@ -188,7 +190,8 @@ static void test_cipher_speed(const char
>  
>  			ret = crypto_blkcipher_setkey(tfm, key, *keysize);
>  			if (ret) {
> -				printk("setkey() failed flags=%x\n",
> +				printk(KERN_WARNING
> +						"setkey() failed flags=%x\n",
>  						crypto_blkcipher_get_flags(tfm));
>  				goto out;
>  			}
> @@ -215,7 +218,8 @@ static void test_cipher_speed(const char
>  							 *b_size);
>  
>  			if (ret) {
> -				printk("%s() failed flags=%x\n", e, desc.flags);
> +				printk(KERN_WARNING "%s() failed flags=%x\n",
> +				       e, desc.flags);
>  				break;
>  			}
>  			b_size++;
> @@ -243,7 +247,7 @@ static int test_hash_jiffies_digest(stru
>  			return ret;
>  	}
>  
> -	printk("%6u opers/sec, %9lu bytes/sec\n",
> +	printk(KERN_WARNING "%6u opers/sec, %9lu bytes/sec\n",
>  	       bcount / sec, ((long)bcount * blen) / sec);
>  
>  	return 0;
> @@ -275,7 +279,7 @@ static int test_hash_jiffies(struct hash
>  			return ret;
>  	}
>  
> -	printk("%6u opers/sec, %9lu bytes/sec\n",
> +	printk(KERN_WARNING "%6u opers/sec, %9lu bytes/sec\n",
>  	       bcount / sec, ((long)bcount * blen) / sec);
>  
>  	return 0;
> @@ -320,7 +324,7 @@ out:
>  	if (ret)
>  		return ret;
>  
> -	printk("%6lu cycles/operation, %4lu cycles/byte\n",
> +	printk(KERN_WARNING "%6lu cycles/operation, %4lu cycles/byte\n",
>  	       cycles / 8, cycles / (8 * blen));
>  
>  	return 0;
> @@ -384,7 +388,7 @@ out:
>  	if (ret)
>  		return ret;
>  
> -	printk("%6lu cycles/operation, %4lu cycles/byte\n",
> +	printk(KERN_WARNING "%6lu cycles/operation, %4lu cycles/byte\n",
>  	       cycles / 8, cycles / (8 * blen));
>  
>  	return 0;
> @@ -400,13 +404,13 @@ static void test_hash_speed(const char *
>  	int i;
>  	int ret;
>  
> -	printk("\ntesting speed of %s\n", algo);
> +	printk(KERN_WARNING "\ntesting speed of %s\n", algo);
>  
>  	tfm = crypto_alloc_hash(algo, 0, CRYPTO_ALG_ASYNC);
>  
>  	if (IS_ERR(tfm)) {
> -		printk("failed to load transform for %s: %ld\n", algo,
> -		       PTR_ERR(tfm));
> +		printk(KERN_WARNING "failed to load transform for %s: %ld\n",
> +		       algo, PTR_ERR(tfm));
>  		return;
>  	}
>  
> @@ -414,7 +418,7 @@ static void test_hash_speed(const char *
>  	desc.flags = 0;
>  
>  	if (crypto_hash_digestsize(tfm) > sizeof(output)) {
> -		printk("digestsize(%u) > outputbuffer(%zu)\n",
> +		printk(KERN_WARNING "digestsize(%u) > outputbuffer(%zu)\n",
>  		       crypto_hash_digestsize(tfm), sizeof(output));
>  		goto out;
>  	}
> @@ -427,12 +431,14 @@ static void test_hash_speed(const char *
>  
>  	for (i = 0; speed[i].blen != 0; i++) {
>  		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
> -			printk("template (%u) too big for tvmem (%lu)\n",
> +			printk(KERN_WARNING
> +			       "template (%u) too big for tvmem (%lu)\n",
>  			       speed[i].blen, TVMEMSIZE * PAGE_SIZE);
>  			goto out;
>  		}
>  
> -		printk("test%3u (%5u byte blocks,%5u bytes per update,%4u updates): ",
> +		printk(KERN_WARNING
> +		       "test%3u (%5u byte blocks,%5u bytes per update,%4u updates): ",
>  		       i, speed[i].blen, speed[i].plen, speed[i].blen / speed[i].plen);
>  
>  		if (sec)
> @@ -443,7 +449,7 @@ static void test_hash_speed(const char *
>  					       speed[i].plen, output);
>  
>  		if (ret) {
> -			printk("hashing failed ret=%d\n", ret);
> +			printk(KERN_WARNING "hashing failed ret=%d\n", ret);
>  			break;
>  		}
>  	}
> --- a/crypto/ansi_cprng.c
> +++ b/crypto/ansi_cprng.c
> @@ -167,7 +167,7 @@ static int _get_more_prng_bytes(struct p
>  			break;
>  	}
>  
> -	dbgprint("Returning new block for context %p\n", ctx);
> +	dbgprint(KERN_WARNING "Returning new block for context %p\n", ctx);
