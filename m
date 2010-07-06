From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH]crypto:hifn_795x.c Fix warning: variable 'ctx' set but
 not used
Date: Tue, 06 Jul 2010 10:19:33 -0700
Message-ID: <4C3365A5.5010605@gmail.com>
References: <20100706070355.GA14626@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net, jkosina@suse.cz,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50852 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab0GFRYu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Jul 2010 13:24:50 -0400
In-Reply-To: <20100706070355.GA14626@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> This certainly does not look right! Returning with IRQs disabled
> is considered to be rude.
>
> I believe the right answer is to delete the line initialising ctx.
>
> Thanks,

o.k. hopefully this is correct this time, resent with the following 
change. let me know if it's legit or not..

Justin P. Mattock
