From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: Re: [PATCH 2/2] salsa20_i586: Salsa20 stream cipher algorithm (i586 version)
Date: Sat, 8 Dec 2007 11:21:55 +0800
Message-ID: <fd3e431c0712071921g14b9983dl6bfdfe41a3f8852@mail.gmail.com>
References: <fd3e431c0712051231h44c7bc6epa2f526116cf2c47@mail.gmail.com>
	 <20071207092211.GA8496@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Linux Crypto" <linux-crypto@vger.kernel.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.226]:27468 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbXLHDV4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 22:21:56 -0500
Received: by wr-out-0506.google.com with SMTP id c49so759898wra
        for <linux-crypto@vger.kernel.org>; Fri, 07 Dec 2007 19:21:55 -0800 (PST)
In-Reply-To: <20071207092211.GA8496@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Dec 7, 2007 5:22 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> It also prevents a failure if the platform doesn't have salsa20-i586,
> which is the case on my x86-64 :)
If I post the x86-64 version of Bernstein's code, can you help to test
it? :P I don't have an x86-64.

Btw, there is an embarrassing bug in my code. I swapped the src and
dst around. Will post a patch.

Swee Heng
