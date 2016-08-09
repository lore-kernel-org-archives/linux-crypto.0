From: Stephan Mueller <smueller@chronox.de>
Subject: Re: RSA key size not allowed in FIPS
Date: Tue, 09 Aug 2016 16:29:37 +0200
Message-ID: <2825660.AnRQGUh0XD@tauon.atsec.com>
References: <D3CF4E8C.2883%tsarangi@trustwave.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tapas Sarangi <TSarangi@trustwave.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34398 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbcHIO3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 10:29:40 -0400
In-Reply-To: <D3CF4E8C.2883%tsarangi@trustwave.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 9. August 2016, 14:10:33 CEST schrieb Tapas Sarangi:

Hi Tapas,

> Hello,
> 
> I am using vanilla kernel-4.7 source. It crashes with the following when
> booted with ³fips=1 boot=/dev/sda1² option at the kernel command line
> argument.

The kernel only allows 2k and 3k RSA keys in FIPS mode. Please check your RSA 
key used for signatures.

                /* In FIPS mode only allow key size 2K & 3K */
                if (n_sz != 256 && n_sz != 384) {
                        pr_err("RSA: key size not allowed in FIPS mode\n");
                        return -EINVAL;
                }

Ciao
Stephan
