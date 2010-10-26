From: Mathias Krause <minipli@googlemail.com>
Subject: Re: AES-NI for x86?
Date: Tue, 26 Oct 2010 07:37:36 +0200
Message-ID: <E313D5B3-A29B-4640-9345-D7E7191D589B@googlemail.com>
References: <20101025235003.GA6076@gondor.apana.org.au> <1288056485.2862.330.camel@yhuang-dev>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64631 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0JZFhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Oct 2010 01:37:55 -0400
Received: by fxm16 with SMTP id 16so3714938fxm.19
        for <linux-crypto@vger.kernel.org>; Mon, 25 Oct 2010 22:37:54 -0700 (PDT)
In-Reply-To: <1288056485.2862.330.camel@yhuang-dev>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am 26.10.2010 um 03:28 schrieb Huang Ying:
> Hi, Mathias,
> 
> On Tue, 2010-10-26 at 07:50 +0800, Herbert Xu wrote:
>> Mathias Krause <minipli@googlemail.com> wrote:
>>> Hello list,
>>> 
>>> will there be a 32-bit version of the Intel AES-NI code? I've seen a 32-bit
>>> version in openssl so it should be possible. Not?
>> 
>> It won't exist unless someone writes one.  Are you volunteering? :)
>> 
>> Ccing the author in case there is some reason why it won't work in
>> 32-bit mode.
> 
> It can be done in 32-bit mode. We have not done that simply because we
> still have no time to work on that.
> 
> You are welcome to do that. :)

Oh, well. Not the answer I'd like to hear but I can give it a try. Just give
me some time :)

Best regards,
Mathias