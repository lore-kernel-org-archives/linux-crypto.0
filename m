From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCHv2] arm: crypto: Add optimized SHA-256/224
Date: Tue, 24 Mar 2015 18:17:59 +0000
Message-ID: <20150324181759.GA2156@google.com>
References: <20150316154835.GA31336@google.com>
 <20150323135009.GB820@google.com>
 <20150324122702.GJ14457@ns203013.ovh.net>
 <CAKv+Gu-j8m7NAYHL8swjwJ0as6TzNyjqhk0Tp1QhDhH=E78K3Q@mail.gmail.com>
 <20150324130511.GK14457@ns203013.ovh.net>
 <CAKv+Gu8Px6dYKdrVFyh_5WN3sEAGYy0fv0qHONJ5x+68YZjCOQ@mail.gmail.com>
 <CAKv+Gu_4G69JZJPex_=1xOZ4z5Fxtht4YG4G=TnYrkXPuiXvFg@mail.gmail.com>
 <20150324170543.GL14457@ns203013.ovh.net>
 <CAKv+Gu-LL5JzALPqPnxdVqQ7HUwnJZQ3=GzPk_h1KSUJp2SVAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
	Andy Polyakov <appro@openssl.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35532 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbbCXSSD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Mar 2015 14:18:03 -0400
Received: by wibdy8 with SMTP id dy8so82194814wib.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2015 11:18:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-LL5JzALPqPnxdVqQ7HUwnJZQ3=GzPk_h1KSUJp2SVAw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 24, 2015 at 06:40:29PM +0100, Ard Biesheuvel wrote:
> @Sami, Andy: we need to respin the whole patch, including updated
> OpenSSL upstream commit id :-(

Sure, I will send v3 once the changes are in OpenSSL. Thanks for testing!
Do you still prefer everything in one patch?

Sami
