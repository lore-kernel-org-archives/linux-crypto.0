Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16A02F12A1
	for <linux-crypto@vger.kernel.org>; Fri, 14 Aug 2026 05:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786685382; cv=none; b=oFlcDWBCcg7bNZ/hudIx2O1m8UOProVLY7/8rtiyPjPDRQ1ZRDL1mPfrWNRyFC9Sr9AHuuaI3MfOyISClZrmKlk6U1D5klEru7IMc6ZWPMWQVFPKgsLKdnK3mbuM3IqnRQK4ptFVaMf/A2w4QhyKL8Ppo4SfXR5jS1B3RYW1xq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786685382; c=relaxed/simple;
	bh=5nGb1HWimcZ0bANvB0d0hNtjQhTI4NyloQ6RR+WQhBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bAMlH9qQXt0jxuXzrItgKUTIbu2sB12+CN65QNvyhrCiTZmiXzs9j8wdQEcE2w316YcGuj8ZXbP9FAT7gwRsIznItpy9VZj7TJJ8OTx7WDoLXONEKKHp6fW3CPpitdnp11LqUCMb/sWOt9qAIJU16fGdxwPqeJrvaFbkemp+hkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SuB6Y2OR; arc=none smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SuB6Y2OR"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-66c711b7f2aso923063d50.3
        for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 22:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786685380; x=1787290180; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iImNcxG8fLabmPC1MwSt+Jl02Q/TG6TAosyGy3jBnk4=;
        b=SuB6Y2ORBC/7DmSf6A7LZcgPmOtrVxa2Ag7OeQfZk+dNhUiaJHvD6fiF/QvhzpKEXf
         5lJZYmHVmHISJ6Z72fp0XFwbmD3TQQTyJ9HOpXLCJgXrIUKUm4POcOzYsCyukoJ3fUQK
         PnUN/Tvqy29KJCbFAA6wjNF3+FWJTqQG5BECqxbXoPadiZZfSA/8pIH9Wrn+gXBy7HBM
         /9NJgCI193vGw3Ga1BbKkcdwc+fYcErM5a2OXsyzLBHniDPQv3HSwkAILX6fy6MOVYJS
         znTZ2XNFEoYEBTP+RK0Z2ueREvELhq+42gc2pK+5D+PgEdr/b/bmSU/hmVHS8ZljeSat
         uvvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786685380; x=1787290180;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iImNcxG8fLabmPC1MwSt+Jl02Q/TG6TAosyGy3jBnk4=;
        b=pK5/ZvOqs/l1iup9PefSQG0cCW76yuMB+t8far0DI5HeJstdW2s7fys98c9S2dMw+Z
         +V14cTOh++6GvOG2qI+DdlD6Ko1E6X8CDktvzRTIjHor1mae/QXEKCI1wxli185L5rU9
         z8mDJunU9HCYDY8dsRE9xHbIJUv9+olODJNaBUIpgpPc8QnXGb0bdXscbuBJATj6XONv
         nLYgRez9ZizdhIKtntKyg8SGgqvakzzHgqZwJvdZKcpHMr1EKGg2MK1OGv7M8jkQF9W3
         E/qwhsHCNegQxctXAc7S9o2XwtH1DK4dD+WgfSbptU2WwPbfxTCq871r8S9e+jvQQ1As
         3B2g==
X-Forwarded-Encrypted: i=1; AHgh+Rro6wkWJJc5RWfUMNfFqBQ996duAR3w1FoIHJ7VQHo3w2GQE5dSzT0g+LeBk8PN7We48fk/5GbA8S6aMtI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw00hhT2SSMMmhm3kxjvNbpYx1ivN81nZJeaSVtfJgihj3E0hck
	Y/R6vBiFEwmcHYnfuVfcl9z4PjF40Txj7oGj8fb2ewussW0Xak7TwgrP
X-Gm-Gg: AR+sD10aa6wKdWI+YIsYyn0afcTYrW0rxsVBvWl/WW84pCuWJzQ3hBxvMs7C5euRiTw
	T8bKe6YBMWdqYqfBICsY1BWM5H992Yl8oeZk7AiVNmVSZwyzzNlAaO9+nRC6gNScgzEkJzIdu0r
	szvq6Qt1DdeS8u42KukLdtD8UJDt5hXW3QXIMbK0+LHWKL/RWJV8peOD+zqU0xPUy5sZCN2zhsX
	+6hlu9HCDkW5y6XecQAMX/GexcKZtPqo8sn/c5kb7I60NpDsl2i2AXs6fFjNAoGXOs8b6R1on5T
	DB2Q08P61RqgkxFs/inn8ya5gRXjAQu+tA8U37JBlFWeVmhA6kdCL8vB6IPtZea1tnaMQM9uulQ
	L9BIAL9n9vDJV83N5ai/cu/3ST/O2E/sSrHx/JOUqxdXS7gHcb8u/Dflp7MR44Nb+h5/BI+kEKs
	/6ZlWZA8SzPtxxdbTSWZ65+d/8zdLfV6Zp7cAi5+2aNNCdWQmFHJfJXICEwx3pu98=
X-Received: by 2002:a05:690e:dc1:b0:668:15aa:4f79 with SMTP id 956f58d0204a3-66c72b20bdcmr1534551d50.2.1786685379829;
        Thu, 13 Aug 2026 22:29:39 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66c79390ae7sm382697d50.20.2026.08.13.22.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2026 22:29:37 -0700 (PDT)
Message-ID: <df2a9e02-0ebe-401a-84b5-b0f404711521@gmail.com>
Date: Fri, 14 Aug 2026 01:29:17 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
To: Eric Biggers <ebiggers@kernel.org>
Cc: Bartosz Golaszewski <brgl@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-msm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Krzysztof Kozlowski <krzk@kernel.org>
References: <e7aeec9b-11aa-4635-bde9-fb8c7ca38260@kernel.org>
 <20260801171242.GA3567@quark>
 <CAMRc=McL5QQRk8C8zzkHm+FUj-SAVi5PLJr2pXo8eNpaxXuALg@mail.gmail.com>
 <20260811224110.GC1905@sol>
 <CAMRc=MfVqphaVsfcmUXjGmu6m+F6nJYXgAPuTVjZBwFnd48BkA@mail.gmail.com>
 <bc95e0b0-2cc5-4ad6-a319-ae4e159b92fe@gmail.com>
 <CAMRc=Mcno_F2UuLXZ3ruaVSbYhssVK90m3KM=+dwskLMSp8TXg@mail.gmail.com>
 <0d2706c6-79fa-40fc-a24a-6d5ffbf02330@gmail.com>
 <20260813201019.GA987015@google.com>
 <b7e697ee-ce3b-4c81-afb8-00205c2997f3@gmail.com>
 <20260813213448.GB987015@google.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260813213448.GB987015@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------nXzoSzcLz1089Ey4q1hbHcJh"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------nXzoSzcLz1089Ey4q1hbHcJh
Content-Type: multipart/mixed; boundary="------------b2lmVs5wJKpQS07vcN45h9uV";
 protected-headers="v1"; hp="clear"
Message-ID: <df2a9e02-0ebe-401a-84b5-b0f404711521@gmail.com>
Date: Fri, 14 Aug 2026 01:29:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
To: Eric Biggers <ebiggers@kernel.org>
Cc: Bartosz Golaszewski <brgl@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-msm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Krzysztof Kozlowski <krzk@kernel.org>
References: <e7aeec9b-11aa-4635-bde9-fb8c7ca38260@kernel.org>
 <20260801171242.GA3567@quark>
 <CAMRc=McL5QQRk8C8zzkHm+FUj-SAVi5PLJr2pXo8eNpaxXuALg@mail.gmail.com>
 <20260811224110.GC1905@sol>
 <CAMRc=MfVqphaVsfcmUXjGmu6m+F6nJYXgAPuTVjZBwFnd48BkA@mail.gmail.com>
 <bc95e0b0-2cc5-4ad6-a319-ae4e159b92fe@gmail.com>
 <CAMRc=Mcno_F2UuLXZ3ruaVSbYhssVK90m3KM=+dwskLMSp8TXg@mail.gmail.com>
 <0d2706c6-79fa-40fc-a24a-6d5ffbf02330@gmail.com>
 <20260813201019.GA987015@google.com>
 <b7e697ee-ce3b-4c81-afb8-00205c2997f3@gmail.com>
 <20260813213448.GB987015@google.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260813213448.GB987015@google.com>

--------------b2lmVs5wJKpQS07vcN45h9uV
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 8/13/26 17:34, Eric Biggers wrote:
> On Thu, Aug 13, 2026 at 05:00:28PM -0400, Demi Marie Obenour wrote:
>> On 8/13/26 16:10, Eric Biggers wrote:
>>> On Thu, Aug 13, 2026 at 03:09:36PM -0400, Demi Marie Obenour wrote:
>>>>> SM8650 with the QCE is FIPS 140-2 certified and apparently this mak=
es
>>>>> a difference. Don't ask me if that makes sense, I don't claim to un=
derstand
>>>>> the legal aspects of it.
>>>>
>>>> That sounds like the kind of thing that would cause someone to use
>>>> a worse implementation of cryptographic algorithms =F0=9F=99=82.
>>>>
>>>> For what it is worth, many common uses of kernel cryptography can't
>>>> use the QCE.  This notably applies to the CSPRNG (/dev/urandom etc),=

>>>> storage encryption, and AF_ALG.  Therefore, I expect that anyone who=

>>>> needs FIPS 140 compliance with Linux needs to ensure that the softwa=
re
>>>> crypto is certified, as that's what actually gets used in most cases=
=2E
>>>
>>> Well there's that, and also the Inline Crypto Engine (which is actual=
ly
>>> being used and is unrelated to QCE) has its own FIPS certification.
>>>
>>> Which upstream kernel feature, if any, is QCE being used with?  I hav=
e
>>> asked this multiple times and still not gotten an answer.
>> Historically AF_ALG has been used to access FIPS-certified crypto
>> from userspace, but that no longer can be used with QCE.  Most kernel
>> features reject CRYPTO_ALG_ASYNC, CRYPTO_ALG_ALLOCATES_MEMORY, or both=
=2E
>> If I exclude tests and fallback paths of other drivers, that leaves
>> crypto/asymmetric_keys/public_key.c (hashing), BPF, MACsec, OpenVPN
>> data channel offload, ecryptfs, Ceph, SMB, IPsec, mac802154, TIPC, TLS=
,
>> and crypto/kpp.c.  AF_ALG only allows offload drivers for cbc(paes),
>> which QCE doesn't implement.  QCE is broken with IPsec and probably
>> some other networking protocols, as it would wind up taking a mutex
>> in softirq context.
>=20
> It's a far more narrow list than even that.  asymmetric_keys uses the
> shash API, so it cannot use QCE.  BPF crypto uses the lskcipher API, so=

> it cannot use QCE.  MACsec uses AES-GCM which QCE driver doesn't have.
> OpenVPN uses AES-GCM or ChaCha20Poly1305, neither of which the QCE
> driver has.  The non-legacy Ceph protocol uses AES-GCM, which again the=

> QCE driver doesn't have.  IPsec does decryption in softirq context,
> which the QCE driver doesn't support.  QCE driver does not implement kp=
p
> algorithms.  SMB, TIPC, TLS, all usually use AES-GCM as well.  Until
> just a couple months ago ksmbd crashed if passed an async algorithm,
> which proves it was never used with QCE.  There is really not much left=
,
> maybe ecryptfs AES-CBC file contents encryption?  But even for that the=

> cra_priority makes it not actually used.
>=20
> But we are going into the weeds here with trying to theorize some way
> the code could theoretically be reached.  It seems it's really just not=
=2E
> Or at least if there is a use it is not upstream and/or is not actually=

> the appropriate code to be using.
At this point I think it is quite clear that the following algorithms
provided by QCE are unusable no matter what userspace does:

- SHA256
- HMAC-SHA256
- AES-XTS
- authenc(hmac(sha256),cbc(aes))

Those should all be deleted as unreachable or unused code.  There are
also a lot of algorithms in other drivers that can also be removed.

If the driver was actually used, I _suspect_ it was by requesting it
explicitly via AF_ALG.  AF_ALG won't let you do that anymore, though.
The other possibilities I can think of are messing with priorities via
NETLINK_CRYPTO or somehow not building any software implementations
with a higher cra_priority than QCE.

Splitting the driver up would be much better than the current status
quo, though.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------b2lmVs5wJKpQS07vcN45h9uV--

--------------nXzoSzcLz1089Ey4q1hbHcJh
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmp+p7kACgkQszaHOrMp
8lO4Ng/+Oat+SL0D3pc+KRTBhovFWMYo6JusJNlUNDqAl2X6LlQuI0BtFeOQ2R0B
Ei4KHe0R3Nv2ucbV52uzM+DaP/CpDPJVCcPZlkjegIQ6om1L1UvBWdJNrN5hdBzk
pmHyWBlZjO+1risApvLyvsfbAJu4UP5iKJ/A2GQ8/86ILNoNuf4XjkftTer156VV
WLRWkLo70FC+y5aqXZis3ca+dRHdwMp9oea45eBe0AAPt69KF5EH/CcoOyjQYYr7
CuhyY03LixxHB/Tp6FiZJpUH/OQhIoZQJSueH4Hp7/sbW5OSZRFKywggi5+IrCOP
HHngA4qycTGcOb/2RIWiDud2ssUWfzCLWoz2fkxkBhzFOTtUAfjBhp7lKRevRFJ2
gNgyuYhrC2Vv0j6d+d0ZRNRKNsLavVw0R2GJtHh10Bn3OMwMOvDexjvT+jrK4y3y
Xgof6cBhyhLCdPU2/jmWhzmITCdo3QzAGisJok1TgcgblmpiVmnWz9w3f1eAPGDS
eS4CjEb2I9XLs+7vj6Avj7c26QiWXYMICNwJA7SfWhRi3PrFQXizN5ZfeVH4HcDW
ym7OdWDBbNeiRdrv4VHpsCYb9ELq5jBkHaBf3G1kbWdM++rlSPI7yFtzmCckwAZR
GIRPq8iTu4vMSfSvs0mt8yMxLJxfebIO+c+Oles0wKwfNt/IyCw=
=69KI
-----END PGP SIGNATURE-----

--------------nXzoSzcLz1089Ey4q1hbHcJh--
