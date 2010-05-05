From: Manuel Lauss <manuel.lauss@googlemail.com>
Subject: Re: Test tools for crypt accelerators?
Date: Wed, 5 May 2010 14:45:35 +0200
Message-ID: <k2mf861ec6f1005050545neeff3d7p3642ba47e0422ab5@mail.gmail.com>
References: <q2uf861ec6f1005050502hf443a7d6mf58f68d97ce38875@mail.gmail.com>
	 <20100505123145.GA6878@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35784 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934711Ab0EEMpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 May 2010 08:45:36 -0400
Received: by fxm10 with SMTP id 10so4174321fxm.19
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2010 05:45:35 -0700 (PDT)
In-Reply-To: <20100505123145.GA6878@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 5, 2010 at 2:31 PM, Sebastian Andrzej Siewior
<linux-crypto@ml.breakpoint.cc> wrote:
> * Manuel Lauss | 2010-05-05 14:02:15 [+0200]:
>
>>I've written a prototype driver for an AES accelerator; I'd like to t=
est it
>>now. =A0Are there any userspace tools available for this?
> modprobe tcrypt mode=3D10

Thanks, that's what I was looking for.
Unfortunately tcrypt oopses when it's loaded.


> will test varios blockmodes. There is no userland interface for hw
> driver atm.

That's okay, I just need something to throw data at it.

Thanks!
     Manuel Lauss
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
