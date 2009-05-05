From: "G.Muruganandam" <gmuruga@gdatech.com>
Subject: Re: talitos_probe hangs
Date: Tue, 05 May 2009 09:39:05 -0700
Message-ID: <200905051641.n45Gfou10608@sierra.gdatech.com>
References: <728619.83165.qm@web50504.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@redhat.com>
To: kishor_ravula@yahoo.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.gdatech.com ([66.237.41.98]:16294 "EHLO
	darwaza.gdatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbZEERFq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 May 2009 13:05:46 -0400
In-Reply-To: <728619.83165.qm@web50504.mail.re2.yahoo.com>
References: <728619.83165.qm@web50504.mail.re2.yahoo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


You may need to use 2.6.27.


At 11:01 PM 5/4/2009, Ravula Kishor wrote:

>Hi,
>
>I am using ltib-20080811 (2.6.25 kernel) . I am porting it to custom 
>board based on mcf5474. I observed that talitos_probe hangs during 
>the kernel initialization.
>
>Is it a known issue.
>
>Appreciate any pointers on this problem.
>
>Thanks,
>Kishor
>
>
>
>
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

