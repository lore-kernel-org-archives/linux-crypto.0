From: "Loc Ho" <lho@amcc.com>
Subject: RE: IPSec ESP Authenc Offload
Date: Wed, 28 May 2008 09:42:47 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D604814F16@SDCEXCHANGE01.ad.amcc.com>
References: <alpine.LFD.1.10.0805250731530.23219@localhost.localdomain> <20080526112058.GA16525@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D604814C4A@SDCEXCHANGE01.ad.amcc.com> <20080528063434.GA1173@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02-ext1.amcc.com ([198.137.200.73]:10541 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbYE1Qmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 May 2008 12:42:49 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080528063434.GA1173@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

With IPSec ESP Authenc, it is expected that the selected driver
generates "IV" as well as encrypts the data. Our 'hardware' (available
currently), can only handle either no header processing or header
processing (from ESP to IV processing but not individual field
processing). 

For no header processing, we will have to do a lot more work in software
- create a context SA for each requested operation, copy from the
initial context SA, after the operation completed, retrieve the update
IV from context SA, and then write it back to the packet.

For header processing, tell hardware to skip IP header (- ESP header -
IV), write SPI, SEQ, and IV. (This is all handled by hardware with the
exception of compute the skipped length of IP header.) It does write the
SPI and SEQ again but it is handled by the hardware and with the same
value as software. Alternatinely, we can parse the IP header for the IP
header length but this information is already available in IPSec statck,
would not work with UDP encapsulation, and would be cleaner.

-Loc 

-----Original Message-----
From: linux-crypto-owner@vger.kernel.org
[mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Herbert Xu
Sent: Tuesday, May 27, 2008 11:35 PM
To: Loc Ho
Cc: linux-crypto@vger.kernel.org
Subject: Re: IPSec ESP Authenc Offload

On Tue, May 27, 2008 at 11:29:22AM -0700, Loc Ho wrote:
> 
> For authenc hardware offload outbound, we need to know the whole ESP 
> header length - IP header + UDP header + ESP header + IV. I am 
> thinking adding a field in struct aead_givcrypt_request as below:

Could you please let me know why it needs this information?
Is it doing ESP offload in addition to crypt/hash offload?

Thanks,
--
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au> Home Page:
http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"
in the body of a message to majordomo@vger.kernel.org More majordomo
info at  http://vger.kernel.org/majordomo-info.html
