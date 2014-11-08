From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] avoid excessive use of socket buffer in skcipher
Date: Sat, 08 Nov 2014 09:44:02 +0100
Message-ID: <545DD7D2.4010006@gmail.com>
References: <1408960194-11726-1-git-send-email-okozina@redhat.com> <1408960194-11726-2-git-send-email-okozina@redhat.com> <20140904070852.GA2606@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Ondrej Kozina <okozina@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:36887 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaKHIoG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Nov 2014 03:44:06 -0500
Received: by mail-wg0-f53.google.com with SMTP id b13so5362801wgh.12
        for <linux-crypto@vger.kernel.org>; Sat, 08 Nov 2014 00:44:05 -0800 (PST)
In-Reply-To: <20140904070852.GA2606@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/04/2014 09:08 AM, Herbert Xu wrote:
> On Mon, Aug 25, 2014 at 11:49:54AM +0200, Ondrej Kozina wrote:
>> On archs with PAGE_SIZE >= 64 KiB the function skcipher_alloc_sgl()
>> fails with -ENOMEM no matter what user space actually requested.
>> This is caused by the fact sock_kmalloc call inside the function tried
>> to allocate more memory than allowed by the default kernel socket buffer
>> size (kernel param net.core.optmem_max).
>>
>> Signed-off-by: Ondrej Kozina <okozina@redhat.com>
> 
> Patch applied.  Thanks!

Please could you send this also to stable tree?
Upstream commit now is e2cffb5f493a8b431dc87124388ea59b79f0bccb

I think it is the problem in all kernels using large page size and skcipher api.

Thanks,
Milan
