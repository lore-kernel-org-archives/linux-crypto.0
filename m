From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH] crypto: user - re-add size check for CRYPTO_MSG_GETALG
Date: Wed, 22 Jun 2016 21:43:18 +0200
Message-ID: <CA+rthh-rr3vNiU_uayEyNDFi4LOGhoqF02PHyO+TiTR=bNSqjg@mail.gmail.com>
References: <1466620177-10998-1-git-send-email-minipli@googlemail.com> <1700839.z4KCsoVT9C@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:35670 "EHLO
	mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbcFVTnY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 15:43:24 -0400
Received: by mail-yw0-f195.google.com with SMTP id v77so7719037ywg.2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jun 2016 12:43:24 -0700 (PDT)
In-Reply-To: <1700839.z4KCsoVT9C@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 22 June 2016 at 21:03, Stephan Mueller <smueller@chronox.de> wrote:
> Am Mittwoch, 22. Juni 2016, 20:29:37 schrieb Mathias Krause:
>
> Hi Mathias,
>
>> Commit 9aa867e46565 ("crypto: user - Add CRYPTO_MSG_DELRNG")
>> accidentally removed the minimum size check for CRYPTO_MSG_GETALG
>> netlink messages. This allows userland to send a truncated
>> CRYPTO_MSG_GETALG message as short as a netlink header only making
>> crypto_report() operate on uninitialized memory by accessing data
>> beyond the end of the netlink message.
>>
>> Fix this be re-adding the minimum required size of CRYPTO_MSG_GETALG
>> messages to the crypto_msg_min[] array.
>
> I was playing with the adding of the GETALG value as you did to track down the
> issue fixed with eed1e1afd8d542d9644534c1b712599b5d680007 ("crypto: user - no
> parsing of CRYPTO_MSG_GETALG") in the cryptodev-2.6 tree.

Oh, I haven't noticed this commit. :D Just looked at Linus' master and
crypto-2.6/master.

> It did not occur to me that it fixes another bug. Yet, with this addition, it
> would be possible to revert the patch eed1e1afd8d542d9644534c1b712599b5d680007
> as your patch fixes the issue too. But my fix can also stay as it does not
> hurt either.

Well, it does. Commit eed1e1afd8d542d9644534c1b712599b5d680007 is
really just a workaround for the underlying issue. It does not fix the
bug of the missing minimal size check for CRYPTO_MSG_GETALG, it just
disables any further size checks for CRYPTO_MSG_GETALG. Putting my
patch on top of yours will still not fix the issue of the missing
minimal size check as your patch explicitly excludes CRYPTO_MSG_GETALG
from any size checks. So it needs to be reverted, sorry :/

> What is your take on that?

I'd say to revert eed1e1afd8d542d9644534c1b712599b5d680007 and fix the
issue for real with my patch in crypto-2.6/master, i.e. the upcoming
v4.7. That adds back the size check so userland can't play tricks with
us.

The patch already contains the Cc to stable, so the fix will
eventually end up in the LTS kernel releases used by distros, so this
regression should be fixed in a few weeks.


Regards,
Mathias
