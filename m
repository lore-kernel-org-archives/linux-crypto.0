From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [BISECTED] 4943ba16 ("include crypto- module prefix") breaks wifi
Date: Wed, 18 Feb 2015 08:56:51 +0100
Message-ID: <CA+rthh-hS3ee7iqUuiTXx9BzFJEvUGk1g84UHNOFm6S+2fRCeQ@mail.gmail.com>
References: <CAGXu5jKMX+DxPQo=BstEKjyWxvLtnHcG44qyMN=os-U4NjM=Kg@mail.gmail.com>
	<20150218063434.24444.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Kees Cook <keescook@chromium.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54244 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbbBRH4w (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Feb 2015 02:56:52 -0500
Received: by mail-wi0-f176.google.com with SMTP id h11so39007259wiw.3
        for <linux-crypto@vger.kernel.org>; Tue, 17 Feb 2015 23:56:51 -0800 (PST)
In-Reply-To: <20150218063434.24444.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 18 February 2015 at 07:34, George Spelvin <linux@horizon.com> wrote:
>
> It's trying to load modules named:
>
> crypto-ccm(aes)
> crypto-ccm(aes)-all
> crypto-ctr(aes)
> crypto-ctr(aes)-all
>
> depmod -n doesn't show any aliases with parens in their names,

That's okay. Also that it fails to load these as it'll fall back
trying to load modules for the templates in that case, as can be seen
in your log:

> Wed Feb 18 06:58:10 UTC 2015 /sbin/modprobe -q -- crypto-ctr

What's curious, however, that it only tries to load the template for
"ctr", not for "ccm". :/
Are the logs complete? Could you please simplify your /sbin/x/modprobe
wrapper to just output the modprobe call, as Kees suggested?

Also, could you please provide the output of "depmod -n | grep
crypto-"? There should be lines for crypto-ccm and crypto-ctr if you
build them as modules.


Mathias
