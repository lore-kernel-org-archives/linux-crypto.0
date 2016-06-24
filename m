From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Encryption output buffer description in algif_aead.c file
Date: Fri, 24 Jun 2016 17:24:02 +0530
Message-ID: <CAFXBA==72cGgAGMjKu7_yCiFuROVYZ4L5s_V5kfrVF=dT=pPkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35809 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbcFXLyE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 07:54:04 -0400
Received: by mail-oi0-f67.google.com with SMTP id d132so17709022oig.2
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jun 2016 04:54:03 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

It seems now AEAD encryption operation also returns AAD to user space
in output buffer. Following comment in aead_recvmsg() needs updation:

/*
373          * AEAD memory structure: For encryption, the tag is appended to the
374          * ciphertext which implies that the memory allocated for
the ciphertext
375          * must be increased by the tag length. For decryption, the tag
376          * is expected to be concatenated to the ciphertext. The plaintext
377          * therefore has a memory size of the ciphertext minus the
tag length.
378          *
379          * The memory structure for cipher operation has the following
380          * structure:
381          *      AEAD encryption input:  assoc data || plaintext
382          *      AEAD encryption output: cipherntext || auth tag
383          *      AEAD decryption input:  assoc data || ciphertext || auth tag
384          *      AEAD decryption output: plaintext
385          */


Regards
Harsh Jain
