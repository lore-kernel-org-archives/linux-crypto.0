From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCHv2] arm: crypto: Add optimized SHA-256/224
Date: Wed, 25 Mar 2015 07:49:56 +0100
Message-ID: <CAKv+Gu8LL4s1fz-VtAthraUrD_9xRCkQ-t_fUTyvHGwFtjmrfw@mail.gmail.com>
References: <20150316154835.GA31336@google.com>
	<20150323135009.GB820@google.com>
	<20150324122702.GJ14457@ns203013.ovh.net>
	<CAKv+Gu-j8m7NAYHL8swjwJ0as6TzNyjqhk0Tp1QhDhH=E78K3Q@mail.gmail.com>
	<20150324130511.GK14457@ns203013.ovh.net>
	<CAKv+Gu8Px6dYKdrVFyh_5WN3sEAGYy0fv0qHONJ5x+68YZjCOQ@mail.gmail.com>
	<CAKv+Gu_4G69JZJPex_=1xOZ4z5Fxtht4YG4G=TnYrkXPuiXvFg@mail.gmail.com>
	<20150324170543.GL14457@ns203013.ovh.net>
	<CAKv+Gu-LL5JzALPqPnxdVqQ7HUwnJZQ3=GzPk_h1KSUJp2SVAw@mail.gmail.com>
	<20150324181759.GA2156@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
	Andy Polyakov <appro@openssl.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Sami Tolvanen <samitolvanen@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34710 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbbCYGt5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Mar 2015 02:49:57 -0400
Received: by iedfl3 with SMTP id fl3so17376486ied.1
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2015 23:49:57 -0700 (PDT)
In-Reply-To: <20150324181759.GA2156@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24 March 2015 at 19:17, Sami Tolvanen <samitolvanen@google.com> wrote:
> On Tue, Mar 24, 2015 at 06:40:29PM +0100, Ard Biesheuvel wrote:
>> @Sami, Andy: we need to respin the whole patch, including updated
>> OpenSSL upstream commit id :-(
>
> Sure, I will send v3 once the changes are in OpenSSL. Thanks for testing!
> Do you still prefer everything in one patch?
>

If it is easily done, you could add the .S_swapped file and the
related Makefile rule in a separate followup patch, yes.
But then, the second one might still be too big ...
