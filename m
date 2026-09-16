Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51344B827D
	for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 16:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789577172; cv=none; b=uhaTlA95MCW23IPTJQ/f4rqyKbMNtW8C/eZRL+Rk5EYnpjx6rcKk+FuuIiTgwrxiMxer7Q3j6OTxhwicA86r5wRo1I5xmstzRdjwYjjWsYOlEjyi/XZQmDRRd4ec2oYabV+IGqBd68dP7lMDoqnbY1cVEq3If/RaKccVQpkJbCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789577172; c=relaxed/simple;
	bh=qUjUi4OUkxEIztp25vsRitnlL+dXfqSGw1HVgzhiFO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s41rE45wqTK/GkC79ngzAucWymGUzwF+rO0atTQ8UPSx4/bqMUzECmfaJGnvAGsVmSA1kZO6Fz2+BCdAde7KVJH2CmGADn0dgJ+tOlnUsw0hxfTRCD9QVM2jonIJ/bVjRq1oNlVlLxriFwo9xtrQulKqDVLOLxKQw06k3BOvNOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EPKDZ+PL; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EPKDZ+PL"
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d43ac6089so12459317b3.1
        for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 09:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789577157; x=1790181957; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Bn6aZ1lxwJ4I9Ak9bkD3kswRMqJ+xZxBaB9EJrANxpc=;
        b=EPKDZ+PLK5/qV2BV9dlC+vUbDDr8CnTKrtN0betFSOYS+eL8+V5Bv3HIVcBBw8nZkG
         XvhCJX/4FvNyMkMAzvXNG0dhRvApwgrvst//XT2eqy5l1sQrgagon4+ITro8R827A2j6
         mTo2KPv7QWxuhHJ6H82l+G971tl2EeL4s5RaKmnWNey10/zDsUK2xJHi39q2qyID6xKE
         x0hbedXU8yudpc43hhJaA7YZok0lfhP/R1VizEnTiHBod/wEQ98gbTzxZ77k+H3nPJ+X
         mRBqkaFQ/zLCAKIdQFEEpfiMGm6RE9Iu7pjuL6NHvWjDy3fjWAlVKa65s1UCdr7v9ifJ
         q7Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789577157; x=1790181957;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bn6aZ1lxwJ4I9Ak9bkD3kswRMqJ+xZxBaB9EJrANxpc=;
        b=n4b22TNzb5Xkxji9oNKl9EEremgKN3k/hIWpiMfOL7nRHzfZWyXD9IYagUkucUoMiQ
         i24Kqpikb2cBqfYgNMrAcR9/T+znnsBfrNO/wg4eEfcrEl3zjQpR2CudzjtD0ZgeHQwq
         yQKw3FOncMDw7ONdYduzjFkerxNpQgQu5rKYAt+AxTa7+UaIrdASZiBoeHZCrARECpPQ
         1Q2Lf4bYp1gkcQEDW22u/ORIZYh0l9bnGefkSJQeBywax1UPIb0OEM/F3NkeEJ1bqMWY
         M4BtuY0g3On2YSCJrEteQeH4HY89wwGZAdeFKqN7NiL0sJi3abgGuADugebm+G/oWP7G
         lzXw==
X-Forwarded-Encrypted: i=1; AKwUvBxqh09I5N1yKPcHcmAdTmP8UYv4f8jvpnlKQU0saTJnITJAxhcvMGydpAZ9qR7/cqAqzmSDPcDu5V4mYL8=@vger.kernel.org
X-Gm-Message-State: AFuF++nTr/d7iDGvu1Zdz9kZdddGl7fspjy/pOyp8Nzr+ccr8CW+bywK
	MlZMKr7vkiVUuT3Wlf/y0JBog1JBjiEkpLO3dI1lbUPoHASlMKyQKJ74
X-Gm-Gg: AYBFou2DpHxGVHA7oXe8GQ38SFrAv5ucWgV7uYGlZw133JT0Hv8x4LlTZD/Xca2imNW
	DZiVKC8qq6cYi/JgzX0xtjnGYAGnNO1bA/4gYO3Wg26YWCnn2PaHCYbAhLAZTnjh1nWWJDmCSYO
	3A6YnJKwLV23g2exGIcPI3Vm7H7JVz2VpLDbo3kcM2v/b8d9SMvQ74mnylBG0L4++dQl7JgUzFS
	iqpGCJ4MlubHSGJqI7Tt5qP5xuK/s57c/0xzY4cgxCdud6UbEIViZ99OwfmI9/4pYfGZu1ZLR6u
	eHvu+beXCq8CU5Htd+MrkwI6bY2DQYC3UFYkL01cDA2kUPqlBIS4gfedY8c7K12CYQZLGvvuY6X
	3lY+gNjYyc6FbtfbhQyd6teGXu8CoVuLGl7pDKsf6U+xYUON70NDumsOr0MpfNreAV7J4ODoZAX
	vX7KGepKgDnt/IQS5+Sq+p61/t3eGRmM8Yka2WiCv+n5Ed9/RaCs3z0BfFFbMChzvNLA3H0hE6s
	A==
X-Received: by 2002:a05:690e:1501:b0:66f:c1bc:4025 with SMTP id 956f58d0204a3-671632afbedmr1106459d50.82.1789577157100;
        Wed, 16 Sep 2026 09:45:57 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.18])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6715f45f803sm1587709d50.0.2026.09.16.09.45.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 09:45:55 -0700 (PDT)
Message-ID: <157aa2cc-65b3-4d89-aa5e-eccd87296293@gmail.com>
Date: Wed, 16 Sep 2026 12:45:40 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/12] crypto: qce - Fix crypto self-test failures
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
 Thara Gopinath <thara.gopinath@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Stanimir Varbanov <svarbanov@mm-sol.com>,
 Eneas U de Queiroz <cotequeiroz@gmail.com>,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Eric Biggers <ebiggers@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, linux-crypto@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
 <7e1b4800-258b-4410-8e88-2ce49505689e@gmail.com>
 <CAMRc=Mdd-_t4HniR0k-xhyS4aMD1gnqJPYgS2cEY81b0dwDZGA@mail.gmail.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <CAMRc=Mdd-_t4HniR0k-xhyS4aMD1gnqJPYgS2cEY81b0dwDZGA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------3xXgf3kbCf0caq6YE31E0Mh9"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------3xXgf3kbCf0caq6YE31E0Mh9
Content-Type: multipart/mixed; boundary="------------dkM26DHH2Ls9uC8sbskWeJcz";
 protected-headers="v1"; hp="clear"
Message-ID: <157aa2cc-65b3-4d89-aa5e-eccd87296293@gmail.com>
Date: Wed, 16 Sep 2026 12:45:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/12] crypto: qce - Fix crypto self-test failures
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
 Thara Gopinath <thara.gopinath@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Stanimir Varbanov <svarbanov@mm-sol.com>,
 Eneas U de Queiroz <cotequeiroz@gmail.com>,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Eric Biggers <ebiggers@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, linux-crypto@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
 <7e1b4800-258b-4410-8e88-2ce49505689e@gmail.com>
 <CAMRc=Mdd-_t4HniR0k-xhyS4aMD1gnqJPYgS2cEY81b0dwDZGA@mail.gmail.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <CAMRc=Mdd-_t4HniR0k-xhyS4aMD1gnqJPYgS2cEY81b0dwDZGA@mail.gmail.com>

--------------dkM26DHH2Ls9uC8sbskWeJcz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 9/15/26 05:42, Bartosz Golaszewski wrote:
> On Fri, 11 Sep 2026 20:34:39 +0200, Demi Marie Obenour
> <demiobenour@gmail.com> said:
>> On 9/10/26 09:00, Bartosz Golaszewski wrote:
>>> This iteration - in addition to the previous fixes - proposes to spli=
t
>>> the QCE driver into a core part necessary to bind to the QCE DT node =
and
>>> enable runtime power management in order to allow to drop the
>>> interconnect votes, and the crypto part registering the crypto
>>> algorithms. The core module is then enabled in arm64 defconfig while =
the
>>> crypto part stays disabled by default.
>>>
>>> The QCE hardware crypto engine has several limitations that cause it =
to
>>> produce incorrect results or stall on certain inputs. This series fix=
es
>>> several bugs and adds workaround allowing the deiver to pass crypto
>>> self-tests.
>>>
>>> The failures addressed are:
>>>
>>> - HMAC self-test failures for empty messages
>>> - AES-XTS returning success on zero-length input (should be -EINVAL)
>>> - AES-CTR: partial final block causes the engine to stall, output IV
>>>   derivation was incorrect
>>> - AES-XTS with key1 =3D=3D key2 is not supported by the CE
>>> - AES-CCM: partial final block and fragmented payload both stall the
>>>   engine
>>>
>>> All fixes were tested on an SM8650 QRD board with
>>> CONFIG_CRYPTO_SELFTESTS=3Dy and CONFIG_CRYPTO_SELFTESTS_FULL=3Dy.
>>>
>>> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.=
com>
>> For stable, would it be better to not register the algorithms, thus
>> preventing their use?  Another option would be to replace the whole
>> driver with an always-on stub driver that just does power management.
>=20
> A module parameter called: really_register_algos that's disabled by def=
ault?
>=20
> Bart

Works for me!  If you add that and fix the tests, go ahead and revert
my patch that marked it as BROKEN.  I suggest reverting the defconfig
changes too, for power management reasons.

While the driver is buggy, you might want to add a kernel taint if
the option is set.  There's precedent for that in other parts of the
kernel.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------dkM26DHH2Ls9uC8sbskWeJcz--

--------------3xXgf3kbCf0caq6YE31E0Mh9
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmqqx78ACgkQszaHOrMp
8lOXMg//YUoYq1jOWJhfaYWrvjJUWr4wIsMXxR7r4HrvqRlmSA7MysXs6nyT2/YS
0jq8PO5/hR7WNnQIKLnWOvCuVJAvftfLKXla2X2W+PUdjP6o7Z1B9w087OGk9RWL
iPMCo8p4RkK0m+eJs4FNBLV71Xi24ivv0/2o2ixyJSOH939/Xa8x3ndW3SGajA9v
ErJFDlD0nIpDNVk4lY/meOVy1Na/JTujjboJBcqqlkQcfATgqNkPepwqJCnYbe6w
SeqfPMOlG7LqzBU7FL7ZIbo5sRBLqU1qmAQ4qlVyRcvr3nuNsHku2u8/kMNFLB4n
cxM+PwZ+5LPhV50Cic/INKASvblYZ7sGkFMgjHP9sSiFctYUPylsm1jbHCl6rt3U
qRWqZURLgrV6AmSbb9wFPkmUeVdHyVq7ZiCzoXtpVTPJ3j8Epdx0B/M7gzTrmF5Q
4VyeVVbEap8sRQrJYmAbZtzlRppZMUQjMi7ZrAvg+r/FmTxcHGknFBZ9UGRgT/7Y
EYMBMuUCOGlos+6qS2PXLV3Onsi+olovwhrR45EffzBTSzopqX6EQDxZcQS04mVa
fJk8NcewRI9vnOoeJR7jsFhUlY0HSo7Xf1LShGGHEKGJB9nrDylccN4HqI/U6lI+
Ued2Zg9qqzbB/KIOZlyMWhn9FulgcVI84kpEsPXlWfTLt+f2NrQ=
=Uo2z
-----END PGP SIGNATURE-----

--------------3xXgf3kbCf0caq6YE31E0Mh9--
