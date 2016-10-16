From: Markus Heiser <markus.heiser@darmarit.de>
Subject: Re: [PATCH 3/7] crypto: doc - fix source comments for Sphinx
Date: Sun, 16 Oct 2016 15:42:23 +0200
Message-ID: <4AC69E43-A8A9-42D2-B957-9DF89224C8A8@darmarit.de>
References: <2721226.4nLlHD9uQ6@positron.chronox.de> <2601538.cyVHbpjp9L@positron.chronox.de> <0255D43E-2C6A-4630-9F86-9723366188EC@darmarit.de> <2972819.9tl40PCxdP@positron.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:50936 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755915AbcJPNmj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Oct 2016 09:42:39 -0400
In-Reply-To: <2972819.9tl40PCxdP@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Am 16.10.2016 um 15:03 schrieb Stephan Mueller <smueller@chronox.de>:

> Am Sonntag, 16. Oktober 2016, 14:56:49 CEST schrieb Markus Heiser:
> 
> Hi Markus,
> ...
> 
>> compared to DocBook, with sphinx you can use (have to use) the reST markup
>> in source code comments.
>> 
>> Here, the code example is just a (indented) float text and this is
>> why you have to quote the asterisk "\*req,".
> 
> Is there any preferred / suggested way whether to use literal or highlighted 
> (or even my approach on) formatting?

No. IMO the "::" markup for code blocks is a good compromise. It is not 
to verbose and prevents you quoting frequent asterisk in code examples.

--Markus--

> Ciao
> Stephan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
