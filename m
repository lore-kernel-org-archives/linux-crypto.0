From: Fan Du <fan.du@windriver.com>
Subject: Re: Why care about signal when instantiate an crypt template
Date: Thu, 17 Apr 2014 17:20:34 +0800
Message-ID: <534F9CE2.1050509@windriver.com>
References: <20140417074449.GA24539@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:64169 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaDQJPd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Apr 2014 05:15:33 -0400
In-Reply-To: <20140417074449.GA24539@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert

On 2014=E5=B9=B404=E6=9C=8817=E6=97=A5 15:44, Herbert Xu wrote:
> Fan Du<fan.du@windriver.com>  wrote:
>> Hi,
>>
>> I recently bump into a issue, ike daemon got interrupted(EINTR),
>> after looking at the code, it seems there are places in crypto code
>> where returning EINTR when current tasks has signal pending.
>>
>> For example:
>> crypto_alloc_base and crypto_alloc_tfm
>>
>> 435 err:
>> 436                 if (err !=3D -EAGAIN)
>> 437                         break;
>> 438                 if (signal_pending(current)) {
>> 439                         err =3D -EINTR;
>> 440                         break;
>> 441                 }
>> 442         }
>>
>> I can't understand why the codes here needs to care about signals?
>
> Because otherwise you may end up with something that you can't
> kill from user-space.  You should fix your app.
Ok, I'm starting to follow your meaning.

The signal checking is only to bail out from the infinite loop, it shou=
ldn't
override original err code -EAGAIN with -EINTR.

With -EAGAIN, user space app can try again, what do you think?

@@ -550,12 +550,8 @@ void *crypto_alloc_tfm(const char *alg_name,
                 err =3D PTR_ERR(tfm);

  err:
-               if (err !=3D -EAGAIN)
+               if ((err !=3D -EAGAIN) || signal_pending(current))
                         break;
-               if (signal_pending(current)) {
-                       err =3D -EINTR;
-                       break;
-               }
         }




--=20
=E6=B5=AE=E6=B2=89=E9=9A=8F=E6=B5=AA=E5=8F=AA=E8=AE=B0=E4=BB=8A=E6=9C=9D=
=E7=AC=91

--fan
