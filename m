From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Encryption output buffer description in algif_aead.c file
Date: Fri, 24 Jun 2016 14:59:04 +0200
Message-ID: <7822072.ReBLfZ8iXg@tauon.atsec.com>
References: <CAFXBA==72cGgAGMjKu7_yCiFuROVYZ4L5s_V5kfrVF=dT=pPkw@mail.gmail.com> <3088643.1BKRPXOEZ9@tauon.atsec.com> <576D2B41.40801@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Harsh Jain <harshjain.prof@gmail.com>, linux-crypto@vger.kernel.org
To: Gary R Hook <ghook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:38176 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbcFXM7M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 08:59:12 -0400
In-Reply-To: <576D2B41.40801@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 24. Juni 2016, 07:44:49 schrieb Gary R Hook:

Hi Gary,

> On 06/24/2016 07:01 AM, Stephan Mueller wrote:
> > Am Freitag, 24. Juni 2016, 17:24:02 schrieb Harsh Jain:
> > 
> > Hi Harsh,
> > 
> >> 379          * The memory structure for cipher operation has the
> >> following
> >> 380          * structure:
> >> 381          *      AEAD encryption input:  assoc data || plaintext
> >> 382          *      AEAD encryption output: cipherntext || auth tag
> >> 383          *      AEAD decryption input:  assoc data || ciphertext ||
> >> auth tag 384          *      AEAD decryption output: plaintext
> > 
> > Right, it returns AAD prepended to the stated output. Do you want to
> > provide a patch?
> 
> If testmgr.c is any model, the caller is expected to populate the
> destination
> buffer with the AAD. Is my understanding correct? And should this
> comment clarify
> that point: i.e. the length of the destination is the sum of the lengths
> of the
> aad + ciphertext + tag?

It may make sense if you would look at libkcapi which handles the input/output 
appropriately. Especially, the kcapi_aead_getdata() function sets up the right 
pointers.

It is correct that the AAD data is taken from the input.

Ciao
Stephan
