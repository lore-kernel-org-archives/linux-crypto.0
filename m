From: =?UTF-8?Q?Juan_Pablo_Nari=C3=B1o_Mendoza?= <jnarino@gmail.com>
Subject: Re: AEAD Question
Date: Thu, 27 Oct 2016 10:05:39 +0200
Message-ID: <CAPSqeoJgcUQc=jE5dy_FkFFf69+7F75yTm4ASRMxXR_b501d9g@mail.gmail.com>
References: <CAPSqeoJkTQ72cRaFk+sZGdCELUR6zFBbFdQsZE_B4DF=x374Og@mail.gmail.com>
 <1536924.VKbsE1YqZP@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35473 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941832AbcJ0OfU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2016 10:35:20 -0400
Received: by mail-wm0-f43.google.com with SMTP id e69so38858748wmg.0
        for <linux-crypto@vger.kernel.org>; Thu, 27 Oct 2016 07:35:07 -0700 (PDT)
In-Reply-To: <1536924.VKbsE1YqZP@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Stephan
Thank you for your fast answer

My idea is to do zero copy encryption and the cipher I am using is
authenc(hmac(sha1),cbc(aes).

The layout of my buffer is

espHeader(AD) || IV || plaintext || Integrity (TAG)

As I see it, the SGs do point to the same buffer, but they do not overlap

Below, some parts of my code


// Prepare data
sg_init_table(sg,ARRAY_SIZE(sg));


sg_set_buf(&sg[1],cipherText_p,espHdrLen);
sg_set_buf(&sg[0],cipherText_p+espHdrLen+ivLen,plen+intLen);

// Put plaintext in cipherText + espHdr + ivLen
// put esp header info in ciphertext

req_p =3D aead_givcrypt_alloc(aead_p,GFP_KERNEL);
aead_givcrypt_set_callback(req_p,0,hwencpoc_testCipher_cb,cipherText_p);
aead_givcrypt_set_crypt(req_p,&sg[0],&sg[0],plen,iv_p);
aead_givcrypt_set_assoc(req_p,&sg[1],espHdrLen);
aead_givcrypt_set_giv(req_p,cipherText_p+espHdrLen,0);

ret=3Dcrypto_aead_givencrypt(req_p);


However, when I get the callback, the associated data has been
overwritten (first 8 bytes of the cipherText buffer), and the
integrity is wrong. The IV and the encryption are correct. What I am
doing wrong? Thank you again

Juan

2016-10-26 18:32 GMT+02:00 Stephan Mueller <smueller@chronox.de>:
> Am Mittwoch, 26. Oktober 2016, 18:17:14 CEST schrieb Juan Pablo Nari=C3=
=B1o
> Mendoza:
>
> Hi Juan,
>
>> Sorry in advance for making what shall be a basic question for this
>> list, but I have really ran out of ideas.
>>
>> Can someone explain me please, how does the memory layout and sg lists
>> work for the IPSec case, with generated IV case?
>>
>> As I understand, it is like this (ascii art)
>>
>> AD | IV Space | Plain Text | Auth Tag
>>  ^                   ^
>>
>> asg              sg
>
> The memory layout is correct when using the RFC4106 cipher.
>
> How you partition your physical memory with the SGL is your choice as lon=
g as
> your data in the SGL is lined up as you mentioned above.
>>
>> But I am having the AD overwritten, and the AUTH tag and encryption is
>> not correct? Could someone please point me in the right direction?
>> Thank you again
>
> Maybe the src and dst SGL somehow partially overlap?
>>
>> Regards
>>
>> Juan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-crypto" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Ciao
> Stephan
