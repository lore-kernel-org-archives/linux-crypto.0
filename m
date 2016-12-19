From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: Test AEAD/authenc algorithms from userspace
Date: Mon, 19 Dec 2016 16:08:11 +0530
Message-ID: <CAFXBA=ma8ZKeFfu-_DS1Nm=k0pwUatSabCmhwwwBMg45epOo_g@mail.gmail.com>
References: <CAFXBA=kStufh3TDe=+qQYmd2tNCj9hgXLUKBeoZHBs2VxRBRbQ@mail.gmail.com>
 <2943969.IiWKeGvEyD@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:33730 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752973AbcLSKiN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Dec 2016 05:38:13 -0500
Received: by mail-qt0-f172.google.com with SMTP id p16so140563438qta.0
        for <linux-crypto@vger.kernel.org>; Mon, 19 Dec 2016 02:38:12 -0800 (PST)
In-Reply-To: <2943969.IiWKeGvEyD@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

TLS default mode of operation is MAC-then-Encrypt for Authenc algos.
Currently framework only supports EtM used in IPSec. User space
programs like openssl cannot use af-alg interface to encrypt/decrypt
in TLS mode.
Are we going to support Mac-then-Encrypt mode in future kernel releases?


Regards
Harsh Jain

On Tue, May 31, 2016 at 12:35 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Dienstag, 31. Mai 2016, 12:31:16 schrieb Harsh Jain:
>
> Hi Harsh,
>
>> Hi All,
>>
>> How can we open socket of type "authenc(hmac(sha256),cbc(aes))" from
>> userspace program.I check libkcapi library. It has test programs for
>> GCM/CCM. There are 3 types of approaches to Authenticated Encryption,
>> Which of them is supported in crypto framework.
>>
>> 1) Encrypt-then-MAC (EtM)
>>      The plaintext is first encrypted, then a MAC is produced based on
>> the resulting ciphertext. The ciphertext and its MAC are sent
>> together.
>> 2) Encrypt-and-MAC (E&M)
>>      A MAC is produced based on the plaintext, and the plaintext is
>> encrypted without the MAC. The plaintext's MAC and the ciphertext are
>> sent together.
>>
>> 3) MAC-then-Encrypt (MtE)
>>      A MAC is produced based on the plaintext, then the plaintext and
>> MAC are together encrypted to produce a ciphertext based on both. The
>> ciphertext (containing an encrypted MAC) is sent.
>
> The cipher types you mention refer to the implementation of authenc(). IIRC,
> authenc implements EtM as this is mandated by IPSEC.
>
> When you use libkcapi, you should simply be able to use your cipher name with
> the AEAD API. I.e. use the examples you see for CCM or GCM and use those with
> the chosen authenc() cipher. Do you experience any issues?
>
> Ciao
> Stephan
