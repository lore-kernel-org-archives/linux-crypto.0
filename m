From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Testing the geode-aes driver with the tcrypt module completely freezes the machine
Date: Fri, 27 Apr 2007 18:10:51 +1000
Message-ID: <20070427081051.GA28960@gondor.apana.org.au>
References: <000601c787e1$e169ff00$1a04010a@V505CP>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: info-linux@geode.amd.com, linux-crypto@vger.kernel.org
To: Martin Schiller <mschiller@tdt.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4108 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754140AbXD0ILR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Apr 2007 04:11:17 -0400
Content-Disposition: inline
In-Reply-To: <000601c787e1$e169ff00$1a04010a@V505CP>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 26, 2007 at 09:04:21AM +0000, Martin Schiller wrote:
> 
> here is what I do:
> 
> - I have an AEWIN CB-6971 with an AMD Geode LX800.
> 
> - Testing with kernel 2.6.21-rc7-git5.
> 
> - When the geode_aes module is loaded and I am loading the tcrypt module,
>   the machine freezes completely.
> 
> - When the geode_aes module is NOT loaded and I am loading the tcrypt
> module,
>   the test works well.
> 
> Has anyone else tried to test the geode-aes driver with the tcrypt module?
> 
> I am also not able to use the geode-aes driver with openswan-2.4.7 on kernel
> 2.6.19 (with patched-in geode driver).

Jordan, do you have any ideas why this is happening?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
