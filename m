From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Encryption output buffer description in algif_aead.c file
Date: Fri, 24 Jun 2016 14:01:23 +0200
Message-ID: <3088643.1BKRPXOEZ9@tauon.atsec.com>
References: <CAFXBA==72cGgAGMjKu7_yCiFuROVYZ4L5s_V5kfrVF=dT=pPkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:38170 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbcFXMBb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 08:01:31 -0400
In-Reply-To: <CAFXBA==72cGgAGMjKu7_yCiFuROVYZ4L5s_V5kfrVF=dT=pPkw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 24. Juni 2016, 17:24:02 schrieb Harsh Jain:

Hi Harsh,


> 379          * The memory structure for cipher operation has the following
> 380          * structure:
> 381          *      AEAD encryption input:  assoc data || plaintext
> 382          *      AEAD encryption output: cipherntext || auth tag
> 383          *      AEAD decryption input:  assoc data || ciphertext || auth
> tag 384          *      AEAD decryption output: plaintext

Right, it returns AAD prepended to the stated output. Do you want to provide a 
patch?

Ciao
Stephan
