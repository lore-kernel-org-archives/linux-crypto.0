From: Patrick McHardy <kaber@trash.net>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Fri, 22 Feb 2008 14:53:12 +0100
Message-ID: <47BED3C8.1050909@trash.net>
References: <20080220005329.GA21565@gondor.apana.org.au> <47BC1E12.9050201@trash.net> <20080220172620.GE27726@gondor.apana.org.au> <20080221091012.GA21291@2ka.mipt.ru> <20080221141013.GB32494@gondor.apana.org.au> <20080221141803.GB24779@2ka.mipt.ru> <47BD88BD.2030305@trash.net> <20080221143721.GB9140@2ka.mipt.ru> <47BD8D93.3070906@trash.net> <47BD98F2.4080305@trash.net> <20080222124211.GA15003@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:4751 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934819AbYBVNxc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Feb 2008 08:53:32 -0500
In-Reply-To: <20080222124211.GA15003@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Evgeniy Polyakov wrote:
> Does this patch  (on top of unpatched tree) helps?
> I can not test it with real hardware, since I'm sicking at home with
> laptop only, but I already know how to make a test case for this problem
> without complex setup, so if it does not work, I will investigate it
> further as soon as be able to move to office with testing machine :)


It still crashed with this patch. Unfortunately I only got
the first line of the Oops over netconsole, and I can't
crash that box too often. I'll see if I can capture the
full oops using serial console sometime tonight.
