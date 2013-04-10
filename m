From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH] crypto: algif - suppress sending source address
 information in recvmsg
Date: Wed, 10 Apr 2013 08:21:51 +0200
Message-ID: <CA+rthh9y2JiqHeOqPsDx+tS1Mk0O7rJDWsNPzqfiQz+9rEAnqA@mail.gmail.com>
References: <1365336339-403-1-git-send-email-minipli@googlemail.com>
	<20130410033148.GA32360@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:55911 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3DJGVw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Apr 2013 02:21:52 -0400
Received: by mail-lb0-f177.google.com with SMTP id r10so172965lbi.36
        for <linux-crypto@vger.kernel.org>; Tue, 09 Apr 2013 23:21:51 -0700 (PDT)
In-Reply-To: <20130410033148.GA32360@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 10, 2013 at 5:31 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Sun, Apr 07, 2013 at 02:05:39PM +0200, Mathias Krause wrote:
>> The current code does not set the msg_namelen member to 0 and therefore
>> makes net/socket.c leak the local sockaddr_storage variable to userland
>> -- 128 bytes of kernel stack memory. Fix that.
>>
>> Signed-off-by: Mathias Krause <minipli@googlemail.com>
>
> Patch applied.  Thanks!

Thanks, but that patch shouldn't have been applied to cryptodev but
crypto instead, and probably queued up for stable as well.
I missed the 'Cc: stable # v2.6.38'. My bad.

Mathias
