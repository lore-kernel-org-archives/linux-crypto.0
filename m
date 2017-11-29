From: Philippe Ombredanne <pombredanne@nexb.com>
Subject: Re: [PATCH] crypto: replace FSF address with web source in license notices
Date: Wed, 29 Nov 2017 07:57:44 +0100
Message-ID: <CAOFm3uGsGsixDwi1EJkFBvSQXN5yESXe9yxxVAF+O2a2do0zCQ@mail.gmail.com>
References: <20171114092515.27010-1-martink@posteo.de> <20171129063511.GE21575@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Martin Kepplinger <martink@posteo.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34603 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752503AbdK2G60 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 01:58:26 -0500
Received: by mail-wm0-f68.google.com with SMTP id y82so34811316wmg.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2017 22:58:25 -0800 (PST)
In-Reply-To: <20171129063511.GE21575@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 29, 2017 at 7:35 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Nov 14, 2017 at 10:25:15AM +0100, Martin Kepplinger wrote:
>> A few years ago the FSF moved and "59 Temple Place" is wrong. Having this
>> still in our source files feels old and unmaintained.
>>
>> Let's take the license statement serious and not confuse users.
>>
>> As https://www.gnu.org/licenses/gpl-howto.html suggests, we replace the
>> postal address with "<http://www.gnu.org/licenses/>".
>>
>> Signed-off-by: Martin Kepplinger <martink@posteo.de>
>
> Patch applied.  Thanks.

Herbert,
You may have missed the thread on the similar "samples" patch [1]
before applying this as-is?

[1] https://lkml.org/lkml/2017/11/14/135
-- 
Cordially
Philippe Ombredanne
