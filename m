Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:40572 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728733AbeLML6P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 06:58:15 -0500
Date: Thu, 13 Dec 2018 14:58:12 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Tudor.Ambarus@microchip.com
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org
Subject: Re: [RFC PATCH] akcipher: Introduce verify2 for public key algorithms
Message-ID: <20181213115811.22ebsv6y6vqclfrz@sole.flsd.net>
References: <20181211165938.1150-1-vt@altlinux.org>
 <b2e6060c-1e2a-c2c5-0484-715646d16201@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <b2e6060c-1e2a-c2c5-0484-715646d16201@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tudor,

On Thu, Dec 13, 2018 at 10:26:53AM +0000, Tudor.Ambarus@microchip.com wrote:
> 
> On 12/11/2018 06:59 PM, Vitaly Chikunov wrote:
> > Current akcipher .verify() just decrypts signature to uncover message
> > hash, which is then verified in upper level public_key_verify_signature
> > by memcmp with the expected signature value, which is never passed into
> > verify().
> > 
> > This approach is incompatible with ECDSA algorithms, because, to verify
> 
> I would love to have ECDSA in kernel but unfortunately it hasn't reached kernel
> because there is no in-kernel user for it. Do we have an agreement that we will
> add support for it? If not, who will benefit of these patches?

I will post patchset for EC-RDSA support (which is slightly different from
ECDSA, but is the same algorithm family). This is intended for use in IMA.

Even though EC-RDSA is different from ECDSA it will require the same changes
that I propose in these RFCs. Basically, after EC-RDSA is implemented and
hooked into IMA it will be much easier to implement ECDSA.

An additional use case is future possibility to implement other signature
schemes out of tree, which is currently not possible because API is very
RSA-centric.

Thanks,

> 
> Thanks,
> ta
