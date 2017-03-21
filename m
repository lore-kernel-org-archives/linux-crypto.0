From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: BUG: Seems un-initialed dst pointer received from algif_aead when
 outlen is zero
Date: Tue, 21 Mar 2017 16:29:54 +0530
Message-ID: <CAFXBA=m10UrBr1qqJ3j9F-hUXL6Bm+iEi6jLLEv9tVmCXc_p1A@mail.gmail.com>
References: <CAFXBA==w7CK_CiiVC37NN8=7p7=a=18sNd5VTnUkDCozrMvT+w@mail.gmail.com>
 <5047201.43uXAH9qJG@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34157 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752227AbdCULav (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Mar 2017 07:30:51 -0400
Received: by mail-qk0-f196.google.com with SMTP id v127so21606093qkb.1
        for <linux-crypto@vger.kernel.org>; Tue, 21 Mar 2017 04:30:45 -0700 (PDT)
In-Reply-To: <5047201.43uXAH9qJG@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 21, 2017 at 3:34 PM, Stephan M=C3=BCller <smueller@chronox.de> =
wrote:
> Am Dienstag, 21. M=C3=A4rz 2017, 07:13:53 CET schrieb Harsh Jain:
>
> Hi Harsh,
>
>> Hi,
>>
>> For tag only AEAD decrypt operation(Zero length Payload). The dst sg
>> list pointer panic with general protection fault. I think it should be
>> NULL when output buffer is supposed to be empty.
>>
>> Kcapi command to re-produce the issue
>>
>> ./kcapi -x 2   -c "gcm(aes)" -i 0d92aa861746b324f20ee6b7 -k
>> f4a6a5e5f2066f6dd9ec6fc5169c29043560ef595c9e81e76f42d29212cc581c -a ""
>> -t "5f24c68cbe6f32c29652442bf5d483ad" -q ""
>>
>> Its decrypt operation. Expected result should be EBADMSG.
>
> Executing this command on a 4.9 kernel, I get:
>
> bin/kcapi -x 2   -c "gcm(aes)" -i 0d92aa861746b324f20ee6b7 -k
> f4a6a5e5f2066f6dd9ec6fc5169c29043560ef595c9e81e76f42d29212cc581c -a "" -t
> "5f24c68cbe6f32c29652442bf5d483ad" -q ""
> EBADMSG

Probably because s/w implementation is not trying to access dst sg
pointer because there's nothing to copy in destination buffer.  1
question If we don't have data to copy to destination buffer what
should dst pointer contains?

>
> There is no GP or other error. Can you please provide some details about =
your
> system? I.e. which kernel version and what cipher implementation resolves=
 to
> gcm(aes)?

I tried with 4.10.13. It's with gcm(aes-chcr). changes which trigger
issue is not submitted to community yet.

>
> Thanks
>
> Ciao
> Stephan
