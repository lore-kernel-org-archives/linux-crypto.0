From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KASAN: use-after-free Read in crypto_aead_free_instance
Date: Wed, 20 Dec 2017 12:59:43 +0100
Message-ID: <CACT4Y+ZPvO-nEMJsHvzm9zPOdB803Eh9+UO_E++Wx6xBxw=mLA@mail.gmail.com>
References: <001a11c14bc887c2c60560c0cdda@google.com> <18467907.EfXNf1iGip@tauon.chronox.de>
 <CACT4Y+bg6GjHbLpSkB6joS_dgu3ZYH=mJXHJ8AnuWiPVokhBdA@mail.gmail.com> <12415329.MInO136rYd@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: syzbot
        <bot+e5e6fab2d4dc3d9877ac240fed364027bb960ad0@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <12415329.MInO136rYd@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Dec 20, 2017 at 12:49 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Mittwoch, 20. Dezember 2017, 11:15:38 CET schrieb Dmitry Vyukov:
>
> Hi Dmitry,
>
>>
>> What will be its meaning? How will it differ from fix?
>
> Maybe a short clarification would help: what is the meaning of the syz fix
> marker?

It's described here:
https://github.com/google/syzkaller/blob/master/docs/syzbot.md#bug-status-tracking

> Depending on this answer, all that I am thinking of is to mark bug
> reports for which there are fixes actively discussed, but yet not integrated.
> Thus, such marker should only help others to point them to active discussions
> instead of them trying to find fixes alone.

If it's only for humans, then there is no need to make a special
machine-readable command for this.
So basically what you wrote above is good:

> This issue vanishes after applying the patch "[PATCH v2] crypto: AF_ALG - limit mask and type".

I just didn't understand that's still pending (but perhaps that's what
you meant by including "[PATCH v2]" part).
