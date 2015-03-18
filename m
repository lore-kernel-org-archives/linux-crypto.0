From: James Hartley <James.Hartley@imgtec.com>
Subject: Re: crypto: img-hash - undefined Kconfig symbols
Date: Wed, 18 Mar 2015 13:02:14 +0000
Message-ID: <CF4C1BA1-5E23-43CE-B66D-99E97AE44571@imgtec.com>
References: <CAD3Xx4Kz0qT+=FKEy8N-rkubSrPAEhmXkTXk1H+-MGJ7BNiGqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "abrestic@chromium.org" <abrestic@chromium.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Paul Bolle <pebolle@tiscali.nl>,
	"Andreas Ruprecht" <rupran@einserver.de>,
	hengelein Stefan <stefan.hengelein@fau.de>
To: Valentin Rothberg <valentinrothberg@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:47508 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbbCRNCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 09:02:17 -0400
In-Reply-To: <CAD3Xx4Kz0qT+=FKEy8N-rkubSrPAEhmXkTXk1H+-MGJ7BNiGqA@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Valentin,


> On 18 Mar 2015, at 01:35, Valentin Rothberg <valentinrothberg@gmail.com> wrote:
> 
> Hi James,
> 
> your commit d358f1abbf71 ("crypto: img-hash - Add Imagination
> Technologies hw hash accelerator") adds two selects on undefined
> Kconfig symbols, namely CRYPTO_ALG_API and CRYPTO_SHA224.
> 
> The first symbols looks like a typo since there is an option
> CRYPTO_ALGAPI defined in crypto/Kconfig.  

Yes, that's a typo - it should be CRYPTO_ALGAPI

> However, I do not find a
> companion for CRYPTO_SHA224.  Is there a patch scheduled somewhere
> that adds this option?

No, I think that option is just incorrect and should be removed.

> 
> I detected your commit in today's Linux next tree by running
> ./scripts/checkkconfigsymbols.py.  Git commit 92503ee4ada1
> ("checkkconfigsymbols.py: make it Git aware") added the functionality
> to check Git commits and diff commits for such undefined symbols.

Great, I'll use it in future. Thanks for the notification. 

> 
> Kind regards,
> Valentin

Herbert: should I send you a patch to address the issues above, or resubmit the series with the fixes incorporated?

Thanks
James 