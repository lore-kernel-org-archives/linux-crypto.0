From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Test AEAD/authenc algorithms from userspace
Date: Tue, 31 May 2016 09:05:33 +0200
Message-ID: <2943969.IiWKeGvEyD@tauon.atsec.com>
References: <CAFXBA=kStufh3TDe=+qQYmd2tNCj9hgXLUKBeoZHBs2VxRBRbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35162 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbcEaHFh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 03:05:37 -0400
In-Reply-To: <CAFXBA=kStufh3TDe=+qQYmd2tNCj9hgXLUKBeoZHBs2VxRBRbQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 31. Mai 2016, 12:31:16 schrieb Harsh Jain:

Hi Harsh,

> Hi All,
> 
> How can we open socket of type "authenc(hmac(sha256),cbc(aes))" from
> userspace program.I check libkcapi library. It has test programs for
> GCM/CCM. There are 3 types of approaches to Authenticated Encryption,
> Which of them is supported in crypto framework.
> 
> 1) Encrypt-then-MAC (EtM)
>      The plaintext is first encrypted, then a MAC is produced based on
> the resulting ciphertext. The ciphertext and its MAC are sent
> together.
> 2) Encrypt-and-MAC (E&M)
>      A MAC is produced based on the plaintext, and the plaintext is
> encrypted without the MAC. The plaintext's MAC and the ciphertext are
> sent together.
> 
> 3) MAC-then-Encrypt (MtE)
>      A MAC is produced based on the plaintext, then the plaintext and
> MAC are together encrypted to produce a ciphertext based on both. The
> ciphertext (containing an encrypted MAC) is sent.

The cipher types you mention refer to the implementation of authenc(). IIRC, 
authenc implements EtM as this is mandated by IPSEC.

When you use libkcapi, you should simply be able to use your cipher name with 
the AEAD API. I.e. use the examples you see for CCM or GCM and use those with 
the chosen authenc() cipher. Do you experience any issues?

Ciao
Stephan
