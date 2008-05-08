From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC, TCRYPT]: Catch cipher destination memory corruption
Date: Thu, 08 May 2008 12:27:55 +0200
Message-ID: <4822D5AB.9040401@trash.net>
References: <E1Jtz38-0000J0-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61131 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759216AbYEHK2b (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 May 2008 06:28:31 -0400
In-Reply-To: <E1Jtz38-0000J0-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> Hi Patrick:
> 
> Patrick McHardy <kaber@trash.net> wrote:
>> This patch adds checks to tcrypt to catch destination buffer
>> corruption for cipher tests across pages, which was useful
>> while fixing corruption caused by the HIFN driver.
> 
> This seems like a pretty useful check.


Would you like me to do any changes? Otherwise, please feel free
to apply :)
