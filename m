From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: VIA Padlock: +30% XTS Performance by using ECB
Date: Wed, 19 May 2010 15:07:14 +1000
Message-ID: <20100519050714.GA22114@gondor.apana.org.au>
References: <20100423154449.GA1138@darkside.12.kls.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:54272 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751341Ab0ESFHT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 01:07:19 -0400
Content-Disposition: inline
In-Reply-To: <20100423154449.GA1138@darkside.12.kls.lan>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mario 'BitKoenig' Holbe <Mario.Holbe@tu-ilmenau.de> wrote:
>
> I have no idea where this should finally be implemented, since it slows
> down XTS on non-accelerated CPUs. Maybe a seperate xts-aes-padlock
> driver would make sense depending on how specific this is to VIA
> Padlock, i.e. how it performs on other non-XTS-capable accelerators.

We can solve that by instantiating both the ECB-based XTS and the
current XTS, but by increasing the current XTS's priority value.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
