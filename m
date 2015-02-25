From: Kees Cook <keescook@chromium.org>
Subject: Re: [BISECTED] 4943ba16 ("include crypto- module prefix") breaks wifi
Date: Wed, 25 Feb 2015 13:50:14 -0800
Message-ID: <CAGXu5jKCr8-0-5EGHi3isnaeOm4qdazF=kpajcindgwCxeaK5w@mail.gmail.com>
References: <CAGXu5jKMX+DxPQo=BstEKjyWxvLtnHcG44qyMN=os-U4NjM=Kg@mail.gmail.com>
	<20150218063434.24444.qmail@ns.horizon.com>
	<CA+rthh-hS3ee7iqUuiTXx9BzFJEvUGk1g84UHNOFm6S+2fRCeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: George Spelvin <linux@horizon.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36176 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbbBYVuP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2015 16:50:15 -0500
Received: by mail-oi0-f50.google.com with SMTP id v1so5908100oia.9
        for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2015 13:50:15 -0800 (PST)
In-Reply-To: <CA+rthh-hS3ee7iqUuiTXx9BzFJEvUGk1g84UHNOFm6S+2fRCeQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 17, 2015 at 11:56 PM, Mathias Krause <minipli@googlemail.com> wrote:
> On 18 February 2015 at 07:34, George Spelvin <linux@horizon.com> wrote:
>>
>> It's trying to load modules named:
>>
>> crypto-ccm(aes)
>> crypto-ccm(aes)-all
>> crypto-ctr(aes)
>> crypto-ctr(aes)-all
>>
>> depmod -n doesn't show any aliases with parens in their names,
>
> That's okay. Also that it fails to load these as it'll fall back
> trying to load modules for the templates in that case, as can be seen
> in your log:
>
>> Wed Feb 18 06:58:10 UTC 2015 /sbin/modprobe -q -- crypto-ctr
>
> What's curious, however, that it only tries to load the template for
> "ctr", not for "ccm". :/
> Are the logs complete? Could you please simplify your /sbin/x/modprobe
> wrapper to just output the modprobe call, as Kees suggested?

George, any updates on this?

> Also, could you please provide the output of "depmod -n | grep
> crypto-"? There should be lines for crypto-ccm and crypto-ctr if you
> build them as modules.

I still haven't been able to reproduce this. :(

-Kees

-- 
Kees Cook
Chrome OS Security
