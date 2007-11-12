From: "Loc Ho" <locnho@sbcglobal.net>
Subject: New Crypto Hardware
Date: Mon, 12 Nov 2007 10:19:49 -0800
Message-ID: <007c01c82558$9d175180$2005420a@amcc.com>
References: <0CA0A16855646F4FA96D25A158E299D603B5A5EB@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:29802 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752473AbXKLS0e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Nov 2007 13:26:34 -0500
In-Reply-To: 
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

I am about to start developing a new device driver for new crypto hardware.
I am thinking of starting with Linux CryptoAPI interface. But I have the
following requirement:

1. Asynchronous encrypt/decrypt
2. Asynchronous hashing
3. Asynchronous combined mode (GCM, CCM, and GMAC) 4.
Asynchronous/synchronous public key accelaration (large vector operation) 5.
Support for additional algorithms - ARC4, Kasumi, AES-XCBC and etc 6. Other
minor offload such as windows check and etc. In fact, it can do packet level
processing as well.

What is the current state of asynchronous hashing? Will AEAD be changed to
make use of asynchronous hashing? Is anyone working on #1 and changing AEAD
to asychronous interface? In addition, most of the existent device driver
only use  synchronous interface. Are there any one changing them to
asynchronous crypto interface - such as NETKEY (Linux IPSec)?

Thanks,
Loc
