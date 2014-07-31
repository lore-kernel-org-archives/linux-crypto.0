From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 0/2] Add TLS record layer encryption module
Date: Thu, 31 Jul 2014 12:59:45 -0700
Message-ID: <53DAA031.30405@amacapital.net>
References: <1406626353-23309-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
To: Cristian Stoica <cristian.stoica@freescale.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33143 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaGaT7t (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Jul 2014 15:59:49 -0400
Received: by mail-pa0-f53.google.com with SMTP id rd3so4285601pab.12
        for <linux-crypto@vger.kernel.org>; Thu, 31 Jul 2014 12:59:49 -0700 (PDT)
In-Reply-To: <1406626353-23309-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/29/2014 02:32 AM, Cristian Stoica wrote:
> Hi all,
> 
> This set of patches introduces support for TLS 1.0 record layer
> encryption/decryption with a corresponding algorithm called
> tls10(hmac(<hash>),cbc(<cipher>)).
> 
> Similarly to authenc.c on which it is based, this module mixes the base
> algorithms in software to produce an algorithm that does record layer
> encryption and decryption for TLS1.0.
> Any combination of hw and sw base algorithms is possible, but the purpose
> is to take advantage of hardware acceleration for TLS record layer offloading
> when hardware acceleration is present.

What is this used for?  AF_ALG?  I find it hard to believe that the
kernel will ever want to use this internally.

--Andy
