From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: Re: [PATCH 0/2] Add TLS record layer encryption module
Date: Fri, 1 Aug 2014 11:24:35 +0300
Message-ID: <53DB4EC3.3080507@freescale.com>
References: <1406626353-23309-1-git-send-email-cristian.stoica@freescale.com>
 <53DAA031.30405@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>
To: Andy Lutomirski <luto@amacapital.net>,
	<herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53DAA031.30405@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>> This set of patches introduces support for TLS 1.0 record layer
>> encryption/decryption with a corresponding algorithm called
>> tls10(hmac(<hash>),cbc(<cipher>)).
>>
>> Similarly to authenc.c on which it is based, this module mixes the base
>> algorithms in software to produce an algorithm that does record layer
>> encryption and decryption for TLS1.0.
>> Any combination of hw and sw base algorithms is possible, but the purpose
>> is to take advantage of hardware acceleration for TLS record layer offloading
>> when hardware acceleration is present.
> 
> What is this used for?  AF_ALG?  I find it hard to believe that the
> kernel will ever want to use this internally.

Yes, AF_ALG is what we have in mind.

Cristian S.
