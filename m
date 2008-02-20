From: Patrick McHardy <kaber@trash.net>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Wed, 20 Feb 2008 13:33:22 +0100
Message-ID: <47BC1E12.9050201@trash.net>
References: <E1JRLsx-0003Yz-00@gondolin.me.apana.org.au> <47BB036D.7090701@trash.net> <20080220005329.GA21565@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, johnpol@2ka.mipt.ru
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from viefep20-int.chello.at ([62.179.121.40]:44752 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbYBTMdk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Feb 2008 07:33:40 -0500
In-Reply-To: <20080220005329.GA21565@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> On Tue, Feb 19, 2008 at 05:27:25PM +0100, Patrick McHardy wrote:
>> Yes, probably. So I take it the assumption in HIFN that the
>> sg-list length matches req->nbytes is incorrect?
> 
> Where were you seeing the discrepancy? If it's at the point of
> entry into the HIFN code then the bug is further up.  If it's
> within the HIFN code then I don't know where 12 came from either
> since the ICV is not visible to it.


I saw the discrepancy between the elen value used
for aead_request_set_crypt() in esp_input() and the
req->nbytes value seen in hifn_setup_session().
