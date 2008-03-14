From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC] [crypto] padlock-AES, use generic setkey function
Date: Fri, 14 Mar 2008 15:16:44 +0100
Message-ID: <20080314141644.GB30663@Chamillionaire.breakpoint.cc>
References: <1203850864-16681-1-git-send-email-sebastian@breakpoint.cc> <1203850864-16681-3-git-send-email-sebastian@breakpoint.cc> <47D99F62.7010100@the2masters.de> <20080314114407.GA30663@Chamillionaire.breakpoint.cc> <47DA7443.1090508@the2masters.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Michal Ludvig <michal@logix.cz>
To: Stefan Hellermann <stefan@the2masters.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33079 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753971AbYCNOQr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Mar 2008 10:16:47 -0400
Content-Disposition: inline
In-Reply-To: <47DA7443.1090508@the2masters.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Stefan Hellermann | 2008-03-14 13:49:07 [+0100]:

>Sebastian Siewior schrieb:
>
>I used cryptsetup with -s 256, so the cbc and lrw tests should be valid.
>
>The tcrypt test succeeds, there's no difference in the dmesg-output with or without
>padlock-aes loaded. I haven't checked the results with an unpatched kernel yet.
Excellent, thanks a lot.

 Sebastian
