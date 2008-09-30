From: "Russ Dill" <russ.dill@gmail.com>
Subject: Re: CTS (cipher text stealing mode) and short packets
Date: Tue, 30 Sep 2008 09:41:04 -0700
Message-ID: <f9d2a5e10809300941m2f63bf4cuc89b2c5f5fe5382@mail.gmail.com>
References: <f9d2a5e10809292008i48e66474hbde8c7723b848c50@mail.gmail.com>
	 <E1KkgHv-00011M-OJ@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kwc@citi.umich.edu, linux-crypto@vger.kernel.org
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:37812 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYI3QlE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Sep 2008 12:41:04 -0400
Received: by wa-out-1112.google.com with SMTP id v27so54230wah.21
        for <linux-crypto@vger.kernel.org>; Tue, 30 Sep 2008 09:41:04 -0700 (PDT)
In-Reply-To: <E1KkgHv-00011M-OJ@gondolin.me.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 30, 2008 at 7:33 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Russ Dill <russ.dill@gmail.com> wrote:
>>
>> I worked with this a bit, and since the IV has to be modified, it was
>> just easier to check for nbytes less than or equal to block size in my
>> own code and then back up src/dest pointers by iv_size and increase
>> the size by iv_size. (My IV is prepended to my data). On decryption I
>> do something similar by adding a buffer for the output of the IV.
>
> I suggest that we fix the CTS algorithm (i.e., give it a block size
> of 1 instead of whatever it is now, plus make it work properly for
> input equal or less than a block), and then implement RFC3962 on
> top of it.
>

I'm just not sure how to best fit that into an API. In the case of
number of bytes being greater than the underlying block size,
everything works "normally". But in the case of the number of bytes
being less than or equal to the block size, the IV sent to the remote
end needs to be modified.
