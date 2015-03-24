From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCHv2] arm: crypto: Add optimized SHA-256/224
Date: Tue, 24 Mar 2015 12:40:50 +0100
Message-ID: <CAKv+Gu9RtkorW1qiX4xohxDYQ-SfbFnY0NgeiXCxdZ1xx6SA9w@mail.gmail.com>
References: <20150316154835.GA31336@google.com>
	<20150323135009.GB820@google.com>
	<CAKv+Gu8qcVVTqy6Fd8PMA8ZTxiMssKz+TbMQW=fAhCBpUH2jTw@mail.gmail.com>
	<20150324113502.GE11405@gondor.apana.org.au>
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
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33218 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbbCXLku (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Mar 2015 07:40:50 -0400
Received: by iecvj10 with SMTP id vj10so57878822iec.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2015 04:40:50 -0700 (PDT)
In-Reply-To: <20150324113502.GE11405@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24 March 2015 at 12:35, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Mar 23, 2015 at 07:26:03PM +0100, Ard Biesheuvel wrote:
>> (resending due to size bounce)
>
> Aha that's why the patch didn't make it through.  Can it be split
> up?

Not so easily. It consists (among other things) of a .pl file that
generates a .S file, but to prevent introducing a build time
dependency on perl, the .S file is included as a .S_shipped file. That
is the big one.

i suppose we could add the .S_shipped file in a separate patch, but
I'd prefer to keep it as is
