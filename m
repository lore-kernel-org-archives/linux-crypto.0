From: Stephan Mueller <smueller@chronox.de>
Subject: Re: RSA key size not allowed in FIPS
Date: Tue, 09 Aug 2016 16:55:52 +0200
Message-ID: <21317106.O9C0GvNNQc@positron.chronox.de>
References: <D3CF4E8C.2883%tsarangi@trustwave.com> <2825660.AnRQGUh0XD@tauon.atsec.com> <D3CF5455.2887%tsarangi@trustwave.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tapas Sarangi <TSarangi@trustwave.com>, dhowells@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34404 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194AbcHIO4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 10:56:00 -0400
In-Reply-To: <D3CF5455.2887%tsarangi@trustwave.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 9. August 2016, 14:39:03 CEST schrieb Tapas Sarangi:

Hi Tapas, David,

> Hi Stephan,
> 
> If I understand this correctly, this (CONFIG_MODULE_SIG_HASH=“sha256")
> tells about the key size used.
> I am using “sha256”. Initially, I was using “sha512” which I thought could
> be causing problem, but I am getting same error when change it to
> “sha256”.
> 
> [root@localhost ~]# grep MODULE_SIG /boot/config-4.7.0-1.tos2_5
> 
> CONFIG_MODULE_SIG=y
> # CONFIG_MODULE_SIG_FORCE is not set
> CONFIG_MODULE_SIG_ALL=y
> # CONFIG_MODULE_SIG_SHA1 is not set
> # CONFIG_MODULE_SIG_SHA224 is not set
> CONFIG_MODULE_SIG_SHA256=y
> # CONFIG_MODULE_SIG_SHA384 is not set
> # CONFIG_MODULE_SIG_SHA512 is not set
> CONFIG_MODULE_SIG_HASH="sha256"
> CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"

It is rather the question how signing_key.pem is generated.

Do you have the file certs/x509.genkey? If yes, what is the default_bits 
value?

David, the x509.genkey file seems to generate a 4k RSA key per default. This 
will cause a panic with fips=1 as only 2k and 3k keys are allowed.

Ciao
Stephan
