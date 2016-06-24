From: Gary R Hook <ghook@amd.com>
Subject: Re: Encryption output buffer description in algif_aead.c file
Date: Fri, 24 Jun 2016 07:44:49 -0500
Message-ID: <576D2B41.40801@amd.com>
References: <CAFXBA==72cGgAGMjKu7_yCiFuROVYZ4L5s_V5kfrVF=dT=pPkw@mail.gmail.com>
 <3088643.1BKRPXOEZ9@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>,
	Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0095.outbound.protection.outlook.com ([157.56.110.95]:11712
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751834AbcFXMpE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 08:45:04 -0400
In-Reply-To: <3088643.1BKRPXOEZ9@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/24/2016 07:01 AM, Stephan Mueller wrote:
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

If testmgr.c is any model, the caller is expected to populate the 
destination
buffer with the AAD. Is my understanding correct? And should this 
comment clarify
that point: i.e. the length of the destination is the sum of the lengths 
of the
aad + ciphertext + tag?

Gary
