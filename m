From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCHv2] arm: crypto: Add optimized SHA-256/224
Date: Tue, 24 Mar 2015 12:57:33 +0100
Message-ID: <CAKv+Gu_T36x=eNfUytT63MDo6qr14izX1V7oAO2yCej+yy=81Q@mail.gmail.com>
References: <20150316154835.GA31336@google.com>
	<20150323135009.GB820@google.com>
	<CAKv+Gu8qcVVTqy6Fd8PMA8ZTxiMssKz+TbMQW=fAhCBpUH2jTw@mail.gmail.com>
	<20150324113502.GE11405@gondor.apana.org.au>
	<CAKv+Gu9RtkorW1qiX4xohxDYQ-SfbFnY0NgeiXCxdZ1xx6SA9w@mail.gmail.com>
	<20150324114606.GA11744@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sami Tolvanen <samitolvanen@google.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andy Polyakov <appro@openssl.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35865 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbbCXL5e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Mar 2015 07:57:34 -0400
Received: by igbud6 with SMTP id ud6so69306598igb.1
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2015 04:57:33 -0700 (PDT)
In-Reply-To: <20150324114606.GA11744@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24 March 2015 at 12:46, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Mar 24, 2015 at 12:40:50PM +0100, Ard Biesheuvel wrote:
>>
>> Not so easily. It consists (among other things) of a .pl file that
>> generates a .S file, but to prevent introducing a build time
>> dependency on perl, the .S file is included as a .S_shipped file. That
>> is the big one.
>>
>> i suppose we could add the .S_shipped file in a separate patch, but
>> I'd prefer to keep it as is
>
> OK then this will have to go up on a website somewhere and then
> the URL can be posted to the list for review.
>

You can pull it from here if you like
https://git.linaro.org/people/ard.biesheuvel/linux-arm.git/shortlog/refs/tags/arm-sha256-neon
(rebased onto your cryptodev-2.6/master branch as of 30 mins ago)

Does that work or you?

Thanks,
Ard.
