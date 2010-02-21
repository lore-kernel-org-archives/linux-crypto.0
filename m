From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] crypto/arc4: convert this stream cipher into
 a block cipher
Date: Sun, 21 Feb 2010 21:01:40 +0100
Message-ID: <20100221200140.GC11951@Chamillionaire.breakpoint.cc>
References: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com>
	<20100209073718.GA17612@gondor.apana.org.au>
	<20100209145705.GA20421@Chamillionaire.breakpoint.cc>
	<20100209204519.GC26258@gondor.apana.org.au>
	<20100209211238.GC21548@Chamillionaire.breakpoint.cc>
	<20100209214522.GA27002@gondor.apana.org.au>
	<20100212084228.GA1535@Chamillionaire.breakpoint.cc>
	<20100216125125.GA390@gondor.apana.org.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
        linux-crypto@vger.kernel.org, agk@redhat.com, mbroz@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100216125125.GA390@gondor.apana.org.au>
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

* Herbert Xu | 2010-02-16 20:51:25 [+0800]:

>On Fri, Feb 12, 2010 at 09:42:28AM +0100, Sebastian Andrzej Siewior wrote:
>>
>> -static void arc4_crypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>> +static void arc4_ivsetup(struct arc4_ctx *ctx, u8 *iv)
>>  {
>> -	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
>> +	if (unlikely(!ctx->new_key))
>> +		return;
>> +	memcpy(iv, &ctx->iv, sizeof(ctx->iv));
>> +	ctx->new_key = 0;
>
>Sorry, but this doesn't work.
>
>A ctx is supposed to be reentrant.  That is, while one thread
>is working away with a given ctx I should be able to use that
>same ctx in a different thread without them clobbering each
>other.
I also destroy the user supplied IV. You don't care about that? :)
So I have to know that someone called setkey() on this ctx but I can't
leave hints.
salsa also does not stick to plan here. ctx->input[6-9] is initialized
in encrypt() path. So two threads sharing a ctx are going to clobber
their state.

What about a new api for the stream cipher? We would merge the ctx part
and the iv into one handle. So the user would call setup_iv() instead of
setkey(). The difference would be that I can access the iv from within
setkey(). And the algorithm can fully express himself since he is no
longer trapped in the wrong body :)

>So that means (in general) you must not modify the ctx in any
>function other than setkey.
That is hard because I have a new state after encryption which I am only
allowed to save in the iv. And the new state may be reset in setkey()
where I can't touch the iv.
salsa does not keep/update its state. So the input[6-9] problem could be
fixed. Who/where is it used anyway? I can't see any user besides the
possible once (i.e. dm-crypt/ipsec).

>This also brings up the bigger question of how we transition to
>this new arc4.  I don't think we need to maintain exactly the
>same behaviour as the existing ecb(arc4).
>
>So what we could do is simply add a new blkcipher arc4, alongside
>the existing cipher arc4.  Then we can convert the existing users
>across, and finally remove the old arc4.
This has worked out before, lets stick to this :)

>Cheers,

Sebastian
