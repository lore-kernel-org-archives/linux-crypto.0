From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: Test AEAD/authenc algorithms from userspace
Date: Tue, 31 May 2016 14:10:20 +0530
Message-ID: <CAFXBA=mHcTorQaTfgkk-gfXf0LSae1hetPe=pJ_05sHJydaJcw@mail.gmail.com>
References: <CAFXBA=kStufh3TDe=+qQYmd2tNCj9hgXLUKBeoZHBs2VxRBRbQ@mail.gmail.com>
	<2943969.IiWKeGvEyD@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:32896 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842AbcEaIkV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 04:40:21 -0400
Received: by mail-oi0-f54.google.com with SMTP id k23so292522391oih.0
        for <linux-crypto@vger.kernel.org>; Tue, 31 May 2016 01:40:21 -0700 (PDT)
In-Reply-To: <2943969.IiWKeGvEyD@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

You means to say like this

./kcapi -x 2 -e -c "authenc(hmac(sha1),cbc(aes))" -p
48981da18e4bb9ef7e2e3162d16b19108b19050f66582cb7f7e4b6c873819b71 -k
8d7dd9b0170ce0b5f2f8e1aa768e01e91da8bfc67fd486d081b28254c99eb423 -i
7fbc02ebf5b93322329df9bfccb635af -a afcd7202d621e06ca53b70c2bdff7fb2
-l 16f4a3eacfbdadd3b1a17117b1d67ffc1f1e21efbbc6d83724a8c296e3bb8cda0c44

It gives following error with kernel 4.5.2
Symmetric cipher setkey failed
Failed to invoke testing



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
