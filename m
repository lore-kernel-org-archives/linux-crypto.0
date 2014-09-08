From: Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: Re: [PATCH] security, crypto: LLVMLinux: Remove VLAIS from ima_crypto.c
Date: Mon, 08 Sep 2014 12:15:53 +0300
Message-ID: <540D73C9.3000906@samsung.com>
References: <1409958360-8061-1-git-send-email-behanw@converseincode.com>
 <alpine.DEB.2.10.1409060131260.5472@nanos>
 <540A590F.1030407@converseincode.com>
 <alpine.DEB.2.10.1409061152090.5472@nanos>
 <540BBD9E.6050708@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: zohar@linux.vnet.ibm.com, james.l.morris@oracle.com,
	linux-ima-devel@lists.sourceforge.net,
	linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, serge@hallyn.com,
	torvalds@linux-foundation.org,
	Mark Charlebois <charlebm@gmail.com>,
	=?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Behan Webster <behanw@converseincode.com>,
	Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-reply-to: <540BBD9E.6050708@converseincode.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 07/09/14 05:06, Behan Webster wrote:
> On 09/06/14 03:11, Thomas Gleixner wrote:
>> On Fri, 5 Sep 2014, Behan Webster wrote:
>>> On 09/05/14 17:18, Thomas Gleixner wrote:
>>>>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>>>>> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
>>>>> Signed-off-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
>>>> This SOB chain is completely ass backwards. See Documentation/...
>>> "The Signed-off-by: tag indicates that the signer was involved in t=
he
>>> development of the patch, or that he/she was in the patch's deliver=
y
>>> path."
>>>
>>> All three of us were involved. Does that not satisfy this rule?
>> No. Read #12
>>
>> The sign-off is a simple line at the end of the explanation for the
>> patch, which certifies that you wrote it or otherwise have the right=
 to
>> pass it on as an open-source patch.
>>
>> So the above chain says:
>>
>>     Written-by:   Behan
>>     Passed-on-by: Mark
>>     Passed-on-by: Jan
>>
>> That would be correct if you sent the patch to Mark, Mark sent it to
>> Jan and Jan finally submitted it to LKML.
> I suppose "Reviewed-by" is probably more appropriate for the last 2
> then. Will fix.
>
>>>>> -    struct {
>>>>> -        struct shash_desc shash;
>>>>> -        char ctx[crypto_shash_descsize(tfm)];
>>>>> -    } desc;
>>>>> +    char desc[sizeof(struct shash_desc) +
>>>>> +        crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR;
>>>>> +    struct shash_desc *shash =3D (struct shash_desc *)desc;
>>>> That anon struct should have never happened in the first place.
>>> Sadly this is a design pattern used in many places through out the
>>> kernel, and
>>> appears to be fundamental to the crypto system. I was advised *not*
>>> to change
>>> it, so we haven't.
>>>
>>> I agree that it's not a good practice.
>>>
>>>>    Not
>>>> your problem, but you are not making it any better. You replace op=
en
>>>> coded crap with even more unreadable crap.
>>>>
>>>> Whats wrong with
>>>>
>>>>         SHASH_DESC_ON_STACK(shash, tfm);
>>> Nothing is wrong with that. I would have actually preferred that.
>>> But it would
>>> have fundamentally changed a lot more code.
>> Errm. Why is
>>
>> #define SHASH_DESC_ON_STACK(shash, tfm)                \
>>     char __shash[sizeof(.....)];                \
>>     struct shash_desc *shash =3D (struct shash_desc *) __shash
>>
>> requiring more fundamental than open coding the same thing a gazilli=
on
>> times. You still need to change ALL usage sides of the anon struct.
>>
>> So in fact you could avoid the whole code change by making it
>>
>>     SHASH_DESC_ON_STACK(desc, tfm);
>>
>> and do the anon struct or a proper struct magic in the macro.
> I see. I thought you meant a more fundamental change to the crypto
> system API. My misunderstanding.
>
> Ironically we tried to stay away from macros since the last time we
> tried to replace VLAIS using macros (we've attempted patches to remov=
e
> VLAIS a few times) we were told *not* to hide the implementation with
> macro magic. Though, to be fair, we were using more pointer math in
> our other macro-based effort, and the non-crypto uses of VLAIS are a
> lot more complex to replace.
>
> Like I said I'm actually a fan of hiding ugliness in macros. Will fix=
=2E
>
> Again, thanks for the feedback,
>
> Behan
>

Hi,

Despite if it is crap or not, it was said already in this thread,
following "design pattern" is heavily used through out the kernel - by
crypto core itself and by many widely used clients.

    struct {
        struct shash_desc shash;
        char ctx[crypto_shash_descsize(tfm)];
    } desc;


My question why do you want to change this particular piece of code?
What about rest of the kernel?
To solve your problem you probably need to change everything.

If we are going to change it and introduce any macros, it is better to
do with the guidance from crypto folks.

I added CC:linux-crypto@vger.kernel.org mailing list and Herbert Xu,
crypto maintainer.

- Dmitry

--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
