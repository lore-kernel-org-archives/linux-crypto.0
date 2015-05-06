From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] splice: sendfile() at once fails for big files
Date: Wed, 06 May 2015 08:40:54 -0600
Message-ID: <554A27F6.10800@kernel.dk>
References: <20150423150308.8782B1A2439@localhost.localdomain>	<20150427070131.GA21190@gondor.apana.org.au> <CA+55aFyc+A25ozSTVNNHmBL_kUhv9u5kUq9esxjYggmqfPRE9w@mail.gmail.com> <554A23F4.7010004@kernel.dk> <554A276D.2080209@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: leroy christophe <christophe.leroy@c-s.fr>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <554A276D.2080209@c-s.fr>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/06/2015 08:38 AM, leroy christophe wrote:
>
> Le 06/05/2015 16:23, Jens Axboe a =C3=A9crit :
>> On 05/05/2015 09:41 PM, Linus Torvalds wrote:
>>> Jens, ping?
>>>
>>> The test results should make this a no-brainer, but I hate how rand=
om
>>> these flag ops.
>>
>> Missed the original, apparently. I too am confused how this is a
>> correctness fix and not just an optimization.
>>
>> +               if (read_len < len)
>> +                       sd->flags |=3D SPLICE_F_MORE;
>> +               else if (!more)
>> +                       sd->flags &=3D ~SPLICE_F_MORE;
>>
>> Should that check be for 'more', not '!more'?
>>
>>
> @@ -1204,6 +1204,7 @@ ssize_t splice_direct_to_actor(struct file *in,
> struct splice_desc *sd,
>        * Don't block on output, we have to drain the direct pipe.
>        */
>       sd->flags &=3D ~SPLICE_F_NONBLOCK;
> +    more =3D sd->flags & SPLICE_F_MORE;
>
>       while (len) {
>           size_t read_len;
> @@ -1216,6 +1217,10 @@ ssize_t splice_direct_to_actor(struct file *in=
,
> struct splice_desc *sd,
>           read_len =3D ret;
>           sd->total_len =3D read_len;
>
> +        if (read_len < len)
> +            sd->flags |=3D SPLICE_F_MORE;
> +        else if (!more)
> +            sd->flags &=3D ~SPLICE_F_MORE;
>
>
>
> 'more' contains whether sendfile() has been called with SPLICE_F_MORE=
 or
> not.
> Until all bytes are processed, we have to force SPLICE_F_MORE regardl=
ess
> of how sendfile() was called.
> Once all bytes have been read, we have to reset the flags according t=
o
> how sendfile() was called, so if 'more' is NOT set, we have to clear
> SPLICE_F_MORE from sd->flags (which was unconditionaly set for
> processing the first bytes)

Ah gotcha, that looks correct. Patch is fine with me then.

--=20
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
