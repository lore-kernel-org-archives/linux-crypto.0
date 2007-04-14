From: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Sat, 14 Apr 2007 15:15:13 +0200
Message-ID: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com>
References: <38b2ab8a0704130630v4c840bd1w19f2a239f86a93b@mail.gmail.com>
	 <E1HcZud-0006DB-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.224]:5772 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030417AbXDNNPP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Apr 2007 09:15:15 -0400
Received: by nz-out-0506.google.com with SMTP id s1so953405nze
        for <linux-crypto@vger.kernel.org>; Sat, 14 Apr 2007 06:15:14 -0700 (PDT)
In-Reply-To: <E1HcZud-0006DB-00@gondolin.me.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On 4/14/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> It should be easy to restrict a crypto device so that it's used
> by one specific user.  That's why we have generic names ("aes") vs.
> specific ones ("aes-foo").
>
> So if you let the priority user pick "aes-foo" instead of "aes",
> and given that there is a higher priority variant of the generic
> "aes" registered, the system will do exactly what you want.
>

hmm yes indeed it should do the job, but I don't see how you do that.
For example, let say I want to use "aes-foo" with eCryptfs. I can give
a higher priority to "aes-foo" than "aes" one. When eCryptfs asks for
a aes cipher it will pass "aes" name and since "aes-foo" has a higher
priority then the cypto core will return "aes-foo" cipher, right ? But
in this scheme, eCryptfs has not a higher priority than other kernel
users. How can I prevent others to use "aes-foo" ?

Actually I'd like to say "'aes-foo' is a cipher used by one and only
one user". That would allow aes-foo driver to no reload the same key
for each block and to be more efficient for my common case.

thanks
-- 
Francis
