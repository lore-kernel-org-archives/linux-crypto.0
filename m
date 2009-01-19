From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: crypto: libcrc32c should select crc32c
Date: Mon, 19 Jan 2009 20:51:49 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901192050550.11601@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901172346500.14505@fbirervta.pbzchgretzou.qr> <20090118053713.GB23663@gondor.apana.org.au> <alpine.LSU.2.00.0901180910390.14063@fbirervta.pbzchgretzou.qr> <20090118204542.GA2978@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33805 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZASTvw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Jan 2009 14:51:52 -0500
In-Reply-To: <20090118204542.GA2978@uranus.ravnborg.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Sunday 2009-01-18 21:45, Sam Ravnborg wrote:
>On Sun, Jan 18, 2009 at 09:14:16AM +0100, Jan Engelhardt wrote:
>> On Sunday 2009-01-18 06:37, Herbert Xu wrote:
>> >On Sat, Jan 17, 2009 at 11:48:42PM +0100, Jan Engelhardt wrote:
>> >>
>> >> Looking at libcrc32c.c shows that it essentially depends on the
>> >> crc32c crypto module, which was not packed into my initramfs image
>> >> by mkinitrd because.. there is no dependency.
>> >
>> >Actually the whole point of doing the crc32c/libcrc32c reversal
>> >was to allow multiple providers of crc32c.  As it stands we have
>> >a generic C version plus an Intel version.[...]
>> >I think a better way of tackling this is to note this information
>> >explicitly in the module.  For example, just like module aliases
>> >we can add explicit module dependencies.
>> 
>> Can we?[...]
>> But in kbuild, this functionality does not seem exported
>> to me as a macro (maybe MODULE_DEPENDS?).
>
>kbuild finds out during modpost what modules depends on what other modules
>and this is used for the dependencies.
>There is no way to control this manually today.

So what will the crypto subsystem try to do then, implementation-wise,
given that kbuild cannot be manually tuned this way?
