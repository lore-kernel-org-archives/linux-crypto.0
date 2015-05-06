From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Re: [PATCH v2] splice: sendfile() at once fails for big files
Date: Wed, 06 May 2015 16:38:37 +0200
Message-ID: <554A276D.2080209@c-s.fr>
References: <20150423150308.8782B1A2439@localhost.localdomain>	<20150427070131.GA21190@gondor.apana.org.au> <CA+55aFyc+A25ozSTVNNHmBL_kUhv9u5kUq9esxjYggmqfPRE9w@mail.gmail.com> <554A23F4.7010004@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:24344 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbbEFOjW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 May 2015 10:39:22 -0400
In-Reply-To: <554A23F4.7010004@kernel.dk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Le 06/05/2015 16:23, Jens Axboe a =C3=A9crit :
> On 05/05/2015 09:41 PM, Linus Torvalds wrote:
>> Jens, ping?
>>
>> The test results should make this a no-brainer, but I hate how rando=
m
>> these flag ops.
>
> Missed the original, apparently. I too am confused how this is a
> correctness fix and not just an optimization.
>
> +               if (read_len < len)
> +                       sd->flags |=3D SPLICE_F_MORE;
> +               else if (!more)
> +                       sd->flags &=3D ~SPLICE_F_MORE;
>
> Should that check be for 'more', not '!more'?
>
>
@@ -1204,6 +1204,7 @@ ssize_t splice_direct_to_actor(struct file *in,=20
struct splice_desc *sd,
       * Don't block on output, we have to drain the direct pipe.
       */
      sd->flags &=3D ~SPLICE_F_NONBLOCK;
+    more =3D sd->flags & SPLICE_F_MORE;

      while (len) {
          size_t read_len;
@@ -1216,6 +1217,10 @@ ssize_t splice_direct_to_actor(struct file *in,=20
struct splice_desc *sd,
          read_len =3D ret;
          sd->total_len =3D read_len;

+        if (read_len < len)
+            sd->flags |=3D SPLICE_F_MORE;
+        else if (!more)
+            sd->flags &=3D ~SPLICE_F_MORE;



'more' contains whether sendfile() has been called with SPLICE_F_MORE o=
r=20
not.
Until all bytes are processed, we have to force SPLICE_F_MORE regardles=
s=20
of how sendfile() was called.
Once all bytes have been read, we have to reset the flags according to=20
how sendfile() was called, so if 'more' is NOT set, we have to clear=20
SPLICE_F_MORE from sd->flags (which was unconditionaly set for=20
processing the first bytes)

Christophe
