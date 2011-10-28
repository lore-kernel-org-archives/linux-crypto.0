From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: Hardware acceleration indication in af_alg
Date: Fri, 28 Oct 2011 18:24:46 +0200
Message-ID: <4EAAD74E.7060202@gnutls.org>
References: <20111021132336.GA1080@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Matthias-Christian Ott <ott@mirix.org>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45923 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab1J1QX3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Oct 2011 12:23:29 -0400
Received: by wwe6 with SMTP id 6so6068617wwe.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Oct 2011 09:23:28 -0700 (PDT)
In-Reply-To: <20111021132336.GA1080@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/21/2011 03:23 PM, Herbert Xu wrote:
> Matthias-Christian Ott <ott@mirix.org> wrote:
>> I did some experiments with af_alg and noticed that to be really
>> useful, it should indicate whether a certain algorithm is hardware
>> accelerated. I guess this has to be inferred by the priority of the
>> algorithm could be made available via a read-only socket option. Any
>> thoughts on this?
>>
>> I can imagine, an alternative approach and perhaps better approach
>> would be to measure the speed of the kernel provided algorithm against
>> a software implementation, but there are many other factors that could
>> influence the results. Therefore, it is perhaps better to just make
>> the assumption that hardware acceleration is faster which is made in
>> the kernel anyhow.
> You have to be careful to distinguish between hardware acceleration
> that is directly available to user-space (such as AESNI) and those
> that aren't.

How can this be done? The only driver field that could be used for that
is cra_priority and it seems it typically set to 300 irrespective of
instruction based crypto or external device.

regards,
Nikos
