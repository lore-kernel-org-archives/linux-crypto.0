From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH 0/3] take 2: repurposing blkcipher walk api for aead
Date: Tue, 4 Mar 2014 15:54:53 +0800
Message-ID: <CAKv+Gu9B0qvU2iEVSezF1H=s=n8LsoAngMh_myZP-ptxDdsBSw@mail.gmail.com>
References: <1393910920-5796-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140304074627.GA10695@gondor.apana.org.au>
	<CAKv+Gu9A6PEVE47a3xERzo3J10OP3Qvd3cNFQwWsGkNKwVFchw@mail.gmail.com>
	<20140304075337.GA10810@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42953 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbaCDHyy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Mar 2014 02:54:54 -0500
Received: by mail-lb0-f171.google.com with SMTP id w7so5321506lbi.2
        for <linux-crypto@vger.kernel.org>; Mon, 03 Mar 2014 23:54:53 -0800 (PST)
In-Reply-To: <20140304075337.GA10810@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4 March 2014 15:53, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Mar 04, 2014 at 03:51:11PM +0800, Ard Biesheuvel wrote:
>>
>> Is there anything else required before you can take these patches?
>> Note that the first one should go through the arm64 tree, and may need
>> further review on the arm list as well, but for the first two, it is
>> completely up to you.
>
> OK I'll take the first two right now.  You can add my ack to the
> last patch for arm.
>

Thank you, will do!

-- 
Ard.
