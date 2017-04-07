From: Hamid Nassiby <h.nassiby@gmail.com>
Subject: Re: What should be the algo priority
Date: Fri, 7 Apr 2017 22:43:24 +0430
Message-ID: <CAFuf8QNiaCohNwHSvytcR9AZwKw=8v4pxHOUQ47qHujXZi5Apg@mail.gmail.com>
References: <CAFXBA=kTywuuZOKw6a7mj+aXtn0YcOYF=jmesuBE2L3zZmojMw@mail.gmail.com>
 <42612664.V5g4013kpk@tauon.chronox.de> <CAFXBA=mHp_LB9tufr-aRGXkfoULGbMn5RxRV1ajSozx88Er0CQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38406 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753758AbdDGSN4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Apr 2017 14:13:56 -0400
Received: by mail-wm0-f45.google.com with SMTP id t189so13472152wmt.1
        for <linux-crypto@vger.kernel.org>; Fri, 07 Apr 2017 11:13:55 -0700 (PDT)
In-Reply-To: <CAFXBA=mHp_LB9tufr-aRGXkfoULGbMn5RxRV1ajSozx88Er0CQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

"authenc" and "hmac" are templates, not different implementations of a ciph=
er.

Please take a look at:
https://kernel.readthedocs.io/en/sphinx-samples/crypto-API.html#terminology


On Thu, Apr 6, 2017 at 9:56 AM, Harsh Jain <harshjain.prof@gmail.com> wrote=
:
> On Tue, Apr 4, 2017 at 6:07 PM, Stephan M=C3=BCller <smueller@chronox.de>=
 wrote:
>> Am Dienstag, 4. April 2017, 09:53:17 CEST schrieb Harsh Jain:
>>
>> Hi Harsh,
>>
>>> Hi,
>>>
>>> Do we have any guidelines documented to decide what should be the
>>> algorithm priority. Specially for authenc implementation.Most of the
>>> drivers have fixed priority for all algos. Problem comes in when we
>>> have cbc(aes), hmac(sha1) and authenc(cbc(aes),hmac(sha1))
>>> implementation in driver. Base authenc driver gets more precedence
>>> because of higher priority(enc->base.cra_priority * 10 +
>>> auth_base->cra_priority;)
>>>
>>> What should be the priority of
>>> cbc(aes),
>>> hmac(sha1)
>>> authenc(cbc(aes),hmac(sha1))
>>
>> There is no general rule about the actual numbers. But commonly, the pri=
os are
>> set such that the prios of C implementations < ASM implementations < har=
dware
>> accelerators. The idea is to give users the fastest implementation there=
 is
>> for his particular system.
>
> It means cbc, hmac should have smaller(nearly 10 times less) priority
> than their authenc implementation otherwise request will not offload
> to driver because sw authenc priority is (aes * 10 + hmac).
>
>>
>> Ciao
>> Stephan
