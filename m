From: Lee Nipper <lee.nipper@gmail.com>
Subject: Re: [PATCH 1/1] crypto: api.c: doc on crypto_alg_lookup,
 crypto_larval_lookup, and crypto_alg_mod_lookup
Date: Fri, 5 Nov 2010 14:57:04 -0500
Message-ID: <AANLkTi=3kQ=op8wp2XqT2JpVtJUAe6fXrrDxWijsQaPp@mail.gmail.com>
References: <1288980346-15961-1-git-send-email-mark.a.allyn@intel.com>
	<AANLkTik7ttMgG97EOkDK7Cmh=7yUe8eUaTfnCoo12Q_9@mail.gmail.com>
	<8A0E4C92AE2D6D40AF99653191DA32316141414460@rrsmsx501.amr.corp.intel.com>
Reply-To: lee.nipper@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Allyn, Mark A" <mark.a.allyn@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60901 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab0KET5F (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Nov 2010 15:57:05 -0400
Received: by bwz11 with SMTP id 11so3014138bwz.19
        for <linux-crypto@vger.kernel.org>; Fri, 05 Nov 2010 12:57:04 -0700 (PDT)
In-Reply-To: <8A0E4C92AE2D6D40AF99653191DA32316141414460@rrsmsx501.amr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 5, 2010 at 13:36, Allyn, Mark A <mark.a.allyn@intel.com> wrote:
> Can you please explain what larval means in this context? I tried googling it an could not find anything meaningful.
>
> What is the difference between crypto_alg_lookup and crypto_larval_lookup?
>

In the kernel crypto context,
I think larval means that the lookup
may load a module, if necessary, to provide support for the algorithm.

I defer to Herbert Xu for any further explanation.
