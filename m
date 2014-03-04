From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH 0/3] take 2: repurposing blkcipher walk api for aead
Date: Tue, 4 Mar 2014 15:51:11 +0800
Message-ID: <CAKv+Gu9A6PEVE47a3xERzo3J10OP3Qvd3cNFQwWsGkNKwVFchw@mail.gmail.com>
References: <1393910920-5796-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140304074627.GA10695@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:45778 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528AbaCDHvM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Mar 2014 02:51:12 -0500
Received: by mail-la0-f41.google.com with SMTP id gl10so5478119lab.28
        for <linux-crypto@vger.kernel.org>; Mon, 03 Mar 2014 23:51:11 -0800 (PST)
In-Reply-To: <20140304074627.GA10695@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4 March 2014 15:46, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Mar 04, 2014 at 01:28:37PM +0800, Ard Biesheuvel wrote:
>> I think this is a better approach than the one I proposed before. This time,
>> I have only added a single function specifically for use by aeads:
>>
>> blkcipher_aead_walk_virt_block()
>>
>> which takes an additional aead param which is used to get the ivsize, alignmask
>> and blocksize of the underlying transform.
>
> Looks good to me.  Thanks!

Great! Thank you.

Is there anything else required before you can take these patches?
Note that the first one should go through the arm64 tree, and may need
further review on the arm list as well, but for the first two, it is
completely up to you.

Regards,
Ard.
