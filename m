From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: Encryption output buffer description in algif_aead.c file
Date: Fri, 24 Jun 2016 17:34:42 +0530
Message-ID: <CAFXBA==QhDAQ87yTWoV_74vzd5bX-TPJ8A2c_gLBsjbFXy7puA@mail.gmail.com>
References: <CAFXBA==72cGgAGMjKu7_yCiFuROVYZ4L5s_V5kfrVF=dT=pPkw@mail.gmail.com>
 <3088643.1BKRPXOEZ9@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36565 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbcFXMEo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 08:04:44 -0400
Received: by mail-oi0-f42.google.com with SMTP id f189so112196712oig.3
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jun 2016 05:04:44 -0700 (PDT)
In-Reply-To: <3088643.1BKRPXOEZ9@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Yes, I will share the patch.

regards
Harsh Jain



On Fri, Jun 24, 2016 at 5:31 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Freitag, 24. Juni 2016, 17:24:02 schrieb Harsh Jain:
>
> Hi Harsh,
>
>
>> 379          * The memory structure for cipher operation has the following
>> 380          * structure:
>> 381          *      AEAD encryption input:  assoc data || plaintext
>> 382          *      AEAD encryption output: cipherntext || auth tag
>> 383          *      AEAD decryption input:  assoc data || ciphertext || auth
>> tag 384          *      AEAD decryption output: plaintext
>
> Right, it returns AAD prepended to the stated output. Do you want to provide a
> patch?
>
> Ciao
> Stephan
