From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: What should be the algo priority
Date: Thu, 6 Apr 2017 10:56:31 +0530
Message-ID: <CAFXBA=mHp_LB9tufr-aRGXkfoULGbMn5RxRV1ajSozx88Er0CQ@mail.gmail.com>
References: <CAFXBA=kTywuuZOKw6a7mj+aXtn0YcOYF=jmesuBE2L3zZmojMw@mail.gmail.com>
 <42612664.V5g4013kpk@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:33056 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752101AbdDFF0c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Apr 2017 01:26:32 -0400
Received: by mail-qk0-f176.google.com with SMTP id h67so28948794qke.0
        for <linux-crypto@vger.kernel.org>; Wed, 05 Apr 2017 22:26:32 -0700 (PDT)
In-Reply-To: <42612664.V5g4013kpk@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 4, 2017 at 6:07 PM, Stephan M=C3=BCller <smueller@chronox.de> w=
rote:
> Am Dienstag, 4. April 2017, 09:53:17 CEST schrieb Harsh Jain:
>
> Hi Harsh,
>
>> Hi,
>>
>> Do we have any guidelines documented to decide what should be the
>> algorithm priority. Specially for authenc implementation.Most of the
>> drivers have fixed priority for all algos. Problem comes in when we
>> have cbc(aes), hmac(sha1) and authenc(cbc(aes),hmac(sha1))
>> implementation in driver. Base authenc driver gets more precedence
>> because of higher priority(enc->base.cra_priority * 10 +
>> auth_base->cra_priority;)
>>
>> What should be the priority of
>> cbc(aes),
>> hmac(sha1)
>> authenc(cbc(aes),hmac(sha1))
>
> There is no general rule about the actual numbers. But commonly, the prio=
s are
> set such that the prios of C implementations < ASM implementations < hard=
ware
> accelerators. The idea is to give users the fastest implementation there =
is
> for his particular system.

It means cbc, hmac should have smaller(nearly 10 times less) priority
than their authenc implementation otherwise request will not offload
to driver because sw authenc priority is (aes * 10 + hmac).

>
> Ciao
> Stephan
