From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: BUG: Seems un-initialed dst pointer received from algif_aead when
 outlen is zero
Date: Tue, 21 Mar 2017 18:53:31 +0530
Message-ID: <CAFXBA==5EOXOJV4UFaG+1AxAmuEo9PzFKsHe25YTMa8LGfKkkQ@mail.gmail.com>
References: <CAFXBA==w7CK_CiiVC37NN8=7p7=a=18sNd5VTnUkDCozrMvT+w@mail.gmail.com>
 <5047201.43uXAH9qJG@positron.chronox.de> <CAFXBA=m10UrBr1qqJ3j9F-hUXL6Bm+iEi6jLLEv9tVmCXc_p1A@mail.gmail.com>
 <3894659.2TbsNqkGul@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35102 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932499AbdCUNXc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Mar 2017 09:23:32 -0400
Received: by mail-qk0-f169.google.com with SMTP id v127so134559830qkb.2
        for <linux-crypto@vger.kernel.org>; Tue, 21 Mar 2017 06:23:32 -0700 (PDT)
In-Reply-To: <3894659.2TbsNqkGul@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 21, 2017 at 5:13 PM, Stephan M=C3=BCller <smueller@chronox.de> =
wrote:
> Am Dienstag, 21. M=C3=A4rz 2017, 11:59:54 CET schrieb Harsh Jain:
>
> Hi Harsh,
>
>> > Executing this command on a 4.9 kernel, I get:
>> >
>> > bin/kcapi -x 2   -c "gcm(aes)" -i 0d92aa861746b324f20ee6b7 -k
>> > f4a6a5e5f2066f6dd9ec6fc5169c29043560ef595c9e81e76f42d29212cc581c -a ""=
 -t
>> > "5f24c68cbe6f32c29652442bf5d483ad" -q ""
>> > EBADMSG
>>
>> Probably because s/w implementation is not trying to access dst sg
>> pointer because there's nothing to copy in destination buffer.  1
>> question If we don't have data to copy to destination buffer what
>> should dst pointer contains?
>
> The dst SGL should simply be discarded by implementations in the case you
> mention above.
>
> The implementation receives the tag size and the supplied input buffer. I=
f
> that input buffer length is equal to the tag length (i.e. no AAD and no
> ciphertext), why would the dst SGL be ever touched during decrytion?

Yes, Driver can figure out when to discard dst SGL but for that Driver
has to put checks before accessing dst SGL. Isn't better if AF_ALG
sends NULL for dst SGL.

>
> Ciao
> Stephan
