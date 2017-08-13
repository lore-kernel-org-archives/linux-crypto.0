From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v8 0/4] crypto: add algif_akcipher user space API
Date: Sun, 13 Aug 2017 11:52:00 +0300
Message-ID: <CAOtvUMfcEDmyO976H0g5=s7BacHsxUf+JoPXLc0hGaPs_LduAQ@mail.gmail.com>
References: <26359147.tCiuJ5s8mz@positron.chronox.de> <alpine.OSX.2.21.1708101619530.33607@cjee-mobl1.amr.corp.intel.com>
 <3151047.7kO17u1kNV@tauon.chronox.de> <1E882887-3F56-4A4C-AADF-2F25F4D3A7C9@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Stephan Mueller <smueller@chronox.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:37834 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdHMIwB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Aug 2017 04:52:01 -0400
Received: by mail-yw0-f193.google.com with SMTP id s143so4572135ywg.4
        for <linux-crypto@vger.kernel.org>; Sun, 13 Aug 2017 01:52:01 -0700 (PDT)
In-Reply-To: <1E882887-3F56-4A4C-AADF-2F25F4D3A7C9@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 11, 2017 at 7:05 PM, Marcel Holtmann <marcel@holtmann.org> wrot=
e:
> Hi Stephan,
>
>>> AF_ALG is best suited for crypto use cases where a socket is set up onc=
e
>>> and there are lots of reads and writes to justify the setup cost. With
>>> asymmetric crypto, the setup cost is high when you might only use the
>>> socket for a brief time to do one verify or encrypt operation.
>>
>> To me, the entire AF_ALG purpose is solely to export hardware support to=
 user
>> space. That said, if user space wants an accelerator, a socket would be =
opened
>> once followed by numerous read/write requests.
>>
>> Besides, I am aware of Tadeusz' patch to link algif_akcipher to the keyr=
ing
>> and I planned to port it to the current implementation. But I thought I =
offer
>> a small patch focusing on the externalization of the akcipher API first.
>>
>> I think the keyctl and AF_ALG are no opponents, but rather are orthogona=
l to
>> each other. The statement I made for the KPP AF_ALG RFC applies here too=
:
>>
>> """
>> I am aware and in fact supported development of the DH support in the ke=
ys
>> subsystem. The question will be raised whether the AF_ALG KPP interface =
is
>> superfluous in light of the keys DH support. My answer is that AF_ALG KP=
P is
>> orthogonal to the keys DH support. The keys DH support use case is that
>> the keys are managed inside the kernel and thus has the focus on the
>> key management. Contrary, AF_ALG KPP does not really focus on key manage=
ment
>> but simply externalizes the DH/ECDH support found in the kernel includin=
g
>> hardware acceleration. User space is in full control of the key life cyc=
le.
>> This way, AF_ALG could be used to complement user-space network protocol
>> implementations like TLS or IKE to offload the resource intense DH
>> calculations to accelerators.
>> =E2=80=9C""
>
> we do not need two interfaces for doing the same thing. Especially not on=
e that can not handle hardware backed keys. And more important if you can n=
ot abstract an accelerator that doesn=E2=80=99t expose the private key at a=
ll.

While I don't have anything to contribute to the choice between
keyctl() vs ALG_IF as interfaces for asymmetric  cryptography, I would
like to point out that there is both interest and HW support for
private symmetric key operations as well, for example for storage
encryption via DM-Crypt and fscrypt, so I do hope (and will work on)
adding some sort of HW key support the crypto API, community
acceptance withstanding of course.

So I hope we won't treat the idea of crypto API lack of support for HW
keys as a long standing immutable argument.

Thanks,
Gilad


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
