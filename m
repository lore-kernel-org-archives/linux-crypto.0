From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Wed, 23 May 2007 12:03:54 +0400
Message-ID: <20070523080354.GA19665@2ka.mipt.ru>
References: <20070522125828.GB8424@2ka.mipt.ru> <20070522151919.GB32493@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:58346 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127AbXEWIEI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 May 2007 04:04:08 -0400
Content-Disposition: inline
In-Reply-To: <20070522151919.GB32493@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 22, 2007 at 05:19:19PM +0200, Sebastian Siewior (linux-crypto@ml.breakpoint.cc) wrote:
> * Evgeniy Polyakov | 2007-05-22 16:58:29 [+0400]:
> 
> >Current driver only supports AES ECB encrypt/decrypt, since I do not 
> >know how to detect operation mode in runtime (a question).
> Take a look on my skeleton driver (posted just a few seconds ago). It
> should solve your problem here.

It does not - your code only supposed to work with ecb, since it is what
was requested during initialization time. This new scheme with templates
helps alot for ciphers/crypto modes which do not support several
templates, so I used old scheme with 'cipher' only template, not
'ecb(cipher)', 'cbc(cipher)' and so on.

And, btw, do not use mutex in encryption path, it is not supposed to
sleep in ipsec.

HIFN supports at least 12 different ciphers/mode (3des, des and aes,
each one with 4 modes), so it is not a good idea to put them all into
separated structures, so I rised a question about it.

> Sebastian

-- 
	Evgeniy Polyakov
