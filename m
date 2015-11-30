From: Rameshwar Sahu <rsahu@apm.com>
Subject: Re: [PATCH v2 0/3] dmaengine: Add supports for APM X-Gene SoC CRC32C
 accerlerator driver
Date: Mon, 30 Nov 2015 14:27:34 +0530
Message-ID: <CAFd313yfmA9eWUqTXuPb7w8L7RBLR0zHRqbaRKWkQqH9FUhyEQ@mail.gmail.com>
References: <rsahu@apm.com>
	<1447665169-14003-1-git-send-email-rsahu@apm.com>
	<CAFd313zqimQtG8epeo3U7gzxWRf0hqO4K8hOFy4UK-6pG5GcJg@mail.gmail.com>
	<20151130083950.GA7792@gondor.apana.org.au>
	<CAFd313z2dncWmBQJY48RkReVOhQqLs13UzehwrbizBbputOSEw@mail.gmail.com>
	<20151130085054.GA7928@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: davem@davemloft.net, Vinod Koul <vinod.koul@intel.com>,
	dan.j.williams@intel.com, dmaengine@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	jcm@redhat.com, patches@apm.com, linux-crypto@vger.kernel.org,
	Kaustubh Gondkar <kgondkar@apm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34282 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbbK3I5e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Nov 2015 03:57:34 -0500
Received: by ioir85 with SMTP id r85so166190746ioi.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Nov 2015 00:57:34 -0800 (PST)
In-Reply-To: <20151130085054.GA7928@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Mon, Nov 30, 2015 at 2:20 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Nov 30, 2015 at 02:19:33PM +0530, Rameshwar Sahu wrote:
>>
>> One of our client is using this layer for offloading the crc32c to our
>> dmaengine hw.
>
> Is this going to be merged into the kernel?
I am not sure about it, but as what I thought is Linux kernel supports
many algos in async mode and sync mode, later client has to take care
which one they are going to use.
Any way this offload implementation is specific to Applied Micro
X-Gene SoC, where we have such a dmaengine can do CRC32c.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
